; PROMETHEUS D40/D80 full driver (800 bytes)
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
    defb 0c3h, 055h, 079h                ; $7918: jp $7955

; -----------------------------------------------------------------------------
; Restore historical cassette instructions; public entry at base+3.
cassetteCompatibilityEntry:
; Begin restoring the original five cassette call sites byte by byte.
    defb 021h, 0e3h, 094h                ; $791B: ld hl,$94e3
    defb 036h, 03eh                      ; $791E: ld (hl),$3e
    defb 023h                            ; $7920: inc hl
    defb 036h, 00ch                      ; $7921: ld (hl),$0c
    defb 023h                            ; $7923: inc hl
    defb 036h, 0ddh                      ; $7924: ld (hl),$dd
    defb 021h, 049h, 096h                ; $7926: ld hl,$9649
    defb 036h, 0cdh                      ; $7929: ld (hl),$cd
    defb 023h                            ; $792B: inc hl
    defb 036h, 054h                      ; $792C: ld (hl),$54
    defb 023h                            ; $792E: inc hl
    defb 036h, 09ah                      ; $792F: ld (hl),$9a
    defb 021h, 075h, 096h                ; $7931: ld hl,$9675
    defb 036h, 0cdh                      ; $7934: ld (hl),$cd
    defb 023h                            ; $7936: inc hl
    defb 036h, 082h                      ; $7937: ld (hl),$82
    defb 023h                            ; $7939: inc hl
    defb 036h, 095h                      ; $793A: ld (hl),$95
    defb 021h, 049h, 080h                ; $793C: ld hl,$8049
    defb 036h, 0cdh                      ; $793F: ld (hl),$cd
    defb 023h                            ; $7941: inc hl
    defb 036h, 012h                      ; $7942: ld (hl),$12
    defb 023h                            ; $7944: inc hl
    defb 036h, 095h                      ; $7945: ld (hl),$95
    defb 021h, 071h, 080h                ; $7947: ld hl,$8071
    defb 036h, 0cdh                      ; $794A: ld (hl),$cd
    defb 023h                            ; $794C: inc hl
    defb 036h, 054h                      ; $794D: ld (hl),$54
    defb 023h                            ; $794F: inc hl
    defb 036h, 080h                      ; $7950: ld (hl),$80
; Resume the full PROMETHEUS entry after cassette hooks are restored.
    defb 0c3h, 0c0h, 08fh                ; $7952: jp $8fc0

; -----------------------------------------------------------------------------
; Patch five full-build tape sites to JP into this driver.
installDiskHooksAndStartAssembler:
; Begin replacing the five tape sites with absolute JP instructions into this driver.
    defb 021h, 0e3h, 094h                ; $7955: ld hl,$94e3
    defb 036h, 0c3h                      ; $7958: ld (hl),$c3
    defb 023h                            ; $795A: inc hl
    defb 036h, 011h                      ; $795B: ld (hl),$11
    defb 023h                            ; $795D: inc hl
    defb 036h, 07ah                      ; $795E: ld (hl),$7a
    defb 021h, 049h, 096h                ; $7960: ld hl,$9649
    defb 036h, 0c3h                      ; $7963: ld (hl),$c3
    defb 023h                            ; $7965: inc hl
    defb 036h, 082h                      ; $7966: ld (hl),$82
    defb 023h                            ; $7968: inc hl
    defb 036h, 07ah                      ; $7969: ld (hl),$7a
    defb 021h, 075h, 096h                ; $796B: ld hl,$9675
    defb 036h, 0c3h                      ; $796E: ld (hl),$c3
    defb 023h                            ; $7970: inc hl
    defb 036h, 050h                      ; $7971: ld (hl),$50
    defb 023h                            ; $7973: inc hl
    defb 036h, 07bh                      ; $7974: ld (hl),$7b
    defb 021h, 049h, 080h                ; $7976: ld hl,$8049
    defb 036h, 0c3h                      ; $7979: ld (hl),$c3
    defb 023h                            ; $797B: inc hl
    defb 036h, 0c4h                      ; $797C: ld (hl),$c4
    defb 023h                            ; $797E: inc hl
    defb 036h, 079h                      ; $797F: ld (hl),$79
    defb 021h, 071h, 080h                ; $7981: ld hl,$8071
    defb 036h, 0c3h                      ; $7984: ld (hl),$c3
    defb 023h                            ; $7986: inc hl
    defb 036h, 08fh                      ; $7987: ld (hl),$8f
    defb 023h                            ; $7989: inc hl
    defb 036h, 079h                      ; $798A: ld (hl),$79
