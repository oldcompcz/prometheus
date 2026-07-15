# Chapter 8: Talking to the Spectrum

PROMETHEUS does not live above the ZX Spectrum as a polite application asking an operating system to draw a window or report a key. There is no window manager, no graphics library, and no background service translating every hardware detail into a convenient object.

The program talks to the machine much more directly.

It writes character pixels into screen memory.

It writes colours into a separate attribute area.

It asks the Spectrum ROM to scan the keyboard, but sometimes reads the keyboard port itself when it needs faster feedback.

It drives the border and speaker through the same ULA output port.

It uses ROM tape routines for physical recording and loading, while building its own higher-level file structures around them.

This chapter is not a complete guide to Spectrum hardware. It introduces only the parts needed to understand PROMETHEUS. The detailed editor key translation belongs to Chapter 10, and tape workflows belong to Part IV. Here our goal is to understand the shared machine-facing layer on which those later systems depend.

## The screen is two different memories

The visible Spectrum display combines two regions:

```text
$4000-$57FF   bitmap pixels
$5800-$5AFF   colour attributes
```

The bitmap contains 6,144 bytes. Each bit is one pixel, so one byte describes eight horizontal pixels.

The attribute area contains 768 bytes, one for each 8×8 character cell in a 32-column by 24-row display.

An attribute byte chooses:

- ink colour;
- paper colour;
- brightness;
- flashing.

This separation has an important consequence. Drawing a character and colouring its cell are two different operations.

PROMETHEUS reflects that distinction in two layers:

- `displayCharacter` writes the eight bitmap rows;
- `displayNormalCharacter` calls it and then writes the corresponding attribute byte.

Some callers need only pixels. Others need a complete text cell.

## Why the bitmap address looks strange

A modern linear framebuffer might store scanlines one after another. The Spectrum bitmap is interleaved.

Within one character cell, successive pixel rows are separated by `$0100`, not by 32 bytes. The three large screen thirds are also arranged in a way that makes simple vertical arithmetic surprising.

PROMETHEUS avoids deriving the full general formula every time. Its character renderer works with the representation naturally suited to the machine:

- increment the low byte to move one character right;
- increment the high byte to move to the next pixel row within an 8×8 glyph;
- add eight to the high byte when a horizontal row wraps to the next text row;
- wrap from the end of bitmap memory back to `$4000` where appropriate for its cursor cycle.

The details are encoded in `displayCharacter`.

## A character begins in the ROM font

The Spectrum ROM contains an 8-byte bitmap for each printable character. PROMETHEUS converts the low seven bits of the character code into a font address.

The high bit has another job: it selects inverse video.

The opening of the renderer is compact:

```asm
displayCharacter:
    add a,a
    ld h,00fh
    ld l,a
    sbc a,a
    ld c,a
    add hl,hl
    add hl,hl
```

The arithmetic constructs the address of the eight-byte ROM glyph while converting the old top bit into either `$00` or `$FF` in `C`.

That `$00`/`$FF` value is an inversion mask:

```text
normal:   glyph XOR $00 = glyph
inverse:  glyph XOR $FF = opposite pixels
```

This is a useful Z80 technique. `SBC A,A` turns carry into a full-byte mask:

```text
carry clear → A = $00
carry set   → A = $FF
```

A single flag becomes eight identical bits.

## Eight rows, one character

The current screen destination is stored inside this self-modifying instruction:

```asm
varcPrintingPosition:
    ld de,SECOND_LINE_ADDRESS
```

The renderer saves the starting destination and loops eight times:

```asm
ld b,008h
.renderEightGlyphRowsLoop:
    ld a,(hl)
configurationPatchTarget01CharacterBoldTransform:
    nop
    or (hl)
    xor c
    ld (de),a
    inc hl
    inc d
    djnz .renderEightGlyphRowsLoop
```

Each iteration:

1. reads one font row;
2. optionally thickens it;
3. optionally inverts it;
4. stores it in bitmap memory;
5. advances to the next font row;
6. advances to the next Spectrum pixel plane row.

The curious pair:

```asm
nop
or (hl)
```

is the configurable bold transform introduced in Chapter 5. The installer changes the first byte so execution is either effectively normal or performs the thickening combination chosen by the original program.

The important point is not the exact visual style. It is that installation configuration changes an instruction inside the hot rendering loop, avoiding a branch for every glyph row.

## Advancing the text cursor

After drawing the eight scanlines, PROMETHEUS advances one character cell horizontally:

```asm
inc l
jr nz,.commitNextCharacterBitmapPosition
```

If the low byte wraps, the renderer has crossed the end of a 32-byte bitmap scanline. It then adjusts the high byte to the next text row:

```asm
ld a,h
add a,008h
cp 058h
jr nz,.storeWrappedBitmapRowHighByte
ld a,040h
```

Finally the next destination is written back into the operand of `varcPrintingPosition`.

In pseudocode:

```text
draw eight glyph rows at printingPosition

printingPosition moves one byte right
if horizontal byte wrapped:
    move to next Spectrum character row

remember new printingPosition
```

Many higher-level renderers therefore do not pass a destination for every character. They set the shared cursor once and repeatedly call the character routine.

## Pixels and colours reunite

`displayNormalCharacter` surrounds the bitmap renderer with alternate-register protection and attribute calculation:

```asm
displayNormalCharacter:
    exx
    call displayCharacter
    ld a,h
    add a,00ah
    cp 05ah
    jr z,.storeTextAttribute
.mapBitmapRowToAttributeRowLoop:
    add a,007h
    cp 058h
    jr c,.mapBitmapRowToAttributeRowLoop
.storeTextAttribute:
    ld h,a
varcTextColor:
    ld (hl),038h
    exx
    ret
```

The mapping arithmetic converts the bitmap address returned for the character cell into its attribute address.

The exact sequence looks odd because the Spectrum bitmap's high-byte layout is odd. The result is conceptually simple:

```text
attributeAddress = attribute cell corresponding to the glyph just drawn
attribute[attributeAddress] = configured text colour
```

`varcTextColor` stores the current attribute in an instruction operand. Different parts of PROMETHEUS patch it before rendering source, status information, selections, or monitor fields.

## Safe character output preserves the other register bank

Several scanners use the main `HL` and `DE` registers to walk text or source structures. The character renderer also needs working registers.

PROMETHEUS uses the alternate register bank to keep the two jobs separate:

```asm
displayCharacterSafely:
    exx
    call displayCharacter
    exx
    ret
```

From the caller's perspective, the important scanning registers survive.

`displayCharacterAtHL` adds packed-string support:

```asm
displayCharacterAtHL:
    ld a,(hl)
    and 07fh
```

It removes the high-bit terminator before entering the safe renderer.

This layer explains why many text loops are so small. They can keep their pointer in the normal register set while the renderer works in the alternate set.

## Clearing a line means clearing eight separated bitmap rows

A 32-character text row is not 256 consecutive bytes in screen memory. It consists of eight 32-byte pixel rows, each in a different bitmap plane.

`clearBitmapTextRow` therefore uses two loops:

```text
repeat 8 pixel rows:
    clear 32 bytes
    move to next pixel plane
```

The source routine follows that shape:

```asm
ld b,008h
.clearNextBitmapPlaneRow:
    push hl
    ld c,020h
.clearThirtyTwoBitmapBytesLoop:
    ld (hl),000h
    inc l
    dec c
    jr nz,.clearThirtyTwoBitmapBytesLoop
    pop hl
    inc h
    djnz .clearNextBitmapPlaneRow
```

A line-clearing caller supplies the bitmap address of the first pixel row in a text cell row.

This is a specialized operation. It is faster and clearer than invoking the full character renderer thirty-two times with spaces when only pixels need to be removed.

## Clearing the whole editor through its own renderer

PROMETHEUS also has a more general display clear:

```asm
clearDisplayToSpaces:
    ld e,020h
clearDisplay:
    ld bc,00003h
.clearDisplayCharacterLoop:
    ld a,e
    call displayNormalCharacter
    djnz .clearDisplayCharacterLoop
    dec c
    jr nz,.clearDisplayCharacterLoop
    ret
```

The pair `BC=$0003` may look like a count of three, but `DJNZ` with `B=0` performs 256 iterations before `B` returns to zero. The outer `C` loop repeats this three times:

```text
3 × 256 = 768 character cells
```

That is exactly the Spectrum's 32×24 text grid.

This is a classic compact-loop trick:

```text
B = 0 means 256 iterations under DJNZ
```

`startPrometheus` places the separator character in `E`, whereas `clearDisplayToSpaces` places a space there. Both use the same complete-screen loop.

The routine draws through the normal character and attribute machinery, ensuring that the configured font and colour path establishes a consistent display state.

## Fast source scrolling copies existing pixels

