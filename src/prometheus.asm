; z80dasm 1.1.3
; command line: z80dasm -a -t -l -g 24000 -b blocks.txt prometheus.bin

    org 05dc0h


BA:      equ 24000
BA1:     equ 24000+2356

; ROM routines

ROM_KeyboardScanning:    equ 0028eh

; system variables

SYSVAR_ERR_SP:       equ 05c3dh                                ; Address of item on machine stack to use as error return


start:
    di                         ;5dc0 f3  .                         (flow from: 34bb 52ad)   5dc0 jp 7cc9 
    ld hl,04000h               ;5dc1 21 00 40  ! . @               (flow from: 5dc0)   5dc1 ld hl,4000 
    ld de,04001h               ;5dc4 11 01 40  . . @               (flow from: 5dc1)   5dc4 ld de,4001 
    ld bc,00fffh               ;5dc7 01 ff 0f  . . .               (flow from: 5dc4)   5dc7 ld bc,0fff 
    ld (hl),l                  ;5dca 75  u                         (flow from: 5dc7)   5dca ld (hl),l 
    ldir                       ;5dcb ed b0  . .                    (flow from: 5dca 5dcb)   5dcb ldir 
    call 00052h                ;5dcd cd 52 00  . R .               (flow from: 5dcb)   5dcd call 0052 
    dec sp                     ;5dd0 3b                        ;   (flow from: 0052)   5dd0 dec sp 
    dec sp                     ;5dd1 3b                        ;   (flow from: 5dd0)   5dd1 dec sp 
    pop bc                     ;5dd2 c1  .                         (flow from: 5dd1)   5dd2 pop bc 
    ld hl,0fff0h               ;5dd3 21 f0 ff  ! . .               (flow from: 5dd2)   5dd3 ld hl,fff0 
    add hl,bc                  ;5dd6 09  .                         (flow from: 5dd3)   5dd6 add hl,bc 
    ld sp,04020h               ;5dd7 31 20 40  1   @               (flow from: 5dd6)   5dd7 ld sp,4020 
    push hl                    ;5dda e5  .                         (flow from: 5dd7)   5dda push hl 
    ld hl,00017h               ;5ddb 21 17 00  ! . .               (flow from: 5dda)   5ddb ld hl,0017 
    add hl,bc                  ;5dde 09  .                         (flow from: 5ddb)   5dde add hl,bc 
    ld bc,007cdh               ;5ddf 01 cd 07  . . .               (flow from: 5dde)   5ddf ld bc,07cd 
    ldir                       ;5de2 ed b0  . .                    (flow from: 5ddf 5de2)   5de2 ldir 
    jp 05000h                  ;5de4 c3 00 50  . . P               (flow from: 5de2)   5de4 jp 5000 
    ld de,04026h               ;5de7 11 26 40  . & @               (ghost flow from: 5de4)   5000 ld de,4026 
    call 05342h                ;5dea cd 42 53  . B S               (ghost flow from: 5000)   5003 call 5342 
    ld e,046h                  ;5ded 1e 46  . F                    (ghost flow from: 5352)   5006 ld e,46 
    call 05342h                ;5def cd 42 53  . B S               (ghost flow from: 5006)   5008 call 5342 
    ex (sp),hl                 ;5df2 e3  .                         (ghost flow from: 5352)   500b ex (sp),hl 
    ld bc,050a1h               ;5df3 01 a1 50  . . P               (ghost flow from: 500b)   500c ld bc,50a1 
    ld de,02710h               ;5df6 11 10 27  . . '               (ghost flow from: 500c)   500f ld de,2710 
    call 052b4h                ;5df9 cd b4 52  . . R               (ghost flow from: 500f)   5012 call 52b4 
    ld de,003e8h               ;5dfc 11 e8 03  . . .               (ghost flow from: 52bf)   5015 ld de,03e8 
    call 052b4h                ;5dff cd b4 52  . . R               (ghost flow from: 5015)   5018 call 52b4 
    ld de,00064h               ;5e02 11 64 00  . d .               (ghost flow from: 52bf)   501b ld de,0064 
    call 052b4h                ;5e05 cd b4 52  . . R               (ghost flow from: 501b)   501e call 52b4 
    ld e,00ah                  ;5e08 1e 0a  . .                    (ghost flow from: 52bf)   5021 ld e,0a 
    call 052b4h                ;5e0a cd b4 52  . . R               (ghost flow from: 5021)   5023 call 52b4 
    ld e,001h                  ;5e0d 1e 01  . .                    (ghost flow from: 52bf)   5026 ld e,01 
    call 052b4h                ;5e0f cd b4 52  . . R               (ghost flow from: 5026)   5028 call 52b4 
    ld hl,04082h               ;5e12 21 82 40  ! . @               (ghost flow from: 52bf)   502b ld hl,4082 
    call 052e6h                ;5e15 cd e6 52  . . R               (ghost flow from: 502b)   502e call 52e6 

; BLOCK 'intro1_string' (start 0x5e18 end 0x5e34)
    defb "Spectrum Z80 Turbo Assemble",0xf2                    ;"r"+0x80                       ;0x5e18
    ld hl,040c7h               ;5e34 21 c7 40  ! . @               (ghost flow from: 531b)   504d ld hl,40c7 
    call 052e6h                ;5e37 cd e6 52  . . R               (ghost flow from: 504d)   5050 call 52e6 

; BLOCK 'intro2_string' (start 0x5e3a end 0x5e4c)
    defb "(C) 1990 UNIVERSU",0xcd                              ;"M"+0x80                       ;5e3a
    ld hl,048e2h               ;5e4c 21 e2 48  ! . H               (ghost flow from: 531b)   5065 ld hl,48e2 
    call 052e6h                ;5e4f cd e6 52  . . R               (ghost flow from: 5065)   5068 call 52e6 

; BLOCK 'intro3_string' (start 0x5e52 end 0x5e6e)
    defb "Press ENTER to run Assemble",0xf2                    ;"r"+0x80                       ;5e52
    ld hl,04883h               ;5e6e 21 83 48  ! . H               (ghost flow from: 531b)   5087 ld hl,4883 
    call 052e6h                ;5e71 cd e6 52  . . R               (ghost flow from: 5087)   508a call 52e6 

; BLOCK 'intro4_string' (start 0x5e74 end 0x5e8f)
    defb "Instalation address:00000_",0xa0                     ;" "+0x80                       ;5e74
    ld hl,0484bh               ;5e8f 21 4b 48  ! K H               (ghost flow from: 531b)   50a8 ld hl,484b 
    call 052e6h                ;5e92 cd e6 52  . . R               (ghost flow from: 50a8)   50ab call 52e6 

; BLOCK 'intro5_string' (start 0x5e95 end 0x5e9d)
    defb "Monitor",0xba        ;":"+0x80                       ;5e95
    ld a,04dh                  ;5e9d 3e 4d  > M                    (ghost flow from: 531b)   50b6 ld a,4d 
    or a                       ;5e9f b7  .                         (ghost flow from: 50b6)   50b8 or a 
    ld hl,04853h               ;5ea0 21 53 48  ! S H               (ghost flow from: 50b8)   50b9 ld hl,4853 
    jr z,l5eadh                ;5ea3 28 08  ( .                    (ghost flow from: 50b9)   50bc jr z,50c6 
    call 052e6h                ;5ea5 cd e6 52  . . R               (ghost flow from: 50bc)   50be call 52e6 

; BLOCK 'intro_yes_string' (start 0x5ea8 end 0x5eab)
    defb "Ye",0xf3             ;"s"+0x80                       ;5ea8
    jr intro_no_string_end     ;5eab 18 06  . .                    (ghost flow from: 531b)   50c4 jr 50cc 
l5eadh:
    call 052e6h                ;5ead cd e6 52  . . R 

; BLOCK 'intro_no_string' (start 0x5eb0 end 0x5eb3)
    defb "No",0xa0             ;" "+0x80                       ;5eb0
intro_no_string_end:
    ld hl,05800h               ;5eb3 21 00 58  ! . X               (ghost flow from: 50c4)   50cc ld hl,5800 
    ld de,05801h               ;5eb6 11 01 58  . . X               (ghost flow from: 50cc)   50cf ld de,5801 
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
    ld (hl),038h               ;5ed4 36 38  6 8                    (ghost flow from: 50ea)   50ed ld (hl),38 
    ld a,(hl)                  ;5ed6 7e  ~                         (ghost flow from: 50ed)   50ef ld a,(hl) 
    ldir                       ;5ed7 ed b0  . .                    (ghost flow from: 50ef 50f0)   50f0 ldir 
    ld (hl),030h               ;5ed9 36 30  6 0                    (ghost flow from: 50f0)   50f2 ld (hl),30 
    ld bc,00020h               ;5edb 01 20 00  .   .               (ghost flow from: 50f2)   50f4 ld bc,0020 
    ldir                       ;5ede ed b0  . .                    (ghost flow from: 50f4 50f7)   50f7 ldir 
    call 052dch                ;5ee0 cd dc 52  . . R               (ghost flow from: 50f7)   50f9 call 52dc 
    ld b,001h                  ;5ee3 06 01  . .                    (ghost flow from: 52e5)   50fc ld b,01 
    ld (hl),a                  ;5ee5 77  w                         (ghost flow from: 50fc)   50fe ld (hl),a 
    ldir                       ;5ee6 ed b0  . .                    (ghost flow from: 50fe 50ff)   50ff ldir 
    ld e,00ah                  ;5ee8 1e 0a  . .                    (ghost flow from: 50ff)   5101 ld e,0a 
    ld hl,0012ch               ;5eea 21 2c 01  ! , .               (ghost flow from: 5101)   5103 ld hl,012c 
    ld a,(050eeh)              ;5eed 3a ee 50  : . P               (ghost flow from: 5103)   5106 ld a,(50ee) 
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
    call 0031eh                ;5f0b cd 1e 03  . . .               (ghost flow from: 5122)   5124 call 031e 
    jr nc,l5f06h               ;5f0e 30 f6  0 .                    (ghost flow from: 0324 0332)   5127 jr nc,511f 
    ld e,a                     ;5f10 5f  _                         (ghost flow from: 5127)   5129 ld e,a 
    inc b                      ;5f11 04  .                         (ghost flow from: 5129)   512a inc b 
    jr z,l5f16h                ;5f12 28 02  ( .                    (ghost flow from: 512a)   512b jr z,512f 
    add a,080h                 ;5f14 c6 80  . . 
l5f16h:
    ld hl,0502bh               ;5f16 21 2b 50  ! + P               (ghost flow from: 512b)   512f ld hl,502b 
    push hl                    ;5f19 e5  .                         (ghost flow from: 512f)   5132 push hl 
    cp 049h                    ;5f1a fe 49  . I                    (ghost flow from: 5132)   5133 cp 49 
    ld hl,050eeh               ;5f1c 21 ee 50  ! . P               (ghost flow from: 5133)   5135 ld hl,50ee 
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
    ld hl,05309h               ;5f4f 21 09 53  ! . S 
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
    ld a,000h                  ;5f72 3e 00  > . 
    inc a                      ;5f74 3c  < 
    cp 003h                    ;5f75 fe 03  . . 
    jr nz,l5f7ah               ;5f77 20 01    . 
    xor a                      ;5f79 af  . 
l5f7ah:
    ld (0518ch),a              ;5f7a 32 8c 51  2 . Q 
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
    call 052afh                ;5fc7 cd af 52  . . R               (ghost flow from: 51dd)   51e0 call 52af 
    ld a,(05309h)              ;5fca 3a 09 53  : . S               (ghost flow from: 52b3)   51e3 ld a,(5309) 
    call 052aeh                ;5fcd cd ae 52  . . R               (ghost flow from: 51e3)   51e6 call 52ae 
    ld de,(052fah)             ;5fd0 ed 5b fa 52  . [ . R          (ghost flow from: 52b3)   51e9 ld de,(52fa) 
    ld (hl),e                  ;5fd4 73  s                         (ghost flow from: 51e9)   51ed ld (hl),e 
    inc hl                     ;5fd5 23  #                         (ghost flow from: 51ed)   51ee inc hl 
    ld (hl),d                  ;5fd6 72  r                         (ghost flow from: 51ee)   51ef ld (hl),d 
    dec hl                     ;5fd7 2b  +                         (ghost flow from: 51ef)   51f0 dec hl 
    call 052afh                ;5fd8 cd af 52  . . R               (ghost flow from: 51f0)   51f1 call 52af 
    ld a,(05102h)              ;5fdb 3a 02 51  : . Q               (ghost flow from: 52b3)   51f4 ld a,(5102) 
    call 052aeh                ;5fde cd ae 52  . . R               (ghost flow from: 51f4)   51f7 call 52ae 
    ld a,(050eeh)              ;5fe1 3a ee 50  : . P               (ghost flow from: 52b3)   51fa ld a,(50ee) 
    call 052aeh                ;5fe4 cd ae 52  . . R               (ghost flow from: 51fa)   51fd call 52ae 
    call 052aeh                ;5fe7 cd ae 52  . . R               (ghost flow from: 52b3)   5200 call 52ae 
    call 052aeh                ;5fea cd ae 52  . . R               (ghost flow from: 52b3)   5203 call 52ae 
    xor 001h                   ;5fed ee 01  . .                    (ghost flow from: 52b3)   5206 xor 01 
    call 052aeh                ;5fef cd ae 52  . . R               (ghost flow from: 5206)   5208 call 52ae 
    call 052aeh                ;5ff2 cd ae 52  . . R               (ghost flow from: 52b3)   520b call 52ae 
    call 052dch                ;5ff5 cd dc 52  . . R               (ghost flow from: 52b3)   520e call 52dc 
    call 052aeh                ;5ff8 cd ae 52  . . R               (ghost flow from: 52e5)   5211 call 52ae 
    and 007h                   ;5ffb e6 07  . .                    (ghost flow from: 52b3)   5214 and 07 
    call 052aeh                ;5ffd cd ae 52  . . R               (ghost flow from: 5214)   5216 call 52ae 
    call 052aeh                ;6000 cd ae 52  . . R               (ghost flow from: 52b3)   5219 call 52ae 
    ld a,(050f3h)              ;6003 3a f3 50  : . P               (ghost flow from: 52b3)   521c ld a,(50f3) 
    call 052aeh                ;6006 cd ae 52  . . R               (ghost flow from: 521c)   521f call 52ae 
    call 052aeh                ;6009 cd ae 52  . . R               (ghost flow from: 52b3)   5222 call 52ae 
    ld (hl),a                  ;600c 77  w                         (ghost flow from: 52b3)   5225 ld (hl),a 
    ld sp,00000h               ;600d 31 00 00  1 . .               (ghost flow from: 5225)   5226 ld sp,401e 
    ld hl,00000h               ;6010 21 00 00  ! . .               (ghost flow from: 5226)   5229 ld hl,0000 
    ld de,050a1h               ;6013 11 a1 50  . . P               (ghost flow from: 5229)   522c ld de,50a1 
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
    ld bc,01b72h               ;6038 01 72 1b  . r . 
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
    ld hl,05353h               ;606a 21 53 53  ! S S               (ghost flow from: 5281)   5283 ld hl,5353 
    call 0531ch                ;606d cd 1c 53  . . S               (ghost flow from: 5283)   5286 call 531c 
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
    ld hl,05547h               ;607d 21 47 55  ! G U               (ghost flow from: 528e)   5296 ld hl,5547 
    call 0531ch                ;6080 cd 1c 53  . . S               (ghost flow from: 5296)   5299 call 531c 
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
    ld (hl),a                  ;6095 77  w                         (ghost flow from: 51e6 51f7 51fd 5200 5203 5208 520b 5211 5216 5219 521f 5222)   52ae ld (hl),a 
    pop bc                     ;6096 c1  .                         (ghost flow from: 51e0 51f1 52ae)   52af pop bc 
    pop de                     ;6097 d1  .                         (ghost flow from: 52af)   52b0 pop de 
    add hl,de                  ;6098 19  .                         (ghost flow from: 52b0)   52b1 add hl,de 
    push bc                    ;6099 c5  .                         (ghost flow from: 52b1)   52b2 push bc 
l609ah:
    ret                        ;609a c9  .                         (ghost flow from: 52b2)   52b3 ret 
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
    jp nc,l9404h               ;60bd d2 04 94  . . . 
    rst 30h                    ;60c0 f7  . 
    ld e,l                     ;60c1 5d  ] 
    ret m                      ;60c2 f8  . 
    and 0f8h                   ;60c3 e6 f8  . .                    (ghost flow from: 50f9 520e)   52dc and f8 
    ld b,a                     ;60c5 47  G                         (ghost flow from: 52dc)   52de ld b,a 
l60c6h:
    rrca                       ;60c6 0f  .                         (ghost flow from: 52de)   52df rrca 
    rrca                       ;60c7 0f  .                         (ghost flow from: 52df)   52e0 rrca 
    rrca                       ;60c8 0f  .                         (ghost flow from: 52e0)   52e1 rrca 
    and 007h                   ;60c9 e6 07  . .                    (ghost flow from: 52e1)   52e2 and 07 
    or b                       ;60cb b0  .                         (ghost flow from: 52e2)   52e4 or b 
    ret                        ;60cc c9  .                         (ghost flow from: 52e4)   52e5 ret 
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
    ld bc,0cf23h               ;613a 01 23 cf  . # . 
    dec e                      ;613d 1d  . 
    or (hl)                    ;613e b6  . 
    ld a,(bc)                  ;613f 0a  . 
    rlca                       ;6140 07  . 
    rlc e                      ;6141 cb 03  . . 
sub_6143h:
    ld b,00ah                  ;6143 06 0a  . . 
    dec bc                     ;6145 0b  . 
    dec b                      ;6146 05  . 
    rrc c                      ;6147 cb 09  . . 
    inc b                      ;6149 04  . 
    rlc h                      ;614a cb 04  . . 
sub_614ch:
    rlca                       ;614c 07  . 
    call v_l63c5h-BA1          ;614d cd 05 06  . . . 
    inc bc                     ;6150 03  . 
    dec b                      ;6151 05  . 
    dec bc                     ;6152 0b  . 
    call z,00802h              ;6153 cc 02 08  . . . 
    inc b                      ;6156 04  . 
    ex af,af'                  ;6157 08  . 
    add hl,bc                  ;6158 09  . 
    ret nc                     ;6159 d0  . 
    ld (bc),a                  ;615a 02  . 
    inc c                      ;615b 0c  . 
    dec b                      ;615c 05  . 
    inc b                      ;615d 04  . 
    rlc d                      ;615e cb 02  . . 
    ld b,008h                  ;6160 06 08  . . 
    ld d,e                     ;6162 53  S 
    ex af,af'                  ;6163 08  . 
    inc bc                     ;6164 03  . 
    dec c                      ;6165 0d  . 
    inc bc                     ;6166 03  . 
    call z,00602h              ;6167 cc 02 06  . . . 
    rlc l                      ;616a cb 05  . . 
    ld b,0cbh                  ;616c 06 cb  . . 
    ld (bc),a                  ;616e 02  . 
    dec b                      ;616f 05  . 
    rlc (hl)                   ;6170 cb 06  . . 
    dec b                      ;6172 05  . 
    ld a,(bc)                  ;6173 0a  . 
    inc bc                     ;6174 03  . 
    dec c                      ;6175 0d  . 
    dec b                      ;6176 05  . 
    rlc e                      ;6177 cb 03  . . 
    dec b                      ;6179 05  . 
    rlc d                      ;617a cb 02  . . 
    ld de,00e05h               ;617c 11 05 0e  . . . 
    inc bc                     ;617f 03  . 
    ld de,0cb04h               ;6180 11 04 cb  . . . 
    inc bc                     ;6183 03  . 
    ld de,003cdh               ;6184 11 cd 03  . . . 
    add hl,bc                  ;6187 09  . 
    rlca                       ;6188 07  . 
    inc b                      ;6189 04  . 
    inc c                      ;618a 0c  . 
    rlc d                      ;618b cb 02  . . 
    dec b                      ;618d 05  . 
    inc d                      ;618e 14  . 
    dec b                      ;618f 05  . 
    rlc d                      ;6190 cb 02  . . 
    call z,v_sub_60c3h-BA1     ;6192 cc 03 03  . . . 
    inc b                      ;6195 04  . 
    ld de,002cdh               ;6196 11 cd 02  . . . 
    rlc d                      ;6199 cb 02  . . 
    inc e                      ;619b 1c  . 
    inc b                      ;619c 04  . 
    inc bc                     ;619d 03  . 
    inc b                      ;619e 04  . 
    rlc h                      ;619f cb 04  . . 
    ld a,(bc)                  ;61a1 0a  . 
    add hl,bc                  ;61a2 09  . 
    inc bc                     ;61a3 03  . 
    dec c                      ;61a4 0d  . 
    rlc h                      ;61a5 cb 04  . . 
    inc b                      ;61a7 04  . 
    inc bc                     ;61a8 03  . 
    ld b,003h                  ;61a9 06 03  . . 
    dec b                      ;61ab 05  . 
    add hl,bc                  ;61ac 09  . 
    inc bc                     ;61ad 03  . 
    ld c,003h                  ;61ae 0e 03  . . 
    dec b                      ;61b0 05  . 
    inc bc                     ;61b1 03  . 
    inc b                      ;61b2 04  . 
    inc bc                     ;61b3 03  . 
    dec b                      ;61b4 05  . 
    inc bc                     ;61b5 03  . 
    ex af,af'                  ;61b6 08  . 
    rlc d                      ;61b7 cb 02  . . 
    rst 8                      ;61b9 cf  . 
    ld (bc),a                  ;61ba 02  . 
    dec b                      ;61bb 05  . 
    inc bc                     ;61bc 03  . 
    inc b                      ;61bd 04  . 
    rlc d                      ;61be cb 02  . . 
    dec b                      ;61c0 05  . 
    rlc d                      ;61c1 cb 02  . . 
    dec b                      ;61c3 05  . 
    inc bc                     ;61c4 03  . 
    inc c                      ;61c5 0c  . 
    dec c                      ;61c6 0d  . 
    rlca                       ;61c7 07  . 
    add hl,bc                  ;61c8 09  . 
    rlc d                      ;61c9 cb 02  . . 
    call v_l6ac2h-BA1          ;61cb cd 02 0d  . . . 
    inc c                      ;61ce 0c  . 
    inc bc                     ;61cf 03  . 
    dec b                      ;61d0 05  . 
    rlc d                      ;61d1 cb 02  . . 
    dec d                      ;61d3 15  . 
    call z,01003h              ;61d4 cc 03 10  . . . 
    dec c                      ;61d7 0d  . 
    dec b                      ;61d8 05  . 
    dec c                      ;61d9 0d  . 
    call 0cc02h                ;61da cd 02 cc  . . . 
    inc bc                     ;61dd 03  . 
    ld a,(bc)                  ;61de 0a  . 
    dec b                      ;61df 05  . 
    jr $+6                     ;61e0 18 04  . . 
    dec c                      ;61e2 0d  . 
    dec b                      ;61e3 05  . 
    rrca                       ;61e4 0f  . 
    call 00c02h                ;61e5 cd 02 0c  . . . 
    dec c                      ;61e8 0d  . 
    dec b                      ;61e9 05  . 
    djnz l61ffh                ;61ea 10 13  . . 
    rla                        ;61ec 17  . 
    inc bc                     ;61ed 03  . 
    ex af,af'                  ;61ee 08  . 
    ld c,005h                  ;61ef 0e 05  . . 
    inc e                      ;61f1 1c  . 
    jp z,01e04h                ;61f2 ca 04 1e  . . . 
    djnz $+7                   ;61f5 10 05  . . 
    ld b,0cbh                  ;61f7 06 cb  . . 
    ld (bc),a                  ;61f9 02  . 
    inc b                      ;61fa 04  . 
    ld b,003h                  ;61fb 06 03  . . 
    ld b,0cbh                  ;61fd 06 cb  . . 
l61ffh:
    ld (bc),a                  ;61ff 02  . 
    ld a,(bc)                  ;6200 0a  . 
    inc bc                     ;6201 03  . 
    dec bc                     ;6202 0b  . 
    ld a,(bc)                  ;6203 0a  . 
    ld c,003h                  ;6204 0e 03  . . 
    ld b,017h                  ;6206 06 17  . . 
    ld (de),a                  ;6208 12  . 
    ld hl,0cb1fh               ;6209 21 1f cb  ! . . 
    ld (bc),a                  ;620c 02  . 
    inc b                      ;620d 04  . 
    inc bc                     ;620e 03  . 
    ld b,003h                  ;620f 06 03  . . 
    ld b,003h                  ;6211 06 03  . . 
    dec b                      ;6213 05  . 
    sub 002h                   ;6214 d6 02  . . 
    inc b                      ;6216 04  . 
    inc bc                     ;6217 03  . 
    ld b,00dh                  ;6218 06 0d  . . 
    ld a,(bc)                  ;621a 0a  . 
    inc b                      ;621b 04  . 
    inc de                     ;621c 13  . 
    rlca                       ;621d 07  . 
    ex af,af'                  ;621e 08  . 
    inc bc                     ;621f 03  . 
    call z,00c02h              ;6220 cc 02 0c  . . . 
    rlc (hl)                   ;6223 cb 06  . . 
    add hl,bc                  ;6225 09  . 
    rlca                       ;6226 07  . 
    ex af,af'                  ;6227 08  . 
    dec b                      ;6228 05  . 
    rlc d                      ;6229 cb 02  . . 
    dec b                      ;622b 05  . 
    ex af,af'                  ;622c 08  . 
    dec b                      ;622d 05  . 
    dec c                      ;622e 0d  . 
    rlc d                      ;622f cb 02  . . 
    ld b,003h                  ;6231 06 03  . . 
    rlca                       ;6233 07  . 
    dec b                      ;6234 05  . 
    rlc (hl)                   ;6235 cb 06  . . 
    call z,0cb02h              ;6237 cc 02 cb  . . . 
    ld (bc),a                  ;623a 02  . 
    call z,0cb02h              ;623b cc 02 cb  . . . 
    ld (bc),a                  ;623e 02  . 
    ld b,004h                  ;623f 06 04  . . 
    inc bc                     ;6241 03  . 
    dec b                      ;6242 05  . 
    inc bc                     ;6243 03  . 
    inc b                      ;6244 04  . 
    rlc l                      ;6245 cb 05  . . 
    inc b                      ;6247 04  . 
    rlc d                      ;6248 cb 02  . . 
    add hl,bc                  ;624a 09  . 
    inc bc                     ;624b 03  . 
    inc b                      ;624c 04  . 
    call 00402h                ;624d cd 02 04  . . . 
    inc bc                     ;6250 03  . 
    inc b                      ;6251 04  . 
    ld a,(bc)                  ;6252 0a  . 
    inc b                      ;6253 04  . 
    inc bc                     ;6254 03  . 
    add hl,de                  ;6255 19  . 
    inc bc                     ;6256 03  . 
    inc b                      ;6257 04  . 
    inc bc                     ;6258 03  . 
    ld c,012h                  ;6259 0e 12  . . 
    inc bc                     ;625b 03  . 
    ld c,026h                  ;625c 0e 26  . & 
    inc bc                     ;625e 03  . 
    dec bc                     ;625f 0b  . 
    call z,00702h              ;6260 cc 02 07  . . . 
    dec b                      ;6263 05  . 
    inc c                      ;6264 0c  . 
    ld b,014h                  ;6265 06 14  . . 
    inc b                      ;6267 04  . 
    inc bc                     ;6268 03  . 
    rla                        ;6269 17  . 
    inc b                      ;626a 04  . 
    rlc d                      ;626b cb 02  . . 
    call z,00602h              ;626d cc 02 06  . . . 
    dec c                      ;6270 0d  . 
    call 01002h                ;6271 cd 02 10  . . . 
    call 0cc03h                ;6274 cd 03 cc  . . . 
    ld (bc),a                  ;6277 02  . 
    inc bc                     ;6278 03  . 
    inc b                      ;6279 04  . 
    inc bc                     ;627a 03  . 
    add hl,bc                  ;627b 09  . 
    ex af,af'                  ;627c 08  . 
    rlca                       ;627d 07  . 
    rlc d                      ;627e cb 02  . . 
    dec bc                     ;6280 0b  . 
    inc bc                     ;6281 03  . 
    ld de,01107h               ;6282 11 07 11  . . . 
    inc b                      ;6285 04  . 
    inc bc                     ;6286 03  . 
    daa                        ;6287 27  ' 
    ex af,af'                  ;6288 08  . 
    inc bc                     ;6289 03  . 
    dec b                      ;628a 05  . 
    rlc d                      ;628b cb 02  . . 
    dec b                      ;628d 05  . 
    inc bc                     ;628e 03  . 
    ld b,004h                  ;628f 06 04  . . 
    rlc e                      ;6291 cb 03  . . 
    inc b                      ;6293 04  . 
    inc bc                     ;6294 03  . 
    ld b,003h                  ;6295 06 03  . . 
    inc b                      ;6297 04  . 
    rlc d                      ;6298 cb 02  . . 
    ex af,af'                  ;629a 08  . 
    inc b                      ;629b 04  . 
    ld b,003h                  ;629c 06 03  . . 
    dec h                      ;629e 25  % 
    inc bc                     ;629f 03  . 
    inc b                      ;62a0 04  . 
    rlc d                      ;62a1 cb 02  . . 
    dec bc                     ;62a3 0b  . 
    call z,00503h              ;62a4 cc 03 05  . . . 
    inc c                      ;62a7 0c  . 
    inc b                      ;62a8 04  . 
    ld (de),a                  ;62a9 12  . 
    inc d                      ;62aa 14  . 
    ex af,af'                  ;62ab 08  . 
    call z,00302h              ;62ac cc 02 03  . . . 
    dec b                      ;62af 05  . 
    inc bc                     ;62b0 03  . 
    ld b,008h                  ;62b1 06 08  . . 
    rrca                       ;62b3 0f  . 
    dec b                      ;62b4 05  . 
    ld a,(de)                  ;62b5 1a  . 
    dec b                      ;62b6 05  . 
    rlca                       ;62b7 07  . 
    jr nz,l62bfh               ;62b8 20 05    . 
    add hl,bc                  ;62ba 09  . 
    rlca                       ;62bb 07  . 
    ld b,005h                  ;62bc 06 05  . . 
    ld a,(bc)                  ;62be 0a  . 
l62bfh:
    ex af,af'                  ;62bf 08  . 
    inc bc                     ;62c0 03  . 
    call z,00302h              ;62c1 cc 02 03  . . . 
    ld b,005h                  ;62c4 06 05  . . 
    ex af,af'                  ;62c6 08  . 
    dec bc                     ;62c7 0b  . 
    ld de,00a15h               ;62c8 11 15 0a  . . . 
    adc a,a                    ;62cb 8f  . 
    inc b                      ;62cc 04  . 
    ex af,af'                  ;62cd 08  . 
    inc b                      ;62ce 04  . 
    ld c,003h                  ;62cf 0e 03  . . 
    dec bc                     ;62d1 0b  . 
    dec b                      ;62d2 05  . 
    ld b,008h                  ;62d3 06 08  . . 
    inc b                      ;62d5 04  . 
    inc l                      ;62d6 2c  , 
    ex af,af'                  ;62d7 08  . 
    inc b                      ;62d8 04  . 
    ld a,(de)                  ;62d9 1a  . 
    inc b                      ;62da 04  . 
    rlca                       ;62db 07  . 
    dec b                      ;62dc 05  . 
    add hl,bc                  ;62dd 09  . 
    inc bc                     ;62de 03  . 
    ld b,007h                  ;62df 06 07  . . 
    inc bc                     ;62e1 03  . 
    add hl,bc                  ;62e2 09  . 
    rla                        ;62e3 17  . 
    ld hl,(00308h)             ;62e4 2a 08 03  * . . 
    dec b                      ;62e7 05  . 
    inc bc                     ;62e8 03  . 
    rlca                       ;62e9 07  . 
    dec e                      ;62ea 1d  . 
    ld a,(de)                  ;62eb 1a  . 
    dec c                      ;62ec 0d  . 
    rlca                       ;62ed 07  . 
    dec l                      ;62ee 2d  - 
    ld hl,(00804h)             ;62ef 2a 04 08  * . . 
    dec b                      ;62f2 05  . 
    inc b                      ;62f3 04  . 
    ld c,0cdh                  ;62f4 0e cd  . . 
    ld (bc),a                  ;62f6 02  . 
    inc c                      ;62f7 0c  . 
    inc bc                     ;62f8 03  . 
    ld hl,00905h               ;62f9 21 05 09  ! . . 
    inc bc                     ;62fc 03  . 
    jr l6313h                  ;62fd 18 14  . . 
    dec c                      ;62ff 0d  . 
    dec d                      ;6300 15  . 
    inc bc                     ;6301 03  . 
    inc b                      ;6302 04  . 
    ld a,(bc)                  ;6303 0a  . 
    ld d,00dh                  ;6304 16 0d  . . 
    inc bc                     ;6306 03  . 
    pop de                     ;6307 d1  . 
    ld (bc),a                  ;6308 02  . 
    inc bc                     ;6309 03  . 
    rrca                       ;630a 0f  . 
    dec d                      ;630b 15  . 
    inc b                      ;630c 04  . 
    dec b                      ;630d 05  . 
    inc bc                     ;630e 03  . 
    inc b                      ;630f 04  . 
    inc bc                     ;6310 03  . 
    inc b                      ;6311 04  . 
    dec b                      ;6312 05  . 
l6313h:
    ld de,v_l7cc6h-BA1         ;6313 11 06 1f  . . . 
    call 00302h                ;6316 cd 02 03  . . . 
    dec b                      ;6319 05  . 
    inc bc                     ;631a 03  . 
    dec b                      ;631b 05  . 
    add hl,bc                  ;631c 09  . 
    dec b                      ;631d 05  . 
    rlc d                      ;631e cb 02  . . 
    ld b,007h                  ;6320 06 07  . . 
    inc c                      ;6322 0c  . 
    rlca                       ;6323 07  . 
    dec b                      ;6324 05  . 
    djnz l632ch                ;6325 10 05  . . 
    ld a,(bc)                  ;6327 0a  . 
    ld b,003h                  ;6328 06 03  . . 
    ld b,007h                  ;632a 06 07  . . 
l632ch:
    nop                        ;632c 00  . 
    nop                        ;632d 00  . 
    ld bc,00dcah               ;632e 01 ca 0d  . . . 
    ld b,0cah                  ;6331 06 ca  . . 
    ld a,(bc)                  ;6333 0a  . 
    rlc d                      ;6334 cb 02  . . 
    inc b                      ;6336 04  . 
    inc bc                     ;6337 03  . 
    dec b                      ;6338 05  . 
    ex af,af'                  ;6339 08  . 
    inc bc                     ;633a 03  . 
    inc b                      ;633b 04  . 
    inc bc                     ;633c 03  . 
    ld b,00ah                  ;633d 06 0a  . . 
    dec b                      ;633f 05  . 
    inc bc                     ;6340 03  . 
    rst 8                      ;6341 cf  . 
    ld (bc),a                  ;6342 02  . 
    call 00a02h                ;6343 cd 02 0a  . . . 
    dec b                      ;6346 05  . 
    ld b,008h                  ;6347 06 08  . . 
    add hl,bc                  ;6349 09  . 
    rlca                       ;634a 07  . 
    dec b                      ;634b 05  . 
    ret nc                     ;634c d0  . 
    ld (bc),a                  ;634d 02  . 
    add hl,bc                  ;634e 09  . 
    rlc d                      ;634f cb 02  . . 
    pop de                     ;6351 d1  . 
    ld (bc),a                  ;6352 02  . 
    rlc d                      ;6353 cb 02  . . 
    call z,0cb02h              ;6355 cc 02 cb  . . . 
    inc bc                     ;6358 03  . 
    inc c                      ;6359 0c  . 
    adc a,003h                 ;635a ce 03  . . 
    inc b                      ;635c 04  . 
    add hl,bc                  ;635d 09  . 
    rst 8                      ;635e cf  . 
    ld (bc),a                  ;635f 02  . 
    add hl,bc                  ;6360 09  . 
    rrc b                      ;6361 cb 08  . . 
    dec b                      ;6363 05  . 
    ld b,004h                  ;6364 06 04  . . 
    rlc d                      ;6366 cb 02  . . 
    rlca                       ;6368 07  . 
    dec bc                     ;6369 0b  . 
    rrc c                      ;636a cb 09  . . 
    inc c                      ;636c 0c  . 
    dec b                      ;636d 05  . 
    rlc d                      ;636e cb 02  . . 
    ld a,(bc)                  ;6370 0a  . 
    ld (de),a                  ;6371 12  . 
    ex af,af'                  ;6372 08  . 
    rlc e                      ;6373 cb 03  . . 
    dec b                      ;6375 05  . 
    inc c                      ;6376 0c  . 
    ex af,af'                  ;6377 08  . 
    ld c,005h                  ;6378 0e 05  . . 
    rlc (hl)                   ;637a cb 06  . . 
    call z,00902h              ;637c cc 02 09  . . . 
    ld c,c                     ;637f 49  I 
    add hl,bc                  ;6380 09  . 
    dec bc                     ;6381 0b  . 
    inc c                      ;6382 0c  . 
    inc e                      ;6383 1c  . 
    dec bc                     ;6384 0b  . 
    rst 10h                    ;6385 d7  . 
    ld (bc),a                  ;6386 02  . 
    inc c                      ;6387 0c  . 
    rlc d                      ;6388 cb 02  . . 
    ld b,00bh                  ;638a 06 0b  . . 
    ld b,008h                  ;638c 06 08  . . 
    dec b                      ;638e 05  . 
    rla                        ;638f 17  . 
    add hl,bc                  ;6390 09  . 
    dec bc                     ;6391 0b  . 
    inc c                      ;6392 0c  . 
    dec b                      ;6393 05  . 
    inc b                      ;6394 04  . 
    dec b                      ;6395 05  . 
    ex af,af'                  ;6396 08  . 
    rlca                       ;6397 07  . 
    add hl,bc                  ;6398 09  . 
    ex af,af'                  ;6399 08  . 
    inc bc                     ;639a 03  . 
    inc de                     ;639b 13  . 
    inc b                      ;639c 04  . 
    rlc l                      ;639d cb 05  . . 
    dec b                      ;639f 05  . 
    rlc d                      ;63a0 cb 02  . . 
    inc c                      ;63a2 0c  . 
    add hl,bc                  ;63a3 09  . 
    dec b                      ;63a4 05  . 
    jp nc,00402h               ;63a5 d2 02 04  . . . 
    ld d,00ch                  ;63a8 16 0c  . . 
    ex af,af'                  ;63aa 08  . 
    inc bc                     ;63ab 03  . 
    add hl,bc                  ;63ac 09  . 
    ld b,0cbh                  ;63ad 06 cb  . . 
    inc bc                     ;63af 03  . 
    rrca                       ;63b0 0f  . 
    dec b                      ;63b1 05  . 
    dec bc                     ;63b2 0b  . 
    ld c,007h                  ;63b3 0e 07  . . 
    inc b                      ;63b5 04  . 
    ld a,(bc)                  ;63b6 0a  . 
    inc bc                     ;63b7 03  . 
    in a,(002h)                ;63b8 db 02  . . 
    ld de,00926h               ;63ba 11 26 09  . & . 
    dec b                      ;63bd 05  . 
    inc bc                     ;63be 03  . 
    ld c,007h                  ;63bf 0e 07  . . 
    dec b                      ;63c1 05  . 
    inc b                      ;63c2 04  . 
    dec b                      ;63c3 05  . 
    rlca                       ;63c4 07  . 
    ld b,004h                  ;63c5 06 04  . . 
    rlca                       ;63c7 07  . 
    inc b                      ;63c8 04  . 
    djnz $+7                   ;63c9 10 05  . . 
    inc hl                     ;63cb 23  # 
    ld hl,00504h               ;63cc 21 04 05  ! . . 
    ld e,003h                  ;63cf 1e 03  . . 
    ld c,0cch                  ;63d1 0e cc  . . 
    ld (bc),a                  ;63d3 02  . 
    dec c                      ;63d4 0d  . 
    dec b                      ;63d5 05  . 
    ld b,0cbh                  ;63d6 06 cb  . . 
    inc b                      ;63d8 04  . 
    ld a,(bc)                  ;63d9 0a  . 
    inc bc                     ;63da 03  . 
    ld de,00503h               ;63db 11 03 05  . . . 
    rlc d                      ;63de cb 02  . . 
    rlca                       ;63e0 07  . 
    inc bc                     ;63e1 03  . 
    ex af,af'                  ;63e2 08  . 
    rlc d                      ;63e3 cb 02  . . 
    inc b                      ;63e5 04  . 
    inc bc                     ;63e6 03  . 
    ld a,(bc)                  ;63e7 0a  . 
    rlc d                      ;63e8 cb 02  . . 
    inc b                      ;63ea 04  . 
    rlc d                      ;63eb cb 02  . . 
    dec b                      ;63ed 05  . 
    inc bc                     ;63ee 03  . 
    inc e                      ;63ef 1c  . 
    ld c,0cbh                  ;63f0 0e cb  . . 
    inc bc                     ;63f2 03  . 
    inc b                      ;63f3 04  . 
    ld a,(bc)                  ;63f4 0a  . 
    inc bc                     ;63f5 03  . 
    inc b                      ;63f6 04  . 
    inc bc                     ;63f7 03  . 
    ld a,(bc)                  ;63f8 0a  . 
    inc b                      ;63f9 04  . 
    rlca                       ;63fa 07  . 
    ex af,af'                  ;63fb 08  . 
    dec b                      ;63fc 05  . 
    rlca                       ;63fd 07  . 
    ret nc                     ;63fe d0  . 
    ld (bc),a                  ;63ff 02  . 
    call 0cb02h                ;6400 cd 02 cb  . . . 
    inc bc                     ;6403 03  . 
    inc b                      ;6404 04  . 
    rlc e                      ;6405 cb 03  . . 
    dec b                      ;6407 05  . 
    inc b                      ;6408 04  . 
    inc bc                     ;6409 03  . 
    ld a,(bc)                  ;640a 0a  . 
    dec b                      ;640b 05  . 
    dec bc                     ;640c 0b  . 
    rlc d                      ;640d cb 02  . . 
    ld b,005h                  ;640f 06 05  . . 
    ld b,008h                  ;6411 06 08  . . 
    rlc d                      ;6413 cb 02  . . 
    ex af,af'                  ;6415 08  . 
    ld b,003h                  ;6416 06 03  . . 
    ld b,0cbh                  ;6418 06 cb  . . 
    ld (bc),a                  ;641a 02  . 
    ld a,(bc)                  ;641b 0a  . 
    dec b                      ;641c 05  . 
    rrca                       ;641d 0f  . 
    ld c,009h                  ;641e 0e 09  . . 
    rlc e                      ;6420 cb 03  . . 
    jr l6427h                  ;6422 18 03  . . 
    rrca                       ;6424 0f  . 
    rst 8                      ;6425 cf  . 
    inc bc                     ;6426 03  . 
l6427h:
    ld b,003h                  ;6427 06 03  . . 
    add hl,bc                  ;6429 09  . 
    push de                    ;642a d5  . 
    ld (bc),a                  ;642b 02  . 
    ld (de),a                  ;642c 12  . 
    rlca                       ;642d 07  . 
    inc c                      ;642e 0c  . 
    add hl,bc                  ;642f 09  . 
    add hl,hl                  ;6430 29  ) 
    dec b                      ;6431 05  . 
    ld c,00dh                  ;6432 0e 0d  . . 
    inc b                      ;6434 04  . 
    dec c                      ;6435 0d  . 
    inc bc                     ;6436 03  . 
    dec b                      ;6437 05  . 
    add hl,de                  ;6438 19  . 
    jr z,$+10                  ;6439 28 08  ( . 
    ld c,0cch                  ;643b 0e cc  . . 
    ld (bc),a                  ;643d 02  . 
    add hl,bc                  ;643e 09  . 
    out (002h),a               ;643f d3 02  . . 
    inc b                      ;6441 04  . 
    rlc e                      ;6442 cb 03  . . 
    add hl,bc                  ;6444 09  . 
    ex af,af'                  ;6445 08  . 
    inc bc                     ;6446 03  . 
    ld b,d                     ;6447 42  B 
    rlca                       ;6448 07  . 
    pop de                     ;6449 d1  . 
    ld (bc),a                  ;644a 02  . 
    dec b                      ;644b 05  . 
    rra                        ;644c 1f  . 
    ex af,af'                  ;644d 08  . 
    ld b,00ch                  ;644e 06 0c  . . 
    dec b                      ;6450 05  . 
    add hl,hl                  ;6451 29  ) 
    ld d,b                     ;6452 50  P 
    inc b                      ;6453 04  . 
    ld a,(0cb07h)              ;6454 3a 07 cb  : . . 
    inc bc                     ;6457 03  . 
    dec b                      ;6458 05  . 
    ld c,007h                  ;6459 0e 07  . . 
    inc de                     ;645b 13  . 
l645ch:
    djnz l646bh                ;645c 10 0d  . . 
    djnz l6463h                ;645e 10 03  . . 
    ld a,(bc)                  ;6460 0a  . 
    dec b                      ;6461 05  . 
    dec e                      ;6462 1d  . 
l6463h:
    add hl,bc                  ;6463 09  . 
    ex af,af'                  ;6464 08  . 
    inc bc                     ;6465 03  . 
    ld b,003h                  ;6466 06 03  . . 
    rlca                       ;6468 07  . 
    jr z,l6476h                ;6469 28 0b  ( . 
l646bh:
    inc bc                     ;646b 03  . 
    ex af,af'                  ;646c 08  . 
    inc bc                     ;646d 03  . 
    adc a,002h                 ;646e ce 02  . . 
    add hl,bc                  ;6470 09  . 
    dec b                      ;6471 05  . 
    inc bc                     ;6472 03  . 
    ld b,003h                  ;6473 06 03  . . 
    ex af,af'                  ;6475 08  . 
l6476h:
    rlc h                      ;6476 cb 04  . . 
    ld b,005h                  ;6478 06 05  . . 
    dec c                      ;647a 0d  . 
    inc bc                     ;647b 03  . 
    rlca                       ;647c 07  . 
    inc b                      ;647d 04  . 
    dec b                      ;647e 05  . 
    add hl,bc                  ;647f 09  . 
    dec b                      ;6480 05  . 
    out (002h),a               ;6481 d3 02  . . 
    ex af,af'                  ;6483 08  . 
    inc c                      ;6484 0c  . 
    dec b                      ;6485 05  . 
    inc bc                     ;6486 03  . 
    dec b                      ;6487 05  . 
    dec c                      ;6488 0d  . 
    dec bc                     ;6489 0b  . 
    ex af,af'                  ;648a 08  . 
    inc c                      ;648b 0c  . 
    dec b                      ;648c 05  . 
    inc bc                     ;648d 03  . 
    dec b                      ;648e 05  . 
    djnz l645ch                ;648f 10 cb  . . 
    ld (bc),a                  ;6491 02  . 
    dec b                      ;6492 05  . 
    inc bc                     ;6493 03  . 
    add hl,bc                  ;6494 09  . 
    rlc e                      ;6495 cb 03  . . 
l6497h:
    dec b                      ;6497 05  . 
    dec bc                     ;6498 0b  . 
    rlc d                      ;6499 cb 02  . . 
    dec bc                     ;649b 0b  . 
    inc bc                     ;649c 03  . 
    ld b,00ah                  ;649d 06 0a  . . 
    inc bc                     ;649f 03  . 
    inc b                      ;64a0 04  . 
    inc bc                     ;64a1 03  . 
    ld b,004h                  ;64a2 06 04  . . 
    ex af,af'                  ;64a4 08  . 
    inc bc                     ;64a5 03  . 
    ld b,005h                  ;64a6 06 05  . . 
    inc b                      ;64a8 04  . 
    rlc d                      ;64a9 cb 02  . . 
    dec a                      ;64ab 3d  = 
l64ach:
    rrca                       ;64ac 0f  . 
    ld e,025h                  ;64ad 1e 25  . % 
    rrca                       ;64af 0f  . 
    inc bc                     ;64b0 03  . 
    ex af,af'                  ;64b1 08  . 
    add hl,bc                  ;64b2 09  . 
    rlc d                      ;64b3 cb 02  . . 
    dec b                      ;64b5 05  . 
    rlc d                      ;64b6 cb 02  . . 
    dec b                      ;64b8 05  . 
    ld b,003h                  ;64b9 06 03  . . 
    dec b                      ;64bb 05  . 
    rlc d                      ;64bc cb 02  . . 
    ex af,af'                  ;64be 08  . 
    rlc d                      ;64bf cb 02  . . 
    inc b                      ;64c1 04  . 
    rlc d                      ;64c2 cb 02  . . 
    add hl,bc                  ;64c4 09  . 
    inc bc                     ;64c5 03  . 
    inc b                      ;64c6 04  . 
    ex af,af'                  ;64c7 08  . 
    inc c                      ;64c8 0c  . 
    inc b                      ;64c9 04  . 
    jr l6497h                  ;64ca 18 cb  . . 
    inc b                      ;64cc 04  . 
    inc b                      ;64cd 04  . 
    dec b                      ;64ce 05  . 
    ex af,af'                  ;64cf 08  . 
    rrca                       ;64d0 0f  . 
    ld c,020h                  ;64d1 0e 20  .   
    inc bc                     ;64d3 03  . 
    dec b                      ;64d4 05  . 
    rlc d                      ;64d5 cb 02  . . 
    djnz $+7                   ;64d7 10 05  . . 
    ld de,0040ah               ;64d9 11 0a 04  . . . 
    ld a,(bc)                  ;64dc 0a  . 
    jr nz,$+7                  ;64dd 20 05    . 
    djnz l64ach                ;64df 10 cb  . . 
    ld (bc),a                  ;64e1 02  . 
    call 00902h                ;64e2 cd 02 09  . . . 
    rst 8                      ;64e5 cf  . 
    ld (bc),a                  ;64e6 02  . 
    ld hl,(0cb04h)             ;64e7 2a 04 cb  * . . 
    ld b,006h                  ;64ea 06 06  . . 
    ex af,af'                  ;64ec 08  . 
    rlc e                      ;64ed cb 03  . . 
    inc b                      ;64ef 04  . 
    inc c                      ;64f0 0c  . 
    rrca                       ;64f1 0f  . 
    inc bc                     ;64f2 03  . 
    ld c,01bh                  ;64f3 0e 1b  . . 
    inc bc                     ;64f5 03  . 
    rra                        ;64f6 1f  . 
    rlca                       ;64f7 07  . 
    dec h                      ;64f8 25  % 
    adc a,002h                 ;64f9 ce 02  . . 
    dec c                      ;64fb 0d  . 
    ex af,af'                  ;64fc 08  . 
    inc de                     ;64fd 13  . 
    inc bc                     ;64fe 03  . 
    dec b                      ;64ff 05  . 
    inc de                     ;6500 13  . 
    djnz l6506h                ;6501 10 03  . . 
    ld c,04eh                  ;6503 0e 4e  . N 
    inc b                      ;6505 04  . 
l6506h:
    rrca                       ;6506 0f  . 
    inc de                     ;6507 13  . 
    inc h                      ;6508 24  $ 
    inc bc                     ;6509 03  . 
    dec b                      ;650a 05  . 
    ld a,(bc)                  ;650b 0a  . 
    dec b                      ;650c 05  . 
    inc b                      ;650d 04  . 
    dec c                      ;650e 0d  . 
    call 0cb03h                ;650f cd 03 cb  . . . 
    ld (bc),a                  ;6512 02  . 
    rla                        ;6513 17  . 
    rlca                       ;6514 07  . 
    djnz $-44                  ;6515 10 d2  . . 
    ld (bc),a                  ;6517 02  . 
    inc bc                     ;6518 03  . 
    ld a,(bc)                  ;6519 0a  . 
    inc c                      ;651a 0c  . 
    dec b                      ;651b 05  . 
    call z,02002h              ;651c cc 02 20  . .   
    inc bc                     ;651f 03  . 
    ld c,c                     ;6520 49  I 
    ex af,af'                  ;6521 08  . 
    add hl,bc                  ;6522 09  . 
    jr nz,l6528h               ;6523 20 03    . 
    dec bc                     ;6525 0b  . 
    inc bc                     ;6526 03  . 
    add hl,bc                  ;6527 09  . 
l6528h:
    ex af,af'                  ;6528 08  . 
    dec bc                     ;6529 0b  . 
    ld (de),a                  ;652a 12  . 
    ld a,(bc)                  ;652b 0a  . 
    ld b,017h                  ;652c 06 17  . . 
    inc bc                     ;652e 03  . 
    dec bc                     ;652f 0b  . 
    inc de                     ;6530 13  . 
    inc bc                     ;6531 03  . 
    ld b,00bh                  ;6532 06 0b  . . 
    ex af,af'                  ;6534 08  . 
    dec bc                     ;6535 0b  . 
    add hl,bc                  ;6536 09  . 
    rlca                       ;6537 07  . 
    ex af,af'                  ;6538 08  . 
    inc b                      ;6539 04  . 
    dec b                      ;653a 05  . 
    inc b                      ;653b 04  . 
    ld de,00949h               ;653c 11 49 09  . I . 
    inc c                      ;653f 0c  . 
    inc bc                     ;6540 03  . 
    inc b                      ;6541 04  . 
    ld d,b                     ;6542 50  P 
    ld a,(bc)                  ;6543 0a  . 
sub_6544h:
    dec hl                     ;6544 2b  + 
    ld (00b0fh),hl             ;6545 22 0f 0b  " . . 
    add hl,bc                  ;6548 09  . 
    inc bc                     ;6549 03  . 
    ld b,003h                  ;654a 06 03  . . 
    inc b                      ;654c 04  . 
sub_654dh:
    dec b                      ;654d 05  . 
    add hl,bc                  ;654e 09  . 
    dec b                      ;654f 05  . 
    inc b                      ;6550 04  . 
    dec b                      ;6551 05  . 
sub_6552h:
    dec bc                     ;6552 0b  . 
    inc d                      ;6553 14  . 
    inc b                      ;6554 04  . 
    dec bc                     ;6555 0b  . 
    ld c,00ah                  ;6556 0e 0a  . . 
    ld b,003h                  ;6558 06 03  . . 
    add hl,bc                  ;655a 09  . 
    ld a,(de)                  ;655b 1a  . 
    add hl,bc                  ;655c 09  . 
    ld c,015h                  ;655d 0e 15  . . 
    call z,v_l6ac2h-BA1        ;655f cc 02 0d  . . . 
    dec bc                     ;6562 0b  . 
    ld hl,0090eh               ;6563 21 0e 09  ! . . 
    ld h,l                     ;6566 65  e 
    rla                        ;6567 17  . 
    ld c,03bh                  ;6568 0e 3b  .                  ; 
    call 00302h                ;656a cd 02 03  . . . 
    dec bc                     ;656d 0b  . 
    ld c,004h                  ;656e 0e 04  . . 
    rlca                       ;6570 07  . 
    inc c                      ;6571 0c  . 
    dec b                      ;6572 05  . 
    inc de                     ;6573 13  . 
    dec de                     ;6574 1b  . 
    inc b                      ;6575 04  . 
    ld b,00fh                  ;6576 06 0f  . . 
    rlc e                      ;6578 cb 03  . . 
    ld b,00ch                  ;657a 06 0c  . . 
    add hl,hl                  ;657c 29  ) 
    add hl,bc                  ;657d 09  . 
    dec c                      ;657e 0d  . 
    inc b                      ;657f 04  . 
    inc bc                     ;6580 03  . 
    inc b                      ;6581 04  . 
    ld b,0cbh                  ;6582 06 cb  . . 
    ld (bc),a                  ;6584 02  . 
    ex af,af'                  ;6585 08  . 
    add hl,bc                  ;6586 09  . 
    adc a,002h                 ;6587 ce 02  . . 
    dec bc                     ;6589 0b  . 
    ld (de),a                  ;658a 12  . 
    add hl,bc                  ;658b 09  . 
    inc hl                     ;658c 23  # 
    ld de,v_l63c5h-BA1         ;658d 11 05 06  . . . 
    ex af,af'                  ;6590 08  . 
    adc a,002h                 ;6591 ce 02  . . 
    dec b                      ;6593 05  . 
    jr nz,l65aah               ;6594 20 14    . 
    dec e                      ;6596 1d  . 
    inc b                      ;6597 04  . 
    inc d                      ;6598 14  . 
    dec bc                     ;6599 0b  . 
    ld c,0cbh                  ;659a 0e cb  . . 
    ld b,01bh                  ;659c 06 1b  . . 
    rlc d                      ;659e cb 02  . . 
    call 00302h                ;65a0 cd 02 03  . . . 
    ld a,(bc)                  ;65a3 0a  . 
    rlc (hl)                   ;65a4 cb 06  . . 
    ld b,008h                  ;65a6 06 08  . . 
    djnz logo_image_start      ;65a8 10 09  . . 
l65aah:
    ld b,011h                  ;65aa 06 11  . . 
    ex af,af'                  ;65ac 08  . 
    ld (de),a                  ;65ad 12  . 
    ld b,00dh                  ;65ae 06 0d  . . 
    inc b                      ;65b0 04  . 
    rlc a                      ;65b1 cb 07  . . 

; BLOCK 'logo_image' (start 0x65b3 end 0x66f4)
logo_image_start:
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

; BLOCK 'data_66f4' (start 0x66f4 end 0x6898)
v_l5dc0h:
    defb 0c3h                  ;66f4 c3  . 
    defb 009h                  ;66f5 09  . 
    defb 01fh                  ;66f6 1f  . 
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
    defb 0f0h                  ;6718 f0  . 
    defb 011h                  ;6719 11  . 
    defb 020h                  ;671a 20    
    defb 050h                  ;671b 50  P 
    defb 0c2h                  ;671c c2  . 
    defb 092h                  ;671d 92  . 
    defb 001h                  ;671e 01  . 
    defb 0eah                  ;671f ea  . 
    defb 011h                  ;6720 11  . 
    defb 040h                  ;6721 40  @ 
    defb 050h                  ;6722 50  P 
    defb 0c3h                  ;6723 c3  . 
    defb 092h                  ;6724 92  . 
    defb 001h                  ;6725 01  . 
    defb 0e9h                  ;6726 e9  . 
    defb 011h                  ;6727 11  . 
    defb 060h                  ;6728 60  ` 
    defb 050h                  ;6729 50  P 
    defb 0c4h                  ;672a c4  . 
    defb 092h                  ;672b 92  . 
    defb 001h                  ;672c 01  . 
    defb 0ech                  ;672d ec  . 
    defb 011h                  ;672e 11  . 
    defb 080h                  ;672f 80  . 
    defb 050h                  ;6730 50  P 
    defb 0c5h                  ;6731 c5  . 
    defb 092h                  ;6732 92  . 
    defb 001h                  ;6733 01  . 
    defb 0ebh                  ;6734 eb  . 
    defb 011h                  ;6735 11  . 
    defb 0a0h                  ;6736 a0  . 
    defb 050h                  ;6737 50  P 
    defb 0c8h                  ;6738 c8  . 
    defb 092h                  ;6739 92  . 
    defb 001h                  ;673a 01  . 
    defb 0eeh                  ;673b ee  . 
    defb 011h                  ;673c 11  . 
    defb 0c0h                  ;673d c0  . 
    defb 050h                  ;673e 50  P 
    defb 0cch                  ;673f cc  . 
    defb 092h                  ;6740 92  . 
    defb 001h                  ;6741 01  . 
    defb 0edh                  ;6742 ed  . 
    defb 011h                  ;6743 11  . 
    defb 080h                  ;6744 80  . 
    defb 048h                  ;6745 48  H 
    defb 0c9h                  ;6746 c9  . 
    defb 082h                  ;6747 82  . 
    defb 000h                  ;6748 00  . 
    defb 0dch                  ;6749 dc  . 
    defb 011h                  ;674a 11  . 
    defb 0c8h                  ;674b c8  . 
    defb 050h                  ;674c 50  P 
    defb 0d2h                  ;674d d2  . 
    defb 082h                  ;674e 82  . 
    defb 001h                  ;674f 01  . 
    defb 0dbh                  ;6750 db  . 
    defb 011h                  ;6751 11  . 
    defb 000h                  ;6752 00  . 
    defb 048h                  ;6753 48  H 
    defb 019h                  ;6754 19  . 
    defb 082h                  ;6755 82  . 
    defb 000h                  ;6756 00  . 
    defb 0e8h                  ;6757 e8  . 
    defb 011h                  ;6758 11  . 
    defb 020h                  ;6759 20    
    defb 048h                  ;675a 48  H 
    defb 01dh                  ;675b 1d  . 
    defb 082h                  ;675c 82  . 
    defb 000h                  ;675d 00  . 
    defb 0e7h                  ;675e e7  . 
    defb 011h                  ;675f 11  . 
    defb 040h                  ;6760 40  @ 
    defb 048h                  ;6761 48  H 
    defb 01ah                  ;6762 1a  . 
    defb 082h                  ;6763 82  . 
    defb 000h                  ;6764 00  . 
    defb 0e6h                  ;6765 e6  . 
    defb 011h                  ;6766 11  . 
    defb 060h                  ;6767 60  ` 
    defb 048h                  ;6768 48  H 
    defb 01eh                  ;6769 1e  . 
    defb 082h                  ;676a 82  . 
    defb 000h                  ;676b 00  . 
    defb 0e5h                  ;676c e5  . 
    defb 011h                  ;676d 11  . 
    defb 0ceh                  ;676e ce  . 
    defb 050h                  ;676f 50  P 
    defb 0c6h                  ;6770 c6  . 
    defb 000h                  ;6771 00  . 
    defb 001h                  ;6772 01  . 
    defb 0efh                  ;6773 ef  . 
    defb 011h                  ;6774 11  . 
    defb 0e0h                  ;6775 e0  . 
    defb 040h                  ;6776 40  @ 
    defb 015h                  ;6777 15  . 
    defb 08ah                  ;6778 8a  . 
    defb 000h                  ;6779 00  . 
    defb 0efh                  ;677a ef  . 
    defb 011h                  ;677b 11  . 
    defb 049h                  ;677c 49  I 
    defb 050h                  ;677d 50  P 
    defb 016h                  ;677e 16  . 
    defb 08ah                  ;677f 8a  . 
    defb 001h                  ;6780 01  . 
    defb 0e9h                  ;6781 e9  . 
    defb 011h                  ;6782 11  . 
    defb 069h                  ;6783 69  i 
    defb 050h                  ;6784 50  P 
    defb 017h                  ;6785 17  . 
    defb 08ah                  ;6786 8a  . 
    defb 001h                  ;6787 01  . 
    defb 0ebh                  ;6788 eb  . 
    defb 011h                  ;6789 11  . 
    defb 089h                  ;678a 89  . 
    defb 050h                  ;678b 50  P 
    defb 018h                  ;678c 18  . 
    defb 08ah                  ;678d 8a  . 
    defb 001h                  ;678e 01  . 
    defb 0edh                  ;678f ed  . 
    defb 011h                  ;6790 11  . 
    defb 052h                  ;6791 52  R 
    defb 050h                  ;6792 50  P 
    defb 023h                  ;6793 23  # 
    defb 08ah                  ;6794 8a  . 
    defb 001h                  ;6795 01  . 
    defb 0f1h                  ;6796 f1  . 
    defb 011h                  ;6797 11  . 
    defb 072h                  ;6798 72  r 
    defb 050h                  ;6799 50  P 
    defb 01bh                  ;679a 1b  . 
    defb 08ah                  ;679b 8a  . 
    defb 001h                  ;679c 01  . 
    defb 0e7h                  ;679d e7  . 
    defb 011h                  ;679e 11  . 
    defb 092h                  ;679f 92  . 
    defb 050h                  ;67a0 50  P 
    defb 01ch                  ;67a1 1c  . 
    defb 08ah                  ;67a2 8a  . 
    defb 001h                  ;67a3 01  . 
    defb 0e5h                  ;67a4 e5  . 
    defb 011h                  ;67a5 11  . 
    defb 0d9h                  ;67a6 d9  . 
    defb 050h                  ;67a7 50  P 
    defb 0d4h                  ;67a8 d4  . 
    defb 08ah                  ;67a9 8a  . 
    defb 001h                  ;67aa 01  . 
    defb 0f3h                  ;67ab f3  . 
    defb 011h                  ;67ac 11  . 
    defb 0a0h                  ;67ad a0  . 
    defb 048h                  ;67ae 48  H 
    defb 0d8h                  ;67af d8  . 
    defb 081h                  ;67b0 81  . 
    defb 0e0h                  ;67b1 e0  . 
    defb 0f5h                  ;67b2 f5  . 
    defb 011h                  ;67b3 11  . 
    defb 0b1h                  ;67b4 b1  . 
    defb 048h                  ;67b5 48  H 
    defb 0d9h                  ;67b6 d9  . 
    defb 081h                  ;67b7 81  . 
    defb 0e0h                  ;67b8 e0  . 
    defb 0f7h                  ;67b9 f7  . 
    defb 011h                  ;67ba 11  . 
    defb 008h                  ;67bb 08  . 
    defb 048h                  ;67bc 48  H 
    defb 026h                  ;67bd 26  & 
    defb 081h                  ;67be 81  . 
    defb 0e0h                  ;67bf e0  . 
    defb 0e9h                  ;67c0 e9  . 
    defb 011h                  ;67c1 11  . 
    defb 028h                  ;67c2 28  ( 
    defb 048h                  ;67c3 48  H 
    defb 027h                  ;67c4 27  ' 
    defb 081h                  ;67c5 81  . 
    defb 0e0h                  ;67c6 e0  . 
    defb 0ebh                  ;67c7 eb  . 
    defb 011h                  ;67c8 11  . 
    defb 048h                  ;67c9 48  H 
    defb 048h                  ;67ca 48  H 
    defb 028h                  ;67cb 28  ( 
    defb 081h                  ;67cc 81  . 
    defb 0e0h                  ;67cd e0  . 
    defb 0edh                  ;67ce ed  . 
    defb 011h                  ;67cf 11  . 
    defb 016h                  ;67d0 16  . 
    defb 050h                  ;67d1 50  P 
    defb 02bh                  ;67d2 2b  + 
    defb 08dh                  ;67d3 8d  . 
    defb 0e5h                  ;67d4 e5  . 
    defb 0f1h                  ;67d5 f1  . 
    defb 011h                  ;67d6 11  . 
    defb 068h                  ;67d7 68  h 
    defb 048h                  ;67d8 48  H 
    defb 029h                  ;67d9 29  ) 
    defb 081h                  ;67da 81  . 
    defb 0e0h                  ;67db e0  . 
    defb 0e7h                  ;67dc e7  . 
    defb 011h                  ;67dd 11  . 
    defb 088h                  ;67de 88  . 
    defb 048h                  ;67df 48  H 
    defb 02ah                  ;67e0 2a  * 
    defb 081h                  ;67e1 81  . 
    defb 0e0h                  ;67e2 e0  . 
    defb 0e5h                  ;67e3 e5  . 
    defb 011h                  ;67e4 11  . 
    defb 0d4h                  ;67e5 d4  . 
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
sub_6821h:
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
    defb 002h                  ;684d 02  . 
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
    call v_sub_6c4ah-BA1       ;6898 cd 8a 0e  . . . 
    xor a                      ;689b af  . 
    in a,(0feh)                ;689c db fe  . . 
    cpl                        ;689e 2f  / 
    and 01fh                   ;689f e6 1f  . . 
    ret nz                     ;68a1 c0  . 
    call v_sub_8608h-BA1       ;68a2 cd 48 28  . H ( 
    cp 004h                    ;68a5 fe 04  . . 
    ret nz                     ;68a7 c0  . 
v_l5f74h:
    di                         ;68a8 f3  . 
    call v_sub_7800h-BA1       ;68a9 cd 40 1a  . @ . 
    ld sp,08ba1h-BA            ;68ac 31 e1 2d  1 . - 
    call v_sub_665ah-BA1       ;68af cd 9a 08  . . . 
    ld hl,v_l8affh-BA1         ;68b2 21 3f 2d  ! ? - 
    ld (hl),0c6h               ;68b5 36 c6  6 . 
    inc hl                     ;68b7 23  # 
    ld a,(v_l68f2h+1-BA1)      ;68b8 3a 33 0b  : 3 . 
    add a,0c7h                 ;68bb c6 c7  . . 
    ld (hl),a                  ;68bd 77  w 
    inc hl                     ;68be 23  # 
    ld (hl),0cch               ;68bf 36 cc  6 . 
    inc hl                     ;68c1 23  # 
    ld a,(v_l6848h-BA1)        ;68c2 3a 88 0a  : . . 
    or a                       ;68c5 b7  . 
    jr z,l68cah                ;68c6 28 02  ( . 
    sub 0c7h                   ;68c8 d6 c7  . . 
l68cah:
    add a,0c9h                 ;68ca c6 c9  . . 
    ld (hl),a                  ;68cc 77  w 
    call v_sub_6669h-BA1       ;68cd cd a9 08  . . . 
    ld a,080h                  ;68d0 3e 80  > . 
    ld (v_l8affh-BA1),a        ;68d2 32 3f 2d  2 ? - 
    ld hl,02fafh               ;68d5 21 af 2f  ! . / 
    ld (02991h),hl             ;68d8 22 91 29  " . ) 
    ld hl,v_l89f4h-BA1         ;68db 21 34 2c  ! 4 , 
    ld (080a0h-BA),hl          ;68de 22 e0 22  " . " 
    ld hl,v_l82dbh-BA1         ;68e1 21 1b 25  ! . % 
    ld (022e3h),hl             ;68e4 22 e3 22  " . " 
    ld hl,v_l7ccfh-BA1         ;68e7 21 0f 1f  ! . . 
    ld (02079h),hl             ;68ea 22 79 20  " y   
    ld hl,v_l5f74h-BA1         ;68ed 21 b4 01  ! . . 
    push hl                    ;68f0 e5  . 
    call v_sub_6d79h-BA1       ;68f1 cd b9 0f  . . . 
    call v_sub_8608h-BA1       ;68f4 cd 48 28  . H ( 
    call v_sub_6113h-BA1       ;68f7 cd 53 03  . S . 
    call v_sub_85f8h-BA1       ;68fa cd 38 28  . 8 ( 
    ld hl,(0603bh-BA)          ;68fd 2a 7b 02  * { . 
    ld e,020h                  ;6900 1e 20  .   
    cp 071h                    ;6902 fe 71  . q 
    jp z,v_l7cc9h-BA1          ;6904 ca 09 1f  . . . 
    cp 014h                    ;6907 fe 14  . . 
    jp z,v_l6c83h-BA1          ;6909 ca c3 0e  . . . 
    cp 023h                    ;690c fe 23  . # 
    jp z,v_l7c39h-BA1          ;690e ca 79 1e  . y . 
    cp 03ah                    ;6911 fe 3a  . : 
    jp z,v_l66eah-BA1          ;6913 ca 2a 09  . * . 
    cp 02ch                    ;6916 fe 2c  . , 
    jp z,v_l64feh-BA1          ;6918 ca 3e 07  . > . 
    cp 003h                    ;691b fe 03  . . 
    jp z,v_l7ca3h-BA1          ;691d ca e3 1e  . . . 
    ld c,a                     ;6920 4f  O 
    ld b,028h                  ;6921 06 28  . ( 
    ld hl,v_l600ah-BA1         ;6923 21 4a 02  ! J . 
    ld de,v_l6063h-BA1         ;6926 11 a3 02  . . . 
l6929h:
    ld a,(de)                  ;6929 1a  . 
    inc de                     ;692a 13  . 
    call v_sub_6bd8h-BA1       ;692b cd 18 0e  . . . 
    ld a,(de)                  ;692e 1a  . 
    cp c                       ;692f b9  . 
    inc de                     ;6930 13  . 
    jr z,l6939h                ;6931 28 06  ( . 
    djnz l6929h                ;6933 10 f4  . . 
    ld a,c                     ;6935 79  y 
    jp v_l6480h-BA1            ;6936 c3 c0 06  . . . 
l6939h:
    push hl                    ;6939 e5  . 
    ld hl,(0603bh-BA)          ;693a 2a 7b 02  * { . 
    ret                        ;693d c9  . 
v_l600ah:
    call v_sub_60c3h-BA1       ;693e cd 03 03  . . . 
    call nz,02b23h             ;6941 c4 23 2b  . # + 
    dec hl                     ;6944 2b  + 
    inc hl                     ;6945 23  # 
l6946h:
v_l6012h:
    ld (0603bh-BA),hl          ;6946 22 7b 02  " { . 
    ret                        ;6949 c9  . 
    ld hl,v_l5ee5h-BA1         ;694a 21 25 01  ! % . 
    ld a,(hl)                  ;694d 7e  ~ 
    or a                       ;694e b7  . 
    ret z                      ;694f c8  . 
    dec (hl)                   ;6950 35  5 
    add a,a                    ;6951 87  . 
    call v_sub_6bd8h-BA1       ;6952 cd 18 0e  . . . 
    ld a,(hl)                  ;6955 7e  ~ 
    dec hl                     ;6956 2b  + 
    ld l,(hl)                  ;6957 6e  n 
    ld h,a                     ;6958 67  g 
    jr l6946h                  ;6959 18 eb  . . 
    ld hl,v_l5ee5h-BA1         ;695b 21 25 01  ! % . 
    ld a,(hl)                  ;695e 7e  ~ 
    cp 00ah                    ;695f fe 0a  . . 
    ret nc                     ;6961 d0  . 
    push hl                    ;6962 e5  . 
    call v_sub_60c3h-BA1       ;6963 cd 03 03  . . . 
    call nz,034e3h             ;6966 c4 e3 34  . . 4 
    ld a,(hl)                  ;6969 7e  ~ 
    add a,a                    ;696a 87  . 
    call v_sub_6bd8h-BA1       ;696b cd 18 0e  . . . 
    ld de,00000h               ;696e 11 00 00  . . . 
    ld (hl),d                  ;6971 72  r 
    dec hl                     ;6972 2b  + 
    ld (hl),e                  ;6973 73  s 
    pop hl                     ;6974 e1  . 
    jr l6946h                  ;6975 18 cf  . . 
    call v_sub_6b56h-BA1       ;6977 cd 96 0d  . . . 
    jr l6946h                  ;697a 18 ca  . . 
    call v_sub_60c3h-BA1       ;697c cd 03 03  . . . 
    jp nz,l87cdh               ;697f c2 cd 87  . . . 
    ld c,0cdh                  ;6982 0e cd  . . 
    ld c,d                     ;6984 4a  J 
    inc c                      ;6985 0c  . 
    call v_sub_5f64h-BA1       ;6986 cd a4 01  . . . 
    jr $-6                     ;6989 18 f8  . . 
    ld ix,v_l5dcah-BA1         ;698b dd 21 0a 00  . ! . . 
    ld a,(ix+004h)             ;698f dd 7e 04  . ~ . 
    and 01fh                   ;6992 e6 1f  . . 
    jp v_l6e46h-BA1            ;6994 c3 86 10  . . . 
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
    ld hl,(06412h)             ;69c6 2a 12 64  * . d 
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
    ld (v_sub_664ch+1-BA1),hl                                  ;69e7 22 8d 08  " . . 
v_sub_60b6h:
    ld a,021h                  ;69ea 3e 21  > ! 
    ld de,00001h               ;69ec 11 01 00  . . . 
    ld hl,(v_sub_826ch+1-BA1)                                  ;69ef 2a ad 24  * . $ 
    ld (v_l79c3h+1-BA1),hl     ;69f2 22 04 1c  " . . 
    jr l69ffh                  ;69f5 18 08  . . 
v_sub_60c3h:
    pop hl                     ;69f7 e1  . 
    ld e,(hl)                  ;69f8 5e  ^ 
    inc hl                     ;69f9 23  # 
    push hl                    ;69fa e5  . 
    ld d,001h                  ;69fb 16 01  . . 
    ld a,0c3h                  ;69fd 3e c3  > . 
l69ffh:
    ld (v_l60f1h-BA1),a        ;69ff 32 31 03  2 1 . 
    call v_sub_665ah-BA1       ;6a02 cd 9a 08  . . . 
    ld (v_l8affh-BA1),de       ;6a05 ed 53 3f 2d  . S ? - 
    ld (v_l60d9h+1-BA1),sp     ;6a09 ed 73 1a 03  . s . . 
l6a0dh:
v_l60d9h:
    ld sp,00000h               ;6a0d 31 00 00  1 . . 
    call v_l82dbh-BA1          ;6a10 cd 1b 25  . . % 
    ld hl,v_l612dh-BA1         ;6a13 21 6d 03  ! m . 
    ld (080a0h-BA),hl          ;6a16 22 e0 22  " . " 
    call v_sub_6675h-BA1       ;6a19 cd b5 08  . . . 
    ld hl,02d40h               ;6a1c 21 40 2d  ! @ - 
    call v_sub_85aeh-BA1       ;6a1f cd ee 27  . . ' 
    cp 03ah                    ;6a22 fe 3a  . : 
    ret z                      ;6a24 c8  . 
v_l60f1h:
    jp v_l719dh-BA1            ;6a25 c3 dd 13  . . . 
    ld hl,v_l8affh-BA1         ;6a28 21 3f 2d  ! ? - 
l6a2bh:
    call v_sub_85aeh-BA1       ;6a2b cd ee 27  . . ' 
    ld c,009h                  ;6a2e 0e 09  . . 
    call v_sub_7ee7h-BA1       ;6a30 cd 27 21  . ' ! 
    call v_sub_664ch-BA1       ;6a33 cd 8c 08  . . . 
    call v_sub_79afh-BA1       ;6a36 cd ef 1b  . . . 
    call v_sub_664ch-BA1       ;6a39 cd 8c 08  . . . 
    call v_sub_78dah-BA1       ;6a3c cd 1a 1b  . . . 
    ld hl,(v_l7953h+1-BA1)     ;6a3f 2a 94 1b  * . . 
    ld (v_sub_664ch+1-BA1),hl                                  ;6a42 22 8d 08  " . . 
    xor a                      ;6a45 af  . 
    ret                        ;6a46 c9  . 
v_sub_6113h:
    ld hl,(v_l5dc3h-BA1)       ;6a47 2a 03 00  * . . 
    push af                    ;6a4a f5  . 
    ld a,l                     ;6a4b 7d  } 
    and 0e0h                   ;6a4c e6 e0  . . 
    ld l,a                     ;6a4e 6f  o 
    pop af                     ;6a4f f1  . 
    ret                        ;6a50 c9  . 
v_sub_611dh:
    call v_sub_6113h-BA1       ;6a51 cd 53 03  . S . 
    call v_sub_80b7h-BA1       ;6a54 cd f7 22  . . " 
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
    call v_sub_611dh-BA1       ;6a61 cd 5d 03  . ] . 
    jr l6a0dh                  ;6a64 18 a7  . . 
    call v_sub_60b3h-BA1       ;6a66 cd f3 02  . . . 
l6a69h:
    ld hl,(v_sub_664ch+1-BA1)                                  ;6a69 2a 8d 08  * . . 
    call v_sub_6d7ch-BA1       ;6a6c cd bc 0f  . . . 
    call v_sub_60b6h-BA1       ;6a6f cd f6 02  . . . 
    jr l6a69h                  ;6a72 18 f5  . . 
    ld hl,v_l68f2h+1-BA1       ;6a74 21 33 0b  ! 3 . 
l6a77h:
    jp v_l7c41h-BA1            ;6a77 c3 81 1e  . . . 
    ld hl,v_l6848h-BA1         ;6a7a 21 88 0a  ! . . 
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
    ld hl,v_l6aedh+1-BA1       ;6a8b 21 2e 0d  ! . . 
    jr l6a77h                  ;6a8e 18 e7  . . 
    ld hl,06a91h-BA            ;6a90 21 d1 0c  ! . . 
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
    call v_sub_66e7h-BA1       ;6a9e cd 27 09  . ' . 
    call c,v_sub_6d79h-BA1     ;6aa1 dc b9 0f  . . . 
    call 01f54h                ;6aa4 cd 54 1f  . T . 
    jr c,l6a9eh                ;6aa7 38 f5  8 . 
l6aa9h:
v_l6175h:
    xor a                      ;6aa9 af  . 
    in a,(0feh)                ;6aaa db fe  . . 
    cpl                        ;6aac 2f  / 
    and 01fh                   ;6aad e6 1f  . . 
    jr nz,l6aa9h               ;6aaf 20 f8    . 
    ret                        ;6ab1 c9  . 
    call v_sub_60c3h-BA1       ;6ab2 cd 03 03  . . . 
    jp 0cf22h                  ;6ab5 c3 22 cf  . " . 
    inc bc                     ;6ab8 03  . 
l6ab9h:
    call v_sub_66e7h-BA1       ;6ab9 cd 27 09  . ' . 
    call nc,v_sub_6d79h-BA1    ;6abc d4 b9 0f  . . . 
    ld hl,(0603bh-BA)          ;6abf 2a 7b 02  * { . 
    ld de,00000h               ;6ac2 11 00 00  . . . 
    or a                       ;6ac5 b7  . 
    sbc hl,de                  ;6ac6 ed 52  . R 
    ret z                      ;6ac8 c8  . 
    call 01f54h                ;6ac9 cd 54 1f  . T . 
    jr nc,l6aa9h               ;6acc 30 db  0 . 
    jr l6ab9h                  ;6ace 18 e9  . . 
    ld hl,010a6h               ;6ad0 21 a6 10  ! . . 
    jr l6a77h                  ;6ad3 18 a2  . . 
    call v_sub_66a8h-BA1       ;6ad5 cd e8 08  . . . 
    jr l6addh                  ;6ad8 18 03  . . 
    call v_sub_669bh-BA1       ;6ada cd db 08  . . . 
l6addh:
    push hl                    ;6add e5  . 
    push de                    ;6ade d5  . 
    call v_sub_60c3h-BA1       ;6adf cd 03 03  . . . 
    exx                        ;6ae2 d9  . 
    xor 03ah                   ;6ae3 ee 3a  . : 
    jr nz,l6b0ah               ;6ae5 20 23    # 
    ld ix,v_l8ad1h-BA1         ;6ae7 dd 21 11 2d  . ! . - 
    ld (ix+000h),003h          ;6aeb dd 36 00 03  . 6 . . 
    ld de,v_l8ad2h-BA1         ;6aef 11 12 2d  . . - 
    inc hl                     ;6af2 23  # 
    call v_sub_76bfh-BA1       ;6af3 cd ff 18  . . . 
    pop de                     ;6af6 d1  . 
    pop hl                     ;6af7 e1  . 
    push hl                    ;6af8 e5  . 
    push de                    ;6af9 d5  . 
    or a                       ;6afa b7  . 
    sbc hl,de                  ;6afb ed 52  . R 
    inc hl                     ;6afd 23  # 
    ld (v_l8adeh-BA1),de       ;6afe ed 53 1e 2d  . S . - 
    ld (v_l8adch-BA1),hl       ;6b02 22 1c 2d  " . - 
    call v_sub_769ah-BA1       ;6b05 cd da 18  . . . 
    ld l,0ffh                  ;6b08 2e ff  . . 
l6b0ah:
    call v_sub_61dch-BA1       ;6b0a cd 1c 04  . . . 
    jp 004c6h                  ;6b0d c3 c6 04  . . . 
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
    call v_sub_66a8h-BA1       ;6b1e cd e8 08  . . . 
    jr l6b26h                  ;6b21 18 03  . . 
    call v_sub_669bh-BA1       ;6b23 cd db 08  . . . 
l6b26h:
    call v_sub_66b3h-BA1       ;6b26 cd f3 08  . . . 
    call v_sub_60c3h-BA1       ;6b29 cd 03 03  . . . 
    exx                        ;6b2c d9  . 
l6b2dh:
    call v_sub_61dch-BA1       ;6b2d cd 1c 04  . . . 
    scf                        ;6b30 37  7 
    call v_sub_7bb1h-BA1       ;6b31 cd f1 1d  . . . 
    ret c                      ;6b34 d8  . 
    jp v_l66c4h-BA1            ;6b35 c3 04 09  . . . 
    call v_sub_6c47h-BA1       ;6b38 cd 87 0e  . . . 
    ld ix,v_l8affh-BA1         ;6b3b dd 21 3f 2d  . ! ? - 
    ld de,00012h               ;6b3f 11 12 00  . . . 
    xor a                      ;6b42 af  . 
    scf                        ;6b43 37  7 
    ex af,af'                  ;6b44 08  . 
    ld a,00fh                  ;6b45 3e 0f  > . 
    out (0feh),a               ;6b47 d3 fe  . . 
    call 00562h                ;6b49 cd 62 05  . b . 
    ld ix,02ce8h               ;6b4c dd 21 e8 2c  . ! . , 
    jr c,l6b5dh                ;6b50 38 0b  8 . 
    ld hl,(v_l8affh-BA1)       ;6b52 2a 3f 2d  * ? - 
    ld h,000h                  ;6b55 26 00  & . 
    call v_sub_6b02h-BA1       ;6b57 cd 42 0d  . B . 
    jp v_sub_6c4ah-BA1         ;6b5a c3 8a 0e  . . . 
l6b5dh:
    ld hl,02d40h               ;6b5d 21 40 2d  ! @ - 
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
    ld hl,(v_l8b0dh-BA1)       ;6b79 2a 4d 2d  * M - 
    push hl                    ;6b7c e5  . 
    call v_sub_6afch-BA1       ;6b7d cd 3c 0d  . < . 
    ld hl,(v_l8b0bh-BA1)       ;6b80 2a 4b 2d  * K - 
    push hl                    ;6b83 e5  . 
    call v_sub_6afch-BA1       ;6b84 cd 3c 0d  . < . 
    ld hl,(v_l8b0fh-BA1)       ;6b87 2a 4f 2d  * O - 
    call v_sub_6afch-BA1       ;6b8a cd 3c 0d  . < . 
    call v_sub_6c4ah-BA1       ;6b8d cd 8a 0e  . . . 
    call v_sub_8608h-BA1       ;6b90 cd 48 28  . H ( 
    pop hl                     ;6b93 e1  . 
    pop de                     ;6b94 d1  . 
    cp 06ah                    ;6b95 fe 6a  . j 
    ret nz                     ;6b97 c0  . 
    add hl,de                  ;6b98 19  . 
    dec hl                     ;6b99 2b  + 
    call v_sub_66b3h-BA1       ;6b9a cd f3 08  . . . 
    ld l,0ffh                  ;6b9d 2e ff  . . 
    jr l6b2dh                  ;6b9f 18 8c  . . 
    ld b,008h                  ;6ba1 06 08  . . 
    ld hl,v_l6fa9h-BA1         ;6ba3 21 e9 11  ! . . 
    ld de,v_l6f9dh-BA1         ;6ba6 11 dd 11  . . . 
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
    ld hl,v_l7332h-BA1         ;6bb3 21 72 15  ! r . 
l6bb6h:
    ld (004e4h),hl             ;6bb6 22 e4 04  " . . 
    ld hl,v_l62b6h-BA1         ;6bb9 21 f6 04  ! . . 
    ld (02079h),hl             ;6bbc 22 79 20  " y   
    call v_sub_66a8h-BA1       ;6bbf cd e8 08  . . . 
    push hl                    ;6bc2 e5  . 
    ld hl,v_l62b7h-BA1         ;6bc3 21 f7 04  ! . . 
    ld (080a0h-BA),hl          ;6bc6 22 e0 22  " . " 
    pop hl                     ;6bc9 e1  . 
    ex de,hl                   ;6bca eb  . 
l6bcbh:
    push de                    ;6bcb d5  . 
    call v_sub_6a0ah-BA1       ;6bcc cd 4a 0c  . J . 
    call v_sub_6c4ah-BA1       ;6bcf cd 8a 0e  . . . 
    push hl                    ;6bd2 e5  . 
    ld (004f8h),sp             ;6bd3 ed 73 f8 04  . s . . 
    call 00052h                ;6bd7 cd 52 00  . R . 
    di                         ;6bda f3  . 
l6bdbh:
    pop hl                     ;6bdb e1  . 
    pop de                     ;6bdc d1  . 
    call v_sub_675dh-BA1       ;6bdd cd 9d 09  . . . 
    jp nc,v_l6175h-BA1         ;6be0 d2 b5 03  . . . 
    push hl                    ;6be3 e5  . 
    or a                       ;6be4 b7  . 
    sbc hl,de                  ;6be5 ed 52  . R 
    pop hl                     ;6be7 e1  . 
    jr c,l6bcbh                ;6be8 38 e1  8 . 
v_l62b6h:
    ret                        ;6bea c9  . 
v_l62b7h:
    ld sp,00000h               ;6beb 31 00 00  1 . . 
    call v_sub_6675h-BA1       ;6bee cd b5 08  . . . 
    call v_sub_62dch-BA1       ;6bf1 cd 1c 05  . . . 
    jr l6bdbh                  ;6bf4 18 e5  . . 
    ld hl,v_l62b6h-BA1         ;6bf6 21 f6 04  ! . . 
    ld (02079h),hl             ;6bf9 22 79 20  " y   
    xor a                      ;6bfc af  . 
    ld (v_l6aedh+1-BA1),a      ;6bfd 32 2e 0d  2 . . 
    ld hl,v_l62d1h-BA1         ;6c00 21 11 05  ! . . 
    jr l6bb6h                  ;6c03 18 b1  . . 
v_l62d1h:
    ld hl,v_l8aa5h-BA1         ;6c05 21 e5 2c  ! . , 
    ld de,v_l8affh-BA1         ;6c08 11 3f 2d  . ? - 
    ld bc,00020h               ;6c0b 01 20 00  .   . 
    ldir                       ;6c0e ed b0  . . 
v_sub_62dch:
    call v_l82dbh-BA1          ;6c10 cd 1b 25  . . % 
    ld hl,v_l8affh-BA1         ;6c13 21 3f 2d  ! ? - 
    call v_sub_85aeh-BA1       ;6c16 cd ee 27  . . ' 
    ld d,000h                  ;6c19 16 00  . . 
    ld c,009h                  ;6c1b 0e 09  . . 
    jp v_l7e07h-BA1            ;6c1d c3 47 20  . G   
    cp 077h                    ;6c20 fe 77  . w 
    jr nz,l6c28h               ;6c22 20 04    . 
    ld (00553h),hl             ;6c24 22 53 05  " S . 
    ret                        ;6c27 c9  . 
l6c28h:
    push hl                    ;6c28 e5  . 
    ld (01b75h),hl             ;6c29 22 75 1b  " u . 
    ld de,v_l632bh-BA1         ;6c2c 11 6b 05  . k . 
    push de                    ;6c2f d5  . 
    call v_sub_631ah-BA1       ;6c30 cd 5a 05  . Z . 
    ld hl,v_l5f74h-BA1         ;6c33 21 b4 01  ! . . 
    ld (080a0h-BA),hl          ;6c36 22 e0 22  " . " 
    ld a,0c3h                  ;6c39 3e c3  > . 
    call v_sub_7931h-BA1       ;6c3b cd 71 1b  . q . 
    ld bc,v_l67ach-BA1         ;6c3e 01 ec 09  . . . 
    call v_sub_7962h-BA1       ;6c41 cd a2 1b  . . . 
    ld c,0c3h                  ;6c44 0e c3  . . 
    ld de,v_l67ach-BA1         ;6c46 11 ec 09  . . . 
    call 00575h                ;6c49 cd 75 05  . u . 
    pop hl                     ;6c4c e1  . 
    pop de                     ;6c4d d1  . 
v_sub_631ah:
    ld bc,v_l5dc3h-BA1         ;6c4e 01 03 00  . . . 
    ldir                       ;6c51 ed b0  . . 
    ld a,0ffh                  ;6c53 3e ff  > . 
v_sub_6321h:
    ld hl,v_l6f9bh-BA1         ;6c55 21 db 11  ! . . 
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
    call v_sub_60c3h-BA1       ;6c62 cd 03 03  . . . 
    call z,v_l6cabh-BA1        ;6c65 cc eb 0e  . . . 
    call 014cdh                ;6c68 cd cd 14  . . . 
    dec bc                     ;6c6b 0b  . 
    ld (hl),c                  ;6c6c 71  q 
    inc hl                     ;6c6d 23  # 
    ld (hl),e                  ;6c6e 73  s 
    inc hl                     ;6c6f 23  # 
    ld (hl),d                  ;6c70 72  r 
    inc hl                     ;6c71 23  # 
    call v_sub_68c3h-BA1       ;6c72 cd 03 0b  . . . 
    jp v_l6762h-BA1            ;6c75 c3 a2 09  . . . 
    call v_sub_66a8h-BA1       ;6c78 cd e8 08  . . . 
    jr l6c80h                  ;6c7b 18 03  . . 
    call v_sub_669bh-BA1       ;6c7d cd db 08  . . . 
l6c80h:
    push hl                    ;6c80 e5  . 
    push de                    ;6c81 d5  . 
    call v_sub_60c3h-BA1       ;6c82 cd 03 03  . . . 
    ret c                      ;6c85 d8  . 
    pop de                     ;6c86 d1  . 
    pop bc                     ;6c87 c1  . 
    push de                    ;6c88 d5  . 
    push hl                    ;6c89 e5  . 
    or a                       ;6c8a b7  . 
    sbc hl,de                  ;6c8b ed 52  . R 
    add hl,bc                  ;6c8d 09  . 
    pop bc                     ;6c8e c1  . 
    call v_sub_66b9h-BA1       ;6c8f cd f9 08  . . . 
    ex de,hl                   ;6c92 eb  . 
    sbc hl,bc                  ;6c93 ed 42  . B 
    inc hl                     ;6c95 23  # 
    ld d,b                     ;6c96 50  P 
    ld e,c                     ;6c97 59  Y 
    ld b,h                     ;6c98 44  D 
    ld c,l                     ;6c99 4d  M 
    pop hl                     ;6c9a e1  . 
    jp v_l88ech-BA1            ;6c9b c3 2c 2b  . , + 
    call v_sub_66a8h-BA1       ;6c9e cd e8 08  . . . 
    jr l6ca6h                  ;6ca1 18 03  . . 
    call v_sub_669bh-BA1       ;6ca3 cd db 08  . . . 
l6ca6h:
    call v_sub_66b3h-BA1       ;6ca6 cd f3 08  . . . 
    call v_sub_60c3h-BA1       ;6ca9 cd 03 03  . . . 
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
    call v_sub_60c3h-BA1       ;6cbe cd 03 03  . . . 
    jp nz,l87cdh               ;6cc1 c2 cd 87  . . . 
    ld c,0ddh                  ;6cc4 0e dd  . . 
    ld hl,v_l8aa5h-BA1         ;6cc6 21 e5 2c  ! . , 
    push hl                    ;6cc9 e5  . 
    call v_sub_8908h-BA1       ;6cca cd 48 2b  . H + 
    pop hl                     ;6ccd e1  . 
    inc ix                     ;6cce dd 23  . # 
    inc ix                     ;6cd0 dd 23  . # 
    push hl                    ;6cd2 e5  . 
    ld bc,00500h               ;6cd3 01 00 05  . . . 
l6cd6h:
    push hl                    ;6cd6 e5  . 
    ld l,(hl)                  ;6cd7 6e  n 
    ld h,000h                  ;6cd8 26 00  & . 
    ld a,(02b49h)              ;6cda 3a 49 2b  : I + 
    push bc                    ;6cdd c5  . 
    or a                       ;6cde b7  . 
    jr z,l6cech                ;6cdf 28 0b  ( . 
    ld (ix+000h),023h          ;6ce1 dd 36 00 23  . 6 . # 
    inc ix                     ;6ce5 dd 23  . # 
    call v_sub_891eh-BA1       ;6ce7 cd 5e 2b  . ^ + 
    jr l6cefh                  ;6cea 18 03  . . 
l6cech:
    call v_sub_8932h-BA1       ;6cec cd 72 2b  . r + 
l6cefh:
    pop bc                     ;6cef c1  . 
    inc ix                     ;6cf0 dd 23  . # 
    pop hl                     ;6cf2 e1  . 
    inc hl                     ;6cf3 23  # 
    djnz l6cd6h                ;6cf4 10 e0  . . 
    pop hl                     ;6cf6 e1  . 
    ld b,005h                  ;6cf7 06 05  . . 
l6cf9h:
v_l63c5h:
    call v_sub_63efh-BA1       ;6cf9 cd 2f 06  . / . 
    djnz l6cf9h                ;6cfc 10 fb  . . 
    call v_sub_5f64h-BA1       ;6cfe cd a4 01  . . . 
    jr $-60                    ;6d01 18 c2  . . 
    call v_sub_60c3h-BA1       ;6d03 cd 03 03  . . . 
    jp nz,l87cdh               ;6d06 c2 cd 87  . . . 
    ld c,0ddh                  ;6d09 0e dd  . . 
    ld hl,v_l8aa5h-BA1         ;6d0b 21 e5 2c  ! . , 
    push hl                    ;6d0e e5  . 
    call v_sub_6afeh-BA1       ;6d0f cd 3e 0d  . > . 
    pop hl                     ;6d12 e1  . 
    inc ix                     ;6d13 dd 23  . # 
    inc ix                     ;6d15 dd 23  . # 
    ld b,019h                  ;6d17 06 19  . . 
l6d19h:
    call v_sub_63efh-BA1       ;6d19 cd 2f 06  . / . 
    djnz l6d19h                ;6d1c 10 fb  . . 
    call v_sub_5f64h-BA1       ;6d1e cd a4 01  . . . 
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
    ld hl,0018dh               ;6d36 21 8d 01  ! . . 
l6d39h:
    push hl                    ;6d39 e5  . 
    call v_sub_65c1h-BA1       ;6d3a cd 01 08  . . . 
    pop hl                     ;6d3d e1  . 
    jr nz,l6d96h               ;6d3e 20 56    V 
    ld a,(hl)                  ;6d40 7e  ~ 
    cp 00bh                    ;6d41 fe 0b  . . 
    ret nc                     ;6d43 d0  . 
    push hl                    ;6d44 e5  . 
    dec a                      ;6d45 3d  = 
    add a,a                    ;6d46 87  . 
    call v_sub_6bd8h-BA1       ;6d47 cd 18 0e  . . . 
    inc hl                     ;6d4a 23  # 
    push hl                    ;6d4b e5  . 
    call v_sub_60c3h-BA1       ;6d4c cd 03 03  . . . 
    call z,0e1ebh              ;6d4f cc eb e1  . . . 
    ld (hl),e                  ;6d52 73  s 
    inc hl                     ;6d53 23  # 
    ld (hl),d                  ;6d54 72  r 
    pop hl                     ;6d55 e1  . 
    inc (hl)                   ;6d56 34  4 
    jr l6d39h                  ;6d57 18 e0  . . 
    ld a,031h                  ;6d59 3e 31  > 1 
    ld (01373h),a              ;6d5b 32 73 13  2 s . 
    ld b,005h                  ;6d5e 06 05  . . 
    ld hl,v_l64ceh-BA1         ;6d60 21 0e 07  ! . . 
l6d63h:
    push bc                    ;6d63 c5  . 
    push hl                    ;6d64 e5  . 
    call v_sub_60c3h-BA1       ;6d65 cd 03 03  . . . 
    jp c,03aeeh                ;6d68 da ee 3a  . . : 
    ld c,000h                  ;6d6b 0e 00  . . 
    jr z,l6d70h                ;6d6d 28 01  ( . 
    dec c                      ;6d6f 0d  . 
l6d70h:
    ld b,l                     ;6d70 45  E 
    ld hl,01373h               ;6d71 21 73 13  ! s . 
    inc (hl)                   ;6d74 34  4 
    pop hl                     ;6d75 e1  . 
    ld (hl),b                  ;6d76 70  p 
    inc hl                     ;6d77 23  # 
    ld (hl),c                  ;6d78 71  q 
    inc hl                     ;6d79 23  # 
    pop bc                     ;6d7a c1  . 
    djnz l6d63h                ;6d7b 10 e6  . . 
    ld de,(0603bh-BA)          ;6d7d ed 5b 7b 02  . [ { . 
    inc de                     ;6d81 13  . 
l6d82h:
    push de                    ;6d82 d5  . 
    ld hl,v_l64ceh-BA1         ;6d83 21 0e 07  ! . . 
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
    jp v_l6012h-BA1            ;6d93 c3 52 02  . R . 
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
    call v_sub_6bd8h-BA1       ;6da6 cd 18 0e  . . . 
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
    ld hl,v_l64c4h-BA1         ;6dbd 21 04 07  ! . . 
    call v_sub_6bd8h-BA1       ;6dc0 cd 18 0e  . . . 
    ld e,(hl)                  ;6dc3 5e  ^ 
    inc hl                     ;6dc4 23  # 
    ld d,(hl)                  ;6dc5 56  V 
    ex de,hl                   ;6dc6 eb  . 
l6dc7h:
    push hl                    ;6dc7 e5  . 
    call v_sub_65bbh-BA1       ;6dc8 cd fb 07  . . . 
    pop hl                     ;6dcb e1  . 
    jr nz,l6e0ch               ;6dcc 20 3e    > 
    ld a,(hl)                  ;6dce 7e  ~ 
    cp 007h                    ;6dcf fe 07  . . 
    ret nc                     ;6dd1 d0  . 
    push hl                    ;6dd2 e5  . 
    dec a                      ;6dd3 3d  = 
    add a,a                    ;6dd4 87  . 
    add a,a                    ;6dd5 87  . 
    call v_sub_6bd8h-BA1       ;6dd6 cd 18 0e  . . . 
    inc hl                     ;6dd9 23  # 
    push hl                    ;6dda e5  . 
    call v_sub_66a8h-BA1       ;6ddb cd e8 08  . . . 
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
    jp p,00c00h                ;6df8 f2 00 0c  . . . 
    ld bc,0013fh               ;6dfb 01 3f 01  . ? . 
    ld e,c                     ;6dfe 59  Y 
    ld bc,v_l5f33h-BA1         ;6dff 01 73 01  . s . 
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
    call v_sub_6bd8h-BA1       ;6e1d cd 18 0e  . . . 
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
    call v_sub_611dh-BA1       ;6e2d cd 5d 03  . ] . 
    jr l6e45h                  ;6e30 18 13  . . 
v_l64feh:
    call v_sub_665ah-BA1       ;6e32 cd 9a 08  . . . 
    ld hl,001c5h               ;6e35 21 c5 01  ! . . 
    ld (v_l8affh-BA1),hl       ;6e38 22 3f 2d  " ? - 
    ld hl,v_l64f9h-BA1         ;6e3b 21 39 07  ! 9 . 
    ld (080a0h-BA),hl          ;6e3e 22 e0 22  " . " 
    ld (00752h),sp             ;6e41 ed 73 52 07  . s R . 
l6e45h:
    ld sp,00000h               ;6e45 31 00 00  1 . . 
    call v_l82dbh-BA1          ;6e48 cd 1b 25  . . % 
    call v_sub_6675h-BA1       ;6e4b cd b5 08  . . . 
    ld b,018h                  ;6e4e 06 18  . . 
    ld ix,v_l5ddfh-BA1         ;6e50 dd 21 1f 00  . ! . . 
l6e54h:
    ld hl,02d40h               ;6e54 21 40 2d  ! @ - 
    call v_sub_85aeh-BA1       ;6e57 cd ee 27  . . ' 
    ld a,(ix+002h)             ;6e5a dd 7e 02  . ~ . 
    bit 7,a                    ;6e5d cb 7f  .  
    jr nz,l6e73h               ;6e5f 20 12    . 
    ld de,v_l8db4h-BA1         ;6e61 11 f4 2f  . . / 
    call v_sub_82c9h-BA1       ;6e64 cd 09 25  . . % 
    ld a,(de)                  ;6e67 1a  . 
    xor (hl)                   ;6e68 ae  . 
    and 05fh                   ;6e69 e6 5f  . _ 
    jr nz,l6e80h               ;6e6b 20 13    . 
    inc de                     ;6e6d 13  . 
    inc hl                     ;6e6e 23  # 
    call v_sub_85aeh-BA1       ;6e6f cd ee 27  . . ' 
    ld a,(de)                  ;6e72 1a  . 
l6e73h:
    xor (hl)                   ;6e73 ae  . 
    and 05fh                   ;6e74 e6 5f  . _ 
    jr nz,l6e80h               ;6e76 20 08    . 
    inc hl                     ;6e78 23  # 
    call v_sub_85aeh-BA1       ;6e79 cd ee 27  . . ' 
    cp 041h                    ;6e7c fe 41  . A 
    jr c,l6eafh                ;6e7e 38 2f  8 / 
l6e80h:
    ld de,00007h               ;6e80 11 07 00  . . . 
    add ix,de                  ;6e83 dd 19  . . 
    djnz l6e54h                ;6e85 10 cd  . . 
    jp v_l8081h-BA1            ;6e87 c3 c1 22  . . " 
l6e8ah:
    call v_sub_85aeh-BA1       ;6e8a cd ee 27  . . ' 
    or 020h                    ;6e8d f6 20  .   
    push hl                    ;6e8f e5  . 
    ld hl,v_l656bh-BA1         ;6e90 21 ab 07  ! . . 
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
    ld bc,0ef11h               ;6ea6 01 11 ef  . . . 
    ld de,0ae1ah               ;6ea9 11 1a ae  . . . 
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
    call v_sub_71a0h-BA1       ;6eb9 cd e0 13  . . . 
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
    ld hl,v_l6fd0h-BA1         ;6eda 21 10 12  ! . . 
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
    ld (v_l65deh-BA1),a        ;6ef9 32 1e 08  2 . . 
    ld (v_l65edh-BA1),a        ;6efc 32 2d 08  2 - . 
    ld (v_l6608h-BA1),a        ;6eff 32 48 08  2 H . 
    ld a,c                     ;6f02 79  y 
    ld (0085dh),a              ;6f03 32 5d 08  2 ] . 
    call v_sub_6c47h-BA1       ;6f06 cd 87 0e  . . . 
    dec hl                     ;6f09 2b  + 
    ld c,(hl)                  ;6f0a 4e  N 
    inc hl                     ;6f0b 23  # 
    ld de,v_l8aa5h-BA1         ;6f0c 11 e5 2c  . . , 
    call v_sub_65a3h-BA1       ;6f0f cd e3 07  . . . 
v_l65deh:
    scf                        ;6f12 37  7 
    ld c,0d6h                  ;6f13 0e d6  . . 
    call c,v_sub_65a3h-BA1     ;6f15 dc e3 07  . . . 
    call v_sub_6c4ah-BA1       ;6f18 cd 8a 0e  . . . 
    ld a,02fh                  ;6f1b 3e 2f  > / 
    ld (v_l8aa5h-BA1),a        ;6f1d 32 e5 2c  2 . , 
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
    ld ix,v_l8aa7h-BA1         ;6f2a dd 21 e7 2c  . ! . , 
    dec a                      ;6f2e 3d  = 
    jr z,l6f46h                ;6f2f 28 15  ( . 
    push af                    ;6f31 f5  . 
    inc (ix-002h)              ;6f32 dd 34 fe  . 4 . 
    ld (ix-001h),03ah          ;6f35 dd 36 ff 3a  . 6 . : 
    call v_sub_6622h-BA1       ;6f39 cd 62 08  . b . 
v_l6608h:
    scf                        ;6f3c 37  7 
    call c,v_sub_6622h-BA1     ;6f3d dc 62 08  . b . 
    call v_sub_6c4ah-BA1       ;6f40 cd 8a 0e  . . . 
    pop af                     ;6f43 f1  . 
    jr l6f2ah                  ;6f44 18 e4  . . 
l6f46h:
    call v_sub_8608h-BA1       ;6f46 cd 48 28  . H ( 
    cp 069h                    ;6f49 fe 69  . i 
    ret z                      ;6f4b c8  . 
    cp 030h                    ;6f4c fe 30  . 0 
l6f4eh:
    jr c,l6f53h                ;6f4e 38 03  8 . 
    cp 035h                    ;6f50 fe 35  . 5 
    ret c                      ;6f52 d8  . 
l6f53h:
    jp v_l5f74h-BA1            ;6f53 c3 b4 01  . . . 
v_sub_6622h:
    ld e,(hl)                  ;6f56 5e  ^ 
    inc hl                     ;6f57 23  # 
    ld d,(hl)                  ;6f58 56  V 
    inc hl                     ;6f59 23  # 
    push hl                    ;6f5a e5  . 
    ex de,hl                   ;6f5b eb  . 
    push hl                    ;6f5c e5  . 
    call v_sub_6afeh-BA1       ;6f5d cd 3e 0d  . > . 
    pop de                     ;6f60 d1  . 
    call v_sub_6b14h-BA1       ;6f61 cd 54 0d  . T . 
    push ix                    ;6f64 dd e5  . . 
    ld b,00ah                  ;6f66 06 0a  . . 
l6f68h:
    ld (ix+000h),020h          ;6f68 dd 36 00 20  . 6 .   
    inc ix                     ;6f6c dd 23  . # 
    djnz l6f68h                ;6f6e 10 f8  . . 
    pop hl                     ;6f70 e1  . 
    jr c,l6f7eh                ;6f71 38 0b  8 . 
    push hl                    ;6f73 e5  . 
    call v_sub_8116h-BA1       ;6f74 cd 56 23  . V # 
    pop hl                     ;6f77 e1  . 
    inc hl                     ;6f78 23  # 
    ld b,009h                  ;6f79 06 09  . . 
    call v_sub_82d4h-BA1       ;6f7b cd 14 25  . . % 
l6f7eh:
    pop hl                     ;6f7e e1  . 
    ret                        ;6f7f c9  . 
v_sub_664ch:
    ld hl,00000h               ;6f80 21 00 00  ! . . 
    ld (v_l7953h+1-BA1),hl     ;6f83 22 94 1b  " . . 
    ld (01b75h),hl             ;6f86 22 75 1b  " u . 
    ld ix,v_l8b22h-BA1         ;6f89 dd 21 62 2d  . ! b - 
    ret                        ;6f8d c9  . 
v_sub_665ah:
    ld hl,v_l8afeh-BA1         ;6f8e 21 3e 2d  ! > - 
    ld (hl),080h               ;6f91 36 80  6 . 
    inc hl                     ;6f93 23  # 
    ld (hl),001h               ;6f94 36 01  6 . 
    inc hl                     ;6f96 23  # 
    ld bc,02000h               ;6f97 01 00 20  . .   
    jp v_l82e1h-BA1            ;6f9a c3 21 25  . ! % 
v_sub_6669h:
    ld hl,v_l6fd0h-BA1         ;6f9d 21 10 12  ! . . 
    ld (02991h),hl             ;6fa0 22 91 29  " . ) 
    call v_sub_6113h-BA1       ;6fa3 cd 53 03  . S . 
    jp v_l85c7h-BA1            ;6fa6 c3 07 28  . . ( 
l6fa9h:
v_sub_6675h:
    call v_sub_6669h-BA1       ;6fa9 cd a9 08  . . . 
    call v_sub_8639h-BA1       ;6fac cd 79 28  . y ( 
    cp 080h                    ;6faf fe 80  . . 
    jr nc,l6fa9h               ;6fb1 30 f6  0 . 
    cp 004h                    ;6fb3 fe 04  . . 
    jp z,v_l5f74h-BA1          ;6fb5 ca b4 01  . . . 
    cp 003h                    ;6fb8 fe 03  . . 
    jr nz,l6fc4h               ;6fba 20 08    . 
    ld hl,(0207ch)             ;6fbc 2a 7c 20  * |   
    dec hl                     ;6fbf 2b  + 
    bit 7,(hl)                 ;6fc0 cb 7e  . ~ 
    jr nz,l6fa9h               ;6fc2 20 e5    . 
l6fc4h:
    call v_sub_7e3bh-BA1       ;6fc4 cd 7b 20  . {   
    jr nz,l6fa9h               ;6fc7 20 e0    . 
    call v_sub_6113h-BA1       ;6fc9 cd 53 03  . S . 
    jp v_sub_85f8h-BA1         ;6fcc c3 38 28  . 8 ( 
v_sub_669bh:
    call v_sub_60c3h-BA1       ;6fcf cd 03 03  . . . 
    jp nz,0cde5h               ;6fd2 c2 e5 cd  . . . 
    inc bc                     ;6fd5 03  . 
    inc bc                     ;6fd6 03  . 
    pop bc                     ;6fd7 c1  . 
    pop de                     ;6fd8 d1  . 
    add hl,de                  ;6fd9 19  . 
    dec hl                     ;6fda 2b  + 
    ret                        ;6fdb c9  . 
v_sub_66a8h:
    call v_sub_60c3h-BA1       ;6fdc cd 03 03  . . . 
    jp nz,0cde5h               ;6fdf c2 e5 cd  . . . 
    inc bc                     ;6fe2 03  . 
    inc bc                     ;6fe3 03  . 
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
    call v_sub_6bddh-BA1       ;6fee cd 1d 0e  . . . 
    ld hl,v_l66d8h-BA1         ;6ff1 21 18 09  ! . . 
    ld (022e3h),hl             ;6ff4 22 e3 22  " . " 
    ret nc                     ;6ff7 d0  . 
v_l66c4h:
    ld a,0cdh                  ;6ff8 3e cd  > . 
v_l66c6h:
    call v_sub_665ah-BA1       ;6ffa cd 9a 08  . . . 
    ld hl,v_l8affh-BA1         ;6ffd 21 3f 2d  ! ? - 
    ld (hl),a                  ;7000 77  w 
    inc hl                     ;7001 23  # 
    ld (hl),0d0h               ;7002 36 d0  6 . 
    call v_sub_6669h-BA1       ;7004 cd a9 08  . . . 
    ld a,000h                  ;7007 3e 00  > . 
    ld (v_l6f9bh-BA1),a        ;7009 32 db 11  2 . . 
v_l66d8h:
    call v_sub_6d79h-BA1       ;700c cd b9 0f  . . . 
    call v_sub_8713h-BA1       ;700f cd 53 29  . S ) 
    call v_sub_8639h-BA1       ;7012 cd 79 28  . y ( 
    call v_l6175h-BA1          ;7015 cd b5 03  . . . 
    jp v_l5f74h-BA1            ;7018 c3 b4 01  . . . 
v_sub_66e7h:
    ld hl,(0603bh-BA)          ;701b 2a 7b 02  * { . 
v_l66eah:
    push hl                    ;701e e5  . 
    call v_sub_6b56h-BA1       ;701f cd 96 0d  . . . 
    ex af,af'                  ;7022 08  . 
    jp nz,v_l5f74h-BA1         ;7023 c2 b4 01  . . . 
    ld (00a0bh),hl             ;7026 22 0b 0a  " . . 
    ld (009e8h),hl             ;7029 22 e8 09  " . . 
    ld (00c33h),de             ;702c ed 53 33 0c  . S 3 . 
    push bc                    ;7030 c5  . 
    ld a,(v_l6f9bh-BA1)        ;7031 3a db 11  : . . 
    ld (00914h),a              ;7034 32 14 09  2 . . 
    call v_sub_68e2h-BA1       ;7037 cd 22 0b  . " . 
    pop bc                     ;703a c1  . 
    pop de                     ;703b d1  . 
    push bc                    ;703c c5  . 
    call v_sub_68b4h-BA1       ;703d cd f4 0a  . . . 
    pop bc                     ;7040 c1  . 
    ld hl,v_l7066h-BA1         ;7041 21 a6 12  ! . . 
    call v_sub_6992h-BA1       ;7044 cd d2 0b  . . . 
    jr c,l7069h                ;7047 38 20  8   
    ld hl,v_l680bh-BA1         ;7049 21 4b 0a  ! K . 
    call v_sub_6bd8h-BA1       ;704c cd 18 0e  . . . 
    ld a,(hl)                  ;704f 7e  ~ 
    ld hl,v_l6813h-BA1         ;7050 21 53 0a  ! S . 
    call v_sub_6bd8h-BA1       ;7053 cd 18 0e  . . . 
    ld bc,v_l680ah-BA1         ;7056 01 4a 0a  . J . 
    ld a,(00a08h)              ;7059 3a 08 0a  : . . 
    call v_sub_6a53h-BA1       ;705c cd 93 0c  . . . 
    ld (009e8h),hl             ;705f 22 e8 09  " . . 
    ld (00990h),bc             ;7062 ed 43 90 09  . C . . 
    ld (009e5h),a              ;7066 32 e5 09  2 . . 
l7069h:
    call v_l6762h-BA1          ;7069 cd a2 09  . . . 
    ex af,af'                  ;706c 08  . 
    push af                    ;706d f5  . 
    exx                        ;706e d9  . 
    push hl                    ;706f e5  . 
    exx                        ;7070 d9  . 
    pop de                     ;7071 d1  . 
    ld hl,v_l5f33h-BA1         ;7072 21 73 01  ! s . 
    ld a,(v_l68f2h+1-BA1)      ;7075 3a 33 0b  : 3 . 
    or a                       ;7078 b7  . 
    call z,v_sub_6c20h-BA1     ;7079 cc 60 0e  . ` . 
    ld a,0ceh                  ;707c 3e ce  > . 
    jp c,v_l66c6h-BA1          ;707e da 06 09  . . . 
    pop af                     ;7081 f1  . 
    or a                       ;7082 b7  . 
    call nz,v_l680ah-BA1       ;7083 c4 4a 0a  . J . 
    exx                        ;7086 d9  . 
    ld (0603bh-BA),hl          ;7087 22 7b 02  " { . 
    ld hl,(v_l6fb3h-BA1)       ;708a 2a f3 11  * . . 
    add hl,de                  ;708d 19  . 
    ld (v_l6fb3h-BA1),hl       ;708e 22 f3 11  " . . 
v_sub_675dh:
    ld a,0bfh                  ;7091 3e bf  > . 
    jp 01f56h                  ;7093 c3 56 1f  . V . 
v_l6762h:
    ld a,0e9h                  ;7096 3e e9  > . 
    call v_sub_6321h-BA1       ;7098 cd 61 05  . a . 
    ld (00a21h),sp             ;709b ed 73 21 0a  . s ! . 
    ld sp,v_l6f9bh-BA1         ;709f 31 db 11  1 . . 
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
    ld sp,(v_l6fb1h-BA1)       ;70b7 ed 7b f1 11  . { . . 
    jp v_l8b21h-BA1            ;70bb c3 61 2d  . a - 
v_l678ah:
    ld (v_l6fb1h-BA1),sp       ;70be ed 73 f1 11  . s . . 
    ld sp,v_l8b21h-BA1         ;70c2 31 61 2d  1 a - 
    push af                    ;70c5 f5  . 
    ld a,i                     ;70c6 ed 57  . W 
    push af                    ;70c8 f5  . 
    ld a,r                     ;70c9 ed 5f  . _ 
    di                         ;70cb f3  . 
    push af                    ;70cc f5  . 
    pop af                     ;70cd f1  . 
    pop af                     ;70ce f1  . 
    pop af                     ;70cf f1  . 
    ld sp,v_l6fb1h-BA1         ;70d0 31 f1 11  1 . . 
    push af                    ;70d3 f5  . 
    push hl                    ;70d4 e5  . 
    push de                    ;70d5 d5  . 
    ld a,001h                  ;70d6 3e 01  > . 
    ld de,00000h               ;70d8 11 00 00  . . . 
    ld hl,00000h               ;70db 21 00 00  ! . . 
    jr l7102h                  ;70de 18 22  . " 
v_l67ach:
    nop                        ;70e0 00  . 
v_l67adh:
    ld (v_l6fb1h-BA1),sp       ;70e1 ed 73 f1 11  . s . . 
    ld sp,v_l8b21h-BA1         ;70e5 31 61 2d  1 a - 
    push af                    ;70e8 f5  . 
    ld a,i                     ;70e9 ed 57  . W 
    push af                    ;70eb f5  . 
    ld a,r                     ;70ec ed 5f  . _ 
    di                         ;70ee f3  . 
    push af                    ;70ef f5  . 
    pop af                     ;70f0 f1  . 
    pop af                     ;70f1 f1  . 
    pop af                     ;70f2 f1  . 
    ld sp,v_l6fb1h-BA1         ;70f3 31 f1 11  1 . . 
    push af                    ;70f6 f5  . 
    push hl                    ;70f7 e5  . 
    push de                    ;70f8 d5  . 
    ld a,000h                  ;70f9 3e 00  > . 
    ld de,00004h               ;70fb 11 04 00  . . . 
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
    ld sp,00000h               ;7114 31 00 00  1 . . 
    ld a,0dbh                  ;7117 3e db  > . 
    call v_sub_6321h-BA1       ;7119 cd 61 05  . a . 
    ld hl,v_l8b1dh-BA1         ;711c 21 5d 2d  ! ] - 
    ld a,(hl)                  ;711f 7e  ~ 
    dec hl                     ;7120 2b  + 
    dec hl                     ;7121 2b  + 
    or (hl)                    ;7122 b6  . 
    and 004h                   ;7123 e6 04  . . 
    rrca                       ;7125 0f  . 
    rrca                       ;7126 0f  . 
    ld (010a6h),a              ;7127 32 a6 10  2 . . 
    ret                        ;712a c9  . 
v_l67f7h:
    ld hl,(v_l6fb1h-BA1)       ;712b 2a f1 11  * . . 
    ld de,(00a0bh)             ;712e ed 5b 0b 0a  . [ . . 
    ld (hl),e                  ;7132 73  s 
    inc hl                     ;7133 23  # 
    ld (hl),d                  ;7134 72  r 
    ret                        ;7135 c9  . 
v_l6802h:
    ld hl,(v_l6fb1h-BA1)       ;7136 2a f1 11  * . . 
    inc hl                     ;7139 23  # 
    inc hl                     ;713a 23  # 
    ld (v_l6fb1h-BA1),hl       ;713b 22 f1 11  " . . 
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
    ld hl,v_l8b23h-BA1         ;7147 21 63 2d  ! c - 
    ld e,(hl)                  ;714a 5e  ^ 
    ld (hl),003h               ;714b 36 03  6 . 
    ld hl,(00a0bh)             ;714d 2a 0b 0a  * . . 
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
    ld de,(v_l8b23h-BA1)       ;7160 ed 5b 63 2d  . [ c - 
    ld (00a85h),sp             ;7164 ed 73 85 0a  . s . . 
    ld hl,0018dh               ;7168 21 8d 01  ! . . 
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
    ld hl,00a08h               ;717f 21 08 0a  ! . . 
    inc (hl)                   ;7182 34  4 
    ld bc,v_l67f7h-BA1         ;7183 01 37 0a  . 7 . 
l7186h:
    ld hl,(v_l8b23h-BA1)       ;7186 2a 63 2d  * c - 
    ld de,v_l8b28h-BA1         ;7189 11 68 2d  . h - 
    ld (v_l8b23h-BA1),de       ;718c ed 53 63 2d  . S c - 
    ret                        ;7190 c9  . 
    ld hl,(v_l6fb1h-BA1)       ;7191 2a f1 11  * . . 
    ld e,(hl)                  ;7194 5e  ^ 
    inc hl                     ;7195 23  # 
    ld d,(hl)                  ;7196 56  V 
    ld hl,v_l8b22h-BA1         ;7197 21 62 2d  ! b - 
    ld a,(hl)                  ;719a 7e  ~ 
    add a,002h                 ;719b c6 02  . . 
    cp 0cbh                    ;719d fe cb  . . 
    jr nz,l71a3h               ;719f 20 02    . 
    sub 008h                   ;71a1 d6 08  . . 
l71a3h:
    ld (hl),a                  ;71a3 77  w 
    call v_sub_68ceh-BA1       ;71a4 cd 0e 0b  . . . 
    ld a,00ah                  ;71a7 3e 0a  > . 
    ld bc,v_l6802h-BA1         ;71a9 01 42 0a  . B . 
    jr l71beh                  ;71ac 18 10  . . 
    ld hl,v_l8b22h-BA1         ;71ae 21 62 2d  ! b - 
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
    call v_sub_68c3h-BA1       ;71be cd 03 0b  . . . 
    jr l715bh                  ;71c1 18 98  . . 
    ld hl,(011edh)             ;71c3 2a ed 11  * . . 
    jr l71d4h                  ;71c6 18 0c  . . 
    ld hl,(011e7h)             ;71c8 2a e7 11  * . . 
    jr l71d0h                  ;71cb 18 03  . . 
    ld hl,(v_l6fa5h-BA1)       ;71cd 2a e5 11  * . . 
l71d0h:
    xor a                      ;71d0 af  . 
    ld (v_l8b23h-BA1),a        ;71d1 32 63 2d  2 c - 
l71d4h:
    xor a                      ;71d4 af  . 
    ld (v_l8b22h-BA1),a        ;71d5 32 62 2d  2 b - 
    ld (00a0bh),hl             ;71d8 22 0b 0a  " . . 
    ret                        ;71db c9  . 
    ld bc,v_l6802h-BA1         ;71dc 01 42 0a  . B . 
    ld hl,(v_l6fb1h-BA1)       ;71df 2a f1 11  * . . 
    ld e,(hl)                  ;71e2 5e  ^ 
    inc hl                     ;71e3 23  # 
    ld d,(hl)                  ;71e4 56  V 
    ex de,hl                   ;71e5 eb  . 
    jr l71d0h                  ;71e6 18 e8  . . 
v_sub_68b4h:
    ld hl,(00a0bh)             ;71e8 2a 0b 0a  * . . 
    and a                      ;71eb a7  . 
    sbc hl,de                  ;71ec ed 52  . R 
    ld b,h                     ;71ee 44  D 
    ld c,l                     ;71ef 4d  M 
    call v_sub_68d4h-BA1       ;71f0 cd 14 0b  . . . 
    ex de,hl                   ;71f3 eb  . 
    ldir                       ;71f4 ed b0  . . 
    ex de,hl                   ;71f6 eb  . 
v_sub_68c3h:
    ld de,v_l67adh-BA1         ;71f7 11 ed 09  . . . 
    call v_sub_68cch-BA1       ;71fa cd 0c 0b  . . . 
    ld de,v_l678ah-BA1         ;71fd 11 ca 09  . . . 
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
    ld hl,v_l8b21h-BA1         ;7208 21 61 2d  ! a - 
    ld a,(010a6h)              ;720b 3a a6 10  : . . 
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
    ld a,(010a6h)              ;721c 3a a6 10  : . . 
    or a                       ;721f b7  . 
    ret nz                     ;7220 c0  . 
    ld a,0cfh                  ;7221 3e cf  > . 
    jp v_l66c6h-BA1            ;7223 c3 06 09  . . . 
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
    ld bc,(v_l6fa9h-BA1)       ;7233 ed 4b e9 11  . K . . 
    ld de,(v_l6fabh-BA1)       ;7237 ed 5b eb 11  . [ . . 
    ld hl,(011edh)             ;723b 2a ed 11  * . . 
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
    call v_sub_7b3ah-BA1       ;7262 cd 7a 1d  . z . 
    dec hl                     ;7265 2b  + 
    dec hl                     ;7266 2b  + 
    dec hl                     ;7267 2b  + 
    dec hl                     ;7268 2b  + 
    dec hl                     ;7269 2b  + 
    ld (00a08h),hl             ;726a 22 08 0a  " . . 
    ld hl,00159h               ;726d 21 59 01  ! Y . 
    pop de                     ;7270 d1  . 
    pop bc                     ;7271 c1  . 
    call v_sub_6be8h-BA1       ;7272 cd 28 0e  . ( . 
    jp c,v_l66c4h-BA1          ;7275 da 04 09  . . . 
    ld hl,0013fh               ;7278 21 3f 01  ! ? . 
    pop de                     ;727b d1  . 
    pop bc                     ;727c c1  . 
    call v_sub_6be8h-BA1       ;727d cd 28 0e  . ( . 
    jp c,v_l66c4h-BA1          ;7280 da 04 09  . . . 
    exx                        ;7283 d9  . 
    ret                        ;7284 c9  . 
l7285h:
    exx                        ;7285 d9  . 
l7286h:
    ld hl,v_l6fb9h-BA1         ;7286 21 f9 11  ! . . 
    push de                    ;7289 d5  . 
    call v_sub_6992h-BA1       ;728a cd d2 0b  . . . 
    ld hl,0013fh               ;728d 21 3f 01  ! ? . 
    call v_sub_6969h-BA1       ;7290 cd a9 0b  . . . 
    ld hl,v_l700bh-BA1         ;7293 21 4b 12  ! K . 
    pop de                     ;7296 d1  . 
    call v_sub_6992h-BA1       ;7297 cd d2 0b  . . . 
    ld hl,00159h               ;729a 21 59 01  ! Y . 
v_sub_6969h:
    ret c                      ;729d d8  . 
    push hl                    ;729e e5  . 
    push af                    ;729f f5  . 
    ld hl,v_l69c3h-BA1         ;72a0 21 03 0c  ! . . 
    call v_sub_6bd8h-BA1       ;72a3 cd 18 0e  . . . 
    ld a,(hl)                  ;72a6 7e  ~ 
    ld hl,v_l69cbh-BA1         ;72a7 21 0b 0c  ! . . 
    call v_sub_6bd8h-BA1       ;72aa cd 18 0e  . . . 
    call v_sub_6a53h-BA1       ;72ad cd 93 0c  . . . 
    pop af                     ;72b0 f1  . 
    ex (sp),hl                 ;72b1 e3  . 
    pop de                     ;72b2 d1  . 
    push af                    ;72b3 f5  . 
    push hl                    ;72b4 e5  . 
    call v_sub_6c20h-BA1       ;72b5 cd 60 0e  . ` . 
    pop hl                     ;72b8 e1  . 
    jp c,v_l66c4h-BA1          ;72b9 da 04 09  . . . 
    pop af                     ;72bc f1  . 
    ret z                      ;72bd c8  . 
    inc de                     ;72be 13  . 
    call v_sub_6c20h-BA1       ;72bf cd 60 0e  . ` . 
    jp c,v_l66c4h-BA1          ;72c2 da 04 09  . . . 
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
    ld hl,v_l69c3h-BA1         ;72e7 21 03 0c  ! . . 
    call v_sub_6bd8h-BA1       ;72ea cd 18 0e  . . . 
    ld a,(hl)                  ;72ed 7e  ~ 
    ld hl,v_l69cbh-BA1         ;72ee 21 0b 0c  ! . . 
    call v_sub_6bd8h-BA1       ;72f1 cd 18 0e  . . . 
    call v_sub_6a53h-BA1       ;72f4 cd 93 0c  . . . 
v_l69c3h:
    nop                        ;72f7 00  . 
    inc b                      ;72f8 04  . 
    ex af,af'                  ;72f9 08  . 
    inc c                      ;72fa 0c  . 
    ld de,0211dh               ;72fb 11 1d 21  . . ! 
    daa                        ;72fe 27  ' 
v_l69cbh:
    ld hl,(v_l6fa9h-BA1)       ;72ff 2a e9 11  * . . 
    ret                        ;7302 c9  . 
    ld hl,(v_l6fabh-BA1)       ;7303 2a eb 11  * . . 
    ret                        ;7306 c9  . 
    ld hl,(011edh)             ;7307 2a ed 11  * . . 
    ret                        ;730a c9  . 
    ld hl,(011e7h)             ;730b 2a e7 11  * . . 
    jr l7313h                  ;730e 18 03  . . 
    ld hl,(v_l6fa5h-BA1)       ;7310 2a e5 11  * . . 
l7313h:
    bit 7,e                    ;7313 cb 7b  . { 
    ld d,000h                  ;7315 16 00  . . 
    jr z,l731ah                ;7317 28 01  ( . 
    dec d                      ;7319 15  . 
l731ah:
    add hl,de                  ;731a 19  . 
    ret                        ;731b c9  . 
    ld hl,(v_l6fb1h-BA1)       ;731c 2a f1 11  * . . 
    ret                        ;731f c9  . 
    ld hl,(v_l6fb1h-BA1)       ;7320 2a f1 11  * . . 
    dec hl                     ;7323 2b  + 
    dec hl                     ;7324 2b  + 
    ret                        ;7325 c9  . 
    ld hl,00000h               ;7326 21 00 00  ! . . 
    ret                        ;7329 c9  . 
l732ah:
    ld e,(hl)                  ;732a 5e  ^ 
    inc hl                     ;732b 23  # 
    ld d,(hl)                  ;732c 56  V 
    ld bc,00937h               ;732d 01 37 09  . 7 . 
    jr l733bh                  ;7330 18 09  . . 
l7332h:
    ld hl,(00ccah)             ;7332 2a ca 0c  * . . 
    ld d,000h                  ;7335 16 00  . . 
    ld e,(hl)                  ;7337 5e  ^ 
    ld bc,00637h               ;7338 01 37 06  . 7 . 
l733bh:
    inc hl                     ;733b 23  # 
    jr l736dh                  ;733c 18 2f  . / 
v_sub_6a0ah:
    ld a,000h                  ;733e 3e 00  > . 
    or a                       ;7340 b7  . 
    jr z,l7352h                ;7341 28 0f  ( . 
v_sub_6a0fh:
    ld a,020h                  ;7343 3e 20  >   
    ld b,a                     ;7345 47  G 
    ld de,v_l8aa5h-BA1         ;7346 11 e5 2c  . . , 
l7349h:
    ld (de),a                  ;7349 12  . 
    inc de                     ;734a 13  . 
    djnz l7349h                ;734b 10 fc  . . 
v_sub_6a19h:
    xor a                      ;734d af  . 
    ld (00c4bh),a              ;734e 32 4b 0c  2 K . 
    ret                        ;7351 c9  . 
l7352h:
    ld (00ccah),hl             ;7352 22 ca 0c  " . . 
    ex de,hl                   ;7355 eb  . 
    ld hl,000f2h               ;7356 21 f2 00  ! . . 
    call v_sub_6c20h-BA1       ;7359 cd 60 0e  . ` . 
    jr c,l7332h                ;735c 38 d4  8 . 
    ld hl,v_l5ecch-BA1         ;735e 21 0c 01  ! . . 
    call v_sub_6c20h-BA1       ;7361 cd 60 0e  . ` . 
    ex de,hl                   ;7364 eb  . 
    jr c,l732ah                ;7365 38 c3  8 . 
    call v_sub_6b56h-BA1       ;7367 cd 96 0d  . . . 
    ex af,af'                  ;736a 08  . 
    jr nz,l7332h               ;736b 20 c5    . 
l736dh:
    push hl                    ;736d e5  . 
    ld ix,v_l8b23h-BA1         ;736e dd 21 63 2d  . ! c - 
    ld (ix-001h),c             ;7372 dd 71 ff  . q . 
    ld (ix-002h),b             ;7375 dd 70 fe  . p . 
    ld a,c                     ;7378 79  y 
    and 007h                   ;7379 e6 07  . . 
    ld c,a                     ;737b 4f  O 
    ld b,000h                  ;737c 06 00  . . 
    ld hl,v_l6a54h-BA1         ;737e 21 94 0c  ! . . 
    add hl,bc                  ;7381 09  . 
    ld c,(hl)                  ;7382 4e  N 
    ld hl,v_l6a69h-BA1         ;7383 21 a9 0c  ! . . 
    add hl,bc                  ;7386 09  . 
v_sub_6a53h:
    jp (hl)                    ;7387 e9  . 
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
    call v_sub_6a5ch-BA1       ;739d cd 9c 0c  . . . 
    jr l73f0h                  ;73a0 18 4e  . N 
    call v_sub_6a5ch-BA1       ;73a2 cd 9c 0c  . . . 
    ld h,000h                  ;73a5 26 00  & . 
    ld l,e                     ;73a7 6b  k 
    push de                    ;73a8 d5  . 
    call v_sub_6b02h-BA1       ;73a9 cd 42 0d  . B . 
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
    ld hl,00001h               ;73bd 21 01 00  ! . . 
    inc hl                     ;73c0 23  # 
    inc hl                     ;73c1 23  # 
    add hl,de                  ;73c2 19  . 
    ex de,hl                   ;73c3 eb  . 
    ld c,000h                  ;73c4 0e 00  . . 
    dec c                      ;73c6 0d  . 
    jr z,l73f2h                ;73c7 28 29  ( ) 
    call v_sub_6b14h-BA1       ;73c9 cd 54 0d  . T . 
    jr c,l73d3h                ;73cc 38 05  8 . 
    call v_sub_6b07h-BA1       ;73ce cd 47 0d  . G . 
    jr l73f6h                  ;73d1 18 23  . # 
l73d3h:
    dec c                      ;73d3 0d  . 
    jr z,l73f2h                ;73d4 28 1c  ( . 
    dec de                     ;73d6 1b  . 
    call v_sub_6b14h-BA1       ;73d7 cd 54 0d  . T . 
    inc de                     ;73da 13  . 
    jr c,l73f2h                ;73db 38 15  8 . 
    dec de                     ;73dd 1b  . 
    call v_sub_6b07h-BA1       ;73de cd 47 0d  . G . 
    ld de,02b31h               ;73e1 11 31 2b  . 1 + 
    call v_sub_6b09h-BA1       ;73e4 cd 49 0d  . I . 
    jr l73f6h                  ;73e7 18 0d  . . 
    ld hl,(00ccah)             ;73e9 2a ca 0c  * . . 
    ld a,(hl)                  ;73ec 7e  ~ 
    and 038h                   ;73ed e6 38  . 8 
    ld e,a                     ;73ef 5f  _ 
l73f0h:
    ld d,000h                  ;73f0 16 00  . . 
l73f2h:
    ex de,hl                   ;73f2 eb  . 
    call v_sub_6b02h-BA1       ;73f3 cd 42 0d  . B . 
l73f6h:
v_l6ac2h:
    ld (ix+000h),0c0h          ;73f6 dd 36 00 c0  . 6 . . 
    ld ix,v_l8b21h-BA1         ;73fa dd 21 61 2d  . ! a - 
    call v_sub_8135h-BA1       ;73fe cd 75 23  . u # 
    ld ix,v_l8aa5h-BA1         ;7401 dd 21 e5 2c  . ! . , 
    ld de,(00ccah)             ;7405 ed 5b ca 0c  . [ . . 
    ld a,(06a91h-BA)           ;7409 3a d1 0c  : . . 
    dec a                      ;740c 3d  = 
    jr z,l7421h                ;740d 28 12  ( . 
    call v_sub_6b14h-BA1       ;740f cd 54 0d  . T . 
    jr c,l7421h                ;7412 38 0d  8 . 
    call v_sub_8116h-BA1       ;7414 cd 56 23  . V # 
    ld b,009h                  ;7417 06 09  . . 
    push ix                    ;7419 dd e5  . . 
    pop hl                     ;741b e1  . 
    call v_sub_82d4h-BA1       ;741c cd 14 25  . . % 
    jr l742eh                  ;741f 18 0d  . . 
l7421h:
v_l6aedh:
    ld a,001h                  ;7421 3e 01  > . 
    dec a                      ;7423 3d  = 
    jr nz,l742eh               ;7424 20 08    . 
    ex de,hl                   ;7426 eb  . 
    call v_sub_6afeh-BA1       ;7427 cd 3e 0d  . > . 
    ld (ix+000h),020h          ;742a dd 36 00 20  . 6 .   
l742eh:
    pop hl                     ;742e e1  . 
    ret                        ;742f c9  . 
v_sub_6afch:
    inc ix                     ;7430 dd 23  . # 
v_sub_6afeh:
    ld c,000h                  ;7432 0e 00  . . 
    jr l7438h                  ;7434 18 02  . . 
v_sub_6b02h:
    ld c,001h                  ;7436 0e 01  . . 
l7438h:
    jp v_sub_8908h-BA1         ;7438 c3 48 2b  . H + 
v_sub_6b07h:
    set 7,d                    ;743b cb fa  . . 
v_sub_6b09h:
    ld (ix+000h),d             ;743d dd 72 00  . r . 
    inc ix                     ;7440 dd 23  . # 
    ld (ix+000h),e             ;7442 dd 73 00  . s . 
    inc ix                     ;7445 dd 23  . # 
    ret                        ;7447 c9  . 
v_sub_6b14h:
    push bc                    ;7448 c5  . 
    exx                        ;7449 d9  . 
    ld de,00000h               ;744a 11 00 00  . . . 
    ld hl,(02a17h)             ;744d 2a 17 2a  * . * 
    ld c,(hl)                  ;7450 4e  N 
    inc hl                     ;7451 23  # 
    ld b,(hl)                  ;7452 46  F 
    inc hl                     ;7453 23  # 
    push hl                    ;7454 e5  . 
    add hl,bc                  ;7455 09  . 
    add hl,bc                  ;7456 09  . 
    ld (00d81h),hl             ;7457 22 81 0d  " . . 
    exx                        ;745a d9  . 
    pop hl                     ;745b e1  . 
    exx                        ;745c d9  . 
l745dh:
    ld a,b                     ;745d 78  x 
    or c                       ;745e b1  . 
    scf                        ;745f 37  7 
    jr z,l7487h                ;7460 28 25  ( % 
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
    ld bc,l9c38h               ;7474 01 38 9c  . 8 . 
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
    exx                        ;7487 d9  . 
    pop bc                     ;7488 c1  . 
    ret                        ;7489 c9  . 
v_sub_6b56h:
    ld a,(hl)                  ;748a 7e  ~ 
    and 0c7h                   ;748b e6 c7  . . 
    cp 0c7h                    ;748d fe c7  . . 
    ld b,a                     ;748f 47  G 
    ld c,000h                  ;7490 0e 00  . . 
    jr z,l74c2h                ;7492 28 2e  ( . 
    ld a,(hl)                  ;7494 7e  ~ 
    ld c,040h                  ;7495 0e 40  . @ 
    cp 0edh                    ;7497 fe ed  . . 
    jr z,l74c0h                ;7499 28 25  ( % 
    ld c,000h                  ;749b 0e 00  . . 
    cp 0ddh                    ;749d fe dd  . . 
    jr nz,l74a5h               ;749f 20 04    . 
    set 5,c                    ;74a1 cb e9  . . 
    jr l74abh                  ;74a3 18 06  . . 
l74a5h:
    cp 0fdh                    ;74a5 fe fd  . . 
    jr nz,l74bah               ;74a7 20 11    . 
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
    cp 0cbh                    ;74ba fe cb  . . 
    jr nz,l74c1h               ;74bc 20 03    . 
    set 7,c                    ;74be cb f9  . . 
l74c0h:
    inc hl                     ;74c0 23  # 
l74c1h:
    ld b,(hl)                  ;74c1 46  F 
l74c2h:
    inc hl                     ;74c2 23  # 
    push hl                    ;74c3 e5  . 
    ld e,(hl)                  ;74c4 5e  ^ 
    inc hl                     ;74c5 23  # 
    ld d,(hl)                  ;74c6 56  V 
l74c7h:
    push de                    ;74c7 d5  . 
    ld a,c                     ;74c8 79  y 
    cp 03fh                    ;74c9 fe 3f  . ? 
    jr nc,l74e0h               ;74cb 30 13  0 . 
    cp 010h                    ;74cd fe 10  . . 
    ld a,b                     ;74cf 78  x 
    jr nc,l74deh               ;74d0 30 0c  0 . 
    cp 018h                    ;74d2 fe 18  . . 
    jr z,l74e4h                ;74d4 28 0e  ( . 
    cp 0c9h                    ;74d6 fe c9  . . 
    jr z,l74e4h                ;74d8 28 0a  ( . 
    cp 0c3h                    ;74da fe c3  . . 
    jr z,l74e4h                ;74dc 28 06  ( . 
l74deh:
    cp 0e9h                    ;74de fe e9  . . 
l74e0h:
    ld a,000h                  ;74e0 3e 00  > . 
    jr nz,l74e6h               ;74e2 20 02    . 
l74e4h:
    ld a,001h                  ;74e4 3e 01  > . 
l74e6h:
    ld (00c4bh),a              ;74e6 32 4b 0c  2 K . 
    push bc                    ;74e9 c5  . 
    call v_sub_831ch-BA1       ;74ea cd 5c 25  . \ % 
    ex af,af'                  ;74ed 08  . 
    pop bc                     ;74ee c1  . 
    ld a,(hl)                  ;74ef 7e  ~ 
    and 01fh                   ;74f0 e6 1f  . . 
    ld (00a08h),a              ;74f2 32 08 0a  2 . . 
    xor a                      ;74f5 af  . 
    ld (00a09h),a              ;74f6 32 09 0a  2 . . 
    dec hl                     ;74f9 2b  + 
    dec hl                     ;74fa 2b  + 
    dec hl                     ;74fb 2b  + 
    ld a,(hl)                  ;74fc 7e  ~ 
    and 007h                   ;74fd e6 07  . . 
    or c                       ;74ff b1  . 
    ld c,a                     ;7500 4f  O 
    pop de                     ;7501 d1  . 
    and 007h                   ;7502 e6 07  . . 
    ld hl,v_l79fah-BA1         ;7504 21 3a 1c  ! : . 
    call v_sub_6bd8h-BA1       ;7507 cd 18 0e  . . . 
    ld a,(hl)                  ;750a 7e  ~ 
    pop hl                     ;750b e1  . 
v_sub_6bd8h:
    add a,l                    ;750c 85  . 
    ld l,a                     ;750d 6f  o 
    ret nc                     ;750e d0  . 
    inc h                      ;750f 24  $ 
    ret                        ;7510 c9  . 
v_sub_6bddh:
    ld (00e5dh),sp             ;7511 ed 73 5d 0e  . s ] . 
    ld a,002h                  ;7515 3e 02  > . 
    ld sp,0015ah               ;7517 31 5a 01  1 Z . 
    jr l7523h                  ;751a 18 07  . . 
v_sub_6be8h:
    ld (00e5dh),sp             ;751c ed 73 5d 0e  . s ] . 
    ld a,(hl)                  ;7520 7e  ~ 
    inc hl                     ;7521 23  # 
    ld sp,hl                   ;7522 f9  . 
l7523h:
    pop hl                     ;7523 e1  . 
    pop hl                     ;7524 e1  . 
    ld hl,(02a5ah)             ;7525 2a 5a 2a  * Z * 
    push hl                    ;7528 e5  . 
    ld hl,(01b72h)             ;7529 2a 72 1b  * r . 
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
    ld (00e84h),sp             ;7554 ed 73 84 0e  . s . . 
    ld a,(hl)                  ;7558 7e  ~ 
    inc hl                     ;7559 23  # 
    ld sp,hl                   ;755a f9  . 
    pop hl                     ;755b e1  . 
    pop hl                     ;755c e1  . 
    ld hl,(02a5ah)             ;755d 2a 5a 2a  * Z * 
    push hl                    ;7560 e5  . 
    ld hl,(01b72h)             ;7561 2a 72 1b  * r . 
    push hl                    ;7564 e5  . 
l7565h:
    dec a                      ;7565 3d  = 
    jr z,l7577h                ;7566 28 0f  ( . 
    pop hl                     ;7568 e1  . 
    or a                       ;7569 b7  . 
    sbc hl,de                  ;756a ed 52  . R 
    pop hl                     ;756c e1  . 
    jr z,l7571h                ;756d 28 02  ( . 
    jr nc,l7565h               ;756f 30 f4  0 . 
l7571h:
    and a                      ;7571 a7  . 
    sbc hl,de                  ;7572 ed 52  . R 
    ccf                        ;7574 3f  ? 
    jr nc,l7565h               ;7575 30 ee  0 . 
l7577h:
    ld sp,l8b91h               ;7577 31 91 8b  1 . . 
    ret                        ;757a c9  . 
v_sub_6c47h:
    call v_sub_6a0fh-BA1       ;757b cd 4f 0c  . O . 
v_sub_6c4ah:
    push hl                    ;757e e5  . 
    ld hl,(v_l5dcah-BA1)       ;757f 2a 0a 00  * . . 
    ld a,l                     ;7582 7d  } 
    and 0e0h                   ;7583 e6 e0  . . 
    ld l,a                     ;7585 6f  o 
    ld a,(v_l5dceh-BA1)        ;7586 3a 0e 00  : . . 
    and 01fh                   ;7589 e6 1f  . . 
    jp z,v_l5f74h-BA1          ;758b ca b4 01  . . . 
l758eh:
    dec a                      ;758e 3d  = 
    jr z,l759dh                ;758f 28 0c  ( . 
    ld d,h                     ;7591 54  T 
    ld e,l                     ;7592 5d  ] 
    ex af,af'                  ;7593 08  . 
    call v_sub_6f94h-BA1       ;7594 cd d4 11  . . . 
    call v_sub_7c83h-BA1       ;7597 cd c3 1e  . . . 
    ex af,af'                  ;759a 08  . 
    jr l758eh                  ;759b 18 f1  . . 
l759dh:
    ld (029c8h),hl             ;759d 22 c8 29  " . ) 
    pop hl                     ;75a0 e1  . 
v_sub_6c6dh:
    push hl                    ;75a1 e5  . 
    ld b,020h                  ;75a2 06 20  .   
    ld hl,v_l8aa4h-BA1         ;75a4 21 e4 2c  ! . , 
l75a7h:
    call v_sub_85adh-BA1       ;75a7 cd ed 27  . . ' 
    cp 020h                    ;75aa fe 20  .   
    jr nc,l75b0h               ;75ac 30 02  0 . 
    ld a,020h                  ;75ae 3e 20  >   
l75b0h:
    call v_sub_8769h-BA1       ;75b0 cd a9 29  . . ) 
    djnz l75a7h                ;75b3 10 f2  . . 
    pop hl                     ;75b5 e1  . 
    ret                        ;75b6 c9  . 
v_l6c83h:
    ld hl,05800h               ;75b7 21 00 58  ! . X 
    ld bc,v_l5dc3h-BA1         ;75ba 01 03 00  . . . 
    push hl                    ;75bd e5  . 
    push bc                    ;75be c5  . 
l75bfh:
    ld (hl),039h               ;75bf 36 39  6 9 
    inc hl                     ;75c1 23  # 
    djnz l75bfh                ;75c2 10 fb  . . 
    dec c                      ;75c4 0d  . 
    jr nz,l75bfh               ;75c5 20 f8    . 
    call v_sub_6d84h-BA1       ;75c7 cd c4 0f  . . . 
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
v_l6cabh:
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
    ld bc,00000h               ;75ed 01 00 00  . . . 
    ld ix,v_l5dc3h-BA1         ;75f0 dd 21 03 00  . ! . . 
    add ix,bc                  ;75f4 dd 09  . . 
    push bc                    ;75f6 c5  . 
    ld a,028h                  ;75f7 3e 28  > ( 
    ld (029bch),a              ;75f9 32 bc 29  2 . ) 
    call v_sub_6db1h-BA1       ;75fc cd f1 0f  . . . 
    ld a,038h                  ;75ff 3e 38  > 8 
    ld (029bch),a              ;7601 32 bc 29  2 . ) 
    call v_sub_8608h-BA1       ;7604 cd 48 28  . H ( 
    pop bc                     ;7607 c1  . 
    cp 004h                    ;7608 fe 04  . . 
    ret z                      ;760a c8  . 
    ld hl,v_l6c83h-BA1         ;760b 21 c3 0e  ! . . 
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
    ld (00efah),a              ;7628 32 fa 0e  2 . . 
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
    call v_sub_6f94h-BA1       ;7642 cd d4 11  . . . 
    djnz l7642h                ;7645 10 fb  . . 
    jr l7659h                  ;7647 18 10  . . 
l7649h:
    cp 035h                    ;7649 fe 35  . 5 
    jr nz,l7660h               ;764b 20 13    . 
    ld b,01fh                  ;764d 06 1f  . . 
l764fh:
    call v_sub_6f88h-BA1       ;764f cd c8 11  . . . 
    djnz l764fh                ;7652 10 fb  . . 
    jr l7640h                  ;7654 18 ea  . . 
l7656h:
    call v_sub_6f88h-BA1       ;7656 cd c8 11  . . . 
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
    ld hl,v_l6d67h-BA1         ;7683 21 a7 0f  ! . . 
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
    ld hl,(0603bh-BA)          ;76ad 2a 7b 02  * { . 
v_sub_6d7ch:
    ld ix,v_l5dd1h-BA1         ;76b0 dd 21 11 00  . ! . . 
    ld b,020h                  ;76b4 06 20  .   
    jr l76beh                  ;76b6 18 06  . . 
v_sub_6d84h:
    ld ix,v_l5dc3h-BA1         ;76b8 dd 21 03 00  . ! . . 
    ld b,022h                  ;76bc 06 22  . " 
l76beh:
    ld (010b9h),hl             ;76be 22 b9 10  " . . 
l76c1h:
    push bc                    ;76c1 c5  . 
    call v_sub_6dabh-BA1       ;76c2 cd eb 0f  . . . 
    ld bc,00007h               ;76c5 01 07 00  . . . 
    add ix,bc                  ;76c8 dd 09  . . 
    pop bc                     ;76ca c1  . 
    djnz l76c1h                ;76cb 10 f4  . . 
    ret                        ;76cd c9  . 
l76ceh:
    ld a,028h                  ;76ce 3e 28  > ( 
    call v_sub_8769h-BA1       ;76d0 cd a9 29  . . ) 
    pop hl                     ;76d3 e1  . 
    push hl                    ;76d4 e5  . 
    call v_sub_6f5dh-BA1       ;76d5 cd 9d 11  . . . 
    ld a,029h                  ;76d8 3e 29  > ) 
l76dah:
    call v_sub_8767h-BA1       ;76da cd a7 29  . . ) 
    jr l770dh                  ;76dd 18 2e  . . 
v_sub_6dabh:
    ld a,(ix+004h)             ;76df dd 7e 04  . ~ . 
    and 01fh                   ;76e2 e6 1f  . . 
    ret z                      ;76e4 c8  . 
v_sub_6db1h:
    xor a                      ;76e5 af  . 
l76e6h:
    ld (01135h),a              ;76e6 32 35 11  2 5 . 
    call v_sub_6e8ah-BA1       ;76e9 cd ca 10  . . . 
    ld l,(ix+005h)             ;76ec dd 6e 05  . n . 
    ld h,(ix+006h)             ;76ef dd 66 06  . f . 
    ld a,(ix+003h)             ;76f2 dd 7e 03  . ~ . 
    and 003h                   ;76f5 e6 03  . . 
    dec a                      ;76f7 3d  = 
    jr nz,l76feh               ;76f8 20 04    . 
    ld e,(hl)                  ;76fa 5e  ^ 
    inc hl                     ;76fb 23  # 
    ld d,(hl)                  ;76fc 56  V 
    ex de,hl                   ;76fd eb  . 
l76feh:
    push hl                    ;76fe e5  . 
    ld a,(ix+002h)             ;76ff dd 7e 02  . ~ . 
    cp 0d8h                    ;7702 fe d8  . . 
    jr nc,l76ceh               ;7704 30 c8  0 . 
    cp 080h                    ;7706 fe 80  . . 
    jr nc,l76dah               ;7708 30 d0  0 . 
    call v_sub_6f6fh-BA1       ;770a cd af 11  . . . 
l770dh:
    ld a,03ah                  ;770d 3e 3a  > : 
    call v_sub_8769h-BA1       ;770f cd a9 29  . . ) 
    pop de                     ;7712 d1  . 
    ld a,(ix+004h)             ;7713 dd 7e 04  . ~ . 
    and 01fh                   ;7716 e6 1f  . . 
    ld hl,(029c8h)             ;7718 2a c8 29  * . ) 
l771bh:
    ld bc,0112ch               ;771b 01 2c 11  . , . 
    or a                       ;771e b7  . 
    ret z                      ;771f c8  . 
    push af                    ;7720 f5  . 
    push hl                    ;7721 e5  . 
    ld a,(de)                  ;7722 1a  . 
    ld l,a                     ;7723 6f  o 
    inc de                     ;7724 13  . 
    ld a,(de)                  ;7725 1a  . 
    ld h,a                     ;7726 67  g 
    ld a,(ix+003h)             ;7727 dd 7e 03  . ~ . 
    bit 3,a                    ;772a cb 5f  . _ 
    jr z,l772fh                ;772c 28 01  ( . 
    inc de                     ;772e 13  . 
l772fh:
    push de                    ;772f d5  . 
    ld e,a                     ;7730 5f  _ 
    and 003h                   ;7731 e6 03  . . 
    jp z,v_l6e9ch-BA1          ;7733 ca dc 10  . . . 
    cp 003h                    ;7736 fe 03  . . 
    jr nc,l7777h               ;7738 30 3d  0 = 
    ld d,004h                  ;773a 16 04  . . 
l773ch:
    bit 3,(ix+003h)            ;773c dd cb 03 5e  . . . ^ 
    push bc                    ;7740 c5  . 
    jr z,l7744h                ;7741 28 01  ( . 
    inc bc                     ;7743 03  . 
l7744h:
    push ix                    ;7744 dd e5  . . 
    ld ix,v_l6f01h-BA1         ;7746 dd 21 41 11  . ! A . 
    ld a,(bc)                  ;774a 0a  . 
    ld b,000h                  ;774b 06 00  . . 
    ld c,a                     ;774d 4f  O 
    add ix,bc                  ;774e dd 09  . . 
    rl e                       ;7750 cb 13  . . 
    push de                    ;7752 d5  . 
    push hl                    ;7753 e5  . 
    call c,v_sub_6ef4h-BA1     ;7754 dc 34 11  . 4 . 
    pop hl                     ;7757 e1  . 
    pop de                     ;7758 d1  . 
    pop ix                     ;7759 dd e1  . . 
    pop bc                     ;775b c1  . 
    inc bc                     ;775c 03  . 
    inc bc                     ;775d 03  . 
    dec d                      ;775e 15  . 
    jr nz,l773ch               ;775f 20 db    . 
    pop de                     ;7761 d1  . 
    pop hl                     ;7762 e1  . 
    bit 2,(ix+003h)            ;7763 dd cb 03 56  . . . V 
    jr z,l7773h                ;7767 28 0a  ( . 
    call v_sub_6f94h-BA1       ;7769 cd d4 11  . . . 
    ld (029c8h),hl             ;776c 22 c8 29  " . ) 
    xor a                      ;776f af  . 
    ld (01135h),a              ;7770 32 35 11  2 5 . 
l7773h:
    pop af                     ;7773 f1  . 
    dec a                      ;7774 3d  = 
    jr l771bh                  ;7775 18 a4  . . 
l7777h:
    pop de                     ;7777 d1  . 
    pop hl                     ;7778 e1  . 
    pop af                     ;7779 f1  . 
v_l6e46h:
    call v_sub_6e8ah-BA1       ;777a cd ca 10  . . . 
    rlca                       ;777d 07  . 
    rlca                       ;777e 07  . 
    rlca                       ;777f 07  . 
    ld l,a                     ;7780 6f  o 
    ld h,000h                  ;7781 26 00  & . 
    add hl,hl                  ;7783 29  ) 
    add hl,hl                  ;7784 29  ) 
l7785h:
    ld a,(ix+002h)             ;7785 dd 7e 02  . ~ . 
    cp 0c4h                    ;7788 fe c4  . . 
    jr z,l77a3h                ;778a 28 17  ( . 
    cp 0a3h                    ;778c fe a3  . . 
    jr z,l7799h                ;778e 28 09  ( . 
    call v_sub_8767h-BA1       ;7790 cd a7 29  . . ) 
    dec hl                     ;7793 2b  + 
    ld a,h                     ;7794 7c  | 
    or l                       ;7795 b5  . 
    jr nz,l7785h               ;7796 20 ed    . 
    ret                        ;7798 c9  . 
l7799h:
    ld a,000h                  ;7799 3e 00  > . 
    add a,003h                 ;779b c6 03  . . 
    ld de,v_l8c76h-BA1         ;779d 11 b6 2e  . . . 
    jp v_l6f72h-BA1            ;77a0 c3 b2 11  . . . 
l77a3h:
    ld a,(ix+004h)             ;77a3 dd 7e 04  . ~ . 
    and 01fh                   ;77a6 e6 1f  . . 
    ld b,a                     ;77a8 47  G 
    call v_sub_6a19h-BA1       ;77a9 cd 59 0c  . Y . 
    ld hl,00000h               ;77ac 21 00 00  ! . . 
    push ix                    ;77af dd e5  . . 
l77b1h:
    push bc                    ;77b1 c5  . 
    call v_sub_6a0ah-BA1       ;77b2 cd 4a 0c  . J . 
    call v_sub_6c6dh-BA1       ;77b5 cd ad 0e  . . . 
    pop bc                     ;77b8 c1  . 
    djnz l77b1h                ;77b9 10 f6  . . 
    pop ix                     ;77bb dd e1  . . 
    ret                        ;77bd c9  . 
v_sub_6e8ah:
    ld l,(ix+000h)             ;77be dd 6e 00  . n . 
    ld h,(ix+001h)             ;77c1 dd 66 01  . f . 
    ld (029c8h),hl             ;77c4 22 c8 29  " . ) 
    ret                        ;77c7 c9  . 
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
    pop af                     ;77d0 f1  . 
    pop af                     ;77d1 f1  . 
    ld a,l                     ;77d2 7d  } 
    ex af,af'                  ;77d3 08  . 
    ld c,l                     ;77d4 4d  M 
    ld b,004h                  ;77d5 06 04  . . 
    bit 5,e                    ;77d7 cb 6b  . k 
    call v_sub_6e8ah-BA1       ;77d9 cd ca 10  . . . 
    push hl                    ;77dc e5  . 
    ld hl,v_l6ee0h-BA1         ;77dd 21 20 11  !   . 
    jr z,l77f8h                ;77e0 28 16  ( . 
    ld de,v_l6e94h-BA1         ;77e2 11 d4 10  . . . 
    call v_sub_6f75h-BA1       ;77e5 cd b5 11  . . . 
    pop hl                     ;77e8 e1  . 
    call v_sub_6f94h-BA1       ;77e9 cd d4 11  . . . 
    ld (029c8h),hl             ;77ec 22 c8 29  " . ) 
    ex af,af'                  ;77ef 08  . 
    call v_sub_6f36h-BA1       ;77f0 cd 76 11  . v . 
    pop hl                     ;77f3 e1  . 
    ret                        ;77f4 c9  . 
l77f5h:
    call v_sub_8765h-BA1       ;77f5 cd a5 29  . . ) 
l77f8h:
    ld a,(hl)                  ;77f8 7e  ~ 
    inc hl                     ;77f9 23  # 
    and c                      ;77fa a1  . 
    jr nz,l7801h               ;77fb 20 04    . 
    inc hl                     ;77fd 23  # 
    ld a,(hl)                  ;77fe 7e  ~ 
    jr l7803h                  ;77ff 18 02  . . 
l7801h:
    ld a,(hl)                  ;7801 7e  ~ 
    inc hl                     ;7802 23  # 
l7803h:
    inc hl                     ;7803 23  # 
    push af                    ;7804 f5  . 
    rlca                       ;7805 07  . 
    call c,v_sub_8765h-BA1     ;7806 dc a5 29  . . ) 
    pop af                     ;7809 f1  . 
    and 07fh                   ;780a e6 7f  .  
    call v_sub_6f6fh-BA1       ;780c cd af 11  . . . 
    djnz l77f5h                ;780f 10 e4  . . 
    pop de                     ;7811 d1  . 
    pop hl                     ;7812 e1  . 
    ret                        ;7813 c9  . 
v_l6ee0h:
    ld b,b                     ;7814 40  @ 
    sub h                      ;7815 94  . 
    jr nz,l7819h               ;7816 20 01    . 
    adc a,e                    ;7818 8b  . 
l7819h:
    rra                        ;7819 1f  . 
    inc b                      ;781a 04  . 
    ld hl,08022h               ;781b 21 22 80  ! " . 
    ld de,00012h               ;781e 11 12 00  . . . 
    ex af,af'                  ;7821 08  . 
    djnz $+32                  ;7822 10 1e  . . 
    inc (hl)                   ;7824 34  4 
    jr nc,l786eh               ;7825 30 47  0 G 
    ld b,e                     ;7827 43  C 
v_sub_6ef4h:
    ld a,000h                  ;7828 3e 00  > . 
    or a                       ;782a b7  . 
    call nz,v_sub_8765h-BA1    ;782b c4 a5 29  . . ) 
    ld a,001h                  ;782e 3e 01  > . 
    ld (01135h),a              ;7830 32 35 11  2 5 . 
    jp (ix)                    ;7833 dd e9  . . 
v_l6f01h:
    call v_sub_6f66h-BA1       ;7835 cd a6 11  . . . 
    call v_sub_8932h-BA1       ;7838 cd 72 2b  . r + 
    jr l7859h                  ;783b 18 1c  . . 
    call v_sub_6f68h-BA1       ;783d cd a8 11  . . . 
    call v_sub_8926h-BA1       ;7840 cd 66 2b  . f + 
    jr l7859h                  ;7843 18 14  . . 
    call v_sub_6f66h-BA1       ;7845 cd a6 11  . . . 
    ld (ix+000h),023h          ;7848 dd 36 00 23  . 6 . # 
    inc ix                     ;784c dd 23  . # 
    call v_sub_891eh-BA1       ;784e cd 5e 2b  . ^ + 
    jr l7859h                  ;7851 18 06  . . 
    call v_sub_6f68h-BA1       ;7853 cd a8 11  . . . 
    call v_sub_890dh-BA1       ;7856 cd 4d 2b  . M + 
l7859h:
    ld hl,v_l8ac7h-BA1         ;7859 21 07 2d  ! . - 
l785ch:
    ld a,(hl)                  ;785c 7e  ~ 
    or a                       ;785d b7  . 
    ret z                      ;785e c8  . 
    call v_sub_8769h-BA1       ;785f cd a9 29  . . ) 
    inc hl                     ;7862 23  # 
    jr l785ch                  ;7863 18 f7  . . 
    ld a,h                     ;7865 7c  | 
    call v_sub_6f36h-BA1       ;7866 cd 76 11  . v . 
    ld a,l                     ;7869 7d  } 
v_sub_6f36h:
    ld c,a                     ;786a 4f  O 
    ld b,008h                  ;786b 06 08  . . 
l786dh:
    xor a                      ;786d af  . 
l786eh:
    rl c                       ;786e cb 11  . . 
    adc a,030h                 ;7870 ce 30  . 0 
    call v_sub_8769h-BA1       ;7872 cd a9 29  . . ) 
    djnz l786dh                ;7875 10 f6  . . 
    ret                        ;7877 c9  . 
    ld a,h                     ;7878 7c  | 
    call v_sub_6f4eh-BA1       ;7879 cd 8e 11  . . . 
    xor a                      ;787c af  . 
    ld h,l                     ;787d 65  e 
    ld (01135h),a              ;787e 32 35 11  2 5 . 
    ld a,h                     ;7881 7c  | 
v_sub_6f4eh:
    ld h,a                     ;7882 67  g 
    and 07fh                   ;7883 e6 7f  .  
    cp 020h                    ;7885 fe 20  .   
    ld a,h                     ;7887 7c  | 
    jr nc,l788eh               ;7888 30 04  0 . 
    and 080h                   ;788a e6 80  . . 
    or 02eh                    ;788c f6 2e  . . 
l788eh:
    jp v_sub_8769h-BA1         ;788e c3 a9 29  . . ) 
v_sub_6f5dh:
    push ix                    ;7891 dd e5  . . 
    call v_sub_8902h-BA1       ;7893 cd 42 2b  . B + 
    pop ix                     ;7896 dd e1  . . 
    jr l7859h                  ;7898 18 bf  . . 
v_sub_6f66h:
    ld h,000h                  ;789a 26 00  & . 
v_sub_6f68h:
    ld ix,v_l8ac7h-BA1         ;789c dd 21 07 2d  . ! . - 
    ld c,000h                  ;78a0 0e 00  . . 
    ret                        ;78a2 c9  . 
v_sub_6f6fh:
    ld de,v_l8db4h-BA1         ;78a3 11 f4 2f  . . / 
v_l6f72h:
    call v_sub_82c9h-BA1       ;78a6 cd 09 25  . . % 
l78a9h:
v_sub_6f75h:
    ld a,(de)                  ;78a9 1a  . 
    res 7,a                    ;78aa cb bf  . . 
    call v_sub_872eh-BA1       ;78ac cd 6e 29  . n ) 
    jr nz,l78b3h               ;78af 20 02    . 
    sub 020h                   ;78b1 d6 20  .   
l78b3h:
    call v_sub_8767h-BA1       ;78b3 cd a7 29  . . ) 
    ld a,(de)                  ;78b6 1a  . 
    inc de                     ;78b7 13  . 
    rla                        ;78b8 17  . 
    jr nc,l78a9h               ;78b9 30 ee  0 . 
    ret                        ;78bb c9  . 
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
    ld a,l                     ;78c8 7d  } 
    add a,020h                 ;78c9 c6 20  .   
    ld l,a                     ;78cb 6f  o 
    ret nc                     ;78cc d0  . 
    jr l78beh                  ;78cd 18 ef  . . 
v_l6f9bh:
    nop                        ;78cf 00  . 
    nop                        ;78d0 00  . 
v_l6f9dh:
    nop                        ;78d1 00  . 
    nop                        ;78d2 00  . 
    nop                        ;78d3 00  . 
    nop                        ;78d4 00  . 
    nop                        ;78d5 00  . 
    nop                        ;78d6 00  . 
    nop                        ;78d7 00  . 
    nop                        ;78d8 00  . 
v_l6fa5h:
    ld a,(0005ch)              ;78d9 3a 5c 00  : \ . 
    nop                        ;78dc 00  . 
v_l6fa9h:
    rst 38h                    ;78dd ff  . 
    xor a                      ;78de af  . 
v_l6fabh:
    ld bc,00001h               ;78df 01 01 00  . . . 
    nop                        ;78e2 00  . 
    nop                        ;78e3 00  . 
    nop                        ;78e4 00  . 
v_l6fb1h:
    nop                        ;78e5 00  . 
    nop                        ;78e6 00  . 
v_l6fb3h:
    nop                        ;78e7 00  . 
    nop                        ;78e8 00  . 
    nop                        ;78e9 00  . 
    nop                        ;78ea 00  . 
    nop                        ;78eb 00  . 
    nop                        ;78ec 00  . 
v_l6fb9h:
    dec de                     ;78ed 1b  . 
    rst 38h                    ;78ee ff  . 
    ex (sp),hl                 ;78ef e3  . 
    dec c                      ;78f0 0d  . 
    rst 38h                    ;78f1 ff  . 
    ex (sp),hl                 ;78f2 e3  . 
    dec e                      ;78f3 1d  . 
    rst 38h                    ;78f4 ff  . 
    ex (sp),hl                 ;78f5 e3  . 
    dec l                      ;78f6 2d  - 
    rst 38h                    ;78f7 ff  . 
    ret                        ;78f8 c9  . 
    dec c                      ;78f9 0d  . 
    rst 8                      ;78fa cf  . 
    pop bc                     ;78fb c1  . 
    dec c                      ;78fc 0d  . 
v_l6fc9h:
    rst 0                      ;78fd c7  . 
    ret nz                     ;78fe c0  . 
    dec c                      ;78ff 0d  . 
    rst 30h                    ;7900 f7  . 
    and b                      ;7901 a0  . 
    ld b,d                     ;7902 42  B 
    rst 0                      ;7903 c7  . 
v_l6fd0h:
    add a,(hl)                 ;7904 86  . 
    inc d                      ;7905 14  . 
    rst 0                      ;7906 c7  . 
    add a,(hl)                 ;7907 86  . 
    inc hl                     ;7908 23  # 
    rst 0                      ;7909 c7  . 
    add a,(hl)                 ;790a 86  . 
    ld (bc),a                  ;790b 02  . 
    rst 8                      ;790c cf  . 
    ld c,e                     ;790d 4b  K 
    ld c,a                     ;790e 4f  O 
    rst 0                      ;790f c7  . 
    ld b,(hl)                  ;7910 46  F 
    inc d                      ;7911 14  . 
    rst 0                      ;7912 c7  . 
    ld b,(hl)                  ;7913 46  F 
    inc hl                     ;7914 23  # 
    rst 0                      ;7915 c7  . 
    ld b,(hl)                  ;7916 46  F 
    ld (bc),a                  ;7917 02  . 
    rst 30h                    ;7918 f7  . 
    ld b,l                     ;7919 45  E 
    ld b,l                     ;791a 45  E 
    rst 38h                    ;791b ff  . 
    ld a,(0fe07h)              ;791c 3a 07 fe  : . . 
    inc (hl)                   ;791f 34  4 
    inc d                      ;7920 14  . 
    cp 034h                    ;7921 fe 34  . 4 
    inc hl                     ;7923 23  # 
    cp 034h                    ;7924 fe 34  . 4 
    ld (bc),a                  ;7926 02  . 
    rst 38h                    ;7927 ff  . 
    ld hl,(0ff0fh)             ;7928 2a 0f ff  * . . 
    ld hl,(0ff1fh)             ;792b 2a 1f ff  * . . 
    ld hl,(0ff2fh)             ;792e 2a 2f ff  * / . 
    ld a,(de)                  ;7931 1a  . 
    ld bc,00affh               ;7932 01 ff 0a  . . . 
    nop                        ;7935 00  . 
    add a,a                    ;7936 87  . 
    ld b,094h                  ;7937 06 94  . . 
    add a,a                    ;7939 87  . 
    ld b,0a3h                  ;793a 06 a3  . . 
    add a,a                    ;793c 87  . 
    ld b,082h                  ;793d 06 82  . . 
v_l700bh:
    ld e,0ffh                  ;793f 1e ff  . . 
    ex (sp),hl                 ;7941 e3  . 
    dec c                      ;7942 0d  . 
    rst 38h                    ;7943 ff  . 
    ex (sp),hl                 ;7944 e3  . 
    dec e                      ;7945 1d  . 
    rst 38h                    ;7946 ff  . 
    ex (sp),hl                 ;7947 e3  . 
    dec l                      ;7948 2d  - 
    rst 38h                    ;7949 ff  . 
    call 0c70eh                ;794a cd 0e c7  . . . 
    rst 0                      ;794d c7  . 
    ld c,0cfh                  ;794e 0e cf  . . 
    push bc                    ;7950 c5  . 
    ld c,0c7h                  ;7951 0e c7  . . 
    call nz,0f70eh             ;7953 c4 0e f7  . . . 
    and b                      ;7956 a0  . 
    ld b,c                     ;7957 41  A 
    add a,a                    ;7958 87  . 
    add a,(hl)                 ;7959 86  . 
    sub h                      ;795a 94  . 
    add a,a                    ;795b 87  . 
    add a,(hl)                 ;795c 86  . 
    and e                      ;795d a3  . 
    add a,a                    ;795e 87  . 
    add a,(hl)                 ;795f 86  . 
    add a,d                    ;7960 82  . 
    ret m                      ;7961 f8  . 
    ld (hl),b                  ;7962 70  p 
    inc d                      ;7963 14  . 
    ret m                      ;7964 f8  . 
    ld (hl),b                  ;7965 70  p 
    inc hl                     ;7966 23  # 
    ret m                      ;7967 f8  . 
    ld (hl),b                  ;7968 70  p 
    ld (bc),a                  ;7969 02  . 
    rst 8                      ;796a cf  . 
    ld b,e                     ;796b 43  C 
    ld c,a                     ;796c 4f  O 
    rst 38h                    ;796d ff  . 
    ld (hl),014h               ;796e 36 14  6 . 
    rst 38h                    ;7970 ff  . 
    ld (hl),023h               ;7971 36 23  6 # 
    rst 38h                    ;7973 ff  . 
    ld (hl),002h               ;7974 36 02  6 . 
    cp 034h                    ;7976 fe 34  . 4 
    inc d                      ;7978 14  . 
    cp 034h                    ;7979 fe 34  . 4 
    inc hl                     ;797b 23  # 
    cp 034h                    ;797c fe 34  . 4 
    ld (bc),a                  ;797e 02  . 
    rst 38h                    ;797f ff  . 
    ld (0ff07h),a              ;7980 32 07 ff  2 . . 
    ld (0ff0fh),hl             ;7983 22 0f ff  " . . 
    ld (0ff1fh),hl             ;7986 22 1f ff  " . . 
    ld (0ff2fh),hl             ;7989 22 2f ff  " / . 
    ld (de),a                  ;798c 12  . 
    ld bc,006c7h               ;798d 01 c7 06  . . . 
    sub h                      ;7990 94  . 
    rst 0                      ;7991 c7  . 
    ld b,0a3h                  ;7992 06 a3  . . 
    rst 0                      ;7994 c7  . 
    ld b,082h                  ;7995 06 82  . . 
    rst 38h                    ;7997 ff  . 
    ld (bc),a                  ;7998 02  . 
    nop                        ;7999 00  . 
v_l7066h:
    ld c,0ffh                  ;799a 0e ff  . . 
    jp (hl)                    ;799c e9  . 
    ld d,0ffh                  ;799d 16 ff  . . 
    jp (hl)                    ;799f e9  . 
    dec h                      ;79a0 25  % 
    rst 38h                    ;79a1 ff  . 
    jp (hl)                    ;79a2 e9  . 
    inc b                      ;79a3 04  . 
    rst 38h                    ;79a4 ff  . 
    call 0ff01h                ;79a5 cd 01 ff  . . . 
    ret                        ;79a8 c9  . 
    ld (bc),a                  ;79a9 02  . 
    rst 0                      ;79aa c7  . 
    rst 0                      ;79ab c7  . 
    inc bc                     ;79ac 03  . 
    rst 0                      ;79ad c7  . 
    call nz,0ff01h             ;79ae c4 01 ff  . . . 
    jp 0c701h                  ;79b1 c3 01 c7  . . . 
    jp nz,0c701h               ;79b4 c2 01 c7  . . . 
    ret nz                     ;79b7 c0  . 
    ld (bc),a                  ;79b8 02  . 
    rst 30h                    ;79b9 f7  . 
    ld b,l                     ;79ba 45  E 
    ld b,a                     ;79bb 47  G 
    rst 20h                    ;79bc e7  . 
    jr nz,l79bfh               ;79bd 20 00    . 
l79bfh:
    rst 38h                    ;79bf ff  . 
    jr l79c2h                  ;79c0 18 00  . . 
l79c2h:
    rst 38h                    ;79c2 ff  . 
    djnz l79c5h                ;79c3 10 00  . . 
l79c5h:
    ld a,(de)                  ;79c5 1a  . 
    rra                        ;79c6 1f  . 
    inc hl                     ;79c7 23  # 
    ld h,02bh                  ;79c8 26 2b  & + 
    inc l                      ;79ca 2c  , 
    dec a                      ;79cb 3d  = 
    ccf                        ;79cc 3f  ? 
    ld b,c                     ;79cd 41  A 
    ld b,e                     ;79ce 43  C 
    ld b,l                     ;79cf 45  E 
    ld b,a                     ;79d0 47  G 
    ld c,d                     ;79d1 4a  J 
    ld d,e                     ;79d2 53  S 
    ld d,l                     ;79d3 55  U 
    ld e,l                     ;79d4 5d  ] 
    ld h,c                     ;79d5 61  a 
    ld h,(hl)                  ;79d6 66  f 
    ld l,l                     ;79d7 6d  m 
    ld (hl),e                  ;79d8 73  s 
    halt                       ;79d9 76  v 
    ld a,c                     ;79da 79  y 
    add a,b                    ;79db 80  . 
    add a,e                    ;79dc 83  . 
    add a,h                    ;79dd 84  . 
    adc a,c                    ;79de 89  . 
    ld c,h                     ;79df 4c  L 
    ld h,l                     ;79e0 65  e 
    ld l,(hl)                  ;79e1 6e  n 
    ld h,a                     ;79e2 67  g 
    ld (hl),h                  ;79e3 74  t 
    ret pe                     ;79e4 e8  . 
    ld b,(hl)                  ;79e5 46  F 
    ld l,c                     ;79e6 69  i 
    ld (hl),d                  ;79e7 72  r 
    ld (hl),e                  ;79e8 73  s 
    call p,sub_614ch           ;79e9 f4 4c 61  . L a 
    ld (hl),e                  ;79ec 73  s 
    call p,sub_654dh           ;79ed f4 4d 65  . M e 
    ld l,l                     ;79f0 6d  m 
    ld l,a                     ;79f1 6f  o 
    ld (hl),d                  ;79f2 72  r 
    ld sp,hl                   ;79f3 f9  . 
    ld l,h                     ;79f4 6c  l 
    call po,05520h             ;79f5 e4 20 55  .   U 
    ld c,(hl)                  ;79f8 4e  N 
    ld c,c                     ;79f9 49  I 
    ld d,(hl)                  ;79fa 56  V 
    ld b,l                     ;79fb 45  E 
    ld d,d                     ;79fc 52  R 
    ld d,e                     ;79fd 53  S 
    ld d,l                     ;79fe 55  U 
    ld c,l                     ;79ff 4d  M 
    jr nz,l7a45h               ;7a00 20 43    C 
    ld l,a                     ;7a02 6f  o 
    ld l,(hl)                  ;7a03 6e  n 
    ld (hl),h                  ;7a04 74  t 
    ld (hl),d                  ;7a05 72  r 
    ld l,a                     ;7a06 6f  o 
    call pe,04e4fh             ;7a07 ec 4f 4e  . O N 
    and b                      ;7a0a a0  . 
    ld c,a                     ;7a0b 4f  O 
    ld b,(hl)                  ;7a0c 46  F 
    add a,04eh                 ;7a0d c6 4e  . N 
    ld c,a                     ;7a0f 4f  O 
    adc a,044h                 ;7a10 ce 44  . D 
    ld b,l                     ;7a12 45  E 
    add a,041h                 ;7a13 c6 41  . A 
    ld c,h                     ;7a15 4c  L 
    call z,sub_6143h           ;7a16 cc 43 61  . C a 
    ld l,h                     ;7a19 6c  l 
    call pe,sub_6552h          ;7a1a ec 52 65  . R e 
    ld h,c                     ;7a1d 61  a 
    ld h,h                     ;7a1e 64  d 
    cpl                        ;7a1f 2f  / 
    ld d,a                     ;7a20 57  W 
    ld (hl),d                  ;7a21 72  r 
    ld l,c                     ;7a22 69  i 
    ld (hl),h                  ;7a23 74  t 
    push hl                    ;7a24 e5  . 
    ld d,d                     ;7a25 52  R 
    ld (hl),l                  ;7a26 75  u 
    xor 049h                   ;7a27 ee 49  . I 
    ld l,(hl)                  ;7a29 6e  n 
    ld (hl),h                  ;7a2a 74  t 
    ld h,l                     ;7a2b 65  e 
    ld (hl),d                  ;7a2c 72  r 
    ld (hl),d                  ;7a2d 72  r 
    ld (hl),l                  ;7a2e 75  u 
    ld (hl),b                  ;7a2f 70  p 
    call p,05245h              ;7a30 f4 45 52  . E R 
    ld d,d                     ;7a33 52  R 
    ld c,a                     ;7a34 4f  O 
    jp nc,l6f4eh               ;7a35 d2 4e 6f  . N o 
    jr nz,l7aach               ;7a38 20 72    r 
    ld (hl),l                  ;7a3a 75  u 
    xor 04eh                   ;7a3b ee 4e  . N 
    ld l,a                     ;7a3d 6f  o 
    jr nz,$+121                ;7a3e 20 77    w 
    ld (hl),d                  ;7a40 72  r 
    ld l,c                     ;7a41 69  i 
    ld (hl),h                  ;7a42 74  t 
    push hl                    ;7a43 e5  . 
    ld c,(hl)                  ;7a44 4e  N 
l7a45h:
    ld l,a                     ;7a45 6f  o 
    jr nz,l7abah               ;7a46 20 72    r 
    ld h,l                     ;7a48 65  e 
    ld h,c                     ;7a49 61  a 
    call po,sub_6544h          ;7a4a e4 44 65  . D e 
    ld h,(hl)                  ;7a4d 66  f 
    jp po,sub_6544h            ;7a4e e2 44 65  . D e 
    ld h,(hl)                  ;7a51 66  f 
    rst 30h                    ;7a52 f7  . 
    ld (hl),a                  ;7a53 77  w 
    ld l,c                     ;7a54 69  i 
    ld l,(hl)                  ;7a55 6e  n 
    ld h,h                     ;7a56 64  d 
    ld l,a                     ;7a57 6f  o 
    ld (hl),a                  ;7a58 77  w 
    ld (hl),e                  ;7a59 73  s 
    cp d                       ;7a5a ba  . 
    ld d,a                     ;7a5b 57  W 
    ld l,c                     ;7a5c 69  i 
    ld (hl),h                  ;7a5d 74  t 
    ret pe                     ;7a5e e8  . 
    ld d,h                     ;7a5f 54  T 
    rst 28h                    ;7a60 ef  . 
    ld c,h                     ;7a61 4c  L 
    ld h,l                     ;7a62 65  e 
    ld h,c                     ;7a63 61  a 
    ld h,h                     ;7a64 64  d 
    ld h,l                     ;7a65 65  e 
    jp p,02e31h                ;7a66 f2 31 2e  . 1 . 
    jr nz,l7acdh               ;7a69 20 62    b 
    ld a,c                     ;7a6b 79  y 
    ld (hl),h                  ;7a6c 74  t 
    ld h,l                     ;7a6d 65  e 
    cp d                       ;7a6e ba  . 
    nop                        ;7a6f 00  . 
    nop                        ;7a70 00  . 
    nop                        ;7a71 00  . 
    nop                        ;7a72 00  . 
    nop                        ;7a73 00  . 
    nop                        ;7a74 00  . 
    nop                        ;7a75 00  . 
    nop                        ;7a76 00  . 
    nop                        ;7a77 00  . 
    nop                        ;7a78 00  . 
    nop                        ;7a79 00  . 
    nop                        ;7a7a 00  . 
    nop                        ;7a7b 00  . 
    jp v_l7cc9h-BA1            ;7a7c c3 09 1f  . . . 
    sbc a,a                    ;7a7f 9f  . 
    ld a,(de)                  ;7a80 1a  . 
    add a,(hl)                 ;7a81 86  . 
    ld e,07fh                  ;7a82 1e 7f  .  
    inc l                      ;7a84 2c  , 
    add a,e                    ;7a85 83  . 
    dec d                      ;7a86 15  . 
    add a,013h                 ;7a87 c6 13  . . 
    pop hl                     ;7a89 e1  . 
    inc d                      ;7a8a 14  . 
    cp e                       ;7a8b bb  . 
    add hl,de                  ;7a8c 19  . 
    ld a,c                     ;7a8d 79  y 
l7a8eh:
    ld e,0bbh                  ;7a8e 1e bb  . . 
    add hl,de                  ;7a90 19  . 
    cp e                       ;7a91 bb  . 
    add hl,de                  ;7a92 19  . 
    cp a                       ;7a93 bf  . 
    inc de                     ;7a94 13  . 
    ld d,(hl)                  ;7a95 56  V 
    add hl,de                  ;7a96 19  . 
    rlca                       ;7a97 07  . 
    ld e,0b7h                  ;7a98 1e b7  . . 
    ld de,011b7h               ;7a9a 11 b7 11  . . . 
    ld e,c                     ;7a9d 59  Y 
    dec d                      ;7a9e 15  . 
    dec d                      ;7a9f 15  . 
    ld e,0f0h                  ;7aa0 1e f0  . . 
    ld e,047h                  ;7aa2 1e 47  . G 
    jr l7a8eh                  ;7aa4 18 e8  . . 
    ld d,0d6h                  ;7aa6 16 d6  . . 
    inc de                     ;7aa8 13  . 
    rra                        ;7aa9 1f  . 
    add hl,de                  ;7aaa 19  . 
    ld a,(hl)                  ;7aab 7e  ~ 
l7aach:
    ld e,016h                  ;7aac 1e 16  . . 
    rla                        ;7aae 17  . 
    ld d,017h                  ;7aaf 16 17  . . 
    ld (hl),c                  ;7ab1 71  q 
    inc d                      ;7ab2 14  . 
    ld hl,03e68h               ;7ab3 21 68 3e  ! h > 
l7ab6h:
    ld (v_sub_826ch+1-BA1),hl                                  ;7ab6 22 ad 24  " . $ 
    ret                        ;7ab9 c9  . 
l7abah:
    call v_sub_718eh-BA1       ;7aba cd ce 13  . . . 
    call v_sub_8235h-BA1       ;7abd cd 75 24  . u $ 
    jr l7ab6h                  ;7ac0 18 f4  . . 
v_sub_718eh:
    ld hl,(02a17h)             ;7ac2 2a 17 2a  * . * 
    ld de,0fff4h               ;7ac5 11 f4 ff  . . . 
    add hl,de                  ;7ac8 19  . 
    ret                        ;7ac9 c9  . 
    call v_l719dh-BA1          ;7aca cd dd 13  . . . 
l7acdh:
    ld (01b86h),hl             ;7acd 22 86 1b  " . . 
    ret                        ;7ad0 c9  . 
v_l719dh:
    ld hl,02d40h               ;7ad1 21 40 2d  ! @ - 
v_sub_71a0h:
    ld de,v_l8ad1h-BA1         ;7ad4 11 11 2d  . . - 
    push de                    ;7ad7 d5  . 
    ld c,01eh                  ;7ad8 0e 1e  . . 
    call v_sub_8577h-BA1       ;7ada cd b7 27  . . ' 
    pop de                     ;7add d1  . 
    ld hl,00000h               ;7ade 21 00 00  ! . . 
    ld a,02bh                  ;7ae1 3e 2b  > + 
    ld ix,v_l8aa5h-BA1         ;7ae3 dd 21 e5 2c  . ! . , 
l7ae7h:
    push hl                    ;7ae7 e5  . 
    push af                    ;7ae8 f5  . 
    call v_sub_8492h-BA1       ;7ae9 cd d2 26  . . & 
    jp c,v_l8089h-BA1          ;7aec da c9 22  . . " 
    cp 02bh                    ;7aef fe 2b  . + 
    jr z,l7afah                ;7af1 28 07  ( . 
    ld (01449h),a              ;7af3 32 49 14  2 I . 
    cp 02dh                    ;7af6 fe 2d  . - 
    jr nz,l7afdh               ;7af8 20 03    . 
l7afah:
    call v_sub_8492h-BA1       ;7afa cd d2 26  . . & 
l7afdh:
    cp 024h                    ;7afd fe 24  . $ 
    ld hl,(v_l7953h+1-BA1)     ;7aff 2a 94 1b  * . . 
    jr z,l7b31h                ;7b02 28 2d  ( - 
    call v_sub_872eh-BA1       ;7b04 cd 6e 29  . n ) 
    jr nz,l7b36h               ;7b07 20 2d    - 
    dec de                     ;7b09 1b  . 
    push de                    ;7b0a d5  . 
    push ix                    ;7b0b dd e5  . . 
    ex de,hl                   ;7b0d eb  . 
    call v_sub_87aah-BA1       ;7b0e cd ea 29  . . ) 
    ld a,009h                  ;7b11 3e 09  > . 
    jp c,v_l809ah-BA1          ;7b13 da da 22  . . " 
    pop ix                     ;7b16 dd e1  . . 
    ex de,hl                   ;7b18 eb  . 
    call v_sub_8116h-BA1       ;7b19 cd 56 23  . V # 
    ld a,(hl)                  ;7b1c 7e  ~ 
    and 0c0h                   ;7b1d e6 c0  . . 
    ld a,009h                  ;7b1f 3e 09  > . 
    jp z,v_l809ah-BA1          ;7b21 ca da 22  . . " 
    dec de                     ;7b24 1b  . 
    ex de,hl                   ;7b25 eb  . 
    ld d,(hl)                  ;7b26 56  V 
    dec hl                     ;7b27 2b  + 
    ld e,(hl)                  ;7b28 5e  ^ 
    pop bc                     ;7b29 c1  . 
    ld hl,(v_l8ac7h-BA1)       ;7b2a 2a 07 2d  * . - 
    ld h,000h                  ;7b2d 26 00  & . 
    add hl,bc                  ;7b2f 09  . 
    ex de,hl                   ;7b30 eb  . 
l7b31h:
    call v_sub_8492h-BA1       ;7b31 cd d2 26  . . & 
    jr l7b39h                  ;7b34 18 03  . . 
l7b36h:
    call v_sub_8419h-BA1       ;7b36 cd 59 26  . Y & 
l7b39h:
    push af                    ;7b39 f5  . 
    push de                    ;7b3a d5  . 
    ex de,hl                   ;7b3b eb  . 
    ld a,032h                  ;7b3c 3e 32  > 2 
    call v_sub_7b50h-BA1       ;7b3e cd 90 1d  . . . 
    pop hl                     ;7b41 e1  . 
    pop bc                     ;7b42 c1  . 
    pop af                     ;7b43 f1  . 
    ex (sp),hl                 ;7b44 e3  . 
    push bc                    ;7b45 c5  . 
    call v_sub_7b0fh-BA1       ;7b46 cd 4f 1d  . O . 
    pop af                     ;7b49 f1  . 
    pop de                     ;7b4a d1  . 
    ret c                      ;7b4b d8  . 
    jr l7ae7h                  ;7b4c 18 99  . . 
v_sub_721ah:
    push hl                    ;7b4e e5  . 
    call v_sub_898ah-BA1       ;7b4f cd ca 2b  . . + 
l7b52h:
    ld hl,03e68h               ;7b52 21 68 3e  ! h > 
    call v_sub_8a2fh-BA1       ;7b55 cd 6f 2c  . o , 
    jr c,l7b63h                ;7b58 38 09  8 . 
    ld d,h                     ;7b5a 54  T 
    ld e,l                     ;7b5b 5d  ] 
    ld c,002h                  ;7b5c 0e 02  . . 
    call v_sub_8a6ch-BA1       ;7b5e cd ac 2c  . . , 
    jr l7b52h                  ;7b61 18 ef  . . 
l7b63h:
    pop hl                     ;7b63 e1  . 
    ret                        ;7b64 c9  . 
    ld b,03ah                  ;7b65 06 3a  . : 
    call v_sub_7c2ch-BA1       ;7b67 cd 6c 1e  . l . 
    ld de,015e9h               ;7b6a 11 e9 15  . . . 
    call z,v_sub_7304h-BA1     ;7b6d cc 44 15  . D . 
    ld ix,(v_sub_826ch+1-BA1)                                  ;7b70 dd 2a ad 24  . * . $ 
    ld (0151eh),ix             ;7b74 dd 22 1e 15  . " . . 
    call v_sub_8135h-BA1       ;7b78 cd 75 23  . u # 
    ld hl,v_l8aa5h-BA1         ;7b7b 21 e5 2c  ! . , 
    ld de,v_l8affh-BA1         ;7b7e 11 3f 2d  . ? - 
    ld a,001h                  ;7b81 3e 01  > . 
    ld (de),a                  ;7b83 12  . 
    inc de                     ;7b84 13  . 
    ld c,01fh                  ;7b85 0e 1f  . . 
l7b87h:
    push hl                    ;7b87 e5  . 
    push de                    ;7b88 d5  . 
    ex de,hl                   ;7b89 eb  . 
    call v_sub_7379h-BA1       ;7b8a cd b9 15  . . . 
    pop de                     ;7b8d d1  . 
    jr nc,l7ba8h               ;7b8e 30 18  0 . 
    ld hl,015e8h               ;7b90 21 e8 15  ! . . 
    ld b,(hl)                  ;7b93 46  F 
l7b94h:
    inc hl                     ;7b94 23  # 
    ld a,(hl)                  ;7b95 7e  ~ 
    call v_sub_7c9bh-BA1       ;7b96 cd db 1e  . . . 
    djnz l7b94h                ;7b99 10 f9  . . 
    pop hl                     ;7b9b e1  . 
    ld a,(v_l738dh-BA1)        ;7b9c 3a cd 15  : . . 
    ld b,a                     ;7b9f 47  G 
l7ba0h:
    call v_sub_85aeh-BA1       ;7ba0 cd ee 27  . . ' 
    inc hl                     ;7ba3 23  # 
    djnz l7ba0h                ;7ba4 10 fa  . . 
    jr l7b87h                  ;7ba6 18 df  . . 
l7ba8h:
    pop hl                     ;7ba8 e1  . 
    call v_sub_85aeh-BA1       ;7ba9 cd ee 27  . . ' 
    inc hl                     ;7bac 23  # 
    or a                       ;7bad b7  . 
    jr z,l7bb5h                ;7bae 28 05  ( . 
    call v_sub_7c9bh-BA1       ;7bb0 cd db 1e  . . . 
    jr l7b87h                  ;7bb3 18 d2  . . 
l7bb5h:
    inc a                      ;7bb5 3c  < 
    ld (de),a                  ;7bb6 12  . 
    ld (0205fh),a              ;7bb7 32 5f 20  2 _   
    dec a                      ;7bba 3d  = 
    inc c                      ;7bbb 0c  . 
l7bbch:
    ld (de),a                  ;7bbc 12  . 
    dec c                      ;7bbd 0d  . 
    jr nz,l7bbch               ;7bbe 20 fc    . 
    ld hl,v_l7295h-BA1         ;7bc0 21 d5 14  ! . . 
    ld (02079h),hl             ;7bc3 22 79 20  " y   
    jp v_l7dddh-BA1            ;7bc6 c3 1d 20  . .   
v_l7295h:
    ld hl,v_l7ccfh-BA1         ;7bc9 21 0f 1f  ! . . 
    ld (02079h),hl             ;7bcc 22 79 20  " y   
    call v_sub_72d4h-BA1       ;7bcf cd 14 15  . . . 
    jp v_l7e34h-BA1            ;7bd2 c3 74 20  . t   
    ld hl,(v_sub_826ch+1-BA1)                                  ;7bd5 2a ad 24  * . $ 
    ld (0151eh),hl             ;7bd8 22 1e 15  " . . 
    ld b,053h                  ;7bdb 06 53  . S 
    call v_sub_7c2ch-BA1       ;7bdd cd 6c 1e  . l . 
    jr nz,l7bf2h               ;7be0 20 10    . 
    xor a                      ;7be2 af  . 
l7be3h:
    ld de,03e66h               ;7be3 11 66 3e  . f > 
    ld (0151eh),de             ;7be6 ed 53 1e 15  . S . . 
    ld (0152eh),a              ;7bea 32 2e 15  2 . . 
    call v_sub_7c2fh-BA1       ;7bed cd 6f 1e  . o . 
    jr l7bfdh                  ;7bf0 18 0b  . . 
l7bf2h:
    ld b,042h                  ;7bf2 06 42  . B 
    call v_sub_7c33h-BA1       ;7bf4 cd 73 1e  . s . 
    jr nz,l7bfdh               ;7bf7 20 04    . 
    ld a,001h                  ;7bf9 3e 01  > . 
    jr l7be3h                  ;7bfb 18 e6  . . 
l7bfdh:
    ld b,03ah                  ;7bfd 06 3a  . : 
    call v_sub_7c33h-BA1       ;7bff cd 73 1e  . s . 
    ld de,v_l738eh-BA1         ;7c02 11 ce 15  . . . 
    call z,v_sub_7304h-BA1     ;7c05 cc 44 15  . D . 
v_sub_72d4h:
    call v_sub_89f2h-BA1       ;7c08 cd 32 2c  . 2 , 
    ld hl,v_l736ch-BA1         ;7c0b 21 ac 15  ! . . 
l7c0eh:
    ld (0153bh),hl             ;7c0e 22 3b 15  "               ; . 
l7c11h:
    ld hl,03e68h               ;7c11 21 68 3e  ! h > 
    call v_sub_8248h-BA1       ;7c14 cd 88 24  . . $ 
    ld (0151eh),hl             ;7c17 22 1e 15  " . . 
    call v_sub_8a2fh-BA1       ;7c1a cd 6f 2c  . o , 
    ret nc                     ;7c1d d0  . 
    push hl                    ;7c1e e5  . 
    pop ix                     ;7c1f dd e1  . . 
    ld a,000h                  ;7c21 3e 00  > . 
    or a                       ;7c23 b7  . 
    jr z,l7c2bh                ;7c24 28 05  ( . 
    call v_sub_80f5h-BA1       ;7c26 cd 35 23  . 5 # 
    jr c,l7c36h                ;7c29 38 0b  8 . 
l7c2bh:
    call v_sub_8135h-BA1       ;7c2b cd 75 23  . u # 
    call v_l736ch-BA1          ;7c2e cd ac 15  . . . 
    ld hl,(0151eh)             ;7c31 2a 1e 15  * . . 
    jr c,l7c9ch                ;7c34 38 66  8 f 
l7c36h:
    jr l7c11h                  ;7c36 18 d9  . . 
v_sub_7304h:
    ld b,000h                  ;7c38 06 00  . . 
    push de                    ;7c3a d5  . 
l7c3bh:
    call v_sub_85aeh-BA1       ;7c3b cd ee 27  . . ' 
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
    call v_sub_7c2ah-BA1       ;7c4d cd 6a 1e  . j . 
    ld a,000h                  ;7c50 3e 00  > . 
    jr nz,l7c55h               ;7c52 20 01    . 
    inc a                      ;7c54 3c  < 
l7c55h:
    ld (0152eh),a              ;7c55 32 2e 15  2 . . 
    ld hl,03e66h               ;7c58 21 66 3e  ! f > 
    ld (0151eh),hl             ;7c5b 22 1e 15  " . . 
    ld hl,v_l732fh-BA1         ;7c5e 21 6f 15  ! o . 
    jr l7c0eh                  ;7c61 18 ab  . . 
v_l732fh:
    call v_sub_7bbch-BA1       ;7c63 cd fc 1d  . . . 
v_l7332h:
    ld a,003h                  ;7c66 3e 03  > . 
    call 01601h                ;7c68 cd 01 16  . . . 
    ei                         ;7c6b fb  . 
    ld hl,00010h               ;7c6c 21 10 00  ! . . 
    call v_sub_82a3h-BA1       ;7c6f cd e3 24  . . $ 
    ld a,00dh                  ;7c72 3e 0d  > . 
    rst 10h                    ;7c74 d7  . 
    xor a                      ;7c75 af  . 
    ret                        ;7c76 c9  . 
v_sub_7343h:
    call 02327h                ;7c77 cd 27 23  . ' # 
    ld bc,00001h               ;7c7a 01 01 00  . . . 
l7c7dh:
    push hl                    ;7c7d e5  . 
    and a                      ;7c7e a7  . 
    sbc hl,de                  ;7c7f ed 52  . R 
    pop hl                     ;7c81 e1  . 
    jr nc,l7c8ah               ;7c82 30 06  0 . 
    inc bc                     ;7c84 03  . 
    call v_sub_8248h-BA1       ;7c85 cd 88 24  . . $ 
    jr l7c7dh                  ;7c88 18 f3  . . 
l7c8ah:
    call 02327h                ;7c8a cd 27 23  . ' # 
    call v_sub_721ah-BA1       ;7c8d cd 5a 14  . Z . 
    call v_sub_8a2fh-BA1       ;7c90 cd 6f 2c  . o , 
    call z,v_sub_8235h-BA1     ;7c93 cc 75 24  . u $ 
    ld (02328h),hl             ;7c96 22 28 23  " ( # 
    ld (0232bh),hl             ;7c99 22 2b 23  " + # 
l7c9ch:
    ld (v_sub_826ch+1-BA1),hl                                  ;7c9c 22 ad 24  " . $ 
    ret                        ;7c9f c9  . 
v_l736ch:
    ld de,v_l8aa5h-BA1         ;7ca0 11 e5 2c  . . , 
l7ca3h:
    push de                    ;7ca3 d5  . 
    call v_sub_7379h-BA1       ;7ca4 cd b9 15  . . . 
    pop de                     ;7ca7 d1  . 
    ret c                      ;7ca8 d8  . 
    inc de                     ;7ca9 13  . 
    jr nz,l7ca3h               ;7caa 20 f7    . 
    ret                        ;7cac c9  . 
v_sub_7379h:
    ld hl,v_l738dh-BA1         ;7cad 21 cd 15  ! . . 
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
    ld (01612h),a              ;7cf6 32 12 16  2 . . 
    ld a,010h                  ;7cf9 3e 10  > . 
v_l73c7h:
    push af                    ;7cfb f5  . 
    ex af,af'                  ;7cfc 08  . 
    ld a,b                     ;7cfd 78  x 
    or c                       ;7cfe b1  . 
    jp z,v_l7cc6h-BA1          ;7cff ca 06 1f  . . . 
    ex af,af'                  ;7d02 08  . 
    push bc                    ;7d03 c5  . 
    push hl                    ;7d04 e5  . 
    ld c,000h                  ;7d05 0e 00  . . 
    call 022b0h                ;7d07 cd b0 22  . . " 
    ld (029c8h),hl             ;7d0a 22 c8 29  " . ) 
    pop hl                     ;7d0d e1  . 
    push hl                    ;7d0e e5  . 
    ld de,00000h               ;7d0f 11 00 00  . . . 
    and a                      ;7d12 a7  . 
    sbc hl,de                  ;7d13 ed 52  . R 
    ex de,hl                   ;7d15 eb  . 
    ld hl,(02a17h)             ;7d16 2a 17 2a  * . * 
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
    jp v_l809ah-BA1            ;7d32 c3 da 22  . . " 
l7d35h:
    ld c,(hl)                  ;7d35 4e  N 
    pop hl                     ;7d36 e1  . 
    ld e,(hl)                  ;7d37 5e  ^ 
    inc hl                     ;7d38 23  # 
    ld d,(hl)                  ;7d39 56  V 
    inc hl                     ;7d3a 23  # 
    push de                    ;7d3b d5  . 
    ex de,hl                   ;7d3c eb  . 
    ld hl,v_l8aa5h-BA1         ;7d3d 21 e5 2c  ! . , 
    ld (hl),020h               ;7d40 36 20  6   
    bit 7,c                    ;7d42 cb 79  . y 
    jr z,l7d48h                ;7d44 28 02  ( . 
    ld (hl),02ah               ;7d46 36 2a  6 * 
l7d48h:
    inc hl                     ;7d48 23  # 
    push bc                    ;7d49 c5  . 
    ld b,009h                  ;7d4a 06 09  . . 
    call v_sub_82d4h-BA1       ;7d4c cd 14 25  . . % 
    pop bc                     ;7d4f c1  . 
    ex de,hl                   ;7d50 eb  . 
    ex (sp),hl                 ;7d51 e3  . 
    ex de,hl                   ;7d52 eb  . 
    ld a,c                     ;7d53 79  y 
    and 0c0h                   ;7d54 e6 c0  . . 
    jr nz,l7d61h               ;7d56 20 09    . 
    ld bc,0052eh               ;7d58 01 2e 05  . . . 
    call v_l82e1h-BA1          ;7d5b cd 21 25  . ! % 
    ld (hl),b                  ;7d5e 70  p 
    jr l7d6ah                  ;7d5f 18 09  . . 
l7d61h:
    push hl                    ;7d61 e5  . 
    pop ix                     ;7d62 dd e1  . . 
    ex de,hl                   ;7d64 eb  . 
    ld c,000h                  ;7d65 0e 00  . . 
    call v_sub_8908h-BA1       ;7d67 cd 48 2b  . H + 
l7d6ah:
    ld hl,v_l8aa5h-BA1         ;7d6a 21 e5 2c  ! . , 
    call v_sub_8a1bh-BA1       ;7d6d cd 5b 2c  . [ , 
    ld a,000h                  ;7d70 3e 00  > . 
    or a                       ;7d72 b7  . 
    call nz,v_l732fh-BA1       ;7d73 c4 6f 15  . o . 
    pop hl                     ;7d76 e1  . 
    pop bc                     ;7d77 c1  . 
    dec bc                     ;7d78 0b  . 
    pop af                     ;7d79 f1  . 
    add a,008h                 ;7d7a c6 08  . . 
    cp 0a9h                    ;7d7c fe a9  . . 
    jp c,v_l73c7h-BA1          ;7d7e da 07 16  . . . 
    ret                        ;7d81 c9  . 
l7d82h:
    ld b,050h                  ;7d82 06 50  . P 
    call v_sub_7c33h-BA1       ;7d84 cd 73 1e  . s . 
    ld a,001h                  ;7d87 3e 01  > . 
    jr z,l7d8ch                ;7d89 28 01  ( . 
    dec a                      ;7d8b 3d  = 
l7d8ch:
    ld (0167dh),a              ;7d8c 32 7d 16  2 } . 
    ld a,00eh                  ;7d8f 3e 0e  > . 
    call v_l89f4h-BA1          ;7d91 cd 34 2c  . 4 , 
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
    ld hl,(02a17h)             ;7da8 2a 17 2a  * . * 
    ld c,(hl)                  ;7dab 4e  N 
    inc hl                     ;7dac 23  # 
    ld b,(hl)                  ;7dad 46  F 
    inc hl                     ;7dae 23  # 
    add hl,bc                  ;7daf 09  . 
    add hl,bc                  ;7db0 09  . 
    ld (0161ch),hl             ;7db1 22 1c 16  " . . 
l7db4h:
    ld a,b                     ;7db4 78  x 
    or c                       ;7db5 b1  . 
    jr z,l7dd6h                ;7db6 28 1e  ( . 
    exx                        ;7db8 d9  . 
    ld a,010h                  ;7db9 3e 10  > . 
l7dbbh:
    push af                    ;7dbb f5  . 
    call v_sub_85f0h-BA1       ;7dbc cd 30 28  . 0 ( 
    pop af                     ;7dbf f1  . 
    add a,008h                 ;7dc0 c6 08  . . 
    cp 0a9h                    ;7dc2 fe a9  . . 
    jr c,l7dbbh                ;7dc4 38 f5  8 . 
    exx                        ;7dc6 d9  . 
    xor a                      ;7dc7 af  . 
    call v_sub_73c2h-BA1       ;7dc8 cd 02 16  . . . 
    ld a,088h                  ;7dcb 3e 88  > . 
    call v_sub_73c2h-BA1       ;7dcd cd 02 16  . . . 
    exx                        ;7dd0 d9  . 
    call v_sub_8639h-BA1       ;7dd1 cd 79 28  . y ( 
    cp 020h                    ;7dd4 fe 20  .   
l7dd6h:
    jp z,v_l7cc9h-BA1          ;7dd6 ca 09 1f  . . . 
    exx                        ;7dd9 d9  . 
    jr l7db4h                  ;7dda 18 d8  . . 
    ld b,043h                  ;7ddc 06 43  . C 
    call v_sub_7c2ch-BA1       ;7dde cd 6c 1e  . l . 
    jr z,l7e1fh                ;7de1 28 3c  ( < 
    ld b,04ch                  ;7de3 06 4c  . L 
    call v_sub_7c33h-BA1       ;7de5 cd 73 1e  . s . 
    ld c,0feh                  ;7de8 0e fe  . . 
    jr z,l7df5h                ;7dea 28 09  ( . 
    ld b,055h                  ;7dec 06 55  . U 
    call v_sub_7c33h-BA1       ;7dee cd 73 1e  . s . 
    jr nz,l7d82h               ;7df1 20 8f    . 
    ld c,0beh                  ;7df3 0e be  . . 
l7df5h:
v_l74c1h:
    ld a,c                     ;7df5 79  y 
    ld (01711h),a              ;7df6 32 11 17  2 . . 
    ld hl,(02a17h)             ;7df9 2a 17 2a  * . * 
    ld c,(hl)                  ;7dfc 4e  N 
    inc hl                     ;7dfd 23  # 
    ld b,(hl)                  ;7dfe 46  F 
    inc hl                     ;7dff 23  # 
l7e00h:
    ld a,b                     ;7e00 78  x 
    or c                       ;7e01 b1  . 
    ret z                      ;7e02 c8  . 
    inc hl                     ;7e03 23  # 
    set 7,(hl)                 ;7e04 cb fe  . . 
    inc hl                     ;7e06 23  # 
    dec bc                     ;7e07 0b  . 
    jr l7e00h                  ;7e08 18 f6  . . 
    ld b,079h                  ;7e0a 06 79  . y 
    call v_sub_7c2ch-BA1       ;7e0c cd 6c 1e  . l . 
    ret nz                     ;7e0f c0  . 
    ld hl,03e68h               ;7e10 21 68 3e  ! h > 
    ld (02328h),hl             ;7e13 22 28 23  " ( # 
    call v_sub_718eh-BA1       ;7e16 cd ce 13  . . . 
    ld (0232bh),hl             ;7e19 22 2b 23  " + # 
    call v_sub_7343h-BA1       ;7e1c cd 83 15  . . . 
l7e1fh:
    call v_sub_89f2h-BA1       ;7e1f cd 32 2c  . 2 , 
    ld c,0b6h                  ;7e22 0e b6  . . 
    call v_l74c1h-BA1          ;7e24 cd 01 17  . . . 
    ld hl,03e68h               ;7e27 21 68 3e  ! h > 
    call v_sub_75e9h-BA1       ;7e2a cd 29 18  . ) . 
l7e2dh:
    jr nc,l7e44h               ;7e2d 30 15  0 . 
    push hl                    ;7e2f e5  . 
    ld l,(hl)                  ;7e30 6e  n 
    and 07fh                   ;7e31 e6 7f  .  
    ld h,a                     ;7e33 67  g 
    add hl,hl                  ;7e34 29  ) 
    ld de,(02a17h)             ;7e35 ed 5b 17 2a  . [ . * 
    add hl,de                  ;7e39 19  . 
    inc hl                     ;7e3a 23  # 
    set 6,(hl)                 ;7e3b cb f6  . . 
    pop hl                     ;7e3d e1  . 
    inc hl                     ;7e3e 23  # 
    call v_sub_75f8h-BA1       ;7e3f cd 38 18  . 8 . 
    jr l7e2dh                  ;7e42 18 e9  . . 
l7e44h:
    ld hl,(02a17h)             ;7e44 2a 17 2a  * . * 
    ld c,(hl)                  ;7e47 4e  N 
    inc hl                     ;7e48 23  # 
    ld b,(hl)                  ;7e49 46  F 
    inc hl                     ;7e4a 23  # 
    push hl                    ;7e4b e5  . 
    add hl,bc                  ;7e4c 09  . 
    add hl,bc                  ;7e4d 09  . 
    ld (0177ah),hl             ;7e4e 22 7a 17  " z . 
    pop hl                     ;7e51 e1  . 
l7e52h:
v_l751eh:
    ld a,b                     ;7e52 78  x 
    or c                       ;7e53 b1  . 
    jr nz,l7e5bh               ;7e54 20 05    . 
    ld c,0b6h                  ;7e56 0e b6  . . 
    jp v_l74c1h-BA1            ;7e58 c3 01 17  . . . 
l7e5bh:
    dec bc                     ;7e5b 0b  . 
    ld (01815h),hl             ;7e5c 22 15 18  " . . 
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
    ld hl,00000h               ;7e6d 21 00 00  ! . . 
    add hl,de                  ;7e70 19  . 
    ld (017d0h),de             ;7e71 ed 53 d0 17  . S . . 
    ld d,h                     ;7e75 54  T 
    ld e,l                     ;7e76 5d  ] 
    inc de                     ;7e77 13  . 
    inc de                     ;7e78 13  . 
l7e79h:
    ld a,(de)                  ;7e79 1a  . 
    inc de                     ;7e7a 13  . 
    rlca                       ;7e7b 07  . 
    jr nc,l7e79h               ;7e7c 30 fb  0 . 
    call v_sub_88e1h-BA1       ;7e7e cd 21 2b  . ! + 
    and a                      ;7e81 a7  . 
    sbc hl,de                  ;7e82 ed 52  . R 
    ld b,h                     ;7e84 44  D 
    ld c,l                     ;7e85 4d  M 
    ld hl,02a5ah               ;7e86 21 5a 2a  ! Z * 
    call v_sub_89d1h-BA1       ;7e89 cd 11 2c  . . , 
    pop hl                     ;7e8c e1  . 
    push bc                    ;7e8d c5  . 
    ld d,h                     ;7e8e 54  T 
    ld e,l                     ;7e8f 5d  ] 
    dec hl                     ;7e90 2b  + 
    dec hl                     ;7e91 2b  + 
    call v_sub_88e1h-BA1       ;7e92 cd 21 2b  . ! + 
    ld bc,00002h               ;7e95 01 02 00  . . . 
    ld hl,0177ah               ;7e98 21 7a 17  ! z . 
    call v_sub_89d1h-BA1       ;7e9b cd 11 2c  . . , 
    ld hl,02a5ah               ;7e9e 21 5a 2a  ! Z * 
    call v_sub_89d1h-BA1       ;7ea1 cd 11 2c  . . , 
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
    ld hl,(02a17h)             ;7eb0 2a 17 2a  * . * 
    push hl                    ;7eb3 e5  . 
    inc bc                     ;7eb4 03  . 
    call v_sub_89d1h-BA1       ;7eb5 cd 11 2c  . . , 
    pop ix                     ;7eb8 dd e1  . . 
    pop bc                     ;7eba c1  . 
l7ebbh:
    ld a,d                     ;7ebb 7a  z 
    or e                       ;7ebc b3  . 
    jr z,l7ed5h                ;7ebd 28 16  ( . 
    push de                    ;7ebf d5  . 
    call v_sub_75dbh-BA1       ;7ec0 cd 1b 18  . . . 
    ld de,00000h               ;7ec3 11 00 00  . . . 
    and a                      ;7ec6 a7  . 
    sbc hl,de                  ;7ec7 ed 52  . R 
    jr c,l7ed1h                ;7ec9 38 06  8 . 
    push ix                    ;7ecb dd e5  . . 
    pop hl                     ;7ecd e1  . 
    call v_sub_89d1h-BA1       ;7ece cd 11 2c  . . , 
l7ed1h:
    pop de                     ;7ed1 d1  . 
    dec de                     ;7ed2 1b  . 
    jr l7ebbh                  ;7ed3 18 e6  . . 
l7ed5h:
    ld hl,(01815h)             ;7ed5 2a 15 18  * . . 
    ld de,(02a17h)             ;7ed8 ed 5b 17 2a  . [ . * 
    sbc hl,de                  ;7edc ed 52  . R 
    ex de,hl                   ;7ede eb  . 
    srl d                      ;7edf cb 3a  . : 
    rr e                       ;7ee1 cb 1b  . . 
    ld hl,03e68h               ;7ee3 21 68 3e  ! h > 
    call v_sub_75e9h-BA1       ;7ee6 cd 29 18  . ) . 
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
    call v_sub_75f8h-BA1       ;7ef9 cd 38 18  . 8 . 
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
    ld hl,00000h               ;7f08 21 00 00  ! . . 
    pop bc                     ;7f0b c1  . 
    jp v_l751eh-BA1            ;7f0c c3 5e 17  . ^ . 
v_sub_75dbh:
    inc ix                     ;7f0f dd 23  . #                    (flow from: 88bc)   75db inc ix 
    ld l,(ix+001h)             ;7f11 dd 6e 01  . n .               (flow from: 75db)   75dd ld l,(ix+01) 
    inc ix                     ;7f14 dd 23  . #                    (flow from: 75dd)   75e0 inc ix 
    ld a,(ix+001h)             ;7f16 dd 7e 01  . ~ .               (flow from: 75e0)   75e2 ld a,(ix+01) 
    and 03fh                   ;7f19 e6 3f  . ?                    (flow from: 75e2)   75e5 and 3f 
    ld h,a                     ;7f1b 67  g                         (flow from: 75e5)   75e7 ld h,a 
    ret                        ;7f1c c9  .                         (flow from: 75e7)   75e8 ret 
l7f1dh:
v_sub_75e9h:
    call v_sub_8a2fh-BA1       ;7f1d cd 6f 2c  . o , 
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
    ld ix,050e0h               ;7f3b dd 21 e0 50  . ! . P 
    ld (ix+000h),003h          ;7f3f dd 36 00 03  . 6 . . 
    call v_sub_7c2ah-BA1       ;7f43 cd 6a 1e  . j . 
    push af                    ;7f46 f5  . 
    ld b,03ah                  ;7f47 06 3a  . : 
    cp b                       ;7f49 b8  . 
    jr z,l7f4fh                ;7f4a 28 03  ( . 
    call v_sub_7c2fh-BA1       ;7f4c cd 6f 1e  . o . 
l7f4fh:
    jr nz,l7f54h               ;7f4f 20 03    . 
    call v_sub_76bch-BA1       ;7f51 cd fc 18  . . . 
l7f54h:
    ld hl,v_l76d5h-BA1         ;7f54 21 15 19  ! . . 
    ld de,050e1h               ;7f57 11 e1 50  . . P 
    ld bc,v_l5dcah-BA1         ;7f5a 01 0a 00  . . . 
    ldir                       ;7f5d ed b0  . . 
    pop af                     ;7f5f f1  . 
    jr z,l7f6eh                ;7f60 28 0c  ( . 
    ld hl,(02a17h)             ;7f62 2a 17 2a  * . * 
    ld de,0fff4h               ;7f65 11 f4 ff  . . . 
    add hl,de                  ;7f68 19  . 
    ld de,03e68h               ;7f69 11 68 3e  . h > 
    jr l7f75h                  ;7f6c 18 07  . . 
l7f6eh:
    call 02327h                ;7f6e cd 27 23  . ' # 
    ex de,hl                   ;7f71 eb  . 
    call v_sub_8248h-BA1       ;7f72 cd 88 24  . . $ 
l7f75h:
    push de                    ;7f75 d5  . 
    ld (0192bh),de             ;7f76 ed 53 2b 19  . S + . 
    or a                       ;7f7a b7  . 
    sbc hl,de                  ;7f7b ed 52  . R 
    push hl                    ;7f7d e5  . 
    ld (0192eh),hl             ;7f7e 22 2e 19  " . . 
    ld (050efh),hl             ;7f81 22 ef 50  " . P 
    ld hl,(02a5ah)             ;7f84 2a 5a 2a  * Z * 
    ld de,(02a17h)             ;7f87 ed 5b 17 2a  . [ . * 
    and a                      ;7f8b a7  . 
    sbc hl,de                  ;7f8c ed 52  . R 
    ld (018c1h),de             ;7f8e ed 53 c1 18  . S . . 
    inc hl                     ;7f92 23  # 
    ld (018c6h),hl             ;7f93 22 c6 18  " . . 
    dec hl                     ;7f96 2b  + 
    pop de                     ;7f97 d1  . 
    push de                    ;7f98 d5  . 
    add hl,de                  ;7f99 19  . 
    inc hl                     ;7f9a 23  # 
    inc hl                     ;7f9b 23  # 
    ld (050ebh),hl             ;7f9c 22 eb 50  " . P 
    ld a,00ch                  ;7f9f 3e 0c  > . 
    push ix                    ;7fa1 dd e5  . . 
    call v_l89f4h-BA1          ;7fa3 cd 34 2c  . 4 , 
    pop ix                     ;7fa6 dd e1  . . 
    call v_sub_769ah-BA1       ;7fa8 cd da 18  . . . 
    pop de                     ;7fab d1  . 
    pop ix                     ;7fac dd e1  . . 
    ld a,0ffh                  ;7fae 3e ff  > . 
    call 004c6h                ;7fb0 cd c6 04  . . . 
    ld ix,00000h               ;7fb3 dd 21 00 00  . ! . . 
    dec ix                     ;7fb7 dd 2b  . + 
    ld de,00000h               ;7fb9 11 00 00  . . . 
    ld l,0ffh                  ;7fbc 2e ff  . . 
    ld a,h                     ;7fbe 7c  | 
    xor l                      ;7fbf ad  . 
    ld h,a                     ;7fc0 67  g 
    ld a,001h                  ;7fc1 3e 01  > . 
    scf                        ;7fc3 37  7 
    rl l                       ;7fc4 cb 15  . . 
    ld b,037h                  ;7fc6 06 37  . 7 
    call 0051ah                ;7fc8 cd 1a 05  . . . 
    jp v_sub_7bbch-BA1         ;7fcb c3 fc 1d  . . . 
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
    ld de,v_l5dd1h-BA1         ;7fdd 11 11 00  . . . 
    xor a                      ;7fe0 af  . 
    call 004c6h                ;7fe1 cd c6 04  . . . 
l7fe4h:
    dec de                     ;7fe4 1b  . 
    dec d                      ;7fe5 15  . 
    inc d                      ;7fe6 14  . 
    jr nz,l7fe4h               ;7fe7 20 fb    . 
    ret                        ;7fe9 c9  . 
v_sub_76b6h:
    ld b,03ah                  ;7fea 06 3a  . :                    (flow from: 89ec)   76b6 ld b,3a 
    call v_sub_7c2ch-BA1       ;7fec cd 6c 1e  . l .               (flow from: 76b6)   76b8 call 7c2c 
    ret nz                     ;7fef c0  .                         (flow from: 7c34)   76bb ret nz 
v_sub_76bch:
    ld de,v_l76d5h-BA1         ;7ff0 11 15 19  . . .               (flow from: 76bb)   76bc ld de,76d5 
v_sub_76bfh:
    ld b,00ah                  ;7ff3 06 0a  . .                    (flow from: 76bc)   76bf ld b,0a 
l7ff5h:
    call v_sub_85aeh-BA1       ;7ff5 cd ee 27  . . '               (flow from: 76bf 76cb)   76c1 call 85ae 
    inc hl                     ;7ff8 23  #                         (flow from: 85b1)   76c4 inc hl 
    or a                       ;7ff9 b7  .                         (flow from: 76c4)   76c5 or a 
    jr z,l8002h                ;7ffa 28 06  ( .                    (flow from: 76c5)   76c6 jr z,76ce 
    ld (de),a                  ;7ffc 12  .                         (flow from: 76c6)   76c8 ld (de),a 
    inc de                     ;7ffd 13  .                         (flow from: 76c8)   76c9 inc de 
    dec b                      ;7ffe 05  .                         (flow from: 76c9)   76ca dec b 
    jr nz,l7ff5h               ;7fff 20 f4    .                    (flow from: 76ca)   76cb jr nz,76c1 
    ret                        ;8001 c9  .                         (flow from: 76cb)   76cd ret 
l8002h:
    ld a,020h                  ;8002 3e 20  >   
l8004h:
    ld (de),a                  ;8004 12  . 
    inc de                     ;8005 13  . 
    djnz l8004h                ;8006 10 fc  . . 
    ret                        ;8008 c9  . 
v_l76d5h:
    ld (hl),b                  ;8009 70  p 
    ld (hl),d                  ;800a 72  r 
    ld l,a                     ;800b 6f  o 
    ld l,l                     ;800c 6d  m 
    ld h,l                     ;800d 65  e 
    ld (hl),h                  ;800e 74  t 
    ld l,b                     ;800f 68  h 
    ld h,l                     ;8010 65  e 
    ld (hl),l                  ;8011 75  u 
    ld (hl),e                  ;8012 73  s 
l8013h:
    call v_sub_7bdch-BA1       ;8013 cd 1c 1e  . . . 
    call v_sub_7c1ah-BA1       ;8016 cd 5a 1e  . Z . 
    jr nz,l8013h               ;8019 20 f8    . 
    xor a                      ;801b af  . 
    dec a                      ;801c 3d  = 
    ld ix,00000h               ;801d dd 21 00 00  . ! . . 
    ld de,00000h               ;8021 11 00 00  . . . 
    call v_sub_770ah-BA1       ;8024 cd 4a 19  . J . 
    ld ix,(018c1h)             ;8027 dd 2a c1 18  . * . . 
    ld de,(018c6h)             ;802b ed 5b c6 18  . [ . . 
    dec de                     ;802f 1b  . 
    ld b,0b0h                  ;8030 06 b0  . . 
    ex af,af'                  ;8032 08  . 
    xor a                      ;8033 af  . 
    dec a                      ;8034 3d  = 
    ex af,af'                  ;8035 08  . 
    call 005c8h                ;8036 cd c8 05  . . . 
    call v_sub_7bbch-BA1       ;8039 cd fc 1d  . . . 
    jr l8041h                  ;803c 18 03  . . 
v_sub_770ah:
    call v_sub_7bb1h-BA1       ;803e cd f1 1d  . . .               (flow from: 77fd)   770a call 7bb1 
l8041h:
    ret c                      ;8041 d8  .                         (flow from: 7bc6)   770d ret c 
    ld a,00dh                  ;8042 3e 0d  > . 
l8044h:
    call v_l89f4h-BA1          ;8044 cd 34 2c  . 4 , 
    jp v_l80a2h-BA1            ;8047 c3 e2 22  . . " 
    call v_sub_89e8h-BA1       ;804a cd 28 2c  . ( ,               (flow from: 7e06)   7716 call 89e8 
    ld hl,v_l7760h-BA1         ;804d 21 a0 19  ! . .               (flow from: 8a1d)   7719 ld hl,7760 
    ld (02079h),hl             ;8050 22 79 20  " y                 (flow from: 7719)   771c ld (7e39),hl 
l8053h:
    ld hl,00000h               ;8053 21 00 00  ! . .               (flow from: 771c 776d)   771f ld hl,fb00 
    push hl                    ;8056 e5  .                         (flow from: 771f)   7722 push hl 
    push hl                    ;8057 e5  .                         (flow from: 7722)   7723 push hl 
    pop ix                     ;8058 dd e1  . .                    (flow from: 7723)   7724 pop ix 
    call v_sub_8248h-BA1       ;805a cd 88 24  . . $               (flow from: 7724)   7726 call 8248 
    ld (01960h),hl             ;805d 22 60 19  " ` .               (flow from: 8255 825a)   7729 ld (7720),hl 
    pop hl                     ;8060 e1  .                         (flow from: 7729)   772c pop hl 
    ld de,00000h               ;8061 11 00 00  . . .               (flow from: 772c)   772d ld de,fb00 
    and a                      ;8064 a7  .                         (flow from: 772d)   7730 and a 
    sbc hl,de                  ;8065 ed 52  . R                    (flow from: 7730)   7731 sbc hl,de 
    jr nc,l80a8h               ;8067 30 3f  0 ?                    (flow from: 7731)   7733 jr nc,7774 
    ld a,021h                  ;8069 3e 21  > !                    (flow from: 7733)   7735 ld a,21 
    ld hl,00000h               ;806b 21 00 00  ! . .               (flow from: 7735)   7737 ld hl,fb02 
    call v_sub_77cah-BA1       ;806e cd 0a 1a  . . .               (flow from: 7737)   773a call 77ca 
    call v_sub_8135h-BA1       ;8071 cd 75 23  . u #               (flow from: 77d0)   773d call 8135 
    ld a,02ah                  ;8074 3e 2a  > *                    (flow from: 8189 81b6 81dd 822d 8231)   7740 ld a,2a 
    ld hl,02a17h               ;8076 21 17 2a  ! . *               (flow from: 7740)   7742 ld hl,87d7 
    call v_sub_77cah-BA1       ;8079 cd 0a 1a  . . .               (flow from: 7742)   7745 call 77ca 
    ld a,(01f3fh)              ;807c 3a 3f 1f  : ? .               (flow from: 77d0)   7748 ld a,(7cff) 
    cp 010h                    ;807f fe 10  . .                    (flow from: 7748)   774b cp 10 
    jr z,l8044h                ;8081 28 c1  ( .                    (flow from: 774b)   774d jr z,7710 
    ld hl,v_l8aa5h-BA1         ;8083 21 e5 2c  ! . ,               (flow from: 774d)   774f ld hl,8aa5 
    ld de,v_l8affh-BA1         ;8086 11 3f 2d  . ? -               (flow from: 774f)   7752 ld de,8aff 
    ld bc,00020h               ;8089 01 20 00  .   .               (flow from: 7752)   7755 ld bc,0020 
    ldir                       ;808c ed b0  . .                    (flow from: 7755 7758)   7758 ldir 
    call v_l82dbh-BA1          ;808e cd 1b 25  . . %               (flow from: 7758)   775a call 82db 
    jp v_l7dddh-BA1            ;8091 c3 1d 20  . .                 (flow from: 82e5)   775d jp 7ddd 
v_l7760h:
    call v_sub_8262h-BA1       ;8094 cd a2 24  . . $               (flow from: 7e38)   7760 call 8262 
    ld de,(01960h)             ;8097 ed 5b 60 19  . [ ` .          (flow from: 8268)   7763 ld de,(7720) 
    ld hl,(02a5ah)             ;809b 2a 5a 2a  * Z *               (flow from: 7763)   7767 ld hl,(881a) 
    and a                      ;809e a7  .                         (flow from: 7767)   776a and a 
    sbc hl,de                  ;809f ed 52  . R                    (flow from: 776a)   776b sbc hl,de 
    jr c,l8053h                ;80a1 38 b0  8 .                    (flow from: 776b)   776d jr c,771f 
    ld a,007h                  ;80a3 3e 07  > . 
    jp v_l809ah-BA1            ;80a5 c3 da 22  . . " 
l80a8h:
    ld hl,v_l7ccfh-BA1         ;80a8 21 0f 1f  ! . .               (flow from: 7733)   7774 ld hl,7ccf 
    ld (02079h),hl             ;80ab 22 79 20  " y                 (flow from: 7774)   7777 ld (7e39),hl 
    jp (hl)                    ;80ae e9  .                         (flow from: 7777)   777a jp hl 
    call v_sub_89e8h-BA1       ;80af cd 28 2c  . ( , 
    ld hl,v_l77b9h-BA1         ;80b2 21 f9 19  ! . . 
    ld (02079h),hl             ;80b5 22 79 20  " y   
l80b8h:
    ld b,001h                  ;80b8 06 01  . . 
    ld de,v_l8affh-BA1         ;80ba 11 3f 2d  . ? - 
    ld hl,(01960h)             ;80bd 2a 60 19  * ` . 
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
    ld (01960h),hl             ;80d9 22 60 19  " ` . 
    ld a,001h                  ;80dc 3e 01  > . 
    ld (de),a                  ;80de 12  . 
l80dfh:
    inc de                     ;80df 13  . 
    xor a                      ;80e0 af  . 
    ld (de),a                  ;80e1 12  . 
    inc b                      ;80e2 04  . 
    bit 5,b                    ;80e3 cb 68  . h 
    jr z,l80dfh                ;80e5 28 f8  ( . 
    call v_l82dbh-BA1          ;80e7 cd 1b 25  . . % 
    jp v_l7dddh-BA1            ;80ea c3 1d 20  . .   
v_l77b9h:
    call v_sub_8262h-BA1       ;80ed cd a2 24  . . $ 
    ld hl,(01960h)             ;80f0 2a 60 19  * ` . 
    ld de,(01b86h)             ;80f3 ed 5b 86 1b  . [ . . 
    and a                      ;80f7 a7  . 
    sbc hl,de                  ;80f8 ed 52  . R 
    jr c,l80b8h                ;80fa 38 bc  8 . 
    jr l80a8h                  ;80fc 18 aa  . . 
v_sub_77cah:
    ld (v_sub_8116h-BA1),a     ;80fe 32 56 23  2 V #               (flow from: 773a 7745)   77ca ld (8116),a 
    ld (02357h),hl             ;8101 22 57 23  " W #               (flow from: 77ca)   77cd ld (8117),hl 
    ret                        ;8104 c9  .                         (flow from: 77cd)   77d0 ret 
l8105h:
v_l77d1h:
    call v_sub_7bdch-BA1       ;8105 cd 1c 1e  . . .               (flow from: 89ef)   77d1 call 7bdc 
    call v_sub_7c0dh-BA1       ;8108 cd 4d 1e  . M .               (flow from: 7c0c)   77d4 call 7c0d 
    jr nz,l8105h               ;810b 20 f8    .                    (flow from: 7c29)   77d7 jr nz,77d1 
    ld hl,(050ebh)             ;810d 2a eb 50  * . P               (flow from: 77d7)   77d9 ld hl,(50eb) 
    ld b,h                     ;8110 44  D                         (flow from: 77d9)   77dc ld b,h 
    ld c,l                     ;8111 4d  M                         (flow from: 77dc)   77dd ld c,l 
    call v_sub_8068h-BA1       ;8112 cd a8 22  . . "               (flow from: 77dd)   77de call 8068 
    ex de,hl                   ;8115 eb  .                         (flow from: 8078)   77e1 ex de,hl 
    ld hl,(01b86h)             ;8116 2a 86 1b  * . .               (flow from: 77e1)   77e2 ld hl,(7946) 
    and a                      ;8119 a7  .                         (flow from: 77e2)   77e5 and a 
    sbc hl,de                  ;811a ed 52  . R                    (flow from: 77e5)   77e6 sbc hl,de 
    push hl                    ;811c e5  .                         (flow from: 77e6)   77e8 push hl 
    ld (01960h),hl             ;811d 22 60 19  " ` .               (flow from: 77e8)   77e9 ld (7720),hl 
    ld bc,(050efh)             ;8120 ed 4b ef 50  . K . P          (flow from: 77e9)   77ec ld bc,(50ef) 
    add hl,bc                  ;8124 09  .                         (flow from: 77ec)   77f0 add hl,bc 
    ld (0196eh),hl             ;8125 22 6e 19  " n .               (flow from: 77f0)   77f1 ld (772e),hl 
    inc hl                     ;8128 23  #                         (flow from: 77f1)   77f4 inc hl 
    inc hl                     ;8129 23  #                         (flow from: 77f4)   77f5 inc hl 
    ld (01978h),hl             ;812a 22 78 19  " x .               (flow from: 77f5)   77f6 ld (7738),hl 
    pop ix                     ;812d dd e1  . .                    (flow from: 77f6)   77f9 pop ix 
    scf                        ;812f 37  7                         (flow from: 77f9)   77fb scf 
    sbc a,a                    ;8130 9f  .                         (flow from: 77fb)   77fc sbc a,a 
    call v_sub_770ah-BA1       ;8131 cd 4a 19  . J .               (flow from: 77fc)   77fd call 770a 
v_sub_7800h:
    ld a,007h                  ;8134 3e 07  > .                    (flow from: 770d 7cf7)   7800 ld a,07 
    out (0feh),a               ;8136 d3 fe  . .                    (flow from: 7800)   7802 out (fe),a 
    ret                        ;8138 c9  .                         (flow from: 7802)   7804 ret 
v_sub_7805h:
    call v_sub_7c2ah-BA1       ;8139 cd 6a 1e  . j . 
    ld a,000h                  ;813c 3e 00  > . 
    jr z,l8141h                ;813e 28 01  ( . 
    inc a                      ;8140 3c  < 
l8141h:
    ld (01a7fh),a              ;8141 32 7f 1a  2  . 
    ld c,0b6h                  ;8144 0e b6  . . 
    call v_l74c1h-BA1          ;8146 cd 01 17  . . . 
    ld a,001h                  ;8149 3e 01  > . 
    ld (01a91h),a              ;814b 32 91 1a  2 . . 
    ld hl,v_sub_79afh-BA1      ;814e 21 ef 1b  ! . . 
    ld (01a89h),hl             ;8151 22 89 1a  " . . 
l8154h:
    ld hl,(02a5ah)             ;8154 2a 5a 2a  * Z * 
    inc hl                     ;8157 23  # 
    ld (v_l7953h+1-BA1),hl     ;8158 22 94 1b  " . . 
    ld (01b75h),hl             ;815b 22 75 1b  " u . 
    ld hl,03e68h               ;815e 21 68 3e  ! h > 
l8161h:
    call v_sub_8a2fh-BA1       ;8161 cd 6f 2c  . o , 
    jr nc,l8184h               ;8164 30 1e  0 . 
    ld (v_l79c3h+1-BA1),hl     ;8166 22 04 1c  " . . 
    push hl                    ;8169 e5  . 
    call v_sub_8248h-BA1       ;816a cd 88 24  . . $ 
    ld (01a8ch),hl             ;816d 22 8c 1a  " . . 
    pop ix                     ;8170 dd e1  . . 
    ld a,000h                  ;8172 3e 00  > . 
    or a                       ;8174 b7  . 
    jr nz,l817ch               ;8175 20 05    . 
    call v_sub_80f5h-BA1       ;8177 cd 35 23  . 5 # 
    jr c,l817fh                ;817a 38 03  8 . 
l817ch:
    call v_sub_79afh-BA1       ;817c cd ef 1b  . . . 
l817fh:
    ld hl,00000h               ;817f 21 00 00  ! . . 
    jr l8161h                  ;8182 18 dd  . . 
l8184h:
    ld a,000h                  ;8184 3e 00  > . 
    dec a                      ;8186 3d  = 
    ld (01a91h),a              ;8187 32 91 1a  2 . . 
    ld hl,v_sub_78dah-BA1      ;818a 21 1a 1b  ! . . 
    ld (01a89h),hl             ;818d 22 89 1a  " . . 
    jr z,l8154h                ;8190 28 c2  ( . 
    ret                        ;8192 c9  . 
    call v_sub_7805h-BA1       ;8193 cd 45 1a  . E . 
    ld a,00bh                  ;8196 3e 0b  > . 
    jp v_l7cdah-BA1            ;8198 c3 1a 1f  . . . 
l819bh:
    ld a,(ix+000h)             ;819b dd 7e 00  . ~ . 
    call v_sub_7a02h-BA1       ;819e cd 42 1c  . B . 
    sub 002h                   ;81a1 d6 02  . . 
    ret c                      ;81a3 d8  . 
    jr nz,l81b1h               ;81a4 20 0b    . 
    call v_sub_7a98h-BA1       ;81a6 cd d8 1c  . . . 
    ld (01f04h),hl             ;81a9 22 04 1f  " . . 
    ld hl,01ef9h               ;81ac 21 f9 1e  ! . . 
    dec (hl)                   ;81af 35  5 
    ret                        ;81b0 c9  . 
l81b1h:
    dec a                      ;81b1 3d  = 
    ret z                      ;81b2 c8  . 
    dec a                      ;81b3 3d  = 
    jp z,v_l7a25h-BA1          ;81b4 ca 65 1c  . e . 
    dec a                      ;81b7 3d  = 
    jr nz,l81c0h               ;81b8 20 06    . 
    call v_sub_7a98h-BA1       ;81ba cd d8 1c  . . . 
    jp v_l7a2ch-BA1            ;81bd c3 6c 1c  . l . 
l81c0h:
    dec a                      ;81c0 3d  = 
    jr nz,l81d0h               ;81c1 20 0d    . 
l81c3h:
    call v_sub_7a98h-BA1       ;81c3 cd d8 1c  . . . 
    jp c,v_l792ah-BA1          ;81c6 da 6a 1b  . j . 
    call v_l792ah-BA1          ;81c9 cd 6a 1b  . j . 
    inc ix                     ;81cc dd 23  . # 
    jr l81c3h                  ;81ce 18 f3  . . 
l81d0h:
    dec a                      ;81d0 3d  = 
    jr nz,l81fdh               ;81d1 20 2a    * 
l81d3h:
    call v_sub_78b3h-BA1       ;81d3 cd f3 1a  . . . 
    jr nz,l81ddh               ;81d6 20 05    . 
    call v_sub_7931h-BA1       ;81d8 cd 71 1b  . q . 
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
    call v_sub_810ah-BA1       ;81e7 cd 4a 23  . J # 
    bit 7,(ix+004h)            ;81ea dd cb 04 7e  . . . ~ 
    ret nz                     ;81ee c0  . 
    ld a,d                     ;81ef 7a  z 
    cp 022h                    ;81f0 fe 22  . " 
    jr nz,l81f8h               ;81f2 20 04    . 
    cp e                       ;81f4 bb  . 
    call z,v_sub_810ah-BA1     ;81f5 cc 4a 23  . J # 
l81f8h:
    bit 7,(ix+004h)            ;81f8 dd cb 04 7e  . . . ~ 
    ret                        ;81fc c9  . 
l81fdh:
    dec a                      ;81fd 3d  = 
    jp z,v_l7a4ch-BA1          ;81fe ca 8c 1c  . . . 
l8201h:
    call v_sub_7a98h-BA1       ;8201 cd d8 1c  . . . 
    jp c,v_sub_7962h-BA1       ;8204 da a2 1b  . . . 
    call v_sub_7962h-BA1       ;8207 cd a2 1b  . . . 
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
    call v_l78f9h-BA1          ;821f cd 39 1b  . 9 . 
    ld hl,(01b75h)             ;8222 2a 75 1b  * u . 
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
    call nz,v_sub_7931h-BA1    ;8231 c4 71 1b  . q . 
    ld a,0fdh                  ;8234 3e fd  > . 
    bit 4,b                    ;8236 cb 60  . ` 
    call nz,v_sub_7931h-BA1    ;8238 c4 71 1b  . q . 
    ld a,0cbh                  ;823b 3e cb  > . 
    bit 7,b                    ;823d cb 78  . x 
    call nz,v_sub_7931h-BA1    ;823f c4 71 1b  . q . 
    ld a,0edh                  ;8242 3e ed  > . 
    bit 6,b                    ;8244 cb 70  . p 
    call nz,v_sub_7931h-BA1    ;8246 c4 71 1b  . q . 
    ld a,(ix+000h)             ;8249 dd 7e 00  . ~ . 
    call v_sub_7931h-BA1       ;824c cd 71 1b  . q . 
    call v_sub_7a02h-BA1       ;824f cd 42 1c  . B . 
    ld a,b                     ;8252 78  x 
    and 007h                   ;8253 e6 07  . . 
    ret z                      ;8255 c8  . 
    dec a                      ;8256 3d  = 
    push af                    ;8257 f5  . 
    call v_sub_7a98h-BA1       ;8258 cd d8 1c  . . . 
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
    ld de,v_l5dc0h-BA1                                         ;8265 11 00 00  . . . 
    ld hl,00000h               ;8268 21 00 00  ! . . 
    and a                      ;826b a7  . 
    sbc hl,de                  ;826c ed 52  . R 
    add hl,de                  ;826e 19  . 
    ex de,hl                   ;826f eb  . 
    jr c,l8279h                ;8270 38 07  8 . 
    ld hl,(02a5ah)             ;8272 2a 5a 2a  * Z * 
    sbc hl,de                  ;8275 ed 52  . R 
    jr nc,l828fh               ;8277 30 16  0 . 
l8279h:
    ld hl,0ffffh               ;8279 21 ff ff  ! . . 
    and a                      ;827c a7  . 
    sbc hl,de                  ;827d ed 52  . R 
    jr c,l828fh                ;827f 38 0e  8 . 
    ld (de),a                  ;8281 12  . 
    inc de                     ;8282 13  . 
    ld (01b75h),de             ;8283 ed 53 75 1b  . S u . 
v_l7953h:
    ld hl,00000h               ;8287 21 00 00  ! . . 
    inc hl                     ;828a 23  # 
    ld (v_l7953h+1-BA1),hl     ;828b 22 94 1b  " . . 
    ret                        ;828e c9  . 
l828fh:
    ld a,008h                  ;828f 3e 08  > . 
    jr l82f7h                  ;8291 18 64  . d 
l8293h:
    dec a                      ;8293 3d  = 
    jr nz,l829dh               ;8294 20 07    . 
v_sub_7962h:
    ld a,c                     ;8296 79  y 
    call v_sub_7931h-BA1       ;8297 cd 71 1b  . q . 
    ld a,b                     ;829a 78  x 
    jr l8265h                  ;829b 18 c8  . . 
l829dh:
    dec a                      ;829d 3d  = 
    jr nz,l82bfh               ;829e 20 1f    . 
    ld hl,(v_l7953h+1-BA1)     ;82a0 2a 94 1b  * . . 
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
    call v_sub_798eh-BA1       ;82c9 cd ce 1b  . . . 
    inc ix                     ;82cc dd 23  . # 
    call v_sub_7a98h-BA1       ;82ce cd d8 1c  . . . 
    jr l825eh                  ;82d1 18 8b  . . 
l82d3h:
    ld a,c                     ;82d3 79  y 
    and 0c7h                   ;82d4 e6 c7  . . 
    or b                       ;82d6 b0  . 
    ld a,006h                  ;82d7 3e 06  > . 
    jr nz,l82f7h               ;82d9 20 1c    . 
    ld a,c                     ;82db 79  y 
    ld hl,(01b75h)             ;82dc 2a 75 1b  * u . 
    dec hl                     ;82df 2b  + 
    add a,(hl)                 ;82e0 86  . 
    ld (hl),a                  ;82e1 77  w 
    ret                        ;82e2 c9  . 
v_sub_79afh:
    bit 3,(ix+001h)            ;82e3 dd cb 01 5e  . . . ^ 
    jr z,l830ah                ;82e7 28 21  ( ! 
    call v_sub_8113h-BA1       ;82e9 cd 53 23  . S # 
    ld (01c5bh),de             ;82ec ed 53 5b 1c  . S [ . 
    ld a,(hl)                  ;82f0 7e  ~ 
    and 0c0h                   ;82f1 e6 c0  . . 
    jr z,l8300h                ;82f3 28 0b  ( . 
    ld a,012h                  ;82f5 3e 12  > . 
l82f7h:
v_l79c3h:
    ld hl,00000h               ;82f7 21 00 00  ! . . 
    ld (v_sub_826ch+1-BA1),hl                                  ;82fa 22 ad 24  " . $ 
    jp v_l809ah-BA1            ;82fd c3 da 22  . . " 
l8300h:
    set 6,(hl)                 ;8300 cb f6  . . 
    ld hl,(v_l7953h+1-BA1)     ;8302 2a 94 1b  * . . 
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
    ld hl,v_l79fah-BA1         ;831b 21 3a 1c  ! : . 
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
    call v_sub_7a02h-BA1       ;8343 cd 42 1c  . B . 
    sub 003h                   ;8346 d6 03  . . 
    ret c                      ;8348 d8  . 
    jr nz,l8356h               ;8349 20 0b    . 
    call v_sub_7a98h-BA1       ;834b cd d8 1c  . . . 
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
    call v_sub_7a98h-BA1       ;8359 cd d8 1c  . . . 
    ld (v_l7953h+1-BA1),bc     ;835c ed 43 94 1b  . C . . 
v_l7a2ch:
    ld (01b75h),bc             ;8360 ed 43 75 1b  . C u . 
    ret                        ;8364 c9  . 
l8365h:
    dec a                      ;8365 3d  = 
    ret z                      ;8366 c8  . 
    dec a                      ;8367 3d  = 
    jr nz,l8370h               ;8368 20 06    . 
    call v_sub_7a70h-BA1       ;836a cd b0 1c  . . . 
    ld a,c                     ;836d 79  y 
    jr l839bh                  ;836e 18 2b  . + 
l8370h:
    dec a                      ;8370 3d  = 
    jr nz,l837dh               ;8371 20 0a    . 
    ld c,a                     ;8373 4f  O 
l8374h:
    inc c                      ;8374 0c  . 
    call v_sub_78b3h-BA1       ;8375 cd f3 1a  . . . 
    jr z,l8374h                ;8378 28 fa  ( . 
    ld a,c                     ;837a 79  y 
    jr l839bh                  ;837b 18 1e  . . 
l837dh:
    dec a                      ;837d 3d  = 
    jr nz,l8396h               ;837e 20 16    . 
l8380h:
v_l7a4ch:
    call v_sub_7a98h-BA1       ;8380 cd d8 1c  . . . 
    push af                    ;8383 f5  . 
    ld hl,v_l7953h+1-BA1       ;8384 21 94 1b  ! . . 
    call v_sub_8980h-BA1       ;8387 cd c0 2b  . . + 
    ld hl,01b75h               ;838a 21 75 1b  ! u . 
    call v_sub_8980h-BA1       ;838d cd c0 2b  . . + 
    pop af                     ;8390 f1  . 
    inc ix                     ;8391 dd 23  . # 
    jr nc,l8380h               ;8393 30 eb  0 . 
    ret                        ;8395 c9  . 
l8396h:
    call v_sub_7a70h-BA1       ;8396 cd b0 1c  . . . 
    ld a,c                     ;8399 79  y 
    add a,c                    ;839a 81  . 
l839bh:
    ld b,000h                  ;839b 06 00  . . 
    ld c,a                     ;839d 4f  O 
    ld hl,v_l7953h+1-BA1       ;839e 21 94 1b  ! . . 
    jp v_sub_8980h-BA1         ;83a1 c3 c0 2b  . . + 
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
    ld de,(v_l7953h+1-BA1)     ;83e2 ed 5b 94 1b  . [ . . 
    jr z,l8409h                ;83e6 28 21  ( ! 
    cp 080h                    ;83e8 fe 80  . . 
    jp c,v_l7b5bh-BA1          ;83ea da 9b 1d  . . . 
    ld d,a                     ;83ed 57  W 
    ld e,(ix+003h)             ;83ee dd 5e 03  . ^ . 
    inc ix                     ;83f1 dd 23  . # 
    call v_sub_8116h-BA1       ;83f3 cd 56 23  . V # 
    ld a,(hl)                  ;83f6 7e  ~ 
    and 0c0h                   ;83f7 e6 c0  . . 
    jr nz,l8404h               ;83f9 20 09    . 
    ld (02300h),de             ;83fb ed 53 00 23  . S . # 
    ld a,009h                  ;83ff 3e 09  > . 
    jp v_l79c3h-BA1            ;8401 c3 03 1c  . . . 
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
    jp v_l7a9dh-BA1            ;8420 c3 dd 1c  . . . 
l8423h:
    ld de,00000h               ;8423 11 00 00  . . . 
    inc ix                     ;8426 dd 23  . # 
    call v_sub_7b9dh-BA1       ;8428 cd dd 1d  . . . 
    jr c,l8437h                ;842b 38 0a  8 . 
    ld e,a                     ;842d 5f  _ 
    call v_sub_7b9dh-BA1       ;842e cd dd 1d  . . . 
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
    call v_sub_7b50h-BA1       ;843a cd 90 1d  . . . 
    pop af                     ;843d f1  . 
    pop hl                     ;843e e1  . 
    ld bc,v_l7ad9h-BA1         ;843f 01 19 1d  . . . 
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
    call v_sub_7b1fh-BA1       ;8468 cd 5f 1d  . _ . 
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
    jp c,v_l7b04h-BA1          ;84b8 da 44 1d  . D . 
l84bbh:
    cp c                       ;84bb b9  . 
    jp nc,v_l7b04h-BA1         ;84bc d2 44 1d  . D . 
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
    inc d                      ;84e5 14  .                         (flow from: 770a 7be5)   7bb1 inc d 
    ex af,af'                  ;84e6 08  .                         (flow from: 7bb1)   7bb2 ex af,af' 
    dec d                      ;84e7 15  .                         (flow from: 7bb2)   7bb3 dec d 
    di                         ;84e8 f3  .                         (flow from: 7bb3)   7bb4 di 
    ld a,00fh                  ;84e9 3e 0f  > .                    (flow from: 7bb4)   7bb5 ld a,0f 
    out (0feh),a               ;84eb d3 fe  . .                    (flow from: 7bb5)   7bb7 out (fe),a 
    call 00562h                ;84ed cd 62 05  . b .               (flow from: 7bb7)   7bb9 call 0562 
v_sub_7bbch:
    push af                    ;84f0 f5  .                         (flow from: 0000)   7bbc push af 
    ld a,07fh                  ;84f1 3e 7f  >                     (flow from: 7bbc)   7bbd ld a,7f 
    in a,(0feh)                ;84f3 db fe  . .                    (flow from: 7bbd)   7bbf in a,(fe) 
    rra                        ;84f5 1f  .                         (flow from: 7bbf)   7bc1 rra 
    jp nc,v_l80a2h-BA1         ;84f6 d2 e2 22  . . "               (flow from: 7bc1)   7bc2 jp nc,80a2 
    pop af                     ;84f9 f1  .                         (flow from: 7bc2)   7bc5 pop af 
    ret                        ;84fa c9  .                         (flow from: 7bc5)   7bc6 ret 
    ld b,061h                  ;84fb 06 61  . a 
    call v_sub_7c2ch-BA1       ;84fd cd 6c 1e  . l . 
    call z,v_sub_7805h-BA1     ;8500 cc 45 1a  . E . 
    call v_sub_7ca1h-BA1       ;8503 cd e1 1e  . . . 
    jp v_l5f74h-BA1            ;8506 c3 b4 01  . . . 
    ld b,079h                  ;8509 06 79  . y 
    call v_sub_7c2ch-BA1       ;850b cd 6c 1e  . l . 
    ret nz                     ;850e c0  . 
    rst 0                      ;850f c7  . 
l8510h:
v_sub_7bdch:
    ld ix,050e0h               ;8510 dd 21 e0 50  . ! . P          (flow from: 77d1)   7bdc ld ix,50e0 
    ld de,v_l5dd1h-BA1         ;8514 11 11 00  . . .               (flow from: 7bdc)   7be0 ld de,0011 
    xor a                      ;8517 af  .                         (flow from: 7be0)   7be3 xor a 
    scf                        ;8518 37  7                         (flow from: 7be3)   7be4 scf 
    call v_sub_7bb1h-BA1       ;8519 cd f1 1d  . . .               (flow from: 7be4)   7be5 call 7bb1 
    jr nc,l8510h               ;851c 30 f2  0 .                    (flow from: 7bc6)   7be8 jr nc,7bdc 
    ld a,011h                  ;851e 3e 11  > .                    (flow from: 7be8)   7bea ld a,11 
    call v_sub_80b4h-BA1       ;8520 cd f4 22  . . "               (flow from: 7bea)   7bec call 80b4 
    ld hl,050e1h               ;8523 21 e1 50  ! . P               (flow from: 80e0)   7bef ld hl,50e1 
    ld b,00ah                  ;8526 06 0a  . .                    (flow from: 7bef)   7bf2 ld b,0a 
l8528h:
    ld a,(hl)                  ;8528 7e  ~                         (flow from: 7bf2 7c03)   7bf4 ld a,(hl) 
    cp 020h                    ;8529 fe 20  .                      (flow from: 7bf4)   7bf5 cp 20 
    jr c,l8531h                ;852b 38 04  8 .                    (flow from: 7bf5)   7bf7 jr c,7bfd 
    cp 080h                    ;852d fe 80  . .                    (flow from: 7bf7)   7bf9 cp 80 
    jr c,l8533h                ;852f 38 02  8 .                    (flow from: 7bf9)   7bfb jr c,7bff 
l8531h:
    ld a,03fh                  ;8531 3e 3f  > ? 
l8533h:
    call v_sub_8744h-BA1       ;8533 cd 84 29  . . )               (flow from: 7bfb)   7bff call 8744 
    inc hl                     ;8536 23  #                         (flow from: 8749)   7c02 inc hl 
    djnz l8528h                ;8537 10 ef  . .                    (flow from: 7c02)   7c03 djnz 7bf4 
    ld a,(050e0h)              ;8539 3a e0 50  : . P               (flow from: 7c03)   7c05 ld a,(50e0) 
    cp 003h                    ;853c fe 03  . .                    (flow from: 7c05)   7c08 cp 03 
    jr nz,l8510h               ;853e 20 d0    .                    (flow from: 7c08)   7c0a jr nz,7bdc 
    ret                        ;8540 c9  .                         (flow from: 7c0a)   7c0c ret 
v_sub_7c0dh:
    ld b,00ah                  ;8541 06 0a  . .                    (flow from: 77d4)   7c0d ld b,0a 
    ld hl,v_l76d5h-BA1         ;8543 21 15 19  ! . .               (flow from: 7c0d)   7c0f ld hl,76d5 
l8546h:
    ld a,(hl)                  ;8546 7e  ~                         (flow from: 7c0f)   7c12 ld a,(hl) 
    cp 020h                    ;8547 fe 20  .                      (flow from: 7c12)   7c13 cp 20 
    jr nz,l854eh               ;8549 20 03    .                    (flow from: 7c13)   7c15 jr nz,7c1a 
    djnz l8546h                ;854b 10 f9  . . 
    ret                        ;854d c9  . 
l854eh:
v_sub_7c1ah:
    ld b,00ah                  ;854e 06 0a  . .                    (flow from: 7c15)   7c1a ld b,0a 
    ld hl,v_l76d5h-BA1         ;8550 21 15 19  ! . .               (flow from: 7c1a)   7c1c ld hl,76d5 
    ld de,050e1h               ;8553 11 e1 50  . . P               (flow from: 7c1c)   7c1f ld de,50e1 
l8556h:
    ld a,(de)                  ;8556 1a  .                         (flow from: 7c1f 7c27)   7c22 ld a,(de) 
    cp (hl)                    ;8557 be  .                         (flow from: 7c22)   7c23 cp (hl) 
    inc hl                     ;8558 23  #                         (flow from: 7c23)   7c24 inc hl 
    inc de                     ;8559 13  .                         (flow from: 7c24)   7c25 inc de 
    ret nz                     ;855a c0  .                         (flow from: 7c25)   7c26 ret nz 
    djnz l8556h                ;855b 10 f9  . .                    (flow from: 7c26)   7c27 djnz 7c22 
    ret                        ;855d c9  .                         (flow from: 7c27)   7c29 ret 
v_sub_7c2ah:
    ld b,042h                  ;855e 06 42  . B 
v_sub_7c2ch:
    ld hl,02d40h               ;8560 21 40 2d  ! @ -               (flow from: 76b8)   7c2c ld hl,8b00 
v_sub_7c2fh:
    call v_sub_85aeh-BA1       ;8563 cd ee 27  . . '               (flow from: 7c2c)   7c2f call 85ae 
    inc hl                     ;8566 23  #                         (flow from: 85b1)   7c32 inc hl 
v_sub_7c33h:
    cp b                       ;8567 b8  .                         (flow from: 7c32)   7c33 cp b 
    ret z                      ;8568 c8  .                         (flow from: 7c33)   7c34 ret z 
    set 5,b                    ;8569 cb e8  . . 
    cp b                       ;856b b8  . 
    ret                        ;856c c9  . 
v_l7c39h:
    ld hl,02b49h               ;856d 21 49 2b  ! I + 
    jr l8575h                  ;8570 18 03  . . 
v_sub_7c3eh:
    ld hl,0205fh               ;8572 21 5f 20  ! _   
l8575h:
v_l7c41h:
    ld a,(hl)                  ;8575 7e  ~ 
    xor 001h                   ;8576 ee 01  . . 
    ld (hl),a                  ;8578 77  w 
    ret                        ;8579 c9  . 
    ld iy,05c3ah               ;857a fd 21 3a 5c  . ! : \          (flow from: 7e06)   7c46 ld iy,5c3a 
    im 1                       ;857e ed 56  . V                    (flow from: 7c46)   7c4a im 1 
    ei                         ;8580 fb  .                         (flow from: 7c4a)   7c4c ei 
    ld sp,(SYSVAR_ERR_SP)      ;8581                               (flow from: 7c4c)   7c4d ld sp,(5c3d) 
    jp 01b76h                  ;8585 c3 76 1b  . v .               (flow from: 7c4d)   7c51 jp 1b76 
v_sub_7c54h:
    push af                    ;8588 f5  . 
    ld c,000h                  ;8589 0e 00  . . 
    call 022b0h                ;858b cd b0 22  . . " 
    push hl                    ;858e e5  . 
    call v_sub_7c83h-BA1       ;858f cd c3 1e  . . . 
    pop de                     ;8592 d1  . 
    pop af                     ;8593 f1  . 
    ret                        ;8594 c9  . 
v_sub_7c61h:
    push hl                    ;8595 e5  . 
    pop ix                     ;8596 dd e1  . . 
    call v_sub_828fh-BA1       ;8598 cd cf 24  . . $ 
    ld a,0efh                  ;859b 3e ef  > . 
    in a,(0feh)                ;859d db fe  . . 
    ret                        ;859f c9  . 
v_sub_7c6ch:
    call v_sub_8232h-BA1       ;85a0 cd 72 24  . r $               (flow from: 7d77)   7c6c call 8232 
    call v_sub_8a24h-BA1       ;85a3 cd 64 2c  . d ,               (flow from: 8244)   7c6f call 8a24 
    ccf                        ;85a6 3f  ?                         (flow from: 8a2e)   7c72 ccf 
    jr l85afh                  ;85a7 18 06  . .                    (flow from: 7c72)   7c73 jr 7c7b 
v_sub_7c75h:
    call v_sub_8245h-BA1       ;85a9 cd 85 24  . . $               (flow from: 7d3e)   7c75 call 8245 
    call v_sub_8a2fh-BA1       ;85ac cd 6f 2c  . o ,               (flow from: 825a)   7c78 call 8a2f 
l85afh:
    pop de                     ;85af d1  .                         (flow from: 7c73 8a3e)   7c7b pop de 
    jr nc,l8622h               ;85b0 30 70  0 p                    (flow from: 7c7b)   7c7c jr nc,7cee 
    push de                    ;85b2 d5  .                         (flow from: 7c7c)   7c7e push de 
    ld (v_sub_826ch+1-BA1),hl                                  ;85b3 22 ad 24  " . $                                                   (flow from: 7c7e)   7c7f ld (826d),hl 
    ret                        ;85b6 c9  .                         (flow from: 7c7f)   7c82 ret 
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
    ld e,020h                  ;85d5 1e 20  .   
v_l7ca3h:
    ld bc,v_l5dc3h-BA1         ;85d7 01 03 00  . . .               (flow from: 7ccc)   7ca3 ld bc,0003 
l85dah:
    ld a,e                     ;85da 7b  {                         (flow from: 7ca3 7caa 7cad)   7ca6 ld a,e 
    call v_sub_8769h-BA1       ;85db cd a9 29  . . )               (flow from: 7ca6)   7ca7 call 8769 
    djnz l85dah                ;85de 10 fa  . .                    (flow from: 877e)   7caa djnz 7ca6 
    dec c                      ;85e0 0d  .                         (flow from: 7caa)   7cac dec c 
    jr nz,l85dah               ;85e1 20 f7    .                    (flow from: 7cac)   7cad jr nz,7ca6 
    ret                        ;85e3 c9  .                         (flow from: 7cad)   7caf ret 
    ld a,001h                  ;85e4 3e 01  > . 
    ld (01ef9h),a              ;85e6 32 f9 1e  2 . . 
    call v_sub_7805h-BA1       ;85e9 cd 45 1a  . E . 
    ld a,000h                  ;85ec 3e 00  > . 
    or a                       ;85ee b7  . 
    ld a,013h                  ;85ef 3e 13  > . 
    jp nz,v_l809ah-BA1         ;85f1 c2 da 22  . . " 
    call v_sub_7ca1h-BA1       ;85f4 cd e1 1e  . . . 
    call 00000h                ;85f7 cd 00 00  . . . 
v_l7cc6h:
    call v_sub_8639h-BA1       ;85fa cd 79 28  . y ( 
v_l7cc9h:
    di                         ;85fd f3  .                         (flow from: 5dc0)   7cc9 di 
    ld e,07eh                  ;85fe 1e 7e  . ~                    (flow from: 7cc9)   7cca ld e,7e 
    call v_l7ca3h-BA1          ;8600 cd e3 1e  . . .               (flow from: 7cca)   7ccc call 7ca3 
l8603h:
v_l7ccfh:
    ld hl,059e0h               ;8603 21 e0 59  ! . Y               (flow from: 777a 7caf 7e38)   7ccf ld hl,59e0 
    ld bc,02030h               ;8606 01 30 20  . 0                 (flow from: 7ccf)   7cd2 ld bc,2030 
    call v_l82e1h-BA1          ;8609 cd 21 25  . ! %               (flow from: 7cd2)   7cd5 call 82e1 
    ld a,00fh                  ;860c 3e 0f  > .                    (flow from: 82e5)   7cd8 ld a,0f 
v_l7cdah:
    call v_l89f4h-BA1          ;860e cd 34 2c  . 4 ,               (flow from: 7cd8)   7cda call 89f4 
    ld hl,v_l8aa5h-BA1         ;8611 21 e5 2c  ! . ,               (flow from: 8a1d)   7cdd ld hl,8aa5 
    ld bc,l9e00h               ;8614 01 00 9e  . . .               (flow from: 7cdd)   7ce0 ld bc,9e00 
    call v_l82e1h-BA1          ;8617 cd 21 25  . ! %               (flow from: 7ce0)   7ce3 call 82e1 
    ld hl,v_l8affh-BA1         ;861a 21 3f 2d  ! ? -               (flow from: 82e5)   7ce6 ld hl,8aff 
    ld (hl),001h               ;861d 36 01  6 .                    (flow from: 7ce6)   7ce9 ld (hl),01 
    dec hl                     ;861f 2b  +                         (flow from: 7ce9)   7ceb dec hl 
    ld (hl),080h               ;8620 36 80  6 .                    (flow from: 7ceb)   7cec ld (hl),80 
l8622h:
v_l7ceeh:
    ld sp,08ba1h-BA            ;8622 31 e1 2d  1 . -               (flow from: 7c7c 7cec 7d36 7d43)   7cee ld sp,8ba1 
    call v_sub_826ch-BA1       ;8625 cd ac 24  . . $               (flow from: 7cee)   7cf1 call 826c 
l8628h:
    call v_sub_85beh-BA1       ;8628 cd fe 27  . . '               (flow from: 7d71 828e)   7cf4 call 85be 
    call v_sub_7800h-BA1       ;862b cd 40 1a  . @ .               (flow from: 85db)   7cf7 call 7800 
    call v_sub_8639h-BA1       ;862e cd 79 28  . y (               (flow from: 7804)   7cfa call 8639 
    push af                    ;8631 f5  .                         (flow from: 86a0 86ad)   7cfd push af 
l08632h:
                               ; value of the argument is modified directly in the code at address 8639
    ld a,00fh                  ;8632 3e 0f  > .                    (flow from: 7cfd)   7cfe ld a,0f 
    call v_l89f4h-BA1          ;8634 cd 34 2c  . 4 ,               (flow from: 7cfe)   7d00 call 89f4 
    ld a,00fh                  ;8637 3e 0f  > .                    (flow from: 8a1d)   7d03 ld a,0f 
    ld (l08632h+1-BA1),a                                       ;8639 32 3f 1f  2 ? .                                                   (flow from: 7d03)   7d05 ld (7cff),a                                (flow from: 7d03)   7d05 ld (7cff),a 
    pop af                     ;863c f1  .                         (flow from: 7d05)   7d08 pop af 
    cp 015h                    ;863d fe 15  . .                    (flow from: 7d08)   7d09 cp 15 
    jr z,l8603h                ;863f 28 c2  ( .                    (flow from: 7d09)   7d0b jr z,7ccf 
    cp 004h                    ;8641 fe 04  . .                    (flow from: 7d0b)   7d0d cp 04 
    jr nz,l865eh               ;8643 20 19    .                    (flow from: 7d0d)   7d0f jr nz,7d2a 
    ld ix,(v_sub_826ch+1-BA1)                                  ;8645 dd 2a ad 24  . * . $                                              (flow from: 7d0f)   7d11 ld ix,(826d) 
    ld hl,v_l8affh-BA1         ;8649 21 3f 2d  ! ? -               (flow from: 7d11)   7d15 ld hl,8aff 
    push hl                    ;864c e5  .                         (flow from: 7d15)   7d18 push hl 
    ld bc,02000h               ;864d 01 00 20  . .                 (flow from: 7d18)   7d19 ld bc,2000 
    call v_l82e1h-BA1          ;8650 cd 21 25  . ! %               (flow from: 7d19)   7d1c call 82e1 
    pop hl                     ;8653 e1  .                         (flow from: 82e5)   7d1f pop hl 
    call v_sub_8138h-BA1       ;8654 cd 78 23  . x #               (flow from: 7d1f)   7d20 call 8138 
    ld a,001h                  ;8657 3e 01  > .                    (flow from: 81b6)   7d23 ld a,01 
    ld (0205fh),a              ;8659 32 5f 20  2 _                 (flow from: 7d23)   7d25 ld (7e1f),a 
    jr l8665h                  ;865c 18 07  . .                    (flow from: 7d25)   7d28 jr 7d31 
l865eh:
    cp 014h                    ;865e fe 14  . .                    (flow from: 7d0f)   7d2a cp 14 
    jr nz,l866ch               ;8660 20 0a    .                    (flow from: 7d2a)   7d2c jr nz,7d38 
    call v_sub_7c3eh-BA1       ;8662 cd 7e 1e  . ~ . 
l8665h:
    ld a,00fh                  ;8665 3e 0f  > .                    (flow from: 7d28)   7d31 ld a,0f 
    call v_l89f4h-BA1          ;8667 cd 34 2c  . 4 ,               (flow from: 7d31)   7d33 call 89f4 
    jr l8622h                  ;866a 18 b6  . .                    (flow from: 8a1d)   7d36 jr 7cee 
l866ch:
    ld b,014h                  ;866c 06 14  . .                    (flow from: 7d2c)   7d38 ld b,14 
    cp 006h                    ;866e fe 06  . .                    (flow from: 7d38)   7d3a cp 06 
    jr nz,l8679h               ;8670 20 07    .                    (flow from: 7d3a)   7d3c jr nz,7d45 
l8672h:
    call v_sub_7c75h-BA1       ;8672 cd b5 1e  . . .               (flow from: 7d3c)   7d3e call 7c75 
    djnz l8672h                ;8675 10 fb  . . 
l8677h:
    jr l8622h                  ;8677 18 a9  . .                    (flow from: 7d7c)   7d43 jr 7cee 
l8679h:
    cp 009h                    ;8679 fe 09  . .                    (flow from: 7d3c)   7d45 cp 09 
    jr nz,l86a7h               ;867b 20 2a    *                    (flow from: 7d45)   7d47 jr nz,7d73 
l867dh:
    call v_sub_7c75h-BA1       ;867d cd b5 1e  . . . 
    ld de,04040h               ;8680 11 40 40  . @ @ 
    ld a,018h                  ;8683 3e 18  > . 
l8685h:
    call v_sub_7c54h-BA1       ;8685 cd 94 1e  . . . 
    add a,008h                 ;8688 c6 08  . . 
    cp 0a9h                    ;868a fe a9  . . 
    jr c,l8685h                ;868c 38 f7  8 . 
    ld hl,050a0h               ;868e 21 a0 50  ! . P 
    call v_sub_85f5h-BA1       ;8691 cd 35 28  . 5 ( 
    ld b,006h                  ;8694 06 06  . . 
    ld hl,(v_sub_826ch+1-BA1)                                  ;8696 2a ad 24  * . $ 
l8699h:
    call v_sub_8248h-BA1       ;8699 cd 88 24  . . $ 
    djnz l8699h                ;869c 10 fb  . . 
    call v_sub_7c61h-BA1       ;869e cd a1 1e  . . . 
    bit 4,a                    ;86a1 cb 67  . g 
    jr z,l867dh                ;86a3 28 d8  ( . 
l86a5h:
    jr l8628h                  ;86a5 18 81  . .                    (flow from: 7daa)   7d71 jr 7cf4 
l86a7h:
    cp 007h                    ;86a7 fe 07  . .                    (flow from: 7d47)   7d73 cp 07 
    jr nz,l86b2h               ;86a9 20 07    .                    (flow from: 7d73)   7d75 jr nz,7d7e 
l86abh:
    call v_sub_7c6ch-BA1       ;86ab cd ac 1e  . . .               (flow from: 7d75 7d7a)   7d77 call 7c6c 
    djnz l86abh                ;86ae 10 fb  . .                    (flow from: 7c82)   7d7a djnz 7d77 
l86b0h:
    jr l8677h                  ;86b0 18 c5  . .                    (flow from: 7d7a)   7d7c jr 7d43 
l86b2h:
    cp 00ah                    ;86b2 fe 0a  . .                    (flow from: 7d75)   7d7e cp 0a 
    jr nz,l86e0h               ;86b4 20 2a    *                    (flow from: 7d7e)   7d80 jr nz,7dac 
l86b6h:
    call v_sub_7c6ch-BA1       ;86b6 cd ac 1e  . . . 
    ld de,050a0h               ;86b9 11 a0 50  . . P 
    ld a,0a0h                  ;86bc 3e a0  > . 
l86beh:
    call v_sub_7c54h-BA1       ;86be cd 94 1e  . . . 
    sub 008h                   ;86c1 d6 08  . . 
    cp 010h                    ;86c3 fe 10  . . 
    jr nc,l86beh               ;86c5 30 f7  0 . 
    ld hl,04040h               ;86c7 21 40 40  ! @ @ 
    call v_sub_85f5h-BA1       ;86ca cd 35 28  . 5 ( 
    ld b,00dh                  ;86cd 06 0d  . . 
    ld hl,(v_sub_826ch+1-BA1)                                  ;86cf 2a ad 24  * . $ 
l86d2h:
    call v_sub_8235h-BA1       ;86d2 cd 75 24  . u $ 
    djnz l86d2h                ;86d5 10 fb  . . 
    call v_sub_7c61h-BA1       ;86d7 cd a1 1e  . . . 
    bit 3,a                    ;86da cb 5f  . _ 
    jr z,l86b6h                ;86dc 28 d8  ( . 
l86deh:
    jr l86a5h                  ;86de 18 c5  . .                    (flow from: 7ddb)   7daa jr 7d71 
l86e0h:
    cp 00ch                    ;86e0 fe 0c  . .                    (flow from: 7d80)   7dac cp 0c 
    jr nz,l86fah               ;86e2 20 16    .                    (flow from: 7dac)   7dae jr nz,7dc6 
    ld bc,00001h               ;86e4 01 01 00  . . . 
    ld hl,(v_sub_826ch+1-BA1)                                  ;86e7 2a ad 24  * . $ 
    call v_sub_721ah-BA1       ;86ea cd 5a 14  . Z . 
    call v_sub_8a24h-BA1       ;86ed cd 64 2c  . d , 
    jr z,l86b0h                ;86f0 28 be  ( . 
    call nc,v_sub_8235h-BA1    ;86f2 d4 75 24  . u $ 
    ld (v_sub_826ch+1-BA1),hl                                  ;86f5 22 ad 24  " . $ 
l86f8h:
    jr l86b0h                  ;86f8 18 b6  . . 
l86fah:
    cp 00eh                    ;86fa fe 0e  . .                    (flow from: 7dae)   7dc6 cp 0e 
    jr nz,l870ch               ;86fc 20 0e    .                    (flow from: 7dc6)   7dc8 jr nz,7dd8 
    ld hl,(0232bh)             ;86fe 2a 2b 23  * + # 
    ld (02328h),hl             ;8701 22 28 23  " ( # 
    ld hl,(v_sub_826ch+1-BA1)                                  ;8704 2a ad 24  * . $ 
    ld (0232bh),hl             ;8707 22 2b 23  " + # 
    jr l86f8h                  ;870a 18 ec  . . 
l870ch:
    call v_sub_7e3bh-BA1       ;870c cd 7b 20  . {                 (flow from: 7dc8)   7dd8 call 7e3b 
    jr nz,l86deh               ;870f 20 cd    .                    (flow from: 7e40 7e73)   7ddb jr nz,7daa 
v_l7dddh:
    ld hl,05ae0h               ;8711 21 e0 5a  ! . Z               (flow from: 775d 7ddb)   7ddd ld hl,5ae0 
    ld bc,0203fh               ;8714 01 3f 20  . ?                 (flow from: 7ddd)   7de0 ld bc,203f 
    call v_l82e1h-BA1          ;8717 cd 21 25  . ! %               (flow from: 7de0)   7de3 call 82e1 
    ld hl,v_l8affh-BA1         ;871a 21 3f 2d  ! ? -               (flow from: 82e5)   7de6 ld hl,8aff 
    call v_sub_85aeh-BA1       ;871d cd ee 27  . . '               (flow from: 7de6)   7de9 call 85ae 
    ld d,000h                  ;8720 16 00  . .                    (flow from: 85b1)   7dec ld d,00 
    ld c,009h                  ;8722 0e 09  . .                    (flow from: 7dec)   7dee ld c,09 
    cp 080h                    ;8724 fe 80  . .                    (flow from: 7dee)   7df0 cp 80 
    jr c,l873bh                ;8726 38 13  8 .                    (flow from: 7df0)   7df2 jr c,7e07 
    ld hl,v_l7ccfh-BA1         ;8728 21 0f 1f  ! . .               (flow from: 7df2)   7df4 ld hl,7ccf 
    ld (02079h),hl             ;872b 22 79 20  " y                 (flow from: 7df4)   7df7 ld (7e39),hl 
    push hl                    ;872e e5  .                         (flow from: 7df7)   7dfa push hl 
    ld h,d                     ;872f 62  b                         (flow from: 7dfa)   7dfb ld h,d 
    ld l,a                     ;8730 6f  o                         (flow from: 7dfb)   7dfc ld l,a 
    ld de,v_l6fc9h-BA1         ;8731 11 09 12  . . .               (flow from: 7dfc)   7dfd ld de,6fc9 
    add hl,hl                  ;8734 29  )                         (flow from: 7dfd)   7e00 add hl,hl 
    add hl,de                  ;8735 19  .                         (flow from: 7e00)   7e01 add hl,de 
    ld a,(hl)                  ;8736 7e  ~                         (flow from: 7e01)   7e02 ld a,(hl) 
    inc hl                     ;8737 23  #                         (flow from: 7e02)   7e03 inc hl 
    ld h,(hl)                  ;8738 66  f                         (flow from: 7e03)   7e04 ld h,(hl) 
    ld l,a                     ;8739 6f  o                         (flow from: 7e04)   7e05 ld l,a 
    jp (hl)                    ;873a e9  .                         (flow from: 7e05)   7e06 jp hl 
l873bh:
v_l7e07h:
    call v_sub_7ee7h-BA1       ;873b cd 27 21  . ' !               (flow from: 7df2)   7e07 call 7ee7 
    call v_sub_8245h-BA1       ;873e cd 85 24  . . $               (flow from: 8000)   7e0a call 8245 
    push hl                    ;8741 e5  .                         (flow from: 8255 825a)   7e0d push hl 
    ld (02bafh),hl             ;8742 22 af 2b  " . +               (flow from: 7e0d)   7e0e ld (896f),hl 
    ld de,v_l8b21h-BA1         ;8745 11 61 2d  . a -               (flow from: 7e0e)   7e11 ld de,8b21 
    ld a,(de)                  ;8748 1a  .                         (flow from: 7e11)   7e14 ld a,(de) 
    ld c,a                     ;8749 4f  O                         (flow from: 7e14)   7e15 ld c,a 
    inc de                     ;874a 13  .                         (flow from: 7e15)   7e16 inc de 
    call v_sub_8a6ch-BA1       ;874b cd ac 2c  . . ,               (flow from: 7e16)   7e17 call 8a6c 
    pop hl                     ;874e e1  .                         (flow from: 8aa3)   7e1a pop hl 
    ld (v_sub_826ch+1-BA1),hl                                  ;874f 22 ad 24  " . $                                                   (flow from: 7e1a)   7e1b ld (826d),hl 
    ld a,000h                  ;8752 3e 00  > .                    (flow from: 7e1b)   7e1e ld a,01 
    or a                       ;8754 b7  .                         (flow from: 7e1e)   7e20 or a 
    jr z,l8763h                ;8755 28 0c  ( .                    (flow from: 7e20)   7e21 jr z,7e2f 
    call v_sub_8232h-BA1       ;8757 cd 72 24  . r $               (flow from: 7e21)   7e23 call 8232 
    ld (v_sub_826ch+1-BA1),hl                                  ;875a 22 ad 24  " . $                                                   (flow from: 8244)   7e26 ld (826d),hl 
    ld bc,00001h               ;875d 01 01 00  . . .               (flow from: 7e26)   7e29 ld bc,0001 
    call v_sub_898ah-BA1       ;8760 cd ca 2b  . . +               (flow from: 7e29)   7e2c call 898a 
l8763h:
    ld a,00fh                  ;8763 3e 0f  > .                    (flow from: 7e21 8989)   7e2f ld a,0f 
    ld (01f3fh),a              ;8765 32 3f 1f  2 ? .               (flow from: 7e2f)   7e31 ld (7cff),a 
v_l7e34h:
    xor a                      ;8768 af  .                         (flow from: 7e31)   7e34 xor a 
    ld (0205fh),a              ;8769 32 5f 20  2 _                 (flow from: 7e34)   7e35 ld (7e1f),a 
    jp v_l7ccfh-BA1            ;876c c3 0f 1f  . . .               (flow from: 7e35)   7e38 jp 7ccf 
v_sub_7e3bh:
    ld hl,02d40h               ;876f 21 40 2d  ! @ -               (flow from: 7dd8)   7e3b ld hl,8b00 
    cp 00dh                    ;8772 fe 0d  . .                    (flow from: 7e3b)   7e3e cp 0d 
    ret z                      ;8774 c8  .                         (flow from: 7e3e)   7e40 ret z 
    cp 008h                    ;8775 fe 08  . .                    (flow from: 7e40)   7e41 cp 08 
    jr nz,l8785h               ;8777 20 0c    .                    (flow from: 7e41)   7e43 jr nz,7e51 
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
    cp 00bh                    ;8785 fe 0b  . .                    (flow from: 7e43)   7e51 cp 0b 
    jr nz,l8793h               ;8787 20 0a    .                    (flow from: 7e51)   7e53 jr nz,7e5f 
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
    cp 003h                    ;8793 fe 03  . .                    (flow from: 7e53)   7e5f cp 03 
    jr nz,l87a8h               ;8795 20 11    .                    (flow from: 7e5f)   7e61 jr nz,7e74 
    ld d,h                     ;8797 54  T                         (flow from: 7e61)   7e63 ld d,h 
    ld e,l                     ;8798 5d  ]                         (flow from: 7e63)   7e64 ld e,l 
    dec hl                     ;8799 2b  +                         (flow from: 7e64)   7e65 dec hl 
    ld a,(hl)                  ;879a 7e  ~                         (flow from: 7e65)   7e66 ld a,(hl) 
    cp 080h                    ;879b fe 80  . .                    (flow from: 7e66)   7e67 cp 80 
    jr z,l87a6h                ;879d 28 07  ( .                    (flow from: 7e67)   7e69 jr z,7e72 
l879fh:
    ld a,(de)                  ;879f 1a  .                         (flow from: 7e69 7e70)   7e6b ld a,(de) 
    ld (hl),a                  ;87a0 77  w                         (flow from: 7e6b)   7e6c ld (hl),a 
    inc hl                     ;87a1 23  #                         (flow from: 7e6c)   7e6d inc hl 
    inc de                     ;87a2 13  .                         (flow from: 7e6d)   7e6e inc de 
    or a                       ;87a3 b7  .                         (flow from: 7e6e)   7e6f or a 
    jr nz,l879fh               ;87a4 20 f9    .                    (flow from: 7e6f)   7e70 jr nz,7e6b 
l87a6h:
    inc a                      ;87a6 3c  <                         (flow from: 7e70 7e7f 7ec7)   7e72 inc a 
    ret                        ;87a7 c9  .                         (flow from: 7e72)   7e73 ret 
l87a8h:
    cp 005h                    ;87a8 fe 05  . .                    (flow from: 7e61)   7e74 cp 05 
    jr nz,l87b5h               ;87aa 20 09    .                    (flow from: 7e74)   7e76 jr nz,7e81 
    ld hl,028aeh               ;87ac 21 ae 28  ! . (               (flow from: 7e76)   7e78 ld hl,866e 
    ld a,0f7h                  ;87af 3e f7  > .                    (flow from: 7e78)   7e7b ld a,f7 
    sub (hl)                   ;87b1 96  .                         (flow from: 7e7b)   7e7d sub (hl) 
    ld (hl),a                  ;87b2 77  w                         (flow from: 7e7d)   7e7e ld (hl),a 
    jr l87a6h                  ;87b3 18 f1  . .                    (flow from: 7e7e)   7e7f jr 7e72 
l87b5h:
    cp 020h                    ;87b5 fe 20  .                      (flow from: 7e76)   7e81 cp 20 
    ret c                      ;87b7 d8  .                         (flow from: 7e81)   7e83 ret c 
    ld b,a                     ;87b8 47  G                         (flow from: 7e83)   7e84 ld b,a 
    jr nz,l87e0h               ;87b9 20 25    %                    (flow from: 7e84)   7e85 jr nz,7eac 
    ld de,v_l8affh-BA1         ;87bb 11 3f 2d  . ? - 
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
l87cdh:
    jr c,l87e0h                ;87cd 38 11  8 . 
    cp 005h                    ;87cf fe 05  . . 
    jr c,l87d5h                ;87d1 38 02  8 . 
    sub 005h                   ;87d3 d6 05  . . 
l87d5h:
    ld b,a                     ;87d5 47  G 
    inc b                      ;87d6 04  . 
    ld c,020h                  ;87d7 0e 20  .   
    call v_l82e1h-BA1          ;87d9 cd 21 25  . ! % 
    ld (hl),001h               ;87dc 36 01  6 . 
    jr l87a6h                  ;87de 18 c6  . . 
l87e0h:
    ld a,007h                  ;87e0 3e 07  > .                    (flow from: 7e85)   7eac ld a,01 
    or a                       ;87e2 b7  .                         (flow from: 7eac)   7eae or a 
    jr z,l87a6h                ;87e3 28 c1  ( .                    (flow from: 7eae)   7eaf jr z,7e72 
    ld a,b                     ;87e5 78  x                         (flow from: 7eaf)   7eb1 ld a,b 
l87e6h:
    ex af,af'                  ;87e6 08  .                         (flow from: 7eb1 7ec5)   7eb2 ex af,af' 
    ld a,(hl)                  ;87e7 7e  ~                         (flow from: 7eb2)   7eb3 ld a,(hl) 
    ex af,af'                  ;87e8 08  .                         (flow from: 7eb3)   7eb4 ex af,af' 
    ld (hl),a                  ;87e9 77  w                         (flow from: 7eb4)   7eb5 ld (hl),a 
    cp 0c5h                    ;87ea fe c5  . .                    (flow from: 7eb5)   7eb6 cp c5 
    ret z                      ;87ec c8  .                         (flow from: 7eb6)   7eb8 ret z 
    cp 0c8h                    ;87ed fe c8  . .                    (flow from: 7eb8)   7eb9 cp c8 
    ret z                      ;87ef c8  .                         (flow from: 7eb9)   7ebb ret z 
    cp 0cbh                    ;87f0 fe cb  . .                    (flow from: 7ebb)   7ebc cp cb 
    ret z                      ;87f2 c8  .                         (flow from: 7ebc)   7ebe ret z 
    cp 0d7h                    ;87f3 fe d7  . .                    (flow from: 7ebe)   7ebf cp d7 
    ret z                      ;87f5 c8  .                         (flow from: 7ebf)   7ec1 ret z 
    inc hl                     ;87f6 23  #                         (flow from: 7ec1)   7ec2 inc hl 
    ex af,af'                  ;87f7 08  .                         (flow from: 7ec2)   7ec3 ex af,af' 
    or a                       ;87f8 b7  .                         (flow from: 7ec3)   7ec4 or a 
    jr nz,l87e6h               ;87f9 20 eb    .                    (flow from: 7ec4)   7ec5 jr nz,7eb2 
    jr l87a6h                  ;87fb 18 a9  . .                    (flow from: 7ec5)   7ec7 jr 7e72 
l87fdh:
    ld ix,v_l8b24h-BA1         ;87fd dd 21 64 2d  . ! d - 
    ld (ix-002h),001h          ;8801 dd 36 fe 01  . 6 . . 
    ld (ix-001h),037h          ;8805 dd 36 ff 37  . 6 . 7 
    ld b,0ffh                  ;8809 06 ff  . . 
    jr l8810h                  ;880b 18 03  . . 
l880dh:
    call v_sub_85adh-BA1       ;880d cd ed 27  . . ' 
l8810h:
    call v_sub_8962h-BA1       ;8810 cd a2 2b  . . + 
    or a                       ;8813 b7  . 
    jr nz,l880dh               ;8814 20 f7    . 
    dec ix                     ;8816 dd 2b  . + 
    jp v_l7fefh-BA1            ;8818 c3 2f 22  . / " 
v_sub_7ee7h:
    cp 03bh                    ;881b fe 3b  .                  ;   (flow from: 7e07)   7ee7 cp 3b 
    jr z,l87fdh                ;881d 28 de  ( .                    (flow from: 7ee7)   7ee9 jr z,7ec9 
    cp 020h                    ;881f fe 20  .                      (flow from: 7ee9)   7eeb cp 20 
    call nz,v_sub_856fh-BA1    ;8821 c4 af 27  . . '               (flow from: 7eeb)   7eed call nz,856f 
    call v_sub_85b5h-BA1       ;8824 cd f5 27  . . '               (flow from: 7eed 8585)   7ef0 call 85b5 
    ld de,v_l8af9h-BA1         ;8827 11 39 2d  . 9 -               (flow from: 85ba)   7ef3 ld de,8af9 
    ld c,005h                  ;882a 0e 05  . .                    (flow from: 7ef3)   7ef6 ld c,05 
    call v_sub_856fh-BA1       ;882c cd af 27  . . '               (flow from: 7ef6)   7ef8 call 856f 
    call v_sub_85b5h-BA1       ;882f cd f5 27  . . '               (flow from: 8585 8590)   7efb call 85b5 
    ld de,v_l8ae5h-BA1         ;8832 11 25 2d  . % -               (flow from: 85ba)   7efe ld de,8ae5 
    ld c,012h                  ;8835 0e 12  . .                    (flow from: 7efe)   7f01 ld c,12 
    call v_sub_8573h-BA1       ;8837 cd b3 27  . . '               (flow from: 7f01)   7f03 call 8573 
    jr nz,l8840h               ;883a 20 04    .                    (flow from: 8585 8590)   7f06 jr nz,7f0c 
    inc hl                     ;883c 23  #                         (flow from: 7f06)   7f08 inc hl 
    ld (v_l8af8h-BA1),a        ;883d 32 38 2d  2 8 -               (flow from: 7f08)   7f09 ld (8af8),a 
l8840h:
    ld de,v_l8ad1h-BA1         ;8840 11 11 2d  . . -               (flow from: 7f06 7f09)   7f0c ld de,8ad1 
    ld c,012h                  ;8843 0e 12  . .                    (flow from: 7f0c)   7f0f ld c,12 
    call v_sub_8577h-BA1       ;8845 cd b7 27  . . '               (flow from: 7f0f)   7f11 call 8577 
    call v_sub_838bh-BA1       ;8848 cd cb 25  . . %               (flow from: 8585)   7f14 call 838b 
    ld hl,v_l8af9h-BA1         ;884b 21 39 2d  ! 9 -               (flow from: 839f)   7f17 ld hl,8af9 
    ld a,(hl)                  ;884e 7e  ~                         (flow from: 7f17)   7f1a ld a,(hl) 
    or a                       ;884f b7  .                         (flow from: 7f1a)   7f1b or a 
    jr z,l8863h                ;8850 28 11  ( .                    (flow from: 7f1b)   7f1c jr z,7f2f 
    push hl                    ;8852 e5  .                         (flow from: 7f1c)   7f1e push hl 
    call v_sub_851fh-BA1       ;8853 cd 5f 27  . _ '               (flow from: 7f1e)   7f1f call 851f 
    ld hl,v_l8545h-BA1         ;8856 21 85 27  ! . '               (flow from: 8522)   7f22 ld hl,8545 
    call v_sub_8559h-BA1       ;8859 cd 99 27  . . '               (flow from: 7f22)   7f25 call 8559 
    pop hl                     ;885c e1  .                         (flow from: 856e)   7f28 pop hl 
    call v_sub_8527h-BA1       ;885d cd 67 27  . g '               (flow from: 7f28)   7f29 call 8527 
    jp c,v_l807dh-BA1          ;8860 da bd 22  . . "               (flow from: 8538)   7f2c jp c,807d 
l8863h:
    ld (021d9h),a              ;8863 32 d9 21  2 . !               (flow from: 7f1c 7f2c)   7f2f ld (7f99),a 
    cp 03ah                    ;8866 fe 3a  . :                    (flow from: 7f2f)   7f32 cp 3a 
    jr c,l886fh                ;8868 38 05  8 .                    (flow from: 7f32)   7f34 jr c,7f3b 
    cp 03eh                    ;886a fe 3e  . >                    (flow from: 7f34)   7f36 cp 3e 
    jp c,v_l8001h-BA1          ;886c da 41 22  . A "               (flow from: 7f36)   7f38 jp c,8001 
l886fh:
    ld hl,v_l8ae5h-BA1         ;886f 21 25 2d  ! % -               (flow from: 7f34 7f38)   7f3b ld hl,8ae5 
    push hl                    ;8872 e5  .                         (flow from: 7f3b)   7f3e push hl 
    call v_sub_851fh-BA1       ;8873 cd 5f 27  . _ '               (flow from: 7f3e)   7f3f call 851f 
    pop hl                     ;8876 e1  .                         (flow from: 8522)   7f42 pop hl 
    ld a,b                     ;8877 78  x                         (flow from: 7f42)   7f43 ld a,b 
    dec a                      ;8878 3d  =                         (flow from: 7f43)   7f44 dec a 
    jr nz,l88a3h               ;8879 20 28    (                    (flow from: 7f44)   7f45 jr nz,7f6f 
    ld a,(021d9h)              ;887b 3a d9 21  : . !               (flow from: 7f45)   7f47 ld a,(7f99) 
    cp 006h                    ;887e fe 06  . .                    (flow from: 7f47)   7f4a cp 06 
    jr nz,l8890h               ;8880 20 0e    .                    (flow from: 7f4a)   7f4c jr nz,7f5c 
    ld a,(hl)                  ;8882 7e  ~                         (flow from: 7f4c)   7f4e ld a,(hl) 
    sub 02fh                   ;8883 d6 2f  . /                    (flow from: 7f4e)   7f4f sub 2f 
    cp 004h                    ;8885 fe 04  . .                    (flow from: 7f4f)   7f51 cp 04 
l8887h:
    jp nc,v_l8081h-BA1         ;8887 d2 c1 22  . . "               (flow from: 7f51)   7f53 jp nc,8081 
    or a                       ;888a b7  .                         (flow from: 7f53)   7f56 or a 
    jp z,v_l8081h-BA1          ;888b ca c1 22  . . "               (flow from: 7f56)   7f57 jp z,8081 
    jr l88a6h                  ;888e 18 16  . .                    (flow from: 7f57)   7f5a jr 7f72 
l8890h:
    cp 011h                    ;8890 fe 11  . .                    (flow from: 7f4c)   7f5c cp 11 
    jr z,l889ch                ;8892 28 08  ( .                    (flow from: 7f5c)   7f5e jr z,7f68 
    cp 026h                    ;8894 fe 26  . &                    (flow from: 7f5e)   7f60 cp 26 
    jr z,l889ch                ;8896 28 04  ( .                    (flow from: 7f60)   7f62 jr z,7f68 
    cp 031h                    ;8898 fe 31  . 1                    (flow from: 7f62)   7f64 cp 31 
    jr nz,l88a3h               ;889a 20 07    .                    (flow from: 7f64)   7f66 jr nz,7f6f 
l889ch:
    ld a,(hl)                  ;889c 7e  ~ 
    sub 02fh                   ;889d d6 2f  . / 
    cp 009h                    ;889f fe 09  . . 
    jr l8887h                  ;88a1 18 e4  . . 
l88a3h:
    call v_sub_84e0h-BA1       ;88a3 cd 20 27  .   '               (flow from: 7f45 7f66)   7f6f call 84e0 
l88a6h:
    ld (021cbh),a              ;88a6 32 cb 21  2 . !               (flow from: 7f5a 84e7 84f7 84fd 851c)   7f72 ld (7f8b),a 
    ld hl,v_l8ad1h-BA1         ;88a9 21 11 2d  ! . -               (flow from: 7f72)   7f75 ld hl,8ad1 
    call v_sub_84e0h-BA1       ;88ac cd 20 27  .   '               (flow from: 7f75)   7f78 call 84e0 
    ld (021c3h),a              ;88af 32 c3 21  2 . !               (flow from: 84e7 84f7 84fd 851c)   7f7b ld (7f83),a 
    xor a                      ;88b2 af  .                         (flow from: 7f7b)   7f7e xor a 
    ld (02201h),a              ;88b3 32 01 22  2 . "               (flow from: 7f7e)   7f7f ld (7fc1),a 
    ld a,000h                  ;88b6 3e 00  > .                    (flow from: 7f7f)   7f82 ld a,00 
    call v_sub_84c3h-BA1       ;88b8 cd 03 27  . . '               (flow from: 7f82)   7f84 call 84c3 
    add a,a                    ;88bb 87  .                         (flow from: 84d5)   7f87 add a,a 
    add a,a                    ;88bc 87  .                         (flow from: 7f87)   7f88 add a,a 
    ld e,a                     ;88bd 5f  _                         (flow from: 7f88)   7f89 ld e,a 
    ld a,000h                  ;88be 3e 00  > .                    (flow from: 7f89)   7f8a ld a,00 
    call v_sub_84c3h-BA1       ;88c0 cd 03 27  . . '               (flow from: 7f8a)   7f8c call 84c3 
    ld d,a                     ;88c3 57  W                         (flow from: 84d5 84df)   7f8f ld d,a 
    ld b,003h                  ;88c4 06 03  . .                    (flow from: 7f8f)   7f90 ld b,03 
l88c6h:
    sla e                      ;88c6 cb 23  . #                    (flow from: 7f90 7f96)   7f92 sla e 
    rl d                       ;88c8 cb 12  . .                    (flow from: 7f92)   7f94 rl d 
    djnz l88c6h                ;88ca 10 fa  . .                    (flow from: 7f94)   7f96 djnz 7f92 
    ld a,000h                  ;88cc 3e 00  > .                    (flow from: 7f96)   7f98 ld a,00 
    rla                        ;88ce 17  .                         (flow from: 7f98)   7f9a rla 
    ld hl,030e1h               ;88cf 21 e1 30  ! . 0               (flow from: 7f9a)   7f9b ld hl,8ea1 
    ld bc,002afh               ;88d2 01 af 02  . . .               (flow from: 7f9b)   7f9e ld bc,02af 
l88d5h:
    inc hl                     ;88d5 23  #                         (flow from: 7f9e 7fac)   7fa1 inc hl 
    ex af,af'                  ;88d6 08  .                         (flow from: 7fa1)   7fa2 ex af,af' 
l88d7h:
    inc hl                     ;88d7 23  #                         (flow from: 7fa2 7fb2 7fb8)   7fa3 inc hl 
    ex af,af'                  ;88d8 08  .                         (flow from: 7fa3)   7fa4 ex af,af' 
    inc hl                     ;88d9 23  #                         (flow from: 7fa4)   7fa5 inc hl 
    inc hl                     ;88da 23  #                         (flow from: 7fa5)   7fa6 inc hl 
    cpi                        ;88db ed a1  . .                    (flow from: 7fa6)   7fa7 cpi 
    jp po,v_l8098h-BA1         ;88dd e2 d8 22  . . "               (flow from: 7fa7)   7fa9 jp po,8098 
    jr nz,l88d5h               ;88e0 20 f3    .                    (flow from: 7fa9)   7fac jr nz,7fa1 
    ex af,af'                  ;88e2 08  .                         (flow from: 7fac)   7fae ex af,af' 
    ld a,(hl)                  ;88e3 7e  ~                         (flow from: 7fae)   7faf ld a,(hl) 
    inc hl                     ;88e4 23  #                         (flow from: 7faf)   7fb0 inc hl 
    cp d                       ;88e5 ba  .                         (flow from: 7fb0)   7fb1 cp d 
    jr nz,l88d7h               ;88e6 20 ef    .                    (flow from: 7fb1)   7fb2 jr nz,7fa3 
    ld a,(hl)                  ;88e8 7e  ~                         (flow from: 7fb2)   7fb4 ld a,(hl) 
    and 0e0h                   ;88e9 e6 e0  . .                    (flow from: 7fb4)   7fb5 and e0 
    cp e                       ;88eb bb  .                         (flow from: 7fb5)   7fb7 cp e 
    jr nz,l88d7h               ;88ec 20 e9    .                    (flow from: 7fb7)   7fb8 jr nz,7fa3 
    dec hl                     ;88ee 2b  +                         (flow from: 7fb8)   7fba dec hl 
    dec hl                     ;88ef 2b  +                         (flow from: 7fba)   7fbb dec hl 
    dec hl                     ;88f0 2b  +                         (flow from: 7fbb)   7fbc dec hl 
    ld d,(hl)                  ;88f1 56  V                         (flow from: 7fbc)   7fbd ld d,(hl) 
    dec hl                     ;88f2 2b  +                         (flow from: 7fbd)   7fbe dec hl 
    ld e,(hl)                  ;88f3 5e  ^                         (flow from: 7fbe)   7fbf ld e,(hl) 
    ld a,000h                  ;88f4 3e 00  > .                    (flow from: 7fbf)   7fc0 ld a,00 
    or a                       ;88f6 b7  .                         (flow from: 7fc0)   7fc2 or a 
    jr z,l88fdh                ;88f7 28 04  ( .                    (flow from: 7fc2)   7fc3 jr z,7fc9 
    res 5,d                    ;88f9 cb aa  . .                    (flow from: 7fc3)   7fc5 res 5,d 
    set 4,d                    ;88fb cb e2  . .                    (flow from: 7fc5)   7fc7 set 4,d 
l88fdh:
    call v_sub_82e6h-BA1       ;88fd cd 26 25  . & %               (flow from: 7fc3 7fc7)   7fc9 call 82e6 
    ld a,(021cbh)              ;8900 3a cb 21  : . !               (flow from: 8309 831b)   7fcc ld a,(7f8b) 
    cp 02ch                    ;8903 fe 2c  . ,                    (flow from: 7fcc)   7fcf cp 2c 
    ld de,v_l8ae5h-BA1         ;8905 11 25 2d  . % -               (flow from: 7fcf)   7fd1 ld de,8ae5 
    call nc,v_sub_83a0h-BA1    ;8908 d4 e0 25  . . %               (flow from: 7fd1)   7fd4 call nc,83a0 
    ld a,(021c3h)              ;890b 3a c3 21  : . !               (flow from: 7fd4 83fe)   7fd7 ld a,(7f83) 
    jr c,l891bh                ;890e 38 0b  8 .                    (flow from: 7fd7)   7fda jr c,7fe7 
    cp 02ch                    ;8910 fe 2c  . ,                    (flow from: 7fda)   7fdc cp 2c 
    jr c,l8923h                ;8912 38 0f  8 .                    (flow from: 7fdc)   7fde jr c,7fef 
    ld (ix+000h),01fh          ;8914 dd 36 00 1f  . 6 . . 
    inc ix                     ;8918 dd 23  . # 
    inc b                      ;891a 04  . 
l891bh:
    ld de,v_l8ad1h-BA1         ;891b 11 11 2d  . . -               (flow from: 7fda)   7fe7 ld de,8ad1 
    cp 02ch                    ;891e fe 2c  . ,                    (flow from: 7fe7)   7fea cp 2c 
    call nc,v_sub_83a0h-BA1    ;8920 d4 e0 25  . . %               (flow from: 7fea)   7fec call nc,83a0 
l8923h:
v_l7fefh:
    ld a,b                     ;8923 78  x                         (flow from: 7fde 7fec 803f 83fe)   7fef ld a,b 
    or a                       ;8924 b7  .                         (flow from: 7fef)   7ff0 or a 
    jr z,l892fh                ;8925 28 08  ( .                    (flow from: 7ff0)   7ff1 jr z,7ffb 
    set 7,b                    ;8927 cb f8  . .                    (flow from: 7ff1)   7ff3 set 7,b 
    set 6,b                    ;8929 cb f0  . .                    (flow from: 7ff3)   7ff5 set 6,b 
    ld (ix+000h),b             ;892b dd 70 00  . p .               (flow from: 7ff5)   7ff7 ld (ix+00),b 
    inc a                      ;892e 3c  <                         (flow from: 7ff7)   7ffa inc a 
l892fh:
    add a,002h                 ;892f c6 02  . .                    (flow from: 7ff1 7ffa)   7ffb add a,02 
    ld (v_l8b21h-BA1),a        ;8931 32 61 2d  2 a -               (flow from: 7ffb)   7ffd ld (8b21),a 
    ret                        ;8934 c9  .                         (flow from: 7ffd)   8000 ret 
v_l8001h:
    push af                    ;8935 f5  .                         (flow from: 7f38)   8001 push af 
    sub 034h                   ;8936 d6 34  . 4                    (flow from: 8001)   8002 sub 34 
    ld e,a                     ;8938 5f  _                         (flow from: 8002)   8004 ld e,a 
    ld d,037h                  ;8939 16 37  . 7                    (flow from: 8004)   8005 ld d,37 
    call v_sub_82e6h-BA1       ;893b cd 26 25  . & %               (flow from: 8005)   8007 call 82e6 
    push bc                    ;893e c5  .                         (flow from: 8309 831b)   800a push bc 
    ld hl,v_l8ae4h-BA1         ;893f 21 24 2d  ! $ -               (flow from: 800a)   800b ld hl,8ae4 
    xor a                      ;8942 af  .                         (flow from: 800b)   800e xor a 
    ld c,a                     ;8943 4f  O                         (flow from: 800e)   800f ld c,a 
l8944h:
    inc hl                     ;8944 23  #                         (flow from: 800f 8013)   8010 inc hl 
    inc c                      ;8945 0c  .                         (flow from: 8010)   8011 inc c 
    cp (hl)                    ;8946 be  .                         (flow from: 8011)   8012 cp (hl) 
    jr nz,l8944h               ;8947 20 fb    .                    (flow from: 8012)   8013 jr nz,8010 
    ld de,v_l8ad1h-BA1         ;8949 11 11 2d  . . -               (flow from: 8013)   8015 ld de,8ad1 
    ld a,(de)                  ;894c 1a  .                         (flow from: 8015)   8018 ld a,(de) 
    or a                       ;894d b7  .                         (flow from: 8018)   8019 or a 
    jr z,l8954h                ;894e 28 04  ( .                    (flow from: 8019)   801a jr z,8020 
    ld (hl),02ch               ;8950 36 2c  6 ,                    (flow from: 801a)   801c ld (hl),2c 
    inc hl                     ;8952 23  #                         (flow from: 801c)   801e inc hl 
    xor a                      ;8953 af  .                         (flow from: 801e)   801f xor a 
l8954h:
    ex de,hl                   ;8954 eb  .                         (flow from: 801a 801f)   8020 ex de,hl 
l8955h:
    cp (hl)                    ;8955 be  .                         (flow from: 8020 8028)   8021 cp (hl) 
    jr z,l895eh                ;8956 28 06  ( .                    (flow from: 8021)   8022 jr z,802a 
    ldi                        ;8958 ed a0  . .                    (flow from: 8022)   8024 ldi 
    inc c                      ;895a 0c  .                         (flow from: 8024)   8026 inc c 
    inc c                      ;895b 0c  .                         (flow from: 8026)   8027 inc c 
    jr l8955h                  ;895c 18 f7  . .                    (flow from: 8027)   8028 jr 8021 
l895eh:
    ld a,012h                  ;895e 3e 12  > .                    (flow from: 8022)   802a ld a,12 
    cp c                       ;8960 b9  .                         (flow from: 802a)   802c cp c 
    jr c,l89bdh                ;8961 38 5a  8 Z                    (flow from: 802c)   802d jr c,8089 
    pop bc                     ;8963 c1  .                         (flow from: 802d)   802f pop bc 
    pop af                     ;8964 f1  .                         (flow from: 802f)   8030 pop af 
    cp 03bh                    ;8965 fe 3b  .                  ;   (flow from: 8030)   8031 cp 3b 
    jr z,l897eh                ;8967 28 15  ( .                    (flow from: 8031)   8033 jr z,804a 
    ld de,v_l8ae5h-BA1         ;8969 11 25 2d  . % -               (flow from: 8033)   8035 ld de,8ae5 
l896ch:
    ld a,02ch                  ;896c 3e 2c  > ,                    (flow from: 8035 8048)   8038 ld a,2c 
    call v_sub_83a0h-BA1       ;896e cd e0 25  . . %               (flow from: 8038 8394)   803a call 83a0 
    ld a,(de)                  ;8971 1a  .                         (flow from: 83fe)   803d ld a,(de) 
    or a                       ;8972 b7  .                         (flow from: 803d)   803e or a 
l8973h:
    jr z,l8923h                ;8973 28 ae  ( .                    (flow from: 803e)   803f jr z,7fef 
    ld (ix+000h),02ch          ;8975 dd 36 00 2c  . 6 . ,          (flow from: 803f)   8041 ld (ix+00),2c 
    inc ix                     ;8979 dd 23  . #                    (flow from: 8041)   8045 inc ix 
    inc b                      ;897b 04  .                         (flow from: 8045)   8047 inc b 
    jr l896ch                  ;897c 18 ee  . .                    (flow from: 8047)   8048 jr 8038 
l897eh:
    ld hl,v_l8ae5h-BA1         ;897e 21 25 2d  ! % - 
    call v_sub_808dh-BA1       ;8981 cd cd 22  . . " 
    call v_sub_8962h-BA1       ;8984 cd a2 2b  . . + 
    inc hl                     ;8987 23  # 
    ld a,(hl)                  ;8988 7e  ~ 
    call v_sub_8962h-BA1       ;8989 cd a2 2b  . . + 
    inc hl                     ;898c 23  # 
    ld a,(hl)                  ;898d 7e  ~ 
l898eh:
    call v_sub_8962h-BA1       ;898e cd a2 2b  . . + 
    inc hl                     ;8991 23  # 
    ld a,(hl)                  ;8992 7e  ~ 
    or a                       ;8993 b7  . 
    jr nz,l898eh               ;8994 20 f8    . 
    dec hl                     ;8996 2b  + 
    call v_sub_808dh-BA1       ;8997 cd cd 22  . . " 
    jr l8973h                  ;899a 18 d7  . . 
v_sub_8068h:
    push hl                    ;899c e5  .                         (flow from: 77de 881f 8a70)   8068 push hl 
    push de                    ;899d d5  .                         (flow from: 8068)   8069 push de 
    ld hl,(02a5ah)             ;899e 2a 5a 2a  * Z *               (flow from: 8069)   806a ld hl,(881a) 
    add hl,bc                  ;89a1 09  .                         (flow from: 806a)   806d add hl,bc 
    jr c,l89adh                ;89a2 38 09  8 .                    (flow from: 806d)   806e jr c,8079 
    ld de,(01b86h)             ;89a4 ed 5b 86 1b  . [ . .          (flow from: 806e)   8070 ld de,(7946) 
    sbc hl,de                  ;89a8 ed 52  . R                    (flow from: 8070)   8074 sbc hl,de 
    pop de                     ;89aa d1  .                         (flow from: 8074)   8076 pop de 
    pop hl                     ;89ab e1  .                         (flow from: 8076)   8077 pop hl 
    ret c                      ;89ac d8  .                         (flow from: 8077)   8078 ret c 
l89adh:
    ld a,007h                  ;89ad 3e 07  > . 
    jr l89ceh                  ;89af 18 1d  . . 
v_l807dh:
    ld a,001h                  ;89b1 3e 01  > . 
    jr l89ceh                  ;89b3 18 19  . . 
v_l8081h:
    ld a,002h                  ;89b5 3e 02  > . 
    jr l89ceh                  ;89b7 18 15  . . 
v_l8085h:
    ld a,003h                  ;89b9 3e 03  > . 
    jr l89ceh                  ;89bb 18 11  . . 
l89bdh:
v_l8089h:
    ld a,004h                  ;89bd 3e 04  > . 
    jr l89ceh                  ;89bf 18 0d  . . 
v_sub_808dh:
    ld a,(hl)                  ;89c1 7e  ~ 
    cp 027h                    ;89c2 fe 27  . ' 
    ret z                      ;89c4 c8  . 
    cp 022h                    ;89c5 fe 22  . " 
    ret z                      ;89c7 c8  . 
v_l8094h:
    ld a,005h                  ;89c8 3e 05  > . 
    jr l89ceh                  ;89ca 18 02  . . 
v_l8098h:
    ld a,006h                  ;89cc 3e 06  > . 
l89ceh:
v_l809ah:
    ex af,af'                  ;89ce 08  . 
    call v_sub_8713h-BA1       ;89cf cd 53 29  . S ) 
    ex af,af'                  ;89d2 08  . 
    call v_l89f4h-BA1          ;89d3 cd 34 2c  . 4 , 
v_l80a2h:
    call v_l82dbh-BA1          ;89d6 cd 1b 25  . . % 
    ld hl,(v_sub_826ch+1-BA1)                                  ;89d9 2a ad 24  * . $ 
    call v_sub_8a2fh-BA1       ;89dc cd 6f 2c  . o , 
    call z,v_sub_8235h-BA1     ;89df cc 75 24  . u $ 
    ld (v_sub_826ch+1-BA1),hl                                  ;89e2 22 ad 24  " . $ 
    jp v_l7ceeh-BA1            ;89e5 c3 2e 1f  . . . 
v_sub_80b4h:
    ld hl,04000h               ;89e8 21 00 40  ! . @               (flow from: 7bec 89f4)   80b4 ld hl,4000 
v_sub_80b7h:
    call v_sub_85f5h-BA1       ;89eb cd 35 28  . 5 (               (flow from: 80b4)   80b7 call 85f5 
    cp 009h                    ;89ee fe 09  . .                    (flow from: 8607)   80ba cp 09 
    jr nz,l8a00h               ;89f0 20 0e    .                    (flow from: 80ba)   80bc jr nz,80cc 
    push af                    ;89f2 f5  . 
    ld hl,v_l80e1h-BA1         ;89f3 21 21 23  ! ! # 
    call v_sub_80d7h-BA1       ;89f6 cd 17 23  . . # 
    ld hl,v_l80e1h-BA1         ;89f9 21 21 23  ! ! # 
    ld (02300h),hl             ;89fc 22 00 23  " . # 
    pop af                     ;89ff f1  . 
l8a00h:
    ld hl,08ba1h-BA            ;8a00 21 e1 2d  ! . -               (flow from: 80bc)   80cc ld hl,8ba1 
l8a03h:
    bit 7,(hl)                 ;8a03 cb 7e  . ~                    (flow from: 80cc 80d2 80d5)   80cf bit 7,(hl) 
    inc hl                     ;8a05 23  #                         (flow from: 80cf)   80d1 inc hl 
    jr z,l8a03h                ;8a06 28 fb  ( .                    (flow from: 80d1)   80d2 jr z,80cf 
    dec a                      ;8a08 3d  =                         (flow from: 80d2)   80d4 dec a 
    jr nz,l8a03h               ;8a09 20 f8    .                    (flow from: 80d4)   80d5 jr nz,80cf 
l8a0bh:
v_sub_80d7h:
    ld a,(hl)                  ;8a0b 7e  ~                         (flow from: 80d5 80de)   80d7 ld a,(hl) 
    call v_sub_8767h-BA1       ;8a0c cd a7 29  . . )               (flow from: 80d7)   80d8 call 8767 
    bit 7,(hl)                 ;8a0f cb 7e  . ~                    (flow from: 877e)   80db bit 7,(hl) 
    inc hl                     ;8a11 23  #                         (flow from: 80db)   80dd inc hl 
    jr z,l8a0bh                ;8a12 28 f7  ( .                    (flow from: 80dd)   80de jr z,80d7 
    ret                        ;8a14 c9  .                         (flow from: 80de)   80e0 ret 
v_l80e1h:
    ld d,e                     ;8a15 53  S 
    ld a,c                     ;8a16 79  y 
    ld l,l                     ;8a17 6d  m 
    ld h,d                     ;8a18 62  b 
    ld l,a                     ;8a19 6f  o 
    call pe,sub_6821h          ;8a1a ec 21 68  . ! h 
    ld a,011h                  ;8a1d 3e 11  > . 
    ld l,b                     ;8a1f 68  h 
    ld a,0e5h                  ;8a20 3e e5  > . 
    xor a                      ;8a22 af  .                         (flow from: 80ed)   80ee xor a 
    sbc hl,de                  ;8a23 ed 52  . R                    (flow from: 80ee)   80ef sbc hl,de 
    pop hl                     ;8a25 e1  .                         (flow from: 80ef)   80f1 pop hl 
    ret c                      ;8a26 d8  .                         (flow from: 80f1)   80f2 ret c 
    ex de,hl                   ;8a27 eb  .                         (flow from: 80f2)   80f3 ex de,hl 
    ret                        ;8a28 c9  .                         (flow from: 80f3)   80f4 ret 
v_sub_80f5h:
    exx                        ;8a29 d9  .                         (flow from: 8296)   80f5 exx 
    push ix                    ;8a2a dd e5  . .                    (flow from: 80f5)   80f6 push ix 
    call 02327h                ;8a2c cd 27 23  . ' #               (flow from: 80f6)   80f8 call 80e7 
    ld b,h                     ;8a2f 44  D                         (flow from: 80f4)   80fb ld b,h 
    ld c,l                     ;8a30 4d  M                         (flow from: 80fb)   80fc ld c,l 
    pop hl                     ;8a31 e1  .                         (flow from: 80fc)   80fd pop hl 
    push hl                    ;8a32 e5  .                         (flow from: 80fd)   80fe push hl 
    xor a                      ;8a33 af  .                         (flow from: 80fe)   80ff xor a 
    sbc hl,bc                  ;8a34 ed 42  . B                    (flow from: 80ff)   8100 sbc hl,bc 
    pop hl                     ;8a36 e1  .                         (flow from: 8100)   8102 pop hl 
    jr c,l8a3ch                ;8a37 38 03  8 .                    (flow from: 8102)   8103 jr c,8108 
    ex de,hl                   ;8a39 eb  .                         (flow from: 8103)   8105 ex de,hl 
    sbc hl,de                  ;8a3a ed 52  . R                    (flow from: 8105)   8106 sbc hl,de 
l8a3ch:
    exx                        ;8a3c d9  .                         (flow from: 8103 8106)   8108 exx 
    ret                        ;8a3d c9  .                         (flow from: 8108)   8109 ret 
v_sub_810ah:
    inc ix                     ;8a3e dd 23  . # 
v_sub_810ch:
    ld d,(ix+002h)             ;8a40 dd 56 02  . V .               (flow from: 8113)   810c ld d,(ix+02) 
    ld e,(ix+003h)             ;8a43 dd 5e 03  . ^ .               (flow from: 810c)   810f ld e,(ix+03) 
    ret                        ;8a46 c9  .                         (flow from: 810f)   8112 ret 
v_sub_8113h:
    call v_sub_810ch-BA1       ;8a47 cd 4c 23  . L #               (flow from: 8167)   8113 call 810c 
v_sub_8116h:
    ld hl,(02a17h)             ;8a4a 2a 17 2a  * . *               (flow from: 8112 821f)   8116 ld hl,(87d7) 
    push hl                    ;8a4d e5  .                         (flow from: 8116)   8119 push hl 
    res 7,d                    ;8a4e cb ba  . .                    (flow from: 8119)   811a res 7,d 
    add hl,de                  ;8a50 19  .                         (flow from: 811a)   811c add hl,de 
    add hl,de                  ;8a51 19  .                         (flow from: 811c)   811d add hl,de 
    ld e,(hl)                  ;8a52 5e  ^                         (flow from: 811d)   811e ld e,(hl) 
    inc hl                     ;8a53 23  #                         (flow from: 811e)   811f inc hl 
    ld a,(hl)                  ;8a54 7e  ~                         (flow from: 811f)   8120 ld a,(hl) 
    and 03fh                   ;8a55 e6 3f  . ?                    (flow from: 8120)   8121 and 3f 
    ld d,a                     ;8a57 57  W                         (flow from: 8121)   8123 ld d,a 
    ex (sp),hl                 ;8a58 e3  .                         (flow from: 8123)   8124 ex (sp),hl 
    push hl                    ;8a59 e5  .                         (flow from: 8124)   8125 push hl 
    ex de,hl                   ;8a5a eb  .                         (flow from: 8125)   8126 ex de,hl 
    ex (sp),hl                 ;8a5b e3  .                         (flow from: 8126)   8127 ex (sp),hl 
    ld e,(hl)                  ;8a5c 5e  ^                         (flow from: 8127)   8128 ld e,(hl) 
    inc hl                     ;8a5d 23  #                         (flow from: 8128)   8129 inc hl 
    ld d,(hl)                  ;8a5e 56  V                         (flow from: 8129)   812a ld d,(hl) 
    inc hl                     ;8a5f 23  #                         (flow from: 812a)   812b inc hl 
    ex de,hl                   ;8a60 eb  .                         (flow from: 812b)   812c ex de,hl 
    inc hl                     ;8a61 23  #                         (flow from: 812c)   812d inc hl 
    add hl,hl                  ;8a62 29  )                         (flow from: 812d)   812e add hl,hl 
    add hl,de                  ;8a63 19  .                         (flow from: 812e)   812f add hl,de 
    pop de                     ;8a64 d1  .                         (flow from: 812f)   8130 pop de 
    add hl,de                  ;8a65 19  .                         (flow from: 8130)   8131 add hl,de 
    ex de,hl                   ;8a66 eb  .                         (flow from: 8131)   8132 ex de,hl 
    pop hl                     ;8a67 e1  .                         (flow from: 8132)   8133 pop hl 
    ret                        ;8a68 c9  .                         (flow from: 8133)   8134 ret 
v_sub_8135h:
    ld hl,v_l8aa5h-BA1         ;8a69 21 e5 2c  ! . ,               (flow from: 773d 8291)   8135 ld hl,8aa5 
v_sub_8138h:
    push hl                    ;8a6c e5  .                         (flow from: 7d20 8135)   8138 push hl 
    ld bc,02000h               ;8a6d 01 00 20  . .                 (flow from: 8138)   8139 ld bc,2000 
    call v_l82e1h-BA1          ;8a70 cd 21 25  . ! %               (flow from: 8139)   813c call 82e1 
    pop hl                     ;8a73 e1  .                         (flow from: 82e5)   813f pop hl 
    ld a,(ix+000h)             ;8a74 dd 7e 00  . ~ .               (flow from: 813f)   8140 ld a,(ix+00) 
    dec a                      ;8a77 3d  =                         (flow from: 8140)   8143 dec a 
    jr nz,l8a8fh               ;8a78 20 15    .                    (flow from: 8143)   8144 jr nz,815b 
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
    ld b,009h                  ;8a8f 06 09  . .                    (flow from: 8144)   815b ld b,09 
    bit 3,(ix+001h)            ;8a91 dd cb 01 5e  . . . ^          (flow from: 815b)   815d bit 3,(ix+01) 
    call z,v_sub_82d7h-BA1     ;8a95 cc 17 25  . . %               (flow from: 815d)   8161 call z,82d7 
    jr z,l8aa4h                ;8a98 28 0a  ( .                    (flow from: 8161 82e5)   8164 jr z,8170 
    push hl                    ;8a9a e5  .                         (flow from: 8164)   8166 push hl 
    call v_sub_8113h-BA1       ;8a9b cd 53 23  . S #               (flow from: 8166)   8167 call 8113 
    pop hl                     ;8a9e e1  .                         (flow from: 8134)   816a pop hl 
    ld b,009h                  ;8a9f 06 09  . .                    (flow from: 816a)   816b ld b,09 
    call v_sub_82d4h-BA1       ;8aa1 cd 14 25  . . %               (flow from: 816b)   816d call 82d4 
l8aa4h:
    push hl                    ;8aa4 e5  .                         (flow from: 8164 82e5)   8170 push hl 
    ld b,(ix+000h)             ;8aa5 dd 46 00  . F .               (flow from: 8170)   8171 ld b,(ix+00) 
    ld a,(ix+001h)             ;8aa8 dd 7e 01  . ~ .               (flow from: 8171)   8174 ld a,(ix+01) 
    and 0f0h                   ;8aab e6 f0  . .                    (flow from: 8174)   8177 and f0 
    ld c,a                     ;8aad 4f  O                         (flow from: 8177)   8179 ld c,a 
    call v_sub_831ch-BA1       ;8aae cd 5c 25  . \ %               (flow from: 8179)   817a call 831c 
    pop hl                     ;8ab1 e1  .                         (flow from: 8376 838a)   817d pop hl 
    jr z,l8abah                ;8ab2 28 06  ( .                    (flow from: 817d)   817e jr z,8186 
    ld a,010h                  ;8ab4 3e 10  > . 
    ld (01f3fh),a              ;8ab6 32 3f 1f  2 ? . 
    ret                        ;8ab9 c9  . 
l8abah:
    ld (hl),001h               ;8aba 36 01  6 .                    (flow from: 817e)   8186 ld (hl),01 
    or a                       ;8abc b7  .                         (flow from: 8186)   8188 or a 
    ret z                      ;8abd c8  .                         (flow from: 8188)   8189 ret z 
    cp 03ah                    ;8abe fe 3a  . :                    (flow from: 8189)   818a cp 3a 
    jr c,l8ac8h                ;8ac0 38 06  8 .                    (flow from: 818a)   818c jr c,8194 
    cp 03eh                    ;8ac2 fe 3e  . >                    (flow from: 818c)   818e cp 3e 
    jr nc,l8ac8h               ;8ac4 30 02  0 .                    (flow from: 818e)   8190 jr nc,8194 
    ld d,02ch                  ;8ac6 16 2c  . ,                    (flow from: 8190)   8192 ld d,2c 
l8ac8h:
    push de                    ;8ac8 d5  .                         (flow from: 818c 8190 8192)   8194 push de 
    ld de,v_l8c76h-BA1         ;8ac9 11 b6 2e  . . .               (flow from: 8194)   8195 ld de,8c76 
    call v_sub_82c9h-BA1       ;8acc cd 09 25  . . %               (flow from: 8195)   8198 call 82c9 
    ld b,005h                  ;8acf 06 05  . .                    (flow from: 82d3)   819b ld b,05 
    call v_sub_82d4h-BA1       ;8ad1 cd 14 25  . . %               (flow from: 819b)   819d call 82d4 
    pop de                     ;8ad4 d1  .                         (flow from: 82e5)   81a0 pop de 
    ld (hl),001h               ;8ad5 36 01  6 .                    (flow from: 81a0)   81a1 ld (hl),01 
    inc hl                     ;8ad7 23  #                         (flow from: 81a1)   81a3 inc hl 
    bit 3,(ix+001h)            ;8ad8 dd cb 01 5e  . . . ^          (flow from: 81a3)   81a4 bit 3,(ix+01) 
    jr z,l8ae2h                ;8adc 28 04  ( .                    (flow from: 81a4)   81a8 jr z,81ae 
    inc ix                     ;8ade dd 23  . #                    (flow from: 81a8)   81aa inc ix 
    inc ix                     ;8ae0 dd 23  . #                    (flow from: 81aa)   81ac inc ix 
l8ae2h:
    push de                    ;8ae2 d5  .                         (flow from: 81a8 81ac)   81ae push de 
    ld a,d                     ;8ae3 7a  z                         (flow from: 81ae)   81af ld a,d 
    call v_sub_81bah-BA1       ;8ae4 cd fa 23  . . #               (flow from: 81af)   81b0 call 81ba 
    pop de                     ;8ae7 d1  .                         (flow from: 81bb 81dd 822d 8231)   81b3 pop de 
    ld a,e                     ;8ae8 7b  {                         (flow from: 81b3)   81b4 ld a,e 
    or a                       ;8ae9 b7  .                         (flow from: 81b4)   81b5 or a 
    ret z                      ;8aea c8  .                         (flow from: 81b5)   81b6 ret z 
    ld (hl),02ch               ;8aeb 36 2c  6 ,                    (flow from: 81b6)   81b7 ld (hl),2c 
    inc hl                     ;8aed 23  #                         (flow from: 81b7)   81b9 inc hl 
v_sub_81bah:
    or a                       ;8aee b7  .                         (flow from: 81b0 81b9)   81ba or a 
    ret z                      ;8aef c8  .                         (flow from: 81ba)   81bb ret z 
    cp 02ch                    ;8af0 fe 2c  . ,                    (flow from: 81bb)   81bc cp 2c 
    jr nc,l8b12h               ;8af2 30 1e  0 .                    (flow from: 81bc)   81be jr nc,81de 
    ld de,v_l8db4h-BA1         ;8af4 11 f4 2f  . . /               (flow from: 81be)   81c0 ld de,8db4 
    call v_sub_82c9h-BA1       ;8af7 cd 09 25  . . %               (flow from: 81c0)   81c3 call 82c9 
v_sub_81c6h:
    ld b,009h                  ;8afa 06 09  . .                    (flow from: 8223 82d3)   81c6 ld b,09 
l8afch:
v_l81c8h:
    ld a,(de)                  ;8afc 1a  .                         (flow from: 81c6 81db 82d4)   81c8 ld a,(de) 
    and 07fh                   ;8afd e6 7f  .                     (flow from: 81c8)   81c9 and 7f 
    ld (hl),a                  ;8aff 77  w                         (flow from: 81c9)   81cb ld (hl),a 
    dec b                      ;8b00 05  .                         (flow from: 81cb)   81cc dec b 
    jr nz,l8b0ah               ;8b01 20 07    .                    (flow from: 81cc)   81cd jr nz,81d6 
    ld a,010h                  ;8b03 3e 10  > . 
    ld (01f3fh),a              ;8b05 32 3f 1f  2 ? . 
    pop af                     ;8b08 f1  . 
    ret                        ;8b09 c9  . 
l8b0ah:
    ld a,(de)                  ;8b0a 1a  .                         (flow from: 81cd)   81d6 ld a,(de) 
    and 080h                   ;8b0b e6 80  . .                    (flow from: 81d6)   81d7 and 80 
    inc hl                     ;8b0d 23  #                         (flow from: 81d7)   81d9 inc hl 
    inc de                     ;8b0e 13  .                         (flow from: 81d9)   81da inc de 
    jr z,l8afch                ;8b0f 28 eb  ( .                    (flow from: 81da)   81db jr z,81c8 
    ret                        ;8b11 c9  .                         (flow from: 81db)   81dd ret 
l8b12h:
    push af                    ;8b12 f5  .                         (flow from: 81be)   81de push af 
    cp 02dh                    ;8b13 fe 2d  . -                    (flow from: 81de)   81df cp 2d 
    jr c,l8b35h                ;8b15 38 1e  8 .                    (flow from: 81df)   81e1 jr c,8201 
    ld (hl),028h               ;8b17 36 28  6 (                    (flow from: 81e1)   81e3 ld (hl),28 
    inc hl                     ;8b19 23  #                         (flow from: 81e3)   81e5 inc hl 
    cp 02eh                    ;8b1a fe 2e  . .                    (flow from: 81e5)   81e6 cp 2e 
    jr c,l8b35h                ;8b1c 38 17  8 .                    (flow from: 81e6)   81e8 jr c,8201 
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
    ld a,(ix+002h)             ;8b35 dd 7e 02  . ~ .               (flow from: 81e1 81e8 8214 8226)   8201 ld a,(ix+02) 
    cp 01fh                    ;8b38 fe 1f  . .                    (flow from: 8201)   8204 cp 1f 
    jr z,l8b5ch                ;8b3a 28 20  (                      (flow from: 8204)   8206 jr z,8228 
    cp 0c0h                    ;8b3c fe c0  . .                    (flow from: 8206)   8208 cp c0 
    jr nc,l8b5ch               ;8b3e 30 1c  0 .                    (flow from: 8208)   820a jr nc,8228 
    cp 080h                    ;8b40 fe 80  . .                    (flow from: 820a)   820c cp 80 
    jr nc,l8b4ah               ;8b42 30 06  0 .                    (flow from: 820c)   820e jr nc,8216 
    ld (hl),a                  ;8b44 77  w                         (flow from: 820e)   8210 ld (hl),a 
    inc hl                     ;8b45 23  #                         (flow from: 8210)   8211 inc hl 
    inc ix                     ;8b46 dd 23  . #                    (flow from: 8211)   8212 inc ix 
    jr l8b35h                  ;8b48 18 eb  . .                    (flow from: 8212)   8214 jr 8201 
l8b4ah:
    ld d,a                     ;8b4a 57  W                         (flow from: 820e)   8216 ld d,a 
    ld e,(ix+003h)             ;8b4b dd 5e 03  . ^ .               (flow from: 8216)   8217 ld e,(ix+03) 
    inc ix                     ;8b4e dd 23  . #                    (flow from: 8217)   821a inc ix 
    inc ix                     ;8b50 dd 23  . #                    (flow from: 821a)   821c inc ix 
    push hl                    ;8b52 e5  .                         (flow from: 821c)   821e push hl 
    call v_sub_8116h-BA1       ;8b53 cd 56 23  . V #               (flow from: 821e)   821f call 8116 
    pop hl                     ;8b56 e1  .                         (flow from: 8134)   8222 pop hl 
    call v_sub_81c6h-BA1       ;8b57 cd 06 24  . . $               (flow from: 8222)   8223 call 81c6 
    jr l8b35h                  ;8b5a 18 d9  . .                    (flow from: 81dd)   8226 jr 8201 
l8b5ch:
    pop af                     ;8b5c f1  .                         (flow from: 820a)   8228 pop af 
    inc ix                     ;8b5d dd 23  . #                    (flow from: 8228)   8229 inc ix 
    cp 02dh                    ;8b5f fe 2d  . -                    (flow from: 8229)   822b cp 2d 
    ret c                      ;8b61 d8  .                         (flow from: 822b)   822d ret c 
    ld (hl),029h               ;8b62 36 29  6 )                    (flow from: 822d)   822e ld (hl),29 
    inc hl                     ;8b64 23  #                         (flow from: 822e)   8230 inc hl 
    ret                        ;8b65 c9  .                         (flow from: 8230)   8231 ret 
v_sub_8232h:
    ld hl,(v_sub_826ch+1-BA1)                                  ;8b66 2a ad 24  * . $                                                   (flow from: 7c6c 7e23)   8232 ld hl,(826d) 
v_sub_8235h:
    dec hl                     ;8b69 2b  +                         (flow from: 8232 8271)   8235 dec hl 
    ld a,(hl)                  ;8b6a 7e  ~                         (flow from: 8235)   8236 ld a,(hl) 
    cp 0c0h                    ;8b6b fe c0  . .                    (flow from: 8236)   8237 cp c0 
    jr c,l8b77h                ;8b6d 38 08  8 .                    (flow from: 8237)   8239 jr c,8243 
    and 03fh                   ;8b6f e6 3f  . ?                    (flow from: 8239)   823b and 3f 
    ld e,a                     ;8b71 5f  _                         (flow from: 823b)   823d ld e,a 
    ld d,000h                  ;8b72 16 00  . .                    (flow from: 823d)   823e ld d,00 
    sbc hl,de                  ;8b74 ed 52  . R                    (flow from: 823e)   8240 sbc hl,de 
    dec hl                     ;8b76 2b  +                         (flow from: 8240)   8242 dec hl 
l8b77h:
    dec hl                     ;8b77 2b  +                         (flow from: 8239 8242)   8243 dec hl 
    ret                        ;8b78 c9  .                         (flow from: 8243)   8244 ret 
v_sub_8245h:
    ld hl,(v_sub_826ch+1-BA1)                                  ;8b79 2a ad 24  * . $                                                   (flow from: 7c75 7e0a)   8245 ld hl,(826d) 
v_sub_8248h:
    inc hl                     ;8b7c 23  #                         (flow from: 7726 8245 8284 898f)   8248 inc hl 
    ld a,(hl)                  ;8b7d 7e  ~                         (flow from: 8248)   8249 ld a,(hl) 
    inc hl                     ;8b7e 23  #                         (flow from: 8249)   824a inc hl 
    bit 3,a                    ;8b7f cb 5f  . _                    (flow from: 824a)   824b bit 3,a 
    jr z,l8b87h                ;8b81 28 04  ( .                    (flow from: 824b)   824d jr z,8253 
    inc hl                     ;8b83 23  #                         (flow from: 824d)   824f inc hl 
    inc hl                     ;8b84 23  #                         (flow from: 824f)   8250 inc hl 
    jr l8b8ah                  ;8b85 18 03  . .                    (flow from: 8250)   8251 jr 8256 
l8b87h:
    and 007h                   ;8b87 e6 07  . .                    (flow from: 824d)   8253 and 07 
    ret z                      ;8b89 c8  .                         (flow from: 8253)   8255 ret z 
l8b8ah:
    ld a,(hl)                  ;8b8a 7e  ~                         (flow from: 8251 8255 825d 8260)   8256 ld a,(hl) 
    inc hl                     ;8b8b 23  #                         (flow from: 8256)   8257 inc hl 
    cp 0c0h                    ;8b8c fe c0  . .                    (flow from: 8257)   8258 cp c0 
    ret nc                     ;8b8e d0  .                         (flow from: 8258)   825a ret nc 
    cp 080h                    ;8b8f fe 80  . .                    (flow from: 825a)   825b cp 80 
l8b91h:
    jr c,l8b8ah                ;8b91 38 f7  8 .                    (flow from: 825b)   825d jr c,8256 
    inc hl                     ;8b93 23  #                         (flow from: 825d)   825f inc hl 
    jr l8b8ah                  ;8b94 18 f4  . .                    (flow from: 825f)   8260 jr 8256 
v_sub_8262h:
    xor a                      ;8b96 af  .                         (flow from: 7760)   8262 xor a 
    in a,(0feh)                ;8b97 db fe  . .                    (flow from: 8262)   8263 in a,(fe) 
    cpl                        ;8b99 2f  /                         (flow from: 8263)   8265 cpl 
    and 01fh                   ;8b9a e6 1f  . .                    (flow from: 8265)   8266 and 1f 
    ret z                      ;8b9c c8  .                         (flow from: 8266)   8268 ret z 
    call v_sub_7bbch-BA1       ;8b9d cd fc 1d  . . . 
v_sub_826ch:
    ld hl,03e68h               ;8ba0 21 68 3e  ! h >               (flow from: 7cf1)   826c ld hl,b24c 
    ld b,00dh                  ;8ba3 06 0d  . .                    (flow from: 826c)   826f ld b,0d 
l8ba5h:
    call v_sub_8235h-BA1       ;8ba5 cd 75 24  . u $               (flow from: 826f 8274)   8271 call 8235 
    djnz l8ba5h                ;8ba8 10 fb  . .                    (flow from: 8244)   8274 djnz 8271 
    ld a,010h                  ;8baa 3e 10  > .                    (flow from: 8274)   8276 ld a,10 
l8bach:
    push af                    ;8bac f5  .                         (flow from: 8276 828c)   8278 push af 
    push hl                    ;8bad e5  .                         (flow from: 8278)   8279 push hl 
    push hl                    ;8bae e5  .                         (flow from: 8279)   827a push hl 
    call v_sub_85f0h-BA1       ;8baf cd 30 28  . 0 (               (flow from: 827a)   827b call 85f0 
    pop ix                     ;8bb2 dd e1  . .                    (flow from: 8607)   827e pop ix 
    call v_sub_828fh-BA1       ;8bb4 cd cf 24  . . $               (flow from: 827e)   8280 call 828f 
    pop hl                     ;8bb7 e1  .                         (flow from: 82b1)   8283 pop hl 
    call v_sub_8248h-BA1       ;8bb8 cd 88 24  . . $               (flow from: 8283)   8284 call 8248 
    pop af                     ;8bbb f1  .                         (flow from: 8255 825a)   8287 pop af 
    add a,008h                 ;8bbc c6 08  . .                    (flow from: 8287)   8288 add a,08 
    cp 0a9h                    ;8bbe fe a9  . .                    (flow from: 8288)   828a cp a9 
    jr c,l8bach                ;8bc0 38 ea  8 .                    (flow from: 828a)   828c jr c,8278 
    ret                        ;8bc2 c9  .                         (flow from: 828c)   828e ret 
v_sub_828fh:
    push ix                    ;8bc3 dd e5  . .                    (flow from: 8280)   828f push ix 
    call v_sub_8135h-BA1       ;8bc5 cd 75 23  . u #               (flow from: 828f)   8291 call 8135 
    pop ix                     ;8bc8 dd e1  . .                    (flow from: 8189 81b6)   8294 pop ix 
    call v_sub_80f5h-BA1       ;8bca cd 35 23  . 5 #               (flow from: 8294)   8296 call 80f5 
    jr c,l8bd4h                ;8bcd 38 05  8 .                    (flow from: 8109)   8299 jr c,82a0 
    ld hl,v_l8aadh-BA1         ;8bcf 21 ed 2c  ! . ,               (flow from: 8299)   829b ld hl,8aad 
    ld (hl),003h               ;8bd2 36 03  6 .                    (flow from: 829b)   829e ld (hl),03 
l8bd4h:
    ld hl,v_sub_8744h-BA1      ;8bd4 21 84 29  ! . )               (flow from: 8299 829e)   82a0 ld hl,8744 
v_sub_82a3h:
    ld (02505h),hl             ;8bd7 22 05 25  " . %               (flow from: 82a0)   82a3 ld (82c5),hl 
    ld hl,v_l8aa5h-BA1         ;8bda 21 e5 2c  ! . ,               (flow from: 82a3)   82a6 ld hl,8aa5 
    ld c,000h                  ;8bdd 0e 00  . .                    (flow from: 82a6)   82a9 ld c,00 
l8bdfh:
    ld a,(hl)                  ;8bdf 7e  ~                         (flow from: 82a9 82ae 82c7)   82ab ld a,(hl) 
    inc hl                     ;8be0 23  #                         (flow from: 82ab)   82ac inc hl 
    dec a                      ;8be1 3d  =                         (flow from: 82ac)   82ad dec a 
    jr z,l8bdfh                ;8be2 28 fb  ( .                    (flow from: 82ad)   82ae jr z,82ab 
    inc a                      ;8be4 3c  <                         (flow from: 82ae)   82b0 inc a 
    ret z                      ;8be5 c8  .                         (flow from: 82b0)   82b1 ret z 
    cp 022h                    ;8be6 fe 22  . "                    (flow from: 82b1)   82b2 cp 22 
    jr nz,l8bedh               ;8be8 20 03    .                    (flow from: 82b2)   82b4 jr nz,82b9 
    inc c                      ;8bea 0c  . 
    ld a,022h                  ;8beb 3e 22  > " 
l8bedh:
    bit 0,c                    ;8bed cb 41  . A                    (flow from: 82b4)   82b9 bit 0,c 
    jr nz,l8bf8h               ;8bef 20 07    .                    (flow from: 82b9)   82bb jr nz,82c4 
    call v_sub_872eh-BA1       ;8bf1 cd 6e 29  . n )               (flow from: 82bb)   82bd call 872e 
    jr nz,l8bf8h               ;8bf4 20 02    .                    (flow from: 8730 873c)   82c0 jr nz,82c4 
    and 0ffh                   ;8bf6 e6 ff  . .                    (flow from: 82c0)   82c2 and ff 
l8bf8h:
    call v_sub_8744h-BA1       ;8bf8 cd 84 29  . . )               (flow from: 82c0 82c2)   82c4 call 8744 
    jr l8bdfh                  ;8bfb 18 e2  . .                    (flow from: 8749)   82c7 jr 82ab 
v_sub_82c9h:
    push hl                    ;8bfd e5  .                         (flow from: 8198 81c3)   82c9 push hl 
    ex de,hl                   ;8bfe eb  .                         (flow from: 82c9)   82ca ex de,hl 
    ld d,000h                  ;8bff 16 00  . .                    (flow from: 82ca)   82cb ld d,00 
    ld e,a                     ;8c01 5f  _                         (flow from: 82cb)   82cd ld e,a 
    add hl,de                  ;8c02 19  .                         (flow from: 82cd)   82ce add hl,de 
    ld e,(hl)                  ;8c03 5e  ^                         (flow from: 82ce)   82cf ld e,(hl) 
    add hl,de                  ;8c04 19  .                         (flow from: 82cf)   82d0 add hl,de 
    ex de,hl                   ;8c05 eb  .                         (flow from: 82d0)   82d1 ex de,hl 
    pop hl                     ;8c06 e1  .                         (flow from: 82d1)   82d2 pop hl 
    ret                        ;8c07 c9  .                         (flow from: 82d2)   82d3 ret 
v_sub_82d4h:
    call v_l81c8h-BA1          ;8c08 cd 08 24  . . $               (flow from: 816d 819d)   82d4 call 81c8 
v_sub_82d7h:
    ld c,020h                  ;8c0b 0e 20  .                      (flow from: 8161 81dd)   82d7 ld c,20 
    jr l8c15h                  ;8c0d 18 06  . .                    (flow from: 82d7)   82d9 jr 82e1 
v_l82dbh:
    ld bc,03700h               ;8c0f 01 00 37  . . 7               (flow from: 775a)   82db ld bc,3700 
    ld hl,v_l8ac7h-BA1         ;8c12 21 07 2d  ! . -               (flow from: 82db)   82de ld hl,8ac7 
l8c15h:
v_l82e1h:
    ld (hl),c                  ;8c15 71  q                         (flow from: 1 7cd5 7ce3 7d1c 7de3 813c 82d9 82de 82e3)   82e1 ld (hl),c 
    inc hl                     ;8c16 23  #                         (flow from: 82e1)   82e2 inc hl 
    djnz l8c15h                ;8c17 10 fc  . .                    (flow from: 82e2)   82e3 djnz 82e1 
    ret                        ;8c19 c9  .                         (flow from: 82e3)   82e5 ret 
v_sub_82e6h:
    ld b,000h                  ;8c1a 06 00  . .                    (flow from: 7fc9 8007)   82e6 ld b,00 
    ld hl,v_l8affh-BA1         ;8c1c 21 3f 2d  ! ? -               (flow from: 82e6)   82e8 ld hl,8aff 
    call v_sub_85aeh-BA1       ;8c1f cd ee 27  . . '               (flow from: 82e8)   82eb call 85ae 
    cp 041h                    ;8c22 fe 41  . A                    (flow from: 85b1)   82ee cp 41 
    jr c,l8c28h                ;8c24 38 02  8 .                    (flow from: 82ee)   82f0 jr c,82f4 
    set 3,d                    ;8c26 cb da  . .                    (flow from: 82f0)   82f2 set 3,d 
l8c28h:
    ld (v_l8b22h-BA1),de       ;8c28 ed 53 62 2d  . S b -          (flow from: 82f0 82f2)   82f4 ld (8b22),de 
    push af                    ;8c2c f5  .                         (flow from: 82f4)   82f8 push af 
    ld a,e                     ;8c2d 7b  {                         (flow from: 82f8)   82f9 ld a,e 
    cp 003h                    ;8c2e fe 03  . .                    (flow from: 82f9)   82fa cp 03 
    jr nz,l8c38h               ;8c30 20 06    .                    (flow from: 82fa)   82fc jr nz,8304 
    ld a,d                     ;8c32 7a  z 
    cp 037h                    ;8c33 fe 37  . 7 
    jp z,v_l8098h-BA1          ;8c35 ca d8 22  . . " 
l8c38h:
    pop af                     ;8c38 f1  .                         (flow from: 82fc)   8304 pop af 
    ld ix,v_l8b24h-BA1         ;8c39 dd 21 64 2d  . ! d -          (flow from: 8304)   8305 ld ix,8b24 
    ret c                      ;8c3d d8  .                         (flow from: 8305)   8309 ret c 
    call v_sub_8815h-BA1       ;8c3e cd 55 2a  . U *               (flow from: 8309)   830a call 8815 
    ld ix,v_l8b26h-BA1         ;8c41 dd 21 66 2d  . ! f -          (flow from: 8818 88e0)   830d ld ix,8b26 
    set 7,h                    ;8c45 cb fc  . .                    (flow from: 830d)   8311 set 7,h 
    ld (ix-002h),h             ;8c47 dd 74 fe  . t .               (flow from: 8311)   8313 ld (ix-02),h 
    ld (ix-001h),l             ;8c4a dd 75 ff  . u .               (flow from: 8313)   8316 ld (ix-01),l 
    ld b,002h                  ;8c4d 06 02  . .                    (flow from: 8316)   8319 ld b,02 
    ret                        ;8c4f c9  .                         (flow from: 8319)   831b ret 
v_sub_831ch:
    ld de,00352h               ;8c50 11 52 03  . R .               (flow from: 817a)   831c ld de,0352 
    ld a,001h                  ;8c53 3e 01  > .                    (flow from: 831c)   831f ld a,01 
    bit 5,c                    ;8c55 cb 69  . i                    (flow from: 831f)   8321 bit 5,c 
    jr nz,l8c62h               ;8c57 20 09    .                    (flow from: 8321)   8323 jr nz,832e 
    bit 4,c                    ;8c59 cb 61  . a                    (flow from: 8323)   8325 bit 4,c 
    jr z,l8c62h                ;8c5b 28 05  ( .                    (flow from: 8325)   8327 jr z,832e 
    dec a                      ;8c5d 3d  =                         (flow from: 8327)   8329 dec a 
    res 4,c                    ;8c5e cb a1  . .                    (flow from: 8329)   832a res 4,c 
    set 5,c                    ;8c60 cb e9  . .                    (flow from: 832a)   832c set 5,c 
l8c62h:
    ld (025b4h),a              ;8c62 32 b4 25  2 . %               (flow from: 8323 8327 832c)   832e ld (8374),a 
    ld hl,v_l9556h-BA1         ;8c65 21 96 37  ! . 7               (flow from: 832e)   8331 ld hl,9556 
    exx                        ;8c68 d9  .                         (flow from: 8331)   8334 exx 
    ld b,00bh                  ;8c69 06 0b  . .                    (flow from: 8334)   8335 ld b,0b 
l8c6bh:
    exx                        ;8c6b d9  .                         (flow from: 8335 8355)   8337 exx 
    ld a,(hl)                  ;8c6c 7e  ~                         (flow from: 8337)   8338 ld a,(hl) 
    cp b                       ;8c6d b8  .                         (flow from: 8338)   8339 cp b 
    jr nz,l8c78h               ;8c6e 20 08    .                    (flow from: 8339)   833a jr nz,8344 
    inc hl                     ;8c70 23  #                         (flow from: 833a)   833c inc hl 
    ld a,(hl)                  ;8c71 7e  ~                         (flow from: 833c)   833d ld a,(hl) 
    dec hl                     ;8c72 2b  +                         (flow from: 833d)   833e dec hl 
    and 0f0h                   ;8c73 e6 f0  . .                    (flow from: 833e)   833f and f0 
    cp c                       ;8c75 b9  .                         (flow from: 833f)   8341 cp c 
    jr z,l8c8eh                ;8c76 28 16  ( .                    (flow from: 8341)   8342 jr z,835a 
l8c78h:
    jr c,l8c7eh                ;8c78 38 04  8 .                    (flow from: 833a 8342)   8344 jr c,834a 
    sbc hl,de                  ;8c7a ed 52  . R                    (flow from: 8344)   8346 sbc hl,de 
    jr l8c7fh                  ;8c7c 18 01  . .                    (flow from: 8346)   8348 jr 834b 
l8c7eh:
    add hl,de                  ;8c7e 19  .                         (flow from: 8344)   834a add hl,de 
l8c7fh:
    srl d                      ;8c7f cb 3a  . :                    (flow from: 8348 834a)   834b srl d 
    rr e                       ;8c81 cb 1b  . .                    (flow from: 834b)   834d rr e 
    jr nc,l8c88h               ;8c83 30 03  0 .                    (flow from: 834d)   834f jr nc,8354 
    inc de                     ;8c85 13  .                         (flow from: 834f)   8351 inc de 
    inc de                     ;8c86 13  .                         (flow from: 8351)   8352 inc de 
    inc de                     ;8c87 13  .                         (flow from: 8352)   8353 inc de 
l8c88h:
    exx                        ;8c88 d9  .                         (flow from: 834f 8353)   8354 exx 
    djnz l8c6bh                ;8c89 10 e0  . .                    (flow from: 8354)   8355 djnz 8337 
    inc b                      ;8c8b 04  . 
    exx                        ;8c8c d9  . 
    ret                        ;8c8d c9  . 
l8c8eh:
    inc hl                     ;8c8e 23  #                         (flow from: 8342 8601)   835a inc hl 
    inc hl                     ;8c8f 23  #                         (flow from: 835a)   835b inc hl 
    ld a,(hl)                  ;8c90 7e  ~                         (flow from: 835b)   835c ld a,(hl) 
    inc hl                     ;8c91 23  #                         (flow from: 835c)   835d inc hl 
    ld d,(hl)                  ;8c92 56  V                         (flow from: 835d)   835e ld d,(hl) 
    inc hl                     ;8c93 23  #                         (flow from: 835e)   835f inc hl 
    ld e,(hl)                  ;8c94 5e  ^                         (flow from: 835f)   8360 ld e,(hl) 
    srl a                      ;8c95 cb 3f  . ?                    (flow from: 8360)   8361 srl a 
    ld b,003h                  ;8c97 06 03  . .                    (flow from: 8361)   8363 ld b,03 
    rr d                       ;8c99 cb 1a  . .                    (flow from: 8363)   8365 rr d 
    jr l8c9fh                  ;8c9b 18 02  . .                    (flow from: 8365)   8367 jr 836b 
l8c9dh:
    srl d                      ;8c9d cb 3a  . :                    (flow from: 836d)   8369 srl d 
l8c9fh:
    rr e                       ;8c9f cb 1b  . .                    (flow from: 8367 8369)   836b rr e 
    djnz l8c9dh                ;8ca1 10 fa  . .                    (flow from: 836b)   836d djnz 8369 
    srl e                      ;8ca3 cb 3b  .                  ;   (flow from: 836d)   836f srl e 
    srl e                      ;8ca5 cb 3b  .                  ;   (flow from: 836f)   8371 srl e 
    ld b,001h                  ;8ca7 06 01  . .                    (flow from: 8371)   8373 ld b,01 
    dec b                      ;8ca9 05  .                         (flow from: 8373)   8375 dec b 
    ret z                      ;8caa c8  .                         (flow from: 8375)   8376 ret z 
    push af                    ;8cab f5  .                         (flow from: 8376)   8377 push af 
    ld a,e                     ;8cac 7b  {                         (flow from: 8377)   8378 ld a,e 
    inc a                      ;8cad 3c  <                         (flow from: 8378)   8379 inc a 
    call v_sub_84c3h-BA1       ;8cae cd 03 27  . . '               (flow from: 8379)   837a call 84c3 
    jr nz,l8cb4h               ;8cb1 20 01    .                    (flow from: 84d5)   837d jr nz,8380 
    inc e                      ;8cb3 1c  . 
l8cb4h:
    ld a,d                     ;8cb4 7a  z                         (flow from: 837d)   8380 ld a,d 
    inc a                      ;8cb5 3c  <                         (flow from: 8380)   8381 inc a 
    call v_sub_84c3h-BA1       ;8cb6 cd 03 27  . . '               (flow from: 8381)   8382 call 84c3 
    jr nz,l8cbch               ;8cb9 20 01    .                    (flow from: 84df)   8385 jr nz,8388 
    inc d                      ;8cbb 14  .                         (flow from: 8385)   8387 inc d 
l8cbch:
    pop af                     ;8cbc f1  .                         (flow from: 8387)   8388 pop af 
    cp a                       ;8cbd bf  .                         (flow from: 8388)   8389 cp a 
    ret                        ;8cbe c9  .                         (flow from: 8389)   838a ret 
v_sub_838bh:
    ld hl,v_l8ad1h-BA1         ;8cbf 21 11 2d  ! . -               (flow from: 7f14)   838b ld hl,8ad1 
    ld b,028h                  ;8cc2 06 28  . (                    (flow from: 838b)   838e ld b,28 
    ld c,001h                  ;8cc4 0e 01  . .                    (flow from: 838e)   8390 ld c,01 
    xor a                      ;8cc6 af  .                         (flow from: 8390)   8392 xor a 
l8cc7h:
    cp (hl)                    ;8cc7 be  .                         (flow from: 8392 8398)   8393 cp (hl) 
    inc hl                     ;8cc8 23  #                         (flow from: 8393)   8394 inc hl 
    jr z,l8ccch                ;8cc9 28 01  ( .                    (flow from: 8394)   8395 jr z,8398 
    inc c                      ;8ccb 0c  .                         (flow from: 8395)   8397 inc c 
l8ccch:
    djnz l8cc7h                ;8ccc 10 f9  . .                    (flow from: 8395 8397)   8398 djnz 8393 
    ld a,012h                  ;8cce 3e 12  > .                    (flow from: 8398)   839a ld a,12 
    cp c                       ;8cd0 b9  .                         (flow from: 839a)   839c cp c 
    jr c,l8ce2h                ;8cd1 38 0f  8 .                    (flow from: 839c)   839d jr c,83ae 
    ret                        ;8cd3 c9  .                         (flow from: 839d)   839f ret 
v_sub_83a0h:
    cp 02ch                    ;8cd4 fe 2c  . ,                    (flow from: 7fd4 7fec 803a)   83a0 cp 2c 
    jr z,l8cdfh                ;8cd6 28 07  ( .                    (flow from: 83a0)   83a2 jr z,83ab 
    inc de                     ;8cd8 13  .                         (flow from: 83a2)   83a4 inc de 
    cp 02dh                    ;8cd9 fe 2d  . -                    (flow from: 83a4)   83a5 cp 2d 
    jr z,l8cdfh                ;8cdb 28 02  ( .                    (flow from: 83a5)   83a7 jr z,83ab 
    inc de                     ;8cdd 13  . 
    inc de                     ;8cde 13  . 
l8cdfh:
    call v_sub_8492h-BA1       ;8cdf cd d2 26  . . &               (flow from: 83a2 83a7)   83ab call 8492 
l8ce2h:
    jp c,v_l8089h-BA1          ;8ce2 da c9 22  . . "               (flow from: 8417 849d)   83ae jp c,8089 
    cp 02bh                    ;8ce5 fe 2b  . +                    (flow from: 83ae)   83b1 cp 2b 
    jr z,l8cf0h                ;8ce7 28 07  ( .                    (flow from: 83b1)   83b3 jr z,83bc 
    cp 02dh                    ;8ce9 fe 2d  . -                    (flow from: 83b3)   83b5 cp 2d 
    jr nz,l8cf5h               ;8ceb 20 08    .                    (flow from: 83b5)   83b7 jr nz,83c1 
    call v_sub_8962h-BA1       ;8ced cd a2 2b  . . + 
l8cf0h:
    call v_sub_8492h-BA1       ;8cf0 cd d2 26  . . & 
    jr c,l8ce2h                ;8cf3 38 ed  8 . 
l8cf5h:
    cp 024h                    ;8cf5 fe 24  . $                    (flow from: 83b7)   83c1 cp 24 
    jr nz,l8cfeh               ;8cf7 20 05    .                    (flow from: 83c1)   83c3 jr nz,83ca 
    call v_sub_848fh-BA1       ;8cf9 cd cf 26  . . &               (flow from: 83c3)   83c5 call 848f 
    jr l8d31h                  ;8cfc 18 33  . 3                    (flow from: 849f)   83c8 jr 83fd 
l8cfeh:
    ld c,a                     ;8cfe 4f  O                         (flow from: 83c3)   83ca ld c,a 
    or 020h                    ;8cff f6 20  .                      (flow from: 83ca)   83cb or 20 
    call v_sub_872eh-BA1       ;8d01 cd 6e 29  . n )               (flow from: 83cb)   83cd call 872e 
    jr nz,l8d2dh               ;8d04 20 27    '                    (flow from: 8730 873c)   83d0 jr nz,83f9 
    push bc                    ;8d06 c5  .                         (flow from: 83d0)   83d2 push bc 
    dec de                     ;8d07 1b  .                         (flow from: 83d2)   83d3 dec de 
    push de                    ;8d08 d5  .                         (flow from: 83d3)   83d4 push de 
    push ix                    ;8d09 dd e5  . .                    (flow from: 83d4)   83d5 push ix 
    ex de,hl                   ;8d0b eb  .                         (flow from: 83d5)   83d7 ex de,hl 
    call v_sub_8815h-BA1       ;8d0c cd 55 2a  . U *               (flow from: 83d7)   83d8 call 8815 
    pop ix                     ;8d0f dd e1  . .                    (flow from: 8818 88e0)   83db pop ix 
    set 7,h                    ;8d11 cb fc  . .                    (flow from: 83db)   83dd set 7,h 
    ld (ix+000h),h             ;8d13 dd 74 00  . t .               (flow from: 83dd)   83df ld (ix+00),h 
    inc ix                     ;8d16 dd 23  . #                    (flow from: 83df)   83e2 inc ix 
    ld (ix+000h),l             ;8d18 dd 75 00  . u .               (flow from: 83e2)   83e4 ld (ix+00),l 
    inc ix                     ;8d1b dd 23  . #                    (flow from: 83e4)   83e7 inc ix 
    pop bc                     ;8d1d c1  .                         (flow from: 83e7)   83e9 pop bc 
    ld hl,(v_l8ac7h-BA1)       ;8d1e 2a 07 2d  * . -               (flow from: 83e9)   83ea ld hl,(8ac7) 
    ld h,000h                  ;8d21 26 00  & .                    (flow from: 83ea)   83ed ld h,00 
    add hl,bc                  ;8d23 09  .                         (flow from: 83ed)   83ef add hl,bc 
    ex de,hl                   ;8d24 eb  .                         (flow from: 83ef)   83f0 ex de,hl 
    pop bc                     ;8d25 c1  .                         (flow from: 83f0)   83f1 pop bc 
    inc b                      ;8d26 04  .                         (flow from: 83f1)   83f2 inc b 
    inc b                      ;8d27 04  .                         (flow from: 83f2)   83f3 inc b 
    call v_sub_8492h-BA1       ;8d28 cd d2 26  . . &               (flow from: 83f3)   83f4 call 8492 
    jr l8d31h                  ;8d2b 18 04  . .                    (flow from: 849d 849f)   83f7 jr 83fd 
l8d2dh:
    ld a,c                     ;8d2d 79  y                         (flow from: 83d0)   83f9 ld a,c 
    call v_sub_8419h-BA1       ;8d2e cd 59 26  . Y &               (flow from: 83f9)   83fa call 8419 
l8d31h:
    ccf                        ;8d31 3f  ?                         (flow from: 83c8 83f7 845c)   83fd ccf 
    ret nc                     ;8d32 d0  .                         (flow from: 83fd)   83fe ret nc 
    cp 02bh                    ;8d33 fe 2b  . +                    (flow from: 83fe)   83ff cp 2b 
    jr z,l8d48h                ;8d35 28 11  ( .                    (flow from: 83ff)   8401 jr z,8414 
    cp 02dh                    ;8d37 fe 2d  . - 
    jr z,l8d48h                ;8d39 28 0d  ( . 
    cp 02ah                    ;8d3b fe 2a  . * 
    jr z,l8d48h                ;8d3d 28 09  ( . 
    cp 02fh                    ;8d3f fe 2f  . / 
    jr z,l8d48h                ;8d41 28 05  ( . 
    cp 03fh                    ;8d43 fe 3f  . ? 
l8d45h:
    jp nz,v_l8089h-BA1         ;8d45 c2 c9 22  . . " 
l8d48h:
    call v_sub_848fh-BA1       ;8d48 cd cf 26  . . &               (flow from: 8401)   8414 call 848f 
    jr l8ce2h                  ;8d4b 18 95  . .                    (flow from: 849d)   8417 jr 83ae 
v_sub_8419h:
    cp 022h                    ;8d4d fe 22  . "                    (flow from: 83fa)   8419 cp 22 
    jr z,l8d93h                ;8d4f 28 42  ( B                    (flow from: 8419)   841b jr z,845f 
    ld c,00ah                  ;8d51 0e 0a  . .                    (flow from: 841b)   841d ld c,0a 
    call v_sub_8726h-BA1       ;8d53 cd 66 29  . f )               (flow from: 841d)   841f call 8726 
    jr z,l8d6ch                ;8d56 28 14  ( .                    (flow from: 872b 872d)   8422 jr z,8438 
    cp 025h                    ;8d58 fe 25  . % 
    jr nz,l8d60h               ;8d5a 20 04    . 
    ld c,002h                  ;8d5c 0e 02  . . 
    jr l8d66h                  ;8d5e 18 06  . . 
l8d60h:
    cp 023h                    ;8d60 fe 23  . # 
    jr nz,l8d45h               ;8d62 20 e1    . 
    ld c,010h                  ;8d64 0e 10  . . 
l8d66h:
    call v_sub_848fh-BA1       ;8d66 cd cf 26  . . & 
    jp c,v_l8089h-BA1          ;8d69 da c9 22  . . " 
l8d6ch:
    ld hl,00000h               ;8d6c 21 00 00  ! . .               (flow from: 8422)   8438 ld hl,0000 
l8d6fh:
    call v_sub_84a0h-BA1       ;8d6f cd e0 26  . . &               (flow from: 8438 845d)   843b call 84a0 
    ret nc                     ;8d72 d0  .                         (flow from: 84a7)   843e ret nc 
    push de                    ;8d73 d5  .                         (flow from: 843e)   843f push de 
    push af                    ;8d74 f5  .                         (flow from: 843f)   8440 push af 
    ld a,c                     ;8d75 79  y                         (flow from: 8440)   8441 ld a,c 
    dec a                      ;8d76 3d  =                         (flow from: 8441)   8442 dec a 
    ld d,h                     ;8d77 54  T                         (flow from: 8442)   8443 ld d,h 
    ld e,l                     ;8d78 5d  ]                         (flow from: 8443)   8444 ld e,l 
l8d79h:
    add hl,de                  ;8d79 19  .                         (flow from: 8444 844a)   8445 add hl,de 
l8d7ah:
    jp c,v_l8085h-BA1          ;8d7a da c5 22  . . "               (flow from: 8445)   8446 jp c,8085 
    dec a                      ;8d7d 3d  =                         (flow from: 8446)   8449 dec a 
    jr nz,l8d79h               ;8d7e 20 f9    .                    (flow from: 8449)   844a jr nz,8445 
    pop af                     ;8d80 f1  .                         (flow from: 844a)   844c pop af 
    cp c                       ;8d81 b9  .                         (flow from: 844c)   844d cp c 
    jp nc,v_l8085h-BA1         ;8d82 d2 c5 22  . . "               (flow from: 844d)   844e jp nc,8085 
    ld d,000h                  ;8d85 16 00  . .                    (flow from: 844e)   8451 ld d,00 
    ld e,a                     ;8d87 5f  _                         (flow from: 8451)   8453 ld e,a 
    add hl,de                  ;8d88 19  .                         (flow from: 8453)   8454 add hl,de 
    jr c,l8d7ah                ;8d89 38 ef  8 .                    (flow from: 8454)   8455 jr c,8446 
    pop de                     ;8d8b d1  .                         (flow from: 8455)   8457 pop de 
    ex af,af'                  ;8d8c 08  .                         (flow from: 8457)   8458 ex af,af' 
    call v_sub_848fh-BA1       ;8d8d cd cf 26  . . &               (flow from: 8458)   8459 call 848f 
    ret c                      ;8d90 d8  .                         (flow from: 849d 849f)   845c ret c 
    jr l8d6fh                  ;8d91 18 dc  . .                    (flow from: 845c)   845d jr 843b 
l8d93h:
    ld hl,00000h               ;8d93 21 00 00  ! . . 
    call v_sub_847ah-BA1       ;8d96 cd ba 26  . . & 
    or a                       ;8d99 b7  . 
    jr z,l8dach                ;8d9a 28 10  ( . 
    ld l,a                     ;8d9c 6f  o 
    call v_sub_847ah-BA1       ;8d9d cd ba 26  . . & 
    or a                       ;8da0 b7  . 
    jr z,l8dach                ;8da1 28 09  ( . 
    ld h,l                     ;8da3 65  e 
    ld l,a                     ;8da4 6f  o 
    call v_sub_847ah-BA1       ;8da5 cd ba 26  . . & 
    or a                       ;8da8 b7  . 
    jp nz,v_l8094h-BA1         ;8da9 c2 d4 22  . . " 
l8dach:
    jr l8dc1h                  ;8dac 18 13  . . 
v_sub_847ah:
    call v_sub_848fh-BA1       ;8dae cd cf 26  . . & 
    or a                       ;8db1 b7  . 
    jp z,v_l8094h-BA1          ;8db2 ca d4 22  . . " 
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
    call v_sub_8962h-BA1       ;8dc3 cd a2 2b  . . +               (flow from: 83c5 8414 8459)   848f call 8962 
v_sub_8492h:
    ld a,(de)                  ;8dc6 1a  .                         (flow from: 83ab 83f4 8968)   8492 ld a,(de) 
    inc de                     ;8dc7 13  .                         (flow from: 8492)   8493 inc de 
    cp 029h                    ;8dc8 fe 29  . )                    (flow from: 8493)   8494 cp 29 
    jr z,l8dd2h                ;8dca 28 06  ( .                    (flow from: 8494)   8496 jr z,849e 
    cp 02ch                    ;8dcc fe 2c  . ,                    (flow from: 8496)   8498 cp 2c 
    jr z,l8dd2h                ;8dce 28 02  ( .                    (flow from: 8498)   849a jr z,849e 
    or a                       ;8dd0 b7  .                         (flow from: 849a)   849c or a 
    ret nz                     ;8dd1 c0  .                         (flow from: 849c)   849d ret nz 
l8dd2h:
    scf                        ;8dd2 37  7                         (flow from: 8496 849a 849d)   849e scf 
    ret                        ;8dd3 c9  .                         (flow from: 849e)   849f ret 
v_sub_84a0h:
    push af                    ;8dd4 f5  .                         (flow from: 843b)   84a0 push af 
    ex af,af'                  ;8dd5 08  .                         (flow from: 84a0)   84a1 ex af,af' 
    pop af                     ;8dd6 f1  .                         (flow from: 84a1)   84a2 pop af 
    sub 030h                   ;8dd7 d6 30  . 0                    (flow from: 84a2)   84a3 sub 30 
    cp 00ah                    ;8dd9 fe 0a  . .                    (flow from: 84a3)   84a5 cp 0a 
    ret c                      ;8ddb d8  .                         (flow from: 84a5)   84a7 ret c 
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
    cp 01ah                    ;8df7 fe 1a  . .                    (flow from: 7f84 7f8c 837a 8382)   84c3 cp 1a 
    jr z,l8e0ah                ;8df9 28 0f  ( .                    (flow from: 84c3)   84c5 jr z,84d6 
    cp 01ch                    ;8dfb fe 1c  . .                    (flow from: 84c5)   84c7 cp 1c 
    jr z,l8e0ah                ;8dfd 28 0b  ( .                    (flow from: 84c7)   84c9 jr z,84d6 
    cp 01eh                    ;8dff fe 1e  . .                    (flow from: 84c9)   84cb cp 1e 
    jr z,l8e0ah                ;8e01 28 07  ( .                    (flow from: 84cb)   84cd jr z,84d6 
    cp 02ah                    ;8e03 fe 2a  . *                    (flow from: 84cd)   84cf cp 2a 
    jr z,l8e0ah                ;8e05 28 03  ( .                    (flow from: 84cf)   84d1 jr z,84d6 
    cp 02fh                    ;8e07 fe 2f  . /                    (flow from: 84d1)   84d3 cp 2f 
    ret nz                     ;8e09 c0  .                         (flow from: 84d3)   84d5 ret nz 
l8e0ah:
    dec a                      ;8e0a 3d  =                         (flow from: 84c9)   84d6 dec a 
    push hl                    ;8e0b e5  .                         (flow from: 84d6)   84d7 push hl 
    ld hl,02201h               ;8e0c 21 01 22  ! . "               (flow from: 84d7)   84d8 ld hl,7fc1 
    ld (hl),001h               ;8e0f 36 01  6 .                    (flow from: 84d8)   84db ld (hl),01 
    pop hl                     ;8e11 e1  .                         (flow from: 84db)   84dd pop hl 
    cp a                       ;8e12 bf  .                         (flow from: 84dd)   84de cp a 
    ret                        ;8e13 c9  .                         (flow from: 84de)   84df ret 
v_sub_84e0h:
    push hl                    ;8e14 e5  .                         (flow from: 7f6f 7f78)   84e0 push hl 
    call v_sub_851fh-BA1       ;8e15 cd 5f 27  . _ '               (flow from: 84e0)   84e1 call 851f 
    pop hl                     ;8e18 e1  .                         (flow from: 8522)   84e4 pop hl 
    ld a,b                     ;8e19 78  x                         (flow from: 84e4)   84e5 ld a,b 
    or a                       ;8e1a b7  .                         (flow from: 84e5)   84e6 or a 
    ret z                      ;8e1b c8  .                         (flow from: 84e6)   84e7 ret z 
    cp 005h                    ;8e1c fe 05  . .                    (flow from: 84e7)   84e8 cp 05 
    jr nc,l8e2ch               ;8e1e 30 0c  0 .                    (flow from: 84e8)   84ea jr nc,84f8 
    push hl                    ;8e20 e5  .                         (flow from: 84ea)   84ec push hl 
    ld hl,v_l854fh-BA1         ;8e21 21 8f 27  ! . '               (flow from: 84ec)   84ed ld hl,854f 
    call v_sub_8559h-BA1       ;8e24 cd 99 27  . . '               (flow from: 84ed)   84f0 call 8559 
    pop hl                     ;8e27 e1  .                         (flow from: 856e)   84f3 pop hl 
    call v_sub_8527h-BA1       ;8e28 cd 67 27  . g '               (flow from: 84f3)   84f4 call 8527 
    ret nc                     ;8e2b d0  .                         (flow from: 8538 8544)   84f7 ret nc 
l8e2ch:
    ld a,(hl)                  ;8e2c 7e  ~                         (flow from: 84ea 84f7)   84f8 ld a,(hl) 
    cp 028h                    ;8e2d fe 28  . (                    (flow from: 84f8)   84f9 cp 28 
    ld a,02ch                  ;8e2f 3e 2c  > ,                    (flow from: 84f9)   84fb ld a,2c 
    ret nz                     ;8e31 c0  .                         (flow from: 84fb)   84fd ret nz 
    inc hl                     ;8e32 23  #                         (flow from: 84fd)   84fe inc hl 
    ld a,(hl)                  ;8e33 7e  ~                         (flow from: 84fe)   84ff ld a,(hl) 
    cp 069h                    ;8e34 fe 69  . i                    (flow from: 84ff)   8500 cp 69 
    jr nz,l8e4eh               ;8e36 20 16    .                    (flow from: 8500)   8502 jr nz,851a 
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
    ld a,02dh                  ;8e4e 3e 2d  > -                    (flow from: 8502)   851a ld a,2d 
    ret nz                     ;8e50 c0  .                         (flow from: 851a)   851c ret nz 
l8e51h:
    ld a,b                     ;8e51 78  x 
    ret                        ;8e52 c9  . 
v_sub_851fh:
    xor a                      ;8e53 af  .                         (flow from: 7f1f 7f3f 84e1)   851f xor a 
    ld b,a                     ;8e54 47  G                         (flow from: 851f)   8520 ld b,a 
l8e55h:
    cp (hl)                    ;8e55 be  .                         (flow from: 8520 8525)   8521 cp (hl) 
    ret z                      ;8e56 c8  .                         (flow from: 8521)   8522 ret z 
    inc hl                     ;8e57 23  #                         (flow from: 8522)   8523 inc hl 
    inc b                      ;8e58 04  .                         (flow from: 8523)   8524 inc b 
    jr l8e55h                  ;8e59 18 fa  . .                    (flow from: 8524)   8525 jr 8521 
l8e5bh:
v_sub_8527h:
    push hl                    ;8e5b e5  .                         (flow from: 7f29 84f4 8541)   8527 push hl 
l8e5ch:
    ld a,(de)                  ;8e5c 1a  .                         (flow from: 8527 8533)   8528 ld a,(de) 
    and 07fh                   ;8e5d e6 7f  .                     (flow from: 8528)   8529 and 7f 
    cp (hl)                    ;8e5f be  .                         (flow from: 8529)   852b cp (hl) 
    jr nz,l8e6dh               ;8e60 20 0b    .                    (flow from: 852b)   852c jr nz,8539 
    ld a,(de)                  ;8e62 1a  .                         (flow from: 852c)   852e ld a,(de) 
    inc hl                     ;8e63 23  #                         (flow from: 852e)   852f inc hl 
    inc de                     ;8e64 13  .                         (flow from: 852f)   8530 inc de 
    and 080h                   ;8e65 e6 80  . .                    (flow from: 8530)   8531 and 80 
    jr z,l8e5ch                ;8e67 28 f3  ( .                    (flow from: 8531)   8533 jr z,8528 
    pop hl                     ;8e69 e1  .                         (flow from: 8533)   8535 pop hl 
    xor a                      ;8e6a af  .                         (flow from: 8535)   8536 xor a 
    ld a,c                     ;8e6b 79  y                         (flow from: 8536)   8537 ld a,c 
    ret                        ;8e6c c9  .                         (flow from: 8537)   8538 ret 
l8e6dh:
    pop hl                     ;8e6d e1  .                         (flow from: 852c)   8539 pop hl 
l8e6eh:
    ld a,(de)                  ;8e6e 1a  .                         (flow from: 8539 853e)   853a ld a,(de) 
    and 080h                   ;8e6f e6 80  . .                    (flow from: 853a)   853b and 80 
    inc de                     ;8e71 13  .                         (flow from: 853b)   853d inc de 
    jr z,l8e6eh                ;8e72 28 fa  ( .                    (flow from: 853d)   853e jr z,853a 
    inc c                      ;8e74 0c  .                         (flow from: 853e)   8540 inc c 
    djnz l8e5bh                ;8e75 10 e4  . .                    (flow from: 8540)   8541 djnz 8527 
    scf                        ;8e77 37  7                         (flow from: 8541)   8543 scf 
    ret                        ;8e78 c9  .                         (flow from: 8543)   8544 ret 
v_l8545h:
    or (hl)                    ;8e79 b6  . 
    ld l,001h                  ;8e7a 2e 01  . . 
    ld bc,0020ch               ;8e7c 01 0c 02  . . . 
    add hl,hl                  ;8e7f 29  ) 
    ld c,017h                  ;8e80 0e 17  . . 
    scf                        ;8e82 37  7 
v_l854fh:
    call p,00c2fh              ;8e83 f4 2f 0c  . / . 
    add hl,bc                  ;8e86 09  . 
    rrca                       ;8e87 0f  . 
    dec d                      ;8e88 15  . 
    ld (bc),a                  ;8e89 02  . 
    inc h                      ;8e8a 24  $ 
    ld b,026h                  ;8e8b 06 26  . & 
v_sub_8559h:
    ld a,b                     ;8e8d 78  x                         (flow from: 7f25 84f0)   8559 ld a,b 
    add a,a                    ;8e8e 87  .                         (flow from: 8559)   855a add a,a 
    ld c,a                     ;8e8f 4f  O                         (flow from: 855a)   855b ld c,a 
    xor a                      ;8e90 af  .                         (flow from: 855b)   855c xor a 
    ld b,a                     ;8e91 47  G                         (flow from: 855c)   855d ld b,a 
    push hl                    ;8e92 e5  .                         (flow from: 855d)   855e push hl 
    add hl,bc                  ;8e93 09  .                         (flow from: 855e)   855f add hl,bc 
    ld b,(hl)                  ;8e94 46  F                         (flow from: 855f)   8560 ld b,(hl) 
    inc hl                     ;8e95 23  #                         (flow from: 8560)   8561 inc hl 
    ld c,(hl)                  ;8e96 4e  N                         (flow from: 8561)   8562 ld c,(hl) 
    pop hl                     ;8e97 e1  .                         (flow from: 8562)   8563 pop hl 
    ld e,(hl)                  ;8e98 5e  ^                         (flow from: 8563)   8564 ld e,(hl) 
    inc hl                     ;8e99 23  #                         (flow from: 8564)   8565 inc hl 
    ld d,(hl)                  ;8e9a 56  V                         (flow from: 8565)   8566 ld d,(hl) 
    ld h,a                     ;8e9b 67  g                         (flow from: 8566)   8567 ld h,a 
    ld l,c                     ;8e9c 69  i                         (flow from: 8567)   8568 ld l,c 
    add hl,de                  ;8e9d 19  .                         (flow from: 8568)   8569 add hl,de 
    ld e,(hl)                  ;8e9e 5e  ^                         (flow from: 8569)   856a ld e,(hl) 
    ld d,a                     ;8e9f 57  W                         (flow from: 856a)   856b ld d,a 
    add hl,de                  ;8ea0 19  .                         (flow from: 856b)   856c add hl,de 
    ex de,hl                   ;8ea1 eb  .                         (flow from: 856c)   856d ex de,hl 
    ret                        ;8ea2 c9  .                         (flow from: 856d)   856e ret 
v_sub_856fh:
    ld b,020h                  ;8ea3 06 20  .                      (flow from: 7eed 7ef8)   856f ld b,20 
    jr l8eadh                  ;8ea5 18 06  . .                    (flow from: 856f)   8571 jr 8579 
v_sub_8573h:
    ld b,02ch                  ;8ea7 06 2c  . ,                    (flow from: 7f03)   8573 ld b,2c 
    jr l8eadh                  ;8ea9 18 02  . .                    (flow from: 8573)   8575 jr 8579 
v_sub_8577h:
    ld b,000h                  ;8eab 06 00  . .                    (flow from: 7f11)   8577 ld b,00 
l8eadh:
    call v_sub_85aeh-BA1       ;8ead cd ee 27  . . '               (flow from: 8571 8575 8577 8597)   8579 call 85ae 
    cp 022h                    ;8eb0 fe 22  . "                    (flow from: 85b1)   857c cp 22 
    jr z,l8ed9h                ;8eb2 28 25  ( %                    (flow from: 857c)   857e jr z,85a5 
    cp 027h                    ;8eb4 fe 27  . '                    (flow from: 857e)   8580 cp 27 
    jr z,l8ed9h                ;8eb6 28 21  ( !                    (flow from: 8580)   8582 jr z,85a5 
l8eb8h:
    cp b                       ;8eb8 b8  .                         (flow from: 8582 859f)   8584 cp b 
    ret z                      ;8eb9 c8  .                         (flow from: 8584)   8585 ret z 
    cp 020h                    ;8eba fe 20  .                      (flow from: 8585)   8586 cp 20 
    inc hl                     ;8ebc 23  #                         (flow from: 8586)   8588 inc hl 
    jr z,l8eadh                ;8ebd 28 ee  ( .                    (flow from: 8588)   8589 jr z,8579 
    dec hl                     ;8ebf 2b  +                         (flow from: 8589)   858b dec hl 
    or a                       ;8ec0 b7  .                         (flow from: 858b)   858c or a 
    jr nz,l8ec5h               ;8ec1 20 02    .                    (flow from: 858c)   858d jr nz,8591 
    inc a                      ;8ec3 3c  <                         (flow from: 858d)   858f inc a 
    ret                        ;8ec4 c9  .                         (flow from: 858f)   8590 ret 
l8ec5h:
    inc hl                     ;8ec5 23  #                         (flow from: 858d)   8591 inc hl 
    set 5,a                    ;8ec6 cb ef  . .                    (flow from: 8591)   8592 set 5,a 
    ld (de),a                  ;8ec8 12  .                         (flow from: 8592)   8594 ld (de),a 
    inc de                     ;8ec9 13  .                         (flow from: 8594)   8595 inc de 
    dec c                      ;8eca 0d  .                         (flow from: 8595)   8596 dec c 
    jr nz,l8eadh               ;8ecb 20 e0    .                    (flow from: 8596)   8597 jr nz,8579 
    jr l8edeh                  ;8ecd 18 0f  . . 
l8ecfh:
    call v_sub_85adh-BA1       ;8ecf cd ed 27  . . '               (flow from: 85a8)   859b call 85ad 
    or a                       ;8ed2 b7  .                         (flow from: 85b1)   859e or a 
    jr z,l8eb8h                ;8ed3 28 e3  ( .                    (flow from: 859e)   859f jr z,8584 
    cp 022h                    ;8ed5 fe 22  . " 
    jr z,l8eb8h                ;8ed7 28 df  ( . 
l8ed9h:
    ld (de),a                  ;8ed9 12  .                         (flow from: 8582)   85a5 ld (de),a 
    inc de                     ;8eda 13  .                         (flow from: 85a5)   85a6 inc de 
    dec c                      ;8edb 0d  .                         (flow from: 85a6)   85a7 dec c 
    jr nz,l8ecfh               ;8edc 20 f1    .                    (flow from: 85a7)   85a8 jr nz,859b 
l8edeh:
    jp v_l8089h-BA1            ;8ede c3 c9 22  . . " 
v_sub_85adh:
    inc hl                     ;8ee1 23  #                         (flow from: 859b)   85ad inc hl 
v_sub_85aeh:
    ld a,(hl)                  ;8ee2 7e  ~                         (flow from: 76c1 7c2f 7de9 82eb 8579 85ad 85b5 87af 8ll)   85ae ld a,(hl) 
    cp 001h                    ;8ee3 fe 01  . .                    (flow from: 85ae)   85af cp 01 
    ret nz                     ;8ee5 c0  .                         (flow from: 85af)   85b1 ret nz 
    inc hl                     ;8ee6 23  #                         (flow from: 85b1)   85b2 inc hl 
    ld a,(hl)                  ;8ee7 7e  ~                         (flow from: 85b2)   85b3 ld a,(hl) 
    ret                        ;8ee8 c9  .                         (flow from: 85b3)   85b4 ret 
l8ee9h:
v_sub_85b5h:
    call v_sub_85aeh-BA1       ;8ee9 cd ee 27  . . '               (flow from: 7ef0 7efb 85bc)   85b5 call 85ae 
    cp 020h                    ;8eec fe 20  .                      (flow from: 85b1 85b4)   85b8 cp 20 
    ret nz                     ;8eee c0  .                         (flow from: 85b8)   85ba ret nz 
    inc hl                     ;8eef 23  #                         (flow from: 85ba)   85bb inc hl 
    jr l8ee9h                  ;8ef0 18 f7  . .                    (flow from: 85bb)   85bc jr 85b5 
v_sub_85beh:
    ld hl,02fafh               ;8ef2 21 af 2f  ! . /               (flow from: 7cf4)   85be ld hl,8d6f 
    ld (02991h),hl             ;8ef5 22 91 29  " . )               (flow from: 85be)   85c1 ld (8751),hl 
    ld hl,050e0h               ;8ef8 21 e0 50  ! . P               (flow from: 85c1)   85c4 ld hl,50e0 
v_l85c7h:
    call v_sub_85f5h-BA1       ;8efb cd 35 28  . 5 (               (flow from: 85c4)   85c7 call 85f5 
    ld hl,v_l8afeh-BA1         ;8efe 21 3e 2d  ! > -               (flow from: 8607)   85ca ld hl,8afe 
l8f01h:
    inc hl                     ;8f01 23  #                         (flow from: 85ca 85df 85ee)   85cd inc hl 
    ld a,(029c8h)              ;8f02 3a c8 29  : . )               (flow from: 85cd)   85ce ld a,(8788) 
    and 01fh                   ;8f05 e6 1f  . .                    (flow from: 85ce)   85d1 and 1f 
    ld (020edh),a              ;8f07 32 ed 20  2 .                 (flow from: 85d1)   85d3 ld (7ead),a 
    ld a,(hl)                  ;8f0a 7e  ~                         (flow from: 85d3)   85d6 ld a,(hl) 
    dec a                      ;8f0b 3d  =                         (flow from: 85d6)   85d7 dec a 
    jr z,l8f15h                ;8f0c 28 07  ( .                    (flow from: 85d7)   85d8 jr z,85e1 
    inc a                      ;8f0e 3c  <                         (flow from: 85d8)   85da inc a 
    ret z                      ;8f0f c8  .                         (flow from: 85da)   85db ret z 
    call v_sub_874ah-BA1       ;8f10 cd 8a 29  . . )               (flow from: 85db)   85dc call 874a 
    jr l8f01h                  ;8f13 18 ec  . .                    (flow from: 877e)   85df jr 85cd 
l8f15h:
    ld (0207ch),hl             ;8f15 22 7c 20  " |                 (flow from: 85d8)   85e1 ld (7e3c),hl 
    push hl                    ;8f18 e5  .                         (flow from: 85e1)   85e4 push hl 
    ld a,(028aeh)              ;8f19 3a ae 28  : . (               (flow from: 85e4)   85e5 ld a,(866e) 
    add a,0cch                 ;8f1c c6 cc  . .                    (flow from: 85e5)   85e8 add a,cc 
    call v_sub_8769h-BA1       ;8f1e cd a9 29  . . )               (flow from: 85e8)   85ea call 8769 
    pop hl                     ;8f21 e1  .                         (flow from: 877e)   85ed pop hl 
    jr l8f01h                  ;8f22 18 dd  . .                    (flow from: 85ed)   85ee jr 85cd 
v_sub_85f0h:
    ld c,000h                  ;8f24 0e 00  . .                    (flow from: 827b)   85f0 ld c,00 
    call 022b0h                ;8f26 cd b0 22  . . "               (flow from: 85f0)   85f2 call 22b0 
v_sub_85f5h:
    ld (029c8h),hl             ;8f29 22 c8 29  " . )               (flow from: 22ca 80b7 85c7)   85f5 ld (8788),hl 
v_sub_85f8h:
    ld b,008h                  ;8f2c 06 08  . .                    (flow from: 85f5)   85f8 ld b,08 
l8f2eh:
    push hl                    ;8f2e e5  .                         (flow from: 85f8 8605)   85fa push hl 
    ld c,020h                  ;8f2f 0e 20  .                      (flow from: 85fa)   85fb ld c,20 
l8f31h:
    ld (hl),000h               ;8f31 36 00  6 .                    (flow from: 85fb 8601)   85fd ld (hl),00 
    inc l                      ;8f33 2c  ,                         (flow from: 85fd)   85ff inc l 
    dec c                      ;8f34 0d  .                         (flow from: 85ff)   8600 dec c 
    jr nz,l8f31h               ;8f35 20 fa    .                    (flow from: 8600)   8601 jr nz,85fd 
    pop hl                     ;8f37 e1  .                         (flow from: 8601)   8603 pop hl 
    inc h                      ;8f38 24  $                         (flow from: 8603)   8604 inc h 
    djnz l8f2eh                ;8f39 10 f3  . .                    (flow from: 8604)   8605 djnz 85fa 
    ret                        ;8f3b c9  .                         (flow from: 8605)   8607 ret 
v_sub_8608h:
    exx                        ;8f3c d9  . 
    call v_sub_8639h-BA1       ;8f3d cd 79 28  . y ( 
    exx                        ;8f40 d9  . 
    call v_sub_872eh-BA1       ;8f41 cd 6e 29  . n ) 
    ret nz                     ;8f44 c0  . 
    or 020h                    ;8f45 f6 20  .   
    ret                        ;8f47 c9  . 
v_l8614h:
    ld hl,00000h               ;8f48 21 00 00  ! . .               (flow from: 868c)   8614 ld hl,004e 
    inc hl                     ;8f4b 23  #                         (flow from: 8614)   8617 inc hl 
    ld (02855h),hl             ;8f4c 22 55 28  " U (               (flow from: 8617)   8618 ld (8615),hl 
    ld a,h                     ;8f4f 7c  |                         (flow from: 8618)   861b ld a,h 
    cp 005h                    ;8f50 fe 05  . .                    (flow from: 861b)   861c cp 05 
    jr nz,l8f6dh               ;8f52 20 19    .                    (flow from: 861c)   861e jr nz,8639 
    ld a,00dh                  ;8f54 3e 0d  > . 
    jr l8fc3h                  ;8f56 18 6b  . k 
l8f58h:
    ld h,002h                  ;8f58 26 02  & .                    (flow from: 863c)   8624 ld h,02 
l8f5ah:
    call v_sub_86aeh-BA1       ;8f5a cd ee 28  . . (               (flow from: 8624 862e)   8626 call 86ae 
    jr nz,l8f67h               ;8f5d 20 08    .                    (flow from: 86b9 86bb 86bf 86c2)   8629 jr nz,8633 
    dec hl                     ;8f5f 2b  +                         (flow from: 8629)   862b dec hl 
    inc h                      ;8f60 24  $                         (flow from: 862b)   862c inc h 
    dec h                      ;8f61 25  %                         (flow from: 862c)   862d dec h 
    jr nz,l8f5ah               ;8f62 20 f6    .                    (flow from: 862d)   862e jr nz,8626 
    call v_sub_86a8h-BA1       ;8f64 cd e8 28  . . (               (flow from: 862e)   8630 call 86a8 
l8f67h:
    ld hl,00000h               ;8f67 21 00 00  ! . .               (flow from: 8629 86ad)   8633 ld hl,0000 
    ld (02855h),hl             ;8f6a 22 55 28  " U (               (flow from: 8633)   8636 ld (8615),hl 
l8f6dh:
v_sub_8639h:
    call v_sub_86aeh-BA1       ;8f6d cd ee 28  . . (               (flow from: 7cfa 861e 8636)   8639 call 86ae 
    jr z,l8f58h                ;8f70 28 e6  ( .                    (flow from: 86b9 86bb 86bf 86c2)   863c jr z,8624 
    ld b,000h                  ;8f72 06 00  . .                    (flow from: 863c)   863e ld b,00 
    ld c,e                     ;8f74 4b  K                         (flow from: 863e)   8640 ld c,e 
    ld a,e                     ;8f75 7b  {                         (flow from: 8640)   8641 ld a,e 
    ld (028c5h),a              ;8f76 32 c5 28  2 . (               (flow from: 8641)   8642 ld (8685),a 
    ld hl,00204h               ;8f79 21 04 02  ! . .               (flow from: 8642)   8645 ld hl,0204 
    ld a,d                     ;8f7c 7a  z                         (flow from: 8645)   8648 ld a,d 
    cp 019h                    ;8f7d fe 19  . .                    (flow from: 8648)   8649 cp 19 
    jr z,l8ff7h                ;8f7f 28 76  ( v                    (flow from: 8649)   864b jr z,86c3 
    add hl,bc                  ;8f81 09  .                         (flow from: 864b)   864d add hl,bc 
    ld a,(hl)                  ;8f82 7e  ~                         (flow from: 864d)   864e ld a,(hl) 
    cp 020h                    ;8f83 fe 20  .                      (flow from: 864e)   864f cp 20 
    ld b,a                     ;8f85 47  G                         (flow from: 864f)   8651 ld b,a 
    jr c,l8fafh                ;8f86 38 27  8 '                    (flow from: 8651)   8652 jr c,867b 
    ld a,d                     ;8f88 7a  z                         (flow from: 8652)   8654 ld a,d 
    cp 028h                    ;8f89 fe 28  . (                    (flow from: 8654)   8655 cp 28 
    ld a,b                     ;8f8b 78  x                         (flow from: 8655)   8657 ld a,b 
    set 5,a                    ;8f8c cb ef  . .                    (flow from: 8657)   8658 set 5,a 
    jr nz,l8fa0h               ;8f8e 20 10    .                    (flow from: 8658)   865a jr nz,866c 
    call v_sub_8726h-BA1       ;8f90 cd 66 29  . f )               (flow from: 865a)   865c call 8726 
    jr nz,l8f99h               ;8f93 20 04    .                    (flow from: 872d)   865f jr nz,8665 
    sub 02dh                   ;8f95 d6 2d  . -                    (flow from: 865f)   8661 sub 2d 
    jr l8fafh                  ;8f97 18 16  . .                    (flow from: 8661)   8663 jr 867b 
l8f99h:
    call v_sub_872eh-BA1       ;8f99 cd 6e 29  . n ) 
    jr nz,l8fa0h               ;8f9c 20 02    . 
    res 5,a                    ;8f9e cb af  . . 
l8fa0h:
    ld b,a                     ;8fa0 47  G                         (flow from: 865a)   866c ld b,a 
    ld a,000h                  ;8fa1 3e 00  > .                    (flow from: 866c)   866d ld a,f7 
    or a                       ;8fa3 b7  .                         (flow from: 866d)   866f or a 
    ld a,b                     ;8fa4 78  x                         (flow from: 866f)   8670 ld a,b 
    jr z,l8fafh                ;8fa5 28 08  ( .                    (flow from: 8670)   8671 jr z,867b 
    call v_sub_872eh-BA1       ;8fa7 cd 6e 29  . n )               (flow from: 8671)   8673 call 872e 
    jr nz,l8fafh               ;8faa 20 03    .                    (flow from: 873c)   8676 jr nz,867b 
    ld a,020h                  ;8fac 3e 20  >                      (flow from: 8676)   8678 ld a,20 
    xor b                      ;8fae a8  .                         (flow from: 8678)   867a xor b 
l8fafh:
    ld b,a                     ;8faf 47  G                         (flow from: 8652 8663 8671 867a 86de 86e5)   867b ld b,a 
    or a                       ;8fb0 b7  .                         (flow from: 867b)   867c or a 
    jr z,l8f6dh                ;8fb1 28 ba  ( .                    (flow from: 867c)   867d jr z,8639 
    cp 080h                    ;8fb3 fe 80  . .                    (flow from: 867d)   867f cp 80 
    jr z,l8f6dh                ;8fb5 28 b6  ( .                    (flow from: 867f)   8681 jr z,8639 
    ld b,a                     ;8fb7 47  G                         (flow from: 8681)   8683 ld b,a 
    ld a,022h                  ;8fb8 3e 22  > "                    (flow from: 8683)   8684 ld a,22 
    cp 022h                    ;8fba fe 22  . "                    (flow from: 8684)   8686 cp 00 
    ld (028c7h),a              ;8fbc 32 c7 28  2 . (               (flow from: 8686)   8688 ld (8687),a 
    ld a,b                     ;8fbf 78  x                         (flow from: 8688)   868b ld a,b 
    jp z,v_l8614h-BA1          ;8fc0 ca 54 28  . T (               (flow from: 868b)   868c jp z,8614 
l8fc3h:
    push af                    ;8fc3 f5  .                         (flow from: 868c)   868f push af 
    call v_sub_870fh-BA1       ;8fc4 cd 4f 29  . O )               (flow from: 868f)   8690 call 870f 
    pop af                     ;8fc7 f1  .                         (flow from: 8728)   8693 pop af 
    ld h,014h                  ;8fc8 26 14  & .                    (flow from: 8693)   8694 ld h,14 
l8fcah:
    dec hl                     ;8fca 2b  +                         (flow from: 8694 8699)   8696 dec hl 
    inc h                      ;8fcb 24  $                         (flow from: 8696)   8697 inc h 
    dec h                      ;8fcc 25  %                         (flow from: 8697)   8698 dec h 
    jr nz,l8fcah               ;8fcd 20 fb    .                    (flow from: 8698)   8699 jr nz,8696 
    bit 7,a                    ;8fcf cb 7f  .                     (flow from: 8699)   869b bit 7,a 
    ld (02861h),a              ;8fd1 32 61 28  2 a (               (flow from: 869b)   869d ld (8621),a 
    ret z                      ;8fd4 c8  .                         (flow from: 869d)   86a0 ret z 
    ld h,04eh                  ;8fd5 26 4e  & N                    (flow from: 86a0)   86a1 ld h,4e 
l8fd7h:
    dec hl                     ;8fd7 2b  +                         (flow from: 86a1 86a6)   86a3 dec hl 
    inc h                      ;8fd8 24  $                         (flow from: 86a3)   86a4 inc h 
    dec h                      ;8fd9 25  %                         (flow from: 86a4)   86a5 dec h 
    jr nz,l8fd7h               ;8fda 20 fb    .                    (flow from: 86a5 86a6)   86a6 jr nz,86a3 
v_sub_86a8h:
    ld hl,028c7h               ;8fdc 21 c7 28  ! . (               (flow from: 8630 86a6)   86a8 ld hl,8687 
    ld (hl),000h               ;8fdf 36 00  6 .                    (flow from: 86a8)   86ab ld (hl),00 
    ret                        ;8fe1 c9  .                         (flow from: 86ab)   86ad ret 
v_sub_86aeh:
    push hl                    ;8fe2 e5  .                         (flow from: 8626 8639)   86ae push hl 
    call ROM_KeyboardScanning  ;8fe3                               (flow from: 8626 86ae)   86af call 028e 
    pop hl                     ;8fe6 e1  .                         (flow from: 02b2 02b5 02b8 02be)   86b2 pop hl 
    jr z,l8febh                ;8fe7 28 02  ( .                    (flow from: 86b2)   86b3 jr z,86b7 
    xor a                      ;8fe9 af  . 
    ret                        ;8fea c9  . 
l8febh:
    ld a,e                     ;8feb 7b  {                         (flow from: 86b3 86jr)   86b7 ld a,e 
    inc e                      ;8fec 1c  .                         (flow from: 86b7)   86b8 inc e 
    ret z                      ;8fed c8  .                         (flow from: 86b8)   86b9 ret z 
    inc d                      ;8fee 14  .                         (flow from: 86b9)   86ba inc d 
    ret nz                     ;8fef c0  .                         (flow from: 86ba)   86bb ret nz 
    ld a,e                     ;8ff0 7b  {                         (flow from: 86bb)   86bc ld a,e 
    sub 019h                   ;8ff1 d6 19  . .                    (flow from: 86bc)   86bd sub 19 
    ret z                      ;8ff3 c8  .                         (flow from: 86bd)   86bf ret z 
    sub 00fh                   ;8ff4 d6 0f  . .                    (flow from: 86bf)   86c0 sub 0f 
    ret                        ;8ff6 c9  .                         (flow from: 86c0)   86c2 ret 
l8ff7h:
    ex de,hl                   ;8ff7 eb  .                         (flow from: 864b)   86c3 ex de,hl 
    ld a,c                     ;8ff8 79  y                         (flow from: 86c3)   86c4 ld a,c 
    cp 01bh                    ;8ff9 fe 1b  . .                    (flow from: 86c4)   86c5 cp 1b 
    jr z,l9014h                ;8ffb 28 17  ( .                    (flow from: 86c5)   86c7 jr z,86e0 
    ld hl,v_l8affh-BA1         ;8ffd 21 3f 2d  ! ? -               (flow from: 86c7)   86c9 ld hl,8aff 
    ld a,(hl)                  ;9000 7e  ~                         (flow from: 86c9)   86cc ld a,(hl) 
    dec a                      ;9001 3d  =                         (flow from: 86cc)   86cd dec a 
    jr nz,l9014h               ;9002 20 10    .                    (flow from: 86cd)   86ce jr nz,86e0 
    inc hl                     ;9004 23  #                         (flow from: 86ce)   86d0 inc hl 
    or (hl)                    ;9005 b6  .                         (flow from: 86d0)   86d1 or (hl) 
    jr nz,l9014h               ;9006 20 0c    .                    (flow from: 86d1)   86d2 jr nz,86e0 
    ex de,hl                   ;9008 eb  .                         (flow from: 86d2)   86d4 ex de,hl 
    add hl,bc                  ;9009 09  .                         (flow from: 86d4)   86d5 add hl,bc 
    ld a,(hl)                  ;900a 7e  ~                         (flow from: 86d5)   86d6 ld a,(hl) 
    call v_sub_872eh-BA1       ;900b cd 6e 29  . n )               (flow from: 86d6)   86d7 call 872e 
    jr nz,l9014h               ;900e 20 04    .                    (flow from: 873c)   86da jr nz,86e0 
    set 7,a                    ;9010 cb ff  . .                    (flow from: 86da)   86dc set 7,a 
    jr l8fafh                  ;9012 18 9b  . .                    (flow from: 86dc)   86de jr 867b 
l9014h:
    ld hl,02926h               ;9014 21 26 29  ! & )               (flow from: 86ce)   86e0 ld hl,86e6 
    add hl,bc                  ;9017 09  .                         (flow from: 86e0)   86e3 add hl,bc 
    ld a,(hl)                  ;9018 7e  ~                         (flow from: 86e3)   86e4 ld a,(hl) 
    jr l8fafh                  ;9019 18 94  . .                    (flow from: 86e4)   86e5 jr 867b 
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
v_sub_870fh:
    ld e,01eh                  ;9043 1e 1e  . .                    (flow from: 8690)   870f ld e,0a 
    jr l9049h                  ;9045 18 02  . .                    (flow from: 870f)   8711 jr 8715 
v_sub_8713h:
    ld e,000h                  ;9047 1e 00  . . 
l9049h:
    ld hl,0012ch               ;9049 21 2c 01  ! , .               (flow from: 8711)   8715 ld hl,012c 
    ld a,017h                  ;904c 3e 17  > .                    (flow from: 8715)   8718 ld a,07 
l904eh:
    ld b,e                     ;904e 43  C                         (flow from: 8718 8724)   871a ld b,e 
    xor 010h                   ;904f ee 10  . .                    (flow from: 871a)   871b xor 10 
l9051h:
    out (0feh),a               ;9051 d3 fe  . .                    (flow from: 871b 871f)   871d out (fe),a 
l9053h:
    djnz l9051h                ;9053 10 fc  . .                    (flow from: 871d)   871f djnz 871d 
    dec hl                     ;9055 2b  +                         (flow from: 871f)   8721 dec hl 
    inc h                      ;9056 24  $                         (flow from: 8721)   8722 inc h 
    dec h                      ;9057 25  %                         (flow from: 8722)   8723 dec h 
    jr nz,l904eh               ;9058 20 f4    .                    (flow from: 8723)   8724 jr nz,871a 
v_sub_8726h:
    cp 030h                    ;905a fe 30  . 0                    (flow from: 841f 865c 8724 87b2)   8726 cp 30 
    ret c                      ;905c d8  .                         (flow from: 8726)   8728 ret c 
    cp 039h                    ;905d fe 39  . 9                    (flow from: 8728)   8729 cp 39 
    ret nc                     ;905f d0  .                         (flow from: 8729)   872b ret nc 
    cp a                       ;9060 bf  .                         (flow from: 872b)   872c cp a 
    ret                        ;9061 c9  .                         (flow from: 872c)   872d ret 
v_sub_872eh:
    cp 041h                    ;9062 fe 41  . A                    (flow from: 82bd 83cd 8673 86d7 87bd)   872e cp 41 
    ret c                      ;9064 d8  .                         (flow from: 872e)   8730 ret c 
    cp 07ah                    ;9065 fe 7a  . z                    (flow from: 8730)   8731 cp 7a 
    ret nc                     ;9067 d0  .                         (flow from: 8731)   8733 ret nc 
    cp 05bh                    ;9068 fe 5b  . [                    (flow from: 8733)   8734 cp 5b 
    jr c,l906fh                ;906a 38 03  8 .                    (flow from: 8734)   8736 jr c,873b 
    cp 061h                    ;906c fe 61  . a                    (flow from: 8736)   8738 cp 61 
    ret c                      ;906e d8  .                         (flow from: 8738)   873a ret c 
l906fh:
    cp a                       ;906f bf  .                         (flow from: 8736 873a)   873b cp a 
    ret                        ;9070 c9  .                         (flow from: 873b)   873c ret 
v_sub_873dh:
    ld a,020h                  ;9071 3e 20  >                      (flow from: 8a12)   873d ld a,20 
    jr l9078h                  ;9073 18 03  . .                    (flow from: 873d)   873f jr 8744 
v_sub_8741h:
    ld a,(hl)                  ;9075 7e  ~                         (flow from: 8a1e)   8741 ld a,(hl) 
    and 07fh                   ;9076 e6 7f  .                     (flow from: 8741)   8742 and 7f 
l9078h:
v_sub_8744h:
    exx                        ;9078 d9  .                         (flow from: 7bff 82c4 873f 8742 8a06)   8744 exx 
    call v_sub_877fh-BA1       ;9079 cd bf 29  . . )               (flow from: 8744)   8745 call 877f 
    exx                        ;907c d9  .                         (flow from: 87a9)   8748 exx 
    ret                        ;907d c9  .                         (flow from: 8748)   8749 ret 
v_sub_874ah:
    cp 080h                    ;907e fe 80  . .                    (flow from: 85dc)   874a cp 80 
    jr c,l909bh                ;9080 38 19  8 .                    (flow from: 874a)   874c jr c,8767 
    push hl                    ;9082 e5  .                         (flow from: 874c)   874e push hl 
    push de                    ;9083 d5  .                         (flow from: 874e)   874f push de 
    ld hl,l8d6fh               ;9084 21 6f 8d  ! o .               (flow from: 874f)   8750 ld hl,8d6f 
    ld d,000h                  ;9087 16 00  . .                    (flow from: 8750)   8753 ld d,00 
    ld e,a                     ;9089 5f  _                         (flow from: 8753)   8755 ld e,a 
    add hl,de                  ;908a 19  .                         (flow from: 8755)   8756 add hl,de 
    ld e,(hl)                  ;908b 5e  ^                         (flow from: 8756)   8757 ld e,(hl) 
    add hl,de                  ;908c 19  .                         (flow from: 8757)   8758 add hl,de 
l908dh:
    ld a,(hl)                  ;908d 7e  ~                         (flow from: 8758 8761)   8759 ld a,(hl) 
    inc hl                     ;908e 23  #                         (flow from: 8759)   875a inc hl 
    push af                    ;908f f5  .                         (flow from: 875a)   875b push af 
    call v_sub_8767h-BA1       ;9090 cd a7 29  . . )               (flow from: 875b)   875c call 8767 
    pop af                     ;9093 f1  .                         (flow from: 877e)   875f pop af 
    rlca                       ;9094 07  .                         (flow from: 875f)   8760 rlca 
    jr nc,l908dh               ;9095 30 f6  0 .                    (flow from: 8760)   8761 jr nc,8759 
    pop de                     ;9097 d1  .                         (flow from: 8761)   8763 pop de 
    pop hl                     ;9098 e1  .                         (flow from: 8763)   8764 pop hl 
v_sub_8765h:
    ld a,020h                  ;9099 3e 20  >                      (flow from: 8764)   8765 ld a,20 
l909bh:
v_sub_8767h:
    res 7,a                    ;909b cb bf  . .                    (flow from: 80d8 874c 875c 8765)   8767 res 7,a 
v_sub_8769h:
    exx                        ;909d d9  .                         (flow from: 7ca7 85ea 8767)   8769 exx 
    call v_sub_877fh-BA1       ;909e cd bf 29  . . )               (flow from: 8769)   876a call 877f 
    ld a,h                     ;90a1 7c  |                         (flow from: 87a9)   876d ld a,h 
    add a,00ah                 ;90a2 c6 0a  . .                    (flow from: 876d)   876e add a,0a 
    cp 05ah                    ;90a4 fe 5a  . Z                    (flow from: 876e)   8770 cp 5a 
    jr z,l90aeh                ;90a6 28 06  ( .                    (flow from: 8770)   8772 jr z,877a 
l90a8h:
    add a,007h                 ;90a8 c6 07  . .                    (flow from: 8772 8778)   8774 add a,07 
    cp 058h                    ;90aa fe 58  . X                    (flow from: 8774)   8776 cp 58 
    jr c,l90a8h                ;90ac 38 fa  8 .                    (flow from: 8776)   8778 jr c,8774 
l90aeh:
    ld h,a                     ;90ae 67  g                         (flow from: 8772 8778)   877a ld h,a 
    ld (hl),038h               ;90af 36 38  6 8                    (flow from: 877a)   877b ld (hl),38 
    exx                        ;90b1 d9  .                         (flow from: 877b)   877d exx 
    ret                        ;90b2 c9  .                         (flow from: 877d)   877e ret 
v_sub_877fh:
    add a,a                    ;90b3 87  .                         (flow from: 8745 876a)   877f add a,a 
    ld h,00fh                  ;90b4 26 0f  & .                    (flow from: 877f)   8780 ld h,0f 
    ld l,a                     ;90b6 6f  o                         (flow from: 8780)   8782 ld l,a 
    sbc a,a                    ;90b7 9f  .                         (flow from: 8782)   8783 sbc a,a 
    ld c,a                     ;90b8 4f  O                         (flow from: 8783)   8784 ld c,a 
    add hl,hl                  ;90b9 29  )                         (flow from: 8784)   8785 add hl,hl 
    add hl,hl                  ;90ba 29  )                         (flow from: 8785)   8786 add hl,hl 
    ld de,04020h               ;90bb 11 20 40  .   @               (flow from: 8786)   8787 ld de,401f 
    push de                    ;90be d5  .                         (flow from: 8787)   878a push de 
    ld b,008h                  ;90bf 06 08  . .                    (flow from: 878a)   878b ld b,08 
l90c1h:
    ld a,(hl)                  ;90c1 7e  ~                         (flow from: 878b 8794)   878d ld a,(hl) 
    nop                        ;90c2 00  .                         (flow from: 878d)   878e nop 
    or (hl)                    ;90c3 b6  .                         (flow from: 878e)   878f or (hl) 
    xor c                      ;90c4 a9  .                         (flow from: 878f)   8790 xor c 
    ld (de),a                  ;90c5 12  .                         (flow from: 8790)   8791 ld (de),a 
    inc hl                     ;90c6 23  #                         (flow from: 8791)   8792 inc hl 
    inc d                      ;90c7 14  .                         (flow from: 8792)   8793 inc d 
    djnz l90c1h                ;90c8 10 f7  . .                    (flow from: 8790 8793)   8794 djnz 878d 
    pop hl                     ;90ca e1  .                         (flow from: 8794)   8796 pop hl 
    push hl                    ;90cb e5  .                         (flow from: 8796)   8797 push hl 
    inc l                      ;90cc 2c  ,                         (flow from: 8797)   8798 inc l 
    jr nz,l90d9h               ;90cd 20 0a    .                    (flow from: 8798)   8799 jr nz,87a5 
    ld a,h                     ;90cf 7c  |                         (flow from: 8799)   879b ld a,h 
    add a,008h                 ;90d0 c6 08  . .                    (flow from: 879b)   879c add a,08 
    cp 058h                    ;90d2 fe 58  . X                    (flow from: 879c)   879e cp 58 
    jr nz,l90d8h               ;90d4 20 02    .                    (flow from: 879e)   87a0 jr nz,87a4 
    ld a,040h                  ;90d6 3e 40  > @                    (flow from: 87a0)   87a2 ld a,40 
l90d8h:
    ld h,a                     ;90d8 67  g                         (flow from: 87a0 87a2)   87a4 ld h,a 
l90d9h:
    ld (029c8h),hl             ;90d9 22 c8 29  " . )               (flow from: 8799 87a4)   87a5 ld (8788),hl 
    pop hl                     ;90dc e1  .                         (flow from: 87a5)   87a8 pop hl 
    ret                        ;90dd c9  .                         (flow from: 87a8)   87a9 ret 
v_sub_87aah:
    ld de,v_l8ac8h-BA1         ;90de 11 08 2d  . . -               (flow from: 8815)   87aa ld de,8ac8 
    ld b,000h                  ;90e1 06 00  . .                    (flow from: 87aa)   87ad ld b,00 
l90e3h:
    call v_sub_85aeh-BA1       ;90e3 cd ee 27  . . '               (flow from: 87ad 87c9)   87af call 85ae 
    call v_sub_8726h-BA1       ;90e6 cd 66 29  . f )               (flow from: 85b1)   87b2 call 8726 
    jr z,l90f6h                ;90e9 28 0b  ( .                    (flow from: 8728 872b 872d)   87b5 jr z,87c2 
    res 5,a                    ;90eb cb af  . .                    (flow from: 87b5)   87b7 res 5,a 
    cp 05fh                    ;90ed fe 5f  . _                    (flow from: 87b7)   87b9 cp 5f 
    jr z,l90f6h                ;90ef 28 05  ( .                    (flow from: 87b9)   87bb jr z,87c2 
    call v_sub_872eh-BA1       ;90f1 cd 6e 29  . n )               (flow from: 87bb)   87bd call 872e 
    jr nz,l9102h               ;90f4 20 0c    .                    (flow from: 8730 873c)   87c0 jr nz,87ce 
l90f6h:
    ld (de),a                  ;90f6 12  .                         (flow from: 87b5 87c0)   87c2 ld (de),a 
    inc de                     ;90f7 13  .                         (flow from: 87c2)   87c3 inc de 
    inc hl                     ;90f8 23  #                         (flow from: 87c3)   87c4 inc hl 
    inc b                      ;90f9 04  .                         (flow from: 87c4)   87c5 inc b 
    ld a,b                     ;90fa 78  x                         (flow from: 87c5)   87c6 ld a,b 
    cp 009h                    ;90fb fe 09  . .                    (flow from: 87c6)   87c7 cp 09 
    jr c,l90e3h                ;90fd 38 e4  8 .                    (flow from: 87c7)   87c9 jr c,87af 
    jp v_l8089h-BA1            ;90ff c3 c9 22  . . " 
l9102h:
    ld a,b                     ;9102 78  x                         (flow from: 87c0)   87ce ld a,b 
    ld (v_l8ac7h-BA1),a        ;9103 32 07 2d  2 . -               (flow from: 87ce)   87cf ld (8ac7),a 
    dec de                     ;9106 1b  .                         (flow from: 87cf)   87d2 dec de 
    ex de,hl                   ;9107 eb  .                         (flow from: 87d2)   87d3 ex de,hl 
    set 7,(hl)                 ;9108 cb fe  . .                    (flow from: 87d3)   87d4 set 7,(hl) 
    ld hl,03e76h               ;910a 21 76 3e  ! v >               (flow from: 87d4)   87d6 ld hl,b3b2 
    ld e,(hl)                  ;910d 5e  ^                         (flow from: 87d6)   87d9 ld e,(hl) 
    inc hl                     ;910e 23  #                         (flow from: 87d9)   87da inc hl 
    ld d,(hl)                  ;910f 56  V                         (flow from: 87da)   87db ld d,(hl) 
    inc hl                     ;9110 23  #                         (flow from: 87db)   87dc inc hl 
    push de                    ;9111 d5  .                         (flow from: 87dc)   87dd push de 
    ex de,hl                   ;9112 eb  .                         (flow from: 87dd)   87de ex de,hl 
    inc hl                     ;9113 23  #                         (flow from: 87de)   87df inc hl 
    add hl,hl                  ;9114 29  )                         (flow from: 87df)   87e0 add hl,hl 
    add hl,de                  ;9115 19  .                         (flow from: 87e0)   87e1 add hl,de 
    ld (02a37h),hl             ;9116 22 37 2a  " 7 *               (flow from: 87e1)   87e2 ld (87f7),hl 
    dec hl                     ;9119 2b  +                         (flow from: 87e2)   87e5 dec hl 
    dec hl                     ;911a 2b  +                         (flow from: 87e5)   87e6 dec hl 
    ld (02a63h),hl             ;911b 22 63 2a  " c *               (flow from: 87e6)   87e7 ld (8823),hl 
    pop bc                     ;911e c1  .                         (flow from: 87e7)   87ea pop bc 
    jr l9143h                  ;911f 18 22  . "                    (flow from: 87ea)   87eb jr 880f 
l9121h:
    push bc                    ;9121 c5  .                         (flow from: 8811)   87ed push bc 
    dec hl                     ;9122 2b  +                         (flow from: 87ed)   87ee dec hl 
    ld a,(hl)                  ;9123 7e  ~                         (flow from: 87ee)   87ef ld a,(hl) 
    and 03fh                   ;9124 e6 3f  . ?                    (flow from: 87ef)   87f0 and 3f 
    ld d,a                     ;9126 57  W                         (flow from: 87f0)   87f2 ld d,a 
    dec hl                     ;9127 2b  +                         (flow from: 87f2)   87f3 dec hl 
    ld e,(hl)                  ;9128 5e  ^                         (flow from: 87f3)   87f4 ld e,(hl) 
    push hl                    ;9129 e5  .                         (flow from: 87f4)   87f5 push hl 
    ld hl,00000h               ;912a 21 00 00  ! . .               (flow from: 87f5)   87f6 ld hl,b4b0 
    add hl,de                  ;912d 19  .                         (flow from: 87f6)   87f9 add hl,de 
    ld de,v_l8ac7h-BA1         ;912e 11 07 2d  . . -               (flow from: 87f9)   87fa ld de,8ac7 
    ld a,(de)                  ;9131 1a  .                         (flow from: 87fa)   87fd ld a,(de) 
    ld b,a                     ;9132 47  G                         (flow from: 87fd)   87fe ld b,a 
    inc de                     ;9133 13  .                         (flow from: 87fe)   87ff inc de 
l9134h:
    ld a,(de)                  ;9134 1a  .                         (flow from: 87ff 8806)   8800 ld a,(de) 
    cp (hl)                    ;9135 be  .                         (flow from: 8800)   8801 cp (hl) 
    jr nz,l9140h               ;9136 20 08    .                    (flow from: 8801)   8802 jr nz,880c 
    inc hl                     ;9138 23  #                         (flow from: 8802)   8804 inc hl 
    inc de                     ;9139 13  .                         (flow from: 8804)   8805 inc de 
    djnz l9134h                ;913a 10 f8  . .                    (flow from: 8805)   8806 djnz 8800 
    pop af                     ;913c f1  .                         (flow from: 8806)   8808 pop af 
    pop hl                     ;913d e1  .                         (flow from: 8808)   8809 pop hl 
    xor a                      ;913e af  .                         (flow from: 8809)   880a xor a 
    ret                        ;913f c9  .                         (flow from: 880a)   880b ret 
l9140h:
    pop hl                     ;9140 e1  .                         (flow from: 8802)   880c pop hl 
    pop bc                     ;9141 c1  .                         (flow from: 880c)   880d pop bc 
    dec bc                     ;9142 0b  .                         (flow from: 880d)   880e dec bc 
l9143h:
    ld a,b                     ;9143 78  x                         (flow from: 87eb 880e)   880f ld a,b 
    or c                       ;9144 b1  .                         (flow from: 880f)   8810 or c 
    jr nz,l9121h               ;9145 20 da    .                    (flow from: 8810)   8811 jr nz,87ed 
    scf                        ;9147 37  7                         (flow from: 8811)   8813 scf 
    ret                        ;9148 c9  .                         (flow from: 8813)   8814 ret 
v_sub_8815h:
    call v_sub_87aah-BA1       ;9149 cd ea 29  . . )               (flow from: 830a 83d8)   8815 call 87aa 
    ret nc                     ;914c d0  .                         (flow from: 880b 8814)   8818 ret nc 
    ld hl,v_l9c38h-BA1         ;914d 21 78 3e  ! x >               (flow from: 8818)   8819 ld hl,ac31 
    ld bc,0000ch               ;9150 01 0c 00  . . .               (flow from: 8819)   881c ld bc,000c 
    call v_sub_8068h-BA1       ;9153 cd a8 22  . . "               (flow from: 881c)   881f call 8068 
    ld de,00000h               ;9156 11 00 00  . . .               (flow from: 8078)   8822 ld de,a837 
    xor a                      ;9159 af  .                         (flow from: 8822)   8825 xor a 
    sbc hl,de                  ;915a ed 52  . R                    (flow from: 8825)   8826 sbc hl,de 
    ld b,h                     ;915c 44  D                         (flow from: 8826)   8828 ld b,h 
    ld c,l                     ;915d 4d  M                         (flow from: 8828)   8829 ld c,l 
    ld h,d                     ;915e 62  b                         (flow from: 8829)   882a ld h,d 
    ld l,e                     ;915f 6b  k                         (flow from: 882a)   882b ld l,e 
    inc de                     ;9160 13  .                         (flow from: 882b)   882c inc de 
    inc de                     ;9161 13  .                         (flow from: 882c)   882d inc de 
    call v_l88ech-BA1          ;9162 cd 2c 2b  . , +               (flow from: 882d)   882e call 88ec 
    ld hl,02a5ah               ;9165 21 5a 2a  ! Z *               (flow from: 88ee 8901)   8831 ld hl,881a 
    call v_sub_8978h-BA1       ;9168 cd b8 2b  . . +               (flow from: 8831)   8834 call 8978 
    ld hl,(02a17h)             ;916b 2a 17 2a  * . *               (flow from: 8989)   8837 ld hl,(87d7) 
    ld c,(hl)                  ;916e 4e  N                         (flow from: 8837)   883a ld c,(hl) 
    inc hl                     ;916f 23  #                         (flow from: 883a)   883b inc hl 
    ld b,(hl)                  ;9170 46  F                         (flow from: 883b)   883c ld b,(hl) 
    ld hl,(02a37h)             ;9171 2a 37 2a  * 7 *               (flow from: 883c)   883d ld hl,(87f7) 
    jr l91a0h                  ;9174 18 2a  . *                    (flow from: 883d)   8840 jr 886c 
l9176h:
    pop hl                     ;9176 e1  .                         (flow from: 8854)   8842 pop hl 
    pop af                     ;9177 f1  .                         (flow from: 8842)   8843 pop af 
    jr l91a4h                  ;9178 18 2a  . *                    (flow from: 8843)   8844 jr 8870 
l917ah:
    push bc                    ;917a c5  .                         (flow from: 886e)   8846 push bc 
    push hl                    ;917b e5  .                         (flow from: 8846)   8847 push hl 
    inc hl                     ;917c 23  #                         (flow from: 8847)   8848 inc hl 
    ld de,v_l8ac8h-BA1         ;917d 11 08 2d  . . -               (flow from: 8848)   8849 ld de,8ac8 
l9180h:
    inc hl                     ;9180 23  #                         (flow from: 8849 8862)   884c inc hl 
    ld c,(hl)                  ;9181 4e  N                         (flow from: 884c)   884d ld c,(hl) 
    res 7,c                    ;9182 cb b9  . .                    (flow from: 884d)   884e res 7,c 
    ld a,(de)                  ;9184 1a  .                         (flow from: 884e)   8850 ld a,(de) 
    and 07fh                   ;9185 e6 7f  .                     (flow from: 8850)   8851 and 7f 
    cp c                       ;9187 b9  .                         (flow from: 8851)   8853 cp c 
    jr c,l9176h                ;9188 38 ec  8 .                    (flow from: 8853)   8854 jr c,8842 
    jr nz,l9198h               ;918a 20 0c    .                    (flow from: 8854)   8856 jr nz,8864 
    ld a,(de)                  ;918c 1a  .                         (flow from: 8856)   8858 ld a,(de) 
    and 080h                   ;918d e6 80  . .                    (flow from: 8858)   8859 and 80 
    jr nz,l9176h               ;918f 20 e5    .                    (flow from: 8859)   885b jr nz,8842 
    bit 7,(hl)                 ;9191 cb 7e  . ~                    (flow from: 885b)   885d bit 7,(hl) 
    jr nz,l9198h               ;9193 20 03    .                    (flow from: 885d)   885f jr nz,8864 
    inc de                     ;9195 13  .                         (flow from: 885f)   8861 inc de 
    jr l9180h                  ;9196 18 e8  . .                    (flow from: 8861)   8862 jr 884c 
l9198h:
    bit 7,(hl)                 ;9198 cb 7e  . ~                    (flow from: 8856 8867)   8864 bit 7,(hl) 
    inc hl                     ;919a 23  #                         (flow from: 8864)   8866 inc hl 
    jr z,l9198h                ;919b 28 fb  ( .                    (flow from: 8866)   8867 jr z,8864 
    pop af                     ;919d f1  .                         (flow from: 8867)   8869 pop af 
    pop bc                     ;919e c1  .                         (flow from: 8869)   886a pop bc 
    dec bc                     ;919f 0b  .                         (flow from: 886a)   886b dec bc 
l91a0h:
    ld a,b                     ;91a0 78  x                         (flow from: 8840 886b)   886c ld a,b 
    or c                       ;91a1 b1  .                         (flow from: 886c)   886d or c 
    jr nz,l917ah               ;91a2 20 d6    .                    (flow from: 886d)   886e jr nz,8846 
l91a4h:
    push hl                    ;91a4 e5  .                         (flow from: 8844 886e)   8870 push hl 
    ex de,hl                   ;91a5 eb  .                         (flow from: 8870)   8871 ex de,hl 
    ld hl,(02a5ah)             ;91a6 2a 5a 2a  * Z *               (flow from: 8871)   8872 ld hl,(881a) 
    xor a                      ;91a9 af  .                         (flow from: 8872)   8875 xor a 
    sbc hl,de                  ;91aa ed 52  . R                    (flow from: 8875)   8876 sbc hl,de 
    ex de,hl                   ;91ac eb  .                         (flow from: 8876)   8878 ex de,hl 
    push hl                    ;91ad e5  .                         (flow from: 8878)   8879 push hl 
    ld b,a                     ;91ae 47  G                         (flow from: 8879)   887a ld b,a 
    ld a,(v_l8ac7h-BA1)        ;91af 3a 07 2d  : . -               (flow from: 887a)   887b ld a,(8ac7) 
    add a,002h                 ;91b2 c6 02  . .                    (flow from: 887b)   887e add a,02 
    ld c,a                     ;91b4 4f  O                         (flow from: 887e)   8880 ld c,a 
    push bc                    ;91b5 c5  .                         (flow from: 8880)   8881 push bc 
    push hl                    ;91b6 e5  .                         (flow from: 8881)   8882 push hl 
    add hl,bc                  ;91b7 09  .                         (flow from: 8882)   8883 add hl,bc 
    ld b,d                     ;91b8 42  B                         (flow from: 8883)   8884 ld b,d 
    ld c,e                     ;91b9 4b  K                         (flow from: 8884)   8885 ld c,e 
    ex de,hl                   ;91ba eb  .                         (flow from: 8885)   8886 ex de,hl 
    pop hl                     ;91bb e1  .                         (flow from: 8886)   8887 pop hl 
    call v_l88ech-BA1          ;91bc cd 2c 2b  . , +               (flow from: 8887)   8888 call 88ec 
    pop bc                     ;91bf c1  .                         (flow from: 88ee 8901)   888b pop bc 
    ld hl,02a5ah               ;91c0 21 5a 2a  ! Z *               (flow from: 888b)   888c ld hl,881a 
    call v_sub_8980h-BA1       ;91c3 cd c0 2b  . . +               (flow from: 888c)   888f call 8980 
    pop de                     ;91c6 d1  .                         (flow from: 8989)   8892 pop de 
    ld hl,v_l8ac6h-BA1         ;91c7 21 06 2d  ! . -               (flow from: 8892)   8893 ld hl,8ac6 
    ld (hl),000h               ;91ca 36 00  6 .                    (flow from: 8893)   8896 ld (hl),00 
    push bc                    ;91cc c5  .                         (flow from: 8896)   8898 push bc 
    call v_l88ech-BA1          ;91cd cd 2c 2b  . , +               (flow from: 8898)   8899 call 88ec 
    ld hl,(02a17h)             ;91d0 2a 17 2a  * . *               (flow from: 8901)   889c ld hl,(87d7) 
    call v_sub_897dh-BA1       ;91d3 cd bd 2b  . . +               (flow from: 889c)   889f call 897d 
    pop bc                     ;91d6 c1  .                         (flow from: 8989)   88a2 pop bc 
    dec de                     ;91d7 1b  .                         (flow from: 88a2)   88a3 dec de 
    ex de,hl                   ;91d8 eb  .                         (flow from: 88a3)   88a4 ex de,hl 
    ex (sp),hl                 ;91d9 e3  .                         (flow from: 88a4)   88a5 ex (sp),hl 
    ld de,(02a37h)             ;91da ed 5b 37 2a  . [ 7 *          (flow from: 88a5)   88a6 ld de,(87f7) 
    xor a                      ;91de af  .                         (flow from: 88a6)   88aa xor a 
    sbc hl,de                  ;91df ed 52  . R                    (flow from: 88aa)   88ab sbc hl,de 
    ex de,hl                   ;91e1 eb  .                         (flow from: 88ab)   88ad ex de,hl 
    inc hl                     ;91e2 23  #                         (flow from: 88ad)   88ae inc hl 
    inc hl                     ;91e3 23  #                         (flow from: 88ae)   88af inc hl 
    ld (02a37h),hl             ;91e4 22 37 2a  " 7 *               (flow from: 88af)   88b0 ld (87f7),hl 
    dec hl                     ;91e7 2b  +                         (flow from: 88b0)   88b3 dec hl 
    dec hl                     ;91e8 2b  +                         (flow from: 88b3)   88b4 dec hl 
    ld ix,(02a17h)             ;91e9 dd 2a 17 2a  . * . *          (flow from: 88b4)   88b5 ld ix,(87d7) 
    ex (sp),hl                 ;91ed e3  .                         (flow from: 88b5)   88b9 ex (sp),hl 
    jr l9201h                  ;91ee 18 11  . .                    (flow from: 88b9)   88ba jr 88cd 
l91f0h:
    call v_sub_75dbh-BA1       ;91f0 cd 1b 18  . . .               (flow from: 88d0)   88bc call 75db 
    sbc hl,de                  ;91f3 ed 52  . R                    (flow from: 75e8)   88bf sbc hl,de 
    jr c,l91ffh                ;91f5 38 08  8 .                    (flow from: 88bf)   88c1 jr c,88cb 
    push de                    ;91f7 d5  .                         (flow from: 88c1)   88c3 push de 
    push ix                    ;91f8 dd e5  . .                    (flow from: 88c3)   88c4 push ix 
    pop hl                     ;91fa e1  .                         (flow from: 88c4)   88c6 pop hl 
    call v_sub_8980h-BA1       ;91fb cd c0 2b  . . +               (flow from: 88c6)   88c7 call 8980 
    pop de                     ;91fe d1  .                         (flow from: 8989)   88ca pop de 
l91ffh:
    ex (sp),hl                 ;91ff e3  .                         (flow from: 88c1 88ca)   88cb ex (sp),hl 
    dec hl                     ;9200 2b  +                         (flow from: 88cb)   88cc dec hl 
l9201h:
    ld a,h                     ;9201 7c  |                         (flow from: 88ba 88cc)   88cd ld a,h 
    or l                       ;9202 b5  .                         (flow from: 88cd)   88ce or l 
    ex (sp),hl                 ;9203 e3  .                         (flow from: 88ce)   88cf ex (sp),hl 
    jr nz,l91f0h               ;9204 20 ea    .                    (flow from: 88cf)   88d0 jr nz,88bc 
    pop hl                     ;9206 e1  .                         (flow from: 88d0)   88d2 pop hl 
    ld (ix+002h),e             ;9207 dd 73 02  . s .               (flow from: 88d2)   88d3 ld (ix+02),e 
    ld (ix+003h),d             ;920a dd 72 03  . r .               (flow from: 88d3)   88d6 ld (ix+03),d 
    ld hl,(02a17h)             ;920d 2a 17 2a  * . *               (flow from: 88d6)   88d9 ld hl,(87d7) 
    ld a,(hl)                  ;9210 7e  ~                         (flow from: 88d9)   88dc ld a,(hl) 
    inc hl                     ;9211 23  #                         (flow from: 88dc)   88dd inc hl 
    ld h,(hl)                  ;9212 66  f                         (flow from: 88dd)   88de ld h,(hl) 
    ld l,a                     ;9213 6f  o                         (flow from: 88de)   88df ld l,a 
    ret                        ;9214 c9  .                         (flow from: 88df)   88e0 ret 
v_sub_88e1h:
    push hl                    ;9215 e5  . 
    ld hl,(02a5ah)             ;9216 2a 5a 2a  * Z * 
    and a                      ;9219 a7  . 
    sbc hl,de                  ;921a ed 52  . R 
    ld b,h                     ;921c 44  D 
    ld c,l                     ;921d 4d  M 
    ex de,hl                   ;921e eb  . 
    pop de                     ;921f d1  . 
v_l88ech:
    ld a,b                     ;9220 78  x                         (flow from: 882e 8888 8899 89ae 8a83)   88ec ld a,b 
    or c                       ;9221 b1  .                         (flow from: 88ec)   88ed or c 
    ret z                      ;9222 c8  .                         (flow from: 88ed)   88ee ret z 
    push hl                    ;9223 e5  .                         (flow from: 88ee)   88ef push hl 
    xor a                      ;9224 af  .                         (flow from: 88ef)   88f0 xor a 
    sbc hl,de                  ;9225 ed 52  . R                    (flow from: 88f0)   88f1 sbc hl,de 
    pop hl                     ;9227 e1  .                         (flow from: 88f1)   88f3 pop hl 
    jr c,l922dh                ;9228 38 03  8 .                    (flow from: 88f3)   88f4 jr c,88f9 
    ldir                       ;922a ed b0  . .                    (flow from: 88f4 88f6)   88f6 ldir 
    ret                        ;922c c9  .                         (flow from: 88f6)   88f8 ret 
l922dh:
    add hl,bc                  ;922d 09  .                         (flow from: 88f4)   88f9 add hl,bc 
    dec hl                     ;922e 2b  +                         (flow from: 88f9)   88fa dec hl 
    ex de,hl                   ;922f eb  .                         (flow from: 88fa)   88fb ex de,hl 
    add hl,bc                  ;9230 09  .                         (flow from: 88fb)   88fc add hl,bc 
    dec hl                     ;9231 2b  +                         (flow from: 88fc)   88fd dec hl 
    ex de,hl                   ;9232 eb  .                         (flow from: 88fd)   88fe ex de,hl 
    lddr                       ;9233 ed b8  . .                    (flow from: 88fe 88ff)   88ff lddr 
    ret                        ;9235 c9  .                         (flow from: 88ff)   8901 ret 
v_sub_8902h:
    ld c,000h                  ;9236 0e 00  . .                    (flow from: 8a15)   8902 ld c,00 
    ld ix,v_l8ac7h-BA1         ;9238 dd 21 07 2d  . ! . -          (flow from: 8902)   8904 ld ix,8ac7 
v_sub_8908h:
    ld a,000h                  ;923c 3e 00  > .                    (flow from: 8904)   8908 ld a,00 
    or a                       ;923e b7  .                         (flow from: 8908)   890a or a 
    jr z,l925ah                ;923f 28 19  ( .                    (flow from: 890a)   890b jr z,8926 
v_sub_890dh:
    ld (ix+000h),023h          ;9241 dd 36 00 23  . 6 . # 
    inc ix                     ;9245 dd 23  . # 
    ld de,01000h               ;9247 11 00 10  . . . 
    call v_sub_8941h-BA1       ;924a cd 81 2b  . . + 
    ld d,001h                  ;924d 16 01  . . 
    call v_sub_8941h-BA1       ;924f cd 81 2b  . . + 
v_sub_891eh:
    ld de,00010h               ;9252 11 10 00  . . . 
    call v_sub_8941h-BA1       ;9255 cd 81 2b  . . + 
    jr l9271h                  ;9258 18 17  . . 
l925ah:
v_sub_8926h:
    ld de,02710h               ;925a 11 10 27  . . '               (flow from: 890b)   8926 ld de,2710 
    call v_sub_8941h-BA1       ;925d cd 81 2b  . . +               (flow from: 8926)   8929 call 8941 
    ld de,003e8h               ;9260 11 e8 03  . . .               (flow from: 8961)   892c ld de,03e8 
    call v_sub_8941h-BA1       ;9263 cd 81 2b  . . +               (flow from: 892c)   892f call 8941 
v_sub_8932h:
    ld de,00064h               ;9266 11 64 00  . d .               (flow from: 8961)   8932 ld de,0064 
    call v_sub_8941h-BA1       ;9269 cd 81 2b  . . +               (flow from: 8932)   8935 call 8941 
    ld e,00ah                  ;926c 1e 0a  . .                    (flow from: 8961)   8938 ld e,0a 
    call v_sub_8941h-BA1       ;926e cd 81 2b  . . +               (flow from: 8938)   893a call 8941 
l9271h:
    ld e,001h                  ;9271 1e 01  . .                    (flow from: 8961)   893d ld e,01 
    ld c,000h                  ;9273 0e 00  . .                    (flow from: 893d)   893f ld c,00 
v_sub_8941h:
    ld a,0ffh                  ;9275 3e ff  > .                    (flow from: 8929 892f 8935 893a 893f)   8941 ld a,ff 
l9277h:
    inc a                      ;9277 3c  <                         (flow from: 8941 8947)   8943 inc a 
    and a                      ;9278 a7  .                         (flow from: 8943)   8944 and a 
    sbc hl,de                  ;9279 ed 52  . R                    (flow from: 8944)   8945 sbc hl,de 
    jr nc,l9277h               ;927b 30 fa  0 .                    (flow from: 8945)   8947 jr nc,8943 
    add hl,de                  ;927d 19  .                         (flow from: 8947)   8949 add hl,de 
    bit 0,c                    ;927e cb 41  . A                    (flow from: 8949)   894a bit 0,c 
    jr z,l9284h                ;9280 28 02  ( .                    (flow from: 894a)   894c jr z,8950 
    or a                       ;9282 b7  . 
    ret z                      ;9283 c8  . 
l9284h:
    res 0,c                    ;9284 cb 81  . .                    (flow from: 894c)   8950 res 0,c 
    add a,030h                 ;9286 c6 30  . 0                    (flow from: 8950)   8952 add a,30 
    cp 03ah                    ;9288 fe 3a  . :                    (flow from: 8952)   8954 cp 3a 
    jr c,l928eh                ;928a 38 02  8 .                    (flow from: 8954)   8956 jr c,895a 
    add a,007h                 ;928c c6 07  . . 
l928eh:
    call v_sub_8963h-BA1       ;928e cd a3 2b  . . +               (flow from: 8956)   895a call 8963 
    ld (ix+000h),000h          ;9291 dd 36 00 00  . 6 . .          (flow from: 8968)   895d ld (ix+00),00 
    ret                        ;9295 c9  .                         (flow from: 895d)   8961 ret 
v_sub_8962h:
    inc b                      ;9296 04  .                         (flow from: 848f)   8962 inc b 
v_sub_8963h:
    ld (ix+000h),a             ;9297 dd 77 00  . w .               (flow from: 895a 8962)   8963 ld (ix+00),a 
    inc ix                     ;929a dd 23  . #                    (flow from: 8963)   8966 inc ix 
    ret                        ;929c c9  .                         (flow from: 8966)   8968 ret 
v_sub_8969h:
    push hl                    ;929d e5  .                         (flow from: 8a96 8a9c)   8969 push hl 
    ld a,(hl)                  ;929e 7e  ~                         (flow from: 8969)   896a ld a,(hl) 
    inc hl                     ;929f 23  #                         (flow from: 896a)   896b inc hl 
    ld h,(hl)                  ;92a0 66  f                         (flow from: 896b)   896c ld h,(hl) 
    ld l,a                     ;92a1 6f  o                         (flow from: 896c)   896d ld l,a 
    ld de,v_l9c3eh-BA1         ;92a2 11 7e 3e  . ~ >               (flow from: 896d)   896e ld de,b252 
    and a                      ;92a5 a7  .                         (flow from: 896e)   8971 and a 
    sbc hl,de                  ;92a6 ed 52  . R                    (flow from: 8971)   8972 sbc hl,de 
    pop hl                     ;92a8 e1  .                         (flow from: 8972)   8974 pop hl 
    ret c                      ;92a9 d8  .                         (flow from: 8974)   8975 ret c 
    jr l92b4h                  ;92aa 18 08  . . 
v_sub_8978h:
    ld bc,00002h               ;92ac 01 02 00  . . .               (flow from: 8834)   8978 ld bc,0002 
    jr l92b4h                  ;92af 18 03  . .                    (flow from: 8978)   897b jr 8980 
v_sub_897dh:
    ld bc,00001h               ;92b1 01 01 00  . . .               (flow from: 889f)   897d ld bc,0001 
l92b4h:
v_sub_8980h:
    ld e,(hl)                  ;92b4 5e  ^                         (flow from: 888f 88c7 897b 897d 8a8a 8a90)   8980 ld e,(hl) 
    inc hl                     ;92b5 23  #                         (flow from: 8980)   8981 inc hl 
    ld d,(hl)                  ;92b6 56  V                         (flow from: 8981)   8982 ld d,(hl) 
    ex de,hl                   ;92b7 eb  .                         (flow from: 8982)   8983 ex de,hl 
    add hl,bc                  ;92b8 09  .                         (flow from: 8983)   8984 add hl,bc 
l92b9h:
    ex de,hl                   ;92b9 eb  .                         (flow from: 8984 89d8)   8985 ex de,hl 
    ld (hl),d                  ;92ba 72  r                         (flow from: 8985)   8986 ld (hl),d 
    dec hl                     ;92bb 2b  +                         (flow from: 8986)   8987 dec hl 
    ld (hl),e                  ;92bc 73  s                         (flow from: 8987)   8988 ld (hl),e 
    ret                        ;92bd c9  .                         (flow from: 8988)   8989 ret 
v_sub_898ah:
    push hl                    ;92be e5  .                         (flow from: 7e2c)   898a push hl 
    ld (02c1fh),hl             ;92bf 22 1f 2c  " . ,               (flow from: 898a)   898b ld (89df),hl 
    push bc                    ;92c2 c5  .                         (flow from: 898b)   898e push bc 
l92c3h:
    call v_sub_8248h-BA1       ;92c3 cd 88 24  . . $               (flow from: 898e)   898f call 8248 
    dec bc                     ;92c6 0b  .                         (flow from: 825a)   8992 dec bc 
    ld a,b                     ;92c7 78  x                         (flow from: 8992)   8993 ld a,b 
    or c                       ;92c8 b1  .                         (flow from: 8993)   8994 or c 
    jr nz,l92c3h               ;92c9 20 f8    .                    (flow from: 8994)   8995 jr nz,898f 
    pop bc                     ;92cb c1  .                         (flow from: 8995)   8997 pop bc 
    pop de                     ;92cc d1  .                         (flow from: 8997)   8998 pop de 
    push hl                    ;92cd e5  .                         (flow from: 8998)   8999 push hl 
    and a                      ;92ce a7  .                         (flow from: 8999)   899a and a 
    sbc hl,de                  ;92cf ed 52  . R                    (flow from: 899a)   899b sbc hl,de 
    ld b,h                     ;92d1 44  D                         (flow from: 899b)   899d ld b,h 
    ld c,l                     ;92d2 4d  M                         (flow from: 899d)   899e ld c,l 
    pop hl                     ;92d3 e1  .                         (flow from: 899e)   899f pop hl 
    push bc                    ;92d4 c5  .                         (flow from: 899f)   89a0 push bc 
    push de                    ;92d5 d5  .                         (flow from: 89a0)   89a1 push de 
    push hl                    ;92d6 e5  .                         (flow from: 89a1)   89a2 push hl 
    ld hl,(02a5ah)             ;92d7 2a 5a 2a  * Z *               (flow from: 89a2)   89a3 ld hl,(881a) 
    and a                      ;92da a7  .                         (flow from: 89a3)   89a6 and a 
    pop de                     ;92db d1  .                         (flow from: 89a6)   89a7 pop de 
    sbc hl,de                  ;92dc ed 52  . R                    (flow from: 89a7)   89a8 sbc hl,de 
    ex de,hl                   ;92de eb  .                         (flow from: 89a8)   89aa ex de,hl 
    ld b,d                     ;92df 42  B                         (flow from: 89aa)   89ab ld b,d 
    ld c,e                     ;92e0 4b  K                         (flow from: 89ab)   89ac ld c,e 
    pop de                     ;92e1 d1  .                         (flow from: 89ac)   89ad pop de 
    call v_l88ech-BA1          ;92e2 cd 2c 2b  . , +               (flow from: 89ad)   89ae call 88ec 
    pop bc                     ;92e5 c1  .                         (flow from: 88f8)   89b1 pop bc 
    push bc                    ;92e6 c5  .                         (flow from: 89b1)   89b2 push bc 
l92e7h:
    xor a                      ;92e7 af  .                         (flow from: 89b2 89b9)   89b3 xor a 
    ld (de),a                  ;92e8 12  .                         (flow from: 89b3)   89b4 ld (de),a 
    inc de                     ;92e9 13  .                         (flow from: 89b4)   89b5 inc de 
    dec bc                     ;92ea 0b  .                         (flow from: 89b5)   89b6 dec bc 
    ld a,b                     ;92eb 78  x                         (flow from: 89b6)   89b7 ld a,b 
    or c                       ;92ec b1  .                         (flow from: 89b7)   89b8 or c 
    jr nz,l92e7h               ;92ed 20 f8    .                    (flow from: 89b8)   89b9 jr nz,89b3 
    pop bc                     ;92ef c1  .                         (flow from: 89b9)   89bb pop bc 
    ld hl,02328h               ;92f0 21 28 23  ! ( #               (flow from: 89bb)   89bc ld hl,80e8 
    call v_sub_89dah-BA1       ;92f3 cd 1a 2c  . . ,               (flow from: 89bc)   89bf call 89da 
    ld hl,0232bh               ;92f6 21 2b 23  ! + #               (flow from: 89e5)   89c2 ld hl,80eb 
    call v_sub_89dah-BA1       ;92f9 cd 1a 2c  . . ,               (flow from: 89c2)   89c5 call 89da 
    ld hl,02a5ah               ;92fc 21 5a 2a  ! Z *               (flow from: 89e5)   89c8 ld hl,881a 
    call v_sub_89d1h-BA1       ;92ff cd 11 2c  . . ,               (flow from: 89c8)   89cb call 89d1 
    ld hl,02a17h               ;9302 21 17 2a  ! . *               (flow from: 8989)   89ce ld hl,87d7 
l9305h:
v_sub_89d1h:
    ld e,(hl)                  ;9305 5e  ^                         (flow from: 89cb 89ce)   89d1 ld e,(hl) 
    inc hl                     ;9306 23  #                         (flow from: 89d1)   89d2 inc hl 
    ld d,(hl)                  ;9307 56  V                         (flow from: 89d2)   89d3 ld d,(hl) 
    ex de,hl                   ;9308 eb  .                         (flow from: 89d3)   89d4 ex de,hl 
    and a                      ;9309 a7  .                         (flow from: 89d4)   89d5 and a 
    sbc hl,bc                  ;930a ed 42  . B                    (flow from: 89d5)   89d6 sbc hl,bc 
    jr l92b9h                  ;930c 18 ab  . .                    (flow from: 89d6)   89d8 jr 8985 
v_sub_89dah:
    push hl                    ;930e e5  .                         (flow from: 89bf 89c5)   89da push hl 
    ld e,(hl)                  ;930f 5e  ^                         (flow from: 89da)   89db ld e,(hl) 
    inc hl                     ;9310 23  #                         (flow from: 89db)   89dc inc hl 
    ld d,(hl)                  ;9311 56  V                         (flow from: 89dc)   89dd ld d,(hl) 
    ld hl,l9c28h               ;9312 21 28 9c  ! ( .               (flow from: 89dd)   89de ld hl,b24c 
    and a                      ;9315 a7  .                         (flow from: 89de)   89e1 and a 
    sbc hl,de                  ;9316 ed 52  . R                    (flow from: 89e1)   89e2 sbc hl,de 
    pop hl                     ;9318 e1  .                         (flow from: 89e2)   89e4 pop hl 
    ret nc                     ;9319 d0  .                         (flow from: 89e4)   89e5 ret nc 
    jr l9305h                  ;931a 18 e9  . . 
v_sub_89e8h:
    xor a                      ;931c af  .                         (flow from: 7716)   89e8 xor a 
    ld (0205fh),a              ;931d 32 5f 20  2 _                 (flow from: 89e8)   89e9 ld (7e1f),a 
    call v_sub_76b6h-BA1       ;9320 cd f6 18  . . .               (flow from: 89e9)   89ec call 76b6 
    call v_l77d1h-BA1          ;9323 cd 11 1a  . . .               (flow from: 76cd)   89ef call 77d1 
v_sub_89f2h:
    ld a,00ah                  ;9326 3e 0a  > .                    (flow from: 7804)   89f2 ld a,0a 
v_l89f4h:
    call v_sub_80b4h-BA1       ;9328 cd f4 22  . . "               (flow from: 7cda 7d00 7d33 89f2)   89f4 call 80b4 
    ld a,013h                  ;932b 3e 13  > .                    (flow from: 80e0)   89f7 ld a,13 
    ld (029c8h),a              ;932d 32 c8 29  2 . )               (flow from: 89f7)   89f9 ld (8788),a 
    ld a,(0205fh)              ;9330 3a 5f 20  : _                 (flow from: 89f9)   89fc ld a,(7e1f) 
    or a                       ;9333 b7  .                         (flow from: 89fc)   89ff or a 
    ld a,04fh                  ;9334 3e 4f  > O                    (flow from: 89ff)   8a00 ld a,4f 
    jr nz,l933ah               ;9336 20 02    .                    (flow from: 8a00)   8a02 jr nz,8a06 
    ld a,049h                  ;9338 3e 49  > I                    (flow from: 8a02)   8a04 ld a,49 
l933ah:
    call v_sub_8744h-BA1       ;933a cd 84 29  . . )               (flow from: 8a02 8a04)   8a06 call 8744 
    ld hl,(02a5ah)             ;933d 2a 5a 2a  * Z *               (flow from: 8749)   8a09 ld hl,(881a) 
    call v_sub_8a12h-BA1       ;9340 cd 52 2c  . R ,               (flow from: 8a09)   8a0c call 8a12 
    ld hl,(01b86h)             ;9343 2a 86 1b  * . .               (flow from: 8a1d)   8a0f ld hl,(7946) 
v_sub_8a12h:
    call v_sub_873dh-BA1       ;9346 cd 7d 29  . } )               (flow from: 8a0c 8a0f)   8a12 call 873d 
    call v_sub_8902h-BA1       ;9349 cd 42 2b  . B +               (flow from: 8749)   8a15 call 8902 
    ld hl,v_l8ac7h-BA1         ;934c 21 07 2d  ! . -               (flow from: 8961)   8a18 ld hl,8ac7 
l934fh:
v_sub_8a1bh:
    ld a,(hl)                  ;934f 7e  ~                         (flow from: 8a18 8a22)   8a1b ld a,(hl) 
    or a                       ;9350 b7  .                         (flow from: 8a1b)   8a1c or a 
    ret z                      ;9351 c8  .                         (flow from: 8a1c)   8a1d ret z 
    call v_sub_8741h-BA1       ;9352 cd 81 29  . . )               (flow from: 8a1d)   8a1e call 8741 
    inc hl                     ;9355 23  #                         (flow from: 8749)   8a21 inc hl 
    jr l934fh                  ;9356 18 f7  . .                    (flow from: 8a21)   8a22 jr 8a1b 
v_sub_8a24h:
    push hl                    ;9358 e5  .                         (flow from: 7c6f)   8a24 push hl 
    push de                    ;9359 d5  .                         (flow from: 8a24)   8a25 push de 
    ld de,03e68h               ;935a 11 68 3e  . h >               (flow from: 8a25)   8a26 ld de,9c28 
    and a                      ;935d a7  .                         (flow from: 8a26)   8a29 and a 
    sbc hl,de                  ;935e ed 52  . R                    (flow from: 8a29)   8a2a sbc hl,de 
    pop de                     ;9360 d1  .                         (flow from: 8a2a)   8a2c pop de 
    pop hl                     ;9361 e1  .                         (flow from: 8a2c)   8a2d pop hl 
    ret                        ;9362 c9  .                         (flow from: 8a2d)   8a2e ret 
v_sub_8a2fh:
    push hl                    ;9363 e5  .                         (flow from: 7c78)   8a2f push hl 
    push de                    ;9364 d5  .                         (flow from: 8a2f)   8a30 push de 
    ld de,0000ch               ;9365 11 0c 00  . . .               (flow from: 8a30)   8a31 ld de,000c 
    add hl,de                  ;9368 19  .                         (flow from: 8a31)   8a34 add hl,de 
    ld de,(02a17h)             ;9369 ed 5b 17 2a  . [ . *          (flow from: 8a34)   8a35 ld de,(87d7) 
    and a                      ;936d a7  .                         (flow from: 8a35)   8a39 and a 
    sbc hl,de                  ;936e ed 52  . R                    (flow from: 8a39)   8a3a sbc hl,de 
    pop de                     ;9370 d1  .                         (flow from: 8a3a)   8a3c pop de 
    pop hl                     ;9371 e1  .                         (flow from: 8a3c)   8a3d pop hl 
    ret                        ;9372 c9  .                         (flow from: 8a3d)   8a3e ret 
    call 02327h                ;9373 cd 27 23  . ' # 
    push hl                    ;9376 e5  . 
    push de                    ;9377 d5  . 
    ld bc,(v_sub_826ch+1-BA1)                                  ;9378 ed 4b ad 24  . K . $ 
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
    call v_sub_8248h-BA1       ;938a cd 88 24  . . $ 
    sbc hl,de                  ;938d ed 52  . R 
    ld b,h                     ;938f 44  D 
    ld c,l                     ;9390 4d  M 
    pop hl                     ;9391 e1  . 
    ld (02bafh),hl             ;9392 22 af 2b  " . + 
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
    ld b,000h                  ;93a0 06 00  . .                    (flow from: 7e17)   8a6c ld b,00 
l93a2h:
    push de                    ;93a2 d5  .                         (flow from: 8a6c)   8a6e push de 
    push hl                    ;93a3 e5  .                         (flow from: 8a6e)   8a6f push hl 
    call v_sub_8068h-BA1       ;93a4 cd a8 22  . . "               (flow from: 8a6f)   8a70 call 8068 
    push bc                    ;93a7 c5  .                         (flow from: 8078)   8a73 push bc 
    push bc                    ;93a8 c5  .                         (flow from: 8a73)   8a74 push bc 
    ex de,hl                   ;93a9 eb  .                         (flow from: 8a74)   8a75 ex de,hl 
    ld hl,(02a5ah)             ;93aa 2a 5a 2a  * Z *               (flow from: 8a75)   8a76 ld hl,(881a) 
    and a                      ;93ad a7  .                         (flow from: 8a76)   8a79 and a 
    sbc hl,de                  ;93ae ed 52  . R                    (flow from: 8a79)   8a7a sbc hl,de 
    ex (sp),hl                 ;93b0 e3  .                         (flow from: 8a7a)   8a7c ex (sp),hl 
    ex de,hl                   ;93b1 eb  .                         (flow from: 8a7c)   8a7d ex de,hl 
    push hl                    ;93b2 e5  .                         (flow from: 8a7d)   8a7e push hl 
    add hl,bc                  ;93b3 09  .                         (flow from: 8a7e)   8a7f add hl,bc 
    pop de                     ;93b4 d1  .                         (flow from: 8a7f)   8a80 pop de 
    ex de,hl                   ;93b5 eb  .                         (flow from: 8a80)   8a81 ex de,hl 
    pop bc                     ;93b6 c1  .                         (flow from: 8a81)   8a82 pop bc 
    call v_l88ech-BA1          ;93b7 cd 2c 2b  . , +               (flow from: 8a82)   8a83 call 88ec 
    pop bc                     ;93ba c1  .                         (flow from: 8901)   8a86 pop bc 
    ld hl,02a5ah               ;93bb 21 5a 2a  ! Z *               (flow from: 8a86)   8a87 ld hl,881a 
    call v_sub_8980h-BA1       ;93be cd c0 2b  . . +               (flow from: 8a87)   8a8a call 8980 
    ld hl,02a17h               ;93c1 21 17 2a  ! . *               (flow from: 8989)   8a8d ld hl,87d7 
    call v_sub_8980h-BA1       ;93c4 cd c0 2b  . . +               (flow from: 8a8d)   8a90 call 8980 
    ld hl,02328h               ;93c7 21 28 23  ! ( #               (flow from: 8989)   8a93 ld hl,80e8 
    call v_sub_8969h-BA1       ;93ca cd a9 2b  . . +               (flow from: 8a93)   8a96 call 8969 
    ld hl,0232bh               ;93cd 21 2b 23  ! + #               (flow from: 8975)   8a99 ld hl,80eb 
    call v_sub_8969h-BA1       ;93d0 cd a9 2b  . . +               (flow from: 8a99)   8a9c call 8969 
    pop de                     ;93d3 d1  .                         (flow from: 8975)   8a9f pop de 
    pop hl                     ;93d4 e1  .                         (flow from: 8a9f)   8aa0 pop hl 
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
l9404h:
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
v_l8ae5h:
    defb 000h                  ;9419 00  . 
    defb 000h                  ;941a 00  . 
    defb 000h                  ;941b 00  . 
    defb 000h                  ;941c 00  . 
    defb 000h                  ;941d 00  . 
    defb 000h                  ;941e 00  . 
    defb 000h                  ;941f 00  . 
    defb 000h                  ;9420 00  . 
    defb 000h                  ;9421 00  . 
    defb 000h                  ;9422 00  . 
    defb 000h                  ;9423 00  . 
    defb 000h                  ;9424 00  . 
    defb 000h                  ;9425 00  . 
    defb 000h                  ;9426 00  . 
    defb 000h                  ;9427 00  . 
    defb 000h                  ;9428 00  . 
    defb 000h                  ;9429 00  . 
    defb 000h                  ;942a 00  . 
    defb 000h                  ;942b 00  . 
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
v_l8affh:
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
    defb 0b0h                  ;9714 b0  . 
    defb 0b1h                  ;9715 b1  . 
    defb 0b2h                  ;9716 b2  . 
    defb 0b3h                  ;9717 b3  . 
    defb 0b4h                  ;9718 b4  . 
    defb 0b5h                  ;9719 b5  . 
    defb 0b6h                  ;971a b6  . 
    defb 0b7h                  ;971b b7  . 
    defb 0e1h                  ;971c e1  . 
    defb 0e2h                  ;971d e2  . 
    defb 0e3h                  ;971e e3  . 
    defb 0e4h                  ;971f e4  . 
    defb 0e5h                  ;9720 e5  . 
    defb 0e8h                  ;9721 e8  . 
    defb 0e9h                  ;9722 e9  . 
    defb 0ech                  ;9723 ec  . 
    defb 0edh                  ;9724 ed  . 
    defb 0f0h                  ;9725 f0  . 
    defb 0f2h                  ;9726 f2  . 
    defb 0fah                  ;9727 fa  . 
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
    defb 01ah                  ;9764 1a  . 
    defb 021h                  ;9765 21  ! 
    defb 025h                  ;9766 25  % 
    defb 028h                  ;9767 28  ( 
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
    defb 041h                  ;977e 41  A 
    defb 053h                  ;977f 53  S 
    defb 053h                  ;9780 53  S 
    defb 045h                  ;9781 45  E 
    defb 04dh                  ;9782 4d  M 
    defb 042h                  ;9783 42  B 
    defb 04ch                  ;9784 4c  L 
    defb 0d9h                  ;9785 d9  . 
    defb "BASI", 0xC3          ;BASIC
    defb "COP", 0xD9           ;COPY
    defb "DELET", 0xC5         ;DELETE
    defb "FIN", 0xC4           ;FIND
    defb "GEN", 0xD3           ;GENS
    defb "LOA", 0xC4           ;LOAD
    defb "MONITO", 0xD2        ;MONITOR
    defb "NE", 0xD7            ;NEW
    defb "PRIN", 0xD4          ;PRINT
    defb "QUI", 0xD4           ;QUIT
    defb "RU", 0xCE            ;RUN
    defb "SAV", 0xC5           ;SAVE
    defb "TABL", 0xC5          ;TABLE
    defb "U-TO", 0xD0          ;U-TOP
    defb "VERIF", 0xD9         ;VERIFY
    defb "CLEA", 0xD2          ;CLEAR
    defb "REPLAC", 0xC5        ;REPLACE
    defb 000h                  ;97d7 00  . 
    defb 000h                  ;97d8 00  . 
    defb 042h                  ;97d9 42  B 
    defb 000h                  ;97da 00  . 
    defb 004h                  ;97db 04  . 
    defb 000h                  ;97dc 00  . 
    defb 030h                  ;97dd 30  0 
    defb 000h                  ;97de 00  . 
    defb 000h                  ;97df 00  . 
    defb 000h                  ;97e0 00  . 
    defb 000h                  ;97e1 00  . 
    defb 080h                  ;97e2 80  . 
    defb 052h                  ;97e3 52  R 
    defb 050h                  ;97e4 50  P 
    defb 008h                  ;97e5 08  . 
    defb 001h                  ;97e6 01  . 
    defb 002h                  ;97e7 02  . 
    defb 014h                  ;97e8 14  . 
    defb 0b5h                  ;97e9 b5  . 
    defb 08ah                  ;97ea 8a  . 
    defb 001h                  ;97eb 01  . 
    defb 037h                  ;97ec 37  7 
    defb 002h                  ;97ed 02  . 
    defb 000h                  ;97ee 00  . 
    defb 000h                  ;97ef 00  . 
    defb 001h                  ;97f0 01  . 
    defb 080h                  ;97f1 80  . 
    defb 052h                  ;97f2 52  R 
    defb 058h                  ;97f3 58  X 
    defb 008h                  ;97f4 08  . 
    defb 002h                  ;97f5 02  . 
    defb 000h                  ;97f6 00  . 
    defb 015h                  ;97f7 15  . 
    defb 031h                  ;97f8 31  1 
    defb 027h                  ;97f9 27  ' 
    defb 002h                  ;97fa 02  . 
    defb 037h                  ;97fb 37  7 
    defb 031h                  ;97fc 31  1 
    defb 060h                  ;97fd 60  ` 
    defb 000h                  ;97fe 00  . 
    defb 002h                  ;97ff 02  . 
    defb 080h                  ;9800 80  . 
    defb 052h                  ;9801 52  R 
    defb 060h                  ;9802 60  ` 
    defb 008h                  ;9803 08  . 
    defb 003h                  ;9804 03  . 
    defb 000h                  ;9805 00  . 
    defb 036h                  ;9806 36  6 
    defb 0b0h                  ;9807 b0  . 
    defb 006h                  ;9808 06  . 
    defb 003h                  ;9809 03  . 
    defb 037h                  ;980a 37  7 
    defb 033h                  ;980b 33  3 
    defb 060h                  ;980c 60  ` 
    defb 000h                  ;980d 00  . 
    defb 003h                  ;980e 03  . 
    defb 080h                  ;980f 80  . 
    defb 052h                  ;9810 52  R 
    defb 068h                  ;9811 68  h 
    defb 008h                  ;9812 08  . 
    defb 004h                  ;9813 04  . 
    defb 000h                  ;9814 00  . 
    defb 036h                  ;9815 36  6 
    defb 050h                  ;9816 50  P 
    defb 004h                  ;9817 04  . 
    defb 004h                  ;9818 04  . 
    defb 037h                  ;9819 37  7 
    defb 045h                  ;981a 45  E 
    defb 060h                  ;981b 60  ` 
    defb 000h                  ;981c 00  . 
    defb 004h                  ;981d 04  . 
    defb 080h                  ;981e 80  . 
    defb 052h                  ;981f 52  R 
    defb 070h                  ;9820 70  p 
    defb 008h                  ;9821 08  . 
    defb 005h                  ;9822 05  . 
    defb 000h                  ;9823 00  . 
    defb 02eh                  ;9824 2e  . 
    defb 050h                  ;9825 50  P 
    defb 004h                  ;9826 04  . 
    defb 005h                  ;9827 05  . 
    defb 037h                  ;9828 37  7 
    defb 04bh                  ;9829 4b  K 
    defb 060h                  ;982a 60  ` 
    defb 000h                  ;982b 00  . 
    defb 005h                  ;982c 05  . 
    defb 080h                  ;982d 80  . 
    defb 052h                  ;982e 52  R 
    defb 080h                  ;982f 80  . 
    defb 008h                  ;9830 08  . 
    defb 006h                  ;9831 06  . 
    defb 001h                  ;9832 01  . 
    defb 014h                  ;9833 14  . 
    defb 055h                  ;9834 55  U 
    defb 087h                  ;9835 87  . 
    defb 006h                  ;9836 06  . 
    defb 037h                  ;9837 37  7 
    defb 074h                  ;9838 74  t 
    defb 000h                  ;9839 00  . 
    defb 000h                  ;983a 00  . 
    defb 006h                  ;983b 06  . 
    defb 080h                  ;983c 80  . 
    defb 053h                  ;983d 53  S 
    defb 040h                  ;983e 40  @ 
    defb 00fh                  ;983f 0f  . 
    defb 006h                  ;9840 06  . 
    defb 0a4h                  ;9841 a4  . 
    defb 053h                  ;9842 53  S 
    defb 070h                  ;9843 70  p 
    defb 017h                  ;9844 17  . 
    defb 007h                  ;9845 07  . 
    defb 000h                  ;9846 00  . 
    defb 096h                  ;9847 96  . 
    defb 000h                  ;9848 00  . 
    defb 004h                  ;9849 04  . 
    defb 007h                  ;984a 07  . 
    defb 037h                  ;984b 37  7 
    defb 076h                  ;984c 76  v 
    defb 000h                  ;984d 00  . 
    defb 000h                  ;984e 00  . 
    defb 007h                  ;984f 07  . 
    defb 080h                  ;9850 80  . 
    defb 052h                  ;9851 52  R 
    defb 048h                  ;9852 48  H 
    defb 008h                  ;9853 08  . 
    defb 008h                  ;9854 08  . 
    defb 000h                  ;9855 00  . 
    defb 00ah                  ;9856 0a  . 
    defb 0ach                  ;9857 ac  . 
    defb 0a4h                  ;9858 a4  . 
    defb 008h                  ;9859 08  . 
    defb 037h                  ;985a 37  7 
    defb 078h                  ;985b 78  x 
    defb 000h                  ;985c 00  . 
    defb 000h                  ;985d 00  . 
    defb 008h                  ;985e 08  . 
    defb 080h                  ;985f 80  . 
    defb 058h                  ;9860 58  X 
    defb 050h                  ;9861 50  P 
    defb 008h                  ;9862 08  . 
    defb 009h                  ;9863 09  . 
    defb 000h                  ;9864 00  . 
    defb 01eh                  ;9865 1e  . 
    defb 0c2h                  ;9866 c2  . 
    defb 0cbh                  ;9867 cb  . 
    defb 009h                  ;9868 09  . 
    defb 020h                  ;9869 20    
    defb 01eh                  ;986a 1e  . 
    defb 0dah                  ;986b da  . 
    defb 0cfh                  ;986c cf  . 
    defb 009h                  ;986d 09  . 
    defb 037h                  ;986e 37  7 
    defb 07ah                  ;986f 7a  z 
    defb 000h                  ;9870 00  . 
    defb 000h                  ;9871 00  . 
    defb 009h                  ;9872 09  . 
    defb 080h                  ;9873 80  . 
    defb 058h                  ;9874 58  X 
    defb 058h                  ;9875 58  X 
    defb 008h                  ;9876 08  . 
    defb 00ah                  ;9877 0a  . 
    defb 000h                  ;9878 00  . 
    defb 014h                  ;9879 14  . 
    defb 04ch                  ;987a 4c  L 
    defb 0c7h                  ;987b c7  . 
    defb 00ah                  ;987c 0a  . 
    defb 080h                  ;987d 80  . 
    defb 058h                  ;987e 58  X 
    defb 060h                  ;987f 60  ` 
    defb 008h                  ;9880 08  . 
    defb 00bh                  ;9881 0b  . 
    defb 000h                  ;9882 00  . 
    defb 02eh                  ;9883 2e  . 
    defb 0b0h                  ;9884 b0  . 
    defb 006h                  ;9885 06  . 
    defb 00bh                  ;9886 0b  . 
    defb 080h                  ;9887 80  . 
    defb 058h                  ;9888 58  X 
    defb 068h                  ;9889 68  h 
    defb 008h                  ;988a 08  . 
    defb 00ch                  ;988b 0c  . 
    defb 000h                  ;988c 00  . 
    defb 036h                  ;988d 36  6 
    defb 058h                  ;988e 58  X 
    defb 004h                  ;988f 04  . 
    defb 00ch                  ;9890 0c  . 
    defb 080h                  ;9891 80  . 
    defb 058h                  ;9892 58  X 
    defb 070h                  ;9893 70  p 
    defb 008h                  ;9894 08  . 
    defb 00dh                  ;9895 0d  . 
    defb 000h                  ;9896 00  . 
    defb 02eh                  ;9897 2e  . 
    defb 058h                  ;9898 58  X 
    defb 004h                  ;9899 04  . 
    defb 00dh                  ;989a 0d  . 
    defb 080h                  ;989b 80  . 
    defb 058h                  ;989c 58  X 
    defb 080h                  ;989d 80  . 
    defb 008h                  ;989e 08  . 
    defb 00eh                  ;989f 0e  . 
    defb 001h                  ;98a0 01  . 
    defb 014h                  ;98a1 14  . 
    defb 05dh                  ;98a2 5d  ] 
    defb 087h                  ;98a3 87  . 
    defb 00eh                  ;98a4 0e  . 
    defb 080h                  ;98a5 80  . 
    defb 059h                  ;98a6 59  Y 
    defb 040h                  ;98a7 40  @ 
    defb 00fh                  ;98a8 0f  . 
    defb 00eh                  ;98a9 0e  . 
    defb 0a4h                  ;98aa a4  . 
    defb 059h                  ;98ab 59  Y 
    defb 070h                  ;98ac 70  p 
    defb 017h                  ;98ad 17  . 
    defb 00fh                  ;98ae 0f  . 
    defb 000h                  ;98af 00  . 
    defb 098h                  ;98b0 98  . 
    defb 000h                  ;98b1 00  . 
    defb 004h                  ;98b2 04  . 
    defb 00fh                  ;98b3 0f  . 
    defb 080h                  ;98b4 80  . 
    defb 058h                  ;98b5 58  X 
    defb 048h                  ;98b6 48  H 
    defb 008h                  ;98b7 08  . 
    defb 010h                  ;98b8 10  . 
    defb 003h                  ;98b9 03  . 
    defb 07dh                  ;98ba 7d  } 
    defb 060h                  ;98bb 60  ` 
    defb 008h                  ;98bc 08  . 
    defb 010h                  ;98bd 10  . 
    defb 080h                  ;98be 80  . 
    defb 018h                  ;98bf 18  . 
    defb 050h                  ;98c0 50  P 
    defb 008h                  ;98c1 08  . 
    defb 011h                  ;98c2 11  . 
    defb 002h                  ;98c3 02  . 
    defb 014h                  ;98c4 14  . 
    defb 0bdh                  ;98c5 bd  . 
    defb 08ah                  ;98c6 8a  . 
    defb 011h                  ;98c7 11  . 
    defb 080h                  ;98c8 80  . 
    defb 018h                  ;98c9 18  . 
    defb 058h                  ;98ca 58  X 
    defb 008h                  ;98cb 08  . 
    defb 012h                  ;98cc 12  . 
    defb 000h                  ;98cd 00  . 
    defb 015h                  ;98ce 15  . 
    defb 039h                  ;98cf 39  9 
    defb 027h                  ;98d0 27  ' 
    defb 012h                  ;98d1 12  . 
    defb 080h                  ;98d2 80  . 
    defb 018h                  ;98d3 18  . 
    defb 060h                  ;98d4 60  ` 
    defb 008h                  ;98d5 08  . 
    defb 013h                  ;98d6 13  . 
    defb 000h                  ;98d7 00  . 
    defb 036h                  ;98d8 36  6 
    defb 0b8h                  ;98d9 b8  . 
    defb 006h                  ;98da 06  . 
    defb 013h                  ;98db 13  . 
    defb 080h                  ;98dc 80  . 
    defb 018h                  ;98dd 18  . 
    defb 068h                  ;98de 68  h 
    defb 008h                  ;98df 08  . 
    defb 014h                  ;98e0 14  . 
    defb 000h                  ;98e1 00  . 
    defb 036h                  ;98e2 36  6 
    defb 060h                  ;98e3 60  ` 
    defb 004h                  ;98e4 04  . 
    defb 014h                  ;98e5 14  . 
    defb 080h                  ;98e6 80  . 
    defb 018h                  ;98e7 18  . 
    defb 070h                  ;98e8 70  p 
    defb 008h                  ;98e9 08  . 
    defb 015h                  ;98ea 15  . 
    defb 000h                  ;98eb 00  . 
    defb 02eh                  ;98ec 2e  . 
    defb 060h                  ;98ed 60  ` 
    defb 004h                  ;98ee 04  . 
    defb 015h                  ;98ef 15  . 
    defb 080h                  ;98f0 80  . 
    defb 018h                  ;98f1 18  . 
    defb 080h                  ;98f2 80  . 
    defb 008h                  ;98f3 08  . 
    defb 016h                  ;98f4 16  . 
    defb 001h                  ;98f5 01  . 
    defb 014h                  ;98f6 14  . 
    defb 065h                  ;98f7 65  e 
    defb 087h                  ;98f8 87  . 
    defb 016h                  ;98f9 16  . 
    defb 080h                  ;98fa 80  . 
    defb 019h                  ;98fb 19  . 
    defb 040h                  ;98fc 40  @ 
    defb 00fh                  ;98fd 0f  . 
    defb 016h                  ;98fe 16  . 
    defb 0a4h                  ;98ff a4  . 
    defb 019h                  ;9900 19  . 
    defb 070h                  ;9901 70  p 
    defb 017h                  ;9902 17  . 
    defb 017h                  ;9903 17  . 
    defb 000h                  ;9904 00  . 
    defb 050h                  ;9905 50  P 
    defb 000h                  ;9906 00  . 
    defb 004h                  ;9907 04  . 
    defb 017h                  ;9908 17  . 
    defb 080h                  ;9909 80  . 
    defb 018h                  ;990a 18  . 
    defb 048h                  ;990b 48  H 
    defb 008h                  ;990c 08  . 
    defb 018h                  ;990d 18  . 
    defb 003h                  ;990e 03  . 
    defb 013h                  ;990f 13  . 
    defb 060h                  ;9910 60  ` 
    defb 007h                  ;9911 07  . 
    defb 018h                  ;9912 18  . 
    defb 080h                  ;9913 80  . 
    defb 01ah                  ;9914 1a  . 
    defb 050h                  ;9915 50  P 
    defb 008h                  ;9916 08  . 
    defb 019h                  ;9917 19  . 
    defb 000h                  ;9918 00  . 
    defb 01eh                  ;9919 1e  . 
    defb 0c2h                  ;991a c2  . 
    defb 0ebh                  ;991b eb  . 
    defb 019h                  ;991c 19  . 
    defb 020h                  ;991d 20    
    defb 01eh                  ;991e 1e  . 
    defb 0dah                  ;991f da  . 
    defb 0efh                  ;9920 ef  . 
    defb 019h                  ;9921 19  . 
    defb 080h                  ;9922 80  . 
    defb 01ah                  ;9923 1a  . 
    defb 058h                  ;9924 58  X 
    defb 008h                  ;9925 08  . 
    defb 01ah                  ;9926 1a  . 
    defb 000h                  ;9927 00  . 
    defb 014h                  ;9928 14  . 
    defb 04ch                  ;9929 4c  L 
    defb 0e7h                  ;992a e7  . 
    defb 01ah                  ;992b 1a  . 
    defb 080h                  ;992c 80  . 
    defb 01ah                  ;992d 1a  . 
    defb 060h                  ;992e 60  ` 
    defb 008h                  ;992f 08  . 
    defb 01bh                  ;9930 1b  . 
    defb 000h                  ;9931 00  . 
    defb 02eh                  ;9932 2e  . 
    defb 0b8h                  ;9933 b8  . 
    defb 006h                  ;9934 06  . 
    defb 01bh                  ;9935 1b  . 
    defb 080h                  ;9936 80  . 
    defb 01ah                  ;9937 1a  . 
    defb 068h                  ;9938 68  h 
    defb 008h                  ;9939 08  . 
    defb 01ch                  ;993a 1c  . 
    defb 000h                  ;993b 00  . 
    defb 036h                  ;993c 36  6 
    defb 068h                  ;993d 68  h 
    defb 004h                  ;993e 04  . 
    defb 01ch                  ;993f 1c  . 
    defb 080h                  ;9940 80  . 
    defb 01ah                  ;9941 1a  . 
    defb 070h                  ;9942 70  p 
    defb 008h                  ;9943 08  . 
    defb 01dh                  ;9944 1d  . 
    defb 000h                  ;9945 00  . 
    defb 02eh                  ;9946 2e  . 
    defb 068h                  ;9947 68  h 
    defb 004h                  ;9948 04  . 
    defb 01dh                  ;9949 1d  . 
    defb 080h                  ;994a 80  . 
    defb 01ah                  ;994b 1a  . 
    defb 080h                  ;994c 80  . 
    defb 008h                  ;994d 08  . 
    defb 01eh                  ;994e 1e  . 
    defb 001h                  ;994f 01  . 
    defb 014h                  ;9950 14  . 
    defb 06dh                  ;9951 6d  m 
    defb 087h                  ;9952 87  . 
    defb 01eh                  ;9953 1e  . 
    defb 080h                  ;9954 80  . 
    defb 01bh                  ;9955 1b  . 
    defb 040h                  ;9956 40  @ 
    defb 00fh                  ;9957 0f  . 
    defb 01eh                  ;9958 1e  . 
    defb 0a4h                  ;9959 a4  . 
    defb 01bh                  ;995a 1b  . 
    defb 070h                  ;995b 70  p 
    defb 017h                  ;995c 17  . 
    defb 01fh                  ;995d 1f  . 
    defb 000h                  ;995e 00  . 
    defb 056h                  ;995f 56  V 
    defb 000h                  ;9960 00  . 
    defb 004h                  ;9961 04  . 
    defb 01fh                  ;9962 1f  . 
    defb 080h                  ;9963 80  . 
    defb 01ah                  ;9964 1a  . 
    defb 048h                  ;9965 48  H 
    defb 008h                  ;9966 08  . 
    defb 020h                  ;9967 20    
    defb 003h                  ;9968 03  . 
    defb 013h                  ;9969 13  . 
    defb 005h                  ;996a 05  . 
    defb 087h                  ;996b 87  . 
    defb 020h                  ;996c 20    
    defb 080h                  ;996d 80  . 
    defb 064h                  ;996e 64  d 
    defb 050h                  ;996f 50  P 
    defb 008h                  ;9970 08  . 
    defb 021h                  ;9971 21  ! 
    defb 002h                  ;9972 02  . 
    defb 014h                  ;9973 14  . 
    defb 0c5h                  ;9974 c5  . 
    defb 08ah                  ;9975 8a  . 
    defb 021h                  ;9976 21  ! 
    defb 022h                  ;9977 22  " 
    defb 014h                  ;9978 14  . 
    defb 0ddh                  ;9979 dd  . 
    defb 08eh                  ;997a 8e  . 
    defb 021h                  ;997b 21  ! 
    defb 080h                  ;997c 80  . 
    defb 064h                  ;997d 64  d 
    defb 058h                  ;997e 58  X 
    defb 008h                  ;997f 08  . 
    defb 022h                  ;9980 22  " 
    defb 002h                  ;9981 02  . 
    defb 015h                  ;9982 15  . 
    defb 06bh                  ;9983 6b  k 
    defb 010h                  ;9984 10  . 
    defb 022h                  ;9985 22  " 
    defb 022h                  ;9986 22  " 
    defb 015h                  ;9987 15  . 
    defb 06bh                  ;9988 6b  k 
    defb 074h                  ;9989 74  t 
    defb 022h                  ;998a 22  " 
    defb 080h                  ;998b 80  . 
    defb 064h                  ;998c 64  d 
    defb 060h                  ;998d 60  ` 
    defb 008h                  ;998e 08  . 
    defb 023h                  ;998f 23  # 
    defb 000h                  ;9990 00  . 
    defb 036h                  ;9991 36  6 
    defb 0c0h                  ;9992 c0  . 
    defb 006h                  ;9993 06  . 
    defb 023h                  ;9994 23  # 
    defb 020h                  ;9995 20    
    defb 036h                  ;9996 36  6 
    defb 0d8h                  ;9997 d8  . 
    defb 00ah                  ;9998 0a  . 
    defb 023h                  ;9999 23  # 
    defb 080h                  ;999a 80  . 
    defb 064h                  ;999b 64  d 
    defb 068h                  ;999c 68  h 
    defb 008h                  ;999d 08  . 
    defb 024h                  ;999e 24  $ 
    defb 000h                  ;999f 00  . 
    defb 036h                  ;99a0 36  6 
    defb 070h                  ;99a1 70  p 
    defb 004h                  ;99a2 04  . 
    defb 024h                  ;99a3 24  $ 
    defb 020h                  ;99a4 20    
    defb 036h                  ;99a5 36  6 
    defb 0c8h                  ;99a6 c8  . 
    defb 008h                  ;99a7 08  . 
    defb 024h                  ;99a8 24  $ 
    defb 080h                  ;99a9 80  . 
    defb 064h                  ;99aa 64  d 
    defb 070h                  ;99ab 70  p 
    defb 008h                  ;99ac 08  . 
    defb 025h                  ;99ad 25  % 
    defb 000h                  ;99ae 00  . 
    defb 02eh                  ;99af 2e  . 
    defb 070h                  ;99b0 70  p 
    defb 004h                  ;99b1 04  . 
    defb 025h                  ;99b2 25  % 
    defb 020h                  ;99b3 20    
    defb 02eh                  ;99b4 2e  . 
    defb 0c8h                  ;99b5 c8  . 
    defb 008h                  ;99b6 08  . 
    defb 025h                  ;99b7 25  % 
    defb 080h                  ;99b8 80  . 
    defb 064h                  ;99b9 64  d 
    defb 080h                  ;99ba 80  . 
    defb 008h                  ;99bb 08  . 
    defb 026h                  ;99bc 26  & 
    defb 001h                  ;99bd 01  . 
    defb 014h                  ;99be 14  . 
    defb 075h                  ;99bf 75  u 
    defb 087h                  ;99c0 87  . 
    defb 026h                  ;99c1 26  & 
    defb 021h                  ;99c2 21  ! 
    defb 014h                  ;99c3 14  . 
    defb 0cdh                  ;99c4 cd  . 
    defb 08bh                  ;99c5 8b  . 
    defb 026h                  ;99c6 26  & 
    defb 080h                  ;99c7 80  . 
    defb 065h                  ;99c8 65  e 
    defb 040h                  ;99c9 40  @ 
    defb 00fh                  ;99ca 0f  . 
    defb 026h                  ;99cb 26  & 
    defb 0a4h                  ;99cc a4  . 
    defb 065h                  ;99cd 65  e 
    defb 070h                  ;99ce 70  p 
    defb 017h                  ;99cf 17  . 
    defb 027h                  ;99d0 27  ' 
    defb 000h                  ;99d1 00  . 
    defb 02ch                  ;99d2 2c  , 
    defb 000h                  ;99d3 00  . 
    defb 004h                  ;99d4 04  . 
    defb 027h                  ;99d5 27  ' 
    defb 080h                  ;99d6 80  . 
    defb 064h                  ;99d7 64  d 
    defb 048h                  ;99d8 48  H 
    defb 008h                  ;99d9 08  . 
    defb 028h                  ;99da 28  ( 
    defb 003h                  ;99db 03  . 
    defb 012h                  ;99dc 12  . 
    defb 0a5h                  ;99dd a5  . 
    defb 087h                  ;99de 87  . 
    defb 028h                  ;99df 28  ( 
    defb 080h                  ;99e0 80  . 
    defb 066h                  ;99e1 66  f 
    defb 050h                  ;99e2 50  P 
    defb 008h                  ;99e3 08  . 
    defb 029h                  ;99e4 29  ) 
    defb 000h                  ;99e5 00  . 
    defb 01eh                  ;99e6 1e  . 
    defb 0c3h                  ;99e7 c3  . 
    defb 00bh                  ;99e8 0b  . 
    defb 029h                  ;99e9 29  ) 
    defb 020h                  ;99ea 20    
    defb 01eh                  ;99eb 1e  . 
    defb 0dbh                  ;99ec db  . 
    defb 06fh                  ;99ed 6f  o 
    defb 029h                  ;99ee 29  ) 
    defb 080h                  ;99ef 80  . 
    defb 066h                  ;99f0 66  f 
    defb 058h                  ;99f1 58  X 
    defb 008h                  ;99f2 08  . 
    defb 02ah                  ;99f3 2a  * 
    defb 002h                  ;99f4 02  . 
    defb 014h                  ;99f5 14  . 
    defb 0c5h                  ;99f6 c5  . 
    defb 0b0h                  ;99f7 b0  . 
    defb 02ah                  ;99f8 2a  * 
    defb 022h                  ;99f9 22  " 
    defb 014h                  ;99fa 14  . 
    defb 0ddh                  ;99fb dd  . 
    defb 0b4h                  ;99fc b4  . 
    defb 02ah                  ;99fd 2a  * 
    defb 080h                  ;99fe 80  . 
    defb 066h                  ;99ff 66  f 
    defb 060h                  ;9a00 60  ` 
    defb 008h                  ;9a01 08  . 
    defb 02bh                  ;9a02 2b  + 
    defb 000h                  ;9a03 00  . 
    defb 02eh                  ;9a04 2e  . 
    defb 0c0h                  ;9a05 c0  . 
    defb 006h                  ;9a06 06  . 
    defb 02bh                  ;9a07 2b  + 
    defb 020h                  ;9a08 20    
    defb 02eh                  ;9a09 2e  . 
    defb 0d8h                  ;9a0a d8  . 
    defb 00ah                  ;9a0b 0a  . 
    defb 02bh                  ;9a0c 2b  + 
    defb 080h                  ;9a0d 80  . 
    defb 066h                  ;9a0e 66  f 
    defb 068h                  ;9a0f 68  h 
    defb 008h                  ;9a10 08  . 
    defb 02ch                  ;9a11 2c  , 
    defb 000h                  ;9a12 00  . 
    defb 036h                  ;9a13 36  6 
    defb 080h                  ;9a14 80  . 
    defb 004h                  ;9a15 04  . 
    defb 02ch                  ;9a16 2c  , 
    defb 020h                  ;9a17 20    
    defb 036h                  ;9a18 36  6 
    defb 0e8h                  ;9a19 e8  . 
    defb 008h                  ;9a1a 08  . 
    defb 02ch                  ;9a1b 2c  , 
    defb 080h                  ;9a1c 80  . 
    defb 066h                  ;9a1d 66  f 
    defb 070h                  ;9a1e 70  p 
    defb 008h                  ;9a1f 08  . 
    defb 02dh                  ;9a20 2d  - 
    defb 000h                  ;9a21 00  . 
    defb 02eh                  ;9a22 2e  . 
    defb 080h                  ;9a23 80  . 
    defb 004h                  ;9a24 04  . 
    defb 02dh                  ;9a25 2d  - 
    defb 020h                  ;9a26 20    
    defb 02eh                  ;9a27 2e  . 
    defb 0e8h                  ;9a28 e8  . 
    defb 008h                  ;9a29 08  . 
    defb 02dh                  ;9a2a 2d  - 
    defb 080h                  ;9a2b 80  . 
    defb 066h                  ;9a2c 66  f 
    defb 080h                  ;9a2d 80  . 
    defb 008h                  ;9a2e 08  . 
    defb 02eh                  ;9a2f 2e  . 
    defb 001h                  ;9a30 01  . 
    defb 014h                  ;9a31 14  . 
    defb 085h                  ;9a32 85  . 
    defb 087h                  ;9a33 87  . 
    defb 02eh                  ;9a34 2e  . 
    defb 021h                  ;9a35 21  ! 
    defb 014h                  ;9a36 14  . 
    defb 0edh                  ;9a37 ed  . 
    defb 08bh                  ;9a38 8b  . 
    defb 02eh                  ;9a39 2e  . 
    defb 080h                  ;9a3a 80  . 
    defb 067h                  ;9a3b 67  g 
    defb 040h                  ;9a3c 40  @ 
    defb 00fh                  ;9a3d 0f  . 
    defb 02eh                  ;9a3e 2e  . 
    defb 0a4h                  ;9a3f a4  . 
    defb 067h                  ;9a40 67  g 
    defb 070h                  ;9a41 70  p 
    defb 017h                  ;9a42 17  . 
    defb 02fh                  ;9a43 2f  / 
    defb 000h                  ;9a44 00  . 
    defb 02ah                  ;9a45 2a  * 
    defb 000h                  ;9a46 00  . 
    defb 004h                  ;9a47 04  . 
    defb 02fh                  ;9a48 2f  / 
    defb 080h                  ;9a49 80  . 
    defb 066h                  ;9a4a 66  f 
    defb 048h                  ;9a4b 48  H 
    defb 008h                  ;9a4c 08  . 
    defb 030h                  ;9a4d 30  0 
    defb 003h                  ;9a4e 03  . 
    defb 012h                  ;9a4f 12  . 
    defb 0fdh                  ;9a50 fd  . 
    defb 087h                  ;9a51 87  . 
    defb 030h                  ;9a52 30  0 
    defb 080h                  ;9a53 80  . 
    defb 09ah                  ;9a54 9a  . 
    defb 050h                  ;9a55 50  P 
    defb 008h                  ;9a56 08  . 
    defb 031h                  ;9a57 31  1 
    defb 002h                  ;9a58 02  . 
    defb 015h                  ;9a59 15  . 
    defb 01dh                  ;9a5a 1d  . 
    defb 08ah                  ;9a5b 8a  . 
    defb 031h                  ;9a5c 31  1 
    defb 080h                  ;9a5d 80  . 
    defb 09ah                  ;9a5e 9a  . 
    defb 058h                  ;9a5f 58  X 
    defb 008h                  ;9a60 08  . 
    defb 032h                  ;9a61 32  2 
    defb 002h                  ;9a62 02  . 
    defb 015h                  ;9a63 15  . 
    defb 069h                  ;9a64 69  i 
    defb 02dh                  ;9a65 2d  - 
    defb 032h                  ;9a66 32  2 
    defb 080h                  ;9a67 80  . 
    defb 09ah                  ;9a68 9a  . 
    defb 060h                  ;9a69 60  ` 
    defb 008h                  ;9a6a 08  . 
    defb 033h                  ;9a6b 33  3 
    defb 000h                  ;9a6c 00  . 
    defb 037h                  ;9a6d 37  7 
    defb 018h                  ;9a6e 18  . 
    defb 006h                  ;9a6f 06  . 
    defb 033h                  ;9a70 33  3 
    defb 080h                  ;9a71 80  . 
    defb 09ah                  ;9a72 9a  . 
    defb 068h                  ;9a73 68  h 
    defb 008h                  ;9a74 08  . 
    defb 034h                  ;9a75 34  4 
    defb 000h                  ;9a76 00  . 
    defb 037h                  ;9a77 37  7 
    defb 040h                  ;9a78 40  @ 
    defb 00bh                  ;9a79 0b  . 
    defb 034h                  ;9a7a 34  4 
    defb 024h                  ;9a7b 24  $ 
    defb 037h                  ;9a7c 37  7 
    defb 070h                  ;9a7d 70  p 
    defb 017h                  ;9a7e 17  . 
    defb 034h                  ;9a7f 34  4 
    defb 080h                  ;9a80 80  . 
    defb 09ah                  ;9a81 9a  . 
    defb 070h                  ;9a82 70  p 
    defb 008h                  ;9a83 08  . 
    defb 035h                  ;9a84 35  5 
    defb 000h                  ;9a85 00  . 
    defb 02fh                  ;9a86 2f  / 
    defb 040h                  ;9a87 40  @ 
    defb 00bh                  ;9a88 0b  . 
    defb 035h                  ;9a89 35  5 
    defb 024h                  ;9a8a 24  $ 
    defb 02fh                  ;9a8b 2f  / 
    defb 070h                  ;9a8c 70  p 
    defb 017h                  ;9a8d 17  . 
    defb 035h                  ;9a8e 35  5 
    defb 080h                  ;9a8f 80  . 
    defb 09ah                  ;9a90 9a  . 
    defb 080h                  ;9a91 80  . 
    defb 008h                  ;9a92 08  . 
    defb 036h                  ;9a93 36  6 
    defb 001h                  ;9a94 01  . 
    defb 015h                  ;9a95 15  . 
    defb 045h                  ;9a96 45  E 
    defb 08ah                  ;9a97 8a  . 
    defb 036h                  ;9a98 36  6 
    defb 025h                  ;9a99 25  % 
    defb 015h                  ;9a9a 15  . 
    defb 075h                  ;9a9b 75  u 
    defb 093h                  ;9a9c 93  . 
    defb 036h                  ;9a9d 36  6 
    defb 080h                  ;9a9e 80  . 
    defb 09bh                  ;9a9f 9b  . 
    defb 040h                  ;9aa0 40  @ 
    defb 00fh                  ;9aa1 0f  . 
    defb 036h                  ;9aa2 36  6 
    defb 0a4h                  ;9aa3 a4  . 
    defb 09bh                  ;9aa4 9b  . 
    defb 070h                  ;9aa5 70  p 
    defb 017h                  ;9aa6 17  . 
    defb 037h                  ;9aa7 37  7 
    defb 000h                  ;9aa8 00  . 
    defb 060h                  ;9aa9 60  ` 
    defb 000h                  ;9aaa 00  . 
    defb 004h                  ;9aab 04  . 
    defb 037h                  ;9aac 37  7 
    defb 080h                  ;9aad 80  . 
    defb 09ah                  ;9aae 9a  . 
    defb 048h                  ;9aaf 48  H 
    defb 008h                  ;9ab0 08  . 
    defb 038h                  ;9ab1 38  8 
    defb 003h                  ;9ab2 03  . 
    defb 012h                  ;9ab3 12  . 
    defb 05dh                  ;9ab4 5d  ] 
    defb 087h                  ;9ab5 87  . 
    defb 038h                  ;9ab6 38  8 
    defb 080h                  ;9ab7 80  . 
    defb 068h                  ;9ab8 68  h 
    defb 050h                  ;9ab9 50  P 
    defb 008h                  ;9aba 08  . 
    defb 039h                  ;9abb 39  9 
    defb 000h                  ;9abc 00  . 
    defb 01eh                  ;9abd 1e  . 
    defb 0c4h                  ;9abe c4  . 
    defb 06bh                  ;9abf 6b  k 
    defb 039h                  ;9ac0 39  9 
    defb 020h                  ;9ac1 20    
    defb 01eh                  ;9ac2 1e  . 
    defb 0dch                  ;9ac3 dc  . 
    defb 06fh                  ;9ac4 6f  o 
    defb 039h                  ;9ac5 39  9 
    defb 080h                  ;9ac6 80  . 
    defb 068h                  ;9ac7 68  h 
    defb 058h                  ;9ac8 58  X 
    defb 008h                  ;9ac9 08  . 
    defb 03ah                  ;9aca 3a  : 
    defb 002h                  ;9acb 02  . 
    defb 014h                  ;9acc 14  . 
    defb 04dh                  ;9acd 4d  M 
    defb 0adh                  ;9ace ad  . 
    defb 03ah                  ;9acf 3a  : 
    defb 080h                  ;9ad0 80  . 
    defb 068h                  ;9ad1 68  h 
    defb 060h                  ;9ad2 60  ` 
    defb 008h                  ;9ad3 08  . 
    defb 03bh                  ;9ad4 3b                        ; 
    defb 000h                  ;9ad5 00  . 
    defb 02fh                  ;9ad6 2f  / 
    defb 018h                  ;9ad7 18  . 
    defb 006h                  ;9ad8 06  . 
    defb 03bh                  ;9ad9 3b                        ; 
    defb 080h                  ;9ada 80  . 
    defb 068h                  ;9adb 68  h 
    defb 068h                  ;9adc 68  h 
    defb 008h                  ;9add 08  . 
    defb 03ch                  ;9ade 3c  < 
    defb 000h                  ;9adf 00  . 
    defb 036h                  ;9ae0 36  6 
    defb 048h                  ;9ae1 48  H 
    defb 004h                  ;9ae2 04  . 
    defb 03ch                  ;9ae3 3c  < 
    defb 080h                  ;9ae4 80  . 
    defb 068h                  ;9ae5 68  h 
    defb 070h                  ;9ae6 70  p 
    defb 008h                  ;9ae7 08  . 
    defb 03dh                  ;9ae8 3d  = 
    defb 000h                  ;9ae9 00  . 
    defb 02eh                  ;9aea 2e  . 
    defb 048h                  ;9aeb 48  H 
    defb 004h                  ;9aec 04  . 
    defb 03dh                  ;9aed 3d  = 
    defb 080h                  ;9aee 80  . 
    defb 068h                  ;9aef 68  h 
    defb 080h                  ;9af0 80  . 
    defb 008h                  ;9af1 08  . 
    defb 03eh                  ;9af2 3e  > 
    defb 001h                  ;9af3 01  . 
    defb 014h                  ;9af4 14  . 
    defb 04dh                  ;9af5 4d  M 
    defb 087h                  ;9af6 87  . 
    defb 03eh                  ;9af7 3e  > 
    defb 080h                  ;9af8 80  . 
    defb 069h                  ;9af9 69  i 
    defb 040h                  ;9afa 40  @ 
    defb 00fh                  ;9afb 0f  . 
    defb 03eh                  ;9afc 3e  > 
    defb 0a4h                  ;9afd a4  . 
    defb 069h                  ;9afe 69  i 
    defb 070h                  ;9aff 70  p 
    defb 017h                  ;9b00 17  . 
    defb 03fh                  ;9b01 3f  ? 
    defb 000h                  ;9b02 00  . 
    defb 024h                  ;9b03 24  $ 
    defb 000h                  ;9b04 00  . 
    defb 004h                  ;9b05 04  . 
    defb 03fh                  ;9b06 3f  ? 
    defb 080h                  ;9b07 80  . 
    defb 068h                  ;9b08 68  h 
    defb 048h                  ;9b09 48  H 
    defb 008h                  ;9b0a 08  . 
    defb 040h                  ;9b0b 40  @ 
    defb 000h                  ;9b0c 00  . 
    defb 014h                  ;9b0d 14  . 
    defb 051h                  ;9b0e 51  Q 
    defb 044h                  ;9b0f 44  D 
    defb 040h                  ;9b10 40  @ 
    defb 040h                  ;9b11 40  @ 
    defb 00eh                  ;9b12 0e  . 
    defb 054h                  ;9b13 54  T 
    defb 08ch                  ;9b14 8c  . 
    defb 040h                  ;9b15 40  @ 
    defb 080h                  ;9b16 80  . 
    defb 022h                  ;9b17 22  " 
    defb 009h                  ;9b18 09  . 
    defb 048h                  ;9b19 48  H 
    defb 041h                  ;9b1a 41  A 
    defb 000h                  ;9b1b 00  . 
    defb 014h                  ;9b1c 14  . 
    defb 051h                  ;9b1d 51  Q 
    defb 064h                  ;9b1e 64  d 
    defb 041h                  ;9b1f 41  A 
    defb 040h                  ;9b20 40  @ 
    defb 047h                  ;9b21 47  G 
    defb 021h                  ;9b22 21  ! 
    defb 04ch                  ;9b23 4c  L 
    defb 041h                  ;9b24 41  A 
    defb 080h                  ;9b25 80  . 
    defb 022h                  ;9b26 22  " 
    defb 009h                  ;9b27 09  . 
    defb 068h                  ;9b28 68  h 
    defb 042h                  ;9b29 42  B 
    defb 000h                  ;9b2a 00  . 
    defb 014h                  ;9b2b 14  . 
    defb 051h                  ;9b2c 51  Q 
    defb 084h                  ;9b2d 84  . 
    defb 042h                  ;9b2e 42  B 
    defb 040h                  ;9b2f 40  @ 
    defb 05eh                  ;9b30 5e  ^ 
    defb 0c2h                  ;9b31 c2  . 
    defb 0cfh                  ;9b32 cf  . 
    defb 042h                  ;9b33 42  B 
    defb 080h                  ;9b34 80  . 
    defb 022h                  ;9b35 22  " 
    defb 009h                  ;9b36 09  . 
    defb 088h                  ;9b37 88  . 
    defb 043h                  ;9b38 43  C 
    defb 000h                  ;9b39 00  . 
    defb 014h                  ;9b3a 14  . 
    defb 051h                  ;9b3b 51  Q 
    defb 0a4h                  ;9b3c a4  . 
    defb 043h                  ;9b3d 43  C 
    defb 042h                  ;9b3e 42  B 
    defb 015h                  ;9b3f 15  . 
    defb 06ah                  ;9b40 6a  j 
    defb 0d4h                  ;9b41 d4  . 
    defb 043h                  ;9b42 43  C 
    defb 080h                  ;9b43 80  . 
    defb 022h                  ;9b44 22  " 
    defb 009h                  ;9b45 09  . 
    defb 0a8h                  ;9b46 a8  . 
    defb 044h                  ;9b47 44  D 
    defb 000h                  ;9b48 00  . 
    defb 014h                  ;9b49 14  . 
    defb 051h                  ;9b4a 51  Q 
    defb 0c4h                  ;9b4b c4  . 
    defb 044h                  ;9b4c 44  D 
    defb 020h                  ;9b4d 20    
    defb 014h                  ;9b4e 14  . 
    defb 053h                  ;9b4f 53  S 
    defb 028h                  ;9b50 28  ( 
    defb 044h                  ;9b51 44  D 
    defb 040h                  ;9b52 40  @ 
    defb 040h                  ;9b53 40  @ 
    defb 000h                  ;9b54 00  . 
    defb 008h                  ;9b55 08  . 
    defb 044h                  ;9b56 44  D 
    defb 080h                  ;9b57 80  . 
    defb 022h                  ;9b58 22  " 
    defb 009h                  ;9b59 09  . 
    defb 0c8h                  ;9b5a c8  . 
    defb 045h                  ;9b5b 45  E 
    defb 000h                  ;9b5c 00  . 
    defb 014h                  ;9b5d 14  . 
    defb 052h                  ;9b5e 52  R 
    defb 004h                  ;9b5f 04  . 
    defb 045h                  ;9b60 45  E 
    defb 020h                  ;9b61 20    
    defb 014h                  ;9b62 14  . 
    defb 053h                  ;9b63 53  S 
    defb 0a8h                  ;9b64 a8  . 
    defb 045h                  ;9b65 45  E 
    defb 040h                  ;9b66 40  @ 
    defb 094h                  ;9b67 94  . 
    defb 000h                  ;9b68 00  . 
    defb 00eh                  ;9b69 0e  . 
    defb 045h                  ;9b6a 45  E 
    defb 080h                  ;9b6b 80  . 
    defb 022h                  ;9b6c 22  " 
    defb 00ah                  ;9b6d 0a  . 
    defb 008h                  ;9b6e 08  . 
    defb 046h                  ;9b6f 46  F 
    defb 000h                  ;9b70 00  . 
    defb 014h                  ;9b71 14  . 
    defb 055h                  ;9b72 55  U 
    defb 007h                  ;9b73 07  . 
    defb 046h                  ;9b74 46  F 
    defb 024h                  ;9b75 24  $ 
    defb 014h                  ;9b76 14  . 
    defb 055h                  ;9b77 55  U 
    defb 0d3h                  ;9b78 d3  . 
    defb 046h                  ;9b79 46  F 
    defb 040h                  ;9b7a 40  @ 
    defb 00ch                  ;9b7b 0c  . 
    defb 008h                  ;9b7c 08  . 
    defb 008h                  ;9b7d 08  . 
    defb 046h                  ;9b7e 46  F 
    defb 080h                  ;9b7f 80  . 
    defb 022h                  ;9b80 22  " 
    defb 00dh                  ;9b81 0d  . 
    defb 00ch                  ;9b82 0c  . 
    defb 046h                  ;9b83 46  F 
    defb 0a4h                  ;9b84 a4  . 
    defb 022h                  ;9b85 22  " 
    defb 00dh                  ;9b86 0d  . 
    defb 0d4h                  ;9b87 d4  . 
    defb 047h                  ;9b88 47  G 
    defb 000h                  ;9b89 00  . 
    defb 014h                  ;9b8a 14  . 
    defb 051h                  ;9b8b 51  Q 
    defb 024h                  ;9b8c 24  $ 
    defb 047h                  ;9b8d 47  G 
    defb 040h                  ;9b8e 40  @ 
    defb 014h                  ;9b8f 14  . 
    defb 079h                  ;9b90 79  y 
    defb 029h                  ;9b91 29  ) 
    defb 047h                  ;9b92 47  G 
    defb 080h                  ;9b93 80  . 
    defb 022h                  ;9b94 22  " 
    defb 009h                  ;9b95 09  . 
    defb 028h                  ;9b96 28  ( 
    defb 048h                  ;9b97 48  H 
    defb 000h                  ;9b98 00  . 
    defb 014h                  ;9b99 14  . 
    defb 059h                  ;9b9a 59  Y 
    defb 044h                  ;9b9b 44  D 
    defb 048h                  ;9b9c 48  H 
    defb 040h                  ;9b9d 40  @ 
    defb 00eh                  ;9b9e 0e  . 
    defb 05ch                  ;9b9f 5c  \ 
    defb 08ch                  ;9ba0 8c  . 
    defb 048h                  ;9ba1 48  H 
    defb 080h                  ;9ba2 80  . 
    defb 022h                  ;9ba3 22  " 
    defb 011h                  ;9ba4 11  . 
    defb 048h                  ;9ba5 48  H 
    defb 049h                  ;9ba6 49  I 
    defb 000h                  ;9ba7 00  . 
    defb 014h                  ;9ba8 14  . 
    defb 059h                  ;9ba9 59  Y 
    defb 064h                  ;9baa 64  d 
    defb 049h                  ;9bab 49  I 
    defb 040h                  ;9bac 40  @ 
    defb 047h                  ;9bad 47  G 
    defb 021h                  ;9bae 21  ! 
    defb 06ch                  ;9baf 6c  l 
    defb 049h                  ;9bb0 49  I 
    defb 080h                  ;9bb1 80  . 
    defb 022h                  ;9bb2 22  " 
    defb 011h                  ;9bb3 11  . 
    defb 068h                  ;9bb4 68  h 
    defb 04ah                  ;9bb5 4a  J 
    defb 000h                  ;9bb6 00  . 
    defb 014h                  ;9bb7 14  . 
    defb 059h                  ;9bb8 59  Y 
    defb 084h                  ;9bb9 84  . 
    defb 04ah                  ;9bba 4a  J 
    defb 040h                  ;9bbb 40  @ 
    defb 01ch                  ;9bbc 1c  . 
    defb 0c2h                  ;9bbd c2  . 
    defb 0cfh                  ;9bbe cf  . 
    defb 04ah                  ;9bbf 4a  J 
    defb 080h                  ;9bc0 80  . 
    defb 022h                  ;9bc1 22  " 
    defb 011h                  ;9bc2 11  . 
    defb 088h                  ;9bc3 88  . 
    defb 04bh                  ;9bc4 4b  K 
    defb 000h                  ;9bc5 00  . 
    defb 014h                  ;9bc6 14  . 
    defb 059h                  ;9bc7 59  Y 
    defb 0a4h                  ;9bc8 a4  . 
    defb 04bh                  ;9bc9 4b  K 
    defb 042h                  ;9bca 42  B 
    defb 014h                  ;9bcb 14  . 
    defb 0b5h                  ;9bcc b5  . 
    defb 0b4h                  ;9bcd b4  . 
    defb 04bh                  ;9bce 4b  K 
    defb 080h                  ;9bcf 80  . 
    defb 022h                  ;9bd0 22  " 
    defb 011h                  ;9bd1 11  . 
    defb 0a8h                  ;9bd2 a8  . 
    defb 04ch                  ;9bd3 4c  L 
    defb 000h                  ;9bd4 00  . 
    defb 014h                  ;9bd5 14  . 
    defb 059h                  ;9bd6 59  Y 
    defb 0c4h                  ;9bd7 c4  . 
    defb 04ch                  ;9bd8 4c  L 
    defb 020h                  ;9bd9 20    
    defb 014h                  ;9bda 14  . 
    defb 05bh                  ;9bdb 5b  [ 
    defb 028h                  ;9bdc 28  ( 
    defb 04ch                  ;9bdd 4c  L 
    defb 080h                  ;9bde 80  . 
    defb 022h                  ;9bdf 22  " 
    defb 011h                  ;9be0 11  . 
    defb 0c8h                  ;9be1 c8  . 
    defb 04dh                  ;9be2 4d  M 
    defb 000h                  ;9be3 00  . 
    defb 014h                  ;9be4 14  . 
    defb 05ah                  ;9be5 5a  Z 
    defb 004h                  ;9be6 04  . 
    defb 04dh                  ;9be7 4d  M 
    defb 020h                  ;9be8 20    
    defb 014h                  ;9be9 14  . 
    defb 05bh                  ;9bea 5b  [ 
    defb 0a8h                  ;9beb a8  . 
    defb 04dh                  ;9bec 4d  M 
    defb 040h                  ;9bed 40  @ 
    defb 092h                  ;9bee 92  . 
    defb 000h                  ;9bef 00  . 
    defb 00eh                  ;9bf0 0e  . 
    defb 04dh                  ;9bf1 4d  M 
    defb 080h                  ;9bf2 80  . 
    defb 022h                  ;9bf3 22  " 
    defb 012h                  ;9bf4 12  . 
    defb 008h                  ;9bf5 08  . 
    defb 04eh                  ;9bf6 4e  N 
    defb 000h                  ;9bf7 00  . 
    defb 014h                  ;9bf8 14  . 
    defb 05dh                  ;9bf9 5d  ] 
    defb 007h                  ;9bfa 07  . 
    defb 04eh                  ;9bfb 4e  N 
    defb 024h                  ;9bfc 24  $ 
    defb 014h                  ;9bfd 14  . 
    defb 05dh                  ;9bfe 5d  ] 
    defb 0d3h                  ;9bff d3  . 
    defb 04eh                  ;9c00 4e  N 
    defb 080h                  ;9c01 80  . 
    defb 022h                  ;9c02 22  " 
    defb 015h                  ;9c03 15  . 
    defb 00ch                  ;9c04 0c  . 
    defb 04eh                  ;9c05 4e  N 
    defb 0a4h                  ;9c06 a4  . 
    defb 022h                  ;9c07 22  " 
    defb 015h                  ;9c08 15  . 
    defb 0d4h                  ;9c09 d4  . 
    defb 04fh                  ;9c0a 4f  O 
    defb 000h                  ;9c0b 00  . 
    defb 014h                  ;9c0c 14  . 
    defb 059h                  ;9c0d 59  Y 
    defb 024h                  ;9c0e 24  $ 
    defb 04fh                  ;9c0f 4f  O 
    defb 040h                  ;9c10 40  @ 
    defb 014h                  ;9c11 14  . 
    defb 099h                  ;9c12 99  . 
    defb 029h                  ;9c13 29  ) 
    defb 04fh                  ;9c14 4f  O 
    defb 080h                  ;9c15 80  . 
    defb 022h                  ;9c16 22  " 
    defb 011h                  ;9c17 11  . 
    defb 028h                  ;9c18 28  ( 
    defb 050h                  ;9c19 50  P 
    defb 000h                  ;9c1a 00  . 
    defb 014h                  ;9c1b 14  . 
    defb 061h                  ;9c1c 61  a 
    defb 044h                  ;9c1d 44  D 
    defb 050h                  ;9c1e 50  P 
    defb 040h                  ;9c1f 40  @ 
    defb 00eh                  ;9c20 0e  . 
    defb 064h                  ;9c21 64  d 
    defb 08ch                  ;9c22 8c  . 
    defb 050h                  ;9c23 50  P 
    defb 080h                  ;9c24 80  . 
    defb 022h                  ;9c25 22  " 
    defb 019h                  ;9c26 19  . 
    defb 048h                  ;9c27 48  H 
l9c28h:
    defb 051h                  ;9c28 51  Q 
    defb 000h                  ;9c29 00  . 
    defb 014h                  ;9c2a 14  . 
    defb 061h                  ;9c2b 61  a 
    defb 064h                  ;9c2c 64  d 
    defb 051h                  ;9c2d 51  Q 
    defb 040h                  ;9c2e 40  @ 
    defb 047h                  ;9c2f 47  G 
    defb 021h                  ;9c30 21  ! 
    defb 08ch                  ;9c31 8c  . 
    defb 051h                  ;9c32 51  Q 
    defb 080h                  ;9c33 80  . 
    defb 022h                  ;9c34 22  " 
    defb 019h                  ;9c35 19  . 
    defb 068h                  ;9c36 68  h 
    defb 052h                  ;9c37 52  R 
l9c38h:
    defb 000h                  ;9c38 00  . 
    defb 014h                  ;9c39 14  . 
    defb 061h                  ;9c3a 61  a 
    defb 084h                  ;9c3b 84  . 
    defb 052h                  ;9c3c 52  R 
    defb 040h                  ;9c3d 40  @ 
    defb 05eh                  ;9c3e 5e  ^ 
    defb 0c2h                  ;9c3f c2  . 
    defb 0efh                  ;9c40 ef  . 
    defb 052h                  ;9c41 52  R 
    defb 080h                  ;9c42 80  . 
    defb 022h                  ;9c43 22  " 
    defb 019h                  ;9c44 19  . 
    defb 088h                  ;9c45 88  . 
    defb 053h                  ;9c46 53  S 
    defb 000h                  ;9c47 00  . 
    defb 014h                  ;9c48 14  . 
    defb 061h                  ;9c49 61  a 
    defb 0a4h                  ;9c4a a4  . 
    defb 053h                  ;9c4b 53  S 
    defb 042h                  ;9c4c 42  B 
    defb 015h                  ;9c4d 15  . 
    defb 06ah                  ;9c4e 6a  j 
    defb 0f4h                  ;9c4f f4  . 
    defb 053h                  ;9c50 53  S 
    defb 080h                  ;9c51 80  . 
    defb 022h                  ;9c52 22  " 
    defb 019h                  ;9c53 19  . 
    defb 0a8h                  ;9c54 a8  . 
    defb 054h                  ;9c55 54  T 
    defb 000h                  ;9c56 00  . 
    defb 014h                  ;9c57 14  . 
    defb 061h                  ;9c58 61  a 
    defb 0c4h                  ;9c59 c4  . 
    defb 054h                  ;9c5a 54  T 
    defb 020h                  ;9c5b 20    
    defb 014h                  ;9c5c 14  . 
    defb 063h                  ;9c5d 63  c 
    defb 028h                  ;9c5e 28  ( 
    defb 054h                  ;9c5f 54  T 
    defb 080h                  ;9c60 80  . 
    defb 022h                  ;9c61 22  " 
    defb 019h                  ;9c62 19  . 
    defb 0c8h                  ;9c63 c8  . 
    defb 055h                  ;9c64 55  U 
    defb 000h                  ;9c65 00  . 
    defb 014h                  ;9c66 14  . 
    defb 062h                  ;9c67 62  b 
    defb 004h                  ;9c68 04  . 
    defb 055h                  ;9c69 55  U 
    defb 020h                  ;9c6a 20    
    defb 014h                  ;9c6b 14  . 
    defb 063h                  ;9c6c 63  c 
    defb 0a8h                  ;9c6d a8  . 
    defb 055h                  ;9c6e 55  U 
    defb 080h                  ;9c6f 80  . 
    defb 022h                  ;9c70 22  " 
    defb 01ah                  ;9c71 1a  . 
    defb 008h                  ;9c72 08  . 
    defb 056h                  ;9c73 56  V 
    defb 000h                  ;9c74 00  . 
    defb 014h                  ;9c75 14  . 
    defb 065h                  ;9c76 65  e 
    defb 007h                  ;9c77 07  . 
    defb 056h                  ;9c78 56  V 
    defb 024h                  ;9c79 24  $ 
    defb 014h                  ;9c7a 14  . 
    defb 065h                  ;9c7b 65  e 
    defb 0d3h                  ;9c7c d3  . 
    defb 056h                  ;9c7d 56  V 
    defb 040h                  ;9c7e 40  @ 
    defb 00ch                  ;9c7f 0c  . 
    defb 010h                  ;9c80 10  . 
    defb 008h                  ;9c81 08  . 
    defb 056h                  ;9c82 56  V 
    defb 080h                  ;9c83 80  . 
    defb 022h                  ;9c84 22  " 
    defb 01dh                  ;9c85 1d  . 
    defb 00ch                  ;9c86 0c  . 
    defb 056h                  ;9c87 56  V 
    defb 0a4h                  ;9c88 a4  . 
    defb 022h                  ;9c89 22  " 
    defb 01dh                  ;9c8a 1d  . 
    defb 0d4h                  ;9c8b d4  . 
    defb 057h                  ;9c8c 57  W 
    defb 000h                  ;9c8d 00  . 
    defb 014h                  ;9c8e 14  . 
    defb 061h                  ;9c8f 61  a 
    defb 024h                  ;9c90 24  $ 
    defb 057h                  ;9c91 57  W 
    defb 040h                  ;9c92 40  @ 
    defb 014h                  ;9c93 14  . 
    defb 049h                  ;9c94 49  I 
    defb 0e9h                  ;9c95 e9  . 
    defb 057h                  ;9c96 57  W 
    defb 080h                  ;9c97 80  . 
    defb 022h                  ;9c98 22  " 
    defb 019h                  ;9c99 19  . 
    defb 028h                  ;9c9a 28  ( 
    defb 058h                  ;9c9b 58  X 
    defb 000h                  ;9c9c 00  . 
    defb 014h                  ;9c9d 14  . 
    defb 069h                  ;9c9e 69  i 
    defb 044h                  ;9c9f 44  D 
    defb 058h                  ;9ca0 58  X 
    defb 040h                  ;9ca1 40  @ 
    defb 00eh                  ;9ca2 0e  . 
    defb 06ch                  ;9ca3 6c  l 
    defb 08ch                  ;9ca4 8c  . 
    defb 058h                  ;9ca5 58  X 
    defb 080h                  ;9ca6 80  . 
    defb 022h                  ;9ca7 22  " 
    defb 021h                  ;9ca8 21  ! 
    defb 048h                  ;9ca9 48  H 
    defb 059h                  ;9caa 59  Y 
    defb 000h                  ;9cab 00  . 
    defb 014h                  ;9cac 14  . 
    defb 069h                  ;9cad 69  i 
    defb 064h                  ;9cae 64  d 
    defb 059h                  ;9caf 59  Y 
    defb 040h                  ;9cb0 40  @ 
    defb 047h                  ;9cb1 47  G 
    defb 021h                  ;9cb2 21  ! 
    defb 0ach                  ;9cb3 ac  . 
    defb 059h                  ;9cb4 59  Y 
    defb 080h                  ;9cb5 80  . 
    defb 022h                  ;9cb6 22  " 
    defb 021h                  ;9cb7 21  ! 
    defb 068h                  ;9cb8 68  h 
    defb 05ah                  ;9cb9 5a  Z 
    defb 000h                  ;9cba 00  . 
    defb 014h                  ;9cbb 14  . 
    defb 069h                  ;9cbc 69  i 
    defb 084h                  ;9cbd 84  . 
    defb 05ah                  ;9cbe 5a  Z 
    defb 040h                  ;9cbf 40  @ 
    defb 01ch                  ;9cc0 1c  . 
    defb 0c2h                  ;9cc1 c2  . 
    defb 0efh                  ;9cc2 ef  . 
    defb 05ah                  ;9cc3 5a  Z 
    defb 080h                  ;9cc4 80  . 
    defb 022h                  ;9cc5 22  " 
    defb 021h                  ;9cc6 21  ! 
    defb 088h                  ;9cc7 88  . 
    defb 05bh                  ;9cc8 5b  [ 
    defb 000h                  ;9cc9 00  . 
    defb 014h                  ;9cca 14  . 
    defb 069h                  ;9ccb 69  i 
    defb 0a4h                  ;9ccc a4  . 
    defb 05bh                  ;9ccd 5b  [ 
    defb 042h                  ;9cce 42  B 
    defb 014h                  ;9ccf 14  . 
    defb 0bdh                  ;9cd0 bd  . 
    defb 0b4h                  ;9cd1 b4  . 
    defb 05bh                  ;9cd2 5b  [ 
    defb 080h                  ;9cd3 80  . 
    defb 022h                  ;9cd4 22  " 
    defb 021h                  ;9cd5 21  ! 
    defb 0a8h                  ;9cd6 a8  . 
    defb 05ch                  ;9cd7 5c  \ 
    defb 000h                  ;9cd8 00  . 
    defb 014h                  ;9cd9 14  . 
    defb 069h                  ;9cda 69  i 
    defb 0c4h                  ;9cdb c4  . 
    defb 05ch                  ;9cdc 5c  \ 
    defb 020h                  ;9cdd 20    
    defb 014h                  ;9cde 14  . 
    defb 06bh                  ;9cdf 6b  k 
    defb 028h                  ;9ce0 28  ( 
    defb 05ch                  ;9ce1 5c  \ 
    defb 080h                  ;9ce2 80  . 
    defb 022h                  ;9ce3 22  " 
    defb 021h                  ;9ce4 21  ! 
    defb 0c8h                  ;9ce5 c8  . 
    defb 05dh                  ;9ce6 5d  ] 
    defb 000h                  ;9ce7 00  . 
    defb 014h                  ;9ce8 14  . 
    defb 06ah                  ;9ce9 6a  j 
    defb 004h                  ;9cea 04  . 
    defb 05dh                  ;9ceb 5d  ] 
    defb 020h                  ;9cec 20    
    defb 014h                  ;9ced 14  . 
    defb 06bh                  ;9cee 6b  k 
    defb 0a8h                  ;9cef a8  . 
    defb 05dh                  ;9cf0 5d  ] 
    defb 080h                  ;9cf1 80  . 
    defb 022h                  ;9cf2 22  " 
    defb 022h                  ;9cf3 22  " 
    defb 008h                  ;9cf4 08  . 
    defb 05eh                  ;9cf5 5e  ^ 
    defb 000h                  ;9cf6 00  . 
    defb 014h                  ;9cf7 14  . 
    defb 06dh                  ;9cf8 6d  m 
    defb 007h                  ;9cf9 07  . 
    defb 05eh                  ;9cfa 5e  ^ 
    defb 024h                  ;9cfb 24  $ 
    defb 014h                  ;9cfc 14  . 
    defb 06dh                  ;9cfd 6d  m 
    defb 0d3h                  ;9cfe d3  . 
    defb 05eh                  ;9cff 5e  ^ 
    defb 040h                  ;9d00 40  @ 
    defb 00ch                  ;9d01 0c  . 
    defb 018h                  ;9d02 18  . 
    defb 008h                  ;9d03 08  . 
    defb 05eh                  ;9d04 5e  ^ 
    defb 080h                  ;9d05 80  . 
    defb 022h                  ;9d06 22  " 
    defb 025h                  ;9d07 25  % 
    defb 00ch                  ;9d08 0c  . 
    defb 05eh                  ;9d09 5e  ^ 
    defb 0a4h                  ;9d0a a4  . 
    defb 022h                  ;9d0b 22  " 
    defb 025h                  ;9d0c 25  % 
    defb 0d4h                  ;9d0d d4  . 
    defb 05fh                  ;9d0e 5f  _ 
    defb 000h                  ;9d0f 00  . 
    defb 014h                  ;9d10 14  . 
    defb 069h                  ;9d11 69  i 
    defb 024h                  ;9d12 24  $ 
    defb 05fh                  ;9d13 5f  _ 
    defb 040h                  ;9d14 40  @ 
    defb 014h                  ;9d15 14  . 
    defb 04ah                  ;9d16 4a  J 
    defb 069h                  ;9d17 69  i 
    defb 05fh                  ;9d18 5f  _ 
    defb 080h                  ;9d19 80  . 
    defb 022h                  ;9d1a 22  " 
    defb 021h                  ;9d1b 21  ! 
    defb 028h                  ;9d1c 28  ( 
    defb 060h                  ;9d1d 60  ` 
    defb 000h                  ;9d1e 00  . 
    defb 014h                  ;9d1f 14  . 
    defb 071h                  ;9d20 71  q 
    defb 044h                  ;9d21 44  D 
    defb 060h                  ;9d22 60  ` 
    defb 020h                  ;9d23 20    
    defb 014h                  ;9d24 14  . 
    defb 0c9h                  ;9d25 c9  . 
    defb 048h                  ;9d26 48  H 
    defb 060h                  ;9d27 60  ` 
    defb 040h                  ;9d28 40  @ 
    defb 00eh                  ;9d29 0e  . 
    defb 074h                  ;9d2a 74  t 
    defb 08ch                  ;9d2b 8c  . 
    defb 060h                  ;9d2c 60  ` 
    defb 080h                  ;9d2d 80  . 
    defb 022h                  ;9d2e 22  " 
    defb 029h                  ;9d2f 29  ) 
    defb 048h                  ;9d30 48  H 
    defb 061h                  ;9d31 61  a 
    defb 000h                  ;9d32 00  . 
    defb 014h                  ;9d33 14  . 
    defb 071h                  ;9d34 71  q 
    defb 064h                  ;9d35 64  d 
    defb 061h                  ;9d36 61  a 
    defb 020h                  ;9d37 20    
    defb 014h                  ;9d38 14  . 
    defb 0c9h                  ;9d39 c9  . 
    defb 068h                  ;9d3a 68  h 
    defb 061h                  ;9d3b 61  a 
    defb 040h                  ;9d3c 40  @ 
    defb 047h                  ;9d3d 47  G 
    defb 021h                  ;9d3e 21  ! 
    defb 0cch                  ;9d3f cc  . 
    defb 061h                  ;9d40 61  a 
    defb 080h                  ;9d41 80  . 
    defb 022h                  ;9d42 22  " 
    defb 029h                  ;9d43 29  ) 
    defb 068h                  ;9d44 68  h 
    defb 062h                  ;9d45 62  b 
    defb 000h                  ;9d46 00  . 
    defb 014h                  ;9d47 14  . 
    defb 071h                  ;9d48 71  q 
    defb 084h                  ;9d49 84  . 
    defb 062h                  ;9d4a 62  b 
    defb 020h                  ;9d4b 20    
    defb 014h                  ;9d4c 14  . 
    defb 0c9h                  ;9d4d c9  . 
    defb 088h                  ;9d4e 88  . 
    defb 062h                  ;9d4f 62  b 
    defb 040h                  ;9d50 40  @ 
    defb 05eh                  ;9d51 5e  ^ 
    defb 0c3h                  ;9d52 c3  . 
    defb 00fh                  ;9d53 0f  . 
    defb 062h                  ;9d54 62  b 
    defb 080h                  ;9d55 80  . 
    defb 022h                  ;9d56 22  " 
    defb 029h                  ;9d57 29  ) 
    defb 088h                  ;9d58 88  . 
    defb 063h                  ;9d59 63  c 
    defb 000h                  ;9d5a 00  . 
    defb 014h                  ;9d5b 14  . 
    defb 071h                  ;9d5c 71  q 
    defb 0a4h                  ;9d5d a4  . 
    defb 063h                  ;9d5e 63  c 
    defb 020h                  ;9d5f 20    
    defb 014h                  ;9d60 14  . 
    defb 0c9h                  ;9d61 c9  . 
    defb 0a8h                  ;9d62 a8  . 
    defb 063h                  ;9d63 63  c 
    defb 042h                  ;9d64 42  B 
    defb 015h                  ;9d65 15  . 
    defb 06bh                  ;9d66 6b  k 
    defb 014h                  ;9d67 14  . 
    defb 063h                  ;9d68 63  c 
    defb 080h                  ;9d69 80  . 
    defb 022h                  ;9d6a 22  " 
    defb 029h                  ;9d6b 29  ) 
    defb 0a8h                  ;9d6c a8  . 
    defb 064h                  ;9d6d 64  d 
    defb 000h                  ;9d6e 00  . 
    defb 014h                  ;9d6f 14  . 
    defb 071h                  ;9d70 71  q 
    defb 0c4h                  ;9d71 c4  . 
    defb 064h                  ;9d72 64  d 
    defb 020h                  ;9d73 20    
    defb 014h                  ;9d74 14  . 
    defb 0cbh                  ;9d75 cb  . 
    defb 028h                  ;9d76 28  ( 
    defb 064h                  ;9d77 64  d 
    defb 080h                  ;9d78 80  . 
    defb 022h                  ;9d79 22  " 
    defb 029h                  ;9d7a 29  ) 
    defb 0c8h                  ;9d7b c8  . 
    defb 065h                  ;9d7c 65  e 
    defb 000h                  ;9d7d 00  . 
    defb 014h                  ;9d7e 14  . 
    defb 072h                  ;9d7f 72  r 
    defb 004h                  ;9d80 04  . 
    defb 065h                  ;9d81 65  e 
    defb 020h                  ;9d82 20    
    defb 014h                  ;9d83 14  . 
    defb 0cbh                  ;9d84 cb  . 
    defb 0a8h                  ;9d85 a8  . 
    defb 065h                  ;9d86 65  e 
    defb 080h                  ;9d87 80  . 
    defb 022h                  ;9d88 22  " 
    defb 02ah                  ;9d89 2a  * 
    defb 008h                  ;9d8a 08  . 
    defb 066h                  ;9d8b 66  f 
    defb 000h                  ;9d8c 00  . 
    defb 014h                  ;9d8d 14  . 
    defb 075h                  ;9d8e 75  u 
    defb 007h                  ;9d8f 07  . 
    defb 066h                  ;9d90 66  f 
    defb 024h                  ;9d91 24  $ 
    defb 014h                  ;9d92 14  . 
    defb 075h                  ;9d93 75  u 
    defb 0d3h                  ;9d94 d3  . 
    defb 066h                  ;9d95 66  f 
    defb 080h                  ;9d96 80  . 
    defb 022h                  ;9d97 22  " 
    defb 02dh                  ;9d98 2d  - 
    defb 00ch                  ;9d99 0c  . 
    defb 066h                  ;9d9a 66  f 
    defb 0a4h                  ;9d9b a4  . 
    defb 022h                  ;9d9c 22  " 
    defb 02dh                  ;9d9d 2d  - 
    defb 0d4h                  ;9d9e d4  . 
    defb 067h                  ;9d9f 67  g 
    defb 000h                  ;9da0 00  . 
    defb 014h                  ;9da1 14  . 
    defb 071h                  ;9da2 71  q 
    defb 024h                  ;9da3 24  $ 
    defb 067h                  ;9da4 67  g 
    defb 020h                  ;9da5 20    
    defb 014h                  ;9da6 14  . 
    defb 0c9h                  ;9da7 c9  . 
    defb 028h                  ;9da8 28  ( 
    defb 067h                  ;9da9 67  g 
    defb 040h                  ;9daa 40  @ 
    defb 05ah                  ;9dab 5a  Z 
    defb 000h                  ;9dac 00  . 
    defb 012h                  ;9dad 12  . 
    defb 067h                  ;9dae 67  g 
    defb 080h                  ;9daf 80  . 
    defb 022h                  ;9db0 22  " 
    defb 029h                  ;9db1 29  ) 
    defb 028h                  ;9db2 28  ( 
    defb 068h                  ;9db3 68  h 
    defb 000h                  ;9db4 00  . 
    defb 014h                  ;9db5 14  . 
    defb 081h                  ;9db6 81  . 
    defb 044h                  ;9db7 44  D 
    defb 068h                  ;9db8 68  h 
    defb 020h                  ;9db9 20    
    defb 014h                  ;9dba 14  . 
    defb 0e9h                  ;9dbb e9  . 
    defb 048h                  ;9dbc 48  H 
    defb 068h                  ;9dbd 68  h 
    defb 040h                  ;9dbe 40  @ 
    defb 00eh                  ;9dbf 0e  . 
    defb 084h                  ;9dc0 84  . 
    defb 08ch                  ;9dc1 8c  . 
    defb 068h                  ;9dc2 68  h 
    defb 080h                  ;9dc3 80  . 
    defb 022h                  ;9dc4 22  " 
    defb 031h                  ;9dc5 31  1 
    defb 048h                  ;9dc6 48  H 
    defb 069h                  ;9dc7 69  i 
    defb 000h                  ;9dc8 00  . 
    defb 014h                  ;9dc9 14  . 
    defb 081h                  ;9dca 81  . 
    defb 064h                  ;9dcb 64  d 
    defb 069h                  ;9dcc 69  i 
    defb 020h                  ;9dcd 20    
    defb 014h                  ;9dce 14  . 
    defb 0e9h                  ;9dcf e9  . 
    defb 068h                  ;9dd0 68  h 
    defb 069h                  ;9dd1 69  i 
    defb 040h                  ;9dd2 40  @ 
    defb 047h                  ;9dd3 47  G 
    defb 022h                  ;9dd4 22  " 
    defb 00ch                  ;9dd5 0c  . 
    defb 069h                  ;9dd6 69  i 
    defb 080h                  ;9dd7 80  . 
    defb 022h                  ;9dd8 22  " 
    defb 031h                  ;9dd9 31  1 
    defb 068h                  ;9dda 68  h 
    defb 06ah                  ;9ddb 6a  j 
    defb 000h                  ;9ddc 00  . 
    defb 014h                  ;9ddd 14  . 
    defb 081h                  ;9dde 81  . 
    defb 084h                  ;9ddf 84  . 
    defb 06ah                  ;9de0 6a  j 
    defb 020h                  ;9de1 20    
    defb 014h                  ;9de2 14  . 
    defb 0e9h                  ;9de3 e9  . 
    defb 088h                  ;9de4 88  . 
    defb 06ah                  ;9de5 6a  j 
    defb 040h                  ;9de6 40  @ 
    defb 01ch                  ;9de7 1c  . 
    defb 0c3h                  ;9de8 c3  . 
    defb 00fh                  ;9de9 0f  . 
    defb 06ah                  ;9dea 6a  j 
    defb 080h                  ;9deb 80  . 
    defb 022h                  ;9dec 22  " 
    defb 031h                  ;9ded 31  1 
    defb 088h                  ;9dee 88  . 
    defb 06bh                  ;9def 6b  k 
    defb 000h                  ;9df0 00  . 
    defb 014h                  ;9df1 14  . 
    defb 081h                  ;9df2 81  . 
    defb 0a4h                  ;9df3 a4  . 
    defb 06bh                  ;9df4 6b  k 
    defb 020h                  ;9df5 20    
    defb 014h                  ;9df6 14  . 
    defb 0e9h                  ;9df7 e9  . 
    defb 0a8h                  ;9df8 a8  . 
    defb 06bh                  ;9df9 6b  k 
    defb 042h                  ;9dfa 42  B 
    defb 014h                  ;9dfb 14  . 
    defb 0c5h                  ;9dfc c5  . 
    defb 0b4h                  ;9dfd b4  . 
    defb 06bh                  ;9dfe 6b  k 
    defb 080h                  ;9dff 80  . 
l9e00h:
    defb 022h                  ;9e00 22  " 
    defb 031h                  ;9e01 31  1 
    defb 0a8h                  ;9e02 a8  . 
    defb 06ch                  ;9e03 6c  l 
    defb 000h                  ;9e04 00  . 
    defb 014h                  ;9e05 14  . 
    defb 081h                  ;9e06 81  . 
    defb 0c4h                  ;9e07 c4  . 
    defb 06ch                  ;9e08 6c  l 
    defb 020h                  ;9e09 20    
    defb 014h                  ;9e0a 14  . 
    defb 0ebh                  ;9e0b eb  . 
    defb 028h                  ;9e0c 28  ( 
    defb 06ch                  ;9e0d 6c  l 
    defb 080h                  ;9e0e 80  . 
    defb 022h                  ;9e0f 22  " 
    defb 031h                  ;9e10 31  1 
    defb 0c8h                  ;9e11 c8  . 
    defb 06dh                  ;9e12 6d  m 
    defb 000h                  ;9e13 00  . 
    defb 014h                  ;9e14 14  . 
    defb 082h                  ;9e15 82  . 
    defb 004h                  ;9e16 04  . 
    defb 06dh                  ;9e17 6d  m 
    defb 020h                  ;9e18 20    
    defb 014h                  ;9e19 14  . 
    defb 0ebh                  ;9e1a eb  . 
    defb 0a8h                  ;9e1b a8  . 
    defb 06dh                  ;9e1c 6d  m 
    defb 080h                  ;9e1d 80  . 
    defb 022h                  ;9e1e 22  " 
    defb 032h                  ;9e1f 32  2 
    defb 008h                  ;9e20 08  . 
    defb 06eh                  ;9e21 6e  n 
    defb 000h                  ;9e22 00  . 
    defb 014h                  ;9e23 14  . 
    defb 085h                  ;9e24 85  . 
    defb 007h                  ;9e25 07  . 
    defb 06eh                  ;9e26 6e  n 
    defb 024h                  ;9e27 24  $ 
    defb 014h                  ;9e28 14  . 
    defb 085h                  ;9e29 85  . 
    defb 0d3h                  ;9e2a d3  . 
    defb 06eh                  ;9e2b 6e  n 
    defb 080h                  ;9e2c 80  . 
    defb 022h                  ;9e2d 22  " 
    defb 035h                  ;9e2e 35  5 
    defb 00ch                  ;9e2f 0c  . 
    defb 06eh                  ;9e30 6e  n 
    defb 0a4h                  ;9e31 a4  . 
    defb 022h                  ;9e32 22  " 
    defb 035h                  ;9e33 35  5 
    defb 0d4h                  ;9e34 d4  . 
    defb 06fh                  ;9e35 6f  o 
    defb 000h                  ;9e36 00  . 
    defb 014h                  ;9e37 14  . 
    defb 081h                  ;9e38 81  . 
    defb 024h                  ;9e39 24  $ 
    defb 06fh                  ;9e3a 6f  o 
    defb 020h                  ;9e3b 20    
    defb 014h                  ;9e3c 14  . 
    defb 0e9h                  ;9e3d e9  . 
    defb 028h                  ;9e3e 28  ( 
    defb 06fh                  ;9e3f 6f  o 
    defb 040h                  ;9e40 40  @ 
    defb 054h                  ;9e41 54  T 
    defb 000h                  ;9e42 00  . 
    defb 012h                  ;9e43 12  . 
    defb 06fh                  ;9e44 6f  o 
    defb 080h                  ;9e45 80  . 
    defb 022h                  ;9e46 22  " 
    defb 031h                  ;9e47 31  1 
    defb 028h                  ;9e48 28  ( 
    defb 070h                  ;9e49 70  p 
    defb 000h                  ;9e4a 00  . 
    defb 015h                  ;9e4b 15  . 
    defb 041h                  ;9e4c 41  A 
    defb 047h                  ;9e4d 47  G 
    defb 070h                  ;9e4e 70  p 
    defb 024h                  ;9e4f 24  $ 
    defb 015h                  ;9e50 15  . 
    defb 071h                  ;9e51 71  q 
    defb 053h                  ;9e52 53  S 
    defb 070h                  ;9e53 70  p 
    defb 080h                  ;9e54 80  . 
    defb 022h                  ;9e55 22  " 
    defb 039h                  ;9e56 39  9 
    defb 048h                  ;9e57 48  H 
    defb 071h                  ;9e58 71  q 
    defb 000h                  ;9e59 00  . 
    defb 015h                  ;9e5a 15  . 
    defb 041h                  ;9e5b 41  A 
    defb 067h                  ;9e5c 67  g 
    defb 071h                  ;9e5d 71  q 
    defb 024h                  ;9e5e 24  $ 
    defb 015h                  ;9e5f 15  . 
    defb 071h                  ;9e60 71  q 
    defb 073h                  ;9e61 73  s 
    defb 071h                  ;9e62 71  q 
    defb 080h                  ;9e63 80  . 
    defb 022h                  ;9e64 22  " 
    defb 039h                  ;9e65 39  9 
    defb 068h                  ;9e66 68  h 
    defb 072h                  ;9e67 72  r 
    defb 000h                  ;9e68 00  . 
    defb 015h                  ;9e69 15  . 
    defb 041h                  ;9e6a 41  A 
    defb 087h                  ;9e6b 87  . 
    defb 072h                  ;9e6c 72  r 
    defb 024h                  ;9e6d 24  $ 
    defb 015h                  ;9e6e 15  . 
    defb 071h                  ;9e6f 71  q 
    defb 093h                  ;9e70 93  . 
    defb 072h                  ;9e71 72  r 
    defb 040h                  ;9e72 40  @ 
    defb 05eh                  ;9e73 5e  ^ 
    defb 0c4h                  ;9e74 c4  . 
    defb 06fh                  ;9e75 6f  o 
    defb 072h                  ;9e76 72  r 
    defb 080h                  ;9e77 80  . 
    defb 022h                  ;9e78 22  " 
    defb 039h                  ;9e79 39  9 
    defb 088h                  ;9e7a 88  . 
    defb 073h                  ;9e7b 73  s 
    defb 000h                  ;9e7c 00  . 
    defb 015h                  ;9e7d 15  . 
    defb 041h                  ;9e7e 41  A 
    defb 0a7h                  ;9e7f a7  . 
    defb 073h                  ;9e80 73  s 
    defb 024h                  ;9e81 24  $ 
    defb 015h                  ;9e82 15  . 
    defb 071h                  ;9e83 71  q 
    defb 0b3h                  ;9e84 b3  . 
    defb 073h                  ;9e85 73  s 
    defb 042h                  ;9e86 42  B 
    defb 015h                  ;9e87 15  . 
    defb 06ch                  ;9e88 6c  l 
    defb 074h                  ;9e89 74  t 
v_l9556h:
    defb 073h                  ;9e8a 73  s 
    defb 080h                  ;9e8b 80  . 
    defb 022h                  ;9e8c 22  " 
    defb 039h                  ;9e8d 39  9 
    defb 0a8h                  ;9e8e a8  . 
    defb 074h                  ;9e8f 74  t 
    defb 000h                  ;9e90 00  . 
    defb 015h                  ;9e91 15  . 
    defb 041h                  ;9e92 41  A 
    defb 0c7h                  ;9e93 c7  . 
    defb 074h                  ;9e94 74  t 
    defb 024h                  ;9e95 24  $ 
    defb 015h                  ;9e96 15  . 
    defb 071h                  ;9e97 71  q 
    defb 0d3h                  ;9e98 d3  . 
    defb 074h                  ;9e99 74  t 
    defb 080h                  ;9e9a 80  . 
    defb 022h                  ;9e9b 22  " 
    defb 039h                  ;9e9c 39  9 
    defb 0c8h                  ;9e9d c8  . 
    defb 075h                  ;9e9e 75  u 
    defb 000h                  ;9e9f 00  . 
    defb 015h                  ;9ea0 15  . 
    defb 042h                  ;9ea1 42  B 
    defb 007h                  ;9ea2 07  . 
    defb 075h                  ;9ea3 75  u 
    defb 024h                  ;9ea4 24  $ 
    defb 015h                  ;9ea5 15  . 
    defb 072h                  ;9ea6 72  r 
    defb 013h                  ;9ea7 13  . 
    defb 075h                  ;9ea8 75  u 
    defb 080h                  ;9ea9 80  . 
    defb 022h                  ;9eaa 22  " 
    defb 03ah                  ;9eab 3a  : 
    defb 008h                  ;9eac 08  . 
    defb 076h                  ;9ead 76  v 
    defb 000h                  ;9eae 00  . 
    defb 07eh                  ;9eaf 7e  ~ 
    defb 000h                  ;9eb0 00  . 
    defb 004h                  ;9eb1 04  . 
    defb 076h                  ;9eb2 76  v 
    defb 080h                  ;9eb3 80  . 
    defb 022h                  ;9eb4 22  " 
    defb 03dh                  ;9eb5 3d  = 
    defb 00ch                  ;9eb6 0c  . 
    defb 076h                  ;9eb7 76  v 
    defb 0a4h                  ;9eb8 a4  . 
    defb 022h                  ;9eb9 22  " 
    defb 03dh                  ;9eba 3d  = 
    defb 0d4h                  ;9ebb d4  . 
    defb 077h                  ;9ebc 77  w 
    defb 000h                  ;9ebd 00  . 
    defb 015h                  ;9ebe 15  . 
    defb 041h                  ;9ebf 41  A 
    defb 027h                  ;9ec0 27  ' 
    defb 077h                  ;9ec1 77  w 
    defb 024h                  ;9ec2 24  $ 
    defb 015h                  ;9ec3 15  . 
    defb 071h                  ;9ec4 71  q 
    defb 033h                  ;9ec5 33  3 
    defb 077h                  ;9ec6 77  w 
    defb 080h                  ;9ec7 80  . 
    defb 022h                  ;9ec8 22  " 
    defb 039h                  ;9ec9 39  9 
    defb 028h                  ;9eca 28  ( 
    defb 078h                  ;9ecb 78  x 
    defb 000h                  ;9ecc 00  . 
    defb 014h                  ;9ecd 14  . 
    defb 049h                  ;9ece 49  I 
    defb 044h                  ;9ecf 44  D 
    defb 078h                  ;9ed0 78  x 
    defb 040h                  ;9ed1 40  @ 
    defb 00eh                  ;9ed2 0e  . 
    defb 04ch                  ;9ed3 4c  L 
    defb 08ch                  ;9ed4 8c  . 
    defb 078h                  ;9ed5 78  x 
    defb 080h                  ;9ed6 80  . 
    defb 022h                  ;9ed7 22  " 
    defb 041h                  ;9ed8 41  A 
    defb 048h                  ;9ed9 48  H 
    defb 079h                  ;9eda 79  y 
    defb 000h                  ;9edb 00  . 
    defb 014h                  ;9edc 14  . 
    defb 049h                  ;9edd 49  I 
    defb 064h                  ;9ede 64  d 
    defb 079h                  ;9edf 79  y 
    defb 040h                  ;9ee0 40  @ 
    defb 047h                  ;9ee1 47  G 
    defb 021h                  ;9ee2 21  ! 
    defb 02ch                  ;9ee3 2c  , 
    defb 079h                  ;9ee4 79  y 
    defb 080h                  ;9ee5 80  . 
    defb 022h                  ;9ee6 22  " 
    defb 041h                  ;9ee7 41  A 
    defb 068h                  ;9ee8 68  h 
    defb 07ah                  ;9ee9 7a  z 
    defb 000h                  ;9eea 00  . 
    defb 014h                  ;9eeb 14  . 
    defb 049h                  ;9eec 49  I 
    defb 084h                  ;9eed 84  . 
    defb 07ah                  ;9eee 7a  z 
    defb 040h                  ;9eef 40  @ 
    defb 01ch                  ;9ef0 1c  . 
    defb 0c4h                  ;9ef1 c4  . 
    defb 06fh                  ;9ef2 6f  o 
    defb 07ah                  ;9ef3 7a  z 
    defb 080h                  ;9ef4 80  . 
    defb 022h                  ;9ef5 22  " 
    defb 041h                  ;9ef6 41  A 
    defb 088h                  ;9ef7 88  . 
    defb 07bh                  ;9ef8 7b  { 
    defb 000h                  ;9ef9 00  . 
    defb 014h                  ;9efa 14  . 
    defb 049h                  ;9efb 49  I 
    defb 0a4h                  ;9efc a4  . 
    defb 07bh                  ;9efd 7b  { 
    defb 042h                  ;9efe 42  B 
    defb 015h                  ;9eff 15  . 
    defb 01dh                  ;9f00 1d  . 
    defb 0b4h                  ;9f01 b4  . 
    defb 07bh                  ;9f02 7b  { 
    defb 080h                  ;9f03 80  . 
    defb 022h                  ;9f04 22  " 
    defb 041h                  ;9f05 41  A 
    defb 0a8h                  ;9f06 a8  . 
    defb 07ch                  ;9f07 7c  | 
    defb 000h                  ;9f08 00  . 
    defb 014h                  ;9f09 14  . 
    defb 049h                  ;9f0a 49  I 
    defb 0c4h                  ;9f0b c4  . 
    defb 07ch                  ;9f0c 7c  | 
    defb 020h                  ;9f0d 20    
    defb 014h                  ;9f0e 14  . 
    defb 04bh                  ;9f0f 4b  K 
    defb 028h                  ;9f10 28  ( 
    defb 07ch                  ;9f11 7c  | 
    defb 080h                  ;9f12 80  . 
    defb 022h                  ;9f13 22  " 
    defb 041h                  ;9f14 41  A 
    defb 0c8h                  ;9f15 c8  . 
    defb 07dh                  ;9f16 7d  } 
    defb 000h                  ;9f17 00  . 
    defb 014h                  ;9f18 14  . 
    defb 04ah                  ;9f19 4a  J 
    defb 004h                  ;9f1a 04  . 
    defb 07dh                  ;9f1b 7d  } 
    defb 020h                  ;9f1c 20    
    defb 014h                  ;9f1d 14  . 
    defb 04bh                  ;9f1e 4b  K 
    defb 0a8h                  ;9f1f a8  . 
    defb 07dh                  ;9f20 7d  } 
    defb 080h                  ;9f21 80  . 
    defb 022h                  ;9f22 22  " 
    defb 042h                  ;9f23 42  B 
    defb 008h                  ;9f24 08  . 
    defb 07eh                  ;9f25 7e  ~ 
    defb 000h                  ;9f26 00  . 
    defb 014h                  ;9f27 14  . 
    defb 04dh                  ;9f28 4d  M 
    defb 007h                  ;9f29 07  . 
    defb 07eh                  ;9f2a 7e  ~ 
    defb 024h                  ;9f2b 24  $ 
    defb 014h                  ;9f2c 14  . 
    defb 04dh                  ;9f2d 4d  M 
    defb 0d3h                  ;9f2e d3  . 
    defb 07eh                  ;9f2f 7e  ~ 
    defb 080h                  ;9f30 80  . 
    defb 022h                  ;9f31 22  " 
    defb 045h                  ;9f32 45  E 
    defb 00ch                  ;9f33 0c  . 
    defb 07eh                  ;9f34 7e  ~ 
    defb 0a4h                  ;9f35 a4  . 
    defb 022h                  ;9f36 22  " 
    defb 045h                  ;9f37 45  E 
    defb 0d4h                  ;9f38 d4  . 
    defb 07fh                  ;9f39 7f   
    defb 000h                  ;9f3a 00  . 
    defb 014h                  ;9f3b 14  . 
    defb 049h                  ;9f3c 49  I 
    defb 024h                  ;9f3d 24  $ 
    defb 07fh                  ;9f3e 7f   
    defb 080h                  ;9f3f 80  . 
    defb 022h                  ;9f40 22  " 
    defb 041h                  ;9f41 41  A 
    defb 028h                  ;9f42 28  ( 
    defb 080h                  ;9f43 80  . 
    defb 000h                  ;9f44 00  . 
    defb 01eh                  ;9f45 1e  . 
    defb 049h                  ;9f46 49  I 
    defb 044h                  ;9f47 44  D 
    defb 080h                  ;9f48 80  . 
    defb 080h                  ;9f49 80  . 
    defb 04ch                  ;9f4a 4c  L 
    defb 009h                  ;9f4b 09  . 
    defb 048h                  ;9f4c 48  H 
    defb 081h                  ;9f4d 81  . 
    defb 000h                  ;9f4e 00  . 
    defb 01eh                  ;9f4f 1e  . 
    defb 049h                  ;9f50 49  I 
    defb 064h                  ;9f51 64  d 
    defb 081h                  ;9f52 81  . 
    defb 080h                  ;9f53 80  . 
    defb 04ch                  ;9f54 4c  L 
    defb 009h                  ;9f55 09  . 
    defb 068h                  ;9f56 68  h 
    defb 082h                  ;9f57 82  . 
    defb 000h                  ;9f58 00  . 
    defb 01eh                  ;9f59 1e  . 
    defb 049h                  ;9f5a 49  I 
    defb 084h                  ;9f5b 84  . 
    defb 082h                  ;9f5c 82  . 
    defb 080h                  ;9f5d 80  . 
    defb 04ch                  ;9f5e 4c  L 
    defb 009h                  ;9f5f 09  . 
    defb 088h                  ;9f60 88  . 
    defb 083h                  ;9f61 83  . 
    defb 000h                  ;9f62 00  . 
    defb 01eh                  ;9f63 1e  . 
    defb 049h                  ;9f64 49  I 
    defb 0a4h                  ;9f65 a4  . 
    defb 083h                  ;9f66 83  . 
    defb 080h                  ;9f67 80  . 
    defb 04ch                  ;9f68 4c  L 
    defb 009h                  ;9f69 09  . 
    defb 0a8h                  ;9f6a a8  . 
    defb 084h                  ;9f6b 84  . 
    defb 000h                  ;9f6c 00  . 
    defb 01eh                  ;9f6d 1e  . 
    defb 049h                  ;9f6e 49  I 
    defb 0c4h                  ;9f6f c4  . 
    defb 084h                  ;9f70 84  . 
    defb 020h                  ;9f71 20    
    defb 01eh                  ;9f72 1e  . 
    defb 04bh                  ;9f73 4b  K 
    defb 028h                  ;9f74 28  ( 
    defb 084h                  ;9f75 84  . 
    defb 080h                  ;9f76 80  . 
    defb 04ch                  ;9f77 4c  L 
    defb 009h                  ;9f78 09  . 
    defb 0c8h                  ;9f79 c8  . 
    defb 085h                  ;9f7a 85  . 
    defb 000h                  ;9f7b 00  . 
    defb 01eh                  ;9f7c 1e  . 
    defb 04ah                  ;9f7d 4a  J 
    defb 004h                  ;9f7e 04  . 
    defb 085h                  ;9f7f 85  . 
    defb 020h                  ;9f80 20    
    defb 01eh                  ;9f81 1e  . 
    defb 04bh                  ;9f82 4b  K 
    defb 0a8h                  ;9f83 a8  . 
    defb 085h                  ;9f84 85  . 
    defb 080h                  ;9f85 80  . 
    defb 04ch                  ;9f86 4c  L 
    defb 00ah                  ;9f87 0a  . 
    defb 008h                  ;9f88 08  . 
    defb 086h                  ;9f89 86  . 
    defb 000h                  ;9f8a 00  . 
    defb 01eh                  ;9f8b 1e  . 
    defb 04dh                  ;9f8c 4d  M 
    defb 007h                  ;9f8d 07  . 
    defb 086h                  ;9f8e 86  . 
    defb 024h                  ;9f8f 24  $ 
    defb 01eh                  ;9f90 1e  . 
    defb 04dh                  ;9f91 4d  M 
    defb 0d3h                  ;9f92 d3  . 
    defb 086h                  ;9f93 86  . 
    defb 080h                  ;9f94 80  . 
    defb 04ch                  ;9f95 4c  L 
    defb 00dh                  ;9f96 0d  . 
    defb 00fh                  ;9f97 0f  . 
    defb 086h                  ;9f98 86  . 
    defb 0a4h                  ;9f99 a4  . 
    defb 04ch                  ;9f9a 4c  L 
    defb 00dh                  ;9f9b 0d  . 
    defb 0d7h                  ;9f9c d7  . 
    defb 087h                  ;9f9d 87  . 
    defb 000h                  ;9f9e 00  . 
    defb 01eh                  ;9f9f 1e  . 
    defb 049h                  ;9fa0 49  I 
    defb 024h                  ;9fa1 24  $ 
    defb 087h                  ;9fa2 87  . 
    defb 080h                  ;9fa3 80  . 
    defb 04ch                  ;9fa4 4c  L 
    defb 009h                  ;9fa5 09  . 
    defb 028h                  ;9fa6 28  ( 
    defb 088h                  ;9fa7 88  . 
    defb 000h                  ;9fa8 00  . 
    defb 01ch                  ;9fa9 1c  . 
    defb 049h                  ;9faa 49  I 
    defb 044h                  ;9fab 44  D 
    defb 088h                  ;9fac 88  . 
    defb 080h                  ;9fad 80  . 
    defb 04ch                  ;9fae 4c  L 
    defb 011h                  ;9faf 11  . 
    defb 048h                  ;9fb0 48  H 
    defb 089h                  ;9fb1 89  . 
    defb 000h                  ;9fb2 00  . 
    defb 01ch                  ;9fb3 1c  . 
    defb 049h                  ;9fb4 49  I 
    defb 064h                  ;9fb5 64  d 
    defb 089h                  ;9fb6 89  . 
    defb 080h                  ;9fb7 80  . 
    defb 04ch                  ;9fb8 4c  L 
    defb 011h                  ;9fb9 11  . 
    defb 068h                  ;9fba 68  h 
    defb 08ah                  ;9fbb 8a  . 
    defb 000h                  ;9fbc 00  . 
    defb 01ch                  ;9fbd 1c  . 
    defb 049h                  ;9fbe 49  I 
    defb 084h                  ;9fbf 84  . 
    defb 08ah                  ;9fc0 8a  . 
    defb 080h                  ;9fc1 80  . 
    defb 04ch                  ;9fc2 4c  L 
    defb 011h                  ;9fc3 11  . 
    defb 088h                  ;9fc4 88  . 
    defb 08bh                  ;9fc5 8b  . 
    defb 000h                  ;9fc6 00  . 
    defb 01ch                  ;9fc7 1c  . 
    defb 049h                  ;9fc8 49  I 
    defb 0a4h                  ;9fc9 a4  . 
    defb 08bh                  ;9fca 8b  . 
    defb 080h                  ;9fcb 80  . 
    defb 04ch                  ;9fcc 4c  L 
    defb 011h                  ;9fcd 11  . 
    defb 0a8h                  ;9fce a8  . 
    defb 08ch                  ;9fcf 8c  . 
    defb 000h                  ;9fd0 00  . 
    defb 01ch                  ;9fd1 1c  . 
    defb 049h                  ;9fd2 49  I 
    defb 0c4h                  ;9fd3 c4  . 
    defb 08ch                  ;9fd4 8c  . 
    defb 020h                  ;9fd5 20    
    defb 01ch                  ;9fd6 1c  . 
    defb 04bh                  ;9fd7 4b  K 
    defb 028h                  ;9fd8 28  ( 
    defb 08ch                  ;9fd9 8c  . 
    defb 080h                  ;9fda 80  . 
    defb 04ch                  ;9fdb 4c  L 
    defb 011h                  ;9fdc 11  . 
    defb 0c8h                  ;9fdd c8  . 
    defb 08dh                  ;9fde 8d  . 
    defb 000h                  ;9fdf 00  . 
    defb 01ch                  ;9fe0 1c  . 
    defb 04ah                  ;9fe1 4a  J 
    defb 004h                  ;9fe2 04  . 
    defb 08dh                  ;9fe3 8d  . 
    defb 020h                  ;9fe4 20    
    defb 01ch                  ;9fe5 1c  . 
    defb 04bh                  ;9fe6 4b  K 
    defb 0a8h                  ;9fe7 a8  . 
    defb 08dh                  ;9fe8 8d  . 
    defb 080h                  ;9fe9 80  . 
    defb 04ch                  ;9fea 4c  L 
    defb 012h                  ;9feb 12  . 
    defb 008h                  ;9fec 08  . 
    defb 08eh                  ;9fed 8e  . 
    defb 000h                  ;9fee 00  . 
    defb 01ch                  ;9fef 1c  . 
    defb 04dh                  ;9ff0 4d  M 
    defb 007h                  ;9ff1 07  . 
    defb 08eh                  ;9ff2 8e  . 
    defb 024h                  ;9ff3 24  $ 
    defb 01ch                  ;9ff4 1c  . 
    defb 04dh                  ;9ff5 4d  M 
    defb 0d3h                  ;9ff6 d3  . 
    defb 08eh                  ;9ff7 8e  . 
    defb 080h                  ;9ff8 80  . 
    defb 04ch                  ;9ff9 4c  L 
    defb 015h                  ;9ffa 15  . 
    defb 00fh                  ;9ffb 0f  . 
    defb 08eh                  ;9ffc 8e  . 
    defb 0a4h                  ;9ffd a4  . 
    defb 04ch                  ;9ffe 4c  L 
    defb 015h                  ;9fff 15  . 
    defb 0d7h                  ;a000 d7  . 
    defb 08fh                  ;a001 8f  . 
    defb 000h                  ;a002 00  . 
    defb 01ch                  ;a003 1c  . 
    defb 049h                  ;a004 49  I 
    defb 024h                  ;a005 24  $ 
    defb 08fh                  ;a006 8f  . 
    defb 080h                  ;a007 80  . 
    defb 04ch                  ;a008 4c  L 
    defb 011h                  ;a009 11  . 
    defb 028h                  ;a00a 28  ( 
    defb 090h                  ;a00b 90  . 
    defb 000h                  ;a00c 00  . 
    defb 06ah                  ;a00d 6a  j 
    defb 050h                  ;a00e 50  P 
    defb 004h                  ;a00f 04  . 
    defb 090h                  ;a010 90  . 
    defb 080h                  ;a011 80  . 
    defb 04ch                  ;a012 4c  L 
    defb 019h                  ;a013 19  . 
    defb 048h                  ;a014 48  H 
    defb 091h                  ;a015 91  . 
    defb 000h                  ;a016 00  . 
    defb 06ah                  ;a017 6a  j 
    defb 058h                  ;a018 58  X 
    defb 004h                  ;a019 04  . 
    defb 091h                  ;a01a 91  . 
    defb 080h                  ;a01b 80  . 
    defb 04ch                  ;a01c 4c  L 
    defb 019h                  ;a01d 19  . 
    defb 068h                  ;a01e 68  h 
    defb 092h                  ;a01f 92  . 
    defb 000h                  ;a020 00  . 
    defb 06ah                  ;a021 6a  j 
    defb 060h                  ;a022 60  ` 
    defb 004h                  ;a023 04  . 
    defb 092h                  ;a024 92  . 
    defb 080h                  ;a025 80  . 
    defb 04ch                  ;a026 4c  L 
    defb 019h                  ;a027 19  . 
    defb 088h                  ;a028 88  . 
    defb 093h                  ;a029 93  . 
    defb 000h                  ;a02a 00  . 
    defb 06ah                  ;a02b 6a  j 
    defb 068h                  ;a02c 68  h 
    defb 004h                  ;a02d 04  . 
    defb 093h                  ;a02e 93  . 
    defb 080h                  ;a02f 80  . 
    defb 04ch                  ;a030 4c  L 
    defb 019h                  ;a031 19  . 
    defb 0a8h                  ;a032 a8  . 
    defb 094h                  ;a033 94  . 
    defb 000h                  ;a034 00  . 
    defb 06ah                  ;a035 6a  j 
    defb 070h                  ;a036 70  p 
    defb 004h                  ;a037 04  . 
    defb 094h                  ;a038 94  . 
    defb 020h                  ;a039 20    
    defb 06ah                  ;a03a 6a  j 
    defb 0c8h                  ;a03b c8  . 
    defb 008h                  ;a03c 08  . 
    defb 094h                  ;a03d 94  . 
    defb 080h                  ;a03e 80  . 
    defb 04ch                  ;a03f 4c  L 
    defb 019h                  ;a040 19  . 
    defb 0c8h                  ;a041 c8  . 
    defb 095h                  ;a042 95  . 
    defb 000h                  ;a043 00  . 
    defb 06ah                  ;a044 6a  j 
    defb 080h                  ;a045 80  . 
    defb 004h                  ;a046 04  . 
    defb 095h                  ;a047 95  . 
    defb 020h                  ;a048 20    
    defb 06ah                  ;a049 6a  j 
    defb 0e8h                  ;a04a e8  . 
    defb 008h                  ;a04b 08  . 
    defb 095h                  ;a04c 95  . 
    defb 080h                  ;a04d 80  . 
    defb 04ch                  ;a04e 4c  L 
    defb 01ah                  ;a04f 1a  . 
    defb 008h                  ;a050 08  . 
    defb 096h                  ;a051 96  . 
    defb 000h                  ;a052 00  . 
    defb 06bh                  ;a053 6b  k 
    defb 040h                  ;a054 40  @ 
    defb 007h                  ;a055 07  . 
    defb 096h                  ;a056 96  . 
    defb 024h                  ;a057 24  $ 
    defb 06bh                  ;a058 6b  k 
    defb 070h                  ;a059 70  p 
    defb 013h                  ;a05a 13  . 
    defb 096h                  ;a05b 96  . 
    defb 080h                  ;a05c 80  . 
    defb 04ch                  ;a05d 4c  L 
    defb 01dh                  ;a05e 1d  . 
    defb 00fh                  ;a05f 0f  . 
    defb 096h                  ;a060 96  . 
    defb 0a4h                  ;a061 a4  . 
    defb 04ch                  ;a062 4c  L 
    defb 01dh                  ;a063 1d  . 
    defb 0d7h                  ;a064 d7  . 
    defb 097h                  ;a065 97  . 
    defb 000h                  ;a066 00  . 
    defb 06ah                  ;a067 6a  j 
    defb 048h                  ;a068 48  H 
    defb 004h                  ;a069 04  . 
    defb 097h                  ;a06a 97  . 
    defb 080h                  ;a06b 80  . 
    defb 04ch                  ;a06c 4c  L 
    defb 019h                  ;a06d 19  . 
    defb 028h                  ;a06e 28  ( 
    defb 098h                  ;a06f 98  . 
    defb 000h                  ;a070 00  . 
    defb 05eh                  ;a071 5e  ^ 
    defb 049h                  ;a072 49  I 
    defb 044h                  ;a073 44  D 
    defb 098h                  ;a074 98  . 
    defb 080h                  ;a075 80  . 
    defb 04ch                  ;a076 4c  L 
    defb 021h                  ;a077 21  ! 
    defb 048h                  ;a078 48  H 
    defb 099h                  ;a079 99  . 
    defb 000h                  ;a07a 00  . 
    defb 05eh                  ;a07b 5e  ^ 
    defb 049h                  ;a07c 49  I 
    defb 064h                  ;a07d 64  d 
    defb 099h                  ;a07e 99  . 
    defb 080h                  ;a07f 80  . 
    defb 04ch                  ;a080 4c  L 
    defb 021h                  ;a081 21  ! 
    defb 068h                  ;a082 68  h 
    defb 09ah                  ;a083 9a  . 
    defb 000h                  ;a084 00  . 
    defb 05eh                  ;a085 5e  ^ 
    defb 049h                  ;a086 49  I 
    defb 084h                  ;a087 84  . 
    defb 09ah                  ;a088 9a  . 
    defb 080h                  ;a089 80  . 
    defb 04ch                  ;a08a 4c  L 
    defb 021h                  ;a08b 21  ! 
    defb 088h                  ;a08c 88  . 
    defb 09bh                  ;a08d 9b  . 
    defb 000h                  ;a08e 00  . 
    defb 05eh                  ;a08f 5e  ^ 
    defb 049h                  ;a090 49  I 
    defb 0a4h                  ;a091 a4  . 
    defb 09bh                  ;a092 9b  . 
    defb 080h                  ;a093 80  . 
    defb 04ch                  ;a094 4c  L 
    defb 021h                  ;a095 21  ! 
    defb 0a8h                  ;a096 a8  . 
    defb 09ch                  ;a097 9c  . 
    defb 000h                  ;a098 00  . 
    defb 05eh                  ;a099 5e  ^ 
    defb 049h                  ;a09a 49  I 
    defb 0c4h                  ;a09b c4  . 
    defb 09ch                  ;a09c 9c  . 
    defb 020h                  ;a09d 20    
    defb 05eh                  ;a09e 5e  ^ 
    defb 04bh                  ;a09f 4b  K 
    defb 028h                  ;a0a0 28  ( 
    defb 09ch                  ;a0a1 9c  . 
    defb 080h                  ;a0a2 80  . 
    defb 04ch                  ;a0a3 4c  L 
    defb 021h                  ;a0a4 21  ! 
    defb 0c8h                  ;a0a5 c8  . 
    defb 09dh                  ;a0a6 9d  . 
    defb 000h                  ;a0a7 00  . 
    defb 05eh                  ;a0a8 5e  ^ 
    defb 04ah                  ;a0a9 4a  J 
    defb 004h                  ;a0aa 04  . 
    defb 09dh                  ;a0ab 9d  . 
    defb 020h                  ;a0ac 20    
    defb 05eh                  ;a0ad 5e  ^ 
    defb 04bh                  ;a0ae 4b  K 
    defb 0a8h                  ;a0af a8  . 
    defb 09dh                  ;a0b0 9d  . 
    defb 080h                  ;a0b1 80  . 
    defb 04ch                  ;a0b2 4c  L 
    defb 022h                  ;a0b3 22  " 
    defb 008h                  ;a0b4 08  . 
    defb 09eh                  ;a0b5 9e  . 
    defb 000h                  ;a0b6 00  . 
    defb 05eh                  ;a0b7 5e  ^ 
    defb 04dh                  ;a0b8 4d  M 
    defb 007h                  ;a0b9 07  . 
    defb 09eh                  ;a0ba 9e  . 
    defb 024h                  ;a0bb 24  $ 
    defb 05eh                  ;a0bc 5e  ^ 
    defb 04dh                  ;a0bd 4d  M 
    defb 0d3h                  ;a0be d3  . 
    defb 09eh                  ;a0bf 9e  . 
    defb 080h                  ;a0c0 80  . 
    defb 04ch                  ;a0c1 4c  L 
    defb 025h                  ;a0c2 25  % 
    defb 00fh                  ;a0c3 0f  . 
    defb 09eh                  ;a0c4 9e  . 
    defb 0a4h                  ;a0c5 a4  . 
    defb 04ch                  ;a0c6 4c  L 
    defb 025h                  ;a0c7 25  % 
    defb 0d7h                  ;a0c8 d7  . 
    defb 09fh                  ;a0c9 9f  . 
    defb 000h                  ;a0ca 00  . 
    defb 05eh                  ;a0cb 5e  ^ 
    defb 049h                  ;a0cc 49  I 
    defb 024h                  ;a0cd 24  $ 
    defb 09fh                  ;a0ce 9f  . 
    defb 080h                  ;a0cf 80  . 
    defb 04ch                  ;a0d0 4c  L 
    defb 021h                  ;a0d1 21  ! 
    defb 028h                  ;a0d2 28  ( 
    defb 0a0h                  ;a0d3 a0  . 
    defb 000h                  ;a0d4 00  . 
    defb 020h                  ;a0d5 20    
    defb 050h                  ;a0d6 50  P 
    defb 004h                  ;a0d7 04  . 
    defb 0a0h                  ;a0d8 a0  . 
    defb 040h                  ;a0d9 40  @ 
    defb 03eh                  ;a0da 3e  > 
    defb 000h                  ;a0db 00  . 
    defb 010h                  ;a0dc 10  . 
    defb 0a0h                  ;a0dd a0  . 
    defb 080h                  ;a0de 80  . 
    defb 04ch                  ;a0df 4c  L 
    defb 029h                  ;a0e0 29  ) 
    defb 048h                  ;a0e1 48  H 
    defb 0a1h                  ;a0e2 a1  . 
    defb 000h                  ;a0e3 00  . 
    defb 020h                  ;a0e4 20    
    defb 058h                  ;a0e5 58  X 
    defb 004h                  ;a0e6 04  . 
    defb 0a1h                  ;a0e7 a1  . 
    defb 040h                  ;a0e8 40  @ 
    defb 028h                  ;a0e9 28  ( 
    defb 000h                  ;a0ea 00  . 
    defb 010h                  ;a0eb 10  . 
    defb 0a1h                  ;a0ec a1  . 
    defb 080h                  ;a0ed 80  . 
    defb 04ch                  ;a0ee 4c  L 
    defb 029h                  ;a0ef 29  ) 
    defb 068h                  ;a0f0 68  h 
    defb 0a2h                  ;a0f1 a2  . 
    defb 000h                  ;a0f2 00  . 
    defb 020h                  ;a0f3 20    
    defb 060h                  ;a0f4 60  ` 
    defb 004h                  ;a0f5 04  . 
    defb 0a2h                  ;a0f6 a2  . 
    defb 040h                  ;a0f7 40  @ 
    defb 03ah                  ;a0f8 3a  : 
    defb 000h                  ;a0f9 00  . 
    defb 010h                  ;a0fa 10  . 
    defb 0a2h                  ;a0fb a2  . 
    defb 080h                  ;a0fc 80  . 
    defb 04ch                  ;a0fd 4c  L 
    defb 029h                  ;a0fe 29  ) 
    defb 088h                  ;a0ff 88  . 
    defb 0a3h                  ;a100 a3  . 
    defb 000h                  ;a101 00  . 
    defb 020h                  ;a102 20    
    defb 068h                  ;a103 68  h 
    defb 004h                  ;a104 04  . 
    defb 0a3h                  ;a105 a3  . 
    defb 040h                  ;a106 40  @ 
    defb 08eh                  ;a107 8e  . 
    defb 000h                  ;a108 00  . 
    defb 010h                  ;a109 10  . 
    defb 0a3h                  ;a10a a3  . 
    defb 080h                  ;a10b 80  . 
    defb 04ch                  ;a10c 4c  L 
    defb 029h                  ;a10d 29  ) 
    defb 0a8h                  ;a10e a8  . 
    defb 0a4h                  ;a10f a4  . 
    defb 000h                  ;a110 00  . 
    defb 020h                  ;a111 20    
    defb 070h                  ;a112 70  p 
    defb 004h                  ;a113 04  . 
    defb 0a4h                  ;a114 a4  . 
    defb 020h                  ;a115 20    
    defb 020h                  ;a116 20    
    defb 0c8h                  ;a117 c8  . 
    defb 008h                  ;a118 08  . 
    defb 0a4h                  ;a119 a4  . 
    defb 080h                  ;a11a 80  . 
    defb 04ch                  ;a11b 4c  L 
    defb 029h                  ;a11c 29  ) 
    defb 0c8h                  ;a11d c8  . 
    defb 0a5h                  ;a11e a5  . 
    defb 000h                  ;a11f 00  . 
    defb 020h                  ;a120 20    
    defb 080h                  ;a121 80  . 
    defb 004h                  ;a122 04  . 
    defb 0a5h                  ;a123 a5  . 
    defb 020h                  ;a124 20    
    defb 020h                  ;a125 20    
    defb 0e8h                  ;a126 e8  . 
    defb 008h                  ;a127 08  . 
    defb 0a5h                  ;a128 a5  . 
    defb 080h                  ;a129 80  . 
    defb 04ch                  ;a12a 4c  L 
    defb 02ah                  ;a12b 2a  * 
    defb 008h                  ;a12c 08  . 
    defb 0a6h                  ;a12d a6  . 
    defb 000h                  ;a12e 00  . 
    defb 021h                  ;a12f 21  ! 
    defb 040h                  ;a130 40  @ 
    defb 007h                  ;a131 07  . 
    defb 0a6h                  ;a132 a6  . 
    defb 024h                  ;a133 24  $ 
    defb 021h                  ;a134 21  ! 
    defb 070h                  ;a135 70  p 
    defb 013h                  ;a136 13  . 
    defb 0a6h                  ;a137 a6  . 
    defb 080h                  ;a138 80  . 
    defb 04ch                  ;a139 4c  L 
    defb 02dh                  ;a13a 2d  - 
    defb 00fh                  ;a13b 0f  . 
    defb 0a6h                  ;a13c a6  . 
    defb 0a4h                  ;a13d a4  . 
    defb 04ch                  ;a13e 4c  L 
    defb 02dh                  ;a13f 2d  - 
    defb 0d7h                  ;a140 d7  . 
    defb 0a7h                  ;a141 a7  . 
    defb 000h                  ;a142 00  . 
    defb 020h                  ;a143 20    
    defb 048h                  ;a144 48  H 
    defb 004h                  ;a145 04  . 
    defb 0a7h                  ;a146 a7  . 
    defb 080h                  ;a147 80  . 
    defb 04ch                  ;a148 4c  L 
    defb 029h                  ;a149 29  ) 
    defb 028h                  ;a14a 28  ( 
    defb 0a8h                  ;a14b a8  . 
    defb 000h                  ;a14c 00  . 
    defb 06ch                  ;a14d 6c  l 
    defb 050h                  ;a14e 50  P 
    defb 004h                  ;a14f 04  . 
    defb 0a8h                  ;a150 a8  . 
    defb 040h                  ;a151 40  @ 
    defb 03ch                  ;a152 3c  < 
    defb 000h                  ;a153 00  . 
    defb 010h                  ;a154 10  . 
    defb 0a8h                  ;a155 a8  . 
    defb 080h                  ;a156 80  . 
    defb 04ch                  ;a157 4c  L 
    defb 031h                  ;a158 31  1 
    defb 048h                  ;a159 48  H 
    defb 0a9h                  ;a15a a9  . 
    defb 000h                  ;a15b 00  . 
    defb 06ch                  ;a15c 6c  l 
    defb 058h                  ;a15d 58  X 
    defb 004h                  ;a15e 04  . 
    defb 0a9h                  ;a15f a9  . 
    defb 040h                  ;a160 40  @ 
    defb 026h                  ;a161 26  & 
    defb 000h                  ;a162 00  . 
    defb 010h                  ;a163 10  . 
    defb 0a9h                  ;a164 a9  . 
    defb 080h                  ;a165 80  . 
    defb 04ch                  ;a166 4c  L 
    defb 031h                  ;a167 31  1 
    defb 068h                  ;a168 68  h 
    defb 0aah                  ;a169 aa  . 
    defb 000h                  ;a16a 00  . 
    defb 06ch                  ;a16b 6c  l 
    defb 060h                  ;a16c 60  ` 
    defb 004h                  ;a16d 04  . 
    defb 0aah                  ;a16e aa  . 
    defb 040h                  ;a16f 40  @ 
    defb 038h                  ;a170 38  8 
    defb 000h                  ;a171 00  . 
    defb 010h                  ;a172 10  . 
    defb 0aah                  ;a173 aa  . 
    defb 080h                  ;a174 80  . 
    defb 04ch                  ;a175 4c  L 
    defb 031h                  ;a176 31  1 
    defb 088h                  ;a177 88  . 
    defb 0abh                  ;a178 ab  . 
    defb 000h                  ;a179 00  . 
    defb 06ch                  ;a17a 6c  l 
    defb 068h                  ;a17b 68  h 
    defb 004h                  ;a17c 04  . 
    defb 0abh                  ;a17d ab  . 
    defb 040h                  ;a17e 40  @ 
    defb 08ch                  ;a17f 8c  . 
    defb 000h                  ;a180 00  . 
    defb 010h                  ;a181 10  . 
    defb 0abh                  ;a182 ab  . 
    defb 080h                  ;a183 80  . 
    defb 04ch                  ;a184 4c  L 
    defb 031h                  ;a185 31  1 
    defb 0a8h                  ;a186 a8  . 
    defb 0ach                  ;a187 ac  . 
    defb 000h                  ;a188 00  . 
    defb 06ch                  ;a189 6c  l 
    defb 070h                  ;a18a 70  p 
    defb 004h                  ;a18b 04  . 
    defb 0ach                  ;a18c ac  . 
    defb 020h                  ;a18d 20    
    defb 06ch                  ;a18e 6c  l 
    defb 0c8h                  ;a18f c8  . 
    defb 008h                  ;a190 08  . 
    defb 0ach                  ;a191 ac  . 
    defb 080h                  ;a192 80  . 
    defb 04ch                  ;a193 4c  L 
    defb 031h                  ;a194 31  1 
    defb 0c8h                  ;a195 c8  . 
    defb 0adh                  ;a196 ad  . 
    defb 000h                  ;a197 00  . 
    defb 06ch                  ;a198 6c  l 
    defb 080h                  ;a199 80  . 
    defb 004h                  ;a19a 04  . 
    defb 0adh                  ;a19b ad  . 
    defb 020h                  ;a19c 20    
    defb 06ch                  ;a19d 6c  l 
    defb 0e8h                  ;a19e e8  . 
    defb 008h                  ;a19f 08  . 
    defb 0adh                  ;a1a0 ad  . 
    defb 080h                  ;a1a1 80  . 
    defb 04ch                  ;a1a2 4c  L 
    defb 032h                  ;a1a3 32  2 
    defb 008h                  ;a1a4 08  . 
    defb 0aeh                  ;a1a5 ae  . 
    defb 000h                  ;a1a6 00  . 
    defb 06dh                  ;a1a7 6d  m 
    defb 040h                  ;a1a8 40  @ 
    defb 007h                  ;a1a9 07  . 
    defb 0aeh                  ;a1aa ae  . 
    defb 024h                  ;a1ab 24  $ 
    defb 06dh                  ;a1ac 6d  m 
    defb 070h                  ;a1ad 70  p 
    defb 013h                  ;a1ae 13  . 
    defb 0aeh                  ;a1af ae  . 
    defb 080h                  ;a1b0 80  . 
    defb 04ch                  ;a1b1 4c  L 
    defb 035h                  ;a1b2 35  5 
    defb 00fh                  ;a1b3 0f  . 
    defb 0aeh                  ;a1b4 ae  . 
    defb 0a4h                  ;a1b5 a4  . 
    defb 04ch                  ;a1b6 4c  L 
    defb 035h                  ;a1b7 35  5 
    defb 0d7h                  ;a1b8 d7  . 
    defb 0afh                  ;a1b9 af  . 
    defb 000h                  ;a1ba 00  . 
    defb 06ch                  ;a1bb 6c  l 
    defb 048h                  ;a1bc 48  H 
    defb 004h                  ;a1bd 04  . 
    defb 0afh                  ;a1be af  . 
    defb 080h                  ;a1bf 80  . 
    defb 04ch                  ;a1c0 4c  L 
    defb 031h                  ;a1c1 31  1 
    defb 028h                  ;a1c2 28  ( 
    defb 0b0h                  ;a1c3 b0  . 
    defb 000h                  ;a1c4 00  . 
    defb 016h                  ;a1c5 16  . 
    defb 050h                  ;a1c6 50  P 
    defb 004h                  ;a1c7 04  . 
    defb 0b0h                  ;a1c8 b0  . 
    defb 040h                  ;a1c9 40  @ 
    defb 086h                  ;a1ca 86  . 
    defb 000h                  ;a1cb 00  . 
    defb 015h                  ;a1cc 15  . 
    defb 0b0h                  ;a1cd b0  . 
    defb 080h                  ;a1ce 80  . 
    defb 04ch                  ;a1cf 4c  L 
    defb 039h                  ;a1d0 39  9 
    defb 048h                  ;a1d1 48  H 
    defb 0b1h                  ;a1d2 b1  . 
    defb 000h                  ;a1d3 00  . 
    defb 016h                  ;a1d4 16  . 
    defb 058h                  ;a1d5 58  X 
    defb 004h                  ;a1d6 04  . 
    defb 0b1h                  ;a1d7 b1  . 
    defb 040h                  ;a1d8 40  @ 
    defb 072h                  ;a1d9 72  r 
    defb 000h                  ;a1da 00  . 
    defb 015h                  ;a1db 15  . 
    defb 0b1h                  ;a1dc b1  . 
    defb 080h                  ;a1dd 80  . 
    defb 04ch                  ;a1de 4c  L 
    defb 039h                  ;a1df 39  9 
    defb 068h                  ;a1e0 68  h 
    defb 0b2h                  ;a1e1 b2  . 
    defb 000h                  ;a1e2 00  . 
    defb 016h                  ;a1e3 16  . 
    defb 060h                  ;a1e4 60  ` 
    defb 004h                  ;a1e5 04  . 
    defb 0b2h                  ;a1e6 b2  . 
    defb 040h                  ;a1e7 40  @ 
    defb 082h                  ;a1e8 82  . 
    defb 000h                  ;a1e9 00  . 
    defb 015h                  ;a1ea 15  . 
    defb 0b2h                  ;a1eb b2  . 
    defb 080h                  ;a1ec 80  . 
    defb 04ch                  ;a1ed 4c  L 
    defb 039h                  ;a1ee 39  9 
    defb 088h                  ;a1ef 88  . 
    defb 0b3h                  ;a1f0 b3  . 
    defb 000h                  ;a1f1 00  . 
    defb 016h                  ;a1f2 16  . 
    defb 068h                  ;a1f3 68  h 
    defb 004h                  ;a1f4 04  . 
    defb 0b3h                  ;a1f5 b3  . 
    defb 040h                  ;a1f6 40  @ 
    defb 08ah                  ;a1f7 8a  . 
    defb 000h                  ;a1f8 00  . 
    defb 015h                  ;a1f9 15  . 
    defb 0b3h                  ;a1fa b3  . 
    defb 080h                  ;a1fb 80  . 
    defb 04ch                  ;a1fc 4c  L 
    defb 039h                  ;a1fd 39  9 
    defb 0a8h                  ;a1fe a8  . 
    defb 0b4h                  ;a1ff b4  . 
    defb 000h                  ;a200 00  . 
    defb 016h                  ;a201 16  . 
    defb 070h                  ;a202 70  p 
    defb 004h                  ;a203 04  . 
    defb 0b4h                  ;a204 b4  . 
    defb 020h                  ;a205 20    
    defb 016h                  ;a206 16  . 
    defb 0c8h                  ;a207 c8  . 
    defb 008h                  ;a208 08  . 
    defb 0b4h                  ;a209 b4  . 
    defb 080h                  ;a20a 80  . 
    defb 04ch                  ;a20b 4c  L 
    defb 039h                  ;a20c 39  9 
    defb 0c8h                  ;a20d c8  . 
    defb 0b5h                  ;a20e b5  . 
    defb 000h                  ;a20f 00  . 
    defb 016h                  ;a210 16  . 
    defb 080h                  ;a211 80  . 
    defb 004h                  ;a212 04  . 
    defb 0b5h                  ;a213 b5  . 
    defb 020h                  ;a214 20    
    defb 016h                  ;a215 16  . 
    defb 0e8h                  ;a216 e8  . 
    defb 008h                  ;a217 08  . 
    defb 0b5h                  ;a218 b5  . 
    defb 080h                  ;a219 80  . 
    defb 04ch                  ;a21a 4c  L 
    defb 03ah                  ;a21b 3a  : 
    defb 008h                  ;a21c 08  . 
    defb 0b6h                  ;a21d b6  . 
    defb 000h                  ;a21e 00  . 
    defb 017h                  ;a21f 17  . 
    defb 040h                  ;a220 40  @ 
    defb 007h                  ;a221 07  . 
    defb 0b6h                  ;a222 b6  . 
    defb 024h                  ;a223 24  $ 
    defb 017h                  ;a224 17  . 
    defb 070h                  ;a225 70  p 
    defb 013h                  ;a226 13  . 
    defb 0b6h                  ;a227 b6  . 
    defb 080h                  ;a228 80  . 
    defb 04ch                  ;a229 4c  L 
    defb 03dh                  ;a22a 3d  = 
    defb 00fh                  ;a22b 0f  . 
    defb 0b6h                  ;a22c b6  . 
    defb 0a4h                  ;a22d a4  . 
    defb 04ch                  ;a22e 4c  L 
    defb 03dh                  ;a22f 3d  = 
    defb 0d7h                  ;a230 d7  . 
    defb 0b7h                  ;a231 b7  . 
    defb 000h                  ;a232 00  . 
    defb 016h                  ;a233 16  . 
    defb 048h                  ;a234 48  H 
    defb 004h                  ;a235 04  . 
    defb 0b7h                  ;a236 b7  . 
    defb 080h                  ;a237 80  . 
    defb 04ch                  ;a238 4c  L 
    defb 039h                  ;a239 39  9 
    defb 028h                  ;a23a 28  ( 
    defb 0b8h                  ;a23b b8  . 
    defb 000h                  ;a23c 00  . 
    defb 004h                  ;a23d 04  . 
    defb 050h                  ;a23e 50  P 
    defb 004h                  ;a23f 04  . 
    defb 0b8h                  ;a240 b8  . 
    defb 040h                  ;a241 40  @ 
    defb 084h                  ;a242 84  . 
    defb 000h                  ;a243 00  . 
    defb 015h                  ;a244 15  . 
    defb 0b8h                  ;a245 b8  . 
    defb 080h                  ;a246 80  . 
    defb 04ch                  ;a247 4c  L 
    defb 041h                  ;a248 41  A 
    defb 048h                  ;a249 48  H 
    defb 0b9h                  ;a24a b9  . 
    defb 000h                  ;a24b 00  . 
    defb 004h                  ;a24c 04  . 
    defb 058h                  ;a24d 58  X 
    defb 004h                  ;a24e 04  . 
    defb 0b9h                  ;a24f b9  . 
    defb 040h                  ;a250 40  @ 
    defb 070h                  ;a251 70  p 
    defb 000h                  ;a252 00  . 
    defb 015h                  ;a253 15  . 
    defb 0b9h                  ;a254 b9  . 
    defb 080h                  ;a255 80  . 
    defb 04ch                  ;a256 4c  L 
    defb 041h                  ;a257 41  A 
    defb 068h                  ;a258 68  h 
    defb 0bah                  ;a259 ba  . 
    defb 000h                  ;a25a 00  . 
    defb 004h                  ;a25b 04  . 
    defb 060h                  ;a25c 60  ` 
    defb 004h                  ;a25d 04  . 
    defb 0bah                  ;a25e ba  . 
    defb 040h                  ;a25f 40  @ 
    defb 080h                  ;a260 80  . 
    defb 000h                  ;a261 00  . 
    defb 015h                  ;a262 15  . 
    defb 0bah                  ;a263 ba  . 
    defb 080h                  ;a264 80  . 
    defb 04ch                  ;a265 4c  L 
    defb 041h                  ;a266 41  A 
    defb 088h                  ;a267 88  . 
    defb 0bbh                  ;a268 bb  . 
    defb 000h                  ;a269 00  . 
    defb 004h                  ;a26a 04  . 
    defb 068h                  ;a26b 68  h 
    defb 004h                  ;a26c 04  . 
    defb 0bbh                  ;a26d bb  . 
    defb 040h                  ;a26e 40  @ 
    defb 088h                  ;a26f 88  . 
    defb 000h                  ;a270 00  . 
    defb 015h                  ;a271 15  . 
    defb 0bbh                  ;a272 bb  . 
    defb 080h                  ;a273 80  . 
    defb 04ch                  ;a274 4c  L 
    defb 041h                  ;a275 41  A 
    defb 0a8h                  ;a276 a8  . 
    defb 0bch                  ;a277 bc  . 
    defb 000h                  ;a278 00  . 
    defb 004h                  ;a279 04  . 
    defb 070h                  ;a27a 70  p 
    defb 004h                  ;a27b 04  . 
    defb 0bch                  ;a27c bc  . 
    defb 020h                  ;a27d 20    
    defb 004h                  ;a27e 04  . 
    defb 0c8h                  ;a27f c8  . 
    defb 008h                  ;a280 08  . 
    defb 0bch                  ;a281 bc  . 
    defb 080h                  ;a282 80  . 
    defb 04ch                  ;a283 4c  L 
    defb 041h                  ;a284 41  A 
    defb 0c8h                  ;a285 c8  . 
    defb 0bdh                  ;a286 bd  . 
    defb 000h                  ;a287 00  . 
    defb 004h                  ;a288 04  . 
    defb 080h                  ;a289 80  . 
    defb 004h                  ;a28a 04  . 
    defb 0bdh                  ;a28b bd  . 
    defb 020h                  ;a28c 20    
    defb 004h                  ;a28d 04  . 
    defb 0e8h                  ;a28e e8  . 
    defb 008h                  ;a28f 08  . 
    defb 0bdh                  ;a290 bd  . 
    defb 080h                  ;a291 80  . 
    defb 04ch                  ;a292 4c  L 
    defb 042h                  ;a293 42  B 
    defb 008h                  ;a294 08  . 
    defb 0beh                  ;a295 be  . 
    defb 000h                  ;a296 00  . 
    defb 005h                  ;a297 05  . 
    defb 040h                  ;a298 40  @ 
    defb 007h                  ;a299 07  . 
    defb 0beh                  ;a29a be  . 
    defb 024h                  ;a29b 24  $ 
    defb 005h                  ;a29c 05  . 
    defb 070h                  ;a29d 70  p 
    defb 013h                  ;a29e 13  . 
    defb 0beh                  ;a29f be  . 
    defb 080h                  ;a2a0 80  . 
    defb 04ch                  ;a2a1 4c  L 
    defb 045h                  ;a2a2 45  E 
    defb 00fh                  ;a2a3 0f  . 
    defb 0beh                  ;a2a4 be  . 
    defb 0a4h                  ;a2a5 a4  . 
    defb 04ch                  ;a2a6 4c  L 
    defb 045h                  ;a2a7 45  E 
    defb 0d7h                  ;a2a8 d7  . 
    defb 0bfh                  ;a2a9 bf  . 
    defb 000h                  ;a2aa 00  . 
    defb 004h                  ;a2ab 04  . 
    defb 048h                  ;a2ac 48  H 
    defb 004h                  ;a2ad 04  . 
    defb 0bfh                  ;a2ae bf  . 
    defb 080h                  ;a2af 80  . 
    defb 04ch                  ;a2b0 4c  L 
    defb 041h                  ;a2b1 41  A 
    defb 028h                  ;a2b2 28  ( 
    defb 0c0h                  ;a2b3 c0  . 
    defb 000h                  ;a2b4 00  . 
    defb 04fh                  ;a2b5 4f  O 
    defb 000h                  ;a2b6 00  . 
    defb 005h                  ;a2b7 05  . 
    defb 0c0h                  ;a2b8 c0  . 
    defb 080h                  ;a2b9 80  . 
    defb 062h                  ;a2ba 62  b 
    defb 009h                  ;a2bb 09  . 
    defb 048h                  ;a2bc 48  H 
    defb 0c1h                  ;a2bd c1  . 
    defb 000h                  ;a2be 00  . 
    defb 048h                  ;a2bf 48  H 
    defb 0b0h                  ;a2c0 b0  . 
    defb 00ah                  ;a2c1 0a  . 
    defb 0c1h                  ;a2c2 c1  . 
    defb 080h                  ;a2c3 80  . 
    defb 062h                  ;a2c4 62  b 
    defb 009h                  ;a2c5 09  . 
    defb 068h                  ;a2c6 68  h 
    defb 0c2h                  ;a2c7 c2  . 
    defb 002h                  ;a2c8 02  . 
    defb 011h                  ;a2c9 11  . 
    defb 005h                  ;a2ca 05  . 
    defb 08ah                  ;a2cb 8a  . 
    defb 0c2h                  ;a2cc c2  . 
    defb 080h                  ;a2cd 80  . 
    defb 062h                  ;a2ce 62  b 
    defb 009h                  ;a2cf 09  . 
    defb 088h                  ;a2d0 88  . 
    defb 0c3h                  ;a2d1 c3  . 
    defb 002h                  ;a2d2 02  . 
    defb 011h                  ;a2d3 11  . 
    defb 060h                  ;a2d4 60  ` 
    defb 00ah                  ;a2d5 0a  . 
    defb 0c3h                  ;a2d6 c3  . 
    defb 080h                  ;a2d7 80  . 
    defb 062h                  ;a2d8 62  b 
    defb 009h                  ;a2d9 09  . 
    defb 0a8h                  ;a2da a8  . 
    defb 0c4h                  ;a2db c4  . 
    defb 002h                  ;a2dc 02  . 
    defb 06fh                  ;a2dd 6f  o 
    defb 005h                  ;a2de 05  . 
    defb 089h                  ;a2df 89  . 
    defb 0c4h                  ;a2e0 c4  . 
    defb 080h                  ;a2e1 80  . 
    defb 062h                  ;a2e2 62  b 
    defb 009h                  ;a2e3 09  . 
    defb 0c8h                  ;a2e4 c8  . 
    defb 0c5h                  ;a2e5 c5  . 
    defb 000h                  ;a2e6 00  . 
    defb 090h                  ;a2e7 90  . 
    defb 0b0h                  ;a2e8 b0  . 
    defb 00bh                  ;a2e9 0b  . 
    defb 0c5h                  ;a2ea c5  . 
    defb 080h                  ;a2eb 80  . 
    defb 062h                  ;a2ec 62  b 
    defb 00ah                  ;a2ed 0a  . 
    defb 008h                  ;a2ee 08  . 
    defb 0c6h                  ;a2ef c6  . 
    defb 001h                  ;a2f0 01  . 
    defb 01eh                  ;a2f1 1e  . 
    defb 04dh                  ;a2f2 4d  M 
    defb 087h                  ;a2f3 87  . 
    defb 0c6h                  ;a2f4 c6  . 
    defb 080h                  ;a2f5 80  . 
    defb 062h                  ;a2f6 62  b 
    defb 00dh                  ;a2f7 0d  . 
    defb 00fh                  ;a2f8 0f  . 
    defb 0c6h                  ;a2f9 c6  . 
    defb 0a4h                  ;a2fa a4  . 
    defb 062h                  ;a2fb 62  b 
    defb 00dh                  ;a2fc 0d  . 
    defb 0d7h                  ;a2fd d7  . 
    defb 0c7h                  ;a2fe c7  . 
    defb 006h                  ;a2ff 06  . 
    defb 05dh                  ;a300 5d  ] 
    defb 060h                  ;a301 60  ` 
    defb 00bh                  ;a302 0b  . 
    defb 0c7h                  ;a303 c7  . 
    defb 080h                  ;a304 80  . 
    defb 062h                  ;a305 62  b 
    defb 009h                  ;a306 09  . 
    defb 028h                  ;a307 28  ( 
    defb 0c8h                  ;a308 c8  . 
    defb 000h                  ;a309 00  . 
    defb 04eh                  ;a30a 4e  N 
    defb 0a0h                  ;a30b a0  . 
    defb 005h                  ;a30c 05  . 
    defb 0c8h                  ;a30d c8  . 
    defb 080h                  ;a30e 80  . 
    defb 062h                  ;a30f 62  b 
    defb 011h                  ;a310 11  . 
    defb 048h                  ;a311 48  H 
    defb 0c9h                  ;a312 c9  . 
    defb 000h                  ;a313 00  . 
    defb 04eh                  ;a314 4e  N 
    defb 000h                  ;a315 00  . 
    defb 005h                  ;a316 05  . 
    defb 0c9h                  ;a317 c9  . 
    defb 080h                  ;a318 80  . 
    defb 062h                  ;a319 62  b 
    defb 011h                  ;a31a 11  . 
    defb 068h                  ;a31b 68  h 
    defb 0cah                  ;a31c ca  . 
    defb 002h                  ;a31d 02  . 
    defb 010h                  ;a31e 10  . 
    defb 0a5h                  ;a31f a5  . 
    defb 08ah                  ;a320 8a  . 
    defb 0cah                  ;a321 ca  . 
    defb 080h                  ;a322 80  . 
    defb 062h                  ;a323 62  b 
    defb 011h                  ;a324 11  . 
    defb 088h                  ;a325 88  . 
    defb 0cbh                  ;a326 cb  . 
    defb 080h                  ;a327 80  . 
    defb 062h                  ;a328 62  b 
    defb 011h                  ;a329 11  . 
    defb 0a8h                  ;a32a a8  . 
    defb 0cch                  ;a32b cc  . 
    defb 002h                  ;a32c 02  . 
    defb 06eh                  ;a32d 6e  n 
    defb 0a5h                  ;a32e a5  . 
    defb 089h                  ;a32f 89  . 
    defb 0cch                  ;a330 cc  . 
    defb 080h                  ;a331 80  . 
    defb 062h                  ;a332 62  b 
    defb 011h                  ;a333 11  . 
    defb 0c8h                  ;a334 c8  . 
    defb 0cdh                  ;a335 cd  . 
    defb 002h                  ;a336 02  . 
    defb 06fh                  ;a337 6f  o 
    defb 060h                  ;a338 60  ` 
    defb 009h                  ;a339 09  . 
    defb 0cdh                  ;a33a cd  . 
    defb 080h                  ;a33b 80  . 
    defb 062h                  ;a33c 62  b 
    defb 012h                  ;a33d 12  . 
    defb 008h                  ;a33e 08  . 
    defb 0ceh                  ;a33f ce  . 
    defb 001h                  ;a340 01  . 
    defb 01ch                  ;a341 1c  . 
    defb 04dh                  ;a342 4d  M 
    defb 087h                  ;a343 87  . 
    defb 0ceh                  ;a344 ce  . 
    defb 080h                  ;a345 80  . 
    defb 062h                  ;a346 62  b 
    defb 015h                  ;a347 15  . 
    defb 00fh                  ;a348 0f  . 
    defb 0ceh                  ;a349 ce  . 
    defb 0a4h                  ;a34a a4  . 
    defb 062h                  ;a34b 62  b 
    defb 015h                  ;a34c 15  . 
    defb 0d7h                  ;a34d d7  . 
    defb 0cfh                  ;a34e cf  . 
    defb 080h                  ;a34f 80  . 
    defb 062h                  ;a350 62  b 
    defb 011h                  ;a351 11  . 
    defb 028h                  ;a352 28  ( 
    defb 0d0h                  ;a353 d0  . 
    defb 000h                  ;a354 00  . 
    defb 04eh                  ;a355 4e  N 
    defb 0f8h                  ;a356 f8  . 
    defb 005h                  ;a357 05  . 
    defb 0d0h                  ;a358 d0  . 
    defb 080h                  ;a359 80  . 
    defb 062h                  ;a35a 62  b 
    defb 019h                  ;a35b 19  . 
    defb 048h                  ;a35c 48  H 
    defb 0d1h                  ;a35d d1  . 
    defb 000h                  ;a35e 00  . 
    defb 048h                  ;a35f 48  H 
    defb 0b8h                  ;a360 b8  . 
    defb 00ah                  ;a361 0a  . 
    defb 0d1h                  ;a362 d1  . 
    defb 080h                  ;a363 80  . 
    defb 062h                  ;a364 62  b 
    defb 019h                  ;a365 19  . 
    defb 068h                  ;a366 68  h 
    defb 0d2h                  ;a367 d2  . 
    defb 002h                  ;a368 02  . 
    defb 010h                  ;a369 10  . 
    defb 0fdh                  ;a36a fd  . 
    defb 08ah                  ;a36b 8a  . 
    defb 0d2h                  ;a36c d2  . 
    defb 080h                  ;a36d 80  . 
    defb 062h                  ;a36e 62  b 
    defb 019h                  ;a36f 19  . 
    defb 088h                  ;a370 88  . 
    defb 0d3h                  ;a371 d3  . 
    defb 001h                  ;a372 01  . 
    defb 047h                  ;a373 47  G 
    defb 069h                  ;a374 69  i 
    defb 02bh                  ;a375 2b  + 
    defb 0d3h                  ;a376 d3  . 
    defb 080h                  ;a377 80  . 
    defb 062h                  ;a378 62  b 
    defb 019h                  ;a379 19  . 
    defb 0a8h                  ;a37a a8  . 
    defb 0d4h                  ;a37b d4  . 
    defb 002h                  ;a37c 02  . 
    defb 06eh                  ;a37d 6e  n 
    defb 0fdh                  ;a37e fd  . 
    defb 089h                  ;a37f 89  . 
    defb 0d4h                  ;a380 d4  . 
    defb 080h                  ;a381 80  . 
    defb 062h                  ;a382 62  b 
    defb 019h                  ;a383 19  . 
    defb 0c8h                  ;a384 c8  . 
    defb 0d5h                  ;a385 d5  . 
    defb 000h                  ;a386 00  . 
    defb 090h                  ;a387 90  . 
    defb 0b8h                  ;a388 b8  . 
    defb 00bh                  ;a389 0b  . 
    defb 0d5h                  ;a38a d5  . 
    defb 080h                  ;a38b 80  . 
    defb 062h                  ;a38c 62  b 
    defb 01ah                  ;a38d 1a  . 
    defb 008h                  ;a38e 08  . 
    defb 0d6h                  ;a38f d6  . 
    defb 001h                  ;a390 01  . 
    defb 06bh                  ;a391 6b  k 
    defb 060h                  ;a392 60  ` 
    defb 007h                  ;a393 07  . 
    defb 0d6h                  ;a394 d6  . 
    defb 080h                  ;a395 80  . 
    defb 062h                  ;a396 62  b 
    defb 01dh                  ;a397 1d  . 
    defb 00fh                  ;a398 0f  . 
    defb 0d6h                  ;a399 d6  . 
    defb 0a4h                  ;a39a a4  . 
    defb 062h                  ;a39b 62  b 
    defb 01dh                  ;a39c 1d  . 
    defb 0d7h                  ;a39d d7  . 
    defb 0d7h                  ;a39e d7  . 
    defb 080h                  ;a39f 80  . 
    defb 062h                  ;a3a0 62  b 
    defb 019h                  ;a3a1 19  . 
    defb 028h                  ;a3a2 28  ( 
    defb 0d8h                  ;a3a3 d8  . 
    defb 000h                  ;a3a4 00  . 
    defb 04eh                  ;a3a5 4e  N 
    defb 058h                  ;a3a6 58  X 
    defb 005h                  ;a3a7 05  . 
    defb 0d8h                  ;a3a8 d8  . 
    defb 080h                  ;a3a9 80  . 
    defb 062h                  ;a3aa 62  b 
    defb 021h                  ;a3ab 21  ! 
    defb 048h                  ;a3ac 48  H 
    defb 0d9h                  ;a3ad d9  . 
    defb 000h                  ;a3ae 00  . 
    defb 034h                  ;a3af 34  4 
    defb 000h                  ;a3b0 00  . 
    defb 004h                  ;a3b1 04  . 
    defb 0d9h                  ;a3b2 d9  . 
    defb 080h                  ;a3b3 80  . 
    defb 062h                  ;a3b4 62  b 
    defb 021h                  ;a3b5 21  ! 
    defb 068h                  ;a3b6 68  h 
    defb 0dah                  ;a3b7 da  . 
    defb 002h                  ;a3b8 02  . 
    defb 010h                  ;a3b9 10  . 
    defb 05dh                  ;a3ba 5d  ] 
    defb 08ah                  ;a3bb 8a  . 
    defb 0dah                  ;a3bc da  . 
    defb 080h                  ;a3bd 80  . 
    defb 062h                  ;a3be 62  b 
    defb 021h                  ;a3bf 21  ! 
    defb 088h                  ;a3c0 88  . 
    defb 0dbh                  ;a3c1 db  . 
    defb 001h                  ;a3c2 01  . 
    defb 00eh                  ;a3c3 0e  . 
    defb 04dh                  ;a3c4 4d  M 
    defb 0abh                  ;a3c5 ab  . 
    defb 0dbh                  ;a3c6 db  . 
    defb 080h                  ;a3c7 80  . 
    defb 062h                  ;a3c8 62  b 
    defb 021h                  ;a3c9 21  ! 
    defb 0a8h                  ;a3ca a8  . 
    defb 0dch                  ;a3cb dc  . 
    defb 002h                  ;a3cc 02  . 
    defb 06eh                  ;a3cd 6e  n 
    defb 05dh                  ;a3ce 5d  ] 
    defb 089h                  ;a3cf 89  . 
    defb 0dch                  ;a3d0 dc  . 
    defb 080h                  ;a3d1 80  . 
    defb 062h                  ;a3d2 62  b 
    defb 021h                  ;a3d3 21  ! 
    defb 0c8h                  ;a3d4 c8  . 
    defb 0ddh                  ;a3d5 dd  . 
    defb 080h                  ;a3d6 80  . 
    defb 062h                  ;a3d7 62  b 
    defb 022h                  ;a3d8 22  " 
    defb 008h                  ;a3d9 08  . 
    defb 0deh                  ;a3da de  . 
    defb 001h                  ;a3db 01  . 
    defb 05eh                  ;a3dc 5e  ^ 
    defb 04dh                  ;a3dd 4d  M 
    defb 087h                  ;a3de 87  . 
    defb 0deh                  ;a3df de  . 
    defb 080h                  ;a3e0 80  . 
    defb 062h                  ;a3e1 62  b 
    defb 025h                  ;a3e2 25  % 
    defb 00fh                  ;a3e3 0f  . 
    defb 0deh                  ;a3e4 de  . 
    defb 0a4h                  ;a3e5 a4  . 
    defb 062h                  ;a3e6 62  b 
    defb 025h                  ;a3e7 25  % 
    defb 0d7h                  ;a3e8 d7  . 
    defb 0dfh                  ;a3e9 df  . 
    defb 080h                  ;a3ea 80  . 
    defb 062h                  ;a3eb 62  b 
    defb 021h                  ;a3ec 21  ! 
    defb 028h                  ;a3ed 28  ( 
    defb 0e0h                  ;a3ee e0  . 
    defb 000h                  ;a3ef 00  . 
    defb 04fh                  ;a3f0 4f  O 
    defb 010h                  ;a3f1 10  . 
    defb 005h                  ;a3f2 05  . 
    defb 0e0h                  ;a3f3 e0  . 
    defb 080h                  ;a3f4 80  . 
    defb 062h                  ;a3f5 62  b 
    defb 029h                  ;a3f6 29  ) 
    defb 048h                  ;a3f7 48  H 
    defb 0e1h                  ;a3f8 e1  . 
    defb 000h                  ;a3f9 00  . 
    defb 048h                  ;a3fa 48  H 
    defb 0c0h                  ;a3fb c0  . 
    defb 00ah                  ;a3fc 0a  . 
    defb 0e1h                  ;a3fd e1  . 
    defb 020h                  ;a3fe 20    
    defb 048h                  ;a3ff 48  H 
    defb 0d8h                  ;a400 d8  . 
    defb 00eh                  ;a401 0e  . 
    defb 0e1h                  ;a402 e1  . 
    defb 080h                  ;a403 80  . 
    defb 062h                  ;a404 62  b 
    defb 029h                  ;a405 29  ) 
    defb 068h                  ;a406 68  h 
    defb 0e2h                  ;a407 e2  . 
    defb 002h                  ;a408 02  . 
    defb 011h                  ;a409 11  . 
    defb 015h                  ;a40a 15  . 
    defb 08ah                  ;a40b 8a  . 
    defb 0e2h                  ;a40c e2  . 
    defb 080h                  ;a40d 80  . 
    defb 062h                  ;a40e 62  b 
    defb 029h                  ;a40f 29  ) 
    defb 088h                  ;a410 88  . 
    defb 0e3h                  ;a411 e3  . 
    defb 000h                  ;a412 00  . 
    defb 00bh                  ;a413 0b  . 
    defb 05bh                  ;a414 5b  [ 
    defb 013h                  ;a415 13  . 
    defb 0e3h                  ;a416 e3  . 
    defb 020h                  ;a417 20    
    defb 00bh                  ;a418 0b  . 
    defb 05bh                  ;a419 5b  [ 
    defb 077h                  ;a41a 77  w 
    defb 0e3h                  ;a41b e3  . 
    defb 080h                  ;a41c 80  . 
    defb 062h                  ;a41d 62  b 
    defb 029h                  ;a41e 29  ) 
    defb 0a8h                  ;a41f a8  . 
    defb 0e4h                  ;a420 e4  . 
    defb 002h                  ;a421 02  . 
    defb 06fh                  ;a422 6f  o 
    defb 015h                  ;a423 15  . 
    defb 089h                  ;a424 89  . 
    defb 0e4h                  ;a425 e4  . 
    defb 080h                  ;a426 80  . 
    defb 062h                  ;a427 62  b 
    defb 029h                  ;a428 29  ) 
    defb 0c8h                  ;a429 c8  . 
    defb 0e5h                  ;a42a e5  . 
    defb 000h                  ;a42b 00  . 
    defb 090h                  ;a42c 90  . 
    defb 0c0h                  ;a42d c0  . 
    defb 00bh                  ;a42e 0b  . 
    defb 0e5h                  ;a42f e5  . 
    defb 020h                  ;a430 20    
    defb 090h                  ;a431 90  . 
    defb 0d8h                  ;a432 d8  . 
    defb 00fh                  ;a433 0f  . 
    defb 0e5h                  ;a434 e5  . 
    defb 080h                  ;a435 80  . 
    defb 062h                  ;a436 62  b 
    defb 02ah                  ;a437 2a  * 
    defb 008h                  ;a438 08  . 
    defb 0e6h                  ;a439 e6  . 
    defb 001h                  ;a43a 01  . 
    defb 021h                  ;a43b 21  ! 
    defb 060h                  ;a43c 60  ` 
    defb 007h                  ;a43d 07  . 
    defb 0e6h                  ;a43e e6  . 
    defb 080h                  ;a43f 80  . 
    defb 062h                  ;a440 62  b 
    defb 02dh                  ;a441 2d  - 
    defb 00fh                  ;a442 0f  . 
    defb 0e6h                  ;a443 e6  . 
    defb 0a4h                  ;a444 a4  . 
    defb 062h                  ;a445 62  b 
    defb 02dh                  ;a446 2d  - 
    defb 0d7h                  ;a447 d7  . 
    defb 0e7h                  ;a448 e7  . 
    defb 080h                  ;a449 80  . 
    defb 062h                  ;a44a 62  b 
    defb 029h                  ;a44b 29  ) 
    defb 028h                  ;a44c 28  ( 
    defb 0e8h                  ;a44d e8  . 
    defb 000h                  ;a44e 00  . 
    defb 04fh                  ;a44f 4f  O 
    defb 008h                  ;a450 08  . 
    defb 005h                  ;a451 05  . 
    defb 0e8h                  ;a452 e8  . 
    defb 080h                  ;a453 80  . 
    defb 062h                  ;a454 62  b 
    defb 031h                  ;a455 31  1 
    defb 048h                  ;a456 48  H 
    defb 0e9h                  ;a457 e9  . 
    defb 000h                  ;a458 00  . 
    defb 011h                  ;a459 11  . 
    defb 040h                  ;a45a 40  @ 
    defb 004h                  ;a45b 04  . 
    defb 0e9h                  ;a45c e9  . 
    defb 020h                  ;a45d 20    
    defb 011h                  ;a45e 11  . 
    defb 048h                  ;a45f 48  H 
    defb 008h                  ;a460 08  . 
    defb 0e9h                  ;a461 e9  . 
    defb 080h                  ;a462 80  . 
    defb 062h                  ;a463 62  b 
    defb 031h                  ;a464 31  1 
    defb 068h                  ;a465 68  h 
    defb 0eah                  ;a466 ea  . 
    defb 002h                  ;a467 02  . 
    defb 011h                  ;a468 11  . 
    defb 00dh                  ;a469 0d  . 
    defb 08ah                  ;a46a 8a  . 
    defb 0eah                  ;a46b ea  . 
    defb 080h                  ;a46c 80  . 
    defb 062h                  ;a46d 62  b 
    defb 031h                  ;a46e 31  1 
    defb 088h                  ;a46f 88  . 
    defb 0ebh                  ;a470 eb  . 
    defb 000h                  ;a471 00  . 
    defb 00ah                  ;a472 0a  . 
    defb 0bbh                  ;a473 bb  . 
    defb 004h                  ;a474 04  . 
    defb 0ebh                  ;a475 eb  . 
    defb 080h                  ;a476 80  . 
    defb 062h                  ;a477 62  b 
    defb 031h                  ;a478 31  1 
    defb 0a8h                  ;a479 a8  . 
    defb 0ech                  ;a47a ec  . 
    defb 002h                  ;a47b 02  . 
    defb 06fh                  ;a47c 6f  o 
    defb 00dh                  ;a47d 0d  . 
    defb 089h                  ;a47e 89  . 
    defb 0ech                  ;a47f ec  . 
    defb 080h                  ;a480 80  . 
    defb 062h                  ;a481 62  b 
    defb 031h                  ;a482 31  1 
    defb 0c8h                  ;a483 c8  . 
    defb 0edh                  ;a484 ed  . 
    defb 080h                  ;a485 80  . 
    defb 062h                  ;a486 62  b 
    defb 032h                  ;a487 32  2 
    defb 008h                  ;a488 08  . 
    defb 0eeh                  ;a489 ee  . 
    defb 001h                  ;a48a 01  . 
    defb 06dh                  ;a48b 6d  m 
    defb 060h                  ;a48c 60  ` 
    defb 007h                  ;a48d 07  . 
    defb 0eeh                  ;a48e ee  . 
    defb 080h                  ;a48f 80  . 
    defb 062h                  ;a490 62  b 
    defb 035h                  ;a491 35  5 
    defb 00fh                  ;a492 0f  . 
    defb 0eeh                  ;a493 ee  . 
    defb 0a4h                  ;a494 a4  . 
    defb 062h                  ;a495 62  b 
    defb 035h                  ;a496 35  5 
    defb 0d7h                  ;a497 d7  . 
    defb 0efh                  ;a498 ef  . 
    defb 080h                  ;a499 80  . 
    defb 062h                  ;a49a 62  b 
    defb 031h                  ;a49b 31  1 
    defb 028h                  ;a49c 28  ( 
    defb 0f0h                  ;a49d f0  . 
    defb 000h                  ;a49e 00  . 
    defb 04eh                  ;a49f 4e  N 
    defb 090h                  ;a4a0 90  . 
    defb 005h                  ;a4a1 05  . 
    defb 0f0h                  ;a4a2 f0  . 
    defb 080h                  ;a4a3 80  . 
    defb 062h                  ;a4a4 62  b 
    defb 039h                  ;a4a5 39  9 
    defb 048h                  ;a4a6 48  H 
    defb 0f1h                  ;a4a7 f1  . 
    defb 000h                  ;a4a8 00  . 
    defb 048h                  ;a4a9 48  H 
    defb 0a8h                  ;a4aa a8  . 
    defb 00ah                  ;a4ab 0a  . 
    defb 0f1h                  ;a4ac f1  . 
    defb 080h                  ;a4ad 80  . 
    defb 062h                  ;a4ae 62  b 
    defb 039h                  ;a4af 39  9 
    defb 068h                  ;a4b0 68  h 
    defb 0f2h                  ;a4b1 f2  . 
    defb 002h                  ;a4b2 02  . 
    defb 010h                  ;a4b3 10  . 
    defb 095h                  ;a4b4 95  . 
    defb 08ah                  ;a4b5 8a  . 
    defb 0f2h                  ;a4b6 f2  . 
    defb 080h                  ;a4b7 80  . 
    defb 062h                  ;a4b8 62  b 
    defb 039h                  ;a4b9 39  9 
    defb 088h                  ;a4ba 88  . 
    defb 0f3h                  ;a4bb f3  . 
    defb 000h                  ;a4bc 00  . 
    defb 006h                  ;a4bd 06  . 
    defb 000h                  ;a4be 00  . 
    defb 004h                  ;a4bf 04  . 
    defb 0f3h                  ;a4c0 f3  . 
    defb 080h                  ;a4c1 80  . 
    defb 062h                  ;a4c2 62  b 
    defb 039h                  ;a4c3 39  9 
    defb 0a8h                  ;a4c4 a8  . 
    defb 0f4h                  ;a4c5 f4  . 
    defb 002h                  ;a4c6 02  . 
    defb 06eh                  ;a4c7 6e  n 
    defb 095h                  ;a4c8 95  . 
    defb 089h                  ;a4c9 89  . 
    defb 0f4h                  ;a4ca f4  . 
    defb 080h                  ;a4cb 80  . 
    defb 062h                  ;a4cc 62  b 
    defb 039h                  ;a4cd 39  9 
    defb 0c8h                  ;a4ce c8  . 
    defb 0f5h                  ;a4cf f5  . 
    defb 000h                  ;a4d0 00  . 
    defb 090h                  ;a4d1 90  . 
    defb 0a8h                  ;a4d2 a8  . 
    defb 00bh                  ;a4d3 0b  . 
    defb 0f5h                  ;a4d4 f5  . 
    defb 080h                  ;a4d5 80  . 
    defb 062h                  ;a4d6 62  b 
    defb 03ah                  ;a4d7 3a  : 
    defb 008h                  ;a4d8 08  . 
    defb 0f6h                  ;a4d9 f6  . 
    defb 001h                  ;a4da 01  . 
    defb 017h                  ;a4db 17  . 
    defb 060h                  ;a4dc 60  ` 
    defb 007h                  ;a4dd 07  . 
    defb 0f6h                  ;a4de f6  . 
    defb 080h                  ;a4df 80  . 
    defb 062h                  ;a4e0 62  b 
    defb 03dh                  ;a4e1 3d  = 
    defb 00fh                  ;a4e2 0f  . 
    defb 0f6h                  ;a4e3 f6  . 
    defb 0a4h                  ;a4e4 a4  . 
    defb 062h                  ;a4e5 62  b 
    defb 03dh                  ;a4e6 3d  = 
    defb 0d7h                  ;a4e7 d7  . 
    defb 0f7h                  ;a4e8 f7  . 
    defb 080h                  ;a4e9 80  . 
    defb 062h                  ;a4ea 62  b 
    defb 039h                  ;a4eb 39  9 
    defb 028h                  ;a4ec 28  ( 
    defb 0f8h                  ;a4ed f8  . 
    defb 000h                  ;a4ee 00  . 
    defb 04eh                  ;a4ef 4e  N 
    defb 088h                  ;a4f0 88  . 
    defb 005h                  ;a4f1 05  . 
    defb 0f8h                  ;a4f2 f8  . 
    defb 080h                  ;a4f3 80  . 
    defb 062h                  ;a4f4 62  b 
    defb 041h                  ;a4f5 41  A 
    defb 048h                  ;a4f6 48  H 
    defb 0f9h                  ;a4f7 f9  . 
    defb 000h                  ;a4f8 00  . 
    defb 015h                  ;a4f9 15  . 
    defb 01bh                  ;a4fa 1b  . 
    defb 006h                  ;a4fb 06  . 
    defb 0f9h                  ;a4fc f9  . 
    defb 020h                  ;a4fd 20    
    defb 015h                  ;a4fe 15  . 
    defb 01bh                  ;a4ff 1b  . 
    defb 06ah                  ;a500 6a  j 
    defb 0f9h                  ;a501 f9  . 
    defb 080h                  ;a502 80  . 
    defb 062h                  ;a503 62  b 
    defb 041h                  ;a504 41  A 
    defb 068h                  ;a505 68  h 
    defb 0fah                  ;a506 fa  . 
    defb 002h                  ;a507 02  . 
    defb 010h                  ;a508 10  . 
    defb 08dh                  ;a509 8d  . 
    defb 08ah                  ;a50a 8a  . 
    defb 0fah                  ;a50b fa  . 
    defb 080h                  ;a50c 80  . 
    defb 062h                  ;a50d 62  b 
    defb 041h                  ;a50e 41  A 
    defb 088h                  ;a50f 88  . 
    defb 0fbh                  ;a510 fb  . 
    defb 000h                  ;a511 00  . 
    defb 008h                  ;a512 08  . 
    defb 000h                  ;a513 00  . 
    defb 004h                  ;a514 04  . 
    defb 0fbh                  ;a515 fb  . 
    defb 080h                  ;a516 80  . 
    defb 062h                  ;a517 62  b 
    defb 041h                  ;a518 41  A 
    defb 0a8h                  ;a519 a8  . 
    defb 0fch                  ;a51a fc  . 
    defb 002h                  ;a51b 02  . 
    defb 06eh                  ;a51c 6e  n 
    defb 08dh                  ;a51d 8d  . 
    defb 089h                  ;a51e 89  . 
    defb 0fch                  ;a51f fc  . 
    defb 080h                  ;a520 80  . 
    defb 062h                  ;a521 62  b 
    defb 041h                  ;a522 41  A 
    defb 0c8h                  ;a523 c8  . 
    defb 0fdh                  ;a524 fd  . 
    defb 080h                  ;a525 80  . 
    defb 062h                  ;a526 62  b 
    defb 042h                  ;a527 42  B 
    defb 008h                  ;a528 08  . 
    defb 0feh                  ;a529 fe  . 
    defb 001h                  ;a52a 01  . 
    defb 005h                  ;a52b 05  . 
    defb 060h                  ;a52c 60  ` 
    defb 007h                  ;a52d 07  . 
    defb 0feh                  ;a52e fe  . 
    defb 080h                  ;a52f 80  . 
    defb 062h                  ;a530 62  b 
    defb 045h                  ;a531 45  E 
    defb 00fh                  ;a532 0f  . 
    defb 0feh                  ;a533 fe  . 
    defb 0a4h                  ;a534 a4  . 
    defb 062h                  ;a535 62  b 
    defb 045h                  ;a536 45  E 
    defb 0d7h                  ;a537 d7  . 
    defb 0ffh                  ;a538 ff  . 
    defb 080h                  ;a539 80  . 
    defb 062h                  ;a53a 62  b 
    defb 041h                  ;a53b 41  A 
    defb 028h                  ;a53c 28  ( 
    defb 0ffh                  ;a53d ff  . 
    defb 0ffh                  ;a53e ff  . 
    defb 0ffh                  ;a53f ff  . 
    defb 0ffh                  ;a540 ff  . 
    defb 0ffh                  ;a541 ff  . 
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
    defb 000h                  ;a55a 00  . 
    defb 030h                  ;a55b 30  0 
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
    defb 000h                  ;a56a 00  . 
    defb 000h                  ;a56b 00  . 
v_l9c38h:
    defb 000h                  ;a56c 00  . 
    defb 000h                  ;a56d 00  . 
    defb 000h                  ;a56e 00  . 
    defb 000h                  ;a56f 00  . 
    defb 000h                  ;a570 00  . 
    defb 000h                  ;a571 00  . 
v_l9c3eh:
    defb 000h                  ;a572 00  . 
    defb 000h                  ;a573 00  . 
