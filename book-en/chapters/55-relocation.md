# Chapter 55: Relocation

The selected resident image is now in its final memory region. Its bytes are in
the right place, and its colours and keyboard behaviour have been configured.
Yet the program still cannot safely run.

The reason is hidden inside many ordinary-looking Z80 instructions.

PROMETHEUS was assembled as though its resident payload began at address zero.
A jump near its beginning therefore contains an address such as `$1F09`, not
`$7CC9` or `$9F09`. After the image is copied to a real destination, every such
internal absolute address must be adjusted.

That adjustment is relocation.

PROMETHEUS contains a remarkably small runtime relocator. The reconstruction
adds a build-time generator that discovers its targets by assembling the same
payload at several artificial origins. Together they solve two different
problems:

- the generator decides **which words need adjustment**;
- the resident installer performs **the adjustment chosen by the user**.

## A jump that still believes the program begins at zero

The first resident bytes are:

```asm
relocatablePayloadStart:
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

At origin zero, `startPrometheus` is at payload offset `$1F09`. The instruction
therefore begins as:

```text
C3 09 1F
```

`C3` is the opcode for an absolute `JP`. The following little-endian word is
`$1F09`.

Suppose the user installs the full system at `$8000`. The desired target is:

```text
$8000 + $1F09 = $9F09
```

The copied instruction must become:

```text
C3 09 9F
```

Only the two-byte operand changes. The opcode remains the same.

In general, a full installation needs:

```text
installedWord = linkedWord + residentBase
```

The runtime relocator repeats this addition at every address-bearing word in the
payload.

## Not every number that changes control flow is relocatable

A naïve program might scan for every `JP`, `CALL` and `LD` opcode and alter the
following bytes. That would fail quickly.

First, absolute addresses appear outside instructions:

- words in tables;
- callback addresses;
- screen or buffer pointers stored as data;
- initial operands of self-modifying instructions;
- front-panel descriptor pointers;
- routine addresses used by indirect dispatchers.

Second, not every word following an address-like opcode is an internal pointer.
PROMETHEUS also contains:

- Spectrum ROM addresses;
- fixed hardware and screen addresses;
- numeric constants;
- masks;
- counts;
- opcode-shaped data;
- differences between labels.

Third, relative control flow does not need this treatment. `JR` and `DJNZ`
store a signed distance from the instruction itself. When the entire program
moves together, source and target move by the same amount, so the distance stays
unchanged.

For example, the running program's:

```asm
LOOP    DJNZ LOOP
```

remains `$10,$FE` no matter where the two-byte instruction is placed.

Relocation therefore needs semantic information that is not visible from a
simple byte scan.

## The historical answer: a precomputed target stream

The original finished program carried a compact list of relocation targets.
The list did not store 1,293 absolute offsets. Instead it stored the distance
from one target to the next.

This was an excellent runtime representation:

- the installer keeps one running pointer in DE;
- most target gaps fit in one byte;
- repeated instruction patterns create repeated gaps that can be compressed;
- the decoder is tiny;
- the table is temporary and may modify itself while being consumed.

The weakness appears only when humans begin changing the source. Insert one
instruction before a target and every later precomputed distance may become
wrong.

The resurrection therefore preserves the original stream format but generates
its contents from the current source.

## Discovering relocation by changing the origin

The central observation is simple:

> An internal origin-dependent word changes by exactly the amount by which the
> payload origin changes.

The build assembles the resident payload at six artificial origins:

```text
$0000
$0101
$1234
$4000
$7FFF
$C000
```

For each two-byte position, it compares the emitted little-endian word.

Let:

```text
W0 = word emitted at origin $0000
WB = word emitted at probe origin B
```

The position is a relocation candidate only when every probe satisfies:

```text
WB = W0 + B  modulo 65536
```

The first entry-point operand illustrates this perfectly:

```text
origin $0000 -> $1F09
origin $0101 -> $200A
origin $1234 -> $313D
origin $4000 -> $5F09
origin $7FFF -> $9F08
origin $C000 -> $DF09
```

The differences are exactly the selected origins, including ordinary sixteen-bit
wraparound.

A ROM call does not behave that way. A constant address such as `$028E` remains
`$028E` in every probe. A label difference such as:

```asm
ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
```

also remains constant, because both labels move together.

This differential method understands the assembler's final meaning without
needing to write a second Z80 parser.

## Why several origins are better than one

Two builds—zero and one nonzero origin—would already identify most sites. The
additional probes guard against coincidences.

A pair of unrelated bytes might accidentally differ by `$0101` between two
builds because another layout effect changed them. It is far less likely to
imitate all five nonzero origins.

The probes also include difficult values:

- `$0101` changes both low and high bytes;
- `$1234` is irregular enough to expose byte-order mistakes;
- `$7FFF` crosses the signed boundary;
- `$C000` exercises wraparound near the top of the Z80 address space.

For the current historical payload, the generator reports:

```text
payload length                         16,000 bytes
assembler-only boundary               $1388
origin-dependent bytes                2,588
origin-dependent candidate words      1,294
explicit @noreloc exclusions              1
generated relocation words            1,293
monitor stream                           571
assembler stream                         722
unsupported one-byte dependencies          0
```

The 2,588 changing bytes are exactly two for each of the 1,294 candidate words.

## The one intentional exception

One origin-dependent word is not a pointer at all:

```asm
relocationExceptionMonitorEntryDescriptorWord:
    defw ENTRY_POINT_WITH_MONITOR+2 ; @noreloc
