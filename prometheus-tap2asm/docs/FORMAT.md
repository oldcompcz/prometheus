# Native PROMETHEUS source formats

## Combined TAP save

The TAP path expects a standard Spectrum header block (`flag = 0x00`, 17 header bytes) immediately followed by a standard data block (`flag = 0xFF`). Both XOR checksums are validated in strict mode.

A native source save uses header type `3` (`CODE`). Header bytes are interpreted as:

```text
+0       type = 3
+1..10   ten-byte space-padded filename
+11..12  complete data length, little-endian
+13..14  ordinary CODE parameter 1
+15..16  compressed source length, little-endian
```

The data payload is:

```text
[source bytes][two bridge bytes][symbol table]
```

## Separate TR-DOS save

For BetaDisk/TR-DOS adaptations with two files, the ordinary layout is:

```text
source TR-DOS file: compressed source bytes
symbol TR-DOS file: complete symbol table
```

The source and symbol structures below are identical to the structures in the combined TAP payload. `--source-offset`, `--source-length`, and `--symbols-offset` can isolate them from private wrappers.

## Source records

Every record starts with:

```text
+0 opcode or pseudo-opcode
+1 prefix, label-present flag, and storage class
```

Information byte:

```text
bit 7  CB family
bit 6  ED family
bit 5  DD / IX family
bit 4  FD / IY family
bit 3  line label ordinal follows
bits 0..2 storage class
```

Storage classes:

```text
0 no expression payload
1 one-byte machine operand, retained as source expression
2 two-byte machine operand, retained as source expression
3 relative machine operand, retained as source expression
4 IX/IY displacement expression
5 IX/IY displacement plus second expression
6 RST expression, also folded into opcode by PROMETHEUS
7 pseudo-operation
```

A class-zero record without a line label is exactly two bytes. Every other record ends with `$C0 + payload_length`, where the low six bits count bytes following the two-byte header and preceding the marker.

Inside a payload:

```text
$00..$7F   literal source byte
$80..$BF   tagged high byte of a two-byte symbol ordinal
$C0..$FF   record terminal marker
$1F        internal separator between two expression payloads
```

The scanner skips the low byte following `$80..$BF`, even when that low byte is itself `$C0..$FF`.

Pseudo-opcodes:

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

## Symbol table

Let `P` be the beginning of the table and `N` the symbol count:

```text
P+0..1        N
P+2..         N little-endian vectors, in ordinal order
then          sorted records: valueLo, valueHi, name...nameLast|$80
```

Ordinals are one-based. Vector bits:

```text
bits 0..13  offset to the symbol name
bit 14      DEFINED state
bit 15      LOCKED state
```

For a vector offset `O`:

```text
nameAnchor  = P + 2 + 2*N + 2
nameAddress = nameAnchor + O
```

The two-byte value is immediately before `nameAddress`. Names are uppercase and high-bit terminated.

## Text-output transformations

The structures above are decoded before any text formatting is applied. Layout,
pseudo-operation mapping, numeric-literal syntax, and comment filtering therefore
do not alter source validation or symbol resolution. See `OUTPUT-FORMATTING.md`
for the complete formatter specification.
