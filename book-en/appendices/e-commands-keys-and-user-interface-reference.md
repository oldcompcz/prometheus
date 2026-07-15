# Appendix E: Commands, Keys and User Interface Reference

This appendix is the quick-reference part of the book. It describes what a
person can type or press, without requiring the reader to remember the internal
journey followed by the command.

PROMETHEUS has three related interfaces:

```text
installer                 choose how and where PROMETHEUS is installed
editor and assembler      enter source, manage symbols, assemble and save
monitor                   inspect, alter and execute machine code
```

The same physical Spectrum key can have a different meaning in each interface.
The tables below therefore always state the current interface.

## E.1 Names used for Spectrum shift keys

The Spectrum has two shift keys:

- **CAPS SHIFT**, abbreviated `CS`;
- **SYMBOL SHIFT**, abbreviated `SS`.

A notation such as `SS+W` means hold SYMBOL SHIFT and press W. `CS+1` means the
Spectrum EDIT key combination. Named keys such as `ENTER`, `SPACE`, `DELETE` and
the four cursor keys refer to their normal Spectrum meanings.

PROMETHEUS normalizes keys before dispatching them. Some source comments and
internal tables therefore contain byte values such as `$14` or `$3E`. Those are
not characters to type; they are the program's compact internal key codes.

## E.2 Editor screen and modes

The main editor screen contains a source listing, one highlighted access line,
an editable input line and a status bar. The access line says which compressed
source record is current. The input line is a separate working copy.

Two insertion policies are available:

| Mode | Meaning |
|---|---|
| INSERT | Submitting a line inserts a new source record before the active position. |
| OVERWRITE | Submitting a line replaces the active source record. |

`SS+W` toggles the policy. `CS+1` loads the active source line into the input
buffer and forces the next submission to overwrite that line.

Number display is also shared between editor and monitor:

| Mode | Typical display |
|---|---|
| decimal | `32768` |
| hexadecimal | `#8000` |

The `H` editor command and `SS+3` in the monitor toggle this mode.

## E.3 Immediate editor keys

These keys operate without first becoming a textual command.

| Key | Action |
|---|---|
| ordinary printable character | Insert or overwrite that character at the input cursor. |
| `ENTER` | Submit the input line. A command is dispatched; an assembly line is encoded and inserted or overwritten. |
| `CS+5` / cursor left | Move the input cursor one character left. |
| `CS+8` / cursor right | Move the input cursor one character right. |
| `CS+0` / DELETE | Delete the character immediately before the input cursor. |
| `CS+2` / CAPS LOCK | Toggle the input case lock used by the editor. |
| `SPACE` | Insert a space, with automatic movement to the next source field where appropriate. |
| `SS+O` | Enter a semicolon comment marker. |
| `SS+Q` | Abandon the current input line and return to the normal warm editor display. |
| `CS+1` / EDIT | Expand the active compressed source record into the input line and select overwrite mode. |
| `SS+W` | Toggle INSERT and OVERWRITE. |
| `CS+6` / cursor down | Select the next source record. |
| `CS+7` / cursor up | Select the previous source record. |
| `CS+3` / TRUE VIDEO | Move forward by one page, twenty source records. |
| `CS+4` / INVERSE VIDEO | Move backward by one page, twenty source records. |
| `CS+9` | Delete the active source line and select the preceding line. |
| `CS+SS` | Set or move one boundary of the selected source block. |

The two block boundaries may be marked in either order. COPY, DELETE, PRINT,
block FIND and block SAVE normalize them into a lower and upper source-record
address before use.

## E.4 Editor command alphabet

A command is normally entered by starting an empty input line with SYMBOL SHIFT
and a letter. The tokenizer converts the command word into one byte in the range
`$C1` to `$DA`; the handler table is arranged alphabetically.

The table below gives the confirmed public meanings and also records historical
alias slots that remain in the binary.

