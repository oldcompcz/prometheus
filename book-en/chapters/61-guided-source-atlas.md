# Chapter 61: A Guided Source Atlas

The book has deliberately avoided following `prometheus.asm` from its first line
to its last. That would have introduced relocation before the reader knew what
was being relocated, the monitor before the source editor, and large tables
before the routines that give those tables meaning.

We can now reverse that decision.

The editor, assembler, monitor, execution engine and installer have all been
seen first as complete features and then as collections of smaller mechanisms.
The physical source file should no longer look like a wall of unrelated labels.
It can be read as the emitted geography of one tightly packed program.

This chapter is an atlas rather than another subsystem lesson. It follows the
current reconstructed `src/prometheus.asm` in physical order and answers four
questions for each region:

1. What bytes or definitions live here?
2. Which entry points and tables should a reader recognize?
3. Why does this material appear at this particular place in the file?
4. Which earlier chapters explain it in depth?

The line ranges quoted below refer to reconstruction v042. They are useful for
orientation, but labels remain the durable landmarks. Adding a comment near the
top of the file can move every later line number without changing a single
machine byte.

## The source has three different kinds of order

Before opening the atlas, separate three ideas that are easy to mix together.

### Textual order

This is the order in which material appears in `prometheus.asm`:

```text
constants
bootstrap
installer
installer metadata
resident monitor
resident assembler/editor
static language tables
initial source and symbol tail
```

An `INCLUDE` line brings another file into this textual stream at that exact
point.

### Emitted-image order

Most machine-emitting statements also appear in the order of their bytes in the
distributed CODE block. There are, however, changes of `ORG` and logical-address
contexts. The installer is copied to `$5000`, while the resident payload is
assembled from origin zero and later relocated.

The source therefore describes one distributed image containing several
logical address worlds.

### Runtime call order

Runtime control flow ignores textual neatness. A routine near the end may be
called by an entry near the beginning. A table after a renderer may describe
that renderer's earlier decisions. The editor can call the assembler, which can
call a shared expression evaluator, which can use symbol routines placed much
later.

Never assume:

```text
next in source = next in execution
```

The physical order is shaped by historical layout, optional installation,
compact offsets and the need to preserve exact bytes—not by a modern module
system.

## The atlas at one glance

The current main file can be divided into the following broad regions:

| Approximate v042 lines | Stable boundaries | Main subject |
|---:|---|---|
| 1–233 | file header through message constants | architecture notes, ROM/system addresses and constants |
| 234–304 | `bootstrapEntry` through `bootstrapCopiedFragmentEnd` | relocation-safe physical self-location |
| 305–1181 | installer origin through logo/metadata tail | interactive installer, copying, configuration and relocation decoder |
| 1182–1685 | `relocatablePayloadStart` through monitor output setup | monitor entry, panel descriptors, protection tables and navigation state |
| 1686–3743 | `startMonitor` through operation-error handling | monitor UI, memory/block/tape/input tools |
| 3744–4480 | `stepAtCurrentMonitorAddress` through access prediction | supervised execution engine |
| 4480–5868 | `disassembleNextLineToBuffer` through panel rendering | disassembly, protection checking, list output and front panel |
| 5869–6163 | access/control tables through monitor text | saved processor state and monitor metadata |
| 6164–7793 | `ENTRY_POINT_WITHOUT_MONITOR` through shared tape setup | command dispatcher, expressions, editor commands, symbols and tape import/export |
| 7794–8854 | `processCompilation` through `invokeRun` | two-pass assembler, encoded expressions and core shared utilities |
| 8855–11347 | `startPrometheus` through character display | editor warm loop, source parser, expansion, keyboard and screen output |
| 11348–12128 | symbol creation through temporary workspaces | symbols, memory movement, numeric formatting, insertion/deletion and buffers |
| 12129–12479 | `internalStackTop` through command-name tables | messages and compact language/UI dictionaries |
| include at 12480 | `instructionTable.asm` | 687 instruction-form records |
| 12488–12534 | `sourceBufferStart` through `relocatablePayloadEnd` | initial source, symbol table and emitted payload end |

This map is intentionally coarse. Some themes cross several regions. The
monitor's disassembler, for example, relies on the instruction table physically
near the end of the assembler suffix. The editor's source expander is also used
by monitor disassembly. Physical geography and conceptual ownership are not
always the same thing.

---

# Route One: The Distributed Installation Image

## Region 1: Design notes, machine addresses and shared constants

The source begins with a long architectural comment. This is not part of the
historical binary; it is a reconstructed guide describing:

- the installer and resident-image split;
- the optional monitor prefix;
- multi-origin relocation generation;
- self-modifying `varc...` state;
- compact data conventions;
- label policy;
- verification expectations.

A first-time source reader should read this header once, then return to it after
finishing the atlas. Many phrases that initially sound abstract—*assembler-only
suffix*, *opcode-shaped data*, *origin-dependent word*—will then point to
concrete regions.

The first emitted definitions are constants rather than routines:

```asm
INSTALLATION_ADDRESS: equ 0x5dc0
VRAM_ADDRESS:         equ 0x4000
ATTRIBUTES_ADDRESS:   equ 0x5800
LOADER_ADDRESS:       equ 0x5000
```

These names establish the four address worlds encountered during startup:

- `$5DC0`, the historical physical CODE load address;
- `$4000`, Spectrum screen bitmap memory and bootstrap workspace;
- `$5800`, screen attributes;
- `$5000`, the fixed temporary installer location.

They are followed by ROM entry points and system variables. A useful reading
habit is to classify each external address immediately:

```text
ROM_...     callable service supplied by the Spectrum ROM
SYSVAR_...  writable/readable state owned by the ROM environment
```

The remaining constants define screen positions, line counts, text colours,
buffer sizes and message indexes. They do not form one conceptual subsystem;
they are the vocabulary shared by everything that follows.

### Read this region with

