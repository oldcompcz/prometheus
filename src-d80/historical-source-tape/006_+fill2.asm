; decoded from 006_+fill2_t3_l1165_p1_0_p2_837.bin
; source_length=837 symbol_count=32 bridge=afff
; symbols:
;      1: START     value=42152 defined=1 locked=0
;      2: PREPIS    value=42417 defined=1 locked=0
;      3: MAKETAB   value=42365 defined=1 locked=0
;      4: FILL      value=42164 defined=1 locked=0
;      5: SPACE     value=43264 defined=1 locked=0
;      6: PUSHPTR   value=42261 defined=1 locked=0
;      7: POPPTR    value=42288 defined=1 locked=0
;      8: PUSHBC    value=42259 defined=1 locked=0
;      9: FILL2     value=42176 defined=1 locked=0
;     10: POPBC     value=42286 defined=1 locked=0
;     11: FILLEND   value=42254 defined=1 locked=0
;     12: POINT     value=42326 defined=1 locked=0
;     13: PLOT3     value=42346 defined=1 locked=0
;     14: NOUP      value=42208 defined=1 locked=0
;     15: NOUP2     value=42207 defined=1 locked=0
;     16: NODOWN    value=42223 defined=1 locked=0
;     17: NODOWN2   value=42222 defined=1 locked=0
;     18: NOLEFT    value=42237 defined=1 locked=0
;     19: NOLEFT2   value=42236 defined=1 locked=0
;     20: NORIGHT2  value=42251 defined=1 locked=0
;     21: SPACEEND  value=45312 defined=1 locked=0
;     22: PUSHBC2   value=42280 defined=1 locked=0
;     23: POPBC3    value=42323 defined=1 locked=0
;     24: POPBC2    value=42320 defined=1 locked=0
;     25: SCRNADRS  value=42496 defined=1 locked=0
;     26: TABLE     value=43008 defined=1 locked=0
;     27: MAKETAB2  value=42373 defined=1 locked=0
;     28: DOWNHL    value=42441 defined=1 locked=0
;     29: MAKETAB3  value=42390 defined=1 locked=0
;     30: PREPIS2   value=42431 defined=1 locked=0
;     31: DOWNHL2   value=42456 defined=1 locked=0
;     32: LAST      value=42462 defined=1 locked=0

                                         ; @0000 0030
                                         ; @0002 0030
          ent $                          ; @0004 023724c1
                                         ; @0008 0030
START     im 1                           ; @000A 56488001c2
          di                             ; @000F f300
          call PREPIS                    ; @0011 cd028002c2
          call MAKETAB                   ; @0016 cd028003c2
                                         ; @001B 0030
          ld bc,32*256+128               ; @001D 010233322a3235362b313238ca
                                         ; @002A 0030
FILL      ld hl,SPACE                    ; @002C 210a80048005c4
          ld (PUSHPTR+1),hl              ; @0033 220280062b31c4
          ld (POPPTR+1),hl               ; @003A 220280072b31c4
          call PUSHBC                    ; @0041 cd028008c2
                                         ; @0046 0030
FILL2     call POPBC                     ; @0048 cd0a8009800ac4
          ld a,b                         ; @004F 7800
          and c                          ; @0051 a100
          inc a                          ; @0053 3c00
          jr z,FILLEND                   ; @0055 2803800bc2
          call POINT                     ; @005A cd02800cc2
          jr nz,FILL2                    ; @005F 20038009c2
          push bc                        ; @0064 c500
          call PLOT3                     ; @0066 cd02800dc2
          pop bc                         ; @006B c100
          ld a,b                         ; @006D 7800
          or a                           ; @006F b700
          jr z,NOUP                      ; @0071 2803800ec2
          dec b                          ; @0076 0500
          call POINT                     ; @0078 cd02800cc2
          jr nz,NOUP2                    ; @007D 2003800fc2
          call PUSHBC                    ; @0082 cd028008c2
NOUP2     inc b                          ; @0087 0408800fc2
                                         ; @008C 0030
NOUP      ld a,b                         ; @008E 7808800ec2
          cp 191                         ; @0093 fe01313931c3
          jr z,NODOWN                    ; @0099 28038010c2
          inc b                          ; @009E 0400
          call POINT                     ; @00A0 cd02800cc2
          jr nz,NODOWN2                  ; @00A5 20038011c2
          call PUSHBC                    ; @00AA cd028008c2
NODOWN2   dec b                          ; @00AF 05088011c2
                                         ; @00B4 0030
