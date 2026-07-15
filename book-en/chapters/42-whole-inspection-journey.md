# Chapter 42: The Whole Inspection Journey

We have spent ten chapters taking the monitor apart. It is time to put the
inspection side back together.

This chapter introduces no major new algorithm. Instead, it follows one realistic
session and watches the mechanisms cooperate:

```text
enter monitor
choose an address
read the front panel
list and classify memory
change display policy
search for bytes
edit one instruction
send disassembly to paper or source
save and restore a block
```

The point is not to memorize the keys. It is to see that the monitor is not a
bag of isolated utilities. Most visible actions pass through a small set of
shared representations and contracts.

## The program we shall inspect

Assume the editor has assembled this small routine at `$8000`:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

Memory contains:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

The symbol table contains:

```text
START = $8000
LOOP  = $8002
```

We will not execute it yet. Execution begins in Part VI. For now, the monitor is
an observer and editor.

## 1. Entering the monitor

The editor command `MONITOR` reaches `invokeMonitor`. With parameter A it first
assembles the current source. It clears the editor display and jumps either to
the real monitor prefix or, in an assembler-only installation, through the
installer-patched fallback.

`startMonitor` then establishes a clean private world:

- interrupts are disabled;
- the border is restored;
- the monitor stack is reset;
- shared input state is initialized;
- policy text is reconstructed;
- the front panel is repainted;
- a key is read and dispatched.

Every ordinary monitor command returns to a synthetic `startMonitor` address on
the stack. That gives each command a fresh warm entry and repaint without
requiring every handler to contain its own final jump.

At this level the loop is:

```text
startMonitor:
    reset transient monitor state
    repaint panel around current address
    key = read key
    dispatch key
    ; handler RET reaches startMonitor again
```

## 2. Choosing `$8000`

The user selects the current address and enters `$8000`. The prompt is rendered
through the shared monitor input line. The expression evaluator accepts the
hexadecimal number and returns it in `HL`.

`setMonitorCurrentAddressAndRet` patches:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

The two operand bytes now contain `$8000`. They are both stored state and a
future instruction input.

On the next warm entry, the monitor supplies this current address to handlers
and to the front-panel repaint.

## 3. Reading the front panel

The panel is not drawn by thirty-four special print routines. Its descriptor
table says where each item lives, what it is called, where its value comes from
and how that value should be formatted.

The current-address-dependent disassembly item receives `$8000` through
`varcFrontPanelDisassemblyAddress`. Its fixed row loop repeatedly calls the
shared disassembler.

The panel can therefore show something like:

```text
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

beside saved registers, flags and selected memory values.

At this moment several levels are cooperating:

```text
current address state
    -> panel descriptor
    -> special disassembly renderer
    -> shared instruction decoder
    -> temporary source record
    -> lineBuffer
    -> bitmap renderer
```

The panel is a view over state, not a separate model of the machine.

## 4. Walking by byte and by instruction

A one-byte-forward key changes `$8000` to `$8001`. The panel now begins in the
middle of `LD B,5`. Byte `$05` may decode as some unrelated instruction,
depending on the following bytes.

This is not an error. A machine-code monitor permits arbitrary alignment.

The one-instruction-forward key behaves differently:

```asm
monOneInstructionForward:
    call decodeInstructionAtHL
    jr setMonitorCurrentAddressAndRet
```

Starting at `$8000`, the decoder recognizes the two-byte instruction and returns
`HL=$8002`. The current address becomes the next instruction boundary.

The same decoder therefore serves two purposes:

- Chapter 39 used its result to create text;
- navigation uses only the returned next address.

This is an early sign of the execution engine to come. Decoding is useful even
when nothing is printed.

## 5. Opening an interactive listing

V begins a disassembly list from a prompted address. SYMBOL SHIFT+4 begins from
the current one.

The list is unbounded. The decoder creates one `lineBuffer` row at a time and
the common list-window output routine handles scrolling and continuation keys.

After the `RET`, the decoder requests a blank separator. The next call emits an
empty row without advancing the address, and the following call continues with
memory at `$8005`.

This shows why the decoder's contract includes both text and a next address:

```text
line 1: START LD B,5      next = $8002
line 2: LOOP  DJNZ LOOP   next = $8004
line 3:       RET         next = $8005, separator pending
line 4:                   next = $8005
line 5: decode at $8005   next = ...
```

## 6. Changing how addresses are shown

The C and SYMBOL SHIFT+C controls change two independent choices:

- whether numeric addresses are printed;
- whether symbols are preferred or numeric values are retained.

These preferences affect later uses of the shared disassembler:

- interactive listing;
- front-panel rows;
- printer disassembly;
- reverse disassembly into source.

A mode is not passed down through a large parameter record. It is stored in
self-modified state such as `varcDisassemblyAddressMode` and
`varcShowNumericDisassemblyAddresses`.

The result may change from:

```text
$8002  DJNZ $8002
```

through:

```text
$8002  DJNZ LOOP
```

or to a source-oriented line without the numeric prefix.

## 7. Telling code from data

Suppose bytes at `$8100` are a table:

```text
01 00 02 00 03 00
```

Without guidance, a disassembler tries to interpret them as instructions.
Through protection-table key 2, the user can mark `$8100..$8105` as a DEFW
area. The same disassembler now emits words instead.

Through key 1, another range may be forced to `DEFB`.

When the current address enters resident PROMETHEUS itself, the hidden dynamic
DEFB range is applied automatically. The monitor shows its own bytes as data
rather than pretending they are ordinary user instructions.

This policy is checked before opcode decoding:

```text
if address in DEFB table:
    make one-byte DEFB record
