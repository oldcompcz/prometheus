# Appendix C: Memory Maps

PROMETHEUS has no single permanent memory map. The bytes pass through several
arrangements between tape and a running editor, and the resident program itself
contains a moving boundary between source, symbols and generated code.

This appendix gathers the maps used throughout the book. Addresses beginning
with `B+` are offsets from a user-selected installation base `B`. Addresses
beginning with `L+` are offsets from the physical address at which the complete
installation CODE block was loaded.

Unless stated otherwise, end addresses in prose are inclusive. Diagrams that
show an **exclusive end** explicitly name it.

## C.1 The 48K Spectrum address space

```text
$0000 ┌──────────────────────────────────────────────┐
      │ 16K ROM                                     │
      │ PROMETHEUS calls selected fixed entry points│
$3FFF └──────────────────────────────────────────────┘
$4000 ┌──────────────────────────────────────────────┐
      │ screen bitmap, 6144 bytes                    │
      │ also temporary installer workspace/stack    │
$57FF ├──────────────────────────────────────────────┤
$5800 │ screen attributes, 768 bytes                 │
$5AFF ├──────────────────────────────────────────────┤
$5B00 │ ROM workspaces, channels, BASIC and free RAM │
      │                                               │
      │ installation image or resident PROMETHEUS     │
      │ source, symbols and generated user code        │
      │                                               │
$FFFF └──────────────────────────────────────────────┘
```

The historical nominal load and full-installation address is `$5DC0`, but the
bootstrap does not assume that the CODE data actually arrived there.

## C.2 The complete historical distribution TAP

The canonical tape image contains eight TAP blocks:

```text
block 0  HEADER BASIC  "PROMETHEUS"  length 54, autostart 9999
block 1  DATA   BASIC  54-byte loader program
block 2  HEADER CODE   "prometheus"  length 18,356, load 24,000
block 3  DATA   CODE   18,356-byte PROMETHEUS installation image
block 4  HEADER CODE   "skatecrazy"  length 7,291
block 5  DATA   CODE   7,291-byte payload
block 6  HEADER CODE   "gensor    "  length 300, load 55,000
block 7  DATA   CODE   300-byte GENSOR payload
```

Each logical Spectrum block is stored in TAP form as:

```text
2-byte little-endian TAP body length
flag byte
payload bytes
XOR checksum
```

The PROMETHEUS reconstruction replaces or verifies block 3 while preserving the
other seven blocks exactly.

## C.3 The distributed PROMETHEUS CODE image

The 18,356-byte PROMETHEUS data payload is an **installation image**, not the
16,000-byte resident program alone.

At its historical physical load address `$5DC0`, the broad layout is:

```text
$5DC0 ┌──────────────────────────────────────────────┐
      │ relocation-safe bootstrap                   │
      │ first 23 bytes before copied installer      │
$5DD7 ├──────────────────────────────────────────────┤
      │ physical bytes of installer assembled for   │
      │ logical execution at $5000                  │
      │ generated patch and relocation metadata     │
      │ first portion of installer logo/data        │
$65B2 ├──────────────────────────────────────────────┤
$65B3 │ remaining logo bitmap data                  │
$66F3 ├──────────────────────────────────────────────┤
$66F4 │ relocatable resident payload, offset $0000  │
      │ ENTRY_POINT_WITH_MONITOR                     │
$7A7B │ final byte of 5,000-byte monitor prefix     │
$7A7C │ ENTRY_POINT_WITHOUT_MONITOR                  │
      │ 11,000-byte assembler/editor suffix         │
$A573 │ final byte of complete installation image   │
$A574 │ exclusive end                               │
      └──────────────────────────────────────────────┘
```

The exact internal installer boundaries are best understood logically rather
than by assuming that their source assembly addresses equal their physical
positions in this concatenated file.

For an arbitrary physical load base `L`, the same image occupies:

```text
L+$0000 ... L+$47B3     18,356 bytes total
```

