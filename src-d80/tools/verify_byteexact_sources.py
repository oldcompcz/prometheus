#!/usr/bin/env python3
"""Verify that every comment-decompiled DEFB source still encodes its reference bytes."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
DEFB_RE = re.compile(r'^\s*defb\s+(.+?)(?:\s*;.*)?$', re.I)


def parse_number(token: str) -> int:
    token = token.strip().lower()
    if token.startswith('0x'):
        value = int(token, 16)
    elif token.endswith('h'):
        value = int(token[:-1], 16)
    else:
        value = int(token, 10)
    if not 0 <= value <= 255:
        raise ValueError(f'byte out of range: {token}')
    return value


def parse_defb_file(path: Path) -> bytes:
    out = bytearray()
    for line_no, line in enumerate(path.read_text(encoding='utf-8').splitlines(), 1):
        match = DEFB_RE.match(line)
        if not match:
            continue
        try:
            out.extend(parse_number(token) for token in match.group(1).split(','))
        except Exception as exc:
            raise ValueError(f'{path}:{line_no}: {exc}') from exc
    return bytes(out)


CASES = [
    ('src/floppy/driver-full.byteexact.asm', 'reference/full/driver.bin'),
    ('src/floppy/driver-assembler-only.byteexact.asm', 'reference/assembler-only/driver.bin'),
    ('src/floppy/installer-full.byteexact.asm', 'reference/full/installer.bin'),
    ('src/floppy/installer-assembler-only.byteexact.asm', 'reference/assembler-only/installer.bin'),
]

for source_name, reference_name in CASES:
    source = ROOT/source_name
    reference = (ROOT/reference_name).read_bytes()
    decoded = parse_defb_file(source)
    assert decoded == reference, (
        source_name,
        len(decoded), len(reference),
        next((i for i, (a, b) in enumerate(zip(decoded, reference)) if a != b), None),
    )
    print(f'PASS {source_name}: {len(decoded)} byte-exact bytes')
