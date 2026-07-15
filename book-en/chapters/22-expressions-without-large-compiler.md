# Chapter 22: Expressions Without a Large Compiler

An assembler would be rather unpleasant if every operand had to be a finished
number.

We want to write:

```asm
        LD HL,SCREEN+32
        JR NZ,LOOP
        DEFW TABLE+2
        ORG #8000
```

not:

```asm
        LD HL,16416
        JR NZ,-7
        DEFW 32786
        ORG 32768
```

Names make a program readable, and arithmetic lets one name describe several
nearby places. The difficulty is that the assembler often meets an expression
before it knows what the names mean. `LOOP` may be defined twenty lines later.
`TABLE` may move after an edit. The current address represented by `$` changes
from one source record to the next.

A modern compiler might build a tree in memory:

```text
        +
       / \
  SCREEN  32
```

PROMETHEUS does nothing so grand. It uses a tiny expression language that can be
checked when the line is entered, stored compactly inside the source record,
and evaluated later during assembly. There is no heap of syntax-tree nodes, no
operator-precedence parser and no recursive descent through nested brackets.

The system is small enough to understand as a sequence of atoms and operators.
That simplicity is not an accident. It is one of the ways PROMETHEUS fits a
serious assembler into a 48K Spectrum.

## An expression has three lives

The same expression appears in three forms during its lifetime.

### 1. Human text

The programmer enters something such as:

```text
TABLE+2
```

or:

```text
$-START
```

This form is pleasant to read, but it is wasteful to keep repeatedly in a
compressed source program. A long name would have to be copied into every line
that used it.

### 2. Encoded source payload

When the source line is accepted, ordinary punctuation and digits remain as
characters, but a symbol name is replaced by its two-byte ordinal.

Conceptually:

```text
TABLE+2
```

becomes:

```text
[tagged ordinal of TABLE] '+' '2'
```

The exact bytes are discussed later in this chapter. The important point is
that the persistent record remembers *which symbol* was written without
remembering the full spelling.

### 3. A 16-bit value

During an assembler pass, the expression is read from the compressed record and
calculated using the current symbol values and current address counter.

```text
TABLE = $8120
TABLE+2 = $8122
```

The result is a 16-bit number. Later code decides whether that number is suitable
for the particular instruction field: byte, word, relative displacement, bit
number and so on.

This separation is central:

```text
line entry checks and stores the expression
assembly later evaluates it
instruction emission later checks how the value is used
```

## The small language

PROMETHEUS expressions are built from **atoms** joined by binary operators.

The principal atoms are:

```text
1234        decimal number
#4D2        hexadecimal number
%101101     binary number
"A"         one-byte quoted constant
"AB"        two-byte quoted constant
$           current logical assembly address
LABEL       symbol value
```

The binary operators are:

```text
+   addition
-   subtraction
*   multiplication
/   unsigned division
?   unsigned remainder
```

A leading `+` or `-` may be placed before an atom:

```text
-1
+TABLE
BASE+-2
```

The most surprising rule is that PROMETHEUS evaluates strictly from left to
right. Multiplication and division do **not** have the usual mathematical
priority over addition and subtraction.

Thus:

```text
2+3*4
```

is evaluated as:

```text
(2+3)*4 = 20
```

not:

```text
2+(3*4) = 14
```

This rule sounds primitive, but it removes the need for an operator stack or an
expression tree. The manual can state the rule, the programmer can add an
intermediate `EQU` symbol when necessary, and the evaluator remains extremely
small.

Parentheses seen in operands usually belong to Z80 addressing syntax:

```asm
LD A,(TABLE+2)
```

They delimit the indirect operand; they are not a general precedence mechanism
inside the arithmetic language.

## The encoder is also a syntax checker

Chapter 21 ended at `encodeOperandExpression`. The routine receives a normalized
operand buffer and writes variable bytes into the temporary source record.

Its main job can be written as:

```text
repeat:
    read optional unary sign
    read one atom
    encode the atom

    if expression boundary reached:
        finish

    require one of + - * / ?
    store the operator
    require another atom
```

The real routine begins by moving past the outer operand syntax. A direct
expression begins immediately. A parenthesized expression skips its opening
bracket. An indexed operand skips `(ix` or `(iy)` and starts at the displacement
sign.

