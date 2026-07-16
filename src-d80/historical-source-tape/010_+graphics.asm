; decoded from 010_+graphics_t3_l3010_p1_255_p2_2397.bin
; source_length=2397 symbol_count=63 bridge=3cff
; symbols:
;      1: DOWNHL    value=44851 defined=1 locked=0
;      2: DOWNHL2   value=44866 defined=1 locked=0
;      3: UPHL      value=44830 defined=1 locked=0
;      4: UPHL2     value=44845 defined=1 locked=0
;      5: START     value=43997 defined=1 locked=0
;      6: MAKETAB   value=44782 defined=1 locked=0
;      7: PLOT3     value=44416 defined=1 locked=0
;      8: RANDOM    value=44802 defined=1 locked=0
;      9: SCRNADRS  value=45056 defined=1 locked=0
;     10: TABLE     value=45568 defined=1 locked=0
;     11: MAKETAB2  value=44790 defined=1 locked=0
;     12: AB        value=44826 defined=1 locked=0
;     13: LAST      value=44872 defined=1 locked=0
;     14: A0LEN     value=  875 defined=1 locked=0
;     15: LASTXY    value=44384 defined=1 locked=0
;     16: DRAW      value=44347 defined=1 locked=0
;     17: DLLARGER  value=44364 defined=1 locked=0
;     18: DLXGTY    value=44357 defined=1 locked=0
;     19: DLLOOP    value=44367 defined=1 locked=0
;     20: DLDIAG    value=44373 defined=1 locked=0
;     21: DLHRVT    value=44380 defined=1 locked=0
;     22: DLRANGE   value=44412 defined=1 locked=0
;     23: DLERR     value=44414 defined=1 locked=0
;     24: DLPLOT    value=44397 defined=1 locked=0
;     25: DRAWDOWN  value=44172 defined=1 locked=0
;     26: DRAWD2    value=44198 defined=1 locked=0
;     27: DRAWRGHT  value=44207 defined=1 locked=0
;     28: DRAWR2    value=44233 defined=1 locked=0
;     29: DRAWR3    value=44241 defined=1 locked=0
;     30: DRAWRFST  value=44244 defined=1 locked=0
;     31: DRAWRF3   value=44303 defined=1 locked=0
;     32: TABLE2    value=45576 defined=1 locked=0
;     33: DRAWRF2   value=44309 defined=1 locked=0
;     34: TABLE3    value=45584 defined=1 locked=0
;     35: CIRCLE    value=44446 defined=1 locked=0
;     36: SQUAREA   value=44765 defined=1 locked=0
;     37: SQROOT    value=44729 defined=1 locked=0
;     38: CIRCLE0   value=44528 defined=1 locked=0
;     39: CIRCLE2   value=44529 defined=1 locked=0
;     40: CIRCLE3   value=44650 defined=1 locked=0
;     41: SQR2      value=44732 defined=1 locked=0
;     42: SQR4      value=44740 defined=1 locked=0
;     43: SQR3      value=44745 defined=1 locked=0
;     44: SQ2       value=44773 defined=1 locked=0
;     45: SQ3       value=44778 defined=1 locked=0
;     46: RING      value=44657 defined=1 locked=0
;     47: RING2     value=44662 defined=1 locked=0
;     48: RING3     value=44721 defined=1 locked=0
;     49: LOOP0     value=44009 defined=1 locked=0
;     50: LOOP1     value=44013 defined=1 locked=0
;     51: LOOP3     value=44032 defined=1 locked=0
;     52: LOOP4     value=44048 defined=1 locked=0
;     53: STEP      value=    5 defined=1 locked=0
;     54: LOOP      value=44060 defined=1 locked=0
;     55: LOOP2     value=44076 defined=1 locked=0
;     56: RANDRAW   value=44127 defined=1 locked=0
;     57: LOOP5     value=44098 defined=1 locked=0
;     58: LOOP8     value=44115 defined=1 locked=0
;     59: LOOP6     value=44154 defined=1 locked=0
;     60: LOOP7     value=44155 defined=1 locked=0
;     61: DRAWTO    value=44323 defined=1 locked=0
;     62: DRAWTO2   value=44337 defined=1 locked=0
;     63: DRAWTO3   value=44346 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     im 1                           ; @0008 56488005c2
          ei                             ; @000D fb00
          call MAKETAB                   ; @000F cd028006c2
                                         ; @0014 0030
          ld a,4                         ; @0016 3e0134c1
          out (254),a                    ; @001A d301323534c3
                                         ; @0020 0030
          ld b,10                        ; @0022 06013130c2
LOOP0     push bc                        ; @0027 c5088031c2
                                         ; @002C 0030
          ld bc,0                        ; @002E 010230c1
