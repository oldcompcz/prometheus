# Appendix B: ZX Spectrum ROM Services and System Variables

PROMETHEUS is mostly self-contained, but it is not a bare-metal program in the
modern sense. It calls selected routines in the 48K Spectrum ROM, reads one ROM
data table, uses one system variable to return to BASIC, writes the display
memory directly, and communicates with the ULA through port `$FE`.

This appendix documents the contract PROMETHEUS actually relies on. It does not
try to reproduce the complete Spectrum ROM disassembly. ROM routines often
clobber more registers or system variables than the narrow call site cares
about; where the exact broad ROM contract is not needed, the entry below states
the conservative PROMETHEUS contract.

All addresses are for the standard 48K Spectrum ROM assumed by the historical
program.

## B.1 Summary table

| Source name | Address | Kind | PROMETHEUS use |
|---|---:|---|---|
| `ROM_PrintACharacter` | `$0010` | restart service | emit ENTER to the currently open printer/channel stream |
| `ROM_MaskableInterrupt` | `$0038` | interrupt entry | not deliberately called; `$FF` bytes appear as descriptor data |
| `ROM_ImmediateRET` | `$0052` | one-byte ROM `RET` | recover the physical load address in the bootstrap |
| `ROM_Key_Tables` | `$0205` | ROM data table | translate keyboard indexes to ordinary characters |
| `ROM_KeyboardScanning` | `$028E` | keyboard scanner | obtain key index and modifier class |
| `ROM_KeyboardTest` | `$031E` | key translator/test | installer translation of a stable scan into a usable code |
| `ROM_SaveControl_4c6` | `$04C6` | tape SAVE control | write headers and data blocks |
| `ROM_SA_SET` | `$051A` | tape SAVE continuation setup | write the chained auxiliary source/symbol segment |
| `ROM_LoadBytes_562` | `$0562` | tape LOAD/VERIFY | monitor block load and editor source LOAD/VERIFY |
| `ROM_LD_MARKER` | `$05C8` | tape chained-marker load | verify/load the auxiliary segment written by SAVE |
| `ROM_NEWCommandRoutine` | `$11B7` | BASIC command path | N/O command slots enter ROM NEW behavior |
| `ROM_ChannelOpen` | `$1601` | channel selection | open channel 3 before PRINT output |
| `ROM_StatementReturn` | `$1B76` | BASIC statement return | leave PROMETHEUS and resume BASIC safely |
| `ROM_BreakKey` | `$1F54` | BREAK test | stop slow and fast tracing |
| `ROM_PixelAddress_22b0` | `$22B0` | display address helper | convert pixel/text coordinates to bitmap address |
| `SYSVAR_ERR_SP` | `$5C3D` | system variable | restore BASIC error-stack pointer before returning |
| port `$FE` | I/O port | ULA | keyboard matrix, border, speaker/MIC and tape-state side effects |
| `$4000-$57FF` | RAM | screen bitmap | editor, monitor, installer graphics and temporary installer workspace |
| `$5800-$5AFF` | RAM | attributes | interface colours and highlighting |

## B.2 `RST $10` — print one character

### Address

```text
$0010
```

### Source name

```asm
ROM_PrintACharacter: equ 0x10
```

### Purpose in the ROM

The restart enters the ROM character-output machinery. Character interpretation
depends on the currently selected channel and on ROM output state. Control codes
can have effects beyond drawing a glyph.

### PROMETHEUS entry contract

```text
A = character code
current ROM channel already selected
interrupt environment suitable for ROM output
```

PROMETHEUS uses it only after opening channel 3 and after sending a complete
expanded source line through its own callback renderer. It places `$0D` in A and
executes:

```asm
    rst ROM_PrintACharacter
```

The purpose is to terminate the printed line with ENTER.

### Result and side effects

PROMETHEUS does not depend on preserved general registers or flags. Treat the
ROM output path as broadly destructive unless the immediate caller saves what it
needs. It can update ROM channel and cursor-related state.

### Where used

`outputLineBufferToChannel3`, reached by the editor `PRINT` command.

### Important distinction

PROMETHEUS normally renders text itself into Spectrum bitmap memory. `RST $10`
is not its general screen character routine. It is used for ROM channel output.

## B.3 `$0038` — maskable interrupt entry, and the false-call trap

