# Chapter 5: When Code Is Also Data

Most programmers are taught to divide memory into two kingdoms.

In one kingdom lives code: instructions that the processor executes.

In the other lives data: numbers, characters, addresses and state that instructions read or change.

PROMETHEUS often refuses to keep that border tidy. An instruction may be executable code and, at the same time, the storage place for a persistent variable. A `CALL` can be a normal call whose destination is later replaced. A `JP` can be a continuation hook. The immediate word inside `LD HL,nn` can serve as a remembered pointer.

This technique is called **self-modifying code** because the program changes bytes that belong to its own instructions.

That phrase may sound reckless. In PROMETHEUS it is usually disciplined. The modified bytes have named labels, known widths and carefully limited meanings. The program is not randomly rewriting itself. It is treating selected instruction operands as compact variables.

## A variable hidden inside an instruction

The simplest example is a remembered pointer:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

When executed, this instruction loads `HL` with the current physical destination for assembled bytes.

Elsewhere the program updates the two-byte operand:

```asm
ld (varcAssemblyOutputPointer+1),de
```

The label names the opcode byte. Adding one reaches the first byte of the immediate word.

Memory therefore contains:

```text
address varcAssemblyOutputPointer     opcode for LD HL,nn
address + 1                           low byte of remembered pointer
address + 2                           high byte of remembered pointer
```

If the pointer is `$9000`, the instruction bytes are conceptually:

```text
21 00 90
```

where `$21` is the opcode for `LD HL,nn`.

The next time execution reaches the instruction, the remembered value is loaded directly into `HL`.

In higher-level pseudocode, the effect is:

```text
assemblyOutputPointer = DE
...
HL = assemblyOutputPointer
```

PROMETHEUS stores the variable in the instruction that consumes it.

## Why do this instead of using an ordinary word?

An ordinary design might reserve:

```asm
assemblyOutputPointer:
    defw 00000h
```

and load it with:

```asm
ld hl,(assemblyOutputPointer)
```

That is perfectly sensible. The self-modifying version has several attractions on a small Z80 machine:

- the stored word is already part of an instruction the routine needs;
- loading it requires no extra indirect memory access;
- the instruction and its state remain together;
- a callback destination can be changed without a separate dispatcher;
- code can be smaller or faster.

PROMETHEUS contains many such state cells. The reconstructed labels use the prefix `varc` to warn the reader that the following instruction is also writable state.

The prefix should be read as:

> variable carried by code

It is a reconstruction convention, but a very useful one.

## The logical address and the physical address

The assembler keeps two related pointers:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h

varcAddressCounter:
    ld hl,00000h
```

At first they usually advance together.

The **physical output pointer** says where the next byte will be written in RAM.

The **logical address counter** says which address the assembled program believes that byte has. It is the value represented by the current-address symbol `$` and used when defining labels.

Normally:

```text
physical output = logical address
```

But directives such as `PUT` can make them differ. A program may be assembled as if it belongs at one address while bytes are placed somewhere else.

The byte emitter makes the distinction explicit:

```asm
emitByteAtAssemblyOutput:
    ld de,ENTRY_POINT_WITH_MONITOR
varcAssemblyOutputPointer:
    ld hl,00000h
    ...
    ld (de),a
    inc de
    ld (varcAssemblyOutputPointer+1),de
varcAddressCounter:
    ld hl,00000h
    inc hl
    ld (varcAddressCounter+1),hl
    ret
```

In prose:

```text
check that the physical destination is safe
write A there
advance and remember the physical destination
load, advance and remember the logical address
```

The two remembered words live in the operands of the two instructions that retrieve them.

This is more than a space trick. It expresses the architecture of the assembler.

## An instruction can remember one byte

Not all self-modified values are addresses. The keyboard repeat machinery stores both a 16-bit delay counter and an 8-bit repeated key:

```asm
varcHeldKeyRepeatScanCounter:
    ld hl,00000h
    inc hl
    ld (varcHeldKeyRepeatScanCounter+1),hl

varcRepeatedKeyCode:
    ld a,00dh
```

After a key is accepted, its normalized code is written into the operand of `LD A,n`:

```asm
ld (varcRepeatedKeyCode+1),a
```

Later, when the repeat delay has expired, execution reaches `varcRepeatedKeyCode` and reloads the stored key automatically.

Likewise, the repeat counter is loaded, incremented and written back into its own `LD HL,nn` operand.

In pseudocode:

```text
repeatCounter = repeatCounter + 1
if repeatCounter has reached the threshold:
    return repeatedKeyCode
