# Chapter 60: How to Modify the Program Without Breaking It

The resurrection project has changed PROMETHEUS in one important sense already:
we can now name its routines, rebuild its exact historical bytes, generate its
address metadata and test relocated installations automatically.

That does not make modification effortless.

PROMETHEUS is compact because many boundaries that a modern program would keep
separate are deliberately joined:

- code operands are variables;
- table order can encode addresses;
- source records and symbols share a moving region;
- one instruction table serves several directions;
- assembler-only installation cuts through one resident source file;
- generated relocation metadata depends on emitted bytes;
- saved tape source contains format-specific ordinals and records.

A safe change begins by deciding **what kind of change it is** and which
contracts it crosses.

This chapter is a practical guide, not a promise that every modification is
simple. Its central rule is:

> Change meaning at the highest level that already owns that meaning, then let
> the existing shared machinery carry the change downward.

## First classify the change

Before editing a line, place the proposed work into one of four categories.

### 1. Explanatory change

Examples:

- improve a comment;
- rename a reconstructed label;
- add a source-roadmap heading;
- clarify a generated report.

No machine-emitting statement should change. The rebuilt binary and TAP should
remain byte-for-byte historical.

This is the safest category, but even label renaming must update every reference,
annotation and documentation link.

### 2. Structural source change with intended identical bytes

Examples:

- replace a numeric expression with an equivalent symbolic expression;
- introduce a label at an existing address;
- split a long source block with comments;
- use a dot prefix for a genuinely local branch label;
- regenerate a table that must reproduce its historical bytes.

The source looks different, but the emitted statement stream should remain
identical. Historical binary identity is still the acceptance test.

### 3. Functional byte change within existing formats

Examples:

- fix a routine;
- add an editor command using existing command/source structures;
- alter a display behavior;
- add a new instruction-table record without changing the record format;
- enlarge the resident payload;
- move a routine or table.

The binary and TAP may change deliberately. Relocation, configuration metadata,
length expressions and installation tests must follow the new layout.

### 4. Format or architectural change

Examples:

- change compressed source-record encoding;
- widen a one-byte self-relative table;
- change symbol ordinal representation;
- extend the runtime relocation stream format;
- move the assembler-only boundary;
- alter the native tape source format;
- replace the saved processor image layout.

This is not merely “add some code.” Every producer, consumer, saved file,
importer and test of the representation must be found. Backward compatibility
becomes an explicit design decision.

The category determines the burden of proof.

## Begin from a source anchor, not from a byte address

The reconstructed source provides semantic boundaries such as:

```text
bootstrapEntry
installerEntryAt5000
relocatablePayloadStart
ENTRY_POINT_WITH_MONITOR
ENTRY_POINT_WITHOUT_MONITOR
sourceBufferStart
relocatablePayloadEnd
```

Use them.

A historical address such as `$7A7C` may describe where a boundary happened in
one load layout. It is not the enduring meaning of the boundary.

Prefer:

```asm
ENTRY_POINT_WITHOUT_MONITOR-relocatablePayloadStart
```

over:

```asm
$1388
```

when the expression's purpose is “monitor prefix length.”

The numerical result may currently be the same, but the symbolic form continues
to describe the program after code moves.

The same rule applies inside routines. Branch to a semantic label, not an old
address copied from a disassembly listing.

## Preserve the difference between global and local labels

Dot-prefixed labels in this source mean:

```text
nearby private control-flow destination
not called indirectly
not taken as an address
not shared as a data or patch boundary
```

The assembler used by the project does not give them lexical scope. Their full
names must still remain globally unique.

Do not make a label local merely because it has one reference. A one-reference
label may still be:

- a callable entry;
- a continuation patched into a `JP`;
- a table target whose address is taken;
- a relocation/configuration anchor;
- a source-region boundary;
- an externally meaningful entry point.

Conversely, a descriptive global name is unnecessary for a tiny nearby loop
that is never addressed as data.

The prefix communicates interface intent to the next reader.

## Treat every `varc...` label as code and data simultaneously

Suppose the source contains:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

A routine may write to:

```asm
varcAssemblyOutputPointer+1
```

The `+1` is not arbitrary. It selects the two-byte immediate operand after the
opcode.

Unsafe changes include:

```asm
; replacing LD HL,nn with a different-width instruction
; inserting a prefix before the operand without updating patch sites
; changing the opcode while assuming only the value matters
; moving the label from the instruction start to the operand without auditing references
```

A safe review asks:

1. Which bytes are read as executable code?
2. Which bytes are written as persistent state?
3. Is the entire opcode itself a mode value?
4. Is the operand relocated at installation?
5. Is it one of the fourteen configuration targets?
6. Does a report or test expect the label to identify the instruction start or
   the operand?

When adding new writable code state, give the operand or opcode an explicit
semantic label and document its width.

## Do not simplify opcode-shaped data by appearance

Some tables deliberately contain bytes that look like Z80 instructions. The
relocation exception:

```asm
relocationExceptionMonitorEntryDescriptorWord:
    defw ENTRY_POINT_WITH_MONITOR+2 ; @noreloc
```

is the clearest example. Differential assembly sees an origin-dependent word,
but the consumer treats its bytes as descriptor fields rather than an address.

Other compact tables may contain:

- opcodes used as mode selectors;
- masks that resemble prefixes;
- counts biased into opcode ranges;
- one-byte routine deltas;
- strings whose final byte has bit 7 set.

Never replace a strange byte sequence with something “equivalent” until the
consumer has been traced.

The correct unit of understanding is often the table plus its reader, not the
line containing `DEFB` or `DEFW`.

## Preserve source-record invariants

The compressed source language is shared by the editor, assembler, tape
translation, reverse disassembly, search, replace and symbol compaction.

A valid record must preserve:

- its two-byte header meaning;
- pseudo-opcode versus machine-instruction classification;
- optional label encoding;
- operand-class fields;
- encoded-expression boundaries;
- symbol ordinal tags;
- terminal/back-link information;
- any fixed-size special record rule.

When adding a new source form, identify every direction:

```text
text -> record            encoder
record -> text            expander
record -> length/address  first pass
record -> bytes/effect    second pass
record -> saved tape      native SAVE
saved record -> live      LOAD translation
record -> references      symbol scanner/compactor
```

If even one direction is missing, the feature may appear to work until a user
prints, reloads, compacts symbols or navigates backward.

A format change also affects existing saved source tapes. Decide whether old
records remain readable or whether a versioned converter is required.

## Preserve the source/symbol moving-region contracts

`insertByteRangeAtHLFromDE` is the central opener of gaps. It assumes the
combined dynamic region is packed and then repairs:

- `varcCodeEndPt`;
- `varcSymbolTablePt`;
- selected-block boundaries at or after the insertion;
- caller-selected semantic pointers through the documented insertion boundary.

Do not move bytes in this region with a casual `LDIR` and then repair only the
pointer that was visible in the current routine.

Before adding a new persistent pointer into source or symbol storage, decide how
it behaves when bytes are inserted or deleted before it. It may need to join the
common repair logic.

Likewise, preserve the permanent empty tail records. Removing them as “unused
padding” changes navigation and display assumptions.

## Preserve stable symbol ordinals—or rewrite every reference deliberately

A symbol ordinal is stored throughout compressed expressions. The vector table
maps it to the current alphabetical record.

If symbol records move, vector offsets are repaired and ordinals can stay the
same.

If a vector entry is removed during `TABLE C`, every greater ordinal embedded in
source must be decremented.

A new symbol-table operation must therefore answer:

```text
Does this change only physical record positions?
Does it change vector offsets?
Does it change ordinal numbering?
Which compressed records contain affected ordinals?
```

Do not sort the vector array alphabetically. Do not replace ordinals with raw
record pointers unless every source representation and tape workflow is being
redesigned.

## Change instruction knowledge in the shared table when possible

If a Z80 instruction form is missing or wrong, the preferred home for the fix is
the instruction descriptor table, provided the existing five-byte format can
express it.

A table change may affect:

- source-entry matching;
- prefix/opcode emission;
- immediate/displacement recipe;
- disassembly recognition;
- instruction length;
- base and taken timing;
- stepping/control-flow classification.

This is a benefit: one correction can repair several directions. It is also a
risk: an apparently assembly-only change can alter disassembly or tracing.

After changing a record, test both directions:

```text
source form -> exact expected bytes
bytes       -> expected source form
```

Then test execution metadata where the instruction has special control flow,
memory access or timing.

If the format cannot express the new instruction, widening or reinterpreting a
record is an architectural change. Audit all 687 consumers and generated table
placement assumptions.

## Add a command through the existing dispatch layers

An editor command normally crosses several compact structures:

1. keyboard/token spelling;
2. operation-label dictionary;
3. token-to-handler entry in `commandHandlerTable`;
4. handler routine;
5. warm-start or custom continuation behavior;
6. status/error message token where appropriate.

Do not add a parallel textual command parser merely because it seems easier.
That would duplicate normalization, token expansion and dispatch rules.

Check whether the command operates on:

- the active line;
- the inclusive selected block;
- whole source;
- the input line following the command token;
- persistent state needed by a repeated command such as FIND/NEXT.

If the handler temporarily redirects `varcPostCommandContinuationJump`, restore
the normal target on every completion and error path.

## Add monitor functionality through neutral representations

The monitor already has shared forms for common tasks:

- current address in `varcMonitorCurrentAddress`;
- formatted output in `lineBuffer`;
- inclusive First/Last or First/Length ranges;
- front-panel descriptor records;
- editable protection windows;
- saved user processor state;
- decoded instruction structure.

A new view should preferably produce `lineBuffer` rows and choose a sink, rather
than writing an unrelated screen renderer.

A new front-panel value should preferably gain a descriptor or renderer class,
not hard-coded repaint logic scattered through the monitor loop.

A new traced safety rule should join validation before execution, not attempt to
undo an unsafe write afterward.

This keeps the monitor's top-level warm-entry model intact.

## Respect trusted tools versus traced user execution

Not every monitor memory command uses READ/WRITE protection windows.

The windows describe what an unknown user instruction may access while being
traced. Trusted monitor operations such as viewing, MOVE or FILL have their own
rules, generally centered on protecting the resident workshop where required.

Do not assume that adding a range to WRITE protection should automatically block
every monitor edit. That would change the model explained by the user interface.

When modifying a command, identify which policy class it belongs to:

```text
trusted monitor operation
assembler output protection
traced READ/WRITE prediction
traced RUN destination protection
resident self-protection
```

These overlap but are not interchangeable.

## Keep control-flow rewriting separate from arithmetic execution

The stepper's strength is that the real Z80 performs the instruction. It rewrites
only control-flow edges that would otherwise escape the scratch trampoline.

When adding support for a new control-flow form:

1. decode the logical sequential and taken destinations;
2. decide whether the physical instruction can run unchanged in scratch;
3. create capture exits for every possible path;
4. preserve the user-visible stack effect of CALL/RET/RST forms;
5. return a logical PC independent of scratch addresses;
6. select correct timing for the path actually taken;
7. validate predicted memory and execution destinations before committing.

Avoid turning the stepper into a partial software emulator unless that is an
intentional redesign. A half-emulated instruction set would create two sources
of Z80 semantics and many opportunities for flag discrepancies.

## Treat monitor/assembler boundary changes as architectural

The historical boundary is exactly 5,000 bytes from the payload start. It
controls:

- assembler-only source start;
- assembler-only copy length;
- relocation stream split;
- addend correction;
- the omitted monitor range;
- the fallback patch for the MONITOR command;
- installation and execution tests.

Adding bytes inside the monitor prefix is supported by the generated build
machinery; the symbolic boundary moves with `ENTRY_POINT_WITHOUT_MONITOR`.

Moving the boundary semantically—placing a shared routine on the other side or
making the suffix depend on omitted monitor data—requires more thought. An
assembler-only image must still contain every routine and datum reachable from
its entry.

Before moving shared code into the optional prefix, search for:

- direct calls from the suffix;
- address-taken callbacks;
- table deltas;
- data references;
- configuration targets;
- relocation words;
- monitor fallback behavior.

The fact that a call happens only during MONITOR use does not automatically make
its target safe to omit if the command itself remains in the suffix.

## Let the generators own generated tables

Two tables are generated from semantic source anchors:

- configuration-patch deltas;
- relocation target streams.

Do not hand-edit their emitted include files.

For configuration fields, add or change an ordered annotation at the actual
source destination:

```asm
configurationPatchTargetNNMeaning: equ $+1 ; @config-patch NN
```

The order is the installer's write protocol. Orders must be unique and
continuous.

For relocation, write normal symbolic internal addresses as complete words. The
multi-origin generator will detect them.

Use `@noreloc` only for an origin-dependent word that is semantically not an
address, and explain the exception beside the data. Use `@reloc` only when a
real target cannot be discovered normally.

Never introduce isolated forms equivalent to:

```asm
defb LOW residentLabel
defb HIGH residentLabel
```

The historical runtime relocator cannot adjust them. The build deliberately
rejects unsupported origin-dependent single bytes.

## Know the historical relocation stream limit

A single target gap in the compact historical format must fit its encoding. The
current generator fails explicitly if a modified layout creates a gap larger
than the supported `$C7` single-gap range.

Do not silence the failure by inserting a fake relocation target. The correct
choices are:

- move relevant code/data so the gap becomes encodable;
- add a legitimate address-bearing word if the design naturally needs one;
- or intentionally extend the relocation format and its runtime decoder.

