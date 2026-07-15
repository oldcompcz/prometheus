# Chapter 16: Making Space and Closing Gaps

The editor has now learned how to understand a source line, store it as a
compressed record, reconstruct it, and move from one record to another. One
large practical question remains:

> What happens when a new record is not the same size as the old one?

PROMETHEUS cannot ask an operating system for a fresh block of memory. It owns
one tightly packed region containing source records followed immediately by the
symbol table. To insert three bytes near the beginning, it may need to move
thousands of later bytes upward. To delete a record, it must close the hole,
move the symbol table downward, and repair every remembered address that has
moved.

This sounds like a large collection of special cases. The source instead builds
most editing operations from two general transformations:

```text
insertion:
    open a gap
    move later bytes upward
    repair pointers
    copy new bytes into the gap

deletion:
    measure the removed records
    move later bytes downward
    repair pointers
    clear the unused tail
```

The difficult part is not copying bytes. Chapter 7 already introduced the
`LDIR`/`LDDR` mover that performs the physical copy safely. The difficult part
is preserving the *meaning* of all the pointers around those bytes.

## One packed region with several meanings

The dynamic area can be pictured like this:

```text
low addresses

compressed source records
    active-line pointer points somewhere here
    selected-block pointers point somewhere here

symbol-table count and ordinal vectors
alphabetically stored symbol entries
small protected tail

high addresses
```

Two self-modified pointers describe its moving boundaries:

- `varcSymbolTablePt` marks where the symbol table currently begins;
- `varcCodeEndPt` marks the high end of the combined source/symbol storage.

Neither address is fixed. Adding source pushes both upward. Removing source pulls
both downward. The source itself therefore has no independent allocation: it
grows by moving everything after the insertion point.

The editor also remembers addresses *inside* the source:

- `varcSourceBufferActiveLine`;
- `varcSelectedBlockStart`;
- `varcSelectedBlockEnd`;
- FIND's continuing scan position;
- temporary command-specific pointers.

Not every one is repaired by the same primitive. Some are persistent structural
pointers and are updated centrally. Others are owned by a command, which knows
what the pointer should mean after the operation and sets it explicitly.

That distinction will matter throughout this chapter.

## Before growing, ask U-TOP

Every insertion begins by checking whether the enlarged region would still fit
below the configurable user-memory ceiling, U-TOP.

The real routine is compact:

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

`BC` is the number of bytes to add. The routine calculates:

```text
proposedEnd = currentEnd + byteCount
```

There are two ways this can fail.

First, 16-bit addition might wrap from a high address back to a low one. The Z80
sets carry in that case, and PROMETHEUS reports memory full immediately.

Second, the proposed end may reach or cross U-TOP. The final subtraction returns
carry only when:

```text
proposedEnd < U-TOP
```

The comparison is strict. U-TOP is a boundary, not a byte available to the
source region.

This check happens before any bytes move. A failed insertion therefore leaves
the packed source and symbol table unchanged.

## Opening a gap

The principal insertion entry is:

```asm
insertByteRangeAtHLFromDE:
    ld b,000h
.insertByteRangeCommon:
    push de
    push hl
    call ensureBCBytesFitBelowUTop
    ...
```

Its public contract is:

```text
HL = address where the gap begins
DE = address of bytes to insert
BC = byte count
```

The parser normally has a record length only in `C`, so the named entry clears
`B`. Block COPY already has a full 16-bit byte count and jumps directly to the
common body.

Suppose memory currently looks like this:

```text
A | B | C | D | symbol table | tail
        ^ insertion point
```

and the new record has length `N`. The desired result is:

```text
A | B | gap of N bytes | C | D | symbol table | tail
```

The routine calculates the length from the insertion point through
`varcCodeEndPt`, then asks `moveMemoryBlockOverlapSafe` to shift that complete
half-open suffix—up to but not including the current end boundary—upward by
`N` bytes.

In pseudocode:

```text
suffixLength = codeEnd - insertionPoint
move(
    source      = insertionPoint,
    destination = insertionPoint + N,
    length      = suffixLength
)
```

