# Chapter 37: Searching and Changing Blocks

A memory monitor is most useful when it can do more than stare at one address.
Sooner or later the user asks larger questions:

- Where does this sequence of bytes occur?
- Can I copy this whole routine somewhere else?
- Can I clear or initialize a complete region?
- What happens if the source and destination overlap?
- How does PROMETHEUS keep such commands away from its own resident image?

PROMETHEUS answers those questions with three compact tools:

1. a five-byte masked finder;
2. an overlap-safe block mover;
3. a byte-value block filler.

They are deliberately small. There is no general regular-expression engine and
no elaborate memory-map object. The finder has exactly five positions. The block
commands work with inclusive 16-bit ranges. Expressions are read through the
same monitor input machinery already used for addresses and registers.

That simplicity is not a weakness. On a 48K Spectrum it means that each command
is predictable, fast and small enough to live beside the editor, assembler and
tracer.

## Two kinds of searching in one application

The editor has a FIND command, described in Chapter 17. It searches expanded
source text. The monitor's G command is a different creature. It searches raw
memory bytes.

The difference matters:

```text
editor FIND:
    compressed source record
        -> expanded source text
        -> character comparison

monitor G:
    memory address
        -> five raw bytes
        -> masked byte comparison
```

The monitor does not care whether a byte is an opcode, text character, number,
screen attribute or part of a table. It sees only values from `$00` to `$FF`.

## A five-position pattern

The workspace `monitorFindByteMaskPairs` reserves ten bytes:

```asm
monitorFindByteMaskPairs:
    defs 10
```

Those ten bytes are interpreted as five adjacent pairs:

```text
(value 1, mask 1)
(value 2, mask 2)
(value 3, mask 3)
(value 4, mask 4)
(value 5, mask 5)
```

Every pattern position is therefore represented by two bytes rather than one.
The first says what value is wanted. The second says which bits of that value
matter.

PROMETHEUS currently creates only two kinds of mask:

```text
ordinary expression   mask = $FF   all eight bits matter
colon `:`              mask = $00   no bits matter
```

A colon is the wildcard.

Suppose the user enters:

```text
$3E : $CD : $C9
```

The resulting pattern is conceptually:

```text
value  mask
$3E    $FF
any    $00
$CD    $FF
any    $00
$C9    $FF
```

It matches five bytes whose first, third and fifth positions are `$3E`, `$CD`
and `$C9`, while the second and fourth positions may contain anything.

The table format is slightly more general than the user interface. A mask such
as `$F0` could compare only the upper four bits. The original command never
creates that mask, but the comparison formula would support it.

## The comparison formula

The inner test is wonderfully small:

```asm
    ld a,(de)
    inc de
    xor (hl)
    inc hl
    and (hl)
    inc hl
    jr nz,.advanceMonitorFindAfterMismatch
```

At this point:

- `(DE)` was the candidate memory byte;
- the first `(HL)` was the wanted value;
- the second `(HL)` was the mask.

The mathematical test is:

```text
(memory XOR wanted) AND mask
```

A zero result means that every significant bit matched.

Why XOR? XOR produces zero wherever two bits are equal and one wherever they are
different. AND then erases differences the mask says to ignore.

For an exact byte:

```text
memory = $3E
wanted = $3E
mask   = $FF

($3E XOR $3E) AND $FF = $00
```

For a mismatch:

```text
memory = $3F
wanted = $3E
mask   = $FF

($3F XOR $3E) AND $FF = $01
```

For a wildcard:

```text
memory = anything
wanted = anything
mask   = $00

(any difference) AND $00 = $00
```

This is the whole wildcard mechanism. There is no branch saying “if this was a
colon, skip the byte.” The mask turns the same arithmetic into either an exact
comparison or a no-op.

## Entering the pattern

`monFindSequence` asks for five positions. Rather than storing five prompt
strings, PROMETHEUS keeps one string beginning with a writable digit:

```text
1. byte:
```

The byte labelled `monitorFindBytePromptDigit` is reset to character `1` before
the first question and incremented after each answer. The same text therefore
becomes:

```text
1. byte:
2. byte:
3. byte:
4. byte:
5. byte:
```

This is a tiny example of the program's general habit: if one byte can turn one
piece of data into five related messages, do not store five separate messages.

Each answer passes through `promptForMonitorValue`. That means a fixed position
can be written as any ordinary PROMETHEUS expression:

```text
42
#$2A                 not actual syntax; hexadecimal is entered as $2A
LABEL
LABEL+1
'A'
```

The special colon result is distinguished from an evaluated expression. The
handler then stores either:

```text
(low byte of result, $FF)
```

or:

```text
(don't-care value, $00)
```

Only the low byte of an expression is used. Entering `$123E` therefore searches
for `$3E` at that position.

## G and N begin after the current address

After G has collected a new pattern, execution falls into `monNextSequence`.
The N command enters `monNextSequence` directly and reuses the previous pattern.

The first instructions are:

```asm
monNextSequence:
    ld de,(varcMonitorCurrentAddress+1)
    inc de
```

Both commands therefore begin at **current address plus one**.

That choice makes repeated searching natural:

```text
G   define pattern and find first later match
N   find next later match
N   find the next one again
```

If the new search began at the current address, N would repeatedly rediscover
the same match.

## Walking candidate by candidate

For every candidate address, the routine:

1. saves the candidate on the CPU stack;
2. resets HL to the first value/mask pair;
3. compares five ascending memory bytes;
4. installs the candidate as the monitor address if all five match;
5. otherwise restores, increments and retries the candidate.

In pseudocode:

```text
candidate = currentAddress + 1

repeat:
    p = candidate

    for i = 0 to 4:
        if ((memory[p+i] XOR value[i]) AND mask[i]) != 0:
            candidate = candidate + 1
            if candidate == 0:
                return without a match
            continue repeat

    currentAddress = candidate
    redraw monitor
    return
```

The actual Z80 address space wraps at `$FFFF`. A five-byte comparison beginning
near the top can consequently read its final bytes from `$0000`, just as the
processor itself would. The candidate loop stops when an unsuccessful candidate
increment wraps to zero. A search that begins at zero can therefore examine the
whole 64K ring before giving up.

There is no “not found” message. Failure simply returns with the former current
address unchanged. This is terse but consistent with the monitor's compact
interaction style.

## Why the candidate is pushed

During a comparison DE advances through the candidate's five bytes. On a
mismatch PROMETHEUS needs the original candidate, not the partially advanced DE.
It therefore begins each trial with:

```asm
    push de
```

A complete match pops that saved value into HL and makes it the new current
address. A mismatch pops it back into DE, increments once and tries again.

The stack is acting as a one-word local variable.

## Moving a block

The I command moves an inclusive source block to another address. There are two
forms:

```text
I             First, Last, To
SYMBOL SHIFT+I First, Length, To
```

The second form is converted immediately into the first form:

```text
Last = First + Length - 1
```

From that point the command has three addresses:

```text
sourceFirst
sourceLast
 destinationFirst = To
```

It derives the destination's inclusive end:

```text
destinationLast = destinationFirst + sourceLast - sourceFirst
```

and the byte count:

```text
length = destinationLast - destinationFirst + 1
```

The `+1` is easy to forget. For an inclusive block `$8000..$8000`, subtraction
produces zero, but the block contains one byte.

## Rejecting impossible ranges

Several things can go wrong before a byte is copied:

- First may be above Last;
- Length may be zero;
- `First + Length - 1` may wrap around 16 bits;
- the destination calculation may wrap;
- the destination may overlap PROMETHEUS and its live source/symbol storage.

The command funnels those cases through the resident-range checker. A bad range
produces the monitor's `Read/Write ERROR` path rather than allowing an enormous
wrapped copy.

The check is performed on the destination, because that is the region the MOVE
command will overwrite. The source is trusted as readable monitor input.

## Overlap is not an error

A source and destination may overlap. For example:

```text
source       $8000..$80FF
destination  $8001..$8100
```

A naive forward copy would overwrite `$8001` before reading its original value.
The corruption would then spread through the rest of the block.

PROMETHEUS calls `moveMemoryBlockOverlapSafe`, the same general mechanism used
when the editor opens and closes gaps. It chooses direction according to the
relative positions:

```text
if destination starts below source:
    copy forward with LDIR
else:
    copy backward with LDDR
```

Copying backward in the example starts at the final source byte, preserving each
unread byte before its destination is overwritten.

This makes the command behave like a modern `memmove`, not a simple `memcpy`.

## The real MOVE flow

The register choreography is compact enough to look mysterious in raw source:

```asm
    push hl
    push de
    call promptForMonitorValue
    defb 0xd8
    pop de
    pop bc
    push de
    push hl
    or a
    sbc hl,de
    add hl,bc
```

The prose meaning is simpler:

```text
remember source First and Last
ask for destination First (`To`)
compute destination Last
check destination
compute inclusive length
perform overlap-safe move
```

The apparent complexity comes mostly from keeping three 16-bit addresses alive
on a processor with few general register pairs.

## Filling a block

