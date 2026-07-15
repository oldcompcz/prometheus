# Chapter 34: The Front Panel

When PROMETHEUS enters the monitor, the screen looks like a carefully arranged
instrument panel. Registers occupy their familiar little fields. A few memory
locations are shown near the registers that point to them. A short disassembly
appears in its own window. The current interrupt state, accumulated timing and
an editable command line all have places of their own.

It would be easy to assume that the source contains one large drawing routine
with instructions such as:

```text
print A at row 16, column 0
print BC at row 18, column 9
print SP at row 18, column 18
print two disassembly lines at row 13
```

That is not how the panel is built.

PROMETHEUS describes the panel with data. A generic renderer reads a row of
small records and discovers:

- where an item begins on the Spectrum bitmap;
- what heading should be printed;
- where its value comes from;
- whether the value is one byte or two;
- how many values should be shown;
- whether they run horizontally or vertically;
- whether each value should appear in decimal, hexadecimal, binary, character
  form, or several forms at once.

The result is more than a configurable screen. It is a tiny **screen-description
language** interpreted by the monitor.

This chapter first looks at the panel as a whole, then decodes the seven-byte
records and the renderer that consumes them, and finally returns to the panel
editor that lets the user change those records while PROMETHEUS is running.

## Thirty-four small descriptions

The table begins at:

```asm
frontPanelItemDescriptors:
```

It contains thirty-four records. Every record is exactly seven bytes long.
That fixed size matters because both the renderer and the panel editor move from
one item to the next by adding seven.

The reconstructed layout is:

```text
byte 0,1   Spectrum bitmap address of the first character cell
byte 2     heading or special renderer selector
byte 3     source class and display-format flags
byte 4     size and capability flags
byte 5,6   address of the value, address variable, or unused zero
```

In pseudocode, one descriptor resembles:

```text
PanelItem {
    screenAddress
    heading
    formatAndSource
    sizeAndCapabilities
    valueAddress
}
```

The table begins with three areas rather than ordinary numeric fields:

1. the monitor edit line;
2. the scrolling list window;
3. the small disassembly window.

It then describes the interrupt state, the saved registers, the flags, register
pairs, the cycle counter, two general addresses called X and Y, and memory views
through BC, DE, HL, SP, IX and IY.

The renderer does not need a different high-level loop for each family. Most of
the differences are encoded in the descriptor bytes.

## A screen address, not a row and column

The first word in each record is a Spectrum bitmap address. For example, the
saved A register begins with:

```asm
    defb 000h
    defb 050h
```

Together these bytes form `$5000`, the bitmap address corresponding to the
first character cell of screen row 16.

The list window begins at `$4000`, the upper-left bitmap cell. The edit line
begins at `$50E0`, the first cell of the final text row. PROMETHEUS stores these
physical bitmap addresses directly because its character renderer already knows
how to move from one bitmap cell to another.

This avoids converting a pair such as `(column,row)` every time the panel is
redrawn. It also gives the panel editor a simple job: moving an item means
changing the two stored address bytes.

The cost is that Spectrum bitmap movement is not ordinary linear addition. As
Chapter 8 explained, neighbouring text rows are interleaved in memory. The
panel editor therefore uses the same bitmap-address helpers as the normal text
renderer when moving an item up, down, left or right.

## Byte 2: what heading should appear?

The third descriptor byte selects the visible heading, but it has three useful
forms.

### A packed operand name

Small values index the ordinary operand-name table. This is used for headings
such as:

```text
AF  BC  DE  HL  SP  IX  IY
```

The monitor does not keep a second spelling table for register names. It reuses
`operandsReferences`, the same compact dictionary used by the assembler and
disassembler.

For example, the AF item contains selector `$15`. The renderer passes that
index to `renderFrontPanelOperandName`, which resolves and prints the packed
name.

### One direct glyph

Values from `$80` upward can be printed directly as one character after their
high-bit display meaning is taken into account. The individual byte-register
items use values such as:

```text
$C1  A
$C2  B
$C3  C
$C4  D
```

This saves a table lookup for a one-letter heading.

### A parenthesized address

Selectors `$D8` and above request a special heading. Rather than printing a
fixed name, the renderer prints the resolved address in parentheses:

```text
(32768):
```

or, in hexadecimal mode:

```text
(#8000):
```

This is used by the X and Y address items and by memory views through saved
register pairs. The heading therefore tells us not merely “memory at HL” but the
actual current address contained in saved HL.

The heading is produced from live data, so it changes after a register or panel
address is edited.

## Byte 3: where the value comes from

The lowest two bits of descriptor byte 3 select one of four source or renderer
classes.