; Resume the full PROMETHEUS entry after disk hooks are installed.
    defb 0c3h, 0c0h, 08fh                ; $798C: jp $8fc0

; -----------------------------------------------------------------------------
; Disk replacement for the monitor byte-load hook.
monitorDiskLoad:
; Monitor LOAD hook; preserves the non-disk path when the command is not the disk form.
    defb 0eeh, 03ah                      ; $798F: xor $3a
    defb 028h, 006h                      ; $7991: jr z,$7999
    defb 0cdh, 054h, 080h                ; $7993: call $8054
    defb 0c3h, 074h, 080h                ; $7996: jp $8074
    defb 011h, 04ah, 0a9h                ; $7999: ld de,$a94a
    defb 023h                            ; $799C: inc hl
    defb 0cdh, 037h, 095h                ; $799D: call $9537
    defb 021h, 049h, 0a9h                ; $79A0: ld hl,$a949
    defb 0cdh, 060h, 07ah                ; $79A3: call $7a60
    defb 001h, 01eh, 07bh                ; $79A6: ld bc,$7b1e
    defb 0cdh, 0cdh, 07ah                ; $79A9: call $7acd
    defb 0cdh, 0dbh, 07ah                ; $79AC: call $7adb
    defb 022h, 072h, 03eh                ; $79AF: ld ($3e72),hl
    defb 0c2h, 01eh, 07bh                ; $79B2: jp nz,$7b1e
    defb 0d1h                            ; $79B5: pop de
    defb 0e1h                            ; $79B6: pop hl
    defb 0b7h                            ; $79B7: or a
    defb 0edh, 052h                      ; $79B8: sbc hl,de
    defb 023h                            ; $79BA: inc hl
    defb 0ebh                            ; $79BB: ex de,hl
    defb 0e5h                            ; $79BC: push hl
    defb 0ddh, 0e1h                      ; $79BD: pop ix
    defb 0cdh, 0aeh, 019h                ; $79BF: call $19ae
    defb 018h, 02fh                      ; $79C2: jr $79f3

; -----------------------------------------------------------------------------
; Disk replacement for the monitor byte-save hook.
monitorDiskSave:
; Monitor SAVE hook.
    defb 0ddh, 0e5h                      ; $79C4: push ix
    defb 0e1h                            ; $79C6: pop hl
    defb 0cdh, 060h, 07ah                ; $79C7: call $7a60
    defb 001h, 01eh, 07bh                ; $79CA: ld bc,$7b1e
    defb 0cdh, 0cdh, 07ah                ; $79CD: call $7acd
    defb 0cdh, 0dbh, 07ah                ; $79D0: call $7adb
    defb 020h, 009h                      ; $79D3: jr nz,$79de
    defb 021h, 015h, 07ch                ; $79D5: ld hl,$7c15
    defb 0efh                            ; $79D8: rst $28
    defb 0fch, 079h, 0c2h                ; $79D9: call m,$c279
    defb 01eh, 07bh                      ; $79DC: ld e,$7b
    defb 0ddh, 021h, 049h, 0a9h          ; $79DE: ld ix,$a949
    defb 0cdh, 0e1h, 019h                ; $79E2: call $19e1
    defb 02ah, 056h, 0a9h                ; $79E5: ld hl,($a956)
    defb 022h, 074h, 03eh                ; $79E8: ld ($3e74),hl
    defb 03eh, 001h                      ; $79EB: ld a,$01
    defb 032h, 062h, 03eh                ; $79ED: ld ($3e62),a
    defb 0cdh, 000h, 01ah                ; $79F0: call $1a00
    defb 0cdh, 0e1h, 002h                ; $79F3: call $02e1
    defb 0cdh, 073h, 07bh                ; $79F6: call $7b73
    defb 0c3h, 0ech, 07dh                ; $79F9: jp $7dec