Because destination is above source and the ranges normally overlap, the mover
uses `LDDR`: it begins at the high end and works backward. If it copied forward,
the first bytes written would destroy source bytes that had not yet been read.

## Why the source bytes are saved before movement

The insertion bytes may themselves live inside the region that is about to
move. COPY certainly does this: its source is a selected block of compressed
records already in the source area.

The insertion routine preserves the original source and insertion addresses on
the stack before opening the gap. The COPY command may additionally correct its
source address in advance when the selected bytes will be shifted by the gap
creation.

This is a useful general lesson:

> A correct `memmove` protects the bytes being shifted, but it does not
> automatically repair a separate pointer that names those bytes.

PROMETHEUS treats those as two different problems.

## Repairing the moving boundaries

After the suffix has moved upward, two region boundaries must always move by the
same byte count:

```asm
ld hl,varcCodeEndPt+1
call increaseAtHLbyBC
ld hl,varcSymbolTablePt+1
call increaseAtHLbyBC
```

The helper reads a little-endian word, adds `BC`, and writes it back.

Conceptually:

```text
codeEnd       += N
symbolTablePt += N
```

The symbol table's contents do not need reinterpretation. Every byte of the
whole table has moved together. Only the external pointer to its beginning and
the external pointer to the combined end must change.

## Repairing block boundaries conditionally

A selected-block endpoint moves only when it lies at or above the insertion
point. A boundary below the new gap still names the same physical record at the
same address.

The insertion operation stores its boundary in a self-modified operand:

```asm
varcInsertionPointForPointerAdjustment:
    ld de,defaultPointerAdjustmentSentinel
```

Then it calls the same helper for both selection pointers:

```asm
ld hl,varcSelectedBlockStart+1
call adjustPointerAtHLIfAtOrAfterInsertion
ld hl,varcSelectedBlockEnd+1
call adjustPointerAtHLIfAtOrAfterInsertion
```

The helper's logic is:

```text
pointer = word stored at HL

if pointer >= insertionPoint:
    pointer += insertedByteCount
```

The real comparison subtracts the insertion point from the stored pointer and
returns without changing it when carry says the pointer was below the gap.

This policy is exactly what a record-start pointer needs. If a new record is
inserted before an existing selected line, that line's bytes move upward and its
pointer follows. If insertion occurs after the selected line, the pointer stays
where it is.

## Why the active-line pointer is not repaired here

You may have noticed that `insertByteRangeAtHLFromDE` repairs the two selected
block endpoints but not `varcSourceBufferActiveLine`.

That is deliberate. The insertion primitive knows only that bytes are being
inserted. It does not know what the editor wants to become active afterward.

For ordinary source entry, the intended result is:

```text
newly inserted record becomes active
```

The caller therefore stores the insertion address explicitly:

```asm
call insertByteRangeAtHLFromDE
pop hl
ld (varcSourceBufferActiveLine+1),hl
```

For COPY, DELETE, tape import, or REPLACE, the desired active line can be
different. Those commands choose it themselves.

This separation keeps the byte mover general. It repairs structural boundaries
whose meaning is invariant, while the higher-level operation repairs user
interface state according to its own semantics.

## Filling the opened gap

Only after memory and pointers have moved does the insertion routine return to
the saved arguments and execute:

```asm
pop de
pop hl
ldir
```

At this moment:

```text
HL = gap start
DE = source bytes, corrected by caller when necessary
BC = insertion length
```

The gap is empty space inside the packed area, so an ordinary forward `LDIR` is
appropriate for filling it.

The complete insertion can be summarized as:

```text
check capacity
move packed suffix upward
move code-end pointer upward
move symbol-table pointer upward
repair selected-block pointers at/after gap
copy requested bytes into gap
```

## Inserting a newly parsed source record

Chapter 13 followed text into `encodedRecordStorageLength` and the staged
encoded bytes. The editor then inserts the new record immediately after the
current active record:

```asm
call getRecordAfterActiveLine
push hl
ld (varcInsertionPointForPointerAdjustment+1),hl
ld de,encodedRecordStorageLength
ld a,(de)
ld c,a
inc de
call insertByteRangeAtHLFromDE
pop hl
ld (varcSourceBufferActiveLine+1),hl
```

