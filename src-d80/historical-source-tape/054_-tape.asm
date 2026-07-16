; decoded from 054_-tape_t3_l1893_p1_0_p2_1533.bin
; source_length=1533 symbol_count=42 bridge=29ff
; symbols:
;      1: BEGIN     value=42680 defined=1 locked=0
;      2: INPCOM    value=43050 defined=1 locked=0
;      3: BEGIN2    value=42687 defined=1 locked=0
;      4: LDHEAD    value=43125 defined=1 locked=0
;      5: INLIN2    value=43077 defined=1 locked=0
;      6: TST       value=42699 defined=1 locked=0
;      7: TST20     value=42723 defined=1 locked=0
;      8: LLLLL     value=42728 defined=1 locked=0
;      9: TST2      value=42707 defined=1 locked=0
;     10: HEAD2     value=42996 defined=1 locked=0
;     11: TST3      value=42715 defined=1 locked=0
;     12: FREE      value=43308 defined=1 locked=0
;     13: LOAD      value=43110 defined=1 locked=0
;     14: CONVERT   value=42757 defined=1 locked=0
;     15: TAPERROR  value=43239 defined=1 locked=0
;     16: CONVERT2  value=42763 defined=1 locked=0
;     17: CONVERT3  value=42775 defined=1 locked=0
;     18: NAME      value=42980 defined=1 locked=0
;     19: SAVE      value=42827 defined=1 locked=0
;     20: TT        value=43172 defined=1 locked=0
;     21: HEAD      value=42979 defined=1 locked=0
;     22: PAUSE     value=42970 defined=1 locked=0
;     23: MENU      value=42882 defined=1 locked=0
;     24: START     value=42960 defined=1 locked=0
;     25: KEY       value=43260 defined=1 locked=0
;     26: LOOOP     value=42929 defined=1 locked=0
;     27: HALT      value=42973 defined=1 locked=0
;     28: LEN       value=42990 defined=1 locked=0
;     29: IP4       value=43013 defined=1 locked=0
;     30: IP8       value=43036 defined=1 locked=0
;     31: IP2       value=43065 defined=1 locked=0
;     32: IP7       value=43028 defined=1 locked=0
;     33: IP6       value=43029 defined=1 locked=0
;     34: INPOS     value=43092 defined=1 locked=0
;     35: IP3       value=43060 defined=1 locked=0
;     36: TXT       value=43068 defined=1 locked=0
;     37: TT2       value=43228 defined=1 locked=0
;     38: IP5       value=43102 defined=1 locked=0
;     39: LDHEAD2   value=43162 defined=1 locked=0
;     40: TT3       value=43229 defined=1 locked=0
;     41: KEY2      value=43295 defined=1 locked=0
;     42: A0LEN     value=  628 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
BEGIN     di                             ; @0008 f3088001c2
          call INPCOM                    ; @000D cd028002c2
          cp 7                           ; @0012 fe0137c1
          ret z                          ; @0016 c800
BEGIN2    call LDHEAD                    ; @0018 cd0a80038004c4
          jr nc,BEGIN                    ; @001F 30038001c2
          ld b,10                        ; @0024 06013130c2
          ld hl,INLIN2                   ; @0029 21028005c2
          ld a,32                        ; @002E 3e013332c2
TST       cp (hl)                        ; @0033 be088006c2
          inc hl                         ; @0038 2300
          jr nz,TST20                    ; @003A 20038007c2
          djnz TST                       ; @003F 10038006c2
          jr LLLLL                       ; @0044 18038008c2
                                         ; @0049 0030
TST2      ld de,INLIN2                   ; @004B 110a80098005c4
          ld hl,HEAD2+1                  ; @0052 2102800a2b31c4
          ld b,10                        ; @0059 06013130c2
TST3      ld a,(de)                      ; @005E 1a08800bc2
          cp (hl)                        ; @0063 be00
          ret nz                         ; @0065 c000
          inc hl                         ; @0067 2300
          inc de                         ; @0069 1300
          djnz TST3                      ; @006B 1003800bc2
          ret                            ; @0070 c900
                                         ; @0072 0030
TST20     call TST2                      ; @0074 cd0a80078009c4
          jr nz,BEGIN2                   ; @007B 20038003c2
                                         ; @0080 0030
LLLLL     ld ix,FREE                     ; @0082 212a8008800cc4
          ld de,(HEAD2+11)               ; @0089 5b42800a2b3131c5
          scf                            ; @0091 3700
          sbc a,a                        ; @0093 9f00
          call LOAD                      ; @0095 cd02800dc2
          ex af,af'                      ; @009A 0800
          ld a,127                       ; @009C 3e01313237c3
          in a,(254)                     ; @00A2 db01323534c3
          rra                            ; @00A8 1f00
          jr nc,BEGIN                    ; @00AA 30038001c2
          ex af,af'                      ; @00AF 0800
          jr c,CONVERT                   ; @00B1 3803800ec2
          call TAPERROR                  ; @00B6 cd02800fc2
          jr BEGIN2                      ; @00BB 18038003c2
                                         ; @00C0 0030
