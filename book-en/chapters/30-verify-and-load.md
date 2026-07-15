# Chapter 30: VERIFY and LOAD

Saving a project is only half of tape support.

PROMETHEUS must also answer two different questions:

```text
VERIFY: Does the tape contain exactly what the last SAVE wrote?
LOAD:   How can a saved project be merged safely into the current editor state?
```

The two commands share low-level tape machinery but have very different effects.
VERIFY compares. LOAD imports.

The surprising part is LOAD. It does **not** copy saved compressed source bytes
straight into the live source area. Instead, it temporarily stages the package
near U-TOP, expands one imported record using the imported symbol table, turns
that record back into a normal editor line, and submits the line through the
ordinary parser and insertion machinery.

This apparently indirect route solves several difficult problems at once:

- imported symbol ordinals may differ from current ordinals;
- the current project may already contain some of the same names;
- source-record details should be validated by one parser, not two;
- imported records may grow or shrink when re-encoded;
- loading a block should behave like inserting typed source.

We will begin with VERIFY, then follow LOAD from tape header to staged payload to
record-by-record merge.

## VERIFY remembers the preceding SAVE

`invokeVerify` accepts no filename or range argument. It relies on state patched
by the most recent SAVE:

```text
source start
source length
symbol-table start
auxiliary chained length
retained filename
```

This makes VERIFY precise but intentionally short-lived.

Consider what would happen if VERIFY recomputed “the whole current source”:

- the preceding SAVE may have written only a selected block;
- the user may have edited records since SAVE;
- the table may have moved or changed length;
- the retained filename alone does not describe the original memory segments.

The self-modified fields preserve the actual ranges that were sent to tape.

## Scanning for a CODE header

Both VERIFY and LOAD use `scanTapeForNextCodeHeader`.

It repeatedly requests a 17-byte Spectrum header into
`BOTTOM_LINE_VRAM_ADDRESS`:

```asm
scanTapeForNextCodeHeader:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld de,00011h
    xor a
    scf
    call callRomTapeLoadOrVerify
    jr nc,scanTapeForNextCodeHeader
```

The helper continues after failed reads. On a successful header it displays a
`Found` message and the ten filename bytes. Non-printable characters are shown
as `?`, keeping a corrupt or unusual header from sending control codes to the
screen renderer.

The type byte must equal 3:

```asm
    ld a,(BOTTOM_LINE_VRAM_ADDRESS)
    cp 003h
    jr nz,scanTapeForNextCodeHeader
```

Other Spectrum block types are ignored.

This separation is useful:

```text
header scanner:
    find the next valid CODE header

caller:
    decide whether its name is acceptable
```

VERIFY requires an exact name. LOAD supports exact and wildcard selection.

## Exact filename comparison

The comparison is a straightforward ten-byte loop:

```asm
compareRequestedNameWithLoadedHeaderExact:
    ld b,MAX_FILE_NAME_LENGTH
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
.compareLoadedHeaderNameLoop:
    ld a,(de)
    cp (hl)
    inc hl
    inc de
    ret nz
    djnz .compareLoadedHeaderNameLoop
    ret
```

Names are compared as fixed-width header fields, including padding spaces.
`ABC` and `ABC       ` are not two representations at this point; the parser has
already normalized the retained name to the ten-byte padded form.

VERIFY loops until the exact name is found:

```asm
invokeVerify:
    call scanTapeForNextCodeHeader
    call compareRequestedNameWithLoadedHeaderExact
    jr nz,invokeVerify
```

## LOAD's wildcard discrepancy

The manual describes a ten-space name as “accept the first CODE block.” The
actual code is broader.

`acceptLoadedHeaderIfNameMatchesOrWildcard` initializes a ten-iteration loop but
repeatedly examines only `fileNameBuffer[0]`; `HL` is not advanced in the
wildcard test.

Therefore the real behavior is:

```text
first retained filename byte is a space:
    accept any CODE header

otherwise:
    require exact ten-byte match
```

A name beginning with one space is thus wildcard even if later bytes are not
spaces.

This book describes the implemented behavior rather than silently rewriting it
to match the manual's likely intention. Such small discrepancies are part of
understanding a historical program honestly.

## Carry chooses LOAD or VERIFY in the ROM

The shared wrapper `callRomTapeLoadOrVerify` receives:

```text
IX = destination or comparison address
DE = byte length
A  = expected tape block flag
carry set   -> LOAD
carry clear -> VERIFY
```

It arranges the expected flag and operation state in the alternate accumulator,
disables interrupts, writes the tape border/MIC state to port `$FE`, and calls
the Spectrum ROM's `LD-BYTES` entry.

The same ROM routine can either write incoming bytes to RAM or compare them with
RAM. Carry on entry selects the mode.

That is why VERIFY builds `$FF` without setting carry:

```asm
    xor a
    dec a
```

The accumulator becomes `$FF`, while carry remains clear.

LOAD instead deliberately keeps carry set before the call.

## Verifying the source segment

Once the matching header is found, VERIFY loads the remembered source range into
IX and DE:

```asm
varcLastSavedSourceStart:
    ld ix,00000h
varcLastSavedSourceLength:
    ld de,00000h
    call performTapeLoadOrVerifyOrReportError
```

The operands were patched by SAVE.

In VERIFY mode, the ROM compares each incoming source byte with the byte already
in memory. A mismatch clears the success carry and leads to `Tape error`.

The source may be:

- the complete meaningful source region; or
- exactly the selected block saved previously.

VERIFY does not need to know which. It trusts the remembered range.

## Verifying the auxiliary segment

The table portion uses the same chained marker protocol as SAVE. VERIFY reloads
the remembered symbol-table start and auxiliary length, reconstructs the ROM
marker state in the alternate accumulator, and calls `ROM_LD_MARKER`.

The low-level sequence is unusual, but the logical operation is simple:

```text
compare the tape's bridge/table continuation
against the exact live table segment used by SAVE
```

If either source or table comparison fails, the command reports `Tape error`.
If SPACE is pressed, the common cancellation path returns to the editor.

## Why VERIFY should be immediate

Suppose the user performs:

```text
SAVE :work
insert a new source line
VERIFY
```

The retained source pointer and length may still describe the original byte
range, but insertion may have moved or changed what lies there. The symbol table
may also have moved upward.

VERIFY is not a version-control system. It is a tape-write confidence check:

```text
SAVE
VERIFY before editing further
```

Its stateful implementation matches that purpose exactly.

## LOAD begins by forcing INSERT mode

Native LOAD is a merge operation. The imported records will be inserted after
the current access line.

`prepareTapeSourceImport` begins with:

```asm
    xor a
    ld (varcInsertMode+1),a
```

In the editor's inverted state convention, zero selects INSERT rather than
OVERWRITE.

There is no hidden “replace current project” option. To replace everything, the
user first clears the current source and then loads.

This behavior is valuable once it is understood: saved blocks can be inserted
into a larger source at the chosen position.

## Parse or reuse the requested name

LOAD accepts the same colon convention as SAVE:

```text
LOAD :name    store and request a new name
LOAD          reuse the retained name
```

`readFileNameWithColon` changes `fileNameBuffer` only when a colon is present.
The lower-level scanner then searches tape CODE headers until wildcard or exact
matching accepts one.

## Staging the complete payload below U-TOP

The current source and symbol table must remain resident while the imported
records are interpreted. PROMETHEUS therefore cannot load the incoming package
directly over them.

It reads the total length from header bytes 11 and 12, checks that the block can
coexist with current dynamic storage, and chooses:

```text
temporaryStart = U-TOP - totalLength
```

The complete payload occupies:

```text
[temporaryStart, U-TOP)
```

This uses high free memory without changing any live source pointer.