```text
00  flags item
01  indirect memory item
10  direct scalar item
11  special area
```

### Class 2: direct scalar data

Most register descriptors use class 2. Bytes 5 and 6 point directly to the
stored value:

```asm
    defw savedRegisterBC
```

The renderer reads from `savedRegisterBC` itself. If the item is configured as a
word, it reads two bytes. If configured as a byte, it reads one.

This is suitable for registers and other ordinary monitor variables such as the
T-state counter.

### Class 1: an address containing an address

Memory-view items use class 1. Bytes 5 and 6 point to a word that contains the
address to inspect.

For example, the `(HL)` item points to `savedRegisterHL`:

```asm
    defw savedRegisterHL
```

The renderer first reads the saved value of HL, then treats that value as the
start of memory to display.

In pseudocode:

```text
pointerVariable = descriptor.valueAddress
memoryAddress   = wordAt(pointerVariable)
valueSource     = memoryAddress
```

The same mechanism serves X and Y. Those are ordinary monitor-owned address
variables rather than Z80 registers, but from the renderer's point of view they
are simply words containing memory addresses.

### Class 0: flags

The F register is unusual enough to receive its own renderer. Its bits can be
shown as condition names or as an eight-bit binary row. We will return to this
shortly.

### Class 3: special areas

The edit line, list window, disassembly window and interrupt display are not
ordinary sequences of bytes. Class 3 diverts them to special handling.

The edit and general list descriptors mainly reserve screen regions. The
disassembly descriptor repeatedly calls the common one-line decoder. The
interrupt descriptor prints the saved `EI` or `DI` state.

The four classes let one table describe both simple values and larger panel
areas without turning every item into a separate function pointer.

## Byte 3 also selects representations

The upper bits of the same byte select output formats:

```text
bit 7  decimal
bit 6  hexadecimal
bit 5  binary
bit 4  character
bit 3  two-byte value rather than one byte
bit 2  vertical rather than horizontal sequence
```

These bits are independent. A value can be shown in more than one
representation.

A byte might therefore appear as:

```text
65 #41 01000001 A
```

if decimal, hexadecimal, binary and character formats are all enabled.

That is an important detail. The format is not a single enumeration such as:

```text
format = HEX
```

It is a set of switches:

```text
showDecimal   = yes
showHex       = yes
showBinary    = no
showCharacter = yes
```

The renderer inspects the four bits in a fixed order and calls every enabled
formatter.

## One byte or a word

Bit 3 chooses whether each logical value occupies one or two bytes.

For a byte item, the renderer zero-extends one byte into HL. For a word item, it
reads the normal little-endian pair.

The front panel uses this distinction naturally:

- A, B, C, D, E, H, L, I and R are byte items;
- AF, BC, DE, HL, SP, IX, IY and T are word items;
- a memory region can be switched between byte and word interpretation if its
  capability flags permit it.

The compact format-renderer table contains separate offsets for byte and word
versions of decimal, hexadecimal, binary and character output. Rather than store
eight full routine addresses, PROMETHEUS stores eight one-byte offsets from
`frontPanelValueRendererCodeBase`.

This is the same design habit we have seen elsewhere:

```text
small fixed family of nearby routines
    → store one-byte offsets
    → add offset to a known code base
    → JP (IX)
```

## Horizontal or vertical sequences

Bit 2 controls what happens after one logical value has been printed.

In horizontal mode, the next value continues on the same row. In vertical mode,
PROMETHEUS advances the bitmap cursor by one text row and resets the
between-format spacing state.

This matters mainly for memory views. Five bytes at SP can be shown beside one
another, or the same values can be arranged as a vertical column.

The renderer's high-level loop is:

```text
repeat descriptor.size times:
    read one byte or word

    for each enabled representation:
        print that representation

    if vertical:
        move to next text row
    else:
        continue on current row
```

The rendering code is compact, but this is the idea it implements.

## Byte 4: size and editing capabilities

The low five bits of descriptor byte 4 are the current size.

For an ordinary register item, size zero hides it and size one displays it.
For a memory item, the size can be the number of consecutive byte or word values
to show. For the list and disassembly windows, it is their height in text rows.

Two higher bits describe which panel-editor operations make sense:

```text
bit 6  byte/word type may be toggled
bit 5  horizontal/vertical direction may be toggled
```

Bit 7 marks a genuinely variable-size item. When it is set, A through Z in the
panel editor select sizes 0 through 25. When it is clear, only a hidden/visible
state is meaningful; the code discards the higher size bits.

This separation is subtle but useful:

```text
current state       lives in low five bits
allowed operations  live in upper capability bits
```

