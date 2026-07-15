# Appendix G: Historical Uncertainties and Confirmed Discrepancies

A reconstructed program invites two opposite mistakes.

The first is excessive caution: treating every clearly decoded instruction as if
nothing could be known. The second is excessive confidence: turning a plausible
interpretation into a historical fact merely because it fits the surrounding
code.

This appendix keeps those mistakes apart. It states what kind of evidence
supports each important claim and records places where the surviving program,
the surviving descriptions and modern reconstruction machinery do not say
exactly the same thing.

## G.1 Evidence classes used in this book

The following letters are used in the tables below.

| Mark | Evidence class | Meaning |
|---|---|---|
| **E** | execution-confirmed | The behavior was observed in an emulator or exercised by an automated execution scenario. |
| **S** | statically established | The instruction and data flow establish the behavior directly, even where no dedicated runtime test was needed. |
| **I** | inferred | The machine operations are known, but their historical purpose, intended interface or edge-case meaning is not completely proved. |
| **D** | discrepancy | Code and surviving documentation differ, or two parts of the implementation impose visibly different rules. |
| **R** | reconstruction-specific | The item belongs to the modern source resurrection, tests, labels, generators or book rather than to the historical running binary. |

These classes can overlap. A behavior may be both **S** and **D**: the code is
unambiguous, and it unambiguously differs from the manual. A generated table can
be **R**, while its emitted bytes are **E/S**-confirmed to equal the historical
table.

## G.2 What “historical” means here

The reconstructed source has several layers:

```text
historical machine-code bytes
        ↓ decoded into assembly
modern labels and comments
        ↓ augmented with annotations
modern generators, tests and reports
        ↓ explained by this book
```

Only the first layer ran on the original machine. A meaningful modern label such
as `acceptLoadedHeaderIfNameMatchesOrWildcard` describes a discovered role; it
is not evidence that the original author used that English name. Likewise,
`@config-patch` and `@noreloc` are modern source annotations that permit safe
generation and checking. The installer only sees the compact byte streams they
produce.

When this book says “PROMETHEUS does X,” it normally means the historical byte
sequence implements X. When it says “the reconstruction marks,” “the generator
checks,” or “the test proves,” it refers to a modern layer.

## G.3 Strongly confirmed reconstruction facts

Before listing uncertainty, it is useful to state what is not uncertain in the
v042 technical baseline.

| Mark | Fact | Basis |
|---|---|---|
| **E/S** | The assembled CODE payload is byte-for-byte equal to the preserved historical payload. | Mandatory assembly and binary-comparison checks. |
| **E/S** | The reconstructed TAP is byte-for-byte equal to the preserved historical TAP. | TAP block reconstruction, length/checksum validation and complete-file comparison. |
| **E** | The relocation-safe bootstrap finds its physical load address and reaches the installer in tested layouts. | Emulated startup scenarios. |
| **E** | Installer copying works for the historical layout, a non-overlapping forward copy and an overlapping backward copy. | Emulated startup scenarios specifically covering all three directions/layout relations. |
| **S/R** | The generated fourteen-target configuration stream equals the historical stream. | Label-driven generation followed by exact byte comparison. |
| **S/R** | The generated 1,293-word relocation metadata equals the historical stream. | Multi-origin analysis, explicit exclusions and exact comparison. |
| **S** | The optional monitor prefix is exactly 5,000 bytes and the assembler-only image is the suffix selected by skipping it. | Entry-label difference and installer `$1388` adjustment. |
| **S** | The resident instruction table contains 687 fixed five-byte records. | Build constant, emitted include size and all consumers' fixed record stride. |

Byte identity proves preservation of the historical program. It does not prove
that every historical behavior was sensible or that every manual sentence was
accurate.

## G.4 Dynamic flow comments are evidence, not a complete call graph

Older disassembly stages contained comments such as:

```text
flow from: ...
ghost flow from: ...
```

These came from emulator execution traces. They show that a test run reached a
location from the recorded origin. They do **not** mean:

