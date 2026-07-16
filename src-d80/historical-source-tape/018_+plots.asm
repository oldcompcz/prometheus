; decoded from 018_+plots_t3_l1156_p1_0_p2_856.bin
; source_length=856 symbol_count=31 bridge=f9ff
; symbols:
;      1: DOWNHL    value=43165 defined=1 locked=0
;      2: DOWNHL2   value=43180 defined=1 locked=0
;      3: UPHL      value=43144 defined=1 locked=0
;      4: UPHL2     value=43159 defined=1 locked=0
;      5: PLOT1     value=43091 defined=1 locked=0
;      6: PLOT1A    value=43099 defined=1 locked=0
;      7: PLOT2     value=43105 defined=1 locked=0
;      8: CODE      value=43141 defined=1 locked=0
;      9: START     value=42143 defined=1 locked=0
;     10: MAKETAB   value=42327 defined=1 locked=0
;     11: LOOP1     value=42150 defined=1 locked=0
;     12: LOOP2     value=42151 defined=1 locked=0
;     13: PLOT3     value=42301 defined=1 locked=0
;     14: CLEAR     value=42166 defined=1 locked=0
;     15: CLEAR2    value=42169 defined=1 locked=0
;     16: RANDOM    value=42347 defined=1 locked=0
;     17: CLEAR3    value=42180 defined=1 locked=0
;     18: NO_STARS  value=   25 defined=1 locked=0
;     19: STARS     value=42191 defined=1 locked=0
;     20: SPACE     value=43016 defined=1 locked=0
;     21: STARS2    value=42197 defined=1 locked=0
;     22: STARS7    value=42254 defined=1 locked=0
;     23: STARS5    value=42230 defined=1 locked=0
;     24: STARS4    value=42236 defined=1 locked=0
;     25: STARS3    value=42260 defined=1 locked=0
;     26: SCRNADRS  value=42496 defined=1 locked=0
;     27: TABLE     value=43008 defined=1 locked=0
;     28: MAKETAB2  value=42335 defined=1 locked=0
;     29: AB        value=42371 defined=1 locked=0
;     30: LAST      value=42375 defined=1 locked=0
;     31: A0LEN     value=  232 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     call MAKETAB                   ; @0008 cd0a8009800ac4
          ei                             ; @000F fb00
                                         ; @0011 0030
          ld bc,0                        ; @0013 010230c1
LOOP1     push bc                        ; @0017 c508800bc2
LOOP2     push bc                        ; @001C c508800cc2
          call PLOT3                     ; @0021 cd02800dc2
          pop bc                         ; @0026 c100
          inc c                          ; @0028 0c00
          jr nz,LOOP2                    ; @002A 2003800cc2
          pop af                         ; @002F f100
          inc a                          ; @0031 3c00
          cp 192                         ; @0033 fe01313932c3
          ld b,a                         ; @0039 4700
          jr c,LOOP1                     ; @003B 3803800bc2
                                         ; @0040 0030
CLEAR     ld hl,0                        ; @0042 210a800e30c3
CLEAR2    push hl                        ; @0048 e508800fc2
          call RANDOM                    ; @004D cd028010c2
          ld a,h                         ; @0052 7c00
          cp 192                         ; @0054 fe01313932c3
          jr c,CLEAR3                    ; @005A 38038011c2
          sub 128                        ; @005F d601313238c3
CLEAR3    ld c,l                         ; @0065 4d088011c2
          ld b,a                         ; @006A 4700
          call PLOT3                     ; @006C cd02800dc2
          pop hl                         ; @0071 e100
          dec hl                         ; @0073 2b00
          ld a,h                         ; @0075 7c00
          or l                           ; @0077 b500
          jr nz,CLEAR2                   ; @0079 2003800fc2
                                         ; @007E 0030
NO_STARS  equ 25                         ; @0080 033f80123235c4
                                         ; @0087 0030
STARS     ld b,NO_STARS                  ; @0089 060980138012c4
          ld ix,SPACE                    ; @0090 21228014c2
STARS2    call RANDOM                    ; @0095 cd0a80158010c4
          ld a,h                         ; @009C 7c00
          and 63                         ; @009E e6013633c2
          add a,64                       ; @00A3 c6013634c2
          ld (ix+0),l                    ; @00A8 752430c1
          ld (ix+1),a                    ; @00AC 772431c1
          call RANDOM                    ; @00B0 cd028010c2
          ld a,l                         ; @00B5 7d00
          and 7                          ; @00B7 e60137c1
          inc a                          ; @00BB 3c00
          ld (ix+2),a                    ; @00BD 772432c1
          ld de,3                        ; @00C1 110233c1
          add ix,de                      ; @00C5 1920
          djnz STARS2                    ; @00C7 10038015c2
          jr STARS7                      ; @00CC 18038016c2
                                         ; @00D1 0030
