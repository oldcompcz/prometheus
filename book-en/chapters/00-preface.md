# Preface: How to Read This Book

A large assembly-language program can make a strange first impression. Even when every instruction is legal and every label has a meaningful name, the page can look less like a story and more like a warehouse inventory. A register is loaded, a flag is tested, a pointer moves, three bytes are copied, and suddenly the code jumps somewhere that seems to belong to a completely different subject.

PROMETHEUS makes this effect stronger than most programs. It is not one simple routine repeated many times. It is an editor, an assembler, a disassembler, a debugger, a tape utility, a screen interface and a relocatable installation program sharing one small computer. Some instructions also serve as variables. Some tables resemble instructions even though they are data. Some data contains tiny offsets that only make sense from the address of the byte that stores them. Several subsystems borrow the same buffers and temporarily replace one another's callback addresses.

The source can be read directly, but direct reading is expensive. To understand a routine, you often need to know a format defined thousands of lines later. To understand the format, you need to know the routine that consumes it. This book is meant to break that circle.

## You do not need to be a Z80 expert

The assumed reader knows the broad idea of assembly language:

- a processor has registers;
- instructions move and transform values;
- labels name addresses;
- branches change the next instruction;
- a stack supports calls and temporary storage;
- machine code is the byte representation of instructions.

That is enough to begin.

When PROMETHEUS uses a less familiar Z80 feature—alternate registers, `EXX`, the carry flag as a returned Boolean, self-modified instruction operands, or a stack-pointer trick—the book will explain it at the moment it becomes useful. We will not pause for a complete Z80 course before meeting the application. It is easier to remember a technique when we already know which problem it solves.

## The order is deliberately different from the source

The physical source begins with installation and relocation. That order is correct for the emitted binary, but poor for learning. Relocation is the answer to a question a new reader has not yet asked: *what exactly is being moved, and why are there so many internal addresses to repair?*

We will therefore begin with the running application. First we will see the editor, assembler and monitor as a connected workshop. Then we will follow a tiny program through the workshop. Only after that will we map the memory in which everything lives.

Later parts repeat the same rhythm:

```text
see the feature from above
        ↓
learn its small mechanisms
        ↓
follow the complete feature again
```

The editor part, for example, will begin with what happens when the user presses a key. It will then descend into keyboard normalization, editable buffers, compressed source records and memory movement. At the end, we will trace one edited line from the key matrix to its permanent compressed form.

The monitor part will work the same way. We will first see a front panel and a disassembly window. Only later will we examine instruction descriptors, protected memory ranges, saved processor state and the scratch code used for single stepping.

## Real code, but not a line-by-line paraphrase

The book uses real fragments such as this:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

A fragment is included when the exact Z80 technique matters, when it anchors a discussion to a real label, or when the code is clearer than a verbal description.

It does not help to copy fifty routine lines and replace each instruction with an English sentence. The source already contains the instructions. The book's job is to reveal the larger action.

For that reason, complete algorithms are often restated in pseudocode:

```text
for every source record:
    if this is pass one:
        determine addresses and define labels
    otherwise:
        emit the final instruction bytes
```

This pseudocode is not an alternative implementation. It is a map. Once the map is clear, the real register-level route becomes much easier to follow.

## Reconstructed names and historical facts

The surviving machine image did not arrive with all of the descriptive labels used in this repository. Many names were reconstructed from control flow, data usage, emulator traces, manuals and repeated verification. A label such as `disassembleNextLineToBuffer` states what the routine has been shown to do; it does not claim that the original programmer wrote that exact phrase.

The project also distinguishes several kinds of confidence:

- **Byte identity** means the reconstructed source emits exactly the historical machine bytes.
- **Static analysis** means the behavior follows from the instructions and data flow.
- **Execution evidence** means a path was observed in the emulator or CPU harness.
- **Interpretation** means we have a strong explanation of why a technique was chosen, but not a surviving comment from the original author.

Where that distinction matters, the book will say so. It is better to leave a small uncertainty visible than to turn a plausible guess into false history.

## Labels are more useful than line numbers

The file will continue to evolve. Line numbers therefore make poor long-term references. Chapters point primarily to labels:

- `startPrometheus`
- `processCompilation`
- `sourceBufferStart`
- `disassembleNextLineToBuffer`

A label survives the addition of comments and usually expresses the concept being discussed. The source-coverage ledger records where each important label receives its proper explanation.

## The central question

Nearly every design in PROMETHEUS can be understood by asking one question:

> How can this feature be made useful while consuming very little memory?

The answer is sometimes elegant and sometimes severe. Source lines are compressed. Names are represented by compact ordinals. Strings often borrow the top bit of their final character as an end marker. Instruction operands double as writable variables. Tables replace repeated decision code. The monitor reuses the source expander to produce disassembly text. The installer relocates the program so users are not forced to keep it at one address.

These are not isolated tricks. Together they are the personality of the program.

The first chapter now introduces the workshop those choices created.
