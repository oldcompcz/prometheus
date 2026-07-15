#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="$ROOT/out"
SOURCE="$ROOT/src/prometheus.asm"
TEMPLATE="$ROOT/tap/prometheus-48.tap"
BINARY="$OUT/prometheus.bin"
TAP="$OUT/prometheus.tap"

for command in z80asm python3; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "Error: required command '$command' was not found." >&2
        exit 1
    fi
done

mkdir -p "$OUT"

z80asm "$SOURCE" -I "$ROOT/src" -o "$BINARY"

python3 "$ROOT/tools/build_tap_from_template.py" \
    --template "$TEMPLATE" \
    --binary "$BINARY" \
    --output "$TAP" \
    --code-name prometheus

echo
echo "Build complete:"
echo "  Binary: $BINARY ($(wc -c < "$BINARY" | tr -d ' ') bytes)"
echo "  TAP:    $TAP ($(wc -c < "$TAP" | tr -d ' ') bytes)"