```

No separate named RAM bytes are needed.

## A self-modified instruction may be a switch

The installer can display text in different letter-case modes. It modifies this instruction:

```asm
varcInstallerCaseTransform:
    and 0ffh
```

`AND $FF` changes nothing, so it acts as the neutral case transformation. Another two-byte instruction from a small option table can replace it when the user changes the installation setting.

The glyph renderer uses an even more visual switch:

```asm
varcInstallerBoldTransform:
    nop
    or (hl)
```

In normal mode, `NOP` does nothing and `OR (HL)` merely combines a glyph row with itself.

In bold mode, the `NOP` byte is replaced with the one-byte opcode for `RRCA`. The row is rotated one pixel, then ORed with the original row:

```text
normal row = original
bold row   = rotateRight(original) OR original
```

The instruction stream itself becomes the selected rendering mode.

This kind of patch is attractive because the hot loop does not need to test a flag for every one of the eight glyph rows. The choice is made once when the option changes. Drawing then runs through the selected instruction directly.

## A `CALL` can become a tiny dispatcher

The two-pass assembler uses one source-record loop for both passes. What changes is the routine called for each record.

Initially the call site contains:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

Before the scan begins, the controller explicitly installs that address:

```asm
ld hl,firstPassProcessSourceRecord
ld (varcAssemblyPassHandlerCall+1),hl
```

At the pass transition it replaces the call destination:

```asm
ld hl,secondPassEmitSourceRecord
ld (varcAssemblyPassHandlerCall+1),hl
```

The record loop itself does not need a branch saying:

```text
if pass == 1:
    call firstPass
else:
    call secondPass
```

It simply executes the call site. The call has already been taught which routine it means.

In pseudocode:

```text
recordHandler = firstPassProcessSourceRecord
scan source using recordHandler

recordHandler = secondPassEmitSourceRecord
scan source using recordHandler
```

A modern programmer might call this a function pointer. PROMETHEUS implements it by replacing the operand of a real `CALL` instruction.

## A `JP` can be a continuation hook

Command processing normally finishes by returning to the editor warm start:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

Some operations need a different continuation. Tape insertion and replacement workflows temporarily change the jump destination, perform a shared command path, and resume at their own follow-up routine.

Before ordinary command dispatch, the normal destination is restored:

```asm
ld hl,prometheusWarmStart
ld (varcPostCommandContinuationJump+1),hl
```

This is another function pointer, but one used for a final jump rather than a nested call.

The distinction matters:

- `CALL` expects to return;
- `JP` transfers control without adding a return address.

The continuation hook lets a complex operation borrow the normal editor machinery and then regain control at the end.

## A patched instruction can restore a whole control environment

The monitor's execution engine temporarily runs user code. Before doing so, it must remember where the monitor's own stack was.

Later, captured user state reaches this instruction:

```asm
varcRestoreMonitorStackAfterExecution:
    ld sp,00000h
```

The immediate word has previously been patched with the monitor stack pointer. Executing the instruction instantly abandons the temporary user/trampoline stack and restores the monitor's own call environment.

This is a powerful form of state restoration. Changing `SP` does not merely load a number. It changes where every following `POP` and `RET` will obtain data.

The patched operand is therefore part of control flow as well as storage.

## Self-modification can save repeated decisions

Several patterns now emerge.

### Remembered scalar

```asm
varcInsertMode:
    ld a,000h
```

The operand stores a mode byte.

### Remembered pointer

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

The operand stores the cursor-marker address discovered during repainting.

### Remembered callback

```asm
varcRangedDisassemblyOutputCall:
    call appendLineBufferToMonitorListWindow
```

The operand chooses where generated disassembly lines are sent.

### Remembered jump destination

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

The operand chooses the continuation after shared work.

### Remembered instruction behavior

```asm
varcInstallerBoldTransform:
    nop
```

The opcode itself, not merely its operand, is replaced.

Each pattern removes a decision or separate lookup from the path where the value is used.

## The danger: the shape of the instruction is part of the data format

Self-modifying code creates strict rules.

If this state cell is defined as:

```asm
varcAddressCounter:
    ld hl,00000h