and the resident payload begins at:

```text
L+$1934
```

because `$66F4-$5DC0 = $1934`.

The bootstrap uses an explicit historical source offset `$0017` to find the
copied installer bytes in the physical image. That value describes this load
image concatenation, not an address inside the relocatable resident payload.

## C.4 The bootstrap's temporary use of screen memory

Immediately after entry:

```text
$4000 ┌──────────────────────────────────────────────┐
      │ cleared by LDIR                              │
      │ lower display bitmap temporarily destroyed  │
$401F ├──────────────────────────────────────────────┤
$4020 │ temporary installer stack starts here       │
      │ physical load base is pushed here           │
      │ later exchanged with physical payload ptr   │
$4FFF ├──────────────────────────────────────────────┤
$5000 │ fixed destination for copied installer      │
      └──────────────────────────────────────────────┘
```

The clear operation starts with HL=`$4000`, DE=`$4001`, BC=`$0FFF` and a zero at
`$4000`. On completion DE is naturally `$5000`, so the next LDIR can copy the
installer there without reloading DE.

The temporary stack is safe only because interrupts are disabled and the
installer owns the machine.

## C.5 The installer at logical `$5000`

The bootstrap copies `$07CD` bytes to `$5000` and jumps there.

```text
$5000 ┌──────────────────────────────────────────────┐
      │ installer code and writable operands        │
      │ screen/UI routines, key handlers             │
      │ copy/configuration/relocation decoder         │
      │ generated metadata located inside copied span│
$57CC └──────────────────────────────────────────────┘
$57CD   exclusive end of copied installer fragment
```

At `installerEntryAt5000`:

```text
HL  = physical pointer immediately after copied fragment
SP  = $4020 temporary screen stack
(SP)= physical base of entire loaded CODE image
```

The first 320 bytes at the physical HL complete two 20-character-by-8-row logo
bands. After the two logo-copy calls, HL points to the physical start of the
16,000-byte resident payload. `EX (SP),HL` then produces:

```text
HL   = physical CODE load base, for decimal display
(SP) = physical resident payload start, retained until ENTER
```

## C.6 Logical zero-origin resident image

The resident payload is assembled at origin zero:

```text
$0000 ┌──────────────────────────────────────────────┐
      │ ENTRY_POINT_WITH_MONITOR                    │
      │ monitor prefix                              │ 5,000 bytes
$1387 └──────────────────────────────────────────────┘
$1388 ┌──────────────────────────────────────────────┐
      │ ENTRY_POINT_WITHOUT_MONITOR                 │
      │ assembler/editor suffix                     │
      │ static tables and initial live tail         │ 11,000 bytes
$3E7F └──────────────────────────────────────────────┘
$3E80   relocatablePayloadEnd, exclusive/no byte
```

This zero-origin image is the address language used by relocation generation.
An internal absolute word initially contains a payload offset. Installation adds
the selected base or assembler-only corrected base.

Key stable offsets in v042 are:

```text
$0000  ENTRY_POINT_WITH_MONITOR
$01B4  startMonitor
$1388  ENTRY_POINT_WITHOUT_MONITOR
$1F09  startPrometheus
$2879  processKey
$3E80  relocatablePayloadEnd
```

Labels are more durable than these numeric offsets, but the offsets are useful
for verification and map reading.

## C.7 Full resident installation at base `B`

The full system copies all 16,000 bytes:

```text
B+$0000 ┌────────────────────────────────────────────┐
        │ monitor entry and monitor prefix           │
        │ front panel, memory tools, disassembler    │
        │ supervised execution and saved CPU image   │
B+$1387 └────────────────────────────────────────────┘
B+$1388 ┌────────────────────────────────────────────┐
        │ assembler/editor entry and body            │
        │ commands, parser, source, symbols, tape    │
        │ static dictionaries/instruction table      │
        │ twenty initial source records + empty table│
B+$3E7F └────────────────────────────────────────────┘
B+$3E80   exclusive resident end
```

