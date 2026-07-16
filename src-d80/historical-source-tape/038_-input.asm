; decoded from 038_-input_t3_l2350_p1_0_p2_1799.bin
; source_length=1799 symbol_count=58 bridge=44ff
; symbols:
;      1: RUN       value=43137 defined=1 locked=0
;      2: MAIN      value=43156 defined=1 locked=0
;      3: INPUT     value=43231 defined=1 locked=0
;      4: TEXT1     value=43781 defined=1 locked=0
;      5: TEXTOUT   value=43761 defined=1 locked=0
;      6: COMPUT    value=43657 defined=1 locked=0
;      7: NUMBER    value=43547 defined=1 locked=0
;      8: TEXT3     value=43803 defined=1 locked=0
;      9: TEXTOUT2  value=43769 defined=1 locked=0
;     10: TEXT2     value=43792 defined=1 locked=0
;     11: NUMSIGN   value=43533 defined=1 locked=0
;     12: INPCLEAR  value=43208 defined=1 locked=0
;     13: INPOS     value=43255 defined=1 locked=0
;     14: INPC2     value=43214 defined=1 locked=0
;     15: INPC3     value=43219 defined=1 locked=0
;     16: DOWNDE    value=43383 defined=1 locked=0
;     17: IN1       value=43239 defined=1 locked=0
;     18: CURSOR    value=43264 defined=1 locked=0
;     19: IN2       value=43253 defined=1 locked=0
;     20: PPOS      value=43602 defined=1 locked=0
;     21: IN3       value=43266 defined=1 locked=0
;     22: CHAR      value=43593 defined=1 locked=0
;     23: INKEY     value=43404 defined=1 locked=0
;     24: CURSLEFT  value=43344 defined=1 locked=0
;     25: CURSRGHT  value=43349 defined=1 locked=0
;     26: BCKSPACE  value=43362 defined=1 locked=0
;     27: DELETE    value=43355 defined=1 locked=0
;     28: IN5       value=43336 defined=1 locked=0
;     29: BCK2      value=43366 defined=1 locked=0
;     30: DEL2      value=43372 defined=1 locked=0
;     31: DOWNDE2   value=43398 defined=1 locked=0
;     32: INKEY2    value=43422 defined=1 locked=0
;     33: READSIGN  value=43438 defined=1 locked=0
;     34: READNUM   value=43467 defined=1 locked=0
;     35: SWAPSIGN  value=43447 defined=1 locked=0
;     36: INVCHAR   value=43455 defined=1 locked=0
;     37: CODECHAR  value=43462 defined=1 locked=0
;     38: READNUM3  value=43495 defined=1 locked=0
;     39: READNUM4  value=43507 defined=1 locked=0
;     40: READNUM6  value=43513 defined=1 locked=0
;     41: READNUM5  value=43523 defined=1 locked=0
;     42: N1        value=43575 defined=1 locked=0
;     43: N2        value=43577 defined=1 locked=0
;     44: N3        value=43591 defined=1 locked=0
;     45: CHAR2     value=43608 defined=1 locked=0
;     46: CHAR3     value=43644 defined=1 locked=0
;     47: CHAR4     value=43639 defined=1 locked=0
;     48: SEEKCHAR  value=43650 defined=1 locked=0
;     49: COMPUT2   value=43664 defined=1 locked=0
;     50: MOD       value=43711 defined=1 locked=0
;     51: LOM       value=43732 defined=1 locked=0
;     52: KRAT      value=43738 defined=1 locked=0
;     53: PLUS      value=43759 defined=1 locked=0
;     54: MINUS     value=43755 defined=1 locked=0
;     55: MOD2      value=43718 defined=1 locked=0
;     56: MOD1      value=43729 defined=1 locked=0
;     57: KRAT2     value=43745 defined=1 locked=0
;     58: KRAT1     value=43752 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
RUN       ld hl,16384                    ; @0008 210a80013136333834c7
          ld de,16385                    ; @0012 11023136333835c5
          ld bc,6143                     ; @001A 010236313433c4
          ld (hl),l                      ; @0021 7500
          ldir                           ; @0023 b040
          ld bc,768                      ; @0025 0102373638c3
          ld (hl),56                     ; @002B 36013536c2
          ldir                           ; @0030 b040
                                         ; @0032 0030