| Letter | Command | Purpose |
|---|---|---|
| A | `ASSEMBLY` | Assemble the current source. |
| B | `BASIC` | Leave PROMETHEUS and return to Spectrum BASIC. |
| C | `COPY` | Copy the selected source block before the active destination line. |
| D | `DELETE` | Delete the selected source block. |
| E | end | Select the last real source record. |
| F | `FIND` | Find text in source, with persistent text, scope and continuation state. |
| G | `GENS` | Import source in the supported GENS/MASM tape representation. |
| H | number-base toggle | Toggle decimal and hexadecimal display. |
| I | historical GENS alias | Dispatches to the GENS import path; normal reachability is not assumed merely from the table entry. |
| J | historical GENS alias | Dispatches to the GENS import path; same caution as I. |
| K | source start | Select the first source position. |
| L | `LOAD` | Load a PROMETHEUS source-and-symbol file. |
| M | `MONITOR` | Enter the resident machine-code monitor. |
| N | `NEW` path | Enter the Spectrum ROM NEW path. |
| O | historical NEW alias | Shares the same handler as N. |
| P | `PRINT` | Print source, optionally restricted to the selected block. |
| Q | `QUIT` | Leave the active operation through PROMETHEUS's quit path. |
| R | `RUN` | Assemble and run from the address selected by `ENT`. |
| S | `SAVE` | Save source and symbols, either whole or selected. |
| T | `TABLE` | Display or manage the symbol table. |
| U | `U-TOP` | Set the highest address available to source, symbols and generated output. |
| V | `VERIFY` | Verify the block described by the immediately preceding SAVE state. |
| W | mode toggle | Toggle INSERT and OVERWRITE; equivalent to the immediate `SS+W` action. |
| X | `CLEAR` | Clear the source workspace. |
| Y | historical CLEAR alias | Shares the CLEAR handler. |
| Z | `REPLACE` | Replace matching text on selected source lines while reusing FIND state. |

The duplicated entries are historical facts about the dispatch table. They are
not evidence that every alias was advertised or conveniently typeable in every
surviving edition.

## E.5 Source navigation and editing commands

### Start and end

| Action | Entry |
|---|---|
| go to first source position | `K` |
| go to last real source line | `E` |
| previous/next line | cursor up/down |
| previous/next page | `CS+4` / `CS+3` |

The end command first obtains the source-end sentinel and then steps backward to
the last real record. The sentinel itself is not shown as an assembly line.

### Copy

`COPY` duplicates the complete compressed byte range from the first selected
record through the second selected record and inserts it before the active line.
The destination must not lie inside the selected range.

Typical use:

```text
1. mark one boundary with CS+SS
2. move to the other end
3. mark the second boundary with CS+SS
4. move to the insertion point
5. enter COPY
```

The original records remain. The new copy is not automatically made the selected
block.

### Delete

`DELETE` removes the complete selected block. It is different from `CS+9`, which
removes only the active line.

### Clear

`CLEAR` removes the current source workspace and re-establishes the empty source
and symbol layout. Because X and Y share the handler, old material may describe
more than one key for this operation.

## E.6 FIND and REPLACE forms

FIND remembers three things: the text, the scope and the last scan position. This
makes a bare FIND a continuation command rather than an incomplete command.

| Form | Meaning |
|---|---|
| `FIND s:text` | Store `text`; search the whole source from the beginning. |
| `FIND b:text` | Store `text`; search the selected block from its beginning. |
| `FIND :text` | Store new text; begin at the current position, retaining the previous scope. |
| `FIND` | Reuse the stored text and scope and continue after the previous candidate. |

Matching is case-insensitive and is performed on the expanded visible source,
not directly on compression bytes.

REPLACE stores a second persistent string. A replacement operation expands the
active record, performs non-overlapping textual replacements, and submits the
rebuilt line through the ordinary overwrite path. It does not patch compressed
source bytes in place.

The practical rhythm is:

```text
FIND       inspect the next matching line
REPLACE    replace matches on that line and continue
FIND       skip a line without changing it
REPLACE    accept the next replacement
```

A replacement cannot create an editor line longer than the normal 31-character
input capacity.

## E.7 PRINT

| Form | Meaning |
|---|---|
| `PRINT` | Print all expanded source records from the beginning. |
| `PRINT b` | Print only the selected block. |

PRINT uses the Spectrum channel associated with printer output. It expands each
compressed record through the same canonical expander used by the editor, so the
printer receives ordinary readable source rather than token bytes and ordinal
references.

## E.8 ASSEMBLY, RUN and BASIC

| Command | Result |
|---|---|
| `ASSEMBLY` | Run pass one and pass two and leave the generated code in the selected output area. |
| `RUN` | Assemble, then transfer control to the address established by `ENT`. |
| `BASIC` | Return to Spectrum BASIC. |
| `MONITOR` | Enter the resident monitor, when the monitor edition was installed. |

Assembly diagnostics are reported against the source record that caused them.
Pass one determines symbols and lengths. Pass two emits bytes. A source may use
`ORG` and `PUT` to separate logical addresses from physical output addresses.