The panel editor can therefore remain generic. It tests the capability bit
before changing a property rather than knowing that, for example, SP memory is
resizable while register A is not.

## Hiding is part of rendering

`renderFrontPanelItemIfEnabled` begins with the simplest possible visibility
test:

```asm
    ld a,(ix+004h)
    and 01fh
    ret z
```

A zero size means “do not render this descriptor.” The caller still advances IX
by seven bytes and continues with the next descriptor.

There is no separate visible-items list and no branching tree describing the
current layout. Visibility is data.

That makes configuration persistent and cheap. Hiding I or showing AF means
changing one descriptor byte. The normal redraw loop immediately obeys it.

## How a normal item is rendered

The common entry is `renderFrontPanelItem`. In simplified pseudocode:

```text
reset between-format spacing
set screen cursor from descriptor bytes 0,1
resolve value source from descriptor source class
print heading
print colon

for each value requested by descriptor size:
    read byte or word
    print every enabled representation
    advance source pointer
    perhaps move down one screen row
```

The actual routine uses DE for the data pointer, HL for the screen cursor and IX
for the descriptor. It preserves and exchanges these values carefully because
all four representation routines expect slightly different register setups.

The interesting point is not each push and pop. It is that the record supplies
all policy needed by the common loop.

## The compact representation dispatcher

PROMETHEUS supports eight renderer variants:

```text
decimal byte       decimal word
hexadecimal byte   hexadecimal word
binary byte        binary word
character byte     character word
```

The table does not contain eight addresses. It contains offsets into a packed
cluster of small routines.

The chosen offset is added to:

```asm
frontPanelValueRendererCodeBase:
```

and the code jumps through IX.

A self-modified immediate inside
`dispatchFrontPanelValueRendererWithSeparator` remembers whether a previous
representation has already been printed. The first representation begins
immediately; later ones receive a separating space.

That tiny state avoids four nearly identical “if not first, print space” paths.

## Character form is deliberately defensive

A memory byte is not necessarily a printable character. The character renderer
therefore examines the low seven bits.

```text
$20..$7F  show the corresponding glyph
$00..$1F  show a dot
bit 7     preserve inverse-video meaning
```

Thus `$01` becomes `.`, while `$81` becomes an inverse-video dot. This same
policy is reused by the character memory listing in Chapter 36.

The monitor is not claiming that every byte is text. It is giving every byte a
stable one-cell visual form.

## Flags are a special language

The saved F byte has two panel interpretations.

In the default form, PROMETHEUS chooses one name from each of four pairs:

```text
Z / NZ
C / NC
PE / PO
M / P
```

For a cleared F register, the panel shows the clear alternatives, producing a
summary like:

```text
NZ NC PO P
```

The choices come from `frontPanelConditionNameSelectionTable`, whose records are
conceptually:

```text
flag mask, token when set, token when clear
```

When binary format is enabled for F, the special renderer instead prints a
heading resembling:

```text
SZ-H-PNC
```

and the eight actual bits beneath it.

The apparent instructions in the condition table are data. This is one of the
places where a linear disassembler is particularly misleading: the bytes happen
to form plausible branches and register operations, but the renderer reads them
as masks and name indexes.

## Special area: the disassembly window

The disassembly item does not point to saved data. Its selector diverts the
renderer to `.renderFrontPanelDisassemblyWindow`.

The current address is placed into the self-modified operand:

```asm
varcFrontPanelDisassemblyAddress:
    ld hl,00000h
```

The descriptor's low-five-bit size becomes a row count. For each row,
PROMETHEUS:

1. calls `disassembleNextLineToBuffer`;
2. renders the resulting 32-character line;
3. continues from the next address returned in HL.

The default descriptor size is two, so two disassembly rows appear. Changing the
size changes the number of decoded rows without changing the disassembly code.

## Special area: interrupt state

The interrupt-state descriptor selects another small special path. The saved
monitor byte `varcInterruptEnableState` is converted into the appropriate
mnemonic index and printed as `EI` or `DI`.

Again, the panel item stores no custom routine address. Its selector is enough
for the generic special-item handler to recognize it.

## Ordinary redraw versus complete redraw

Two related entries render descriptor ranges.

`redrawFrontPanelAtCurrentAddress` starts at the third descriptor—the
disassembly window—and renders 32 records. It deliberately leaves the edit line
and general scrolling list alone. Those areas may contain a prompt or the latest
listing output that should survive an ordinary monitor refresh.

`redrawEntireFrontPanel` begins at descriptor zero and renders all 34 records.
The panel editor uses this complete form because it must reveal every configured
area.

The shared loop is almost trivial:

```text
repeat B times:
    render descriptor if size is nonzero
    IX += 7
```

