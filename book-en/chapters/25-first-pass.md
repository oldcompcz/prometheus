# Chapter 25: The First Pass

An assembler eventually has to write bytes, but it cannot sensibly begin there.
Before a branch can be encoded, its destination must have an address. Before a
label can have an address, the assembler must know how many bytes came before
it. Before it can know that, it must understand the size of every instruction
and data directive encountered on the way.

This circular-looking problem is the reason for the first pass.

PROMETHEUS solves it in the traditional manner:

```text
pass one:  discover the map of the future program
pass two:  use that map to produce the future program
```

The first pass does not emit ordinary instruction bytes. Its main product is a
set of facts:

- the value of every line label;
- the value of every `EQU` symbol that can be calculated at that point;
- the logical address before and after every source record;
- the effect of `ORG`, `PUT` and storage directives;
- whether any name is defined twice;
- whether an address-control expression depends on a name that is not yet known.

Once those facts exist, pass two can evaluate forward references and write final
machine code.

This chapter follows the first pass from its top-level controller down to the
small byte-counting tricks inside `firstPassProcessSourceRecord`, then returns to
the complete source scan.

## The source is already parsed

The first pass does not read words such as `LD`, `LOOP` or `DEFW` from the edit
line. That work happened when the line was entered.

By the time assembly begins, each source record already contains:

- an opcode or pseudo-opcode;
- an information byte describing prefixes, label presence and operand class;
- an optional two-byte line-label ordinal;
- compact expression material where required.

This separation is important. Pass one can operate on a small semantic record
rather than repeatedly parsing human text.

For an ordinary instruction, it usually needs only the two header bytes to know
its eventual size. It does not need to evaluate the instruction's operand yet.

For example, the source:

```asm
        JR LOOP
```

already says, in compressed form:

```text
this is a JR-shaped machine instruction
its operand class is relative target
its expression refers to symbol ordinal N
```

Pass one knows that such an instruction occupies two bytes. It can advance the
address counter without knowing the current value of `LOOP`.

That is how ordinary forward references remain possible.

## Preparing the symbol world

The controller is `processCompilation`. Before scanning source, it clears the
DEFINED state from symbols:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

The byte `$B6` is the opcode for:

```asm
RES 6,(HL)
```

As Chapter 24 explained, `processSymbolTableItems` places this opcode into its
self-modified vector operation and applies it across the table.

Bit 6 is both the ordinary DEFINED state during assembly and the temporary mark
bit used by symbol compaction. Clearing it gives the new first pass a clean set
of source definitions.

Locked symbols retain bit 7. The expression evaluator accepts a symbol when
either bit 6 or bit 7 is set, so a locked value can still be used as an imported
constant or lower-layer address even though its ordinary DEFINED bit has just
been cleared.

Conceptually:

```text
for each symbol:
    symbol.defined = false
    symbol.locked remains unchanged
```

This makes each assembly a fresh definition scan without destroying deliberately
preserved external values.

## Whole source or selected block

The `ASSEMBLY` and `RUN` paths can assemble the whole source or only the selected
block. `processCompilation` first looks for the command parameter `B` and stores
a deliberately inverted mode byte:

```text
0 = selected block only
1 = whole source
```

The inversion is merely convenient for the branch used in the hot scan loop.
When whole-source mode is active, the per-record handler is reached directly.
When block mode is active, `testSourceRecordOutsideSelectedBlock` can skip a
record before either pass processes it.

The selected bounds are inclusive. The same membership test is used in both
passes, so pass two cannot accidentally emit a line that pass one omitted from
its address calculation.

There is a practical consequence: block assembly is a small independent
translation using whatever locked symbol values and definitions occur inside
the chosen block. It is not a promise that every reference to an unselected line
will somehow remain available.

## Installing the first-pass handler

PROMETHEUS does not have two copies of the source traversal loop. Instead, the
controller patches one `CALL` operand:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Later the same operand is changed to `secondPassEmitSourceRecord`.

The scan therefore has this shape:

```text
for each selected source record:
    CALL currentPassHandler
```

where `currentPassHandler` is initially pass one and later pass two.

This is a good example of PROMETHEUS using code as a small object. The `CALL`
instruction contains the current strategy.

## Where assembly begins

At the start of each pass, both working pointers are initialized to one byte
beyond the current source and symbol area:

```asm
.initializeAssemblyPass:
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
```

The two pointers have different meanings:

- `varcAddressCounter+1` is the **logical address** represented by labels and by
  the `$` atom;
- `varcAssemblyOutputPointer+1` is the **physical RAM destination** used when
  pass two writes bytes.