; -----------------------------------------------------------------------------
; Continuation of the monitor SAVE path after PROMETHEUS bookkeeping.
monitorDiskSaveContinuation:
; Unseeded but valid continuation used by the monitor save path.
    defb 0ebh                            ; $79FC: ex de,hl
    defb 02ah, 03bh, 07ch                ; $79FD: ld hl,($7c3b)
    defb 0cdh, 00ah, 07ah                ; $7A00: call $7a0a
    defb 0ebh                            ; $7A03: ex de,hl
    defb 0cdh, 0e8h, 07bh                ; $7A04: call $7be8
    defb 021h, 000h, 040h                ; $7A07: ld hl,$4000
    defb 022h, 0d9h, 07bh                ; $7A0A: ld ($7bd9),hl
    defb 022h, 0f0h, 07bh                ; $7A0D: ld ($7bf0),hl
    defb 0c9h                            ; $7A10: ret

; -----------------------------------------------------------------------------
; Disk replacement for assembler/source SAVE.
assemblerDiskSave:
; Assembler/source SAVE hook; computes and stores the source checksum before disk output.
    defb 0cdh, 05ch, 07ah                ; $7A11: call $7a5c
    defb 0c1h                            ; $7A14: pop bc
    defb 0e1h                            ; $7A15: pop hl
    defb 0e5h                            ; $7A16: push hl
    defb 0c5h                            ; $7A17: push bc
    defb 016h, 0ffh                      ; $7A18: ld d,$ff
    defb 07ah                            ; $7A1A: ld a,d
    defb 0aeh                            ; $7A1B: xor (hl)
    defb 057h                            ; $7A1C: ld d,a
    defb 023h                            ; $7A1D: inc hl
    defb 00bh                            ; $7A1E: dec bc
    defb 078h                            ; $7A1F: ld a,b
    defb 0b1h                            ; $7A20: or c
    defb 020h, 0f7h                      ; $7A21: jr nz,$7a1a
    defb 0ddh, 062h                      ; $7A23: ld ixh,d
    defb 0c1h                            ; $7A25: pop bc
    defb 0e1h                            ; $7A26: pop hl
    defb 009h                            ; $7A27: add hl,bc
    defb 02bh                            ; $7A28: dec hl
    defb 0edh, 05bh, 0f9h, 094h          ; $7A29: ld de,($94f9)
    defb 01bh                            ; $7A2D: dec de
    defb 03eh, 0ffh                      ; $7A2E: ld a,$ff
    defb 012h                            ; $7A30: ld (de),a
    defb 01bh                            ; $7A31: dec de
    defb 0ddh, 07ch                      ; $7A32: ld a,ixh
    defb 012h                            ; $7A34: ld (de),a
    defb 01bh                            ; $7A35: dec de
    defb 0c5h                            ; $7A36: push bc
    defb 01ah                            ; $7A37: ld a,(de)
    defb 0edh, 0a8h                      ; $7A38: ldd
    defb 023h                            ; $7A3A: inc hl
    defb 077h                            ; $7A3B: ld (hl),a
    defb 02bh                            ; $7A3C: dec hl
    defb 0eah, 037h, 07ah                ; $7A3D: jp pe,$7a37
    defb 023h                            ; $7A40: inc hl
    defb 013h                            ; $7A41: inc de
    defb 0e5h                            ; $7A42: push hl
    defb 0d5h                            ; $7A43: push de
    defb 0cdh, 0e5h, 07ah                ; $7A44: call $7ae5
    defb 0d1h                            ; $7A47: pop de
    defb 0e1h                            ; $7A48: pop hl
    defb 0c1h                            ; $7A49: pop bc
    defb 01ah                            ; $7A4A: ld a,(de)
    defb 0edh, 0a0h                      ; $7A4B: ldi
    defb 02bh                            ; $7A4D: dec hl
    defb 077h                            ; $7A4E: ld (hl),a
    defb 023h                            ; $7A4F: inc hl
    defb 0eah, 04ah, 07ah                ; $7A50: jp pe,$7a4a
    defb 0afh                            ; $7A53: xor a
    defb 012h                            ; $7A54: ld (de),a
    defb 013h                            ; $7A55: inc de
    defb 03eh, 030h                      ; $7A56: ld a,$30
    defb 012h                            ; $7A58: ld (de),a
    defb 0c3h, 034h, 09ah                ; $7A59: jp $9a34