The staged buffer begins with a copy count, followed by the persistent record.
The count byte itself is not inserted.

In pseudocode:

```text
insertionPoint = nextRecord(active)
length = stagedRecord.length
bytes = stagedRecord.payload

insert(insertionPoint, bytes, length)
active = insertionPoint
```

This is INSERT mode: the old active record survives and the new one appears
below it.

## OVERWRITE is implemented as insert, then delete

PROMETHEUS does not need a separate “resize this record in place” routine.
OVERWRITE reuses insertion and deletion:

```text
1. insert the new compressed record after the old active record
2. make the new record active
3. step back to the old record
4. delete exactly that old record
5. the new record slides down into its place
```

The source fragment is:

```asm
varcInsertMode:
    ld a,000h
    or a
    jr z,.finishSourceLineInsertion
    call getRecordBeforeActiveLine
    ld (varcSourceBufferActiveLine+1),hl
    ld bc,00001h
    call deleteSourceLinesAtHL
```

This is a fine example of building a complicated visible operation from simple
memory transformations.

It also handles size changes naturally. The replacement record may be shorter
or longer than the original. Insertion first guarantees enough room for the new
record; deletion then removes the exact byte length of the old one.

## Deletion begins with records, then becomes bytes

The deletion API is expressed in source records:

```text
HL = first record to delete
BC = number of records
```

But memory movement requires a byte count. `deleteSourceLinesAtHL` therefore
walks forward `BC` records using `getNextSourceRecord`.

If deletion starts at address `start` and the walk ends at `end`, then:

```text
removedBytes = end - start
```

This is why the record format's forward traversal is part of the mutation
engine. The editor does not need to calculate the length of every record
separately; it asks where the record after the deleted range begins.

## Closing the gap

After measuring the range, the routine moves everything from `end` through the
combined code end down to `start`:

```text
before:
    prefix | bytes to delete | later source | symbol table | tail

move:
    later source | symbol table | tail
        downward over bytes to delete

after:
    prefix | later source | symbol table | tail | unused bytes
```

The destination is below the source, so `moveMemoryBlockOverlapSafe` selects
forward `LDIR`. Reading from low to high is safe in this direction.

The common mover does not care that some bytes are source records and later
bytes are symbol data. It sees one continuous suffix.

## Clearing the vacated high end

Compaction leaves `removedBytes` stale bytes above the new end. PROMETHEUS
clears every one to zero:

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

Those bytes are no longer part of the live source or symbol table, so correctness
does not require their old values. Clearing them has practical benefits:

- old source fragments do not remain as confusing debris;
- later workspaces begin from predictable zeroes;
- accidental scans beyond the live end are less likely to appear meaningful.

On a memory-constrained machine, unused does not mean physically absent. It
means “outside the current boundary.” Clearing makes that boundary visible in
the bytes as well as in the pointers.

## Repairing pointers after deletion

Deletion moves later bytes downward. The simple repair helper uses the stored
deletion start:

```asm
varcDeletionStartForPointerAdjustment:
    ld hl,09c28h
```

For each selected-block endpoint, it performs the equivalent of:

```text
if pointer > deletionStart:
    pointer -= removedBytes
```

A pointer at or below the deletion start remains unchanged.

This helper is intentionally mechanical. It knows nothing about whether a
selection endpoint was *inside* the removed block or after it. It only follows
the physical movement rule. A high-level destructive command, such as block
DELETE, subsequently gives the block pointers a new semantic value.

That is another important distinction:

```text
physical repair:
    make an address follow moved bytes

semantic repair:
    decide what the editor state should mean after those bytes no longer exist
```

The common deletion routine performs the first. Its caller may perform the
second.

Finally, the two dynamic region boundaries are reduced unconditionally:

```text
codeEnd       -= removedBytes
symbolTablePt -= removedBytes
```

The symbol table has physically moved downward by exactly that amount.

## Restoring the permanent empty tail

Deleting a large range—even the complete user program—could make the source too
short to preserve the six records needed below the access line.

