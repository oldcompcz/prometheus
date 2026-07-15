# Chapter 11: The Editable Line

The editor's source window looks like text, but it is not where typing happens.

PROMETHEUS gives the user one temporary editable line at the bottom of the screen. That line is a small meeting place for several kinds of information:

- ordinary characters;
- a movable cursor marker;
- compact command tokens;
- a zero terminator;
- automatically inserted field spacing;
- source text reconstructed from a compressed record;
- command arguments entered by the user.

The line is simple enough to fit in a few dozen bytes, yet it supports source entry, editing, commands, monitor prompts, filenames and several generated forms of text.

This chapter studies that temporary representation before Chapter 12 turns to the much denser form used for permanent source storage.

## Three versions of one line

Consider the visible source line:

```asm
LOOP     DJNZ LOOP
```

At different moments PROMETHEUS may hold three versions of it.

### Persistent source record

This is the compressed, machine-oriented form stored among the other source records. It contains an opcode, an information byte, compact symbol references and a backward marker.

### Expanded display line

This is a 32-byte row in `lineBuffer`. Fields have been padded and symbol names expanded so the source can be drawn or printed.

### Editable input line

This is a zero-terminated sequence at `inputBufferStart`, containing one cursor marker and possibly a compact command token.

The editable line is the user's workspace. It is not the final source representation.

```text
persistent record
    → expand for EDIT
editable line
    → user changes it
    → parse and compress on ENTER
persistent record
```

## The cursor is a byte inside the string

Many text editors store a cursor as a separate number:

```text
cursorColumn = 12
```

PROMETHEUS instead places byte `$01` directly inside the input sequence.

An empty line is:

```text
$01,$00
```

A line containing `abc` with the cursor after `b` is conceptually:

```text
'a','b',$01,'c',$00
```

The cursor can move by exchanging `$01` with a neighbouring byte.

This eliminates several calculations. The current logical insertion point is always the address of the marker. Text before it is before the cursor; text after it is after the cursor.

The renderer remembers that address in a self-modified instruction:

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

After every repaint, the immediate operand contains the actual address of `$01`.

## A guard byte stands before the line

Immediately before `inputBufferStart` lies `inputBufferGuardByte`:

```asm
inputBufferGuardByte:
    defb 080h
inputBufferStart:
    ...
```

The guard serves two related purposes.

First, several scanners use a pre-increment pattern. They begin one byte before the real data, increment, and then read. A valid predecessor address makes that idiom safe at the first character.

Second, the high bit gives cursor-left and deletion code a protected boundary. The cursor cannot move indefinitely into unrelated workspace memory.

The guard is not visible text. It is part of the buffer's safety machinery.

## The physical workspace is shared

The labels following `inputBufferStart` expose several other uses of the same memory:

- editor and monitor input;
- a Spectrum tape header;
- monitor register-assignment text;
- temporary interrupt-state capture.

This sharing is safe because the activities do not happen at the same time. When the editor owns the line, the bytes mean editable text. During a tape operation, some of the same bytes mean header fields.

A modern program might allocate a separate structure for every purpose. PROMETHEUS reuses one scratch area because resident memory is precious.

The important rule is temporal:

> A byte may have several meanings across the life of the program, but only one meaning at a particular moment.

## Repainting discovers the cursor again

`repaintEditLine` selects the assembler token table and the bottom bitmap row:

```asm
repaintEditLine:
    ld hl,l96a4-1
    ld (varcTokenExpansionTableBase+1),hl
    ld hl,BOTTOM_LINE_VRAM_ADDRESS
```

It then enters the shared renderer `renderInputLineAtBitmapAddress`.

The renderer clears the row and begins at the guard byte:

```asm
ld hl,inputBufferGuardByte
.renderNextInputBufferElement:
    inc hl
    ...
    ld a,(hl)
```

For each element it performs one of three actions:

```text
$00        stop
$01        draw cursor and remember its address
other      display character or expand token
```