The P command fills an inclusive range with one byte. Again there are two forms:

```text
P              First, Last, With
SYMBOL SHIFT+P  First, Length, With
```

`With` is evaluated as a 16-bit expression, but only its low byte is written.

PROMETHEUS does not run a hand-written store loop. It writes the first byte and
then uses `LDIR` to copy that byte over itself into the remaining cells:

```asm
    ld (de),a
    ret z
    ld b,h
    ld c,l
    ex de,hl
    ld d,h
    ld e,l
    inc de
    ldir
```

Imagine filling `$9000..$9004` with `$FF`:

```text
write $FF at $9000
copy $9000 to $9001
copy $9001 to $9002
copy $9002 to $9003
copy $9003 to $9004
```

Once the first destination byte exists, the Z80's block-copy instruction becomes
a compact byte-replication engine.

## A subtle but important protection rule

The monitor has configurable READ and WRITE protection windows. It is tempting
to assume that MOVE and FILL obey them.

They do not.

Both commands call the specialized resident-only check, ultimately
`checkRangeAgainstResidentRegionOnly`. It protects:

```text
relocated PROMETHEUS start
    through
current end of PROMETHEUS + source + symbol table
```

It does **not** examine the user's custom READ or WRITE windows.

Therefore the implemented behavior is:

```text
MOVE/FILL cannot overwrite the resident workshop
MOVE/FILL can overwrite a user-defined WRITE-protected area
MOVE can read a user-defined READ-protected area
```

The surviving manual reportedly describes broader protection. The machine code
is unambiguous: the custom tables are not on this call path.

This should not be “fixed” silently in a historical reconstruction. It is part
of the program we are explaining.

## Trusted monitor commands and controlled user instructions

The apparent inconsistency makes more sense when we distinguish two roles:

```text
trusted monitor operator:
    explicitly asks to inspect, move or fill memory

traced user program:
    may accidentally or maliciously read, write or execute protected memory
```

The configurable windows are mainly enforced by the instruction-control and
single-step engine. They are fences around the program being examined, not a
universal memory-management system wrapped around every monitor routine.

Numeric listings likewise read memory directly. One-line assembly uses the
assembler's resident/source output check. MOVE and FILL use the narrower
resident check.

PROMETHEUS has several safety boundaries, each attached to a particular path.
Understanding which path is active is more useful than assuming one global rule.

## Back to the whole operation

Consider a common investigation:

```text
1. Set current address to a suspected routine.
2. Press G and enter: $21 : : $CD :
3. PROMETHEUS stores five value/mask pairs.
4. It scans from current+1 until the masked pattern matches.
5. The match becomes the new current address.
6. Press I to copy the surrounding block to scratch RAM.
7. Press P to fill a temporary work area with zero.
8. Use the one-line assembler or disassembler on the copied bytes.
```

The commands feel independent at the keyboard. Internally they share principles
we have seen throughout the program:

- ordinary expression parsing;
- compact fixed workspaces;
- flags as Boolean results;
- inclusive 16-bit range arithmetic;
- overlap-safe block instructions;
- a dynamic resident-memory boundary.

The monitor's block tools are not a separate miniature operating system. They
are careful recombinations of machinery already needed by the editor and
assembler.

## What has changed in memory

After a successful G search:

- `monitorFindByteMaskPairs` holds the new pattern;
- `varcMonitorCurrentAddress+1` holds the match address.

After N:

- the pattern is unchanged;
- only the current address may move.

After MOVE:

- the destination range contains an exact copy of the source's original bytes;
- overlapping copies are still correct;
- source bytes are otherwise unchanged.

After FILL:

- every byte in the inclusive destination range contains the low byte of `With`.

## Important labels encountered

- `monFindSequence`
- `monNextSequence`
- `monitorFindByteMaskPairs`
- `monitorFindBytePromptDigit`
- `monMoveBlockFirstLast`
- `monMoveBlockFirstLength`
- `monFillBlockFirstLast`
- `monFillBlockFirstLength`
- `promptForFirstAndLast`
- `promptForFirstAndLength`
- `checkBlockDestinationAgainstResidentRegion`
- `preserveBlockRangeAndCheckResidentWrite`
- `checkRangeAgainstResidentRegionOnly`
- `moveMemoryBlockOverlapSafe`

## Ideas needed later

- A range can be represented by inclusive First and Last words.
- Several monitor facilities share one compact range-table language.
- The resident PROMETHEUS/source interval is generated dynamically before a
  safety check.
- Configurable protection applies principally to traced instruction behavior,
  not automatically to every trusted monitor command.
