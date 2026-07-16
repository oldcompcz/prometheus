; PROMETHEUS D40/D80 full distribution installer (3324 bytes)
;
; BYTE-EXACT, COMMENT-DECOMPILED SOURCE
;
; The first 23 bytes execute at the physical CODE-block load address $5DC0.
; Bytes stored after them are copied to $4017 and execute there. Each DEFB row
; therefore states the true runtime address in its comment. The tail is not code:
; it is a typed relocation table, decoded record by record below.
;
    org 05dc0h

; -----------------------------------------------------------------------------
; Self-locating 23-byte distribution bootstrap.
floppyBootstrap:
; Keep relocation/copy setup non-interruptible.
    defb 0f3h                            ; load $5DC0: di
; CALL a ROM RET to leave a load-position-dependent return address on the stack.
    defb 0cdh, 052h, 000h                ; load $5DC1: call $0052
; Expose that consumed return word again.
    defb 03bh                            ; load $5DC4: dec sp
    defb 03bh                            ; load $5DC5: dec sp
; Recover the physical address immediately after CALL.
    defb 0e1h                            ; load $5DC6: pop hl
; Preserve it for the runtime installer.
    defb 0e5h                            ; load $5DC7: push hl
; Advance to the stored runtime image at distribution offset 23.
    defb 001h, 013h, 000h                ; load $5DC8: ld bc,$0013
    defb 009h                            ; load $5DCB: add hl,bc
    defb 001h, 0c9h, 001h                ; load $5DCC: ld bc,$01c9
    defb 011h, 017h, 040h                ; load $5DCF: ld de,$4017
    defb 0edh, 0b0h                      ; load $5DD2: ldir
; Execute the copied runtime installer.
    defb 0c3h, 017h, 040h                ; load $5DD4: jp $4017

; =============================================================================
; Runtime image stored in the distribution from $5DD7, executing at $4017.
; =============================================================================

; -----------------------------------------------------------------------------
; Runtime entry after the 457-byte front section has been copied to $4017.
installerRuntimeEntry:
; BC is the variant-specific number of relocation-table bytes still in the original load image.
    defb 001h, 01ch, 00bh                ; runtime $4017, stored $5DD7: ld bc,$0b1c
; DE currently equals $41E0; save it as the relocation-table start.
    defb 0d5h                            ; runtime $401A, stored $5DDA: push de
    defb 0edh, 0b0h                      ; runtime $401B, stored $5DDB: ldir
; Append the two-byte zero terminator that is deliberately absent from the distributed image.
    defb 0afh                            ; runtime $401D, stored $5DDD: xor a
    defb 012h                            ; runtime $401E, stored $5DDE: ld (de),a
    defb 013h                            ; runtime $401F, stored $5DDF: inc de
    defb 012h                            ; runtime $4020, stored $5DE0: ld (de),a

; -----------------------------------------------------------------------------
; Initialize attributes and clear the temporary $5000-$57FF bitmap workspace.
initializeInstallerDisplay:
    defb 011h, 000h, 058h                ; runtime $4021, stored $5DE1: ld de,$5800
; B=0 makes each DJNZ loop execute 256 iterations.
    defb 006h, 000h                      ; runtime $4024, stored $5DE4: ld b,$00
    defb 03eh, 03fh                      ; runtime $4026, stored $5DE6: ld a,$3f
    defb 012h                            ; runtime $4028, stored $5DE8: ld (de),a
    defb 013h                            ; runtime $4029, stored $5DE9: inc de
    defb 012h                            ; runtime $402A, stored $5DEA: ld (de),a
    defb 013h                            ; runtime $402B, stored $5DEB: inc de
    defb 010h, 0f8h                      ; runtime $402C, stored $5DEC: djnz $4026
    defb 03eh, 038h                      ; runtime $402E, stored $5DEE: ld a,$38
    defb 012h                            ; runtime $4030, stored $5DF0: ld (de),a
    defb 013h                            ; runtime $4031, stored $5DF1: inc de
    defb 010h, 0fah                      ; runtime $4032, stored $5DF2: djnz $402e
; Clear $5000-$57FF, used for installer text rendering.
    defb 011h, 000h, 050h                ; runtime $4034, stored $5DF4: ld de,$5000
    defb 0afh                            ; runtime $4037, stored $5DF7: xor a
    defb 012h                            ; runtime $4038, stored $5DF8: ld (de),a
    defb 013h                            ; runtime $4039, stored $5DF9: inc de
    defb 07ah                            ; runtime $403A, stored $5DFA: ld a,d
    defb 0feh, 058h                      ; runtime $403B, stored $5DFB: cp $58
    defb 038h, 0f8h                      ; runtime $403D, stored $5DFD: jr c,$4037

; -----------------------------------------------------------------------------
; Recover relocation-table, distribution-base and resident-image pointers from the temporary stack.
recoverInstallerPointers:
    defb 0ddh, 0e1h                      ; runtime $403F, stored $5DFF: pop ix
; The bootstrap left its captured physical return address on the temporary stack.
    defb 0d1h                            ; runtime $4041, stored $5E01: pop de
; Subtract four to recover the actual CODE-block load base.
    defb 01bh                            ; runtime $4042, stored $5E02: dec de
    defb 01bh                            ; runtime $4043, stored $5E03: dec de
    defb 01bh                            ; runtime $4044, stored $5E04: dec de
    defb 01bh                            ; runtime $4045, stored $5E05: dec de
; HL points immediately after the installer: the first resident byte to be moved.
    defb 0e5h                            ; runtime $4046, stored $5E06: push hl
; IX is the typed relocation-table pointer.
    defb 0ddh, 0e5h                      ; runtime $4047, stored $5E07: push ix
    defb 0ebh                            ; runtime $4049, stored $5E09: ex de,hl

; -----------------------------------------------------------------------------
; Format the physical CODE-block load address into the five editable decimal digits.
formatDetectedLoadAddress:
    defb 001h, 0cch, 040h                ; runtime $404A, stored $5E0A: ld bc,$40cc
    defb 011h, 010h, 027h                ; runtime $404D, stored $5E0D: ld de,$2710
    defb 0cdh, 022h, 041h                ; runtime $4050, stored $5E10: call $4122
    defb 011h, 0e8h, 003h                ; runtime $4053, stored $5E13: ld de,$03e8
    defb 0cdh, 022h, 041h                ; runtime $4056, stored $5E16: call $4122
    defb 011h, 064h, 000h                ; runtime $4059, stored $5E19: ld de,$0064
    defb 0cdh, 022h, 041h                ; runtime $405C, stored $5E1C: call $4122
    defb 01eh, 00ah                      ; runtime $405F, stored $5E1F: ld e,$0a
    defb 0cdh, 022h, 041h                ; runtime $4061, stored $5E21: call $4122
    defb 01eh, 001h                      ; runtime $4064, stored $5E24: ld e,$01
    defb 0cdh, 022h, 041h                ; runtime $4066, stored $5E26: call $4122

; -----------------------------------------------------------------------------
; Draw the product/version title using an inline high-bit-terminated string.
drawInstallerTitle:
    defb 021h, 043h, 050h                ; runtime $4069, stored $5E29: ld hl,$5043
; Self-modify the glyph destination operand at $41B8.
    defb 022h, 0b8h, 041h                ; runtime $406C, stored $5E2C: ld ($41b8),hl
    defb 0cdh, 0a5h, 041h                ; runtime $406F, stored $5E2F: call $41a5

; -----------------------------------------------------------------------------
; Inline high-bit-terminated text consumed by printInlineHighBitString.
installerVersionString:
    defb 050h, 052h, 04fh, 04dh, 045h, 054h, 048h, 045h, 055h, 053h, 020h, 064h, 069h, 073h, 06bh, 020h, 076h, 065h, 072h, 073h, 069h, 06fh, 06eh, 020h, 0c1h ; runtime $4072: "PROMETHEUS disk version A"

; -----------------------------------------------------------------------------
; Draw the copyright line using an inline high-bit-terminated string.
drawInstallerCopyright:
    defb 021h, 081h, 050h                ; runtime $408B, stored $5E4B: ld hl,$5081
    defb 022h, 0b8h, 041h                ; runtime $408E, stored $5E4E: ld ($41b8),hl
    defb 0cdh, 0a5h, 041h                ; runtime $4091, stored $5E51: call $41a5

; -----------------------------------------------------------------------------
; Inline high-bit-terminated text consumed by printInlineHighBitString.
installerCopyrightString:
    defb 07fh, 020h, 031h, 039h, 039h, 032h, 020h, 050h, 052h, 04fh, 058h, 049h, 04dh, 041h, 020h, 073h, 06fh, 066h, 074h, 077h, 061h, 072h, 065h, 020h, 076h, 02eh, 06fh, 02eh, 0f3h ; runtime $4094: "<copyright-glyph> 1992 PROXIMA software v.o.s"

; -----------------------------------------------------------------------------
; Enable IM 1 interrupts and clear the ROM new-key flag.
enableKeyboardInput:
    defb 0edh, 056h                      ; runtime $40B1, stored $5E71: im 1
    defb 0fbh                            ; runtime $40B3, stored $5E73: ei
; Clear FLAGS bit 5 so a fresh keypress can be detected.
    defb 0fdh, 0cbh, 001h, 0aeh          ; runtime $40B4, stored $5E74: res 5,(iy+$01)

; -----------------------------------------------------------------------------
; Draw the Address prompt and current editable address buffer.
redrawAddressPrompt:
    defb 021h, 0c8h, 050h                ; runtime $40B8, stored $5E78: ld hl,$50c8
    defb 022h, 0b8h, 041h                ; runtime $40BB, stored $5E7B: ld ($41b8),hl
    defb 0cdh, 0a5h, 041h                ; runtime $40BE, stored $5E7E: call $41a5

; -----------------------------------------------------------------------------
; Inline high-bit-terminated text consumed by printInlineHighBitString.
installerAddressPrompt:
    defb 041h, 064h, 064h, 072h, 065h, 073h, 073h, 0bah                          ; runtime $40C1: "Address:"
; Print the editable seven-byte buffer inline at $40CC.
    defb 0cdh, 0a5h, 041h                ; runtime $40C9, stored $5E89: call $41a5

; -----------------------------------------------------------------------------
; Inline high-bit-terminated text consumed by printInlineHighBitString.
installerAddressBuffer:
    defb 030h, 030h, 030h, 030h, 030h, 05fh, 0a0h                                ; runtime $40CC: "00000_ "

; -----------------------------------------------------------------------------
; Wait for a ROM-decoded key and accept DELETE, ENTER, or a decimal digit.
waitForInstallerKey:
; HALT until the ROM keyboard interrupt sets FLAGS bit 5.
    defb 076h                            ; runtime $40D3, stored $5E93: halt
    defb 0fdh, 0cbh, 001h, 06eh          ; runtime $40D4, stored $5E94: bit 5,(iy+$01)
    defb 028h, 0f9h                      ; runtime $40D8, stored $5E98: jr z,$40d3
    defb 021h, 0c8h, 000h                ; runtime $40DA, stored $5E9A: ld hl,$00c8
    defb 01eh, 002h                      ; runtime $40DD, stored $5E9D: ld e,$02
    defb 054h                            ; runtime $40DF, stored $5E9F: ld d,h
; ROM pause/debounce routine with HL=$00C8 and DE=$0002.
    defb 0cdh, 0b5h, 003h                ; runtime $40E0, stored $5EA0: call $03b5
; Read LAST_K.
    defb 03ah, 008h, 05ch                ; runtime $40E3, stored $5EA3: ld a,($5c08)
    defb 0fdh, 0cbh, 001h, 0aeh          ; runtime $40E6, stored $5EA6: res 5,(iy+$01)
    defb 0feh, 00ch                      ; runtime $40EA, stored $5EAA: cp $0c
    defb 020h, 016h                      ; runtime $40EC, stored $5EAC: jr nz,$4104
; The immediate word at $4111 is also the mutable cursor pointer.
    defb 02ah, 011h, 041h                ; runtime $40EE, stored $5EAE: ld hl,($4111)
    defb 001h, 0cch, 040h                ; runtime $40F1, stored $5EB1: ld bc,$40cc
    defb 0b7h                            ; runtime $40F4, stored $5EB4: or a
    defb 0edh, 042h                      ; runtime $40F5, stored $5EB5: sbc hl,bc
    defb 009h                            ; runtime $40F7, stored $5EB7: add hl,bc
    defb 028h, 0d9h                      ; runtime $40F8, stored $5EB8: jr z,$40d3
    defb 036h, 020h                      ; runtime $40FA, stored $5EBA: ld (hl),$20
    defb 02bh                            ; runtime $40FC, stored $5EBC: dec hl
    defb 036h, 05fh                      ; runtime $40FD, stored $5EBD: ld (hl),$5f
    defb 022h, 011h, 041h                ; runtime $40FF, stored $5EBF: ld ($4111),hl
    defb 018h, 0b4h                      ; runtime $4102, stored $5EC2: jr $40b8
; ENTER commits; only ASCII 0..9 are otherwise accepted.
    defb 0feh, 00dh                      ; runtime $4104, stored $5EC4: cp $0d
    defb 028h, 026h                      ; runtime $4106, stored $5EC6: jr z,$412e
    defb 0feh, 030h                      ; runtime $4108, stored $5EC8: cp $30
    defb 038h, 0c7h                      ; runtime $410A, stored $5ECA: jr c,$40d3
    defb 0feh, 03ah                      ; runtime $410C, stored $5ECC: cp $3a
    defb 030h, 0c3h                      ; runtime $410E, stored $5ECE: jr nc,$40d3
; Load the mutable insertion cursor; its operand is rewritten after each edit.
    defb 021h, 0d1h, 040h                ; runtime $4110, stored $5ED0: ld hl,$40d1
    defb 023h                            ; runtime $4113, stored $5ED3: inc hl
    defb 0cbh, 07eh                      ; runtime $4114, stored $5ED4: bit 7,(hl)
    defb 02bh                            ; runtime $4116, stored $5ED6: dec hl
    defb 020h, 0bah                      ; runtime $4117, stored $5ED7: jr nz,$40d3
    defb 077h                            ; runtime $4119, stored $5ED9: ld (hl),a
    defb 023h                            ; runtime $411A, stored $5EDA: inc hl
    defb 036h, 05fh                      ; runtime $411B, stored $5EDB: ld (hl),$5f
    defb 022h, 011h, 041h                ; runtime $411D, stored $5EDD: ld ($4111),hl
    defb 018h, 096h                      ; runtime $4120, stored $5EE0: jr $40b8

; -----------------------------------------------------------------------------
; Repeated-subtraction helper used to render one decimal digit.
emitDecimalDigit:
    defb 03eh, 02fh                      ; runtime $4122, stored $5EE2: ld a,$2f
    defb 0b7h                            ; runtime $4124, stored $5EE4: or a
    defb 03ch                            ; runtime $4125, stored $5EE5: inc a
    defb 0edh, 052h                      ; runtime $4126, stored $5EE6: sbc hl,de
    defb 030h, 0fah                      ; runtime $4128, stored $5EE8: jr nc,$4124
    defb 019h                            ; runtime $412A, stored $5EEA: add hl,de
    defb 002h                            ; runtime $412B, stored $5EEB: ld (bc),a
    defb 003h                            ; runtime $412C, stored $5EEC: inc bc
    defb 0c9h                            ; runtime $412D, stored $5EED: ret

; -----------------------------------------------------------------------------
; Parse the five digits, move the resident image, and apply the typed relocation table.
parseAddressAndInstall:
; BC points to the first digit of the inline address buffer.
    defb 001h, 0cch, 040h                ; runtime $412E, stored $5EEE: ld bc,$40cc
    defb 03eh, 004h                      ; runtime $4131, stored $5EF1: ld a,$04
    defb 0d3h, 0feh                      ; runtime $4133, stored $5EF3: out ($fe),a
; HL accumulates the decimal value.
    defb 021h, 000h, 000h                ; runtime $4135, stored $5EF5: ld hl,$0000
    defb 00ah                            ; runtime $4138, stored $5EF8: ld a,(bc)
    defb 003h                            ; runtime $4139, stored $5EF9: inc bc
    defb 0feh, 05fh                      ; runtime $413A, stored $5EFA: cp $5f
    defb 028h, 00eh                      ; runtime $413C, stored $5EFC: jr z,$414c
; HL = HL*10 + digit, implemented without multiplication.
    defb 029h                            ; runtime $413E, stored $5EFE: add hl,hl
    defb 0e5h                            ; runtime $413F, stored $5EFF: push hl
    defb 029h                            ; runtime $4140, stored $5F00: add hl,hl
    defb 029h                            ; runtime $4141, stored $5F01: add hl,hl
    defb 0d1h                            ; runtime $4142, stored $5F02: pop de
    defb 019h                            ; runtime $4143, stored $5F03: add hl,de
    defb 0d6h, 030h                      ; runtime $4144, stored $5F04: sub $30
    defb 05fh                            ; runtime $4146, stored $5F06: ld e,a
    defb 016h, 000h                      ; runtime $4147, stored $5F07: ld d,$00
    defb 019h                            ; runtime $4149, stored $5F09: add hl,de
    defb 018h, 0ech                      ; runtime $414A, stored $5F0A: jr $4138

; -----------------------------------------------------------------------------
; Move the driver/body with overlap safety, then relocate every recorded operand.
moveAndRelocateResidentImage:
    defb 0ebh                            ; runtime $414C, stored $5F0C: ex de,hl
    defb 0ddh, 0e1h                      ; runtime $414D, stored $5F0D: pop ix
    defb 0e1h                            ; runtime $414F, stored $5F0F: pop hl
; BC is exactly driver length + retained PROMETHEUS body length for this variant.
    defb 001h, 0a0h, 041h                ; runtime $4150, stored $5F10: ld bc,$41a0
    defb 0d5h                            ; runtime $4153, stored $5F13: push de
    defb 0cdh, 0cah, 041h                ; runtime $4154, stored $5F14: call $41ca
    defb 0e1h                            ; runtime $4157, stored $5F17: pop hl
    defb 0e5h                            ; runtime $4158, stored $5F18: push hl
; The historical resident reference base is fixed at disk-driver base $7918.
    defb 011h, 018h, 079h                ; runtime $4159, stored $5F19: ld de,$7918
    defb 0b7h                            ; runtime $415C, stored $5F1C: or a
    defb 0e5h                            ; runtime $415D, stored $5F1D: push hl
; BC becomes the signed relocation delta selected by the entered address.
    defb 0edh, 052h                      ; runtime $415E, stored $5F1E: sbc hl,de
    defb 04dh                            ; runtime $4160, stored $5F20: ld c,l
    defb 044h                            ; runtime $4161, stored $5F21: ld b,h
    defb 0d1h                            ; runtime $4162, stored $5F22: pop de
; Clear the saved carry used by split low/high relocation records.
    defb 0afh                            ; runtime $4163, stored $5F23: xor a
    defb 032h, 092h, 041h                ; runtime $4164, stored $5F24: ld ($4192),a

; -----------------------------------------------------------------------------
; Typed relocation loop: whole word, split low byte, or split high byte.
applyTypedRelocationTable:
    defb 0ddh, 06eh, 000h                ; runtime $4167, stored $5F27: ld l,(ix+$00)
    defb 0ddh, 066h, 001h                ; runtime $416A, stored $5F2A: ld h,(ix+$01)
    defb 0ddh, 023h                      ; runtime $416D, stored $5F2D: inc ix
    defb 0ddh, 023h                      ; runtime $416F, stored $5F2F: inc ix
    defb 07ch                            ; runtime $4171, stored $5F31: ld a,h
    defb 0b5h                            ; runtime $4172, stored $5F32: or l
    defb 0c8h                            ; runtime $4173, stored $5F33: ret z
; Top two bits select record type; the lower 14 bits are the patch offset.
    defb 07ch                            ; runtime $4174, stored $5F34: ld a,h
    defb 0e6h, 0c0h                      ; runtime $4175, stored $5F35: and $c0
    defb 0cbh, 0bch                      ; runtime $4177, stored $5F37: res 7,h
    defb 0cbh, 0b4h                      ; runtime $4179, stored $5F39: res 6,h
    defb 019h                            ; runtime $417B, stored $5F3B: add hl,de
    defb 0d5h                            ; runtime $417C, stored $5F3C: push de
    defb 05eh                            ; runtime $417D, stored $5F3D: ld e,(hl)
    defb 023h                            ; runtime $417E, stored $5F3E: inc hl
    defb 056h                            ; runtime $417F, stored $5F3F: ld d,(hl)
    defb 0ebh                            ; runtime $4180, stored $5F40: ex de,hl
    defb 0b7h                            ; runtime $4181, stored $5F41: or a
    defb 028h, 015h                      ; runtime $4182, stored $5F42: jr z,$4199
    defb 0feh, 040h                      ; runtime $4184, stored $5F44: cp $40
    defb 028h, 009h                      ; runtime $4186, stored $5F46: jr z,$4191
; Type $80: add delta low byte and save carry for a later type-$40 record.
    defb 07dh                            ; runtime $4188, stored $5F48: ld a,l
    defb 081h                            ; runtime $4189, stored $5F49: add a,c
    defb 06fh                            ; runtime $418A, stored $5F4A: ld l,a
    defb 03eh, 000h                      ; runtime $418B, stored $5F4B: ld a,$00
    defb 0ceh, 000h                      ; runtime $418D, stored $5F4D: adc a,$00
    defb 018h, 00ah                      ; runtime $418F, stored $5F4F: jr $419b
; Type $40: relocate a separated high byte using delta high byte plus saved carry.
    defb 03eh, 000h                      ; runtime $4191, stored $5F51: ld a,$00
    defb 085h                            ; runtime $4193, stored $5F53: add a,l
    defb 080h                            ; runtime $4194, stored $5F54: add a,b
    defb 06fh                            ; runtime $4195, stored $5F55: ld l,a
    defb 0afh                            ; runtime $4196, stored $5F56: xor a
    defb 018h, 002h                      ; runtime $4197, stored $5F57: jr $419b
; Type $00: add the complete 16-bit relocation delta.
    defb 009h                            ; runtime $4199, stored $5F59: add hl,bc
    defb 0afh                            ; runtime $419A, stored $5F5A: xor a
; Store carry into the immediate operand at $4192 for the next split-high record.
    defb 032h, 092h, 041h                ; runtime $419B, stored $5F5B: ld ($4192),a
    defb 0ebh                            ; runtime $419E, stored $5F5E: ex de,hl
    defb 072h                            ; runtime $419F, stored $5F5F: ld (hl),d
    defb 02bh                            ; runtime $41A0, stored $5F60: dec hl
    defb 073h                            ; runtime $41A1, stored $5F61: ld (hl),e
    defb 0d1h                            ; runtime $41A2, stored $5F62: pop de
    defb 018h, 0c2h                      ; runtime $41A3, stored $5F63: jr $4167

; -----------------------------------------------------------------------------
; Consume the CALL return address as a high-bit-terminated inline string pointer.
printInlineHighBitString:
; POP converts the caller return address into the inline string source.
    defb 0e1h                            ; runtime $41A5, stored $5F65: pop hl
    defb 07eh                            ; runtime $41A6, stored $5F66: ld a,(hl)
    defb 0cdh, 0b0h, 041h                ; runtime $41A7, stored $5F67: call $41b0
; Bit 7 on the original byte terminates the string.
    defb 0cbh, 07eh                      ; runtime $41AA, stored $5F6A: bit 7,(hl)
    defb 023h                            ; runtime $41AC, stored $5F6C: inc hl
    defb 028h, 0f7h                      ; runtime $41AD, stored $5F6D: jr z,$41a6
    defb 0e9h                            ; runtime $41AF, stored $5F6F: jp (hl)

; -----------------------------------------------------------------------------
; Render one ROM-font character into the Spectrum bitmap.
drawInstallerCharacter:
    defb 087h                            ; runtime $41B0, stored $5F70: add a,a
    defb 0d9h                            ; runtime $41B1, stored $5F71: exx
    defb 06fh                            ; runtime $41B2, stored $5F72: ld l,a
    defb 026h, 00fh                      ; runtime $41B3, stored $5F73: ld h,$0f
    defb 029h                            ; runtime $41B5, stored $5F75: add hl,hl
    defb 029h                            ; runtime $41B6, stored $5F76: add hl,hl
; Self-modified destination pointer; the caller writes it at $41B8.
    defb 011h, 000h, 000h                ; runtime $41B7, stored $5F77: ld de,$0000
    defb 0d5h                            ; runtime $41BA, stored $5F7A: push de
    defb 006h, 008h                      ; runtime $41BB, stored $5F7B: ld b,$08
    defb 07eh                            ; runtime $41BD, stored $5F7D: ld a,(hl)
    defb 012h                            ; runtime $41BE, stored $5F7E: ld (de),a
    defb 023h                            ; runtime $41BF, stored $5F7F: inc hl
; Increment D to follow Spectrum bitmap row stride $0100.
    defb 014h                            ; runtime $41C0, stored $5F80: inc d
    defb 010h, 0fah                      ; runtime $41C1, stored $5F81: djnz $41bd
    defb 0e1h                            ; runtime $41C3, stored $5F83: pop hl
    defb 02ch                            ; runtime $41C4, stored $5F84: inc l
    defb 022h, 0b8h, 041h                ; runtime $41C5, stored $5F85: ld ($41b8),hl
    defb 0d9h                            ; runtime $41C8, stored $5F88: exx
    defb 0c9h                            ; runtime $41C9, stored $5F89: ret

; -----------------------------------------------------------------------------
; Choose LDIR or LDDR according to source/destination overlap.
moveMemoryOverlapSafe:
; Zero length returns immediately.
    defb 078h                            ; runtime $41CA, stored $5F8A: ld a,b
    defb 0b1h                            ; runtime $41CB, stored $5F8B: or c
    defb 0c8h                            ; runtime $41CC, stored $5F8C: ret z
    defb 0e5h                            ; runtime $41CD, stored $5F8D: push hl
    defb 0afh                            ; runtime $41CE, stored $5F8E: xor a
    defb 0edh, 052h                      ; runtime $41CF, stored $5F8F: sbc hl,de
    defb 0e1h                            ; runtime $41D1, stored $5F91: pop hl
; Forward copy is safe when source is below destination test result permits it.
    defb 038h, 003h                      ; runtime $41D2, stored $5F92: jr c,$41d7
    defb 0edh, 0b0h                      ; runtime $41D4, stored $5F94: ldir
    defb 0c9h                            ; runtime $41D6, stored $5F96: ret
    defb 009h                            ; runtime $41D7, stored $5F97: add hl,bc
    defb 02bh                            ; runtime $41D8, stored $5F98: dec hl
    defb 0ebh                            ; runtime $41D9, stored $5F99: ex de,hl
    defb 009h                            ; runtime $41DA, stored $5F9A: add hl,bc
    defb 02bh                            ; runtime $41DB, stored $5F9B: dec hl
    defb 0ebh                            ; runtime $41DC, stored $5F9C: ex de,hl
    defb 0edh, 0b8h                      ; runtime $41DD, stored $5F9D: lddr
    defb 0c9h                            ; runtime $41DF, stored $5F9F: ret