; -----------------------------------------------------------------------------
; Copy editor filename workspace and replace trailing spaces with zeroes.
copyAndNormalizeFilename:
; Filename helper uses EXX so the caller register set remains available.
    defb 0d9h                            ; $7A5C: exx
    defb 021h, 0e0h, 050h                ; $7A5D: ld hl,$50e0
    defb 011h, 049h, 0a9h                ; $7A60: ld de,$a949
    defb 001h, 011h, 000h                ; $7A63: ld bc,$0011
    defb 0edh, 0b0h                      ; $7A66: ldir
    defb 021h, 053h, 0a9h                ; $7A68: ld hl,$a953
    defb 006h, 009h                      ; $7A6B: ld b,$09
    defb 07eh                            ; $7A6D: ld a,(hl)
    defb 0feh, 020h                      ; $7A6E: cp $20
    defb 020h, 005h                      ; $7A70: jr nz,$7a77
    defb 036h, 000h                      ; $7A72: ld (hl),$00
    defb 02bh                            ; $7A74: dec hl
    defb 010h, 0f6h                      ; $7A75: djnz $7a6d
    defb 0d9h                            ; $7A77: exx
    defb 0c9h                            ; $7A78: ret

; -----------------------------------------------------------------------------
; LOAD ! special case: invoke catalogue.
catalogueFromLoadBang:
; LOAD ! branches here to request a disk catalogue.
    defb 011h, 0cah, 07bh                ; $7A79: ld de,$7bca
    defb 0cdh, 085h, 07bh                ; $7A7C: call $7b85
    defb 0c3h, 0c0h, 08fh                ; $7A7F: jp $8fc0

; -----------------------------------------------------------------------------
; Disk replacement for assembler/source LOAD.
assemblerDiskLoad:
; Assembler/source LOAD hook.
    defb 03ah, 04dh, 095h                ; $7A82: ld a,($954d)
    defb 0feh, 021h                      ; $7A85: cp $21
    defb 028h, 0f0h                      ; $7A87: jr z,$7a79
    defb 001h, 00eh, 07bh                ; $7A89: ld bc,$7b0e
    defb 0cdh, 0cdh, 07ah                ; $7A8C: call $7acd
    defb 021h, 04ch, 095h                ; $7A8F: ld hl,$954c
    defb 0cdh, 060h, 07ah                ; $7A92: call $7a60
    defb 0cdh, 0dbh, 07ah                ; $7A95: call $7adb
    defb 0f5h                            ; $7A98: push af
    defb 022h, 072h, 03eh                ; $7A99: ld ($3e72),hl
    defb 011h, 0e0h, 050h                ; $7A9C: ld de,$50e0
    defb 001h, 011h, 000h                ; $7A9F: ld bc,$0011
    defb 0edh, 0b0h                      ; $7AA2: ldir
    defb 0cdh, 063h, 07bh                ; $7AA4: call $7b63
    defb 0f1h                            ; $7AA7: pop af
    defb 0cah, 051h, 096h                ; $7AA8: jp z,$9651
    defb 021h, 00bh, 07ch                ; $7AAB: ld hl,$7c0b
    defb 018h, 061h                      ; $7AAE: jr $7b11

