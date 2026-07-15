# Chapter 43: Saving a Complete Processor

Until now, the monitor has behaved like a careful observer. It has read bytes,
formatted registers, decoded instructions, searched memory and edited selected
locations. None of those jobs required PROMETHEUS to surrender control of the
Z80.

Single stepping is different.

To execute one instruction exactly as the inspected program would execute it,
PROMETHEUS must briefly let that program own the processor. The accumulator must
contain the user's accumulator, not the monitor's temporary value. The flags
must be the user's flags. Both ordinary and alternate register banks must be
restored. The stack pointer must point to the user's stack. Even the interrupt
state and refresh register matter.

This creates the central problem of Part VI:

> How can the monitor become another program for a moment, then return with a
> faithful picture of what happened?

The answer begins with a complete saved processor image.

## Two machines sharing one Z80

There is only one physical processor, but the monitor treats it as if two
logical machines take turns using it.

The first is the **monitor machine**. It has:

- PROMETHEUS's private stack;
- temporary register values used by monitor routines;
- screen and keyboard state;
- pointers into source, symbols and tables;
- callbacks patched into instructions.

The second is the **user machine**. It has:

- the register values shown on the front panel;
- the user's stack pointer;
- the user's interrupt state;
- a logical program counter represented by the monitor's current address;
- an accumulated execution-time count.

When the monitor is waiting for a key, the physical Z80 contains monitor-machine
state. The user-machine state lives in memory.

When an instruction is executed, those roles reverse:

```text
before execution
    physical Z80 = monitor state
    memory image = user state

restore
    physical Z80 = user state
    monitor stack address remembered in patched code

execute one prepared instruction

capture
    memory image = new user state
    physical Z80 = temporary capture state

restore monitor stack
    physical Z80 = monitor state again
```

The saved image is therefore not a backup made only in emergencies. It is the
normal home of the user processor whenever PROMETHEUS is in control.

## The saved image is shaped like a stack

Near the end of the resident payload is a compact block beginning at
`savedRegisterR`:

```asm
savedRegisterR:
    defb 000h
savedRegisterI:
    defb 000h
savedAlternateRegisterSet:
    defs 8
savedRegisterIY:
    defb 03ah
savedRegisterIYHigh:
    defb 05ch
savedRegisterIX:
    defb 000h
savedRegisterIXHigh:
    defb 000h
savedRegisterBC:
    defb 0ffh
savedRegisterB:
    defb 0afh
savedRegisterDE:
    defb 001h
savedRegisterD:
    defb 001h
savedRegisterHL:
    defb 000h
savedRegisterH:
    defb 000h
savedRegisterAF:
    defb 000h
savedRegisterA:
    defb 000h
savedRegisterSP:
    defw 0
accumulatedTStates:
    defw 0
monitorAddressX:
    defw 0
monitorAddressY:
    defw 0
```

The apparently odd order is deliberate. The register portion can be consumed by
a sequence of Z80 `POP` instructions.

A clearer map is:

```text
offset  size   saved value
------  ----   --------------------------------
  0       1    R
  1       1    I
  2       2    BC'
  4       2    DE'
  6       2    HL'
  8       2    AF'
 10       2    IY
 12       2    IX
 14       2    BC
 16       2    DE
 18       2    HL
 20       2    AF
 22       2    SP
 24       2    accumulated T states
 26       2    monitor address X
 28       2    monitor address Y
```

The first two bytes form one convenient word for restoration: when popped into
`HL`, `L` receives R and `H` receives I. After that, every register pair is
already arranged in stack byte order.

This is a good example of a data structure designed around the instructions that
will consume it. A modern program might define a record and write separate load
operations for every field. PROMETHEUS arranges the record so that most of it can
be restored by moving `SP` to the block and popping.

## Little-endian words and useful aliases

On the Z80, a word stored in memory places its low byte first. The saved word
`BC` therefore appears as:

```text
savedRegisterBC   = C
savedRegisterB    = B
```

Likewise:

```text
savedRegisterDE   = E
savedRegisterD    = D
savedRegisterHL   = L
savedRegisterH    = H
savedRegisterAF   = F
savedRegisterA    = A
```

These labels are not duplicated storage. They are names for different byte
positions inside the same words.

That matters to the front panel. A descriptor for register A can point directly
to `savedRegisterA`, while a descriptor for AF can point to `savedRegisterAF` and
request a two-byte display.

The same memory can therefore support both views:

```text
A  = $3E
F  = $45
AF = $3E45
```