`deleteSourceLinesAndRestoreTailPadding` wraps the basic deletion routine. After
compaction it repeatedly tests the permanent access-line area. While the source
end is too low, it inserts another fixed two-byte empty record:

```asm
.ensureSourceTailPaddingLoop:
    ld hl,sourceBufferAccessLine
    call comparePositionWithCodeEnd
    jr c,.sourceTailPaddingRestored
    ld d,h
    ld e,l
    ld c,002h
    call insertByteRangeAtHLFromDE
    jr .ensureSourceTailPaddingLoop
```

`HL` and `DE` both point to an existing empty record, so the insertion copies
that two-byte `$00,$30` form.

The loop is wonderfully economical. Rather than owning a separate constant for
an empty record, it duplicates the already present access-line record until the
navigation invariant has been restored.

## Deleting the active line with one key

The immediate delete key removes exactly one compressed record:

```asm
ld bc,00001h
ld hl,(varcSourceBufferActiveLine+1)
call deleteSourceLinesAndRestoreTailPadding
```

Afterward the editor chooses a nearby survivor:

```text
if deletion began at earliest legal active line:
    keep that address active
else:
    move to the previous surviving record
```

Why does the original address often remain useful? Because the following record
has slid down into the deleted record's old address. At the first legal record,
that is the most natural survivor. Elsewhere, the editor deliberately steps one
record back so the cursor stays near the line above the deletion.

Again, the common byte routine does not decide this. The key handler does.

## Deleting an inclusive selected block

The DELETE command first normalizes the two block endpoints. It then counts
records inclusively from the lower endpoint through the upper endpoint:

```text
count = 1
record = lower

while record < upper:
    record = next(record)
    count++
```

It passes that record count to `deleteSourceLinesAndRestoreTailPadding`.

Once the bytes are gone, the command chooses the surviving record nearest the
removed range. It then collapses all three editor pointers onto that survivor:

```text
selectedBlockStart = survivor
selectedBlockEnd   = survivor
activeLine         = survivor
```

This is semantic repair. A selection cannot continue to describe a block that
no longer exists, so it becomes a one-line selection at the new active record.

## COPY and the moving source pointer

COPY is more delicate because the bytes to insert already live in the packed
region.

The command obtains:

```text
low  = first selected record
high = last selected record
end  = record after high
size = end - low
```

The gap opens at the active record, so the copied block appears immediately
before it.

The command rejects an active insertion point strictly inside the selected
range. The lower boundary itself is a useful special case: because the gap opens
*before* that record, copying at the first selected line can duplicate the block
in place without reading from the new gap.

Before the common insertion moves memory, COPY asks whether the selected source
lies at or above the insertion point.

If so, opening the gap will move the original selected bytes upward by `size`.
The source pointer must therefore also be increased by `size` before the final
copy.

In pseudocode:

```text
copySource = low

if copySource >= insertionPoint:
    copySource += size

insert(
    insertionPoint,
    copySource,
    size
)
```

This is the kind of correction that `memmove` cannot invent. The mover preserves
bytes; COPY preserves the identity of the selected block.

## A worked insertion example

Imagine four records with byte lengths 2, 5, 3 and 4:

```text
R0 at $A000, length 2
R1 at $A002, length 5
R2 at $A007, length 3
R3 at $A00A, length 4
symbol table at $A00E
```

A new six-byte record is inserted before `R2`, at `$A007`.

Before:

```text
$A000 R0
$A002 R1
$A007 R2
$A00A R3
$A00E symbol table
```

After moving the suffix upward by six:

```text
$A000 R0
$A002 R1
$A007 gap
$A00D R2
$A010 R3
$A014 symbol table
```

The routine then fills `$A007..$A00C` with the new record.

Pointer consequences:

```text
symbolTablePt += 6
codeEnd       += 6
any selected endpoint >= $A007 += 6
activeLine is set explicitly by caller
```

The packed record sequence remains valid because all later bytes moved together.

## A worked deletion example

Now delete `R1` and the six-byte new record. Suppose their combined byte length
is eleven.