; -----------------------------------------------------------------------------
; Prepare PROMETHEUS file metadata around a disk operation.
prepareLoadedFileMetadata:
    defb 021h, 0aah, 03eh                ; $7AB0: ld hl,$3eaa
    defb 011h, 080h, 03eh                ; $7AB3: ld de,$3e80
    defb 001h, 00ah, 000h                ; $7AB6: ld bc,$000a
    defb 0edh, 0b0h                      ; $7AB9: ldir
    defb 021h, 04ah, 0a9h                ; $7ABB: ld hl,$a94a
    defb 00eh, 00ah                      ; $7ABE: ld c,$0a
    defb 0edh, 0b0h                      ; $7AC0: ldir
    defb 03eh, 042h                      ; $7AC2: ld a,$42
    defb 012h                            ; $7AC4: ld (de),a
    defb 03ah, 06bh, 03eh                ; $7AC5: ld a,($3e6b)
    defb 03ch                            ; $7AC8: inc a
    defb 032h, 071h, 03eh                ; $7AC9: ld ($3e71),a
    defb 0c9h                            ; $7ACC: ret

; -----------------------------------------------------------------------------
; Temporarily replace the BASIC error return address.
installTemporaryErrorReturn:
; Temporarily replaces the BASIC error return word and remembers the old value.
    defb 02ah, 03dh, 05ch                ; $7ACD: ld hl,($5c3d)
    defb 05eh                            ; $7AD0: ld e,(hl)
    defb 023h                            ; $7AD1: inc hl
    defb 056h                            ; $7AD2: ld d,(hl)
    defb 0edh, 053h, 074h, 07bh          ; $7AD3: ld ($7b74),de
    defb 070h                            ; $7AD7: ld (hl),b
    defb 02bh                            ; $7AD8: dec hl
    defb 071h                            ; $7AD9: ld (hl),c
    defb 0c9h                            ; $7ADA: ret

; -----------------------------------------------------------------------------
; Enter the D40/D80 ROM operation wrapper.
invokeDiskRomOperation:
; Transfers into the M-DOS wrapper; RST 0 is executed in the prepared DOS context.
    defb 0cdh, 082h, 07bh                ; $7ADB: call $7b82
    defb 0c7h                            ; $7ADE: rst $00
    defb 0cdh, 0b0h, 07ah                ; $7ADF: call $7ab0
    defb 0c3h, 02bh, 021h                ; $7AE2: jp $212b

; -----------------------------------------------------------------------------
; Save path including existing-file/overwrite handling.
saveWithOverwriteHandling:
; Save dispatcher with overwrite/error handling.
    defb 0edh, 073h, 001h, 07bh          ; $7AE5: ld ($7b01),sp
    defb 0d5h                            ; $7AE9: push de
    defb 001h, 000h, 07bh                ; $7AEA: ld bc,$7b00
    defb 0cdh, 0cdh, 07ah                ; $7AED: call $7acd
    defb 0cdh, 0dbh, 07ah                ; $7AF0: call $7adb
    defb 020h, 046h                      ; $7AF3: jr nz,$7b3b
    defb 021h, 015h, 07ch                ; $7AF5: ld hl,$7c15
    defb 0efh                            ; $7AF8: rst $28
    defb 0e8h                            ; $7AF9: ret pe
    defb 07bh                            ; $7AFA: ld a,e
    defb 028h, 03eh                      ; $7AFB: jr z,$7b3b
    defb 0e1h                            ; $7AFD: pop hl
    defb 018h, 063h                      ; $7AFE: jr $7b63

