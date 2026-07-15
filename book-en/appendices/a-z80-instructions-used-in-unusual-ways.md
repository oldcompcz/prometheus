# Appendix A: Z80 Instructions Used in Unusual Ways

This appendix is not a general Z80 instruction manual. It is a guide to the
places where PROMETHEUS asks an ordinary instruction to perform an unusual job.
The instruction itself is not mysterious. What is unusual is the surrounding
agreement about registers, flags, stack contents, writable operands or bytes
that are temporarily treated as code.

A useful rule while reading the source is:

```text
Do not ask only, “What does this instruction do?”
Also ask, “What has PROMETHEUS arranged around it so that this effect means
something larger?”
```

The following sections collect the patterns that most often make the source look
more magical than it is.

## A.1 The alternate register banks are a second workbench

The Z80 has a second copy of `BC`, `DE` and `HL`, selected by `EXX`, and a
second `AF`, selected by `EX AF,AF'`. PROMETHEUS uses these banks for three
quite different purposes.

### A.1.1 Temporary preservation without memory

A small routine can move to the alternate bank, call code that freely uses the
ordinary registers, and then move back:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ret nz
    or 020h
    ret
```

The monitor keeps useful state in the alternate bank. `readKeyCode` therefore
moves the keyboard machinery away from that state rather than pushing and
popping three register pairs individually.

This is faster and smaller than a conventional save sequence, but it creates a
local contract: code between the two `EXX` instructions must not itself assume
that the alternate bank contains ordinary monitor state.

### A.1.2 Carrying two independent machine contexts

Tape routines use `EX AF,AF'` because the Spectrum ROM expects the desired tape
flag byte and the LOAD/VERIFY carry state in the alternate accumulator and
flags. PROMETHEUS prepares the ordinary `AF`, swaps it into `AF'`, then enters
the ROM routine.

The important point is that `AF'` is not merely “saved AF” here. It is an input
channel to ROM code.

### A.1.3 Saving a user processor while the monitor keeps running

The execution monitor must preserve the program being inspected while still
having registers in which to operate. Its saved processor image lives mainly in
memory, but alternate-register exchanges are part of the transfer between the
real Z80 and that image. At the boundary, a register bank is not just scratch
space; it belongs to one of two personalities:

```text
monitor personality     user-program personality
```

This is why apparently harmless insertion of `EXX` or `EX AF,AF'` can be very
dangerous. The instruction may exchange not two temporary values but two
complete contexts.

### Reading checklist for `EXX` and `EX AF,AF'`

Before following the next instruction, determine:

1. which bank belonged to the caller;
2. whether an interrupt could occur while the banks are exchanged;
3. whether a ROM routine expects values specifically in `AF'`;
4. whether the code will return through the same exchange point;
5. whether the user-program state is live in either bank.

## A.2 The stack pointer is a movable data pointer

Most beginner programs treat `SP` as a fixed pointer to a call stack.
PROMETHEUS treats it as a register that can temporarily address any carefully
prepared word stream.

### A.2.1 Re-reading a consumed return address

The relocation-safe bootstrap calls a ROM byte that contains a plain `RET`:

```asm
    call ROM_ImmediateRET
bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
```

`CALL` writes the address after the call onto the stack. The ROM `RET` consumes
that word. Two `DEC SP` instructions move the stack pointer back over the same
bytes, and `POP BC` reads the return address as data.

PROMETHEUS now knows a physical address inside the loaded image even though the
image may not have been loaded at its nominal assembly address.

This is not stack corruption. It is a deliberate rewind of a word that is known
to remain in RAM after `RET` has advanced `SP`.

### A.2.2 `EX (SP),HL` as a two-way handoff

At installer entry, one useful address is in `HL` and another is at the top of
the temporary stack. The installer exchanges them:

```asm
    ex (sp),hl
```

After the exchange:

- `HL` contains the original physical load base, needed for display;
- the stack contains the physical payload pointer, needed later when ENTER
  commits the installation.

