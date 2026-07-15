# Chapter 41: Monitor Tape Tools

The editor's tape commands save a structured PROMETHEUS document: compressed
source followed by its symbol table. The monitor's tape commands have a more
primitive purpose. They move arbitrary memory blocks.

That difference is fundamental:

```text
editor SAVE / LOAD:
    understands source records and symbols

monitor S / J / Y:
    understands addresses, lengths and Spectrum tape blocks
```

The monitor can save assembled code, screen memory, a data table or almost any
other byte range. It can load a raw block at a chosen destination. It can also
read and display a standard Spectrum header before deciding whether to load the
following data block.

These commands are small wrappers around the Spectrum ROM tape routines, but
they reveal several PROMETHEUS habits:

- inclusive ranges are converted only at the last moment;
- parameters are sometimes preserved under the return address on the stack;
- one prompt accepts two different languages, a number or `:filename`;
- the standard Spectrum header is built inside an existing scratch buffer;
- monitor safety checks are intentionally narrower than the later tracing
  protection system.

## Two ways to describe a range

SAVE and LOAD each have two key variants:

```text
First, Last
First, Length
```

The first form already produces an inclusive range. The second computes:

```text
Last = First + Length - 1
```

By the time the command reaches its tape-specific tail, both forms therefore
look the same:

```text
DE = First
HL = Last
```

The ROM, however, wants a start address and a byte count. PROMETHEUS delays the
conversion until `prepareMonitorTapeBlockParameters`:

```text
length = Last - First + 1
IX = First
DE = length
A  = low byte of Leader
```

The helper's register shuffling looks unusual because First and Last were pushed
beneath its return address:

```asm
prepareMonitorTapeBlockParameters:
    ld a,l
    pop bc
    pop de
    pop hl
    push bc
    or a
    sbc hl,de
    inc hl
    ex de,hl
    push hl
    pop ix
    ret
```

Read it as a stack diagram rather than instruction by instruction:

```text
before helper:
    top -> helper return
           First
           Last

helper removes return temporarily
helper recovers First and Last
helper restores return
helper converts inclusive range to IX + length
```

Only the low byte of the entered Leader survives. A value such as `$12FF`
therefore behaves exactly like `$FF`.

## Saving a raw block

The ordinary S command asks for First, Last and Leader. SYMBOL SHIFT+S asks for
First, Length and Leader.

If Leader is a numeric expression, PROMETHEUS saves a **raw tape block**. The low
byte becomes the tape flag passed to the ROM. There is no Spectrum header and no
filename.

Conceptually:

```text
ask for range
ask for numeric Leader
convert inclusive range to start + length
ROM SAVE block with that flag
```

This is useful for private tape formats. A program may choose, for example, flag
`$42` for one kind of block and flag `$43` for another.

The command jumps directly into the ROM SAVE control routine:

```asm
.writeMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters
    jp ROM_SaveControl_4c6
```

It does not return through a PROMETHEUS status wrapper. Once the jump is made,
the Spectrum ROM owns the final tape behavior and error reporting.

## Saving a standard CODE block

The Leader prompt has a second language. If the answer begins with a colon,
such as:

```text
:ROUTINE
```

PROMETHEUS constructs a normal seventeen-byte Spectrum CODE header.

The fields are:

```text
+0       type = 3, meaning CODE
+1..10   filename, padded or truncated to ten characters
+11..12  data length
+13..14  parameter 1 = First address
+15..16  parameter 2 = zero in the normal path
```

The workspace is not a separately allocated tape object. It is a named view over
`commandArgumentBuffer`:

```asm
commandArgumentBuffer:
    defb 000h
monitorTapeHeaderFileName:
    defs 10
monitorTapeHeaderDataLength:
    defw 0
monitorTapeHeaderParameter1:
    defs 6
```

The six final bytes contain parameter 1, parameter 2 and adjacent scratch space.
The SAVE path explicitly stores parameter 1 and the data length. Parameter 2 is
normally zero because the shared prompt initialization cleared the scratch
buffer before `:filename` was processed.

The command then:

1. waits for the user to start the tape;
2. writes a flag-`$00` header block;
3. changes Leader to `$FF`;
4. writes the selected memory as the standard data block.

