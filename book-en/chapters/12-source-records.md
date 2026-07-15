# Chapter 12: Source Lines Are Not Stored as Text

The editable line is pleasant for a human. It is not economical for a 48K computer.

If PROMETHEUS stored every source line exactly as displayed, it would repeatedly keep information that the program already knows:

- the spelling of common mnemonics;
- the spelling of register operands;
- spaces used only for alignment;
- symbol names repeated in many expressions;
- enough information to rediscover an instruction-table entry during every assembly.

PROMETHEUS therefore stores source in a compact record language of its own.

A source record is not machine code, although its first byte is often a real Z80 opcode. It is not tokenized text in the BASIC sense, although names and instructions are represented compactly. It is a prepared description of one source line, designed so that the editor can reconstruct readable text and the assembler can process the line quickly.

This chapter describes that persistent format. Chapters 13 and 14 will show how text is encoded into it and expanded back out.

## Why compress source at all?

PROMETHEUS must keep several large things in memory simultaneously:

```text
resident program
compressed source
symbol table
assembled output
Spectrum display
stacks and work buffers
```

Source can easily become the largest user-controlled structure. Saving a few bytes on every line therefore matters more than saving a few bytes in an occasional routine.

Consider this ordinary line:

```asm
LOOP     DJNZ LOOP
```

A simple text representation might store twenty visible characters plus a terminator. PROMETHEUS already knows that:

- `DJNZ` is one of its supported mnemonics;
- the corresponding instruction has a relative expression operand;
- `LOOP` can be represented by a symbol ordinal;
- field spacing can be reconstructed;
- the final machine opcode is known from the instruction table.

The persistent record keeps those facts, not the full appearance of the line.

## Every record begins with two bytes

There is **no leading length byte** in persistent source memory.

This is important because a temporary workspace byte named `encodedRecordStorageLength` exists immediately before a newly built record. That byte tells the insertion routine how many bytes to copy. It is not copied into source memory.

Persistent storage begins at `encodedRecordHeader` and always has this fixed header:

```text
offset +0    opcode or pseudo-opcode
offset +1    information byte
```

Everything after those two bytes is optional variable material.

The record is therefore more like a tiny instruction descriptor than a conventional text line.

## Byte zero is often a real opcode

For an ordinary machine instruction, byte zero is the Z80 opcode byte selected from the instruction table.

For example, a `RET` line can be represented by its opcode plus an information byte saying that there is no expression payload.

This does not mean the source record can simply be executed. Prefixes, operands, expressions and labels still require interpretation. But storing the opcode early has a major advantage:

> The expensive work of recognizing the mnemonic and operand form has already been done while the line was entered.

During assembly, PROMETHEUS can begin from a prepared instruction identity instead of parsing the original words again.

## Pseudo-opcodes represent lines that are not Z80 instructions

Some source lines do not correspond to executable machine instructions. PROMETHEUS reserves opcode values `$00` through `$09` for them:

| Value | Source form |
|---:|---|
| `$00` | empty line |
| `$01` | comment |
| `$02` | `ENT` |
| `$03` | `EQU` |
| `$04` | `ORG` |
| `$05` | `PUT` |
| `$06` | `DEFB` |
| `$07` | `DEFM` |
| `$08` | `DEFS` |
| `$09` | `DEFW` |

These values are not used alone. The information byte marks the record as a pseudo-instruction by using a prefix combination that cannot describe a real Z80 instruction in this table.

PROMETHEUS thus gives editor-only and assembler-control lines the same two-byte beginning as machine instructions. Traversal and dispatch can treat all source lines as members of one record family.

## The information byte answers several questions

Byte one is divided into fields:

```text
bit 7       CB family
bit 6       ED family
bit 5       DD family
bit 4       FD family
bit 3       source line defines a label
bits 2–0    operand or storage class
```

The upper four bits identify the instruction prefix family.

