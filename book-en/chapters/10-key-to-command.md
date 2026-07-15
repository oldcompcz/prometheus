# Chapter 10: From a Spectrum Key to a PROMETHEUS Command

In the previous chapter we watched the editor from above. Its main loop seemed to perform a pleasantly simple action:

```text
read one key
```

That phrase hides an awkward truth. A ZX Spectrum keyboard does not hand a program an ASCII character. The machine presents a matrix of electrical switches. Two keys may be held together. SHIFT keys change the interpretation of the other key. A key may remain physically down for hundreds of processor loops. The editor must decide whether that means one character, a control action, or a stream of repeated actions.

PROMETHEUS turns this untidy physical event into one clean byte.

That byte may mean:

- an ordinary character such as `a`;
- a punctuation mark such as `,`;
- ENTER or backspace;
- an immediate editor control such as cursor-up;
- a compact command token such as `$C1` for `ASSEMBLY`.

This chapter follows that conversion from the keyboard matrix to the command dispatcher. It is a good example of a recurring PROMETHEUS technique: several layers gradually turn machine-specific detail into a small internal language.

## The journey in one picture

A normal editor key travels through these stages:

```text
physical keys
    ↓
Spectrum ROM keyboard scanner
    ↓
raw key index and modifier class
    ↓
PROMETHEUS translation
    ↓
CAPS LOCK and case rules
    ↓
new-key / held-key decision
    ↓
click and repeat delay
    ↓
one normalized byte
```

A command entered with SYMBOL SHIFT may take one additional step:

```text
SYMBOL SHIFT + A at an empty input line
    ↓
letter A
    ↓
set bit 7
    ↓
$C1 command token
    ↓
commandHandlerTable[0]
    ↓
invokeAssembly
```

PROMETHEUS does not carry a large structure describing a key event. It does not return separate fields for “letter,” “modifier,” and “repeat.” By the time `processKey` returns, all of those questions have already been settled.

## Let the ROM scan the matrix

The lowest PROMETHEUS wrapper is `getKeypressCodeOrZero`:

```asm
getKeypressCodeOrZero:
    push hl
    call ROM_KeyboardScanning
    pop hl
    jr z,.filterModifierOnlyKeypress
    xor a
    ret
```

The routine uses the Spectrum ROM's keyboard scanner rather than reimplementing the whole keyboard matrix. That scanner returns two important values:

- `E` identifies the key position;
- `D` describes the modifier state.

The ROM convention is compact, but it is not yet convenient for the editor. It can represent “no key,” an isolated SHIFT key, and combinations involving CAPS SHIFT or SYMBOL SHIFT. PROMETHEUS filters those cases so its caller receives a simple test:

```text
A = 0      no usable key event
A ≠ 0      E and D describe a usable event
```

The arithmetic that follows looks mysterious if read as ordinary subtraction:

```asm
.filterModifierOnlyKeypress:
    ld a,e
    inc e
    ret z
    inc d
    ret nz
    ld a,e
    sub 019h
    ret z
    sub 00fh
    ret
```

It is better to read this as a chain of questions about the ROM's special return values:

```text
Was there no key at all?
Was the result only a modifier?
Was it SYMBOL SHIFT by itself?
Was it CAPS SHIFT by itself?
```

The routine does not need to explain *which* ordinary key was pressed. It merely rejects states that are not useful on their own.

This is the first layer of simplification.

## `processKey` is the real translator

The editor calls `processKey`, not the ROM routine directly.

At the start it waits until `getKeypressCodeOrZero` reports a usable key. It then uses the ROM's key tables for ordinary combinations and a private table for SYMBOL SHIFT punctuation.

The high-level algorithm is approximately:

```text
repeat:
    scan keyboard

    if no usable key:
        wait for a stable release
        clear repeat state
        continue

    translate raw key index and modifier
    apply CAPS LOCK case inversion

    if translated key is invalid:
        continue

    if it is the same held key as before:
        wait until repeat threshold
    else:
        remember it as a new key

    click
    apply initial delay
    return translated byte
```

