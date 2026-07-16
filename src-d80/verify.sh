#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
python3 "$ROOT/tools/verify_byteexact_sources.py"
python3 "$ROOT/tools/verify_exact.py"