At the historical base `$5DC0`:

```text
$5DC0 ┌──────────────────────────────────────────────┐
      │ monitor prefix                              │
$7147 └──────────────────────────────────────────────┘
$7148 ┌──────────────────────────────────────────────┐
      │ assembler/editor suffix                     │
$9C3F └──────────────────────────────────────────────┘
$9C40   exclusive end
```

At an example base `$8000`:

```text
$8000  monitor entry
$9388  assembler/editor entry
$BE7F  last resident byte
$BE80  exclusive end
```

## C.8 Assembler-only resident installation at base `B`

The installer omits the first 5,000 bytes and places the suffix directly at B:

```text
B+$0000 ┌────────────────────────────────────────────┐
        │ former payload offset $1388                │
        │ ENTRY_POINT_WITHOUT_MONITOR                │
        │ assembler/editor suffix                    │
        │ tables and initial live tail               │ 11,000 bytes
B+$2AF7 └────────────────────────────────────────────┘
B+$2AF8   exclusive end
```

For B=`$8000`:

```text
$8000  assembler/editor entry
$AAF7  final resident byte
$AAF8  exclusive end
```

The suffix's linked absolute words still describe zero-origin full-payload
offsets. The installer therefore relocates them with:

```text
addend = B - $1388
```

so that an original logical address `$1388+x` becomes physical `B+x`.

Two explicit assembler-only patches repair behavior that cannot be obtained by
uniform word relocation alone:

- the output/protection reference that must skip the omitted prefix;
- the MONITOR command fallback, which cannot jump into a monitor that was not
  installed.

## C.9 Overlapping copy layouts

The installation image and destination may overlap. Consider physical source
range `S..S+length-1` and destination `D..D+length-1`.

### Safe forward copy

```text
D <= S
or
D >= S+length
```

The installer can use `LDIR`:

```text
low addresses                                    high addresses
source  [----------------]
dest [----------------]       or       dest [----------------]
```

### Required backward copy

```text
S < D < S+length
```

```text
source [----------------]
          dest [----------------]
```

Forward copying would overwrite unread source bytes. The installer converts HL
and DE to inclusive block ends and uses `LDDR`.

The relocation and configuration walks occur on the copied resident, not on an
assumed non-overlapping image.

## C.10 Resident monitor prefix by functional neighborhood

The first 5,000 bytes are tightly interleaved, but a conceptual map is:

```text
B+$0000  full-system entry jump
          saved/default monitor configuration tables
          front-panel descriptors and protection windows
          warm monitor entry and key dispatcher
          address navigation and monitor input
          memory list/edit, block MOVE/FILL/FIND
          tape S/J/Y operations
          tracing, breakpoint and native CALL commands
          scratch-execution builder and state capture
          control-flow and memory-access classifiers
          disassembler and output routing
          front-panel rendering
          saved primary/alternate register image
          monitor strings and compact metadata
B+$1388  assembler-only boundary
```

This is not a strict source-order module map. The disassembler and panel
renderers, for example, consume tables placed near other monitor data.

## C.11 Saved processor image

The monitor stores a complete inspectable processor state in resident writable
bytes. Conceptually:

```text
saved primary registers
    AF, BC, DE, HL
saved index and system registers
    IX, IY, SP, I, R
saved alternate registers
    AF', BC', DE', HL'
monitor pseudo-registers
    T-state accumulator, X/Y display pointers, current PC
interrupt-enable state
scratch capture words for LD A,R and LD A,I flags
```

The exact bytes are interleaved with front-panel descriptors and execution
support. The front panel does not maintain a duplicate display model: descriptor
fields point directly to this saved state.

During one supervised step, the real Z80 temporarily receives the saved user
state. After the scratch instruction, capture code serializes the resulting
state back before restoring the monitor stack.

