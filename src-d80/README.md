# PROMETHEUS D40/D80 decompilation

This bundle reconstructs the two historical floppy variants from the semantic
PROMETHEUS v042 source and identifies the exact delta from the tape edition.

Start with:

- `docs/EXACT-CHANGES.md` — architecture, hook map, relocation, and exact changes;
- `docs/BYTEEXACT-COMMENT-DECOMPILATION.md` — how every installer/driver byte is
  decoded while retaining exact `DEFB` encoding;
- `src/floppy/prometheus-d80-*-payload.asm` — semantic resident-body variants;
- `src/floppy/driver-*.byteexact.asm` — instruction-by-instruction driver sources;
- `src/floppy/installer-*.byteexact.asm` — bootstrap/runtime/string/relocation-table
  decompilation with physical and runtime addresses;
- `historical-source-tape/` — decoded files from the supplied D80 source tape.

The older recursive listings remain in `src/listings/` as analytical working
material, but the annotated byte-exact files are now the authoritative readable
representation of the extracted installer and driver segments.

Run:

```sh
./verify.sh
```

The script first proves that all four annotated `DEFB` sources still encode the
exact extracted segments, then reconstructs `promdiskam` and `promdiska` and checks
their historical SHA-256 identities.
