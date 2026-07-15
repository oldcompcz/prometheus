# Chapter 14: Turning a Record Back into Text

PROMETHEUS never treats the source-window pixels as the program. The real
program is the compressed record chain in memory.

Whenever a line must be displayed, edited, printed, searched as text, or
converted into another form, PROMETHEUS reconstructs a readable line from one
record.

This reverse conversion is not merely decompression in the ordinary sense. The
record does not contain all visible characters. The expander must combine
information from several places:

```text
source record
instruction table
mnemonic string table
operand string table
symbol table
editor field-width rules
current display case option
selected-block boundaries
```

Only together do they produce the familiar assembly line.

## The whole outward journey

The principal routine is `expandSourceRecordToLineBuffer`.

At the highest level:

```text
clear 32-byte lineBuffer

if record is a comment:
    copy comment text
else:
    reconstruct optional label field
    decode opcode/prefix metadata
    reconstruct mnemonic field
    reconstruct first operand
    if second operand exists:
        append comma
        reconstruct second operand

insert private field markers
terminate line
```

That produces a neutral editor line. A second stage,
`printExpandedSourceLineWithRoutine`, scans it and sends characters to a
caller-selected destination.

Thus expansion itself does not know whether the result is going to:

- the Spectrum screen;
- a printer;
- a FIND comparison routine;
- a REPLACE builder;
- another text consumer.

The same semantic reconstruction serves them all.

## The destination is cleared first

The default entry chooses `lineBuffer`:

```asm
expandSourceRecordToLineBuffer:
    ld hl,lineBuffer
expandSourceRecordToHL:
    push hl
    ld bc,02000h
    call atHLrepeatBTimesC
    pop hl
```

`BC=$2000` is the compact calling convention for:

```text
B = 32 bytes
C = zero fill byte
```

The buffer is therefore a clean 32-byte, zero-terminated workspace before any
field is written.

The secondary entry `expandSourceRecordToHL` allows another caller to provide a
different destination while reusing the same algorithm.

## Comments are almost literal

A comment record is recognized by its exact two-byte identity:

```text
opcode       $01
information  $37
```

The expander then copies bytes from record offset `+2` until it reaches a value
in the `$C0`–`$FF` terminal range.

Before each test it prewrites `$01` at the current output position:

```asm
.expandCommentRecordLoop:
    ld a,(ix+002h)
    cp 0c0h
    ld (hl),001h
    ret nc
    inc ix
    ld (hl),a
    inc hl
    jr .expandCommentRecordLoop
```

The final `$01` becomes the edit-line cursor/field marker used when the line is
opened for editing.

No mnemonic or symbol table is consulted. The prose was stored literally, so it
can be returned literally.

## Structured lines begin with a nine-character label field

For an ordinary source record, the expander prepares a field of
`LABEL_LENGTH`, which is nine characters.

If information bit 3 is clear, it simply fills that field with spaces.

If the bit is set, the first two variable bytes are a symbol ordinal. The
expander calls `resolveRecordLabelAfterHeader`, which ultimately reaches
`resolveSymbolReferenceToName`.

That resolver performs several levels of indirection:

```text
ordinal from source record
    → two-byte vector in symbol table
    → offset of value/name entry
    → high-bit-terminated symbol spelling
```

It deliberately does **not** interpret the record bytes as an address. Source
and symbol storage can move; the ordinal remains stable.

The spelling is copied left-aligned and the rest of the nine-character field is
space-padded.

Conceptually:

```text
symbol name "LOOP"
field width 9
result "LOOP     "
```

If a spelling exceeds the available field, the shared copy routine reports a
source error instead of overwriting the next field.

## The record does not store the mnemonic spelling

After the label field, the expander knows only:

- opcode byte from record offset 0;
- prefix-family nibble from record offset 1.

It must recover the instruction-table record that originally produced them.

`decodeInstructionTableRecord` searches the ordered instruction metadata and
returns:

- mnemonic-table index in `A`;
- first operand descriptor in `D`;
- second operand descriptor in `E`.

The search is a stride-halving ordered search rather than a linear scan. It
begins with a large record-aligned displacement, compares opcode and normalized
prefix family, and repeatedly halves its search window.

In broad pseudocode:

```text
key = (opcode, normalizedPrefixFamily)
position = middle of ordered instruction table
stride = initialHalfTableStride

repeat limited number of times:
    if table[position].key == key:
        unpack mnemonic and operands
        return success

    if table[position].key < key:
        position += stride
    else:
        position -= stride

    stride = next smaller record-aligned stride

return damaged-record failure
```

This is the reverse of Chapter 13's source-entry search. There the parser knew
mnemonic and operand classes and sought an instruction record. Here the
expander knows opcode and prefix metadata and recovers mnemonic and operand
descriptors.

