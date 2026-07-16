; decoded from 020_+preruseni_t3_l1248_p1_0_p2_965.bin
; source_length=965 symbol_count=30 bridge=17ff
; symbols:
;      1: SPRITES   value=64000 defined=1 locked=0
;      2: WIDTH     value=    2 defined=1 locked=0
;      3: HEIGHT    value=   16 defined=1 locked=0
;      4: SPRLEN    value=   64 defined=1 locked=0
;      5: START     value=42202 defined=1 locked=0
;      6: LOOP1     value=42254 defined=1 locked=0
;      7: LOOP2     value=42259 defined=1 locked=0
;      8: XPOS      value=42261 defined=1 locked=0
;      9: DRAWSPR   value=42312 defined=1 locked=0
;     10: WAIT      value=42272 defined=1 locked=0
;     11: REDRAWSP  value=42411 defined=1 locked=0
;     12: SPACE     value=42558 defined=1 locked=0
;     13: DRS1      value=42330 defined=1 locked=0
;     14: DRS2      value=42367 defined=1 locked=0
;     15: DOWNDE    value=42436 defined=1 locked=0
;     16: RDRS1     value=42419 defined=1 locked=0
;     17: RDRS2     value=42422 defined=1 locked=0
;     18: DOWNDE2   value=42451 defined=1 locked=0
;     19: LOOP3     value=42304 defined=1 locked=0
;     20: SHIFT     value=42347 defined=1 locked=0
;     21: SCRADR    value=42369 defined=1 locked=0
;     22: DRS3      value=42353 defined=1 locked=0
;     23: INTRPT    value=42457 defined=1 locked=0
;     24: WAIT3     value=42468 defined=1 locked=0
;     25: WAIT2     value=42479 defined=1 locked=0
;     26: WAIT4     value=42490 defined=1 locked=0
;     27: FILL1     value=42509 defined=1 locked=0
;     28: WAIT5     value=42517 defined=1 locked=0
;     29: WAIT6     value=42525 defined=1 locked=0
;     30: WAIT8     value=42536 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
;nahrajte "birdspr" na 64000             ; @0008 01373b6e616872616a746520226269726473707222206e61203634303030dc
                                         ; @0027 0030
SPRITES   equ 64000                      ; @0029 033f80013634303030c7
WIDTH     equ 2                          ; @0033 033f800232c3
HEIGHT    equ 16                         ; @0039 033f80033136c4
SPRLEN    equ WIDTH*HEIGHT*2             ; @0040 033f800480022a80032a32c9
                                         ; @004C 0030
START     di                             ; @004E f3088005c2
          im 2                           ; @0053 5e40
          ld a,#FD                       ; @0055 3e01234644c3
          ld i,a                         ; @005B 4740
          ld hl,#FD00                    ; @005D 21022346443030c5
          ld de,#FD01                    ; @0065 11022346443031c5
          ld bc,256                      ; @006D 0102323536c3
          ld (hl),#FE                    ; @0073 3601234645c3
          ldir                           ; @0079 b040
          ld hl,#FEFE                    ; @007B 21022346454645c5
          ld (hl),195                    ; @0083 3601313935c3
          inc hl                         ; @0089 2300
          ld (hl),INTRPT?256             ; @008B 360180173f323536c6
          inc hl                         ; @0094 2300
          ld (hl),INTRPT/256             ; @0096 360180172f323536c6
                                         ; @009F 0030
          ld hl,16384                    ; @00A1 21023136333834c5
          ld de,16385                    ; @00A9 11023136333835c5
          ld bc,6144                     ; @00B1 010236313434c4
          ld (hl),255                    ; @00B8 3601323535c3
          ldir                           ; @00BE b040
          ld bc,767                      ; @00C0 0102373637c3
          ld (hl),56                     ; @00C6 36013536c2
          ldir                           ; @00CB b040
          ei                             ; @00CD fb00
                                         ; @00CF 0030
LOOP1     ld de,SPRITES                  ; @00D1 110a80068001c4
          ld b,4                         ; @00D8 060134c1
LOOP2     push de                        ; @00DC d5088007c2
          push bc                        ; @00E1 c500
XPOS      ld bc,20*256+8                 ; @00E3 010a800832302a3235362b38ca
          call DRAWSPR                   ; @00F0 cd028009c2
          xor a                          ; @00F5 af00
          out (254),a                    ; @00F7 d301323534c3
          ld b,5                         ; @00FD 060135c1
