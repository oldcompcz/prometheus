# Chapter 6: PROMETHEUS's Tiny Data Languages

A table of bytes is not automatically understandable just because we can see its numbers.

Imagine finding this sequence in memory:

```text
E0 50 C5 03 01 00 00
```

Is it a string? A machine instruction? Seven independent settings? A screen coordinate followed by flags? Without the routine that reads it, the bytes do not tell their own story.

PROMETHEUS contains many compact formats like this. Each is a tiny language with its own grammar:

- one bit may mark the final character of a word;
- one byte may be an offset measured from the byte itself;
- a stored count may be deliberately larger than the visible count;
- several option flags may share one descriptor byte;
- values that look like Z80 opcodes may actually be table entries;
- a command token may be an ordinary letter with bit 7 added.

The program saves memory by not storing information in the most obvious form. To understand it, we must learn to recognize the small language being used.

## A terminator does not need its own byte

The ordinary way to store a string is to add a special byte after it:

```text
P R O M E T H E U S 00
```

The zero does not belong to the visible word. It exists only to say “stop.”

PROMETHEUS often avoids that extra byte by borrowing bit 7 of the final character:

```text
P R O M E T H E U S-with-bit-7-set
```

ASCII letters normally fit in seven bits, so the top bit is available as a marker. A reader performs two actions for every byte:

```text
display byte AND $7F
if byte has bit 7 set:
    stop
```

The installer string printer does exactly this:

```asm
ld a,(hl)
and 07fh
; draw the character
...
ld a,(hl)
inc hl
rlca
jr nc,.installerPrintNextCharacter
```

`AND $7F` removes the marker before glyph lookup. Later `RLCA` moves the original bit 7 into carry. Carry clear means another character follows; carry set means the word is complete.

The same idea is used in several places, including symbol names and token-expansion words.

### Why this is a good bargain

A one-byte terminator seems insignificant, but a program may contain hundreds of short words. If the average word has only four or five letters, one extra byte per word is expensive.

The high-bit scheme gives PROMETHEUS:

- no separate terminator byte;
- no length byte;
- a simple sequential reader;
- the original seven-bit character still available after masking.

The cost is that the stored text is not ordinary ASCII. A generic string routine would display the final character incorrectly unless it knew the convention.

## Inline strings turn return addresses into pointers

The installer's text routine combines the high-bit marker with the stack technique from Chapter 4.

The call is followed immediately by string bytes:

```asm
ld hl,someBitmapAddress
call installerPrintInlineString
; packed characters are placed here
; execution continues after the marked final character
```

The routine pops the call's return address and uses it as the first string address. There is no separate pointer word in the instruction stream.

The format can be described as:

```text
CALL printer
character
character
final character with bit 7 set
next executable instruction
```

The printer's decoder is also its control-flow mechanism. Finding the final marked character tells it where execution must resume.

This is a miniature embedded language inside the instruction stream:

```text
CALL means “the following bytes are text until bit 7 says stop”
```

A disassembler that does not know this language may falsely decode the text bytes as instructions.

## Symbols use the same marker for a different purpose

When PROMETHEUS reads an identifier, it normalizes letters to uppercase and stores the name with bit 7 on the last character.

Conceptually:

```text
LOOP   →  L O O P|$80
START  →  S T A R T|$80
```

The source routine does not need to reserve a length byte in every permanent name. Comparison proceeds character by character until either spelling differs or the marked final character is reached.

This is a useful lesson: the same low-level encoding can support different larger systems.

- In the installer, the marked character ends inline display text.
- In the editor, it ends a token word.
- In the symbol table, it ends an identifier spelling.

The meaning of the bit is locally consistent—“this is the final character”—while the surrounding structures differ.

## A token can replace a whole word

The edit-line buffer may contain ordinary characters, but it can also contain bytes at or above `$80`. Such a byte represents a complete word or command token.

The common renderer decides which case it has:

```asm
displayInputTokenOrCharacter:
    cp 080h
    jr c,displayUninvertedCharacter
    ...
```

A byte below `$80` is displayed directly. A byte at or above `$80` indexes a token-offset table.

In pseudocode:

```text
if byte < $80:
    display byte
else:
    word = findPackedWordForToken(byte)
    display word until its high-bit final character
    display one following space
```