MAIN      ld hx,31                       ; @0034 262980023331c4
          ld hl,6*32+20480               ; @003B 2102362a33322b3230343830ca
          call INPUT                     ; @0048 cd028003c2
          cp 7                           ; @004D fe0137c1
          ret z                          ; @0051 c800
                                         ; @0053 0030
          ld hl,TEXT1                    ; @0055 21028004c2
          call TEXTOUT                   ; @005A cd028005c2
                                         ; @005F 0030
          ld de,23296                    ; @0061 11023233323936c5
          call COMPUT                    ; @0069 cd028006c2
          push hl                        ; @006E e500
          call NUMBER                    ; @0070 cd028007c2
          ld hl,TEXT3                    ; @0075 21028008c2
          call TEXTOUT2                  ; @007A cd028009c2
                                         ; @007F 0030
          ld hl,TEXT2                    ; @0081 2102800ac2
          call TEXTOUT                   ; @0086 cd028005c2
                                         ; @008B 0030
          pop hl                         ; @008D e100
          call NUMSIGN                   ; @008F cd02800bc2
          ld hl,TEXT3                    ; @0094 21028008c2
          call TEXTOUT2                  ; @0099 cd028009c2
          jr MAIN                        ; @009E 18038002c2
                                         ; @00A3 0030
                                         ; @00A5 0030
                                         ; @00A7 0030
INPCLEAR  ld de,(INPOS+1)                ; @00A9 5b4a800c800d2b31c6
          ld c,16                        ; @00B2 0e013136c2
INPC2     ld b,hx                        ; @00B7 4428800ec2
          inc b                          ; @00BC 0400
          xor a                          ; @00BE af00
          push de                        ; @00C0 d500
                                         ; @00C2 0030
INPC3     ld (de),a                      ; @00C4 1208800fc2
          inc de                         ; @00C9 1300
          djnz INPC3                     ; @00CB 1003800fc2
          pop de                         ; @00D0 d100
          call DOWNDE                    ; @00D2 cd028010c2
          dec c                          ; @00D7 0d00
          jr nz,INPC2                    ; @00D9 2003800ec2
          ret                            ; @00DE c900
                                         ; @00E0 0030
                                         ; @00E2 0030
INPUT     ld (INPOS+1),hl                ; @00E4 220a8003800d2b31c6
          ld hl,23296                    ; @00ED 21023233323936c5
          ld b,hx                        ; @00F5 4420
IN1       ld (hl),32                     ; @00F7 360980113332c4
          inc hl                         ; @00FE 2300
          djnz IN1                       ; @0100 10038011c2
          ld (hl),b                      ; @0105 7000
                                         ; @0107 0030
          res 5,(iy+1)                   ; @0109 ae9431c1
          xor a                          ; @010D af00
          ld (CURSOR+1),a                ; @010F 320280122b31c4
                                         ; @0116 0030
IN2       ld b,hx                        ; @0118 44288013c2
INPOS     ld hl,0                        ; @011D 210a800d30c3
          ld (PPOS+1),hl                 ; @0123 220280142b31c4
          ld hl,23296                    ; @012A 21023233323936c5
                                         ; @0132 0030
