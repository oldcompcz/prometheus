# Chapter 7: Moving and Comparing Memory

A text editor on a modern computer can ask the operating system for a larger block of memory whenever a document grows. PROMETHEUS cannot. It lives inside one fixed 64-kilobyte address space, most of which is already occupied by ROM, the display, system variables, the resident program, the user's source, symbols, and eventually the assembled result.

When a source line becomes longer, PROMETHEUS does not obtain a new container. It opens a gap inside the existing one.

When lines are deleted, it closes the gap again.

When symbols are inserted in alphabetical order, it moves all following symbol data.

When a selected block is copied, it must be prepared for the source and destination ranges to overlap.

This is why memory movement is not a minor utility hidden at the edge of the program. It is one of the mechanisms that make the editor possible.

The same is true of comparison. PROMETHEUS repeatedly asks questions such as:

- Is this address before the source area?
- Is there enough room below `U-TOP`?
- Does this pointer lie at or after the place where bytes were inserted?
- Has the source cursor moved past the last real record?
- Is the destination above the source, so copying forward would destroy bytes we still need?

On the Z80, these questions are usually answered by subtraction and the carry flag. There is no separate instruction meaning “compare these two 16-bit addresses and return a Boolean.” PROMETHEUS builds that idea from smaller operations.

This chapter follows the complete path from a simple overlap-safe copy routine to source insertion and deletion. Along the way, we will see how PROMETHEUS treats pointers as part of a moving structure rather than isolated numbers.

## The shelf of books problem

Imagine a shelf containing books with no empty space between them:

```text
[A][B][C][D][E][F]
```

Suppose we want to insert two new books before `C`. We must first move `C` through `F` two positions to the right:

```text
[A][B][ ][ ][C][D][E][F]
```

Only after the move may we place the new books into the gap.

Now imagine performing the move one book at a time from left to right:

1. copy `C` into the first new position;
2. copy `D` into the next;
3. continue.

That seems reasonable, but the first copy overwrites the original `E` if source and destination overlap in the wrong direction. The moved copy of `C` may then be copied again as if it were original data. The shelf becomes corrupted.

The safe method is to start at the far end:

1. move `F` first;
2. then `E`;
3. continue backward until `C` has moved.

For deletion, where following bytes move toward lower addresses, copying from the beginning is safe.

This gives the rule used throughout PROMETHEUS:

```text
if destination is above source:
    copy backward
else:
    copy forward
```

The routine applies this conservative rule even when the ranges do not actually overlap. Backward copying is still correct; it is simply the safe choice for every upward move.

## The Z80 already knows how to copy a sequence

The Z80 has block-copy instructions:

- `LDIR` copies forward;
- `LDDR` copies backward.

Both repeatedly copy one byte from `(HL)` to `(DE)` and update the pointers and count in `BC`.

For `LDIR`:

```text
(HL) → (DE)
HL = HL + 1
DE = DE + 1
BC = BC - 1
repeat until BC = 0
```

For `LDDR`, the pointers move downward instead.

PROMETHEUS wraps these instructions in a routine with the useful meaning of the C library function often called `memmove`: copy a range correctly even if source and destination overlap.

```asm
moveMemoryBlockOverlapSafe:
    ld a,b
    or c
    ret z
    push hl
    xor a
    sbc hl,de
    pop hl
    jr c,.moveMemoryBlockBackward
    ldir
    ret
.moveMemoryBlockBackward:
    add hl,bc
    dec hl
    ex de,hl
    add hl,bc
    dec hl
    ex de,hl
    lddr
    ret
```

Its contract is:

```text
HL = source address
DE = destination address
BC = number of bytes
```

The first three instructions test for a zero-length move. `OR C` combines the two halves of the count only for the purpose of setting flags. If both are zero, there is nothing to do.

The next comparison temporarily calculates:

```text
source - destination
```

`XOR A` clears carry before `SBC HL,DE`. If source is below destination, subtraction borrows and carry becomes set. That is the dangerous upward-copy case, so the routine chooses the backward path.

Notice the `PUSH HL` and `POP HL`. The subtraction is used only for its flags. The original source pointer must be restored before copying begins.

## Why backward copying starts at the final byte

`LDDR` expects `HL` and `DE` to point at the last bytes to copy, not the first. The caller supplies the beginning of each range, so PROMETHEUS adjusts both pointers:

```asm
add hl,bc
 dec hl
```

Conceptually:

```text
lastSource = source + length - 1
```

The same calculation is performed for the destination after exchanging `HL` and `DE`.