This means an input line can keep a command or assembler word in one byte instead of repeating all its letters.

The compact form is useful not only for storage. It also tells the parser that the word has already been recognized as a known token.

## The offset table points from itself

The token renderer does not store a full 16-bit pointer for every word. It uses a one-byte relative offset:

```asm
varcTokenExpansionTableBase:
    ld hl,08d6fh
    ld d,000h
    ld e,a
    add hl,de
    ld e,(hl)
    add hl,de
```

After selecting a table entry, it reads one byte and adds that byte to the entry's own address. The result is the packed word.

Conceptually:

```text
entryAddress = tableBase + tokenIndex
wordAddress  = entryAddress + memory[entryAddress]
```

This is a **self-relative pointer**. Its value is meaningful only in relation to where the byte is stored.

Why use one byte instead of a two-byte address?

- every table entry is half the size;
- relocation is unnecessary when the table and words move together;
- nearby strings can be reached cheaply;
- the decoder is only a few instructions.

The limitation is distance. The target must be close enough to fit the chosen one-byte interpretation. The source layout is therefore part of the format.

## Some offset bytes happen to be valid Z80 instructions

The disassembler uses another self-relative table:

```asm
disassemblyOperandHandlerOffsets:
    ld e,c
    ld d,e
    daa
    add hl,de
    nop
    dec b
    ld c,h
    daa
```

This looks like eight peculiar instructions. It is actually eight data bytes.

The comments reveal their real purpose: each opcode byte numerically equals the distance from `formatIndexedDisplacementOperand` to one of eight operand handlers.

The dispatch logic reads the selected byte as data:

```asm
ld hl,disassemblyOperandHandlerOffsets
add hl,bc
ld c,(hl)
ld hl,formatIndexedDisplacementOperand
add hl,bc
jp (hl)
```

In pseudocode:

```text
offset = operandHandlerOffsets[operandClass]
handler = firstOperandHandler + offset
jump handler
```

Why write the table using instruction mnemonics rather than `DEFB` values?

The historical binary only cares about the bytes. In reconstructed source, an opcode mnemonic can preserve the exact byte while making it obvious why a naive disassembler once saw executable-looking instructions there. The surrounding comment is essential: without it, the reader would try to invent a nonsensical execution path through `LD E,C`, `DAA` and `NOP`.

This is a recurring warning:

> Bytes are not code merely because they decode as legal instructions.

On an 8-bit processor, most byte values decode to something.

## Self-relative structures move as a unit

Suppose a table entry at address `$8000` contains `$20`. Its target is:

```text
$8000 + $20 = $8020
```

If the whole table and target are moved together by `$1000`, the entry is now at `$9000` and the target at `$9020`. The stored byte `$20` remains correct.

This is why self-relative data is naturally relocatable.

Absolute pointer:

```text
store $8020
must be repaired when moved
```

Self-relative offset:

```text
store $20
still correct when both parts move together
```

PROMETHEUS uses this property to reduce both storage and relocation work.

## A count may include an invisible bias

The monitor's protection and disassembly-area tables begin with a count byte, but the number is not simply the number of user-entered ranges.

For example:

```asm
defbDisassemblyAreaTable:
    defb 002h
    defw $5DC0,$9C38
```

The initial visible custom-range count is zero, yet the stored count is two.

The table language says:

```text
stored count = 2 + number of user ranges
```

This is a **biased count**.

Why begin at two?

The consumer uses the value as part of a compact loop that also accounts for a hidden dynamic resident range and its own termination convention. Starting from the biased representation avoids extra special-case code every time the table is scanned.

The user thinks in visible ranges:

```text
0, 1, 2, 3, 4 or 5 custom ranges
```

The table stores:

```text
2, 3, 4, 5, 6 or 7
```

The program pays a small mental cost in exchange for simpler machine code.

## Hidden and visible entries can share one table

The first range words in the protection tables are placeholders. When checking memory, PROMETHEUS replaces them temporarily with the current dynamic resident interval:

```text
First = relocated PROMETHEUS start
Last  = current end of resident code, source and symbols
```

After that hidden interval come user-editable ranges.

The complete conceptual format is:

```text
byte 0      biased count
bytes 1-2   hidden First placeholder
bytes 3-4   hidden Last placeholder
next 4      user range 1
next 4      user range 2
...
```

