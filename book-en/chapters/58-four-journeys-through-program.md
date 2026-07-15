# Chapter 58: Four Journeys Through the Program

We have reached the point where almost every important mechanism in PROMETHEUS
has been examined separately. We know how the editor stores a line, how the
assembler finds an instruction, how the monitor reconstructs readable source,
how one instruction is executed under supervision, and how the whole workshop
moves to a chosen address.

There is one danger in learning a large program this way. The better we become
at naming the parts, the easier it is to forget that the user never experiences
them as isolated parts.

A person at the keyboard does not think:

```text
now I shall invoke a high-bit string table
now I shall repair a symbol ordinal
now I shall enter the second pass
```

The person presses a key, assembles a program, looks at memory, or takes one
step. PROMETHEUS quietly crosses many subsystem boundaries on their behalf.

This chapter therefore follows four complete journeys without pausing to teach
new machinery:

1. a key becomes persistent source;
2. source becomes machine code;
3. memory becomes readable assembly;
4. one machine instruction becomes a safely observed state change.

The journeys also reveal something deeper. PROMETHEUS is not three unrelated
programs squeezed into one binary. The editor, assembler and monitor repeatedly
lend one another their representations and routines.

## Journey one: a key becomes source

Imagine that the editor's active line is empty and the user types:

```asm
LOOP    DJNZ LOOP
```

We shall follow the line from the keyboard matrix to the compressed source
area.

### 1. The Spectrum reports a physical key

The main editor loop eventually reaches:

```asm
processKey:
    call getKeypressCodeOrZero
```

The ROM keyboard scanner does not return a ready-made PROMETHEUS command. It
reports a physical key position and modifier state. `processKey` then performs
the workshop's own translation:

- ordinary letters are normalized;
- CAPS SHIFT and SYMBOL SHIFT select alternate meanings;
- CAPS LOCK may invert letter case;
- command letters may become compact tokens above `$80`;
- a held key is compared with the previous normalized key;
- delays decide whether it is accepted as a repeat;
- the beeper acknowledges an accepted press.

For ordinary source text, the result is an ASCII-like character. The first `L`
in `LOOP` is not yet a source label. It is merely one accepted byte.

### 2. The editable line receives the character

The character enters `updateInputBuffer`. The edit line is a zero-terminated
string containing a movable `$01` cursor marker. Insertion does not require a
large text editor object. The routine moves bytes through the marker until the
new character occupies the cursor position and the marker has moved one place
to the right.

After several keypresses, the temporary buffer conceptually contains:

```text
L O O P _ _ _ _ D J N Z _ L O O P cursor 0
```

The spaces are meaningful. PROMETHEUS divides an assembly line into fields, and
tabulation helps the user move between them. At this stage, however, the line is
still human text. It can be corrected freely without disturbing the persistent
source area.

### 3. ENTER chooses source rather than command dispatch

When ENTER is accepted, `updateInputBuffer` returns with Z set. The editor falls
through to:

```asm
submitInputLineOrDispatchCommand:
    ...
    cp 080h
    jr c,parseAndInsertSourceLine
```

The first nonblank token decides the route:

```text
token >= $80  -> an editor command such as ASSEMBLY or FIND
token <  $80  -> an assembly source line
```

Our line begins with `L`, so it takes the source route.

This small test is the junction between the visible editor and the language
front end. PROMETHEUS does not need a separate command-line parser and source
line parser running in parallel. The keyboard/token layer gives the dispatcher
enough information to choose one.

### 4. Text becomes a semantic temporary record

The call:

```asm
call encodeInputLineToSourceRecord
```

performs the work studied in Chapters 13, 20, 21 and 22.

For our example, it:

1. recognizes `LOOP` as an optional label field;
2. finds `DJNZ` in the mnemonic dictionary;
3. classifies the operand as an expression-bearing relative target;
4. resolves or creates the symbol ordinal for `LOOP`;
5. finds the matching instruction-table record;
6. writes a compact record into temporary encoded-record storage;
7. appends the terminal/back-link byte needed for reverse navigation.

