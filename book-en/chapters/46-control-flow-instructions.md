# Chapter 46: Instructions That Change Control Flow

The scratch program from the previous chapter works beautifully for an ordinary
instruction:

```text
DI or EI
copied instruction
JP sequential capture
JP taken capture
```

If the copied instruction is `INC A`, it runs and falls into the first capture
jump. The logical next address is simply the address following `INC A` in the
user's program.

A branch is different. It may have two possible next addresses. A call also
changes the stack. A return obtains its destination from the stack. A relative
jump calculates its destination from the address where it is physically
executed—and the copied instruction is no longer at its original address.

PROMETHEUS solves this without emulating all the arithmetic and flag behavior of
the Z80. It keeps the real instruction wherever that remains useful, but rewrites
its route through the scratch program so that every possible result comes back to
one of the two capture exits.

The real Z80 still decides whether a condition is true. PROMETHEUS merely arranges
where the taken and not-taken paths lead.

## The problem with copying a branch

Suppose the user's program contains:

```asm
$8000   DEC B
$8001   JR NZ,$7FF0
```

The `JR` displacement is measured from the byte after the original instruction.
If its two bytes are copied to scratch RAM at, say, `$9001`, the same displacement
would now point somewhere near `$9003`, not `$7FF0`.

A copied absolute jump has a different problem:

```asm
JP NZ,$8120
```

Its target remains `$8120`, but if the jump is taken the processor escapes from
the scratch program before PROMETHEUS can capture the resulting registers.

A copied return is worse:

```asm
RET Z
```

If the condition succeeds, the Z80 pops a real address from the user's stack and
continues there. Again, the capture machinery is bypassed.

The monitor therefore needs a small amount of instruction-specific knowledge.
Not enough to reproduce the whole instruction, but enough to supervise its
control flow.

## Classifying only the dangerous instructions

The decoder already returns two compact pieces of identity:

- **B** contains the significant opcode byte;
- the high nibble of **C** identifies the prefix or decoder class.

The stepping engine searches `controlFlowDescriptorTable`. Each row contains:

```text
opcode mask
expected masked opcode
decoder class plus handler index
```

The table has fourteen rows covering:

- `JR`, conditional `JR`, and `DJNZ`;
- absolute `JP` and `CALL`, conditional and unconditional;
- `RET` and conditional `RET`;
- `RST`;
- `JP (HL)`, `JP (IX)`, and `JP (IY)`;
- `RETN` and `RETI`.

Everything else needs no control-flow rewrite and runs through the ordinary
scratch layout.

The search is shared with the memory-access tables described in Chapter 47:

```asm
ld hl,controlFlowDescriptorTable
call matchInstructionAccessDescriptor
jr c,.executePreparedInstructionTrampoline
```

Carry means that no row matched. In that case, the copied instruction is left
alone.

When a row does match, its low result bits select one of eight handlers. The
selection is indirect:

```asm
ld hl,tracedControlFlowHandlerOffsets
call addAtoHL
ld a,(hl)
ld hl,simulateRelativeControlFlow
call addAtoHL
call dispatchDisassemblyOperandHandler
```

The offset table is written as bytes that happen to disassemble as Z80
instructions:

```asm
tracedControlFlowHandlerOffsets:
    nop
    inc d
    ld c,d
    ld h,a
    ld a,h
    add a,c
    add a,(hl)
    sub l
```

These instructions are never executed. Their opcode bytes are compact offsets to
neighboring handler entries.

This is another example of a tiny PROMETHEUS data language. A disassembler sees
instructions; the stepping engine sees eight small integers.

## Two logical exits

Before any special rewrite, the engine prepares two logical destinations:

```text
sequential PC = address after original instruction
taken PC      = sequential PC for now
```

It also prepares two timings:

```text
sequential timing = base timing from instruction table
taken timing      = base timing for now
```

A handler changes only what its instruction family requires:

- copied opcode or operand bytes;
- logical taken destination;
- taken timing;
- optional post-capture stack repair.

