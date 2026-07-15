# Chapter 27: Pseudo-Instructions and Assembly Control

A Z80 knows nothing about `ORG`, `EQU`, `DEFB` or `ENT`.

These words are instructions to the assembler rather than to the processor.
They shape addresses, create data, reserve storage and tell PROMETHEUS how a
finished program should be entered.

Calling them *pseudo-instructions* is useful because they appear in source where
instructions appear and are stored in the same compressed-record system. But
their effects are much more varied than “emit an opcode.”

Some emit bytes. Some alter pointers. Some define values. Some affect only the
`RUN` command. Empty and comment lines do nothing at assembly time yet still
occupy source records.

PROMETHEUS gives these records pseudo-opcodes `$00` through `$09`:

```text
$00 empty
$01 comment
$02 ENT
$03 EQU
$04 ORG
$05 PUT
$06 DEFB
$07 DEFM
$08 DEFS
$09 DEFW
```

Their information byte uses the pseudo namespace, and an optional line-label
ordinal follows the same rule as on machine records.

This chapter studies the directives as one language. The aim is not merely to
list their syntax, but to show how they cooperate with the two pointers and two
passes explained in Chapters 25 and 26.

## A table of effects

The easiest starting point is to ask three questions about every directive:

1. Must pass one evaluate it?
2. Does pass two evaluate or emit it?
3. Which state does it change?

| Directive | Pass one | Pass two | Main effect |
|---|---|---|---|
| empty/comment | ignore | ignore | source organization only |
| `ENT` | ignore | evaluate | RUN entry target |
| `EQU` | evaluate | ignore | value of line label |
| `ORG` | evaluate | evaluate | logical and physical pointers |
| `PUT` | evaluate | evaluate | physical pointer only |
| `DEFB` | count items | evaluate and emit | byte data |
| `DEFM` | count characters | decode and emit | text data |
| `DEFS` | evaluate and advance | evaluate and advance | reserved hole |
| `DEFW` | count items | evaluate and emit | word data |

The asymmetry is intentional. Pass one performs exactly enough work to establish
later addresses. Pass two performs exactly enough work to realize the output and
RUN metadata.

## Empty and comment records

An empty source line has pseudo-opcode `$00`. A comment has `$01` and carries its
verbatim text payload.

Neither affects addresses or output in either pass.

They still matter to the editor:

- they appear in the source window;
- they can be selected, copied, deleted, found and printed;
- comments preserve the programmer's explanation;
- record traversal must skip their exact stored lengths.

The assembler's behavior is simply:

```text
if pseudoOpcode < ENT:
    return
```

This is a useful separation between **source structure** and **generated
structure**. Not everything worth keeping in a program needs a machine-code
representation.

## `ENT`: the address used by RUN

`ENT expression` selects the entry address for the `RUN` command.

It does not emit a byte and does not alter either assembly pointer. Pass one
ignores it. Pass two evaluates the expression after normal labels have been
defined and stores the result in the operand of:

```asm
varcRunEntryCallTarget:
    call 00000h
```

The target is therefore another self-modified instruction operand.

`RUN` requires exactly one `ENT`. Before compiling, `invokeRun` initializes a
balance byte to 1:

```asm
    ld a,001h
    ld (varcRunEntDirectiveBalance+1),a
```

Every pass-two `ENT` decrements it.

After assembly:

```text
zero ENT directives      balance remains 1
one ENT directive        balance becomes 0
multiple ENT directives  balance underflows or continues nonzero
```

Only zero is accepted. Otherwise PROMETHEUS reports `ENT ?`.

This compact counter distinguishes “exactly one” without keeping a separate
seen/not-seen flag and duplicate count.

A valid `RUN` then clears the display and executes:

```asm
varcRunEntryCallTarget:
    call 00000h
```

The generated program is expected to return with `RET` if it wants to come back
to PROMETHEUS.

Because `ENT` is evaluated in pass two, it may refer to a label defined later in
source than the `ENT` line itself. By then the complete first-pass map exists.

## `EQU`: a name whose value is not its position

A normal line label receives the logical address at which its line begins.
`EQU` replaces that positional meaning with an expression value.

Typical source might be:

```asm
SCREEN  EQU 16384
WIDTH   EQU 32
```

The label belongs to the record. During pass one, the normal label path first
marks it DEFINED. The `EQU` branch then evaluates the encoded expression and
writes the result into the same symbol's value word.

Pass two does nothing for `EQU` because the symbol value already exists and no
byte is emitted.

