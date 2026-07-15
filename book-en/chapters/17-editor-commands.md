# Chapter 17: FIND, REPLACE, COPY, DELETE and PRINT

The editor's larger commands can look unrelated from the keyboard.

- FIND searches text.
- REPLACE rewrites it.
- COPY duplicates source records.
- DELETE removes a selected region.
- PRINT sends source to an external channel.

Inside PROMETHEUS, however, these commands are built from a small shared set of
ideas:

- expand compressed records into `lineBuffer`;
- scan records with a replaceable callback;
- represent a block with two record pointers;
- turn an inclusive block into an exclusive byte range;
- reuse the normal parser instead of modifying compressed records by hand;
- let the common insertion and deletion engine move memory.

This chapter follows those commands as *applications* of the editor mechanisms
we already understand.

## A selected block is two remembered records

Chapter 15 introduced:

```asm
varcSelectedBlockStart:
    ld hl,sourceBufferAccessLine
varcSelectedBlockEnd:
    ld de,sourceBufferAccessLine
```

The user can mark boundaries in either order. `getSelectedBlock` compares the
stored addresses and swaps them when necessary, returning a normalized pair:

```text
HL = lower record start
DE = upper record start
```

The range is inclusive. Both named records belong to the block.

Nothing is written into the compressed records themselves. COPY, DELETE, PRINT
and block-restricted FIND all consult the same two external pointers.

## FIND is a continuing conversation

A modern search box often has separate buttons for “Find first” and “Find
next.” PROMETHEUS uses one command whose exact form decides which state to
replace and which state to reuse.

The supported forms are:

```text
FIND s:text     search whole source from its beginning
FIND b:text     search selected block from its beginning
FIND :text      use new text, begin from current position and previous scope
FIND            reuse saved text and scope, continue
```

The letters are case-insensitive in normal command entry. In the source, the
checks use uppercase `S`, `B`, and colon after tokenization and input-buffer
normalization.

Two pieces of state survive between commands:

```asm
varcFindScanPosition:
    ld hl,sourceBufferAccessLine

varcFindRestrictToBlock:
    ld a,000h
```

The first immediate operand remembers the last compressed record examined. The
second remembers whether candidates must lie inside the selected block.

A separate workspace stores the current pattern as:

```text
one-byte visible length
lowercase pattern bytes
```

A bare FIND therefore needs no new text. It can continue from the remembered
record with the remembered pattern and remembered scope.

## Starting from before the first record

To search from the beginning, PROMETHEUS stores
`sourceBufferPreviousLine` in the scan cursor rather than the first real source
record.

This is because the generic loop advances *before* processing:

```asm
varcFindScanPosition:
    ld hl,sourceBufferAccessLine
    call getNextSourceRecord
    ld (varcFindScanPosition+1),hl
```

Starting at the special preceding record means the first advance lands exactly
on the first searchable record.

This “position before first” technique avoids a separate first-iteration case.
It is the record-chain equivalent of starting an array loop at index `-1` when
the loop increments before reading.

## One scanner, different jobs

The core source scan is callback-driven.

FIND installs:

```asm
ld hl,findTextInLineBuffer
```

PRINT installs:

```asm
ld hl,printLineBufferToChannel3
```

That address is written into a self-modified call:

```asm
varcLineScanCallback:
    call findTextInLineBuffer
```

The scanner itself does not know whether it is searching or printing. It only
knows how to:

1. advance to the next compressed record;
2. stop at source end;
3. optionally reject records outside the selected block;
4. expand the record into `lineBuffer`;
5. call the configured per-line routine;
6. continue or stop according to carry.

In pseudocode:

```text
repeat:
    record = next(savedScanPosition)
    savedScanPosition = record

    if record is at source end:
        return not found / finished

    if blockOnly and record outside selected block:
        continue

    expand record into lineBuffer

    if callback(lineBuffer) returns carry:
        activeLine = record
        return success
```

This is a small internal framework. FIND and PRINT differ mainly in the callback
and how they interpret completion.

## Matching visible text, not formatting bytes