### Address

```text
$0038
```

### Source name

```asm
ROM_MaskableInterrupt: equ 0x38
```

### Normal machine meaning

In interrupt mode 1, a maskable interrupt vectors to `$0038`. The byte encoding
`RST $38` is `$FF`.

### PROMETHEUS use

Three `RST ROM_MaskableInterrupt` source statements occur in the front-panel
format-toggle table. They are not intended to execute as interrupt calls. The
source uses the assembler mnemonic to emit capability byte `$FF` compactly and
preserve historical bytes.

They mean:

```text
all format-toggle capability bits enabled
```

not:

```text
call the Spectrum interrupt handler
```

### Reading rule

This is the clearest example of opcode-shaped data. Static disassembly alone is
insufficient to establish an execution path.

## B.4 `$0052` — a ROM `RET` used as a location probe

### Address

```text
$0052
```

### Source name

```asm
ROM_ImmediateRET: equ 0x0052
```

### ROM behavior relied on

The byte at this entry executes a plain `RET` immediately.

### PROMETHEUS entry contract

No register inputs are important. The call must be made with writable stack RAM.
Interrupts are already disabled by the bootstrap.

### Result

A normal `CALL $0052` pushes the address following the call. The ROM `RET`
returns to that address. PROMETHEUS then decrements SP twice and pops the still
present word into BC.

The recovered word is combined with a compile-time displacement to find the
physical address of `bootstrapEntry`.

### Side effects and assumptions

- the memory beneath the returned SP still contains the consumed return word;
- no interrupt or nested stack activity occurs between the ROM return and the
  two `DEC SP` instructions;
- the stack is in writable RAM;
- the ROM byte is indeed a simple `RET` in the expected ROM version.

### Where used

Only in `bootstrapEntry` / `bootstrapRecoverLoadAddress`.

## B.5 `$0205` — ROM keyboard translation tables

### Address

```text
$0205
```

### Source name

```asm
ROM_Key_Tables: equ 0x0205
```

### Kind

This is data, not a callable routine.

### PROMETHEUS use

`processKey` obtains a key index in E from the ROM scanner, forms a zero-extended
index in BC and uses:

```asm
    ld hl,ROM_Key_Tables-1
    add hl,bc
    ld a,(hl)
```

The `-1` compensates for the scanner's one-based convention used by this path.
PROMETHEUS then applies its own CAPS SHIFT, SYMBOL SHIFT, command-token, CAPS
LOCK and lowercase rules.

### Assumptions

- the 48K ROM table ordering matches the scanner's E values;
- PROMETHEUS's custom modifier logic is layered on top of the ROM's ordinary
  character table rather than replacing matrix scanning entirely.

## B.6 `$028E` — keyboard scanning

### Address

```text
$028E
```

### Source name

```asm
ROM_KeyboardScanning: equ 0x028e
```

### PROMETHEUS-observed result contract

The source and surrounding tests rely on:

```text
E = raw key-table index or $FF-like no-key state
D = modifier/shift class
Z state distinguishes the ROM scanner's accepted/stable result from retry state
```

The installer loops until the scanner reports the state expected by its
translation path. The resident editor wrapper `getKeypressCodeOrZero` rejects:

- no key;
- SYMBOL SHIFT alone;
- CAPS SHIFT alone.

### Inputs

No explicit register input is prepared by PROMETHEUS. The routine reads the ULA
keyboard matrix itself.

### Side effects

Treat AF, DE and ROM keyboard scratch state as modified. The resident wrapper
preserves HL because its caller may be using it as a source or display pointer.

### Where used

- installer key loop;
- `getKeypressCodeOrZero`, the low-level resident keyboard wrapper.

### Why PROMETHEUS also reads port `$FE` directly

The ROM scanner is used for normalized key identity. Direct ULA reads are used
for simpler questions where translation would be wasteful:

- is any key still held while a list scrolls?
- has SPACE been pressed to abort?
- is a specific row still active for autorepeat?
- have all keys been released after BREAK?

## B.7 `$031E` — keyboard test/translation

### Address

```text
$031E
```

### Source name

```asm
ROM_KeyboardTest: equ 0x031e
```

### PROMETHEUS entry contract

The installer calls this immediately after a successful/stable
`ROM_KeyboardScanning` result. It relies on the scanner's register state.

