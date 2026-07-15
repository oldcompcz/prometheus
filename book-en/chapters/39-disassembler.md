# Chapter 39: The Disassembler

An assembler answers:

> Which bytes represent this instruction text?

A disassembler asks the opposite question:

> Which instruction text best explains these bytes?

The second question is harder. A source line contains names and intentions that
machine code may no longer preserve. Several byte sequences are invalid. Data
may resemble instructions. Relative branches store a distance rather than their
visible target. IX and IY instructions rearrange prefixes, displacements and
opcodes. A numeric address might be better printed as a symbol.

PROMETHEUS solves the problem by reusing almost the whole language machinery we
have already studied. It does not contain a separate giant text printer for Z80
instructions. It decodes bytes into a **temporary compressed source record** and
then asks the normal source-record expander to produce the final 32-column line.

That design is the heart of the disassembler.

## The top-level journey

For one item at address HL, the path is:

```text
memory bytes
    -> DEFB/DEFW area classification
    -> Z80 prefix and opcode decoder
    -> shared instruction-table lookup
    -> temporary source record
    -> ordinary source-record expansion
    -> optional symbol/address decoration
    -> 32-column lineBuffer
```

The main routine is `disassembleNextLineToBuffer`.

Its contract is simple:

```text
input:   HL = address to decode
output:  lineBuffer = one printable source-style row
         HL = address of following item
```

The following item may be:

- the next byte after a DEFB;
- two bytes after a DEFW;
- the sequential address after a valid instruction;
- the same address after an inserted visual separator row.

That last possibility will make sense shortly.

## The interactive V command

The V command prompts for a starting address. SYMBOL SHIFT+4 begins at the
current monitor address. Both then enter `monListDisassembly`:

```asm
monListDisassembly:
    call beginMonitorListOutputWithBlankLine
    call disassembleNextLineToBuffer
    call outputMonitorListLineAndPollContinuation
    jr $-6
```

This is one of the clearest high-level loops in the source:

```text
open list with a blank row
repeat forever:
    decode one item into lineBuffer
    append it to the configurable list window
    ask whether listing should continue
```

There is no Last address in the interactive listing. The user's keypress rhythm
controls its duration.

The printer and reverse-source destinations will be the subject of Chapter 40.
For now, the important point is that they call the same one-item decoder.

## Begin with a clean line

`disassembleNextLineToBuffer` first prepares an exact 32-space row. It also
remembers the item's starting address in the operand of
`varcDisassemblyInstructionAddress`.

The routine needs both values later:

```text
HL during decoding       advances to following bytes
saved start address      labels the line and computes relative targets
```

Without the saved start, a displacement such as `$FE` would be difficult to turn
back into the visible destination address.

## First ask whether the bytes are data

Before recognizing an opcode, the routine consults the two tables from Chapter
38:

```asm
    ld hl,defbDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefbDisassemblyRecord

    ld hl,defwDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefwDisassemblyRecord
```

The order is significant:

```text
DEFB wins over DEFW
DEFW wins over instruction decoding
```

The dynamically synthesized resident/source interval occurs in both tables, so
it is caught by DEFB first. This is where PROMETHEUS blocks instruction-style
disassembly of itself.

It does not hide the bytes. A resident byte can still be displayed and examined;
it is simply written as a data directive.

## Constructing DEFB and DEFW records

For DEFB, the routine reads one byte and prepares the equivalent of:

```asm
    DEFB value
```

For DEFW, it reads a little-endian word and prepares:

```asm
    DEFW value
```

Then both paths join the same temporary-record expansion used for instructions.

If normal instruction decoding fails, PROMETHEUS also falls back to DEFB for the
first byte. This guarantees progress through arbitrary memory:

```text
valid instruction  consume its full length
known DEFW area    consume two bytes
anything else      consume one byte as DEFB
```

An invalid opcode can never trap the listing at one address forever.

## A deliberately shifted temporary record

The editor's encoding workspace normally begins with a temporary length byte,
followed by the two persistent record-header bytes.

The disassembler does not need to insert the record into source yet. It starts
one byte earlier and reuses the same workspace in a shifted interpretation:

```text
encodedRecordStorageLength   temporary opcode/pseudo-opcode
encodedRecordHeader          temporary prefix/operand metadata
encodedRecordInfoByte        temporary operand/expression payload
```

With IX pointing at `encodedRecordInfoByte`, stores to `(IX-2)` and `(IX-1)`
create the two bytes the normal expander expects.

This is not accidental overlap. It is a compact adapter:

```text
disassembler output format
        becomes
source-record expander input format
```

No persistent length or backward-link marker is required because the temporary
record will not be traversed inside the compressed source list.

## Decoding instruction prefixes

If the address is not classified as data, `decodeInstructionAtHL` examines the
first bytes.

The decoder recognizes these families:

```text
ordinary opcode
CB opcode
ED opcode
DD opcode
FD opcode
DD CB displacement opcode
FD CB displacement opcode
```

It builds the same prefix-information bits used by compressed source records:

```text
bit 7  CB family
bit 6  ED family
bit 5  DD / IX family
bit 4  FD / IY family
bits 0..2 operand class
```

