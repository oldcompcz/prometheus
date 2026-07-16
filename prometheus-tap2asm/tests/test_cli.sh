#!/bin/sh
set -eu

BIN=${PROMTAP_BIN:?PROMTAP_BIN is required}
FIX=build/test-fixtures
TMP=build/test-cli
rm -rf "$TMP"
mkdir -p "$TMP"

fail() {
    echo "CLI TEST FAILED: $*" >&2
    exit 1
}

"$BIN" --help | grep -q "TAP or BetaDisk/TR-DOS" || fail "--help"
"$BIN" --version | grep -q "1.2.0" || fail "--version"

# TAP compatibility path.
"$BIN" --list "$FIX/basic.tap" > "$TMP/list-tap.txt"
grep -q "file" "$TMP/list-tap.txt" || fail "TAP --list missing name"
grep -q "yes (5 lines)" "$TMP/list-tap.txt" || fail "TAP --list did not identify source"

"$BIN" --format compact --stdout "$FIX/basic.tap" file > "$TMP/stdout.asm"
grep -q '^    ld a,VALUE+1$' "$TMP/stdout.asm" || fail "TAP --stdout/compact"

"$BIN" --format prometheus --output "$TMP/prometheus.asm" "$FIX/basic.tap" file >/dev/null 2>"$TMP/prometheus.log"
grep -q '^         ld   a,VALUE+1$' "$TMP/prometheus.asm" || fail "prometheus formatting"

"$BIN" --format compact --line-endings crlf --output "$TMP/crlf.asm" "$FIX/basic.tap" file >/dev/null 2>/dev/null
cr_count=$(tr -cd '\r' < "$TMP/crlf.asm" | wc -c | tr -d ' ')
lf_count=$(tr -cd '\n' < "$TMP/crlf.asm" | wc -c | tr -d ' ')
[ "$cr_count" = 5 ] && [ "$lf_count" = 5 ] || fail "CRLF counts"
tr -d '\r' < "$TMP/crlf.asm" > "$TMP/crlf-normalized.asm"
cmp "$TMP/stdout.asm" "$TMP/crlf-normalized.asm" >/dev/null || fail "CRLF content"

# Configurable formatter: requested 2 TABs for instruction/label and 1 TAB for operands.
"$BIN" --format tabs --stdout "$FIX/formatting.tap" format > "$TMP/tabs.asm"
printf '; format\nSTART\t\tld\ta,#Af+%%1010\n\t\tdefb\t#ff,%%0011\n\t\tdefw\t#1234\n\t\tdefm\t"#No%%,",#41\n\t\tdefs\t%%100\n\t\tent\t#8000\n\t\tequ\t%%10\n\t\torg\t#9000\n\t\tput\t%%1\n' > "$TMP/tabs.expected"
cmp "$TMP/tabs.expected" "$TMP/tabs.asm" >/dev/null || fail "tabs layout preset"

"$BIN" --format separated --indent-char space --instruction-indent 3 --label-gap 4 --operand-gap 2 \
    --comments none --stdout "$FIX/formatting.tap" format > "$TMP/custom-spaces.asm"
grep -q '^START    ld  a,#Af+%1010$' "$TMP/custom-spaces.asm" || fail "custom label/operand spacing"
grep -q '^   defb  #ff,%0011$' "$TMP/custom-spaces.asm" || fail "custom instruction indentation"

"$BIN" --format tabs --pseudo-style db \
    --map-pseudo ent=ENTRY --map-pseudo equ=EQUAL --map-pseudo org=ORIGIN --map-pseudo put=OUTPUT \
    --hex-style dollar --bin-style 0b --number-case upper --comments none \
    --stdout "$FIX/formatting.tap" format > "$TMP/dialect.asm"
printf 'START\t\tld\ta,$AF+0B1010\n\t\tdb\t$FF,0B0011\n\t\tdw\t$1234\n\t\tdb\t"#No%%,",$41\n\t\tds\t0B100\n\t\tENTRY\t$8000\n\t\tEQUAL\t0B10\n\t\tORIGIN\t$9000\n\t\tOUTPUT\t0B1\n' > "$TMP/dialect.expected"
cmp "$TMP/dialect.expected" "$TMP/dialect.asm" >/dev/null || fail "pseudo-op and number conversion"

"$BIN" --format compact --hex-style suffix --bin-style suffix --number-case upper \
    --no-comments --stdout "$FIX/formatting.tap" format > "$TMP/suffix.asm"
grep -q '^START ld a,0AFH+1010B$' "$TMP/suffix.asm" || fail "hex/binary suffix formatting"
! grep -q '^;' "$TMP/suffix.asm" || fail "--no-comments"