```

This word lives in a packed memory-access descriptor. Its low and high bytes are
being reused as opcode-shaped table fields. The expression moves with the
origin, so differential detection correctly notices that it is origin
dependent. But the runtime must not add the installation base to it as if it
were an address.

The explicit annotation states the semantic exception.

This is safer than embedding the exception only in the generator code. The
reason remains beside the unusual data, where a future reader will see it.

The generator also supports `@reloc` for an unusual word that should be forced
into the table, although the current source needs no such addition.

## Catching address bytes that the runtime cannot repair

The historical relocator adjusts complete little-endian words only. A source
construct equivalent to:

```asm
defb LOW someResidentLabel
```

would produce one origin-dependent byte. It would not be covered by a detected
two-byte target, and the runtime table could not express it.

The generator therefore performs a second, byte-level comparison. Every changing
byte must belong to one accepted relocation word. Otherwise the build fails and
reports:

- payload offset;
- value emitted at every probe origin;
- assembler listing line responsible for the byte.

This turns a subtle future runtime failure into an immediate build error.

## Splitting the table at the monitor boundary

The resident payload has two possible physical layouts:

```text
full image:
    offsets $0000-$3E7F copied

assembler-only image:
    original offsets $1388-$3E7F copied to destination offset $0000
```

One relocation stream begins at the full-image origin. The second begins at the
assembler boundary.

The generated source names them:

```asm
vr_l05353h:       ; first, monitor-region stream
    ...

vr_l05547h:       ; second, assembler-region stream
    ...
```

The names are historical reconstruction labels, not meaningful original names.
What matters is their role.

The split allows:

- full installation to apply stream 1 and then stream 2;
- assembler-only installation to skip stream 1 and apply the shared suffix
  stream with a different addend.

The first stream currently contains 571 words. The second contains 722.

## Turning targets into deltas

Within each stream, relocation offsets are sorted. The generator converts them
into gaps from the previous target.

For the first stream, the initial previous position is zero. Its first byte is:

```text
$01
```

That means:

```text
move from payload offset $0000 to $0001
relocate the word there
```

Offset `$0001` is the operand of the opening `JP startPrometheus`.

For the second stream, the initial previous position is the assembler boundary
`$1388`. Its first target is `$1389`, again the operand immediately after the
entry-point `JP` opcode, so its first gap is also one.

A normal single target uses:

```text
$01-$C7  -> advance by this distance and relocate one word
```

A zero byte terminates the stream.

The largest directly representable single gap is therefore `$C7`, or 199 bytes.
The generator refuses to produce an invalid stream if a future layout creates a
larger gap. Extending the historical format should be a deliberate source
change, not silent corruption.

## Compressing repeated gaps

Z80 code often contains tables or repeated instruction shapes whose address
operands are equally spaced. PROMETHEUS compresses such runs.

The repeated form is:

```text
prefix $C8-$FF
count byte
```

Its distance is:

```text
distance = prefix - $C8
```

For example:

```text
$CF,$1D
```

means:

```text
$CF - $C8 = 7-byte gap
$1D       = 29 repetitions
```

So the decoder relocates twenty-nine words, each seven bytes after the previous
one.

The current generator uses this two-byte representation when at least two
identical gaps occur and the gap is small enough to fit the repeated prefix.
Otherwise it emits the ordinary one-byte gaps separately.

The whole generated table—including two stream terminators/padding—occupies far
less space than 1,293 sixteen-bit absolute offsets would.

## The runtime decoder modifies its own table

The decoder begins:

```asm
installerApplyRelocationTable:
    ld a,(hl)
    or a
    ret z
    ld (hl),001h
    cp 0c8h
    jr c,.installerApplyRelocationRun
    sub 0c8h
    inc hl
