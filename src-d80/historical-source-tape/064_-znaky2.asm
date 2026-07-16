; decoded from 064_-znaky2_t3_l1429_p1_0_p2_1171.bin
; source_length=1171 symbol_count=25 bridge=a2ff
; symbols:
;      1: START     value=42216 defined=1 locked=0
;      2: LOOP      value=42224 defined=1 locked=0
;      3: CHAR1     value=42298 defined=1 locked=0
;      4: CHARS     value=15360 defined=1 locked=0
;      5: PRINTPOS  value=42581 defined=1 locked=0
;      6: CHAR1A    value=42317 defined=1 locked=0
;      7: CHAR1B    value=42337 defined=1 locked=0
;      8: CHAR2     value=42344 defined=1 locked=0
;      9: CHAR2A    value=42363 defined=1 locked=0
;     10: CHAR2B    value=42385 defined=1 locked=0
;     11: LOOP2     value=42236 defined=1 locked=0
;     12: CHAR3     value=42392 defined=1 locked=0
;     13: CHAR3B    value=42461 defined=1 locked=0
;     14: LOOP3     value=42248 defined=1 locked=0
;     15: CHARC1    value=42468 defined=1 locked=0
;     16: CHARC1A   value=42487 defined=1 locked=0
;     17: CHARC1B   value=42524 defined=1 locked=0
;     18: LOOP4     value=42287 defined=1 locked=0
;     19: ATTRIBUT  value=42583 defined=1 locked=0
;     20: ADRSET    value=42531 defined=1 locked=0
;     21: SETINK    value=42547 defined=1 locked=0
;     22: STCOMMON  value=42567 defined=1 locked=0
;     23: SETPAPER  value=42551 defined=1 locked=0
;     24: SETBRGHT  value=42558 defined=1 locked=0
;     25: SETFLASH  value=42564 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld hl,16384                    ; @0008 210a80013136333834c7
          ld (PRINTPOS),hl               ; @0012 22028005c2
                                         ; @0017 0030
          ld a,32                        ; @0019 3e013332c2
LOOP      push af                        ; @001E f5088002c2
          call CHAR1                     ; @0023 cd028003c2
          pop af                         ; @0028 f100
          inc a                          ; @002A 3c00
          cp 128                         ; @002C fe01313238c3
          jr c,LOOP                      ; @0032 38038002c2
                                         ; @0037 0030
          ld a,32                        ; @0039 3e013332c2
LOOP2     push af                        ; @003E f508800bc2
          call CHAR2                     ; @0043 cd028008c2
          pop af                         ; @0048 f100
          inc a                          ; @004A 3c00
          cp 128                         ; @004C fe01313238c3
          jr c,LOOP2                     ; @0052 3803800bc2
                                         ; @0057 0030
          ld a,32                        ; @0059 3e013332c2
LOOP3     push af                        ; @005E f508800ec2
          call CHAR3                     ; @0063 cd02800cc2
          pop af                         ; @0068 f100
          inc a                          ; @006A 3c00
          cp 128                         ; @006C fe01313238c3
          jr c,LOOP3                     ; @0072 3803800ec2
                                         ; @0077 0030
          ld b,10                        ; @0079 06013130c2
          ld c,20                        ; @007E 0e013230c2
          call ADRSET                    ; @0083 cd028014c2
                                         ; @0088 0030
          ld a,4                         ; @008A 3e0134c1
          call SETPAPER                  ; @008E cd028017c2
          ld a,1                         ; @0093 3e0131c1
          call SETINK                    ; @0097 cd028015c2
          ld a,0                         ; @009C 3e0130c1
          call SETBRGHT                  ; @00A0 cd028018c2
          ld a,1                         ; @00A5 3e0131c1
          call SETFLASH                  ; @00A9 cd028019c2
                                         ; @00AE 0030
          ld a,32                        ; @00B0 3e013332c2
LOOP4     push af                        ; @00B5 f5088012c2
          call CHARC1                    ; @00BA cd02800fc2
          pop af                         ; @00BF f100
          inc a                          ; @00C1 3c00
          cp 128                         ; @00C3 fe01313238c3
          jr c,LOOP4                     ; @00C9 38038012c2
                                         ; @00CE 0030
          ret                            ; @00D0 c900
                                         ; @00D2 0030
                                         ; @00D4 0030
                                         ; @00D6 0030
                                         ; @00D8 0030
