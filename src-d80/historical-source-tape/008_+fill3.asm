; decoded from 008_+fill3_t3_l1480_p1_0_p2_1060.bin
; source_length=1060 symbol_count=46 bridge=c3ff
; symbols:
;      1: START     value=42467 defined=1 locked=0
;      2: PREPIS    value=42846 defined=1 locked=0
;      3: FILL      value=42476 defined=1 locked=0
;      4: SPACE     value=42870 defined=1 locked=0
;      5: PUSHPTR   value=42776 defined=1 locked=0
;      6: POPPTR    value=42817 defined=1 locked=0
;      7: FILLEND   value=42721 defined=1 locked=0
;      8: SPACEEND  value=45942 defined=1 locked=0
;      9: DOWNHL    value=42741 defined=1 locked=0
;     10: PREPIS2   value=42860 defined=1 locked=0
;     11: BUFSIZE   value= 1024 defined=1 locked=0
;     12: PUSHCNT   value=42759 defined=1 locked=0
;     13: FILL9     value=42499 defined=1 locked=0
;     14: PUSH      value=42756 defined=1 locked=0
;     15: FILL0     value=42506 defined=1 locked=0
;     16: POP       value=42803 defined=1 locked=0
;     17: GOLEFT    value=42518 defined=1 locked=0
;     18: GOLEFT2   value=42524 defined=1 locked=0
;     19: GOLEFT3   value=42536 defined=1 locked=0
;     20: GOLEFT4   value=42540 defined=1 locked=0
;     21: FILLRGHT  value=42546 defined=1 locked=0
;     22: FREND     value=42576 defined=1 locked=0
;     23: FR2       value=42558 defined=1 locked=0
;     24: UPHL      value=42726 defined=1 locked=0
;     25: DOWN      value=42648 defined=1 locked=0
;     26: TUR1B     value=42627 defined=1 locked=0
;     27: TUR7      value=42593 defined=1 locked=0
;     28: TUR2      value=42596 defined=1 locked=0
;     29: TUR3      value=42619 defined=1 locked=0
;     30: TUR8      value=42604 defined=1 locked=0
;     31: TUR9      value=42648 defined=1 locked=0
;     32: TUR1      value=42623 defined=1 locked=0
;     33: TUR4      value=42646 defined=1 locked=0
;     34: TUR8B     value=42631 defined=1 locked=0
;     35: TDR1      value=42693 defined=1 locked=0
;     36: TDR1B     value=42697 defined=1 locked=0
;     37: TDR7      value=42663 defined=1 locked=0
;     38: TDR2      value=42666 defined=1 locked=0
;     39: TDR3      value=42689 defined=1 locked=0
;     40: TDR8      value=42674 defined=1 locked=0
;     41: TDR9      value=42718 defined=1 locked=0
;     42: TDR4      value=42716 defined=1 locked=0
;     43: TDR8B     value=42701 defined=1 locked=0
;     44: PUSH2     value=42797 defined=1 locked=0
;     45: POP3      value=42843 defined=1 locked=0
;     46: POP2      value=42840 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
BUFSIZE   equ 1024                       ; @0008 033f800b31303234c6
                                         ; @0011 0030
START     im 1                           ; @0013 56488001c2
          di                             ; @0018 f300
          call PREPIS                    ; @001A cd028002c2
          ld bc,120*256+128              ; @001F 01023132302a3235362b313238cb
                                         ; @002D 0030
FILL      ld hl,SPACE                    ; @002F 210a80038004c4
          ld (PUSHPTR+1),hl              ; @0036 220280052b31c4
          ld (POPPTR+1),hl               ; @003D 220280062b31c4
          ld hl,0                        ; @0044 210230c1
          ld (PUSHCNT+1),hl              ; @0048 2202800c2b31c4
                                         ; @004F 0030
          ld a,b                         ; @0051 7800
          call #22B0                     ; @0053 cd022332324230c5
          ld b,a                         ; @005B 4700
          inc b                          ; @005D 0400
          ld a,1                         ; @005F 3e0131c1
FILL9     rrca                           ; @0063 0f08800dc2
          djnz FILL9                     ; @0068 1003800dc2
          ld c,a                         ; @006D 4f00
          call PUSH                      ; @006F cd02800ec2
                                         ; @0074 0030
