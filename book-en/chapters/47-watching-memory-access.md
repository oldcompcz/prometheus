# Chapter 47: Watching Memory Access

A monitor that can single-step machine code has an awkward responsibility.

It must allow the user's instruction to operate on real memory, because that is
what makes the result authentic. But it should not casually allow a traced
instruction to overwrite PROMETHEUS, read a protected secret area, or transfer
control into a forbidden region.

PROMETHEUS does not simulate each load, store, push, pop, call, return, and block
move. Instead, it predicts the memory addresses that the instruction is about to
touch. If those addresses are allowed, the real Z80 performs the operation in
scratch RAM with the user's real registers.

This chapter explains that prediction layer.

## Trusted commands and traced instructions are different

Chapter 38 introduced five kinds of protection window:

- DEFB display areas;
- DEFW display areas;
- READ-protected areas;
- WRITE-protected areas;
- RUN-protected areas.

The first two affect disassembly. The last three are chiefly policies for the
instruction-stepping engine.

This distinction matters. Trusted monitor commands such as MOVE and FILL use
simpler resident-memory checks and do not consistently honor the configurable
READ and WRITE windows. A user instruction executed through the trace engine
passes through the detailed descriptor machinery described here.

The monitor treats itself as trusted. It treats the program being observed as
potentially dangerous.

## The pre-execution gate

After decoding but before building or running the scratch instruction,
`stepInstructionAtHL` calls:

```asm
call validateInstructionBeforeExecution
```

This routine performs two conceptually separate jobs:

1. reject a `HALT` that could never resume;
2. when instruction controls are enabled, predict READ and WRITE effects.

RUN protection is checked later, after state capture. We will return to that
surprising difference.

## HALT while interrupts are disabled

`HALT` waits until an interrupt occurs. If the saved user state says interrupts
are disabled, executing HALT inside the scratch program could trap the monitor
forever.

PROMETHEUS recognizes exact unprefixed HALT before considering the controls
switch:

```asm
validateInstructionBeforeExecution:
    ld a,b
    sub 076h
    or c
    jr nz,.enforceInstructionMemoryControls
    ld a,(varcInterruptEnableState+1)
    or a
    ret nz
    ld a,0cfh
    jp showMonitorOperationError
```

The test combines:

```text
opcode B == $76
prefix/class C == 0
```

If the saved state is EI, the instruction is allowed. If it is DI, the monitor
shows `Interrupt ERROR`.

This check remains active even when ordinary READ, WRITE, and RUN controls are
switched off. It is not merely a protection preference; it is a guard against a
step that may never return.

## The inverse controls switch

The status command toggles a self-modified immediate:

```asm
varcInstructionControlsDisabled:
    ld a,000h
    or a
    ret nz
```

The meaning is inverted:

```text
0       controls enabled
nonzero controls disabled
```

Zero is convenient because the normal protected path simply falls through.
Turning controls off causes an early return before any descriptor search.

Even with controls off:

- invalid opcodes are still rejected by the decoder;
- HALT under DI is still rejected;
- control-flow rewriting still returns the instruction to the monitor;
- ordinary stepping still captures registers and PC.

Only configurable READ, WRITE, and RUN window checks are bypassed.

## Predicting effects instead of emulating instructions

Consider these instructions:

```asm
LD A,(HL)
LD (IX+5),B
PUSH DE
POP BC
LD ($9000),HL
CALL $8120
```

The monitor does not need to know the value loaded or stored. The real Z80 will
handle that.

For protection it needs only:

```text
kind of access: READ or WRITE
first address
width: one byte or two bytes
```

Examples:

```text
LD A,(HL)       READ  saved HL, one byte
LD (IX+5),B     WRITE saved IX + signed 5, one byte
PUSH DE         WRITE saved SP - 2, two bytes
POP BC          READ  saved SP, two bytes
LD ($9000),HL   WRITE $9000, two bytes
CALL $8120      WRITE saved SP - 2, two bytes
```

A compact table is enough to connect opcode shapes to these address recipes.

## The READ and WRITE descriptor tables

`readAccessDescriptorTable` and `writeAccessDescriptorTable` use the same row
format as the control-flow table:

```text
count
repeated rows:
    opcode mask
    expected masked opcode
    packed descriptor
```

A row matches when:

```text
(B AND opcodeMask) == expectedOpcode
AND
row prefix class == decoded prefix class from C
```

The packed descriptor contains:

```text
high nibble  decoder/prefix class
bit 3        access spans two bytes
bits 0..2    effective-address recipe
```

The matching routine returns carry set when no row describes that instruction.
No match is not an error. It simply means the instruction has no protected memory
access of that kind.

An instruction may match one READ row, one WRITE row, both, or neither.

For example, a block transfer reads from one range and writes another. Stack
operations may read or write two bytes. A register-only `ADD A,B` matches no
memory descriptor at all.

## One matching routine serves three tables

The source calls the routine `matchInstructionAccessDescriptor`, but it is also
used for control flow. Its operation is general:

```asm
matchInstructionAccessDescriptor:
    ld a,c
    and 0f0h
    ld c,a
    ld d,(hl)               ; row count
    inc hl
.scanNextInstructionAccessDescriptor:
    ld a,b
    and (hl)                ; opcode mask
    inc hl
    cp (hl)                 ; expected value
    inc hl
    jr z,.returnInstructionAccessDescriptor
    ...
```

When the opcode matches, the routine compares the descriptor's high nibble with
the decoded class. On success it returns the low nibble, using the zero flag to
remember whether bit 3 had been present.

This is compact but not immediately obvious:

```text
A after return = address-recipe index 0..7
Z after return = one-byte access
NZ after return = two-byte access
carry          = no row matched
```

The flags form part of the routine contract. The caller must understand them just
as clearly as a returned register value.

## Eight ways to obtain an effective address

The low three descriptor bits select one of eight small accessor routines:

```text
0  saved BC
1  saved DE
2  saved HL
3  saved IX + signed displacement
4  saved IY + signed displacement
5  saved SP
6  saved SP - 2
7  decoded immediate word NN
```

The selection table is another sequence of opcode-shaped offsets:

```asm
effectiveAddressAccessorOffsets:
    nop
    inc b
    ex af,af'
    inc c
    ld de,0211dh
    daa
```

Read as data, those bytes point into the contiguous accessor routines beginning
at `loadEffectiveAddressFromBC`.

### Saved register pairs

The first three accessors simply load a word from the saved user image:

```asm
loadEffectiveAddressFromBC:
    ld hl,(savedRegisterBC)
    ret
    ld hl,(savedRegisterDE)
    ret
    ld hl,(savedRegisterD+1)    ; saved HL
    ret
```

The odd-looking `savedRegisterD+1` is the address of the saved H byte and thus
the beginning of the little-endian HL word in the packed processor image.

### Indexed addresses

For IX or IY addressing, the decoded displacement is in E. It must be treated as
a signed byte:

```asm
bit 7,e
ld d,000h
jr z,.applySignedDisplacementToEffectiveAddress
dec d
.applySignedDisplacementToEffectiveAddress:
add hl,de
```

Thus:

```text
E=$05 -> DE=$0005
E=$FB -> DE=$FFFB = -5
```

The access address becomes saved IX or IY plus that signed value.

### Stack addresses

Two stack recipes are needed:

```text
SP      for POP, RET, and other reads from top of stack
SP - 2  for PUSH, CALL, and other writes below current top
```

The monitor predicts the address before the real Z80 changes SP.

### Immediate address

Instructions containing `(NN)` use the raw operand saved by the decoder:

```asm
varcDecodedInstructionOperandWord:
    ld hl,00000h
    ret
```

The decoder rewrites the immediate in this tiny `LD HL,nn / RET` accessor before
the step begins.

## Checking one byte or two

After selecting an effective address, `validateMatchedMemoryAccess` checks it
against the chosen READ or WRITE table:

```asm
call checkAddressAgainstProtectionTable
jp c,showMonitorReadWriteError
```

If the descriptor marks a one-byte access, that is enough.

For a word access, the monitor increments the address and checks again:

```asm
inc de
call checkAddressAgainstProtectionTable
jp c,showMonitorReadWriteError
```

