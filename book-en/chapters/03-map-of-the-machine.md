# Chapter 3: A Map of the Machine

PROMETHEUS moves many kinds of information through memory: source records, symbols, emitted code, screen images, stacks, installation tables and saved processor state. Before examining any one of those structures closely, we need a map.

The map is unusual because there is no single permanent arrangement. PROMETHEUS exists in at least three important forms:

1. the CODE block as it was loaded from tape;
2. the temporary installer working at `$5000`;
3. the resident program at the address selected by the user.

Inside the resident program, some boundaries are fixed relative to its base while others move as source and symbols grow.

## The Spectrum's broad 64K address space

The Z80 can address 65,536 byte positions, from `$0000` to `$FFFF`.

A simplified 48K Spectrum map is:

```text
$0000 ┌──────────────────────────────┐
      │ 16K Spectrum ROM             │
$3FFF └──────────────────────────────┘
$4000 ┌──────────────────────────────┐
      │ screen bitmap                │
$57FF ├──────────────────────────────┤
$5800 │ screen attributes            │
$5AFF ├──────────────────────────────┤
      │ system variables, channels,  │
      │ BASIC area and general RAM   │
$FFFF └──────────────────────────────┘
```

The display is not a separate graphics device with its own private memory. Bytes at `$4000` onward are ordinary RAM seen by the processor and continuously interpreted by the video hardware.

PROMETHEUS uses that screen RAM in two ways:

- normally, as the visible editor or monitor interface;
- during installation, partly as temporary working storage and stack space.

That reuse is safe only while the installer controls the machine and is prepared to redraw the screen later.

## The historical installation address

The historical default installation address is:

```asm
INSTALLATION_ADDRESS: equ 0x5dc0
```

A full resident payload is exactly 16,000 bytes, or `$3E80` bytes. Its internal layout is defined relative to zero:

```asm
    org 0

relocatablePayloadStart:
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Linking the payload at origin zero means an internal label is initially represented by its offset from the payload start. During installation, the relocation system adds the chosen resident base to every internal absolute word that needs it.

For any full installation base `B`, the main sections are:

```text
B+$0000 ┌─────────────────────────────────┐
        │ monitor prefix                  │ 5,000 bytes
B+$1387 └─────────────────────────────────┘
B+$1388 ┌─────────────────────────────────┐
        │ assembler/editor suffix         │
        │ tables and initial workspaces   │ 11,000 bytes
B+$3E7F └─────────────────────────────────┘
```

The exclusive end is `B+$3E80`.

At the historical base `$5DC0`, this becomes:

```text
$5DC0 ┌─────────────────────────────────┐
      │ monitor prefix                  │
$7147 └─────────────────────────────────┘
$7148 ┌─────────────────────────────────┐
      │ assembler/editor, tables,       │
      │ initial source and symbol tail  │
$9C3F └─────────────────────────────────┘
```

The value `$1388` is not an arbitrary magic number. It is exactly 5,000 in hexadecimal and equals:

```text
ENTRY_POINT_WITHOUT_MONITOR - ENTRY_POINT_WITH_MONITOR
```

The source enforces the relationship symbolically.

## Full and assembler-only residents

When the user chooses the full system, installation copies all 16,000 payload bytes.

The installer begins with:

```asm
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITH_MONITOR
```

When the monitor is omitted, it advances the source pointer to `ENTRY_POINT_WITHOUT_MONITOR` and changes the copy length:

```asm
    ld bc,ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITHOUT_MONITOR