### PROMETHEUS-observed result contract

```text
A = translated character code
carry set = usable translated key
B contains shift information used by the installer
```

The installer increments B and treats zero as the unshifted case. Shifted codes
are represented internally by adding `$80` to A.

### Side effects

AF and B are consumed by the installer's normalization. Other ROM side effects
are not relied on.

### Where used

Only in the temporary installer. The resident keyboard path uses the ROM tables
more directly and supplies its own command/modifier mapping.

## B.8 `$04C6` — tape SAVE control

### Address

```text
$04C6
```

### Source name

```asm
ROM_SaveControl_4c6: equ 0x04c6
```

### Purpose

Enter the Spectrum ROM tape writer for a header or data block.

### Common PROMETHEUS inputs

The exact ROM entry convention is compact and partly mediated by preceding ROM
code, but the call sites establish these practical inputs:

```text
IX = start address of bytes to save
DE = byte length
A  = block flag/type state selected by caller
carry and related tape state prepared for SAVE
interrupt/tape timing environment owned by ROM
```

For a standard header, PROMETHEUS supplies a 17-byte header at IX, DE=`17`, and
A=`0`. For the following data block it supplies flag `$FF` and the requested
memory range.

The monitor's headerless raw save tail-jumps to this ROM entry after preparing a
leader/flag and range.

### Returned values

PROMETHEUS does not use a rich return structure. The ROM routine either completes
or follows ROM error/cancellation behavior. Editor SAVE then continues with the
next block or returns through PROMETHEUS's operation path.

### Side effects and assumptions

- ROM tape code controls timing and port `$FE`;
- register preservation should not be assumed;
- the user has started the recorder after the PROMETHEUS prompt;
- stack and interrupt state must be compatible with ROM code.

### Where used

- `waitForKeyAndWriteTapeHeader`;
- editor source/symbol SAVE data block;
- monitor arbitrary block SAVE.

## B.9 `$051A` — `SA_SET`, chained save setup

### Address

```text
$051A
```

### Source name

```asm
ROM_SA_SET: equ 0x051a
```

### PROMETHEUS purpose

After saving the main source segment, PROMETHEUS writes an auxiliary segment
containing the symbol-table side of the saved representation. It prepares IX,
DE, marker state, B and carry, then calls `ROM_SA_SET` to enter the ROM's chained
writer setup.

### Inputs visible at the call site

```text
IX = auxiliary segment start (adjusted as required by ROM convention)
DE = auxiliary length
AF/AF' = marker and flag state
B = ROM timing/state constant `$37`
carry set
```

The surrounding byte manipulations are historical ROM-protocol setup. They
should be treated as one contract rather than independently simplified.

### Result and side effects

Control returns to PROMETHEUS's SPACE-abort check after the ROM operation. No
ordinary register preservation is assumed.

### Where used

Editor SAVE only.

## B.10 `$0562` — LOAD or VERIFY bytes

### Address

```text
$0562
```

### Source name

```asm
ROM_LoadBytes_562: equ 0x0562
```

### Purpose

Read a tape block into memory or compare it with memory.

### PROMETHEUS wrapper contract

`callRomTapeLoadOrVerify` accepts:

```text
IX = destination or comparison address
DE = length
A  = expected block flag
carry set   = LOAD
carry clear = VERIFY
```

It moves the expected flag and carry state into `AF'`, disables interrupts,
writes `$0F` to port `$FE`, and calls the ROM.

### Result

```text
carry set   = ROM reports successful block operation
carry clear = failure/mismatch/wrong block according to ROM path
```

PROMETHEUS preserves that carry while checking whether SPACE is held. SPACE
causes an immediate jump to the current abort continuation.

### Special Y-command use

The monitor Y command calls `$0562` directly with:

```text
IX = inputBufferStart
DE = 18
expected flag = $00 in AF'
LOAD mode
```

The extra byte allows the physical tape flag/leader to remain at buffer offset
zero. A successful standard header fills the remaining 17 bytes. On failure,
the first byte can still be displayed as a raw leader.

### Side effects and assumptions

- interrupts are disabled before entry;
- ROM tape timing owns port `$FE`;
- AF' contains ROM-private flag/mode state;
- IX and DE have exact byte-range meaning;
- stack is valid throughout a potentially long ROM operation.