- Chapter 3 for the memory map;
- Chapter 8 for Spectrum screen, keyboard, sound and ROM services;
- Chapters 50–57 for the installation addresses;
- Chapter 60 for symbolic-address modification rules.

### Do not over-read it

A constant's position near the top does not mean it is globally important.
`LINES_BEFORE_ACCESS_LINE`, for example, matters deeply to the editor window but
not to relocation. Use reference search to find consumers rather than trying to
memorize every definition.

## Region 2: The relocation-safe bootstrap

The first executable landmark is:

```asm
bootstrapEntry:
```

This short fragment exists in the distributed image at whatever physical
address the loader happened to use. It must run before the program knows that
address. Consequently it avoids ordinary absolute references to its own code
until it has recovered the physical base.

The important anchors are:

- `bootstrapEntry`;
- `bootstrapRecoverLoadAddress`;
- `bootstrapCopiedFragmentEnd`.

The region performs three jobs:

1. prepare the lower screen area as temporary workspace and stack;
2. discover the physical load address using a CALL to a ROM `RET`;
3. copy the small installer fragment to `$5000` and jump there.

The source looks deceptively ordinary after the clever stack trick has produced
the base address. That is a good example of why a source atlas must identify
boundaries. The strange part is concentrated at the beginning; the rest is a
normal position-independent copy.

### Why it appears here

The bootstrap must be the first executable bytes reached by the BASIC loader.
It also needs the installer bytes to follow at a known label difference. Its
physical place in the image is therefore part of its algorithm.

### Read this region with

- Chapter 51 for the complete instruction-by-instruction explanation;
- Chapter 57 for its role in the whole tape-to-editor journey.

## Region 3: The installer proper at logical `$5000`

After the bootstrap, the source changes to the installer's logical address
context. The principal entry is:

```asm
installerEntryAt5000:
```

From this point until the generated metadata and logo tail, the code assumes it
is running from its copied workspace at `$5000`.

The installer region itself contains several subregions.

### 3A. Screen construction and input loop

The visible setup interface begins around:

- `installerEntryAt5000`;
- `installerRedrawAndWait`;
- `installationAddressString`;
- `varcMonitorInstallFlag`;
- `varcInstallerTextAttribute`;
- `varcInstallerHighlightAttribute`;
- `varcKeyboardEchoDelay`;
- `varcInstallerCaseMode`;
- `varcInstallationAddressCursor`.

The many `varc...` labels are especially important here. The installer does not
store all choices in a conventional structure. It rewrites instruction operands
or opcodes that will later be read as settings.

When reading this area, pair every writable label with its use:

```text
where is the byte changed by a key?
where is the same byte later copied or interpreted?
is the label on the opcode, the instruction start or the operand?
```

The user-interface helpers follow nearby:

- decimal address editing;
- inline-string printing;
- case transformation;
- bold transformation;
- attribute manipulation;
- logo rendering.

Chapters 5 and 52 explain why these apparently tiny rendering routines also act
as persistent configuration storage.

### 3B. Choosing and copying the resident image

The copy path is anchored by:

- `installerPrepareAssemblerOnlyImage`;
- the full-image and backward-copy paths around it;
- payload-length expressions based on `relocatablePayloadEnd`;
- the monitor boundary `ENTRY_POINT_WITHOUT_MONITOR`.

The most important observation is that the source does not contain two resident
programs. It contains one 16,000-byte payload with a 5,000-byte removable prefix.
The installer selects either:

```text
ENTRY_POINT_WITH_MONITOR .. relocatablePayloadEnd
```

or:

```text
ENTRY_POINT_WITHOUT_MONITOR .. relocatablePayloadEnd
```

The assembler-only path also applies its intentional compatibility patches.
When editing this area, keep the distinction between *source pointer*,
*destination pointer*, *copy length* and *relocation correction* explicit.
They are related but not interchangeable.

### 3C. Configuration patch traversal

The installer does not contain fourteen hardcoded absolute destination
addresses. It consumes a signed-delta stream beginning at:

```asm
installerConfigurationPatchDeltas:
    include "configurationPatchTable.asm"
```

The decoder helpers are:

- `installerStoreAAndAdvancePatchPointer`;
- `installerAdvancePatchPointer`.

The include is generated from `configurationPatchTarget...` labels spread
through the resident payload. Textual source order therefore creates a useful
cross-file relationship:

```text
resident semantic labels
        ↓ build-time generator
configurationPatchTable.asm
        ↓ included here
original compact installer decoder
```

The Spectrum runtime knows nothing about the generator. It only walks the
historical delta format.

### 3D. Relocation decoder and table

The main runtime decoder is:

```asm
installerApplyRelocationTable:
```

The generated stream is included at:

```asm
include "relocationTable.asm"
```

A nearby label marks the transition from relocation metadata into the installer
logo tail:

```asm
relocationSecondStreamTerminatorAndLogoStart:
```

The decoder is small because the build-time table carries the list of 1,293
words requiring adjustment. The stream is split for the monitor prefix and the
assembler suffix, allowing the same compact decoder to support both installation
modes.

### 3E. Installer logo and end of temporary code

The logo bitmap and row renderer occupy the end of the installer area. Their
position matters because the bootstrap copies a bounded installer segment, and
the relocation stream terminator shares the transition into logo data.

This is a region where apparently decorative bytes still participate in image
layout. Moving the logo can change installer length even though it does not
change resident code.

### Read the whole installer with

- Chapters 50–57;
- Chapter 5 for writable instruction state;
- Chapter 7 for overlap-safe copying;
- Chapter 54 for configuration metadata;
- Chapter 55 for relocation generation and decoding;
- Chapter 56 for the surrounding TAP image.

---

# Route Two: The Optional Monitor Prefix

## Region 4: The zero-origin payload boundary and monitor entry

The resident payload begins at:

```asm
relocatablePayloadStart:
```

and immediately provides the full-installation entry:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

