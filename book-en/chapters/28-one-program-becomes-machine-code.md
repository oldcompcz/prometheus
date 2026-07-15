# Chapter 28: One Program Becomes Machine Code

We have spent nine chapters dismantling the assembler into manageable pieces.
We know how PROMETHEUS recognizes words, classifies operands, stores expressions,
creates symbols, predicts addresses and emits bytes. It is time to put those
pieces back together.

We will return to the small program introduced near the beginning of the book:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

The program is tiny enough to follow without losing our place, but it passes
through nearly every important layer of the assembler:

- a pseudo-instruction that sets the origin;
- two symbol definitions;
- a fixed register operand;
- an immediate expression;
- a relative branch to a symbol;
- a no-operand instruction;
- an `ENT` expression that prepares `RUN`.

This chapter will follow the program three times.

First we will look down from above and state what must happen. Then we will walk
through the records, symbols and two passes in detail. Finally we will return to
the whole operation and see the machine-code image as one finished result.

## The destination before the journey begins

The source starts with:

```asm
        ORG 32768
```

Decimal 32768 is hexadecimal `$8000`. Both the logical address counter and the
physical output pointer will therefore be moved to `$8000`.

That distinction matters even though the two values happen to agree here:

```text
logical address counter = address assigned to labels and `$`
physical output pointer = RAM byte that receives the next output byte
```

`ORG` changes both. A later `PUT` could separate them, but this example does not
need that complication.

The expected output is already easy to predict:

```text
$8000  06 05     LD B,5
$8002  10 FE     DJNZ LOOP
$8004  C9        RET
```

`ORG` and `ENT` do not produce bytes. The final program is therefore five bytes
long.

The purpose of assembly is not merely to discover those five values. It must
also:

- assign `START=$8000`;
- assign `LOOP=$8002`;
- validate that every source form is legal;
- calculate the signed branch displacement `$FE`;
- make the `RUN` command call `$8000`;
- avoid overwriting protected memory while emitting the result.

## The source does not enter the assembler as text

By the time the user invokes ASSEMBLY, the five lines are already stored as
compressed semantic records. The spelling has been converted into indexes,
classes, ordinals and encoded expressions.

The exact ordinal numbers depend on the current symbol table. For this example,
we can imagine that the editor created:

```text
ordinal 1 -> START
ordinal 2 -> LOOP
```

The records can then be pictured conceptually like this:

```text
record 1
    pseudo-opcode: ORG
    expression: literal 32768

record 2
    line label: symbol ordinal 1 (START)
    instruction form: LD register, immediate byte
    fixed operand: B
    expression: literal 5

record 3
    line label: symbol ordinal 2 (LOOP)
    instruction form: DJNZ relative expression
    expression: symbol ordinal 2 (LOOP)

record 4
    instruction form: RET
    no expression payload

record 5
    pseudo-opcode: ENT
    expression: symbol ordinal 1 (START)
```

This is not the literal byte dump, because the instruction-table indexes and
symbol ordinals are properties of the current source and table. It is the
important semantic structure.

Notice what is absent:

- the letters `S T A R T` are not repeated in record 2 and record 5;
- the letters `L O O P` are not repeated in record 3's definition and branch;
- `LD`, `DJNZ` and `RET` are represented by compact table identities;
- the decimal spellings `32768` and `5` have become encoded numeric atoms.

The assembler therefore begins from a form that is already partly understood.
It is not asked to tokenize five human-readable lines again.

## Before pass one: symbols lose old definitions

A previous assembly may have left values in the symbol table. PROMETHEUS cannot
simply trust them, because editing may have changed instruction lengths or label
positions.

`processCompilation` first clears the DEFINED bit of every unlocked symbol:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

The byte `$B6` is the encoded `RES 6,(HL)` operation installed into the shared
symbol-vector modifier. Bit 6 is the temporary DEFINED/mark bit.

The names and saved value words remain present. Only their current-definition
status is cleared. Locked symbols keep their special status and can remain
available as external constants or previously assembled interfaces.

For the running example, assume neither `START` nor `LOOP` is locked:

```text
before reset:
    START  value from any earlier assembly, DEFINED maybe set
    LOOP   value from any earlier assembly, DEFINED maybe set

after reset:
    START  record still exists, DEFINED clear
    LOOP   record still exists, DEFINED clear
```

The source records still refer to the same ordinals. Stable identity survives;
position-dependent meaning will be rebuilt.

## Installing the first-pass strategy

The controller patches its per-record call to point at
`firstPassProcessSourceRecord`:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

It also initializes the transition counter to 1. That one byte will lead the
controller through three states:

```text
1    first pass in progress
0    switch to second pass
$FF  both passes complete
```

At the beginning of the scan, both assembly pointers are initialized just above
the current source and symbol table. That is merely the default. The first
record immediately replaces them with `$8000`.

## Pass one, record 1: `ORG 32768`

The first record belongs to the pseudo-instruction namespace. Pass one reaches
the `ORG` handler, evaluates its encoded expression and sets both pointers:

```text
logicalAddress = $8000
outputPointer  = $8000
```

No byte is written.

The first pass must evaluate `ORG` now because the addresses of all following
labels depend on it. A forward reference in this expression would not be useful:
the assembler would need the later address to calculate the origin, while that
later address itself depends on the origin.

After record 1:

```text
START undefined
LOOP  undefined
logicalAddress = $8000
outputPointer  = $8000
```

## Pass one, record 2: `START LD B,5`

The record contains a line-label ordinal. Before accounting for the instruction,
`firstPassProcessSourceRecord` resolves that ordinal to the symbol vector and
record for `START`.

The normal line-label rule is:

```text
if symbol is locked or already defined:
    report a definition error
else:
    symbol.value = logicalAddress
    set symbol.DEFINED
```

The logical address is currently `$8000`, so:

```text
START = $8000
```

The instruction form has already been matched during editing. Pass one does not
evaluate the literal `5`; it only asks how many bytes this instruction form will
occupy.

For `LD B,n`, the instruction table supplies a base opcode and an operand
emission class. The class-length adjustment says that one immediate byte follows
the opcode:

```text
opcode bytes       1
immediate operand  1
total               2
```

The pointers advance:

```text
logicalAddress = $8002
outputPointer  = $8002
```

No output byte has yet been written. Pass one is measuring.

## Pass one, record 3: `LOOP DJNZ LOOP`

The label is defined first:

```text
LOOP = $8002
```

Then the instruction form is measured. `DJNZ expression` occupies two bytes:

```text
opcode        1
relative byte 1
total         2
```

The fact that the expression refers to `LOOP` does not need to be evaluated in
pass one. The instruction length is known from its form alone.

After the record:

```text
logicalAddress = $8004
outputPointer  = $8004
```

This is the classic benefit of a two-pass assembler. A branch expression can be
ignored until every ordinary line label has received its address.

In this particular line, `LOOP` happens to be defined before its own expression
would be evaluated anyway. The same mechanism also handles a branch to a label
that appears later in the source.

## Pass one, record 4: `RET`

`RET` has no prefix and no operand bytes. Its instruction-table record predicts
one byte.

```text
logicalAddress = $8005
outputPointer  = $8005
```

## Pass one, record 5: `ENT START`

Pass one ignores `ENT`. It does not emit bytes and it does not affect the address
map.

The expression is deliberately postponed until pass two, when all ordinary
labels are defined.

The final first-pass state is:

```text
START = $8000, DEFINED
LOOP  = $8002, DEFINED
logicalAddress = $8005
outputPointer  = $8005
```

The map is complete.

## The pass transition

At the end of the source scan, the transition counter changes from 1 to 0.
The controller patches the strategy call again:

```asm
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Then it restarts the same source traversal from the beginning.

The logical and physical pointers are again initialized to the default dynamic
end, and `ORG 32768` again replaces both with `$8000`. Running directives in both
passes ensures that pass two follows exactly the same address history as pass
one.

## Pass two, record 1: repeat the origin

`ORG 32768` is evaluated again:

```text
logicalAddress = $8000
outputPointer  = $8000
```

Still no byte is emitted.

## Pass two, record 2: emit `LD B,5`

The second-pass machine handler reads the record's prefix/opcode description and
emits the opcode for `LD B,n`:

```text
$06
```

It then evaluates the encoded expression `5`. The immediate-byte validator
accepts values whose high byte is `$00` or `$FF`, preserving the assembler's
compact byte semantics. Five is plainly valid.

The second byte is emitted:

```text
$05
```

Memory now contains:

```text
$8000  $06
$8001  $05
```

Each call to `emitByteAtAssemblyOutput` performs more than a store. It checks
that the current destination is not in protected resident/source/symbol space
and is below U-TOP. Only after the checks does it write the byte and advance both
assembly pointers.

After the instruction:

```text
logicalAddress = $8002
outputPointer  = $8002
```

## Pass two, record 3: calculate `DJNZ LOOP`

The opcode is emitted first:

```text
$10
```

The output and logical pointers now refer to the displacement byte at `$8003`.
For a relative branch, the processor interprets the signed displacement from the
address after the complete two-byte instruction.

PROMETHEUS therefore needs:

```text
target = value of LOOP = $8002
next instruction address = $8004

displacement = target - next instruction address
             = $8002 - $8004
             = -2
```

In an eight-bit two's-complement byte:

```text
-2 = $FE
```

The signed-byte validator accepts the range -128 through 127 and writes `$FE`.

The emitted memory is now:

```text
$8000  06 05     LD B,5
$8002  10 FE     DJNZ $8002
```

The pointers advance to `$8004`.

### Why the branch does not contain `$8002`

A beginning assembly programmer may expect the two bytes after `DJNZ` to contain
the destination address. But a Z80 relative branch has only one operand byte.
It stores a distance, not an address.

At runtime:

```text
fetch $10 at $8002
fetch $FE at $8003
program counter is now $8004
B = B - 1
if B != 0:
    PC = $8004 + signed($FE)
       = $8004 - 2
       = $8002
```

The assembler has converted the symbolic intention “go to LOOP” into the small
local motion the processor actually understands.

## Pass two, record 4: emit `RET`

`RET` is a simple one-byte instruction:

```text
$C9
```

The completed machine-code region is:

```text
Address  Hex bytes  Meaning
$8000    06 05      LD B,5
$8002    10 FE      DJNZ $8002
$8004    C9         RET
```

Both assembly pointers become `$8005`.

## Pass two, record 5: prepare RUN

`ENT START` evaluates `START`, obtaining `$8000`.

Instead of writing output bytes, it patches the operand of a resident call:

```asm
varcRunEntryCallTarget:
    call 00000h
```

After the directive, the three bytes of that instruction behave as:

```text
CD 00 80
```

The directive also decrements `varcRunEntDirectiveBalance`. Since the balance
started at 1 and this is the only `ENT`, it reaches zero.

That zero proves exactly one entry directive was present.

## Completion of the second pass

At the end of the second scan, the transition counter underflows from 0 to
`$FF`. The controller returns to `invokeAssembly`, which displays the assembly
complete message.

No third scan occurs.

The two-pass process can now be summarized as a table:

| Record | Pass one | Pass two |
|---|---|---|
| `ORG 32768` | set both pointers to `$8000` | set both pointers to `$8000` |
| `START LD B,5` | define `START`; add 2 | emit `06 05` |
| `LOOP DJNZ LOOP` | define `LOOP`; add 2 | emit `10 FE` |
| `RET` | add 1 | emit `C9` |
| `ENT START` | ignore | patch RUN target; decrement ENT balance |

## The symbol table after assembly

The symbol table still has its usual two-level structure:

```text
ordinal vectors
    1 -> physical record for START
    2 -> physical record for LOOP

alphabetical value/name records
    LOOP   value $8002
    START  value $8000
