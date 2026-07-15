# Chapter 40: One Decoder, Several Destinations

A disassembler can easily become a collection of almost-identical routines.
One routine prints to the screen. Another prints to paper. A third converts the
same bytes into editable source. A fourth fills a little window in the register
panel. If each version performs its own instruction decoding, the program grows
larger and the versions slowly disagree.

PROMETHEUS avoids that trap. It has one central act:

```text
machine address
    -> one canonical 32-column line in lineBuffer
    -> next machine address
```

After that act, another routine decides where the line should go.

This chapter is about that second half. Chapter 39 explained how bytes become a
mnemonic, operands, optional symbols and a possible blank separator. We will now
follow the finished line to four different destinations:

1. the monitor's scrolling list window;
2. the fixed disassembly area in the front panel;
3. Spectrum output channel 3, normally a printer;
4. the PROMETHEUS source editor.

The important lesson is larger than disassembly. On a small machine, a useful
intermediate representation is often worth more than several clever special
cases.

## The neutral meeting place

The neutral form is `lineBuffer`. It is exactly thirty-two bytes wide because
that is the width of the Spectrum screen and the ordinary source-line renderer.
It may contain:

- a numeric address prefix;
- a label field;
- mnemonic and operand fields;
- trailing spaces;
- an entirely blank separator line.

The decoder does not print while it is deciding what the instruction means. It
finishes the line first and returns the address of the next item in `HL`:

```asm
    call disassembleNextLineToBuffer
    ; lineBuffer now contains one complete row
    ; HL now points at the next machine-code address
```

This contract is deliberately plain. A caller does not need to know whether the
line came from:

- an ordinary instruction;
- a forced `DEFB` byte;
- a forced `DEFW` word;
- an unknown opcode sequence;
- a requested separator after an unconditional transfer.

It receives one line and one next address.

In pseudocode:

```text
function make_disassembly_line(address):
    if a blank separator is pending:
        clear lineBuffer
        clear pending separator
        return address

    classify address as DEFB, DEFW or instruction
    build a temporary source record
    expand that record into lineBuffer
    decorate it with address or symbol information

    if this instruction requests visual separation:
        remember that the next call must return a blank line

    return address after decoded bytes
```

The line is therefore not merely display text. It is an interchange format
between the decoder and several independent consumers.

## Destination one: the scrolling monitor list

The simplest consumer is the interactive listing entered by V or by SYMBOL
SHIFT+4. One version asks for a starting address; the other begins at the current
monitor address.

The heart of the listing is almost comically short:

```asm
monListDisassembly:
    call beginMonitorListOutputWithBlankLine
    call disassembleNextLineToBuffer
    call outputMonitorListLineAndPollContinuation
    jr $-6
```

The loop has no final address. It continues for as long as the monitor's common
list-output convention allows it:

- holding a key streams more lines;
- releasing it pauses;
- another ordinary key continues;
- EDIT returns to the monitor.

`outputMonitorListLineAndPollContinuation` does not know that the line is a
disassembly. The same general list-window machinery is used elsewhere for
memory and table output. It appends `lineBuffer`, scrolls the window when
necessary and handles continuation keys.

This is the first destination in its simplest form:

```text
repeat forever:
    address = make_disassembly_line(address)
    append lineBuffer to monitor list window
    obey list continuation keys
```

A blank separator is treated as a real visual row. Since the decoder returns the
same address for that row, the following iteration decodes the memory byte that
was waiting before the separator.

## Destination two: the front panel

The front panel needs a different kind of listing. It cannot scroll forever.
Its descriptor reserves a fixed rectangular area and says exactly how many rows
must be painted.

The special panel renderer begins by extracting that row count from the item
descriptor:

```asm
.renderFrontPanelDisassemblyWindow:
    ld a,(ix+004h)
    and 01fh
    ld b,a
    call clearPendingDisassemblySeparatorAndReturn
varcFrontPanelDisassemblyAddress:
    ld hl,00000h
```

The start address is the operand of the self-modified `LD HL,nn`. Whenever the
panel is redrawn for a new monitor address, that operand is patched. The loop is
then straightforward:

```asm
.renderNextFrontPanelDisassemblyRow:
    push bc
    call disassembleNextLineToBuffer
    call renderLineBufferAtMonitorListCursor
    pop bc
    djnz .renderNextFrontPanelDisassemblyRow
```

There are two differences from the interactive list:

1. the panel begins with no pending separator inherited from an earlier use;
2. the descriptor's count, not a keypress, decides when to stop.

The renderer still receives the same thirty-two-byte line. It merely places it
at the bitmap position selected by the panel descriptor.

