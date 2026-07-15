# Chapter 48: Time, Interrupts and Trace Modes

Once PROMETHEUS can execute one instruction safely, three questions remain:

1. How much processor time should that instruction add to the counter?
2. What interrupt state should the user program see?
3. How can one step be repeated slowly or quickly without losing control of the
   keyboard and display?

These questions are connected more closely than they first appear. The two
capture exits carry not only two possible PCs, but also two possible timings.
The scratch program begins with the saved DI or EI state. The stepping routine
returns a keyboard-chord result that tells an automatic trace whether to repaint
the front panel.

PROMETHEUS turns one carefully controlled step into several user-visible execution
modes.

## What is a T state?

A Z80 instruction does not take an abstract “one step.” It consumes a number of
clock periods called **T states**.

Simple instructions may have one fixed cost:

```text
NOP       4 T states
INC B     4 T states
LD A,n    7 T states
```

Conditional and repeated instructions may have more than one cost:

```text
JR NZ,d   one cost when not taken,
          five extra T states when taken

LDIR      repeats according to BC
```

PROMETHEUS keeps a sixteen-bit accumulated counter in
`accumulatedTStates`. The front panel can display and edit it like other saved
words.

The counter is not a wall clock. It is a model built from instruction metadata
and a few path-specific adjustments.

## Timing begins in the instruction table

The shared instruction table used by assembly and disassembly also carries a
small timing field. During decode, the low five timing bits are copied into a
self-modified accessor:

```asm
varcDecodedInstructionTStates:
    ld de,00004h
```

The high byte is cleared, so an ordinary timing begins as a sixteen-bit value:

```text
DE = base timing
```

For an instruction with only one path, this value reaches sequential capture and
is later added to the cumulative counter.

This reuse is important. PROMETHEUS does not maintain a separate timing database
beside the instruction decoder. The decoder's instruction identity supplies the
base value used by tracing.

## Two exits can carry two timings

The sequential capture entry uses the base timing:

```asm
varcDecodedInstructionTStates:
    ld de,00004h
varcSequentialNextAddress:
    ld hl,00000h
```

The taken capture entry uses handler-patched values:

```asm
varcTakenFlowTStates:
    ld de,00000h
varcTakenFlowNextAddress:
    ld hl,00000h
```

Thus each capture exit carries a pair:

```text
sequential exit -> sequential PC, sequential time
taken exit      -> taken PC, taken time
```

The instruction itself chooses the exit. The real Z80 condition therefore also
chooses the timing without PROMETHEUS separately evaluating flags.

## Adjusting conditional timings

Control-flow handlers begin with the base timing in A. They adjust only the
families that need a different taken cost.

For relative branches, Chapter 46 showed the exact adjustment:

```asm
add a,005h
```

The not-taken path keeps the base table value. The taken path receives five more
T states.

CALL and related absolute-flow handlers make compact adjustments to distinguish
taken and not-taken behavior. Rather than storing another complete table, the
handler modifies the low-byte timing values already supplied by the decoder.

The important design principle is:

```text
instruction table stores common/base timing
flow handler stores only the difference required by a path
```

This saves data while still allowing the two capture entrances to report
different costs.

## Repeated block timing

`LDIR` and `LDDR` are special because their duration depends on the saved BC
value. The memory-validation path calculates:

```text
21 * BC - 5
```

and writes the result back into `varcDecodedInstructionTStates` before execution.

The repeated instruction then runs as one real Z80 operation. The counter receives
the modeled cost of the whole repetition, not one iteration.

This is one reason memory prediction and timing prediction share code: both need
the same BC count and need to recognize the repeated ED opcodes specially.

## Direct CALLs deliberately break complete timing

In CALL NON mode, a CALL is simulated through the capture engine. Its outer
instruction timing is modeled, and later steps can trace instructions inside the
called routine one at a time.

In CALL DEF or ALL mode, an accepted routine runs natively until it returns to
the scratch trampoline. PROMETHEUS does not see its internal instructions.

Consequently:

```text
counted:     the outer CALL/RST timing chosen by the handler
not counted: the body of the directly executed routine
```

The front-panel T-state counter is therefore unreliable as a complete program
time measurement while direct execution is enabled.

