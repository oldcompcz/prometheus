# Chapter 31: Importing GENS/MASM Source

PROMETHEUS can load its own saved projects, but that is not the only kind of
source a Spectrum programmer may already possess.

Another assembler may store a program as ordinary-looking text. Its lines may
have numbers at the beginning. Its characters may use bit 7 for private
purposes. It may terminate lines with carriage returns rather than with
PROMETHEUS source-record markers. It certainly will not use PROMETHEUS symbol
ordinals or its five-byte instruction descriptors.

The `GENS` command is the bridge between those worlds.

At first this sounds like a large compatibility project. One could imagine a
second parser that understands foreign syntax and directly manufactures
PROMETHEUS records. The real implementation is much smaller and more cautious:

```text
load the foreign byte stream into temporary memory
for each foreign line:
    discard its two-byte line number
    normalize its text into the ordinary edit buffer
    submit that text as though the user had typed it
```

That last step is the important one. GENS/MASM import does not create a second
assembly-language front end. It merely creates another **producer of editor
lines**. The normal PROMETHEUS parser remains the only authority that can turn
text into compressed source.

This chapter follows the import path from command dispatch to the last converted
line. Along the way we will see how it handles filenames, line numbers,
high-bit characters, overlong input, cancellation and malformed final data.

## Three command slots lead to one importer

The alphabetic command table contains these entries:

```asm
    defw invokeGens                         ; $C7 / G / GENS
    defw invokeToggleNumberBase             ; $C8 / H / decimal-hex
    defw invokeGensTokenAliasI              ; $C9 / I / import path
    defw invokeGensTokenAliasJ              ; $CA / J / import path
```

All three import labels occupy the same address:

```asm
invokeGens:
invokeGensTokenAliasI:
invokeGensTokenAliasJ:
    call prepareTapeSourceImport
```

Only `GENS` is documented as a normal user command. The `I` and `J` slots are
facts visible in the reconstructed dispatch table, but a static alias does not
by itself tell us whether every token can be produced through ordinary editor
input in every version or configuration.

For understanding the algorithm, the alias question does not matter. All three
labels enter one path.

This is a recurring lesson in reverse engineering:

> An address table tells us which destinations exist. It does not always tell us
> which destinations were intended for ordinary users.

## GENS begins exactly like native LOAD

The first helper is shared with the native project importer:

```asm
prepareTapeSourceImport:
    xor a
    ld (varcInsertMode+1),a
    call readFileNameWithColon
    call loadMatchingCodePayloadToTemporaryMemory
```

Its work is:

1. force editor INSERT mode;
2. read a new filename after `:` or reuse the retained filename;
3. scan tape for a matching Spectrum CODE header;
4. check that the payload fits below U-TOP;
5. load the payload into temporary high memory.

The staging address is calculated as:

```text
temporaryStart = U-TOP - payloadLength
```

The current source and symbol table remain where they are. The foreign bytes sit
above them, at the high end of the free region.

This gives the importer room to work incrementally:

```text
low memory                               high memory

PROMETHEUS | live source | live symbols | free | staged foreign text | U-TOP
```

As imported lines are inserted, the live source and symbols grow upward. The
staged stream is consumed from its low address upward. If those two fronts meet,
there is no longer enough room to keep both representations alive.

Native LOAD uses metadata in the CODE header to divide its payload into source
and symbol sections. GENS deliberately ignores those private PROMETHEUS fields.
For GENS, the loaded CODE block is simply one flat sequence of foreign bytes.
Its exclusive end is U-TOP itself.

## The documented foreign line format

The source comments describe each foreign line as:

```text
two bytes ignored as a line number
text bytes
$0D carriage return
```

A small example might look like this in memory:

```text
00 10 20 20 4C 44 20 41 2C 35 0D
00 20 4C 4F 4F 50 20 44 4A 4E 5A 20 4C 4F 4F 50 0D
```

