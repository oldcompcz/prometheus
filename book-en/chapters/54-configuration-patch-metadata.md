# Chapter 54: Configuration Patch Metadata

The installer preview stores its choices inside the temporary program at
`$5000`. The resident payload contains its own copies of corresponding
instructions and colour constants. Before the payload is moved, the installer
must transfer selected values into those distant locations.

There are fourteen destinations. They are scattered across the monitor,
assembler, editor, symbol-table display, keyboard and character-rendering code.
Some lie thousands of bytes apart; the next destination may be lower or higher
than the previous one.

PROMETHEUS visits them with a stream of signed sixteen-bit deltas used as a
temporary Z80 stack.

This mechanism is distinct from the relocation table:

- configuration patching writes selected **values and opcodes**;
- relocation later adds a base to selected **address words**.

Confusing the two would make the installer seem far more mysterious than it is.

## The fourteen destinations

In installer write order, the reconstructed source names them:

| Order | Payload offset | Purpose |
|---:|---:|---|
| 1 | `$29CE` | character bold-transform opcode |
| 2 | `$2502` | two-byte source case-transform instruction |
| 3 | `$2950` | keypress beep duration |
| 4 | `$0F0C` | monitor normal text attribute |
| 5 | `$16A4` | symbol-table normal attribute |
| 6 | `$29BC` | generic resident text attribute |
| 7 | `$0ECC` | front-panel editor fill attribute |
| 8 | `$0EDA` | front-panel editor comparison attribute |
| 9 | `$2021` | hidden edit-line attribute |
| 10 | `$2959` | keypress-beep border colour |
| 11 | `$1A41` | ordinary resident border colour |
| 12 | `$1F13` | warm-start access-line attribute |
| 13 | `$16A7` | symbol-table highlight attribute |
| 14 | `$0F04` | monitor access-line attribute |

The order is not sorted by address. It is chosen to match the compact write
sequence: several destinations receive the same A value, so the installer can
write, advance, write again and avoid reloading the setting.

## Why the table is generated now

In the historical source, the fourteen deltas were precomputed bytes. That was
reasonable for a finished fixed-layout program, but it is fragile during a
reconstruction. Adding one instruction before a destination moves that label and
silently makes every later hard-coded displacement wrong.

The resurrected build marks every destination with an ordered annotation such
as:

```asm
configurationPatchTarget03KeypressBeepDuration: equ $+1 ; @config-patch 03
    ld e,01eh
```

A build-time generator assembles the source, resolves the label offsets and
writes:

```asm
installerConfigurationPatchDeltas:
include "configurationPatchTable.asm"
```

The generated file contains fourteen little-endian signed words—twenty-eight
bytes in total.

For the unchanged program, the generator reproduces the historical bytes
exactly. For a modified program, it follows the labels.

This modern generator is reconstruction tooling. The resident Z80 decoder and
the compact table format remain the original design.

## Offsets rather than installed addresses

The configuration destinations are expressed relative to the start of the
physical origin-zero payload. They do not depend on the requested resident base.

At ENTER, HL is loaded with the physical payload pointer:

```asm
    pop hl
    push hl
```

The first delta advances from that pointer to destination 1. Every later delta
advances from the preceding destination.

Therefore the same table works whether the CODE block was loaded at `$5DC0`,
`$8000` or another address. All destinations move together with the physical
payload source.

This is not relocation because no address stored *inside* the payload is being
rebased. The installer is merely finding bytes in the source image before it
copies them.

## The delta sequence

The generated report describes the current walk:

```text
start at payload offset $0000
+10702 -> $29CE
 -1228 -> $2502
 +1102 -> $2950
 -6724 -> $0F0C
 +1944 -> $16A4
 +4888 -> $29BC
 -6896 -> $0ECC
   +14 -> $0EDA
 +4423 -> $2021
 +2360 -> $2959
 -3864 -> $1A41
 +1234 -> $1F13
 -2156 -> $16A7
 -1955 -> $0F04
```

Negative numbers are ordinary two’s-complement words. For example:

```text
-1228 = $FB34
```

The table stores `$34,$FB` because Z80 words are little-endian.

A delta stream does not necessarily use fewer data bytes than fourteen absolute
sixteen-bit offsets. Its main advantages here are operational:

- HL remains a running destination pointer;
- no original base needs to be reloaded for each target;
- one tiny helper can consume the next target from the stack;
- moving source labels can regenerate the walk mechanically;
- the write order can follow value reuse rather than address order.

## Replacing the installer stack with the table

The most surprising line is:

```asm
    ld sp,installerConfigurationPatchDeltas-installerEntryAt5000+LOADER_ADDRESS
```

