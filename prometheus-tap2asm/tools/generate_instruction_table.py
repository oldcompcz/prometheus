#!/usr/bin/env python3
"""Maintainer helper: regenerate embedded instruction metadata from the retained ASM table.

The released converter and tests do not require Python; generated .inc files are committed.
"""
from __future__ import annotations

import argparse
import re
from pathlib import Path


def parse_rows(path: Path):
    comment = ""
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith(";"):
            comment = stripped[1:].strip().split("[")[0].rstrip()
        match = re.search(r"defb\s+(.+?)(?:\s*;|$)", line, re.IGNORECASE)
        if not match:
            continue
        values = []
        for token in match.group(1).split(","):
            try:
                values.append(int(token.strip(), 0))
            except ValueError:
                break
        if len(values) != 5 or values == [0xFF] * 5:
            continue
        yield values[0], values[1] & 0xF0, values[1] & 7, comment


def write(path: Path, rows, heading: str) -> None:
    with path.open("w", encoding="utf-8", newline="\n") as stream:
        stream.write(heading + "\n")
        for opcode, prefix, storage_class, template in rows:
            escaped = template.replace("\\", "\\\\").replace('"', '\\"')
            stream.write(
                f'    {{0x{opcode:02x}, 0x{prefix:02x}, {storage_class}, "{escaped}"}},\n'
            )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "table",
        nargs="?",
        type=Path,
        default=Path("docs/PROMETHEUS-instructionTable-reference.asm"),
    )
    args = parser.parse_args()
    rows = list(parse_rows(args.table))
    if len(rows) != 686:
        raise SystemExit(f"expected 686 valid rows, found {len(rows)}")
    write(Path("src/instructions.inc"), rows,
          "/* Generated from PROMETHEUS instructionTable.asm; 686 valid records. */")
    write(Path("tests/instruction_cases.inc"), rows,
          "/* Exhaustive generated cases: opcode, prefix, storage class, canonical template. */")


if __name__ == "__main__":
    main()
