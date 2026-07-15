# Chapter 21: Reading Operands

Mnemonics are short names from a finite vocabulary. Operands are messier.

A Z80 operand may be:

```text
A                  fixed register
NZ                 fixed condition
1234               numeric expression
TABLE+2            symbolic expression
(HL)               fixed indirect register
(32768)            indirect expression
(IX+5)             indexed memory expression
(IY-OFFSET)         indexed symbolic expression
```

The assembler must recognize enough structure to answer two different
questions:

1. Which instruction form could this be?
2. Which part of the text must be kept as an expression for later evaluation?

PROMETHEUS does not fully evaluate an operand while the source line is entered.
That would fail for forward references and would throw away the expression
needed in later assemblies. Instead it gives each operand a compact **class**.

A class describes the grammatical shape:

```text
fixed register or condition
direct expression
parenthesized expression
IX displacement
IY displacement
no operand
```

The expression text is then syntax-checked and compressed into the source
record. Its final value is calculated during assembly.

## First the line is split into at most two operands

The tokenizer reads the first operand up to a comma and the second to the end of
the line:

```asm
    ld de,varLowercasedOperands
    ld c,012h
    call readFirstOperandUntilComma
    jr nz,.parseSecondOperandText
    inc hl
    ld (firstOperandDelimiterByte),a
.parseSecondOperandText:
    ld de,commandArgumentBuffer
    ld c,012h
    call readSecondOperandToEnd
```

The two temporary buffers are:

```text
varLowercasedOperands   first operand
commandArgumentBuffer   second operand
```

Each is zero-terminated and limited to eighteen bytes.

The field reader performs several useful normalizations:

- spaces around fields are skipped by the caller;
- letters outside quotes become lower case;
- quoted characters keep their exact case;
- a comma outside quoted text ends the first operand;
- zero ends the second operand;
- buffer exhaustion is an error rather than silent truncation.

For:

```asm
LD A,(IX+TABLE-1)
```

we can imagine the buffers becoming:

```text
first  = "a\0"
second = "(ix+table-1)\0"
```

Visible alignment spaces and letter case have disappeared. Syntactic
punctuation remains.

## A quick structural sanity check

After splitting, `validateParsedOperandBuffers` performs a compact bound check
on the combined normalized form.

Its implementation counts nonzero bytes across a fixed region containing the
second-operand workspace and its structural terminators. The exact arithmetic
is shaped by how the two temporary buffers sit in memory, but the purpose is
simple:

```text
reject a combined operand representation that is too large
or structurally inconsistent for the record workspace
```

PROMETHEUS repeatedly prefers a firm early error to allowing a long field to
spill into neighboring scratch storage.

## Operand classes are not operand values

It helps to keep three concepts separate.

### Spelling

The actual normalized characters:

```text
(ix+5)
```

### Class

The grammatical category used to find an instruction form:

```text
indexed displacement using IX
```

### Encoded expression

The persistent compact representation of the displacement:

```text
+ 5
```

The class is found now. The expression is stored now. The value is evaluated
later.

For fixed operands such as `B` or `(HL)`, the class alone is enough; there is no
expression payload.

## The classifier begins with length

`classifyOperandText` starts like the word recognizer:

```asm
classifyOperandText:
    push hl
    call lengthUpToZero
    pop hl
    ld a,b
    or a
    ret z
    cp 005h
    jr nc,.classifyNonRegisterOperand
```

An empty string returns class zero: no operand.

Strings shorter than five characters are possible fixed operands, so the
routine tries the packed operand dictionary described in Chapter 20:

```asm
    push hl
    ld hl,operandLookupByLengthDescriptors
    call prepareLengthBucketLookup
    pop hl
    call compareWithMnemonics
    ret nc
```

Carry clear means a fixed spelling matched, and the returned index is already
the operand class.

Examples include:

```text
A     B     C     HL     SP
NZ    Z     NC    PO     PE
(HL)  (BC)  (DE)  AF'
```

Only a failed fixed-word lookup continues into structural expression
classification.

## Direct expressions

If the text does not begin with an opening parenthesis, the classifier returns
class `$2C`:

```asm
.classifyNonRegisterOperand:
    ld a,(hl)
    cp "("
    ld a,02ch
    ret nz
```

This class means roughly:

```text
an expression used directly as an operand
```

It covers many source spellings:

```text
5
32768
LABEL
LABEL+2
$-START
#FF
```

The class does not decide whether the instruction needs an eight-bit value, a
sixteen-bit value or a relative displacement. That information comes from the
matched instruction-table record.

