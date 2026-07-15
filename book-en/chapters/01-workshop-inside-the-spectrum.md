# Chapter 1: A Workshop Inside the Spectrum

Imagine using a ZX Spectrum to write a machine-code program. The machine itself has only 48K of RAM. Part of that RAM must hold the screen. Part must hold the development tool. The tool must also find room for your source, your symbol names, the machine code it produces and the temporary buffers needed while editing or assembling.

On a modern computer, an editor, compiler and debugger can each occupy megabytes. PROMETHEUS fits all three jobs into one resident program small enough to leave useful space for the programmer.

That is the best first description of PROMETHEUS: **a machine-code workshop inside the Spectrum**.

## Three main tools, one shared world

The workshop has three large rooms.

### The source editor

The editor lets the user enter and change assembly source. It is not a general text editor that happens to contain assembly language. It understands the shape of assembly lines: labels, mnemonics, operands, comments and assembler directives.

This matters because PROMETHEUS does not keep every source line as ordinary text. Text is pleasant to display but wasteful to store. After a line is accepted, the editor parses it and stores a compact record. When the line must be displayed again, PROMETHEUS expands the record back into readable text.

The editor therefore performs two opposite translations:

```text
what the user types  →  compact source record
compact source record → what the user sees
```

The same compact source later feeds the assembler and can even be created by the disassembler.

### The two-pass assembler

The assembler turns source records into machine bytes. It uses two passes because labels may be mentioned before their values are known.

Consider a forward jump:

```asm
        JP FINISH
        ; many lines may appear here
FINISH  RET
```

When the assembler first sees `JP FINISH`, it may not yet know the address of `FINISH`. During the first pass it calculates where every line will be placed and records label values. During the second pass it knows those values and can emit final bytes.

PROMETHEUS also maintains a symbol table, evaluates expressions, recognizes instruction forms, checks ranges and reports an error at the source record that caused it.

### The monitor

The monitor is the part that lets a programmer examine the machine after code has been assembled. It can display registers and flags, inspect memory, alter bytes, disassemble instructions, search memory, save and load blocks, set temporary breakpoints and execute another program carefully.

Calling it a *monitor* may sound as though it merely watches. In early microcomputer language, a machine-code monitor was an interactive control panel for the processor and memory.

PROMETHEUS's monitor is especially closely connected to its assembler. The disassembler does not invent a separate text format. It builds a temporary compact source record and asks the ordinary source expander to render it. A disassembled instruction can therefore look like an editor line because, internally, it briefly becomes one.

## Two doors into the resident program

The resident payload has two public entry boundaries:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

and, exactly 5,000 bytes later:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

At first this seems odd. Both entries jump to the editor rather than to different top-level routines.

The reason is that PROMETHEUS can be installed in two forms:

- **full installation** — monitor plus assembler/editor;
- **assembler-only installation** — the monitor prefix is omitted to save 5,000 bytes.

In the full form, the first entry is the base of the complete resident image. The monitor exists below the assembler/editor section and can be entered later through `startMonitor`.

In the assembler-only form, installation begins with the second entry. The exact same assembler/editor suffix is copied, but it becomes the beginning of the installed program. The missing monitor is compensated for by relocation and two intentional patches.

The two entries are therefore less like two different front doors and more like two permitted starting cuts through the same building.

## The editor is the ordinary home screen

After installation, `startPrometheus` enters the editor:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
prometheusWarmStart:
    ld hl,ACCESS_LINE_ATTRIBUTE_ADDRESS
    ld bc,02000h+HIGHLIGHT_COLOR
    call atHLrepeatBTimesC
    ld a,MESSAGE_COPYRIGHT
```

We do not need to understand every instruction yet. The larger action is simple:

1. keep initialization undisturbed by interrupts;
2. clear the display;
3. highlight the active input line;
4. show a status message;
5. clear temporary editing buffers;
6. establish the program's private stack;
7. render the visible source lines;
8. enter the key-processing loop.

In pseudocode:

```text
start editor:
    temporarily disable interruptions
    clear the screen
    prepare colors and buffers
    restore the editor stack
    display the current source window

    forever:
        paint the editable line
        read one normalized key
        perform the requested editing action
