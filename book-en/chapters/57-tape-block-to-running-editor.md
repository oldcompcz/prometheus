# Chapter 57: From Tape Block to Running Editor

We now know every major mechanism in the installation path. This chapter puts
them back together.

The point is not to introduce another table or another Z80 trick. It is to watch
the complete chain operate as one program:

```text
cassette blocks
BASIC loader
physical CODE image
bootstrap
installer
configuration
copy
relocation
resident entry
editor warm start
keyboard wait
```

At the beginning, PROMETHEUS is merely bytes following a CODE header. At the
end, it is a live development system with source, symbols, screen state, private
stack and command loop.

## Stage 1: the ROM finds the BASIC program

The user begins with the ordinary Spectrum command:

```basic
LOAD ""
```

The ROM reads the BASIC header named `PROMETHEUS`, learns that the program is 54
bytes long and sees the autostart line number 9999. It then reads the following
BASIC data block and starts that line.

The program in memory is:

```basic
1 RANDOMIZE USR 24e3: STOP
9999 CLEAR 23999: LOAD "prometheus" CODE : RUN
```

The apparently backward line order is the first small piece of choreography.
Autostart begins at the loader line; `RUN` later returns to the machine-code call
on line 1.

## Stage 2: BASIC makes room and loads the CODE image

Line 9999 executes:

```basic
CLEAR 23999
```

BASIC now promises not to use memory at 24,000 or above for its normal program
workspace.

Next:

```basic
LOAD "prometheus" CODE
```

The ROM scans until it finds the CODE header:

```text
name          "prometheus"
length        18,356
load address  24,000 = $5DC0
```

It copies the following data block to `$5DC0`.

At this moment memory contains a **distributed installation image**, not a ready
resident editor:

```text
$5DC0                         bootstrapEntry
...                           installer and metadata bytes
$66F4                         origin-zero resident payload, physically loaded
$66F4 + $1388 = $7A7C         physical assembler-only boundary
$66F4 + $3E80                 physical end of resident payload
```

The addresses `$66F4` and `$7A7C` describe the historical physical load layout.
They are not yet the final linked addresses that the resident code will use.

## Stage 3: BASIC calls the bootstrap

The loader's `RUN` restarts at line 1:

```basic
RANDOMIZE USR 24e3
```

PC becomes `$5DC0`, the nominal physical CODE address.

The first machine instruction is at:

```asm
bootstrapEntry:
    di
```

Interrupts remain disabled throughout the vulnerable movement and patching
sequence.

The bootstrap clears `$4000-$4FFF`, leaving:

- blank bitmap workspace;
- a safe temporary stack area;
- DE naturally positioned at `$5000` after `LDIR`.

It calls the ROM's immediate `RET`, exposes the consumed return address again,
and calculates its actual physical load base. In the historical tape this is
`$5DC0`, but the arithmetic does not rely on that fixed value.

It then:

```text
saves physical load base on stack at $4020
finds the installer bytes by relative displacement
copies the fixed installer segment to $5000
jumps to $5000
```

The BASIC layer has now finished its job. Even if the CODE block had been placed
somewhere else by a different loader, the bootstrap would have discovered that
location.

## Stage 4: the installer discovers the resident payload

At `installerEntryAt5000`, HL points into the remaining physical CODE image.
Drawing the two logo rows consumes exactly the remaining logo bytes. HL then
lands at the physical start of the 16,000-byte resident payload.

The installer exchanges this pointer with the physical load base saved on the
temporary stack:

```text
HL       = physical load base for decimal display
(SP)     = physical resident-payload source for ENTER
```

The default address field becomes:

```text
24000
```

because the historical CODE image was loaded at 24,000.

The user sees the installer and may change:

- final installation address;
- monitor inclusion;
- case rendering;
- bold rendering;
- click duration;
- normal and highlight colours;
- border-related colours.

Every accepted key returns through the synthetic redraw address, so the complete
screen always reflects the current self-modified settings.

## Stage 5: ENTER turns visible choices into payload bytes

When the user presses ENTER, the installer parses the five decimal address
characters by repeated multiplication by ten:

```text
value = value*10 + nextDigit
```

It then restores the physical payload source from the temporary stack.

Before copying, the fourteen generated configuration deltas are walked. The
installer writes the selected opcodes, delay byte and attributes into the
physical origin-zero payload.

This ordering matters:

```text
patch source once
copy selected layout afterwards
```

The same configuration sequence serves both full and assembler-only products.
Monitor-only destinations may be patched even when they will soon be omitted;
that is cheaper than branching around them.

## Stage 6A: the ordinary full installation

The default monitor setting is enabled. If the user simply presses ENTER, the
chosen layout is:

```text
source      physical resident payload at $66F4
length      16,000 bytes
entry       full payload offset $0000
```

The historical default destination is `$5DC0`.

Because destination lies below source, forward `LDIR` is safe:

```text
copy $66F4-$A573 down to $5DC0-$9C3F
```

The exact final end depends on inclusive/exclusive notation; the copied length
is `$3E80` bytes.

After the move, the bytes at `$5DC0` begin with:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

but the JP operand still contains the origin-zero offset `$1F09`. Relocation must
repair it before execution.

## Stage 6B: the assembler-only alternative

If the user toggles `Monitor:No`, the installer first applies the pre-copy suffix
compatibility adjustment. It then chooses:

```text
source      physical payload + $1388
length      11,000 bytes
entry       original ENTRY_POINT_WITHOUT_MONITOR
```

That original suffix is copied to destination offset zero.

At historical destination `$5DC0`, the copied first bytes are the original:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

The monitor's 5,000 bytes are absent. All assembler/editor bytes retain their
relative order.

## Stage 7: the copied words learn their real addresses

The installer restores the destination and layout flag from its stack.

### Full path

For a full installation:

```text
DE = resident base
BC = resident base
```

It applies the 571-target monitor stream, bridges from final monitor target
`$11C0` to assembler boundary `$1388`, then applies the 722-target suffix
stream.

The opening entry word changes from:

```text
$1F09
```

to:

```text
$1F09 + $5DC0 = $7CC9
```

So the first instruction at `$5DC0` becomes:

```asm
jp $7CC9
```

`$7CC9` is the historical full-layout address of `startPrometheus`.

### Assembler-only path

For assembler-only installation, the monitor stream is skipped. The addend is:

```text
$5DC0 - $1388 = $4A38
```

The linked `startPrometheus` word `$1F09` becomes:

```text
$1F09 + $4A38 = $6941
```

That is exactly:

```text
assembler destination $5DC0
+ relative suffix offset ($1F09-$1388)
```

The MONITOR command's fallback word is then changed to `$5DC0`, so selecting
MONITOR cannot jump into the missing prefix.

## Stage 8: the temporary installer gives control away

After the second stream, DE points at the final relocated word. Adding `$0104`
selects the resident `internalStackTop` for the chosen layout.

The installer restores BC to the selected entry address and executes:

```asm
    ld sp,hl
    push bc
    ret
```

The RET does not go back to BASIC. It pops the just-pushed resident entry address
into PC.

The temporary installer at `$5000` has finished. Its screen workspace, temporary
stack and destructively consumed relocation table are no longer part of the
running program.

## Stage 9: both layouts converge on `startPrometheus`

The full entry is:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

The assembler-only entry is:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Their JP operands have been relocated differently, but both reach the same
logical routine in the bytes that were actually copied.

For the historical destination:

```text
full startPrometheus address           $7CC9
assembler-only startPrometheus address $6941
```

The difference is exactly the omitted `$1388` monitor prefix.

From this point onward, the assembler/editor code does not need to know which
layout produced it, except for the patched MONITOR fallback.

## Stage 10: resident startup takes ownership

The common entry begins:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
```

Interrupts remain disabled. The resident renderer clears the display using its
own configured character and attribute machinery.

Then execution falls into:

```asm
prometheusWarmStart:
```

The warm-start path:

1. fills the access-line attributes with the configured highlight colour;
2. selects the copyright/status message;
3. clears shared line, input, operand and formatting buffers;
4. restores the input buffer's movable `$01` cursor marker;
5. restores its `$80` guard byte;
6. sets SP to `internalStackTop` again;
7. renders the twenty visible source records.

The source area already contains twenty empty compressed records and an empty
symbol table, so the very first listing is structurally valid without any
special “no program yet” case.

## Stage 11: the first editor frame appears

The visible editor state is assembled from mechanisms described much earlier in
the book:

```text
compressed empty source records
    -> record traversal
    -> record expansion
    -> Spectrum bitmap character rendering

configured attributes
    -> normal rows, highlighted access line, status bar

input buffer
    -> guard, cursor marker, empty editable line
```

The installation chapters did not create a separate startup user interface.
They delivered control into the same ordinary editor warm-start machinery used
after many commands and monitor exits.

This reuse is why the transition feels immediate: the installer disappears and
the normal editor simply paints its current state.

## Stage 12: PROMETHEUS waits in `processKey`

The main editor loop repaints the edit line, restores the border and calls:

```asm
processKey:
```

The keyboard routine enters its ROM scanning and repeat logic. At this point the
installation is complete.

The full historical path has reached approximately:

```text
entry point  $5DC0
start        $7CC9
processKey   $8639
```

The assembler-only historical path reaches:

```text
entry point  $5DC0
start        $6941
processKey   $72B1
```

The physical CODE image may still remain elsewhere in memory, depending on the
chosen destination and overlap, but the live program no longer depends on its
installation copy.

The user can now:

- enter source;
- assemble it;
- save and load it;
- inspect memory;
- use the monitor when installed;
- execute or trace generated code.

The entire development workshop is alive.

## The complete journey in pseudocode

```text
ROM loads BASIC program
BASIC autostarts at line 9999

