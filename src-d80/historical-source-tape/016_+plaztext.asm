; decoded from 016_+plaztext_t3_l1698_p1_65280_p2_1145.bin
; source_length=1145 symbol_count=56 bridge=cbff
; symbols:
;      1: VYSKA     value=   20 defined=0 locked=0
;      2: SIRKA     value=   25 defined=0 locked=0
;      3: DOWNHL    value=43117 defined=1 locked=0
;      4: DOWNHL2   value=43132 defined=1 locked=0
;      5: TEST      value=42710 defined=1 locked=0
;      6: UPHL      value=43096 defined=1 locked=0
;      7: UPHL2     value=43111 defined=1 locked=0
;      8: ROL_UP    value=42422 defined=0 locked=0
;      9: BUFFER    value=42603 defined=0 locked=0
;     10: RLU1      value=42435 defined=0 locked=0
;     11: RLCM      value=42449 defined=0 locked=0
;     12: ROL_DOWN  value=42478 defined=0 locked=0
;     13: RLD1      value=42491 defined=0 locked=0
;     14: ROL_RGHT  value=42314 defined=0 locked=0
;     15: RLR1      value=42319 defined=0 locked=0
;     16: RLR2      value=42322 defined=0 locked=0
;     17: ROL_LEFT  value=42368 defined=0 locked=0
;     18: RLL1      value=42373 defined=0 locked=0
;     19: RLL2      value=42376 defined=0 locked=0
;     20: ATTRADR   value=42828 defined=0 locked=0
;     21: DOWNCH    value=42836 defined=0 locked=0
;     22: LINE_BUF  value=42580 defined=0 locked=0
;     23: MOVELINE  value=42531 defined=0 locked=0
;     24: BUF_LINE  value=42450 defined=0 locked=0
;     25: BUF_LIN2  value=42459 defined=0 locked=0
;     26: UPCH      value=42851 defined=0 locked=0
;     27: SCR_UPLT  value=42507 defined=0 locked=0
;     28: SCRUL1    value=42512 defined=0 locked=0
;     29: MOVELNE2  value=42534 defined=0 locked=0
;     30: MOVELIN2  value=42538 defined=0 locked=0
;     31: ONE_BUF   value=42563 defined=0 locked=0
;     32: ONE_BU2   value=42566 defined=0 locked=0
;     33: LINE_BU2  value=42586 defined=0 locked=0
;     34: START     value=42685 defined=1 locked=0
;     35: TEXT      value=43026 defined=1 locked=0
;     36: TEXT2     value=42887 defined=1 locked=0
;     37: SCRLEFT   value=42987 defined=1 locked=0
;     38: SCRUP     value=42923 defined=1 locked=0
;     39: SCRRIGHT  value=43009 defined=1 locked=0
;     40: SCRDOWN   value=42955 defined=1 locked=0
;     41: TEST2     value=42916 defined=1 locked=0
;     42: TEXT1     value=42879 defined=1 locked=0
;     43: CHAR3     value=42892 defined=1 locked=0
;     44: CHAR      value=42906 defined=1 locked=0
;     45: SUP0      value=42924 defined=1 locked=0
;     46: SUP1      value=42936 defined=1 locked=0
;     47: SUP4      value=42932 defined=1 locked=0
;     48: SUP2      value=42946 defined=1 locked=0
;     49: SUP3      value=42952 defined=1 locked=0
;     50: SDOWN0    value=42957 defined=1 locked=0
;     51: SDOWN2    value=42978 defined=1 locked=0
;     52: SDOWN3    value=42984 defined=1 locked=0
;     53: SLEFT0    value=42995 defined=1 locked=0
;     54: SLEFT1    value=42998 defined=1 locked=0
;     55: SRIGHT0   value=43012 defined=1 locked=0
;     56: SRIGHT1   value=43015 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     im 1                           ; @0008 56488022c2
          ei                             ; @000D fb00
          ld hl,0                        ; @000F 210230c1
          ld de,16384                    ; @0013 11023136333834c5
          ld bc,6144                     ; @001B 010236313434c4
          ldir                           ; @0022 b040
                                         ; @0024 0030
          ld hl,TEXT                     ; @0026 21028023c2
          ld (TEXT1+1),hl                ; @002B 2202802a2b31c4
          ld (TEXT2+1),hl                ; @0032 220280242b31c4
                                         ; @0039 0030
          ld d,0                         ; @003B 160130c1
                                         ; @003F 0030