The stored record does not contain the four letters `DJNZ`. It contains the
indexes and expression bytes from which `DJNZ LOOP` can later be reconstructed.
The source line has crossed its most important boundary:

```text
human spelling -> compact semantic representation
```

### 5. The combined source/symbol region opens a gap

The parser returns to:

```asm
parseAndInsertSourceLine:
    call encodeInputLineToSourceRecord
    call getRecordAfterActiveLine
    ...
    call insertByteRangeAtHLFromDE
```

`insertByteRangeAtHLFromDE` does more than copy the new bytes. The persistent
source records and symbol table occupy one packed movable region. Inserting a
record therefore requires a small memory relocation of its own:

```text
check that the added bytes fit below U-TOP
move the following source/symbol suffix upward
increase the combined end pointer
increase the symbol-table base pointer
repair selected-block pointers at or above the insertion
copy the new record into the opened gap
```

The symbol `LOOP` may have been created while the record was being encoded. Its
name and vector live above the source records, so they move together with the
suffix. The record stores only the ordinal, and the vector still leads from that
ordinal to the moved name/value entry.

### 6. INSERT or OVERWRITE decides the old line's fate

The self-modified byte at `varcInsertMode+1` chooses between two visible editor
meanings:

```text
INSERT     keep the old active record and place the new one after it
OVERWRITE  insert the new record, then remove the old active record
```

Even overwrite is implemented as a safe insert followed by a deletion. That
ordering avoids destroying the old line before the new one has been parsed and
accepted.

### 7. Warm start rebuilds the view

The normal completion hook is:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

The warm-start path resets temporary editor state, expands the records around
the active pointer, draws thirteen records above it and six below it, restores
the edit row, and returns to `processKey`.

The user sees one new line. Internally, the line has travelled through:

```text
keyboard matrix
-> normalized key byte
-> editable text buffer
-> mnemonic and operand dictionaries
-> symbol ordinal
-> instruction-table record
-> compressed source record
-> packed source/symbol insertion
-> reconstructed screen text
```

That is the first complete journey.

## Journey two: source becomes machine code

The user now enters the running example:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

and invokes `ASSEMBLY`.

### 1. A command token reaches the compilation controller

The word `ASSEMBLY` was not stored as ordinary letters in the command input
buffer. Keyboard entry expanded it into token `$C1`. The dispatcher uses that
token as a two-byte index into `commandHandlerTable` and jumps to the assembly
handler.

The handler reaches:

```asm
processCompilation:
```

This is not the code emitter itself. It is the conductor of two walks over the
same compressed source sequence.

### 2. Existing unlocked definitions are cleared

Before pass one, ordinary symbols lose their `DEFINED` bit. Locked symbols keep
their value so separately assembled lower layers can remain available.

This distinction is small but powerful:

```text
ordinary source label -> must be defined again by this compilation
locked symbol         -> acts like an imported or fixed definition
```

The symbol vector preserves ordinals throughout. Source records do not need to
be rewritten simply because the values attached to their names are about to be
recomputed.

### 3. Logical address and physical output begin together

The controller initializes two self-modified pointers just beyond the current
source/symbol region:

```text
varcAddressCounter       logical address used by labels and $
varcAssemblyOutputPointer physical address receiving generated bytes
```

At first they are equal. `ORG` may later separate them. This lets PROMETHEUS say:

```text
pretend the code lives at $8000
but place its bytes in whatever free RAM is safe
```

For our example, the first record changes the logical address to `$8000` while
leaving the physical output pointer in the free area above source and symbols.

### 4. Pass one walks the compressed records

The controller installs `firstPassProcessSourceRecord` into a self-modified
`CALL` and visits records in source order.

The pass does not emit half-finished instructions. It asks only what must be
known to assign addresses:

```text
ORG 32768      set logical address to $8000
START LD B,5   define START=$8000, then advance by 2
LOOP DJNZ LOOP define LOOP=$8002, then advance by 2
RET            advance by 1
ENT START      record the required entry expression
```

The instruction table supplies lengths. Ordinary operands need not yet be
resolved merely to discover that `DJNZ expression` occupies two bytes.

At the end of the first scan, every source label in this program has a value.

### 5. The same loop becomes pass two

