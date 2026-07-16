; decoded from 034_+spriter_t3_l1557_p1_255_p2_1187.bin
; source_length=1187 symbol_count=42 bridge=77ff
; symbols:
;      1: DOWNHL    value=43362 defined=1 locked=0
;      2: DOWNHL2   value=43377 defined=1 locked=0
;      3: UPHL      value=43341 defined=1 locked=0
;      4: UPHL2     value=43356 defined=1 locked=0
;      5: DATA      value=50000 defined=1 locked=0
;      6: START     value=43000 defined=1 locked=0
;      7: MAIN2     value=43006 defined=1 locked=0
;      8: LAST      value=43060 defined=1 locked=0
;      9: MAIN      value=43010 defined=1 locked=0
;     10: WAIT      value=43011 defined=1 locked=0
;     11: WAIT2     value=43018 defined=1 locked=0
;     12: DRAWBOX   value=43288 defined=1 locked=0
;     13: ENTER     value=43244 defined=1 locked=0
;     14: CONTROLS  value=43405 defined=1 locked=0
;     15: NOWAIT    value=43076 defined=1 locked=0
;     16: FIRED     value=43165 defined=1 locked=0
;     17: LEFT      value=43099 defined=1 locked=0
;     18: WIDTH     value=43291 defined=1 locked=0
;     19: DOWN      value=43115 defined=1 locked=0
;     20: UP        value=43141 defined=1 locked=0
;     21: DOWNTEST  value=43119 defined=1 locked=0
;     22: END       value=43162 defined=1 locked=0
;     23: FLEFT     value=43187 defined=1 locked=0
;     24: FDOWN     value=43200 defined=1 locked=0
;     25: FUP       value=43226 defined=1 locked=0
;     26: HEIGHT    value=43302 defined=1 locked=0
;     27: FEND      value=43241 defined=1 locked=0
;     28: ENTER2    value=43253 defined=1 locked=0
;     29: ENTER3    value=43259 defined=1 locked=0
;     30: BEEP      value=43383 defined=1 locked=0
;     31: WAIT3     value=43282 defined=1 locked=0
;     32: DB1       value=43295 defined=1 locked=0
;     33: DB2       value=43307 defined=1 locked=0
;     34: DB3       value=43318 defined=1 locked=0
;     35: DB4       value=43334 defined=1 locked=0
;     36: BEEP9     value=43388 defined=1 locked=0
;     37: BEEP4     value=43390 defined=1 locked=0
;     38: BEEP3     value=43396 defined=1 locked=0
;     39: REDEFINE  value=43434 defined=1 locked=0
;     40: CLP       value=43411 defined=1 locked=0
;     41: NCPL      value=43422 defined=1 locked=0
;     42: CN        value=43428 defined=1 locked=0

                                         ; @0000 0030
          org 43000                      ; @0002 04373433303030c5
                                         ; @000A 0030
          ent $                          ; @000C 023724c1
                                         ; @0010 0030
DATA      equ 50000                      ; @0012 033f80053530303030c7
                                         ; @001C 0030
START     im 1                           ; @001E 56488006c2
          ld a,4                         ; @0023 3e0134c1
          out (254),a                    ; @0027 d301323534c3
MAIN2     xor a                          ; @002D af088007c2
          ld (LAST+1),a                  ; @0032 320280082b31c4
MAIN      ei                             ; @0039 fb088009c2
WAIT      ld b,1                         ; @003E 0609800a31c3
          ld a,1                         ; @0044 3e0131c1
          ld (WAIT+1),a                  ; @0048 3202800a2b31c4
WAIT2     push bc                        ; @004F c508800bc2
          halt                           ; @0054 7600
          call DRAWBOX                   ; @0056 cd02800cc2
          halt                           ; @005B 7600
          call DRAWBOX                   ; @005D cd02800cc2
          pop bc                         ; @0062 c100
          djnz WAIT2                     ; @0064 1003800bc2
          ld hl,(ENTER+1)                ; @0069 2a02800d2b31c4
          ld bc,DATA                     ; @0070 01028005c2
          or a                           ; @0075 b700
          sbc hl,bc                      ; @0077 4240
          ld b,h                         ; @0079 4400
          ld c,l                         ; @007B 4d00
          call 8020                      ; @007D cd0238303230c4
          ret nc                         ; @0084 d000
          ld a,191                       ; @0086 3e01313931c3
          in a,(254)                     ; @008C db01323534c3
          rra                            ; @0092 1f00
          jp nc,ENTER                    ; @0094 d202800dc2
          call CONTROLS                  ; @0099 cd02800ec2
          ld a,d                         ; @009E 7a00
          or a                           ; @00A0 b700
          jr z,MAIN2                     ; @00A2 28038007c2
                                         ; @00A7 0030