LOOP1     push bc                        ; @0032 c5088032c2
          ld a,0                         ; @0037 3e0130c1
          call DRAWRFST                  ; @003B cd02801ec2
          pop bc                         ; @0040 c100
          inc b                          ; @0042 0400
          ld a,b                         ; @0044 7800
          cp 192                         ; @0046 fe01313932c3
          jr c,LOOP1                     ; @004C 38038032c2
                                         ; @0051 0030
          pop bc                         ; @0053 c100
          djnz LOOP0                     ; @0055 10038031c2
                                         ; @005A 0030
          ld bc,0                        ; @005C 010230c1
LOOP3     push bc                        ; @0060 c5088033c2
          ld a,0                         ; @0065 3e0130c1
          call DRAWRGHT                  ; @0069 cd02801bc2
          pop bc                         ; @006E c100
          inc b                          ; @0070 0400
          ld a,b                         ; @0072 7800
          cp 192                         ; @0074 fe01313932c3
          jr c,LOOP3                     ; @007A 38038033c2
                                         ; @007F 0030
          ld bc,0                        ; @0081 010230c1
LOOP4     push bc                        ; @0085 c5088034c2
          ld a,192                       ; @008A 3e01313932c3
          call DRAWDOWN                  ; @0090 cd028019c2
          pop bc                         ; @0095 c100
          inc c                          ; @0097 0c00
          jr nz,LOOP4                    ; @0099 20038034c2
                                         ; @009E 0030
STEP      equ 5                          ; @00A0 033f803535c3
                                         ; @00A6 0030
          ld a,0                         ; @00A8 3e0130c1
LOOP      push af                        ; @00AC f5088036c2
          ld de,96*256+128               ; @00B1 110239362a3235362b313238ca
          call CIRCLE                    ; @00BE cd028023c2
          pop af                         ; @00C3 f100
          add a,STEP                     ; @00C5 c6018035c2
          cp 96                          ; @00CA fe013936c2
          jr c,LOOP                      ; @00CF 38038036c2
                                         ; @00D4 0030
          ld a,0                         ; @00D6 3e0130c1
LOOP2     push af                        ; @00DA f5088037c2
          ld de,96*256+128               ; @00DF 110239362a3235362b313238ca
          call CIRCLE                    ; @00EC cd028023c2
          pop af                         ; @00F1 f100
          add a,STEP                     ; @00F3 c6018035c2
          cp 96                          ; @00F8 fe013936c2
          jr c,LOOP2                     ; @00FD 38038037c2
                                         ; @0102 0030
          call RANDRAW                   ; @0104 cd028038c2
                                         ; @0109 0030
          ld a,1                         ; @010B 3e0131c1
          ld de,96*256+50                ; @010F 110239362a3235362b3530c9
LOOP5     push af                        ; @011B f5088039c2
          push de                        ; @0120 d500
          call RING                      ; @0122 cd02802ec2
          pop de                         ; @0127 d100
          inc e                          ; @0129 1c00
          pop af                         ; @012B f100
          add a,1                        ; @012D c60131c1
          cp 96                          ; @0131 fe013936c2
          jr c,LOOP5                     ; @0136 38038039c2
                                         ; @013B 0030
          dec e                          ; @013D 1d00
          ld a,95                        ; @013F 3e013935c2
LOOP8     push af                        ; @0144 f508803ac2
          push de                        ; @0149 d500
          call RING                      ; @014B cd02802ec2
          pop de                         ; @0150 d100
          dec e                          ; @0152 1d00
          pop af                         ; @0154 f100
          sub 1                          ; @0156 d60131c1
          jr nc,LOOP8                    ; @015A 3003803ac2
                                         ; @015F 0030
RANDRAW   ld bc,0                        ; @0161 010a803830c3
          ld (LASTXY+1),bc               ; @0167 4342800f2b31c4
          call PLOT3                     ; @016E cd028007c2
                                         ; @0173 0030
          ld bc,191*256+255              ; @0175 01023139312a3235362b323535cb
          ld de,257                      ; @0183 1102323537c3
          call DRAW                      ; @0189 cd028010c2
                                         ; @018E 0030
          ld b,20                        ; @0190 06013230c2
          ld hl,0                        ; @0195 210230c1
          ld (RANDOM+1),hl               ; @0199 220280082b31c4
LOOP6     push bc                        ; @01A0 c508803bc2
LOOP7     call RANDOM                    ; @01A5 cd0a803c8008c4
          ld a,h                         ; @01AC 7c00
          cp 192                         ; @01AE fe01313932c3
          jr nc,LOOP7                    ; @01B4 3003803cc2
          ld b,h                         ; @01B9 4400
          ld c,l                         ; @01BB 4d00
          call DRAWTO                    ; @01BD cd02803dc2
          pop bc                         ; @01C2 c100
          djnz LOOP6                     ; @01C4 1003803bc2
          ret                            ; @01C9 c900
                                         ; @01CB 0030
                                         ; @01CD 0030
                                         ; @01CF 0030