For a four-byte move:

```text
source begins at S
last source byte = S + 4 - 1 = S + 3
```

The `-1` matters. `source + length` is the address immediately after the range. PROMETHEUS often uses this **exclusive end** convention because it makes lengths easy to calculate:

```text
length = exclusiveEnd - start
```

But `LDDR` needs the inclusive final byte, so the routine decrements once.

## A routine can return an answer in flags while preserving the question

Consider this helper:

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

The routine compares the address in `HL` with the permanent source-buffer starting position. Carry set means the candidate is below that boundary.

Yet it returns with both `HL` and `DE` restored.

This is a common PROMETHEUS pattern:

1. save the values;
2. perform subtraction;
3. restore the values with instructions that do not alter flags;
4. return the comparison result in carry and zero.

`POP` does not change the flags, so the answer survives.

In pseudocode:

```text
function compareWithSourceStart(candidate):
    flags = subtract(candidate, sourceBufferAccessLine)
    return candidate unchanged, flags
```

This is useful because the caller often wants to keep using the candidate address if it is valid.

For example, moving to the previous source record does this:

```asm
call getRecordBeforeActiveLine
call compareHLWithSourceBufferStart
ccf
jr .commitActiveLineMoveIfValid
```

The record pointer remains in `HL`. Only the carry convention is inverted to fit the shared commit path.

## Comparing against a moving upper boundary

The lower source boundary is fixed, but the upper boundary moves as source and symbols grow.

`comparePositionWithCodeEnd` compares a candidate source position against the current symbol-table anchor:

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

The added twelve bytes convert the source-record candidate into the basis used by the editor's layout. The exact displacement belongs to the source-window and tail arrangement described later; the important idea here is that the upper comparison is not against a fixed assembled constant. It uses the current self-modified symbol-table pointer.

The pattern is the same:

```text
adjust candidate to the comparison basis
subtract current moving boundary
restore registers
return flags
```

This separation is valuable. Navigation code does not need to know how the end is represented. It asks a helper whether a proposed position is still valid.

## Opening a gap is more than moving bytes

Suppose the editor has encoded a new source record of six bytes. It wants to insert those bytes at address `P`.

The visible operation sounds simple:

```text
insert six bytes at P
```

But several things must happen:

1. ensure that six more bytes fit below `U-TOP`;
2. move all following source and symbol bytes upward;
3. increase the remembered end of used memory;
4. increase the remembered symbol-table base;
5. repair selected-block pointers if they refer to moved records;
6. copy the new record into the gap.

PROMETHEUS centralizes this work in `insertByteRangeAtHLFromDE`.

Its entry contract is:

```text
HL = insertion address
DE = address of bytes to insert
BC = byte count
```

The parser usually has a one-byte record length in `C`, so the public entry begins by clearing `B`:

```asm
insertByteRangeAtHLFromDE:
    ld b,000h
.insertByteRangeCommon:
```

The block-copy command can enter at `.insertByteRangeCommon` with a full 16-bit length.

## First ask whether the new end is legal

The capacity check is concise:

```asm
ensureBCBytesFitBelowUTop:
    push hl
    push de
    ld hl,(varcCodeEndPt+1)
    add hl,bc
    jr c,.memoryFullError
    ld de,(varcUTop+1)
    sbc hl,de
    pop de
    pop hl
    ret c
```

The proposed new end is:

```text
currentCodeEnd + insertedLength
```

Two failures are possible.

### Failure 1: the addition wraps around

A 16-bit addition larger than `$FFFF` wraps back to the bottom of memory. Carry detects this immediately.

Without the check, an apparently small result could be mistaken for plentiful free memory.

### Failure 2: the result reaches or exceeds U-TOP

`U-TOP` is the exclusive ceiling chosen by the user. The new end must remain strictly below it.

The subtraction:

```text
newEnd - UTop
```

sets carry only when `newEnd < UTop`. That is the success condition.

The routine preserves the caller's `HL` and `DE`; again, only the flags and possible error path matter.

## Calculating the tail that must move

The insertion routine loads the current high end and subtracts the insertion address. The result is the number of existing bytes at or above the insertion point:

```text
tailLength = codeEnd - insertionAddress
```

Then it constructs:

```text
source      = insertionAddress
destination = insertionAddress + insertedLength
length      = tailLength
```

and calls `moveMemoryBlockOverlapSafe`.

Because destination is above source, the move routine selects `LDDR`. The tail is shifted upward without destroying itself.

Afterward the memory looks like this:

```text
before:

low memory                high memory
... [prefix][tail................]
             ^ insertion

move tail upward:

... [prefix][gap][tail................]
             ^   ^
             P   P + insertedLength
```

Only then can the new bytes be copied into the gap with `LDIR`.

## Pointers are part of the structure

Moving the bytes is not enough. PROMETHEUS stores several addresses that point into the moved region.

The most important are:

- `varcCodeEndPt+1` — the high end of used source/symbol memory;
- `varcSymbolTablePt+1` — the moving symbol-table base;
- `varcSelectedBlockStart+1` — one selected-block boundary;
- `varcSelectedBlockEnd+1` — the other boundary.

The first two always move upward by the inserted byte count:

```asm
ld hl,varcCodeEndPt+1
call increaseAtHLbyBC
ld hl,varcSymbolTablePt+1
call increaseAtHLbyBC
```

The helper reads a little-endian word from memory, adds `BC`, and writes it back:

```asm
increaseAtHLbyBC:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    add hl,bc
.atDEminusOnePutHLAndRet:
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ret
```

This is another example of code operating on the operand bytes of self-modifying instructions. `HL` initially points not to an ordinary variable declaration but to the low byte of a stored immediate address.

The selected-block pointers need a conditional adjustment. A pointer below the insertion stays valid; a pointer at or above it must follow the shifted bytes.

```asm
adjustPointerAtHLIfAtOrAfterInsertion:
    push hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
varcInsertionPointForPointerAdjustment:
    ld de,defaultPointerAdjustmentSentinel
    and a
    sbc hl,de
    pop hl
    ret c
    jr increaseAtHLbyBC
```

Pseudocode:

```text
storedPointer = wordAt(pointerCell)
if storedPointer >= insertionPoint:
    storedPointer += insertedLength
```

The insertion point itself is remembered in the operand of `varcInsertionPointForPointerAdjustment`. The same helper can therefore repair both block boundaries.

## Why equality moves the pointer

Suppose a selected block begins exactly at the insertion address. After opening a gap before that record, the original record now starts later. Its pointer must increase.

Therefore the condition is:

```text
pointer >= insertion point
```

not merely:

```text
pointer > insertion point
```

Subtraction provides exactly this distinction. Carry means “strictly below.” If carry is clear, equality and greater-than both take the adjustment path.

## Copying a selected block adds one extra puzzle

The `COPY` command uses the same insertion primitive, but its source bytes already live inside the source area that is about to move.

Imagine copying a block located above the insertion point. Opening the gap shifts that original block upward before the final `LDIR` copies it. If the source pointer is not corrected, PROMETHEUS would copy from the old address, which now contains different bytes.

`invokeCopy` therefore checks the relationship between:

- selected block start;
- selected block end;
- insertion point.

It first rejects an insertion point inside the selected block. Copying a range into its own interior would make the intended source ambiguous during the move.

Then, if the source lies at or above the insertion point, it adds the new gap length to the source pointer before entering `.insertByteRangeCommon`.

In simplified pseudocode:

```text
blockStart, blockEnd = normalizedSelection()
insertion = activeLine

if insertion is inside [blockStart, blockEnd]:
    reject

length = addressAfter(blockEnd) - blockStart

if blockStart >= insertion:
    blockStart += length

insertBytes(insertion, blockStart, length)
```

The important insight is that the source pointer describes bytes **after the movement**, because the movement occurs before the final copy.

## Deletion starts with records and ends with bytes

The public deletion routine receives:

```text
HL = first compressed source record
BC = number of records
```

But memory movement needs a byte length.

Source records are variable-sized, so PROMETHEUS walks forward record by record:

```asm
.findEndOfDeletedLineRangeLoop:
    call getNextSourceRecord
    dec bc
    ld a,b
    or c
    jr nz,.findEndOfDeletedLineRangeLoop
```

After the loop:

```text
HL = first byte after deleted records
DE = deletion start
```

The byte count is:

```text
deletedLength = end - start
```

This is a good example of separating the user-facing unit from the storage unit.

The editor says “delete three lines.”

The storage engine says “remove seventeen bytes beginning here.”

## Closing the gap

To delete a range, all bytes after it move downward:

```text
before:

[prefix][deleted bytes][tail........]
         ^             ^
         start         end

after:

[prefix][tail........][unused]
```

The source is the old end of the deleted range. The destination is the old start. Destination is below source, so `moveMemoryBlockOverlapSafe` chooses forward `LDIR`.