The cursor branch is:

```asm
.renderInputCursorMarker:
    ld (varcInputBufferPosition+1),hl
    push hl
    ld a,(varcCapsLockEnabled+1)
    add a,0cch
    call displayNormalCharacter
    pop hl
```

The glyph changes with CAPS LOCK state. The state byte is either zero or nonzero, so adding it to `$CC` selects the appropriate visual form according to the original font arrangement.

The key point is not the exact glyph code. It is that repainting performs two jobs at once:

1. draw the line;
2. rebuild the cached cursor address.

No separate scan is needed before the next edit operation.

## Screen column is also cached

Before reading each buffer element, the renderer records the current physical output column:

```asm
ld a,(varcPrintingPosition+1)
and 01fh
ld (varcInputColumnAfterCursor+1),a
```

Because `varcPrintingPosition` points to the next bitmap cell, its low five bits reveal the horizontal column within a 32-character row.

When the cursor marker is encountered, the value left in `varcInputColumnAfterCursor` describes the physical position after the cursor glyph. A later insertion checks that value:

```asm
varcInputColumnAfterCursor:
    ld a,007h
    or a
    jr z,.incAAndRet
```

A zero means the renderer has wrapped beyond the final column. PROMETHEUS refuses to insert another character rather than allowing the editable line to spill into another screen row.

The input capacity is therefore governed not merely by raw workspace size but by the visible 32-column interface.

## Tokens look like words

A byte below `$80` is displayed as one character. A byte at or above `$80` is a compact token.

`displayInputTokenOrCharacter` uses the token value as an index into a caller-selected self-relative table:

```asm
varcTokenExpansionTableBase:
    ld hl,08d6fh
    ld d,000h
    ld e,a
    add hl,de
    ld e,(hl)
    add hl,de
```

The resulting address points to a high-bit-terminated word. The renderer writes its characters and then adds one space.

This means one physical input byte may consume many screen columns:

```text
buffer byte $C1
    ↓
visible "ASSEMBLY "
```

That is why the cached *physical* column matters. Buffer length alone cannot tell whether the line still fits on screen.

## ENTER is signalled through the zero flag

The first test in `updateInputBuffer` is intentionally tiny:

```asm
cp 00dh
ret z
```

If the key is ENTER, the routine returns immediately with the zero flag set.

The main editor loop uses that flag as its result:

```text
Z clear    continue editing
Z set      submit the line
```

The routine does not return a special status byte or place a result in memory. The comparison flag is enough.

Several immediate command tokens deliberately use the same convention, as Chapter 10 explained. A comparison with `$C5`, `$C8`, `$CB` or `$D7` returns zero and therefore submits the command without waiting for ENTER.

## Cursor-left is one exchange

At entry, `HL` points to the cursor marker.

Cursor-left reads the byte before it and exchanges the two:

```asm
ld b,(hl)
dec hl
ld a,(hl)
rlca
jr c,.incAAndRet
ld c,(hl)
ld (hl),b
inc hl
ld (hl),c
```

Since `B` contains `$01`, the effect is:

```text
before:  x,$01

after:   $01,x
```

The `RLCA` tests the high bit of the preceding byte. A high-bit token acts as a left boundary for cursor movement. The user cannot place the cursor inside the expanded spelling of a token because that spelling is not physically present in the buffer.

For example:

```text
buffer:  $D3,' ','F','I','L','E',$01,$00
screen:  SAVE FILE_
```

The cursor may move among the argument characters, but not into the displayed letters of `SAVE`.

The token is one indivisible internal element even though it occupies several visible columns.

## Cursor-right is the mirror operation

Cursor-right inspects the byte after the marker:

```asm
ld b,(hl)
inc hl
ld a,(hl)
and a
jr z,.incAAndRet
ld (hl),b
dec hl
ld (hl),a
ret
```

If the next byte is zero, the cursor is already at the end and does not move.