LAST      cp 0                           ; @00A9 fe09800830c3
          ld (LAST+1),a                  ; @00AF 320280082b31c4
          jr z,NOWAIT                    ; @00B6 2803800fc2
          cp 16                          ; @00BB fe013136c2
          jr z,NOWAIT                    ; @00C0 2803800fc2
          ld a,5                         ; @00C5 3e0135c1
          ld (WAIT+1),a                  ; @00C9 3202800a2b31c4
                                         ; @00D0 0030
NOWAIT    bit 4,d                        ; @00D2 6288800fc2
          jr nz,FIRED                    ; @00D7 20038010c2
                                         ; @00DC 0030
          bit 0,d                        ; @00DE 4280
          jr z,LEFT                      ; @00E0 28038011c2
          ld hl,(DRAWBOX+1)              ; @00E5 2a02800c2b31c4
          ld a,(WIDTH+1)                 ; @00EC 3a0280122b31c4
          add a,l                        ; @00F3 8500
          and 31                         ; @00F5 e6013331c2
          jr z,LEFT                      ; @00FA 28038011c2
          inc l                          ; @00FF 2c00
          ld (DRAWBOX+1),hl              ; @0101 2202800c2b31c4
                                         ; @0108 0030
LEFT      bit 1,d                        ; @010A 4a888011c2
          jr z,DOWN                      ; @010F 28038013c2
          ld hl,(DRAWBOX+1)              ; @0114 2a02800c2b31c4
          ld a,l                         ; @011B 7d00
          and 31                         ; @011D e6013331c2
          jr z,DOWN                      ; @0122 28038013c2
          dec l                          ; @0127 2d00
          ld (DRAWBOX+1),hl              ; @0129 2202800c2b31c4
                                         ; @0130 0030
DOWN      bit 2,d                        ; @0132 52888013c2
          jr z,UP                        ; @0137 28038014c2
DOWNTEST  ld hl,0                        ; @013C 210a801530c3
          ld a,h                         ; @0142 7c00
          sub 87                         ; @0144 d6013837c2
          ld c,a                         ; @0149 4f00
          ld a,l                         ; @014B 7d00
          and %11100000                  ; @014D e601253131313030303030c9
          sub %11100000                  ; @0159 d601253131313030303030c9
          or c                           ; @0165 b100
          ld hl,(DRAWBOX+1)              ; @0167 2a02800c2b31c4
          call nz,DOWNHL                 ; @016E c4028001c2
          ld (DRAWBOX+1),hl              ; @0173 2202800c2b31c4
                                         ; @017A 0030
UP        bit 3,d                        ; @017C 5a888014c2
          jr z,END                       ; @0181 28038016c2
          ld hl,(DRAWBOX+1)              ; @0186 2a02800c2b31c4
          ld a,l                         ; @018D 7d00
          and %11100000                  ; @018F e601253131313030303030c9
          ld c,a                         ; @019B 4f00
          ld a,h                         ; @019D 7c00
          sub 64                         ; @019F d6013634c2
          or c                           ; @01A4 b100
          call nz,UPHL                   ; @01A6 c4028003c2
          ld (DRAWBOX+1),hl              ; @01AB 2202800c2b31c4
                                         ; @01B2 0030
END       jp MAIN                        ; @01B4 c30a80168009c4
                                         ; @01BB 0030
                                         ; @01BD 0030
FIRED     bit 0,d                        ; @01BF 42888010c2
          jr z,FLEFT                     ; @01C4 28038017c2
          ld hl,(DRAWBOX+1)              ; @01C9 2a02800c2b31c4
          ld a,(WIDTH+1)                 ; @01D0 3a0280122b31c4
          add a,l                        ; @01D7 8500
          and 31                         ; @01D9 e6013331c2
          jr z,FLEFT                     ; @01DE 28038017c2
          ld a,(WIDTH+1)                 ; @01E3 3a0280122b31c4
          inc a                          ; @01EA 3c00
          ld (WIDTH+1),a                 ; @01EC 320280122b31c4
                                         ; @01F3 0030