## DD and FD are normalized during lookup

IX and IY instructions share table records. If the source information byte says
FD, the decoder temporarily converts it to the common DD-family key and records
which textual variant must later be restored.

After unpacking operand descriptors, it adjusts IX-shaped descriptors to their
IY spellings where necessary.

The result is the same normalization pattern seen during encoding, but in the
opposite direction:

```text
stored FD family
    → search common indexed metadata
    → return IY-flavoured operand descriptors
```

The table stays compact while the reconstructed text remains faithful to the
user's chosen register.

## Damaged metadata is visible as a source error

If no instruction-table entry matches the stored opcode and prefix family,
`expandSourceRecordToLineBuffer` does not guess. It sets a source-error status
for the next editor repaint and returns.

This matters because the compressed source is a structured database. A stray
byte in it can create a combination that never came from the encoder.

PROMETHEUS checks the integrity of its own internal language at the point where
that language is interpreted.

## A private marker separates source fields

Once instruction metadata has been decoded, the expander writes `$01` before
the mnemonic field:

```asm
.appendExpandedMnemonic:
    ld (hl),001h
```

It later writes another `$01` before operands.

These bytes are not displayed as characters. They serve the editable-line and
source-output scanners as invisible structural markers.

The reconstructed buffer therefore resembles:

```text
label text and padding
$01
mnemonic text and padding
$01
operand text
$00...
```

The editor can place its movable cursor at a meaningful field boundary without
storing those boundaries in persistent source.

## Mnemonic text comes from a packed table

The decoded mnemonic index selects a spelling through `mnemonicsReferences` and
`getStringFromTableDE`.

The reference vector uses one-byte self-relative displacements, introduced in
Chapter 6. `getStringFromTableDE` calculates:

```text
tableBase + index + table[index]
```

and returns a pointer to the high-bit-terminated spelling.

The mnemonic is copied into a five-character field and space-padded.

Definition pseudo-records need a small index adjustment so that `$06` through
`$09` map back to the shared `DEFB`, `DEFM`, `DEFS` and `DEFW` spellings.

Again the visible word is not stored in the source record. It is reconstructed
from compact semantic identity.

## Fixed operands are table words

`expandOperandByDescriptor` receives one operand descriptor in `A`.

Values below `$2C` refer to fixed operand spellings:

```text
A
BC
HL
NZ
(BC)
IX
...
```

The routine resolves the descriptor through `operandsReferences` and copies the
packed string into the output line.

This is the cheapest kind of operand reconstruction:

```text
descriptor  →  known spelling
```

No bytes need to be consumed from the variable expression payload.

## Expression operands combine templates and stored bytes

Descriptors `$2C` and above say that variable expression material follows.

The descriptor determines an outer textual template:

```text
$2C    expression
$2D    (expression)
$2E    (ix+displacement)
$2F    (iy+displacement)
```

The expander writes characters implied by the descriptor:

- opening parenthesis where required;
- `ix` or `iy` for indexed forms;
- a plus sign before a nonnegative indexed displacement;
- closing parenthesis at the end.

Only the variable part is read from the record.

For example, a record for:

```asm
        LD A,(IX+TABLE-2)
```

need not store the characters `(`, `i`, `x`, `+`, or `)`. They are consequences
of the operand descriptor. It stores only the encoded expression for
`TABLE-2`.

This is semantic compression in its clearest form.

## Why a plus sign may be added during expansion

For an indexed displacement, the record's expression may begin with `-`. If it
does, the expander leaves it alone:

```text
(ix-3)
```

If it does not begin with minus, the visible syntax requires an explicit plus:

```text
(ix+3)
```

The plus is therefore generated, not stored.

A direct expression such as `LABEL+2` retains its internal plus because that
operator belongs to the expression itself. The distinction is:

```text
plus implied by indexed-address template
plus written as an expression operator
```

## Literal expression bytes are copied directly

Inside `.expandEncodedExpressionLoop`, bytes below `$80` are ordinary expression
characters.

They are copied until one of two structural boundaries appears:

- `$1F`, separating two expression-bearing machine operands;
- `$C0` or above, ending the variable record.

Examples of copied bytes include:

```text
0 1 2 # % + - * / ? " '
```

The persistent expression was deliberately kept close enough to source text
that reconstruction remains simple.

## Symbol references become names again

Bytes `$80` through `$BF` introduce a two-byte ordinal. The expander:

1. reads the tagged high and low bytes;
2. resolves the ordinal through the current symbol table;
3. copies the high-bit-terminated name into the output line;
4. resumes scanning the encoded expression.

Thus the two persistent bytes may expand to a much longer spelling:

```text
$80,$25  →  LOOP_COUNTER
```

This is why expansion must consult live symbol storage. The source record knows
identity; the symbol table knows presentation and current value.