- that the origin is the only possible caller;
- that an unrecorded path cannot occur;
- that a table-dispatched or self-modified call was statically impossible;
- that every conditional path was exercised.

The modern source removes much of this noisy address/byte tail from inline
comments, but the evidential meaning remains important. Appendix F therefore
uses static direct references for its compact caller column and explicitly does
not claim an exhaustive dynamic call graph.

**Classification: E/R.** The traces are real observed evidence collected during
the resurrection, but they are not part of the historical binary and not a
complete behavioral proof.

## G.5 Filename wildcard behavior

The surviving description says that a filename made entirely of spaces selects
wildcard LOAD behavior. The implementation performs a stranger test.

The routine loads the **first requested filename character**, compares it with a
space, and repeats that same unchanged test ten times. It does not advance
through ten filename characters.

Therefore:

```text
first filename character is space     wildcard
first filename character is not space exact ten-byte comparison
```

A name beginning with a space is accepted as wildcard even if later positions
contain non-space bytes. A name containing spaces only after a non-space first
character is not wildcard.

The repetition strongly suggests an intended ten-character loop whose pointer
increment was omitted or lost, but that historical intention cannot be proved
from the bytes alone. The resurrection preserves the actual first-character
rule rather than silently correcting it.

**Classification: S/D; intended cause I.**

## G.6 EQU is evaluated in pass one, not pass two

One surviving explanation places `EQU` evaluation in pass two. The assembler
code establishes the opposite:

- pass one remembers the current line's label entry;
- the EQU case evaluates its expression and writes the value then;
- pass two recognizes EQU and returns without assigning it again.

This has a practical consequence. An EQU expression can use symbols already
defined earlier in pass one or retained as locked symbols. A forward symbol that
is still undefined follows the normal Unknown-error path. There is no pass-two
opportunity to resolve it later.

This is not merely an implementation detail. It changes which source programs
are accepted.

**Classification: S/D.**

## G.7 RUN protection occurs after the instruction has executed

The monitor's traced stepping path is often described as refusing to execute an
instruction whose resulting PC lies in a RUN-protected area. The actual order is:

```text
prepare scratch instruction
restore user state
execute instruction
capture resulting state
check resulting PC against RUN ranges
commit or reject PC and timing
```

If the resulting address is protected, PROMETHEUS reports Run ERROR and does not
commit the new monitor PC or selected T-state count. However, the instruction has
already run. Memory writes, stack changes and captured-register side effects may
already exist.

The distinction matters for code such as:

```asm
LD (dangerousAddress),A
JP protectedAddress
```

The jump destination may be rejected after capture, but the preceding operation
of the traced instruction—where a single instruction itself performs a write or
stack change—cannot be undone by merely refusing the final PC.

The resurrection documents this weaker ordering and keeps it byte-identical.
Changing it would be a functional redesign of the monitor.

**Classification: S/D.**

## G.8 Native execution bypasses traced protection

Several monitor commands deliberately leave the instruction-by-instruction
engine:

- persistent/temporary breakpoint runs;
- native CALL through `SS+H`;
- CALL/RST targets executed directly in DEF or ALL mode.

During native execution:

- custom READ windows are not checked for each load;
- custom WRITE windows are not checked for each store;
- custom RUN windows are not checked for each instruction target;
- monitor T-state accounting does not describe the interior of the native call;
- instruction-control emulation cannot repair or reject each internal step.

The resident-output check is used while installing the three-byte breakpoint,
but that one check is not equivalent to tracing the program that follows.

This is best understood as an intentional speed/compatibility escape, not as a
single universal monitor security model. NON mode keeps calls under monitored
simulation. DEF and ALL trade supervision for direct execution.

**Classification: S; difference from a universal-protection interpretation D.**

## G.9 A breakpoint may remain installed forever

The temporary breakpoint mechanism saves exactly three bytes, writes:

```asm
JP breakpointHitCaptureEntry
```