Interpreted loosely:

```text
line number bytes   source text       CR
00 10               "  LD A,5"       0D
00 20               "LOOP DJNZ LOOP" 0D
```

PROMETHEUS does not decode the number. It does not check whether lines are in
ascending order. It does not preserve the numbers as comments. It simply skips
two bytes before every text line.

That choice keeps the converter independent of the foreign assembler's exact
number encoding. Binary, decimal digits or some internal token do not matter as
long as the line-number field is two bytes long.

## The continuation is changed before the first line

Ordinary source submission ends by jumping through a patchable continuation.
For normal keyboard entry that continuation returns to the warm editor.

GENS replaces it:

```asm
    ld hl,continueGensImportAfterSubmittedLine
    ld (varcPostCommandContinuationJump+1),hl
```

The resulting control flow is:

```text
convert foreign line
    ↓
submitInputLineOrDispatchCommand
    ↓
normal parser and insertion machinery
    ↓
varcPostCommandContinuationJump
    ↓
continueGensImportAfterSubmittedLine
    ↓
convert next foreign line
```

The importer therefore does not need a private loop surrounding the parser. The
normal parser returns directly to the import continuation after every accepted
line.

This is the same continuation technique we saw in editor commands and native
LOAD. PROMETHEUS often turns a normally terminal editor operation into one stage
of a larger workflow by replacing one jump operand.

## Building one normal edit line

The converter begins here:

```asm
.importNextGensLine:
    ld b,001h
    ld de,inputBufferStart
    ld hl,(varcImportedDataCursor+1)
    inc hl
    inc hl
```

The registers have simple roles:

```text
HL = next foreign input byte
DE = next byte in PROMETHEUS inputBuffer
B  = occupied edit-buffer positions, including the future cursor marker
```

`HL` is advanced twice, discarding the line number.

Why does `B` start at one rather than zero? The fixed 32-byte input area needs
one position for PROMETHEUS's `$01` cursor/end marker. Only 31 positions can
contain imported text.

The basic algorithm is:

```text
used = 1
source = importedCursor + 2
output = inputBufferStart

until source byte is CR:
    if fewer than 31 text bytes have been kept:
        normalize byte
        store it
        used += 1
    source += 1

remember source as next imported cursor
append $01 marker
zero-fill the rest of the 32-byte input area
submit the line normally
```

## Carriage return is the only line boundary

The scan loop first tests for `$0D`:

```asm
.scanNextGensLineByte:
    ld a,(hl)
    inc hl
    cp 00dh
    jr z,.finishCurrentGensLine
```

Nothing else ends a line. A zero byte is treated as a control character and
becomes a space. A Spectrum BASIC-style high-bit end marker is merely stripped
to seven bits. The importer is specifically looking for carriage-return
terminated text.

This means the physical payload must have a proper CR after every line. The
command is not a general text-file autodetector.

## Overlong lines are truncated without losing alignment

The test for remaining capacity is compact:

```asm
    bit 5,b
    jr nz,.scanNextGensLineByte
```

`B` began at 1 and is incremented after every retained character. Once it reaches
32, bit 5 becomes set. Further characters are not stored.

Crucially, the routine still keeps reading until CR.

A careless implementation might stop reading when the edit buffer becomes full.
Then the unread tail of the long line would be mistaken for the next line's two
line-number bytes, corrupting every following record.

PROMETHEUS instead does this:

```text
first 31 characters:
    retain

remaining characters before CR:
    discard, but continue scanning

next byte after CR:
    correctly begins the following foreign line
```

No truncation error is reported. The surviving prefix is submitted to the
ordinary parser. It may be valid, or it may fail with a normal source-entry
error.

For example:

```text
foreign line:
    VERYLONGNAME EQU SOMEEXPRESSIONTHATCONTINUES...

retained line:
    VERYLONGNAME EQU SOMEEXPRESSION
```