CHARS     equ 15616-256                  ; @00DA 033f800431353631362d323536cb
                                         ; @00E8 0030
                                         ; @00EA 0030
;tisk znaku 1 - standardni               ; @00EC 01373b7469736b207a6e616b752031202d207374616e646172646e69da
                                         ; @0109 0030
CHAR1     push af                        ; @010B f5088003c2
          exx                            ; @0110 d900
                                         ; @0112 0030
          ld l,a                         ; @0114 6f00
          ld h,0                         ; @0116 260130c1
          add hl,hl                      ; @011A 2900
          add hl,hl                      ; @011C 2900
          add hl,hl                      ; @011E 2900
          ld bc,CHARS                    ; @0120 01028004c2
          add hl,bc                      ; @0125 0900
                                         ; @0127 0030
          ld de,(PRINTPOS)               ; @0129 5b428005c2
          push de                        ; @012E d500
                                         ; @0130 0030
          ld b,8                         ; @0132 060138c1
CHAR1A    ld a,(hl)                      ; @0136 7e088006c2
          ld (de),a                      ; @013B 1200
          inc hl                         ; @013D 2300
          inc d                          ; @013F 1400
          djnz CHAR1A                    ; @0141 10038006c2
                                         ; @0146 0030
          pop de                         ; @0148 d100
          inc e                          ; @014A 1c00
          jr nz,CHAR1B                   ; @014C 20038007c2
          ld a,d                         ; @0151 7a00
          add a,8                        ; @0153 c60138c1
          ld d,a                         ; @0157 5700
          cp 88                          ; @0159 fe013838c2
          jr c,CHAR1B                    ; @015E 38038007c2
          ld d,64                        ; @0163 16013634c2
                                         ; @0168 0030
CHAR1B    ld (PRINTPOS),de               ; @016A 534a80078005c4
                                         ; @0171 0030
          exx                            ; @0173 d900
          pop af                         ; @0175 f100
          ret                            ; @0177 c900
                                         ; @0179 0030
                                         ; @017B 0030
                                         ; @017D 0030
                                         ; @017F 0030
;tisk znaku 2 - tucny                    ; @0181 01373b7469736b207a6e616b752032202d207475636e79d5
                                         ; @0199 0030
CHAR2     push af                        ; @019B f5088008c2
          exx                            ; @01A0 d900
                                         ; @01A2 0030
          ld l,a                         ; @01A4 6f00
          ld h,0                         ; @01A6 260130c1
          add hl,hl                      ; @01AA 2900
          add hl,hl                      ; @01AC 2900
          add hl,hl                      ; @01AE 2900
          ld bc,CHARS                    ; @01B0 01028004c2
          add hl,bc                      ; @01B5 0900
                                         ; @01B7 0030
          ld de,(PRINTPOS)               ; @01B9 5b428005c2
          push de                        ; @01BE d500
                                         ; @01C0 0030
          ld b,8                         ; @01C2 060138c1
CHAR2A    ld a,(hl)                      ; @01C6 7e088009c2
          rrca                           ; @01CB 0f00
          or (hl)                        ; @01CD b600
          ld (de),a                      ; @01CF 1200
          inc hl                         ; @01D1 2300
          inc d                          ; @01D3 1400
          djnz CHAR2A                    ; @01D5 10038009c2
                                         ; @01DA 0030
          pop de                         ; @01DC d100
          inc e                          ; @01DE 1c00
          jr nz,CHAR2B                   ; @01E0 2003800ac2
          ld a,d                         ; @01E5 7a00
          add a,8                        ; @01E7 c60138c1
          ld d,a                         ; @01EB 5700
          cp 88                          ; @01ED fe013838c2
          jr c,CHAR2B                    ; @01F2 3803800ac2
          ld d,64                        ; @01F7 16013634c2
                                         ; @01FC 0030
CHAR2B    ld (PRINTPOS),de               ; @01FE 534a800a8005c4
                                         ; @0205 0030
          exx                            ; @0207 d900
          pop af                         ; @0209 f100
          ret                            ; @020B c900
                                         ; @020D 0030
                                         ; @020F 0030
                                         ; @0211 0030
                                         ; @0213 0030
;tisk znaku 3 - italika                  ; @0215 01373b7469736b207a6e616b752033202d206974616c696b61d7
                                         ; @022F 0030
