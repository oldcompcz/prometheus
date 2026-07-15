# Foreword: The Fire Inside the Machine

In 1990, writing a serious machine-code program on a ZX Spectrum was an exercise in making several large things inhabit one very small room. The computer had to hold the programming tool, the source text, the symbol table, the machine code being produced and some means of examining that code when it failed. A cassette recorder was often the only permanent storage. Every extra kilobyte occupied by the tools was a kilobyte taken away from the program.

PROMETHEUS was created for that world.

It was written by the Czech programmer **Tomáš Vilím**, also known under the name **Universum**, and first published in **1990** by **Proxima – Software** of Ústí nad Labem. The original release belongs to the world of the Sinclair ZX Spectrum and the then-established Didaktik Gama. Surviving catalogue records likewise cover both the original 48K system and later 128K editions.[^foreword-1]

Calling PROMETHEUS merely an assembler is accurate in the same limited way that calling a workshop a room is accurate. Its central task is to translate Z80 assembly language into machine code, but around that translator stands almost everything needed to develop a program on the machine itself:

- a source editor;
- a two-pass assembler;
- a symbol table that is maintained while the source is edited;
- a disassembler;
- a machine-code monitor;
- tracing and single-step facilities;
- memory inspection, searching and modification;
- protection windows for watched areas of memory;
- cassette operations and, in later editions, disk support;
- a relocatable installer that lets the user choose where the system will live.

The result is better described by the phrase used in Czech accounts of the program: an **integrated debugging system**. Editor, assembler and monitor do not merely coexist on one tape. They share routines, formats and knowledge.

## Why it was built

The original manual begins not with instruction syntax but with a comparison of the development systems already familiar to Spectrum programmers. It discusses GENS and its extensions, OCP, Laser Genius, Memory Resident System, PIKASM, MON, MON2 and VAST. Each offered useful ideas, but each also imposed a cost in memory, source size, convenience or integration.

From this comparison, Vilím identifies two main requirements for a better system:

1. source text must be stored as efficiently as possible;
2. assembler and monitor must form one connected whole.

Those requirements explain much of the code studied in this book. PROMETHEUS does not preserve source lines as ordinary text. It parses them into compact records containing mnemonic identifiers, operand forms, symbol references and small pieces of literal data. The symbol table belongs to the living source structure instead of being rebuilt in a large temporary area for every assembly. The monitor reuses services of the assembler, and the disassembler can manufacture the same kind of compact record that the editor later expands into readable text.

This is not compression added as a final optimisation. It is the architecture.

According to the figures printed in the 1990 manual, the 48K system occupied about **11 KB for the assembler/editor and 5 KB for the monitor**. The manual claims a typical source-to-output size ratio of roughly **3:1 to 4:1**, and an assembly speed of approximately **2–3 KB per second**. These were promotional figures supplied by the program's author and publisher, not measurements made for this book, but they describe the priorities very clearly: leave room for the user's work, and do not make the user wait unnecessarily.[^foreword-2]

## A program that learned to build itself

PROMETHEUS also has a pleasingly appropriate creation story.

The manual says that its early development used **GENS3E, GENS 3.1, MON, MON2 and VAST**. GENS remained the assembler until the first usable PROMETHEUS assembler had been debugged. From that point onward, newer versions were assembled by an older version of PROMETHEUS. The monitor was then written from the beginning inside PROMETHEUS itself.[^foreword-3]

In other words, the tool crossed a boundary familiar from the history of compilers: it became capable of building its own successor.

The author gives a concrete comparison. In GENS, the source was said to occupy about 40 KB, had to be split into two parts and took around forty seconds to assemble. Converted into PROMETHEUS's compact representation, it occupied about 20 KB, fitted into memory as one source and assembled in about three seconds. Again, these numbers come from the original manual and should be read as the author's contemporary report. Their importance is not the exact benchmark. Their importance is that PROMETHEUS itself became the demonstration program for its storage model and assembler speed.[^foreword-3]

## The 48K system and its 128K descendants

The program first addressed the ordinary 48K Spectrum environment. Its distributed image contains a monitor, an assembler/editor and a temporary installation section with relocation information. It can install the complete development system or omit the 5,000-byte monitor prefix and leave only the assembler/editor. The installed program is relocatable, so the user can trade memory below or above it according to the needs of the project being developed.

