# Chapter 49: One Complete Single Step

Part VI has built the stepping engine from the bottom upward. We have seen the
saved processor image, the scratch program, the two capture exits, control-flow
rewriting, memory prediction, timing and trace loops. Each mechanism is small
enough to understand alone, but the complete operation still crosses several
register banks, stacks and temporary representations.

It is time to return to the top.

This chapter follows one instruction from the monitor panel to the moment the
panel is ready to be redrawn. The example is deliberately taken from the tiny
program that has accompanied us since Chapter 2:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Suppose the program has already executed `LD B,5` and several loop iterations.
The saved state now contains:

```text
current address   $8002
B                 2
instruction       10 FE      DJNZ $8002
saved interrupts  DI
T-state total     $0120      illustrative previous total
```

The next instruction decrements B. Because the result will be 1, the branch is
taken back to `$8002`.

PROMETHEUS does not know that result in advance. That is the point. The real Z80
must perform the decrement and make the branch decision from its own B register.
The monitor's job is to arrange matters so that either decision returns safely.

## The whole operation in one view

Before descending into the details, here is the complete journey:

```text
monitor current address $8002
        ↓
decode 10 FE as DJNZ displacement -2
        ↓
record sequential PC $8004 and base timing
        ↓
validate that execution is permitted
        ↓
build scratch code beginning with saved DI
        ↓
rewrite copied DJNZ displacement from -2 to +3
        ↓
record logical taken PC $8002 and taken timing
        ↓
restore every saved user register and user SP
        ↓
real Z80 executes DJNZ in scratch RAM
        ↓
B becomes 1, so physical branch chooses taken capture
        ↓
capture complete processor state
        ↓
check logical resulting PC against RUN protection
        ↓
commit PC $8002 and taken timing
        ↓
return redraw policy in carry
```

The essential separation is visible already:

```text
physical execution route     through scratch RAM
logical program route        from $8002 back to $8002
```

PROMETHEUS allows the first route to be artificial so that the second route can
remain faithful.

## Entering through the monitor's current address

Manual stepping, slow trace and fast trace all reach the same small wrapper:

```asm
stepAtCurrentMonitorAddress:
    ld hl,(varcMonitorCurrentAddress+1)
```

The current address is stored in an immediate operand, as explained in Chapter
5. Loading it into HL gives the common engine its only formal input:

```text
HL = address of the instruction to execute
```

The wrapper falls directly into `stepInstructionAtHL`.

This is a useful architectural choice. The core engine does not care whether it
was invoked by:

- one manual step;
- the slow trace loop;
- the fast trace loop;
- another internal caller that already has an address in HL.

The difference between those modes appears only after the step returns.

## Stage 1: decode without executing

The controller begins by preserving the original address and calling the same
decoder used by listings and reverse disassembly:

```asm
stepInstructionAtHL:
    push hl
    call decodeInstructionAtHL
    ex af,af'
    jp nz,startMonitor
```

For our two bytes:

```text
$8002  $10
$8003  $FE
```

`decodeInstructionAtHL` discovers:

```text
instruction family       DJNZ relative branch
sequential address       $8004
raw operand              $00FE
instruction length       2
base timing              not-taken timing
opcode/prefix metadata   compact descriptor values
validity                  valid
```

The decoder returns the address following the instruction in HL. That address is
more useful than a separate length because subtraction can recover the length
later:

```text
$8004 - $8002 = 2 bytes
```

The validity flags are moved into alternate AF with `EX AF,AF'`. The live A
register will shortly be needed for timing and descriptor work, but the decode
result must survive. An unknown instruction causes an immediate warm return to
the monitor. PROMETHEUS will display unknown bytes as `DEFB`; it will not blindly
execute them.

## Stage 2: establish neutral sequential state

Before examining whether this is a branch, the controller prepares a harmless
default:

```asm
    ld (varcSequentialNextAddress+1),hl
    ld (varcTakenFlowNextAddress+1),hl
    ld (varcDecodedInstructionOperandWord+1),de
```

