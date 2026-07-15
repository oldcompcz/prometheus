# Chapter 24: Creating, Deleting and Compacting Symbols

The symbol table from Chapter 23 is compact because it has no slack space and no
redundant names. Compactness creates work whenever the collection changes.

Adding a symbol may require:

- appending a new ordinal vector;
- inserting a value/name record in the middle of alphabetical data;
- moving all bytes above the insertion point;
- adjusting vectors whose records moved.

Removing a symbol is harder still. The corresponding vector disappears, so all
later ordinals change. Source records that refer to those ordinals must be found
and rewritten.

PROMETHEUS performs these operations directly in packed memory. There is no
separate rebuilt copy of the table and no heap allocator that quietly returns a
new object. The program opens and closes exact gaps, repairs every affected
reference and keeps working in the same memory region.

This chapter is therefore about more than symbols. It is about maintaining
**identity while representation moves**.

## A symbol is often created before it is defined

Suppose the programmer enters:

```asm
        JR LOOP
```

and `LOOP` does not yet exist.

The line cannot store the spelling repeatedly, and it cannot store a final
address because the label has not been defined. `findOrCreateSymbolOrdinal`
therefore creates an undefined symbol and returns its new ordinal.

The source record can immediately contain:

```text
SYMBOL(LOOP ordinal)
```

Later, when pass one reaches:

```asm
LOOP    RET
```

it sets the same vector's DEFINED flag and writes the current logical address
into the value word.

Creation establishes identity. Definition supplies a value. They are separate
events.

## Existing names take the easy path

The creation routine first calls the ordinary lookup:

```asm
findOrCreateSymbolOrdinal:
    call parseSymbolNameAndFindOrdinal
    ret nc
```

Carry clear means the spelling already exists, so the ordinal is returned
without changing the table.

This is the usual path for repeated references. A symbol may appear many times
in source, but it is created only once.

Carry set means the normalized name remains in `numberStringBuffer`, ready for
insertion. The routine then begins a carefully ordered set of memory changes.

## Before movement, check the ceiling

The table shares space with compressed source and must remain below U-TOP.
Creation first reserves enough room for its worst immediate needs:

```asm
varcCodeEndPt:
    ld hl,codeEndDefaultPt
    ld bc,0000ch
    call ensureBCBytesFitBelowUTop
```

The fixed twelve-byte check is conservative for the largest permitted name and
its associated vector/value overhead.

The exact table growth for a name of length `L` is:

```text
2 bytes  new ordinal vector
2 bytes  value word
L bytes  high-bit-terminated name
```

so:

```text
total growth = L + 4
```

PROMETHEUS checks capacity before it starts moving bytes. An error after half an
insertion would be much harder to recover from.

## The temporary creation record

The normalized name already sits in temporary workspace. The bytes beginning at
`symbolEntryCreationPrefix` are used as a staging record:

```text
$00
name length temporarily present in workspace
normalized name characters...
```

When copied into the table, the first two bytes become the undefined value word.
The apparent temporary length byte is not a persistent length field. It is later
overwritten when the symbol receives a value.

The final name character already has bit 7 set, so the new record is immediately
compatible with the permanent alphabetical representation.

This is a compact trick: workspace bytes are arranged so that the same sequence
can be copied directly into its final structural role.

## First make room for a new vector

The new ordinal must be appended after all existing vectors. But the
alphabetical record area begins immediately after the vector array, so adding two
vector bytes shifts the entire record area upward.

The patched operand at `varcNewSymbolVectorSlot+1` identifies the place where
the new vector will be opened.

The routine calculates the length from that slot to the current end and performs
an overlap-safe upward move:

```asm
varcNewSymbolVectorSlot:
    ld de,00000h
    xor a
    sbc hl,de
    ld b,h
    ld c,l
    ld h,d
    ld l,e
    inc de
    inc de
    call moveMemoryBlockOverlapSafe
```

After this move:

```text
old vectors remain in place
new two-byte empty vector slot exists at their end
all alphabetical records have moved upward by two bytes
```

`varcCodeEndPt+1` is increased by two.

Because the vector offsets are measured from a name anchor that also moves with
the expanded vector array, this first whole-entry-area shift does not by itself
change the relative positions represented by existing offsets. The later
alphabetical insertion does.

## Then find the alphabetical position

The routine walks physical value/name records in spelling order and compares the
new normalized name character by character.

It chooses the first record whose name is greater than the new one:

```text
new ALPHA before stored LOOP
new LOOP before stored SCREEN
new ZED after every existing record
```

