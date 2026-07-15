# Chapter 29: Saving Source and Symbols

A program held only in RAM is a temporary visitor.

On a 48K Spectrum, switching off the machine erases the editor's compressed
source, the symbol table and every assembled byte that has not been written to
tape. PROMETHEUS therefore needs a way to preserve not merely machine code, but
the working form of a project: the source records and the names that give those
records meaning.

Its native `SAVE` command writes both as one Spectrum CODE payload.

That sentence sounds simple. The implementation has to solve several less
obvious problems:

- source and symbols occupy two adjacent but differently structured regions;
- the editor keeps permanent empty records between them that should not be part
  of the saved program;
- a selected block can be saved instead of the whole source;
- even a block still needs the complete symbol table to interpret its ordinals;
- Spectrum tape headers know a total byte length, but native LOAD also needs to
  know where the source portion ends;
- `VERIFY` must later compare exactly the memory ranges that were saved;
- the tape ROM expects a particular state and timing sequence.

This chapter begins with the logical package visible to a programmer, descends
into the header and memory arithmetic, and then returns to the complete journey
from editor memory to tape.

## What the user asks for

PROMETHEUS accepts four useful forms:

```text
SAVE :name      save the whole source under a new name
SAVE            save the whole source using the retained name
SAVE b:name     save the selected block under a new name
SAVE b          save the selected block using the retained name
```

The command parameter `b` means the inclusive block marked in the editor. A
colon introduces a filename of at most ten characters.

The most recent filename is remembered in:

```asm
fileNameBuffer:
    defb "prometheus"
```

So the initial default is `prometheus`. A shorter newly entered name is padded
with spaces to the ten bytes required by a Spectrum tape header.

This small retained buffer makes repeated tape work less tedious:

```text
SAVE :lesson1
VERIFY
SAVE
```

The final `SAVE` reuses `lesson1` unless another command has replaced the
retained name.

## The saved object is not the assembled program

The editor's native SAVE path preserves:

```text
compressed source records
complete current symbol table
```

It does not mean “save bytes emitted by the last assembly.” The monitor has
separate commands for arbitrary memory blocks, and the Spectrum's ordinary CODE
format can also hold generated code. Here we are interested in a project that
can be loaded back into the PROMETHEUS editor.

This distinction is essential. A machine-code image contains enough information
to run, but not enough to recover comments, labels, expressions, directives and
editor structure reliably.

## One logical package, two live regions

In memory, meaningful source lies below the symbol table:

```text
sourceBufferAccessLine
    ... compressed source records ...
    ... six permanent empty records ...
varcSymbolTablePt
    symbol count
    ordinal vectors
    value/name records
varcCodeEndPt
```

The twelve bytes immediately below `varcSymbolTablePt` are six two-byte empty
records. They are structural editor padding, not part of the user's program.

Whole-source SAVE therefore chooses:

```text
sourceStart = sourceBufferAccessLine
sourceEnd   = varcSymbolTablePt - 12
```

The range is half-open:

```text
[sourceStart, sourceEnd)
```

That notation means the first byte is included and `sourceEnd` itself is not.
The source length is simply:

```text
sourceLength = sourceEnd - sourceStart
```

The code uses the two's-complement value `$FFF4`, which is -12:

```asm
    ld hl,(varcSymbolTablePt+1)
    ld de,0fff4h
    add hl,de
    ld de,sourceBufferAccessLine
```

The arithmetic looks cryptic until we name the objects:

```text
HL = exclusive end of meaningful source
DE = first meaningful source record
```

## Saving an inclusive selected block

The editor stores two block margins and treats both endpoint records as part of
the selection. Tape output is easier to calculate as a byte interval with an
exclusive end.

`getSelectedBlock` returns the normalized first and last records. SAVE then
advances once from the final record:

```asm
.selectSaveBlockRange:
    call getSelectedBlock
    ex de,hl
    call getNextSourceRecord
```

After this conversion:

```text
DE = first selected record
HL = first byte after final selected record
```

The source length is again `HL-DE`.

The pattern has appeared throughout the editor:

```text
human-facing block      inclusive first and last records
memory-moving interval  half-open [start,end)
```

The half-open form avoids special cases. An empty length is zero, adjacent ranges
meet exactly, and subtraction gives the byte count directly.

## Why block SAVE still includes every symbol

A selected block may refer to symbols defined outside the block. It may also use
ordinal numbers whose identities belong to the complete current table.

PROMETHEUS does not build a reduced table by tracing only the chosen records.
Even `SAVE b` writes the whole symbol table.

This is a sensible 1980s trade-off:

- SAVE remains compact and quick;
- no temporary dependency graph is required;
- the saved records can always resolve their original ordinals;
- unused names may occupy some extra tape space.

The later LOAD path will not copy those ordinals into the live source directly.
It will use the imported table to turn them back into names, which makes a full
table safe even when loading into a project with a different ordinal order.

