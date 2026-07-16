; PROMETHEUS D40/D80 assembler-only driver (606 bytes)
;
; BYTE-EXACT, COMMENT-DECOMPILED SOURCE
;
; All historical bytes remain DEFB. Code rows contain the exact equivalent Z80
; mnemonic in comments; data rows are explicitly typed. This file can therefore
; be audited instruction by instruction without sacrificing byte identity.
;
    org 07918h

; -----------------------------------------------------------------------------
; Install disk hooks; public entry at driver base.
diskDriverEntry:
; Public disk-mode entry; jumps over the cassette-restoration patcher.
    defb 0c3h, 03fh, 079h                ; $7918: jp $793f

; -----------------------------------------------------------------------------
; Restore historical cassette instructions; public entry at base+3.
cassetteCompatibilityEntry:
; Begin restoring the original three cassette call sites byte by byte.
    defb 021h, 099h, 080h                ; $791B: ld hl,$8099
    defb 036h, 03eh                      ; $791E: ld (hl),$3e
    defb 023h                            ; $7920: inc hl
    defb 036h, 00ch                      ; $7921: ld (hl),$0c
    defb 023h                            ; $7923: inc hl
    defb 036h, 0ddh                      ; $7924: ld (hl),$dd
    defb 021h, 0ffh, 081h                ; $7926: ld hl,$81ff
    defb 036h, 0cdh                      ; $7929: ld (hl),$cd
    defb 023h                            ; $792B: inc hl
    defb 036h, 00ah                      ; $792C: ld (hl),$0a
    defb 023h                            ; $792E: inc hl
    defb 036h, 086h                      ; $792F: ld (hl),$86
    defb 021h, 02bh, 082h                ; $7931: ld hl,$822b
    defb 036h, 0cdh                      ; $7934: ld (hl),$cd
    defb 023h                            ; $7936: inc hl
    defb 036h, 038h                      ; $7937: ld (hl),$38
    defb 023h                            ; $7939: inc hl
    defb 036h, 081h                      ; $793A: ld (hl),$81
; Resume the monitor-less assembler entry after cassette hooks are restored.
    defb 0c3h, 076h, 07bh                ; $793C: jp $7b76

; -----------------------------------------------------------------------------
; Patch three assembler tape sites to JP into this driver.
installDiskHooksAndStartAssembler:
; Begin replacing the three tape sites with absolute JP instructions into this driver.
    defb 021h, 099h, 080h                ; $793F: ld hl,$8099
    defb 036h, 0c3h                      ; $7942: ld (hl),$c3
    defb 023h                            ; $7944: inc hl
    defb 036h, 063h                      ; $7945: ld (hl),$63
    defb 023h                            ; $7947: inc hl
    defb 036h, 079h                      ; $7948: ld (hl),$79
    defb 021h, 0ffh, 081h                ; $794A: ld hl,$81ff
    defb 036h, 0c3h                      ; $794D: ld (hl),$c3
    defb 023h                            ; $794F: inc hl
    defb 036h, 0d4h                      ; $7950: ld (hl),$d4
    defb 023h                            ; $7952: inc hl
    defb 036h, 079h                      ; $7953: ld (hl),$79
    defb 021h, 02bh, 082h                ; $7955: ld hl,$822b
    defb 036h, 0c3h                      ; $7958: ld (hl),$c3
    defb 023h                            ; $795A: inc hl
    defb 036h, 095h                      ; $795B: ld (hl),$95
    defb 023h                            ; $795D: inc hl
    defb 036h, 07ah                      ; $795E: ld (hl),$7a
; Resume the monitor-less assembler entry after disk hooks are installed.
    defb 0c3h, 076h, 07bh                ; $7960: jp $7b76