The third choice changes historical emitted code and must be tested in both
installation modes.

A loud build failure is safer than a table that silently relocates the wrong
word.

## Regenerate lengths and rebuild the TAP

The distributed CODE block contains more than the resident payload:

```text
bootstrap + installer + generated metadata + logo + resident payload
```

A functional change may alter:

- payload length;
- monitor boundary;
- assembler-only length;
- installer copy length;
- relocation stream size;
- complete CODE block size;
- TAP header length;
- TAP data-block length;
- header and data checksums.

Use symbolic section differences in assembly and the variable-length TAP builder.
Do not patch the old 18,356-byte value by hand.

Unrelated TAP blocks should remain untouched unless the distribution itself is
being changed.

## A disciplined modification recipe

The following sequence is intentionally conservative.

### Step 1: write the behavioral intention

Describe the change without Z80 instructions.

For example:

```text
Add a command that clears only the selected source block after confirmation.
```

State visible inputs, outputs, cancellation and error behavior.

### Step 2: locate the owning representation

Ask which existing subsystem already owns the meaning:

```text
editor command dispatch?
source-record mutation?
instruction table?
front-panel descriptor?
configuration target?
relocation generator?
```

Avoid creating a parallel mechanism.

### Step 3: list affected contracts

For the example command:

- command token and handler;
- selected-block inclusivity;
- deletion helper;
- permanent tail padding;
- active-line repair;
- status message;
- warm-start continuation.

For a new instruction, the list would be entirely different.

### Step 4: make boundaries symbolic

Introduce semantic labels for any new region, operand, patch target or callback.
Do not bake current addresses into logic.

### Step 5: preserve or document representation changes

If no format changes, say so. If a format changes, write its old and new grammar
and identify every producer/consumer.

### Step 6: regenerate metadata

Run configuration and relocation generation from the modified source. Checked-in
generated files must match fresh output exactly.

### Step 7: test both resident layouts

A change is not complete merely because the full monitor build starts.

Test:

```text
full 16K image
assembler-only suffix
several destination bases
forward and backward overlapping copies
```

If the change lives in the suffix, both products must execute it.

### Step 8: test the visible feature and its inverse paths

Examples:

- parser feature: enter, expand, save, load, compact symbols;
- instruction feature: assemble, disassemble, step;
- tape feature: save, verify, load, cancel, malformed input;
- monitor view: screen, panel, printer or source destination as applicable.

### Step 9: preserve history when history should be preserved

For comment-only or byte-neutral work, require exact binary and TAP identity.

For intentional functional changes, retain the historical artifact as a
reference and document why hashes differ.

### Step 10: update the book and source atlas

A modification that cannot be explained clearly may still contain an
unrecognized dependency. Documentation is part of the design review.

## Worked example: moving an ordinary routine

Suppose a routine in the assembler/editor suffix grows and must be moved.

A safe procedure is:

1. keep its global entry label;
2. move all genuinely private dot-labelled control flow with it;
3. search for direct `CALL`/`JP` references;
4. search for its address stored in tables or self-modified callbacks;
5. regenerate relocation metadata—absolute references will move;
6. verify one-byte relative table deltas still reach;
7. verify assembler-only installation still contains the routine;
8. assemble/disassemble or exercise its visible feature;
9. test installations at nonhistorical bases.

The machine code does not need to remain at its old address. The semantic label
and generated relocation system are designed to permit movement.

## Worked example: adding a display-only status message

This is smaller but still crosses compact formats.

Questions include:

- Is the message high-bit terminated?
- Is it selected by a token/index whose order is fixed?
- Does the rendering routine expect inline text after a `CALL`?
- Will adding bytes create an unencodable self-relative table delta?
- Does the message live in the monitor prefix or shared suffix?
- Does its insertion move configuration or relocation targets?

The visible change may be one sentence, but the correct representation determines
whether it costs a new renderer, one table entry or merely one packed string.

## Worked example: adding an instruction form

Suppose an instruction table entry is corrected or added.

Verify:

```text
text input is classified into the intended operand classes
instruction-table search chooses the new record
second pass emits exact prefix/opcode/operand order
disassembler recognizes those bytes and reconstructs the same form
length returned to source navigation/stepper is correct
timing and taken timing are correct
memory-access and control-flow descriptors cover special behavior
```

For DD/FD-CB forms, pay particular attention to physical byte order. The table's
logical description and emitted order are not always visually obvious.

## Worked example: changing the source-record format

This is the kind of change that should never begin with a local patch.

Write down:

- new header bits;
- new terminal/back-link rule;
- old and new maximum lengths;
- symbol ordinal encoding;
- pseudo-opcode mapping;
- how old native SAVE files are recognized;
- how the editor moves backward;
- how FIND/REPLACE and compaction scan variable fields;
- how reverse disassembly creates the new form.

Then implement converters or deliberately declare incompatibility.

A record format is a language shared across time as well as across routines.

## Worked example: adding a LOW-byte resident address

Do not do this:

```asm
    defb residentRoutine & $FF
```

At origin zero the byte may look correct. After installing at `$8000`, the low
byte may or may not change depending on carry from the added base, and the
runtime has no entry telling it to adjust one byte.

Prefer a complete relocatable word and derive the needed byte at runtime, or
redesign the representation to be self-relative.

The generator's failure is not an inconvenience. It is proving that the
historical installer cannot support the new representation.

## The release gate as an executable explanation

The reconstruction's tests encode much of the architecture described in this
book.

They check that:

- metadata generation is deterministic;
- annotations still point to valid sites;
- no unsupported origin-dependent bytes exist;
- relocation matches independent nonzero-origin assemblies;
- full and assembler-only images install correctly;
- changed-length images produce valid TAP blocks;
- forward and backward overlapping copies work;
- execution reaches the editor loop at several destinations;
- deliberate monitor and assembler insertions regenerate all layout metadata;
- historical hashes remain exact when no machine-byte change was intended.

A test failure often identifies the contract that the modification crossed.
Read it as architectural evidence, not merely as an obstacle to making the
build green.

## Separate original runtime behavior from reconstruction tooling

PROMETHEUS itself does not know about:

- six artificial assembly origins;
- Python table generators;
- SHA-256 manifests;
- headless execution harnesses;
- variable-length TAP template replacement.

Those are modern tools surrounding the reconstructed source.

The runtime still consumes:

- the compact historical configuration delta stream;
- the compact historical relocation stream;
- ordinary Spectrum tape blocks;
- its original source, symbol and monitor formats.

Keep this distinction visible in comments and documentation. A build-time
improvement should not be described as though the 1980s program performed it on
the Spectrum.

Conversely, do not preserve manual fragility merely because it was historical.
Generating the same runtime bytes from semantic labels makes modification safer
without changing the original machine's behavior.

## A checklist before committing a machine-emitting change

```text
[ ] Is the change owned by an existing representation or subsystem?
[ ] Are new labels global or local for the correct reason?
[ ] Have all varc/opcode-shaped state consumers been traced?
[ ] Are source-record and symbol ordinal invariants preserved?
[ ] Are self-relative deltas and compact table ranges still valid?
[ ] Does assembler-only installation still contain all suffix dependencies?
[ ] Are internal addresses complete relocatable words?
[ ] Are configuration annotations ordered and unique?
[ ] Were generated metadata files reproduced freshly?
[ ] Were full and assembler-only layouts tested at several bases?
[ ] Were forward/backward overlapping copies exercised if layout changed?
[ ] Was the TAP rebuilt with current lengths and checksums?
[ ] Should historical binary/TAP hashes remain identical?
[ ] Has the new behavior been explained in source and book documentation?
```

## What changes in memory when the source is modified

The answer depends on the category:

- a comment or label change should alter no emitted byte;
- a moved routine shifts later payload offsets and relocation targets;
- a new configuration field changes the generated delta walk;
- a larger monitor moves the assembler-only boundary;
- a larger suffix changes payload and TAP lengths;
- a new source-record format changes every live and saved representation;
- a new table entry may change self-relative distances and decoder indexes.

The modification process must follow these ripples deliberately rather than
trying to hold old addresses in place.

## Important source and build anchors

- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `configurationPatchTarget...`
- `installerConfigurationPatchDeltas`
- relocation stream labels
- `varc...` writable operands and opcodes
- `sourceBufferStart`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `instructionTable.asm`
- `emitByteAtAssemblyOutput`
- generated metadata tools and installation execution harness

## Back to the whole machine

The resurrection has removed one old restriction: PROMETHEUS no longer has to
remain frozen at the addresses of the surviving binary merely because its
relocation and configuration tables were once precomputed.

It has not removed the need to understand the program's compact contracts.
Movement is safe because labels and generators now describe address-sensitive
meaning. Functional change is safe only when the same care is applied to source
records, ordinals, tables, stateful operands, stack layouts and shared pipelines.

The final main chapter will turn from rules to geography. It will walk through
`prometheus.asm` in physical order, showing where each subsystem lives and which
chapters explain it. That atlas will let a reader return from the book to the
source without losing the larger picture.