CURSOR    ld c,0                         ; @0134 0e09801230c3
IN3       ld a,l                         ; @013A 7d088015c2
          cp c                           ; @013F b900
          ld a,"C"+128                   ; @0141 3e012243222b313238c7
          call z,CHAR                    ; @014B cc028016c2
                                         ; @0150 0030
          ld a,(hl)                      ; @0152 7e00
          call CHAR                      ; @0154 cd028016c2
                                         ; @0159 0030
          inc hl                         ; @015B 2300
          djnz IN3                       ; @015D 10038015c2
                                         ; @0162 0030
          ld a,l                         ; @0164 7d00
          cp c                           ; @0166 b900
          ld a,"<"+128                   ; @0168 3e01223c222b313238c7
          call z,CHAR                    ; @0172 cc028016c2
                                         ; @0177 0030
          call INKEY                     ; @0179 cd028017c2
          cp 7                           ; @017E fe0137c1
          ret z                          ; @0182 c800
          cp 13                          ; @0184 fe013133c2
          jr z,INPCLEAR                  ; @0189 2803800cc2
                                         ; @018E 0030
          ld hl,IN2                      ; @0190 21028013c2
          push hl                        ; @0195 e500
          ld hl,CURSOR+1                 ; @0197 210280122b31c4
          cp 8                           ; @019E fe0138c1
          jr z,CURSLEFT                  ; @01A2 28038018c2
          cp 9                           ; @01A7 fe0139c1
          jr z,CURSRGHT                  ; @01AB 28038019c2
          cp 12                          ; @01B0 fe013132c2
          jr z,BCKSPACE                  ; @01B5 2803801ac2
          cp 199                         ; @01BA fe01313939c3
          jr z,DELETE                    ; @01C0 2803801bc2
          cp 32                          ; @01C5 fe013332c2
          ret c                          ; @01CA d800
          cp 128                         ; @01CC fe01313238c3
          ret nc                         ; @01D2 d000
          ex af,af'                      ; @01D4 0800
                                         ; @01D6 0030
          ld a,(hl)                      ; @01D8 7e00
          cp hx                          ; @01DA bc20
          ret nc                         ; @01DC d000
                                         ; @01DE 0030
          inc (hl)                       ; @01E0 3400
          ld l,(hl)                      ; @01E2 6e00
          dec l                          ; @01E4 2d00
          ld h,23296/256                 ; @01E6 260132333239362f323536c9
                                         ; @01F2 0030
IN5       ld a,(hl)                      ; @01F4 7e08801cc2
          or a                           ; @01F9 b700
          ret z                          ; @01FB c800
          ex af,af'                      ; @01FD 0800
          ld (hl),a                      ; @01FF 7700
          inc hl                         ; @0201 2300
          jr IN5                         ; @0203 1803801cc2
                                         ; @0208 0030
                                         ; @020A 0030
CURSLEFT  ld a,(hl)                      ; @020C 7e088018c2
          or a                           ; @0211 b700
          ret z                          ; @0213 c800
          dec (hl)                       ; @0215 3500
          ret                            ; @0217 c900
                                         ; @0219 0030
                                         ; @021B 0030
CURSRGHT  ld a,(hl)                      ; @021D 7e088019c2
          cp hx                          ; @0222 bc20
          ret nc                         ; @0224 d000
          inc (hl)                       ; @0226 3400
          ret                            ; @0228 c900
                                         ; @022A 0030
                                         ; @022C 0030
DELETE    ld a,(hl)                      ; @022E 7e08801bc2
          cp hx                          ; @0233 bc20
          ret z                          ; @0235 c800
          inc a                          ; @0237 3c00
          jr BCK2                        ; @0239 1803801dc2
                                         ; @023E 0030
                                         ; @0240 0030
BCKSPACE  ld a,(hl)                      ; @0242 7e08801ac2
          or a                           ; @0247 b700
          ret z                          ; @0249 c800
                                         ; @024B 0030
          dec (hl)                       ; @024D 3500
                                         ; @024F 0030
BCK2      ld l,a                         ; @0251 6f08801dc2
          ld h,23296/256                 ; @0256 260132333239362f323536c9
          ld e,l                         ; @0262 5d00
          ld d,h                         ; @0264 5400
          dec e                          ; @0266 1d00
                                         ; @0268 0030