; -----------------------------------------------------------------------------
; Disk replacement for assembler/source SAVE.
assemblerDiskSave:
; Assembler/source SAVE hook; computes and stores the source checksum before disk output.
    defb 0cdh, 0aeh, 079h                ; $7963: call $79ae
    defb 0c1h                            ; $7966: pop bc
    defb 0e1h                            ; $7967: pop hl
    defb 0e5h                            ; $7968: push hl
    defb 0c5h                            ; $7969: push bc
    defb 016h, 0ffh                      ; $796A: ld d,$ff
    defb 07ah                            ; $796C: ld a,d
    defb 0aeh                            ; $796D: xor (hl)
    defb 057h                            ; $796E: ld d,a
    defb 023h                            ; $796F: inc hl
    defb 00bh                            ; $7970: dec bc
    defb 078h                            ; $7971: ld a,b
    defb 0b1h                            ; $7972: or c
    defb 020h, 0f7h                      ; $7973: jr nz,$796c
    defb 0ddh, 062h                      ; $7975: ld ixh,d
    defb 0c1h                            ; $7977: pop bc
    defb 0e1h                            ; $7978: pop hl
    defb 009h                            ; $7979: add hl,bc
    defb 02bh                            ; $797A: dec hl
    defb 0edh, 05bh, 0afh, 080h          ; $797B: ld de,($80af)
    defb 01bh                            ; $797F: dec de
    defb 03eh, 0ffh                      ; $7980: ld a,$ff
    defb 012h                            ; $7982: ld (de),a
    defb 01bh                            ; $7983: dec de
    defb 0ddh, 07ch                      ; $7984: ld a,ixh
    defb 012h                            ; $7986: ld (de),a
    defb 01bh                            ; $7987: dec de
    defb 0c5h                            ; $7988: push bc
    defb 01ah                            ; $7989: ld a,(de)
    defb 0edh, 0a8h                      ; $798A: ldd
    defb 023h                            ; $798C: inc hl
    defb 077h                            ; $798D: ld (hl),a
    defb 02bh                            ; $798E: dec hl
    defb 0eah, 089h, 079h                ; $798F: jp pe,$7989
    defb 023h                            ; $7992: inc hl
    defb 013h                            ; $7993: inc de
    defb 0e5h                            ; $7994: push hl
    defb 0d5h                            ; $7995: push de
    defb 0cdh, 037h, 07ah                ; $7996: call $7a37
    defb 0d1h                            ; $7999: pop de
    defb 0e1h                            ; $799A: pop hl
    defb 0c1h                            ; $799B: pop bc
    defb 01ah                            ; $799C: ld a,(de)
    defb 0edh, 0a0h                      ; $799D: ldi
    defb 02bh                            ; $799F: dec hl
    defb 077h                            ; $79A0: ld (hl),a
    defb 023h                            ; $79A1: inc hl
    defb 0eah, 09ch, 079h                ; $79A2: jp pe,$799c
    defb 0afh                            ; $79A5: xor a
    defb 012h                            ; $79A6: ld (de),a
    defb 013h                            ; $79A7: inc de
    defb 03eh, 030h                      ; $79A8: ld a,$30
    defb 012h                            ; $79AA: ld (de),a
    defb 0c3h, 0eah, 085h                ; $79AB: jp $85ea

; -----------------------------------------------------------------------------
; Copy editor filename workspace and replace trailing spaces with zeroes.
copyAndNormalizeFilename:
; Filename helper uses EXX so the caller register set remains available.
    defb 0d9h                            ; $79AE: exx
    defb 021h, 0e0h, 050h                ; $79AF: ld hl,$50e0
    defb 011h, 0ffh, 094h                ; $79B2: ld de,$94ff
    defb 001h, 011h, 000h                ; $79B5: ld bc,$0011
    defb 0edh, 0b0h                      ; $79B8: ldir
    defb 021h, 009h, 095h                ; $79BA: ld hl,$9509
    defb 006h, 009h                      ; $79BD: ld b,$09
    defb 07eh                            ; $79BF: ld a,(hl)
    defb 0feh, 020h                      ; $79C0: cp $20
    defb 020h, 005h                      ; $79C2: jr nz,$79c9
    defb 036h, 000h                      ; $79C4: ld (hl),$00
    defb 02bh                            ; $79C6: dec hl
    defb 010h, 0f6h                      ; $79C7: djnz $79bf
    defb 0d9h                            ; $79C9: exx
    defb 0c9h                            ; $79CA: ret