This is not an accidental oversight. It is the explicit price of the faster
mode.

## Committing time only after a successful step

After capture and RUN checking, the stepping controller commits both PC and time:

```asm
ld (varcMonitorCurrentAddress+1),hl
ld hl,(accumulatedTStates)
add hl,de
ld (accumulatedTStates),hl
```

The chosen path-specific timing is in DE.

The order matters. A post-execution Run ERROR prevents the addition, even though
register or memory effects may already have occurred. This creates the mismatch
explained in Chapter 47:

```text
instruction side effects may exist
but
PC and T-state counter remain uncommitted
```

The counter is sixteen-bit. It wraps naturally from `$FFFF` to `$0000`. There is
no overflow warning or wider hidden total.

## The saved interrupt state is a Boolean

The monitor stores the user's interrupt choice in one self-modified byte:

```text
0  DI
1  EI
```

`SYMBOL SHIFT+M` toggles it:

```asm
monToggleInterruptEnableState:
    ld hl,varcInterruptEnableState+1
    jr .invertLogicAtHLAndRet_
```

The front panel reads the same byte to show DI or EI. The stepping engine reads it
to begin the scratch program.

A single state value therefore connects:

- user command;
- panel display;
- HALT safety check;
- generated execution trampoline.

## Turning the Boolean into a real opcode

`beginExecutionTrampoline` maps 0 or 1 to `$F3` or `$FB`:

```asm
ld a,(varcInterruptEnableState+1)
add a,a
add a,a
add a,a
add a,0f3h
ld (hl),a
```

The arithmetic is:

```text
0 * 8 + $F3 = $F3 = DI
1 * 8 + $F3 = $FB = EI
```

This opcode is executed immediately before the copied or rewritten user
instruction.

The monitor itself must disable interrupts while changing stacks and serializing
state. Emitting the user's choice at the beginning of the scratch code restores
the logical state at the last practical moment.

## The EI delay belongs to the real processor

On a Z80, interrupts do not become active immediately at the exact moment EI is
fetched. They become eligible after the following instruction.

Because PROMETHEUS emits a real EI followed by the real copied instruction, it
inherits that hardware rule naturally:

```text
EI
copied user instruction
capture jump
```

The stepper does not need to invent an EI-delay flag in software. The real Z80
performs the correct sequence.

This is another benefit of the hybrid design.

## Capturing interrupt state again

After the instruction, the capture routine uses `LD A,I` and `LD A,R`. These
instructions report interrupt-state information through the P/V flag.
PROMETHEUS temporarily preserves their accumulator/flag results on the scratch
stack, restores the monitor stack, and combines the relevant flag bits:

```asm
ld hl,interruptStateCaptureScratch
ld a,(hl)
dec hl
dec hl
or (hl)
and 004h
rrca
rrca
ld (varcInterruptEnableState+1),a
```

The result is reduced back to Boolean 0 or 1.

The source comments describe this as an approximation of the user's interrupt
enable state. The Z80 has two interrupt flip-flops and instructions such as
RETN have special restoration behavior. PROMETHEUS stores only the simple state
needed for its panel and next trampoline.

For ordinary tracing this compact representation is highly practical. For exact
RETN/RETI semantics it leaves the uncertainty recorded in Chapter 46.

## The refresh register is corrected

The Z80 R register advances as instructions are fetched. PROMETHEUS itself and
the scratch trampoline execute extra opcodes around the user instruction, so a
raw captured R would include monitor overhead.

`adjustSavedRefreshRegisterLow7` compensates for known fetches while preserving
bit 7, whose behavior differs from the low seven-bit counter.

The correction occurs:

- before restoring the user state;
- after capturing it;
- on error paths where a rejected operation should not appear to have advanced
  R.

The result is still a carefully modeled view, not a magical suspension of all
hardware activity. But it is much closer to the value the user instruction would
have produced by itself.

## One step as a monitor command

`SYMBOL SHIFT+Z` executes one instruction at the current monitor address. The
entry is small:

```asm
stepAtCurrentMonitorAddress:
    ld hl,(varcMonitorCurrentAddress+1)
```

It falls directly into `stepInstructionAtHL`, whose complete lifecycle now spans
Chapters 43–48:

```text
decode
validate
build scratch instruction
rewrite control flow
restore user state
execute
capture
check RUN address
repair logical stack
commit PC and T states
return keyboard-chord status
```

The last item is what allows the same routine to power automatic tracing.

## A clever alternate use of the ROM BREAK routine

At the end of a successful step, the engine does not simply return. It enters a
Spectrum ROM keyboard routine at an internal point:

```asm
testCapsShiftEnter:
    ld a,0bfh
    jp 01f56h
```

The normal ROM BREAK check loads the keyboard row containing SPACE. Entering at
`$1F56` skips that load. PROMETHEUS supplies `$BF`, selecting the ENTER row while
the remaining ROM code still checks CAPS SHIFT.

The returned carry flag means:

```text
carry clear  CAPS SHIFT+ENTER is held
carry set    it is not held
```

The stepping routine therefore returns both “the step succeeded” and “what does
the user currently want the trace display to do?” through the normal flags.

## Slow trace

The `T` command repeatedly steps and normally redraws the panel:

```asm
monSlowTracing:
    call stepAtCurrentMonitorAddress
    call c,redrawFrontPanelAtCurrentAddress
    call ROM_BreakKey
    jr c,monSlowTracing
```

Because carry is set when CAPS SHIFT+ENTER is *not* held:

```text
normal operation:
    redraw after every instruction

hold CAPS SHIFT+ENTER:
    suppress redraw and run faster
```

After each step, the ordinary ROM BREAK test looks for CAPS SHIFT+SPACE. If BREAK
is not pressed, the loop continues.

When trace stops, `waitForAllKeysReleased` waits until the keyboard matrix is
clear. Without this, the stopping chord could immediately become a new monitor
command.

Slow trace is therefore a repeated single step with an optional display throttle.
It does not have a separate execution engine.

## Fast trace to an address

`SYMBOL SHIFT+T` asks for `Last` and repeats the same one-step routine:

```asm
monFastTracingToAddress:
    call promptForMonitorValue
    defb 0xc3
    ld (varcFastTraceStopAddress+1),hl
.fastTraceNextInstruction:
    call stepAtCurrentMonitorAddress
    call nc,redrawFrontPanelAtCurrentAddress
```

Here the display rule is reversed:

```text
normal operation:
    do not redraw

hold CAPS SHIFT+ENTER:
    redraw after the current step
```

Fast trace is intended to cover many instructions quickly, with the panel shown
only when requested.

After every step it compares the newly committed current address with `Last`:

```asm
ld hl,(varcMonitorCurrentAddress+1)
varcFastTraceStopAddress:
    ld de,00000h
or a
sbc hl,de
ret z
```

The comparison is post-step. Therefore:

- `Last` is a stop condition on the resulting PC;
- if the initial PC already equals `Last`, one instruction is still executed;
- the trace stops after an instruction arrives at `Last`, not before executing
  an instruction located there in every possible interpretation.

BREAK is also checked between steps.

## Slow and fast trace are display policies

The two modes can be understood without imagining two tracing engines:

```text
slow trace:
    step
    usually redraw
    BREAK?
    repeat

fast trace:
    step
    usually do not redraw
    resulting PC == Last?
    BREAK?
    repeat
```

Both inherit every behavior of one step:

- instruction decoding;
- READ/WRITE/RUN protection;
- CALL modes;
- HALT-under-DI rejection;
- control-flow rewriting;
- interrupt capture;
- T-state accumulation;
- all original edge cases.

This reuse reduces code size and makes the modes consistent.

## Instruction controls during trace

The READ/WRITE/RUN switch is global to the stepping engine. Slow trace, fast
trace, and manual one-step all read the same inverse byte.

With controls ON:

```text
READ and WRITE predicted before execution
RUN checked after capture
HALT under DI rejected
```

With controls OFF:

```text
READ, WRITE, RUN tables skipped
HALT under DI still rejected
```

Turning controls off may make experimentation easier, but it also lets traced
code damage the monitor or enter arbitrary regions. The dynamic hidden resident
range ceases to be enforced by these instruction checks as well.

## Direct CALL mode during trace

The NON/DEF/ALL setting is also shared by all step and trace modes.

