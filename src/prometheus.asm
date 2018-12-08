; z80dasm 1.1.3
; command line: z80dasm -a -t -l -g 24000 -b blocks.txt prometheus.bin

    org 05dc0h


ATTRIBUTES_ADDRESS:      equ 0x5800

; ROM routines

ROM_KeyboardScanning:    equ 0x028e
ROM_KeyboardTest:    equ 0x031e
ROM_BreakKey:    equ 0x1f54
ROM_LoadBytes_562:       equ 0x0562
ROM_SaveControl_4c6:     equ 0x04c6
ROM_SA_SET:      equ 0x051a
ROM_LD_MARKER:       equ 0x05c8
ROM_ChannelOpen:     equ 0x1601
ROM_PixelAddress_22b0:       equ 0x22b0
ROM_NEWCommandRoutine:       equ 0x11b7

; system variables

SYSVAR_ERR_SP:       equ 05c3dh                                ; Address of item on machine stack to use as error return

; constants

INSTRUCTIONS_TABLE_SIZE:     equ 687  
LEFT_BOTTOM_ATTRIBUTE_ADDRESS:       equ 0x5ae0
HIGHLIGHT_COLOR:     equ 0x30  ; yellow paper, black color
BOTTOM_LINE_VRAM_ADDRESS:    equ 0x50e0

start:
    di                         ;5dc0 f3  .                         (flow from: 34bb 52ad)  5dc0 jp 7cc9 
    ld hl,04000h               ;5dc1 21 00 40  ! . @               (flow from: 5dc0)  5dc1 ld hl,4000 
    ld de,04001h               ;5dc4 11 01 40  . . @               (flow from: 5dc1)  5dc4 ld de,4001 
    ld bc,00fffh               ;5dc7 01 ff 0f  . . .               (flow from: 5dc4)  5dc7 ld bc,0fff 
    ld (hl),l                  ;5dca 75  u                         (flow from: 5dc7)  5dca ld (hl),l 
    ldir                       ;5dcb ed b0  . .                    (flow from: 5dca 5dcb)  5dcb ldir 
    call 00052h                ;5dcd cd 52 00  . R .               (flow from: 5dcb)  5dcd call 0052 
    dec sp                     ;5dd0 3b                        ;   (flow from: 0052)  5dd0 dec sp 
    dec sp                     ;5dd1 3b                        ;   (flow from: 5dd0)  5dd1 dec sp 
    pop bc                     ;5dd2 c1  .                         (flow from: 5dd1)  5dd2 pop bc 
    ld hl,0fff0h               ;5dd3 21 f0 ff  ! . .               (flow from: 5dd2)  5dd3 ld hl,fff0 
    add hl,bc                  ;5dd6 09  .                         (flow from: 5dd3)  5dd6 add hl,bc 
    ld sp,04020h               ;5dd7 31 20 40  1   @               (flow from: 5dd6)  5dd7 ld sp,4020 
    push hl                    ;5dda e5  .                         (flow from: 5dd7)  5dda push hl 
    ld hl,00017h               ;5ddb 21 17 00  ! . .               (flow from: 5dda)  5ddb ld hl,0017 
    add hl,bc                  ;5dde 09  .                         (flow from: 5ddb)  5dde add hl,bc 
    ld bc,007cdh               ;5ddf 01 cd 07  . . .               (flow from: 5dde)  5ddf ld bc,07cd 
    ldir                       ;5de2 ed b0  . .                    (flow from: 5ddf 5de2)  5de2 ldir 
    jp 05000h                  ;5de4 c3 00 50  . . P               (flow from: 5de2)  5de4 jp 5000 

    org 0x5000

    ld de,04026h               ;5de7 11 26 40  . & @               (ghost flow from: 5de4)   5000 ld de,4026 
    call vr_sub_05342h         ;5dea cd 42 53  . B S               (ghost flow from: 5000)   5003 call 5342 
    ld e,046h                  ;5ded 1e 46  . F                    (ghost flow from: 5352)   5006 ld e,46 
    call vr_sub_05342h         ;5def cd 42 53  . B S               (ghost flow from: 5006)   5008 call 5342 
    ex (sp),hl                 ;5df2 e3  .                         (ghost flow from: 5352)   500b ex (sp),hl 
    ld bc,vr_l050a1h           ;5df3 01 a1 50  . . P               (ghost flow from: 500b)   500c ld bc,50a1 
    ld de,02710h               ;5df6 11 10 27  . . '               (ghost flow from: 500c)   500f ld de,2710 
    call vr_sub_052b4h         ;5df9 cd b4 52  . . R               (ghost flow from: 500f)   5012 call 52b4 
    ld de,003e8h               ;5dfc 11 e8 03  . . .               (ghost flow from: 52bf)   5015 ld de,03e8 
    call vr_sub_052b4h         ;5dff cd b4 52  . . R               (ghost flow from: 5015)   5018 call 52b4 
    ld de,00064h               ;5e02 11 64 00  . d .               (ghost flow from: 52bf)   501b ld de,0064 
    call vr_sub_052b4h         ;5e05 cd b4 52  . . R               (ghost flow from: 501b)   501e call 52b4 
    ld e,00ah                  ;5e08 1e 0a  . .                    (ghost flow from: 52bf)   5021 ld e,0a 
    call vr_sub_052b4h         ;5e0a cd b4 52  . . R               (ghost flow from: 5021)   5023 call 52b4 
    ld e,001h                  ;5e0d 1e 01  . .                    (ghost flow from: 52bf)   5026 ld e,01 
    call vr_sub_052b4h         ;5e0f cd b4 52  . . R               (ghost flow from: 5026)   5028 call 52b4 
vr_l0502bh:
    ld hl,04082h               ;5e12 21 82 40  ! . @               (ghost flow from: 52bf)   502b ld hl,4082 
    call vr_sub_052e6h         ;5e15 cd e6 52  . . R               (ghost flow from: 502b)   502e call 52e6 

; BLOCK 'intro1_string' (start 0x5e18 end 0x5e34)
    defb "Spectrum Z80 Turbo Assemble",0xf2                    ;"r"+0x80                       ;0x5e18
    ld hl,040c7h               ;5e34 21 c7 40  ! . @               (ghost flow from: 531b)   504d ld hl,40c7 
    call vr_sub_052e6h         ;5e37 cd e6 52  . . R               (ghost flow from: 504d)   5050 call 52e6 

; BLOCK 'intro2_string' (start 0x5e3a end 0x5e4c)
    defb "(C) 1990 UNIVERSU",0xcd                              ;"M"+0x80                       ;5e3a
    ld hl,048e2h               ;5e4c 21 e2 48  ! . H               (ghost flow from: 531b)   5065 ld hl,48e2 
    call vr_sub_052e6h         ;5e4f cd e6 52  . . R               (ghost flow from: 5065)   5068 call 52e6 

; BLOCK 'intro3_string' (start 0x5e52 end 0x5e6e)
    defb "Press ENTER to run Assemble",0xf2                    ;"r"+0x80                       ;5e52
    ld hl,04883h               ;5e6e 21 83 48  ! . H               (ghost flow from: 531b)   5087 ld hl,4883 
    call vr_sub_052e6h         ;5e71 cd e6 52  . . R               (ghost flow from: 5087)   508a call 52e6 

; BLOCK 'intro4_string' (start 0x5e74 end 0x5e8f)
    defb "Instalation address:"
vr_l050a1h:
    defb "00000_",0xa0         ;" "+0x80                       ;5e88
    ld hl,0484bh               ;5e8f 21 4b 48  ! K H               (ghost flow from: 531b)   50a8 ld hl,484b 
    call vr_sub_052e6h         ;5e92 cd e6 52  . . R               (ghost flow from: 50a8)   50ab call 52e6 

; BLOCK 'intro5_string' (start 0x5e95 end 0x5e9d)
    defb "Monitor",0xba        ;":"+0x80                       ;5e95
    ld a,04dh                  ;5e9d 3e 4d  > M                    (ghost flow from: 531b)   50b6 ld a,4d 
    or a                       ;5e9f b7  .                         (ghost flow from: 50b6)   50b8 or a 
    ld hl,04853h               ;5ea0 21 53 48  ! S H               (ghost flow from: 50b8)   50b9 ld hl,4853 
    jr z,l5eadh                ;5ea3 28 08  ( .                    (ghost flow from: 50b9)   50bc jr z,50c6 
    call vr_sub_052e6h         ;5ea5 cd e6 52  . . R               (ghost flow from: 50bc)   50be call 52e6 

; BLOCK 'intro_yes_string' (start 0x5ea8 end 0x5eab)
    defb "Ye",0xf3             ;"s"+0x80                       ;5ea8
    jr intro_no_string_end     ;5eab 18 06  . .                    (ghost flow from: 531b)   50c4 jr 50cc 
l5eadh:
    call vr_sub_052e6h         ;5ead cd e6 52  . . R 

; BLOCK 'intro_no_string' (start 0x5eb0 end 0x5eb3)
    defb "No",0xa0             ;" "+0x80                       ;5eb0
intro_no_string_end:
    ld hl,ATTRIBUTES_ADDRESS   ;5eb3 21 00 58  ! . X               (ghost flow from: 50c4)   50cc ld hl,5800 
    ld de,ATTRIBUTES_ADDRESS+1                                 ;5eb6 11 01 58  . . X                                                   (ghost flow from: 50cc)   50cf ld de,5801 
    ld bc,00020h               ;5eb9 01 20 00  .   .               (ghost flow from: 50cf)   50d2 ld bc,0020 
    ld (hl),l                  ;5ebc 75  u                         (ghost flow from: 50d2)   50d5 ld (hl),l 
    ldir                       ;5ebd ed b0  . .                    (ghost flow from: 50d5 50d6)   50d6 ldir 
    ld c,020h                  ;5ebf 0e 20  .                      (ghost flow from: 50d6)   50d8 ld c,20 
    ld (hl),006h               ;5ec1 36 06  6 .                    (ghost flow from: 50d8)   50da ld (hl),06 
    ldir                       ;5ec3 ed b0  . .                    (ghost flow from: 50da 50dc)   50dc ldir 
    ld c,020h                  ;5ec5 0e 20  .                      (ghost flow from: 50dc)   50de ld c,20 
    ld (hl),046h               ;5ec7 36 46  6 F                    (ghost flow from: 50de)   50e0 ld (hl),46 
    ldir                       ;5ec9 ed b0  . .                    (ghost flow from: 50e0 50e2)   50e2 ldir 
    ld c,0a0h                  ;5ecb 0e a0  . .                    (ghost flow from: 50e2)   50e4 ld c,a0 
    ld (hl),007h               ;5ecd 36 07  6 .                    (ghost flow from: 50e4)   50e6 ld (hl),07 
    ldir                       ;5ecf ed b0  . .                    (ghost flow from: 50e6 50e8)   50e8 ldir 
    ld bc,000e0h               ;5ed1 01 e0 00  . . .               (ghost flow from: 50e8)   50ea ld bc,00e0 
vr_l050edh:
    ld (hl),038h               ;5ed4 36 38  6 8                    (ghost flow from: 50ea)   50ed ld (hl),38 
    ld a,(hl)                  ;5ed6 7e  ~                         (ghost flow from: 50ed)   50ef ld a,(hl) 
    ldir                       ;5ed7 ed b0  . .                    (ghost flow from: 50ef 50f0)   50f0 ldir 
    ld (hl),030h               ;5ed9 36 30  6 0                    (ghost flow from: 50f0)   50f2 ld (hl),30 
    ld bc,00020h               ;5edb 01 20 00  .   .               (ghost flow from: 50f2)   50f4 ld bc,0020 
    ldir                       ;5ede ed b0  . .                    (ghost flow from: 50f4 50f7)   50f7 ldir 
    call vr_sub_052dch         ;5ee0 cd dc 52  . . R               (ghost flow from: 50f7)   50f9 call 52dc 
    ld b,001h                  ;5ee3 06 01  . .                    (ghost flow from: 52e5)   50fc ld b,01 
    ld (hl),a                  ;5ee5 77  w                         (ghost flow from: 50fc)   50fe ld (hl),a 
    ldir                       ;5ee6 ed b0  . .                    (ghost flow from: 50fe 50ff)   50ff ldir 
    ld e,00ah                  ;5ee8 1e 0a  . .                    (ghost flow from: 50ff)   5101 ld e,0a 
    ld hl,0012ch               ;5eea 21 2c 01  ! , .               (ghost flow from: 5101)   5103 ld hl,012c 
    ld a,(vr_l050edh+1)        ;5eed 3a ee 50  : . P               (ghost flow from: 5103)   5106 ld a,(50ee) 
    rrca                       ;5ef0 0f  .                         (ghost flow from: 5106)   5109 rrca 
    rrca                       ;5ef1 0f  .                         (ghost flow from: 5109)   510a rrca 
    rrca                       ;5ef2 0f  .                         (ghost flow from: 510a)   510b rrca 
l5ef3h:
    ld b,e                     ;5ef3 43  C                         (ghost flow from: 510b 5116)   510c ld b,e 
    xor 010h                   ;5ef4 ee 10  . .                    (ghost flow from: 510c)   510d xor 10 
l5ef6h:
    out (0feh),a               ;5ef6 d3 fe  . .                    (ghost flow from: 510d 5111)   510f out (fe),a 
    djnz l5ef6h                ;5ef8 10 fc  . .                    (ghost flow from: 510f)   5111 djnz 510f 
    dec hl                     ;5efa 2b  +                         (ghost flow from: 5111)   5113 dec hl 
    inc h                      ;5efb 24  $                         (ghost flow from: 5113)   5114 inc h 
    dec h                      ;5efc 25  %                         (ghost flow from: 5114)   5115 dec h 
    jr nz,l5ef3h               ;5efd 20 f4    .                    (ghost flow from: 5115)   5116 jr nz,510c 
    ld h,080h                  ;5eff 26 80  & .                    (ghost flow from: 5116)   5118 ld h,80 
l5f01h:
    inc hl                     ;5f01 23  #                         (ghost flow from: 5118 511d)   511a inc hl 
    inc h                      ;5f02 24  $                         (ghost flow from: 511a)   511b inc h 
    dec h                      ;5f03 25  %                         (ghost flow from: 511b)   511c dec h 
    jr nz,l5f01h               ;5f04 20 fb    .                    (ghost flow from: 511c)   511d jr nz,511a 
l5f06h:
    call ROM_KeyboardScanning  ;5f06                               (ghost flow from: 511d 5127)   511f call 028e 
    jr nz,l5f06h               ;5f09 20 fb    .                    (ghost flow from: 02b2)   5122 jr nz,511f 
    call ROM_KeyboardTest      ;5f0b cd 1e 03                      (ghost flow from: 5122)   5124 call 031e 
    jr nc,l5f06h               ;5f0e 30 f6  0 .                    (ghost flow from: 0324 0332)   5127 jr nc,511f 
    ld e,a                     ;5f10 5f  _                         (ghost flow from: 5127)   5129 ld e,a 
    inc b                      ;5f11 04  .                         (ghost flow from: 5129)   512a inc b 
    jr z,l5f16h                ;5f12 28 02  ( .                    (ghost flow from: 512a)   512b jr z,512f 
    add a,080h                 ;5f14 c6 80  . . 
l5f16h:
    ld hl,vr_l0502bh           ;5f16 21 2b 50  ! + P               (ghost flow from: 512b)   512f ld hl,502b 
    push hl                    ;5f19 e5  .                         (ghost flow from: 512f)   5132 push hl 
    cp 049h                    ;5f1a fe 49  . I                    (ghost flow from: 5132)   5133 cp 49 
    ld hl,vr_l050edh+1         ;5f1c 21 ee 50  ! . P               (ghost flow from: 5133)   5135 ld hl,50ee 
l5f1fh:
    ld de,00107h               ;5f1f 11 07 01  . . .               (ghost flow from: 5135)   5138 ld de,0107 
    jr nz,l5f2eh               ;5f22 20 0a    .                    (ghost flow from: 5138)   513b jr nz,5147 
l5f24h:
    ld a,e                     ;5f24 7b  { 
    cpl                        ;5f25 2f  / 
    and (hl)                   ;5f26 a6  . 
    ld c,a                     ;5f27 4f  O 
    ld a,(hl)                  ;5f28 7e  ~ 
    add a,d                    ;5f29 82  . 
    and e                      ;5f2a a3  . 
    or c                       ;5f2b b1  . 
    ld (hl),a                  ;5f2c 77  w 
    ret                        ;5f2d c9  . 
l5f2eh:
    cp 050h                    ;5f2e fe 50  . P                    (ghost flow from: 513b)   5147 cp 50 
l5f30h:
    ld de,00838h               ;5f30 11 38 08  . 8 .               (ghost flow from: 5147)   5149 ld de,0838 
    jr z,l5f24h                ;5f33 28 ef  ( .                    (ghost flow from: 5149)   514c jr z,513d 
    cp 042h                    ;5f35 fe 42  . B                    (ghost flow from: 514c)   514e cp 42 
l5f37h:
    ld de,04040h               ;5f37 11 40 40  . @ @               (ghost flow from: 514e)   5150 ld de,4040 
    jr z,l5f24h                ;5f3a 28 e8  ( .                    (ghost flow from: 5150)   5153 jr z,513d 
    ld hl,050f3h               ;5f3c 21 f3 50  ! . P               (ghost flow from: 5153)   5155 ld hl,50f3 
    cp 0c9h                    ;5f3f fe c9  . .                    (ghost flow from: 5155)   5158 cp c9 
    jr z,l5f1fh                ;5f41 28 dc  ( .                    (ghost flow from: 5158)   515a jr z,5138 
    cp 0d0h                    ;5f43 fe d0  . .                    (ghost flow from: 515a)   515c cp d0 
    jr z,l5f30h                ;5f45 28 e9  ( .                    (ghost flow from: 515c)   515e jr z,5149 
    cp 0c2h                    ;5f47 fe c2  . .                    (ghost flow from: 515e)   5160 cp c2 
    jr z,l5f37h                ;5f49 28 ec  ( .                    (ghost flow from: 5160)   5162 jr z,5150 
    cp 044h                    ;5f4b fe 44  . D                    (ghost flow from: 5162)   5164 cp 44 
    jr nz,l5f57h               ;5f4d 20 08    .                    (ghost flow from: 5164)   5166 jr nz,5170 
    ld hl,vr_l05309h           ;5f4f 21 09 53  ! . S 
    ld a,00fh                  ;5f52 3e 0f  > . 
l5f54h:
    xor (hl)                   ;5f54 ae  . 
    ld (hl),a                  ;5f55 77  w 
    ret                        ;5f56 c9  . 
l5f57h:
    cp 04dh                    ;5f57 fe 4d  . M                    (ghost flow from: 5166)   5170 cp 4d 
    ld hl,050b7h               ;5f59 21 b7 50  ! . P               (ghost flow from: 5170)   5172 ld hl,50b7 
    jr z,l5f54h                ;5f5c 28 f6  ( .                    (ghost flow from: 5172)   5175 jr z,516d 
    cp 058h                    ;5f5e fe 58  . X                    (ghost flow from: 5175)   5177 cp 58 
    ld hl,05102h               ;5f60 21 02 51  ! . Q               (ghost flow from: 5177)   5179 ld hl,5102 
    ld de,0013fh               ;5f63 11 3f 01  . ? .               (ghost flow from: 5179)   517c ld de,013f 
    jr z,l5f24h                ;5f66 28 bc  ( .                    (ghost flow from: 517c)   517f jr z,513d 
    ld d,0ffh                  ;5f68 16 ff  . .                    (ghost flow from: 517f)   5181 ld d,ff 
    cp 0d8h                    ;5f6a fe d8  . .                    (ghost flow from: 5181)   5183 cp d8 
    jr z,l5f24h                ;5f6c 28 b6  ( .                    (ghost flow from: 5183)   5185 jr z,513d 
    cp 043h                    ;5f6e fe 43  . C                    (ghost flow from: 5185)   5187 cp 43 
    jr nz,l5f93h               ;5f70 20 21    !                    (ghost flow from: 5187)   5189 jr nz,51ac 
vr_l0518bh:
    ld a,000h                  ;5f72 3e 00  > . 
    inc a                      ;5f74 3c  < 
    cp 003h                    ;5f75 fe 03  . . 
    jr nz,l5f7ah               ;5f77 20 01    . 
    xor a                      ;5f79 af  . 
l5f7ah:
    ld (vr_l0518bh+1),a        ;5f7a 32 8c 51  2 . Q 
    add a,a                    ;5f7d 87  . 
    ld hl,051a6h               ;5f7e 21 a6 51  ! . Q 
    ld b,000h                  ;5f81 06 00  . . 
    ld c,a                     ;5f83 4f  O 
    add hl,bc                  ;5f84 09  . 
    ld e,(hl)                  ;5f85 5e  ^ 
    inc hl                     ;5f86 23  # 
    ld d,(hl)                  ;5f87 56  V 
    ex de,hl                   ;5f88 eb  . 
    ld (052fah),hl             ;5f89 22 fa 52  " . R 
    ret                        ;5f8c c9  . 
    and 0ffh                   ;5f8d e6 ff  . . 
    or 020h                    ;5f8f f6 20  .   
    and 0dfh                   ;5f91 e6 df  . . 
l5f93h:
    ld hl,050a6h               ;5f93 21 a6 50  ! . P               (ghost flow from: 5189)   51ac ld hl,50a6 
    cp 0b0h                    ;5f96 fe b0  . .                    (ghost flow from: 51ac)   51af cp b0 
    jr nz,l5fa9h               ;5f98 20 0f    .                    (ghost flow from: 51af)   51b1 jr nz,51c2 
    dec hl                     ;5f9a 2b  + 
    ld a,(hl)                  ;5f9b 7e  ~ 
    cp 03ah                    ;5f9c fe 3a  . : 
    ret z                      ;5f9e c8  . 
    inc hl                     ;5f9f 23  # 
    ld (hl),020h               ;5fa0 36 20  6   
    dec hl                     ;5fa2 2b  + 
l5fa3h:
    ld (hl),05fh               ;5fa3 36 5f  6 _ 
    ld (051adh),hl             ;5fa5 22 ad 51  " . Q 
    ret                        ;5fa8 c9  . 
l5fa9h:
    cp 030h                    ;5fa9 fe 30  . 0                    (ghost flow from: 51b1)   51c2 cp 30 
    jr c,l5fbah                ;5fab 38 0d  8 .                    (ghost flow from: 51c2)   51c4 jr c,51d3 
    cp 03ah                    ;5fad fe 3a  . : 
    jr nc,l5fbah               ;5faf 30 09  0 . 
    inc hl                     ;5fb1 23  # 
    bit 7,(hl)                 ;5fb2 cb 7e  . ~ 
    ret nz                     ;5fb4 c0  . 
    dec hl                     ;5fb5 2b  + 
    ld (hl),a                  ;5fb6 77  w 
    inc hl                     ;5fb7 23  # 
    jr l5fa3h                  ;5fb8 18 e9  . . 
l5fbah:
    cp 00dh                    ;5fba fe 0d  . .                    (ghost flow from: 51c4)   51d3 cp 0d 
    ret nz                     ;5fbc c0  .                         (ghost flow from: 51d3)   51d5 ret nz 
    pop af                     ;5fbd f1  .                         (ghost flow from: 51d5)   51d6 pop af 
    pop hl                     ;5fbe e1  .                         (ghost flow from: 51d6)   51d7 pop hl 
    push hl                    ;5fbf e5  .                         (ghost flow from: 51d7)   51d8 push hl 
    ld (05227h),sp             ;5fc0 ed 73 27 52  . s ' R          (ghost flow from: 51d8)   51d9 ld (5227),sp 
    ld sp,052c0h               ;5fc4 31 c0 52  1 . R               (ghost flow from: 51d9)   51dd ld sp,52c0 
    call vr_sub_052afh         ;5fc7 cd af 52  . . R               (ghost flow from: 51dd)   51e0 call 52af 
    ld a,(vr_l05309h)          ;5fca 3a 09 53  : . S               (ghost flow from: 52b3)   51e3 ld a,(5309) 
    call vr_sub_052aeh         ;5fcd cd ae 52  . . R               (ghost flow from: 51e3)   51e6 call 52ae 
    ld de,(052fah)             ;5fd0 ed 5b fa 52  . [ . R          (ghost flow from: 52b3)   51e9 ld de,(52fa) 
    ld (hl),e                  ;5fd4 73  s                         (ghost flow from: 51e9)   51ed ld (hl),e 
    inc hl                     ;5fd5 23  #                         (ghost flow from: 51ed)   51ee inc hl 
    ld (hl),d                  ;5fd6 72  r                         (ghost flow from: 51ee)   51ef ld (hl),d 
    dec hl                     ;5fd7 2b  +                         (ghost flow from: 51ef)   51f0 dec hl 
    call vr_sub_052afh         ;5fd8 cd af 52  . . R               (ghost flow from: 51f0)   51f1 call 52af 
    ld a,(05102h)              ;5fdb 3a 02 51  : . Q               (ghost flow from: 52b3)   51f4 ld a,(5102) 
    call vr_sub_052aeh         ;5fde cd ae 52  . . R               (ghost flow from: 51f4)   51f7 call 52ae 
    ld a,(vr_l050edh+1)        ;5fe1 3a ee 50  : . P               (ghost flow from: 52b3)   51fa ld a,(50ee) 
    call vr_sub_052aeh         ;5fe4 cd ae 52  . . R               (ghost flow from: 51fa)   51fd call 52ae 
    call vr_sub_052aeh         ;5fe7 cd ae 52  . . R               (ghost flow from: 52b3)   5200 call 52ae 
    call vr_sub_052aeh         ;5fea cd ae 52  . . R               (ghost flow from: 52b3)   5203 call 52ae 
    xor 001h                   ;5fed ee 01  . .                    (ghost flow from: 52b3)   5206 xor 01 
    call vr_sub_052aeh         ;5fef cd ae 52  . . R               (ghost flow from: 5206)   5208 call 52ae 
    call vr_sub_052aeh         ;5ff2 cd ae 52  . . R               (ghost flow from: 52b3)   520b call 52ae 
    call vr_sub_052dch         ;5ff5 cd dc 52  . . R               (ghost flow from: 52b3)   520e call 52dc 
    call vr_sub_052aeh         ;5ff8 cd ae 52  . . R               (ghost flow from: 52e5)   5211 call 52ae 
    and 007h                   ;5ffb e6 07  . .                    (ghost flow from: 52b3)   5214 and 07 
    call vr_sub_052aeh         ;5ffd cd ae 52  . . R               (ghost flow from: 5214)   5216 call 52ae 
    call vr_sub_052aeh         ;6000 cd ae 52  . . R               (ghost flow from: 52b3)   5219 call 52ae 
    ld a,(050f3h)              ;6003 3a f3 50  : . P               (ghost flow from: 52b3)   521c ld a,(50f3) 
    call vr_sub_052aeh         ;6006 cd ae 52  . . R               (ghost flow from: 521c)   521f call 52ae 
    call vr_sub_052aeh         ;6009 cd ae 52  . . R               (ghost flow from: 52b3)   5222 call 52ae 
    ld (hl),a                  ;600c 77  w                         (ghost flow from: 52b3)   5225 ld (hl),a 
    ld sp,00000h               ;600d 31 00 00  1 . .               (ghost flow from: 5225)   5226 ld sp,401e 
    ld hl,00000h               ;6010 21 00 00  ! . .               (ghost flow from: 5226)   5229 ld hl,0000 
    ld de,vr_l050a1h           ;6013 11 a1 50  . . P               (ghost flow from: 5229)   522c ld de,50a1 
l6016h:
    ld a,(de)                  ;6016 1a  .                         (ghost flow from: 522c 5241)   522f ld a,(de) 
    inc de                     ;6017 13  .                         (ghost flow from: 522f)   5230 inc de 
    cp 05fh                    ;6018 fe 5f  . _                    (ghost flow from: 5230)   5231 cp 5f 
    jr z,l602ah                ;601a 28 0e  ( .                    (ghost flow from: 5231)   5233 jr z,5243 
    add hl,hl                  ;601c 29  )                         (ghost flow from: 5233)   5235 add hl,hl 
    push hl                    ;601d e5  .                         (ghost flow from: 5235)   5236 push hl 
    add hl,hl                  ;601e 29  )                         (ghost flow from: 5236)   5237 add hl,hl 
    add hl,hl                  ;601f 29  )                         (ghost flow from: 5237)   5238 add hl,hl 
    pop bc                     ;6020 c1  .                         (ghost flow from: 5238)   5239 pop bc 
    add hl,bc                  ;6021 09  .                         (ghost flow from: 5239)   523a add hl,bc 
    sub 030h                   ;6022 d6 30  . 0                    (ghost flow from: 523a)   523b sub 30 
    ld c,a                     ;6024 4f  O                         (ghost flow from: 523b)   523d ld c,a 
    ld b,000h                  ;6025 06 00  . .                    (ghost flow from: 523d)   523e ld b,00 
    add hl,bc                  ;6027 09  .                         (ghost flow from: 523e)   5240 add hl,bc 
    jr l6016h                  ;6028 18 ec  . .                    (ghost flow from: 5240)   5241 jr 522f 
l602ah:
    pop de                     ;602a d1  .                         (ghost flow from: 5233)   5243 pop de 
    ex de,hl                   ;602b eb  .                         (ghost flow from: 5243)   5244 ex de,hl 
    ld a,(050b7h)              ;602c 3a b7 50  : . P               (ghost flow from: 5244)   5245 ld a,(50b7) 
    rrca                       ;602f 0f  .                         (ghost flow from: 5245)   5248 rrca 
    push af                    ;6030 f5  .                         (ghost flow from: 5248)   5249 push af 
    ld bc,03e80h               ;6031 01 80 3e  . . >               (ghost flow from: 5249)   524a ld bc,3e80 
    jr c,l604eh                ;6034 38 18  8 .                    (ghost flow from: 524a)   524d jr c,5267 
    push hl                    ;6036 e5  . 
    push de                    ;6037 d5  . 
    ld bc,vr_l07931h+1         ;6038 01 72 1b  . r . 
    add hl,bc                  ;603b 09  . 
    ld e,(hl)                  ;603c 5e  ^ 
    inc hl                     ;603d 23  # 
    ld d,(hl)                  ;603e 56  V 
    ex de,hl                   ;603f eb  . 
    ld bc,01388h               ;6040 01 88 13  . . . 
    add hl,bc                  ;6043 09  . 
    ex de,hl                   ;6044 eb  . 
    ld (hl),d                  ;6045 72  r 
    dec hl                     ;6046 2b  + 
    ld (hl),e                  ;6047 73  s 
    pop de                     ;6048 d1  . 
    pop hl                     ;6049 e1  . 
    add hl,bc                  ;604a 09  . 
    ld bc,02af8h               ;604b 01 f8 2a  . . * 
l604eh:
    push de                    ;604e d5  .                         (ghost flow from: 524d)   5267 push de 
    push hl                    ;604f e5  .                         (ghost flow from: 5267)   5268 push hl 
    xor a                      ;6050 af  .                         (ghost flow from: 5268)   5269 xor a 
    sbc hl,de                  ;6051 ed 52  . R                    (ghost flow from: 5269)   526a sbc hl,de 
    pop hl                     ;6053 e1  .                         (ghost flow from: 526a)   526c pop hl 
    jr c,l605ah                ;6054 38 04  8 .                    (ghost flow from: 526c)   526d jr c,5273 
    ldir                       ;6056 ed b0  . .                    (ghost flow from: 526d 526f)   526f ldir 
    jr l6062h                  ;6058 18 08  . .                    (ghost flow from: 526f)   5271 jr 527b 
l605ah:
    add hl,bc                  ;605a 09  . 
    dec hl                     ;605b 2b  + 
    ex de,hl                   ;605c eb  . 
    add hl,bc                  ;605d 09  . 
    dec hl                     ;605e 2b  + 
    ex de,hl                   ;605f eb  . 
    lddr                       ;6060 ed b8  . . 
l6062h:
    pop bc                     ;6062 c1  .                         (ghost flow from: 5271)   527b pop bc 
    ld d,b                     ;6063 50  P                         (ghost flow from: 527b)   527c ld d,b 
    ld e,c                     ;6064 59  Y                         (ghost flow from: 527c)   527d ld e,c 
    pop af                     ;6065 f1  .                         (ghost flow from: 527d)   527e pop af 
    push bc                    ;6066 c5  .                         (ghost flow from: 527e)   527f push bc 
    push af                    ;6067 f5  .                         (ghost flow from: 527f)   5280 push af 
    jr nc,l6077h               ;6068 30 0d  0 .                    (ghost flow from: 5280)   5281 jr nc,5290 
    ld hl,vr_l05353h           ;606a 21 53 53  ! S S               (ghost flow from: 5281)   5283 ld hl,5353 
    call vr_sub_0531ch         ;606d cd 1c 53  . . S               (ghost flow from: 5283)   5286 call 531c 
    ld hl,001c8h               ;6070 21 c8 01  ! . .               (ghost flow from: 531e)   5289 ld hl,01c8 
    add hl,de                  ;6073 19  .                         (ghost flow from: 5289)   528c add hl,de 
    ex de,hl                   ;6074 eb  .                         (ghost flow from: 528c)   528d ex de,hl 
    jr l607dh                  ;6075 18 06  . .                    (ghost flow from: 528d)   528e jr 5296 
l6077h:
    ld hl,0ec78h               ;6077 21 78 ec  ! x . 
    add hl,bc                  ;607a 09  . 
    ld b,h                     ;607b 44  D 
    ld c,l                     ;607c 4d  M 
l607dh:
    ld hl,vr_l05547h           ;607d 21 47 55  ! G U               (ghost flow from: 528e)   5296 ld hl,5547 
    call vr_sub_0531ch         ;6080 cd 1c 53  . . S               (ghost flow from: 5296)   5299 call 531c 
    ld hl,0f136h               ;6083 21 36 f1  ! 6 .               (ghost flow from: 531e)   529c ld hl,f136 
    add hl,de                  ;6086 19  .                         (ghost flow from: 529c)   529f add hl,de 
    pop af                     ;6087 f1  .                         (ghost flow from: 529f)   52a0 pop af 
    pop bc                     ;6088 c1  .                         (ghost flow from: 52a0)   52a1 pop bc 
    jr c,l608eh                ;6089 38 03  8 .                    (ghost flow from: 52a1)   52a2 jr c,52a7 
    ld (hl),c                  ;608b 71  q 
    inc hl                     ;608c 23  # 
    ld (hl),b                  ;608d 70  p 
l608eh:
    ld hl,00104h               ;608e 21 04 01  ! . .               (ghost flow from: 52a2)   52a7 ld hl,0104 
    add hl,de                  ;6091 19  .                         (ghost flow from: 52a7)   52aa add hl,de 
    ld sp,hl                   ;6092 f9  .                         (ghost flow from: 52aa)   52ab ld sp,hl 
    push bc                    ;6093 c5  .                         (ghost flow from: 52ab)   52ac push bc 
    ret                        ;6094 c9  .                         (ghost flow from: 52ac)   52ad ret 
vr_sub_052aeh:
    ld (hl),a                  ;6095 77  w                         (ghost flow from: 51e6 51f7 51fd 5200 5203 5208 520b 5211 5216 5219 521f 5222)   52ae ld (hl),a 
vr_sub_052afh:
    pop bc                     ;6096 c1  .                         (ghost flow from: 51e0 51f1 52ae)   52af pop bc 
    pop de                     ;6097 d1  .                         (ghost flow from: 52af)   52b0 pop de 
    add hl,de                  ;6098 19  .                         (ghost flow from: 52b0)   52b1 add hl,de 
    push bc                    ;6099 c5  .                         (ghost flow from: 52b1)   52b2 push bc 
l609ah:
    ret                        ;609a c9  .                         (ghost flow from: 52b2)   52b3 ret 
vr_sub_052b4h:
    ld a,02fh                  ;609b 3e 2f  > /                    (ghost flow from: 5012 5018 501e 5023 5028)   52b4 ld a,2f 
l609dh:
    inc a                      ;609d 3c  <                         (ghost flow from: 52b4 52ba)   52b6 inc a 
    and a                      ;609e a7  .                         (ghost flow from: 52b6)   52b7 and a 
    sbc hl,de                  ;609f ed 52  . R                    (ghost flow from: 52b7)   52b8 sbc hl,de 
    jr nc,l609dh               ;60a1 30 fa  0 .                    (ghost flow from: 52b8)   52ba jr nc,52b6 
    add hl,de                  ;60a3 19  .                         (ghost flow from: 52ba)   52bc add hl,de 
    ld (bc),a                  ;60a4 02  .                         (ghost flow from: 52bc)   52bd ld (bc),a 
    inc bc                     ;60a5 03  .                         (ghost flow from: 52bd)   52be inc bc 
    ret                        ;60a6 c9  .                         (ghost flow from: 52be)   52bf ret 
    adc a,029h                 ;60a7 ce 29  . ) 
    inc (hl)                   ;60a9 34  4 
    ei                         ;60aa fb  . 
    ld c,(hl)                  ;60ab 4e  N 
    inc b                      ;60ac 04  . 
    cp h                       ;60ad bc  . 
    push hl                    ;60ae e5  . 
    sbc a,b                    ;60af 98  . 
    rlca                       ;60b0 07  . 
    jr l60c6h                  ;60b1 18 13  . . 
    djnz l609ah                ;60b3 10 e5  . . 
    ld c,000h                  ;60b5 0e 00  . . 
    ld b,a                     ;60b7 47  G 
    ld de,00938h               ;60b8 11 38 09  . 8 . 
    ret pe                     ;60bb e8  . 
    ret p                      ;60bc f0  . 
    jp nc,09404h                                               ;60bd d2 04 94  . . .           ;data? 
    rst 30h                    ;60c0 f7  . 
    ld e,l                     ;60c1 5d  ] 
    ret m                      ;60c2 f8  . 
vr_sub_052dch:
    and 0f8h                   ;60c3 e6 f8  . .                    (ghost flow from: 50f9 520e)   52dc and f8 
    ld b,a                     ;60c5 47  G                         (ghost flow from: 52dc)   52de ld b,a 
l60c6h:
    rrca                       ;60c6 0f  .                         (ghost flow from: 52de)   52df rrca 
    rrca                       ;60c7 0f  .                         (ghost flow from: 52df)   52e0 rrca 
    rrca                       ;60c8 0f  .                         (ghost flow from: 52e0)   52e1 rrca 
    and 007h                   ;60c9 e6 07  . .                    (ghost flow from: 52e1)   52e2 and 07 
    or b                       ;60cb b0  .                         (ghost flow from: 52e2)   52e4 or b 
    ret                        ;60cc c9  .                         (ghost flow from: 52e4)   52e5 ret 
vr_sub_052e6h:
    ld (05303h),hl             ;60cd 22 03 53  " . S               (ghost flow from: 502e 5050 5068 508a 50ab 50be)   52e6 ld (5303),hl 
    pop hl                     ;60d0 e1  .                         (ghost flow from: 52e6)   52e9 pop hl 
l60d1h:
    ld a,(hl)                  ;60d1 7e  ~                         (ghost flow from: 52e9 5319)   52ea ld a,(hl) 
    and 07fh                   ;60d2 e6 7f  .                     (ghost flow from: 52ea)   52eb and 7f 
    exx                        ;60d4 d9  .                         (ghost flow from: 52eb)   52ed exx 
    cp 041h                    ;60d5 fe 41  . A                    (ghost flow from: 52ed)   52ee cp 41 
    jr c,l60e3h                ;60d7 38 0a  8 .                    (ghost flow from: 52ee)   52f0 jr c,52fc 
    cp 05bh                    ;60d9 fe 5b  . [                    (ghost flow from: 52f0)   52f2 cp 5b 
    jr c,l60e1h                ;60db 38 04  8 .                    (ghost flow from: 52f2)   52f4 jr c,52fa 
    cp 061h                    ;60dd fe 61  . a                    (ghost flow from: 52f4)   52f6 cp 61 
    jr c,l60e3h                ;60df 38 02  8 .                    (ghost flow from: 52f6)   52f8 jr c,52fc 
l60e1h:
    and 0ffh                   ;60e1 e6 ff  . .                    (ghost flow from: 52f4 52f8)   52fa and ff 
l60e3h:
    add a,a                    ;60e3 87  .                         (ghost flow from: 52f0 52f8 52fa)   52fc add a,a 
    ld h,00fh                  ;60e4 26 0f  & .                    (ghost flow from: 52fc)   52fd ld h,0f 
    ld l,a                     ;60e6 6f  o                         (ghost flow from: 52fd)   52ff ld l,a 
    add hl,hl                  ;60e7 29  )                         (ghost flow from: 52ff)   5300 add hl,hl 
    add hl,hl                  ;60e8 29  )                         (ghost flow from: 5300)   5301 add hl,hl 
    ld de,04000h               ;60e9 11 00 40  . . @               (ghost flow from: 5301)   5302 ld de,4855 
    push de                    ;60ec d5  .                         (ghost flow from: 5302)   5305 push de 
    ld b,008h                  ;60ed 06 08  . .                    (ghost flow from: 5305)   5306 ld b,08 
l60efh:
    ld a,(hl)                  ;60ef 7e  ~                         (ghost flow from: 5306 530e)   5308 ld a,(hl) 
vr_l05309h:
    nop                        ;60f0 00  .                         (ghost flow from: 5308)   5309 nop 
    or (hl)                    ;60f1 b6  .                         (ghost flow from: 5309)   530a or (hl) 
    ld (de),a                  ;60f2 12  .                         (ghost flow from: 530a)   530b ld (de),a 
    inc hl                     ;60f3 23  #                         (ghost flow from: 530b)   530c inc hl 
    inc d                      ;60f4 14  .                         (ghost flow from: 530c)   530d inc d 
    djnz l60efh                ;60f5 10 f8  . .                    (ghost flow from: 530d)   530e djnz 5308 
    pop hl                     ;60f7 e1  .                         (ghost flow from: 530e)   5310 pop hl 
    inc l                      ;60f8 2c  ,                         (ghost flow from: 5310)   5311 inc l 
    ld (05303h),hl             ;60f9 22 03 53  " . S               (ghost flow from: 5311)   5312 ld (5303),hl 
    exx                        ;60fc d9  .                         (ghost flow from: 5312)   5315 exx 
    ld a,(hl)                  ;60fd 7e  ~                         (ghost flow from: 5315)   5316 ld a,(hl) 
    inc hl                     ;60fe 23  #                         (ghost flow from: 5316)   5317 inc hl 
    rlca                       ;60ff 07  .                         (ghost flow from: 5317)   5318 rlca 
    jr nc,l60d1h               ;6100 30 cf  0 .                    (ghost flow from: 5318)   5319 jr nc,52ea 
    jp (hl)                    ;6102 e9  .                         (ghost flow from: 5319)   531b jp hl 
l6103h:
vr_sub_0531ch:
    ld a,(hl)                  ;6103 7e  ~                         (ghost flow from: 5286 5299 5340)   531c ld a,(hl) 
    or a                       ;6104 b7  .                         (ghost flow from: 531c)   531d or a 
    ret z                      ;6105 c8  .                         (ghost flow from: 531d)   531e ret z 
    ld (hl),001h               ;6106 36 01  6 .                    (ghost flow from: 531e)   531f ld (hl),01 
    cp 0c8h                    ;6108 fe c8  . .                    (ghost flow from: 531f)   5321 cp c8 
    jr c,l610fh                ;610a 38 03  8 .                    (ghost flow from: 5321)   5323 jr c,5328 
    sub 0c8h                   ;610c d6 c8  . .                    (ghost flow from: 5323)   5325 sub c8 
    inc hl                     ;610e 23  #                         (ghost flow from: 5325)   5327 inc hl 
l610fh:
    push af                    ;610f f5  .                         (ghost flow from: 5323 5327 533d)   5328 push af 
    add a,e                    ;6110 83  .                         (ghost flow from: 5328)   5329 add a,e 
    ld e,a                     ;6111 5f  _                         (ghost flow from: 5329)   532a ld e,a 
    jr nc,l6115h               ;6112 30 01  0 .                    (ghost flow from: 532a)   532b jr nc,532e 
    inc d                      ;6114 14  .                         (ghost flow from: 532b)   532d inc d 
l6115h:
    pop af                     ;6115 f1  .                         (ghost flow from: 532b 532d)   532e pop af 
    push hl                    ;6116 e5  .                         (ghost flow from: 532e)   532f push hl 
    ex de,hl                   ;6117 eb  .                         (ghost flow from: 532f)   5330 ex de,hl 
    ld e,(hl)                  ;6118 5e  ^                         (ghost flow from: 5330)   5331 ld e,(hl) 
    inc hl                     ;6119 23  #                         (ghost flow from: 5331)   5332 inc hl 
    ld d,(hl)                  ;611a 56  V                         (ghost flow from: 5332)   5333 ld d,(hl) 
    ex de,hl                   ;611b eb  .                         (ghost flow from: 5333)   5334 ex de,hl 
    add hl,bc                  ;611c 09  .                         (ghost flow from: 5334)   5335 add hl,bc 
    ex de,hl                   ;611d eb  .                         (ghost flow from: 5335)   5336 ex de,hl 
    ld (hl),d                  ;611e 72  r                         (ghost flow from: 5336)   5337 ld (hl),d 
    dec hl                     ;611f 2b  +                         (ghost flow from: 5337)   5338 dec hl 
    ld (hl),e                  ;6120 73  s                         (ghost flow from: 5338)   5339 ld (hl),e 
    ex de,hl                   ;6121 eb  .                         (ghost flow from: 5339)   533a ex de,hl 
    pop hl                     ;6122 e1  .                         (ghost flow from: 533a)   533b pop hl 
    dec (hl)                   ;6123 35  5                         (ghost flow from: 533b)   533c dec (hl) 
    jr nz,l610fh               ;6124 20 e9    .                    (ghost flow from: 533c)   533d jr nz,5328 
    inc hl                     ;6126 23  #                         (ghost flow from: 533d)   533f inc hl 
    jr l6103h                  ;6127 18 da  . .                    (ghost flow from: 533f)   5340 jr 531c 
vr_sub_05342h:
    ld c,014h                  ;6129 0e 14  . .                    (ghost flow from: 5003 5008)   5342 ld c,14 
l612bh:
    ld b,008h                  ;612b 06 08  . .                    (ghost flow from: 5342 5350)   5344 ld b,08 
    push de                    ;612d d5  .                         (ghost flow from: 5344)   5346 push de 
l612eh:
    ld a,(hl)                  ;612e 7e  ~                         (ghost flow from: 5346 534b)   5347 ld a,(hl) 
    ld (de),a                  ;612f 12  .                         (ghost flow from: 5347)   5348 ld (de),a 
    inc hl                     ;6130 23  #                         (ghost flow from: 5348)   5349 inc hl 
    inc d                      ;6131 14  .                         (ghost flow from: 5349)   534a inc d 
    djnz l612eh                ;6132 10 fa  . .                    (ghost flow from: 534a)   534b djnz 5347 
    pop de                     ;6134 d1  .                         (ghost flow from: 534b)   534d pop de 
    inc e                      ;6135 1c  .                         (ghost flow from: 534d)   534e inc e 
    dec c                      ;6136 0d  .                         (ghost flow from: 534e)   534f dec c 
    jr nz,l612bh               ;6137 20 f2    .                    (ghost flow from: 534f)   5350 jr nz,5344 
    ret                        ;6139 c9  .                         (ghost flow from: 5350)   5352 ret 

include "relocationTable.asm"



; BLOCK 'logo_image' (start 0x65b3 end 0x66f4)
    defb 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh, 0fch, 0dch, 0a8h, 000h, 0e0h, 0f8h, 0fch, 0fch, 0feh, 076h
    defb 0aah, 000h, 07fh, 0ffh, 0ffh, 0ffh, 0fch, 0dch, 0a8h, 000h, 0e0h, 0f8h, 0fch, 0fch, 0feh, 076h
    defb 0aah, 000h, 00fh, 03fh, 07fh, 07fh, 0feh, 0dch, 0a8h, 000h, 0e0h, 0f8h, 0fch, 0fch, 0feh, 06eh
    defb 054h, 000h, 060h, 0f0h, 0f8h, 0fch, 0feh, 077h, 0aah, 000h, 00ch, 01eh, 03eh, 07eh, 0feh, 076h
    defb 0aah, 000h, 07fh, 0ffh, 0ffh, 0ffh, 0fch, 077h, 0aah, 000h, 0fch, 0feh, 0feh, 0fch, 000h, 060h
    defb 0b0h, 000h, 07fh, 0ffh, 0ffh, 07fh, 007h, 003h, 005h, 000h, 0feh, 0ffh, 0ffh, 0feh, 0e0h, 0a0h
    defb 040h, 000h, 03ch, 07eh, 07eh, 07eh, 07eh, 03bh, 055h, 000h, 01eh, 03fh, 03fh, 03fh, 03fh, 0bbh
    defb 055h, 000h, 03fh, 07fh, 07fh, 07fh, 07eh, 03bh, 055h, 000h, 0feh, 0ffh, 0ffh, 0feh, 000h, 0b8h
    defb 054h, 000h, 03ch, 07eh, 07eh, 07eh, 07eh, 03ah, 054h, 000h, 01eh, 03fh, 03fh, 03fh, 03fh, 01dh
    defb 02ah, 000h, 00fh, 03fh, 03fh, 07fh, 07eh, 07bh, 015h, 000h, 0f8h, 0fch, 0fch, 0f8h, 000h, 0a8h
    defb 054h, 055h, 0bbh, 0ffh, 0ffh, 0fch, 0fch, 0fch, 078h, 054h, 0bch, 0f8h, 0e0h, 000h, 000h, 000h
    defb 000h, 055h, 0bbh, 0ffh, 0ffh, 0ffh, 0fch, 0fch, 078h, 054h, 0bch, 0f8h, 0f0h, 0f8h, 0fch, 07eh
    defb 03ch, 054h, 0ech, 0fch, 0feh, 07fh, 07fh, 03fh, 00fh, 02ah, 076h, 07eh, 0feh, 0fch, 0fch, 0f8h
    defb 0e0h, 055h, 0bbh, 0fdh, 0fch, 0fch, 0fch, 0fch, 078h, 054h, 0bah, 07eh, 07eh, 07eh, 07eh, 07eh
    defb 03ch, 055h, 0bbh, 0fch, 0fch, 0ffh, 0ffh, 0ffh, 07fh, 050h, 0a0h, 000h, 000h, 0fch, 0feh, 0feh
    defb 0fch, 002h, 005h, 007h, 007h, 007h, 007h, 007h, 003h, 0a0h, 0c0h, 0e0h, 0e0h, 0e0h, 0e0h, 0e0h
    defb 0c0h, 02ah, 05dh, 07eh, 07eh, 07eh, 07eh, 07eh, 03ch, 0aah, 0ddh, 03fh, 03fh, 03fh, 03fh, 03fh
    defb 01eh, 02ah, 05dh, 07eh, 07eh, 07fh, 07fh, 07fh, 03fh, 0ach, 0d8h, 000h, 000h, 0feh, 0ffh, 0ffh
    defb 0feh, 02ah, 05ch, 07fh, 07fh, 03fh, 03fh, 01fh, 007h, 015h, 02eh, 07fh, 0ffh, 0feh, 0feh, 0fch
    defb 0f0h, 02ah, 00dh, 000h, 07fh, 0ffh, 0ffh, 0ffh, 07fh, 0a8h, 0deh, 07eh, 0feh, 0feh, 0fch, 0fch
    defb 0f0h

    org 0

ENTRY_POINT_WITH_MONITOR:
    jp v_l7cc9h                ;66f4 c3 09 1f  . . . 

; BLOCK 'data_66f7' (start 0x66f7 end 0x6898)
v_l5dc3h:
    defb 0e0h                  ;66f7 e0  . 
    defb 050h                  ;66f8 50  P 
    defb 0c5h                  ;66f9 c5  . 
    defb 003h                  ;66fa 03  . 
    defb 001h                  ;66fb 01  . 
    defb 000h                  ;66fc 00  . 
    defb 000h                  ;66fd 00  . 
v_l5dcah:
    defb 000h                  ;66fe 00  . 
    defb 040h                  ;66ff 40  @ 
    defb 0a0h                  ;6700 a0  . 
    defb 003h                  ;6701 03  . 
v_l5dceh:
    defb 08bh                  ;6702 8b  . 
    defb 000h                  ;6703 00  . 
    defb 000h                  ;6704 00  . 
v_l5dd1h:
    defb 0a0h                  ;6705 a0  . 
    defb 048h                  ;6706 48  H 
    defb 0c4h                  ;6707 c4  . 
    defb 003h                  ;6708 03  . 
    defb 082h                  ;6709 82  . 
    defb 000h                  ;670a 00  . 
    defb 000h                  ;670b 00  . 
    defb 012h                  ;670c 12  . 
    defb 050h                  ;670d 50  P 
    defb 0a3h                  ;670e a3  . 
    defb 003h                  ;670f 03  . 
    defb 001h                  ;6710 01  . 
    defb 000h                  ;6711 00  . 
    defb 000h                  ;6712 00  . 
v_l5ddfh:
    defb 000h                  ;6713 00  . 
    defb 050h                  ;6714 50  P 
    defb 0c1h                  ;6715 c1  . 
    defb 0b2h                  ;6716 b2  . 
    defb 001h                  ;6717 01  . 
    defw l078e4h               ;6718
    defb 020h                  ;671a 20    
    defb 050h                  ;671b 50  P 
    defb 0c2h                  ;671c c2  . 
    defb 092h                  ;671d 92  . 
    defb 001h                  ;671e 01  . 
    defw l078deh               ;671f
    defb 040h                  ;6721 40  @ 
    defb 050h                  ;6722 50  P 
    defb 0c3h                  ;6723 c3  . 
    defb 092h                  ;6724 92  . 
    defb 001h                  ;6725 01  . 
    defw l078ddh               ;6726
    defb 060h                  ;6728 60  ` 
    defb 050h                  ;6729 50  P 
    defb 0c4h                  ;672a c4  . 
    defb 092h                  ;672b 92  . 
    defb 001h                  ;672c 01  . 
    defw l078e0h               ;672d
    defb 080h                  ;672f 80  . 
    defb 050h                  ;6730 50  P 
    defb 0c5h                  ;6731 c5  . 
    defb 092h                  ;6732 92  . 
    defb 001h                  ;6733 01  . 
    defw l078dfh               ;6734
    defb 0a0h                  ;6736 a0  . 
    defb 050h                  ;6737 50  P 
    defb 0c8h                  ;6738 c8  . 
    defb 092h                  ;6739 92  . 
    defb 001h                  ;673a 01  . 
    defw l078e2h               ;673b
    defb 0c0h                  ;673d c0  . 
    defb 050h                  ;673e 50  P 
    defb 0cch                  ;673f cc  . 
    defb 092h                  ;6740 92  . 
    defb 001h                  ;6741 01  . 
    defw l078e1h               ;6742
    defb 080h                  ;6744 80  . 
    defb 048h                  ;6745 48  H 
    defb 0c9h                  ;6746 c9  . 
    defb 082h                  ;6747 82  . 
    defb 000h                  ;6748 00  . 
    defw l078d0h               ;6749
    defb 0c8h                  ;674b c8  . 
    defb 050h                  ;674c 50  P 
    defb 0d2h                  ;674d d2  . 
    defb 082h                  ;674e 82  . 
    defb 001h                  ;674f 01  . 
    defw l078cfh               ;6750
    defb 000h                  ;6752 00  . 
    defb 048h                  ;6753 48  H 
    defb 019h                  ;6754 19  . 
    defb 082h                  ;6755 82  . 
    defb 000h                  ;6756 00  . 
    defw l078dch               ;6757
    defb 020h                  ;6759 20    
    defb 048h                  ;675a 48  H 
    defb 01dh                  ;675b 1d  . 
    defb 082h                  ;675c 82  . 
    defb 000h                  ;675d 00  . 
    defw l078dbh               ;675e
    defb 040h                  ;6760 40  @ 
    defb 048h                  ;6761 48  H 
    defb 01ah                  ;6762 1a  . 
    defb 082h                  ;6763 82  . 
    defb 000h                  ;6764 00  . 
    defw l078dah               ;6765
    defb 060h                  ;6767 60  ` 
    defb 048h                  ;6768 48  H 
    defb 01eh                  ;6769 1e  . 
    defb 082h                  ;676a 82  . 
    defb 000h                  ;676b 00  . 
    defw l078d9h               ;676c
    defb 0ceh                  ;676e ce  . 
    defb 050h                  ;676f 50  P 
    defb 0c6h                  ;6770 c6  . 
    defb 000h                  ;6771 00  . 
    defb 001h                  ;6772 01  . 
    defw l078e3h               ;6773
    defb 0e0h                  ;6775 e0  . 
    defb 040h                  ;6776 40  @ 
    defb 015h                  ;6777 15  . 
    defb 08ah                  ;6778 8a  . 
    defb 000h                  ;6779 00  . 
    defw l078e3h               ;677a
    defb 049h                  ;677c 49  I 
    defb 050h                  ;677d 50  P 
    defb 016h                  ;677e 16  . 
    defb 08ah                  ;677f 8a  . 
    defb 001h                  ;6780 01  . 
    defw l078ddh               ;6781
    defb 069h                  ;6783 69  i 
    defb 050h                  ;6784 50  P 
    defb 017h                  ;6785 17  . 
    defb 08ah                  ;6786 8a  . 
    defb 001h                  ;6787 01  . 
    defw l078dfh               ;6788
    defb 089h                  ;678a 89  . 
    defb 050h                  ;678b 50  P 
    defb 018h                  ;678c 18  . 
    defb 08ah                  ;678d 8a  . 
    defb 001h                  ;678e 01  . 
    defw l078e1h               ;678f
    defb 052h                  ;6791 52  R 
    defb 050h                  ;6792 50  P 
    defb 023h                  ;6793 23  # 
    defb 08ah                  ;6794 8a  . 
    defb 001h                  ;6795 01  . 
    defw l078e5h               ;6796
    defb 072h                  ;6798 72  r 
    defb 050h                  ;6799 50  P 
    defb 01bh                  ;679a 1b  . 
    defb 08ah                  ;679b 8a  . 
    defb 001h                  ;679c 01  . 
    defw l078dbh               ;679d 
    defb 092h                  ;679f 92  . 
    defb 050h                  ;67a0 50  P 
    defb 01ch                  ;67a1 1c  . 
    defb 08ah                  ;67a2 8a  . 
    defb 001h                  ;67a3 01  . 
    defw l078d9h               ;67a4
    defb 0d9h                  ;67a6 d9  . 
    defb 050h                  ;67a7 50  P 
    defb 0d4h                  ;67a8 d4  . 
    defb 08ah                  ;67a9 8a  . 
    defb 001h                  ;67aa 01  . 
    defw l078e7h               ;67ab
    defb 0a0h                  ;67ad a0  . 
    defb 048h                  ;67ae 48  H 
    defb 0d8h                  ;67af d8  . 
    defb 081h                  ;67b0 81  . 
    defb 0e0h                  ;67b1 e0  . 
    defw l078e9h               ;67b2
    defb 0b1h                  ;67b4 b1  . 
    defb 048h                  ;67b5 48  H 
    defb 0d9h                  ;67b6 d9  . 
    defb 081h                  ;67b7 81  . 
    defb 0e0h                  ;67b8 e0  . 
    defw l078ebh               ;67b9
    defb 008h                  ;67bb 08  . 
    defb 048h                  ;67bc 48  H 
    defb 026h                  ;67bd 26  & 
    defb 081h                  ;67be 81  . 
    defb 0e0h                  ;67bf e0  . 
    defw l078ddh               ;67c0
    defb 028h                  ;67c2 28  ( 
    defb 048h                  ;67c3 48  H 
    defb 027h                  ;67c4 27  ' 
    defb 081h                  ;67c5 81  . 
    defb 0e0h                  ;67c6 e0  . 
    defw l078dfh               ;67c7
    defb 048h                  ;67c9 48  H 
    defb 048h                  ;67ca 48  H 
    defb 028h                  ;67cb 28  ( 
    defb 081h                  ;67cc 81  . 
    defb 0e0h                  ;67cd e0  . 
    defw l078e1h               ;67ce
    defb 016h                  ;67d0 16  . 
    defb 050h                  ;67d1 50  P 
    defb 02bh                  ;67d2 2b  + 
    defb 08dh                  ;67d3 8d  . 
    defb 0e5h                  ;67d4 e5  . 
    defw l078e5h               ;67d5
    defb 068h                  ;67d7 68  h 
    defb 048h                  ;67d8 48  H 
    defb 029h                  ;67d9 29  ) 
    defb 081h                  ;67da 81  . 
    defb 0e0h                  ;67db e0  . 
    defw l078dbh               ;67dc
    defb 088h                  ;67de 88  . 
    defb 048h                  ;67df 48  H 
    defb 02ah                  ;67e0 2a  * 
    defb 081h                  ;67e1 81  . 
    defb 0e0h                  ;67e2 e0  . 
    defw l078d9h               ;67e3
    defb 0d4h                  ;67e5 d4  . 
l067e6h:
    defb 002h                  ;67e6 02  . 
    defb 0c0h                  ;67e7 c0  . 
    defb 05dh                  ;67e8 5d  ] 
    defb 038h                  ;67e9 38  8 
    defb 09ch                  ;67ea 9c  . 
    defb 000h                  ;67eb 00  . 
    defb 000h                  ;67ec 00  . 
    defb 000h                  ;67ed 00  . 
    defb 000h                  ;67ee 00  . 
    defb 000h                  ;67ef 00  . 
    defb 000h                  ;67f0 00  . 
    defb 000h                  ;67f1 00  . 
    defb 000h                  ;67f2 00  . 
    defb 000h                  ;67f3 00  . 
    defb 000h                  ;67f4 00  . 
    defb 000h                  ;67f5 00  . 
    defb 000h                  ;67f6 00  . 
    defb 000h                  ;67f7 00  . 
    defb 000h                  ;67f8 00  . 
    defb 000h                  ;67f9 00  . 
    defb 000h                  ;67fa 00  . 
    defb 000h                  ;67fb 00  . 
    defb 000h                  ;67fc 00  . 
    defb 000h                  ;67fd 00  . 
    defb 000h                  ;67fe 00  . 
    defb 0d5h                  ;67ff d5  . 
v_l5ecch:
    defb 002h                  ;6800 02  . 
    defb 0c0h                  ;6801 c0  . 
    defb 05dh                  ;6802 5d  ] 
    defb 038h                  ;6803 38  8 
    defb 09ch                  ;6804 9c  . 
    defb 000h                  ;6805 00  . 
    defb 000h                  ;6806 00  . 
    defb 000h                  ;6807 00  . 
    defb 000h                  ;6808 00  . 
    defb 000h                  ;6809 00  . 
    defb 000h                  ;680a 00  . 
    defb 000h                  ;680b 00  . 
    defb 000h                  ;680c 00  . 
    defb 000h                  ;680d 00  . 
    defb 000h                  ;680e 00  . 
    defb 000h                  ;680f 00  . 
    defb 000h                  ;6810 00  . 
    defb 000h                  ;6811 00  . 
    defb 000h                  ;6812 00  . 
    defb 000h                  ;6813 00  . 
    defb 000h                  ;6814 00  . 
    defb 000h                  ;6815 00  . 
    defb 000h                  ;6816 00  . 
    defb 000h                  ;6817 00  . 
    defb 000h                  ;6818 00  . 
v_l5ee5h:
    defb 000h                  ;6819 00  . 
    defb 000h                  ;681a 00  . 
    defb 000h                  ;681b 00  . 
    defb 000h                  ;681c 00  . 
    defb 000h                  ;681d 00  . 
    defb 000h                  ;681e 00  . 
    defb 000h                  ;681f 00  . 
    defb 000h                  ;6820 00  . 
    defb 000h                  ;6821 00  . 
    defb 000h                  ;6822 00  . 
    defb 000h                  ;6823 00  . 
    defb 000h                  ;6824 00  . 
    defb 000h                  ;6825 00  . 
    defb 000h                  ;6826 00  . 
    defb 000h                  ;6827 00  . 
    defb 000h                  ;6828 00  . 
    defb 000h                  ;6829 00  . 
    defb 000h                  ;682a 00  . 
    defb 000h                  ;682b 00  . 
    defb 000h                  ;682c 00  . 
    defb 000h                  ;682d 00  . 
    defb 000h                  ;682e 00  . 
    defb 000h                  ;682f 00  . 
    defb 000h                  ;6830 00  . 
    defb 000h                  ;6831 00  . 
    defb 0d3h                  ;6832 d3  . 
l06833h:
    defb 002h                  ;6833 02  . 
    defb 000h                  ;6834 00  . 
    defb 000h                  ;6835 00  . 
    defb 000h                  ;6836 00  . 
    defb 000h                  ;6837 00  . 
    defb 000h                  ;6838 00  . 
    defb 000h                  ;6839 00  . 
    defb 000h                  ;683a 00  . 
    defb 000h                  ;683b 00  . 
    defb 000h                  ;683c 00  . 
    defb 000h                  ;683d 00  . 
    defb 000h                  ;683e 00  . 
    defb 000h                  ;683f 00  . 
    defb 000h                  ;6840 00  . 
    defb 000h                  ;6841 00  . 
    defb 000h                  ;6842 00  . 
    defb 000h                  ;6843 00  . 
    defb 000h                  ;6844 00  . 
    defb 000h                  ;6845 00  . 
    defb 000h                  ;6846 00  . 
    defb 000h                  ;6847 00  . 
    defb 000h                  ;6848 00  . 
    defb 000h                  ;6849 00  . 
    defb 000h                  ;684a 00  . 
    defb 000h                  ;684b 00  . 
    defb 0d2h                  ;684c d2  . 
l0684dh:
    defb 002h                  ;684d 02  . 
l0684eh:
    defb 000h                  ;684e 00  . 
    defb 000h                  ;684f 00  . 
    defb 000h                  ;6850 00  . 
    defb 000h                  ;6851 00  . 
    defb 000h                  ;6852 00  . 
    defb 000h                  ;6853 00  . 
    defb 000h                  ;6854 00  . 
    defb 000h                  ;6855 00  . 
    defb 000h                  ;6856 00  . 
    defb 000h                  ;6857 00  . 
    defb 000h                  ;6858 00  . 
    defb 000h                  ;6859 00  . 
    defb 000h                  ;685a 00  . 
    defb 000h                  ;685b 00  . 
    defb 000h                  ;685c 00  . 
    defb 000h                  ;685d 00  . 
    defb 000h                  ;685e 00  . 
    defb 000h                  ;685f 00  . 
    defb 000h                  ;6860 00  . 
    defb 000h                  ;6861 00  . 
    defb 000h                  ;6862 00  . 
    defb 000h                  ;6863 00  . 
    defb 000h                  ;6864 00  . 
    defb 000h                  ;6865 00  . 
    defb 0d1h                  ;6866 d1  . 
v_l5f33h:
    defb 002h                  ;6867 02  . 
    defb 000h                  ;6868 00  . 
    defb 000h                  ;6869 00  . 
    defb 000h                  ;686a 00  . 
    defb 000h                  ;686b 00  . 
    defb 000h                  ;686c 00  . 
    defb 000h                  ;686d 00  . 
    defb 000h                  ;686e 00  . 
    defb 000h                  ;686f 00  . 
    defb 000h                  ;6870 00  . 
    defb 000h                  ;6871 00  . 
    defb 000h                  ;6872 00  . 
    defb 000h                  ;6873 00  . 
    defb 000h                  ;6874 00  . 
    defb 000h                  ;6875 00  . 
    defb 000h                  ;6876 00  . 
    defb 000h                  ;6877 00  . 
    defb 000h                  ;6878 00  . 
    defb 000h                  ;6879 00  . 
    defb 000h                  ;687a 00  . 
    defb 000h                  ;687b 00  . 
    defb 000h                  ;687c 00  . 
    defb 000h                  ;687d 00  . 
    defb 000h                  ;687e 00  . 
    defb 000h                  ;687f 00  . 
    defb 0cch                  ;6880 cc  . 
l06881h:
    defb 001h                  ;6881 01  . 
    defb 000h                  ;6882 00  . 
    defb 000h                  ;6883 00  . 
    defb 000h                  ;6884 00  . 
    defb 000h                  ;6885 00  . 
    defb 000h                  ;6886 00  . 
    defb 000h                  ;6887 00  . 
    defb 000h                  ;6888 00  . 
    defb 000h                  ;6889 00  . 
    defb 000h                  ;688a 00  . 
    defb 000h                  ;688b 00  . 
    defb 000h                  ;688c 00  . 
    defb 000h                  ;688d 00  . 
    defb 000h                  ;688e 00  . 
    defb 000h                  ;688f 00  . 
    defb 000h                  ;6890 00  . 
    defb 000h                  ;6891 00  . 
    defb 000h                  ;6892 00  . 
    defb 000h                  ;6893 00  . 
    defb 000h                  ;6894 00  . 
    defb 000h                  ;6895 00  . 
    defb 000h                  ;6896 00  . 
    defb 000h                  ;6897 00  . 
v_sub_5f64h:
    call v_sub_6c4ah           ;6898 cd 8a 0e  . . . 
    xor a                      ;689b af  . 
    in a,(0feh)                ;689c db fe  . . 
    cpl                        ;689e 2f  / 
    and 01fh                   ;689f e6 1f  . . 
    ret nz                     ;68a1 c0  . 
    call v_sub_8608h           ;68a2 cd 48 28  . H ( 
    cp 004h                    ;68a5 fe 04  . . 
    ret nz                     ;68a7 c0  . 
v_l5f74h:
    di                         ;68a8 f3  .                         (flow (mon) from: 6015 7bd2)  5f74 di 
    call v_sub_7800h           ;68a9 cd 40 1a  . @ .               (flow (mon) from: 5f74)  5f75 call 7800 
        ld sp,l094d5h                                          ;68ac 31 e1 2d  1 . -                                                   (flow (mon) from: 7804)  5f78 ld sp,8ba1                            (flow (mon) from: 7804)  5f78 ld sp,8ba1 
    call v_sub_665ah           ;68af cd 9a 08  . . .               (flow (mon) from: 5f78)  5f7b call 665a 
    ld hl,inputBufferStart     ;68b2 21 3f 2d  ! ? -               (flow (mon) from: 82e5)  5f7e ld hl,8aff 
    ld (hl),0c6h               ;68b5 36 c6  6 .                    (flow (mon) from: 5f7e)  5f81 ld (hl),c6 
    inc hl                     ;68b7 23  #                         (flow (mon) from: 5f81)  5f83 inc hl 
    ld a,(v_l68f2h+1)          ;68b8 3a 33 0b  : 3 .               (flow (mon) from: 5f83)  5f84 ld a,(68f3) 
    add a,0c7h                 ;68bb c6 c7  . .                    (flow (mon) from: 5f84)  5f87 add a,c7 
    ld (hl),a                  ;68bd 77  w                         (flow (mon) from: 5f87)  5f89 ld (hl),a 
    inc hl                     ;68be 23  #                         (flow (mon) from: 5f89)  5f8a inc hl 
    ld (hl),0cch               ;68bf 36 cc  6 .                    (flow (mon) from: 5f8a)  5f8b ld (hl),cc 
    inc hl                     ;68c1 23  #                         (flow (mon) from: 5f8b)  5f8d inc hl 
    ld a,(v_l6848h)            ;68c2 3a 88 0a  : . .               (flow (mon) from: 5f8d)  5f8e ld a,(6848) 
    or a                       ;68c5 b7  .                         (flow (mon) from: 5f8e)  5f91 or a 
    jr z,l68cah                ;68c6 28 02  ( .                    (flow (mon) from: 5f91)  5f92 jr z,5f96 
    sub 0c7h                   ;68c8 d6 c7  . . 
l68cah:
    add a,0c9h                 ;68ca c6 c9  . .                    (flow (mon) from: 5f92)  5f96 add a,c9 
    ld (hl),a                  ;68cc 77  w                         (flow (mon) from: 5f96)  5f98 ld (hl),a 
    call v_sub_6669h           ;68cd cd a9 08  . . .               (flow (mon) from: 5f98)  5f99 call 6669 
    ld a,080h                  ;68d0 3e 80  > .                    (flow (mon) from: 85db)  5f9c ld a,80 
    ld (inputBufferStart),a    ;68d2 32 3f 2d  2 ? -               (flow (mon) from: 5f9c)  5f9e ld (8aff),a 
        ld hl,l095f9h+170                                      ;68d5 21 af 2f  ! . /                                                   (flow (mon) from: 5f9e)  5fa1 ld hl,8d6f                            (flow (mon) from: 5f9e)  5fa1 ld hl,8d6f 
    ld (vr_l08750h+1),hl       ;68d8 22 91 29  " . )               (flow (mon) from: 5fa1)  5fa4 ld (8751),hl 
    ld hl,v_l89f4h             ;68db 21 34 2c  ! 4 ,               (flow (mon) from: 5fa4)  5fa7 ld hl,89f4 
        ld (l089d3h+1),hl                                      ;68de 22 e0 22  " . "                                                   (flow (mon) from: 5fa7)  5faa ld (80a0),hl                          (flow (mon) from: 5fa7)  5faa ld (80a0),hl 
    ld hl,v_l82dbh             ;68e1 21 1b 25  ! . %               (flow (mon) from: 5faa)  5fad ld hl,82db 
    ld (vr_l080a2h+1),hl       ;68e4 22 e3 22  " . "               (flow (mon) from: 5fad)  5fb0 ld (80a3),hl 
    ld hl,v_l7ccfh             ;68e7 21 0f 1f  ! . .               (flow (mon) from: 5fb0)  5fb3 ld hl,7ccf 
    ld (vr_l07e38h+1),hl       ;68ea 22 79 20  " y                 (flow (mon) from: 5fb3)  5fb6 ld (7e39),hl 
    ld hl,v_l5f74h             ;68ed 21 b4 01  ! . .               (flow (mon) from: 5fb6)  5fb9 ld hl,5f74 
    push hl                    ;68f0 e5  .                         (flow (mon) from: 5fb9)  5fbc push hl 
    call v_sub_6d79h           ;68f1 cd b9 0f  . . .               (flow (mon) from: 5fbc)  5fbd call 6d79 
    call v_sub_8608h           ;68f4 cd 48 28  . H (               (flow (mon) from: 6d99)  5fc0 call 8608 
    call v_sub_6113h           ;68f7 cd 53 03  . S .               (flow (mon) from: 8610)  5fc3 call 6113 
    call v_sub_85f8h           ;68fa cd 38 28  . 8 (               (flow (mon) from: 611c)  5fc6 call 85f8 
        ld hl,(l0696eh+1)                                      ;68fd 2a 7b 02  * { .                                                   (flow (mon) from: 8607)  5fc9 ld hl,(603b)                          (flow (mon) from: 8607)  5fc9 ld hl,(603b) 
    ld e,020h                  ;6900 1e 20  .                      (flow (mon) from: 5fc9)  5fcc ld e,20 
    cp 071h                    ;6902 fe 71  . q                    (flow (mon) from: 5fcc)  5fce cp 71 
    jp z,v_l7cc9h              ;6904 ca 09 1f  . . .               (flow (mon) from: 5fce)  5fd0 jp z,7cc9 
    cp 014h                    ;6907 fe 14  . .                    (flow (mon) from: 5fd0)  5fd3 cp 14 
    jp z,v_l6c83h              ;6909 ca c3 0e  . . .               (flow (mon) from: 5fd3)  5fd5 jp z,6c83 
    cp 023h                    ;690c fe 23  . #                    (flow (mon) from: 5fd5)  5fd8 cp 23 
    jp z,v_l7c39h              ;690e ca 79 1e  . y .               (flow (mon) from: 5fd8)  5fda jp z,7c39 
    cp 03ah                    ;6911 fe 3a  . :                    (flow (mon) from: 5fda)  5fdd cp 3a 
    jp z,v_l66eah              ;6913 ca 2a 09  . * .               (flow (mon) from: 5fdd)  5fdf jp z,66ea 
    cp 02ch                    ;6916 fe 2c  . ,                    (flow (mon) from: 5fdf)  5fe2 cp 2c 
    jp z,v_l64feh              ;6918 ca 3e 07  . > .               (flow (mon) from: 5fe2)  5fe4 jp z,64fe 
    cp 003h                    ;691b fe 03  . .                    (flow (mon) from: 5fe4)  5fe7 cp 03 
    jp z,v_l7ca3h              ;691d ca e3 1e  . . .               (flow (mon) from: 5fe7)  5fe9 jp z,7ca3 
    ld c,a                     ;6920 4f  O                         (flow (mon) from: 5fe9)  5fec ld c,a 
    ld b,028h                  ;6921 06 28  . (                    (flow (mon) from: 5fec)  5fed ld b,28 
    ld hl,v_l600ah             ;6923 21 4a 02  ! J .               (flow (mon) from: 5fed)  5fef ld hl,600a 
    ld de,v_l6063h             ;6926 11 a3 02  . . .               (flow (mon) from: 5fef)  5ff2 ld de,6063 
l6929h:
    ld a,(de)                  ;6929 1a  .                         (flow (mon) from: 5ff2 5fff)  5ff5 ld a,(de) 
    inc de                     ;692a 13  .                         (flow (mon) from: 5ff5)  5ff6 inc de 
    call v_sub_6bd8h           ;692b cd 18 0e  . . .               (flow (mon) from: 5ff6)  5ff7 call 6bd8 
    ld a,(de)                  ;692e 1a  .                         (flow (mon) from: 6bda)  5ffa ld a,(de) 
    cp c                       ;692f b9  .                         (flow (mon) from: 5ffa)  5ffb cp c 
    inc de                     ;6930 13  .                         (flow (mon) from: 5ffb)  5ffc inc de 
    jr z,l6939h                ;6931 28 06  ( .                    (flow (mon) from: 5ffc)  5ffd jr z,6005 
    djnz l6929h                ;6933 10 f4  . .                    (flow (mon) from: 5ffd)  5fff djnz 5ff5 
    ld a,c                     ;6935 79  y 
    jp v_l6480h                ;6936 c3 c0 06  . . . 
l6939h:
    push hl                    ;6939 e5  .                         (flow (mon) from: 5ffd)  6005 push hl 
        ld hl,(l0696eh+1)                                      ;693a 2a 7b 02  * { .                                                   (flow (mon) from: 6005)  6006 ld hl,(603b)                          (flow (mon) from: 6005)  6006 ld hl,(603b) 
    ret                        ;693d c9  .                         (flow (mon) from: 6006)  6009 ret 
v_l600ah:
    call v_sub_60c3h           ;693e cd 03 03  . . . 
    call nz,02b23h             ;6941 c4 23 2b  . # + 
    dec hl                     ;6944 2b  +                         (flow (mon) from: 600f)  6010 dec hl 
    inc hl                     ;6945 23  #                         (flow (mon) from: 6010)  6011 inc hl 
l6946h:
v_l6012h:
        ld (l0696eh+1),hl                                      ;6946 22 7b 02  " { .                                                   (flow (mon) from: 6011 6046)  6012 ld (603b),hl                     (flow (mon) from: 6011 6046)  6012 ld (603b),hl 
    ret                        ;6949 c9  .                         (flow (mon) from: 6012)  6015 ret 
    ld hl,v_l5ee5h             ;694a 21 25 01  ! % . 
    ld a,(hl)                  ;694d 7e  ~ 
    or a                       ;694e b7  . 
    ret z                      ;694f c8  . 
    dec (hl)                   ;6950 35  5 
    add a,a                    ;6951 87  . 
    call v_sub_6bd8h           ;6952 cd 18 0e  . . . 
    ld a,(hl)                  ;6955 7e  ~ 
    dec hl                     ;6956 2b  + 
    ld l,(hl)                  ;6957 6e  n 
    ld h,a                     ;6958 67  g 
    jr l6946h                  ;6959 18 eb  . . 
    ld hl,v_l5ee5h             ;695b 21 25 01  ! % .               (flow (mon) from: 6009)  6027 ld hl,5ee5 
    ld a,(hl)                  ;695e 7e  ~                         (flow (mon) from: 6027)  602a ld a,(hl) 
    cp 00ah                    ;695f fe 0a  . .                    (flow (mon) from: 602a)  602b cp 0a 
    ret nc                     ;6961 d0  .                         (flow (mon) from: 602b)  602d ret nc 
    push hl                    ;6962 e5  .                         (flow (mon) from: 602d)  602e push hl 
    call v_sub_60c3h           ;6963 cd 03 03  . . .               (flow (mon) from: 602e)  602f call 60c3 
    call nz,034e3h             ;6966 c4 e3 34  . . 4 
    ld a,(hl)                  ;6969 7e  ~ 
    add a,a                    ;696a 87  . 
    call v_sub_6bd8h           ;696b cd 18 0e  . . . 
l0696eh:
    ld de,00000h               ;696e 11 00 00  . . . 
    ld (hl),d                  ;6971 72  r 
    dec hl                     ;6972 2b  + 
    ld (hl),e                  ;6973 73  s 
    pop hl                     ;6974 e1  . 
    jr l6946h                  ;6975 18 cf  . . 
    call v_sub_6b56h           ;6977 cd 96 0d  . . .               (flow (mon) from: 6009)  6043 call 6b56 
    jr l6946h                  ;697a 18 ca  . .                    (flow (mon) from: 6bda)  6046 jr 6012 
    call v_sub_60c3h           ;697c cd 03 03  . . . 
    defb 0xc2, 0xcd            ;697f
    defw v_sub_6c47h           ;6981
    defb 0xcd                  ;6983
    defw l0733eh               ;6984
    call v_sub_5f64h           ;6986 cd a4 01  . . . 
    jr $-6                     ;6989 18 f8  . . 
    ld ix,v_l5dcah             ;698b dd 21 0a 00  . ! . . 
    ld a,(ix+004h)             ;698f dd 7e 04  . ~ . 
    and 01fh                   ;6992 e6 1f  . . 
    jp v_l6e46h                ;6994 c3 86 10  . . . 
v_l6063h:
    nop                        ;6997 00  . 
    ld l,l                     ;6998 6d  m 
    dec b                      ;6999 05  . 
    ld a,(bc)                  ;699a 0a  . 
    ld (bc),a                  ;699b 02  . 
    dec c                      ;699c 0d  . 
    dec b                      ;699d 05  . 
    ex af,af'                  ;699e 08  . 
    ld de,01c0bh               ;699f 11 0b 1c  . . . 
    add hl,bc                  ;69a2 09  . 
    dec b                      ;69a3 05  . 
    halt                       ;69a4 76  v 
    inc b                      ;69a5 04  . 
    inc h                      ;69a6 24  $ 
    dec bc                     ;69a7 0b  . 
    dec b                      ;69a8 05  . 
    ld e,h                     ;69a9 5c  \ 
    jr nz,l6a2bh               ;69aa 20 7f     
    ld h,l                     ;69ac 65  e 
    ld c,060h                  ;69ad 0e 60  . ` 
    ld b,078h                  ;69af 06 78  . x 
    ld de,00563h               ;69b1 11 63 05  . c . 
    ccf                        ;69b4 3f  ? 
    ld c,074h                  ;69b5 0e 74  . t 
    inc d                      ;69b7 14  . 
    ld a,01eh                  ;69b8 3e 1e  > . 
    ld l,005h                  ;69ba 2e 05  . . 
    ld (hl),e                  ;69bc 73  s 
    dec b                      ;69bd 05  . 
    ld a,h                     ;69be 7c  | 
    ld b,h                     ;69bf 44  D 
    ld l,d                     ;69c0 6a  j 
    dec b                      ;69c1 05  . 
    dec l                      ;69c2 2d  - 
    dec d                      ;69c3 15  . 
    ld a,c                     ;69c4 79  y 
    ld l,c                     ;69c5 69  i 
    ld hl,(06412h)                                             ;69c6 2a 12 64  * . d 
    ld b,e                     ;69c9 43  C 
    ld e,h                     ;69ca 5c  \ 
    ld hl,(00877h)             ;69cb 2a 77 08  * w . 
    ld e,l                     ;69ce 5d  ] 
    ld a,(0165eh)              ;69cf 3a 5e 16  : ^ . 
    ld l,c                     ;69d2 69  i 
    dec b                      ;69d3 05  . 
    ld a,a                     ;69d4 7f   
    ld hl,00570h               ;69d5 21 70 05  ! p . 
    ld (03d1bh),hl             ;69d8 22 1b 3d  " . = 
    inc b                      ;69db 04  . 
    ld l,h                     ;69dc 6c  l 
    ld b,c                     ;69dd 41  A 
    dec sp                     ;69de 3b                        ; 
    inc b                      ;69df 04  . 
    ld l,a                     ;69e0 6f  o 
    cpl                        ;69e1 2f  / 
    ld (hl),023h               ;69e2 36 23  6 # 
    ld h,a                     ;69e4 67  g 
    inc h                      ;69e5 24  $ 
    ld l,(hl)                  ;69e6 6e  n 
v_sub_60b3h:
    ld (v_sub_664ch+1),hl      ;69e7 22 8d 08  " . . 
v_sub_60b6h:
    ld a,021h                  ;69ea 3e 21  > ! 
    ld de,00001h               ;69ec 11 01 00  . . . 
    ld hl,(v_sub_826ch+1)      ;69ef 2a ad 24  * . $ 
    ld (v_l79c3h+1),hl         ;69f2 22 04 1c  " . . 
    jr l69ffh                  ;69f5 18 08  . . 
v_sub_60c3h:
    pop hl                     ;69f7 e1  .                         (flow (mon) from: 602f)  60c3 pop hl 
    ld e,(hl)                  ;69f8 5e  ^                         (flow (mon) from: 60c3)  60c4 ld e,(hl) 
    inc hl                     ;69f9 23  #                         (flow (mon) from: 60c4)  60c5 inc hl 
    push hl                    ;69fa e5  .                         (flow (mon) from: 60c5)  60c6 push hl 
    ld d,001h                  ;69fb 16 01  . .                    (flow (mon) from: 60c6)  60c7 ld d,01 
    ld a,0c3h                  ;69fd 3e c3  > .                    (flow (mon) from: 60c7)  60c9 ld a,c3 
l69ffh:
    ld (v_l60f1h),a            ;69ff 32 31 03  2 1 .               (flow (mon) from: 60c9)  60cb ld (60f1),a 
    call v_sub_665ah           ;6a02 cd 9a 08  . . .               (flow (mon) from: 60cb)  60ce call 665a 
    ld (inputBufferStart),de   ;6a05 ed 53 3f 2d  . S ? -          (flow (mon) from: 82e5)  60d1 ld (8aff),de 
    ld (v_l60d9h+1),sp         ;6a09 ed 73 1a 03  . s . .          (flow (mon) from: 60d1)  60d5 ld (60da),sp 
l6a0dh:
v_l60d9h:
    ld sp,00000h               ;6a0d 31 00 00  1 . .               (flow (mon) from: 60d5)  60d9 ld sp,8b9b 
    call v_l82dbh              ;6a10 cd 1b 25  . . %               (flow (mon) from: 60d9)  60dc call 82db 
    ld hl,v_l612dh             ;6a13 21 6d 03  ! m .               (flow (mon) from: 82e5)  60df ld hl,612d 
        ld (l089d3h+1),hl                                      ;6a16 22 e0 22  " . "                                                   (flow (mon) from: 60df)  60e2 ld (80a0),hl                          (flow (mon) from: 60df)  60e2 ld (80a0),hl 
    call v_sub_6675h           ;6a19 cd b5 08  . . .               (flow (mon) from: 60e2)  60e5 call 6675 
    ld hl,inputBufferStart+1   ;6a1c 21 40 2d  ! @ - 
    call atHLorNextIfOne       ;6a1f cd ee 27  . . ' 
    cp 03ah                    ;6a22 fe 3a  . : 
    ret z                      ;6a24 c8  . 
v_l60f1h:
    jp v_l719dh                ;6a25 c3 dd 13  . . . 
    ld hl,inputBufferStart     ;6a28 21 3f 2d  ! ? - 
l6a2bh:
    call atHLorNextIfOne       ;6a2b cd ee 27  . . ' 
    ld c,009h                  ;6a2e 0e 09  . . 
    call v_sub_7ee7h           ;6a30 cd 27 21  . ' ! 
    call v_sub_664ch           ;6a33 cd 8c 08  . . . 
    call v_sub_79afh           ;6a36 cd ef 1b  . . . 
    call v_sub_664ch           ;6a39 cd 8c 08  . . . 
    call v_sub_78dah           ;6a3c cd 1a 1b  . . . 
    ld hl,(v_l7953h+1)         ;6a3f 2a 94 1b  * . . 
    ld (v_sub_664ch+1),hl      ;6a42 22 8d 08  " . . 
    xor a                      ;6a45 af  . 
    ret                        ;6a46 c9  . 
v_sub_6113h:
    ld hl,(v_l5dc3h)           ;6a47 2a 03 00  * . .               (flow (mon) from: 5fc3 666f)  6113 ld hl,(5dc3) 
    push af                    ;6a4a f5  .                         (flow (mon) from: 6113)  6116 push af 
    ld a,l                     ;6a4b 7d  }                         (flow (mon) from: 6116)  6117 ld a,l 
    and 0e0h                   ;6a4c e6 e0  . .                    (flow (mon) from: 6117)  6118 and e0 
    ld l,a                     ;6a4e 6f  o                         (flow (mon) from: 6118)  611a ld l,a 
    pop af                     ;6a4f f1  .                         (flow (mon) from: 611a)  611b pop af 
    ret                        ;6a50 c9  .                         (flow (mon) from: 611b)  611c ret 
v_sub_611dh:
    call v_sub_6113h           ;6a51 cd 53 03  . S . 
    call v_sub_80b7h           ;6a54 cd f7 22  . . " 
    ld h,001h                  ;6a57 26 01  & . 
l6a59h:
    inc hl                     ;6a59 23  # 
    ex (sp),hl                 ;6a5a e3  . 
    ex (sp),hl                 ;6a5b e3  . 
    inc h                      ;6a5c 24  $ 
    dec h                      ;6a5d 25  % 
    jr nz,l6a59h               ;6a5e 20 f9    . 
    ret                        ;6a60 c9  . 
v_l612dh:
    call v_sub_611dh           ;6a61 cd 5d 03  . ] . 
    jr l6a0dh                  ;6a64 18 a7  . . 
    call v_sub_60b3h           ;6a66 cd f3 02  . . . 
l6a69h:
    ld hl,(v_sub_664ch+1)      ;6a69 2a 8d 08  * . . 
    call v_sub_6d7ch           ;6a6c cd bc 0f  . . . 
    call v_sub_60b6h           ;6a6f cd f6 02  . . . 
    jr l6a69h                  ;6a72 18 f5  . . 
    ld hl,v_l68f2h+1           ;6a74 21 33 0b  ! 3 . 
l6a77h:
    jp v_l7c41h                ;6a77 c3 81 1e  . . . 
    ld hl,v_l6848h             ;6a7a 21 88 0a  ! . . 
    ld a,(hl)                  ;6a7d 7e  ~ 
    or a                       ;6a7e b7  . 
    jr nz,l6a83h               ;6a7f 20 02    . 
    ld a,0c7h                  ;6a81 3e c7  > . 
l6a83h:
    inc a                      ;6a83 3c  < 
    cp 0cah                    ;6a84 fe ca  . . 
    jr nz,l6a89h               ;6a86 20 01    . 
    xor a                      ;6a88 af  . 
l6a89h:
    ld (hl),a                  ;6a89 77  w 
    ret                        ;6a8a c9  . 
    ld hl,v_l6aedh+1           ;6a8b 21 2e 0d  ! . . 
    jr l6a77h                  ;6a8e 18 e7  . . 
        ld hl,l073c4h+1                                        ;6a90 21 d1 0c  ! . . 
    ld a,(hl)                  ;6a93 7e  ~ 
    or a                       ;6a94 b7  . 
    jr nz,l6a99h               ;6a95 20 02    . 
    ld a,003h                  ;6a97 3e 03  > . 
l6a99h:
    dec a                      ;6a99 3d  = 
    ld (hl),a                  ;6a9a 77  w 
    out (0feh),a               ;6a9b d3 fe  . . 
    ret                        ;6a9d c9  . 
l6a9eh:
    call v_sub_66e7h           ;6a9e cd 27 09  . ' . 
    call c,v_sub_6d79h         ;6aa1 dc b9 0f  . . . 
    call ROM_BreakKey          ;6aa4 cd 54 1f  . T . 
    jr c,l6a9eh                ;6aa7 38 f5  8 . 
l6aa9h:
v_l6175h:
    xor a                      ;6aa9 af  . 
    in a,(0feh)                ;6aaa db fe  . . 
    cpl                        ;6aac 2f  / 
    and 01fh                   ;6aad e6 1f  . . 
    jr nz,l6aa9h               ;6aaf 20 f8    . 
    ret                        ;6ab1 c9  . 
    call v_sub_60c3h           ;6ab2 cd 03 03  . . . 
    defb 0xc3, 0x22            ;6ab5
    defw l06ac2h+1             ;6ab7
l6ab9h:
    call v_sub_66e7h           ;6ab9 cd 27 09  . ' . 
    call nc,v_sub_6d79h        ;6abc d4 b9 0f  . . . 
        ld hl,(l0696eh+1)                                      ;6abf 2a 7b 02  * { . 
l06ac2h:
    ld de,00000h               ;6ac2 11 00 00  . . . 
    or a                       ;6ac5 b7  . 
    sbc hl,de                  ;6ac6 ed 52  . R 
    ret z                      ;6ac8 c8  . 
    call ROM_BreakKey          ;6ac9 cd 54 1f  . T . 
    jr nc,l6aa9h               ;6acc 30 db  0 . 
    jr l6ab9h                  ;6ace 18 e9  . . 
    ld hl,vr_l06e65h+1         ;6ad0 21 a6 10  ! . . 
    jr l6a77h                  ;6ad3 18 a2  . . 
    call v_sub_66a8h           ;6ad5 cd e8 08  . . . 
    jr l6addh                  ;6ad8 18 03  . . 
    call v_sub_669bh           ;6ada cd db 08  . . . 
l6addh:
    push hl                    ;6add e5  . 
    push de                    ;6ade d5  . 
    call v_sub_60c3h           ;6adf cd 03 03  . . . 
    exx                        ;6ae2 d9  . 
    xor 03ah                   ;6ae3 ee 3a  . : 
    jr nz,l6b0ah               ;6ae5 20 23    # 
    ld ix,v_l8ad1h             ;6ae7 dd 21 11 2d  . ! . - 
    ld (ix+000h),003h          ;6aeb dd 36 00 03  . 6 . . 
    ld de,v_l8ad2h             ;6aef 11 12 2d  . . - 
    inc hl                     ;6af2 23  # 
    call v_sub_76bfh           ;6af3 cd ff 18  . . . 
    pop de                     ;6af6 d1  . 
    pop hl                     ;6af7 e1  . 
    push hl                    ;6af8 e5  . 
    push de                    ;6af9 d5  . 
    or a                       ;6afa b7  . 
    sbc hl,de                  ;6afb ed 52  . R 
    inc hl                     ;6afd 23  # 
    ld (v_l8adeh),de           ;6afe ed 53 1e 2d  . S . - 
    ld (v_l8adch),hl           ;6b02 22 1c 2d  " . - 
    call v_sub_769ah           ;6b05 cd da 18  . . . 
    ld l,0ffh                  ;6b08 2e ff  . . 
l6b0ah:
    call v_sub_61dch           ;6b0a cd 1c 04  . . . 
    jp ROM_SaveControl_4c6     ;6b0d c3 c6 04  . . . 
v_sub_61dch:
    ld a,l                     ;6b10 7d  } 
    pop bc                     ;6b11 c1  . 
    pop de                     ;6b12 d1  . 
    pop hl                     ;6b13 e1  . 
    push bc                    ;6b14 c5  . 
    or a                       ;6b15 b7  . 
    sbc hl,de                  ;6b16 ed 52  . R 
    inc hl                     ;6b18 23  # 
    ex de,hl                   ;6b19 eb  . 
    push hl                    ;6b1a e5  . 
    pop ix                     ;6b1b dd e1  . . 
    ret                        ;6b1d c9  . 
    call v_sub_66a8h           ;6b1e cd e8 08  . . . 
    jr l6b26h                  ;6b21 18 03  . . 
    call v_sub_669bh           ;6b23 cd db 08  . . . 
l6b26h:
    call v_sub_66b3h           ;6b26 cd f3 08  . . . 
    call v_sub_60c3h           ;6b29 cd 03 03  . . . 
    exx                        ;6b2c d9  . 
l6b2dh:
    call v_sub_61dch           ;6b2d cd 1c 04  . . . 
    scf                        ;6b30 37  7 
    call v_sub_7bb1h           ;6b31 cd f1 1d  . . . 
    ret c                      ;6b34 d8  . 
    jp v_l66c4h                ;6b35 c3 04 09  . . . 
    call v_sub_6c47h           ;6b38 cd 87 0e  . . . 
    ld ix,inputBufferStart     ;6b3b dd 21 3f 2d  . ! ? - 
    ld de,00012h               ;6b3f 11 12 00  . . . 
    xor a                      ;6b42 af  . 
    scf                        ;6b43 37  7 
    ex af,af'                  ;6b44 08  . 
    ld a,00fh                  ;6b45 3e 0f  > . 
    out (0feh),a               ;6b47 d3 fe  . . 
    call ROM_LoadBytes_562     ;6b49 cd 62 05  . b . 
   ld ix,l093dch                                               ;6b4c dd 21 e8 2c  . ! . , 
    jr c,l6b5dh                ;6b50 38 0b  8 . 
    ld hl,(inputBufferStart)   ;6b52 2a 3f 2d  * ? - 
    ld h,000h                  ;6b55 26 00  & . 
    call v_sub_6b02h           ;6b57 cd 42 0d  . B . 
    jp v_sub_6c4ah             ;6b5a c3 8a 0e  . . . 
l6b5dh:
    ld hl,inputBufferStart+1   ;6b5d 21 40 2d  ! @ - 
    ld a,(hl)                  ;6b60 7e  ~ 
    add a,030h                 ;6b61 c6 30  . 0 
    ld (ix-003h),a             ;6b63 dd 77 fd  . w . 
    ld b,00ah                  ;6b66 06 0a  . . 
l6b68h:
    inc hl                     ;6b68 23  # 
    ld a,(hl)                  ;6b69 7e  ~ 
    cp 020h                    ;6b6a fe 20  .   
    jr nc,l6b70h               ;6b6c 30 02  0 . 
    ld a,03fh                  ;6b6e 3e 3f  > ? 
l6b70h:
    ld (ix+000h),a             ;6b70 dd 77 00  . w . 
    inc ix                     ;6b73 dd 23  . # 
    djnz l6b68h                ;6b75 10 f1  . . 
    inc ix                     ;6b77 dd 23  . # 
    ld hl,(v_l8b0dh)           ;6b79 2a 4d 2d  * M - 
    push hl                    ;6b7c e5  . 
    call v_sub_6afch           ;6b7d cd 3c 0d  . < . 
    ld hl,(v_l8b0bh)           ;6b80 2a 4b 2d  * K - 
    push hl                    ;6b83 e5  . 
    call v_sub_6afch           ;6b84 cd 3c 0d  . < . 
    ld hl,(v_l8b0fh)           ;6b87 2a 4f 2d  * O - 
    call v_sub_6afch           ;6b8a cd 3c 0d  . < . 
    call v_sub_6c4ah           ;6b8d cd 8a 0e  . . . 
    call v_sub_8608h           ;6b90 cd 48 28  . H ( 
    pop hl                     ;6b93 e1  . 
    pop de                     ;6b94 d1  . 
    cp 06ah                    ;6b95 fe 6a  . j 
    ret nz                     ;6b97 c0  . 
    add hl,de                  ;6b98 19  . 
    dec hl                     ;6b99 2b  + 
    call v_sub_66b3h           ;6b9a cd f3 08  . . . 
    ld l,0ffh                  ;6b9d 2e ff  . . 
    jr l6b2dh                  ;6b9f 18 8c  . . 
    ld b,008h                  ;6ba1 06 08  . . 
    ld hl,v_l6fa9h             ;6ba3 21 e9 11  ! . . 
    ld de,v_l6f9dh             ;6ba6 11 dd 11  . . . 
l6ba9h:
    ld c,(hl)                  ;6ba9 4e  N 
    ld a,(de)                  ;6baa 1a  . 
    ld (hl),a                  ;6bab 77  w 
    ld a,c                     ;6bac 79  y 
    ld (de),a                  ;6bad 12  . 
    inc hl                     ;6bae 23  # 
    inc de                     ;6baf 13  . 
    djnz l6ba9h                ;6bb0 10 f7  . . 
    ret                        ;6bb2 c9  . 
    ld hl,v_l7332h             ;6bb3 21 72 15  ! r . 
l6bb6h:
        ld (l06bd7h+1),hl                                      ;6bb6 22 e4 04  " . . 
    ld hl,v_l62b6h             ;6bb9 21 f6 04  ! . . 
    ld (vr_l07e38h+1),hl       ;6bbc 22 79 20  " y   
    call v_sub_66a8h           ;6bbf cd e8 08  . . . 
    push hl                    ;6bc2 e5  . 
    ld hl,v_l62b7h             ;6bc3 21 f7 04  ! . . 
        ld (l089d3h+1),hl                                      ;6bc6 22 e0 22  " . " 
    pop hl                     ;6bc9 e1  . 
    ex de,hl                   ;6bca eb  . 
l6bcbh:
    push de                    ;6bcb d5  . 
    call v_sub_6a0ah           ;6bcc cd 4a 0c  . J . 
    call v_sub_6c4ah           ;6bcf cd 8a 0e  . . . 
    push hl                    ;6bd2 e5  . 
    ld (l06bebh+1),sp                                          ;6bd3 ed 73 f8 04  . s . . 
l06bd7h:
    call 00052h                ;6bd7 cd 52 00  . R . 
    di                         ;6bda f3  . 
l6bdbh:
    pop hl                     ;6bdb e1  . 
    pop de                     ;6bdc d1  . 
    call v_sub_675dh           ;6bdd cd 9d 09  . . . 
    jp nc,v_l6175h             ;6be0 d2 b5 03  . . . 
    push hl                    ;6be3 e5  . 
    or a                       ;6be4 b7  . 
    sbc hl,de                  ;6be5 ed 52  . R 
    pop hl                     ;6be7 e1  . 
    jr c,l6bcbh                ;6be8 38 e1  8 . 
v_l62b6h:
    ret                        ;6bea c9  . 
v_l62b7h:
l06bebh:
    ld sp,00000h               ;6beb 31 00 00  1 . . 
    call v_sub_6675h           ;6bee cd b5 08  . . . 
    call v_sub_62dch           ;6bf1 cd 1c 05  . . . 
    jr l6bdbh                  ;6bf4 18 e5  . . 
    ld hl,v_l62b6h             ;6bf6 21 f6 04  ! . . 
    ld (vr_l07e38h+1),hl       ;6bf9 22 79 20  " y   
    xor a                      ;6bfc af  . 
    ld (v_l6aedh+1),a          ;6bfd 32 2e 0d  2 . . 
    ld hl,v_l62d1h             ;6c00 21 11 05  ! . . 
    jr l6bb6h                  ;6c03 18 b1  . . 
v_l62d1h:
    ld hl,v_l8aa5h             ;6c05 21 e5 2c  ! . , 
    ld de,inputBufferStart     ;6c08 11 3f 2d  . ? - 
    ld bc,00020h               ;6c0b 01 20 00  .   . 
    ldir                       ;6c0e ed b0  . . 
v_sub_62dch:
    call v_l82dbh              ;6c10 cd 1b 25  . . % 
    ld hl,inputBufferStart     ;6c13 21 3f 2d  ! ? - 
    call atHLorNextIfOne       ;6c16 cd ee 27  . . ' 
    ld d,000h                  ;6c19 16 00  . . 
    ld c,009h                  ;6c1b 0e 09  . . 
    jp v_l7e07h                ;6c1d c3 47 20  . G   
    cp 077h                    ;6c20 fe 77  . w 
    jr nz,l6c28h               ;6c22 20 04    . 
        ld (l06c46h+1),hl                                      ;6c24 22 53 05  " S . 
    ret                        ;6c27 c9  . 
l6c28h:
    push hl                    ;6c28 e5  . 
    ld (vr_l07934h+1),hl       ;6c29 22 75 1b  " u . 
    ld de,v_l632bh             ;6c2c 11 6b 05  . k . 
    push de                    ;6c2f d5  . 
    call v_sub_631ah           ;6c30 cd 5a 05  . Z . 
    ld hl,v_l5f74h             ;6c33 21 b4 01  ! . . 
        ld (l089d3h+1),hl                                      ;6c36 22 e0 22  " . " 
    ld a,0c3h                  ;6c39 3e c3  > . 
    call v_sub_7931h           ;6c3b cd 71 1b  . q . 
    ld bc,v_l67ach             ;6c3e 01 ec 09  . . . 
    call v_sub_7962h           ;6c41 cd a2 1b  . . . 
    ld c,0c3h                  ;6c44 0e c3  . . 
l06c46h:
    ld de,v_l67ach             ;6c46 11 ec 09  . . . 
    call l06c69h                                               ;6c49 cd 75 05  . u . 
    pop hl                     ;6c4c e1  . 
    pop de                     ;6c4d d1  . 
v_sub_631ah:
    ld bc,0003                 ;6c4e 01 03 00  . . . 
    ldir                       ;6c51 ed b0  . . 
    ld a,0ffh                  ;6c53 3e ff  > . 
v_sub_6321h:
    ld hl,v_l6f9bh             ;6c55 21 db 11  ! . . 
    add a,(hl)                 ;6c58 86  . 
    xor (hl)                   ;6c59 ae  . 
    and 07fh                   ;6c5a e6 7f  .  
    xor (hl)                   ;6c5c ae  . 
    ld (hl),a                  ;6c5d 77  w 
    ret                        ;6c5e c9  . 
v_l632bh:
    nop                        ;6c5f 00  . 
    nop                        ;6c60 00  . 
    nop                        ;6c61 00  . 
    call v_sub_60c3h           ;6c62 cd 03 03  . . . 
    call z,0eebh               ;6c65 cc eb 0e  . . . 
    defb 0xcd
l06c69h:
    call v_sub_68d4h           ;6c69
    ld (hl),c                  ;6c6c 71  q 
    inc hl                     ;6c6d 23  # 
    ld (hl),e                  ;6c6e 73  s 
    inc hl                     ;6c6f 23  # 
    ld (hl),d                  ;6c70 72  r 
    inc hl                     ;6c71 23  # 
    call v_sub_68c3h           ;6c72 cd 03 0b  . . . 
    jp v_l6762h                ;6c75 c3 a2 09  . . . 
    call v_sub_66a8h           ;6c78 cd e8 08  . . . 
    jr l6c80h                  ;6c7b 18 03  . . 
    call v_sub_669bh           ;6c7d cd db 08  . . . 
l6c80h:
    push hl                    ;6c80 e5  . 
    push de                    ;6c81 d5  . 
    call v_sub_60c3h           ;6c82 cd 03 03  . . . 
    ret c                      ;6c85 d8  . 
    pop de                     ;6c86 d1  . 
    pop bc                     ;6c87 c1  . 
    push de                    ;6c88 d5  . 
    push hl                    ;6c89 e5  . 
    or a                       ;6c8a b7  . 
    sbc hl,de                  ;6c8b ed 52  . R 
    add hl,bc                  ;6c8d 09  . 
    pop bc                     ;6c8e c1  . 
    call v_sub_66b9h           ;6c8f cd f9 08  . . . 
    ex de,hl                   ;6c92 eb  . 
    sbc hl,bc                  ;6c93 ed 42  . B 
    inc hl                     ;6c95 23  # 
    ld d,b                     ;6c96 50  P 
    ld e,c                     ;6c97 59  Y 
    ld b,h                     ;6c98 44  D 
    ld c,l                     ;6c99 4d  M 
    pop hl                     ;6c9a e1  . 
    jp v_l88ech                ;6c9b c3 2c 2b  . , + 
    call v_sub_66a8h           ;6c9e cd e8 08  . . . 
    jr l6ca6h                  ;6ca1 18 03  . . 
    call v_sub_669bh           ;6ca3 cd db 08  . . . 
l6ca6h:
    call v_sub_66b3h           ;6ca6 cd f3 08  . . . 
    call v_sub_60c3h           ;6ca9 cd 03 03  . . . 
    rst 10h                    ;6cac d7  . 
    ld a,l                     ;6cad 7d  } 
    pop de                     ;6cae d1  . 
    pop hl                     ;6caf e1  . 
    or a                       ;6cb0 b7  . 
    sbc hl,de                  ;6cb1 ed 52  . R 
    ld (de),a                  ;6cb3 12  . 
    ret z                      ;6cb4 c8  . 
    ld b,h                     ;6cb5 44  D 
    ld c,l                     ;6cb6 4d  M 
    ex de,hl                   ;6cb7 eb  . 
    ld d,h                     ;6cb8 54  T 
    ld e,l                     ;6cb9 5d  ] 
    inc de                     ;6cba 13  . 
    ldir                       ;6cbb ed b0  . . 
    ret                        ;6cbd c9  . 
    call v_sub_60c3h           ;6cbe cd 03 03  . . . 
    defb 0xc2, 0xcd            ;6cc1
    defw v_sub_6c47h                                           ;6cc3 
    defb 0xdd                                                  ;6cc4
    ld hl,v_l8aa5h             ;6cc6 21 e5 2c  ! . , 
    push hl                    ;6cc9 e5  . 
    call v_sub_8908h           ;6cca cd 48 2b  . H + 
    pop hl                     ;6ccd e1  . 
    inc ix                     ;6cce dd 23  . # 
    inc ix                     ;6cd0 dd 23  . # 
    push hl                    ;6cd2 e5  . 
    ld bc,00500h               ;6cd3 01 00 05  . . . 
l6cd6h:
    push hl                    ;6cd6 e5  . 
    ld l,(hl)                  ;6cd7 6e  n 
    ld h,000h                  ;6cd8 26 00  & . 
        ld a,(l0923ch+1)                                       ;6cda 3a 49 2b  : I + 
    push bc                    ;6cdd c5  . 
    or a                       ;6cde b7  . 
    jr z,l6cech                ;6cdf 28 0b  ( . 
    ld (ix+000h),023h          ;6ce1 dd 36 00 23  . 6 . # 
    inc ix                     ;6ce5 dd 23  . # 
    call v_sub_891eh           ;6ce7 cd 5e 2b  . ^ + 
    jr l6cefh                  ;6cea 18 03  . . 
l6cech:
    call v_sub_8932h           ;6cec cd 72 2b  . r + 
l6cefh:
    pop bc                     ;6cef c1  . 
    inc ix                     ;6cf0 dd 23  . # 
    pop hl                     ;6cf2 e1  . 
    inc hl                     ;6cf3 23  # 
    djnz l6cd6h                ;6cf4 10 e0  . . 
    pop hl                     ;6cf6 e1  . 
    ld b,005h                  ;6cf7 06 05  . . 
l6cf9h:
    call v_sub_63efh           ;6cf9 cd 2f 06  . / . 
    djnz l6cf9h                ;6cfc 10 fb  . . 
    call v_sub_5f64h           ;6cfe cd a4 01  . . . 
    jr $-60                    ;6d01 18 c2  . . 
    call v_sub_60c3h           ;6d03 cd 03 03  . . . 
    defb 0xc2, 0xcd            ;6d06
    defw v_sub_6c47h                                           ;6d08 
    defb 0xdd                                                  ;6d0a
    ld hl,v_l8aa5h             ;6d0b 21 e5 2c  ! . , 
    push hl                    ;6d0e e5  . 
    call v_sub_6afeh           ;6d0f cd 3e 0d  . > . 
    pop hl                     ;6d12 e1  . 
    inc ix                     ;6d13 dd 23  . # 
    inc ix                     ;6d15 dd 23  . # 
    ld b,019h                  ;6d17 06 19  . . 
l6d19h:
    call v_sub_63efh           ;6d19 cd 2f 06  . / . 
    djnz l6d19h                ;6d1c 10 fb  . . 
    call v_sub_5f64h           ;6d1e cd a4 01  . . . 
    jr $-23                    ;6d21 18 e7  . . 
v_sub_63efh:
    ld a,(hl)                  ;6d23 7e  ~ 
    and 07fh                   ;6d24 e6 7f  .  
    cp 020h                    ;6d26 fe 20  .   
    ld a,(hl)                  ;6d28 7e  ~ 
    inc hl                     ;6d29 23  # 
    jr nc,l6d30h               ;6d2a 30 04  0 . 
    and 080h                   ;6d2c e6 80  . . 
    or 02eh                    ;6d2e f6 2e  . . 
l6d30h:
    ld (ix+000h),a             ;6d30 dd 77 00  . w . 
    inc ix                     ;6d33 dd 23  . # 
    ret                        ;6d35 c9  . 
        ld hl,l06881h                                          ;6d36 21 8d 01  ! . . 
l6d39h:
    push hl                    ;6d39 e5  . 
    call v_sub_65c1h           ;6d3a cd 01 08  . . . 
    pop hl                     ;6d3d e1  . 
    jr nz,l6d96h               ;6d3e 20 56    V 
    ld a,(hl)                  ;6d40 7e  ~ 
    cp 00bh                    ;6d41 fe 0b  . . 
    ret nc                     ;6d43 d0  . 
    push hl                    ;6d44 e5  . 
    dec a                      ;6d45 3d  = 
    add a,a                    ;6d46 87  . 
    call v_sub_6bd8h           ;6d47 cd 18 0e  . . . 
    inc hl                     ;6d4a 23  # 
    push hl                    ;6d4b e5  . 
    call v_sub_60c3h           ;6d4c cd 03 03  . . . 
    call z,0e1ebh              ;6d4f cc eb e1  . . . 
    ld (hl),e                  ;6d52 73  s 
    inc hl                     ;6d53 23  # 
    ld (hl),d                  ;6d54 72  r 
    pop hl                     ;6d55 e1  . 
    inc (hl)                   ;6d56 34  4 
    jr l6d39h                  ;6d57 18 e0  . . 
    ld a,031h                  ;6d59 3e 31  > 1 
        ld (l07a67h),a                                         ;6d5b 32 73 13  2 s . 
    ld b,005h                  ;6d5e 06 05  . . 
    ld hl,v_l64ceh             ;6d60 21 0e 07  ! . . 
l6d63h:
    push bc                    ;6d63 c5  . 
    push hl                    ;6d64 e5  . 
    call v_sub_60c3h           ;6d65 cd 03 03  . . . 
    jp c,03aeeh                ;6d68 da ee 3a  . . : 
    ld c,000h                  ;6d6b 0e 00  . . 
    jr z,l6d70h                ;6d6d 28 01  ( . 
    dec c                      ;6d6f 0d  . 
l6d70h:
    ld b,l                     ;6d70 45  E 
        ld hl,l07a67h                                          ;6d71 21 73 13  ! s . 
    inc (hl)                   ;6d74 34  4 
    pop hl                     ;6d75 e1  . 
    ld (hl),b                  ;6d76 70  p 
    inc hl                     ;6d77 23  # 
    ld (hl),c                  ;6d78 71  q 
    inc hl                     ;6d79 23  # 
    pop bc                     ;6d7a c1  . 
    djnz l6d63h                ;6d7b 10 e6  . . 
    ld de,(l0696eh+1)                                          ;6d7d ed 5b 7b 02  . [ { . 
    inc de                     ;6d81 13  . 
l6d82h:
    push de                    ;6d82 d5  . 
    ld hl,v_l64ceh             ;6d83 21 0e 07  ! . . 
    ld b,005h                  ;6d86 06 05  . . 
l6d88h:
    ld a,(de)                  ;6d88 1a  . 
    inc de                     ;6d89 13  . 
    xor (hl)                   ;6d8a ae  . 
    inc hl                     ;6d8b 23  # 
    and (hl)                   ;6d8c a6  . 
    inc hl                     ;6d8d 23  # 
    jr nz,l6df1h               ;6d8e 20 61    a 
    djnz l6d88h                ;6d90 10 f6  . . 
    pop hl                     ;6d92 e1  . 
    jp v_l6012h                ;6d93 c3 52 02  . R . 
l6d96h:
    sub 02fh                   ;6d96 d6 2f  . / 
    cp (hl)                    ;6d98 be  . 
    jr nc,l6d39h               ;6d99 30 9e  0 . 
    dec a                      ;6d9b 3d  = 
    add a,a                    ;6d9c 87  . 
    ld b,a                     ;6d9d 47  G 
    ld a,015h                  ;6d9e 3e 15  > . 
    sub b                      ;6da0 90  . 
    ld c,a                     ;6da1 4f  O 
    ld a,b                     ;6da2 78  x 
    ld b,000h                  ;6da3 06 00  . . 
    push hl                    ;6da5 e5  . 
    call v_sub_6bd8h           ;6da6 cd 18 0e  . . . 
    inc hl                     ;6da9 23  # 
    ld d,h                     ;6daa 54  T 
    ld e,l                     ;6dab 5d  ] 
    inc hl                     ;6dac 23  # 
    inc hl                     ;6dad 23  # 
    ldir                       ;6dae ed b0  . . 
    pop hl                     ;6db0 e1  . 
    dec (hl)                   ;6db1 35  5 
    jr l6d39h                  ;6db2 18 85  . . 
v_l6480h:
    cp 031h                    ;6db4 fe 31  . 1 
    ret c                      ;6db6 d8  . 
    cp 036h                    ;6db7 fe 36  . 6 
    ret nc                     ;6db9 d0  . 
    sub 031h                   ;6dba d6 31  . 1 
    add a,a                    ;6dbc 87  . 
    ld hl,v_l64c4h             ;6dbd 21 04 07  ! . . 
    call v_sub_6bd8h           ;6dc0 cd 18 0e  . . . 
    ld e,(hl)                  ;6dc3 5e  ^ 
    inc hl                     ;6dc4 23  # 
    ld d,(hl)                  ;6dc5 56  V 
    ex de,hl                   ;6dc6 eb  . 
l6dc7h:
    push hl                    ;6dc7 e5  . 
    call v_sub_65bbh           ;6dc8 cd fb 07  . . . 
    pop hl                     ;6dcb e1  . 
    jr nz,l6e0ch               ;6dcc 20 3e    > 
    ld a,(hl)                  ;6dce 7e  ~ 
    cp 007h                    ;6dcf fe 07  . . 
    ret nc                     ;6dd1 d0  . 
    push hl                    ;6dd2 e5  . 
    dec a                      ;6dd3 3d  = 
    add a,a                    ;6dd4 87  . 
    add a,a                    ;6dd5 87  . 
    call v_sub_6bd8h           ;6dd6 cd 18 0e  . . . 
    inc hl                     ;6dd9 23  # 
    push hl                    ;6dda e5  . 
    call v_sub_66a8h           ;6ddb cd e8 08  . . . 
    push hl                    ;6dde e5  . 
    or a                       ;6ddf b7  . 
    sbc hl,de                  ;6de0 ed 52  . R 
    pop bc                     ;6de2 c1  . 
    pop hl                     ;6de3 e1  . 
    ld (hl),e                  ;6de4 73  s 
    inc hl                     ;6de5 23  # 
    ld (hl),d                  ;6de6 72  r 
    inc hl                     ;6de7 23  # 
    ld (hl),c                  ;6de8 71  q 
    inc hl                     ;6de9 23  # 
    ld (hl),b                  ;6dea 70  p 
    pop hl                     ;6deb e1  . 
    jr c,l6dc7h                ;6dec 38 d9  8 . 
    inc (hl)                   ;6dee 34  4 
    jr l6dc7h                  ;6def 18 d6  . . 
l6df1h:
    pop de                     ;6df1 d1  . 
    inc de                     ;6df2 13  . 
    ld a,d                     ;6df3 7a  z 
    or e                       ;6df4 b3  . 
    ret z                      ;6df5 c8  . 
    jr l6d82h                  ;6df6 18 8a  . . 
v_l64c4h:
    defw l067e6h               ;6df8
    defw v_l5ecch                                              ;6dfa
    defw l06833h                                               ;6dfc
    defw l0684dh               ;6dfe
    defw v_l5f33h              ;6e00
v_l64ceh:
    nop                        ;6e02 00  . 
    nop                        ;6e03 00  . 
    nop                        ;6e04 00  . 
    nop                        ;6e05 00  . 
    nop                        ;6e06 00  . 
    nop                        ;6e07 00  . 
    nop                        ;6e08 00  . 
    nop                        ;6e09 00  . 
    nop                        ;6e0a 00  . 
    nop                        ;6e0b 00  . 
l6e0ch:
    sub 02eh                   ;6e0c d6 2e  . . 
    cp (hl)                    ;6e0e be  . 
    jr nc,l6dc7h               ;6e0f 30 b6  0 . 
    dec a                      ;6e11 3d  = 
    add a,a                    ;6e12 87  . 
    add a,a                    ;6e13 87  . 
    ld b,a                     ;6e14 47  G 
    ld a,015h                  ;6e15 3e 15  > . 
    sub b                      ;6e17 90  . 
    ld c,a                     ;6e18 4f  O 
    ld a,b                     ;6e19 78  x 
    ld b,000h                  ;6e1a 06 00  . . 
    push hl                    ;6e1c e5  . 
    call v_sub_6bd8h           ;6e1d cd 18 0e  . . . 
    inc hl                     ;6e20 23  # 
    ld d,h                     ;6e21 54  T 
    ld e,l                     ;6e22 5d  ] 
    inc hl                     ;6e23 23  # 
    inc hl                     ;6e24 23  # 
    inc hl                     ;6e25 23  # 
    inc hl                     ;6e26 23  # 
    ldir                       ;6e27 ed b0  . . 
    pop hl                     ;6e29 e1  . 
    dec (hl)                   ;6e2a 35  5 
    jr l6dc7h                  ;6e2b 18 9a  . . 
v_l64f9h:
    call v_sub_611dh           ;6e2d cd 5d 03  . ] . 
    jr l6e45h                  ;6e30 18 13  . . 
v_l64feh:
    call v_sub_665ah           ;6e32 cd 9a 08  . . . 
    ld hl,001c5h               ;6e35 21 c5 01  ! . . 
    ld (inputBufferStart),hl   ;6e38 22 3f 2d  " ? - 
    ld hl,v_l64f9h             ;6e3b 21 39 07  ! 9 . 
        ld (l089d3h+1),hl                                      ;6e3e 22 e0 22  " . " 
    ld (l6e45h+1),sp                                           ;6e41 ed 73 52 07  . s R . 
l6e45h:
    ld sp,00000h               ;6e45 31 00 00  1 . . 
    call v_l82dbh              ;6e48 cd 1b 25  . . % 
    call v_sub_6675h           ;6e4b cd b5 08  . . . 
    ld b,018h                  ;6e4e 06 18  . . 
    ld ix,v_l5ddfh             ;6e50 dd 21 1f 00  . ! . . 
l6e54h:
    ld hl,inputBufferStart+1   ;6e54 21 40 2d  ! @ - 
    call atHLorNextIfOne       ;6e57 cd ee 27  . . ' 
    ld a,(ix+002h)             ;6e5a dd 7e 02  . ~ . 
    bit 7,a                    ;6e5d cb 7f  .  
    jr nz,l6e73h               ;6e5f 20 12    . 
    ld de,v_l8db4h             ;6e61 11 f4 2f  . . / 
    call v_sub_82c9h           ;6e64 cd 09 25  . . % 
    ld a,(de)                  ;6e67 1a  . 
    xor (hl)                   ;6e68 ae  . 
    and 05fh                   ;6e69 e6 5f  . _ 
    jr nz,l6e80h               ;6e6b 20 13    . 
    inc de                     ;6e6d 13  . 
    inc hl                     ;6e6e 23  # 
    call atHLorNextIfOne       ;6e6f cd ee 27  . . ' 
    ld a,(de)                  ;6e72 1a  . 
l6e73h:
    xor (hl)                   ;6e73 ae  . 
    and 05fh                   ;6e74 e6 5f  . _ 
    jr nz,l6e80h               ;6e76 20 08    . 
    inc hl                     ;6e78 23  # 
    call atHLorNextIfOne       ;6e79 cd ee 27  . . ' 
    cp 041h                    ;6e7c fe 41  . A 
    jr c,l6eafh                ;6e7e 38 2f  8 / 
l6e80h:
    ld de,00007h               ;6e80 11 07 00  . . . 
    add ix,de                  ;6e83 dd 19  . . 
    djnz l6e54h                ;6e85 10 cd  . . 
    jp badOperandError         ;6e87 c3 c1 22  . . " 
l6e8ah:
    call atHLorNextIfOne       ;6e8a cd ee 27  . . ' 
    or 020h                    ;6e8d f6 20  .   
    push hl                    ;6e8f e5  . 
    ld hl,v_l656bh             ;6e90 21 ab 07  ! . . 
    ld b,004h                  ;6e93 06 04  . . 
l6e95h:
    cp (hl)                    ;6e95 be  . 
    inc hl                     ;6e96 23  # 
    jr z,$+16                  ;6e97 28 0e  ( . 
    inc hl                     ;6e99 23  # 
    djnz l6e95h                ;6e9a 10 f9  . . 
    pop hl                     ;6e9c e1  . 
    jr l6eb7h                  ;6e9d 18 18  . . 
v_l656bh:
    ld (hl),e                  ;6e9f 73  s 
    add a,b                    ;6ea0 80  . 
    ld a,d                     ;6ea1 7a  z 
    ld b,b                     ;6ea2 40  @ 
    ld (hl),b                  ;6ea3 70  p 
    inc b                      ;6ea4 04  . 
    ld h,e                     ;6ea5 63  c 
    defb 0x01, 0x11            ;6ea6
    defw v_l6fafh              ;6ea8
    defb 0x1a, 0xae            ;6eaa
    ld (de),a                  ;6eac 12  . 
    pop hl                     ;6ead e1  . 
    ret                        ;6eae c9  . 
l6eafh:
    inc hl                     ;6eaf 23  # 
    ld a,(ix+002h)             ;6eb0 dd 7e 02  . ~ . 
    cp 0c6h                    ;6eb3 fe c6  . . 
    jr z,l6e8ah                ;6eb5 28 d3  ( . 
l6eb7h:
    push ix                    ;6eb7 dd e5  . . 
    call v_sub_71a0h           ;6eb9 cd e0 13  . . . 
    pop ix                     ;6ebc dd e1  . . 
    ex de,hl                   ;6ebe eb  . 
    ld l,(ix+005h)             ;6ebf dd 6e 05  . n . 
    ld h,(ix+006h)             ;6ec2 dd 66 06  . f . 
    ld a,(ix+002h)             ;6ec5 dd 7e 02  . ~ . 
    cp 0d8h                    ;6ec8 fe d8  . . 
    jr nc,l6ed2h               ;6eca 30 06  0 . 
    bit 3,(ix+003h)            ;6ecc dd cb 03 5e  . . . ^ 
    jr z,l6ed5h                ;6ed0 28 03  ( . 
l6ed2h:
    inc hl                     ;6ed2 23  # 
    ld (hl),d                  ;6ed3 72  r 
    dec hl                     ;6ed4 2b  + 
l6ed5h:
    ld (hl),e                  ;6ed5 73  s 
    ret                        ;6ed6 c9  . 
v_sub_65a3h:
    ld b,000h                  ;6ed7 06 00  . . 
    push hl                    ;6ed9 e5  . 
    ld hl,v_l6fd0h             ;6eda 21 10 12  ! . . 
    add hl,bc                  ;6edd 09  . 
    ld c,(hl)                  ;6ede 4e  N 
    add hl,bc                  ;6edf 09  . 
l6ee0h:
    ld a,(hl)                  ;6ee0 7e  ~ 
    cp 080h                    ;6ee1 fe 80  . . 
    res 7,a                    ;6ee3 cb bf  . . 
    ld (de),a                  ;6ee5 12  . 
    inc de                     ;6ee6 13  . 
    inc hl                     ;6ee7 23  # 
    jr c,l6ee0h                ;6ee8 38 f6  8 . 
    xor a                      ;6eea af  . 
    ld (de),a                  ;6eeb 12  . 
    inc de                     ;6eec 13  . 
    pop hl                     ;6eed e1  . 
    ret                        ;6eee c9  . 
v_sub_65bbh:
    ld a,037h                  ;6eef 3e 37  > 7 
    ld c,035h                  ;6ef1 0e 35  . 5 
    jr l6ef9h                  ;6ef3 18 04  . . 
v_sub_65c1h:
    ld a,0b7h                  ;6ef5 3e b7  > . 
    ld c,039h                  ;6ef7 0e 39  . 9 
l6ef9h:
    ld (v_l65deh),a            ;6ef9 32 1e 08  2 . . 
    ld (v_l65edh),a            ;6efc 32 2d 08  2 - . 
    ld (v_l6608h),a            ;6eff 32 48 08  2 H . 
    ld a,c                     ;6f02 79  y 
        ld (l06f50h+1),a                                       ;6f03 32 5d 08  2 ] . 
    call v_sub_6c47h           ;6f06 cd 87 0e  . . . 
    dec hl                     ;6f09 2b  + 
    ld c,(hl)                  ;6f0a 4e  N 
    inc hl                     ;6f0b 23  # 
    ld de,v_l8aa5h             ;6f0c 11 e5 2c  . . , 
    call v_sub_65a3h           ;6f0f cd e3 07  . . . 
v_l65deh:
    scf                        ;6f12 37  7 
    ld c,0d6h                  ;6f13 0e d6  . . 
    call c,v_sub_65a3h         ;6f15 dc e3 07  . . . 
    call v_sub_6c4ah           ;6f18 cd 8a 0e  . . . 
    ld a,02fh                  ;6f1b 3e 2f  > / 
    ld (v_l8aa5h),a            ;6f1d 32 e5 2c  2 . , 
    ld a,(hl)                  ;6f20 7e  ~ 
v_l65edh:
    scf                        ;6f21 37  7 
    jr nc,l6f29h               ;6f22 30 05  0 . 
    dec a                      ;6f24 3d  = 
    inc hl                     ;6f25 23  # 
    inc hl                     ;6f26 23  # 
    inc hl                     ;6f27 23  # 
    inc hl                     ;6f28 23  # 
l6f29h:
    inc hl                     ;6f29 23  # 
l6f2ah:
    ld ix,v_l8aa7h             ;6f2a dd 21 e7 2c  . ! . , 
    dec a                      ;6f2e 3d  = 
    jr z,l6f46h                ;6f2f 28 15  ( . 
    push af                    ;6f31 f5  . 
    inc (ix-002h)              ;6f32 dd 34 fe  . 4 . 
    ld (ix-001h),03ah          ;6f35 dd 36 ff 3a  . 6 . : 
    call v_sub_6622h           ;6f39 cd 62 08  . b . 
v_l6608h:
    scf                        ;6f3c 37  7 
    call c,v_sub_6622h         ;6f3d dc 62 08  . b . 
    call v_sub_6c4ah           ;6f40 cd 8a 0e  . . . 
    pop af                     ;6f43 f1  . 
    jr l6f2ah                  ;6f44 18 e4  . . 
l6f46h:
    call v_sub_8608h           ;6f46 cd 48 28  . H ( 
    cp 069h                    ;6f49 fe 69  . i 
    ret z                      ;6f4b c8  . 
    cp 030h                    ;6f4c fe 30  . 0 
    jr c,l6f53h                ;6f4e 38 03  8 . 
l06f50h:
    cp 035h                    ;6f50 fe 35  . 5 
    ret c                      ;6f52 d8  . 
l6f53h:
    jp v_l5f74h                ;6f53 c3 b4 01  . . . 
v_sub_6622h:
    ld e,(hl)                  ;6f56 5e  ^ 
    inc hl                     ;6f57 23  # 
    ld d,(hl)                  ;6f58 56  V 
    inc hl                     ;6f59 23  # 
    push hl                    ;6f5a e5  . 
    ex de,hl                   ;6f5b eb  . 
    push hl                    ;6f5c e5  . 
    call v_sub_6afeh           ;6f5d cd 3e 0d  . > . 
    pop de                     ;6f60 d1  . 
    call v_sub_6b14h           ;6f61 cd 54 0d  . T . 
    push ix                    ;6f64 dd e5  . . 
    ld b,00ah                  ;6f66 06 0a  . . 
l6f68h:
    ld (ix+000h),020h          ;6f68 dd 36 00 20  . 6 .   
    inc ix                     ;6f6c dd 23  . # 
    djnz l6f68h                ;6f6e 10 f8  . . 
    pop hl                     ;6f70 e1  . 
    jr c,l6f7eh                ;6f71 38 0b  8 . 
    push hl                    ;6f73 e5  . 
    call v_sub_8116h           ;6f74 cd 56 23  . V # 
    pop hl                     ;6f77 e1  . 
    inc hl                     ;6f78 23  # 
    ld b,009h                  ;6f79 06 09  . . 
    call v_sub_82d4h           ;6f7b cd 14 25  . . % 
l6f7eh:
    pop hl                     ;6f7e e1  . 
    ret                        ;6f7f c9  . 
v_sub_664ch:
    ld hl,00000h               ;6f80 21 00 00  ! . . 
    ld (v_l7953h+1),hl         ;6f83 22 94 1b  " . . 
    ld (vr_l07934h+1),hl       ;6f86 22 75 1b  " u . 
    ld ix,v_l8b22h             ;6f89 dd 21 62 2d  . ! b - 
    ret                        ;6f8d c9  . 
v_sub_665ah:
    ld hl,v_l8afeh             ;6f8e 21 3e 2d  ! > -               (flow (mon) from: 5f7b 60ce)  665a ld hl,8afe 
    ld (hl),080h               ;6f91 36 80  6 .                    (flow (mon) from: 665a)  665d ld (hl),80 
    inc hl                     ;6f93 23  #                         (flow (mon) from: 665d)  665f inc hl 
    ld (hl),001h               ;6f94 36 01  6 .                    (flow (mon) from: 665f)  6660 ld (hl),01 
    inc hl                     ;6f96 23  #                         (flow (mon) from: 6660)  6662 inc hl 
    ld bc,02000h               ;6f97 01 00 20  . .                 (flow (mon) from: 6662)  6663 ld bc,2000 
    jp atHLrepeatBTimesC       ;6f9a c3 21 25  . ! %               (flow (mon) from: 6663)  6666 jp 82e1 
v_sub_6669h:
    ld hl,v_l6fd0h             ;6f9d 21 10 12  ! . .               (flow (mon) from: 5f99 6675)  6669 ld hl,6fd0 
    ld (vr_l08750h+1),hl       ;6fa0 22 91 29  " . )               (flow (mon) from: 6669)  666c ld (8751),hl 
    call v_sub_6113h           ;6fa3 cd 53 03  . S .               (flow (mon) from: 666c)  666f call 6113 
    jp v_l85c7h                ;6fa6 c3 07 28  . . (               (flow (mon) from: 611c)  6672 jp 85c7 
l6fa9h:
v_sub_6675h:
    call v_sub_6669h           ;6fa9 cd a9 08  . . .               (flow (mon) from: 60e5)  6675 call 6669 
    call v_sub_8639h           ;6fac cd 79 28  . y (               (flow (mon) from: 85db)  6678 call 8639 
    cp 080h                    ;6faf fe 80  . . 
    jr nc,l6fa9h               ;6fb1 30 f6  0 . 
    cp 004h                    ;6fb3 fe 04  . . 
    jp z,v_l5f74h              ;6fb5 ca b4 01  . . . 
    cp 003h                    ;6fb8 fe 03  . . 
    jr nz,l6fc4h               ;6fba 20 08    . 
    ld hl,(vr_l07e3bh+1)       ;6fbc 2a 7c 20  * |   
    dec hl                     ;6fbf 2b  + 
    bit 7,(hl)                 ;6fc0 cb 7e  . ~ 
    jr nz,l6fa9h               ;6fc2 20 e5    . 
l6fc4h:
    call v_sub_7e3bh           ;6fc4 cd 7b 20  . {   
    jr nz,l6fa9h               ;6fc7 20 e0    . 
    call v_sub_6113h           ;6fc9 cd 53 03  . S . 
    jp v_sub_85f8h             ;6fcc c3 38 28  . 8 ( 
v_sub_669bh:
    call v_sub_60c3h           ;6fcf cd 03 03  . . . 
    jp nz,0cde5h               ;6fd2 c2 e5 cd  . . . 
    defw v_sub_60c3h           ;6fd5
    pop bc                     ;6fd7 c1  . 
    pop de                     ;6fd8 d1  . 
    add hl,de                  ;6fd9 19  . 
    dec hl                     ;6fda 2b  + 
    ret                        ;6fdb c9  . 
v_sub_66a8h:
    call v_sub_60c3h           ;6fdc cd 03 03  . . . 
    jp nz,0cde5h               ;6fdf c2 e5 cd  . . . 
    defw v_sub_60c3h           ;6fe2
    jp 0c9d1h                  ;6fe4 c3 d1 c9  . . . 
v_sub_66b3h:
    pop af                     ;6fe7 f1  . 
    push hl                    ;6fe8 e5  . 
    push de                    ;6fe9 d5  . 
    push af                    ;6fea f5  . 
    ld b,d                     ;6feb 42  B 
    ld c,e                     ;6fec 4b  K 
v_sub_66b9h:
    ex de,hl                   ;6fed eb  . 
    call v_sub_6bddh           ;6fee cd 1d 0e  . . . 
    ld hl,v_l66d8h             ;6ff1 21 18 09  ! . . 
    ld (vr_l080a2h+1),hl       ;6ff4 22 e3 22  " . " 
    ret nc                     ;6ff7 d0  . 
v_l66c4h:
    ld a,0cdh                  ;6ff8 3e cd  > . 
v_l66c6h:
    call v_sub_665ah           ;6ffa cd 9a 08  . . . 
    ld hl,inputBufferStart     ;6ffd 21 3f 2d  ! ? - 
    ld (hl),a                  ;7000 77  w 
    inc hl                     ;7001 23  # 
    ld (hl),0d0h               ;7002 36 d0  6 . 
    call v_sub_6669h           ;7004 cd a9 08  . . . 
l07007h:
    ld a,000h                  ;7007 3e 00  > . 
    ld (v_l6f9bh),a            ;7009 32 db 11  2 . . 
v_l66d8h:
    call v_sub_6d79h           ;700c cd b9 0f  . . . 
    call v_sub_8713h           ;700f cd 53 29  . S ) 
    call v_sub_8639h           ;7012 cd 79 28  . y ( 
    call v_l6175h              ;7015 cd b5 03  . . . 
    jp v_l5f74h                ;7018 c3 b4 01  . . . 
v_sub_66e7h:
        ld hl,(l0696eh+1)                                      ;701b 2a 7b 02  * { . 
v_l66eah:
    push hl                    ;701e e5  . 
    call v_sub_6b56h           ;701f cd 96 0d  . . . 
    ex af,af'                  ;7022 08  . 
    jp nz,v_l5f74h             ;7023 c2 b4 01  . . . 
        ld (l070feh+1),hl                                      ;7026 22 0b 0a  " . . 
        ld (l070dbh+1),hl                                      ;7029 22 e8 09  " . . 
    ld (l07326h+1),de                                          ;702c ed 53 33 0c  . S 3 . 
    push bc                    ;7030 c5  . 
    ld a,(v_l6f9bh)            ;7031 3a db 11  : . . 
        ld (l07007h+1),a                                       ;7034 32 14 09  2 . . 
    call v_sub_68e2h           ;7037 cd 22 0b  . " . 
    pop bc                     ;703a c1  . 
    pop de                     ;703b d1  . 
    push bc                    ;703c c5  . 
    call v_sub_68b4h           ;703d cd f4 0a  . . . 
    pop bc                     ;7040 c1  . 
    ld hl,v_l7066h             ;7041 21 a6 12  ! . . 
    call v_sub_6992h           ;7044 cd d2 0b  . . . 
    jr c,l7069h                ;7047 38 20  8   
    ld hl,v_l680bh             ;7049 21 4b 0a  ! K . 
    call v_sub_6bd8h           ;704c cd 18 0e  . . . 
    ld a,(hl)                  ;704f 7e  ~ 
    ld hl,v_l6813h             ;7050 21 53 0a  ! S . 
    call v_sub_6bd8h           ;7053 cd 18 0e  . . . 
    ld bc,v_l680ah             ;7056 01 4a 0a  . J . 
        ld a,(l070fbh+1)                                       ;7059 3a 08 0a  : . . 
    call v_sub_6a53h           ;705c cd 93 0c  . . . 
        ld (l070dbh+1),hl                                      ;705f 22 e8 09  " . . 
    ld (l07083h+1),bc                                          ;7062 ed 43 90 09  . C . . 
        ld (l070d8h+1),a                                       ;7066 32 e5 09  2 . . 
l7069h:
    call v_l6762h              ;7069 cd a2 09  . . . 
    ex af,af'                  ;706c 08  . 
    push af                    ;706d f5  . 
    exx                        ;706e d9  . 
    push hl                    ;706f e5  . 
    exx                        ;7070 d9  . 
    pop de                     ;7071 d1  . 
    ld hl,v_l5f33h             ;7072 21 73 01  ! s . 
    ld a,(v_l68f2h+1)          ;7075 3a 33 0b  : 3 . 
    or a                       ;7078 b7  . 
    call z,v_sub_6c20h         ;7079 cc 60 0e  . ` . 
    ld a,0ceh                  ;707c 3e ce  > . 
    jp c,v_l66c6h              ;707e da 06 09  . . . 
    pop af                     ;7081 f1  . 
    or a                       ;7082 b7  . 
l07083h:
    call nz,v_l680ah           ;7083 c4 4a 0a  . J . 
    exx                        ;7086 d9  . 
        ld (l0696eh+1),hl                                      ;7087 22 7b 02  " { . 
    ld hl,(v_l6fb3h)           ;708a 2a f3 11  * . . 
    add hl,de                  ;708d 19  . 
    ld (v_l6fb3h),hl           ;708e 22 f3 11  " . . 
v_sub_675dh:
    ld a,0bfh                  ;7091 3e bf  > . 
    jp 01f56h                  ;7093 c3 56 1f  . V . 
v_l6762h:
    ld a,0e9h                  ;7096 3e e9  > . 
    call v_sub_6321h           ;7098 cd 61 05  . a . 
    ld (l07114h+1),sp                                          ;709b ed 73 21 0a  . s ! . 
    ld sp,v_l6f9bh             ;709f 31 db 11  1 . . 
    pop hl                     ;70a2 e1  . 
    ld a,l                     ;70a3 7d  } 
    ld r,a                     ;70a4 ed 4f  . O 
    ld a,h                     ;70a6 7c  | 
    ld i,a                     ;70a7 ed 47  . G 
    pop bc                     ;70a9 c1  . 
    pop de                     ;70aa d1  . 
    pop hl                     ;70ab e1  . 
    pop af                     ;70ac f1  . 
    exx                        ;70ad d9  . 
    ex af,af'                  ;70ae 08  . 
    pop iy                     ;70af fd e1  . . 
    pop ix                     ;70b1 dd e1  . . 
    pop bc                     ;70b3 c1  . 
    pop de                     ;70b4 d1  . 
    pop hl                     ;70b5 e1  . 
    pop af                     ;70b6 f1  . 
    ld sp,(v_l6fb1h)           ;70b7 ed 7b f1 11  . { . . 
    jp v_l8b21h                ;70bb c3 61 2d  . a - 
v_l678ah:
    ld (v_l6fb1h),sp           ;70be ed 73 f1 11  . s . . 
    ld sp,v_l8b21h             ;70c2 31 61 2d  1 a - 
    push af                    ;70c5 f5  . 
    ld a,i                     ;70c6 ed 57  . W 
    push af                    ;70c8 f5  . 
    ld a,r                     ;70c9 ed 5f  . _ 
    di                         ;70cb f3  . 
    push af                    ;70cc f5  . 
    pop af                     ;70cd f1  . 
    pop af                     ;70ce f1  . 
    pop af                     ;70cf f1  . 
    ld sp,v_l6fb1h             ;70d0 31 f1 11  1 . . 
    push af                    ;70d3 f5  . 
    push hl                    ;70d4 e5  . 
    push de                    ;70d5 d5  . 
    ld a,001h                  ;70d6 3e 01  > . 
l070d8h:
    ld de,00000h               ;70d8 11 00 00  . . . 
l070dbh:
    ld hl,00000h               ;70db 21 00 00  ! . . 
    jr l7102h                  ;70de 18 22  . " 
v_l67ach:
    nop                        ;70e0 00  . 
v_l67adh:
    ld (v_l6fb1h),sp           ;70e1 ed 73 f1 11  . s . . 
    ld sp,v_l8b21h             ;70e5 31 61 2d  1 a - 
    push af                    ;70e8 f5  . 
    ld a,i                     ;70e9 ed 57  . W 
    push af                    ;70eb f5  . 
    ld a,r                     ;70ec ed 5f  . _ 
    di                         ;70ee f3  . 
    push af                    ;70ef f5  . 
    pop af                     ;70f0 f1  . 
    pop af                     ;70f1 f1  . 
    pop af                     ;70f2 f1  . 
    ld sp,v_l6fb1h             ;70f3 31 f1 11  1 . . 
    push af                    ;70f6 f5  . 
    push hl                    ;70f7 e5  . 
    push de                    ;70f8 d5  . 
    ld a,000h                  ;70f9 3e 00  > . 
l070fbh:
    ld de,00004h               ;70fb 11 04 00  . . . 
l070feh:
    ld hl,00000h               ;70fe 21 00 00  ! . . 
    nop                        ;7101 00  . 
l7102h:
    push bc                    ;7102 c5  . 
    push ix                    ;7103 dd e5  . . 
    push iy                    ;7105 fd e5  . . 
    exx                        ;7107 d9  . 
    ex af,af'                  ;7108 08  . 
    push af                    ;7109 f5  . 
    push hl                    ;710a e5  . 
    push de                    ;710b d5  . 
    push bc                    ;710c c5  . 
    ld a,i                     ;710d ed 57  . W 
    ld h,a                     ;710f 67  g 
    ld a,r                     ;7110 ed 5f  . _ 
    ld l,a                     ;7112 6f  o 
    push hl                    ;7113 e5  . 
l07114h:
    ld sp,00000h               ;7114 31 00 00  1 . . 
    ld a,0dbh                  ;7117 3e db  > . 
    call v_sub_6321h           ;7119 cd 61 05  . a . 
    ld hl,v_l8b1dh             ;711c 21 5d 2d  ! ] - 
    ld a,(hl)                  ;711f 7e  ~ 
    dec hl                     ;7120 2b  + 
    dec hl                     ;7121 2b  + 
    or (hl)                    ;7122 b6  . 
    and 004h                   ;7123 e6 04  . . 
    rrca                       ;7125 0f  . 
    rrca                       ;7126 0f  . 
    ld (vr_l06e65h+1),a        ;7127 32 a6 10  2 . . 
    ret                        ;712a c9  . 
v_l67f7h:
    ld hl,(v_l6fb1h)           ;712b 2a f1 11  * . . 
    ld de,(l070feh+1)                                          ;712e ed 5b 0b 0a  . [ . . 
    ld (hl),e                  ;7132 73  s 
    inc hl                     ;7133 23  # 
    ld (hl),d                  ;7134 72  r 
    ret                        ;7135 c9  . 
v_l6802h:
    ld hl,(v_l6fb1h)           ;7136 2a f1 11  * . . 
    inc hl                     ;7139 23  # 
    inc hl                     ;713a 23  # 
    ld (v_l6fb1h),hl           ;713b 22 f1 11  " . . 
v_l680ah:
    ret                        ;713e c9  . 
v_l680bh:
    nop                        ;713f 00  . 
    inc d                      ;7140 14  . 
    ld c,d                     ;7141 4a  J 
    ld h,a                     ;7142 67  g 
    ld a,h                     ;7143 7c  | 
    add a,c                    ;7144 81  . 
    add a,(hl)                 ;7145 86  . 
    sub l                      ;7146 95  . 
v_l6813h:
    ld hl,v_l8b23h             ;7147 21 63 2d  ! c - 
    ld e,(hl)                  ;714a 5e  ^ 
    ld (hl),003h               ;714b 36 03  6 . 
        ld hl,(l070feh+1)                                      ;714d 2a 0b 0a  * . . 
    ld d,000h                  ;7150 16 00  . . 
    bit 7,e                    ;7152 cb 7b  . { 
    jr z,l7157h                ;7154 28 01  ( . 
    dec d                      ;7156 15  . 
l7157h:
    add hl,de                  ;7157 19  . 
    add a,005h                 ;7158 c6 05  . . 
    ret                        ;715a c9  . 
l715bh:
    cp 00ah                    ;715b fe 0a  . . 
    jr z,l7186h                ;715d 28 27  ( ' 
    exx                        ;715f d9  . 
    ld de,(v_l8b23h)           ;7160 ed 5b 63 2d  . [ c - 
   ld (l7178h+1),sp                                            ;7164 ed 73 85 0a  . s . . 
        ld hl,l06881h                                          ;7168 21 8d 01  ! . . 
    ld b,(hl)                  ;716b 46  F 
    inc hl                     ;716c 23  # 
    ld sp,hl                   ;716d f9  . 
l716eh:
    djnz l7172h                ;716e 10 02  . . 
    jr l7178h                  ;7170 18 06  . . 
l7172h:
    pop hl                     ;7172 e1  . 
    or a                       ;7173 b7  . 
    sbc hl,de                  ;7174 ed 52  . R 
    jr nz,l716eh               ;7176 20 f6    . 
l7178h:
    ld sp,00000h               ;7178 31 00 00  1 . . 
    exx                        ;717b d9  . 
v_l6848h:
    nop                        ;717c 00  . 
    add a,008h                 ;717d c6 08  . . 
        ld hl,l070fbh+1                                        ;717f 21 08 0a  ! . . 
    inc (hl)                   ;7182 34  4 
    ld bc,v_l67f7h             ;7183 01 37 0a  . 7 . 
l7186h:
    ld hl,(v_l8b23h)           ;7186 2a 63 2d  * c - 
    ld de,v_l8b28h             ;7189 11 68 2d  . h - 
    ld (v_l8b23h),de           ;718c ed 53 63 2d  . S c - 
    ret                        ;7190 c9  . 
    ld hl,(v_l6fb1h)           ;7191 2a f1 11  * . . 
    ld e,(hl)                  ;7194 5e  ^ 
    inc hl                     ;7195 23  # 
    ld d,(hl)                  ;7196 56  V 
    ld hl,v_l8b22h             ;7197 21 62 2d  ! b - 
    ld a,(hl)                  ;719a 7e  ~ 
    add a,002h                 ;719b c6 02  . . 
    cp 0cbh                    ;719d fe cb  . . 
    jr nz,l71a3h               ;719f 20 02    . 
    sub 008h                   ;71a1 d6 08  . . 
l71a3h:
    ld (hl),a                  ;71a3 77  w 
    call v_sub_68ceh           ;71a4 cd 0e 0b  . . . 
    ld a,00ah                  ;71a7 3e 0a  > . 
    ld bc,v_l6802h             ;71a9 01 42 0a  . B . 
    jr l71beh                  ;71ac 18 10  . . 
    ld hl,v_l8b22h             ;71ae 21 62 2d  ! b - 
    ld a,(hl)                  ;71b1 7e  ~ 
    and 038h                   ;71b2 e6 38  . 8 
    ld (hl),0cdh               ;71b4 36 cd  6 . 
    inc hl                     ;71b6 23  # 
    ld (hl),a                  ;71b7 77  w 
    inc hl                     ;71b8 23  # 
    ld (hl),000h               ;71b9 36 00  6 . 
    inc hl                     ;71bb 23  # 
    ld a,003h                  ;71bc 3e 03  > . 
l71beh:
    call v_sub_68c3h           ;71be cd 03 0b  . . . 
    jr l715bh                  ;71c1 18 98  . . 
    ld hl,(vr_l06fach+1)       ;71c3 2a ed 11  * . . 
    jr l71d4h                  ;71c6 18 0c  . . 
    ld hl,(vr_l06fa6h+1)       ;71c8 2a e7 11  * . . 
    jr l71d0h                  ;71cb 18 03  . . 
    ld hl,(v_l6fa5h)           ;71cd 2a e5 11  * . . 
l71d0h:
    xor a                      ;71d0 af  . 
    ld (v_l8b23h),a            ;71d1 32 63 2d  2 c - 
l71d4h:
    xor a                      ;71d4 af  . 
    ld (v_l8b22h),a            ;71d5 32 62 2d  2 b - 
        ld (l070feh+1),hl                                      ;71d8 22 0b 0a  " . . 
    ret                        ;71db c9  . 
    ld bc,v_l6802h             ;71dc 01 42 0a  . B . 
    ld hl,(v_l6fb1h)           ;71df 2a f1 11  * . . 
    ld e,(hl)                  ;71e2 5e  ^ 
    inc hl                     ;71e3 23  # 
    ld d,(hl)                  ;71e4 56  V 
    ex de,hl                   ;71e5 eb  . 
    jr l71d0h                  ;71e6 18 e8  . . 
v_sub_68b4h:
        ld hl,(l070feh+1)                                      ;71e8 2a 0b 0a  * . . 
    and a                      ;71eb a7  . 
    sbc hl,de                  ;71ec ed 52  . R 
    ld b,h                     ;71ee 44  D 
    ld c,l                     ;71ef 4d  M 
    call v_sub_68d4h           ;71f0 cd 14 0b  . . . 
    ex de,hl                   ;71f3 eb  . 
    ldir                       ;71f4 ed b0  . . 
    ex de,hl                   ;71f6 eb  . 
v_sub_68c3h:
    ld de,v_l67adh             ;71f7 11 ed 09  . . . 
    call v_sub_68cch           ;71fa cd 0c 0b  . . . 
    ld de,v_l678ah             ;71fd 11 ca 09  . . . 
v_sub_68cch:
    ld (hl),0c3h               ;7200 36 c3  6 . 
v_sub_68ceh:
    inc hl                     ;7202 23  # 
    ld (hl),e                  ;7203 73  s 
    inc hl                     ;7204 23  # 
    ld (hl),d                  ;7205 72  r 
    inc hl                     ;7206 23  # 
    ret                        ;7207 c9  . 
v_sub_68d4h:
    ld hl,v_l8b21h             ;7208 21 61 2d  ! a - 
    ld a,(vr_l06e65h+1)        ;720b 3a a6 10  : . . 
    add a,a                    ;720e 87  . 
    add a,a                    ;720f 87  . 
    add a,a                    ;7210 87  . 
    add a,0f3h                 ;7211 c6 f3  . . 
    ld (hl),a                  ;7213 77  w 
    inc hl                     ;7214 23  # 
    ret                        ;7215 c9  . 
v_sub_68e2h:
    ld a,b                     ;7216 78  x 
    sub 076h                   ;7217 d6 76  . v 
    or c                       ;7219 b1  . 
    jr nz,l7226h               ;721a 20 0a    . 
    ld a,(vr_l06e65h+1)        ;721c 3a a6 10  : . . 
    or a                       ;721f b7  . 
    ret nz                     ;7220 c0  . 
    ld a,0cfh                  ;7221 3e cf  > . 
    jp v_l66c6h                ;7223 c3 06 09  . . . 
l7226h:
v_l68f2h:
    ld a,000h                  ;7226 3e 00  > . 
    or a                       ;7228 b7  . 
    ret nz                     ;7229 c0  . 
    ld a,c                     ;722a 79  y 
    and 040h                   ;722b e6 40  . @ 
    jr z,l7286h                ;722d 28 57  ( W 
    ld a,b                     ;722f 78  x 
    exx                        ;7230 d9  . 
    cp 0b0h                    ;7231 fe b0  . . 
    ld bc,(v_l6fa9h)           ;7233 ed 4b e9 11  . K . . 
    ld de,(v_l6fabh)           ;7237 ed 5b eb 11  . [ . . 
    ld hl,(vr_l06fach+1)       ;723b 2a ed 11  * . . 
    jr nz,l724ah               ;723e 20 0a    . 
    push hl                    ;7240 e5  . 
    add hl,bc                  ;7241 09  . 
    dec hl                     ;7242 2b  + 
    push hl                    ;7243 e5  . 
    ex de,hl                   ;7244 eb  . 
    push hl                    ;7245 e5  . 
    add hl,bc                  ;7246 09  . 
    dec hl                     ;7247 2b  + 
    jr l725ch                  ;7248 18 12  . . 
l724ah:
    cp 0b8h                    ;724a fe b8  . . 
    jr nz,l7285h               ;724c 20 37    7 
    push hl                    ;724e e5  . 
    and a                      ;724f a7  . 
    sbc hl,bc                  ;7250 ed 42  . B 
    inc hl                     ;7252 23  # 
    ex (sp),hl                 ;7253 e3  . 
    push hl                    ;7254 e5  . 
    ex de,hl                   ;7255 eb  . 
    push hl                    ;7256 e5  . 
    and a                      ;7257 a7  . 
    sbc hl,bc                  ;7258 ed 42  . B 
    inc hl                     ;725a 23  # 
    ex (sp),hl                 ;725b e3  . 
l725ch:
    push hl                    ;725c e5  . 
    ld h,b                     ;725d 60  ` 
    ld l,c                     ;725e 69  i 
    ld de,00015h               ;725f 11 15 00  . . . 
    call v_sub_7b3ah           ;7262 cd 7a 1d  . z . 
    dec hl                     ;7265 2b  + 
    dec hl                     ;7266 2b  + 
    dec hl                     ;7267 2b  + 
    dec hl                     ;7268 2b  + 
    dec hl                     ;7269 2b  + 
        ld (l070fbh+1),hl                                      ;726a 22 08 0a  " . . 
        ld hl,l0684dh                                          ;726d 21 59 01  ! Y . 
    pop de                     ;7270 d1  . 
    pop bc                     ;7271 c1  . 
    call v_sub_6be8h           ;7272 cd 28 0e  . ( . 
    jp c,v_l66c4h              ;7275 da 04 09  . . . 
        ld hl,l06833h                                          ;7278 21 3f 01  ! ? . 
    pop de                     ;727b d1  . 
    pop bc                     ;727c c1  . 
    call v_sub_6be8h           ;727d cd 28 0e  . ( . 
    jp c,v_l66c4h              ;7280 da 04 09  . . . 
    exx                        ;7283 d9  . 
    ret                        ;7284 c9  . 
l7285h:
    exx                        ;7285 d9  . 
l7286h:
    ld hl,v_l6fb9h             ;7286 21 f9 11  ! . . 
    push de                    ;7289 d5  . 
    call v_sub_6992h           ;728a cd d2 0b  . . . 
        ld hl,l06833h                                          ;728d 21 3f 01  ! ? . 
    call v_sub_6969h           ;7290 cd a9 0b  . . . 
    ld hl,v_l700bh             ;7293 21 4b 12  ! K . 
    pop de                     ;7296 d1  . 
    call v_sub_6992h           ;7297 cd d2 0b  . . . 
        ld hl,l0684dh                                          ;729a 21 59 01  ! Y . 
v_sub_6969h:
    ret c                      ;729d d8  . 
    push hl                    ;729e e5  . 
    push af                    ;729f f5  . 
    ld hl,v_l69c3h             ;72a0 21 03 0c  ! . . 
    call v_sub_6bd8h           ;72a3 cd 18 0e  . . . 
    ld a,(hl)                  ;72a6 7e  ~ 
    ld hl,v_l69cbh             ;72a7 21 0b 0c  ! . . 
    call v_sub_6bd8h           ;72aa cd 18 0e  . . . 
    call v_sub_6a53h           ;72ad cd 93 0c  . . . 
    pop af                     ;72b0 f1  . 
    ex (sp),hl                 ;72b1 e3  . 
    pop de                     ;72b2 d1  . 
    push af                    ;72b3 f5  . 
    push hl                    ;72b4 e5  . 
    call v_sub_6c20h           ;72b5 cd 60 0e  . ` . 
    pop hl                     ;72b8 e1  . 
    jp c,v_l66c4h              ;72b9 da 04 09  . . . 
    pop af                     ;72bc f1  . 
    ret z                      ;72bd c8  . 
    inc de                     ;72be 13  . 
    call v_sub_6c20h           ;72bf cd 60 0e  . ` . 
    jp c,v_l66c4h              ;72c2 da 04 09  . . . 
    ret                        ;72c5 c9  . 
v_sub_6992h:
    ld a,c                     ;72c6 79  y 
    and 0f0h                   ;72c7 e6 f0  . . 
    ld c,a                     ;72c9 4f  O 
    ld d,(hl)                  ;72ca 56  V 
    inc hl                     ;72cb 23  # 
l72cch:
    ld a,b                     ;72cc 78  x 
    and (hl)                   ;72cd a6  . 
    inc hl                     ;72ce 23  # 
    cp (hl)                    ;72cf be  . 
    inc hl                     ;72d0 23  # 
    jr z,l72d9h                ;72d1 28 06  ( . 
l72d3h:
    inc hl                     ;72d3 23  # 
    dec d                      ;72d4 15  . 
    jr nz,l72cch               ;72d5 20 f5    . 
    scf                        ;72d7 37  7 
    ret                        ;72d8 c9  . 
l72d9h:
    ld a,(hl)                  ;72d9 7e  ~ 
    and 0f0h                   ;72da e6 f0  . . 
    cp c                       ;72dc b9  . 
    jr nz,l72d3h               ;72dd 20 f4    . 
    ld a,(hl)                  ;72df 7e  ~ 
    and 00fh                   ;72e0 e6 0f  . . 
    bit 3,a                    ;72e2 cb 5f  . _ 
    res 3,a                    ;72e4 cb 9f  . . 
    ret                        ;72e6 c9  . 
    ld hl,v_l69c3h             ;72e7 21 03 0c  ! . . 
    call v_sub_6bd8h           ;72ea cd 18 0e  . . . 
    ld a,(hl)                  ;72ed 7e  ~ 
    ld hl,v_l69cbh             ;72ee 21 0b 0c  ! . . 
    call v_sub_6bd8h           ;72f1 cd 18 0e  . . . 
    call v_sub_6a53h           ;72f4 cd 93 0c  . . . 
v_l69c3h:
    nop                        ;72f7 00  . 
    inc b                      ;72f8 04  . 
    ex af,af'                  ;72f9 08  . 
    inc c                      ;72fa 0c  . 
    ld de,0211dh               ;72fb 11 1d 21  . . ! 
    daa                        ;72fe 27  ' 
v_l69cbh:
    ld hl,(v_l6fa9h)           ;72ff 2a e9 11  * . . 
    ret                        ;7302 c9  . 
    ld hl,(v_l6fabh)           ;7303 2a eb 11  * . . 
    ret                        ;7306 c9  . 
    ld hl,(vr_l06fach+1)       ;7307 2a ed 11  * . . 
    ret                        ;730a c9  . 
    ld hl,(vr_l06fa6h+1)       ;730b 2a e7 11  * . . 
    jr l7313h                  ;730e 18 03  . . 
    ld hl,(v_l6fa5h)           ;7310 2a e5 11  * . . 
l7313h:
    bit 7,e                    ;7313 cb 7b  . { 
    ld d,000h                  ;7315 16 00  . . 
    jr z,l731ah                ;7317 28 01  ( . 
    dec d                      ;7319 15  . 
l731ah:
    add hl,de                  ;731a 19  . 
    ret                        ;731b c9  . 
    ld hl,(v_l6fb1h)           ;731c 2a f1 11  * . . 
    ret                        ;731f c9  . 
    ld hl,(v_l6fb1h)           ;7320 2a f1 11  * . . 
    dec hl                     ;7323 2b  + 
    dec hl                     ;7324 2b  + 
    ret                        ;7325 c9  . 
l07326h:
    ld hl,00000h               ;7326 21 00 00  ! . . 
    ret                        ;7329 c9  . 
l732ah:
    ld e,(hl)                  ;732a 5e  ^ 
    inc hl                     ;732b 23  # 
    ld d,(hl)                  ;732c 56  V 
    ld bc,00937h               ;732d 01 37 09  . 7 . 
    jr l733bh                  ;7330 18 09  . . 
l7332h:
        ld hl,(l073bdh+1)                                      ;7332 2a ca 0c  * . . 
    ld d,000h                  ;7335 16 00  . . 
    ld e,(hl)                  ;7337 5e  ^ 
    ld bc,00637h               ;7338 01 37 06  . 7 . 
l733bh:
    inc hl                     ;733b 23  # 
    jr l736dh                  ;733c 18 2f  . / 
v_sub_6a0ah:
l0733eh:
    ld a,000h                  ;733e 3e 00  > .                    (flow (mon) from: 6e7e)  6a0a ld a,00 
    or a                       ;7340 b7  .                         (flow (mon) from: 6a0a)  6a0c or a 
    jr z,l7352h                ;7341 28 0f  ( .                    (flow (mon) from: 6a0c)  6a0d jr z,6a1e 
v_sub_6a0fh:
    ld a,020h                  ;7343 3e 20  >   
    ld b,a                     ;7345 47  G 
    ld de,v_l8aa5h             ;7346 11 e5 2c  . . , 
l7349h:
    ld (de),a                  ;7349 12  . 
    inc de                     ;734a 13  . 
    djnz l7349h                ;734b 10 fc  . . 
v_sub_6a19h:
    xor a                      ;734d af  .                         (flow (mon) from: 6e75)  6a19 xor a 
        ld (l0733eh+1),a                                       ;734e 32 4b 0c  2 K .                                                   (flow (mon) from: 6a19)  6a1a ld (6a0b),a                           (flow (mon) from: 6a19)  6a1a ld (6a0b),a 
    ret                        ;7351 c9  .                         (flow (mon) from: 6a1a)  6a1d ret 
l7352h:
        ld (l073bdh+1),hl                                      ;7352 22 ca 0c  " . .                                                   (flow (mon) from: 6a0d)  6a1e ld (6a8a),hl                          (flow (mon) from: 6a0d)  6a1e ld (6a8a),hl 
    ex de,hl                   ;7355 eb  .                         (flow (mon) from: 6a1e)  6a21 ex de,hl 
        ld hl,l067e6h                                          ;7356 21 f2 00  ! . .                                                   (flow (mon) from: 6a21)  6a22 ld hl,5eb2                            (flow (mon) from: 6a21)  6a22 ld hl,5eb2 
    call v_sub_6c20h           ;7359 cd 60 0e  . ` .               (flow (mon) from: 6a22)  6a25 call 6c20 
    jr c,l7332h                ;735c 38 d4  8 .                    (flow (mon) from: 6c46)  6a28 jr c,69fe 
    ld hl,v_l5ecch             ;735e 21 0c 01  ! . .               (flow (mon) from: 6a28)  6a2a ld hl,5ecc 
    call v_sub_6c20h           ;7361 cd 60 0e  . ` .               (flow (mon) from: 6a2a)  6a2d call 6c20 
    ex de,hl                   ;7364 eb  .                         (flow (mon) from: 6c46)  6a30 ex de,hl 
    jr c,l732ah                ;7365 38 c3  8 .                    (flow (mon) from: 6a30)  6a31 jr c,69f6 
    call v_sub_6b56h           ;7367 cd 96 0d  . . .               (flow (mon) from: 6a31)  6a33 call 6b56 
    ex af,af'                  ;736a 08  .                         (flow (mon) from: 6bda)  6a36 ex af,af' 
    jr nz,l7332h               ;736b 20 c5    .                    (flow (mon) from: 6a36)  6a37 jr nz,69fe 
l736dh:
    push hl                    ;736d e5  .                         (flow (mon) from: 6a37)  6a39 push hl 
    ld ix,v_l8b23h             ;736e dd 21 63 2d  . ! c -          (flow (mon) from: 6a39)  6a3a ld ix,8b23 
    ld (ix-001h),c             ;7372 dd 71 ff  . q .               (flow (mon) from: 6a3a)  6a3e ld (ix-01),c 
    ld (ix-002h),b             ;7375 dd 70 fe  . p .               (flow (mon) from: 6a3e)  6a41 ld (ix-02),b 
    ld a,c                     ;7378 79  y                         (flow (mon) from: 6a41)  6a44 ld a,c 
    and 007h                   ;7379 e6 07  . .                    (flow (mon) from: 6a44)  6a45 and 07 
    ld c,a                     ;737b 4f  O                         (flow (mon) from: 6a45)  6a47 ld c,a 
    ld b,000h                  ;737c 06 00  . .                    (flow (mon) from: 6a47)  6a48 ld b,00 
    ld hl,v_l6a54h             ;737e 21 94 0c  ! . .               (flow (mon) from: 6a48)  6a4a ld hl,6a54 
    add hl,bc                  ;7381 09  .                         (flow (mon) from: 6a4a)  6a4d add hl,bc 
    ld c,(hl)                  ;7382 4e  N                         (flow (mon) from: 6a4d)  6a4e ld c,(hl) 
    ld hl,v_l6a69h             ;7383 21 a9 0c  ! . .               (flow (mon) from: 6a4e)  6a4f ld hl,6a69 
    add hl,bc                  ;7386 09  .                         (flow (mon) from: 6a4f)  6a52 add hl,bc 
v_sub_6a53h:
    jp (hl)                    ;7387 e9  .                         (flow (mon) from: 6a52)  6a53 jp hl 
v_l6a54h:
    ld e,c                     ;7388 59  Y 
    ld d,e                     ;7389 53  S 
    daa                        ;738a 27  ' 
    add hl,de                  ;738b 19  . 
    nop                        ;738c 00  . 
    dec b                      ;738d 05  . 
    ld c,h                     ;738e 4c  L 
    daa                        ;738f 27  ' 
v_sub_6a5ch:
    bit 7,e                    ;7390 cb 7b  . { 
    ret z                      ;7392 c8  . 
    ld (ix+000h),02dh          ;7393 dd 36 00 2d  . 6 . - 
    inc ix                     ;7397 dd 23  . # 
    xor a                      ;7399 af  . 
    sub e                      ;739a 93  . 
    ld e,a                     ;739b 5f  _ 
    ret                        ;739c c9  . 
v_l6a69h:
    call v_sub_6a5ch           ;739d cd 9c 0c  . . . 
    jr l73f0h                  ;73a0 18 4e  . N 
    call v_sub_6a5ch           ;73a2 cd 9c 0c  . . . 
    ld h,000h                  ;73a5 26 00  & . 
    ld l,e                     ;73a7 6b  k 
    push de                    ;73a8 d5  . 
    call v_sub_6b02h           ;73a9 cd 42 0d  . B . 
    pop de                     ;73ac d1  . 
    ld e,d                     ;73ad 5a  Z 
    ld (ix+000h),01fh          ;73ae dd 36 00 1f  . 6 . . 
    inc ix                     ;73b2 dd 23  . # 
    jr l73f0h                  ;73b4 18 3a  . : 
    ld d,000h                  ;73b6 16 00  . . 
    bit 7,e                    ;73b8 cb 7b  . { 
    jr z,l73bdh                ;73ba 28 01  ( . 
    dec d                      ;73bc 15  . 
l73bdh:
l073bdh:
    ld hl,00001h               ;73bd 21 01 00  ! . . 
    inc hl                     ;73c0 23  # 
    inc hl                     ;73c1 23  # 
    add hl,de                  ;73c2 19  . 
    ex de,hl                   ;73c3 eb  . 
l073c4h:
    ld c,000h                  ;73c4 0e 00  . .                    (flow (mon) from: 6a53)  6a90 ld c,00 
    dec c                      ;73c6 0d  .                         (flow (mon) from: 6a90)  6a92 dec c 
    jr z,l73f2h                ;73c7 28 29  ( )                    (flow (mon) from: 6a92)  6a93 jr z,6abe 
    call v_sub_6b14h           ;73c9 cd 54 0d  . T .               (flow (mon) from: 6a93)  6a95 call 6b14 
    jr c,l73d3h                ;73cc 38 05  8 .                    (flow (mon) from: 6b55)  6a98 jr c,6a9f 
    call v_sub_6b07h           ;73ce cd 47 0d  . G . 
    jr l73f6h                  ;73d1 18 23  . # 
l73d3h:
    dec c                      ;73d3 0d  .                         (flow (mon) from: 6a98)  6a9f dec c 
    jr z,l73f2h                ;73d4 28 1c  ( .                    (flow (mon) from: 6a9f)  6aa0 jr z,6abe 
    dec de                     ;73d6 1b  .                         (flow (mon) from: 6aa0)  6aa2 dec de 
    call v_sub_6b14h           ;73d7 cd 54 0d  . T .               (flow (mon) from: 6aa2)  6aa3 call 6b14 
    inc de                     ;73da 13  .                         (flow (mon) from: 6b55)  6aa6 inc de 
    jr c,l73f2h                ;73db 38 15  8 .                    (flow (mon) from: 6aa6)  6aa7 jr c,6abe 
    dec de                     ;73dd 1b  . 
    call v_sub_6b07h           ;73de cd 47 0d  . G . 
    ld de,02b31h               ;73e1 11 31 2b  . 1 + 
    call v_sub_6b09h           ;73e4 cd 49 0d  . I . 
    jr l73f6h                  ;73e7 18 0d  . . 
        ld hl,(l073bdh+1)                                      ;73e9 2a ca 0c  * . . 
    ld a,(hl)                  ;73ec 7e  ~ 
    and 038h                   ;73ed e6 38  . 8 
    ld e,a                     ;73ef 5f  _ 
l73f0h:
    ld d,000h                  ;73f0 16 00  . . 
l73f2h:
    ex de,hl                   ;73f2 eb  .                         (flow (mon) from: 6aa7)  6abe ex de,hl 
    call v_sub_6b02h           ;73f3 cd 42 0d  . B .               (flow (mon) from: 6abe)  6abf call 6b02 
l73f6h:
    ld (ix+000h),0c0h          ;73f6 dd 36 00 c0  . 6 . .          (flow (mon) from: 6a53 8961)  6ac2 ld (ix+00),c0 
    ld ix,v_l8b21h             ;73fa dd 21 61 2d  . ! a -          (flow (mon) from: 6ac2)  6ac6 ld ix,8b21 
    call v_sub_8135h           ;73fe cd 75 23  . u #               (flow (mon) from: 6ac6)  6aca call 8135 
    ld ix,v_l8aa5h             ;7401 dd 21 e5 2c  . ! . ,          (flow (mon) from: 81b6 81dd 822d)  6acd ld ix,8aa5 
    ld de,(l073bdh+1)                                          ;7405 ed 5b ca 0c  . [ . .                                              (flow (mon) from: 6acd)  6ad1 ld de,(6a8a) 
        ld a,(l073c4h+1)                                       ;7409 3a d1 0c  : . .                                                   (flow (mon) from: 6ad1)  6ad5 ld a,(6a91)                           (flow (mon) from: 6ad1)  6ad5 ld a,(6a91) 
    dec a                      ;740c 3d  =                         (flow (mon) from: 6ad5)  6ad8 dec a 
    jr z,l7421h                ;740d 28 12  ( .                    (flow (mon) from: 6ad8)  6ad9 jr z,6aed 
    call v_sub_6b14h           ;740f cd 54 0d  . T .               (flow (mon) from: 6ad9)  6adb call 6b14 
    jr c,l7421h                ;7412 38 0d  8 .                    (flow (mon) from: 6b55)  6ade jr c,6aed 
    call v_sub_8116h           ;7414 cd 56 23  . V # 
    ld b,009h                  ;7417 06 09  . . 
    push ix                    ;7419 dd e5  . . 
    pop hl                     ;741b e1  . 
    call v_sub_82d4h           ;741c cd 14 25  . . % 
    jr l742eh                  ;741f 18 0d  . . 
l7421h:
v_l6aedh:
    ld a,001h                  ;7421 3e 01  > .                    (flow (mon) from: 6ade)  6aed ld a,01 
    dec a                      ;7423 3d  =                         (flow (mon) from: 6aed)  6aef dec a 
    jr nz,l742eh               ;7424 20 08    .                    (flow (mon) from: 6aef)  6af0 jr nz,6afa 
    ex de,hl                   ;7426 eb  .                         (flow (mon) from: 6af0)  6af2 ex de,hl 
    call v_sub_6afeh           ;7427 cd 3e 0d  . > .               (flow (mon) from: 6af2)  6af3 call 6afe 
    ld (ix+000h),020h          ;742a dd 36 00 20  . 6 .            (flow (mon) from: 8961)  6af6 ld (ix+00),20 
l742eh:
    pop hl                     ;742e e1  .                         (flow (mon) from: 6af6)  6afa pop hl 
    ret                        ;742f c9  .                         (flow (mon) from: 6afa)  6afb ret 
v_sub_6afch:
    inc ix                     ;7430 dd 23  . # 
v_sub_6afeh:
    ld c,000h                  ;7432 0e 00  . .                    (flow (mon) from: 6af3)  6afe ld c,00 
    jr l7438h                  ;7434 18 02  . .                    (flow (mon) from: 6afe)  6b00 jr 6b04 
v_sub_6b02h:
    ld c,001h                  ;7436 0e 01  . .                    (flow (mon) from: 6abf)  6b02 ld c,01 
l7438h:
    jp v_sub_8908h             ;7438 c3 48 2b  . H +               (flow (mon) from: 6b00 6b02)  6b04 jp 8908 
v_sub_6b07h:
    set 7,d                    ;743b cb fa  . . 
v_sub_6b09h:
    ld (ix+000h),d             ;743d dd 72 00  . r . 
    inc ix                     ;7440 dd 23  . # 
    ld (ix+000h),e             ;7442 dd 73 00  . s . 
    inc ix                     ;7445 dd 23  . # 
    ret                        ;7447 c9  . 
v_sub_6b14h:
    push bc                    ;7448 c5  .                         (flow (mon) from: 6a95 6aa3 6adb)  6b14 push bc 
    exx                        ;7449 d9  .                         (flow (mon) from: 6b14)  6b15 exx 
    ld de,00000h               ;744a 11 00 00  . . .               (flow (mon) from: 6b15)  6b16 ld de,0000 
    ld hl,(vr_l087d6h+1)       ;744d 2a 17 2a  * . *               (flow (mon) from: 6b16)  6b19 ld hl,(87d7) 
    ld c,(hl)                  ;7450 4e  N                         (flow (mon) from: 6b19)  6b1c ld c,(hl) 
    inc hl                     ;7451 23  #                         (flow (mon) from: 6b1c)  6b1d inc hl 
    ld b,(hl)                  ;7452 46  F                         (flow (mon) from: 6b1d)  6b1e ld b,(hl) 
    inc hl                     ;7453 23  #                         (flow (mon) from: 6b1e)  6b1f inc hl 
    push hl                    ;7454 e5  .                         (flow (mon) from: 6b1f)  6b20 push hl 
    add hl,bc                  ;7455 09  .                         (flow (mon) from: 6b20)  6b21 add hl,bc 
    add hl,bc                  ;7456 09  .                         (flow (mon) from: 6b21)  6b22 add hl,bc 
        ld (l07474h+1),hl                                      ;7457 22 81 0d  " . .                                                   (flow (mon) from: 6b22)  6b23 ld (6b41),hl                          (flow (mon) from: 6b22)  6b23 ld (6b41),hl 
    exx                        ;745a d9  .                         (flow (mon) from: 6b23)  6b26 exx 
    pop hl                     ;745b e1  .                         (flow (mon) from: 6b26)  6b27 pop hl 
    exx                        ;745c d9  .                         (flow (mon) from: 6b27)  6b28 exx 
l745dh:
    ld a,b                     ;745d 78  x                         (flow (mon) from: 6b28)  6b29 ld a,b 
    or c                       ;745e b1  .                         (flow (mon) from: 6b29)  6b2a or c 
    scf                        ;745f 37  7                         (flow (mon) from: 6b2a)  6b2b scf 
    jr z,l7487h                ;7460 28 25  ( %                    (flow (mon) from: 6b2b)  6b2c jr z,6b53 
    exx                        ;7462 d9  . 
    inc hl                     ;7463 23  # 
    ld a,(hl)                  ;7464 7e  ~ 
    ld c,a                     ;7465 4f  O 
    and 0c0h                   ;7466 e6 c0  . . 
    ld a,c                     ;7468 79  y 
    jr nz,l746eh               ;7469 20 03    . 
    inc a                      ;746b 3c  < 
    jr l7480h                  ;746c 18 12  . . 
l746eh:
    push hl                    ;746e e5  . 
    dec hl                     ;746f 2b  + 
    ld l,(hl)                  ;7470 6e  n 
    and 03fh                   ;7471 e6 3f  . ? 
    ld h,a                     ;7473 67  g 
l07474h:
    ld bc,09c38h               ;7474 01 38 9c  . 8 .
    add hl,bc                  ;7477 09  . 
    ld a,(hl)                  ;7478 7e  ~ 
    inc hl                     ;7479 23  # 
    ld h,(hl)                  ;747a 66  f 
    ld l,a                     ;747b 6f  o 
    xor a                      ;747c af  . 
    sbc hl,de                  ;747d ed 52  . R 
    pop hl                     ;747f e1  . 
l7480h:
    inc hl                     ;7480 23  # 
    exx                        ;7481 d9  . 
    dec bc                     ;7482 0b  . 
    inc de                     ;7483 13  . 
    jr nz,l745dh               ;7484 20 d7    . 
    exx                        ;7486 d9  . 
l7487h:
    exx                        ;7487 d9  .                         (flow (mon) from: 6b2c)  6b53 exx 
    pop bc                     ;7488 c1  .                         (flow (mon) from: 6b53)  6b54 pop bc 
    ret                        ;7489 c9  .                         (flow (mon) from: 6b54)  6b55 ret 
v_sub_6b56h:
    ld a,(hl)                  ;748a 7e  ~                         (flow (mon) from: 6043 6a33)  6b56 ld a,(hl) 
    and 0c7h                   ;748b e6 c7  . .                    (flow (mon) from: 6b56)  6b57 and c7 
    cp 0c7h                    ;748d fe c7  . .                    (flow (mon) from: 6b57)  6b59 cp c7 
    ld b,a                     ;748f 47  G                         (flow (mon) from: 6b59)  6b5b ld b,a 
    ld c,000h                  ;7490 0e 00  . .                    (flow (mon) from: 6b5b)  6b5c ld c,00 
    jr z,l74c2h                ;7492 28 2e  ( .                    (flow (mon) from: 6b5c)  6b5e jr z,6b8e 
    ld a,(hl)                  ;7494 7e  ~                         (flow (mon) from: 6b5e)  6b60 ld a,(hl) 
    ld c,040h                  ;7495 0e 40  . @                    (flow (mon) from: 6b60)  6b61 ld c,40 
    cp 0edh                    ;7497 fe ed  . .                    (flow (mon) from: 6b61)  6b63 cp ed 
    jr z,l74c0h                ;7499 28 25  ( %                    (flow (mon) from: 6b63)  6b65 jr z,6b8c 
    ld c,000h                  ;749b 0e 00  . .                    (flow (mon) from: 6b65)  6b67 ld c,00 
    cp 0ddh                    ;749d fe dd  . .                    (flow (mon) from: 6b67)  6b69 cp dd 
    jr nz,l74a5h               ;749f 20 04    .                    (flow (mon) from: 6b69)  6b6b jr nz,6b71 
    set 5,c                    ;74a1 cb e9  . . 
    jr l74abh                  ;74a3 18 06  . . 
l74a5h:
    cp 0fdh                    ;74a5 fe fd  . .                    (flow (mon) from: 6b6b)  6b71 cp fd 
    jr nz,l74bah               ;74a7 20 11    .                    (flow (mon) from: 6b71)  6b73 jr nz,6b86 
    set 4,c                    ;74a9 cb e1  . . 
l74abh:
    inc hl                     ;74ab 23  # 
    ld a,(hl)                  ;74ac 7e  ~ 
    cp 0cbh                    ;74ad fe cb  . . 
    jr nz,l74c1h               ;74af 20 10    . 
    set 7,c                    ;74b1 cb f9  . . 
    inc hl                     ;74b3 23  # 
    ld e,(hl)                  ;74b4 5e  ^ 
    inc hl                     ;74b5 23  # 
    ld b,(hl)                  ;74b6 46  F 
    push hl                    ;74b7 e5  . 
    jr l74c7h                  ;74b8 18 0d  . . 
l74bah:
    cp 0cbh                    ;74ba fe cb  . .                    (flow (mon) from: 6b73)  6b86 cp cb 
    jr nz,l74c1h               ;74bc 20 03    .                    (flow (mon) from: 6b86)  6b88 jr nz,6b8d 
    set 7,c                    ;74be cb f9  . . 
l74c0h:
    inc hl                     ;74c0 23  # 
l74c1h:
    ld b,(hl)                  ;74c1 46  F                         (flow (mon) from: 6b88)  6b8d ld b,(hl) 
l74c2h:
    inc hl                     ;74c2 23  #                         (flow (mon) from: 6b8d)  6b8e inc hl 
    push hl                    ;74c3 e5  .                         (flow (mon) from: 6b8e)  6b8f push hl 
    ld e,(hl)                  ;74c4 5e  ^                         (flow (mon) from: 6b8f)  6b90 ld e,(hl) 
    inc hl                     ;74c5 23  #                         (flow (mon) from: 6b90)  6b91 inc hl 
    ld d,(hl)                  ;74c6 56  V                         (flow (mon) from: 6b91)  6b92 ld d,(hl) 
l74c7h:
    push de                    ;74c7 d5  .                         (flow (mon) from: 6b92)  6b93 push de 
    ld a,c                     ;74c8 79  y                         (flow (mon) from: 6b93)  6b94 ld a,c 
    cp 03fh                    ;74c9 fe 3f  . ?                    (flow (mon) from: 6b94)  6b95 cp 3f 
    jr nc,l74e0h               ;74cb 30 13  0 .                    (flow (mon) from: 6b95)  6b97 jr nc,6bac 
    cp 010h                    ;74cd fe 10  . .                    (flow (mon) from: 6b97)  6b99 cp 10 
    ld a,b                     ;74cf 78  x                         (flow (mon) from: 6b99)  6b9b ld a,b 
    jr nc,l74deh               ;74d0 30 0c  0 .                    (flow (mon) from: 6b9b)  6b9c jr nc,6baa 
    cp 018h                    ;74d2 fe 18  . .                    (flow (mon) from: 6b9c)  6b9e cp 18 
    jr z,l74e4h                ;74d4 28 0e  ( .                    (flow (mon) from: 6b9e)  6ba0 jr z,6bb0 
    cp 0c9h                    ;74d6 fe c9  . .                    (flow (mon) from: 6ba0)  6ba2 cp c9 
    jr z,l74e4h                ;74d8 28 0a  ( .                    (flow (mon) from: 6ba2)  6ba4 jr z,6bb0 
    cp 0c3h                    ;74da fe c3  . .                    (flow (mon) from: 6ba4)  6ba6 cp c3 
    jr z,l74e4h                ;74dc 28 06  ( .                    (flow (mon) from: 6ba6)  6ba8 jr z,6bb0 
l74deh:
    cp 0e9h                    ;74de fe e9  . .                    (flow (mon) from: 6ba8)  6baa cp e9 
l74e0h:
    ld a,000h                  ;74e0 3e 00  > .                    (flow (mon) from: 6baa)  6bac ld a,00 
    jr nz,l74e6h               ;74e2 20 02    .                    (flow (mon) from: 6bac)  6bae jr nz,6bb2 
l74e4h:
    ld a,001h                  ;74e4 3e 01  > . 
l74e6h:
        ld (l0733eh+1),a                                       ;74e6 32 4b 0c  2 K .                                                   (flow (mon) from: 6bae)  6bb2 ld (6a0b),a                           (flow (mon) from: 6bae)  6bb2 ld (6a0b),a 
    push bc                    ;74e9 c5  .                         (flow (mon) from: 6bb2)  6bb5 push bc 
    call v_sub_831ch           ;74ea cd 5c 25  . \ %               (flow (mon) from: 6bb5)  6bb6 call 831c 
    ex af,af'                  ;74ed 08  .                         (flow (mon) from: 8376)  6bb9 ex af,af' 
    pop bc                     ;74ee c1  .                         (flow (mon) from: 6bb9)  6bba pop bc 
    ld a,(hl)                  ;74ef 7e  ~                         (flow (mon) from: 6bba)  6bbb ld a,(hl) 
    and 01fh                   ;74f0 e6 1f  . .                    (flow (mon) from: 6bbb)  6bbc and 1f 
        ld (l070fbh+1),a                                       ;74f2 32 08 0a  2 . .                                                   (flow (mon) from: 6bbc)  6bbe ld (67c8),a                           (flow (mon) from: 6bbc)  6bbe ld (67c8),a 
    xor a                      ;74f5 af  .                         (flow (mon) from: 6bbe)  6bc1 xor a 
        ld (l070fbh+2),a                                       ;74f6 32 09 0a  2 . .                                                   (flow (mon) from: 6bc1)  6bc2 ld (67c9),a                           (flow (mon) from: 6bc1)  6bc2 ld (67c9),a 
    dec hl                     ;74f9 2b  +                         (flow (mon) from: 6bc2)  6bc5 dec hl 
    dec hl                     ;74fa 2b  +                         (flow (mon) from: 6bc5)  6bc6 dec hl 
    dec hl                     ;74fb 2b  +                         (flow (mon) from: 6bc6)  6bc7 dec hl 
    ld a,(hl)                  ;74fc 7e  ~                         (flow (mon) from: 6bc7)  6bc8 ld a,(hl) 
    and 007h                   ;74fd e6 07  . .                    (flow (mon) from: 6bc8)  6bc9 and 07 
    or c                       ;74ff b1  .                         (flow (mon) from: 6bc9)  6bcb or c 
    ld c,a                     ;7500 4f  O                         (flow (mon) from: 6bcb)  6bcc ld c,a 
    pop de                     ;7501 d1  .                         (flow (mon) from: 6bcc)  6bcd pop de 
    and 007h                   ;7502 e6 07  . .                    (flow (mon) from: 6bcd)  6bce and 07 
    ld hl,v_l79fah             ;7504 21 3a 1c  ! : .               (flow (mon) from: 6bce)  6bd0 ld hl,79fa 
    call v_sub_6bd8h           ;7507 cd 18 0e  . . .               (flow (mon) from: 6bd0)  6bd3 call 6bd8 
    ld a,(hl)                  ;750a 7e  ~                         (flow (mon) from: 6bda)  6bd6 ld a,(hl) 
    pop hl                     ;750b e1  .                         (flow (mon) from: 6bd6)  6bd7 pop hl 
v_sub_6bd8h:
    add a,l                    ;750c 85  .                         (flow (mon) from: 5ff7 6bd3 6bd7)  6bd8 add a,l 
    ld l,a                     ;750d 6f  o                         (flow (mon) from: 6bd8)  6bd9 ld l,a 
    ret nc                     ;750e d0  .                         (flow (mon) from: 6bd9)  6bda ret nc 
    inc h                      ;750f 24  $ 
    ret                        ;7510 c9  . 
v_sub_6bddh:
   ld (l7550h+1),sp                                            ;7511 ed 73 5d 0e  . s ] . 
    ld a,002h                  ;7515 3e 02  > . 
        ld sp,l0684eh                                          ;7517 31 5a 01  1 Z . 
    jr l7523h                  ;751a 18 07  . . 
v_sub_6be8h:
   ld (l7550h+1),sp                                            ;751c ed 73 5d 0e  . s ] . 
    ld a,(hl)                  ;7520 7e  ~ 
    inc hl                     ;7521 23  # 
    ld sp,hl                   ;7522 f9  . 
l7523h:
    pop hl                     ;7523 e1  . 
    pop hl                     ;7524 e1  . 
    ld hl,(vr_l08819h+1)       ;7525 2a 5a 2a  * Z * 
    push hl                    ;7528 e5  . 
    ld hl,(vr_l07931h+1)       ;7529 2a 72 1b  * r . 
    push hl                    ;752c e5  . 
l752dh:
    and a                      ;752d a7  . 
    dec a                      ;752e 3d  = 
    jr z,l7550h                ;752f 28 1f  ( . 
    ex af,af'                  ;7531 08  . 
    xor a                      ;7532 af  . 
    ld h,d                     ;7533 62  b 
    ld l,e                     ;7534 6b  k 
    sbc hl,bc                  ;7535 ed 42  . B 
    ccf                        ;7537 3f  ? 
    adc a,000h                 ;7538 ce 00  . . 
    pop hl                     ;753a e1  . 
    sbc hl,de                  ;753b ed 52  . R 
    jr z,l7542h                ;753d 28 03  ( . 
    ccf                        ;753f 3f  ? 
    adc a,000h                 ;7540 ce 00  . . 
l7542h:
    pop hl                     ;7542 e1  . 
    and a                      ;7543 a7  . 
    sbc hl,bc                  ;7544 ed 42  . B 
    adc a,000h                 ;7546 ce 00  . . 
    cp 002h                    ;7548 fe 02  . . 
    scf                        ;754a 37  7 
    jr nz,l7550h               ;754b 20 03    . 
    ex af,af'                  ;754d 08  . 
    jr l752dh                  ;754e 18 dd  . . 
l7550h:
    ld sp,00000h               ;7550 31 00 00  1 . . 
    ret                        ;7553 c9  . 
v_sub_6c20h:
    ld (l7577h+1),sp                                           ;7554 ed 73 84 0e  . s . .                                              (flow (mon) from: 6a25 6a2d)  6c20 ld (6c44),sp 
    ld a,(hl)                  ;7558 7e  ~                         (flow (mon) from: 6c20)  6c24 ld a,(hl) 
    inc hl                     ;7559 23  #                         (flow (mon) from: 6c24)  6c25 inc hl 
    ld sp,hl                   ;755a f9  .                         (flow (mon) from: 6c25)  6c26 ld sp,hl 
    pop hl                     ;755b e1  .                         (flow (mon) from: 6c26)  6c27 pop hl 
    pop hl                     ;755c e1  .                         (flow (mon) from: 6c27)  6c28 pop hl 
    ld hl,(vr_l08819h+1)       ;755d 2a 5a 2a  * Z *               (flow (mon) from: 6c28)  6c29 ld hl,(881a) 
    push hl                    ;7560 e5  .                         (flow (mon) from: 6c29)  6c2c push hl 
    ld hl,(vr_l07931h+1)       ;7561 2a 72 1b  * r .               (flow (mon) from: 6c2c)  6c2d ld hl,(7932) 
    push hl                    ;7564 e5  .                         (flow (mon) from: 6c2d)  6c30 push hl 
l7565h:
    dec a                      ;7565 3d  =                         (flow (mon) from: 6c30 6c3b 6c41)  6c31 dec a 
    jr z,l7577h                ;7566 28 0f  ( .                    (flow (mon) from: 6c31)  6c32 jr z,6c43 
    pop hl                     ;7568 e1  .                         (flow (mon) from: 6c32)  6c34 pop hl 
    or a                       ;7569 b7  .                         (flow (mon) from: 6c34)  6c35 or a 
    sbc hl,de                  ;756a ed 52  . R                    (flow (mon) from: 6c35)  6c36 sbc hl,de 
    pop hl                     ;756c e1  .                         (flow (mon) from: 6c36)  6c38 pop hl 
    jr z,l7571h                ;756d 28 02  ( .                    (flow (mon) from: 6c38)  6c39 jr z,6c3d 
    jr nc,l7565h               ;756f 30 f4  0 .                    (flow (mon) from: 6c39)  6c3b jr nc,6c31 
l7571h:
    and a                      ;7571 a7  .                         (flow (mon) from: 6c3b)  6c3d and a 
    sbc hl,de                  ;7572 ed 52  . R                    (flow (mon) from: 6c3d)  6c3e sbc hl,de 
    ccf                        ;7574 3f  ?                         (flow (mon) from: 6c3e)  6c40 ccf 
    jr nc,l7565h               ;7575 30 ee  0 .                    (flow (mon) from: 6c40)  6c41 jr nc,6c31 
l7577h:
    ld sp,08b91h                                               ;7577 31 91 8b  1 . .                                                   (flow (mon) from: 6c32)  6c43 ld sp,8b91 
    ret                        ;757a c9  .                         (flow (mon) from: 6c43)  6c46 ret 
v_sub_6c47h:
    call v_sub_6a0fh           ;757b cd 4f 0c  . O . 
v_sub_6c4ah:
    push hl                    ;757e e5  . 
    ld hl,(v_l5dcah)           ;757f 2a 0a 00  * . . 
    ld a,l                     ;7582 7d  } 
    and 0e0h                   ;7583 e6 e0  . . 
    ld l,a                     ;7585 6f  o 
    ld a,(v_l5dceh)            ;7586 3a 0e 00  : . . 
    and 01fh                   ;7589 e6 1f  . . 
    jp z,v_l5f74h              ;758b ca b4 01  . . . 
l758eh:
    dec a                      ;758e 3d  = 
    jr z,l759dh                ;758f 28 0c  ( . 
    ld d,h                     ;7591 54  T 
    ld e,l                     ;7592 5d  ] 
    ex af,af'                  ;7593 08  . 
    call v_sub_6f94h           ;7594 cd d4 11  . . . 
    call v_sub_7c83h           ;7597 cd c3 1e  . . . 
    ex af,af'                  ;759a 08  . 
    jr l758eh                  ;759b 18 f1  . . 
l759dh:
    ld (vr_l08787h+1),hl       ;759d 22 c8 29  " . ) 
    pop hl                     ;75a0 e1  . 
v_sub_6c6dh:
    push hl                    ;75a1 e5  .                         (flow (mon) from: 6e81)  6c6d push hl 
    ld b,020h                  ;75a2 06 20  .                      (flow (mon) from: 6c6d)  6c6e ld b,20 
    ld hl,v_l8aa4h             ;75a4 21 e4 2c  ! . ,               (flow (mon) from: 6c6e)  6c70 ld hl,8aa4 
l75a7h:
    call v_sub_85adh           ;75a7 cd ed 27  . . '               (flow (mon) from: 6c70 6c7f)  6c73 call 85ad 
    cp 020h                    ;75aa fe 20  .                      (flow (mon) from: 85b1 85b4)  6c76 cp 20 
    jr nc,l75b0h               ;75ac 30 02  0 .                    (flow (mon) from: 6c76)  6c78 jr nc,6c7c 
    ld a,020h                  ;75ae 3e 20  >                      (flow (mon) from: 6c78)  6c7a ld a,20 
l75b0h:
    call v_sub_8769h           ;75b0 cd a9 29  . . )               (flow (mon) from: 6c78 6c7a)  6c7c call 8769 
    djnz l75a7h                ;75b3 10 f2  . .                    (flow (mon) from: 877e)  6c7f djnz 6c73 
    pop hl                     ;75b5 e1  .                         (flow (mon) from: 6c7f)  6c81 pop hl 
    ret                        ;75b6 c9  .                         (flow (mon) from: 6c81)  6c82 ret 
v_l6c83h:
    ld hl,ATTRIBUTES_ADDRESS   ;75b7 21 00 58  ! . X 
    ld bc,00003h               ;75ba 01 03 00  . . . 
    push hl                    ;75bd e5  . 
    push bc                    ;75be c5  . 
l75bfh:
    ld (hl),039h               ;75bf 36 39  6 9 
    inc hl                     ;75c1 23  # 
    djnz l75bfh                ;75c2 10 fb  . . 
    dec c                      ;75c4 0d  . 
    jr nz,l75bfh               ;75c5 20 f8    . 
    call v_sub_6d84h           ;75c7 cd c4 0f  . . . 
    pop bc                     ;75ca c1  . 
    pop hl                     ;75cb e1  . 
l75cch:
    ld a,(hl)                  ;75cc 7e  ~ 
    cp 039h                    ;75cd fe 39  . 9 
    jr nz,l75e7h               ;75cf 20 16    . 
    push hl                    ;75d1 e5  . 
    ld a,h                     ;75d2 7c  | 
    sub 00ah                   ;75d3 d6 0a  . . 
l75d5h:
    ld h,a                     ;75d5 67  g 
    and 007h                   ;75d6 e6 07  . . 
    jr z,l75dfh                ;75d8 28 05  ( . 
    ld a,h                     ;75da 7c  | 
    sub 007h                   ;75db d6 07  . . 
    jr l75d5h                  ;75dd 18 f6  . . 
l75dfh:
    ld e,008h                  ;75df 1e 08  . . 
l75e1h:
    ld (hl),a                  ;75e1 77  w 
    inc h                      ;75e2 24  $ 
    dec e                      ;75e3 1d  . 
    jr nz,l75e1h               ;75e4 20 fb    . 
    pop hl                     ;75e6 e1  . 
l75e7h:
    inc hl                     ;75e7 23  # 
    djnz l75cch                ;75e8 10 e2  . . 
    dec c                      ;75ea 0d  . 
    jr nz,l75cch               ;75eb 20 df    . 
l075edh:
    ld bc,00000h               ;75ed 01 00 00  . . . 
    ld ix,v_l5dc3h             ;75f0 dd 21 03 00  . ! . . 
    add ix,bc                  ;75f4 dd 09  . . 
    push bc                    ;75f6 c5  . 
    ld a,028h                  ;75f7 3e 28  > ( 
    ld (vr_l0877bh+1),a        ;75f9 32 bc 29  2 . ) 
    call v_sub_6db1h           ;75fc cd f1 0f  . . . 
    ld a,038h                  ;75ff 3e 38  > 8 
    ld (vr_l0877bh+1),a        ;7601 32 bc 29  2 . ) 
    call v_sub_8608h           ;7604 cd 48 28  . H ( 
    pop bc                     ;7607 c1  . 
    cp 004h                    ;7608 fe 04  . . 
    ret z                      ;760a c8  . 
    ld hl,v_l6c83h             ;760b 21 c3 0e  ! . . 
    push hl                    ;760e e5  . 
    ld b,007h                  ;760f 06 07  . . 
    cp 034h                    ;7611 fe 34  . 4 
    jr z,l761bh                ;7613 28 06  ( . 
    ld b,0f9h                  ;7615 06 f9  . . 
    cp 033h                    ;7617 fe 33  . 3 
    jr nz,l762ch               ;7619 20 11    . 
l761bh:
    ld a,c                     ;761b 79  y 
    add a,b                    ;761c 80  . 
    cp 0f9h                    ;761d fe f9  . . 
    jr nz,l7623h               ;761f 20 02    . 
    ld a,0e7h                  ;7621 3e e7  > . 
l7623h:
    cp 0eeh                    ;7623 fe ee  . . 
    jr c,l7628h                ;7625 38 01  8 . 
    xor a                      ;7627 af  . 
l7628h:
        ld (l075edh+1),a                                       ;7628 32 fa 0e  2 . . 
    ret                        ;762b c9  . 
l762ch:
    ld h,(ix+001h)             ;762c dd 66 01  . f . 
    ld l,(ix+000h)             ;762f dd 6e 00  . n . 
    ld b,001h                  ;7632 06 01  . . 
    cp 038h                    ;7634 fe 38  . 8 
    jr z,l7656h                ;7636 28 1e  ( . 
    cp 036h                    ;7638 fe 36  . 6 
    jr z,l7642h                ;763a 28 06  ( . 
    cp 037h                    ;763c fe 37  . 7 
    jr nz,l7649h               ;763e 20 09    . 
l7640h:
    ld b,017h                  ;7640 06 17  . . 
l7642h:
    call v_sub_6f94h           ;7642 cd d4 11  . . . 
    djnz l7642h                ;7645 10 fb  . . 
    jr l7659h                  ;7647 18 10  . . 
l7649h:
    cp 035h                    ;7649 fe 35  . 5 
    jr nz,l7660h               ;764b 20 13    . 
    ld b,01fh                  ;764d 06 1f  . . 
l764fh:
    call v_sub_6f88h           ;764f cd c8 11  . . . 
    djnz l764fh                ;7652 10 fb  . . 
    jr l7640h                  ;7654 18 ea  . . 
l7656h:
    call v_sub_6f88h           ;7656 cd c8 11  . . . 
l7659h:
    ld (ix+001h),h             ;7659 dd 74 01  . t . 
    ld (ix+000h),l             ;765c dd 75 00  . u . 
    ret                        ;765f c9  . 
l7660h:
    cp 061h                    ;7660 fe 61  . a 
    jr c,l767dh                ;7662 38 19  8 . 
    cp 07bh                    ;7664 fe 7b  . { 
    jr nc,l767dh               ;7666 30 15  0 . 
    sub 061h                   ;7668 d6 61  . a 
    ld b,a                     ;766a 47  G 
    ld a,(ix+004h)             ;766b dd 7e 04  . ~ . 
    ld c,a                     ;766e 4f  O 
    and 01fh                   ;766f e6 1f  . . 
    xor b                      ;7671 a8  . 
    xor c                      ;7672 a9  . 
    bit 7,c                    ;7673 cb 79  . y 
    jr nz,l7679h               ;7675 20 02    . 
    and 0e1h                   ;7677 e6 e1  . . 
l7679h:
    ld (ix+004h),a             ;7679 dd 77 04  . w . 
    ret                        ;767c c9  . 
l767dh:
    ld d,(ix+003h)             ;767d dd 56 03  . V . 
    ld e,(ix+004h)             ;7680 dd 5e 04  . ^ . 
    ld hl,v_l6d67h             ;7683 21 a7 0f  ! . . 
    ld b,006h                  ;7686 06 06  . . 
l7688h:
    cp (hl)                    ;7688 be  . 
    inc hl                     ;7689 23  # 
    jr z,l7691h                ;768a 28 05  ( . 
    inc hl                     ;768c 23  # 
    inc hl                     ;768d 23  # 
    djnz l7688h                ;768e 10 f8  . . 
    ret                        ;7690 c9  . 
l7691h:
    ld a,(hl)                  ;7691 7e  ~ 
    and e                      ;7692 a3  . 
    ret z                      ;7693 c8  . 
    inc hl                     ;7694 23  # 
    ld a,(hl)                  ;7695 7e  ~ 
    xor d                      ;7696 aa  . 
    ld (ix+003h),a             ;7697 dd 77 03  . w . 
    ret                        ;769a c9  . 
v_l6d67h:
    ld e,h                     ;769b 5c  \ 
    rst 38h                    ;769c ff  . 
    add a,b                    ;769d 80  . 
    ld e,(hl)                  ;769e 5e  ^ 
    rst 38h                    ;769f ff  . 
    ld b,b                     ;76a0 40  @ 
    ld hl,(020ffh)             ;76a1 2a ff 20  * .   
    ccf                        ;76a4 3f  ? 
    rst 38h                    ;76a5 ff  . 
    djnz l76e6h                ;76a6 10 3e  . > 
    ld b,b                     ;76a8 40  @ 
    ex af,af'                  ;76a9 08  . 
    ld a,h                     ;76aa 7c  | 
    jr nz,$+6                  ;76ab 20 04    . 
v_sub_6d79h:
        ld hl,(l0696eh+1)                                      ;76ad 2a 7b 02  * { .                                                   (flow (mon) from: 5fbd)  6d79 ld hl,(603b)                          (flow (mon) from: 5fbd)  6d79 ld hl,(603b) 
v_sub_6d7ch:
    ld ix,v_l5dd1h             ;76b0 dd 21 11 00  . ! . .          (flow (mon) from: 6d79)  6d7c ld ix,5dd1 
    ld b,020h                  ;76b4 06 20  .                      (flow (mon) from: 6d7c)  6d80 ld b,20 
    jr l76beh                  ;76b6 18 06  . .                    (flow (mon) from: 6d80)  6d82 jr 6d8a 
v_sub_6d84h:
    ld ix,v_l5dc3h             ;76b8 dd 21 03 00  . ! . . 
    ld b,022h                  ;76bc 06 22  . " 
l76beh:
    ld (vr_l06e78h+1),hl       ;76be 22 b9 10  " . .               (flow (mon) from: 6d82)  6d8a ld (6e79),hl 
l76c1h:
    push bc                    ;76c1 c5  .                         (flow (mon) from: 6d8a 6d97)  6d8d push bc 
    call v_sub_6dabh           ;76c2 cd eb 0f  . . .               (flow (mon) from: 6d8d)  6d8e call 6dab 
    ld bc,00007h               ;76c5 01 07 00  . . .               (flow (mon) from: 6db0 6deb 6e89 6edf 6f87)  6d91 ld bc,0007 
    add ix,bc                  ;76c8 dd 09  . .                    (flow (mon) from: 6d91)  6d94 add ix,bc 
    pop bc                     ;76ca c1  .                         (flow (mon) from: 6d94)  6d96 pop bc 
    djnz l76c1h                ;76cb 10 f4  . .                    (flow (mon) from: 6d96)  6d97 djnz 6d8d 
    ret                        ;76cd c9  .                         (flow (mon) from: 6d97)  6d99 ret 
l76ceh:
    ld a,028h                  ;76ce 3e 28  > ( 
    call v_sub_8769h           ;76d0 cd a9 29  . . ) 
    pop hl                     ;76d3 e1  . 
    push hl                    ;76d4 e5  . 
    call v_sub_6f5dh           ;76d5 cd 9d 11  . . . 
    ld a,029h                  ;76d8 3e 29  > ) 
l76dah:
    call v_sub_8767h           ;76da cd a7 29  . . )               (flow (mon) from: 6dd4)  6da6 call 8767 
    jr l770dh                  ;76dd 18 2e  . .                    (flow (mon) from: 877e)  6da9 jr 6dd9 
v_sub_6dabh:
    ld a,(ix+004h)             ;76df dd 7e 04  . ~ .               (flow (mon) from: 6d8e)  6dab ld a,(ix+04) 
    and 01fh                   ;76e2 e6 1f  . .                    (flow (mon) from: 6dab)  6dae and 1f 
    ret z                      ;76e4 c8  .                         (flow (mon) from: 6dae)  6db0 ret z 
v_sub_6db1h:
    xor a                      ;76e5 af  .                         (flow (mon) from: 6db0)  6db1 xor a 
l76e6h:
    ld (vr_l06ef4h+1),a        ;76e6 32 35 11  2 5 .               (flow (mon) from: 6db1)  6db2 ld (6ef5),a 
    call v_sub_6e8ah           ;76e9 cd ca 10  . . .               (flow (mon) from: 6db2)  6db5 call 6e8a 
    ld l,(ix+005h)             ;76ec dd 6e 05  . n .               (flow (mon) from: 6e93)  6db8 ld l,(ix+05) 
    ld h,(ix+006h)             ;76ef dd 66 06  . f .               (flow (mon) from: 6db8)  6dbb ld h,(ix+06) 
    ld a,(ix+003h)             ;76f2 dd 7e 03  . ~ .               (flow (mon) from: 6dbb)  6dbe ld a,(ix+03) 
    and 003h                   ;76f5 e6 03  . .                    (flow (mon) from: 6dbe)  6dc1 and 03 
    dec a                      ;76f7 3d  =                         (flow (mon) from: 6dc1)  6dc3 dec a 
    jr nz,l76feh               ;76f8 20 04    .                    (flow (mon) from: 6dc3)  6dc4 jr nz,6dca 
    ld e,(hl)                  ;76fa 5e  ^                         (flow (mon) from: 6dc4)  6dc6 ld e,(hl) 
    inc hl                     ;76fb 23  #                         (flow (mon) from: 6dc6)  6dc7 inc hl 
    ld d,(hl)                  ;76fc 56  V                         (flow (mon) from: 6dc7)  6dc8 ld d,(hl) 
    ex de,hl                   ;76fd eb  .                         (flow (mon) from: 6dc8)  6dc9 ex de,hl 
l76feh:
    push hl                    ;76fe e5  .                         (flow (mon) from: 6dc4 6dc9)  6dca push hl 
    ld a,(ix+002h)             ;76ff dd 7e 02  . ~ .               (flow (mon) from: 6dca)  6dcb ld a,(ix+02) 
    cp 0d8h                    ;7702 fe d8  . .                    (flow (mon) from: 6dcb)  6dce cp d8 
    jr nc,l76ceh               ;7704 30 c8  0 .                    (flow (mon) from: 6dce)  6dd0 jr nc,6d9a 
    cp 080h                    ;7706 fe 80  . .                    (flow (mon) from: 6dd0)  6dd2 cp 80 
    jr nc,l76dah               ;7708 30 d0  0 .                    (flow (mon) from: 6dd2)  6dd4 jr nc,6da6 
    call v_sub_6f6fh           ;770a cd af 11  . . .               (flow (mon) from: 6dd4)  6dd6 call 6f6f 
l770dh:
    ld a,03ah                  ;770d 3e 3a  > :                    (flow (mon) from: 6da9 6f87)  6dd9 ld a,3a 
    call v_sub_8769h           ;770f cd a9 29  . . )               (flow (mon) from: 6dd9)  6ddb call 8769 
    pop de                     ;7712 d1  .                         (flow (mon) from: 877e)  6dde pop de 
    ld a,(ix+004h)             ;7713 dd 7e 04  . ~ .               (flow (mon) from: 6dde)  6ddf ld a,(ix+04) 
    and 01fh                   ;7716 e6 1f  . .                    (flow (mon) from: 6ddf)  6de2 and 1f 
    ld hl,(vr_l08787h+1)       ;7718 2a c8 29  * . )               (flow (mon) from: 6de2)  6de4 ld hl,(8788) 
l771bh:
        ld bc,l0781eh+2                                        ;771b 01 2c 11  . , .                                                   (flow (mon) from: 6de4 6e41)  6de7 ld bc,6eec                       (flow (mon) from: 6de4 6e41)  6de7 ld bc,6eec 
    or a                       ;771e b7  .                         (flow (mon) from: 6de7)  6dea or a 
    ret z                      ;771f c8  .                         (flow (mon) from: 6dea)  6deb ret z 
    push af                    ;7720 f5  .                         (flow (mon) from: 6deb)  6dec push af 
    push hl                    ;7721 e5  .                         (flow (mon) from: 6dec)  6ded push hl 
    ld a,(de)                  ;7722 1a  .                         (flow (mon) from: 6ded)  6dee ld a,(de) 
    ld l,a                     ;7723 6f  o                         (flow (mon) from: 6dee)  6def ld l,a 
    inc de                     ;7724 13  .                         (flow (mon) from: 6def)  6df0 inc de 
    ld a,(de)                  ;7725 1a  .                         (flow (mon) from: 6df0)  6df1 ld a,(de) 
    ld h,a                     ;7726 67  g                         (flow (mon) from: 6df1)  6df2 ld h,a 
    ld a,(ix+003h)             ;7727 dd 7e 03  . ~ .               (flow (mon) from: 6df2)  6df3 ld a,(ix+03) 
    bit 3,a                    ;772a cb 5f  . _                    (flow (mon) from: 6df3)  6df6 bit 3,a 
    jr z,l772fh                ;772c 28 01  ( .                    (flow (mon) from: 6df6)  6df8 jr z,6dfb 
    inc de                     ;772e 13  .                         (flow (mon) from: 6df8)  6dfa inc de 
l772fh:
    push de                    ;772f d5  .                         (flow (mon) from: 6df8 6dfa)  6dfb push de 
    ld e,a                     ;7730 5f  _                         (flow (mon) from: 6dfb)  6dfc ld e,a 
    and 003h                   ;7731 e6 03  . .                    (flow (mon) from: 6dfc)  6dfd and 03 
    jp z,v_l6e9ch              ;7733 ca dc 10  . . .               (flow (mon) from: 6dfd)  6dff jp z,6e9c 
    cp 003h                    ;7736 fe 03  . .                    (flow (mon) from: 6dff)  6e02 cp 03 
    jr nc,l7777h               ;7738 30 3d  0 =                    (flow (mon) from: 6e02)  6e04 jr nc,6e43 
    ld d,004h                  ;773a 16 04  . .                    (flow (mon) from: 6e04)  6e06 ld d,04 
l773ch:
    bit 3,(ix+003h)            ;773c dd cb 03 5e  . . . ^          (flow (mon) from: 6e06 6e2b)  6e08 bit 3,(ix+03) 
    push bc                    ;7740 c5  .                         (flow (mon) from: 6e08)  6e0c push bc 
    jr z,l7744h                ;7741 28 01  ( .                    (flow (mon) from: 6e0c)  6e0d jr z,6e10 
    inc bc                     ;7743 03  .                         (flow (mon) from: 6e0d)  6e0f inc bc 
l7744h:
    push ix                    ;7744 dd e5  . .                    (flow (mon) from: 6e0d 6e0f)  6e10 push ix 
    ld ix,v_l6f01h             ;7746 dd 21 41 11  . ! A .          (flow (mon) from: 6e10)  6e12 ld ix,6f01 
    ld a,(bc)                  ;774a 0a  .                         (flow (mon) from: 6e12)  6e16 ld a,(bc) 
    ld b,000h                  ;774b 06 00  . .                    (flow (mon) from: 6e16)  6e17 ld b,00 
    ld c,a                     ;774d 4f  O                         (flow (mon) from: 6e17)  6e19 ld c,a 
    add ix,bc                  ;774e dd 09  . .                    (flow (mon) from: 6e19)  6e1a add ix,bc 
    rl e                       ;7750 cb 13  . .                    (flow (mon) from: 6e1a)  6e1c rl e 
    push de                    ;7752 d5  .                         (flow (mon) from: 6e1c)  6e1e push de 
    push hl                    ;7753 e5  .                         (flow (mon) from: 6e1e)  6e1f push hl 
    call c,v_sub_6ef4h         ;7754 dc 34 11  . 4 .               (flow (mon) from: 6e1f)  6e20 call c,6ef4 
    pop hl                     ;7757 e1  .                         (flow (mon) from: 6e20 6f2a 6f43 877e)  6e23 pop hl 
    pop de                     ;7758 d1  .                         (flow (mon) from: 6e23)  6e24 pop de 
    pop ix                     ;7759 dd e1  . .                    (flow (mon) from: 6e24)  6e25 pop ix 
    pop bc                     ;775b c1  .                         (flow (mon) from: 6e25)  6e27 pop bc 
    inc bc                     ;775c 03  .                         (flow (mon) from: 6e27)  6e28 inc bc 
    inc bc                     ;775d 03  .                         (flow (mon) from: 6e28)  6e29 inc bc 
    dec d                      ;775e 15  .                         (flow (mon) from: 6e29)  6e2a dec d 
    jr nz,l773ch               ;775f 20 db    .                    (flow (mon) from: 6e2a)  6e2b jr nz,6e08 
    pop de                     ;7761 d1  .                         (flow (mon) from: 6e2b)  6e2d pop de 
    pop hl                     ;7762 e1  .                         (flow (mon) from: 6e2d)  6e2e pop hl 
    bit 2,(ix+003h)            ;7763 dd cb 03 56  . . . V          (flow (mon) from: 6e2e)  6e2f bit 2,(ix+03) 
    jr z,l7773h                ;7767 28 0a  ( .                    (flow (mon) from: 6e2f)  6e33 jr z,6e3f 
    call v_sub_6f94h           ;7769 cd d4 11  . . .               (flow (mon) from: 6e33)  6e35 call 6f94 
    ld (vr_l08787h+1),hl       ;776c 22 c8 29  " . )               (flow (mon) from: 6f98)  6e38 ld (8788),hl 
    xor a                      ;776f af  .                         (flow (mon) from: 6e38)  6e3b xor a 
    ld (vr_l06ef4h+1),a        ;7770 32 35 11  2 5 .               (flow (mon) from: 6e3b)  6e3c ld (6ef5),a 
l7773h:
    pop af                     ;7773 f1  .                         (flow (mon) from: 6e33 6e3c)  6e3f pop af 
    dec a                      ;7774 3d  =                         (flow (mon) from: 6e3f)  6e40 dec a 
    jr l771bh                  ;7775 18 a4  . .                    (flow (mon) from: 6e40)  6e41 jr 6de7 
l7777h:
    pop de                     ;7777 d1  .                         (flow (mon) from: 6e04)  6e43 pop de 
    pop hl                     ;7778 e1  .                         (flow (mon) from: 6e43)  6e44 pop hl 
    pop af                     ;7779 f1  .                         (flow (mon) from: 6e44)  6e45 pop af 
v_l6e46h:
    call v_sub_6e8ah           ;777a cd ca 10  . . .               (flow (mon) from: 6e45)  6e46 call 6e8a 
    rlca                       ;777d 07  .                         (flow (mon) from: 6e93)  6e49 rlca 
    rlca                       ;777e 07  .                         (flow (mon) from: 6e49)  6e4a rlca 
    rlca                       ;777f 07  .                         (flow (mon) from: 6e4a)  6e4b rlca 
    ld l,a                     ;7780 6f  o                         (flow (mon) from: 6e4b)  6e4c ld l,a 
    ld h,000h                  ;7781 26 00  & .                    (flow (mon) from: 6e4c)  6e4d ld h,00 
    add hl,hl                  ;7783 29  )                         (flow (mon) from: 6e4d)  6e4f add hl,hl 
    add hl,hl                  ;7784 29  )                         (flow (mon) from: 6e4f)  6e50 add hl,hl 
l7785h:
    ld a,(ix+002h)             ;7785 dd 7e 02  . ~ .               (flow (mon) from: 6e50)  6e51 ld a,(ix+02) 
    cp 0c4h                    ;7788 fe c4  . .                    (flow (mon) from: 6e51)  6e54 cp c4 
    jr z,l77a3h                ;778a 28 17  ( .                    (flow (mon) from: 6e54)  6e56 jr z,6e6f 
    cp 0a3h                    ;778c fe a3  . .                    (flow (mon) from: 6e56)  6e58 cp a3 
    jr z,l7799h                ;778e 28 09  ( .                    (flow (mon) from: 6e58)  6e5a jr z,6e65 
    call v_sub_8767h           ;7790 cd a7 29  . . ) 
    dec hl                     ;7793 2b  + 
    ld a,h                     ;7794 7c  | 
    or l                       ;7795 b5  . 
    jr nz,l7785h               ;7796 20 ed    . 
    ret                        ;7798 c9  . 
l7799h:
vr_l06e65h:
    ld a,000h                  ;7799 3e 00  > .                    (flow (mon) from: 6e5a)  6e65 ld a,00 
    add a,003h                 ;779b c6 03  . .                    (flow (mon) from: 6e65)  6e67 add a,03 
    ld de,v_l8c76h             ;779d 11 b6 2e  . . .               (flow (mon) from: 6e67)  6e69 ld de,8c76 
    jp v_l6f72h                ;77a0 c3 b2 11  . . .               (flow (mon) from: 6e69)  6e6c jp 6f72 
l77a3h:
    ld a,(ix+004h)             ;77a3 dd 7e 04  . ~ .               (flow (mon) from: 6e56)  6e6f ld a,(ix+04) 
    and 01fh                   ;77a6 e6 1f  . .                    (flow (mon) from: 6e6f)  6e72 and 1f 
    ld b,a                     ;77a8 47  G                         (flow (mon) from: 6e72)  6e74 ld b,a 
    call v_sub_6a19h           ;77a9 cd 59 0c  . Y .               (flow (mon) from: 6e74)  6e75 call 6a19 
vr_l06e78h:
    ld hl,00000h               ;77ac 21 00 00  ! . .               (flow (mon) from: 6a1d)  6e78 ld hl,fffd 
    push ix                    ;77af dd e5  . .                    (flow (mon) from: 6e78)  6e7b push ix 
l77b1h:
    push bc                    ;77b1 c5  .                         (flow (mon) from: 6e7b 6e85)  6e7d push bc 
    call v_sub_6a0ah           ;77b2 cd 4a 0c  . J .               (flow (mon) from: 6e7d)  6e7e call 6a0a 
    call v_sub_6c6dh           ;77b5 cd ad 0e  . . .               (flow (mon) from: 6afb)  6e81 call 6c6d 
    pop bc                     ;77b8 c1  .                         (flow (mon) from: 6c82)  6e84 pop bc 
    djnz l77b1h                ;77b9 10 f6  . .                    (flow (mon) from: 6e84)  6e85 djnz 6e7d 
    pop ix                     ;77bb dd e1  . .                    (flow (mon) from: 6e85)  6e87 pop ix 
    ret                        ;77bd c9  .                         (flow (mon) from: 6e87)  6e89 ret 
v_sub_6e8ah:
    ld l,(ix+000h)             ;77be dd 6e 00  . n .               (flow (mon) from: 6db5 6e46 6ea5)  6e8a ld l,(ix+00) 
    ld h,(ix+001h)             ;77c1 dd 66 01  . f .               (flow (mon) from: 6e8a)  6e8d ld h,(ix+01) 
    ld (vr_l08787h+1),hl       ;77c4 22 c8 29  " . )               (flow (mon) from: 6e8d)  6e90 ld (8788),hl 
    ret                        ;77c7 c9  .                         (flow (mon) from: 6e90)  6e93 ret 
v_l6e94h:
    ld (hl),e                  ;77c8 73  s 
    ld a,d                     ;77c9 7a  z 
    dec l                      ;77ca 2d  - 
    ld l,b                     ;77cb 68  h 
    dec l                      ;77cc 2d  - 
    ld (hl),b                  ;77cd 70  p 
    ld l,(hl)                  ;77ce 6e  n 
    ex (sp),hl                 ;77cf e3  . 
v_l6e9ch:
    pop af                     ;77d0 f1  .                         (flow (mon) from: 6dff)  6e9c pop af 
    pop af                     ;77d1 f1  .                         (flow (mon) from: 6e9c)  6e9d pop af 
    ld a,l                     ;77d2 7d  }                         (flow (mon) from: 6e9d)  6e9e ld a,l 
    ex af,af'                  ;77d3 08  .                         (flow (mon) from: 6e9e)  6e9f ex af,af' 
    ld c,l                     ;77d4 4d  M                         (flow (mon) from: 6e9f)  6ea0 ld c,l 
    ld b,004h                  ;77d5 06 04  . .                    (flow (mon) from: 6ea0)  6ea1 ld b,04 
    bit 5,e                    ;77d7 cb 6b  . k                    (flow (mon) from: 6ea1)  6ea3 bit 5,e 
    call v_sub_6e8ah           ;77d9 cd ca 10  . . .               (flow (mon) from: 6ea3)  6ea5 call 6e8a 
    push hl                    ;77dc e5  .                         (flow (mon) from: 6e93)  6ea8 push hl 
    ld hl,v_l6ee0h             ;77dd 21 20 11  !   .               (flow (mon) from: 6ea8)  6ea9 ld hl,6ee0 
    jr z,l77f8h                ;77e0 28 16  ( .                    (flow (mon) from: 6ea9)  6eac jr z,6ec4 
    ld de,v_l6e94h             ;77e2 11 d4 10  . . . 
    call v_sub_6f75h           ;77e5 cd b5 11  . . . 
    pop hl                     ;77e8 e1  . 
    call v_sub_6f94h           ;77e9 cd d4 11  . . . 
    ld (vr_l08787h+1),hl       ;77ec 22 c8 29  " . ) 
    ex af,af'                  ;77ef 08  . 
    call v_sub_6f36h           ;77f0 cd 76 11  . v . 
    pop hl                     ;77f3 e1  . 
    ret                        ;77f4 c9  . 
l77f5h:
    call v_sub_8765h           ;77f5 cd a5 29  . . )               (flow (mon) from: 6edb)  6ec1 call 8765 
l77f8h:
    ld a,(hl)                  ;77f8 7e  ~                         (flow (mon) from: 6eac 877e)  6ec4 ld a,(hl) 
    inc hl                     ;77f9 23  #                         (flow (mon) from: 6ec4)  6ec5 inc hl 
    and c                      ;77fa a1  .                         (flow (mon) from: 6ec5)  6ec6 and c 
    jr nz,l7801h               ;77fb 20 04    .                    (flow (mon) from: 6ec6)  6ec7 jr nz,6ecd 
    inc hl                     ;77fd 23  #                         (flow (mon) from: 6ec7)  6ec9 inc hl 
    ld a,(hl)                  ;77fe 7e  ~                         (flow (mon) from: 6ec9)  6eca ld a,(hl) 
    jr l7803h                  ;77ff 18 02  . .                    (flow (mon) from: 6eca)  6ecb jr 6ecf 
l7801h:
    ld a,(hl)                  ;7801 7e  ~ 
    inc hl                     ;7802 23  # 
l7803h:
    inc hl                     ;7803 23  #                         (flow (mon) from: 6ecb)  6ecf inc hl 
    push af                    ;7804 f5  .                         (flow (mon) from: 6ecf)  6ed0 push af 
    rlca                       ;7805 07  .                         (flow (mon) from: 6ed0)  6ed1 rlca 
    call c,v_sub_8765h         ;7806 dc a5 29  . . )               (flow (mon) from: 6ed1)  6ed2 call c,8765 
    pop af                     ;7809 f1  .                         (flow (mon) from: 6ed2)  6ed5 pop af 
    and 07fh                   ;780a e6 7f  .                     (flow (mon) from: 6ed5)  6ed6 and 7f 
    call v_sub_6f6fh           ;780c cd af 11  . . .               (flow (mon) from: 6ed6)  6ed8 call 6f6f 
    djnz l77f5h                ;780f 10 e4  . .                    (flow (mon) from: 6f87)  6edb djnz 6ec1 
    pop de                     ;7811 d1  .                         (flow (mon) from: 6edb)  6edd pop de 
    pop hl                     ;7812 e1  .                         (flow (mon) from: 6edd)  6ede pop hl 
    ret                        ;7813 c9  .                         (flow (mon) from: 6ede)  6edf ret 
v_l6ee0h:
    ld b,b                     ;7814 40  @ 
    sub h                      ;7815 94  . 
    jr nz,l7819h               ;7816 20 01    . 
    adc a,e                    ;7818 8b  . 
l7819h:
    rra                        ;7819 1f  . 
    inc b                      ;781a 04  . 
    ld hl,08022h               ;781b 21 22 80  ! " . 
l0781eh:
    ld de,00012h               ;781e 11 12 00  . . . 
    ex af,af'                  ;7821 08  . 
    djnz $+32                  ;7822 10 1e  . . 
    inc (hl)                   ;7824 34  4 
    jr nc,l786eh               ;7825 30 47  0 G 
    ld b,e                     ;7827 43  C 
v_sub_6ef4h:
vr_l06ef4h:
    ld a,000h                  ;7828 3e 00  > .                    (flow (mon) from: 6e20)  6ef4 ld a,00 
    or a                       ;782a b7  .                         (flow (mon) from: 6ef4)  6ef6 or a 
    call nz,v_sub_8765h        ;782b c4 a5 29  . . )               (flow (mon) from: 6ef6)  6ef7 call nz,8765 
    ld a,001h                  ;782e 3e 01  > .                    (flow (mon) from: 6ef7 877e)  6efa ld a,01 
    ld (vr_l06ef4h+1),a        ;7830 32 35 11  2 5 .               (flow (mon) from: 6efa)  6efc ld (6ef5),a 
    jp (ix)                    ;7833 dd e9  . .                    (flow (mon) from: 6efc)  6eff jp ix 
v_l6f01h:
    call v_sub_6f66h           ;7835 cd a6 11  . . .               (flow (mon) from: 6eff)  6f01 call 6f66 
    call v_sub_8932h           ;7838 cd 72 2b  . r +               (flow (mon) from: 6f6e)  6f04 call 8932 
    jr l7859h                  ;783b 18 1c  . .                    (flow (mon) from: 8961)  6f07 jr 6f25 
    call v_sub_6f68h           ;783d cd a8 11  . . .               (flow (mon) from: 6eff)  6f09 call 6f68 
    call v_sub_8926h           ;7840 cd 66 2b  . f +               (flow (mon) from: 6f6e)  6f0c call 8926 
    jr l7859h                  ;7843 18 14  . .                    (flow (mon) from: 8961)  6f0f jr 6f25 
    call v_sub_6f66h           ;7845 cd a6 11  . . . 
    ld (ix+000h),023h          ;7848 dd 36 00 23  . 6 . # 
    inc ix                     ;784c dd 23  . # 
    call v_sub_891eh           ;784e cd 5e 2b  . ^ + 
    jr l7859h                  ;7851 18 06  . . 
    call v_sub_6f68h           ;7853 cd a8 11  . . . 
    call v_sub_890dh           ;7856 cd 4d 2b  . M + 
l7859h:
    ld hl,v_l8ac7h             ;7859 21 07 2d  ! . -               (flow (mon) from: 6f07 6f0f)  6f25 ld hl,8ac7 
l785ch:
    ld a,(hl)                  ;785c 7e  ~                         (flow (mon) from: 6f25 6f2f)  6f28 ld a,(hl) 
    or a                       ;785d b7  .                         (flow (mon) from: 6f28)  6f29 or a 
    ret z                      ;785e c8  .                         (flow (mon) from: 6f29)  6f2a ret z 
    call v_sub_8769h           ;785f cd a9 29  . . )               (flow (mon) from: 6f2a)  6f2b call 8769 
    inc hl                     ;7862 23  #                         (flow (mon) from: 877e)  6f2e inc hl 
    jr l785ch                  ;7863 18 f7  . .                    (flow (mon) from: 6f2e)  6f2f jr 6f28 
    ld a,h                     ;7865 7c  | 
    call v_sub_6f36h           ;7866 cd 76 11  . v . 
    ld a,l                     ;7869 7d  }                         (flow (mon) from: 6eff)  6f35 ld a,l 
v_sub_6f36h:
    ld c,a                     ;786a 4f  O                         (flow (mon) from: 6f35)  6f36 ld c,a 
    ld b,008h                  ;786b 06 08  . .                    (flow (mon) from: 6f36)  6f37 ld b,08 
l786dh:
    xor a                      ;786d af  .                         (flow (mon) from: 6f37 6f41)  6f39 xor a 
l786eh:
    rl c                       ;786e cb 11  . .                    (flow (mon) from: 6f39)  6f3a rl c 
    adc a,030h                 ;7870 ce 30  . 0                    (flow (mon) from: 6f3a)  6f3c adc a,30 
    call v_sub_8769h           ;7872 cd a9 29  . . )               (flow (mon) from: 6f3c)  6f3e call 8769 
    djnz l786dh                ;7875 10 f6  . .                    (flow (mon) from: 877e)  6f41 djnz 6f39 
    ret                        ;7877 c9  .                         (flow (mon) from: 6f41)  6f43 ret 
    ld a,h                     ;7878 7c  | 
    call v_sub_6f4eh           ;7879 cd 8e 11  . . . 
    xor a                      ;787c af  .                         (flow (mon) from: 6eff)  6f48 xor a 
    ld h,l                     ;787d 65  e                         (flow (mon) from: 6f48)  6f49 ld h,l 
    ld (vr_l06ef4h+1),a        ;787e 32 35 11  2 5 .               (flow (mon) from: 6f49)  6f4a ld (6ef5),a 
    ld a,h                     ;7881 7c  |                         (flow (mon) from: 6f4a)  6f4d ld a,h 
v_sub_6f4eh:
    ld h,a                     ;7882 67  g                         (flow (mon) from: 6f4d)  6f4e ld h,a 
    and 07fh                   ;7883 e6 7f  .                     (flow (mon) from: 6f4e)  6f4f and 7f 
    cp 020h                    ;7885 fe 20  .                      (flow (mon) from: 6f4f)  6f51 cp 20 
    ld a,h                     ;7887 7c  |                         (flow (mon) from: 6f51)  6f53 ld a,h 
    jr nc,l788eh               ;7888 30 04  0 .                    (flow (mon) from: 6f53)  6f54 jr nc,6f5a 
    and 080h                   ;788a e6 80  . .                    (flow (mon) from: 6f54)  6f56 and 80 
    or 02eh                    ;788c f6 2e  . .                    (flow (mon) from: 6f56)  6f58 or 2e 
l788eh:
    jp v_sub_8769h             ;788e c3 a9 29  . . )               (flow (mon) from: 6f54 6f58)  6f5a jp 8769 
v_sub_6f5dh:
    push ix                    ;7891 dd e5  . . 
    call v_sub_8902h           ;7893 cd 42 2b  . B + 
    pop ix                     ;7896 dd e1  . . 
    jr l7859h                  ;7898 18 bf  . . 
v_sub_6f66h:
    ld h,000h                  ;789a 26 00  & .                    (flow (mon) from: 6f01)  6f66 ld h,00 
v_sub_6f68h:
    ld ix,v_l8ac7h             ;789c dd 21 07 2d  . ! . -          (flow (mon) from: 6f09 6f66)  6f68 ld ix,8ac7 
    ld c,000h                  ;78a0 0e 00  . .                    (flow (mon) from: 6f68)  6f6c ld c,00 
    ret                        ;78a2 c9  .                         (flow (mon) from: 6f6c)  6f6e ret 
v_sub_6f6fh:
    ld de,v_l8db4h             ;78a3 11 f4 2f  . . /               (flow (mon) from: 6dd6 6ed8)  6f6f ld de,8db4 
v_l6f72h:
    call v_sub_82c9h           ;78a6 cd 09 25  . . %               (flow (mon) from: 6e6c 6f6f)  6f72 call 82c9 
l78a9h:
v_sub_6f75h:
    ld a,(de)                  ;78a9 1a  .                         (flow (mon) from: 6f85 82d3)  6f75 ld a,(de) 
    res 7,a                    ;78aa cb bf  . .                    (flow (mon) from: 6f75)  6f76 res 7,a 
    call potencialCommandKeyPressed                            ;78ac cd 6e 29  . n )                                                   (flow (mon) from: 6f76)  6f78 call 872e 
    jr nz,l78b3h               ;78af 20 02    .                    (flow (mon) from: 8730 8733 873c)  6f7b jr nz,6f7f 
    sub 020h                   ;78b1 d6 20  .                      (flow (mon) from: 6f7b)  6f7d sub 20 
l78b3h:
    call v_sub_8767h           ;78b3 cd a7 29  . . )               (flow (mon) from: 6f7b 6f7d)  6f7f call 8767 
    ld a,(de)                  ;78b6 1a  .                         (flow (mon) from: 877e)  6f82 ld a,(de) 
    inc de                     ;78b7 13  .                         (flow (mon) from: 6f82)  6f83 inc de 
    rla                        ;78b8 17  .                         (flow (mon) from: 6f83)  6f84 rla 
    jr nc,l78a9h               ;78b9 30 ee  0 .                    (flow (mon) from: 6f84)  6f85 jr nc,6f75 
    ret                        ;78bb c9  .                         (flow (mon) from: 6f85)  6f87 ret 
v_sub_6f88h:
    inc l                      ;78bc 2c  , 
    ret nz                     ;78bd c0  . 
l78beh:
    ld a,h                     ;78be 7c  | 
    add a,008h                 ;78bf c6 08  . . 
    cp 058h                    ;78c1 fe 58  . X 
    ld h,a                     ;78c3 67  g 
    ret nz                     ;78c4 c0  . 
    ld h,040h                  ;78c5 26 40  & @ 
    ret                        ;78c7 c9  . 
v_sub_6f94h:
    ld a,l                     ;78c8 7d  }                         (flow (mon) from: 6e35)  6f94 ld a,l 
    add a,020h                 ;78c9 c6 20  .                      (flow (mon) from: 6f94)  6f95 add a,20 
    ld l,a                     ;78cb 6f  o                         (flow (mon) from: 6f95)  6f97 ld l,a 
    ret nc                     ;78cc d0  .                         (flow (mon) from: 6f97)  6f98 ret nc 
    jr l78beh                  ;78cd 18 ef  . . 

; BLOCK 'data_78cf' (start 0x78cf end 0x7ab3)
v_l6f9bh:
l078cfh:
    defb 000h                  ;78cf 00  . 
l078d0h:
    defb 000h                  ;78d0 00  . 
v_l6f9dh:
    defb 000h                  ;78d1 00  . 
    defb 000h                  ;78d2 00  . 
    defb 000h                  ;78d3 00  . 
    defb 000h                  ;78d4 00  . 
    defb 000h                  ;78d5 00  . 
    defb 000h                  ;78d6 00  . 
    defb 000h                  ;78d7 00  . 
    defb 000h                  ;78d8 00  . 
v_l6fa5h:
l078d9h:
    defb 03ah                  ;78d9 3a  : 
vr_l06fa6h:
l078dah:
    defb 05ch                  ;78da 5c  \ 
l078dbh:
    defb 000h                  ;78db 00  . 
l078dch:
    defb 000h                  ;78dc 00  . 
v_l6fa9h:
l078ddh:
    defb 0ffh                  ;78dd ff  . 
l078deh:
    defb 0afh                  ;78de af  . 
v_l6fabh:
l078dfh:
    defb 001h                  ;78df 01  . 
vr_l06fach:
l078e0h:
    defb 001h                  ;78e0 01  . 
l078e1h:
    defb 000h                  ;78e1 00  . 
l078e2h:
    defb 000h                  ;78e2 00  . 
v_l6fafh:
l078e3h:
    defb 000h                  ;78e3 00  . 
l078e4h:
    defb 000h                  ;78e4 00  . 
v_l6fb1h:
l078e5h:
    defb 000h                  ;78e5 00  . 
    defb 000h                  ;78e6 00  . 
v_l6fb3h:
l078e7h:
    defb 000h                  ;78e7 00  . 
    defb 000h                  ;78e8 00  . 
l078e9h:
    defb 000h                  ;78e9 00  . 
    defb 000h                  ;78ea 00  . 
l078ebh:
    defb 000h                  ;78eb 00  . 
    defb 000h                  ;78ec 00  . 
v_l6fb9h:
    defb 01bh                  ;78ed 1b  . 
    defb 0ffh                  ;78ee ff  . 
    defb 0e3h                  ;78ef e3  . 
    defb 00dh                  ;78f0 0d  . 
    defb 0ffh                  ;78f1 ff  . 
    defb 0e3h                  ;78f2 e3  . 
    defb 01dh                  ;78f3 1d  . 
    defb 0ffh                  ;78f4 ff  . 
    defb 0e3h                  ;78f5 e3  . 
    defb 02dh                  ;78f6 2d  - 
    defb 0ffh                  ;78f7 ff  . 
    defb 0c9h                  ;78f8 c9  . 
    defb 00dh                  ;78f9 0d  . 
    defb 0cfh                  ;78fa cf  . 
    defb 0c1h                  ;78fb c1  . 
    defb 00dh                  ;78fc 0d  . 
v_l6fc9h:
    defb 0c7h                  ;78fd c7  . 
    defb 0c0h                  ;78fe c0  . 
    defb 00dh                  ;78ff 0d  . 
    defb 0f7h                  ;7900 f7  . 
    defb 0a0h                  ;7901 a0  . 
    defb 042h                  ;7902 42  B 
    defb 0c7h                  ;7903 c7  . 
v_l6fd0h:
    defb 086h                  ;7904 86  . 
    defb 014h                  ;7905 14  . 
    defb 0c7h                  ;7906 c7  . 
    defb 086h                  ;7907 86  . 
    defb 023h                  ;7908 23  # 
    defb 0c7h                  ;7909 c7  . 
    defb 086h                  ;790a 86  . 
    defb 002h                  ;790b 02  . 
    defb 0cfh                  ;790c cf  . 
    defb 04bh                  ;790d 4b  K 
    defb 04fh                  ;790e 4f  O 
    defb 0c7h                  ;790f c7  . 
    defb 046h                  ;7910 46  F 
    defb 014h                  ;7911 14  . 
    defb 0c7h                  ;7912 c7  . 
    defb 046h                  ;7913 46  F 
    defb 023h                  ;7914 23  # 
    defb 0c7h                  ;7915 c7  . 
    defb 046h                  ;7916 46  F 
    defb 002h                  ;7917 02  . 
    defb 0f7h                  ;7918 f7  . 
    defb 045h                  ;7919 45  E 
    defb 045h                  ;791a 45  E 
    defb 0ffh                  ;791b ff  . 
    defb 03ah                  ;791c 3a  : 
    defb 007h                  ;791d 07  . 
    defb 0feh                  ;791e fe  . 
    defb 034h                  ;791f 34  4 
    defb 014h                  ;7920 14  . 
    defb 0feh                  ;7921 fe  . 
    defb 034h                  ;7922 34  4 
    defb 023h                  ;7923 23  # 
    defb 0feh                  ;7924 fe  . 
    defb 034h                  ;7925 34  4 
    defb 002h                  ;7926 02  . 
    defb 0ffh                  ;7927 ff  . 
    defb 02ah                  ;7928 2a  * 
    defb 00fh                  ;7929 0f  . 
    defb 0ffh                  ;792a ff  . 
    defb 02ah                  ;792b 2a  * 
    defb 01fh                  ;792c 1f  . 
    defb 0ffh                  ;792d ff  . 
    defb 02ah                  ;792e 2a  * 
    defb 02fh                  ;792f 2f  / 
    defb 0ffh                  ;7930 ff  . 
    defb 01ah                  ;7931 1a  . 
    defb 001h                  ;7932 01  . 
    defb 0ffh                  ;7933 ff  . 
    defb 00ah                  ;7934 0a  . 
    defb 000h                  ;7935 00  . 
    defb 087h                  ;7936 87  . 
    defb 006h                  ;7937 06  . 
    defb 094h                  ;7938 94  . 
    defb 087h                  ;7939 87  . 
    defb 006h                  ;793a 06  . 
    defb 0a3h                  ;793b a3  . 
    defb 087h                  ;793c 87  . 
    defb 006h                  ;793d 06  . 
    defb 082h                  ;793e 82  . 
v_l700bh:
    defb 01eh                  ;793f 1e  . 
    defb 0ffh                  ;7940 ff  . 
    defb 0e3h                  ;7941 e3  . 
    defb 00dh                  ;7942 0d  . 
    defb 0ffh                  ;7943 ff  . 
    defb 0e3h                  ;7944 e3  . 
    defb 01dh                  ;7945 1d  . 
    defb 0ffh                  ;7946 ff  . 
    defb 0e3h                  ;7947 e3  . 
    defb 02dh                  ;7948 2d  - 
    defb 0ffh                  ;7949 ff  . 
    defb 0cdh                  ;794a cd  . 
    defb 00eh                  ;794b 0e  . 
    defb 0c7h                  ;794c c7  . 
    defb 0c7h                  ;794d c7  . 
    defb 00eh                  ;794e 0e  . 
    defb 0cfh                  ;794f cf  . 
    defb 0c5h                  ;7950 c5  . 
    defb 00eh                  ;7951 0e  . 
    defb 0c7h                  ;7952 c7  . 
    defb 0c4h                  ;7953 c4  . 
    defb 00eh                  ;7954 0e  . 
    defb 0f7h                  ;7955 f7  . 
    defb 0a0h                  ;7956 a0  . 
    defb 041h                  ;7957 41  A 
    defb 087h                  ;7958 87  . 
    defb 086h                  ;7959 86  . 
    defb 094h                  ;795a 94  . 
    defb 087h                  ;795b 87  . 
    defb 086h                  ;795c 86  . 
    defb 0a3h                  ;795d a3  . 
    defb 087h                  ;795e 87  . 
    defb 086h                  ;795f 86  . 
    defb 082h                  ;7960 82  . 
    defb 0f8h                  ;7961 f8  . 
    defb 070h                  ;7962 70  p 
    defb 014h                  ;7963 14  . 
    defb 0f8h                  ;7964 f8  . 
    defb 070h                  ;7965 70  p 
    defb 023h                  ;7966 23  # 
    defb 0f8h                  ;7967 f8  . 
    defb 070h                  ;7968 70  p 
    defb 002h                  ;7969 02  . 
    defb 0cfh                  ;796a cf  . 
    defb 043h                  ;796b 43  C 
    defb 04fh                  ;796c 4f  O 
    defb 0ffh                  ;796d ff  . 
    defb 036h                  ;796e 36  6 
    defb 014h                  ;796f 14  . 
    defb 0ffh                  ;7970 ff  . 
    defb 036h                  ;7971 36  6 
    defb 023h                  ;7972 23  # 
    defb 0ffh                  ;7973 ff  . 
    defb 036h                  ;7974 36  6 
    defb 002h                  ;7975 02  . 
    defb 0feh                  ;7976 fe  . 
    defb 034h                  ;7977 34  4 
    defb 014h                  ;7978 14  . 
    defb 0feh                  ;7979 fe  . 
    defb 034h                  ;797a 34  4 
    defb 023h                  ;797b 23  # 
    defb 0feh                  ;797c fe  . 
    defb 034h                  ;797d 34  4 
    defb 002h                  ;797e 02  . 
    defb 0ffh                  ;797f ff  . 
    defb 032h                  ;7980 32  2 
    defb 007h                  ;7981 07  . 
    defb 0ffh                  ;7982 ff  . 
    defb 022h                  ;7983 22  " 
    defb 00fh                  ;7984 0f  . 
    defb 0ffh                  ;7985 ff  . 
    defb 022h                  ;7986 22  " 
    defb 01fh                  ;7987 1f  . 
    defb 0ffh                  ;7988 ff  . 
    defb 022h                  ;7989 22  " 
    defb 02fh                  ;798a 2f  / 
    defb 0ffh                  ;798b ff  . 
    defb 012h                  ;798c 12  . 
    defb 001h                  ;798d 01  . 
    defb 0c7h                  ;798e c7  . 
    defb 006h                  ;798f 06  . 
    defb 094h                  ;7990 94  . 
    defb 0c7h                  ;7991 c7  . 
    defb 006h                  ;7992 06  . 
    defb 0a3h                  ;7993 a3  . 
    defb 0c7h                  ;7994 c7  . 
    defb 006h                  ;7995 06  . 
    defb 082h                  ;7996 82  . 
    defb 0ffh                  ;7997 ff  . 
    defw ENTRY_POINT_WITH_MONITOR+2                            ;7998
v_l7066h:
    defb 00eh                  ;799a 0e  . 
    defb 0ffh                  ;799b ff  . 
    defb 0e9h                  ;799c e9  . 
    defb 016h                  ;799d 16  . 
    defb 0ffh                  ;799e ff  . 
    defb 0e9h                  ;799f e9  . 
    defb 025h                  ;79a0 25  % 
    defb 0ffh                  ;79a1 ff  . 
    defb 0e9h                  ;79a2 e9  . 
    defb 004h                  ;79a3 04  . 
    defb 0ffh                  ;79a4 ff  . 
    defb 0cdh                  ;79a5 cd  . 
    defb 001h                  ;79a6 01  . 
    defb 0ffh                  ;79a7 ff  . 
    defb 0c9h                  ;79a8 c9  . 
    defb 002h                  ;79a9 02  . 
    defb 0c7h                  ;79aa c7  . 
    defb 0c7h                  ;79ab c7  . 
    defb 003h                  ;79ac 03  . 
    defb 0c7h                  ;79ad c7  . 
    defb 0c4h                  ;79ae c4  . 
    defb 001h                  ;79af 01  . 
    defb 0ffh                  ;79b0 ff  . 
    defb 0c3h                  ;79b1 c3  . 
    defb 001h                  ;79b2 01  . 
    defb 0c7h                  ;79b3 c7  . 
    defb 0c2h                  ;79b4 c2  . 
    defb 001h                  ;79b5 01  . 
    defb 0c7h                  ;79b6 c7  . 
    defb 0c0h                  ;79b7 c0  . 
    defb 002h                  ;79b8 02  . 
    defb 0f7h                  ;79b9 f7  . 
    defb 045h                  ;79ba 45  E 
    defb 047h                  ;79bb 47  G 
    defb 0e7h                  ;79bc e7  . 
    defb 020h                  ;79bd 20    
    defb 000h                  ;79be 00  . 
    defb 0ffh                  ;79bf ff  . 
    defb 018h                  ;79c0 18  . 
    defb 000h                  ;79c1 00  . 
    defb 0ffh                  ;79c2 ff  . 
    defb 010h                  ;79c3 10  . 
    defb 000h                  ;79c4 00  . 
    defb 01ah                  ;79c5 1a  . 
    defb 01fh                  ;79c6 1f  . 
    defb 023h                  ;79c7 23  # 
    defb 026h                  ;79c8 26  & 
    defb 02bh                  ;79c9 2b  + 
    defb 02ch                  ;79ca 2c  , 
    defb 03dh                  ;79cb 3d  = 
    defb 03fh                  ;79cc 3f  ? 
    defb 041h                  ;79cd 41  A 
    defb 043h                  ;79ce 43  C 
    defb 045h                  ;79cf 45  E 
    defb 047h                  ;79d0 47  G 
    defb 04ah                  ;79d1 4a  J 
    defb 053h                  ;79d2 53  S 
    defb 055h                  ;79d3 55  U 
    defb 05dh                  ;79d4 5d  ] 
    defb 061h                  ;79d5 61  a 
    defb 066h                  ;79d6 66  f 
    defb 06dh                  ;79d7 6d  m 
    defb 073h                  ;79d8 73  s 
    defb 076h                  ;79d9 76  v 
    defb 079h                  ;79da 79  y 
    defb 080h                  ;79db 80  . 
    defb 083h                  ;79dc 83  . 
    defb 084h                  ;79dd 84  . 
    defb 089h                  ;79de 89  . 
    defb "Lengt",0xe8          ;"h"+0x80                       ;79df
    defb "Firs",0xf4           ;"t"+0x80                       ;79e5
    defb "Las",0xf4            ;"t"+0x80                       ;79ea
    defb "Memor",0xf9          ;"y"+0x80                       ;79ee
    defb "l",0xe4              ;"d"+0x80                       ;79f4
    defb " UNIVERSUM Contro",0xec                              ;"l"+0x80                       ;79f6
    defb "ON",0xa0             ;" "+0x80                       ;7a08
    defb "OF",0xc6             ;"F"+0x80                       ;7a0b
    defb "NO",0xce             ;"N"+0x80                       ;7a0e
    defb "DE",0xc6             ;"F"+0x80                       ;7a11
    defb "AL",0xcc             ;"L"+0x80                       ;7a14
    defb "Cal",0xec            ;"l"+0x80                       ;7a17
    defb "Read/Writ",0xe5      ;"e"+0x80                       ;7a1b
    defb "Ru",0xee             ;"n"+0x80                       ;7a25
    defb "Interrup",0xf4       ;"t"+0x80                       ;7a28
    defb "ERRO",0xd2           ;"R"+0x80                       ;7a31
    defb "No ru",0xee          ;"n"+0x80                       ;7a36
    defb "No writ",0xe5        ;"e"+0x80                       ;7a3c
    defb "No rea",0xe4         ;"d"+0x80                       ;7a44
    defb "Def",0xe2            ;"b"+0x80                       ;7a4b
    defb "Def",0xf7            ;"w"+0x80                       ;7a4f
    defb "windows",0xba        ;":"+0x80                       ;7a53
    defb "Wit",0xe8            ;"h"+0x80                       ;7a5b
    defb "T",0xef              ;"o"+0x80                       ;7a5f
    defb "Leade",0xf2          ;"r"+0x80                       ;7a61
l07a67h:
    defb "1. byte",0xba        ;":"+0x80                       ;7a67
    defb 000h                  ;7a6f 00  . 
    defb 000h                  ;7a70 00  . 
    defb 000h                  ;7a71 00  . 
    defb 000h                  ;7a72 00  . 
    defb 000h                  ;7a73 00  . 
    defb 000h                  ;7a74 00  . 
    defb 000h                  ;7a75 00  . 
    defb 000h                  ;7a76 00  . 
    defb 000h                  ;7a77 00  . 
    defb 000h                  ;7a78 00  . 
    defb 000h                  ;7a79 00  . 
    defb 000h                  ;7a7a 00  . 
    defb 000h                  ;7a7b 00  . 

; =====================================================================
;ENTRY_POINT_WITHOUT_MONITOR

    jp  v_l7cc9h               ;7a7c 

    defw invokeAssembly        ;7a7f
    defw invokeBasic           ;7a81
    defw invokeCopy            ;7a83
    defw invokeDelete          ;7a85
    defw invokeE               ;7a87
    defw invokeFind            ;7a89
    defw invokeGens            ;7a8b
    defw invokeH               ;7a8d
    defw invokeI               ;7a8f
    defw invokeJ               ;7a91
    defw invokeK               ;7a93
    defw invokeLoad            ;7a95
    defw invokeMonitor         ;7a97
    defw ROM_NEWCommandRoutine                                 ;7a99
    defw ROM_NEWCommandRoutine                                 ;7a9b
    defw invokePrint           ;7a9d
    defw invokeQuit            ;7a9f
    defw invokeRun             ;7aa1
    defw invokeSave            ;7aa3
    defw invokeTable           ;7aa5
    defw invokeUTop            ;7aa7
    defw invokeVerify          ;7aa9
    defw invokeW               ;7aab
    defw invokeClear           ;7aad                           ;key X
    defw invokeClear2          ;7aaf                           ;key Y
    defw invokeReplace         ;7ab1                           ;key Z
invokeK:
        ld hl,l0a55ch                                          ;7ab3 21 68 3e  ! h > 
l7ab6h:
    ld (v_sub_826ch+1),hl      ;7ab6 22 ad 24  " . $ 
    ret                        ;7ab9 c9  . 
invokeE:
    call v_sub_718eh           ;7aba cd ce 13  . . . 
    call v_sub_8235h           ;7abd cd 75 24  . u $ 
    jr l7ab6h                  ;7ac0 18 f4  . . 
v_sub_718eh:
    ld hl,(vr_l087d6h+1)       ;7ac2 2a 17 2a  * . * 
    ld de,0fff4h               ;7ac5 11 f4 ff  . . . 
    add hl,de                  ;7ac8 19  . 
    ret                        ;7ac9 c9  . 
invokeUTop:
    call v_l719dh              ;7aca cd dd 13  . . . 
    ld (vr_l07945h+1),hl       ;7acd 22 86 1b  " . . 
    ret                        ;7ad0 c9  . 
v_l719dh:
    ld hl,inputBufferStart+1   ;7ad1 21 40 2d  ! @ - 
v_sub_71a0h:
    ld de,v_l8ad1h             ;7ad4 11 11 2d  . . - 
    push de                    ;7ad7 d5  . 
    ld c,01eh                  ;7ad8 0e 1e  . . 
    call v_sub_8577h           ;7ada cd b7 27  . . ' 
    pop de                     ;7add d1  . 
    ld hl,00000h               ;7ade 21 00 00  ! . . 
    ld a,02bh                  ;7ae1 3e 2b  > + 
    ld ix,v_l8aa5h             ;7ae3 dd 21 e5 2c  . ! . , 
l7ae7h:
    push hl                    ;7ae7 e5  . 
    push af                    ;7ae8 f5  . 
    call v_sub_8492h           ;7ae9 cd d2 26  . . & 
    jp c,syntaxError           ;7aec da c9 22  . . " 
    cp 02bh                    ;7aef fe 2b  . + 
    jr z,l7afah                ;7af1 28 07  ( . 
    ld (vr_l07208h+1),a        ;7af3 32 49 14  2 I . 
    cp 02dh                    ;7af6 fe 2d  . - 
    jr nz,l7afdh               ;7af8 20 03    . 
l7afah:
    call v_sub_8492h           ;7afa cd d2 26  . . & 
l7afdh:
    cp 024h                    ;7afd fe 24  . $ 
    ld hl,(v_l7953h+1)         ;7aff 2a 94 1b  * . . 
    jr z,l7b31h                ;7b02 28 2d  ( - 
    call potencialCommandKeyPressed                            ;7b04 cd 6e 29  . n ) 
    jr nz,l7b36h               ;7b07 20 2d    - 
    dec de                     ;7b09 1b  . 
    push de                    ;7b0a d5  . 
    push ix                    ;7b0b dd e5  . . 
    ex de,hl                   ;7b0d eb  . 
    call v_sub_87aah           ;7b0e cd ea 29  . . ) 
    ld a,009h                  ;7b11 3e 09  > . 
    jp c,v_l809ah              ;7b13 da da 22  . . " 
    pop ix                     ;7b16 dd e1  . . 
    ex de,hl                   ;7b18 eb  . 
    call v_sub_8116h           ;7b19 cd 56 23  . V # 
    ld a,(hl)                  ;7b1c 7e  ~ 
    and 0c0h                   ;7b1d e6 c0  . . 
    ld a,009h                  ;7b1f 3e 09  > . 
    jp z,v_l809ah              ;7b21 ca da 22  . . " 
    dec de                     ;7b24 1b  . 
    ex de,hl                   ;7b25 eb  . 
    ld d,(hl)                  ;7b26 56  V 
    dec hl                     ;7b27 2b  + 
    ld e,(hl)                  ;7b28 5e  ^ 
    pop bc                     ;7b29 c1  . 
    ld hl,(v_l8ac7h)           ;7b2a 2a 07 2d  * . - 
    ld h,000h                  ;7b2d 26 00  & . 
    add hl,bc                  ;7b2f 09  . 
    ex de,hl                   ;7b30 eb  . 
l7b31h:
    call v_sub_8492h           ;7b31 cd d2 26  . . & 
    jr l7b39h                  ;7b34 18 03  . . 
l7b36h:
    call v_sub_8419h           ;7b36 cd 59 26  . Y & 
l7b39h:
    push af                    ;7b39 f5  . 
    push de                    ;7b3a d5  . 
    ex de,hl                   ;7b3b eb  . 
vr_l07208h:
    ld a,032h                  ;7b3c 3e 32  > 2 
    call v_sub_7b50h           ;7b3e cd 90 1d  . . . 
    pop hl                     ;7b41 e1  . 
    pop bc                     ;7b42 c1  . 
    pop af                     ;7b43 f1  . 
    ex (sp),hl                 ;7b44 e3  . 
    push bc                    ;7b45 c5  . 
    call v_sub_7b0fh           ;7b46 cd 4f 1d  . O . 
    pop af                     ;7b49 f1  . 
    pop de                     ;7b4a d1  . 
    ret c                      ;7b4b d8  . 
    jr l7ae7h                  ;7b4c 18 99  . . 
v_sub_721ah:
    push hl                    ;7b4e e5  . 
    call v_sub_898ah           ;7b4f cd ca 2b  . . + 
l7b52h:
        ld hl,l0a55ch                                          ;7b52 21 68 3e  ! h > 
    call v_sub_8a2fh           ;7b55 cd 6f 2c  . o , 
    jr c,l7b63h                ;7b58 38 09  8 . 
    ld d,h                     ;7b5a 54  T 
    ld e,l                     ;7b5b 5d  ] 
    ld c,002h                  ;7b5c 0e 02  . . 
    call v_sub_8a6ch           ;7b5e cd ac 2c  . . , 
    jr l7b52h                  ;7b61 18 ef  . . 
l7b63h:
    pop hl                     ;7b63 e1  . 
    ret                        ;7b64 c9  . 
invokeReplace:
    ld b,03ah                  ;7b65 06 3a  . : 
    call v_sub_7c2ch           ;7b67 cd 6c 1e  . l . 
        ld de,l07cdbh+2                                        ;7b6a 11 e9 15  . . . 
    call z,v_sub_7304h         ;7b6d cc 44 15  . D . 
    ld ix,(v_sub_826ch+1)      ;7b70 dd 2a ad 24  . * . $ 
    ld (vr_l072ddh+1),ix       ;7b74 dd 22 1e 15  . " . . 
    call v_sub_8135h           ;7b78 cd 75 23  . u # 
    ld hl,v_l8aa5h             ;7b7b 21 e5 2c  ! . , 
    ld de,inputBufferStart     ;7b7e 11 3f 2d  . ? - 
    ld a,001h                  ;7b81 3e 01  > . 
    ld (de),a                  ;7b83 12  . 
    inc de                     ;7b84 13  . 
    ld c,01fh                  ;7b85 0e 1f  . . 
l7b87h:
    push hl                    ;7b87 e5  . 
    push de                    ;7b88 d5  . 
    ex de,hl                   ;7b89 eb  . 
    call v_sub_7379h           ;7b8a cd b9 15  . . . 
    pop de                     ;7b8d d1  . 
    jr nc,l7ba8h               ;7b8e 30 18  0 . 
        ld hl,l07cdbh+1                                        ;7b90 21 e8 15  ! . . 
    ld b,(hl)                  ;7b93 46  F 
l7b94h:
    inc hl                     ;7b94 23  # 
    ld a,(hl)                  ;7b95 7e  ~ 
    call v_sub_7c9bh           ;7b96 cd db 1e  . . . 
    djnz l7b94h                ;7b99 10 f9  . . 
    pop hl                     ;7b9b e1  . 
    ld a,(v_l738dh)            ;7b9c 3a cd 15  : . . 
    ld b,a                     ;7b9f 47  G 
l7ba0h:
    call atHLorNextIfOne       ;7ba0 cd ee 27  . . ' 
    inc hl                     ;7ba3 23  # 
    djnz l7ba0h                ;7ba4 10 fa  . . 
    jr l7b87h                  ;7ba6 18 df  . . 
l7ba8h:
    pop hl                     ;7ba8 e1  . 
    call atHLorNextIfOne       ;7ba9 cd ee 27  . . ' 
    inc hl                     ;7bac 23  # 
    or a                       ;7bad b7  . 
    jr z,l7bb5h                ;7bae 28 05  ( . 
    call v_sub_7c9bh           ;7bb0 cd db 1e  . . . 
    jr l7b87h                  ;7bb3 18 d2  . . 
l7bb5h:
    inc a                      ;7bb5 3c  < 
    ld (de),a                  ;7bb6 12  . 
    ld (vr_l07e1eh+1),a        ;7bb7 32 5f 20  2 _   
    dec a                      ;7bba 3d  = 
    inc c                      ;7bbb 0c  . 
l7bbch:
    ld (de),a                  ;7bbc 12  . 
    dec c                      ;7bbd 0d  . 
    jr nz,l7bbch               ;7bbe 20 fc    . 
    ld hl,v_l7295h             ;7bc0 21 d5 14  ! . . 
    ld (vr_l07e38h+1),hl       ;7bc3 22 79 20  " y   
    jp v_l7dddh                ;7bc6 c3 1d 20  . .   
v_l7295h:
    ld hl,v_l7ccfh             ;7bc9 21 0f 1f  ! . . 
    ld (vr_l07e38h+1),hl       ;7bcc 22 79 20  " y   
    call v_sub_72d4h           ;7bcf cd 14 15  . . . 
    jp v_l7e34h                ;7bd2 c3 74 20  . t   
invokeFind:
    ld hl,(v_sub_826ch+1)      ;7bd5 2a ad 24  * . $ 
    ld (vr_l072ddh+1),hl       ;7bd8 22 1e 15  " . . 
    ld b,053h                  ;7bdb 06 53  . S 
    call v_sub_7c2ch           ;7bdd cd 6c 1e  . l . 
    jr nz,l7bf2h               ;7be0 20 10    . 
    xor a                      ;7be2 af  . 
l7be3h:
        ld de,l0a55ah                                          ;7be3 11 66 3e  . f > 
    ld (vr_l072ddh+1),de       ;7be6 ed 53 1e 15  . S . . 
    ld (vr_l072edh+1),a        ;7bea 32 2e 15  2 . . 
    call v_sub_7c2fh           ;7bed cd 6f 1e  . o . 
    jr l7bfdh                  ;7bf0 18 0b  . . 
l7bf2h:
    ld b,042h                  ;7bf2 06 42  . B 
    call v_sub_7c33h           ;7bf4 cd 73 1e  . s . 
    jr nz,l7bfdh               ;7bf7 20 04    . 
    ld a,001h                  ;7bf9 3e 01  > . 
    jr l7be3h                  ;7bfb 18 e6  . . 
l7bfdh:
    ld b,03ah                  ;7bfd 06 3a  . : 
    call v_sub_7c33h           ;7bff cd 73 1e  . s . 
    ld de,v_l738eh             ;7c02 11 ce 15  . . . 
    call z,v_sub_7304h         ;7c05 cc 44 15  . D . 
v_sub_72d4h:
    call v_sub_89f2h           ;7c08 cd 32 2c  . 2 , 
    ld hl,v_l736ch             ;7c0b 21 ac 15  ! . . 
l7c0eh:
    ld (vr_l072fah+1),hl       ;7c0e 22 3b 15  "               ; . 
l7c11h:
vr_l072ddh:
        ld hl,l0a55ch                                          ;7c11 21 68 3e  ! h > 
    call v_sub_8248h           ;7c14 cd 88 24  . . $ 
    ld (vr_l072ddh+1),hl       ;7c17 22 1e 15  " . . 
    call v_sub_8a2fh           ;7c1a cd 6f 2c  . o , 
    ret nc                     ;7c1d d0  . 
    push hl                    ;7c1e e5  . 
    pop ix                     ;7c1f dd e1  . . 
vr_l072edh:
    ld a,000h                  ;7c21 3e 00  > . 
    or a                       ;7c23 b7  . 
    jr z,l7c2bh                ;7c24 28 05  ( . 
    call v_sub_80f5h           ;7c26 cd 35 23  . 5 # 
    jr c,l7c36h                ;7c29 38 0b  8 . 
l7c2bh:
    call v_sub_8135h           ;7c2b cd 75 23  . u # 
vr_l072fah:
    call v_l736ch              ;7c2e cd ac 15  . . . 
    ld hl,(vr_l072ddh+1)       ;7c31 2a 1e 15  * . . 
    jr c,l7c9ch                ;7c34 38 66  8 f 
l7c36h:
    jr l7c11h                  ;7c36 18 d9  . . 
v_sub_7304h:
    ld b,000h                  ;7c38 06 00  . . 
    push de                    ;7c3a d5  . 
l7c3bh:
    call atHLorNextIfOne       ;7c3b cd ee 27  . . ' 
    inc hl                     ;7c3e 23  # 
    or a                       ;7c3f b7  . 
    jr z,l7c49h                ;7c40 28 07  ( . 
    or 020h                    ;7c42 f6 20  .   
    ld (de),a                  ;7c44 12  . 
    inc de                     ;7c45 13  . 
    inc b                      ;7c46 04  . 
    jr l7c3bh                  ;7c47 18 f2  . . 
l7c49h:
    pop hl                     ;7c49 e1  . 
    dec hl                     ;7c4a 2b  + 
    ld (hl),b                  ;7c4b 70  p 
    ret                        ;7c4c c9  . 
invokePrint:
    call v_sub_7c2ah           ;7c4d cd 6a 1e  . j . 
    ld a,000h                  ;7c50 3e 00  > . 
    jr nz,l7c55h               ;7c52 20 01    . 
    inc a                      ;7c54 3c  < 
l7c55h:
    ld (vr_l072edh+1),a        ;7c55 32 2e 15  2 . . 
        ld hl,l0a55ah                                          ;7c58 21 66 3e  ! f > 
    ld (vr_l072ddh+1),hl       ;7c5b 22 1e 15  " . . 
    ld hl,v_l732fh             ;7c5e 21 6f 15  ! o . 
    jr l7c0eh                  ;7c61 18 ab  . . 
v_l732fh:
    call v_sub_7bbch           ;7c63 cd fc 1d  . . . 
v_l7332h:
    ld a,003h                  ;7c66 3e 03  > . 
    call ROM_ChannelOpen       ;7c68 cd 01 16  . . . 
    ei                         ;7c6b fb  . 
    ld hl,00010h               ;7c6c 21 10 00  ! . . 
    call v_sub_82a3h           ;7c6f cd e3 24  . . $ 
    ld a,00dh                  ;7c72 3e 0d  > . 
    rst 10h                    ;7c74 d7  . 
    xor a                      ;7c75 af  . 
    ret                        ;7c76 c9  . 
v_sub_7343h:
invokeDelete:
    call v_sub_080e7h          ;7c77 cd 27 23  . ' # 
    ld bc,00001h               ;7c7a 01 01 00  . . . 
l7c7dh:
    push hl                    ;7c7d e5  . 
    and a                      ;7c7e a7  . 
    sbc hl,de                  ;7c7f ed 52  . R 
    pop hl                     ;7c81 e1  . 
    jr nc,l7c8ah               ;7c82 30 06  0 . 
    inc bc                     ;7c84 03  . 
    call v_sub_8248h           ;7c85 cd 88 24  . . $ 
    jr l7c7dh                  ;7c88 18 f3  . . 
l7c8ah:
    call v_sub_080e7h          ;7c8a cd 27 23  . ' # 
    call v_sub_721ah           ;7c8d cd 5a 14  . Z . 
    call v_sub_8a2fh           ;7c90 cd 6f 2c  . o , 
    call z,v_sub_8235h         ;7c93 cc 75 24  . u $ 
    ld (vr_l080e7h+1),hl       ;7c96 22 28 23  " ( # 
    ld (vr_l080eah+1),hl       ;7c99 22 2b 23  " + # 
l7c9ch:
    ld (v_sub_826ch+1),hl      ;7c9c 22 ad 24  " . $ 
    ret                        ;7c9f c9  . 
v_l736ch:
    ld de,v_l8aa5h             ;7ca0 11 e5 2c  . . , 
l7ca3h:
    push de                    ;7ca3 d5  . 
    call v_sub_7379h           ;7ca4 cd b9 15  . . . 
    pop de                     ;7ca7 d1  . 
    ret c                      ;7ca8 d8  . 
    inc de                     ;7ca9 13  . 
    jr nz,l7ca3h               ;7caa 20 f7    . 
    ret                        ;7cac c9  . 
v_sub_7379h:
    ld hl,v_l738dh             ;7cad 21 cd 15  ! . . 
    ld b,(hl)                  ;7cb0 46  F 
l7cb1h:
    inc hl                     ;7cb1 23  # 
l7cb2h:
    ld a,(de)                  ;7cb2 1a  . 
    inc de                     ;7cb3 13  . 
    dec a                      ;7cb4 3d  = 
    jr z,l7cb2h                ;7cb5 28 fb  ( . 
    inc a                      ;7cb7 3c  < 
    ret z                      ;7cb8 c8  . 
    xor (hl)                   ;7cb9 ae  . 
    and 0dfh                   ;7cba e6 df  . . 
    ret nz                     ;7cbc c0  . 
    djnz l7cb1h                ;7cbd 10 f2  . . 
    scf                        ;7cbf 37  7 
    ret                        ;7cc0 c9  . 
v_l738dh:
    nop                        ;7cc1 00  . 
v_l738eh:
    add a,d                    ;7cc2 82  . 
    ld l,c                     ;7cc3 69  i 
    jp nz,00009h               ;7cc4 c2 09 00  . . . 
    ex de,hl                   ;7cc7 eb  . 
    ex af,af'                  ;7cc8 08  . 
    add a,d                    ;7cc9 82  . 
    ld l,c                     ;7cca 69  i 
    jp nz,00318h               ;7ccb c2 18 03  . . . 
    nop                        ;7cce 00  . 
    ld a,b                     ;7ccf 78  x 
    ld l,a                     ;7cd0 6f  o 
    ld (hl),e                  ;7cd1 73  s 
    ld h,l                     ;7cd2 65  e 
    ld h,(hl)                  ;7cd3 66  f 
    ld (hl),e                  ;7cd4 73  s 
    jr nc,$-59                 ;7cd5 30 c3  0 . 
    push de                    ;7cd7 d5  . 
    ex af,af'                  ;7cd8 08  . 
    add a,d                    ;7cd9 82  . 
    ld l,d                     ;7cda 6a  j 
l07cdbh:
    jp nz,00000h               ;7cdb c2 00 00  . . . 
    nop                        ;7cde 00  . 
    ld (bc),a                  ;7cdf 02  . 
    add a,b                    ;7ce0 80  . 
    ret c                      ;7ce1 d8  . 
    jp nz,000c5h               ;7ce2 c2 c5 00  . . . 
    push bc                    ;7ce5 c5  . 
    nop                        ;7ce6 00  . 
    ex de,hl                   ;7ce7 eb  . 
    nop                        ;7ce8 00  . 
    ld hl,(0cd02h)             ;7ce9 2a 02 cd  * . . 
    ld hl,0c373h               ;7cec 21 73 c3  ! s . 
    xor (hl)                   ;7cef ae  . 
    ld l,c                     ;7cf0 69  i 
    ld (060a8h),a              ;7cf1 32 a8 60  2 . ` 
    ld a,010h                  ;7cf4 3e 10  > . 
v_sub_73c2h:
    ld (vr_l073d1h+1),a        ;7cf6 32 12 16  2 . . 
    ld a,010h                  ;7cf9 3e 10  > . 
v_l73c7h:
    push af                    ;7cfb f5  . 
    ex af,af'                  ;7cfc 08  . 
    ld a,b                     ;7cfd 78  x 
    or c                       ;7cfe b1  . 
    jp z,v_l7cc6h              ;7cff ca 06 1f  . . . 
    ex af,af'                  ;7d02 08  . 
    push bc                    ;7d03 c5  . 
    push hl                    ;7d04 e5  . 
vr_l073d1h:
    ld c,000h                  ;7d05 0e 00  . . 
    call ROM_PixelAddress_22b0                                 ;7d07 cd b0 22  . . " 
    ld (vr_l08787h+1),hl       ;7d0a 22 c8 29  " . ) 
    pop hl                     ;7d0d e1  . 
    push hl                    ;7d0e e5  . 
vr_l073dbh:
    ld de,00000h               ;7d0f 11 00 00  . . . 
    and a                      ;7d12 a7  . 
    sbc hl,de                  ;7d13 ed 52  . R 
    ex de,hl                   ;7d15 eb  . 
    ld hl,(vr_l087d6h+1)       ;7d16 2a 17 2a  * . * 
    ld c,(hl)                  ;7d19 4e  N 
    inc hl                     ;7d1a 23  # 
    ld b,(hl)                  ;7d1b 46  F 
l7d1ch:
    inc hl                     ;7d1c 23  # 
    ld a,(hl)                  ;7d1d 7e  ~ 
    inc hl                     ;7d1e 23  # 
    push hl                    ;7d1f e5  . 
    ld h,(hl)                  ;7d20 66  f 
    ld l,a                     ;7d21 6f  o 
    ld a,h                     ;7d22 7c  | 
    and 03fh                   ;7d23 e6 3f  . ? 
    ld h,a                     ;7d25 67  g 
    sbc hl,de                  ;7d26 ed 52  . R 
    pop hl                     ;7d28 e1  . 
    jr z,l7d35h                ;7d29 28 0a  ( . 
    dec bc                     ;7d2b 0b  . 
    ld a,b                     ;7d2c 78  x 
    or c                       ;7d2d b1  . 
    jr nz,l7d1ch               ;7d2e 20 ec    . 
    ld a,010h                  ;7d30 3e 10  > . 
    jp v_l809ah                ;7d32 c3 da 22  . . " 
l7d35h:
    ld c,(hl)                  ;7d35 4e  N 
    pop hl                     ;7d36 e1  . 
    ld e,(hl)                  ;7d37 5e  ^ 
    inc hl                     ;7d38 23  # 
    ld d,(hl)                  ;7d39 56  V 
    inc hl                     ;7d3a 23  # 
    push de                    ;7d3b d5  . 
    ex de,hl                   ;7d3c eb  . 
    ld hl,v_l8aa5h             ;7d3d 21 e5 2c  ! . , 
    ld (hl),020h               ;7d40 36 20  6   
    bit 7,c                    ;7d42 cb 79  . y 
    jr z,l7d48h                ;7d44 28 02  ( . 
    ld (hl),02ah               ;7d46 36 2a  6 * 
l7d48h:
    inc hl                     ;7d48 23  # 
    push bc                    ;7d49 c5  . 
    ld b,009h                  ;7d4a 06 09  . . 
    call v_sub_82d4h           ;7d4c cd 14 25  . . % 
    pop bc                     ;7d4f c1  . 
    ex de,hl                   ;7d50 eb  . 
    ex (sp),hl                 ;7d51 e3  . 
    ex de,hl                   ;7d52 eb  . 
    ld a,c                     ;7d53 79  y 
    and 0c0h                   ;7d54 e6 c0  . . 
    jr nz,l7d61h               ;7d56 20 09    . 
    ld bc,0052eh               ;7d58 01 2e 05  . . . 
    call atHLrepeatBTimesC     ;7d5b cd 21 25  . ! % 
    ld (hl),b                  ;7d5e 70  p 
    jr l7d6ah                  ;7d5f 18 09  . . 
l7d61h:
    push hl                    ;7d61 e5  . 
    pop ix                     ;7d62 dd e1  . . 
    ex de,hl                   ;7d64 eb  . 
    ld c,000h                  ;7d65 0e 00  . . 
    call v_sub_8908h           ;7d67 cd 48 2b  . H + 
l7d6ah:
    ld hl,v_l8aa5h             ;7d6a 21 e5 2c  ! . , 
    call v_sub_8a1bh           ;7d6d cd 5b 2c  . [ , 
vr_l0743ch:
    ld a,000h                  ;7d70 3e 00  > . 
    or a                       ;7d72 b7  . 
    call nz,v_l732fh           ;7d73 c4 6f 15  . o . 
    pop hl                     ;7d76 e1  . 
    pop bc                     ;7d77 c1  . 
    dec bc                     ;7d78 0b  . 
    pop af                     ;7d79 f1  . 
    add a,008h                 ;7d7a c6 08  . . 
    cp 0a9h                    ;7d7c fe a9  . . 
    jp c,v_l73c7h              ;7d7e da 07 16  . . . 
    ret                        ;7d81 c9  . 
l7d82h:
    ld b,050h                  ;7d82 06 50  . P 
    call v_sub_7c33h           ;7d84 cd 73 1e  . s . 
    ld a,001h                  ;7d87 3e 01  > . 
    jr z,l7d8ch                ;7d89 28 01  ( . 
    dec a                      ;7d8b 3d  = 
l7d8ch:
    ld (vr_l0743ch+1),a        ;7d8c 32 7d 16  2 } . 
    ld a,00eh                  ;7d8f 3e 0e  > . 
    call v_l89f4h              ;7d91 cd 34 2c  . 4 , 
    ld hl,05840h               ;7d94 21 40 58  ! @ X 
    ld a,038h                  ;7d97 3e 38  > 8 
    ex af,af'                  ;7d99 08  . 
    ld a,030h                  ;7d9a 3e 30  > 0 
    ld c,014h                  ;7d9c 0e 14  . . 
l7d9eh:
    ld b,020h                  ;7d9e 06 20  .   
l7da0h:
    ld (hl),a                  ;7da0 77  w 
    inc hl                     ;7da1 23  # 
    djnz l7da0h                ;7da2 10 fc  . . 
    ex af,af'                  ;7da4 08  . 
    dec c                      ;7da5 0d  . 
    jr nz,l7d9eh               ;7da6 20 f6    . 
    ld hl,(vr_l087d6h+1)       ;7da8 2a 17 2a  * . * 
    ld c,(hl)                  ;7dab 4e  N 
    inc hl                     ;7dac 23  # 
    ld b,(hl)                  ;7dad 46  F 
    inc hl                     ;7dae 23  # 
    add hl,bc                  ;7daf 09  . 
    add hl,bc                  ;7db0 09  . 
    ld (vr_l073dbh+1),hl       ;7db1 22 1c 16  " . . 
l7db4h:
    ld a,b                     ;7db4 78  x 
    or c                       ;7db5 b1  . 
    jr z,l7dd6h                ;7db6 28 1e  ( . 
    exx                        ;7db8 d9  . 
    ld a,010h                  ;7db9 3e 10  > . 
l7dbbh:
    push af                    ;7dbb f5  . 
    call v_sub_85f0h           ;7dbc cd 30 28  . 0 ( 
    pop af                     ;7dbf f1  . 
    add a,008h                 ;7dc0 c6 08  . . 
    cp 0a9h                    ;7dc2 fe a9  . . 
    jr c,l7dbbh                ;7dc4 38 f5  8 . 
    exx                        ;7dc6 d9  . 
    xor a                      ;7dc7 af  . 
    call v_sub_73c2h           ;7dc8 cd 02 16  . . . 
    ld a,088h                  ;7dcb 3e 88  > . 
    call v_sub_73c2h           ;7dcd cd 02 16  . . . 
    exx                        ;7dd0 d9  . 
    call v_sub_8639h           ;7dd1 cd 79 28  . y ( 
    cp 020h                    ;7dd4 fe 20  .   
l7dd6h:
    jp z,v_l7cc9h              ;7dd6 ca 09 1f  . . . 
    exx                        ;7dd9 d9  . 
    jr l7db4h                  ;7dda 18 d8  . . 
invokeTable:
    ld b,043h                  ;7ddc 06 43  . C 
    call v_sub_7c2ch           ;7dde cd 6c 1e  . l . 
    jr z,l7e1fh                ;7de1 28 3c  ( < 
    ld b,04ch                  ;7de3 06 4c  . L 
    call v_sub_7c33h           ;7de5 cd 73 1e  . s . 
    ld c,0feh                  ;7de8 0e fe  . . 
    jr z,l7df5h                ;7dea 28 09  ( . 
    ld b,055h                  ;7dec 06 55  . U 
    call v_sub_7c33h           ;7dee cd 73 1e  . s . 
    jr nz,l7d82h               ;7df1 20 8f    . 
    ld c,0beh                  ;7df3 0e be  . . 
l7df5h:
v_l74c1h:
    ld a,c                     ;7df5 79  y 
    ld (vr_l074d0h+1),a        ;7df6 32 11 17  2 . . 
    ld hl,(vr_l087d6h+1)       ;7df9 2a 17 2a  * . * 
    ld c,(hl)                  ;7dfc 4e  N 
    inc hl                     ;7dfd 23  # 
    ld b,(hl)                  ;7dfe 46  F 
    inc hl                     ;7dff 23  # 
l7e00h:
    ld a,b                     ;7e00 78  x 
    or c                       ;7e01 b1  . 
    ret z                      ;7e02 c8  . 
    inc hl                     ;7e03 23  # 
vr_l074d0h:
    set 7,(hl)                 ;7e04 cb fe  . . 
    inc hl                     ;7e06 23  # 
    dec bc                     ;7e07 0b  . 
    jr l7e00h                  ;7e08 18 f6  . . 
invokeClear: 
invokeClear2:
    ld b,079h                  ;7e0a 06 79  . y 
    call v_sub_7c2ch           ;7e0c cd 6c 1e  . l . 
    ret nz                     ;7e0f c0  . 
        ld hl,l0a55ch                                          ;7e10 21 68 3e  ! h > 
    ld (vr_l080e7h+1),hl       ;7e13 22 28 23  " ( # 
    call v_sub_718eh           ;7e16 cd ce 13  . . . 
    ld (vr_l080eah+1),hl       ;7e19 22 2b 23  " + # 
    call v_sub_7343h           ;7e1c cd 83 15  . . . 
l7e1fh:
    call v_sub_89f2h           ;7e1f cd 32 2c  . 2 , 
    ld c,0b6h                  ;7e22 0e b6  . . 
    call v_l74c1h              ;7e24 cd 01 17  . . . 
        ld hl,l0a55ch                                          ;7e27 21 68 3e  ! h > 
    call v_sub_75e9h           ;7e2a cd 29 18  . ) . 
l7e2dh:
    jr nc,l7e44h               ;7e2d 30 15  0 . 
    push hl                    ;7e2f e5  . 
    ld l,(hl)                  ;7e30 6e  n 
    and 07fh                   ;7e31 e6 7f  .  
    ld h,a                     ;7e33 67  g 
    add hl,hl                  ;7e34 29  ) 
    ld de,(vr_l087d6h+1)       ;7e35 ed 5b 17 2a  . [ . * 
    add hl,de                  ;7e39 19  . 
    inc hl                     ;7e3a 23  # 
    set 6,(hl)                 ;7e3b cb f6  . . 
    pop hl                     ;7e3d e1  . 
    inc hl                     ;7e3e 23  # 
    call v_sub_75f8h           ;7e3f cd 38 18  . 8 . 
    jr l7e2dh                  ;7e42 18 e9  . . 
l7e44h:
    ld hl,(vr_l087d6h+1)       ;7e44 2a 17 2a  * . * 
    ld c,(hl)                  ;7e47 4e  N 
    inc hl                     ;7e48 23  # 
    ld b,(hl)                  ;7e49 46  F 
    inc hl                     ;7e4a 23  # 
    push hl                    ;7e4b e5  . 
    add hl,bc                  ;7e4c 09  . 
    add hl,bc                  ;7e4d 09  . 
    ld (vr_l07539h+1),hl       ;7e4e 22 7a 17  " z . 
    pop hl                     ;7e51 e1  . 
l7e52h:
v_l751eh:
    ld a,b                     ;7e52 78  x 
    or c                       ;7e53 b1  . 
    jr nz,l7e5bh               ;7e54 20 05    . 
    ld c,0b6h                  ;7e56 0e b6  . . 
    jp v_l74c1h                ;7e58 c3 01 17  . . . 
l7e5bh:
    dec bc                     ;7e5b 0b  . 
    ld (vr_l075d4h+1),hl       ;7e5c 22 15 18  " . . 
    ld e,(hl)                  ;7e5f 5e  ^ 
    inc hl                     ;7e60 23  # 
    ld a,(hl)                  ;7e61 7e  ~ 
    and 0c0h                   ;7e62 e6 c0  . . 
    ld a,(hl)                  ;7e64 7e  ~ 
    inc hl                     ;7e65 23  # 
    jr nz,l7e52h               ;7e66 20 ea    . 
    and 03fh                   ;7e68 e6 3f  . ? 
    ld d,a                     ;7e6a 57  W 
    push bc                    ;7e6b c5  . 
    push hl                    ;7e6c e5  . 
vr_l07539h:
    ld hl,00000h               ;7e6d 21 00 00  ! . . 
    add hl,de                  ;7e70 19  . 
    ld (vr_l0758fh+1),de       ;7e71 ed 53 d0 17  . S . . 
    ld d,h                     ;7e75 54  T 
    ld e,l                     ;7e76 5d  ] 
    inc de                     ;7e77 13  . 
    inc de                     ;7e78 13  . 
l7e79h:
    ld a,(de)                  ;7e79 1a  . 
    inc de                     ;7e7a 13  . 
    rlca                       ;7e7b 07  . 
    jr nc,l7e79h               ;7e7c 30 fb  0 . 
    call v_sub_88e1h           ;7e7e cd 21 2b  . ! + 
    and a                      ;7e81 a7  . 
    sbc hl,de                  ;7e82 ed 52  . R 
    ld b,h                     ;7e84 44  D 
    ld c,l                     ;7e85 4d  M 
    ld hl,vr_l08819h+1         ;7e86 21 5a 2a  ! Z * 
    call v_sub_89d1h           ;7e89 cd 11 2c  . . , 
    pop hl                     ;7e8c e1  . 
    push bc                    ;7e8d c5  . 
    ld d,h                     ;7e8e 54  T 
    ld e,l                     ;7e8f 5d  ] 
    dec hl                     ;7e90 2b  + 
    dec hl                     ;7e91 2b  + 
    call v_sub_88e1h           ;7e92 cd 21 2b  . ! + 
    ld bc,00002h               ;7e95 01 02 00  . . . 
    ld hl,vr_l07539h+1         ;7e98 21 7a 17  ! z . 
    call v_sub_89d1h           ;7e9b cd 11 2c  . . , 
    ld hl,vr_l08819h+1         ;7e9e 21 5a 2a  ! Z * 
    call v_sub_89d1h           ;7ea1 cd 11 2c  . . , 
    pop bc                     ;7ea4 c1  . 
    push bc                    ;7ea5 c5  . 
    inc bc                     ;7ea6 03  . 
    inc bc                     ;7ea7 03  . 
l7ea8h:
    xor a                      ;7ea8 af  . 
    ld (de),a                  ;7ea9 12  . 
    inc de                     ;7eaa 13  . 
    dec bc                     ;7eab 0b  . 
    ld a,b                     ;7eac 78  x 
    or c                       ;7ead b1  . 
    jr nz,l7ea8h               ;7eae 20 f8    . 
    ld hl,(vr_l087d6h+1)       ;7eb0 2a 17 2a  * . * 
    push hl                    ;7eb3 e5  . 
    inc bc                     ;7eb4 03  . 
    call v_sub_89d1h           ;7eb5 cd 11 2c  . . , 
    pop ix                     ;7eb8 dd e1  . . 
    pop bc                     ;7eba c1  . 
l7ebbh:
    ld a,d                     ;7ebb 7a  z 
    or e                       ;7ebc b3  . 
    jr z,l7ed5h                ;7ebd 28 16  ( . 
    push de                    ;7ebf d5  . 
    call v_sub_75dbh           ;7ec0 cd 1b 18  . . . 
vr_l0758fh:
    ld de,00000h               ;7ec3 11 00 00  . . . 
    and a                      ;7ec6 a7  . 
    sbc hl,de                  ;7ec7 ed 52  . R 
    jr c,l7ed1h                ;7ec9 38 06  8 . 
    push ix                    ;7ecb dd e5  . . 
    pop hl                     ;7ecd e1  . 
    call v_sub_89d1h           ;7ece cd 11 2c  . . , 
l7ed1h:
    pop de                     ;7ed1 d1  . 
    dec de                     ;7ed2 1b  . 
    jr l7ebbh                  ;7ed3 18 e6  . . 
l7ed5h:
    ld hl,(vr_l075d4h+1)       ;7ed5 2a 15 18  * . . 
    ld de,(vr_l087d6h+1)       ;7ed8 ed 5b 17 2a  . [ . * 
    sbc hl,de                  ;7edc ed 52  . R 
    ex de,hl                   ;7ede eb  . 
    srl d                      ;7edf cb 3a  . : 
    rr e                       ;7ee1 cb 1b  . . 
        ld hl,l0a55ch                                          ;7ee3 21 68 3e  ! h > 
    call v_sub_75e9h           ;7ee6 cd 29 18  . ) . 
l7ee9h:
    jr nc,l7f08h               ;7ee9 30 1d  0 . 
    push hl                    ;7eeb e5  . 
    ld l,(hl)                  ;7eec 6e  n 
    ld h,a                     ;7eed 67  g 
    push hl                    ;7eee e5  . 
    res 7,h                    ;7eef cb bc  . . 
    or a                       ;7ef1 b7  . 
    sbc hl,de                  ;7ef2 ed 52  . R 
    pop hl                     ;7ef4 e1  . 
    jr nc,l7efeh               ;7ef5 30 07  0 . 
    pop hl                     ;7ef7 e1  . 
l7ef8h:
    inc hl                     ;7ef8 23  # 
    call v_sub_75f8h           ;7ef9 cd 38 18  . 8 . 
    jr l7ee9h                  ;7efc 18 eb  . . 
l7efeh:
    dec hl                     ;7efe 2b  + 
    ld b,h                     ;7eff 44  D 
    ld c,l                     ;7f00 4d  M 
    pop hl                     ;7f01 e1  . 
    ld (hl),c                  ;7f02 71  q 
    dec hl                     ;7f03 2b  + 
    ld (hl),b                  ;7f04 70  p 
    inc hl                     ;7f05 23  # 
    jr l7ef8h                  ;7f06 18 f0  . . 
l7f08h:
vr_l075d4h:
    ld hl,00000h               ;7f08 21 00 00  ! . . 
    pop bc                     ;7f0b c1  . 
    jp v_l751eh                ;7f0c c3 5e 17  . ^ . 
v_sub_75dbh:
    inc ix                     ;7f0f dd 23  . #                    (flow from: 88bc)  75db inc ix 
    ld l,(ix+001h)             ;7f11 dd 6e 01  . n .               (flow from: 75db)  75dd ld l,(ix+01) 
    inc ix                     ;7f14 dd 23  . #                    (flow from: 75dd)  75e0 inc ix 
    ld a,(ix+001h)             ;7f16 dd 7e 01  . ~ .               (flow from: 75e0)  75e2 ld a,(ix+01) 
    and 03fh                   ;7f19 e6 3f  . ?                    (flow from: 75e2)  75e5 and 3f 
    ld h,a                     ;7f1b 67  g                         (flow from: 75e5)  75e7 ld h,a 
    ret                        ;7f1c c9  .                         (flow from: 75e7)  75e8 ret 
l7f1dh:
v_sub_75e9h:
    call v_sub_8a2fh           ;7f1d cd 6f 2c  . o , 
    ret nc                     ;7f20 d0  . 
    inc hl                     ;7f21 23  # 
    ld a,(hl)                  ;7f22 7e  ~ 
    and 00fh                   ;7f23 e6 0f  . . 
    inc hl                     ;7f25 23  # 
    jr z,l7f1dh                ;7f26 28 f5  ( . 
    and 008h                   ;7f28 e6 08  . . 
    jr nz,l7f37h               ;7f2a 20 0b    . 
l7f2ch:
v_sub_75f8h:
    ld a,(hl)                  ;7f2c 7e  ~ 
    inc hl                     ;7f2d 23  # 
    cp 0c0h                    ;7f2e fe c0  . . 
    jr nc,l7f1dh               ;7f30 30 eb  0 . 
    cp 080h                    ;7f32 fe 80  . . 
    jr c,l7f2ch                ;7f34 38 f6  8 . 
    dec hl                     ;7f36 2b  + 
l7f37h:
    ld a,(hl)                  ;7f37 7e  ~ 
    inc hl                     ;7f38 23  # 
    scf                        ;7f39 37  7 
    ret                        ;7f3a c9  . 
invokeSave:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS                             ;7f3b dd 21 e0 50  . ! . P 
    ld (ix+000h),003h          ;7f3f dd 36 00 03  . 6 . . 
    call v_sub_7c2ah           ;7f43 cd 6a 1e  . j . 
    push af                    ;7f46 f5  . 
    ld b,03ah                  ;7f47 06 3a  . : 
    cp b                       ;7f49 b8  . 
    jr z,l7f4fh                ;7f4a 28 03  ( . 
    call v_sub_7c2fh           ;7f4c cd 6f 1e  . o . 
l7f4fh:
    jr nz,l7f54h               ;7f4f 20 03    . 
    call v_sub_76bch           ;7f51 cd fc 18  . . . 
l7f54h:
    ld hl,v_l76d5h             ;7f54 21 15 19  ! . . 
    ld de,050e1h               ;7f57 11 e1 50  . . P 
    ld bc,0000ah               ;7f5a 01 0a 00  . . . 
    ldir                       ;7f5d ed b0  . . 
    pop af                     ;7f5f f1  . 
    jr z,l7f6eh                ;7f60 28 0c  ( . 
    ld hl,(vr_l087d6h+1)       ;7f62 2a 17 2a  * . * 
    ld de,0fff4h               ;7f65 11 f4 ff  . . . 
    add hl,de                  ;7f68 19  . 
        ld de,l0a55ch                                          ;7f69 11 68 3e  . h > 
    jr l7f75h                  ;7f6c 18 07  . . 
l7f6eh:
    call v_sub_080e7h          ;7f6e cd 27 23  . ' # 
    ex de,hl                   ;7f71 eb  . 
    call v_sub_8248h           ;7f72 cd 88 24  . . $ 
l7f75h:
    push de                    ;7f75 d5  . 
    ld (l0801dh+2),de                                          ;7f76 ed 53 2b 19  . S + . 
    or a                       ;7f7a b7  . 
    sbc hl,de                  ;7f7b ed 52  . R 
    push hl                    ;7f7d e5  . 
        ld (l08021h+1),hl                                      ;7f7e 22 2e 19  " . . 
    ld (050efh),hl             ;7f81 22 ef 50  " . P 
    ld hl,(vr_l08819h+1)       ;7f84 2a 5a 2a  * Z * 
    ld de,(vr_l087d6h+1)       ;7f87 ed 5b 17 2a  . [ . * 
    and a                      ;7f8b a7  . 
    sbc hl,de                  ;7f8c ed 52  . R 
    ld (l07fb3h+2),de                                          ;7f8e ed 53 c1 18  . S . . 
    inc hl                     ;7f92 23  # 
    ld (vr_l07685h+1),hl       ;7f93 22 c6 18  " . . 
    dec hl                     ;7f96 2b  + 
    pop de                     ;7f97 d1  . 
    push de                    ;7f98 d5  . 
    add hl,de                  ;7f99 19  . 
    inc hl                     ;7f9a 23  # 
    inc hl                     ;7f9b 23  # 
    ld (050ebh),hl             ;7f9c 22 eb 50  " . P 
    ld a,00ch                  ;7f9f 3e 0c  > . 
    push ix                    ;7fa1 dd e5  . . 
    call v_l89f4h              ;7fa3 cd 34 2c  . 4 , 
    pop ix                     ;7fa6 dd e1  . . 
    call v_sub_769ah           ;7fa8 cd da 18  . . . 
    pop de                     ;7fab d1  . 
    pop ix                     ;7fac dd e1  . . 
    ld a,0ffh                  ;7fae 3e ff  > . 
    call ROM_SaveControl_4c6   ;7fb0 cd c6 04  . . . 
l07fb3h:
    ld ix,00000h               ;7fb3 dd 21 00 00  . ! . . 
    dec ix                     ;7fb7 dd 2b  . + 
vr_l07685h:
    ld de,00000h               ;7fb9 11 00 00  . . . 
    ld l,0ffh                  ;7fbc 2e ff  . . 
    ld a,h                     ;7fbe 7c  | 
    xor l                      ;7fbf ad  . 
    ld h,a                     ;7fc0 67  g 
    ld a,001h                  ;7fc1 3e 01  > . 
    scf                        ;7fc3 37  7 
    rl l                       ;7fc4 cb 15  . . 
    ld b,037h                  ;7fc6 06 37  . 7 
    call ROM_SA_SET            ;7fc8 cd 1a 05  . . . 
    jp v_sub_7bbch             ;7fcb c3 fc 1d  . . . 
v_sub_769ah:
    ld h,001h                  ;7fce 26 01  & . 
l7fd0h:
    inc hl                     ;7fd0 23  # 
    inc h                      ;7fd1 24  $ 
    dec h                      ;7fd2 25  % 
    jr nz,l7fd0h               ;7fd3 20 fb    . 
l7fd5h:
    xor a                      ;7fd5 af  . 
    in a,(0feh)                ;7fd6 db fe  . . 
    cpl                        ;7fd8 2f  / 
    and 01fh                   ;7fd9 e6 1f  . . 
    jr z,l7fd5h                ;7fdb 28 f8  ( . 
    ld de,00011h               ;7fdd 11 11 00  . . . 
    xor a                      ;7fe0 af  . 
    call ROM_SaveControl_4c6   ;7fe1 cd c6 04  . . . 
l7fe4h:
    dec de                     ;7fe4 1b  . 
    dec d                      ;7fe5 15  . 
    inc d                      ;7fe6 14  . 
    jr nz,l7fe4h               ;7fe7 20 fb    . 
    ret                        ;7fe9 c9  . 
v_sub_76b6h:
    ld b,03ah                  ;7fea 06 3a  . :                    (flow from: 89ec)  76b6 ld b,3a 
    call v_sub_7c2ch           ;7fec cd 6c 1e  . l .               (flow from: 76b6)  76b8 call 7c2c 
    ret nz                     ;7fef c0  .                         (flow from: 7c34)  76bb ret nz 
v_sub_76bch:
    ld de,v_l76d5h             ;7ff0 11 15 19  . . .               (flow from: 76bb)  76bc ld de,76d5 
v_sub_76bfh:
    ld b,00ah                  ;7ff3 06 0a  . .                    (flow from: 76bc)  76bf ld b,0a 
l7ff5h:
    call atHLorNextIfOne       ;7ff5 cd ee 27  . . '               (flow from: 76bf 76cb)  76c1 call 85ae 
    inc hl                     ;7ff8 23  #                         (flow from: 85b1)  76c4 inc hl 
    or a                       ;7ff9 b7  .                         (flow from: 76c4)  76c5 or a 
    jr z,l8002h                ;7ffa 28 06  ( .                    (flow from: 76c5)  76c6 jr z,76ce 
    ld (de),a                  ;7ffc 12  .                         (flow from: 76c6)  76c8 ld (de),a 
    inc de                     ;7ffd 13  .                         (flow from: 76c8)  76c9 inc de 
    dec b                      ;7ffe 05  .                         (flow from: 76c9)  76ca dec b 
    jr nz,l7ff5h               ;7fff 20 f4    .                    (flow from: 76ca)  76cb jr nz,76c1 
    ret                        ;8001 c9  .                         (flow from: 76cb)  76cd ret 
l8002h:
    ld a,020h                  ;8002 3e 20  >   
l8004h:
    ld (de),a                  ;8004 12  . 
    inc de                     ;8005 13  . 
    djnz l8004h                ;8006 10 fc  . . 
    ret                        ;8008 c9  . 
v_l76d5h:
    defb "prometheus"          ;8009
l8013h:
invokeVerify:
    call v_sub_7bdch           ;8013 cd 1c 1e  . . . 
    call v_sub_7c1ah           ;8016 cd 5a 1e  . Z . 
    jr nz,l8013h               ;8019 20 f8    . 
    xor a                      ;801b af  . 
    dec a                      ;801c 3d  = 
l0801dh:
    ld ix,00000h               ;801d dd 21 00 00  . ! . . 
l08021h:
    ld de,00000h               ;8021 11 00 00  . . . 
    call v_sub_770ah           ;8024 cd 4a 19  . J . 
    ld ix,(l07fb3h+2)                                          ;8027 dd 2a c1 18  . * . . 
    ld de,(vr_l07685h+1)       ;802b ed 5b c6 18  . [ . . 
    dec de                     ;802f 1b  . 
    ld b,0b0h                  ;8030 06 b0  . . 
    ex af,af'                  ;8032 08  . 
    xor a                      ;8033 af  . 
    dec a                      ;8034 3d  = 
    ex af,af'                  ;8035 08  . 
    call ROM_LD_MARKER         ;8036 cd c8 05  . . . 
    call v_sub_7bbch           ;8039 cd fc 1d  . . . 
    jr l8041h                  ;803c 18 03  . . 
v_sub_770ah:
    call v_sub_7bb1h           ;803e cd f1 1d  . . .               (flow from: 77fd)  770a call 7bb1 
l8041h:
    ret c                      ;8041 d8  .                         (flow from: 7bc6)  770d ret c 
    ld a,00dh                  ;8042 3e 0d  > . 
l8044h:
    call v_l89f4h              ;8044 cd 34 2c  . 4 , 
    jp v_l80a2h                ;8047 c3 e2 22  . . " 
invokeLoad:
    call v_sub_89e8h           ;804a cd 28 2c  . ( ,               (flow from: 7e06)  7716 call 89e8 
    ld hl,v_l7760h             ;804d 21 a0 19  ! . .               (flow from: 8a1d)  7719 ld hl,7760 
    ld (vr_l07e38h+1),hl       ;8050 22 79 20  " y                 (flow from: 7719)  771c ld (7e39),hl 
l8053h:
vr_l0771fh:
    ld hl,00000h               ;8053 21 00 00  ! . .               (flow from: 771c 776d)  771f ld hl,fb00 
    push hl                    ;8056 e5  .                         (flow from: 771f)  7722 push hl 
    push hl                    ;8057 e5  .                         (flow from: 7722)  7723 push hl 
    pop ix                     ;8058 dd e1  . .                    (flow from: 7723)  7724 pop ix 
    call v_sub_8248h           ;805a cd 88 24  . . $               (flow from: 7724)  7726 call 8248 
    ld (vr_l0771fh+1),hl       ;805d 22 60 19  " ` .               (flow from: 8255 825a)  7729 ld (7720),hl 
    pop hl                     ;8060 e1  .                         (flow from: 7729)  772c pop hl 
vr_l0772dh:
    ld de,00000h               ;8061 11 00 00  . . .               (flow from: 772c)  772d ld de,fb00 
    and a                      ;8064 a7  .                         (flow from: 772d)  7730 and a 
    sbc hl,de                  ;8065 ed 52  . R                    (flow from: 7730)  7731 sbc hl,de 
    jr nc,l80a8h               ;8067 30 3f  0 ?                    (flow from: 7731)  7733 jr nc,7774 
    ld a,021h                  ;8069 3e 21  > !                    (flow from: 7733)  7735 ld a,21 
vr_l07737h:
    ld hl,00000h               ;806b 21 00 00  ! . .               (flow from: 7735)  7737 ld hl,fb02 
    call v_sub_77cah           ;806e cd 0a 1a  . . .               (flow from: 7737)  773a call 77ca 
    call v_sub_8135h           ;8071 cd 75 23  . u #               (flow from: 77d0)  773d call 8135 
    ld a,02ah                  ;8074 3e 2a  > *                    (flow from: 8189 81b6 81dd 822d 8231)  7740 ld a,2a 
    ld hl,vr_l087d6h+1         ;8076 21 17 2a  ! . *               (flow from: 7740)  7742 ld hl,87d7 
    call v_sub_77cah           ;8079 cd 0a 1a  . . .               (flow from: 7742)  7745 call 77ca 
    ld a,(vr_l07cfeh+1)        ;807c 3a 3f 1f  : ? .               (flow from: 77d0)  7748 ld a,(7cff) 
    cp 010h                    ;807f fe 10  . .                    (flow from: 7748)  774b cp 10 
    jr z,l8044h                ;8081 28 c1  ( .                    (flow from: 774b)  774d jr z,7710 
    ld hl,v_l8aa5h             ;8083 21 e5 2c  ! . ,               (flow from: 774d)  774f ld hl,8aa5 
    ld de,inputBufferStart     ;8086 11 3f 2d  . ? -               (flow from: 774f)  7752 ld de,8aff 
    ld bc,00020h               ;8089 01 20 00  .   .               (flow from: 7752)  7755 ld bc,0020 
    ldir                       ;808c ed b0  . .                    (flow from: 7755 7758)  7758 ldir 
    call v_l82dbh              ;808e cd 1b 25  . . %               (flow from: 7758)  775a call 82db 
    jp v_l7dddh                ;8091 c3 1d 20  . .                 (flow from: 82e5)  775d jp 7ddd 
v_l7760h:
    call v_sub_8262h           ;8094 cd a2 24  . . $               (flow from: 7e38)  7760 call 8262 
    ld de,(vr_l0771fh+1)       ;8097 ed 5b 60 19  . [ ` .          (flow from: 8268)  7763 ld de,(7720) 
    ld hl,(vr_l08819h+1)       ;809b 2a 5a 2a  * Z *               (flow from: 7763)  7767 ld hl,(881a) 
    and a                      ;809e a7  .                         (flow from: 7767)  776a and a 
    sbc hl,de                  ;809f ed 52  . R                    (flow from: 776a)  776b sbc hl,de 
    jr c,l8053h                ;80a1 38 b0  8 .                    (flow from: 776b)  776d jr c,771f 
    ld a,007h                  ;80a3 3e 07  > . 
    jp v_l809ah                ;80a5 c3 da 22  . . " 
l80a8h:
    ld hl,v_l7ccfh             ;80a8 21 0f 1f  ! . .               (flow from: 7733)  7774 ld hl,7ccf 
    ld (vr_l07e38h+1),hl       ;80ab 22 79 20  " y                 (flow from: 7774)  7777 ld (7e39),hl 
    jp (hl)                    ;80ae e9  .                         (flow from: 7777)  777a jp hl 
invokeGens:
invokeI:
invokeJ:
    call v_sub_89e8h           ;80af cd 28 2c  . ( , 
    ld hl,v_l77b9h             ;80b2 21 f9 19  ! . . 
    ld (vr_l07e38h+1),hl       ;80b5 22 79 20  " y   
l80b8h:
    ld b,001h                  ;80b8 06 01  . . 
    ld de,inputBufferStart     ;80ba 11 3f 2d  . ? - 
    ld hl,(vr_l0771fh+1)       ;80bd 2a 60 19  * ` . 
    inc hl                     ;80c0 23  # 
    inc hl                     ;80c1 23  # 
l80c2h:
    ld a,(hl)                  ;80c2 7e  ~ 
    inc hl                     ;80c3 23  # 
    cp 00dh                    ;80c4 fe 0d  . . 
    jr z,l80d9h                ;80c6 28 11  ( . 
    bit 5,b                    ;80c8 cb 68  . h 
    jr nz,l80c2h               ;80ca 20 f6    . 
    cp 020h                    ;80cc fe 20  .   
    jr nc,l80d2h               ;80ce 30 02  0 . 
    ld a,020h                  ;80d0 3e 20  >   
l80d2h:
    and 07fh                   ;80d2 e6 7f  .  
    ld (de),a                  ;80d4 12  . 
    inc de                     ;80d5 13  . 
    inc b                      ;80d6 04  . 
    jr l80c2h                  ;80d7 18 e9  . . 
l80d9h:
    ld (vr_l0771fh+1),hl       ;80d9 22 60 19  " ` . 
    ld a,001h                  ;80dc 3e 01  > . 
    ld (de),a                  ;80de 12  . 
l80dfh:
    inc de                     ;80df 13  . 
    xor a                      ;80e0 af  . 
    ld (de),a                  ;80e1 12  . 
    inc b                      ;80e2 04  . 
    bit 5,b                    ;80e3 cb 68  . h 
    jr z,l80dfh                ;80e5 28 f8  ( . 
    call v_l82dbh              ;80e7 cd 1b 25  . . % 
    jp v_l7dddh                ;80ea c3 1d 20  . .   
v_l77b9h:
    call v_sub_8262h           ;80ed cd a2 24  . . $ 
    ld hl,(vr_l0771fh+1)       ;80f0 2a 60 19  * ` . 
    ld de,(vr_l07945h+1)       ;80f3 ed 5b 86 1b  . [ . . 
    and a                      ;80f7 a7  . 
    sbc hl,de                  ;80f8 ed 52  . R 
    jr c,l80b8h                ;80fa 38 bc  8 . 
    jr l80a8h                  ;80fc 18 aa  . . 
v_sub_77cah:
    ld (v_sub_8116h),a         ;80fe 32 56 23  2 V #               (flow from: 773a 7745)  77ca ld (8116),a 
    ld (vr_l08116h+1),hl       ;8101 22 57 23  " W #               (flow from: 77ca)  77cd ld (8117),hl 
    ret                        ;8104 c9  .                         (flow from: 77cd)  77d0 ret 
l8105h:
v_l77d1h:
    call v_sub_7bdch           ;8105 cd 1c 1e  . . .               (flow from: 89ef)  77d1 call 7bdc 
    call v_sub_7c0dh           ;8108 cd 4d 1e  . M .               (flow from: 7c0c)  77d4 call 7c0d 
    jr nz,l8105h               ;810b 20 f8    .                    (flow from: 7c29)  77d7 jr nz,77d1 
    ld hl,(050ebh)             ;810d 2a eb 50  * . P               (flow from: 77d7)  77d9 ld hl,(50eb) 
    ld b,h                     ;8110 44  D                         (flow from: 77d9)  77dc ld b,h 
    ld c,l                     ;8111 4d  M                         (flow from: 77dc)  77dd ld c,l 
    call v_sub_8068h           ;8112 cd a8 22  . . "               (flow from: 77dd)  77de call 8068 
    ex de,hl                   ;8115 eb  .                         (flow from: 8078)  77e1 ex de,hl 
    ld hl,(vr_l07945h+1)       ;8116 2a 86 1b  * . .               (flow from: 77e1)  77e2 ld hl,(7946) 
    and a                      ;8119 a7  .                         (flow from: 77e2)  77e5 and a 
    sbc hl,de                  ;811a ed 52  . R                    (flow from: 77e5)  77e6 sbc hl,de 
    push hl                    ;811c e5  .                         (flow from: 77e6)  77e8 push hl 
    ld (vr_l0771fh+1),hl       ;811d 22 60 19  " ` .               (flow from: 77e8)  77e9 ld (7720),hl 
    ld bc,(050efh)             ;8120 ed 4b ef 50  . K . P          (flow from: 77e9)  77ec ld bc,(50ef) 
    add hl,bc                  ;8124 09  .                         (flow from: 77ec)  77f0 add hl,bc 
    ld (vr_l0772dh+1),hl       ;8125 22 6e 19  " n .               (flow from: 77f0)  77f1 ld (772e),hl 
    inc hl                     ;8128 23  #                         (flow from: 77f1)  77f4 inc hl 
    inc hl                     ;8129 23  #                         (flow from: 77f4)  77f5 inc hl 
    ld (vr_l07737h+1),hl       ;812a 22 78 19  " x .               (flow from: 77f5)  77f6 ld (7738),hl 
    pop ix                     ;812d dd e1  . .                    (flow from: 77f6)  77f9 pop ix 
    scf                        ;812f 37  7                         (flow from: 77f9)  77fb scf 
    sbc a,a                    ;8130 9f  .                         (flow from: 77fb)  77fc sbc a,a 
    call v_sub_770ah           ;8131 cd 4a 19  . J .               (flow from: 77fc)  77fd call 770a 
v_sub_7800h:
    ld a,007h                  ;8134 3e 07  > .                    (flow from: 770d 7cf7)  7800 ld a,07 
    out (0feh),a               ;8136 d3 fe  . .                    (flow from: 7800)  7802 out (fe),a 
    ret                        ;8138 c9  .                         (flow from: 7802)  7804 ret 
v_sub_7805h:
    call v_sub_7c2ah           ;8139 cd 6a 1e  . j . 
    ld a,000h                  ;813c 3e 00  > . 
    jr z,l8141h                ;813e 28 01  ( . 
    inc a                      ;8140 3c  < 
l8141h:
    ld (vr_l0783eh+1),a        ;8141 32 7f 1a  2  . 
    ld c,0b6h                  ;8144 0e b6  . . 
    call v_l74c1h              ;8146 cd 01 17  . . . 
    ld a,001h                  ;8149 3e 01  > . 
    ld (vr_l07850h+1),a        ;814b 32 91 1a  2 . . 
    ld hl,v_sub_79afh          ;814e 21 ef 1b  ! . . 
    ld (vr_l07848h+1),hl       ;8151 22 89 1a  " . . 
l8154h:
    ld hl,(vr_l08819h+1)       ;8154 2a 5a 2a  * Z * 
    inc hl                     ;8157 23  # 
    ld (v_l7953h+1),hl         ;8158 22 94 1b  " . . 
    ld (vr_l07934h+1),hl       ;815b 22 75 1b  " u . 
        ld hl,l0a55ch                                          ;815e 21 68 3e  ! h > 
l8161h:
    call v_sub_8a2fh           ;8161 cd 6f 2c  . o , 
    jr nc,l8184h               ;8164 30 1e  0 . 
    ld (v_l79c3h+1),hl         ;8166 22 04 1c  " . . 
    push hl                    ;8169 e5  . 
    call v_sub_8248h           ;816a cd 88 24  . . $ 
    ld (vr_l0784bh+1),hl       ;816d 22 8c 1a  " . . 
    pop ix                     ;8170 dd e1  . . 
vr_l0783eh:
    ld a,000h                  ;8172 3e 00  > . 
    or a                       ;8174 b7  . 
    jr nz,l817ch               ;8175 20 05    . 
    call v_sub_80f5h           ;8177 cd 35 23  . 5 # 
    jr c,l817fh                ;817a 38 03  8 . 
l817ch:
vr_l07848h:
    call v_sub_79afh           ;817c cd ef 1b  . . . 
l817fh:
vr_l0784bh:
    ld hl,00000h               ;817f 21 00 00  ! . . 
    jr l8161h                  ;8182 18 dd  . . 
l8184h:
vr_l07850h:
    ld a,000h                  ;8184 3e 00  > . 
    dec a                      ;8186 3d  = 
    ld (vr_l07850h+1),a        ;8187 32 91 1a  2 . . 
    ld hl,v_sub_78dah          ;818a 21 1a 1b  ! . . 
    ld (vr_l07848h+1),hl       ;818d 22 89 1a  " . . 
    jr z,l8154h                ;8190 28 c2  ( . 
    ret                        ;8192 c9  . 
invokeAssembly:
    call v_sub_7805h           ;8193 cd 45 1a  . E . 
    ld a,00bh                  ;8196 3e 0b  > . 
    jp v_l7cdah                ;8198 c3 1a 1f  . . . 
l819bh:
    ld a,(ix+000h)             ;819b dd 7e 00  . ~ . 
    call v_sub_7a02h           ;819e cd 42 1c  . B . 
    sub 002h                   ;81a1 d6 02  . . 
    ret c                      ;81a3 d8  . 
    jr nz,l81b1h               ;81a4 20 0b    . 
    call v_sub_7a98h           ;81a6 cd d8 1c  . . . 
    ld (vr_l07cc3h+1),hl       ;81a9 22 04 1f  " . . 
        ld hl,l085ech+1                                        ;81ac 21 f9 1e  ! . . 
    dec (hl)                   ;81af 35  5 
    ret                        ;81b0 c9  . 
l81b1h:
    dec a                      ;81b1 3d  = 
    ret z                      ;81b2 c8  . 
    dec a                      ;81b3 3d  = 
    jp z,v_l7a25h              ;81b4 ca 65 1c  . e . 
    dec a                      ;81b7 3d  = 
    jr nz,l81c0h               ;81b8 20 06    . 
    call v_sub_7a98h           ;81ba cd d8 1c  . . . 
    jp v_l7a2ch                ;81bd c3 6c 1c  . l . 
l81c0h:
    dec a                      ;81c0 3d  = 
    jr nz,l81d0h               ;81c1 20 0d    . 
l81c3h:
    call v_sub_7a98h           ;81c3 cd d8 1c  . . . 
    jp c,v_l792ah              ;81c6 da 6a 1b  . j . 
    call v_l792ah              ;81c9 cd 6a 1b  . j . 
    inc ix                     ;81cc dd 23  . # 
    jr l81c3h                  ;81ce 18 f3  . . 
l81d0h:
    dec a                      ;81d0 3d  = 
    jr nz,l81fdh               ;81d1 20 2a    * 
l81d3h:
    call v_sub_78b3h           ;81d3 cd f3 1a  . . . 
    jr nz,l81ddh               ;81d6 20 05    . 
    call v_sub_7931h           ;81d8 cd 71 1b  . q . 
    jr l81d3h                  ;81db 18 f6  . . 
l81ddh:
    ld a,e                     ;81dd 7b  { 
    cp 027h                    ;81de fe 27  . ' 
    jr nz,l81e4h               ;81e0 20 02    . 
    set 7,d                    ;81e2 cb fa  . . 
l81e4h:
    ld a,d                     ;81e4 7a  z 
    jr l8265h                  ;81e5 18 7e  . ~ 
v_sub_78b3h:
    call v_sub_810ah           ;81e7 cd 4a 23  . J # 
    bit 7,(ix+004h)            ;81ea dd cb 04 7e  . . . ~ 
    ret nz                     ;81ee c0  . 
    ld a,d                     ;81ef 7a  z 
    cp 022h                    ;81f0 fe 22  . " 
    jr nz,l81f8h               ;81f2 20 04    . 
    cp e                       ;81f4 bb  . 
    call z,v_sub_810ah         ;81f5 cc 4a 23  . J # 
l81f8h:
    bit 7,(ix+004h)            ;81f8 dd cb 04 7e  . . . ~ 
    ret                        ;81fc c9  . 
l81fdh:
    dec a                      ;81fd 3d  = 
    jp z,v_l7a4ch              ;81fe ca 8c 1c  . . . 
l8201h:
    call v_sub_7a98h           ;8201 cd d8 1c  . . . 
    jp c,v_sub_7962h           ;8204 da a2 1b  . . . 
    call v_sub_7962h           ;8207 cd a2 1b  . . . 
    inc ix                     ;820a dd 23  . # 
    jr l8201h                  ;820c 18 f3  . . 
v_sub_78dah:
    ld b,(ix+001h)             ;820e dd 46 01  . F . 
    ld a,b                     ;8211 78  x 
    and 030h                   ;8212 e6 30  . 0 
    cp 030h                    ;8214 fe 30  . 0 
    jr z,l819bh                ;8216 28 83  ( . 
    ld a,b                     ;8218 78  x 
    and 0b0h                   ;8219 e6 b0  . . 
    cp 090h                    ;821b fe 90  . . 
    jr c,l822dh                ;821d 38 0e  8 . 
    call v_l78f9h              ;821f cd 39 1b  . 9 . 
    ld hl,(vr_l07934h+1)       ;8222 2a 75 1b  * u . 
    dec hl                     ;8225 2b  + 
    ld a,(hl)                  ;8226 7e  ~ 
    dec hl                     ;8227 2b  + 
    ld b,(hl)                  ;8228 46  F 
    ld (hl),a                  ;8229 77  w 
    inc hl                     ;822a 23  # 
    ld (hl),b                  ;822b 70  p 
    ret                        ;822c c9  . 
l822dh:
v_l78f9h:
    ld a,0ddh                  ;822d 3e dd  > . 
    bit 5,b                    ;822f cb 68  . h 
    call nz,v_sub_7931h        ;8231 c4 71 1b  . q . 
    ld a,0fdh                  ;8234 3e fd  > . 
    bit 4,b                    ;8236 cb 60  . ` 
    call nz,v_sub_7931h        ;8238 c4 71 1b  . q . 
    ld a,0cbh                  ;823b 3e cb  > . 
    bit 7,b                    ;823d cb 78  . x 
    call nz,v_sub_7931h        ;823f c4 71 1b  . q . 
    ld a,0edh                  ;8242 3e ed  > . 
    bit 6,b                    ;8244 cb 70  . p 
    call nz,v_sub_7931h        ;8246 c4 71 1b  . q . 
    ld a,(ix+000h)             ;8249 dd 7e 00  . ~ . 
    call v_sub_7931h           ;824c cd 71 1b  . q . 
    call v_sub_7a02h           ;824f cd 42 1c  . B . 
    ld a,b                     ;8252 78  x 
    and 007h                   ;8253 e6 07  . . 
    ret z                      ;8255 c8  . 
    dec a                      ;8256 3d  = 
    push af                    ;8257 f5  . 
    call v_sub_7a98h           ;8258 cd d8 1c  . . . 
    pop af                     ;825b f1  . 
    jr nz,l8293h               ;825c 20 35    5 
l825eh:
v_l792ah:
    ld a,b                     ;825e 78  x 
    inc a                      ;825f 3c  < 
    and 0feh                   ;8260 e6 fe  . . 
    jr nz,l82bbh               ;8262 20 57    W 
    ld a,c                     ;8264 79  y 
l8265h:
v_sub_7931h:
vr_l07931h:
    ld de,ENTRY_POINT_WITH_MONITOR                             ;8265 11 00 00  . . . 
vr_l07934h:
    ld hl,00000h               ;8268 21 00 00  ! . . 
    and a                      ;826b a7  . 
    sbc hl,de                  ;826c ed 52  . R 
    add hl,de                  ;826e 19  . 
    ex de,hl                   ;826f eb  . 
    jr c,l8279h                ;8270 38 07  8 . 
    ld hl,(vr_l08819h+1)       ;8272 2a 5a 2a  * Z * 
    sbc hl,de                  ;8275 ed 52  . R 
    jr nc,l828fh               ;8277 30 16  0 . 
l8279h:
vr_l07945h:
    ld hl,0ffffh               ;8279 21 ff ff  ! . . 
    and a                      ;827c a7  . 
    sbc hl,de                  ;827d ed 52  . R 
    jr c,l828fh                ;827f 38 0e  8 . 
    ld (de),a                  ;8281 12  . 
    inc de                     ;8282 13  . 
    ld (vr_l07934h+1),de       ;8283 ed 53 75 1b  . S u . 
v_l7953h:
    ld hl,00000h               ;8287 21 00 00  ! . . 
    inc hl                     ;828a 23  # 
    ld (v_l7953h+1),hl         ;828b 22 94 1b  " . . 
    ret                        ;828e c9  . 
l828fh:
    ld a,008h                  ;828f 3e 08  > . 
    jr l82f7h                  ;8291 18 64  . d 
l8293h:
    dec a                      ;8293 3d  = 
    jr nz,l829dh               ;8294 20 07    . 
v_sub_7962h:
    ld a,c                     ;8296 79  y 
    call v_sub_7931h           ;8297 cd 71 1b  . q . 
    ld a,b                     ;829a 78  x 
    jr l8265h                  ;829b 18 c8  . . 
l829dh:
    dec a                      ;829d 3d  = 
    jr nz,l82bfh               ;829e 20 1f    . 
    ld hl,(v_l7953h+1)         ;82a0 2a 94 1b  * . . 
    inc hl                     ;82a3 23  # 
    push bc                    ;82a4 c5  . 
    ex (sp),hl                 ;82a5 e3  . 
    pop bc                     ;82a6 c1  . 
    and a                      ;82a7 a7  . 
    sbc hl,bc                  ;82a8 ed 42  . B 
l82aah:
    ld a,l                     ;82aa 7d  } 
    inc h                      ;82ab 24  $ 
    jr z,l82b7h                ;82ac 28 09  ( . 
    dec h                      ;82ae 25  % 
    jr nz,l82bbh               ;82af 20 0a    . 
    cp 080h                    ;82b1 fe 80  . . 
    jr nc,l82bbh               ;82b3 30 06  0 . 
l82b5h:
    jr l8265h                  ;82b5 18 ae  . . 
l82b7h:
    cp 080h                    ;82b7 fe 80  . . 
    jr nc,l82b5h               ;82b9 30 fa  0 . 
l82bbh:
    ld a,003h                  ;82bb 3e 03  > . 
    jr l82f7h                  ;82bd 18 38  . 8 
l82bfh:
    dec a                      ;82bf 3d  = 
    jr nz,l82c6h               ;82c0 20 04    . 
v_sub_798eh:
    ld h,b                     ;82c2 60  ` 
    ld l,c                     ;82c3 69  i 
    jr l82aah                  ;82c4 18 e4  . . 
l82c6h:
    dec a                      ;82c6 3d  = 
    jr nz,l82d3h               ;82c7 20 0a    . 
    call v_sub_798eh           ;82c9 cd ce 1b  . . . 
    inc ix                     ;82cc dd 23  . # 
    call v_sub_7a98h           ;82ce cd d8 1c  . . . 
    jr l825eh                  ;82d1 18 8b  . . 
l82d3h:
    ld a,c                     ;82d3 79  y 
    and 0c7h                   ;82d4 e6 c7  . . 
    or b                       ;82d6 b0  . 
    ld a,006h                  ;82d7 3e 06  > . 
    jr nz,l82f7h               ;82d9 20 1c    . 
    ld a,c                     ;82db 79  y 
    ld hl,(vr_l07934h+1)       ;82dc 2a 75 1b  * u . 
    dec hl                     ;82df 2b  + 
    add a,(hl)                 ;82e0 86  . 
    ld (hl),a                  ;82e1 77  w 
    ret                        ;82e2 c9  . 
v_sub_79afh:
    bit 3,(ix+001h)            ;82e3 dd cb 01 5e  . . . ^ 
    jr z,l830ah                ;82e7 28 21  ( ! 
    call v_sub_8113h           ;82e9 cd 53 23  . S # 
    ld (vr_l07a1ah+1),de       ;82ec ed 53 5b 1c  . S [ . 
    ld a,(hl)                  ;82f0 7e  ~ 
    and 0c0h                   ;82f1 e6 c0  . . 
    jr z,l8300h                ;82f3 28 0b  ( . 
    ld a,012h                  ;82f5 3e 12  > . 
l82f7h:
v_l79c3h:
    ld hl,00000h               ;82f7 21 00 00  ! . . 
    ld (v_sub_826ch+1),hl      ;82fa 22 ad 24  " . $ 
    jp v_l809ah                ;82fd c3 da 22  . . " 
l8300h:
    set 6,(hl)                 ;8300 cb f6  . . 
    ld hl,(v_l7953h+1)         ;8302 2a 94 1b  * . . 
    ex de,hl                   ;8305 eb  . 
    dec hl                     ;8306 2b  + 
    ld (hl),d                  ;8307 72  r 
    dec hl                     ;8308 2b  + 
    ld (hl),e                  ;8309 73  s 
l830ah:
    ld a,(ix+001h)             ;830a dd 7e 01  . ~ . 
    and 030h                   ;830d e6 30  . 0 
    cp 030h                    ;830f fe 30  . 0 
    jr z,l8340h                ;8311 28 2d  ( - 
    ld a,(ix+001h)             ;8313 dd 7e 01  . ~ . 
    and 007h                   ;8316 e6 07  . . 
    ld c,a                     ;8318 4f  O 
    ld b,000h                  ;8319 06 00  . . 
    ld hl,v_l79fah             ;831b 21 3a 1c  ! : . 
    add hl,bc                  ;831e 09  . 
    ld a,(hl)                  ;831f 7e  ~ 
    inc a                      ;8320 3c  < 
    ld bc,00400h               ;8321 01 00 04  . . . 
    ld d,(ix+001h)             ;8324 dd 56 01  . V . 
l8327h:
    rl d                       ;8327 cb 12  . . 
    adc a,c                    ;8329 89  . 
    djnz l8327h                ;832a 10 fb  . . 
    jr l839bh                  ;832c 18 6d  . m 
v_l79fah:
    nop                        ;832e 00  . 
    ld bc,00102h               ;832f 01 02 01  . . . 
    ld bc,00002h               ;8332 01 02 00  . . . 
    nop                        ;8335 00  . 
v_sub_7a02h:
    bit 3,(ix+001h)            ;8336 dd cb 01 5e  . . . ^ 
    ret z                      ;833a c8  . 
    inc ix                     ;833b dd 23  . # 
    inc ix                     ;833d dd 23  . # 
    ret                        ;833f c9  . 
l8340h:
    ld a,(ix+000h)             ;8340 dd 7e 00  . ~ . 
    call v_sub_7a02h           ;8343 cd 42 1c  . B . 
    sub 003h                   ;8346 d6 03  . . 
    ret c                      ;8348 d8  . 
    jr nz,l8356h               ;8349 20 0b    . 
    call v_sub_7a98h           ;834b cd d8 1c  . . . 
vr_l07a1ah:
    ld hl,00000h               ;834e 21 00 00  ! . . 
    dec hl                     ;8351 2b  + 
    ld (hl),b                  ;8352 70  p 
    dec hl                     ;8353 2b  + 
    ld (hl),c                  ;8354 71  q 
    ret                        ;8355 c9  . 
l8356h:
    dec a                      ;8356 3d  = 
    jr nz,l8365h               ;8357 20 0c    . 
v_l7a25h:
    call v_sub_7a98h           ;8359 cd d8 1c  . . . 
    ld (v_l7953h+1),bc         ;835c ed 43 94 1b  . C . . 
v_l7a2ch:
    ld (vr_l07934h+1),bc       ;8360 ed 43 75 1b  . C u . 
    ret                        ;8364 c9  . 
l8365h:
    dec a                      ;8365 3d  = 
    ret z                      ;8366 c8  . 
    dec a                      ;8367 3d  = 
    jr nz,l8370h               ;8368 20 06    . 
    call v_sub_7a70h           ;836a cd b0 1c  . . . 
    ld a,c                     ;836d 79  y 
    jr l839bh                  ;836e 18 2b  . + 
l8370h:
    dec a                      ;8370 3d  = 
    jr nz,l837dh               ;8371 20 0a    . 
    ld c,a                     ;8373 4f  O 
l8374h:
    inc c                      ;8374 0c  . 
    call v_sub_78b3h           ;8375 cd f3 1a  . . . 
    jr z,l8374h                ;8378 28 fa  ( . 
    ld a,c                     ;837a 79  y 
    jr l839bh                  ;837b 18 1e  . . 
l837dh:
    dec a                      ;837d 3d  = 
    jr nz,l8396h               ;837e 20 16    . 
l8380h:
v_l7a4ch:
    call v_sub_7a98h           ;8380 cd d8 1c  . . . 
    push af                    ;8383 f5  . 
    ld hl,v_l7953h+1           ;8384 21 94 1b  ! . . 
    call v_sub_8980h           ;8387 cd c0 2b  . . + 
    ld hl,vr_l07934h+1         ;838a 21 75 1b  ! u . 
    call v_sub_8980h           ;838d cd c0 2b  . . + 
    pop af                     ;8390 f1  . 
    inc ix                     ;8391 dd 23  . # 
    jr nc,l8380h               ;8393 30 eb  0 . 
    ret                        ;8395 c9  . 
l8396h:
    call v_sub_7a70h           ;8396 cd b0 1c  . . . 
    ld a,c                     ;8399 79  y 
    add a,c                    ;839a 81  . 
l839bh:
    ld b,000h                  ;839b 06 00  . . 
    ld c,a                     ;839d 4f  O 
    ld hl,v_l7953h+1           ;839e 21 94 1b  ! . . 
    jp v_sub_8980h             ;83a1 c3 c0 2b  . . + 
v_sub_7a70h:
    ld c,001h                  ;83a4 0e 01  . . 
l83a6h:
    ld a,(ix+002h)             ;83a6 dd 7e 02  . ~ . 
    cp 02ch                    ;83a9 fe 2c  . , 
    jr nz,l83b0h               ;83ab 20 03    . 
    inc c                      ;83ad 0c  . 
    jr l83bdh                  ;83ae 18 0d  . . 
l83b0h:
    cp 022h                    ;83b0 fe 22  . " 
    jr nz,l83c1h               ;83b2 20 0d    . 
l83b4h:
    inc ix                     ;83b4 dd 23  . # 
    ld a,(ix+002h)             ;83b6 dd 7e 02  . ~ . 
    cp 022h                    ;83b9 fe 22  . " 
    jr nz,l83b4h               ;83bb 20 f7    . 
l83bdh:
    inc ix                     ;83bd dd 23  . # 
    jr l83a6h                  ;83bf 18 e5  . . 
l83c1h:
    cp 0c0h                    ;83c1 fe c0  . . 
    ret nc                     ;83c3 d0  . 
    cp 080h                    ;83c4 fe 80  . . 
    jr c,l83bdh                ;83c6 38 f5  8 . 
    inc ix                     ;83c8 dd 23  . # 
    jr l83bdh                  ;83ca 18 f1  . . 
v_sub_7a98h:
    ld hl,00000h               ;83cc 21 00 00  ! . . 
    ld a,02bh                  ;83cf 3e 2b  > + 
v_l7a9dh:
    push hl                    ;83d1 e5  . 
    push af                    ;83d2 f5  . 
    ld a,(ix+002h)             ;83d3 dd 7e 02  . ~ . 
    push af                    ;83d6 f5  . 
    cp 02dh                    ;83d7 fe 2d  . - 
    jr nz,l83ddh               ;83d9 20 02    . 
    inc ix                     ;83db dd 23  . # 
l83ddh:
    ld a,(ix+002h)             ;83dd dd 7e 02  . ~ . 
    cp 024h                    ;83e0 fe 24  . $ 
    ld de,(v_l7953h+1)         ;83e2 ed 5b 94 1b  . [ . . 
    jr z,l8409h                ;83e6 28 21  ( ! 
    cp 080h                    ;83e8 fe 80  . . 
    jp c,v_l7b5bh              ;83ea da 9b 1d  . . . 
    ld d,a                     ;83ed 57  W 
    ld e,(ix+003h)             ;83ee dd 5e 03  . ^ . 
    inc ix                     ;83f1 dd 23  . # 
    call v_sub_8116h           ;83f3 cd 56 23  . V # 
    ld a,(hl)                  ;83f6 7e  ~ 
    and 0c0h                   ;83f7 e6 c0  . . 
    jr nz,l8404h               ;83f9 20 09    . 
    ld (vr_l080bfh+1),de       ;83fb ed 53 00 23  . S . # 
    ld a,009h                  ;83ff 3e 09  > . 
    jp v_l79c3h                ;8401 c3 03 1c  . . . 
l8404h:
    dec de                     ;8404 1b  . 
    ex de,hl                   ;8405 eb  . 
    ld d,(hl)                  ;8406 56  V 
    dec hl                     ;8407 2b  + 
    ld e,(hl)                  ;8408 5e  ^ 
l8409h:
    inc ix                     ;8409 dd 23  . # 
    jr l8439h                  ;840b 18 2c  . , 
v_l7ad9h:
    ld a,(ix+002h)             ;840d dd 7e 02  . ~ . 
    xor 02ch                   ;8410 ee 2c  . , 
    ld b,h                     ;8412 44  D 
    ld c,l                     ;8413 4d  M 
    ret z                      ;8414 c8  . 
    xor 033h                   ;8415 ee 33  . 3 
    ret z                      ;8417 c8  . 
    cp 0c0h                    ;8418 fe c0  . . 
    ccf                        ;841a 3f  ? 
    ret c                      ;841b d8  . 
    xor 01fh                   ;841c ee 1f  . . 
    inc ix                     ;841e dd 23  . # 
    jp v_l7a9dh                ;8420 c3 dd 1c  . . . 
l8423h:
    ld de,00000h               ;8423 11 00 00  . . . 
    inc ix                     ;8426 dd 23  . # 
    call v_sub_7b9dh           ;8428 cd dd 1d  . . . 
    jr c,l8437h                ;842b 38 0a  8 . 
    ld e,a                     ;842d 5f  _ 
    call v_sub_7b9dh           ;842e cd dd 1d  . . . 
    jr c,l8437h                ;8431 38 04  8 . 
    ld d,e                     ;8433 53  S 
    ld e,a                     ;8434 5f  _ 
    inc ix                     ;8435 dd 23  . # 
l8437h:
    ex de,hl                   ;8437 eb  . 
v_l7b04h:
    ex de,hl                   ;8438 eb  . 
l8439h:
    pop af                     ;8439 f1  . 
    call v_sub_7b50h           ;843a cd 90 1d  . . . 
    pop af                     ;843d f1  . 
    pop hl                     ;843e e1  . 
    ld bc,v_l7ad9h             ;843f 01 19 1d  . . . 
    push bc                    ;8442 c5  . 
v_sub_7b0fh:
    cp 02bh                    ;8443 fe 2b  . + 
    jr z,l847fh                ;8445 28 38  ( 8 
    cp 02dh                    ;8447 fe 2d  . - 
    jr z,l8481h                ;8449 28 36  ( 6 
    cp 02ah                    ;844b fe 2a  . * 
    jr z,l846eh                ;844d 28 1f  ( . 
    cp 02fh                    ;844f fe 2f  . / 
    jr z,l8468h                ;8451 28 15  ( . 
v_sub_7b1fh:
    ld a,h                     ;8453 7c  | 
    ld c,l                     ;8454 4d  M 
    ld hl,00000h               ;8455 21 00 00  ! . . 
    ld b,010h                  ;8458 06 10  . . 
l845ah:
    sli c                      ;845a cb 31  . 1 
    rla                        ;845c 17  . 
    adc hl,hl                  ;845d ed 6a  . j 
    sbc hl,de                  ;845f ed 52  . R 
    jr nc,l8465h               ;8461 30 02  0 . 
    add hl,de                  ;8463 19  . 
    dec c                      ;8464 0d  . 
l8465h:
    djnz l845ah                ;8465 10 f3  . . 
    ret                        ;8467 c9  . 
l8468h:
    call v_sub_7b1fh           ;8468 cd 5f 1d  . _ . 
    ld h,a                     ;846b 67  g 
    ld l,c                     ;846c 69  i 
    ret                        ;846d c9  . 
l846eh:
v_sub_7b3ah:
    ld b,010h                  ;846e 06 10  . . 
    ld a,h                     ;8470 7c  | 
    ld c,l                     ;8471 4d  M 
    ld hl,00000h               ;8472 21 00 00  ! . . 
l8475h:
    add hl,hl                  ;8475 29  ) 
    rl c                       ;8476 cb 11  . . 
    rla                        ;8478 17  . 
    jr nc,l847ch               ;8479 30 01  0 . 
    add hl,de                  ;847b 19  . 
l847ch:
    djnz l8475h                ;847c 10 f7  . . 
    ret                        ;847e c9  . 
l847fh:
    add hl,de                  ;847f 19  . 
    ret                        ;8480 c9  . 
l8481h:
    or a                       ;8481 b7  . 
    sbc hl,de                  ;8482 ed 52  . R 
v_sub_7b50h:
    cp 02dh                    ;8484 fe 2d  . - 
    ret nz                     ;8486 c0  . 
    ld a,d                     ;8487 7a  z 
    cpl                        ;8488 2f  / 
    ld d,a                     ;8489 57  W 
    ld a,e                     ;848a 7b  { 
    cpl                        ;848b 2f  / 
    ld e,a                     ;848c 5f  _ 
    inc de                     ;848d 13  . 
    ret                        ;848e c9  . 
v_l7b5bh:
    ld a,(ix+002h)             ;848f dd 7e 02  . ~ . 
    cp 022h                    ;8492 fe 22  . " 
    jr z,l8423h                ;8494 28 8d  ( . 
    ld c,00ah                  ;8496 0e 0a  . . 
    cp 025h                    ;8498 fe 25  . % 
    jr nz,l84a0h               ;849a 20 04    . 
    inc ix                     ;849c dd 23  . # 
    ld c,002h                  ;849e 0e 02  . . 
l84a0h:
    cp 023h                    ;84a0 fe 23  . # 
    jr nz,l84a8h               ;84a2 20 04    . 
    inc ix                     ;84a4 dd 23  . # 
    ld c,010h                  ;84a6 0e 10  . . 
l84a8h:
    ld hl,00000h               ;84a8 21 00 00  ! . . 
l84abh:
    ld a,(ix+002h)             ;84ab dd 7e 02  . ~ . 
    sub 030h                   ;84ae d6 30  . 0 
    cp 00ah                    ;84b0 fe 0a  . . 
    jr c,l84bbh                ;84b2 38 07  8 . 
    sub 007h                   ;84b4 d6 07  . . 
    cp 00ah                    ;84b6 fe 0a  . . 
    jp c,v_l7b04h              ;84b8 da 44 1d  . D . 
l84bbh:
    cp c                       ;84bb b9  . 
    jp nc,v_l7b04h             ;84bc d2 44 1d  . D . 
    push af                    ;84bf f5  . 
    ld a,c                     ;84c0 79  y 
    dec a                      ;84c1 3d  = 
    ld d,h                     ;84c2 54  T 
    ld e,l                     ;84c3 5d  ] 
l84c4h:
    add hl,de                  ;84c4 19  . 
    dec a                      ;84c5 3d  = 
    jr nz,l84c4h               ;84c6 20 fc    . 
    pop af                     ;84c8 f1  . 
    ld d,000h                  ;84c9 16 00  . . 
    ld e,a                     ;84cb 5f  _ 
    add hl,de                  ;84cc 19  . 
    inc ix                     ;84cd dd 23  . # 
    jr l84abh                  ;84cf 18 da  . . 
v_sub_7b9dh:
    ld a,(ix+002h)             ;84d1 dd 7e 02  . ~ . 
    cp 022h                    ;84d4 fe 22  . " 
    jr nz,l84e1h               ;84d6 20 09    . 
    cp (ix+003h)               ;84d8 dd be 03  . . . 
    inc ix                     ;84db dd 23  . # 
    jr z,l84e1h                ;84dd 28 02  ( . 
    scf                        ;84df 37  7 
    ret                        ;84e0 c9  . 
l84e1h:
    inc ix                     ;84e1 dd 23  . # 
    or a                       ;84e3 b7  . 
    ret                        ;84e4 c9  . 
v_sub_7bb1h:
    inc d                      ;84e5 14  .                         (flow from: 770a 7be5)  7bb1 inc d 
    ex af,af'                  ;84e6 08  .                         (flow from: 7bb1)  7bb2 ex af,af' 
    dec d                      ;84e7 15  .                         (flow from: 7bb2)  7bb3 dec d 
    di                         ;84e8 f3  .                         (flow from: 7bb3)  7bb4 di 
    ld a,00fh                  ;84e9 3e 0f  > .                    (flow from: 7bb4)  7bb5 ld a,0f 
    out (0feh),a               ;84eb d3 fe  . .                    (flow from: 7bb5)  7bb7 out (fe),a 
    call ROM_LoadBytes_562     ;84ed cd 62 05  . b .               (flow from: 7bb7)  7bb9 call 0562 
v_sub_7bbch:
    push af                    ;84f0 f5  .                         (flow from: 0000)  7bbc push af 
    ld a,07fh                  ;84f1 3e 7f  >                     (flow from: 7bbc)  7bbd ld a,7f 
    in a,(0feh)                ;84f3 db fe  . .                    (flow from: 7bbd)  7bbf in a,(fe) 
    rra                        ;84f5 1f  .                         (flow from: 7bbf)  7bc1 rra 
    jp nc,v_l80a2h             ;84f6 d2 e2 22  . . "               (flow from: 7bc1)  7bc2 jp nc,80a2 
    pop af                     ;84f9 f1  .                         (flow from: 7bc2)  7bc5 pop af 
    ret                        ;84fa c9  .                         (flow from: 7bc5)  7bc6 ret 
invokeMonitor:
    ld b,061h                  ;84fb 06 61  . a                    (flow (mon) from: 7e06)  7bc7 ld b,61 
    call v_sub_7c2ch           ;84fd cd 6c 1e  . l .               (flow (mon) from: 7bc7)  7bc9 call 7c2c 
    call z,v_sub_7805h         ;8500 cc 45 1a  . E .               (flow (mon) from: 7c38)  7bcc call z,7805 
    call v_sub_7ca1h           ;8503 cd e1 1e  . . .               (flow (mon) from: 7bcc)  7bcf call 7ca1 
    jp v_l5f74h                ;8506 c3 b4 01  . . .               (flow (mon) from: 7caf)  7bd2 jp 5f74 
invokeQuit:
    ld b,079h                  ;8509 06 79  . y 
    call v_sub_7c2ch           ;850b cd 6c 1e  . l . 
    ret nz                     ;850e c0  . 
    rst 0                      ;850f c7  . 
l8510h:
v_sub_7bdch:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS                             ;8510 dd 21 e0 50  . ! . P                                              (flow from: 77d1)  7bdc ld ix,50e0 
    ld de,00011h               ;8514 11 11 00  . . .               (flow from: 7bdc)  7be0 ld de,0011 
    xor a                      ;8517 af  .                         (flow from: 7be0)  7be3 xor a 
    scf                        ;8518 37  7                         (flow from: 7be3)  7be4 scf 
    call v_sub_7bb1h           ;8519 cd f1 1d  . . .               (flow from: 7be4)  7be5 call 7bb1 
    jr nc,l8510h               ;851c 30 f2  0 .                    (flow from: 7bc6)  7be8 jr nc,7bdc 
    ld a,011h                  ;851e 3e 11  > .                    (flow from: 7be8)  7bea ld a,11 
    call v_sub_80b4h           ;8520 cd f4 22  . . "               (flow from: 7bea)  7bec call 80b4 
    ld hl,050e1h               ;8523 21 e1 50  ! . P               (flow from: 80e0)  7bef ld hl,50e1 
    ld b,00ah                  ;8526 06 0a  . .                    (flow from: 7bef)  7bf2 ld b,0a 
l8528h:
    ld a,(hl)                  ;8528 7e  ~                         (flow from: 7bf2 7c03)  7bf4 ld a,(hl) 
    cp 020h                    ;8529 fe 20  .                      (flow from: 7bf4)  7bf5 cp 20 
    jr c,l8531h                ;852b 38 04  8 .                    (flow from: 7bf5)  7bf7 jr c,7bfd 
    cp 080h                    ;852d fe 80  . .                    (flow from: 7bf7)  7bf9 cp 80 
    jr c,l8533h                ;852f 38 02  8 .                    (flow from: 7bf9)  7bfb jr c,7bff 
l8531h:
    ld a,03fh                  ;8531 3e 3f  > ? 
l8533h:
    call v_sub_8744h           ;8533 cd 84 29  . . )               (flow from: 7bfb)  7bff call 8744 
    inc hl                     ;8536 23  #                         (flow from: 8749)  7c02 inc hl 
    djnz l8528h                ;8537 10 ef  . .                    (flow from: 7c02)  7c03 djnz 7bf4 
    ld a,(BOTTOM_LINE_VRAM_ADDRESS)                            ;8539 3a e0 50  : . P                                                   (flow from: 7c03)  7c05 ld a,(50e0) 
    cp 003h                    ;853c fe 03  . .                    (flow from: 7c05)  7c08 cp 03 
    jr nz,l8510h               ;853e 20 d0    .                    (flow from: 7c08)  7c0a jr nz,7bdc 
    ret                        ;8540 c9  .                         (flow from: 7c0a)  7c0c ret 
v_sub_7c0dh:
    ld b,00ah                  ;8541 06 0a  . .                    (flow from: 77d4)  7c0d ld b,0a 
    ld hl,v_l76d5h             ;8543 21 15 19  ! . .               (flow from: 7c0d)  7c0f ld hl,76d5 
l8546h:
    ld a,(hl)                  ;8546 7e  ~                         (flow from: 7c0f)  7c12 ld a,(hl) 
    cp 020h                    ;8547 fe 20  .                      (flow from: 7c12)  7c13 cp 20 
    jr nz,l854eh               ;8549 20 03    .                    (flow from: 7c13)  7c15 jr nz,7c1a 
    djnz l8546h                ;854b 10 f9  . . 
    ret                        ;854d c9  . 
l854eh:
v_sub_7c1ah:
    ld b,00ah                  ;854e 06 0a  . .                    (flow from: 7c15)  7c1a ld b,0a 
    ld hl,v_l76d5h             ;8550 21 15 19  ! . .               (flow from: 7c1a)  7c1c ld hl,76d5 
    ld de,050e1h               ;8553 11 e1 50  . . P               (flow from: 7c1c)  7c1f ld de,50e1 
l8556h:
    ld a,(de)                  ;8556 1a  .                         (flow from: 7c1f 7c27)  7c22 ld a,(de) 
    cp (hl)                    ;8557 be  .                         (flow from: 7c22)  7c23 cp (hl) 
    inc hl                     ;8558 23  #                         (flow from: 7c23)  7c24 inc hl 
    inc de                     ;8559 13  .                         (flow from: 7c24)  7c25 inc de 
    ret nz                     ;855a c0  .                         (flow from: 7c25)  7c26 ret nz 
    djnz l8556h                ;855b 10 f9  . .                    (flow from: 7c26)  7c27 djnz 7c22 
    ret                        ;855d c9  .                         (flow from: 7c27)  7c29 ret 
v_sub_7c2ah:
    ld b,042h                  ;855e 06 42  . B 
v_sub_7c2ch:
    ld hl,inputBufferStart+1   ;8560 21 40 2d  ! @ -               (flow from: 76b8)  7c2c ld hl,8b00 
v_sub_7c2fh:
    call atHLorNextIfOne       ;8563 cd ee 27  . . '               (flow from: 7c2c)  7c2f call 85ae 
    inc hl                     ;8566 23  #                         (flow from: 85b1)  7c32 inc hl 
v_sub_7c33h:
    cp b                       ;8567 b8  .                         (flow from: 7c32)  7c33 cp b 
    ret z                      ;8568 c8  .                         (flow from: 7c33)  7c34 ret z 
    set 5,b                    ;8569 cb e8  . .                    (flow (mon) from: 7c34)  7c35 set 5,b 
    cp b                       ;856b b8  .                         (flow (mon) from: 7c35)  7c37 cp b 
    ret                        ;856c c9  .                         (flow (mon) from: 7c37)  7c38 ret 
v_l7c39h:
invokeH:
        ld hl,l0923ch+1                                        ;856d 21 49 2b  ! I + 
    jr l8575h                  ;8570 18 03  . . 
v_sub_7c3eh:
invokeW:
    ld hl,vr_l07e1eh+1         ;8572 21 5f 20  ! _   
l8575h:
v_l7c41h:
    ld a,(hl)                  ;8575 7e  ~ 
    xor 001h                   ;8576 ee 01  . . 
    ld (hl),a                  ;8578 77  w 
    ret                        ;8579 c9  . 
invokeBasic:
    ld iy,05c3ah               ;857a fd 21 3a 5c  . ! : \          (flow from: 7e06)  7c46 ld iy,5c3a 
    im 1                       ;857e ed 56  . V                    (flow from: 7c46)  7c4a im 1 
    ei                         ;8580 fb  .                         (flow from: 7c4a)  7c4c ei 
    ld sp,(SYSVAR_ERR_SP)      ;8581                               (flow from: 7c4c)  7c4d ld sp,(5c3d) 
    jp 01b76h                  ;8585 c3 76 1b  . v .               (flow from: 7c4d)  7c51 jp 1b76 
v_sub_7c54h:
    push af                    ;8588 f5  . 
    ld c,000h                  ;8589 0e 00  . . 
    call ROM_PixelAddress_22b0                                 ;858b cd b0 22  . . " 
    push hl                    ;858e e5  . 
    call v_sub_7c83h           ;858f cd c3 1e  . . . 
    pop de                     ;8592 d1  . 
    pop af                     ;8593 f1  . 
    ret                        ;8594 c9  . 
v_sub_7c61h:
    push hl                    ;8595 e5  . 
    pop ix                     ;8596 dd e1  . . 
    call v_sub_828fh           ;8598 cd cf 24  . . $ 
    ld a,0efh                  ;859b 3e ef  > . 
    in a,(0feh)                ;859d db fe  . . 
    ret                        ;859f c9  . 
v_sub_7c6ch:
    call v_sub_8232h           ;85a0 cd 72 24  . r $               (flow from: 7d77)  7c6c call 8232 
    call v_sub_8a24h           ;85a3 cd 64 2c  . d ,               (flow from: 8244)  7c6f call 8a24 
    ccf                        ;85a6 3f  ?                         (flow from: 8a2e)  7c72 ccf 
    jr l85afh                  ;85a7 18 06  . .                    (flow from: 7c72)  7c73 jr 7c7b 
v_sub_7c75h:
    call v_sub_8245h           ;85a9 cd 85 24  . . $               (flow from: 7d3e)  7c75 call 8245 
    call v_sub_8a2fh           ;85ac cd 6f 2c  . o ,               (flow from: 825a)  7c78 call 8a2f 
l85afh:
    pop de                     ;85af d1  .                         (flow from: 7c73 8a3e)  7c7b pop de 
    jr nc,l8622h               ;85b0 30 70  0 p                    (flow from: 7c7b)  7c7c jr nc,7cee 
    push de                    ;85b2 d5  .                         (flow from: 7c7c)  7c7e push de 
    ld (v_sub_826ch+1),hl      ;85b3 22 ad 24  " . $               (flow from: 7c7e)  7c7f ld (826d),hl 
    ret                        ;85b6 c9  .                         (flow from: 7c7f)  7c82 ret 
v_sub_7c83h:
    push hl                    ;85b7 e5  . 
    push de                    ;85b8 d5  . 
    ld b,008h                  ;85b9 06 08  . . 
l85bbh:
    push hl                    ;85bb e5  . 
    push de                    ;85bc d5  . 
    ld c,020h                  ;85bd 0e 20  .   
l85bfh:
    ld a,(hl)                  ;85bf 7e  ~ 
    ld (de),a                  ;85c0 12  . 
    inc l                      ;85c1 2c  , 
    inc e                      ;85c2 1c  . 
    dec c                      ;85c3 0d  . 
    jr nz,l85bfh               ;85c4 20 f9    . 
    pop de                     ;85c6 d1  . 
    pop hl                     ;85c7 e1  . 
    inc h                      ;85c8 24  $ 
    inc d                      ;85c9 14  . 
    djnz l85bbh                ;85ca 10 ef  . . 
    pop de                     ;85cc d1  . 
    pop hl                     ;85cd e1  . 
    ret                        ;85ce c9  . 
v_sub_7c9bh:
    ld (de),a                  ;85cf 12  . 
    inc de                     ;85d0 13  . 
    dec c                      ;85d1 0d  . 
    ret nz                     ;85d2 c0  . 
    jr l8603h                  ;85d3 18 2e  . . 
v_sub_7ca1h:
    ld e,020h                  ;85d5 1e 20  .                      (flow (mon) from: 7bcf)  7ca1 ld e,20 
v_l7ca3h:
    ld bc,00003h               ;85d7 01 03 00  . . .               (flow from: 7ccc)  7ca3 ld bc,0003 
l85dah:
    ld a,e                     ;85da 7b  {                         (flow from: 7ca3 7caa 7cad)  7ca6 ld a,e 
    call v_sub_8769h           ;85db cd a9 29  . . )               (flow from: 7ca6)  7ca7 call 8769 
    djnz l85dah                ;85de 10 fa  . .                    (flow from: 877e)  7caa djnz 7ca6 
    dec c                      ;85e0 0d  .                         (flow from: 7caa)  7cac dec c 
    jr nz,l85dah               ;85e1 20 f7    .                    (flow from: 7cac)  7cad jr nz,7ca6 
    ret                        ;85e3 c9  .                         (flow from: 7cad)  7caf ret 
invokeRun:
    ld a,001h                  ;85e4 3e 01  > . 
        ld (l085ech+1),a                                       ;85e6 32 f9 1e  2 . . 
    call v_sub_7805h           ;85e9 cd 45 1a  . E . 
l085ech:
    ld a,000h                  ;85ec 3e 00  > . 
    or a                       ;85ee b7  . 
    ld a,013h                  ;85ef 3e 13  > . 
    jp nz,v_l809ah             ;85f1 c2 da 22  . . " 
    call v_sub_7ca1h           ;85f4 cd e1 1e  . . . 
vr_l07cc3h:
    call 00000h                ;85f7 cd 00 00  . . . 
v_l7cc6h:
    call v_sub_8639h           ;85fa cd 79 28  . y ( 
v_l7cc9h:
    di                         ;85fd f3  .                         (flow from: 5dc0)  7cc9 di 
    ld e,07eh                  ;85fe 1e 7e  . ~                    (flow from: 7cc9)  7cca ld e,7e 
    call v_l7ca3h              ;8600 cd e3 1e  . . .               (flow from: 7cca)  7ccc call 7ca3 
l8603h:
v_l7ccfh:
    ld hl,059e0h               ;8603 21 e0 59  ! . Y               (flow from: 777a 7caf 7e38)  7ccf ld hl,59e0 
    ld bc,02000h+HIGHLIGHT_COLOR                               ;8606 01 30 20  . 0                                                     (flow from: 7ccf)  7cd2 ld bc,2030                                  (flow from: 7ccf)  7cd2 ld bc,2030 
    call atHLrepeatBTimesC     ;8609 cd 21 25  . ! %               (flow from: 7cd2)  7cd5 call 82e1 
    ld a,00fh                  ;860c 3e 0f  > .                    (flow from: 82e5)  7cd8 ld a,0f 
v_l7cdah:
    call v_l89f4h              ;860e cd 34 2c  . 4 ,               (flow from: 7cd8)  7cda call 89f4 
    ld hl,v_l8aa5h             ;8611 21 e5 2c  ! . ,               (flow from: 8a1d)  7cdd ld hl,8aa5 
    ld bc,09e00h               ;8614 01 00 9e  . . .               (flow from: 7cdd)  7ce0 ld bc,9e00 
    call atHLrepeatBTimesC     ;8617 cd 21 25  . ! %               (flow from: 7ce0)  7ce3 call 82e1 
    ld hl,inputBufferStart     ;861a 21 3f 2d  ! ? -               (flow from: 82e5)  7ce6 ld hl,8aff 
    ld (hl),001h               ;861d 36 01  6 .                    (flow from: 7ce6)  7ce9 ld (hl),01 
    dec hl                     ;861f 2b  +                         (flow from: 7ce9)  7ceb dec hl 
    ld (hl),080h               ;8620 36 80  6 .                    (flow from: 7ceb)  7cec ld (hl),80 
l8622h:
v_l7ceeh:
        ld sp,l094d5h                                          ;8622 31 e1 2d  1 . -                                                   (flow from: 7c7c 7cec 7d36 7d43)  7cee ld sp,8ba1                   (flow from: 7c7c 7cec 7d36 7d43)  7cee ld sp,8ba1 
    call v_sub_826ch           ;8625 cd ac 24  . . $               (flow from: 7cee)  7cf1 call 826c 
l8628h:
    call v_sub_85beh           ;8628 cd fe 27  . . '               (flow from: 7d71 828e)  7cf4 call 85be 
    call v_sub_7800h           ;862b cd 40 1a  . @ .               (flow from: 85db)  7cf7 call 7800 
    call v_sub_8639h           ;862e cd 79 28  . y (               (flow from: 7804)  7cfa call 8639 
    push af                    ;8631 f5  .                         (flow from: 86a0 86ad)  7cfd push af 
l08632h:
                               ; value of the argument is modified directly in the code at address 8639
vr_l07cfeh:
    ld a,00fh                  ;8632 3e 0f  > .                    (flow from: 7cfd)  7cfe ld a,0f 
    call v_l89f4h              ;8634 cd 34 2c  . 4 ,               (flow from: 7cfe)  7d00 call 89f4 
    ld a,00fh                  ;8637 3e 0f  > .                    (flow from: 8a1d)  7d03 ld a,0f 
    ld (l08632h+1),a                                           ;8639 32 3f 1f  2 ? .                                                   (flow from: 7d03)   7d05 ld (7cff),a                                (flow from: 7d03)  7d05 ld (7cff),a 
    pop af                     ;863c f1  .                         (flow from: 7d05)  7d08 pop af 
    cp 015h                    ;863d fe 15  . .                    (flow from: 7d08)  7d09 cp 15 
    jr z,l8603h                ;863f 28 c2  ( .                    (flow from: 7d09)  7d0b jr z,7ccf 
    cp 004h                    ;8641 fe 04  . .                    (flow from: 7d0b)  7d0d cp 04 
    jr nz,l865eh               ;8643 20 19    .                    (flow from: 7d0d)  7d0f jr nz,7d2a 
    ld ix,(v_sub_826ch+1)      ;8645 dd 2a ad 24  . * . $          (flow from: 7d0f)  7d11 ld ix,(826d) 
    ld hl,inputBufferStart     ;8649 21 3f 2d  ! ? -               (flow from: 7d11)  7d15 ld hl,8aff 
    push hl                    ;864c e5  .                         (flow from: 7d15)  7d18 push hl 
    ld bc,02000h               ;864d 01 00 20  . .                 (flow from: 7d18)  7d19 ld bc,2000 
    call atHLrepeatBTimesC     ;8650 cd 21 25  . ! %               (flow from: 7d19)  7d1c call 82e1 
    pop hl                     ;8653 e1  .                         (flow from: 82e5)  7d1f pop hl 
    call v_sub_8138h           ;8654 cd 78 23  . x #               (flow from: 7d1f)  7d20 call 8138 
    ld a,001h                  ;8657 3e 01  > .                    (flow from: 81b6)  7d23 ld a,01 
    ld (vr_l07e1eh+1),a        ;8659 32 5f 20  2 _                 (flow from: 7d23)  7d25 ld (7e1f),a 
    jr l8665h                  ;865c 18 07  . .                    (flow from: 7d25)  7d28 jr 7d31 
l865eh:
    cp 014h                    ;865e fe 14  . .                    (flow from: 7d0f)  7d2a cp 14 
    jr nz,l866ch               ;8660 20 0a    .                    (flow from: 7d2a)  7d2c jr nz,7d38 
    call v_sub_7c3eh           ;8662 cd 7e 1e  . ~ . 
l8665h:
    ld a,00fh                  ;8665 3e 0f  > .                    (flow from: 7d28)  7d31 ld a,0f 
    call v_l89f4h              ;8667 cd 34 2c  . 4 ,               (flow from: 7d31)  7d33 call 89f4 
    jr l8622h                  ;866a 18 b6  . .                    (flow from: 8a1d)  7d36 jr 7cee 
l866ch:
    ld b,014h                  ;866c 06 14  . .                    (flow from: 7d2c)  7d38 ld b,14 
    cp 006h                    ;866e fe 06  . .                    (flow from: 7d38)  7d3a cp 06 
    jr nz,l8679h               ;8670 20 07    .                    (flow from: 7d3a)  7d3c jr nz,7d45 
l8672h:
    call v_sub_7c75h           ;8672 cd b5 1e  . . .               (flow from: 7d3c)  7d3e call 7c75 
    djnz l8672h                ;8675 10 fb  . . 
l8677h:
    jr l8622h                  ;8677 18 a9  . .                    (flow from: 7d7c)  7d43 jr 7cee 
l8679h:
    cp 009h                    ;8679 fe 09  . .                    (flow from: 7d3c)  7d45 cp 09 
    jr nz,l86a7h               ;867b 20 2a    *                    (flow from: 7d45)  7d47 jr nz,7d73 
l867dh:
    call v_sub_7c75h           ;867d cd b5 1e  . . . 
    ld de,04040h               ;8680 11 40 40  . @ @ 
    ld a,018h                  ;8683 3e 18  > . 
l8685h:
    call v_sub_7c54h           ;8685 cd 94 1e  . . . 
    add a,008h                 ;8688 c6 08  . . 
    cp 0a9h                    ;868a fe a9  . . 
    jr c,l8685h                ;868c 38 f7  8 . 
    ld hl,050a0h               ;868e 21 a0 50  ! . P 
    call v_sub_85f5h           ;8691 cd 35 28  . 5 ( 
    ld b,006h                  ;8694 06 06  . . 
    ld hl,(v_sub_826ch+1)      ;8696 2a ad 24  * . $ 
l8699h:
    call v_sub_8248h           ;8699 cd 88 24  . . $ 
    djnz l8699h                ;869c 10 fb  . . 
    call v_sub_7c61h           ;869e cd a1 1e  . . . 
    bit 4,a                    ;86a1 cb 67  . g 
    jr z,l867dh                ;86a3 28 d8  ( . 
l86a5h:
    jr l8628h                  ;86a5 18 81  . .                    (flow from: 7daa)  7d71 jr 7cf4 
l86a7h:
    cp 007h                    ;86a7 fe 07  . .                    (flow from: 7d47)  7d73 cp 07 
    jr nz,l86b2h               ;86a9 20 07    .                    (flow from: 7d73)  7d75 jr nz,7d7e 
l86abh:
    call v_sub_7c6ch           ;86ab cd ac 1e  . . .               (flow from: 7d75 7d7a)  7d77 call 7c6c 
    djnz l86abh                ;86ae 10 fb  . .                    (flow from: 7c82)  7d7a djnz 7d77 
l86b0h:
    jr l8677h                  ;86b0 18 c5  . .                    (flow from: 7d7a)  7d7c jr 7d43 
l86b2h:
    cp 00ah                    ;86b2 fe 0a  . .                    (flow from: 7d75)  7d7e cp 0a 
    jr nz,l86e0h               ;86b4 20 2a    *                    (flow from: 7d7e)  7d80 jr nz,7dac 
l86b6h:
    call v_sub_7c6ch           ;86b6 cd ac 1e  . . . 
    ld de,050a0h               ;86b9 11 a0 50  . . P 
    ld a,0a0h                  ;86bc 3e a0  > . 
l86beh:
    call v_sub_7c54h           ;86be cd 94 1e  . . . 
    sub 008h                   ;86c1 d6 08  . . 
    cp 010h                    ;86c3 fe 10  . . 
    jr nc,l86beh               ;86c5 30 f7  0 . 
    ld hl,04040h               ;86c7 21 40 40  ! @ @ 
    call v_sub_85f5h           ;86ca cd 35 28  . 5 ( 
    ld b,00dh                  ;86cd 06 0d  . . 
    ld hl,(v_sub_826ch+1)      ;86cf 2a ad 24  * . $ 
l86d2h:
    call v_sub_8235h           ;86d2 cd 75 24  . u $ 
    djnz l86d2h                ;86d5 10 fb  . . 
    call v_sub_7c61h           ;86d7 cd a1 1e  . . . 
    bit 3,a                    ;86da cb 5f  . _ 
    jr z,l86b6h                ;86dc 28 d8  ( . 
l86deh:
    jr l86a5h                  ;86de 18 c5  . .                    (flow from: 7ddb)  7daa jr 7d71 
l86e0h:
    cp 00ch                    ;86e0 fe 0c  . .                    (flow from: 7d80)  7dac cp 0c 
    jr nz,l86fah               ;86e2 20 16    .                    (flow from: 7dac)  7dae jr nz,7dc6 
    ld bc,00001h               ;86e4 01 01 00  . . . 
    ld hl,(v_sub_826ch+1)      ;86e7 2a ad 24  * . $ 
    call v_sub_721ah           ;86ea cd 5a 14  . Z . 
    call v_sub_8a24h           ;86ed cd 64 2c  . d , 
    jr z,l86b0h                ;86f0 28 be  ( . 
    call nc,v_sub_8235h        ;86f2 d4 75 24  . u $ 
    ld (v_sub_826ch+1),hl      ;86f5 22 ad 24  " . $ 
l86f8h:
    jr l86b0h                  ;86f8 18 b6  . . 
l86fah:
    cp 00eh                    ;86fa fe 0e  . .                    (flow from: 7dae)  7dc6 cp 0e 
    jr nz,l870ch               ;86fc 20 0e    .                    (flow from: 7dc6)  7dc8 jr nz,7dd8 
    ld hl,(vr_l080eah+1)       ;86fe 2a 2b 23  * + # 
    ld (vr_l080e7h+1),hl       ;8701 22 28 23  " ( # 
    ld hl,(v_sub_826ch+1)      ;8704 2a ad 24  * . $ 
    ld (vr_l080eah+1),hl       ;8707 22 2b 23  " + # 
    jr l86f8h                  ;870a 18 ec  . . 
l870ch:
    call v_sub_7e3bh           ;870c cd 7b 20  . {                 (flow from: 7dc8)  7dd8 call 7e3b 
    jr nz,l86deh               ;870f 20 cd    .                    (flow from: 7e40 7e73)  7ddb jr nz,7daa 
v_l7dddh:
    ld hl,LEFT_BOTTOM_ATTRIBUTE_ADDRESS                        ;8711 21 e0 5a  ! . Z                                                   (flow from: 775d 7ddb)  7ddd ld hl,5ae0 
    ld bc,0203fh               ;8714 01 3f 20  . ?                 (flow from: 7ddd)  7de0 ld bc,203f 
    call atHLrepeatBTimesC     ;8717 cd 21 25  . ! %               (flow from: 7de0)  7de3 call 82e1 
    ld hl,inputBufferStart     ;871a 21 3f 2d  ! ? -               (flow from: 82e5)  7de6 ld hl,8aff 
    call atHLorNextIfOne       ;871d cd ee 27  . . '               (flow from: 7de6)  7de9 call 85ae 
    ld d,000h                  ;8720 16 00  . .                    (flow from: 85b1)  7dec ld d,00 
    ld c,009h                  ;8722 0e 09  . .                    (flow from: 7dec)  7dee ld c,09 
    cp 080h                    ;8724 fe 80  . .                    (flow from: 7dee)  7df0 cp 80 
    jr c,l873bh                ;8726 38 13  8 .                    (flow from: 7df0)  7df2 jr c,7e07 
    ld hl,v_l7ccfh             ;8728 21 0f 1f  ! . .               (flow from: 7df2)  7df4 ld hl,7ccf 
    ld (vr_l07e38h+1),hl       ;872b 22 79 20  " y                 (flow from: 7df4)  7df7 ld (7e39),hl 
    push hl                    ;872e e5  .                         (flow from: 7df7)  7dfa push hl 
    ld h,d                     ;872f 62  b                         (flow from: 7dfa)  7dfb ld h,d 
    ld l,a                     ;8730 6f  o                         (flow from: 7dfb)  7dfc ld l,a 
    ld de,v_l6fc9h             ;8731 11 09 12  . . .               (flow from: 7dfc)  7dfd ld de,6fc9 
    add hl,hl                  ;8734 29  )                         (flow from: 7dfd)  7e00 add hl,hl 
    add hl,de                  ;8735 19  .                         (flow from: 7e00)  7e01 add hl,de 
    ld a,(hl)                  ;8736 7e  ~                         (flow from: 7e01)  7e02 ld a,(hl) 
    inc hl                     ;8737 23  #                         (flow from: 7e02)  7e03 inc hl 
    ld h,(hl)                  ;8738 66  f                         (flow from: 7e03)  7e04 ld h,(hl) 
    ld l,a                     ;8739 6f  o                         (flow from: 7e04)  7e05 ld l,a 
    jp (hl)                    ;873a e9  .                         (flow from: 7e05)  7e06 jp hl 
l873bh:
v_l7e07h:
    call v_sub_7ee7h           ;873b cd 27 21  . ' !               (flow from: 7df2)  7e07 call 7ee7 
    call v_sub_8245h           ;873e cd 85 24  . . $               (flow from: 8000)  7e0a call 8245 
    push hl                    ;8741 e5  .                         (flow from: 8255 825a)  7e0d push hl 
    ld (vr_l0896eh+1),hl       ;8742 22 af 2b  " . +               (flow from: 7e0d)  7e0e ld (896f),hl 
    ld de,v_l8b21h             ;8745 11 61 2d  . a -               (flow from: 7e0e)  7e11 ld de,8b21 
    ld a,(de)                  ;8748 1a  .                         (flow from: 7e11)  7e14 ld a,(de) 
    ld c,a                     ;8749 4f  O                         (flow from: 7e14)  7e15 ld c,a 
    inc de                     ;874a 13  .                         (flow from: 7e15)  7e16 inc de 
    call v_sub_8a6ch           ;874b cd ac 2c  . . ,               (flow from: 7e16)  7e17 call 8a6c 
    pop hl                     ;874e e1  .                         (flow from: 8aa3)  7e1a pop hl 
    ld (v_sub_826ch+1),hl      ;874f 22 ad 24  " . $               (flow from: 7e1a)  7e1b ld (826d),hl 
vr_l07e1eh:
    ld a,000h                  ;8752 3e 00  > .                    (flow from: 7e1b)  7e1e ld a,01 
    or a                       ;8754 b7  .                         (flow from: 7e1e)  7e20 or a 
    jr z,l8763h                ;8755 28 0c  ( .                    (flow from: 7e20)  7e21 jr z,7e2f 
    call v_sub_8232h           ;8757 cd 72 24  . r $               (flow from: 7e21)  7e23 call 8232 
    ld (v_sub_826ch+1),hl      ;875a 22 ad 24  " . $               (flow from: 8244)  7e26 ld (826d),hl 
    ld bc,00001h               ;875d 01 01 00  . . .               (flow from: 7e26)  7e29 ld bc,0001 
    call v_sub_898ah           ;8760 cd ca 2b  . . +               (flow from: 7e29)  7e2c call 898a 
l8763h:
    ld a,00fh                  ;8763 3e 0f  > .                    (flow from: 7e21 8989)  7e2f ld a,0f 
    ld (vr_l07cfeh+1),a        ;8765 32 3f 1f  2 ? .               (flow from: 7e2f)  7e31 ld (7cff),a 
v_l7e34h:
    xor a                      ;8768 af  .                         (flow from: 7e31)  7e34 xor a 
    ld (vr_l07e1eh+1),a        ;8769 32 5f 20  2 _                 (flow from: 7e34)  7e35 ld (7e1f),a 
vr_l07e38h:
    jp v_l7ccfh                ;876c c3 0f 1f  . . .               (flow from: 7e35)  7e38 jp 7ccf 
v_sub_7e3bh:
vr_l07e3bh:
    ld hl,inputBufferStart+1   ;876f 21 40 2d  ! @ -               (flow from: 7dd8)  7e3b ld hl,8b00 
    cp 00dh                    ;8772 fe 0d  . .                    (flow from: 7e3b)  7e3e cp 0d 
    ret z                      ;8774 c8  .                         (flow from: 7e3e)  7e40 ret z 
    cp 008h                    ;8775 fe 08  . .                    (flow from: 7e40)  7e41 cp 08 
    jr nz,l8785h               ;8777 20 0c    .                    (flow from: 7e41)  7e43 jr nz,7e51 
    ld b,(hl)                  ;8779 46  F 
    dec hl                     ;877a 2b  + 
    ld a,(hl)                  ;877b 7e  ~ 
    rlca                       ;877c 07  . 
    jr c,l87a6h                ;877d 38 27  8 ' 
    ld c,(hl)                  ;877f 4e  N 
    ld (hl),b                  ;8780 70  p 
    inc hl                     ;8781 23  # 
    ld (hl),c                  ;8782 71  q 
    jr l87a6h                  ;8783 18 21  . ! 
l8785h:
    cp 00bh                    ;8785 fe 0b  . .                    (flow from: 7e43)  7e51 cp 0b 
    jr nz,l8793h               ;8787 20 0a    .                    (flow from: 7e51)  7e53 jr nz,7e5f 
    ld b,(hl)                  ;8789 46  F 
    inc hl                     ;878a 23  # 
    ld a,(hl)                  ;878b 7e  ~ 
    and a                      ;878c a7  . 
    jr z,l87a6h                ;878d 28 17  ( . 
    ld (hl),b                  ;878f 70  p 
    dec hl                     ;8790 2b  + 
    ld (hl),a                  ;8791 77  w 
    ret                        ;8792 c9  . 
l8793h:
    cp 003h                    ;8793 fe 03  . .                    (flow from: 7e53)  7e5f cp 03 
    jr nz,l87a8h               ;8795 20 11    .                    (flow from: 7e5f)  7e61 jr nz,7e74 
    ld d,h                     ;8797 54  T                         (flow from: 7e61)  7e63 ld d,h 
    ld e,l                     ;8798 5d  ]                         (flow from: 7e63)  7e64 ld e,l 
    dec hl                     ;8799 2b  +                         (flow from: 7e64)  7e65 dec hl 
    ld a,(hl)                  ;879a 7e  ~                         (flow from: 7e65)  7e66 ld a,(hl) 
    cp 080h                    ;879b fe 80  . .                    (flow from: 7e66)  7e67 cp 80 
    jr z,l87a6h                ;879d 28 07  ( .                    (flow from: 7e67)  7e69 jr z,7e72 
l879fh:
    ld a,(de)                  ;879f 1a  .                         (flow from: 7e69 7e70)  7e6b ld a,(de) 
    ld (hl),a                  ;87a0 77  w                         (flow from: 7e6b)  7e6c ld (hl),a 
    inc hl                     ;87a1 23  #                         (flow from: 7e6c)  7e6d inc hl 
    inc de                     ;87a2 13  .                         (flow from: 7e6d)  7e6e inc de 
    or a                       ;87a3 b7  .                         (flow from: 7e6e)  7e6f or a 
    jr nz,l879fh               ;87a4 20 f9    .                    (flow from: 7e6f)  7e70 jr nz,7e6b 
l87a6h:
    inc a                      ;87a6 3c  <                         (flow from: 7e70 7e7f 7ec7)  7e72 inc a 
    ret                        ;87a7 c9  .                         (flow from: 7e72)  7e73 ret 
l87a8h:
    cp 005h                    ;87a8 fe 05  . .                    (flow from: 7e61)  7e74 cp 05 
    jr nz,l87b5h               ;87aa 20 09    .                    (flow from: 7e74)  7e76 jr nz,7e81 
        ld hl,l08fa1h+1                                        ;87ac 21 ae 28  ! . (                                                   (flow from: 7e76)  7e78 ld hl,866e                                  (flow from: 7e76)  7e78 ld hl,866e 
    ld a,0f7h                  ;87af 3e f7  > .                    (flow from: 7e78)  7e7b ld a,f7 
    sub (hl)                   ;87b1 96  .                         (flow from: 7e7b)  7e7d sub (hl) 
    ld (hl),a                  ;87b2 77  w                         (flow from: 7e7d)  7e7e ld (hl),a 
    jr l87a6h                  ;87b3 18 f1  . .                    (flow from: 7e7e)  7e7f jr 7e72 
l87b5h:
    cp 020h                    ;87b5 fe 20  .                      (flow from: 7e76)  7e81 cp 20 
    ret c                      ;87b7 d8  .                         (flow from: 7e81)  7e83 ret c 
    ld b,a                     ;87b8 47  G                         (flow from: 7e83)  7e84 ld b,a 
    jr nz,l87e0h               ;87b9 20 25    %                    (flow from: 7e84)  7e85 jr nz,7eac 
    ld de,inputBufferStart     ;87bb 11 3f 2d  . ? - 
    ld a,(de)                  ;87be 1a  . 
    cp 03bh                    ;87bf fe 3b  .                  ; 
    jr z,l87e0h                ;87c1 28 1d  ( . 
    rlca                       ;87c3 07  . 
    jr c,l87e0h                ;87c4 38 1a  8 . 
    push hl                    ;87c6 e5  . 
    sbc hl,de                  ;87c7 ed 52  . R 
    ld a,00dh                  ;87c9 3e 0d  > . 
    sub l                      ;87cb 95  . 
    pop hl                     ;87cc e1  . 
    jr c,l87e0h                ;87cd 38 11  8 . 
    cp 005h                    ;87cf fe 05  . . 
    jr c,l87d5h                ;87d1 38 02  8 . 
    sub 005h                   ;87d3 d6 05  . . 
l87d5h:
    ld b,a                     ;87d5 47  G 
    inc b                      ;87d6 04  . 
    ld c,020h                  ;87d7 0e 20  .   
    call atHLrepeatBTimesC     ;87d9 cd 21 25  . ! % 
    ld (hl),001h               ;87dc 36 01  6 . 
    jr l87a6h                  ;87de 18 c6  . . 
l87e0h:
vr_l07each:
    ld a,007h                  ;87e0 3e 07  > .                    (flow from: 7e85)  7eac ld a,01 
    or a                       ;87e2 b7  .                         (flow from: 7eac)  7eae or a 
    jr z,l87a6h                ;87e3 28 c1  ( .                    (flow from: 7eae)  7eaf jr z,7e72 
    ld a,b                     ;87e5 78  x                         (flow from: 7eaf)  7eb1 ld a,b 
l87e6h:
    ex af,af'                  ;87e6 08  .                         (flow from: 7eb1 7ec5)  7eb2 ex af,af' 
    ld a,(hl)                  ;87e7 7e  ~                         (flow from: 7eb2)  7eb3 ld a,(hl) 
    ex af,af'                  ;87e8 08  .                         (flow from: 7eb3)  7eb4 ex af,af' 
    ld (hl),a                  ;87e9 77  w                         (flow from: 7eb4)  7eb5 ld (hl),a 
    cp 0c5h                    ;87ea fe c5  . .                    (flow from: 7eb5)  7eb6 cp c5 
    ret z                      ;87ec c8  .                         (flow from: 7eb6)  7eb8 ret z 
    cp 0c8h                    ;87ed fe c8  . .                    (flow from: 7eb8)  7eb9 cp c8 
    ret z                      ;87ef c8  .                         (flow from: 7eb9)  7ebb ret z 
    cp 0cbh                    ;87f0 fe cb  . .                    (flow from: 7ebb)  7ebc cp cb 
    ret z                      ;87f2 c8  .                         (flow from: 7ebc)  7ebe ret z 
    cp 0d7h                    ;87f3 fe d7  . .                    (flow from: 7ebe)  7ebf cp d7 
    ret z                      ;87f5 c8  .                         (flow from: 7ebf)  7ec1 ret z 
    inc hl                     ;87f6 23  #                         (flow from: 7ec1)  7ec2 inc hl 
    ex af,af'                  ;87f7 08  .                         (flow from: 7ec2)  7ec3 ex af,af' 
    or a                       ;87f8 b7  .                         (flow from: 7ec3)  7ec4 or a 
    jr nz,l87e6h               ;87f9 20 eb    .                    (flow from: 7ec4)  7ec5 jr nz,7eb2 
    jr l87a6h                  ;87fb 18 a9  . .                    (flow from: 7ec5)  7ec7 jr 7e72 
l87fdh:
    ld ix,v_l8b24h             ;87fd dd 21 64 2d  . ! d - 
    ld (ix-002h),001h          ;8801 dd 36 fe 01  . 6 . . 
    ld (ix-001h),037h          ;8805 dd 36 ff 37  . 6 . 7 
    ld b,0ffh                  ;8809 06 ff  . . 
    jr l8810h                  ;880b 18 03  . . 
l880dh:
    call v_sub_85adh           ;880d cd ed 27  . . ' 
l8810h:
    call v_sub_8962h           ;8810 cd a2 2b  . . + 
    or a                       ;8813 b7  . 
    jr nz,l880dh               ;8814 20 f7    . 
    dec ix                     ;8816 dd 2b  . + 
    jp v_l7fefh                ;8818 c3 2f 22  . / " 
v_sub_7ee7h:
    cp 03bh                    ;881b fe 3b  .                  ;   (flow from: 7e07)  7ee7 cp 3b 
    jr z,l87fdh                ;881d 28 de  ( .                    (flow from: 7ee7)  7ee9 jr z,7ec9 
    cp 020h                    ;881f fe 20  .                      (flow from: 7ee9)  7eeb cp 20 
    call nz,v_sub_856fh        ;8821 c4 af 27  . . '               (flow from: 7eeb)  7eed call nz,856f 
    call v_sub_85b5h           ;8824 cd f5 27  . . '               (flow from: 7eed 8585)  7ef0 call 85b5 
    ld de,v_l8af9h             ;8827 11 39 2d  . 9 -               (flow from: 85ba)  7ef3 ld de,8af9 
    ld c,005h                  ;882a 0e 05  . .                    (flow from: 7ef3)  7ef6 ld c,05 
    call v_sub_856fh           ;882c cd af 27  . . '               (flow from: 7ef6)  7ef8 call 856f 
    call v_sub_85b5h           ;882f cd f5 27  . . '               (flow from: 8585 8590)  7efb call 85b5 
    ld de,varLowercasedOperands                                ;8832 11 25 2d  . % -                                                   (flow from: 85ba)  7efe ld de,8ae5 
    ld c,012h                  ;8835 0e 12  . .                    (flow from: 7efe)  7f01 ld c,12 
    call v_sub_8573h           ;8837 cd b3 27  . . '               (flow from: 7f01)  7f03 call 8573 
    jr nz,l8840h               ;883a 20 04    .                    (flow from: 8585 8590)  7f06 jr nz,7f0c 
    inc hl                     ;883c 23  #                         (flow from: 7f06)  7f08 inc hl 
    ld (v_l8af8h),a            ;883d 32 38 2d  2 8 -               (flow from: 7f08)  7f09 ld (8af8),a 
l8840h:
    ld de,v_l8ad1h             ;8840 11 11 2d  . . -               (flow from: 7f06 7f09)  7f0c ld de,8ad1 
    ld c,012h                  ;8843 0e 12  . .                    (flow from: 7f0c)  7f0f ld c,12 
    call v_sub_8577h           ;8845 cd b7 27  . . '               (flow from: 7f0f)  7f11 call 8577 
    call v_sub_838bh           ;8848 cd cb 25  . . %               (flow from: 8585)  7f14 call 838b 
    ld hl,v_l8af9h             ;884b 21 39 2d  ! 9 -               (flow from: 839f)  7f17 ld hl,8af9 
    ld a,(hl)                  ;884e 7e  ~                         (flow from: 7f17)  7f1a ld a,(hl) 
    or a                       ;884f b7  .                         (flow from: 7f1a)  7f1b or a 
    jr z,l8863h                ;8850 28 11  ( .                    (flow from: 7f1b)  7f1c jr z,7f2f 
    push hl                    ;8852 e5  .                         (flow from: 7f1c)  7f1e push hl 
    call lengthUpToZero        ;8853 cd 5f 27  . _ '               (flow from: 7f1e)  7f1f call 851f 
    ld hl,v_l8545h             ;8856 21 85 27  ! . '               (flow from: 8522)  7f22 ld hl,8545 
    call v_sub_8559h           ;8859 cd 99 27  . . '               (flow from: 7f22)  7f25 call 8559 
    pop hl                     ;885c e1  .                         (flow from: 856e)  7f28 pop hl 
    call compareWithMnemonics                                  ;885d cd 67 27  . g '                                                   (flow from: 7f28)  7f29 call 8527 
    jp c,badMnemonicError      ;8860 da bd 22  . . "               (flow from: 8538)  7f2c jp c,807d 
l8863h:
    ld (varcMnemonicIndex+1),a                                 ;8863 32 d9 21  2 . !                                                   (flow from: 7f1c 7f2c)  7f2f ld (7f99),a 
    cp 03ah                    ;8866 fe 3a  . :                    (flow from: 7f2f)  7f32 cp 3a 
    jr c,mnemonicIsNotDef      ;8868 38 05  8 .                    (flow from: 7f32)  7f34 jr c,7f3b 
    cp 03eh                    ;886a fe 3e  . >                    (flow from: 7f34)  7f36 cp 3e 
    jp c,mnemonicIsDef         ;886c da 41 22  . A "               (flow from: 7f36)  7f38 jp c,8001 
mnemonicIsNotDef:
    ld hl,varLowercasedOperands                                ;886f 21 25 2d  ! % -                                                   (flow from: 7f34 7f38)  7f3b ld hl,8ae5 
    push hl                    ;8872 e5  .                         (flow from: 7f3b)  7f3e push hl 
    call lengthUpToZero        ;8873 cd 5f 27  . _ '               (flow from: 7f3e)  7f3f call 851f 
    pop hl                     ;8876 e1  .                         (flow from: 8522)  7f42 pop hl 
    ld a,b                     ;8877 78  x                         (flow from: 7f42)  7f43 ld a,b 
    dec a                      ;8878 3d  =                         (flow from: 7f43)  7f44 dec a 
    jr nz,l88a3h               ;8879 20 28    (                    (flow from: 7f44)  7f45 jr nz,7f6f 
    ld a,(varcMnemonicIndex+1)                                 ;887b 3a d9 21  : . !                                                   (flow from: 7f45)  7f47 ld a,(7f99) 
    cp 006h                    ;887e fe 06  . .                    (flow from: 7f47)  7f4a cp 06 
    jr nz,mnemonicIsNotIM      ;8880 20 0e    .                    (flow from: 7f4a)  7f4c jr nz,7f5c 
    ld a,(hl)                  ;8882 7e  ~                         (flow from: 7f4c)  7f4e ld a,(hl) 
    sub 02fh                   ;8883 d6 2f  . /                    (flow from: 7f4e)  7f4f sub 2f 
    cp 004h                    ;8885 fe 04  . .                    (flow from: 7f4f)  7f51 cp 04 
l8887h:
    jp nc,badOperandError      ;8887 d2 c1 22  . . "               (flow from: 7f51)  7f53 jp nc,8081 
    or a                       ;888a b7  .                         (flow from: 7f53)  7f56 or a 
    jp z,badOperandError       ;888b ca c1 22  . . "               (flow from: 7f56)  7f57 jp z,8081 
    jr l88a6h                  ;888e 18 16  . .                    (flow from: 7f57)  7f5a jr 7f72 
mnemonicIsNotIM:
; is the mnemonic BIT?
    cp 011h                    ;8890 fe 11  . .                    (flow from: 7f4c)  7f5c cp 11 
    jr z,l889ch                ;8892 28 08  ( .                    (flow from: 7f5c)  7f5e jr z,7f68 
; is the mnemonic RES?
    cp 026h                    ;8894 fe 26  . &                    (flow from: 7f5e)  7f60 cp 26 
    jr z,l889ch                ;8896 28 04  ( .                    (flow from: 7f60)  7f62 jr z,7f68 
; is the mnemonic SET?
    cp 031h                    ;8898 fe 31  . 1                    (flow from: 7f62)  7f64 cp 31 
    jr nz,l88a3h               ;889a 20 07    .                    (flow from: 7f64)  7f66 jr nz,7f6f 
l889ch:
    ld a,(hl)                  ;889c 7e  ~ 
    sub 02fh                   ;889d d6 2f  . / 
    cp 009h                    ;889f fe 09  . . 
    jr l8887h                  ;88a1 18 e4  . . 
l88a3h:
    call v_sub_84e0h           ;88a3 cd 20 27  .   '               (flow from: 7f45 7f66)  7f6f call 84e0 
l88a6h:
    ld (vr_l07f8ah+1),a        ;88a6 32 cb 21  2 . !               (flow from: 7f5a 84e7 84f7 84fd 851c)  7f72 ld (7f8b),a 
    ld hl,v_l8ad1h             ;88a9 21 11 2d  ! . -               (flow from: 7f72)  7f75 ld hl,8ad1 
    call v_sub_84e0h           ;88ac cd 20 27  .   '               (flow from: 7f75)  7f78 call 84e0 
    ld (vr_l07f82h+1),a        ;88af 32 c3 21  2 . !               (flow from: 84e7 84f7 84fd 851c)  7f7b ld (7f83),a 
    xor a                      ;88b2 af  .                         (flow from: 7f7b)  7f7e xor a 
    ld (vr_l07fc0h+1),a        ;88b3 32 01 22  2 . "               (flow from: 7f7e)  7f7f ld (7fc1),a 
vr_l07f82h:
    ld a,000h                  ;88b6 3e 00  > .                    (flow from: 7f7f)  7f82 ld a,00 
    call v_sub_84c3h           ;88b8 cd 03 27  . . '               (flow from: 7f82)  7f84 call 84c3 
    add a,a                    ;88bb 87  .                         (flow from: 84d5)  7f87 add a,a 
    add a,a                    ;88bc 87  .                         (flow from: 7f87)  7f88 add a,a 
    ld e,a                     ;88bd 5f  _                         (flow from: 7f88)  7f89 ld e,a 
vr_l07f8ah:
    ld a,000h                  ;88be 3e 00  > .                    (flow from: 7f89)  7f8a ld a,00 
    call v_sub_84c3h           ;88c0 cd 03 27  . . '               (flow from: 7f8a)  7f8c call 84c3 
    ld d,a                     ;88c3 57  W                         (flow from: 84d5 84df)  7f8f ld d,a 
    ld b,003h                  ;88c4 06 03  . .                    (flow from: 7f8f)  7f90 ld b,03 
l88c6h:
    sla e                      ;88c6 cb 23  . #                    (flow from: 7f90 7f96)  7f92 sla e 
    rl d                       ;88c8 cb 12  . .                    (flow from: 7f92)  7f94 rl d 
    djnz l88c6h                ;88ca 10 fa  . .                    (flow from: 7f94)  7f96 djnz 7f92 
varcMnemonicIndex:
    ld a,000h                  ;88cc 3e 00  > .                    (flow from: 7f96)  7f98 ld a,00 
    rla                        ;88ce 17  .                         (flow from: 7f98)  7f9a rla 
    ld hl,instructionsTable-2                                  ;88cf 21 e1 30  ! . 0                                                   (flow from: 7f9a)  7f9b ld hl,8ea1                                  (flow from: 7f9a)  7f9b ld hl,8ea1 
    ld bc,INSTRUCTIONS_TABLE_SIZE                              ;88d2 01 af 02  . . .                                                   (flow from: 7f9b)  7f9e ld bc,02af                                  (flow from: 7f9b)  7f9e ld bc,02af 
l88d5h:
    inc hl                     ;88d5 23  #                         (flow from: 7f9e 7fac)  7fa1 inc hl 
    ex af,af'                  ;88d6 08  .                         (flow from: 7fa1)  7fa2 ex af,af' 
l88d7h:
    inc hl                     ;88d7 23  #                         (flow from: 7fa2 7fb2 7fb8)  7fa3 inc hl 
    ex af,af'                  ;88d8 08  .                         (flow from: 7fa3)  7fa4 ex af,af' 
; move to instructionRecord[2]
    inc hl                     ;88d9 23  #                         (flow from: 7fa4)  7fa5 inc hl 
    inc hl                     ;88da 23  #                         (flow from: 7fa5)  7fa6 inc hl 
    cpi                        ;88db ed a1  . .                    (flow from: 7fa6)  7fa7 cpi 
    jp po,v_l8098h             ;88dd e2 d8 22  . . "               (flow from: 7fa7)  7fa9 jp po,8098 
    jr nz,l88d5h               ;88e0 20 f3    .                    (flow from: 7fa9)  7fac jr nz,7fa1 
    ex af,af'                  ;88e2 08  .                         (flow from: 7fac)  7fae ex af,af' 
    ld a,(hl)                  ;88e3 7e  ~                         (flow from: 7fae)  7faf ld a,(hl) 
    inc hl                     ;88e4 23  #                         (flow from: 7faf)  7fb0 inc hl 
    cp d                       ;88e5 ba  .                         (flow from: 7fb0)  7fb1 cp d 
    jr nz,l88d7h               ;88e6 20 ef    .                    (flow from: 7fb1)  7fb2 jr nz,7fa3 
    ld a,(hl)                  ;88e8 7e  ~                         (flow from: 7fb2)  7fb4 ld a,(hl) 
    and 0e0h                   ;88e9 e6 e0  . .                    (flow from: 7fb4)  7fb5 and e0 
    cp e                       ;88eb bb  .                         (flow from: 7fb5)  7fb7 cp e 
    jr nz,l88d7h               ;88ec 20 e9    .                    (flow from: 7fb7)  7fb8 jr nz,7fa3 
    dec hl                     ;88ee 2b  +                         (flow from: 7fb8)  7fba dec hl 
    dec hl                     ;88ef 2b  +                         (flow from: 7fba)  7fbb dec hl 
    dec hl                     ;88f0 2b  +                         (flow from: 7fbb)  7fbc dec hl 
    ld d,(hl)                  ;88f1 56  V                         (flow from: 7fbc)  7fbd ld d,(hl) 
    dec hl                     ;88f2 2b  +                         (flow from: 7fbd)  7fbe dec hl 
    ld e,(hl)                  ;88f3 5e  ^                         (flow from: 7fbe)  7fbf ld e,(hl) 
vr_l07fc0h:
    ld a,000h                  ;88f4 3e 00  > .                    (flow from: 7fbf)  7fc0 ld a,00 
    or a                       ;88f6 b7  .                         (flow from: 7fc0)  7fc2 or a 
    jr z,l88fdh                ;88f7 28 04  ( .                    (flow from: 7fc2)  7fc3 jr z,7fc9 
    res 5,d                    ;88f9 cb aa  . .                    (flow from: 7fc3)  7fc5 res 5,d 
    set 4,d                    ;88fb cb e2  . .                    (flow from: 7fc5)  7fc7 set 4,d 
l88fdh:
    call v_sub_82e6h           ;88fd cd 26 25  . & %               (flow from: 7fc3 7fc7)  7fc9 call 82e6 
    ld a,(vr_l07f8ah+1)        ;8900 3a cb 21  : . !               (flow from: 8309 831b)  7fcc ld a,(7f8b) 
    cp 02ch                    ;8903 fe 2c  . ,                    (flow from: 7fcc)  7fcf cp 2c 
    ld de,varLowercasedOperands                                ;8905 11 25 2d  . % -                                                   (flow from: 7fcf)  7fd1 ld de,8ae5 
    call nc,v_sub_83a0h        ;8908 d4 e0 25  . . %               (flow from: 7fd1)  7fd4 call nc,83a0 
    ld a,(vr_l07f82h+1)        ;890b 3a c3 21  : . !               (flow from: 7fd4 83fe)  7fd7 ld a,(7f83) 
    jr c,l891bh                ;890e 38 0b  8 .                    (flow from: 7fd7)  7fda jr c,7fe7 
    cp 02ch                    ;8910 fe 2c  . ,                    (flow from: 7fda)  7fdc cp 2c 
    jr c,l8923h                ;8912 38 0f  8 .                    (flow from: 7fdc)  7fde jr c,7fef 
    ld (ix+000h),01fh          ;8914 dd 36 00 1f  . 6 . . 
    inc ix                     ;8918 dd 23  . # 
    inc b                      ;891a 04  . 
l891bh:
    ld de,v_l8ad1h             ;891b 11 11 2d  . . -               (flow from: 7fda)  7fe7 ld de,8ad1 
    cp 02ch                    ;891e fe 2c  . ,                    (flow from: 7fe7)  7fea cp 2c 
    call nc,v_sub_83a0h        ;8920 d4 e0 25  . . %               (flow from: 7fea)  7fec call nc,83a0 
l8923h:
v_l7fefh:
    ld a,b                     ;8923 78  x                         (flow from: 7fde 7fec 803f 83fe)  7fef ld a,b 
    or a                       ;8924 b7  .                         (flow from: 7fef)  7ff0 or a 
    jr z,l892fh                ;8925 28 08  ( .                    (flow from: 7ff0)  7ff1 jr z,7ffb 
    set 7,b                    ;8927 cb f8  . .                    (flow from: 7ff1)  7ff3 set 7,b 
    set 6,b                    ;8929 cb f0  . .                    (flow from: 7ff3)  7ff5 set 6,b 
    ld (ix+000h),b             ;892b dd 70 00  . p .               (flow from: 7ff5)  7ff7 ld (ix+00),b 
    inc a                      ;892e 3c  <                         (flow from: 7ff7)  7ffa inc a 
l892fh:
    add a,002h                 ;892f c6 02  . .                    (flow from: 7ff1 7ffa)  7ffb add a,02 
    ld (v_l8b21h),a            ;8931 32 61 2d  2 a -               (flow from: 7ffb)  7ffd ld (8b21),a 
    ret                        ;8934 c9  .                         (flow from: 7ffd)  8000 ret 
mnemonicIsDef:
    push af                    ;8935 f5  .                         (flow from: 7f38)  8001 push af 
    sub 034h                   ;8936 d6 34  . 4                    (flow from: 8001)  8002 sub 34 
    ld e,a                     ;8938 5f  _                         (flow from: 8002)  8004 ld e,a 
    ld d,037h                  ;8939 16 37  . 7                    (flow from: 8004)  8005 ld d,37 
    call v_sub_82e6h           ;893b cd 26 25  . & %               (flow from: 8005)  8007 call 82e6 
    push bc                    ;893e c5  .                         (flow from: 8309 831b)  800a push bc 
    ld hl,v_l8ae4h             ;893f 21 24 2d  ! $ -               (flow from: 800a)  800b ld hl,8ae4 
    xor a                      ;8942 af  .                         (flow from: 800b)  800e xor a 
    ld c,a                     ;8943 4f  O                         (flow from: 800e)  800f ld c,a 
l8944h:
    inc hl                     ;8944 23  #                         (flow from: 800f 8013)  8010 inc hl 
    inc c                      ;8945 0c  .                         (flow from: 8010)  8011 inc c 
    cp (hl)                    ;8946 be  .                         (flow from: 8011)  8012 cp (hl) 
    jr nz,l8944h               ;8947 20 fb    .                    (flow from: 8012)  8013 jr nz,8010 
    ld de,v_l8ad1h             ;8949 11 11 2d  . . -               (flow from: 8013)  8015 ld de,8ad1 
    ld a,(de)                  ;894c 1a  .                         (flow from: 8015)  8018 ld a,(de) 
    or a                       ;894d b7  .                         (flow from: 8018)  8019 or a 
    jr z,l8954h                ;894e 28 04  ( .                    (flow from: 8019)  801a jr z,8020 
    ld (hl),02ch               ;8950 36 2c  6 ,                    (flow from: 801a)  801c ld (hl),2c 
    inc hl                     ;8952 23  #                         (flow from: 801c)  801e inc hl 
    xor a                      ;8953 af  .                         (flow from: 801e)  801f xor a 
l8954h:
    ex de,hl                   ;8954 eb  .                         (flow from: 801a 801f)  8020 ex de,hl 
l8955h:
    cp (hl)                    ;8955 be  .                         (flow from: 8020 8028)  8021 cp (hl) 
    jr z,l895eh                ;8956 28 06  ( .                    (flow from: 8021)  8022 jr z,802a 
    ldi                        ;8958 ed a0  . .                    (flow from: 8022)  8024 ldi 
    inc c                      ;895a 0c  .                         (flow from: 8024)  8026 inc c 
    inc c                      ;895b 0c  .                         (flow from: 8026)  8027 inc c 
    jr l8955h                  ;895c 18 f7  . .                    (flow from: 8027)  8028 jr 8021 
l895eh:
    ld a,012h                  ;895e 3e 12  > .                    (flow from: 8022)  802a ld a,12 
    cp c                       ;8960 b9  .                         (flow from: 802a)  802c cp c 
    jr c,syntaxError22         ;8961 38 5a  8 Z                    (flow from: 802c)  802d jr c,8089 
    pop bc                     ;8963 c1  .                         (flow from: 802d)  802f pop bc 
    pop af                     ;8964 f1  .                         (flow from: 802f)  8030 pop af 
    cp 03bh                    ;8965 fe 3b  .                  ;   (flow from: 8030)  8031 cp 3b 
    jr z,l897eh                ;8967 28 15  ( .                    (flow from: 8031)  8033 jr z,804a 
    ld de,varLowercasedOperands                                ;8969 11 25 2d  . % -                                                   (flow from: 8033)  8035 ld de,8ae5 
l896ch:
    ld a,02ch                  ;896c 3e 2c  > ,                    (flow from: 8035 8048)  8038 ld a,2c 
    call v_sub_83a0h           ;896e cd e0 25  . . %               (flow from: 8038 8394)  803a call 83a0 
    ld a,(de)                  ;8971 1a  .                         (flow from: 83fe)  803d ld a,(de) 
    or a                       ;8972 b7  .                         (flow from: 803d)  803e or a 
l8973h:
    jr z,l8923h                ;8973 28 ae  ( .                    (flow from: 803e)  803f jr z,7fef 
    ld (ix+000h),02ch          ;8975 dd 36 00 2c  . 6 . ,          (flow from: 803f)  8041 ld (ix+00),2c 
    inc ix                     ;8979 dd 23  . #                    (flow from: 8041)  8045 inc ix 
    inc b                      ;897b 04  .                         (flow from: 8045)  8047 inc b 
    jr l896ch                  ;897c 18 ee  . .                    (flow from: 8047)  8048 jr 8038 
l897eh:
    ld hl,varLowercasedOperands                                ;897e 21 25 2d  ! % - 
    call v_sub_808dh           ;8981 cd cd 22  . . " 
    call v_sub_8962h           ;8984 cd a2 2b  . . + 
    inc hl                     ;8987 23  # 
    ld a,(hl)                  ;8988 7e  ~ 
    call v_sub_8962h           ;8989 cd a2 2b  . . + 
    inc hl                     ;898c 23  # 
    ld a,(hl)                  ;898d 7e  ~ 
l898eh:
    call v_sub_8962h           ;898e cd a2 2b  . . + 
    inc hl                     ;8991 23  # 
    ld a,(hl)                  ;8992 7e  ~ 
    or a                       ;8993 b7  . 
    jr nz,l898eh               ;8994 20 f8    . 
    dec hl                     ;8996 2b  + 
    call v_sub_808dh           ;8997 cd cd 22  . . " 
    jr l8973h                  ;899a 18 d7  . . 
v_sub_8068h:
    push hl                    ;899c e5  .                         (flow from: 77de 881f 8a70)  8068 push hl 
    push de                    ;899d d5  .                         (flow from: 8068)  8069 push de 
    ld hl,(vr_l08819h+1)       ;899e 2a 5a 2a  * Z *               (flow from: 8069)  806a ld hl,(881a) 
    add hl,bc                  ;89a1 09  .                         (flow from: 806a)  806d add hl,bc 
    jr c,l89adh                ;89a2 38 09  8 .                    (flow from: 806d)  806e jr c,8079 
    ld de,(vr_l07945h+1)       ;89a4 ed 5b 86 1b  . [ . .          (flow from: 806e)  8070 ld de,(7946) 
    sbc hl,de                  ;89a8 ed 52  . R                    (flow from: 8070)  8074 sbc hl,de 
    pop de                     ;89aa d1  .                         (flow from: 8074)  8076 pop de 
    pop hl                     ;89ab e1  .                         (flow from: 8076)  8077 pop hl 
    ret c                      ;89ac d8  .                         (flow from: 8077)  8078 ret c 
l89adh:
    ld a,007h                  ;89ad 3e 07  > . 
    jr l89ceh                  ;89af 18 1d  . . 
badMnemonicError:
    ld a,001h                  ;89b1 3e 01  > . 
    jr l89ceh                  ;89b3 18 19  . . 
badOperandError:
    ld a,002h                  ;89b5 3e 02  > . 
    jr l89ceh                  ;89b7 18 15  . . 
bigNumberError:
    ld a,003h                  ;89b9 3e 03  > . 
    jr l89ceh                  ;89bb 18 11  . . 
syntaxError22:
syntaxError:
    ld a,004h                  ;89bd 3e 04  > . 
    jr l89ceh                  ;89bf 18 0d  . . 
v_sub_808dh:
    ld a,(hl)                  ;89c1 7e  ~ 
    cp 027h                    ;89c2 fe 27  . ' 
    ret z                      ;89c4 c8  . 
    cp 022h                    ;89c5 fe 22  . " 
    ret z                      ;89c7 c8  . 
badStringError:
    ld a,005h                  ;89c8 3e 05  > . 
    jr l89ceh                  ;89ca 18 02  . . 
v_l8098h:
    ld a,006h                  ;89cc 3e 06  > . 
l89ceh:
v_l809ah:
    ex af,af'                  ;89ce 08  . 
    call v_sub_8713h           ;89cf cd 53 29  . S ) 
    ex af,af'                  ;89d2 08  . 
l089d3h:
    call v_l89f4h              ;89d3 cd 34 2c  . 4 , 
v_l80a2h:
vr_l080a2h:
    call v_l82dbh              ;89d6 cd 1b 25  . . % 
    ld hl,(v_sub_826ch+1)      ;89d9 2a ad 24  * . $ 
    call v_sub_8a2fh           ;89dc cd 6f 2c  . o , 
    call z,v_sub_8235h         ;89df cc 75 24  . u $ 
    ld (v_sub_826ch+1),hl      ;89e2 22 ad 24  " . $ 
    jp v_l7ceeh                ;89e5 c3 2e 1f  . . . 
v_sub_80b4h:
    ld hl,04000h               ;89e8 21 00 40  ! . @               (flow from: 7bec 89f4)  80b4 ld hl,4000 
v_sub_80b7h:
    call v_sub_85f5h           ;89eb cd 35 28  . 5 (               (flow from: 80b4)  80b7 call 85f5 
    cp 009h                    ;89ee fe 09  . .                    (flow from: 8607)  80ba cp 09 
    jr nz,l8a00h               ;89f0 20 0e    .                    (flow from: 80ba)  80bc jr nz,80cc 
    push af                    ;89f2 f5  . 
vr_l080bfh:
    ld hl,v_l80e1h             ;89f3 21 21 23  ! ! # 
    call v_sub_80d7h           ;89f6 cd 17 23  . . # 
    ld hl,v_l80e1h             ;89f9 21 21 23  ! ! # 
    ld (vr_l080bfh+1),hl       ;89fc 22 00 23  " . # 
    pop af                     ;89ff f1  . 
l8a00h:
        ld hl,l094d5h                                          ;8a00 21 e1 2d  ! . -                                                   (flow from: 80bc)  80cc ld hl,8ba1                                  (flow from: 80bc)  80cc ld hl,8ba1 
l8a03h:
    bit 7,(hl)                 ;8a03 cb 7e  . ~                    (flow from: 80cc 80d2 80d5)  80cf bit 7,(hl) 
    inc hl                     ;8a05 23  #                         (flow from: 80cf)  80d1 inc hl 
    jr z,l8a03h                ;8a06 28 fb  ( .                    (flow from: 80d1)  80d2 jr z,80cf 
    dec a                      ;8a08 3d  =                         (flow from: 80d2)  80d4 dec a 
    jr nz,l8a03h               ;8a09 20 f8    .                    (flow from: 80d4)  80d5 jr nz,80cf 
l8a0bh:
v_sub_80d7h:
    ld a,(hl)                  ;8a0b 7e  ~                         (flow from: 80d5 80de)  80d7 ld a,(hl) 
    call v_sub_8767h           ;8a0c cd a7 29  . . )               (flow from: 80d7)  80d8 call 8767 
    bit 7,(hl)                 ;8a0f cb 7e  . ~                    (flow from: 877e)  80db bit 7,(hl) 
    inc hl                     ;8a11 23  #                         (flow from: 80db)  80dd inc hl 
    jr z,l8a0bh                ;8a12 28 f7  ( .                    (flow from: 80dd)  80de jr z,80d7 
    ret                        ;8a14 c9  .                         (flow from: 80de)  80e0 ret 

; BLOCK 'data_8a15' (start 0x8a15 end 0x8a1b)
v_l80e1h:
    defb "Symbo",0xec          ;"l"+0x80                       ;8a15
v_sub_080e7h:
vr_l080e7h:
        ld hl,l0a55ch                                          ;8a1b 21 68 3e  ! h >                                                   (flow from: 80f8)  80e7 ld hl,9c28                                  (flow from: 80f8)  80e7 ld hl,9c28 
vr_l080eah:
        ld de,l0a55ch                                          ;8a1e 11 68 3e  . h >                                                   (flow from: 80e7)  80ea ld de,9c28                                  (flow from: 80e7)  80ea ld de,9c28 
    push hl                    ;8a21 e5  .                         (flow from: 80ea)  80ed push hl 
    xor a                      ;8a22 af  .                         (flow from: 80ed)  80ee xor a 
    sbc hl,de                  ;8a23 ed 52  . R                    (flow from: 80ee)  80ef sbc hl,de 
    pop hl                     ;8a25 e1  .                         (flow from: 80ef)  80f1 pop hl 
    ret c                      ;8a26 d8  .                         (flow from: 80f1)  80f2 ret c 
    ex de,hl                   ;8a27 eb  .                         (flow from: 80f2)  80f3 ex de,hl 
    ret                        ;8a28 c9  .                         (flow from: 80f3)  80f4 ret 
v_sub_80f5h:
    exx                        ;8a29 d9  .                         (flow from: 8296)  80f5 exx 
    push ix                    ;8a2a dd e5  . .                    (flow from: 80f5)  80f6 push ix 
    call v_sub_080e7h          ;8a2c cd 27 23  . ' #               (flow from: 80f6)  80f8 call 80e7 
    ld b,h                     ;8a2f 44  D                         (flow from: 80f4)  80fb ld b,h 
    ld c,l                     ;8a30 4d  M                         (flow from: 80fb)  80fc ld c,l 
    pop hl                     ;8a31 e1  .                         (flow from: 80fc)  80fd pop hl 
    push hl                    ;8a32 e5  .                         (flow from: 80fd)  80fe push hl 
    xor a                      ;8a33 af  .                         (flow from: 80fe)  80ff xor a 
    sbc hl,bc                  ;8a34 ed 42  . B                    (flow from: 80ff)  8100 sbc hl,bc 
    pop hl                     ;8a36 e1  .                         (flow from: 8100)  8102 pop hl 
    jr c,l8a3ch                ;8a37 38 03  8 .                    (flow from: 8102)  8103 jr c,8108 
    ex de,hl                   ;8a39 eb  .                         (flow from: 8103)  8105 ex de,hl 
    sbc hl,de                  ;8a3a ed 52  . R                    (flow from: 8105)  8106 sbc hl,de 
l8a3ch:
    exx                        ;8a3c d9  .                         (flow from: 8103 8106)  8108 exx 
    ret                        ;8a3d c9  .                         (flow from: 8108)  8109 ret 
v_sub_810ah:
    inc ix                     ;8a3e dd 23  . # 
v_sub_810ch:
    ld d,(ix+002h)             ;8a40 dd 56 02  . V .               (flow from: 8113)  810c ld d,(ix+02) 
    ld e,(ix+003h)             ;8a43 dd 5e 03  . ^ .               (flow from: 810c)  810f ld e,(ix+03) 
    ret                        ;8a46 c9  .                         (flow from: 810f)  8112 ret 
v_sub_8113h:
    call v_sub_810ch           ;8a47 cd 4c 23  . L #               (flow from: 8167)  8113 call 810c 
v_sub_8116h:
vr_l08116h:
    ld hl,(vr_l087d6h+1)       ;8a4a 2a 17 2a  * . *               (flow from: 8112 821f)  8116 ld hl,(87d7) 
    push hl                    ;8a4d e5  .                         (flow from: 8116)  8119 push hl 
    res 7,d                    ;8a4e cb ba  . .                    (flow from: 8119)  811a res 7,d 
    add hl,de                  ;8a50 19  .                         (flow from: 811a)  811c add hl,de 
    add hl,de                  ;8a51 19  .                         (flow from: 811c)  811d add hl,de 
    ld e,(hl)                  ;8a52 5e  ^                         (flow from: 811d)  811e ld e,(hl) 
    inc hl                     ;8a53 23  #                         (flow from: 811e)  811f inc hl 
    ld a,(hl)                  ;8a54 7e  ~                         (flow from: 811f)  8120 ld a,(hl) 
    and 03fh                   ;8a55 e6 3f  . ?                    (flow from: 8120)  8121 and 3f 
    ld d,a                     ;8a57 57  W                         (flow from: 8121)  8123 ld d,a 
    ex (sp),hl                 ;8a58 e3  .                         (flow from: 8123)  8124 ex (sp),hl 
    push hl                    ;8a59 e5  .                         (flow from: 8124)  8125 push hl 
    ex de,hl                   ;8a5a eb  .                         (flow from: 8125)  8126 ex de,hl 
    ex (sp),hl                 ;8a5b e3  .                         (flow from: 8126)  8127 ex (sp),hl 
    ld e,(hl)                  ;8a5c 5e  ^                         (flow from: 8127)  8128 ld e,(hl) 
    inc hl                     ;8a5d 23  #                         (flow from: 8128)  8129 inc hl 
    ld d,(hl)                  ;8a5e 56  V                         (flow from: 8129)  812a ld d,(hl) 
    inc hl                     ;8a5f 23  #                         (flow from: 812a)  812b inc hl 
    ex de,hl                   ;8a60 eb  .                         (flow from: 812b)  812c ex de,hl 
    inc hl                     ;8a61 23  #                         (flow from: 812c)  812d inc hl 
    add hl,hl                  ;8a62 29  )                         (flow from: 812d)  812e add hl,hl 
    add hl,de                  ;8a63 19  .                         (flow from: 812e)  812f add hl,de 
    pop de                     ;8a64 d1  .                         (flow from: 812f)  8130 pop de 
    add hl,de                  ;8a65 19  .                         (flow from: 8130)  8131 add hl,de 
    ex de,hl                   ;8a66 eb  .                         (flow from: 8131)  8132 ex de,hl 
    pop hl                     ;8a67 e1  .                         (flow from: 8132)  8133 pop hl 
    ret                        ;8a68 c9  .                         (flow from: 8133)  8134 ret 
v_sub_8135h:
    ld hl,v_l8aa5h             ;8a69 21 e5 2c  ! . ,               (flow from: 773d 8291)  8135 ld hl,8aa5 
v_sub_8138h:
    push hl                    ;8a6c e5  .                         (flow from: 7d20 8135)  8138 push hl 
    ld bc,02000h               ;8a6d 01 00 20  . .                 (flow from: 8138)  8139 ld bc,2000 
    call atHLrepeatBTimesC     ;8a70 cd 21 25  . ! %               (flow from: 8139)  813c call 82e1 
    pop hl                     ;8a73 e1  .                         (flow from: 82e5)  813f pop hl 
    ld a,(ix+000h)             ;8a74 dd 7e 00  . ~ .               (flow from: 813f)  8140 ld a,(ix+00) 
    dec a                      ;8a77 3d  =                         (flow from: 8140)  8143 dec a 
    jr nz,l8a8fh               ;8a78 20 15    .                    (flow from: 8143)  8144 jr nz,815b 
    ld a,(ix+001h)             ;8a7a dd 7e 01  . ~ . 
    cp 037h                    ;8a7d fe 37  . 7 
    jr nz,l8a8fh               ;8a7f 20 0e    . 
l8a81h:
    ld a,(ix+002h)             ;8a81 dd 7e 02  . ~ . 
    cp 0c0h                    ;8a84 fe c0  . . 
    ld (hl),001h               ;8a86 36 01  6 . 
    ret nc                     ;8a88 d0  . 
    inc ix                     ;8a89 dd 23  . # 
    ld (hl),a                  ;8a8b 77  w 
    inc hl                     ;8a8c 23  # 
    jr l8a81h                  ;8a8d 18 f2  . . 
l8a8fh:
    ld b,009h                  ;8a8f 06 09  . .                    (flow from: 8144)  815b ld b,09 
    bit 3,(ix+001h)            ;8a91 dd cb 01 5e  . . . ^          (flow from: 815b)  815d bit 3,(ix+01) 
    call z,v_sub_82d7h         ;8a95 cc 17 25  . . %               (flow from: 815d)  8161 call z,82d7 
    jr z,l8aa4h                ;8a98 28 0a  ( .                    (flow from: 8161 82e5)  8164 jr z,8170 
    push hl                    ;8a9a e5  .                         (flow from: 8164)  8166 push hl 
    call v_sub_8113h           ;8a9b cd 53 23  . S #               (flow from: 8166)  8167 call 8113 
    pop hl                     ;8a9e e1  .                         (flow from: 8134)  816a pop hl 
    ld b,009h                  ;8a9f 06 09  . .                    (flow from: 816a)  816b ld b,09 
    call v_sub_82d4h           ;8aa1 cd 14 25  . . %               (flow from: 816b)  816d call 82d4 
l8aa4h:
    push hl                    ;8aa4 e5  .                         (flow from: 8164 82e5)  8170 push hl 
    ld b,(ix+000h)             ;8aa5 dd 46 00  . F .               (flow from: 8170)  8171 ld b,(ix+00) 
    ld a,(ix+001h)             ;8aa8 dd 7e 01  . ~ .               (flow from: 8171)  8174 ld a,(ix+01) 
    and 0f0h                   ;8aab e6 f0  . .                    (flow from: 8174)  8177 and f0 
    ld c,a                     ;8aad 4f  O                         (flow from: 8177)  8179 ld c,a 
    call v_sub_831ch           ;8aae cd 5c 25  . \ %               (flow from: 8179)  817a call 831c 
    pop hl                     ;8ab1 e1  .                         (flow from: 8376 838a)  817d pop hl 
    jr z,l8abah                ;8ab2 28 06  ( .                    (flow from: 817d)  817e jr z,8186 
    ld a,010h                  ;8ab4 3e 10  > . 
    ld (vr_l07cfeh+1),a        ;8ab6 32 3f 1f  2 ? . 
    ret                        ;8ab9 c9  . 
l8abah:
    ld (hl),001h               ;8aba 36 01  6 .                    (flow from: 817e)  8186 ld (hl),01 
    or a                       ;8abc b7  .                         (flow from: 8186)  8188 or a 
    ret z                      ;8abd c8  .                         (flow from: 8188)  8189 ret z 
    cp 03ah                    ;8abe fe 3a  . :                    (flow from: 8189)  818a cp 3a 
    jr c,l8ac8h                ;8ac0 38 06  8 .                    (flow from: 818a)  818c jr c,8194 
    cp 03eh                    ;8ac2 fe 3e  . >                    (flow from: 818c)  818e cp 3e 
    jr nc,l8ac8h               ;8ac4 30 02  0 .                    (flow from: 818e)  8190 jr nc,8194 
    ld d,02ch                  ;8ac6 16 2c  . ,                    (flow from: 8190)  8192 ld d,2c 
l8ac8h:
    push de                    ;8ac8 d5  .                         (flow from: 818c 8190 8192)  8194 push de 
    ld de,v_l8c76h             ;8ac9 11 b6 2e  . . .               (flow from: 8194)  8195 ld de,8c76 
    call v_sub_82c9h           ;8acc cd 09 25  . . %               (flow from: 8195)  8198 call 82c9 
    ld b,005h                  ;8acf 06 05  . .                    (flow from: 82d3)  819b ld b,05 
    call v_sub_82d4h           ;8ad1 cd 14 25  . . %               (flow from: 819b)  819d call 82d4 
    pop de                     ;8ad4 d1  .                         (flow from: 82e5)  81a0 pop de 
    ld (hl),001h               ;8ad5 36 01  6 .                    (flow from: 81a0)  81a1 ld (hl),01 
    inc hl                     ;8ad7 23  #                         (flow from: 81a1)  81a3 inc hl 
    bit 3,(ix+001h)            ;8ad8 dd cb 01 5e  . . . ^          (flow from: 81a3)  81a4 bit 3,(ix+01) 
    jr z,l8ae2h                ;8adc 28 04  ( .                    (flow from: 81a4)  81a8 jr z,81ae 
    inc ix                     ;8ade dd 23  . #                    (flow from: 81a8)  81aa inc ix 
    inc ix                     ;8ae0 dd 23  . #                    (flow from: 81aa)  81ac inc ix 
l8ae2h:
    push de                    ;8ae2 d5  .                         (flow from: 81a8 81ac)  81ae push de 
    ld a,d                     ;8ae3 7a  z                         (flow from: 81ae)  81af ld a,d 
    call v_sub_81bah           ;8ae4 cd fa 23  . . #               (flow from: 81af)  81b0 call 81ba 
    pop de                     ;8ae7 d1  .                         (flow from: 81bb 81dd 822d 8231)  81b3 pop de 
    ld a,e                     ;8ae8 7b  {                         (flow from: 81b3)  81b4 ld a,e 
    or a                       ;8ae9 b7  .                         (flow from: 81b4)  81b5 or a 
    ret z                      ;8aea c8  .                         (flow from: 81b5)  81b6 ret z 
    ld (hl),02ch               ;8aeb 36 2c  6 ,                    (flow from: 81b6)  81b7 ld (hl),2c 
    inc hl                     ;8aed 23  #                         (flow from: 81b7)  81b9 inc hl 
v_sub_81bah:
    or a                       ;8aee b7  .                         (flow from: 81b0 81b9)  81ba or a 
    ret z                      ;8aef c8  .                         (flow from: 81ba)  81bb ret z 
    cp 02ch                    ;8af0 fe 2c  . ,                    (flow from: 81bb)  81bc cp 2c 
    jr nc,l8b12h               ;8af2 30 1e  0 .                    (flow from: 81bc)  81be jr nc,81de 
    ld de,v_l8db4h             ;8af4 11 f4 2f  . . /               (flow from: 81be)  81c0 ld de,8db4 
    call v_sub_82c9h           ;8af7 cd 09 25  . . %               (flow from: 81c0)  81c3 call 82c9 
v_sub_81c6h:
    ld b,009h                  ;8afa 06 09  . .                    (flow from: 8223 82d3)  81c6 ld b,09 
l8afch:
v_l81c8h:
    ld a,(de)                  ;8afc 1a  .                         (flow from: 81c6 81db 82d4)  81c8 ld a,(de) 
    and 07fh                   ;8afd e6 7f  .                     (flow from: 81c8)  81c9 and 7f 
    ld (hl),a                  ;8aff 77  w                         (flow from: 81c9)  81cb ld (hl),a 
    dec b                      ;8b00 05  .                         (flow from: 81cb)  81cc dec b 
    jr nz,l8b0ah               ;8b01 20 07    .                    (flow from: 81cc)  81cd jr nz,81d6 
    ld a,010h                  ;8b03 3e 10  > . 
    ld (vr_l07cfeh+1),a        ;8b05 32 3f 1f  2 ? . 
    pop af                     ;8b08 f1  . 
    ret                        ;8b09 c9  . 
l8b0ah:
    ld a,(de)                  ;8b0a 1a  .                         (flow from: 81cd)  81d6 ld a,(de) 
    and 080h                   ;8b0b e6 80  . .                    (flow from: 81d6)  81d7 and 80 
    inc hl                     ;8b0d 23  #                         (flow from: 81d7)  81d9 inc hl 
    inc de                     ;8b0e 13  .                         (flow from: 81d9)  81da inc de 
    jr z,l8afch                ;8b0f 28 eb  ( .                    (flow from: 81da)  81db jr z,81c8 
    ret                        ;8b11 c9  .                         (flow from: 81db)  81dd ret 
l8b12h:
    push af                    ;8b12 f5  .                         (flow from: 81be)  81de push af 
    cp 02dh                    ;8b13 fe 2d  . -                    (flow from: 81de)  81df cp 2d 
    jr c,l8b35h                ;8b15 38 1e  8 .                    (flow from: 81df)  81e1 jr c,8201 
    ld (hl),028h               ;8b17 36 28  6 (                    (flow from: 81e1)  81e3 ld (hl),28 
    inc hl                     ;8b19 23  #                         (flow from: 81e3)  81e5 inc hl 
    cp 02eh                    ;8b1a fe 2e  . .                    (flow from: 81e5)  81e6 cp 2e 
    jr c,l8b35h                ;8b1c 38 17  8 .                    (flow from: 81e6)  81e8 jr c,8201 
    ld (hl),069h               ;8b1e 36 69  6 i 
    inc hl                     ;8b20 23  # 
    ld b,078h                  ;8b21 06 78  . x 
    cp 02fh                    ;8b23 fe 2f  . / 
    jr c,l8b29h                ;8b25 38 02  8 . 
    ld b,079h                  ;8b27 06 79  . y 
l8b29h:
    ld (hl),b                  ;8b29 70  p 
    inc hl                     ;8b2a 23  # 
    ld a,(ix+002h)             ;8b2b dd 7e 02  . ~ . 
    cp 02dh                    ;8b2e fe 2d  . - 
    jr z,l8b35h                ;8b30 28 03  ( . 
    ld (hl),02bh               ;8b32 36 2b  6 + 
    inc hl                     ;8b34 23  # 
l8b35h:
    ld a,(ix+002h)             ;8b35 dd 7e 02  . ~ .               (flow from: 81e1 81e8 8214 8226)  8201 ld a,(ix+02) 
    cp 01fh                    ;8b38 fe 1f  . .                    (flow from: 8201)  8204 cp 1f 
    jr z,l8b5ch                ;8b3a 28 20  (                      (flow from: 8204)  8206 jr z,8228 
    cp 0c0h                    ;8b3c fe c0  . .                    (flow from: 8206)  8208 cp c0 
    jr nc,l8b5ch               ;8b3e 30 1c  0 .                    (flow from: 8208)  820a jr nc,8228 
    cp 080h                    ;8b40 fe 80  . .                    (flow from: 820a)  820c cp 80 
    jr nc,l8b4ah               ;8b42 30 06  0 .                    (flow from: 820c)  820e jr nc,8216 
    ld (hl),a                  ;8b44 77  w                         (flow from: 820e)  8210 ld (hl),a 
    inc hl                     ;8b45 23  #                         (flow from: 8210)  8211 inc hl 
    inc ix                     ;8b46 dd 23  . #                    (flow from: 8211)  8212 inc ix 
    jr l8b35h                  ;8b48 18 eb  . .                    (flow from: 8212)  8214 jr 8201 
l8b4ah:
    ld d,a                     ;8b4a 57  W                         (flow from: 820e)  8216 ld d,a 
    ld e,(ix+003h)             ;8b4b dd 5e 03  . ^ .               (flow from: 8216)  8217 ld e,(ix+03) 
    inc ix                     ;8b4e dd 23  . #                    (flow from: 8217)  821a inc ix 
    inc ix                     ;8b50 dd 23  . #                    (flow from: 821a)  821c inc ix 
    push hl                    ;8b52 e5  .                         (flow from: 821c)  821e push hl 
    call v_sub_8116h           ;8b53 cd 56 23  . V #               (flow from: 821e)  821f call 8116 
    pop hl                     ;8b56 e1  .                         (flow from: 8134)  8222 pop hl 
    call v_sub_81c6h           ;8b57 cd 06 24  . . $               (flow from: 8222)  8223 call 81c6 
    jr l8b35h                  ;8b5a 18 d9  . .                    (flow from: 81dd)  8226 jr 8201 
l8b5ch:
    pop af                     ;8b5c f1  .                         (flow from: 820a)  8228 pop af 
    inc ix                     ;8b5d dd 23  . #                    (flow from: 8228)  8229 inc ix 
    cp 02dh                    ;8b5f fe 2d  . -                    (flow from: 8229)  822b cp 2d 
    ret c                      ;8b61 d8  .                         (flow from: 822b)  822d ret c 
    ld (hl),029h               ;8b62 36 29  6 )                    (flow from: 822d)  822e ld (hl),29 
    inc hl                     ;8b64 23  #                         (flow from: 822e)  8230 inc hl 
    ret                        ;8b65 c9  .                         (flow from: 8230)  8231 ret 
v_sub_8232h:
    ld hl,(v_sub_826ch+1)      ;8b66 2a ad 24  * . $               (flow from: 7c6c 7e23)  8232 ld hl,(826d) 
v_sub_8235h:
    dec hl                     ;8b69 2b  +                         (flow from: 8232 8271)  8235 dec hl 
    ld a,(hl)                  ;8b6a 7e  ~                         (flow from: 8235)  8236 ld a,(hl) 
    cp 0c0h                    ;8b6b fe c0  . .                    (flow from: 8236)  8237 cp c0 
    jr c,l8b77h                ;8b6d 38 08  8 .                    (flow from: 8237)  8239 jr c,8243 
    and 03fh                   ;8b6f e6 3f  . ?                    (flow from: 8239)  823b and 3f 
    ld e,a                     ;8b71 5f  _                         (flow from: 823b)  823d ld e,a 
    ld d,000h                  ;8b72 16 00  . .                    (flow from: 823d)  823e ld d,00 
    sbc hl,de                  ;8b74 ed 52  . R                    (flow from: 823e)  8240 sbc hl,de 
    dec hl                     ;8b76 2b  +                         (flow from: 8240)  8242 dec hl 
l8b77h:
    dec hl                     ;8b77 2b  +                         (flow from: 8239 8242)  8243 dec hl 
    ret                        ;8b78 c9  .                         (flow from: 8243)  8244 ret 
v_sub_8245h:
    ld hl,(v_sub_826ch+1)      ;8b79 2a ad 24  * . $               (flow from: 7c75 7e0a)  8245 ld hl,(826d) 
v_sub_8248h:
    inc hl                     ;8b7c 23  #                         (flow from: 7726 8245 8284 898f)  8248 inc hl 
    ld a,(hl)                  ;8b7d 7e  ~                         (flow from: 8248)  8249 ld a,(hl) 
    inc hl                     ;8b7e 23  #                         (flow from: 8249)  824a inc hl 
    bit 3,a                    ;8b7f cb 5f  . _                    (flow from: 824a)  824b bit 3,a 
    jr z,l8b87h                ;8b81 28 04  ( .                    (flow from: 824b)  824d jr z,8253 
    inc hl                     ;8b83 23  #                         (flow from: 824d)  824f inc hl 
    inc hl                     ;8b84 23  #                         (flow from: 824f)  8250 inc hl 
    jr l8b8ah                  ;8b85 18 03  . .                    (flow from: 8250)  8251 jr 8256 
l8b87h:
    and 007h                   ;8b87 e6 07  . .                    (flow from: 824d)  8253 and 07 
    ret z                      ;8b89 c8  .                         (flow from: 8253)  8255 ret z 
l8b8ah:
    ld a,(hl)                  ;8b8a 7e  ~                         (flow from: 8251 8255 825d 8260)  8256 ld a,(hl) 
    inc hl                     ;8b8b 23  #                         (flow from: 8256)  8257 inc hl 
    cp 0c0h                    ;8b8c fe c0  . .                    (flow from: 8257)  8258 cp c0 
    ret nc                     ;8b8e d0  .                         (flow from: 8258)  825a ret nc 
    cp 080h                    ;8b8f fe 80  . .                    (flow from: 825a)  825b cp 80 
l8b91h:
    jr c,l8b8ah                ;8b91 38 f7  8 .                    (flow from: 825b)  825d jr c,8256 
    inc hl                     ;8b93 23  #                         (flow from: 825d)  825f inc hl 
    jr l8b8ah                  ;8b94 18 f4  . .                    (flow from: 825f)  8260 jr 8256 
v_sub_8262h:
    xor a                      ;8b96 af  .                         (flow from: 7760)  8262 xor a 
    in a,(0feh)                ;8b97 db fe  . .                    (flow from: 8262)  8263 in a,(fe) 
    cpl                        ;8b99 2f  /                         (flow from: 8263)  8265 cpl 
    and 01fh                   ;8b9a e6 1f  . .                    (flow from: 8265)  8266 and 1f 
    ret z                      ;8b9c c8  .                         (flow from: 8266)  8268 ret z 
    call v_sub_7bbch           ;8b9d cd fc 1d  . . . 
v_sub_826ch:
        ld hl,l0a55ch                                          ;8ba0 21 68 3e  ! h >                                                   (flow from: 7cf1)  826c ld hl,b24c                                  (flow from: 7cf1)  826c ld hl,b24c 
    ld b,00dh                  ;8ba3 06 0d  . .                    (flow from: 826c)  826f ld b,0d 
l8ba5h:
    call v_sub_8235h           ;8ba5 cd 75 24  . u $               (flow from: 826f 8274)  8271 call 8235 
    djnz l8ba5h                ;8ba8 10 fb  . .                    (flow from: 8244)  8274 djnz 8271 
    ld a,010h                  ;8baa 3e 10  > .                    (flow from: 8274)  8276 ld a,10 
l8bach:
    push af                    ;8bac f5  .                         (flow from: 8276 828c)  8278 push af 
    push hl                    ;8bad e5  .                         (flow from: 8278)  8279 push hl 
    push hl                    ;8bae e5  .                         (flow from: 8279)  827a push hl 
    call v_sub_85f0h           ;8baf cd 30 28  . 0 (               (flow from: 827a)  827b call 85f0 
    pop ix                     ;8bb2 dd e1  . .                    (flow from: 8607)  827e pop ix 
    call v_sub_828fh           ;8bb4 cd cf 24  . . $               (flow from: 827e)  8280 call 828f 
    pop hl                     ;8bb7 e1  .                         (flow from: 82b1)  8283 pop hl 
    call v_sub_8248h           ;8bb8 cd 88 24  . . $               (flow from: 8283)  8284 call 8248 
    pop af                     ;8bbb f1  .                         (flow from: 8255 825a)  8287 pop af 
    add a,008h                 ;8bbc c6 08  . .                    (flow from: 8287)  8288 add a,08 
    cp 0a9h                    ;8bbe fe a9  . .                    (flow from: 8288)  828a cp a9 
    jr c,l8bach                ;8bc0 38 ea  8 .                    (flow from: 828a)  828c jr c,8278 
    ret                        ;8bc2 c9  .                         (flow from: 828c)  828e ret 
v_sub_828fh:
    push ix                    ;8bc3 dd e5  . .                    (flow from: 8280)  828f push ix 
    call v_sub_8135h           ;8bc5 cd 75 23  . u #               (flow from: 828f)  8291 call 8135 
    pop ix                     ;8bc8 dd e1  . .                    (flow from: 8189 81b6)  8294 pop ix 
    call v_sub_80f5h           ;8bca cd 35 23  . 5 #               (flow from: 8294)  8296 call 80f5 
    jr c,l8bd4h                ;8bcd 38 05  8 .                    (flow from: 8109)  8299 jr c,82a0 
    ld hl,v_l8aadh             ;8bcf 21 ed 2c  ! . ,               (flow from: 8299)  829b ld hl,8aad 
    ld (hl),003h               ;8bd2 36 03  6 .                    (flow from: 829b)  829e ld (hl),03 
l8bd4h:
    ld hl,v_sub_8744h          ;8bd4 21 84 29  ! . )               (flow from: 8299 829e)  82a0 ld hl,8744 
v_sub_82a3h:
    ld (v_l82c4h+1),hl         ;8bd7 22 05 25  " . %               (flow from: 82a0)  82a3 ld (82c5),hl 
    ld hl,v_l8aa5h             ;8bda 21 e5 2c  ! . ,               (flow from: 82a3)  82a6 ld hl,8aa5 
    ld c,000h                  ;8bdd 0e 00  . .                    (flow from: 82a6)  82a9 ld c,00 
l8bdfh:
    ld a,(hl)                  ;8bdf 7e  ~                         (flow from: 82a9 82ae 82c7)  82ab ld a,(hl) 
    inc hl                     ;8be0 23  #                         (flow from: 82ab)  82ac inc hl 
    dec a                      ;8be1 3d  =                         (flow from: 82ac)  82ad dec a 
    jr z,l8bdfh                ;8be2 28 fb  ( .                    (flow from: 82ad)  82ae jr z,82ab 
    inc a                      ;8be4 3c  <                         (flow from: 82ae)  82b0 inc a 
    ret z                      ;8be5 c8  .                         (flow from: 82b0)  82b1 ret z 
    cp 022h                    ;8be6 fe 22  . "                    (flow from: 82b1)  82b2 cp 22 
    jr nz,l8bedh               ;8be8 20 03    .                    (flow from: 82b2)  82b4 jr nz,82b9 
    inc c                      ;8bea 0c  . 
    ld a,022h                  ;8beb 3e 22  > " 
l8bedh:
    bit 0,c                    ;8bed cb 41  . A                    (flow from: 82b4)  82b9 bit 0,c 
    jr nz,l8bf8h               ;8bef 20 07    .                    (flow from: 82b9)  82bb jr nz,82c4 
    call potencialCommandKeyPressed                            ;8bf1 cd 6e 29  . n )                                                   (flow from: 82bb)  82bd call 872e 
    jr nz,l8bf8h               ;8bf4 20 02    .                    (flow from: 8730 873c)  82c0 jr nz,82c4 
    and 0ffh                   ;8bf6 e6 ff  . .                    (flow from: 82c0)  82c2 and ff 
l8bf8h:
v_l82c4h:
    call v_sub_8744h           ;8bf8 cd 84 29  . . )               (flow from: 82c0 82c2)  82c4 call 8744 
    jr l8bdfh                  ;8bfb 18 e2  . .                    (flow from: 8749)  82c7 jr 82ab 
v_sub_82c9h:
    push hl                    ;8bfd e5  .                         (flow from: 8198 81c3)  82c9 push hl 
    ex de,hl                   ;8bfe eb  .                         (flow from: 82c9)  82ca ex de,hl 
    ld d,000h                  ;8bff 16 00  . .                    (flow from: 82ca)  82cb ld d,00 
    ld e,a                     ;8c01 5f  _                         (flow from: 82cb)  82cd ld e,a 
    add hl,de                  ;8c02 19  .                         (flow from: 82cd)  82ce add hl,de 
    ld e,(hl)                  ;8c03 5e  ^                         (flow from: 82ce)  82cf ld e,(hl) 
    add hl,de                  ;8c04 19  .                         (flow from: 82cf)  82d0 add hl,de 
    ex de,hl                   ;8c05 eb  .                         (flow from: 82d0)  82d1 ex de,hl 
    pop hl                     ;8c06 e1  .                         (flow from: 82d1)  82d2 pop hl 
    ret                        ;8c07 c9  .                         (flow from: 82d2)  82d3 ret 
v_sub_82d4h:
    call v_l81c8h              ;8c08 cd 08 24  . . $               (flow from: 816d 819d)  82d4 call 81c8 
v_sub_82d7h:
    ld c,020h                  ;8c0b 0e 20  .                      (flow from: 8161 81dd)  82d7 ld c,20 
    jr l8c15h                  ;8c0d 18 06  . .                    (flow from: 82d7)  82d9 jr 82e1 
v_l82dbh:
    ld bc,03700h               ;8c0f 01 00 37  . . 7               (flow from: 775a)  82db ld bc,3700 
    ld hl,v_l8ac7h             ;8c12 21 07 2d  ! . -               (flow from: 82db)  82de ld hl,8ac7 
l8c15h:
atHLrepeatBTimesC:
    ld (hl),c                  ;8c15 71  q                         (flow from: 1 7cd5 7ce3 7d1c 7de3 813c 82d9 82de 82e3)  82e1 ld (hl),c 
    inc hl                     ;8c16 23  #                         (flow from: 82e1)  82e2 inc hl 
    djnz l8c15h                ;8c17 10 fc  . .                    (flow from: 82e2)  82e3 djnz 82e1 
    ret                        ;8c19 c9  .                         (flow from: 82e3)  82e5 ret 
v_sub_82e6h:
    ld b,000h                  ;8c1a 06 00  . .                    (flow from: 7fc9 8007)  82e6 ld b,00 
    ld hl,inputBufferStart     ;8c1c 21 3f 2d  ! ? -               (flow from: 82e6)  82e8 ld hl,8aff 
    call atHLorNextIfOne       ;8c1f cd ee 27  . . '               (flow from: 82e8)  82eb call 85ae 
    cp 041h                    ;8c22 fe 41  . A                    (flow from: 85b1)  82ee cp 41 
    jr c,l8c28h                ;8c24 38 02  8 .                    (flow from: 82ee)  82f0 jr c,82f4 
    set 3,d                    ;8c26 cb da  . .                    (flow from: 82f0)  82f2 set 3,d 
l8c28h:
    ld (v_l8b22h),de           ;8c28 ed 53 62 2d  . S b -          (flow from: 82f0 82f2)  82f4 ld (8b22),de 
    push af                    ;8c2c f5  .                         (flow from: 82f4)  82f8 push af 
    ld a,e                     ;8c2d 7b  {                         (flow from: 82f8)  82f9 ld a,e 
    cp 003h                    ;8c2e fe 03  . .                    (flow from: 82f9)  82fa cp 03 
    jr nz,l8c38h               ;8c30 20 06    .                    (flow from: 82fa)  82fc jr nz,8304 
    ld a,d                     ;8c32 7a  z 
    cp 037h                    ;8c33 fe 37  . 7 
    jp z,v_l8098h              ;8c35 ca d8 22  . . " 
l8c38h:
    pop af                     ;8c38 f1  .                         (flow from: 82fc)  8304 pop af 
    ld ix,v_l8b24h             ;8c39 dd 21 64 2d  . ! d -          (flow from: 8304)  8305 ld ix,8b24 
    ret c                      ;8c3d d8  .                         (flow from: 8305)  8309 ret c 
    call v_sub_8815h           ;8c3e cd 55 2a  . U *               (flow from: 8309)  830a call 8815 
    ld ix,v_l8b26h             ;8c41 dd 21 66 2d  . ! f -          (flow from: 8818 88e0)  830d ld ix,8b26 
    set 7,h                    ;8c45 cb fc  . .                    (flow from: 830d)  8311 set 7,h 
    ld (ix-002h),h             ;8c47 dd 74 fe  . t .               (flow from: 8311)  8313 ld (ix-02),h 
    ld (ix-001h),l             ;8c4a dd 75 ff  . u .               (flow from: 8313)  8316 ld (ix-01),l 
    ld b,002h                  ;8c4d 06 02  . .                    (flow from: 8316)  8319 ld b,02 
    ret                        ;8c4f c9  .                         (flow from: 8319)  831b ret 
v_sub_831ch:
    ld de,00352h               ;8c50 11 52 03  . R .               (flow from: 817a)  831c ld de,0352 
    ld a,001h                  ;8c53 3e 01  > .                    (flow from: 831c)  831f ld a,01 
    bit 5,c                    ;8c55 cb 69  . i                    (flow from: 831f)  8321 bit 5,c 
    jr nz,l8c62h               ;8c57 20 09    .                    (flow from: 8321)  8323 jr nz,832e 
    bit 4,c                    ;8c59 cb 61  . a                    (flow from: 8323)  8325 bit 4,c 
    jr z,l8c62h                ;8c5b 28 05  ( .                    (flow from: 8325)  8327 jr z,832e 
    dec a                      ;8c5d 3d  =                         (flow from: 8327)  8329 dec a 
    res 4,c                    ;8c5e cb a1  . .                    (flow from: 8329)  832a res 4,c 
    set 5,c                    ;8c60 cb e9  . .                    (flow from: 832a)  832c set 5,c 
l8c62h:
    ld (vr_lO8373h+1),a        ;8c62 32 b4 25  2 . %               (flow from: 8323 8327 832c)  832e ld (8374),a 
        ld hl,l0977eh+1804                                     ;8c65 21 96 37  ! . 7                                                   (flow from: 832e)  8331 ld hl,9556                                  (flow from: 832e)  8331 ld hl,9556 
    exx                        ;8c68 d9  .                         (flow from: 8331)  8334 exx 
    ld b,00bh                  ;8c69 06 0b  . .                    (flow from: 8334)  8335 ld b,0b 
l8c6bh:
    exx                        ;8c6b d9  .                         (flow from: 8335 8355)  8337 exx 
    ld a,(hl)                  ;8c6c 7e  ~                         (flow from: 8337)  8338 ld a,(hl) 
    cp b                       ;8c6d b8  .                         (flow from: 8338)  8339 cp b 
    jr nz,l8c78h               ;8c6e 20 08    .                    (flow from: 8339)  833a jr nz,8344 
    inc hl                     ;8c70 23  #                         (flow from: 833a)  833c inc hl 
    ld a,(hl)                  ;8c71 7e  ~                         (flow from: 833c)  833d ld a,(hl) 
    dec hl                     ;8c72 2b  +                         (flow from: 833d)  833e dec hl 
    and 0f0h                   ;8c73 e6 f0  . .                    (flow from: 833e)  833f and f0 
    cp c                       ;8c75 b9  .                         (flow from: 833f)  8341 cp c 
    jr z,l8c8eh                ;8c76 28 16  ( .                    (flow from: 8341)  8342 jr z,835a 
l8c78h:
    jr c,l8c7eh                ;8c78 38 04  8 .                    (flow from: 833a 8342)  8344 jr c,834a 
    sbc hl,de                  ;8c7a ed 52  . R                    (flow from: 8344)  8346 sbc hl,de 
    jr l8c7fh                  ;8c7c 18 01  . .                    (flow from: 8346)  8348 jr 834b 
l8c7eh:
    add hl,de                  ;8c7e 19  .                         (flow from: 8344)  834a add hl,de 
l8c7fh:
    srl d                      ;8c7f cb 3a  . :                    (flow from: 8348 834a)  834b srl d 
    rr e                       ;8c81 cb 1b  . .                    (flow from: 834b)  834d rr e 
    jr nc,l8c88h               ;8c83 30 03  0 .                    (flow from: 834d)  834f jr nc,8354 
    inc de                     ;8c85 13  .                         (flow from: 834f)  8351 inc de 
    inc de                     ;8c86 13  .                         (flow from: 8351)  8352 inc de 
    inc de                     ;8c87 13  .                         (flow from: 8352)  8353 inc de 
l8c88h:
    exx                        ;8c88 d9  .                         (flow from: 834f 8353)  8354 exx 
    djnz l8c6bh                ;8c89 10 e0  . .                    (flow from: 8354)  8355 djnz 8337 
    inc b                      ;8c8b 04  . 
    exx                        ;8c8c d9  . 
    ret                        ;8c8d c9  . 
l8c8eh:
    inc hl                     ;8c8e 23  #                         (flow from: 8342 8601)  835a inc hl 
    inc hl                     ;8c8f 23  #                         (flow from: 835a)  835b inc hl 
    ld a,(hl)                  ;8c90 7e  ~                         (flow from: 835b)  835c ld a,(hl) 
    inc hl                     ;8c91 23  #                         (flow from: 835c)  835d inc hl 
    ld d,(hl)                  ;8c92 56  V                         (flow from: 835d)  835e ld d,(hl) 
    inc hl                     ;8c93 23  #                         (flow from: 835e)  835f inc hl 
    ld e,(hl)                  ;8c94 5e  ^                         (flow from: 835f)  8360 ld e,(hl) 
    srl a                      ;8c95 cb 3f  . ?                    (flow from: 8360)  8361 srl a 
    ld b,003h                  ;8c97 06 03  . .                    (flow from: 8361)  8363 ld b,03 
    rr d                       ;8c99 cb 1a  . .                    (flow from: 8363)  8365 rr d 
    jr l8c9fh                  ;8c9b 18 02  . .                    (flow from: 8365)  8367 jr 836b 
l8c9dh:
    srl d                      ;8c9d cb 3a  . :                    (flow from: 836d)  8369 srl d 
l8c9fh:
    rr e                       ;8c9f cb 1b  . .                    (flow from: 8367 8369)  836b rr e 
    djnz l8c9dh                ;8ca1 10 fa  . .                    (flow from: 836b)  836d djnz 8369 
    srl e                      ;8ca3 cb 3b  .                  ;   (flow from: 836d)  836f srl e 
    srl e                      ;8ca5 cb 3b  .                  ;   (flow from: 836f)  8371 srl e 
vr_lO8373h:
    ld b,001h                  ;8ca7 06 01  . .                    (flow from: 8371)  8373 ld b,01 
    dec b                      ;8ca9 05  .                         (flow from: 8373)  8375 dec b 
    ret z                      ;8caa c8  .                         (flow from: 8375)  8376 ret z 
    push af                    ;8cab f5  .                         (flow from: 8376)  8377 push af 
    ld a,e                     ;8cac 7b  {                         (flow from: 8377)  8378 ld a,e 
    inc a                      ;8cad 3c  <                         (flow from: 8378)  8379 inc a 
    call v_sub_84c3h           ;8cae cd 03 27  . . '               (flow from: 8379)  837a call 84c3 
    jr nz,l8cb4h               ;8cb1 20 01    .                    (flow from: 84d5)  837d jr nz,8380 
    inc e                      ;8cb3 1c  . 
l8cb4h:
    ld a,d                     ;8cb4 7a  z                         (flow from: 837d)  8380 ld a,d 
    inc a                      ;8cb5 3c  <                         (flow from: 8380)  8381 inc a 
    call v_sub_84c3h           ;8cb6 cd 03 27  . . '               (flow from: 8381)  8382 call 84c3 
    jr nz,l8cbch               ;8cb9 20 01    .                    (flow from: 84df)  8385 jr nz,8388 
    inc d                      ;8cbb 14  .                         (flow from: 8385)  8387 inc d 
l8cbch:
    pop af                     ;8cbc f1  .                         (flow from: 8387)  8388 pop af 
    cp a                       ;8cbd bf  .                         (flow from: 8388)  8389 cp a 
    ret                        ;8cbe c9  .                         (flow from: 8389)  838a ret 
v_sub_838bh:
    ld hl,v_l8ad1h             ;8cbf 21 11 2d  ! . -               (flow from: 7f14)  838b ld hl,8ad1 
    ld b,028h                  ;8cc2 06 28  . (                    (flow from: 838b)  838e ld b,28 
    ld c,001h                  ;8cc4 0e 01  . .                    (flow from: 838e)  8390 ld c,01 
    xor a                      ;8cc6 af  .                         (flow from: 8390)  8392 xor a 
l8cc7h:
    cp (hl)                    ;8cc7 be  .                         (flow from: 8392 8398)  8393 cp (hl) 
    inc hl                     ;8cc8 23  #                         (flow from: 8393)  8394 inc hl 
    jr z,l8ccch                ;8cc9 28 01  ( .                    (flow from: 8394)  8395 jr z,8398 
    inc c                      ;8ccb 0c  .                         (flow from: 8395)  8397 inc c 
l8ccch:
    djnz l8cc7h                ;8ccc 10 f9  . .                    (flow from: 8395 8397)  8398 djnz 8393 
    ld a,012h                  ;8cce 3e 12  > .                    (flow from: 8398)  839a ld a,12 
    cp c                       ;8cd0 b9  .                         (flow from: 839a)  839c cp c 
    jr c,l8ce2h                ;8cd1 38 0f  8 .                    (flow from: 839c)  839d jr c,83ae 
    ret                        ;8cd3 c9  .                         (flow from: 839d)  839f ret 
v_sub_83a0h:
    cp 02ch                    ;8cd4 fe 2c  . ,                    (flow from: 7fd4 7fec 803a)  83a0 cp 2c 
    jr z,l8cdfh                ;8cd6 28 07  ( .                    (flow from: 83a0)  83a2 jr z,83ab 
    inc de                     ;8cd8 13  .                         (flow from: 83a2)  83a4 inc de 
    cp 02dh                    ;8cd9 fe 2d  . -                    (flow from: 83a4)  83a5 cp 2d 
    jr z,l8cdfh                ;8cdb 28 02  ( .                    (flow from: 83a5)  83a7 jr z,83ab 
    inc de                     ;8cdd 13  . 
    inc de                     ;8cde 13  . 
l8cdfh:
    call v_sub_8492h           ;8cdf cd d2 26  . . &               (flow from: 83a2 83a7)  83ab call 8492 
l8ce2h:
    jp c,syntaxError           ;8ce2 da c9 22  . . "               (flow from: 8417 849d)  83ae jp c,8089 
    cp 02bh                    ;8ce5 fe 2b  . +                    (flow from: 83ae)  83b1 cp 2b 
    jr z,l8cf0h                ;8ce7 28 07  ( .                    (flow from: 83b1)  83b3 jr z,83bc 
    cp 02dh                    ;8ce9 fe 2d  . -                    (flow from: 83b3)  83b5 cp 2d 
    jr nz,l8cf5h               ;8ceb 20 08    .                    (flow from: 83b5)  83b7 jr nz,83c1 
    call v_sub_8962h           ;8ced cd a2 2b  . . + 
l8cf0h:
    call v_sub_8492h           ;8cf0 cd d2 26  . . & 
    jr c,l8ce2h                ;8cf3 38 ed  8 . 
l8cf5h:
    cp 024h                    ;8cf5 fe 24  . $                    (flow from: 83b7)  83c1 cp 24 
    jr nz,l8cfeh               ;8cf7 20 05    .                    (flow from: 83c1)  83c3 jr nz,83ca 
    call v_sub_848fh           ;8cf9 cd cf 26  . . &               (flow from: 83c3)  83c5 call 848f 
    jr l8d31h                  ;8cfc 18 33  . 3                    (flow from: 849f)  83c8 jr 83fd 
l8cfeh:
    ld c,a                     ;8cfe 4f  O                         (flow from: 83c3)  83ca ld c,a 
    or 020h                    ;8cff f6 20  .                      (flow from: 83ca)  83cb or 20 
    call potencialCommandKeyPressed                            ;8d01 cd 6e 29  . n )                                                   (flow from: 83cb)  83cd call 872e 
    jr nz,l8d2dh               ;8d04 20 27    '                    (flow from: 8730 873c)  83d0 jr nz,83f9 
    push bc                    ;8d06 c5  .                         (flow from: 83d0)  83d2 push bc 
    dec de                     ;8d07 1b  .                         (flow from: 83d2)  83d3 dec de 
    push de                    ;8d08 d5  .                         (flow from: 83d3)  83d4 push de 
    push ix                    ;8d09 dd e5  . .                    (flow from: 83d4)  83d5 push ix 
    ex de,hl                   ;8d0b eb  .                         (flow from: 83d5)  83d7 ex de,hl 
    call v_sub_8815h           ;8d0c cd 55 2a  . U *               (flow from: 83d7)  83d8 call 8815 
    pop ix                     ;8d0f dd e1  . .                    (flow from: 8818 88e0)  83db pop ix 
    set 7,h                    ;8d11 cb fc  . .                    (flow from: 83db)  83dd set 7,h 
    ld (ix+000h),h             ;8d13 dd 74 00  . t .               (flow from: 83dd)  83df ld (ix+00),h 
    inc ix                     ;8d16 dd 23  . #                    (flow from: 83df)  83e2 inc ix 
    ld (ix+000h),l             ;8d18 dd 75 00  . u .               (flow from: 83e2)  83e4 ld (ix+00),l 
    inc ix                     ;8d1b dd 23  . #                    (flow from: 83e4)  83e7 inc ix 
    pop bc                     ;8d1d c1  .                         (flow from: 83e7)  83e9 pop bc 
    ld hl,(v_l8ac7h)           ;8d1e 2a 07 2d  * . -               (flow from: 83e9)  83ea ld hl,(8ac7) 
    ld h,000h                  ;8d21 26 00  & .                    (flow from: 83ea)  83ed ld h,00 
    add hl,bc                  ;8d23 09  .                         (flow from: 83ed)  83ef add hl,bc 
    ex de,hl                   ;8d24 eb  .                         (flow from: 83ef)  83f0 ex de,hl 
    pop bc                     ;8d25 c1  .                         (flow from: 83f0)  83f1 pop bc 
    inc b                      ;8d26 04  .                         (flow from: 83f1)  83f2 inc b 
    inc b                      ;8d27 04  .                         (flow from: 83f2)  83f3 inc b 
    call v_sub_8492h           ;8d28 cd d2 26  . . &               (flow from: 83f3)  83f4 call 8492 
    jr l8d31h                  ;8d2b 18 04  . .                    (flow from: 849d 849f)  83f7 jr 83fd 
l8d2dh:
    ld a,c                     ;8d2d 79  y                         (flow from: 83d0)  83f9 ld a,c 
    call v_sub_8419h           ;8d2e cd 59 26  . Y &               (flow from: 83f9)  83fa call 8419 
l8d31h:
    ccf                        ;8d31 3f  ?                         (flow from: 83c8 83f7 845c)  83fd ccf 
    ret nc                     ;8d32 d0  .                         (flow from: 83fd)  83fe ret nc 
    cp 02bh                    ;8d33 fe 2b  . +                    (flow from: 83fe)  83ff cp 2b 
    jr z,l8d48h                ;8d35 28 11  ( .                    (flow from: 83ff)  8401 jr z,8414 
    cp 02dh                    ;8d37 fe 2d  . - 
    jr z,l8d48h                ;8d39 28 0d  ( . 
    cp 02ah                    ;8d3b fe 2a  . * 
    jr z,l8d48h                ;8d3d 28 09  ( . 
    cp 02fh                    ;8d3f fe 2f  . / 
    jr z,l8d48h                ;8d41 28 05  ( . 
    cp 03fh                    ;8d43 fe 3f  . ? 
l8d45h:
    jp nz,syntaxError          ;8d45 c2 c9 22  . . " 
l8d48h:
    call v_sub_848fh           ;8d48 cd cf 26  . . &               (flow from: 8401)  8414 call 848f 
    jr l8ce2h                  ;8d4b 18 95  . .                    (flow from: 849d)  8417 jr 83ae 
v_sub_8419h:
    cp 022h                    ;8d4d fe 22  . "                    (flow from: 83fa)  8419 cp 22 
    jr z,l8d93h                ;8d4f 28 42  ( B                    (flow from: 8419)  841b jr z,845f 
    ld c,00ah                  ;8d51 0e 0a  . .                    (flow from: 841b)  841d ld c,0a 
    call v_sub_8726h           ;8d53 cd 66 29  . f )               (flow from: 841d)  841f call 8726 
    jr z,l8d6ch                ;8d56 28 14  ( .                    (flow from: 872b 872d)  8422 jr z,8438 
    cp 025h                    ;8d58 fe 25  . % 
    jr nz,l8d60h               ;8d5a 20 04    . 
    ld c,002h                  ;8d5c 0e 02  . . 
    jr l8d66h                  ;8d5e 18 06  . . 
l8d60h:
    cp 023h                    ;8d60 fe 23  . # 
    jr nz,l8d45h               ;8d62 20 e1    . 
    ld c,010h                  ;8d64 0e 10  . . 
l8d66h:
    call v_sub_848fh           ;8d66 cd cf 26  . . & 
    jp c,syntaxError           ;8d69 da c9 22  . . " 
l8d6ch:
    ld hl,00000h               ;8d6c 21 00 00  ! . .               (flow from: 8422)  8438 ld hl,0000 
l8d6fh:
    call v_sub_84a0h           ;8d6f cd e0 26  . . &               (flow from: 8438 845d)  843b call 84a0 
    ret nc                     ;8d72 d0  .                         (flow from: 84a7)  843e ret nc 
    push de                    ;8d73 d5  .                         (flow from: 843e)  843f push de 
    push af                    ;8d74 f5  .                         (flow from: 843f)  8440 push af 
    ld a,c                     ;8d75 79  y                         (flow from: 8440)  8441 ld a,c 
    dec a                      ;8d76 3d  =                         (flow from: 8441)  8442 dec a 
    ld d,h                     ;8d77 54  T                         (flow from: 8442)  8443 ld d,h 
    ld e,l                     ;8d78 5d  ]                         (flow from: 8443)  8444 ld e,l 
l8d79h:
    add hl,de                  ;8d79 19  .                         (flow from: 8444 844a)  8445 add hl,de 
l8d7ah:
    jp c,bigNumberError        ;8d7a da c5 22  . . "               (flow from: 8445)  8446 jp c,8085 
    dec a                      ;8d7d 3d  =                         (flow from: 8446)  8449 dec a 
    jr nz,l8d79h               ;8d7e 20 f9    .                    (flow from: 8449)  844a jr nz,8445 
    pop af                     ;8d80 f1  .                         (flow from: 844a)  844c pop af 
    cp c                       ;8d81 b9  .                         (flow from: 844c)  844d cp c 
    jp nc,bigNumberError       ;8d82 d2 c5 22  . . "               (flow from: 844d)  844e jp nc,8085 
    ld d,000h                  ;8d85 16 00  . .                    (flow from: 844e)  8451 ld d,00 
    ld e,a                     ;8d87 5f  _                         (flow from: 8451)  8453 ld e,a 
    add hl,de                  ;8d88 19  .                         (flow from: 8453)  8454 add hl,de 
    jr c,l8d7ah                ;8d89 38 ef  8 .                    (flow from: 8454)  8455 jr c,8446 
    pop de                     ;8d8b d1  .                         (flow from: 8455)  8457 pop de 
    ex af,af'                  ;8d8c 08  .                         (flow from: 8457)  8458 ex af,af' 
    call v_sub_848fh           ;8d8d cd cf 26  . . &               (flow from: 8458)  8459 call 848f 
    ret c                      ;8d90 d8  .                         (flow from: 849d 849f)  845c ret c 
    jr l8d6fh                  ;8d91 18 dc  . .                    (flow from: 845c)  845d jr 843b 
l8d93h:
    ld hl,00000h               ;8d93 21 00 00  ! . . 
    call v_sub_847ah           ;8d96 cd ba 26  . . & 
    or a                       ;8d99 b7  . 
    jr z,l8dach                ;8d9a 28 10  ( . 
    ld l,a                     ;8d9c 6f  o 
    call v_sub_847ah           ;8d9d cd ba 26  . . & 
    or a                       ;8da0 b7  . 
    jr z,l8dach                ;8da1 28 09  ( . 
    ld h,l                     ;8da3 65  e 
    ld l,a                     ;8da4 6f  o 
    call v_sub_847ah           ;8da5 cd ba 26  . . & 
    or a                       ;8da8 b7  . 
    jp nz,badStringError       ;8da9 c2 d4 22  . . " 
l8dach:
    jr l8dc1h                  ;8dac 18 13  . . 
v_sub_847ah:
    call v_sub_848fh           ;8dae cd cf 26  . . & 
    or a                       ;8db1 b7  . 
    jp z,badStringError        ;8db2 ca d4 22  . . " 
    cp 022h                    ;8db5 fe 22  . " 
    jr z,l8dbbh                ;8db7 28 02  ( . 
    and a                      ;8db9 a7  . 
    ret                        ;8dba c9  . 
l8dbbh:
    ld a,(de)                  ;8dbb 1a  . 
    cp 022h                    ;8dbc fe 22  . " 
    ld a,000h                  ;8dbe 3e 00  > . 
    ret nz                     ;8dc0 c0  . 
l8dc1h:
    ld a,022h                  ;8dc1 3e 22  > " 
v_sub_848fh:
    call v_sub_8962h           ;8dc3 cd a2 2b  . . +               (flow from: 83c5 8414 8459)  848f call 8962 
v_sub_8492h:
    ld a,(de)                  ;8dc6 1a  .                         (flow from: 83ab 83f4 8968)  8492 ld a,(de) 
    inc de                     ;8dc7 13  .                         (flow from: 8492)  8493 inc de 
    cp 029h                    ;8dc8 fe 29  . )                    (flow from: 8493)  8494 cp 29 
    jr z,l8dd2h                ;8dca 28 06  ( .                    (flow from: 8494)  8496 jr z,849e 
    cp 02ch                    ;8dcc fe 2c  . ,                    (flow from: 8496)  8498 cp 2c 
    jr z,l8dd2h                ;8dce 28 02  ( .                    (flow from: 8498)  849a jr z,849e 
    or a                       ;8dd0 b7  .                         (flow from: 849a)  849c or a 
    ret nz                     ;8dd1 c0  .                         (flow from: 849c)  849d ret nz 
l8dd2h:
    scf                        ;8dd2 37  7                         (flow from: 8496 849a 849d)  849e scf 
    ret                        ;8dd3 c9  .                         (flow from: 849e)  849f ret 
v_sub_84a0h:
    push af                    ;8dd4 f5  .                         (flow from: 843b)  84a0 push af 
    ex af,af'                  ;8dd5 08  .                         (flow from: 84a0)  84a1 ex af,af' 
    pop af                     ;8dd6 f1  .                         (flow from: 84a1)  84a2 pop af 
    sub 030h                   ;8dd7 d6 30  . 0                    (flow from: 84a2)  84a3 sub 30 
    cp 00ah                    ;8dd9 fe 0a  . .                    (flow from: 84a3)  84a5 cp 0a 
    ret c                      ;8ddb d8  .                         (flow from: 84a5)  84a7 ret c 
    sub 007h                   ;8ddc d6 07  . . 
    cp 00ah                    ;8dde fe 0a  . . 
    jr c,l8df4h                ;8de0 38 12  8 . 
    cp 010h                    ;8de2 fe 10  . . 
    ret c                      ;8de4 d8  . 
    sub 020h                   ;8de5 d6 20  .   
    cp 00ah                    ;8de7 fe 0a  . . 
    jr c,l8df4h                ;8de9 38 09  8 . 
    cp 010h                    ;8deb fe 10  . . 
    jr nc,l8df4h               ;8ded 30 05  0 . 
    ex af,af'                  ;8def 08  . 
    sub 020h                   ;8df0 d6 20  .   
    ex af,af'                  ;8df2 08  . 
    ret c                      ;8df3 d8  . 
l8df4h:
    ex af,af'                  ;8df4 08  . 
    and a                      ;8df5 a7  . 
    ret                        ;8df6 c9  . 
v_sub_84c3h:
    cp 01ah                    ;8df7 fe 1a  . .                    (flow from: 7f84 7f8c 837a 8382)  84c3 cp 1a 
    jr z,l8e0ah                ;8df9 28 0f  ( .                    (flow from: 84c3)  84c5 jr z,84d6 
    cp 01ch                    ;8dfb fe 1c  . .                    (flow from: 84c5)  84c7 cp 1c 
    jr z,l8e0ah                ;8dfd 28 0b  ( .                    (flow from: 84c7)  84c9 jr z,84d6 
    cp 01eh                    ;8dff fe 1e  . .                    (flow from: 84c9)  84cb cp 1e 
    jr z,l8e0ah                ;8e01 28 07  ( .                    (flow from: 84cb)  84cd jr z,84d6 
    cp 02ah                    ;8e03 fe 2a  . *                    (flow from: 84cd)  84cf cp 2a 
    jr z,l8e0ah                ;8e05 28 03  ( .                    (flow from: 84cf)  84d1 jr z,84d6 
    cp 02fh                    ;8e07 fe 2f  . /                    (flow from: 84d1)  84d3 cp 2f 
    ret nz                     ;8e09 c0  .                         (flow from: 84d3)  84d5 ret nz 
l8e0ah:
    dec a                      ;8e0a 3d  =                         (flow from: 84c9)  84d6 dec a 
    push hl                    ;8e0b e5  .                         (flow from: 84d6)  84d7 push hl 
    ld hl,vr_l07fc0h+1         ;8e0c 21 01 22  ! . "               (flow from: 84d7)  84d8 ld hl,7fc1 
    ld (hl),001h               ;8e0f 36 01  6 .                    (flow from: 84d8)  84db ld (hl),01 
    pop hl                     ;8e11 e1  .                         (flow from: 84db)  84dd pop hl 
    cp a                       ;8e12 bf  .                         (flow from: 84dd)  84de cp a 
    ret                        ;8e13 c9  .                         (flow from: 84de)  84df ret 
v_sub_84e0h:
    push hl                    ;8e14 e5  .                         (flow from: 7f6f 7f78)  84e0 push hl 
    call lengthUpToZero        ;8e15 cd 5f 27  . _ '               (flow from: 84e0)  84e1 call 851f 
    pop hl                     ;8e18 e1  .                         (flow from: 8522)  84e4 pop hl 
    ld a,b                     ;8e19 78  x                         (flow from: 84e4)  84e5 ld a,b 
    or a                       ;8e1a b7  .                         (flow from: 84e5)  84e6 or a 
    ret z                      ;8e1b c8  .                         (flow from: 84e6)  84e7 ret z 
    cp 005h                    ;8e1c fe 05  . .                    (flow from: 84e7)  84e8 cp 05 
    jr nc,l8e2ch               ;8e1e 30 0c  0 .                    (flow from: 84e8)  84ea jr nc,84f8 
    push hl                    ;8e20 e5  .                         (flow from: 84ea)  84ec push hl 
    ld hl,v_l854fh             ;8e21 21 8f 27  ! . '               (flow from: 84ec)  84ed ld hl,854f 
    call v_sub_8559h           ;8e24 cd 99 27  . . '               (flow from: 84ed)  84f0 call 8559 
    pop hl                     ;8e27 e1  .                         (flow from: 856e)  84f3 pop hl 
    call compareWithMnemonics                                  ;8e28 cd 67 27  . g '                                                   (flow from: 84f3)  84f4 call 8527 
    ret nc                     ;8e2b d0  .                         (flow from: 8538 8544)  84f7 ret nc 
l8e2ch:
    ld a,(hl)                  ;8e2c 7e  ~                         (flow from: 84ea 84f7)  84f8 ld a,(hl) 
    cp 028h                    ;8e2d fe 28  . (                    (flow from: 84f8)  84f9 cp 28 
    ld a,02ch                  ;8e2f 3e 2c  > ,                    (flow from: 84f9)  84fb ld a,2c 
    ret nz                     ;8e31 c0  .                         (flow from: 84fb)  84fd ret nz 
    inc hl                     ;8e32 23  #                         (flow from: 84fd)  84fe inc hl 
    ld a,(hl)                  ;8e33 7e  ~                         (flow from: 84fe)  84ff ld a,(hl) 
    cp 069h                    ;8e34 fe 69  . i                    (flow from: 84ff)  8500 cp 69 
    jr nz,l8e4eh               ;8e36 20 16    .                    (flow from: 8500)  8502 jr nz,851a 
    inc hl                     ;8e38 23  # 
    ld a,(hl)                  ;8e39 7e  ~ 
    cp 078h                    ;8e3a fe 78  . x 
    ld b,02eh                  ;8e3c 06 2e  . . 
    jr z,l8e46h                ;8e3e 28 06  ( . 
    cp 079h                    ;8e40 fe 79  . y 
    ld b,02fh                  ;8e42 06 2f  . / 
    jr nz,l8e4eh               ;8e44 20 08    . 
l8e46h:
    inc hl                     ;8e46 23  # 
    ld a,(hl)                  ;8e47 7e  ~ 
    cp 02bh                    ;8e48 fe 2b  . + 
    jr z,l8e51h                ;8e4a 28 05  ( . 
    cp 02dh                    ;8e4c fe 2d  . - 
l8e4eh:
    ld a,02dh                  ;8e4e 3e 2d  > -                    (flow from: 8502)  851a ld a,2d 
    ret nz                     ;8e50 c0  .                         (flow from: 851a)  851c ret nz 
l8e51h:
    ld a,b                     ;8e51 78  x 
    ret                        ;8e52 c9  . 
lengthUpToZero:
    xor a                      ;8e53 af  .                         (flow from: 7f1f 7f3f 84e1)  851f xor a 
    ld b,a                     ;8e54 47  G                         (flow from: 851f)  8520 ld b,a 
l8e55h:
    cp (hl)                    ;8e55 be  .                         (flow from: 8520 8525)  8521 cp (hl) 
    ret z                      ;8e56 c8  .                         (flow from: 8521)  8522 ret z 
    inc hl                     ;8e57 23  #                         (flow from: 8522)  8523 inc hl 
    inc b                      ;8e58 04  .                         (flow from: 8523)  8524 inc b 
    jr l8e55h                  ;8e59 18 fa  . .                    (flow from: 8524)  8525 jr 8521 
l8e5bh:
compareWithMnemonics:
; compare instructions with the table records (pointer in DE)
    push hl                    ;8e5b e5  .                         (flow from: 7f29 84f4 8541)  8527 push hl 
l8e5ch:
    ld a,(de)                  ;8e5c 1a  .                         (flow from: 8527 8533)  8528 ld a,(de) 
    and 07fh                   ;8e5d e6 7f  .                     (flow from: 8528)  8529 and 7f 
    cp (hl)                    ;8e5f be  .                         (flow from: 8529)  852b cp (hl) 
; does the letter match?
    jr nz,l8e6dh               ;8e60 20 0b    .                    (flow from: 852b)  852c jr nz,8539 
; letter matches, compare until the end of the word
    ld a,(de)                  ;8e62 1a  .                         (flow from: 852c)  852e ld a,(de) 
    inc hl                     ;8e63 23  #                         (flow from: 852e)  852f inc hl 
    inc de                     ;8e64 13  .                         (flow from: 852f)  8530 inc de 
    and 080h                   ;8e65 e6 80  . .                    (flow from: 8530)  8531 and 80 
    jr z,l8e5ch                ;8e67 28 f3  ( .                    (flow from: 8531)  8533 jr z,8528 
; all word corresponds, A will contain its index
    pop hl                     ;8e69 e1  .                         (flow from: 8533)  8535 pop hl 
    xor a                      ;8e6a af  .                         (flow from: 8535)  8536 xor a 
    ld a,c                     ;8e6b 79  y                         (flow from: 8536)  8537 ld a,c 
    ret                        ;8e6c c9  .                         (flow from: 8537)  8538 ret 
l8e6dh:
; the first letter does not match
; find the end of the word
    pop hl                     ;8e6d e1  .                         (flow from: 852c)  8539 pop hl 
l8e6eh:
    ld a,(de)                  ;8e6e 1a  .                         (flow from: 8539 853e)  853a ld a,(de) 
    and 080h                   ;8e6f e6 80  . .                    (flow from: 853a)  853b and 80 
    inc de                     ;8e71 13  .                         (flow from: 853b)  853d inc de 
    jr z,l8e6eh                ;8e72 28 fa  ( .                    (flow from: 853d)  853e jr z,853a 
    inc c                      ;8e74 0c  .                         (flow from: 853e)  8540 inc c 
    djnz l8e5bh                ;8e75 10 e4  . .                    (flow from: 8540)  8541 djnz 8527 
; no word found, set carry
    scf                        ;8e77 37  7                         (flow from: 8541)  8543 scf 
    ret                        ;8e78 c9  .                         (flow from: 8543)  8544 ret 
v_l8545h:
    defw v_l8c76h                                              ;8e79 
    defb 0x01                                                  ;8e7b
    ld bc,0020ch               ;8e7c 01 0c 02  . . . 
    add hl,hl                  ;8e7f 29  ) 
    ld c,017h                  ;8e80 0e 17  . . 
    scf                        ;8e82 37  7 
v_l854fh:
    defw v_l8db4h                                              ;8e83 
    defb 0x0c                                                  ;8e85
    add hl,bc                  ;8e86 09  . 
    rrca                       ;8e87 0f  . 
    dec d                      ;8e88 15  . 
    ld (bc),a                  ;8e89 02  . 
    inc h                      ;8e8a 24  $ 
    ld b,026h                  ;8e8b 06 26  . & 
v_sub_8559h:
    ld a,b                     ;8e8d 78  x                         (flow from: 7f25 84f0)  8559 ld a,b 
    add a,a                    ;8e8e 87  .                         (flow from: 8559)  855a add a,a 
    ld c,a                     ;8e8f 4f  O                         (flow from: 855a)  855b ld c,a 
    xor a                      ;8e90 af  .                         (flow from: 855b)  855c xor a 
    ld b,a                     ;8e91 47  G                         (flow from: 855c)  855d ld b,a 
    push hl                    ;8e92 e5  .                         (flow from: 855d)  855e push hl 
    add hl,bc                  ;8e93 09  .                         (flow from: 855e)  855f add hl,bc 
    ld b,(hl)                  ;8e94 46  F                         (flow from: 855f)  8560 ld b,(hl) 
    inc hl                     ;8e95 23  #                         (flow from: 8560)  8561 inc hl 
    ld c,(hl)                  ;8e96 4e  N                         (flow from: 8561)  8562 ld c,(hl) 
    pop hl                     ;8e97 e1  .                         (flow from: 8562)  8563 pop hl 
    ld e,(hl)                  ;8e98 5e  ^                         (flow from: 8563)  8564 ld e,(hl) 
    inc hl                     ;8e99 23  #                         (flow from: 8564)  8565 inc hl 
    ld d,(hl)                  ;8e9a 56  V                         (flow from: 8565)  8566 ld d,(hl) 
    ld h,a                     ;8e9b 67  g                         (flow from: 8566)  8567 ld h,a 
    ld l,c                     ;8e9c 69  i                         (flow from: 8567)  8568 ld l,c 
    add hl,de                  ;8e9d 19  .                         (flow from: 8568)  8569 add hl,de 
    ld e,(hl)                  ;8e9e 5e  ^                         (flow from: 8569)  856a ld e,(hl) 
    ld d,a                     ;8e9f 57  W                         (flow from: 856a)  856b ld d,a 
    add hl,de                  ;8ea0 19  .                         (flow from: 856b)  856c add hl,de 
    ex de,hl                   ;8ea1 eb  .                         (flow from: 856c)  856d ex de,hl 
    ret                        ;8ea2 c9  .                         (flow from: 856d)  856e ret 
v_sub_856fh:
    ld b,020h                  ;8ea3 06 20  .                      (flow from: 7eed 7ef8)  856f ld b,20 
    jr l8eadh                  ;8ea5 18 06  . .                    (flow from: 856f)  8571 jr 8579 
v_sub_8573h:
    ld b,02ch                  ;8ea7 06 2c  . ,                    (flow from: 7f03)  8573 ld b,2c 
    jr l8eadh                  ;8ea9 18 02  . .                    (flow from: 8573)  8575 jr 8579 
v_sub_8577h:
    ld b,000h                  ;8eab 06 00  . .                    (flow from: 7f11)  8577 ld b,00 
l8eadh:
    call atHLorNextIfOne       ;8ead cd ee 27  . . '               (flow from: 8571 8575 8577 8597)  8579 call 85ae 
    cp 022h                    ;8eb0 fe 22  . "                    (flow from: 85b1)  857c cp 22 
    jr z,l8ed9h                ;8eb2 28 25  ( %                    (flow from: 857c)  857e jr z,85a5 
    cp 027h                    ;8eb4 fe 27  . '                    (flow from: 857e)  8580 cp 27 
    jr z,l8ed9h                ;8eb6 28 21  ( !                    (flow from: 8580)  8582 jr z,85a5 
l8eb8h:
    cp b                       ;8eb8 b8  .                         (flow from: 8582 859f)  8584 cp b 
    ret z                      ;8eb9 c8  .                         (flow from: 8584)  8585 ret z 
    cp 020h                    ;8eba fe 20  .                      (flow from: 8585)  8586 cp 20 
    inc hl                     ;8ebc 23  #                         (flow from: 8586)  8588 inc hl 
    jr z,l8eadh                ;8ebd 28 ee  ( .                    (flow from: 8588)  8589 jr z,8579 
    dec hl                     ;8ebf 2b  +                         (flow from: 8589)  858b dec hl 
    or a                       ;8ec0 b7  .                         (flow from: 858b)  858c or a 
    jr nz,l8ec5h               ;8ec1 20 02    .                    (flow from: 858c)  858d jr nz,8591 
    inc a                      ;8ec3 3c  <                         (flow from: 858d)  858f inc a 
    ret                        ;8ec4 c9  .                         (flow from: 858f)  8590 ret 
l8ec5h:
    inc hl                     ;8ec5 23  #                         (flow from: 858d)  8591 inc hl 
    set 5,a                    ;8ec6 cb ef  . .                    (flow from: 8591)  8592 set 5,a 
    ld (de),a                  ;8ec8 12  .                         (flow from: 8592)  8594 ld (de),a 
    inc de                     ;8ec9 13  .                         (flow from: 8594)  8595 inc de 
    dec c                      ;8eca 0d  .                         (flow from: 8595)  8596 dec c 
    jr nz,l8eadh               ;8ecb 20 e0    .                    (flow from: 8596)  8597 jr nz,8579 
    jr l8edeh                  ;8ecd 18 0f  . . 
l8ecfh:
    call v_sub_85adh           ;8ecf cd ed 27  . . '               (flow from: 85a8)  859b call 85ad 
    or a                       ;8ed2 b7  .                         (flow from: 85b1)  859e or a 
    jr z,l8eb8h                ;8ed3 28 e3  ( .                    (flow from: 859e)  859f jr z,8584 
    cp 022h                    ;8ed5 fe 22  . " 
    jr z,l8eb8h                ;8ed7 28 df  ( . 
l8ed9h:
    ld (de),a                  ;8ed9 12  .                         (flow from: 8582)  85a5 ld (de),a 
    inc de                     ;8eda 13  .                         (flow from: 85a5)  85a6 inc de 
    dec c                      ;8edb 0d  .                         (flow from: 85a6)  85a7 dec c 
    jr nz,l8ecfh               ;8edc 20 f1    .                    (flow from: 85a7)  85a8 jr nz,859b 
l8edeh:
    jp syntaxError             ;8ede c3 c9 22  . . " 
v_sub_85adh:
    inc hl                     ;8ee1 23  #                         (flow from: 859b)  85ad inc hl 
atHLorNextIfOne:
    ld a,(hl)                  ;8ee2 7e  ~                         (flow from: 76c1 7c2f 7de9 82eb 8579 85ad 85b5 87af 8ll)  85ae ld a,(hl) 
    cp 001h                    ;8ee3 fe 01  . .                    (flow from: 85ae)  85af cp 01 
    ret nz                     ;8ee5 c0  .                         (flow from: 85af)  85b1 ret nz 
    inc hl                     ;8ee6 23  #                         (flow from: 85b1)  85b2 inc hl 
    ld a,(hl)                  ;8ee7 7e  ~                         (flow from: 85b2)  85b3 ld a,(hl) 
    ret                        ;8ee8 c9  .                         (flow from: 85b3)  85b4 ret 
l8ee9h:
v_sub_85b5h:
    call atHLorNextIfOne       ;8ee9 cd ee 27  . . '               (flow from: 7ef0 7efb 85bc)  85b5 call 85ae 
    cp 020h                    ;8eec fe 20  .                      (flow from: 85b1 85b4)  85b8 cp 20 
    ret nz                     ;8eee c0  .                         (flow from: 85b8)  85ba ret nz 
    inc hl                     ;8eef 23  #                         (flow from: 85ba)  85bb inc hl 
    jr l8ee9h                  ;8ef0 18 f7  . .                    (flow from: 85bb)  85bc jr 85b5 
v_sub_85beh:
        ld hl,l095f9h+170                                      ;8ef2 21 af 2f  ! . /                                                   (flow from: 7cf4)  85be ld hl,8d6f                                  (flow from: 7cf4)  85be ld hl,8d6f 
    ld (vr_l08750h+1),hl       ;8ef5 22 91 29  " . )               (flow from: 85be)  85c1 ld (8751),hl 
    ld hl,BOTTOM_LINE_VRAM_ADDRESS                             ;8ef8 21 e0 50  ! . P                                                   (flow from: 85c1)  85c4 ld hl,50e0 
v_l85c7h:
    call v_sub_85f5h           ;8efb cd 35 28  . 5 (               (flow from: 85c4)  85c7 call 85f5 
    ld hl,v_l8afeh             ;8efe 21 3e 2d  ! > -               (flow from: 8607)  85ca ld hl,8afe 
l8f01h:
    inc hl                     ;8f01 23  #                         (flow from: 85ca 85df 85ee)  85cd inc hl 
    ld a,(vr_l08787h+1)        ;8f02 3a c8 29  : . )               (flow from: 85cd)  85ce ld a,(8788) 
    and 01fh                   ;8f05 e6 1f  . .                    (flow from: 85ce)  85d1 and 1f 
    ld (vr_l07each+1),a        ;8f07 32 ed 20  2 .                 (flow from: 85d1)  85d3 ld (7ead),a 
    ld a,(hl)                  ;8f0a 7e  ~                         (flow from: 85d3)  85d6 ld a,(hl) 
    dec a                      ;8f0b 3d  =                         (flow from: 85d6)  85d7 dec a 
    jr z,l8f15h                ;8f0c 28 07  ( .                    (flow from: 85d7)  85d8 jr z,85e1 
    inc a                      ;8f0e 3c  <                         (flow from: 85d8)  85da inc a 
    ret z                      ;8f0f c8  .                         (flow from: 85da)  85db ret z 
    call v_sub_874ah           ;8f10 cd 8a 29  . . )               (flow from: 85db)  85dc call 874a 
    jr l8f01h                  ;8f13 18 ec  . .                    (flow from: 877e)  85df jr 85cd 
l8f15h:
    ld (vr_l07e3bh+1),hl       ;8f15 22 7c 20  " |                 (flow from: 85d8)  85e1 ld (7e3c),hl 
    push hl                    ;8f18 e5  .                         (flow from: 85e1)  85e4 push hl 
        ld a,(l08fa1h+1)                                       ;8f19 3a ae 28  : . (                                                   (flow from: 85e4)  85e5 ld a,(866e)                                 (flow from: 85e4)  85e5 ld a,(866e) 
    add a,0cch                 ;8f1c c6 cc  . .                    (flow from: 85e5)  85e8 add a,cc 
    call v_sub_8769h           ;8f1e cd a9 29  . . )               (flow from: 85e8)  85ea call 8769 
    pop hl                     ;8f21 e1  .                         (flow from: 877e)  85ed pop hl 
    jr l8f01h                  ;8f22 18 dd  . .                    (flow from: 85ed)  85ee jr 85cd 
v_sub_85f0h:
    ld c,000h                  ;8f24 0e 00  . .                    (flow from: 827b)  85f0 ld c,00 
    call ROM_PixelAddress_22b0                                 ;8f26 cd b0 22  . . "                                                   (flow from: 85f0)  85f2 call 22b0 
v_sub_85f5h:
    ld (vr_l08787h+1),hl       ;8f29 22 c8 29  " . )               (flow from: 22ca 80b7 85c7)  85f5 ld (8788),hl 
v_sub_85f8h:
    ld b,008h                  ;8f2c 06 08  . .                    (flow from: 85f5)  85f8 ld b,08 
l8f2eh:
    push hl                    ;8f2e e5  .                         (flow from: 85f8 8605)  85fa push hl 
    ld c,020h                  ;8f2f 0e 20  .                      (flow from: 85fa)  85fb ld c,20 
l8f31h:
    ld (hl),000h               ;8f31 36 00  6 .                    (flow from: 85fb 8601)  85fd ld (hl),00 
    inc l                      ;8f33 2c  ,                         (flow from: 85fd)  85ff inc l 
    dec c                      ;8f34 0d  .                         (flow from: 85ff)  8600 dec c 
    jr nz,l8f31h               ;8f35 20 fa    .                    (flow from: 8600)  8601 jr nz,85fd 
    pop hl                     ;8f37 e1  .                         (flow from: 8601)  8603 pop hl 
    inc h                      ;8f38 24  $                         (flow from: 8603)  8604 inc h 
    djnz l8f2eh                ;8f39 10 f3  . .                    (flow from: 8604)  8605 djnz 85fa 
    ret                        ;8f3b c9  .                         (flow from: 8605)  8607 ret 
v_sub_8608h:
    exx                        ;8f3c d9  .                         (flow (mon) from: 5fc0)  8608 exx 
    call v_sub_8639h           ;8f3d cd 79 28  . y (               (flow (mon) from: 8608)  8609 call 8639 
    exx                        ;8f40 d9  .                         (flow (mon) from: 86a0)  860c exx 
    call potencialCommandKeyPressed                            ;8f41 cd 6e 29  . n )                                                   (flow (mon) from: 860c)  860d call 872e 
    ret nz                     ;8f44 c0  .                         (flow (mon) from: 8730)  8610 ret nz 
    or 020h                    ;8f45 f6 20  .   
    ret                        ;8f47 c9  . 
varcKeyboardScanningsCount:
    ld hl,00000h               ;8f48 21 00 00  ! . .               (flow from: 868c)  8614 ld hl,004e 
    inc hl                     ;8f4b 23  #                         (flow from: 8614)  8617 inc hl 
    ld (varcKeyboardScanningsCount+1),hl                       ;8f4c 22 55 28  " U (                                                   (flow from: 8617)  8618 ld (8615),hl 
    ld a,h                     ;8f4f 7c  |                         (flow from: 8618)  861b ld a,h 
    cp 005h                    ;8f50 fe 05  . .                    (flow from: 861b)  861c cp 05 
    jr nz,l8f6dh               ;8f52 20 19    .                    (flow from: 861c)  861e jr nz,8639 
vr_l08620h:
    ld a,00dh                  ;8f54 3e 0d  > . 
    jr l8fc3h                  ;8f56 18 6b  . k 
l8f58h:
    ld h,002h                  ;8f58 26 02  & .                    (flow from: 863c)  8624 ld h,02 
l8f5ah:
    call getKeypressCodeOrZero                                 ;8f5a cd ee 28  . . (                                                   (flow from: 8624 862e)  8626 call 86ae 
    jr nz,l8f67h               ;8f5d 20 08    .                    (flow from: 86b9 86bb 86bf 86c2)  8629 jr nz,8633 
    dec hl                     ;8f5f 2b  +                         (flow from: 8629)  862b dec hl 
    inc h                      ;8f60 24  $                         (flow from: 862b)  862c inc h 
    dec h                      ;8f61 25  %                         (flow from: 862c)  862d dec h 
    jr nz,l8f5ah               ;8f62 20 f6    .                    (flow from: 862d)  862e jr nz,8626 
    call v_sub_86a8h           ;8f64 cd e8 28  . . (               (flow from: 862e)  8630 call 86a8 
l8f67h:
; some key was pressed
    ld hl,00000h               ;8f67 21 00 00  ! . .               (flow from: 8629 86ad)  8633 ld hl,0000 
    ld (varcKeyboardScanningsCount+1),hl                       ;8f6a 22 55 28  " U (                                                   (flow from: 8633)  8636 ld (8615),hl 
l8f6dh:
v_sub_8639h:
    call getKeypressCodeOrZero                                 ;8f6d cd ee 28  . . (                                                   (flow from: 7cfa 861e 8636)  8639 call 86ae 
    jr z,l8f58h                ;8f70 28 e6  ( .                    (flow from: 86b9 86bb 86bf 86c2)  863c jr z,8624 
    ld b,000h                  ;8f72 06 00  . .                    (flow from: 863c)  863e ld b,00 
    ld c,e                     ;8f74 4b  K                         (flow from: 863e)  8640 ld c,e 
    ld a,e                     ;8f75 7b  {                         (flow from: 8640)  8641 ld a,e 
    ld (varcLastPressedKey+1),a                                ;8f76 32 c5 28  2 . (                                                   (flow from: 8641)  8642 ld (8685),a 
    ld hl,00204h               ;8f79 21 04 02  ! . .               (flow from: 8642)  8645 ld hl,0204 
    ld a,d                     ;8f7c 7a  z                         (flow from: 8645)  8648 ld a,d 
    cp 019h                    ;8f7d fe 19  . .                    (flow from: 8648)  8649 cp 19 
    jr z,l8ff7h                ;8f7f 28 76  ( v                    (flow from: 8649)  864b jr z,86c3 
    add hl,bc                  ;8f81 09  .                         (flow from: 864b)  864d add hl,bc 
    ld a,(hl)                  ;8f82 7e  ~                         (flow from: 864d)  864e ld a,(hl) 
    cp 020h                    ;8f83 fe 20  .                      (flow from: 864e)  864f cp 20 
    ld b,a                     ;8f85 47  G                         (flow from: 864f)  8651 ld b,a 
    jr c,l8fafh                ;8f86 38 27  8 '                    (flow from: 8651)  8652 jr c,867b 
    ld a,d                     ;8f88 7a  z                         (flow from: 8652)  8654 ld a,d 
    cp 028h                    ;8f89 fe 28  . (                    (flow from: 8654)  8655 cp 28 
    ld a,b                     ;8f8b 78  x                         (flow from: 8655)  8657 ld a,b 
    set 5,a                    ;8f8c cb ef  . .                    (flow from: 8657)  8658 set 5,a 
    jr nz,l8fa0h               ;8f8e 20 10    .                    (flow from: 8658)  865a jr nz,866c 
    call v_sub_8726h           ;8f90 cd 66 29  . f )               (flow from: 865a)  865c call 8726 
    jr nz,l8f99h               ;8f93 20 04    .                    (flow from: 872d)  865f jr nz,8665 
    sub 02dh                   ;8f95 d6 2d  . -                    (flow from: 865f)  8661 sub 2d 
    jr l8fafh                  ;8f97 18 16  . .                    (flow from: 8661)  8663 jr 867b 
l8f99h:
    call potencialCommandKeyPressed                            ;8f99 cd 6e 29  . n ) 
    jr nz,l8fa0h               ;8f9c 20 02    . 
    res 5,a                    ;8f9e cb af  . . 
l8fa0h:
    ld b,a                     ;8fa0 47  G                         (flow from: 865a)  866c ld b,a 
l08fa1h:
    ld a,000h                  ;8fa1 3e 00  > .                    (flow from: 866c)  866d ld a,f7 
    or a                       ;8fa3 b7  .                         (flow from: 866d)  866f or a 
    ld a,b                     ;8fa4 78  x                         (flow from: 866f)  8670 ld a,b 
    jr z,l8fafh                ;8fa5 28 08  ( .                    (flow from: 8670)  8671 jr z,867b 
    call potencialCommandKeyPressed                            ;8fa7 cd 6e 29  . n )                                                   (flow from: 8671)  8673 call 872e 
    jr nz,l8fafh               ;8faa 20 03    .                    (flow from: 873c)  8676 jr nz,867b 
    ld a,020h                  ;8fac 3e 20  >                      (flow from: 8676)  8678 ld a,20 
    xor b                      ;8fae a8  .                         (flow from: 8678)  867a xor b 
l8fafh:
    ld b,a                     ;8faf 47  G                         (flow from: 8652 8663 8671 867a 86de 86e5)  867b ld b,a 
    or a                       ;8fb0 b7  .                         (flow from: 867b)  867c or a 
    jr z,l8f6dh                ;8fb1 28 ba  ( .                    (flow from: 867c)  867d jr z,8639 
    cp 080h                    ;8fb3 fe 80  . .                    (flow from: 867d)  867f cp 80 
    jr z,l8f6dh                ;8fb5 28 b6  ( .                    (flow from: 867f)  8681 jr z,8639 
    ld b,a                     ;8fb7 47  G                         (flow from: 8681)  8683 ld b,a 
varcLastPressedKey:
    ld a,022h                  ;8fb8 3e 22  > "                    (flow from: 8683)  8684 ld a,22 
vr_l08686h:
    cp 022h                    ;8fba fe 22  . "                    (flow from: 8684)  8686 cp 00 
    ld (vr_l08686h+1),a        ;8fbc 32 c7 28  2 . (               (flow from: 8686)  8688 ld (8687),a 
    ld a,b                     ;8fbf 78  x                         (flow from: 8688)  868b ld a,b 
    jp z,varcKeyboardScanningsCount                            ;8fc0 ca 54 28  . T (                                                   (flow from: 868b)  868c jp z,8614 
l8fc3h:
    push af                    ;8fc3 f5  .                         (flow from: 868c)  868f push af 
    call keypressBeep          ;8fc4 cd 4f 29  . O )               (flow from: 868f)  8690 call 870f 
    pop af                     ;8fc7 f1  .                         (flow from: 8728)  8693 pop af 
    ld h,014h                  ;8fc8 26 14  & .                    (flow from: 8693)  8694 ld h,14 
l8fcah:
    dec hl                     ;8fca 2b  +                         (flow from: 8694 8699)  8696 dec hl 
    inc h                      ;8fcb 24  $                         (flow from: 8696)  8697 inc h 
    dec h                      ;8fcc 25  %                         (flow from: 8697)  8698 dec h 
    jr nz,l8fcah               ;8fcd 20 fb    .                    (flow from: 8698)  8699 jr nz,8696 
    bit 7,a                    ;8fcf cb 7f  .                     (flow from: 8699)  869b bit 7,a 
    ld (vr_l08620h+1),a        ;8fd1 32 61 28  2 a (               (flow from: 869b)  869d ld (8621),a 
    ret z                      ;8fd4 c8  .                         (flow from: 869d)  86a0 ret z 
    ld h,04eh                  ;8fd5 26 4e  & N                    (flow from: 86a0)  86a1 ld h,4e 
l8fd7h:
    dec hl                     ;8fd7 2b  +                         (flow from: 86a1 86a6)  86a3 dec hl 
    inc h                      ;8fd8 24  $                         (flow from: 86a3)  86a4 inc h 
    dec h                      ;8fd9 25  %                         (flow from: 86a4)  86a5 dec h 
    jr nz,l8fd7h               ;8fda 20 fb    .                    (flow from: 86a5 86a6)  86a6 jr nz,86a3 
v_sub_86a8h:
    ld hl,vr_l08686h+1         ;8fdc 21 c7 28  ! . (               (flow from: 8630 86a6)  86a8 ld hl,8687 
    ld (hl),000h               ;8fdf 36 00  6 .                    (flow from: 86a8)  86ab ld (hl),00 
    ret                        ;8fe1 c9  .                         (flow from: 86ab)  86ad ret 
getKeypressCodeOrZero:
; get code of a pressed key in E. A is 0 if no key or a special key (SS or CS) was pressed
    push hl                    ;8fe2 e5  .                         (flow from: 8626 8639)  86ae push hl 
    call ROM_KeyboardScanning  ;8fe3                               (flow from: 8626 86ae)  86af call 028e 
    pop hl                     ;8fe6 e1  .                         (flow from: 02b2 02b5 02b8 02be)  86b2 pop hl 
    jr z,l8febh                ;8fe7 28 02  ( .                    (flow from: 86b2)  86b3 jr z,86b7 
    xor a                      ;8fe9 af  . 
    ret                        ;8fea c9  . 
l8febh:
    ld a,e                     ;8feb 7b  {                         (flow from: 86b3 86jr)  86b7 ld a,e 
    inc e                      ;8fec 1c  .                         (flow from: 86b7)  86b8 inc e 
    ret z                      ;8fed c8  .                         (flow from: 86b8)  86b9 ret z 
    inc d                      ;8fee 14  .                         (flow from: 86b9)  86ba inc d 
    ret nz                     ;8fef c0  .                         (flow from: 86ba)  86bb ret nz 
; any key pressed
    ld a,e                     ;8ff0 7b  {                         (flow from: 86bb)  86bc ld a,e 
; SS pressed?
    sub 019h                   ;8ff1 d6 19  . .                    (flow from: 86bc)  86bd sub 19 
    ret z                      ;8ff3 c8  .                         (flow from: 86bd)  86bf ret z 
; CS pressed?
    sub 00fh                   ;8ff4 d6 0f  . .                    (flow from: 86bf)  86c0 sub 0f 
    ret                        ;8ff6 c9  .                         (flow from: 86c0)  86c2 ret 
l8ff7h:
; a key in combination with SS was pressed
    ex de,hl                   ;8ff7 eb  .                         (flow from: 864b)  86c3 ex de,hl 
    ld a,c                     ;8ff8 79  y                         (flow from: 86c3)  86c4 ld a,c 
; was SS+O pressed? ("         ;", start of a comment)
    cp 01bh                    ;8ff9 fe 1b  . .                    (flow from: 86c4)  86c5 cp 1b 
    jr z,standardKeyPlusSSPressed                              ;8ffb 28 17  ( .                                                        (flow from: 86c5)  86c7 jr z,86e0 
; are we on the beginning of the line so commands can be accecpted?
    ld hl,inputBufferStart     ;8ffd 21 3f 2d  ! ? -               (flow from: 86c7)  86c9 ld hl,8aff 
    ld a,(hl)                  ;9000 7e  ~                         (flow from: 86c9)  86cc ld a,(hl) 
    dec a                      ;9001 3d  =                         (flow from: 86cc)  86cd dec a 
    jr nz,standardKeyPlusSSPressed                             ;9002 20 10    .                                                        (flow from: 86cd)  86ce jr nz,86e0 
    inc hl                     ;9004 23  #                         (flow from: 86ce)  86d0 inc hl 
    or (hl)                    ;9005 b6  .                         (flow from: 86d0)  86d1 or (hl) 
    jr nz,standardKeyPlusSSPressed                             ;9006 20 0c    .                                                        (flow from: 86d1)  86d2 jr nz,86e0 
    ex de,hl                   ;9008 eb  .                         (flow from: 86d2)  86d4 ex de,hl 
    add hl,bc                  ;9009 09  .                         (flow from: 86d4)  86d5 add hl,bc 
    ld a,(hl)                  ;900a 7e  ~                         (flow from: 86d5)  86d6 ld a,(hl) 
    call potencialCommandKeyPressed                            ;900b cd 6e 29  . n )                                                   (flow from: 86d6)  86d7 call 872e 
    jr nz,standardKeyPlusSSPressed                             ;900e 20 04    .                                                        (flow from: 873c)  86da jr nz,86e0 
    set 7,a                    ;9010 cb ff  . .                    (flow from: 86da)  86dc set 7,a 
    jr l8fafh                  ;9012 18 9b  . .                    (flow from: 86dc)  86de jr 867b 
standardKeyPlusSSPressed:
    ld hl,varc9019+1           ;9014 21 26 29  ! & )               (flow from: 86ce)  86e0 ld hl,86e6 
    add hl,bc                  ;9017 09  .                         (flow from: 86e0)  86e3 add hl,bc 
    ld a,(hl)                  ;9018 7e  ~                         (flow from: 86e3)  86e4 ld a,(hl) 
varc9019:
    jr l8fafh                  ;9019 18 94  . .                    (flow from: 86e4)  86e5 jr 867b 
    ld hl,(05b5eh)             ;901b 2a 5e 5b  * ^ [ 
    ld h,025h                  ;901e 26 25  & % 
    ld a,07dh                  ;9020 3e 7d  > } 
    cpl                        ;9022 2f  / 
    inc l                      ;9023 2c  , 
    dec l                      ;9024 2d  - 
    ld e,l                     ;9025 5d  ] 
    daa                        ;9026 27  ' 
    inc h                      ;9027 24  $ 
    inc a                      ;9028 3c  < 
    ld a,e                     ;9029 7b  { 
    ccf                        ;902a 3f  ? 
    ld l,02bh                  ;902b 2e 2b  . + 
    ld a,a                     ;902d 7f   
    jr z,l9053h                ;902e 28 23  ( # 
    nop                        ;9030 00  . 
    ld e,h                     ;9031 5c  \ 
    ld h,b                     ;9032 60  ` 
    nop                        ;9033 00  . 
    dec a                      ;9034 3d  = 
    dec sp                     ;9035 3b                        ; 
    add hl,hl                  ;9036 29  ) 
    ld b,b                     ;9037 40  @ 
    inc d                      ;9038 14  . 
    ld a,h                     ;9039 7c  | 
    ld a,(00d20h)              ;903a 3a 20 0d  :   . 
    ld (0215fh),hl             ;903d 22 5f 21  " _ ! 
    dec d                      ;9040 15  . 
    ld a,(hl)                  ;9041 7e  ~ 
    nop                        ;9042 00  . 
keypressBeep:
    ld e,01eh                  ;9043 1e 1e  . .                    (flow from: 8690)  870f ld e,0a 
    jr l9049h                  ;9045 18 02  . .                    (flow from: 870f)  8711 jr 8715 
v_sub_8713h:
    ld e,000h                  ;9047 1e 00  . . 
l9049h:
    ld hl,0012ch               ;9049 21 2c 01  ! , .               (flow from: 8711)  8715 ld hl,012c 
    ld a,017h                  ;904c 3e 17  > .                    (flow from: 8715)  8718 ld a,07 
l904eh:
    ld b,e                     ;904e 43  C                         (flow from: 8718 8724)  871a ld b,e 
    xor 010h                   ;904f ee 10  . .                    (flow from: 871a)  871b xor 10 
l9051h:
    out (0feh),a               ;9051 d3 fe  . .                    (flow from: 871b 871f)  871d out (fe),a 
l9053h:
    djnz l9051h                ;9053 10 fc  . .                    (flow from: 871d)  871f djnz 871d 
    dec hl                     ;9055 2b  +                         (flow from: 871f)  8721 dec hl 
    inc h                      ;9056 24  $                         (flow from: 8721)  8722 inc h 
    dec h                      ;9057 25  %                         (flow from: 8722)  8723 dec h 
    jr nz,l904eh               ;9058 20 f4    .                    (flow from: 8723)  8724 jr nz,871a 
v_sub_8726h:
    cp 030h                    ;905a fe 30  . 0                    (flow from: 841f 865c 8724 87b2)  8726 cp 30 
    ret c                      ;905c d8  .                         (flow from: 8726)  8728 ret c 
    cp 039h                    ;905d fe 39  . 9                    (flow from: 8728)  8729 cp 39 
    ret nc                     ;905f d0  .                         (flow from: 8729)  872b ret nc 
    cp a                       ;9060 bf  .                         (flow from: 872b)  872c cp a 
    ret                        ;9061 c9  .                         (flow from: 872c)  872d ret 
potencialCommandKeyPressed:
; ignore if the command key is not in a-z or A-Z
    cp 041h                    ;9062 fe 41  . A                    (flow from: 82bd 83cd 8673 86d7 87bd)  872e cp 41 
    ret c                      ;9064 d8  .                         (flow from: 872e)  8730 ret c 
    cp 07ah                    ;9065 fe 7a  . z                    (flow from: 8730)  8731 cp 7a 
    ret nc                     ;9067 d0  .                         (flow from: 8731)  8733 ret nc 
    cp 05bh                    ;9068 fe 5b  . [                    (flow from: 8733)  8734 cp 5b 
    jr c,l906fh                ;906a 38 03  8 .                    (flow from: 8734)  8736 jr c,873b 
    cp 061h                    ;906c fe 61  . a                    (flow from: 8736)  8738 cp 61 
    ret c                      ;906e d8  .                         (flow from: 8738)  873a ret c 
l906fh:
    cp a                       ;906f bf  .                         (flow from: 8736 873a)  873b cp a 
    ret                        ;9070 c9  .                         (flow from: 873b)  873c ret 
v_sub_873dh:
    ld a,020h                  ;9071 3e 20  >                      (flow from: 8a12)  873d ld a,20 
    jr l9078h                  ;9073 18 03  . .                    (flow from: 873d)  873f jr 8744 
v_sub_8741h:
    ld a,(hl)                  ;9075 7e  ~                         (flow from: 8a1e)  8741 ld a,(hl) 
    and 07fh                   ;9076 e6 7f  .                     (flow from: 8741)  8742 and 7f 
l9078h:
v_sub_8744h:
    exx                        ;9078 d9  .                         (flow from: 7bff 82c4 873f 8742 8a06)  8744 exx 
    call displayCharacter      ;9079 cd bf 29  . . )               (flow from: 8744)  8745 call 877f 
    exx                        ;907c d9  .                         (flow from: 87a9)  8748 exx 
    ret                        ;907d c9  .                         (flow from: 8748)  8749 ret 
v_sub_874ah:
    cp 080h                    ;907e fe 80  . .                    (flow from: 85dc)  874a cp 80 
    jr c,l909bh                ;9080 38 19  8 .                    (flow from: 874a)  874c jr c,8767 
    push hl                    ;9082 e5  .                         (flow from: 874c)  874e push hl 
    push de                    ;9083 d5  .                         (flow from: 874e)  874f push de 
vr_l08750h:
    ld hl,08d6fh                                               ;9084 21 6f 8d  ! o .                                                   (flow from: 874f)  8750 ld hl,8d6f 
    ld d,000h                  ;9087 16 00  . .                    (flow from: 8750)  8753 ld d,00 
    ld e,a                     ;9089 5f  _                         (flow from: 8753)  8755 ld e,a 
    add hl,de                  ;908a 19  .                         (flow from: 8755)  8756 add hl,de 
    ld e,(hl)                  ;908b 5e  ^                         (flow from: 8756)  8757 ld e,(hl) 
    add hl,de                  ;908c 19  .                         (flow from: 8757)  8758 add hl,de 
l908dh:
    ld a,(hl)                  ;908d 7e  ~                         (flow from: 8758 8761)  8759 ld a,(hl) 
    inc hl                     ;908e 23  #                         (flow from: 8759)  875a inc hl 
    push af                    ;908f f5  .                         (flow from: 875a)  875b push af 
    call v_sub_8767h           ;9090 cd a7 29  . . )               (flow from: 875b)  875c call 8767 
    pop af                     ;9093 f1  .                         (flow from: 877e)  875f pop af 
    rlca                       ;9094 07  .                         (flow from: 875f)  8760 rlca 
    jr nc,l908dh               ;9095 30 f6  0 .                    (flow from: 8760)  8761 jr nc,8759 
    pop de                     ;9097 d1  .                         (flow from: 8761)  8763 pop de 
    pop hl                     ;9098 e1  .                         (flow from: 8763)  8764 pop hl 
v_sub_8765h:
    ld a,020h                  ;9099 3e 20  >                      (flow from: 8764)  8765 ld a,20 
l909bh:
v_sub_8767h:
    res 7,a                    ;909b cb bf  . .                    (flow from: 80d8 874c 875c 8765)  8767 res 7,a 
v_sub_8769h:
    exx                        ;909d d9  .                         (flow from: 7ca7 85ea 8767)  8769 exx 
    call displayCharacter      ;909e cd bf 29  . . )               (flow from: 8769)  876a call 877f 
    ld a,h                     ;90a1 7c  |                         (flow from: 87a9)  876d ld a,h 
    add a,00ah                 ;90a2 c6 0a  . .                    (flow from: 876d)  876e add a,0a 
    cp 05ah                    ;90a4 fe 5a  . Z                    (flow from: 876e)  8770 cp 5a 
    jr z,l90aeh                ;90a6 28 06  ( .                    (flow from: 8770)  8772 jr z,877a 
l90a8h:
    add a,007h                 ;90a8 c6 07  . .                    (flow from: 8772 8778)  8774 add a,07 
    cp 058h                    ;90aa fe 58  . X                    (flow from: 8774)  8776 cp 58 
    jr c,l90a8h                ;90ac 38 fa  8 .                    (flow from: 8776)  8778 jr c,8774 
l90aeh:
    ld h,a                     ;90ae 67  g                         (flow from: 8772 8778)  877a ld h,a 
vr_l0877bh:
    ld (hl),038h               ;90af 36 38  6 8                    (flow from: 877a)  877b ld (hl),38 
    exx                        ;90b1 d9  .                         (flow from: 877b)  877d exx 
    ret                        ;90b2 c9  .                         (flow from: 877d)  877e ret 
displayCharacter:
    add a,a                    ;90b3 87  .                         (flow from: 8745 876a)  877f add a,a 
    ld h,00fh                  ;90b4 26 0f  & .                    (flow from: 877f)  8780 ld h,0f 
    ld l,a                     ;90b6 6f  o                         (flow from: 8780)  8782 ld l,a 
    sbc a,a                    ;90b7 9f  .                         (flow from: 8782)  8783 sbc a,a 
    ld c,a                     ;90b8 4f  O                         (flow from: 8783)  8784 ld c,a 
    add hl,hl                  ;90b9 29  )                         (flow from: 8784)  8785 add hl,hl 
    add hl,hl                  ;90ba 29  )                         (flow from: 8785)  8786 add hl,hl 
vr_l08787h:
    ld de,04020h               ;90bb 11 20 40  .   @               (flow from: 8786)  8787 ld de,401f 
    push de                    ;90be d5  .                         (flow from: 8787)  878a push de 
    ld b,008h                  ;90bf 06 08  . .                    (flow from: 878a)  878b ld b,08 
l90c1h:
    ld a,(hl)                  ;90c1 7e  ~                         (flow from: 878b 8794)  878d ld a,(hl) 
    nop                        ;90c2 00  .                         (flow from: 878d)  878e nop 
    or (hl)                    ;90c3 b6  .                         (flow from: 878e)  878f or (hl) 
    xor c                      ;90c4 a9  .                         (flow from: 878f)  8790 xor c 
    ld (de),a                  ;90c5 12  .                         (flow from: 8790)  8791 ld (de),a 
    inc hl                     ;90c6 23  #                         (flow from: 8791)  8792 inc hl 
    inc d                      ;90c7 14  .                         (flow from: 8792)  8793 inc d 
    djnz l90c1h                ;90c8 10 f7  . .                    (flow from: 8790 8793)  8794 djnz 878d 
    pop hl                     ;90ca e1  .                         (flow from: 8794)  8796 pop hl 
    push hl                    ;90cb e5  .                         (flow from: 8796)  8797 push hl 
    inc l                      ;90cc 2c  ,                         (flow from: 8797)  8798 inc l 
    jr nz,l90d9h               ;90cd 20 0a    .                    (flow from: 8798)  8799 jr nz,87a5 
    ld a,h                     ;90cf 7c  |                         (flow from: 8799)  879b ld a,h 
    add a,008h                 ;90d0 c6 08  . .                    (flow from: 879b)  879c add a,08 
    cp 058h                    ;90d2 fe 58  . X                    (flow from: 879c)  879e cp 58 
    jr nz,l90d8h               ;90d4 20 02    .                    (flow from: 879e)  87a0 jr nz,87a4 
    ld a,040h                  ;90d6 3e 40  > @                    (flow from: 87a0)  87a2 ld a,40 
l90d8h:
    ld h,a                     ;90d8 67  g                         (flow from: 87a0 87a2)  87a4 ld h,a 
l90d9h:
    ld (vr_l08787h+1),hl       ;90d9 22 c8 29  " . )               (flow from: 8799 87a4)  87a5 ld (8788),hl 
    pop hl                     ;90dc e1  .                         (flow from: 87a5)  87a8 pop hl 
    ret                        ;90dd c9  .                         (flow from: 87a8)  87a9 ret 
v_sub_87aah:
    ld de,v_l8ac8h             ;90de 11 08 2d  . . -               (flow from: 8815)  87aa ld de,8ac8 
    ld b,000h                  ;90e1 06 00  . .                    (flow from: 87aa)  87ad ld b,00 
l90e3h:
    call atHLorNextIfOne       ;90e3 cd ee 27  . . '               (flow from: 87ad 87c9)  87af call 85ae 
    call v_sub_8726h           ;90e6 cd 66 29  . f )               (flow from: 85b1)  87b2 call 8726 
    jr z,l90f6h                ;90e9 28 0b  ( .                    (flow from: 8728 872b 872d)  87b5 jr z,87c2 
    res 5,a                    ;90eb cb af  . .                    (flow from: 87b5)  87b7 res 5,a 
    cp 05fh                    ;90ed fe 5f  . _                    (flow from: 87b7)  87b9 cp 5f 
    jr z,l90f6h                ;90ef 28 05  ( .                    (flow from: 87b9)  87bb jr z,87c2 
    call potencialCommandKeyPressed                            ;90f1 cd 6e 29  . n )                                                   (flow from: 87bb)  87bd call 872e 
    jr nz,l9102h               ;90f4 20 0c    .                    (flow from: 8730 873c)  87c0 jr nz,87ce 
l90f6h:
    ld (de),a                  ;90f6 12  .                         (flow from: 87b5 87c0)  87c2 ld (de),a 
    inc de                     ;90f7 13  .                         (flow from: 87c2)  87c3 inc de 
    inc hl                     ;90f8 23  #                         (flow from: 87c3)  87c4 inc hl 
    inc b                      ;90f9 04  .                         (flow from: 87c4)  87c5 inc b 
    ld a,b                     ;90fa 78  x                         (flow from: 87c5)  87c6 ld a,b 
    cp 009h                    ;90fb fe 09  . .                    (flow from: 87c6)  87c7 cp 09 
    jr c,l90e3h                ;90fd 38 e4  8 .                    (flow from: 87c7)  87c9 jr c,87af 
    jp syntaxError             ;90ff c3 c9 22  . . " 
l9102h:
    ld a,b                     ;9102 78  x                         (flow from: 87c0)  87ce ld a,b 
    ld (v_l8ac7h),a            ;9103 32 07 2d  2 . -               (flow from: 87ce)  87cf ld (8ac7),a 
    dec de                     ;9106 1b  .                         (flow from: 87cf)  87d2 dec de 
    ex de,hl                   ;9107 eb  .                         (flow from: 87d2)  87d3 ex de,hl 
    set 7,(hl)                 ;9108 cb fe  . .                    (flow from: 87d3)  87d4 set 7,(hl) 
vr_l087d6h:
        ld hl,l0a56ah                                          ;910a 21 76 3e  ! v >                                                   (flow from: 87d4)  87d6 ld hl,b3b2                                  (flow from: 87d4)  87d6 ld hl,b3b2 
    ld e,(hl)                  ;910d 5e  ^                         (flow from: 87d6)  87d9 ld e,(hl) 
    inc hl                     ;910e 23  #                         (flow from: 87d9)  87da inc hl 
    ld d,(hl)                  ;910f 56  V                         (flow from: 87da)  87db ld d,(hl) 
    inc hl                     ;9110 23  #                         (flow from: 87db)  87dc inc hl 
    push de                    ;9111 d5  .                         (flow from: 87dc)  87dd push de 
    ex de,hl                   ;9112 eb  .                         (flow from: 87dd)  87de ex de,hl 
    inc hl                     ;9113 23  #                         (flow from: 87de)  87df inc hl 
    add hl,hl                  ;9114 29  )                         (flow from: 87df)  87e0 add hl,hl 
    add hl,de                  ;9115 19  .                         (flow from: 87e0)  87e1 add hl,de 
    ld (vr_l087f6h+1),hl       ;9116 22 37 2a  " 7 *               (flow from: 87e1)  87e2 ld (87f7),hl 
    dec hl                     ;9119 2b  +                         (flow from: 87e2)  87e5 dec hl 
    dec hl                     ;911a 2b  +                         (flow from: 87e5)  87e6 dec hl 
    ld (vr_l08822h+1),hl       ;911b 22 63 2a  " c *               (flow from: 87e6)  87e7 ld (8823),hl 
    pop bc                     ;911e c1  .                         (flow from: 87e7)  87ea pop bc 
    jr l9143h                  ;911f 18 22  . "                    (flow from: 87ea)  87eb jr 880f 
l9121h:
    push bc                    ;9121 c5  .                         (flow from: 8811)  87ed push bc 
    dec hl                     ;9122 2b  +                         (flow from: 87ed)  87ee dec hl 
    ld a,(hl)                  ;9123 7e  ~                         (flow from: 87ee)  87ef ld a,(hl) 
    and 03fh                   ;9124 e6 3f  . ?                    (flow from: 87ef)  87f0 and 3f 
    ld d,a                     ;9126 57  W                         (flow from: 87f0)  87f2 ld d,a 
    dec hl                     ;9127 2b  +                         (flow from: 87f2)  87f3 dec hl 
    ld e,(hl)                  ;9128 5e  ^                         (flow from: 87f3)  87f4 ld e,(hl) 
    push hl                    ;9129 e5  .                         (flow from: 87f4)  87f5 push hl 
vr_l087f6h:
    ld hl,00000h               ;912a 21 00 00  ! . .               (flow from: 87f5)  87f6 ld hl,b4b0 
    add hl,de                  ;912d 19  .                         (flow from: 87f6)  87f9 add hl,de 
    ld de,v_l8ac7h             ;912e 11 07 2d  . . -               (flow from: 87f9)  87fa ld de,8ac7 
    ld a,(de)                  ;9131 1a  .                         (flow from: 87fa)  87fd ld a,(de) 
    ld b,a                     ;9132 47  G                         (flow from: 87fd)  87fe ld b,a 
    inc de                     ;9133 13  .                         (flow from: 87fe)  87ff inc de 
l9134h:
    ld a,(de)                  ;9134 1a  .                         (flow from: 87ff 8806)  8800 ld a,(de) 
    cp (hl)                    ;9135 be  .                         (flow from: 8800)  8801 cp (hl) 
    jr nz,l9140h               ;9136 20 08    .                    (flow from: 8801)  8802 jr nz,880c 
    inc hl                     ;9138 23  #                         (flow from: 8802)  8804 inc hl 
    inc de                     ;9139 13  .                         (flow from: 8804)  8805 inc de 
    djnz l9134h                ;913a 10 f8  . .                    (flow from: 8805)  8806 djnz 8800 
    pop af                     ;913c f1  .                         (flow from: 8806)  8808 pop af 
    pop hl                     ;913d e1  .                         (flow from: 8808)  8809 pop hl 
    xor a                      ;913e af  .                         (flow from: 8809)  880a xor a 
    ret                        ;913f c9  .                         (flow from: 880a)  880b ret 
l9140h:
    pop hl                     ;9140 e1  .                         (flow from: 8802)  880c pop hl 
    pop bc                     ;9141 c1  .                         (flow from: 880c)  880d pop bc 
    dec bc                     ;9142 0b  .                         (flow from: 880d)  880e dec bc 
l9143h:
    ld a,b                     ;9143 78  x                         (flow from: 87eb 880e)  880f ld a,b 
    or c                       ;9144 b1  .                         (flow from: 880f)  8810 or c 
    jr nz,l9121h               ;9145 20 da    .                    (flow from: 8810)  8811 jr nz,87ed 
    scf                        ;9147 37  7                         (flow from: 8811)  8813 scf 
    ret                        ;9148 c9  .                         (flow from: 8813)  8814 ret 
v_sub_8815h:
    call v_sub_87aah           ;9149 cd ea 29  . . )               (flow from: 830a 83d8)  8815 call 87aa 
    ret nc                     ;914c d0  .                         (flow from: 880b 8814)  8818 ret nc 
vr_l08819h:
        ld hl,l0a56ch                                          ;914d 21 78 3e  ! x >                                                   (flow from: 8818)  8819 ld hl,ac31                                  (flow from: 8818)  8819 ld hl,ac31 
    ld bc,0000ch               ;9150 01 0c 00  . . .               (flow from: 8819)  881c ld bc,000c 
    call v_sub_8068h           ;9153 cd a8 22  . . "               (flow from: 881c)  881f call 8068 
vr_l08822h:
    ld de,00000h               ;9156 11 00 00  . . .               (flow from: 8078)  8822 ld de,a837 
    xor a                      ;9159 af  .                         (flow from: 8822)  8825 xor a 
    sbc hl,de                  ;915a ed 52  . R                    (flow from: 8825)  8826 sbc hl,de 
    ld b,h                     ;915c 44  D                         (flow from: 8826)  8828 ld b,h 
    ld c,l                     ;915d 4d  M                         (flow from: 8828)  8829 ld c,l 
    ld h,d                     ;915e 62  b                         (flow from: 8829)  882a ld h,d 
    ld l,e                     ;915f 6b  k                         (flow from: 882a)  882b ld l,e 
    inc de                     ;9160 13  .                         (flow from: 882b)  882c inc de 
    inc de                     ;9161 13  .                         (flow from: 882c)  882d inc de 
    call v_l88ech              ;9162 cd 2c 2b  . , +               (flow from: 882d)  882e call 88ec 
    ld hl,vr_l08819h+1         ;9165 21 5a 2a  ! Z *               (flow from: 88ee 8901)  8831 ld hl,881a 
    call v_sub_8978h           ;9168 cd b8 2b  . . +               (flow from: 8831)  8834 call 8978 
    ld hl,(vr_l087d6h+1)       ;916b 2a 17 2a  * . *               (flow from: 8989)  8837 ld hl,(87d7) 
    ld c,(hl)                  ;916e 4e  N                         (flow from: 8837)  883a ld c,(hl) 
    inc hl                     ;916f 23  #                         (flow from: 883a)  883b inc hl 
    ld b,(hl)                  ;9170 46  F                         (flow from: 883b)  883c ld b,(hl) 
    ld hl,(vr_l087f6h+1)       ;9171 2a 37 2a  * 7 *               (flow from: 883c)  883d ld hl,(87f7) 
    jr l91a0h                  ;9174 18 2a  . *                    (flow from: 883d)  8840 jr 886c 
l9176h:
    pop hl                     ;9176 e1  .                         (flow from: 8854)  8842 pop hl 
    pop af                     ;9177 f1  .                         (flow from: 8842)  8843 pop af 
    jr l91a4h                  ;9178 18 2a  . *                    (flow from: 8843)  8844 jr 8870 
l917ah:
    push bc                    ;917a c5  .                         (flow from: 886e)  8846 push bc 
    push hl                    ;917b e5  .                         (flow from: 8846)  8847 push hl 
    inc hl                     ;917c 23  #                         (flow from: 8847)  8848 inc hl 
    ld de,v_l8ac8h             ;917d 11 08 2d  . . -               (flow from: 8848)  8849 ld de,8ac8 
l9180h:
    inc hl                     ;9180 23  #                         (flow from: 8849 8862)  884c inc hl 
    ld c,(hl)                  ;9181 4e  N                         (flow from: 884c)  884d ld c,(hl) 
    res 7,c                    ;9182 cb b9  . .                    (flow from: 884d)  884e res 7,c 
    ld a,(de)                  ;9184 1a  .                         (flow from: 884e)  8850 ld a,(de) 
    and 07fh                   ;9185 e6 7f  .                     (flow from: 8850)  8851 and 7f 
    cp c                       ;9187 b9  .                         (flow from: 8851)  8853 cp c 
    jr c,l9176h                ;9188 38 ec  8 .                    (flow from: 8853)  8854 jr c,8842 
    jr nz,l9198h               ;918a 20 0c    .                    (flow from: 8854)  8856 jr nz,8864 
    ld a,(de)                  ;918c 1a  .                         (flow from: 8856)  8858 ld a,(de) 
    and 080h                   ;918d e6 80  . .                    (flow from: 8858)  8859 and 80 
    jr nz,l9176h               ;918f 20 e5    .                    (flow from: 8859)  885b jr nz,8842 
    bit 7,(hl)                 ;9191 cb 7e  . ~                    (flow from: 885b)  885d bit 7,(hl) 
    jr nz,l9198h               ;9193 20 03    .                    (flow from: 885d)  885f jr nz,8864 
    inc de                     ;9195 13  .                         (flow from: 885f)  8861 inc de 
    jr l9180h                  ;9196 18 e8  . .                    (flow from: 8861)  8862 jr 884c 
l9198h:
    bit 7,(hl)                 ;9198 cb 7e  . ~                    (flow from: 8856 8867)  8864 bit 7,(hl) 
    inc hl                     ;919a 23  #                         (flow from: 8864)  8866 inc hl 
    jr z,l9198h                ;919b 28 fb  ( .                    (flow from: 8866)  8867 jr z,8864 
    pop af                     ;919d f1  .                         (flow from: 8867)  8869 pop af 
    pop bc                     ;919e c1  .                         (flow from: 8869)  886a pop bc 
    dec bc                     ;919f 0b  .                         (flow from: 886a)  886b dec bc 
l91a0h:
    ld a,b                     ;91a0 78  x                         (flow from: 8840 886b)  886c ld a,b 
    or c                       ;91a1 b1  .                         (flow from: 886c)  886d or c 
    jr nz,l917ah               ;91a2 20 d6    .                    (flow from: 886d)  886e jr nz,8846 
l91a4h:
    push hl                    ;91a4 e5  .                         (flow from: 8844 886e)  8870 push hl 
    ex de,hl                   ;91a5 eb  .                         (flow from: 8870)  8871 ex de,hl 
    ld hl,(vr_l08819h+1)       ;91a6 2a 5a 2a  * Z *               (flow from: 8871)  8872 ld hl,(881a) 
    xor a                      ;91a9 af  .                         (flow from: 8872)  8875 xor a 
    sbc hl,de                  ;91aa ed 52  . R                    (flow from: 8875)  8876 sbc hl,de 
    ex de,hl                   ;91ac eb  .                         (flow from: 8876)  8878 ex de,hl 
    push hl                    ;91ad e5  .                         (flow from: 8878)  8879 push hl 
    ld b,a                     ;91ae 47  G                         (flow from: 8879)  887a ld b,a 
    ld a,(v_l8ac7h)            ;91af 3a 07 2d  : . -               (flow from: 887a)  887b ld a,(8ac7) 
    add a,002h                 ;91b2 c6 02  . .                    (flow from: 887b)  887e add a,02 
    ld c,a                     ;91b4 4f  O                         (flow from: 887e)  8880 ld c,a 
    push bc                    ;91b5 c5  .                         (flow from: 8880)  8881 push bc 
    push hl                    ;91b6 e5  .                         (flow from: 8881)  8882 push hl 
    add hl,bc                  ;91b7 09  .                         (flow from: 8882)  8883 add hl,bc 
    ld b,d                     ;91b8 42  B                         (flow from: 8883)  8884 ld b,d 
    ld c,e                     ;91b9 4b  K                         (flow from: 8884)  8885 ld c,e 
    ex de,hl                   ;91ba eb  .                         (flow from: 8885)  8886 ex de,hl 
    pop hl                     ;91bb e1  .                         (flow from: 8886)  8887 pop hl 
    call v_l88ech              ;91bc cd 2c 2b  . , +               (flow from: 8887)  8888 call 88ec 
    pop bc                     ;91bf c1  .                         (flow from: 88ee 8901)  888b pop bc 
    ld hl,vr_l08819h+1         ;91c0 21 5a 2a  ! Z *               (flow from: 888b)  888c ld hl,881a 
    call v_sub_8980h           ;91c3 cd c0 2b  . . +               (flow from: 888c)  888f call 8980 
    pop de                     ;91c6 d1  .                         (flow from: 8989)  8892 pop de 
    ld hl,v_l8ac6h             ;91c7 21 06 2d  ! . -               (flow from: 8892)  8893 ld hl,8ac6 
    ld (hl),000h               ;91ca 36 00  6 .                    (flow from: 8893)  8896 ld (hl),00 
    push bc                    ;91cc c5  .                         (flow from: 8896)  8898 push bc 
    call v_l88ech              ;91cd cd 2c 2b  . , +               (flow from: 8898)  8899 call 88ec 
    ld hl,(vr_l087d6h+1)       ;91d0 2a 17 2a  * . *               (flow from: 8901)  889c ld hl,(87d7) 
    call v_sub_897dh           ;91d3 cd bd 2b  . . +               (flow from: 889c)  889f call 897d 
    pop bc                     ;91d6 c1  .                         (flow from: 8989)  88a2 pop bc 
    dec de                     ;91d7 1b  .                         (flow from: 88a2)  88a3 dec de 
    ex de,hl                   ;91d8 eb  .                         (flow from: 88a3)  88a4 ex de,hl 
    ex (sp),hl                 ;91d9 e3  .                         (flow from: 88a4)  88a5 ex (sp),hl 
    ld de,(vr_l087f6h+1)       ;91da ed 5b 37 2a  . [ 7 *          (flow from: 88a5)  88a6 ld de,(87f7) 
    xor a                      ;91de af  .                         (flow from: 88a6)  88aa xor a 
    sbc hl,de                  ;91df ed 52  . R                    (flow from: 88aa)  88ab sbc hl,de 
    ex de,hl                   ;91e1 eb  .                         (flow from: 88ab)  88ad ex de,hl 
    inc hl                     ;91e2 23  #                         (flow from: 88ad)  88ae inc hl 
    inc hl                     ;91e3 23  #                         (flow from: 88ae)  88af inc hl 
    ld (vr_l087f6h+1),hl       ;91e4 22 37 2a  " 7 *               (flow from: 88af)  88b0 ld (87f7),hl 
    dec hl                     ;91e7 2b  +                         (flow from: 88b0)  88b3 dec hl 
    dec hl                     ;91e8 2b  +                         (flow from: 88b3)  88b4 dec hl 
    ld ix,(vr_l087d6h+1)       ;91e9 dd 2a 17 2a  . * . *          (flow from: 88b4)  88b5 ld ix,(87d7) 
    ex (sp),hl                 ;91ed e3  .                         (flow from: 88b5)  88b9 ex (sp),hl 
    jr l9201h                  ;91ee 18 11  . .                    (flow from: 88b9)  88ba jr 88cd 
l91f0h:
    call v_sub_75dbh           ;91f0 cd 1b 18  . . .               (flow from: 88d0)  88bc call 75db 
    sbc hl,de                  ;91f3 ed 52  . R                    (flow from: 75e8)  88bf sbc hl,de 
    jr c,l91ffh                ;91f5 38 08  8 .                    (flow from: 88bf)  88c1 jr c,88cb 
    push de                    ;91f7 d5  .                         (flow from: 88c1)  88c3 push de 
    push ix                    ;91f8 dd e5  . .                    (flow from: 88c3)  88c4 push ix 
    pop hl                     ;91fa e1  .                         (flow from: 88c4)  88c6 pop hl 
    call v_sub_8980h           ;91fb cd c0 2b  . . +               (flow from: 88c6)  88c7 call 8980 
    pop de                     ;91fe d1  .                         (flow from: 8989)  88ca pop de 
l91ffh:
    ex (sp),hl                 ;91ff e3  .                         (flow from: 88c1 88ca)  88cb ex (sp),hl 
    dec hl                     ;9200 2b  +                         (flow from: 88cb)  88cc dec hl 
l9201h:
    ld a,h                     ;9201 7c  |                         (flow from: 88ba 88cc)  88cd ld a,h 
    or l                       ;9202 b5  .                         (flow from: 88cd)  88ce or l 
    ex (sp),hl                 ;9203 e3  .                         (flow from: 88ce)  88cf ex (sp),hl 
    jr nz,l91f0h               ;9204 20 ea    .                    (flow from: 88cf)  88d0 jr nz,88bc 
    pop hl                     ;9206 e1  .                         (flow from: 88d0)  88d2 pop hl 
    ld (ix+002h),e             ;9207 dd 73 02  . s .               (flow from: 88d2)  88d3 ld (ix+02),e 
    ld (ix+003h),d             ;920a dd 72 03  . r .               (flow from: 88d3)  88d6 ld (ix+03),d 
    ld hl,(vr_l087d6h+1)       ;920d 2a 17 2a  * . *               (flow from: 88d6)  88d9 ld hl,(87d7) 
    ld a,(hl)                  ;9210 7e  ~                         (flow from: 88d9)  88dc ld a,(hl) 
    inc hl                     ;9211 23  #                         (flow from: 88dc)  88dd inc hl 
    ld h,(hl)                  ;9212 66  f                         (flow from: 88dd)  88de ld h,(hl) 
    ld l,a                     ;9213 6f  o                         (flow from: 88de)  88df ld l,a 
    ret                        ;9214 c9  .                         (flow from: 88df)  88e0 ret 
v_sub_88e1h:
    push hl                    ;9215 e5  . 
    ld hl,(vr_l08819h+1)       ;9216 2a 5a 2a  * Z * 
    and a                      ;9219 a7  . 
    sbc hl,de                  ;921a ed 52  . R 
    ld b,h                     ;921c 44  D 
    ld c,l                     ;921d 4d  M 
    ex de,hl                   ;921e eb  . 
    pop de                     ;921f d1  . 
v_l88ech:
    ld a,b                     ;9220 78  x                         (flow from: 882e 8888 8899 89ae 8a83)  88ec ld a,b 
    or c                       ;9221 b1  .                         (flow from: 88ec)  88ed or c 
    ret z                      ;9222 c8  .                         (flow from: 88ed)  88ee ret z 
    push hl                    ;9223 e5  .                         (flow from: 88ee)  88ef push hl 
    xor a                      ;9224 af  .                         (flow from: 88ef)  88f0 xor a 
    sbc hl,de                  ;9225 ed 52  . R                    (flow from: 88f0)  88f1 sbc hl,de 
    pop hl                     ;9227 e1  .                         (flow from: 88f1)  88f3 pop hl 
    jr c,l922dh                ;9228 38 03  8 .                    (flow from: 88f3)  88f4 jr c,88f9 
    ldir                       ;922a ed b0  . .                    (flow from: 88f4 88f6)  88f6 ldir 
    ret                        ;922c c9  .                         (flow from: 88f6)  88f8 ret 
l922dh:
    add hl,bc                  ;922d 09  .                         (flow from: 88f4)  88f9 add hl,bc 
    dec hl                     ;922e 2b  +                         (flow from: 88f9)  88fa dec hl 
    ex de,hl                   ;922f eb  .                         (flow from: 88fa)  88fb ex de,hl 
    add hl,bc                  ;9230 09  .                         (flow from: 88fb)  88fc add hl,bc 
    dec hl                     ;9231 2b  +                         (flow from: 88fc)  88fd dec hl 
    ex de,hl                   ;9232 eb  .                         (flow from: 88fd)  88fe ex de,hl 
    lddr                       ;9233 ed b8  . .                    (flow from: 88fe 88ff)  88ff lddr 
    ret                        ;9235 c9  .                         (flow from: 88ff)  8901 ret 
v_sub_8902h:
    ld c,000h                  ;9236 0e 00  . .                    (flow from: 8a15)  8902 ld c,00 
    ld ix,v_l8ac7h             ;9238 dd 21 07 2d  . ! . -          (flow from: 8902)  8904 ld ix,8ac7 
v_sub_8908h:
l0923ch:
    ld a,000h                  ;923c 3e 00  > .                    (flow from: 8904)  8908 ld a,00 
    or a                       ;923e b7  .                         (flow from: 8908)  890a or a 
    jr z,l925ah                ;923f 28 19  ( .                    (flow from: 890a)  890b jr z,8926 
v_sub_890dh:
    ld (ix+000h),023h          ;9241 dd 36 00 23  . 6 . # 
    inc ix                     ;9245 dd 23  . # 
    ld de,01000h               ;9247 11 00 10  . . . 
    call v_sub_8941h           ;924a cd 81 2b  . . + 
    ld d,001h                  ;924d 16 01  . . 
    call v_sub_8941h           ;924f cd 81 2b  . . + 
v_sub_891eh:
    ld de,00010h               ;9252 11 10 00  . . . 
    call v_sub_8941h           ;9255 cd 81 2b  . . + 
    jr l9271h                  ;9258 18 17  . . 
l925ah:
v_sub_8926h:
    ld de,02710h               ;925a 11 10 27  . . '               (flow from: 890b)  8926 ld de,2710 
    call v_sub_8941h           ;925d cd 81 2b  . . +               (flow from: 8926)  8929 call 8941 
    ld de,003e8h               ;9260 11 e8 03  . . .               (flow from: 8961)  892c ld de,03e8 
    call v_sub_8941h           ;9263 cd 81 2b  . . +               (flow from: 892c)  892f call 8941 
v_sub_8932h:
    ld de,00064h               ;9266 11 64 00  . d .               (flow from: 8961)  8932 ld de,0064 
    call v_sub_8941h           ;9269 cd 81 2b  . . +               (flow from: 8932)  8935 call 8941 
    ld e,00ah                  ;926c 1e 0a  . .                    (flow from: 8961)  8938 ld e,0a 
    call v_sub_8941h           ;926e cd 81 2b  . . +               (flow from: 8938)  893a call 8941 
l9271h:
    ld e,001h                  ;9271 1e 01  . .                    (flow from: 8961)  893d ld e,01 
    ld c,000h                  ;9273 0e 00  . .                    (flow from: 893d)  893f ld c,00 
v_sub_8941h:
    ld a,0ffh                  ;9275 3e ff  > .                    (flow from: 8929 892f 8935 893a 893f)  8941 ld a,ff 
l9277h:
    inc a                      ;9277 3c  <                         (flow from: 8941 8947)  8943 inc a 
    and a                      ;9278 a7  .                         (flow from: 8943)  8944 and a 
    sbc hl,de                  ;9279 ed 52  . R                    (flow from: 8944)  8945 sbc hl,de 
    jr nc,l9277h               ;927b 30 fa  0 .                    (flow from: 8945)  8947 jr nc,8943 
    add hl,de                  ;927d 19  .                         (flow from: 8947)  8949 add hl,de 
    bit 0,c                    ;927e cb 41  . A                    (flow from: 8949)  894a bit 0,c 
    jr z,l9284h                ;9280 28 02  ( .                    (flow from: 894a)  894c jr z,8950 
    or a                       ;9282 b7  .                         (flow (mon) from: 894c)  894e or a 
    ret z                      ;9283 c8  .                         (flow (mon) from: 894e)  894f ret z 
l9284h:
    res 0,c                    ;9284 cb 81  . .                    (flow from: 894c)  8950 res 0,c 
    add a,030h                 ;9286 c6 30  . 0                    (flow from: 8950)  8952 add a,30 
    cp 03ah                    ;9288 fe 3a  . :                    (flow from: 8952)  8954 cp 3a 
    jr c,l928eh                ;928a 38 02  8 .                    (flow from: 8954)  8956 jr c,895a 
    add a,007h                 ;928c c6 07  . . 
l928eh:
    call v_sub_8963h           ;928e cd a3 2b  . . +               (flow from: 8956)  895a call 8963 
    ld (ix+000h),000h          ;9291 dd 36 00 00  . 6 . .          (flow from: 8968)  895d ld (ix+00),00 
    ret                        ;9295 c9  .                         (flow from: 895d)  8961 ret 
v_sub_8962h:
    inc b                      ;9296 04  .                         (flow from: 848f)  8962 inc b 
v_sub_8963h:
    ld (ix+000h),a             ;9297 dd 77 00  . w .               (flow from: 895a 8962)  8963 ld (ix+00),a 
    inc ix                     ;929a dd 23  . #                    (flow from: 8963)  8966 inc ix 
    ret                        ;929c c9  .                         (flow from: 8966)  8968 ret 
v_sub_8969h:
    push hl                    ;929d e5  .                         (flow from: 8a96 8a9c)  8969 push hl 
    ld a,(hl)                  ;929e 7e  ~                         (flow from: 8969)  896a ld a,(hl) 
    inc hl                     ;929f 23  #                         (flow from: 896a)  896b inc hl 
    ld h,(hl)                  ;92a0 66  f                         (flow from: 896b)  896c ld h,(hl) 
    ld l,a                     ;92a1 6f  o                         (flow from: 896c)  896d ld l,a 
vr_l0896eh:
    ld de,v_l9c3eh             ;92a2 11 7e 3e  . ~ >               (flow from: 896d)  896e ld de,b252 
    and a                      ;92a5 a7  .                         (flow from: 896e)  8971 and a 
    sbc hl,de                  ;92a6 ed 52  . R                    (flow from: 8971)  8972 sbc hl,de 
    pop hl                     ;92a8 e1  .                         (flow from: 8972)  8974 pop hl 
    ret c                      ;92a9 d8  .                         (flow from: 8974)  8975 ret c 
    jr l92b4h                  ;92aa 18 08  . . 
v_sub_8978h:
    ld bc,00002h               ;92ac 01 02 00  . . .               (flow from: 8834)  8978 ld bc,0002 
    jr l92b4h                  ;92af 18 03  . .                    (flow from: 8978)  897b jr 8980 
v_sub_897dh:
    ld bc,00001h               ;92b1 01 01 00  . . .               (flow from: 889f)  897d ld bc,0001 
l92b4h:
v_sub_8980h:
    ld e,(hl)                  ;92b4 5e  ^                         (flow from: 888f 88c7 897b 897d 8a8a 8a90)  8980 ld e,(hl) 
    inc hl                     ;92b5 23  #                         (flow from: 8980)  8981 inc hl 
    ld d,(hl)                  ;92b6 56  V                         (flow from: 8981)  8982 ld d,(hl) 
    ex de,hl                   ;92b7 eb  .                         (flow from: 8982)  8983 ex de,hl 
    add hl,bc                  ;92b8 09  .                         (flow from: 8983)  8984 add hl,bc 
l92b9h:
    ex de,hl                   ;92b9 eb  .                         (flow from: 8984 89d8)  8985 ex de,hl 
    ld (hl),d                  ;92ba 72  r                         (flow from: 8985)  8986 ld (hl),d 
    dec hl                     ;92bb 2b  +                         (flow from: 8986)  8987 dec hl 
    ld (hl),e                  ;92bc 73  s                         (flow from: 8987)  8988 ld (hl),e 
    ret                        ;92bd c9  .                         (flow from: 8988)  8989 ret 
v_sub_898ah:
    push hl                    ;92be e5  .                         (flow from: 7e2c)  898a push hl 
    ld (vr_l089deh+1),hl       ;92bf 22 1f 2c  " . ,               (flow from: 898a)  898b ld (89df),hl 
    push bc                    ;92c2 c5  .                         (flow from: 898b)  898e push bc 
l92c3h:
    call v_sub_8248h           ;92c3 cd 88 24  . . $               (flow from: 898e)  898f call 8248 
    dec bc                     ;92c6 0b  .                         (flow from: 825a)  8992 dec bc 
    ld a,b                     ;92c7 78  x                         (flow from: 8992)  8993 ld a,b 
    or c                       ;92c8 b1  .                         (flow from: 8993)  8994 or c 
    jr nz,l92c3h               ;92c9 20 f8    .                    (flow from: 8994)  8995 jr nz,898f 
    pop bc                     ;92cb c1  .                         (flow from: 8995)  8997 pop bc 
    pop de                     ;92cc d1  .                         (flow from: 8997)  8998 pop de 
    push hl                    ;92cd e5  .                         (flow from: 8998)  8999 push hl 
    and a                      ;92ce a7  .                         (flow from: 8999)  899a and a 
    sbc hl,de                  ;92cf ed 52  . R                    (flow from: 899a)  899b sbc hl,de 
    ld b,h                     ;92d1 44  D                         (flow from: 899b)  899d ld b,h 
    ld c,l                     ;92d2 4d  M                         (flow from: 899d)  899e ld c,l 
    pop hl                     ;92d3 e1  .                         (flow from: 899e)  899f pop hl 
    push bc                    ;92d4 c5  .                         (flow from: 899f)  89a0 push bc 
    push de                    ;92d5 d5  .                         (flow from: 89a0)  89a1 push de 
    push hl                    ;92d6 e5  .                         (flow from: 89a1)  89a2 push hl 
    ld hl,(vr_l08819h+1)       ;92d7 2a 5a 2a  * Z *               (flow from: 89a2)  89a3 ld hl,(881a) 
    and a                      ;92da a7  .                         (flow from: 89a3)  89a6 and a 
    pop de                     ;92db d1  .                         (flow from: 89a6)  89a7 pop de 
    sbc hl,de                  ;92dc ed 52  . R                    (flow from: 89a7)  89a8 sbc hl,de 
    ex de,hl                   ;92de eb  .                         (flow from: 89a8)  89aa ex de,hl 
    ld b,d                     ;92df 42  B                         (flow from: 89aa)  89ab ld b,d 
    ld c,e                     ;92e0 4b  K                         (flow from: 89ab)  89ac ld c,e 
    pop de                     ;92e1 d1  .                         (flow from: 89ac)  89ad pop de 
    call v_l88ech              ;92e2 cd 2c 2b  . , +               (flow from: 89ad)  89ae call 88ec 
    pop bc                     ;92e5 c1  .                         (flow from: 88f8)  89b1 pop bc 
    push bc                    ;92e6 c5  .                         (flow from: 89b1)  89b2 push bc 
l92e7h:
    xor a                      ;92e7 af  .                         (flow from: 89b2 89b9)  89b3 xor a 
    ld (de),a                  ;92e8 12  .                         (flow from: 89b3)  89b4 ld (de),a 
    inc de                     ;92e9 13  .                         (flow from: 89b4)  89b5 inc de 
    dec bc                     ;92ea 0b  .                         (flow from: 89b5)  89b6 dec bc 
    ld a,b                     ;92eb 78  x                         (flow from: 89b6)  89b7 ld a,b 
    or c                       ;92ec b1  .                         (flow from: 89b7)  89b8 or c 
    jr nz,l92e7h               ;92ed 20 f8    .                    (flow from: 89b8)  89b9 jr nz,89b3 
    pop bc                     ;92ef c1  .                         (flow from: 89b9)  89bb pop bc 
    ld hl,vr_l080e7h+1         ;92f0 21 28 23  ! ( #               (flow from: 89bb)  89bc ld hl,80e8 
    call v_sub_89dah           ;92f3 cd 1a 2c  . . ,               (flow from: 89bc)  89bf call 89da 
    ld hl,vr_l080eah+1         ;92f6 21 2b 23  ! + #               (flow from: 89e5)  89c2 ld hl,80eb 
    call v_sub_89dah           ;92f9 cd 1a 2c  . . ,               (flow from: 89c2)  89c5 call 89da 
    ld hl,vr_l08819h+1         ;92fc 21 5a 2a  ! Z *               (flow from: 89e5)  89c8 ld hl,881a 
    call v_sub_89d1h           ;92ff cd 11 2c  . . ,               (flow from: 89c8)  89cb call 89d1 
    ld hl,vr_l087d6h+1         ;9302 21 17 2a  ! . *               (flow from: 8989)  89ce ld hl,87d7 
l9305h:
v_sub_89d1h:
    ld e,(hl)                  ;9305 5e  ^                         (flow from: 89cb 89ce)  89d1 ld e,(hl) 
    inc hl                     ;9306 23  #                         (flow from: 89d1)  89d2 inc hl 
    ld d,(hl)                  ;9307 56  V                         (flow from: 89d2)  89d3 ld d,(hl) 
    ex de,hl                   ;9308 eb  .                         (flow from: 89d3)  89d4 ex de,hl 
    and a                      ;9309 a7  .                         (flow from: 89d4)  89d5 and a 
    sbc hl,bc                  ;930a ed 42  . B                    (flow from: 89d5)  89d6 sbc hl,bc 
    jr l92b9h                  ;930c 18 ab  . .                    (flow from: 89d6)  89d8 jr 8985 
v_sub_89dah:
    push hl                    ;930e e5  .                         (flow from: 89bf 89c5)  89da push hl 
    ld e,(hl)                  ;930f 5e  ^                         (flow from: 89da)  89db ld e,(hl) 
    inc hl                     ;9310 23  #                         (flow from: 89db)  89dc inc hl 
    ld d,(hl)                  ;9311 56  V                         (flow from: 89dc)  89dd ld d,(hl) 
vr_l089deh:
     ld hl,09c28h                                              ;9312 21 28 9c  ! ( .                                                   (flow from: 89dd)  89de ld hl,b24c 
    and a                      ;9315 a7  .                         (flow from: 89de)  89e1 and a 
    sbc hl,de                  ;9316 ed 52  . R                    (flow from: 89e1)  89e2 sbc hl,de 
    pop hl                     ;9318 e1  .                         (flow from: 89e2)  89e4 pop hl 
    ret nc                     ;9319 d0  .                         (flow from: 89e4)  89e5 ret nc 
    jr l9305h                  ;931a 18 e9  . . 
v_sub_89e8h:
    xor a                      ;931c af  .                         (flow from: 7716)  89e8 xor a 
    ld (vr_l07e1eh+1),a        ;931d 32 5f 20  2 _                 (flow from: 89e8)  89e9 ld (7e1f),a 
    call v_sub_76b6h           ;9320 cd f6 18  . . .               (flow from: 89e9)  89ec call 76b6 
    call v_l77d1h              ;9323 cd 11 1a  . . .               (flow from: 76cd)  89ef call 77d1 
v_sub_89f2h:
    ld a,00ah                  ;9326 3e 0a  > .                    (flow from: 7804)  89f2 ld a,0a 
v_l89f4h:
    call v_sub_80b4h           ;9328 cd f4 22  . . "               (flow from: 7cda 7d00 7d33 89f2)  89f4 call 80b4 
    ld a,013h                  ;932b 3e 13  > .                    (flow from: 80e0)  89f7 ld a,13 
    ld (vr_l08787h+1),a        ;932d 32 c8 29  2 . )               (flow from: 89f7)  89f9 ld (8788),a 
    ld a,(vr_l07e1eh+1)        ;9330 3a 5f 20  : _                 (flow from: 89f9)  89fc ld a,(7e1f) 
    or a                       ;9333 b7  .                         (flow from: 89fc)  89ff or a 
    ld a,04fh                  ;9334 3e 4f  > O                    (flow from: 89ff)  8a00 ld a,4f 
    jr nz,l933ah               ;9336 20 02    .                    (flow from: 8a00)  8a02 jr nz,8a06 
    ld a,049h                  ;9338 3e 49  > I                    (flow from: 8a02)  8a04 ld a,49 
l933ah:
    call v_sub_8744h           ;933a cd 84 29  . . )               (flow from: 8a02 8a04)  8a06 call 8744 
    ld hl,(vr_l08819h+1)       ;933d 2a 5a 2a  * Z *               (flow from: 8749)  8a09 ld hl,(881a) 
    call v_sub_8a12h           ;9340 cd 52 2c  . R ,               (flow from: 8a09)  8a0c call 8a12                                   (flow (mon) from: 02b0)  0ret z 
    ld hl,(vr_l07945h+1)       ;9343 2a 86 1b  * . .               (flow from: 8a1d)  8a0f ld hl,(7946) 
v_sub_8a12h:
    call v_sub_873dh           ;9346 cd 7d 29  . } )               (flow from: 8a0c 8a0f)  8a12 call 873d 
    call v_sub_8902h           ;9349 cd 42 2b  . B +               (flow from: 8749)  8a15 call 8902 
    ld hl,v_l8ac7h             ;934c 21 07 2d  ! . -               (flow from: 8961)  8a18 ld hl,8ac7 
l934fh:
v_sub_8a1bh:
    ld a,(hl)                  ;934f 7e  ~                         (flow from: 8a18 8a22)  8a1b ld a,(hl) 
    or a                       ;9350 b7  .                         (flow from: 8a1b)  8a1c or a 
    ret z                      ;9351 c8  .                         (flow from: 8a1c)  8a1d ret z 
    call v_sub_8741h           ;9352 cd 81 29  . . )               (flow from: 8a1d)  8a1e call 8741 
    inc hl                     ;9355 23  #                         (flow from: 8749)  8a21 inc hl 
    jr l934fh                  ;9356 18 f7  . .                    (flow from: 8a21)  8a22 jr 8a1b 
v_sub_8a24h:
    push hl                    ;9358 e5  .                         (flow from: 7c6f)  8a24 push hl 
    push de                    ;9359 d5  .                         (flow from: 8a24)  8a25 push de 
        ld de,l0a55ch                                          ;935a 11 68 3e  . h >                                                   (flow from: 8a25)  8a26 ld de,9c28                                  (flow from: 8a25)  8a26 ld de,9c28 
    and a                      ;935d a7  .                         (flow from: 8a26)  8a29 and a 
    sbc hl,de                  ;935e ed 52  . R                    (flow from: 8a29)  8a2a sbc hl,de 
    pop de                     ;9360 d1  .                         (flow from: 8a2a)  8a2c pop de 
    pop hl                     ;9361 e1  .                         (flow from: 8a2c)  8a2d pop hl 
    ret                        ;9362 c9  .                         (flow from: 8a2d)  8a2e ret 
v_sub_8a2fh:
    push hl                    ;9363 e5  .                         (flow from: 7c78)  8a2f push hl 
    push de                    ;9364 d5  .                         (flow from: 8a2f)  8a30 push de 
    ld de,0000ch               ;9365 11 0c 00  . . .               (flow from: 8a30)  8a31 ld de,000c 
    add hl,de                  ;9368 19  .                         (flow from: 8a31)  8a34 add hl,de 
    ld de,(vr_l087d6h+1)       ;9369 ed 5b 17 2a  . [ . *          (flow from: 8a34)  8a35 ld de,(87d7) 
    and a                      ;936d a7  .                         (flow from: 8a35)  8a39 and a 
    sbc hl,de                  ;936e ed 52  . R                    (flow from: 8a39)  8a3a sbc hl,de 
    pop de                     ;9370 d1  .                         (flow from: 8a3a)  8a3c pop de 
    pop hl                     ;9371 e1  .                         (flow from: 8a3c)  8a3d pop hl 
    ret                        ;9372 c9  .                         (flow from: 8a3d)  8a3e ret 
invokeCopy:
    call v_sub_080e7h          ;9373 cd 27 23  . ' # 
    push hl                    ;9376 e5  . 
    push de                    ;9377 d5  . 
    ld bc,(v_sub_826ch+1)      ;9378 ed 4b ad 24  . K . $ 
    and a                      ;937c a7  . 
    sbc hl,bc                  ;937d ed 42  . B 
    jr nc,l9386h               ;937f 30 05  0 . 
    ex de,hl                   ;9381 eb  . 
    ccf                        ;9382 3f  ? 
    sbc hl,bc                  ;9383 ed 42  . B 
    ccf                        ;9385 3f  ? 
l9386h:
    pop hl                     ;9386 e1  . 
    pop de                     ;9387 d1  . 
    ret c                      ;9388 d8  . 
    push bc                    ;9389 c5  . 
    call v_sub_8248h           ;938a cd 88 24  . . $ 
    sbc hl,de                  ;938d ed 52  . R 
    ld b,h                     ;938f 44  D 
    ld c,l                     ;9390 4d  M 
    pop hl                     ;9391 e1  . 
    ld (vr_l0896eh+1),hl       ;9392 22 af 2b  " . + 
    ex de,hl                   ;9395 eb  . 
    push hl                    ;9396 e5  . 
    sbc hl,de                  ;9397 ed 52  . R 
    pop hl                     ;9399 e1  . 
    jr c,l939dh                ;939a 38 01  8 . 
    add hl,bc                  ;939c 09  . 
l939dh:
    ex de,hl                   ;939d eb  . 
    jr l93a2h                  ;939e 18 02  . . 
v_sub_8a6ch:
    ld b,000h                  ;93a0 06 00  . .                    (flow from: 7e17)  8a6c ld b,00 
l93a2h:
    push de                    ;93a2 d5  .                         (flow from: 8a6c)  8a6e push de 
    push hl                    ;93a3 e5  .                         (flow from: 8a6e)  8a6f push hl 
    call v_sub_8068h           ;93a4 cd a8 22  . . "               (flow from: 8a6f)  8a70 call 8068 
    push bc                    ;93a7 c5  .                         (flow from: 8078)  8a73 push bc 
    push bc                    ;93a8 c5  .                         (flow from: 8a73)  8a74 push bc 
    ex de,hl                   ;93a9 eb  .                         (flow from: 8a74)  8a75 ex de,hl 
    ld hl,(vr_l08819h+1)       ;93aa 2a 5a 2a  * Z *               (flow from: 8a75)  8a76 ld hl,(881a) 
    and a                      ;93ad a7  .                         (flow from: 8a76)  8a79 and a 
    sbc hl,de                  ;93ae ed 52  . R                    (flow from: 8a79)  8a7a sbc hl,de 
    ex (sp),hl                 ;93b0 e3  .                         (flow from: 8a7a)  8a7c ex (sp),hl 
    ex de,hl                   ;93b1 eb  .                         (flow from: 8a7c)  8a7d ex de,hl 
    push hl                    ;93b2 e5  .                         (flow from: 8a7d)  8a7e push hl 
    add hl,bc                  ;93b3 09  .                         (flow from: 8a7e)  8a7f add hl,bc 
    pop de                     ;93b4 d1  .                         (flow from: 8a7f)  8a80 pop de 
    ex de,hl                   ;93b5 eb  .                         (flow from: 8a80)  8a81 ex de,hl 
    pop bc                     ;93b6 c1  .                         (flow from: 8a81)  8a82 pop bc 
    call v_l88ech              ;93b7 cd 2c 2b  . , +               (flow from: 8a82)  8a83 call 88ec 
    pop bc                     ;93ba c1  .                         (flow from: 8901)  8a86 pop bc 
    ld hl,vr_l08819h+1         ;93bb 21 5a 2a  ! Z *               (flow from: 8a86)  8a87 ld hl,881a 
    call v_sub_8980h           ;93be cd c0 2b  . . +               (flow from: 8a87)  8a8a call 8980 
    ld hl,vr_l087d6h+1         ;93c1 21 17 2a  ! . *               (flow from: 8989)  8a8d ld hl,87d7                                  (flow (mon) from: 8697)  8inc h 
    call v_sub_8980h           ;93c4 cd c0 2b  . . +               (flow from: 8a8d)  8a90 call 8980 
    ld hl,vr_l080e7h+1         ;93c7 21 28 23  ! ( #               (flow from: 8989)  8a93 ld hl,80e8 
    call v_sub_8969h           ;93ca cd a9 2b  . . +               (flow from: 8a93)  8a96 call 8969 
    ld hl,vr_l080eah+1         ;93cd 21 2b 23  ! + #               (flow from: 8975)  8a99 ld hl,80eb 
    call v_sub_8969h           ;93d0 cd a9 2b  . . +               (flow from: 8a99)  8a9c call 8969 
    pop de                     ;93d3 d1  .                         (flow from: 8975)  8a9f pop de 
    pop hl                     ;93d4 e1  .                         (flow from: 8a9f)  8aa0 pop hl 
    ldir
    ret
                               ;defb 0edh,0b0h,0c9h

; BLOCK 'data_93d8' (start 0x93d8 end 0xa574)
v_l8aa4h:
    defb 000h                  ;93d8 00  . 
v_l8aa5h:
    defb 020h                  ;93d9 20    
    defb 020h                  ;93da 20    
v_l8aa7h:
    defb 020h                  ;93db 20    
l093dch:
    defb 020h                  ;93dc 20    
    defb 020h                  ;93dd 20    
    defb 020h                  ;93de 20    
    defb 020h                  ;93df 20    
    defb 020h                  ;93e0 20    
v_l8aadh:
    defb 020h                  ;93e1 20    
    defb 001h                  ;93e2 01  . 
    defb 000h                  ;93e3 00  . 
    defb 000h                  ;93e4 00  . 
    defb 000h                  ;93e5 00  . 
    defb 000h                  ;93e6 00  . 
    defb 000h                  ;93e7 00  . 
    defb 000h                  ;93e8 00  . 
    defb 000h                  ;93e9 00  . 
    defb 000h                  ;93ea 00  . 
    defb 000h                  ;93eb 00  . 
    defb 000h                  ;93ec 00  . 
    defb 000h                  ;93ed 00  . 
    defb 000h                  ;93ee 00  . 
    defb 000h                  ;93ef 00  . 
    defb 000h                  ;93f0 00  . 
    defb 000h                  ;93f1 00  . 
    defb 000h                  ;93f2 00  . 
    defb 000h                  ;93f3 00  . 
    defb 000h                  ;93f4 00  . 
    defb 000h                  ;93f5 00  . 
    defb 000h                  ;93f6 00  . 
    defb 000h                  ;93f7 00  . 
    defb 000h                  ;93f8 00  . 
    defb 000h                  ;93f9 00  . 
v_l8ac6h:
    defb 000h                  ;93fa 00  . 
v_l8ac7h:
    defb 036h                  ;93fb 36  6 
v_l8ac8h:
    defb 035h                  ;93fc 35  5 
    defb 035h                  ;93fd 35  5 
    defb 033h                  ;93fe 33  3 
    defb 035h                  ;93ff 35  5 
    defb 000h                  ;9400 00  . 
    defb 000h                  ;9401 00  . 
    defb 000h                  ;9402 00  . 
    defb 000h                  ;9403 00  . 
    defb 000h                  ;9404 00  . 
v_l8ad1h:
    defb 000h                  ;9405 00  . 
v_l8ad2h:
    defb 000h                  ;9406 00  . 
    defb 000h                  ;9407 00  . 
    defb 000h                  ;9408 00  . 
    defb 000h                  ;9409 00  . 
    defb 000h                  ;940a 00  . 
    defb 000h                  ;940b 00  . 
    defb 000h                  ;940c 00  . 
    defb 000h                  ;940d 00  . 
    defb 000h                  ;940e 00  . 
    defb 000h                  ;940f 00  . 
v_l8adch:
    defb 000h                  ;9410 00  . 
    defb 000h                  ;9411 00  . 
v_l8adeh:
    defb 000h                  ;9412 00  . 
    defb 000h                  ;9413 00  . 
    defb 000h                  ;9414 00  . 
    defb 000h                  ;9415 00  . 
    defb 000h                  ;9416 00  . 
    defb 000h                  ;9417 00  . 
v_l8ae4h:
    defb 000h                  ;9418 00  . 
varLowercasedOperands:
    defs 19                    ;9419 (8ae5)
v_l8af8h:
    defb 000h                  ;942c 00  . 
v_l8af9h:
    defb 000h                  ;942d 00  . 
    defb 000h                  ;942e 00  . 
    defb 000h                  ;942f 00  . 
    defb 000h                  ;9430 00  . 
    defb 000h                  ;9431 00  . 
v_l8afeh:
    defb 080h                  ;9432 80  . 
inputBufferStart:              ;9433 (8aff)
    defb 0c2h                  ;9433 c2  . 
    defb 001h                  ;9434 01  . 
    defb 000h                  ;9435 00  . 
    defb 000h                  ;9436 00  . 
    defb 000h                  ;9437 00  . 
    defb 000h                  ;9438 00  . 
    defb 000h                  ;9439 00  . 
    defb 000h                  ;943a 00  . 
    defb 000h                  ;943b 00  . 
    defb 000h                  ;943c 00  . 
    defb 000h                  ;943d 00  . 
    defb 000h                  ;943e 00  . 
v_l8b0bh:
    defb 000h                  ;943f 00  . 
    defb 000h                  ;9440 00  . 
v_l8b0dh:
    defb 000h                  ;9441 00  . 
    defb 000h                  ;9442 00  . 
v_l8b0fh:
    defb 000h                  ;9443 00  . 
    defb 000h                  ;9444 00  . 
    defb 000h                  ;9445 00  . 
    defb 000h                  ;9446 00  . 
    defb 000h                  ;9447 00  . 
    defb 000h                  ;9448 00  . 
    defb 000h                  ;9449 00  . 
    defb 000h                  ;944a 00  . 
    defb 000h                  ;944b 00  . 
    defb 000h                  ;944c 00  . 
    defb 000h                  ;944d 00  . 
    defb 000h                  ;944e 00  . 
    defb 000h                  ;944f 00  . 
    defb 000h                  ;9450 00  . 
v_l8b1dh:
    defb 000h                  ;9451 00  . 
    defb 000h                  ;9452 00  . 
    defb 000h                  ;9453 00  . 
    defb 000h                  ;9454 00  . 
v_l8b21h:
    defb 000h                  ;9455 00  . 
v_l8b22h:
    defb 000h                  ;9456 00  . 
v_l8b23h:
    defb 000h                  ;9457 00  . 
v_l8b24h:
    defb 000h                  ;9458 00  . 
    defb 000h                  ;9459 00  . 
v_l8b26h:
    defb 000h                  ;945a 00  . 
    defb 000h                  ;945b 00  . 
v_l8b28h:
    defb 000h                  ;945c 00  . 
    defb 000h                  ;945d 00  . 
    defb 000h                  ;945e 00  . 
    defb 000h                  ;945f 00  . 
    defb 000h                  ;9460 00  . 
    defb 000h                  ;9461 00  . 
    defb 000h                  ;9462 00  . 
    defb 000h                  ;9463 00  . 
    defb 000h                  ;9464 00  . 
    defb 000h                  ;9465 00  . 
    defb 000h                  ;9466 00  . 
    defb 000h                  ;9467 00  . 
    defb 000h                  ;9468 00  . 
    defb 000h                  ;9469 00  . 
    defb 000h                  ;946a 00  . 
    defb 000h                  ;946b 00  . 
    defb 000h                  ;946c 00  . 
    defb 000h                  ;946d 00  . 
    defb 000h                  ;946e 00  . 
    defb 000h                  ;946f 00  . 
    defb 000h                  ;9470 00  . 
    defb 000h                  ;9471 00  . 
    defb 000h                  ;9472 00  . 
    defb 000h                  ;9473 00  . 
    defb 000h                  ;9474 00  . 
    defb 000h                  ;9475 00  . 
    defb 000h                  ;9476 00  . 
    defb 000h                  ;9477 00  . 
    defb 000h                  ;9478 00  . 
    defb 000h                  ;9479 00  . 
    defb 000h                  ;947a 00  . 
    defb 000h                  ;947b 00  . 
    defb 000h                  ;947c 00  . 
    defb 000h                  ;947d 00  . 
    defb 000h                  ;947e 00  . 
    defb 000h                  ;947f 00  . 
    defb 000h                  ;9480 00  . 
    defb 000h                  ;9481 00  . 
    defb 000h                  ;9482 00  . 
    defb 000h                  ;9483 00  . 
    defb 000h                  ;9484 00  . 
    defb 000h                  ;9485 00  . 
    defb 000h                  ;9486 00  . 
    defb 000h                  ;9487 00  . 
    defb 000h                  ;9488 00  . 
    defb 000h                  ;9489 00  . 
    defb 000h                  ;948a 00  . 
    defb 000h                  ;948b 00  . 
    defb 000h                  ;948c 00  . 
    defb 000h                  ;948d 00  . 
    defb 002h                  ;948e 02  . 
    defb 0c2h                  ;948f c2  . 
    defb 001h                  ;9490 01  . 
    defb 000h                  ;9491 00  . 
    defb 000h                  ;9492 00  . 
    defb 000h                  ;9493 00  . 
    defb 000h                  ;9494 00  . 
    defb 000h                  ;9495 00  . 
    defb 000h                  ;9496 00  . 
    defb 000h                  ;9497 00  . 
    defb 000h                  ;9498 00  . 
    defb 000h                  ;9499 00  . 
    defb 000h                  ;949a 00  . 
    defb 000h                  ;949b 00  . 
    defb 000h                  ;949c 00  . 
    defb 000h                  ;949d 00  . 
    defb 000h                  ;949e 00  . 
    defb 000h                  ;949f 00  . 
    defb 000h                  ;94a0 00  . 
    defb 000h                  ;94a1 00  . 
    defb 000h                  ;94a2 00  . 
    defb 000h                  ;94a3 00  . 
    defb 000h                  ;94a4 00  . 
    defb 000h                  ;94a5 00  . 
    defb 000h                  ;94a6 00  . 
    defb 000h                  ;94a7 00  . 
    defb 000h                  ;94a8 00  . 
    defb 000h                  ;94a9 00  . 
    defb 000h                  ;94aa 00  . 
    defb 000h                  ;94ab 00  . 
    defb 000h                  ;94ac 00  . 
    defb 000h                  ;94ad 00  . 
    defb 000h                  ;94ae 00  . 
    defb 000h                  ;94af 00  . 
    defb 000h                  ;94b0 00  . 
    defb 000h                  ;94b1 00  . 
    defb 000h                  ;94b2 00  . 
    defb 000h                  ;94b3 00  . 
    defb 000h                  ;94b4 00  . 
    defb 000h                  ;94b5 00  . 
    defb 000h                  ;94b6 00  . 
    defb 09fh                  ;94b7 9f  . 
    defb 050h                  ;94b8 50  P 
    defb 06dh                  ;94b9 6d  m 
    defb 087h                  ;94ba 87  . 
    defb 02eh                  ;94bb 2e  . 
    defb 06fh                  ;94bc 6f  o 
    defb 023h                  ;94bd 23  # 
    defb 06eh                  ;94be 6e  n 
    defb 02ah                  ;94bf 2a  * 
    defb 05dh                  ;94c0 5d  ] 
    defb 0d0h                  ;94c1 d0  . 
    defb 001h                  ;94c2 01  . 
    defb 09ch                  ;94c3 9c  . 
    defb 05eh                  ;94c4 5e  ^ 
    defb 0e4h                  ;94c5 e4  . 
    defb 050h                  ;94c6 50  P 
    defb 06dh                  ;94c7 6d  m 
    defb 087h                  ;94c8 87  . 
    defb 019h                  ;94c9 19  . 
    defb 040h                  ;94ca 40  @ 
    defb 01fh                  ;94cb 1f  . 
    defb 040h                  ;94cc 40  @ 
    defb 048h                  ;94cd 48  H 
    defb 087h                  ;94ce 87  . 
    defb 021h                  ;94cf 21  ! 
    defb 08ah                  ;94d0 8a  . 
    defb 003h                  ;94d1 03  . 
    defb 07dh                  ;94d2 7d  } 
    defb 0cfh                  ;94d3 cf  . 
    defb 07ch                  ;94d4 7c  | 
l094d5h:
    defb 080h                  ;94d5 80  . 
    defb "Bad mnemoni",0xe3    ;"c"+0x80                       ;94d6
    defb "Bad operan",0xe4     ;"d"+0x80                       ;94e2
    defb "Big numbe",0xf2      ;"r"+0x80                       ;94ed
    defb "Syntax horro",0xf2   ;"r"+0x80                       ;94f7
    defb "Bad strin",0xe7      ;"g"+0x80                       ;9504
    defb "Bad instructio",0xee                                 ;"n"+0x80                       ;950e
    defb "Memory ful",0xec     ;"l"+0x80                       ;951d
    defb "Bad PUT (ORG",0xa9   ;")"+0x80                       ;9528
    defb " unknow",0xee        ;"n"+0x80                       ;9535
    defb "Wait pleas",0xe5     ;"e"+0x80                       ;953d
    defb "Assembly complet",0xe5                               ;"e"+0x80                       ;9548
    defb "Start tap",0xe5      ;"e"+0x80                       ;9559
    defb "Tape erro",0xf2      ;"r"+0x80                       ;9563
    defb "Any ke",0xf9         ;"y"+0x80                       ;956d
    defb "(C) 90 UNIVERSU",0xcd                                ;"M"+0x80                       ;9574
    defb "Source ERRO",0xd2    ;"R"+0x80                       ;9584
    defb "Found",0xba          ;":"+0x80                       ;9590
    defb "Already define",0xe4                                 ;"d"+0x80                       ;9596
    defb "ENT ",0xbf           ;"?"+0x80                       ;95a5
v_l8c76h:
    defb 000h                  ;95aa 00  . 
    defb 04dh                  ;95ab 4d  M 
    defb 04dh                  ;95ac 4d  M 
    defb 04eh                  ;95ad 4e  N 
    defb 04fh                  ;95ae 4f  O 
    defb 050h                  ;95af 50  P 
    defb 051h                  ;95b0 51  Q 
    defb 052h                  ;95b1 52  R 
    defb 053h                  ;95b2 53  S 
    defb 054h                  ;95b3 54  T 
    defb 055h                  ;95b4 55  U 
    defb 056h                  ;95b5 56  V 
    defb 057h                  ;95b6 57  W 
    defb 058h                  ;95b7 58  X 
    defb 059h                  ;95b8 59  Y 
    defb 05bh                  ;95b9 5b  [ 
    defb 05dh                  ;95ba 5d  ] 
    defb 05fh                  ;95bb 5f  _ 
    defb 061h                  ;95bc 61  a 
    defb 063h                  ;95bd 63  c 
    defb 065h                  ;95be 65  e 
    defb 067h                  ;95bf 67  g 
    defb 069h                  ;95c0 69  i 
    defb 06bh                  ;95c1 6b  k 
    defb 06dh                  ;95c2 6d  m 
    defb 06fh                  ;95c3 6f  o 
    defb 071h                  ;95c4 71  q 
    defb 073h                  ;95c5 73  s 
    defb 075h                  ;95c6 75  u 
    defb 077h                  ;95c7 77  w 
    defb 079h                  ;95c8 79  y 
    defb 07bh                  ;95c9 7b  { 
    defb 07dh                  ;95ca 7d  } 
    defb 07fh                  ;95cb 7f   
    defb 081h                  ;95cc 81  . 
    defb 083h                  ;95cd 83  . 
    defb 085h                  ;95ce 85  . 
    defb 087h                  ;95cf 87  . 
    defb 089h                  ;95d0 89  . 
    defb 08bh                  ;95d1 8b  . 
    defb 08dh                  ;95d2 8d  . 
    defb 08fh                  ;95d3 8f  . 
    defb 091h                  ;95d4 91  . 
    defb 093h                  ;95d5 93  . 
    defb 095h                  ;95d6 95  . 
    defb 097h                  ;95d7 97  . 
    defb 099h                  ;95d8 99  . 
    defb 09bh                  ;95d9 9b  . 
    defb 09dh                  ;95da 9d  . 
    defb 09fh                  ;95db 9f  . 
    defb 0a1h                  ;95dc a1  . 
    defb 0a3h                  ;95dd a3  . 
    defb 0a5h                  ;95de a5  . 
    defb 0a7h                  ;95df a7  . 
    defb 0a9h                  ;95e0 a9  . 
    defb 0abh                  ;95e1 ab  . 
    defb 0aeh                  ;95e2 ae  . 
    defb 0b1h                  ;95e3 b1  . 
    defb 0b4h                  ;95e4 b4  . 
    defb 0b7h                  ;95e5 b7  . 
    defb 0bah                  ;95e6 ba  . 
    defb 0bdh                  ;95e7 bd  . 
    defb 0c0h                  ;95e8 c0  . 
    defb 0c3h                  ;95e9 c3  . 
    defb 0c6h                  ;95ea c6  . 
    defb 0c9h                  ;95eb c9  . 
    defb 0cch                  ;95ec cc  . 
    defb 0cfh                  ;95ed cf  . 
    defb 0d2h                  ;95ee d2  . 
    defb 0d5h                  ;95ef d5  . 
    defb 0d8h                  ;95f0 d8  . 
    defb 0dbh                  ;95f1 db  . 
    defb 0deh                  ;95f2 de  . 
    defb 0e1h                  ;95f3 e1  . 
    defb 0e4h                  ;95f4 e4  . 
    defb 0e7h                  ;95f5 e7  . 
    defb 0eah                  ;95f6 ea  . 
    defb 0edh                  ;95f7 ed  . 
    defb 0bbh                  ;95f8 bb  . 
l095f9h:
    defb "c", 0xF0             ;cp                             ;95f9
    defb "d", 0xE9             ;di
    defb "e", 0xE9             ;ei
    defb "e", 0xF8             ;ex
    defb "i", 0xED             ;im
    defb "i", 0xEE             ;in
    defb "j", 0xF0             ;jp
    defb "j", 0xF2             ;jr
    defb "l", 0xE4             ;ld
    defb "o", 0xF2             ;or
    defb "r", 0xEC             ;rl
    defb "r", 0xF2             ;rr
    defb "ad", 0xE3            ;adc
    defb "ad", 0xE4            ;add
    defb "an", 0xE4            ;and
    defb "bi", 0xF4            ;bit
    defb "cc", 0xE6            ;ccf
    defb "cp", 0xE4            ;cpd
    defb "cp", 0xE9            ;cpi
    defb "cp", 0xEC            ;cpl
    defb "da", 0xE1            ;daa
    defb "de", 0xE3            ;dec
    defb "en", 0xF4            ;ent
    defb "eq", 0xF5            ;equ
    defb "ex", 0xF8            ;exx
    defb "in", 0xE3            ;inc
    defb "in", 0xE4            ;ind
    defb "in", 0xE9            ;ini
    defb "ld", 0xE4            ;ldd
    defb "ld", 0xE9            ;ldi
    defb "ne", 0xE7            ;neg
    defb "no", 0xF0            ;nop
    defb "or", 0xE7            ;org
    defb "ou", 0xF4            ;out
    defb "po", 0xF0            ;pop
    defb "pu", 0xF4            ;put
    defb "re", 0xF3            ;res
    defb "re", 0xF4            ;ret
    defb "rl", 0xE1            ;rla
    defb "rl", 0xE3            ;rlc
    defb "rl", 0xE4            ;rld
    defb "rr", 0xE1            ;rra
    defb "rr", 0xE3            ;rrc
    defb "rr", 0xE4            ;rrd
    defb "rs", 0xF4            ;rst
    defb "sb", 0xE3            ;sbc
    defb "sc", 0xE6            ;scf
    defb "se", 0xF4            ;set
    defb "sl", 0xE1            ;sla
    defb "sr", 0xE1            ;sra
    defb "sr", 0xEC            ;srl
    defb "su", 0xE2            ;sub
    defb "xo", 0xF2            ;xor
    defb "cal", 0xEC           ;call
    defb "cpd", 0xF2           ;cpdr
    defb "cpi", 0xF2           ;cpir
    defb "def", 0xE2           ;defb
    defb "def", 0xED           ;defm
    defb "def", 0xF3           ;defs
    defb "def", 0xF7           ;defw
    defb "djn", 0xFA           ;djnz
    defb "hal", 0xF4           ;halt
    defb "ind", 0xF2           ;indr
    defb "ini", 0xF2           ;inir
    defb "ldd", 0xF2           ;lddr
    defb "ldi", 0xF2           ;ldir
    defb "otd", 0xF2           ;otdr
    defb "oti", 0xF2           ;otir
    defb "out", 0xE4           ;outd
    defb "out", 0xE9           ;outi
    defb "pus", 0xE8           ;push
    defb "ret", 0xE9           ;reti
    defb "ret", 0xEE           ;retn
    defb "rlc", 0xE1           ;rlca
    defb "rrc", 0xE1           ;rrca
    defb "sli", 0xE1           ;slia
v_l8db4h:
    defb 020h                  ;96e8 20    
    defb 02bh                  ;96e9 2b  + 
    defb 02bh                  ;96ea 2b  + 
    defb 02bh                  ;96eb 2b  + 
    defb 02bh                  ;96ec 2b  + 
    defb 02bh                  ;96ed 2b  + 
    defb 02bh                  ;96ee 2b  + 
    defb 02bh                  ;96ef 2b  + 
    defb 02bh                  ;96f0 2b  + 
    defb 02bh                  ;96f1 2b  + 
    defb 02bh                  ;96f2 2b  + 
    defb 02bh                  ;96f3 2b  + 
    defb 02bh                  ;96f4 2b  + 
    defb 02bh                  ;96f5 2b  + 
    defb 02bh                  ;96f6 2b  + 
    defb 02bh                  ;96f7 2b  + 
    defb 02bh                  ;96f8 2b  + 
    defb 02bh                  ;96f9 2b  + 
    defb 02bh                  ;96fa 2b  + 
    defb 02bh                  ;96fb 2b  + 
    defb 02bh                  ;96fc 2b  + 
    defb 02bh                  ;96fd 2b  + 
    defb 02ch                  ;96fe 2c  , 
    defb 02dh                  ;96ff 2d  - 
    defb 02eh                  ;9700 2e  . 
    defb 02fh                  ;9701 2f  / 
    defb 030h                  ;9702 30  0 
    defb 031h                  ;9703 31  1 
    defb 032h                  ;9704 32  2 
    defb 033h                  ;9705 33  3 
    defb 034h                  ;9706 34  4 
    defb 035h                  ;9707 35  5 
    defb 036h                  ;9708 36  6 
    defb 037h                  ;9709 37  7 
    defb 038h                  ;970a 38  8 
    defb 039h                  ;970b 39  9 
    defb 03ah                  ;970c 3a  : 
    defb 03ch                  ;970d 3c  < 
    defb 03eh                  ;970e 3e  > 
    defb 041h                  ;970f 41  A 
    defb 044h                  ;9710 44  D 
    defb 047h                  ;9711 47  G 
    defb 04ah                  ;9712 4a  J 
    defb 04dh                  ;9713 4d  M 

;table of operands
    
operandsTable:  
    defb "", 0xB0              ;0                              ;9714
    defb "", 0xB1              ;1
    defb "", 0xB2              ;2
    defb "", 0xB3              ;3
    defb "", 0xB4              ;4
    defb "", 0xB5              ;5
    defb "", 0xB6              ;6
    defb "", 0xB7              ;7
    defb "", 0xE1              ;a
    defb "", 0xE2              ;b
    defb "", 0xE3              ;c
    defb "", 0xE4              ;d
    defb "", 0xE5              ;e
    defb "", 0xE8              ;h
    defb "", 0xE9              ;i
    defb "", 0xEC              ;l
    defb "", 0xED              ;m
    defb "", 0xF0              ;p
    defb "", 0xF2              ;r
    defb "", 0xFA              ;z
    defb "a", 0xE6             ;af                             ;9728
    defb "b", 0xE3             ;bc
    defb "d", 0xE5             ;de
    defb "h", 0xEC             ;hl
    defb "h", 0xF8             ;hx
    defb "h", 0xF9             ;hy
    defb "i", 0xF8             ;ix
    defb "i", 0xF9             ;iy
    defb "l", 0xF8             ;lx
    defb "l", 0xF9             ;ly
    defb "n", 0xE3             ;nc
    defb "n", 0xFA             ;nz
    defb "p", 0xE5             ;pe
    defb "p", 0xEF             ;po
    defb "s", 0xF0             ;sp
    defb "(c", 0xA9            ;(c)
    defb "af", 0xA7            ;af'
    defb "(bc", 0xA9           ;(bc)
    defb "(de", 0xA9           ;(de)
    defb "(hl", 0xA9           ;(hl)
    defb "(ix", 0xA9           ;(ix)
    defb "(iy", 0xA9           ;(iy)
    defb "(sp", 0xA9           ;(sp)
    
operationLabels:
    defb operationLabelAssembly - operationLabels
    defb operationLabelBasic - operationLabels - 1
    defb operationLabelCopy - operationLabels - 2
    defb operationLabelDelete - operationLabels - 3
;   defb operationLabelFind - operationLabels - 4
;   defb operationLabelGens - operationLabels - 5
;   defb operationLabelLoad - operationLabels - 6
;   defb operationLabelMonitor - operationLabels - 7
;   defb operationLabelNew - operationLabels - 8
;   defb operationLabelPrint - operationLabels - 9
;   defb operationLabelQuit - operationLabels - 10
;   defb operationLabelRun - operationLabels - 11
;   defb operationLabelSave - operationLabels - 12
;   defb operationLabelTable - operationLabels - 13
;   defb operationLabelUTop - operationLabels - 14
;   defb operationLabelVerify - operationLabels - 15
;   defb operationLabelClear - operationLabels - 16
;   defb operationLabelReplace - operationLabels - 17

    defb 027h                  ;9768 27  ' 
    defb 02ch                  ;9769 2c  , 
    defb 02fh                  ;976a 2f  / 
    defb 02eh                  ;976b 2e  . 
    defb 02dh                  ;976c 2d  - 
    defb 02ch                  ;976d 2c  , 
    defb 02bh                  ;976e 2b  + 
    defb 02eh                  ;976f 2e  . 
    defb 031h                  ;9770 31  1 
    defb 037h                  ;9771 37  7 
    defb 036h                  ;9772 36  6 
    defb 038h                  ;9773 38  8 
    defb 03ch                  ;9774 3c  < 
    defb 03fh                  ;9775 3f  ? 
    defb 041h                  ;9776 41  A 
    defb 044h                  ;9777 44  D 
    defb 048h                  ;9778 48  H 
    defb 04ch                  ;9779 4c  L 
    defb 04bh                  ;977a 4b  K 
    defb 050h                  ;977b 50  P 
    defb 04fh                  ;977c 4f  O 
    defb 053h                  ;977d 53  S 
operationLabelAssembly:
l0977eh:
    defb "ASSEMBL", 0xD9       ;977e                           ;ASSEMBLY
operationLabelBasic:
    defb "BASI", 0xC3          ;BASIC
operationLabelCopy:
    defb "COP", 0xD9           ;COPY
operationLabelDelete:
    defb "DELET", 0xC5         ;DELETE
operationLabelFind:
    defb "FIN", 0xC4           ;FIND
operationLabelGens:
    defb "GEN", 0xD3           ;GENS
operationLabelLoad:
    defb "LOA", 0xC4           ;LOAD
operationLabelMonitor:
    defb "MONITO", 0xD2        ;MONITOR
operationLabelNew:
    defb "NE", 0xD7            ;NEW
operationLabelPrint:
    defb "PRIN", 0xD4          ;PRINT
operationLabelQuit:
    defb "QUI", 0xD4           ;QUIT
operationLabelRun:
    defb "RU", 0xCE            ;RUN
operationLabelSave:
    defb "SAV", 0xC5           ;SAVE
operationLabelTable:
    defb "TABL", 0xC5          ;TABLE
operationLabelUTop:
    defb "U-TO", 0xD0          ;U-TOP
operationLabelVerify:
    defb "VERIF", 0xD9         ;VERIFY
operationLabelClear:
    defb "CLEA", 0xD2          ;CLEAR
operationLabelReplace:
    defb "REPLAC", 0xC5        ;REPLACE


include "instructionTable.asm"

    defb 000h                  ;a542 00  . 
    defb 030h                  ;a543 30  0 
    defb 000h                  ;a544 00  . 
    defb 030h                  ;a545 30  0 
    defb 000h                  ;a546 00  . 
    defb 030h                  ;a547 30  0 
    defb 000h                  ;a548 00  . 
    defb 030h                  ;a549 30  0 
    defb 000h                  ;a54a 00  . 
    defb 030h                  ;a54b 30  0 
    defb 000h                  ;a54c 00  . 
    defb 030h                  ;a54d 30  0 
    defb 000h                  ;a54e 00  . 
    defb 030h                  ;a54f 30  0 
    defb 000h                  ;a550 00  . 
    defb 030h                  ;a551 30  0 
    defb 000h                  ;a552 00  . 
    defb 030h                  ;a553 30  0 
    defb 000h                  ;a554 00  . 
    defb 030h                  ;a555 30  0 
    defb 000h                  ;a556 00  . 
    defb 030h                  ;a557 30  0 
    defb 000h                  ;a558 00  . 
    defb 030h                  ;a559 30  0 
l0a55ah:
    defb 000h                  ;a55a 00  . 
    defb 030h                  ;a55b 30  0 
l0a55ch:
    defb 000h                  ;a55c 00  . 
    defb 030h                  ;a55d 30  0 
    defb 000h                  ;a55e 00  . 
    defb 030h                  ;a55f 30  0 
    defb 000h                  ;a560 00  . 
    defb 030h                  ;a561 30  0 
    defb 000h                  ;a562 00  . 
    defb 030h                  ;a563 30  0 
    defb 000h                  ;a564 00  . 
    defb 030h                  ;a565 30  0 
    defb 000h                  ;a566 00  . 
    defb 030h                  ;a567 30  0 
    defb 000h                  ;a568 00  . 
    defb 030h                  ;a569 30  0 
l0a56ah:
    defb 000h                  ;a56a 00  . 
    defb 000h                  ;a56b 00  . 
l0a56ch:
    defb 000h                  ;a56c 00  . 
    defb 000h                  ;a56d 00  . 
    defb 000h                  ;a56e 00  . 
    defb 000h                  ;a56f 00  . 
    defb 000h                  ;a570 00  . 
    defb 000h                  ;a571 00  . 
v_l9c3eh:
    defb 000h                  ;a572 00  . 
    defb 000h                  ;a573 00  . 