If the block is too large to coexist with the current project, `Memory full` is
reported before the data block is read.

At this moment the source and symbol table exist twice in different forms:

```text
lower memory:
    current live source and current live table

high temporary memory:
    imported source + bridge + imported table
```

That temporary coexistence is the key to safe name translation.

## Deriving the staged regions from header metadata

Let:

```text
P = temporaryStart
S = sourceLength from header bytes 15..16
```

Then LOAD patches:

```text
varcImportedDataCursor      = P
varcImportedSourceEnd       = P + S
varcImportedSymbolTableBase = P + S + 2
```

The two added bytes skip the bridge described in Chapter 29.

The complete data block is then read with:

```text
IX = P
DE = totalLength
A  = $FF
carry set
```

A tape failure occurs before merging begins, so the live source remains
unchanged if the data block cannot be loaded.

## Why direct copying would be wrong

Imagine the imported source contains ordinal 2 for symbol `LOOP`.

In the current project, ordinal 2 might mean `SCREEN`, or there may be only one
symbol. Copying the record bytes directly would silently change the program's
meaning.

Even if the two tables contain the same names, their ordinal order may differ
because symbols were created in different sequences.

PROMETHEUS solves this by translating through readable names:

```text
imported ordinal
    -> imported symbol table
    -> symbol spelling
    -> ordinary live parser
    -> current ordinal
```

The imported table supplies meaning; the current table supplies new identity.

## Temporarily switching the symbol resolver

`resolveSymbolReferenceToName` normally begins by loading the current dynamic
symbol-table pointer indirectly.

During imported-record expansion, LOAD patches that first instruction between
two opcodes:

```text
$21  LD HL,nn      use a direct staged table address
$2A  LD HL,(nn)    use the indirect live table pointer
```

The helper is:

```asm
patchSymbolReferenceResolverBase:
    ld (varcSymbolTableBasePointer),a
    ld (varcSymbolTableBasePointer+1),hl
    ret
```

This changes both the opcode and its operand.

For one imported record:

```text
patch resolver to direct imported table
expand record into readable line
restore resolver to indirect current table
```

Restoration happens immediately after expansion, before the line is parsed into
the live source.

This is disciplined self-modification used as a temporary addressing strategy.

## The imported-record loop

`invokeLoad` patches the editor's post-command continuation so a successfully
submitted line returns to the import loop:

```asm
    ld hl,continueSourceImportAfterSubmittedLine
    ld (varcPostCommandContinuationJump+1),hl
```

Then each iteration performs the following work.

### 1. Remember the current staged record

`varcImportedDataCursor` loads the next imported record address into `HL`. The
address is also placed in `IX`, which is the source-record pointer expected by
the expansion routine.

### 2. Find the next record before processing this one

`getNextSourceRecord` understands fixed and variable record lengths. LOAD stores
the successor back into `varcImportedDataCursor` immediately.

This is the familiar safe-iteration pattern:

```text
calculate next position before a deep operation reuses registers
```

### 3. Stop at the imported source boundary

The current record address is compared with `varcImportedSourceEnd`. When it is
at or beyond the boundary, the bridge and table have been reached and import is
finished.

### 4. Expand using the imported table

The resolver is patched to `LD HL,nn` with the staged table base. Then:

```asm
    call expandSourceRecordToLineBuffer
```

The result is a normal 32-byte editor line containing label, mnemonic,
operands, spaces and the `$01` cursor marker.

### 5. Restore the live resolver

The opcode returns to `$2A`, and the operand names `varcSymbolTablePt+1`.
Ordinary editor operations can again resolve current ordinals.

### 6. Reject an unexpandable imported record

If expansion reports `Source error`, the command aborts with the offending text
available for inspection or repair.

### 7. Submit through the normal editor

The 32-byte line is copied to `inputBufferStart`, parser scratch buffers are
cleared, and control jumps to:

```text
submitInputLineOrDispatchCommand
```

