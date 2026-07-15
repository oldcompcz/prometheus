# Chapter 15: Navigating the Source

A text editor on a modern computer often keeps an array of lines, a tree of
pieces, or a large character buffer with indexes. PROMETHEUS has no room for a
separate table containing the address of every source line.

Instead, the compressed records themselves form the navigation structure.

Each record explains how to reach the next one. Each variable record leaves a
small backward clue at its end. A single pointer identifies the active line.
The editor's visible window is rebuilt by walking outward from that pointer.

This chapter connects the record format from Chapter 12 to the editor overview
from Chapter 9.

## The source is a sequence, not a table of line pointers

In memory, records are packed immediately one after another:

```text
record 0 | record 1 | record 2 | record 3 | ... | symbol table
```

There is no permanent structure like:

```text
linePointers[0]
linePointers[1]
linePointers[2]
...
```

Such an index would cost two bytes for every source line and would need repair
after every insertion or deletion.

PROMETHEUS instead asks local questions:

```text
Given this record start, where does this record end?
Given this record start, where did the previous record begin?
```

Those questions are answered by `getNextSourceRecord` and
`getPreviousSourceRecord`.

## Forward movement reads the current record

To find the next record, PROMETHEUS examines the current record's information
byte.

The fixed case is immediate:

```text
no line label
operand/storage class zero
    → record length is exactly two bytes
```

For a variable record, the scanner walks payload bytes until it reaches the
`$C0`–`$FF` terminal marker.

It must treat `$80`–`$BF` as the first half of a two-byte symbol reference and
skip the following low byte. Otherwise that low byte might happen to be `$C0`
or above and be mistaken for the end of the record.

The algorithm is:

```text
HL = record start
info = record[1]
HL += 2

if line label present:
    HL += 2

if no label and class == 0:
    return HL

repeat:
    byte = *HL++

    if byte >= $C0:
        return HL

    if byte >= $80:
        HL++       skip ordinal low byte
```

When it returns, `HL` points at the following record's first byte.

## Backward movement reads the byte before the current record

To move backward, PROMETHEUS does not examine the current record at all. It
looks at the byte immediately before it.

If that byte is below `$C0`, the previous record must be the fixed two-byte
form. The byte is its information byte.

If that byte is `$C0` or above, it is the previous variable record's terminal
marker. Its low six bits give the number of variable bytes between header and
marker.

The real routine is short enough to repeat:

```asm
getPreviousSourceRecord:
    dec hl
    ld a,(hl)
    cp 0c0h
    jr c,.previousRecordIsFixedLength
    and 03fh
    ld e,a
    ld d,000h
    sbc hl,de
    dec hl
.previousRecordIsFixedLength:
    dec hl
    ret
```

In pseudocode:

```text
HL--
lastByte = *HL

if lastByte < $C0:
    HL--
    return HL

payloadLength = lastByte & $3F
HL -= payloadLength
HL--       pass information byte
HL--       pass opcode byte
return HL
```

The terminal marker is therefore a miniature relative back-link.

## Why reverse travel is constant-time

A variable record may contain several expression bytes, but backward movement
does not scan them. It subtracts the stored length in one 16-bit operation.

Forward movement can scan a short payload because the editor line is short.
Backward movement would be much more awkward without the terminal length: the
editor would otherwise need to begin at the source start and walk forward until
it rediscovered the previous record.

PROMETHEUS spends one marker byte only on records that need variable material.
That byte buys efficient upward cursor movement through the listing.

## The active line is one self-modified pointer

The editor's current position is stored in the operand of:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
```

At run time, the word after `LD HL,` is rewritten to the start of the active
compressed record.

The active line is not a line number. It is a direct pointer into the current
packed source region.

This makes ordinary movement cheap:

```text
load active pointer
find adjacent record
validate boundary
store new active pointer
```

It also means source insertion and deletion must repair the pointer whenever
memory moves around it. Chapter 16 will examine that repair machinery in detail.

## The initial source contains navigation padding

The initial source image contains twenty fixed empty records `$00,$30`.

They are arranged so that `sourceBufferAccessLine` names the fourteenth record:

```text
13 empty records before active access line
1 active empty record
6 empty records after it
```

This matches the twenty visible rows of the source window.

The padding is not merely cosmetic. It lets the editor perform the same record
walks at the beginning of an empty program that it uses later:

- walk thirteen records backward to find the top visible row;
- render the active row;
- render six records below it.

No special case is needed for “there is no source yet.” The empty source is
already a valid chain of records.

## The active line has a stricter lower boundary than rendering

`compareHLWithSourceBufferStart` compares a candidate active pointer with
`sourceBufferAccessLine`, not with the physical label `sourceBufferStart`:

```asm
compareHLWithSourceBufferStart:
    push hl
    push de
    ld de,sourceBufferAccessLine
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