The complexity lives in the descriptor interpreter, not in the traversal.

## Editing the panel while it is alive

SYMBOL SHIFT+W enters `invokeFrontPanelEditor`.

The editor begins with a clever occupancy-map trick. It paints all 768 Spectrum
attribute cells with a special editor colour, then redraws all panel items.
Rendered characters replace that colour with the normal text attribute. Cells
that still retain the editor colour were not used by any item, so their bitmap
cells are cleared.

In pseudocode:

```text
paint every attribute cell with editor colour
render all panel descriptors

for each screen cell:
    if its attribute is still editor colour:
        clear its bitmap
```

No separate 32-by-24 occupancy array is needed. The Spectrum attribute screen
itself temporarily serves as the map.

## Selecting one descriptor

`varcActiveFrontPanelItemOffset` stores a byte offset, not an item number.
Because every item occupies seven bytes, the possible offsets are:

```text
0, 7, 14, 21, ...
```

The selected item is redrawn in the access-line colour. Keys 4 and 3 move to the
next or previous descriptor, wrapping cyclically at the ends.

The editor returns through a synthetic `invokeFrontPanelEditor` address after
each change. That causes the complete panel to be rebuilt, the new active item
to be highlighted and another key to be read.

This is the same warm-entry pattern used by the monitor itself, on a smaller
scale.

## Moving an item

Keys 5 through 8 move the selected descriptor left, down, up and right.

The code does not add simple constants to the address. It calls the Spectrum
bitmap movement helpers so row interleaving and screen wrapping remain correct.
The resulting bitmap address is written back into descriptor bytes 0 and 1.

The visible panel moves because the next repaint interprets the changed data.
There is no separate “move register A” implementation.

## Changing size

Letters A through Z are translated to values 0 through 25 and placed in the
size field.

For variable items, this means exactly what it suggests:

```text
A → size 0
B → size 1
C → size 2
...
Z → size 25
```

For fixed scalar items, only the visibility-sized low bit is retained. In
practice, the operation is used to hide or show them rather than to request a
row of seventeen copies of register A.

This lets the same input path serve list heights, disassembly heights, memory
sequence lengths and simple visibility.

## Changing format

Six shifted commands are described by `frontPanelFormatToggleKeyTable`:

```text
SS+D  toggle decimal
SS+H  toggle hexadecimal
SS+B  toggle binary
SS+C  toggle character
SS+T  toggle byte/word type, when supported
SS+S  toggle horizontal/vertical direction, when supported
```

Each table entry contains:

```text
key, required capability mask, bit to XOR
```

The first four format switches are generally applicable. Type and direction
first test their corresponding capability bits in descriptor byte 4. If the
item does not support the operation, the key has no effect.

The table bytes overlap plausible Z80 opcodes in a linear disassembly, but here
they are simply three-byte property-edit descriptions.

## The panel as an interpreted object

We can now return to the whole front panel.

At monitor entry:

```text
current address is loaded
    ↓
renderer starts at descriptor 2
    ↓
each visible record supplies screen position, heading and data policy
    ↓
ordinary values use the common format loop
    ↓
flags, interrupt state and disassembly use special branches
    ↓
the same records can later be edited in place
```

The panel feels fixed because its defaults are sensible. Internally it is a
small interpreted document.

That design saves code, but it also gives the monitor a feature unusual for such
a small machine: the user can rearrange the debugger's front panel without
reassembling PROMETHEUS.

## What has changed in memory?

During an ordinary redraw, only bitmap and attribute cells are changed. The
saved user state is read but not modified.

During panel editing, PROMETHEUS may modify:

- descriptor bytes 0 and 1 for position;
- descriptor byte 3 for format, type and direction;
- descriptor byte 4 for size or visibility;
- `varcActiveFrontPanelItemOffset` for the currently selected descriptor.

The records themselves are resident mutable configuration.

## Ideas needed by later chapters

- Register names and destinations can be recovered from the same descriptors
  used for display.
- The list window and disassembly window are configurable special areas.
- Memory items may dereference saved registers or panel-owned address words.
- Several output representations can be enabled simultaneously.
- Protection tables and address lists will reuse the same general philosophy:
  compact data plus one shared interpreter.

## Source coverage

This chapter explains `frontPanelItemDescriptors`, the seven-byte descriptor
format, `redrawFrontPanelAtCurrentAddress`, `redrawEntireFrontPanel`,
`renderFrontPanelItemIfEnabled`, `renderFrontPanelItem`, the compact value
renderer offsets, flags rendering, special-area rendering,
`invokeFrontPanelEditor` and `frontPanelFormatToggleKeyTable`.
