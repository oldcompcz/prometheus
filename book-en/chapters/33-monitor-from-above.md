# Chapter 33: The Monitor from Above

The editor and assembler help us **create** machine code. The monitor helps us
**meet it while it is running—or before we dare to run it**.

A machine-code monitor is sometimes described as a collection of utilities:

- display memory;
- change bytes;
- show registers;
- disassemble instructions;
- search or move blocks;
- set breakpoints;
- execute one instruction;
- load and save raw memory.

PROMETHEUS contains all of those, but the list hides its central idea. The
monitor is an interactive front panel for a second, temporarily suspended Z80
machine state.

The physical processor is still the Spectrum's one Z80. Yet the monitor keeps a
saved set of user registers, a current address, protection windows and execution
policies. It lets the human inspect and change that suspended world. When asked
to step or run code, it carefully lends the real processor to the user state and
then takes it back.

We will not open the execution machinery yet. That is the subject of Part VI.
This chapter gives a top-down tour of monitor mode:

```text
enter monitor
    ↓
prepare its private stack and shared input area
    ↓
render a descriptor-driven front panel
    ↓
read one normalized key
    ↓
dispatch a monitor command
    ↓
return to the warm monitor entry and redraw
```

The goal is to make the large monitor prefix feel like one coherent application
before we study its individual tools.

## The monitor may not be installed at all

The full resident image begins at:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Five thousand bytes later lies:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

When the installer is configured with `Monitor: No`, it copies only the suffix
beginning at `ENTRY_POINT_WITHOUT_MONITOR`. The editor and assembler remain, but
the monitor prefix is absent.

That physical separation explains an unusual entry patch near the editor's
`MONITOR` command:

```asm
invokeMonitor:
    ld b,"a"
    call containsInputBufferCharacterInB
    call z,processCompilation
    call clearDisplayToSpaces
assemblerOnlyMonitorFallbackOpcode:
    defb 0c3h
assemblerOnlyMonitorFallbackAddress:
    defw startMonitor
```

In a full installation, the final bytes form:

```asm
    jp startMonitor
```

For an assembler-only installation, the installer patches the destination so
that trying to invoke the missing monitor does not jump into absent code.

The monitor is therefore optional in the strongest possible sense: not merely
hidden, but physically omitted from the resident image.

## The optional `A` parameter assembles first

The `MONITOR` command can contain the parameter `A`:

```asm
    ld b,"a"
    call containsInputBufferCharacterInB
    call z,processCompilation
```

If `A` is present, PROMETHEUS assembles the current source before entering the
monitor.

This supports a natural workflow:

```text
edit source
MONITOR A
inspect or run the freshly assembled result
```

Without `A`, the monitor opens immediately and leaves existing memory as it is.

After the optional compilation, the editor display is cleared and control jumps
to `startMonitor`.

## A warm entry rather than one endless loop

The core entry is:

```asm
startMonitor:
    di
    call setBorderColor
    ld sp,internalStackTop
    call monitorInputBuffersInitialization
    ...
```

Calling it a “loop” is only partly accurate. Every monitor command normally
returns to a **fresh invocation** of `startMonitor`.

That entry:

- disables interrupts while rebuilding monitor state;
- restores the configured border;
- resets the private internal stack;
- initializes shared input buffers;
- reconstructs the status line;
- restores shared error and continuation hooks;
- redraws the entire front panel;
- reads and dispatches one key.

Why reset the stack every time? Monitor commands can be complicated. Some call
ROM routines, some display long lists, some temporarily patch error paths, and
some prepare to execute user code. Re-entering through a known stack top prevents
one abandoned or unusual path from gradually contaminating the next command.

Persistent monitor state is therefore not expected to live on the previous
command's stack. It lives in:

- saved register fields;
- monitor tables;
- front-panel descriptors;
- self-modified operands such as the current address;
- explicit navigation and protection structures.

## The monitor has its own status sentence

At entry, four compact tokens are placed in `inputBufferStart`:

```text
UNIVERSUM Control  ON/OFF  Call  NON/DEF/ALL
```

The exact wording is assembled from monitor token codes rather than copied as
one long string.