FILL0     call POP                       ; @0076 cd0a800f8010c4
          ld a,c                         ; @007D 7900
          inc a                          ; @007F 3c00
          jp z,FILLEND                   ; @0081 ca028007c2
          ld a,(hl)                      ; @0086 7e00
          and c                          ; @0088 a100
          jr nz,FILL0                    ; @008A 2003800fc2
                                         ; @008F 0030
GOLEFT    ld a,(hl)                      ; @0091 7e088011c2
          or a                           ; @0096 b700
          jr nz,GOLEFT2                  ; @0098 20038012c2
          ld c,128                       ; @009D 0e01313238c3
GOLEFT2   ld b,c                         ; @00A3 41088012c2
          ld e,l                         ; @00A8 5d00
          rlc c                          ; @00AA 0180
          jr nc,GOLEFT3                  ; @00AC 30038013c2
          ld a,l                         ; @00B1 7d00
          and 31                         ; @00B3 e6013331c2
          jr z,GOLEFT4                   ; @00B8 28038014c2
          dec l                          ; @00BD 2d00
GOLEFT3   ld a,(hl)                      ; @00BF 7e088013c2
          and c                          ; @00C4 a100
          jr z,GOLEFT                    ; @00C6 28038011c2
GOLEFT4   ld c,b                         ; @00CB 48088014c2
          ld l,e                         ; @00D0 6b00
                                         ; @00D2 0030
          push hl                        ; @00D4 e500
          push bc                        ; @00D6 c500
          ld e,0                         ; @00D8 1e0130c1
FILLRGHT  ld a,(hl)                      ; @00DC 7e088015c2
          and c                          ; @00E1 a100
          jr nz,FREND                    ; @00E3 20038016c2
          ld a,(hl)                      ; @00E8 7e00
          or c                           ; @00EA b100
          ld (hl),a                      ; @00EC 7700
          inc e                          ; @00EE 1c00
          rrc c                          ; @00F0 0980
          jr nc,FILLRGHT                 ; @00F2 30038015c2
FR2       inc l                          ; @00F7 2c088017c2
          ld a,l                         ; @00FC 7d00
          and 31                         ; @00FE e6013331c2
          jr z,FREND                     ; @0103 28038016c2
          ld a,(hl)                      ; @0108 7e00
          or a                           ; @010A b700
          jr nz,FILLRGHT                 ; @010C 20038015c2
          ld (hl),255                    ; @0111 3601323535c3
          ld a,e                         ; @0117 7b00
          add a,8                        ; @0119 c60138c1
          ld e,a                         ; @011D 5f00
          jr FR2                         ; @011F 18038017c2
                                         ; @0124 0030
FREND     pop bc                         ; @0126 c1088016c2
          pop hl                         ; @012B e100
                                         ; @012D 0030
          push hl                        ; @012F e500
          ld b,e                         ; @0131 4300
          push bc                        ; @0133 c500
                                         ; @0135 0030
          call UPHL                      ; @0137 cd028018c2
          ld a,h                         ; @013C 7c00
          cp 64                          ; @013E fe013634c2
          jr c,DOWN                      ; @0143 38038019c2
                                         ; @0148 0030
          ld a,(hl)                      ; @014A 7e00
          and c                          ; @014C a100
          jr nz,TUR1B                    ; @014E 2003801ac2
TUR7      call PUSH                      ; @0153 cd0a801b800ec4
TUR2      ld a,(hl)                      ; @015A 7e08801cc2
          and c                          ; @015F a100
          jr nz,TUR1B                    ; @0161 2003801ac2
          rrc c                          ; @0166 0980
          jr nc,TUR3                     ; @0168 3003801dc2
TUR8      inc l                          ; @016D 2c08801ec2
          ld a,(hl)                      ; @0172 7e00
          or a                           ; @0174 b700
          jr nz,TUR3                     ; @0176 2003801dc2
          ld a,b                         ; @017B 7800
          sub 8                          ; @017D d60138c1
          jr c,TUR3                      ; @0181 3803801dc2
          jr z,TUR9                      ; @0186 2803801fc2
          ld b,a                         ; @018B 4700
          jr TUR8                        ; @018D 1803801ec2
                                         ; @0192 0030
TUR3      djnz TUR2                      ; @0194 100b801d801cc4
          jr TUR9                        ; @019B 1803801fc2
                                         ; @01A0 0030
TUR1      ld a,(hl)                      ; @01A2 7e088020c2
          and c                          ; @01A7 a100
          jr z,TUR7                      ; @01A9 2803801bc2