and starts native execution. The original bytes are restored only after the
program reaches that patch and returns through the expected capture path.

If the program:

- loops elsewhere;
- crashes;
- jumps into ROM/BASIC and never returns;
- overwrites the patch;
- reaches the patch with an unusable stack;

then PROMETHEUS has no asynchronous supervisor that can regain control and
restore the bytes. The displaced bytes remain only in the single save slot.

The patch is also always three bytes and need not align with an instruction
boundary. That is safe only when the user selects a suitable breakpoint address.

**Classification: S.** This is a limitation, not a reconstruction defect.

## G.10 Breakpoint restoration bypasses the installer check used to place it

Installing a breakpoint uses the assembler's protected byte emitter. Restoring
it uses a raw three-byte `LDIR`.

That asymmetry is reasonable in the expected path: the monitor is putting back
bytes it just removed. It nevertheless means restoration is not revalidated
against current U-TOP or resident boundaries. If the memory arrangement or
saved patch address were corrupted during native execution, the restoration
copy would trust them.

**Classification: S; risk interpretation I.**

## G.11 RETN and RETI are only partly modeled with confidence

The monitor recognizes RET, RETN and RETI-style control flow and can obtain the
stacked return target. It also advances the saved user SP by two after simulated
return. The control-flow destination and stack consumption are therefore
explicit.

The uncertain part is exact interrupt-state semantics in every edge case.
`RETN` has a defined relationship between IFF2 and IFF1; `RETI` also has hardware
and peripheral significance beyond “pop a PC.” PROMETHEUS reconstructs interrupt
enable state from the captured flags and its saved state machinery, but the
surviving path does not permit every subtle RETN/RETI distinction to be proved
as a faithful model of all Z80 and peripheral situations.

The safe claim is:

```text
confirmed: stacked target and saved-SP advancement
strongly indicated: common return-style trampoline handling
not fully proved: every IFF1/IFF2 and RETI peripheral-observation edge case
```

This is why the book describes RETN/RETI handling conservatively rather than
claiming a complete hardware debugger model.

**Classification: S for target/SP; I for full interrupt semantics.**

## G.12 HALT with interrupts disabled is special even when controls are off

The instruction-controls toggle is stored inversely:

```text
zero       READ/WRITE/RUN controls on
nonzero    those configurable controls off
```

The HALT-with-interrupts-disabled rejection lies outside that toggle. Turning
controls off therefore does not mean “execute absolutely anything.” The monitor
still avoids a scratch HALT that could stop forever with no interrupt able to
release it.

A simple status wording such as “controls off” can obscure this exception.

**Classification: S.**

## G.13 MOVE, FILL, LOAD, SAVE and list commands do not share one protection law

It is tempting to imagine the five READ/WRITE/RUN windows as a global memory
firewall. They are not.

| Operation | Protection actually used |
|---|---|
| traced user instruction | configurable READ, WRITE and resulting RUN checks, unless controls are off |
| monitor MOVE | resident/source destination check; no custom WRITE-window check |
| monitor FILL | resident/source destination check; no custom WRITE-window check |
| monitor J load | reversed/wrap and resident/source destination check; no custom WRITE-window check |
| monitor S save | no resident check and no custom READ-window check |
| memory list L | direct reads; no configurable READ-window check |
| character list O | direct reads; no configurable READ-window check |
| masked FIND G/N | direct reads; no configurable READ-window check |
| native breakpoint/CALL | no per-instruction custom READ/WRITE/RUN checks |

The differences may represent a deliberate separation between “untrusted code
being traced” and “trusted commands explicitly requested by the operator.” They
may also reflect organic development. What can be stated firmly is that there is
no single enforcement gate covering all memory operations.

**Classification: S; overall design intention I.**

## G.14 Monitor SAVE accepts reversed and wrapping ranges

The S command calculates:

```text
length = Last - First + 1      modulo 65536
```

It does not reject `Last < First`, does not consult resident protection and does
not prevent a zero result after wrap. The resulting 16-bit length is passed into
the tape path.