The first policy reports whether instruction-control checks are enabled. The
second reports how CALL and RST targets are treated during tracing:

```text
NON  do not directly execute selected call targets
DEF  execute targets present in the defined list
ALL  allow all direct calls
```

The code derives visible tokens from executable state:

```asm
    ld a,(varcInstructionControlsDisabled+1)
    add a,0c7h
    ld (hl),a
    ...
    ld a,(directCallModeGateOpcode)
```

`directCallModeGateOpcode` is not merely a numeric setting. It contains one of
three real opcodes—NOP, RET Z or RET—whose behavior is used by the tracing
engine. `startMonitor` also interprets those opcode values as a compact policy
number for display.

This is PROMETHEUS's characteristic style: one byte serves as executable policy
and as encoded user-interface state.

## Shared editor machinery is retuned for monitor mode

The monitor does not own a completely separate text system. It reuses the
editor's input buffer, token expander, error hook and post-command continuation.
At warm entry it restores or redirects them deliberately.

The token-expansion base is changed:

```asm
    ld hl,l96a4-1
    ld (varcTokenExpansionTableBase+1),hl
```

The editor normally expands assembler command tokens. The monitor needs its own
compact vocabulary for prompts and panel labels.

The shared error hook is restored:

```asm
    ld hl,printStatusBar
    ld (errorAction+1),hl
```

Individual monitor prompts later replace it so syntax errors can appear on the
monitor edit line and retry the same prompt.

The shared abort and completion hooks are also returned to safe defaults:

```asm
    ld hl,clearStringBuffers
    ld (abortCommandAndReturnToEditor+1),hl
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
```

At first it may look odd that monitor entry restores an editor warm-start
continuation. It is defensive housekeeping. Previous tape, list or line-assembly
operations may have patched shared hooks. A new monitor command should begin from
known defaults before installing any temporary behavior it needs.

## A synthetic return address makes commands redraw automatically

This is one of the cleanest control-flow tricks in the monitor:

```asm
    ld hl,startMonitor
    push hl
    call redrawFrontPanelAtCurrentAddress
    call readKeyCode
```

`startMonitor` pushes its own address before dispatching the key.

Later, the table dispatcher pushes a command handler address and executes `RET`.
The stack then looks conceptually like this:

```text
top → selected command handler
      startMonitor
```

The dispatcher's `RET` enters the handler. When the handler eventually performs
its ordinary `RET`, it returns to `startMonitor`.

No command-specific tail jump is needed merely to repaint the panel.

In pseudocode:

```text
push address_of(startMonitor)
push address_of(selectedHandler)
return                      // enters selectedHandler

selectedHandler eventually returns
    → startMonitor
    → rebuild and redraw panel
```

This is why many monitor handlers can be written as ordinary subroutines even
though they participate in an interactive command loop.

Some handlers intentionally jump elsewhere—for example, Q returns to the editor,
and a tracing command may remain in an execution loop—but the default behavior
is built into the stack.

## The current address is the monitor's centre of gravity

Before command dispatch, the monitor loads:

```asm
    ld hl,(varcMonitorCurrentAddress+1)
```

The current address is stored in the immediate operand of a self-modified
instruction:

```asm
varcMonitorCurrentAddress:
    ld hl,00000h
```

Almost every monitor operation begins from this address:

- memory display;
- disassembly;
- byte movement;
- single-step execution;
- address navigation;
- one-line assembly;
- front-panel repainting.

The table-dispatched handlers receive it in `HL` automatically.

A useful first mental model is:

> The editor has a current source record. The monitor has a current memory
> address.

Both applications redraw a window around that focal point and let commands move
or reinterpret it.

## The front panel is generated from descriptors

`redrawFrontPanelAtCurrentAddress` does not contain one long hardcoded sequence
such as “print A here, print BC there, print memory there.” Instead it walks
`frontPanelItemDescriptors`.

Each item is seven bytes. In broad terms it says:

```text
where on the Spectrum bitmap to draw
which label or selector identifies the item
how values should be formatted
whether the item is fixed, variable, hidden or visible
where its value or indirect start address comes from
```

Representative items include:

- the monitor edit line;
- an eleven-row list window;
- a small disassembly window;
- interrupt state;
- A, B, C, D, E, H and L;
- index-register halves;
- flags and register pairs;
- memory areas based on saved pointers.

For example, the list-window descriptor begins:

```asm
frontPanelListWindowItem:
    defb 000h
    defb 040h
    defb 0a0h
    defb 003h
frontPanelListWindowSizeFlags:
    defb 08bh
    defw 0
```

The low five bits of `$8B` give a default height of eleven rows. Bit 7 marks the
item as variable-size. The front-panel editor can change descriptor bytes, and
the ordinary renderer immediately obeys the new layout on the next warm entry.

The panel is therefore a tiny data-driven user interface.

Chapter 34 will open the descriptor format in detail. For now, remember the
high-level flow:

```text
saved monitor state
    ↓ generic descriptor renderer
visible front panel
```

## Redrawing is a complete state refresh

After every normal command, `startMonitor` calls:

```asm
    call redrawFrontPanelAtCurrentAddress
```

A complete repaint may seem expensive, but it has strong advantages:

- handlers do not need to update every affected field themselves;
- register, memory and disassembly views stay mutually consistent;
- panel-format changes take effect through the same renderer;
- commands can concentrate on changing state rather than maintaining screen
  fragments;
- re-entry after errors or list cancellation has one reliable visual result.

On a 3.5 MHz Z80 this is not free, but monitor interaction is human-paced. Code
simplicity and state consistency are worth more than avoiding a few character
renders after a deliberate keypress.

## One key is read after the panel is ready

The monitor uses the same normalized keyboard reader we met in the editor:

```asm
    call readKeyCode
```

Before dispatching, it clears the monitor edit-line bitmap row so a previous
prompt does not remain under the next operation:

```asm
    call getMonitorEditLineBitmapRowStart
    call clearBitmapTextRow
```

A few important keys are tested directly because their actions are central or
need special control flow:

```asm
    cp 071h
    jp z,startPrometheus

    cp 014h
    jp z,invokeFrontPanelEditor

    cp 023h
    jp z,invokeToggleNumberBase

    cp 03ah
    jp z,stepInstructionAtHL

    cp 02ch
    jp z,setRegisterValue

    cp 003h
    jp z,clearDisplay
```

These represent, among others:

- Q: return to PROMETHEUS editor;
- SYMBOL SHIFT+W: edit front-panel layout;
- SYMBOL SHIFT+3: toggle decimal/hexadecimal display;
- SYMBOL SHIFT+Z: single-step current instruction;
- SYMBOL SHIFT+N: set a register value;
- CAPS SHIFT+0: restore/clear the monitor display.

The remaining commands use a compact table.

## Forty bindings in a delta-address table

The monitor has forty table-dispatched key bindings. The dispatcher begins with:

```asm
    ld c,a
    ld b,028h
    ld hl,monitorKeyboardActions
    ld de,monitorKeyboardActionsTable
```

Each table entry contains:

```text
unsigned delta from the preceding handler
normalized key code
```

The scan cumulatively adds the delta to `HL`:

```asm
.scanMonitorKeyBindings:
    ld a,(de)
    inc de
    call addAtoHL
    ld a,(de)
    cp c
    inc de
    jr z,.invokeMatchedMonitorKeyBinding
    djnz .scanMonitorKeyBindings
```

On a match:

```asm
.invokeMatchedMonitorKeyBinding:
    push hl
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

The computed handler address is pushed, the current address is restored to
`HL`, and `RET` enters the handler.

This is another compact replacement for a large table of two-byte addresses.
The handlers are arranged close enough in memory that one-byte forward deltas
suffice.

The default contract is:

```text
input:
    HL = current monitor address

stack beneath handler:
    startMonitor

normal RET:
    redraw monitor