`varcAssemblyPassTransitionCounter` changes state, and the dispatch `CALL` is
patched to `secondPassEmitSourceRecord`. The controller resets both assembly
pointers and walks the same records again.

Now the compact source records are enough. PROMETHEUS does not reparse the
visible spelling. It already knows:

- the mnemonic index;
- the operand classes;
- the selected instruction-table record;
- the encoded expressions and symbol ordinals.

For `LD B,5`, pass two takes opcode `$06` from the table and appends immediate
byte `$05`.

For `DJNZ LOOP`, it computes:

```text
target                 $8002
address after DJNZ     $8004
displacement           $8002 - $8004 = -2 = $FE
```

The bytes become:

```text
06 05 10 FE C9
```

### 6. Every emitted byte is checked

`emitByteAtAssemblyOutput` does not blindly store through the current pointer.
It first verifies that the destination is outside the protected resident,
source and symbol region and below U-TOP.

This is a good example of a compact program placing safety at a narrow shared
point. Every instruction class and every data directive ultimately emits bytes
through the same checked helper. The rule need not be duplicated in `DEFB`,
`DEFW`, indexed instructions, relative branches and immediate operands.

### 7. RUN adds one final path

If the user chooses `RUN`, compilation also requires exactly one valid `ENT`.
The expression `START` evaluates to `$8000`; the generated-call operand is
patched with that entry address; PROMETHEUS calls the program; and a normal
`RET` returns through `returnFromCompiledProgram` to the workshop.

The complete journey is:

```text
compressed records
-> pass-one address prediction
-> symbol values
-> pass-two table lookup
-> expression evaluation
-> checked byte emission
-> optional ENT-controlled execution
```

The visible text mattered when the record was created. Assembly itself works
mainly from the compact meaning already stored in memory.

## Journey three: memory becomes readable assembly

Now suppose the monitor's current address is `$8000`, where the five bytes have
been placed.

The user asks for disassembly.

### 1. The current address enters a shared line producer

The monitor keeps its focus in the operand of a self-modified instruction:

```text
varcMonitorCurrentAddress+1 = $8000
```

A disassembly view eventually calls:

```asm
disassembleNextLineToBuffer:
```

The destination is not immediately the screen. The routine first constructs a
neutral formatted line in `lineBuffer`.

This separation is why the same decoder can later feed:

- the scrolling monitor list;
- the fixed front-panel item;
- printer output;
- reverse insertion into editor source.

### 2. Data-area policy is checked before opcode decoding

The address is tested against the DEFB and DEFW windows.

If it lies in the hidden resident range, the line is forced to a data directive.
That is how PROMETHEUS avoids pretending that its own writable operands, compact
tables and source records are ordinary instructions.

At `$8000`, no such forced range applies, so decoding continues.

### 3. The decoder recognizes the physical instruction form

`decodeInstructionAtHL` reads `$06`. It determines the prefix family, searches
the shared 687-record instruction table, and finds the form:

```asm
LD B,n
```

The next byte supplies `n=$05`.

The routine returns structural information rather than polished prose:

```text
instruction length
mnemonic/operand descriptor
operand bytes or address
base and alternate timing
control-flow class where relevant
```

This is the same table that the assembler used in the opposite direction.
During source entry, PROMETHEUS asked:

> Which record matches mnemonic LD and operands B,expression?

During disassembly, it asks:

> Which record matches prefix/opcode bytes $06?

### 4. A temporary source record becomes the formatting bridge

Instead of maintaining a second textual assembly formatter, the disassembler
constructs a temporary compressed source record resembling one entered by the
editor.

That record can then pass through `expandSourceRecordToLineBuffer`, the ordinary
source expander.

This reuse gives disassembly the same:

- mnemonic spelling;
- operand spelling;
- number formatting conventions;
- spacing and field layout;
- symbol rendering rules;
- pseudo-instruction representation for unknown/data bytes.

When the next instruction `$10,$FE` is decoded, the relative byte is turned
back into absolute target `$8002`. `findSymbolOrdinalByValue` may replace the
number with `LOOP` if a symbol of that value exists.

The lines become conceptually:

```asm
8000  LD B,5
8002  DJNZ LOOP
8004  RET
```

### 5. The line chooses a destination only at the end

The canonical line can now be consumed in several ways.

For interactive listing, the monitor-list callback draws it and advances the
window.

For the front panel, a descriptor chooses a fixed screen position.

For printer output, the callback sends characters through Spectrum channel 3.

For reverse disassembly, `monDisassembleIntoSource` copies the reconstructed
text into the ordinary input buffer and submits it through
`submitInputLineOrDispatchCommand`. The line is parsed again, assigned live
symbol ordinals and inserted as a normal source record.

The complete journey is therefore:

```text
memory address
-> DEFB/DEFW policy
-> physical opcode decoder
-> shared instruction-table record
-> temporary compressed source record
-> ordinary source expander
-> optional symbol names
-> lineBuffer
-> screen, panel, printer or editor
```

A decoder has become a source generator because both agree on the compact source
language in the middle.

## Journey four: one instruction becomes an observed state change

The monitor can now read `DJNZ LOOP`. The user presses the single-step key while
the saved user PC points to `$8002` and B contains 5.

### 1. The saved processor is the starting truth

PROMETHEUS is currently running on its own stack and registers. The user program
is represented by a saved image containing:

- main and alternate registers;
- IX and IY;
- SP;
- logical PC;
- interrupt state;
- refresh register;
- accumulated timing.

The front panel displays values from this image. The user is not looking at the
monitor's live BC or AF.

### 2. The instruction is decoded structurally

`stepAtCurrentMonitorAddress` reaches `stepInstructionAtHL`, which calls the same
instruction decoder used for textual disassembly.

This time no formatted line is needed. The stepping engine wants:

```text
length = 2
control-flow class = conditional relative branch
sequential address = $8004
taken address = $8002
sequential timing and taken timing
memory-access description, if any
```

Again one table serves two consumers. The monitor does not decode the Z80 once
for display and again for execution.

### 3. Safety is predicted before the real instruction runs

`validateInstructionBeforeExecution` checks the instruction class and any
predicted memory access.

For `DJNZ`, there is no data read or write beyond fetching the instruction
itself, so READ and WRITE windows do not reject it. The candidate next addresses
are also prepared for later RUN checks.

An instruction such as `LD (HL),A` would instead use the saved HL value to test
one WRITE address. `LDIR` would validate the complete repeated ranges.

PROMETHEUS is not emulating the operation. It is predicting just enough about
its externally visible effects to decide whether the real Z80 may perform it.

### 4. The scratch trampoline repairs physical control flow

The original bytes are copied into scratch RAM. A conditional relative branch
cannot retain displacement `$FE`, because `$FE` from the scratch address would
jump inside the scratch region, not to logical `$8002`.

PROMETHEUS rewrites the scratch displacement to `+3`:

```text
scratch DJNZ +3
fall-through -> sequential capture jump
branch taken -> taken capture jump
```

The real Z80 will still decrement B and make the condition decision from the
real flags and register value. Only the physical exits are redirected.

### 5. PROMETHEUS lends the processor to the user instruction

`restoreUserStateAndExecuteTrampoline` switches away from the monitor's private
state:

- the saved primary and alternate registers are restored;
- IX and IY are restored;
- the saved user SP becomes live;
- the recorded interrupt policy is recreated;
- execution enters the scratch instruction.

For a brief moment, PROMETHEUS has become the user's processor state.

### 6. One of two capture paths wins

With B initially 5, `DJNZ` changes it to 4 and takes the branch. The rewritten
`+3` displacement selects `captureUserStateAfterTakenFlow`.

That path:

- disables interrupts for safe capture;
- saves the resulting user registers and stack pointer;
- reconstructs interrupt state;
- corrects the refresh register for monitor-added instructions;
- selects the taken logical next PC `$8002`;
- adds the taken timing.

If B had become zero, the sequential capture path would instead choose `$8004`
and the shorter sequential timing.

### 7. The monitor returns to its ordinary face

The new saved image now says:

```text
B  = 4
PC = $8002
```

The monitor re-enters through its warm start, redraws the descriptor-driven
front panel, and waits for another key.

