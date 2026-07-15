# Chapter 56: Building the TAP

The Z80 binary is not, by itself, a complete Spectrum cassette program.

A user expects to type `LOAD ""`, wait for the familiar coloured border, and see
the machine continue automatically. For that to happen, PROMETHEUS is wrapped
in a small BASIC loader and stored in standard Spectrum tape blocks.

The outer format is much simpler than the program inside it. Yet it performs an
important act of coordination:

- BASIC reserves memory;
- ROM tape code loads the machine-code block;
- BASIC calls the physical bootstrap address;
- the bootstrap then performs PROMETHEUS's own installation and relocation.

This chapter distinguishes three layers that are often casually called “the
loader”:

```text
Spectrum BASIC loader
PROMETHEUS position-independent bootstrap
PROMETHEUS installer at $5000
```

They are separate programs with separate jobs.

## A TAP file is a list of logical blocks

A `.tap` file is not a recording of the analogue cassette waveform. It is a
compact computer representation of Spectrum tape blocks.

Each block is stored as:

```text
2-byte little-endian block length
flag byte
payload bytes
XOR checksum byte
```

The length counts the flag, payload and checksum, but not the two length bytes.

The checksum is chosen so that XORing every byte from the flag through the final
checksum gives zero:

```text
flag XOR payload[0] XOR ... XOR payload[n-1] XOR checksum = 0
```

Two flag values dominate ordinary Spectrum tapes:

```text
$00  header block
$FF  data block
```

A header announces the kind, name and size of the following data block. The ROM
then reads the data under the contract described by that header.

## Header and data travel as a pair

A standard Spectrum header payload contains seventeen bytes:

```text
byte 0      file type
bytes 1-10  ten-character name
bytes 11-12 data length
bytes 13-14 parameter 1
bytes 15-16 parameter 2
```

For a BASIC program:

```text
type        = 0
parameter 1 = autostart line, or a sentinel for no autostart
parameter 2 = program-variable-area information
```

For CODE:

```text
type        = 3
parameter 1 = load address
parameter 2 = an auxiliary value, commonly preserved from the producing tool
```

The header block itself is:

```text
$00 flag + 17 header bytes + checksum
```

Its following data block is:

```text
$FF flag + actual program bytes + checksum
```

The ROM does not need to guess how long to read. The header has already told it.

## The historical PROMETHEUS distribution tape

The recovered tape contains eight blocks, or four header/data pairs:

```text
0  BASIC header  "PROMETHEUS"  54 bytes, autostart 9999
1  BASIC data                    54 bytes
2  CODE header   "prometheus"   18,356 bytes, load at 24,000
3  CODE data                     PROMETHEUS installation image
4  CODE header   "skatecrazy"   7,291 bytes
5  CODE data                     skatecrazy payload
6  CODE header   "gensor    "     300 bytes, load at 55,000
7  CODE data                     GENSOR payload
```

The latter two programs are additional distribution material. PROMETHEUS itself
uses blocks 0 through 3.

The case difference in the names is real:

```text
BASIC: "PROMETHEUS"
CODE:  "prometheus"
```

Spectrum names are exactly ten bytes in the header and are padded with spaces
when shorter.

## The two-line BASIC loader

Decoded through the Spectrum BASIC token table, the 54-byte program is:

```basic
1 RANDOMIZE USR 24e3: STOP
9999 CLEAR 23999: LOAD "prometheus" CODE : RUN
```

`24e3` is Spectrum BASIC's printed scientific notation for 24,000.

The program autostarts at line 9999, not line 1. That ordering is deliberate.

Line 9999 performs three steps:

```basic
CLEAR 23999
LOAD "prometheus" CODE
RUN
```

`CLEAR 23999` moves BASIC's RAM boundary below the CODE load address 24,000. It
prevents BASIC variables and workspace from growing into the machine-code image.

`LOAD "prometheus" CODE` asks the ROM to find the named CODE header and load the
following data block at the address stored in that header.

`RUN` restarts the BASIC program from its first line. Execution then reaches:

```basic
1 RANDOMIZE USR 24e3
```