```

## What kinds of commands live behind the table?

We will study them in later chapters, but a top-down grouping is useful now.

### Address navigation

Commands can:

- set the current address explicitly;
- move one byte backward or forward;
- move one decoded instruction;
- push and pop addresses on a small navigation stack.

### Memory viewing and editing

The monitor can display bytes, words or characters and can edit memory one item
at a time or continuously.

### Disassembly and source creation

It can decode instructions into text, list a range, print it, or insert decoded
lines into the PROMETHEUS source editor.

### Block operations

It can search with masks, fill memory, move overlapping blocks and inspect
ranges.

### Register and execution control

It can edit saved registers, step an instruction, trace automatically, manage
breakpoints and decide how CALL/RST instructions are treated.

### Protection editing

It exposes inclusive ranges that forbid reads, writes or execution. It also has
DEFB/DEFW display-area tables that affect disassembly.

### Tape operations

It can load, verify and save raw memory blocks independently of the structured
source-project commands from Part IV.

The monitor is broad because it is the operating environment for machine-code
experiments, not merely a debugger attached to the assembler.

## Monitor input uses the familiar 32-byte workspace

Commands that need a value call `promptForMonitorValue`. Commands that assemble
one instruction use `assembleMonitorInputLine`. Both reuse the normal input
buffer and much of the normal expression or source parser.

The monitor changes three surrounding details:

1. where the prompt is rendered;
2. where errors are displayed;
3. where successful completion continues.

For a numeric prompt, the input ultimately reaches the ordinary expression
evaluator, so the user can enter forms such as:

```text
32768
#8000
%10101010
'A'
$
SYMBOL+2
```

For one-line assembly, the monitor uses the ordinary source parser and the same
first- and second-pass record handlers, but without inserting a record into the
user's compressed source.

This reuse is exactly the pattern we saw in LOAD and GENS:

```text
special feature prepares ordinary input
    ↓
trusted parser/evaluator performs the semantic work
```

## The list window has an unusual continuation rule

Many monitor operations produce more lines than fit in the panel's list window.
The shared output helper is:

```asm
outputMonitorListLineAndPollContinuation:
    call appendLineBufferToMonitorListWindow
    xor a
    in a,(0feh)
    cpl
    and 01fh
    ret nz
    call readKeyCode
    cp 004h
    ret nz
```

The missing final `RET` is intentional. If the new deliberate key is EDIT
(normalized as `$04`), execution falls directly into `startMonitor`, which is
physically next in the source.

The behavior is:

```text
while any key remains physically held:
    stream further rows immediately

when no key is held:
    wait for a deliberate key

if key is EDIT:
    return to monitor by fall-through
else:
    continue listing
```

This arrangement provides fast continuous output while a key is held and a
simple way to stop with EDIT.

It also illustrates why reading reconstructed assembly requires attention to
physical fall-through. A missing `RET` is not necessarily damage.

## The monitor's private world of saved state

Even before we explain stepping, several categories of state are visible:

```text
saved main registers
saved alternate registers
saved IX and IY
saved SP, I, R and interrupt state
current monitor address
navigation address stack
front-panel descriptors
DEFB/DEFW display ranges
NO READ / NO WRITE / NO RUN ranges
direct CALL/RST target list
instruction-control policies
trace timing accumulator
```

Some of these are ordinary data bytes. Some are operands inside instructions.
Some are biased-count lists. Some are compact descriptors.

The front panel is a view onto this world. Editing a displayed register does not
necessarily change the monitor's own currently executing Z80 register. It
changes the **saved user state** that will be restored when user code is run or
stepped.

This distinction is fundamental:

```text
monitor's working registers:
    temporary tools used by PROMETHEUS right now

saved user registers:
    model of the program being inspected