NODOWN    ld a,c                         ; @00B6 79088010c2
          or a                           ; @00BB b700
          jr z,NOLEFT                    ; @00BD 28038012c2
          dec c                          ; @00C2 0d00
          call POINT                     ; @00C4 cd02800cc2
          jr nz,NOLEFT2                  ; @00C9 20038013c2
          call PUSHBC                    ; @00CE cd028008c2
NOLEFT2   inc c                          ; @00D3 0c088013c2
                                         ; @00D8 0030
NOLEFT    ld a,c                         ; @00DA 79088012c2
          cp 255                         ; @00DF fe01323535c3
          jr z,FILL2                     ; @00E5 28038009c2
          inc c                          ; @00EA 0c00
          call POINT                     ; @00EC cd02800cc2
          jr nz,NORIGHT2                 ; @00F1 20038014c2
          call PUSHBC                    ; @00F6 cd028008c2
NORIGHT2  dec c                          ; @00FB 0d088014c2
          jr FILL2                       ; @0100 18038009c2
                                         ; @0105 0030
FILLEND   ld a,4                         ; @0107 3e09800b34c3
          out (254),a                    ; @010D d301323534c3
          ret                            ; @0113 c900
                                         ; @0115 0030
PUSHBC    push de                        ; @0117 d5088008c2
          push hl                        ; @011C e500
PUSHPTR   ld hl,0                        ; @011E 210a800630c3
          ld (hl),c                      ; @0124 7100
          inc hl                         ; @0126 2300
          ld (hl),b                      ; @0128 7000
          inc hl                         ; @012A 2300
          ld de,SPACEEND                 ; @012C 11028015c2
          or a                           ; @0131 b700
          sbc hl,de                      ; @0133 5240
          add hl,de                      ; @0135 1900
          jr nz,PUSHBC2                  ; @0137 20038016c2
          ld hl,SPACE                    ; @013C 21028005c2
PUSHBC2   ld (PUSHPTR+1),hl              ; @0141 220a801680062b31c6
          pop hl                         ; @014A e100
          pop de                         ; @014C d100
          ret                            ; @014E c900
                                         ; @0150 0030
POPBC     push de                        ; @0152 d508800ac2
          push hl                        ; @0157 e500
POPPTR    ld hl,0                        ; @0159 210a800730c3
          ld de,(PUSHPTR+1)              ; @015F 5b4280062b31c4
          or a                           ; @0166 b700
          sbc hl,de                      ; @0168 5240
          add hl,de                      ; @016A 1900
          ld bc,-1                       ; @016C 01022d31c2
          jr z,POPBC3                    ; @0171 28038017c2
          ld c,(hl)                      ; @0176 4e00
          inc hl                         ; @0178 2300
          ld b,(hl)                      ; @017A 4600
          inc hl                         ; @017C 2300
          ld de,SPACEEND                 ; @017E 11028015c2
          or a                           ; @0183 b700
          sbc hl,de                      ; @0185 5240
          add hl,de                      ; @0187 1900
          jr nz,POPBC2                   ; @0189 20038018c2
          ld hl,SPACE                    ; @018E 21028005c2
POPBC2    ld (POPPTR+1),hl               ; @0193 220a801880072b31c6
POPBC3    pop hl                         ; @019C e1088017c2
          pop de                         ; @01A1 d100
          ret                            ; @01A3 c900
                                         ; @01A5 0030
POINT     push bc                        ; @01A7 c508800cc2
          ld l,b                         ; @01AC 6800
          ld h,SCRNADRS/256              ; @01AE 260180192f323536c6
          ld a,c                         ; @01B7 7900
          rrca                           ; @01B9 0f00
          rrca                           ; @01BB 0f00
          rrca                           ; @01BD 0f00
          and 31                         ; @01BF e6013331c2
          add a,(hl)                     ; @01C4 8600
          inc h                          ; @01C6 2400
          ld h,(hl)                      ; @01C8 6600
          ld l,a                         ; @01CA 6f00
          ld b,TABLE/256                 ; @01CC 0601801a2f323536c6
          ld a,(bc)                      ; @01D5 0a00
          and (hl)                       ; @01D7 a600
          pop bc                         ; @01D9 c100
          ret                            ; @01DB c900
                                         ; @01DD 0030