After the instruction runs, the capture entry identifies which physical exit was
reached. The physical scratch address is discarded. The corresponding logical
address and timing become the result of the step.

## Relative branches: make the real Z80 choose the exit

For `JR`, `JR cc`, and `DJNZ`, PROMETHEUS uses a particularly elegant rewrite.

The scratch program already contains two three-byte jumps:

```text
JP sequentialCapture
JP takenCapture
```

The copied relative displacement is changed to `+3`:

```asm
simulateRelativeControlFlow:
    ld hl,encodedRecordInfoByte
    ld e,(hl)             ; original displacement
    ld (hl),003h          ; replacement displacement
```

If the branch is not taken, execution falls into the first `JP`, exactly as for
an ordinary instruction.

If it is taken, `+3` skips the first three-byte jump and lands on the second:

```text
copied JR cc,+3
JP sequentialCapture
JP takenCapture
```

The real Z80 evaluates the condition from the real saved flags. PROMETHEUS does
not need to know whether zero, carry, parity, sign, or the B counter caused the
branch.

The original destination is calculated separately:

```asm
ld hl,(varcSequentialNextAddress+1)
ld d,000h
bit 7,e
jr z,.finishRelativeControlFlowTarget
dec d                    ; sign-extend E into DE
.finishRelativeControlFlowTarget:
add hl,de
add a,005h               ; taken relative branch costs five more T states
ret
```

In pseudocode:

```text
originalDisplacement = signed byte from instruction
logicalTakenPC = originalSequentialPC + originalDisplacement
copiedDisplacement = +3
logicalTakenTime = baseTime + 5
```

For our example:

```text
original instruction at $8001
sequential address       $8003
original displacement    $ED = -19
logical target           $8003 - 19 = $7FF0
```

The copied branch never jumps to `$7FF0` physically. It jumps three bytes inside
the scratch program, where the taken capture supplies `$7FF0` as the logical PC.

## Absolute jumps: redirect the operand

An instruction such as:

```asm
JP NZ,$8120
```

already contains its real logical destination as a sixteen-bit operand.
PROMETHEUS keeps that value in `varcTakenFlowNextAddress`, but changes the copied
operand to the address of the taken-capture jump inside scratch RAM.

Conceptually:

```text
original:
    JP NZ,$8120

scratch:
    JP NZ,takenCaptureJump
    JP sequentialCapture
 takenCaptureJump:
    JP captureTaken
```

If the condition is false, the copied instruction falls through to sequential
capture. If it is true, the real Z80 executes the copied conditional jump and
reaches taken capture.

An unconditional `JP` uses only the taken route, but can use the same structure.

The handler does not need to evaluate the flags. It only redirects the physical
target while remembering the original logical one.

## CALL: the scratch return address must be repaired

A simulated `CALL` can also be redirected to taken capture, but a real Z80
`CALL` has an extra effect: it pushes a return address.

In scratch RAM, the pushed word points back into the scratch program. That is
correct while the instruction is running, but it would be wrong to leave on the
user's saved stack. A later `RET` in the user's program should return to the
instruction after the original CALL, not to PROMETHEUS's temporary workspace.

PROMETHEUS therefore lets the copied CALL push its ordinary scratch return word.
After state capture, it replaces that word:

```asm
replaceScratchCallReturnAddress:
    ld hl,(savedRegisterSP)
    ld de,(varcSequentialNextAddress+1)
    ld (hl),e
    inc hl
    ld (hl),d
    ret
```

The sequence is:

```text
1. copied CALL is taken;
2. real Z80 decrements user SP and pushes scratch return address;
3. taken capture serializes the resulting user SP;
4. post-flow callback overwrites the top word;
5. top word becomes original sequential PC.
```

This is a useful distinction:

- the **physical** CALL occurs in scratch RAM;
- the **logical** return address belongs to the original program.

PROMETHEUS repairs only the address. The stack movement itself was performed by
the real processor.

Conditional CALLs benefit from the two exits. The stack-repair callback is
invoked only when the taken path reports a nonzero path flag.

## NON, DEF, and ALL: sometimes do not redirect a CALL