The important word is *translated*. Repeat handling occurs after the physical event has become the editor's chosen byte. This means that `a`, `A`, cursor-down, and a command token can each repeat according to the same basic mechanism.

## Ordinary keys begin in the ROM tables

PROMETHEUS prepares a pointer just before the ROM key table:

```asm
ld hl,ROM_Key_Tables-1
```

The key index in `E` becomes an offset into that table. The `-1` matches the ROM's one-based index convention.

For an ordinary unshifted key, the code is essentially:

```text
character = ROM_Key_Tables[keyIndex]
```

PROMETHEUS then normalizes alphabetic letters to lower case for ordinary source entry:

```asm
set 5,a
```

In ASCII, upper- and lower-case alphabetic codes differ in bit 5. Setting that bit changes `A` to `a`, `B` to `b`, and so on. It also changes some nonletters, so PROMETHEUS applies the operation only in the branch where the ROM's result is known to be an ordinary character class.

This is a typical Z80 economy. A modern program might call a character-conversion library. PROMETHEUS uses one bit operation because the representation was chosen to make that possible.

## CAPS SHIFT creates editor controls

CAPS SHIFT does more than uppercase a letter.

When it accompanies a digit, PROMETHEUS converts the digit code into a small control value:

```asm
call isNumber
jr nz,.uppercaseCapsShiftLetter
sub 02dh
```

For example, the Spectrum's cursor legends live on number keys. Rather than returning the visible digit, the translator returns one of the editor's compact control codes.

Those codes are handled immediately by the main editor loop or by `updateInputBuffer`. Examples include:

- cursor-left;
- cursor-right;
- cursor-up;
- cursor-down;
- backspace;
- EDIT;
- CAPS LOCK;
- page movement;
- deletion of the active source line.

A CAPS SHIFT letter follows a different path:

```asm
call isLetter
jr nz,.applyCapsLockCaseInversion
res 5,a
```

Clearing bit 5 converts a lower-case letter to upper case.

So CAPS SHIFT is not represented as a separate returned flag. Its meaning has already been folded into the byte returned to the editor.

## PROMETHEUS CAPS LOCK is deliberately unusual

The Spectrum already has familiar case behaviour, but PROMETHEUS adds its own persistent CAPS LOCK state in the operand of `varcCapsLockEnabled`:

```asm
varcCapsLockEnabled:
    ld a,000h
```

After a letter has otherwise been translated, the state may invert its case:

```asm
call isLetter
jr nz,.compareLastPressedKey
ld a," "
xor b
```

The expression looks strange until we notice that ASCII upper- and lower-case letters differ by `$20`, the code for a space. XOR with `$20` flips bit 5.

The state byte is toggled elsewhere between `$00` and `$F7`, not between the more obvious `$00` and `$01`. Only its zero/nonzero quality matters here. The peculiar `$F7` value is inherited from the original implementation.

The result is easiest to state in prose:

> PROMETHEUS first applies the meaning of the physical SHIFT combination, then its own CAPS LOCK may invert the final letter case.

That differs slightly from thinking of CAPS LOCK as merely “hold CAPS SHIFT forever.”

## SYMBOL SHIFT has two personalities

SYMBOL SHIFT normally produces punctuation. PROMETHEUS stores those translations in `symbolCharacters`:

```asm
symbolCharacters:
    defb "*", "^", "[", "&", "%", ">", "}", "/", ",", "-"
    defb "]", "'", "$", "<", "{", "?", ".", "+", 0x7f, "("
    ...
```

The exact order follows the ROM key indices rather than alphabetical or visual order. The table includes punctuation, editing controls, and a few zero entries for combinations PROMETHEUS does not use.

But SYMBOL SHIFT has a second personality: at the start of an otherwise empty edit line, SYMBOL SHIFT plus a letter may produce a command token.

The test is wonderfully small:

```asm
ld hl,inputBufferStart
ld a,(hl)
dec a
jr nz,.standardKeyPlusSSPressed
inc hl
or (hl)
jr nz,.standardKeyPlusSSPressed
```

