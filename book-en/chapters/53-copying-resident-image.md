# Chapter 53: Copying the Resident Image

Pressing ENTER changes the nature of the installer.

Until this moment, it has behaved like a tiny interactive application. Its
self-modified operands describe colours, case, boldness, click duration, monitor
selection and the chosen decimal address. After ENTER, those settings are
committed and the installer performs an irreversible sequence:

```text
copy settings into the physical payload
parse destination address
choose full or assembler-only image
prepare the chosen source layout
copy it to the requested destination
relocate internal absolute words
build a resident stack
enter the installed program
```

This chapter concentrates on selecting and copying the resident image. The next
chapter returns to the first step—configuration patching—in detail, because its
stack-driven delta walk deserves an explanation of its own. Chapter 55 will then
open the relocation streams.

## Leaving the redraw machine

Every ordinary key handler has a synthetic return address on the stack. ENTER
must not return there:

```asm
.installerCheckEnterKey:
    cp 00dh
    ret nz
    pop af
```

If A is not carriage return, `RET NZ` redraws the installer in the usual way.
If it *is* ENTER, `POP AF` discards `installerRedrawAndWait`, the synthetic return
address pushed by the dispatcher.

The next stack word is the physical payload pointer that was preserved when the
installer first exchanged HL with `(SP)`:

```asm
    pop hl
    push hl
```

HL receives the pointer for immediate configuration patching. It is pushed back
because the later copy stage will need it again.

This stack word has survived the entire interactive session. No separate global
variable was required.

## Settings are committed before the image moves

The installer now visits fourteen marked bytes or instructions inside the
physical origin-zero payload and changes them to match the preview. It does this
*before* copying.

That ordering is valuable:

- the same patch sequence works regardless of final destination;
- the selected bytes are copied together with the resident image;
- no configuration address has to be relocated first;
- full and assembler-only copies receive the same relevant settings;
- the patch destinations can be expressed relative to the payload source.

After the fourteenth patch, the temporary configuration-table stack is restored
and the decimal destination is parsed into HL.

## Parsing the destination

The address characters are stored in `installationAddressString`. Parsing stops
at the underscore cursor:

```asm
.installerParseAddressDigit:
    ld a,(de)
    inc de
    cp 05fh
    jr z,.installerAddressParsed
```

For every digit:

```text
HL = HL * 10
HL = HL + digit
```

The multiplication uses only `ADD HL,HL` and one saved partial result:

```asm
    add hl,hl
    push hl
    add hl,hl
    add hl,hl
    pop bc
    add hl,bc
```

If old HL was x:

```text
first ADD       -> 2x, saved in BC later
second ADD      -> 4x
third ADD       -> 8x
ADD saved 2x    -> 10x
```

Then ASCII `'0'` is subtracted and the digit is added.

The result is a sixteen-bit destination. No separate range type exists; overflow
wraps just like any other Z80 word arithmetic.

## Restoring source and destination roles

At `.installerAddressParsed`, HL contains the requested destination. The saved
physical payload pointer is popped into DE and the registers are exchanged:

```asm
.installerAddressParsed:
    pop de
    ex de,hl
```

The result is the standard Z80 block-copy convention:

```text
HL = source payload
DE = destination
```

The monitor-selection byte is then transformed into carry:

```asm
    ld a,(varcMonitorInstallFlag+1-installerEntryAt5000+LOADER_ADDRESS)
    rrca
    push af
```

As Chapter 52 explained:

```text
$4D -> bit 0 is 1 -> carry set   -> full image
$00 -> bit 0 is 0 -> carry clear -> assembler only
```

AF is pushed because copying and relocation will reuse the condition later.

## The full image is one origin-zero object

For a full installation the source begins at:

```asm
ENTRY_POINT_WITH_MONITOR
```

and extends to:

```asm
relocatablePayloadEnd
```

The current reconstructed source expresses the length symbolically:

```asm
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITH_MONITOR
```

For the historical image this is:

```text
$3E80 = 16,000 bytes
```

Its conceptual layout is:

```text
payload offset $0000          monitor entry and monitor prefix
payload offset $1388          assembler/editor entry
payload offset $3E80          end
```

The origin-zero assembly means that words pointing within the image initially
contain offsets. Copying preserves those offsets. Relocation later adds the
chosen destination base to all words that truly represent internal addresses.

