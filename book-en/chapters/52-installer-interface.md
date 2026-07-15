# Chapter 52: The Installer Interface

The bootstrap of the previous chapter was almost invisible. It cleared memory,
found itself, copied a small helper to `$5000`, and jumped there. Now the
program suddenly becomes visible. A logo appears, a detected address is printed,
and a small group of options can be changed before PROMETHEUS settles into its
permanent home.

This is the installer interface.

It is tempting to regard the installer as an unimportant front porch. After all,
it disappears as soon as installation finishes. But its source is a compact
lesson in the design habits used throughout PROMETHEUS:

- registers are left in useful states for the next operation;
- current settings are stored inside instruction operands;
- a synthetic return address replaces a larger dispatcher loop;
- strings live immediately after their `CALL` instructions;
- complete Z80 instructions are copied as configuration templates;
- the Spectrum bitmap is addressed according to its peculiar physical layout;
- one generic masked-field routine edits several unrelated packed settings.

The installer is small because almost every byte performs more than one job.

## What arrives at `$5000`

At the end of the bootstrap, execution reaches:

```asm
installerEntryAt5000:
```

The important state is already prepared:

```text
HL = first of the 320 remaining logo bytes in the physical CODE image
SP = private stack near $4020
top stack word = physical start of the complete origin-zero resident payload
next stack word = physical load base of the installation CODE block
```

The distinction between the last two addresses matters.

The **physical load base** is where the bootstrap itself began. The **payload
start** is farther into the same CODE block, after the bootstrap, installer,
relocation metadata and logo material. The installer must display the first
address as a useful default, but later it must copy from the second.

PROMETHEUS keeps both without creating a formal structure.

## Drawing the two-row logo

The first code in the fixed installer is:

```asm
installerEntryAt5000:
    ld de,VRAM_ADDRESS+0x26
    call installerDrawLogoRow
    ld e,046h
    call installerDrawLogoRow
```

Each logo row is twenty character columns wide and eight pixel rows high. The
source is linear: eight bytes for the first column, eight for the next, and so
on. The Spectrum screen is not linear in that way. Within one character cell,
the next pixel row is `$0100` bytes away.

The drawing routine therefore treats D and E as two different dimensions:

```asm
installerDrawLogoRow:
    ld c,014h
.installerDrawNextLogoColumn:
    ld b,008h
    push de
.installerCopyLogoColumnRows:
    ld a,(hl)
    ld (de),a
    inc hl
    inc d
    djnz .installerCopyLogoColumnRows
    pop de
    inc e
    dec c
    jr nz,.installerDrawNextLogoColumn
    ret
```

For one column:

```text
increment D -> move down one pixel row
restore DE  -> return to the top of the column
increment E -> move one byte right
```

This is lighter than calculating a fresh Spectrum bitmap address for every
byte. After two calls, HL has advanced by exactly 320 bytes and now points to
the resident payload in the physical CODE image.

The installer has used the logo as both decoration and pointer arithmetic.

## Exchanging the two important addresses

The next instruction is:

```asm
    ex (sp),hl
```

Immediately before it:

```text
HL       = physical payload start
(SP)     = physical load base
```

Immediately after it:

```text
HL       = physical load base
(SP)     = physical payload start
```

That single exchange gives the display code the number it wants while leaving
the later copy source safely on the stack.

The physical load base is converted into five decimal digits by repeated calls
to `installerEmitDecimalDigit`:

```asm
    ld bc,installationAddressString
    ld de,02710h
    call installerEmitDecimalDigit
    ld de,003e8h
    call installerEmitDecimalDigit
    ld de,00064h
    call installerEmitDecimalDigit
    ld e,00ah
    call installerEmitDecimalDigit
    ld e,001h
    call installerEmitDecimalDigit
```

The divisors are 10,000, 1,000, 100, 10 and 1. The helper repeatedly subtracts
the current divisor, counting successful subtractions as an ASCII digit:

```asm
installerEmitDecimalDigit:
    ld a,02fh
.installerDecimalSubtractLoop:
    inc a
    and a
    sbc hl,de
    jr nc,.installerDecimalSubtractLoop
    add hl,de
    ld (bc),a
    inc bc
    ret
```

Starting A at `'/'`, one below `'0'`, makes the first increment produce the
right digit. The final failed subtraction is repaired with `ADD HL,DE`, leaving
the remainder for the next decimal place.