The expanded line contains `$01` field separators. They help rendering and edit
navigation but are not visible source characters.

`matchSearchTextAtDE` skips them without consuming one character of the pattern:

```asm
.matchReadNextSourceCharacter:
    ld a,(de)
    inc de
    dec a
    jr z,.matchReadNextSourceCharacter
    inc a
    ret z
```

The `DEC` temporarily maps `$01` to zero so it can be recognized cheaply. `INC`
restores other bytes and turns the true `$00` line terminator into zero for the
following test.

Comparison itself is case-insensitive:

```asm
xor (hl)
and 0dfh
ret nz
```

ASCII uppercase and lowercase letters differ by bit 5. XOR reveals differing
bits; AND `$DF` ignores bit 5. If all remaining bits match, the letters are
considered equal.

The matcher therefore compares what a person reads:

```text
label mnemonic operands
```

not the editor's invisible field boundaries.

## Searching every possible starting position

`findTextInLineBuffer` tries the saved pattern at each visible position:

```text
position = start of line

while not end of line:
    if pattern matches here:
        return carry set
    position++

return carry clear
```

The matcher distinguishes two failures:

- ordinary mismatch: try the next position;
- line terminator: no later position can match.

On success, the generic scanner makes the current compressed record active.
The screen is later rebuilt around it by the ordinary warm-start path.

FIND does not store a character cursor inside the source record. Its continuing
state is record-oriented. REPLACE searches the expanded active line again when
it needs exact character positions.

## Failure leaves the active line unchanged

The scan cursor advances as records are examined, but the active editor pointer
is changed only when the callback reports carry.

If the scan reaches source end, `findNextOccurrence` returns without committing
a new active line.

This separation gives useful behavior:

```text
search progress state may advance
visible editor position changes only on success
```

A failed FIND therefore does not unexpectedly move the user's current line.
A later command can still decide whether to restart or reuse the saved scan
state.

## Block-restricted FIND reuses ordinary selection testing

When `varcFindRestrictToBlock` is nonzero, each candidate record is passed to
`testSourceRecordOutsideSelectedBlock` before expansion.

Records outside are skipped entirely. The matcher does not need to understand
block endpoints, and the block logic does not need to understand text.

This is a recurring PROMETHEUS design style:

> Keep each compact routine knowledgeable about one representation and connect
> them through small contracts.

The scanner knows records. The block helper knows addresses. The expander knows
compressed source. The matcher knows visible characters.

## REPLACE stores a second persistent string

The FIND text and replacement text are independent.

A new replacement after colon is normalized to lowercase and stored as another
length-prefixed sequence. A REPLACE command without a new argument reuses the
previous replacement, just as bare FIND reuses the previous search pattern.

The replacement workspace is embedded in bytes that otherwise look like inert
instructions when disassembled. This is another case of code-shaped storage,
introduced in Chapter 5.

## REPLACE does not edit compressed bytes directly

It would be possible to locate encoded expression fragments and patch them in
place—but that would be dangerously complicated.

A textual replacement might:

- change a mnemonic;
- cross a field boundary;
- create or remove a symbol;
- change the record's length;
- change the instruction-table descriptor;
- turn a valid line into an error;
- require a different pseudo-operation encoding.

PROMETHEUS chooses the safer route:

```text
compressed active record
    ↓ expand
canonical lineBuffer text
    ↓ apply replacement
ordinary inputBuffer text
    ↓ normal parser
new compressed record
    ↓ OVERWRITE commit
source
```

Thus REPLACE reuses both directions of the round trip described in Chapters 13
and 14.

## Rebuilding the editable line

REPLACE expands the active record, then constructs a fresh `inputBufferStart`.
It begins by writing the normal `$01` cursor marker and setting a capacity of 31
visible characters.

At every source position it asks whether the saved FIND pattern matches.

There are three cases.

### Case 1: a match

The saved replacement bytes are appended to the new input line. Then the source
pointer skips the number of *visible* characters in the matched pattern.

The helper `atHLorNextIfOne` transparently passes over internal `$01` field
separators while consuming those visible characters.

### Case 2: no match

