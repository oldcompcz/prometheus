# Chapter 35: Address Navigation and Monitor Input

The editor has an active source line. The monitor has a **current address**.

That address is the centre of the monitor's world. The small disassembly window
begins there. Memory listings can begin there. SPACE and E assemble machine code
there. A single step executes the instruction there. Most table-dispatched
monitor commands receive it in HL before they begin.

The address is therefore more than a number shown on screen. It is the monitor's
position in machine-code space.

This chapter explains how PROMETHEUS moves that position, how it asks the user
for addresses and other expressions, how it safely retries after input errors,
and how the same machinery edits saved register values.

## The current address is stored inside an instruction

The persistent value appears in:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

The two operand bytes of this `LD DE,nn` instruction are the monitor's current
address. Code that needs to remember a new address writes into
`varcMonitorCurrentAddress+1`.

When a table-dispatched command is selected, `startMonitor` reloads the word into
HL before returning into the handler:

```asm
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

This gives the compact handler family a common contract:

```text
entry: HL = current monitor address
exit:  ordinary RET redraws the monitor
```

A handler that wants to change the current address eventually reaches:

```asm
setMonitorCurrentAddressAndRet:
    ld (varcMonitorCurrentAddress+1),hl
    ret
```

The next warm monitor entry redraws the disassembly window and all address-based
panel items from the new value.

## Moving by one byte

Two commands make the simplest possible movement:

```text
cursor up  → previous byte
ENTER      → next byte
```

The corresponding code is deliberately shared:

```asm
monOneByteBack:
    dec hl
    dec hl

monOneByteForward:
    inc hl
setMonitorCurrentAddressAndRet:
    ld (varcMonitorCurrentAddress+1),hl
    ret
```

Entry at `monOneByteBack` performs two decrements and then falls through one
increment, for a net movement of minus one. Entry at `monOneByteForward`
performs only the final increment.

This looks odd when read line by line. Read as three entry points, it is compact:

```text
BACK:     HL = HL - 1
FORWARD:  HL = HL + 1
STORE:    currentAddress = HL
```

Sixteen-bit arithmetic wraps naturally. Moving forward from `$FFFF` reaches
`$0000`; moving backward from `$0000` reaches `$FFFF`.

## Moving by one instruction

Cursor down advances by the decoded length of the instruction at the current
address:

```asm
monOneInstructionForward:
    call decodeInstructionAtHL
    jr setMonitorCurrentAddressAndRet
```

`decodeInstructionAtHL` returns HL at the byte following the decoded item. It
may be a one-byte instruction, a prefixed instruction of several bytes, or a
forced `DEFB`/`DEFW` item in a configured data area.

The movement command therefore shares the same interpretation as the visible
disassembly. The monitor does not keep a second instruction-length decoder.

This is an important invariant:

```text
what the disassembler says is one item
    =
what cursor-down skips as one item
```

Chapter 39 will explain how the decoder reaches that answer.

## Setting an address explicitly

The M command prompts for a memory address. Its handler is compact because it
falls through the same movement entries:

```asm
monSetCurrentAddress:
    call promptForMonitorValue
    defb 0c4h
    inc hl

monOneByteBack:
    dec hl
    dec hl

monOneByteForward:
    inc hl
```

After the prompt returns a value in HL, the net arithmetic is:

```text
+1 -1 -1 +1 = 0
```

The value is stored unchanged.

The inline byte `$C4` is not an instruction executed after the call. It is the
monitor text token for the prompt. `promptForMonitorValue` removes the return
address from the stack, consumes the token byte and pushes a corrected return
address pointing after it.

The source can therefore read almost like this imaginary syntax:

```text
address = prompt("Memory")
```

without storing a separate prompt pointer.

## A ten-level navigation path

The cursor-left and cursor-right commands do more than subtract or add. They
provide a small navigation history.

`monitorNavigationAddressStack` contains:

```text
byte 0     depth, 0..10
bytes 1..  ten little-endian saved addresses
```

This stack is unrelated to:

- the Z80's real SP;
- the saved user SP;
- traced CALL and RET instructions.

It belongs only to the monitor's address browser.

### Going down to a child address

Cursor right prompts for a new address. If fewer than ten levels are stored, it:

1. increments the depth;
2. stores the old current address in the new slot;
3. makes the prompted address current.

Conceptually:

```text
if depth < 10:
    navigation[depth] = currentAddress
    depth += 1
    currentAddress = prompt("Memory")
```

This is useful while following pointers or calls. A reader can leave an address,
inspect a related address and later return.

### Going back up

Cursor left does nothing at depth zero. Otherwise it decrements the depth,
retrieves the corresponding saved address and makes it current.

```text
if depth > 0:
    depth -= 1
    currentAddress = navigation[depth]
