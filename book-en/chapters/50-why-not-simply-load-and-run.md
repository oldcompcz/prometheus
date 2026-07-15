# Chapter 50: Why the Program Cannot Simply Be Loaded and Run

The source file begins with an installer, not with the editor or monitor. We have
postponed that installer until now because relocation makes sense only after we
know what is being relocated.

We now do.

The resident application contains:

- thousands of calls and jumps between routines;
- pointers to tables, strings, source buffers and saved registers;
- addresses embedded inside self-modifying instructions;
- monitor descriptors that point at data;
- assembler callbacks patched into operands;
- two possible resident layouts;
- initial source records and a symbol-table tail.

A normal load-and-run program could assume one fixed address. PROMETHEUS wants the
user to choose where this whole workshop will live. It can also omit the monitor
prefix and install only the assembler/editor.

Those choices turn loading into a small linking operation performed on the
Spectrum itself.

## Three addresses, not one

The installation process uses three different notions of address.

### 1. Physical tape-load address

This is where the complete distributed CODE block happens to arrive in RAM.
The historical header normally suggests `$5DC0`, but the manual allows the image
to be loaded at another usable address.

We will call it:

```text
physicalLoadBase
```

The first bootstrap instruction really executes there.

### 2. Temporary installer address

A compact installer is copied to the fixed address:

```text
$5000
```

It is assembled as though it lives at `$5000`, so after copying it can use
ordinary absolute labels internally. It draws the configuration screen and
performs the large move and relocation.

### 3. Final resident address

The user types a five-digit decimal installation address. The complete resident
program—or only its assembler suffix—is copied there.

We will call it:

```text
residentBase
```

After relocation, control finally transfers to this address.

These three values may all differ:

```text
physical CODE block     $8000
installer workspace     $5000
resident application    $A000
```

Confusing them would make the source almost impossible to understand.

## Loading is not installation

When the Spectrum ROM loads a CODE block, it knows only two basic things:

```text
destination address
number of bytes
```

It does not understand that part of the block is a bootstrap, part is an
installer assembled for another origin, and part is a payload whose internal
words need rebasing.

Therefore:

```text
LOAD places bytes
INSTALL interprets and transforms those bytes
```

The distributed CODE block is better imagined as a self-extracting development
environment than as the final resident binary.

## The resident payload is linked at zero

The monitor-plus-assembler payload begins at:

```asm
relocatablePayloadStart:
    org 0

ENTRY_POINT_WITH_MONITOR:
```

Linking at origin zero gives every internal absolute label a useful property:
its assembled word is an **offset within the payload**.

Suppose a call operand contains:

```text
$1234
```

and that word refers to a routine 4,660 bytes from the payload start. Installing
the payload at `$8000` requires:

```text
$1234 + $8000 = $9234
```

The installer can repair such words by adding one common base.

Relative branches do not need this treatment. A `JR` displacement depends on the
distance between two bytes inside the same moved block; that distance remains the
same. ROM calls and screen addresses also stay fixed because they point outside
the payload.

## Why not write position-independent resident code?

Modern systems often avoid relocation by calculating addresses relative to a
base register. The Z80 and the Spectrum environment make that unattractive here.

A resident PROMETHEUS routine wants to write:

```asm
call renderInputLineAtBitmapAddress
ld hl,mnemonicsTable
ld (varcAssemblyOutputPointer+1),hl
```

If every such operation had to recover a base and add an offset at runtime, the
program would become:

- larger;
- slower;
- more register-hungry;
- harder to combine with self-modifying operands;
- less like ordinary Z80 code.

PROMETHEUS pays relocation cost once during installation so the resident program
can remain compact and direct afterward.

## Two resident products inside one payload

The linked payload has a major boundary:

```text
ENTRY_POINT_WITH_MONITOR
        monitor prefix, historically 5,000 bytes
ENTRY_POINT_WITHOUT_MONITOR
        assembler/editor suffix, historically 11,000 bytes
relocatablePayloadEnd
```

The installer can create either product.

### Full installation

```text
residentBase + 0
    monitor prefix
    assembler/editor suffix
```

The entry point is `ENTRY_POINT_WITH_MONITOR` relocated to `residentBase`.

### Assembler-only installation

The first 5,000 bytes are omitted:

```text
residentBase + 0
    assembler/editor suffix only
```