This distinction is subtle and important.

The thirteen records before `sourceBufferAccessLine` are permanent display
padding. The active editor line may not move into them. They exist so the top of
the listing remains filled when the first real source line is active.

Thus there are two ideas of “start”:

```text
physical sourceBufferStart
    beginning of top display padding

sourceBufferAccessLine
    earliest legal active-line position
```

The reconstructed label name `compareHLWithSourceBufferStart` is slightly broad;
the code's actual policy is “compare with the earliest active source record.”

## Moving to the previous active line

`moveActiveLineToPreviousSourceRecord` performs:

```asm
moveActiveLineToPreviousSourceRecord:
    call getRecordBeforeActiveLine
    call compareHLWithSourceBufferStart
    ccf
    jr .commitActiveLineMoveIfValid
```

The helper first computes the previous record. The comparison then checks
whether that candidate lies before the legal access-line boundary.

If invalid, the editor redraws without changing the stored pointer.

If valid, the common commit path writes the candidate into
`varcSourceBufferActiveLine`.

The user experiences a cursor that simply refuses to move above the beginning.
Internally the program has still calculated the preceding padding record; it
just declines to make it active.

## The upper boundary preserves six records below the active line

Moving downward uses `comparePositionWithCodeEnd`.

Its name is historical and its arithmetic initially looks mysterious:

```asm
comparePositionWithCodeEnd:
    push hl
    push de
    ld de,0000ch
    add hl,de
    ld de,(varcSymbolTablePt+1)
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

Why add twelve?

Twelve bytes are six fixed empty records:

```text
6 × 2 bytes = 12 bytes
```

The candidate active record is valid only if there is still room for six
following empty records before the symbol table begins.

The logical test is approximately:

```text
candidate + sizeOfSixEmptyRecords < symbolTableStart
```

This maintains the lower display padding required by the source window.

The source region therefore always includes a small tail of valid records after
the last user line. The active line cannot descend beyond the position that
leaves those six records available.

## Committing a move uses the return address carefully

Both navigation directions share `.commitActiveLineMoveIfValid`:

```asm
.commitActiveLineMoveIfValid:
    pop de
    jr nc,prometheusWarmStartWithCurrentBuffers
    push de
    ld (varcSourceBufferActiveLine+1),hl
    ret
```

The routine removes its caller's return address before the possible jump to a
warm start. If the move is invalid, it can redraw the editor directly without
leaving a stale return address on the stack.

For a valid move, it restores the return address, commits the new pointer, and
returns normally.

This is a small Z80 technique worth noticing:

> The stack is adjusted so one path behaves like a return and another behaves
> like a tail jump, while both leave `SP` correct.

The visible result is ordinary bounded cursor movement. The implementation is a
carefully shaped control-flow junction.

## Finding the top visible record

The source window is not stored as twenty line pointers. Every repaint derives
it from the active record.

`renderVisibleSourceRecords` loads the active pointer and walks backward thirteen
times:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
    ld b,LINES_BEFORE_ACCESS_LINE
.findTopVisibleSourceRecordLoop:
    call getPreviousSourceRecord
    djnz .findTopVisibleSourceRecordLoop
```

Because the legal active boundary always has thirteen padding records before
it, this walk is valid even at the beginning of the source.

The top record is not remembered after repaint. It is cheap enough to derive.

## Rendering twenty records

After finding the top, the routine repeatedly:

1. clears one screen row;
2. expands and renders the record;
3. advances to the next record;
4. advances one Spectrum character row;
5. stops after the twentieth row.

In pseudocode:

```text
top = active
repeat 13 times:
    top = previous(top)

screenRow = firstSourceWindowRow
record = top

repeat 20 times:
    clear(screenRow)
    render(record, screenRow)
    record = next(record)
    screenRow++
```

The comment in the current source still says “sixteen source rows” at one point,
but the actual loop and display geometry produce twenty. The book follows the
implemented behavior.

## Why repainting from records is useful

A full repaint may seem expensive, but it gives strong consistency:

- no separate screen-line cache can become stale;
- selected-block markers are recalculated;
- symbol names are resolved from the current symbol table;
- source case configuration is applied uniformly;
- every visible line reflects the compressed source currently in memory.

The source window is a projection, not a second editable model.

## Held-arrow scrolling uses a faster visual path

During ordinary movement, a warm start can repaint the whole source window.
While an arrow key remains held, repeatedly rebuilding twenty rows would feel
slow.

PROMETHEUS therefore uses bitmap-row copying for smooth scrolling:

- copy nineteen existing text rows one position;
- render only the newly exposed edge record;
- test the keyboard matrix directly;
- repeat while the arrow remains held.

`copyScreenTextRowAtYToDE` and `copyEightBitmapRows` move the eight bitmap slices
that form one Spectrum character row.

`writeLineOfCodeAndTestKeyboard` renders the new edge line and immediately
samples the keyboard row.

This is an optimization at the view level. The active source pointer still
moves record by record through the same navigation routines.

## The selected block is two external record pointers

Block selection is not stored in record headers. Two self-modified pointers
remember its endpoints:

```asm
varcSelectedBlockStart:
    ld hl,sourceBufferAccessLine
varcSelectedBlockEnd:
    ld de,sourceBufferAccessLine
```

`getSelectedBlock` normalizes their order. If the user set the lower and upper
margins in reverse order, the routine swaps them before use.

A record is inside the selected block when its start address lies between the
normalized endpoints, inclusively.

This design has several advantages:

- selecting a block does not rewrite every record;
- clearing or moving boundaries changes only two words;
- rendering can add a temporary marker without altering source;
- COPY, DELETE, PRINT and assembly-selection logic can share the same endpoints.

The cost is that insertion and deletion must repair these pointers when source
memory moves. That is another job for Chapter 16.

## Navigation and selection are related but independent

The active line can be inside or outside the selected block. Moving the active
line does not automatically drag both boundaries.

The special block-margin key performs an explicit update:

```text
old upper boundary becomes lower boundary
current active record becomes new upper boundary
```

This lets the user define a region by visiting its endpoints.

During repaint, `testSourceRecordOutsideSelectedBlock` compares each rendered
record with the normalized range. A record inside receives a temporary display
marker in `lineBuffer`.

The persistent record has no “selected” bit. Selection is editor state, not
source meaning.

## Insertions and deletions must leave navigation valid

Suppose a new record is inserted before the active line. Raw memory addresses
above the insertion point increase. Without repair:

- the active pointer might now point into the middle of another record;
- selected-block boundaries might drift;
- the symbol-table pointer would be wrong;
- code-end and other region pointers could become stale.

The common insertion/deletion primitives therefore adjust all registered
pointers that lie at or above the movement boundary.

The navigation routines themselves remain simple because structural mutation
promises to preserve their invariants:

```text
active always points to a record start
selected boundaries always point to record starts
symbolTablePt follows the source tail
six lower padding records remain available
thirteen upper padding records remain permanent
```

A compact data structure works only because every writer respects the same
rules as every reader.

## Repair after deletion

Deleting the active line requires choosing a surviving record to become active.
The main editor path generally:

1. deletes exactly one compressed record;
2. tests whether deletion occurred at the first legal active position;
3. if not, steps to the preceding surviving record;
4. stores that pointer as active;
5. redraws.

This keeps the user's position close to the deleted line instead of jumping to
an unrelated address.

The common abort path also repairs an active pointer that has reached the
source-end boundary:

```asm
call comparePositionWithCodeEnd
call z,getPreviousSourceRecord
```

Even error recovery treats navigation invariants as part of application state.

## Import progress reuses source rendering

During source import, PROMETHEUS normally avoids repainting after every inserted
line. That would slow tape or foreign-source conversion.

`pollImportKeyboardAndRefreshIfRequested` checks the keyboard:

- no key: continue import immediately;
- SPACE: abort through the common command-cancellation path;
- another key: fall through to `renderVisibleSourceRecords` for an on-demand
  progress display.

This shows how the source-window renderer is reused outside ordinary cursor
movement. Any operation that maintains a valid active pointer can ask for a
fresh projection of the record chain.

## A complete downward movement

Suppose the active pointer names record `R` and the user presses cursor down.