For a real Z80 instruction, only meaningful combinations are produced. For pseudo-instructions, the otherwise impossible simultaneous DD and FD indication acts as an internal category marker.

Bit 3 says whether the source line has a label. If it is set, a two-byte symbol ordinal follows the header.

The low three bits describe how the operand is stored or emitted:

| Class | Meaning |
|---:|---|
| `0` | no expression payload |
| `1` | one-byte value |
| `2` | two-byte value |
| `3` | signed relative byte |
| `4` | indexed displacement `(IX/IY+d)` |
| `5` | indexed displacement plus another byte `(IX/IY+d),n` |
| `6` | `RST` operand folded into the opcode |
| `7` | pseudo-instruction or other non-machine form |

The information byte therefore carries several layers of knowledge compactly:

```text
which instruction family?
does this line define a label?
what kind of variable data follows?
```

## The smallest record is only two bytes

A record with:

- no source-line label;
- operand/storage class zero;

needs nothing after the header.

It is exactly two bytes long.

The initial empty source line is:

```text
$00,$30
```

Read it field by field:

```text
$00    empty-line pseudo-opcode
$30    DD and FD pseudo marker, no label, class zero
```

No terminal marker follows because the record length is already known from the information byte.

Other simple forms such as an unlabeled no-operand instruction can also use the fixed two-byte shape.

This is a large saving because empty lines and simple instructions are common.

## Variable records add a compact payload

A record becomes variable when it needs material after the header. That material may include:

- a source-line label ordinal;
- expression characters;
- symbol references inside expressions;
- comment text;
- definition data;
- separators for multiple expressions.

A variable record ends with a special marker, described shortly.

The broad shape is:

```text
+0    opcode or pseudo-opcode
+1    information byte
+2    optional label ordinal high/tag byte
+3    optional label ordinal low byte
...   expression, comment or definition payload
last  terminal/back-link marker
```

Not every variable record uses every field. The information byte and pseudo-opcode tell the consumer how to interpret the payload.

## Labels are ordinals, not pointers

Suppose the line begins with label `LOOP`.

PROMETHEUS does not store:

- the characters `L`,`O`,`O`,`P` in every record that mentions it;
- an absolute pointer into the movable symbol table.

It stores a one-based symbol ordinal.

Conceptually:

```text
LOOP is symbol number 37
record stores 37
```

A later routine resolves ordinal 37 through the symbol table and obtains the current address of the name and value entry.

The source and symbol-table regions can move when records are inserted or deleted. An absolute pointer would become invalid. An ordinal remains meaningful as long as the symbol vector order is maintained.

This is one reason PROMETHEUS can move the complete source/symbol region without rewriting every stored name reference as a memory address.

## Symbol references announce themselves with bit 7

A symbol ordinal occupies two bytes.

Its first byte is the high ordinal byte with bit 7 set. The second byte is the low ordinal byte:

```text
first byte   $80 | ordinalHigh
second byte  ordinalLow
```

This tagging creates three useful byte ranges inside a variable payload:

```text
$00–$7F    literal text or expression byte
$80–$BF    first byte of a two-byte symbol reference
$C0–$FF    terminal/back-link marker
```

The ranges do not overlap.

A scanner can examine one byte and decide:

```text
below $80       copy or interpret as literal
$80 through $BF read this and the next byte as one symbol ordinal
$C0 or above    end of this variable record
```

No escape character or separate item count is required.

## Why only `$80` through `$BF` for symbol leads?

Bit 7 is set to mark a symbol reference, but bits 7 and 6 together must not both be set. Values `$C0` through `$FF` are reserved for record terminators.

This leaves six useful bits in the high ordinal byte and eight bits in the low byte: enough for a 14-bit ordinal space.

PROMETHEUS is far more likely to run out of Spectrum memory than to need sixteen thousand distinct symbols, so this compact range is generous for the machine.

## Literal expression characters remain readable bytes

An expression such as:

```asm
2*LABEL+#23
```