For example, all of these may begin as direct expressions:

```asm
LD B,5          ; immediate byte
LD HL,32768     ; immediate word
JR LOOP         ; relative displacement
RST 8           ; restricted encoded value
```

After instruction matching, the selected emitter interprets the expression in
the required way and performs the appropriate range check.

This separation keeps the textual classifier small.

## Parenthesized expressions

If an operand begins with `(` but is not a recognized fixed form such as `(HL)`,
PROMETHEUS returns class `$2D`:

```text
generic indirect expression
```

Examples are:

```asm
LD A,(32768)
LD HL,(TABLE)
LD (SCREEN+32),A
JP (VECTOR)        ; if a corresponding instruction form exists
```

The source record keeps the expression inside the parentheses, not merely its
current numeric result.

The opening parenthesis is part of the class. `encodeOperandExpression` skips
it before compressing the expression and checks for a correct closing boundary.
When the record is expanded later, the operand descriptor restores the
parentheses around the reconstructed expression.

Thus punctuation that belongs to a general syntactic form is often represented
by the class rather than stored character by character.

## Recognizing IX and IY displacements

The most interesting structural path begins when the operand starts with:

```text
(i
```

The classifier inspects the next character:

```asm
    inc hl
    ld a,(hl)
    cp "i"
    jr nz,.returnGenericExpressionOperandClass
    inc hl
    ld a,(hl)
    cp "x"
    ld b,02eh
    jr z,.returnIndexDisplacementOperandClass
    cp "y"
    ld b,02fh
    jr nz,.returnGenericExpressionOperandClass
```

`(IX...)` receives class `$2E` and `(IY...)` class `$2F`, but only if the next
character is `+` or `-`:

```asm
.returnIndexDisplacementOperandClass:
    inc hl
    ld a,(hl)
    cp "+"
    jr z,.returnRegisterOperandClass
    cp "-"
.returnGenericExpressionOperandClass:
    ld a,02dh
    ret nz
.returnRegisterOperandClass:
    ld a,b
    ret
```

So:

```text
(ix+5)       indexed-displacement class
(iy-table)   indexed-displacement class
(ix)         fixed operand, found earlier in the dictionary
(ix*2)       not indexed-displacement grammar; falls back toward generic form
```

This distinction is useful because an indexed instruction needs a signed
one-byte displacement emitted in a particular place among prefixes and opcode
bytes.

## Why `(IX)` and `(IX+0)` are different classes

The fixed operand table contains `(IX)` and `(IY)`. They are used by forms such
as:

```asm
JP (IX)
JP (IY)
```

An indexed memory reference such as:

```asm
LD A,(IX+0)
```

is not merely another spelling of the same operand. The machine encoding
contains a displacement byte, even when that byte is zero.

PROMETHEUS therefore distinguishes:

```text
(IX)       fixed indirect index register
(IX+expr)  indexed memory operand with displacement
```

The source language's structural classes mirror real differences in Z80
encoding.

## IX and IY share most table records

The Z80 generally uses the same instruction form for IX and IY. The only change
is the prefix byte:

```text
DD  selects IX
FD  selects IY
```

Duplicating every IX instruction record with an IY twin would waste a large
amount of table space. PROMETHEUS normalizes IY operand classes to their IX
counterparts and separately remembers that the FD prefix must be used.

The routine is `normalizeIndexOperandClass`:

```asm
normalizeIndexOperandClass:
    cp 01ah
    jr z,.convertIYClassToIXClass
    cp 01ch
    jr z,.convertIYClassToIXClass
    cp 01eh
    jr z,.convertIYClassToIXClass
    cp 02ah
    jr z,.convertIYClassToIXClass
    cp 02fh
    ret nz
.convertIYClassToIXClass:
    dec a
    push hl
    ld hl,varcUseIYPrefix+1
    ld (hl),001h
    pop hl
    cp a
    ret
```

The paired IY class is one greater than its IX class. Normalization decrements
it and sets `varcUseIYPrefix`.

Conceptually:

```text
input class:  IY version
search class: corresponding IX version
side flag:    use FD instead of DD
```

This happens independently for both operands because some Z80 forms mention an
index register in different positions.

After a matching instruction record is found, the source-header metadata is
patched from the common DD family to FD when the flag is set:

```asm
varcUseIYPrefix:
    ld a,000h
    or a
    jr z,.initializeEncodedRecordHeader
    res 5,d
    set 4,d
```

One instruction table can therefore describe both families while the persistent
source record still remembers the user's IX/IY choice.

## Special small numeric operands