else if address in DEFW table:
    make one-word DEFW record
else:
    decode instruction
```

Classification and decoding are thus separate decisions.

## 8. Searching for the loop

Imagine we do not know where the routine lies, but we remember part of its byte
shape:

```text
06 : 10 : C9
```

The monitor's G command stores five `(value, mask)` pairs. Colons produce zero
masks and therefore match any byte.

The search formula for each position is:

```text
(memory XOR wanted) AND mask
```

At `$8000`, the five bytes are:

```text
06 05 10 FE C9
```

They match the pattern. The monitor makes `$8000` the current address and the
front panel immediately provides symbolic disassembly.

N begins the next search beyond the previous match. The finder, current-address
state and front panel are loosely coupled through one address rather than a
large search-result object.

## 9. Editing one instruction

Suppose we want `LD B,10` instead of `LD B,5`.

The SPACE command prepares one monitor assembly line at the current address.
The user enters:

```asm
LD B,10
```

PROMETHEUS does not use a special monitor opcode writer. It reuses:

- the ordinary source tokenizer;
- mnemonic and operand dictionaries;
- the instruction table;
- first-pass size logic;
- second-pass byte emission;
- protected output checks.

The bytes become:

```text
$8000  06 0A
```

On return to the warm monitor entry, the panel is repainted and the new operand
is visible.

This route is longer than manually poking `$0A` into `$8001`, but it preserves
assembly-language intent and catches invalid instruction forms.

## 10. Inspecting raw bytes and characters

L displays numeric memory rows. O displays character rows. Both use the common
monitor list window and its continuation behavior.

The user may therefore look at the same address in three languages:

```text
numeric memory:   06 0A 10 FE C9
characters:       .....
disassembly:      LD B,10 / DJNZ LOOP / RET
```

None is the one true meaning of memory. They are interpretations chosen for the
current question.

This is especially important on an eight-bit machine, where the same byte may
be:

- an opcode;
- an operand;
- a character;
- a bitmap fragment;
- a table count;
- part of a little-endian address.

## 11. Moving, filling and protecting blocks

The I and P command pairs operate on inclusive ranges. MOVE chooses forward or
backward copying when source and destination overlap. FILL stores the first byte
and lets `LDIR` replicate it through the rest of the range.

Both protect resident PROMETHEUS but do not consult the configurable WRITE
windows. Those windows belong to the user-instruction execution policy.

This division can now be seen as deliberate architecture rather than an
inconsistency:

```text
trusted monitor block command:
    protect resident workshop

unknown user instruction during trace:
    protect resident workshop
    plus user's READ/WRITE/RUN windows
```

The monitor itself is trusted to perform the operation the user explicitly
requested.

## 12. Sending disassembly elsewhere

D asks for a range and prints it through channel 3. SYMBOL SHIFT+D submits the
same generated lines to the editor parser.

For the running example, reverse disassembly can recreate:

```asm
START   LD B,10
LOOP    DJNZ LOOP
        RET
```

The path is deliberately circular:

```text
source
 -> compressed records
 -> machine bytes
 -> disassembly text
 -> ordinary source parser
 -> compressed records again