### Where used

- editor LOAD and VERIFY;
- monitor J block LOAD;
- monitor Y header/leader inspection;
- imported code/tape paths that reuse the common wrapper.

## B.11 `$05C8` — chained-marker LOAD/VERIFY

### Address

```text
$05C8
```

### Source name

```asm
ROM_LD_MARKER: equ 0x05c8
```

### PROMETHEUS purpose

This is the reading counterpart to the auxiliary chained SAVE setup. VERIFY and
LOAD use it for the second saved segment after the main source data.

### Inputs visible in PROMETHEUS

```text
IX = auxiliary destination/comparison start
DE = auxiliary length minus protocol adjustment
B = marker-state constant `$B0`
AF/AF' = expected flag and LOAD/VERIFY state
```

### Result

Carry is normalized through the common tape success/error path. SPACE can abort
afterward through the shared polling helper.

### Where used

`invokeVerify` and the corresponding source LOAD path.

## B.12 `$11B7` — ROM NEW command path

### Address

```text
$11B7
```

### Source name

```asm
ROM_NEWCommandRoutine: equ 0x11b7
```

### PROMETHEUS use

The N and O command-token entries in `commandHandlerTable` point directly to this
ROM routine. The duplicate slots are preserved historical aliases.

### Meaning

This is not PROMETHEUS's own “clear source” command. It enters the Spectrum ROM
NEW path, with the broad consequences of BASIC's NEW behavior and ROM error
handling.

### Inputs, return and assumptions

PROMETHEUS provides no narrow subroutine-style contract and does not expect a
normal return into the editor handler table. This is a transfer into ROM command
logic. Exact behavior depends on the ROM environment and system variables.

### Where used

`commandHandlerTable` entries `$CE` and `$CF`.

## B.13 `$1601` — open a ROM channel

### Address

```text
$1601
```

### Source name

```asm
ROM_ChannelOpen: equ 0x1601
```

### PROMETHEUS entry contract

```text
A = channel number
```

PROMETHEUS supplies A=`3` before printing source through the ROM output system.
Channel 3 is the printer channel in the standard Spectrum arrangement.

### Result and side effects

The ROM updates current-channel system state. PROMETHEUS then enables interrupts,
renders the expanded line through its output callback, and uses `RST $10` for
ENTER. General registers and flags should not be assumed preserved beyond what
the local caller explicitly reconstructs.

### Where used

`outputLineBufferToChannel3`.

## B.14 `$1B76` — return from a BASIC statement

### Address

```text
$1B76
```

### Source name

```asm
ROM_StatementReturn: equ 0x1b76
```

### PROMETHEUS preparation

`invokeBasic` performs:

```asm
    ld iy,05c3ah
    im 1
    ei
    ld sp,(SYSVAR_ERR_SP)
    jp ROM_StatementReturn
```

### Purpose

PROMETHEUS restores the ROM's expected IY base, interrupt mode and interrupt
enable state, then restores the BASIC error-return stack pointer before jumping
into the ROM statement-return path.

### Result

Control resumes in the BASIC environment rather than returning to the
PROMETHEUS caller.

### Assumptions

- standard 48K ROM system-variable layout;
- `SYSVAR_ERR_SP` still describes a valid BASIC return context;
- IY=`$5C3A` is the ROM's expected system-variable base;
- interrupt mode 1 is the normal Spectrum environment.

### Where used

Editor command B / `BASIC`.

## B.15 `$1F54` — BREAK-key test

### Address

```text
$1F54
```

### Source name

```asm
ROM_BreakKey: equ 0x1f54
```

### PROMETHEUS-observed result contract

The trace loops interpret:

```text
carry set   = BREAK is not requesting termination; continue tracing
carry clear = BREAK detected; stop and wait for key release
```

Slow trace loops while carry remains set. Fast trace branches to the key-release
wait when carry becomes clear.

### Inputs

No explicit register input is prepared. The routine tests the Spectrum BREAK
chord, conventionally CAPS SHIFT+SPACE.

### Side effects

AF is changed. PROMETHEUS does not rely on preservation of other ROM scratch
state.

### Where used

- `monSlowTracing`;
- `monFastTracingToAddress`.

## B.16 `$22B0` — convert coordinates to a bitmap address

### Address

```text
$22B0
```