The source bytes that were linked at payload offset 5,000 now begin at resident
offset zero. This is not equivalent to merely skipping a copy. Internal absolute
words in the suffix were originally offsets from the full payload start.

For assembler-only installation, their correction is conceptually:

```text
installedWord = linkedWord + residentBase - monitorPrefixLength
```

The installer also applies two intentional patches so monitor-related entry
assumptions become assembler-only behavior.

This second layout is why the relocation metadata is divided into two streams.

## The temporary installer needs a fixed home

The first bootstrap cannot safely use absolute references to its own labels,
because its physical load address is not yet known. Writing an entire interactive
installer under that restriction would be painful.

The solution is to keep the position-independent part tiny:

```text
discover physical load address
copy installer to known $5000
jump to $5000
```

At `$5000`, the installer can use normal absolute addresses for:

- its strings;
- setting operands;
- keyboard handlers;
- logo data;
- patch stream;
- relocation decoder.

The final resident image is not copied until the user presses ENTER.

## Why `$5000` can be used

During bootstrap, the lower part of the Spectrum display bitmap is cleared and
borrowed as workspace. The temporary stack begins at `$4020`. The installer
occupies memory beginning at `$5000`, below the usual default load base `$5DC0`.

This arrangement gives a compact controlled zone:

```text
$4000-$4FFF   cleared screen/workspace and temporary stack region
$5000...      copied installer
elsewhere     original loaded installation image
```

It is temporary. The final resident application may be installed somewhere else
and may later use the display normally.

## Copying may overlap

The loaded payload and final destination can be arranged in several ways:

```text
destination below source       forward copy is safe
destination above source       backward copy may be required
non-overlapping regions        either direction could work
```

If the destination begins inside the source block at a higher address, `LDIR`
would overwrite bytes that have not yet been copied. The installer detects this
case and uses a backward copy instead.

This is the same memory-movement problem discussed in Chapter 7, now applied to
the complete resident application.

The modern reconstruction tests both directions deliberately:

```text
load high -> install low
load low  -> install high with overlap
```

The original algorithm was already designed for this flexibility.

## Configuration bytes must move with the code

The setup screen lets the user choose values such as:

- installation address;
- monitor inclusion;
- text and highlight attributes;
- case conversion;
- keyboard-click duration and tone settings.

The resident program stores many of these settings in immediate operands or
small instructions rather than in one conventional structure. Their locations
therefore move when the payload layout changes.

The installer needs a compact list of destinations to patch. The historical
program stores that list as signed deltas. In the reconstruction, named
`@config-patch` labels generate the same compact stream automatically.

Configuration patching and relocation are related but distinct:

```text
configuration patch
    write a selected byte or word into a named resident setting

relocation
    add resident base to an internal absolute address word
```

A configuration value may be a colour or delay and have nothing to do with an
address.

## Absolute words are scattered through code and data

Relocation sites are not limited to obvious `JP` and `CALL` instructions. They
also occur in:

- `LD HL,address` and similar immediate operands;
- table pointers;
- front-panel descriptor addresses;
- saved callback targets;
- self-modifying variables initialized to labels;
- internal data words that name routines or buffers.

Trying to maintain the list manually after source changes is dangerous. A new
absolute pointer can be forgotten; an inserted byte changes later table deltas;
a word that looks like an address may actually be descriptor data.

The reconstruction therefore assembles the payload at several artificial origins
and compares the outputs. A genuine relocatable word changes by exactly the
origin difference. Chapter 55 will explain that process in detail.

## Some address-looking data must not move

One word in the monitor tables deliberately resembles an internal address but is
opcode-shaped descriptor data:

```asm
    defw ENTRY_POINT_WITH_MONITOR+2
```

Its numerical dependence on the origin does not mean the runtime installer
should relocate it. The source marks it `@noreloc`, and the generator verifies
the exception.

This illustrates an important rule:

> relocation follows meaning, not merely numerical appearance.

The multi-origin generator discovers candidates; source annotations resolve
exceptional semantics.

## The complete installation problem

The installer must perform this sequence:

```pseudocode
physicalLoadBase = discoverWhereCODEActuallyLanded()
copySmallInstallerTo($5000)

settings = interactWithUser()
residentBase = parseFiveDecimalDigits(settings.address)

if settings.monitorEnabled:
    source = fullPayloadStart
    length = fullPayloadLength
    relocationBias = residentBase
else:
    source = assemblerSuffixStart
    length = assemblerSuffixLength
    relocationBias = residentBase - monitorPrefixLength

copyOverlapSafely(source, residentBase, length)
patchResidentConfiguration(settings)
applyRelocationStreams(relocationBias)
applyAssemblerOnlySpecialPatchesIfNeeded()
setResidentStack()
jumpToResidentEntry()
```

Each line hides a chapter-sized mechanism, but the overall purpose is now plain.

## A map of the distributed image

The emitted CODE block is physically arranged approximately like this:

```text
+------------------------------------+
| tiny relocation-safe bootstrap     |
+------------------------------------+
| installer assembled for $5000      |
| generated patch/relocation data    |
| logo tail                          |
+------------------------------------+
| payload linked at origin 0         |
|   monitor prefix                   |
|   assembler/editor suffix          |
|   tables and initial workspaces    |
+------------------------------------+
```

The ORG values describe logical execution addresses, not necessarily the order
in which bytes occur in the tape block. The build emits the pieces contiguously,
and the bootstrap knows their physical offsets inside that block.

## A map after full installation

For a chosen base `$8000`:

```text
$8000              ENTRY_POINT_WITH_MONITOR
$8000-$9387        monitor prefix, 5,000 bytes
$9388              ENTRY_POINT_WITHOUT_MONITOR
$9388-...          assembler/editor suffix
...                 tables, empty source and symbol tail
```

Every listed absolute internal word has had `$8000` added.

## A map after assembler-only installation

For the same chosen base:

```text
$8000              ENTRY_POINT_WITHOUT_MONITOR copied here
$8000-...          assembler/editor suffix
```

Words in that suffix receive the effective correction:

```text
$8000 - $1388 = $6C78
```

because `$1388` is the historical 5,000-byte monitor prefix length.

The source expresses this symbolically rather than relying on the historical
number.

## Why the installer appears first in the source

The source's physical order follows startup and emitted-image needs:

```text
bootstrap must be first byte executed
installer bytes must follow at known physical displacement
payload follows as the material to copy
```

The book's learning order is the reverse. We first learned the resident program
so that phrases like “relocate an internal absolute word” now refer to familiar
things:

- a front-panel pointer;
- a symbol-table address;
- a saved callback;
- an assembler output pointer;
- a monitor capture routine.

The installer is not mysterious glue. It is a tiny program that prepares all the
machinery we already understand.

## Back to the whole machine

PROMETHEUS cannot simply be loaded and run because the loaded CODE block is not
the final resident arrangement.

It must reconcile:

```text
where the tape loader put the image
where the temporary installer expects to execute
where the user wants the application to live
which half or whole of the payload is wanted
which bytes are configuration
which words are internal addresses
which copy direction is safe
```

Once these questions are answered, the resident program becomes ordinary direct
Z80 code. Calls, pointers and self-modified operands contain real final addresses.
The relocation complexity disappears from normal editing, assembling and tracing.

The next chapter examines the tiny bootstrap that solves the first and most
awkward question: how can code discover its own physical load address before it
can trust any address referring to itself?

## What has changed in memory

This conceptual chapter introduces the transformations that installation will
perform:

- clear and borrow `$4000-$4FFF`;
- copy installer bytes to `$5000`;
- copy full payload or assembler suffix to a chosen resident base;
- patch selected configuration destinations;
- add an installation correction to relocation words;
- patch assembler-only entry differences;
- establish a resident stack and transfer control.

The detailed writes are covered in Chapters 51–55.

## Important labels encountered

- `INSTALLATION_ADDRESS`
- `LOADER_ADDRESS`
- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `emitByteAtAssemblyOutput`
- `assemblerOnlyMonitorFallbackAddress`
- `installerConfigurationPatchDeltas`
- `installerApplyRelocationTable`

## Ideas needed by later chapters

- Physical load address, temporary installer address and final resident address
  are separate values.
- The distributed CODE block is an installation image, not the final resident
  binary.
- The payload is linked at origin zero so internal words are offsets.
- Full and assembler-only products need different relocation biases.
- The installer executes at fixed `$5000` to escape position-independent coding.
- Payload copying must be overlap-safe.
- Configuration patching and address relocation are separate metadata streams.
- Relocation candidates can occur in both instructions and data.
