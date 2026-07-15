# Chapter 13: Turning Text into a Source Record

In the previous chapter we examined the compact source record as if it had
already appeared in memory. We saw its two-byte header, its optional symbol
ordinals, and its final `$C0+n` marker. That answered the question:

> What does PROMETHEUS keep after a source line has been accepted?

Now we can ask the more interesting question:

> How does a line that a person typed become that record?

The answer is not a single act of tokenization. PROMETHEUS gradually changes
its view of the line.

At first it sees three broad human fields:

```text
label       mnemonic     operands
```

Then it sees known words and expression-shaped text:

```text
symbol      mnemonic #   operand classes
```

Then it finds one exact instruction description:

```text
opcode      prefix family      operand descriptors
```

Finally it writes a persistent record in which repeated names have become
symbol ordinals and the line's visible spacing has disappeared.

This is a good example of the book's top-down, bottom-up, top-down pattern. We
will first follow the whole conversion, then study its small mechanisms, and
finally reconstruct one complete line from keyboard buffer to inserted source.

## The whole conversion in one view

When the user presses ENTER on an ordinary source line, the editor eventually
reaches `parseAndInsertSourceLine`:

```asm
parseAndInsertSourceLine:
    call encodeInputLineToSourceRecord
    call getRecordAfterActiveLine
    push hl
    ld (varcInsertionPointForPointerAdjustment+1),hl
    ld de,encodedRecordStorageLength
    ld a,(de)
    ld c,a
    inc de
    call insertByteRangeAtHLFromDE
    pop hl
    ld (varcSourceBufferActiveLine+1),hl
```

This fragment separates two jobs that are easy to confuse:

1. `encodeInputLineToSourceRecord` **understands** the line and builds a
   temporary compressed record.
2. `insertByteRangeAtHLFromDE` **stores** those already prepared bytes in the
   persistent source area.

The parser does not directly push bytes into the middle of source memory as it
recognizes them. It first builds a complete candidate in a fixed workspace. If
an error is found, the old source remains untouched.

In plain pseudocode:

```text
record = encode(editLine)

if encoding failed:
    show error
    leave source unchanged
else:
    insertionPoint = recordAfter(activeRecord)
    open space of record.length bytes
    copy record into that space
    make new record active

    if OVERWRITE mode:
        delete the old active record

    return to editor
```

That temporary-first design is more than convenient. It is a small transaction:
PROMETHEUS commits the line only after the line has passed all recognition and
syntax checks.

## The input is still the editable line

The encoder starts from `inputBufferStart`, the same short zero-terminated
string described in Chapter 11. The movable `$01` cursor marker may still be
inside it.

Parser routines therefore do not read bytes with a simple `LD A,(HL)`. They use
`atHLorNextIfOne`:

```asm
atHLorNextIfOne:
    ld a,(hl)
    cp 001h
    ret nz
    inc hl
    ld a,(hl)
    ret
```

To the parser, the marker is transparent. It belongs to the editing interface,
not to the assembly language.

This is a recurring PROMETHEUS principle:

> A temporary representation may contain private control bytes, but the next
> layer receives a view in which those bytes have disappeared.

## The visible three-field language

PROMETHEUS's editor presents a conventional assembly layout:

```text
columns  0..8     optional label
columns  9..13    mnemonic
columns 14..31    operands
```

The parser does not trust the spaces to be perfectly aligned. It uses spaces as
separators and ignores additional spaces where reasonable. The field widths are
mainly editing and validation limits.

`encodeInputLineToSourceRecord` performs the first broad split:

```asm
encodeInputLineToSourceRecord:
    cp ";"
    jr z,.encodeCommentSourceRecord
    cp " "
    call nz,readSourceFieldUntilSpace
    call skipSpaces
    ld de,parsedMnemonicBuffer
    ld c,005h
    call readSourceFieldUntilSpace
    call skipSpaces
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

The broad algorithm is:

```text
if first visible character is ';':
    encode comment by a special path
else:
    if line begins before mnemonic field:
        read optional label

    skip spaces
    read mnemonic within its five-column parsing budget

    skip spaces
    read first operand within its fixed workspace, stopping at an unquoted comma
    read second operand to end of line
