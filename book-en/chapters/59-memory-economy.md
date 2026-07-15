# Chapter 59: The Memory Economy of PROMETHEUS

A 48K Spectrum appears generous when the program in question is a small game or
a short BASIC utility. It appears much less generous when one program wants to
be all of these at once:

- a full-screen source editor;
- a two-pass assembler;
- a symbol manager;
- a disassembler;
- a memory inspector and editor;
- a tape file manager;
- a breakpoint and tracing monitor;
- a configurable installer;
- a workspace in which the user's own source and generated code can grow.

PROMETHEUS's resident payload is exactly 16,000 bytes in the historical build:

```text
5,000 bytes   optional monitor prefix
11,000 bytes  assembler/editor suffix
```

That number does not include the user's growing source, symbols and generated
program. Those must share the remaining machine with the Spectrum ROM, screen,
system variables and stacks.

The interesting question is therefore not merely:

> How were individual routines made short?

The more useful question is:

> How did PROMETHEUS avoid storing the same meaning twice?

Its memory economy comes from compression, but also from shared representations,
table-driven behavior, movable boundaries, use of the Z80 itself as temporary
storage, and a willingness to let code bytes hold state.

## The first economy: omit an entire subsystem when it is not wanted

The largest saving is architectural rather than clever.

The payload has a hard boundary:

```text
ENTRY_POINT_WITH_MONITOR      offset $0000
ENTRY_POINT_WITHOUT_MONITOR   offset $1388
```

The first `$1388` bytes—exactly 5,000—contain the monitor. A user who wants only
the editor and assembler can install the 11,000-byte suffix by itself.

This arrangement has several costs. Absolute addresses in the suffix were
linked as though the monitor prefix existed, so assembler-only relocation needs
a different correction. A MONITOR command must be redirected because its
normal target is absent. The installer must support two copy lengths and two
entry meanings.

Yet the reward is substantial: one distributed image produces two useful
resident products without maintaining two unrelated code bases.

This is an early example of a principle that appears throughout PROMETHEUS:

> Share everything that can be shared, but preserve one carefully chosen
> boundary where a whole optional feature can disappear.

## Source records store meaning, not appearance

Human-readable source is expensive. Consider:

```asm
LOOP    DJNZ LOOP
```

Stored literally, it contains repeated letters, spacing chosen for presentation,
and a mnemonic whose spelling is already present in PROMETHEUS's dictionary.

The persistent source record instead stores compact facts:

```text
there is a label
its symbol ordinal is N
mnemonic index means DJNZ
operand class means relative expression
expression atom refers to symbol ordinal N
record ends here; previous record has this length
```

The exact bytes depend on the record form, but the saving principle is stable.
The line does not repeat `LOOP` twice as text. It does not repeat `DJNZ` at all.
It does not preserve decorative spaces.

This yields several economies at once.

### The source occupies fewer bytes

A long program can fit below U-TOP more easily.

### Assembly skips repeated lexical work

Once a line has been accepted, pass one and pass two operate on its encoded
meaning. They do not search the mnemonic dictionary and classify the same
parentheses every time the user assembles.

### Backward movement is encoded in-band

The terminal byte also contains the record's length class/back-link information.
The editor can find the previous variable-length record without a separate array
of line pointers.

### Display is derived when needed

Readable source is reconstructed into a temporary line buffer only for the
records currently being shown, printed, searched textually or edited.

The editor therefore keeps the expensive human view transient and the compact
semantic view persistent.

## Twenty empty records are cheaper than special cases everywhere

The initial source contains twenty fixed empty records:

```asm
sourceBufferStart:
    defb $00,$30
    ... twenty times ...
```

At first this seems wasteful. Why spend forty bytes on lines that contain
nothing?

Because those records buy simplicity in many hot paths.

The editor wants:

```text
13 valid records above the active line
1 active record
6 valid records below it
```

With permanent empty padding, the initial display and near-boundary navigation
can often use the same forward/backward record routines as ordinary source. The
program does not need a large collection of tests saying “if no previous line
exists, invent a blank row.”

Six empty records are also restored beneath the live source tail after deletion.
A small fixed storage cost removes repeated code and branch cost from the main
editor.

Memory economy is not always “use the fewest data bytes.” Sometimes a few data
bytes save more code bytes and complexity than they consume.

## Symbols use ordinals so names are stored once