FLEFT     bit 1,d                        ; @01F5 4a888017c2
          jr z,FDOWN                     ; @01FA 28038018c2
          ld a,(WIDTH+1)                 ; @01FF 3a0280122b31c4
          dec a                          ; @0206 3d00
          jr z,FDOWN                     ; @0208 28038018c2
          ld (WIDTH+1),a                 ; @020D 320280122b31c4
                                         ; @0214 0030
FDOWN     bit 2,d                        ; @0216 52888018c2
          jr z,FUP                       ; @021B 28038019c2
          ld hl,(DOWNTEST+1)             ; @0220 2a0280152b31c4
          ld a,h                         ; @0227 7c00
          sub 87                         ; @0229 d6013837c2
          ld c,a                         ; @022E 4f00
          ld a,l                         ; @0230 7d00
          and %11100000                  ; @0232 e601253131313030303030c9
          sub %11100000                  ; @023E d601253131313030303030c9
          or c                           ; @024A b100
          jr z,FUP                       ; @024C 28038019c2
          ld a,(HEIGHT+1)                ; @0251 3a02801a2b31c4
          inc a                          ; @0258 3c00
          ld (HEIGHT+1),a                ; @025A 3202801a2b31c4
                                         ; @0261 0030
FUP       bit 3,d                        ; @0263 5a888019c2
          jr z,FEND                      ; @0268 2803801bc2
          ld a,(HEIGHT+1)                ; @026D 3a02801a2b31c4
          dec a                          ; @0274 3d00
          cp 3                           ; @0276 fe0133c1
          jr c,FEND                      ; @027A 3803801bc2
          ld (HEIGHT+1),a                ; @027F 3202801a2b31c4
                                         ; @0286 0030
FEND      jp MAIN                        ; @0288 c30a801b8009c4
                                         ; @028F 0030
ENTER     ld de,DATA                     ; @0291 110a800d8005c4
          ld hl,(DRAWBOX+1)              ; @0298 2a02800c2b31c4
          ld a,(HEIGHT+1)                ; @029F 3a02801a2b31c4
ENTER2    push af                        ; @02A6 f508801cc2
          ld a,(WIDTH+1)                 ; @02AB 3a0280122b31c4
          ld b,a                         ; @02B2 4700
          push hl                        ; @02B4 e500
ENTER3    ld a,(hl)                      ; @02B6 7e08801dc2
          ld (de),a                      ; @02BB 1200
          inc hl                         ; @02BD 2300
          inc de                         ; @02BF 1300
          djnz ENTER3                    ; @02C1 1003801dc2
          pop hl                         ; @02C6 e100
          call DOWNHL                    ; @02C8 cd028001c2
          pop af                         ; @02CD f100
          dec a                          ; @02CF 3d00
          jr nz,ENTER2                   ; @02D1 2003801cc2
          ld (ENTER+1),de                ; @02D6 5342800d2b31c4
          call BEEP                      ; @02DD cd02801ec2
          ld b,30                        ; @02E2 06013330c2
WAIT3     halt                           ; @02E7 7608801fc2
          djnz WAIT3                     ; @02EC 1003801fc2
          jp MAIN                        ; @02F1 c3028009c2
                                         ; @02F6 0030
DRAWBOX   ld hl,16384                    ; @02F8 210a800c3136333834c7
WIDTH     ld b,4                         ; @0302 0609801234c3
          push bc                        ; @0308 c500
          push hl                        ; @030A e500
DB1       ld a,(hl)                      ; @030C 7e088020c2
          cpl                            ; @0311 2f00
          ld (hl),a                      ; @0313 7700
          inc l                          ; @0315 2c00
          djnz DB1                       ; @0317 10038020c2
          dec l                          ; @031C 2d00
HEIGHT    ld b,52                        ; @031E 0609801a3532c4
          dec b                          ; @0325 0500
          dec b                          ; @0327 0500
          push bc                        ; @0329 c500
DB2       call DOWNHL                    ; @032B cd0a80218001c4
          ld a,(hl)                      ; @0332 7e00
          xor 1                          ; @0334 ee0131c1
          ld (hl),a                      ; @0338 7700
          djnz DB2                       ; @033A 10038021c2
          pop bc                         ; @033F c100
          pop hl                         ; @0341 e100