Repainting twenty expanded source lines after every arrow-key repeat would be expensive. PROMETHEUS instead shifts already-rendered bitmap rows and draws only the newly exposed line.

`copyScreenTextRowAtYToDE` asks a Spectrum ROM routine to translate a text-row coordinate into the corresponding bitmap address:

```asm
ld c,000h
call ROM_PixelAddress_22b0
```

Then `copyEightBitmapRows` copies all eight pixel planes for the row:

```asm
copyEightBitmapRows:
    push hl
    push de
    ld b,008h
.copyNextBitmapRow:
    push hl
    push de
    ld c,020h
.copyNextByteInBitmapRow:
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    dec c
    jr nz,.copyNextByteInBitmapRow
    pop de
    pop hl
    inc h
    inc d
    djnz .copyNextBitmapRow
```

This is not the generic `moveMemoryBlockOverlapSafe` routine because a text row is not one contiguous 256-byte block. Each of its eight 32-byte slices has a different high byte.

The routine advances horizontally inside each slice, then increments the high bytes for the next plane.

During held-arrow scrolling, the editor repeatedly calls this primitive to shift visible lines up or down, clears one newly exposed row, and renders only one compressed source record there.

This is an early example of an optimisation chosen around the Spectrum's display layout rather than around abstract text rows.

## The access line is coloured separately

The editor's active access row has its bitmap text and its attribute strip managed separately.

At warm start:

```asm
ld hl,ACCESS_LINE_ATTRIBUTE_ADDRESS
ld bc,02000h+HIGHLIGHT_COLOR
call atHLrepeatBTimesC
```

The shared filler interprets:

```text
B = 32 cells
C = highlight attribute
```

and writes the attribute value across the row.

This is cheap because attributes are linear: one byte per character cell. The complicated bitmap arrangement does not apply.

Later, when a submitted edit line is hidden before parsing, another 32-byte attribute fill makes ink and paper the same colour. The pixels need not be erased first; their attributes make them invisible during the operation.

The Spectrum's separate colour memory is therefore not merely a limitation. PROMETHEUS uses it as a fast display-control layer.

## The keyboard can be read at two levels

PROMETHEUS normally calls the ROM keyboard scanner:

```asm
call ROM_KeyboardScanning
```

The ROM returns a key-table index and modifier information. Chapter 10 will follow the complete translation into letters, commands, arrows, CAPS LOCK behaviour, debounce, and autorepeat.

At this level, the important contract is:

```text
ROM scanner → physical key index + modifier class
PROMETHEUS  → normalized editor or monitor key code
```

However, the editor sometimes bypasses the full translation and reads port `$FE` directly:

```asm
ld a,0efh
in a,(0feh)
```

This occurs during fast scrolling. The code has already accepted a down-arrow or up-arrow command. It now needs only one simple answer:

```text
Is that physical key still held?
```

Running the complete command translator on every copied screen row would be unnecessary. A direct matrix-row test is faster.

The program uses the level of abstraction appropriate to the question:

- ROM scan for a new general key event;
- direct port sample for a known held key;
- another direct sample during long imports to detect SPACE/BREAK or a request to refresh the display.

## Active-low keyboard bits

Spectrum keyboard matrix reads are active-low:

```text
0 bit → key pressed
1 bit → key released
```

This is why source sometimes uses `CPL` after reading port `$FE`. Complementing the byte converts pressed keys into set bits, which are easier to test using ordinary masks.

A young reader may naturally expect “pressed” to equal one. Hardware does not promise that convention. The circuit design determines the electrical meaning; software adapts.

## One ULA port controls border and sound

The Spectrum's ULA output port is also `$FE`.

The low bits choose the border colour. Another bit controls the small speaker path.

PROMETHEUS restores its configured border with:

```asm
setBorderColor:
    ld a,007h
    out (0feh),a
    ret
```

The actual immediate byte is an installer-configured value.

The key click and general beep use the same port:

```asm
.beepToggleLoop:
    ld b,e
    xor 010h
.beepPulseDelayLoop:
    out (0feh),a
    djnz .beepPulseDelayLoop
```

`XOR $10` flips the speaker bit. The inner delay loop holds one phase for a duration chosen in `E`. Repeating the phases creates a square wave.

The border bits remain in the same output byte, so the beep routine also carries a configured border colour. Without that care, sound output could unexpectedly change the border.

## Sound is made from timing loops

There is no background sound synthesizer here. The CPU itself alternates the output bit and spends time in delay loops.