## Two operands are separated by metadata, not stored comma text

After expanding the first operand, the routine examines the second descriptor
returned from the instruction table.

If it is zero, the line is complete.

If it is nonzero, the expander writes a visible comma and expands the second
operand.

The internal `$1F` byte stops the first encoded expression at the right point.
The visible comma comes from the fact that the instruction has two operands.

This arrangement avoids storing a comma that the metadata already implies.

## Definition lists are a controlled exception

Definition records can have an arbitrary list of expressions:

```asm
        DEFB 1,2,3,4
```

The instruction metadata cannot know how many items occur. Their commas are
therefore present as ordinary payload bytes and are copied during expression
expansion.

`DEFM` similarly contains literal string characters that must be reproduced.

A single outer record format can contain several small inner languages. The
pseudo-opcode tells the expander which interpretation applies.

## The neutral line is not yet the final display

After expansion, `lineBuffer` contains a readable zero-terminated line with
private `$01` field markers.

`renderSourceRecord` adds display context.

First it asks whether the record lies inside the current selected block. If so,
it writes marker byte `$03` at `lineBufferMarkerPosition`.

That marker is intended to render using an all-filled ROM glyph, producing a
visible block-selection sign. The reconstructed source record itself is not
modified.

Then `renderSourceRecord` selects `displayCharacterSafely` as the output callback
and enters `printExpandedSourceLineWithRoutine`.

## One source scanner serves many destinations

`printExpandedSourceLineWithRoutine` patches this call:

```asm
varcExpandedSourceCharacterRendererCall:
    call displayCharacterSafely
```

A caller can replace the target with another routine. The scanner itself then:

- skips `$01` field markers;
- stops at zero;
- tracks whether it is inside double quotes;
- applies the configured source-case conversion only outside quotes;
- sends each resulting character to the selected callback.

In pseudocode:

```text
for each byte in lineBuffer:
    if byte == $01:
        continue
    if byte == $00:
        stop

    if byte == '"':
        toggle quotedState

    if outside quotes and case conversion enabled:
        transform letter

    outputCallback(byte)
```

This is a miniature stream processor. Expansion establishes meaning; the
scanner applies output policy.

## Case conversion must not alter string data

PROMETHEUS can display source in a chosen letter case. It must not change:

```asm
        DEFM "Hello"
```

to a different string merely because the source display is configured for
uppercase or lowercase.

The scanner therefore toggles a quote-state bit whenever it sees `"`. Letters
inside quoted text bypass case conversion.

The case option changes presentation, not source meaning.

This distinction is especially important because expanded lines are reused by
PRINT, FIND and other tools. A display preference must not become a data
corruption mechanism.

## The output callback is more powerful than it first appears

By replacing one `CALL` operand, PROMETHEUS can reuse the same line scan for
several purposes.

Conceptually:

```text
expand record once
scan reconstructed text once

callback = screen character renderer
    → display source

callback = printer character routine
    → print source

callback = comparison routine
    → search source text

callback = replacement builder
    → construct transformed line
```

The callback sees a normalized sequence in which private field markers are gone
and source-case policy has already been applied where appropriate.

This is one of the program's most elegant uses of self-modifying code. The
patched call is not an uncontrolled trick; it is a tiny configurable interface.

## Following `LOOP DJNZ LOOP` back outward

Let us reverse the record built in Chapter 13.

Conceptually it contains:

```text
opcode $10
information: label present + relative-expression class
line-label ordinal 37
operand-expression ordinal 37
terminal marker $C4
```

### 1. Clear line buffer

Thirty-two zero bytes provide a clean destination.

### 2. Expand label

Information bit 3 is set. Ordinal 37 resolves through the symbol table to
`LOOP`. The result is padded to nine characters:

```text
LOOP
```

### 3. Decode instruction metadata

Opcode `$10` and its prefix family locate the `DJNZ` instruction record. The
decoder returns:

```text
mnemonic index: DJNZ
first operand: relative expression
second operand: none
```

### 4. Append field marker and mnemonic

The mnemonic table supplies `djnz`, padded to five characters.

The neutral buffer now resembles:

```text
LOOP     $01djnz $01
```

where `$01` represents an invisible field marker.

### 5. Expand operand

The relative-expression descriptor requires no parentheses. The tagged ordinal
37 is resolved again to `LOOP` and copied.

### 6. Apply output policy

The display scanner skips markers and, according to installation configuration,
may convert source letters to uppercase.

The user sees:

```asm
LOOP     DJNZ LOOP
```

The spelling has been recreated from identity and tables. It was not retained
as one original text string.

## Opening the reconstructed line for editing

The same expansion path is used when EDIT brings the active source record into
the bottom edit row.

The `$01` markers are useful here. They provide natural field positions and one
of them can serve as the movable cursor marker understood by `updateInputBuffer`.