```

The real loop is more complicated because keys may be held, modifier combinations have special meanings, and some commands replace the normal continuation path. But this is the stable outer shape.

## The monitor is reached from inside the workshop

The full installation contains `startMonitor`, a separate warm entry for the monitor. It resets the monitor's private working state, selects monitor vocabulary and handlers, draws the front panel, reads a command and dispatches it.

The monitor is not a completely separate program joined by a single call. It shares many services with the editor:

- number formatting;
- text rendering;
- keyboard input;
- tape access;
- expression and symbol knowledge;
- source expansion;
- reusable memory-range helpers.

That sharing saves memory, but it also explains some of the source's unusual structure. A common routine may be used in a calm editor operation and later in a monitor path where registers, callbacks or error handling have been temporarily redirected.

## What the user can do in one session

A typical session might look like this:

1. Enter several assembly lines.
2. Edit a mistaken operand.
3. Mark a block of source.
4. Assemble the complete source or only the marked block.
5. Run the generated program through an `ENT` entry directive.
6. Enter the monitor.
7. Inspect the generated bytes.
8. Disassemble them back into source-like text.
9. Alter a byte or register.
10. Trace an instruction.
11. Save source, symbols or a raw memory block to tape.
12. Return to editing.

Those actions are not isolated commands bolted onto a menu. They are different views of the same information.

A label typed in the editor becomes a symbol-table entry. The assembler uses it to emit an address. The monitor may show that symbol name when disassembling the address. A disassembled instruction can be inserted back into source. The RUN command uses the address selected by `ENT`. The monitor protects the resident source and symbol region because it knows where the editor's dynamic memory currently ends.

The workshop is connected by shared representations.

## A program that remembers by rewriting itself

One of the first surprises in the source is the number of labels beginning with `varc`. They identify persistent values stored inside instruction bytes.

For example, a routine may contain:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

Another routine writes a new word into the operand after the `LD` opcode. The next time this instruction runs, it loads the remembered pointer.

To a modern reader, code and data are often imagined as strictly separate. On the Spectrum they occupy the same writable RAM. PROMETHEUS takes advantage of that fact.

This style can save instructions and separate variable cells. It can also make dispatch very compact: a `CALL` instruction's destination may be changed between the first and second assembler passes, or an opcode may itself encode the current mode.

The cost is that a seemingly ordinary instruction may have two roles:

- perform an action now;
- store state for later.

We will devote a full chapter to this technique. For the moment, remember that the program is not only *executing* its instructions. It is also *using their bytes as memory*.

## Tables as small specialized languages

PROMETHEUS is full of tables, but they are not all simple lists.

A table may describe:

- a monitor front-panel item;
- a mnemonic spelling;
- an operand class;
- an instruction encoding;
- a command handler;
- a protected address range;
- a compact string;
- a source record;
- a relocation target.

Each table is a tiny language understood by one or more interpreter routines. A byte may mean “display this value in hexadecimal,” “the final character has arrived,” “jump this many bytes backwards to the real string,” or “the next two bytes contain a symbol ordinal.”

This is one of the key reading habits for the entire source:

> When a block of bytes looks mysterious, first find the routine that reads it.

The meaning is usually in the relationship between table and consumer, not in the bytes alone.

## Why the source is one large file

The reconstructed source is largely monolithic. That does not mean the program lacks subsystems. It means the emitted image tightly combines:

- executable routines;
- writable instruction operands;
- initial buffers;
- compact strings;
- descriptor tables;
- generated metadata;
- two possible resident boundaries.

Splitting such a file mechanically can hide physical relationships that matter. A byte may be reached by a self-relative displacement. A table order may be encoded as a token number. The assembler-only entry must remain exactly at the boundary between monitor and editor sections unless the installer is rebuilt to follow it.

The book will organize concepts more freely than the binary, but it will always point back to the physical source.

## Back to the whole machine

We can now draw the first useful picture:

```text
                  ┌───────────────────────┐
                  │       source editor   │
keyboard ───────► │  readable line view   │
                  └──────────┬────────────┘
                             │ compressed records
                             ▼
                  ┌───────────────────────┐
                  │   two-pass assembler  │
                  │ symbols + expressions │
                  └──────────┬────────────┘
                             │ machine bytes
                             ▼
                  ┌───────────────────────┐
                  │        monitor        │
                  │ inspect / alter / run │
                  └──────────┬────────────┘
                             │ disassembled records
                             └──────────────► editor
```

This picture is still simple, but it gives every later mechanism a home.

In the next chapter, one tiny source program will travel through the complete loop. We will not yet examine every format byte. We will see why those formats must exist.

## What has changed in memory?

After an ordinary editor startup:

- the resident PROMETHEUS image is already installed and relocated;
- the screen bitmap and attributes have been initialized;
- the edit and formatting buffers have been cleared;
- the internal stack pointer has been restored;
- the current compressed source remains in its resident area;
- the editor is waiting inside the key-processing path.

No user program has been assembled yet. The workshop is open, but the workbench is empty.

## Source anchors introduced

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `startPrometheus`
- `prometheusWarmStart`
- `startMonitor`
- `processKey`
- `varcAssemblyOutputPointer`