```asm
encodeOperandExpression:
    cp ","
    jr z,.beginExpressionTokenScan
    inc de
    cp "-"
    jr z,.beginExpressionTokenScan
    inc de
    inc de
.beginExpressionTokenScan:
    call testClosingBracketOrComma
```

This compact entry sequence depends on the operand classes already established
in Chapter 21. `encodeOperandExpression` does not rediscover the complete outer
grammar. The caller has already told it what sort of expression-bearing operand
it is dealing with.

## Expression boundaries

The helper `testClosingBracketOrComma` recognizes the places where the current
expression must stop:

```asm
testClosingBracketOrComma:
    ld a,(de)
    inc de
    cp ")"
    jr z,.setFlagForSyntaxError
    cp ","
    jr z,.setFlagForSyntaxError
    or a
    ret nz
.setFlagForSyntaxError:
    scf
    ret
```

Despite the historical local-label name, carry here is not necessarily an
error. It means:

```text
comma, closing parenthesis or end of text has been reached
```

The caller decides whether that boundary is legal at the present moment.

At the beginning of an atom, a boundary is illegal:

```text
TABLE+
       ^ another atom was required
```

After a complete atom, the same boundary is exactly what finishes the
expression.

PROMETHEUS often uses flags in this manner. Carry does not have one universal
meaning. It is a compact answer agreed upon by a caller and callee.

## Unary plus disappears; unary minus remains

At the beginning of each atom, the encoder checks for a sign:

```asm
    cp "+"
    jr z,.readExpressionAfterUnaryMinus
    cp "-"
    jr nz,.classifyExpressionAtom
    call storeAtIXMoveToNextAndIncB
.readExpressionAfterUnaryMinus:
    call testClosingBracketOrComma
```

Unary plus adds no information, so it is consumed but not stored.

Unary minus matters and is copied into the compressed expression. During later
evaluation it means:

```text
read atom
replace value with its 16-bit two's-complement negative
then apply the previous binary operator
```

For example:

```text
BASE+-2
```

can remain a simple left-to-right sequence:

```text
atom BASE
operator +
unary -
atom 2
```

No special subtraction grammar is needed beyond distinguishing the binary
operator after one atom from the unary sign before the next.

## The current-address atom

The dollar sign represents the current logical assembly address:

```asm
        DEFW $-TABLE
```

The encoder simply stores `$` as an ordinary literal byte. Its meaning is not
resolved until an assembler pass, because the address counter may change when
source above the line is edited.

During evaluation:

```asm
    cp "$"
    ld de,(varcAddressCounter+1)
    jr z,.advancePastEncodedExpressionAtom
```

The instruction operand patched at `varcAddressCounter+1` is therefore more than
an assembler variable. It gives expressions access to the logical location at
which the current source record is being processed.

This is another example of the source's self-modifying state conventions from
Chapter 5.

## Symbol names become ordinals

When the first character is a letter, the encoder treats the atom as a symbol:

```asm
    dec de
    push de
    push ix
    ex de,hl
    call findOrCreateSymbolOrdinal
    pop ix
    set 7,h
    ld (ix+000h),h
    inc ix
    ld (ix+000h),l
    inc ix
```

Several important things happen here.

First, the spelling is normalized and looked up in the symbol table. If it does
not yet exist, a new symbol is created. This is why a forward reference is
possible: using `LOOP` can create its identity before a later line defines its
value.

Second, the source record stores the one-based ordinal, not a pointer to the
name and not the characters of the name.

Third, bit 7 is set in the high ordinal byte. This turns the first byte into a
tag in the range `$80-$BF`.

The expression stream can therefore be scanned without a separate token-length
table:

```text
$00-$7F  literal character such as digit, operator, quote or '$'
$80-$BF  first byte of a two-byte symbol ordinal
$C0-$FF  source-record terminal/back-link marker
```

A scanner sees a byte at least `$80` but below `$C0`, knows that one more byte
belongs to the symbol reference, and can then continue.

This tagging scheme is one of the book's recurring examples of a **tiny data
language**. A few unused high bits make a mixed stream self-describing.

## Numbers are checked while they are copied