DRAWDOWN  ld e,a                         ; @01D1 5f088019c2
          ld l,b                         ; @01D6 6800
          ld h,SCRNADRS/512              ; @01D8 260180092f353132c6
          add hl,hl                      ; @01E1 2900
          ld a,(hl)                      ; @01E3 7e00
          inc l                          ; @01E5 2c00
          ld h,(hl)                      ; @01E7 6600
          ld l,a                         ; @01E9 6f00
          ld a,c                         ; @01EB 7900
          rrca                           ; @01ED 0f00
          rrca                           ; @01EF 0f00
          rrca                           ; @01F1 0f00
          and 31                         ; @01F3 e6013331c2
          add a,l                        ; @01F8 8500
          ld l,a                         ; @01FA 6f00
          ld a,c                         ; @01FC 7900
          and 7                          ; @01FE e60137c1
          ld c,a                         ; @0202 4f00
          ld b,TABLE/256                 ; @0204 0601800a2f323536c6
          ld a,(bc)                      ; @020D 0a00
          ld c,a                         ; @020F 4f00
          ld b,e                         ; @0211 4300
DRAWD2    ld a,(hl)                      ; @0213 7e08801ac2
          xor c                          ; @0218 a900
          ld (hl),a                      ; @021A 7700
          call DOWNHL                    ; @021C cd028001c2
          djnz DRAWD2                    ; @0221 1003801ac2
          ret                            ; @0226 c900
                                         ; @0228 0030
DRAWRGHT  ld e,a                         ; @022A 5f08801bc2
          ld l,b                         ; @022F 6800
          ld h,SCRNADRS/512              ; @0231 260180092f353132c6
          add hl,hl                      ; @023A 2900
          ld a,(hl)                      ; @023C 7e00
          inc l                          ; @023E 2c00
          ld h,(hl)                      ; @0240 6600
          ld l,a                         ; @0242 6f00
          ld a,c                         ; @0244 7900
          rrca                           ; @0246 0f00
          rrca                           ; @0248 0f00
          rrca                           ; @024A 0f00
          and 31                         ; @024C e6013331c2
          add a,l                        ; @0251 8500
          ld l,a                         ; @0253 6f00
          ld a,c                         ; @0255 7900
          and 7                          ; @0257 e60137c1
          ld c,a                         ; @025B 4f00
          ld b,TABLE/256                 ; @025D 0601800a2f323536c6
          ld a,(bc)                      ; @0266 0a00
          ld c,a                         ; @0268 4f00
          ld b,e                         ; @026A 4300
DRAWR2    ld a,(hl)                      ; @026C 7e08801cc2
          xor c                          ; @0271 a900
          ld (hl),a                      ; @0273 7700
          rrc c                          ; @0275 0980
          jr nc,DRAWR3                   ; @0277 3003801dc2
          inc l                          ; @027C 2c00
DRAWR3    djnz DRAWR2                    ; @027E 100b801d801cc4
          ret                            ; @0285 c900
                                         ; @0287 0030
DRAWRFST  ld d,a                         ; @0289 5708801ec2
          ld l,b                         ; @028E 6800
          ld h,SCRNADRS/512              ; @0290 260180092f353132c6
          add hl,hl                      ; @0299 2900
          ld a,(hl)                      ; @029B 7e00
          inc l                          ; @029D 2c00
          ld h,(hl)                      ; @029F 6600
          ld l,a                         ; @02A1 6f00
          ld a,c                         ; @02A3 7900
          rrca                           ; @02A5 0f00
          rrca                           ; @02A7 0f00
          rrca                           ; @02A9 0f00
          and 31                         ; @02AB e6013331c2
          add a,l                        ; @02B0 8500
          ld l,a                         ; @02B2 6f00
          ld a,c                         ; @02B4 7900
          or d                           ; @02B6 b200
          ld e,255                       ; @02B8 1e01323535c3
          ld b,32                        ; @02BE 06013332c2
          jr z,DRAWRF3                   ; @02C3 2803801fc2
          ld a,c                         ; @02C8 7900
          and 7                          ; @02CA e60137c1
          add a,TABLE2-TABLE             ; @02CE c60180202d800ac5
          ld c,a                         ; @02D6 4f00
          ld b,TABLE2/256                ; @02D8 060180202f323536c6
          ld a,(bc)                      ; @02E1 0a00
          ld e,a                         ; @02E3 5f00
                                         ; @02E5 0030
          ld a,c                         ; @02E7 7900
          and 7                          ; @02E9 e60137c1
          add a,d                        ; @02ED 8200
          sub 8                          ; @02EF d60138c1
          ld d,a                         ; @02F3 5700
          jr c,DRAWRF2                   ; @02F5 38038021c2
                                         ; @02FA 0030
          ld a,(hl)                      ; @02FC 7e00
          xor e                          ; @02FE ab00
          ld (hl),a                      ; @0300 7700
          inc l                          ; @0302 2c00
                                         ; @0304 0030
          ld a,d                         ; @0306 7a00
          rra                            ; @0308 1f00
          rra                            ; @030A 1f00
          rra                            ; @030C 1f00
          and 31                         ; @030E e6013331c2
          ld e,255                       ; @0313 1e01323535c3
          jr z,DRAWRF2                   ; @0319 28038021c2
          ld b,a                         ; @031E 4700
                                         ; @0320 0030