```text
1. load address of R from varcSourceBufferActiveLine
2. getNextSourceRecord scans R and returns address of S
3. add 12 to S for six-record tail requirement
4. compare with current symbol-table start
5. if invalid:
       leave active pointer unchanged
       warm-start redraw
6. if valid:
       store S as active
       return to scrolling/editor path
7. source window is shifted or repainted around S
```

No line number is incremented. No array element is selected. Movement is purely
structural.

## A complete repaint at the start of an empty source

Initially:

```text
active = sourceBufferAccessLine
```

The renderer calls `getPreviousSourceRecord` thirteen times and reaches
`sourceBufferStart`.

It then renders:

```text
records 0–12     top padding
record 13        active access line
records 14–19    lower padding
```

All twenty records are valid `$00,$30` empty lines. The editor can use its normal
algorithms before the user has entered a single instruction.

This is an elegant form of boundary design:

> Instead of teaching every routine how to handle “no previous line” and “no
> next line,” provide real empty records around the usable source.

## A complete selected-block repaint

Suppose boundaries point at records `B` and `D`, while the active line is `C`.

For each visible record, the renderer:

```text
normalize endpoints to low..high
compare current record start with low
compare current record start with high

if inside:
    place temporary selection glyph in lineBuffer

print reconstructed line
```

The same compressed records can therefore appear selected or unselected without
one source byte changing.

## Back to the whole editor

The source record format serves three jobs at once:

1. compact storage of parsed assembly source;
2. input to assembler and text-expansion routines;
3. local navigation structure for the editor.

The final marker on a variable record is not merely a terminator. It makes the
listing navigable in both directions. The initial empty records are not merely
blank source. They are boundary padding that removes special cases. The active
line is not merely a user-interface cursor. It is a live pointer whose validity
must be preserved by every memory mutation.

The editor's apparent simplicity—press up, press down, see twenty lines—rests on
careful agreement between format, memory layout and rendering.

## What has changed in memory or on screen?

After a valid active-line move:

- `varcSourceBufferActiveLine` contains the adjacent record start;
- selected-block pointers are unchanged;
- compressed source bytes are unchanged.

After an invalid boundary move:

- the active pointer remains unchanged;
- the stack has been repaired for a direct warm-start jump;
- the editor is redrawn at the same position.

During a full repaint:

- `lineBuffer` is repeatedly reconstructed for twenty records;
- bitmap rows are cleared and redrawn;
- temporary selected-block markers may be inserted into `lineBuffer`;
- persistent source remains untouched.

During fast held-key scrolling:

- existing bitmap rows are copied up or down;
- only one newly exposed source record is expanded and drawn;
- the keyboard matrix is sampled directly to decide whether to continue.

## Important ideas for later chapters

- source records are packed consecutively without a line-address index;
- forward movement reads the current record's header and variable stream;
- backward movement uses the preceding record's terminal marker;
- variable-record reverse movement is constant-time;
- the active line is a self-modified direct record pointer;
- thirteen permanent records before `sourceBufferAccessLine` provide top display
  padding;
- six records after the latest active position provide bottom display padding;
- `candidate+12 < symbolTableStart` enforces that lower padding;
- every repaint derives the top line by walking thirteen records backward;
- the source window contains twenty records;
- bitmap copying accelerates held-arrow scrolling without changing source
  navigation semantics;
- block selection is represented by two external record pointers;
- insertion, deletion and import must preserve all navigation invariants.

## Source anchors explained

- `getRecordBeforeActiveLine`
- `getPreviousSourceRecord`
- `getRecordAfterActiveLine`
- `getNextSourceRecord`
- `varcSourceBufferActiveLine`
- `sourceBufferStart`
- `sourceBufferPreviousLine`
- `sourceBufferAccessLine`
- `LINES_BEFORE_ACCESS_LINE`
- `moveActiveLineToPreviousSourceRecord`
- `moveActiveLineToNextSourceRecord`
- `.commitActiveLineMoveIfValid`
- `compareHLWithSourceBufferStart`
- `comparePositionWithCodeEnd`
- `renderVisibleSourceRecords`
- `.findTopVisibleSourceRecordLoop`
- `.renderVisibleSourceRecordLoop`
- `copyScreenTextRowAtYToDE`
- `copyEightBitmapRows`
- `writeLineOfCodeAndTestKeyboard`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `getSelectedBlock`
- `testSourceRecordOutsideSelectedBlock` at navigation level
- `pollImportKeyboardAndRefreshIfRequested`
- `abortCommandAndReturnToEditor` at active-pointer repair level