The panel therefore does not own a second miniature disassembler. It owns a
short fixed-count loop around the ordinary one.

## Destination three: the printer

The D command asks for First and Last and sends a ranged disassembly to Spectrum
channel 3. In a normal Spectrum setup that is the printer channel, though the
ROM channel system may redirect it elsewhere.

The chosen output routine is placed in `HL`:

```asm
monDisassemblyOnPrinter:
    ld hl,outputLineBufferToChannel3
```

Control then falls into the common ranged driver. The driver patches the operand
of a real `CALL` instruction:

```asm
varcRangedDisassemblyOutputCall:
    call 00052h
```

At run time its operand points either to the printer sink or to the source sink
we shall meet shortly. The opcode remains `CALL`; only the two-byte destination
changes.

The printer sink itself is shared with the editor's PRINT command:

```asm
outputLineBufferToChannel3:
    ld a,003h
    call ROM_ChannelOpen
    ei
    ld hl,00010h
    call printExpandedSourceLineWithRoutine
    ld a,00dh
    rst ROM_PrintACharacter
    xor a
    ret
```

It opens channel 3, prints the already prepared row, emits ENTER and returns.
There is no disassembly logic here at all.

The ranged driver also appends every generated line to the monitor list window
before calling the selected sink. The user can therefore watch the same lines
that are being printed.

## One ranged driver

The common driver is the most important part of this chapter. Its complete
shape is:

```text
choose a per-line sink
ask for First and Last
current = First

while current < Last:
    next = make_disassembly_line(current)
    show lineBuffer in monitor list window
    send lineBuffer to selected sink

    if CAPS SHIFT+ENTER requests stop:
        finish

    current = next
```

`Last` is exclusive. If `Last` is `$8100`, an instruction beginning at `$8100`
is not emitted. An instruction beginning at `$80FF` is emitted in full even if
its operand bytes lie at `$8100` or beyond. The test concerns the start address
of each decoded item, not every byte the decoder may read.

The source implements the comparison after the sink returns:

```asm
    push hl
    or a
    sbc hl,de
    pop hl
    jr c,.processNextRangedDisassemblyLine
```

Here `HL` is the next start address and `DE` is the exclusive endpoint.

This design also means a pending blank separator participates in the range. It
does not advance `HL`, but it is emitted while another actual address still
remains below `Last`.

## Destination four: editable PROMETHEUS source

SYMBOL SHIFT+D chooses the second sink:

```asm
monDisassembleIntoSource:
    xor a
    ld (varcShowNumericDisassemblyAddresses+1),a
    ld hl,copyDisassemblyLineToInputBuffer
    jr .configureRangedDisassembly
```

Numeric address prefixes are disabled because they are display decoration, not
valid source fields. Exact symbol labels may still be generated according to
the current disassembly-address mode.

The sink copies all thirty-two bytes:

```asm
copyDisassemblyLineToInputBuffer:
    ld hl,lineBuffer
    ld de,inputBufferStart
    ld bc,00020h
    ldir
```

Then it enters the ordinary editor pipeline:

```asm
parseAndInsertDisassemblyLine:
    call clearStringBuffers
    ld hl,inputBufferStart
    call atHLorNextIfOne
    ld d,000h
    ld c,009h
    jp parseAndInsertSourceLine
```

This is a crucial architectural choice. PROMETHEUS does **not** manufacture a
persistent compressed source record directly from the disassembler's private
knowledge. It goes through the same parser as a human-entered line.

The consequences are valuable:

- mnemonic and operand spelling are checked normally;
- symbol names are resolved or created normally;
- source memory capacity is checked normally;
- record framing and backward links are constructed normally;
- every inserted line becomes canonical PROMETHEUS source.

The path is:

```text
machine bytes
    -> temporary disassembly record
    -> canonical 32-column text
    -> ordinary editor input buffer
    -> ordinary source parser
    -> persistent compressed source record
```

It may look wasteful to leave a compact record, expand it to text and compress
it again. But the two records serve different purposes. The temporary one is a
private decoding convenience. The persistent one must obey every editor and
symbol-table invariant.

## Why blank separators become real source lines

After selected unconditional jumps and returns, the disassembler asks for a
blank row. On screen or paper this improves readability. During reverse
disassembly, the same blank row is passed to the source parser and becomes an
empty source record.

That behavior is not an accident. It preserves the visual grouping in the
editable program.

Suppose memory contains:

```asm
        RET
NEXT    LD A,1
```

The inserted source may become:

```asm
        RET

NEXT    LD A,1
```

The separator is now part of the source document. It can be moved, deleted or
printed like any other empty line.

## Errors while inserting generated source