An empty editor input line begins with:

```text
$01,$00
```

That means “cursor marker, then terminator.”

The code subtracts one from the first byte and ORs the result with the second. Only `$01,$00` makes the final result zero. Thus the special command-token translation is available only at a genuinely empty line.

The translated letter then receives bit 7:

```asm
set 7,a
```

If the underlying letter is `A` through `Z`, this produces `$C1` through `$DA`:

```text
'A' = $41    → $C1
'B' = $42    → $C2
...
'Z' = $5A    → $DA
```

This is not an accident. It gives the command dispatcher a dense 26-entry range indexed directly by the alphabet.

## Why commands are tokens rather than text

Suppose the user presses SYMBOL SHIFT+A.

The input buffer does not receive the eight characters of `ASSEMBLY`. It receives one byte:

```text
$C1
```

When the line is displayed, `displayInputTokenOrCharacter` expands that byte through a self-relative table and prints the visible word.

This has several benefits:

- command entry requires one key combination;
- the input buffer uses one byte rather than a whole word;
- dispatch does not need a string comparison;
- a command can still be followed by ordinary arguments;
- the display can show a full readable command name.

The user's view and the internal representation differ:

```text
screen:       SAVE filename
buffer:       $D3 " filename" $01 $00
```

This is the same design idea we will meet in compressed source records: preserve a readable interface while storing a representation optimized for the machine.

## A few command tokens execute immediately

Not every command waits for ENTER.

During insertion into the edit buffer, `updateInputBuffer` checks four token values:

```asm
cp 0c5h
ret z
cp 0c8h
ret z
cp 0cbh
ret z
cp 0d7h
ret z
```

These are:

```text
$C5  E   go to source end
$C8  H   toggle decimal/hexadecimal display
$CB  K   go to source start
$D7  W   toggle insert/overwrite source mode
```

`updateInputBuffer` normally returns with zero clear, meaning “keep editing.” A successful comparison leaves zero set, which the main editor loop interprets as “submit the line now.”

These four commands need no argument. The user presses the key combination and sees the result immediately.

Other tokens remain in the input buffer so the user can type parameters before pressing ENTER:

```text
FIND label
SAVE MYFILE
U-TOP 50000
```

The distinction is encoded not in a separate command-property table, but in four comparisons inside the insertion loop.

## Command dispatch is arithmetic, not searching

When ENTER submits a line, `submitInputLineOrDispatchCommand` reads its first logical byte.

If the byte is below `$80`, it is ordinary source text and goes to `parseAndInsertSourceLine`.

If the byte is `$C1` or above, it is a command token. The dispatcher computes an address in `commandHandlerTable`:

```asm
ld h,0
ld l,a
ld de,commandHandlerTable-($c1*2)
add hl,hl
add hl,de
ld a,(hl)
inc hl
ld h,(hl)
ld l,a
jp (hl)
```

Read as pseudocode:

```text
index = token - $C1
handlerAddress = wordAt(commandHandlerTable + index*2)
jump handlerAddress
```

The source performs the subtraction indirectly by biasing the table base. That saves instructions in a frequently used path.

The table itself is clear once its purpose is known:

```asm
commandHandlerTable:
    defw invokeAssembly
    defw invokeBasic
    defw invokeCopy
    defw invokeDelete
    ...
    defw invokeReplace
```

The alphabet is the index:

```text
A → ASSEMBLY
B → BASIC
C → COPY
D → DELETE
...
Z → REPLACE
```

Some letters are aliases or immediate navigation operations. The table preserves those historical slots rather than trying to make every letter unique.

## The prepared return address

The dispatcher uses `JP (HL)`, not `CALL (HL)`. The Z80 has no convenient general indirect `CALL` instruction.

PROMETHEUS creates the same effect by pushing the normal return destination first:

```asm
ld hl,prometheusWarmStart
push hl
...
jp (hl)
```

A simple command handler can now finish with `RET`. The address popped from the stack is `prometheusWarmStart`, so the editor redraws and waits for the next key.

This is a small but important Z80 pattern:

```text
push desired return address
jump indirectly to selected routine
routine RETs to prepared address
```

It turns a jump table into something that behaves like a table of subroutine calls.

## Repeat begins with comparing normalized bytes

PROMETHEUS remembers the last accepted key in self-modified operands:

```asm
varcLastPressedKey:
    ld a,022h
varcLastPressedKeyComparisonValue:
    cp 022h
```

The first instruction's operand stores a translated key. The second instruction's operand stores the value used for the next comparison.

The exact arrangement is compact and slightly indirect, but the purpose is simple:

```text
if currentNormalizedKey == previousNormalizedKey:
    treat it as a held key
else:
    accept it as a new key
```

This comparison happens after case conversion and command-token formation. Holding SYMBOL SHIFT+A therefore repeats `$C1`, not a raw matrix index.

## Repeat delay is a loop count, not a clock

A held key enters `.advanceHeldKeyRepeatCounter`:

```asm
varcHeldKeyRepeatScanCounter:
    ld hl,00000h
    inc hl
    ld (varcHeldKeyRepeatScanCounter+1),hl
    ld a,h
    cp 005h
    jr nz,processKey
```

The counter is incremented once per repeated scan. Only when its high byte reaches five is the remembered key emitted again.

This is not a time measurement in milliseconds. It is a processor-loop delay. Its real duration depends on the exact instruction path and machine speed.

A newly accepted key also runs an initial delay loop. Command tokens with bit 7 set receive an additional longer delay:

```asm
bit 7,a
ld (varcRepeatedKeyCode+1),a
ret z
```

Why delay commands more? A repeated letter in source may be useful. Accidentally repeating a whole command token is more disruptive. The extra pause reduces that risk.

## Release must be stable

Mechanical key contacts and keyboard scans are not perfectly clean. PROMETHEUS does not reset repeat state after one scan that happens to report no key. It waits through a small release-debounce loop:

```text
scan repeatedly
if the key reappears, continue held-key processing
if it remains absent long enough, clear previous-key state
```

This prevents a held key from being misread as many separate new presses because of a momentary gap.

The implementation uses nested decrement loops rather than a timer interrupt, because PROMETHEUS normally runs with interrupts disabled and wants complete control over the machine.

## Every accepted key clicks

A new or repeated key reaches `.acceptNormalizedKeyAndBeep`:

```asm
push af
call keypressBeep
pop af
```

The key byte is preserved while the configured click routine toggles the Spectrum speaker.

The beep is therefore part of event acceptance, not part of physical scanning. Invalid states, isolated modifiers, and suppressed held-key scans do not click.

This gives useful feedback: a click means PROMETHEUS has decided to deliver a key to the editor.

## The monitor uses a wrapper

The monitor often calls `readKeyCode` instead of `processKey` directly:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ret nz
    or 020h
    ret
