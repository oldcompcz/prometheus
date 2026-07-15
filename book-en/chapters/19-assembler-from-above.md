# Chapter 19: The Assembler from Above

The editor is now behind us.

That does not mean it has disappeared. The assembler depends on nearly every
editor idea we have learned:

- source is still a chain of compressed records;
- labels and expression names are still symbol ordinals rather than repeated
  text;
- the active line is still used when an error must be shown;
- block boundaries can still limit an operation;
- the moving end of source and symbols still decides where free memory begins.

But the question has changed.

The editor asks:

> How can a person enter, store and change assembly-language source?

The assembler asks:

> What bytes does that source mean, and where should those bytes be placed?

This chapter gives the first top-down view of the answer. We will deliberately
leave several difficult mechanisms unopened. Expressions receive their own
chapter. Symbols receive two. Instruction emission receives another. For now,
we want to see the shape of an assembly from the moment the user chooses
`ASSEMBLY` until the editor announces that the job is complete.

## The visible operation is almost suspiciously simple

The command handler is tiny:

```asm
invokeAssembly:
    call processCompilation
    ld a,MESSAGE_ASSEMBLY_COMPLETE
    jp prometheusWarmStartWithMessage
```

There is no special display mode, no progress counter and no printed listing.
If `processCompilation` returns normally, PROMETHEUS selects the status text
`Assembly complete` and re-enters the editor.

If an error occurs, normal return never happens. The common error machinery
uses the source-record pointer saved by the assembly controller, makes that
record active, displays the appropriate message and returns the user to the
line that caused trouble.

From the keyboard, assembly therefore looks like one indivisible action:

```text
enter ASSEMBLY
    → a short pause
    → either an error at one source line
      or “Assembly complete”
```

Inside the program, however, the source is walked twice.

## Why there are two passes

Consider this small program:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

The instruction `DJNZ LOOP` contains a relative displacement. To encode it, the
assembler must know the address of `LOOP` and the address immediately after the
`DJNZ` instruction.

In this example the label appears before the reference, so a simple
one-directional assembler could cope. But real programs contain forward
references:

```asm
        JR Z,FINISHED
        ; many instructions
FINISHED RET
```

When the assembler reaches `JR Z,FINISHED`, the address of `FINISHED` is not yet
known. There are several possible designs:

1. reject forward references;
2. remember every unfinished patch and return to it later;
3. scan the source once to discover addresses, then scan it again to emit bytes.

PROMETHEUS chooses the third design.

The two passes have different jobs.

### Pass one: discover the shape

The first pass follows source records in order and works out:

- the address belonging to each line label;
- the value of `EQU` symbols that can be resolved;
- how far each machine instruction advances the logical address;
- how `ORG`, `PUT` and reserved storage affect the counters;
- whether definitions are duplicated or otherwise invalid.

It does not need to place the final opcode bytes in their destination.

### Pass two: produce the result

The second pass repeats the same source walk. This time labels established by
pass one can be used in expressions. The assembler:

- writes instruction prefixes and opcodes;
- writes immediate bytes and words;
- calculates relative branch displacements;
- emits `DEFB`, `DEFM` and `DEFW` data;
- applies `ORG`, `PUT` and `DEFS` pointer changes;
- records the `ENT` address used by RUN.

In plain pseudocode:

```text
clear ordinary symbol definitions

pass = 1
address = defaultStart
for each selected source record:
    discover definitions and record length

pass = 2
address = defaultStart
output = defaultStart
for each selected source record:
    evaluate final operands and emit bytes
```

The important phrase is **the same source walk**. PROMETHEUS does not have two
large, mostly duplicated compilation loops. It has one controller whose
per-record action is replaced between scans.

## The controller is a small machine of its own

The main routine is `processCompilation`.

Its source begins by deciding whether the whole source or only the selected
block should be assembled:

```asm
processCompilation:
    call containsInputBufferCharacterB
    ld a,000h
    jr z,.storeCompilationScope
    inc a
.storeCompilationScope:
    ld (varcCompileWholeSource+1),a
```

The optional command parameter `B` means block-only assembly. The stored flag
is slightly counter-intuitive:

```text
0  assemble only the selected block
1  assemble the whole source
```

This inversion is not a deep language feature. It merely lets a later `OR A`
and conditional jump choose the common whole-source path cheaply.

Before pass one, the assembler clears the `DEFINED` state of ordinary symbols:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