WAIT      halt                           ; @0101 7608800ac2
          djnz WAIT                      ; @0106 1003800ac2
          ld a,4                         ; @010B 3e0134c1
          out (254),a                    ; @010F d301323534c3
          call REDRAWSP                  ; @0115 cd02800bc2
          ld hl,XPOS+1                   ; @011A 210280082b31c4
          ld a,(hl)                      ; @0121 7e00
          add a,1                        ; @0123 c60131c1
          ld (hl),a                      ; @0127 7700
          pop bc                         ; @0129 c100
          pop de                         ; @012B d100
          ld hl,SPRLEN                   ; @012D 21028004c2
          add hl,de                      ; @0132 1900
          ex de,hl                       ; @0134 eb00
          ld a,b                         ; @0136 7800
          cp 2                           ; @0138 fe0132c1
          jr nz,LOOP3                    ; @013C 20038013c2
          ld de,SPRITES+SPRLEN           ; @0141 110280012b8004c5
LOOP3     djnz LOOP2                     ; @0149 100b80138007c4
                                         ; @0150 0030
          call 8020                      ; @0152 cd0238303230c4
          jr c,LOOP1                     ; @0159 38038006c2
          ret                            ; @015E c900
                                         ; @0160 0030
DRAWSPR   ld a,b                         ; @0162 78088009c2
          call #22B0                     ; @0167 cd022332324230c5
          ld (REDRAWSP+1),hl             ; @016F 2202800b2b31c4
          ex de,hl                       ; @0176 eb00
          ld (SHIFT+1),a                 ; @0178 320280142b31c4
          exx                            ; @017F d900
          ld de,SPACE                    ; @0181 1102800cc2
          exx                            ; @0186 d900
                                         ; @0188 0030
          ld b,HEIGHT                    ; @018A 06018003c2
DRS1      push bc                        ; @018F c508800dc2
          ld (SCRADR+1),de               ; @0194 534280152b31c4
          ld a,(hl)                      ; @019B 7e00
          inc hl                         ; @019D 2300
          ld d,(hl)                      ; @019F 5600
          inc hl                         ; @01A1 2300
          ld c,(hl)                      ; @01A3 4e00
          inc hl                         ; @01A5 2300
          ld e,(hl)                      ; @01A7 5e00
          inc hl                         ; @01A9 2300
          push hl                        ; @01AB e500
          ld hl,256*255                  ; @01AD 21023235362a323535c7
SHIFT     ld b,0                         ; @01B7 0609801430c3
          inc b                          ; @01BD 0400
          dec b                          ; @01BF 0500
          jr z,DRS2                      ; @01C1 2803800ec2
DRS3      scf                            ; @01C6 37088016c2
          rra                            ; @01CB 1f00
          rr d                           ; @01CD 1a80
          rr h                           ; @01CF 1c80
          srl c                          ; @01D1 3980
          rr e                           ; @01D3 1b80
          rr l                           ; @01D5 1d80
          djnz DRS3                      ; @01D7 10038016c2
DRS2      ld b,a                         ; @01DC 4708800ec2
          push hl                        ; @01E1 e500
SCRADR    ld hl,0                        ; @01E3 210a801530c3
          ld a,(hl)                      ; @01E9 7e00
          exx                            ; @01EB d900
          ld (de),a                      ; @01ED 1200
          inc de                         ; @01EF 1300
          exx                            ; @01F1 d900
          and b                          ; @01F3 a000
          or c                           ; @01F5 b100
          ld (hl),a                      ; @01F7 7700
          inc hl                         ; @01F9 2300
          ld a,(hl)                      ; @01FB 7e00
          exx                            ; @01FD d900
          ld (de),a                      ; @01FF 1200
          inc de                         ; @0201 1300
          exx                            ; @0203 d900
          and d                          ; @0205 a200
          or e                           ; @0207 b300
          ld (hl),a                      ; @0209 7700
          inc hl                         ; @020B 2300
          pop de                         ; @020D d100
          ld a,(hl)                      ; @020F 7e00
          exx                            ; @0211 d900
          ld (de),a                      ; @0213 1200
          inc de                         ; @0215 1300
          exx                            ; @0217 d900
          and d                          ; @0219 a200
          or e                           ; @021B b300
          ld (hl),a                      ; @021D 7700
          ld de,(SCRADR+1)               ; @021F 5b4280152b31c4
          call DOWNDE                    ; @0226 cd02800fc2
          pop hl                         ; @022B e100
          pop bc                         ; @022D c100
          djnz DRS1                      ; @022F 1003800dc2
          ret                            ; @0234 c900
                                         ; @0236 0030
REDRAWSP  ld de,0                        ; @0238 110a800b30c3
          ld hl,SPACE                    ; @023E 2102800cc2
          ld c,HEIGHT                    ; @0243 0e018003c2
RDRS1     ld b,WIDTH+1                   ; @0248 0609801080022b31c6
          push de                        ; @0251 d500
