# Chapter 26: The Second Pass

At the beginning of the second pass, PROMETHEUS deliberately forgets where the
first pass ended.

The logical address and physical output pointer are reset to their common
default just above source and symbols. The source scan returns to its first
record. `ORG`, `PUT` and `DEFS` will be interpreted again.

What does *not* disappear is the address map built in pass one. Selected labels
now carry DEFINED bit 6 and have final values in their symbol records.

The second pass therefore sees the same source under different conditions:

```text
same records
same order
same starting pointers
same address-control directives
but now every normal label value is available
```

Its job is to turn that stable meaning into bytes.

## One handler for machine and pseudo records

`secondPassEmitSourceRecord` begins with the record information byte:

```asm
secondPassEmitSourceRecord:
    ld b,(ix+001h)
    ld a,b
    and 030h
    cp 030h
    jr z,.executePseudoInstructionSecondPass
```

In ordinary machine records, bits 5 and 4 describe DD and FD prefix families.
The combination `$30` is reserved as the pseudo-instruction namespace, so it is
a fast discriminator:

```text
DD and FD both marked → interpret byte 0 as pseudo-opcode
otherwise             → emit a machine instruction
```

The parser guaranteed that the record was valid when it was entered. Pass two
can therefore concentrate on encoding, not on spelling or grammar.

## The common instruction emitter

For a normal instruction, `emitMachineInstructionBytes` writes components in a
fixed order:

```text
optional DD
optional FD
optional CB
optional ED
stored opcode
operand bytes selected by class
```

The source fragment is direct:

```asm
emitMachineInstructionBytes:
    ld a,0ddh
    bit 5,b
    call nz,emitByteAtAssemblyOutput
    ld a,0fdh
    bit 4,b
    call nz,emitByteAtAssemblyOutput
    ld a,0cbh
    bit 7,b
    call nz,emitByteAtAssemblyOutput
    ld a,0edh
    bit 6,b
    call nz,emitByteAtAssemblyOutput
    ld a,(ix+000h)
    call emitByteAtAssemblyOutput
```

Only valid combinations exist in correctly encoded source. The emitter does not
need a large tree saying which mnemonics permit which prefix. That decision was
captured in the instruction-table record during source entry.

Every prefix and opcode goes through the same protected byte writer. This means
an instruction that crosses an illegal boundary is rejected at the exact byte
where it becomes unsafe.

## Skipping the line label

The optional line-label ordinal is part of the persistent record payload, but it
is not an operand. Before expression evaluation, the emitter calls:

```asm
    call skipEncodedLineLabelIfPresent
```

If information bit 3 is set, `IX` advances two bytes. Otherwise it remains at the
record header.

The expression evaluator always reads its first byte at `IX+2`, so this small
adjustment gives it a uniform view:

```text
IX+2 = first operand byte
```

whether or not the source line also defined a label.

## Operand classes are emission recipes

The low three information bits select one of seven recipes:

| Class | Meaning | Bytes after opcode |
|---|---|---|
| 0 | no operand | none |
| 1 | immediate byte | one checked byte |
| 2 | absolute word | low byte, high byte |
| 3 | relative target | calculated signed displacement |
| 4 | IX/IY displacement | one signed byte |
| 5 | IX/IY displacement plus immediate | signed byte, checked byte |
| 6 | RST vector | folded into opcode already emitted |

The class is not the same thing as the textual operand category from Chapter 21.
It is the final byte-emission behavior stored in the source record.

For any nonzero class, the encoded expression is evaluated into `BC`. The class
then decides how that value is represented.

## Class 1: PROMETHEUS's broad byte rule

A one-byte value is accepted when the high byte is either `$00` or `$FF`:

```asm
validateAndEmitImmediateByte:
    ld a,b
    inc a
    and 0feh
    jr nz,.reportAssemblyBigNumber
    ld a,c
```

This accepts:

```text
$0000..$00FF
$FF00..$FFFF
```

and emits the low byte.

The second range represents negative values from -256 through -1 in sixteen-bit
two's-complement form. It is broader than the usual signed-byte range. Thus both
of these can produce `$FF`:

```asm
        DEFB 255
        DEFB -1
```

but a value such as `$0100` is rejected as `Big number`.

The test is compact: after incrementing the high byte, masking with `$FE` leaves
zero only for original values `$00` and `$FF`.

## Class 2: little-endian words

A word in `BC` is emitted low byte first:

```asm
emitWordBCAtAssemblyOutput:
    ld a,c
    call emitByteAtAssemblyOutput
    ld a,b
    jr emitByteAtAssemblyOutput
```

This is standard Z80 little-endian order.

For:

```asm
        LD HL,$1234
```

an appropriate instruction record emits:

```text
21 34 12
```

The opcode came first. The operand word follows as low `$34`, high `$12`.

The same helper is used by `DEFW`, so instruction operands and explicit word data
obey exactly the same byte order and output protection.

## Class 3: an absolute expression becomes a relative byte

Source records keep a relative branch destination as an absolute expression.
Pass two converts it after prefixes and opcode have already advanced the logical
address counter.

The required formula is:

```text
displacement = target - addressAfterCompleteInstruction
```

At the class-3 branch, the logical counter points just after the opcode. The code
increments a temporary copy once more to include the displacement byte, then
subtracts that completed program counter from the target.

The implementation uses an elegant stack exchange to rearrange the values:

```asm
    ld hl,(varcAddressCounter+1)
    inc hl
    push bc
    ex (sp),hl
    pop bc
    and a
    sbc hl,bc
```

After the exchange and pop, `HL` holds the target and `BC` holds the address after
the complete instruction. `SBC HL,BC` produces the signed difference.

The result is valid only in:

```text
-128..127
```

or, as sixteen-bit bit patterns:

```text
$FF80..$FFFF or $0000..$007F
```

Anything else raises `Big number`.

For the running example:

```asm
LOOP    DJNZ LOOP
```

suppose `LOOP` is `$8002`. After emitting opcode `$10`, the logical counter is
`$8003`. Adding the displacement byte gives `$8004`:

```text
$8002 - $8004 = -2 = $FE
```

The emitted instruction is:

```text
10 FE
```

## Class 4: signed index displacement

An expression in `(IX+d)` or `(IY+d)` is evaluated as a sixteen-bit value, moved
into `HL`, and checked by the same signed-byte validator used for relative
branches.

Valid values are -128 through 127. The low byte is emitted.

The source may write:

```asm
        LD A,(IX-3)
```

The expression evaluator returns `$FFFD`; the signed validator accepts it and
emits `$FD`.

This reuse is possible because both relative branches and indexed addressing
need exactly the same final signed-byte range, even though their values are
calculated differently.

## Class 5: displacement and immediate byte

Some indexed forms require two expressions, for example:

```asm
        LD (IX+5),17
```

The encoded source record stores them separated by the internal expression
separator introduced in Chapter 13.

The emitter:

1. validates and writes the signed displacement;
2. advances `IX` to the next encoded expression;
3. evaluates the immediate;
4. validates it with the broad one-byte rule;
5. emits it.

The instruction becomes:

```text
DD 36 05 11
```

where `$11` is decimal 17.

## Class 6: folding an RST vector into the opcode

`RST` is unusual because its apparent operand is encoded in the opcode itself.
The allowed vectors are:

```text
0, 8, 16, 24, 32, 40, 48, 56
```

PROMETHEUS first emits the base opcode from the instruction table. It then
validates the expression:

- high byte must be zero;
- low three bits must be zero;
- bits 6 and 7 must be zero.

If valid, the vector value is added to the byte just emitted:

```asm
    ld hl,(varcAssemblyOutputPointer+1)
    dec hl
    add a,(hl)
    ld (hl),a
```

No second output byte is required. The emitter edits its own most recent result.

An invalid vector is reported as `Bad instruction`, not `Big number`, because the
problem is that the requested RST form does not exist.

## The indexed CB byte-order problem

Most instructions fit the common order:

```text
prefixes, opcode, operand bytes
```

Indexed rotate and bit instructions do not. Z80 encodes them as:

```text
DD/FD, CB, displacement, operation opcode
```

