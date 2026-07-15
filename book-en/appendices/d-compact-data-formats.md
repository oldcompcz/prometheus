# Appendix D: Compact Data Formats

PROMETHEUS saves memory by replacing general-purpose structures with small local
languages. A byte may be a character plus an end marker, a count plus a flag, a
delta to a nearby routine, or an instruction descriptor whose fields are only
meaningful to one consumer.

The formats below are reference descriptions. They should be read together with
the code that consumes them. Similar-looking tables do not necessarily use the
same bias, signedness or terminator.

## D.1 General conventions

### D.1.1 Little-endian words

Unless stated otherwise, a 16-bit word is stored:

```text
low byte, high byte
```

### D.1.2 High bit as punctuation

Bit 7 commonly marks the final character of a string or word. The stored byte is
usually recovered with:

```text
character = byte AND $7F
end        = byte has bit 7 set
```

Not every high-bit byte is text. Command tokens, descriptor flags and compressed
source fields also use the upper bits.

### D.1.3 Biased counts

Several tables store:

```text
stored count = visible count + 1
```

The zero/one boundary can then serve as a terminator or simplify a decrementing
loop. Always consult the table's consumer before subtracting one.

### D.1.4 Self-relative offsets

A one-byte vector often stores the distance from the vector byte itself or from
a known table base to its target. This avoids relocation because both source and
target move together.

### D.1.5 Opcode-shaped data

Some tables are written with Z80 mnemonics to emit convenient byte values. The
bytes are data unless a demonstrated control-flow path executes them.

## D.2 High-bit-terminated strings

### Layout

```text
ordinary character bytes
final character with bit 7 set
```

Example for `RUN`:

```asm
    defb "RU",0CEh
```

`$CE & $7F = $4E`, which is `N`.

Equivalent byte view:

```text
$52 $55 $CE
 R   U   N|end
```

### Empty strings

A format may represent an empty or special word with an immediate high-bit byte
or with a separate count. Do not assume every table permits an empty string.

### Consumers

- editor command names;
- mnemonic and operand word dictionaries;
- messages and monitor vocabulary;
- symbol names;
- inline installer text.

### Comparison

A typical comparator masks bit 7 for character comparison while remembering
whether the candidate and table word ended at the same position. A prefix alone
must not match a longer word.

## D.3 Inline strings following `CALL`

### Source form

```asm
    call installerPrintInlineString
    defb "Instalation address",":"+080h
nextInstruction:
```

### Runtime layout

```text
CALL opcode
16-bit target
first inline character
...
last character | $80
next executable opcode
```

### Decoder

```text
returnAddress = POP()
source = returnAddress
repeat:
    b = *source++
    draw(b & $7F)
until b & $80
JUMP source
```

The routine does not return through the original return address because that
address points to data. It jumps to the corrected continuation.

### One-byte prompt variant

Monitor prompts use the same return-address idea but consume exactly one token:

```asm
    call promptForMonitorValue
    defb 0C4h
```

The routine pops the return address, reads the token, increments the pointer and
pushes the corrected continuation.

## D.4 Command tokens

### Range

Editor command tokens occupy `$C1-$DA`, corresponding to A-Z:

```text
$C1 A
$C2 B
...
$DA Z
```

### Dispatch

The dispatcher doubles the token and indexes a word table biased by
`commandHandlerTable-($C1*2)`.

```text
handler = word[commandHandlerTable + 2*(token-$C1)]
JUMP handler
```

### Command map

```text
$C1 A  ASSEMBLY
$C2 B  BASIC
$C3 C  COPY
$C4 D  DELETE
$C5 E  end of source
$C6 F  FIND
$C7 G  GENS
$C8 H  decimal/hex toggle
$C9 I  GENS/import alias
$CA J  GENS/import alias
$CB K  start of source
$CC L  LOAD
$CD M  MONITOR
$CE N  ROM NEW path
$CF O  ROM NEW alias
$D0 P  PRINT
$D1 Q  QUIT
$D2 R  RUN
$D3 S  SAVE
$D4 T  TABLE
$D5 U  U-TOP
$D6 V  VERIFY
$D7 W  INSERT/OVERWRITE toggle
$D8 X  CLEAR
$D9 Y  CLEAR alias
$DA Z  REPLACE
```

The textual command-name vector is separate. It contains historical duplicate
slots and aliases; table identity does not prove that every alias is reachable
through every input route.

### Immediate key actions