This is the familiar Spectrum pair:

```text
header block flag $00
CODE data block flag $FF
```

The header's load address is the selected First address. A later standard loader
can therefore know where the bytes originally belonged.

## A deliberate lack of SAVE protection

Monitor SAVE does not call the resident-range checker. It also does not reject a
reversed range.

That means this entry:

```text
First = $9000
Last  = $8FFF
```

is not diagnosed as empty. Sixteen-bit subtraction wraps:

```text
Last - First + 1 = $0000
```

What the ROM does with that length belongs to the original behavior. The monitor
assumes the user knows what memory is being read.

This fits a larger distinction:

- reading memory for a trusted monitor command is permissive;
- writing into PROMETHEUS's resident area is guarded;
- executing unknown code receives the strongest, configurable checks.

The program does not impose one universal protection policy on every command.

## Loading a raw block

J asks for First, Last and numeric Leader. SYMBOL SHIFT+J asks for First, Length
and numeric Leader.

Unlike SAVE, LOAD first calls `preserveBlockRangeAndCheckResidentWrite`. It
rejects:

- a reversed or wrapped destination;
- any destination intersecting resident PROMETHEUS, source or symbols.

It does **not** consult the five editable WRITE windows described in Chapter 38.
Those windows govern traced user instructions, not this trusted monitor command.

After the range check, the command asks for Leader, converts the parameters and
calls the shared ROM loader with carry set:

```asm
.readMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters
    scf
    call callRomTapeLoadOrVerify
    ret c
    jp showMonitorReadWriteError
```

The raw load expects exactly:

- the requested flag byte;
- the requested length;
- valid tape parity.

It does not scan ahead for a header or filename. The first suitable physical
block must be the one the user intends to load.

PROMETHEUS reports the same `Read/Write ERROR` for a protected destination and a
ROM tape failure. The interface does not attempt a detailed diagnosis.

## Why `:filename` is not meaningful for J

`promptForMonitorValue` understands colon input because it is shared with SAVE.
But the J handler contains no filename branch. If colon input were supplied, the
low byte of the returned buffer pointer would accidentally become the expected
Leader.

The meaningful interface is therefore numeric Leader input only.

This is a useful reconstruction lesson: a shared parser may accept more forms
than a particular caller has semantic code to handle. The caller, not the parser
alone, defines the real command language.

## Reading a header or a leader with Y

The Y command is an inspector rather than an ordinary block loader. It reads
eighteen bytes into `inputBufferStart`:

```text
+0       physical tape flag
+1       Spectrum header type
+2..11   filename
+12..13  data length
+14..15  parameter 1
+16..17  parameter 2
```

Why eighteen when a Spectrum header payload is seventeen bytes? The ordinary
ROM wrapper consumes the flag separately. Y calls the ROM more directly so the
physical flag remains in memory before the seventeen header bytes.

The setup is:

```asm
monReadTapeHeaderOrLeader:
    call beginMonitorListOutputWithBlankLine
    ld ix,inputBufferStart
    ld de,00012h
    xor a
    scf
    ex af,af'
    ld a,00fh
    out (0feh),a
    call ROM_LoadBytes_562
```

Expected flag `$00` and LOAD mode are moved into the alternate accumulator, as
required by the ROM tape routine.

Two outcomes are possible.

### A valid header was read

The monitor builds one list-window line containing:

```text
type  filename  parameter1  length  parameter2
```

The three words are displayed in the monitor's current decimal or hexadecimal
mode. Control characters in the filename become `?`. Bytes at `$20` and above
are copied as they are, even if bit 7 is set.

The user then presses a key. If it is J, PROMETHEUS interprets the header as a
CODE-style destination description:

```text
First  = parameter 1
Length = data length
Last   = First + Length - 1
Leader = $FF
```

It checks that destination against resident memory and loads the immediately
following standard data block.

Any other key returns to the monitor after displaying the header.

### The block was not a valid `$00` header

The ROM leaves carry clear, but the first physical flag byte remains at
`inputBufferStart`. PROMETHEUS displays that one value in the active number
base.

It cannot offer an automatic follow-up load because a raw leader does not say:

- where the data should go;
- how long the block is.

Y is therefore literally a **header or leader** reader.

## Header display and follow-up load

The successful-header tail carefully preserves two values while rendering:

```asm
    ld hl,(loadedTapeHeaderParameter1)
    push hl
    ... print parameter 1 ...
    ld hl,(loadedTapeHeaderDataLength)
    push hl
    ... print length ...
```

After `readKeyCode`, it recovers length and First:

```asm
    pop hl
    pop de
    cp 06ah
    ret nz
    add hl,de
    dec hl
```

Now `DE=First` and `HL=Last`, exactly the range form expected by the raw LOAD
tail. It checks the destination, selects flag `$FF` and joins
`.readMonitorBlockWithSelectedLeader`.

This is economical code reuse:

```text
Y reads and displays header
if user presses J:
    translate header fields into ordinary LOAD range
    join the same protected raw-load tail
```

## The shared ROM loader contract

`callRomTapeLoadOrVerify` is also used by editor LOAD and VERIFY. Its inputs are:

```text
IX = destination or comparison address
DE = length
A  = expected block flag
carry set   -> LOAD
carry clear -> VERIFY
```

The wrapper:

- transfers flag and mode into `AF'` for the ROM;
- disables interrupts;
- prepares port `$FE`;
- calls ROM LD-BYTES;
- preserves the ROM success carry unless SPACE is pressed.

The monitor's J and Y-follow-up paths always choose LOAD. Editor VERIFY chooses
the other carry state.

Again one low-level mechanism supports several user-level commands.

## A practical example

Suppose an assembled routine occupies `$8000` through `$80FF`.

### Save it as a standard CODE file

```text
S
First:  $8000
Last:   $80FF
Leader: :ROUTINE
```

PROMETHEUS writes:

```text
header:
    type       3
    name       ROUTINE
    length     256
    parameter1 $8000
    parameter2 0

data:
    flag       $FF
    bytes      memory[$8000..$80FF]
```

### Inspect and reload it

Y reads the header and displays its fields. Pressing J immediately afterwards
loads the following `$FF` block back to `$8000`, unless that range now overlaps
resident PROMETHEUS.

### Save a private raw block

```text
S
First:  $8000
Last:   $80FF
Leader: $42
```

Only a flag-`$42` data block is written. Reload it with J by supplying the same
range and Leader `$42`.

## What has changed in memory

Depending on the command:

- First and Last are temporarily preserved on the private monitor stack;
- `commandArgumentBuffer` may hold a generated CODE header;
- `monitorTapeHeaderDataLength` and `monitorTapeHeaderParameter1` receive range
  metadata;
- `inputBufferStart` may hold a retained flag plus a seventeen-byte header;
- `lineBuffer` receives the displayed header or leader;
- a successful LOAD overwrites the requested destination range;
- monitor current-address and saved-register state are otherwise unchanged.

## Important labels encountered

- `monSaveBlockFirstLast`
- `monSaveBlockFirstLength`
- `.saveMonitorBlockAfterRangePrompt`
- `.writeMonitorBlockWithSelectedLeader`
- `prepareMonitorTapeBlockParameters`
- `commandArgumentBuffer`
- `monitorTapeHeaderFileName`
- `monitorTapeHeaderDataLength`
- `monitorTapeHeaderParameter1`
- `waitForKeyAndWriteTapeHeader`
- `monLoadBlockFirstLast`
- `monLoadBlockFirstLength`
- `preserveBlockRangeAndCheckResidentWrite`
- `.readMonitorBlockWithSelectedLeader`
- `callRomTapeLoadOrVerify`
- `monReadTapeHeaderOrLeader`
- `loadedTapeHeaderDataLength`
- `loadedTapeHeaderParameter1`
- `loadedTapeHeaderParameter2`
- `showMonitorReadWriteError`

## Ideas needed later

- The monitor deliberately distinguishes trusted operations from traced user
  execution.
- Carry often selects an operating mode without requiring another entry point.
- Scratch buffers are repeatedly reinterpreted as temporary structured data.
- The installer and final TAP chapter will return to the Spectrum header and
  physical tape-block formats from a different direction.
