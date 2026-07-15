# Chapter 51: The Relocation-Safe Bootstrap

The bootstrap has a difficult job and almost no freedom.

It is the first code executed from the installation image, but it does not know
where that image was actually loaded. It cannot yet use an absolute address of
one of its own labels. It must establish temporary working memory, discover its
physical base, find the installer bytes that follow it in the CODE block, copy
them to `$5000`, and jump there.

It accomplishes all of this in only a few dozen bytes.

Here is the complete central fragment:

```asm
bootstrapEntry:
    di
    ld hl,VRAM_ADDRESS
    ld de,VRAM_ADDRESS+1
    ld bc,00fffh
    ld (hl),l
    ldir
    call ROM_ImmediateRET

bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
    ld hl,bootstrapEntry-bootstrapRecoverLoadAddress
    add hl,bc
    ld sp,VRAM_ADDRESS+0x20
    push hl
    ld hl,00017h
    add hl,bc
    ld bc,relocationSecondStreamTerminatorAndLogoStart+1-installerEntryAt5000
    ldir
    jp LOADER_ADDRESS
```

A line-by-line paraphrase would miss the elegance. Several registers finish one
job already positioned for the next. The display clear prepares both the stack
area and the installer destination. A CALL to a ROM routine that does nothing
creates a physical address. Even a return address that has already been popped is
recovered from the untouched bytes beneath SP.

We will unfold the sequence as a story.

## Constraint: own labels are not yet trustworthy

The bootstrap is assembled with:

```asm
org INSTALLATION_ADDRESS
```

where `INSTALLATION_ADDRESS` is historically `$5DC0`. But the CODE block may be
loaded elsewhere.

An instruction such as:

```asm
ld hl,someBootstrapLabel
```

would contain the address calculated for `$5DC0`, not the physical address at
which the bytes are currently executing. Therefore the bootstrap avoids absolute
references to its own runtime location.

It may safely use addresses that are genuinely fixed in the Spectrum:

- `$4000` display bitmap;
- ROM entry `$0052`;
- fixed temporary installer destination `$5000`.

It may also use **differences between labels**. If two labels move together, their
distance does not change.

This is the basis of the self-location calculation.

## Step 1: disable interrupts

The first instruction is:

```asm
    di
```

The bootstrap is about to replace SP, clear working memory, recover bytes beneath
the stack pointer, and perform a long copy. A maskable interrupt during these
operations would push a return address onto whichever temporary stack happened
to be active and would enter ROM interrupt code with half-prepared state.

Interrupts remain disabled through installation. The resident program later
establishes its own intended policy.

## Step 2: clear a 4K workspace

The code prepares a standard one-byte fill with `LDIR`:

```asm
    ld hl,VRAM_ADDRESS       ; $4000
    ld de,VRAM_ADDRESS+1     ; $4001
    ld bc,00fffh             ; 4095 following bytes
    ld (hl),l
    ldir
```

Because HL is `$4000`, its low byte L is zero. Therefore:

```asm
ld (hl),l
```

stores zero at `$4000` without needing `XOR A` or a separate literal load.

`LDIR` then copies that zero forward repeatedly:

```text
$4000 -> $4001
$4001 -> $4002
$4002 -> $4003
...
```

Since each newly written byte is zero, the operation fills:

```text
$4000 through $4FFF
```

with zeros.

This is the lower two thirds of the Spectrum bitmap, not the attribute file. On
screen it erases the relevant display area. Internally it creates clean temporary
RAM for:

- the private installer stack near `$4020`;
- logo and installer display work;
- the fixed installer destination beginning at `$5000`, which is exactly where
  DE finishes after the fill.

That final register position is an important economy.

## A free destination pointer

At the start of the fill:

```text
DE = $4001
BC = $0FFF
```

`LDIR` increments DE once for every copied byte. After 4,095 copies:

```text
DE = $5000
```

The next major operation needs to copy the installer to `$5000`. The bootstrap
does not execute another `LD DE,$5000`; the screen-clear loop has already
calculated the destination.

This is a characteristic PROMETHEUS trick: a register's final value is part of
the next algorithm, not disposable debris from the previous one.

## Step 3: ask a RET to reveal the physical PC

The Z80 has no ordinary instruction meaning “load the current program counter
into a register.” CALL provides an indirect way.

The bootstrap executes:

```asm
    call ROM_ImmediateRET
```

`ROM_ImmediateRET` is address `$0052`, containing a plain `RET` path suitable for
this purpose.

A CALL does two things:

1. pushes the address of the instruction after the CALL;
2. jumps to the target.

The ROM immediately executes RET, which pops that same address and returns.

Conceptually:

```text
CALL pushes physical address of bootstrapRecoverLoadAddress
ROM RET pops it and resumes there
```

The useful address has apparently vanished from the stack. But POP changes SP;
it does not erase the two bytes in RAM that held the word.

The bootstrap knows those bytes are still just below the restored SP.

## Step 4: reopen the consumed return word

Immediately after the ROM return:

```asm
bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
```

The two `DEC SP` instructions move the stack pointer back onto the old return
word. `POP BC` reads it again.