```

PROMETHEUS calls the operations “level down” and “level up,” as if the user were
moving through a tree of related addresses rather than through a chronological
browser history.

The stack is not automatically tied to disassembled CALL instructions. The user
chooses when an address is a child worth remembering.

## The monitor borrows the editor's input line

PROMETHEUS already has a capable line editor:

- a guarded buffer;
- the movable `$01` cursor marker;
- insertion and deletion;
- token expansion;
- normalized keyboard input;
- expression parsing;
- error messages.

The monitor reuses it rather than implementing a second one.

`monitorInputBuffersInitialization` restores this shape:

```text
$80 guard | $01 cursor | zero-filled remainder
```

`renderMonitorInputLine` temporarily selects the monitor token table and calls
the ordinary input-line renderer at the bitmap row described by
`frontPanelEditLineItem`.

`monitorInputLoop` then follows the familiar cycle:

```text
render line
read and normalize one key
edit the shared buffer
repeat until ENTER
```

EDIT abandons the request and jumps directly to `startMonitor`.

## Prompt text is protected from DELETE

A monitor prompt is stored as a high-bit token followed by the cursor marker.
For example:

```text
$C2 $01 ...   → "First" followed by the editable cursor
```

Before allowing DELETE, `monitorInputLoop` looks at the byte immediately before
the cursor. If bit 7 is set, the byte is a prompt token and deletion is ignored.

The user can edit the answer but cannot backspace into the fixed prompt.

This is a very small form of field protection implemented entirely through the
in-band token representation.

## One routine, many prompt words

A call site looks like:

```asm
    call promptForMonitorValue
    defb 0c2h
```

The routine:

1. pops the call's return address;
2. reads the byte at that address as a prompt token;
3. increments the address;
4. pushes the corrected continuation;
5. initializes the input buffer with `[token,$01]`.

PROMETHEUS uses tokens such as:

```text
First
Last
Memory
Length
Call
```

without passing an ordinary register argument or allocating a word-sized
pointer at every call site.

This is the inline-string technique of Chapter 6 reduced to a one-byte compact
vocabulary.

## The answer is a full expression

After ENTER, the normal prompt completion path jumps to
`evaluateInputExpression`.

The answer can therefore be more than a literal address. It can use the same
left-to-right expression language as assembler source:

```text
#8000
32768+5
TABLESTART+2
$+16
%1000000000000000
```

Here `$` has the ordinary expression meaning established by the relevant
assembler/monitor state. Defined symbols can be used, so monitor work remains
connected to source names.

This makes the prompt line feel like a tiny command language rather than a
numeric keypad.

## The colon exception

Tape commands may accept a filename beginning with a colon. After input,
`promptForMonitorValue` checks the first editable character:

```asm
    cp 03ah
    ret z
```

If it is `:`, the routine returns without trying to evaluate the rest as an
expression. The caller can interpret the remaining characters as filename text.

Thus the same prompt editor supports two result types:

```text
ordinary input  → evaluate and return a 16-bit value
colon input     → return the text form to a tape command
```

The exception is explicit and small; the common editing machinery remains
shared.

## Safe retry after a parser error

An expression parser may leave through the shared `signalError` path rather than
return normally. If the monitor simply called it, the parser's stack unwinding
could abandon several monitor return addresses and make retry unsafe.

PROMETHEUS solves this by remembering the prompt's stack pointer inside an
instruction:

```asm
monitorInputRestart:
    ld sp,00000h
```

At prompt setup, the current SP is written into this operand. The shared
`errorAction` hook is redirected to `retryMonitorInputAfterError`.

On an error, that handler:

1. prints the ordinary PROMETHEUS message on the monitor edit row;
2. waits briefly so it can be read;
3. jumps to `monitorInputRestart`;
4. restores the exact prompt stack;
5. clears temporary parser strings;
6. reopens the same line for correction.

In pseudocode:

```text
savedPromptSP = SP

retry:
    SP = savedPromptSP
    edit answer
    try evaluate

on parser error:
    show message
    goto retry
```

This is not exception handling in a modern language, but it solves the same
problem: restore a known command context and let the user fix the input.

## The completion instruction changes meaning

The three bytes at `monitorInputCompletionDispatch` normally form:

```asm
    jp evaluateInputExpression
```

For monitor line assembly, PROMETHEUS changes only the opcode byte from `$C3`
(`JP nn`) to `$21` (`LD HL,nn`). The two address bytes remain unchanged.

The same bytes then mean:

```asm
    ld hl,evaluateInputExpression
