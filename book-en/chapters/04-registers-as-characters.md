# Chapter 4: Registers as Temporary Characters in a Story

When people first learn assembly language, registers are often presented as a list to memorize:

- `A` is the accumulator;
- `B`, `C`, `D`, `E`, `H` and `L` are general-purpose registers;
- `BC`, `DE` and `HL` are register pairs;
- `IX` and `IY` are index registers;
- `SP` is the stack pointer;
- `PC` is the program counter.

That description is correct, but it is not yet useful enough for reading a large program. It tells us what the registers *can* do, not what they *mean at this moment*.

In PROMETHEUS, a register is better imagined as an actor who changes costume between scenes. In one routine, `HL` is the address of source text. A few calls later, it is a screen position. Elsewhere, the same pair holds a number being formatted. The processor does not remember these meanings. They exist only in the agreement between a routine and its callers.

This chapter is therefore not a catalogue of Z80 registers. It is a lesson in following their changing roles without becoming lost.

## A routine creates a temporary vocabulary

Consider this very small helper:

```asm
addAtoHL:
    add a,l
    ld l,a
    ret nc
    inc h
    ret
```

Its job is simple: add the unsigned 8-bit value in `A` to the 16-bit address in `HL`.

The Z80 has no instruction meaning “add `A` directly to `HL`.” PROMETHEUS therefore adds `A` to the low byte `L`. If that addition crosses a 256-byte page, the carry flag is set and `H` must be incremented.

In pseudocode:

```text
HL.low = HL.low + A
if that addition overflowed:
    HL.high = HL.high + 1
return HL
```

Inside this tiny routine, the temporary vocabulary is:

```text
A  = unsigned offset
HL = base address, then resulting address
carry = overflow from the low byte
```

That vocabulary ends at `RET`. The next routine may give every register a different meaning.

This is the first habit needed for reading PROMETHEUS:

> Do not ask what a register normally means. Ask what the current routine promises it means.

## Register pairs are often more important than single registers

The Z80 is an 8-bit processor, but addresses are 16 bits wide. PROMETHEUS therefore works constantly with pairs:

```text
BC = B as the high byte, C as the low byte
DE = D as the high byte, E as the low byte
HL = H as the high byte, L as the low byte
```

If `HL` contains `$8123`, then:

```text
H = $81
L = $23
```

This pairing is not just a convenience. Many Z80 instructions treat a pair as one 16-bit object:

```asm
ld hl,$8123
inc hl
add hl,de
push hl
pop hl
jp (hl)
```

PROMETHEUS takes advantage of this constantly. A pair may be:

- an address in source memory;
- the first or last address of a block;
- a byte count;
- a computed symbol value;
- a screen bitmap position;
- the next assembled output address.

The individual halves are still available. That allows compact tricks such as `addAtoHL`, but it also creates danger. If `HL` is a pointer and a routine borrows `H` as an unrelated counter, the pointer has been damaged unless it was saved first.

## The common travelling formation: source, destination and count

Memory-moving routines often use a familiar arrangement:

```text
HL = source
DE = destination
BC = number of bytes
```

This arrangement fits the Z80 block-copy instruction `LDIR`, which repeatedly performs the equivalent of:

```text
memory[DE] = memory[HL]
HL = HL + 1
DE = DE + 1
BC = BC - 1
```

until `BC` becomes zero.

PROMETHEUS also needs backward copying when source and destination overlap in the wrong direction. The high-level purpose remains the same, even though the registers may be adjusted to the ends of the ranges before `LDDR` is used.

When later chapters discuss insertion of a source record, movement of the symbol table or installation of the resident image, this three-register formation will return again and again.

It is useful to read it almost as a sentence:

```text
copy BC bytes from HL to DE
```

That sentence is much easier to remember than three unrelated register names.

## A register can carry a value and a decision

A routine often returns a useful address or byte in registers and a second answer in the flags.

Consider this boundary comparison:

```asm
compareHLWithSourceBufferStart:
    push hl
    push de
    ld de,sourceBufferAccessLine
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

The caller supplies a candidate pointer in `HL`. The routine subtracts the permanent source-buffer start only to establish a relation. It then restores both register pairs before returning.

The candidate pointer therefore survives unchanged, while carry reports the answer:

```text
carry set   = candidate is below the source-buffer start
carry clear = candidate is at or above it
```

The `POP` instructions do not disturb the comparison flags, so the restored `HL` and the carry result can travel back together.

This is a common PROMETHEUS style:

```text
useful value remains in registers
answer about that value remains in flags
```

Typical returned decisions include:

- found or not found;
- inside or outside a range;
- valid or invalid;
- equal, lower or higher;
- carry set to mean “yes.”

This can feel mysterious when reading only one side of the call. A routine call is much clearer when we note both parts of its result.

## Carry is PROMETHEUS's favourite one-bit envelope

The carry flag began life as an arithmetic flag, but assembly programs commonly use it as a one-bit return value.

For example, the monitor's range-checking machinery uses carry to report containment. Conceptually:

```text
carry clear = address or range is allowed
carry set   = address or range intersects a protected interval
```

The caller can then react directly:

```asm
call checkAddressAgainstProtectionTable
jr c,.buildDefbDisassemblyRecord
```

The branch reads naturally once the contract is known:

```text
if the address is protected:
    show it as data instead of decoding an instruction