They begin equal, but directives can separate them.

`ORG` changes both. `PUT` changes only the physical pointer. Ordinary emission
advances both. `DEFS` advances both without writing.

Pass one must maintain this distinction even though it does not normally write
bytes. Otherwise the values assigned to later labels would disagree with what
pass two eventually emits.

## The scanner remembers the next record first

The source buffer is packed and several processing routines freely reuse `HL`
and `IX`. The controller therefore calculates the successor before invoking the
pass handler:

```asm
    push hl
    call getNextSourceRecord
    ld (varcNextAssemblyRecordPointer+1),hl
    pop ix
```

After this sequence:

- `IX` addresses the current record;
- the operand of `varcNextAssemblyRecordPointer` remembers its successor.

The handler may evaluate expressions, walk symbols or manipulate other
pointers. When it returns, the controller reloads the saved successor and
continues.

This is the same design principle seen throughout the program: preserve the
small piece of structural state that must survive a complex operation, then let
the operation use the working registers freely.

## Errors know which source line caused them

Immediately before a record is processed, its address is also stored in the
operand of `reportAssemblyErrorAtSourceRecord`:

```asm
    ld (reportAssemblyErrorAtSourceRecord+1),hl
```

Deep routines do not need to carry the source-record pointer through every
register exchange. If an error occurs, the common path loads the patched value,
places it in `varcSourceBufferActiveLine+1`, and returns to the editor with that
line highlighted.

Thus an error in expression evaluation, range checking or output protection can
still point to the right source record.

## Defining a line label

The first action of `firstPassProcessSourceRecord` is to test information bit 3:

```asm
firstPassProcessSourceRecord:
    bit 3,(ix+001h)
    jr z,.accountSourceRecordLength
```

If the bit is clear, the record has no line label and the routine can move
straight to size accounting.

If the bit is set, the two-byte ordinal after the record header is resolved to
its symbol vector and physical value/name record. The routine remembers that
entry for a possible `EQU`, then inspects the vector's two state bits:

```asm
    ld a,(hl)
    and 0c0h
    jr z,.defineLineLabelAtCurrentAddress
```

Both bits clear means the name is available for definition.

Either bit set means the name is already established:

- bit 6: it was defined earlier in this first pass;
- bit 7: it is locked and therefore not available for redefinition.

The error is `Already defined`, and the current record is highlighted.

For a new label, pass one:

1. sets bit 6 in its vector;
2. reads the current logical address;
3. writes that address into the two-byte value immediately before the symbol
   name.

In plain terms:

```text
if line has label:
    symbol = resolve(line.labelOrdinal)
    if symbol.defined or symbol.locked:
        error "Already defined"
    symbol.defined = true
    symbol.value = logicalAddress
```

At this moment a normal line label is complete. The rest of the record only
determines how far the address counter moves afterwards.

## `EQU` first defines, then replaces

An `EQU` line uses the same label-definition entrance. Its label is initially
marked DEFINED and receives the current address just like any other line label.
The pseudo-instruction branch then evaluates the `EQU` expression and overwrites
that temporary value.

The intermediate current-address value is not normally visible. Reusing the
common label path avoids a second definition-state mechanism.

The important limitation is the evaluation time. `EQU` is calculated during
pass one, so every symbol used in its expression must already be:

- defined by an earlier selected source record; or
- retained as a locked symbol.

A later ordinary label cannot be used by an earlier `EQU`.

For example:

```asm
SIZE    EQU END-START
START   DEFS 10
END
```

cannot work in that order because `END` and `START` are not yet both defined
when `SIZE` is evaluated. Reordering the `EQU` after the labels, or locking the
required values from an earlier layer, solves the problem.

This is not a general failure of forward references. It is a consequence of
asking pass one to know a value immediately.

## Predicting an ordinary instruction's size

For a machine instruction, pass one does not search the instruction table again.
The compressed record already contains the final opcode and information byte.
The low three information bits select an operand-emission class:

```text
class 0  opcode only
class 1  opcode + one byte
class 2  opcode + word
class 3  opcode + relative byte
class 4  opcode + index displacement
class 5  opcode + index displacement + immediate byte
class 6  RST opcode with vector folded into it
```

The prefix-family bits say whether DD, FD, CB or ED bytes are also required.

PROMETHEUS packs the base instruction lengths into an unusually economical
sequence:

```asm
operandClassLengthAdjustments:
    nop
    ld bc,00102h
    ld bc,00002h
    nop
```

These instructions are not executed as a subroutine. Their bytes form the lookup
values:

```text
class:       0  1  2  3  4  5  6
stored byte: 0  1  2  1  1  2  0
plus one:    1  2  3  2  2  3  1
```

The final row is the size of opcode plus operand material before prefixes are
counted.

The code then shifts the information byte four times. Each selected prefix bit
falls into carry, and `ADC A,0` adds that carry to the length.

In pseudocode:

```text
length = baseLengthByOperandClass[class]
for prefix in [DD, FD, CB, ED]:
    if record requests prefix:
        length += 1
logicalAddress += length
```

This tiny mechanism predicts the length of the already-recognized instruction
without decoding its expression or writing any byte.

## Why relative branches need no special first-pass calculation

A relative branch such as:

```asm
        JR LOOP
```

stores an absolute target expression in its source record, but pass one treats
it simply as operand class 3 and adds two bytes.

The signed displacement is not calculated yet.

That calculation depends on final addresses and belongs in pass two:

```text
displacement = target - addressAfterInstruction
```

By postponing it, pass one allows `LOOP` to appear later. It needs only the fact
that a relative branch has a one-byte operand.

## First-pass treatment of pseudo-instructions

Pseudo-opcodes occupy a separate namespace. After an optional line-label ordinal
is skipped, the first pass dispatches by the pseudo-opcode byte.

The broad behavior is:

| Directive | First-pass action |
|---|---|
| empty/comment | none |
| `ENT` | none |
| `EQU` | evaluate now and assign label value |
| `ORG` | evaluate now; set logical and physical pointers |
| `PUT` | evaluate now; set physical pointer only |
| `DEFB` | count items; add one byte per item |
| `DEFM` | scan string; add one byte per logical character |
| `DEFS` | evaluate count(s); advance logical and physical pointers |
| `DEFW` | count items; add two bytes per item |

This table explains the forward-reference rules.

`DEFB` and `DEFW` do not need their values in pass one. They only need the number
of comma-separated expressions, so their expressions may refer forward.

`DEFM` only needs to count decoded characters, including doubled quote handling.

`ENT` is deferred entirely to pass two, when all ordinary labels have been
defined.

By contrast, `ORG`, `PUT`, `DEFS` and `EQU` must know their values immediately
because those values affect the map being constructed.

## Counting definition items without evaluating them

`countCommaSeparatedDefinitionItems` walks encoded definition material and
counts separators. It understands enough of the compressed representation not
to be fooled by:

- commas that divide items;
- quoted strings that may contain ordinary bytes;
- two-byte tagged symbol ordinals;
- the `$C0+n` terminal marker.

It is not an expression evaluator. It is a structural scanner.

For:

```asm
        DEFB 1,VALUE,3
```

pass one obtains three items and advances the logical address by three.

For `DEFW`, it doubles the count.

This is faster and more permissive than evaluating expressions prematurely.

## Counting `DEFM` the same way it will be emitted

The first and second passes share `scanNextDefmCharacter`.

That helper understands:

- the opening and closing delimiter;
- doubled double quotes representing one literal double quote;
- the source-record terminal marker;
- the final-character condition;
- apostrophe-delimited strings, whose last emitted byte receives bit 7 in pass
  two.

Pass one repeatedly calls the scanner and counts logical characters. Pass two
uses the same scanner and emits those characters.

Sharing the decoder prevents the two passes from disagreeing about the length of
a string containing an escaped quote.

## `DEFS` is more than a length count

`DEFS` reserves storage by moving both pointers without writing. Because its
expression determines the location of every following label, it must be
evaluated during pass one.

The implementation accepts a comma-separated sequence even though the usual
form is one count:

```asm
        DEFS 16
```

For every encoded expression it:

1. evaluates the value into `BC`;
2. adds it to `varcAddressCounter+1`;
3. adds it to `varcAssemblyOutputPointer+1`;
4. continues if another comma-separated expression follows.

Pass two repeats the same pointer movement. No memory is filled or cleared.
`DEFS` merely leaves a hole in the output address space.

Because no byte is emitted, output protection is not tested at the moment of the
reservation. A later actual emission catches an illegal destination if the
pointer now lies in protected memory.

## `ORG` and `PUT` must be replayed in both passes

At the start of pass two, the controller resets both pointers to their original
post-source value. Therefore address-control directives must execute again in
pass two.

This is deliberate. Each pass begins from the same initial state and interprets
the same source sequence.

```text
pass one starts at default base
    ORG/PUT/DEFS modify its map

pass two starts at default base again
    the same ORG/PUT/DEFS reproduce that map while bytes are emitted
```

