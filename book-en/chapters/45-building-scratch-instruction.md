# Chapter 45: Building a Scratch Instruction

The monitor cannot safely execute every instruction exactly where it was found.

An ordinary instruction such as `INC A` could in principle be called through a
small arrangement and allowed to run in place. But many instructions would then
continue into the user's next instruction before PROMETHEUS could recover.
Branches may jump away. Calls and returns use the user's stack. An instruction
may lie in ROM, where no temporary trap can be written after it. Even in RAM,
patching the bytes after every instruction would disturb the program being
observed.

PROMETHEUS therefore builds a tiny temporary program in its own scratch space.
The user's instruction is copied there, capture exits are appended, the user
processor image is restored, and the scratch program is executed.

This chapter explains that miniature code generator.

## A laboratory bench for one instruction

The scratch program begins at `encodedRecordStorageLength`.

That name comes from the editor and assembler. The same memory area is normally
used to construct a temporary compressed source record:

```asm
encodedRecordStorageLength:
    defb 0
encodedRecordHeader:
    defb 0
encodedRecordInfoByte:
    defb 0
encodedRecordPayload:
    defw 0
encodedRecordPayloadAfterLabel:
    defw 0
encodedRecordPayloadWorkspace:
    defs 28
```

During instruction execution, however, no source record is being built. The
workspace is borrowed as executable RAM.

This is characteristic of PROMETHEUS. Memory is not permanently divided into a
large number of single-purpose objects. A region is assigned a role for the
current operation, and routines agree on when that role is safe.

The scratch area is large enough for:

- one DI or EI opcode;
- the copied or rewritten user instruction;
- two absolute capture jumps;
- temporary control-flow operands and helper state.

The source parser, disassembler and stepping engine take turns using the same
bytes.

## Why copy the instruction?

Consider stepping this sequence:

```asm
$8000   INC A
$8001   LD ($9000),A
```

If PROMETHEUS simply jumped to `$8000`, the Z80 would execute `INC A`, then
immediately fetch `LD ($9000),A`. There is no automatic one-instruction stop.

The monitor could temporarily overwrite `$8001` with a breakpoint, but that has
several disadvantages:

- the following bytes may be in ROM;
- the following address may be protected or shared;
- a branch may never reach the temporary breakpoint;
- installing and restoring a patch for every step is intrusive;
- the next instruction may begin fewer than three bytes before important data;
- conditional flow needs more than one possible stop address.

Copying the instruction into scratch RAM solves the ordinary fall-through case:

```text
scratch:
    copied INC A
    JP capture
```

After `INC A`, the Z80 naturally reaches the appended jump rather than the user's
next instruction.

For a normal non-branching instruction, this is almost the whole trick.

## Every scratch program begins with DI or EI

`beginExecutionTrampoline` writes the first byte:

```asm
beginExecutionTrampoline:
    ld hl,encodedRecordStorageLength
    ld a,(varcInterruptEnableState+1)
    add a,a
    add a,a
    add a,a
    add a,0f3h
    ld (hl),a
    inc hl
    ret
```

The emitted byte is:

```text
$F3  DI, when saved state is 0
$FB  EI, when saved state is 1
```

The scratch program therefore re-establishes the user's logical interrupt state
immediately before the copied instruction.

This choice deserves attention. `restoreUserStateAndExecuteTrampoline` itself
must execute monitor machinery while restoring registers. It cannot simply leave
the monitor's current interrupt state untouched and claim that it represents the
user. The scratch program applies the saved choice at the last practical moment.

For example:

```text
scratch address S

S+0   FB             EI
S+1   3C             INC A
S+2   C3 lo hi       JP sequentialCapture
S+5   C3 lo hi       JP takenCapture
```

The `EI` delay rule on the Z80 means interrupts become effective after the
following instruction. That detail is part of the real hardware behavior the
trampoline naturally inherits.

## Finding the instruction length

The disassembler has already decoded the instruction before the trampoline is
built. It returns:

- DE = original instruction address;
- HL = sequential address after the instruction;
- BC = decoded opcode/prefix metadata;
- timing and operand information in self-modified state.

The length is therefore:

```text
instructionLength = sequentialAddress - originalAddress
```