CHAR3     push af                        ; @0231 f508800cc2
          exx                            ; @0236 d900
                                         ; @0238 0030
          ld l,a                         ; @023A 6f00
          ld h,0                         ; @023C 260130c1
          add hl,hl                      ; @0240 2900
          add hl,hl                      ; @0242 2900
          add hl,hl                      ; @0244 2900
          ld bc,CHARS                    ; @0246 01028004c2
          add hl,bc                      ; @024B 0900
                                         ; @024D 0030
          ld de,(PRINTPOS)               ; @024F 5b428005c2
          push de                        ; @0254 d500
                                         ; @0256 0030
          ld a,(hl)                      ; @0258 7e00
          rrca                           ; @025A 0f00
          ld (de),a                      ; @025C 1200
          inc hl                         ; @025E 2300
          inc d                          ; @0260 1400
                                         ; @0262 0030
          ld a,(hl)                      ; @0264 7e00
          rrca                           ; @0266 0f00
          ld (de),a                      ; @0268 1200
          inc hl                         ; @026A 2300
          inc d                          ; @026C 1400
                                         ; @026E 0030
          ld a,(hl)                      ; @0270 7e00
          rrca                           ; @0272 0f00
          ld (de),a                      ; @0274 1200
          inc hl                         ; @0276 2300
          inc d                          ; @0278 1400
                                         ; @027A 0030
          ld a,(hl)                      ; @027C 7e00
          ld (de),a                      ; @027E 1200
          inc hl                         ; @0280 2300
          inc d                          ; @0282 1400
          ld a,(hl)                      ; @0284 7e00
          ld (de),a                      ; @0286 1200
          inc hl                         ; @0288 2300
          inc d                          ; @028A 1400
                                         ; @028C 0030
          ld a,(hl)                      ; @028E 7e00
          rlca                           ; @0290 0700
          ld (de),a                      ; @0292 1200
          inc hl                         ; @0294 2300
          inc d                          ; @0296 1400
                                         ; @0298 0030
          ld a,(hl)                      ; @029A 7e00
          rlca                           ; @029C 0700
          ld (de),a                      ; @029E 1200
          inc hl                         ; @02A0 2300
          inc d                          ; @02A2 1400
                                         ; @02A4 0030
          ld a,(hl)                      ; @02A6 7e00
          rlca                           ; @02A8 0700
          ld (de),a                      ; @02AA 1200
          inc hl                         ; @02AC 2300
          inc d                          ; @02AE 1400
                                         ; @02B0 0030
          pop de                         ; @02B2 d100
          inc e                          ; @02B4 1c00
          jr nz,CHAR3B                   ; @02B6 2003800dc2
          ld a,d                         ; @02BB 7a00
          add a,8                        ; @02BD c60138c1
          ld d,a                         ; @02C1 5700
          cp 88                          ; @02C3 fe013838c2
          jr c,CHAR3B                    ; @02C8 3803800dc2
          ld d,64                        ; @02CD 16013634c2
                                         ; @02D2 0030
CHAR3B    ld (PRINTPOS),de               ; @02D4 534a800d8005c4
                                         ; @02DB 0030
          exx                            ; @02DD d900
          pop af                         ; @02DF f100
          ret                            ; @02E1 c900
                                         ; @02E3 0030
                                         ; @02E5 0030
                                         ; @02E7 0030
                                         ; @02E9 0030
;tisk znaku 4 - barevny                  ; @02EB 01373b7469736b207a6e616b752034202d2062617265766e79d7
                                         ; @0305 0030
CHARC1    push af                        ; @0307 f508800fc2
          exx                            ; @030C d900
                                         ; @030E 0030
          ld l,a                         ; @0310 6f00
          ld h,0                         ; @0312 260130c1
          add hl,hl                      ; @0316 2900
          add hl,hl                      ; @0318 2900
          add hl,hl                      ; @031A 2900
          ld bc,CHARS                    ; @031C 01028004c2
          add hl,bc                      ; @0321 0900
                                         ; @0323 0030
          ld de,(PRINTPOS)               ; @0325 5b428005c2
          push de                        ; @032A d500
                                         ; @032C 0030
          ld b,8                         ; @032E 060138c1