Conceptually:

```text
repeat for requested total duration:
    flip speaker output
    write ULA port repeatedly for one half-wave delay
```

The pitch depends on how long each phase lasts. The overall beep length depends on how many phases are generated.

Because the CPU is busy during the beep, PROMETHEUS keeps the key click short. The click is feedback, not a musical performance.

This also explains why exact timing can vary if the code path changes. Cycle counts are part of the result.

## ROM routines are services with contracts

PROMETHEUS mixes direct hardware access with calls into the Spectrum ROM.

Examples include:

- `ROM_KeyboardScanning` — scan the keyboard matrix;
- `ROM_PixelAddress_22b0` — convert coordinates into bitmap addresses;
- `ROM_ChannelOpen` and `RST $10` — print through Spectrum channels;
- tape loading and saving entries;
- `ROM_StatementReturn` — return to BASIC;
- `ROM_NEWCommandRoutine` — enter the ROM's NEW path.

A ROM address should not be treated as a magical incantation. Each call has an implicit calling convention:

```text
inputs in certain registers or system variables
result in certain registers and flags
some registers or memory may be changed
interrupt state may matter
```

The reconstruction gives these addresses descriptive names so the reader can think about the service rather than memorising hexadecimal numbers.

For example, leaving PROMETHEUS for BASIC does not merely jump to a ROM address:

```asm
invokeBasic:
    ld iy,05c3ah
    im 1
    ei
    ld sp,(SYSVAR_ERR_SP)
    jp ROM_StatementReturn
```

It restores assumptions expected by the ROM:

- `IY` points into the Spectrum system-variable area;
- interrupt mode 1 is active;
- maskable interrupts are enabled;
- the stack uses the ROM's saved error-return position.

Only then is the ROM statement-return path safe to enter.

## PROMETHEUS usually keeps interrupts disabled

`startPrometheus` begins with:

```asm
di
```

The resident editor and monitor frequently use alternate registers, self-modifying state, exact timing, and their own stack arrangements. A normal Spectrum interrupt handler could disturb those assumptions.

When PROMETHEUS deliberately uses a ROM service that expects interrupts, it enables them locally. Printing source through ROM channel 3, for example, includes:

```asm
call ROM_ChannelOpen
ei
...
rst ROM_PrintACharacter
```

Returning to BASIC restores the normal interrupt environment permanently.

The policy is therefore not simply “interrupts are always off.” It is:

```text
resident PROMETHEUS owns the machine and normally disables interrupts
ROM-facing paths restore the environment required by the ROM
```

## The stack is also part of the machine interface

At every warm start, the editor sets:

```asm
ld sp,internalStackTop
```

This discards any abandoned internal calls and re-establishes a known private stack.

Returning to BASIC instead loads `SP` from `SYSVAR_ERR_SP`, because the ROM expects its own stack frame and error-return chain.

The stack pointer is therefore not merely a local implementation detail. It helps decide which software world currently owns the machine:

- PROMETHEUS resident stack;
- saved user-program stack in the monitor;
- Spectrum ROM/BASIC stack.

Later chapters will show the monitor switching among these worlds while single-stepping another program.

## Tape access has two layers

The physical Spectrum tape routines understand signals, pilot tones, headers, flags, checksums, and byte blocks. PROMETHEUS calls those ROM services rather than reproducing the pulse decoder.

Above that layer, PROMETHEUS defines its own meaning for the bytes:

- editor SAVE packages source and symbols;
- LOAD and VERIFY interpret that package;
- GENS import treats the payload as line-oriented foreign text;
- the monitor saves or loads raw memory blocks;
- the distributed TAP contains a BASIC loader and the installable code image.

This is another recurring architectural split:

```text
ROM: move physical bytes to or from tape
PROMETHEUS: decide what those bytes mean
```

We will return to it in Chapters 29–32 and 41.

## Why not use ROM text output for the editor?

The ROM can print characters, so why does PROMETHEUS carry its own font renderer?

Several reasons follow from the source:

- PROMETHEUS wants exact control over bitmap destinations;
- it uses several independent screen regions rather than one ROM cursor;
- it changes source case without changing quoted text;
- it supports selectable normal/bold rendering;
- it draws inverse and special marker characters;
- it scrolls source rows by copying bitmap planes;
- it normally runs with interrupts disabled and outside the ROM's standard channel environment;
- monitor front-panel rendering uses compact descriptors and direct positions.