is not reduced to a modern abstract syntax tree. Operators and number characters can remain ordinary bytes. Only symbol names are replaced by ordinals.

Conceptually the payload becomes:

```text
'2','*',symbolReference(LABEL),'+','#','2','3'
```

If `LABEL` has ordinal `$0123`, the bytes might look schematically like:

```text
$32,$2A,$81,$23,$2B,$23,$32,$33
```

where `$81,$23` is the tagged ordinal.

The exact ordinal depends on the current symbol table. The important point is the mixture:

```text
literal syntax remains literal
names become compact references
```

This keeps expression reconstruction possible while avoiding repeated symbol spellings.

## A marker records the variable length backward

A variable record ends with:

```text
$C0 + payloadLength
```

Here `payloadLength` is the number of bytes after the two-byte header and before the marker.

For a payload of eight bytes, the marker is:

```text
$C8
```

The low six bits carry the length. The high two bits place the byte in the reserved terminal range.

The complete size of a variable record is:

```text
2-byte header + payloadLength + 1-byte marker
```

The marker does two jobs:

1. forward scanners know where the variable material ends;
2. reverse navigation can recover the start of the preceding record.

That second job is the clever one.

## Why the length is stored at the end

If every record began with a length byte, moving forward would be easy. Moving backward would still require an index or a scan from the beginning.

PROMETHEUS places the variable length at the end of the record. When `HL` points to the current record, the byte immediately before it belongs to the previous record.

That byte tells us which of two cases applies:

```text
byte before current < $C0
    previous record was fixed two-byte form

byte before current ≥ $C0
    previous record was variable
    low six bits give its payload length
```

Thus the record format contains its own backward link without storing an address.

It is a **relative structural link**, not a pointer.

## Walking backward in constant time

`getPreviousSourceRecord` is short because the format was designed for it:

```asm
getPreviousSourceRecord:
    dec hl
    ld a,(hl)
    cp 0c0h
    jr c,.previousRecordIsFixedLength
    and 03fh
    ld e,a
    ld d,000h
    sbc hl,de
    dec hl
.previousRecordIsFixedLength:
    dec hl
    ret
```

Let us read both paths.

### Previous record was fixed

`HL` begins at the current record.

```text
dec HL        points to second byte of previous fixed record
value < $C0   fixed case
dec HL        points to first byte of previous record
```

### Previous record was variable

After the first decrement, `HL` points to the marker.

```text
length = marker & $3F
HL -= length      move backward over payload
HL--              move backward over information byte
HL--              move backward over opcode byte
```

The result is the previous record's start address.

No source-line number and no table of record addresses is needed.

## Walking forward uses the information byte

`getNextSourceRecord` begins by reading the two-byte header.

It first skips an optional line-label ordinal when bit 3 is set.

Then it tests for the fixed form:

```asm
.testFixedLengthRecord:
    and 007h
    ret z
```

If there is no label and the class is zero, `HL` already points immediately after the two-byte record.

Otherwise it scans the variable payload.

The scanner must avoid mistaking the second byte of a symbol ordinal for a marker. It therefore treats `$80` through `$BF` as a two-byte unit:

```asm
.scanVariableLengthRecord:
    ld a,(hl)
    inc hl
    cp 0c0h
    ret nc
    cp 080h
    jr c,.scanVariableLengthRecord
    inc hl
    jr .scanVariableLengthRecord
```

In pseudocode:

```text
while true:
    byte = *HL++

    if byte >= $C0:
        return HL

    if byte >= $80:
        HL++        skip low byte of symbol ordinal
```

The marker itself has already been passed when the routine returns, so `HL` points at the next record.

## Forward and backward travel are not mirror images

Backward travel is constant-time for every record because the final marker stores payload length.

Forward travel is constant-time for fixed records but scans the payload of variable records.

That asymmetry is sensible.

Variable records are short because the editor line is short. A forward scan of perhaps a few dozen bytes is cheap. Adding a leading length field to make forward movement constant-time would cost one byte on every record and complicate the compact header design.