DRAWRF3   ld a,(hl)                      ; @0322 7e08801fc2
          xor e                          ; @0327 ab00
          ld (hl),a                      ; @0329 7700
          inc l                          ; @032B 2c00
          djnz DRAWRF3                   ; @032D 1003801fc2
                                         ; @0332 0030
DRAWRF2   ld a,d                         ; @0334 7a088021c2
          and 7                          ; @0339 e60137c1
          ret z                          ; @033D c800
          add a,TABLE3-TABLE             ; @033F c60180222d800ac5
          ld c,a                         ; @0347 4f00
          ld b,TABLE3/256                ; @0349 060180222f323536c6
          ld a,(bc)                      ; @0352 0a00
          and e                          ; @0354 a300
          xor (hl)                       ; @0356 ae00
          ld (hl),a                      ; @0358 7700
          ret                            ; @035A c900
                                         ; @035C 0030
DRAWTO    ld hl,(LASTXY+1)               ; @035E 2a0a803d800f2b31c6
          ld de,257                      ; @0367 1102323537c3
          ld a,b                         ; @036D 7800
          sub h                          ; @036F 9400
          jr nc,DRAWTO2                  ; @0371 3003803ec2
          cpl                            ; @0376 2f00
          inc a                          ; @0378 3c00
          ld d,-1                        ; @037A 16012d31c2
DRAWTO2   ld b,a                         ; @037F 4708803ec2
          ld a,c                         ; @0384 7900
          sub l                          ; @0386 9500
          jr nc,DRAWTO3                  ; @0388 3003803fc2
          cpl                            ; @038D 2f00
          inc a                          ; @038F 3c00
          ld e,-1                        ; @0391 1e012d31c2
DRAWTO3   ld c,a                         ; @0396 4f08803fc2
                                         ; @039B 0030
DRAW      ld a,c                         ; @039D 79088010c2
          cp b                           ; @03A2 b800
          jr nc,DLXGTY                   ; @03A4 30038012c2
          ld l,c                         ; @03A9 6900
          push de                        ; @03AB d500
          xor a                          ; @03AD af00
          ld e,a                         ; @03AF 5f00
          jr DLLARGER                    ; @03B1 18038011c2
                                         ; @03B6 0030
DLXGTY    or c                           ; @03B8 b1088012c2
          ret z                          ; @03BD c800
          ld l,b                         ; @03BF 6800
          ld b,c                         ; @03C1 4100
          push de                        ; @03C3 d500
          ld d,0                         ; @03C5 160130c1
DLLARGER  ld h,b                         ; @03C9 60088011c2
          ld a,b                         ; @03CE 7800
          rra                            ; @03D0 1f00
DLLOOP    add a,l                        ; @03D2 85088013c2
          jr c,DLDIAG                    ; @03D7 38038014c2
          cp h                           ; @03DC bc00
          jr c,DLHRVT                    ; @03DE 38038015c2
DLDIAG    sub h                          ; @03E3 94088014c2
          ld c,a                         ; @03E8 4f00
          exx                            ; @03EA d900
          pop bc                         ; @03EC c100
          push bc                        ; @03EE c500
          jr LASTXY                      ; @03F0 1803800fc2
                                         ; @03F5 0030
DLHRVT    ld c,a                         ; @03F7 4f088015c2
          push de                        ; @03FC d500
          exx                            ; @03FE d900
          pop bc                         ; @0400 c100
LASTXY    ld hl,0                        ; @0402 210a800f30c3
          ld a,b                         ; @0408 7800
          add a,h                        ; @040A 8400
          ld b,a                         ; @040C 4700
          ld a,c                         ; @040E 7900
          inc a                          ; @0410 3c00
          add a,l                        ; @0412 8500
          jr c,DLRANGE                   ; @0414 38038016c2
          jr z,DLERR                     ; @0419 28038017c2
DLPLOT    dec a                          ; @041E 3d088018c2
          ld c,a                         ; @0423 4f00
          ld (LASTXY+1),bc               ; @0425 4342800f2b31c4
          call PLOT3                     ; @042C cd028007c2
          exx                            ; @0431 d900
          ld a,c                         ; @0433 7900
          djnz DLLOOP                    ; @0435 10038013c2
          pop de                         ; @043A d100
          ret                            ; @043C c900
                                         ; @043E 0030