```

The vector order reflects stable ordinal identity. The physical record order is
alphabetical, so `LOOP` may appear before `START` even though `START` received the
lower ordinal.

Both vector entries have DEFINED set. Neither needs to store every place where
the symbol was used. The compressed source records continue to hold their
ordinals.

## What RUN does with the result

The `RUN` command invokes assembly first. It then checks the ENT balance.

For this program, the balance is zero, so RUN clears the display and executes
the patched call to `$8000`.

The processor performs:

```text
B = 5
repeat:
    B = B - 1
until B = 0
return
```

`RET` returns to the instruction after `varcRunEntryCallTarget`. PROMETHEUS can
then wait for a key and restore the editor display.

A generated program that never returns would keep control. PROMETHEUS does not
create a protective process boundary around an ordinary RUN. The more guarded
single-step machinery belongs to the monitor and will be explained much later.

## Reading the output back

The monitor's disassembler can later begin at `$8000` and reconstruct the three
instructions.

The same instruction table that helped the editor accept the source and the
second pass emit bytes now works in reverse:

```text
06 05 -> LD B,5
10 FE -> DJNZ $8002
C9    -> RET
```

If symbol-by-value lookup finds `LOOP=$8002`, the relative destination can be
rendered as `LOOP` rather than a number.

This closes a remarkable circle:

```text
human text
    -> compact source semantics
    -> instruction-table identity
    -> machine bytes
    -> instruction-table identity
    -> readable source text
```

The table is not merely a list of opcodes. It is a shared bridge between the
editor, assembler and monitor.

## In plain pseudocode

Here is the complete assembly of the example without register-level detail:

```text
symbols.clearDefinedOnUnlockedItems()

passOne:
    logical = dynamicEnd + 1
    output  = dynamicEnd + 1

    ORG 32768:
        logical = $8000
        output  = $8000

    START: LD B,5:
        define START = logical
        logical += 2
        output  += 2

    LOOP: DJNZ LOOP:
        define LOOP = logical
        logical += 2
        output  += 2

    RET:
        logical += 1
        output  += 1

    ENT START:
        no pass-one effect

passTwo:
    logical = dynamicEnd + 1
    output  = dynamicEnd + 1

    ORG 32768:
        logical = $8000
        output  = $8000

    LD B,5:
        emit $06
        emit $05

    DJNZ LOOP:
        emit $10
        displacement = LOOP - (logical + 2)
        require -128 <= displacement <= 127
        emit lowByte(displacement)       ; $FE

    RET:
        emit $C9

    ENT START:
        runCallTarget = START
        entBalance -= 1

require entBalance == 0 for RUN
```

## What has changed in memory

After successful assembly:

- the unlocked symbol vectors for `START` and `LOOP` have DEFINED set;
- their value words contain `$8000` and `$8002`;
- bytes `$06,$05,$10,$FE,$C9` occupy `$8000` through `$8004`;
- `varcAddressCounter` and `varcAssemblyOutputPointer` finish at `$8005`;
- the operand of `varcRunEntryCallTarget` contains `$8000`;
- `varcRunEntDirectiveBalance` has reached zero;
- the compressed source records themselves remain unchanged.

## Important labels encountered

- `processCompilation`
- `processSymbolTableItems`
- `varcAssemblyPassHandlerCall`
- `varcAssemblyPassTransitionCounter`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
- `emitMachineInstructionBytes`
- `emitByteAtAssemblyOutput`
- `validateAndEmitImmediateByte`
- `.validateSignedByteInHLAndEmitL`
- `varcRunEntryCallTarget`
- `varcRunEntDirectiveBalance`
- `invokeRun`

## Back to the bigger picture

Part III began with an assembler seen from above. It then descended through word
recognition, operands, expressions, symbols, the two passes and directives. We
can now return to the original top-level view with every major step filled in:

```text
five visible source lines
    -> five compact semantic records
    -> two stable symbol identities
    -> first-pass address map
    -> second-pass opcode and operand recipes
    -> five protected output bytes
    -> one patched RUN entry
```

The assembler section is complete at book level.

The next problem is persistence. Source records and symbols are valuable only if
they can survive power-off, move between sessions and be merged into another
program. Part IV follows them onto tape and back.