The comparison masks the high terminator bit from visible characters. It also
handles prefixes correctly:

```text
A comes before AB
LOOP comes before LOOP2
```

The broad algorithm is:

```text
insertionPoint = endOfRecordArea
for each stored record alphabetically:
    if newName < storedName:
        insertionPoint = this record
        break
```

The new ordinal does not depend on this alphabetical position. It is simply the
new symbol count. This is the crucial separation between identity order and
name order.

## Open the value/name gap

The physical record requires `nameLength + 2` bytes. PROMETHEUS calculates the
number of bytes above the chosen insertion point, moves them upward, advances
`varcCodeEndPt`, and copies the staged record into the gap.

Conceptually:

```text
before:
    ALPHA record
    LOOP record
    SCREEN record

insert BETA:
    move LOOP and SCREEN upward

    ALPHA record
    [new gap]
    LOOP record
    SCREEN record

copy:
    ALPHA record
    BETA record
    LOOP record
    SCREEN record
```

The move uses the overlap-safe primitive from Chapter 7. Since the destination
is above the source and ranges overlap, the primitive chooses backward copying.

## Increment the count

Once the record exists, the two-byte count at the table base is incremented.
The count performs several jobs throughout the subsystem:

- identifies the highest ordinal;
- gives the vector-array length;
- locates the first physical record;
- bounds lookup, display and cleanup loops.

Changing it alters the calculated name anchor, so the vector repairs must use a
consistent before-and-after interpretation. The original code stores patched
anchors during the operation to keep the arithmetic small.

## Calculate the new vector offset

The new vector must point to the first name byte of the inserted physical record,
relative to the new name anchor.

In plain terms:

```text
newOffset = newNameAddress - newNameAnchor
```

The new vector begins with both flags clear:

```text
DEFINED = 0
LOCKED  = 0
```

The value word begins as zero. The symbol exists, but its value is unknown until
a later pass or directive defines it.

## Repair displaced vector offsets

Inserting the physical record moves that record and every alphabetically later
record upward by `nameLength + 2` bytes.

Their vectors must increase by the same amount. Records alphabetically before
the insertion point did not move and their offsets remain unchanged.

The repair rule is:

```text
for each existing vector:
    if vector.offset >= newRecordInsertionOffset:
        vector.offset += newRecordLength
```

The code compares each clean fourteen-bit offset with the new symbol's insertion
offset and calls `increaseAtHLbyBC` for affected vectors.

Notice what is *not* changed:

- old ordinals;
- source records;
- values and names before the insertion point;
- flags in existing vectors.

Only the small indirection layer is repaired.

## A creation example

Begin with two symbols encountered in this order:

```text
ordinal 1 = LOOP
ordinal 2 = SCREEN
```

Physical records:

```text
LOOP
SCREEN
```

Now source first mentions `ALPHA`.

The new ordinal is appended:

```text
ordinal 1 = LOOP
ordinal 2 = SCREEN
ordinal 3 = ALPHA
```

But the record is inserted alphabetically:

```text
ALPHA
LOOP
SCREEN
```

The vectors for `LOOP` and `SCREEN` increase because their records moved. The
new vector 3 points backward, in ordinal terms, to the first physical record.

Existing compressed source still contains ordinals 1 and 2 and requires no
change.

That is the payoff of the design.

## TABLE L and TABLE U

Creation and definition are not the only state transitions. The table commands
can lock or unlock every symbol.

PROMETHEUS uses one loop for both operations. The instruction operating on each
vector high byte is itself modified.

For `TABLE L` the selected instruction is conceptually:

```asm
SET 7,(HL)
```

For `TABLE U` it becomes:

```asm
RES 7,(HL)
```

The source contains:

```asm
varcSymbolVectorFlagInstruction:
    set 7,(hl)
```

and the second opcode byte is patched before the vector loop.

This is a classic PROMETHEUS pattern:

```text
one traversal
one self-modified tiny operation
several command meanings
```

Locking changes no names, values or offsets. It only sets bit 7 in every vector
high byte.

## What locking means

A locked symbol is accepted as having a usable value even after ordinary
DEFINED state has been cleared.

This can support workflows such as:

```text
assemble or load a group of known addresses
lock the symbol table
clear or replace source
use those preserved values in another assembly
```

The lock does not stop the table from being compacted physically, but `TABLE C`
will not remove a locked symbol. Its identity and value survive.

Unlocking removes that protection. If the symbol is neither referenced by
current source nor otherwise redefined, a later compaction may remove it.