## E.9 U-TOP

`U-TOP` is followed by an ordinary PROMETHEUS expression:

```text
U-TOP #BFFF
U-TOP 49151
U-TOP -1
```

The resulting 16-bit value becomes the highest user-memory address accepted by
source, symbol and output-space checks. `U-TOP -1` wraps naturally to `$FFFF`.
A careless value can remove protection from memory that the application itself
needs; the command assumes an informed machine-code user.

## E.10 Symbol-table commands

The TABLE family operates on the ordinal vector and the alphabetically sorted
symbol records described in Chapters 23 and 24.

| Form | Action |
|---|---|
| `TABLE` | Display the symbol table. |
| `TABLE P` | Use the table-printing form supported by the command parser. |
| `TABLE L` | Lock every current symbol against removal by TABLE C. |
| `TABLE U` | Unlock current symbols. |
| `TABLE C` | Collect unused symbols, compact records and vectors, and rewrite source ordinals. |

A vector has a LOCK bit and a state bit. During ordinary assembly the state bit
marks definition. During TABLE C it is temporarily reused as a reachability
mark. A symbol survives collection when it is locked or referenced by retained
source.

TABLE C is a true compacting operation. It can move physical symbol records,
renumber ordinals and rewrite every compressed source expression that contains
one of those ordinals. It is therefore expected to take noticeably longer than
a simple display or lock operation.

## E.11 Pseudo-instructions

PROMETHEUS recognizes ordinary Z80 mnemonics through its instruction table and
also provides the following assembly-control words.

| Pseudo-instruction | Purpose | Pass behavior |
|---|---|---|
| `ENT expression` | Set the address used by RUN after successful assembly. | Ignored in pass one; expression evaluated in pass two. |
| `EQU expression` | Define the line's label with the value of the expression. | Evaluated in pass one; no pass-two emission. |
| `ORG expression` | Set both logical assembly address and physical output pointer. | Applied in both passes. |
| `PUT expression` | Change only the physical output pointer; preserve the logical assembly address. | Applied in both passes. |
| `DEFB expr[,expr...]` | Emit one byte for each expression. | Count in pass one; emit low bytes in pass two. |
| `DEFM string[,string...]` | Emit character bytes. | Count in pass one; emit in pass two. |
| `DEFS expr[,expr...]` | Reserve space by advancing addresses without writing bytes. | Advance only. The implementation accepts the parsed item form used by the common data list. |
| `DEFW expr[,expr...]` | Emit each 16-bit value low byte first. | Count two bytes per item, then emit little-endian words. |

### ORG and PUT together

```text
ORG #8000       logical = #8000, output = #8000
PUT #A000       logical remains #8000, output becomes #A000
```

A label and branch assembled after the PUT still have logical addresses near
`#8000`, while their machine-code bytes are written near `#A000`.

### DEFM quote forms

PROMETHEUS retains its historical quote conventions. In the apostrophe form the
last emitted character receives bit 7; the double-quote form emits ordinary
character bytes. Doubled delimiters are handled by the string parser. This is a
compact assembly-language convention, not a general Spectrum BASIC string
syntax.

## E.12 SAVE, VERIFY and LOAD in the editor

PROMETHEUS source files contain compressed source together with the symbol table
needed to decode symbol ordinals.

| Command | Purpose |
|---|---|
| `SAVE` | Save the current source-and-symbol image. |
| `SAVE b` | Save the selected source block and the symbol information needed by it. |
| `VERIFY` | Compare tape against the parameters and filename retained by the preceding SAVE. |
| `LOAD` | Load a PROMETHEUS source-and-symbol image. |
| `GENS` | Import supported GENS/MASM source instead of the native format. |

A filename follows the command's colon form where requested by the prompt. The
implemented wildcard rule is narrower than one might expect: a blank **first
filename character** selects wildcard behavior. The code repeatedly tests that
first byte; it does not require all ten filename positions to be spaces.

VERIFY is intentionally stateful. It is not a general command with a fresh full
parameter set. Use it immediately after the corresponding SAVE operation so the
self-modified tape parameters still describe the intended block.

LOAD and GENS are not transactional modern importers. They transform and insert
material as they proceed. A late failure can therefore leave already imported
source in memory.

## E.13 Entering and leaving the monitor

Use `MONITOR` from the editor. The monitor maintains its own front panel and a
saved processor image. Press `Q` to return to PROMETHEUS.