```

The temporary names are historical compromises. `commandArgumentBuffer`, for
example, is reused here as the second operand buffer. PROMETHEUS saves memory by
letting different operations borrow the same workspace at different times.

## One field reader, three delimiters

The routines for label/mnemonic, first operand, and second operand all enter the
same loop with a different delimiter:

```asm
readSourceFieldUntilSpace:
    ld b," "
    jr .readDelimitedFieldLoop
readFirstOperandUntilComma:
    ld b,","
    jr .readDelimitedFieldLoop
readSecondOperandToEnd:
    ld b,000h
```

This is compact but also conceptually clean. The loop's policy is:

```text
read visible byte, ignoring cursor marker

if quote begins:
    copy quoted material without interpreting spaces or commas
else if byte is selected delimiter:
    stop
else if byte is an unquoted space:
    skip it
else if byte is zero:
    stop at end of line
else:
    normalize and copy it
```

Outside quoted text, the loop forces bit 5:

```asm
set 5,a
```

For alphabetic ASCII, that changes uppercase letters to lowercase. The
temporary parser vocabulary is therefore case-independent:

```text
LD      ld      Ld      lD
```

all become the same normalized mnemonic.

Quoted text is copied verbatim. A character inside a string is data, not an
assembly-language keyword.

## Why commas inside quotes do not split operands

Consider:

```asm
        DEFM "A,B"
```

A naive comma scanner would split the string after `A`. PROMETHEUS instead
enters a quoted-copy loop when it sees `'` or `"`. Delimiter tests are suspended
until the matching quote is reached.

The parser is not a general language compiler, but it understands enough local
structure to distinguish:

```text
comma separating operands
comma stored inside quoted data
```

This is a useful lesson in small parsers. They do not need a huge formal grammar
if the language's difficult cases can be isolated into a few state changes.

## Comments take the shortest path

A source line beginning with semicolon is not divided into label, mnemonic and
operands. PROMETHEUS knows that it cannot usefully compress arbitrary prose
beyond framing it as one record.

The special path begins:

```asm
.encodeCommentSourceRecord:
    ld ix,encodedRecordPayload
    ld (ix-002h),001h
    ld (ix-001h),037h
    ld b,0ffh
```

It sets:

```text
opcode byte       $01       comment pseudo-opcode
information byte  $37       pseudo-record, class 7, no label
```

Then it copies the visible line, including the leading semicolon, until the
zero terminator. The final zero is not stored. The normal finalizer adds the
back-link marker and publishes the byte count.

Comments therefore bypass:

- mnemonic lookup;
- operand recognition;
- symbol creation;
- instruction-table matching;
- expression validation.

This is both faster and safer. A word like `loop` in a comment must not silently
create a symbol.

## Recognizing the mnemonic by length first

After field splitting, `parsedMnemonicBuffer` holds a normalized zero-terminated
word such as `djnz`.

PROMETHEUS does not compare it against every mnemonic from the beginning. It
first measures the length with `lengthUpToZero`, then uses a small descriptor to
select only words of that length.

Conceptually:

```text
length 1  → compare with one-character mnemonic bucket
length 2  → compare with two-character bucket
length 3  → compare with three-character bucket
length 4  → compare with four-character bucket
```

The descriptors in `mnemonicLookupByLengthDescriptors` are wonderfully dense.
Some bytes look like Z80 instructions because the table is embedded directly in
the assembly source:

```asm
mnemonicLookupByLengthDescriptors:
    defw mnemonicsReferences
    defb 0x01
    ld bc,0020ch
    add hl,hl
    ld c,017h
    scf
```

The processor never executes those apparent instructions. Their bytes encode
bucket counts and offsets.

`prepareLengthBucketLookup` turns a length into:

- the number of candidate words in the bucket;
- the address of the first packed spelling;
- the logical index of that first candidate.

`compareWithMnemonics` then compares high-bit-terminated words one character at
a time. Carry set means no candidate matched.

In pseudocode:

```text
length = strlen(mnemonic)
bucket = mnemonicBuckets[length]

for each word in bucket:
    if word == mnemonic:
        return mnemonicIndex

error "Bad mnemonic"
```

This is a small but important optimization. Most mnemonics are eliminated by
length before any character comparison occurs.

## Empty mnemonic and pseudo-instructions