### Source name

```asm
ROM_PixelAddress_22b0: equ 0x22b0
```

### PROMETHEUS entry contract

The call sites use coordinate registers as follows:

```text
B or A-derived row state = vertical pixel/text-row coordinate as prepared by caller
C = horizontal pixel coordinate, commonly 0
```

The exact ROM convention is inherited by each caller; PROMETHEUS usually sets
C=`0` and supplies the row coordinate already expected by the ROM helper.

### Result

```text
HL = address in `$4000-$57FF` corresponding to the requested pixel position
```

PROMETHEUS then uses the result as the first byte of a character row, a clear
operation or a screen-row copy.

### Side effects

AF and other scratch registers may be changed. Callers save coordinates they
need afterward.

### Where used

- clear one 32-character bitmap row;
- copy a text row during fast source scrolling;
- position monitor/editor rendering at calculated screen coordinates.

### Why use ROM here but not for character rendering

The Spectrum bitmap line arrangement is awkward. The ROM already contains a
reliable coordinate-to-address calculation. PROMETHEUS reuses that calculation,
then performs its own fast byte-level drawing.

## B.17 `SYSVAR_ERR_SP` at `$5C3D`

### Address

```text
$5C3D-$5C3E
```

### Source name

```asm
SYSVAR_ERR_SP: equ 05c3dh
```

### Meaning

The word identifies the stack position used by the ROM's error/statement return
machinery.

### PROMETHEUS use

Before returning to BASIC, PROMETHEUS loads:

```asm
    ld sp,(SYSVAR_ERR_SP)
```

It then jumps to `ROM_StatementReturn`.

### Assumptions and danger

This is not a private PROMETHEUS variable. Writing it or returning with an
incompatible ROM context could send BASIC to an invalid stack frame. PROMETHEUS
only reads it during the carefully prepared BASIC exit.

## B.18 Port `$FE` — the ULA's shared keyboard/output port

Port `$FE` combines several unrelated hardware functions. Which function matters
depends on whether the Z80 executes `IN` or `OUT` and on the address placed on
the upper bus lines.

### B.18.1 Output layout used by PROMETHEUS

For `OUT ($FE),A`, the low bits control approximately:

```text
bits 0-2  border colour
bit 3     microphone/tape output
bit 4     speaker output
```

PROMETHEUS uses the port to:

- set or restore the configured border;
- toggle bit 4 for key clicks and beeps;
- establish the ROM tape border/MIC state before LOAD/VERIFY;
- mirror one compact disassembly mode byte as a historical command-feedback
  side effect.

Because one write affects all low output functions together, sound routines
derive a base byte containing the desired border and then toggle only speaker
bit 4.

### B.18.2 Keyboard input

The keyboard matrix is active low. A selected row is placed on the high address
lines and the five key bits are read in A bits 0–4.

Typical PROMETHEUS pattern:

```asm
    in a,(0feh)
    cpl
    and 01fh
```

After complementing, nonzero means at least one selected key is pressed.

Specific uses include:

- any-key-held streaming during long monitor lists;
- all-keys-released wait after BREAK;
- SPACE abort using row selector `$7F` and bit 0;
- editor held-key repeat on a selected row;
- installer/import cancellation polling.

### B.18.3 Side effects and timing

`IN` and `OUT` themselves do not call ROM, but timing matters:

- speaker pitch and duration are formed by instruction-loop timing;
- tape ROM code assumes a suitable port state and interrupt state;
- keyboard rows are active low and must be interpreted accordingly;
- changing a delay loop can audibly change behavior.

## B.19 Screen bitmap `$4000-$57FF`

### Layout

The 6,144-byte bitmap contains 256 pixels × 192 lines, but line order is
interleaved. Adding 32 moves one byte row horizontally/within a logical band, not
always to the next visible character row. PROMETHEUS often increments H to move
among the eight pixel rows of a character cell and uses the ROM pixel-address
helper for larger coordinate conversions.

### PROMETHEUS uses

- normal editor and monitor display;
- custom character rendering from ROM font data;
- line scrolling and row copying;
- monitor front-panel fields;
- installer logo;
- `$4000-$4FFF` temporary bootstrap workspace and stack area.

### Bootstrap destruction