J, MOVE and FILL perform stronger destination/range checks, so SAVE's behavior is
not a reusable statement about all block commands.

This may have been accepted because SAVE only reads memory, or because the ROM
routine was expected to define the edge behavior. The code itself does not say
which justification the author intended.

**Classification: S; rationale I.**

## G.15 Monitor J has no meaningful filename mode

The common monitor value prompt can return either:

- an evaluated numeric expression; or
- a colon-prefixed string form.

S interprets the colon form as a filename and builds a standard CODE header. J
does not. Its handler treats the resulting low byte as the expected leader. A
later quick reference that implies a symmetric filename LOAD mode therefore
describes a facility the J path does not implement.

For J, use a numeric leader. For a header-guided load, use Y and then press J
after the displayed header.

**Classification: S/D.**

## G.16 Y accepts any valid standard header before offering J

Y reads a header-sized block with expected flag `$00`. When that physical block
is a valid Spectrum header, the monitor displays its fields. Pressing J then
uses:

```text
First  = header parameter 1
Length = header data length
Leader = $FF
```

The follow-up path does not first require the header's type byte to mean CODE.
It applies a CODE-like interpretation to any valid standard header. For a BASIC,
number-array or character-array header, parameter 1 has a different documented
meaning, yet PROMETHEUS can still treat it as a destination address.

The interface is therefore a low-level header inspector with an optional raw
follow-up, not a type-safe Spectrum file loader.

**Classification: S; user-interface expectation discrepancy D.**

## G.17 Reverse disassembly leaves numeric-address display changed

`SS+D` selects the source-insertion sink and disables numeric address prefixes so
generated source does not begin with monitor addresses. The command does not
restore that flag afterward. Subsequent interactive disassembly begins with
numeric addresses hidden until the user toggles them again with C.

This is a small persistent side effect that might be mistaken for a modern
reconstruction bug. It is in the historical byte flow.

**Classification: S.**

## G.18 DEFB and DEFW display ranges classify only the starting address

Disassembly table 1 and table 2 mark regions to present as byte or word data. The
classification test uses the current item's starting address. It does not split
a multi-byte decoded unit when a range boundary falls inside it.

For example, a DEFW-classified address at the final byte of a region can cause a
two-byte word display whose second byte lies outside the nominal range. Likewise,
an instruction beginning outside a data range is not retroactively split because
an operand byte lies inside it.

This keeps the decoder simple and deterministic. The range table should be
aligned to intended item boundaries.

**Classification: S.**

## G.19 The masked memory search has no end and wraps at `$FFFF`

G stores five value/mask pairs. N continues from the saved scan address. The
candidate pointer is 16-bit and simply increments. There is no Last prompt and
no “searched entire memory” state.

Consequences:

- a scan can cross from `$FFFF` to `$0000`;
- a five-byte comparison near the top can itself wrap;
- an absent pattern produces an indefinitely continuing search rather than a
  finite not-found result;
- repeated N can rediscover a pattern after a full address-space cycle.

This is an exact result of the compact loop, not a promise that wraparound was a
deliberately advertised feature.

**Classification: S; intention I.**

## G.20 GENS end scanning can wrap when U-TOP is `$FFFF`

The GENS/MASM importer locates the foreign source's terminating boundary by
scanning memory. The manual itself warns that with U-TOP set to `$FFFF`, the scan
may wrap around the 16-bit address space when the expected end condition is not
found.

This is one reason the apparently convenient `U-TOP -1` must be used carefully.
It removes the natural finite upper boundary that would otherwise stop several
memory-growth or scan operations.

**Classification: S/D only where a user expects `$FFFF` to be a universally safe
“all memory” setting.**

## G.21 LOAD and GENS are not transactional

A modern importer might first validate an entire file, then commit it in one
atomic operation. PROMETHEUS works in a small memory budget and transforms data
as it arrives.

The native LOAD path can already have accepted and staged part of a source/symbol
transfer before a later tape error. GENS expands and inserts lines progressively.
A syntax, capacity, tape or end-boundary failure can therefore leave earlier
material present.