RDRS2     ld a,(hl)                      ; @0253 7e088011c2
          ld (de),a                      ; @0258 1200
          inc hl                         ; @025A 2300
          inc e                          ; @025C 1c00
          djnz RDRS2                     ; @025E 10038011c2
          pop de                         ; @0263 d100
          call DOWNDE                    ; @0265 cd02800fc2
          dec c                          ; @026A 0d00
          jr nz,RDRS1                    ; @026C 20038010c2
          ret                            ; @0271 c900
                                         ; @0273 0030
DOWNDE    inc d                          ; @0275 1408800fc2
          ld a,d                         ; @027A 7a00
          and 7                          ; @027C e60137c1
          ret nz                         ; @0280 c000
          ld a,e                         ; @0282 7b00
          add a,32                       ; @0284 c6013332c2
          ld e,a                         ; @0289 5f00
          ld a,d                         ; @028B 7a00
          jr c,DOWNDE2                   ; @028D 38038012c2
          sub 8                          ; @0292 d60138c1
          ld d,a                         ; @0296 5700
DOWNDE2   cp 88                          ; @0298 fe0980123838c4
          ret c                          ; @029F d800
          ld d,64                        ; @02A1 16013634c2
          ret                            ; @02A6 c900
                                         ; @02A8 0030
INTRPT    push af                        ; @02AA f5088017c2
          push bc                        ; @02AF c500
          push de                        ; @02B1 d500
          push hl                        ; @02B3 e500
                                         ; @02B5 0030
          ld a,1                         ; @02B7 3e0131c1
          out (254),a                    ; @02BB d301323534c3
          ld hl,757                      ; @02C1 2102373537c3
WAIT3     dec hl                         ; @02C7 2b088018c2
          inc h                          ; @02CC 2400
          dec h                          ; @02CE 2500
          jr nz,WAIT3                    ; @02D0 20038018c2
                                         ; @02D5 0030
          ld a,7                         ; @02D7 3e0137c1
          out (254),a                    ; @02DB d301323534c3
          ld b,33                        ; @02E1 06013333c2
WAIT2     djnz WAIT2                     ; @02E6 100b80198019c4
                                         ; @02ED 0030
          ld a,2                         ; @02EF 3e0132c1
          out (254),a                    ; @02F3 d301323534c3
          nop                            ; @02F9 0000
          nop                            ; @02FB 0000
          ld hl,312                      ; @02FD 2102333132c3
WAIT4     dec hl                         ; @0303 2b08801ac2
          inc h                          ; @0308 2400
          dec h                          ; @030A 2500
          jr nz,WAIT4                    ; @030C 2003801ac2
                                         ; @0311 0030
          ld a,r                         ; @0313 5f40
          and 7                          ; @0315 e60137c1
          ld c,a                         ; @0319 4f00
          rlca                           ; @031B 0700
          rlca                           ; @031D 0700
          rlca                           ; @031F 0700
          or c                           ; @0321 b100
          ld hl,22528+32                 ; @0323 210232323532382b3332c8
          ld b,32                        ; @032E 06013332c2
FILL1     ld (hl),a                      ; @0333 7708801bc2
          inc hl                         ; @0338 2300
          djnz FILL1                     ; @033A 1003801bc2
          out (254),a                    ; @033F d301323534c3
          ld b,135                       ; @0345 0601313335c3
WAIT5     djnz WAIT5                     ; @034B 100b801c801cc4
                                         ; @0352 0030
          ld a,1                         ; @0354 3e0131c1
          out (254),a                    ; @0358 d301323534c3
          ld b,0                         ; @035E 060130c1
WAIT6     djnz WAIT6                     ; @0362 100b801d801dc4
          nop                            ; @0369 0000
          nop                            ; @036B 0000
                                         ; @036D 0030
          ld a,7                         ; @036F 3e0137c1
          out (254),a                    ; @0373 d301323534c3
          ld hl,100                      ; @0379 2102313030c3
WAIT8     ld a,r                         ; @037F 5f48801ec2
          out (254),a                    ; @0384 d301323534c3
          dec hl                         ; @038A 2b00
          nop                            ; @038C 0000
          nop                            ; @038E 0000
          nop                            ; @0390 0000
          ld a,h                         ; @0392 7c00
          or l                           ; @0394 b500
          jr nz,WAIT8                    ; @0396 2003801ec2
                                         ; @039B 0030
          ld a,0                         ; @039D 3e0130c1
          out (254),a                    ; @03A1 d301323534c3
                                         ; @03A7 0030
          pop hl                         ; @03A9 e100
          pop de                         ; @03AB d100
          pop bc                         ; @03AD c100
          pop af                         ; @03AF f100
          ei                             ; @03B1 fb00
          ret                            ; @03B3 c900
                                         ; @03B5 0030
SPACE     defs WIDTH+1*HEIGHT*2          ; @03B7 083f800c80022b312a80032a32cb