## Why unused symbols accumulate

Entering a name creates it immediately. Later editing may remove every source
line that refers to it.

For example:

```asm
        LD HL,TEMP
```

creates `TEMP`. If the line is deleted, the symbol remains in the table. This is
intentional: deleting one source line should not immediately launch an expensive
whole-source search and table rewrite.

Over time, however, abandoned names consume memory and clutter `TABLE` output.
The `TABLE C` operation performs explicit garbage collection when requested.

## TABLE C is a mark-and-compact collector

The algorithm has five broad phases:

```text
1. clear temporary marks
2. scan source and mark every referenced symbol
3. remove every unmarked, unlocked symbol
4. repair vector offsets and source ordinals
5. clear temporary marks again
```

This resembles a garbage collector:

- source records are the roots;
- symbol references are edges to live objects;
- LOCKED symbols are permanent roots;
- unreferenced unlocked symbols are garbage.

The program does not call it a heap collector, but the intellectual pattern is
the same.

## Bit 6 temporarily changes meaning

Normally bit 6 means DEFINED. At the beginning of `TABLE C`, PROMETHEUS clears it
in every vector while preserving bit 7.

The same vector loop used by lock/unlock is configured as:

```asm
RES 6,(HL)
```

During the mark phase, bit 6 no longer means “defined by pass one.” It means:

```text
referenced somewhere in the current compressed source
```

Reusing the bit avoids allocating a separate mark bitmap.

This temporary change is safe because compaction is an explicit operation and
ordinary assembly-definition state will be rebuilt on the next pass.

## Scanning source for symbol references

The source scanner must understand the compressed record language from Chapter
12.

A symbol reference may appear:

- as the optional line-label ordinal after the two-byte header;
- inside one or more encoded expression payloads.

The scanner skips:

- literal bytes below `$80`;
- the second byte belonging to a tagged ordinal;
- record terminal/back-link bytes at `$C0` or above.

The source contains:

```asm
findNextSymbolReferenceInSource:
.findNextSourceRecordWithSymbolReference:
    call comparePositionWithCodeEnd
    ret nc
    inc hl
    ld a,(hl)
    and 00fh
    inc hl
    jr z,.findNextSourceRecordWithSymbolReference
    and 008h
    jr nz,.returnFoundSymbolReference
findNextSymbolReferenceInPayload:
.scanSourcePayloadForSymbolReference:
    ld a,(hl)
    inc hl
    cp 0c0h
    jr nc,.findNextSourceRecordWithSymbolReference
    cp 080h
    jr c,.scanSourcePayloadForSymbolReference
```

This is why a well-designed compact format pays dividends. The collector does
not need to expand source into text. It can identify references directly from
byte classes.

Each discovered ordinal is resolved to its vector, and bit 6 is set.

## Deciding what may be removed

After marking, the collector examines every vector.

A symbol is retained if either high flag is set:

```text
bit 6 marked from source
or
bit 7 locked
```

A symbol is removable when:

```text
(flags & $C0) == 0
```

That means:

```text
not referenced by current source
and
not locked
```

The old value does not matter. A once-defined but now-unused unlocked symbol is
eligible for removal.

## Removing the physical record

The vector gives the offset of the symbol's name. The collector moves back two
bytes to include the value word, then scans to the high-bit-terminated end of
the name.

The removed range is:

```text
value low
value high
all name bytes through final tagged character
```

`closeDeletedSymbolDataGap` moves the bytes above that record downward. The end
pointer is reduced by the record length, and vacated bytes at the top are
cleared.

Physical records after the removed record have moved downward. Their vector
offsets must decrease by the removed record length.

The rule is the inverse of insertion:

```text
for each surviving vector:
    if vector.offset >= removedRecordOffset:
        vector.offset -= removedRecordLength
```

## Removing the ordinal vector

The collector also closes the two-byte gap left by the removed vector and
decrements the symbol count.

This operation is more disruptive than physical record deletion because ordinal
positions above the removed one shift down:

```text
before:
    1 ALPHA
    2 LOOP
    3 SCREEN

remove ordinal 2:
    1 ALPHA
    2 SCREEN
```

Every source reference to old ordinal 3 must become ordinal 2.

This is the situation the stable-vector design normally avoids, but true symbol
deletion necessarily changes the ordinal sequence. PROMETHEUS pays the cost only
during explicit `TABLE C`.

## Rewriting source ordinals

After determining the removed ordinal, the collector scans the complete source
again.