Cursor movement, EDIT, block margin changes and some mode toggles are processed
before tokenized command dispatch. They are not command tokens merely because a
letter key is involved.

## D.5 Monitor normalized key codes

`readKeyCode` returns ordinary letters in lowercase. Modifier combinations and
special keys occupy compact codes chosen by the keyboard translator.

The monitor's main binding table stores forty pairs:

```text
handler delta, normalized key code
```

Six additional commands are tested directly before the table.

The key code is not a Spectrum ASCII guarantee. It is the output of
PROMETHEUS's normalization pipeline. Comments beside the table are the safest
human-readable key names.

## D.6 Compressed source records

The central correction established during reconstruction is that a persistent
source record does **not** begin with a general length byte. It has a two-byte
header, variable payload and a terminal/back-link byte whose value supports
reverse traversal.

### D.6.1 Broad layout

```text
+0  opcode or pseudo-opcode / primary record byte
+1  information byte
+2  optional line-label ordinal or variable fields
... compressed operands/expressions/text
last terminal/back-link marker
```

The exact fields depend on the record class.

### D.6.2 Empty record

```text
$00,$30
```

Twenty copies form the initial source image.

### D.6.3 Information byte

Important upper-bit meaning includes:

```text
(info & $30) == $30    pseudo-instruction namespace
otherwise              machine-instruction record
```

Other bits describe presence and shape of label/operand fields. Their meaning is
interpreted together with the primary opcode/descriptor byte.

### D.6.4 Pseudo-opcode namespace

```text
$00 empty line
$01 comment
$02 ENT
$03 EQU
$04 ORG
$05 PUT
$06 DEFB
$07 DEFM
$08 DEFS
$09 DEFW
```

The pseudo-opcode is a source-record code, not a Z80 opcode.

### D.6.5 Machine-instruction records

A machine record stores enough compact metadata to recover:

- the selected instruction-table form;
- prefix/opcode class;
- optional line label;
- operand expressions or fixed operands;
- index displacement and immediate fields when present.

It does not store the original spacing or capitalization. Expansion produces a
canonical source line.

### D.6.6 Terminal/back-link marker

The final byte lets the reverse walker find the preceding record in constant
time. Forward traversal interprets the current record's fields to find its end;
reverse traversal uses the marker immediately before the current record.

This is why record mutation must finalize the tail marker exactly. A damaged
marker can make upward source navigation jump into the middle of another record.

### D.6.7 Line labels as ordinals

Compressed source refers to symbols by one-based ordinal rather than repeating
the symbol text. The symbol vector resolves the ordinal to the current record.
TABLE C may compact symbols and rewrite all affected ordinals in source.

### D.6.8 Expressions

Expressions are stored as a compact sequence of atoms and operators. Atoms can
represent:

- literal numeric values;
- current address `$`;
- symbol ordinal references;
- quoted byte values.

The evaluator is left-to-right rather than a large precedence parser. The
encoded form is interpreted by a dedicated evaluator during assembly and source
expansion.

### D.6.9 Example at conceptual level

Source:

```asm
LOOP:   LD A,COUNT+1
```

Conceptual record:

```text
machine-form descriptor for `LD A,n`
information bits: label present, expression operand present
ordinal(LOOP)
expression atom ordinal(COUNT)
operator +
literal 1
terminal/back-link marker
```

The exact bytes depend on table indexes and symbol ordinals, so the book avoids
inventing a fixed byte sequence for this illustrative line.

## D.7 Temporary editable input line

The input buffer is not a persistent source record.

### Representation

```text
characters and compact tokens
one movable cursor marker `$01`
terminator/high-bit state appropriate to renderer/parser
```

The cursor is in-band: moving the cursor means moving marker `$01` through the
buffer. Rendering records the marker's address in a self-modified operand and
draws a CAPS-state glyph in its place.

### Predecessor guard

`inputBufferGuardByte` lies immediately before the buffer because some readers
pre-increment before fetching. Similar guards exist before other line/operand
buffers.

## D.8 Symbol table

### D.8.1 Top-level layout

```text
word count
word vector[count]
variable-length symbol records sorted by name
```

### D.8.2 Ordinals

Ordinals are one-based:

```text
ordinal 1 -> vector entry 1
ordinal 2 -> vector entry 2
...
```

The count word is not ordinal zero.

### D.8.3 Vector entries

Each word is a compact pointer/offset representation interpreted relative to the
symbol table's moving base. The vector lets source ordinals remain stable while
symbol records are inserted alphabetically.