Labels are another source of repetition. A program may mention `LOOP` dozens of
times. PROMETHEUS stores the name once in the symbol table and places a compact
ordinal in each source expression.

The symbol table separates two needs:

```text
source records need stable small identities
people need names in alphabetical order
```

A one-based vector translates ordinal to the current value/name record. The
records themselves are stored alphabetically for lookup and display.

This indirection means:

- source references remain small;
- names do not repeat in every expression;
- alphabetical insertion may move records without changing ordinals;
- compaction can remove one ordinal and systematically rewrite later references;
- imported source can translate foreign ordinals through names into live
  ordinals.

The vector costs two bytes per symbol, but it prevents much larger repeated
names and decouples source identity from physical table order.

## Packed strings avoid separate lengths and terminators

PROMETHEUS frequently marks the last character of a string by setting bit 7.
For example, the command name ASSEMBLY is stored conceptually as:

```asm
defb "ASSEMBL", 'Y'|$80
```

One byte serves two purposes:

- its low seven bits are the final character;
- its high bit is the end marker.

There is no separate zero terminator and no length byte.

The same convention also permits inline call strings. A routine can pop the
return address, treat it as a string pointer, print until the high-bit final
character, and then jump to the byte after the string. Code flow and data
location share the return address already created by `CALL`.

To a modern reader this is unusual. To PROMETHEUS it is a repeated method for
removing one byte here and one instruction there across many strings.

## Self-relative vectors avoid full pointers

Many tables store one-byte differences rather than two-byte absolute addresses.
A command dispatcher or descriptor group knows a base and adds a signed or
unsigned local delta.

This is economical when targets are nearby:

```text
full address per entry       2 bytes
one-byte relative entry      1 byte
```

It also survives moving the whole resident image without relocation, because
source and target move together.

The price is a range limit and a stronger dependency on table order. A routine
cannot be moved arbitrarily far away without widening the representation or
rearranging the group.

That is why apparently harmless table reordering can be dangerous. The physical
layout is sometimes part of the encoding.

## One instruction table serves three large subsystems

The included instruction table contains 687 five-byte records. That is a
noticeable investment in a 16K payload, but it replaces several larger bodies of
special-case code.

The table supports:

### Source entry

```text
mnemonic index + operand classes -> matching instruction record
```

### Assembly

```text
record -> prefix, opcode and operand-emission recipe
```

### Disassembly

```text
prefix/opcode pattern -> mnemonic and operand classes
```

### Monitored execution

The same decoded structure contributes:

- instruction length;
- base and taken timing;
- control-flow classification;
- memory-access matching.

The important saving is not that the table is tiny. It is that instruction
knowledge is stored once.

Without it, PROMETHEUS would need one opcode map for assembly, another for
disassembly, another length decoder for stepping, and scattered timing logic.
Those structures would eventually disagree as well as consume memory.

## One source parser serves several entrances

The ordinary editor parser is reused by operations that at first appear
unrelated.

### Native LOAD

Saved compressed records cannot be copied directly because their ordinals refer
to the imported symbol table. Each record is expanded to text using the imported
names, then submitted through the live parser to receive live ordinals.

### GENS/MASM import

Foreign text is normalized into an editor input line and submitted through the
same parser.

### REPLACE

The selected source record is expanded, changed as text, and submitted through
the normal overwrite path.

### Reverse disassembly

Decoded memory becomes textual assembly, then ordinary source input.

### Monitor one-line assembly

A temporary record is parsed and sent through the standard pass handlers without
being inserted into persistent source.

A larger program might implement five direct converters. PROMETHEUS maintains
one trusted gate:

```text
readable assembly text -> checked compact record
```

Every feature that can produce such text receives syntax checking, symbol
creation and instruction matching for free.

## One disassembly line serves several exits

The inverse direction has the same economy.

`disassembleNextLineToBuffer` creates a canonical line. Different callbacks send
it to:

- the scrolling screen;
- the front panel;
- the printer;
- the editor input path.

The decoder does not know whether a human is looking at the screen or whether
the line will become persistent source. Presentation and destination are
separate late decisions.

This is the same “one internal truth, several views” principle used by source
records and instruction descriptors.

## Code bytes double as variables

PROMETHEUS uses labels beginning with `varc` for state embedded in instruction
operands or opcodes.

For example:

```asm
varcAssemblyOutputPointer:
    ld hl,0000h
```

The two operand bytes are both:

- part of executable `LD HL,nn`;
- persistent storage for the current output pointer.

A conventional design might require:

```asm
assemblyOutputPointer:
    defw 0

    ld hl,(assemblyOutputPointer)
```

The self-modifying form saves the separate cell and can save instructions on
every read. Similar fields remember:

- source and code-end pointers;
- callbacks;
- pass handlers;
- continuation jumps;
- editor modes;
- keyboard repeat state;
- monitor addresses;
- installer rendering opcodes;
- execution policy.

Sometimes a whole opcode is the setting. `NOP` versus `RRCA`, `DI` versus `EI`,
or one patched `JP` target can express a mode without a branch and a separate
flag.

The cost is intellectual rather than spatial. A reader must understand that
editing an instruction shape may destroy a variable. Code movement must preserve
relocation and patch labels. Interrupts or re-entrancy could be dangerous if two
uses competed for the same patched operand—PROMETHEUS avoids this largely by
being a single-user, single-threaded workshop.

## Registers and flags are short-lived storage

PROMETHEUS has no universal calling convention. This is inconvenient for
reading, but economical in a program designed around carefully local contracts.

A helper may return:

- a pointer in HL;
- a count in BC;
- a classification in A;
- success or an inclusive comparison in carry;
- “submitted line” in Z;
- an alternate value in the shadow register bank.

If the caller already needs the value for its next operation, writing it to a
permanent variable and loading it back would waste bytes and time.

The stack also acts as a transient record:

- source traversal saves current and next pointers;
- the importer preserves staged-table context across parser submission;
- the installer uses SP as a configuration-delta reader;
- protection-table checks temporarily turn a range table into a stack;
- saved user processor state is deliberately arranged for POP restoration.

This economy works because contracts are narrow and the machine is not
pre-emptively multitasking.

## Alternate registers provide a second tiny workspace

`EXX` and `EX AF,AF'` let PROMETHEUS switch to another BC, DE, HL and AF without
copying them to RAM.

The monitor execution engine benefits most visibly. It must preserve one
processor image while using another set of registers to build and supervise the
trampoline. Tape and rendering paths also exploit the extra bank when several
pointers must remain live.

Alternate registers are not free: they make control flow harder to follow, and
an interrupt or ROM routine may impose additional rules. But in a 16K assembly
program they are six bytes of fast implicit storage built into the CPU.

## The bitmap becomes installer workspace

During installation, PROMETHEUS clears `$4000-$4FFF`. This region is normally
the upper part of Spectrum bitmap memory, but the ordinary editor is not yet
running.

The bootstrap uses it for:

- a private stack around `$4020`;
- temporary state;
- a clean installer display area.

The screen is therefore not only an output device. Before the resident workshop
exists, it is available RAM with a convenient known address.

After installation, the editor and monitor naturally reclaim the same physical
screen for visible use.

This is time-sharing rather than overlapping live data. The same bytes serve
different purposes in different stages of the program's life.

## Source, symbols and generated code share one moving frontier

The resident tail begins with:

```text
static dictionaries and instruction table
20 initial compressed source records
symbol count and small initial symbol/code-end tail
```

As source grows, the symbol-table base moves upward. As symbol records grow, the
combined end moves upward. Default generated output begins just above that end.

Conceptually:

```text
low addresses
    resident PROMETHEUS
    compressed source records       grows upward
    symbol table                    moves and grows upward
    code-end marker
    generated program bytes         placed in free memory
    ...
    U-TOP
high addresses
```

The arrangement avoids fixed reservations such as “4K for source, 2K for
symbols, 8K for code,” any of which might be wasted while another category runs
out.

Instead, the current program determines the balance.

The cost is that insertion and symbol growth must move memory and repair
pointers. `insertByteRangeAtHLFromDE`, deletion helpers and symbol-table routines
form the small memory manager that makes the flexible frontier possible.

## Protection is centralized at narrow choke points

Compact programs can become unsafe if every caller must remember every memory
rule. PROMETHEUS instead places checks where effects converge.

Examples include:

- all generated bytes pass through `emitByteAtAssemblyOutput`;
- source/symbol expansion passes through U-TOP checks;
- traced instructions pass through READ/WRITE prediction;
- relocation generation rejects unsupported address-byte forms;
- tape blocks use shared ROM parameter preparation;
- parser errors return through a saved error stack.