TEST      push de                        ; @0041 d5088005c2
          ld a,5                         ; @0046 3e0135c1
          out (254),a                    ; @004A d301323534c3
          halt                           ; @0050 7600
          ld a,7                         ; @0052 3e0137c1
          out (254),a                    ; @0056 d301323534c3
          ld hl,20480+10                 ; @005C 210232303438302b3130c8
          ld a,22                        ; @0067 3e013232c2
          call SCRLEFT                   ; @006C cd028025c2
                                         ; @0071 0030
          ld hl,18432+10                 ; @0073 210231383433322b3130c8
          ld a,9                         ; @007E 3e0139c1
          call SCRUP                     ; @0082 cd028026c2
                                         ; @0087 0030
          ld hl,18432+10                 ; @0089 210231383433322b3130c8
          ld a,10                        ; @0094 3e013130c2
          call SCRRIGHT                  ; @0099 cd028027c2
                                         ; @009E 0030
          ld hl,16384+19+64              ; @00A0 210231363338342b31392b3634cb
          ld a,7                         ; @00AE 3e0137c1
          call SCRUP                     ; @00B2 cd028026c2
                                         ; @00B7 0030
          ld hl,16384+64+7               ; @00B9 210231363338342b36342b37ca
          ld a,13                        ; @00C6 3e013133c2
          call SCRLEFT                   ; @00CB cd028025c2
                                         ; @00D0 0030
          ld hl,16384+64+7               ; @00D2 210231363338342b36342b37ca
          ld a,17                        ; @00DF 3e013137c2
          call SCRDOWN                   ; @00E4 cd028028c2
                                         ; @00E9 0030
          ld hl,20480+64+7               ; @00EB 210232303438302b36342b37ca
          ld a,24                        ; @00F8 3e013234c2
          call SCRRIGHT                  ; @00FD cd028027c2
                                         ; @0102 0030
          ld hl,20480+64+30              ; @0104 210232303438302b36342b3330cb
          ld a,4                         ; @0112 3e0134c1
          call SCRDOWN                   ; @0116 cd028028c2
                                         ; @011B 0030
          ld hl,20480+160+4              ; @011D 210232303438302b3136302b34cb
          ld a,27                        ; @012B 3e013237c2
          call SCRLEFT                   ; @0130 cd028025c2
          ld hl,20480+128+2              ; @0135 210232303438302b3132382b32cb
          ld a,3                         ; @0143 3e0133c1
          call SCRLEFT                   ; @0147 cd028025c2
          ld hl,20480+96+2               ; @014C 210232303438302b39362b32ca
          ld a,2                         ; @0159 3e0132c1
          call SCRLEFT                   ; @015D cd028025c2
          ld hl,20480+64+1               ; @0162 210232303438302b36342b31ca
          ld a,2                         ; @016F 3e0132c1
          call SCRLEFT                   ; @0173 cd028025c2
          ld hl,20480+32                 ; @0178 210232303438302b3332c8
          ld a,2                         ; @0183 3e0132c1
          call SCRLEFT                   ; @0187 cd028025c2
          ld hl,20480                    ; @018C 21023230343830c5
          ld a,1                         ; @0194 3e0131c1
          call SCRLEFT                   ; @0198 cd028025c2
                                         ; @019D 0030
          ld hl,20480+128+4              ; @019F 210232303438302b3132382b34cb
          ld a,3                         ; @01AD 3e0133c1
          call SCRUP                     ; @01B1 cd028026c2
          ld hl,20480+96+3               ; @01B6 210232303438302b39362b33ca
          ld a,3                         ; @01C3 3e0133c1
          call SCRUP                     ; @01C7 cd028026c2
          ld hl,20480+64+2               ; @01CC 210232303438302b36342b32ca
          ld a,3                         ; @01D9 3e0133c1
          call SCRUP                     ; @01DD cd028026c2
          ld hl,20480+32+1               ; @01E2 210232303438302b33322b31ca
          ld a,3                         ; @01EF 3e0133c1
          call SCRUP                     ; @01F3 cd028026c2
          ld hl,20480                    ; @01F8 21023230343830c5
          ld a,3                         ; @0200 3e0133c1
          call SCRUP                     ; @0204 cd028026c2
                                         ; @0209 0030
          pop af                         ; @020B f100
          inc a                          ; @020D 3c00
          cp 10                          ; @020F fe013130c2
          ld d,a                         ; @0214 5700
          jr nz,TEST2                    ; @0216 20038029c2
                                         ; @021B 0030
