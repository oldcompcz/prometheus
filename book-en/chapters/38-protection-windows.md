# Chapter 38: Protection Windows

A machine-code monitor invites dangerous experiments. The user can point it at
any address, alter bytes, single-step instructions and call routines whose
behavior may not yet be understood. PROMETHEUS therefore lets the user describe
places that traced code must not read, write or execute.

It also uses the same range machinery for a gentler purpose: telling the
disassembler that certain addresses contain bytes or words of data rather than
instructions.

Five editable tables appear behind keys 1 to 5:

```text
1  display as DEFB
2  display as DEFW
3  do not READ
4  do not WRITE
5  do not RUN
```

At first these seem like five unrelated features. Internally they are five
instances of one tiny range language and one shared table editor.

## The visible idea

A user range contains two inclusive endpoints:

```text
First = $8000
Last  = $80FF
```

The range includes 256 addresses, including both `$8000` and `$80FF`.

Up to five user ranges may be stored in each table. The monitor displays them as
numbered windows 0 through 4. A new range is inserted with I. A numbered key
deletes an existing range.

The word *window* is useful. A window is not a separate memory region or copied
buffer. It is simply a pair of numbers through which the checker views the
64K address space.

## The physical table

Each table occupies twenty-five bytes:

```text
+0      stored count
+1..4   hidden First, Last pair
+5..8   user window 0
+9..12  user window 1
+13..16 user window 2
+17..20 user window 3
+21..24 user window 4
```

Each First or Last value is a little-endian word. One user window therefore
occupies four bytes.

The source for the READ table begins:

```asm
setReadProtectedAreas:
    defb 002h
    defw 0x0000, 0x0000
customReadProtectedAreas:
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
```

WRITE and RUN use the same shape. So do `defbDisassemblyAreaTable` and
`defwDisassemblyAreaTable`.

## Why an empty table starts at two

The count byte is biased:

```text
stored count = 2 + number of visible user windows
```

Therefore:

```text
no user windows    stored count = 2
one user window    stored count = 3
five user windows  stored count = 7
```

The two extra units support two related interpretations.

The user-interface code subtracts the bias and sees:

```text
visible count = stored count - 2
```

The checking code decrements once before each test and sees:

```text
ranges to test = stored count - 1
```

Why one rather than zero when the table is visibly empty? Because there is one
hidden range.

## The invisible resident window

PROMETHEUS must always protect itself, its compressed source and its symbol
table. Their final addresses are not fixed:

- the whole resident image can be installed at another base;
- the monitor prefix may be omitted;
- source can grow;
- symbol records can move upward.

A permanent pair of hard-coded endpoints would soon become wrong.

Before every check, the code replaces the hidden pair with:

```text
First = relocated resident PROMETHEUS start
Last  = current end of resident code + source + symbols
```

Those values come from two self-modified operands:

```asm
    ld hl,(emitByteAtAssemblyOutput+1)
    ld hl,(varcCodeEndPt+1)
```

The first name can mislead a reader. `emitByteAtAssemblyOutput+1` is used here
because the operand at that location contains the relocated resident-image
start. The installer adjusts it when PROMETHEUS moves and when the monitor
prefix is omitted.

`varcCodeEndPt+1` follows the current upper end of the resident workshop's live
storage.

The hidden window therefore grows with the source:

```text
resident start  [ code | source | symbols ]  current end
^                                                   ^
First                                               Last
```

It is not shown to the user and cannot be deleted.

## One editor for all five tables

`testKeysForAreas` accepts keys 1 through 5 and indexes
`monitorRangeTablePointers`:

```asm
monitorRangeTablePointers:
    defw defbDisassemblyAreaTable
    defw defwDisassemblyAreaTable
    defw setReadProtectedAreas
    defw setWriteProtectedAreas
    defw setExecutionProtectedAreas
```

The selected address is then passed to the same display-and-edit machinery.

This is a common PROMETHEUS design:

```text
small table chooses data
one general routine interprets it
```

Adding a sixth kind of range would principally require another table and another
pointer, not another complete editor.

## The heading is stored beside the table

The byte immediately before each table is a monitor text token for its heading.
The display routine can move one byte backward from the count address and print
the correct name without receiving another parameter.

For example, the layout is conceptually:

```text
[token "No READ"] [count] [hidden pair] [five user pairs]
```

The table carries enough neighboring context to introduce itself.

## Displaying only user windows

`displayAndEditFiveRangeTable` skips the hidden four-byte pair. It interprets
`stored count - 2` as the number of visible entries and prints each as:

```text
0  First  Last
1  First  Last
...
```

Number formatting follows the monitor's current decimal/hexadecimal setting.
The same line-buffer and list-window machinery used for memory dumps is reused
for the range list.

The hidden range participates in checks but not in the display. That separation
is why the biased count is more than a space-saving curiosity; it keeps two
views of the same table synchronized.

## Inserting a window

Pressing I in the range editor asks for First and Last through the normal monitor
expression reader.

The sequence is:

```text
if five user windows already exist:
    return to monitor

ask for First
ask for Last
store both in next unused slot

if First <= Last:
    increment stored count
else:
    leave count unchanged

redraw table
```

The pair is physically written before validity is accepted. If First is above
Last, the count is not increased, so the slot remains logically unused. The next
insertion overwrites it.

This saves a temporary four-byte buffer. The unused next slot *is* the temporary
buffer.

Zero-length windows are impossible because endpoints are inclusive. A range
with `First == Last` protects exactly one address and is valid.

## Deleting a window

Keys 0 through 4 select visible slots. The selected slot and every later pair are
shifted down by four bytes with `LDIR`, then the stored count is decremented.

The visible index must be translated past the hidden pair. That is why key 0
maps to physical offset +5, not +1.

In pseudocode:

```text
if selectedNumber >= visibleCount:
    ignore key
else:
    move later 4-byte pairs down over selected pair
    storedCount--
    redraw
```

Bytes left in the unused tail do not matter. The count defines which pairs are
alive.

## A range-overlap question

The main range checker receives:

```text
BC = query First
DE = query Last
HL = address of selected table's count byte
```

It must answer:

> Does any part of query First..Last touch any protected First..Last?

For two valid inclusive ranges A and B, they are disjoint only when:

```text
A.Last < B.First
or
B.Last < A.First
```

Every other relation is overlap, including equality at either endpoint.

PROMETHEUS also treats a reversed query, where query First is above query Last,
as an error.

A clearer high-level version of the routine is:

```text
install dynamic resident range in hidden slot

for each hidden or user protected range:
    if queryFirst > queryLast:
        return carry set

    if queryLast < protectedFirst:
        continue

    if protectedLast < queryFirst:
        continue

    return carry set

return carry clear
```

Carry set means collision or malformed range. Carry clear means safe with
respect to that table.

## The table briefly becomes the stack

The actual implementation uses a bold Z80 trick. It redirects SP into the table:

```asm
checkRangeAgainstProtectionTable:
    ld (restoreProtectionCheckStackAndReturn+1),sp
    ld a,(hl)
    inc hl
    ld sp,hl
```

It then uses POP to read First/Last pairs efficiently.

Before doing that, the caller's real SP is written into the operand of a later
instruction:

```asm
restoreProtectionCheckStackAndReturn:
    ld sp,00000h
    ret
```

The zero word is patched at run time. Every exit reaches this instruction and
restores the genuine monitor stack.

The sequence is conceptually:

```text
remember real SP inside code
point SP at range table
POP pair after pair
restore real SP from patched LD SP,nn
RET normally
```

This would be reckless in a program with interrupts or uncontrolled re-entry.
The monitor disables interrupts and owns a private stack, so the trick is
contained.

## Installing the hidden pair with PUSH

After SP points at the first pair, the routine discards the placeholder words,
then pushes the current dynamic Last and First back into that exact slot.

The table is therefore genuinely rewritten before each check. The hidden bytes
are scratch storage, not authoritative configuration.

This is another reason they are not shown to the user: their values are transient
and regenerated from live state.

## Checking one address

The stepping engine often needs a simpler question:

> Is this single address inside any forbidden window?

`checkAddressAgainstProtectionTable` receives the candidate in DE and uses the
same table preparation:

```text
replace hidden pair with current resident bounds
scan hidden range and every custom range
return carry if First <= address <= Last
```

It also redirects SP into the table and restores it through a patched
`LD SP,nn` exit.

The two checkers deliberately share the representation but not all comparison
code:

```text
range checker    used when an operation spans First..Last
address checker  used for one program counter or effective address
```

## Where READ, WRITE and RUN are enforced

The custom protection windows become active in the traced instruction engine,
provided instruction controls are enabled.

Before executing a user instruction, later chapters will show that PROMETHEUS:

1. decodes the instruction;
2. determines whether it reads or writes memory;
3. calculates the effective address;
4. checks that address against READ or WRITE tables;
5. checks execution destinations against the RUN table.

The resulting messages are:

```text
Read/Write ERROR
Run ERROR
```