The value `$B6` is itself an encoded instruction, `RES 6,(HL)`, supplied to a
shared symbol-vector modifier. Locked symbols retain their separate lock state
and can continue to represent definitions supplied by an already assembled
lower layer. We will examine that compact symbol machinery in Chapters 23 and
24.

For the moment, the effect is:

```text
ordinary definitions from the previous assembly are forgotten
locked external definitions remain available
```

This matters because a fresh first pass must not accidentally believe that a
label is already defined merely because an earlier assembly left a value in its
symbol entry.

## One loop, two personalities

The controller initializes a self-modified `CALL` with the first-pass routine:

```asm
    ld a,001h
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Later in the source we find the call itself:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

The visible operand `firstPassProcessSourceRecord` is only the initial value.
After pass one, the program writes the address of
`secondPassEmitSourceRecord` into the two operand bytes following the `CALL`
opcode.

The scan loop therefore behaves like this:

```text
handler = firstPassProcessSourceRecord
scan source

handler = secondPassEmitSourceRecord
scan source again
```

A modern language might store a function pointer in a variable. PROMETHEUS
stores the function pointer directly inside the instruction that will call it.
We met this style in Chapter 5. Here it becomes an architectural device: one
compact loop performs both passes.

## Where generated code begins by default

At the beginning of each pass, the controller reads the current end of the
packed source and symbol region:

```asm
.initializeAssemblyPass:
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
    ld hl,sourceBufferAccessLine
```

One byte beyond `varcCodeEndPt` becomes both:

- the initial **logical address counter**;
- the initial **physical output pointer**.

This default is useful. If a program contains no `ORG` or `PUT`, assembled code
is placed immediately after PROMETHEUS's current source and symbol storage.

The two pointers begin equal, but they are conceptually different.

### The logical address counter

`varcAddressCounter` answers questions such as:

- What value should this label receive?
- What does the expression atom `$` mean here?
- How far is the target of a relative jump from the next instruction?
- What address follows this instruction or reserved area?

It describes the address **the generated program believes it occupies**.

### The physical output pointer

`varcAssemblyOutputPointer` answers:

- At which Spectrum RAM address should the next byte actually be written?

Usually both pointers move together. `ORG` changes both. `PUT` exists precisely
so the physical destination can differ from the logical address. `DEFS` can
advance address space without writing bytes.

This separation is one of the most important ideas in the assembler. It lets
PROMETHEUS describe code intended for one address while controlling where bytes
are deposited.

A useful mental picture is:

```text
logical address counter  → the address printed on the plan
physical output pointer  → the place where the builder lays the brick
```

Most of the time the plan and the building site agree. The assembler still
keeps them separate because some source directives need them not to.

## Walking records without losing the next one

The controller begins at `sourceBufferAccessLine` and repeatedly compares the
current record address with the dynamic source end:

```asm
.processNextAssemblyRecord:
    call comparePositionWithCodeEnd
    jr nc,varcAssemblyPassTransitionCounter
```

Before processing the current record, it finds and saves the successor:

```asm
    ld (reportAssemblyErrorAtSourceRecord+1),hl
    push hl
    call getNextSourceRecord
    ld (varcNextAssemblyRecordPointer+1),hl
    pop ix
```

The current record is placed in `IX`, while the successor is written into the
operand of this instruction:

```asm
varcNextAssemblyRecordPointer:
    ld hl,00000h
```

Why calculate the successor first?

The per-record handlers are substantial. They evaluate expressions, search
symbols, inspect instruction records and use `HL` for many temporary purposes.
It would be awkward to demand that every handler preserve the record pointer
and then rediscover the next variable-length record.

Instead, the controller says:

```text
before handing the record to a complicated routine,
remember exactly where the following record begins
```

After the handler returns, one patched `LD HL,nn` restores the successor and the
loop continues.

The same pattern also makes error reporting reliable. The instruction operand
at `reportAssemblyErrorAtSourceRecord+1` remembers the exact record being
processed. If any deeper routine signals an error, PROMETHEUS can return the
editor to that line even though the working registers have long since changed
meaning.

## Whole source or selected block

After preparing `IX`, the loop applies its scope rule:

```asm
varcCompileWholeSource:
    ld a,000h
    or a
    jr nz,varcAssemblyPassHandlerCall
    call testSourceRecordOutsideSelectedBlock
    jr c,varcNextAssemblyRecordPointer