TUR1B     rrc c                          ; @01AE 0988801ac2
          jr nc,TUR4                     ; @01B3 30038021c2
TUR8B     inc l                          ; @01B8 2c088022c2
          ld a,(hl)                      ; @01BD 7e00
          inc a                          ; @01BF 3c00
          jr nz,TUR4                     ; @01C1 20038021c2
          ld a,b                         ; @01C6 7800
          sub 8                          ; @01C8 d60138c1
          jr c,TUR4                      ; @01CC 38038021c2
          jr z,TUR9                      ; @01D1 2803801fc2
          ld b,a                         ; @01D6 4700
          jr TUR8B                       ; @01D8 18038022c2
                                         ; @01DD 0030
TUR4      djnz TUR1                      ; @01DF 100b80218020c4
TUR9                                     ; @01E6 0038801fc2
                                         ; @01EB 0030
DOWN      pop bc                         ; @01ED c1088019c2
          pop hl                         ; @01F2 e100
          call DOWNHL                    ; @01F4 cd028009c2
          ld a,h                         ; @01F9 7c00
          cp 88                          ; @01FB fe013838c2
          jp nc,FILL0                    ; @0200 d202800fc2
                                         ; @0205 0030
          ld a,(hl)                      ; @0207 7e00
          and c                          ; @0209 a100
          jr nz,TDR1B                    ; @020B 20038024c2
TDR7      call PUSH                      ; @0210 cd0a8025800ec4
TDR2      ld a,(hl)                      ; @0217 7e088026c2
          and c                          ; @021C a100
          jr nz,TDR1B                    ; @021E 20038024c2
          rrc c                          ; @0223 0980
          jr nc,TDR3                     ; @0225 30038027c2
TDR8      inc l                          ; @022A 2c088028c2
          ld a,(hl)                      ; @022F 7e00
          or a                           ; @0231 b700
          jr nz,TDR3                     ; @0233 20038027c2
          ld a,b                         ; @0238 7800
          sub 8                          ; @023A d60138c1
          jr c,TDR3                      ; @023E 38038027c2
          jr z,TDR9                      ; @0243 28038029c2
          ld b,a                         ; @0248 4700
          jr TDR8                        ; @024A 18038028c2
                                         ; @024F 0030
TDR3      djnz TDR2                      ; @0251 100b80278026c4
          jr TDR9                        ; @0258 18038029c2
                                         ; @025D 0030
TDR1      ld a,(hl)                      ; @025F 7e088023c2
          and c                          ; @0264 a100
          jr z,TDR7                      ; @0266 28038025c2
TDR1B     rrc c                          ; @026B 09888024c2
          jr nc,TDR4                     ; @0270 3003802ac2
TDR8B     inc l                          ; @0275 2c08802bc2
          ld a,(hl)                      ; @027A 7e00
          inc a                          ; @027C 3c00
          jr nz,TDR4                     ; @027E 2003802ac2
          ld a,b                         ; @0283 7800
          sub 8                          ; @0285 d60138c1
          jr c,TDR4                      ; @0289 3803802ac2
          jr z,TDR9                      ; @028E 28038029c2
          ld b,a                         ; @0293 4700
          jr TDR8B                       ; @0295 1803802bc2
                                         ; @029A 0030
TDR4      djnz TDR1                      ; @029C 100b802a8023c4
TDR9                                     ; @02A3 00388029c2
          jp FILL0                       ; @02A8 c302800fc2
                                         ; @02AD 0030
FILLEND   ld a,4                         ; @02AF 3e09800734c3
          out (254),a                    ; @02B5 d301323534c3
          ret                            ; @02BB c900
                                         ; @02BD 0030
UPHL      ld a,h                         ; @02BF 7c088018c2
          dec h                          ; @02C4 2500
          and 7                          ; @02C6 e60137c1
          ret nz                         ; @02CA c000
          ld a,l                         ; @02CC 7d00
          sub 32                         ; @02CE d6013332c2
          ld l,a                         ; @02D3 6f00
          ld a,h                         ; @02D5 7c00
          ret c                          ; @02D7 d800
          add a,8                        ; @02D9 c60138c1
          ld h,a                         ; @02DD 6700
          ret                            ; @02DF c900
                                         ; @02E1 0030