without copying or rearranging anything.

## The program counter is kept elsewhere

You may have noticed that the saved image contains no field named PC.

The Z80 does not provide an ordinary instruction such as `LD HL,PC`. More
importantly, PROMETHEUS already has a natural place for the logical program
counter: the monitor's current address.

The self-modified operand at `varcMonitorCurrentAddress` serves several jobs:

- it is the address around which the front panel is drawn;
- it is the start address for instruction-oriented navigation;
- it is the address passed to `stepInstructionAtHL`;
- after a successful step, it becomes the captured next PC.

So the user's logical machine is split across two nearby forms of state:

```text
saved processor image    registers, SP, I, R, time and monitor X/Y
current monitor address  logical PC
interrupt-state operand  logical DI/EI state
```

This split is practical rather than theoretically pure. The monitor already
needs a current address even when no instruction is being executed, so using it
as the saved PC avoids another word and keeps inspection and execution focused on
the same location.

## The interrupt state is an executable byte

The interrupt-enable state is not stored inside the contiguous register block.
It lives in the immediate operand of this instruction:

```asm
varcInterruptEnableState:
    ld a,000h
```

The convention is:

```text
0 = interrupts disabled, DI
1 = interrupts enabled, EI
```

The front-panel renderer reads that operand and converts it into the displayed
mnemonic. The execution-trampoline builder reads the same operand and turns it
into a real instruction byte.

The conversion is compact:

```asm
ld a,(varcInterruptEnableState+1)
add a,a
add a,a
add a,a
add a,0f3h
```

For zero, the result is `$F3`, the opcode for `DI`.
For one, the result is `$FB`, the opcode for `EI`.

In pseudocode:

```text
interruptOpcode = $F3 + 8 * savedInterruptBoolean
```

This works because the two opcodes happen to differ by eight.

Again, one byte has several roles:

- remembered user state;
- panel data;
- input to trampoline construction.

## Editing saved state without touching the physical registers

Chapter 34 showed that front-panel items refer to memory. When the user edits A,
HL, SP or another register, PROMETHEUS changes the saved image, not the monitor's
current working register.

This is essential. Suppose the monitor used its physical `HL` while parsing the
new value of the user's HL register. If it then wrote the result only into the
physical register, the value would be lost as soon as the command returned and
the monitor used HL for something else.

Instead:

```text
read new value
    -> locate descriptor's saved-value address
    -> store into saved processor image
    -> later restoration loads it into the real register
```

The user is editing the next processor state that will be restored.

The same principle explains `monSwapPrimaryAndAlternateRegisters`. It does not
execute `EXX` or `EX AF,AF'`, because those instructions would exchange the
monitor's live registers. It swaps two eight-byte memory areas:

```asm
monSwapPrimaryAndAlternateRegisters:
    ld b,008h
    ld hl,savedRegisterBC
    ld de,savedAlternateRegisterSet
.swapNextPrimaryAlternateRegisterByte:
    ld c,(hl)
    ld a,(de)
    ld (hl),a
    ld a,c
    ld (de),a
    inc hl
    inc de
    djnz .swapNextPrimaryAlternateRegisterByte
    ret
```

The command exchanges saved `BC/DE/HL/AF` with saved
`BC'/DE'/HL'/AF'`. IX, IY, SP, I, R and the interrupt state remain unchanged.

This is safer and conceptually cleaner than disturbing the monitor machine.

## Restoring the register image

The actual restoration routine is
`restoreUserStateAndExecuteTrampoline`. Its first half is a carefully ordered
unpacking operation:

```asm
ld sp,savedRegisterR
pop hl
ld a,l
ld r,a
ld a,h
ld i,a
pop bc
pop de
pop hl
pop af
exx
ex af,af'
pop iy
pop ix
pop bc
pop de
pop hl
pop af
ld sp,(savedRegisterSP)
jp encodedRecordStorageLength
```

Let us read this slowly.

### 1. Remember the monitor stack

Before `SP` is changed, its current value is written into the operand of a later
instruction:

```asm
ld (varcRestoreMonitorStackAfterExecution+1),sp
```

That patched operand is the route home. Once the user's SP has been loaded, the
normal monitor call stack no longer exists as the active stack.

### 2. Point SP at the saved image

```asm
ld sp,savedRegisterR
```

Now `POP` instructions read the saved record.

### 3. Restore R and I

The first word is popped into HL:

```text
L = saved R
H = saved I
```

The values are moved through A because the Z80 loads I and R only through A:

```asm
ld a,l
ld r,a
ld a,h
ld i,a
```

### 4. Restore the alternate bank

The next four pops obtain saved `BC'`, `DE'`, `HL'` and `AF'`. At first they are
physically in the currently visible bank. Then:

```asm
exx
ex af,af'
```

moves them into the architectural alternate banks.

### 5. Restore index and primary registers

The next values are popped into IY, IX, BC, DE, HL and AF.

### 6. Restore the user's stack

Finally:

```asm
ld sp,(savedRegisterSP)
```

The user's stack is active. From this point the routine cannot safely `CALL` or
`RET` through the monitor stack. It jumps directly to the scratch program.

The restoration algorithm is therefore:

```text
remember monitor SP
correct saved R for upcoming monitor/trampoline fetches
SP = address of saved image
restore R and I
restore alternate register bank
restore IY and IX
restore primary register bank
SP = saved user SP
jump to prepared scratch instruction
```

## Why R needs correction

The refresh register R is unusual. Its low seven bits are incremented by
instruction fetches. Merely passing through the monitor's restoration and
capture code changes it.

PROMETHEUS wants the saved R value to describe the user program as closely as
possible, not the number of monitor instructions executed while arranging the
experiment.

The helper `adjustSavedRefreshRegisterLow7` adds a correction to bits 0..6 while
preserving bit 7:

```asm
adjustSavedRefreshRegisterLow7:
    ld hl,savedRegisterR
    add a,(hl)
    xor (hl)
    and 07fh
    xor (hl)
    ld (hl),a
    ret
```

This sequence may look mysterious, but its purpose can be stated simply:

```text
new low seven bits = old low seven bits + correction
new bit 7          = old bit 7
```

Different paths use different correction constants because they execute
different numbers of fetches before or after the user instruction. The exact
constants are implementation bookkeeping, not part of the user's program.

The important idea is that R cannot be saved and restored naively if the monitor
wants a believable traced value.

## Capturing the user's state again

After the prepared instruction runs, it jumps into one of the capture entries.
At that moment:

- primary registers contain the user's results;
- alternate registers contain the user's alternate results;
- SP is the user's resulting SP;
- I and R are live architectural registers;
- the monitor stack is inactive.

The capture code must serialize all of that before returning to ordinary monitor
code.

The first action is:

```asm
ld (savedRegisterSP),sp
```

This records the user's resulting stack pointer.

Then PROMETHEUS temporarily uses its scratch workspace as a small stack while it
collects AF, I and R. It issues `DI` before restoring monitor ownership, so an
interrupt cannot arrive halfway through the delicate bank and stack exchange.

Later `.saveRemainingUserState` pushes values into the saved-image area in the
reverse order needed by the restoration pops:

```asm
push bc
push ix
push iy
exx
ex af,af'
push af
push hl
push de
push bc
ld a,i
ld h,a
ld a,r
ld l,a
push hl
```

Because `SP` has been positioned at the end of the register area, these pushes
fill the image backward until R and I occupy its first two bytes.

The broad capture algorithm is:

```text
save resulting user SP
preserve primary AF, HL and DE
collect I and R plus their flags
save primary BC, IX and IY
switch to alternate banks
save AF', HL', DE' and BC'
save I and R at the start of the image
restore monitor SP
repair saved R
recover logical interrupt state
return to monitor code
```

## Capturing interrupt enable without reading IFF directly

The Z80 has no ordinary instruction that copies its interrupt flip-flop directly
into a general register. `LD A,I` and `LD A,R`, however, copy the interrupt-enable
state into the P/V flag under normal conditions.

PROMETHEUS uses both instructions during capture and stores their flags in a
small temporary area near the shared input buffer. It then ORs the relevant flag
bytes and reduces bit 2 to Boolean zero or one:

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

Conceptually:

```text
pv = PV flag observed while reading I or R
savedInterruptBoolean = pv ? 1 : 0
```

The source comments correctly describe this as an approximation of the user's
interrupt state. It is a clever use of the information the Z80 makes available,
but it is not a magical direct read of every hidden interrupt latch.

For the book's mental model, the important result is stable:

- the panel can show DI or EI;
- the user can toggle it;
- the next scratch program begins with the corresponding opcode;
- capture updates the remembered state after execution.

## Sequential and taken capture entries

There are two ordinary capture entrances:

- `captureUserStateAfterSequentialFlow`;
- `captureUserStateAfterTakenFlow`.

They serialize registers in the same way. Their difference is the logical result
they attach to the step.