In slow trace, a direct subroutine may make the apparent step pause for a long
time before the panel redraws. In fast trace, it may run an arbitrarily large
body without any intermediate stop. In both cases its internal instructions:

- cannot be interrupted by the monitor's per-step BREAK check;
- do not contribute to the T-state total;
- do not encounter trace protection windows.

The mode display is therefore not cosmetic. It changes the supervision boundary.

## A complete timing example

Consider this loop:

```asm
LOOP:   DEC B
        JR NZ,LOOP
```

Suppose B begins at 3.

The real Z80 executes and PROMETHEUS records:

```text
DEC B        fixed table timing
JR NZ taken  base JR timing + 5
DEC B        fixed table timing
JR NZ taken  base JR timing + 5
DEC B        fixed table timing
JR NZ not    base JR timing
```

The condition is never evaluated by monitor code. Each copied JR selects the
physical exit according to the real Z flag. That exit supplies the corresponding
time.

At the same time, the logical PC alternates between:

```text
address after DEC
LOOP target after taken JR
address after final JR when not taken
```

PC and timing are two parallel products of the same captured path.

## Where the model is exact—and where it is not

Within its intended design, PROMETHEUS models many timings neatly:

- fixed instruction timing from the shared table;
- taken relative-branch difference;
- conditional absolute-flow differences;
- complete LDIR/LDDR timing;
- sequential versus taken path selection by real hardware flags.

But the counter is not guaranteed to equal elapsed machine time in every
situation:

- direct CALL/RST bodies are omitted;
- interrupt activity is not represented as a full event timeline;
- monitor and display overhead are deliberately excluded;
- post-execution Run Error suppresses timing commitment after side effects;
- uncertain RETN/RETI semantics remain uncertain;
- the sixteen-bit total wraps.

The counter is best understood as **traced user-instruction T states according to
PROMETHEUS's execution model**.

## Back to the whole machine

We can now describe the three execution modes with one core:

```text
manual step
    one call to stepInstructionAtHL

slow trace
    repeat the same call
    redraw unless CAPS SHIFT+ENTER is held

fast trace
    repeat the same call
    do not redraw unless CAPS SHIFT+ENTER is held
    stop when resulting PC equals Last
```

Inside each step:

```text
base timing comes from decoder metadata
control-flow handler selects any taken adjustment
block-transfer validator may replace timing entirely
scratch begins with saved DI/EI
capture reconstructs saved state
RUN check decides whether PC and timing are committed
```

The next chapter will follow one complete single step from the first byte decode
to the final panel-ready state, reconnecting every mechanism from Part VI.

## What has changed in memory

A successful traced instruction may change:

- the complete saved processor image;
- saved interrupt Boolean;
- corrected saved R value;
- logical current address;
- sixteen-bit accumulated T-state count;
- user memory and user stack according to the real instruction;
- scratch workspace and self-modified flow/timing operands.

Slow and fast trace additionally patch or read:

- fast-trace stop address;
- instruction-controls byte;
- direct CALL mode opcode;
- display-control chord state.

## Important labels encountered

- `varcDecodedInstructionTStates`
- `varcTakenFlowTStates`
- `accumulatedTStates`
- `varcInterruptEnableState`
- `beginExecutionTrampoline`
- `adjustSavedRefreshRegisterLow7`
- `interruptStateCaptureScratch`
- `testCapsShiftEnter`
- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `monSlowTracing`
- `monFastTracingToAddress`
- `varcFastTraceStopAddress`
- `monToggleInterruptEnableState`
- `monToggleInstructionControls`
- `monCycleDirectCallMode`
- `waitForAllKeysReleased`

## Ideas needed by later chapters

- The instruction table supplies base timing; handlers store only differences.
- Sequential and taken exits carry both logical PC and timing.
- The saved interrupt state is a Boolean converted to real DI/EI opcode bytes.
- The real Z80 naturally supplies EI-delay behavior.
- R is corrected for known monitor/trampoline fetch overhead.
- Slow and fast trace are loops around the same one-step engine.
- CAPS SHIFT+ENTER changes redraw policy, not execution semantics.
- Direct CALL modes and post-execution RUN errors limit timing accuracy.
