# Chapter 44: Breakpoints and Native Calls

Single stepping keeps PROMETHEUS close to every instruction. It decodes the
instruction, checks its memory effects, prepares a controlled copy, executes it
and immediately captures the result.

Sometimes that is not what the user wants.

A subroutine may be long but already trusted. A program may need to run at full
speed until it reaches a particular address. In those cases the monitor provides
two more direct operations:

- call one subroutine with the saved user state;
- run natively until a temporary breakpoint is reached.

Both operations use the saved processor image from Chapter 43, but they loosen
the monitor's control. They do not inspect every instruction inside the called
or running code. They rely on ordinary Z80 control flow to bring execution back.

This chapter explains those two escape routes and the risks they accept.

## Native execution versus traced execution

It helps to name the distinction clearly.

A **traced** instruction is supervised:

```text
decode
check
copy or rewrite
execute in scratch RAM
capture immediately
```

A **native** operation gives the user program a longer turn:

```text
restore saved state
CALL or JP into user code
let ordinary machine code run
return only through a promised route
capture state
```

During native execution PROMETHEUS does not:

- check every memory read or write;
- enforce RUN windows inside the called code;
- count each instruction's T states;
- regain control after every instruction;
- protect itself from a program that jumps somewhere unexpected.

Native execution is faster and more natural for trusted code, but it is less
contained.

## Calling one user subroutine

SYMBOL SHIFT+H invokes `monCallSubroutineWithSavedState`. The command prompts for
an address and passes it to a common trampoline builder:

```asm
monCallSubroutineWithSavedState:
    call promptForMonitorValue
    defb 0cch
    ex de,hl
    ld c,0cdh
```

The important values are:

```text
C  = $CD, the opcode for CALL nn
DE = requested subroutine address
```

The following routine writes a tiny executable program into scratch memory:

```asm
executeNativeCallOrJumpThroughTrampoline:
    call beginExecutionTrampoline
    ld (hl),c
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    call appendSequentialAndTakenCaptureJumps
    jp restoreUserStateAndExecuteTrampoline
```

For a subroutine call, the scratch program has this shape:

```text
DI or EI
CALL target
JP captureUserStateAfterSequentialFlow
JP captureUserStateAfterTakenFlow
```

The second jump is present because the builder is shared with the stepping
engine. A normal native CALL returns to the byte immediately after its three-byte
instruction, which is the first appended jump. It therefore reaches the
sequential capture entry.

The actual flow is:

```text
restore user registers and SP
    -> execute CALL target
       -> user subroutine runs natively
       -> user's RET returns into scratch RAM
    -> JP sequential capture
    -> save resulting user registers and SP
    -> restore monitor stack
    -> return to monitor
```

The subroutine sees the user processor exactly as represented on the front panel.
Its register results are captured back into that image.

## Why the user's SP must be valid

A real `CALL` writes a return address to the active stack. By the time the CALL
runs, `restoreUserStateAndExecuteTrampoline` has loaded:

```asm
ld sp,(savedRegisterSP)
```

The return address is therefore pushed onto the user's stack, not a private
monitor stack.

The saved SP must point to writable RAM with room for at least one word. If it
points into ROM, screen data that should not be changed, PROMETHEUS itself, or an
invalid top-of-memory position, the native call may fail or corrupt memory.

The monitor does not silently substitute a safe stack because that would change
the subroutine's environment. Code that reads or modifies SP should see the
value the user selected.

This is a general debugger tension:

> A faithful environment may be less safe than an artificial one.

PROMETHEUS chooses faithfulness for this command and warns the user instead.

## What a native CALL does not count

The subroutine body is not traced. `accumulatedTStates` therefore does not gain
the time spent inside it.

The scratch CALL and return-to-capture path are implementation machinery, not a
sequence that the timing model tries to account for instruction by instruction.
The command is a convenience for invoking code, not a timing experiment.

The same principle later applies when traced CALL/RST policy allows selected
routines to execute directly. Direct calls improve speed, but the monitor loses
visibility into their internals.

## Running until a temporary breakpoint

The breakpoint operation uses two commands sharing one handler:

- W remembers the native run start address;
- SYMBOL SHIFT+U places a temporary breakpoint at the current monitor address
  and starts running from the remembered W address.

The shared entry begins:

```asm
monSetBreakpointRunStartOrExecute:
    cp 077h
    jr nz,monRunToTemporaryBreakpoint
    ld (varcBreakpointRunStartAddress+1),hl
    ret
```

When the normalized key code is W (`$77`), the current address in HL is written
into the immediate operand of a later `LD DE,nn` instruction.

No program memory changes yet. W merely says:

```text
next native run should begin here
```

The user can then navigate elsewhere and select the breakpoint address.

## A breakpoint is a three-byte JP

SYMBOL SHIFT+U enters `monRunToTemporaryBreakpoint` with HL equal to the current
monitor address—the place where execution should stop.

PROMETHEUS saves exactly three bytes from that address:

```asm
ld de,savedBreakpointOriginalBytes
call copyThreeBytesFromHLToDE
```

It then replaces them with:

```asm
JP breakpointHitCaptureEntry
```

The emitted bytes are:

```text
$C3  low(capture address)  high(capture address)
```

The patch is installed through the assembler's protected output routines:

```asm
ld a,0c3h
call emitByteAtAssemblyOutput
ld bc,breakpointHitCaptureEntry
call emitWordBCAtAssemblyOutput
```

Using the ordinary emitter is important. It rejects destinations in ROM, in the
resident PROMETHEUS/source region, or above U-TOP. The monitor therefore does not
place its breakpoint jump through obviously forbidden memory.

Custom traced READ, WRITE and RUN windows are not consulted here. This is a
native-run command, not a traced instruction.

## Why exactly three bytes are saved

A Z80 absolute jump is three bytes long. PROMETHEUS always saves and replaces
three bytes regardless of instruction boundaries.

Suppose the breakpoint address begins a one-byte instruction followed by a
two-byte instruction. The patch temporarily covers both. Suppose it begins in
the middle of an instruction. The patch still covers three bytes from that
location.

This is normal for a simple software breakpoint: the chosen address is assumed
to be an address at which the processor may legitimately fetch an instruction.
PROMETHEUS does not use the disassembler to prove alignment before patching.

The saved buffer is itself only three bytes:

```asm
savedBreakpointOriginalBytes:
    nop
    nop
    nop
```

Those `NOP` opcodes are harmless initial values. While no breakpoint is active,
the bytes are merely storage.

## The run-start address is separate from the breakpoint address

The run-start address remembered by W appears here:

```asm
varcBreakpointRunStartAddress:
    ld de,breakpointHitCaptureEntry
```

The initial assembled operand points to the capture entry, but W patches it with
the chosen start address.

At run time the registers are arranged as:

```text
HL = breakpoint patch address, preserved on monitor stack
DE = native run start address
C  = $C3, opcode for JP nn
```

The common native trampoline therefore begins the user program with a real
absolute jump:

```text
DI or EI
JP runStart
JP sequentialCapture
JP takenCapture
```

The JP does not return to the scratch area. The user's program runs freely until
it fetches the temporary jump at the breakpoint address.

## How the program finds its way back

When the program reaches the patched address, it executes:

```asm
JP breakpointHitCaptureEntry
```

That entry contains one deliberate `NOP` and then falls into
`captureUserStateAfterSequentialFlow`:

```asm
breakpointHitCaptureEntry:
    nop
captureUserStateAfterSequentialFlow:
    ld (savedRegisterSP),sp
    ...
```

Why the `NOP`?

The ordinary sequential capture path has a one-byte layout position associated
with its scratch-trampoline fall-through. The breakpoint entry uses a single
byte to reach the same common arrangement and to keep the refresh-register
correction compatible with that path.

The exact byte accounting is less important than the design principle:

> The breakpoint does not need a second complete state-saving routine. It enters
> the existing serializer at a compatible point.

Chapter 43's capture code records registers, stack, I, R and interrupt state,
then restores the monitor SP that was saved before native execution.

Because `executeNativeCallOrJumpThroughTrampoline` was itself called from
`monRunToTemporaryBreakpoint`, returning from capture resumes immediately after
that call.