A line may contain only a label. In that case the mnemonic buffer begins with
zero and PROMETHEUS keeps mnemonic index zero.

Assembler-control words such as `ORG`, `EQU`, `ENT`, `DEFB`, `DEFM`, `DEFS` and
`DEFW` also have mnemonic indices, but some are later translated to the
pseudo-opcode range described in Chapter 12.

Definition mnemonics receive a special path because they can contain lists and
strings whose syntax differs from a normal one- or two-operand instruction.

## Operands are first classified, not evaluated

The parser now has up to two normalized operand strings. It does not yet ask
what expression `LOOP+2` evaluates to. It asks what *kind of operand text* it
has.

`classifyOperandText` first measures the string.

For short strings, it searches the fixed operand table. Examples include:

```text
a       hl      nz      (bc)      ix
```

If a fixed spelling is found, the routine returns its compact descriptor index.

If not, structural rules choose one of the expression-bearing classes:

```text
text                 class
--------------------------------------------
LABEL+2              direct expression
(TABLE)              parenthesized expression
(IX+5)               IX displacement
(IY-3)               IY displacement
```

The essential fragment is:

```asm
.classifyNonRegisterOperand:
    ld a,(hl)
    cp "("
    ld a,02ch
    ret nz
    inc hl
    ld a,(hl)
    cp "i"
    jr nz,.returnGenericExpressionOperandClass
```

A non-parenthesized unknown spelling becomes descriptor `$2C`, the generic
direct expression. Parenthesized text becomes `$2D` unless it has the special
`ix` or `iy` displacement shape.

This is not yet instruction validation. `nonsense` can temporarily look like an
expression. Later stages will either create it as a symbol or reject the whole
instruction form.

## IX and IY share most of their description

The Z80 gives IX and IY parallel instruction families. A table containing every
form twice would waste space.

`normalizeIndexOperandClass` maps IY descriptors to their IX counterparts and
sets `varcUseIYPrefix`:

```text
recognize IY-shaped class
    → convert to common IX table class
    → remember that final prefix must be FD rather than DD
```

The instruction table can then describe one common indexed family. After a
matching record is found, the source-record information byte is adjusted to
record whether the user wrote IX or IY.

This is a compact form of normalization:

> Remove an unimportant difference while searching, remember it separately,
> and restore it in the result.

## A few operands receive immediate range checks

Some instructions use a very small literal field that is really part of the
instruction identity:

```asm
IM 0
BIT 7,A
RES 3,(HL)
SET 2,B
```

PROMETHEUS validates the first operand of `IM`, `BIT`, `RES` and `SET` before the
main instruction-table search. An invalid bit number cannot be treated as an
arbitrary expression because the opcode itself contains those bits.

This is a useful distinction:

```text
LD A,VALUE      VALUE may remain unresolved until assembly
BIT 9,A         9 is invalid immediately
```

The parser performs early checks where the instruction shape requires them and
defers true address/value evaluation to the assembler passes.

## Packing two operand classes into a search key

The instruction table stores compact operand descriptors across byte
boundaries. After classifying both operands, PROMETHEUS packs their indexes into
`D:E` with shifts and rotates:

```asm
.packOperandClassesLoop:
    sla e
    rl d
    djnz .packOperandClassesLoop
```

The exact bit arrangement is less important to a first reading than the
purpose:

```text
first operand class + second operand class
        ↓
one compact comparison key
```

The mnemonic index is prepared as another key, and the parser walks
`instructionsTable` looking for one five-byte record whose:

- mnemonic index matches;
- first operand descriptor matches;
- second operand descriptor matches;
- prefix family is compatible.

This is where a plausible-looking line becomes one exact Z80 instruction form.

For example, `LD` alone is not enough. The table distinguishes:

```text
LD A,B
LD A,(HL)
LD HL,nn
LD (nn),A
LD (IX+d),n
```

The parser's central question is therefore not merely:

> Is `LD` a known word?

It is:

> Is there a supported instruction record for this mnemonic and these two
> operand classes?

Failure produces `Bad instruction`, which is more precise than `Bad mnemonic`.

## The instruction table gives back prepared metadata

Once a matching five-byte record is found, PROMETHEUS obtains:

- the opcode byte;
- prefix-family information;
- the compact operand/storage class needed later;
- enough information to reconstruct the mnemonic and operands again.

The parser now knows the semantic shape of the line. It can begin writing the
persistent record.

## Building the header and optional line label

`initializeRecordHeaderAndOptionalLabel` receives the opcode in `E` and the
information byte in `D`.

It first writes those two bytes to `encodedRecordHeader`.

Then it checks whether the original line began with a label. If so, it:

1. sets information bit 3;
2. calls `findOrCreateSymbolOrdinal`;
3. tags the high ordinal byte with bit 7;
4. writes the two-byte ordinal immediately after the header;
5. starts the variable-byte count at two.

The source record stores the label's symbol number, not its spelling.

This means that entering:

```asm
LOOP    DJNZ LOOP
```

may create `LOOP` only once in the symbol table even though the line mentions it
twice:

- once as the line label;
- once as the branch expression.

Both record occurrences become the same ordinal.

## Expressions are compressed without being calculated

The assembler cannot necessarily calculate an expression while the line is
entered. A forward reference may name a label that receives its address only in
the first assembly pass.

The encoder therefore validates and compresses expression **syntax**, but it
does not generally calculate the final value.

`encodeOperandExpression` scans a sequence of atoms and operators.

Supported operators include:

```text
+   -   *   /   ?
```

The expression may begin with unary plus or minus. Unary plus is discarded;
unary minus is retained because it changes the value.

The broad pseudocode is:

```text
read optional leading sign

repeat:
    read one atom

    if atom is identifier:
        find or create symbol
        store tagged two-byte ordinal
    else if atom is number:
        validate radix and 16-bit range
        store canonical spelling
    else if atom is quoted literal:
        validate one- or two-byte form
        store quoted spelling
    else:
        syntax error

    if expression boundary reached:
        finish

    require one supported operator
```

The persistent expression is still readable enough to expand later, but symbol
spellings have been replaced by compact references.

## Identifiers become symbol ordinals

The first letter test identifies a symbol-like atom. PROMETHEUS temporarily
moves the identifier pointer to `HL` and calls `findOrCreateSymbolOrdinal`.

It then writes:

```text
$80 | ordinalHigh
ordinalLow
```

The source pointer advances by the length of the identifier, but the persistent
record grows by only two bytes.

For a long symbol used many times, this is a substantial saving.

More importantly, it creates a direct relationship between source and symbol
management. Later symbol compaction need only update ordinals systematically;
source expressions never contain fragile pointers into movable memory.

## Numbers are checked now even though their use comes later

PROMETHEUS accepts numeric forms such as:

```text
1234       decimal
%101101    binary
#7FFF      hexadecimal
```

While copying the textual spelling into the record, it also accumulates the
numeric value in `HL`.

For each digit:

```text
value = value * radix + digit
```

Multiplication is performed by repeated 16-bit addition. Any carry reports
`Big number`. A digit outside the selected radix also reaches that error path.

Why validate now if the assembler will evaluate the expression later?

Because malformed numeric text is independent of symbol values. Rejecting it at
entry time prevents a bad record from ever entering persistent source.

Lowercase hexadecimal letters are normalized to uppercase in the stored
expression. Thus two equivalent spellings do not create needless display
variation.

## Quoted expression atoms contain at most two bytes

In an expression, a quoted literal represents a one- or two-byte value. The
encoder accepts an empty, one-character or two-character quoted form according
to the implemented rules, retains the quote delimiters, and rejects a third data
character with `Bad string`.

This is different from `DEFM`, where a whole string is data and may be much
longer. The context decides the grammar.

Again PROMETHEUS avoids one enormous universal parser. It uses a small parser
for ordinary expression atoms and a dedicated path for definition records.

## Operand boundaries are not all stored the same way

A comma between two machine operands is already represented by the instruction
table's two operand descriptors. It does not need to be preserved as ordinary
text.

When both operands contain encoded expression material, PROMETHEUS inserts the
private byte `$1F` between them:

```asm
ld (ix+000h),01fh
```

During expansion, `$1F` tells the first expression renderer to stop. The
mnemonic metadata tells the renderer that a second operand exists, so it prints
a visible comma itself and continues with the next expression.

Definition lists such as:

```asm
        DEFB 1,2,3
```