```

The copied suffix is therefore 11,000 bytes.

Suppose the user selects destination `$8000`.

A full installation places the monitor entry at `$8000`, the assembler-only boundary at `$9388`, and the exclusive payload end at `$BE80`.

An assembler-only installation instead places `ENTRY_POINT_WITHOUT_MONITOR` itself at `$8000`. The copied suffix occupies `$8000` through `$AAF7`.

This distinction is important. The assembler/editor code was linked as though it originally began at offset `$1388`, but in assembler-only form it is physically installed at offset zero from the chosen destination. The installer compensates during relocation and applies two explicit assembler-only patches.

The source can therefore keep one shared assembler/editor body without maintaining a second separately linked copy.

## The program loaded from tape is not yet the resident program

The distributed CODE block contains more than the 16,000-byte resident payload. Before the payload come:

- an arbitrary-load bootstrap;
- the installer, logically assembled for `$5000`;
- generated configuration-patch data;
- generated relocation streams;
- installer display data.

The physical order in the file and the logical runtime addresses are not the same thing.

A useful conceptual picture is:

```text
CODE block loaded somewhere in RAM
┌────────────────────────────────────┐
│ relocation-safe bootstrap          │
├────────────────────────────────────┤
│ bytes of installer for $5000       │
├────────────────────────────────────┤
│ configuration + relocation streams │
├────────────────────────────────────┤
│ installer graphics/data            │
├────────────────────────────────────┤
│ zero-origin resident payload       │
└────────────────────────────────────┘
```

The bootstrap first discovers where this CODE block was actually loaded. It then copies the small installer to `$5000` and jumps there. The installer can now use its own absolute labels safely because it really is running at the address for which it was assembled.

Only after the user selects options does the installer copy and relocate the resident payload.

We will examine that sequence in detail near the end of the book. For now, keep the three forms separate:

```text
loaded image ≠ temporary installer ≠ final resident image
```

## The lower end of the resident image is mostly fixed

Inside the resident payload, routine and table offsets are fixed by assembly. For a chosen base `B`:

- `ENTRY_POINT_WITH_MONITOR` is at `B+$0000`;
- `startMonitor` is at `B+$01B4` in the historical layout;
- `ENTRY_POINT_WITHOUT_MONITOR` is at `B+$1388`;
- `startPrometheus` is at `B+$1F09`;
- `processKey` is at `B+$2879`;
- `relocatablePayloadEnd` is at `B+$3E80`.

These offsets help verification, but the book will prefer labels over numeric addresses. A future intentional change may move a routine while the label continues to express its meaning.

## The upper tail begins as code, tables and twenty empty lines

Near the end of the payload are the instruction table and initial editable storage.

The source buffer begins with twenty empty records:

```asm
sourceBufferStart:
    defb 0x00, 0x30
    defb 0x00, 0x30
    ; ...
sourceBufferAccessLine:
    defb 0x00, 0x30
    ; ...
```

Immediately after the initial source is the empty symbol table:

```asm
symbolTableDefaultPt:
    defw 0
codeEndDefaultPt:
    defs 6
```

The first word says that the symbol table initially contains zero entries. The following tail supplies initial protected state and the starting code-end region.

This is where the memory map stops being completely static.

## Source and symbols share a moving boundary

The compressed source grows upward in memory. The symbol table lives immediately above it. When a source record is inserted, the symbol area may have to move. When source is deleted, the gap can close again.

Conceptually:

```text
lower addresses
┌────────────────────────────┐
│ fixed resident routines    │
│ fixed tables               │
├────────────────────────────┤
│ compressed source records  │  grows and shrinks
├────────────────────────────┤
│ symbol table               │  moves with source changes
├────────────────────────────┤
│ protected end marker       │
└────────────────────────────┘
higher addresses
```

Several self-modified operands remember the current positions:

- the current symbol-table pointer;
- the current protected code end;
- active and visible source-record pointers;
- the current assembly output pointer.

This arrangement saves memory because unused space does not have to be permanently reserved for a maximum-size source or maximum-size symbol table. But it creates a strict rule: whenever bytes are inserted or removed below a pointer, every affected pointer must be adjusted.

Later editor chapters will show the routines that perform those repairs.

## Where does assembled code go?

Unless an `ORG` or `PUT` directive says otherwise, PROMETHEUS initializes both its logical address counter and physical output pointer to one byte above the current dynamic source/symbol region:

```asm
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
```

This means the default generated program begins immediately after PROMETHEUS's current working data.

There are two related but distinct ideas:

- the **logical address** used for labels and relative calculations;
- the **physical output pointer** where bytes are written.

Normally they advance together. `ORG` changes both. `PUT` can change the physical destination while leaving the logical address model different.

Our running example uses `ORG 32768`, so its output is deliberately placed at `$8000` rather than immediately after the source and symbol table.

## The screen is both display and addressable memory

PROMETHEUS writes directly into the Spectrum bitmap and attribute areas. It knows the unusual arrangement of Spectrum display lines and uses helpers to move by a character cell or text row.

Several fixed addresses are named near the beginning of the source:

```asm
VRAM_ADDRESS:                  equ 0x4000
ATTRIBUTES_ADDRESS:            equ 0x5800
ACCESS_LINE_ATTRIBUTE_ADDRESS: equ 0x59e0
BOTTOM_LINE_VRAM_ADDRESS:      equ 0x50e0
```

These names turn visible regions into memory destinations:

- the access line has an attribute row that can be highlighted;
- the bottom screen line can hold status or monitor input;
- the monitor front panel descriptors point to bitmap cells;
- the installer draws directly into screen memory.

The display chapter will explain why advancing one visible text row is not the same as adding 32 to a Spectrum bitmap address.

## Stacks appear in more than one place

PROMETHEUS cannot assume that the Spectrum's previous stack remains suitable.

During bootstrap and installation, part of display memory is used as a temporary stack. After copying the resident image, the installer creates a fresh stack inside the installed region at a known offset from the destination, pushes the resident entry and reaches it with `RET`.

The editor and monitor later restore their own internal stack top during warm entry. This prevents abandoned command frames from accumulating when a monitor operation or editor error returns through a nonstandard continuation.

This is another example of the program treating control flow as a resource to be reset, not merely followed.

## Protected memory is a moving concept

The monitor can examine almost all addressable memory, but it must not casually overwrite the resident program, source or symbols. The upper protected end is therefore not a compile-time constant. It follows the dynamic code-end pointer.

This also explains the behavior discussed earlier: when the disassembler reaches the monitor's own resident area, PROMETHEUS does not decode those bytes as ordinary instructions. A dynamic protected range causes them to be represented as one-byte `DEFB` records instead. The bytes remain visible, but the monitor avoids presenting its own writable instruction operands and tables as trustworthy executable code.

Protection is therefore based on the current map, not just on a fixed historical address interval.

## A combined map of a historical full installation

The following diagram is deliberately approximate inside the assembler/editor suffix. Later chapters will divide that region into precise functional neighborhoods.

```text
$0000-$3FFF   Spectrum ROM
$4000-$5AFF   screen bitmap and attributes
$5B00-$5DBF   Spectrum workspace / lower RAM context