```

That instruction is harmless setup, and execution falls through into
`assembleMonitorInputLine` instead of jumping to the expression evaluator.

So one self-modified opcode chooses the result type:

```text
$C3  prompt answer is an expression
$21  entered text is one assembly source line
```

Chapter 36 will follow the assembly path. Here the important idea is that the
input editor itself does not care what completion means.

## Editing saved register values

SYMBOL SHIFT+N invokes `setRegisterValue`. The initial line contains a tokenized
`LD ` followed by the cursor:

```text
LD _
```

The user enters forms such as:

```text
LD HL,#8000
LD A,65
LD X,BUFFER
```

PROMETHEUS does not keep a special register-name table for this command. It scans
the first twenty-four front-panel descriptors beginning at
`frontPanelRegistersItems`.

Those descriptors already contain:

- the visible name selector in byte 2;
- byte/word information in byte 3;
- the destination address in bytes 5 and 6.

The display description becomes an editing description.

In pseudocode:

```text
for each editable panel descriptor:
    if entered name matches descriptor heading:
        value = evaluate remaining expression
        destination = descriptor.valueAddress
        store byte or word according to descriptor
        return

error "Bad operand"
```

This is a particularly elegant reuse. A register shown on the panel and a
register accepted by `LD` cannot silently drift into different name lists,
because both are described by the same record.

## Which values can be assigned?

The scan covers:

```text
A B C D E H L I R
HX LX HY LY
F AF BC DE HL SP IX IY
T X Y
```

A one-byte descriptor stores only the low result byte. A word descriptor stores
the ordinary little-endian pair. T, X and Y are treated as words by their heading
selector class even though they are not all Z80 register names.

Assignments modify the **saved user state** or panel-owned address variables.
They do not overwrite the monitor's temporary working registers. That is why
the changes remain visible after the command returns and the panel redraws.

## The F shorthand

F accepts ordinary numeric assignment, but it also supports compact flag
toggles:

```text
LD F,S
LD F,Z
LD F,P
LD F,C
```

The letters select masks:

```text
S  $80
Z  $40
P  $04
C  $01
```

The selected bit is XORed into the saved F byte, so the command toggles rather
than simply setting it.

The mask table overlaps executable bytes in a very compact code/data trick. The
last mask is immediately followed by the opcode and address of a real
`LD DE,savedRegisterAF`, after which a tiny XOR/store tail performs the change.

For a young reader, the safe way to understand this region is not to simulate
its accidental linear disassembly. Read it as:

```text
four (letter,mask) records
followed by a shared toggle routine
```

## One complete address-entry journey

Suppose the current monitor address is `$8000` and the user presses M, enters:

```text
LOOP+2
```

and presses ENTER.

The path is:

```text
startMonitor dispatches M with HL=$8000
    ↓
monSetCurrentAddress calls promptForMonitorValue
    ↓
inline token creates the fixed "Memory" prompt
    ↓
monitorInputLoop edits the shared line buffer
    ↓
expression evaluator resolves LOOP and adds 2
    ↓
fall-through arithmetic leaves the result unchanged
    ↓
setMonitorCurrentAddressAndRet stores it in the LD DE operand
    ↓
RET reaches synthetic startMonitor
    ↓
panel redraw begins disassembly at the new address
```

Nothing in this path requires a special “address parser.” PROMETHEUS composes
its ordinary keyboard, line editor, token renderer, expression evaluator and
warm monitor redraw.

## One complete register-edit journey

For:

```text
LD HL,BUFFER
```

PROMETHEUS:

1. constructs the fixed `LD ` prefix;
2. accepts the rest through `monitorInputLoop`;
3. scans descriptor headings until HL matches;
4. evaluates `BUFFER` through the ordinary symbol-aware expression parser;
5. reads the destination pointer `savedRegisterHL` from the descriptor;
6. sees that HL is a word item;
7. stores the two result bytes;
8. returns to a complete panel redraw.

The `(HL)` memory panel item is indirect through the same saved word, so it
immediately begins showing memory at the new address as well.

One assignment therefore updates several visible consequences without special
coordination.

## What has changed in memory?

Address navigation may change:

- the operand of `varcMonitorCurrentAddress`;
- the depth and saved words in `monitorNavigationAddressStack`.

Prompt handling temporarily changes:

- `inputBufferStart` and its cursor position;
- `monitorInputCompletionDispatch`'s opcode;
- the saved SP operand in `monitorInputRestart`;
- the shared `errorAction` hook;
- temporary parser strings.

Register editing changes the saved user register area, `accumulatedTStates`, or
monitor-owned X/Y address variables selected by the matched descriptor.

## Ideas needed by later chapters

- The current address is the starting point for listings, disassembly and
  execution.
- Prompt input is ordinary editor input with a different completion action.
- Parser errors can safely retry because the command stack is restored.
- Register editing reuses front-panel descriptor names and destinations.
- Cursor-down depends on the same decoder that will later power disassembly and
  stepping.

## Source coverage

This chapter explains `varcMonitorCurrentAddress`, `monSetCurrentAddress`, byte
and instruction movement, `monitorNavigationAddressStack`, `monLevelUp`,
`monLevelDown`, `promptForMonitorValue`, `monitorInputBuffersInitialization`,
`renderMonitorInputLine`, `monitorInputLoop`, monitor input error recovery,
`monitorInputCompletionDispatch` and `setRegisterValue`.
