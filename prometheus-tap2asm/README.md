# prometheus-tap2asm 1.2.0

A dependency-free C11 command-line tool that recovers native **PROMETHEUS ZX Spectrum assembler sources** and writes configurable text `.asm` files.

Supported containers:

- standard uncompressed Spectrum `.tap` images, where PROMETHEUS stores source and symbols together;
- raw BetaDisk/TR-DOS `.trd` images, including variants that store compressed source and the symbol table in separate files.

The bundle is standalone. It contains the PROMETHEUS instruction metadata and needs no emulator, resurrected assembler, Python runtime, or external library.

## Build

With Make:

```sh
make
```

The executable is created as:

```text
build/prometheus-tap2asm
```

With CMake:

```sh
cmake -S . -B build-cmake
cmake --build build-cmake
ctest --test-dir build-cmake --output-on-failure
```

## TAP use

List a tape and identify native PROMETHEUS source blocks:

```sh
build/prometheus-tap2asm --list prometheus-48.tap
```

Convert the tape file named `file`:

```sh
build/prometheus-tap2asm prometheus-48.tap file
```

This writes `file.asm`.

## BetaDisk/TR-DOS use

List the catalogue and probe possible PROMETHEUS source/symbol pairs:

```sh
build/prometheus-tap2asm --list sources.trd
```

TR-DOS names contain an eight-character filename and a one-character type. Use `NAME.T`, `NAME:T`, or `NAME/T` to select both. A bare `NAME` matches any type.

Convert a source whose separate symbol table can be identified uniquely:

```sh
build/prometheus-tap2asm sources.trd SOURCE.C
```

Select the symbol table explicitly:

```sh
build/prometheus-tap2asm sources.trd SOURCE.C SYMBOL.S
```

or:

```sh
build/prometheus-tap2asm --symbols SYMBOL.S sources.trd SOURCE.C
```

When `SYMBOLS` is omitted, every other active TR-DOS file is tested as a strict PROMETHEUS symbol table. Conversion proceeds only when exactly one file validates the complete source. Ambiguity is reported rather than guessed.

### Wrapped or prefixed disk files

Some adaptations may put private bytes before one or both structures:

```sh
build/prometheus-tap2asm \
  --source-offset 2 \
  --source-length 12034 \
  --symbols-offset 4 \
  sources.trd SOURCE.C SYMBOL.S
```

Numbers may be decimal or C-style hexadecimal such as `0x2`.

- `--source-offset` skips bytes before the compressed source.
- `--source-length` limits decoding to an exact byte count; otherwise the rest of the TR-DOS file is used.
- `--symbols-offset` skips bytes before the symbol-table counter.

These options apply only to `.trd` input.

## Configurable output

Version 1.2 separates decoding from formatting. Existing output remains compatible, while new profiles can target other assemblers and editor conventions.

### Requested TAB layout

```sh
build/prometheus-tap2asm \
  --format tabs \
  --stdout \
  sources.trd SOURCE.C SYMBOL.S
```

This emits:

- two actual TAB characters before an unlabelled instruction;
- two TAB characters between a label and its instruction;
- one TAB character between the mnemonic and operands.

Equivalent fully explicit form:

```sh
build/prometheus-tap2asm \
  --format separated \
  --indent-char tab \
  --instruction-indent 2 \
  --label-gap 2 \
  --operand-gap 1 \
  sources.trd SOURCE.C SYMBOL.S
```

Spaces and all three counts are independently configurable. Zero is allowed.

### Convert PROMETHEUS data directives

```sh
build/prometheus-tap2asm \
  --pseudo-style db \
  sources.trd SOURCE.C SYMBOL.S
```

The preset maps:

```text
defb -> db
defw -> dw
defm -> db
defs -> ds
```

Other pseudo-operations can be changed individually:

```sh
--map-pseudo ent=ENTRY \
--map-pseudo equ=EQUAL \
--map-pseudo org=ORIGIN \
--map-pseudo put=OUTPUT
```