$5DC0         ENTRY_POINT_WITH_MONITOR
              monitor front panel and commands
              disassembler and memory tools
              execution/trace machinery
$7147         end of 5,000-byte monitor prefix

$7148         ENTRY_POINT_WITHOUT_MONITOR
              command dispatcher and editor
              tape source transfer
              two-pass assembler
              expression and symbol machinery
              shared rendering and keyboard code
              strings, mnemonic/operand/instruction tables
              initial compressed source records
              initial symbol/code-end tail
$9C3F         final byte of historical payload
$9C40         first byte beyond relocatablePayloadEnd

higher RAM    available according to source growth,
              selected U-TOP and generated program placement
```

This map is not a promise that every later user program begins at `$9C40`. `ORG`, `PUT`, source growth, symbols and the configured upper limit all affect what is legal. It is the starting arrangement after historical installation.

## Back to the whole machine

We can now place the journey from Chapter 2 into memory:

```text
keys and edit buffer             screen + resident work buffers
        ↓
compressed source                dynamic tail of resident payload
        ↓
symbol table                     immediately above source
        ↓
first/second pass state          self-modified operands in resident code
        ↓
emitted program at $8000         user-selected output memory
        ↓
monitor disassembly              monitor buffers + screen
```

The same address space holds the tool, the text being edited, the program being built and the interface used to inspect it. Most of PROMETHEUS's cleverness follows from arranging those neighbors safely.

## What has changed in memory?

Immediately after a historical full installation, before the user enters source:

- `$5DC0-$9C3F` contains the 16,000-byte relocated resident payload;
- `$5DC0-$7147` is the monitor prefix;
- `$7148-$9C3F` is the assembler/editor suffix, tables and initial workspaces;
- the source tail contains twenty empty records;
- the symbol table count is zero;
- the code-end state protects the initial source/symbol tail;
- screen memory contains the newly drawn editor interface;
- higher RAM remains available subject to configuration and later source/code growth.

In an assembler-only installation, the 11,000-byte suffix begins directly at the selected destination and the monitor prefix does not occupy memory.

## Source anchors introduced

- `INSTALLATION_ADDRESS`
- `LOADER_ADDRESS`
- `relocatablePayloadStart`
- `relocatablePayloadEnd`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `installerPrepareAssemblerOnlyImage`
- `installerCopyImage`
- `installerCopyImageBackward`
- `sourceBufferStart`
- `sourceBufferAccessLine`
- `symbolTableDefaultPt`
- `codeEndDefaultPt`
- `varcCodeEndPt`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