CHARC1A   ld a,(hl)                      ; @0332 7e088010c2
          ld (de),a                      ; @0337 1200
          inc hl                         ; @0339 2300
          inc d                          ; @033B 1400
          djnz CHARC1A                   ; @033D 10038010c2
                                         ; @0342 0030
          pop hl                         ; @0344 e100
          push hl                        ; @0346 e500
                                         ; @0348 0030
          ld a,h                         ; @034A 7c00
          sub 64                         ; @034C d6013634c2
          rrca                           ; @0351 0f00
          rrca                           ; @0353 0f00
          rrca                           ; @0355 0f00
          and 3                          ; @0357 e60133c1
          add a,88                       ; @035B c6013838c2
          ld h,a                         ; @0360 6700
                                         ; @0362 0030
          ld a,(ATTRIBUT)                ; @0364 3a028013c2
          ld (hl),a                      ; @0369 7700
                                         ; @036B 0030
          pop de                         ; @036D d100
          inc e                          ; @036F 1c00
          jr nz,CHARC1B                  ; @0371 20038011c2
          ld a,d                         ; @0376 7a00
          add a,8                        ; @0378 c60138c1
          ld d,a                         ; @037C 5700
          cp 88                          ; @037E fe013838c2
          jr c,CHARC1B                   ; @0383 38038011c2
          ld d,64                        ; @0388 16013634c2
                                         ; @038D 0030
CHARC1B   ld (PRINTPOS),de               ; @038F 534a80118005c4
                                         ; @0396 0030
          exx                            ; @0398 d900
          pop af                         ; @039A f100
          ret                            ; @039C c900
                                         ; @039E 0030
                                         ; @03A0 0030
                                         ; @03A2 0030
                                         ; @03A4 0030
;nastaveni tiskove pozice                ; @03A6 01373b6e6173746176656e69207469736b6f766520706f7a696365d9
                                         ; @03C2 0030
ADRSET    ld a,c                         ; @03C4 79088014c2
          add a,a                        ; @03C9 8700
          add a,a                        ; @03CB 8700
          add a,a                        ; @03CD 8700
          ld c,a                         ; @03CF 4f00
                                         ; @03D1 0030
          ld a,b                         ; @03D3 7800
          add a,a                        ; @03D5 8700
          add a,a                        ; @03D7 8700
          add a,a                        ; @03D9 8700
                                         ; @03DB 0030
          call #22B0                     ; @03DD cd022332324230c5
          ld (PRINTPOS),hl               ; @03E5 22028005c2
          ret                            ; @03EA c900
                                         ; @03EC 0030
                                         ; @03EE 0030
                                         ; @03F0 0030
                                         ; @03F2 0030
;nastaveni barev                         ; @03F4 01373b6e6173746176656e69206261726576d0
                                         ; @0407 0030
SETINK    ld c,%11111000                 ; @0409 0e098015253131313131303030cb
          jr STCOMMON                    ; @0417 18038016c2
                                         ; @041C 0030
SETPAPER  ld c,%11000111                 ; @041E 0e098017253131303030313131cb
          rlca                           ; @042C 0700
          rlca                           ; @042E 0700
          rlca                           ; @0430 0700
          jr STCOMMON                    ; @0432 18038016c2
                                         ; @0437 0030
SETBRGHT  ld c,%10111111                 ; @0439 0e098018253130313131313131cb
          rrca                           ; @0447 0f00
          rrca                           ; @0449 0f00
          jr STCOMMON                    ; @044B 18038016c2
                                         ; @0450 0030
SETFLASH  ld c,%01111111                 ; @0452 0e098019253031313131313131cb
          rrca                           ; @0460 0f00
                                         ; @0462 0030
STCOMMON  ld b,a                         ; @0464 47088016c2
          ld a,c                         ; @0469 7900
          cpl                            ; @046B 2f00
          and b                          ; @046D a000
          ld b,a                         ; @046F 4700
          ld a,(ATTRIBUT)                ; @0471 3a028013c2
          and c                          ; @0476 a100
          or b                           ; @0478 b000
          ld (ATTRIBUT),a                ; @047A 32028013c2
          ret                            ; @047F c900
                                         ; @0481 0030
                                         ; @0483 0030
                                         ; @0485 0030
PRINTPOS  defw 0                         ; @0487 093f800530c3
ATTRIBUT  defb 0                         ; @048D 063f801330c3