For the example:

```text
sequential next address = $8004
taken next address      = $8004 initially
raw operand             = $00FE
```

Why initialize both addresses to the same value?

Most instructions have no taken path. Even a conditional instruction may not
match a special handler until later. Giving both exits the sequential address
creates a safe neutral state:

```pseudocode
sequentialPC = decodedAddressAfterInstruction
takenPC      = sequentialPC
```

A control-flow handler changes `takenPC` only when necessary.

The raw operand is also saved in an immediate word. Memory-address prediction and
control-flow rewriting can then use it after the decoder's temporary register
values have been repurposed.

## Stage 3: remember a clean error state

The controller next preserves decoder metadata and remembers the current saved R
value:

```asm
    push bc
    ld a,(savedRegisterR)
    ld (varcRestoreRBeforeOperationError+1),a
    call validateInstructionBeforeExecution
```

Decoding itself has performed instruction fetches and therefore disturbed the
physical Z80 refresh register. If validation rejects the instruction, the
monitor wants to display the saved user's R value, not a value contaminated by
its own checking work. The self-modified restore operand provides that rollback
point for the error path.

Validation asks several questions:

1. Is this exactly `HALT` while the saved state is DI?
2. Are instruction controls enabled?
3. Does the instruction predict a protected READ?
4. Does it predict a protected WRITE?
5. Is it a repeated block instruction needing whole-range checks?

`DJNZ` reads no user memory and writes no user memory. It is not HALT. The
validation path therefore returns without complaint.

This is still pre-execution checking. No user register or user memory has changed.

## Stage 4: recover the original address

The original instruction address was pushed before decoding. After validation,
the controller recovers it into DE:

```asm
    pop bc
    pop de
    push bc
    call buildInstructionExecutionTrampoline
```

Now the important values are conceptually:

```text
DE = $8002       original physical address
HL = $8004       remembered separately in patched code
BC = decoder metadata
```

The metadata remains on the stack while the scratch program is built.

## Stage 5: build the neutral scratch program

`buildInstructionExecutionTrampoline` subtracts the original address from the
sequential address:

```text
$8004 - $8002 = 2
```

It then calls `beginExecutionTrampoline`. Saved interrupts are DI, so the first
scratch byte becomes `$F3`:

```asm
DI
```

The original two instruction bytes are copied after it:

```text
F3 10 FE
```

Finally the builder appends two absolute jumps:

```text
JP captureUserStateAfterSequentialFlow
JP captureUserStateAfterTakenFlow
```

At this neutral stage the workspace looks like this:

```text
scratch+0   F3             DI
scratch+1   10 FE          DJNZ -2        copied unchanged
scratch+3   C3 ss ss       JP sequential capture
scratch+6   C3 tt tt       JP taken capture
```

If this were an ordinary arithmetic instruction, the scratch program would now
be ready. Falling through would reach the sequential capture jump. But copying a
relative branch unchanged is unsafe.

At its original address, displacement `$FE` means:

```text
$8004 - 2 = $8002
```

In scratch RAM it would mean “two bytes before the scratch sequential PC,” which
is an unrelated address. The branch needs a physical scratch destination and a
separate logical program destination.

## Stage 6: classify control flow

The controller searches `controlFlowDescriptorTable` using the decoder's compact
opcode and prefix metadata:

```asm
    ld hl,controlFlowDescriptorTable
    call matchInstructionAccessDescriptor
```

`DJNZ` matches the relative-control-flow family. The returned small index selects
an offset in `tracedControlFlowHandlerOffsets`, and that offset leads to
`simulateRelativeControlFlow`.

This is deliberately narrower than a Z80 emulator. The engine has no special
handler for `INC B`, `ADD HL,DE` or `XOR A`; the real processor can execute those
unchanged. It needs a handler only because `DJNZ` contains a physical
program-counter relationship that changes when copied.