Thus the record-to-text path does not merely print a line. It constructs the
next editable representation.

The round trip is:

```text
persistent semantic record
    → neutral editable line
    → user changes characters
    → parser builds a new semantic record
```

The screen is only a view between those two structured states.

## What information is deliberately not reproduced exactly?

PROMETHEUS preserves the program's source meaning, but it does not promise to
remember every cosmetic choice from the submitted line.

It reconstructs:

- fixed label and mnemonic field widths;
- normalized mnemonic/operand spellings;
- configured source letter case;
- standard punctuation implied by operand descriptors.

It may not preserve:

- arbitrary extra spaces;
- original uppercase/lowercase outside quotes;
- a redundant unary plus discarded by expression encoding;
- lowercase hexadecimal digits that were canonicalized;
- hand-chosen alignment beyond the editor's fields.

This is not accidental loss. The compressed source format stores a canonical
form suitable for a small integrated assembler.

## Detecting a damaged source record

Several checks protect expansion:

- opcode/prefix metadata must decode to a table record;
- symbol ordinals must resolve through the current table structure;
- fixed words must fit their output field;
- expression scanning must encounter valid structural boundaries;
- output must remain within the small line buffer.

PROMETHEUS cannot provide modern memory protection, but it repeatedly checks the
invariants of its compact data languages.

A `Source` error means that the internal representation no longer agrees with
those invariants, not merely that the user typed a bad line. Entry-time syntax
errors should have been rejected before a record was stored.

## Back to the whole machine

The expander demonstrates why PROMETHEUS's compressed source is useful rather
than merely small.

The record stores enough semantic information to serve two opposite consumers:

```text
assembler:
    wants opcode family, operand class and encoded expressions

editor:
    wants label, mnemonic and readable operand text
```

The instruction and symbol tables bridge the two views.

The same source line can therefore travel repeatedly through this cycle:

```text
record
  → screen text
  → edited text
  → new record
  → assembly passes
  → machine code
```

No stage needs the original raw keystroke sequence.

## What has changed in memory?

During neutral expansion:

- `lineBuffer` is cleared and filled with reconstructed text;
- `$01` markers identify field boundaries;
- `IX` advances through variable record material;
- symbol-table memory is read but not changed;
- `varcIndexRegisterVariantOffset` records IX/IY text selection during decode.

During contextual rendering:

- `lineBufferMarkerPosition` may receive `$03` for block selection;
- `varcExpandedSourceCharacterRendererCall` receives the selected callback;
- quote state is held temporarily in `C`;
- screen, printer or another destination receives characters;
- persistent compressed source remains unchanged.

If damaged metadata is detected:

- `varcLastStatusBarMessage` is set to the source-error message;
- the editor later displays the diagnostic.

## Important ideas for later chapters

- expansion combines source, instruction, mnemonic, operand and symbol tables;
- comments use a literal fast path;
- labels are resolved from ordinals and padded to nine columns;
- opcode plus prefix family recovers mnemonic and operand descriptors;
- IX/IY metadata is normalized for lookup and restored for text;
- `$01` markers divide reconstructed fields but are not displayed;
- fixed operands come from packed string tables;
- expression templates generate parentheses, index-register names and some
  punctuation;
- symbol ordinals expand to current symbol spellings;
- `$1F` separates two encoded expression operands;
- selected-block marking belongs to the view, not to the record;
- one patched output callback lets screen, printer, search and replacement share
  the same scanner;
- case conversion is suppressed inside quoted text;
- the result is canonical source, not an exact replay of original spacing and
  letter case.

## Source anchors explained

- `expandSourceRecordToLineBuffer`
- `expandSourceRecordToHL`
- `.expandCommentRecordLoop`
- `.expandStructuredSourceRecord`
- `resolveRecordLabelAfterHeader`
- `resolveSymbolReferenceToName`
- `decodeInstructionTableRecord`
- `varcIndexRegisterVariantOffset`
- `.appendExpandedMnemonic`
- `mnemonicsReferences`
- `operandsReferences`
- `getStringFromTableDE`
- `printFromDEtoHLpaddedLeft`
- `fillHLWithBSpaces`
- `expandOperandByDescriptor`
- `.expandExpressionOperand`
- `.expandEncodedExpressionLoop`
- `.expandEncodedSymbolReference`
- `.finishExpressionOperand`
- `copyResolvedSymbolNameToLine`
- `renderSourceRecord`
- `testSourceRecordOutsideSelectedBlock` at display level
- `lineBuffer`
- `lineBufferMarkerPosition`
- `printExpandedSourceLineWithRoutine`
- `varcExpandedSourceCharacterRendererCall`
- `configurationPatchTarget02SourceCaseTransform`
- `displayCharacterSafely` at source-output level