The installer begins by clearing `$4000-$4FFF`. This deliberately destroys much
of the visible bitmap so it can serve as clean workspace and a temporary stack.
The installer later draws its own interface.

## B.20 Attribute RAM `$5800-$5AFF`

Each attribute byte describes one 8×8 character cell:

```text
bits 0-2  INK
bits 3-5  PAPER
bit 6     BRIGHT
bit 7     FLASH
```

PROMETHEUS stores common attributes such as:

```asm
TEXT_COLOR:               equ 038h
HIGHLIGHT_COLOR:          equ 030h
FRONT_PANEL_EDITOR_COLOR: equ 039h
```

The installer lets the user edit INK, PAPER and BRIGHT for normal and highlighted
text. Resident screen routines copy or transform attributes independently from
the bitmap.

## B.21 The ROM font

PROMETHEUS's custom renderer uses glyph bytes from the Spectrum ROM font rather
than calling ROM print for ordinary screen output. The exact font base is
reached through the established ROM/font convention in the display routines.
For each character, eight bitmap rows are fetched, optionally case/bold
transformed in the installer, and written into the interleaved display.

This gives PROMETHEUS:

- predictable 32-column placement;
- its own cursor and token rendering;
- direct control over attributes;
- speed independent of the ROM channel system.

## B.22 Interrupt assumptions

The program changes interrupt state according to subsystem needs.

### Installation

The bootstrap begins with `DI`. Self-location, screen-stack use, copying,
configuration patching and relocation must not be interrupted while code and
stack contexts are transient.

### Tape

The common LOAD/VERIFY wrapper executes `DI` before ROM tape timing. The ROM owns
the operation until return.

### Monitor execution

The monitor saves a user interrupt-enable state and constructs `DI` or `EI` as
the first scratch instruction. Interrupt state is part of the simulated user
processor, not merely a monitor setting.

### Returning to BASIC

`invokeBasic` restores IM 1 and executes `EI` before entering ROM statement
return.

### ROM printer channel

PROMETHEUS enables interrupts after opening channel 3 before using ROM output.

## B.23 Stack assumptions by service

| Service | Stack requirement in PROMETHEUS |
|---|---|
| `$0052` immediate RET | return word must remain readable; no intervening stack activity |
| keyboard ROM calls | ordinary resident/installer stack valid |
| tape ROM calls | stable writable stack for long timing-sensitive routine |
| channel/print ROM | ROM-compatible stack and interrupt state |
| BASIC return | SP restored from `ERR_SP`; not an ordinary subroutine return |
| monitor native CALL | user's saved SP must be writable and semantically valid |

## B.24 ROM-version dependency

The program's named addresses assume the standard 48K Spectrum ROM layout. A
compatible clone ROM must preserve not only public entry points but also the
particular internal entries and table at `$0052`, `$0205`, `$028E`, `$031E`,
`$04C6`, `$051A`, `$0562`, `$05C8` and `$22B0`.

A machine that merely provides BASIC-compatible behavior but moves these
internal routines is not binary compatible with PROMETHEUS.

## B.25 Quick diagnosis table

When a reconstructed build fails only in one area, these external contracts are
natural suspects:

| Symptom | First external contracts to inspect |
|---|---|
| installer cannot detect keys | `$028E`, `$031E`, port `$FE` |
| resident commands have wrong letters | `$0205`, `$028E`, modifier mapping |
| screen rows appear scrambled | `$22B0`, bitmap interleave assumptions |
| no key click or wrong border | port `$FE`, configured output byte, delay loops |
| SAVE writes bad block sequence | `$04C6`, `$051A`, AF' and marker setup |
| LOAD/VERIFY always fails | `$0562`, `$05C8`, IX/DE/flag/carry convention |
| PRINT goes to wrong destination | `$1601`, current ROM channel, `RST $10` |
| BASIC exit crashes | IY=`$5C3A`, IM 1, `ERR_SP`, `$1B76` |
| trace never stops on BREAK | `$1F54` carry interpretation |
| bootstrap copies from wrong place | `$0052` must be an immediate `RET` |

The larger lesson is that PROMETHEUS uses the ROM selectively. It does not hand
the application to BASIC, but neither does it duplicate every service. It keeps
high-frequency display, editing and assembly work under its own control while
borrowing carefully chosen machine services whose exact addresses form part of
the program's platform contract.