Some Z80 instructions have operands that look like ordinary numbers but belong
to a very small fixed domain.

PROMETHEUS treats several of these specially during source entry.

### Interrupt mode

For `IM`, the single-character operand is checked against the permitted compact
range.

### Bit numbers

For `BIT`, `RES` and `SET`, the first operand must be a single digit in the
accepted bit-number range.

The encoder performs an inexpensive biased-character test before generic
classification:

```asm
    ld a,(hl)
    sub 02fh
    cp 009h
    jp nc,badOperandError
    or a
    jp z,badOperandError
```

The exact biased values are chosen to fit the subsequent compact table key.
The important point is that a bit number is not stored as an arbitrary
expression such as `3+4`. The syntax expects a direct small digit.

This lets the instruction table encode the chosen bit directly into opcode
metadata and prevents nonsensical forms early.

## From classes to an instruction signature

After both operands are classified, the encoder has values such as:

```text
LD B,5
    mnemonic = LD
    operand1 = fixed B class
    operand2 = direct expression class

JR NZ,LOOP
    mnemonic = JR
    operand1 = fixed NZ condition class
    operand2 = direct expression class

LD A,(IX+3)
    mnemonic = LD
    operand1 = fixed A class
    operand2 = indexed-displacement class
    prefix   = IX
```

The two classes are packed into `D:E` with shifts so their bits align with the
five-byte instruction-table format. The mnemonic index is packed alongside
them.

The search then asks:

> Is there a Z80 instruction record with this mnemonic and exactly these
> operand classes?

This is stricter than asking whether every word is individually legal.

## Several examples from beginning to class

### `LD B,5`

Field split:

```text
mnemonic = ld
first    = b
second   = 5
```

Classification:

```text
b → fixed operand dictionary → class for B
5 → no opening parenthesis → direct expression $2C
```

Instruction search finds the record documented as:

```asm
; ld b,N
    defb 0x06,0x01,0x14,0x55,0x87
```

The expression `5` is compressed into the source record. During pass two it is
evaluated and emitted as one checked byte.

### `JR NZ,LOOP`

Field split:

```text
mnemonic = jr
first    = nz
second   = loop
```

Classification:

```text
nz   → fixed condition class
loop → direct expression $2C
```

The matching record says the final value is a relative displacement, not an
absolute byte. The second-pass relative emitter will subtract the address after
the instruction and check the signed range.

### `LD A,(HL)`

Both operands are fixed dictionary words:

```text
a    → fixed A class
(hl) → fixed indirect-HL class
```

No expression bytes need to be stored. The persistent source record can be a
short fixed record containing only its two metadata bytes.

### `LD A,(TABLE)`

The first operand remains fixed `A`. The second begins with `(`, fails the fixed
operand dictionary and is not IX/IY displacement syntax, so it becomes generic
indirect expression `$2D`.

`TABLE` is compressed into the record as a symbol ordinal. Pass two evaluates
its address and emits the word required by the matched `LD` form.

### `LD A,(IY-OFFSET)`

The second operand becomes class `$2F`:

```text
IY indexed displacement
```

Normalization changes the search class to the IX equivalent and sets the IY
flag. The table match uses the common indexed record. The stored source header
uses FD-family metadata, and the expression `-OFFSET` is retained for later
evaluation as a signed displacement.

### `LD BC,DE`

Both `BC` and `DE` are legal fixed operands, and `LD` is a legal mnemonic.
Nevertheless no five-byte instruction record describes `LD BC,DE`.

The final result is:

```text
Bad instruction
```

This demonstrates the three recognition levels:

```text
word exists
operand classes exist
combined instruction form does not exist
```

## Encoding only the variable parts

After instruction matching, fixed operands do not need any payload. Their
identity is already contained in the selected instruction metadata.

Expression-bearing classes are compared with `$2C`:

```asm
    ld a,(varcFirstOperandClass+1)
    cp 02ch
    ld de,varLowercasedOperands
    call nc,encodeOperandExpression
```

Classes below `$2C` are fixed. Classes `$2C` and above contain expression
material that must be compressed.

If both operands contain expressions, the encoder inserts byte `$1F` between
them:

```asm
    ld (ix+000h),01fh
    inc ix
    inc b
```

That separator does not appear in reconstructed source text. It is an internal
boundary enabling the later evaluator and expander to know where one expression
ends and the next begins.

Again, PROMETHEUS stores only what cannot be recovered from the instruction
record.

## The expression encoder sees a simplified view

The operand class tells `encodeOperandExpression` how much structural
punctuation to skip.