Printing is simple: a failed printer operation belongs to the ROM and the user
can stop the range with a key. Source insertion is more difficult because the
ordinary parser may abandon several nested calls when it reports an error.

Before invoking the sink, the ranged driver records the current stack pointer
inside another self-modified instruction:

```asm
    ld (recoverRangedDisassemblyInsertionError+1),sp
```

The recovery entry begins:

```asm
recoverRangedDisassemblyInsertionError:
    ld sp,00000h
    call monitorInputLoop
    call parseAndInsertDisassemblyLine
    jr .resumeRangedDisassemblyAfterOutput
```

If a generated line cannot be accepted, the normal error machinery jumps here.
Restoring the recorded `SP` discards the abandoned parser's stack frames. The
monitor then lets the user edit the offending line and tries it again.

This is a very PROMETHEUS solution:

```text
remember a safe stack level
try the ordinary parser
if it fails:
    restore that stack level
    let the human repair the generated text
    submit it again
```

There is no rollback. Lines inserted before the failure remain in the source.
If the source area fills, the practical escape is to leave the operation with
EDIT; already inserted records stay inserted.

## A small persistent side effect

Reverse disassembly writes zero into
`varcShowNumericDisassemblyAddresses+1`. It does not restore the previous value
when it finishes. Later interactive disassembly therefore also begins with
numeric prefixes hidden until the user toggles them again with C.

This is easy to miss when reading the interface and obvious when reading the
self-modifying state. The command changes a shared display preference, not a
local temporary option.

## Four uses compared

| Destination | Stop rule | What consumes `lineBuffer` | Persistent effect |
|---|---|---|---|
| Interactive list | user continuation keys | list-window renderer | none except monitor display state |
| Front panel | descriptor row count | fixed panel renderer | none |
| Printer | exclusive Last or stop chord | channel-3 output routine | external printed stream |
| Source editor | exclusive Last, error or stop chord | ordinary source parser | inserted source records and symbols |

All four begin with the same decoder and the same line.

## Following the running example

Assume memory still contains:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

and the symbol table contains `START=$8000` and `LOOP=$8002`.

### In the front panel

A three-row descriptor beginning at `$8000` requests:

```text
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

The panel loop stops because its row count reaches zero.

### In the interactive list

V begins at `$8000` and can continue beyond `$8004`. After `RET`, the next call
may produce a blank separator before decoding `$8005`.

### On the printer

D with First `$8000` and Last `$8005` prints the three instruction rows. The
exclusive endpoint prevents a new instruction from beginning at `$8005`.

### In the source editor

SYMBOL SHIFT+D with the same range copies each row into `inputBufferStart` and
submits it. After the final `RET`, no following machine address lies below the
endpoint, so a pending separator need not create an extra final source record.

The bytes have travelled all the way back into editable source without a second
instruction decoder.

## What has changed in memory

Depending on the selected destination:

- `lineBuffer` is rewritten for every generated row;
- `varcRangedDisassemblyOutputCall+1` stores the chosen sink address;
- `varcPostCommandContinuationJump+1` is temporarily redirected for source
  insertion;
- the current and exclusive endpoint are preserved on the monitor stack;
- `recoverRangedDisassemblyInsertionError+1` may remember a safe stack pointer;
- `inputBufferStart` receives generated source text;
- reverse disassembly may insert records and create symbols;
- `varcShowNumericDisassemblyAddresses+1` remains cleared after reverse
  disassembly.

The decoded machine bytes themselves are not modified.

## Important labels encountered

- `lineBuffer`
- `disassembleNextLineToBuffer`
- `monListDisassemblyFromGivenAddress`
- `monListDisassembly`
- `outputMonitorListLineAndPollContinuation`
- `.renderFrontPanelDisassemblyWindow`
- `varcFrontPanelDisassemblyAddress`
- `renderLineBufferAtMonitorListCursor`
- `monDisassemblyOnPrinter`
- `.configureRangedDisassembly`
- `.processNextRangedDisassemblyLine`
- `varcRangedDisassemblyOutputCall`
- `outputLineBufferToChannel3`
- `monDisassembleIntoSource`
- `copyDisassemblyLineToInputBuffer`
- `parseAndInsertDisassemblyLine`
- `recoverRangedDisassemblyInsertionError`
- `varcShowNumericDisassemblyAddresses`

## Ideas needed later

- The decoder's raw instruction side effects can serve execution analysis even
  when no line is printed.
- Self-modified calls are used as compact strategy selectors.
- Restoring a saved stack pointer is PROMETHEUS's way to escape an abandoned
  nested operation safely.
- The monitor distinguishes trusted tools from the user program it will later
  execute one instruction at a time.