DLRANGE   jr z,DLPLOT                    ; @0440 280b80168018c4
DLERR     pop af                         ; @0447 f1088017c2
          ret                            ; @044C c900
                                         ; @044E 0030
                                         ; @0450 0030
PLOT3     push de                        ; @0452 d5088007c2
          push hl                        ; @0457 e500
          ld l,b                         ; @0459 6800
          ld h,SCRNADRS/512              ; @045B 260180092f353132c6
          add hl,hl                      ; @0464 2900
          ld a,(hl)                      ; @0466 7e00
          inc l                          ; @0468 2c00
          ld h,(hl)                      ; @046A 6600
          ld l,a                         ; @046C 6f00
          ld a,c                         ; @046E 7900
          rrca                           ; @0470 0f00
          rrca                           ; @0472 0f00
          rrca                           ; @0474 0f00
          and 31                         ; @0476 e6013331c2
          add a,l                        ; @047B 8500
          ld l,a                         ; @047D 6f00
          ld a,c                         ; @047F 7900
          and 7                          ; @0481 e60137c1
          ld c,a                         ; @0485 4f00
          ld b,TABLE/256                 ; @0487 0601800a2f323536c6
          ld a,(bc)                      ; @0490 0a00
          xor (hl)                       ; @0492 ae00
          ld (hl),a                      ; @0494 7700
          pop hl                         ; @0496 e100
          pop de                         ; @0498 d100
          ret                            ; @049A c900
                                         ; @049C 0030
CIRCLE    call SQUAREA                   ; @049E cd0a80238024c4
          push hl                        ; @04A5 e500
          srl h                          ; @04A7 3c80
          rr l                           ; @04A9 1d80
          call SQROOT                    ; @04AB cd028025c2
          ld a,c                         ; @04B0 7900
          pop hl                         ; @04B2 e100
                                         ; @04B4 0030
          push af                        ; @04B6 f500
          inc a                          ; @04B8 3c00
          push af                        ; @04BA f500
          dec a                          ; @04BC 3d00
                                         ; @04BE 0030
          push hl                        ; @04C0 e500
          call SQUAREA                   ; @04C2 cd028024c2
          ld c,l                         ; @04C7 4d00
          ld b,h                         ; @04C9 4400
          pop hl                         ; @04CB e100
          or a                           ; @04CD b700
          push hl                        ; @04CF e500
          sbc hl,bc                      ; @04D1 4240
          call SQROOT                    ; @04D3 cd028025c2
          pop hl                         ; @04D8 e100
                                         ; @04DA 0030
          pop bc                         ; @04DC c100
          ld c,b                         ; @04DE 4800
          sub c                          ; @04E0 9100
          dec a                          ; @04E2 3d00
          jr nz,CIRCLE0                  ; @04E4 20038026c2
                                         ; @04E9 0030
          push bc                        ; @04EB c500
          ld a,d                         ; @04ED 7a00
          add a,b                        ; @04EF 8000
          ld b,a                         ; @04F1 4700
          ld a,e                         ; @04F3 7b00
          add a,c                        ; @04F5 8100
          ld c,a                         ; @04F7 4f00
          call PLOT3                     ; @04F9 cd028007c2
          pop bc                         ; @04FE c100
                                         ; @0500 0030
          push bc                        ; @0502 c500
          ld a,d                         ; @0504 7a00
          sub b                          ; @0506 9000
          ld b,a                         ; @0508 4700
          ld a,e                         ; @050A 7b00
          sub c                          ; @050C 9100
          ld c,a                         ; @050E 4f00
          call PLOT3                     ; @0510 cd028007c2
          pop bc                         ; @0515 c100
                                         ; @0517 0030
          push bc                        ; @0519 c500
          ld a,d                         ; @051B 7a00
          add a,b                        ; @051D 8000
          ld b,a                         ; @051F 4700
          ld a,e                         ; @0521 7b00
          sub c                          ; @0523 9100
          ld c,a                         ; @0525 4f00
          call PLOT3                     ; @0527 cd028007c2
          pop bc                         ; @052C c100
                                         ; @052E 0030
          push bc                        ; @0530 c500
          ld a,d                         ; @0532 7a00
          sub b                          ; @0534 9000
          ld b,a                         ; @0536 4700
          ld a,e                         ; @0538 7b00
          add a,c                        ; @053A 8100
          ld c,a                         ; @053C 4f00
          call PLOT3                     ; @053E cd028007c2
          pop bc                         ; @0543 c100
                                         ; @0545 0030
CIRCLE0   pop af                         ; @0547 f1088026c2
                                         ; @054C 0030