The detected physical load address therefore becomes the initial proposed
installation address. The user may accept it unchanged or edit it.

## The installer is redrawn after every accepted key

The main interface begins at:

```asm
installerRedrawAndWait:
```

It prints the title, copyright line, instruction, address field and monitor
choice. Then it rebuilds the attribute layout, makes the configured click, waits
for a key and dispatches it.

There is no large conventional loop of the form:

```text
while not ENTER:
    draw screen
    key = read key
    perform action
```

Instead, the dispatcher pushes the redraw address as though it were a return
address:

```asm
.installerDispatchKey:
    ld hl,installerRedrawAndWait
    push hl
    ...
```

Most handlers end with an ordinary `RET`. That RET does not return to the line
after a CALL. It pops the synthetic address and jumps back to the complete
redraw path.

In pseudocode:

```text
push address_of_redraw
handle_key
RET                    ; means redraw and wait again
```

ENTER is the exception. It deliberately removes this synthetic return address
and proceeds into installation instead of returning to the interface.

This is the same general idea seen elsewhere in PROMETHEUS: the stack is not
merely for subroutine nesting. It can also hold the next state of a compact
state machine.

## Inline strings consume their own return address

The installer text appears in the source like this:

```asm
    ld hl,04082h
    call installerPrintInlineString
    defb "Spectrum Z80 Turbo Assemble",0xf2
```

The final character has bit 7 set. The apparent return address of the CALL is
therefore not code at first; it points at the string.

`installerPrintInlineString` performs this transformation:

```text
pop CALL return address -> source-string pointer
render bytes until one has bit 7 set
jump to the byte after the string
```

The subroutine eventually uses:

```asm
    jp (hl)
```

rather than RET, because HL has advanced beyond the marked final character.

This format saves a separate pointer word for each string and keeps text beside
the code that uses it. It is particularly suitable for a small, temporary
program whose strings are never searched independently.

## A private character renderer

The installer does not call the resident PROMETHEUS text renderer; that renderer
has not yet been installed. It contains a small renderer of its own.

For each character it:

1. removes the high-bit terminator marker;
2. optionally changes alphabetic case;
3. calculates the corresponding Spectrum ROM-font address;
4. copies eight glyph rows into the bitmap;
5. optionally thickens each row;
6. advances to the next character cell.

The ROM glyph calculation is compact:

```asm
.installerLocateRomGlyph:
    add a,a
    ld h,00fh
    ld l,a
    add hl,hl
    add hl,hl
```

The result is the ROM character-generator address for the selected printable
character. The destination is remembered in an immediate operand:

```asm
varcInstallerStringDestination:
    ld de,04000h
```

After rendering one character, the routine changes the operand of this `LD DE`
so the next iteration starts one column to the right.

Again, code is serving as state.

## Three case policies are complete instructions

Pressing C cycles among three display policies:

```text
0 = preserve source case
1 = force lower case
2 = force upper case
```

The policies are represented by real two-byte instructions:

```asm
installerCaseModeInstructionTable:
    and 0ffh
    or 020h
    and 0dfh
```

`AND $FF` leaves A unchanged. `OR $20` forces the lowercase bit for letters.
`AND $DF` clears it.

The selected pair of bytes is copied over:

```asm
varcInstallerCaseTransform:
    and 0ffh
```

The rendering loop then executes the selected operation directly. It does not
load a mode byte and branch three ways for every character.

Pseudocode for the setting change is:

```text
mode = (mode + 1) modulo 3
template = caseInstructionTable[mode]
overwrite caseTransformInstruction with template
```

The case-mode index itself is stored in the immediate operand of another
instruction:

```asm
varcInstallerCaseMode:
    ld a,000h
```

There is no separate installer settings record. The executable bytes *are* the
record.

## Bold text is a one-byte code toggle

The renderer reads one ROM glyph row into A. It then reaches:

```asm
varcInstallerBoldTransform:
    nop
    or (hl)
```

In normal mode, NOP leaves the row alone and `OR (HL)` merely ORs the byte with
itself.

When D is pressed, the NOP opcode `$00` is XORed with `$0F`, turning it into
`RRCA`:

```text
RRCA row
OR original row
```

A pixel and its one-position rotation are merged, making the strokes appear
two pixels thick.