DEL2      ld a,(hl)                      ; @026A 7e08801ec2
          ldi                            ; @026F a040
          or a                           ; @0271 b700
          jr nz,DEL2                     ; @0273 2003801ec2
          ex de,hl                       ; @0278 eb00
          dec hl                         ; @027A 2b00
          ld (hl)," "                    ; @027C 3601222022c3
          ret                            ; @0282 c900
                                         ; @0284 0030
                                         ; @0286 0030
DOWNDE    inc d                          ; @0288 14088010c2
          ld a,d                         ; @028D 7a00
          and 7                          ; @028F e60137c1
          ret nz                         ; @0293 c000
          ld a,e                         ; @0295 7b00
          add a,32                       ; @0297 c6013332c2
          ld e,a                         ; @029C 5f00
          ld a,d                         ; @029E 7a00
          jr c,DOWNDE2                   ; @02A0 3803801fc2
          sub 8                          ; @02A5 d60138c1
          ld d,a                         ; @02A9 5700
DOWNDE2   cp 88                          ; @02AB fe09801f3838c4
          ret c                          ; @02B2 d800
          ld d,64                        ; @02B4 16013634c2
          ret                            ; @02B9 c900
                                         ; @02BB 0030
                                         ; @02BD 0030
INKEY     ei                             ; @02BF fb088017c2
          halt                           ; @02C4 7600
          bit 5,(iy+1)                   ; @02C6 6e9431c1
          jr z,INKEY                     ; @02CA 28038017c2
          res 5,(iy+1)                   ; @02CF ae9431c1
                                         ; @02D3 0030
          push bc                        ; @02D5 c500
          push hl                        ; @02D7 e500
                                         ; @02D9 0030
          ld hl,0                        ; @02DB 210230c1
          ld b,l                         ; @02DF 4500
INKEY2    ld a,(hl)                      ; @02E1 7e088020c2
          inc hl                         ; @02E6 2300
          and 24                         ; @02E8 e6013234c2
          or 4                           ; @02ED f60134c1
          out (254),a                    ; @02F1 d301323534c3
          djnz INKEY2                    ; @02F7 10038020c2
                                         ; @02FC 0030
          pop hl                         ; @02FE e100
          pop bc                         ; @0300 c100
                                         ; @0302 0030
          ld a,(23560)                   ; @0304 3a023233353630c5
          ret                            ; @030C c900
                                         ; @030E 0030
                                         ; @0310 0030
READSIGN  ld a,(de)                      ; @0312 1a088021c2
          cp "-"                         ; @0317 fe01222d22c3
          jr nz,READNUM                  ; @031D 20038022c2
          inc de                         ; @0322 1300
          call READNUM                   ; @0324 cd028022c2
SWAPSIGN  ld a,l                         ; @0329 7d088023c2
          cpl                            ; @032E 2f00
          ld l,a                         ; @0330 6f00
          ld a,h                         ; @0332 7c00
          cpl                            ; @0334 2f00
          ld h,a                         ; @0336 6700
          inc hl                         ; @0338 2300
          ret                            ; @033A c900
                                         ; @033C 0030
                                         ; @033E 0030
INVCHAR   ld a,(de)                      ; @0340 1a088024c2
          inc de                         ; @0345 1300
          inc de                         ; @0347 1300
          add a,128                      ; @0349 c601313238c3
          ld l,a                         ; @034F 6f00
          ret                            ; @0351 c900
                                         ; @0353 0030
                                         ; @0355 0030
CODECHAR  ld a,(de)                      ; @0357 1a088025c2
          inc de                         ; @035C 1300
          inc de                         ; @035E 1300
          ld l,a                         ; @0360 6f00
          ret                            ; @0362 c900
                                         ; @0364 0030
                                         ; @0366 0030