Otherwise:

```text
before:  $01,x

after:   x,$01
```

Again, no numerical cursor position is updated. The marker itself moves.

## Backspace closes the gap

Backspace removes the byte before the cursor. It sets two pointers:

```text
HL = byte before cursor
DE = cursor
```

Then it copies the tail left until the zero terminator has also moved:

```asm
.shiftInputTailLeftAfterDeleteLoop:
    ld a,(de)
    ld (hl),a
    inc hl
    inc de
    or a
    jr nz,.shiftInputTailLeftAfterDeleteLoop
```

Suppose the buffer is:

```text
'a','b','c',$01,'d',$00
```

Backspace produces:

```text
'a','b',$01,'d',$00
```

The cursor remains at the same logical place relative to the surviving text because the marker is copied left along with the tail.

If the byte before the cursor is the `$80` guard, deletion is refused. A command token can be deleted as one whole byte, which is useful for cancelling a command and returning to ordinary source entry.

## Printable insertion is a travelling exchange

The most interesting edit-line trick is insertion.

A conventional implementation would move the complete tail right by one byte and then store the new character. PROMETHEUS instead carries one displaced byte through the line.

At first:

```text
A  = new character
HL = cursor marker
```

The loop exchanges the byte in `A` with the byte at `HL`, advances, and repeats with the displaced byte.

Conceptually:

```text
carry = newCharacter
position = cursor

loop:
    displaced = buffer[position]
    buffer[position] = carry
    carry = displaced
    position++

    stop after the old zero terminator has been placed
```

For insertion of `X` into:

```text
'a','b',$01,'c',$00
```

we can follow the carried value:

```text
write X, carry $01
write $01, carry c
write c, carry $00
write $00, stop
```

Result:

```text
'a','b','X',$01,'c',$00
```

The cursor has moved one position to the right, remaining after the inserted character.

The real Z80 loop uses the alternate accumulator through `EX AF,AF'` so it can hold both the carried byte and the byte just read without consuming another general register.

This is an excellent example of a low-level trick serving a simple high-level rule.

## The edit line always inserts characters

The interface uses the words INSERT and OVERWRITE, but there are two different questions that can easily be confused.

### Character insertion inside the temporary line

Typing a printable character always shifts the tail right. There is no character-overwrite branch in `updateInputBuffer`.

### Source-record insertion versus replacement

`varcInsertMode` decides what happens when the completed line is submitted:

- zero: insert a new compressed source record after the active record;
- one: insert the new record and delete the old active record, effectively replacing it.

The EDIT key sets `varcInsertMode` to one because the user is changing an existing source line. The W command toggles the mode for source-line submission.

Thus PROMETHEUS's “insert/overwrite” mode is primarily about **lines in the compressed source**, not characters in the temporary edit buffer.

That distinction is easy to miss if we read only labels or user-interface wording.

## SPACE knows the source fields

For ordinary source entry, SPACE is not always inserted as one literal space.

The editor follows a traditional assembly layout:

```text
columns 0–8     label field, width 9
columns 9–13    mnemonic field, width 5
columns 14–31   operands and comment area
```

If the line is ordinary source and the cursor is before column 14, pressing SPACE pads to the next field boundary.

The code measures the cursor-marker offset from `inputBufferStart` and derives one of two targets:

```text
before column 9      pad to column 9
columns 9 through 13 pad to column 14
column 14 or later   insert one normal space
```

Comments and command-token lines bypass this tabulation:

```asm
ld a,(de)
cp ";"
jr z,.insertCharacterAtInputCursor
rlca
jr c,.insertCharacterAtInputCursor
```

If the first character is `;`, the rest of the line is free-form comment text.

If the first byte has bit 7 set, the line begins with a command token. Command arguments should not be forced into assembler source fields.

For source, automatic padding lets the user type:

```text
LOOP SPACE DJNZ SPACE LOOP
```

and obtain the visual layout:

```asm
LOOP     DJNZ LOOP
```

The buffer contains the actual padding spaces. Later parsing also understands the cursor/field marker, but the visible field alignment is already present.

## EDIT reconstructs a line into the buffer

Pressing the Spectrum EDIT combination causes the editor to load the active compressed record into the temporary input area:

```asm
ld ix,(varcSourceBufferActiveLine+1)
ld hl,inputBufferStart
...
call expandSourceRecordToHL
ld a,001h
ld (varcInsertMode+1),a
```

The input buffer is cleared first. The source-record expander then creates editable text rather than drawing directly to the screen.

This reuse is important. PROMETHEUS does not maintain a second permanent textual copy of source. When a line must be edited, readable text is reconstructed on demand.

The mode is set to overwrite so submitting the result will replace the original record rather than merely insert a duplicate beside it.

## Submission chooses source or command

When ENTER or an immediate token causes `updateInputBuffer` to return zero, the editor hides the edit row and examines the first logical input byte.

```asm
ld hl,inputBufferStart
call atHLorNextIfOne
cp 080h
jr c,parseAndInsertSourceLine
```

`atHLorNextIfOne` skips the cursor marker if it happens to be at the beginning. Therefore an empty or ordinary text line is classified by its first actual character.

The rule is:

```text
first logical byte < $80     source text
first logical byte ≥ $80     tokenized command
```

This works because source characters are ordinary seven-bit text while command tokens deliberately occupy the high-bit range.

No full command-name comparison is required.

## Inserting a source line

The source path first builds a temporary compressed record:

```asm
call encodeInputLineToSourceRecord
```

It then chooses the position after the active source record, opens a gap in the combined source/symbol region, and copies the record bytes there.

The new record becomes active.

If `varcInsertMode` is one, the old active record is then removed, turning the operation into a replacement.

In simplified pseudocode:

```text
newRecord = encode(editBuffer)
insertPosition = recordAfter(activeRecord)
insert newRecord at insertPosition
activeRecord = insertPosition

if overwriteMode:
    oldRecord = recordBefore(activeRecord)
    activeRecord = oldRecord
    delete oldRecord

reset mode to INSERT
go to warm start
```

The order may seem indirect, but inserting first ensures the new record exists before the old one is removed and allows the common insertion machinery to adjust moving pointers consistently.

## Why the buffer has no explicit length

The line is zero-terminated.

The cursor marker is found during rendering and cached. Insertion moves the old zero one byte to the right. Deletion copies the zero one byte to the left. Scanners stop at zero.

An explicit length byte would have to be updated after every edit. PROMETHEUS instead lets the terminator travel with the text.

The screen-width check prevents the editor from filling the shared workspace indefinitely, so scanning to zero remains cheap.

## A line containing a token is not ordinary text

Consider:

```text
buffer bytes:
    $D5,' ','5','0','0','0','0',$01,$00
```

Visible line:

```text
U-TOP 50000_
```

Cursor-left may move among the digits and space, but it cannot enter the token's visible letters. Backspace at the first argument position can remove the token as one unit. The command dispatcher later reads `$D5`, not the displayed spelling.

This creates a useful two-level editing model:

```text
ordinary characters     editable one by one
command token           editable as one indivisible word
```

PROMETHEUS gains some of the convenience of tokenized BASIC while still allowing ordinary textual arguments.

## A complete source-entry line

Suppose the line is empty and the user enters:

```asm
START    LD A,1
```

The journey inside the temporary buffer is approximately:

```text
initial:
    $01,$00

type START:
    'S','T','A','R','T',$01,$00

press SPACE:
    'S','T','A','R','T',' ',' ',' ',' ',$01,$00

enter LD and SPACE:
    ... 'L','D',' ',' ',' ',$01,$00

enter A,1:
    ... 'A',',','1',$01,$00
```

Repainting repeatedly locates the marker, draws the line and caches the visible column.