The instruction performs a swap between a register and a persistent deferred
argument. No extra two-byte variable is required.

### A.2.3 A table disguised as a stack

The installer configuration patch table is a series of signed 16-bit
displacements. The installer points `SP` at that table and lets helper calls
`POP` successive displacements.

Conceptually:

```text
SP -> delta 1, delta 2, delta 3, ...

repeat:
    POP next delta
    add delta to current patch pointer
    write selected setting
```

This is compact because `POP` is a short, fast little-endian word reader that
also advances the stream pointer automatically. The cost is that ordinary
subroutine nesting cannot use the same stack during the walk unless the code
has arranged a separate continuation path.

### A.2.4 Resetting abandoned control flow

`startMonitor` and editor warm entries load `SP` with `internalStackTop`.
This intentionally discards old frames. A parser error, cancelled tape
operation or monitor command may have escaped through a patched continuation
rather than unwinding every ordinary call. Resetting `SP` makes the warm entry a
control-flow checkpoint.

The invariant is not “every CALL is matched by a RET.” It is:

```text
Every long-lived mode eventually returns to an entry that installs a known
stack.
```

### A.2.5 Running with the user's real stack

Native monitor CALL and breakpoint operations restore the saved user `SP`
before executing user code. This is necessary for authentic `CALL`, `RET`,
`PUSH`, `POP` and interrupt behavior. It also means the saved stack must point to
writable, valid RAM. The manual's warning about the stack is therefore an exact
machine requirement, not general caution.

## A.3 Synthetic calls made from `PUSH` and `RET`

The Z80 has no `CALL (HL)` instruction. PROMETHEUS often obtains the same effect
by pushing an address and executing `RET`.

### A.3.1 Table dispatch

The monitor key dispatcher computes a handler address in `HL` from a compact
list of deltas. On a match it performs:

```asm
    push hl
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

The `RET` pops the computed handler into `PC`. The handler sees the current
monitor address in `HL`, exactly as if an indirect call instruction existed.

Beneath the synthetic handler address is another address, `startMonitor`, pushed
before dispatch began. When the handler eventually executes its own `RET`, it
returns to the monitor redraw loop.

The stack therefore contains a deliberately constructed two-level call chain:

```text
top -> selected handler
       startMonitor
```

### A.3.2 Installer handlers that all redraw

The installer pushes `installerRedrawAndWait` before checking the selected key.
Most key handlers merely update one byte and `RET`. Their return redraws the
screen and resumes input.

ENTER is different: it removes or bypasses that synthetic return because it is
leaving the installer permanently.

### A.3.3 Entering the relocated resident with `RET`

After copying and relocating the selected image, the installer creates a fresh
resident stack, pushes the chosen entry address and executes `RET`. This avoids
an absolute `JP` whose target would depend on installation mode and destination.

### A.3.4 Why `JP (HL)` is not always used instead

`JP (HL)` changes control flow but does not create a return address. It also
requires the target to remain in `HL`, which may be needed as an argument.
The `PUSH`/`RET` pattern can:

- make an indirect call;
- pass `HL` to the target after pushing the target;
- place an outer continuation beneath it;
- use any register pair or table result to construct the target.

## A.4 Return addresses used as inline data pointers

Several PROMETHEUS routines place data immediately after a `CALL`:

```asm
    call installerPrintInlineString
    defb "Text", "!"+080h
    ; execution continues here
```

The called routine pops its return address and treats it as a pointer to the
inline bytes. After finding the high-bit terminator, it jumps to the byte after
the data.

The same technique is used for one-byte monitor prompt tokens:

```asm
    call promptForMonitorValue
    defb 0c4h
```

Here the return address points to a single token. The routine consumes that byte,
pushes the corrected continuation and opens the shared input editor.

This pattern saves:

- a separate pointer load;
- a separately labelled short string or token;
- an extra return-address correction table.

It also means a disassembler that blindly treats bytes after every `CALL` as
instructions will display nonsense. Source readers must know which call targets
consume inline data.

## A.5 Flags as small return values

PROMETHEUS frequently returns a decision in one flag rather than in a byte.
This is common Z80 practice, but several idioms are easy to misread.

### A.5.1 `CP A` as “return equal”

A helper may validate a range and finish with:

```asm
    cp a
    ret