## Stage 7: rewrite the physical branch, preserve the logical branch

The relative-flow handler performs two different calculations.

First it changes the copied displacement to `+3`:

```text
scratch sequential PC after DJNZ = scratch+3
taken capture JP begins          = scratch+6
required displacement            = +3
```

The scratch bytes become:

```text
F3 10 03 C3 ss ss C3 tt tt
```

Now the real Z80 has two safe physical outcomes:

```text
DJNZ not taken -> fall through to JP sequential capture
DJNZ taken     -> jump +3 to JP taken capture
```

Second, the handler calculates the original logical target. The saved raw byte
`$FE` is sign-extended to -2 and added to the original sequential PC:

```text
$8004 + (-2) = $8002
```

The result is written into `varcTakenFlowNextAddress`.

The handler also adds the taken-path timing difference. For `DJNZ`, the base
not-taken cost is 8 T states and the taken route adds 5:

```text
sequential timing = 8
taken timing      = 13
```

Finally it selects `noPostFlowStackAdjustment`, because a relative branch does
not alter the user's stack.

The scratch route and logical result are now fully separated:

```text
physical taken destination = taken capture stub in scratch RAM
logical taken destination  = $8002
```

## Stage 8: restore the user processor

The controller calls:

```asm
restoreUserStateAndExecuteTrampoline
```

This routine first adjusts saved R for the known fetches that are about to occur
and stores the monitor's current SP into a patched `LD SP,nn` instruction. That
patched instruction is the thread back home; after the user SP becomes active,
the ordinary monitor call stack is inaccessible.

It then points SP at `savedRegisterR` and restores the user image through a
carefully ordered series of POPs:

```text
R and I
alternate BC', DE', HL', AF'
IY and IX
primary BC, DE, HL, AF
user SP
```

For our example, primary B becomes 2. The physical Z80 now contains the user's
state, not the monitor's temporary state.

The routine jumps to the scratch workspace. It does not CALL it. A CALL would
push a monitor return address onto the user stack and would make the instruction
observe an invented stack word.

## Stage 9: let the real Z80 decide

The scratch program begins:

```asm
DI
DJNZ +3
```

`DI` recreates the saved interrupt policy. It does not change the ordinary flags
used by `DJNZ`.

The real `DJNZ` now performs its architectural work:

1. B changes from 2 to 1.
2. The processor tests whether B is zero.
3. B is not zero, so the relative branch is taken.
4. Displacement +3 skips the sequential capture JP.
5. Execution reaches the taken capture JP.

No PROMETHEUS routine calculated `B-1` or imitated the branch condition. The
actual Z80 did both.

This is the heart of the design:

> rewrite where control returns, but do not rewrite what the instruction means.

## Stage 10: enter the taken capture path

The taken jump reaches `captureUserStateAfterTakenFlow`.

The first task is to preserve the user SP before any capture stack is used. The
routine then collects AF, I and R evidence, disables interrupts, and saves the
primary registers that are still live.

It supplies three path-specific results:

```text
path flag    1
timing       13
logical PC   $8002
```

Those values come from patched operands:

```asm
varcTakenFlowTStates:
    ld de,00000h
varcTakenFlowNextAddress:
    ld hl,00000h
```

They were filled by the relative-flow handler before execution.

The common serializer saves the rest of the primary and alternate registers,
IX, IY, I, R and SP into the stack-shaped image. B=1 is now stored in
`savedRegisterB`. It restores the monitor SP from
`varcRestoreMonitorStackAfterExecution` and reconstructs the saved interrupt
Boolean from the captured `LD A,I` and `LD A,R` flag evidence.

The physical Z80 is once again a monitor machine. The user machine, including
its new B value, lives in memory.

## Stage 11: check the resulting execution address

The capture routine returns to the controller. The resulting logical PC is
extracted and checked against `setExecutionProtectedAreas` when instruction
controls are enabled:

```text
candidate PC = $8002
```