This shared representation is one reason the instruction table can serve both
assembler and disassembler.

## The awkward indexed-CB order

An instruction such as:

```asm
    BIT 3,(IX+5)
```

uses physical bytes in this order:

```text
DD CB displacement opcode
```

The displacement comes before the final operation byte. Most other forms place
an opcode before its operands.

The decoder handles the special form explicitly:

```text
see DD or FD
see following CB
read displacement into E
read final opcode into B
remember indexed-CB prefix bits
```

The instruction table is searched by the final opcode and normalized prefix
metadata, while the displacement is retained separately for formatting.

This mirrors the second-pass repair described in Chapter 26, but in reverse.

## RST opcodes become one family

The eight restart opcodes are:

```text
$C7 $CF $D7 $DF $E7 $EF $F7 $FF
```

Their target vector is encoded in bits 3 through 5 of the opcode. For table
lookup, PROMETHEUS canonicalizes all of them to `$C7`:

```asm
    ld a,(hl)
    and 0c7h
    cp 0c7h
```

The original vector bits are retained and later rendered as:

```text
0, 8, 16, 24, 32, 40, 48 or 56
```

One instruction-table form can therefore represent the whole RST family.

## The decoder's return values

On a valid match, `decodeInstructionAtHL` returns:

```text
HL = next sequential address
B  = canonical opcode
C  = prefix bits combined with operand class
DE = raw immediate, word or displacement bytes
AF' zero flag = set
```

On an invalid encoding, the alternate zero flag is clear. The caller then builds
DEFB.

Using alternate AF for the success result lets the routine return ordinary
register data without losing the status while nested table lookup modifies the
main flags.

The decoder also stores two facts for the future tracing engine:

- the instruction-table T-state field;
- the raw operand word.

The disassembler itself does not need timing, but decoding it once avoids doing
the same table search again during single-step analysis.

## The shared instruction table answers the central question

`decodeInstructionTableRecord` receives canonical opcode B and prefix metadata
C. It searches the same five-byte instruction table that the assembler used to
turn mnemonic/operand classes into bytes.

In the reverse direction it recovers:

```text
mnemonic-table index
first operand descriptor
second operand descriptor
operand class
```

DD and FD share table forms. A small remembered variant tells later expansion
whether the visible name should be IX or IY.

The table is therefore not merely an assembler emission table. It is a compact
bidirectional description of the supported Z80 language.

## Eight operand classes

The low three metadata bits select one of eight handlers:

```text
0  no operand bytes
1  one-byte immediate
2  two-byte word or address
3  signed relative branch
4  signed IX/IY displacement
5  signed IX/IY displacement plus immediate byte
6  RST vector carried in opcode
7  invalid
```

A compact offset table dispatches to the handler. Like many PROMETHEUS tables,
it stores small relative code offsets rather than full addresses.

The handlers do not print final punctuation themselves. They append the compact
operand/expression material that the ordinary source expander already knows how
to render.

## Relative branches must recover a target

A relative instruction stores an 8-bit signed displacement from the address
following the instruction.

For a two-byte JR or DJNZ:

```text
target = instructionAddress + 2 + signed displacement
```

Consider the running example:

```text
address       $8002
bytes         $10 $FE
```

`$FE` is signed -2:

```text
$8002 + 2 - 2 = $8002
```

The disassembler therefore writes:

```asm
LOOP    DJNZ LOOP
```

or the numeric equivalent, depending on symbol mode.

Simply printing `$FE` would describe the encoding, not the assembly-language
meaning.

## Indexed displacements keep their sign

For IX/IY addressing, an 8-bit displacement is also signed. PROMETHEUS converts
it back to a visible `+n` or `-n` form:

```text
$05  -> +5
$FB  -> -5
```

Operand class 5 additionally carries an immediate byte, as in an indexed memory
instruction that writes a literal value.

The temporary source expression is constructed in the order expected by the
normal expander, not necessarily the physical order in machine code.

## Ending the temporary record

After opcode and operand material have been assembled in the workspace, the
routine writes `$C0` as the variable-record terminal marker:

```asm
    ld (ix+000h),0c0h
    ld ix,encodedRecordStorageLength
    call expandSourceRecordToLineBuffer
```

The ordinary expander then creates:

- the mnemonic;
- register names;
- commas and parentheses;
- plus or minus signs;
- numeric formatting;
- source-field spacing;
- uppercase or lowercase according to current editor policy.

This reuse is why disassembled text looks like PROMETHEUS source rather than a
separate monitor dialect.

## Numbers or symbols

Two controls affect address presentation.

The C command toggles numeric instruction addresses at the beginning of lines.
SYMBOL SHIFT+C cycles operand/address symbol substitution.

The internal symbol modes are:

```text
1  numeric operands only
2  replace an exact value with a label
0  exact label, otherwise try label+1
```

Their cycle is:

```text
0 -> 2 -> 1 -> 0
```

The numbering is not meant to be read directly by the user. It is chosen for
compact branch behavior.

## Labels at the instruction address

After source expansion, PROMETHEUS checks whether the item's own starting
address exactly equals a symbol value.