PROMETHEUS can optionally allow a traced `CALL` or `RST` to execute its real
target natively.

The three modes are stored as executable opcode bytes:

```text
$00  NOP     NON — never execute directly
$C8  RET Z   DEF — execute directly only if target is in the list
$C9  RET     ALL — execute every CALL/RST directly
```

The mode byte lives at `directCallModeGateOpcode`.

In DEF mode, the target is compared with `directCallAddressList`. The scan uses
the Z80 stack pointer as a compact iterator over the list:

```asm
ld hl,directCallAddressList
ld b,(hl)
inc hl
ld sp,hl
...
pop hl                  ; next candidate target
```

The real monitor SP is first stored in the operand at
`restoreStackAfterDirectCallScan`, then restored before the selected mode opcode
is executed.

The result is surprisingly compact:

```text
NON: NOP continues into simulation
DEF: RET Z returns early only after a listed-target match
ALL: RET always returns early
```

Returning early leaves the copied CALL aimed at the user's real routine. That
routine runs natively and its `RET` returns to the scratch program's sequential
capture jump.

This is much faster, but it has consequences:

- instructions inside the routine are not individually traced;
- READ, WRITE, and RUN windows are not checked inside it;
- BREAK is not sampled inside it;
- its internal T states are not counted;
- a damaged stack or non-returning routine can escape the monitor.

DEF mode lets the user grant this trust only to selected routines, perhaps ROM
services or known utility code.

## RST becomes CALL

A Z80 `RST` is a one-byte call to one of eight fixed vectors:

```text
$00, $08, $10, $18, $20, $28, $30, or $38
```

The vector is encoded in bits 3–5 of the opcode. PROMETHEUS extracts those bits
and turns the copied byte into an ordinary three-byte CALL:

```asm
ld hl,encodedRecordHeader
ld a,(hl)
and 038h
ld (hl),0cdh             ; CALL opcode
inc hl
ld (hl),a                ; low byte of vector
inc hl
ld (hl),000h             ; high byte
```

Once expanded, RST can use the same CALL machinery:

- simulated stack repair in NON mode;
- direct execution selection in DEF or ALL mode;
- ordinary sequential capture after a directly executed handler returns.

One instruction family is translated into another because their logical effects
are close enough for the existing machinery to be reused.

## RET: read the target, do not trust the physical return

For a return, the logical destination is the word at the saved user SP:

```asm
ld hl,(savedRegisterSP)
ld e,(hl)
inc hl
ld d,(hl)
```

PROMETHEUS reads this word before execution. The copied `RET` or conditional
`RET` is then converted into an equivalent absolute jump aimed at the taken
capture route.

Why not execute the real RET?

Because a real RET would jump to the user target immediately, outside the
scratch program. By translating it to a JP inside scratch RAM, PROMETHEUS lets
the real Z80 decide the condition but retains control.

The logical target remains the word read from the user's stack.

A taken RET must also consume that word. Since no real RET was allowed to pop it,
the post-capture callback advances the saved SP:

```asm
advanceSavedStackAfterReturn:
    ld hl,(savedRegisterSP)
    inc hl
    inc hl
    ld (savedRegisterSP),hl
```

For a conditional RET:

```text
not taken:
    sequential capture
    SP unchanged

taken:
    taken capture
    logical PC = word at old SP
    SP = old SP + 2
```

Again, the path flag controls whether the callback runs.

## Indirect jumps use saved registers directly

The target of `JP (HL)` is not stored in the instruction bytes. It comes from the
saved HL register. The indexed forms similarly use IX or IY.

PROMETHEUS reads the appropriate saved pair:

```asm
ld hl,(savedRegisterD+1)          ; saved HL
...
ld hl,(savedRegisterIYHigh+1)     ; saved IX
...
ld hl,(savedRegisterIY)           ; saved IY
```

The copied jump bytes are neutralized so they cannot leave scratch RAM, and the
selected register value is installed as the logical captured PC.

Unlike a conditional branch, `JP (HL)` has only one outcome. It can therefore
reuse what is normally called the sequential capture route, but supply the
register target rather than the decoder's address-after-instruction.