"$BIN" --format compact --comments generated --stdout "$FIX/basic.tap" file > "$TMP/no-source-comments.asm"
! grep -q 'hello' "$TMP/no-source-comments.asm" || fail "source comment filtering"

"$BIN" --salvage --format compact --comments generated --stdout "$FIX/broken.tap" broken > "$TMP/generated-comments.asm"
grep -q 'prometheus-tap2asm: stopped' "$TMP/generated-comments.asm" || fail "generated diagnostic comments"
! grep -q 'before damage' "$TMP/generated-comments.asm" || fail "generated-only comment mode"

"$BIN" --salvage --format compact --no-generated-comments --stdout "$FIX/broken.tap" broken > "$TMP/source-comments.asm"
grep -q '^; before damage$' "$TMP/source-comments.asm" || fail "--no-generated-comments source preservation"
! grep -q 'prometheus-tap2asm: stopped' "$TMP/source-comments.asm" || fail "--no-generated-comments diagnostic suppression"

"$BIN" --format compact --pseudo-style prometheus --map-pseudo defb=BYTE \
    --hex-style 0x --bin-style percent --number-case lower --comments none \
    --stdout "$FIX/formatting.tap" format > "$TMP/0x-lower.asm"
grep -q '^    BYTE 0xff,%0011$' "$TMP/0x-lower.asm" || fail "custom DEFB and lower 0x formatting"
grep -q '^START ld a,0xaf+%1010$' "$TMP/0x-lower.asm" || fail "lower numeric case"

"$BIN" --format separated --instruction-indent 0 --label-gap 0 --operand-gap 0 \
    --hex-style hash --bin-style percent --comments none --stdout "$FIX/formatting.tap" format > "$TMP/zero-gaps.asm"
grep -q '^STARTlda,#Af+%1010$' "$TMP/zero-gaps.asm" || fail "zero separators"
grep -q '^defb#ff,%0011$' "$TMP/zero-gaps.asm" || fail "explicit hash/percent styles"

"$BIN" --strict --ignore-case --validate-only "$FIX/basic.tap" FILE >/dev/null 2>"$TMP/validate.log"
grep -q 'validated 5 source records' "$TMP/validate.log" || fail "TAP --validate-only"

"$BIN" --index 1 --format compact --stdout "$FIX/duplicate.tap" file > "$TMP/second.asm"
grep -q '^; second$' "$TMP/second.asm" || fail "TAP --index"

if "$BIN" --validate-only "$FIX/bad-checksum.tap" file >/dev/null 2>&1; then
    fail "strict mode accepted bad TAP checksum"
fi
"$BIN" --salvage --validate-only "$FIX/bad-checksum.tap" file >/dev/null 2>/dev/null || fail "TAP --salvage"

# TR-DOS/BetaDisk split source and symbol-table path.
"$BIN" --list "$FIX/basic.trd" > "$TMP/list-trd.txt"
grep -q 'SOURCE.C' "$TMP/list-trd.txt" || fail "TRD --list missing source"
grep -q 'source -> SYMBOL.S (5 lines)' "$TMP/list-trd.txt" || fail "TRD --list did not pair files"

"$BIN" --format compact --stdout "$FIX/basic.trd" SOURCE.C > "$TMP/trd-auto.asm"
cmp "$TMP/stdout.asm" "$TMP/trd-auto.asm" >/dev/null || fail "TRD automatic symbol pairing"

"$BIN" --format compact --stdout "$FIX/basic.trd" SOURCE.C SYMBOL.S > "$TMP/trd-positional.asm"
cmp "$TMP/stdout.asm" "$TMP/trd-positional.asm" >/dev/null || fail "TRD positional symbol file"

"$BIN" --format compact --stdout --symbols SYMBOL.S "$FIX/basic.trd" SOURCE > "$TMP/trd-option.asm"
cmp "$TMP/stdout.asm" "$TMP/trd-option.asm" >/dev/null || fail "TRD --symbols/bare source selector"

"$BIN" --ignore-case --validate-only --symbols symbol.s "$FIX/basic.trd" source.c >/dev/null 2>"$TMP/trd-validate.log"
grep -q 'validated 5 source records' "$TMP/trd-validate.log" || fail "TRD ignore-case validation"

"$BIN" --format compact --stdout --index 1 --symbols SYMTWO.S \
    "$FIX/duplicate-sources.trd" SOURCE.C > "$TMP/trd-second-source.asm"
grep -q '^; second$' "$TMP/trd-second-source.asm" || fail "TRD source --index"

"$BIN" --validate-only "$FIX/partial.trd" SOURCE.C SYMBOL.S >/dev/null 2>/dev/null \
    || fail "TRD partial raw image"