STARS5    ld ix,SPACE                    ; @00D3 212a80178014c4
          ld b,NO_STARS                  ; @00DA 06018012c2
STARS4    push bc                        ; @00DF c5088018c2
          ld c,(ix+0)                    ; @00E4 4e2430c1
          ld b,(ix+1)                    ; @00E8 462431c1
          call PLOT3                     ; @00EC cd02800dc2
          ld de,3                        ; @00F1 110233c1
          add ix,de                      ; @00F5 1920
          pop bc                         ; @00F7 c100
          djnz STARS4                    ; @00F9 10038018c2
                                         ; @00FE 0030
STARS7    ld ix,SPACE                    ; @0100 212a80168014c4
          ld b,NO_STARS                  ; @0107 06018012c2
STARS3    push bc                        ; @010C c5088019c2
          ld a,(ix+2)                    ; @0111 7e2432c1
          ld c,(ix+0)                    ; @0115 4e2430c1
          add a,c                        ; @0119 8100
          ld c,a                         ; @011B 4f00
          ld (ix+0),a                    ; @011D 772430c1
          ld b,(ix+1)                    ; @0121 462431c1
          call PLOT3                     ; @0125 cd02800dc2
          ld de,3                        ; @012A 110233c1
          add ix,de                      ; @012E 1920
          pop bc                         ; @0130 c100
          djnz STARS3                    ; @0132 10038019c2
          ld a,0                         ; @0137 3e0130c1
          out (254),a                    ; @013B d301323534c3
          halt                           ; @0141 7600
          ld a,4                         ; @0143 3e0134c1
          out (254),a                    ; @0147 d301323534c3
          call 8020                      ; @014D cd0238303230c4
          ret nc                         ; @0154 d000
          jr STARS5                      ; @0156 18038017c2
                                         ; @015B 0030
PLOT3     ld l,b                         ; @015D 6808800dc2
          ld h,SCRNADRS/512              ; @0162 2601801a2f353132c6
          add hl,hl                      ; @016B 2900
          ld a,(hl)                      ; @016D 7e00
          inc l                          ; @016F 2c00
          ld h,(hl)                      ; @0171 6600
          ld l,a                         ; @0173 6f00
          ld a,c                         ; @0175 7900
          rrca                           ; @0177 0f00
          rrca                           ; @0179 0f00
          rrca                           ; @017B 0f00
          and 31                         ; @017D e6013331c2
          add a,l                        ; @0182 8500
          ld l,a                         ; @0184 6f00
          ld a,c                         ; @0186 7900
          and 7                          ; @0188 e60137c1
          ld c,a                         ; @018C 4f00
          ld b,TABLE/256                 ; @018E 0601801b2f323536c6
          ld a,(bc)                      ; @0197 0a00
          xor (hl)                       ; @0199 ae00
          ld (hl),a                      ; @019B 7700
          ret                            ; @019D c900
                                         ; @019F 0030
MAKETAB   ld b,192                       ; @01A1 0609800a313932c5
          ld de,16384                    ; @01A9 11023136333834c5
          ld hl,SCRNADRS                 ; @01B1 2102801ac2
MAKETAB2  ld (hl),e                      ; @01B6 7308801cc2
          inc hl                         ; @01BB 2300
          ld (hl),d                      ; @01BD 7200
          inc hl                         ; @01BF 2300
          ex de,hl                       ; @01C1 eb00
          call DOWNHL                    ; @01C3 cd028001c2
          ex de,hl                       ; @01C8 eb00
          djnz MAKETAB2                  ; @01CA 1003801cc2
          ret                            ; @01CF c900
                                         ; @01D1 0030
RANDOM    ld de,0                        ; @01D3 110a801030c3
          ld h,e                         ; @01D9 6300
          ld l,253                       ; @01DB 2e01323533c3
          ld a,d                         ; @01E1 7a00
          or a                           ; @01E3 b700
          sbc hl,de                      ; @01E5 5240
          sbc a,0                        ; @01E7 de0130c1
          sbc hl,de                      ; @01EB 5240
          sbc a,0                        ; @01ED de0130c1
          ld e,a                         ; @01F1 5f00
          ld d,0                         ; @01F3 160130c1
          sbc hl,de                      ; @01F7 5240
          jr nc,AB                       ; @01F9 3003801dc2
          inc hl                         ; @01FE 2300