The source computes it directly:

```asm
buildInstructionExecutionTrampoline:
    ld hl,(varcSequentialNextAddress+1)
    and a
    sbc hl,de
    ld b,h
    ld c,l
```

No separate instruction-length table is needed at this point. The decoder has
already walked the bytes and produced the next address.

This reuse is one reason the monitor's disassembler is central to execution. It
is not only a text printer. It is the instruction-structure oracle used by the
stepper.

## Copying the exact byte sequence

After the length has been placed in BC, the routine begins the scratch program
and copies the instruction:

```asm
call beginExecutionTrampoline
ex de,hl
ldir
ex de,hl
```

The register dance can be read as:

```text
before EX:
    DE = original instruction address
    HL = scratch cursor after DI/EI
    BC = instruction length

after EX:
    HL = original instruction address
    DE = scratch destination

LDIR copies BC bytes

second EX:
    HL = scratch cursor after copied instruction
```

For `LD BC,$1234`, the emitted scratch sequence becomes:

```text
F3 or FB
01 34 12
```

Prefix bytes are copied too. An indexed instruction such as:

```asm
LD A,(IX+5)
```

keeps its complete byte sequence:

```text
DD 7E 05
```

The copied instruction sees the restored IX value, so its effective address is
unchanged by the move.

## Appending two exits

After copying, `appendSequentialAndTakenCaptureJumps` writes two absolute jumps:

```asm
appendSequentialAndTakenCaptureJumps:
    ld de,captureUserStateAfterSequentialFlow
    call writeJumpAtHL
    ld de,captureUserStateAfterTakenFlow
writeJumpAtHL:
    ld (hl),0c3h
writeDEWordAtHLAndAdvance:
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ret
```

The resulting general layout is:

```text
+0                 DI or EI
+1                 copied/rewritten instruction bytes
+1+length          JP sequential capture
+4+length          JP taken capture
```

Why append two jumps when an instruction such as `INC A` can only fall through?

Because the same layout must also support conditional control flow.

A rewritten `JR Z,target` can be arranged so:

- not taken: it reaches the first JP;
- taken: it skips the first JP and reaches the second.

A rewritten conditional CALL, JP or RET can use the same pair. Keeping a fixed
two-exit layout makes later handlers smaller.

For ordinary instructions the second jump is simply unreachable.

## A non-control-flow step

Let us follow `INC A` from `$8000`.

Assume:

```text
current address = $8000
memory[$8000]   = $3C
saved A         = $05
saved interrupts = DI
```

The decoder returns:

```text
original DE     = $8000
sequential HL   = $8001
length          = 1
base timing     = 4 T states
```

The scratch program becomes:

```text
F3                         DI
3C                         INC A
C3 <sequential capture>    JP captureUserStateAfterSequentialFlow
C3 <taken capture>         JP captureUserStateAfterTakenFlow
```

The step controller finds no control-flow descriptor for `INC A`, so it does not
rewrite anything.

Restoration loads A=`$05` and jumps to scratch. The Z80 executes:

```text
DI
INC A       ; A becomes $06, flags change normally
JP capture
```

Capture stores A=`$06` and the new F byte. The higher controller later commits
PC=`$8001` and adds four to `accumulatedTStates`.

The actual instruction has executed on the real Z80 with the user's registers.
Only its location and continuation have been changed.

## Why absolute memory operands still work

Moving an instruction can alter its meaning if the instruction depends on its
own address. Most Z80 instructions do not.

An absolute memory instruction such as:

```asm
LD A,($9000)
```

contains `$9000` explicitly. Copying the bytes leaves the operand unchanged, so
it still reads `$9000`.

Register-indirect instructions also keep their meaning:

```asm
LD A,(HL)
LD (IX+5),B
PUSH DE
```

They use restored user registers and the user's stack.

The difficult categories are those whose effect depends on the original PC or
on return addresses:

- JR and DJNZ;
- conditional and unconditional JP;
- CALL and RST;
- RET, RETI and RETN;
- JP (HL), JP (IX), JP (IY).

Those instructions cannot simply be copied and trusted. Chapter 46 explains how
PROMETHEUS rewrites them while preserving their logical destination.

## The scratch area is code only for a moment