PROMETHEUS spends bytes only where they buy an important capability: backward movement without a line index.

## Comments have their own simple record form

A comment begins with semicolon and bypasses the label/mnemonic/operand parser.

Its header is:

```text
$01,$37
```

Read as:

```text
$01    comment pseudo-opcode
$37    DD+FD pseudo marker, no label, class 7
```

The payload contains the comment text, including the leading semicolon, followed by the `$C0+n` marker.

For example, the comment:

```asm
;wait for key
```

is conceptually:

```text
$01,$37,
';','w','a','i','t',' ','f','o','r',' ','k','e','y',
terminalMarker
```

Comments are not lower-cased, tokenized as mnemonics, or searched in the instruction table. Their text is retained because there is no shorter semantic representation that would preserve arbitrary prose.

This is an important compression principle:

> Compress structure when the program understands the structure; keep literal data when it does not.

## Label-only lines still become variable

A line may define a label without containing an instruction.

The opcode can remain the empty-line pseudo-opcode, but information bit 3 is set and the two-byte label ordinal follows.

Because variable bytes now exist, the record also needs a terminal marker.

Conceptually:

```text
$00, infoWithLabelBit,
labelOrdinalHighTagged, labelOrdinalLow,
$C2
```

The marker's low six bits say that the payload contains two bytes.

This illustrates why “empty line” and “two-byte record” are not identical ideas. An unlabeled empty line is fixed. A visually label-only line uses the empty pseudo-opcode but carries variable label information.

## Real instructions may also be fixed or variable

An unlabeled `RET` needs no expression payload:

```text
opcode RET, information class 0
```

It can be a two-byte fixed record.

An unlabeled `JP ADDRESS` needs an expression payload. Its class indicates a two-byte value, and the encoded expression follows, ending with a marker.

A labeled `RET` needs no operand expression but still carries a label ordinal, so it becomes variable.

Thus record size is determined by stored information, not merely by whether the instruction appears simple to a human.

## Prefix bits save repeated decoding work

The information byte's upper bits record whether the instruction belongs to a CB, ED, DD or FD family.

This matters because a Z80 instruction is not identified by one opcode byte alone. The same following byte can mean different things after different prefixes.

Rather than storing the original mnemonic text and reclassifying it later, the record stores the chosen family directly.

For IX and IY forms, the instruction table can share much of its classification. A separate bit selects DD or FD when the source record is built.

The compact record therefore sits halfway between source text and final bytes:

```text
more semantic than machine code
more prepared than text
```

## Operand classes explain how assembly should use the expression

The low three bits are not merely a byte count.

For example, class 3 says that an expression is a signed relative branch target. During assembly, PROMETHEUS must calculate:

```text
displacement = target - addressAfterInstruction
```

and check that the result fits in a signed byte.

Class 2 says that the expression becomes a two-byte value.

Class 4 says that the expression is an IX/IY displacement and belongs inside an indexed addressing form.

The source record thus preserves the *role* of the expression, not just its characters.

That makes the assembly pass smaller and faster.

## Definition records keep lists and strings

`DEFB`, `DEFS` and `DEFW` can contain comma-separated expressions. Their payload keeps encoded expression material and comma separators.

`DEFM` preserves quoted character bytes because the characters themselves are the data to be emitted.

These records use the same outer framing:

```text
pseudo-opcode
information byte
optional label ordinal
encoded definition material
terminal marker
```

The meaning of the variable stream depends on the pseudo-opcode. The record language is compact but not completely uniform; specialized consumers know how to interpret each family.

That is reasonable. A single universal expression tree would require more code and more bytes than the simple source forms need.

## Field spacing is not stored as record metadata

The editor displays source in fixed fields:

```text
label       9 columns
mnemonic    5 columns
operand     remaining columns
```

Those field widths are not stored in every record.

