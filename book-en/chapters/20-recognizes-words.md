# Chapter 20: How PROMETHEUS Recognizes Words

A person sees this line immediately:

```asm
LOOP    DJNZ LOOP
```

There is a label named `LOOP`, an instruction named `DJNZ`, and an operand that
refers to the same label.

PROMETHEUS cannot begin with that understanding. It receives characters in the
edit buffer. It must decide which character group is a mnemonic, whether the
spelling is legal, and which compact number should represent it in a source
record.

A large modern assembler might use a hash table full of structures and pointers.
PROMETHEUS uses something much smaller:

1. normalize the word to lower case;
2. measure its length;
3. use the length to select a small candidate bucket;
4. compare against packed high-bit-terminated words;
5. return the word's compact index.

The same mechanism recognizes fixed operands such as `A`, `HL`, `NZ`, `(HL)`
and `AF'`.

This chapter is about that dictionary machinery. It is also about a broader
design lesson: when memory is scarce, recognizing a word can be cheaper if the
program first asks a very simple question that eliminates most candidates.

## Recognition begins after field splitting

Chapter 13 showed how `encodeInputLineToSourceRecord` separates a source line
into temporary fields:

```text
parsed label
parsedMnemonicBuffer
varLowercasedOperands
commandArgumentBuffer
```

Letters outside quoted strings are normalized to lower case. The mnemonic
`DJNZ`, `djnz` and a mixed spelling such as `DjNz` therefore all become:

```text
djnz\0
```

The encoder then measures the mnemonic:

```asm
    push hl
    call lengthUpToZero
    ld hl,mnemonicLookupByLengthDescriptors
    call prepareLengthBucketLookup
    pop hl
    call compareWithMnemonics
    jp c,badMnemonicError
```

This short fragment contains the whole recognition strategy.

`lengthUpToZero` returns the length in `B`. The descriptor table converts that
length into:

- a count of candidate words;
- a pointer to the first packed word of that length.

`compareWithMnemonics` tests only those candidates. Carry set means none
matched.

## Why length is such a useful first question

Suppose the complete mnemonic vocabulary contains words such as:

```text
cpi  cpir  djnz  ex  exx  ld  lddr  nop  reti  rlca
```

If the candidate is four characters long, it cannot be `EX`, `LD` or `NOP`.
There is no reason to compare even their first character.

PROMETHEUS divides the mnemonic vocabulary into four useful lengths:

```text
1-character special forms
2-character mnemonics
3-character mnemonics
4-character mnemonics
```

The reconstructed descriptor bytes tell us the bucket sizes:

```text
length 1:  1 candidate
length 2: 12 candidates
length 3: 41 candidates
length 4: 23 candidates
```

Together these describe 77 searchable spellings. Mnemonic index zero is reserved separately for a label-only or no-mnemonic record; the searchable set also includes the pseudo-operation names used by the editor's record language.

A misspelled five-character mnemonic need not search anything. The editor has
already limited the mnemonic field to five characters, but the legal packed
vocabulary is arranged around the actual short Z80 words and source
directives.

This is not as fast as a perfect modern lookup. It is compact, predictable and
good enough for a person entering one line at a time on a Spectrum.

## A descriptor table that looks like machine code

The mnemonic bucket descriptor is written like this:

```asm
mnemonicLookupByLengthDescriptors:
    defw mnemonicsReferences
    defb 0x01
    ld bc,0020ch
    add hl,hl
    ld c,017h
    scf
```

At first sight, this appears to be a short and rather strange Z80 routine.
It is not executed.

After the initial pointer, the following bytes are data pairs:

```text
(candidate count, offset into reference vector)
```

They happen to disassemble as instructions because every byte sequence can be
interpreted as some Z80 instruction. The original program saves source bytes by
letting the assembler emit convenient byte values through instruction syntax.
The reconstruction comments reveal the intended data meaning.

For mnemonics the logical descriptor is:

```text
base pointer = mnemonicsReferences

length 1 → count  1, vector offset  1
length 2 → count 12, vector offset  2
length 3 → count 41, vector offset 14
length 4 → count 23, vector offset 55
```

Operands have their own table:

```asm
operandLookupByLengthDescriptors:
    defw operandsReferences
    defb 0x0c
    add hl,bc
    rrca
    dec d
    ld (bc),a
    inc h
    ld b,026h
```

Its logical content is:

```text
length 1 → count 12, vector offset  9
length 2 → count 15, vector offset 21
length 3 → count  2, vector offset 36
length 4 → count  6, vector offset 38
```

