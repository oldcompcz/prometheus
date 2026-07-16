# Byte-exact comment decompilation

The four `*.byteexact.asm` files are no longer generic twelve-byte `DEFB` dumps.
They retain `DEFB` as the authoritative encoding, but explain every byte according
to its actual role.

## Why the instructions remain `DEFB`

Replacing all bytes with ordinary assembler mnemonics would introduce avoidable
risk: assembler dialect differences, undocumented-opcode normalization, expression
re-evaluation, and accidental reinterpretation of inline data can all change a
historical binary. In these files, the bytes remain primary and the decompilation
is placed beside them:

```asm
    defb 0cdh, 0a5h, 041h ; runtime $406F, stored $5E2F: call $41a5
```

`tools/verify_byteexact_sources.py` parses every `DEFB` row and compares the result
with the extracted historical segment. Thus the comments can evolve without
weakening binary verification.

## Driver coverage

| Driver | Total | Decoded executable bytes | Typed data bytes |
|---|---:|---:|---:|
| Full monitor + assembler | 800 | 727 | 73 |
| Assembler only | 606 | 540 | 66 |

Executable regions are decoded one instruction per row. Routine labels and
higher-level comments identify hook installation/restoration, source checksum
handling, filename normalization, `LOAD !` catalogue handling, M-DOS context
construction, error recovery, UI restoration, message display, and overwrite
policy.

The non-executable bytes are not disguised as instructions:

- each driver has an exact 28-byte M-DOS operation descriptor/workspace;
- high-bit-terminated `Not found`, `Overwrite?`, and `Disk error` messages are
  decoded as strings;
- status-line erasure text and trailing reserved zeroes are marked as data.

The exact field-level ABI of the 28-byte M-DOS descriptor is intentionally not
claimed without the matching D40/D80 ROM source. Its use and boundaries are known;
its internal field names remain an open low-level documentation task.

## Installer coverage

Both installers have the same 480-byte structural front:

- 23-byte self-locating bootstrap executing at the physical load address `$5DC0`;
- 388 bytes of runtime Z80 code copied to and executing at `$4017`;
- 69 bytes of inline high-bit-terminated display text.

Every runtime instruction comment includes both addresses: its execution address
and its storage address inside the distribution image. The code is divided into
coherent routines for:

- completing the installer copy and appending a synthetic relocation terminator;
- initializing the screen workspace;
- displaying and editing the five-digit installation address;
- decimal formatting and parsing;
- overlap-safe movement of the resident driver/body;
- applying the relocation table;
- rendering inline text from the Spectrum ROM font.

Everything after runtime `$41E0` is a relocation table, not executable code. It is
now decoded one record per row.

| Installer | Relocation records | Whole-word | Split-low | Split-high |
|---|---:|---:|---:|---:|
| Full | 1,422 | 1,404 | 9 | 9 |
| Assembler only | 810 | 800 | 5 | 5 |

The type is stored in the top two bits of each record:

- `$0000-$3FFF`: add the complete 16-bit relocation delta to a word;
- `$8000-$BFFF`: relocate a separated low byte and save its carry;
- `$4000-$7FFF`: relocate the matching separated high byte using that carry.

The lower 14 bits are the patch offset. The table does not contain its own zero
terminator in the distributed image; the installer writes two zero bytes after the
copied table before processing it.

## Verification

Run:

```sh
./verify.sh
```

It now performs two independent checks:

1. re-decodes all four comment-decompiled `DEFB` sources and compares them with the
   extracted installer/driver binaries;
2. reconstructs the two complete floppy images and checks their historical
   SHA-256 identities.