Before doing this, the installer writes the live private stack pointer into an
instruction operand:

```asm
    ld (varcInstallerSavedStackPointer+1-installerEntryAt5000+LOADER_ADDRESS),sp
```

Later it restores SP by executing that patched instruction:

```asm
varcInstallerSavedStackPointer:
    ld sp,00000h
```

Between those moments, SP points into read-only-looking table bytes that are
being used as a sequence of words.

No ordinary nested calls may consume the table accidentally. The helper is
carefully written so CALL and RET coexist with the next delta.

## How one delta is consumed

The helper is:

```asm
installerAdvancePatchPointer:
    pop bc
    pop de
    add hl,de
    push bc
    ret
```

Suppose the stack initially contains:

```text
next delta
following delta
...
```

A `CALL installerAdvancePatchPointer` first pushes its return address above the
next delta:

```text
return address
next delta
following delta
...
```

Inside the helper:

```asm
pop bc
```

removes and preserves the return address.

```asm
pop de
```

consumes the signed delta.

```asm
add hl,de
```

moves the running destination pointer.

```asm
push bc
ret
```

restores the return address and returns normally, leaving SP positioned at the
following delta.

In pseudocode:

```text
function advancePatchPointer():
    savedReturn = popWord()
    delta       = popWord()
    HL          = HL + delta
    pushWord(savedReturn)
    return
```

The table is a stack, the CALL return address temporarily interrupts it, and the
helper carefully removes that interruption.

## Writing and advancing are fused

Most one-byte destinations use:

```asm
installerStoreAAndAdvancePatchPointer:
    ld (hl),a
```

and then fall directly into `installerAdvancePatchPointer`.

Thus:

```asm
call installerStoreAAndAdvancePatchPointer
```

means:

```text
write A at current target
consume next delta
advance HL to next target
```

The final destination is written with a plain:

```asm
    ld (hl),a
```

because no fifteenth delta exists.

## Patch 1: boldness as an opcode

The first advance moves HL from payload start to offset `$29CE`. The installer
loads its own currently selected bold opcode:

```asm
    ld a,(varcInstallerBoldTransform)
    call installerStoreAAndAdvancePatchPointer
```

A is either:

```text
$00 = NOP
$0F = RRCA
```

That opcode is copied into the corresponding resident character-rendering
instruction. The resident renderer will later execute the selected policy
without testing a Boolean setting for each glyph row.

Configuration patching is therefore able to copy code as well as ordinary data.

## Patch 2: case policy as a two-byte instruction

Destination 2 receives the complete instruction stored at
`varcInstallerCaseTransform`:

```asm
    ld de,(varcInstallerCaseTransform-installerEntryAt5000+LOADER_ADDRESS)
    ld (hl),e
    inc hl
    ld (hl),d
    dec hl
    call installerAdvancePatchPointer
```

The possibilities are:

```asm
and 0ffh
or 020h
and 0dfh
```

Each is two bytes. HL is returned to the first byte before the next delta is
added, because generated deltas are measured from the marked destination label,
not from the byte after a multi-byte patch.

This detail matters. Without `DEC HL`, every later target would be one byte too
high.

## Patch 3: keyboard-click duration

The third target receives the immediate byte from:

```asm
varcKeyboardEchoDelay:
    ld e,00ah
```

The installer preview and resident keyboard loop therefore use the same selected
six-bit duration.

## Patches 4–6: one normal attribute reused

A is loaded once from the normal installer text attribute:

```asm
    ld a,(varcInstallerTextAttribute+1)
```

Then three consecutive write-and-advance calls send it to:

1. monitor normal text;
2. symbol-table normal text;
3. generic resident text.

The delta order was chosen so A can remain unchanged.

This is why the target sequence jumps from `$0F0C` to `$16A4` to `$29BC` rather
than following source order. Execution economy has shaped metadata order.

## Patches 7–8: a nearby attribute variant

After the third normal-attribute patch, the code executes:

```asm
    xor 001h
```

and writes the result to two front-panel editor locations.

Only bit 0 changes. The exact visual meaning follows the resident routines that
consume these bytes, but the important design is clear: the installer derives a
closely related variant rather than storing and editing another independent
choice.

The two destinations are only fourteen bytes apart. The corresponding generated
delta is `+14`, the smallest movement in the table.

## Patch 9: invisible edit-line text

The current attribute is converted by:

```asm
    call attributeCopyPaperColourToInk
```

INK becomes equal to PAPER. The resulting byte is written to the hidden
edit-line attribute destination.