Once the tail has moved, PROMETHEUS clears the vacated bytes at the high end:

```asm
.clearVacatedSourceBytesLoop:
    xor a
    ld (de),a
    inc de
    dec bc
    ld a,b
    or c
    jr nz,.clearVacatedSourceBytesLoop
```

Clearing is not strictly required for the movement itself. The code-end pointer already says those bytes are unused. But zeroing stale data gives the surrounding workspaces a predictable state and avoids leaving old encoded records visible beyond the logical end.

## Repairing pointers after deletion

The high-end pointers always decrease by the deleted byte count:

```asm
ld hl,varcCodeEndPt+1
call subtractBCFromPointerAtHL
ld hl,varcSymbolTablePt+1
```

The selected-block boundaries are conditionally repaired by `adjustPointerAtHLForDeletion`.

Its comparison asks whether a stored pointer is above the deletion start. If so, the pointer is reduced by the deleted length.

The command-level deletion logic then collapses both selected boundaries onto a surviving record:

```asm
ld (varcSelectedBlockStart+1),hl
ld (varcSelectedBlockEnd+1),hl
ld (varcSourceBufferActiveLine+1),hl
```

This division of responsibility is useful:

- the low-level deletion routine compacts bytes and performs general pointer arithmetic;
- the `DELETE` command chooses the sensible surviving editor selection afterward.

The reader should not expect every semantic editor decision to be hidden inside the generic memory primitive.

## Empty records preserve the editor's floor

PROMETHEUS keeps a small cushion of empty compressed records around the permanent access-line area. If a user deletes the entire program, the editor must still have valid records to display and navigate.

`deleteSourceLinesAndRestoreTailPadding` therefore checks whether the source end has retreated too close to `sourceBufferAccessLine`. If necessary, it repeatedly inserts a two-byte empty record.

In pseudocode:

```text
delete requested records
while source end is too close to permanent access line:
    insert one empty two-byte record
```

This illustrates an important rule:

> A memory operation may preserve the bytes correctly and still violate a higher-level structural invariant.

The padding loop restores that invariant.

## Inclusive selections and exclusive byte ranges

PROMETHEUS uses both inclusive and exclusive concepts, and confusing them causes off-by-one errors.

A selected block is described by two record starts and is inclusive:

```text
first selected record ... last selected record
```

To calculate its byte length, the program advances once beyond the last record:

```text
exclusiveEnd = getNextSourceRecord(lastSelected)
length = exclusiveEnd - firstSelected
```

This pattern is safer than trying to find the final byte of a variable-length record.

It appears in `invokeCopy` and in selected-block deletion.

The general rule is:

```text
human selection: inclusive records
memory move: [start, exclusiveEnd)
```

The bracket notation means the start is included and the end is not.

## Carry is not always “error”

In PROMETHEUS, carry can mean many things depending on the routine contract:

- candidate address is below a boundary;
- a range lies inside a protection window;
- a symbol was not found;
- a text match succeeded;
- an addition overflowed;
- an insertion still fits below `U-TOP`.

This is why reading only one instruction after a `CALL` is dangerous. A branch such as `JR C` has no universal English translation. You must know what the called routine promised to leave in carry.

For memory comparisons, the common pattern is unsigned subtraction:

```text
clear carry
SBC left,right
```

Then:

```text
carry set   → left < right
zero set    → left = right
carry clear and zero clear → left > right
```

Addresses are treated as unsigned 16-bit numbers. Address `$F000` is above `$7000`, not a negative number.

## Why PROMETHEUS does not use a large pointer registry

A more general editor might keep every internal pointer in a table and run one universal relocation pass after each insertion or deletion.

PROMETHEUS instead updates the few pointers relevant to each operation directly.

For insertion, this includes:

- code end;
- symbol-table base;
- selected block start;
- selected block end;
- sometimes a source pointer held by the caller.

Other subsystems repair their own structures when they insert data. Symbol insertion, for example, also adjusts ordinal-vector offsets because those are relative positions inside the symbol area, not ordinary source pointers.

This approach is less abstract but smaller. There is no descriptor table explaining every resident pointer. The cost is that each memory-changing routine must know exactly which structures it can disturb.

## A complete insertion in pseudocode

We can now reconstruct the generic insertion algorithm without register noise:

```text
function insertByteRange(insertion, sourceBytes, length):
    proposedEnd = codeEnd + length

    if proposedEnd overflowed or proposedEnd >= UTop:
        report "Memory full"

    tailLength = codeEnd - insertion

    memmove(
        source      = insertion,
        destination = insertion + length,
        length      = tailLength
    )

    codeEnd       += length
    symbolTablePt += length

    if selectedBlockStart >= insertion:
        selectedBlockStart += length

    if selectedBlockEnd >= insertion:
        selectedBlockEnd += length

    copy sourceBytes into insertion for length bytes
```

The source-line parser and block-copy command differ mainly in how they prepare `sourceBytes`, `length`, and the insertion point.

## A complete deletion in pseudocode

```text
function deleteSourceRecords(firstRecord, recordCount):
    deletionStart = firstRecord
    deletionEnd = firstRecord

    repeat recordCount times:
        deletionEnd = nextRecord(deletionEnd)

    deletedLength = deletionEnd - deletionStart
    tailLength = codeEnd - deletionEnd

    memmove(
        source      = deletionEnd,
        destination = deletionStart,
        length      = tailLength
    )

    clear the deletedLength bytes now unused at the high end

    repair selected-block pointers
    codeEnd       -= deletedLength
    symbolTablePt -= deletedLength
```

The command wrapper then selects a valid surviving record and restores empty tail records if the source became too short.

## Why the order of repairs matters

Consider insertion. The tail must move before the new bytes are copied, because the new bytes may come from a temporary buffer that does not overlap the source region. But the pointer adjustments can occur after the move and before the final copy because they affect metadata, not the bytes being transferred.

For a block copy, the source pointer itself may be shifted by opening the gap. `invokeCopy` adjusts that pointer before calling the insertion core.

For deletion, the routine must remember both the deletion start and the deleted byte length before moving the tail, because the original record positions disappear after compaction.

A safe memory transformation therefore has three phases:

```text
1. Measure and remember
2. Move bytes
3. Repair metadata and invariants
```

Trying to rediscover the old boundaries after phase 2 would be much harder.

## Back to the whole machine

In Chapter 3, source and symbols appeared as two neighbouring dynamic regions. We can now see how they remain neighbours while the editor changes them.

A new source record opens a gap below the symbol table. The symbol table and code-end pointers move upward. Selected source pointers follow if necessary.

A deletion closes a gap. The tail, including symbol data, slides downward. The high-end pointers shrink.

A new symbol name performs a similar movement inside the symbol area and repairs its own vector offsets.

The installer later uses the same direction-aware idea to copy the complete resident image safely even when load and destination regions overlap.

The screen scroller uses a smaller specialized copy because Spectrum bitmap rows are interleaved rather than linear.

So the central idea is broader than `LDIR` versus `LDDR`:

> PROMETHEUS treats memory as a set of structures whose bytes and pointers must move together.

## What has changed in memory?

After a generic insertion of `N` bytes:

- all bytes from the insertion point through the old code end have shifted upward by `N`;
- `varcCodeEndPt` has increased by `N`;
- `varcSymbolTablePt` has increased by `N`;
- selected-block pointers at or above the insertion have increased by `N`;
- the new bytes occupy the opened gap.

After deletion:

- all bytes after the deleted range have shifted downward;
- the vacated high bytes have been cleared;
- code-end and symbol-table pointers have decreased;
- editor selection pointers have been repaired or reset by the command wrapper;
- empty source records may have been reinserted to preserve the editor's minimum layout.

## Important ideas for later chapters

- `LDIR` and `LDDR` are the foundation of safe structural movement.
- unsigned 16-bit comparison is usually expressed through `SBC HL,DE` and flags.
- PROMETHEUS often preserves compared values while returning only flags.
- source selections are inclusive, but memory ranges are most easily measured with an exclusive end.
- byte movement must be followed by pointer repair.
- high-level invariants, such as permanent empty source records, may require work beyond the raw move.

## Source anchors explained

- `moveMemoryBlockOverlapSafe`
- `ensureBCBytesFitBelowUTop`
- `insertByteRangeAtHLFromDE`
- `.insertByteRangeCommon`
- `adjustPointerAtHLIfAtOrAfterInsertion`
- `varcInsertionPointForPointerAdjustment`
- `increaseAtHL`
- `increaseAtHLByTwo`
- `increaseAtHLbyBC`
- `deleteSourceLinesAtHL`
- `subtractBCFromPointerAtHL`
- `adjustPointerAtHLForDeletion`
- `varcDeletionStartForPointerAdjustment`
- `deleteSourceLinesAndRestoreTailPadding`
- `compareHLWithSourceBufferStart`
- `comparePositionWithCodeEnd`
- `invokeCopy`
- `invokeDelete`