This jump may initially look surprising. The full image begins with the monitor
prefix, yet ordinary startup enters the editor. The monitor is a service entered
later by the `MONITOR` command; it is not the initial user interface.

The origin-dependent value `ENTRY_POINT_WITH_MONITOR+2` is also stored later as
opcode-shaped descriptor data rather than as an address. That is why the
multi-origin generator has the explicit
`relocationExceptionMonitorEntryDescriptorWord` exception in the table region.

The payload is assembled at origin zero. Every internal absolute word in this
region therefore begins as an offset. The installer adds the selected resident
base only at generated relocation targets.

## Region 5: Front-panel descriptors and protection-state storage

Soon after the monitor entry, the source presents data before the main monitor
loop:

- `frontPanelItemDescriptors`;
- `frontPanelEditLineItem`;
- `frontPanelListWindowItem`;
- `frontPanelDisassemblyWindowItem`;
- `frontPanelRegistersItems`;
- DEFB and DEFW disassembly-area tables;
- navigation-address stack;
- READ, WRITE and RUN protection tables;
- direct-call address list.

This ordering is a good test of mature source reading. A beginner often skips
large tables because they do not “do” anything. Here the tables *are* much of
the monitor's design.

The front panel is generic because each seven-byte descriptor says what to draw,
where to find its value and which representation to use. The protection tables
share a biased-count/range format. The direct-call list changes stepping policy
without changing the execution engine.

Read each table together with its later consumer:

| Early data | Later consumer |
|---|---|
| front-panel item descriptors | `renderFrontPanelItem` and renderer dispatch |
| DEFB/DEFW areas | `disassembleNextLineToBuffer` |
| READ/WRITE/RUN ranges | protection checkers and step validation |
| navigation stack | `monLevelUp` / `monLevelDown` |
| direct-call list | control-flow gate in the execution engine |

The data appears early partly because the historical layout keeps the monitor's
persistent configuration close to its entry. Conceptually, however, Chapters
34, 38, 39 and 46–48 should be read before trying to decode every byte.

## Region 6: Monitor warm entry and keyboard dispatcher

The monitor's true control-loop entry is:

```asm
startMonitor:
```

The nearby region includes:

- private-stack reset;
- restoration of display/input hooks;
- status construction;
- full-panel redraw;
- key normalization;
- the monitor key-action table;
- address navigation;
- byte and instruction movement;
- list-window setup.

The key table is another compact dispatch structure. The textual sequence of
handlers is not the keyboard's visible order; the table maps normalized key
codes to nearby routines through compact offsets.

Useful landmarks include:

- `monitorKeyboardActions`;
- `monitorKeyboardActionsTable`;
- `monSetCurrentAddress`;
- `monOneByteBack` / `monOneByteForward`;
- `monLevelUp` / `monLevelDown`;
- `varcMonitorCurrentAddress`;
- `monOneInstructionForward`;
- `monListDisassembly`.

Chapter 33 gives the top-level loop. Chapter 35 explains the address and input
state. Chapter 40 explains how list output becomes one of several destinations
for the same disassembly line.

## Region 7: Monitor input, memory editing and policy toggles

Following navigation, the file collects many visible monitor commands:

- one-shot memory editing;
- one-line assembly;
- prompted expression input;
- continuous memory editing;
- instruction-control toggle;
- direct-call mode cycling;
- numeric/symbolic disassembly modes;
- slow and fast tracing;
- interrupt-state toggle.

Important anchors are:

- `monMemoryEditingOneShot`;
- `editOneMonitorAssemblyLine`;
- `promptForMonitorValue`;
- `monitorInputRestart`;
- `assembleMonitorInputLine`;
- `monMemoryEditing`;
- `monToggleInstructionControls`;
- `monCycleDirectCallMode`;
- `monToggleNumericDisassemblyAddresses`;
- `monSlowTracing`;
- `monFastTracingToAddress`;
- `monToggleInterruptEnableState`.

This region demonstrates how PROMETHEUS shares lower-level machinery across
subsystems. Monitor expressions use the assembler's evaluator. One-line
assembly uses the ordinary parser and both pass handlers. The input line uses
the editor buffer and renderer, but with monitor-specific completion and error
continuations.

Do not read these routines as a second independent editor. They are adapters
around shared suffix code.

## Region 8: Monitor tape, reverse disassembly and native execution commands

The next visible tools include:

- block SAVE by First/Last or First/Length;
- block LOAD;
- tape header/leader inspection;
- register-bank swap;
- disassembly to printer;
- ranged disassembly into source;
- temporary-breakpoint run;
- native subroutine call;
- MOVE and FILL;
- numeric and character memory listings;
- direct-call-list editing;
- masked FIND/NEXT.

The region is large, but the routines can be grouped by the neutral form they
consume:

```text
inclusive memory range   -> SAVE, LOAD, MOVE, FILL
address                  -> listing, character view, run start
32-column lineBuffer     -> printer or source insertion
five (value,mask) pairs  -> FIND/NEXT
saved processor image    -> native call or breakpoint run
```

Representative landmarks are:

- `monSaveBlockFirstLast`;
- `prepareMonitorTapeBlockParameters`;
- `monLoadBlockFirstLast`;
- `monReadTapeHeaderOrLeader`;
- `monDisassemblyOnPrinter`;
- `monDisassembleIntoSource`;
- `parseAndInsertDisassemblyLine`;
- `monRunToTemporaryBreakpoint`;
- `monCallSubroutineWithSavedState`;
- `monMoveBlockFirstLast`;
- `monFillBlockFirstLast`;
- `monListMemoryFromTheCurrentAddress`;
- `monCharactersFromTheCurrentAddress`;
- `monFindSequence` / `monNextSequence`.

Chapters 36–42 describe these as user features. In physical source order they
also form a bridge to the execution engine: the breakpoint and native-call
commands introduce saved state and scratch execution before supervised stepping
begins.

## Region 9: Range-table editor and shared monitor prompts

Before the single-step entry, the source gathers helpers for:

- editing protection tables;
- editing the direct-call list;
- rendering range endpoints;
- initializing the monitor line assembler;
- prompting for First/Length and First/Last;
- resident-write checks;
- operation-error display and recovery.

Useful anchors include:

- `writeMonitorTextToDE`;
- `displayAndEditFiveRangeTable`;
- `displayAndEditDirectCallAddressList`;
- `monitorInputBuffersInitialization`;
- `renderMonitorInputLine`;
- `monitorInputLoop`;
- `promptForFirstAndLength`;
- `promptForFirstAndLast`;
- `preserveBlockRangeAndCheckResidentWrite`;
- `showMonitorOperationError`.

This is not glamorous code, but it explains why the higher-level monitor
commands remain compact. Prompting, parsing, retries, display and range
normalization are centralized here.

---

# Route Three: Supervised Execution

## Region 10: Step entry, user-state restoration and capture

The execution engine begins at:

```asm
stepAtCurrentMonitorAddress:
```

and quickly reaches:

```asm
stepInstructionAtHL:
```

This region orchestrates one complete step:

```text
decode
validate
construct scratch instruction
restore user state
execute on the real Z80
capture state
repair logical flow and timing
return to monitor
```

The most important anchors in the first half are:

- `testCapsShiftEnter`;
- `restoreUserStateAndExecuteTrampoline`;
- `captureUserStateAfterTakenFlow`;
- `captureUserStateAfterSequentialFlow`;
- `breakpointHitCaptureEntry`;
- `varcTakenFlowNextAddress`;
- `varcSequentialNextAddress`;
- `varcRestoreMonitorStackAfterExecution`.

The source order mirrors the physical scratch exits: sequential and taken paths
need distinct capture entries because they commit different logical addresses
and timing values.

Chapters 43, 45, 48 and 49 should be kept open while reading this area.

## Region 11: Control-flow repair and scratch construction

The next cluster contains the small interpreter that rewrites dangerous control
flow:

- return-stack adjustment;
- descriptor-driven control-flow handlers;
- relative-branch transformation;
- direct CALL/RST policy;
- scratch instruction copy;
- appended capture jumps.

Principal labels include:

- `replaceScratchCallReturnAddress`;
- `advanceSavedStackAfterReturn`;
- `tracedControlFlowHandlerOffsets`;
- `simulateRelativeControlFlow`;
- `directCallModeGateOpcode`;
- `buildInstructionExecutionTrampoline`;
- `appendSequentialAndTakenCaptureJumps`;
- `beginExecutionTrampoline`.

This is a place where local labels matter. Many dot-prefixed destinations select
small nearby cases and should not be mistaken for reusable interfaces.

The central architectural fact from Chapter 46 is visible here: PROMETHEUS does
not emulate instruction arithmetic. It only changes the physical control-flow
edges needed to return safely to its capture code.

## Region 12: Pre-execution validation and effective-address prediction

Before executing the scratch copy, PROMETHEUS predicts whether the instruction
would read or write forbidden memory.

The cluster begins around:

- `validateInstructionBeforeExecution`;
- `varcInstructionControlsDisabled`;
- `validateMatchedMemoryAccess`;
- `matchInstructionAccessDescriptor`;
- `effectiveAddressAccessorOffsets`;
- the effective-address accessor routines;
- `varcDecodedInstructionOperandWord`.

This code should be read alongside the descriptor tables placed later in the
monitor prefix. One side performs table matching; the other side stores masks,
access size and address-recipe indexes.

The split is typical of PROMETHEUS:

```text
compact declarative table later
small generic interpreter here
```

Chapter 47 explains the recipes for registers, indexed displacements, stack
addresses and block-transfer ranges. Chapter 38 explains the target protection
tables.

---

# Route Four: Decoding and Displaying the Machine

## Region 13: Disassembly into the neutral line buffer

The main disassembly pipeline begins at:

```asm
disassembleNextLineToBuffer:
```

Its physical position immediately after execution validation is logical: the
stepper already needs decoded instruction length and metadata, and the monitor
needs the same decoder for display.

The cluster includes:

- line-buffer clearing and pending separator state;
- DEFB/DEFW area classification;
- instruction decode;
- operand-handler dispatch;
- signed and indexed displacement formatting;
- symbol lookup by value;
- numeric formatting policy;
- `decodeInstructionAtHL`.

Important labels include:

- `varcDisassemblyInstructionAddress`;
- `varcDisassemblyAddressMode`;
- `varcShowNumericDisassemblyAddresses`;
- `dispatchDisassemblyOperandHandler`;
- `disassemblyOperandHandlerOffsets`;
- `findSymbolOrdinalByValue`;
- `decodeInstructionAtHL`.

The output is not drawn directly. It is a 32-column `lineBuffer` representation
that later code can send to the scrolling window, fixed front-panel item,
printer or source parser.

Read with Chapters 39 and 40, then revisit Chapters 20–21 to see the same
instruction metadata from the opposite direction.

## Region 14: Generic protection checks and monitor list output

After decoding come reusable address/range checks:

- `checkRangeAgainstResidentRegionOnly`;
- `checkRangeAgainstProtectionTable`;
- `checkAddressAgainstProtectionTable`;
- their stack-restoration exits.

The code temporarily uses the range table as stack-driven traversal state. This
is one of those routines that looks stranger when isolated than when understood
as a response to memory pressure.

The following output helpers include:

- `beginMonitorListOutputWithBlankLine`;
- `appendLineBufferToMonitorListWindow`;
- `renderLineBufferAtMonitorListCursor`.

Together these routines connect neutral decoded text to the moving twenty-line
monitor list area.

Chapters 38 and 40 explain both halves.

## Region 15: Front-panel editor and renderer

The next major source block implements the descriptor system introduced near the
start of the monitor prefix.

Its entry points and state include:

- `invokeFrontPanelEditor`;
- `varcActiveFrontPanelItemOffset`;
- `redrawFrontPanelAtCurrentAddress`;
- `redrawEntireFrontPanel`;
- `renderFrontPanelItemIfEnabled`;
- `renderFrontPanelItem`;
- `clearOrRenderFrontPanelSpecialArea`;
- `varcInterruptEnableState`;
- `varcFrontPanelDisassemblyAddress`.

Below these lie the specialized renderers:

- flag headings and conditions;
- binary byte;
- character;
- decimal word;
- operand name;
- high-bit text;
- bitmap-address movement.

The physical order is a classic table-interpreter arrangement:

```text
editor and high-level traversal
        ↓
generic descriptor renderer
        ↓
small format-specific renderer dispatch
        ↓
screen-address stepping helpers
```

Chapter 34 is the main guide. Chapter 8 explains the Spectrum bitmap operations.
Chapter 5 explains the configuration-patched attributes and mode operands found
inside this region.

## Region 16: Saved processor image and monitor metadata tables

Near the end of the optional prefix, executable code gives way to persistent
state and large declarative tables.

The saved processor image begins around:

- `savedRegisterR`;
- `savedRegisterI`;
- `savedAlternateRegisterSet`;
- saved IY, IX, BC, DE, HL and AF words with byte aliases;
- `savedRegisterSP`;
- `accumulatedTStates`;
- monitor address X/Y state.

This layout is deliberately stack-shaped. Restore routines POP values in one
order; capture routines PUSH them back in the inverse order.

The large tables following it include:

- `readAccessDescriptorTable`;
- `monitorTables`;
- `writeAccessDescriptorTable`;
- `relocationExceptionMonitorEntryDescriptorWord`;
- `controlFlowDescriptorTable`;
- `monitorTextReferences` and `monitorTextsTable`.

Each belongs to a consumer earlier in the prefix:

| Table | Main chapters |
|---|---|
| saved processor image | 43, 48, 49 |
| READ/WRITE descriptors | 47 |
| control-flow descriptors | 46 |
| monitor text vector/table | 6, 33–41 |
| relocation exception | 55 |

The final monitor text ends immediately before the assembler-only boundary.
That placement is not merely aesthetic: the next label must remain the first
byte copied for an assembler-only installation.

---

# Route Five: The Assembler/Editor Suffix

## Region 17: The assembler-only entry and command dispatcher