The sequential entry supplies:

- path flag 0;
- the decoder's ordinary T-state count;
- the address immediately after the original instruction.

The taken entry supplies:

- path flag 1;
- a handler-adjusted taken-path T-state count;
- the actual branch, call, return or indirect-jump destination.

That distinction is not needed for an instruction such as `INC A`; it always
falls through. It becomes vital for conditional control flow. Chapter 46 will
show how the scratch instruction is rewritten so either outcome lands in the
right capture entry.

There is also `breakpointHitCaptureEntry`, which intentionally falls into the
sequential capture layout. Chapter 44 will explain why a single `NOP` is enough
to make a temporary breakpoint share the same state serializer.

## What the saved image does not promise

It is tempting to call this a perfect frozen Z80. That would be too strong.

PROMETHEUS saves the state required by its monitor model, but some architectural
and environmental details are outside the image:

- PC is represented separately by the current monitor address;
- the interrupt state is reconstructed through available flags;
- interrupt mode itself is not presented as a separately saved editable field;
- external devices and ULA state are not rolled back;
- memory changes made by an executed instruction remain changes;
- an interrupt or hardware event may have consequences beyond the register
  image.

This is still an impressively complete processor snapshot for a compact 48K
monitor. The design captures every ordinary register bank, index registers, SP,
I, R, flags, logical interrupt enable and time accounting needed by the stepping
engine.

## The complete state round trip

We can now state the whole mechanism in pseudocode:

```text
function executePreparedExperiment():
    monitorSP = SP

    adjustSavedRForRestorationPath()

    R, I = saved.R, saved.I
    BC', DE', HL', AF' = saved.alternateRegisters
    IY, IX = saved.IY, saved.IX
    BC, DE, HL, AF = saved.primaryRegisters
    SP = saved.SP

    jump scratchProgram

captureEntry:
    saved.SP = SP
    preserve user results
    disable monitor-time interrupts

    saved.primaryRegisters = BC, DE, HL, AF
    saved.IX, saved.IY = IX, IY
    saved.alternateRegisters = BC', DE', HL', AF'
    saved.I, saved.R = I, R

    SP = monitorSP
    correctSavedRForCapturePath()
    saved.interruptEnabled = deriveFromCapturedFlags()

    return to monitor controller
```

The scratch program in the middle is deliberately left vague here. It may
contain one copied ordinary instruction, a rewritten branch, a native CALL or a
native jump toward a temporary breakpoint. Chapters 44 and 45 build those forms.

## Back to the whole machine

The front panel is now more than a display. It is the visible editor for a
processor image that PROMETHEUS can materialize into the real Z80.

The cycle is:

```text
front-panel values
    -> saved processor image
    -> POP-based restoration
    -> real instruction execution
    -> PUSH-based capture
    -> saved processor image
    -> front-panel values
```

The physical processor belongs to the monitor most of the time. During a small,
controlled interval it belongs to the user's program. The stack-shaped saved
image is the doorway between those two worlds.

## What has changed in memory

After a captured instruction:

- saved primary and alternate registers contain the user's resulting values;
- saved IX, IY, SP, I and R are updated;
- `varcInterruptEnableState+1` contains the reconstructed DI/EI Boolean;
- the logical PC has not yet necessarily been committed—commit occurs in the
  higher-level step controller after RUN checking;
- `accumulatedTStates` is updated only after a successful committed step;
- memory effects performed by the instruction already exist.

## Important labels encountered

- `savedRegisterR`
- `savedRegisterI`
- `savedAlternateRegisterSet`
- `savedRegisterIY`
- `savedRegisterIX`
- `savedRegisterBC`
- `savedRegisterDE`
- `savedRegisterHL`
- `savedRegisterAF`
- `savedRegisterSP`
- `accumulatedTStates`
- `monitorAddressX`
- `monitorAddressY`
- `varcInterruptEnableState`
- `monSwapPrimaryAndAlternateRegisters`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`
- `adjustSavedRefreshRegisterLow7`
- `interruptStateCaptureScratch`

## Ideas needed by later chapters

- The user processor normally exists as a memory image.
- PC is represented by the monitor's current address rather than by a field in
  the contiguous register block.
- The monitor must remember its own SP before activating the user's SP.
- Restoration is arranged as POP operations; capture is arranged as PUSH
  operations.
- DI/EI is stored as a Boolean in an instruction operand and emitted as the first
  byte of every scratch program.
- Different capture entries can share register serialization while supplying
  different logical PCs and timings.