The parser sees only the retained form. The importer itself does not know whether
truncation changed the meaning.

## Control characters become spaces

For a byte that still fits, the converter distinguishes printable values from
control characters:

```asm
    cp 020h
    jr nc,.storeNormalizedGensLineByte
    ld a,020h
.storeNormalizedGensLineByte:
    and 07fh
```

The implemented rules are:

```text
$0D:
    terminate line

$00-$1F, except $0D:
    store one ordinary space

$20-$FF:
    clear bit 7 and store the result
```

TAB is therefore not expanded to the next tab stop. It becomes one space.
Repeated controls become repeated spaces. Repeated existing spaces are retained.

The surviving manual advice that one space is enough should be read as a
recommendation for preparing compact source, not as a statement that the
converter collapses whitespace.

## Why clear bit 7?

Some Spectrum text formats use the top bit for marking the last character of a
word or line. PROMETHEUS itself uses that convention in several compact tables.
A foreign assembler may also leave high bits set in stored source.

The instruction:

```asm
    and 07fh
```

turns every retained character into ordinary seven-bit text.

For example:

```text
foreign byte  PROMETHEUS input character
$CC           $4C = 'L'
$CF           $4F = 'O'
$CF           $4F = 'O'
$D0           $50 = 'P'
```

The converter does not interpret the foreign high-bit convention. It simply
removes the bit and lets the normal PROMETHEUS tokenizer decide what the visible
characters mean.

## Finishing the edit buffer

When CR is reached, the next source address is saved directly inside the load
instruction used by the next iteration:

```asm
.finishCurrentGensLine:
    ld (varcImportedDataCursor+1),hl
    ld a,001h
    ld (de),a
```

The `$01` is the editor's movable cursor/end marker. Although this line is being
imported automatically and no human cursor is visible, the parser expects the
same input representation used by keyboard editing.

The rest of the fixed input area is cleared:

```asm
.clearRemainingGensInputBuffer:
    inc de
    xor a
    ld (de),a
    inc b
    bit 5,b
    jr z,.clearRemainingGensInputBuffer
```

The resulting buffer looks like this:

```text
text bytes | $01 | zeroes to the end of the 32-byte area
```

Then the importer resets parser scratch buffers and enters the ordinary command
submission path:

```asm
    call clearStringBuffers
    jp submitInputLineOrDispatchCommand
```

The jump is significant. There is no special GENS parser beyond this point.

## Foreign source is judged by PROMETHEUS rules

Once submitted, the line goes through the same stages as keyboard text:

```text
inputBuffer
    ↓
source-or-command decision
    ↓
field splitting
    ↓
mnemonic lookup
    ↓
operand classification
    ↓
expression and symbol processing
    ↓
compressed-record construction
    ↓
INSERT into live source
```

This gives the converter several useful properties for free.

### Symbol names enter the current table normally

A foreign line containing:

```asm
LOOP    DJNZ LOOP
```

causes the normal symbol parser to find or create `LOOP` in the live table. No
foreign symbol table is needed.

### Unsupported syntax fails visibly

If the foreign assembler accepted a spelling PROMETHEUS does not understand,
the ordinary editor reports `Bad mnemonic`, `Bad operand`, `Bad instruction` or
another familiar source error.

The offending converted text remains available for inspection and repair.

### The internal source format stays canonical

Even if several external spellings are equivalent, imported lines are stored in
the same compact representation as typed lines. Later expansion uses
PROMETHEUS's canonical mnemonic and operand spelling.

### One parser means one set of bugs and fixes

Any correction made to normal source entry automatically improves GENS import.
There is no second record constructor to keep synchronized.

## An imported line can accidentally look like a command

The shared submission path first decides whether the prepared line is source or
a tokenized command. This raises a subtle consequence.

GENS is intended for assembler source lines, and normal assembler syntax usually
contains leading spaces, labels, mnemonics or comments. But the imported text is
not tagged as “definitely source.” It is passed through the same discriminator as
a typed line.