One decoder can therefore check both compulsory program protection and optional user protection.

The table is not simply a list the user sees. It is a language shared by the interface and the safety machinery.

## A descriptor is a sentence compressed into fixed fields

The monitor front panel contains 34 seven-byte descriptors. Each descriptor tells a generic renderer what to place on the screen.

A simplified layout is:

```text
+0,+1  bitmap address
+2     heading or special selector
+3     format and source flags
+4     size and capability flags
+5,+6  address of displayed value
```

Consider the list-window descriptor:

```asm
frontPanelListWindowItem:
    defb 000h
    defb 040h
    defb 0a0h
    defb 003h
frontPanelListWindowSizeFlags:
    defb 08bh
    defw 0
```

Those seven bytes say approximately:

```text
place this special area at bitmap address $4000
use selector $A0
render it as a special panel region
allow variable size
show eleven rows
no ordinary value pointer is needed
```

The byte `$8B` combines two ideas:

```text
bit 7     variable size is allowed
low 5 bits = 11 visible rows
```

A renderer can process many different panel items because each descriptor is a tiny instruction to the renderer.

This is data-driven programming. Instead of writing separate drawing code for `BC`, `DE`, `HL`, `IX`, `IY`, memory windows and cycle counts, PROMETHEUS stores their differences in records and reuses common code.

## Bit fields let one byte answer several questions

Descriptor byte `+3` contains several independent choices:

```text
bit 7  decimal display
bit 6  hexadecimal display
bit 5  binary display
bit 4  character display
bit 3  one-byte or two-byte values
bit 2  horizontal or vertical layout
bits 1..0 source/rendering class
```

This is a miniature set of switches packed into one byte.

To test hexadecimal mode, code can use:

```asm
bit 6,(ix+3)
```

To keep only the source class:

```asm
ld a,(ix+3)
and 003h
```

To toggle one option:

```text
descriptorByte = descriptorByte XOR optionBit
```

The same byte is meaningful only because reader and writer agree on the bit assignments. That agreement is the grammar of the descriptor language.

## Fixed-size descriptors make navigation cheap

Every front-panel item occupies exactly seven bytes. The panel editor stores an offset into the table, so moving to the next item means adding seven.

```text
current descriptor offset + 7 = next descriptor
current descriptor offset - 7 = previous descriptor
```

No pointer table is required. No variable-length record must be skipped. The fixed record size becomes part of the navigation algorithm.

This is a common PROMETHEUS trade:

- a little unused space may appear in some records;
- in return, indexing and traversal become extremely small.

## Command bytes combine character and category

PROMETHEUS sometimes turns a letter into a command token by setting bit 7:

```asm
set 7,a
```

An ordinary lowercase letter might be:

```text
'a' = $61
```

The command-token version becomes:

```text
$E1
```

The low seven bits still identify the character family, while bit 7 says “interpret this as a token, not literal text.”

This allows the edit line to contain both what the user typed and what the program has already recognized.

It also explains why several routines protect bytes with bit 7 set. Moving a cursor into the middle of a one-byte token and treating it like a visible character would damage the line's grammar.

## A marker can be part of the editable data

The edit-line buffer contains another reserved byte:

```text
$01 = cursor marker
$00 = end of line
```

The cursor is not stored only in a separate variable. It physically travels through the buffer by exchanging places with neighbouring bytes.

A simplified line may look like:

```text
L D [cursor=$01] space A comma B 00
```

Rendering interprets `$01` as a cursor glyph. Cursor-left and cursor-right swap that marker with nearby characters. Insertion moves it and the trailing terminator through an in-place exchange chain.

The buffer is therefore a tiny language containing:

- ordinary character bytes;
- compact token bytes `$80+`;
- one cursor marker `$01`;
- one zero terminator.

The raw bytes are not the same as the visible line.

## Value-and-mask pairs describe a search pattern

The monitor's five-byte search feature stores ten bytes as five pairs:

```text
(value, mask)
(value, mask)
(value, mask)
(value, mask)
(value, mask)
```

An ordinary requested byte uses:

```text
mask = $FF
```

A wildcard uses:

```text
mask = $00
```

Comparison is:

```text
(memoryByte XOR value) AND mask
```