A later 128K edition extended the same ideas into banked memory. The surviving manual addendum says that source could occupy as much as 64 KB in RAM pages 1, 3, 4 and 6. It describes three variants: a short disk-oriented form, a middle form intended mainly for developing 48K programs, and a long form with the complete feature set. The 128K edition could assemble and trace code in paged memory and cooperate with D40/D80 and Kompakt disk systems, while retaining relocation.[^foreword-4]

This book, however, follows the reconstructed **48K program**. That version is small enough to fit inside one visible address space, yet complicated enough to contain nearly every problem that makes old machine-code software fascinating: packed data, relocation, self-modifying operands, private stacks, alternate registers, shared buffers, ROM calls, hardware access and a debugger that must briefly take control of another program without losing either program's state.

## The name

The mythological Prometheus stole fire and brought it to humanity. The name was already suitable for a programming tool before anyone looked inside the binary: an assembler gives the programmer access to the machine's most direct and dangerous form of power.

Inside the code, the name becomes even more appropriate. PROMETHEUS does not hide the Spectrum behind a comfortable abstraction. It teaches the user to work with addresses, registers, flags, instruction timings, screen memory, cassette blocks and the electrical reality of port `$FE`. The monitor can protect areas of memory, but it cannot make machine code harmless. The original manual repeatedly reminds the user that a wrong address or an unsafe breakpoint can destroy the current work.

The gift is power, not safety.

## The wider PROMETHEUS world

PROMETHEUS was not an isolated technical curiosity. Vilím produced other Spectrum software under the Universum name and through Proxima, and later wrote the two-volume Czech book *Assembler a ZX Spectrum*, published by Proxima in 1992. The example sources in those books were prepared for PROMETHEUS, placing the assembler at the centre of a small ecosystem of software, documentation and teaching material.[^foreword-5]

Decades later, archive sites still preserve 48K and 128K tape images, disk images, scans of the manual and catalogue records. That survival matters. Most users encountered PROMETHEUS only as an opaque block of machine code. The development source was not preserved in a form that could simply be opened, rebuilt and annotated.

The resurrection project behind this book therefore began from the surviving program image. Its reconstructed assembly source has been repeatedly checked against the historical binary and TAP image until it reproduces them byte for byte. Descriptive labels and explanatory comments are modern additions, but the emitted machine code remains the old program.

That distinction is central to the pages that follow. We can establish exactly what many routines do. We can observe paths in an emulator. We can compare the implementation with the manual. We can identify design patterns that repeat across the system. But we should not pretend that every reconstructed label was chosen by Tomáš Vilím, or that every inferred intention survives as a documented historical fact.

The purpose of this book is neither to replace the original manual nor to turn the source into a museum specimen. It is to make the machinery readable again.

PROMETHEUS was a practical tool created under severe limits. Its compressed records, relocation streams, synthetic calls and tracing machinery were not puzzles written for future reverse engineers. They were solutions to the everyday problem of building substantial Z80 programs on a small computer.

The source is intricate because the task was ambitious. It is worth reading because the solutions remain ingenious.

Now we can open the machine and follow the fire inward.

---

## Historical sources for this foreword

[^foreword-1]: *PROMETHEUS* user manual, Proxima, Ústí nad Labem, 1990, title page; World of Spectrum and ZXDB catalogue records for PROMETHEUS, which identify Tomáš Vilím as author and record the 48K/128K releases. The surviving manual scan is a layered historical document: its machine list includes later Didaktik compatibility and must not be treated as unchanged 1990 launch copy. The name Universum is preserved in Czech catalogue and biographical records.
[^foreword-2]: *PROMETHEUS* user manual, section “Trocha sebechvály aneb odkud to přišlo”, especially the contemporary feature and performance summary.
[^foreword-3]: Ibid., description of the development process and the transition from GENS to self-hosting PROMETHEUS.
[^foreword-4]: Ibid., “Poznámky k verzi 128”, describing bank use and the `sht`, `mdm` and `lng` variants.
[^foreword-5]: Catalogue records for Tomáš Vilím and the two-volume *Assembler a ZX Spectrum* (Proxima, 1992); surviving descriptions state that its example sources were prepared for PROMETHEUS.