Checking the bytes separately handles every boundary correctly, including
sixteen-bit wraparound:

```text
first byte  $FFFF
second byte $0000
```

A two-byte access is rejected if either byte lies in a protected range.

This is more precise than checking only the starting address.

## READ before WRITE

The generic path first searches the READ table, then the WRITE table:

```asm
ld hl,readAccessDescriptorTable
push de
call matchInstructionAccessDescriptor
ld hl,setReadProtectedAreas
call validateMatchedMemoryAccess

ld hl,writeAccessDescriptorTable
pop de
call matchInstructionAccessDescriptor
ld hl,setWriteProtectedAreas
```

The raw decoded operand in DE is preserved across the first search because both
address calculations may need it.

If either validation fails, execution never reaches the scratch instruction.
The current PC, registers, memory, and accumulated timing remain logically
uncommitted. The saved R value is restored by the common monitor error path to
avoid making a rejected instruction appear to have consumed fetches.

## LDIR and LDDR need whole ranges

An ordinary descriptor describes one memory access. `LDIR` and `LDDR` repeat an
operation until BC becomes zero. Checking only the first source and destination
bytes would miss most of the instruction's effect.

PROMETHEUS recognizes the repeated ED opcodes specially.

For forward `LDIR`, with saved values:

```text
HL = source first
DE = destination first
BC = count
```

it constructs inclusive ranges:

```text
source      HL .. HL+BC-1
destination DE .. DE+BC-1
```

For backward `LDDR`, the saved HL and DE point at the high ends:

```text
source      HL-BC+1 .. HL
destination DE-BC+1 .. DE
```

The source uses the alternate register bank while building these ranges, so the
main bank remains available to the surrounding trace engine.

The destination is checked against WRITE protection first, then the source
against READ protection:

```asm
ld hl,setWriteProtectedAreas
call checkRangeAgainstProtectionTable
jp c,showMonitorReadWriteError

ld hl,setReadProtectedAreas
call checkRangeAgainstProtectionTable
jp c,showMonitorReadWriteError
```

Only after both complete ranges are accepted does the repeated instruction run
natively.

This is a good example of PROMETHEUS changing the *prediction*, not the execution.
The Z80 still performs the real LDIR or LDDR and produces the real final
registers and flags.

## Block timing is predicted at the same time

The repeated transfer path also replaces the ordinary table timing with:

```text
21 * BC - 5
```

The source computes it using the existing multiplication helper:

```asm
ld h,b
ld l,c
ld de,00015h
call multiplyHLByDE

dec hl
dec hl
dec hl
dec hl
dec hl
ld (varcDecodedInstructionTStates+1),hl
```

For BC=1:

```text
21*1-5 = 16 T states
```

For BC=10:

```text
210-5 = 205 T states
```

The same special recognition therefore supplies both the full memory footprint
and the full repeated-instruction timing.

The arithmetic is sixteen-bit. A saved BC of zero follows the historical code's
natural wrap behavior rather than receiving a modern special case.

## RUN protection is checked after execution

READ and WRITE effects are checked before the scratch program runs. RUN is
different.

After capture, the resulting logical PC is placed in DE and checked against
`setExecutionProtectedAreas`:

```asm
ld hl,setExecutionProtectedAreas
ld a,(varcInstructionControlsDisabled+1)
or a
call z,checkAddressAgainstProtectionTable
ld a,0ceh
jp c,showMonitorOperationError
```

Only after this succeeds does PROMETHEUS:

- perform a simulated CALL/RET stack callback;
- commit the new current address;
- add the selected T-state count.

This ordering creates an important historical discrepancy.

If a step produces a protected PC:

- the displayed PC is not committed;
- the selected T states are not added;
- but the instruction has already executed;
- its memory writes may already exist;
- its captured registers and SP may already reflect the result.

The surviving manual simplifies this into the idea that protected execution is
prevented. The original program actually detects the protected destination after
the fact.

The resurrection preserves this behavior rather than quietly moving the check.

## What an error path restores—and what it cannot

The common operation-error path reconstructs a short line such as:

```text
Read/Write ERROR
Run ERROR
Interrupt ERROR
```

It restores the saved R value captured before validation:

```asm
varcRestoreRBeforeOperationError:
    ld a,000h
    ld (savedRegisterR),a
```

It redraws the panel, beeps, waits for acknowledgement, waits for key release,
and re-enters `startMonitor`.

For a pre-execution READ or WRITE error, no user instruction has run, so this
recovery is clean.

For a post-execution RUN error, it cannot undo arbitrary register or memory
side effects. There is no general transaction log. This limitation follows from
the hybrid design: the real processor performs the operation directly.

## A worked example: `LD (IX-2),HL`

Suppose:

```text
saved IX = $9002
displacement = $FE = -2
WRITE-protected window = $9000..$9000
```

The descriptor says:

```text
WRITE
effective address = IX + signed displacement
width = two bytes
```

The accessor calculates:

```text
$9002 + (-2) = $9000
```

The validator checks:

```text
first byte  $9000 -> protected
second byte not reached
```

The step is rejected with `Read/Write ERROR`. The real `LD` never runs.

If only `$9001` were protected, the first check would pass, the second would fail,
and the instruction would still be rejected before either byte was written.

## A worked example: `RET`

For a saved SP of `$A000`, RET has two kinds of predicted effect:

```text
READ  $A000 and $A001       obtain return target
RUN   resulting target      checked after capture
```

The READ descriptor protects the two stack bytes before execution. The
control-flow handler also reads them to establish the logical taken PC. The RET
is rewritten so it does not physically escape scratch RAM.

After capture, the logical target is checked against RUN windows. Only then is
the saved SP advanced by two and the new PC committed.

This shows how separate subsystems cooperate:

- memory descriptor predicts the stack read;
- control-flow handler predicts the target;
- capture obtains the real conditional result;
- RUN table judges the resulting logical PC;
- callback applies the logical stack pop.

## Back to the whole machine

The protection engine can now be summarized as:

```text
decode opcode and prefix

if HALT and saved DI:
    Interrupt ERROR

if controls enabled:
    if LDIR/LDDR:
        build full source and destination ranges
        check WRITE range
        check READ range
    else:
        match READ descriptor
        calculate effective address
        check one or two bytes

        match WRITE descriptor
        calculate effective address
        check one or two bytes

execute real instruction in scratch
capture result

if controls enabled:
    check resulting PC against RUN table

commit stack repair, PC, and timing
```

PROMETHEUS predicts only what it needs for policy. It does not duplicate the
processor's data behavior.

The next chapter explains how the chosen timing is accumulated, how the saved
interrupt state enters and leaves the trampoline, and how single stepping becomes
slow or fast automatic tracing.

## What has changed in memory

Memory-access validation normally changes no user memory. It reads:

- saved registers;
- decoded operand state;
- READ and WRITE descriptor tables;
- protection-window tables.

For LDIR/LDDR it patches the decoded T-state value with the complete repeated
instruction timing.

If a pre-execution validation fails, the scratch instruction is not executed.
If RUN validation fails after capture, user-side effects may already have
occurred even though PC and timing are not committed.

## Important labels encountered

- `validateInstructionBeforeExecution`
- `varcInstructionControlsDisabled`
- `readAccessDescriptorTable`
- `writeAccessDescriptorTable`
- `matchInstructionAccessDescriptor`
- `validateMatchedMemoryAccess`
- `effectiveAddressAccessorOffsets`
- `loadEffectiveAddressFromBC`
- `varcDecodedInstructionOperandWord`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `showMonitorReadWriteError`
- `showMonitorOperationError`
- `varcRestoreRBeforeOperationError`

## Ideas needed by later chapters

- Traced memory policy is based on predicted addresses, not instruction
  emulation.
- Descriptor rows combine opcode mask, prefix class, width, and address recipe.
- Two-byte accesses are checked byte by byte, including `$FFFF` wraparound.
- LDIR/LDDR require complete inclusive range prediction.
- HALT under DI is rejected even when controls are off.
- READ and WRITE are checked before execution; RUN is checked afterward.
- A post-execution Run ERROR cannot undo arbitrary user side effects.