```

Whole-source mode proceeds directly to the patched call.

Block mode asks whether the current record lies outside the inclusive selected
range. Outside records are skipped. Inside records are processed in both
passes.

This means block assembly is not a different assembler. It is a filter placed
around the ordinary record handler:

```text
for each source record:
    if wholeSource or recordInsideSelectedBlock:
        process record
```

The selected block must therefore be meaningful as a unit. Labels outside it
are not freshly defined during the block's pass one unless they remain locked
from an earlier layer. This is why locked symbols matter for separately
assembled sections.

## The pass transition counter

When the source scan reaches its end, control arrives here:

```asm
varcAssemblyPassTransitionCounter:
    ld a,000h
    dec a
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
    jr z,.initializeAssemblyPass
    ret
```

At the start of compilation, the immediate operand has been patched to `1`.

After the first scan:

```text
1 - 1 = 0
```

Zero is stored back. The handler is changed to the second-pass routine, and
`JR Z` restarts from the beginning.

After the second scan:

```text
0 - 1 = 255
```

The result is not zero, so the routine returns.

The counter is therefore both state and control:

```text
1  first pass still ahead
0  second pass still ahead
255 both passes complete
```

No separate “which pass am I in?” branch is required inside the scan loop.

## What a per-record handler sees

For either pass, `IX` points at the two-byte compressed source header.

The handler can learn from that header:

- whether the record is empty, a comment, a pseudo-operation or a machine
  instruction;
- whether a line label is present;
- which prefix family belongs to the instruction;
- which operand forms follow;
- how much the logical address should advance.

This is why the expensive text recognition was performed when the line was
entered. Assembly does not repeatedly compare the letters `L`, `D`, `B` and
`,` against language tables. It begins with a semantic source record already
containing an instruction-table choice and compact expression data.

The overall route is:

```text
editable text                    done when line was entered
    ↓
compressed semantic record       persistent source
    ↓
pass-one handler                 addresses and definitions
    ↓
pass-two handler                 final values and emitted bytes
```

The editor and assembler are not two programs connected by a text file. The
editor stores a form deliberately prepared for the assembler.

## Machine instructions and pseudo-instructions

Each record falls into one of two broad families.

### Machine instructions

Examples are:

```asm
LD B,5
DJNZ LOOP
RET
```

Their compressed headers refer to one of the 687 five-byte records in
`instructionsTable`. That record carries enough metadata for PROMETHEUS to
know:

- the base opcode;
- prefix family;
- mnemonic identity;
- operand classes;
- instruction length and timing information.

Pass one uses the length information. Pass two emits prefixes, opcode and
encoded operand values.

### Pseudo-instructions

Examples are:

```asm
ORG 32768
ENT START
DEFB 1,2,3
DEFM "HELLO"
DEFS 20
DEFW TABLE
```

They do not name Z80 instructions, but they are stored in the same source chain
with small pseudo-opcode numbers. Their pass behavior is selected by compact
branches rather than by the machine-instruction table.

For example:

- `EQU` assigns a value during pass one;
- `ENT` records the RUN target during pass two;
- `ORG` changes logical and physical pointers;
- `DEFB` emits checked bytes;
- `DEFS` advances pointers without writing a block of bytes.

The full details belong to Chapter 27. At this stage, it is enough to see that
the two-pass controller treats every line as a record and lets the selected
handler decide what that kind of record means.

## Errors unwind to the right line

Assembly routines are deeply nested. A bad expression can be discovered inside
an evaluator called by an operand emitter called by a record handler called by
the pass controller.

PROMETHEUS does not require every level to return a carefully layered error
object. Its common error path resets the stack to a known state and uses the
self-modified current-record address prepared by the controller.

Conceptually:

```text
before record:
    errorRecord = currentRecord

while processing:
    if anything fails:
        discard nested work
        activeRecord = errorRecord
        display error message
        return to editor