AB        ld (RANDOM+1),hl               ; @0200 220a801d80102b31c6
          ret                            ; @0209 c900
                                         ; @020B 0030
LAST                                     ; @020D 0038801ec2
A0LEN     equ $-START                    ; @0212 033f801f242d8009c6
                                         ; @021B 0030
          org LAST/512+1*512             ; @021D 0437801e2f3531322b312a353132cc
                                         ; @022C 0030
SCRNADRS  defs 512                       ; @022E 083f801a353132c5
                                         ; @0236 0030
TABLE     defb 128,64,32,16              ; @0238 063f801b3132382c36342c33322c3136ce
          defb 8,4,2,1                   ; @0249 0637382c342c322c31c7
                                         ; @0253 0030
SPACE     defs 3*NO_STARS                ; @0255 083f8014332a8012c6
                                         ; @025E 0030
PLOT1     ld a,b                         ; @0260 78088005c2
          call #22B1                     ; @0265 cd022332324231c5
          ld b,a                         ; @026D 4700
          inc b                          ; @026F 0400
          ld a,1                         ; @0271 3e0131c1
PLOT1A    rrca                           ; @0275 0f088006c2
          djnz PLOT1A                    ; @027A 10038006c2
          xor (hl)                       ; @027F ae00
          ld (hl),a                      ; @0281 7700
          ret                            ; @0283 c900
                                         ; @0285 0030
PLOT2     ld a,b                         ; @0287 78088007c2
          and a                          ; @028C a700
          rra                            ; @028E 1f00
          scf                            ; @0290 3700
          rra                            ; @0292 1f00
          and a                          ; @0294 a700
          rra                            ; @0296 1f00
          xor b                          ; @0298 a800
          and #F8                        ; @029A e601234638c3
          xor b                          ; @02A0 a800
          ld h,a                         ; @02A2 6700
          ld a,c                         ; @02A4 7900
          rlca                           ; @02A6 0700
          rlca                           ; @02A8 0700
          rlca                           ; @02AA 0700
          xor b                          ; @02AC a800
          and %11000111                  ; @02AE e601253131303030313131c9
          xor b                          ; @02BA a800
          rlca                           ; @02BC 0700
          rlca                           ; @02BE 0700
          ld l,a                         ; @02C0 6f00
          ld a,c                         ; @02C2 7900
          and 7                          ; @02C4 e60137c1
                                         ; @02C8 0030
          add a,a                        ; @02CA 8700
          add a,a                        ; @02CC 8700
          add a,a                        ; @02CE 8700
          ld b,a                         ; @02D0 4700
          ld a,254                       ; @02D2 3e01323534c3
          sub b                          ; @02D8 9000
          ld (CODE+1),a                  ; @02DA 320280082b31c4
CODE      set 0,(hl)                     ; @02E1 c6888008c2
          ret                            ; @02E6 c900
                                         ; @02E8 0030
UPHL      ld a,h                         ; @02EA 7c088003c2
          dec h                          ; @02EF 2500
          and 7                          ; @02F1 e60137c1
          ret nz                         ; @02F5 c000
          ld a,l                         ; @02F7 7d00
          sub 32                         ; @02F9 d6013332c2
          ld l,a                         ; @02FE 6f00
          ld a,h                         ; @0300 7c00
          jr c,UPHL2                     ; @0302 38038004c2
          add a,8                        ; @0307 c60138c1
          ld h,a                         ; @030B 6700
UPHL2     cp 64                          ; @030D fe0980043634c4
          ret nc                         ; @0314 d000
          ld h,87                        ; @0316 26013837c2
          ret                            ; @031B c900
                                         ; @031D 0030
                                         ; @031F 0030
DOWNHL    inc h                          ; @0321 24088001c2
          ld a,h                         ; @0326 7c00
          and 7                          ; @0328 e60137c1
          ret nz                         ; @032C c000
          ld a,l                         ; @032E 7d00
          add a,32                       ; @0330 c6013332c2
          ld l,a                         ; @0335 6f00
          ld a,h                         ; @0337 7c00
          jr c,DOWNHL2                   ; @0339 38038002c2
          sub 8                          ; @033E d60138c1
          ld h,a                         ; @0342 6700
DOWNHL2   cp 88                          ; @0344 fe0980023838c4
          ret c                          ; @034B d800
          ld h,64                        ; @034D 26013634c2
          ret                            ; @0352 c900
                                         ; @0354 0030
                                         ; @0356 0030
