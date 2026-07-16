# Configurable assembly-text output

The decoder and formatter are separate stages. All options in this document change only the emitted text; they do not change which PROMETHEUS records are accepted or how symbol ordinals are resolved. Command-line formatting options are applied from left to right, so select a preset before applying its individual overrides.

## Layout profiles

### `--format prometheus`

The compatibility default. Labels begin in column 1, mnemonics begin in column 10, and operands begin after the five-character mnemonic field.

```text
START    ld   a,VALUE
         ret
```

This reproduces the formatting used by versions 1.0 and 1.1.

### `--format compact`

Unlabelled instructions receive four leading spaces. Labelled instructions use one space after the label, and operands use one space after the mnemonic.

```text
START ld a,VALUE
    ret
```

This also remains byte-for-byte compatible with versions 1.0 and 1.1.

### `--format tabs`

A convenience preset implementing the requested Slovak-user convention:

- two actual TAB characters before an unlabelled instruction;
- two actual TAB characters after a label;
- one actual TAB character before operands.

Conceptually:

```text
START<TAB><TAB>ld<TAB>a,VALUE
<TAB><TAB>ret
```

The output contains `0x09` TAB bytes, not spaces expanded to a particular tab width.

### `--format separated`

Uses fixed repeated separator characters. Configure it with:

```text
--indent-char space|tab
--instruction-indent N
--label-gap N
--operand-gap N
```

The counts are numbers of literal characters, not visual columns or tab stops. Zero is valid.

Example equivalent to `--format tabs`:

```sh
prometheus-tap2asm \
  --format separated \
  --indent-char tab \
  --instruction-indent 2 \
  --label-gap 2 \
  --operand-gap 1 \
  IMAGE.trd SOURCE.C SYMBOL.S
```

A space-oriented custom style:

```sh
prometheus-tap2asm \
  --format separated \
  --indent-char space \
  --instruction-indent 8 \
  --label-gap 4 \
  --operand-gap 2 \
  IMAGE.tap file
```

Specifying any of the custom separator options automatically selects the separated layout.

## Pseudo-operation dialects

### PROMETHEUS spelling

```sh
--pseudo-style prometheus
```

Emits:

```text
defb defw defm defs ent equ org put
```

This is the default.

### DB/DW spelling

```sh
--pseudo-style db
```

Maps the data directives as follows:

```text
defb -> db
defw -> dw
defm -> db
defs -> ds
```

`ent`, `equ`, `org`, and `put` remain unchanged because their correct replacement depends on the target assembler and project structure.

### Individual mappings

Use `--map-pseudo OLD=NEW` repeatedly:

```sh
--pseudo-style db \
--map-pseudo ent=ENTRY \
--map-pseudo equ=EQUAL \
--map-pseudo org=ORIGIN \
--map-pseudo put=OUTPUT
```

Supported source names are:

```text
defb defw defm defs ent equ org put
```

Replacement names must be non-empty, shorter than 32 bytes, and contain no whitespace or `=` character.

Options are applied from left to right. Put individual mappings after the chosen preset so that the preset does not overwrite them.

## Hexadecimal literals

PROMETHEUS hexadecimal literals beginning with `#` can be emitted as:

| Option | Example |
|---|---|
| `--hex-style keep` | `#AF` |
| `--hex-style hash` | `#AF` |
| `--hex-style dollar` | `$AF` |
| `--hex-style 0x` | `0xAF` |
| `--hex-style suffix` | `0AFh` |

The suffix form adds a leading zero when the first hexadecimal digit is `A` through `F`, preventing the token from being interpreted as an identifier.

The standalone `$` current-address expression is not changed.

## Binary literals

PROMETHEUS binary literals beginning with `%` can be emitted as:

| Option | Example |
|---|---|
| `--bin-style keep` | `%1010` |
| `--bin-style percent` | `%1010` |
| `--bin-style 0b` | `0b1010` |
| `--bin-style suffix` | `1010b` |

## Numeric letter case

```text
--number-case preserve
--number-case lower
--number-case upper
```

This affects hexadecimal digits `A` through `F` and alphabetic literal markers such as `x`, `b`, and `h`.

Examples:

```text
0xaf   0b1010   0afh
0XAF   0B1010   0AFH
```

Decimal numbers are not converted to another base. The tool changes only the syntax of literals already stored as hexadecimal or binary.

Literal conversion is lexical and deliberately does not touch:

- text inside single- or double-quoted strings;
- symbol names;
- the standalone `$` current-address expression;
- generated `<SYM#n>` salvage placeholders;
- source comments.

## Comments

PROMETHEUS source comments and converter-generated salvage diagnostics can be selected independently:

| Option | Source comments | Generated diagnostics |
|---|---:|---:|
| `--comments all` | yes | yes |
| `--comments source` | yes | no |
| `--comments generated` | no | yes |
| `--comments none` | no | no |

Convenience aliases:

```text
--no-generated-comments
--no-comments
```

Generated output comments are currently used only in salvage mode when decoding stops at a damaged source record. Suppressing them does not suppress the warning count reported by the program.

## Complete requested-style example

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

Typical output:

```text
START<TAB><TAB>ld<TAB>a,$FF
<TAB><TAB>db<TAB>%10101010,$00
```