When the source area moves, `varcSymbolTablePt` moves with it. Internal vector
relationships remain meaningful because the mover and insertion logic repair the
necessary offsets.

### D.8.4 Symbol record

A record contains:

```text
flags
16-bit value
high-bit-terminated name
```

The exact placement of flags/value is consumed by lookup, display and definition
routines. Important semantic flags are:

```text
DEFINED  value is currently valid for assembly
LOCKED   preserve across definition reset / separate compilation
mark bit transiently used by TABLE C
```

### D.8.5 Sorted records versus ordinal vector

Two access orders coexist:

```text
source reference -> ordinal vector -> record
name lookup       -> alphabetically sorted record scan
```

This is the reason symbol insertion updates vector offsets and why deleting a
record is more than closing one byte gap.

## D.9 Text expression syntax and encoded expression format

### D.9.1 Text atoms accepted by monitor/editor evaluator

```text
decimal digits       1234
hexadecimal          #1F or current configured syntax
binary               %1010
quoted byte          "A"-style atom under historical parser rules
current address      $
symbol name          LABEL
```

### D.9.2 Operators

The compact evaluator supports the source's arithmetic/operator set, including:

```text
+  -  *  /  ?
```

Evaluation is deliberately small and largely left-to-right. It is not a modern
expression grammar with a full precedence tree.

### D.9.3 Encoded atoms

Persistent records replace textual symbol names with ordinal tags and encode
literal values in compact forms. The encoded evaluator shares arithmetic
primitives with the text evaluator but reads the record stream instead of the
edit buffer.

### D.9.4 Historical quote asymmetry

The parser has an opaque-copy path entered by an apostrophe-like condition, but
a double quote is the confirmed closing delimiter in the relevant routine. This
oddity is preserved and should not be generalized into a clean modern quoting
rule without tests.

## D.10 Mnemonic dictionaries

PROMETHEUS does not store one conventional array of C strings.

### D.10.1 Length buckets

Mnemonic lookup first selects a bucket based on word length. A compact bucket
entry identifies how many words and where their high-bit-terminated spellings
begin.

This reduces comparisons because `LD` is never compared with `EXX` or `OTDR` if
their lengths differ.

### D.10.2 Word encoding

Within a bucket:

```text
letters, final letter|$80
letters, final letter|$80
...
```

The position of a matched mnemonic becomes part of the instruction-form key.

### D.10.3 Duplicate/alias preservation

Apparently duplicate words or references may occupy distinct slots because slot
number, not just spelling, participates in another table. Do not merge them
without following every consumer.

## D.11 Operand dictionaries

Operand spellings are also high-bit-terminated and grouped into compact tables.
Examples include registers, conditions and parenthesized fixed forms:

```text
a
bc
(hl)
(ix
(iy
```

Some entries are prefixes rather than complete user-visible operands because the
parser handles a following displacement or closing punctuation separately.

The source defines `operandsTable00` through `operandsTable42`. Empty-looking
entries and repeated initial letters are part of the lookup/index scheme.

## D.12 Operation-name vector

`operationLabels` is a self-relative byte vector. Each entry contains:

```text
address(operationLabelX) - address(thisVectorByte)
```

The target is one of the high-bit-terminated command names.

Historical aliases remain separate slots:

- DELETE appears more than once;
- GENS occupies several token slots;
- NEW and CLEAR have duplicate token entries.

The vector is used to recognize textual commands and connect a name to the
alphabetic token namespace.

## D.13 Instruction descriptors

The included `instructionTable.asm` contains 687 fixed-size records. One record
represents one accepted Z80 instruction form, not merely one mnemonic.

### D.13.1 Conceptual fields

A record supplies compact information for several consumers:

```text
mnemonic index
operand-form indexes/classes
prefix/opcode bytes or derivation fields
instruction length
second-pass emission class
disassembly operand handler class
control-flow and timing bits
```

The exact bit allocation is intentionally consumed through masks and helper
tables rather than expanded into a large C-like structure.

### D.13.2 Shared consumers

The same descriptor supports:

- source parser exact-form matching;
- first-pass length accounting;
- second-pass prefix/opcode/operand emission;
- monitor disassembly;
- instruction-length navigation;
- T-state base count;
- control-flow classification support.

This sharing is one of PROMETHEUS's largest memory economies.

### D.13.3 Indexed CB forms

DDCB/FDCB forms require a nontrivial emitted order:

```text
DD/FD, CB, displacement, opcode
```

The compact descriptor and second-pass class cooperate to repair this order even
though ordinary prefix/opcode emission would place bytes differently.

### D.13.4 RST operand folding

The RST class validates a small vector and folds it into opcode bits rather than
emitting a separate operand byte.

### D.13.5 Timing field

Low timing bits give a base T-state count. Execution handlers adjust for taken
branches and repeated block instructions.

## D.14 Disassembly operand-handler vector

`disassemblyOperandHandlerOffsets` stores compact offsets to operand renderers.
The decoder selects a class from the instruction descriptor and dispatches
through the offset.

Handlers cover forms such as:

- no operand bytes;
- immediate byte;
- little-endian word;
- relative target;
- IX/IY displacement;
- displacement plus immediate;
- RST vector;
- fixed register/condition text.

The vector is self-relative and therefore needs no runtime relocation.

## D.15 Front-panel descriptors

There are thirty-four records of seven bytes.

### Layout

```text
+0..+1  bitmap destination or special-area address
+2      heading/name representation
+3      source class and current display format
+4      byte size and supported-format capability mask
+5..+6  source/destination address or accessor data
```

### Byte +2: name

One-letter names can be stored directly with bit 7 set. Longer names refer into
operand/name tables.

### Byte +3: source/format

This byte combines where the displayed value comes from with how it is rendered.
The front-panel editor cycles supported formats by consulting capability data.

### Byte +4: size/capabilities

Low bits describe value width or special-area behavior. Other bits indicate
which numeric, hexadecimal, character or condition formats are permitted.

### Bytes +5/+6

For scalar items these identify the saved value. The register editor reuses the
same address to store a new one-byte or little-endian two-byte value. Special
items interpret the word as an accessor/table pointer.

### Special areas

List, disassembly and flags items use specialized renderers rather than an
ordinary scalar fetch. Their descriptors still fit the same seven-byte outer
shape.

## D.16 Front-panel format-toggle data

The panel editor uses compact capability masks. Some `$FF` bytes are emitted as
`RST $38` mnemonics. They mean “all relevant toggles allowed,” not executable
calls.

A format-toggle table can therefore look like mixed code when viewed without its
consumer.

## D.17 Protection-window tables

### Outer layout

```text
byte biasedCount
repeated visible entries:
    word first
    word last
spare tail words
```

The stored count is one more than the visible number of ranges.

### Range semantics

Endpoints are inclusive. A single-address checker succeeds when:

```text
first <= address <= last
```

A range checker tests overlap between an inclusive operation range and each
protected window.

### Dynamic resident window

The current PROMETHEUS region is synthesized separately using the installed
start and moving `varcCodeEndPt`. It is not simply one immutable user-table row.

### Table families

- READ-protected areas;
- WRITE-protected areas;
- RUN-protected areas;
- DEFB disassembly areas;
- DEFW disassembly areas.

The format is shared, but command paths do not all consult every family.

## D.18 Control-flow descriptor table

The supervised execution engine classifies instructions that cannot simply be
copied into scratch RAM.

A compact row combines masked opcode/prefix recognition with a handler or class
for:

- conditional/unconditional relative jumps;
- absolute CALL and JP;
- RET;
- RST;
- indirect JP through HL/IX/IY;
- RETN/RETI.

The descriptor can include timing adjustments and callback choice. Exact
semantics come from the dispatcher and handler; a matching byte sequence alone
does not fully describe taken/not-taken behavior.

## D.19 Memory-access descriptor tables

READ and WRITE prediction tables use rows of:

```text
opcodeMask
expectedOpcode
accessDescriptor
```

A row matches when:

```text
(decodedOpcode & opcodeMask) == expectedOpcode
and descriptor prefix nibble matches decoded prefix nibble
```

### Descriptor low bits

```text
0  address from BC
1  address from DE
2  address from HL
3  address from IX + signed displacement
4  address from IY + signed displacement
5  address from SP
6  address from SP - 2
7  immediate NN
```

Bit 3 marks a two-byte access. Both bytes are checked independently, including
wrap from `$FFFF` to `$0000`.

Repeated LDIR/LDDR receives a separate full-range calculation rather than being
represented as a single descriptor access.

## D.20 Masked-search patterns

### Workspace

```text
five × (value, mask)
```

### Comparison

```text
matchByte = ((memoryByte XOR value) AND mask) == 0
```

### Exact byte

```text
value = requested low byte
mask  = $FF
```