This check happens after execution. That historical order matters. If `$8002`
were protected, PROMETHEUS would report `Run ERROR` and refuse to commit the new
current address and timing, but B would already be 1 in the saved image. Any
memory or stack side effects would also already have happened.

For this example, `$8002` is permitted.

## Stage 12: apply any logical stack repair

The path flag is nonzero because the taken capture was used. The controller
therefore calls the self-modified post-flow callback:

```asm
varcPostTakenControlFlowCallback:
    call nz,noPostFlowStackAdjustment
```

For `DJNZ`, the callback is the no-op routine. A simulated CALL would replace the
scratch return word with the original sequential PC. A simulated RET would
advance saved SP by two. The controller does not need another opcode test here;
the control-flow handler chose the callback earlier.

## Stage 13: commit PC and time

Only after the RUN check and any stack repair does the controller commit the
step:

```asm
    ld (varcMonitorCurrentAddress+1),hl
    ld hl,(accumulatedTStates)
    add hl,de
    ld (accumulatedTStates),hl
```

The new visible state is:

```text
current address   $8002
B                 1
T-state total     old total + 13
```

The current address appears unchanged because the loop branches to itself. The
processor state proves that progress occurred: B has decreased and time has
advanced.

This is why a debugger cannot treat “same PC” as “nothing happened.”

## Stage 14: return redraw policy in carry

The controller falls into `testCapsShiftEnter`. That routine reuses the ROM
BREAK-key logic with the ENTER row selected. Its carry result means:

```text
carry set     ordinary case; caller may redraw according to its mode
carry clear   CAPS SHIFT+ENTER held; alter automatic-trace display policy
```

A manual caller can simply use the result. Slow trace redraws on carry set. Fast
trace redraws on carry clear. The step engine itself remains unaware of which
loop invoked it.

The processor is now ready for another instruction or for a panel repaint.

## What if B had been 1?

The scratch program would be identical:

```text
DI
DJNZ +3
JP sequential capture
JP taken capture
```

The real Z80 would decrement B from 1 to 0 and not take the branch. Execution
would fall into the sequential capture JP.

That capture path supplies:

```text
path flag    0
timing       8
logical PC   $8004
```

The callback is not invoked because the path flag is zero. The committed state
would become:

```text
B                 0
current address   $8004
timing added      8
```

The same generated code therefore handles both outcomes. PROMETHEUS prepares
possibilities; hardware selects reality.

## What if validation failed?

Suppose the instruction had been `LD (HL),A` and saved HL pointed into a protected
WRITE window.

The journey would stop before scratch execution:

```text
decode
predict effective address from saved HL
find protected WRITE collision
restore saved R for display
show Read/Write ERROR
return to monitor
```

The user processor image would not have been restored or executed.

HALT under saved DI is rejected in the same pre-execution phase, even when the
ordinary instruction controls switch is off.

## What if the resulting PC were protected?

A branch may pass all READ and WRITE checks but choose a protected RUN address.
Because the implementation checks RUN after capture:

```text
instruction executes
state is captured
candidate PC collides with RUN window
Run ERROR appears
PC and time are not committed
other side effects may remain
```

This is not the clean transaction one might design today. It is the behavior of
the original program and therefore part of the reconstruction.

## The controller in plain pseudocode

The complete engine can now be written without register noise:

```pseudocode
function step(address):
    decoded = decode(address)
    if decoded is unknown:
        return to monitor

    sequentialPC = decoded.nextAddress
    takenPC = sequentialPC
    operand = decoded.rawOperand
    baseTime = decoded.time

    rememberSavedRForErrorPath()
    validateHaltAndPredictedMemoryAccess(decoded)

    scratch = beginWithSavedDIorEI()
    scratch.copy(decoded.bytes)
    scratch.appendJump(sequentialCapture)
    scratch.appendJump(takenCapture)

    callback = noStackAdjustment
    takenTime = baseTime

    if decoded is dangerousControlFlow:
        rewriteScratchControlFlow(decoded, scratch)
        takenPC = calculateOriginalLogicalTarget(decoded)
        takenTime = calculateTakenTiming(decoded)
        callback = chooseCallOrReturnStackRepair(decoded)

    restoreCompleteUserProcessor()
    executeScratchOnRealZ80()
    result = captureCompleteUserProcessor()

    if controlsEnabled and result.logicalPC is RUN-protected:
        showRunErrorAfterSideEffects()

    if result.usedTakenPath:
        callback()

    currentAddress = result.logicalPC
    accumulatedTime += result.pathTime
    return capsShiftEnterDisplayPolicy()
```