## Restoring the displaced bytes

Before running, the breakpoint routine has placed two values on the monitor
stack:

- the breakpoint address;
- the address of `savedBreakpointOriginalBytes`.

That stack is inactive while the user program runs but is restored by the
capture path. The code after the common trampoline call therefore continues:

```asm
pop hl
pop de
copyThreeBytesFromHLToDE:
    ld bc,0003h
    ldir
```

The source and destination have been arranged so the original three bytes are
copied back to the breakpoint location.

The temporary patch exists only during the native run.

In pseudocode:

```text
breakpoint = currentAddress
start = rememberedWAddress

savedBytes = memory[breakpoint .. breakpoint+2]
protectedWrite(breakpoint, JP captureEntry)

save monitor continuation state
restore user processor
JP start

; user code runs until breakpoint
captureEntry:
    capture user processor
    restore monitor stack
    return to breakpoint command

memory[breakpoint .. breakpoint+2] = savedBytes
```

## The address shown after the hit

The monitor's current address remains the chosen breakpoint address. The native
program reached that address and executed the replacement jump instead of the
original bytes.

The state image therefore describes the processor just after the jump into the
monitor capture path, while the visible focal address describes the logical
place at which the user intended to stop.

PROMETHEUS does not try to pretend that the overwritten instruction was
executed. It stops before those original bytes and restores them for possible
later inspection or execution.

## Failure modes of a simple software breakpoint

The design is compact, but its limits should be understood.

### The program may never reach the breakpoint

The native JP leaves the scratch trampoline permanently. If the user program
loops elsewhere, crashes, disables useful input, overwrites the breakpoint, or
jumps into ROM, PROMETHEUS does not automatically regain control.

Because cleanup occurs only after `breakpointHitCaptureEntry` returns through the
saved monitor continuation, the displaced bytes also remain patched until that
happens.

### There is only one breakpoint slot

`savedBreakpointOriginalBytes` holds one three-byte sequence. There is no array
of breakpoint records and no active flag. Setting several simultaneous software
breakpoints is not supported by this mechanism.

### The program can alter the patch

The running code has ordinary access to memory. It may overwrite the temporary
JP deliberately or accidentally. The monitor is not tracing writes during the
native run.

### Interrupts may change the route

The saved DI/EI state is applied before the native jump. If interrupts are
enabled, an interrupt routine may run. That is part of the user's machine
environment, but it also means the route to the breakpoint is not isolated.

### Stack and hardware effects are real

Unlike a simulated experiment, native code can use the stack, ports, interrupt
mode and memory without per-instruction checks. The state capture records the
resulting processor registers; it cannot undo external effects.

## Why patch installation is protected but restoration is raw

The three breakpoint bytes are installed through `emitByteAtAssemblyOutput` and
`emitWordBCAtAssemblyOutput`. Those routines perform the assembler's output
safety checks.

Restoration uses a direct `LDIR`.

At first this asymmetry may look careless. It is based on a simple fact: if
installation was accepted at an address, restoring the bytes to that same
address should be possible. The address is still held on the monitor stack; no
new destination is being chosen.

The raw copy is smaller and avoids disturbing the output-emitter state during
cleanup.

There is still a theoretical risk if the running program changes the system's
memory boundaries or otherwise invalidates assumptions before the breakpoint is
hit. PROMETHEUS is a compact monitor, not a protected operating system.

## One common builder, two different promises

The native CALL and breakpoint run share
`executeNativeCallOrJumpThroughTrampoline`, but their control promises differ.

### Native CALL promise

```text
CALL target
    target eventually executes RET
    RET returns to scratch sequential-capture jump
```

### Breakpoint-run promise

```text
JP start
    program eventually reaches patched address
    patched JP reaches breakpoint capture entry
```

The common builder needs only an opcode and target:

```text
$CD + target  for CALL
$C3 + start   for JP
```

The caller is responsible for arranging the route back.

This is an elegant separation. The trampoline builder does not know what a
subroutine means or how a breakpoint was installed. It writes a transfer
instruction and standard capture exits. Higher-level commands create the
appropriate return condition.

## Native calls inside tracing