CONVERT   ld hl,FREE                     ; @00C2 210a800e800cc4
          ld bc,6144                     ; @00C9 010236313434c4
                                         ; @00D0 0030
CONVERT2  ld a,(hl)                      ; @00D2 7e088010c2
          cpl                            ; @00D7 2f00
          ld (hl),a                      ; @00D9 7700
          inc hl                         ; @00DB 2300
          dec bc                         ; @00DD 0b00
          ld a,b                         ; @00DF 7800
          or c                           ; @00E1 b100
          jr nz,CONVERT2                 ; @00E3 20038010c2
                                         ; @00E8 0030
          ld bc,768                      ; @00EA 0102373638c3
CONVERT3  ld (hl),56                     ; @00F0 360980113536c4
          inc hl                         ; @00F7 2300
          dec bc                         ; @00F9 0b00
          ld a,b                         ; @00FB 7800
          or c                           ; @00FD b100
          jr nz,CONVERT3                 ; @00FF 20038011c2
                                         ; @0104 0030
          out (254),a                    ; @0106 d301323534c3
                                         ; @010C 0030
          ld hl,FREE                     ; @010E 2102800cc2
          ld de,16384                    ; @0113 11023136333834c5
          ld bc,6912                     ; @011B 010236393132c4
          ldir                           ; @0122 b040
                                         ; @0124 0030
          ld bc,0                        ; @0126 010230c1
          ei                             ; @012A fb00
          call #1F3D                     ; @012C cd022331463344c5
                                         ; @0134 0030
          call #D6B                      ; @0136 cd0223443642c4
          ld a,7                         ; @013D 3e0137c1
          out (254),a                    ; @0141 d301323534c3
                                         ; @0147 0030
          call INPCOM                    ; @0149 cd028002c2
          cp 7                           ; @014E fe0137c1
          ret z                          ; @0152 c800
                                         ; @0154 0030
          ld hl,INLIN2                   ; @0156 21028005c2
          ld de,NAME                     ; @015B 11028012c2
          ld bc,10                       ; @0160 01023130c2
          ldir                           ; @0165 b040
                                         ; @0167 0030
                                         ; @0169 0030
SAVE      call TT                        ; @016B cd0a80138014c4
          defm " Start tape "            ; @0172 07372220537461727420746170652022ce
          defm '& key '                  ; @0183 07372726206b65792027c8
                                         ; @018E 0030
          ld bc,0                        ; @0190 010230c1
          ei                             ; @0194 fb00
          call #1F3D                     ; @0196 cd022331463344c5
                                         ; @019E 0030
          call #D6B                      ; @01A0 cd0223443642c4
          ld ix,HEAD                     ; @01A7 21228015c2
          ld de,17                       ; @01AC 11023137c2
          xor a                          ; @01B1 af00
          call PAUSE                     ; @01B3 cd028016c2
          ld a,127                       ; @01B8 3e01313237c3
          in a,(254)                     ; @01BE db01323534c3
          rra                            ; @01C4 1f00
          jr nc,MENU                     ; @01C6 30038017c2
                                         ; @01CB 0030
          call START                     ; @01CD cd028018c2
          call PAUSE                     ; @01D2 cd028016c2
MENU      call TT                        ; @01D7 cd0a80178014c4
          defb 20,1,"S",20,0             ; @01DE 063732302c312c2253222c32302c30cd
          defm "ave "                    ; @01EE 0737226176652022c6
          defb 20,1,"V",20,0             ; @01F7 063732302c312c2256222c32302c30cd
          defm "erify "                  ; @0207 07372265726966792022c8
          defb 20,1,"R",20,0             ; @0212 063732302c312c2252222c32302c30cd
          defm 'eturn'                   ; @0222 073727657475726e27c7
                                         ; @022C 0030
          call KEY                       ; @022E cd028019c2
          cp "s"                         ; @0233 fe01227322c3
          jr z,SAVE                      ; @0239 28038013c2
          cp "r"                         ; @023E fe01227222c3
          ret z                          ; @0244 c800
          cp "v"                         ; @0246 fe01227622c3
          jr nz,MENU                     ; @024C 20038017c2
                                         ; @0251 0030