### Wildcard

```text
value = don't care
mask  = $00
```

A colon response creates the wildcard. The algorithm tests five bytes at every
candidate, permits natural 16-bit wrap while reading, and stops when the
candidate start itself wraps.

## D.21 Direct-CALL address list

The list begins with a biased count:

```text
stored count = visible targets + 1
```

It is followed by eleven words:

```text
up to ten visible CALL/RST targets
one spare tail word used by compact deletion
```

Direct-call mode values are represented by executable opcodes elsewhere:

```text
NOP    NON mode
RET Z  DEF mode
RET    ALL mode
```

The opcode doubles as mode data and a gate when executed.

## D.22 Navigation stack

The monitor address-navigation stack stores:

```text
byte depth
word address[10]
```

Depth is one-based while selecting a newly stored slot. Left/right or up/down
navigation handlers convert the compact depth to a word offset with doubling.
This is not the Z80 machine stack; it is a resident data stack for visited
addresses.

## D.23 Installer setting representation

The temporary installer has no conventional settings structure. Values live in
writable operands/opcodes:

```text
text attribute byte
highlight attribute byte
keyboard echo duration immediate
monitor yes/no byte
case-mode byte and executable case opcode
bold transform opcode
installation-address cursor operand
five ASCII decimal destination digits
```

When ENTER is pressed, selected bytes are copied in a fixed order into the
resident using the generated configuration-patch stream.

## D.24 Configuration-patch stream

### Format

Exactly fourteen signed little-endian words:

```text
delta 0
...
delta 13
```

### Decoder state

```text
patchPointer = resident payload start
settingsSource = installer settings in fixed order
```

### Operation

```text
for each signed delta:
    patchPointer += delta
    *patchPointer = next setting byte
```

### Historical deltas

```text
+10702, -1228, +1102, -6724, +1944, +4888, -6896,
   +14, +4423, +2360, -3864, +1234, -2156, -1955
```

The generator derives them from ordered `@config-patch` labels and rejects
missing, duplicate or out-of-range targets.

### Why signed

Patch destinations are visited in semantic write order rather than ascending
address order. The pointer moves backward as well as forward.

## D.25 Relocation stream

### Purpose

Identify each little-endian word in the copied resident to which the relocation
addend must be added.

### Decoder inputs

```text
HL -> stream
DE = running target address
BC = relocation addend
```

### Records

```text
$00                 end of stream
$01-$C7             short record: distance, implicit count 1
$C8-$FF, count      run record: distance = prefix-$C8, explicit count
```

For each selected word:

```text
DE += distance
word[DE] += BC
```

For a run, the same distance is applied repeatedly for `count` words.

### Example

```text
$CF,$1D
```

means:

```text
distance = $CF-$C8 = 7
count    = $1D = 29
```

Relocate 29 words, each seven bytes after the previous target.

### Limits

A directly encoded individual distance must fit `$01-$C7`. The historical
format cannot represent one isolated larger gap without an extension. The v040
hardening tests reject such a layout rather than silently generating bad data.

### Streams

```text
monitor stream    571 words
assembler stream  722 words
```

The two are separated because assembler-only installation omits the monitor
prefix and uses a different addend.

### Explicit exception

`relocationExceptionMonitorEntryDescriptorWord` changes across probe origins but
is opcode-shaped descriptor data, not a pointer. `@noreloc` excludes exactly
this one word and the generator validates the exception.

## D.26 Relocation discovery format in modern tooling

The historical program contains only the compact stream. The reconstruction
generator discovers targets by assembling at multiple origins and comparing
words:

```text
origin 0
origin $0101
origin $1234
origin $4000
(and additional hardening probes)
```

A word is relocatable when every nonzero-origin value equals:

```text
originZeroValue + probeOrigin  modulo 65536
```

This modern multi-origin evidence is reconstruction metadata, not an original
runtime format. Appendix G keeps that distinction explicit.

## D.27 Tape header format

A standard Spectrum header payload is 17 bytes:

```text
+0       type
+1..+10  filename, space-padded to ten bytes
+11..+12 data length
+13..+14 parameter 1
+15..+16 parameter 2
```

On tape/TAP it is preceded by flag `$00` and followed by XOR checksum.

For a CODE header:

```text
type        3
parameter 1 load address
parameter 2 conventional secondary parameter
```

The canonical PROMETHEUS CODE header contains:

```text
name          "prometheus"
length        18,356
load address  24,000
parameter 2   32,768
```