One visible source character is copied unchanged. Again, formatting separators
are skipped rather than copied as user text.

### Case 3: end of line

The new line is terminated with a cursor marker, the unused tail of the input
buffer is zeroed, and the line is submitted through the ordinary parser.

In pseudocode:

```text
output = cursorMarker
source = expandedLine

while not end(source):
    if findPattern matches source:
        append replacementText to output
        advance source by visibleLength(findPattern)
    else:
        append next visible source character to output

append cursorMarker / terminator form
clear unused input tail
submit in OVERWRITE mode
```

The loop continues after a match, so every non-overlapping occurrence in the
current expanded line is replaced during that command.

## The 31-character limit still applies

`appendReplacementCharacterOrAbort` enforces the same visible-line capacity as
manual editing.

This matters because a short source line can expand dramatically. Replacing one
character with ten characters several times might exceed the editor's input
buffer.

PROMETHEUS does not allow REPLACE to construct a line that the normal editor
could not hold. It reports the ordinary error path rather than corrupting the
next workspace.

## Temporarily forcing OVERWRITE

Once rebuilding is complete, REPLACE writes a nonzero value into the immediate
operand of `varcInsertMode`.

The normal submit path then:

1. parses the rebuilt text;
2. inserts the new encoded record;
3. deletes the old active record;
4. returns the new record to the old position.

REPLACE does not need its own source-memory commit routine.

## Continuing after the parser returns

Normally, source submission ends through:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

REPLACE temporarily patches that jump to `replaceCommitContinuation`.

After the normal parser has committed the line, the continuation:

1. restores the jump target to `prometheusWarmStart`;
2. calls `findNextOccurrence`;
3. restores normal insert mode;
4. completes through the ordinary editor path.

This produces an interactive rhythm:

```text
FIND       move to next matching line without changing it
REPLACE    replace matches on this line, then move to the next matching line
FIND       skip this occurrence
REPLACE    accept replacement here and continue
```

The continuation hook lets a high-level workflow borrow the normal parser
without duplicating its completion logic.

## PRINT is FIND's scanner with a different callback

PRINT begins at the source start. With a `B` option it sets the same block-only
flag used by FIND. Then it installs `printLineBufferToChannel3` as the per-line
callback.

For each expanded record, the callback:

1. checks whether SPACE/BREAK requests cancellation;
2. opens Spectrum channel 3;
3. outputs the expanded line;
4. emits carriage return 13;
5. returns carry clear so scanning continues.

The scanner stops naturally at source end.

In pseudocode:

```text
scope = whole source or selected block
scan from beginning

for every record in scope:
    expand to lineBuffer
    if SPACE pressed:
        abort
    print lineBuffer to channel 3
    print newline
```

The exact device attached to channel 3 belongs to the Spectrum's channel
system. PROMETHEUS only needs a standard output route.

## Why PRINT expands records instead of printing stored bytes

Compressed records contain:

- instruction indexes rather than mnemonic spelling;
- symbol ordinals rather than names;
- compact expression markers;
- header bits;
- terminal/back-link bytes.

Sending those bytes to a printer would be meaningless.

PRINT uses the same canonical expansion as the screen listing, so printed source
reflects current symbol names and configured source case. It also means one
formatting implementation serves:

- editor display;
- editing an existing line;
- FIND;
- REPLACE;
- PRINT;
- later import/export paths.

## COPY turns an inclusive block into bytes

COPY begins with the normalized block:

```text
low  = first selected record
high = last selected record
```

To calculate a byte length, it advances once from `high`:

```text
exclusiveEnd = next(high)
byteCount = exclusiveEnd - low
```

This is the standard conversion from an inclusive record range to a half-open
byte range:

```text
[low, high record inclusive]
        becomes
[low, exclusiveEnd)
```

Half-open ranges are easy to measure because subtraction directly gives their
length.

## Where COPY inserts

The gap opens at the active record. The duplicate block therefore appears
immediately before the active line.

An active pointer strictly inside the selected range is rejected. Otherwise the
operation could open a gap in the middle of the very bytes it is trying to use
as one coherent source block.