Chapter 48 will return to native execution in a subtler form. PROMETHEUS can be
configured to let selected traced CALL or RST instructions run directly:

- NON: no CALL/RST target is direct;
- DEF: only addresses in the direct-call list are direct;
- ALL: every CALL/RST target is direct.

The same trade-off applies:

- direct execution is much faster;
- the called body is not individually checked;
- its T states are not added accurately;
- control is regained only when it returns.

The explicit SYMBOL SHIFT+H command is the clearest introduction because the
user asks for one native call directly. Later, the tracing engine will decide
whether to use similar freedom for a decoded CALL/RST.

## Comparing the three ways to run code

PROMETHEUS now has three broad execution styles:

| Style | Regains control | Protection checks | Timing visibility |
|---|---|---|---|
| one-step scratch execution | after one instruction | per decoded instruction | modeled per instruction |
| native subroutine CALL | when the subroutine returns | not inside body | body not counted |
| native breakpoint run | when patched address is reached | not during run | run not counted |

None is universally best.

- Single step is slow but observable.
- Native CALL is useful for trusted service routines.
- Breakpoint run is useful for crossing a long region at full speed.

The monitor gives the user a choice rather than forcing every problem through
one execution mechanism.

## A small example

Suppose the saved state is:

```text
PC/current = $8000
SP         = $9000
A          = $05
interrupts = DI
```

A trusted subroutine at `$8200` increments A and returns.

SYMBOL SHIFT+H with target `$8200` builds:

```text
$F3                 DI
$CD $00 $82         CALL $8200
$C3 <seq capture>   JP sequential capture
$C3 <taken capture> JP taken capture
```

Restoration activates SP `$9000`. The CALL writes its scratch return address at
`$8FFE..$8FFF`, runs the subroutine, and RET retrieves that address. Capture then
saves A=`$06` and SP=`$9000` again.

For a breakpoint run, imagine:

```text
W start       = $8000
current break = $8100
```

PROMETHEUS changes bytes at `$8100..$8102` to a JP into capture, restores the
same state, and jumps to `$8000`. If the program reaches `$8100`, the saved image
is refreshed and the original three bytes are restored.

The user can then inspect the machine at the stopping point.

## Back to the whole machine

Chapter 43 gave PROMETHEUS a doorway between a memory image and the real Z80.
This chapter has shown two ways to use that doorway without immediately stepping
back through it:

```text
saved image
    -> real Z80
       -> trusted CALL and RET
       -> capture

saved image
    -> real Z80
       -> native JP and free running
       -> temporary breakpoint JP
       -> capture
```

Both routes depend on a tiny scratch program. The next chapter examines that
program as a reusable piece of generated machine code.

## What has changed in memory

A native subroutine call may change:

- all saved registers and flags;
- the user's stack contents during the CALL;
- any memory or hardware the subroutine touches;
- the remembered interrupt state after capture.

A breakpoint run additionally changes temporarily:

- the three bytes at the breakpoint address;
- `savedBreakpointOriginalBytes`;
- the immediate operand at `varcBreakpointRunStartAddress` when W is used.

After a successful breakpoint hit, the original three bytes are restored.

## Important labels encountered

- `monCallSubroutineWithSavedState`
- `executeNativeCallOrJumpThroughTrampoline`
- `monSetBreakpointRunStartOrExecute`
- `monRunToTemporaryBreakpoint`
- `varcBreakpointRunStartAddress`
- `savedBreakpointOriginalBytes`
- `copyThreeBytesFromHLToDE`
- `emitByteAtAssemblyOutput`
- `emitWordBCAtAssemblyOutput`
- `breakpointHitCaptureEntry`
- `captureUserStateAfterSequentialFlow`
- `restoreUserStateAndExecuteTrampoline`

## Ideas needed by later chapters

- A scratch program can begin with either a real CALL or a real JP.
- The route back may be a normal RET into scratch RAM or a patched JP at a
  breakpoint address.
- Native execution deliberately gives up per-instruction protection and timing.
- The monitor stack can remain dormant while the user's SP is active, then be
  restored by the common capture serializer.
- Standard capture exits let several execution commands share one state-saving
  mechanism.