The program provides recovery and error messages, but not rollback to an exact
pre-command memory image.

**Classification: S.**

## G.22 VERIFY depends on SAVE's retained state

VERIFY does not reconstruct all tape parameters from a fresh command line. It
reuses filename, source length and auxiliary-segment state established by the
preceding SAVE path.

This makes `SAVE` followed immediately by `VERIFY` the intended pair. Intervening
operations that repurpose the relevant self-modified operands can make a later
VERIFY describe something other than the user expects.

The interface is compact and historically reasonable, but it is more stateful
than the word VERIFY alone suggests.

**Classification: S.**

## G.23 DEFS accepts the common parsed list shape

Documentation commonly describes DEFS with one size expression. The code reaches
it through the shared pseudo-instruction data-list machinery. The accepted
encoded shape can therefore process the list structure used by the parser rather
than enforcing a unique one-expression grammar at a separate front gate.

The safe user-facing form remains:

```asm
DEFS size
```

More exotic comma-separated use should be treated as implementation behavior,
not a portable source-language guarantee.

**Classification: S for implementation; historical language intention I.**

## G.24 DEFM's quote forms are asymmetric

The two quote delimiters are not interchangeable decoration.

- double quotes emit ordinary character bytes;
- the apostrophe form sets bit 7 on the final emitted character.

This is useful for PROMETHEUS-style high-bit strings but surprising to a reader
who expects both delimiters to create the same literal. The parser also has
historical doubled-delimiter behavior that belongs to this compact assembler,
not to a general modern string standard.

**Classification: S.**

## G.25 Installer address validation is minimal

The installer limits the visible field to five decimal digits and prevents the
cursor crossing its delimiters. On ENTER it parses those digits, selects the full
or suffix image, chooses copy direction, patches configuration values, applies
relocation and transfers control.

It does not perform a comprehensive modern preflight proving that:

- the selected image fits entirely in safe RAM;
- the destination does not overwrite screen, system variables or a required
  stack at the wrong time;
- the final source/symbol workspace will have a useful size;
- every user-selected address is operationally sensible.

The copy engine itself handles overlap correctly, including backward copying.
That is different from validating the wisdom of the requested destination.

**Classification: S; historical user-responsibility model I.**

## G.26 Historical aliases are not proof of public commands

The command vectors contain duplicate targets:

- G, I and J slots associated with GENS/import;
- N and O slots associated with NEW;
- X and Y slots associated with CLEAR;
- duplicate name-vector destinations for some command words.

The table identity is certain. It does not prove that every alias was reachable
through normal tokenization, printed in every manual, or intended as a separate
public feature. Some may be compatibility remains, keyboard-layout conveniences,
unused ordinal slots or historical edits.

Appendix E records them as aliases while reserving the documented command name
for normal use.

**Classification: S for table identity; I for public reachability/intention.**

## G.27 Opaque bytes in the internal stack area

A small region backing the internal stack contains historical nonzero bytes that
look like old stack material, data or unused residue. They are preserved because
byte identity requires them and because the live stack can overwrite the area at
runtime.

No confident semantic structure should be invented for those bytes merely
because every byte in a binary feels as if it ought to have a named purpose.
Their established role is:

```text
initial contents of storage later available to the internal stack
```

Anything more specific is provisional unless execution or another surviving
source proves it.

**Classification: S for location/preservation; I for original contents' meaning.**

## G.28 Original tables versus modern generators

The historical program contains compact runtime tables:

- configuration-patch deltas;
- relocation streams;
- instruction descriptors;
- command and text vectors.

The resurrection adds build-time generators for the first two difficult classes.
This changes source ownership, not runtime representation.

### Historical runtime mechanism

The installer walks small deltas and relocation counts. It has no symbol names,
JSON, Python objects or linker map. It performs the same compact arithmetic that
ran historically.

### Modern generation mechanism