A central check costs code once and protects many features. It also reduces the
number of slightly different safety implementations that must be maintained.

## Biased counts and in-band markers save representation overhead

Several formats avoid a separate “type” or “empty” field by choosing a biased
value.

Examples include:

- protection-table range counts;
- relocation repeat commands;
- source-record terminal bytes;
- descriptor lengths;
- the `$01` cursor marker inside the editable line.

The data consumer already knows the context, so an otherwise unused value or bit
can carry control information.

This is compact, but it makes local bytes difficult to interpret without the
reader routine. The correct question is not “what does `$30` mean everywhere?”
It is “what does the source-record walker do with `$30` here?”

## The program pays complexity to save memory

PROMETHEUS's choices are not free.

### Compressed source

Saves memory and repeated parsing, but requires an encoder and expander.

### Symbol ordinals

Save repeated names, but require vectors, compaction and ordinal repair.

### Shared instruction table

Prevents duplicated instruction knowledge, but uses dense descriptors and
careful lookup rules.

### Self-modifying state

Saves variables and instructions, but couples data meaning to exact code shape.

### Movable source/symbol region

Uses free RAM flexibly, but every insertion may move a large suffix.

### Optional monitor prefix

Saves 5,000 resident bytes, but complicates relocation and entry patching.

### One parser for many features

Avoids duplicate front ends, but imports and reverse disassembly must take an
indirect text round trip.

The design is therefore not “clever tricks everywhere for their own sake.” It
is a network of deliberate exchanges:

```text
more local complexity
in return for
less duplicated persistent state and code
```

## What PROMETHEUS does not compress

It is equally instructive to notice where the program spends bytes.

- Twenty empty source records simplify the editor boundary model.
- The instruction table is large because shared declarative knowledge is worth
  storing.
- The front panel has thirty-four descriptors so one renderer can replace much
  hard-coded display logic.
- Error messages and command names remain readable enough for a human tool.
- The monitor keeps a complete saved processor image because omitting alternate
  registers or interrupt state would make stepping misleading.
- Relocation and configuration streams exist because movable installation is a
  primary feature, not an afterthought.

Good memory economy is not the smallest possible file. It is spending bytes
where they eliminate larger costs or preserve essential behavior.

## A compact budget of ideas

```text
Save whole regions        optional 5,000-byte monitor prefix
Save repeated spelling    compressed source + symbol ordinals
Save duplicate logic      shared parser, expander, decoder and instruction table
Save pointer width        self-relative vectors and local deltas
Save variable cells       self-modified operands/opcodes
Save temporary RAM        registers, alternate banks and stack
Avoid fixed wastage       movable source/symbol/code frontier
Spend bytes strategically padding records, descriptors, processor image, tables
```

## What has changed in memory

This chapter has not followed one command, so no single operation changes
memory. It has identified the ownership pattern of the whole resident system:

- static resident bytes contain code, tables and writable instruction operands;
- source text exists persistently only as compressed records;
- symbol names exist once, behind ordinal vectors;
- expanded lines are temporary;
- output code occupies whatever safe area follows the dynamic source/symbol end;
- screen and stack areas change purpose between installation and residency;
- optional installation can omit the monitor prefix entirely.

## Important labels and structures reconnected

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `sourceBufferStart`
- `sourceBufferAccessLine`
- `symbolTableDefaultPt`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `insertByteRangeAtHLFromDE`
- `lineBuffer`
- `encodeInputLineToSourceRecord`
- `expandSourceRecordToLineBuffer`
- `instructionTable.asm`
- `varcAssemblyOutputPointer`
- `emitByteAtAssemblyOutput`
- alternate register and saved-processor structures
- `internalStackTop`
- `relocatablePayloadEnd`

## Back to the whole machine

PROMETHEUS fits because it rarely keeps both a fact and all of that fact's
possible presentations.

It keeps one symbol name and many small ordinals. It keeps one instruction
description and uses it in several directions. It keeps compact source and
reconstructs text only when a person needs it. It keeps processor state as data
and makes it live only for the instant of execution.

This economy is also the main source of danger when modifying the program. A
byte that looks redundant may be carrying a second meaning; a routine that looks
private may be serving three subsystems; a table order may be part of an
encoding.

The next chapter turns those observations into practical modification rules.