The ROM remains useful for occasional external printing and coordinate translation, but the interactive interface is its own display system.

## A complete character-output path

Suppose the editor wants to display the letter `A` in the source listing.

The path is approximately:

```text
expanded source scanner obtains 'A'
    ↓
displayCharacterSafely protects scanning registers
    ↓
displayCharacter finds the ROM glyph
    ↓
eight glyph rows are transformed and written to bitmap memory
    ↓
printing position advances
    ↓
displayNormalCharacter maps the cell to attribute memory
    ↓
configured text attribute is stored
```

If the character comes from a packed high-bit string, `displayCharacterAtHL` masks off the terminator bit first.

If it is a token byte rather than a character, `displayInputTokenOrCharacter` expands the token into a packed word and sends each character through the same output path.

## A complete held-arrow scroll

For a held down-arrow:

```text
processKey accepts the down command
    ↓
active source-record pointer advances
    ↓
existing visible bitmap rows are copied upward
    ↓
newly exposed bottom row is cleared
    ↓
the appropriate compressed source record is expanded and drawn there
    ↓
port $FE is sampled directly
    ↓
repeat while the physical arrow key remains held
```

This avoids rebuilding all twenty source lines for every repeat.

The editor still performs a full warm redraw when necessary, but the common held-key case receives a hardware-aware fast path.

## A complete key click

```text
normalized key accepted
    ↓
keypressBeep loads configured duration
    ↓
beep combines configured border bits with speaker state
    ↓
speaker bit alternates through timed OUT ($FE),A loops
    ↓
normal editor processing resumes
```

The same ULA write controls two visible/audible properties, so the routine must preserve their intended combination.

## Back to the whole machine

PROMETHEUS is not isolated from the Spectrum by a thick software layer. Its design follows the physical machine.

The interleaved bitmap encourages an eight-plane character renderer and specialized row copier.

The separate attributes encourage cheap colour-strip changes and hiding through equal ink and paper.

The keyboard matrix encourages a ROM translation path for general events and direct port tests for known held keys.

The combined border/speaker port encourages careful output-byte construction.

The ROM encourages selective reuse: PROMETHEUS borrows mature services such as tape and keyboard scanning but keeps control of its own interactive display and internal data.

Understanding this relationship prevents a common mistake when reading the source. A strange loop or address calculation may not be a private PROMETHEUS invention. It may be the shape of the Spectrum hardware showing through.

## What has changed in memory or hardware?

After one normal character is rendered:

- eight bitmap bytes have been written in separate pixel-plane rows;
- one attribute byte has been assigned;
- `varcPrintingPosition` points to the next character cell.

After a fast row copy:

- eight groups of thirty-two bitmap bytes have moved;
- attributes are left to the surrounding editor logic because the source window's colour layout is stable.

After a border write:

- the ULA immediately changes the visible border colour.

During a beep:

- the speaker-control bit alternates while the border bits remain present in the output byte.

During a ROM call:

- registers, flags, system variables, stack, and interrupt state must satisfy the service's contract.

## Important ideas for later chapters

- Spectrum pixels and colours live in separate memory regions.
- a text row is not one contiguous bitmap block.
- `varcPrintingPosition` is the shared resident screen cursor.
- the character high bit can select inverse rendering.
- alternate registers protect text scanners from the renderer.
- direct port access and ROM services coexist; each is used where it fits best.
- the same `$FE` port participates in keyboard input, border output, and sound output, with direction and selected lines determined by the operation.
- resident PROMETHEUS normally owns the machine with interrupts disabled, but ROM-facing paths restore ROM assumptions.

## Source anchors explained

- `displayCharacter`
- `displayNormalCharacter`
- `displayCharacterSafely`
- `displayCharacterAtHL`
- `displayUninvertedCharacter`
- `varcPrintingPosition`
- `varcTextColor`
- `configurationPatchTarget01CharacterBoldTransform`
- `clearBitmapTextRow`
- `clearLineAtHL`
- `clearDisplay`
- `clearDisplayToSpaces`
- `copyScreenTextRowAtYToDE`
- `copyEightBitmapRows`
- `setBorderColor`
- `keypressBeep`
- `beep`
- `getKeypressCodeOrZero` at interface level
- `ROM_KeyboardScanning`
- `ROM_PixelAddress_22b0`
- `ROM_ChannelOpen`
- `ROM_PrintACharacter`
- `invokeBasic`
- `internalStackTop`