When PROMETHEUS expands a record, it resolves the optional label ordinal to a name, reconstructs the mnemonic from the instruction table, and pads the fields in `lineBuffer`.

The visible spaces are presentation.

This separation is worth emphasizing:

```text
source record stores meaning
lineBuffer stores one formatted view
```

A selected-block marker is also not stored in the record. It is added to the expanded line according to two external boundary pointers.

## The initial source is twenty tiny records

At the end of the resident payload, `sourceBufferStart` contains twenty copies of:

```text
$00,$30
```

These are real empty source records, not zero-filled unused memory.

Why twenty?

The editor wants valid records above and below the active access line from its first display. The initial layout provides:

- thirteen records before the active line;
- the active line itself;
- six records after it.

That exactly fills the twenty-line source window described in Chapter 9.

The labels `sourceBufferPreviousLine` and `sourceBufferAccessLine` identify useful positions inside this initial chain.

As the user inserts source, the region grows upward and the symbol table moves with it. The empty tail records also provide editor padding around the current text.

## Source end is structural, not a text sentinel byte

The compressed source region ends where the symbol table begins. `varcSymbolTablePt` therefore acts as the source-end boundary.

Navigation routines compare candidate record addresses with the dynamic combined-region pointers. They do not search for a special “end of file” character embedded in source text.

This is important because zero is a perfectly valid byte inside headers and literal expression material. The record structure and moving region pointers define the source, not C-style string rules.

## The record language protects itself from ambiguity

The byte ranges were chosen so each scanner can make local decisions:

```text
header tells whether optional label exists
class zero tells whether an unlabeled record is fixed
symbol lead byte tells scanner to skip one more byte
terminal range tells scanner where variable record ends
terminal low bits tell reverse scanner how far back to go
```

There is no need to parse the expression grammar merely to find the next line.

This is a hallmark of a good compact format: navigation can happen without understanding every semantic detail.

## A schematic record for the running example

Take:

```asm
LOOP     DJNZ LOOP
```

The exact bytes depend on the symbol ordinal assigned to `LOOP` and on the instruction-table encoding. Its conceptual record is:

```text
+0  DJNZ opcode
+1  information:
        no prefix family
        label-present bit set
        relative-expression class
+2  tagged high byte of line-label ordinal LOOP
+3  low byte of line-label ordinal LOOP
+4  tagged high byte of operand-symbol ordinal LOOP
+5  low byte of operand-symbol ordinal LOOP
+6  $C4 terminal marker for four payload bytes
```

The same symbol appears twice for two different reasons:

- first as the name being defined by this line;
- second as the branch target expression.

Both uses share the same ordinal representation.

The record does **not** store:

- letters `D`,`J`,`N`,`Z`;
- nine-column label padding;
- a space before the operand;
- letters `L`,`O`,`O`,`P` twice.

When displayed, all of those human-facing details are reconstructed.

## A schematic fixed instruction

For:

```asm
        RET
```

there is no label and no expression payload.

The conceptual record is simply:

```text
RET opcode, class-zero information byte
```

Two bytes describe the complete source line.

This shows why the format can save substantial memory in instruction-heavy source.

## A schematic comment

For:

```asm
;main loop
```

PROMETHEUS cannot replace the prose by an opcode or symbol ordinal. It stores:

```text
comment pseudo-opcode
pseudo/class information byte
literal characters ";main loop"
terminal/back-link marker
```

Comments remain comparatively expensive. That is the price of preserving arbitrary human explanation.

## What corruption would look like

Because record bytes form a compact language, damage can have consequences beyond one visible character.

A changed information byte might:

- falsely claim a label ordinal exists;
- select the wrong prefix family;
- change the operand class;
- make a fixed record look variable.

A changed terminal marker might make reverse navigation jump to the wrong address.

A damaged symbol lead byte could cause the forward scanner to skip the wrong following byte.

PROMETHEUS includes source-error paths when opcode and information data cannot be reconciled with its instruction table. But compactness means there is less redundant information with which to recover from arbitrary memory corruption.