```

Because the return path uses the ordinary parser, reconstructed source obeys the
same rules as keyboard-entered source. If one generated line fails, the monitor
restores a saved stack point, lets the user edit the line and retries it. Earlier
insertions remain.

## 13. Saving the inspected block

S can save `$8000..$8004` as a raw block with a chosen flag or as a standard CODE
file with `:filename`.

Y can later read the CODE header, show its type, name, address and length, and
load the following `$FF` block if the user presses J.

This completes an inspection-and-repair cycle:

```text
find routine
inspect symbols and instructions
change one instruction
print or reconstruct source
save corrected bytes
```

The monitor does not need to know that the five bytes form our running example.
It provides general operations that happen to compose into this workflow.

## The monitor's three neutral forms

Across Part V, most operations converge on three simple forms.

### 1. An address

`varcMonitorCurrentAddress+1` is the focal point for:

- front-panel repainting;
- byte and instruction navigation;
- find results;
- memory editing;
- stepping in the next part.

### 2. A thirty-two-byte line

`lineBuffer` is the exchange point for:

- memory listings;
- disassembly;
- front-panel rows;
- printer output;
- reverse source insertion;
- header display.

### 3. An inclusive range

First/Last pairs support:

- MOVE;
- FILL;
- monitor SAVE and LOAD;
- protection windows.

Some commands accept First/Length, but they normalize it to the same inclusive
form before doing real work.

These forms keep the program comprehensible. Each subsystem can cooperate
without sharing every private detail.

## The monitor's trust boundary

We can now summarize what the inspection monitor will and will not protect.

| Operation | Resident PROMETHEUS protected? | Custom READ/WRITE/RUN windows used? |
|---|---:|---:|
| Disassembly classification | resident forced to DEFB | DEFB/DEFW tables only |
| One-line assembly into memory | yes, through assembler emitter | no |
| MOVE / FILL | yes | no |
| Raw monitor LOAD | yes | no |
| Monitor SAVE | no read prohibition | no |
| Traced user instruction | yes | yes, according to access type |

The final row belongs to Part VI. It is the reason the five range tables include
READ, WRITE and RUN even though the monitor's own trusted block tools mostly do
not consult them.

## Inspection is not execution

So far, the monitor has changed memory only when the user explicitly asked it
to:

- assemble a replacement instruction;
- move or fill a range;
- load a tape block.

It has not yet restored the saved user registers and allowed an unknown
instruction to run.

That next step is much harder. Before executing one instruction, PROMETHEUS must
answer questions such as:

- Which complete processor state belongs to the user program?
- Does this instruction read, write or execute a protected address?
- Is it a jump, call, return or restart?
- Where should control return to the monitor?
- How can the monitor execute a relocated copy without changing its meaning?
- What happens to interrupts, alternate registers, SP and the refresh register?

The instruction decoder we already understand will be the foundation, but it is
not enough by itself.

## The complete inspection loop in pseudocode

```text
enter_monitor(optional_compile):
    if optional_compile:
        assemble source

    repeat:
        reset monitor-private stack and hooks
        repaint descriptor-driven panel at current_address
        key = read monitor key

        if key changes address:
            update current_address

        else if key requests a view:
            convert memory into lineBuffer rows
            send rows to panel or scrolling list

        else if key edits memory:
            use trusted monitor or assembler operation
            protect resident workshop where that command requires it

        else if key changes policy:
            edit display, DEFB/DEFW or execution-protection tables

        else if key transfers data:
            translate inclusive range into ROM tape parameters

        else if key requests execution:
            enter the machinery of Part VI
```

The warm entry makes every completed command return to the same top-level
picture.

## What has changed in memory

During the complete session:

- `varcMonitorCurrentAddress+1` follows the focal address;
- panel descriptors and self-modified mode bytes control presentation;
- `lineBuffer` repeatedly receives views of memory;
- range tables may gain or lose user windows;
- one-line assembly may alter machine bytes;
- finder state remembers its five mask/value pairs and next position;
- reverse disassembly may create source records and symbols;
- tape commands may fill scratch headers or overwrite a loaded destination;
- saved user processor state remains a monitor data image, not yet a running CPU.

## Important labels reconnected

- `invokeMonitor`
- `startMonitor`
- `varcMonitorCurrentAddress`
- `frontPanelItemDescriptors`
- `redrawFrontPanelAtCurrentAddress`
- `varcFrontPanelDisassemblyAddress`
- `decodeInstructionAtHL`
- `disassembleNextLineToBuffer`
- `lineBuffer`
- `monFindSequence`
- `monNextSequence`
- `monitorFindByteMaskPairs`
- `editOneMonitorAssemblyLine`
- `assembleMonitorInputLine`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `monDisassemblyOnPrinter`
- `monDisassembleIntoSource`
- `monSaveBlockFirstLast`
- `monLoadBlockFirstLast`
- `monReadTapeHeaderOrLeader`

## Ideas needed in Part VI

- The decoder can return instruction structure without producing text.
- The current address will become the saved user's program counter.
- The private monitor stack must survive instructions that use or replace the
  user's stack.
- READ, WRITE and RUN windows become active when the monitor executes unknown
  code on the user's behalf.
- Self-modified policy opcodes and saved continuations will choose among several
  execution paths.
- A complete user register image must be restored before execution and captured
  again afterwards.

Part V has taught us how PROMETHEUS **looks at** another program. Part VI explains
how it briefly **becomes** that program and still finds its way home.