Conceptually:

```text
direct expression:
    encode from first character

(parenthesized expression):
    skip opening parenthesis
    encode interior

(IX+expression) or (IY-expression):
    skip “(ix” or “(iy”
    begin at + or - displacement sign
```

The encoder then recognizes:

- unary signs;
- current-address atom `$`;
- identifiers, replaced by symbol ordinals;
- numeric and quoted atoms;
- arithmetic operators;
- closing parenthesis, comma or record end.

Chapter 22 will follow this expression language in detail. The crucial point
here is that structural operand classification reduces several visible forms to
a common expression stream.

## Classification is deliberately shallow

`classifyOperandText` does not try to prove every semantic fact.

It does not know whether `TABLE+2` fits in eight bits. It does not know the
address of `TABLE`. It does not calculate a relative displacement. It does not
know whether a direct expression will become an immediate byte, word, port
number or restart vector until the instruction record is found.

Its job is only:

```text
recognize fixed vocabulary where possible
otherwise identify the outer grammatical shape
```

This division of labor keeps the line-entry path responsive and permits forward
references.

## A compact grammar

We can describe the accepted outer forms as:

```text
operand := empty
         | fixedOperand
         | expression
         | '(' expression ')'
         | '(ix' ('+' | '-') expression ')'
         | '(iy' ('+' | '-') expression ')'
```

Some forms such as `(IX)` are captured by `fixedOperand` before the indexed rule
is considered.

Special instruction families add small restrictions:

```text
IM mode
BIT bitNumber,target
RES bitNumber,target
SET bitNumber,target
```

The grammar is not implemented as a general parser table. It is encoded in the
order of tests inside `classifyOperandText` and in the special checks surrounding
it.

## In plain pseudocode

```text
function classifyOperand(text):
    if text is empty:
        return NONE

    if length(text) < 5:
        fixed = lookupFixedOperand(text)
        if fixed exists:
            return fixed.class

    if text does not begin with '(':
        return DIRECT_EXPRESSION

    if text begins with '(ix+' or '(ix-':
        return IX_DISPLACEMENT

    if text begins with '(iy+' or '(iy-':
        return IY_DISPLACEMENT

    return INDIRECT_EXPRESSION
```

Normalization:

```text
function normalizeIndexClass(class):
    if class is an IY variant:
        useIYPrefix = true
        return corresponding IX class
    return class
```

Complete line-form recognition:

```text
mnemonicIndex = lookupMnemonic(mnemonicText)
class1 = classifyOperand(firstOperand)
class2 = classifyOperand(secondOperand)

searchClass1 = normalizeIndexClass(class1)
searchClass2 = normalizeIndexClass(class2)

record = findInstruction(mnemonicIndex, searchClass1, searchClass2)
if no record:
    error “Bad instruction”

if useIYPrefix:
    convert selected DD-family metadata to FD

encode expressions only for classes DIRECT_EXPRESSION and above
```

## What has changed in memory

After operand classification and instruction matching:

- normalized first and second operand strings remain in their temporary
  buffers;
- `varcFirstOperandClass+1` contains the first class;
- `varcSecondOperandClass+1` contains the second class;
- `varcUseIYPrefix+1` records an IY spelling when normalization was needed;
- the matching five-byte instruction record has supplied opcode and information
  bytes for the temporary compressed source record;
- fixed operand text can be discarded;
- expression-bearing text is compressed into persistent payload bytes.

No final expression value has yet been required.

## Important labels encountered

- `readFirstOperandUntilComma`
- `readSecondOperandToEnd`
- `varLowercasedOperands`
- `commandArgumentBuffer`
- `validateParsedOperandBuffers`
- `classifyOperandText`
- `normalizeIndexOperandClass`
- `varcUseIYPrefix`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `encodeOperandExpression`
- `firstOperandDelimiterByte`

## Back to the bigger picture

We can now extend the assembler pipeline from Chapter 19:

```text
source text entered by user
    ↓
mnemonic recognized by packed dictionary
    ↓
operands classified by fixed vocabulary and outer syntax
    ↓
exact five-byte instruction record selected
    ↓
variable expressions compressed into source record
    ↓
pass one determines addresses and definitions
    ↓
pass two evaluates those expressions and emits bytes
```

The next missing piece is the expression itself. A source record may contain
`TABLE+2`, `$-START`, a hexadecimal number, a quoted character or a unary minus.
Chapter 22 will show how PROMETHEUS stores and evaluates these without a large
compiler, operator-precedence tree or heap of temporary nodes.