Individual overrides are supported for `defb`, `defw`, `defm`, `defs`, `ent`, `equ`, `org`, and `put`.

### Convert hexadecimal and binary syntax

```sh
--hex-style keep|hash|dollar|0x|suffix
--bin-style keep|percent|0b|suffix
--number-case preserve|lower|upper
```

Examples:

```text
#AF   $AF   0xAF   0AFh
%1010 0b1010 1010b
```

Only literals already stored as hexadecimal or binary are changed. Decimal values are not converted to another base. Quoted strings, symbol names, comments, the standalone `$` current-address expression, and generated `<SYM#n>` placeholders are left untouched.

### Select comments

```sh
--comments all|source|generated|none
--no-generated-comments
--no-comments
```

“Source” means comment records saved in the PROMETHEUS source. “Generated” currently means salvage diagnostics inserted when decoding stops at a damaged record.

A complete target-assembler example:

```sh
build/prometheus-tap2asm \
  --format tabs \
  --pseudo-style db \
  --hex-style dollar \
  --bin-style percent \
  --number-case upper \
  --comments source \
  --output recovered.asm \
  sources.trd PROGRAM.C SYMBOLS.S
```

See [`docs/OUTPUT-FORMATTING.md`](docs/OUTPUT-FORMATTING.md) for exact behavior and examples.

## Output destination and validation

Write to a chosen path:

```sh
build/prometheus-tap2asm -o recovered.asm sources.trd SOURCE.C SYMBOL.S
```

Write to standard output:

```sh
build/prometheus-tap2asm --stdout sources.trd SOURCE.C SYMBOL.S
```

Validate without writing text:

```sh
build/prometheus-tap2asm --validate-only sources.trd SOURCE.C SYMBOL.S
```

## Command line

```text
prometheus-tap2asm --list [--salvage] IMAGE.tap|IMAGE.trd
prometheus-tap2asm [options] IMAGE.tap NAME
prometheus-tap2asm [options] IMAGE.trd SOURCE [SYMBOLS]
```

### Input and output

| Option | Meaning |
|---|---|
| `-l`, `--list` | List TAP headers or the active TR-DOS catalogue and probe PROMETHEUS content. |
| `-o FILE`, `--output FILE` | Write to an explicit output file. |
| `--stdout` | Write assembly text to standard output. |
| `--validate-only` | Parse and validate the complete source without creating output. |
| `--symbols NAME` | Select a separate TR-DOS symbol-table file. |
| `--line-endings lf|crlf` | Select line endings. |

### Layout

| Option | Meaning |
|---|---|
| `--format prometheus` | Original 9-column label and 5-column mnemonic fields. Default. |
| `--format compact` | Four-space instruction indentation and single field spaces. |
| `--format tabs` | Two TABs before/after labels and one TAB before operands. |
| `--format separated` | Fixed configurable separator characters. |
| `--indent-char space|tab` | Character used by separated layout. |
| `--instruction-indent N` | Characters before an unlabelled instruction. |
| `--label-gap N` | Characters between label and mnemonic. |
| `--operand-gap N` | Characters between mnemonic and operands. |

### Assembler syntax

| Option | Meaning |
|---|---|
| `--pseudo-style prometheus|db` | Original directives or `db/dw/db/ds` data directives. |
| `--map-pseudo OLD=NEW` | Override one supported pseudo-operation name. Repeatable. |
| `--hex-style keep|hash|dollar|0x|suffix` | Select hexadecimal literal syntax. |
| `--bin-style keep|percent|0b|suffix` | Select binary literal syntax. |
| `--number-case preserve|lower|upper` | Select letter case in converted numeric literals. |
| `--comments all|source|generated|none` | Select emitted comment classes. |
| `--no-generated-comments` | Preserve source comments and suppress generated diagnostics. |
| `--no-comments` | Suppress all comment lines. |

### Selection and recovery