If pass two simply inherited the final pointers from pass one, it would begin at
the end of the program rather than at its start.

## Completing the scan and changing passes

When the source pointer reaches the dynamic source end,
`varcAssemblyPassTransitionCounter` controls the transition:

```text
initial value 1
end of pass one: decrement to 0, install pass-two handler, restart
end of pass two: decrement to $FF, return
```

The code is compact:

```asm
varcAssemblyPassTransitionCounter:
    ld a,000h
    dec a
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
    jr z,.initializeAssemblyPass
    ret
```

The pass-two handler is written even after pass two, but the zero test is false
when the counter becomes `$FF`, so assembly returns instead of starting a third
scan.

## A small first-pass journey

Consider:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

The first pass begins with both pointers just above source and symbols.

Then:

1. `ORG 32768` sets both pointers to `$8000`.
2. `START` is defined as `$8000`; `LD B,5` has length 2; address becomes `$8002`.
3. `LOOP` is defined as `$8002`; `DJNZ LOOP` has length 2; address becomes `$8004`.
4. `RET` has length 1; address becomes `$8005`.
5. `ENT START` has no first-pass length or evaluation action.

The map now exists:

```text
START = $8000
LOOP  = $8002
program end logical address = $8005
```

No machine-code byte has yet been written by the ordinary instruction paths.

## In plain pseudocode

The controller:

```text
function compile(scope):
    clearDefinedBitOnAllSymbols()

    passState = 1
    currentHandler = firstPass

    repeat:
        logicalAddress = codeEnd + 1
        outputPointer = codeEnd + 1
        record = firstSourceRecord

        while record is before sourceEnd:
            nextRecord = record.next
            remember record for error reporting

            if scope is wholeSource or record is inside selectedBlock:
                currentHandler(record)

            record = nextRecord

        passState -= 1
        currentHandler = secondPass

    until passState != 0
```

The first-pass handler:

```text
function firstPass(record):
    if record has line label:
        symbol = resolve(record.lineLabelOrdinal)
        if symbol.defined or symbol.locked:
            errorAt(record, "Already defined")
        symbol.defined = true
        symbol.value = logicalAddress
        remember symbol as possible EQU destination

    if record is machine instruction:
        logicalAddress += sizeFromInformationByte(record.info)
        return

    switch record.pseudoOpcode:
        case empty, comment, ENT:
            return

        case EQU:
            rememberedLineLabel.value = evaluate(record.expression)

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            logicalAddress += countItems(record)

        case DEFM:
            logicalAddress += countDecodedCharacters(record)

        case DEFS:
            for each expression in record:
                count = evaluate(expression)
                logicalAddress += count
                outputPointer += count

        case DEFW:
            logicalAddress += 2 * countItems(record)
```

## What has changed in memory

After a successful first pass:

- every selected ordinary line label has bit 6 set;
- each such label's value word contains its logical address;
- every selected `EQU` label contains its evaluated value;
- locked symbols still carry bit 7 and keep their values;
- `varcAddressCounter+1` contains the final logical address reached by the pass;
- `varcAssemblyOutputPointer+1` contains the final physical position implied by
  `ORG`, `PUT` and `DEFS`;
- no ordinary instruction or data byte has yet been emitted by the pass-one
  paths;
- the per-record dispatch target has been changed to
  `secondPassEmitSourceRecord`;
- the source pointer is ready to restart from the beginning.

## Important labels encountered

- `processCompilation`
- `varcCompileWholeSource`
- `varcAssemblyPassHandlerCall`
- `varcNextAssemblyRecordPointer`
- `varcAssemblyPassTransitionCounter`
- `reportAssemblyErrorAtSourceRecord`
- `firstPassProcessSourceRecord`
- `varcCurrentLineLabelEntry`
- `operandClassLengthAdjustments`
- `skipEncodedLineLabelIfPresent`
- `setOrgAddressAndOutputPointer`
- `setOutputPointerFromBC`
- `advancePointersForDefsExpressions`
- `countCommaSeparatedDefinitionItems`
- `scanNextDefmCharacter`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`

## Back to the bigger picture

Pass one has changed symbolic source into a complete address map, but the program
still does not exist as bytes.

The important result is not merely a final size. It is agreement among many
small facts:

```text
labels have values
instruction lengths are known
ORG and PUT have shaped the address spaces
storage reservations have moved later labels
forward ordinary operands can now be resolved
```

Chapter 26 replays the same source from the same initial state. This time the
handler does not predict. It emits prefixes, opcodes, immediate values, words,
relative displacements and data, checking every physical destination as it
goes.