A line whose normalized form matches an editor command could therefore enter
command dispatch rather than source insertion.

The design assumes that the foreign file contains assembly-language source in a
form accepted by the normal editor. The converter is not a protected batch
language of its own.

This is another example of deliberate reuse bringing both advantages and
observable semantics.

## Continuing after successful insertion

When the parser and inserter finish, the patched continuation runs:

```asm
continueGensImportAfterSubmittedLine:
    call pollImportKeyboardAndRefreshIfRequested
    ld hl,(varcImportedDataCursor+1)
    ld de,(varcUTop+1)
    and a
    sbc hl,de
    jr c,.importNextGensLine
    jr .finishSourceImport
```

Three things happen.

### First: allow cancellation or progress display

`pollImportKeyboardAndRefreshIfRequested` performs a quick keyboard scan:

```text
no key:
    continue immediately

SPACE:
    abort to the editor

any other key:
    repaint the visible source window, then continue
```

The unusual fall-through into `renderVisibleSourceRecords` implements an
on-demand progress display without repainting after every imported line.

Constant repainting would make import slower. No repaint would make a long load
look frozen. PROMETHEUS lets the user request a view by pressing any non-SPACE
key.

### Second: compare the stream cursor with U-TOP

For GENS, U-TOP is the exclusive end of the staged data. While:

```text
importedCursor < U-TOP
```

the routine assumes another foreign line begins there.

Equality or a higher address ends the import.

### Third: restore ordinary editor continuation

GENS shares native LOAD's completion path:

```asm
.finishSourceImport:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
    jp (hl)
```

The temporary continuation is removed before normal editing resumes.

## A malformed final line can cross the boundary

The U-TOP comparison happens **between lines**, not for every scanned byte.

Suppose the final foreign line has no carriage return. The scan loop keeps
advancing `HL`, looking for `$0D`, even after it passes U-TOP. Only after a CR is
finally found can control return to `continueGensImportAfterSubmittedLine` and
perform the boundary comparison.

The source comments preserve the manual's warning that U-TOP at `$FFFF` may let
such a scan wrap around into low ROM addresses. Choosing a slightly lower U-TOP
reduces that extreme danger, but the true file-format requirement is simpler:

> Every foreign line, including the last, must end with carriage return.

This is not modern bounds-checked parsing. It is compact 1980s code operating on
trusted tape data with a documented preparation rule.

## Import is not transactional

Like native LOAD, GENS inserts one line at a time.

If ten lines succeed and line eleven fails, the first ten remain in the source.
If the user presses SPACE, all lines inserted before the cancellation remain. If
an overlong line truncates into invalid syntax, earlier work is not rolled back.

The operation behaves more like a typist entering lines rapidly than like a
modern atomic file import:

```text
for each line:
    try to type and insert it
    stop on failure
```

This has two practical consequences.

1. The user can inspect and repair the partially imported result.
2. Re-running the import without first removing the prefix may duplicate lines.

The behavior is consistent with PROMETHEUS's limited memory. Transactional
rollback would require retaining enough information to undo a changing source
and symbol table, exactly while the staged foreign file is already consuming the
high free region.

## GENS and native LOAD solve different translation problems

The two importers share staging and line submission, but they begin from
different representations.

### Native LOAD

```text
compressed PROMETHEUS record
+ imported PROMETHEUS symbol table
    ↓ expand with imported symbol names
canonical text line
    ↓ ordinary parser
new live compressed record
```

The central problem is translating imported **symbol ordinals** into the current
symbol table.

### GENS/MASM

```text
foreign line number + text + CR
    ↓ discard number and normalize bytes
ordinary text line
    ↓ ordinary parser
new live compressed record
```

The central problem is translating a foreign **text container** into the editor's
input-buffer convention.

After that first translation, both paths deliberately converge.