This makes text pixels invisible without losing the selected background and
brightness.

## Patches 10–11: border colours

After patch 9, the code keeps only the three low colour bits:

```asm
    and 007h
```

The value is written twice:

- keypress-beep border colour;
- normal resident border colour.

The paper colour selected for ordinary text has therefore also selected the ULA
border colour and the border bits used while making keyboard sound.

One user choice propagates coherently through screen cells, border and click.

## Patches 12–14: highlight attributes

Finally A is reloaded from:

```asm
varcInstallerHighlightAttribute:
```

and written to:

- warm-start access-line attribute;
- symbol-table highlight attribute;
- monitor access-line attribute.

Again the installer loads once and uses the generated walk to distribute the
same setting to three subsystems.

## The complete runtime sequence

The entire patch operation can be summarized as:

```text
HL = physicalPayloadStart
save real installer SP
SP = address of generated delta stream

advance to target 1
write selected bold opcode
advance to target 2
write selected two-byte case instruction
advance to target 3
write click duration

advance through targets 4..6, writing normal attribute
modify attribute slightly
advance through targets 7..8, writing front-panel variant
derive paper-equals-ink attribute
write target 9
extract three-bit colour
write targets 10..11
load selected highlight attribute
write targets 12..14

restore real installer SP
```

The delta table supplies locations; the straight-line installer code supplies
meaning and values.

## Build-time validation

The reconstructed generator does more than calculate bytes. It verifies that:

- all fourteen order numbers are present exactly once;
- their labels resolve inside the relocatable payload;
- the generated target sequence decodes back to the same labels;
- checked-in generated output is not stale;
- the unchanged source reproduces the historical twenty-eight bytes exactly.

Layout mutation tests insert and remove bytes in both major payload regions and
confirm that the configuration table changes with the labels.

This modern safety net is especially appropriate for a literate reconstruction.
It preserves the compact original runtime technique while removing the old
requirement that every earlier byte remain at its historical address.

## Why not patch after copying?

It would be possible to relocate and copy the image first, then find fourteen
resident addresses and write settings there. That would require each target to
be expressed in final installed coordinates or adjusted for full versus
assembler-only layout.

Patching the physical origin-zero source first is simpler:

```text
one source pointer
one relative target walk
one set of settings
then ordinary block copy
```

For assembler-only mode, monitor destinations are patched even though those
bytes will not be copied. That costs a few harmless writes but avoids a second
conditional configuration sequence.

The suffix destinations that matter receive the selected values and travel with
the 11,000-byte copy.

## Configuration and relocation compared

The two metadata systems can now be contrasted precisely.

### Configuration table

```text
14 targets
signed 16-bit deltas
used before copy
points into physical source payload
writes chosen bytes/opcodes
includes only installer-configurable locations
```

### Relocation table

```text
1,293 targets in the historical image
compressed mostly as one-byte gaps and repeated runs
used after copy
points into installed destination image
adds an installation-dependent 16-bit base to address words
includes every relocatable internal absolute word
```

Configuration answers:

> What behavior and appearance did the user select?

Relocation answers:

> Where does this copied program live now?

## What changed in memory

The patch phase changes fourteen marked payload destinations:

- one bold opcode;
- one two-byte case instruction;
- one click-duration byte;
- several normal, derived, border and highlight attributes.

It also temporarily changes:

- the operand of `varcInstallerSavedStackPointer`;
- SP, which walks through `installerConfigurationPatchDeltas`;
- HL, which moves forward and backward across the physical payload.

After the phase, the private installer stack is restored and the generated table
remains unchanged.

## Important labels encountered

- `installerConfigurationPatchDeltas`
- `installerAdvancePatchPointer`
- `installerStoreAAndAdvancePatchPointer`
- `varcInstallerSavedStackPointer`
- `varcInstallerBoldTransform`
- `varcInstallerCaseTransform`
- `varcKeyboardEchoDelay`
- `varcInstallerTextAttribute`
- `varcInstallerHighlightAttribute`
- `attributeCopyPaperColourToInk`
- `configurationPatchTarget01CharacterBoldTransform`
- `configurationPatchTarget14MonitorAccessLineAttribute`

## Back to the whole machine

The physical payload now contains the user’s chosen personality. It has the
selected font thickness, alphabetic case behavior, click duration and colour
scheme before a single resident byte is moved.

The installer can copy either layout and be confident that the retained parts
carry the right settings.

But the copy still contains origin-zero internal addresses. The next chapter
explains the larger generated metadata system that finds 1,293 such words and
rebases them without mistaking constants, ROM calls, relative branches or
opcode-shaped data for pointers.