```

then other code assumes:

```text
the stored low byte is at label+1
the stored high byte is at label+2
```

Replacing `LD HL,nn` with a different-length instruction would break every writer even if the new instruction appeared to perform a similar task.

Likewise, changing a one-byte patched opcode into a two-byte instruction could overwrite the next instruction.

The exact byte layout is an interface.

That is why the source introduction and comments distinguish:

- opcode byte;
- immediate byte;
- immediate word;
- full instruction replacement;
- patched `CALL` or `JP` destination.

A modification must preserve the expected shape or update every writer and verifier.

## The danger: code may be writable for reasons that disassembly hides

Suppose the monitor disassembled its own resident region as ordinary code. It would display instructions such as:

```asm
ld hl,$8A31
call $7420
jp $7300
```

A reader might assume these operands are permanent addresses. In fact, some may be live variables or callbacks that change while PROMETHEUS runs.

This is one reason the monitor's hidden resident range is forced through the `DEFB` path. The bytes remain inspectable, but PROMETHEUS does not pretend that its own mutable instruction stream is a stable sequence of user instructions.

The protection is not secrecy. It is an admission that code and data are entangled.

## The danger: ROM or read-only memory would make this impossible

PROMETHEUS can self-modify because it runs in writable RAM. The ZX Spectrum ROM cannot be patched this way.

The program's own relocation also matters. A patch writer must address the relocated copy of the instruction, not the zero-origin build address or temporary tape position. The installer and relocation machinery arrange this before the resident program begins ordinary work.

Once installed, label-based internal references point to the writable resident image.

## The source uses a naming warning

The `varc` prefix is not decorative. It tells us to inspect at least three things:

1. Which bytes are read when the instruction executes?
2. Which other routines write those bytes?
3. Is the opcode itself fixed, or can it also be replaced?

For example:

```asm
varcPrintingPosition:
    ld de,SECOND_LINE_ADDRESS
```

The renderer later stores the next bitmap position into `varcPrintingPosition+1`. We should therefore read the instruction as both:

```text
load DE with the current printing position
```

and:

```text
two writable bytes hold the current printing position
```

The label connects those two views.

## A useful way to translate self-modifying code

When reading a `varc` site, temporarily rewrite it as a higher-level variable.

Real code:

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

Mental translation:

```text
HL = inputBufferPosition
```

Writer:

```asm
ld (varcInputBufferPosition+1),hl
```

Mental translation:

```text
inputBufferPosition = HL
```

For a callback:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

Mental translation:

```text
call assemblyPassHandler()
```

Writer:

```text
assemblyPassHandler = secondPassEmitSourceRecord
```

This translation reveals the design without hiding the unusual implementation.

## Why the program uses this style so widely

PROMETHEUS was designed for a machine where every byte mattered and where RAM execution was normal. Self-modification offered:

- compact persistent state;
- direct loading of frequently used values;
- cheap callbacks;
- removal of repeated mode tests;
- natural storage of relocated runtime addresses;
- reuse of one loop for several phases.

It also fits the Z80 particularly well. Immediate operands are stored directly after opcodes, and absolute `CALL` and `JP` destinations are ordinary writable words.

The technique would be less attractive in a system with protected executable pages, instruction caches or code stored in ROM. On the Spectrum, it is a practical part of the program's design language.

## Back to the whole machine

The source editor, assembler, monitor and renderer all depend on remembered state.

PROMETHEUS could have collected that state into one large variable block. Instead, much of it is distributed at the places where it is consumed:

```text
renderer position         inside LD DE,nn
current source record     inside LD HL,nn
assembler pass handler    inside CALL nn
command continuation      inside JP nn
mode and option bytes     inside LD A,n
font transformation       inside executable opcode
monitor stack restoration inside LD SP,nn
```

This makes the physical source look stranger, but the runtime path shorter.

The next chapter looks at the other half of the same philosophy. PROMETHEUS does not only compress state into instructions. It also invents several tiny data languages so that strings, vectors, commands and descriptors occupy as few bytes as possible.

## What has changed in memory?

During the examples in this chapter, PROMETHEUS may change bytes inside its resident code image:

- immediate operands remember pointers, counters, modes and addresses;
- `CALL` and `JP` destination words select callbacks and continuations;
- selected opcodes implement installation choices such as bold rendering;
- the monitor stack pointer is stored in an `LD SP,nn` instruction;
- the assembler's output and logical address counters advance inside two `LD HL,nn` instructions.

These writes are intentional persistent state changes. They are not changes to the user's source or generated program.

## Source anchors introduced

- `varcAssemblyOutputPointer`
- `varcAddressCounter`
- `emitByteAtAssemblyOutput`
- `varcHeldKeyRepeatScanCounter`
- `varcRepeatedKeyCode`
- `varcInstallerCaseTransform`
- `varcInstallerBoldTransform`
- `varcAssemblyPassHandlerCall`
- `varcPostCommandContinuationJump`
- `varcRestoreMonitorStackAfterExecution`
- `varcInputBufferPosition`
- `varcPrintingPosition`
- `varcRangedDisassemblyOutputCall`