; -----------------------------------------------------------------------------
; Self-modifying disk-failure recovery trampoline.
diskFailureRecoveryTrampoline:
; Self-modifying recovery trampoline; the LD SP immediate is filled at runtime.
    defb 031h, 000h, 000h                ; $7B00: ld sp,$0000
    defb 021h, 01fh, 07ch                ; $7B03: ld hl,$7c1f
    defb 0cdh, 0d4h, 07bh                ; $7B06: call $7bd4
    defb 0cdh, 080h, 0a4h                ; $7B09: call $a480
    defb 018h, 055h                      ; $7B0C: jr $7b63
    defb 021h, 01fh, 07ch                ; $7B0E: ld hl,$7c1f
    defb 0edh, 07bh, 067h, 09bh          ; $7B11: ld sp,($9b67)
    defb 0cdh, 0d4h, 07bh                ; $7B15: call $7bd4
    defb 0cdh, 066h, 07bh                ; $7B18: call $7b66
    defb 0c3h, 066h, 09bh                ; $7B1B: jp $9b66

; -----------------------------------------------------------------------------
; Restore PROMETHEUS stack/state after a disk failure.
recoverAfterDiskFailure:
    defb 0cdh, 0e1h, 002h                ; $7B1E: call $02e1
    defb 0edh, 07bh, 0f1h, 07dh          ; $7B21: ld sp,($7df1)
    defb 0cdh, 073h, 07bh                ; $7B25: call $7b73
    defb 0c3h, 03ch, 085h                ; $7B28: jp $853c

; -----------------------------------------------------------------------------
; Clear the status/display area used by disk messages.
clearDiskStatusLine:
; Clear the disk status line before returning to the PROMETHEUS UI.
    defb 021h, 0c0h, 050h                ; $7B2B: ld hl,$50c0
    defb 022h, 000h, 0a6h                ; $7B2E: ld ($a600),hl
    defb 006h, 020h                      ; $7B31: ld b,$20
    defb 03eh, 07eh                      ; $7B33: ld a,$7e
    defb 0cdh, 0dfh, 0a5h                ; $7B35: call $a5df
    defb 010h, 0f9h                      ; $7B38: djnz $7b33
    defb 0c9h                            ; $7B3A: ret

; -----------------------------------------------------------------------------
; Finish installing a source file after successful disk load.
finishLoadedSource:
    defb 0ddh, 021h, 049h, 0a9h          ; $7B3B: ld ix,$a949
    defb 0cdh, 0e1h, 019h                ; $7B3F: call $19e1
    defb 0e1h                            ; $7B42: pop hl
    defb 022h, 074h, 03eh                ; $7B43: ld ($3e74),hl
    defb 03eh, 001h                      ; $7B46: ld a,$01
    defb 032h, 062h, 03eh                ; $7B48: ld ($3e62),a
    defb 0cdh, 000h, 01ah                ; $7B4B: call $1a00
    defb 018h, 013h                      ; $7B4E: jr $7b63

; -----------------------------------------------------------------------------
; Catalogue entry used by LOAD !.
assemblerDiskCatalogue:
; Catalogue entry used by LOAD !.
    defb 0ddh, 0e5h                      ; $7B50: push ix
    defb 0d5h                            ; $7B52: push de
    defb 0cdh, 082h, 07bh                ; $7B53: call $7b82
    defb 0c7h                            ; $7B56: rst $00
    defb 001h, 00eh, 07bh                ; $7B57: ld bc,$7b0e
    defb 0cdh, 0cdh, 07ah                ; $7B5A: call $7acd
    defb 0d1h                            ; $7B5D: pop de
    defb 0ddh, 0e1h                      ; $7B5E: pop ix
    defb 0cdh, 0aeh, 019h                ; $7B60: call $19ae