; -----------------------------------------------------------------------------
; LOAD ! special case: invoke catalogue.
catalogueFromLoadBang:
; LOAD ! branches here to request a disk catalogue.
    defb 011h, 00fh, 07bh                ; $79CB: ld de,$7b0f
    defb 0cdh, 0cah, 07ah                ; $79CE: call $7aca
    defb 0c3h, 076h, 07bh                ; $79D1: jp $7b76

; -----------------------------------------------------------------------------
; Disk replacement for assembler/source LOAD.
assemblerDiskLoad:
; Assembler/source LOAD hook.
    defb 03ah, 003h, 081h                ; $79D4: ld a,($8103)
    defb 0feh, 021h                      ; $79D7: cp $21
    defb 028h, 0f0h                      ; $79D9: jr z,$79cb
    defb 001h, 060h, 07ah                ; $79DB: ld bc,$7a60
    defb 0cdh, 01fh, 07ah                ; $79DE: call $7a1f
    defb 021h, 002h, 081h                ; $79E1: ld hl,$8102
    defb 0cdh, 0b2h, 079h                ; $79E4: call $79b2
    defb 0cdh, 02dh, 07ah                ; $79E7: call $7a2d
    defb 0f5h                            ; $79EA: push af
    defb 022h, 072h, 03eh                ; $79EB: ld ($3e72),hl
    defb 011h, 0e0h, 050h                ; $79EE: ld de,$50e0
    defb 001h, 011h, 000h                ; $79F1: ld bc,$0011
    defb 0edh, 0b0h                      ; $79F4: ldir
    defb 0cdh, 0a8h, 07ah                ; $79F6: call $7aa8
    defb 0f1h                            ; $79F9: pop af
    defb 0cah, 007h, 082h                ; $79FA: jp z,$8207
    defb 021h, 050h, 07bh                ; $79FD: ld hl,$7b50
    defb 018h, 061h                      ; $7A00: jr $7a63

; -----------------------------------------------------------------------------
; Prepare PROMETHEUS file metadata around a disk operation.
prepareLoadedFileMetadata:
    defb 021h, 0aah, 03eh                ; $7A02: ld hl,$3eaa
    defb 011h, 080h, 03eh                ; $7A05: ld de,$3e80
    defb 001h, 00ah, 000h                ; $7A08: ld bc,$000a
    defb 0edh, 0b0h                      ; $7A0B: ldir
    defb 021h, 000h, 095h                ; $7A0D: ld hl,$9500
    defb 00eh, 00ah                      ; $7A10: ld c,$0a
    defb 0edh, 0b0h                      ; $7A12: ldir
    defb 03eh, 042h                      ; $7A14: ld a,$42
    defb 012h                            ; $7A16: ld (de),a
    defb 03ah, 06bh, 03eh                ; $7A17: ld a,($3e6b)
    defb 03ch                            ; $7A1A: inc a
    defb 032h, 071h, 03eh                ; $7A1B: ld ($3e71),a
    defb 0c9h                            ; $7A1E: ret

; -----------------------------------------------------------------------------
; Temporarily replace the BASIC error return address.
installTemporaryErrorReturn:
; Temporarily replaces the BASIC error return word and remembers the old value.
    defb 02ah, 03dh, 05ch                ; $7A1F: ld hl,($5c3d)
    defb 05eh                            ; $7A22: ld e,(hl)
    defb 023h                            ; $7A23: inc hl
    defb 056h                            ; $7A24: ld d,(hl)
    defb 0edh, 053h, 0b9h, 07ah          ; $7A25: ld ($7ab9),de
    defb 070h                            ; $7A29: ld (hl),b
    defb 02bh                            ; $7A2A: dec hl
    defb 071h                            ; $7A2B: ld (hl),c
    defb 0c9h                            ; $7A2C: ret

; -----------------------------------------------------------------------------
; Enter the D40/D80 ROM operation wrapper.
invokeDiskRomOperation:
; Transfers into the M-DOS wrapper; RST 0 is executed in the prepared DOS context.
    defb 0cdh, 0c7h, 07ah                ; $7A2D: call $7ac7
    defb 0c7h                            ; $7A30: rst $00
    defb 0cdh, 002h, 07ah                ; $7A31: call $7a02
    defb 0c3h, 02bh, 021h                ; $7A34: jp $212b