```

`CP A` always sets Z and clears carry because A equals itself. It is a compact
way to return “yes” without changing A.

The classification helpers `isNumber` and `isLetter` use this convention: Z
means the character belongs to the class.

### A.5.2 `OR A` and `AND A` as carry clearing

`OR A` and `AND A` leave A numerically unchanged but clear carry and set Z from
A. They often prepare an unsigned `SBC HL,DE` comparison:

```asm
    or a
    sbc hl,de
```

Without the first instruction, an old carry would subtract one extra unit.

The source uses both `OR A` and `AND A`; the choice may reflect nearby byte
layout or original coding style rather than a different algorithm.

### A.5.3 `SCF` followed by `CCF`

Carry sometimes represents an inverted condition. The source uses `CCF` after a
comparison to adapt one helper's convention to another rather than repeating
the comparison.

### A.5.4 Conditional CALL as a display policy

Slow and fast tracing use opposite conditions on panel repaint calls:

```asm
    call c,redrawFrontPanelAtCurrentAddress
```

or

```asm
    call nc,redrawFrontPanelAtCurrentAddress
```

The preceding key test has intentionally returned its state in carry. The call
is not testing an arithmetic overflow; it is implementing “show each step” or
“suppress display while this chord is held.”

### A.5.5 Preserving a ROM result across a keyboard poll

Tape helpers need the carry returned by ROM LD-BYTES, but also need to test
SPACE. They use:

```asm
    push af
    ; poll port $FE
    pop af
    ret
```

The `PUSH AF` is not primarily saving A. It is preserving the success flag while
an unrelated hardware test destroys flags.

## A.6 Flag-preserving delay and wrap tests

A characteristic loop appears in the installer, keyboard repeat and beeper:

```asm
    dec hl
    inc h
    dec h
    jr nz,loop
```

or:

```asm
    inc hl
    inc h
    dec h
    jr nz,loop
```

`INC H` followed by `DEC H` restores H to its original value, but the final
`DEC H` sets Z according to that value. The pair is therefore a compact way to
test whether H is zero without changing the 16-bit counter value left in HL.

This should not be “simplified” to `LD A,H / OR A` without checking byte size,
flags, timing and historical identity. In a sound or keyboard delay, timing is
part of behavior.

## A.7 Block instructions used as algorithms

### A.7.1 `LDIR` as copy, clear and fill

The same instruction performs several jobs depending on the first byte and the
relative positions of HL and DE.

To clear a range:

```asm
    ld hl,start
    ld de,start+1
    ld (hl),0
    ld bc,length-1
    ldir
