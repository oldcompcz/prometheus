# Chapter 32: The Complete Tape Journey

We have now examined four tape operations separately:

- SAVE writes native PROMETHEUS source and symbols;
- VERIFY compares that exact write with memory;
- LOAD translates a native saved project back into the current editor;
- GENS translates line-numbered foreign text into ordinary editor input.

This chapter steps back from individual routines and follows complete journeys
through the system. It introduces no large new mechanism. Its purpose is to
reconnect the pieces before the book leaves the editor and assembler behind and
enters the machine-code monitor.

The common theme is that PROMETHEUS treats tape as a **transport**, not as live
editor memory. Data crossing the tape boundary is checked, staged or translated
before it becomes part of the current project.

## The four representations in play

Tape support is easier to understand if we name the representations explicitly.

### 1. Live editor state

This is the current in-memory project:

```text
compressed source records
permanent empty tail records
symbol ordinal vector
alphabetically sorted symbol records
```

Pointers such as `varcSymbolTablePt` and `varcCodeEndPt` describe its current
shape.

### 2. Native PROMETHEUS tape payload

SAVE writes:

```text
[source bytes][two-byte bridge][complete symbol table]
```

The Spectrum CODE header carries:

```text
total payload length
source length in a repurposed header field
```

That private source-length value allows LOAD to find the imported symbol table
inside the staged payload.

### 3. Staged high-memory payload

LOAD and GENS first place the complete CODE data just below U-TOP:

```text
temporaryStart = U-TOP - totalLength
```

The live project remains in place while the staged representation is interpreted
line by line.

### 4. Ordinary editor input

Both importers eventually produce:

```text
text bytes | $01 cursor marker | zero padding
```

in `inputBufferStart`, then enter `submitInputLineOrDispatchCommand`.

This last representation is the narrow bridge into the live project.

## Native SAVE: from live structures to tape

Assume our running program is in the editor:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Its live form is not this text. It is a chain of compressed records referring to
symbol ordinals, plus a symbol table containing names such as `START` and
`LOOP`.

SAVE chooses either:

- the meaningful whole-source interval; or
- the exact inclusive selected block, converted to a half-open byte range.

For a whole-source save, the six permanent empty records before the symbol table
are excluded. They are editor scaffolding, not project content.

The command computes:

```text
S = saved source bytes
T = complete symbol table bytes
P = S + 2 + T
```

and constructs a Spectrum CODE header:

```text
filename = ten padded bytes
CODE length = P
private source length = S
```

The physical data path is chained. The ROM writes the source segment first, then
continues through the two-byte bridge and table segment. PROMETHEUS does not need
to copy the whole logical package into one temporary buffer merely to make it
contiguous.

The important transition is:

```text
live source/table addresses
    ↓ exact selected ranges
Spectrum header + chained data blocks
    ↓ tape pulses
physical tape recording
```

SAVE also remembers the exact ranges it used so that immediate VERIFY can
compare the same bytes.

## VERIFY: from tape back to the same memory

VERIFY does not build or merge anything. It asks the ROM to compare incoming
bytes with the retained source and table ranges.

The path is:

```text
scan tape headers
    ↓ exact retained filename
compare source data with remembered source range
    ↓ chained marker state
compare bridge/table data with remembered auxiliary range
```

Carry selects VERIFY rather than LOAD at the ROM `LD-BYTES` service.

If every byte matches, the preceding recording is trustworthy. If one byte
differs, or if the expected block cannot be read correctly, the command reports
`Tape error`.

VERIFY is therefore a test of one recent physical operation, not a general
project comparison. It depends on self-modified ranges saved by the previous
SAVE and should be performed before further editing moves those structures.

## Native LOAD: from private records through public text

LOAD begins by staging the tape payload below U-TOP. It then reads the source
length from the CODE header and derives:

```text
stagedSourceStart = temporaryStart
stagedSourceEnd   = temporaryStart + sourceLength
stagedTableStart  = stagedSourceEnd + 2
```

The imported records cannot be copied directly into the live source. Their
symbol ordinal 4, for example, refers to ordinal 4 in the **imported** table, not
necessarily ordinal 4 in the current table.

PROMETHEUS solves this by temporarily patching the symbol-name resolver:

```text
normal mode:
    load live table base indirectly from varcSymbolTablePt

import mode:
    use staged imported table base directly
```

For each staged record:

```text
1. find the following record
2. remember it as the next import cursor
3. ensure current record is still inside staged source
4. expand record using imported symbol names
5. restore normal live-table resolver
6. copy canonical text into inputBuffer
7. submit through ordinary parser and INSERT path
8. return through the import continuation
```