## D.28 Tape data block format

A standard data block is:

```text
flag `$FF`
payload bytes
XOR checksum
```

Editor SAVE writes a standard CODE header, then a main source segment and a
chained auxiliary segment using ROM marker conventions. The saved logical
representation combines:

- source record range;
- bridge/length state needed by loader;
- symbol-table side data.

VERIFY reuses the exact ranges patched by the preceding SAVE rather than parsing
a new name or range.

## D.29 Monitor Y header buffer

Y deliberately reads 18 bytes:

```text
+0       physical tape flag/leader
+1       header type
+2..+11  filename
+12..+13 data length
+14..+15 parameter 1
+16..+17 parameter 2
```

On a valid header, J may load the immediately following data block using
parameter 1 as destination and header length as size. The code does not require
header type 3.

## D.30 Raw monitor SAVE/LOAD leader form

Monitor S can save either:

- a standard CODE header plus data when the prompt begins with `:filename`;
- a headerless raw block whose user-supplied low byte becomes the leader/flag.

Monitor J accepts a numeric leader/flag. Although a later quick reference
suggests `:filename`, the machine path has no meaningful filename branch for J.

## D.31 TAP container format

A `.tap` file concatenates records:

```text
word bodyLength
byte flag
bodyLength-2 payload bytes
byte checksum
```

The length word itself is not included in the XOR. XOR of flag, payload and
checksum is zero.

The reconstruction's template builder:

1. finds the named PROMETHEUS CODE header/data pair;
2. replaces the binary payload;
3. updates header length;
4. recalculates the affected checksums;
5. preserves unrelated blocks byte-for-byte.

## D.32 Installer logo data

The logo source is linear by character column:

```text
20 columns × 8 row bytes = 160 bytes per band
2 bands = 320 bytes
```

`installerDrawLogoRow` writes eight bytes while incrementing D to step through
Spectrum pixel rows, restores DE, then increments E for the next horizontal
byte.

The logo is split physically because the bootstrap-copied fragment ends before
the remaining 320 bytes consumed at installer entry. HL's progression through
those bytes leads naturally to the resident payload pointer.

## D.33 Fixed work buffers and guard bytes

Important temporary areas include:

```text
inputBufferStart          editable line / monitor prompts / tape header
lineBuffer                neutral 32-column output line
firstOperandBuffer        parser operand workspace
second operand/string workspaces
monitorFindByteMaskPairs  five masked bytes
scratch instruction area  generated one-step program
```

Some readers pre-increment before fetching. The reconstruction names bytes
immediately before buffers as guards:

- `lineBufferReadGuard`;
- `firstOperandBufferReadGuard`;
- `inputBufferGuardByte`.

Their placement is structural even when their exact value is usually ignored.

## D.34 Message indexes

Status/error messages are selected by small numbers:

```text
1  BAD MNEMONIC
2  BAD OPERAND
3  BIG NUMBER
4  SYNTAX HORROR
5  BAD STRING
6  BAD INSTRUCTION
7  MEMORY FULL
8  BAD PUT/ORG
9  UNKNOWN
10 WAIT PLEASE
11 ASSEMBLY COMPLETE
12 START TAPE
13 TAPE ERROR
14 ANY KEY
15 COPYRIGHT
16 SOURCE ERROR
17 FOUND
18 ALREADY DEFINED
19 ENT
```

The indexes are constants into compact text data, not direct screen codes.

## D.35 Compact monitor text tokens

The monitor constructs status and prompt lines from token bytes rather than
storing every complete sentence. For example, `startMonitor` writes four tokens
to form the equivalent of:

```text
UNIVERSUM Control  ON/OFF  Call  NON/DEF/ALL
```

The token expansion table base is itself patched when switching between editor
and monitor vocabularies.

## D.36 Reading compact data safely

For any unfamiliar table:

1. locate every reader and writer;
2. determine whether offsets are signed, unsigned or biased;
3. identify the base used for self-relative values;
4. establish whether endpoints are inclusive or exclusive;
5. check whether count zero is legal or encoded as one;
6. distinguish persistent data from temporary workspace;
7. inspect assembler-only installation adjustments;
8. do not infer execution merely because bytes disassemble cleanly;
9. preserve duplicates until their index role is disproved;
10. regenerate relocation/configuration metadata after any emitted layout change.

PROMETHEUS's formats are small because each has a narrow, disciplined consumer.
They become confusing only when treated as if they were all examples of one
general structure.