Literal numbers are not merely accepted as arbitrary character strings. The
encoder checks their syntax and range while retaining a canonical textual
spelling.

The default radix is decimal:

```text
32768
```

A prefix selects another radix:

```text
#8000       hexadecimal
%10101100   binary
```

The core algorithm is:

```text
value = 0
for each valid digit:
    value = value * radix
    value = value + digit
    fail if either operation exceeds 16 bits
    copy the normalized source character into the record
```

The multiplication is performed by repeated addition because the radix is only
2, 10 or 16:

```asm
    ld a,c
    dec a
    ld d,h
    ld e,l
.multiplyLiteralAccumulatorByRadixLoop:
    add hl,de
    jp c,bigNumberError
    dec a
    jr nz,.multiplyLiteralAccumulatorByRadixLoop
```

If the current accumulator is `123` and the radix is ten, the old value is added
nine more times to itself, producing `1230`. The digit is then added.

This is not the fastest imaginable conversion, but numbers in source lines are
short and line entry is interactive. The code saves space and catches overflow
at the moment it occurs.

Lowercase hexadecimal digits are normalized to uppercase before being copied.
Thus `#beef` can reappear in canonical source as `#BEEF`.

## A valid digit depends on the radix

`convertInputCharacterToRadixDigit` first maps ASCII characters into candidate
values:

```text
'0'..'9' → 0..9
'A'..'F' → 10..15
'a'..'f' → 10..15, with canonical uppercase spelling
```

The caller then compares the candidate with the selected radix.

```text
%102       digit 2 is invalid in radix 2
#1G        G is not a hexadecimal digit
19         both digits are valid in radix 10
```

A non-digit may also be a legitimate operator or boundary, so “not a digit” is
not immediately an error. The outer expression parser decides what may follow
the completed number.

## Quoted constants pack one or two bytes

PROMETHEUS accepts a double-quoted atom containing at most two logical
characters:

```text
"A"     → $0041
"AB"    → $4142 interpreted as a two-byte constant by the evaluator's order
```

The exact high/low arrangement is determined by the evaluator's byte-building
sequence, not by how the characters look on paper. The practical rule is that a
one-character constant produces that character's byte value, while a
two-character constant produces one 16-bit value containing both bytes.

A doubled quote represents a literal quote character. A third data character
before closure gives `Bad string`.

The encoder retains the quoted spelling in the compressed expression. This is
useful when the line is expanded back into readable source: the expression can
be reconstructed without inventing a numeric replacement.

The algorithm is roughly:

```text
copy opening quote
read first logical character, if any
read second logical character, if any
require closing quote now
copy closing quote
```

The quote-handling code is more intricate than the pseudocode because it must
distinguish a closing quote from a doubled quote used as data.

## Operators are stored literally

After one atom, the encoder accepts only:

```text
+ - * / ?
```

and copies the chosen operator into the record.

```asm
    cp "+"
    jr z,.storeExpressionOperatorAndContinue
    cp "-"
    jr z,.storeExpressionOperatorAndContinue
    cp "*"
    jr z,.storeExpressionOperatorAndContinue
    cp "/"
    jr z,.storeExpressionOperatorAndContinue
    cp "?"
    jp nz,syntaxError
```

The next byte must begin another atom. Consequently malformed forms are rejected
while the line is entered:

```text
A++        sign without following atom
A&3        unsupported operator
#          radix prefix without digit
"ABC"      quoted constant too long
```

A forward symbol is not an error at this stage. Its spelling can be valid even
when its value is not yet known.

## The encoded stream is still readable

Suppose, only for illustration, that `TABLE` has ordinal 37. Its two-byte
ordinal might be represented as a tagged high byte and a low byte. Then:

```text
TABLE+2
```

has the conceptual payload:

```text
SYMBOL(37), '+', '2'
```

and:

```text
$-START
```

becomes:

```text
'$', '-', SYMBOL(ordinal of START)
```

The stream is not machine code. It is a compact postfix-free little language
that remains in the same order as the original text.

That order makes expansion easy: literal bytes are copied, tagged symbol
ordinals are replaced by names, and the record terminator says when to stop.
Chapter 14 already used this reverse path without yet explaining the evaluator.

## Two evaluators, one arithmetic model

