# Testing

## Standard suite

```sh
make test
```

The core executable generates all TAP and TR-DOS fixtures before exercising the public API. The shell suite then tests the built command-line program against those fixtures.

Current coverage includes:

- all 686 PROMETHEUS instruction-table records;
- 117 additional IY transformations;
- combined TAP payloads and separate TR-DOS source/symbol files;
- strict and salvage validation;
- source and symbol duplicate occurrence selection;
- TR-DOS type-qualified and bare selectors;
- automatic unique symbol pairing and ambiguity rejection;
- source/symbol private-wrapper ranges;
- malformed TAP checksums and malformed TR-DOS allocations;
- legacy PROMETHEUS and compact layouts;
- the two-TAB/one-TAB preset;
- fixed space and TAB separators with independent counts, including zero;
- PROMETHEUS and DB/DW pseudo-operation presets;
- individual mappings for all eight PROMETHEUS pseudo-operations;
- every hexadecimal and binary output syntax;
- preserved, lowercase, and uppercase numeric letters;
- all source/generated comment combinations and convenience aliases;
- quoted-string protection during literal conversion;
- strict public-API rejection of invalid formatter enums, flags, counts, and directive names;
- every documented command-line option and invalid value.

Expected result:

```text
all 3273 checks passed (686 instruction records + 117 IY variants)
all TAP, TR-DOS, and formatter CLI option checks passed
```

## Sanitizers

```sh
make sanitize
```

This rebuilds and reruns the complete suite with AddressSanitizer and UndefinedBehaviorSanitizer.

## CMake

```sh
cmake -S . -B build-cmake
cmake --build build-cmake
ctest --test-dir build-cmake --output-on-failure
```

## Historical TAP regression

```sh
build/prometheus-tap2asm --validate-only prometheus-48.tap skatecrazy
```

The supplied historical image validates 1,331 source records. Release verification also exports it with the TAB layout, DB/DW directive preset, numeric syntax conversion, and source-only comment mode.

## Real BetaDisk compatibility

The test suite constructs byte-exact raw TR-DOS images from the documented filesystem layout. A real split-file archival image has not yet been supplied. When one becomes available, add it as an optional non-redistributed integration fixture or capture its structural characteristics in a minimal generated regression fixture.