```

Carry is especially convenient because many comparison and addition instructions already produce it. A good Z80 programmer often arranges the calculation so the useful decision appears in carry without needing to store an extra byte.

The book will always explain such a convention when it matters. Carry does not have one global meaning across PROMETHEUS. It only has the meaning promised by the current routine.

## Preserving a register means preserving a promise

Suppose a caller needs `HL` after a subroutine, but the subroutine uses `HL` internally. The ordinary solution is the stack:

```asm
push hl
call someRoutine
pop hl
```

This is sometimes described mechanically as “save and restore `HL`.” The deeper reason is:

> The caller has a continuing meaning attached to `HL`, and the callee is about to borrow the physical register.

A representative fragment from the input renderer does exactly this:

```asm
displayInputTokenOrCharacter:
    cp $80
    jr c,displayUninvertedCharacter
    push hl
    push de
    ; locate and render the expanded token
    ...
    pop de
    pop hl
```

Here `HL` belongs to the caller's scan through the input buffer, and `DE` may belong to another surrounding operation. Token expansion needs both registers for table lookup and text traversal, so it borrows them behind the caller's back and returns them unchanged.

The pushes are not decoration. They maintain the larger story.

## The stack is more than a place for return addresses

Every `CALL` automatically places a return address on the stack. `RET` removes it. PROMETHEUS also uses the stack for:

- saving register pairs;
- passing temporary values through a routine that needs the registers;
- reversing the order of data;
- remembering several nested addresses;
- deliberately taking control of a return address.

The inline-string printer provides a striking example:

```asm
installerPrintInlineString:
    ld (varcInstallerStringDestination+1-...),hl
    pop hl
    ...
    jp (hl)
```

The caller places text immediately after the `CALL` instruction. Normally the return address would point to the next instruction. Here it points to the first character of that text.

The routine removes the return address with `POP HL`, treats it as a string pointer, advances through the marked final character, and finally performs `JP (HL)` to continue after the inline data.

In pseudocode:

```text
stringPointer = popReturnAddress()
print characters beginning there
stringPointer = byte after final character
jump stringPointer
```

The stack has temporarily changed role. It still carried an address, but the address was interpreted as data before becoming control flow again.

This technique will be revisited in Chapter 6 because it also depends on a compact string terminator.

## `IX` and `IY` are useful when fields have fixed positions

`HL` is excellent for walking through a sequence. `IX` and `IY` are excellent for referring to fields around a stable base address.

The disassembler builds a temporary compressed source record using `IX`:

```asm
ld ix,encodedRecordInfoByte
ld (ix-1),c
ld (ix-2),b
```

The base register points at one known field. Nearby fields are addressed with signed displacements:

```text
IX-2 = opcode byte
IX-1 = information byte
IX+0 = first expression byte
```

This resembles a tiny structure in a higher-level language:

```text
record.opcode = B
record.info   = C
record.expression begins here
```

The Z80's indexed instructions are longer and slower than ordinary `(HL)` access, so PROMETHEUS does not use them everywhere. They are most valuable when a routine needs several named positions around one object without constantly moving the base pointer.

## The alternate register bank is a second desk

The Z80 contains shadow copies of several registers:

```text
AF  ↔ AF'
BC  ↔ BC'
DE  ↔ DE'
HL  ↔ HL'
```

`EX AF,AF'` swaps the accumulator and flags. `EXX` swaps `BC`, `DE` and `HL` with their alternate versions.

This does not copy values. It exchanges which set is currently visible.

Imagine a desk with two drawers. Instead of moving six objects one by one, `EXX` closes one drawer and opens the other.

PROMETHEUS uses this when two activities need their own temporary register world. The inline-string printer keeps its source string pointer in one bank while the glyph renderer uses the other bank for font and screen addresses:

```asm
ld a,(hl)
and $7F
exx
; calculate and draw glyph using the other HL/DE/BC
...
exx
ld a,(hl)
```