```

For a short-form gap, the original byte is overwritten with 1. HL still points
to it. That byte becomes a synthetic count:

```text
perform this gap once
```

For a repeated form, A is changed from prefix to distance and HL advances to the
real count byte.

In both cases the following loop sees:

```text
A    = gap
(HL) = repetitions remaining
```

This is destructive decoding. That is acceptable because the table belongs to
the temporary installer at `$5000`. It is never needed again after installation.

A more formal decoder would keep a separate count register. PROMETHEUS saves
bytes by borrowing the table itself.

## Advancing the target pointer

DE is the running address in the installed image. The gap in A is added to its
low byte:

```asm
    add a,e
    ld e,a
    jr nc,.installerRelocateWord
    inc d
```

This is a compact sixteen-bit addition of an unsigned eight-bit distance:

```text
E = E + gap
if low byte wrapped:
    D = D + 1
```

The stream format guarantees a positive gap no larger than 199, so no larger
arithmetic is needed.

## Rebasing one word

At the selected target, the code must add BC to the little-endian word while
preserving both pointers:

```asm
.installerRelocateWord:
    pop af
    push hl
    ex de,hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    add hl,bc
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ex de,hl
    pop hl
```

The register exchanges are dense, but the logical operation is ordinary:

```text
streamPointer = HL
wordPointer   = DE

word = readWord(wordPointer)
word = word + relocationAddend
writeWord(wordPointer, word)

restore streamPointer and running wordPointer
```

The run count is then decremented in place:

```asm
    dec (hl)
    jr nz,.installerApplyRelocationRun
    inc hl
    jr installerApplyRelocationTable
```

When it reaches zero, HL advances to the next encoded gap.

## Runtime decoder in pseudocode

The whole routine can be written as:

```text
function applyRelocationStream(stream, target, addend):
    while true:
        prefix = stream.byte

        if prefix == 0:
            return target

        if prefix < $C8:
            gap = prefix
            count = 1
            overwrite prefix with count
        else:
            gap = prefix - $C8
            stream++
            count is stored at stream.byte

        while stream.byte != 0:
            target += gap
            writeWord(target, readWord(target) + addend)
            stream.byte--

        stream++
```

The returned `target` is important. The installer uses the final position of one
stream as the starting reference for later arithmetic.

## Full installation: add the selected base

After copying, the installer recovers the selected destination:

```asm
.installerRelocateCopiedImage:
    pop bc
    ld d,b
    ld e,c
    pop af
    push bc
    push af
```

For the full layout:

```text
BC = selected resident base
DE = selected resident base
```

The first stream starts with gaps measured from payload offset zero, so DE begins
at the payload base:

```asm
    ld hl,vr_l05353h
    call installerApplyRelocationTable
```

Every linked word receives:

```text
word += residentBase
```

The first stream ends at payload offset `$11C0`. The second stream was encoded as
though its previous position were the assembler boundary `$1388`. The installer
bridges that gap symbolically:

```asm
    ld hl,ENTRY_POINT_WITHOUT_MONITOR
          -ENTRY_POINT_WITH_MONITOR
          -RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET
    add hl,de
    ex de,hl
```

For the historical layout:

```text
$1388 - $11C0 = $01C8
```

DE becomes:

```text
residentBase + $1388
```

The shared second stream can now continue with the same addend BC.

## Assembler-only installation: subtract the omitted prefix

The assembler-only image copies original payload offset `$1388` to destination
offset zero.

A linked word containing original offset `$2500` should become:

```text
destination + ($2500 - $1388)
```

Rearrange that expression:

```text
$2500 + (destination - $1388)
```

Therefore the correct relocation addend is:

```text
BC = destination - $1388
```

The installer forms it with:

```asm
.installerPrepareAssemblerOnlyRelocation:
    ld hl,ENTRY_POINT_WITH_MONITOR-ENTRY_POINT_WITHOUT_MONITOR
    add hl,bc
    ld b,h
    ld c,l
```

The label difference is `-$1388`, represented modulo 65536 as `$EC78`.

DE remains the physical start of the copied suffix. Because the second stream's
gaps are measured from original boundary `$1388`, its first gap of one lands on
copied destination offset one—the operand of the assembler-only entry jump.

The same 722-target stream now works for both layouts:

```text
full:           start pointer = base+$1388, addend = base
assembler-only: start pointer = destination, addend = destination-$1388
```

This is the heart of the dual-layout design.

## The second assembler-only compatibility patch

The assembler code still contains the command handler:

```asm
invokeMonitor:
    ...
assemblerOnlyMonitorFallbackOpcode:
    defb 0c3h
assemblerOnlyMonitorFallbackAddress:
    defw startMonitor
