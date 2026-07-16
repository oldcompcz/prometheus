#!/usr/bin/env python3
from pathlib import Path
import hashlib, subprocess, sys
root=Path(__file__).resolve().parents[1]
subprocess.run([sys.executable,str(root/'tools/build_floppy_variants.py')],check=True)
expected={
  'promdiskam.bin':(20124,'e0617fadc3ac124ed0963741e32c51a2c4caaab0f6949d0e25f1f5cfb2d24e90'),
  'promdiska.bin':(13700,'2fcad91c25e95afaa8b6c2d0c40b4d6536ffc534dc42120f180e9bbf16af6cdc')}
for name,(size,digest) in expected.items():
  data=(root/'build'/name).read_bytes(); got=hashlib.sha256(data).hexdigest()
  assert len(data)==size,(name,len(data),size); assert got==digest,(name,got,digest)
  print('PASS',name,size,got)