CIRCLE2   push af                        ; @054E f5088027c2
          push af                        ; @0553 f500
          push hl                        ; @0555 e500
          call SQUAREA                   ; @0557 cd028024c2
          ld c,l                         ; @055C 4d00
          ld b,h                         ; @055E 4400
          pop hl                         ; @0560 e100
          or a                           ; @0562 b700
          push hl                        ; @0564 e500
          sbc hl,bc                      ; @0566 4240
          call SQROOT                    ; @0568 cd028025c2
          ld b,a                         ; @056D 4700
          pop hl                         ; @056F e100
          pop af                         ; @0571 f100
          ld c,a                         ; @0573 4f00
                                         ; @0575 0030
          push bc                        ; @0577 c500
          ld a,d                         ; @0579 7a00
          add a,c                        ; @057B 8100
          ex af,af'                      ; @057D 0800
          ld a,e                         ; @057F 7b00
          add a,b                        ; @0581 8000
          ld c,a                         ; @0583 4f00
          ex af,af'                      ; @0585 0800
          ld b,a                         ; @0587 4700
          call PLOT3                     ; @0589 cd028007c2
          pop bc                         ; @058E c100
                                         ; @0590 0030
          push bc                        ; @0592 c500
          ld a,d                         ; @0594 7a00
          add a,b                        ; @0596 8000
          ld b,a                         ; @0598 4700
          ld a,e                         ; @059A 7b00
          add a,c                        ; @059C 8100
          ld c,a                         ; @059E 4f00
          call PLOT3                     ; @05A0 cd028007c2
          pop bc                         ; @05A5 c100
                                         ; @05A7 0030
          push bc                        ; @05A9 c500
          ld a,d                         ; @05AB 7a00
          add a,c                        ; @05AD 8100
          ex af,af'                      ; @05AF 0800
          ld a,e                         ; @05B1 7b00
          sub b                          ; @05B3 9000
          ld c,a                         ; @05B5 4f00
          ex af,af'                      ; @05B7 0800
          ld b,a                         ; @05B9 4700
          call PLOT3                     ; @05BB cd028007c2
          pop bc                         ; @05C0 c100
                                         ; @05C2 0030
          push bc                        ; @05C4 c500
          ld a,d                         ; @05C6 7a00
          sub b                          ; @05C8 9000
          ld b,a                         ; @05CA 4700
          ld a,e                         ; @05CC 7b00
          sub c                          ; @05CE 9100
          ld c,a                         ; @05D0 4f00
          call PLOT3                     ; @05D2 cd028007c2
          pop bc                         ; @05D7 c100
                                         ; @05D9 0030
          pop af                         ; @05DB f100
          push af                        ; @05DD f500
          or a                           ; @05DF b700
          jr z,CIRCLE3                   ; @05E1 28038028c2
                                         ; @05E6 0030
          push bc                        ; @05E8 c500
          ld a,d                         ; @05EA 7a00
          add a,b                        ; @05EC 8000
          ld b,a                         ; @05EE 4700
          ld a,e                         ; @05F0 7b00
          sub c                          ; @05F2 9100
          ld c,a                         ; @05F4 4f00
          call PLOT3                     ; @05F6 cd028007c2
          pop bc                         ; @05FB c100
                                         ; @05FD 0030
          push bc                        ; @05FF c500
          ld a,d                         ; @0601 7a00
          sub b                          ; @0603 9000
          ld b,a                         ; @0605 4700
          ld a,e                         ; @0607 7b00
          add a,c                        ; @0609 8100
          ld c,a                         ; @060B 4f00
          call PLOT3                     ; @060D cd028007c2
          pop bc                         ; @0612 c100
                                         ; @0614 0030
          push bc                        ; @0616 c500
          ld a,d                         ; @0618 7a00
          sub c                          ; @061A 9100
          ex af,af'                      ; @061C 0800
          ld a,e                         ; @061E 7b00
          add a,b                        ; @0620 8000
          ld c,a                         ; @0622 4f00
          ex af,af'                      ; @0624 0800
          ld b,a                         ; @0626 4700
          call PLOT3                     ; @0628 cd028007c2
          pop bc                         ; @062D c100
                                         ; @062F 0030
          push bc                        ; @0631 c500
          ld a,d                         ; @0633 7a00
          sub c                          ; @0635 9100
          ex af,af'                      ; @0637 0800
          ld a,e                         ; @0639 7b00
          sub b                          ; @063B 9000
          ld c,a                         ; @063D 4f00
          ex af,af'                      ; @063F 0800
          ld b,a                         ; @0641 4700
          call PLOT3                     ; @0643 cd028007c2
          pop bc                         ; @0648 c100
                                         ; @064A 0030