```

This style is severe but appropriate for a small interactive tool. An assembly
error is not recoverable inside the current pass. The useful recovery is to put
the programmer back at the offending source line with the program and editor
still intact.

## The one-line monitor assembler uses the same engine

The monitor contains an editor for assembling one instruction directly at the
current monitor address. It does not contain a second tiny assembler.

Its route is essentially:

```asm
call firstPassProcessSourceRecord
call initializeMonitorLineAssembler
call secondPassEmitSourceRecord
```

A temporary source record is prepared through the ordinary parser. The monitor
then applies the same pass-one and pass-two handlers to that one record, with
its logical address and physical output pointer initialized to the selected
memory location.

This reuse is valuable for two reasons:

1. the monitor accepts the same instruction language as the main editor;
2. fixes to expression handling and byte emission apply to both paths.

The large whole-source controller is not needed for one line, but the semantic
workers are shared.

## The complete assembly journey

We can now follow our example at the correct level of detail.

### 1. The user enters `ASSEMBLY`

The command dispatcher calls `invokeAssembly`, which calls
`processCompilation`.

### 2. Scope and symbols are prepared

PROMETHEUS decides between whole-source and block mode. Ordinary symbol
`DEFINED` bits are cleared; locked definitions survive.

### 3. Pass one begins

Both counters start one byte after current source/symbol storage. The active
source chain is scanned from `sourceBufferAccessLine`.

For the example:

```text
ORG 32768      set the logical and physical positions
START LD B,5   define START = 32768; advance by 2
LOOP DJNZ LOOP define LOOP = 32770; advance by 2
RET            advance by 1
ENT START      no machine-code length
```

By the end of pass one, the assembler knows the relevant addresses.

### 4. The controller changes personality

The patched handler becomes `secondPassEmitSourceRecord`, counters are
reinitialized and the source scan restarts.

### 5. Pass two emits

The assembler evaluates each final operand and produces bytes:

```text
32768: 06 05       LD B,5
32770: 10 FE       DJNZ LOOP
32772: C9          RET
```

`ENT START` stores 32768 as the entry address used by RUN.

### 6. Success returns to the editor

The controller's pass counter underflows, `processCompilation` returns and the
status bar reports `Assembly complete`.

Nothing in this journey required reparsing visible source text. Nothing required
building a separate intermediate file. The compressed source chain itself was
the assembler's input language.

## Why the design is effective

The design has several strong qualities.

### The source is understood once

Mnemonic and operand recognition happen when a line is accepted. Repeated
assemblies reuse semantic records.

### The pass controller is small

One traversal loop serves both passes through a patched handler.

### Memory roles are explicit

Logical address and physical destination can agree normally but diverge when
source directives require it.

### Errors remain interactive

The current record is remembered before deep processing begins, so the editor
can return to the exact source line.

### Main editor and monitor share workers

One-line assembly reuses the ordinary parser and pass handlers instead of
maintaining a second language implementation.

The price is that important state lives in instruction operands and compact
record fields. A reader must learn where those hidden variables are. But that
is now familiar territory.

## In plain pseudocode

Here is the controller without Z80 details:

```text
function assemble(scope):
    wholeSource = scope is not BLOCK
    clearDefinedFlagOnUnlockedSymbols()

    handler = firstPass
    transitions = 1

    repeat:
        logicalAddress = codeEnd + 1
        outputPointer = codeEnd + 1
        record = firstEditableSourceRecord

        while record is before sourceEnd:
            errorRecord = record
            nextRecord = successor(record)

            if wholeSource or record is inside selectedBlock:
                handler(record)

            record = nextRecord

        transitions = transitions - 1
        handler = secondPass

    until transitions is not zero
```

The curious final condition mirrors the original `1 → 0 → 255` transition.

## What has changed in memory

After a successful whole-source assembly:

- symbol definitions contain pass-one values;
- `varcRunEntryCallTarget` contains the `ENT` address;
- generated bytes occupy their selected physical output locations;
- the logical and physical counters contain their final positions;
- the compressed source itself is unchanged;
- the editor's active line remains available for ordinary work.

After an error:

- the active line is moved to the record whose address was saved before
  processing;
- an error message identifies the category;
- partially emitted output may exist, because assembly is not a transactional
  operation over the generated code area;
- the source records remain intact.

## Important labels encountered

- `invokeAssembly`
- `processCompilation`
- `varcCompileWholeSource`
- `varcAssemblyPassHandlerCall`
- `varcNextAssemblyRecordPointer`
- `varcAssemblyPassTransitionCounter`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `reportAssemblyErrorAtSourceRecord`
- `testSourceRecordOutsideSelectedBlock`

## What comes next

This chapter treated a source record as if the editor had already given it a
correct mnemonic and operand identity.

The next chapter opens that earlier recognition step. We will see how
PROMETHEUS finds words such as `LD`, `DJNZ`, `NZ` and `HL` without storing a
large conventional dictionary, and how one recognized line is matched against
687 compact instruction descriptions.