This turns:

```text
imported compressed identity
```

into:

```text
symbol names
```

and then back into:

```text
new live compressed identity
```

The name is the stable bridge. Ordinal numbers are allowed to change.

## GENS: from foreign text through the same public entrance

GENS shares the tape-header scan and staging step but ignores the private source
and symbol metadata.

For each line it:

```text
skip two line-number bytes
copy up to 31 characters
replace controls with spaces
clear bit 7
stop at carriage return
append the editor's $01 marker
submit normally
```

Native LOAD needs a temporary imported symbol table because its staged source is
already compressed. GENS does not: names are still present as text.

Both paths converge at the same point:

```text
inputBufferStart
    ↓
submitInputLineOrDispatchCommand
    ↓
normal tokenizer, parser, symbol manager and inserter
```

## Why LOAD is a merge, not a restore-image operation

The command name `LOAD` can suggest replacing all current state with a saved
snapshot. PROMETHEUS does something more flexible.

Imported records are inserted after the current access line. Existing source and
symbols remain. A user who wants replacement can CLEAR the old project first.

This design supports:

- loading a library beneath existing source;
- inserting a saved block into a larger program;
- combining projects whose symbol ordinal numbering differs;
- importing selected source saved from another context.

The price is that LOAD is incremental and non-transactional. A failure after
some accepted records leaves the prefix inserted.

Conceptually:

```text
LOAD = automated sequence of valid editor insertions
```

not:

```text
LOAD = overwrite editor memory with saved bytes
```

## The meeting of two growing regions

During either import, memory contains both old and incoming representations:

```text
resident program
live source and symbols      → grows upward
free space
staged tape payload          → cursor advances upward
U-TOP
```

For native LOAD, the next staged record address is compared with the growing live
end after every inserted line:

```text
if liveEnd < nextStagedRecord:
    continue
else:
    Memory full
```

The comparison is more subtle than checking the payload once before loading. The
initial payload may fit, yet re-encoding can enlarge the live project:

- imported names may create new table entries;
- an imported record may use a representation whose live encoding differs;
- current symbols must coexist with imported names;
- source insertion moves the live table upward.

The pre-load capacity check proves only that staging is possible. The per-line
check proves that coexistence remains possible as translation proceeds.

GENS uses U-TOP as the stream end. Its source comments emphasize the malformed
unterminated-line edge case, while native LOAD has exact record boundaries from
its compressed format.

## Names cross the boundary more safely than ordinals

Suppose the saved project contains:

```text
ordinal 1 = LOOP
ordinal 2 = START
```

but the current project already has:

```text
ordinal 1 = SCREEN
ordinal 2 = LOOP
ordinal 3 = BUFFER
```

Direct record copying would silently change meanings. A reference encoded as
ordinal 1 would become `SCREEN` rather than `LOOP`.

LOAD instead expands imported ordinal 1 through the staged table and obtains the
text `LOOP`. The live parser then finds existing live ordinal 2.

The translation is:

```text
imported ordinal 1
    → imported name LOOP
    → live ordinal 2
```

This is why the seemingly wasteful expand-and-reparse route is actually the safe
one.

It also explains why the complete symbol table is saved even when only a source
block is selected. A block may refer to names defined or stored elsewhere. The
importer needs the table to recover those names.

## Tape errors occur at different stages

It helps to separate failures by whether live source has changed.

### Before insertion begins

Examples:

- no matching CODE block;
- bad tape data checksum;
- payload too large to stage;
- ROM load failure.

At this point the live source is untouched. The command can return with a clean
project state.

### During incremental translation

Examples:

- invalid imported source syntax;
- live/staged memory collision;
- SPACE cancellation;
- malformed foreign line;
- command-like imported text causing an unintended path.

Earlier accepted lines remain inserted.

This division is a useful mental model:

```text
physical acquisition phase:
    all-or-nothing with respect to live source

semantic import phase:
    incremental and visible
```

## The keyboard remains part of tape operations

Tape support is not a sealed background task. The user participates at several
points:

- start-tape prompts wait for a deliberate key;
- SPACE can abort tape or import operations;
- a non-SPACE key during import requests a source-window repaint;
- filename text may be reused or supplied after a colon;
- VERIFY normally follows SAVE while retained state is still meaningful.

PROMETHEUS was designed for a person sitting in front of a cassette recorder,
not for unattended batch processing.

The physical sequence matters:

```text
prepare recorder
press a key
start or read tape
watch Found messages
request progress if desired
stop on an error or cancellation
```