; -----------------------------------------------------------------------------
; Save path including existing-file/overwrite handling.
saveWithOverwriteHandling:
; Save dispatcher with overwrite/error handling.
    defb 0edh, 073h, 053h, 07ah          ; $7A37: ld ($7a53),sp
    defb 0d5h                            ; $7A3B: push de
    defb 001h, 052h, 07ah                ; $7A3C: ld bc,$7a52
    defb 0cdh, 01fh, 07ah                ; $7A3F: call $7a1f
    defb 0cdh, 02dh, 07ah                ; $7A42: call $7a2d
    defb 020h, 039h                      ; $7A45: jr nz,$7a80
    defb 021h, 05ah, 07bh                ; $7A47: ld hl,$7b5a
    defb 0efh                            ; $7A4A: rst $28
    defb 02dh                            ; $7A4B: dec l
    defb 07bh                            ; $7A4C: ld a,e
    defb 028h, 031h                      ; $7A4D: jr z,$7a80
    defb 0e1h                            ; $7A4F: pop hl
    defb 018h, 056h                      ; $7A50: jr $7aa8

; -----------------------------------------------------------------------------
; Self-modifying disk-failure recovery trampoline.
diskFailureRecoveryTrampoline:
; Self-modifying recovery trampoline; the LD SP immediate is filled at runtime.
    defb 031h, 000h, 000h                ; $7A52: ld sp,$0000
    defb 021h, 064h, 07bh                ; $7A55: ld hl,$7b64
    defb 0cdh, 019h, 07bh                ; $7A58: call $7b19
    defb 0cdh, 036h, 090h                ; $7A5B: call $9036
    defb 018h, 048h                      ; $7A5E: jr $7aa8

; -----------------------------------------------------------------------------
; Restore PROMETHEUS stack/state after a disk failure.
recoverAfterDiskFailure:
    defb 021h, 064h, 07bh                ; $7A60: ld hl,$7b64
    defb 0edh, 07bh, 01dh, 087h          ; $7A63: ld sp,($871d)
    defb 0cdh, 019h, 07bh                ; $7A67: call $7b19
    defb 0cdh, 0abh, 07ah                ; $7A6A: call $7aab
    defb 0c3h, 01ch, 087h                ; $7A6D: jp $871c

; -----------------------------------------------------------------------------
; Clear the status/display area used by disk messages.
clearDiskStatusLine:
; Clear the disk status line before returning to the PROMETHEUS UI.
    defb 021h, 0c0h, 050h                ; $7A70: ld hl,$50c0
    defb 022h, 0b6h, 091h                ; $7A73: ld ($91b6),hl
    defb 006h, 020h                      ; $7A76: ld b,$20
    defb 03eh, 07eh                      ; $7A78: ld a,$7e
    defb 0cdh, 095h, 091h                ; $7A7A: call $9195
    defb 010h, 0f9h                      ; $7A7D: djnz $7a78
    defb 0c9h                            ; $7A7F: ret

; -----------------------------------------------------------------------------
; Finish installing a source file after successful disk load.
finishLoadedSource:
    defb 0ddh, 021h, 0ffh, 094h          ; $7A80: ld ix,$94ff
    defb 0cdh, 0e1h, 019h                ; $7A84: call $19e1
    defb 0e1h                            ; $7A87: pop hl
    defb 022h, 074h, 03eh                ; $7A88: ld ($3e74),hl
    defb 03eh, 001h                      ; $7A8B: ld a,$01
    defb 032h, 062h, 03eh                ; $7A8D: ld ($3e62),a
    defb 0cdh, 000h, 01ah                ; $7A90: call $1a00
    defb 018h, 013h                      ; $7A93: jr $7aa8