CIRCLE3   pop af                         ; @064C f1088028c2
          sub 1                          ; @0651 d60131c1
          jp nc,CIRCLE2                  ; @0655 d2028027c2
          ret                            ; @065A c900
                                         ; @065C 0030
RING      push af                        ; @065E f508802ec2
          call SQUAREA                   ; @0663 cd028024c2
          pop af                         ; @0668 f100
                                         ; @066A 0030
RING2     push hl                        ; @066C e508802fc2
          push af                        ; @0671 f500
          push af                        ; @0673 f500
          push hl                        ; @0675 e500
          call SQUAREA                   ; @0677 cd028024c2
          ld c,l                         ; @067C 4d00
          ld b,h                         ; @067E 4400
          pop hl                         ; @0680 e100
          or a                           ; @0682 b700
          push hl                        ; @0684 e500
          sbc hl,bc                      ; @0686 4240
          call SQROOT                    ; @0688 cd028025c2
          ld c,a                         ; @068D 4f00
          pop hl                         ; @068F e100
          pop af                         ; @0691 f100
          ld b,a                         ; @0693 4700
                                         ; @0695 0030
          push bc                        ; @0697 c500
          ld a,c                         ; @0699 7900
          add a,a                        ; @069B 8700
          ld l,a                         ; @069D 6f00
          ld a,d                         ; @069F 7a00
          sub b                          ; @06A1 9000
          ld b,a                         ; @06A3 4700
          ld a,e                         ; @06A5 7b00
          sub c                          ; @06A7 9100
          ld c,a                         ; @06A9 4f00
          push de                        ; @06AB d500
          ld a,l                         ; @06AD 7d00
          push hl                        ; @06AF e500
          call DRAWRFST                  ; @06B1 cd02801ec2
          pop hl                         ; @06B6 e100
          pop de                         ; @06B8 d100
          pop bc                         ; @06BA c100
                                         ; @06BC 0030
          pop af                         ; @06BE f100
          push af                        ; @06C0 f500
          or a                           ; @06C2 b700
          jr z,RING3                     ; @06C4 28038030c2
                                         ; @06C9 0030
          push bc                        ; @06CB c500
          ld a,d                         ; @06CD 7a00
          add a,b                        ; @06CF 8000
          ld b,a                         ; @06D1 4700
          ld a,e                         ; @06D3 7b00
          sub c                          ; @06D5 9100
          ld c,a                         ; @06D7 4f00
          push de                        ; @06D9 d500
          ld a,l                         ; @06DB 7d00
          call DRAWRFST                  ; @06DD cd02801ec2
          pop de                         ; @06E2 d100
          pop bc                         ; @06E4 c100
                                         ; @06E6 0030
RING3     pop af                         ; @06E8 f1088030c2
          pop hl                         ; @06ED e100
          sub 1                          ; @06EF d60131c1
          jp nc,RING2                    ; @06F3 d202802fc2
          ret                            ; @06F8 c900
                                         ; @06FA 0030
                                         ; @06FC 0030
SQROOT    xor a                          ; @06FE af088025c2
          push de                        ; @0703 d500
          push hl                        ; @0705 e500
SQR2      ld de,64                       ; @0707 110a80293634c4
          ld a,l                         ; @070E 7d00
          ld l,h                         ; @0710 6c00
          ld h,d                         ; @0712 6200
          ld b,8                         ; @0714 060138c1
SQR4      sbc hl,de                      ; @0718 5248802ac2
          jr nc,SQR3                     ; @071D 3003802bc2
          add hl,de                      ; @0722 1900
SQR3      ccf                            ; @0724 3f08802bc2
          rl d                           ; @0729 1280
          add a,a                        ; @072B 8700
          adc hl,hl                      ; @072D 6a40
          add a,a                        ; @072F 8700
          adc hl,hl                      ; @0731 6a40
          djnz SQR4                      ; @0733 1003802ac2
          xor a                          ; @0738 af00
          sub h                          ; @073A 9400
          ld a,0                         ; @073C 3e0130c1
          adc a,d                        ; @0740 8a00
          ld c,d                         ; @0742 4a00
          pop hl                         ; @0744 e100
          pop de                         ; @0746 d100
          ret                            ; @0748 c900
                                         ; @074A 0030
SQUAREA   ld b,8                         ; @074C 0609802438c3
          push de                        ; @0752 d500
          ld hl,0                        ; @0754 210230c1
          ld d,l                         ; @0758 5500
          ld e,a                         ; @075A 5f00
SQ2       add hl,hl                      ; @075C 2908802cc2
          rla                            ; @0761 1700
          jr nc,SQ3                      ; @0763 3003802dc2
          add hl,de                      ; @0768 1900
SQ3       djnz SQ2                       ; @076A 100b802d802cc4
          pop de                         ; @0771 d100
          ret                            ; @0773 c900
                                         ; @0775 0030