LOOOP     call LDHEAD                    ; @0253 cd0a801a8004c4
          jr nc,MENU                     ; @025A 30038017c2
          call TST2                      ; @025F cd028009c2
          jr nz,LOOOP                    ; @0264 2003801ac2
                                         ; @0269 0030
          call START                     ; @026B cd028018c2
          cp a                           ; @0270 bf00
          call LOAD                      ; @0272 cd02800dc2
          jr c,MENU                      ; @0277 38038017c2
          ld a,127                       ; @027C 3e01313237c3
          in a,(254)                     ; @0282 db01323534c3
          rra                            ; @0288 1f00
          jr nc,MENU                     ; @028A 30038017c2
          call TAPERROR                  ; @028F cd02800fc2
          jr MENU                        ; @0294 18038017c2
                                         ; @0299 0030
START     ld ix,FREE                     ; @029B 212a8018800cc4
          ld de,6912                     ; @02A2 110236393132c4
          ld a,255                       ; @02A9 3e01323535c3
          ret                            ; @02AF c900
                                         ; @02B1 0030
PAUSE     ld b,30                        ; @02B3 060980163330c4
          ei                             ; @02BA fb00
HALT      halt                           ; @02BC 7608801bc2
          djnz HALT                      ; @02C1 1003801bc2
          jp #4C6                        ; @02C6 c30223344336c4
                                         ; @02CD 0030
HEAD      defb 3                         ; @02CF 063f801533c3
NAME      defm "0123456789"              ; @02D5 073f8012223031323334353637383922ce
LEN       defw 6912                      ; @02E6 093f801c36393132c6
          defw 16384,0                   ; @02EF 093731363338342c30c7
                                         ; @02F9 0030
HEAD2     defs 17                        ; @02FB 083f800a3137c4
                                         ; @0302 0030
IP4       cp 12                          ; @0304 fe09801d3132c4
          jr nz,IP8                      ; @030B 2003801ec2
          ld bc,INLIN2                   ; @0310 01028005c2
          or a                           ; @0315 b700
          sbc hl,bc                      ; @0317 4240
          add hl,bc                      ; @0319 0900
          jr z,IP2                       ; @031B 2803801fc2
          ld (hl),32                     ; @0320 36013332c2
IP7       dec hl                         ; @0325 2b088020c2
IP6       ld (hl),"_"                    ; @032A 36098021225f22c5
          ld (INPOS+1),hl                ; @0332 220280222b31c4
          jr IP2                         ; @0339 1803801fc2
                                         ; @033E 0030
IP8       cp 32                          ; @0340 fe09801e3332c4
          jr c,IP2                       ; @0347 3803801fc2
          and 127                        ; @034C e601313237c3
          ld (hl),a                      ; @0352 7700
          inc hl                         ; @0354 2300
          bit 7,(hl)                     ; @0356 7e80
          jr nz,IP7                      ; @0358 20038020c2
          jr IP6                         ; @035D 18038021c2
                                         ; @0362 0030
INPCOM    ld hl,INLIN2                   ; @0364 210a80028005c4
          ld (INPOS+1),hl                ; @036B 220280222b31c4
          ld (hl),"_"                    ; @0372 3601225f22c3
          ld b,10                        ; @0378 06013130c2
IP3       inc hl                         ; @037D 23088023c2
          ld (hl),32                     ; @0382 36013332c2
          djnz IP3                       ; @0387 10038023c2
IP2       call TT                        ; @038C cd0a801f8014c4
TXT       defm ' Name:'                  ; @0393 073f802427204e616d653a27ca
          call TT2                       ; @03A0 cd028025c2
INLIN2    defm ' 0123456789 '            ; @03A5 073f80052720303132333435363738392027d0
                                         ; @03B8 0030
          call KEY                       ; @03BA cd028019c2
INPOS     ld hl,0                        ; @03BF 210a802230c3
          cp 7                           ; @03C5 fe0137c1
          ret z                          ; @03C9 c800
          cp 13                          ; @03CB fe013133c2
          jr nz,IP4                      ; @03D0 2003801dc2
                                         ; @03D5 0030
IP5       ld (hl),32                     ; @03D7 360980263332c4
          inc hl                         ; @03DE 2300
          bit 7,(hl)                     ; @03E0 7e80
          jr z,IP5                       ; @03E2 28038026c2
          ret                            ; @03E7 c900
                                         ; @03E9 0030
                                         ; @03EB 0030
LOAD      inc d                          ; @03ED 1408800dc2
          ex af,af'                      ; @03F2 0800
          dec d                          ; @03F4 1500
          ld a,4+8                       ; @03F6 3e01342b38c3
          out (254),a                    ; @03FC d301323534c3
          call #562                      ; @0402 cd0223353632c4
          ld a,15                        ; @0409 3e013135c2
          out (254),a                    ; @040E d301323534c3
          ret                            ; @0414 c900
                                         ; @0416 0030
                                         ; @0418 0030