From this point the imported line is indistinguishable from a line entered at
the keyboard.

It undergoes:

- field splitting;
- mnemonic and operand recognition;
- expression validation;
- live symbol lookup or creation;
- current ordinal encoding;
- compressed-record construction;
- memory-capacity checks;
- insertion after the current access line.

There is one source language and one insertion path.

## A symbol translation example

Suppose the staged package contains:

```text
imported ordinal 1 -> START
imported ordinal 2 -> LOOP
```

The live project already has:

```text
current ordinal 1 -> SCREEN
current ordinal 2 -> START
current ordinal 3 -> WIDTH
```

An imported record equivalent to:

```asm
        DJNZ LOOP
```

contains imported ordinal 2. During expansion:

```text
imported ordinal 2
    -> staged table record "LOOP"
    -> lineBuffer text "DJNZ LOOP"
```

During ordinary parsing, `LOOP` is not yet in the live table, so it is created:

```text
current ordinal 4 -> LOOP
```

The newly inserted compressed record uses current ordinal 4, not imported
ordinal 2.

Meaning is preserved even though identity changes.

## Why records may change size during LOAD

The staged and new records are semantically equivalent but need not have the
same physical length.

Reasons include:

- current symbol ordinals may have different high/low byte values;
- a symbol may already exist rather than being newly created;
- normalized text is re-tokenized through the current implementation;
- current table growth changes available memory but not source semantics.

Therefore LOAD cannot predict final live size merely from the imported source
length.

## The moving collision boundary

The live dynamic region grows upward as imported lines and symbols are inserted.
The next staged record cursor also moves upward through the high-memory payload.

Before another iteration, PROMETHEUS compares:

```text
current live code end
next staged record address
```

As long as:

```text
liveEnd < nextImportedRecord
```

the two regions remain separate.

If they meet or cross, LOAD reports `Memory full`.

This late check is necessary even though the original payload passed the initial
capacity test. Re-encoding and symbol merging can consume a different number of
bytes from the staged representation.

The picture is:

```text
low addresses                                         high addresses

[live source + live table --->] free gap [---> remaining staged payload]

                         collision means Memory full
```

## Progress display and cancellation

After each successfully inserted line,
`continueSourceImportAfterSubmittedLine` polls the keyboard.

The behavior is deliberately compact:

```text
no key       continue importing silently
SPACE        abort to editor
other key    fall through and repaint the visible source window
```

The fall-through into `renderVisibleSourceRecords` provides on-demand progress
without slowing every imported line with a redraw.

Earlier imported lines remain if the user presses SPACE.

## LOAD is incremental, not transactional

PROMETHEUS keeps no rollback log.

Different failures occur at different stages:

### Header or data tape failure

This happens before merge begins. The live source remains unchanged.

### Expansion or parser error

Earlier records remain inserted. The offending reconstructed line is left in a
human-readable form for repair.

### SPACE during merge

Earlier records remain inserted. The operation stops.

### Late memory collision

Earlier records remain inserted and `Memory full` is reported.

This is not careless error handling. A full transactional import would require
extra memory to remember every insertion and symbol-table change—the resource
already under pressure.

The program favors useful partial progress and a repairable current line.

## Finishing the import

When the staged cursor reaches `varcImportedSourceEnd`, LOAD restores the normal
post-command continuation:

```asm
.finishSourceImport:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
    jp (hl)
```

The staged package remains in high memory only as abandoned temporary bytes.
They are outside the live source/table pointers and may be overwritten by later
work.

The imported records now belong entirely to the current project:

- they use current symbol ordinals;
- they occupy current compressed-source storage;
- their names live in the current symbol table;
- they appear after the editor line that was active when LOAD began.

## Replacing rather than merging

Because LOAD always uses INSERT mode, the documented replacement workflow is:

```text
CLEAR y
LOAD :name
```

Without the clear, LOAD is a merge at the current position.