That trade-off is common in small-machine software: memory efficiency wins over elaborate fault tolerance.

## Why this format suits both editor and assembler

The editor needs to:

- move forward and backward between lines;
- reconstruct readable source;
- insert and delete variable records;
- find symbol references;
- mark selected lines without changing them.

The assembler needs to:

- know the instruction family and operand role;
- resolve expressions and symbols;
- count output bytes in pass one;
- emit final bytes in pass two.

The source record provides enough prepared structure for both.

It is not optimized for one single operation. It is a compact common language joining the editor, symbol table and assembler.

## A complete navigation example

Imagine three records in sequence:

```text
A: fixed two-byte RET record
B: variable JP LABEL record with payload length 5
C: fixed two-byte empty record
```

The memory shapes are:

```text
A: [header0][header1]
B: [header0][header1][five payload bytes][$C5]
C: [header0][header1]
```

To move from A to B:

```text
read A information byte
class zero and no label → return after two bytes
```

To move from B to C:

```text
read B information byte
variable form → scan payload
symbol lead bytes skip ordinal lows
encounter $C5 → return after marker
```

To move from C back to B:

```text
inspect byte before C → $C5
payload length = 5
subtract payload, marker and header
arrive at B
```

To move from B back to A:

```text
inspect byte before B → A's information byte, below $C0
subtract two
arrive at A
```

The records require no external line index.

## Back to the whole machine

We can now refine the editor cycle from Chapter 9:

```text
compressed record
    contains prepared instruction identity and compact references

expand
    resolves names and reconstructs display fields

editable line
    contains characters, tokens, cursor marker and terminator

submit
    recognizes syntax and chooses instruction-table entry

compress
    writes header, ordinals, expression bytes and marker

insert
    moves the source/symbol region and repairs pointers
```

The source record is the stable middle of this cycle. The screen and edit buffer are temporary views. The assembler output is a later product. The record is what PROMETHEUS keeps as the user's program.

## What has changed in memory?

Merely navigating records changes no source bytes. `HL` is calculated from headers and terminal markers.

When a new fixed record is inserted:

- two persistent bytes are added;
- following source and symbol memory moves upward;
- dynamic pointers are adjusted.

When a variable record is inserted:

- its two-byte header, payload and terminal marker are added;
- the marker records the payload length for future reverse travel.

When a symbol name is used:

- the source record receives an ordinal, not a pointer or full spelling;
- the symbol table separately owns the name and value.

When a line is selected:

- the record remains unchanged;
- the marker is added only to the temporary expanded display line.

## Important ideas for later chapters

- `encodedRecordStorageLength` is a temporary copy count, not part of persistent source;
- every persistent record begins with opcode/pseudo-opcode and information byte;
- unlabeled class-zero records are fixed at two bytes;
- variable records end with `$C0+payloadLength`;
- the final marker makes backward navigation constant-time;
- symbol names are replaced by tagged two-byte ordinals;
- payload byte ranges distinguish literals, symbol leads and terminal markers;
- field spacing and block-selection markers belong to expanded views, not records;
- pseudo-instructions share the record framework with real Z80 instructions;
- the format stores enough semantic preparation to serve both editor and assembler.

## Source anchors explained

- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `encodedRecordPayload`
- `encodedRecordPayloadAfterLabel`
- `encodedRecordPayloadWorkspace`
- `sourceBufferStart`
- `sourceBufferPreviousLine`
- `sourceBufferAccessLine`
- `getPreviousSourceRecord`
- `getNextSourceRecord`
- `getRecordBeforeActiveLine`
- `getRecordAfterActiveLine`
- `varcSymbolTablePt` at source-boundary level
- `varcSelectedBlockStart` and `varcSelectedBlockEnd` as external view state
- `renderSourceRecord` at record/view boundary
- `expandSourceRecordToLineBuffer` at interface level