PROMETHEUS has two principal expression-entry situations.

### Text command expressions

Commands such as `U-TOP` are typed into the input line and evaluated directly.
`evaluateInputExpression` points at the command argument and enters
`evaluateExpressionAtHL`.

This evaluator first copies and normalizes the text into command workspace. It
then recognizes atoms and symbols from characters.

### Encoded source expressions

Assembler source records already contain tagged symbol ordinals and validated
literal spelling. `evaluateEncodedExpressionAtIX` reads them directly without
reconstructing text.

These two front ends differ in how they obtain an atom, but they converge on the
same ideas:

```text
accumulated value
pending binary operator
possible unary minus on next atom
shared 16-bit arithmetic routines
```

The text evaluator is useful for interactive commands. The encoded evaluator is
compact and fast enough to run repeatedly during assembler passes.

## The stack becomes the expression workspace

The textual evaluator begins with:

```asm
evaluateExpressionAtHL:
    ...
    ld hl,00000h
    ld a,"+"
.evaluateTextExpressionLoop:
    push hl
    push af
```

`HL` is the accumulated result. `A` is the operator waiting to combine that
result with the next atom.

The first waiting operator is `+`, and the initial accumulator is zero. This
turns the first atom into an ordinary case:

```text
0 + firstAtom
```

While the next atom is decoded, the old accumulator and operator wait on the
Z80 stack. The atom's value is formed in another register pair. The routine then
restores the waiting state and applies the operator.

Conceptually:

```text
accumulator = 0
pending = '+'

loop:
    atom = readAtom()
    atom = applyUnarySign(atom)
    accumulator = apply(pending, accumulator, atom)

    if end:
        return accumulator

    pending = readOperator()
```

This is the entire reason no expression tree is required.

## Symbols must be known at evaluation time

The textual evaluator recognizes a name by calling
`parseSymbolNameAndFindOrdinal`, then resolves the ordinal:

```asm
    call resolveSymbolReferenceToName
    ld a,(hl)
    and 0c0h
    ld a,MESSAGE_UNKNOWN
    jp z,signalError
```

The high flag byte of the symbol vector is accepted when either:

```text
DEFINED bit is set
or
LOCKED bit is set
```

An existing but currently unknown symbol is therefore different from a name
that does not exist at all. In either case the interactive command reports
`Unknown`, but internally PROMETHEUS has preserved the identity needed for
forward references in source.

The encoded evaluator performs the same flag test. If the symbol is unknown, it
also remembers the name address for the assembler diagnostic before returning
to the offending source record.

Chapter 23 will explain where those flags and values live.

## Left-to-right evaluation in action

Consider:

```text
10-2*3+1
```

PROMETHEUS proceeds as follows:

```text
start accumulator = 0, pending = +

atom 10:
    0 + 10 = 10
    next pending operator = -

atom 2:
    10 - 2 = 8
    next pending operator = *

atom 3:
    8 * 3 = 24
    next pending operator = +

atom 1:
    24 + 1 = 25
```

The result is 25.

For a programmer accustomed to ordinary precedence, this is a rule to remember.
For the implementation, it is a major simplification: one accumulator and one
pending operator are sufficient.

## Sixteen-bit arithmetic wraps

Addition and subtraction use the Z80's natural 16-bit behavior. If a result
passes beyond `$FFFF`, it wraps around modulo 65536.

```text
$FFFF + 1 = 0
0 - 1 = $FFFF
```

This is useful in an assembler. `U-TOP -1`, for example, naturally creates
`$FFFF`.

Literal entry itself is stricter: a written number too large for sixteen bits
produces `Big number`. But arithmetic performed after valid atoms is allowed to
wrap.

This distinction is sensible:

```text
70000       is not a legal 16-bit literal
$FFFF+1     is a legal 16-bit calculation whose result wraps to zero
```

## Addition and subtraction

The two simplest operator implementations are almost direct translations of
their meaning:

```asm
.addExpressionOperands:
    add hl,de
    ret
.subtractExpressionOperands:
    or a
    sbc hl,de
```

`or a` clears carry before `SBC`, turning it into ordinary 16-bit subtraction.

The operands follow the shared convention:

```text
HL = accumulated left side
DE = newly read right-side atom
```