But the common record structure naturally emits:

```text
DD/FD, CB, operation opcode, displacement
```

PROMETHEUS avoids a separate full emitter. `secondPassEmitSourceRecord` recognizes
the indexed-CB family from the information bits, calls the common emitter, then
swaps the final two bytes in memory:

```asm
    call emitMachineInstructionBytes
    ld hl,(varcAssemblyOutputPointer+1)
    dec hl
    ld a,(hl)
    dec hl
    ld b,(hl)
    ld (hl),a
    inc hl
    ld (hl),b
```

For example, the temporary common order:

```text
DD CB 46 05
```

is corrected to:

```text
DD CB 05 46
```

This tiny repair handles an awkward Z80 encoding while preserving one general
emission path for almost everything else.

## The protected byte writer

Every actual generated byte passes through `emitByteAtAssemblyOutput`.

This routine owns two pieces of state stored in instruction operands:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h

varcAddressCounter:
    ld hl,00000h
```

Before writing, it checks the physical destination against three boundaries.
Generated output is allowed when it is:

1. below the relocated resident PROMETHEUS image; or
2. strictly above the current resident/source/symbol end;
3. and not above U-TOP.

It is rejected when it would overwrite:

- the resident application;
- compressed source;
- the symbol table;
- the protected upper region.

The check is performed per byte. An instruction beginning in a legal location
but crossing into protected memory fails on the first forbidden byte.

On success:

```text
memory[outputPointer] = byte
outputPointer += 1
logicalAddress += 1
```

The logical counter advances even when `PUT` has made the physical destination
different from the logical address.

## Logical address and physical destination

This distinction is easiest to see with an example:

```asm
        ORG 40000
        PUT 50000
START   LD HL,START
```

After `ORG`:

```text
logicalAddress = 40000
outputPointer  = 40000
```

After `PUT`:

```text
logicalAddress = 40000
outputPointer  = 50000
```

`START` is defined as 40000. The `LD HL,START` bytes are physically written at
50000, but its operand contains 40000.

After the three-byte instruction:

```text
logicalAddress = 40003
outputPointer  = 50003
```

`PUT` therefore permits code to be assembled for one address while stored at
another. It is powerful, but the program does not automatically copy that code
to its logical address later. The user must have a reason for creating the
separation.

## Why output protection belongs to the byte writer

PROMETHEUS could have checked an instruction's entire range before emission, but
that would require every caller to calculate its size and repeat the same
boundary logic.

Instead, one routine is the gatekeeper.

This gives several benefits:

- prefixes and opcodes are checked;
- immediate bytes are checked;
- `DEFB`, `DEFM` and `DEFW` data are checked;
- monitor patch assembly is checked;
- a crossing boundary is caught even in the middle of an item;
- all illegal destinations report the same `Bad PUT (ORG)` error.

The design is slower than unchecked stores, but assembly is an interactive task,
not a real-time inner loop. Safety and compactness matter more.

## Errors return to the original source record

If byte range validation, relative range validation or output protection fails,
the error path ultimately reaches `reportAssemblyErrorAtSourceRecord`.

The controller patched that routine with the current record before invoking the
handler. The editor can therefore redisplay the exact failing line.

Examples include:

- an immediate too large for its class;
- a relative target farther than 127 bytes forward or 128 bytes backward;
- an indexed displacement outside -128..127;
- an invalid RST vector;
- an output pointer inside PROMETHEUS or above U-TOP;
- an unresolved symbol encountered by the expression evaluator.

The deep emitter need not know anything about the source window. It only selects
an error number.

## The one-line monitor assembler reuses the same machinery

The monitor's interactive assembler does not have a separate instruction
encoder.

It turns one entered line into the ordinary compressed record form, then calls:

```asm
    call initializeMonitorLineAssembler
    call firstPassProcessSourceRecord
    call initializeMonitorLineAssembler
    call secondPassEmitSourceRecord