Once the reader recognizes this idiom, the apparent code stops being
mysterious. It is a compact little index.

## Two levels of indirection

The bucket does not point directly into one long spelling table. It first
selects an entry in a **self-relative reference vector**.

The mnemonic vector begins:

```asm
mnemonicsReferences:
    defb 000h
    defb 04dh
mnemonics00:
    defb mnemonicsTable00-mnemonics00
mnemonics01:
    defb mnemonicsTable01-mnemonics01
    ; ...
```

Each ordinary vector byte says:

```text
spellingAddress = addressOfThisVectorByte + signedByteStoredHere
```

The target is one high-bit-terminated spelling in `mnemonicsTable`.

For example, packed words near the beginning are stored as:

```asm
mnemonicsTable00: defb "c",0xF0
mnemonicsTable01: defb "d",0xE9
mnemonicsTable02: defb "e",0xE9
```

The high bit marks the final character. Masking bit 7 reveals spellings such as:

```text
cp
di
ei
```

Later entries include:

```asm
mnemonicsTable53: defb "cal",0xEC
mnemonicsTable56: defb "def",0xE2
mnemonicsTable60: defb "djn",0xFA
mnemonicsTable71: defb "ret",0xE9
```

which decode as:

```text
call
defb
djnz
reti
```

Why use a reference vector instead of placing words directly in bucket order?

Because the same compact index is useful in both directions:

- text entry finds a spelling and returns its numeric mnemonic index;
- source expansion starts with the index and follows the vector to recover the
  spelling.

The dictionary therefore serves encoder and decoder.

## Selecting a length bucket

`prepareLengthBucketLookup` performs the address arithmetic:

```asm
prepareLengthBucketLookup:
    ld a,b
    add a,a
    ld c,a
    xor a
    ld b,a
    push hl
    add hl,bc
    ld b,(hl)
    inc hl
    ld c,(hl)
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,a
    ld l,c
    add hl,de
    ld e,(hl)
    ld d,a
    add hl,de
    ex de,hl
    ret
```

The routine is dense because several small jobs are folded together.

In prose:

```text
input:
    B  = length of candidate word
    HL = address of length-bucket descriptor table

read:
    table base pointer
    candidate count for this length
    reference-vector offset for this length

follow:
    vector entry’s self-relative displacement

output:
    B  = number of packed words to try
    C  = logical index of first candidate
    DE = address of first packed spelling
```

The multiplication by two is simply because each length bucket occupies two
bytes.

Once this routine returns, the general comparator does not need to know whether
it is handling mnemonics or operands. It has a candidate string in `HL`, a
packed spelling in `DE`, a count in `B` and the first logical index in `C`.

## Comparing a normal string with packed words

The comparator is called `compareWithMnemonics`, although it also handles fixed
operands.

Its central loop is:

```asm
.compareLookupWordCharacters:
    ld a,(de)
    and 07fh
    cp (hl)
    jr nz,.skipMismatchedLookupWord
    ld a,(de)
    inc hl
    inc de
    and 080h
    jr z,.compareLookupWordCharacters
```

For each packed character it:

1. clears the high terminator bit;
2. compares the resulting character with the normalized input;
3. advances both pointers after a match;
4. tests the original packed byte's high bit;
5. continues until the terminal character has matched.

A complete match returns the current index in `A`:

```asm
    pop hl
    xor a
    ld a,c
    ret
```

A mismatch cannot simply advance one byte, because packed words have different
lengths. The routine scans `DE` forward until it finds the high-bit-marked final
character, increments the logical index and tries the next candidate:

```asm
.skipMismatchedLookupWord:
    pop hl
.scanToLookupWordTerminatorLoop:
    ld a,(de)
    and 080h
    inc de
    jr z,.scanToLookupWordTerminatorLoop
    inc c
    djnz compareWithMnemonics
    scf
    ret
```

Notice that `HL`, the candidate input pointer, is restored before every retry.
The packed table pointer remains at the next word.

In pseudocode:

```text
for index in candidateRange:
    if input equals packedWordIgnoringFinalHighBit:
        return index
    packedPointer = afterCurrentPackedWord

return NOT_FOUND
```

## Following `DJNZ` through the dictionary

Let us trace the mnemonic from our running example.

The normalized input is:

```text
d j n z 0
```

`lengthUpToZero` returns 4.

The four-character bucket descriptor supplies:

```text
23 candidates
starting mnemonic index 55
```

`prepareLengthBucketLookup` follows the corresponding vector entry to the first
four-character packed spelling.

`compareWithMnemonics` tries the bucket in order. When it reaches:

```asm
mnemonicsTable60: defb "djn",0xFA
```

it compares:

```text
'd' with 'd'
'j' with 'j'
'n' with 'n'
($FA & $7F) = 'z' with 'z'
```

The high bit on `$FA` says the word ends there. The comparator returns the
mnemonic index in `A`, and the encoder stores that index in the source record's
instruction metadata.

If the user typed `DJNX`, all four lengths would still fit, but the final
character would fail. After the 23 candidates were exhausted, carry would be
set and `badMnemonicError` would select the message `Bad mnemonic`.

## Fixed operands use the same recognizer

A short operand is first compared against `operandsReferences` and
`operandsTable`.

The packed vocabulary includes:

- registers such as `A`, `B`, `HL`, `IX` and `IY`;
- register pairs such as `BC`, `DE`, `SP` and `AF`;
- conditions such as `NZ`, `Z`, `NC`, `C`, `PO`, `PE`, `P` and `M`;
- parenthesized fixed forms such as `(BC)`, `(DE)`, `(HL)`, `(IX)`, `(IY)` and
  `(SP)`;
- special spellings such as `AF'`.

The source table looks odd because high-bit termination is again mixed with
short strings:

```asm
operandsTable35: defb "(c",0xA9
operandsTable36: defb "af",0xA7
operandsTable37: defb "(bc",0xA9
operandsTable39: defb "(hl",0xA9
operandsTable40: defb "(ix",0xA9
```

After clearing bit 7, `$A9` is `')'` and `$A7` is an apostrophe. These become:

```text
(c)
af'
(bc)
(hl)
(ix)
```

The returned operand index is not merely a spelling number. It is an **operand
class** used when searching the instruction table.

For example, fixed register `B` and fixed condition `NZ` receive different
class numbers even though both are short words. Those numbers let PROMETHEUS
distinguish:

```asm
LD B,5
JR NZ,LOOP
```

without carrying their text into the instruction search.

## Recognizing a mnemonic is not yet recognizing an instruction

Suppose the mnemonic lookup returns the index for `LD`.

That alone is far from enough. Z80 has many `LD` forms:

```asm
LD B,C
LD B,5
LD BC,1234
LD A,(HL)
LD (32768),HL
LD IX,(TABLE)
```

The parser must combine:

```text
mnemonic index
first operand class
second operand class
```

and find one exact record in `instructionsTable`.

The table contains **687 records**, each exactly five bytes long. It therefore
occupies 3,435 bytes—large by PROMETHEUS standards, but still much smaller than
storing full textual syntax and emission code for every form.

Representative records are documented in the reconstructed table as:

```asm
; ld b,N
    defb 0x06,0x01,0x14,0x55,0x87

; djnz N
    defb 0x10,0x03,0x7d,0x60,0x08

; ld hl,N
    defb 0x21,0x02,0x14,0xc5,0x8a

; ld ix,N
    defb 0x21,0x22,0x14,0xdd,0x8e
```

The five bytes combine several fields:

```text
byte 0  base opcode or pseudo-opcode
byte 1  prefix and instruction-form information
byte 2  packed mnemonic key
byte 3  packed operand-class information
byte 4  remaining operand, size and timing information
```

The exact bit unpacking is shared by the editor, assembler, disassembler and
execution engine. We will revisit it from those different directions.

At source-entry time, the important fact is that PROMETHEUS has transformed
words into numbers before scanning the table.

## Packing the search key

After classifying both operands, the encoder normalizes IX/IY variants and
packs the two operand classes:

```asm
varcSecondOperandClass:
    ld a,000h
    call normalizeIndexOperandClass
    add a,a
    add a,a
    ld e,a
varcFirstOperandClass:
    ld a,000h
    call normalizeIndexOperandClass
    ld d,a
    ld b,003h
.packOperandClassesLoop:
    sla e
    rl d
    djnz .packOperandClassesLoop
```

The result in `D:E` is arranged in the same compact bit positions used by the
five-byte instruction records.

The mnemonic index is also rotated into the comparison form expected by the
table:

```asm
varcMnemonicIndex:
    ld a,000h
    rla
```

At this point the textual source has disappeared from the search problem. The
parser holds a small numeric signature:

```text
(mnemonic key, operand-one class, operand-two class, index-prefix variant)
```

## Searching the 687 instruction forms

The encoder positions `HL` just before `instructionsTable` and gives `CPI` a
bounded byte count:

```asm
    ld hl,instructionsTable-2
    ld bc,INSTRUCTIONS_TABLE_SIZE
```

The scan advances through records, first comparing the packed mnemonic byte,
then the packed operand fields:

```asm
    cpi
    jp po,badInstructionError
    jr nz,.scanInstructionTableOuter
    ; ...
    cp d
    jr nz,.scanInstructionTableRecord
    ; ...
    cp e
    jr nz,.scanInstructionTableRecord
```

A matching mnemonic with nonmatching operands is not a valid instruction. The
scan continues through other forms of the same mnemonic.

This distinction produces two useful error levels:

- `Bad mnemonic`: the word itself is unknown;
- `Bad instruction`: the mnemonic exists, but no legal form matches the
  supplied operands.

For example:

```asm
FLY A,B        ; Bad mnemonic
LD BC,DE       ; LD exists, BC and DE exist, but this form is not a Z80 LD
```

The second line is not rejected by word recognition. It survives until the
combined instruction-form search.

## Why the table is ordered by opcode

At source entry, a simple bounded linear scan is acceptable. But the same table
is also used in reverse when expanding source records and disassembling memory.
There, the program begins with an opcode and prefix family.

The records are ordered principally by opcode. The decoder can therefore use a
stride-halving search rather than starting at record one for every instruction.

This is a good example of one table serving several directions:

```text
text → mnemonic/operand classes → instruction record
instruction record → canonical source text
opcode bytes → instruction record → disassembly text
instruction record → execution/timing metadata
```

A table chosen only for fast source entry might have been organized by
mnemonic. PROMETHEUS accepts a somewhat less direct encoder search because
opcode order benefits the decoder and monitor as well.

## Text exists at the edges, indexes in the middle

We can summarize the recognition pipeline as:

```text
human spelling
    ↓ normalize and measure
packed word dictionary
    ↓
mnemonic/operand indexes
    ↓ pack
five-byte instruction record
    ↓
compressed source metadata
```

On the way back to the screen, the direction reverses:

```text
compressed source metadata
    ↓
five-byte instruction record
    ↓
mnemonic/operand indexes
    ↓ follow self-relative vectors
packed spellings
    ↓ clear final high bit
human-readable source
```

The central representation is numeric. Text is reconstructed only for people.

## In plain pseudocode

Mnemonic lookup:

```text
function lookupMnemonic(text):
    text = lowercase(text)
    length = countCharacters(text)
    bucket = mnemonicBuckets[length]

    for index in bucket.firstIndex .. bucket.lastIndex:
        if text == packedMnemonic[index]:
            return index

    error “Bad mnemonic”
```

Fixed operand lookup:

```text
function lookupFixedOperand(text):
    if length(text) >= 5:
        return NOT_FIXED

    bucket = operandBuckets[length(text)]

    for class in bucket:
        if text == packedOperand[class]:
            return class

    return NOT_FIXED
```

Instruction-form lookup:

```text
function lookupInstruction(mnemonic, operand1, operand2):
    key = pack(mnemonic.index,
               normalizeIXIY(operand1.class),
               normalizeIXIY(operand2.class))

    for record in instructionTable:
        if record.key == key:
            return record with chosen IX/IY prefix

    error “Bad instruction”
```

## What has changed in memory

During recognition of one entered line:

- `parsedMnemonicBuffer` contains normalized mnemonic text;
- operand buffers contain normalized operand spellings;
- `varcMnemonicIndex+1` is patched with the selected mnemonic index;
- `varcFirstOperandClass+1` and `varcSecondOperandClass+1` hold the classified
  operands;
- `varcUseIYPrefix+1` records whether shared IX metadata must become FD/IY;
- the selected instruction record supplies the two persistent source-header
  bytes;
- the original visible spelling is no longer needed except for expression
  material and symbol names.

The packed dictionary tables themselves are read-only.

## Important labels and tables encountered

- `parsedMnemonicBuffer`
- `mnemonicLookupByLengthDescriptors`
- `operandLookupByLengthDescriptors`
- `prepareLengthBucketLookup`
- `compareWithMnemonics`
- `mnemonicsReferences`
- `mnemonicsTable`
- `operandsReferences`
- `operandsTable`
- `varcMnemonicIndex`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `instructionsTable`
- `INSTRUCTIONS_TABLE_SIZE`

## What comes next

Word recognition handles the easy operands: registers, conditions and a few
fixed parenthesized forms.

But many operands are not dictionary words at all:

```asm
5
TABLE+2
(32768)
(IX-4)
"A"
$
```

The next chapter shows how PROMETHEUS separates these structural forms, how it
normalizes IX and IY without doubling the instruction table, and how several
very different-looking source operands become a small set of classes before
the expression evaluator is involved.