For each encoded ordinal:

```text
if ordinal >= removedOrdinal:
    ordinal -= 1
else:
    leave it unchanged
```

The actual comparison decrements ordinals greater than or equal to the removed
one. In a valid table there should be no source reference equal to the removed
ordinal, because the mark phase would have retained that symbol. Equality would
contradict the collector's liveness decision; the inclusive comparison keeps the
loop compact.

The source bytes are updated in place. The high tag bit is preserved in the
stored high ordinal byte.

The algorithm repeats for every removable symbol. This can require several full
source scans and several packed-memory moves, which explains why `TABLE C` is a
relatively slow maintenance command rather than an automatic action after every
edit.

## Why removal proceeds in place

A simpler program might construct a new table elsewhere, then replace the old
one. PROMETHEUS cannot casually reserve another table-sized memory region.

In-place compaction has advantages:

- no duplicate table storage;
- no second source copy;
- exact reclamation of every removed byte;
- continued use of the shared source/symbol area.

Its cost is algorithmic care. Every move requires offset repair, and every
ordinal deletion requires source rewriting.

This is a familiar trade-off in small systems:

```text
save memory by spending code and time
```

## CLEAR uses the same cleanup machinery

The `CLEAR` command removes the complete editable source after confirmation.
Once the source has gone, many ordinary symbols are no longer referenced.

PROMETHEUS routes into the same symbol cleanup logic. Locked symbols can survive;
unlocked unreferenced ones are removed.

This reuse keeps the meaning consistent:

```text
source roots determine ordinary symbol liveness
lock bits preserve explicitly retained symbols
```

## Definitions are intentionally cleared

At the end of `TABLE C`, bit 6 is cleared again in every surviving vector.

For unlocked survivors, this means:

```text
name remains
value may remain physically present
but value is not accepted until a new pass defines it
```

Locked symbols retain bit 7 and remain usable.

This prevents an old unlocked value from silently pretending to be a current
definition after source has changed. The next first pass rebuilds ordinary
DEFINED state from actual labels and `EQU` directives.

## A complete compaction example

Suppose the table contains:

```text
ordinal 1 = START   referenced
ordinal 2 = TEMP    no longer referenced
ordinal 3 = SCREEN  locked
ordinal 4 = LOOP    referenced
```

The mark phase produces:

```text
START   bit6 = 1, bit7 = 0
TEMP    bit6 = 0, bit7 = 0
SCREEN  bit6 = 0, bit7 = 1
LOOP    bit6 = 1, bit7 = 0
```

`TEMP` is removed.

The physical record gap closes. Offsets after `TEMP` decrease. The vector array
changes from four entries to three:

```text
new ordinal 1 = START
new ordinal 2 = SCREEN
new ordinal 3 = LOOP
```

The source scanner then changes every old ordinal 3 to 2 and every old ordinal 4
to 3.

Finally bit 6 is cleared:

```text
START   exists, currently undefined
SCREEN  locked and usable
LOOP    exists, currently undefined
```

The next assembly pass defines `START` and `LOOP` again from source.

## Insertion and deletion are mirror images, but not exact mirrors

Physical record insertion and deletion have symmetric offset rules:

```text
insert before offset T:
    offsets >= T increase by inserted length

delete at offset T:
    offsets >= T decrease by removed length
```

Ordinal handling is asymmetric:

```text
creation:
    append new vector
    old ordinals do not change

deletion:
    remove a vector from the middle
    later ordinals decrease
```

This asymmetry is deliberate. Creation is frequent during normal editing, so it
is made cheap for source references. Deletion is deferred to explicit cleanup,
where the more expensive rewrite is acceptable.

## The source record is the collector's root set

It is worth stepping back from instructions and registers.

A symbol survives `TABLE C` for one of two reasons:

1. some current source record names it;
2. the programmer locked it.

That is a semantic rule, not merely a memory-layout rule.

The collector discovers it by reading the source's compact syntax directly. In
modern terms:

```text
compressed source records = root graph
symbol vectors             = handles and state
value/name records          = managed objects
TABLE C                     = explicit mark-and-compact collection
```

PROMETHEUS was not designed as an object system, but the same fundamental
problems of identity, reachability and relocation appear.

## Failure safety

The code generally checks space before insertion and performs maintenance in an
order where each step has the information needed to repair the next.

Still, these operations assume that table invariants are already correct:

- count matches the vector array;
- every vector offset selects a valid name;
- every name has a final high-bit marker;
- every encoded source ordinal lies within the count;
- packed source and table end at `varcCodeEndPt+1`.