The deletion walk begins at `$A002` and ends at the record after the new record,
`$A00D`.

The suffix beginning at `$A00D` moves down to `$A002`:

```text
before:
R0 | R1 + new | R2 | R3 | symbols

move down eleven bytes

after:
R0 | R2 | R3 | symbols | cleared tail
```

The dynamic boundaries decrease by eleven. A block endpoint above `$A002`
follows the physical movement by subtracting eleven. The deleting command then
chooses and stores a meaningful surviving selection.

## Why no record index is needed

A line-address index would make some operations easier, but it would create
another structure to move and repair.

PROMETHEUS instead derives everything from the packed records:

- record count becomes byte length by traversal;
- insertion address is a record start;
- deletion end is found by walking records;
- block byte size is `next(upper)-lower`;
- neighboring survivors are found with the same forward/backward navigation
  routines used by the editor.

The record sequence is both data and index.

## Back to the whole editor

When the user enters one new source line, the visible event is tiny. Underneath,
PROMETHEUS may:

1. verify room below U-TOP;
2. move every later live source and symbol byte upward;
3. move the symbol-table and code-end boundaries;
4. move selected-block endpoints that lie above the insertion;
5. copy the encoded record into the new gap;
6. choose the new active record;
7. possibly delete the old record for OVERWRITE mode;
8. redraw the source window from the repaired chain.

The editor works because every layer keeps a clear responsibility:

- the parser creates valid record bytes;
- the mover preserves overlapping byte ranges;
- the insertion/deletion engine preserves packed-region structure;
- pointer helpers follow physical movement;
- command handlers restore user-interface meaning;
- navigation assumes all of those invariants are now true.

This is the hidden machinery behind the ordinary act of adding or removing a
line.

## What has changed in memory?

After insertion:

- the packed suffix from the insertion point through code end has moved upward;
- the new bytes occupy the opened gap;
- `varcSymbolTablePt` and `varcCodeEndPt` have increased;
- selected-block endpoints at or above the insertion have increased;
- the caller has chosen a new active-line value;
- the source remains followed immediately by the symbol table.

After deletion:

- the byte range covering the requested records has disappeared;
- the later source and symbol bytes have moved downward;
- the vacated high bytes have been cleared;
- dynamic region boundaries have decreased;
- selected-block addresses above the deletion start have been mechanically
  shifted;
- the caller has restored meaningful active and block pointers;
- empty tail records have been reinserted when necessary.

## Important ideas for later chapters

- source and symbol data form one packed moving region;
- insertion and deletion are byte transformations built from record traversal;
- U-TOP is checked before growth;
- `moveMemoryBlockOverlapSafe` preserves overlapping bytes but not external
  pointer meaning;
- region boundaries always follow the complete packed suffix;
- selected-block pointers receive central physical repair;
- active-line state is chosen by the high-level caller;
- OVERWRITE is implemented as insert-new then delete-old;
- deletion counts records first and computes bytes second;
- physical pointer repair and semantic editor repair are different jobs;
- permanent empty records are restored after large deletion;
- COPY must correct its source pointer when opening the gap moves the selected
  bytes.

## Source anchors explained

- `ensureBCBytesFitBelowUTop`
- `insertByteRangeAtHLFromDE`
- `.insertByteRangeCommon`
- `varcInsertionPointForPointerAdjustment`
- `adjustPointerAtHLIfAtOrAfterInsertion`
- `increaseAtHL`
- `increaseAtHLByTwo`
- `increaseAtHLbyBC`
- `deleteSourceLinesAtHL`
- `.findEndOfDeletedLineRangeLoop`
- `.clearVacatedSourceBytesLoop`
- `subtractBCFromPointerAtHL`
- `adjustPointerAtHLForDeletion`
- `varcDeletionStartForPointerAdjustment`
- `deleteSourceLinesAndRestoreTailPadding`
- `.ensureSourceTailPaddingLoop`
- `parseAndInsertSourceLine` at mutation level
- `varcInsertMode` at commit level
- `.checkDeleteActiveLineKey`
- `invokeCopy` at memory-mutation level
- `invokeDelete` at memory-mutation level