READNUM   ld a,(de)                      ; @0368 1a088022c2
          inc de                         ; @036D 1300
          ld hl,0                        ; @036F 210230c1
                                         ; @0373 0030
          cp """"                        ; @0375 fe0122222222c4
          jr z,CODECHAR                  ; @037C 28038025c2
                                         ; @0381 0030
          cp "'"                         ; @0383 fe01222722c3
          jr z,INVCHAR                   ; @0389 28038024c2
                                         ; @038E 0030
          ld b,16                        ; @0390 06013136c2
          cp "#"                         ; @0395 fe01222322c3
          jr z,READNUM3                  ; @039B 28038026c2
                                         ; @03A0 0030
          ld b,2                         ; @03A2 060132c1
          cp "%"                         ; @03A6 fe01222522c3
          jr z,READNUM3                  ; @03AC 28038026c2
                                         ; @03B1 0030
          ld b,10                        ; @03B3 06013130c2
          dec de                         ; @03B8 1b00
                                         ; @03BA 0030
READNUM3  ld a,(de)                      ; @03BC 1a088026c2
          sub "0"                        ; @03C1 d601223022c3
          cp 10                          ; @03C7 fe013130c2
          jr c,READNUM4                  ; @03CC 38038027c2
          sub "A"-"9"-1                  ; @03D1 d6012241222d2239222d31c9
          cp 10                          ; @03DD fe013130c2
          ret c                          ; @03E2 d800
                                         ; @03E4 0030
READNUM4  cp 16                          ; @03E6 fe0980273136c4
          jr c,READNUM6                  ; @03ED 38038028c2
          sub 32                         ; @03F2 d6013332c2
                                         ; @03F7 0030
READNUM6  cp 16                          ; @03F9 fe0980283136c4
          ret nc                         ; @0400 d000
                                         ; @0402 0030
          inc de                         ; @0404 1300
          push de                        ; @0406 d500
                                         ; @0408 0030
          ex de,hl                       ; @040A eb00
          ld hl,0                        ; @040C 210230c1
                                         ; @0410 0030
          push bc                        ; @0412 c500
READNUM5  add hl,de                      ; @0414 19088029c2
          djnz READNUM5                  ; @0419 10038029c2
          ld d,b                         ; @041E 5000
          pop bc                         ; @0420 c100
                                         ; @0422 0030
          ld e,a                         ; @0424 5f00
          add hl,de                      ; @0426 1900
                                         ; @0428 0030
          pop de                         ; @042A d100
          jr READNUM3                    ; @042C 18038026c2
                                         ; @0431 0030
                                         ; @0433 0030
NUMSIGN   bit 7,h                        ; @0435 7c88800bc2
          jr z,NUMBER                    ; @043A 28038007c2
          call SWAPSIGN                  ; @043F cd028023c2
          push hl                        ; @0444 e500
          ld a,"-"                       ; @0446 3e01222d22c3
          call CHAR                      ; @044C cd028016c2
          pop hl                         ; @0451 e100
                                         ; @0453 0030
NUMBER    ld de,10000                    ; @0455 110a80073130303030c7
          ld b,0                         ; @045F 060130c1
          call N1                        ; @0463 cd02802ac2
          ld de,1000                     ; @0468 110231303030c4
          call N1                        ; @046F cd02802ac2
          ld de,100                      ; @0474 1102313030c3
          call N1                        ; @047A cd02802ac2
          ld e,10                        ; @047F 1e013130c2
          call N1                        ; @0484 cd02802ac2
          ld b,1                         ; @0489 060131c1
          ld e,b                         ; @048D 5800
                                         ; @048F 0030
N1        ld a,"0"-1                     ; @0491 3e09802a2230222d31c7
N2        inc a                          ; @049B 3c08802bc2
          or a                           ; @04A0 b700
          sbc hl,de                      ; @04A2 5240
          jr nc,N2                       ; @04A4 3003802bc2
          add hl,de                      ; @04A9 1900
                                         ; @04AB 0030
          cp "0"                         ; @04AD fe01223022c3
          jr nz,N3                       ; @04B3 2003802cc2
          bit 0,b                        ; @04B8 4080
          ret z                          ; @04BA c800
                                         ; @04BC 0030
N3        ld b,1                         ; @04BE 0609802c31c3
                                         ; @04C4 0030
CHAR      exx                            ; @04C6 d9088016c2
                                         ; @04CB 0030
          add a,a                        ; @04CD 8700
          ld l,a                         ; @04CF 6f00
          sbc a,a                        ; @04D1 9f00
          ld c,a                         ; @04D3 4f00
          ld h,15                        ; @04D5 26013135c2
          add hl,hl                      ; @04DA 2900
          add hl,hl                      ; @04DC 2900
                                         ; @04DE 0030
PPOS      ld de,16384                    ; @04E0 110a80143136333834c7
          push de                        ; @04EA d500
          ld b,8                         ; @04EC 060138c1
                                         ; @04F0 0030
CHAR2     ld a,(hl)                      ; @04F2 7e08802dc2
          rrca                           ; @04F7 0f00
          or (hl)                        ; @04F9 b600
          xor c                          ; @04FB a900
          ld (de),a                      ; @04FD 1200
          call DOWNDE                    ; @04FF cd028010c2
          ld a,(hl)                      ; @0504 7e00
          xor c                          ; @0506 a900
          ld (de),a                      ; @0508 1200
          call DOWNDE                    ; @050A cd028010c2
          inc hl                         ; @050F 2300
          djnz CHAR2                     ; @0511 1003802dc2
                                         ; @0516 0030
          pop de                         ; @0518 d100
          inc e                          ; @051A 1c00
          ld a,e                         ; @051C 7b00
          and 31                         ; @051E e6013331c2
          jr nz,CHAR3                    ; @0523 2003802ec2
          dec e                          ; @0528 1d00
          ld a,e                         ; @052A 7b00
          and %11100000                  ; @052C e601253131313030303030c9
          ld e,a                         ; @0538 5f00
          ld b,16                        ; @053A 06013136c2
CHAR4     call DOWNDE                    ; @053F cd0a802f8010c4
          djnz CHAR4                     ; @0546 1003802fc2
CHAR3     ld (PPOS+1),de                 ; @054B 534a802e80142b31c6
                                         ; @0554 0030
          exx                            ; @0556 d900
          ret                            ; @0558 c900
                                         ; @055A 0030
                                         ; @055C 0030
SEEKCHAR  ld a,(de)                      ; @055E 1a088030c2
          cp " "                         ; @0563 fe01222022c3
          ret nz                         ; @0569 c000
          inc de                         ; @056B 1300
          jr SEEKCHAR                    ; @056D 18038030c2
                                         ; @0572 0030
                                         ; @0574 0030
COMPUT    call SEEKCHAR                  ; @0576 cd0a80068030c4
          call READSIGN                  ; @057D cd028021c2
          push de                        ; @0582 d500
                                         ; @0584 0030
COMPUT2   pop de                         ; @0586 d1088031c2
          call SEEKCHAR                  ; @058B cd028030c2
          or a                           ; @0590 b700
          ret z                          ; @0592 c800
                                         ; @0594 0030
          push af                        ; @0596 f500
          push hl                        ; @0598 e500
          inc de                         ; @059A 1300
          call SEEKCHAR                  ; @059C cd028030c2
          call READSIGN                  ; @05A1 cd028021c2
          pop bc                         ; @05A6 c100
          pop af                         ; @05A8 f100
          push de                        ; @05AA d500
          ld d,b                         ; @05AC 5000
          ld e,c                         ; @05AE 5900
                                         ; @05B0 0030
          ld bc,COMPUT2                  ; @05B2 01028031c2
          push bc                        ; @05B7 c500
                                         ; @05B9 0030
          ex de,hl                       ; @05BB eb00
          cp "?"                         ; @05BD fe01223f22c3
          jr z,MOD                       ; @05C3 28038032c2
                                         ; @05C8 0030
          cp "/"                         ; @05CA fe01222f22c3
          jr z,LOM                       ; @05D0 28038033c2
                                         ; @05D5 0030
          cp "*"                         ; @05D7 fe01222a22c3
          jr z,KRAT                      ; @05DD 28038034c2
                                         ; @05E2 0030
          cp "+"                         ; @05E4 fe01222b22c3
          jr z,PLUS                      ; @05EA 28038035c2
                                         ; @05EF 0030
          cp "-"                         ; @05F1 fe01222d22c3
          jr z,MINUS                     ; @05F7 28038036c2
                                         ; @05FC 0030
          pop af                         ; @05FE f100
          ret                            ; @0600 c900
                                         ; @0602 0030
                                         ; @0604 0030
MOD       ld a,h                         ; @0606 7c088032c2
          ld c,l                         ; @060B 4d00
          ld hl,0                        ; @060D 210230c1
          ld b,16                        ; @0611 06013136c2
MOD2      slia c                         ; @0616 31888037c2
          rla                            ; @061B 1700
          adc hl,hl                      ; @061D 6a40
          sbc hl,de                      ; @061F 5240
          jr nc,MOD1                     ; @0621 30038038c2
          add hl,de                      ; @0626 1900
          dec c                          ; @0628 0d00
MOD1      djnz MOD2                      ; @062A 100b80388037c4
          ret                            ; @0631 c900
                                         ; @0633 0030
                                         ; @0635 0030
LOM       call MOD                       ; @0637 cd0a80338032c4
          ld h,a                         ; @063E 6700
          ld l,c                         ; @0640 6900
          ret                            ; @0642 c900
                                         ; @0644 0030
                                         ; @0646 0030
KRAT      ld b,16                        ; @0648 060980343136c4
          ld a,h                         ; @064F 7c00
          ld c,l                         ; @0651 4d00
          ld hl,0                        ; @0653 210230c1
KRAT2     add hl,hl                      ; @0657 29088039c2
          rl c                           ; @065C 1180
          rla                            ; @065E 1700
          jr nc,KRAT1                    ; @0660 3003803ac2
          add hl,de                      ; @0665 1900
KRAT1     djnz KRAT2                     ; @0667 100b803a8039c4
          ret                            ; @066E c900
                                         ; @0670 0030
                                         ; @0672 0030
MINUS     or a                           ; @0674 b7088036c2
          sbc hl,de                      ; @0679 5240
          ret                            ; @067B c900
                                         ; @067D 0030
                                         ; @067F 0030
PLUS      add hl,de                      ; @0681 19088035c2
          ret                            ; @0686 c900
                                         ; @0688 0030
                                         ; @068A 0030
TEXTOUT   ld e,(hl)                      ; @068C 5e088005c2
          inc hl                         ; @0691 2300
          ld d,(hl)                      ; @0693 5600
          inc hl                         ; @0695 2300
          ld (PPOS+1),de                 ; @0697 534280142b31c4
                                         ; @069E 0030
TEXTOUT2  ld a,(hl)                      ; @06A0 7e088009c2
          and 127                        ; @06A5 e601313237c3
          call CHAR                      ; @06AB cd028016c2
          bit 7,(hl)                     ; @06B0 7e80
          inc hl                         ; @06B2 2300
          jr z,TEXTOUT2                  ; @06B4 28038009c2
          ret                            ; @06B9 c900
                                         ; @06BB 0030
                                         ; @06BD 0030
TEXT1     defw 18432+8                   ; @06BF 093f800431383433322b38c9
          defm 'Unsigned:'               ; @06CB 073727556e7369676e65643a27cb
                                         ; @06D9 0030
TEXT2     defw 18432+96+8                ; @06DB 093f800a31383433322b39362b38cc
          defm '  Signed:'               ; @06EA 07372720205369676e65643a27cb
                                         ; @06F8 0030
TEXT3     defm '      '                  ; @06FA 073f80082720202020202027ca