```

The zero written at the first byte is repeatedly copied forward.

To fill with an arbitrary byte, the first destination byte is written explicitly
and then replicated in the same manner.

To copy, HL and DE simply identify separate source and destination ranges.

### A.7.2 `LDDR` as the backward half of `memmove`

When the destination begins inside a source range at a higher address, a forward
copy would overwrite bytes before they are read. PROMETHEUS moves both pointers
to the inclusive last byte and uses `LDDR`.

The installer selects `LDIR` or `LDDR` because the final resident destination may
overlap the still-loaded installation image.

### A.7.3 Repeated instructions and the execution monitor

`LDIR` and `LDDR` are special in supervised execution. Their memory effects span
ranges, not one source and one destination byte. PROMETHEUS calculates the full
ranges from saved `HL`, `DE`, `BC` and direction, checks protection, calculates
`21 * BC - 5` T states, then lets the real processor execute the repeated
instruction in the scratch trampoline.

## A.8 Indirect jumps and indirect control-flow reconstruction

### A.8.1 The real Z80 indirect jumps

The Z80 provides:

```asm
jp (hl)
jp (ix)
jp (iy)
```

PROMETHEUS's execution monitor cannot copy such an instruction into scratch RAM
and expect the scratch address to become the next program counter. It detects the
instruction and takes the logical destination from the saved user register.
The copied jump bytes are neutralized, and the selected register value is fed to
the state-capture path.

### A.8.2 Indexed handler vectors

Many PROMETHEUS tables store one-byte displacements from the entry that contains
them. A dispatcher loads a displacement, adds it to the entry's own address and
jumps or returns through the result.

The vector is therefore relocatable without the installer touching it:

```text
target = address_of_this_vector_byte + signed_or_unsigned_delta
```

The exact bias differs by table, so always read the consumer before interpreting
a byte as an offset.

### A.8.3 Patched `JP` and `CALL` operands

A label such as `varcPostCommandContinuationJump` often names an instruction
whose two operand bytes are changed at runtime. Execution remains an ordinary
absolute jump; only its destination has become state.

The important distinction is:

```text
indirect jump through register      target supplied at execution time
self-modified absolute jump         target stored earlier in instruction bytes
```

## A.9 The refresh register is not an ordinary counter

The Z80 `R` register increments as instruction opcodes are fetched. Bit 7 has
special behavior and is not simply part of the low seven-bit refresh count.
PROMETHEUS saves the user's `R`, executes monitor and trampoline instructions,
and later corrects the saved value so the displayed/restored state more closely
matches execution without the monitor's extra fetches.

`adjustSavedRefreshRegisterLow7` changes bits 0–6 while preserving bit 7. The
breakpoint cleanup uses a correction equivalent to decrementing the low seven
bits by one; other trace paths use corrections appropriate to their extra
fetches.

This mechanism is necessarily delicate:

- prefixes count as opcode fetches;
- copied scratch instructions add fetches not present at the original address;
- monitor entry and capture paths add more;
- bit 7 must survive low-seven-bit correction.

A replacement that merely increments or decrements the whole byte would be
wrong at the `$7F/$80` boundary.

## A.10 Code operands used as variables

PROMETHEUS often stores persistent state inside an instruction already needed by
the algorithm:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

Writing to `varcMonitorCurrentAddress+1` changes the immediate word. Later
executing the instruction loads the remembered value.

Common shapes are:

| Instruction shape | Bytes used as state |
|---|---|
| `LD A,n` | one mode byte, count or Boolean |
| `LD HL,nn` / `LD DE,nn` | pointer or 16-bit value |
| `CALL nn` | callback target |
| `JP nn` | continuation target |
| `CP n` | remembered comparison value |
| `LD SP,nn` | saved retry or restore stack |
| one-byte opcode | mode whose value is executed |

The `varc...` prefix in the reconstructed source warns that the bytes are both
instruction and storage.

### A.10.1 Opcode-valued state

Some settings are represented by an opcode because executing the setting is
cheaper than testing it. Examples include:

- `NOP`, `RET Z` or `RET` for direct-CALL policy;
- `NOP` or `RRCA` for normal/bold installer glyphs;
- `AND n` or `OR n` forms for case transformation;
- `JP nn` changed to `LD HL,nn` to redirect monitor input completion into the
  one-line assembler path.

In the last example, only the first opcode byte changes. The following two bytes
remain a useful word. Under `$C3` they are a jump target; under `$21` they are an
immediate value loaded into HL. Execution then falls through into another path.
This is code-shape reuse, not merely a patched branch.

### A.10.2 Rules for changing a `varc` field

When modifying such code, verify all of the following:

1. the label names the instruction start or the exact operand byte intended;
2. the write has the right width;
3. no interrupt or alternate entry can execute the instruction while half
   patched;
4. relocation metadata still identifies origin-dependent words;
5. assembler-only installation still adjusts omitted-prefix references;
6. any descriptor that overlays the same bytes is still valid.

## A.11 Temporary execution trampolines

The monitor cannot safely execute every inspected instruction at its original
address under observation. It constructs a short program in scratch memory.
A simplified trampoline is:

```text
restore interrupt state
restore user registers
execute copied or substituted instruction
capture the resulting user state
return to monitor stack
```

### A.11.1 Why a copied instruction is not enough

Control-flow instructions refer to their original location or manipulate the
stack. Relative jumps copied elsewhere would calculate from the scratch address.
Calls would push a scratch return address. Returns would leave the trampoline.
Indirect jumps would never reach the capture tail.

PROMETHEUS therefore classifies the instruction and may replace, surround or
neutralize it:

- ordinary sequential instruction: copy and fall into capture;
- conditional relative branch: arrange separate taken and untaken captures;
- `CALL`: predict target and return behavior, or execute natively under selected
  direct-call policy;
- `RET`: read target from saved stack and advance saved SP;
- `RST`: synthesize its vector and stack effect;
- `JP (HL/IX/IY)`: use saved register as next PC;
- `RETN/RETI`: partly reconstructed, with interrupt-return details explicitly
  left uncertain.

### A.11.2 Scratch bytes may be instructions only briefly

The scratch area is writable work memory. It may contain prefixes, a copied
opcode, a displacement, callback jumps and state-capture fragments for one
step, then be overwritten for the next. A static disassembly of this area is not
a permanent description of the program.

## A.12 Code and data deliberately overlap

Some tables are shaped so that a byte can be both the last table element and the
first byte of a useful instruction reached after a successful lookup. The flag
editor's condition table is one example. Elsewhere bytes that look like `RST
$38` are descriptor masks with value `$FF`, not calls to the interrupt routine.

The safe rule is:

```text
A byte is code only on a demonstrated execution path.
Its mnemonic appearance is not evidence.
```

This is especially important around:

- front-panel capability tables;
- control-flow and memory-access descriptors;
- operation dictionaries;
- monitor flag selectors;
- relocation exception words;
- compact command workspaces.

## A.13 Instructions whose side effects are intentionally borrowed

PROMETHEUS often chooses an instruction because of a secondary effect.

| Instruction | Borrowed effect |
|---|---|
| `CALL` | leaves a physical self-address or inline-data pointer on stack |
| `RET` | indirect jump through a constructed stack word |
| `POP` | reads and advances a compact word stream |
| `EX (SP),HL` | swaps a live argument with a deferred one |
| `INC/DEC H` pair | sets Z while restoring H |
| `RRA` | moves one keyboard bit into carry |
| `RRCA` | moves attribute bits into ULA-port positions or transforms glyph row |
| `LDIR` | copy, clear or fill depending on initial byte arrangement |
| `DJNZ` | delay timing as well as loop counting |
| `CP A` | unconditional Z=1, C=0 result |
| `OR A` | clear carry before 16-bit subtraction |
| `RST $10` | compact ROM character output after channel setup |
| `RST $38` bytes | in some tables, simply the byte `$FF`, not execution |

## A.14 A method for reading any suspicious sequence

When a short sequence looks like a trick, use this order:

1. **Find the entry contract.** Which registers, flags, stack words and writable
   operands are already prepared?
2. **Mark code and data boundaries.** Does the routine consume bytes after a
   call? Is the table opcode-shaped?
3. **Track SP explicitly.** Write down every pushed word and every synthetic
   continuation.
4. **Name the flag.** Replace “carry” with its local meaning: tape success,
   BREAK not pressed, range valid, display suppressed, and so on.
5. **Check alternate banks.** Decide which personality owns each bank.
6. **Search writes to operands.** A constant in the listing may be runtime state.
7. **Follow both exits.** A missing `RET` may be intentional fall-through into a
   warm entry.
8. **Distinguish emulation from native execution.** The monitor sometimes checks
   and simulates, sometimes lets the processor run directly.
9. **Consult Appendix G.** A few paths, especially RETN/RETI, are documented as
   uncertain rather than silently regularized.

PROMETHEUS becomes much easier to read once these techniques stop looking like
isolated cleverness. They form a consistent style: exploit instruction side
effects, reuse bytes, keep state close to the code that consumes it, and reset
whole control contexts at safe boundaries.