The result returns in `HL` and becomes the next accumulator.

## Multiplication by shift and add

The Z80 has no general 16-bit multiply instruction. PROMETHEUS uses a sixteen-step
shift-and-add routine.

At a high level:

```text
result = 0
repeat for 16 multiplier bits:
    shift result
    shift next multiplier bit into carry
    if bit was 1:
        add multiplicand
```

Only the low sixteen bits survive, matching the evaluator's wraparound model.

For a young assembly programmer, this routine is worth studying not because one
must memorize it, but because it shows a general lesson:

> A missing processor instruction can often be replaced by a small loop over
> bits.

## Division by restoring subtraction

Division is also implemented in software. `divideHLByDE` performs sixteen
rounds of an unsigned restoring division.

The broad idea is:

```text
remainder = 0
quotient bits = bits of dividend

for each bit:
    shift next dividend bit into remainder
    try remainder - divisor
    if subtraction succeeded:
        keep it and set quotient bit
    otherwise:
        restore old remainder
```

The real loop is compact:

```asm
divideHLByDE:
    ld a,h
    ld c,l
    ld hl,00000h
    ld b,010h
.unsignedDivideLoop:
    sli c
    rla
    adc hl,hl
    sbc hl,de
    jr nc,.unsignedDivideKeepBit
    add hl,de
    dec c
.unsignedDivideKeepBit:
    djnz .unsignedDivideLoop
    ret
```

The quotient is assembled in `A:C`; the remainder stays in `HL`.

The `/` operator returns the quotient. The `?` operator uses the remainder left
by the same primitive.

### Division by zero

PROMETHEUS does not raise a special error for division by zero. The original
algorithm's repeated trials produce quotient `$FFFF`, matching the documented
behavior.

This is a useful historical reminder: an implementation may define an edge case
through its algorithm rather than through a modern exception mechanism.

## Unary minus uses two's complement

To negate a 16-bit value in `DE`, PROMETHEUS complements both bytes and adds one:

```asm
negateDEIfOperatorIsMinus:
    cp "-"
    ret nz
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ret
```

That is the standard two's-complement operation:

```text
-value = bitwise_not(value) + 1
```

Examples:

```text
1      → $0001
-1     → $FFFF
2      → $0002
-2     → $FFFE
```

Again, no signed-number object exists. The same sixteen bits can be interpreted
as unsigned or two's-complement signed according to what the surrounding
operation needs.

## The encoded evaluator walks through `IX`

`evaluateEncodedExpressionAtIX` keeps `IX` based near the source-record header.
The current expression byte is repeatedly fetched through a fixed displacement:

```asm
    ld a,(ix+002h)
```

Instead of changing the displacement, the routine increments `IX` as it consumes
bytes. This preserves a compact instruction shape throughout the loop.

A symbol token is recognized by its high range:

```asm
    cp 080h
    jp c,.parseNumericOrQuotedConstantAtIX
```

Bytes below `$80` are literal text. A byte in the symbol range becomes the high
ordinal byte, followed by the low ordinal byte.

The resolver then returns:

```text
HL = vector flag-byte address
DE = symbol-name address
DE-2 = symbol-value address
```

The evaluator checks the flags and loads the two-byte value stored immediately
before the name.

## End markers need no separate length

After an atom has been applied, `readEncodedExpressionOperatorOrEnd` examines the
next byte. It must distinguish:

- another operator;
- an operand separator;
- the source-record terminal/back-link byte.

Because terminal bytes occupy `$C0-$FF`, the same numeric ranges that distinguish
symbols also make the end visible.

The evaluator does not need a separately stored expression length. It walks the
self-describing source payload until the surrounding record format tells it to
stop.

This is one reason the source-record encoding described in Chapter 12 is so
powerful: editor traversal, expression evaluation, symbol-reference scanning and
source expansion all understand the same byte classes.

## Syntax checking and value checking are different

PROMETHEUS deliberately separates several kinds of validity.

### At line entry

The encoder checks:

- atom and operator order;
- legal radix digits;
- literal overflow;
- quote closure and quoted length;
- legal symbol spelling;
- supported operators.

### During assembly

The evaluator checks:

- whether referenced symbols are currently defined or locked.

### During instruction emission

Later code checks:

- whether the resulting value fits a byte;
- whether an index displacement fits its signed range;
- whether a relative branch reaches its target;
- whether a bit number, restart vector or interrupt mode is legal.

This staged design prevents the expression evaluator from knowing every possible
use of a number.

## In plain pseudocode

Encoding a textual operand expression:

```text
function encodeExpression(text):
    output = []

    while true:
        sign = readOptionalUnarySign()
        if sign == '-':
            output.append('-')

        atom = readAtom()

        if atom is symbol name:
            ordinal = findOrCreateSymbol(atom.name)
            output.append(taggedHighByte(ordinal))
            output.append(lowByte(ordinal))

        else if atom is number:
            validateSixteenBitLiteral(atom)
            output.append(canonicalText(atom))

        else if atom is quoted constant:
            validateOneOrTwoCharacters(atom)
            output.append(originalQuotedText(atom))

        else if atom is '$':
            output.append('$')

        else:
            syntaxError()

        if at expression boundary:
            return output

        operator = readCharacter()
        if operator not in '+-*/?':
            syntaxError()
        output.append(operator)
```

Evaluating the encoded expression:

```text
function evaluateEncodedExpression(stream, currentAddress):
    accumulator = 0
    pendingOperator = '+'

    while true:
        unaryMinus = stream.peek() == '-'
        if unaryMinus:
            stream.advance()

        token = stream.peek()

        if token == '$':
            atom = currentAddress
            stream.advance()

        else if token is tagged symbol ordinal:
            symbol = resolveOrdinal(stream.readOrdinal())
            if symbol is neither defined nor locked:
                error Unknown
            atom = symbol.value

        else:
            atom = parseNumericOrQuotedLiteral(stream)

        if unaryMinus:
            atom = -atom modulo 65536

        accumulator = apply(pendingOperator, accumulator, atom)

        if stream is at expression end:
            return accumulator

        pendingOperator = stream.readOperator()
```

Operator application:

```text
function apply(op, left, right):
    '+' → left + right modulo 65536
    '-' → left - right modulo 65536
    '*' → low16(left * right)
    '/' → unsignedQuotient(left, right)
    '?' → unsignedRemainder(left, right)
```

## What has changed in memory

When an expression is accepted into a source record:

- literal digits, radix prefixes, quotes, `$`, unary minus and binary operators
  occupy ordinary payload bytes;
- each symbol spelling has been replaced by a tagged two-byte ordinal;
- any previously unseen symbol has been added to the symbol table;
- the record carries no evaluated value and no fixed pointer to a symbol name;
- the expression's syntax and literal ranges have already been checked.

When the expression is evaluated:

- no permanent source bytes change;
- `varcAddressCounter+1` supplies the current `$` value;
- symbol vectors supply state and symbol records supply values;
- the Z80 stack temporarily holds the accumulator and pending operator;
- the result returns as a 16-bit value, in `HL` for text expressions or `BC` for
  encoded assembler expressions.

## Important labels encountered

- `encodeOperandExpression`
- `encodeQuotedOrNumericAtom`
- `convertInputCharacterToRadixDigit`
- `testClosingBracketOrComma`
- `evaluateInputExpression`
- `evaluateExpressionAtHL`
- `evaluateEncodedExpressionAtIX`
- `readEncodedExpressionOperatorOrEnd`
- `applyExpressionOperatorToHLAndDE`
- `multiplyHLByDE`
- `divideHLByDE`
- `negateDEIfOperatorIsMinus`
- `varcTextAtomUnarySign`
- `varcAddressCounter`

## Back to the bigger picture

The assembler pipeline can now carry a line such as:

```asm
        LD HL,TABLE+2
```

through several stages without knowing `TABLE` too early:

```text
visible operand text
    ↓
outer class: direct expression
    ↓
encoded payload: SYMBOL(TABLE), '+', '2'
    ↓
pass-time symbol resolution
    ↓
16-bit result
    ↓
instruction-specific range check and byte emission
```

The missing object in this story is the symbol itself. We have used ordinals,
values, names and DEFINED/LOCKED flags, but have not yet seen how they coexist in
memory. Chapter 23 opens the symbol table and shows why PROMETHEUS keeps it in
two simultaneous orders.