The monitor's current address is a central cursor. Many commands use it without
prompting; shifted variants commonly ask for an explicit First address.

## E.14 Monitor address navigation

| Key | Action |
|---|---|
| `M` | Prompt for a new current memory address. |
| cursor up | Move current address back by one byte. |
| `ENTER` | Move current address forward by one byte. |
| cursor down | Decode the current instruction and advance by its length. |
| cursor right | Prompt for a child address and push the former navigation level. |
| cursor left | Return to the preceding saved navigation level. |
| `CS+0` | Clear and restore the monitor display. |
| `Q` | Return to the editor. |

The left/right mechanism is a ten-entry address stack. It is useful when following
pointers or calls: move down into a referenced address, then return to the prior
view without retyping it.

## E.15 Monitor expression input

Monitor prompts share the assembler's left-to-right expression evaluator. They
accept:

```text
12345          decimal
#8000          hexadecimal
%10101010      binary
'A' or quoted values as accepted by the parser
$              current assembly/monitor address in the active context
SYMBOL         an existing PROMETHEUS symbol
+ - * / ?      the supported left-to-right operators
```

There is no conventional precedence hierarchy. Use the expression language as
described in Chapter 22 rather than assuming a modern compiler's rules.

For tape commands, an input beginning with `:` is returned as a filename form
instead of being evaluated as a number. Not every tape handler gives that form a
meaning; notably, monitor J expects a numeric leader.

`EDIT` abandons a monitor prompt and returns to the front panel.

## E.16 Monitor front-panel controls

| Key | Action |
|---|---|
| `SS+W` | Enter the front-panel descriptor editor. |
| `SS+N` | Set the selected register or displayed value. |
| `SS+B` | Swap primary and alternate register sets in the saved processor image. |
| `SS+M` | Toggle the saved interrupt-enable state. |
| `SS+3` | Toggle decimal/hexadecimal number display. |
| `SS+X` | Toggle instruction-control processing. |
| `X` | Cycle direct execution policy through NON, DEF and ALL. |
| `6` | Edit the direct CALL/RST target list. |

The direct execution modes mean:

| Mode | Meaning during tracing |
|---|---|
| NON | Do not execute CALL/RST targets natively; keep them under monitor interpretation. |
| DEF | Execute natively only when the target occurs in the direct-call list. |
| ALL | Execute every CALL/RST target natively. |

The direct-call table accepts up to ten addresses. In its table editor, `I`
inserts a new address and digit keys remove displayed entries according to the
numbered list.

Native execution is fast but is outside several instruction-by-instruction
protections. See Appendix G before treating ALL mode as equivalent to traced
execution.

## E.17 Viewing and assembling memory

| Key | Action |
|---|---|
| `L` | List memory from the current address. |
| `SS+L` | Prompt for an address, then list memory. |
| `O` | List character interpretation from the current address. |
| `SS+O` | Prompt for an address, then list characters. |
| `SPACE` | Assemble one line into memory at the current address. |
| `E` | Enter continuous memory-assembly mode. |
| monitor clear-list key (`CS+2` in the normalized table) | Clear the front-panel list window. |

The one-line assembler is the ordinary PROMETHEUS tokenizer and two-pass engine
borrowed for a temporary line. It honors the resident-memory output check used by
normal compilation. Continuous E mode updates its origin after each successful
line.

Memory and character listing read RAM directly. They are inspection commands,
not simulated user instructions, and therefore do not necessarily consult the
configurable READ windows.

## E.18 Disassembly controls

| Key | Action |
|---|---|
| `SS+4` | List disassembly from the current monitor address. |
| `V` | Prompt for a starting address and list disassembly. |
| `D` | Send ranged disassembly to the printer. |
| `SS+D` | Reverse-disassemble a range into PROMETHEUS source. |
| `C` | Toggle numeric address display in disassembly. |
| `SS+C` | Cycle the broader address-printing policy. |

Interactive list output follows the monitor continuation convention: holding a
key streams rows; releasing pauses; another non-EDIT key resumes; EDIT returns
to the panel.

Reverse disassembly uses the same neutral line buffer as screen and printer
output, then submits each generated line through the ordinary source-record
encoder. It is therefore subject to source capacity and parser errors. The
operation has a correction path for a failed generated line rather than a
separate private source writer.

## E.19 Searching memory