DOWNHL    inc h                          ; @02E3 24088009c2
          ld a,h                         ; @02E8 7c00
          and 7                          ; @02EA e60137c1
          ret nz                         ; @02EE c000
          ld a,l                         ; @02F0 7d00
          add a,32                       ; @02F2 c6013332c2
          ld l,a                         ; @02F7 6f00
          ld a,h                         ; @02F9 7c00
          ret c                          ; @02FB d800
          sub 8                          ; @02FD d60138c1
          ld h,a                         ; @0301 6700
          ret                            ; @0303 c900
                                         ; @0305 0030
PUSH      push de                        ; @0307 d508800ec2
          push hl                        ; @030C e500
          push hl                        ; @030E e500
PUSHCNT   ld hl,0                        ; @0310 210a800c30c3
          inc hl                         ; @0316 2300
          ld (PUSHCNT+1),hl              ; @0318 2202800c2b31c4
          ld de,BUFSIZE+1                ; @031F 1102800b2b31c4
          or a                           ; @0326 b700
          sbc hl,de                      ; @0328 5240
          jp z,25000                     ; @032A ca023235303030c5
          pop de                         ; @0332 d100
PUSHPTR   ld hl,0                        ; @0334 210a800530c3
          ld (hl),e                      ; @033A 7300
          inc hl                         ; @033C 2300
          ld (hl),d                      ; @033E 7200
          inc hl                         ; @0340 2300
          ld (hl),c                      ; @0342 7100
          inc hl                         ; @0344 2300
          ld de,SPACEEND                 ; @0346 11028008c2
          or a                           ; @034B b700
          sbc hl,de                      ; @034D 5240
          add hl,de                      ; @034F 1900
          jr nz,PUSH2                    ; @0351 2003802cc2
          ld hl,SPACE                    ; @0356 21028004c2
PUSH2     ld (PUSHPTR+1),hl              ; @035B 220a802c80052b31c6
          pop hl                         ; @0364 e100
          pop de                         ; @0366 d100
          ret                            ; @0368 c900
                                         ; @036A 0030
POP       push de                        ; @036C d5088010c2
          ld hl,(PUSHCNT+1)              ; @0371 2a02800c2b31c4
          dec hl                         ; @0378 2b00
          ld (PUSHCNT+1),hl              ; @037A 2202800c2b31c4
          ld a,h                         ; @0381 7c00
          and l                          ; @0383 a500
          ld c,a                         ; @0385 4f00
          inc a                          ; @0387 3c00
          jr z,POP3                      ; @0389 2803802dc2
POPPTR    ld hl,0                        ; @038E 210a800630c3
          ld e,(hl)                      ; @0394 5e00
          inc hl                         ; @0396 2300
          ld d,(hl)                      ; @0398 5600
          inc hl                         ; @039A 2300
          ld c,(hl)                      ; @039C 4e00
          inc hl                         ; @039E 2300
          push de                        ; @03A0 d500
          ld de,SPACEEND                 ; @03A2 11028008c2
          or a                           ; @03A7 b700
          sbc hl,de                      ; @03A9 5240
          add hl,de                      ; @03AB 1900
          pop de                         ; @03AD d100
          jr nz,POP2                     ; @03AF 2003802ec2
          ld hl,SPACE                    ; @03B4 21028004c2
POP2      ld (POPPTR+1),hl               ; @03B9 220a802e80062b31c6
POP3      ex de,hl                       ; @03C2 eb08802dc2
          pop de                         ; @03C7 d100
          ret                            ; @03C9 c900
                                         ; @03CB 0030
                                         ; @03CD 0030
PREPIS    ld a,2                         ; @03CF 3e09800232c3
          call #1601                     ; @03D5 cd022331363031c5
          ld a,22                        ; @03DD 3e013232c2
          rst 16                         ; @03E2 c7063136c2
          xor a                          ; @03E7 af00
          rst 16                         ; @03E9 c7063136c2
          xor a                          ; @03EE af00
          rst 16                         ; @03F0 c7063136c2
          ld b,0                         ; @03F5 060130c1
PREPIS2   ld a,r                         ; @03F9 5f48800ac2
          and 63                         ; @03FE e6013633c2
          add a,32                       ; @0403 c6013332c2
          rst 16                         ; @0408 c7063136c2
          djnz PREPIS2                   ; @040D 1003800ac2
          ret                            ; @0412 c900
                                         ; @0414 0030
SPACE     defs 3*BUFSIZE                 ; @0416 083f8004332a800bc6
SPACEEND  nop                            ; @041F 00088008c2