```

Two extra policies are applied:

1. the alternate register bank is protected around the editor-oriented translator;
2. letters are forced to lower case for monitor command dispatch.

This is another layer of adaptation. `processKey` supplies a general normalized event. `readKeyCode` narrows it to the monitor's expectations.

## Fast held arrows bypass part of this mechanism

Chapter 9 showed that source-window scrolling can continue while an arrow remains held. After the first normalized arrow event, the fast scroll loop reads keyboard port `$FE` directly.

That is not a contradiction.

The first event still goes through the full translation path:

```text
matrix → ROM scanner → control code
```

Once the editor knows specifically that it is repeating cursor-down or cursor-up, it can cheaply test the one known physical key in the matrix:

```text
Is that exact arrow key still down?
```

There is no need to redo command-token translation, CAPS LOCK, punctuation lookup, or general debounce for every shifted bitmap row.

PROMETHEUS uses the general service to identify an event and a specialized service to accelerate a known continuation.

## A complete ordinary letter

Suppose the user presses `L` without SHIFT while entering source.

```text
1. ROM_KeyboardScanning returns key index E and ordinary modifier class D.
2. getKeypressCodeOrZero accepts the event.
3. processKey indexes ROM_Key_Tables.
4. the letter is normalized to lower case: 'l'.
5. CAPS LOCK may invert it.
6. the byte is compared with the previous accepted key.
7. if new, the click sounds and repeat state is initialized.
8. processKey returns 'l'.
9. the editor sends it to updateInputBuffer.
```

At this point the keyboard is no longer relevant. The editor sees one byte.

## A complete command token

Suppose the input line is empty and the user presses SYMBOL SHIFT+S.

```text
1. ROM scanner reports S with SYMBOL SHIFT.
2. processKey verifies that inputBufferStart is $01,$00.
3. the letter code 'S' receives bit 7, becoming $D3.
4. the key is clicked and returned.
5. updateInputBuffer inserts $D3 before the cursor marker.
6. repaintEditLine expands $D3 to visible word SAVE.
7. the user types a filename and presses ENTER.
8. submitInputLineOrDispatchCommand recognizes a high-bit first byte.
9. $D3 selects the S entry in commandHandlerTable.
10. control jumps to invokeSave.
```

The user thinks in words. PROMETHEUS thinks in one-byte verbs.

## A complete held key

Suppose the user holds `x`.

```text
first scan:
    translate to 'x'
    previous key differs
    click
    remember 'x'
    initial delay
    return 'x'

following scans:
    translate to 'x'
    previous key matches
    increase repeat counter
    return nothing until threshold

threshold scan:
    return remembered 'x'
    click again

release:
    require stable absence
    clear comparison and counter
```

This design avoids filling the line at full processor speed while still allowing useful repetition.

## Back to the whole machine

The keyboard layer is a small interpreter.

Its input language consists of:

- matrix positions;
- modifier states;
- time expressed as repeated scans.

Its output language consists of:

- ASCII-like characters;
- editor control bytes;
- command tokens.

That output is deliberately shaped for the next layers. Cursor codes are small enough for direct comparisons. Command tokens form a dense alphabetic range. Letters obey the editor's case policy. Repeats are already slowed to human speed.

This separation matters. The edit-line routine does not know how the Spectrum keyboard matrix works. The command dispatcher does not know whether a token came from a key combination or was constructed by another routine. Each layer receives a representation suited to its job.

## What has changed in memory or hardware?

After a new key is accepted:

- `varcLastPressedKey` remembers the translated byte;
- `varcLastPressedKeyComparisonValue` is updated;
- `varcRepeatedKeyCode` receives the byte for future repeat;
- `varcHeldKeyRepeatScanCounter` is reset;
- the ULA speaker bit is toggled for the click.

While the key remains held:

- the repeat counter increases;
- no input-buffer byte changes until the threshold produces another event.

After a stable release:

- the previous-key comparison byte is cleared;
- the next press will be treated as new.

For a command token:

- only one high-bit byte is returned;
- visible expansion and handler dispatch happen later.

## Important ideas for later chapters

- the Spectrum ROM returns a key index and modifier class, not a ready editor character;
- `processKey` folds physical modifiers, CAPS LOCK, repeat and command entry into one byte;
- bit 7 distinguishes command tokens from ordinary input text;
- `$C1` through `$DA` map directly to letters A through Z;
- command words are displayed by expansion, not stored as full text;
- some no-argument commands submit themselves immediately;
- indirect command dispatch is implemented by pushing a return address and jumping through a word table;
- repeat timing is based on processor loops and repeated scans, not interrupts or a clock.

## Source anchors explained

- `getKeypressCodeOrZero`
- `processKey`
- `readKeyCode`
- `ROM_KeyboardScanning`
- `.keyCombinationWithSS`
- `symbolCharacters`
- `varcCapsLockEnabled`
- `varcLastPressedKey`
- `varcLastPressedKeyComparisonValue`
- `varcRepeatedKeyCode`
- `varcHeldKeyRepeatScanCounter`
- `resetLastPressedKeyComparison`
- `keypressBeep`
- `isNumber`
- `isLetter`
- `submitInputLineOrDispatchCommand` at command-dispatch level
- `commandHandlerTable`