If carry is set, no source selection work is needed:

```asm
    jr c,.installerCopyImage
```

HL already points at the first payload byte and BC already contains 16,000.

## The assembler-only image is the suffix

When carry is clear, the first 5,000 bytes are omitted. The retained source
begins at:

```asm
ENTRY_POINT_WITHOUT_MONITOR
```

The prefix size is expressed by:

```asm
ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
```

Historically this is:

```text
$1388 = 5,000 bytes
```

The suffix length is:

```asm
relocatablePayloadEnd-ENTRY_POINT_WITHOUT_MONITOR
```

or historically:

```text
$2AF8 = 11,000 bytes
```

The important point is not merely that fewer bytes are copied. The suffix was
linked as part of the complete origin-zero image, beginning at logical offset
`$1388`. When it is installed alone, its first byte becomes resident offset
zero. Several assumptions therefore need intentional correction.

## The first assembler-only correction happens in the source payload

Before advancing HL past the monitor prefix, the installer patches one word in
the physical source image:

```asm
installerPrepareAssemblerOnlyImage:
    push hl
    push de
    ld bc,emitByteAtAssemblyOutput+1-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld bc,ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    pop de
    pop hl
```

The code finds the word stored in the operand at
`emitByteAtAssemblyOutput+1`, adds the monitor-prefix length and writes it back.

This is not the general relocation operation. It is a layout conversion made
because the same retained assembler body must work when its normal full-image
context has been removed.

The source and destination pointers are preserved around the patch. Afterwards:

```asm
    add hl,bc
```

advances the physical source from the full payload start to the assembler-only
entry. BC is then replaced by the 11,000-byte suffix length.

In pseudocode:

```text
if assembler_only:
    specialWord += monitorPrefixLength
    source       += monitorPrefixLength
    length        = assemblerSuffixLength
```

The second intentional assembler-only patch is applied after relocation. We
will meet it in Chapter 55 because its address is found relative to the final
relocation target.

## Why not assemble two unrelated binaries?

PROMETHEUS could have carried two separately linked resident programs on tape.
That would make installation simpler but enlarge the tape image and duplicate
almost all code.

Instead it stores one complete origin-zero payload and derives the smaller
variant by:

- skipping the monitor prefix;
- changing the additive relocation base for the shared suffix;
- applying two deliberate compatibility patches.

This is a space-saving design. It also means that the assembler/editor code in
both products is literally the same bytes apart from the documented patched
words.

## Choosing copy direction

The source payload is still located somewhere in the loaded CODE block. The
requested resident destination may lie:

- below it;
- at the same address;
- above it without overlap;
- above it with overlap.

A naïve `LDIR` is unsafe in the final case. Copying forward could overwrite
source bytes before they have been read.

PROMETHEUS compares the starting addresses:

```asm
.installerCopyImage:
    push de
    push hl
    xor a
    sbc hl,de
    pop hl
    jr c,.installerCopyImageBackward
    ldir
    jr .installerRelocateCopiedImage
```

After `SBC HL,DE`, carry is set when source is below destination. The installer
then chooses backward copying.

The rule is slightly more conservative than a full overlap test:

```text
if destination <= source:
    copy forward
else:
    copy backward
```

If destination is above source but far enough away not to overlap, backward
copying is unnecessary but still correct. The simpler comparison saves code and
covers the dangerous case.

## Forward copying

When destination is not above source, `LDIR` is safe:

```asm
    ldir
```

It repeatedly performs:

```text
(DE) = (HL)
HL++
DE++
BC--
```

until BC reaches zero.

This handles destinations below the source, including overlapping downward
moves. A byte is read before anything later can overwrite it.

## Backward copying

For a destination above the source, both start pointers are converted to
inclusive end pointers:

```asm
.installerCopyImageBackward:
    add hl,bc
    dec hl
    ex de,hl
    add hl,bc
    dec hl
    ex de,hl
    lddr
```

Conceptually:

```text
sourceEnd      = sourceStart + length - 1
destinationEnd = destinationStart + length - 1
copy backwards
```

`LDDR` then decrements the pointers after every byte. Bytes at the high end are
secured before the low end of the destination can overwrite their old source
positions.

This is the same memmove principle introduced in Chapter 7, now used on the
program’s own resident body.

## The original destination survives the copy

Before comparing pointers, the installer executes:

```asm
    push de
```