The source marks semantic targets and exclusions. A generator assembles/link
probes at more than one origin, determines which words truly move with the
resident image, creates the historical compact stream and rejects ambiguous or
unsafe cases.

### Equality requirement

For the v042 baseline, generated bytes are compared with the preserved historical
bytes. A generator is not allowed to produce a merely equivalent but differently
encoded stream while the release claims historical identity.

Thus:

```text
generator and annotations      reconstruction-specific
compact bytes in final image   historical and byte-identical
installer decoder              historical
```

**Classification: R for production method; E/S for byte equality and runtime use.**

## G.29 Configuration patch labels are modern names for historical destinations

Labels such as `configurationPatchTarget05...` make fourteen scattered write
destinations explicit. The historical installer already visited those bytes by
walking a signed-delta stream. The labels did not add a new patch; they gave a
stable semantic name to an old one.

A similar distinction applies to relocation exceptions. `@noreloc` records why a
word that looks address-like must not move. The original binary expressed that
fact only by omitting the word from the relocation stream.

**Classification: R for annotation; S for underlying historical behavior.**

## G.30 Multi-origin relocation analysis is a proof technique, not a historical tool

A single assembled image cannot always reveal whether a word is:

- a relocatable resident address;
- a Spectrum ROM address;
- a screen address;
- a constant whose numeric value happens to resemble an address;
- an origin-zero offset intentionally interpreted later.

The modern generator links or analyzes the payload at multiple origins and
compares candidate words. Words that move by exactly the origin delta are strong
relocation candidates; explicit semantic exclusions resolve the remaining
ambiguous cases.

The 1990 program did not perform this experiment on the Spectrum. This is a
clean-room verification method used to rediscover and protect its relocation
set.

**Classification: R.**

## G.31 Emulated startup scenarios are modern tests

The historical TAP contains one normal installation experience. The resurrection
also exercises artificial layouts chosen to force:

- no harmful overlap;
- forward copying;
- backward copying.

These scenarios validate branches that might not be reached by the most common
load address. They do not imply that those exact synthetic layouts were shipped
as separate historical products.

**Classification: R for scenarios; E for the code paths they execute.**

## G.32 Source labels, local-label grouping and prose are interpretations

The reconstruction replaced address-shaped labels with names such as
`moveMemoryBlockOverlapSafe` and converted suitable private jump targets to
 dot-prefixed local labels. These changes preserve bytes but add an explanatory
model.

A good label is a falsifiable claim: callers, inputs, outputs and side effects
should support it. It is still not an original identifier. Future evidence can
justify renaming a routine without changing the historical program.

The same caution applies to chapter boundaries. PROMETHEUS does not contain a
runtime object called “the editor pipeline” or “the source atlas.” Those are
teaching structures imposed on interconnected assembly code.

**Classification: R.**

## G.33 Comments named “flow from” are not missing source references

Because flow comments record observed emulator arrivals, removing their noisy
inline form does not erase executable edges. Static labels, operand references,
dispatch tables and tests remain. Conversely, retaining one does not promote it
to a complete list of callers.

When Appendix F names “principal callers or consumers,” it uses direct static
references and groups local flow beneath a global routine. This is a different
instrument from the historical trace comments.

**Classification: R methodological note.**

## G.34 Manual translation and terminology

Surviving documentation may exist in Czech, English translation or later quick
reference form. Several terms have more than one plausible English rendering:

- “installation” versus “relocation” for the user-selected resident address;
- “leader” versus “flag” for the first tape-block byte;
- “window,” “area” or “range” for protection intervals;
- “assembly” as command, process or generated product;
- “monitor” as both optional resident prefix and interactive tool.

This book chooses consistent technical English based on behavior. A wording
choice is not evidence that the original author used the same conceptual
boundary.

**Classification: I/R.**

## G.35 Apparent typographical and interface oddities preserved in the image

Several visible strings and conventions look unusual to a modern reader:

- `Instalation address:` contains the historical spelling;
- the installer title and copyright strings use compact high-bit termination;
- status names may be shortened to fit fixed panel cells;
- command aliases and duplicated vectors are retained;
- the filename wildcard loop repeats one byte ten times;
- initial stack backing contains opaque nonzero bytes.

The resurrection does not “clean” emitted text or unused-looking data when doing
so would change the historical payload. The book may spell the general English
word correctly while quoting the screen exactly where relevant.

**Classification: S for bytes; intention varies.**

## G.36 Bugs, quirks and deliberate economies

The word *bug* should be used carefully. Three useful categories are:

### Confirmed discrepancy

The implementation contradicts a stated rule or clearly fails to perform the
loop its structure announces. The filename wildcard and post-execution RUN check
belong here.

### Consistent but surprising implementation

The code behaves regularly, but not like a modern interface. Stateful VERIFY,
nontransactional import and the unbounded wrapping memory search belong here.

### Economy with a risk envelope

The behavior is a compact design that requires the operator to respect its
contract. Three-byte breakpoints, minimal installer validation, self-modified
operands and native ALL mode belong here.

Calling every surprising economy a bug hides the design constraints. Refusing to
name clear discrepancies hides equally important evidence.

## G.37 Summary ledger

| Subject | Class | Safe statement |
|---|---|---|
| historical binary/TAP identity | **E/S** | v042 reproduces the preserved payload and TAP exactly. |
| flow-from comments | **E/R** | observed test origins, not an exhaustive caller graph. |
| filename wildcard | **S/D** | blank first character is wildcard; all-ten-spaces test is not implemented. |
| EQU pass | **S/D** | EQU is assigned in pass one. |
| RUN protection order | **S/D** | resulting PC checked after execution/capture; side effects may remain. |
| native breakpoint/CALL modes | **S** | bypass per-instruction custom protections and timing. |
| unreached breakpoint | **S** | original three bytes are not automatically restored. |
| RETN/RETI | **S/I** | target and SP repair are clear; complete interrupt/peripheral fidelity is not fully proved. |
| controls OFF | **S** | configurable READ/WRITE/RUN checks off; DI+HALT hazard still rejected. |
| MOVE/FILL/J versus WRITE windows | **S** | use resident destination checks, not custom WRITE ranges. |
| L/O/G versus READ windows | **S** | direct inspection reads bypass custom READ ranges. |
| monitor SAVE range | **S** | reversed/wrapped ranges are passed through modulo-16-bit length arithmetic. |
| J filename form | **S/D** | no meaningful filename branch; numeric leader only. |
| Y header follow-up | **S** | any valid header can be interpreted through parameter 1 and length. |
| reverse disassembly display flag | **S** | numeric-address suppression persists afterward. |
| data display ranges | **S** | classification uses the starting address only. |
| masked search | **S/I** | no terminal address; scan and comparison can wrap. |
| GENS with U-TOP `$FFFF` | **S** | end scan can wrap when terminator/boundary is not found. |
| LOAD/GENS rollback | **S** | partial committed import may remain after failure. |
| VERIFY | **S** | depends on retained SAVE state. |
| DEFS list form | **S/I** | common parser shape is accepted; one-expression use is the portable form. |
| installer validation | **S/I** | field is constrained, destination safety is largely the user's responsibility. |
| duplicated command slots | **S/I** | identical table targets do not prove every alias was public. |
| generated patch/relocation tables | **R + E/S** | modern production, historical byte stream and historical runtime decoder. |
| labels and prose structure | **R** | modern explanatory names, not recovered original identifiers. |

## G.38 Rule for future revisions

When new evidence appears, update the classification before strengthening the
prose.

```text
new emulator observation        may promote I to E for that tested path
new static proof                may promote I to S
new manual page                 may reveal or create a D
new build generator             remains R even if output is historical
new label or chapter wording    remains R unless historical source proves it
```

The goal is not to keep the book hesitant. It is to be exact about where its
confidence comes from. PROMETHEUS is impressive enough without turning every
reasonable inference into legend.