This makes a saved block reusable as a library fragment. The same mechanism can
insert a routine into another project without a special linker or include-file
system.

## In plain pseudocode: VERIFY

```text
function verifyMostRecentSave():
    repeat:
        header = readNextValidCodeHeader()
    until header.name == retainedName

    verifyTapeBytes(
        memory = rememberedSourceStart,
        length = rememberedSourceLength,
        flag = $FF
    )

    verifyChainedAuxiliaryBytes(
        memory = rememberedTableStart,
        length = rememberedAuxiliaryLength
    )

    if either comparison failed:
        display "Tape error"
```

## In plain pseudocode: LOAD

```text
function loadNativeSource(command):
    editorMode = INSERT
    parseOrReuseFilename(command)

    repeat:
        header = readNextValidCodeHeader()
    until wildcardRequested() or header.name == retainedName

    total = header.totalLength
    sourceLength = header.prometheusSourceLength

    require currentDynamicData + total can coexist below UTOP

    stagedStart = UTOP - total
    loadTapeData(stagedStart, total)

    stagedCursor = stagedStart
    stagedSourceEnd = stagedStart + sourceLength
    stagedTableBase = stagedSourceEnd + 2

    postSubmitContinuation = continueImport

    while stagedCursor < stagedSourceEnd:
        record = stagedCursor
        stagedCursor = nextRecord(stagedCursor)

        resolver = direct(stagedTableBase)
        line = expandRecord(record)
        resolver = indirect(currentSymbolTablePointer)

        submit line through normal editor parser in INSERT mode

        if SPACE:
            abort and keep inserted prefix
        if currentCodeEnd >= stagedCursor:
            report Memory full and keep inserted prefix

    postSubmitContinuation = normalWarmStart
    return to editor
```

## What has changed in memory

After successful VERIFY:

- the loaded header workspace contains the matching CODE header;
- tape bytes have been compared against remembered source and table ranges;
- the live source and symbol table are unchanged.

After successful LOAD:

- the complete tape payload was temporarily staged below U-TOP;
- `varcImportedDataCursor`, `varcImportedSourceEnd` and
  `varcImportedSymbolTableBase` were patched for the staged layout;
- `resolveSymbolReferenceToName` was repeatedly switched between imported and
  live table addressing;
- each imported record was expanded to text and re-encoded through the normal
  editor;
- the live source and table grew upward;
- imported ordinals were replaced by current ordinals with the same names;
- the post-command continuation was restored to `prometheusWarmStart`.

## Important labels encountered

- `invokeVerify`
- `scanTapeForNextCodeHeader`
- `compareRequestedNameWithLoadedHeaderExact`
- `acceptLoadedHeaderIfNameMatchesOrWildcard`
- `callRomTapeLoadOrVerify`
- `performTapeLoadOrVerifyOrReportError`
- `ROM_LD_MARKER`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `invokeLoad`
- `varcImportedDataCursor`
- `varcImportedSourceEnd`
- `varcImportedSymbolTableBase`
- `patchSymbolReferenceResolverBase`
- `expandSourceRecordToLineBuffer`
- `submitInputLineOrDispatchCommand`
- `continueSourceImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`
- `varcPostCommandContinuationJump`

## Back to the bigger picture

Native tape transfer is not a raw memory dump in both directions.

SAVE is compact and trusting because it writes an internally consistent current
project:

```text
source bytes + bridge + complete table
```

LOAD is cautious and translational because it introduces that project into a
different current state:

```text
staged record
    -> imported names
    -> readable line
    -> normal parser
    -> current names and ordinals
    -> new live record
```

This design lets PROMETHEUS merge saved fragments, preserve symbol meaning and
reuse its strongest validation path, all without a large second importer.

The next chapter applies the same principle to a more foreign source format:
GENS/MASM line-numbered text. Rather than teach the assembler a second complete
syntax engine, PROMETHEUS converts each foreign line into its ordinary edit
buffer and lets the familiar editor take over.
