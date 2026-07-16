#!/usr/bin/env python3
"""Reconstruct the two historical floppy CODE blocks from v042 + exact segments."""
from pathlib import Path
import re, hashlib

ROOT=Path(__file__).resolve().parents[1]
BASE=(ROOT/'reference/base/prometheus-v042.bin').read_bytes()
REPORT=(ROOT/'reference/base/RELOCATION-GENERATION-V040.txt').read_text()
PAYLOAD=bytearray(BASE[2356:])
RELOCS=[(int(m.group(1),16),m.group(2)) for m in re.finditer(r'^\$([0-9A-Fa-f]{4})\s+(monitor|assembler)\s+\$[0-9A-Fa-f]{4}$',REPORT,re.M)]
assert len(RELOCS)==1293 and len(PAYLOAD)==16000

def putw(buf,o,v): buf[o:o+2]=int(v&0xffff).to_bytes(2,'little')
def relocate(origin, sections):
    out=bytearray(PAYLOAD)
    for off,section in RELOCS:
        if section in sections:
            putw(out,off,int.from_bytes(PAYLOAD[off:off+2],'little')+origin)
    return out

full=relocate(0x7c38,{'monitor','assembler'})
full[0x0f04]=0x30; putw(full,0x1b72,0x7918); full[0x2950]=0x0a; full[0x2959]=0x07
for off,rel in [(0x2991,0x2faf),(0x2dd3,0x29ad),(0x2dd9,0x2988),(0x2ddb,0x2c61),(0x2ddd,0x1f43),(0x2ddf,0x1f0f)]: putw(full,off,0x7c38+rel)
full_image=(ROOT/'reference/full/installer.bin').read_bytes()+(ROOT/'reference/full/driver.bin').read_bytes()+full

asm=relocate(0x67ee,{'assembler'})
putw(asm,0x1b72,0x7918); putw(asm,0x1e13,0x7b76); asm[0x2950]=0x0a; asm[0x2959]=0x07
for off,rel in [(0x2991,0x2faf),(0x2dd3,0x29ad),(0x2dd9,0x2988),(0x2ddb,0x2c61),(0x2ddd,0x1f43),(0x2ddf,0x1f0f)]: putw(asm,off,0x67ee+rel)
asm_image=(ROOT/'reference/assembler-only/installer.bin').read_bytes()+(ROOT/'reference/assembler-only/driver.bin').read_bytes()+asm[0x1388:0x3e7a]

out=ROOT/'build'; out.mkdir(exist_ok=True)
(out/'promdiskam.bin').write_bytes(full_image); (out/'promdiska.bin').write_bytes(asm_image)
print('promdiskam.bin',len(full_image),hashlib.sha256(full_image).hexdigest())
print('promdiska.bin ',len(asm_image),hashlib.sha256(asm_image).hexdigest())
