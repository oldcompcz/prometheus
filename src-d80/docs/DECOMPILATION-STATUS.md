# Decompilation status

This bundle separates byte identity, instruction decoding, semantic confidence,
and unresolved external ROM details.

- **PROMETHEUS body:** semantic v042 source with the exact floppy source-level
  modifications applied in the two payload files.
- **Disk drivers:** complete byte-exact comment decompilation. All executable
  regions are decoded one instruction per `DEFB` row, with reconstructed routine
  labels and higher-level comments. Messages, padding, and the 28-byte M-DOS
  descriptor are explicitly typed as data instead of being presented as code.
- **Installers:** complete structural comment decompilation. The physical bootstrap,
  relocated runtime code, inline strings, self-modifying operands, overlap-safe
  mover, and typed relocation decoder are identified. Every relocation table word
  is classified and annotated individually.
- **Historical source tape:** decoded PROMETHEUS source records from
  `source-d80.tap`. These are D40/D80 programming examples and supporting evidence;
  they are not the compact resident driver source.

The remaining principal uncertainty is external to these binaries: the exact
field names and service semantics of the 28-byte M-DOS descriptor require the
matching D40/D80 ROM/API source or documentation. The byte boundaries and the
code that prepares and consumes the block are exact.

`./verify.sh` checks both the four byte-exact source streams and the two complete
historical distribution images.
