#!/usr/bin/env python3
"""Replace the PROMETHEUS CODE block in a Spectrum TAP template.

Unlike the historical identity checker, this builder accepts a changed binary
length.  It updates the CODE header length, recalculates both affected XOR
checksums, and preserves every other block byte-for-byte.
"""
from __future__ import annotations

import argparse
import struct
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Block:
    body: bytes

    @property
    def flag(self) -> int:
        return self.body[0]

    @property
    def payload(self) -> bytes:
        return self.body[1:-1]


def checksum(data: bytes) -> int:
    value = 0
    for byte in data:
        value ^= byte
    return value


def parse_tap(data: bytes) -> list[Block]:
    blocks: list[Block] = []
    offset = 0
    while offset < len(data):
        if offset + 2 > len(data):
            raise ValueError("truncated TAP length")
        length = struct.unpack_from("<H", data, offset)[0]
        offset += 2
        body = data[offset : offset + length]
        if len(body) != length:
            raise ValueError("truncated TAP block")
        if length < 2 or checksum(body) != 0:
            raise ValueError("invalid TAP block or XOR checksum")
        blocks.append(Block(body))
        offset += length
    return blocks


def encode_body(body_without_checksum: bytes) -> bytes:
    body = body_without_checksum + bytes([checksum(body_without_checksum)])
    return struct.pack("<H", len(body)) + body


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--template", type=Path, required=True)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--code-name", default="prometheus")
    args = parser.parse_args()

    name = args.code_name.encode("latin1")
    if len(name) > 10:
        raise ValueError("Spectrum header names are at most ten bytes")
    name = name.ljust(10, b" ")

    blocks = parse_tap(args.template.read_bytes())
    binary = args.binary.read_bytes()
    if len(binary) > 0xFFFF:
        raise ValueError("CODE payload exceeds Spectrum header length field")

    target: int | None = None
    for index, block in enumerate(blocks[:-1]):
        if block.flag != 0x00 or len(block.body) != 19:
            continue
        header = bytearray(block.payload)
        if header[0] == 3 and bytes(header[1:11]) == name:
            if blocks[index + 1].flag != 0xFF:
                raise ValueError("matching CODE header is not followed by data")
            target = index
            break
    if target is None:
        raise ValueError(f"CODE header {args.code_name!r} not found")

    header = bytearray(blocks[target].payload)
    struct.pack_into("<H", header, 11, len(binary))

    encoded: list[bytes] = []
    for index, block in enumerate(blocks):
        if index == target:
            encoded.append(encode_body(bytes([0x00]) + bytes(header)))
        elif index == target + 1:
            encoded.append(encode_body(bytes([0xFF]) + binary))
        else:
            encoded.append(struct.pack("<H", len(block.body)) + block.body)

    output = b"".join(encoded)
    # Parse the result again so malformed output cannot be written silently.
    parse_tap(output)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(output)
    print(f"Wrote {len(output)}-byte TAP with {len(binary)}-byte PROMETHEUS CODE payload")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