The exact boundary is:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
```

This label has three simultaneous meanings:

1. resident entry for an assembler-only installation;
2. start of the 11,000-byte suffix;
3. symbolic subtraction point for installer lengths and relocation correction.

The first routines establish command dispatch and source-position commands.
Important landmarks include:

- `commandHandlerTable`;
- source start/end commands;
- `getSourceEndPosition`;
- `invokeUTop`;
- textual expression evaluation through `evaluateInputExpression` and
  `evaluateExpressionAtHL`.

The command table appears before many handlers because the dispatcher needs a
compact central map. Some handlers lie immediately below; others are much later.
Do not infer ownership from proximity alone.

Read with Chapters 9, 10, 17 and 22.

## Region 18: FIND, REPLACE, PRINT and source-block operations

The next cluster contains the higher-level editor commands:

- `invokeReplace` and its continuation;
- `invokeFind` / `findNextOccurrence`;
- callback-driven line scanning;
- lowercase argument storage;
- `invokePrint`;
- `invokeDelete`;
- line-buffer text matching;
- replacement-text storage.

The callbacks are the key to this area's compactness. FIND and PRINT share
record traversal, while REPLACE expands a record to text and deliberately sends
it back through the ordinary parser.

The physical order reveals the pipeline:

```text
command state
-> common scanner
-> reconstructed lineBuffer
-> command-specific callback
-> optional ordinary source submission
```

Chapters 14, 17 and 18 explain this region.

## Region 19: Symbol display, locking and compaction

The symbol command block begins around:

- `displaySymbolTableColumn`;
- symbol-table display state;
- `invokeTable`;
- `processSymbolTableItems`;
- `invokeClear`;
- compaction pointers;
- source-reference scanning.

This is the *management* side of symbols: display, lock/unlock, clear and
`TABLE C` collection. The lower-level name lookup and physical insertion
routines appear much later in the file.

That separation is intentional. User commands are grouped near other command
handlers, while the common symbol primitives live with parser/memory helpers.

Read Chapters 23 and 24. When following a call, expect to jump thousands of
source lines forward to `parseSymbolNameAndFindOrdinal`,
`findOrCreateSymbolOrdinal` and the table-movement routines.

## Region 20: Native source SAVE, VERIFY, LOAD and GENS import

Tape-oriented editor commands follow symbol management:

- `invokeSave`;
- retained source/symbol lengths and pointers;
- tape-header writing;
- filename input;
- `invokeVerify`;
- `performTapeLoadOrVerifyOrReportError`;
- `invokeLoad` and imported cursors;
- GENS/MASM import aliases;
- imported-symbol resolver-base patch;
- matching CODE payload load;
- border-status helper.

This region is not the monitor's raw block-tape system. It understands native
compressed source plus symbol tables, or foreign text records converted through
the editor parser.

The important architectural line is:

```text
staged tape representation -> canonical editor text -> live source records
```

rather than direct copying of foreign ordinals into the live table.

Read Chapters 29–32.

## Region 21: The two-pass assembly controller and emitters

The assembler proper begins at:

```asm
processCompilation:
```

and includes:

- scope selection;
- self-modified pass-handler call;
- source-record traversal;
- `invokeAssembly`;
- pseudo-operation scanning;
- `secondPassEmitSourceRecord`;
- `emitMachineInstructionBytes`;
- immediate/signed validation;
- `emitByteAtAssemblyOutput` and its writable pointer;
- logical address counter;
- word emission;
- first-pass record processing;
- error return to the source record.

This is the best source region to read after Chapters 19 and 25–28. Those
chapters explain the outer shape, allowing the reader to focus here on register
contracts and record dispatch rather than rediscovering why two passes exist.

The writable state is especially dense:

- current pass handler;
- next source record;
- transition counter;
- output pointer;
- U-TOP;
- logical address counter;
- current line-label entry.

Most are instruction operands. Audit `+1` references carefully.

## Region 22: Encoded expression evaluator and arithmetic

Below the pass handlers lies the evaluator used on compressed source records:

- `evaluateEncodedExpressionAtIX`;
- operator decoding;
- `applyExpressionOperatorToHLAndDE`;
- software division;
- software multiplication;
- unary minus;
- quoted constants.

This is distinct from the textual parser near the suffix entry, though both
ultimately implement the same left-to-right expression language.

The physical placement beside the assembler is natural: encoded expressions
are primarily consumed during pass processing. The monitor borrows the textual
route instead.

Read Chapter 22.

## Region 23: Shared tape, cancellation and command bridges

The remaining pre-editor block includes:

- ROM tape LOAD/VERIFY wrapper;
- SPACE cancellation checks;
- assembler-to-monitor bridge;
- assembler-only fallback opcode/address;
- QUIT/BASIC and tape-header scanning helpers;
- number-base and INSERT/OVERWRITE toggles;
- screen-row copy and source navigation helpers;
- RUN and its `ENT` balance/call target.

These are the seams between major user operations. They are physically near the
assembler because many of them depend on assembly state or determine what
happens after compilation.

The assembler-only monitor fallback is especially layout-sensitive. In the
suffix-only product, `MONITOR` must not jump into an omitted prefix. Chapters 53
and 55 explain the two installer patches that make this boundary safe.

---

# Route Six: The Editor Core and Language Front End

## Region 24: Cold start, warm starts and the main editor loop

The visible editor begins at:

```asm
startPrometheus:
```

followed by several warm-start levels:

- `prometheusWarmStart`;
- `prometheusWarmStartWithMessage`;
- `prometheusWarmStartWithCurrentBuffers`.

The region initializes or preserves different amounts of state, rebuilds the
screen, paints the status bar and eventually reaches keyboard processing.

The important continuation points are writable:

- last status-bar message;
- post-command continuation jump;
- active source-record pointer;
- input-buffer position;
- insert/overwrite mode.

The main submission fork is:

```asm
submitInputLineOrDispatchCommand:
```

followed by:

```asm
parseAndInsertSourceLine:
```

Read Chapters 9, 10, 13 and 18 before following this source region. It will then
look like a concrete implementation of a known cycle rather than a maze of warm
entries.

## Region 25: Editable input buffer behavior

The next cluster implements:

- cursor movement;
- character insertion/deletion;
- field tabulation;
- cursor marker tracking;
- command-token expansion;
- repainting.

The main state is attached to:

- `updateInputBuffer`;
- `varcInputBufferPosition`;
- `varcInputColumnAfterCursor`.

The physical buffers themselves are later, so this code repeatedly refers
forward to `inputBufferStart` and its guard byte.

Chapter 11 explains the travelling `$01` cursor marker and why INSERT/OVERWRITE
applies to source records rather than character insertion.

## Region 26: Source-line encoder and instruction-form recognition

The source front end begins at:

```asm
encodeInputLineToSourceRecord:
```

and descends through:

- optional label handling;
- mnemonic and operand fields;
- `decodeInstructionTableRecord`;
- operand validation;
- expression encoding;
- quoted/numeric atom encoding;
- bracket/comma validation;
- radix-digit conversion;
- IX/IY normalization;
- operand classification;
- length-bucket lookup;
- input-field readers.

Important writable state includes:

- `varcSecondOperandClass`;
- `varcFirstOperandClass`;
- `varcMnemonicIndex`;
- `varcUseIYPrefix`;
- `varcIndexRegisterVariantOffset`.

This code reaches forward into the mnemonic, operand and instruction tables near
the end of the payload. Chapters 13, 20 and 21 should be treated as its map.

## Region 27: Source expansion and navigation

The inverse pipeline is physically interleaved with parser helpers and source
window rendering:

- symbol-reference resolution;
- `expandSourceRecordToLineBuffer`;
- operand expansion;
- previous/next record traversal;
- visible-source rendering;
- source-record rendering;
- callback-driven expanded-line output;
- high-bit string lookup and padded printing.

Key anchors include:

- `resolveSymbolReferenceToName`;
- `varcSymbolTableBasePointer`;
- `expandSourceRecordToHL`;
- `getPreviousSourceRecord`;
- `getNextSourceRecord`;
- `renderVisibleSourceRecords`;
- `varcSourceBufferActiveLine`;
- `printExpandedSourceLineWithRoutine`.

This is the source region where the editor's persistent format becomes visible
text again. Chapters 12, 14 and 15 explain the framing, inverse decoding and
window geometry.

## Region 28: Screen rendering, keyboard and beeper

Near the lower part of the editor core, the source collects shared physical I/O:

- edit-line repaint;
- bitmap-row clearing;
- ROM keyboard scanning and repeat state;
- `processKey`;
- CAPS LOCK and last-key state;
- accepted-key beeper;
- character classification;
- token/character display;
- generic character renderer;
- text colour and printing position;
- bold-transform configuration patch.

Representative labels are:

- `repaintEditLine`;
- `renderInputLineAtBitmapAddress`;
- `readKeyCode`;
- `processKey`;
- `getKeypressCodeOrZero`;
- `keypressBeep`;
- `displayInputTokenOrCharacter`;
- `displayCharacter`;
- `varcPrintingPosition`.

This region is shared far beyond the editor. The installer has its own small
renderer because it runs before the resident image is ready, but the monitor
borrows many resident display/input conventions from this suffix.

Read Chapters 8, 10 and 11.

---

# Route Seven: Shared Storage Machinery and Static Languages

## Region 29: Symbol creation and physical table movement

The low-level symbol primitives begin around:

```asm
parseSymbolNameAndFindOrdinal:
```

and include:

- current symbol-table pointer;
- entry-area base;
- find-or-create logic;
- code-end pointer;
- new vector slot;
- closing deleted symbol gaps;
- overlap-safe memory movement.

This is the physical side of the symbol table, complementing the user command
block much earlier in the suffix.

The important anchors are:

- `varcSymbolTablePt`;
- `varcSymbolEntryAreaBase`;
- `findOrCreateSymbolOrdinal`;
- `varcCodeEndPt`;
- `varcNewSymbolVectorSlot`;
- `closeDeletedSymbolDataGap`;
- `moveMemoryBlockOverlapSafe`.

Read Chapters 7, 23 and 24.

## Region 30: Number formatting, pointer repair and source mutation

The following general utilities include:

- hexadecimal and decimal formatting;
- fixed-width byte output;
- pointer adjustment after insertion;
- source-line deletion;
- pointer adjustment after deletion;
- status-bar helpers;
- source/code-end comparisons;
- COPY;
- byte-range insertion.

Key labels include:

- `printNumberToIX`;
- `varcHexMode`;
- `adjustPointerAtHLIfAtOrAfterInsertion`;
- `varcInsertionPointForPointerAdjustment`;
- `deleteSourceLinesAtHL`;
- `adjustPointerAtHLForDeletion`;
- `varcDeletionStartForPointerAdjustment`;
- `invokeCopy`;
- `insertByteRangeAtHLFromDE`.

This region is the mechanical engine beneath many semantic operations. It moves
bytes and repairs common pointers; callers remain responsible for editor meaning
such as which record becomes active afterward.

Read Chapters 7, 16 and 17.

## Region 31: Shared temporary buffers and scratch memory

A dense block of named storage follows:

- `lineBuffer` and its guard/marker position;
- number and command-argument buffers;
- monitor tape-header fields;
- operand buffers;
- parsed mnemonic buffer;
- input buffer and guard;
- loaded tape-header fields;
- interrupt capture scratch;
- encoded source-record workspace;
- backing area below `internalStackTop`.

This area explains many forward references encountered earlier. PROMETHEUS does
not allocate temporary objects. It reuses fixed resident workspaces whose
meaning changes by operation.

The most important rule when modifying it is ownership in time:

```text
which subsystem is active?
which buffer contents must survive a callback?
can this workspace execute as scratch code?
does the internal stack grow into the same area?
```

Chapter 5 discusses code/data overlap. Chapters 11–14 explain editor buffers.
Chapter 45 explains execution from the encoded-record workspace.

## Region 32: Error messages and mnemonic dictionary

At `internalStackTop`, the source switches from workspace to static packed
language data:

- `errorMessages`;
- `mnemonicsReferences`;
- `mnemonicsTable`.

The message table uses high-bit termination. The mnemonic vector uses one-byte
self-relative displacements from each vector cell to its packed spelling.

The physical order—reference vector immediately before spelling table—keeps all
displacements within one byte. Moving one without the other can break the format
even if every symbolic label still resolves.

Chapter 6 explains high-bit strings and self-relative vectors. Chapter 20
explains mnemonic length buckets and indexes.

## Region 33: Fixed operand dictionary and editor command names

The next static structures are:

- `operandsReferences`;
- `operandsTable`;
- `operationLabels`;
- high-bit-terminated command names such as ASSEMBLY, COPY, FIND and TABLE.

The fixed operand table stores registers, conditions and parenthesized fixed
forms. Expression-bearing operands are represented by classes rather than full
strings.

The command-name vector supports canonical expansion of tokenized editor
commands. Several tokens deliberately map to the same visible word, which is
why repeated-looking vector entries must not be “deduplicated” casually.

Read Chapters 6, 10, 20 and 21.

## Region 34: The included 687-record instruction table

At this point `prometheus.asm` says:

```asm
include "instructionTable.asm"
```

The included file is not an external library in the modern sense. Its bytes are
inserted directly into the resident payload at this location.

Each five-byte record connects several meanings:

- mnemonic index;
- two operand classes;
- prefixes and opcode pattern;
- instruction length/emission recipe;
- timing and other metadata used by decoding/stepping.

The same table supports:

```text
source text -> instruction form
instruction form -> machine bytes
machine bytes -> source form
machine bytes -> length and timing knowledge
```

Because the table is large and regular, the book does not reproduce all 687
records. Chapter 20 explains the format; Chapters 26, 39, 46–48 show its
consumers.

When changing it, use Chapter 60's multi-direction checklist. A record that
assembles correctly can still disassemble incorrectly or provide wrong stepping
metadata.

## Region 35: Initial source, empty symbol table and payload end

The final emitted region begins at:

```asm
sourceBufferStart:
```

It contains twenty empty compressed records. Two labels identify special
positions inside them:

- `sourceBufferPreviousLine`;
- `sourceBufferAccessLine`.

The padding gives the editor thirteen valid records above the active line and
six below it before the user enters any source.

After the empty records come:

```asm
symbolTableDefaultPt:
    defw 0
