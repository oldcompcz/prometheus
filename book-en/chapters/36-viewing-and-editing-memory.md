# Chapter 36: Viewing and Editing Memory

A monitor earns its name by making otherwise invisible machine state visible.
At the lowest level, that means memory.

PROMETHEUS offers three related ways to look at or change bytes:

1. small live memory views embedded in the front panel;
2. scrolling numeric or character listings in the configurable list window;
3. an interactive one-line assembler that writes new machine code at a chosen
   address.

These are not three copies of one routine. The panel uses the descriptor
interpreter from Chapter 34. Listings build exact 32-character rows in a shared
buffer. Editing returns entered text through the ordinary assembler pipeline.

This chapter follows each path and then reconnects them as one memory-inspection
workflow.

## The smallest view is already on the panel

Descriptors such as `(BC)`, `(DE)`, `(HL)`, `(SP)`, `(IX)`, `(IY)`, X and Y are
indirect memory items.

For `(HL)`, for example:

```text
descriptor points to savedRegisterHL
renderer reads the word stored there
that word becomes the memory source address
one or more values are displayed
```

The panel view is useful for context. It can show a stack word near SP, the byte
pointed to by HL or a short vertical region beginning at X.

Its weakness is space. Even a configurable 32-by-24 screen cannot display a
large dump beside registers and disassembly. Longer inspection uses the list
window.

## One shared scrolling list window

The general monitor list area is described by `frontPanelListWindowItem`. Its
screen origin and low-five-bit height are read at the moment each row is added.

Every list operation begins with:

```asm
beginMonitorListOutputWithBlankLine:
    call clearMonitorLineBuffer
```

The blank line is appended once as a separator from earlier output.

Subsequent rows pass through `appendLineBufferToMonitorListWindow`. That routine:

1. aligns the configured origin to a 32-column row;
2. reads the configured height;
3. scrolls existing bitmap rows upward;
4. chooses the exposed bottom row;
5. renders exactly 32 bytes from `lineBuffer`.

In pseudocode:

```text
if listWindow.height == 0:
    return to monitor

scroll rows 1..height-1 into rows 0..height-2
render lineBuffer into bottom row
```

The list machinery knows nothing about memory bytes, disassembled instructions
or range-table entries. Callers merely prepare a 32-character line.

Changing the panel descriptor's location or height changes every list command
without changing those commands.

## Continuation is shared too

After a row is appended, `outputMonitorListLineAndPollContinuation` implements
the monitor's listing rhythm:

- holding a key streams more rows;
- releasing it pauses;
- another non-EDIT key continues;
- EDIT returns to the monitor.

The memory, character and disassembly listings all inherit the same behaviour.
The producer returns the next memory address in HL; the output loop decides when
to ask it for another row.

That separation is useful:

```text
producer:  turn state into a 32-column line
consumer:  scroll, display and ask whether to continue
```

## Numeric memory listing

The L command begins at the current monitor address. SYMBOL SHIFT+L first asks
for `First` and then uses the same listing routine.

Each row shows five bytes in numeric and character form.

In hexadecimal mode the shape is approximately:

```text
#8000  #06 #05 #10 #FE #C9  .....
```

In decimal mode it resembles:

```text
32768  006 005 016 254 201  .....
```

The exact spacing is chosen so the result occupies 32 columns.

The row begins with its first address. Decimal bytes always use three digits.
Hexadecimal bytes use `#` plus two digits. The final five cells show the same
bytes as characters.

The high-level algorithm is:

```text
repeat forever:
    print row start address

    repeat 5 times:
        print next byte as fixed-width decimal or hexadecimal

    rewind to row start

    repeat 5 times:
        print same byte as a normalized character

    append row to list window
    continue from address + 5
```

The rewind is necessary because numeric formatting consumes the five memory
bytes before the character half is built.

## The curious standalone `$DD`

The routine contains:

```asm
    defb 0ddh
    ld hl,lineBuffer
```

A linear reading might call `$DD` stray data followed by `LD HL,nn`. The Z80
actually treats `$DD` as an IX prefix, so the bytes execute as:

```asm
    ld ix,lineBuffer
```

The source keeps the prefix separate because the same bytes are useful to the
reconstruction and because the original layout is exact. It is a compact
code/data presentation trick, not a random invalid byte.

IX then serves as the character destination while HL remains available as the
memory pointer or numeric value.

## Fixed-width formatting matters

A scrolling memory dump becomes hard to read if fields change width. PROMETHEUS
therefore uses dedicated fixed-width helpers:

```text
address       5 decimal digits or # plus 4 hexadecimal digits
byte          3 decimal digits or # plus 2 hexadecimal digits
```

The ordinary decimal number printer can omit leading zeroes, but the dump's byte
columns cannot. `006` must occupy the same space as `254`.

This is a good example of presentation code enforcing a structural invariant:

```text
every row has exactly 32 display cells
```

Because the list window renderer always consumes 32 bytes, malformed spacing
would not merely look untidy; it would shift or truncate the character half.