The lower boundary itself is permitted because the insertion point is *before*
that record. In that case, opening the gap shifts the original block upward and
the source pointer is corrected to follow it.

The user-visible idea remains simple:

```text
mark block
move active line to destination
COPY
```

The implementation must distinguish the address of the destination record from
the address where new bytes are inserted before it.

## COPY does not decode or re-encode source

COPY duplicates the compressed byte range exactly.

That means:

- instruction descriptors remain identical;
- symbol ordinals remain identical;
- comments and expression encodings remain identical;
- record boundaries are preserved as a group;
- no parser errors are possible during copying.

The symbol table does not need new entries because copied records refer to the
same existing ordinals.

This is faster and more faithful than expanding every selected line to text and
submitting it again.

## DELETE counts records inclusively

DELETE also begins with normalized block endpoints. It counts one for the lower
record, then walks until it reaches the upper endpoint.

The resulting record count is passed to the common deletion engine from Chapter
16.

After compaction, the command chooses the nearest valid survivor and stores it
as:

```text
active line
block start
block end
```

The old selected range has ceased to exist, so collapsing the selection is the
only unambiguous result.

## COPY and DELETE share selection but not semantics

Both commands use the same two block pointers and the same normalization helper,
but they treat editor state differently.

COPY preserves the original selected records. Because the common insertion
routine repairs block pointers at or above the gap, the selection continues to
follow the original block when it moves.

DELETE destroys the selected records. Its caller therefore replaces the block
pointers with a surviving record.

This is another example of the physical/semantic split:

```text
insertion engine:
    follow bytes that moved

COPY meaning:
    selection still describes original bytes

DELETE meaning:
    old selection is gone; choose a new one-line selection
```

## One scanner, one block representation, two memory transforms

We can now see the economy of the editor command layer.

### FIND

```text
record scanner + expander + text matcher
```

### PRINT

```text
same record scanner + expander + output callback
```

### REPLACE

```text
expander + matcher + edit buffer + ordinary parser + overwrite mutation
```

### COPY

```text
block endpoints + record traversal + insertion mutation
```

### DELETE

```text
block endpoints + record traversal + deletion mutation
```

The commands are not five independent programs. They are five compositions of
shared machinery.

## A complete FIND example

Suppose the source contains:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

The user enters:

```text
FIND s:loop
```

The path is:

```text
1. command parser recognizes S scope
2. scan cursor becomes sourceBufferPreviousLine
3. block-only flag becomes zero
4. saved pattern becomes length 4, bytes "loop"
5. scanner advances to first source record
6. record is expanded to lineBuffer
7. matcher tests every visible position, skipping $01 separators
8. scanner repeats until "LOOP" matches
9. matching compressed record becomes active
10. warm-start redraw places that record on the access line
```

The match succeeds whether the listing displays `LOOP`, `loop`, or a mixed
case, because comparison ignores ASCII bit 5.

## A complete REPLACE example

With the line containing:

```asm
START   LD B,5
```

suppose the saved FIND pattern is `5` and the user enters:

```text
REPLACE :8
```

PROMETHEUS:

```text
expands the compressed record
copies "START LD B," into the input buffer
matches "5"
appends "8"
finishes the editable line
forces OVERWRITE
submits through the normal parser
inserts the new record
removes the old record
restores normal continuation
searches for the next saved pattern
```

If the changed text were not valid assembly, the normal parser would report its
ordinary error. REPLACE gains validation for free by using the established
source-entry route.

## A complete block COPY example

Suppose selected boundaries enclose:

```asm
LOOP    DJNZ LOOP
        RET
```

and the active line is a later `ENT START` record.

COPY calculates the byte range from the start of `LOOP` through the byte before
`ENT START`, opens a gap at the `ENT` record, and copies the exact compressed
bytes into it.

No text is reconstructed. The duplicate records appear before `ENT START` and
refer to the same symbol ordinals as the originals.

Whether the duplicate source is logically sensible is the programmer's
responsibility. The editor copies records; it does not rename labels or attempt
to prevent duplicate definitions. The assembler will later diagnose semantic
problems.