## The seventeen-byte Spectrum header

PROMETHEUS constructs a standard Spectrum tape header in the bottom line of
bitmap memory:

```asm
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld (ix+000h),003h
```

Type 3 means CODE.

The fields used by native source SAVE are:

```text
offset  size  meaning
+0      1     type = 3 (CODE)
+1      10    space-padded filename
+11     2     complete payload length
+13     2     ordinary CODE parameter 1, not used by native LOAD
+15     2     PROMETHEUS source portion length
```

The last field is the clever extension. A standard CODE header has two parameter
words. PROMETHEUS repurposes bytes 15 and 16 to remember how many bytes at the
start of the data belong to compressed source.

Native LOAD can then recover the internal division without searching records or
trusting a fixed table address.

## Copying the retained filename

After optional colon parsing, the ten persistent filename bytes are copied to
the header:

```asm
.copySaveNameIntoCodeHeader:
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
    ld bc,0000ah
    ldir
```

`readFileNameFromInput` accepts up to ten logical input characters. If the name
ends earlier, it fills the rest with spaces.

The persistent buffer is not modified merely because it is copied into a tape
header. It remains available for the next SAVE or LOAD.

## Calculating the table length

The symbol table begins at `varcSymbolTablePt` and the combined dynamic region
ends at `varcCodeEndPt`.

The table byte length is:

```text
tableLength = varcCodeEndPt - varcSymbolTablePt
```

The source code performs the subtraction, temporarily increments the result for
the chained writer, stores that auxiliary length for VERIFY, then returns to the
ordinary table length while calculating the complete payload.

At the logical level, define:

```text
S = sourceLength
T = tableLength
```

The saved data payload has the form:

```text
source bytes [S]
two-byte bridge
symbol-table bytes [T]
```

So the complete CODE data length is:

```text
S + 2 + T
```

The header receives:

```text
bytes 11..12 = S + T + 2
bytes 15..16 = S
```

## The mysterious two-byte bridge

The two bytes between source and table are not source records and are not part
of the symbol-table base used by LOAD.

The writer first sends the source segment through the ordinary ROM SAVE control
entry. It then begins a compact continuation one byte before the live symbol
table and enters `ROM_SA_SET` with specially arranged marker state.

The resulting logical payload contains two bridge bytes before the table.

The reconstructed source proves their presence because:

- SAVE adds 2 to the combined length;
- LOAD calculates the imported table base as `sourceEnd+2`;
- native records stop at `sourceEnd`, never consuming those bytes.

Their individual waveform-level roles in the ROM's chained writer are not
needed to understand PROMETHEUS's file format. A careful reconstruction should
not invent names for behavior that has not been separately proved.

For the book, the correct model is simply:

```text
[source][two-byte bridge][table]
```

## Remembering the exact SAVE for VERIFY

VERIFY does not recalculate the current source range. SAVE patches four fields
inside later instructions:

```text
varcLastSavedSourceStart
varcLastSavedSourceLength
varcLastSavedSymbolTableStart
varcLastSavedAuxiliarySegmentLength
```

The source writes values directly into instruction operands:

```asm
    ld (varcLastSavedSourceStart+2),de
    ld (varcLastSavedSourceLength+1),hl
    ld (varcLastSavedSymbolTableStart+2),de
    ld (varcLastSavedAuxiliarySegmentLength+1),hl
```

This is another use of code as persistent state.

Why remember actual addresses rather than just the filename and header lengths?
Because VERIFY must compare the tape bytes against the exact memory segments
that were written:

```text
source segment  may be a selected block rather than the whole source
table segment   begins elsewhere and uses the chained protocol
```

This also explains the old manual rule: VERIFY belongs immediately after SAVE.
If the editor changes source or symbols first, the remembered ranges may no
longer contain the saved bytes.

## Asking the user to start the recorder

Before writing the header, PROMETHEUS displays the `Start tape` status message.
`waitForKeyAndWriteTapeHeader` then:

1. performs a short busy delay;
2. waits until any physical key is pressed;
3. calls the ROM SAVE routine with a 17-byte header block;
4. performs a second delay before the data block.

The key wait reads the keyboard matrix directly:

```asm
.waitForTapeStartKey:
    xor a
    in a,(0feh)
    cpl
    and 01fh
    jr z,.waitForTapeStartKey
```

The active-low keyboard bits are complemented, masked and tested. Which key was
pressed does not matter; the press means “the recorder is ready.”

For the header call:

```text
IX = header address
DE = 17
A  = 0, the header flag
```

The data block follows with the standard `$FF` flag.

## Writing the two logical segments

At the high level, SAVE behaves like this:

```text
choose whole source or selected block
parse or reuse filename
build CODE header
remember source and table ranges for VERIFY
show Start tape
write header
write source bytes
continue writer through bridge and symbol table
allow SPACE to abort
```

The real source around the first data write is compact:

```asm
    pop de
    pop ix
    ld a,0ffh
    call ROM_SaveControl_4c6
```

At this point:

```text
IX = selected source start
DE = source length
A  = $FF data flag
```

The continuation then reloads the remembered symbol-table position and
auxiliary length from self-modified operands and enters the ROM's lower-level
marker/setup path.

The unusual sequence is not decorative cleverness. It lets two noncontiguous
live memory regions appear as one logical tape payload without first copying
both into a separate temporary buffer.

That saves RAM—exactly the resource PROMETHEUS is trying to preserve.

## A worked layout example

Imagine a small editor state with:

```text
meaningful saved source length S = 80 bytes
symbol table length T            = 46 bytes
```

The header stores:

```text
sourceLength = 80
completeLength = 80 + 2 + 46 = 128
```

The tape data block logically contains:

```text
offset 0..79    80 compressed source bytes
offset 80..81   two-byte bridge
offset 82..127  46 symbol-table bytes
```

LOAD can later stage the 128-byte block at any temporary address `P` and derive:

```text
importedSourceStart = P
importedSourceEnd   = P + 80
importedTableBase   = P + 82
```

No absolute source or table address is stored in the data. The header lengths
provide the necessary structure.

## Saving a block is a project fragment, not an isolated binary

Suppose a selected block contains:

```asm
DRAW    CALL PIXEL
        RET
```

and `PIXEL` is defined elsewhere. The saved block still includes the complete
symbol table, so its record for `CALL PIXEL` can be expanded later.

When it is loaded into another project, the imported ordinal for `PIXEL` is not
trusted as a live ordinal. LOAD resolves the imported name and lets the normal
parser create or find the appropriate current symbol.

The SAVE format is therefore a transport representation for source semantics,
not a promise that internal table offsets or ordinal numbers will remain
unchanged forever.

## Cancellation and failure

SPACE is the common cancellation key during tape operations. The helper
`abortCurrentOperationIfSpacePressed` preserves the ROM's flags when SPACE is
not held and jumps back to the editor when it is.

A SAVE interrupted by the recorder, tape, or user may leave an unusable tape
block, but it does not need to undo editor memory: source and symbols were read,
not moved or modified, apart from the harmless retained VERIFY metadata.

## In plain pseudocode

```text
function save(command):
    header.type = CODE

    blockMode = command contains B
    if command contains ':':
        retainedName = readAtMostTenCharactersAndPadWithSpaces()

    header.name = retainedName

    if blockMode:
        sourceStart = selectedBlock.firstRecord
        sourceEnd = addressAfter(selectedBlock.lastRecord)
    else:
        sourceStart = sourceBufferAccessLine
        sourceEnd = symbolTableStart - 12

    sourceLength = sourceEnd - sourceStart
    tableStart = symbolTableStart
    tableLength = codeEnd - tableStart

    header.totalLength = sourceLength + 2 + tableLength
    header.prometheusSourceLength = sourceLength

    rememberForVerify(
        sourceStart,
        sourceLength,
        tableStart,
        tableLengthAndWriterState
    )

    display "Start tape"
    waitForAnyKey()
    romSave(header, 17, HEADER_FLAG)
    romSaveSourceThenChainBridgeAndTable(
        sourceStart,
        sourceLength,
        tableStart,
        tableLength
    )
```

## What has changed in memory

SAVE does not rearrange the live source or table. It changes only temporary and
remembered state:

- the bottom bitmap line contains the 17-byte CODE header workspace;
- `fileNameBuffer` may contain a newly entered padded name;
- the header total-length word contains `S+T+2`;
- the header final word contains `S`;
- four self-modified fields remember the source and table ranges for VERIFY;
- ROM tape state temporarily owns timing, border and MIC behavior;
- the compressed source and symbol-table bytes themselves remain in place.

## Important labels encountered

- `invokeSave`
- `fileNameBuffer`
- `readFileNameWithColon`
- `readFileNameFromInput`
- `copyFileNameFromHLToDE`
- `getSelectedBlock`
- `getNextSourceRecord`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `varcLastSavedSourceStart`
- `varcLastSavedSourceLength`
- `varcLastSavedSymbolTableStart`
- `varcLastSavedAuxiliarySegmentLength`
- `waitForKeyAndWriteTapeHeader`
- `ROM_SaveControl_4c6`
- `ROM_SA_SET`
- `abortCurrentOperationIfSpacePressed`

## Back to the bigger picture

PROMETHEUS has turned two live, separately structured memory regions into one
portable object:

```text
editor source
    + complete symbol meaning
    + small structural bridge
    + lengths in a standard CODE header
    -> one tape data block
```

The format is compact because it does not expand source to text and does not
copy the project into an intermediate RAM package before saving.

The next chapter follows the reverse direction. But LOAD is not a mirror image
that blindly copies bytes home. It stages the package in high memory and feeds
each imported line back through the editor, translating names and validating
syntax as it goes.