## Character normalization

`appendMemoryByteAsDisplayCharacter` implements the same policy used by the
front-panel character formatter:

```text
low seven bits below $20  → dot
otherwise                 → original glyph
original bit 7            → retained as inverse-video state
```

The code reads the byte twice so it can classify the low seven bits while still
preserving the original high bit.

Examples:

```text
$41  → A
$01  → .
$C1  → inverse A
$81  → inverse .
```

This gives control bytes a visible placeholder without losing the information
carried by bit 7.

## Character-only listing

The O command begins a character listing at the current address. SYMBOL SHIFT+O
prompts for a starting address first.

A row contains one address and twenty-five character cells:

```text
#8000  HELLO.................
```

The exact content depends on memory, of course. The important dimensions are:

```text
fixed address field
2 spaces
25 normalized memory characters
=
32 columns
```

The producer is simpler than the numeric dump:

```text
print row address
repeat 25 times:
    append normalized memory character
append row
continue from address + 25
```

Both listing forms wrap naturally through `$FFFF` to `$0000`. There is no
special end-of-memory stop because the Z80 address space itself is circular
under 16-bit arithmetic.

## Listings read memory directly

The numeric and character list commands do not consult the configurable READ
protection windows.

That fact may seem surprising after seeing “No read” areas in the monitor data.
Those tables belong chiefly to the controlled instruction-execution machinery,
where PROMETHEUS predicts and validates a user instruction's memory accesses.
Standalone display commands have their own behaviour and, in this case, simply
read the requested bytes.

Chapter 38 will distinguish the protection policies carefully. For now, remember:

```text
monitor command can inspect memory directly
    ≠
traced user instruction is permitted to read that memory
```

The monitor itself is trusted; the code being traced is the thing under control.

## Changing memory through assembly language

PROMETHEUS does not provide only a raw “enter one byte” editor. SPACE and E turn
the monitor edit line into a one-line assembler.

SPACE performs one edit at the current monitor address.

E begins continuous memory editing: after each entered line is assembled, the
next logical address becomes the origin for another line.

This is a powerful choice. The user can enter:

```asm
LD A,5
CALL ROUTINE
DEFB #00,#FF
```

rather than manually translating every instruction to bytes.

## SPACE: one-shot assembly

`monMemoryEditingOneShot` stores the current address into the operand of:

```asm
initializeMonitorLineAssembler:
    ld hl,00000h
```

It then enters `editOneMonitorAssemblyLine`.

As Chapter 35 described, that routine changes
`monitorInputCompletionDispatch` from `JP nn` to `LD HL,nn`. The entered line is
therefore not treated as a numeric expression. It falls through to
`assembleMonitorInputLine`.

The high-level path is:

```text
origin = current monitor address
edit one ordinary assembly source line
encode it into the temporary record buffer
run first-pass handler on that record
reset origin
run second-pass handler and emit bytes
return to monitor
```

No source record is inserted into the user's program. The temporary
`encodedRecordHeader` is enough for the normal assembler handlers.

## The ordinary parser is reused

The entered line passes through:

```asm
    call encodeInputLineToSourceRecord
```

with the normal nine-column label field reserved. This means monitor assembly
accepts the same instruction spelling, operand classes, expressions, symbols
and pseudo-instructions already described in Parts II and III.

The first and second pass routines are also the ordinary ones:

```asm
    call firstPassProcessSourceRecord
    ...
    call secondPassEmitSourceRecord
```

The monitor does not have a reduced private assembler.

That gives the command consistent behaviour almost for free:

- mnemonic recognition is identical;
- symbol references are identical;
- relative displacements are calculated identically;
- indexed-CB instructions receive the same byte-order correction;
- output uses the same protected emission path.

## Logical and physical origin are the same here

`initializeMonitorLineAssembler` writes the chosen address into both:

```text
varcAddressCounter
varcAssemblyOutputPointer
```

So a monitor-entered instruction is assembled as if it lives at the address
where its bytes are physically written.

This matters for:

- `$` expressions;
- relative branches;
- labels or `EQU` within the temporary line;
- directives whose result depends on the address counter.

There is no separate `PUT`-style destination unless the entered directive itself
changes the normal assembler state.

## E: continuous assembly

`monMemoryEditing` begins by using the one-shot setup, then repeats:

```text
load retained next origin
redraw panel disassembly from that origin
edit and assemble one line
retain the resulting address counter
repeat
```

After successful assembly, `assembleMonitorInputLine` copies the new logical
address back into `initializeMonitorLineAssembler+1`. If a two-byte instruction
was written at `$8000`, the next E-mode prompt begins at `$8002`.

In pseudocode:

```text
origin = currentAddress

loop:
    show disassembly at origin
    line = editAssemblyLine()
    origin = assembleOneLine(line, origin)
```

EDIT exits through the monitor input loop and returns to `startMonitor`.

This makes E feel like a small sequential machine-code editor even though each
line is independently encoded in a temporary record.

## Why redraw from the evolving address?