Pressing D again XORs `$0F` a second time and restores NOP.

The same one-byte XOR helper also toggles the monitor choice, although with a
different mask:

```asm
.installerXorToggleByte:
    xor (hl)
    ld (hl),a
    ret
```

For bold, A contains `$0F`. For the monitor flag, A contains `$4D`.

## The monitor option is deliberately encoded as the letter M

The monitor setting is held here:

```asm
varcMonitorInstallFlag:
    ld a,04dh
```

`$4D` is ASCII M. Pressing M XORs the operand with `$4D`, so it alternates
between:

```text
$4D -> monitor included
$00 -> assembler only
```

Later, installation uses `RRCA`. Bit 0 of `$4D` becomes carry, while zero leaves
carry clear. Thus the same byte is:

- a convenient XOR mask;
- a readable reminder of the M key;
- a Boolean value;
- a future source of the carry flag that selects the image layout.

This is a tiny but characteristic piece of multi-purpose encoding.

## Colour settings are packed Spectrum attributes

The Spectrum attribute byte contains several fields:

```text
bits 0-2  INK
bits 3-5  PAPER
bit  6    BRIGHT
bit  7    FLASH
```

The installer stores two editable attribute values inside instructions:

```asm
varcInstallerTextAttribute:
    ld (hl),038h

varcInstallerHighlightAttribute:
    ld (hl),030h
```

Unshifted I, P and B change the normal-text attribute. Shifted I, P and B edit
the highlighted-line attribute.

One helper updates all of these fields:

```asm
.installerAdjustMaskedSetting:
    ld a,e
    cpl
    and (hl)
    ld c,a
    ld a,(hl)
    add a,d
    and e
    or c
    ld (hl),a
    ret
```

Its mathematical meaning is:

```text
preserved = old AND NOT mask
changed   = (old + step) AND mask
new       = preserved OR changed
```

The caller selects the field with D and E:

```text
INK:    step $01, mask $07
PAPER:  step $08, mask $38
BRIGHT: step $40, mask $40
```

Because the changed value is masked, it wraps within its own field without
altering neighbouring settings.

The same routine even adjusts the keyboard click duration:

```text
step +1 or -1
mask $3F
```

The data is different, but the packed-field operation is the same.

## Some colours are derived rather than selected directly

PROMETHEUS sometimes wants text to be invisible while preserving its background
colour. The helper:

```asm
attributeCopyPaperColourToInk:
```

copies the three PAPER bits down into the INK field. Conceptually:

```text
result = keep high attribute bits
         OR paperColourPlacedInInkBits
```

INK and PAPER then match, so glyph pixels disappear against the cell
background.

The installer uses this derived value for small hidden or border-like cells and,
when ENTER is pressed, for several resident configuration destinations.

It also derives the ULA border colour by retaining only the low three colour
bits after the PAPER-to-INK conversion.

## The key echo is real ULA sound

The current click duration is stored here:

```asm
varcKeyboardEchoDelay:
    ld e,00ah
```

The installer derives border-related output bits from the selected PAPER colour
and repeatedly toggles bit 4 while writing port `$FE`:

```asm
.installerEchoTonePulseLoop:
    out (0feh),a
    djnz .installerEchoTonePulseLoop
```

Bit 4 drives the Spectrum speaker. X increments the six-bit duration and CAPS
SHIFT+X decrements it. The adjusted click is heard before the next key is read,
so the setting is immediately testable.

This small feedback loop is good interface design within severe constraints:
the user does not need a separate “test sound” command.

## Reading and normalizing a key

The installer uses Spectrum ROM keyboard services:

```asm
.installerWaitForKey:
    call ROM_KeyboardScanning
    jr nz,.installerWaitForKey
    call ROM_KeyboardTest
    jr nc,.installerWaitForKey
```

The ROM also reports shift state. PROMETHEUS represents a shifted installer key
by adding `$80` to the translated character code. Thus values such as these can
be compared directly:

```text
CAPS SHIFT+I -> $C9
CAPS SHIFT+P -> $D0
CAPS SHIFT+B -> $C2
CAPS SHIFT+X -> $D8
DELETE       -> $B0
```

This is a private convention of the installer. It is not the same complete
keyboard-token system used later by the editor.

## Editing the five-digit address

The address field is embedded in an inline string:

```asm
installationAddressString:
    defb "00000_",0xa0
```

The underscore is the cursor. Its current position is remembered in the operand
of:

```asm
varcInstallationAddressCursor:
    ld hl,installationAddressString+5-installerEntryAt5000+LOADER_ADDRESS
```

A digit overwrites the underscore and moves it right. DELETE moves it left,
turns the old cursor into a space and writes the underscore at the new position.
The immediate operand is patched to remember the result.

The byte after the five-digit field has bit 7 set because it terminates the
inline string. Testing that bit prevents a sixth digit from being entered.

The left boundary is recognized by examining the colon before the field. The
code refuses to move DELETE across it.

The editor later uses much richer cursor machinery. Here a pointer, an
underscore and two sentinels are enough.

## There is almost no destination validation

The field contains up to five decimal digits. On ENTER it is parsed with
repeated multiplication by ten:

```text
value = value * 10 + nextDigit
```

The multiplication is built from shifts:

```asm
    add hl,hl       ; old * 2
    push hl
    add hl,hl       ; old * 4
    add hl,hl       ; old * 8
    pop bc
    add hl,bc       ; old * 10
```

Arithmetic is sixteen-bit and therefore wraps naturally. The small installer
does not perform the extensive collision checks used by the resident editor and
assembler. It assumes the user chooses a sensible destination.

That is historically understandable but important for a modern reader: a
configurable address is not automatically a safe address.

## The interface in pseudocode

The whole visible installer can now be written without register details:

```text
draw two-row logo
exchange payload pointer for physical load base
format physical load base as default decimal destination

repeat:
    draw all installer strings
    draw Yes or No for monitor choice
    rebuild colour attributes
    make click using selected duration and colour
    wait for translated key

    if key edits normal colour:
        update selected packed attribute field
    else if shifted key edits highlight colour:
        update selected packed attribute field
    else if key is D:
        toggle bold instruction opcode
    else if key is M:
        toggle monitor-selection operand
    else if key is X or shifted X:
        change click duration
    else if key is C:
        copy next case instruction template into renderer
    else if key is DELETE or a digit:
        edit decimal destination string
    else if key is ENTER:
        leave interface and commit installation
```

The code does not hold these choices in a conventional structure. It reads them
later from the modified instructions that have been implementing the preview.

## What changed in memory

During one trip around the interface, PROMETHEUS may modify:

- the bitmap containing logo and text;
- the attribute file containing logo, normal and highlight colours;
- the inline decimal address string;
- the operand of `varcInstallationAddressCursor`;
- the operand of `varcInstallerTextAttribute`;
- the operand of `varcInstallerHighlightAttribute`;
- the operand of `varcKeyboardEchoDelay`;
- the operand of `varcMonitorInstallFlag`;
- the operand of `varcInstallerCaseMode`;
- the complete instruction at `varcInstallerCaseTransform`;
- the opcode at `varcInstallerBoldTransform`;
- the operand of `varcInstallerStringDestination` while text is rendered.

These are temporary installer bytes at `$5000`, not yet the resident payload.
The next two chapters explain how selected values are copied into that payload
and how the requested resident image is moved to its final address.

## Important labels encountered

- `installerEntryAt5000`
- `installerDrawLogoRow`
- `installerEmitDecimalDigit`
- `installerRedrawAndWait`
- `installerPrintInlineString`
- `varcInstallerStringDestination`
- `varcInstallerCaseTransform`
- `varcInstallerBoldTransform`
- `varcInstallerCaseMode`
- `varcMonitorInstallFlag`
- `varcInstallerTextAttribute`
- `varcInstallerHighlightAttribute`
- `varcKeyboardEchoDelay`
- `varcInstallationAddressCursor`
- `.installerAdjustMaskedSetting`
- `attributeCopyPaperColourToInk`

## Back to the whole machine

The installer is a preview of the resident application. It already demonstrates
custom text rendering, compact strings, direct screen access, packed Spectrum
attributes, keyboard normalization and self-modifying state. But the settings
currently exist only in the temporary copy at `$5000`.

Pressing ENTER begins a different phase. The screen stops being an interface and
the installer becomes a transformation engine: it writes selected settings into
the origin-zero payload, chooses one of two payload layouts, copies it safely,
relocates its internal addresses and transfers control to the result.
