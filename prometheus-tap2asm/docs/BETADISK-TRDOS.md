# BetaDisk / TR-DOS support

## Implemented image format

The converter reads raw `.trd` files. A `.trd` file is a headerless concatenation of TR-DOS logical sectors:

```text
256 bytes per sector
16 sectors per logical track
logical tracks in TR-DOS order
```

The first eight sectors contain up to 128 16-byte file descriptors. Sector 9 contains disk information. File data begins after the system track and is contiguous rather than cluster-chained.

## Directory descriptor

```text
+0..7   filename, padded with spaces
+8      one-byte file type
+9..10  CODE load address / type-specific parameter
+11..12 exact file length for non-BASIC files
+13     allocated sectors
+14     starting sector, zero based
+15     starting logical track
```

The file-data offset in a raw `.trd` image is:

```text
(logicalTrack * 16 + sector) * 256
```

Strict mode checks:

- image and directory availability;
- sector and logical-track ranges;
- exact byte length fitting in the allocated sector count;
- selected file data fitting in the image;
- the complete PROMETHEUS source and symbol structures.

## Separate PROMETHEUS files

The default split interpretation is intentionally simple:

```text
SOURCE file = compressed source records only
SYMBOL file = complete symbol table beginning at its two-byte symbol count
```

The two structures are decoded by the same routines used for the combined TAP payload. Symbol references in source records remain ordinal references, so selecting the matching symbol file is essential.

When the symbol file is not named explicitly, the tool performs strict full-source validation against every other active file. It accepts only one unique pairing.

The following options support adaptation-specific wrappers:

```text
--source-offset N
--source-length N
--symbols-offset N
```

## References

- Technology Research Limited, *Beta Disk Interface — TR-DOS v4 User Manual Supplement*, 1984:
  `https://worldofspectrum.net/pub/sinclair/hardware-info/b/BetaDiskInterface_ManualV4.pdf`
- Sinclair Wiki, *TR-DOS filesystem*:
  `https://sinclair.wiki.zxnet.co.uk/wiki/TR-DOS_filesystem`
- Sinclair Wiki, *TRD format*:
  `https://sinclair.wiki.zxnet.co.uk/wiki/TRD_format`
- PROMETHEUS English documentation, including internal source and symbol-table formats:
  `https://ci5.speccy.cz/files/prometheus_en.pdf`