which calls machine code at 24,000. If that machine code unexpectedly returns,
`STOP` prevents BASIC from falling onward into the loader line and attempting to
load the tape again.

In pseudocode:

```text
autostart at 9999
reserve memory below 24000
load CODE at 24000
restart BASIC from line 1
call machine code at 24000
stop if it returns
```

## Why BASIC calls the physical load address

The CODE header says:

```text
load address = 24,000 = $5DC0
```

That is the nominal physical location of `bootstrapEntry`, not necessarily the
final home of the resident editor.

The sequence is:

```text
BASIC USR $5DC0
    -> position-independent bootstrap
    -> installer copied to $5000
    -> user-selected resident destination
    -> relocation
    -> resident entry
```

The BASIC loader knows nothing about the final installation address. It merely
enters the first-stage bootstrap at the place where the ROM put the complete
CODE block.

This separation is why PROMETHEUS can offer an installation address interactively
without constructing new BASIC text.

## The CODE header

The historical PROMETHEUS CODE header contains:

```text
type          CODE (3)
name          "prometheus"
length        18,356 bytes
load address  24,000 ($5DC0)
parameter 2   32,768 ($8000)
```

The 18,356-byte CODE data is larger than the 16,000-byte resident payload.

The difference is the temporary installation apparatus:

```text
18,356 total CODE bytes
-16,000 resident payload bytes
= 2,356 bootstrap/installer/metadata/logo bytes
```

Those first 2,356 bytes are not all copied into the final resident program.
They include:

- the physical bootstrap;
- the installer that executes from `$5000`;
- configuration and relocation streams;
- installer logo data.

The resident payload begins later in the physical CODE data. At the historical
load address `$5DC0`, its physical start is `$66F4`.

The installer can then copy all or the suffix of those 16,000 bytes to the final
destination.

## Why the complete binary must remain contiguous

The bootstrap finds the installer and payload through compile-time differences
between labels. The installer finishes drawing logo bytes and naturally reaches
the payload pointer. The relocation and configuration tables sit in the same
installation image.

Therefore the CODE block is not a loose collection of independently loadable
pieces. Its layout is one contiguous construction:

```text
bootstrap
fixed-address installer bytes
configuration metadata
relocation metadata
logo tail
origin-zero resident payload
```

The source uses `ORG` to describe different logical execution addresses, but the
assembler output still places their bytes consecutively in the CODE data.

This is a subtle point:

> Logical assembly address and physical position in the tape block are not
> always the same thing.

The bootstrap's self-location arithmetic reconnects them at runtime.

## Rebuilding one TAP block

To encode a data block from an assembled binary:

```text
bodyWithoutChecksum = $FF + binary
checksum            = XOR of bodyWithoutChecksum
body                 = bodyWithoutChecksum + checksum
storedBlock          = littleEndian(len(body)) + body
```

For the historical binary:

```text
payload bytes      18,356
flag byte               1
checksum byte           1
TAP block body      18,358
plus length field        2
```

The same process applies to headers, except the flag is `$00` and the payload is
the seventeen-byte header.

A parser can validate a block without knowing its meaning: it checks that the
stored length is available and the XOR of the complete body is zero.

## Why changing the binary length affects two blocks

Suppose the resident source grows by two bytes. The complete assembled
installation binary also grows by two bytes.

The TAP builder must update:

1. bytes 11-12 of the matching CODE header payload;
2. the header checksum;
3. the following CODE data block length field;
4. the data checksum;
5. the overall file length.

It must not merely append bytes to the old data block. The ROM trusts the header
length, and TAP readers trust the outer block length.

For example, the relocation mutation test creates:

```text
binary       18,356 -> 18,358 bytes
TAP          26,101 -> 26,103 bytes
```

The two-byte total growth is possible because the fixed-size CODE header block
keeps the same physical size; only its fields/checksum change, while the data
block gains two payload bytes.

## The resurrection's variable-length TAP builder

The reconstruction includes a host-side tool that accepts:

```text
historical template TAP
freshly assembled binary
output TAP path
CODE name, normally "prometheus"
```

It parses every block and checks every checksum. It then searches for a standard
header satisfying:

```text
flag = $00
header type = 3
name = "prometheus" padded to ten bytes
next block flag = $FF
```

Only the matched pair is changed.

Conceptually:

```text
blocks = parseAndValidate(template)

find CODE header named "prometheus"
header.length = len(newBinary)
rebuild header checksum

replace following data payload with newBinary
rebuild data block length and checksum

copy every other block byte-for-byte
parseAndValidate(result)
write result
```

This preserves the BASIC loader, `skatecrazy`, `gensor`, their headers, and every
unrelated checksum exactly.

The tool also rejects:

- malformed or truncated blocks;
- invalid XOR checksums;
- missing matching CODE header;
- a matching header not followed by data;
- binary lengths larger than the Spectrum's sixteen-bit header field.

## Original mechanism versus reconstruction tooling

The original PROMETHEUS source does not build a TAP file. It is the payload that
an external development tool placed inside a cassette image.

The modern TAP builder belongs to the resurrection project. Its purpose is to
make source changes reproducible without depending on the exact historical host
toolchain.

The distinction mirrors the generated relocation table:

```text
original runtime design:
    Spectrum BASIC and ROM load a standard CODE block
    Z80 bootstrap/installer relocates the resident program

modern reconstruction support:
    host scripts regenerate metadata and rebuild valid TAP containers
```

The new tooling does not replace the original Spectrum behavior. It prepares the
bytes that the original behavior expects.

## Historical identity as a stronger test

For unchanged source, the freshly assembled binary is exactly:

```text
size      18,356 bytes
SHA-256   940f793ad99351507d857b1d96a79bfcf3395d2e1577d633595ab7eaa67edce8
```

Replacing the historical data block with this binary and recalculating its
checksum reconstructs the complete original tape:

```text
size      26,101 bytes
SHA-256   29111b19fb680199b6ed3eee07bbd62757a25a8baefe2454a497d2f35c46a93f
```

That claim is stronger than saying “the assembler emitted equivalent code.” It
means:

- every PROMETHEUS binary byte matches;
- the CODE header metadata matches;
- the complete length-prefixed data block matches;
- all eight blocks form the same distribution tape.

For a modified source, exact historical identity is no longer expected. The
relevant guarantees become structural validity, correct lengths/checksums, and
successful relocated execution.

## What the automated tests deliberately do not reproduce

A TAP file represents logical tape blocks, not the analogue signal, cassette
motor, noise, timing or complete ROM loader interaction.

The execution harness begins after the CODE data has been placed in memory. It
models only the small ROM contracts needed by PROMETHEUS startup and executes
the real bootstrap, installer and resident program.

A faithful end-to-end test from physical tape waveform through an original
copyrighted 48K ROM is a separate problem.

This boundary is honest and useful:

```text
TAP builder tests:
    block structure, header fields, data lengths, checksums

startup emulator tests:
    bootstrap, installer, copying, metadata decoding, relocation, editor entry

not automatically tested here:
    analogue cassette signal and complete original ROM tape path
```

## What changed in the file

Building a modified TAP may change:

- the PROMETHEUS CODE header length field;
- that header block's XOR checksum;
- the following data block length field;
- the PROMETHEUS data bytes;
- that data block's XOR checksum;
- the complete TAP file length.

All unrelated blocks remain byte-for-byte unchanged.

## Important artefacts encountered

- BASIC header `"PROMETHEUS"`
- BASIC data block with lines 1 and 9999
- CODE header `"prometheus"`
- CODE data block beginning at physical `$5DC0`
- `bootstrapEntry`
- `build_tap_from_template.py`
- `verify_tap_compatibility.py`
- the canonical eight-block distribution tape

## Back to the whole machine

The tape now contains every layer required for startup:

```text
BASIC program
    -> loads the complete CODE image

CODE image
    -> locates itself
    -> installs and configures PROMETHEUS
    -> relocates the selected resident layout

resident image
    -> enters the editor
```

The next chapter follows that journey continuously, without pausing to explain a
new mechanism. It is the final top-down return for Part VII: from the first BASIC
autostart instruction to the first wait for an editor key.