; -----------------------------------------------------------------------------
; Restore editor state after an M-DOS call.
restorePrometheusAfterDiskCall:
    defb 0cdh, 0e1h, 002h                ; $7B63: call $02e1
    defb 0cdh, 02bh, 07bh                ; $7B66: call $7b2b
    defb 021h, 0e0h, 05ah                ; $7B69: ld hl,$5ae0
    defb 0edh, 04bh, 059h, 09ch          ; $7B6C: ld bc,($9c59)
    defb 0cdh, 059h, 0a1h                ; $7B70: call $a159

; -----------------------------------------------------------------------------
; Restore ERR_SP, IY and interrupt-disabled convention.
restoreErrorReturnAndInterruptState:
; Restore ERR_SP and the interrupt-disabled PROMETHEUS convention.
    defb 011h, 000h, 000h                ; $7B73: ld de,$0000
    defb 02ah, 03dh, 05ch                ; $7B76: ld hl,($5c3d)
    defb 073h                            ; $7B79: ld (hl),e
    defb 023h                            ; $7B7A: inc hl
    defb 072h                            ; $7B7B: ld (hl),d
    defb 0fdh, 036h, 000h, 0ffh          ; $7B7C: ld (iy+$00),$ff
    defb 0f3h                            ; $7B80: di
    defb 0c9h                            ; $7B81: ret

; -----------------------------------------------------------------------------
; Build an M-DOS-compatible stack/error context and jump to ROM.
enterMdosContext:
; Construct a temporary M-DOS stack/error context.
    defb 011h, 0b7h, 07bh                ; $7B82: ld de,$7bb7
    defb 02ah, 05dh, 05ch                ; $7B85: ld hl,($5c5d)
    defb 0fdh, 021h, 03ah, 05ch          ; $7B88: ld iy,$5c3a
    defb 0e5h                            ; $7B8C: push hl
    defb 0edh, 073h, 0b0h, 07bh          ; $7B8D: ld ($7bb0),sp
    defb 0edh, 07bh, 03dh, 05ch          ; $7B91: ld sp,($5c3d)
    defb 021h, 0a5h, 07bh                ; $7B95: ld hl,$7ba5
    defb 0e3h                            ; $7B98: ex (sp),hl
    defb 022h, 0a8h, 07bh                ; $7B99: ld ($7ba8),hl
    defb 0edh, 056h                      ; $7B9C: im 1
    defb 0fbh                            ; $7B9E: ei
    defb 03eh, 001h                      ; $7B9F: ld a,$01
    defb 0ebh                            ; $7BA1: ex de,hl
    defb 0c3h, 0d5h, 01bh                ; $7BA2: jp $1bd5

; -----------------------------------------------------------------------------
; Return trampoline entered by the M-DOS error/return context.
mdosReturnTrampoline:
; M-DOS return trampoline; two immediate words are patched with saved stack state.
    defb 03bh                            ; $7BA5: dec sp
    defb 03bh                            ; $7BA6: dec sp
    defb 021h, 000h, 000h                ; $7BA7: ld hl,$0000
    defb 0e3h                            ; $7BAA: ex (sp),hl
    defb 021h, 076h, 01bh                ; $7BAB: ld hl,$1b76
    defb 0e5h                            ; $7BAE: push hl
    defb 031h, 000h, 000h                ; $7BAF: ld sp,$0000
    defb 0e1h                            ; $7BB2: pop hl
    defb 022h, 05dh, 05ch                ; $7BB3: ld ($5c5d),hl
    defb 018h, 0c4h                      ; $7BB6: jr $7b7c