ENTER does not directly store these bytes in source memory. It hands them to the source encoder, which will replace names and syntax with a compact record.

## A complete EDIT operation

Suppose the active persistent source record represents:

```asm
LOOP     DJNZ LOOP
```

Pressing EDIT performs:

```text
1. clear input workspace
2. expand compressed record into readable fields
3. place cursor marker in the reconstructed line
4. set source submission mode to overwrite
5. redraw editor with the active line in the edit row
```

The user changes `LOOP` to `AGAIN` and presses ENTER.

PROMETHEUS then:

```text
1. parses and compresses the edited text
2. inserts the new record
3. deletes the old record
4. resets mode to insert
5. redraws source from the new compressed representation
```

At no time is the source-window bitmap treated as editable storage.

## A complete immediate command

Suppose the line is empty and the user presses SYMBOL SHIFT+H.

```text
1. processKey returns token $C8.
2. insertion loop writes $C8 over the cursor position.
3. comparison with $C8 returns with zero set.
4. main loop immediately submits the line.
5. command dispatch selects invokeToggleNumberBase.
6. handler toggles varcHexMode and RETs to warm start.
```

The input line never needs to be repainted with the word `H` or wait for ENTER. The token is an event as much as it is a byte of text.

## Back to the whole machine

The editable line is an adapter between humans and compressed structures.

For the user, it behaves like a short text editor.

For the renderer, it is a stream of characters and expandable tokens.

For the key layer, it is a destination for normalized bytes.

For the command dispatcher, its first high-bit byte is a direct verb index.

For the source encoder, it is readable label/mnemonic/operand text.

For tape and monitor routines, the same memory is a convenient scratch area.

The design remains manageable because each interpretation has a clear moment and a clear terminator.

## What has changed in memory?

After repainting:

- `varcInputBufferPosition` points at the `$01` marker;
- `varcInputColumnAfterCursor` records the relevant physical column;
- bitmap bytes and edit-line attributes have been refreshed;
- input bytes themselves are unchanged.

After cursor movement:

- `$01` has exchanged places with one neighbouring byte;
- no explicit cursor number changes.

After insertion:

- the new byte occupies the former cursor position;
- the cursor and tail have shifted right;
- the zero terminator has moved right by one byte.

After backspace:

- the tail, cursor and terminator have shifted left;
- one byte of text has disappeared.

After source submission:

- a temporary record is built elsewhere;
- persistent source memory may move;
- the input buffer is reset by warm start.

## Important ideas for later chapters

- `$01` is a movable cursor marker inside the editable string;
- `$00` terminates the input line;
- the byte before the line is a protected scanner guard;
- token bytes expand to words only while rendering;
- physical screen width, not merely workspace length, limits insertion;
- cursor movement swaps bytes rather than changing a numerical column;
- insertion is a travelling exchange using the alternate accumulator;
- SPACE pads ordinary source to label and mnemonic field boundaries;
- character editing always inserts, while `varcInsertMode` controls source-record insertion versus replacement;
- ENTER returns its meaning through the zero flag;
- the first logical byte decides whether submission is source or a command.

## Source anchors explained

- `inputBufferGuardByte`
- `inputBufferStart`
- `repaintEditLine`
- `renderInputLineAtBitmapAddress`
- `varcInputBufferPosition`
- `varcInputColumnAfterCursor`
- `varcTokenExpansionTableBase`
- `displayInputTokenOrCharacter`
- `atHLorNextIfOne`
- `updateInputBuffer`
- `.shiftInputTailLeftAfterDeleteLoop`
- `.shiftInputTailRightForInsertionLoop`
- `varcCapsLockEnabled` at edit-line level
- `varcInsertMode`
- `invokeToggleInsertOverwrite`
- `submitInputLineOrDispatchCommand`
- `parseAndInsertSourceLine` at insertion level
- `encodedRecordStorageLength` at interface level
- `varcPostCommandContinuationJump` at overview level