```

The first initialization supplies the monitor address as logical and physical
origin. Pass one defines any line label or `EQU` state and predicts size. The
second initialization resets to the same origin, and the normal second-pass
emitter writes bytes through the same protection gate.

Thus improvements or corrections in the central assembler also apply to the
monitor's one-line assembly function.

## Following the running example

After Chapter 25, the symbol map is:

```text
START = $8000
LOOP  = $8002
```

Pass two replays:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

The steps are:

1. `ORG 32768` sets both pointers to `$8000`.
2. `LD B,5` emits `$06,$05`; pointers become `$8002`.
3. `DJNZ LOOP` emits `$10`; calculates `$8002-$8004=-2`; emits `$FE`; pointers
   become `$8004`.
4. `RET` emits `$C9`; pointers become `$8005`.
5. `ENT START` evaluates `$8000` and stores it as the RUN target.

The final bytes are:

```text
address  bytes     source
$8000    06 05     LD B,5
$8002    10 FE     DJNZ LOOP
$8004    C9        RET
```

The predictions from pass one and the physical effects of pass two agree.

## In plain pseudocode

```text
function secondPass(record):
    if record is pseudoInstruction:
        executePseudoInstructionSecondPass(record)
        return

    info = record.info

    if info requests DD: emitByte($DD)
    if info requests FD: emitByte($FD)
    if info requests CB: emitByte($CB)
    if info requests ED: emitByte($ED)

    emitByte(record.opcode)
    skipOptionalLineLabel(record)

    class = info.operandEmissionClass
    if class == 0:
        return

    value = evaluate(record.firstExpression)

    switch class:
        case 1:
            emitCheckedBroadByte(value)

        case 2:
            emitByte(low(value))
            emitByte(high(value))

        case 3:
            displacement = value - (logicalAddress + 1)
            emitCheckedSignedByte(displacement)

        case 4:
            emitCheckedSignedByte(value)

        case 5:
            emitCheckedSignedByte(value)
            immediate = evaluate(record.secondExpression)
            emitCheckedBroadByte(immediate)

        case 6:
            require value in {0,8,16,24,32,40,48,56}
            mostRecentlyEmittedOpcode += value

    if instruction is indexedCBFamily:
        swap lastTwoEmittedBytes()
```

The common byte writer:

```text
function emitByte(value):
    destination = outputPointer

    if destination is not below residentStart:
        if destination <= codeEnd:
            error "Bad PUT (ORG)"

    if destination > UTop:
        error "Bad PUT (ORG)"

    memory[destination] = low(value)
    outputPointer += 1
    logicalAddress += 1
```

## What has changed in memory

After a successful second pass:

- generated instructions and data occupy their selected physical output ranges;
- `varcAssemblyOutputPointer+1` points just after the final physical output;
- `varcAddressCounter+1` contains the final logical address;
- relative and indexed displacements have been range checked and encoded;
- word values have been written little-endian;
- indexed-CB forms have had their final byte order corrected;
- `ENT`, if present, has patched the RUN target;
- the symbol table still contains the values established by pass one;
- the original compressed source remains unchanged.

## Important labels encountered

- `secondPassEmitSourceRecord`
- `.executePseudoInstructionSecondPass`
- `emitMachineInstructionBytes`
- `validateAndEmitImmediateByte`
- `emitWordBCAtAssemblyOutput`
- `.validateSignedByteInHLAndEmitL`
- `validateAndEmitSignedBC`
- `.foldRstVectorIntoEmittedOpcode`
- `emitByteAtAssemblyOutput`
- `varcAssemblyOutputPointer`
- `varcAddressCounter`
- `varcUTop`
- `reportAssemblyErrorAtSourceRecord`
- `assembleMonitorInputLine`
- `initializeMonitorLineAssembler`

## Back to the bigger picture

The two passes now form a matched pair:

```text
pass one asks: how much space and what addresses?
pass two asks: which exact bytes and where may they be written?
```

The same compact record supports both questions. The first pass reads its shape;
the second pass realizes its content.

Machine instructions are only half of an assembler's language, however.
Programs also need to choose origins, reserve space, define constants, place
literal bytes and select an entry point. Chapter 27 gathers those
pseudo-instructions into one coherent system and shows how each one participates
in one or both passes.