A corrupted table could make a scanner run into unrelated memory. The compact
format has little redundancy for defensive validation. That is normal for a
resident program designed to manage its own trusted structures.

For the resurrection project, these invariants are valuable targets for tests
and diagnostic tooling even when the original runtime does not check them all.

## In plain pseudocode

Creating a symbol:

```text
function findOrCreateSymbol(name):
    normalized = normalizeName(name)

    existing = findOrdinal(normalized)
    if existing exists:
        return existing

    requireSpace(maximumNewEntrySize)

    oldCount = symbolCount
    newOrdinal = oldCount + 1

    openTwoByteGapAtEndOfVectorArray()
    codeEnd += 2

    insertionPoint = findAlphabeticalInsertionPoint(normalized)
    entryLength = 2 + length(normalized)

    openGap(insertionPoint, entryLength)
    copy([zeroValueWord, normalizedName], insertionPoint)
    codeEnd += entryLength
    symbolCount += 1

    newOffset = addressOfNewName - newNameAnchor

    for each old vector:
        if vector.offset >= newOffset:
            vector.offset += entryLength

    appendVector(offset=newOffset, defined=false, locked=false)
    return newOrdinal
```

Locking or unlocking all symbols:

```text
function setAllLocks(wantedState):
    patch vectorOperation to SET bit7 or RES bit7
    for every vector high byte:
        execute patched operation
```

Compacting unused symbols:

```text
function compactSymbols():
    clear bit6 in every vector

    for each symbol reference in compressed source:
        set bit6 in referenced vector

    ordinal = 1
    while ordinal <= symbolCount:
        vector = vectorAt(ordinal)

        if vector.bit6 == 0 and vector.bit7 == 0:
            removedEntryOffset = vector.offset
            removedEntryLength = deletePhysicalValueNameRecord(vector)
            deleteVector(ordinal)
            symbolCount -= 1

            for each surviving vector whose offset followed removed entry:
                vector.offset -= removedEntryLength

            for each encoded symbol ordinal in source:
                if encodedOrdinal >= ordinal:
                    encodedOrdinal -= 1

            # do not increment ordinal: a new vector now occupies this slot
        else:
            ordinal += 1

    clear bit6 in every surviving vector
```

## What has changed in memory

After creating a new symbol:

- the table count has increased by one;
- the vector array is two bytes longer;
- a zero-valued high-bit-terminated record has been inserted alphabetically;
- offsets for displaced records have increased;
- a new unflagged vector has been appended;
- `varcCodeEndPt+1` has moved upward;
- existing compressed source ordinals remain unchanged.

After `TABLE L` or `TABLE U`:

- bit 7 has been set or cleared in every vector high byte;
- names, values, offsets and source records are unchanged.

After `TABLE C`:

- unreferenced unlocked value/name records are gone;
- their vector slots are gone;
- surviving offsets have been reduced where necessary;
- source ordinals above each removed ordinal have been decremented;
- the count and end pointer are smaller;
- bit 6 has been cleared from survivors;
- locked symbols retain bit 7 and usable saved values.

## Important labels encountered

- `findOrCreateSymbolOrdinal`
- `symbolEntryCreationPrefix`
- `varcNewSymbolVectorSlot`
- `varcSymbolEntryAreaBase`
- `varcCodeEndPt`
- `ensureBCBytesFitBelowUTop`
- `moveMemoryBlockOverlapSafe`
- `processSymbolTableItems`
- `varcSymbolVectorFlagInstruction`
- `findNextSymbolReferenceInSource`
- `findNextSymbolReferenceInPayload`
- `varcSymbolEntryAreaBaseForCleanup`
- `varcRemovedSymbolEntryOffset`
- `varcCurrentCompactionVectorPointer`
- `advanceSymbolVectorAndLoadOffset`
- `closeDeletedSymbolDataGap`

## Back to the bigger picture

Part III has now assembled the front half of the assembler's semantic machinery:

```text
source word
    ↓
mnemonic and operand classes
    ↓
encoded expressions
    ↓
stable symbol ordinals
    ↓
movable alphabetical records
    ↓
pass-time values and state flags
```

We also know how the table remains healthy as names are introduced and later
abandoned.

The next chapter turns from data structures to action. Pass one walks every
source record, defines labels, evaluates `EQU`, processes address-control
directives and predicts how many bytes each line will occupy. It is the stage
that turns the symbolic world described in Chapters 22–24 into a complete map of
the future machine-code program.