are different. Their commas belong to a variable-length list, so the commas are
kept inside the definition payload.

This illustrates an important compression rule:

> Do not store punctuation when structure already implies it; do store it when
> the number of items is not otherwise known.

## Definition pseudo-instructions use a specialized encoder

`DEFB`, `DEFM`, `DEFS` and `DEFW` are recognized by mnemonic index and mapped to
pseudo-opcodes `$06` through `$09`.

For expression lists, PROMETHEUS joins the temporary first and second operand
buffers, restores a comma where necessary, and repeatedly calls the expression
encoder.

For `DEFM`, it verifies matching quotes and copies the complete quoted string.
Unlike an ordinary expression literal, a `DEFM` string is not restricted to two
data bytes.

The record still uses the same outer frame:

```text
pseudo-opcode
information byte
optional line-label ordinal
encoded definition payload
$C0+n marker
```

The format is shared; the payload grammar is specialized.

## Finalizing the temporary record

Throughout construction, `B` counts variable bytes after the two-byte header.

The finalizer is compact:

```asm
.finalizeEncodedSourceRecord:
    ld a,b
    or a
    jr z,.storeEncodedRecordStorageLength
    set 7,b
    set 6,b
    ld (ix+000h),b
    inc a
.storeEncodedRecordStorageLength:
    add a,002h
    ld (encodedRecordStorageLength),a
    ret
```

Read it as:

```text
if variableByteCount != 0:
    append $C0 + variableByteCount
    copyLength = variableByteCount + marker + header
else:
    copyLength = two-byte header only

publish copyLength before the record workspace
```

`encodedRecordStorageLength` is deliberately adjacent to the record bytes so
the insertion routine can treat the temporary result as:

```text
length byte followed by data bytes
```

Only the data bytes enter persistent source.

## Error handling protects persistent source

The encoder can report:

- `Bad mnemonic`;
- `Bad operand`;
- `Bad instruction`;
- `Big number`;
- `Bad string`;
- `Syntax horror`;
- `Memory full` during later insertion.

All parser errors leave through common status-bar paths before the insertion
primitive is called.

The old source record is therefore preserved even in OVERWRITE mode. PROMETHEUS
does not delete the old line first and hope that the replacement parses.

This order is worth stating explicitly:

```text
encode new line
insert new record
only then delete old record in overwrite mode
```

The editor favors recoverability over the smallest possible number of memory
moves.

## Insertion mode and overwrite mode

After encoding, `parseAndInsertSourceLine` inserts the new record immediately
after the active record and makes it active.

If `varcInsertMode` is zero, that is the end of the structural change.

If overwrite mode is active, PROMETHEUS steps back to the old record and deletes
exactly one record. The newly inserted record survives and becomes the logical
replacement.

In simplified form:

```text
old = active
newPosition = after(old)
insert(newRecord, newPosition)
active = newPosition

if overwrite:
    old = recordBefore(active)
    delete(old, one record)
```

Why insert before deleting?

- a failed parse cannot destroy the old line;
- the encoded record already exists before source mutation begins;
- common insertion and deletion machinery can be reused unchanged.

## Following `LOOP DJNZ LOOP`

Let us now follow the running example:

```asm
LOOP    DJNZ LOOP
```

### 1. Field splitting

The parser obtains:

```text
label       "loop"
mnemonic    "djnz"
operand 1   "loop"
operand 2   empty
```

The words are lowercased outside quotes.

### 2. Mnemonic lookup

`djnz` has length four. The four-character bucket is selected, and packed-word
comparison returns the mnemonic index for `DJNZ`.

### 3. Operand classification

`loop` is not a fixed register or condition spelling. It does not begin with
`(`. It becomes a direct expression class.

The second operand is empty and becomes class zero.

### 4. Instruction-table match

The parser finds the five-byte record describing:

```text
mnemonic DJNZ
first operand = relative expression
second operand = none
opcode = $10
```

The resulting information class records that the expression is a signed
relative branch target.

### 5. Optional label

`LOOP` is found or created in the symbol table. Suppose it receives ordinal 37.
Information bit 3 is set, and the record payload begins with tagged ordinal 37.

### 6. Operand expression

The operand text `LOOP` resolves to the same ordinal 37 and is stored as another
tagged two-byte reference.