## A full native round trip

Let us follow one project from editor to tape and into another live project.

### Step 1: original live project

```text
source records use original ordinals
symbol table contains START and LOOP
```

### Step 2: SAVE

```text
select source range
exclude permanent empty tail if whole source
write CODE header
write source bytes
write bridge and complete table
remember exact ranges for VERIFY
```

### Step 3: VERIFY

```text
find exact filename
compare tape source with remembered source
compare tape bridge/table with remembered table range
report success
```

### Step 4: later LOAD into another project

```text
stage complete CODE payload below U-TOP
locate staged source and table
for each imported record:
    imported ordinal → imported name
    imported record → canonical text
    canonical text → live parser
    live parser → current ordinal and new record
```

### Step 5: resulting live project

```text
old current records remain
imported records appear after the access line
shared names reuse current symbol ordinals
new names gain new current ordinals
source is entirely in canonical PROMETHEUS format
```

The physical bytes on tape were preserved exactly during acquisition, but the
live result may have different record bytes and different symbol ordinals. What
is preserved is the program's textual and symbolic meaning.

## A full foreign-source journey

The GENS route is shorter:

```text
foreign assembler stores numbered CR-terminated text
    ↓ SAVE or export from that assembler
Spectrum CODE block on tape
    ↓ GENS filename scan and staging
foreign bytes below U-TOP
    ↓ line-number removal and byte normalization
PROMETHEUS inputBuffer
    ↓ ordinary parser
canonical compressed source and live symbols
```

The resulting source is no longer “GENS format.” Once accepted, it is ordinary
PROMETHEUS source and can be edited, assembled, saved and loaded through the
native mechanisms.

## Tape support as a set of adapters

The four commands can be viewed as adapters around two central representations:

```text
                    ┌───────────────┐
                    │ live project  │
                    └───────────────┘
                       ↑         ↓
             parse text│         │select raw ranges
                       │         │
        ┌──────────────┘         └──────────────┐
        │                                       │
canonical editor text                 native tape package
        ↑                                       ↓
        │                                  physical tape
        │                                       ↑
foreign numbered text                         VERIFY
```

The editor parser is the semantic entrance. The ROM tape routines are the
physical entrance and exit. The importers connect the two.

## Why no universal file object exists

A modern program might define one structured project object and serialize it.
PROMETHEUS instead works with address ranges, patched operands and several
compact conventions.

That choice reflects both the Z80 and the machine's memory limits:

- source already exists in a useful packed form;
- the symbol table is already contiguous;
- the ROM expects raw address and length registers;
- constructing a second full project image would waste scarce RAM;
- incremental translation allows useful partial success.

The code is not organized around “files” as abstract objects. It is organized
around transformations between byte regions.

## What has changed in memory?

Across the complete tape system, different operations change different things:

### SAVE

- builds a 17-byte header workspace;
- patches retained VERIFY ranges;
- does not change source or symbols.

### VERIFY

- reads headers and compares tape data;
- does not intentionally change project bytes;
- depends on state retained by SAVE.

### LOAD

- stages a native package below U-TOP;
- temporarily redirects imported symbol resolution;
- inserts newly encoded records into live source;
- may create or reuse live symbols.

### GENS

- stages a flat foreign stream below U-TOP;
- advances through two-byte-numbered CR lines;
- rebuilds `inputBufferStart` repeatedly;
- inserts ordinary PROMETHEUS records.

## Important labels encountered

- `invokeSave`
- `invokeVerify`
- `invokeLoad`
- `invokeGens`
- `scanTapeForNextCodeHeader`
- `callRomTapeLoadOrVerify`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `patchSymbolReferenceResolverBase`
- `varcImportedDataCursor`
- `varcImportedSourceEnd`
- `varcImportedSymbolTableBase`
- `continueSourceImportAfterSubmittedLine`
- `continueGensImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`

## Ideas needed by later chapters

- Monitor tape tools will use the same ROM services but will transfer raw memory
  blocks rather than structured source projects.
- The monitor will again use shared input and display machinery while changing
  the surrounding continuation and error behavior.
- PROMETHEUS often preserves meaning by translating through a neutral textual
  representation rather than copying private internal identities.
- Memory regions are treated as moving fronts whose coexistence must be checked
  repeatedly, not only once.

## Source coverage

This chapter reconnects the complete native SAVE/VERIFY/LOAD path and the
GENS/MASM importer described in Chapters 29–31. It completes Part IV at book
level without repeating every low-level ROM or parser routine.