The checker itself does not know why it is being called. It only returns carry.
The stepping engine chooses the table and the error text.

## DEFB and DEFW use the same windows differently

The first two tables do not prohibit access. They classify memory for the
disassembler.

At each address the disassembler asks in order:

```text
inside DEFB table?  -> consume one byte as data
else inside DEFW?   -> consume two bytes as a little-endian word
else                -> try to decode a Z80 instruction
```

Because both tables receive the hidden resident/source range and DEFB is tested
first, PROMETHEUS's own bytes are always shown as `DEFB`, never decoded as
instructions.

This is the answer to a question that often arises while exploring the monitor:
**the block occurs in `disassembleNextLineToBuffer`, at the carry branch after
`checkAddressAgainstProtectionTable` on `defbDisassemblyAreaTable`.**

The relevant shape is:

```asm
    ld hl,defbDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefbDisassemblyRecord

    ld hl,defwDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefwDisassemblyRecord
```

It does not make the resident bytes unreadable. It makes the disassembler treat
them as data.

## Only the starting address is classified

A DEFB hit consumes one byte. A DEFW hit consumes two bytes. The code tests only
the item's starting address.

Therefore, if the user defines:

```text
DEFW window $9000..$9000
```

a word starting at `$9000` still reads its high byte from `$9001`, outside the
window.

There is also no even-address requirement. A DEFW item may begin at `$9001`.

The windows say:

```text
when decoding begins here, choose this item type
```

They do not claim ownership of every byte consumed by that item.

## The resident-only checker

Chapter 37 introduced `checkRangeAgainstResidentRegionOnly`. It borrows the
WRITE table's hidden slot but supplies a hard-coded biased count of two.

That means exactly one synthesized range is tested:

```text
PROMETHEUS start .. current code/source/symbol end
```

No user WRITE window is reached.

This specialized wrapper is used by trusted block operations such as MOVE and
FILL. It demonstrates that sharing a table format does not mean every caller
uses every table entry.

## Error recovery returns to a clean monitor

On a protection error, PROMETHEUS does more than print text and return through a
deep call chain. The common handler:

- builds the appropriate tokenized error line;
- redraws it in the panel area;
- clears relevant monitor state;
- refreshes the panel;
- beeps;
- waits for a key and its release;
- re-enters `startMonitor` with a fresh private stack.

That last step is important because range checking and instruction simulation
use unusual stack arrangements. A warm restart is safer than trusting every
nested routine to unwind after a rejected execution.

## Back to the whole feature

Suppose the user wants to inspect a data table while safely stepping a routine:

```text
1. Key 1: add $9000..$90FF as DEFB.
2. Key 3: add $9000..$90FF as No READ.
3. Key 4: add $9100..$91FF as No WRITE.
4. Key 5: add $5DC0..$9FFF as No RUN.
5. List disassembly around $9000.
6. Step code that approaches those regions.
```

The same four-byte pair representation now serves two different stories:

```text
disassembler story:
    addresses in this window are data

execution-control story:
    traced code may not perform this kind of access here
```

The hidden resident window is added to both stories automatically. In the
first, it stops nonsensical self-disassembly. In the second, it stops the traced
program from trampling its monitor.

## What has changed in memory

After inserting a user window:

- the next unused four-byte pair stores First and Last;
- the table's biased count increases by one.

After deleting one:

- later pairs move down four bytes;
- the count decreases;
- stale bytes beyond the new logical end are ignored.

During every check:

- the hidden pair is overwritten with current resident First and Last;
- SP temporarily points into the table;
- the real SP is restored before return.

## Important labels encountered

- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `customDefbDisassemblyAreas`
- `customDefwDisassemblyAreas`
- `customReadProtectedAreas`
- `customWriteProtectedAreas`
- `customExecutionProtectedAreas`
- `monitorRangeTablePointers`
- `testKeysForAreas`
- `displayAndEditFiveRangeTable`
- `checkRangeAgainstResidentRegionOnly`
- `checkRangeAgainstProtectionTable`
- `checkAddressAgainstProtectionTable`
- `restoreProtectionCheckStackAndReturn`
- `restoreAddressCheckStackAndReturn`

## Ideas needed later

- Traced memory behavior is described by compact opcode/access tables and checked
  against these windows.
- The disassembler uses DEFB/DEFW classification before instruction decoding.
- The hidden resident range follows relocation and source growth automatically.
- PROMETHEUS sometimes turns an ordinary data table into a temporary Z80 stack
  to save code and simplify iteration.