The complete journey is:

```text
saved processor image
-> shared instruction decoder
-> predicted safety checks
-> scratch control-flow rewrite
-> real Z80 execution
-> taken/sequential capture
-> logical PC and timing repair
-> saved processor image
-> front-panel redraw
```

The instruction was not interpreted in software. It was surrounded by just
enough machinery to let the real processor execute it and still return an
observable result.

## The crossings are more important than the boxes

These four journeys reveal several repeated crossings.

### Human text and compact meaning

The editor accepts text, but persistent source is semantic. The same compact
record later supports:

- screen reconstruction;
- assembly;
- tape save/load translation;
- reverse disassembly;
- symbol reference scans.

### Instruction meaning and physical bytes

The instruction table connects both directions:

```text
mnemonic + operand classes -> opcode and emission recipe
opcode and prefix bytes     -> mnemonic + operand classes
```

It also supplies length and timing to the execution engine.

### Neutral buffers and several destinations

`lineBuffer` separates production from presentation. A line is constructed once
and then sent to screen, front panel, printer, search logic or source insertion.

### Saved state and temporary live state

The monitor treats the user processor as data until the final instant. Then the
saved image becomes live registers, one instruction runs, and the result becomes
data again.

### Self-modified continuations and reusable loops

PROMETHEUS frequently patches a `CALL` or `JP` operand to reuse the same loop
with a different worker:

- pass one versus pass two;
- screen versus printer output;
- normal warm start versus import/replace continuation;
- sequential versus taken capture;
- load versus verify ROM behavior.

The source is compact not only because individual records are compressed, but
because flows are parameterized with tiny pieces of executable state.

## A whole-program pseudocode view

```text
while PROMETHEUS is resident:
    show editor or monitor state
    key = normalize_spectrum_keyboard()

    if editor source is submitted:
        record = parse_and_encode(text)
        insert_record_and_repair_dynamic_pointers(record)

    if assembly is requested:
        first_pass(compressed_source, symbols)
        second_pass(compressed_source, symbols, checked_output)

    if memory is inspected:
        decoded = decode_instruction_or_data(address)
        line = expand_through_source_formatter(decoded)
        send_line_to_selected_destination(line)

    if one instruction is stepped:
        decoded = decode_instruction(address)
        validate_predicted_effects(decoded, saved_cpu)
        trampoline = rewrite_only_dangerous_control_flow(decoded)
        result = execute_on_real_z80(saved_cpu, trampoline)
        saved_cpu = repair_logical_result(result)
```

The installer sits outside this resident loop, but it follows the same style:
use compact generated metadata to transform one neutral origin-zero payload into
the selected live arrangement.

## What changes in memory across the four journeys

- the editable input buffer receives and loses human text;
- temporary encoded-record storage receives semantic records;
- source insertion moves the packed source/symbol suffix;
- symbol vectors gain values during pass one;
- generated bytes appear above the dynamic source/symbol end;
- `lineBuffer` repeatedly receives reconstructed views;
- saved user registers change only when the monitor commits an execution result;
- self-modified pointers and callback operands steer each shared pipeline.

## Important labels reconnected

- `processKey`
- `updateInputBuffer`
- `submitInputLineOrDispatchCommand`
- `encodeInputLineToSourceRecord`
- `insertByteRangeAtHLFromDE`
- `prometheusWarmStart`
- `processCompilation`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `emitByteAtAssemblyOutput`
- `disassembleNextLineToBuffer`
- `decodeInstructionAtHL`
- `expandSourceRecordToLineBuffer`
- `findSymbolOrdinalByValue`
- `monDisassembleIntoSource`
- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `validateInstructionBeforeExecution`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterTakenFlow`
- `captureUserStateAfterSequentialFlow`

## Back to the whole machine

PROMETHEUS feels larger than 16,000 resident bytes because its parts are not
sealed away from one another. A parser's output becomes an assembler's input. A
disassembler borrows the source expander. An instruction table also becomes a
timing table. A saved register image is both a display model and an executable
processor state.

The next chapter asks how this sharing, compression and deliberate overlap made
such a complete workshop fit at all.