PLOT3     ld l,b                         ; @01DF 6808800dc2
          ld h,SCRNADRS/256              ; @01E4 260180192f323536c6
          ld a,c                         ; @01ED 7900
          rrca                           ; @01EF 0f00
          rrca                           ; @01F1 0f00
          rrca                           ; @01F3 0f00
          and 31                         ; @01F5 e6013331c2
          add a,(hl)                     ; @01FA 8600
          inc h                          ; @01FC 2400
          ld h,(hl)                      ; @01FE 6600
          ld l,a                         ; @0200 6f00
          ld b,TABLE/256                 ; @0202 0601801a2f323536c6
          ld a,(bc)                      ; @020B 0a00
          xor (hl)                       ; @020D ae00
          ld (hl),a                      ; @020F 7700
          ret                            ; @0211 c900
                                         ; @0213 0030
MAKETAB   ld b,192                       ; @0215 06098003313932c5
          ld de,16384                    ; @021D 11023136333834c5
          ld hl,SCRNADRS                 ; @0225 21028019c2
MAKETAB2  ld (hl),e                      ; @022A 7308801bc2
          inc h                          ; @022F 2400
          ld (hl),d                      ; @0231 7200
          dec h                          ; @0233 2500
          inc hl                         ; @0235 2300
          ex de,hl                       ; @0237 eb00
          call DOWNHL                    ; @0239 cd02801cc2
          ex de,hl                       ; @023E eb00
          djnz MAKETAB2                  ; @0240 1003801bc2
          ld b,32                        ; @0245 06013332c2
          ld hl,TABLE                    ; @024A 2102801ac2
MAKETAB3  ld (hl),128                    ; @024F 3609801d313238c5
          inc l                          ; @0257 2c00
          ld (hl),64                     ; @0259 36013634c2
          inc l                          ; @025E 2c00
          ld (hl),32                     ; @0260 36013332c2
          inc l                          ; @0265 2c00
          ld (hl),16                     ; @0267 36013136c2
          inc l                          ; @026C 2c00
          ld (hl),8                      ; @026E 360138c1
          inc l                          ; @0272 2c00
          ld (hl),4                      ; @0274 360134c1
          inc l                          ; @0278 2c00
          ld (hl),2                      ; @027A 360132c1
          inc l                          ; @027E 2c00
          ld (hl),1                      ; @0280 360131c1
          inc l                          ; @0284 2c00
          djnz MAKETAB3                  ; @0286 1003801dc2
          ret                            ; @028B c900
                                         ; @028D 0030
PREPIS    ld a,2                         ; @028F 3e09800232c3
          call #1601                     ; @0295 cd022331363031c5
          ld a,22                        ; @029D 3e013232c2
          rst 16                         ; @02A2 c7063136c2
          xor a                          ; @02A7 af00
          rst 16                         ; @02A9 c7063136c2
          xor a                          ; @02AE af00
          rst 16                         ; @02B0 c7063136c2
          ld b,0                         ; @02B5 060130c1
PREPIS2   ld a,r                         ; @02B9 5f48801ec2
          and 63                         ; @02BE e6013633c2
          add a,32                       ; @02C3 c6013332c2
          rst 16                         ; @02C8 c7063136c2
          djnz PREPIS2                   ; @02CD 1003801ec2
          ret                            ; @02D2 c900
                                         ; @02D4 0030
DOWNHL    inc h                          ; @02D6 2408801cc2
          ld a,h                         ; @02DB 7c00
          and 7                          ; @02DD e60137c1
          ret nz                         ; @02E1 c000
                                         ; @02E3 0030
          ld a,l                         ; @02E5 7d00
          add a,32                       ; @02E7 c6013332c2
          ld l,a                         ; @02EC 6f00
          ld a,h                         ; @02EE 7c00
          jr c,DOWNHL2                   ; @02F0 3803801fc2
          sub 8                          ; @02F5 d60138c1
          ld h,a                         ; @02F9 6700
DOWNHL2   cp 88                          ; @02FB fe09801f3838c4
          ret c                          ; @0302 d800
          ld h,64                        ; @0304 26013634c2
          ret                            ; @0309 c900
                                         ; @030B 0030
LAST                                     ; @030D 00388020c2
                                         ; @0312 0030
          org LAST/256+1*256             ; @0314 043780202f3235362b312a323536cc
                                         ; @0323 0030
SCRNADRS  defs 512                       ; @0325 083f8019353132c5
TABLE     defs 256                       ; @032D 083f801a323536c5
                                         ; @0335 0030
SPACE     defs 2048                      ; @0337 083f800532303438c6
SPACEEND  nop                            ; @0340 00088015c2