; -----------------------------------------------------------------------------
; Catalogue entry used by LOAD !.
assemblerDiskCatalogue:
; Catalogue entry used by LOAD !.
    defb 0ddh, 0e5h                      ; $7A95: push ix
    defb 0d5h                            ; $7A97: push de
    defb 0cdh, 0c7h, 07ah                ; $7A98: call $7ac7
    defb 0c7h                            ; $7A9B: rst $00
    defb 001h, 060h, 07ah                ; $7A9C: ld bc,$7a60
    defb 0cdh, 01fh, 07ah                ; $7A9F: call $7a1f
    defb 0d1h                            ; $7AA2: pop de
    defb 0ddh, 0e1h                      ; $7AA3: pop ix
    defb 0cdh, 0aeh, 019h                ; $7AA5: call $19ae

; -----------------------------------------------------------------------------
; Restore editor state after an M-DOS call.
restorePrometheusAfterDiskCall:
    defb 0cdh, 0e1h, 002h                ; $7AA8: call $02e1
    defb 0cdh, 070h, 07ah                ; $7AAB: call $7a70
    defb 021h, 0e0h, 05ah                ; $7AAE: ld hl,$5ae0
    defb 0edh, 04bh, 00fh, 088h          ; $7AB1: ld bc,($880f)
    defb 0cdh, 00fh, 08dh                ; $7AB5: call $8d0f

; -----------------------------------------------------------------------------
; Restore ERR_SP, IY and interrupt-disabled convention.
restoreErrorReturnAndInterruptState:
; Restore ERR_SP and the interrupt-disabled PROMETHEUS convention.
    defb 011h, 000h, 000h                ; $7AB8: ld de,$0000
    defb 02ah, 03dh, 05ch                ; $7ABB: ld hl,($5c3d)
    defb 073h                            ; $7ABE: ld (hl),e
    defb 023h                            ; $7ABF: inc hl
    defb 072h                            ; $7AC0: ld (hl),d
    defb 0fdh, 036h, 000h, 0ffh          ; $7AC1: ld (iy+$00),$ff
    defb 0f3h                            ; $7AC5: di
    defb 0c9h                            ; $7AC6: ret

; -----------------------------------------------------------------------------
; Build an M-DOS-compatible stack/error context and jump to ROM.
enterMdosContext:
; Construct a temporary M-DOS stack/error context.
    defb 011h, 0fch, 07ah                ; $7AC7: ld de,$7afc
    defb 02ah, 05dh, 05ch                ; $7ACA: ld hl,($5c5d)
    defb 0fdh, 021h, 03ah, 05ch          ; $7ACD: ld iy,$5c3a
    defb 0e5h                            ; $7AD1: push hl
    defb 0edh, 073h, 0f5h, 07ah          ; $7AD2: ld ($7af5),sp
    defb 0edh, 07bh, 03dh, 05ch          ; $7AD6: ld sp,($5c3d)
    defb 021h, 0eah, 07ah                ; $7ADA: ld hl,$7aea
    defb 0e3h                            ; $7ADD: ex (sp),hl
    defb 022h, 0edh, 07ah                ; $7ADE: ld ($7aed),hl
    defb 0edh, 056h                      ; $7AE1: im 1
    defb 0fbh                            ; $7AE3: ei
    defb 03eh, 001h                      ; $7AE4: ld a,$01
    defb 0ebh                            ; $7AE6: ex de,hl
    defb 0c3h, 0d5h, 01bh                ; $7AE7: jp $1bd5

; -----------------------------------------------------------------------------
; Return trampoline entered by the M-DOS error/return context.
mdosReturnTrampoline:
; M-DOS return trampoline; two immediate words are patched with saved stack state.
    defb 03bh                            ; $7AEA: dec sp
    defb 03bh                            ; $7AEB: dec sp
    defb 021h, 000h, 000h                ; $7AEC: ld hl,$0000
    defb 0e3h                            ; $7AEF: ex (sp),hl
    defb 021h, 076h, 01bh                ; $7AF0: ld hl,$1b76
    defb 0e5h                            ; $7AF3: push hl
    defb 031h, 000h, 000h                ; $7AF4: ld sp,$0000
    defb 0e1h                            ; $7AF7: pop hl
    defb 022h, 05dh, 05ch                ; $7AF8: ld ($5c5d),hl
    defb 018h, 0c4h                      ; $7AFB: jr $7ac1