"$BIN" --salvage --list "$FIX/bad-directory.trd" > "$TMP/trd-salvage-list.txt" 2> "$TMP/trd-salvage-list.err"
grep -q 'SOURCE.C' "$TMP/trd-salvage-list.txt" || fail "TRD salvage listing"
grep -q 'warning(s) ignored' "$TMP/trd-salvage-list.txt" || fail "TRD salvage warning"

if "$BIN" --validate-only "$FIX/duplicate-symbols.trd" SOURCE.C >/dev/null 2>&1; then
    fail "TRD auto-pair accepted ambiguous symbols"
fi
"$BIN" --validate-only --symbols SYMBOL.S --symbols-index 1 "$FIX/duplicate-symbols.trd" SOURCE.C >/dev/null 2>/dev/null \
    || fail "TRD --symbols-index"

"$BIN" --format compact --stdout --source-offset 0x2 --source-length 37 --symbols-offset 3 \
    "$FIX/wrapped.trd" WRAPSRC.C WRAPSYM.S > "$TMP/trd-wrapped.asm"
cmp "$TMP/stdout.asm" "$TMP/trd-wrapped.asm" >/dev/null || fail "TRD split ranges"

if "$BIN" --validate-only --source-offset 2 --source-length 9999 --symbols-offset 3 \
    "$FIX/wrapped.trd" WRAPSRC.C WRAPSYM.S >/dev/null 2>&1; then
    fail "TRD accepted source range beyond file"
fi
if "$BIN" --validate-only "$FIX/bad-directory.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then
    fail "TRD strict mode accepted malformed directory allocation"
fi

(
  cd "$TMP"
  "$BIN" --format compact "$OLDPWD/$FIX/basic.tap" file >/dev/null 2>/dev/null
  test -f file.asm
  "$BIN" --format compact "$OLDPWD/$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>/dev/null
  test -f SOURCE.C.asm
) || fail "default output filenames"

# Invalid combinations and values.
if "$BIN" --bogus "$FIX/basic.tap" file >/dev/null 2>&1; then fail "unknown option"; fi
if "$BIN" "$FIX/basic.tap" >/dev/null 2>&1; then fail "missing NAME"; fi
if "$BIN" --stdout --output "$TMP/x" "$FIX/basic.tap" file >/dev/null 2>&1; then fail "conflicting output options"; fi
if "$BIN" --format invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid format"; fi
if "$BIN" --line-endings invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid line endings"; fi
if "$BIN" --index nope "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid index"; fi
if "$BIN" --symbols-index nope "$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then fail "invalid symbols index"; fi
if "$BIN" --symbols-index 1 "$FIX/basic.trd" SOURCE.C >/dev/null 2>&1; then fail "symbols index without selector"; fi
if "$BIN" --source-offset nope "$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then fail "invalid source offset"; fi
if "$BIN" --source-length nope "$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then fail "invalid source length"; fi
if "$BIN" --symbols-offset nope "$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then fail "invalid symbols offset"; fi
if "$BIN" --list --stdout "$FIX/basic.tap" >/dev/null 2>&1; then fail "invalid list combination"; fi
if "$BIN" --list "$FIX/basic.trd" SOURCE.C >/dev/null 2>&1; then fail "list with source name"; fi
if "$BIN" --symbols SYMBOL.S "$FIX/basic.trd" SOURCE.C SYMBOL.S >/dev/null 2>&1; then fail "duplicate symbol selector"; fi
if "$BIN" --symbols SYMBOL.S "$FIX/basic.tap" file >/dev/null 2>&1; then fail "separate symbols on TAP"; fi
if "$BIN" --source-offset 1 "$FIX/basic.tap" file >/dev/null 2>&1; then fail "TRD offset on TAP"; fi
if "$BIN" --validate-only "$FIX/basic.trd" 'SOURCE.LONG' SYMBOL.S >/dev/null 2>&1; then fail "invalid TRD type selector"; fi
if "$BIN" --indent-char commas "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid indent character"; fi
if "$BIN" --instruction-indent 1025 "$FIX/basic.tap" file >/dev/null 2>&1; then fail "oversized instruction indent"; fi
if "$BIN" --label-gap nope "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid label gap"; fi
if "$BIN" --operand-gap nope "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid operand gap"; fi
if "$BIN" --pseudo-style invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid pseudo style"; fi
if "$BIN" --map-pseudo nope=db "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid pseudo mapping key"; fi
if "$BIN" --map-pseudo defb= "$FIX/basic.tap" file >/dev/null 2>&1; then fail "empty pseudo mapping"; fi
if "$BIN" --hex-style invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid hex style"; fi
if "$BIN" --bin-style invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid binary style"; fi
if "$BIN" --number-case invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid number case"; fi
if "$BIN" --comments invalid "$FIX/basic.tap" file >/dev/null 2>&1; then fail "invalid comment mode"; fi

echo "all TAP, TR-DOS, and formatter CLI option checks passed"