TEXT1     ld hl,0                        ; @021D 210a802a30c3
          ld a,(hl)                      ; @0223 7e00
          inc hl                         ; @0225 2300
          or a                           ; @0227 b700
          jr nz,CHAR3                    ; @0229 2003802bc2
TEXT2     ld hl,0                        ; @022E 210a802430c3
          ld a,(hl)                      ; @0234 7e00
          inc hl                         ; @0236 2300
CHAR3     ld (TEXT1+1),hl                ; @0238 220a802b802a2b31c6
          add a,a                        ; @0241 8700
          ld l,a                         ; @0243 6f00
          ld h,15                        ; @0245 26013135c2
          add hl,hl                      ; @024A 2900
          add hl,hl                      ; @024C 2900
          ld b,8                         ; @024E 060138c1
          ld de,20480+31                 ; @0252 110232303438302b3331c8
CHAR      ld a,(hl)                      ; @025D 7e08802cc2
          rrca                           ; @0262 0f00
          or (hl)                        ; @0264 b600
          ld (de),a                      ; @0266 1200
          inc hl                         ; @0268 2300
          inc d                          ; @026A 1400
          djnz CHAR                      ; @026C 1003802cc2
                                         ; @0271 0030
          ld d,0                         ; @0273 160130c1
                                         ; @0277 0030
TEST2     call 8020                      ; @0279 cd0a802938303230c6
          jp c,TEST                      ; @0282 da028005c2
          ret                            ; @0287 c900
                                         ; @0289 0030
                                         ; @028B 0030
SCRUP     ld b,a                         ; @028D 47088026c2
SUP0      ld e,l                         ; @0292 5d08802dc2
          ld d,h                         ; @0297 5400
          inc h                          ; @0299 2400
          ld a,h                         ; @029B 7c00
          and 7                          ; @029D e60137c1
          jr z,SUP1                      ; @02A1 2803802ec2
SUP4      ld a,(hl)                      ; @02A6 7e08802fc2
          ld (de),a                      ; @02AB 1200
          jr SUP0                        ; @02AD 1803802dc2
                                         ; @02B2 0030
SUP1      ld a,l                         ; @02B4 7d08802ec2
          add a,32                       ; @02B9 c6013332c2
          ld l,a                         ; @02BE 6f00
          ld a,h                         ; @02C0 7c00
          jr c,SUP2                      ; @02C2 38038030c2
          sub 8                          ; @02C7 d60138c1
          ld h,a                         ; @02CB 6700
SUP2      cp 88                          ; @02CD fe0980303838c4
          jr c,SUP3                      ; @02D4 38038031c2
          ld h,66                        ; @02D9 26013636c2
SUP3      djnz SUP4                      ; @02DE 100b8031802fc4
          ret                            ; @02E5 c900
                                         ; @02E7 0030
SCRDOWN   ld b,a                         ; @02E9 47088028c2
          ld c,(hl)                      ; @02EE 4e00
SDOWN0    inc h                          ; @02F0 24088032c2
          ld a,(hl)                      ; @02F5 7e00
          ld (hl),c                      ; @02F7 7100
          ld c,a                         ; @02F9 4f00
          ld a,h                         ; @02FB 7c00
          and 7                          ; @02FD e60137c1
          cp 7                           ; @0301 fe0137c1
          jr nz,SDOWN0                   ; @0305 20038032c2
          ld a,l                         ; @030A 7d00
          add a,32                       ; @030C c6013332c2
          ld l,a                         ; @0311 6f00
          ld a,h                         ; @0313 7c00
          jr c,SDOWN2                    ; @0315 38038033c2
          sub 8                          ; @031A d60138c1
          ld h,a                         ; @031E 6700