LDHEAD    ld ix,HEAD2                    ; @041A 212a8004800ac4
          ld de,17                       ; @0421 11023137c2
          xor a                          ; @0426 af00
          scf                            ; @0428 3700
          call LOAD                      ; @042A cd02800dc2
          ex af,af'                      ; @042F 0800
          ld a,127                       ; @0431 3e01313237c3
          in a,(254)                     ; @0437 db01323534c3
          rra                            ; @043D 1f00
          ret nc                         ; @043F d000
          ex af,af'                      ; @0441 0800
          jr nc,LDHEAD                   ; @0443 30038004c2
                                         ; @0448 0030
          call TT                        ; @044A cd028014c2
          defm ' Found:'                 ; @044F 07372720466f756e643a27c9
                                         ; @045B 0030
          ld hl,HEAD2+1                  ; @045D 2102800a2b31c4
          ld b,10                        ; @0464 06013130c2
LDHEAD2   ld a,(hl)                      ; @0469 7e088027c2
          rst 16                         ; @046E c7063136c2
          inc hl                         ; @0473 2300
          djnz LDHEAD2                   ; @0475 10038027c2
          ld a,32                        ; @047A 3e013332c2
          rst 16                         ; @047F c7063136c2
          scf                            ; @0484 3700
          ret                            ; @0486 c900
                                         ; @0488 0030
                                         ; @048A 0030
TT        ld a,2                         ; @048C 3e09801432c3
          call #1601                     ; @0492 cd022331363031c5
                                         ; @049A 0030
          ld bc,71*256+47                ; @049C 010237312a3235362b3437c9
          call #22E5                     ; @04A8 cd022332324535c5
                                         ; @04B0 0030
          ld de,256                      ; @04B2 1102323536c3
          ld bc,26*256                   ; @04B8 010232362a323536c6
          call #24BA                     ; @04C1 cd022332344241c5
                                         ; @04C9 0030
          ld de,1                        ; @04CB 110231c1
          ld bc,162                      ; @04CF 0102313632c3
          call #24BA                     ; @04D5 cd022332344241c5
                                         ; @04DD 0030
          ld de,256*255                  ; @04DF 11023235362a323535c7
          ld bc,26*256                   ; @04E9 010232362a323536c6
          call #24BA                     ; @04F2 cd022332344241c5
                                         ; @04FA 0030
          ld de,255                      ; @04FC 1102323535c3
          ld bc,162                      ; @0502 0102313632c3
          call #24BA                     ; @0508 cd022332344241c5
                                         ; @0510 0030
          ld a,22                        ; @0512 3e013232c2
          rst 16                         ; @0517 c7063136c2
          ld a,11                        ; @051C 3e013131c2
          rst 16                         ; @0521 c7063136c2
          ld a,7                         ; @0526 3e0137c1
          rst 16                         ; @052A c7063136c2
                                         ; @052F 0030
TT2       pop hl                         ; @0531 e1088025c2
TT3       ld a,(hl)                      ; @0536 7e088028c2
          and 127                        ; @053B e601313237c3
          rst 16                         ; @0541 c7063136c2
          bit 7,(hl)                     ; @0546 7e80
          inc hl                         ; @0548 2300
          jr z,TT3                       ; @054A 28038028c2
          jp (hl)                        ; @054F e900
                                         ; @0551 0030
TAPERROR  call TT                        ; @0553 cd0a800f8014c4
          defm "Tape loading"            ; @055A 07372254617065206c6f6164696e6722ce
          defm ' error'                  ; @056B 073727206572726f7227c8
                                         ; @0576 0030
KEY       ei                             ; @0578 fb088019c2
          halt                           ; @057D 7600
          bit 5,(iy+1)                   ; @057F 6e9431c1
          jr z,KEY                       ; @0583 28038019c2
                                         ; @0588 0030
          res 5,(iy+1)                   ; @058A ae9431c1
          ld a,(23560)                   ; @058E 3a023233353630c5
          cp 7                           ; @0596 fe0137c1
          jr z,KEY2                      ; @059A 28038029c2
          cp 13                          ; @059F fe013133c2
          jr z,KEY2                      ; @05A4 28038029c2
          cp 12                          ; @05A9 fe013132c2
          jr z,KEY2                      ; @05AE 28038029c2
          cp 32                          ; @05B3 fe013332c2
          jr c,KEY                       ; @05B8 38038019c2
          cp 128                         ; @05BD fe01313238c3
          jr nc,KEY                      ; @05C3 30038019c2
                                         ; @05C8 0030
KEY2      push af                        ; @05CA f5088029c2
          ld hl,#C8                      ; @05CF 2102234338c3
          ld de,#F                       ; @05D5 11022346c2
          call #3B5                      ; @05DA cd0223334235c4
          pop af                         ; @05E1 f100
          di                             ; @05E3 f300
          ret                            ; @05E5 c900
                                         ; @05E7 0030
A0LEN     equ $-BEGIN                    ; @05E9 033f802a242d8001c6
                                         ; @05F2 0030
FREE      defs 6912                      ; @05F4 083f800c36393132c6