## C.12 Scratch execution area

The execution engine builds a temporary program in writable resident scratch
space:

```text
scratch start
┌───────────────────────────────────────────┐
│ DI or EI opcode selected from saved state │
│ restored register/context setup           │
│ copied, modified or substituted instruction│
│ optional branch/call return bridges       │
│ jump into sequential/taken capture path   │
└───────────────────────────────────────────┘
nearby scratch
┌───────────────────────────────────────────┐
│ temporary saved AF and interrupt probes   │
│ stack restore operand                     │
│ predicted next-PC/callback data           │
└───────────────────────────────────────────┘
```

The bytes are regenerated for each step. They are not a stable subroutine that
can be understood from one memory dump.

Native breakpoint and direct-CALL modes use related scratch/control structures
but may execute user code for an arbitrary duration before capture returns.

## C.13 The assembler/editor suffix by functional neighborhood

From payload offset `$1388`:

```text
+$1388  entry jump and tokenized command dispatcher
         editor commands and selected-block operations
         expression evaluation and symbol lookup
         source/symbol tape save, verify, load and GENS import
         two-pass assembly controller and second-pass emitters
         pseudo-instructions and RUN
         editor warm loop and source-line submission
         text-to-record parser and record-to-text expander
         source navigation and dynamic insertion/deletion
         keyboard, token and custom screen rendering
         symbol insertion/collection and memory utilities
         messages, mnemonic/operand dictionaries
         command names and 687 instruction descriptors
         twenty empty source records
         empty symbol table + code-end reserve
+$3E80  exclusive end
```

## C.14 Initial source and symbol tail

At the end of a freshly installed payload:

```text
lower addresses
┌────────────────────────────────────────────┐
│ instruction table                         │
├────────────────────────────────────────────┤
│ sourceBufferStart                         │
│ 20 × empty record `$00,$30`               │
│                                            │
│ sourceBufferPreviousLine marks record 12   │
│ sourceBufferAccessLine marks record 13     │
│ six further empty records below display   │
├────────────────────────────────────────────┤
│ symbolTableDefaultPt                      │
│ word `$0000` = zero symbol entries         │
├────────────────────────────────────────────┤
│ codeEndDefaultPt                          │
│ six reserved bytes in protected live tail │
├────────────────────────────────────────────┤
│ defaultPointerAdjustmentSentinel          │
│ harmless fallback word outside initial end│
└────────────────────────────────────────────┘
higher addresses
```

The source is initialized with twenty records so the access line can begin with
thirteen valid records above it and six below it.

## C.15 Dynamic source/symbol arrangement during editing

The persistent editor region changes as records and symbols are created:

```text
fixed resident tables
        │
        ▼
┌────────────────────────────────────────────┐
│ compressed source records                 │ grows/shrinks upward
│ permanent empty tail records              │
├────────────────────────────────────────────┤  varcSymbolTablePt
│ symbol count word                         │
│ ordinal vector                            │
│ sorted variable-length symbol records     │ moves as source changes
├────────────────────────────────────────────┤
│ protected live end / code-end state       │ varcCodeEndPt
└────────────────────────────────────────────┘
```

Source insertion opens a gap and moves the symbol area upward. Source deletion
closes a gap and moves it downward. The common memory movers repair physical
pointers; editor/symbol callers repair semantic references such as active line,
block boundaries and symbol ordinals.

## C.16 Symbol-table internal map

A conceptual live symbol table is:

```text
symbolTablePt:
+0  count low
+1  count high
+2  vector entry for ordinal 1
+4  vector entry for ordinal 2
...
    each vector word is a compact offset to a symbol record

sorted symbol records:
    flags/value/name representation
    variable-length high-bit-terminated name
```

The vector preserves stable one-based ordinals used by compressed source while
records can remain alphabetically sorted by name. TABLE C can remove unreferenced
unlocked records and rewrite ordinals in source.

## C.17 Default generated-code output