SDOWN2    cp 88                          ; @0320 fe0980333838c4
          jr c,SDOWN3                    ; @0327 38038034c2
          ld h,66                        ; @032C 26013636c2
SDOWN3    djnz SDOWN0                    ; @0331 100b80348032c4
          ret                            ; @0338 c900
                                         ; @033A 0030
SCRLEFT   ld c,a                         ; @033C 4f088025c2
          dec c                          ; @0341 0d00
          ld b,0                         ; @0343 060130c1
          add hl,bc                      ; @0347 0900
          ld d,a                         ; @0349 5700
          ld c,8                         ; @034B 0e0138c1
SLEFT0    push hl                        ; @034F e5088035c2
          ld b,d                         ; @0354 4200
          xor a                          ; @0356 af00
SLEFT1    rl (hl)                        ; @0358 16888036c2
          dec l                          ; @035D 2d00
          djnz SLEFT1                    ; @035F 10038036c2
          pop hl                         ; @0364 e100
          inc h                          ; @0366 2400
          dec c                          ; @0368 0d00
          jr nz,SLEFT0                   ; @036A 20038035c2
          ret                            ; @036F c900
                                         ; @0371 0030
SCRRIGHT  ld d,a                         ; @0373 57088027c2
          ld c,8                         ; @0378 0e0138c1
SRIGHT0   push hl                        ; @037C e5088037c2
          ld b,d                         ; @0381 4200
          xor a                          ; @0383 af00
SRIGHT1   rr (hl)                        ; @0385 1e888038c2
          inc l                          ; @038A 2c00
          djnz SRIGHT1                   ; @038C 10038038c2
          pop hl                         ; @0391 e100
          inc h                          ; @0393 2400
          dec c                          ; @0395 0d00
          jr nz,SRIGHT0                  ; @0397 20038037c2
          ret                            ; @039C c900
                                         ; @039E 0030
TEXT      defm "Toto je "                ; @03A0 073f802322546f746f206a652022cc
          defm "plazici se "             ; @03AF 073722706c617a6963692073652022cd
          defm "text z knihy "           ; @03BF 07372274657874207a206b6e6968792022cf
          defm "ASSEMBLER a "            ; @03D1 073722415353454d424c455220612022ce
          defm "ZX SPECTRUM "            ; @03E2 0737225a5820535045435452554d2022ce
          defm "(2).....     "           ; @03F3 0737222832292e2e2e2e2e202020202022cf
          defb 0                         ; @0405 063730c1
                                         ; @0409 0030
UPHL      ld a,h                         ; @040B 7c088006c2
          dec h                          ; @0410 2500
          and 7                          ; @0412 e60137c1
          ret nz                         ; @0416 c000
          ld a,l                         ; @0418 7d00
          sub 32                         ; @041A d6013332c2
          ld l,a                         ; @041F 6f00
          ld a,h                         ; @0421 7c00
          jr c,UPHL2                     ; @0423 38038007c2
          add a,8                        ; @0428 c60138c1
          ld h,a                         ; @042C 6700
UPHL2     cp 64                          ; @042E fe0980073634c4
          ret nc                         ; @0435 d000
          ld h,87                        ; @0437 26013837c2
          ret                            ; @043C c900
                                         ; @043E 0030
                                         ; @0440 0030
DOWNHL    inc h                          ; @0442 24088003c2
          ld a,h                         ; @0447 7c00
          and 7                          ; @0449 e60137c1
          ret nz                         ; @044D c000
          ld a,l                         ; @044F 7d00
          add a,32                       ; @0451 c6013332c2
          ld l,a                         ; @0456 6f00
          ld a,h                         ; @0458 7c00
          jr c,DOWNHL2                   ; @045A 38038004c2
          sub 8                          ; @045F d60138c1
          ld h,a                         ; @0463 6700
DOWNHL2   cp 88                          ; @0465 fe0980043838c4
          ret c                          ; @046C d800
          ld h,64                        ; @046E 26013634c2
          ret                            ; @0473 c900
                                         ; @0475 0030
                                         ; @0477 0030