This is a reminder that “sequential” and “taken” are names for two physical
capture entrances. The logical address supplied by either entrance can be
patched when required.

## RETN and RETI: a genuine uncertainty

The control-flow table recognizes the extended return family represented by
`RETN` and `RETI`. The source reads a stacked target and prepares the same kind
of indirect return used by ordinary RET.

However, static analysis does not establish every semantic detail with equal
confidence:

- the saved-SP advance callback is not equally explicit on every path;
- the architectural restoration of IFF1 from IFF2 is not represented as a
  separate, clear operation.

The reconstructed source therefore does not pretend that these instructions are
perfectly understood. It preserves the historical bytes and records the
uncertainty.

This is the correct approach for a resurrection project. Where the code proves a
behavior, the book explains it. Where it only suggests one, the book says so.

## A complete conditional CALL example

Consider:

```asm
$8100   CALL Z,$9000
```

The decoder establishes:

```text
sequential PC = $8103
taken PC      = $9000
base timing   = not-taken timing from instruction metadata
```

In NON mode, the scratch program is conceptually transformed into:

```text
DI/EI
CALL Z,takenCaptureJump
JP sequentialCapture
 takenCaptureJump:
JP takenCapture
```

If Z is clear:

```text
CALL condition fails
no stack write occurs
sequential capture reports PC=$8103
SP is unchanged
```

If Z is set:

```text
CALL condition succeeds
real Z80 pushes a scratch return word
taken capture reports PC=$9000
callback replaces scratch word with $8103
saved SP remains decremented by two
```

The arithmetic, flags, stack decrement, and conditional decision all came from
the real Z80. PROMETHEUS supplied the safe physical destinations and repaired the
one scratch-specific word.

## Back to the whole machine

The control-flow engine is not a second Z80 interpreter. It is a collection of
small adapters around the actual processor:

```text
decode instruction
    -> ordinary instruction? copy unchanged
    -> relative branch? point taken flow at second capture
    -> JP/CALL? redirect physical target
    -> RET? obtain logical target from user stack
    -> RST? expand into CALL
    -> indirect JP? obtain target from saved register

restore real user state
execute real instruction
capture selected exit
repair logical stack if required
commit logical PC
```

This is why the implementation can support all Z80 conditions without a large
condition evaluator. The real flags register remains the final judge.

The next problem is not where an instruction goes, but which memory locations it
will touch before it gets there.

## What has changed in memory

During control-flow preparation PROMETHEUS may modify the scratch copy by:

- changing a relative displacement to `+3`;
- replacing an absolute target with a scratch capture address;
- translating RET to a JP-like form;
- expanding RST into a three-byte CALL;
- clearing indirect-jump bytes;
- appending a second pair of capture jumps where a rewritten layout requires it.

It also patches self-modified state holding:

- logical taken PC;
- taken timing;
- post-taken stack callback;
- direct CALL mode;
- monitor SP used while scanning the direct-call target list.

After a taken simulated CALL or RET, the saved user stack may be repaired.

## Important labels encountered

- `controlFlowDescriptorTable`
- `matchInstructionAccessDescriptor`
- `tracedControlFlowHandlerOffsets`
- `simulateRelativeControlFlow`
- `directCallAddressList`
- `directCallModeGateOpcode`
- `restoreStackAfterDirectCallScan`
- `replaceScratchCallReturnAddress`
- `advanceSavedStackAfterReturn`
- `noPostFlowStackAdjustment`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcPostTakenControlFlowCallback`
- `varcTakenFlowTStates`

## Ideas needed by later chapters

- Control-flow descriptors classify only instructions that can escape scratch
  RAM or alter the logical stack.
- The real Z80 still evaluates every condition.
- Sequential and taken capture are physical exits carrying logical PCs.
- Relative branches use a replacement displacement of `+3`.
- Simulated CALL and RET require post-capture stack repair.
- Direct CALL/RST modes deliberately trade protection and timing accuracy for
  speed.
- Some RETN/RETI details remain uncertain in the historical implementation.