; -----------------------------------------------------------------------------
; Relocation records; the installer appends an in-memory zero terminator after copying them.
typedRelocationTable:
; Record format proven by the decoder at $4167:
;   $0000-$3FFF  relocate the complete little-endian word at this offset;
;   $8000-$BFFF  relocate only a separated low byte and save carry;
;   $4000-$7FFF  relocate the matching separated high byte with saved carry.
; The distributed table has no $0000 record. The runtime entry appends two zero
; bytes immediately after the copied table and the loop stops on that synthesized
; terminator. Offsets are relative to the resident relocation base held in DE.
; This full installer moves exactly $41A0 bytes before applying the table.
    defb 001h, 000h      ; runtime $41E0, stored $5FA0: #0001 word patch offset $0001; whole 16-bit word += relocation delta
    defb 004h, 000h      ; runtime $41E2, stored $5FA2: #0002 word patch offset $0004; whole 16-bit word += relocation delta
    defb 00fh, 000h      ; runtime $41E4, stored $5FA4: #0003 word patch offset $000F; whole 16-bit word += relocation delta
    defb 015h, 080h      ; runtime $41E6, stored $5FA6: #0004 low  patch offset $0015; split LOW byte += delta low; save carry
    defb 018h, 040h      ; runtime $41E8, stored $5FA8: #0005 high patch offset $0018; split HIGH byte += delta high + saved carry
    defb 01ah, 000h      ; runtime $41EA, stored $5FAA: #0006 word patch offset $001A; whole 16-bit word += relocation delta
    defb 020h, 080h      ; runtime $41EC, stored $5FAC: #0007 low  patch offset $0020; split LOW byte += delta low; save carry
    defb 023h, 040h      ; runtime $41EE, stored $5FAE: #0008 high patch offset $0023; split HIGH byte += delta high + saved carry
    defb 025h, 000h      ; runtime $41F0, stored $5FB0: #0009 word patch offset $0025; whole 16-bit word += relocation delta
    defb 02bh, 080h      ; runtime $41F2, stored $5FB2: #0010 low  patch offset $002B; split LOW byte += delta low; save carry
    defb 02eh, 040h      ; runtime $41F4, stored $5FB4: #0011 high patch offset $002E; split HIGH byte += delta high + saved carry
    defb 030h, 000h      ; runtime $41F6, stored $5FB6: #0012 word patch offset $0030; whole 16-bit word += relocation delta
    defb 036h, 080h      ; runtime $41F8, stored $5FB8: #0013 low  patch offset $0036; split LOW byte += delta low; save carry
    defb 039h, 040h      ; runtime $41FA, stored $5FBA: #0014 high patch offset $0039; split HIGH byte += delta high + saved carry
    defb 03bh, 000h      ; runtime $41FC, stored $5FBC: #0015 word patch offset $003B; whole 16-bit word += relocation delta
    defb 03eh, 000h      ; runtime $41FE, stored $5FBE: #0016 word patch offset $003E; whole 16-bit word += relocation delta
    defb 044h, 080h      ; runtime $4200, stored $5FC0: #0017 low  patch offset $0044; split LOW byte += delta low; save carry
    defb 047h, 040h      ; runtime $4202, stored $5FC2: #0018 high patch offset $0047; split HIGH byte += delta high + saved carry
    defb 049h, 000h      ; runtime $4204, stored $5FC4: #0019 word patch offset $0049; whole 16-bit word += relocation delta
    defb 04fh, 080h      ; runtime $4206, stored $5FC6: #0020 low  patch offset $004F; split LOW byte += delta low; save carry
    defb 052h, 040h      ; runtime $4208, stored $5FC8: #0021 high patch offset $0052; split HIGH byte += delta high + saved carry
    defb 054h, 000h      ; runtime $420A, stored $5FCA: #0022 word patch offset $0054; whole 16-bit word += relocation delta
    defb 05ah, 080h      ; runtime $420C, stored $5FCC: #0023 low  patch offset $005A; split LOW byte += delta low; save carry
    defb 05dh, 040h      ; runtime $420E, stored $5FCE: #0024 high patch offset $005D; split HIGH byte += delta high + saved carry
    defb 05fh, 000h      ; runtime $4210, stored $5FD0: #0025 word patch offset $005F; whole 16-bit word += relocation delta
    defb 065h, 080h      ; runtime $4212, stored $5FD2: #0026 low  patch offset $0065; split LOW byte += delta low; save carry
    defb 068h, 040h      ; runtime $4214, stored $5FD4: #0027 high patch offset $0068; split HIGH byte += delta high + saved carry
    defb 06ah, 000h      ; runtime $4216, stored $5FD6: #0028 word patch offset $006A; whole 16-bit word += relocation delta
    defb 070h, 080h      ; runtime $4218, stored $5FD8: #0029 low  patch offset $0070; split LOW byte += delta low; save carry
    defb 073h, 040h      ; runtime $421A, stored $5FDA: #0030 high patch offset $0073; split HIGH byte += delta high + saved carry
    defb 075h, 000h      ; runtime $421C, stored $5FDC: #0031 word patch offset $0075; whole 16-bit word += relocation delta
    defb 07ch, 000h      ; runtime $421E, stored $5FDE: #0032 word patch offset $007C; whole 16-bit word += relocation delta
    defb 07fh, 000h      ; runtime $4220, stored $5FE0: #0033 word patch offset $007F; whole 16-bit word += relocation delta
    defb 082h, 000h      ; runtime $4222, stored $5FE2: #0034 word patch offset $0082; whole 16-bit word += relocation delta
    defb 086h, 000h      ; runtime $4224, stored $5FE4: #0035 word patch offset $0086; whole 16-bit word += relocation delta
    defb 089h, 000h      ; runtime $4226, stored $5FE6: #0036 word patch offset $0089; whole 16-bit word += relocation delta
    defb 08ch, 000h      ; runtime $4228, stored $5FE8: #0037 word patch offset $008C; whole 16-bit word += relocation delta
    defb 08fh, 000h      ; runtime $422A, stored $5FEA: #0038 word patch offset $008F; whole 16-bit word += relocation delta
    defb 092h, 000h      ; runtime $422C, stored $5FEC: #0039 word patch offset $0092; whole 16-bit word += relocation delta
    defb 095h, 000h      ; runtime $422E, stored $5FEE: #0040 word patch offset $0095; whole 16-bit word += relocation delta
    defb 09bh, 000h      ; runtime $4230, stored $5FF0: #0041 word patch offset $009B; whole 16-bit word += relocation delta
    defb 0b0h, 000h      ; runtime $4232, stored $5FF2: #0042 word patch offset $00B0; whole 16-bit word += relocation delta
    defb 0b3h, 000h      ; runtime $4234, stored $5FF4: #0043 word patch offset $00B3; whole 16-bit word += relocation delta
    defb 0b6h, 000h      ; runtime $4236, stored $5FF6: #0044 word patch offset $00B6; whole 16-bit word += relocation delta
    defb 0b9h, 000h      ; runtime $4238, stored $5FF8: #0045 word patch offset $00B9; whole 16-bit word += relocation delta
    defb 0beh, 000h      ; runtime $423A, stored $5FFA: #0046 word patch offset $00BE; whole 16-bit word += relocation delta
    defb 0c1h, 000h      ; runtime $423C, stored $5FFC: #0047 word patch offset $00C1; whole 16-bit word += relocation delta
    defb 0c4h, 000h      ; runtime $423E, stored $5FFE: #0048 word patch offset $00C4; whole 16-bit word += relocation delta
    defb 0c8h, 000h      ; runtime $4240, stored $6000: #0049 word patch offset $00C8; whole 16-bit word += relocation delta
    defb 0ceh, 000h      ; runtime $4242, stored $6002: #0050 word patch offset $00CE; whole 16-bit word += relocation delta
    defb 0dfh, 000h      ; runtime $4244, stored $6004: #0051 word patch offset $00DF; whole 16-bit word += relocation delta
    defb 0e2h, 000h      ; runtime $4246, stored $6006: #0052 word patch offset $00E2; whole 16-bit word += relocation delta
    defb 0e6h, 000h      ; runtime $4248, stored $6008: #0053 word patch offset $00E6; whole 16-bit word += relocation delta
    defb 0e9h, 000h      ; runtime $424A, stored $600A: #0054 word patch offset $00E9; whole 16-bit word += relocation delta
    defb 0edh, 000h      ; runtime $424C, stored $600C: #0055 word patch offset $00ED; whole 16-bit word += relocation delta
    defb 0f3h, 000h      ; runtime $424E, stored $600E: #0056 word patch offset $00F3; whole 16-bit word += relocation delta
    defb 0f6h, 000h      ; runtime $4250, stored $6010: #0057 word patch offset $00F6; whole 16-bit word += relocation delta
    defb 0fah, 000h      ; runtime $4252, stored $6012: #0058 word patch offset $00FA; whole 16-bit word += relocation delta
    defb 013h, 001h      ; runtime $4254, stored $6014: #0059 word patch offset $0113; whole 16-bit word += relocation delta
    defb 026h, 001h      ; runtime $4256, stored $6016: #0060 word patch offset $0126; whole 16-bit word += relocation delta
    defb 02dh, 001h      ; runtime $4258, stored $6018: #0061 word patch offset $012D; whole 16-bit word += relocation delta
    defb 039h, 001h      ; runtime $425A, stored $601A: #0062 word patch offset $0139; whole 16-bit word += relocation delta
    defb 042h, 001h      ; runtime $425C, stored $601C: #0063 word patch offset $0142; whole 16-bit word += relocation delta
    defb 049h, 001h      ; runtime $425E, stored $601E: #0064 word patch offset $0149; whole 16-bit word += relocation delta
    defb 051h, 001h      ; runtime $4260, stored $6020: #0065 word patch offset $0151; whole 16-bit word += relocation delta
    defb 062h, 001h      ; runtime $4262, stored $6022: #0066 word patch offset $0162; whole 16-bit word += relocation delta
    defb 065h, 001h      ; runtime $4264, stored $6024: #0067 word patch offset $0165; whole 16-bit word += relocation delta
    defb 068h, 001h      ; runtime $4266, stored $6026: #0068 word patch offset $0168; whole 16-bit word += relocation delta
    defb 06bh, 001h      ; runtime $4268, stored $6028: #0069 word patch offset $016B; whole 16-bit word += relocation delta
    defb 072h, 001h      ; runtime $426A, stored $602A: #0070 word patch offset $0172; whole 16-bit word += relocation delta
    defb 075h, 001h      ; runtime $426C, stored $602C: #0071 word patch offset $0175; whole 16-bit word += relocation delta
    defb 078h, 001h      ; runtime $426E, stored $602E: #0072 word patch offset $0178; whole 16-bit word += relocation delta
    defb 07bh, 001h      ; runtime $4270, stored $6030: #0073 word patch offset $017B; whole 16-bit word += relocation delta
    defb 07eh, 001h      ; runtime $4272, stored $6032: #0074 word patch offset $017E; whole 16-bit word += relocation delta
    defb 08dh, 001h      ; runtime $4274, stored $6034: #0075 word patch offset $018D; whole 16-bit word += relocation delta
    defb 091h, 001h      ; runtime $4276, stored $6036: #0076 word patch offset $0191; whole 16-bit word += relocation delta
    defb 094h, 001h      ; runtime $4278, stored $6038: #0077 word patch offset $0194; whole 16-bit word += relocation delta
    defb 0a4h, 001h      ; runtime $427A, stored $603A: #0078 word patch offset $01A4; whole 16-bit word += relocation delta
    defb 0bdh, 001h      ; runtime $427C, stored $603C: #0079 word patch offset $01BD; whole 16-bit word += relocation delta
    defb 0c4h, 001h      ; runtime $427E, stored $603E: #0080 word patch offset $01C4; whole 16-bit word += relocation delta
    defb 0c8h, 001h      ; runtime $4280, stored $6040: #0081 word patch offset $01C8; whole 16-bit word += relocation delta
    defb 0cfh, 001h      ; runtime $4282, stored $6042: #0082 word patch offset $01CF; whole 16-bit word += relocation delta
    defb 0d3h, 001h      ; runtime $4284, stored $6044: #0083 word patch offset $01D3; whole 16-bit word += relocation delta
    defb 0d6h, 001h      ; runtime $4286, stored $6046: #0084 word patch offset $01D6; whole 16-bit word += relocation delta
    defb 0d9h, 001h      ; runtime $4288, stored $6048: #0085 word patch offset $01D9; whole 16-bit word += relocation delta
    defb 0deh, 001h      ; runtime $428A, stored $604A: #0086 word patch offset $01DE; whole 16-bit word += relocation delta
    defb 0e1h, 001h      ; runtime $428C, stored $604C: #0087 word patch offset $01E1; whole 16-bit word += relocation delta
    defb 0ech, 001h      ; runtime $428E, stored $604E: #0088 word patch offset $01EC; whole 16-bit word += relocation delta
    defb 0efh, 001h      ; runtime $4290, stored $6050: #0089 word patch offset $01EF; whole 16-bit word += relocation delta
    defb 0f2h, 001h      ; runtime $4292, stored $6052: #0090 word patch offset $01F2; whole 16-bit word += relocation delta
    defb 0f7h, 001h      ; runtime $4294, stored $6054: #0091 word patch offset $01F7; whole 16-bit word += relocation delta
    defb 0fbh, 001h      ; runtime $4296, stored $6056: #0092 word patch offset $01FB; whole 16-bit word += relocation delta
    defb 0feh, 001h      ; runtime $4298, stored $6058: #0093 word patch offset $01FE; whole 16-bit word += relocation delta
    defb 001h, 002h      ; runtime $429A, stored $605A: #0094 word patch offset $0201; whole 16-bit word += relocation delta
    defb 004h, 002h      ; runtime $429C, stored $605C: #0095 word patch offset $0204; whole 16-bit word += relocation delta
    defb 00bh, 002h      ; runtime $429E, stored $605E: #0096 word patch offset $020B; whole 16-bit word += relocation delta
    defb 00eh, 002h      ; runtime $42A0, stored $6060: #0097 word patch offset $020E; whole 16-bit word += relocation delta
    defb 011h, 002h      ; runtime $42A2, stored $6062: #0098 word patch offset $0211; whole 16-bit word += relocation delta
    defb 017h, 002h      ; runtime $42A4, stored $6064: #0099 word patch offset $0217; whole 16-bit word += relocation delta
    defb 01eh, 002h      ; runtime $42A6, stored $6066: #0100 word patch offset $021E; whole 16-bit word += relocation delta
    defb 025h, 002h      ; runtime $42A8, stored $6068: #0101 word patch offset $0225; whole 16-bit word += relocation delta
    defb 03ch, 002h      ; runtime $42AA, stored $606A: #0102 word patch offset $023C; whole 16-bit word += relocation delta
    defb 040h, 002h      ; runtime $42AC, stored $606C: #0103 word patch offset $0240; whole 16-bit word += relocation delta
    defb 043h, 002h      ; runtime $42AE, stored $606E: #0104 word patch offset $0243; whole 16-bit word += relocation delta
    defb 04fh, 002h      ; runtime $42B0, stored $6070: #0105 word patch offset $024F; whole 16-bit word += relocation delta
    defb 056h, 002h      ; runtime $42B2, stored $6072: #0106 word patch offset $0256; whole 16-bit word += relocation delta
    defb 059h, 002h      ; runtime $42B4, stored $6074: #0107 word patch offset $0259; whole 16-bit word += relocation delta
    defb 06bh, 002h      ; runtime $42B6, stored $6076: #0108 word patch offset $026B; whole 16-bit word += relocation delta
    defb 077h, 002h      ; runtime $42B8, stored $6078: #0109 word patch offset $0277; whole 16-bit word += relocation delta
    defb 07eh, 002h      ; runtime $42BA, stored $607A: #0110 word patch offset $027E; whole 16-bit word += relocation delta
    defb 082h, 002h      ; runtime $42BC, stored $607C: #0111 word patch offset $0282; whole 16-bit word += relocation delta
    defb 0beh, 002h      ; runtime $42BE, stored $607E: #0112 word patch offset $02BE; whole 16-bit word += relocation delta
    defb 0c4h, 002h      ; runtime $42C0, stored $6080: #0113 word patch offset $02C4; whole 16-bit word += relocation delta
    defb 0c8h, 002h      ; runtime $42C2, stored $6082: #0114 word patch offset $02C8; whole 16-bit word += relocation delta
    defb 0cbh, 002h      ; runtime $42C4, stored $6084: #0115 word patch offset $02CB; whole 16-bit word += relocation delta
    defb 0ceh, 002h      ; runtime $42C6, stored $6086: #0116 word patch offset $02CE; whole 16-bit word += relocation delta
    defb 0d1h, 002h      ; runtime $42C8, stored $6088: #0117 word patch offset $02D1; whole 16-bit word += relocation delta
    defb 0d4h, 002h      ; runtime $42CA, stored $608A: #0118 word patch offset $02D4; whole 16-bit word += relocation delta
    defb 0dbh, 002h      ; runtime $42CC, stored $608C: #0119 word patch offset $02DB; whole 16-bit word += relocation delta
    defb 0deh, 002h      ; runtime $42CE, stored $608E: #0120 word patch offset $02DE; whole 16-bit word += relocation delta
    defb 0e1h, 002h      ; runtime $42D0, stored $6090: #0121 word patch offset $02E1; whole 16-bit word += relocation delta
    defb 0e4h, 002h      ; runtime $42D2, stored $6092: #0122 word patch offset $02E4; whole 16-bit word += relocation delta
    defb 0e7h, 002h      ; runtime $42D4, stored $6094: #0123 word patch offset $02E7; whole 16-bit word += relocation delta
    defb 021h, 003h      ; runtime $42D6, stored $6096: #0124 word patch offset $0321; whole 16-bit word += relocation delta
    defb 044h, 003h      ; runtime $42D8, stored $6098: #0125 word patch offset $0344; whole 16-bit word += relocation delta
    defb 04bh, 003h      ; runtime $42DA, stored $609A: #0126 word patch offset $034B; whole 16-bit word += relocation delta
    defb 052h, 003h      ; runtime $42DC, stored $609C: #0127 word patch offset $0352; whole 16-bit word += relocation delta
    defb 059h, 003h      ; runtime $42DE, stored $609E: #0128 word patch offset $0359; whole 16-bit word += relocation delta
    defb 060h, 003h      ; runtime $42E0, stored $60A0: #0129 word patch offset $0360; whole 16-bit word += relocation delta
    defb 067h, 003h      ; runtime $42E2, stored $60A2: #0130 word patch offset $0367; whole 16-bit word += relocation delta
    defb 06eh, 003h      ; runtime $42E4, stored $60A4: #0131 word patch offset $036E; whole 16-bit word += relocation delta
    defb 075h, 003h      ; runtime $42E6, stored $60A6: #0132 word patch offset $0375; whole 16-bit word += relocation delta
    defb 07ch, 003h      ; runtime $42E8, stored $60A8: #0133 word patch offset $037C; whole 16-bit word += relocation delta
    defb 083h, 003h      ; runtime $42EA, stored $60AA: #0134 word patch offset $0383; whole 16-bit word += relocation delta
    defb 08ah, 003h      ; runtime $42EC, stored $60AC: #0135 word patch offset $038A; whole 16-bit word += relocation delta
    defb 091h, 003h      ; runtime $42EE, stored $60AE: #0136 word patch offset $0391; whole 16-bit word += relocation delta
    defb 098h, 003h      ; runtime $42F0, stored $60B0: #0137 word patch offset $0398; whole 16-bit word += relocation delta
    defb 09fh, 003h      ; runtime $42F2, stored $60B2: #0138 word patch offset $039F; whole 16-bit word += relocation delta
    defb 0a6h, 003h      ; runtime $42F4, stored $60B4: #0139 word patch offset $03A6; whole 16-bit word += relocation delta
    defb 0adh, 003h      ; runtime $42F6, stored $60B6: #0140 word patch offset $03AD; whole 16-bit word += relocation delta
    defb 0b4h, 003h      ; runtime $42F8, stored $60B8: #0141 word patch offset $03B4; whole 16-bit word += relocation delta
    defb 0bbh, 003h      ; runtime $42FA, stored $60BA: #0142 word patch offset $03BB; whole 16-bit word += relocation delta
    defb 0c2h, 003h      ; runtime $42FC, stored $60BC: #0143 word patch offset $03C2; whole 16-bit word += relocation delta
    defb 0c9h, 003h      ; runtime $42FE, stored $60BE: #0144 word patch offset $03C9; whole 16-bit word += relocation delta
    defb 0d0h, 003h      ; runtime $4300, stored $60C0: #0145 word patch offset $03D0; whole 16-bit word += relocation delta
    defb 0d7h, 003h      ; runtime $4302, stored $60C2: #0146 word patch offset $03D7; whole 16-bit word += relocation delta
    defb 0deh, 003h      ; runtime $4304, stored $60C4: #0147 word patch offset $03DE; whole 16-bit word += relocation delta
    defb 0e5h, 003h      ; runtime $4306, stored $60C6: #0148 word patch offset $03E5; whole 16-bit word += relocation delta
    defb 0ech, 003h      ; runtime $4308, stored $60C8: #0149 word patch offset $03EC; whole 16-bit word += relocation delta
    defb 0f3h, 003h      ; runtime $430A, stored $60CA: #0150 word patch offset $03F3; whole 16-bit word += relocation delta
    defb 0fah, 003h      ; runtime $430C, stored $60CC: #0151 word patch offset $03FA; whole 16-bit word += relocation delta
    defb 001h, 004h      ; runtime $430E, stored $60CE: #0152 word patch offset $0401; whole 16-bit word += relocation delta
    defb 008h, 004h      ; runtime $4310, stored $60D0: #0153 word patch offset $0408; whole 16-bit word += relocation delta
    defb 00fh, 004h      ; runtime $4312, stored $60D2: #0154 word patch offset $040F; whole 16-bit word += relocation delta
    defb 0c5h, 004h      ; runtime $4314, stored $60D4: #0155 word patch offset $04C5; whole 16-bit word += relocation delta
    defb 0cfh, 004h      ; runtime $4316, stored $60D6: #0156 word patch offset $04CF; whole 16-bit word += relocation delta
    defb 0d6h, 004h      ; runtime $4318, stored $60D8: #0157 word patch offset $04D6; whole 16-bit word += relocation delta
    defb 0d9h, 004h      ; runtime $431A, stored $60DA: #0158 word patch offset $04D9; whole 16-bit word += relocation delta
    defb 0dch, 004h      ; runtime $431C, stored $60DC: #0159 word patch offset $04DC; whole 16-bit word += relocation delta
    defb 0dfh, 004h      ; runtime $431E, stored $60DE: #0160 word patch offset $04DF; whole 16-bit word += relocation delta
    defb 0e5h, 004h      ; runtime $4320, stored $60E0: #0161 word patch offset $04E5; whole 16-bit word += relocation delta
    defb 0efh, 004h      ; runtime $4322, stored $60E2: #0162 word patch offset $04EF; whole 16-bit word += relocation delta
    defb 0fah, 004h      ; runtime $4324, stored $60E4: #0163 word patch offset $04FA; whole 16-bit word += relocation delta
    defb 0ffh, 004h      ; runtime $4326, stored $60E6: #0164 word patch offset $04FF; whole 16-bit word += relocation delta
    defb 002h, 005h      ; runtime $4328, stored $60E8: #0165 word patch offset $0502; whole 16-bit word += relocation delta
    defb 005h, 005h      ; runtime $432A, stored $60EA: #0166 word patch offset $0505; whole 16-bit word += relocation delta
    defb 008h, 005h      ; runtime $432C, stored $60EC: #0167 word patch offset $0508; whole 16-bit word += relocation delta
    defb 00bh, 005h      ; runtime $432E, stored $60EE: #0168 word patch offset $050B; whole 16-bit word += relocation delta
    defb 00eh, 005h      ; runtime $4330, stored $60F0: #0169 word patch offset $050E; whole 16-bit word += relocation delta
    defb 011h, 005h      ; runtime $4332, stored $60F2: #0170 word patch offset $0511; whole 16-bit word += relocation delta
    defb 014h, 005h      ; runtime $4334, stored $60F4: #0171 word patch offset $0514; whole 16-bit word += relocation delta
    defb 017h, 005h      ; runtime $4336, stored $60F6: #0172 word patch offset $0517; whole 16-bit word += relocation delta
    defb 01ah, 005h      ; runtime $4338, stored $60F8: #0173 word patch offset $051A; whole 16-bit word += relocation delta
    defb 01eh, 005h      ; runtime $433A, stored $60FA: #0174 word patch offset $051E; whole 16-bit word += relocation delta
    defb 021h, 005h      ; runtime $433C, stored $60FC: #0175 word patch offset $0521; whole 16-bit word += relocation delta
    defb 024h, 005h      ; runtime $433E, stored $60FE: #0176 word patch offset $0524; whole 16-bit word += relocation delta
    defb 027h, 005h      ; runtime $4340, stored $6100: #0177 word patch offset $0527; whole 16-bit word += relocation delta
    defb 02ah, 005h      ; runtime $4342, stored $6102: #0178 word patch offset $052A; whole 16-bit word += relocation delta
    defb 031h, 005h      ; runtime $4344, stored $6104: #0179 word patch offset $0531; whole 16-bit word += relocation delta
    defb 036h, 005h      ; runtime $4346, stored $6106: #0180 word patch offset $0536; whole 16-bit word += relocation delta
    defb 03bh, 005h      ; runtime $4348, stored $6108: #0181 word patch offset $053B; whole 16-bit word += relocation delta
    defb 040h, 005h      ; runtime $434A, stored $610A: #0182 word patch offset $0540; whole 16-bit word += relocation delta
    defb 045h, 005h      ; runtime $434C, stored $610C: #0183 word patch offset $0545; whole 16-bit word += relocation delta
    defb 04ah, 005h      ; runtime $434E, stored $610E: #0184 word patch offset $054A; whole 16-bit word += relocation delta
    defb 050h, 005h      ; runtime $4350, stored $6110: #0185 word patch offset $0550; whole 16-bit word += relocation delta
    defb 053h, 005h      ; runtime $4352, stored $6112: #0186 word patch offset $0553; whole 16-bit word += relocation delta
    defb 058h, 005h      ; runtime $4354, stored $6114: #0187 word patch offset $0558; whole 16-bit word += relocation delta
    defb 063h, 005h      ; runtime $4356, stored $6116: #0188 word patch offset $0563; whole 16-bit word += relocation delta
    defb 067h, 005h      ; runtime $4358, stored $6118: #0189 word patch offset $0567; whole 16-bit word += relocation delta
    defb 06bh, 005h      ; runtime $435A, stored $611A: #0190 word patch offset $056B; whole 16-bit word += relocation delta
    defb 073h, 005h      ; runtime $435C, stored $611C: #0191 word patch offset $0573; whole 16-bit word += relocation delta
    defb 077h, 005h      ; runtime $435E, stored $611E: #0192 word patch offset $0577; whole 16-bit word += relocation delta
    defb 07fh, 005h      ; runtime $4360, stored $6120: #0193 word patch offset $057F; whole 16-bit word += relocation delta
    defb 088h, 005h      ; runtime $4362, stored $6122: #0194 word patch offset $0588; whole 16-bit word += relocation delta
    defb 090h, 005h      ; runtime $4364, stored $6124: #0195 word patch offset $0590; whole 16-bit word += relocation delta
    defb 098h, 005h      ; runtime $4366, stored $6126: #0196 word patch offset $0598; whole 16-bit word += relocation delta
    defb 0a4h, 005h      ; runtime $4368, stored $6128: #0197 word patch offset $05A4; whole 16-bit word += relocation delta
    defb 0a9h, 005h      ; runtime $436A, stored $612A: #0198 word patch offset $05A9; whole 16-bit word += relocation delta
    defb 0adh, 005h      ; runtime $436C, stored $612C: #0199 word patch offset $05AD; whole 16-bit word += relocation delta
    defb 0b0h, 005h      ; runtime $436E, stored $612E: #0200 word patch offset $05B0; whole 16-bit word += relocation delta
    defb 0b3h, 005h      ; runtime $4370, stored $6130: #0201 word patch offset $05B3; whole 16-bit word += relocation delta
    defb 0b9h, 005h      ; runtime $4372, stored $6132: #0202 word patch offset $05B9; whole 16-bit word += relocation delta
    defb 0c1h, 005h      ; runtime $4374, stored $6134: #0203 word patch offset $05C1; whole 16-bit word += relocation delta
    defb 014h, 006h      ; runtime $4376, stored $6136: #0204 word patch offset $0614; whole 16-bit word += relocation delta
    defb 01ch, 006h      ; runtime $4378, stored $6138: #0205 word patch offset $061C; whole 16-bit word += relocation delta
    defb 01fh, 006h      ; runtime $437A, stored $613A: #0206 word patch offset $061F; whole 16-bit word += relocation delta
    defb 02ch, 006h      ; runtime $437C, stored $613C: #0207 word patch offset $062C; whole 16-bit word += relocation delta
    defb 02fh, 006h      ; runtime $437E, stored $613E: #0208 word patch offset $062F; whole 16-bit word += relocation delta
    defb 033h, 006h      ; runtime $4380, stored $6140: #0209 word patch offset $0633; whole 16-bit word += relocation delta
    defb 037h, 006h      ; runtime $4382, stored $6142: #0210 word patch offset $0637; whole 16-bit word += relocation delta
    defb 03dh, 006h      ; runtime $4384, stored $6144: #0211 word patch offset $063D; whole 16-bit word += relocation delta
    defb 040h, 006h      ; runtime $4386, stored $6146: #0212 word patch offset $0640; whole 16-bit word += relocation delta
    defb 043h, 006h      ; runtime $4388, stored $6148: #0213 word patch offset $0643; whole 16-bit word += relocation delta
    defb 046h, 006h      ; runtime $438A, stored $614A: #0214 word patch offset $0646; whole 16-bit word += relocation delta
    defb 049h, 006h      ; runtime $438C, stored $614C: #0215 word patch offset $0649; whole 16-bit word += relocation delta
    defb 04ch, 006h      ; runtime $438E, stored $614E: #0216 word patch offset $064C; whole 16-bit word += relocation delta
    defb 052h, 006h      ; runtime $4390, stored $6150: #0217 word patch offset $0652; whole 16-bit word += relocation delta
    defb 055h, 006h      ; runtime $4392, stored $6152: #0218 word patch offset $0655; whole 16-bit word += relocation delta
    defb 058h, 006h      ; runtime $4394, stored $6154: #0219 word patch offset $0658; whole 16-bit word += relocation delta
    defb 05dh, 006h      ; runtime $4396, stored $6156: #0220 word patch offset $065D; whole 16-bit word += relocation delta
    defb 060h, 006h      ; runtime $4398, stored $6158: #0221 word patch offset $0660; whole 16-bit word += relocation delta
    defb 063h, 006h      ; runtime $439A, stored $615A: #0222 word patch offset $0663; whole 16-bit word += relocation delta
    defb 066h, 006h      ; runtime $439C, stored $615C: #0223 word patch offset $0666; whole 16-bit word += relocation delta
    defb 069h, 006h      ; runtime $439E, stored $615E: #0224 word patch offset $0669; whole 16-bit word += relocation delta
    defb 06ch, 006h      ; runtime $43A0, stored $6160: #0225 word patch offset $066C; whole 16-bit word += relocation delta
    defb 06fh, 006h      ; runtime $43A2, stored $6162: #0226 word patch offset $066F; whole 16-bit word += relocation delta
    defb 074h, 006h      ; runtime $43A4, stored $6164: #0227 word patch offset $0674; whole 16-bit word += relocation delta
    defb 07eh, 006h      ; runtime $43A6, stored $6166: #0228 word patch offset $067E; whole 16-bit word += relocation delta
    defb 081h, 006h      ; runtime $43A8, stored $6168: #0229 word patch offset $0681; whole 16-bit word += relocation delta
    defb 08eh, 006h      ; runtime $43AA, stored $616A: #0230 word patch offset $068E; whole 16-bit word += relocation delta
    defb 093h, 006h      ; runtime $43AC, stored $616C: #0231 word patch offset $0693; whole 16-bit word += relocation delta
    defb 096h, 006h      ; runtime $43AE, stored $616E: #0232 word patch offset $0696; whole 16-bit word += relocation delta
    defb 099h, 006h      ; runtime $43B0, stored $6170: #0233 word patch offset $0699; whole 16-bit word += relocation delta
    defb 09ch, 006h      ; runtime $43B2, stored $6172: #0234 word patch offset $069C; whole 16-bit word += relocation delta
    defb 0a1h, 006h      ; runtime $43B4, stored $6174: #0235 word patch offset $06A1; whole 16-bit word += relocation delta
    defb 0a4h, 006h      ; runtime $43B6, stored $6176: #0236 word patch offset $06A4; whole 16-bit word += relocation delta
    defb 0a7h, 006h      ; runtime $43B8, stored $6178: #0237 word patch offset $06A7; whole 16-bit word += relocation delta
    defb 0b8h, 006h      ; runtime $43BA, stored $617A: #0238 word patch offset $06B8; whole 16-bit word += relocation delta
    defb 0bdh, 006h      ; runtime $43BC, stored $617C: #0239 word patch offset $06BD; whole 16-bit word += relocation delta
    defb 0cbh, 006h      ; runtime $43BE, stored $617E: #0240 word patch offset $06CB; whole 16-bit word += relocation delta
    defb 0ceh, 006h      ; runtime $43C0, stored $6180: #0241 word patch offset $06CE; whole 16-bit word += relocation delta
    defb 0dfh, 006h      ; runtime $43C2, stored $6182: #0242 word patch offset $06DF; whole 16-bit word += relocation delta
    defb 0e3h, 006h      ; runtime $43C4, stored $6184: #0243 word patch offset $06E3; whole 16-bit word += relocation delta
    defb 0e6h, 006h      ; runtime $43C6, stored $6186: #0244 word patch offset $06E6; whole 16-bit word += relocation delta
    defb 0e9h, 006h      ; runtime $43C8, stored $6188: #0245 word patch offset $06E9; whole 16-bit word += relocation delta
    defb 0ech, 006h      ; runtime $43CA, stored $618A: #0246 word patch offset $06EC; whole 16-bit word += relocation delta
    defb 0fdh, 006h      ; runtime $43CC, stored $618C: #0247 word patch offset $06FD; whole 16-bit word += relocation delta
    defb 002h, 007h      ; runtime $43CE, stored $618E: #0248 word patch offset $0702; whole 16-bit word += relocation delta
    defb 007h, 007h      ; runtime $43D0, stored $6190: #0249 word patch offset $0707; whole 16-bit word += relocation delta
    defb 00ch, 007h      ; runtime $43D2, stored $6192: #0250 word patch offset $070C; whole 16-bit word += relocation delta
    defb 015h, 007h      ; runtime $43D4, stored $6194: #0251 word patch offset $0715; whole 16-bit word += relocation delta
    defb 01ch, 007h      ; runtime $43D6, stored $6196: #0252 word patch offset $071C; whole 16-bit word += relocation delta
    defb 020h, 007h      ; runtime $43D8, stored $6198: #0253 word patch offset $0720; whole 16-bit word += relocation delta
    defb 02ch, 007h      ; runtime $43DA, stored $619A: #0254 word patch offset $072C; whole 16-bit word += relocation delta
    defb 02fh, 007h      ; runtime $43DC, stored $619C: #0255 word patch offset $072F; whole 16-bit word += relocation delta
    defb 032h, 007h      ; runtime $43DE, stored $619E: #0256 word patch offset $0732; whole 16-bit word += relocation delta
    defb 037h, 007h      ; runtime $43E0, stored $61A0: #0257 word patch offset $0737; whole 16-bit word += relocation delta
    defb 04bh, 007h      ; runtime $43E2, stored $61A2: #0258 word patch offset $074B; whole 16-bit word += relocation delta
    defb 050h, 007h      ; runtime $43E4, stored $61A4: #0259 word patch offset $0750; whole 16-bit word += relocation delta
    defb 053h, 007h      ; runtime $43E6, stored $61A6: #0260 word patch offset $0753; whole 16-bit word += relocation delta
    defb 056h, 007h      ; runtime $43E8, stored $61A8: #0261 word patch offset $0756; whole 16-bit word += relocation delta
    defb 05ah, 007h      ; runtime $43EA, stored $61AA: #0262 word patch offset $075A; whole 16-bit word += relocation delta
    defb 05eh, 007h      ; runtime $43EC, stored $61AC: #0263 word patch offset $075E; whole 16-bit word += relocation delta
    defb 062h, 007h      ; runtime $43EE, stored $61AE: #0264 word patch offset $0762; whole 16-bit word += relocation delta
    defb 065h, 007h      ; runtime $43F0, stored $61B0: #0265 word patch offset $0765; whole 16-bit word += relocation delta
    defb 069h, 007h      ; runtime $43F2, stored $61B2: #0266 word patch offset $0769; whole 16-bit word += relocation delta
    defb 07ah, 007h      ; runtime $43F4, stored $61B4: #0267 word patch offset $077A; whole 16-bit word += relocation delta
    defb 07fh, 007h      ; runtime $43F6, stored $61B6: #0268 word patch offset $077F; whole 16-bit word += relocation delta
    defb 084h, 007h      ; runtime $43F8, stored $61B8: #0269 word patch offset $0784; whole 16-bit word += relocation delta
    defb 087h, 007h      ; runtime $43FA, stored $61BA: #0270 word patch offset $0787; whole 16-bit word += relocation delta
    defb 08ah, 007h      ; runtime $43FC, stored $61BC: #0271 word patch offset $078A; whole 16-bit word += relocation delta
    defb 0a6h, 007h      ; runtime $43FE, stored $61BE: #0272 word patch offset $07A6; whole 16-bit word += relocation delta
    defb 0aah, 007h      ; runtime $4400, stored $61C0: #0273 word patch offset $07AA; whole 16-bit word += relocation delta
    defb 0adh, 007h      ; runtime $4402, stored $61C2: #0274 word patch offset $07AD; whole 16-bit word += relocation delta
    defb 0b1h, 007h      ; runtime $4404, stored $61C4: #0275 word patch offset $07B1; whole 16-bit word += relocation delta
    defb 0b4h, 007h      ; runtime $4406, stored $61C6: #0276 word patch offset $07B4; whole 16-bit word += relocation delta
    defb 0b7h, 007h      ; runtime $4408, stored $61C8: #0277 word patch offset $07B7; whole 16-bit word += relocation delta
    defb 0bah, 007h      ; runtime $440A, stored $61CA: #0278 word patch offset $07BA; whole 16-bit word += relocation delta
    defb 0bdh, 007h      ; runtime $440C, stored $61CC: #0279 word patch offset $07BD; whole 16-bit word += relocation delta
    defb 0c7h, 007h      ; runtime $440E, stored $61CE: #0280 word patch offset $07C7; whole 16-bit word += relocation delta
    defb 0d0h, 007h      ; runtime $4410, stored $61D0: #0281 word patch offset $07D0; whole 16-bit word += relocation delta
    defb 0d3h, 007h      ; runtime $4412, stored $61D2: #0282 word patch offset $07D3; whole 16-bit word += relocation delta
    defb 0e0h, 007h      ; runtime $4414, stored $61D4: #0283 word patch offset $07E0; whole 16-bit word += relocation delta
    defb 0e3h, 007h      ; runtime $4416, stored $61D6: #0284 word patch offset $07E3; whole 16-bit word += relocation delta
    defb 0e6h, 007h      ; runtime $4418, stored $61D8: #0285 word patch offset $07E6; whole 16-bit word += relocation delta
    defb 0e9h, 007h      ; runtime $441A, stored $61DA: #0286 word patch offset $07E9; whole 16-bit word += relocation delta
    defb 0ech, 007h      ; runtime $441C, stored $61DC: #0287 word patch offset $07EC; whole 16-bit word += relocation delta
    defb 0f0h, 007h      ; runtime $441E, stored $61DE: #0288 word patch offset $07F0; whole 16-bit word += relocation delta
    defb 0f3h, 007h      ; runtime $4420, stored $61E0: #0289 word patch offset $07F3; whole 16-bit word += relocation delta
    defb 0f9h, 007h      ; runtime $4422, stored $61E2: #0290 word patch offset $07F9; whole 16-bit word += relocation delta
    defb 0fch, 007h      ; runtime $4424, stored $61E4: #0291 word patch offset $07FC; whole 16-bit word += relocation delta
    defb 001h, 008h      ; runtime $4426, stored $61E6: #0292 word patch offset $0801; whole 16-bit word += relocation delta
    defb 00ah, 008h      ; runtime $4428, stored $61E8: #0293 word patch offset $080A; whole 16-bit word += relocation delta
    defb 00dh, 008h      ; runtime $442A, stored $61EA: #0294 word patch offset $080D; whole 16-bit word += relocation delta
    defb 01bh, 008h      ; runtime $442C, stored $61EC: #0295 word patch offset $081B; whole 16-bit word += relocation delta
    defb 01eh, 008h      ; runtime $442E, stored $61EE: #0296 word patch offset $081E; whole 16-bit word += relocation delta
    defb 023h, 008h      ; runtime $4430, stored $61F0: #0297 word patch offset $0823; whole 16-bit word += relocation delta
    defb 026h, 008h      ; runtime $4432, stored $61F2: #0298 word patch offset $0826; whole 16-bit word += relocation delta
    defb 02ah, 008h      ; runtime $4434, stored $61F4: #0299 word patch offset $082A; whole 16-bit word += relocation delta
    defb 02dh, 008h      ; runtime $4436, stored $61F6: #0300 word patch offset $082D; whole 16-bit word += relocation delta
    defb 032h, 008h      ; runtime $4438, stored $61F8: #0301 word patch offset $0832; whole 16-bit word += relocation delta
    defb 035h, 008h      ; runtime $443A, stored $61FA: #0302 word patch offset $0835; whole 16-bit word += relocation delta
    defb 03dh, 008h      ; runtime $443C, stored $61FC: #0303 word patch offset $083D; whole 16-bit word += relocation delta
    defb 040h, 008h      ; runtime $443E, stored $61FE: #0304 word patch offset $0840; whole 16-bit word += relocation delta
    defb 043h, 008h      ; runtime $4440, stored $6200: #0305 word patch offset $0843; whole 16-bit word += relocation delta
    defb 04ah, 008h      ; runtime $4442, stored $6202: #0306 word patch offset $084A; whole 16-bit word += relocation delta
    defb 051h, 008h      ; runtime $4444, stored $6204: #0307 word patch offset $0851; whole 16-bit word += relocation delta
    defb 056h, 008h      ; runtime $4446, stored $6206: #0308 word patch offset $0856; whole 16-bit word += relocation delta
    defb 059h, 008h      ; runtime $4448, stored $6208: #0309 word patch offset $0859; whole 16-bit word += relocation delta
    defb 05dh, 008h      ; runtime $444A, stored $620A: #0310 word patch offset $085D; whole 16-bit word += relocation delta
    defb 060h, 008h      ; runtime $444C, stored $620C: #0311 word patch offset $0860; whole 16-bit word += relocation delta
    defb 063h, 008h      ; runtime $444E, stored $620E: #0312 word patch offset $0863; whole 16-bit word += relocation delta
    defb 068h, 008h      ; runtime $4450, stored $6210: #0313 word patch offset $0868; whole 16-bit word += relocation delta
    defb 06bh, 008h      ; runtime $4452, stored $6212: #0314 word patch offset $086B; whole 16-bit word += relocation delta
    defb 06eh, 008h      ; runtime $4454, stored $6214: #0315 word patch offset $086E; whole 16-bit word += relocation delta
    defb 073h, 008h      ; runtime $4456, stored $6216: #0316 word patch offset $0873; whole 16-bit word += relocation delta
    defb 076h, 008h      ; runtime $4458, stored $6218: #0317 word patch offset $0876; whole 16-bit word += relocation delta
    defb 082h, 008h      ; runtime $445A, stored $621A: #0318 word patch offset $0882; whole 16-bit word += relocation delta
    defb 08fh, 008h      ; runtime $445C, stored $621C: #0319 word patch offset $088F; whole 16-bit word += relocation delta
    defb 096h, 008h      ; runtime $445E, stored $621E: #0320 word patch offset $0896; whole 16-bit word += relocation delta
    defb 09fh, 008h      ; runtime $4460, stored $6220: #0321 word patch offset $089F; whole 16-bit word += relocation delta
    defb 0a2h, 008h      ; runtime $4462, stored $6222: #0322 word patch offset $08A2; whole 16-bit word += relocation delta
    defb 0a5h, 008h      ; runtime $4464, stored $6224: #0323 word patch offset $08A5; whole 16-bit word += relocation delta
    defb 0aah, 008h      ; runtime $4466, stored $6226: #0324 word patch offset $08AA; whole 16-bit word += relocation delta
    defb 0afh, 008h      ; runtime $4468, stored $6228: #0325 word patch offset $08AF; whole 16-bit word += relocation delta
    defb 0bch, 008h      ; runtime $446A, stored $622A: #0326 word patch offset $08BC; whole 16-bit word += relocation delta
    defb 0c8h, 008h      ; runtime $446C, stored $622C: #0327 word patch offset $08C8; whole 16-bit word += relocation delta
    defb 0cbh, 008h      ; runtime $446E, stored $622E: #0328 word patch offset $08CB; whole 16-bit word += relocation delta
    defb 0d0h, 008h      ; runtime $4470, stored $6230: #0329 word patch offset $08D0; whole 16-bit word += relocation delta
    defb 0d3h, 008h      ; runtime $4472, stored $6232: #0330 word patch offset $08D3; whole 16-bit word += relocation delta
    defb 0d6h, 008h      ; runtime $4474, stored $6234: #0331 word patch offset $08D6; whole 16-bit word += relocation delta
    defb 0ebh, 008h      ; runtime $4476, stored $6236: #0332 word patch offset $08EB; whole 16-bit word += relocation delta
    defb 0efh, 008h      ; runtime $4478, stored $6238: #0333 word patch offset $08EF; whole 16-bit word += relocation delta
    defb 0f3h, 008h      ; runtime $447A, stored $623A: #0334 word patch offset $08F3; whole 16-bit word += relocation delta
    defb 0f7h, 008h      ; runtime $447C, stored $623C: #0335 word patch offset $08F7; whole 16-bit word += relocation delta
    defb 007h, 009h      ; runtime $447E, stored $623E: #0336 word patch offset $0907; whole 16-bit word += relocation delta
    defb 014h, 009h      ; runtime $4480, stored $6240: #0337 word patch offset $0914; whole 16-bit word += relocation delta
    defb 019h, 009h      ; runtime $4482, stored $6242: #0338 word patch offset $0919; whole 16-bit word += relocation delta
    defb 026h, 009h      ; runtime $4484, stored $6244: #0339 word patch offset $0926; whole 16-bit word += relocation delta
    defb 02bh, 009h      ; runtime $4486, stored $6246: #0340 word patch offset $092B; whole 16-bit word += relocation delta
    defb 030h, 009h      ; runtime $4488, stored $6248: #0341 word patch offset $0930; whole 16-bit word += relocation delta
    defb 034h, 009h      ; runtime $448A, stored $624A: #0342 word patch offset $0934; whole 16-bit word += relocation delta
    defb 038h, 009h      ; runtime $448C, stored $624C: #0343 word patch offset $0938; whole 16-bit word += relocation delta
    defb 03ch, 009h      ; runtime $448E, stored $624E: #0344 word patch offset $093C; whole 16-bit word += relocation delta
    defb 046h, 009h      ; runtime $4490, stored $6250: #0345 word patch offset $0946; whole 16-bit word += relocation delta
    defb 04bh, 009h      ; runtime $4492, stored $6252: #0346 word patch offset $094B; whole 16-bit word += relocation delta
    defb 063h, 009h      ; runtime $4494, stored $6254: #0347 word patch offset $0963; whole 16-bit word += relocation delta
    defb 067h, 009h      ; runtime $4496, stored $6256: #0348 word patch offset $0967; whole 16-bit word += relocation delta
    defb 074h, 009h      ; runtime $4498, stored $6258: #0349 word patch offset $0974; whole 16-bit word += relocation delta
    defb 079h, 009h      ; runtime $449A, stored $625A: #0350 word patch offset $0979; whole 16-bit word += relocation delta
    defb 088h, 009h      ; runtime $449C, stored $625C: #0351 word patch offset $0988; whole 16-bit word += relocation delta
    defb 08dh, 009h      ; runtime $449E, stored $625E: #0352 word patch offset $098D; whole 16-bit word += relocation delta
    defb 092h, 009h      ; runtime $44A0, stored $6260: #0353 word patch offset $0992; whole 16-bit word += relocation delta
    defb 09eh, 009h      ; runtime $44A2, stored $6262: #0354 word patch offset $099E; whole 16-bit word += relocation delta
    defb 0abh, 009h      ; runtime $44A4, stored $6264: #0355 word patch offset $09AB; whole 16-bit word += relocation delta
    defb 0b0h, 009h      ; runtime $44A6, stored $6266: #0356 word patch offset $09B0; whole 16-bit word += relocation delta
    defb 0c0h, 009h      ; runtime $44A8, stored $6268: #0357 word patch offset $09C0; whole 16-bit word += relocation delta
    defb 0d3h, 009h      ; runtime $44AA, stored $626A: #0358 word patch offset $09D3; whole 16-bit word += relocation delta
    defb 0eah, 009h      ; runtime $44AC, stored $626C: #0359 word patch offset $09EA; whole 16-bit word += relocation delta
    defb 0edh, 009h      ; runtime $44AE, stored $626E: #0360 word patch offset $09ED; whole 16-bit word += relocation delta
    defb 0f5h, 009h      ; runtime $44B0, stored $6270: #0361 word patch offset $09F5; whole 16-bit word += relocation delta
    defb 003h, 00ah      ; runtime $44B2, stored $6272: #0362 word patch offset $0A03; whole 16-bit word += relocation delta
    defb 008h, 00ah      ; runtime $44B4, stored $6274: #0363 word patch offset $0A08; whole 16-bit word += relocation delta
    defb 024h, 00ah      ; runtime $44B6, stored $6276: #0364 word patch offset $0A24; whole 16-bit word += relocation delta
    defb 026h, 00ah      ; runtime $44B8, stored $6278: #0365 word patch offset $0A26; whole 16-bit word += relocation delta
    defb 028h, 00ah      ; runtime $44BA, stored $627A: #0366 word patch offset $0A28; whole 16-bit word += relocation delta
    defb 02ah, 00ah      ; runtime $44BC, stored $627C: #0367 word patch offset $0A2A; whole 16-bit word += relocation delta
    defb 02ch, 00ah      ; runtime $44BE, stored $627E: #0368 word patch offset $0A2C; whole 16-bit word += relocation delta
    defb 04ah, 00ah      ; runtime $44C0, stored $6280: #0369 word patch offset $0A4A; whole 16-bit word += relocation delta
    defb 05ah, 00ah      ; runtime $44C2, stored $6282: #0370 word patch offset $0A5A; whole 16-bit word += relocation delta
    defb 05fh, 00ah      ; runtime $44C4, stored $6284: #0371 word patch offset $0A5F; whole 16-bit word += relocation delta
    defb 065h, 00ah      ; runtime $44C6, stored $6286: #0372 word patch offset $0A65; whole 16-bit word += relocation delta
    defb 068h, 00ah      ; runtime $44C8, stored $6288: #0373 word patch offset $0A68; whole 16-bit word += relocation delta
    defb 06bh, 00ah      ; runtime $44CA, stored $628A: #0374 word patch offset $0A6B; whole 16-bit word += relocation delta
    defb 06fh, 00ah      ; runtime $44CC, stored $628C: #0375 word patch offset $0A6F; whole 16-bit word += relocation delta
    defb 075h, 00ah      ; runtime $44CE, stored $628E: #0376 word patch offset $0A75; whole 16-bit word += relocation delta
    defb 078h, 00ah      ; runtime $44D0, stored $6290: #0377 word patch offset $0A78; whole 16-bit word += relocation delta
    defb 07eh, 00ah      ; runtime $44D2, stored $6292: #0378 word patch offset $0A7E; whole 16-bit word += relocation delta
    defb 081h, 00ah      ; runtime $44D4, stored $6294: #0379 word patch offset $0A81; whole 16-bit word += relocation delta
    defb 084h, 00ah      ; runtime $44D6, stored $6296: #0380 word patch offset $0A84; whole 16-bit word += relocation delta
    defb 08eh, 00ah      ; runtime $44D8, stored $6298: #0381 word patch offset $0A8E; whole 16-bit word += relocation delta
    defb 091h, 00ah      ; runtime $44DA, stored $629A: #0382 word patch offset $0A91; whole 16-bit word += relocation delta
    defb 09ch, 00ah      ; runtime $44DC, stored $629C: #0383 word patch offset $0A9C; whole 16-bit word += relocation delta
    defb 0a6h, 00ah      ; runtime $44DE, stored $629E: #0384 word patch offset $0AA6; whole 16-bit word += relocation delta
    defb 0b4h, 00ah      ; runtime $44E0, stored $62A0: #0385 word patch offset $0AB4; whole 16-bit word += relocation delta
    defb 0b7h, 00ah      ; runtime $44E2, stored $62A2: #0386 word patch offset $0AB7; whole 16-bit word += relocation delta
    defb 0bdh, 00ah      ; runtime $44E4, stored $62A4: #0387 word patch offset $0ABD; whole 16-bit word += relocation delta
    defb 0d4h, 00ah      ; runtime $44E6, stored $62A6: #0388 word patch offset $0AD4; whole 16-bit word += relocation delta
    defb 0e6h, 00ah      ; runtime $44E8, stored $62A8: #0389 word patch offset $0AE6; whole 16-bit word += relocation delta
    defb 007h, 00bh      ; runtime $44EA, stored $62AA: #0390 word patch offset $0B07; whole 16-bit word += relocation delta
    defb 026h, 00bh      ; runtime $44EC, stored $62AC: #0391 word patch offset $0B26; whole 16-bit word += relocation delta
    defb 029h, 00bh      ; runtime $44EE, stored $62AE: #0392 word patch offset $0B29; whole 16-bit word += relocation delta
    defb 02ch, 00bh      ; runtime $44F0, stored $62B0: #0393 word patch offset $0B2C; whole 16-bit word += relocation delta
    defb 030h, 00bh      ; runtime $44F2, stored $62B2: #0394 word patch offset $0B30; whole 16-bit word += relocation delta
    defb 033h, 00bh      ; runtime $44F4, stored $62B4: #0395 word patch offset $0B33; whole 16-bit word += relocation delta
    defb 039h, 00bh      ; runtime $44F6, stored $62B6: #0396 word patch offset $0B39; whole 16-bit word += relocation delta
    defb 03ch, 00bh      ; runtime $44F8, stored $62B8: #0397 word patch offset $0B3C; whole 16-bit word += relocation delta
    defb 042h, 00bh      ; runtime $44FA, stored $62BA: #0398 word patch offset $0B42; whole 16-bit word += relocation delta
    defb 045h, 00bh      ; runtime $44FC, stored $62BC: #0399 word patch offset $0B45; whole 16-bit word += relocation delta
    defb 04ah, 00bh      ; runtime $44FE, stored $62BE: #0400 word patch offset $0B4A; whole 16-bit word += relocation delta
    defb 058h, 00bh      ; runtime $4500, stored $62C0: #0401 word patch offset $0B58; whole 16-bit word += relocation delta
    defb 066h, 00bh      ; runtime $4502, stored $62C2: #0402 word patch offset $0B66; whole 16-bit word += relocation delta
    defb 06ah, 00bh      ; runtime $4504, stored $62C4: #0403 word patch offset $0B6A; whole 16-bit word += relocation delta
    defb 06dh, 00bh      ; runtime $4506, stored $62C6: #0404 word patch offset $0B6D; whole 16-bit word += relocation delta
    defb 073h, 00bh      ; runtime $4508, stored $62C8: #0405 word patch offset $0B73; whole 16-bit word += relocation delta
    defb 080h, 00bh      ; runtime $450A, stored $62CA: #0406 word patch offset $0B80; whole 16-bit word += relocation delta
    defb 08ah, 00bh      ; runtime $450C, stored $62CC: #0407 word patch offset $0B8A; whole 16-bit word += relocation delta
    defb 08eh, 00bh      ; runtime $450E, stored $62CE: #0408 word patch offset $0B8E; whole 16-bit word += relocation delta
    defb 0a1h, 00bh      ; runtime $4510, stored $62D0: #0409 word patch offset $0BA1; whole 16-bit word += relocation delta
    defb 0a8h, 00bh      ; runtime $4512, stored $62D2: #0410 word patch offset $0BA8; whole 16-bit word += relocation delta
    defb 0b0h, 00bh      ; runtime $4514, stored $62D4: #0411 word patch offset $0BB0; whole 16-bit word += relocation delta
    defb 0b3h, 00bh      ; runtime $4516, stored $62D6: #0412 word patch offset $0BB3; whole 16-bit word += relocation delta
    defb 0b7h, 00bh      ; runtime $4518, stored $62D8: #0413 word patch offset $0BB7; whole 16-bit word += relocation delta
    defb 0bbh, 00bh      ; runtime $451A, stored $62DA: #0414 word patch offset $0BBB; whole 16-bit word += relocation delta
    defb 0c7h, 00bh      ; runtime $451C, stored $62DC: #0415 word patch offset $0BC7; whole 16-bit word += relocation delta
    defb 0cah, 00bh      ; runtime $451E, stored $62DE: #0416 word patch offset $0BCA; whole 16-bit word += relocation delta
    defb 0cdh, 00bh      ; runtime $4520, stored $62E0: #0417 word patch offset $0BCD; whole 16-bit word += relocation delta
    defb 0d0h, 00bh      ; runtime $4522, stored $62E2: #0418 word patch offset $0BD0; whole 16-bit word += relocation delta
    defb 0d3h, 00bh      ; runtime $4524, stored $62E4: #0419 word patch offset $0BD3; whole 16-bit word += relocation delta
    defb 0d6h, 00bh      ; runtime $4526, stored $62E6: #0420 word patch offset $0BD6; whole 16-bit word += relocation delta
    defb 0d9h, 00bh      ; runtime $4528, stored $62E8: #0421 word patch offset $0BD9; whole 16-bit word += relocation delta
    defb 0e2h, 00bh      ; runtime $452A, stored $62EA: #0422 word patch offset $0BE2; whole 16-bit word += relocation delta
    defb 0e9h, 00bh      ; runtime $452C, stored $62EC: #0423 word patch offset $0BE9; whole 16-bit word += relocation delta
    defb 0f1h, 00bh      ; runtime $452E, stored $62EE: #0424 word patch offset $0BF1; whole 16-bit word += relocation delta
    defb 0f6h, 00bh      ; runtime $4530, stored $62F0: #0425 word patch offset $0BF6; whole 16-bit word += relocation delta
    defb 0f9h, 00bh      ; runtime $4532, stored $62F2: #0426 word patch offset $0BF9; whole 16-bit word += relocation delta
    defb 0fch, 00bh      ; runtime $4534, stored $62F4: #0427 word patch offset $0BFC; whole 16-bit word += relocation delta
    defb 001h, 00ch      ; runtime $4536, stored $62F6: #0428 word patch offset $0C01; whole 16-bit word += relocation delta
    defb 009h, 00ch      ; runtime $4538, stored $62F8: #0429 word patch offset $0C09; whole 16-bit word += relocation delta
    defb 00eh, 00ch      ; runtime $453A, stored $62FA: #0430 word patch offset $0C0E; whole 16-bit word += relocation delta
    defb 01bh, 00ch      ; runtime $453C, stored $62FC: #0431 word patch offset $0C1B; whole 16-bit word += relocation delta
    defb 01eh, 00ch      ; runtime $453E, stored $62FE: #0432 word patch offset $0C1E; whole 16-bit word += relocation delta
    defb 021h, 00ch      ; runtime $4540, stored $6300: #0433 word patch offset $0C21; whole 16-bit word += relocation delta
    defb 027h, 00ch      ; runtime $4542, stored $6302: #0434 word patch offset $0C27; whole 16-bit word += relocation delta
    defb 02ah, 00ch      ; runtime $4544, stored $6304: #0435 word patch offset $0C2A; whole 16-bit word += relocation delta
    defb 031h, 00ch      ; runtime $4546, stored $6306: #0436 word patch offset $0C31; whole 16-bit word += relocation delta
    defb 036h, 00ch      ; runtime $4548, stored $6308: #0437 word patch offset $0C36; whole 16-bit word += relocation delta
    defb 039h, 00ch      ; runtime $454A, stored $630A: #0438 word patch offset $0C39; whole 16-bit word += relocation delta
    defb 03ch, 00ch      ; runtime $454C, stored $630C: #0439 word patch offset $0C3C; whole 16-bit word += relocation delta
    defb 03fh, 00ch      ; runtime $454E, stored $630E: #0440 word patch offset $0C3F; whole 16-bit word += relocation delta
    defb 042h, 00ch      ; runtime $4550, stored $6310: #0441 word patch offset $0C42; whole 16-bit word += relocation delta
    defb 045h, 00ch      ; runtime $4552, stored $6312: #0442 word patch offset $0C45; whole 16-bit word += relocation delta
    defb 048h, 00ch      ; runtime $4554, stored $6314: #0443 word patch offset $0C48; whole 16-bit word += relocation delta
    defb 04ch, 00ch      ; runtime $4556, stored $6316: #0444 word patch offset $0C4C; whole 16-bit word += relocation delta
    defb 050h, 00ch      ; runtime $4558, stored $6318: #0445 word patch offset $0C50; whole 16-bit word += relocation delta
    defb 053h, 00ch      ; runtime $455A, stored $631A: #0446 word patch offset $0C53; whole 16-bit word += relocation delta
    defb 056h, 00ch      ; runtime $455C, stored $631C: #0447 word patch offset $0C56; whole 16-bit word += relocation delta
    defb 05ah, 00ch      ; runtime $455E, stored $631E: #0448 word patch offset $0C5A; whole 16-bit word += relocation delta
    defb 05eh, 00ch      ; runtime $4560, stored $6320: #0449 word patch offset $0C5E; whole 16-bit word += relocation delta
    defb 061h, 00ch      ; runtime $4562, stored $6322: #0450 word patch offset $0C61; whole 16-bit word += relocation delta
    defb 064h, 00ch      ; runtime $4564, stored $6324: #0451 word patch offset $0C64; whole 16-bit word += relocation delta
    defb 06ah, 00ch      ; runtime $4566, stored $6326: #0452 word patch offset $0C6A; whole 16-bit word += relocation delta
    defb 06eh, 00ch      ; runtime $4568, stored $6328: #0453 word patch offset $0C6E; whole 16-bit word += relocation delta
    defb 071h, 00ch      ; runtime $456A, stored $632A: #0454 word patch offset $0C71; whole 16-bit word += relocation delta
    defb 076h, 00ch      ; runtime $456C, stored $632C: #0455 word patch offset $0C76; whole 16-bit word += relocation delta
    defb 079h, 00ch      ; runtime $456E, stored $632E: #0456 word patch offset $0C79; whole 16-bit word += relocation delta
    defb 07dh, 00ch      ; runtime $4570, stored $6330: #0457 word patch offset $0C7D; whole 16-bit word += relocation delta
    defb 080h, 00ch      ; runtime $4572, stored $6332: #0458 word patch offset $0C80; whole 16-bit word += relocation delta
    defb 083h, 00ch      ; runtime $4574, stored $6334: #0459 word patch offset $0C83; whole 16-bit word += relocation delta
    defb 086h, 00ch      ; runtime $4576, stored $6336: #0460 word patch offset $0C86; whole 16-bit word += relocation delta
    defb 089h, 00ch      ; runtime $4578, stored $6338: #0461 word patch offset $0C89; whole 16-bit word += relocation delta
    defb 08ch, 00ch      ; runtime $457A, stored $633A: #0462 word patch offset $0C8C; whole 16-bit word += relocation delta
    defb 090h, 00ch      ; runtime $457C, stored $633C: #0463 word patch offset $0C90; whole 16-bit word += relocation delta
    defb 093h, 00ch      ; runtime $457E, stored $633E: #0464 word patch offset $0C93; whole 16-bit word += relocation delta
    defb 096h, 00ch      ; runtime $4580, stored $6340: #0465 word patch offset $0C96; whole 16-bit word += relocation delta
    defb 09fh, 00ch      ; runtime $4582, stored $6342: #0466 word patch offset $0C9F; whole 16-bit word += relocation delta
    defb 0a2h, 00ch      ; runtime $4584, stored $6344: #0467 word patch offset $0CA2; whole 16-bit word += relocation delta
    defb 0a6h, 00ch      ; runtime $4586, stored $6346: #0468 word patch offset $0CA6; whole 16-bit word += relocation delta
    defb 0abh, 00ch      ; runtime $4588, stored $6348: #0469 word patch offset $0CAB; whole 16-bit word += relocation delta
    defb 0b0h, 00ch      ; runtime $458A, stored $634A: #0470 word patch offset $0CB0; whole 16-bit word += relocation delta
    defb 0b4h, 00ch      ; runtime $458C, stored $634C: #0471 word patch offset $0CB4; whole 16-bit word += relocation delta
    defb 0b7h, 00ch      ; runtime $458E, stored $634E: #0472 word patch offset $0CB7; whole 16-bit word += relocation delta
    defb 0bbh, 00ch      ; runtime $4590, stored $6350: #0473 word patch offset $0CBB; whole 16-bit word += relocation delta
    defb 0c5h, 00ch      ; runtime $4592, stored $6352: #0474 word patch offset $0CC5; whole 16-bit word += relocation delta
    defb 0c9h, 00ch      ; runtime $4594, stored $6354: #0475 word patch offset $0CC9; whole 16-bit word += relocation delta
    defb 0cch, 00ch      ; runtime $4596, stored $6356: #0476 word patch offset $0CCC; whole 16-bit word += relocation delta
    defb 0e5h, 00ch      ; runtime $4598, stored $6358: #0477 word patch offset $0CE5; whole 16-bit word += relocation delta
    defb 0e8h, 00ch      ; runtime $459A, stored $635A: #0478 word patch offset $0CE8; whole 16-bit word += relocation delta
    defb 0ech, 00ch      ; runtime $459C, stored $635C: #0479 word patch offset $0CEC; whole 16-bit word += relocation delta
    defb 0efh, 00ch      ; runtime $459E, stored $635E: #0480 word patch offset $0CEF; whole 16-bit word += relocation delta
    defb 0fdh, 00ch      ; runtime $45A0, stored $6360: #0481 word patch offset $0CFD; whole 16-bit word += relocation delta
    defb 00fh, 00dh      ; runtime $45A2, stored $6362: #0482 word patch offset $0D0F; whole 16-bit word += relocation delta
    defb 012h, 00dh      ; runtime $45A4, stored $6364: #0483 word patch offset $0D12; whole 16-bit word += relocation delta
    defb 020h, 00dh      ; runtime $45A6, stored $6366: #0484 word patch offset $0D20; whole 16-bit word += relocation delta
    defb 046h, 00dh      ; runtime $45A8, stored $6368: #0485 word patch offset $0D46; whole 16-bit word += relocation delta
    defb 049h, 00dh      ; runtime $45AA, stored $636A: #0486 word patch offset $0D49; whole 16-bit word += relocation delta
    defb 054h, 00dh      ; runtime $45AC, stored $636C: #0487 word patch offset $0D54; whole 16-bit word += relocation delta
    defb 058h, 00dh      ; runtime $45AE, stored $636E: #0488 word patch offset $0D58; whole 16-bit word += relocation delta
    defb 05ch, 00dh      ; runtime $45B0, stored $6370: #0489 word patch offset $0D5C; whole 16-bit word += relocation delta
    defb 063h, 00dh      ; runtime $45B2, stored $6372: #0490 word patch offset $0D63; whole 16-bit word += relocation delta
    defb 068h, 00dh      ; runtime $45B4, stored $6374: #0491 word patch offset $0D68; whole 16-bit word += relocation delta
    defb 074h, 00dh      ; runtime $45B6, stored $6376: #0492 word patch offset $0D74; whole 16-bit word += relocation delta
    defb 07ah, 00dh      ; runtime $45B8, stored $6378: #0493 word patch offset $0D7A; whole 16-bit word += relocation delta
    defb 08eh, 00dh      ; runtime $45BA, stored $637A: #0494 word patch offset $0D8E; whole 16-bit word += relocation delta
    defb 092h, 00dh      ; runtime $45BC, stored $637C: #0495 word patch offset $0D92; whole 16-bit word += relocation delta
    defb 095h, 00dh      ; runtime $45BE, stored $637E: #0496 word patch offset $0D95; whole 16-bit word += relocation delta
    defb 0ach, 00dh      ; runtime $45C0, stored $6380: #0497 word patch offset $0DAC; whole 16-bit word += relocation delta
    defb 0b0h, 00dh      ; runtime $45C2, stored $6382: #0498 word patch offset $0DB0; whole 16-bit word += relocation delta
    defb 0b3h, 00dh      ; runtime $45C4, stored $6384: #0499 word patch offset $0DB3; whole 16-bit word += relocation delta
    defb 0b6h, 00dh      ; runtime $45C6, stored $6386: #0500 word patch offset $0DB6; whole 16-bit word += relocation delta
    defb 0bah, 00dh      ; runtime $45C8, stored $6388: #0501 word patch offset $0DBA; whole 16-bit word += relocation delta
    defb 0beh, 00dh      ; runtime $45CA, stored $638A: #0502 word patch offset $0DBE; whole 16-bit word += relocation delta
    defb 0c4h, 00dh      ; runtime $45CC, stored $638C: #0503 word patch offset $0DC4; whole 16-bit word += relocation delta
    defb 0d1h, 00dh      ; runtime $45CE, stored $638E: #0504 word patch offset $0DD1; whole 16-bit word += relocation delta
    defb 0d6h, 00dh      ; runtime $45D0, stored $6390: #0505 word patch offset $0DD6; whole 16-bit word += relocation delta
    defb 0dbh, 00dh      ; runtime $45D2, stored $6392: #0506 word patch offset $0DDB; whole 16-bit word += relocation delta
    defb 0ebh, 00dh      ; runtime $45D4, stored $6394: #0507 word patch offset $0DEB; whole 16-bit word += relocation delta
    defb 0f0h, 00dh      ; runtime $45D6, stored $6396: #0508 word patch offset $0DF0; whole 16-bit word += relocation delta
    defb 0f5h, 00dh      ; runtime $45D8, stored $6398: #0509 word patch offset $0DF5; whole 16-bit word += relocation delta
    defb 0fah, 00dh      ; runtime $45DA, stored $639A: #0510 word patch offset $0DFA; whole 16-bit word += relocation delta
    defb 0feh, 00dh      ; runtime $45DC, stored $639C: #0511 word patch offset $0DFE; whole 16-bit word += relocation delta
    defb 002h, 00eh      ; runtime $45DE, stored $639E: #0512 word patch offset $0E02; whole 16-bit word += relocation delta
    defb 005h, 00eh      ; runtime $45E0, stored $63A0: #0513 word patch offset $0E05; whole 16-bit word += relocation delta
    defb 009h, 00eh      ; runtime $45E2, stored $63A2: #0514 word patch offset $0E09; whole 16-bit word += relocation delta
    defb 00ch, 00eh      ; runtime $45E4, stored $63A4: #0515 word patch offset $0E0C; whole 16-bit word += relocation delta
    defb 015h, 00eh      ; runtime $45E6, stored $63A6: #0516 word patch offset $0E15; whole 16-bit word += relocation delta
    defb 01dh, 00eh      ; runtime $45E8, stored $63A8: #0517 word patch offset $0E1D; whole 16-bit word += relocation delta
    defb 024h, 00eh      ; runtime $45EA, stored $63AA: #0518 word patch offset $0E24; whole 16-bit word += relocation delta
    defb 027h, 00eh      ; runtime $45EC, stored $63AC: #0519 word patch offset $0E27; whole 16-bit word += relocation delta
    defb 02ah, 00eh      ; runtime $45EE, stored $63AE: #0520 word patch offset $0E2A; whole 16-bit word += relocation delta
    defb 035h, 00eh      ; runtime $45F0, stored $63B0: #0521 word patch offset $0E35; whole 16-bit word += relocation delta
    defb 038h, 00eh      ; runtime $45F2, stored $63B2: #0522 word patch offset $0E38; whole 16-bit word += relocation delta
    defb 049h, 00eh      ; runtime $45F4, stored $63B4: #0523 word patch offset $0E49; whole 16-bit word += relocation delta
    defb 050h, 00eh      ; runtime $45F6, stored $63B6: #0524 word patch offset $0E50; whole 16-bit word += relocation delta
    defb 061h, 00eh      ; runtime $45F8, stored $63B8: #0525 word patch offset $0E61; whole 16-bit word += relocation delta
    defb 065h, 00eh      ; runtime $45FA, stored $63BA: #0526 word patch offset $0E65; whole 16-bit word += relocation delta
    defb 068h, 00eh      ; runtime $45FC, stored $63BC: #0527 word patch offset $0E68; whole 16-bit word += relocation delta
    defb 08fh, 00eh      ; runtime $45FE, stored $63BE: #0528 word patch offset $0E8F; whole 16-bit word += relocation delta
    defb 097h, 00eh      ; runtime $4600, stored $63C0: #0529 word patch offset $0E97; whole 16-bit word += relocation delta
    defb 09ah, 00eh      ; runtime $4602, stored $63C2: #0530 word patch offset $0E9A; whole 16-bit word += relocation delta
    defb 09fh, 00eh      ; runtime $4604, stored $63C4: #0531 word patch offset $0E9F; whole 16-bit word += relocation delta
    defb 0a2h, 00eh      ; runtime $4606, stored $63C6: #0532 word patch offset $0EA2; whole 16-bit word += relocation delta
    defb 0a5h, 00eh      ; runtime $4608, stored $63C8: #0533 word patch offset $0EA5; whole 16-bit word += relocation delta
    defb 0aah, 00eh      ; runtime $460A, stored $63CA: #0534 word patch offset $0EAA; whole 16-bit word += relocation delta
    defb 0adh, 00eh      ; runtime $460C, stored $63CC: #0535 word patch offset $0EAD; whole 16-bit word += relocation delta
    defb 0b3h, 00eh      ; runtime $460E, stored $63CE: #0536 word patch offset $0EB3; whole 16-bit word += relocation delta
    defb 0b7h, 00eh      ; runtime $4610, stored $63D0: #0537 word patch offset $0EB7; whole 16-bit word += relocation delta
    defb 0bah, 00eh      ; runtime $4612, stored $63D2: #0538 word patch offset $0EBA; whole 16-bit word += relocation delta
    defb 0bdh, 00eh      ; runtime $4614, stored $63D4: #0539 word patch offset $0EBD; whole 16-bit word += relocation delta
    defb 0c0h, 00eh      ; runtime $4616, stored $63D6: #0540 word patch offset $0EC0; whole 16-bit word += relocation delta
    defb 0c4h, 00eh      ; runtime $4618, stored $63D8: #0541 word patch offset $0EC4; whole 16-bit word += relocation delta
    defb 0c7h, 00eh      ; runtime $461A, stored $63DA: #0542 word patch offset $0EC7; whole 16-bit word += relocation delta
    defb 0cdh, 00eh      ; runtime $461C, stored $63DC: #0543 word patch offset $0ECD; whole 16-bit word += relocation delta
    defb 0d0h, 00eh      ; runtime $461E, stored $63DE: #0544 word patch offset $0ED0; whole 16-bit word += relocation delta
    defb 0d4h, 00eh      ; runtime $4620, stored $63E0: #0545 word patch offset $0ED4; whole 16-bit word += relocation delta
    defb 0d7h, 00eh      ; runtime $4622, stored $63E2: #0546 word patch offset $0ED7; whole 16-bit word += relocation delta
    defb 0dah, 00eh      ; runtime $4624, stored $63E4: #0547 word patch offset $0EDA; whole 16-bit word += relocation delta
    defb 0e2h, 00eh      ; runtime $4626, stored $63E6: #0548 word patch offset $0EE2; whole 16-bit word += relocation delta
    defb 0e6h, 00eh      ; runtime $4628, stored $63E8: #0549 word patch offset $0EE6; whole 16-bit word += relocation delta
    defb 0ech, 00eh      ; runtime $462A, stored $63EA: #0550 word patch offset $0EEC; whole 16-bit word += relocation delta
    defb 0efh, 00eh      ; runtime $462C, stored $63EC: #0551 word patch offset $0EEF; whole 16-bit word += relocation delta
    defb 014h, 00fh      ; runtime $462E, stored $63EE: #0552 word patch offset $0F14; whole 16-bit word += relocation delta
    defb 017h, 00fh      ; runtime $4630, stored $63F0: #0553 word patch offset $0F17; whole 16-bit word += relocation delta
    defb 01bh, 00fh      ; runtime $4632, stored $63F2: #0554 word patch offset $0F1B; whole 16-bit word += relocation delta
    defb 01eh, 00fh      ; runtime $4634, stored $63F4: #0555 word patch offset $0F1E; whole 16-bit word += relocation delta
    defb 021h, 00fh      ; runtime $4636, stored $63F6: #0556 word patch offset $0F21; whole 16-bit word += relocation delta
    defb 02ch, 00fh      ; runtime $4638, stored $63F8: #0557 word patch offset $0F2C; whole 16-bit word += relocation delta
    defb 030h, 00fh      ; runtime $463A, stored $63FA: #0558 word patch offset $0F30; whole 16-bit word += relocation delta
    defb 034h, 00fh      ; runtime $463C, stored $63FC: #0559 word patch offset $0F34; whole 16-bit word += relocation delta
    defb 038h, 00fh      ; runtime $463E, stored $63FE: #0560 word patch offset $0F38; whole 16-bit word += relocation delta
    defb 03dh, 00fh      ; runtime $4640, stored $6400: #0561 word patch offset $0F3D; whole 16-bit word += relocation delta
    defb 049h, 00fh      ; runtime $4642, stored $6402: #0562 word patch offset $0F49; whole 16-bit word += relocation delta
    defb 04dh, 00fh      ; runtime $4644, stored $6404: #0563 word patch offset $0F4D; whole 16-bit word += relocation delta
    defb 05fh, 00fh      ; runtime $4646, stored $6406: #0564 word patch offset $0F5F; whole 16-bit word += relocation delta
    defb 073h, 00fh      ; runtime $4648, stored $6408: #0565 word patch offset $0F73; whole 16-bit word += relocation delta
    defb 07bh, 00fh      ; runtime $464A, stored $640A: #0566 word patch offset $0F7B; whole 16-bit word += relocation delta
    defb 07fh, 00fh      ; runtime $464C, stored $640C: #0567 word patch offset $0F7F; whole 16-bit word += relocation delta
    defb 083h, 00fh      ; runtime $464E, stored $640E: #0568 word patch offset $0F83; whole 16-bit word += relocation delta
    defb 086h, 00fh      ; runtime $4650, stored $6410: #0569 word patch offset $0F86; whole 16-bit word += relocation delta
    defb 08bh, 00fh      ; runtime $4652, stored $6412: #0570 word patch offset $0F8B; whole 16-bit word += relocation delta
    defb 08eh, 00fh      ; runtime $4654, stored $6414: #0571 word patch offset $0F8E; whole 16-bit word += relocation delta
    defb 094h, 00fh      ; runtime $4656, stored $6416: #0572 word patch offset $0F94; whole 16-bit word += relocation delta
    defb 09ch, 00fh      ; runtime $4658, stored $6418: #0573 word patch offset $0F9C; whole 16-bit word += relocation delta
    defb 0abh, 00fh      ; runtime $465A, stored $641A: #0574 word patch offset $0FAB; whole 16-bit word += relocation delta
    defb 0b0h, 00fh      ; runtime $465C, stored $641C: #0575 word patch offset $0FB0; whole 16-bit word += relocation delta
    defb 0cah, 00fh      ; runtime $465E, stored $641E: #0576 word patch offset $0FCA; whole 16-bit word += relocation delta
    defb 0cfh, 00fh      ; runtime $4660, stored $6420: #0577 word patch offset $0FCF; whole 16-bit word += relocation delta
    defb 0d6h, 00fh      ; runtime $4662, stored $6422: #0578 word patch offset $0FD6; whole 16-bit word += relocation delta
    defb 0f6h, 00fh      ; runtime $4664, stored $6424: #0579 word patch offset $0FF6; whole 16-bit word += relocation delta
    defb 0fbh, 00fh      ; runtime $4666, stored $6426: #0580 word patch offset $0FFB; whole 16-bit word += relocation delta
    defb 004h, 010h      ; runtime $4668, stored $6428: #0581 word patch offset $1004; whole 16-bit word += relocation delta
    defb 00bh, 010h      ; runtime $466A, stored $642A: #0582 word patch offset $100B; whole 16-bit word += relocation delta
    defb 011h, 010h      ; runtime $466C, stored $642C: #0583 word patch offset $1011; whole 16-bit word += relocation delta
    defb 016h, 010h      ; runtime $466E, stored $642E: #0584 word patch offset $1016; whole 16-bit word += relocation delta
    defb 020h, 010h      ; runtime $4670, stored $6430: #0585 word patch offset $1020; whole 16-bit word += relocation delta
    defb 028h, 010h      ; runtime $4672, stored $6432: #0586 word patch offset $1028; whole 16-bit word += relocation delta
    defb 02bh, 010h      ; runtime $4674, stored $6434: #0587 word patch offset $102B; whole 16-bit word += relocation delta
    defb 02fh, 010h      ; runtime $4676, stored $6436: #0588 word patch offset $102F; whole 16-bit word += relocation delta
    defb 033h, 010h      ; runtime $4678, stored $6438: #0589 word patch offset $1033; whole 16-bit word += relocation delta
    defb 036h, 010h      ; runtime $467A, stored $643A: #0590 word patch offset $1036; whole 16-bit word += relocation delta
    defb 03ch, 010h      ; runtime $467C, stored $643C: #0591 word patch offset $103C; whole 16-bit word += relocation delta
    defb 041h, 010h      ; runtime $467E, stored $643E: #0592 word patch offset $1041; whole 16-bit word += relocation delta
    defb 049h, 010h      ; runtime $4680, stored $6440: #0593 word patch offset $1049; whole 16-bit word += relocation delta
    defb 054h, 010h      ; runtime $4682, stored $6442: #0594 word patch offset $1054; whole 16-bit word += relocation delta
    defb 065h, 010h      ; runtime $4684, stored $6444: #0595 word patch offset $1065; whole 16-bit word += relocation delta
    defb 07ah, 010h      ; runtime $4686, stored $6446: #0596 word patch offset $107A; whole 16-bit word += relocation delta
    defb 084h, 010h      ; runtime $4688, stored $6448: #0597 word patch offset $1084; whole 16-bit word += relocation delta
    defb 013h, 011h      ; runtime $468A, stored $644A: #0598 word patch offset $1113; whole 16-bit word += relocation delta
    defb 017h, 011h      ; runtime $468C, stored $644C: #0599 word patch offset $1117; whole 16-bit word += relocation delta
    defb 01fh, 011h      ; runtime $468E, stored $644E: #0600 word patch offset $111F; whole 16-bit word += relocation delta
    defb 023h, 011h      ; runtime $4690, stored $6450: #0601 word patch offset $1123; whole 16-bit word += relocation delta
    defb 031h, 011h      ; runtime $4692, stored $6452: #0602 word patch offset $1131; whole 16-bit word += relocation delta
    defb 034h, 011h      ; runtime $4694, stored $6454: #0603 word patch offset $1134; whole 16-bit word += relocation delta
    defb 03fh, 011h      ; runtime $4696, stored $6456: #0604 word patch offset $113F; whole 16-bit word += relocation delta
    defb 044h, 011h      ; runtime $4698, stored $6458: #0605 word patch offset $1144; whole 16-bit word += relocation delta
    defb 04ah, 011h      ; runtime $469A, stored $645A: #0606 word patch offset $114A; whole 16-bit word += relocation delta
    defb 052h, 011h      ; runtime $469C, stored $645C: #0607 word patch offset $1152; whole 16-bit word += relocation delta
    defb 056h, 011h      ; runtime $469E, stored $645E: #0608 word patch offset $1156; whole 16-bit word += relocation delta
    defb 082h, 011h      ; runtime $46A0, stored $6460: #0609 word patch offset $1182; whole 16-bit word += relocation delta
    defb 08ah, 011h      ; runtime $46A2, stored $6462: #0610 word patch offset $118A; whole 16-bit word += relocation delta
    defb 08eh, 011h      ; runtime $46A4, stored $6464: #0611 word patch offset $118E; whole 16-bit word += relocation delta
    defb 0a8h, 011h      ; runtime $46A6, stored $6466: #0612 word patch offset $11A8; whole 16-bit word += relocation delta
    defb 0ach, 011h      ; runtime $46A8, stored $6468: #0613 word patch offset $11AC; whole 16-bit word += relocation delta
    defb 0b3h, 011h      ; runtime $46AA, stored $646A: #0614 word patch offset $11B3; whole 16-bit word += relocation delta
    defb 0b8h, 011h      ; runtime $46AC, stored $646C: #0615 word patch offset $11B8; whole 16-bit word += relocation delta
    defb 0c1h, 011h      ; runtime $46AE, stored $646E: #0616 word patch offset $11C1; whole 16-bit word += relocation delta
    defb 0c4h, 011h      ; runtime $46B0, stored $6470: #0617 word patch offset $11C4; whole 16-bit word += relocation delta
    defb 0cah, 011h      ; runtime $46B2, stored $6472: #0618 word patch offset $11CA; whole 16-bit word += relocation delta
    defb 0d1h, 011h      ; runtime $46B4, stored $6474: #0619 word patch offset $11D1; whole 16-bit word += relocation delta
    defb 0d4h, 011h      ; runtime $46B6, stored $6476: #0620 word patch offset $11D4; whole 16-bit word += relocation delta
    defb 0ddh, 011h      ; runtime $46B8, stored $6478: #0621 word patch offset $11DD; whole 16-bit word += relocation delta
    defb 0f4h, 011h      ; runtime $46BA, stored $647A: #0622 word patch offset $11F4; whole 16-bit word += relocation delta
    defb 01eh, 012h      ; runtime $46BC, stored $647C: #0623 word patch offset $121E; whole 16-bit word += relocation delta
    defb 026h, 012h      ; runtime $46BE, stored $647E: #0624 word patch offset $1226; whole 16-bit word += relocation delta
    defb 029h, 012h      ; runtime $46C0, stored $6480: #0625 word patch offset $1229; whole 16-bit word += relocation delta
    defb 02eh, 012h      ; runtime $46C2, stored $6482: #0626 word patch offset $122E; whole 16-bit word += relocation delta
    defb 031h, 012h      ; runtime $46C4, stored $6484: #0627 word patch offset $1231; whole 16-bit word += relocation delta
    defb 038h, 012h      ; runtime $46C6, stored $6486: #0628 word patch offset $1238; whole 16-bit word += relocation delta
    defb 055h, 012h      ; runtime $46C8, stored $6488: #0629 word patch offset $1255; whole 16-bit word += relocation delta
    defb 06fh, 012h      ; runtime $46CA, stored $648A: #0630 word patch offset $126F; whole 16-bit word += relocation delta
    defb 07ch, 012h      ; runtime $46CC, stored $648C: #0631 word patch offset $127C; whole 16-bit word += relocation delta
    defb 083h, 012h      ; runtime $46CE, stored $648E: #0632 word patch offset $1283; whole 16-bit word += relocation delta
    defb 0b0h, 012h      ; runtime $46D0, stored $6490: #0633 word patch offset $12B0; whole 16-bit word += relocation delta
    defb 0dah, 012h      ; runtime $46D2, stored $6492: #0634 word patch offset $12DA; whole 16-bit word += relocation delta
    defb 0deh, 012h      ; runtime $46D4, stored $6494: #0635 word patch offset $12DE; whole 16-bit word += relocation delta
    defb 0e6h, 012h      ; runtime $46D6, stored $6496: #0636 word patch offset $12E6; whole 16-bit word += relocation delta
    defb 0ebh, 012h      ; runtime $46D8, stored $6498: #0637 word patch offset $12EB; whole 16-bit word += relocation delta
    defb 0efh, 012h      ; runtime $46DA, stored $649A: #0638 word patch offset $12EF; whole 16-bit word += relocation delta
    defb 0fdh, 012h      ; runtime $46DC, stored $649C: #0639 word patch offset $12FD; whole 16-bit word += relocation delta
    defb 002h, 013h      ; runtime $46DE, stored $649E: #0640 word patch offset $1302; whole 16-bit word += relocation delta
    defb 007h, 013h      ; runtime $46E0, stored $64A0: #0641 word patch offset $1307; whole 16-bit word += relocation delta
    defb 013h, 013h      ; runtime $46E2, stored $64A2: #0642 word patch offset $1313; whole 16-bit word += relocation delta
    defb 016h, 013h      ; runtime $46E4, stored $64A4: #0643 word patch offset $1316; whole 16-bit word += relocation delta
    defb 037h, 013h      ; runtime $46E6, stored $64A6: #0644 word patch offset $1337; whole 16-bit word += relocation delta
    defb 03ch, 013h      ; runtime $46E8, stored $64A8: #0645 word patch offset $133C; whole 16-bit word += relocation delta
    defb 045h, 013h      ; runtime $46EA, stored $64AA: #0646 word patch offset $1345; whole 16-bit word += relocation delta
    defb 048h, 013h      ; runtime $46EC, stored $64AC: #0647 word patch offset $1348; whole 16-bit word += relocation delta
    defb 060h, 013h      ; runtime $46EE, stored $64AE: #0648 word patch offset $1360; whole 16-bit word += relocation delta
    defb 074h, 013h      ; runtime $46F0, stored $64B0: #0649 word patch offset $1374; whole 16-bit word += relocation delta
    defb 081h, 013h      ; runtime $46F2, stored $64B2: #0650 word patch offset $1381; whole 16-bit word += relocation delta
    defb 096h, 013h      ; runtime $46F4, stored $64B4: #0651 word patch offset $1396; whole 16-bit word += relocation delta
    defb 099h, 013h      ; runtime $46F6, stored $64B6: #0652 word patch offset $1399; whole 16-bit word += relocation delta
    defb 09dh, 013h      ; runtime $46F8, stored $64B8: #0653 word patch offset $139D; whole 16-bit word += relocation delta
    defb 0a7h, 013h      ; runtime $46FA, stored $64BA: #0654 word patch offset $13A7; whole 16-bit word += relocation delta
    defb 0bdh, 013h      ; runtime $46FC, stored $64BC: #0655 word patch offset $13BD; whole 16-bit word += relocation delta
    defb 0cah, 013h      ; runtime $46FE, stored $64BE: #0656 word patch offset $13CA; whole 16-bit word += relocation delta
    defb 0cdh, 013h      ; runtime $4700, stored $64C0: #0657 word patch offset $13CD; whole 16-bit word += relocation delta
    defb 0d6h, 013h      ; runtime $4702, stored $64C2: #0658 word patch offset $13D6; whole 16-bit word += relocation delta
    defb 0dfh, 013h      ; runtime $4704, stored $64C4: #0659 word patch offset $13DF; whole 16-bit word += relocation delta
    defb 0e2h, 013h      ; runtime $4706, stored $64C6: #0660 word patch offset $13E2; whole 16-bit word += relocation delta
    defb 0f1h, 013h      ; runtime $4708, stored $64C8: #0661 word patch offset $13F1; whole 16-bit word += relocation delta
    defb 006h, 014h      ; runtime $470A, stored $64CA: #0662 word patch offset $1406; whole 16-bit word += relocation delta
    defb 00ah, 014h      ; runtime $470C, stored $64CC: #0663 word patch offset $140A; whole 16-bit word += relocation delta
    defb 00fh, 014h      ; runtime $470E, stored $64CE: #0664 word patch offset $140F; whole 16-bit word += relocation delta
    defb 012h, 014h      ; runtime $4710, stored $64D0: #0665 word patch offset $1412; whole 16-bit word += relocation delta
    defb 016h, 014h      ; runtime $4712, stored $64D2: #0666 word patch offset $1416; whole 16-bit word += relocation delta
    defb 019h, 014h      ; runtime $4714, stored $64D4: #0667 word patch offset $1419; whole 16-bit word += relocation delta
    defb 01dh, 014h      ; runtime $4716, stored $64D6: #0668 word patch offset $141D; whole 16-bit word += relocation delta
    defb 022h, 014h      ; runtime $4718, stored $64D8: #0669 word patch offset $1422; whole 16-bit word += relocation delta
    defb 033h, 014h      ; runtime $471A, stored $64DA: #0670 word patch offset $1433; whole 16-bit word += relocation delta
    defb 039h, 014h      ; runtime $471C, stored $64DC: #0671 word patch offset $1439; whole 16-bit word += relocation delta
    defb 058h, 014h      ; runtime $471E, stored $64DE: #0672 word patch offset $1458; whole 16-bit word += relocation delta
    defb 05dh, 014h      ; runtime $4720, stored $64E0: #0673 word patch offset $145D; whole 16-bit word += relocation delta
    defb 062h, 014h      ; runtime $4722, stored $64E2: #0674 word patch offset $1462; whole 16-bit word += relocation delta
    defb 065h, 014h      ; runtime $4724, stored $64E4: #0675 word patch offset $1465; whole 16-bit word += relocation delta
    defb 06ah, 014h      ; runtime $4726, stored $64E6: #0676 word patch offset $146A; whole 16-bit word += relocation delta
    defb 06dh, 014h      ; runtime $4728, stored $64E8: #0677 word patch offset $146D; whole 16-bit word += relocation delta
    defb 072h, 014h      ; runtime $472A, stored $64EA: #0678 word patch offset $1472; whole 16-bit word += relocation delta
    defb 07bh, 014h      ; runtime $472C, stored $64EC: #0679 word patch offset $147B; whole 16-bit word += relocation delta
    defb 080h, 014h      ; runtime $472E, stored $64EE: #0680 word patch offset $1480; whole 16-bit word += relocation delta
    defb 083h, 014h      ; runtime $4730, stored $64F0: #0681 word patch offset $1483; whole 16-bit word += relocation delta
    defb 086h, 014h      ; runtime $4732, stored $64F2: #0682 word patch offset $1486; whole 16-bit word += relocation delta
    defb 08ch, 014h      ; runtime $4734, stored $64F4: #0683 word patch offset $148C; whole 16-bit word += relocation delta
    defb 093h, 014h      ; runtime $4736, stored $64F6: #0684 word patch offset $1493; whole 16-bit word += relocation delta
    defb 09fh, 014h      ; runtime $4738, stored $64F8: #0685 word patch offset $149F; whole 16-bit word += relocation delta
    defb 0a6h, 014h      ; runtime $473A, stored $64FA: #0686 word patch offset $14A6; whole 16-bit word += relocation delta
    defb 0abh, 014h      ; runtime $473C, stored $64FC: #0687 word patch offset $14AB; whole 16-bit word += relocation delta
    defb 0bbh, 014h      ; runtime $473E, stored $64FE: #0688 word patch offset $14BB; whole 16-bit word += relocation delta
    defb 0c0h, 014h      ; runtime $4740, stored $6500: #0689 word patch offset $14C0; whole 16-bit word += relocation delta
    defb 0cah, 014h      ; runtime $4742, stored $6502: #0690 word patch offset $14CA; whole 16-bit word += relocation delta
    defb 0d0h, 014h      ; runtime $4744, stored $6504: #0691 word patch offset $14D0; whole 16-bit word += relocation delta
    defb 0d3h, 014h      ; runtime $4746, stored $6506: #0692 word patch offset $14D3; whole 16-bit word += relocation delta
    defb 0d9h, 014h      ; runtime $4748, stored $6508: #0693 word patch offset $14D9; whole 16-bit word += relocation delta
    defb 0e0h, 014h      ; runtime $474A, stored $650A: #0694 word patch offset $14E0; whole 16-bit word += relocation delta
    defb 0a9h, 016h      ; runtime $474C, stored $650C: #0695 word patch offset $16A9; whole 16-bit word += relocation delta
    defb 0abh, 016h      ; runtime $474E, stored $650E: #0696 word patch offset $16AB; whole 16-bit word += relocation delta
    defb 0adh, 016h      ; runtime $4750, stored $6510: #0697 word patch offset $16AD; whole 16-bit word += relocation delta
    defb 0afh, 016h      ; runtime $4752, stored $6512: #0698 word patch offset $16AF; whole 16-bit word += relocation delta
    defb 0b1h, 016h      ; runtime $4754, stored $6514: #0699 word patch offset $16B1; whole 16-bit word += relocation delta
    defb 0b3h, 016h      ; runtime $4756, stored $6516: #0700 word patch offset $16B3; whole 16-bit word += relocation delta
    defb 0b5h, 016h      ; runtime $4758, stored $6518: #0701 word patch offset $16B5; whole 16-bit word += relocation delta
    defb 0b7h, 016h      ; runtime $475A, stored $651A: #0702 word patch offset $16B7; whole 16-bit word += relocation delta
    defb 0b9h, 016h      ; runtime $475C, stored $651C: #0703 word patch offset $16B9; whole 16-bit word += relocation delta
    defb 0bbh, 016h      ; runtime $475E, stored $651E: #0704 word patch offset $16BB; whole 16-bit word += relocation delta
    defb 0bdh, 016h      ; runtime $4760, stored $6520: #0705 word patch offset $16BD; whole 16-bit word += relocation delta
    defb 0bfh, 016h      ; runtime $4762, stored $6522: #0706 word patch offset $16BF; whole 16-bit word += relocation delta
    defb 0c1h, 016h      ; runtime $4764, stored $6524: #0707 word patch offset $16C1; whole 16-bit word += relocation delta
    defb 0c3h, 016h      ; runtime $4766, stored $6526: #0708 word patch offset $16C3; whole 16-bit word += relocation delta
    defb 0c9h, 016h      ; runtime $4768, stored $6528: #0709 word patch offset $16C9; whole 16-bit word += relocation delta
    defb 0cbh, 016h      ; runtime $476A, stored $652A: #0710 word patch offset $16CB; whole 16-bit word += relocation delta
    defb 0cdh, 016h      ; runtime $476C, stored $652C: #0711 word patch offset $16CD; whole 16-bit word += relocation delta
    defb 0cfh, 016h      ; runtime $476E, stored $652E: #0712 word patch offset $16CF; whole 16-bit word += relocation delta
    defb 0d1h, 016h      ; runtime $4770, stored $6530: #0713 word patch offset $16D1; whole 16-bit word += relocation delta
    defb 0d3h, 016h      ; runtime $4772, stored $6532: #0714 word patch offset $16D3; whole 16-bit word += relocation delta
    defb 0d5h, 016h      ; runtime $4774, stored $6534: #0715 word patch offset $16D5; whole 16-bit word += relocation delta
    defb 0d7h, 016h      ; runtime $4776, stored $6536: #0716 word patch offset $16D7; whole 16-bit word += relocation delta
    defb 0d9h, 016h      ; runtime $4778, stored $6538: #0717 word patch offset $16D9; whole 16-bit word += relocation delta
    defb 0dbh, 016h      ; runtime $477A, stored $653A: #0718 word patch offset $16DB; whole 16-bit word += relocation delta
    defb 0ddh, 016h      ; runtime $477C, stored $653C: #0719 word patch offset $16DD; whole 16-bit word += relocation delta
    defb 0e0h, 016h      ; runtime $477E, stored $653E: #0720 word patch offset $16E0; whole 16-bit word += relocation delta
    defb 0e3h, 016h      ; runtime $4780, stored $6540: #0721 word patch offset $16E3; whole 16-bit word += relocation delta
    defb 0e7h, 016h      ; runtime $4782, stored $6542: #0722 word patch offset $16E7; whole 16-bit word += relocation delta
    defb 0eah, 016h      ; runtime $4784, stored $6544: #0723 word patch offset $16EA; whole 16-bit word += relocation delta
    defb 0efh, 016h      ; runtime $4786, stored $6546: #0724 word patch offset $16EF; whole 16-bit word += relocation delta
    defb 0f7h, 016h      ; runtime $4788, stored $6548: #0725 word patch offset $16F7; whole 16-bit word += relocation delta
    defb 0fah, 016h      ; runtime $478A, stored $654A: #0726 word patch offset $16FA; whole 16-bit word += relocation delta
    defb 0feh, 016h      ; runtime $478C, stored $654C: #0727 word patch offset $16FE; whole 16-bit word += relocation delta
    defb 001h, 017h      ; runtime $478E, stored $654E: #0728 word patch offset $1701; whole 16-bit word += relocation delta
    defb 007h, 017h      ; runtime $4790, stored $6550: #0729 word patch offset $1707; whole 16-bit word += relocation delta
    defb 011h, 017h      ; runtime $4792, stored $6552: #0730 word patch offset $1711; whole 16-bit word += relocation delta
    defb 016h, 017h      ; runtime $4794, stored $6554: #0731 word patch offset $1716; whole 16-bit word += relocation delta
    defb 019h, 017h      ; runtime $4796, stored $6556: #0732 word patch offset $1719; whole 16-bit word += relocation delta
    defb 020h, 017h      ; runtime $4798, stored $6558: #0733 word patch offset $1720; whole 16-bit word += relocation delta
    defb 027h, 017h      ; runtime $479A, stored $655A: #0734 word patch offset $1727; whole 16-bit word += relocation delta
    defb 02ch, 017h      ; runtime $479C, stored $655C: #0735 word patch offset $172C; whole 16-bit word += relocation delta
    defb 031h, 017h      ; runtime $479E, stored $655E: #0736 word patch offset $1731; whole 16-bit word += relocation delta
    defb 03bh, 017h      ; runtime $47A0, stored $6560: #0737 word patch offset $173B; whole 16-bit word += relocation delta
    defb 040h, 017h      ; runtime $47A2, stored $6562: #0738 word patch offset $1740; whole 16-bit word += relocation delta
    defb 046h, 017h      ; runtime $47A4, stored $6564: #0739 word patch offset $1746; whole 16-bit word += relocation delta
    defb 04eh, 017h      ; runtime $47A6, stored $6566: #0740 word patch offset $174E; whole 16-bit word += relocation delta
    defb 057h, 017h      ; runtime $47A8, stored $6568: #0741 word patch offset $1757; whole 16-bit word += relocation delta
    defb 05eh, 017h      ; runtime $47AA, stored $656A: #0742 word patch offset $175E; whole 16-bit word += relocation delta
    defb 063h, 017h      ; runtime $47AC, stored $656C: #0743 word patch offset $1763; whole 16-bit word += relocation delta
    defb 06bh, 017h      ; runtime $47AE, stored $656E: #0744 word patch offset $176B; whole 16-bit word += relocation delta
    defb 073h, 017h      ; runtime $47B0, stored $6570: #0745 word patch offset $1773; whole 16-bit word += relocation delta
    defb 07ch, 017h      ; runtime $47B2, stored $6572: #0746 word patch offset $177C; whole 16-bit word += relocation delta
    defb 07fh, 017h      ; runtime $47B4, stored $6574: #0747 word patch offset $177F; whole 16-bit word += relocation delta
    defb 082h, 017h      ; runtime $47B6, stored $6576: #0748 word patch offset $1782; whole 16-bit word += relocation delta
    defb 08bh, 017h      ; runtime $47B8, stored $6578: #0749 word patch offset $178B; whole 16-bit word += relocation delta
    defb 094h, 017h      ; runtime $47BA, stored $657A: #0750 word patch offset $1794; whole 16-bit word += relocation delta
    defb 097h, 017h      ; runtime $47BC, stored $657C: #0751 word patch offset $1797; whole 16-bit word += relocation delta
    defb 09ah, 017h      ; runtime $47BE, stored $657E: #0752 word patch offset $179A; whole 16-bit word += relocation delta
    defb 09eh, 017h      ; runtime $47C0, stored $6580: #0753 word patch offset $179E; whole 16-bit word += relocation delta
    defb 0a2h, 017h      ; runtime $47C2, stored $6582: #0754 word patch offset $17A2; whole 16-bit word += relocation delta
    defb 0a5h, 017h      ; runtime $47C4, stored $6584: #0755 word patch offset $17A5; whole 16-bit word += relocation delta
    defb 0a8h, 017h      ; runtime $47C6, stored $6586: #0756 word patch offset $17A8; whole 16-bit word += relocation delta
    defb 0abh, 017h      ; runtime $47C8, stored $6588: #0757 word patch offset $17AB; whole 16-bit word += relocation delta
    defb 0b7h, 017h      ; runtime $47CA, stored $658A: #0758 word patch offset $17B7; whole 16-bit word += relocation delta
    defb 0bdh, 017h      ; runtime $47CC, stored $658C: #0759 word patch offset $17BD; whole 16-bit word += relocation delta
    defb 0c3h, 017h      ; runtime $47CE, stored $658E: #0760 word patch offset $17C3; whole 16-bit word += relocation delta
    defb 0c9h, 017h      ; runtime $47D0, stored $6590: #0761 word patch offset $17C9; whole 16-bit word += relocation delta
    defb 0cdh, 017h      ; runtime $47D2, stored $6592: #0762 word patch offset $17CD; whole 16-bit word += relocation delta
    defb 0d6h, 017h      ; runtime $47D4, stored $6594: #0763 word patch offset $17D6; whole 16-bit word += relocation delta
    defb 0ddh, 017h      ; runtime $47D6, stored $6596: #0764 word patch offset $17DD; whole 16-bit word += relocation delta
    defb 0e4h, 017h      ; runtime $47D8, stored $6598: #0765 word patch offset $17E4; whole 16-bit word += relocation delta
    defb 0edh, 017h      ; runtime $47DA, stored $659A: #0766 word patch offset $17ED; whole 16-bit word += relocation delta
    defb 0f0h, 017h      ; runtime $47DC, stored $659C: #0767 word patch offset $17F0; whole 16-bit word += relocation delta
    defb 0f3h, 017h      ; runtime $47DE, stored $659E: #0768 word patch offset $17F3; whole 16-bit word += relocation delta
    defb 0f6h, 017h      ; runtime $47E0, stored $65A0: #0769 word patch offset $17F6; whole 16-bit word += relocation delta
    defb 0f9h, 017h      ; runtime $47E2, stored $65A2: #0770 word patch offset $17F9; whole 16-bit word += relocation delta
    defb 0fch, 017h      ; runtime $47E4, stored $65A4: #0771 word patch offset $17FC; whole 16-bit word += relocation delta
    defb 0ffh, 017h      ; runtime $47E6, stored $65A6: #0772 word patch offset $17FF; whole 16-bit word += relocation delta
    defb 002h, 018h      ; runtime $47E8, stored $65A8: #0773 word patch offset $1802; whole 16-bit word += relocation delta
    defb 005h, 018h      ; runtime $47EA, stored $65AA: #0774 word patch offset $1805; whole 16-bit word += relocation delta
    defb 00ah, 018h      ; runtime $47EC, stored $65AC: #0775 word patch offset $180A; whole 16-bit word += relocation delta
    defb 010h, 018h      ; runtime $47EE, stored $65AE: #0776 word patch offset $1810; whole 16-bit word += relocation delta
    defb 014h, 018h      ; runtime $47F0, stored $65B0: #0777 word patch offset $1814; whole 16-bit word += relocation delta
    defb 017h, 018h      ; runtime $47F2, stored $65B2: #0778 word patch offset $1817; whole 16-bit word += relocation delta
    defb 01ah, 018h      ; runtime $47F4, stored $65B4: #0779 word patch offset $181A; whole 16-bit word += relocation delta
    defb 021h, 018h      ; runtime $47F6, stored $65B6: #0780 word patch offset $1821; whole 16-bit word += relocation delta
    defb 02ch, 018h      ; runtime $47F8, stored $65B8: #0781 word patch offset $182C; whole 16-bit word += relocation delta
    defb 02fh, 018h      ; runtime $47FA, stored $65BA: #0782 word patch offset $182F; whole 16-bit word += relocation delta
    defb 032h, 018h      ; runtime $47FC, stored $65BC: #0783 word patch offset $1832; whole 16-bit word += relocation delta
    defb 035h, 018h      ; runtime $47FE, stored $65BE: #0784 word patch offset $1835; whole 16-bit word += relocation delta
    defb 038h, 018h      ; runtime $4800, stored $65C0: #0785 word patch offset $1838; whole 16-bit word += relocation delta
    defb 03bh, 018h      ; runtime $4802, stored $65C2: #0786 word patch offset $183B; whole 16-bit word += relocation delta
    defb 03eh, 018h      ; runtime $4804, stored $65C4: #0787 word patch offset $183E; whole 16-bit word += relocation delta
    defb 041h, 018h      ; runtime $4806, stored $65C6: #0788 word patch offset $1841; whole 16-bit word += relocation delta
    defb 044h, 018h      ; runtime $4808, stored $65C8: #0789 word patch offset $1844; whole 16-bit word += relocation delta
    defb 047h, 018h      ; runtime $480A, stored $65CA: #0790 word patch offset $1847; whole 16-bit word += relocation delta
    defb 053h, 018h      ; runtime $480C, stored $65CC: #0791 word patch offset $1853; whole 16-bit word += relocation delta
    defb 058h, 018h      ; runtime $480E, stored $65CE: #0792 word patch offset $1858; whole 16-bit word += relocation delta
    defb 05bh, 018h      ; runtime $4810, stored $65D0: #0793 word patch offset $185B; whole 16-bit word += relocation delta
    defb 05eh, 018h      ; runtime $4812, stored $65D2: #0794 word patch offset $185E; whole 16-bit word += relocation delta
    defb 068h, 018h      ; runtime $4814, stored $65D4: #0795 word patch offset $1868; whole 16-bit word += relocation delta
    defb 07ah, 018h      ; runtime $4816, stored $65D6: #0796 word patch offset $187A; whole 16-bit word += relocation delta
    defb 082h, 018h      ; runtime $4818, stored $65D8: #0797 word patch offset $1882; whole 16-bit word += relocation delta
    defb 085h, 018h      ; runtime $481A, stored $65DA: #0798 word patch offset $1885; whole 16-bit word += relocation delta
    defb 088h, 018h      ; runtime $481C, stored $65DC: #0799 word patch offset $1888; whole 16-bit word += relocation delta
    defb 08bh, 018h      ; runtime $481E, stored $65DE: #0800 word patch offset $188B; whole 16-bit word += relocation delta
    defb 090h, 018h      ; runtime $4820, stored $65E0: #0801 word patch offset $1890; whole 16-bit word += relocation delta
    defb 09ch, 018h      ; runtime $4822, stored $65E2: #0802 word patch offset $189C; whole 16-bit word += relocation delta
    defb 0a4h, 018h      ; runtime $4824, stored $65E4: #0803 word patch offset $18A4; whole 16-bit word += relocation delta
    defb 0b2h, 018h      ; runtime $4826, stored $65E6: #0804 word patch offset $18B2; whole 16-bit word += relocation delta
    defb 0b7h, 018h      ; runtime $4828, stored $65E8: #0805 word patch offset $18B7; whole 16-bit word += relocation delta
    defb 0bah, 018h      ; runtime $482A, stored $65EA: #0806 word patch offset $18BA; whole 16-bit word += relocation delta
    defb 0bdh, 018h      ; runtime $482C, stored $65EC: #0807 word patch offset $18BD; whole 16-bit word += relocation delta
    defb 0c0h, 018h      ; runtime $482E, stored $65EE: #0808 word patch offset $18C0; whole 16-bit word += relocation delta
    defb 0c3h, 018h      ; runtime $4830, stored $65F0: #0809 word patch offset $18C3; whole 16-bit word += relocation delta
    defb 0c6h, 018h      ; runtime $4832, stored $65F2: #0810 word patch offset $18C6; whole 16-bit word += relocation delta
    defb 0c9h, 018h      ; runtime $4834, stored $65F4: #0811 word patch offset $18C9; whole 16-bit word += relocation delta
    defb 0cdh, 018h      ; runtime $4836, stored $65F6: #0812 word patch offset $18CD; whole 16-bit word += relocation delta
    defb 0d1h, 018h      ; runtime $4838, stored $65F8: #0813 word patch offset $18D1; whole 16-bit word += relocation delta
    defb 0dah, 018h      ; runtime $483A, stored $65FA: #0814 word patch offset $18DA; whole 16-bit word += relocation delta
    defb 023h, 019h      ; runtime $483C, stored $65FC: #0815 word patch offset $1923; whole 16-bit word += relocation delta
    defb 02ch, 019h      ; runtime $483E, stored $65FE: #0816 word patch offset $192C; whole 16-bit word += relocation delta
    defb 037h, 019h      ; runtime $4840, stored $6600: #0817 word patch offset $1937; whole 16-bit word += relocation delta
    defb 043h, 019h      ; runtime $4842, stored $6602: #0818 word patch offset $1943; whole 16-bit word += relocation delta
    defb 05fh, 019h      ; runtime $4844, stored $6604: #0819 word patch offset $195F; whole 16-bit word += relocation delta
    defb 06ah, 019h      ; runtime $4846, stored $6606: #0820 word patch offset $196A; whole 16-bit word += relocation delta
    defb 079h, 019h      ; runtime $4848, stored $6608: #0821 word patch offset $1979; whole 16-bit word += relocation delta
    defb 088h, 019h      ; runtime $484A, stored $660A: #0822 word patch offset $1988; whole 16-bit word += relocation delta
    defb 094h, 019h      ; runtime $484C, stored $660C: #0823 word patch offset $1994; whole 16-bit word += relocation delta
    defb 097h, 019h      ; runtime $484E, stored $660E: #0824 word patch offset $1997; whole 16-bit word += relocation delta
    defb 09ah, 019h      ; runtime $4850, stored $6610: #0825 word patch offset $199A; whole 16-bit word += relocation delta
    defb 0a0h, 019h      ; runtime $4852, stored $6612: #0826 word patch offset $19A0; whole 16-bit word += relocation delta
    defb 0abh, 019h      ; runtime $4854, stored $6614: #0827 word patch offset $19AB; whole 16-bit word += relocation delta
    defb 0b1h, 019h      ; runtime $4856, stored $6616: #0828 word patch offset $19B1; whole 16-bit word += relocation delta
    defb 0b9h, 019h      ; runtime $4858, stored $6618: #0829 word patch offset $19B9; whole 16-bit word += relocation delta
    defb 0beh, 019h      ; runtime $485A, stored $661A: #0830 word patch offset $19BE; whole 16-bit word += relocation delta
    defb 0d5h, 019h      ; runtime $485C, stored $661C: #0831 word patch offset $19D5; whole 16-bit word += relocation delta
    defb 0deh, 019h      ; runtime $485E, stored $661E: #0832 word patch offset $19DE; whole 16-bit word += relocation delta
    defb 0e9h, 019h      ; runtime $4860, stored $6620: #0833 word patch offset $19E9; whole 16-bit word += relocation delta
    defb 0f5h, 019h      ; runtime $4862, stored $6622: #0834 word patch offset $19F5; whole 16-bit word += relocation delta
    defb 0fah, 019h      ; runtime $4864, stored $6624: #0835 word patch offset $19FA; whole 16-bit word += relocation delta
    defb 0feh, 019h      ; runtime $4866, stored $6626: #0836 word patch offset $19FE; whole 16-bit word += relocation delta
    defb 003h, 01ah      ; runtime $4868, stored $6628: #0837 word patch offset $1A03; whole 16-bit word += relocation delta
    defb 00bh, 01ah      ; runtime $486A, stored $662A: #0838 word patch offset $1A0B; whole 16-bit word += relocation delta
    defb 012h, 01ah      ; runtime $486C, stored $662C: #0839 word patch offset $1A12; whole 16-bit word += relocation delta
    defb 01bh, 01ah      ; runtime $486E, stored $662E: #0840 word patch offset $1A1B; whole 16-bit word += relocation delta
    defb 023h, 01ah      ; runtime $4870, stored $6630: #0841 word patch offset $1A23; whole 16-bit word += relocation delta
    defb 026h, 01ah      ; runtime $4872, stored $6632: #0842 word patch offset $1A26; whole 16-bit word += relocation delta
    defb 039h, 01ah      ; runtime $4874, stored $6634: #0843 word patch offset $1A39; whole 16-bit word += relocation delta
    defb 03dh, 01ah      ; runtime $4876, stored $6636: #0844 word patch offset $1A3D; whole 16-bit word += relocation delta
    defb 040h, 01ah      ; runtime $4878, stored $6638: #0845 word patch offset $1A40; whole 16-bit word += relocation delta
    defb 043h, 01ah      ; runtime $487A, stored $663A: #0846 word patch offset $1A43; whole 16-bit word += relocation delta
    defb 046h, 01ah      ; runtime $487C, stored $663C: #0847 word patch offset $1A46; whole 16-bit word += relocation delta
    defb 049h, 01ah      ; runtime $487E, stored $663E: #0848 word patch offset $1A49; whole 16-bit word += relocation delta
    defb 04ch, 01ah      ; runtime $4880, stored $6640: #0849 word patch offset $1A4C; whole 16-bit word += relocation delta
    defb 051h, 01ah      ; runtime $4882, stored $6642: #0850 word patch offset $1A51; whole 16-bit word += relocation delta
    defb 054h, 01ah      ; runtime $4884, stored $6644: #0851 word patch offset $1A54; whole 16-bit word += relocation delta
    defb 057h, 01ah      ; runtime $4886, stored $6646: #0852 word patch offset $1A57; whole 16-bit word += relocation delta
    defb 063h, 01ah      ; runtime $4888, stored $6648: #0853 word patch offset $1A63; whole 16-bit word += relocation delta
    defb 06ch, 01ah      ; runtime $488A, stored $664A: #0854 word patch offset $1A6C; whole 16-bit word += relocation delta
    defb 071h, 01ah      ; runtime $488C, stored $664C: #0855 word patch offset $1A71; whole 16-bit word += relocation delta
    defb 07bh, 01ah      ; runtime $488E, stored $664E: #0856 word patch offset $1A7B; whole 16-bit word += relocation delta
    defb 085h, 01ah      ; runtime $4890, stored $6650: #0857 word patch offset $1A85; whole 16-bit word += relocation delta
    defb 089h, 01ah      ; runtime $4892, stored $6652: #0858 word patch offset $1A89; whole 16-bit word += relocation delta
    defb 09fh, 01ah      ; runtime $4894, stored $6654: #0859 word patch offset $1A9F; whole 16-bit word += relocation delta
    defb 0abh, 01ah      ; runtime $4896, stored $6656: #0860 word patch offset $1AAB; whole 16-bit word += relocation delta
    defb 0b3h, 01ah      ; runtime $4898, stored $6658: #0861 word patch offset $1AB3; whole 16-bit word += relocation delta
    defb 0b6h, 01ah      ; runtime $489A, stored $665A: #0862 word patch offset $1AB6; whole 16-bit word += relocation delta
    defb 0bfh, 01ah      ; runtime $489C, stored $665C: #0863 word patch offset $1ABF; whole 16-bit word += relocation delta
    defb 0c5h, 01ah      ; runtime $489E, stored $665E: #0864 word patch offset $1AC5; whole 16-bit word += relocation delta
    defb 0c8h, 01ah      ; runtime $48A0, stored $6660: #0865 word patch offset $1AC8; whole 16-bit word += relocation delta
    defb 0cbh, 01ah      ; runtime $48A2, stored $6662: #0866 word patch offset $1ACB; whole 16-bit word += relocation delta
    defb 0ceh, 01ah      ; runtime $48A4, stored $6664: #0867 word patch offset $1ACE; whole 16-bit word += relocation delta
    defb 0ddh, 01ah      ; runtime $48A6, stored $6666: #0868 word patch offset $1ADD; whole 16-bit word += relocation delta
    defb 0e2h, 01ah      ; runtime $48A8, stored $6668: #0869 word patch offset $1AE2; whole 16-bit word += relocation delta
    defb 0edh, 01ah      ; runtime $48AA, stored $666A: #0870 word patch offset $1AED; whole 16-bit word += relocation delta
    defb 0fbh, 01ah      ; runtime $48AC, stored $666C: #0871 word patch offset $1AFB; whole 16-bit word += relocation delta
    defb 002h, 01bh      ; runtime $48AE, stored $666E: #0872 word patch offset $1B02; whole 16-bit word += relocation delta
    defb 006h, 01bh      ; runtime $48B0, stored $6670: #0873 word patch offset $1B06; whole 16-bit word += relocation delta
    defb 010h, 01bh      ; runtime $48B2, stored $6672: #0874 word patch offset $1B10; whole 16-bit word += relocation delta
    defb 013h, 01bh      ; runtime $48B4, stored $6674: #0875 word patch offset $1B13; whole 16-bit word += relocation delta
    defb 026h, 01bh      ; runtime $48B6, stored $6676: #0876 word patch offset $1B26; whole 16-bit word += relocation delta
    defb 039h, 01bh      ; runtime $48B8, stored $6678: #0877 word patch offset $1B39; whole 16-bit word += relocation delta
    defb 04ah, 01bh      ; runtime $48BA, stored $667A: #0878 word patch offset $1B4A; whole 16-bit word += relocation delta
    defb 070h, 01bh      ; runtime $48BC, stored $667C: #0879 word patch offset $1B70; whole 16-bit word += relocation delta
    defb 079h, 01bh      ; runtime $48BE, stored $667E: #0880 word patch offset $1B79; whole 16-bit word += relocation delta
    defb 07eh, 01bh      ; runtime $48C0, stored $6680: #0881 word patch offset $1B7E; whole 16-bit word += relocation delta
    defb 081h, 01bh      ; runtime $48C2, stored $6682: #0882 word patch offset $1B81; whole 16-bit word += relocation delta
    defb 08fh, 01bh      ; runtime $48C4, stored $6684: #0883 word patch offset $1B8F; whole 16-bit word += relocation delta
    defb 096h, 01bh      ; runtime $48C6, stored $6686: #0884 word patch offset $1B96; whole 16-bit word += relocation delta
    defb 09bh, 01bh      ; runtime $48C8, stored $6688: #0885 word patch offset $1B9B; whole 16-bit word += relocation delta
    defb 09fh, 01bh      ; runtime $48CA, stored $668A: #0886 word patch offset $1B9F; whole 16-bit word += relocation delta
    defb 0a4h, 01bh      ; runtime $48CC, stored $668C: #0887 word patch offset $1BA4; whole 16-bit word += relocation delta
    defb 0abh, 01bh      ; runtime $48CE, stored $668E: #0888 word patch offset $1BAB; whole 16-bit word += relocation delta
    defb 0b1h, 01bh      ; runtime $48D0, stored $6690: #0889 word patch offset $1BB1; whole 16-bit word += relocation delta
    defb 0b5h, 01bh      ; runtime $48D2, stored $6692: #0890 word patch offset $1BB5; whole 16-bit word += relocation delta
    defb 0bch, 01bh      ; runtime $48D4, stored $6694: #0891 word patch offset $1BBC; whole 16-bit word += relocation delta
    defb 0c0h, 01bh      ; runtime $48D6, stored $6696: #0892 word patch offset $1BC0; whole 16-bit word += relocation delta
    defb 0d0h, 01bh      ; runtime $48D8, stored $6698: #0893 word patch offset $1BD0; whole 16-bit word += relocation delta
    defb 0d5h, 01bh      ; runtime $48DA, stored $669A: #0894 word patch offset $1BD5; whole 16-bit word += relocation delta
    defb 0f8h, 01bh      ; runtime $48DC, stored $669C: #0895 word patch offset $1BF8; whole 16-bit word += relocation delta
    defb 019h, 01ch      ; runtime $48DE, stored $669E: #0896 word patch offset $1C19; whole 16-bit word += relocation delta
    defb 01dh, 01ch      ; runtime $48E0, stored $66A0: #0897 word patch offset $1C1D; whole 16-bit word += relocation delta
    defb 022h, 01ch      ; runtime $48E2, stored $66A2: #0898 word patch offset $1C22; whole 16-bit word += relocation delta
    defb 040h, 01ch      ; runtime $48E4, stored $66A4: #0899 word patch offset $1C40; whole 16-bit word += relocation delta
    defb 043h, 01ch      ; runtime $48E6, stored $66A6: #0900 word patch offset $1C43; whole 16-bit word += relocation delta
    defb 051h, 01ch      ; runtime $48E8, stored $66A8: #0901 word patch offset $1C51; whole 16-bit word += relocation delta
    defb 055h, 01ch      ; runtime $48EA, stored $66AA: #0902 word patch offset $1C55; whole 16-bit word += relocation delta
    defb 059h, 01ch      ; runtime $48EC, stored $66AC: #0903 word patch offset $1C59; whole 16-bit word += relocation delta
    defb 066h, 01ch      ; runtime $48EE, stored $66AE: #0904 word patch offset $1C66; whole 16-bit word += relocation delta
    defb 06bh, 01ch      ; runtime $48F0, stored $66B0: #0905 word patch offset $1C6B; whole 16-bit word += relocation delta
    defb 071h, 01ch      ; runtime $48F2, stored $66B2: #0906 word patch offset $1C71; whole 16-bit word += relocation delta
    defb 074h, 01ch      ; runtime $48F4, stored $66B4: #0907 word patch offset $1C74; whole 16-bit word += relocation delta
    defb 077h, 01ch      ; runtime $48F6, stored $66B6: #0908 word patch offset $1C77; whole 16-bit word += relocation delta
    defb 07ah, 01ch      ; runtime $48F8, stored $66B8: #0909 word patch offset $1C7A; whole 16-bit word += relocation delta
    defb 07dh, 01ch      ; runtime $48FA, stored $66BA: #0910 word patch offset $1C7D; whole 16-bit word += relocation delta
    defb 087h, 01ch      ; runtime $48FC, stored $66BC: #0911 word patch offset $1C87; whole 16-bit word += relocation delta
    defb 08ah, 01ch      ; runtime $48FE, stored $66BE: #0912 word patch offset $1C8A; whole 16-bit word += relocation delta
    defb 09bh, 01ch      ; runtime $4900, stored $66C0: #0913 word patch offset $1C9B; whole 16-bit word += relocation delta
    defb 09eh, 01ch      ; runtime $4902, stored $66C2: #0914 word patch offset $1C9E; whole 16-bit word += relocation delta
    defb 0a3h, 01ch      ; runtime $4904, stored $66C4: #0915 word patch offset $1CA3; whole 16-bit word += relocation delta
    defb 0a6h, 01ch      ; runtime $4906, stored $66C6: #0916 word patch offset $1CA6; whole 16-bit word += relocation delta
    defb 0a9h, 01ch      ; runtime $4908, stored $66C8: #0917 word patch offset $1CA9; whole 16-bit word += relocation delta
    defb 0b0h, 01ch      ; runtime $490A, stored $66CA: #0918 word patch offset $1CB0; whole 16-bit word += relocation delta
    defb 0b3h, 01ch      ; runtime $490C, stored $66CC: #0919 word patch offset $1CB3; whole 16-bit word += relocation delta
    defb 0bbh, 01ch      ; runtime $490E, stored $66CE: #0920 word patch offset $1CBB; whole 16-bit word += relocation delta
    defb 0beh, 01ch      ; runtime $4910, stored $66D0: #0921 word patch offset $1CBE; whole 16-bit word += relocation delta
    defb 0c1h, 01ch      ; runtime $4912, stored $66D2: #0922 word patch offset $1CC1; whole 16-bit word += relocation delta
    defb 0c5h, 01ch      ; runtime $4914, stored $66D4: #0923 word patch offset $1CC5; whole 16-bit word += relocation delta
    defb 0c8h, 01ch      ; runtime $4916, stored $66D6: #0924 word patch offset $1CC8; whole 16-bit word += relocation delta
    defb 0d2h, 01ch      ; runtime $4918, stored $66D8: #0925 word patch offset $1CD2; whole 16-bit word += relocation delta
    defb 0d5h, 01ch      ; runtime $491A, stored $66DA: #0926 word patch offset $1CD5; whole 16-bit word += relocation delta
    defb 0d8h, 01ch      ; runtime $491C, stored $66DC: #0927 word patch offset $1CD8; whole 16-bit word += relocation delta
    defb 0dch, 01ch      ; runtime $491E, stored $66DE: #0928 word patch offset $1CDC; whole 16-bit word += relocation delta
    defb 0dfh, 01ch      ; runtime $4920, stored $66E0: #0929 word patch offset $1CDF; whole 16-bit word += relocation delta
    defb 0e2h, 01ch      ; runtime $4922, stored $66E2: #0930 word patch offset $1CE2; whole 16-bit word += relocation delta
    defb 0e7h, 01ch      ; runtime $4924, stored $66E4: #0931 word patch offset $1CE7; whole 16-bit word += relocation delta
    defb 0eah, 01ch      ; runtime $4926, stored $66E6: #0932 word patch offset $1CEA; whole 16-bit word += relocation delta
    defb 006h, 01dh      ; runtime $4928, stored $66E8: #0933 word patch offset $1D06; whole 16-bit word += relocation delta
    defb 014h, 01dh      ; runtime $492A, stored $66EA: #0934 word patch offset $1D14; whole 16-bit word += relocation delta
    defb 017h, 01dh      ; runtime $492C, stored $66EC: #0935 word patch offset $1D17; whole 16-bit word += relocation delta
    defb 01ah, 01dh      ; runtime $492E, stored $66EE: #0936 word patch offset $1D1A; whole 16-bit word += relocation delta
    defb 01dh, 01dh      ; runtime $4930, stored $66F0: #0937 word patch offset $1D1D; whole 16-bit word += relocation delta
    defb 021h, 01dh      ; runtime $4932, stored $66F2: #0938 word patch offset $1D21; whole 16-bit word += relocation delta
    defb 02bh, 01dh      ; runtime $4934, stored $66F4: #0939 word patch offset $1D2B; whole 16-bit word += relocation delta
    defb 02eh, 01dh      ; runtime $4936, stored $66F6: #0940 word patch offset $1D2E; whole 16-bit word += relocation delta
    defb 032h, 01dh      ; runtime $4938, stored $66F8: #0941 word patch offset $1D32; whole 16-bit word += relocation delta
    defb 035h, 01dh      ; runtime $493A, stored $66FA: #0942 word patch offset $1D35; whole 16-bit word += relocation delta
    defb 03fh, 01dh      ; runtime $493C, stored $66FC: #0943 word patch offset $1D3F; whole 16-bit word += relocation delta
    defb 043h, 01dh      ; runtime $493E, stored $66FE: #0944 word patch offset $1D43; whole 16-bit word += relocation delta
    defb 04ah, 01dh      ; runtime $4940, stored $6700: #0945 word patch offset $1D4A; whole 16-bit word += relocation delta
    defb 052h, 01dh      ; runtime $4942, stored $6702: #0946 word patch offset $1D52; whole 16-bit word += relocation delta
    defb 057h, 01dh      ; runtime $4944, stored $6704: #0947 word patch offset $1D57; whole 16-bit word += relocation delta
    defb 05eh, 01dh      ; runtime $4946, stored $6706: #0948 word patch offset $1D5E; whole 16-bit word += relocation delta
    defb 066h, 01dh      ; runtime $4948, stored $6708: #0949 word patch offset $1D66; whole 16-bit word += relocation delta
    defb 06eh, 01dh      ; runtime $494A, stored $670A: #0950 word patch offset $1D6E; whole 16-bit word += relocation delta
    defb 073h, 01dh      ; runtime $494C, stored $670C: #0951 word patch offset $1D73; whole 16-bit word += relocation delta
    defb 078h, 01dh      ; runtime $494E, stored $670E: #0952 word patch offset $1D78; whole 16-bit word += relocation delta
    defb 07bh, 01dh      ; runtime $4950, stored $6710: #0953 word patch offset $1D7B; whole 16-bit word += relocation delta
    defb 07eh, 01dh      ; runtime $4952, stored $6712: #0954 word patch offset $1D7E; whole 16-bit word += relocation delta
    defb 081h, 01dh      ; runtime $4954, stored $6714: #0955 word patch offset $1D81; whole 16-bit word += relocation delta
    defb 085h, 01dh      ; runtime $4956, stored $6716: #0956 word patch offset $1D85; whole 16-bit word += relocation delta
    defb 088h, 01dh      ; runtime $4958, stored $6718: #0957 word patch offset $1D88; whole 16-bit word += relocation delta
    defb 08bh, 01dh      ; runtime $495A, stored $671A: #0958 word patch offset $1D8B; whole 16-bit word += relocation delta
    defb 08eh, 01dh      ; runtime $495C, stored $671C: #0959 word patch offset $1D8E; whole 16-bit word += relocation delta
    defb 093h, 01dh      ; runtime $495E, stored $671E: #0960 word patch offset $1D93; whole 16-bit word += relocation delta
    defb 097h, 01dh      ; runtime $4960, stored $6720: #0961 word patch offset $1D97; whole 16-bit word += relocation delta
    defb 09ah, 01dh      ; runtime $4962, stored $6722: #0962 word patch offset $1D9A; whole 16-bit word += relocation delta
    defb 0a4h, 01dh      ; runtime $4964, stored $6724: #0963 word patch offset $1DA4; whole 16-bit word += relocation delta
    defb 0a9h, 01dh      ; runtime $4966, stored $6726: #0964 word patch offset $1DA9; whole 16-bit word += relocation delta
    defb 0b4h, 01dh      ; runtime $4968, stored $6728: #0965 word patch offset $1DB4; whole 16-bit word += relocation delta
    defb 0b7h, 01dh      ; runtime $496A, stored $672A: #0966 word patch offset $1DB7; whole 16-bit word += relocation delta
    defb 0bah, 01dh      ; runtime $496C, stored $672C: #0967 word patch offset $1DBA; whole 16-bit word += relocation delta
    defb 0c0h, 01dh      ; runtime $496E, stored $672E: #0968 word patch offset $1DC0; whole 16-bit word += relocation delta
    defb 0c5h, 01dh      ; runtime $4970, stored $6730: #0969 word patch offset $1DC5; whole 16-bit word += relocation delta
    defb 0cbh, 01dh      ; runtime $4972, stored $6732: #0970 word patch offset $1DCB; whole 16-bit word += relocation delta
    defb 0d3h, 01dh      ; runtime $4974, stored $6734: #0971 word patch offset $1DD3; whole 16-bit word += relocation delta
    defb 0d6h, 01dh      ; runtime $4976, stored $6736: #0972 word patch offset $1DD6; whole 16-bit word += relocation delta
    defb 0d9h, 01dh      ; runtime $4978, stored $6738: #0973 word patch offset $1DD9; whole 16-bit word += relocation delta
    defb 0e1h, 01dh      ; runtime $497A, stored $673A: #0974 word patch offset $1DE1; whole 16-bit word += relocation delta
    defb 0e7h, 01dh      ; runtime $497C, stored $673C: #0975 word patch offset $1DE7; whole 16-bit word += relocation delta
    defb 0eah, 01dh      ; runtime $497E, stored $673E: #0976 word patch offset $1DEA; whole 16-bit word += relocation delta
    defb 0f0h, 01dh      ; runtime $4980, stored $6740: #0977 word patch offset $1DF0; whole 16-bit word += relocation delta
    defb 0f3h, 01dh      ; runtime $4982, stored $6742: #0978 word patch offset $1DF3; whole 16-bit word += relocation delta
    defb 0f6h, 01dh      ; runtime $4984, stored $6744: #0979 word patch offset $1DF6; whole 16-bit word += relocation delta
    defb 000h, 01eh      ; runtime $4986, stored $6746: #0980 word patch offset $1E00; whole 16-bit word += relocation delta
    defb 005h, 01eh      ; runtime $4988, stored $6748: #0981 word patch offset $1E05; whole 16-bit word += relocation delta
    defb 014h, 01eh      ; runtime $498A, stored $674A: #0982 word patch offset $1E14; whole 16-bit word += relocation delta
    defb 022h, 01eh      ; runtime $498C, stored $674C: #0983 word patch offset $1E22; whole 16-bit word += relocation delta
    defb 02bh, 01eh      ; runtime $498E, stored $674E: #0984 word patch offset $1E2B; whole 16-bit word += relocation delta
    defb 02eh, 01eh      ; runtime $4990, stored $6750: #0985 word patch offset $1E2E; whole 16-bit word += relocation delta
    defb 031h, 01eh      ; runtime $4992, stored $6752: #0986 word patch offset $1E31; whole 16-bit word += relocation delta
    defb 034h, 01eh      ; runtime $4994, stored $6754: #0987 word patch offset $1E34; whole 16-bit word += relocation delta
    defb 04ch, 01eh      ; runtime $4996, stored $6756: #0988 word patch offset $1E4C; whole 16-bit word += relocation delta
    defb 04fh, 01eh      ; runtime $4998, stored $6758: #0989 word patch offset $1E4F; whole 16-bit word += relocation delta
    defb 05eh, 01eh      ; runtime $499A, stored $675A: #0990 word patch offset $1E5E; whole 16-bit word += relocation delta
    defb 065h, 01eh      ; runtime $499C, stored $675C: #0991 word patch offset $1E65; whole 16-bit word += relocation delta
    defb 06ch, 01eh      ; runtime $499E, stored $675E: #0992 word patch offset $1E6C; whole 16-bit word += relocation delta
    defb 073h, 01eh      ; runtime $49A0, stored $6760: #0993 word patch offset $1E73; whole 16-bit word += relocation delta
    defb 079h, 01eh      ; runtime $49A2, stored $6762: #0994 word patch offset $1E79; whole 16-bit word += relocation delta
    defb 07ch, 01eh      ; runtime $49A4, stored $6764: #0995 word patch offset $1E7C; whole 16-bit word += relocation delta
    defb 085h, 01eh      ; runtime $49A6, stored $6766: #0996 word patch offset $1E85; whole 16-bit word += relocation delta
    defb 092h, 01eh      ; runtime $49A8, stored $6768: #0997 word patch offset $1E92; whole 16-bit word += relocation delta
    defb 09fh, 01eh      ; runtime $49AA, stored $676A: #0998 word patch offset $1E9F; whole 16-bit word += relocation delta
    defb 0b1h, 01eh      ; runtime $49AC, stored $676C: #0999 word patch offset $1EB1; whole 16-bit word += relocation delta
    defb 0b8h, 01eh      ; runtime $49AE, stored $676E: #1000 word patch offset $1EB8; whole 16-bit word += relocation delta
    defb 0c4h, 01eh      ; runtime $49B0, stored $6770: #1001 word patch offset $1EC4; whole 16-bit word += relocation delta
    defb 0cdh, 01eh      ; runtime $49B2, stored $6772: #1002 word patch offset $1ECD; whole 16-bit word += relocation delta
    defb 0f6h, 01eh      ; runtime $49B4, stored $6774: #1003 word patch offset $1EF6; whole 16-bit word += relocation delta
    defb 0fbh, 01eh      ; runtime $49B6, stored $6776: #1004 word patch offset $1EFB; whole 16-bit word += relocation delta
    defb 009h, 01fh      ; runtime $49B8, stored $6778: #1005 word patch offset $1F09; whole 16-bit word += relocation delta
    defb 016h, 01fh      ; runtime $49BA, stored $677A: #1006 word patch offset $1F16; whole 16-bit word += relocation delta
    defb 01ah, 01fh      ; runtime $49BC, stored $677C: #1007 word patch offset $1F1A; whole 16-bit word += relocation delta
    defb 027h, 01fh      ; runtime $49BE, stored $677E: #1008 word patch offset $1F27; whole 16-bit word += relocation delta
    defb 02ah, 01fh      ; runtime $49C0, stored $6780: #1009 word patch offset $1F2A; whole 16-bit word += relocation delta
    defb 02fh, 01fh      ; runtime $49C2, stored $6782: #1010 word patch offset $1F2F; whole 16-bit word += relocation delta
    defb 048h, 01fh      ; runtime $49C4, stored $6784: #1011 word patch offset $1F48; whole 16-bit word += relocation delta
    defb 070h, 01fh      ; runtime $49C6, stored $6786: #1012 word patch offset $1F70; whole 16-bit word += relocation delta
    defb 078h, 01fh      ; runtime $49C8, stored $6788: #1013 word patch offset $1F78; whole 16-bit word += relocation delta
    defb 086h, 01fh      ; runtime $49CA, stored $678A: #1014 word patch offset $1F86; whole 16-bit word += relocation delta
    defb 08ah, 01fh      ; runtime $49CC, stored $678C: #1015 word patch offset $1F8A; whole 16-bit word += relocation delta
    defb 08eh, 01fh      ; runtime $49CE, stored $678E: #1016 word patch offset $1F8E; whole 16-bit word += relocation delta
    defb 097h, 01fh      ; runtime $49D0, stored $6790: #1017 word patch offset $1F97; whole 16-bit word += relocation delta
    defb 0a2h, 01fh      ; runtime $49D2, stored $6792: #1018 word patch offset $1FA2; whole 16-bit word += relocation delta
    defb 0adh, 01fh      ; runtime $49D4, stored $6794: #1019 word patch offset $1FAD; whole 16-bit word += relocation delta
    defb 0b1h, 01fh      ; runtime $49D6, stored $6796: #1020 word patch offset $1FB1; whole 16-bit word += relocation delta
    defb 0b4h, 01fh      ; runtime $49D8, stored $6798: #1021 word patch offset $1FB4; whole 16-bit word += relocation delta
    defb 0b7h, 01fh      ; runtime $49DA, stored $679A: #1022 word patch offset $1FB7; whole 16-bit word += relocation delta
    defb 0bah, 01fh      ; runtime $49DC, stored $679C: #1023 word patch offset $1FBA; whole 16-bit word += relocation delta
    defb 0c3h, 01fh      ; runtime $49DE, stored $679E: #1024 word patch offset $1FC3; whole 16-bit word += relocation delta
    defb 0cbh, 01fh      ; runtime $49E0, stored $67A0: #1025 word patch offset $1FCB; whole 16-bit word += relocation delta
    defb 0ceh, 01fh      ; runtime $49E2, stored $67A2: #1026 word patch offset $1FCE; whole 16-bit word += relocation delta
    defb 010h, 020h      ; runtime $49E4, stored $67A4: #1027 word patch offset $2010; whole 16-bit word += relocation delta
    defb 017h, 020h      ; runtime $49E6, stored $67A6: #1028 word patch offset $2017; whole 16-bit word += relocation delta
    defb 020h, 020h      ; runtime $49E8, stored $67A8: #1029 word patch offset $2020; whole 16-bit word += relocation delta
    defb 029h, 020h      ; runtime $49EA, stored $67AA: #1030 word patch offset $2029; whole 16-bit word += relocation delta
    defb 02eh, 020h      ; runtime $49EC, stored $67AC: #1031 word patch offset $202E; whole 16-bit word += relocation delta
    defb 04dh, 020h      ; runtime $49EE, stored $67AE: #1032 word patch offset $204D; whole 16-bit word += relocation delta
    defb 055h, 020h      ; runtime $49F0, stored $67B0: #1033 word patch offset $2055; whole 16-bit word += relocation delta
    defb 05bh, 020h      ; runtime $49F2, stored $67B2: #1034 word patch offset $205B; whole 16-bit word += relocation delta
    defb 067h, 020h      ; runtime $49F4, stored $67B4: #1035 word patch offset $2067; whole 16-bit word += relocation delta
    defb 06ch, 020h      ; runtime $49F6, stored $67B6: #1036 word patch offset $206C; whole 16-bit word += relocation delta
    defb 095h, 020h      ; runtime $49F8, stored $67B8: #1037 word patch offset $2095; whole 16-bit word += relocation delta
    defb 0e5h, 020h      ; runtime $49FA, stored $67BA: #1038 word patch offset $20E5; whole 16-bit word += relocation delta
    defb 0e9h, 020h      ; runtime $49FC, stored $67BC: #1039 word patch offset $20E9; whole 16-bit word += relocation delta
    defb 023h, 021h      ; runtime $49FE, stored $67BE: #1040 word patch offset $2123; whole 16-bit word += relocation delta
    defb 02ah, 021h      ; runtime $4A00, stored $67C0: #1041 word patch offset $212A; whole 16-bit word += relocation delta
    defb 02dh, 021h      ; runtime $4A02, stored $67C2: #1042 word patch offset $212D; whole 16-bit word += relocation delta
    defb 030h, 021h      ; runtime $4A04, stored $67C4: #1043 word patch offset $2130; whole 16-bit word += relocation delta
    defb 033h, 021h      ; runtime $4A06, stored $67C6: #1044 word patch offset $2133; whole 16-bit word += relocation delta
    defb 038h, 021h      ; runtime $4A08, stored $67C8: #1045 word patch offset $2138; whole 16-bit word += relocation delta
    defb 046h, 021h      ; runtime $4A0A, stored $67CA: #1046 word patch offset $2146; whole 16-bit word += relocation delta
    defb 04dh, 021h      ; runtime $4A0C, stored $67CC: #1047 word patch offset $214D; whole 16-bit word += relocation delta
    defb 060h, 021h      ; runtime $4A0E, stored $67CE: #1048 word patch offset $2160; whole 16-bit word += relocation delta
    defb 070h, 021h      ; runtime $4A10, stored $67D0: #1049 word patch offset $2170; whole 16-bit word += relocation delta
    defb 07dh, 021h      ; runtime $4A12, stored $67D2: #1050 word patch offset $217D; whole 16-bit word += relocation delta
    defb 08dh, 021h      ; runtime $4A14, stored $67D4: #1051 word patch offset $218D; whole 16-bit word += relocation delta
    defb 090h, 021h      ; runtime $4A16, stored $67D6: #1052 word patch offset $2190; whole 16-bit word += relocation delta
    defb 09ah, 021h      ; runtime $4A18, stored $67D8: #1053 word patch offset $219A; whole 16-bit word += relocation delta
    defb 09fh, 021h      ; runtime $4A1A, stored $67DA: #1054 word patch offset $219F; whole 16-bit word += relocation delta
    defb 0bch, 021h      ; runtime $4A1C, stored $67DC: #1055 word patch offset $21BC; whole 16-bit word += relocation delta
    defb 0c5h, 021h      ; runtime $4A1E, stored $67DE: #1056 word patch offset $21C5; whole 16-bit word += relocation delta
    defb 0cdh, 021h      ; runtime $4A20, stored $67E0: #1057 word patch offset $21CD; whole 16-bit word += relocation delta
    defb 0d0h, 021h      ; runtime $4A22, stored $67E2: #1058 word patch offset $21D0; whole 16-bit word += relocation delta
    defb 0d6h, 021h      ; runtime $4A24, stored $67E4: #1059 word patch offset $21D6; whole 16-bit word += relocation delta
    defb 0d9h, 021h      ; runtime $4A26, stored $67E6: #1060 word patch offset $21D9; whole 16-bit word += relocation delta
    defb 0e0h, 021h      ; runtime $4A28, stored $67E8: #1061 word patch offset $21E0; whole 16-bit word += relocation delta
    defb 008h, 022h      ; runtime $4A2A, stored $67EA: #1062 word patch offset $2208; whole 16-bit word += relocation delta
    defb 013h, 022h      ; runtime $4A2C, stored $67EC: #1063 word patch offset $2213; whole 16-bit word += relocation delta
    defb 016h, 022h      ; runtime $4A2E, stored $67EE: #1064 word patch offset $2216; whole 16-bit word += relocation delta
    defb 01eh, 022h      ; runtime $4A30, stored $67F0: #1065 word patch offset $221E; whole 16-bit word += relocation delta
    defb 021h, 022h      ; runtime $4A32, stored $67F2: #1066 word patch offset $2221; whole 16-bit word += relocation delta
    defb 027h, 022h      ; runtime $4A34, stored $67F4: #1067 word patch offset $2227; whole 16-bit word += relocation delta
    defb 02dh, 022h      ; runtime $4A36, stored $67F6: #1068 word patch offset $222D; whole 16-bit word += relocation delta
    defb 036h, 022h      ; runtime $4A38, stored $67F8: #1069 word patch offset $2236; whole 16-bit word += relocation delta
    defb 03bh, 022h      ; runtime $4A3A, stored $67FA: #1070 word patch offset $223B; whole 16-bit word += relocation delta
    defb 03eh, 022h      ; runtime $4A3C, stored $67FC: #1071 word patch offset $223E; whole 16-bit word += relocation delta
    defb 044h, 022h      ; runtime $4A3E, stored $67FE: #1072 word patch offset $2244; whole 16-bit word += relocation delta
    defb 047h, 022h      ; runtime $4A40, stored $6800: #1073 word patch offset $2247; whole 16-bit word += relocation delta
    defb 04fh, 022h      ; runtime $4A42, stored $6802: #1074 word patch offset $224F; whole 16-bit word += relocation delta
    defb 052h, 022h      ; runtime $4A44, stored $6804: #1075 word patch offset $2252; whole 16-bit word += relocation delta
    defb 055h, 022h      ; runtime $4A46, stored $6806: #1076 word patch offset $2255; whole 16-bit word += relocation delta
    defb 058h, 022h      ; runtime $4A48, stored $6808: #1077 word patch offset $2258; whole 16-bit word += relocation delta
    defb 05bh, 022h      ; runtime $4A4A, stored $680A: #1078 word patch offset $225B; whole 16-bit word += relocation delta
    defb 061h, 022h      ; runtime $4A4C, stored $680C: #1079 word patch offset $2261; whole 16-bit word += relocation delta
    defb 066h, 022h      ; runtime $4A4E, stored $680E: #1080 word patch offset $2266; whole 16-bit word += relocation delta
    defb 073h, 022h      ; runtime $4A50, stored $6810: #1081 word patch offset $2273; whole 16-bit word += relocation delta
    defb 076h, 022h      ; runtime $4A52, stored $6812: #1082 word patch offset $2276; whole 16-bit word += relocation delta
    defb 07dh, 022h      ; runtime $4A54, stored $6814: #1083 word patch offset $227D; whole 16-bit word += relocation delta
    defb 081h, 022h      ; runtime $4A56, stored $6816: #1084 word patch offset $2281; whole 16-bit word += relocation delta
    defb 086h, 022h      ; runtime $4A58, stored $6818: #1085 word patch offset $2286; whole 16-bit word += relocation delta
    defb 08fh, 022h      ; runtime $4A5A, stored $681A: #1086 word patch offset $228F; whole 16-bit word += relocation delta
    defb 094h, 022h      ; runtime $4A5C, stored $681C: #1087 word patch offset $2294; whole 16-bit word += relocation delta
    defb 09fh, 022h      ; runtime $4A5E, stored $681E: #1088 word patch offset $229F; whole 16-bit word += relocation delta
    defb 0aah, 022h      ; runtime $4A60, stored $6820: #1089 word patch offset $22AA; whole 16-bit word += relocation delta
    defb 0b2h, 022h      ; runtime $4A62, stored $6822: #1090 word patch offset $22B2; whole 16-bit word += relocation delta
    defb 0beh, 022h      ; runtime $4A64, stored $6824: #1091 word patch offset $22BE; whole 16-bit word += relocation delta
    defb 0c3h, 022h      ; runtime $4A66, stored $6826: #1092 word patch offset $22C3; whole 16-bit word += relocation delta
    defb 0c6h, 022h      ; runtime $4A68, stored $6828: #1093 word patch offset $22C6; whole 16-bit word += relocation delta
    defb 0cbh, 022h      ; runtime $4A6A, stored $682A: #1094 word patch offset $22CB; whole 16-bit word += relocation delta
    defb 0d8h, 022h      ; runtime $4A6C, stored $682C: #1095 word patch offset $22D8; whole 16-bit word += relocation delta
    defb 0e3h, 022h      ; runtime $4A6E, stored $682E: #1096 word patch offset $22E3; whole 16-bit word += relocation delta
    defb 0ebh, 022h      ; runtime $4A70, stored $6830: #1097 word patch offset $22EB; whole 16-bit word += relocation delta
    defb 0f7h, 022h      ; runtime $4A72, stored $6832: #1098 word patch offset $22F7; whole 16-bit word += relocation delta
    defb 0fch, 022h      ; runtime $4A74, stored $6834: #1099 word patch offset $22FC; whole 16-bit word += relocation delta
    defb 0ffh, 022h      ; runtime $4A76, stored $6836: #1100 word patch offset $22FF; whole 16-bit word += relocation delta
    defb 004h, 023h      ; runtime $4A78, stored $6838: #1101 word patch offset $2304; whole 16-bit word += relocation delta
    defb 014h, 023h      ; runtime $4A7A, stored $683A: #1102 word patch offset $2314; whole 16-bit word += relocation delta
    defb 017h, 023h      ; runtime $4A7C, stored $683C: #1103 word patch offset $2317; whole 16-bit word += relocation delta
    defb 01ah, 023h      ; runtime $4A7E, stored $683E: #1104 word patch offset $231A; whole 16-bit word += relocation delta
    defb 01fh, 023h      ; runtime $4A80, stored $6840: #1105 word patch offset $231F; whole 16-bit word += relocation delta
    defb 022h, 023h      ; runtime $4A82, stored $6842: #1106 word patch offset $2322; whole 16-bit word += relocation delta
    defb 02bh, 023h      ; runtime $4A84, stored $6844: #1107 word patch offset $232B; whole 16-bit word += relocation delta
    defb 02eh, 023h      ; runtime $4A86, stored $6846: #1108 word patch offset $232E; whole 16-bit word += relocation delta
    defb 031h, 023h      ; runtime $4A88, stored $6848: #1109 word patch offset $2331; whole 16-bit word += relocation delta
    defb 034h, 023h      ; runtime $4A8A, stored $684A: #1110 word patch offset $2334; whole 16-bit word += relocation delta
    defb 039h, 023h      ; runtime $4A8C, stored $684C: #1111 word patch offset $2339; whole 16-bit word += relocation delta
    defb 044h, 023h      ; runtime $4A8E, stored $684E: #1112 word patch offset $2344; whole 16-bit word += relocation delta
    defb 047h, 023h      ; runtime $4A90, stored $6850: #1113 word patch offset $2347; whole 16-bit word += relocation delta
    defb 04ah, 023h      ; runtime $4A92, stored $6852: #1114 word patch offset $234A; whole 16-bit word += relocation delta
    defb 055h, 023h      ; runtime $4A94, stored $6854: #1115 word patch offset $2355; whole 16-bit word += relocation delta
    defb 058h, 023h      ; runtime $4A96, stored $6856: #1116 word patch offset $2358; whole 16-bit word += relocation delta
    defb 05eh, 023h      ; runtime $4A98, stored $6858: #1117 word patch offset $235E; whole 16-bit word += relocation delta
    defb 068h, 023h      ; runtime $4A9A, stored $685A: #1118 word patch offset $2368; whole 16-bit word += relocation delta
    defb 06bh, 023h      ; runtime $4A9C, stored $685C: #1119 word patch offset $236B; whole 16-bit word += relocation delta
    defb 06fh, 023h      ; runtime $4A9E, stored $685E: #1120 word patch offset $236F; whole 16-bit word += relocation delta
    defb 072h, 023h      ; runtime $4AA0, stored $6860: #1121 word patch offset $2372; whole 16-bit word += relocation delta
    defb 078h, 023h      ; runtime $4AA2, stored $6862: #1122 word patch offset $2378; whole 16-bit word += relocation delta
    defb 07ch, 023h      ; runtime $4AA4, stored $6864: #1123 word patch offset $237C; whole 16-bit word += relocation delta
    defb 084h, 023h      ; runtime $4AA6, stored $6866: #1124 word patch offset $2384; whole 16-bit word += relocation delta
    defb 087h, 023h      ; runtime $4AA8, stored $6868: #1125 word patch offset $2387; whole 16-bit word += relocation delta
    defb 08dh, 023h      ; runtime $4AAA, stored $686A: #1126 word patch offset $238D; whole 16-bit word += relocation delta
    defb 092h, 023h      ; runtime $4AAC, stored $686C: #1127 word patch offset $2392; whole 16-bit word += relocation delta
    defb 096h, 023h      ; runtime $4AAE, stored $686E: #1128 word patch offset $2396; whole 16-bit word += relocation delta
    defb 099h, 023h      ; runtime $4AB0, stored $6870: #1129 word patch offset $2399; whole 16-bit word += relocation delta
    defb 09ch, 023h      ; runtime $4AB2, stored $6872: #1130 word patch offset $239C; whole 16-bit word += relocation delta
    defb 0d9h, 023h      ; runtime $4AB4, stored $6874: #1131 word patch offset $23D9; whole 16-bit word += relocation delta
    defb 0e8h, 023h      ; runtime $4AB6, stored $6876: #1132 word patch offset $23E8; whole 16-bit word += relocation delta
    defb 006h, 024h      ; runtime $4AB8, stored $6878: #1133 word patch offset $2406; whole 16-bit word += relocation delta
    defb 02bh, 024h      ; runtime $4ABA, stored $687A: #1134 word patch offset $242B; whole 16-bit word += relocation delta
    defb 03ah, 024h      ; runtime $4ABC, stored $687C: #1135 word patch offset $243A; whole 16-bit word += relocation delta
    defb 03dh, 024h      ; runtime $4ABE, stored $687E: #1136 word patch offset $243D; whole 16-bit word += relocation delta
    defb 045h, 024h      ; runtime $4AC0, stored $6880: #1137 word patch offset $2445; whole 16-bit word += relocation delta
    defb 04eh, 024h      ; runtime $4AC2, stored $6882: #1138 word patch offset $244E; whole 16-bit word += relocation delta
    defb 051h, 024h      ; runtime $4AC4, stored $6884: #1139 word patch offset $2451; whole 16-bit word += relocation delta
    defb 054h, 024h      ; runtime $4AC6, stored $6886: #1140 word patch offset $2454; whole 16-bit word += relocation delta
    defb 059h, 024h      ; runtime $4AC8, stored $6888: #1141 word patch offset $2459; whole 16-bit word += relocation delta
    defb 05ch, 024h      ; runtime $4ACA, stored $688A: #1142 word patch offset $245C; whole 16-bit word += relocation delta
    defb 05fh, 024h      ; runtime $4ACC, stored $688C: #1143 word patch offset $245F; whole 16-bit word += relocation delta
    defb 064h, 024h      ; runtime $4ACE, stored $688E: #1144 word patch offset $2464; whole 16-bit word += relocation delta
    defb 06ah, 024h      ; runtime $4AD0, stored $6890: #1145 word patch offset $246A; whole 16-bit word += relocation delta
    defb 06dh, 024h      ; runtime $4AD2, stored $6892: #1146 word patch offset $246D; whole 16-bit word += relocation delta
    defb 072h, 024h      ; runtime $4AD4, stored $6894: #1147 word patch offset $2472; whole 16-bit word += relocation delta
    defb 075h, 024h      ; runtime $4AD6, stored $6896: #1148 word patch offset $2475; whole 16-bit word += relocation delta
    defb 078h, 024h      ; runtime $4AD8, stored $6898: #1149 word patch offset $2478; whole 16-bit word += relocation delta
    defb 080h, 024h      ; runtime $4ADA, stored $689A: #1150 word patch offset $2480; whole 16-bit word += relocation delta
    defb 083h, 024h      ; runtime $4ADC, stored $689C: #1151 word patch offset $2483; whole 16-bit word += relocation delta
    defb 086h, 024h      ; runtime $4ADE, stored $689E: #1152 word patch offset $2486; whole 16-bit word += relocation delta
    defb 08ah, 024h      ; runtime $4AE0, stored $68A0: #1153 word patch offset $248A; whole 16-bit word += relocation delta
    defb 08dh, 024h      ; runtime $4AE2, stored $68A2: #1154 word patch offset $248D; whole 16-bit word += relocation delta
    defb 090h, 024h      ; runtime $4AE4, stored $68A4: #1155 word patch offset $2490; whole 16-bit word += relocation delta
    defb 099h, 024h      ; runtime $4AE6, stored $68A6: #1156 word patch offset $2499; whole 16-bit word += relocation delta
    defb 09ch, 024h      ; runtime $4AE8, stored $68A8: #1157 word patch offset $249C; whole 16-bit word += relocation delta
    defb 0a0h, 024h      ; runtime $4AEA, stored $68AA: #1158 word patch offset $24A0; whole 16-bit word += relocation delta
    defb 0a8h, 024h      ; runtime $4AEC, stored $68AC: #1159 word patch offset $24A8; whole 16-bit word += relocation delta
    defb 0b4h, 024h      ; runtime $4AEE, stored $68AE: #1160 word patch offset $24B4; whole 16-bit word += relocation delta
    defb 0b8h, 024h      ; runtime $4AF0, stored $68B0: #1161 word patch offset $24B8; whole 16-bit word += relocation delta
    defb 0d0h, 024h      ; runtime $4AF2, stored $68B2: #1162 word patch offset $24D0; whole 16-bit word += relocation delta
    defb 0d3h, 024h      ; runtime $4AF4, stored $68B4: #1163 word patch offset $24D3; whole 16-bit word += relocation delta
    defb 0d6h, 024h      ; runtime $4AF6, stored $68B6: #1164 word patch offset $24D6; whole 16-bit word += relocation delta
    defb 0d9h, 024h      ; runtime $4AF8, stored $68B8: #1165 word patch offset $24D9; whole 16-bit word += relocation delta
    defb 0dch, 024h      ; runtime $4AFA, stored $68BA: #1166 word patch offset $24DC; whole 16-bit word += relocation delta
    defb 0e0h, 024h      ; runtime $4AFC, stored $68BC: #1167 word patch offset $24E0; whole 16-bit word += relocation delta
    defb 0e5h, 024h      ; runtime $4AFE, stored $68BE: #1168 word patch offset $24E5; whole 16-bit word += relocation delta
    defb 0edh, 024h      ; runtime $4B00, stored $68C0: #1169 word patch offset $24ED; whole 16-bit word += relocation delta
    defb 0fch, 024h      ; runtime $4B02, stored $68C2: #1170 word patch offset $24FC; whole 16-bit word += relocation delta
    defb 00ah, 025h      ; runtime $4B04, stored $68C4: #1171 word patch offset $250A; whole 16-bit word += relocation delta
    defb 02ah, 025h      ; runtime $4B06, stored $68C6: #1172 word patch offset $252A; whole 16-bit word += relocation delta
    defb 02dh, 025h      ; runtime $4B08, stored $68C8: #1173 word patch offset $252D; whole 16-bit word += relocation delta
    defb 032h, 025h      ; runtime $4B0A, stored $68CA: #1174 word patch offset $2532; whole 16-bit word += relocation delta
    defb 035h, 025h      ; runtime $4B0C, stored $68CC: #1175 word patch offset $2535; whole 16-bit word += relocation delta
    defb 038h, 025h      ; runtime $4B0E, stored $68CE: #1176 word patch offset $2538; whole 16-bit word += relocation delta
    defb 048h, 025h      ; runtime $4B10, stored $68D0: #1177 word patch offset $2548; whole 16-bit word += relocation delta
    defb 04dh, 025h      ; runtime $4B12, stored $68D2: #1178 word patch offset $254D; whole 16-bit word += relocation delta
    defb 05eh, 025h      ; runtime $4B14, stored $68D4: #1179 word patch offset $255E; whole 16-bit word += relocation delta
    defb 068h, 025h      ; runtime $4B16, stored $68D6: #1180 word patch offset $2568; whole 16-bit word += relocation delta
    defb 06ch, 025h      ; runtime $4B18, stored $68D8: #1181 word patch offset $256C; whole 16-bit word += relocation delta
    defb 076h, 025h      ; runtime $4B1A, stored $68DA: #1182 word patch offset $2576; whole 16-bit word += relocation delta
    defb 096h, 025h      ; runtime $4B1C, stored $68DC: #1183 word patch offset $2596; whole 16-bit word += relocation delta
    defb 09bh, 025h      ; runtime $4B1E, stored $68DE: #1184 word patch offset $259B; whole 16-bit word += relocation delta
    defb 0abh, 025h      ; runtime $4B20, stored $68E0: #1185 word patch offset $25AB; whole 16-bit word += relocation delta
    defb 0aeh, 025h      ; runtime $4B22, stored $68E2: #1186 word patch offset $25AE; whole 16-bit word += relocation delta
    defb 0b1h, 025h      ; runtime $4B24, stored $68E4: #1187 word patch offset $25B1; whole 16-bit word += relocation delta
    defb 0b6h, 025h      ; runtime $4B26, stored $68E6: #1188 word patch offset $25B6; whole 16-bit word += relocation delta
    defb 0bbh, 025h      ; runtime $4B28, stored $68E8: #1189 word patch offset $25BB; whole 16-bit word += relocation delta
    defb 0c4h, 025h      ; runtime $4B2A, stored $68EA: #1190 word patch offset $25C4; whole 16-bit word += relocation delta
    defb 0cbh, 025h      ; runtime $4B2C, stored $68EC: #1191 word patch offset $25CB; whole 16-bit word += relocation delta
    defb 0d2h, 025h      ; runtime $4B2E, stored $68EE: #1192 word patch offset $25D2; whole 16-bit word += relocation delta
    defb 0fch, 025h      ; runtime $4B30, stored $68F0: #1193 word patch offset $25FC; whole 16-bit word += relocation delta
    defb 000h, 026h      ; runtime $4B32, stored $68F2: #1194 word patch offset $2600; whole 16-bit word += relocation delta
    defb 003h, 026h      ; runtime $4B34, stored $68F4: #1195 word patch offset $2603; whole 16-bit word += relocation delta
    defb 006h, 026h      ; runtime $4B36, stored $68F6: #1196 word patch offset $2606; whole 16-bit word += relocation delta
    defb 009h, 026h      ; runtime $4B38, stored $68F8: #1197 word patch offset $2609; whole 16-bit word += relocation delta
    defb 00ch, 026h      ; runtime $4B3A, stored $68FA: #1198 word patch offset $260C; whole 16-bit word += relocation delta
    defb 00fh, 026h      ; runtime $4B3C, stored $68FC: #1199 word patch offset $260F; whole 16-bit word += relocation delta
    defb 012h, 026h      ; runtime $4B3E, stored $68FE: #1200 word patch offset $2612; whole 16-bit word += relocation delta
    defb 018h, 026h      ; runtime $4B40, stored $6900: #1201 word patch offset $2618; whole 16-bit word += relocation delta
    defb 020h, 026h      ; runtime $4B42, stored $6902: #1202 word patch offset $2620; whole 16-bit word += relocation delta
    defb 023h, 026h      ; runtime $4B44, stored $6904: #1203 word patch offset $2623; whole 16-bit word += relocation delta
    defb 026h, 026h      ; runtime $4B46, stored $6906: #1204 word patch offset $2626; whole 16-bit word += relocation delta
    defb 029h, 026h      ; runtime $4B48, stored $6908: #1205 word patch offset $2629; whole 16-bit word += relocation delta
    defb 02dh, 026h      ; runtime $4B4A, stored $690A: #1206 word patch offset $262D; whole 16-bit word += relocation delta
    defb 039h, 026h      ; runtime $4B4C, stored $690C: #1207 word patch offset $2639; whole 16-bit word += relocation delta
    defb 048h, 026h      ; runtime $4B4E, stored $690E: #1208 word patch offset $2648; whole 16-bit word += relocation delta
    defb 04bh, 026h      ; runtime $4B50, stored $6910: #1209 word patch offset $264B; whole 16-bit word += relocation delta
    defb 059h, 026h      ; runtime $4B52, stored $6912: #1210 word patch offset $2659; whole 16-bit word += relocation delta
    defb 074h, 026h      ; runtime $4B54, stored $6914: #1211 word patch offset $2674; whole 16-bit word += relocation delta
    defb 077h, 026h      ; runtime $4B56, stored $6916: #1212 word patch offset $2677; whole 16-bit word += relocation delta
    defb 096h, 026h      ; runtime $4B58, stored $6918: #1213 word patch offset $2696; whole 16-bit word += relocation delta
    defb 09dh, 026h      ; runtime $4B5A, stored $691A: #1214 word patch offset $269D; whole 16-bit word += relocation delta
    defb 0c2h, 026h      ; runtime $4B5C, stored $691C: #1215 word patch offset $26C2; whole 16-bit word += relocation delta
    defb 0c8h, 026h      ; runtime $4B5E, stored $691E: #1216 word patch offset $26C8; whole 16-bit word += relocation delta
    defb 0ceh, 026h      ; runtime $4B60, stored $6920: #1217 word patch offset $26CE; whole 16-bit word += relocation delta
    defb 0dbh, 026h      ; runtime $4B62, stored $6922: #1218 word patch offset $26DB; whole 16-bit word += relocation delta
    defb 0e3h, 026h      ; runtime $4B64, stored $6924: #1219 word patch offset $26E3; whole 16-bit word += relocation delta
    defb 0f6h, 026h      ; runtime $4B66, stored $6926: #1220 word patch offset $26F6; whole 16-bit word += relocation delta
    defb 0f9h, 026h      ; runtime $4B68, stored $6928: #1221 word patch offset $26F9; whole 16-bit word += relocation delta
    defb 0feh, 026h      ; runtime $4B6A, stored $692A: #1222 word patch offset $26FE; whole 16-bit word += relocation delta
    defb 011h, 027h      ; runtime $4B6C, stored $692C: #1223 word patch offset $2711; whole 16-bit word += relocation delta
    defb 021h, 027h      ; runtime $4B6E, stored $692E: #1224 word patch offset $2721; whole 16-bit word += relocation delta
    defb 024h, 027h      ; runtime $4B70, stored $6930: #1225 word patch offset $2724; whole 16-bit word += relocation delta
    defb 032h, 027h      ; runtime $4B72, stored $6932: #1226 word patch offset $2732; whole 16-bit word += relocation delta
    defb 080h, 027h      ; runtime $4B74, stored $6934: #1227 word patch offset $2780; whole 16-bit word += relocation delta
    defb 084h, 027h      ; runtime $4B76, stored $6936: #1228 word patch offset $2784; whole 16-bit word += relocation delta
    defb 093h, 027h      ; runtime $4B78, stored $6938: #1229 word patch offset $2793; whole 16-bit word += relocation delta
    defb 0a6h, 027h      ; runtime $4B7A, stored $693A: #1230 word patch offset $27A6; whole 16-bit word += relocation delta
    defb 0cah, 027h      ; runtime $4B7C, stored $693C: #1231 word patch offset $27CA; whole 16-bit word += relocation delta
    defb 0cdh, 027h      ; runtime $4B7E, stored $693E: #1232 word patch offset $27CD; whole 16-bit word += relocation delta
    defb 0d2h, 027h      ; runtime $4B80, stored $6940: #1233 word patch offset $27D2; whole 16-bit word += relocation delta
    defb 0dch, 027h      ; runtime $4B82, stored $6942: #1234 word patch offset $27DC; whole 16-bit word += relocation delta
    defb 0e1h, 027h      ; runtime $4B84, stored $6944: #1235 word patch offset $27E1; whole 16-bit word += relocation delta
    defb 0e5h, 027h      ; runtime $4B86, stored $6946: #1236 word patch offset $27E5; whole 16-bit word += relocation delta
    defb 0f2h, 027h      ; runtime $4B88, stored $6948: #1237 word patch offset $27F2; whole 16-bit word += relocation delta
    defb 0f7h, 027h      ; runtime $4B8A, stored $694A: #1238 word patch offset $27F7; whole 16-bit word += relocation delta
    defb 0fch, 027h      ; runtime $4B8C, stored $694C: #1239 word patch offset $27FC; whole 16-bit word += relocation delta
    defb 001h, 028h      ; runtime $4B8E, stored $694E: #1240 word patch offset $2801; whole 16-bit word += relocation delta
    defb 004h, 028h      ; runtime $4B90, stored $6950: #1241 word patch offset $2804; whole 16-bit word += relocation delta
    defb 007h, 028h      ; runtime $4B92, stored $6952: #1242 word patch offset $2807; whole 16-bit word += relocation delta
    defb 01eh, 028h      ; runtime $4B94, stored $6954: #1243 word patch offset $281E; whole 16-bit word += relocation delta
    defb 025h, 028h      ; runtime $4B96, stored $6956: #1244 word patch offset $2825; whole 16-bit word += relocation delta
    defb 035h, 028h      ; runtime $4B98, stored $6958: #1245 word patch offset $2835; whole 16-bit word += relocation delta
    defb 03fh, 028h      ; runtime $4B9A, stored $695A: #1246 word patch offset $283F; whole 16-bit word += relocation delta
    defb 049h, 028h      ; runtime $4B9C, stored $695C: #1247 word patch offset $2849; whole 16-bit word += relocation delta
    defb 04ch, 028h      ; runtime $4B9E, stored $695E: #1248 word patch offset $284C; whole 16-bit word += relocation delta
    defb 056h, 028h      ; runtime $4BA0, stored $6960: #1249 word patch offset $2856; whole 16-bit word += relocation delta
    defb 062h, 028h      ; runtime $4BA2, stored $6962: #1250 word patch offset $2862; whole 16-bit word += relocation delta
    defb 067h, 028h      ; runtime $4BA4, stored $6964: #1251 word patch offset $2867; whole 16-bit word += relocation delta
    defb 06bh, 028h      ; runtime $4BA6, stored $6966: #1252 word patch offset $286B; whole 16-bit word += relocation delta
    defb 06fh, 028h      ; runtime $4BA8, stored $6968: #1253 word patch offset $286F; whole 16-bit word += relocation delta
    defb 08fh, 028h      ; runtime $4BAA, stored $696A: #1254 word patch offset $288F; whole 16-bit word += relocation delta
    defb 092h, 028h      ; runtime $4BAC, stored $696C: #1255 word patch offset $2892; whole 16-bit word += relocation delta
    defb 0dbh, 028h      ; runtime $4BAE, stored $696E: #1256 word patch offset $28DB; whole 16-bit word += relocation delta
    defb 0e3h, 028h      ; runtime $4BB0, stored $6970: #1257 word patch offset $28E3; whole 16-bit word += relocation delta
    defb 0ech, 028h      ; runtime $4BB2, stored $6972: #1258 word patch offset $28EC; whole 16-bit word += relocation delta
    defb 00ch, 029h      ; runtime $4BB4, stored $6974: #1259 word patch offset $290C; whole 16-bit word += relocation delta
    defb 00fh, 029h      ; runtime $4BB6, stored $6976: #1260 word patch offset $290F; whole 16-bit word += relocation delta
    defb 01ah, 029h      ; runtime $4BB8, stored $6978: #1261 word patch offset $291A; whole 16-bit word += relocation delta
    defb 01dh, 029h      ; runtime $4BBA, stored $697A: #1262 word patch offset $291D; whole 16-bit word += relocation delta
    defb 026h, 029h      ; runtime $4BBC, stored $697C: #1263 word patch offset $2926; whole 16-bit word += relocation delta
    defb 02eh, 029h      ; runtime $4BBE, stored $697E: #1264 word patch offset $292E; whole 16-bit word += relocation delta
    defb 039h, 029h      ; runtime $4BC0, stored $6980: #1265 word patch offset $2939; whole 16-bit word += relocation delta
    defb 04bh, 029h      ; runtime $4BC2, stored $6982: #1266 word patch offset $294B; whole 16-bit word += relocation delta
    defb 055h, 029h      ; runtime $4BC4, stored $6984: #1267 word patch offset $2955; whole 16-bit word += relocation delta
    defb 05bh, 029h      ; runtime $4BC6, stored $6986: #1268 word patch offset $295B; whole 16-bit word += relocation delta
    defb 072h, 029h      ; runtime $4BC8, stored $6988: #1269 word patch offset $2972; whole 16-bit word += relocation delta
    defb 075h, 029h      ; runtime $4BCA, stored $698A: #1270 word patch offset $2975; whole 16-bit word += relocation delta
    defb 080h, 029h      ; runtime $4BCC, stored $698C: #1271 word patch offset $2980; whole 16-bit word += relocation delta
    defb 093h, 029h      ; runtime $4BCE, stored $698E: #1272 word patch offset $2993; whole 16-bit word += relocation delta
    defb 096h, 029h      ; runtime $4BD0, stored $6990: #1273 word patch offset $2996; whole 16-bit word += relocation delta
    defb 09ch, 029h      ; runtime $4BD2, stored $6992: #1274 word patch offset $299C; whole 16-bit word += relocation delta
    defb 0a7h, 029h      ; runtime $4BD4, stored $6994: #1275 word patch offset $29A7; whole 16-bit word += relocation delta
    defb 0afh, 029h      ; runtime $4BD6, stored $6996: #1276 word patch offset $29AF; whole 16-bit word += relocation delta
    defb 0bah, 029h      ; runtime $4BD8, stored $6998: #1277 word patch offset $29BA; whole 16-bit word += relocation delta
    defb 0c3h, 029h      ; runtime $4BDA, stored $699A: #1278 word patch offset $29C3; whole 16-bit word += relocation delta
    defb 0cah, 029h      ; runtime $4BDC, stored $699C: #1279 word patch offset $29CA; whole 16-bit word += relocation delta
    defb 0d2h, 029h      ; runtime $4BDE, stored $699E: #1280 word patch offset $29D2; whole 16-bit word += relocation delta
    defb 0d6h, 029h      ; runtime $4BE0, stored $69A0: #1281 word patch offset $29D6; whole 16-bit word += relocation delta
    defb 0dbh, 029h      ; runtime $4BE2, stored $69A2: #1282 word patch offset $29DB; whole 16-bit word += relocation delta
    defb 0dfh, 029h      ; runtime $4BE4, stored $69A4: #1283 word patch offset $29DF; whole 16-bit word += relocation delta
    defb 0f0h, 029h      ; runtime $4BE6, stored $69A6: #1284 word patch offset $29F0; whole 16-bit word += relocation delta
    defb 039h, 02ah      ; runtime $4BE8, stored $69A8: #1285 word patch offset $2A39; whole 16-bit word += relocation delta
    defb 042h, 02ah      ; runtime $4BEA, stored $69AA: #1286 word patch offset $2A42; whole 16-bit word += relocation delta
    defb 04eh, 02ah      ; runtime $4BEC, stored $69AC: #1287 word patch offset $2A4E; whole 16-bit word += relocation delta
    defb 051h, 02ah      ; runtime $4BEE, stored $69AE: #1288 word patch offset $2A51; whole 16-bit word += relocation delta
    defb 055h, 02ah      ; runtime $4BF0, stored $69B0: #1289 word patch offset $2A55; whole 16-bit word += relocation delta
    defb 0a5h, 02ah      ; runtime $4BF2, stored $69B2: #1290 word patch offset $2AA5; whole 16-bit word += relocation delta
    defb 0afh, 02ah      ; runtime $4BF4, stored $69B4: #1291 word patch offset $2AAF; whole 16-bit word += relocation delta
    defb 0dah, 02ah      ; runtime $4BF6, stored $69B6: #1292 word patch offset $2ADA; whole 16-bit word += relocation delta
    defb 0fch, 02ah      ; runtime $4BF8, stored $69B8: #1293 word patch offset $2AFC; whole 16-bit word += relocation delta
    defb 00bh, 02bh      ; runtime $4BFA, stored $69BA: #1294 word patch offset $2B0B; whole 16-bit word += relocation delta
    defb 016h, 02bh      ; runtime $4BFC, stored $69BC: #1295 word patch offset $2B16; whole 16-bit word += relocation delta
    defb 01fh, 02bh      ; runtime $4BFE, stored $69BE: #1296 word patch offset $2B1F; whole 16-bit word += relocation delta
    defb 022h, 02bh      ; runtime $4C00, stored $69C0: #1297 word patch offset $2B22; whole 16-bit word += relocation delta
    defb 028h, 02bh      ; runtime $4C02, stored $69C2: #1298 word patch offset $2B28; whole 16-bit word += relocation delta
    defb 02bh, 02bh      ; runtime $4C04, stored $69C4: #1299 word patch offset $2B2B; whole 16-bit word += relocation delta
    defb 02fh, 02bh      ; runtime $4C06, stored $69C6: #1300 word patch offset $2B2F; whole 16-bit word += relocation delta
    defb 034h, 02bh      ; runtime $4C08, stored $69C8: #1301 word patch offset $2B34; whole 16-bit word += relocation delta
    defb 03dh, 02bh      ; runtime $4C0A, stored $69CA: #1302 word patch offset $2B3D; whole 16-bit word += relocation delta
    defb 042h, 02bh      ; runtime $4C0C, stored $69CC: #1303 word patch offset $2B42; whole 16-bit word += relocation delta
    defb 046h, 02bh      ; runtime $4C0E, stored $69CE: #1304 word patch offset $2B46; whole 16-bit word += relocation delta
    defb 04bh, 02bh      ; runtime $4C10, stored $69D0: #1305 word patch offset $2B4B; whole 16-bit word += relocation delta
    defb 056h, 02bh      ; runtime $4C12, stored $69D2: #1306 word patch offset $2B56; whole 16-bit word += relocation delta
    defb 06ah, 02bh      ; runtime $4C14, stored $69D4: #1307 word patch offset $2B6A; whole 16-bit word += relocation delta
    defb 06eh, 02bh      ; runtime $4C16, stored $69D6: #1308 word patch offset $2B6E; whole 16-bit word += relocation delta
    defb 079h, 02bh      ; runtime $4C18, stored $69D8: #1309 word patch offset $2B79; whole 16-bit word += relocation delta
    defb 087h, 02bh      ; runtime $4C1A, stored $69DA: #1310 word patch offset $2B87; whole 16-bit word += relocation delta
    defb 091h, 02bh      ; runtime $4C1C, stored $69DC: #1311 word patch offset $2B91; whole 16-bit word += relocation delta
    defb 097h, 02bh      ; runtime $4C1E, stored $69DE: #1312 word patch offset $2B97; whole 16-bit word += relocation delta
    defb 09ah, 02bh      ; runtime $4C20, stored $69E0: #1313 word patch offset $2B9A; whole 16-bit word += relocation delta
    defb 0a3h, 02bh      ; runtime $4C22, stored $69E2: #1314 word patch offset $2BA3; whole 16-bit word += relocation delta
    defb 0bdh, 02bh      ; runtime $4C24, stored $69E4: #1315 word patch offset $2BBD; whole 16-bit word += relocation delta
    defb 0c6h, 02bh      ; runtime $4C26, stored $69E6: #1316 word patch offset $2BC6; whole 16-bit word += relocation delta
    defb 0d4h, 02bh      ; runtime $4C28, stored $69E8: #1317 word patch offset $2BD4; whole 16-bit word += relocation delta
    defb 0e9h, 02bh      ; runtime $4C2A, stored $69EA: #1318 word patch offset $2BE9; whole 16-bit word += relocation delta
    defb 0edh, 02bh      ; runtime $4C2C, stored $69EC: #1319 word patch offset $2BED; whole 16-bit word += relocation delta
    defb 0f1h, 02bh      ; runtime $4C2E, stored $69EE: #1320 word patch offset $2BF1; whole 16-bit word += relocation delta
    defb 0feh, 02bh      ; runtime $4C30, stored $69F0: #1321 word patch offset $2BFE; whole 16-bit word += relocation delta
    defb 009h, 02ch      ; runtime $4C32, stored $69F2: #1322 word patch offset $2C09; whole 16-bit word += relocation delta
    defb 02ah, 02ch      ; runtime $4C34, stored $69F4: #1323 word patch offset $2C2A; whole 16-bit word += relocation delta
    defb 038h, 02ch      ; runtime $4C36, stored $69F6: #1324 word patch offset $2C38; whole 16-bit word += relocation delta
    defb 041h, 02ch      ; runtime $4C38, stored $69F8: #1325 word patch offset $2C41; whole 16-bit word += relocation delta
    defb 0a6h, 02ch      ; runtime $4C3A, stored $69FA: #1326 word patch offset $2CA6; whole 16-bit word += relocation delta
    defb 0b1h, 02ch      ; runtime $4C3C, stored $69FC: #1327 word patch offset $2CB1; whole 16-bit word += relocation delta
    defb 0bdh, 02ch      ; runtime $4C3E, stored $69FE: #1328 word patch offset $2CBD; whole 16-bit word += relocation delta
    defb 0cbh, 02ch      ; runtime $4C40, stored $6A00: #1329 word patch offset $2CCB; whole 16-bit word += relocation delta
    defb 006h, 02dh      ; runtime $4C42, stored $6A02: #1330 word patch offset $2D06; whole 16-bit word += relocation delta
    defb 00bh, 02dh      ; runtime $4C44, stored $6A04: #1331 word patch offset $2D0B; whole 16-bit word += relocation delta
    defb 010h, 02dh      ; runtime $4C46, stored $6A06: #1332 word patch offset $2D10; whole 16-bit word += relocation delta
    defb 013h, 02dh      ; runtime $4C48, stored $6A08: #1333 word patch offset $2D13; whole 16-bit word += relocation delta
    defb 01eh, 02dh      ; runtime $4C4A, stored $6A0A: #1334 word patch offset $2D1E; whole 16-bit word += relocation delta
    defb 02ch, 02dh      ; runtime $4C4C, stored $6A0C: #1335 word patch offset $2D2C; whole 16-bit word += relocation delta
    defb 030h, 02dh      ; runtime $4C4E, stored $6A0E: #1336 word patch offset $2D30; whole 16-bit word += relocation delta
    defb 037h, 02dh      ; runtime $4C50, stored $6A10: #1337 word patch offset $2D37; whole 16-bit word += relocation delta
    defb 043h, 02dh      ; runtime $4C52, stored $6A12: #1338 word patch offset $2D43; whole 16-bit word += relocation delta
    defb 048h, 02dh      ; runtime $4C54, stored $6A14: #1339 word patch offset $2D48; whole 16-bit word += relocation delta
    defb 05bh, 02dh      ; runtime $4C56, stored $6A16: #1340 word patch offset $2D5B; whole 16-bit word += relocation delta
    defb 076h, 02dh      ; runtime $4C58, stored $6A18: #1341 word patch offset $2D76; whole 16-bit word += relocation delta
    defb 07ah, 02dh      ; runtime $4C5A, stored $6A1A: #1342 word patch offset $2D7A; whole 16-bit word += relocation delta
    defb 080h, 02dh      ; runtime $4C5C, stored $6A1C: #1343 word patch offset $2D80; whole 16-bit word += relocation delta
    defb 08fh, 02dh      ; runtime $4C5E, stored $6A1E: #1344 word patch offset $2D8F; whole 16-bit word += relocation delta
    defb 092h, 02dh      ; runtime $4C60, stored $6A20: #1345 word patch offset $2D92; whole 16-bit word += relocation delta
    defb 095h, 02dh      ; runtime $4C62, stored $6A22: #1346 word patch offset $2D95; whole 16-bit word += relocation delta
    defb 098h, 02dh      ; runtime $4C64, stored $6A24: #1347 word patch offset $2D98; whole 16-bit word += relocation delta
    defb 09eh, 02dh      ; runtime $4C66, stored $6A26: #1348 word patch offset $2D9E; whole 16-bit word += relocation delta
    defb 0aah, 02dh      ; runtime $4C68, stored $6A28: #1349 word patch offset $2DAA; whole 16-bit word += relocation delta
    defb 0d3h, 02dh      ; runtime $4C6A, stored $6A2A: #1350 word patch offset $2DD3; whole 16-bit word += relocation delta
    defb 0dch, 02dh      ; runtime $4C6C, stored $6A2C: #1351 word patch offset $2DDC; whole 16-bit word += relocation delta
    defb 0e9h, 02dh      ; runtime $4C6E, stored $6A2E: #1352 word patch offset $2DE9; whole 16-bit word += relocation delta
    defb 0edh, 02dh      ; runtime $4C70, stored $6A30: #1353 word patch offset $2DED; whole 16-bit word += relocation delta
    defb 0f0h, 02dh      ; runtime $4C72, stored $6A32: #1354 word patch offset $2DF0; whole 16-bit word += relocation delta
    defb 0f4h, 02dh      ; runtime $4C74, stored $6A34: #1355 word patch offset $2DF4; whole 16-bit word += relocation delta
    defb 0fah, 02dh      ; runtime $4C76, stored $6A36: #1356 word patch offset $2DFA; whole 16-bit word += relocation delta
    defb 0fdh, 02dh      ; runtime $4C78, stored $6A38: #1357 word patch offset $2DFD; whole 16-bit word += relocation delta
    defb 000h, 02eh      ; runtime $4C7A, stored $6A3A: #1358 word patch offset $2E00; whole 16-bit word += relocation delta
    defb 008h, 02eh      ; runtime $4C7C, stored $6A3C: #1359 word patch offset $2E08; whole 16-bit word += relocation delta
    defb 011h, 02eh      ; runtime $4C7E, stored $6A3E: #1360 word patch offset $2E11; whole 16-bit word += relocation delta
    defb 017h, 02eh      ; runtime $4C80, stored $6A40: #1361 word patch offset $2E17; whole 16-bit word += relocation delta
    defb 01dh, 02eh      ; runtime $4C82, stored $6A42: #1362 word patch offset $2E1D; whole 16-bit word += relocation delta
    defb 028h, 02eh      ; runtime $4C84, stored $6A44: #1363 word patch offset $2E28; whole 16-bit word += relocation delta
    defb 03ah, 02eh      ; runtime $4C86, stored $6A46: #1364 word patch offset $2E3A; whole 16-bit word += relocation delta
    defb 043h, 02eh      ; runtime $4C88, stored $6A48: #1365 word patch offset $2E43; whole 16-bit word += relocation delta
    defb 066h, 02eh      ; runtime $4C8A, stored $6A4A: #1366 word patch offset $2E66; whole 16-bit word += relocation delta
    defb 077h, 02eh      ; runtime $4C8C, stored $6A4C: #1367 word patch offset $2E77; whole 16-bit word += relocation delta
    defb 07ch, 02eh      ; runtime $4C8E, stored $6A4E: #1368 word patch offset $2E7C; whole 16-bit word += relocation delta
    defb 082h, 02eh      ; runtime $4C90, stored $6A50: #1369 word patch offset $2E82; whole 16-bit word += relocation delta
    defb 08ah, 02eh      ; runtime $4C92, stored $6A52: #1370 word patch offset $2E8A; whole 16-bit word += relocation delta
    defb 090h, 02eh      ; runtime $4C94, stored $6A54: #1371 word patch offset $2E90; whole 16-bit word += relocation delta
    defb 096h, 02eh      ; runtime $4C96, stored $6A56: #1372 word patch offset $2E96; whole 16-bit word += relocation delta
    defb 09bh, 02eh      ; runtime $4C98, stored $6A58: #1373 word patch offset $2E9B; whole 16-bit word += relocation delta
    defb 0bbh, 02eh      ; runtime $4C9A, stored $6A5A: #1374 word patch offset $2EBB; whole 16-bit word += relocation delta
    defb 0cfh, 02eh      ; runtime $4C9C, stored $6A5C: #1375 word patch offset $2ECF; whole 16-bit word += relocation delta
    defb 0ech, 02eh      ; runtime $4C9E, stored $6A5E: #1376 word patch offset $2EEC; whole 16-bit word += relocation delta
    defb 0f0h, 02eh      ; runtime $4CA0, stored $6A60: #1377 word patch offset $2EF0; whole 16-bit word += relocation delta
    defb 004h, 02fh      ; runtime $4CA2, stored $6A62: #1378 word patch offset $2F04; whole 16-bit word += relocation delta
    defb 00fh, 02fh      ; runtime $4CA4, stored $6A64: #1379 word patch offset $2F0F; whole 16-bit word += relocation delta
    defb 01dh, 02fh      ; runtime $4CA6, stored $6A66: #1380 word patch offset $2F1D; whole 16-bit word += relocation delta
    defb 020h, 02fh      ; runtime $4CA8, stored $6A68: #1381 word patch offset $2F20; whole 16-bit word += relocation delta
    defb 023h, 02fh      ; runtime $4CAA, stored $6A6A: #1382 word patch offset $2F23; whole 16-bit word += relocation delta
    defb 026h, 02fh      ; runtime $4CAC, stored $6A6C: #1383 word patch offset $2F26; whole 16-bit word += relocation delta
    defb 029h, 02fh      ; runtime $4CAE, stored $6A6E: #1384 word patch offset $2F29; whole 16-bit word += relocation delta
    defb 02ch, 02fh      ; runtime $4CB0, stored $6A70: #1385 word patch offset $2F2C; whole 16-bit word += relocation delta
    defb 02fh, 02fh      ; runtime $4CB2, stored $6A72: #1386 word patch offset $2F2F; whole 16-bit word += relocation delta
    defb 04ah, 02fh      ; runtime $4CB4, stored $6A74: #1387 word patch offset $2F4A; whole 16-bit word += relocation delta
    defb 04dh, 02fh      ; runtime $4CB6, stored $6A76: #1388 word patch offset $2F4D; whole 16-bit word += relocation delta
    defb 050h, 02fh      ; runtime $4CB8, stored $6A78: #1389 word patch offset $2F50; whole 16-bit word += relocation delta
    defb 055h, 02fh      ; runtime $4CBA, stored $6A7A: #1390 word patch offset $2F55; whole 16-bit word += relocation delta
    defb 05ah, 02fh      ; runtime $4CBC, stored $6A7C: #1391 word patch offset $2F5A; whole 16-bit word += relocation delta
    defb 05dh, 02fh      ; runtime $4CBE, stored $6A7E: #1392 word patch offset $2F5D; whole 16-bit word += relocation delta
    defb 067h, 02fh      ; runtime $4CC0, stored $6A80: #1393 word patch offset $2F67; whole 16-bit word += relocation delta
    defb 06ah, 02fh      ; runtime $4CC2, stored $6A82: #1394 word patch offset $2F6A; whole 16-bit word += relocation delta
    defb 06dh, 02fh      ; runtime $4CC4, stored $6A84: #1395 word patch offset $2F6D; whole 16-bit word += relocation delta
    defb 070h, 02fh      ; runtime $4CC6, stored $6A86: #1396 word patch offset $2F70; whole 16-bit word += relocation delta
    defb 073h, 02fh      ; runtime $4CC8, stored $6A88: #1397 word patch offset $2F73; whole 16-bit word += relocation delta
    defb 076h, 02fh      ; runtime $4CCA, stored $6A8A: #1398 word patch offset $2F76; whole 16-bit word += relocation delta
    defb 079h, 02fh      ; runtime $4CCC, stored $6A8C: #1399 word patch offset $2F79; whole 16-bit word += relocation delta
    defb 07fh, 02fh      ; runtime $4CCE, stored $6A8E: #1400 word patch offset $2F7F; whole 16-bit word += relocation delta
    defb 087h, 02fh      ; runtime $4CD0, stored $6A90: #1401 word patch offset $2F87; whole 16-bit word += relocation delta
    defb 097h, 02fh      ; runtime $4CD2, stored $6A92: #1402 word patch offset $2F97; whole 16-bit word += relocation delta
    defb 0a0h, 02fh      ; runtime $4CD4, stored $6A94: #1403 word patch offset $2FA0; whole 16-bit word += relocation delta
    defb 0a6h, 02fh      ; runtime $4CD6, stored $6A96: #1404 word patch offset $2FA6; whole 16-bit word += relocation delta
    defb 0b7h, 02fh      ; runtime $4CD8, stored $6A98: #1405 word patch offset $2FB7; whole 16-bit word += relocation delta
    defb 0bfh, 02fh      ; runtime $4CDA, stored $6A9A: #1406 word patch offset $2FBF; whole 16-bit word += relocation delta
    defb 0d1h, 02fh      ; runtime $4CDC, stored $6A9C: #1407 word patch offset $2FD1; whole 16-bit word += relocation delta
    defb 0d7h, 02fh      ; runtime $4CDE, stored $6A9E: #1408 word patch offset $2FD7; whole 16-bit word += relocation delta
    defb 0e4h, 02fh      ; runtime $4CE0, stored $6AA0: #1409 word patch offset $2FE4; whole 16-bit word += relocation delta
    defb 0e8h, 02fh      ; runtime $4CE2, stored $6AA2: #1410 word patch offset $2FE8; whole 16-bit word += relocation delta
    defb 0ebh, 02fh      ; runtime $4CE4, stored $6AA4: #1411 word patch offset $2FEB; whole 16-bit word += relocation delta
    defb 0eeh, 02fh      ; runtime $4CE6, stored $6AA6: #1412 word patch offset $2FEE; whole 16-bit word += relocation delta
    defb 0f1h, 02fh      ; runtime $4CE8, stored $6AA8: #1413 word patch offset $2FF1; whole 16-bit word += relocation delta
    defb 0f4h, 02fh      ; runtime $4CEA, stored $6AAA: #1414 word patch offset $2FF4; whole 16-bit word += relocation delta
    defb 0f7h, 02fh      ; runtime $4CEC, stored $6AAC: #1415 word patch offset $2FF7; whole 16-bit word += relocation delta
    defb 0fah, 02fh      ; runtime $4CEE, stored $6AAE: #1416 word patch offset $2FFA; whole 16-bit word += relocation delta
    defb 0fdh, 02fh      ; runtime $4CF0, stored $6AB0: #1417 word patch offset $2FFD; whole 16-bit word += relocation delta
    defb 0f3h, 030h      ; runtime $4CF2, stored $6AB2: #1418 word patch offset $30F3; whole 16-bit word += relocation delta
    defb 0f9h, 030h      ; runtime $4CF4, stored $6AB4: #1419 word patch offset $30F9; whole 16-bit word += relocation delta
    defb 0fbh, 030h      ; runtime $4CF6, stored $6AB6: #1420 word patch offset $30FB; whole 16-bit word += relocation delta
    defb 0fdh, 030h      ; runtime $4CF8, stored $6AB8: #1421 word patch offset $30FD; whole 16-bit word += relocation delta
    defb 0ffh, 030h      ; runtime $4CFA, stored $6ABA: #1422 word patch offset $30FF; whole 16-bit word += relocation delta

; Table summary: 1422 records = 1404 whole-word, 9 split-low, 9 split-high.
