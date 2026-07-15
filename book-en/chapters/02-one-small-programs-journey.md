# Chapter 2: One Small Program's Journey

A system becomes easier to understand when we follow one thing through it. For PROMETHEUS, the most useful thing to follow is a source program.

We will use this tiny example throughout the book:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

The exact screen spacing is not important yet. The program does four simple jobs:

1. tell the assembler to place code at address 32768, which is `$8000`;
2. load register `B` with 5;
3. decrement `B` and jump back to `LOOP` until it reaches zero;
4. return to its caller.

`ENT START` tells PROMETHEUS which address the RUN command should call.

The loop is intentionally unexciting. That lets us concentrate on the journey rather than the program's purpose.

## Stage 1: The keys do not go directly into source storage

Suppose the user types the first line. PROMETHEUS reads a physical Spectrum key, interprets Caps Shift or Symbol Shift, applies Caps Lock behavior, handles held-key repeat and returns one normalized code.

The outer editor loop repeatedly calls `processKey`:

```asm
.readInputLineLoop:
    call repaintEditLine
    call setBorderColor
    call processKey
    push af
    call printStatusBar
    pop af
```

The normalized character is inserted into an editable input buffer. At this moment the line is still close to ordinary text. The cursor can move through it; characters can be inserted or deleted; fields can be repainted.

Only when the user submits the line does PROMETHEUS try to understand it.

For `START LD B,5`, the parser must answer several questions:

- Is `START` a label?
- Is `LD` a known mnemonic?
- Is `B` a register operand?
- Is `5` a numeric expression?
- Does this combination correspond to a real Z80 instruction form?

If the answers fit, the line is encoded as a compact source record and inserted into the permanent source area.

In pseudocode:

```text
submit editable line:
    split line into label, operation and operand fields
    recognize the operation
    parse each operand or expression
    build a compact record
    replace or insert the active source record
    redraw the visible source window
```

The details of that record will occupy several later chapters. For now, one fact matters: **the permanent source is no longer just the characters the user typed**.

## Stage 2: The source begins as twenty empty records

At the end of the resident payload, PROMETHEUS contains an initial source area:

```asm
sourceBufferStart:
    defb 0x00, 0x30
    defb 0x00, 0x30
    ; ...twenty empty records in total...
```

An empty line is represented by the two bytes `$00,$30`. Twenty are supplied so the editor can already place its active access line among valid records above and below it.

As the user enters real lines, records are inserted into this region and following memory is moved. The source therefore grows, shrinks and changes shape while PROMETHEUS remains resident.

Our five visible lines become five structured records. They will not all have the same length:

- `ORG 32768` needs a directive code and an encoded expression;
- `START LD B,5` includes a label reference, an instruction description and a constant;
- `LOOP DJNZ LOOP` includes both a definition and a reference to a symbol;
- `RET` is compact because it has no explicit operand;
- `ENT START` stores the entry expression used by RUN.

The symbol names themselves are managed separately, so a record can refer to a compact symbol ordinal instead of repeating the full spelling every time.

## Stage 3: Names become symbols

Two labels appear in the example:

```text
START
LOOP
```

During editing and assembly, PROMETHEUS gives each name a symbol-table identity. Source records can then refer to that identity.

At first, a symbol may exist without a final value. `LOOP` can be mentioned in an expression before the first assembler pass has assigned its address. The symbol table must therefore remember more than a name and number. It also tracks states such as defined, undefined, locked or temporary.

For our example, the first pass will eventually determine:

```text
START = $8000
LOOP  = $8002
```

Why `$8002`? Because `LD B,5` occupies two bytes at `$8000` and `$8001`. The next instruction begins at `$8002`.

## Stage 4: The first assembler pass measures the program

The ASSEMBLY command reaches `invokeAssembly`:

```asm
invokeAssembly:
    call processCompilation
    ld a,MESSAGE_ASSEMBLY_COMPLETE
    jp prometheusWarmStartWithMessage
```

The real work is in `processCompilation`. Its central trick is a self-modified call. During the first scan, that call points to `firstPassProcessSourceRecord`. During the second scan, it is patched to call `secondPassEmitSourceRecord` instead.

The surrounding controller looks roughly like this:

```text
prepare symbols for a new assembly
select first-pass record handler

repeat twice:
    reset logical address and output pointer
    scan source records in order
    call the currently selected handler for each record
    replace first-pass handler with second-pass handler
```

The real source contains:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

and later:

```asm
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

The bytes of a `CALL` instruction are being used as a writable function pointer.

During pass one, our example changes the logical address counter like this:

| Source line | Address before line | Effect |
|---|---:|---|
| `ORG 32768` | dynamic default | set logical and physical output to `$8000` |
| `START LD B,5` | `$8000` | define `START=$8000`; add 2 |
| `LOOP DJNZ LOOP` | `$8002` | define `LOOP=$8002`; add 2 |
| `RET` | `$8004` | add 1 |
| `ENT START` | `$8005` | record entry expression; emit no instruction bytes |

At the end of the first pass, every label value needed by this program is known.

## Stage 5: The second pass emits the bytes

The second pass scans the same compact source records. This time it evaluates final expressions and matches each machine instruction against the instruction table.

The output is:

```text
Address   Bytes    Source
$8000     06 05    LD B,5
$8002     10 FE    DJNZ LOOP
$8004     C9       RET
```

The interesting byte is `$FE`, the displacement for `DJNZ`.

A relative jump does not store the complete destination `$8002`. It stores the signed distance from the address *after* the jump instruction. After fetching `DJNZ` and its displacement, the processor would be at `$8004`.

So PROMETHEUS calculates:

```text
target - next instruction
= $8002 - $8004
= -2
= $FE as an 8-bit signed value
```

This is one reason the assembler needs instruction-specific operand handlers. A word address, an immediate byte, an index displacement and a relative branch may all begin as expressions, but they are encoded differently.

The output pointer advances as each byte is written. PROMETHEUS also checks that the generated program does not collide with protected resident/source storage or extend beyond the configured upper memory boundary.

## Stage 6: RUN uses the entry chosen by ENT

The `ENT START` directive does not emit a Z80 instruction. During the second pass, it evaluates `START` and patches the target of a call used by the RUN command.

The relevant source shape is:

```asm
varcRunEntryCallTarget:
    call 00000h
```

After assembly, the operand has become `$8000`. RUN clears the editor display and executes the patched call.

Conceptually:

```text
RUN:
    assemble the source
    require exactly one ENT directive
    clear the display
    call the address selected by ENT
    when the program returns, wait for a key
    return to the editor
```

Our sample program returns normally. It changes `B`, but it does not permanently seize control of the Spectrum.

## Stage 7: The monitor can read the bytes back

Now imagine entering the monitor and selecting address `$8000` for disassembly.

The disassembler begins at `disassembleNextLineToBuffer`. For a normal unprotected address, it calls the instruction decoder:

```asm
    call decodeInstructionAtHL
```

If a matching instruction form is found, the decoder returns a canonical operation and operand description. PROMETHEUS then constructs a temporary compact source record and passes it through the ordinary source expander.

The result is text equivalent to:

```asm
        LD B,5
        DJNZ $8002
        RET
```

If symbol lookup is enabled and `LOOP` is available by value, the branch may be shown using the symbol name instead of the numeric address.

This is a particularly elegant connection:

```text
machine bytes
    ↓
instruction decoder
    ↓
temporary compressed source record
    ↓
normal source-line expander
    ↓
monitor text or inserted editor source
```

The disassembler does not need a second complete formatter for assembly syntax.

## Stage 8: The monitor may execute one instruction carefully

A normal RUN gives control to the program and waits for it to return. The monitor can do something more delicate: execute a single instruction while preserving a saved image of the user's processor state.

For `LD B,5`, that requires little special handling. For `DJNZ LOOP`, the monitor must decide whether the branch is taken, preserve the rest of the registers and return control to itself after the instruction.

Later chapters will show how PROMETHEUS builds a small scratch sequence, restores the user's registers, executes or transforms the selected instruction, captures the result and redraws the front panel.

For now, we can extend the journey:

```text
source line
    → compact record
    → symbol values
    → machine bytes
    → decoded instruction
    → controlled execution
    → updated register display
```

## The complete journey in one view

```text
1. Physical keys
        ↓ processKey
2. Editable input buffer
        ↓ parser and encoder
3. Compressed source records
        ↓ first pass
4. Addresses and symbol values
        ↓ second pass
5. Machine-code bytes
        ↓ RUN or monitor
6. Executing program / inspected memory
        ↓ disassembler
7. Temporary source record
        ↓ source expander
8. Readable assembly text
```

This is why PROMETHEUS should not be understood as three unrelated programs. The editor, assembler and monitor continuously translate between several representations of the same program.

## What has changed in memory?

After entering and assembling the example:

- five meaningful source records have replaced some initial empty records;
- the dynamic source region has grown;
- the symbol table contains at least `START` and `LOOP` with final values;
- the protected code-end marker has moved to include the enlarged source and symbols;
- bytes `$06,$05,$10,$FE,$C9` have been emitted beginning at `$8000`;
- the RUN call operand contains `$8000` after processing `ENT START`;
- the monitor can inspect the emitted program without altering the stored source.

## Source anchors introduced

- `processKey`
- `sourceBufferStart`
- `processCompilation`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `varcAssemblyPassHandlerCall`
- `invokeAssembly`
- `varcRunEntryCallTarget`
- `disassembleNextLineToBuffer`
- `decodeInstructionAtHL`