## A complete block DELETE example

With the same two-line selection, DELETE:

```text
normalizes endpoints
counts 2 records
finds byte address after RET
moves all later source and the symbol table downward
clears the old tail
repairs region boundaries
restores empty source padding if needed
chooses the nearest surviving record
collapses selection and active line onto it
```

The source window is then reconstructed from the repaired chain.

## Back to the whole editor

These commands feel substantial because they affect many lines or perform a
long search. Yet each relies on representations already built for ordinary
editing.

FIND does not search compressed opcodes. It expands records through the normal
listing path. REPLACE does not invent a second parser. It rebuilds an ordinary
edit line. PRINT does not own a separate source iterator. It replaces FIND's
callback. COPY does not understand assembly. It duplicates a valid record
range. DELETE does not know every record length beforehand. It walks the same
chain used by cursor movement.

The editor becomes powerful not by accumulating unrelated special-purpose code,
but by arranging for its compact pieces to be reusable.

## What has changed in memory or on screen?

After successful FIND:

- the saved scan position has advanced;
- the active-line pointer names the matching record;
- compressed source is unchanged;
- the source window is redrawn around the match.

After REPLACE:

- the current compressed record has been replaced through normal parse/commit;
- source length may have grown or shrunk;
- symbol references may have changed through the parser;
- normal INSERT mode and continuation have been restored;
- FIND state has advanced toward the next occurrence.

After COPY:

- an exact compressed byte range has been inserted before the active record;
- source and symbol storage above the gap have moved upward;
- original selected records remain and selection pointers follow them;
- the duplicate may introduce assembler-level duplicate labels, which are not
  an editor concern.

After DELETE:

- the inclusive selected records have been removed;
- later source and symbol bytes have moved downward;
- the selection has collapsed onto a survivor;
- the active line names the same survivor;
- required empty tail records exist again.

During PRINT:

- compressed source remains unchanged;
- `lineBuffer` is rebuilt for each record;
- channel 3 receives canonical expanded source and carriage returns;
- SPACE can abort the scan.

## Important ideas for later chapters

- FIND state survives in self-modified scan and scope operands;
- a “before first record” cursor simplifies restart scanning;
- FIND and PRINT share one callback-driven record scanner;
- searches compare visible expanded text, not compressed bytes;
- `$01` field separators are ignored by matching and replacement;
- case-insensitive comparison masks ASCII bit 5;
- REPLACE rebuilds an ordinary edit line and reuses the normal parser;
- REPLACE may change record size and symbol references safely;
- the post-command continuation hook creates multi-stage workflows;
- inclusive blocks become half-open byte ranges by advancing past the upper
  record;
- COPY duplicates compressed bytes exactly;
- DELETE destroys the selected meaning and therefore resets block state;
- editor commands compose existing mechanisms rather than duplicating them.

## Source anchors explained

- `invokeFind`
- `.initializeFindScopeAndRestartAtSourceBeginning`
- `.checkFindBlockScopePrefix`
- `findNextOccurrence`
- `.configureLineScanAndStart`
- `varcFindScanPosition`
- `varcFindRestrictToBlock`
- `varcLineScanCallback`
- `storeLowercaseCommandArgument`
- `findTextInLineBuffer`
- `matchSearchTextAtDE`
- `searchTextLength`
- `searchTextCharacters`
- `invokeReplace`
- `.replaceScanLoop`
- `.replaceCopyReplacementLoop`
- `.replaceSkipMatchedTextLoop`
- `.replaceCopyUnmatchedCharacter`
- `.replaceFinalizeInputLine`
- `replaceCommitContinuation`
- `replacementTextStorageBaseMinusOne`
- `appendReplacementCharacterOrAbort`
- `varcPostCommandContinuationJump` at workflow level
- `invokePrint`
- `printLineBufferToChannel3`
- `outputLineBufferToChannel3`
- `getSelectedBlock` at command level
- `testSourceRecordOutsideSelectedBlock` at command level
- `invokeCopy`
- `invokeDelete`