### 7. Final marker

The variable payload contains four bytes:

```text
line-label ordinal      2 bytes
branch-target ordinal   2 bytes
```

The final marker is `$C4`.

Conceptually the record is:

```text
$10, informationWithLabelAndRelativeClass,
$80|high(37), low(37),
$80|high(37), low(37),
$C4
```

The visible spelling `LOOP` occurs twice in the input line but not once in the
persistent record. Its identity is carried twice by the same ordinal.

### 8. Commit

The byte count is published, space is opened after the active record, the bytes
are copied, and the new record becomes active.

The next editor repaint does not reuse the submitted text. It expands the new
compressed record afresh. That is an immediate consistency check: what appears
on screen is what PROMETHEUS actually stored.

## Back to the whole editor

The source encoder is a small compiler front end, but it is carefully limited.
It does not calculate final addresses or emit machine code. It prepares a line
for those later jobs.

Its output has already settled several questions:

- which mnemonic was meant;
- which exact instruction form matched;
- which prefix family applies;
- whether the line defines a label;
- which operands are fixed names and which are expressions;
- where symbol names occur;
- which expression storage class the assembler must use.

The persistent source record is therefore not merely compressed text. It is a
cached result of parsing.

That is why the second assembly pass can be much smaller than a conventional
assembler that begins from raw characters every time.

## What has changed in memory?

Before successful submission:

- normalized label, mnemonic and operand strings occupy shared temporary
  buffers;
- `varcMnemonicIndex`, `varcFirstOperandClass`, `varcSecondOperandClass` and
  `varcUseIYPrefix` hold parser state inside instruction operands;
- the candidate record occupies the `encodedRecord...` workspace;
- newly encountered identifiers may already have received symbol ordinals.

After finalization:

- `encodedRecordStorageLength` contains the number of persistent bytes;
- the candidate record has a complete header and optional terminal marker.

After insertion:

- the source/symbol region may have moved upward;
- pointers at or above the insertion point have been repaired;
- `varcSourceBufferActiveLine` points at the new record;
- overwrite mode may have removed the preceding old record;
- `varcInsertMode` is reset to INSERT for the next submission.

## Important ideas for later chapters

- parsing and persistent insertion are separate operations;
- the cursor marker is invisible to field readers;
- unquoted parser text is normalized to lowercase;
- comments bypass instruction parsing completely;
- mnemonic and fixed-operand lookup first selects an exact-length bucket;
- operand text is classified before expression values are known;
- IX and IY share normalized table descriptions;
- one exact instruction-table record must match mnemonic plus both operands;
- line labels and expression identifiers become symbol ordinals;
- numeric spelling is retained but validated against a 16-bit range;
- `$1F` separates two encoded expression operands internally;
- definition lists retain commas because their item count is variable;
- the record is committed only after complete successful encoding;
- overwrite inserts the replacement before deleting the old record.

## Source anchors explained

- `parseAndInsertSourceLine`
- `encodeInputLineToSourceRecord`
- `.encodeCommentSourceRecord`
- `readSourceFieldUntilSpace`
- `readFirstOperandUntilComma`
- `readSecondOperandToEnd`
- `skipSpaces`
- `atHLorNextIfOne`
- `lengthUpToZero`
- `mnemonicLookupByLengthDescriptors`
- `operandLookupByLengthDescriptors`
- `prepareLengthBucketLookup`
- `compareWithMnemonics`
- `validateParsedOperandBuffers`
- `classifyOperandText`
- `normalizeIndexOperandClass`
- `varcMnemonicIndex`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `varcUseIYPrefix`
- `instructionsTable` at source-entry level
- `initializeRecordHeaderAndOptionalLabel`
- `encodeOperandExpression`
- `encodeQuotedOrNumericAtom`
- `convertInputCharacterToRadixDigit`
- `.encodeDefinitionPseudoInstruction`
- `.encodeDefmStringLiteral`
- `.finalizeEncodedSourceRecord`
- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `varcInsertionPointForPointerAdjustment`
- `insertByteRangeAtHLFromDE` at commit level
- `varcInsertMode`
- `badMnemonicError`
- `badOperandError`
- `badInstructionError`
- `bigNumberError`
- `badStringError`
- `syntaxError`