If the result is zero, the position matches.

Why does a zero mask create a wildcard?

```text
anything AND $00 = 0
```

The value byte becomes irrelevant.

This two-byte mini-language can describe exact bytes and “don't care” positions with one comparison loop.

## Many tiny languages are really tiny interpreters

A format is useful only because a routine interprets it.

Examples now seen include:

| Data language | Interpreter |
|---|---|
| high-bit string | packed-character rendering loop |
| token offset table | `displayInputTokenOrCharacter` |
| operand-handler offsets | disassembler dispatch logic |
| biased range table | protection/range checker |
| seven-byte panel descriptor | generic front-panel renderer |
| cursor/token edit buffer | common input-line renderer and mutator |
| value/mask pairs | monitor memory finder |

The table and routine form a pair. Reading only one usually creates confusion.

A good question when encountering unfamiliar bytes is:

> Which code advances through this structure, and what does it do after each field?

That code is the grammar book.

## Why PROMETHEUS invents several formats instead of one universal format

A universal record system would be easier to document, but probably larger.

PROMETHEUS chooses a format for each job:

- sequential text uses a final-character bit;
- nearby targets use one-byte relative offsets;
- repeated display objects use fixed seven-byte descriptors;
- memory ranges use a biased count and four-byte entries;
- editable text needs in-band cursor and token markers;
- search patterns use value/mask pairs.

Each language is small because it supports only the operations required by its consumer.

This is the same economy seen in self-modifying state. PROMETHEUS rarely pays for generality it does not need.

## How to avoid being fooled by tables

When a region of source looks strange, use this checklist.

### 1. Find the label at the start

A descriptive label often identifies the consumer or purpose.

### 2. Find every reference to the label

A table used only by one routine is best understood from that routine.

### 3. Determine the unit of movement

Does the reader increment by one byte, two bytes, four bytes or seven bytes?

### 4. Look for masks and shifts

Operations such as `AND`, `BIT`, `RLCA` and `ADD` often reveal packed fields.

### 5. Ask whether values are absolute or relative

A byte added to its own address is not an ordinary number.

### 6. Check for biased or sentinel values

A stored zero, one or two may mean “empty” rather than a literal count.

### 7. Do not trust accidental disassembly

Legal opcodes can still be pure data.

## Back to the whole machine

The earlier overview described PROMETHEUS as an editor, assembler and monitor. We can now see that it is also a collection of small interpreters.

The editor interprets a mixed stream of characters, tokens, a cursor marker and a terminator.

The symbol machinery interprets high-bit-terminated names and ordinal vectors.

The monitor interprets seven-byte display descriptors and biased protection ranges.

The disassembler interprets opcode tables and self-relative formatter offsets.

The installer interprets inline strings, configuration deltas and relocation streams.

The program remains compact because much of its behavior is moved out of repeated code and into dense data understood by shared routines.

This completes the first layer of our Z80 survival kit. We now know how to follow register roles, how instructions double as variables, and how compact tables act as tiny languages. The next two chapters will use these ideas to explain safe movement through memory and direct communication with the Spectrum hardware.

## What has changed in memory?

The formats discussed here occupy several kinds of memory:

- packed strings end by marking the final character's top bit;
- token tables store one-byte offsets to nearby packed words;
- operand dispatch stores eight self-relative handler offsets;
- protection tables contain a biased count, one hidden dynamic range and user ranges;
- front-panel items occupy fixed seven-byte records;
- the edit buffer contains character, token, cursor and terminator bytes;
- memory-search patterns occupy five value/mask pairs.

Most of these structures are changed only through routines that understand their grammar. Editing individual bytes without that context can make the table internally inconsistent.

## Source anchors introduced

- `installerPrintInlineString`
- `parseSymbolNameAndFindOrdinal`
- `displayInputTokenOrCharacter`
- `varcTokenExpansionTableBase`
- `disassemblyOperandHandlerOffsets`
- `dispatchDisassemblyOperandHandler`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `checkRangeAgainstProtectionTable`
- `checkAddressAgainstProtectionTable`
- `frontPanelItemDescriptors`
- `frontPanelListWindowItem`
- `frontPanelListWindowSizeFlags`
- `inputBufferStart`
- `varcInputBufferPosition`
- `monitorFindByteMaskPairs`