## A complete example

Imagine a staged foreign payload containing three lines:

```text
[number]["        ORG 32768"][CR]
[number]["START   LD B,5"][CR]
[number]["LOOP    DJNZ LOOP"][CR]
```

For the second line, the importer performs these steps:

```text
1. importedCursor points at the two line-number bytes
2. skip both bytes
3. copy S T A R T spaces L D space B , 5
4. clear bit 7 of each copied byte
5. append $01
6. zero-fill the fixed buffer
7. submit through normal source entry
8. find or create symbol START
9. find mnemonic LD
10. classify B as a fixed operand
11. encode 5 as an expression atom
12. build and insert the compressed record
13. return through continueGensImportAfterSubmittedLine
14. advance to the next foreign line
```

At no point does the GENS routine need to know the compressed record layout. The
normal parser supplies that knowledge.

## The small converter in pseudocode

The whole feature can be expressed compactly:

```text
function importForeignSource(name):
    force INSERT mode
    stagedStart, stagedEnd = loadMatchingCodeBelowUTop(name)
    cursor = stagedStart
    editorContinuation = continueImport

    while cursor < stagedEnd:
        cursor += 2                    // discard line number
        line = empty

        while memory[cursor] != CR:
            byte = memory[cursor]
            cursor += 1

            if length(line) < 31:
                if byte < SPACE:
                    byte = SPACE
                line.append(byte AND $7F)

        cursor += 1                    // pass CR
        inputBuffer = line + CURSOR_MARKER + zeroPadding
        submitInputLineNormally()

continueImport:
    pollForAbortOrProgressDisplay()

    restoreNormalEditorContinuation()
```

The real code is shorter because state such as `cursor` and `editorContinuation`
is kept inside instruction operands rather than in a formal object.

## What has changed in memory?

During import:

- the foreign CODE payload is staged immediately below U-TOP;
- `varcImportedDataCursor+1` advances through that payload;
- `varcPostCommandContinuationJump+1` points at the GENS continuation;
- `inputBufferStart` is rebuilt for every foreign line;
- successfully parsed lines enlarge the live compressed source;
- new names may enlarge and rearrange the live symbol table;
- the staged bytes themselves are not rewritten.

At normal completion:

- the live source contains newly encoded PROMETHEUS records;
- imported line numbers and high-bit conventions are gone;
- the staged high-memory bytes become disposable;
- the ordinary editor continuation is restored.

## Why this design is worth remembering

The GENS importer is a fine example of a small-system design principle:

> Translate an unfamiliar representation into the system's ordinary public
> input, then reuse the trusted path.

PROMETHEUS does not ask its tape converter to understand symbol records,
instruction descriptors or source-memory insertion. It asks the converter to
produce one plausible editor line at a time.

That is why a compatibility feature spanning two assemblers can fit into a few
dozen Z80 instructions.

## Important labels encountered

- `invokeGens`
- `invokeGensTokenAliasI`
- `invokeGensTokenAliasJ`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `varcImportedDataCursor`
- `.importNextGensLine`
- `.scanNextGensLineByte`
- `.finishCurrentGensLine`
- `continueGensImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`
- `submitInputLineOrDispatchCommand`
- `.finishSourceImport`

## Ideas needed by later chapters

- Several monitor operations will again reuse ordinary editor and assembler
  input machinery rather than creating private parsers.
- Tape data is often staged in a high-memory region before being interpreted.
- A patchable continuation can turn one ordinary operation into a stage of a
  larger state machine.
- Historical importers may trust file terminators more than modern readers
  expect.

## Source coverage

This chapter explains the GENS/MASM import block from `invokeGens` through
`continueGensImportAfterSubmittedLine`, together with its shared use of
`prepareTapeSourceImport`, `varcImportedDataCursor`,
`pollImportKeyboardAndRefreshIfRequested` and the normal editor submission
pipeline.