If so, the symbol name is placed in the nine-column label field. This exact
address label may appear even when numeric-address printing is disabled.

If no exact symbol exists, the left address field is filled only when the C
setting requests numeric addresses.

This gives useful output such as:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

rather than printing a number before every line when known labels already divide
the program.

## Symbols in operands

`findSymbolOrdinalByValue` scans symbol ordinals and returns the first record
whose stored value equals the decoded target.

In the fullest mode, if exact lookup fails, PROMETHEUS tries `target - 1`. A
match becomes:

```text
SYMBOL+1
```

This modest rule is surprisingly useful. Machine code often points one byte
inside a labelled object or to the byte following a labelled instruction.

It does not attempt arbitrary offsets such as `SYMBOL+37`. The compact policy is:

```text
exact symbol
else symbol+1
else number
```

Duplicate values resolve to the first ordinal. The lookup masks the vector's
flag bits to find the symbol record but does not explicitly require the symbol
to be DEFINED or LOCKED. It trusts the stored value fields.

## Visual separators after unconditional transfers

A long disassembly is easier to read when basic blocks are separated. PROMETHEUS
requests one blank row after:

- unconditional JR;
- unconditional JP;
- JP (HL), JP (IX) or JP (IY);
- RET.

It does not insert separators after conditional branches, CALL, RST or
conditional returns.

The mechanism is self-modifying. The decoder writes a nonzero flag into the
opening immediate byte of `disassembleNextLineToBuffer`. On the next call, the
routine:

1. fills `lineBuffer` with spaces;
2. clears the flag;
3. returns without advancing HL.

The following call decodes the same next address.

Thus:

```text
instruction call   consumes bytes
separator call     consumes no bytes
next instruction   begins at unchanged HL
```

The blank line is presentation state, not a phantom memory item.

## Unknown bytes remain readable

Z80 has many prefix combinations that are unused, undocumented or absent from
PROMETHEUS's supported instruction table. Memory also contains arbitrary data.

When lookup fails, the disassembler takes the conservative path:

```asm
    DEFB byte
```

This is preferable to guessing. It preserves the byte exactly and keeps the
listing moving forward by one address.

A user can later mark a larger region as DEFB or DEFW if the fallback reveals
that the memory is structured data.

## One decoder serves more than text

Even before Chapter 40, we can see that `decodeInstructionAtHL` has several
customers:

- interactive disassembly;
- one-instruction address movement;
- printer disassembly;
- reverse insertion into source;
- instruction stepping and timing.

The textual wrapper builds a source-style line. The lower decoder returns a
machine-oriented description: opcode family, operand class, raw data, next PC
and timing.

This division is important:

```text
decodeInstructionAtHL
    understands machine-byte structure

disassembleNextLineToBuffer
    turns that structure into source-language text
```

Later execution chapters can reuse the first without pretending they need a
printed line.

## Following the running example

Memory contains:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

Assume symbols:

```text
START = $8000
LOOP  = $8002
```

At `$8000`:

```text
not in DEFB/DEFW area
opcode $06 -> LD B,n
operand class 1 -> one immediate byte
immediate = 5
temporary record -> LD B,5
exact address symbol -> START in label field
next address -> $8002
```

At `$8002`:

```text
opcode $10 -> DJNZ relative
operand class 3
$FE -> -2
target = $8002
exact target symbol -> LOOP
exact line-address symbol -> LOOP
next address -> $8004
```

At `$8004`:

```text
opcode $C9 -> RET
no operands
request separator for following call
next address -> $8005
```

The next call emits a blank row with HL still `$8005`. The call after that tries
to decode memory at `$8005`.

The final visible result is the same program we originally entered:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

The round trip is not magical. It is the shared language tables working in the
opposite direction.

## What has changed in memory

For each decoded item:

- `varcDisassemblyInstructionAddress+1` remembers its starting address;
- the shifted encoding workspace holds a temporary source record;
- `lineBuffer` receives the expanded 32-column text;
- `varcDecodedInstructionTStates` receives base timing metadata;
- `varcDecodedInstructionOperandWord` receives raw operand data;
- the separator flag may be patched for the following call.

The examined machine bytes are not modified.

## Important labels encountered

- `monListDisassemblyFromGivenAddress`
- `monListDisassembly`
- `disassembleNextLineToBuffer`
- `varcDisassemblyInstructionAddress`
- `decodeInstructionAtHL`
- `decodeInstructionTableRecord`
- `operandClassLengthAdjustments`
- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `expandSourceRecordToLineBuffer`
- `findSymbolOrdinalByValue`
- `varcDisassemblyAddressMode`
- `varcShowNumericDisassemblyAddresses`
- `varcDecodedInstructionTStates`
- `varcDecodedInstructionOperandWord`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`

## Ideas needed later

- The same generated line can be sent to screen, printer or the source editor.
- Reverse disassembly becomes safe and canonical because it returns through the
  ordinary source parser.
- Timing and raw operand side effects prepare the single-step engine.
- Instruction-control code will add effective-address and control-flow analysis
  on top of the decoder described here.
