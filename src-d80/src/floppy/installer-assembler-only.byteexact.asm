; PROMETHEUS D40/D80 assembler-only distribution installer (2100 bytes)
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
    defb 001h, 054h, 006h                ; runtime $4017, stored $5DD7: ld bc,$0654
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
    defb 050h, 052h, 04fh, 04dh, 045h, 054h, 048h, 045h, 055h, 053h, 020h, 064h, 069h, 073h, 06bh, 020h, 076h, 065h, 072h, 073h, 069h, 06fh, 06eh, 020h, 0c2h ; runtime $4072: "PROMETHEUS disk version B"

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
    defb 001h, 050h, 02dh                ; runtime $4150, stored $5F10: ld bc,$2d50
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
; This assembler-only installer moves exactly $2D50 bytes before applying the table.
    defb 001h, 000h      ; runtime $41E0, stored $5FA0: #0001 word patch offset $0001; whole 16-bit word += relocation delta
    defb 004h, 000h      ; runtime $41E2, stored $5FA2: #0002 word patch offset $0004; whole 16-bit word += relocation delta
    defb 00fh, 000h      ; runtime $41E4, stored $5FA4: #0003 word patch offset $000F; whole 16-bit word += relocation delta
    defb 015h, 080h      ; runtime $41E6, stored $5FA6: #0004 low  patch offset $0015; split LOW byte += delta low; save carry
    defb 018h, 040h      ; runtime $41E8, stored $5FA8: #0005 high patch offset $0018; split HIGH byte += delta high + saved carry
    defb 01ah, 000h      ; runtime $41EA, stored $5FAA: #0006 word patch offset $001A; whole 16-bit word += relocation delta
    defb 020h, 080h      ; runtime $41EC, stored $5FAC: #0007 low  patch offset $0020; split LOW byte += delta low; save carry
    defb 023h, 040h      ; runtime $41EE, stored $5FAE: #0008 high patch offset $0023; split HIGH byte += delta high + saved carry
    defb 025h, 000h      ; runtime $41F0, stored $5FB0: #0009 word patch offset $0025; whole 16-bit word += relocation delta
    defb 028h, 000h      ; runtime $41F2, stored $5FB2: #0010 word patch offset $0028; whole 16-bit word += relocation delta
    defb 02eh, 080h      ; runtime $41F4, stored $5FB4: #0011 low  patch offset $002E; split LOW byte += delta low; save carry
    defb 031h, 040h      ; runtime $41F6, stored $5FB6: #0012 high patch offset $0031; split HIGH byte += delta high + saved carry
    defb 033h, 000h      ; runtime $41F8, stored $5FB8: #0013 word patch offset $0033; whole 16-bit word += relocation delta
    defb 039h, 080h      ; runtime $41FA, stored $5FBA: #0014 low  patch offset $0039; split LOW byte += delta low; save carry
    defb 03ch, 040h      ; runtime $41FC, stored $5FBC: #0015 high patch offset $003C; split HIGH byte += delta high + saved carry
    defb 03eh, 000h      ; runtime $41FE, stored $5FBE: #0016 word patch offset $003E; whole 16-bit word += relocation delta
    defb 044h, 080h      ; runtime $4200, stored $5FC0: #0017 low  patch offset $0044; split LOW byte += delta low; save carry
    defb 047h, 040h      ; runtime $4202, stored $5FC2: #0018 high patch offset $0047; split HIGH byte += delta high + saved carry
    defb 049h, 000h      ; runtime $4204, stored $5FC4: #0019 word patch offset $0049; whole 16-bit word += relocation delta
    defb 04ch, 000h      ; runtime $4206, stored $5FC6: #0020 word patch offset $004C; whole 16-bit word += relocation delta
    defb 065h, 000h      ; runtime $4208, stored $5FC8: #0021 word patch offset $0065; whole 16-bit word += relocation delta
    defb 078h, 000h      ; runtime $420A, stored $5FCA: #0022 word patch offset $0078; whole 16-bit word += relocation delta
    defb 07fh, 000h      ; runtime $420C, stored $5FCC: #0023 word patch offset $007F; whole 16-bit word += relocation delta
    defb 08bh, 000h      ; runtime $420E, stored $5FCE: #0024 word patch offset $008B; whole 16-bit word += relocation delta
    defb 094h, 000h      ; runtime $4210, stored $5FD0: #0025 word patch offset $0094; whole 16-bit word += relocation delta
    defb 09bh, 000h      ; runtime $4212, stored $5FD2: #0026 word patch offset $009B; whole 16-bit word += relocation delta
    defb 0a3h, 000h      ; runtime $4214, stored $5FD4: #0027 word patch offset $00A3; whole 16-bit word += relocation delta
    defb 0b4h, 000h      ; runtime $4216, stored $5FD6: #0028 word patch offset $00B4; whole 16-bit word += relocation delta
    defb 0b7h, 000h      ; runtime $4218, stored $5FD8: #0029 word patch offset $00B7; whole 16-bit word += relocation delta
    defb 0bah, 000h      ; runtime $421A, stored $5FDA: #0030 word patch offset $00BA; whole 16-bit word += relocation delta
    defb 0bdh, 000h      ; runtime $421C, stored $5FDC: #0031 word patch offset $00BD; whole 16-bit word += relocation delta
    defb 0c4h, 000h      ; runtime $421E, stored $5FDE: #0032 word patch offset $00C4; whole 16-bit word += relocation delta
    defb 0c7h, 000h      ; runtime $4220, stored $5FE0: #0033 word patch offset $00C7; whole 16-bit word += relocation delta
    defb 0cah, 000h      ; runtime $4222, stored $5FE2: #0034 word patch offset $00CA; whole 16-bit word += relocation delta
    defb 0cdh, 000h      ; runtime $4224, stored $5FE4: #0035 word patch offset $00CD; whole 16-bit word += relocation delta
    defb 0d0h, 000h      ; runtime $4226, stored $5FE6: #0036 word patch offset $00D0; whole 16-bit word += relocation delta
    defb 0dfh, 000h      ; runtime $4228, stored $5FE8: #0037 word patch offset $00DF; whole 16-bit word += relocation delta
    defb 0e3h, 000h      ; runtime $422A, stored $5FEA: #0038 word patch offset $00E3; whole 16-bit word += relocation delta
    defb 0e6h, 000h      ; runtime $422C, stored $5FEC: #0039 word patch offset $00E6; whole 16-bit word += relocation delta
    defb 0f6h, 000h      ; runtime $422E, stored $5FEE: #0040 word patch offset $00F6; whole 16-bit word += relocation delta
    defb 00fh, 001h      ; runtime $4230, stored $5FF0: #0041 word patch offset $010F; whole 16-bit word += relocation delta
    defb 016h, 001h      ; runtime $4232, stored $5FF2: #0042 word patch offset $0116; whole 16-bit word += relocation delta
    defb 01ah, 001h      ; runtime $4234, stored $5FF4: #0043 word patch offset $011A; whole 16-bit word += relocation delta
    defb 021h, 001h      ; runtime $4236, stored $5FF6: #0044 word patch offset $0121; whole 16-bit word += relocation delta
    defb 025h, 001h      ; runtime $4238, stored $5FF8: #0045 word patch offset $0125; whole 16-bit word += relocation delta
    defb 028h, 001h      ; runtime $423A, stored $5FFA: #0046 word patch offset $0128; whole 16-bit word += relocation delta
    defb 02bh, 001h      ; runtime $423C, stored $5FFC: #0047 word patch offset $012B; whole 16-bit word += relocation delta
    defb 030h, 001h      ; runtime $423E, stored $5FFE: #0048 word patch offset $0130; whole 16-bit word += relocation delta
    defb 033h, 001h      ; runtime $4240, stored $6000: #0049 word patch offset $0133; whole 16-bit word += relocation delta
    defb 03eh, 001h      ; runtime $4242, stored $6002: #0050 word patch offset $013E; whole 16-bit word += relocation delta
    defb 041h, 001h      ; runtime $4244, stored $6004: #0051 word patch offset $0141; whole 16-bit word += relocation delta
    defb 044h, 001h      ; runtime $4246, stored $6006: #0052 word patch offset $0144; whole 16-bit word += relocation delta
    defb 049h, 001h      ; runtime $4248, stored $6008: #0053 word patch offset $0149; whole 16-bit word += relocation delta
    defb 04dh, 001h      ; runtime $424A, stored $600A: #0054 word patch offset $014D; whole 16-bit word += relocation delta
    defb 050h, 001h      ; runtime $424C, stored $600C: #0055 word patch offset $0150; whole 16-bit word += relocation delta
    defb 053h, 001h      ; runtime $424E, stored $600E: #0056 word patch offset $0153; whole 16-bit word += relocation delta
    defb 056h, 001h      ; runtime $4250, stored $6010: #0057 word patch offset $0156; whole 16-bit word += relocation delta
    defb 05ch, 001h      ; runtime $4252, stored $6012: #0058 word patch offset $015C; whole 16-bit word += relocation delta
    defb 063h, 001h      ; runtime $4254, stored $6014: #0059 word patch offset $0163; whole 16-bit word += relocation delta
    defb 06ah, 001h      ; runtime $4256, stored $6016: #0060 word patch offset $016A; whole 16-bit word += relocation delta
    defb 081h, 001h      ; runtime $4258, stored $6018: #0061 word patch offset $0181; whole 16-bit word += relocation delta
    defb 085h, 001h      ; runtime $425A, stored $601A: #0062 word patch offset $0185; whole 16-bit word += relocation delta
    defb 088h, 001h      ; runtime $425C, stored $601C: #0063 word patch offset $0188; whole 16-bit word += relocation delta
    defb 094h, 001h      ; runtime $425E, stored $601E: #0064 word patch offset $0194; whole 16-bit word += relocation delta
    defb 09bh, 001h      ; runtime $4260, stored $6020: #0065 word patch offset $019B; whole 16-bit word += relocation delta
    defb 09eh, 001h      ; runtime $4262, stored $6022: #0066 word patch offset $019E; whole 16-bit word += relocation delta
    defb 0b0h, 001h      ; runtime $4264, stored $6024: #0067 word patch offset $01B0; whole 16-bit word += relocation delta
    defb 0bch, 001h      ; runtime $4266, stored $6026: #0068 word patch offset $01BC; whole 16-bit word += relocation delta
    defb 0c3h, 001h      ; runtime $4268, stored $6028: #0069 word patch offset $01C3; whole 16-bit word += relocation delta
    defb 0c7h, 001h      ; runtime $426A, stored $602A: #0070 word patch offset $01C7; whole 16-bit word += relocation delta
    defb 003h, 002h      ; runtime $426C, stored $602C: #0071 word patch offset $0203; whole 16-bit word += relocation delta
    defb 009h, 002h      ; runtime $426E, stored $602E: #0072 word patch offset $0209; whole 16-bit word += relocation delta
    defb 00dh, 002h      ; runtime $4270, stored $6030: #0073 word patch offset $020D; whole 16-bit word += relocation delta
    defb 010h, 002h      ; runtime $4272, stored $6032: #0074 word patch offset $0210; whole 16-bit word += relocation delta
    defb 013h, 002h      ; runtime $4274, stored $6034: #0075 word patch offset $0213; whole 16-bit word += relocation delta
    defb 016h, 002h      ; runtime $4276, stored $6036: #0076 word patch offset $0216; whole 16-bit word += relocation delta
    defb 019h, 002h      ; runtime $4278, stored $6038: #0077 word patch offset $0219; whole 16-bit word += relocation delta
    defb 020h, 002h      ; runtime $427A, stored $603A: #0078 word patch offset $0220; whole 16-bit word += relocation delta
    defb 023h, 002h      ; runtime $427C, stored $603C: #0079 word patch offset $0223; whole 16-bit word += relocation delta
    defb 026h, 002h      ; runtime $427E, stored $603E: #0080 word patch offset $0226; whole 16-bit word += relocation delta
    defb 029h, 002h      ; runtime $4280, stored $6040: #0081 word patch offset $0229; whole 16-bit word += relocation delta
    defb 02ch, 002h      ; runtime $4282, stored $6042: #0082 word patch offset $022C; whole 16-bit word += relocation delta
    defb 05fh, 002h      ; runtime $4284, stored $6044: #0083 word patch offset $025F; whole 16-bit word += relocation delta
    defb 061h, 002h      ; runtime $4286, stored $6046: #0084 word patch offset $0261; whole 16-bit word += relocation delta
    defb 063h, 002h      ; runtime $4288, stored $6048: #0085 word patch offset $0263; whole 16-bit word += relocation delta
    defb 065h, 002h      ; runtime $428A, stored $604A: #0086 word patch offset $0265; whole 16-bit word += relocation delta
    defb 067h, 002h      ; runtime $428C, stored $604C: #0087 word patch offset $0267; whole 16-bit word += relocation delta
    defb 069h, 002h      ; runtime $428E, stored $604E: #0088 word patch offset $0269; whole 16-bit word += relocation delta
    defb 06bh, 002h      ; runtime $4290, stored $6050: #0089 word patch offset $026B; whole 16-bit word += relocation delta
    defb 06dh, 002h      ; runtime $4292, stored $6052: #0090 word patch offset $026D; whole 16-bit word += relocation delta
    defb 06fh, 002h      ; runtime $4294, stored $6054: #0091 word patch offset $026F; whole 16-bit word += relocation delta
    defb 071h, 002h      ; runtime $4296, stored $6056: #0092 word patch offset $0271; whole 16-bit word += relocation delta
    defb 073h, 002h      ; runtime $4298, stored $6058: #0093 word patch offset $0273; whole 16-bit word += relocation delta
    defb 075h, 002h      ; runtime $429A, stored $605A: #0094 word patch offset $0275; whole 16-bit word += relocation delta
    defb 077h, 002h      ; runtime $429C, stored $605C: #0095 word patch offset $0277; whole 16-bit word += relocation delta
    defb 079h, 002h      ; runtime $429E, stored $605E: #0096 word patch offset $0279; whole 16-bit word += relocation delta
    defb 07fh, 002h      ; runtime $42A0, stored $6060: #0097 word patch offset $027F; whole 16-bit word += relocation delta
    defb 081h, 002h      ; runtime $42A2, stored $6062: #0098 word patch offset $0281; whole 16-bit word += relocation delta
    defb 083h, 002h      ; runtime $42A4, stored $6064: #0099 word patch offset $0283; whole 16-bit word += relocation delta
    defb 085h, 002h      ; runtime $42A6, stored $6066: #0100 word patch offset $0285; whole 16-bit word += relocation delta
    defb 087h, 002h      ; runtime $42A8, stored $6068: #0101 word patch offset $0287; whole 16-bit word += relocation delta
    defb 089h, 002h      ; runtime $42AA, stored $606A: #0102 word patch offset $0289; whole 16-bit word += relocation delta
    defb 08bh, 002h      ; runtime $42AC, stored $606C: #0103 word patch offset $028B; whole 16-bit word += relocation delta
    defb 08dh, 002h      ; runtime $42AE, stored $606E: #0104 word patch offset $028D; whole 16-bit word += relocation delta
    defb 08fh, 002h      ; runtime $42B0, stored $6070: #0105 word patch offset $028F; whole 16-bit word += relocation delta
    defb 091h, 002h      ; runtime $42B2, stored $6072: #0106 word patch offset $0291; whole 16-bit word += relocation delta
    defb 093h, 002h      ; runtime $42B4, stored $6074: #0107 word patch offset $0293; whole 16-bit word += relocation delta
    defb 096h, 002h      ; runtime $42B6, stored $6076: #0108 word patch offset $0296; whole 16-bit word += relocation delta
    defb 099h, 002h      ; runtime $42B8, stored $6078: #0109 word patch offset $0299; whole 16-bit word += relocation delta
    defb 09dh, 002h      ; runtime $42BA, stored $607A: #0110 word patch offset $029D; whole 16-bit word += relocation delta
    defb 0a0h, 002h      ; runtime $42BC, stored $607C: #0111 word patch offset $02A0; whole 16-bit word += relocation delta
    defb 0a5h, 002h      ; runtime $42BE, stored $607E: #0112 word patch offset $02A5; whole 16-bit word += relocation delta
    defb 0adh, 002h      ; runtime $42C0, stored $6080: #0113 word patch offset $02AD; whole 16-bit word += relocation delta
    defb 0b0h, 002h      ; runtime $42C2, stored $6082: #0114 word patch offset $02B0; whole 16-bit word += relocation delta
    defb 0b4h, 002h      ; runtime $42C4, stored $6084: #0115 word patch offset $02B4; whole 16-bit word += relocation delta
    defb 0b7h, 002h      ; runtime $42C6, stored $6086: #0116 word patch offset $02B7; whole 16-bit word += relocation delta
    defb 0bdh, 002h      ; runtime $42C8, stored $6088: #0117 word patch offset $02BD; whole 16-bit word += relocation delta
    defb 0c7h, 002h      ; runtime $42CA, stored $608A: #0118 word patch offset $02C7; whole 16-bit word += relocation delta
    defb 0cch, 002h      ; runtime $42CC, stored $608C: #0119 word patch offset $02CC; whole 16-bit word += relocation delta
    defb 0cfh, 002h      ; runtime $42CE, stored $608E: #0120 word patch offset $02CF; whole 16-bit word += relocation delta
    defb 0d6h, 002h      ; runtime $42D0, stored $6090: #0121 word patch offset $02D6; whole 16-bit word += relocation delta
    defb 0ddh, 002h      ; runtime $42D2, stored $6092: #0122 word patch offset $02DD; whole 16-bit word += relocation delta
    defb 0e2h, 002h      ; runtime $42D4, stored $6094: #0123 word patch offset $02E2; whole 16-bit word += relocation delta
    defb 0e7h, 002h      ; runtime $42D6, stored $6096: #0124 word patch offset $02E7; whole 16-bit word += relocation delta
    defb 0f1h, 002h      ; runtime $42D8, stored $6098: #0125 word patch offset $02F1; whole 16-bit word += relocation delta
    defb 0f6h, 002h      ; runtime $42DA, stored $609A: #0126 word patch offset $02F6; whole 16-bit word += relocation delta
    defb 0fch, 002h      ; runtime $42DC, stored $609C: #0127 word patch offset $02FC; whole 16-bit word += relocation delta
    defb 004h, 003h      ; runtime $42DE, stored $609E: #0128 word patch offset $0304; whole 16-bit word += relocation delta
    defb 00dh, 003h      ; runtime $42E0, stored $60A0: #0129 word patch offset $030D; whole 16-bit word += relocation delta
    defb 014h, 003h      ; runtime $42E2, stored $60A2: #0130 word patch offset $0314; whole 16-bit word += relocation delta
    defb 019h, 003h      ; runtime $42E4, stored $60A4: #0131 word patch offset $0319; whole 16-bit word += relocation delta
    defb 021h, 003h      ; runtime $42E6, stored $60A6: #0132 word patch offset $0321; whole 16-bit word += relocation delta
    defb 029h, 003h      ; runtime $42E8, stored $60A8: #0133 word patch offset $0329; whole 16-bit word += relocation delta
    defb 032h, 003h      ; runtime $42EA, stored $60AA: #0134 word patch offset $0332; whole 16-bit word += relocation delta
    defb 035h, 003h      ; runtime $42EC, stored $60AC: #0135 word patch offset $0335; whole 16-bit word += relocation delta
    defb 038h, 003h      ; runtime $42EE, stored $60AE: #0136 word patch offset $0338; whole 16-bit word += relocation delta
    defb 041h, 003h      ; runtime $42F0, stored $60B0: #0137 word patch offset $0341; whole 16-bit word += relocation delta
    defb 04ah, 003h      ; runtime $42F2, stored $60B2: #0138 word patch offset $034A; whole 16-bit word += relocation delta
    defb 04dh, 003h      ; runtime $42F4, stored $60B4: #0139 word patch offset $034D; whole 16-bit word += relocation delta
    defb 050h, 003h      ; runtime $42F6, stored $60B6: #0140 word patch offset $0350; whole 16-bit word += relocation delta
    defb 054h, 003h      ; runtime $42F8, stored $60B8: #0141 word patch offset $0354; whole 16-bit word += relocation delta
    defb 058h, 003h      ; runtime $42FA, stored $60BA: #0142 word patch offset $0358; whole 16-bit word += relocation delta
    defb 05bh, 003h      ; runtime $42FC, stored $60BC: #0143 word patch offset $035B; whole 16-bit word += relocation delta
    defb 05eh, 003h      ; runtime $42FE, stored $60BE: #0144 word patch offset $035E; whole 16-bit word += relocation delta
    defb 061h, 003h      ; runtime $4300, stored $60C0: #0145 word patch offset $0361; whole 16-bit word += relocation delta
    defb 06dh, 003h      ; runtime $4302, stored $60C2: #0146 word patch offset $036D; whole 16-bit word += relocation delta
    defb 073h, 003h      ; runtime $4304, stored $60C4: #0147 word patch offset $0373; whole 16-bit word += relocation delta
    defb 079h, 003h      ; runtime $4306, stored $60C6: #0148 word patch offset $0379; whole 16-bit word += relocation delta
    defb 07fh, 003h      ; runtime $4308, stored $60C8: #0149 word patch offset $037F; whole 16-bit word += relocation delta
    defb 083h, 003h      ; runtime $430A, stored $60CA: #0150 word patch offset $0383; whole 16-bit word += relocation delta
    defb 08ch, 003h      ; runtime $430C, stored $60CC: #0151 word patch offset $038C; whole 16-bit word += relocation delta
    defb 093h, 003h      ; runtime $430E, stored $60CE: #0152 word patch offset $0393; whole 16-bit word += relocation delta
    defb 09ah, 003h      ; runtime $4310, stored $60D0: #0153 word patch offset $039A; whole 16-bit word += relocation delta
    defb 0a3h, 003h      ; runtime $4312, stored $60D2: #0154 word patch offset $03A3; whole 16-bit word += relocation delta
    defb 0a6h, 003h      ; runtime $4314, stored $60D4: #0155 word patch offset $03A6; whole 16-bit word += relocation delta
    defb 0a9h, 003h      ; runtime $4316, stored $60D6: #0156 word patch offset $03A9; whole 16-bit word += relocation delta
    defb 0ach, 003h      ; runtime $4318, stored $60D8: #0157 word patch offset $03AC; whole 16-bit word += relocation delta
    defb 0afh, 003h      ; runtime $431A, stored $60DA: #0158 word patch offset $03AF; whole 16-bit word += relocation delta
    defb 0b2h, 003h      ; runtime $431C, stored $60DC: #0159 word patch offset $03B2; whole 16-bit word += relocation delta
    defb 0b5h, 003h      ; runtime $431E, stored $60DE: #0160 word patch offset $03B5; whole 16-bit word += relocation delta
    defb 0b8h, 003h      ; runtime $4320, stored $60E0: #0161 word patch offset $03B8; whole 16-bit word += relocation delta
    defb 0bbh, 003h      ; runtime $4322, stored $60E2: #0162 word patch offset $03BB; whole 16-bit word += relocation delta
    defb 0c0h, 003h      ; runtime $4324, stored $60E4: #0163 word patch offset $03C0; whole 16-bit word += relocation delta
    defb 0c6h, 003h      ; runtime $4326, stored $60E6: #0164 word patch offset $03C6; whole 16-bit word += relocation delta
    defb 0cah, 003h      ; runtime $4328, stored $60E8: #0165 word patch offset $03CA; whole 16-bit word += relocation delta
    defb 0cdh, 003h      ; runtime $432A, stored $60EA: #0166 word patch offset $03CD; whole 16-bit word += relocation delta
    defb 0d0h, 003h      ; runtime $432C, stored $60EC: #0167 word patch offset $03D0; whole 16-bit word += relocation delta
    defb 0d7h, 003h      ; runtime $432E, stored $60EE: #0168 word patch offset $03D7; whole 16-bit word += relocation delta
    defb 0e2h, 003h      ; runtime $4330, stored $60F0: #0169 word patch offset $03E2; whole 16-bit word += relocation delta
    defb 0e5h, 003h      ; runtime $4332, stored $60F2: #0170 word patch offset $03E5; whole 16-bit word += relocation delta
    defb 0e8h, 003h      ; runtime $4334, stored $60F4: #0171 word patch offset $03E8; whole 16-bit word += relocation delta
    defb 0ebh, 003h      ; runtime $4336, stored $60F6: #0172 word patch offset $03EB; whole 16-bit word += relocation delta
    defb 0eeh, 003h      ; runtime $4338, stored $60F8: #0173 word patch offset $03EE; whole 16-bit word += relocation delta
    defb 0f1h, 003h      ; runtime $433A, stored $60FA: #0174 word patch offset $03F1; whole 16-bit word += relocation delta
    defb 0f4h, 003h      ; runtime $433C, stored $60FC: #0175 word patch offset $03F4; whole 16-bit word += relocation delta
    defb 0f7h, 003h      ; runtime $433E, stored $60FE: #0176 word patch offset $03F7; whole 16-bit word += relocation delta
    defb 0fah, 003h      ; runtime $4340, stored $6100: #0177 word patch offset $03FA; whole 16-bit word += relocation delta
    defb 0fdh, 003h      ; runtime $4342, stored $6102: #0178 word patch offset $03FD; whole 16-bit word += relocation delta
    defb 009h, 004h      ; runtime $4344, stored $6104: #0179 word patch offset $0409; whole 16-bit word += relocation delta
    defb 00eh, 004h      ; runtime $4346, stored $6106: #0180 word patch offset $040E; whole 16-bit word += relocation delta
    defb 011h, 004h      ; runtime $4348, stored $6108: #0181 word patch offset $0411; whole 16-bit word += relocation delta
    defb 014h, 004h      ; runtime $434A, stored $610A: #0182 word patch offset $0414; whole 16-bit word += relocation delta
    defb 01eh, 004h      ; runtime $434C, stored $610C: #0183 word patch offset $041E; whole 16-bit word += relocation delta
    defb 030h, 004h      ; runtime $434E, stored $610E: #0184 word patch offset $0430; whole 16-bit word += relocation delta
    defb 038h, 004h      ; runtime $4350, stored $6110: #0185 word patch offset $0438; whole 16-bit word += relocation delta
    defb 03bh, 004h      ; runtime $4352, stored $6112: #0186 word patch offset $043B; whole 16-bit word += relocation delta
    defb 03eh, 004h      ; runtime $4354, stored $6114: #0187 word patch offset $043E; whole 16-bit word += relocation delta
    defb 041h, 004h      ; runtime $4356, stored $6116: #0188 word patch offset $0441; whole 16-bit word += relocation delta
    defb 046h, 004h      ; runtime $4358, stored $6118: #0189 word patch offset $0446; whole 16-bit word += relocation delta
    defb 052h, 004h      ; runtime $435A, stored $611A: #0190 word patch offset $0452; whole 16-bit word += relocation delta
    defb 05ah, 004h      ; runtime $435C, stored $611C: #0191 word patch offset $045A; whole 16-bit word += relocation delta
    defb 068h, 004h      ; runtime $435E, stored $611E: #0192 word patch offset $0468; whole 16-bit word += relocation delta
    defb 06dh, 004h      ; runtime $4360, stored $6120: #0193 word patch offset $046D; whole 16-bit word += relocation delta
    defb 070h, 004h      ; runtime $4362, stored $6122: #0194 word patch offset $0470; whole 16-bit word += relocation delta
    defb 073h, 004h      ; runtime $4364, stored $6124: #0195 word patch offset $0473; whole 16-bit word += relocation delta
    defb 076h, 004h      ; runtime $4366, stored $6126: #0196 word patch offset $0476; whole 16-bit word += relocation delta
    defb 079h, 004h      ; runtime $4368, stored $6128: #0197 word patch offset $0479; whole 16-bit word += relocation delta
    defb 07ch, 004h      ; runtime $436A, stored $612A: #0198 word patch offset $047C; whole 16-bit word += relocation delta
    defb 07fh, 004h      ; runtime $436C, stored $612C: #0199 word patch offset $047F; whole 16-bit word += relocation delta
    defb 083h, 004h      ; runtime $436E, stored $612E: #0200 word patch offset $0483; whole 16-bit word += relocation delta
    defb 087h, 004h      ; runtime $4370, stored $6130: #0201 word patch offset $0487; whole 16-bit word += relocation delta
    defb 090h, 004h      ; runtime $4372, stored $6132: #0202 word patch offset $0490; whole 16-bit word += relocation delta
    defb 0d9h, 004h      ; runtime $4374, stored $6134: #0203 word patch offset $04D9; whole 16-bit word += relocation delta
    defb 0e2h, 004h      ; runtime $4376, stored $6136: #0204 word patch offset $04E2; whole 16-bit word += relocation delta
    defb 0edh, 004h      ; runtime $4378, stored $6138: #0205 word patch offset $04ED; whole 16-bit word += relocation delta
    defb 0f9h, 004h      ; runtime $437A, stored $613A: #0206 word patch offset $04F9; whole 16-bit word += relocation delta
    defb 015h, 005h      ; runtime $437C, stored $613C: #0207 word patch offset $0515; whole 16-bit word += relocation delta
    defb 020h, 005h      ; runtime $437E, stored $613E: #0208 word patch offset $0520; whole 16-bit word += relocation delta
    defb 02fh, 005h      ; runtime $4380, stored $6140: #0209 word patch offset $052F; whole 16-bit word += relocation delta
    defb 03eh, 005h      ; runtime $4382, stored $6142: #0210 word patch offset $053E; whole 16-bit word += relocation delta
    defb 04ah, 005h      ; runtime $4384, stored $6144: #0211 word patch offset $054A; whole 16-bit word += relocation delta
    defb 04dh, 005h      ; runtime $4386, stored $6146: #0212 word patch offset $054D; whole 16-bit word += relocation delta
    defb 050h, 005h      ; runtime $4388, stored $6148: #0213 word patch offset $0550; whole 16-bit word += relocation delta
    defb 056h, 005h      ; runtime $438A, stored $614A: #0214 word patch offset $0556; whole 16-bit word += relocation delta
    defb 061h, 005h      ; runtime $438C, stored $614C: #0215 word patch offset $0561; whole 16-bit word += relocation delta
    defb 067h, 005h      ; runtime $438E, stored $614E: #0216 word patch offset $0567; whole 16-bit word += relocation delta
    defb 06fh, 005h      ; runtime $4390, stored $6150: #0217 word patch offset $056F; whole 16-bit word += relocation delta
    defb 074h, 005h      ; runtime $4392, stored $6152: #0218 word patch offset $0574; whole 16-bit word += relocation delta
    defb 08bh, 005h      ; runtime $4394, stored $6154: #0219 word patch offset $058B; whole 16-bit word += relocation delta
    defb 094h, 005h      ; runtime $4396, stored $6156: #0220 word patch offset $0594; whole 16-bit word += relocation delta
    defb 09fh, 005h      ; runtime $4398, stored $6158: #0221 word patch offset $059F; whole 16-bit word += relocation delta
    defb 0abh, 005h      ; runtime $439A, stored $615A: #0222 word patch offset $05AB; whole 16-bit word += relocation delta
    defb 0b0h, 005h      ; runtime $439C, stored $615C: #0223 word patch offset $05B0; whole 16-bit word += relocation delta
    defb 0b4h, 005h      ; runtime $439E, stored $615E: #0224 word patch offset $05B4; whole 16-bit word += relocation delta
    defb 0b9h, 005h      ; runtime $43A0, stored $6160: #0225 word patch offset $05B9; whole 16-bit word += relocation delta
    defb 0c1h, 005h      ; runtime $43A2, stored $6162: #0226 word patch offset $05C1; whole 16-bit word += relocation delta
    defb 0c8h, 005h      ; runtime $43A4, stored $6164: #0227 word patch offset $05C8; whole 16-bit word += relocation delta
    defb 0d1h, 005h      ; runtime $43A6, stored $6166: #0228 word patch offset $05D1; whole 16-bit word += relocation delta
    defb 0d9h, 005h      ; runtime $43A8, stored $6168: #0229 word patch offset $05D9; whole 16-bit word += relocation delta
    defb 0dch, 005h      ; runtime $43AA, stored $616A: #0230 word patch offset $05DC; whole 16-bit word += relocation delta
    defb 0efh, 005h      ; runtime $43AC, stored $616C: #0231 word patch offset $05EF; whole 16-bit word += relocation delta
    defb 0f3h, 005h      ; runtime $43AE, stored $616E: #0232 word patch offset $05F3; whole 16-bit word += relocation delta
    defb 0f6h, 005h      ; runtime $43B0, stored $6170: #0233 word patch offset $05F6; whole 16-bit word += relocation delta
    defb 0f9h, 005h      ; runtime $43B2, stored $6172: #0234 word patch offset $05F9; whole 16-bit word += relocation delta
    defb 0fch, 005h      ; runtime $43B4, stored $6174: #0235 word patch offset $05FC; whole 16-bit word += relocation delta
    defb 0ffh, 005h      ; runtime $43B6, stored $6176: #0236 word patch offset $05FF; whole 16-bit word += relocation delta
    defb 002h, 006h      ; runtime $43B8, stored $6178: #0237 word patch offset $0602; whole 16-bit word += relocation delta
    defb 007h, 006h      ; runtime $43BA, stored $617A: #0238 word patch offset $0607; whole 16-bit word += relocation delta
    defb 00ah, 006h      ; runtime $43BC, stored $617C: #0239 word patch offset $060A; whole 16-bit word += relocation delta
    defb 00dh, 006h      ; runtime $43BE, stored $617E: #0240 word patch offset $060D; whole 16-bit word += relocation delta
    defb 019h, 006h      ; runtime $43C0, stored $6180: #0241 word patch offset $0619; whole 16-bit word += relocation delta
    defb 022h, 006h      ; runtime $43C2, stored $6182: #0242 word patch offset $0622; whole 16-bit word += relocation delta
    defb 027h, 006h      ; runtime $43C4, stored $6184: #0243 word patch offset $0627; whole 16-bit word += relocation delta
    defb 031h, 006h      ; runtime $43C6, stored $6186: #0244 word patch offset $0631; whole 16-bit word += relocation delta
    defb 03bh, 006h      ; runtime $43C8, stored $6188: #0245 word patch offset $063B; whole 16-bit word += relocation delta
    defb 03fh, 006h      ; runtime $43CA, stored $618A: #0246 word patch offset $063F; whole 16-bit word += relocation delta
    defb 055h, 006h      ; runtime $43CC, stored $618C: #0247 word patch offset $0655; whole 16-bit word += relocation delta
    defb 061h, 006h      ; runtime $43CE, stored $618E: #0248 word patch offset $0661; whole 16-bit word += relocation delta
    defb 069h, 006h      ; runtime $43D0, stored $6190: #0249 word patch offset $0669; whole 16-bit word += relocation delta
    defb 06ch, 006h      ; runtime $43D2, stored $6192: #0250 word patch offset $066C; whole 16-bit word += relocation delta
    defb 075h, 006h      ; runtime $43D4, stored $6194: #0251 word patch offset $0675; whole 16-bit word += relocation delta
    defb 07bh, 006h      ; runtime $43D6, stored $6196: #0252 word patch offset $067B; whole 16-bit word += relocation delta
    defb 07eh, 006h      ; runtime $43D8, stored $6198: #0253 word patch offset $067E; whole 16-bit word += relocation delta
    defb 081h, 006h      ; runtime $43DA, stored $619A: #0254 word patch offset $0681; whole 16-bit word += relocation delta
    defb 084h, 006h      ; runtime $43DC, stored $619C: #0255 word patch offset $0684; whole 16-bit word += relocation delta
    defb 093h, 006h      ; runtime $43DE, stored $619E: #0256 word patch offset $0693; whole 16-bit word += relocation delta
    defb 098h, 006h      ; runtime $43E0, stored $61A0: #0257 word patch offset $0698; whole 16-bit word += relocation delta
    defb 0a3h, 006h      ; runtime $43E2, stored $61A2: #0258 word patch offset $06A3; whole 16-bit word += relocation delta
    defb 0b1h, 006h      ; runtime $43E4, stored $61A4: #0259 word patch offset $06B1; whole 16-bit word += relocation delta
    defb 0b8h, 006h      ; runtime $43E6, stored $61A6: #0260 word patch offset $06B8; whole 16-bit word += relocation delta
    defb 0bch, 006h      ; runtime $43E8, stored $61A8: #0261 word patch offset $06BC; whole 16-bit word += relocation delta
    defb 0c6h, 006h      ; runtime $43EA, stored $61AA: #0262 word patch offset $06C6; whole 16-bit word += relocation delta
    defb 0c9h, 006h      ; runtime $43EC, stored $61AC: #0263 word patch offset $06C9; whole 16-bit word += relocation delta
    defb 0dch, 006h      ; runtime $43EE, stored $61AE: #0264 word patch offset $06DC; whole 16-bit word += relocation delta
    defb 0efh, 006h      ; runtime $43F0, stored $61B0: #0265 word patch offset $06EF; whole 16-bit word += relocation delta
    defb 000h, 007h      ; runtime $43F2, stored $61B2: #0266 word patch offset $0700; whole 16-bit word += relocation delta
    defb 026h, 007h      ; runtime $43F4, stored $61B4: #0267 word patch offset $0726; whole 16-bit word += relocation delta
    defb 02fh, 007h      ; runtime $43F6, stored $61B6: #0268 word patch offset $072F; whole 16-bit word += relocation delta
    defb 034h, 007h      ; runtime $43F8, stored $61B8: #0269 word patch offset $0734; whole 16-bit word += relocation delta
    defb 037h, 007h      ; runtime $43FA, stored $61BA: #0270 word patch offset $0737; whole 16-bit word += relocation delta
    defb 045h, 007h      ; runtime $43FC, stored $61BC: #0271 word patch offset $0745; whole 16-bit word += relocation delta
    defb 04ch, 007h      ; runtime $43FE, stored $61BE: #0272 word patch offset $074C; whole 16-bit word += relocation delta
    defb 051h, 007h      ; runtime $4400, stored $61C0: #0273 word patch offset $0751; whole 16-bit word += relocation delta
    defb 055h, 007h      ; runtime $4402, stored $61C2: #0274 word patch offset $0755; whole 16-bit word += relocation delta
    defb 05ah, 007h      ; runtime $4404, stored $61C4: #0275 word patch offset $075A; whole 16-bit word += relocation delta
    defb 061h, 007h      ; runtime $4406, stored $61C6: #0276 word patch offset $0761; whole 16-bit word += relocation delta
    defb 067h, 007h      ; runtime $4408, stored $61C8: #0277 word patch offset $0767; whole 16-bit word += relocation delta
    defb 06bh, 007h      ; runtime $440A, stored $61CA: #0278 word patch offset $076B; whole 16-bit word += relocation delta
    defb 072h, 007h      ; runtime $440C, stored $61CC: #0279 word patch offset $0772; whole 16-bit word += relocation delta
    defb 076h, 007h      ; runtime $440E, stored $61CE: #0280 word patch offset $0776; whole 16-bit word += relocation delta
    defb 086h, 007h      ; runtime $4410, stored $61D0: #0281 word patch offset $0786; whole 16-bit word += relocation delta
    defb 08bh, 007h      ; runtime $4412, stored $61D2: #0282 word patch offset $078B; whole 16-bit word += relocation delta
    defb 0aeh, 007h      ; runtime $4414, stored $61D4: #0283 word patch offset $07AE; whole 16-bit word += relocation delta
    defb 0cfh, 007h      ; runtime $4416, stored $61D6: #0284 word patch offset $07CF; whole 16-bit word += relocation delta
    defb 0d3h, 007h      ; runtime $4418, stored $61D8: #0285 word patch offset $07D3; whole 16-bit word += relocation delta
    defb 0d8h, 007h      ; runtime $441A, stored $61DA: #0286 word patch offset $07D8; whole 16-bit word += relocation delta
    defb 0f6h, 007h      ; runtime $441C, stored $61DC: #0287 word patch offset $07F6; whole 16-bit word += relocation delta
    defb 0f9h, 007h      ; runtime $441E, stored $61DE: #0288 word patch offset $07F9; whole 16-bit word += relocation delta
    defb 007h, 008h      ; runtime $4420, stored $61E0: #0289 word patch offset $0807; whole 16-bit word += relocation delta
    defb 00bh, 008h      ; runtime $4422, stored $61E2: #0290 word patch offset $080B; whole 16-bit word += relocation delta
    defb 00fh, 008h      ; runtime $4424, stored $61E4: #0291 word patch offset $080F; whole 16-bit word += relocation delta
    defb 01ch, 008h      ; runtime $4426, stored $61E6: #0292 word patch offset $081C; whole 16-bit word += relocation delta
    defb 021h, 008h      ; runtime $4428, stored $61E8: #0293 word patch offset $0821; whole 16-bit word += relocation delta
    defb 027h, 008h      ; runtime $442A, stored $61EA: #0294 word patch offset $0827; whole 16-bit word += relocation delta
    defb 02ah, 008h      ; runtime $442C, stored $61EC: #0295 word patch offset $082A; whole 16-bit word += relocation delta
    defb 02dh, 008h      ; runtime $442E, stored $61EE: #0296 word patch offset $082D; whole 16-bit word += relocation delta
    defb 030h, 008h      ; runtime $4430, stored $61F0: #0297 word patch offset $0830; whole 16-bit word += relocation delta
    defb 033h, 008h      ; runtime $4432, stored $61F2: #0298 word patch offset $0833; whole 16-bit word += relocation delta
    defb 03dh, 008h      ; runtime $4434, stored $61F4: #0299 word patch offset $083D; whole 16-bit word += relocation delta
    defb 040h, 008h      ; runtime $4436, stored $61F6: #0300 word patch offset $0840; whole 16-bit word += relocation delta
    defb 051h, 008h      ; runtime $4438, stored $61F8: #0301 word patch offset $0851; whole 16-bit word += relocation delta
    defb 054h, 008h      ; runtime $443A, stored $61FA: #0302 word patch offset $0854; whole 16-bit word += relocation delta
    defb 059h, 008h      ; runtime $443C, stored $61FC: #0303 word patch offset $0859; whole 16-bit word += relocation delta
    defb 05ch, 008h      ; runtime $443E, stored $61FE: #0304 word patch offset $085C; whole 16-bit word += relocation delta
    defb 05fh, 008h      ; runtime $4440, stored $6200: #0305 word patch offset $085F; whole 16-bit word += relocation delta
    defb 066h, 008h      ; runtime $4442, stored $6202: #0306 word patch offset $0866; whole 16-bit word += relocation delta
    defb 069h, 008h      ; runtime $4444, stored $6204: #0307 word patch offset $0869; whole 16-bit word += relocation delta
    defb 071h, 008h      ; runtime $4446, stored $6206: #0308 word patch offset $0871; whole 16-bit word += relocation delta
    defb 074h, 008h      ; runtime $4448, stored $6208: #0309 word patch offset $0874; whole 16-bit word += relocation delta
    defb 077h, 008h      ; runtime $444A, stored $620A: #0310 word patch offset $0877; whole 16-bit word += relocation delta
    defb 07bh, 008h      ; runtime $444C, stored $620C: #0311 word patch offset $087B; whole 16-bit word += relocation delta
    defb 07eh, 008h      ; runtime $444E, stored $620E: #0312 word patch offset $087E; whole 16-bit word += relocation delta
    defb 088h, 008h      ; runtime $4450, stored $6210: #0313 word patch offset $0888; whole 16-bit word += relocation delta
    defb 08bh, 008h      ; runtime $4452, stored $6212: #0314 word patch offset $088B; whole 16-bit word += relocation delta
    defb 08eh, 008h      ; runtime $4454, stored $6214: #0315 word patch offset $088E; whole 16-bit word += relocation delta
    defb 092h, 008h      ; runtime $4456, stored $6216: #0316 word patch offset $0892; whole 16-bit word += relocation delta
    defb 095h, 008h      ; runtime $4458, stored $6218: #0317 word patch offset $0895; whole 16-bit word += relocation delta
    defb 098h, 008h      ; runtime $445A, stored $621A: #0318 word patch offset $0898; whole 16-bit word += relocation delta
    defb 09dh, 008h      ; runtime $445C, stored $621C: #0319 word patch offset $089D; whole 16-bit word += relocation delta
    defb 0a0h, 008h      ; runtime $445E, stored $621E: #0320 word patch offset $08A0; whole 16-bit word += relocation delta
    defb 0bch, 008h      ; runtime $4460, stored $6220: #0321 word patch offset $08BC; whole 16-bit word += relocation delta
    defb 0cah, 008h      ; runtime $4462, stored $6222: #0322 word patch offset $08CA; whole 16-bit word += relocation delta
    defb 0cdh, 008h      ; runtime $4464, stored $6224: #0323 word patch offset $08CD; whole 16-bit word += relocation delta
    defb 0d0h, 008h      ; runtime $4466, stored $6226: #0324 word patch offset $08D0; whole 16-bit word += relocation delta
    defb 0d3h, 008h      ; runtime $4468, stored $6228: #0325 word patch offset $08D3; whole 16-bit word += relocation delta
    defb 0d7h, 008h      ; runtime $446A, stored $622A: #0326 word patch offset $08D7; whole 16-bit word += relocation delta
    defb 0e1h, 008h      ; runtime $446C, stored $622C: #0327 word patch offset $08E1; whole 16-bit word += relocation delta
    defb 0e4h, 008h      ; runtime $446E, stored $622E: #0328 word patch offset $08E4; whole 16-bit word += relocation delta
    defb 0e8h, 008h      ; runtime $4470, stored $6230: #0329 word patch offset $08E8; whole 16-bit word += relocation delta
    defb 0ebh, 008h      ; runtime $4472, stored $6232: #0330 word patch offset $08EB; whole 16-bit word += relocation delta
    defb 0f5h, 008h      ; runtime $4474, stored $6234: #0331 word patch offset $08F5; whole 16-bit word += relocation delta
    defb 0f9h, 008h      ; runtime $4476, stored $6236: #0332 word patch offset $08F9; whole 16-bit word += relocation delta
    defb 000h, 009h      ; runtime $4478, stored $6238: #0333 word patch offset $0900; whole 16-bit word += relocation delta
    defb 008h, 009h      ; runtime $447A, stored $623A: #0334 word patch offset $0908; whole 16-bit word += relocation delta
    defb 00dh, 009h      ; runtime $447C, stored $623C: #0335 word patch offset $090D; whole 16-bit word += relocation delta
    defb 014h, 009h      ; runtime $447E, stored $623E: #0336 word patch offset $0914; whole 16-bit word += relocation delta
    defb 01ch, 009h      ; runtime $4480, stored $6240: #0337 word patch offset $091C; whole 16-bit word += relocation delta
    defb 024h, 009h      ; runtime $4482, stored $6242: #0338 word patch offset $0924; whole 16-bit word += relocation delta
    defb 029h, 009h      ; runtime $4484, stored $6244: #0339 word patch offset $0929; whole 16-bit word += relocation delta
    defb 02eh, 009h      ; runtime $4486, stored $6246: #0340 word patch offset $092E; whole 16-bit word += relocation delta
    defb 031h, 009h      ; runtime $4488, stored $6248: #0341 word patch offset $0931; whole 16-bit word += relocation delta
    defb 034h, 009h      ; runtime $448A, stored $624A: #0342 word patch offset $0934; whole 16-bit word += relocation delta
    defb 037h, 009h      ; runtime $448C, stored $624C: #0343 word patch offset $0937; whole 16-bit word += relocation delta
    defb 03bh, 009h      ; runtime $448E, stored $624E: #0344 word patch offset $093B; whole 16-bit word += relocation delta
    defb 03eh, 009h      ; runtime $4490, stored $6250: #0345 word patch offset $093E; whole 16-bit word += relocation delta
    defb 041h, 009h      ; runtime $4492, stored $6252: #0346 word patch offset $0941; whole 16-bit word += relocation delta
    defb 044h, 009h      ; runtime $4494, stored $6254: #0347 word patch offset $0944; whole 16-bit word += relocation delta
    defb 049h, 009h      ; runtime $4496, stored $6256: #0348 word patch offset $0949; whole 16-bit word += relocation delta
    defb 04dh, 009h      ; runtime $4498, stored $6258: #0349 word patch offset $094D; whole 16-bit word += relocation delta
    defb 050h, 009h      ; runtime $449A, stored $625A: #0350 word patch offset $0950; whole 16-bit word += relocation delta
    defb 05ah, 009h      ; runtime $449C, stored $625C: #0351 word patch offset $095A; whole 16-bit word += relocation delta
    defb 05fh, 009h      ; runtime $449E, stored $625E: #0352 word patch offset $095F; whole 16-bit word += relocation delta
    defb 06ah, 009h      ; runtime $44A0, stored $6260: #0353 word patch offset $096A; whole 16-bit word += relocation delta
    defb 06dh, 009h      ; runtime $44A2, stored $6262: #0354 word patch offset $096D; whole 16-bit word += relocation delta
    defb 070h, 009h      ; runtime $44A4, stored $6264: #0355 word patch offset $0970; whole 16-bit word += relocation delta
    defb 076h, 009h      ; runtime $44A6, stored $6266: #0356 word patch offset $0976; whole 16-bit word += relocation delta
    defb 07bh, 009h      ; runtime $44A8, stored $6268: #0357 word patch offset $097B; whole 16-bit word += relocation delta
    defb 081h, 009h      ; runtime $44AA, stored $626A: #0358 word patch offset $0981; whole 16-bit word += relocation delta
    defb 089h, 009h      ; runtime $44AC, stored $626C: #0359 word patch offset $0989; whole 16-bit word += relocation delta
    defb 08ch, 009h      ; runtime $44AE, stored $626E: #0360 word patch offset $098C; whole 16-bit word += relocation delta
    defb 08fh, 009h      ; runtime $44B0, stored $6270: #0361 word patch offset $098F; whole 16-bit word += relocation delta
    defb 097h, 009h      ; runtime $44B2, stored $6272: #0362 word patch offset $0997; whole 16-bit word += relocation delta
    defb 09dh, 009h      ; runtime $44B4, stored $6274: #0363 word patch offset $099D; whole 16-bit word += relocation delta
    defb 0a0h, 009h      ; runtime $44B6, stored $6276: #0364 word patch offset $09A0; whole 16-bit word += relocation delta
    defb 0a6h, 009h      ; runtime $44B8, stored $6278: #0365 word patch offset $09A6; whole 16-bit word += relocation delta
    defb 0a9h, 009h      ; runtime $44BA, stored $627A: #0366 word patch offset $09A9; whole 16-bit word += relocation delta
    defb 0ach, 009h      ; runtime $44BC, stored $627C: #0367 word patch offset $09AC; whole 16-bit word += relocation delta
    defb 0b6h, 009h      ; runtime $44BE, stored $627E: #0368 word patch offset $09B6; whole 16-bit word += relocation delta
    defb 0bbh, 009h      ; runtime $44C0, stored $6280: #0369 word patch offset $09BB; whole 16-bit word += relocation delta
    defb 0cah, 009h      ; runtime $44C2, stored $6282: #0370 word patch offset $09CA; whole 16-bit word += relocation delta
    defb 0d8h, 009h      ; runtime $44C4, stored $6284: #0371 word patch offset $09D8; whole 16-bit word += relocation delta
    defb 0e1h, 009h      ; runtime $44C6, stored $6286: #0372 word patch offset $09E1; whole 16-bit word += relocation delta
    defb 0e4h, 009h      ; runtime $44C8, stored $6288: #0373 word patch offset $09E4; whole 16-bit word += relocation delta
    defb 0e7h, 009h      ; runtime $44CA, stored $628A: #0374 word patch offset $09E7; whole 16-bit word += relocation delta
    defb 0eah, 009h      ; runtime $44CC, stored $628C: #0375 word patch offset $09EA; whole 16-bit word += relocation delta
    defb 002h, 00ah      ; runtime $44CE, stored $628E: #0376 word patch offset $0A02; whole 16-bit word += relocation delta
    defb 005h, 00ah      ; runtime $44D0, stored $6290: #0377 word patch offset $0A05; whole 16-bit word += relocation delta
    defb 014h, 00ah      ; runtime $44D2, stored $6292: #0378 word patch offset $0A14; whole 16-bit word += relocation delta
    defb 01bh, 00ah      ; runtime $44D4, stored $6294: #0379 word patch offset $0A1B; whole 16-bit word += relocation delta
    defb 022h, 00ah      ; runtime $44D6, stored $6296: #0380 word patch offset $0A22; whole 16-bit word += relocation delta
    defb 029h, 00ah      ; runtime $44D8, stored $6298: #0381 word patch offset $0A29; whole 16-bit word += relocation delta
    defb 02fh, 00ah      ; runtime $44DA, stored $629A: #0382 word patch offset $0A2F; whole 16-bit word += relocation delta
    defb 032h, 00ah      ; runtime $44DC, stored $629C: #0383 word patch offset $0A32; whole 16-bit word += relocation delta
    defb 03bh, 00ah      ; runtime $44DE, stored $629E: #0384 word patch offset $0A3B; whole 16-bit word += relocation delta
    defb 048h, 00ah      ; runtime $44E0, stored $62A0: #0385 word patch offset $0A48; whole 16-bit word += relocation delta
    defb 055h, 00ah      ; runtime $44E2, stored $62A2: #0386 word patch offset $0A55; whole 16-bit word += relocation delta
    defb 067h, 00ah      ; runtime $44E4, stored $62A4: #0387 word patch offset $0A67; whole 16-bit word += relocation delta
    defb 06eh, 00ah      ; runtime $44E6, stored $62A6: #0388 word patch offset $0A6E; whole 16-bit word += relocation delta
    defb 07ah, 00ah      ; runtime $44E8, stored $62A8: #0389 word patch offset $0A7A; whole 16-bit word += relocation delta
    defb 083h, 00ah      ; runtime $44EA, stored $62AA: #0390 word patch offset $0A83; whole 16-bit word += relocation delta
    defb 0ach, 00ah      ; runtime $44EC, stored $62AC: #0391 word patch offset $0AAC; whole 16-bit word += relocation delta
    defb 0b1h, 00ah      ; runtime $44EE, stored $62AE: #0392 word patch offset $0AB1; whole 16-bit word += relocation delta
    defb 0bfh, 00ah      ; runtime $44F0, stored $62B0: #0393 word patch offset $0ABF; whole 16-bit word += relocation delta
    defb 0cch, 00ah      ; runtime $44F2, stored $62B2: #0394 word patch offset $0ACC; whole 16-bit word += relocation delta
    defb 0d0h, 00ah      ; runtime $44F4, stored $62B4: #0395 word patch offset $0AD0; whole 16-bit word += relocation delta
    defb 0ddh, 00ah      ; runtime $44F6, stored $62B6: #0396 word patch offset $0ADD; whole 16-bit word += relocation delta
    defb 0e0h, 00ah      ; runtime $44F8, stored $62B8: #0397 word patch offset $0AE0; whole 16-bit word += relocation delta
    defb 0e5h, 00ah      ; runtime $44FA, stored $62BA: #0398 word patch offset $0AE5; whole 16-bit word += relocation delta
    defb 0feh, 00ah      ; runtime $44FC, stored $62BC: #0399 word patch offset $0AFE; whole 16-bit word += relocation delta
    defb 026h, 00bh      ; runtime $44FE, stored $62BE: #0400 word patch offset $0B26; whole 16-bit word += relocation delta
    defb 02eh, 00bh      ; runtime $4500, stored $62C0: #0401 word patch offset $0B2E; whole 16-bit word += relocation delta
    defb 03ch, 00bh      ; runtime $4502, stored $62C2: #0402 word patch offset $0B3C; whole 16-bit word += relocation delta
    defb 040h, 00bh      ; runtime $4504, stored $62C4: #0403 word patch offset $0B40; whole 16-bit word += relocation delta
    defb 044h, 00bh      ; runtime $4506, stored $62C6: #0404 word patch offset $0B44; whole 16-bit word += relocation delta
    defb 04dh, 00bh      ; runtime $4508, stored $62C8: #0405 word patch offset $0B4D; whole 16-bit word += relocation delta
    defb 058h, 00bh      ; runtime $450A, stored $62CA: #0406 word patch offset $0B58; whole 16-bit word += relocation delta
    defb 063h, 00bh      ; runtime $450C, stored $62CC: #0407 word patch offset $0B63; whole 16-bit word += relocation delta
    defb 067h, 00bh      ; runtime $450E, stored $62CE: #0408 word patch offset $0B67; whole 16-bit word += relocation delta
    defb 06ah, 00bh      ; runtime $4510, stored $62D0: #0409 word patch offset $0B6A; whole 16-bit word += relocation delta
    defb 06dh, 00bh      ; runtime $4512, stored $62D2: #0410 word patch offset $0B6D; whole 16-bit word += relocation delta
    defb 070h, 00bh      ; runtime $4514, stored $62D4: #0411 word patch offset $0B70; whole 16-bit word += relocation delta
    defb 079h, 00bh      ; runtime $4516, stored $62D6: #0412 word patch offset $0B79; whole 16-bit word += relocation delta
    defb 081h, 00bh      ; runtime $4518, stored $62D8: #0413 word patch offset $0B81; whole 16-bit word += relocation delta
    defb 084h, 00bh      ; runtime $451A, stored $62DA: #0414 word patch offset $0B84; whole 16-bit word += relocation delta
    defb 0c6h, 00bh      ; runtime $451C, stored $62DC: #0415 word patch offset $0BC6; whole 16-bit word += relocation delta
    defb 0cdh, 00bh      ; runtime $451E, stored $62DE: #0416 word patch offset $0BCD; whole 16-bit word += relocation delta
    defb 0d6h, 00bh      ; runtime $4520, stored $62E0: #0417 word patch offset $0BD6; whole 16-bit word += relocation delta
    defb 0dfh, 00bh      ; runtime $4522, stored $62E2: #0418 word patch offset $0BDF; whole 16-bit word += relocation delta
    defb 0e4h, 00bh      ; runtime $4524, stored $62E4: #0419 word patch offset $0BE4; whole 16-bit word += relocation delta
    defb 003h, 00ch      ; runtime $4526, stored $62E6: #0420 word patch offset $0C03; whole 16-bit word += relocation delta
    defb 00bh, 00ch      ; runtime $4528, stored $62E8: #0421 word patch offset $0C0B; whole 16-bit word += relocation delta
    defb 011h, 00ch      ; runtime $452A, stored $62EA: #0422 word patch offset $0C11; whole 16-bit word += relocation delta
    defb 01dh, 00ch      ; runtime $452C, stored $62EC: #0423 word patch offset $0C1D; whole 16-bit word += relocation delta
    defb 022h, 00ch      ; runtime $452E, stored $62EE: #0424 word patch offset $0C22; whole 16-bit word += relocation delta
    defb 04bh, 00ch      ; runtime $4530, stored $62F0: #0425 word patch offset $0C4B; whole 16-bit word += relocation delta
    defb 09bh, 00ch      ; runtime $4532, stored $62F2: #0426 word patch offset $0C9B; whole 16-bit word += relocation delta
    defb 09fh, 00ch      ; runtime $4534, stored $62F4: #0427 word patch offset $0C9F; whole 16-bit word += relocation delta
    defb 0d9h, 00ch      ; runtime $4536, stored $62F6: #0428 word patch offset $0CD9; whole 16-bit word += relocation delta
    defb 0e0h, 00ch      ; runtime $4538, stored $62F8: #0429 word patch offset $0CE0; whole 16-bit word += relocation delta
    defb 0e3h, 00ch      ; runtime $453A, stored $62FA: #0430 word patch offset $0CE3; whole 16-bit word += relocation delta
    defb 0e6h, 00ch      ; runtime $453C, stored $62FC: #0431 word patch offset $0CE6; whole 16-bit word += relocation delta
    defb 0e9h, 00ch      ; runtime $453E, stored $62FE: #0432 word patch offset $0CE9; whole 16-bit word += relocation delta
    defb 0eeh, 00ch      ; runtime $4540, stored $6300: #0433 word patch offset $0CEE; whole 16-bit word += relocation delta
    defb 0fch, 00ch      ; runtime $4542, stored $6302: #0434 word patch offset $0CFC; whole 16-bit word += relocation delta
    defb 003h, 00dh      ; runtime $4544, stored $6304: #0435 word patch offset $0D03; whole 16-bit word += relocation delta
    defb 016h, 00dh      ; runtime $4546, stored $6306: #0436 word patch offset $0D16; whole 16-bit word += relocation delta
    defb 026h, 00dh      ; runtime $4548, stored $6308: #0437 word patch offset $0D26; whole 16-bit word += relocation delta
    defb 033h, 00dh      ; runtime $454A, stored $630A: #0438 word patch offset $0D33; whole 16-bit word += relocation delta
    defb 043h, 00dh      ; runtime $454C, stored $630C: #0439 word patch offset $0D43; whole 16-bit word += relocation delta
    defb 046h, 00dh      ; runtime $454E, stored $630E: #0440 word patch offset $0D46; whole 16-bit word += relocation delta
    defb 050h, 00dh      ; runtime $4550, stored $6310: #0441 word patch offset $0D50; whole 16-bit word += relocation delta
    defb 055h, 00dh      ; runtime $4552, stored $6312: #0442 word patch offset $0D55; whole 16-bit word += relocation delta
    defb 072h, 00dh      ; runtime $4554, stored $6314: #0443 word patch offset $0D72; whole 16-bit word += relocation delta
    defb 07bh, 00dh      ; runtime $4556, stored $6316: #0444 word patch offset $0D7B; whole 16-bit word += relocation delta
    defb 083h, 00dh      ; runtime $4558, stored $6318: #0445 word patch offset $0D83; whole 16-bit word += relocation delta
    defb 086h, 00dh      ; runtime $455A, stored $631A: #0446 word patch offset $0D86; whole 16-bit word += relocation delta
    defb 08ch, 00dh      ; runtime $455C, stored $631C: #0447 word patch offset $0D8C; whole 16-bit word += relocation delta
    defb 08fh, 00dh      ; runtime $455E, stored $631E: #0448 word patch offset $0D8F; whole 16-bit word += relocation delta
    defb 096h, 00dh      ; runtime $4560, stored $6320: #0449 word patch offset $0D96; whole 16-bit word += relocation delta
    defb 0beh, 00dh      ; runtime $4562, stored $6322: #0450 word patch offset $0DBE; whole 16-bit word += relocation delta
    defb 0c9h, 00dh      ; runtime $4564, stored $6324: #0451 word patch offset $0DC9; whole 16-bit word += relocation delta
    defb 0cch, 00dh      ; runtime $4566, stored $6326: #0452 word patch offset $0DCC; whole 16-bit word += relocation delta
    defb 0d4h, 00dh      ; runtime $4568, stored $6328: #0453 word patch offset $0DD4; whole 16-bit word += relocation delta
    defb 0d7h, 00dh      ; runtime $456A, stored $632A: #0454 word patch offset $0DD7; whole 16-bit word += relocation delta
    defb 0ddh, 00dh      ; runtime $456C, stored $632C: #0455 word patch offset $0DDD; whole 16-bit word += relocation delta
    defb 0e3h, 00dh      ; runtime $456E, stored $632E: #0456 word patch offset $0DE3; whole 16-bit word += relocation delta
    defb 0ech, 00dh      ; runtime $4570, stored $6330: #0457 word patch offset $0DEC; whole 16-bit word += relocation delta
    defb 0f1h, 00dh      ; runtime $4572, stored $6332: #0458 word patch offset $0DF1; whole 16-bit word += relocation delta
    defb 0f4h, 00dh      ; runtime $4574, stored $6334: #0459 word patch offset $0DF4; whole 16-bit word += relocation delta
    defb 0fah, 00dh      ; runtime $4576, stored $6336: #0460 word patch offset $0DFA; whole 16-bit word += relocation delta
    defb 0fdh, 00dh      ; runtime $4578, stored $6338: #0461 word patch offset $0DFD; whole 16-bit word += relocation delta
    defb 005h, 00eh      ; runtime $457A, stored $633A: #0462 word patch offset $0E05; whole 16-bit word += relocation delta
    defb 008h, 00eh      ; runtime $457C, stored $633C: #0463 word patch offset $0E08; whole 16-bit word += relocation delta
    defb 00bh, 00eh      ; runtime $457E, stored $633E: #0464 word patch offset $0E0B; whole 16-bit word += relocation delta
    defb 00eh, 00eh      ; runtime $4580, stored $6340: #0465 word patch offset $0E0E; whole 16-bit word += relocation delta
    defb 011h, 00eh      ; runtime $4582, stored $6342: #0466 word patch offset $0E11; whole 16-bit word += relocation delta
    defb 017h, 00eh      ; runtime $4584, stored $6344: #0467 word patch offset $0E17; whole 16-bit word += relocation delta
    defb 01ch, 00eh      ; runtime $4586, stored $6346: #0468 word patch offset $0E1C; whole 16-bit word += relocation delta
    defb 029h, 00eh      ; runtime $4588, stored $6348: #0469 word patch offset $0E29; whole 16-bit word += relocation delta
    defb 02ch, 00eh      ; runtime $458A, stored $634A: #0470 word patch offset $0E2C; whole 16-bit word += relocation delta
    defb 033h, 00eh      ; runtime $458C, stored $634C: #0471 word patch offset $0E33; whole 16-bit word += relocation delta
    defb 037h, 00eh      ; runtime $458E, stored $634E: #0472 word patch offset $0E37; whole 16-bit word += relocation delta
    defb 03ch, 00eh      ; runtime $4590, stored $6350: #0473 word patch offset $0E3C; whole 16-bit word += relocation delta
    defb 045h, 00eh      ; runtime $4592, stored $6352: #0474 word patch offset $0E45; whole 16-bit word += relocation delta
    defb 04ah, 00eh      ; runtime $4594, stored $6354: #0475 word patch offset $0E4A; whole 16-bit word += relocation delta
    defb 055h, 00eh      ; runtime $4596, stored $6356: #0476 word patch offset $0E55; whole 16-bit word += relocation delta
    defb 060h, 00eh      ; runtime $4598, stored $6358: #0477 word patch offset $0E60; whole 16-bit word += relocation delta
    defb 068h, 00eh      ; runtime $459A, stored $635A: #0478 word patch offset $0E68; whole 16-bit word += relocation delta
    defb 074h, 00eh      ; runtime $459C, stored $635C: #0479 word patch offset $0E74; whole 16-bit word += relocation delta
    defb 079h, 00eh      ; runtime $459E, stored $635E: #0480 word patch offset $0E79; whole 16-bit word += relocation delta
    defb 07ch, 00eh      ; runtime $45A0, stored $6360: #0481 word patch offset $0E7C; whole 16-bit word += relocation delta
    defb 081h, 00eh      ; runtime $45A2, stored $6362: #0482 word patch offset $0E81; whole 16-bit word += relocation delta
    defb 08eh, 00eh      ; runtime $45A4, stored $6364: #0483 word patch offset $0E8E; whole 16-bit word += relocation delta
    defb 099h, 00eh      ; runtime $45A6, stored $6366: #0484 word patch offset $0E99; whole 16-bit word += relocation delta
    defb 0a1h, 00eh      ; runtime $45A8, stored $6368: #0485 word patch offset $0EA1; whole 16-bit word += relocation delta
    defb 0adh, 00eh      ; runtime $45AA, stored $636A: #0486 word patch offset $0EAD; whole 16-bit word += relocation delta
    defb 0b2h, 00eh      ; runtime $45AC, stored $636C: #0487 word patch offset $0EB2; whole 16-bit word += relocation delta
    defb 0b5h, 00eh      ; runtime $45AE, stored $636E: #0488 word patch offset $0EB5; whole 16-bit word += relocation delta
    defb 0bah, 00eh      ; runtime $45B0, stored $6370: #0489 word patch offset $0EBA; whole 16-bit word += relocation delta
    defb 0cah, 00eh      ; runtime $45B2, stored $6372: #0490 word patch offset $0ECA; whole 16-bit word += relocation delta
    defb 0cdh, 00eh      ; runtime $45B4, stored $6374: #0491 word patch offset $0ECD; whole 16-bit word += relocation delta
    defb 0d0h, 00eh      ; runtime $45B6, stored $6376: #0492 word patch offset $0ED0; whole 16-bit word += relocation delta
    defb 0d5h, 00eh      ; runtime $45B8, stored $6378: #0493 word patch offset $0ED5; whole 16-bit word += relocation delta
    defb 0d8h, 00eh      ; runtime $45BA, stored $637A: #0494 word patch offset $0ED8; whole 16-bit word += relocation delta
    defb 0e1h, 00eh      ; runtime $45BC, stored $637C: #0495 word patch offset $0EE1; whole 16-bit word += relocation delta
    defb 0e4h, 00eh      ; runtime $45BE, stored $637E: #0496 word patch offset $0EE4; whole 16-bit word += relocation delta
    defb 0e7h, 00eh      ; runtime $45C0, stored $6380: #0497 word patch offset $0EE7; whole 16-bit word += relocation delta
    defb 0eah, 00eh      ; runtime $45C2, stored $6382: #0498 word patch offset $0EEA; whole 16-bit word += relocation delta
    defb 0efh, 00eh      ; runtime $45C4, stored $6384: #0499 word patch offset $0EEF; whole 16-bit word += relocation delta
    defb 0fah, 00eh      ; runtime $45C6, stored $6386: #0500 word patch offset $0EFA; whole 16-bit word += relocation delta
    defb 0fdh, 00eh      ; runtime $45C8, stored $6388: #0501 word patch offset $0EFD; whole 16-bit word += relocation delta
    defb 000h, 00fh      ; runtime $45CA, stored $638A: #0502 word patch offset $0F00; whole 16-bit word += relocation delta
    defb 00bh, 00fh      ; runtime $45CC, stored $638C: #0503 word patch offset $0F0B; whole 16-bit word += relocation delta
    defb 00eh, 00fh      ; runtime $45CE, stored $638E: #0504 word patch offset $0F0E; whole 16-bit word += relocation delta
    defb 014h, 00fh      ; runtime $45D0, stored $6390: #0505 word patch offset $0F14; whole 16-bit word += relocation delta
    defb 01eh, 00fh      ; runtime $45D2, stored $6392: #0506 word patch offset $0F1E; whole 16-bit word += relocation delta
    defb 021h, 00fh      ; runtime $45D4, stored $6394: #0507 word patch offset $0F21; whole 16-bit word += relocation delta
    defb 025h, 00fh      ; runtime $45D6, stored $6396: #0508 word patch offset $0F25; whole 16-bit word += relocation delta
    defb 028h, 00fh      ; runtime $45D8, stored $6398: #0509 word patch offset $0F28; whole 16-bit word += relocation delta
    defb 02eh, 00fh      ; runtime $45DA, stored $639A: #0510 word patch offset $0F2E; whole 16-bit word += relocation delta
    defb 032h, 00fh      ; runtime $45DC, stored $639C: #0511 word patch offset $0F32; whole 16-bit word += relocation delta
    defb 03ah, 00fh      ; runtime $45DE, stored $639E: #0512 word patch offset $0F3A; whole 16-bit word += relocation delta
    defb 03dh, 00fh      ; runtime $45E0, stored $63A0: #0513 word patch offset $0F3D; whole 16-bit word += relocation delta
    defb 043h, 00fh      ; runtime $45E2, stored $63A2: #0514 word patch offset $0F43; whole 16-bit word += relocation delta
    defb 048h, 00fh      ; runtime $45E4, stored $63A4: #0515 word patch offset $0F48; whole 16-bit word += relocation delta
    defb 04ch, 00fh      ; runtime $45E6, stored $63A6: #0516 word patch offset $0F4C; whole 16-bit word += relocation delta
    defb 04fh, 00fh      ; runtime $45E8, stored $63A8: #0517 word patch offset $0F4F; whole 16-bit word += relocation delta
    defb 052h, 00fh      ; runtime $45EA, stored $63AA: #0518 word patch offset $0F52; whole 16-bit word += relocation delta
    defb 08fh, 00fh      ; runtime $45EC, stored $63AC: #0519 word patch offset $0F8F; whole 16-bit word += relocation delta
    defb 09eh, 00fh      ; runtime $45EE, stored $63AE: #0520 word patch offset $0F9E; whole 16-bit word += relocation delta
    defb 0bch, 00fh      ; runtime $45F0, stored $63B0: #0521 word patch offset $0FBC; whole 16-bit word += relocation delta
    defb 0e1h, 00fh      ; runtime $45F2, stored $63B2: #0522 word patch offset $0FE1; whole 16-bit word += relocation delta
    defb 0f0h, 00fh      ; runtime $45F4, stored $63B4: #0523 word patch offset $0FF0; whole 16-bit word += relocation delta
    defb 0f3h, 00fh      ; runtime $45F6, stored $63B6: #0524 word patch offset $0FF3; whole 16-bit word += relocation delta
    defb 0fbh, 00fh      ; runtime $45F8, stored $63B8: #0525 word patch offset $0FFB; whole 16-bit word += relocation delta
    defb 004h, 010h      ; runtime $45FA, stored $63BA: #0526 word patch offset $1004; whole 16-bit word += relocation delta
    defb 007h, 010h      ; runtime $45FC, stored $63BC: #0527 word patch offset $1007; whole 16-bit word += relocation delta
    defb 00ah, 010h      ; runtime $45FE, stored $63BE: #0528 word patch offset $100A; whole 16-bit word += relocation delta
    defb 00fh, 010h      ; runtime $4600, stored $63C0: #0529 word patch offset $100F; whole 16-bit word += relocation delta
    defb 012h, 010h      ; runtime $4602, stored $63C2: #0530 word patch offset $1012; whole 16-bit word += relocation delta
    defb 015h, 010h      ; runtime $4604, stored $63C4: #0531 word patch offset $1015; whole 16-bit word += relocation delta
    defb 01ah, 010h      ; runtime $4606, stored $63C6: #0532 word patch offset $101A; whole 16-bit word += relocation delta
    defb 020h, 010h      ; runtime $4608, stored $63C8: #0533 word patch offset $1020; whole 16-bit word += relocation delta
    defb 023h, 010h      ; runtime $460A, stored $63CA: #0534 word patch offset $1023; whole 16-bit word += relocation delta
    defb 028h, 010h      ; runtime $460C, stored $63CC: #0535 word patch offset $1028; whole 16-bit word += relocation delta
    defb 02bh, 010h      ; runtime $460E, stored $63CE: #0536 word patch offset $102B; whole 16-bit word += relocation delta
    defb 02eh, 010h      ; runtime $4610, stored $63D0: #0537 word patch offset $102E; whole 16-bit word += relocation delta
    defb 036h, 010h      ; runtime $4612, stored $63D2: #0538 word patch offset $1036; whole 16-bit word += relocation delta
    defb 039h, 010h      ; runtime $4614, stored $63D4: #0539 word patch offset $1039; whole 16-bit word += relocation delta
    defb 03ch, 010h      ; runtime $4616, stored $63D6: #0540 word patch offset $103C; whole 16-bit word += relocation delta
    defb 040h, 010h      ; runtime $4618, stored $63D8: #0541 word patch offset $1040; whole 16-bit word += relocation delta
    defb 043h, 010h      ; runtime $461A, stored $63DA: #0542 word patch offset $1043; whole 16-bit word += relocation delta
    defb 046h, 010h      ; runtime $461C, stored $63DC: #0543 word patch offset $1046; whole 16-bit word += relocation delta
    defb 04fh, 010h      ; runtime $461E, stored $63DE: #0544 word patch offset $104F; whole 16-bit word += relocation delta
    defb 052h, 010h      ; runtime $4620, stored $63E0: #0545 word patch offset $1052; whole 16-bit word += relocation delta
    defb 056h, 010h      ; runtime $4622, stored $63E2: #0546 word patch offset $1056; whole 16-bit word += relocation delta
    defb 05eh, 010h      ; runtime $4624, stored $63E4: #0547 word patch offset $105E; whole 16-bit word += relocation delta
    defb 06ah, 010h      ; runtime $4626, stored $63E6: #0548 word patch offset $106A; whole 16-bit word += relocation delta
    defb 06eh, 010h      ; runtime $4628, stored $63E8: #0549 word patch offset $106E; whole 16-bit word += relocation delta
    defb 086h, 010h      ; runtime $462A, stored $63EA: #0550 word patch offset $1086; whole 16-bit word += relocation delta
    defb 089h, 010h      ; runtime $462C, stored $63EC: #0551 word patch offset $1089; whole 16-bit word += relocation delta
    defb 08ch, 010h      ; runtime $462E, stored $63EE: #0552 word patch offset $108C; whole 16-bit word += relocation delta
    defb 08fh, 010h      ; runtime $4630, stored $63F0: #0553 word patch offset $108F; whole 16-bit word += relocation delta
    defb 092h, 010h      ; runtime $4632, stored $63F2: #0554 word patch offset $1092; whole 16-bit word += relocation delta
    defb 096h, 010h      ; runtime $4634, stored $63F4: #0555 word patch offset $1096; whole 16-bit word += relocation delta
    defb 09bh, 010h      ; runtime $4636, stored $63F6: #0556 word patch offset $109B; whole 16-bit word += relocation delta
    defb 0a3h, 010h      ; runtime $4638, stored $63F8: #0557 word patch offset $10A3; whole 16-bit word += relocation delta
    defb 0b2h, 010h      ; runtime $463A, stored $63FA: #0558 word patch offset $10B2; whole 16-bit word += relocation delta
    defb 0c0h, 010h      ; runtime $463C, stored $63FC: #0559 word patch offset $10C0; whole 16-bit word += relocation delta
    defb 0e0h, 010h      ; runtime $463E, stored $63FE: #0560 word patch offset $10E0; whole 16-bit word += relocation delta
    defb 0e3h, 010h      ; runtime $4640, stored $6400: #0561 word patch offset $10E3; whole 16-bit word += relocation delta
    defb 0e8h, 010h      ; runtime $4642, stored $6402: #0562 word patch offset $10E8; whole 16-bit word += relocation delta
    defb 0ebh, 010h      ; runtime $4644, stored $6404: #0563 word patch offset $10EB; whole 16-bit word += relocation delta
    defb 0eeh, 010h      ; runtime $4646, stored $6406: #0564 word patch offset $10EE; whole 16-bit word += relocation delta
    defb 0feh, 010h      ; runtime $4648, stored $6408: #0565 word patch offset $10FE; whole 16-bit word += relocation delta
    defb 003h, 011h      ; runtime $464A, stored $640A: #0566 word patch offset $1103; whole 16-bit word += relocation delta
    defb 014h, 011h      ; runtime $464C, stored $640C: #0567 word patch offset $1114; whole 16-bit word += relocation delta
    defb 01eh, 011h      ; runtime $464E, stored $640E: #0568 word patch offset $111E; whole 16-bit word += relocation delta
    defb 022h, 011h      ; runtime $4650, stored $6410: #0569 word patch offset $1122; whole 16-bit word += relocation delta
    defb 02ch, 011h      ; runtime $4652, stored $6412: #0570 word patch offset $112C; whole 16-bit word += relocation delta
    defb 04ch, 011h      ; runtime $4654, stored $6414: #0571 word patch offset $114C; whole 16-bit word += relocation delta
    defb 051h, 011h      ; runtime $4656, stored $6416: #0572 word patch offset $1151; whole 16-bit word += relocation delta
    defb 061h, 011h      ; runtime $4658, stored $6418: #0573 word patch offset $1161; whole 16-bit word += relocation delta
    defb 064h, 011h      ; runtime $465A, stored $641A: #0574 word patch offset $1164; whole 16-bit word += relocation delta
    defb 067h, 011h      ; runtime $465C, stored $641C: #0575 word patch offset $1167; whole 16-bit word += relocation delta
    defb 06ch, 011h      ; runtime $465E, stored $641E: #0576 word patch offset $116C; whole 16-bit word += relocation delta
    defb 071h, 011h      ; runtime $4660, stored $6420: #0577 word patch offset $1171; whole 16-bit word += relocation delta
    defb 07ah, 011h      ; runtime $4662, stored $6422: #0578 word patch offset $117A; whole 16-bit word += relocation delta
    defb 081h, 011h      ; runtime $4664, stored $6424: #0579 word patch offset $1181; whole 16-bit word += relocation delta
    defb 088h, 011h      ; runtime $4666, stored $6426: #0580 word patch offset $1188; whole 16-bit word += relocation delta
    defb 0b2h, 011h      ; runtime $4668, stored $6428: #0581 word patch offset $11B2; whole 16-bit word += relocation delta
    defb 0b6h, 011h      ; runtime $466A, stored $642A: #0582 word patch offset $11B6; whole 16-bit word += relocation delta
    defb 0b9h, 011h      ; runtime $466C, stored $642C: #0583 word patch offset $11B9; whole 16-bit word += relocation delta
    defb 0bch, 011h      ; runtime $466E, stored $642E: #0584 word patch offset $11BC; whole 16-bit word += relocation delta
    defb 0bfh, 011h      ; runtime $4670, stored $6430: #0585 word patch offset $11BF; whole 16-bit word += relocation delta
    defb 0c2h, 011h      ; runtime $4672, stored $6432: #0586 word patch offset $11C2; whole 16-bit word += relocation delta
    defb 0c5h, 011h      ; runtime $4674, stored $6434: #0587 word patch offset $11C5; whole 16-bit word += relocation delta
    defb 0c8h, 011h      ; runtime $4676, stored $6436: #0588 word patch offset $11C8; whole 16-bit word += relocation delta
    defb 0ceh, 011h      ; runtime $4678, stored $6438: #0589 word patch offset $11CE; whole 16-bit word += relocation delta
    defb 0d6h, 011h      ; runtime $467A, stored $643A: #0590 word patch offset $11D6; whole 16-bit word += relocation delta
    defb 0d9h, 011h      ; runtime $467C, stored $643C: #0591 word patch offset $11D9; whole 16-bit word += relocation delta
    defb 0dch, 011h      ; runtime $467E, stored $643E: #0592 word patch offset $11DC; whole 16-bit word += relocation delta
    defb 0dfh, 011h      ; runtime $4680, stored $6440: #0593 word patch offset $11DF; whole 16-bit word += relocation delta
    defb 0e3h, 011h      ; runtime $4682, stored $6442: #0594 word patch offset $11E3; whole 16-bit word += relocation delta
    defb 0efh, 011h      ; runtime $4684, stored $6444: #0595 word patch offset $11EF; whole 16-bit word += relocation delta
    defb 0feh, 011h      ; runtime $4686, stored $6446: #0596 word patch offset $11FE; whole 16-bit word += relocation delta
    defb 001h, 012h      ; runtime $4688, stored $6448: #0597 word patch offset $1201; whole 16-bit word += relocation delta
    defb 00fh, 012h      ; runtime $468A, stored $644A: #0598 word patch offset $120F; whole 16-bit word += relocation delta
    defb 02ah, 012h      ; runtime $468C, stored $644C: #0599 word patch offset $122A; whole 16-bit word += relocation delta
    defb 02dh, 012h      ; runtime $468E, stored $644E: #0600 word patch offset $122D; whole 16-bit word += relocation delta
    defb 04ch, 012h      ; runtime $4690, stored $6450: #0601 word patch offset $124C; whole 16-bit word += relocation delta
    defb 053h, 012h      ; runtime $4692, stored $6452: #0602 word patch offset $1253; whole 16-bit word += relocation delta
    defb 078h, 012h      ; runtime $4694, stored $6454: #0603 word patch offset $1278; whole 16-bit word += relocation delta
    defb 07eh, 012h      ; runtime $4696, stored $6456: #0604 word patch offset $127E; whole 16-bit word += relocation delta
    defb 084h, 012h      ; runtime $4698, stored $6458: #0605 word patch offset $1284; whole 16-bit word += relocation delta
    defb 091h, 012h      ; runtime $469A, stored $645A: #0606 word patch offset $1291; whole 16-bit word += relocation delta
    defb 099h, 012h      ; runtime $469C, stored $645C: #0607 word patch offset $1299; whole 16-bit word += relocation delta
    defb 0ach, 012h      ; runtime $469E, stored $645E: #0608 word patch offset $12AC; whole 16-bit word += relocation delta
    defb 0afh, 012h      ; runtime $46A0, stored $6460: #0609 word patch offset $12AF; whole 16-bit word += relocation delta
    defb 0b4h, 012h      ; runtime $46A2, stored $6462: #0610 word patch offset $12B4; whole 16-bit word += relocation delta
    defb 0c7h, 012h      ; runtime $46A4, stored $6464: #0611 word patch offset $12C7; whole 16-bit word += relocation delta
    defb 0d7h, 012h      ; runtime $46A6, stored $6466: #0612 word patch offset $12D7; whole 16-bit word += relocation delta
    defb 0dah, 012h      ; runtime $46A8, stored $6468: #0613 word patch offset $12DA; whole 16-bit word += relocation delta
    defb 0e8h, 012h      ; runtime $46AA, stored $646A: #0614 word patch offset $12E8; whole 16-bit word += relocation delta
    defb 036h, 013h      ; runtime $46AC, stored $646C: #0615 word patch offset $1336; whole 16-bit word += relocation delta
    defb 03ah, 013h      ; runtime $46AE, stored $646E: #0616 word patch offset $133A; whole 16-bit word += relocation delta
    defb 049h, 013h      ; runtime $46B0, stored $6470: #0617 word patch offset $1349; whole 16-bit word += relocation delta
    defb 05ch, 013h      ; runtime $46B2, stored $6472: #0618 word patch offset $135C; whole 16-bit word += relocation delta
    defb 080h, 013h      ; runtime $46B4, stored $6474: #0619 word patch offset $1380; whole 16-bit word += relocation delta
    defb 083h, 013h      ; runtime $46B6, stored $6476: #0620 word patch offset $1383; whole 16-bit word += relocation delta
    defb 088h, 013h      ; runtime $46B8, stored $6478: #0621 word patch offset $1388; whole 16-bit word += relocation delta
    defb 092h, 013h      ; runtime $46BA, stored $647A: #0622 word patch offset $1392; whole 16-bit word += relocation delta
    defb 097h, 013h      ; runtime $46BC, stored $647C: #0623 word patch offset $1397; whole 16-bit word += relocation delta
    defb 09bh, 013h      ; runtime $46BE, stored $647E: #0624 word patch offset $139B; whole 16-bit word += relocation delta
    defb 0a8h, 013h      ; runtime $46C0, stored $6480: #0625 word patch offset $13A8; whole 16-bit word += relocation delta
    defb 0adh, 013h      ; runtime $46C2, stored $6482: #0626 word patch offset $13AD; whole 16-bit word += relocation delta
    defb 0b2h, 013h      ; runtime $46C4, stored $6484: #0627 word patch offset $13B2; whole 16-bit word += relocation delta
    defb 0b7h, 013h      ; runtime $46C6, stored $6486: #0628 word patch offset $13B7; whole 16-bit word += relocation delta
    defb 0bah, 013h      ; runtime $46C8, stored $6488: #0629 word patch offset $13BA; whole 16-bit word += relocation delta
    defb 0bdh, 013h      ; runtime $46CA, stored $648A: #0630 word patch offset $13BD; whole 16-bit word += relocation delta
    defb 0d4h, 013h      ; runtime $46CC, stored $648C: #0631 word patch offset $13D4; whole 16-bit word += relocation delta
    defb 0dbh, 013h      ; runtime $46CE, stored $648E: #0632 word patch offset $13DB; whole 16-bit word += relocation delta
    defb 0ebh, 013h      ; runtime $46D0, stored $6490: #0633 word patch offset $13EB; whole 16-bit word += relocation delta
    defb 0f5h, 013h      ; runtime $46D2, stored $6492: #0634 word patch offset $13F5; whole 16-bit word += relocation delta
    defb 0ffh, 013h      ; runtime $46D4, stored $6494: #0635 word patch offset $13FF; whole 16-bit word += relocation delta
    defb 002h, 014h      ; runtime $46D6, stored $6496: #0636 word patch offset $1402; whole 16-bit word += relocation delta
    defb 00ch, 014h      ; runtime $46D8, stored $6498: #0637 word patch offset $140C; whole 16-bit word += relocation delta
    defb 018h, 014h      ; runtime $46DA, stored $649A: #0638 word patch offset $1418; whole 16-bit word += relocation delta
    defb 01dh, 014h      ; runtime $46DC, stored $649C: #0639 word patch offset $141D; whole 16-bit word += relocation delta
    defb 021h, 014h      ; runtime $46DE, stored $649E: #0640 word patch offset $1421; whole 16-bit word += relocation delta
    defb 025h, 014h      ; runtime $46E0, stored $64A0: #0641 word patch offset $1425; whole 16-bit word += relocation delta
    defb 045h, 014h      ; runtime $46E2, stored $64A2: #0642 word patch offset $1445; whole 16-bit word += relocation delta
    defb 048h, 014h      ; runtime $46E4, stored $64A4: #0643 word patch offset $1448; whole 16-bit word += relocation delta
    defb 091h, 014h      ; runtime $46E6, stored $64A6: #0644 word patch offset $1491; whole 16-bit word += relocation delta
    defb 099h, 014h      ; runtime $46E8, stored $64A8: #0645 word patch offset $1499; whole 16-bit word += relocation delta
    defb 0a2h, 014h      ; runtime $46EA, stored $64AA: #0646 word patch offset $14A2; whole 16-bit word += relocation delta
    defb 0c2h, 014h      ; runtime $46EC, stored $64AC: #0647 word patch offset $14C2; whole 16-bit word += relocation delta
    defb 0c5h, 014h      ; runtime $46EE, stored $64AE: #0648 word patch offset $14C5; whole 16-bit word += relocation delta
    defb 0d0h, 014h      ; runtime $46F0, stored $64B0: #0649 word patch offset $14D0; whole 16-bit word += relocation delta
    defb 0d3h, 014h      ; runtime $46F2, stored $64B2: #0650 word patch offset $14D3; whole 16-bit word += relocation delta
    defb 0dch, 014h      ; runtime $46F4, stored $64B4: #0651 word patch offset $14DC; whole 16-bit word += relocation delta
    defb 0e4h, 014h      ; runtime $46F6, stored $64B6: #0652 word patch offset $14E4; whole 16-bit word += relocation delta
    defb 0efh, 014h      ; runtime $46F8, stored $64B8: #0653 word patch offset $14EF; whole 16-bit word += relocation delta
    defb 001h, 015h      ; runtime $46FA, stored $64BA: #0654 word patch offset $1501; whole 16-bit word += relocation delta
    defb 00bh, 015h      ; runtime $46FC, stored $64BC: #0655 word patch offset $150B; whole 16-bit word += relocation delta
    defb 011h, 015h      ; runtime $46FE, stored $64BE: #0656 word patch offset $1511; whole 16-bit word += relocation delta
    defb 028h, 015h      ; runtime $4700, stored $64C0: #0657 word patch offset $1528; whole 16-bit word += relocation delta
    defb 02bh, 015h      ; runtime $4702, stored $64C2: #0658 word patch offset $152B; whole 16-bit word += relocation delta
    defb 036h, 015h      ; runtime $4704, stored $64C4: #0659 word patch offset $1536; whole 16-bit word += relocation delta
    defb 049h, 015h      ; runtime $4706, stored $64C6: #0660 word patch offset $1549; whole 16-bit word += relocation delta
    defb 04ch, 015h      ; runtime $4708, stored $64C8: #0661 word patch offset $154C; whole 16-bit word += relocation delta
    defb 052h, 015h      ; runtime $470A, stored $64CA: #0662 word patch offset $1552; whole 16-bit word += relocation delta
    defb 05dh, 015h      ; runtime $470C, stored $64CC: #0663 word patch offset $155D; whole 16-bit word += relocation delta
    defb 065h, 015h      ; runtime $470E, stored $64CE: #0664 word patch offset $1565; whole 16-bit word += relocation delta
    defb 070h, 015h      ; runtime $4710, stored $64D0: #0665 word patch offset $1570; whole 16-bit word += relocation delta
    defb 079h, 015h      ; runtime $4712, stored $64D2: #0666 word patch offset $1579; whole 16-bit word += relocation delta
    defb 080h, 015h      ; runtime $4714, stored $64D4: #0667 word patch offset $1580; whole 16-bit word += relocation delta
    defb 088h, 015h      ; runtime $4716, stored $64D6: #0668 word patch offset $1588; whole 16-bit word += relocation delta
    defb 08ch, 015h      ; runtime $4718, stored $64D8: #0669 word patch offset $158C; whole 16-bit word += relocation delta
    defb 091h, 015h      ; runtime $471A, stored $64DA: #0670 word patch offset $1591; whole 16-bit word += relocation delta
    defb 095h, 015h      ; runtime $471C, stored $64DC: #0671 word patch offset $1595; whole 16-bit word += relocation delta
    defb 0a6h, 015h      ; runtime $471E, stored $64DE: #0672 word patch offset $15A6; whole 16-bit word += relocation delta
    defb 0efh, 015h      ; runtime $4720, stored $64E0: #0673 word patch offset $15EF; whole 16-bit word += relocation delta
    defb 0f8h, 015h      ; runtime $4722, stored $64E2: #0674 word patch offset $15F8; whole 16-bit word += relocation delta
    defb 004h, 016h      ; runtime $4724, stored $64E4: #0675 word patch offset $1604; whole 16-bit word += relocation delta
    defb 007h, 016h      ; runtime $4726, stored $64E6: #0676 word patch offset $1607; whole 16-bit word += relocation delta
    defb 00bh, 016h      ; runtime $4728, stored $64E8: #0677 word patch offset $160B; whole 16-bit word += relocation delta
    defb 05bh, 016h      ; runtime $472A, stored $64EA: #0678 word patch offset $165B; whole 16-bit word += relocation delta
    defb 065h, 016h      ; runtime $472C, stored $64EC: #0679 word patch offset $1665; whole 16-bit word += relocation delta
    defb 090h, 016h      ; runtime $472E, stored $64EE: #0680 word patch offset $1690; whole 16-bit word += relocation delta
    defb 0b2h, 016h      ; runtime $4730, stored $64F0: #0681 word patch offset $16B2; whole 16-bit word += relocation delta
    defb 0c1h, 016h      ; runtime $4732, stored $64F2: #0682 word patch offset $16C1; whole 16-bit word += relocation delta
    defb 0cch, 016h      ; runtime $4734, stored $64F4: #0683 word patch offset $16CC; whole 16-bit word += relocation delta
    defb 0d5h, 016h      ; runtime $4736, stored $64F6: #0684 word patch offset $16D5; whole 16-bit word += relocation delta
    defb 0d8h, 016h      ; runtime $4738, stored $64F8: #0685 word patch offset $16D8; whole 16-bit word += relocation delta
    defb 0deh, 016h      ; runtime $473A, stored $64FA: #0686 word patch offset $16DE; whole 16-bit word += relocation delta
    defb 0e1h, 016h      ; runtime $473C, stored $64FC: #0687 word patch offset $16E1; whole 16-bit word += relocation delta
    defb 0e5h, 016h      ; runtime $473E, stored $64FE: #0688 word patch offset $16E5; whole 16-bit word += relocation delta
    defb 0eah, 016h      ; runtime $4740, stored $6500: #0689 word patch offset $16EA; whole 16-bit word += relocation delta
    defb 0f3h, 016h      ; runtime $4742, stored $6502: #0690 word patch offset $16F3; whole 16-bit word += relocation delta
    defb 0f8h, 016h      ; runtime $4744, stored $6504: #0691 word patch offset $16F8; whole 16-bit word += relocation delta
    defb 0fch, 016h      ; runtime $4746, stored $6506: #0692 word patch offset $16FC; whole 16-bit word += relocation delta
    defb 001h, 017h      ; runtime $4748, stored $6508: #0693 word patch offset $1701; whole 16-bit word += relocation delta
    defb 00ch, 017h      ; runtime $474A, stored $650A: #0694 word patch offset $170C; whole 16-bit word += relocation delta
    defb 020h, 017h      ; runtime $474C, stored $650C: #0695 word patch offset $1720; whole 16-bit word += relocation delta
    defb 024h, 017h      ; runtime $474E, stored $650E: #0696 word patch offset $1724; whole 16-bit word += relocation delta
    defb 02fh, 017h      ; runtime $4750, stored $6510: #0697 word patch offset $172F; whole 16-bit word += relocation delta
    defb 03dh, 017h      ; runtime $4752, stored $6512: #0698 word patch offset $173D; whole 16-bit word += relocation delta
    defb 047h, 017h      ; runtime $4754, stored $6514: #0699 word patch offset $1747; whole 16-bit word += relocation delta
    defb 04dh, 017h      ; runtime $4756, stored $6516: #0700 word patch offset $174D; whole 16-bit word += relocation delta
    defb 050h, 017h      ; runtime $4758, stored $6518: #0701 word patch offset $1750; whole 16-bit word += relocation delta
    defb 059h, 017h      ; runtime $475A, stored $651A: #0702 word patch offset $1759; whole 16-bit word += relocation delta
    defb 073h, 017h      ; runtime $475C, stored $651C: #0703 word patch offset $1773; whole 16-bit word += relocation delta
    defb 07ch, 017h      ; runtime $475E, stored $651E: #0704 word patch offset $177C; whole 16-bit word += relocation delta
    defb 08ah, 017h      ; runtime $4760, stored $6520: #0705 word patch offset $178A; whole 16-bit word += relocation delta
    defb 09fh, 017h      ; runtime $4762, stored $6522: #0706 word patch offset $179F; whole 16-bit word += relocation delta
    defb 0a3h, 017h      ; runtime $4764, stored $6524: #0707 word patch offset $17A3; whole 16-bit word += relocation delta
    defb 0a7h, 017h      ; runtime $4766, stored $6526: #0708 word patch offset $17A7; whole 16-bit word += relocation delta
    defb 0b4h, 017h      ; runtime $4768, stored $6528: #0709 word patch offset $17B4; whole 16-bit word += relocation delta
    defb 0bfh, 017h      ; runtime $476A, stored $652A: #0710 word patch offset $17BF; whole 16-bit word += relocation delta
    defb 0e0h, 017h      ; runtime $476C, stored $652C: #0711 word patch offset $17E0; whole 16-bit word += relocation delta
    defb 0eeh, 017h      ; runtime $476E, stored $652E: #0712 word patch offset $17EE; whole 16-bit word += relocation delta
    defb 0f7h, 017h      ; runtime $4770, stored $6530: #0713 word patch offset $17F7; whole 16-bit word += relocation delta
    defb 05ch, 018h      ; runtime $4772, stored $6532: #0714 word patch offset $185C; whole 16-bit word += relocation delta
    defb 067h, 018h      ; runtime $4774, stored $6534: #0715 word patch offset $1867; whole 16-bit word += relocation delta
    defb 073h, 018h      ; runtime $4776, stored $6536: #0716 word patch offset $1873; whole 16-bit word += relocation delta
    defb 081h, 018h      ; runtime $4778, stored $6538: #0717 word patch offset $1881; whole 16-bit word += relocation delta
    defb 0bch, 018h      ; runtime $477A, stored $653A: #0718 word patch offset $18BC; whole 16-bit word += relocation delta
    defb 0c1h, 018h      ; runtime $477C, stored $653C: #0719 word patch offset $18C1; whole 16-bit word += relocation delta
    defb 0c6h, 018h      ; runtime $477E, stored $653E: #0720 word patch offset $18C6; whole 16-bit word += relocation delta
    defb 0c9h, 018h      ; runtime $4780, stored $6540: #0721 word patch offset $18C9; whole 16-bit word += relocation delta
    defb 0d4h, 018h      ; runtime $4782, stored $6542: #0722 word patch offset $18D4; whole 16-bit word += relocation delta
    defb 0e2h, 018h      ; runtime $4784, stored $6544: #0723 word patch offset $18E2; whole 16-bit word += relocation delta
    defb 0e6h, 018h      ; runtime $4786, stored $6546: #0724 word patch offset $18E6; whole 16-bit word += relocation delta
    defb 0edh, 018h      ; runtime $4788, stored $6548: #0725 word patch offset $18ED; whole 16-bit word += relocation delta
    defb 0f9h, 018h      ; runtime $478A, stored $654A: #0726 word patch offset $18F9; whole 16-bit word += relocation delta
    defb 0feh, 018h      ; runtime $478C, stored $654C: #0727 word patch offset $18FE; whole 16-bit word += relocation delta
    defb 011h, 019h      ; runtime $478E, stored $654E: #0728 word patch offset $1911; whole 16-bit word += relocation delta
    defb 02ch, 019h      ; runtime $4790, stored $6550: #0729 word patch offset $192C; whole 16-bit word += relocation delta
    defb 030h, 019h      ; runtime $4792, stored $6552: #0730 word patch offset $1930; whole 16-bit word += relocation delta
    defb 036h, 019h      ; runtime $4794, stored $6554: #0731 word patch offset $1936; whole 16-bit word += relocation delta
    defb 045h, 019h      ; runtime $4796, stored $6556: #0732 word patch offset $1945; whole 16-bit word += relocation delta
    defb 048h, 019h      ; runtime $4798, stored $6558: #0733 word patch offset $1948; whole 16-bit word += relocation delta
    defb 04bh, 019h      ; runtime $479A, stored $655A: #0734 word patch offset $194B; whole 16-bit word += relocation delta
    defb 04eh, 019h      ; runtime $479C, stored $655C: #0735 word patch offset $194E; whole 16-bit word += relocation delta
    defb 054h, 019h      ; runtime $479E, stored $655E: #0736 word patch offset $1954; whole 16-bit word += relocation delta
    defb 060h, 019h      ; runtime $47A0, stored $6560: #0737 word patch offset $1960; whole 16-bit word += relocation delta
    defb 089h, 019h      ; runtime $47A2, stored $6562: #0738 word patch offset $1989; whole 16-bit word += relocation delta
    defb 092h, 019h      ; runtime $47A4, stored $6564: #0739 word patch offset $1992; whole 16-bit word += relocation delta
    defb 09fh, 019h      ; runtime $47A6, stored $6566: #0740 word patch offset $199F; whole 16-bit word += relocation delta
    defb 0a3h, 019h      ; runtime $47A8, stored $6568: #0741 word patch offset $19A3; whole 16-bit word += relocation delta
    defb 0a6h, 019h      ; runtime $47AA, stored $656A: #0742 word patch offset $19A6; whole 16-bit word += relocation delta
    defb 0aah, 019h      ; runtime $47AC, stored $656C: #0743 word patch offset $19AA; whole 16-bit word += relocation delta
    defb 0b0h, 019h      ; runtime $47AE, stored $656E: #0744 word patch offset $19B0; whole 16-bit word += relocation delta
    defb 0b3h, 019h      ; runtime $47B0, stored $6570: #0745 word patch offset $19B3; whole 16-bit word += relocation delta
    defb 0b6h, 019h      ; runtime $47B2, stored $6572: #0746 word patch offset $19B6; whole 16-bit word += relocation delta
    defb 0beh, 019h      ; runtime $47B4, stored $6574: #0747 word patch offset $19BE; whole 16-bit word += relocation delta
    defb 0c7h, 019h      ; runtime $47B6, stored $6576: #0748 word patch offset $19C7; whole 16-bit word += relocation delta
    defb 0cdh, 019h      ; runtime $47B8, stored $6578: #0749 word patch offset $19CD; whole 16-bit word += relocation delta
    defb 0d3h, 019h      ; runtime $47BA, stored $657A: #0750 word patch offset $19D3; whole 16-bit word += relocation delta
    defb 0deh, 019h      ; runtime $47BC, stored $657C: #0751 word patch offset $19DE; whole 16-bit word += relocation delta
    defb 0f0h, 019h      ; runtime $47BE, stored $657E: #0752 word patch offset $19F0; whole 16-bit word += relocation delta
    defb 0f9h, 019h      ; runtime $47C0, stored $6580: #0753 word patch offset $19F9; whole 16-bit word += relocation delta
    defb 01ch, 01ah      ; runtime $47C2, stored $6582: #0754 word patch offset $1A1C; whole 16-bit word += relocation delta
    defb 02dh, 01ah      ; runtime $47C4, stored $6584: #0755 word patch offset $1A2D; whole 16-bit word += relocation delta
    defb 032h, 01ah      ; runtime $47C6, stored $6586: #0756 word patch offset $1A32; whole 16-bit word += relocation delta
    defb 038h, 01ah      ; runtime $47C8, stored $6588: #0757 word patch offset $1A38; whole 16-bit word += relocation delta
    defb 040h, 01ah      ; runtime $47CA, stored $658A: #0758 word patch offset $1A40; whole 16-bit word += relocation delta
    defb 046h, 01ah      ; runtime $47CC, stored $658C: #0759 word patch offset $1A46; whole 16-bit word += relocation delta
    defb 04ch, 01ah      ; runtime $47CE, stored $658E: #0760 word patch offset $1A4C; whole 16-bit word += relocation delta
    defb 051h, 01ah      ; runtime $47D0, stored $6590: #0761 word patch offset $1A51; whole 16-bit word += relocation delta
    defb 071h, 01ah      ; runtime $47D2, stored $6592: #0762 word patch offset $1A71; whole 16-bit word += relocation delta
    defb 085h, 01ah      ; runtime $47D4, stored $6594: #0763 word patch offset $1A85; whole 16-bit word += relocation delta
    defb 0a2h, 01ah      ; runtime $47D6, stored $6596: #0764 word patch offset $1AA2; whole 16-bit word += relocation delta
    defb 0a6h, 01ah      ; runtime $47D8, stored $6598: #0765 word patch offset $1AA6; whole 16-bit word += relocation delta
    defb 0bah, 01ah      ; runtime $47DA, stored $659A: #0766 word patch offset $1ABA; whole 16-bit word += relocation delta
    defb 0c5h, 01ah      ; runtime $47DC, stored $659C: #0767 word patch offset $1AC5; whole 16-bit word += relocation delta
    defb 0d3h, 01ah      ; runtime $47DE, stored $659E: #0768 word patch offset $1AD3; whole 16-bit word += relocation delta
    defb 0d6h, 01ah      ; runtime $47E0, stored $65A0: #0769 word patch offset $1AD6; whole 16-bit word += relocation delta
    defb 0d9h, 01ah      ; runtime $47E2, stored $65A2: #0770 word patch offset $1AD9; whole 16-bit word += relocation delta
    defb 0dch, 01ah      ; runtime $47E4, stored $65A4: #0771 word patch offset $1ADC; whole 16-bit word += relocation delta
    defb 0dfh, 01ah      ; runtime $47E6, stored $65A6: #0772 word patch offset $1ADF; whole 16-bit word += relocation delta
    defb 0e2h, 01ah      ; runtime $47E8, stored $65A8: #0773 word patch offset $1AE2; whole 16-bit word += relocation delta
    defb 0e5h, 01ah      ; runtime $47EA, stored $65AA: #0774 word patch offset $1AE5; whole 16-bit word += relocation delta
    defb 000h, 01bh      ; runtime $47EC, stored $65AC: #0775 word patch offset $1B00; whole 16-bit word += relocation delta
    defb 003h, 01bh      ; runtime $47EE, stored $65AE: #0776 word patch offset $1B03; whole 16-bit word += relocation delta
    defb 006h, 01bh      ; runtime $47F0, stored $65B0: #0777 word patch offset $1B06; whole 16-bit word += relocation delta
    defb 00bh, 01bh      ; runtime $47F2, stored $65B2: #0778 word patch offset $1B0B; whole 16-bit word += relocation delta
    defb 010h, 01bh      ; runtime $47F4, stored $65B4: #0779 word patch offset $1B10; whole 16-bit word += relocation delta
    defb 013h, 01bh      ; runtime $47F6, stored $65B6: #0780 word patch offset $1B13; whole 16-bit word += relocation delta
    defb 01dh, 01bh      ; runtime $47F8, stored $65B8: #0781 word patch offset $1B1D; whole 16-bit word += relocation delta
    defb 020h, 01bh      ; runtime $47FA, stored $65BA: #0782 word patch offset $1B20; whole 16-bit word += relocation delta
    defb 023h, 01bh      ; runtime $47FC, stored $65BC: #0783 word patch offset $1B23; whole 16-bit word += relocation delta
    defb 026h, 01bh      ; runtime $47FE, stored $65BE: #0784 word patch offset $1B26; whole 16-bit word += relocation delta
    defb 029h, 01bh      ; runtime $4800, stored $65C0: #0785 word patch offset $1B29; whole 16-bit word += relocation delta
    defb 02ch, 01bh      ; runtime $4802, stored $65C2: #0786 word patch offset $1B2C; whole 16-bit word += relocation delta
    defb 02fh, 01bh      ; runtime $4804, stored $65C4: #0787 word patch offset $1B2F; whole 16-bit word += relocation delta
    defb 035h, 01bh      ; runtime $4806, stored $65C6: #0788 word patch offset $1B35; whole 16-bit word += relocation delta
    defb 03dh, 01bh      ; runtime $4808, stored $65C8: #0789 word patch offset $1B3D; whole 16-bit word += relocation delta
    defb 04dh, 01bh      ; runtime $480A, stored $65CA: #0790 word patch offset $1B4D; whole 16-bit word += relocation delta
    defb 056h, 01bh      ; runtime $480C, stored $65CC: #0791 word patch offset $1B56; whole 16-bit word += relocation delta
    defb 05ch, 01bh      ; runtime $480E, stored $65CE: #0792 word patch offset $1B5C; whole 16-bit word += relocation delta
    defb 06dh, 01bh      ; runtime $4810, stored $65D0: #0793 word patch offset $1B6D; whole 16-bit word += relocation delta
    defb 075h, 01bh      ; runtime $4812, stored $65D2: #0794 word patch offset $1B75; whole 16-bit word += relocation delta
    defb 087h, 01bh      ; runtime $4814, stored $65D4: #0795 word patch offset $1B87; whole 16-bit word += relocation delta
    defb 08dh, 01bh      ; runtime $4816, stored $65D6: #0796 word patch offset $1B8D; whole 16-bit word += relocation delta
    defb 09ah, 01bh      ; runtime $4818, stored $65D8: #0797 word patch offset $1B9A; whole 16-bit word += relocation delta
    defb 09eh, 01bh      ; runtime $481A, stored $65DA: #0798 word patch offset $1B9E; whole 16-bit word += relocation delta
    defb 0a1h, 01bh      ; runtime $481C, stored $65DC: #0799 word patch offset $1BA1; whole 16-bit word += relocation delta
    defb 0a4h, 01bh      ; runtime $481E, stored $65DE: #0800 word patch offset $1BA4; whole 16-bit word += relocation delta
    defb 0a7h, 01bh      ; runtime $4820, stored $65E0: #0801 word patch offset $1BA7; whole 16-bit word += relocation delta
    defb 0aah, 01bh      ; runtime $4822, stored $65E2: #0802 word patch offset $1BAA; whole 16-bit word += relocation delta
    defb 0adh, 01bh      ; runtime $4824, stored $65E4: #0803 word patch offset $1BAD; whole 16-bit word += relocation delta
    defb 0b0h, 01bh      ; runtime $4826, stored $65E6: #0804 word patch offset $1BB0; whole 16-bit word += relocation delta
    defb 0b3h, 01bh      ; runtime $4828, stored $65E8: #0805 word patch offset $1BB3; whole 16-bit word += relocation delta
    defb 0a9h, 01ch      ; runtime $482A, stored $65EA: #0806 word patch offset $1CA9; whole 16-bit word += relocation delta
    defb 0afh, 01ch      ; runtime $482C, stored $65EC: #0807 word patch offset $1CAF; whole 16-bit word += relocation delta
    defb 0b1h, 01ch      ; runtime $482E, stored $65EE: #0808 word patch offset $1CB1; whole 16-bit word += relocation delta
    defb 0b3h, 01ch      ; runtime $4830, stored $65F0: #0809 word patch offset $1CB3; whole 16-bit word += relocation delta
    defb 0b5h, 01ch      ; runtime $4832, stored $65F2: #0810 word patch offset $1CB5; whole 16-bit word += relocation delta

; Table summary: 810 records = 800 whole-word, 5 split-low, 5 split-high.