That saved destination is later popped into BC after the block move:

```asm
.installerRelocateCopiedImage:
    pop bc
    ld d,b
    ld e,c
```

The block instructions leave HL and DE at direction-dependent positions. The
saved word restores a stable reference:

```text
BC = installed base retained for arithmetic and final entry
DE = running relocation target pointer initially at installed base
```

This is another reason not to infer semantic meaning from the final register
state of `LDIR` or `LDDR`. The installer preserves the value it truly needs
before starting the move.

## Copying has not made the image runnable yet

After the move, bytes are in the chosen physical place, but absolute internal
words still contain origin-zero values or full-image offsets.

For example, if a copied instruction contains a word meaning:

```text
address of resident routine at payload offset $2500
```

then a full installation at `$8000` needs:

```text
$2500 + $8000 = $A500
```

An assembler-only installation needs a different correction because its copied
suffix has been shifted down by `$1388`:

```text
full-image offset + destination - $1388
```

The relocation streams encode exactly which words require these additions. JR
and DJNZ displacements, ROM addresses, screen addresses, constants and marked
address-looking data must not be changed.

The move and the relocation are therefore separate operations:

```text
copy      -> changes where bytes live
relocate  -> changes selected address words inside those bytes
```

## Entering the installed program

After relocation and the final assembler-only compatibility patch, the installer
builds a new stack inside the resident image:

```asm
.installerStartRelocatedProgram:
    ld hl,00104h
    add hl,de
    ld sp,hl
    push bc
    ret
```

At this point DE is the running relocation pointer left at the final target of
the second stream, and BC has been restored to the selected resident entry
address. Adding `$0104` to that final target reaches the resident
`internalStackTop` in either layout.

The sequence:

```asm
    push bc
    ret
```

is a compact indirect jump. RET pops the just-pushed word into PC.

For the historical full layout, the final target is resident offset `$2CDD`,
so the stack becomes resident offset `$2DE1`. In the assembler-only layout both
positions are shifted down by the omitted `$1388` prefix. The `$0104` is
therefore relative to the final relocation target, not directly to the image
base.

The stack is now inside the resident program rather than in the temporary bitmap
workspace. The installer is finished and its `$5000` code no longer matters.

Interrupts are still disabled from the bootstrap. The resident entry code takes
responsibility for establishing the runtime environment appropriate to the
monitor or assembler/editor.

## Copy stage in pseudocode

Ignoring configuration and relocation details, the image-selection stage is:

```text
destination = parseDecimalAddress()
source      = physicalPayloadStart

if monitorEnabled:
    length = payloadEnd - monitorEntry
    layout = FULL
else:
    patch one retained assembler word for suffix use
    source += assemblerEntry - monitorEntry
    length  = payloadEnd - assemblerEntry
    layout  = ASSEMBLER_ONLY

save destination

if destination <= source:
    copyForward(source, destination, length)
else:
    copyBackward(source, destination, length)

restore destination
relocate according to layout
apply remaining assembler-only compatibility patch if needed
create resident stack
jump to installed entry
```

## What changed in memory

By the end of the copy stage:

- the physical payload has received the selected configuration bytes;
- assembler-only mode has modified one word in the physical suffix source;
- either 16,000 or 11,000 bytes have been copied to the requested destination;
- the destination may overlap the original CODE block safely;
- the origin-zero words inside the copy still await relocation;
- the temporary installer and logo remain at `$5000`/screen memory but are no
  longer needed after transfer.

## Important labels encountered

- `.installerCheckEnterKey`
- `.installerParseAddressDigit`
- `.installerAddressParsed`
- `varcMonitorInstallFlag`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `installerPrepareAssemblerOnlyImage`
- `emitByteAtAssemblyOutput`
- `.installerCopyImage`
- `.installerCopyImageBackward`
- `.installerRelocateCopiedImage`
- `.installerStartRelocatedProgram`

## Back to the whole machine

PROMETHEUS now exists in its final memory region, but only as copied bytes. The
installer has solved the physical movement problem and has selected either the
complete workshop or its assembler/editor suffix.

Two kinds of internal correction surround that copy:

1. **configuration patching**, which writes the user’s chosen behavior and
   appearance into fourteen marked destinations;
2. **relocation**, which rebases every true internal absolute address.

The first is explained next. The second is the subject of Chapter 55.