Before execution, `encodedRecordStorageLength` is data. After the builder writes
to it, the same address becomes executable machine code.

After capture, the bytes are not ceremonially erased. The next parser,
disassembler or step operation overwrites them as needed.

This is safe because the operations are sequential:

```text
build scratch program
restore and execute it
capture and return
scratch area no longer active
reuse area for another task
```

No background thread can begin parsing a source line while the Z80 is inside the
trampoline. The Spectrum and PROMETHEUS are single-tasking here.

The design saves memory at the cost of stronger temporal rules: every subsystem
must know when the shared workspace belongs to it.

## Entering scratch without a CALL

At the end of restoration, PROMETHEUS uses:

```asm
ld sp,(savedRegisterSP)
jp encodedRecordStorageLength
```

It does not call the scratch program.

A `CALL` would push a monitor return address onto the user's stack and contaminate
the state being tested. It would also imply that the scratch program could return
normally, which is not how it is designed.

The only valid exits are explicit jumps into capture code.

This is a useful rule when reading the execution engine:

> Once the user's SP is active, control paths are jumps, not ordinary monitor
> calls and returns.

The monitor's own return chain is dormant until capture restores
`varcRestoreMonitorStackAfterExecution`.

## The monitor SP is stored in code

Before changing SP, restoration patches this instruction:

```asm
varcRestoreMonitorStackAfterExecution:
    ld sp,00000h
```

The current monitor SP becomes the future immediate operand.

During capture, after all user registers have been serialized, execution reaches
that patched `LD SP,nn`. The monitor stack reappears exactly where it was before
the experiment.

This is self-modifying code used as a continuation record:

```text
before user execution:
    remember monitor SP in future LD SP operand

after user execution:
    execute patched LD SP to reactivate monitor call chain
```

A separate memory variable could have held the same word, but the patched
instruction restores it directly.

## Native CALL/JP trampolines are a smaller variation

Chapter 44's common native builder also starts with
`beginExecutionTrampoline`, but instead of copying decoded bytes it writes a
three-byte transfer instruction:

```text
DI/EI
CALL target   or   JP target
JP sequential capture
JP taken capture
```

This is the same laboratory bench with a different experiment placed on it.

For CALL:

```text
CALL returns to first appended JP
```

For breakpoint JP:

```text
JP leaves scratch permanently
patched breakpoint later jumps directly to capture
```

The shared beginning and capture exits let native and traced operations reuse
the complete register restoration and serialization machinery.

## A branch needs two meanings of “next”

The scratch layout introduces an important distinction that will dominate the
next chapter.

For every decoded instruction, PROMETHEUS records at least one next address:

```text
sequential next = original address + instruction length
```

For control-flow instructions there may also be:

```text
taken next = branch/call/return destination
```

The two appended jumps correspond to those logical outcomes, not to physical
scratch addresses.

The capture entries carry the appropriate address back to the controller:

```asm
varcSequentialNextAddress:
    ld hl,00000h
```

and:

```asm
varcTakenFlowNextAddress:
    ld hl,00000h
```

The actual scratch PC disappears during capture. The monitor commits one of the
original program's logical addresses.

This is the heart of simulation: execute enough real machine code to obtain
correct registers and flags, but replace the physical scratch continuation with
the continuation the original program would have had.

## Instruction validation happens before execution

The scratch program is built only after the instruction has been decoded and
passed preliminary validation.

The step controller broadly does:

```text
decode instruction
remember sequential address and operand
validate HALT and memory effects
build scratch program
rewrite control flow if necessary
restore user state
execute
```

The validation details belong to Chapter 47, but their position matters now. A
forbidden read or write is detected before the copied instruction is allowed to
run.

There is an important exception discussed later: RUN protection is checked on
the resulting PC after execution. The source comments identify this as weaker
than the surviving manual's wording.

For now, think of the scratch builder as operating on an instruction that the
controller has already agreed is eligible for an execution attempt.

## Instructions that alter the stack

A copied `PUSH`, `POP`, `EX (SP),HL` or similar instruction runs against the real
saved user SP. This is necessary for fidelity.

The capture code immediately records the resulting SP before borrowing scratch
memory as a temporary stack. Therefore:

- PUSH leaves the saved SP two bytes lower;
- POP leaves it two bytes higher;
- data written or read by the instruction affects user memory normally.

The scratch location of the opcode does not interfere with those effects.

CALL and RET need extra work not because they touch the stack, but because the
return address or destination would refer to scratch RAM rather than the original
program. Their handlers repair that logical mismatch.

## What happens to flags

The copied instruction executes with the saved F byte restored through `POP AF`.
Whatever flags the real Z80 produces are then captured with AF.

PROMETHEUS does not recalculate flags in software for ordinary instructions.
That would require a large, error-prone CPU emulator. The trampoline lets the
real processor perform the difficult details:

- half carry;
- overflow;
- undocumented flag bits;
- parity;
- carry and zero interactions.

This is one of the design's strongest advantages.

The monitor simulates **control flow around** the instruction, not the arithmetic
inside it.

## A miniature hybrid emulator

PROMETHEUS is neither simply executing in place nor fully emulating the Z80 in
software.

It uses a hybrid method:

```text
real Z80 executes:
    arithmetic
    logic
    register transfers
    memory operations
    flag generation

monitor machinery simulates or supervises:
    where the instruction is placed
    how control returns
    logical next PC
    CALL/RET stack meaning
    protection checks
    timing bookkeeping
```

This division is well suited to a small machine. A complete software Z80
interpreter would consume much more code. Blind native execution would be too
hard to control. The scratch trampoline uses the processor itself as the
instruction engine while PROMETHEUS manages the dangerous edges.

## The general scratch-program recipes

By the end of this chapter we have met three layouts.

### Ordinary instruction

```text
DI/EI
copied instruction
JP sequential capture
JP taken capture        ; normally unreachable
```

### Native subroutine call

```text
DI/EI
CALL target
JP sequential capture   ; reached after target RET
JP taken capture
```

### Native run to breakpoint

```text
DI/EI
JP runStart             ; does not return here
JP sequential capture
JP taken capture

... elsewhere ...
breakpoint:
JP breakpointHitCaptureEntry
```

Chapter 46 adds rewritten control-flow recipes in which the copied instruction is
changed so each outcome chooses one of the two capture jumps.

## Back to the whole machine

The scratch workspace connects almost every idea developed so far:

- the disassembler determines instruction length and operands;
- self-modified state stores sequential address, timing and policy;
- the saved processor image supplies registers and stack;
- a shared workspace becomes generated code;
- two capture exits serialize the result;
- the front panel later displays the new state.

For an ordinary instruction, the complete flow is now understandable:

```text
current address
    -> decode bytes
    -> copy to scratch
    -> append capture jumps
    -> restore saved processor
    -> execute real Z80 instruction
    -> capture processor
    -> commit logical next address
    -> repaint panel
```

The remaining difficulty is the phrase “logical next address.” An ordinary
instruction has only one. A branch may have two, a CALL changes the stack, a RET
obtains its destination from memory, and an indirect JP obtains it from a saved
register.

That is the subject of the next chapter.

## What has changed in memory

Building a scratch instruction overwrites the temporary encoded-record workspace
with:

- one DI/EI opcode;
- copied or generated instruction bytes;
- a sequential-capture JP;
- a taken-capture JP.

It also relies on self-modified operands holding:

- sequential next address;
- taken next address;
- decoded operand;
- base and taken timings;
- post-flow stack callback;
- monitor-stack restoration address.

The workspace is transient and is reused after capture.

## Important labels encountered

- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `encodedRecordPayloadWorkspace`
- `beginExecutionTrampoline`
- `buildInstructionExecutionTrampoline`
- `appendSequentialAndTakenCaptureJumps`
- `writeJumpAtHL`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcRestoreMonitorStackAfterExecution`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`

## Ideas needed by later chapters

- The original instruction is normally copied into shared scratch RAM.
- DI or EI is emitted immediately before it.
- Two appended capture jumps represent sequential and taken logical outcomes.
- The physical scratch PC is never committed as the user's PC.
- The real Z80 supplies register, memory and flag behavior; PROMETHEUS supervises
  control flow and safety.
- PC-relative and stack-return instructions must be rewritten because copying
  them changes the meaning of their physical location.