| Key | Action |
|---|---|
| `G` | Define and find a five-byte masked pattern. |
| `N` | Continue to the next occurrence of the saved pattern. |

For each of five positions, the prompt accepts a value and mask representation
through the monitor expression path. The compact search compares only bits
selected by the mask. A wildcard byte therefore uses a zero mask.

The scan advances through the 16-bit address space and can wrap through `$FFFF`.
It has no independent end address. Use N with awareness that the next match may
be on the other side of the address wrap.

## E.20 Moving and filling blocks

Every range uses an inclusive First and Last endpoint unless the shifted command
asks for Length.

| Key | Form | Action |
|---|---|---|
| `I` | First, Last, To | Move a block with overlap-safe direction selection. |
| `SS+I` | First, Length, To | Same operation using length. |
| `P` | First, Last, Byte | Fill an inclusive range. |
| `SS+P` | First, Length, Byte | Fill by length. |

MOVE behaves like `memmove`: it chooses forward or backward copying according
to overlap. MOVE and FILL reject writes into PROMETHEUS's resident/source area
through the command-specific resident check. They do not use the five editable
WRITE windows that govern traced program instructions.

## E.21 Protection and display-area tables

Number keys `1` through `5` open five related range tables:

| Key | Table |
|---|---|
| `1` | addresses to display as `DEFB` regions during disassembly |
| `2` | addresses to display as `DEFW` regions during disassembly |
| `3` | READ-protected ranges for traced instructions |
| `4` | WRITE-protected ranges for traced instructions |
| `5` | RUN-protected ranges for traced execution |

Each table can hold five visible user ranges. In the editor:

| Key | Action |
|---|---|
| `I` | Prompt for First and inclusive Last and append a range. |
| `0`..`4` | Remove the correspondingly numbered visible range. |
| `EDIT` or normal exit action | Return to the monitor. |

READ, WRITE and RUN tables contain an additional hidden dynamic range protecting
PROMETHEUS itself. It is not one of the five displayed user entries.

Display-area classification is based on the starting address of a decoded item.
A multi-byte item crossing a range boundary is not split into two different
disassembly formats.

## E.22 Execution and tracing controls

| Key | Action |
|---|---|
| `SS+Z` | Execute one monitored instruction at the current address. |
| `T` | Trace slowly, presenting each step. |
| `SS+T` | Trace quickly until a prompted address. |
| `W` | Set or use the persistent breakpoint/run start control. |
| `SS+U` | Run natively to a temporary breakpoint. |
| `SS+H` | CALL a prompted subroutine with the saved user register state. |

Single-step mode copies a suitable instruction to a scratch trampoline, executes
it, captures the processor state and repairs control flow when the copied
instruction's original address matters. Calls, returns, relative jumps,
interrupt returns and block operations need special handling.

Slow and fast trace use the same stepping engine with different presentation and
stopping policies. The saved interrupt state can be toggled independently with
`SS+M`.

Persistent and temporary native breakpoints replace a target byte with a trap
instruction and restore it when hit. A breakpoint that is never reached remains
installed until another path restores or replaces it; this is one reason to use
native execution carefully.

## E.23 Monitor tape commands

### Save arbitrary memory

| Key | Prompts |
|---|---|
| `S` | First, Last, then Leader or `:filename` |
| `SS+S` | First, Length, then Leader or `:filename` |

A numeric Leader saves one raw block with that low-byte flag and no Spectrum
header. A `:filename` builds a standard seventeen-byte CODE header, waits for
tape in the ordinary header path, then saves a `$FF` data block. The header load
address is First.

Monitor SAVE deliberately does not reject reversed or wrapped ranges and does
not call the resident-range checker. The 16-bit subtraction simply supplies the
length accepted by the ROM path.

### Load arbitrary memory

| Key | Prompts |
|---|---|
| `J` | First, Last, numeric Leader |
| `SS+J` | First, Length, numeric Leader |

J rejects a reversed/wrapped destination and a destination intersecting the
resident PROMETHEUS/source region. It then loads exactly one raw block whose flag
matches Leader. The handler has no meaningful filename branch; use a numeric
leader.

### Inspect a tape header or leader

`Y` reads the next tape block as a header-sized object.

- For a valid `$00` header, it displays filename, length and the two header
  parameters. Pressing `J` then loads the immediately following data block to
  the address in parameter 1, with the displayed length and flag `$FF`.
- For a non-header block, it reports the observed leader/flag and returns.