```

In a full installation, the `JP startMonitor` target is relocated normally.

In an assembler-only installation, `startMonitor` was not copied. The command
must not jump into absent memory. After the second relocation stream, the
installer finds the named operand relative to the final stream target and writes
the assembler-only entry address into it:

```asm
    pop af
    pop bc
    jr c,.installerStartRelocatedProgram
    ld (hl),c
    inc hl
    ld (hl),b
```

BC has just been restored from the saved stack and again contains the selected
destination. The MONITOR command therefore jumps back to the assembler/editor
entry when no monitor exists.

This is the second deliberate suffix patch. The first, discussed in Chapter 53,
was applied before copying to `emitByteAtAssemblyOutput+1`.

## From the final relocation target to the resident stack

The decoder leaves DE at its last relocated word. In the historical origin-zero
layout that final target is `$2CDD`.

The installer then adds `$0104`:

```asm
.installerStartRelocatedProgram:
    ld hl,00104h
    add hl,de
    ld sp,hl
    push bc
    ret
```

So the stack is not simply `residentBase+$0104`. The arithmetic is:

```text
full layout:
    DE = residentBase + $2CDD
    SP = residentBase + $2DE1

assembler-only layout:
    DE = destination + ($2CDD-$1388)
    SP = destination + ($2DE1-$1388)
```

Both expressions identify the same logical `internalStackTop` inside their
respective copied layouts.

BC has been restored to the selected entry address. `PUSH BC` followed by `RET`
therefore transfers control to:

```text
full installation:           destination + full entry offset 0
assembler-only installation: destination + suffix entry offset 0
```

Each entry begins with its own relocated `JP startPrometheus`.

## How the generator produces the table

The modern build process is conceptually:

```text
assemble payload at six origins
compare every emitted byte and word
reject unsupported one-byte dependencies
apply explicit @noreloc/@reloc annotations
reject overlapping relocation words
split targets at ENTRY_POINT_WITHOUT_MONITOR
sort each group
convert targets to gaps
compress repeated gaps
emit relocationTable.asm
emit a readable relocation report
```

The generated file also publishes:

```asm
RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET
RELOCATION_SECOND_STREAM_FINAL_TARGET_OFFSET
```

The installer uses these symbolic values in its bridge and final-patch
arithmetic. If code moves, the generator updates both the stream and the
installer's references to its final positions.

For unchanged source, the generated bytes reproduce the historical table
exactly.

## What relocation does not promise

Relocation makes internal absolute addresses follow a moved resident image. It
does not automatically solve every possible modification.

A future edit can still fail if it:

- creates an isolated LOW/HIGH label byte;
- creates a gap larger than `$C7` between relocation targets;
- turns an `@noreloc` exception into a real pointer;
- stores an address through a runtime encoding unknown to the generator;
- lets the enlarged resident image collide with source, screen, ROM or U-TOP.

The current build checks the first three conditions explicitly. Memory-layout
policy remains a separate design responsibility.

## What changed in memory

During relocation:

- 571 words in the monitor prefix are adjusted for a full installation;
- 722 words in the assembler/editor suffix are adjusted in both layouts;
- the temporary relocation count bytes are overwritten and decremented;
- assembler-only mode rewrites the MONITOR fallback operand;
- DE advances to the final relocated target;
- SP moves from the temporary installer workspace to `internalStackTop`;
- control transfers through the relocated entry-point jump.

## Important labels encountered

- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `vr_l05353h`
- `vr_l05547h`
- `RELOCATION_FIRST_STREAM_FINAL_TARGET_OFFSET`
- `RELOCATION_SECOND_STREAM_FINAL_TARGET_OFFSET`
- `.installerRelocateCopiedImage`
- `.installerPrepareAssemblerOnlyRelocation`
- `.installerApplySecondRelocationTable`
- `installerApplyRelocationTable`
- `relocationExceptionMonitorEntryDescriptorWord`
- `assemblerOnlyMonitorFallbackAddress`
- `.installerStartRelocatedProgram`
- `internalStackTop`

## Back to the whole machine

The resident image is now internally consistent. Its absolute jumps, calls,
pointers, dispatch entries, self-modifying operands and table addresses all refer
to the chosen installation region.

PROMETHEUS has travelled through three coordinate systems:

```text
origin-zero linked offsets
physical tape-load addresses
final resident addresses
```

The generated table connects the first and third. The bootstrap and copy logic
connect the second and third.

What remains outside the resident source is the tape container that carries the
whole installation image to the Spectrum. The next chapter looks at that outer
layer: the BASIC loader, Spectrum header and data blocks, and the XOR checksums
that make a `.tap` file a valid cassette image.