Without `ORG` or `PUT`, compilation initializes:

```text
logical address  = varcCodeEndPt + 1
physical output  = varcCodeEndPt + 1
```

Conceptually:

```text
resident + source + symbols
┌────────────────────────────────────────────┐
│ protected PROMETHEUS live region          │
└────────────────────────────────────────────┘  codeEndPt
                                             +1
┌────────────────────────────────────────────┐
│ default generated machine code            │
└────────────────────────────────────────────┘
```

`ORG` changes both logical and physical positions. `PUT` changes the physical
output pointer while preserving a distinct logical address counter. `DEFS`
advances positions without emitting bytes.

The assembler protects the live resident/source/symbol region from output. A
user-selected U-TOP limits the allowed high end.

## C.18 Selected source block representation

PROMETHEUS stores two source-record pointers as block margins. Their physical
order is not assumed; `getSelectedBlock` normalizes them:

```text
margin A ---- possibly earlier or later ---- margin B

normalized result:
DE = first record
HL = last record
```

Commands such as COPY, DELETE, PRINT, SAVE and block FIND consume that normalized
inclusive record range. Selection is editor state, not a bit stored in each
source record.

## C.19 Editor screen layout

The editor uses a twenty-record source window:

```text
screen top
┌────────────────────────────────────────────┐
│ 13 source records before active line      │
├────────────────────────────────────────────┤
│ active/access line                        │ highlighted attributes
├────────────────────────────────────────────┤
│ 6 source records after active line        │
├────────────────────────────────────────────┤
│ input/status region                       │ bottom bitmap rows
└────────────────────────────────────────────┘
```

Fixed addresses include:

```text
BOTTOM_LINE_VRAM_ADDRESS       `$50E0`
LEFT_BOTTOM_ATTRIBUTE_ADDRESS  `$5AE0`
ACCESS_LINE_ATTRIBUTE_ADDRESS  `$59E0`
THIRD_LINE_ATTRIBUTE_ADDRESS   `$5840`
```

The exact visual purpose of a byte depends on mode. The monitor reuses parts of
the same screen for its panel and edit line.

## C.20 Monitor front-panel descriptor map

There are thirty-four seven-byte descriptors. Each points to:

```text
+0..+1  bitmap address or special-area reference
+2      heading/name representation
+3      source class and formatting mode
+4      size/capability flags
+5..+6  value source or destination address
```

The fixed descriptor region maps directly onto:

- register fields;
- flags;
- memory list area;
- disassembly area;
- X/Y and stack-derived windows;
- monitor input/edit area.

The front-panel editor modifies descriptor bytes in place. The next redraw reads
the same table; there is no separate saved layout object.

## C.21 Protection-window tables

READ, WRITE, RUN, DEFB and DEFW area sets share a biased-count range layout:

```text
table start:
    stored count = visible ranges + 1
    first low word
    first high word
    second low word
    second high word
    ...
    spare tail storage
```

A dynamic resident range is synthesized from:

```text
ENTRY_POINT_WITH_MONITOR or adjusted assembler-only base
through current varcCodeEndPt
```

The monitor's range editor can display, insert and delete up to the format's
visible capacity. MOVE and FILL, however, call a resident-only checker and do not
consult custom READ/WRITE windows; Appendix G records that confirmed discrepancy.

## C.22 Masked finder workspace

The monitor G command stores five adjacent pairs:

```text
monitorFindByteMaskPairs:
+0 value 1   +1 mask 1
+2 value 2   +3 mask 2
+4 value 3   +5 mask 3
+6 value 4   +7 mask 4
+8 value 5   +9 mask 5
```

An expression gives mask `$FF`. A colon wildcard gives mask `$00`. N repeats the
same search specification starting at current address plus one.

## C.23 Temporary tape staging for source LOAD

Editor LOAD does not copy compressed records directly into live source. It loads
the saved payload near U-TOP, then imports records one at a time:

```text
high memory near U-TOP
┌────────────────────────────────────────────┐
│ staged saved source segment               │
│ staged bridge/metadata                    │
│ staged saved symbol table                 │
└────────────────────────────────────────────┘

for each imported record:
    expand using staged symbol table
    copy canonical text to inputBuffer
    submit through ordinary editor parser
    create/resolve live symbols by name
```

This staging separates the imported ordinal namespace from the live one.
Failure can leave already imported records committed; the operation is not a
transactional all-or-nothing merge.

## C.24 Temporary GENS/MASM import layout

The GENS importer similarly stages foreign bytes near U-TOP. Each foreign line
is framed by its two-byte line number and carriage-return termination, normalized
into a PROMETHEUS text line, limited to the edit-buffer capacity and submitted
through the ordinary source pipeline.

```text
staged foreign bytes
        ↓ line decoder
inputBuffer canonical text
        ↓ ordinary tokenizer/parser
live compressed source + live symbols
```

Control characters are normalized, high bits stripped, and overlong lines are
truncated according to the confirmed importer behavior.

## C.25 Relocation streams in the installation image

The generated stream represents 1,293 relocated words:

```text
first stream   571 monitor-prefix targets
bridge         moves running target to assembler suffix
second stream  722 assembler/editor targets
```

The emitted historical stream occupies 1,145 bytes. It is stored before the
remaining logo and resident payload in the installation image and is copied
with the installer to `$5000`.

A relocation stream does **not** contain absolute target addresses. It contains
deltas from the preceding target, plus optional run counts. The installer walks
both the stream and the copied destination image.

## C.26 Configuration patch stream

Fourteen selected user settings are copied into fourteen resident bytes or
opcodes. The table contains fourteen signed words:

```text
current patch pointer begins at payload offset 0
for each word:
    pointer += signed delta
    write next selected setting byte
```

The historical destination offsets are:

```text
$29CE $2502 $2950 $0F0C $16A4 $29BC $0ECC
$0EDA $2021 $2959 $1A41 $1F13 $16A7 $0F04
```

Order is installation write order, not address order; the signed deltas therefore
move both forward and backward through the payload.

## C.27 Installation-state timeline

The most useful combined map is chronological:

```text
1. Tape loader
   CODE image exists at physical L, perhaps not $5DC0.

2. Bootstrap
   $4000-$4FFF cleared; SP=$4020.
   Physical L recovered through CALL to ROM RET.

3. Installer copy
   `$07CD` bytes copied from L+$0017 to `$5000`.
   Control jumps to `$5000`.

4. Installer UI
   Logo tail read from original physical image.
   Physical payload pointer retained on screen stack.

5. Commit
   Full 16,000 bytes or suffix 11,000 bytes copied to B.
   Direction selected like memmove.

6. Configuration
   Fourteen settings patched into copied resident.

7. Relocation
   Monitor and/or assembler streams add correct base to 16-bit words.

8. Entry
   Fresh resident stack installed.
   Selected entry pushed and reached by RET.

9. Editor/monitor warm start
   Internal stack reset; screen redrawn; dynamic source/symbol tail begins live.
```

## C.28 Address arithmetic quick reference

```text
full payload length                 $3E80 = 16,000
monitor prefix length               $1388 =  5,000
assembler/editor suffix length      $2AF8 = 11,000
installation image length           $47B4 = 18,356
historical full base                $5DC0
historical full assembler boundary  $7148
historical full exclusive end       $9C40
historical physical payload start   $66F4 in loaded image
historical image exclusive end      $A574
installer execution base            $5000
bootstrap temporary stack           $4020
```

Whenever two of these values appear in one calculation, first identify the
address world:

```text
physical installation-image address
logical installer address
zero-origin payload offset
full resident physical address
assembler-only resident physical address
screen/hardware address
```

Most apparent address puzzles in PROMETHEUS come from mixing those worlds.