```

and the initial combined source/symbol/code-end tail:

- `codeEndDefaultPt`;
- `defaultPointerAdjustmentSentinel`.

Finally:

```asm
relocatablePayloadEnd:
```

emits no bytes. It is a semantic boundary used by installer length expressions,
metadata generation and build verification.

This is an elegant ending. The last emitted bytes are not dead padding after a
program; they are the initial live dynamic state into which the editor will
immediately grow.

Read Chapters 3, 12, 15, 16, 23 and 59.

---

# How to Use the Atlas While Reading Code

## Start at a semantic entry point

Do not begin with an arbitrary address from a disassembly. Choose the feature's
entry:

```text
editor startup             startPrometheus
editor key processing      processKey
source submission          submitInputLineOrDispatchCommand
assembly                   processCompilation
monitor                    startMonitor
single step                stepAtCurrentMonitorAddress
disassembly                disassembleNextLineToBuffer
installation               installerEntryAt5000
```

Read downward until the routine delegates to a different conceptual region.
Then use the atlas to jump to that region instead of continuing blindly through
physical source.

## Follow data to its consumer

When encountering a table, search for the routine that reads it. When
encountering an interpreter, search for its table.

Useful pairs include:

```text
frontPanelItemDescriptors       <-> renderFrontPanelItem
controlFlowDescriptorTable      <-> traced control-flow dispatch
read/write access tables        <-> matchInstructionAccessDescriptor
mnemonicsReferences             <-> compareWithMnemonics
operandsReferences              <-> fixed operand lookup
instructionTable.asm            <-> parser, emitter and decoder
configurationPatchTable.asm     <-> installerAdvancePatchPointer
relocationTable.asm             <-> installerApplyRelocationTable
```

PROMETHEUS often stores half an algorithm in code and the other half in a packed
table.

## Mark writable instruction shapes

Whenever a `varc...` label appears, note:

- the complete instruction;
- the exact byte being rewritten;
- all writers;
- all execution paths that consume it;
- whether it is relocated or configuration-patched.

This turns self-modifying code from mystery into an explicit state record.

## Distinguish region boundaries from ordinary labels

These labels affect the build or optional layout and deserve stronger caution:

```text
bootstrapCopiedFragmentEnd
installerEntryAt5000
relocatablePayloadStart
ENTRY_POINT_WITH_MONITOR
ENTRY_POINT_WITHOUT_MONITOR
sourceBufferStart
relocatablePayloadEnd
```

Moving an ordinary routine may change relocation offsets. Moving a section
boundary can also change which bytes exist in the assembler-only product.

## Use the book in both directions

The chapters and source atlas form a two-way map.

From feature to source:

```text
“I want to understand FIND”
-> Chapter 17
-> invokeFind / findNextOccurrence
-> shared scan callback and lineBuffer matcher
```

From source to feature:

```text
“I found effectiveAddressAccessorOffsets”
-> atlas Region 12
-> Chapter 47
-> predicted READ/WRITE safety during stepping
```

The routine/table index planned for Appendix F will make this lookup finer, but
the atlas already provides the large-scale geography.

# A Final Walk from Top to Bottom

We can now summarize the physical file in one continuous sentence.

`prometheus.asm` begins by naming the Spectrum world in which it will run. A
small bootstrap discovers where the distribution image actually landed and
copies an installer into the screen's lower workspace. The installer asks the
user where and how PROMETHEUS should live, copies either the full resident
payload or its assembler/editor suffix, applies fourteen visible configuration
choices, relocates 1,293 internal words and transfers control.

The zero-origin payload begins with the optional monitor. Its first area stores
front-panel descriptions, protection ranges and navigation state. Its main code
implements address movement, memory viewing, block tools, tape operations,
reverse disassembly and native execution commands. A supervised execution engine
then rewrites only dangerous control-flow edges, predicts memory effects, runs
the real instruction in scratch RAM and captures the resulting processor. The
shared disassembler turns bytes into a neutral line; generic output and
front-panel code render that line and the saved processor. The prefix ends with
saved-state fields, execution descriptor tables and compact monitor text.

At exactly 5,000 bytes, `ENTRY_POINT_WITHOUT_MONITOR` begins the suffix that can
survive alone. Command dispatch, editor operations, symbol commands and native
source tape transfer lead into the two-pass assembler and encoded expression
evaluator. The cold/warm editor core follows, then the source parser, expander,
keyboard and screen services. Low-level symbol and memory-moving routines sit
beneath them, followed by shared work buffers and packed language dictionaries.
The included instruction table supplies one common semantic description of 687
instruction forms. Twenty empty compressed records and an empty symbol table
finish the emitted image, already prepared to become the user's working source.

That is the liver of PROMETHEUS: not one central routine, but a dense organ of
shared representations through which every feature passes.

# What the Main Text Has Accomplished

The sixty-one chapters have now covered the complete program at architectural,
algorithmic and source-geographical levels:

- Part I supplied the Z80 and Spectrum techniques needed later;
- Part II followed the editor from keys to compressed source and back;
- Part III explained names, expressions and both assembler passes;
- Part IV followed source to tape and back;
- Part V explained monitor inspection and disassembly;
- Part VI reconstructed supervised real-Z80 execution;
- Part VII explained bootstrap, installation, relocation and TAP construction;
- Part VIII reconnected the whole machine, its memory economy, safe modification
  rules and physical source layout.

The main narrative is complete. The appendices remain useful work rather than
missing architecture. They will provide quicker reference views of material the
chapters have already explained: unusual Z80 techniques, ROM contracts, memory
maps, compact formats, command keys, routine/table indexes and documented
uncertainties.

## Important source anchors

- `bootstrapEntry`
- `installerEntryAt5000`
- `installerConfigurationPatchDeltas`
- `installerApplyRelocationTable`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `startMonitor`
- `stepAtCurrentMonitorAddress`
- `disassembleNextLineToBuffer`
- `frontPanelItemDescriptors`
- `readAccessDescriptorTable`
- `controlFlowDescriptorTable`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `processCompilation`
- `startPrometheus`
- `submitInputLineOrDispatchCommand`
- `encodeInputLineToSourceRecord`
- `expandSourceRecordToLineBuffer`
- `processKey`
- `findOrCreateSymbolOrdinal`
- `moveMemoryBlockOverlapSafe`
- `lineBuffer`
- `internalStackTop`
- `mnemonicsReferences`
- `operandsReferences`
- `instructionTable.asm`
- `sourceBufferStart`
- `symbolTableDefaultPt`
- `relocatablePayloadEnd`

## Back to the source

The source file no longer needs to be read as a puzzle in which every address is
unknown. Its regions have roles, its tables have consumers, its writable
operands have owners, and its boundaries have build meanings.

The next stage of the book will not add another hidden subsystem. It will turn
the completed explanation into reference appendices that let a reader answer
smaller questions quickly while keeping this larger map in view.