The timing creates an ordering rule:

```text
an EQU expression may use:
    earlier definitions in the current pass
    locked symbols retained from elsewhere

it may not use:
    an ordinary symbol first defined later in the same pass
```

For example:

```asm
START   EQU BASE+16
BASE    EQU 32768
```

fails unless `BASE` was already locked, because `START` is evaluated first.
Reversing the two records works.

PROMETHEUS is therefore a two-pass assembler for ordinary instruction
references, but its `EQU` expressions follow a single forward scan inside pass
one.

## `ORG`: choose both meanings of “where”

`ORG expression` sets:

```text
logicalAddress = expression
outputPointer  = expression
```

It says both:

- “the next generated byte is considered to live at this address”; and
- “write that byte to this address in RAM.”

The first and second passes both execute `ORG`, because both begin from the same
default state and need the same address history.

A common program begins:

```asm
        ORG 32768
```

Later labels then receive values from `$8000` upward, and pass two writes the
bytes there.

`ORG` is also the reason an assembly can leave the safe post-source output area
and target lower free memory. The per-byte writer checks that the chosen region
does not overlap PROMETHEUS, source, symbols or U-TOP.

The expression must be available in pass one. A forward label cannot choose the
origin because later label values depend on the origin itself.

## `PUT`: separate storage from logical addresses

`PUT expression` changes only:

```text
outputPointer = expression
```

The logical address remains unchanged.

This allows code to be assembled *as if* it lived at one address while its bytes
are placed at another.

Example:

```asm
        ORG 32768
        PUT 50000
HERE    LD HL,HERE
```

`HERE` is `$8000`, but the instruction bytes are written beginning at decimal
50000. The operand inside those bytes also contains `$8000`.

`PUT` is useful for advanced layouts, staged code or data that will later be
moved. PROMETHEUS itself does not infer the later movement. It merely maintains
the two coordinate systems.

Like `ORG`, `PUT` must evaluate during pass one and replay during pass two.

The shared helper reflects their relationship:

```asm
setOrgAddressAndOutputPointer:
    call evaluateEncodedExpressionAtIX
    ld (varcAddressCounter+1),bc
setOutputPointerFromBC:
    ld (varcAssemblyOutputPointer+1),bc
    ret
```

`ORG` enters above both stores. `PUT` enters at the second store.

## `DEFB`: define bytes from expressions

`DEFB` creates one byte per comma-separated expression:

```asm
        DEFB 1,2,255
        DEFB LOWVALUE,-1
```

During source entry, the definition parser joins the two ordinary operand
buffers if necessary, encodes each expression, and retains commas as structural
separators in the compressed payload.

Pass one does not evaluate the expressions. It counts the items and advances the
logical address by that count.

Pass two evaluates each item and sends it to
`validateAndEmitImmediateByte`. The broad byte rule accepts values whose high
byte is `$00` or `$FF`, then emits the low byte.

Thus `DEFB` shares the same value validation and protected writer as immediate
instruction operands.

Because values are deferred to pass two, a `DEFB` item may refer to a later
ordinary label:

```asm
        DEFB TABLE & 255
```

subject, of course, to PROMETHEUS's actual left-to-right expression operators
and syntax rather than modern assembler conventions. The important point is that
the symbol need not be evaluated merely to count one item in pass one.

## `DEFW`: define little-endian words

`DEFW` is the word counterpart:

```asm
        DEFW START,END,BUFFER
```

Pass one counts items and advances the logical address by twice the count.

Pass two evaluates each expression and calls `emitWordBCAtAssemblyOutput`, which
writes:

```text
low byte
high byte
```

No range reduction is required. Every sixteen-bit value is representable as a
word.

The source above might produce:

```text
low(START), high(START),
low(END),   high(END),
low(BUFFER),high(BUFFER)
```

Every byte is individually output-protected.

## `DEFM`: define a message, not a list of expressions

`DEFM` stores quoted character data.

The parser gives it a dedicated path rather than the general expression-list
encoder. The complete normalized quoted string, including its delimiters, is
copied into the persistent record.

Two delimiter forms have different final-byte behavior.

With double quotes:

```asm
        DEFM "HELLO"
```

PROMETHEUS emits ordinary character bytes:

```text
48 45 4C 4C 4F
```

With apostrophes:

```asm
        DEFM 'HELLO'
```

it sets bit 7 on the last emitted character:

```text
48 45 4C 4C CF
```

This matches the high-bit-terminated string convention used widely inside
PROMETHEUS itself.