This pseudocode is longer than the central source routine because many details
are compressed into tables, self-modified operands and shared helpers. But its
shape is straightforward.

## Why this is not an emulator

An emulator would implement the meaning of every instruction in software:

```pseudocode
B = B - 1
if B != 0:
    PC = PC + signedDisplacement
```

PROMETHEUS instead constructs:

```asm
DJNZ +3
JP sequentialCapture
JP takenCapture
```

The physical Z80 performs the decrement and decision. PROMETHEUS supplies safe
places for the two results to report themselves.

The monitor emulates only the context that copying would otherwise break:

- physical PC-relative destinations;
- absolute flow into uncontrolled memory;
- CALL and RET stack semantics;
- predicted protected memory ranges;
- logical timing and PC commitment.

This division of labour makes the engine compact enough for the Spectrum while
preserving real processor behavior for ordinary arithmetic, flags and memory
operations.

## Back to the whole machine

Part VI began with a front-panel register value sitting passively in memory. A
complete step now connects every layer:

```text
front-panel current address
    -> shared disassembler
    -> instruction metadata
    -> protection prediction
    -> generated scratch bytes
    -> restored saved processor
    -> real Z80 execution
    -> captured saved processor
    -> logical control-flow repair
    -> RUN policy
    -> committed PC and time
    -> front-panel redraw
```

The monitor can therefore lend the entire machine to another program for one
instruction and reliably take it back.

That completes the execution engine. We can now turn to the beginning of the
source file and understand a different kind of temporary surrender: before
PROMETHEUS can edit or trace anything, its installation image must discover
where it was loaded, move a small installer to `$5000`, copy the chosen resident
body, and repair every internal absolute address.

## What has changed in memory

For the taken `DJNZ` example, a successful step changes:

- scratch workspace, first into DI + copied instruction + capture jumps, then
  into the relative-flow rewrite;
- self-modified sequential and taken PC operands;
- self-modified base and taken timing operands;
- post-flow callback operand;
- saved complete processor image, especially B, R, interrupt state and SP;
- monitor current address, although it happens to remain `$8002`;
- accumulated T-state count.

The instruction does not change user memory or user SP.

## Important labels encountered

- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `decodeInstructionAtHL`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcDecodedInstructionOperandWord`
- `varcRestoreRBeforeOperationError`
- `validateInstructionBeforeExecution`
- `buildInstructionExecutionTrampoline`
- `controlFlowDescriptorTable`
- `matchInstructionAccessDescriptor`
- `tracedControlFlowHandlerOffsets`
- `simulateRelativeControlFlow`
- `varcTakenFlowTStates`
- `varcPostTakenControlFlowCallback`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`
- `setExecutionProtectedAreas`
- `noPostFlowStackAdjustment`
- `accumulatedTStates`
- `testCapsShiftEnter`

## Ideas needed by later chapters

- PROMETHEUS separates physical scratch flow from logical user-program flow.
- The shared decoder supplies next address, operand, metadata and base timing.
- Pre-execution validation predicts dangerous memory effects without executing.
- Control-flow handlers rewrite only physical return routes and logical repairs.
- The real Z80 chooses sequential or taken capture from real register/flag state.
- Capture serializes the complete processor before the monitor stack returns.
- RUN protection is historically post-execution.
- PC and timing are committed only after checks and any simulated stack repair.