| Option | Meaning |
|---|---|
| `--ignore-case` | Match TAP and TR-DOS names without ASCII case sensitivity. |
| `--index N` | Select zero-based source occurrence among duplicate matching names. |
| `--symbols-index N` | Select zero-based symbol occurrence among duplicate matching names. |
| `--source-offset N` | Skip initial source-file bytes in a TR-DOS image. |
| `--source-length N` | Decode exactly `N` source bytes in a TR-DOS image. |
| `--symbols-offset N` | Skip initial symbol-file bytes in a TR-DOS image. |
| `--strict` | Reject damaged input. Default. |
| `--salvage` | Tolerate recoverable damage, unresolved symbols, and a damaged final source region. |
| `--version` | Print the version. |
| `--help` | Print command help. |

## What is decoded

The converter decodes:

- all 686 valid PROMETHEUS instruction-table records;
- ordinary, CB, ED, DD/IX, and FD/IY instruction families;
- undocumented `HX`, `LX`, `HY`, and `LY` register spellings used by PROMETHEUS;
- labels and expression symbols through stable one-based symbol ordinals;
- empty and label-only lines;
- comments, preserving their stored text when enabled;
- `ENT`, `EQU`, `ORG`, `PUT`, `DEFB`, `DEFM`, `DEFS`, and `DEFW`;
- one- and two-expression indexed forms such as `LD (IX+d),n`;
- decimal, hexadecimal, binary, quoted, and symbolic expression text.

## Information that cannot be recovered

PROMETHEUS deliberately compresses source lines. A text export cannot recover information that was not stored:

- symbol spelling is normalized to uppercase;
- mnemonic spelling is reconstructed in PROMETHEUS's canonical lowercase form before optional directive mapping;
- arbitrary original spaces are replaced by the chosen canonical layout;
- instruction text is reconstructed from opcode/prefix metadata rather than copied from the original entry.

Comments and quoted text remain byte-for-byte as stored unless comments are explicitly suppressed.

## TR-DOS scope

The `.trd` reader implements the ordinary TR-DOS filesystem layout:

- 256-byte sectors;
- 16 sectors per logical track;
- 16-byte directory descriptors in the first eight sectors;
- contiguous, non-fragmented files;
- exact byte length from the directory descriptor for non-BASIC files;
- partial `.trd` images, provided every selected file is physically present.

It does not currently read SCL, FDI, physical-sector DSK, flux, or controller-level images. Convert those to a raw `.trd` image first.

The common split layout is assumed by default:

```text
source file: compressed PROMETHEUS source records
symbol file: two-byte count, ordinal vectors, physical value/name records
```

The offset/length options cover variants with small private wrappers. Since no original split-file archival image has yet been supplied, that path is validated with generated byte-exact TR-DOS fixtures. A real requester image remains the final compatibility check.

## Tests

Run the complete suite:

```sh
make test
```

Run with AddressSanitizer and UndefinedBehaviorSanitizer:

```sh
make sanitize
```

Coverage includes:

- every one of the 686 valid instruction records;
- all 117 applicable FD/IY transformations in addition to DD/IX forms;
- TAP and raw TR-DOS construction and extraction;
- combined and split source/symbol layouts;
- strict, salvage, duplicate-name, wrapper-offset, and malformed-image paths;
- all output layouts, separator characters/counts, directive presets and overrides;
- every hexadecimal and binary syntax, number-case mode, and comment mode;
- all documented command-line options and invalid values;
- strict public-API validation of malformed formatting settings.

Release verification also converts the historical `prometheus-48.tap` source `skatecrazy`, containing 1,331 records, with both compatibility and customized output profiles.

The current release passes **3,273 core assertions** plus the complete TAP/TR-DOS/formatter CLI matrix under normal and sanitizer builds.

## Exit status

- `0`: success;
- `1`: input, validation, decoding, or output failure;
- `2`: command-line usage error.

## Source provenance

`src/instructions.inc` is generated from the reconstructed PROMETHEUS `instructionTable.asm`. The retained reference table and generator are in `docs/` and `tools/` so the embedded metadata can be audited or regenerated.

TR-DOS filesystem notes are recorded in `docs/BETADISK-TRDOS.md`.