DB3       call DOWNHL                    ; @0343 cd0a80228001c4
          ld a,(hl)                      ; @034A 7e00
          xor 128                        ; @034C ee01313238c3
          ld (hl),a                      ; @0352 7700
          djnz DB3                       ; @0354 10038022c2
          call DOWNHL                    ; @0359 cd028001c2
          ld (DOWNTEST+1),hl             ; @035E 220280152b31c4
          pop bc                         ; @0365 c100
DB4       ld a,(hl)                      ; @0367 7e088023c2
          cpl                            ; @036C 2f00
          ld (hl),a                      ; @036E 7700
          inc l                          ; @0370 2c00
          djnz DB4                       ; @0372 10038023c2
          ret                            ; @0377 c900
                                         ; @0379 0030
UPHL      ld a,h                         ; @037B 7c088003c2
          dec h                          ; @0380 2500
          and 7                          ; @0382 e60137c1
          ret nz                         ; @0386 c000
          ld a,l                         ; @0388 7d00
          sub 32                         ; @038A d6013332c2
          ld l,a                         ; @038F 6f00
          ld a,h                         ; @0391 7c00
          jr c,UPHL2                     ; @0393 38038004c2
          add a,8                        ; @0398 c60138c1
          ld h,a                         ; @039C 6700
UPHL2     cp 64                          ; @039E fe0980043634c4
          ret nc                         ; @03A5 d000
          ld h,87                        ; @03A7 26013837c2
          ret                            ; @03AC c900
                                         ; @03AE 0030
                                         ; @03B0 0030
DOWNHL    inc h                          ; @03B2 24088001c2
          ld a,h                         ; @03B7 7c00
          and 7                          ; @03B9 e60137c1
          ret nz                         ; @03BD c000
          ld a,l                         ; @03BF 7d00
          add a,32                       ; @03C1 c6013332c2
          ld l,a                         ; @03C6 6f00
          ld a,h                         ; @03C8 7c00
          jr c,DOWNHL2                   ; @03CA 38038002c2
          sub 8                          ; @03CF d60138c1
          ld h,a                         ; @03D3 6700
DOWNHL2   cp 88                          ; @03D5 fe0980023838c4
          ret c                          ; @03DC d800
          ld h,64                        ; @03DE 26013634c2
          ret                            ; @03E3 c900
                                         ; @03E5 0030
BEEP      push af                        ; @03E7 f508801ec2
          push bc                        ; @03EC c500
          push de                        ; @03EE d500
          ld b,0                         ; @03F0 060130c1
BEEP9     ld a,4                         ; @03F4 3e09802434c3
BEEP4     add a,8                        ; @03FA c609802538c3
          out (254),a                    ; @0400 d301323534c3
          ld c,10                        ; @0406 0e013130c2
BEEP3     dec c                          ; @040B 0d088026c2
          jr nz,BEEP3                    ; @0410 20038026c2
          djnz BEEP4                     ; @0415 10038025c2
          pop de                         ; @041A d100
          pop bc                         ; @041C c100
          pop af                         ; @041E f100
          ret                            ; @0420 c900
                                         ; @0422 0030
CONTROLS  ld hl,REDEFINE                 ; @0424 210a800e8027c4
          ld de,5                        ; @042B 110235c1
CLP       ld c,(hl)                      ; @042F 4e088028c2
          inc hl                         ; @0434 2300
          ld b,(hl)                      ; @0436 4600
          inc hl                         ; @0438 2300
          in a,(c)                       ; @043A 7840
          bit 7,c                        ; @043C 7980
          jr z,NCPL                      ; @043E 28038029c2
          cpl                            ; @0443 2f00
NCPL      and (hl)                       ; @0445 a6088029c2
          inc hl                         ; @044A 2300
          jr z,CN                        ; @044C 2803802ac2
          set 5,d                        ; @0451 ea80
CN        srl d                          ; @0453 3a88802ac2
          dec e                          ; @0458 1d00
          jr nz,CLP                      ; @045A 20038028c2
          ret                            ; @045F c900
                                         ; @0461 0030
REDEFINE  defb 254,223,1                 ; @0463 063f80273235342c3232332c31cb
          defb 254,223,2                 ; @0471 06373235342c3232332c32c9
          defb 254,253,1                 ; @047D 06373235342c3235332c31c9
          defb 254,251,1                 ; @0489 06373235342c3235312c31c9
          defb 254,127,4                 ; @0495 06373235342c3132372c34c9
                                         ; @04A1 0030