; -----------------------------------------------------------------------------
; Exact 28-byte M-DOS operation descriptor/workspace (field ABI not yet named); data, not linear Z80 code.
mdosOperationDescriptor:
; Passed as an M-DOS operation descriptor/workspace. The driver patches
; nearby return/error slots before entering ROM. Exact bytes are shown in
; structured data rows because a linear opcode interpretation is false.
    defb 0f4h, 023h, 032h, 00eh, 000h, 000h, 0f7h        ; $7BB8: descriptor +$00..+$06
    defb 000h, 000h, 02ch, 037h, 00eh, 000h, 000h        ; $7BBF: descriptor +$07..+$0D
    defb 04fh, 000h, 000h, 03ah, 03fh, 0fbh, 03ah        ; $7BC6: descriptor +$0E..+$14
    defb 0cfh, 03ah, 0f2h, 0c3h, 0a7h, 03ah, 03fh        ; $7BCD: descriptor +$15..+$1B

; -----------------------------------------------------------------------------
; Display a high-bit-terminated driver message.
displayDiskMessage:
; Display one high-bit-terminated disk message.
    defb 0e5h                            ; $7BD4: push hl
    defb 0cdh, 08bh, 0a5h                ; $7BD5: call $a58b
    defb 021h, 000h, 040h                ; $7BD8: ld hl,$4000
    defb 022h, 000h, 0a6h                ; $7BDB: ld ($a600),hl
    defb 0e1h                            ; $7BDE: pop hl
    defb 0cdh, 04fh, 09fh                ; $7BDF: call $9f4f
    defb 021h, 029h, 07ch                ; $7BE2: ld hl,$7c29
    defb 0c3h, 04fh, 09fh                ; $7BE5: jp $9f4f

; -----------------------------------------------------------------------------
; Ask whether an existing file should be preserved, replaced, or retried.
askOverwritePolicy:
; Prompt for P/R/Y after an existing-file condition.
    defb 0cdh, 0d4h, 07bh                ; $7BE8: call $7bd4
    defb 0cdh, 080h, 0a4h                ; $7BEB: call $a480
    defb 0f5h                            ; $7BEE: push af
    defb 021h, 000h, 040h                ; $7BEF: ld hl,$4000
    defb 022h, 000h, 0a6h                ; $7BF2: ld ($a600),hl
    defb 021h, 029h, 07ch                ; $7BF5: ld hl,$7c29
    defb 0cdh, 0d4h, 07bh                ; $7BF8: call $7bd4
    defb 021h, 029h, 07ch                ; $7BFB: ld hl,$7c29
    defb 0cdh, 0dfh, 07bh                ; $7BFE: call $7bdf
    defb 0f1h                            ; $7C01: pop af
    defb 0feh, 070h                      ; $7C02: cp $70
    defb 0c8h                            ; $7C04: ret z
    defb 0feh, 072h                      ; $7C05: cp $72
    defb 0c8h                            ; $7C07: ret z
    defb 0feh, 079h                      ; $7C08: cp $79
    defb 0c9h                            ; $7C0A: ret

; -----------------------------------------------------------------------------
; "Not found".
messageNotFound:
; File lookup failure message.
    defb 04eh, 06fh, 074h, 020h, 066h, 06fh, 075h, 06eh, 064h, 0a0h ; $7C0B: "Not found " (high-bit terminator)

; -----------------------------------------------------------------------------
; "Overwrite".
messageOverwrite:
; Existing-file prompt.
    defb 04fh, 076h, 065h, 072h, 077h, 072h, 069h, 074h, 065h, 0bfh ; $7C15: "Overwrite?" (high-bit terminator)

; -----------------------------------------------------------------------------
; "Disk error".
messageDiskError:
; Generic disk error message.
    defb 044h, 069h, 073h, 06bh, 020h, 065h, 072h, 072h, 06fh, 0f2h ; $7C1F: "Disk error" (high-bit terminator)

; -----------------------------------------------------------------------------
; Blank high-bit-terminated padding.
messageBlankPadding:
; Status-line erasure string.
    defb 020h, 020h, 020h, 020h, 020h, 020h, 020h, 0a0h, 000h    ; $7C29: blank padding (high-bit terminator)
    defb 000h, 000h, 000h, 000h, 000h, 000h                      ; $7C32: reserved zero padding