The Y-followed-by-J path treats parameter 1 and length as a CODE-style
destination. It does not restrict the displayed header type to a semantic CODE
header before offering that raw follow-up interpretation.

## E.24 Monitor list-output continuation

Memory, character and disassembly lists share one continuation protocol:

```text
hold a key       continue producing rows
release key      pause
press non-EDIT   resume
press EDIT       stop and return to panel
```

This permits both rapid streaming and line-by-line inspection without separate
pause commands.

## E.25 Installer controls

The temporary installer runs at `$5000`. It displays a proposed five-digit
installation address, a Monitor Yes/No choice, normal and highlighted colours,
text style and keyboard echo. Every accepted setting change returns through a
synthetic redraw address, so the entire panel immediately reflects the result.

| Key | Installer action |
|---|---|
| digit `0`..`9` | Replace the current address digit and move the underscore cursor right. |
| DELETE | Erase the preceding address digit and move the cursor left. |
| `ENTER` | Commit settings, copy the selected resident image, patch it, relocate it and start it. |
| `M` | Toggle Monitor Yes/No. |
| `I` | Cycle normal-text INK. |
| `P` | Cycle normal-text PAPER. |
| `B` | Toggle normal-text BRIGHT. |
| `CS+I` | Cycle highlighted-line INK. |
| `CS+P` | Cycle highlighted-line PAPER. |
| `CS+B` | Toggle highlighted-line BRIGHT. |
| `D` | Toggle bold glyph rendering. |
| `C` | Cycle mixed case, forced lower case and forced upper case. |
| `X` | Increase keyboard-click duration. |
| `CS+X` | Decrease keyboard-click duration. |

The address editor accepts exactly five decimal digits. Its main protection is
field shape: it refuses to cross the colon on the left or the high-bit string
terminator on the right. It does not perform the kind of comprehensive overlap
and machine-layout validation expected from a modern installer. The user is
responsible for choosing a destination at which the selected 16,000-byte or
11,000-byte image can live.

## E.26 Common recovery rules

A few interface rules recur throughout PROMETHEUS:

- `EDIT` generally abandons the current monitor prompt or list operation.
- A syntax error in a monitor expression reopens the same prompt after displaying
  the error.
- The editor's `SS+Q` abandons the current input line rather than deleting source.
- A command that mutates packed source or symbols first checks the relevant
  capacity or resident boundary, but commands do not all share one universal
  protection policy.
- Decimal/hex mode affects presentation, not the stored machine values.
- Source block endpoints and monitor First/Last endpoints are inclusive.

## E.27 One-page condensed reference

```text
EDITOR
  CS+1 edit active line       SS+W insert/overwrite
  CS+6 next line              CS+7 previous line
  CS+3 next page              CS+4 previous page
  CS+9 delete active line     CS+SS mark block boundary
  SS+Q abandon input          ENTER submit

  A ASSEMBLY   B BASIC      C COPY       D DELETE
  E END        F FIND       G GENS       H HEX/DEC
  K START      L LOAD       M MONITOR     N NEW
  P PRINT      Q QUIT       R RUN         S SAVE
  T TABLE      U U-TOP      V VERIFY      X CLEAR
  Z REPLACE

ASSEMBLER CONTROL
  ENT EQU ORG PUT DEFB DEFM DEFS DEFW

MONITOR NAVIGATION
  M set address   up/down byte-or-instruction navigation
  left/right navigation stack   Q editor   CS+0 clear display

MONITOR MEMORY/DISASSEMBLY
  L/SS+L memory list             O/SS+O character list
  SPACE one-line assemble        E continuous assemble
  SS+4/V disassembly             D printer disassembly
  SS+D reverse disassembly       G find pattern, N next
  I/SS+I move                    P/SS+P fill

MONITOR EXECUTION
  SS+Z step   T slow trace   SS+T fast trace
  W breakpoint/run start     SS+U temporary breakpoint
  SS+H native call           X NON/DEF/ALL
  6 direct-call list         3/4/5 READ/WRITE/RUN windows

MONITOR TAPE
  S/SS+S save First/Last or First/Length
  J/SS+J load First/Last or First/Length
  Y inspect header/leader; J after a header loads its data

INSTALLER
  digits/DELETE address      ENTER install
  M monitor                  I/P/B normal colour
  CS+I/P/B highlight colour  D bold   C case
  X/CS+X click duration
```

The condensed page is useful beside the emulator. The preceding sections remain
the authority when a command has a stateful or historically surprising edge
case.