; -----------------------------------------------------------------------------
; Exact 28-byte M-DOS operation descriptor/workspace (field ABI not yet named); data, not linear Z80 code.
mdosOperationDescriptor:
; Passed as an M-DOS operation descriptor/workspace. The driver patches
; nearby return/error slots before entering ROM. Exact bytes are shown in
; structured data rows because a linear opcode interpretation is false.
    defb 0f4h, 023h, 032h, 00eh, 000h, 000h, 0f7h        ; $7AFD: descriptor +$00..+$06
    defb 000h, 000h, 02ch, 037h, 00eh, 000h, 000h        ; $7B04: descriptor +$07..+$0D
    defb 04fh, 000h, 000h, 03ah, 03fh, 0fbh, 03ah        ; $7B0B: descriptor +$0E..+$14
    defb 0cfh, 03ah, 0f2h, 0c3h, 0a7h, 03ah, 03fh        ; $7B12: descriptor +$15..+$1B

; -----------------------------------------------------------------------------
; Display a high-bit-terminated driver message.
displayDiskMessage:
; Display one high-bit-terminated disk message.
    defb 0e5h                            ; $7B19: push hl
    defb 0cdh, 041h, 091h                ; $7B1A: call $9141
    defb 021h, 000h, 040h                ; $7B1D: ld hl,$4000
    defb 022h, 0b6h, 091h                ; $7B20: ld ($91b6),hl
    defb 0e1h                            ; $7B23: pop hl
    defb 0cdh, 005h, 08bh                ; $7B24: call $8b05
    defb 021h, 06eh, 07bh                ; $7B27: ld hl,$7b6e
    defb 0c3h, 005h, 08bh                ; $7B2A: jp $8b05

; -----------------------------------------------------------------------------
; Ask whether an existing file should be preserved, replaced, or retried.
askOverwritePolicy:
; Prompt for P/R/Y after an existing-file condition.
    defb 0cdh, 019h, 07bh                ; $7B2D: call $7b19
    defb 0cdh, 036h, 090h                ; $7B30: call $9036
    defb 0f5h                            ; $7B33: push af
    defb 021h, 000h, 040h                ; $7B34: ld hl,$4000
    defb 022h, 0b6h, 091h                ; $7B37: ld ($91b6),hl
    defb 021h, 06eh, 07bh                ; $7B3A: ld hl,$7b6e
    defb 0cdh, 019h, 07bh                ; $7B3D: call $7b19
    defb 021h, 06eh, 07bh                ; $7B40: ld hl,$7b6e
    defb 0cdh, 024h, 07bh                ; $7B43: call $7b24
    defb 0f1h                            ; $7B46: pop af
    defb 0feh, 070h                      ; $7B47: cp $70
    defb 0c8h                            ; $7B49: ret z
    defb 0feh, 072h                      ; $7B4A: cp $72
    defb 0c8h                            ; $7B4C: ret z
    defb 0feh, 079h                      ; $7B4D: cp $79
    defb 0c9h                            ; $7B4F: ret

; -----------------------------------------------------------------------------
; "Not found".
messageNotFound:
; File lookup failure message.
    defb 04eh, 06fh, 074h, 020h, 066h, 06fh, 075h, 06eh, 064h, 0a0h ; $7B50: "Not found " (high-bit terminator)

; -----------------------------------------------------------------------------
; "Overwrite".
messageOverwrite:
; Existing-file prompt.
    defb 04fh, 076h, 065h, 072h, 077h, 072h, 069h, 074h, 065h, 0bfh ; $7B5A: "Overwrite?" (high-bit terminator)

; -----------------------------------------------------------------------------
; "Disk error".
messageDiskError:
; Generic disk error message.
    defb 044h, 069h, 073h, 06bh, 020h, 065h, 072h, 072h, 06fh, 0f2h ; $7B64: "Disk error" (high-bit terminator)

; -----------------------------------------------------------------------------
; Blank high-bit-terminated padding.
messageBlankPadding:
; Status-line erasure string.
    defb 020h, 020h, 020h, 020h, 020h, 020h, 020h, 0a0h          ; $7B6E: blank padding (high-bit terminator)