Before every continuous line, PROMETHEUS calls
`redrawFrontPanelFromDisassemblyAddress` with the retained origin.

The persistent monitor current address need not be committed after every line.
The panel's disassembly window can nevertheless show the place about to be
edited.

This distinction is useful:

```text
monitor current address       stable navigation focus
continuous assembly origin    moving edit cursor
```

The renderer accepts an explicit HL entry precisely so the edit cursor can be
shown without changing all monitor state.

## Errors remain editable

A malformed instruction, bad operand or out-of-range displacement leaves through
the ordinary assembler error machinery. The monitor-specific error continuation
from Chapter 35 restores the saved prompt stack, displays the message on the
panel edit row and lets the same line be corrected.

The user does not fall back into the source editor merely because the normal
source encoder and pass handlers were reused.

The command changes the error destination, not the parser.

## What memory is protected during editing?

Monitor line assembly emits bytes through the same
`emitByteAtAssemblyOutput` path as source compilation. That path prevents output
from colliding with PROMETHEUS's resident image, compressed source, symbol table
and configured user-memory ceiling.

This is different from the monitor's configurable WRITE-protection table used
when validating traced user instructions. The one-line assembler follows the
assembler's own output-safety rules.

The distinction again matters:

```text
assembler output safety
    protects PROMETHEUS and its stored program structures

monitor WRITE windows
    constrain memory effects predicted for traced user code
```

The two systems have related goals but different consumers.

## A practical inspection-and-patch journey

Suppose the current address is `$8000`, containing:

```text
06 05 10 FE C9
```

The panel disassembly shows:

```asm
LD B,5
DJNZ #8002
```

Pressing L shows the bytes numerically and as characters. Pressing O shows a
wider character-only view, which is more useful if the area contains text than
code.

Now suppose the first instruction should load 10 rather than 5. SPACE opens the
one-line assembler at `$8000`, and the user enters:

```asm
LD B,10
```

PROMETHEUS encodes a temporary source record, performs both normal assembler
passes and writes:

```text
06 0A
```

Returning to the monitor redraw immediately changes the disassembly. A new L
listing confirms the byte change.

The complete interaction is:

```text
panel gives local context
    ↓
L or O gives a longer memory view
    ↓
SPACE or E enters assembly text
    ↓
ordinary parser and assembler emit bytes
    ↓
panel and listings reveal the result
```

The monitor is not merely a hex dump with a poke command. It connects memory
inspection directly to the language of the assembler.

## Why not store the entered line in source?

A monitor patch is often experimental or temporary. Automatically inserting it
into the editor's compressed source would create several problems:

- which source position should receive it?
- should it replace an existing record?
- what if the address is outside the assembled program?
- should a temporary breakpoint patch become permanent source?

PROMETHEUS therefore keeps the operations separate:

```text
source editor assembly  → persistent source record, later compiled
monitor line assembly   → temporary record, immediate byte emission
```

Chapter 40 will show the opposite operation: disassembled memory can be
explicitly converted into source when the user requests it.

## The list buffer as a boundary

Both numeric and character listings build their rows in `lineBuffer` before
screen output. This boundary has several benefits:

- formatting does not need to know the current list-window bitmap address;
- scrolling does not need to know how the row was produced;
- printer and disassembly paths can reuse similar fixed-width line production;
- continuation polling occurs after one complete logical row.

The same architectural pattern appears throughout PROMETHEUS:

```text
produce canonical intermediate form
    ↓
pass it to a shared destination mechanism
```

For source, the canonical form was the compressed record or editable line. For
monitor lists, it is a 32-character row.

## What has changed in memory?

Numeric and character listings change:

- `lineBuffer`;
- list-window bitmap cells;
- shared printing-position state;
- temporary formatting buffers.

They do not change the listed memory.

SPACE and E additionally change:

- `encodedRecordHeader` and temporary parser storage;
- monitor line-assembler origin operands;
- ordinary assembler counters and output pointers;
- the destination memory bytes emitted by the assembled line.

Continuous E mode retains the next origin inside
`initializeMonitorLineAssembler+1`.

## Ideas needed by later chapters

- The list window is a generic 32-column scrolling destination.
- Direct memory-list commands bypass execution READ windows.
- Monitor assembly uses ordinary source parsing and both ordinary pass handlers.
- The monitor distinguishes navigation focus from a moving continuous-edit
  origin.
- Memory can later be searched, moved, filled, protected and disassembled through
  other producers that reuse the same address and list conventions.

## Source coverage

This chapter explains `frontPanelListWindowItem`,
`beginMonitorListOutputWithBlankLine`, `appendLineBufferToMonitorListWindow`,
`renderLineBufferAtMonitorListCursor`, numeric memory listing, character memory
listing, `appendMemoryByteAsDisplayCharacter`, `monMemoryEditingOneShot`,
`editOneMonitorAssemblyLine`, `initializeMonitorLineAssembler`,
`assembleMonitorInputLine` and continuous `monMemoryEditing`.
