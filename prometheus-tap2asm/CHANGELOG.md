# Changelog

## 1.2.0

- Added fixed-separator output formatting with independently configurable:
  - space or TAB separator characters;
  - indentation before unlabelled instructions;
  - label-to-instruction gap;
  - instruction-to-operands gap.
- Added the requested `--format tabs` preset: two TABs before instructions, two TABs after labels, and one TAB before operands.
- Added pseudo-operation dialect conversion:
  - PROMETHEUS spelling preset;
  - `db/dw/db/ds` data-directive preset;
  - individual mappings for `defb`, `defw`, `defm`, `defs`, `ent`, `equ`, `org`, and `put`.
- Added hexadecimal syntax conversion to `#FF`, `$FF`, `0xFF`, or `0FFh` forms.
- Added binary syntax conversion to `%1010`, `0b1010`, or `1010b` forms.
- Added configurable upper/lower/preserved letter case for numeric literals.
- Numeric conversion now deliberately skips quoted strings and generated unresolved-symbol placeholders.
- Added independent source-comment and generated-diagnostic filtering.
- Added strict public-API validation for every formatting option and directive name.
- Expanded the generated fixtures and CLI matrix to cover every new option, preset, mapping, syntax style, zero-length separator, and invalid value.
- Retained byte-for-byte compatibility for the pre-existing `prometheus` and `compact` output modes.

## 1.1.0

- Added raw BetaDisk/TR-DOS `.trd` catalogue parsing and file extraction.
- Added separate PROMETHEUS compressed-source and symbol-table file decoding.
- Added strict automatic source/symbol pairing with ambiguity rejection.
- Added explicit `SYMBOLS` positional argument and `--symbols` option.
- Added type-qualified TR-DOS selectors and duplicate source/symbol occurrence selection.
- Added `--source-offset`, `--source-length`, and `--symbols-offset` for adaptation-specific wrappers.
- Added TR-DOS catalogue PROMETHEUS-role probing.
- Added generated TR-DOS images, malformed-directory cases, split-wrapper cases, and complete CLI regression coverage.
- Retained the original TAP API and command syntax.

## 1.0.0

- Initial standalone TAP-to-ASM converter.
- Exhaustive PROMETHEUS instruction-table tests.
- Strict/salvage modes, formatting modes, line-ending selection, listing, and validation-only operation.