```

Part VI will show how the program crosses between them.

## The monitor protects itself from its subject

A monitor that runs arbitrary machine code faces a paradox: the code being
examined can overwrite the monitor, its stack, its tables or the screen used to
report what happened.

PROMETHEUS addresses this with several protection structures:

- no-read ranges;
- no-write ranges;
- no-run ranges;
- automatic dynamic protection of its resident region;
- instruction-level analysis before a step;
- special treatment of disassembly inside resident data areas.

The protection system does not make arbitrary code perfectly safe. A Z80 has no
memory-management unit. But it lets the monitor reject many dangerous operations
before lending the processor to the user instruction.

We will study these checks in Chapters 38 and 47.

## The monitor is also a second user interface built from the first

By now a larger design becomes visible.

The editor and monitor look different, but they share:

- keyboard normalization;
- compact token expansion;
- the 32-byte input area;
- number and symbol expression evaluation;
- line-buffer rendering;
- screen character routines;
- tape ROM wrappers;
- continuation patching;
- status and error hooks;
- the instruction vocabulary.

What changes is the surrounding state machine.

The editor's central object is a source record. The monitor's central object is a
memory address and saved processor state.

The editor command loop asks:

```text
What should happen to the source around the active record?
```

The monitor asks:

```text
What should be shown or done around the current address and saved CPU state?
```

PROMETHEUS is not two completely separate applications. It is one compact set of
parsers, renderers and memory routines arranged into two different workshops.

## The top-level monitor cycle in pseudocode

Ignoring special non-returning commands, the warm cycle is:

```text
function startMonitor():
    disableInterrupts()
    restoreBorder()
    SP = internalStackTop
    initializeSharedMonitorInput()

    buildStatusTokens(
        instructionControlPolicy,
        directCallPolicy
    )
    renderMonitorInputLine()

    selectMonitorTokenVocabulary()
    restoreDefaultSharedErrorAndAbortHooks()

    push startMonitor as outer return
    redrawFrontPanel(currentAddress)

    key = readNormalizedKey()
    clearMonitorPromptRow()

    if key is directSpecialKey:
        jump to its handler

    handler = findInFortyEntryDeltaTable(key)
    if found:
        HL = currentAddress
        returnInto(handler)

    trySharedAreaKeys(key)
```

A normal handler changes monitor state and executes `RET`. The synthetic outer
return re-enters `startMonitor`, which redraws everything from that changed
state.

## Following one simple action

Suppose the user presses the key assigned to “next byte.”

The journey is:

```text
1. startMonitor rebuilds panel and reads the key
2. direct tests do not match
3. forty-entry table scan finds the navigation handler
4. dispatcher pushes that handler
5. dispatcher loads HL=current address
6. RET enters the handler
7. handler increments HL
8. handler stores HL into varcMonitorCurrentAddress+1
9. handler RETs
10. synthetic return enters startMonitor
11. front panel is redrawn around the new address
```

The handler itself can be only a few instructions because entry, redisplay and
state delivery are handled by the common frame.

This is the monitor's top-down architecture in miniature.

## What has changed in memory?

During one ordinary monitor command:

- `SP` is reset to `internalStackTop` at warm entry;
- monitor status tokens temporarily occupy `inputBufferStart`;
- shared token, error, abort and continuation operands are restored or retuned;
- the front-panel bitmap is rebuilt from descriptor and saved-state data;
- a command may change the current address, saved registers, memory, tables or
  policies;
- normal `RET` re-enters `startMonitor` and discards the old command stack.

The editor's compressed source usually remains untouched unless a command
explicitly assembles a source line or inserts disassembly into the editor.

## Important labels encountered

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `invokeMonitor`
- `assemblerOnlyMonitorFallbackAddress`
- `startMonitor`
- `internalStackTop`
- `monitorInputBuffersInitialization`
- `varcTokenExpansionTableBase`
- `varcMonitorCurrentAddress`
- `redrawFrontPanelAtCurrentAddress`
- `frontPanelItemDescriptors`
- `monitorKeyboardActions`
- `monitorKeyboardActionsTable`
- `outputMonitorListLineAndPollContinuation`
- `promptForMonitorValue`
- `assembleMonitorInputLine`

## Ideas needed by later chapters

- Front-panel appearance is data, not a fixed drawing routine.
- A synthetic return address makes normal monitor handlers redraw automatically.
- The monitor distinguishes its own working registers from a saved user CPU
  state.
- The current address plays the same organizing role that the active source line
  plays in the editor.
- Shared parsers and renderers are retuned through patched hooks instead of
  duplicated.
- Protection and execution control are inseparable from stepping arbitrary code.

## Source coverage

This chapter explains `invokeMonitor`, the warm entry at `startMonitor`, its
shared-hook reset, status construction, front-panel repaint, direct key tests,
forty-entry delta dispatch and the synthetic return convention. Detailed panel
descriptors, navigation commands, memory operations, protection tables,
disassembly and stepping remain for Chapters 34–49.