CLEAR 23999
LOAD "prometheus" CODE at header address $5DC0
RUN
RANDOMIZE USR $5DC0

bootstrap:
    disable interrupts
    clear temporary screen workspace
    discover actual physical CODE address
    copy installer to $5000
    jump $5000

installer:
    draw logo and options
    let user choose destination/settings/layout
    apply 14 configuration patches to physical payload

    if full:
        source = payloadStart
        length = 16000
    else:
        patch suffix compatibility word
        source = payloadStart + $1388
        length = 11000

    memmove(source, destination, length)

    if full:
        relocate monitor stream using addend destination
        relocate suffix stream using addend destination
    else:
        relocate suffix stream using addend destination-$1388
        patch MONITOR fallback to destination

    set SP to resident internalStackTop
    jump to selected resident entry

resident entry:
    JP relocated startPrometheus

startPrometheus:
    clear display
    initialize warm editor state
    render source window
    wait for first key
```

## The same machinery works away from historical addresses

The reconstructed execution harness has run both layouts under several physical
load/destination combinations:

```text
load $5DC0 -> destination $5DC0
load $5DC0 -> destination $8000
load $8000 -> destination $6000
load $8000 -> destination $A000
```

These cover:

- historical placement;
- forward copies;
- destination-above-source backward copies;
- physical loading at a nonhistorical address;
- full and assembler-only relocation.

Every scenario reaches the relocated entry, `startPrometheus`, initial screen
rendering and the resident `processKey` loop.

A separate changed-layout test inserts bytes in both the monitor prefix and the
assembler section. It regenerates both metadata tables, builds a longer TAP and
again executes both installation modes. This demonstrates that the successful
journey no longer depends on preserving every historical source address.

## Three programs hand control to one another

The complete startup can be understood as a succession of ownership:

### BASIC owns the machine

It reserves memory, loads the CODE block and calls `$5DC0`.

### The temporary installer owns the machine

It disables interrupts, uses screen RAM as workspace, chooses the resident
layout, patches, copies and relocates it.

### The resident PROMETHEUS owns the machine

It establishes its permanent stack and dynamic memory structures, paints the
editor and waits for commands.

None of the three needs to know every detail of the next. They agree on narrow
contracts:

```text
BASIC -> physical CODE entry
bootstrap -> installer at $5000 with saved physical pointers
installer -> relocated resident entry with valid stack
resident entry -> normal editor warm start
```

This is a compact form of staged loading long before modern executable loaders
and operating-system process images were commonplace on home computers.

## What changed in memory

Across the complete journey:

- BASIC moves its boundary below 24,000;
- the ROM places 18,356 CODE bytes at the physical load address;
- `$4000-$4FFF` becomes temporary bootstrap/installer workspace;
- the installer is copied to `$5000`;
- fourteen physical payload fields receive chosen configuration values;
- 16,000 or 11,000 resident bytes are copied to the selected destination;
- 1,293 or 722 internal words are rebased;
- assembler-only compatibility words are patched when needed;
- SP moves to the resident `internalStackTop`;
- source, symbol and editor buffers begin in their initial resident state;
- the screen becomes the ordinary PROMETHEUS editor.

## Important labels and layers encountered

- BASIC line 9999
- BASIC line 1
- CODE load address `$5DC0`
- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `.installerRelocateCopiedImage`
- `installerApplyRelocationTable`
- `.installerStartRelocatedProgram`
- `startPrometheus`
- `prometheusWarmStart`
- `internalStackTop`
- `processKey`

## Back to the whole machine

Part VII began with a question: why can PROMETHEUS not simply be loaded and run?

The answer is now complete. The tape carries a distributed installation image,
not a fixed resident executable. BASIC loads it, a position-independent
bootstrap locates it, an installer creates one of two resident layouts, generated
metadata finds configuration and address-sensitive fields, and a compact decoder
rebases the selected image.

Only then does the editor begin.

The remaining main chapters no longer need to discover another major subsystem.
They can step back and examine the whole design: how editor, assembler, monitor,
execution engine and installer repeatedly reuse the same compact representations,
and how a future programmer can navigate and modify the complete source without
losing those connections.