BC now contains the **physical** address of
`bootstrapRecoverLoadAddress`, because that is where the real CALL returned,
regardless of the load base.

This trick is subtle enough to restate:

```text
CALL manufactured a physical code address
RET consumed it logically
the bytes remained in RAM
DEC SP twice exposed them again
POP BC recovered them
```

No Spectrum system variable and no assumed load address was needed.

## Step 5: turn one physical label into the image base

The assembler can calculate the constant difference:

```asm
bootstrapEntry-bootstrapRecoverLoadAddress
```

This is a negative displacement because `bootstrapEntry` appears earlier. The
difference is independent of load position.

The bootstrap adds it to the physical address in BC:

```asm
    ld hl,bootstrapEntry-bootstrapRecoverLoadAddress
    add hl,bc
```

Therefore:

```text
HL = physicalAddress(bootstrapRecoverLoadAddress)
     + (bootstrapEntry - bootstrapRecoverLoadAddress)

HL = physicalAddress(bootstrapEntry)
```

HL now holds `physicalLoadBase`.

This is the first moment the program knows where the installation image truly
began.

## A numerical miniature

Suppose the CODE block was loaded at `$8000` rather than `$5DC0`.

Imagine `bootstrapRecoverLoadAddress` is 16 bytes after the start. The ROM trick
returns:

```text
BC = $8010
```

The assembled label difference is:

```text
bootstrapEntry-bootstrapRecoverLoadAddress = -16 = $FFF0
```

Adding:

```text
$8010 + $FFF0 = $8000    modulo 65536
```

The same code would recover `$5DC0`, `$6000`, `$A000` or any other usable load
base.

## Step 6: establish the private stack

The bootstrap now abandons the caller's stack:

```asm
    ld sp,VRAM_ADDRESS+0x20
```

This sets:

```text
SP = $4020
```

The cleared screen memory below it becomes a private stack. The bootstrap then
saves the newly discovered physical load base:

```asm
    push hl
```

The word is stored at `$401E-$401F`, and SP becomes `$401E`.

Why preserve it?

The installer will display the detected load address and later needs the
physical payload pointer. The stack is a cheap way to carry the value through the
initial logo-copy work without reserving a separate variable.

## Step 7: find the installer bytes physically

BC still contains the physical address of `bootstrapRecoverLoadAddress`, the
instruction immediately after the ROM CALL. The source's physical byte layout is
known at build time, so a small constant displacement can reach the first byte of
the installer segment:

```asm
    ld hl,00017h
    add hl,bc
```

The historical `$17` is the distance from that recovered post-CALL address to the
first physical byte copied as the installer.

This is not an absolute address. It is an offset inside the same loaded CODE
block, so it remains valid wherever the block lands.

After the addition:

```text
HL = physical source address of installer bytes
DE = $5000, inherited from the screen-clearing LDIR
```

Both source and destination are ready.

## Step 8: calculate copy length symbolically

The byte count is written as a label expression:

```asm
    ld bc,relocationSecondStreamTerminatorAndLogoStart+1-installerEntryAt5000
```

The labels belong to the installer's logical `$5000` view, but their difference
is simply a byte length. Differences do not depend on origin.

In the historical image this copy length is `$07CD`, 1,997 bytes.

The copied region includes:

- installer code and interactive text;
- configuration-patch decoder;
- relocation decoder and compact streams;
- the initial part of the logo tail needed by the installer's layout.

The exact boundary is chosen so that code executing at `$5000` has all absolute
internal material it needs there, while HL after the copy points at the remaining
physical logo/payload data.

## Step 9: copy to `$5000`

The second `LDIR` performs the relocation of the installer itself:

```asm
    ldir
```

This copy is safe because the destination is the fixed workspace beginning at `$5000` and
the source is the loaded installation image at its physical address.

Afterward:

```text
$5000...    contains installer assembled for $5000
HL          points after copied installer segment in physical image
DE          points after copied installer at $5000
SP          is private screen stack
[SP]        still holds physicalLoadBase
interrupts  disabled
```

Unlike the large resident payload copy, this bootstrap copy has one fixed
destination and a small known size.

## Step 10: jump, do not call

The final instruction is:

```asm
    jp LOADER_ADDRESS
```

where `LOADER_ADDRESS` is `$5000`.

A CALL would push a return address from the old physical bootstrap onto the
private stack. The installer never intends to return there, and such a word would
interfere with the deliberately saved load base. A JP cleanly transfers ownership
to the copied installer.

At this point absolute installer labels are trustworthy, because their bytes are
now exactly where they were assembled to run.

## The bootstrap in plain pseudocode

```pseudocode
interruptsOff()

fillMemory($4000, $5000, 0)
# side effect: destination pointer now equals $5000

physicalAfterCall = callKnownROMRetAndRecoverOldStackBytes()
physicalLoadBase = physicalAfterCall +
                   (bootstrapEntry - bootstrapRecoverLoadAddress)

SP = $4020
push(physicalLoadBase)

installerSource = physicalAfterCall + $17
installerDestination = $5000
installerLength = installerLogicalEnd - installerLogicalStart
copyForward(installerSource, installerDestination, installerLength)

jump($5000)
```