The monitor also protects its alternate registers when it calls the shared keyboard routine:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ...
```

The important point is not that the alternate bank is “faster storage.” It is that it allows two overlapping stories to keep separate casts of registers.

The cost is mental. After an `EXX`, the names `HL`, `DE` and `BC` refer to different physical values than they did one instruction earlier. Good comments and clear routine boundaries are essential.

## Registers may hold code metadata, not user data

The disassembler shows another kind of role assignment. After decoding an instruction, it uses:

```text
B = canonical opcode
C = prefix and operand-class metadata
DE = raw operand bytes
HL = next sequential address
```

These values do not directly belong to the user program's live processor state. They are *descriptions* of an instruction.

A later routine takes the low three bits of `C`, selects an operand handler and constructs text or a temporary source record. The same physical registers that elsewhere represent memory blocks now represent facts about machine-code grammar.

This is why names in prose are valuable. Instead of saying:

> The routine masks C, loads C from `(HL)`, then adds BC to HL.

we can say:

> The routine uses the operand class to select a self-relative formatter entry.

The real code remains available, but the temporary vocabulary makes its purpose visible.

## A routine can change the meaning halfway through

Large routines sometimes reuse registers after an earlier phase is finished. This saves pushes, memory variables and code bytes.

For example, a parser may begin with:

```text
HL = input pointer
DE = output buffer pointer
C  = remaining capacity
```

After the field is copied, `HL` may become a table pointer and `DE` may hold a numeric value. This is legal because the earlier meanings are no longer needed.

The safest way to read such code is in phases:

```text
Phase 1: scan input
Phase 2: classify token
Phase 3: build encoded form
```

At each boundary, rewrite the register vocabulary in your notes. Trying to preserve one meaning for an entire long routine creates confusion that the original code does not have.

## Some instructions deliberately manufacture flags

A curious instruction such as:

```asm
cp a
```

compares `A` with itself. The value cannot differ, so the zero flag is set and carry is cleared.

Why not just return?

Because the caller expects a result in the flags. The routine is manufacturing the promised answer.

Other common flag-setting idioms include:

```asm
or a       ; test A, clear carry
and a      ; test A, clear carry
scf        ; set carry
inc a      ; alter zero without altering carry
```

These instructions may look pointless if read only as arithmetic. They are meaningful as preparation of the routine's outgoing condition.

Later chapters will point out the exact contract rather than expecting the reader to memorize every flag side effect immediately.

## A practical method for following registers

When a routine becomes difficult, make a small table before reading every instruction:

| Register | Meaning at entry | Meaning at return |
|---|---|---|
| `HL` | source-record address | next record or preserved pointer |
| `DE` | destination buffer | end of produced data |
| `BC` | byte count | zero or preserved value |
| `A` | option or current byte | result code |
| flags | unspecified | carry means success/failure |

Then divide the body into phases and update the table when meanings change.

For a call, ask four questions:

1. What must be placed in registers before the call?
2. Which registers are promised to survive?
3. Where is the returned value?
4. Which flags contain a returned decision?

This is the assembly-language equivalent of reading a function signature.

## Back to the whole machine

We can now restate several earlier journeys in register language.

When the editor scans input:

```text
HL walks through characters
DE writes a normalized field
C counts remaining buffer space
A carries the current character
flags report its class
```

When the assembler emits bytes:

```text
HL and IX point into source and record structures
DE or BC carry decoded values
varcAssemblyOutputPointer remembers the long-lived destination
A carries each byte to the emitter
```

When the monitor disassembles:

```text
HL walks through machine code
B and C describe the decoded instruction
DE carries operand bytes
IX builds a temporary source record
```

The register names are the same. The stories are different.

That flexibility is one reason PROMETHEUS can contain so many features in so little space. The program does not reserve a separate set of variables for every conceptual object. It gives a few fast registers precise temporary roles, uses them intensely, and then reuses them for the next scene.

## What has changed in memory?

This chapter mostly described values in the processor, not long-lived memory. During the examples:

- `PUSH` temporarily stored register values on the active stack;
- the inline-string printer removed a return address and later resumed after the string;
- the input renderer preserved caller pointers while expanding a token;
- `IX` addressed fields in a temporary compressed record;
- alternate-register swaps changed which physical register bank was active without changing RAM.

No new persistent data format has been introduced yet. That changes in the next two chapters.

## Source anchors introduced

- `addAtoHL`
- `compareHLWithSourceBufferStart`
- `displayInputTokenOrCharacter`
- `installerPrintInlineString`
- `readKeyCode`
- `processKey`
- `encodedRecordInfoByte`
- `dispatchDisassemblyOperandHandler`
- `checkAddressAgainstProtectionTable`