The shared `scanNextDefmCharacter` handles both passes. It returns each logical
character and tells the caller when the final one has been reached.

It also collapses a doubled double quote inside a double-quoted string. A pair of
quote characters represents one literal quote rather than the end followed by
another opening delimiter.

Pass one counts the logical characters returned by this decoder. Pass two emits
them. On the final apostrophe-delimited character, pass two sets bit 7 before
calling the common byte writer.

Using one scanner for both jobs guarantees that escaping rules do not change the
predicted and emitted lengths differently.

## `DEFS`: reserve space without filling it

`DEFS expression` advances both assembly pointers but writes nothing:

```asm
BUFFER  DEFS 256
```

If `BUFFER` begins at `$9000`, the next label is `$9100`. The bytes from `$9000`
through `$90FF` retain whatever memory previously contained.

This distinction matters. `DEFS` is not equivalent to:

```asm
        DEFB 0,0,0,...
```

It does not initialize the region.

Both passes evaluate the count and advance:

```text
logicalAddress += count
outputPointer  += count
```

The reconstructed source shows that the encoded-expression loop accepts more
than one comma-separated count, even though the ordinary documented form is one
value. Each is added in turn.

Because no byte is written, the output-protection routine is not called while
the hole is skipped. If the new output pointer lands in an illegal region, the
error appears when a later instruction or data directive attempts its first
actual write.

Like `ORG`, `PUT` and `EQU`, the count must be evaluable in pass one. A forward
reference cannot determine how much space earlier records reserve.

## Labels on data and storage directives

All pseudo-records use the same optional line-label mechanism as machine
instructions.

Therefore these are natural:

```asm
MESSAGE DEFM "READY"
TABLE   DEFW ITEM1,ITEM2
BUFFER  DEFS 64
```

The first pass defines the label at the logical address *before* applying the
record's size or pointer movement.

Thus:

```text
MESSAGE = address of first message byte
TABLE   = address of first word
BUFFER  = beginning of reserved area
```

For `EQU`, the label's ordinary positional value is immediately replaced by the
expression result.

For `ORG` or `PUT`, a label on the same record would be defined before the
pointer-changing directive is applied. This follows directly from the shared
first-pass order. Clear source style generally places address-control directives
without a label when the intended meaning might otherwise be surprising.

## Definition records are encoded differently from instructions

During source entry, mnemonic indexes for `DEFB` through `DEFW` select
`.encodeDefinitionPseudoInstruction`.

This path:

1. maps the mnemonic to pseudo-opcode 6 through 9;
2. creates the common header and optional label ordinal;
3. joins comma-separated material from the two parsed operand buffers;
4. checks the combined normalized length;
5. either encodes expression items or copies a quoted `DEFM` string;
6. appends the usual `$C0+n` terminal/back-link marker.

The assembler passes never need to reconstruct the original columns. They see a
compact directive-specific payload.

For `DEFB`, `DEFS` and `DEFW`, symbol names inside expressions have already been
replaced by tagged ordinals.

For `DEFM`, character bytes remain character bytes because their spelling is the
actual data to emit.

## The second-pass pseudo dispatcher

The pass-two routine uses arithmetic fall-through rather than a large jump
table. It subtracts 2 so that `ENT` becomes case zero, then repeatedly decrements
to reach the other directives.

The shape is approximately:

```text
opcode < ENT: return
opcode == ENT: evaluate and store run target
opcode == EQU: return
opcode == ORG: set both pointers
opcode == PUT: set output pointer
opcode == DEFB: expression loop, checked byte emitter
opcode == DEFM: character loop, optional final high bit
opcode == DEFS: pointer-advance expression loop
opcode == DEFW: expression loop, word emitter
```

This compact dispatch works because the pseudo-opcodes were deliberately
assigned in a useful order.

## An example combining the directives

Consider:

```asm
BASE    EQU 32768
        ORG BASE
START   LD HL,MESSAGE
        LD DE,BUFFER
        RET
MESSAGE DEFM 'OK'
TABLE   DEFW START,MESSAGE
BUFFER  DEFS 16
        ENT START
```

Assume the instruction lengths are:

```text
LD HL,nn  3
LD DE,nn  3
RET       1
```

### Pass one

1. `BASE EQU 32768`
   - defines `BASE` and replaces its value with `$8000`;
   - emits no length.
2. `ORG BASE`
   - sets both pointers to `$8000`.
3. `START LD HL,MESSAGE`
   - defines `START=$8000`;
   - advances to `$8003` without evaluating `MESSAGE`.