The only physically variable quantity is derived from the CALL return address.
Everything else is:

- a fixed Spectrum address;
- a fixed temporary destination;
- a difference between labels;
- an offset inside the loaded image.

That is what makes the bootstrap relocation-safe.

## The first instructions at `$5000`

The copied installer begins at `installerEntryAt5000`. At entry, HL still points
into the physical load image after the copied segment. The installer first draws
two logo rows, consuming the remaining logo bytes and advancing HL to the start
of the resident payload.

Then it executes:

```asm
    ex (sp),hl
```

Before the exchange:

```text
HL     = physical address of resident payload
[SP]   = physical load base
```

After the exchange:

```text
HL     = physical load base, used for decimal display
[SP]   = physical payload address, preserved until ENTER
```

The stack again acts as a tiny two-value communication structure between stages.
The installer can show where the CODE block was found while retaining the exact
source pointer needed for final copying.

Chapter 52 will continue from this exchange and examine the interactive screen
and its self-modified settings.

## Why not recover the address with Spectrum variables?

A loader could have stored the load address in a known variable or passed it in a
register. PROMETHEUS does not depend on such cooperation.

The CALL/RET trick makes the CODE block self-locating even when invoked through a
different BASIC loader or loaded manually at another address, provided execution
begins at its first byte.

This reduces assumptions at the cost of a clever stack sequence.

## Why use the screen as a stack?

The normal stack belongs to the calling environment and may be close to unknown
RAM contents. The installer needs a known safe stack while it moves large blocks
and changes addresses.

The display bitmap is:

- fixed at `$4000`;
- writable;
- immediately available;
- already being cleared for the installer screen;
- temporary until the resident application starts.

Using `$4020` is therefore economical. The visual side effect is simply part of
the installer's screen preparation.

## A compact register choreography

The bootstrap's efficiency becomes clearer in a register timeline:

```text
initial
    HL,DE,BC unspecified

prepare fill
    HL=$4000  source zero
    DE=$4001  destination
    BC=$0FFF  count

after fill
    HL=$4FFF
    DE=$5000  already installer destination
    BC=0

after ROM return recovery
    BC=physical bootstrapRecoverLoadAddress

after base calculation
    HL=physical bootstrapEntry

private stack
    SP=$4020
    push HL preserves physical load base

find installer source
    HL=BC+$17
    DE still $5000
    BC=installer byte count

after copy
    HL=physical byte after copied segment
    DE=$5000+installer length
```

No register is casually reloaded when its previous job can leave the required
next value behind.

## Failure assumptions

The bootstrap is compact partly because it assumes a valid environment.

It expects:

- writable RAM at `$4000-$57CC` for screen workspace and installer;
- the complete CODE block to be present contiguously;
- execution to begin at `bootstrapEntry`;
- the source and `$5000` destination not to overlap destructively during this
  small forward copy;
- ROM entry `$0052` to behave as the known immediate return;
- no maskable interrupt because DI has been issued.

It does not display errors or negotiate alternatives. The interactive installer
can report and accept choices later; the bootstrap must first create the stable
place from which that richer code can run.

## Back to the whole machine

The bootstrap solves an apparently circular problem:

```text
to use labels, code must know where it is
to discover where it is, code seems to need labels
```

It breaks the circle by using only:

- a physical return address produced by CALL;
- relative differences between labels;
- fixed Spectrum addresses;
- physical offsets inside the contiguous image.

The final result is a conventional absolute program at `$5000`.

We have crossed the first installation boundary:

```text
unknown physical location
        -> self-locating bootstrap
        -> known temporary installer address
```

The remaining boundaries are easier because the installer now has a stable
origin, a private stack, a pointer to the resident payload, and the actual load
base available for display.

## What has changed in memory

The bootstrap changes:

- `$4000-$4FFF`, cleared to zero;
- SP, moved to `$4020` and then lowered by the saved word;
- `$401E-$401F`, holding the physical load base before installer exchange;
- `$5000` onward, filled with the copied installer segment;
- HL, ending at the physical byte after that segment;
- DE, ending after the copied installer destination;
- interrupt state, forced to DI.

It does not yet copy or relocate the resident payload.

## Important labels encountered

- `INSTALLATION_ADDRESS`
- `VRAM_ADDRESS`
- `LOADER_ADDRESS`
- `ROM_ImmediateRET`
- `bootstrapEntry`
- `bootstrapRecoverLoadAddress`
- `bootstrapCopiedFragmentEnd`
- `installerEntryAt5000`
- `relocationSecondStreamTerminatorAndLogoStart`
- `installerDrawLogoRow`
- `installationAddressString`

## Ideas needed by later chapters

- CALL followed by a known RET can manufacture a physical code address.
- Popped stack bytes remain in memory and can be recovered by moving SP back.
- Label differences remain valid when the whole fragment moves.
- The screen clear leaves DE exactly at the installer destination `$5000`.
- The cleared bitmap supplies a private temporary stack.
- A stack exchange carries physical load base and payload source pointer between
  bootstrap and installer.
- Once copied to `$5000`, the installer may use ordinary absolute labels.