MAKETAB   ld b,192                       ; @0777 06098006313932c5
          ld de,16384                    ; @077F 11023136333834c5
          ld hl,SCRNADRS                 ; @0787 21028009c2
MAKETAB2  ld (hl),e                      ; @078C 7308800bc2
          inc hl                         ; @0791 2300
          ld (hl),d                      ; @0793 7200
          inc hl                         ; @0795 2300
          ex de,hl                       ; @0797 eb00
          call DOWNHL                    ; @0799 cd028001c2
          ex de,hl                       ; @079E eb00
          djnz MAKETAB2                  ; @07A0 1003800bc2
          ret                            ; @07A5 c900
                                         ; @07A7 0030
RANDOM    ld de,0                        ; @07A9 110a800830c3
          ld h,e                         ; @07AF 6300
          ld l,253                       ; @07B1 2e01323533c3
          ld a,d                         ; @07B7 7a00
          or a                           ; @07B9 b700
          sbc hl,de                      ; @07BB 5240
          sbc a,0                        ; @07BD de0130c1
          sbc hl,de                      ; @07C1 5240
          sbc a,0                        ; @07C3 de0130c1
          ld e,a                         ; @07C7 5f00
          ld d,0                         ; @07C9 160130c1
          sbc hl,de                      ; @07CD 5240
          jr nc,AB                       ; @07CF 3003800cc2
          inc hl                         ; @07D4 2300
AB        ld (RANDOM+1),hl               ; @07D6 220a800c80082b31c6
          ret                            ; @07DF c900
                                         ; @07E1 0030
UPHL      ld a,h                         ; @07E3 7c088003c2
          dec h                          ; @07E8 2500
          and 7                          ; @07EA e60137c1
          ret nz                         ; @07EE c000
          ld a,l                         ; @07F0 7d00
          sub 32                         ; @07F2 d6013332c2
          ld l,a                         ; @07F7 6f00
          ld a,h                         ; @07F9 7c00
          jr c,UPHL2                     ; @07FB 38038004c2
          add a,8                        ; @0800 c60138c1
          ld h,a                         ; @0804 6700
UPHL2     cp 64                          ; @0806 fe0980043634c4
          ret nc                         ; @080D d000
          ld h,87                        ; @080F 26013837c2
          ret                            ; @0814 c900
                                         ; @0816 0030
                                         ; @0818 0030
DOWNHL    inc h                          ; @081A 24088001c2
          ld a,h                         ; @081F 7c00
          and 7                          ; @0821 e60137c1
          ret nz                         ; @0825 c000
          ld a,l                         ; @0827 7d00
          add a,32                       ; @0829 c6013332c2
          ld l,a                         ; @082E 6f00
          ld a,h                         ; @0830 7c00
          jr c,DOWNHL2                   ; @0832 38038002c2
          sub 8                          ; @0837 d60138c1
          ld h,a                         ; @083B 6700
DOWNHL2   cp 88                          ; @083D fe0980023838c4
          ret c                          ; @0844 d800
          ld h,64                        ; @0846 26013634c2
          ret                            ; @084B c900
LAST                                     ; @084D 0038800dc2
A0LEN     equ $-START                    ; @0852 033f800e242d8005c6
                                         ; @085B 0030
          org LAST/512+1*512             ; @085D 0437800d2f3531322b312a353132cc
                                         ; @086C 0030
SCRNADRS  defs 512                       ; @086E 083f8009353132c5
                                         ; @0876 0030
TABLE     defb 128,64,32,16              ; @0878 063f800a3132382c36342c33322c3136ce
          defb 8,4,2,1                   ; @0889 0637382c342c322c31c7
                                         ; @0893 0030
TABLE2    defb %11111111                 ; @0895 063f8020253131313131313131cb
          defb %01111111                 ; @08A3 0637253031313131313131c9
          defb %00111111                 ; @08AF 0637253030313131313131c9
          defb %00011111                 ; @08BB 0637253030303131313131c9
          defb %00001111                 ; @08C7 0637253030303031313131c9
          defb %00000111                 ; @08D3 0637253030303030313131c9
          defb %00000011                 ; @08DF 0637253030303030303131c9
          defb %00000001                 ; @08EB 0637253030303030303031c9
                                         ; @08F7 0030
TABLE3    defb %00000000                 ; @08F9 063f8022253030303030303030cb
          defb %10000000                 ; @0907 0637253130303030303030c9
          defb %11000000                 ; @0913 0637253131303030303030c9
          defb %11100000                 ; @091F 0637253131313030303030c9
          defb %11110000                 ; @092B 0637253131313130303030c9
          defb %11111000                 ; @0937 0637253131313131303030c9
          defb %11111100                 ; @0943 0637253131313131313030c9
          defb %11111110                 ; @094F 0637253131313131313130c9
                                         ; @095B 0030
