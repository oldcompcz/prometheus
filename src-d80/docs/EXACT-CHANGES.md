# Exact changes from PROMETHEUS v042 tape build to D40/D80 builds

## Result

The floppy editions are not independent rewrites. They preserve the v042 origin-zero resident payload and apply a different installer, a resident disk driver at `$7918`, ordinary relocation, and a small set of explicit patches.

| Image | Length | Installer | Driver | Retained PROMETHEUS body | Effective body origin |
|---|---:|---:|---:|---:|---:|
| `promdiskam` | 20,124 | 3,324 | 800 | 16,000 (monitor + assembler) | `$7C38` |
| `promdiska` | 13,700 | 2,100 | 606 | 10,994 (payload offsets `$1388..$3E79`) | `$67EE`; retained bytes begin at `$7B76` |

The full image performs 1,293 normal relocation-word updates except that the resident-boundary word at payload offset `$1B72` is deliberately redirected to driver base `$7918`. After relocation normalization, only 17 retained payload bytes differ.

The assembler-only image uses all 722 assembler relocation sites: 720 ordinary `+$67EE` relocations and two deliberate overrides (`$1B72` and `$1E13`). After normalization, 18 retained payload bytes differ. The last six zero bytes of the 16,000-byte logical payload are not stored.

## Source-level changes

1. **Resident lower bound includes the driver.** `emitByteAtAssemblyOutput` compares generated output against `$7918`, not the PROMETHEUS payload entry, preventing assembled code from overwriting the driver.
2. **Assembler-only MONITOR fallback.** The `JP startMonitor` operand is changed to `$7B76`, the assembler entry, because the 5,000-byte monitor prefix is absent.
3. **Disk hook patching.** The driver overwrites three assembler tape-operation sites with `JP` instructions. The full driver additionally patches two monitor byte-operation sites. Entry `driver+3` restores the exact original instructions.
4. **UI tuning.** Full monitor access-line attribute `$28` becomes `$30`; keypress beep duration `$1E` becomes `$0A`; beep/border seed `$17` becomes `$07`.
5. **Previously hard-coded absolute words are rebased.** The initial token table pointer and five preserved internal-stack words are recalculated from the variant payload origin.
6. **Installer replacement.** The original 2,356-byte tape installer is replaced by a 3,324-byte full or 2,100-byte assembler-only floppy installer. Both start with the same 23-byte self-locating bootstrap and copy their temporary installer to `$4017`.

Every relocation word is listed in `docs/generated/*-relocation-words.csv`; every non-relocation patch is listed in `docs/generated/non-relocation-patches.csv`.

## Driver hooks

### Full driver

| Patched resident address | Original body offset | Installed target | Meaning |
|---:|---:|---:|---|
| `$8049` | `$0411` | `$79C4` | monitor byte save |
| `$8071` | `$0439` | `$798F` | monitor byte load |
| `$94E3` | `$18AB` | `$7A11` | assembler/source save |
| `$9649` | `$1A11` | `$7A82` | assembler/source load |
| `$9675` | `$1A3D` | `$7B50` | `LOAD !` catalogue |

### Assembler-only driver

| Patched resident address | Logical body offset | Installed target | Meaning |
|---:|---:|---:|---|
| `$8099` | `$18AB` | `$7963` | assembler/source save |
| `$81FF` | `$1A11` | `$79D4` | assembler/source load |
| `$822B` | `$1A3D` | `$7A95` | `LOAD !` catalogue |

## Verification hashes

- `promdiskam`: `e0617fadc3ac124ed0963741e32c51a2c4caaab0f6949d0e25f1f5cfb2d24e90`
- `promdiska`: `2fcad91c25e95afaa8b6c2d0c40b4d6536ffc534dc42120f180e9bbf16af6cdc`

Run `./verify.sh` to reconstruct both files from the v042 baseline, relocation map, exact installer/driver segments, and explicit patches.