4. `LD DE,BUFFER`
   - advances to `$8006` without evaluating `BUFFER`.
5. `RET`
   - advances to `$8007`.
6. `MESSAGE DEFM 'OK'`
   - defines `MESSAGE=$8007`;
   - counts two characters; advances to `$8009`.
7. `TABLE DEFW START,MESSAGE`
   - defines `TABLE=$8009`;
   - counts two words; advances to `$800D`.
8. `BUFFER DEFS 16`
   - defines `BUFFER=$800D`;
   - evaluates 16 and advances to `$801D`.
9. `ENT START`
   - no first-pass action.

### Pass two

1. `EQU` does nothing.
2. `ORG` restores `$8000` to both pointers.
3. `LD HL,MESSAGE` emits `21 07 80`.
4. `LD DE,BUFFER` emits `11 0D 80`.
5. `RET` emits `C9`.
6. `DEFM 'OK'` emits `4F CB`, with bit 7 set on final `K`.
7. `DEFW START,MESSAGE` emits `00 80 07 80`.
8. `DEFS 16` skips sixteen bytes without writing.
9. `ENT START` patches the RUN call target to `$8000` and satisfies the exactly-one
   counter.

The logical end is `$801D`, but the last actual written byte was at `$800C`.
The reserved buffer occupies the following address range without being
initialized.

This example shows why one simple “current position” variable would not be
enough. Directives can define values, write data, change positions or merely
reserve an address range.

## In plain pseudocode

First-pass directive behavior:

```text
function pseudoPassOne(record):
    switch record.opcode:
        case empty, comment, ENT:
            return

        case EQU:
            currentLineLabel.value = evaluate(record.expression)

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            logicalAddress += countExpressionItems(record)

        case DEFM:
            logicalAddress += countLogicalStringCharacters(record)

        case DEFS:
            for each expression:
                value = evaluate(expression)
                logicalAddress += value
                outputPointer += value

        case DEFW:
            logicalAddress += 2 * countExpressionItems(record)
```

Second-pass directive behavior:

```text
function pseudoPassTwo(record):
    switch record.opcode:
        case empty, comment:
            return

        case ENT:
            runTarget = evaluate(record.expression)
            entBalance -= 1

        case EQU:
            return

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            for each expression:
                emitCheckedByte(evaluate(expression))

        case DEFM:
            for each decoded character:
                if last and delimiter is apostrophe:
                    character |= $80
                emitByte(character)

        case DEFS:
            for each expression:
                value = evaluate(expression)
                logicalAddress += value
                outputPointer += value

        case DEFW:
            for each expression:
                emitWordLittleEndian(evaluate(expression))
```

## What has changed in memory

Depending on the directives present:

- `EQU` has changed symbol value words during pass one;
- `ORG` has replaced both assembly pointers in both passes;
- `PUT` has replaced only the physical output pointer;
- `DEFB` has written checked bytes;
- `DEFM` has written text, possibly tagging the final apostrophe-delimited byte;
- `DEFS` has advanced pointers without altering skipped RAM;
- `DEFW` has written little-endian words;
- `ENT` has patched the target of the RUN `CALL` and changed the ENT balance;
- empty and comment records have changed nothing outside source storage.

## Important labels encountered

- `.executePseudoInstructionSecondPass`
- `skipEncodedLineLabelIfPresent`
- `setOrgAddressAndOutputPointer`
- `setOutputPointerFromBC`
- `advancePointersForDefsExpressions`
- `countCommaSeparatedDefinitionItems`
- `scanNextDefmCharacter`
- `.encodeDefinitionPseudoInstruction`
- `.encodeDefmStringLiteral`
- `validateAndEmitImmediateByte`
- `emitByteAtAssemblyOutput`
- `emitWordBCAtAssemblyOutput`
- `invokeRun`
- `varcRunEntDirectiveBalance`
- `varcRunEntryCallTarget`

## Back to the bigger picture

Part III can now explain almost every transformation performed during assembly:

```text
human source
    ↓
compressed semantic records
    ↓
mnemonics, operands and expressions
    ↓
stable symbol ordinals and values
    ↓
first-pass address map
    ↓
second-pass instructions and directive data
```

What remains is to put all of those mechanisms around one program and follow its
records, symbols, addresses and final bytes without interruption.

Chapter 28 will perform that reconstruction. It will be the assembler section's
return to the top level: one small program will enter as source and leave as a
complete machine-code image with a runnable entry point.
