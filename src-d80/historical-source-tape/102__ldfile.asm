; decoded from 102__ldfile_t3_l1186_p1_0_p2_888.bin
; source_length=888 symbol_count=34 bridge=baff
; symbols:
;      1: ADR       value=16384 defined=1 locked=0
;      2: DIR       value=58000 defined=1 locked=0
;      3: BREAD     value= 8866 defined=1 locked=0
;      4: BWRITE    value= 8854 defined=1 locked=0
;      5: READALL   value=42196 defined=1 locked=0
;      6: HEAD      value=42300 defined=1 locked=0
;      7: LDADR     value=42077 defined=1 locked=0
;      8: LDFILE    value=41993 defined=1 locked=0
;      9: LDSVR     value=42083 defined=1 locked=0
;     10: FINDFL    value=42096 defined=1 locked=0
;     11: MESSAG2   value=42325 defined=1 locked=0
;     12: LDF1      value=42016 defined=1 locked=0
;     13: FDBLOCK   value=42133 defined=1 locked=0
;     14: LDF3      value=42069 defined=1 locked=0
;     15: LDF2      value=42042 defined=1 locked=0
;     16: DIVIDE    value=42278 defined=1 locked=0
;     17: LDSV      value=42073 defined=1 locked=0
;     18: FF0       value=42104 defined=1 locked=0
;     19: FF1       value=42109 defined=1 locked=0
;     20: FF2       value=42125 defined=1 locked=0
;     21: LESS      value=42141 defined=1 locked=0
;     22: MORE      value=42148 defined=1 locked=0
;     23: TYPE      value=42187 defined=1 locked=0
;     24: NODD      value=42177 defined=1 locked=0
;     25: ODD       value=42169 defined=1 locked=0
;     26: BOTH      value=42182 defined=1 locked=0
;     27: WRITALL   value=42188 defined=1 locked=0
;     28: SETPRMS   value=42238 defined=1 locked=0
;     29: RWALL     value=42202 defined=1 locked=0
;     30: RWAL1     value=42226 defined=1 locked=0
;     31: RWTAB     value=42311 defined=1 locked=0
;     32: RWAL0     value=42213 defined=1 locked=0
;     33: RA0       value=42271 defined=1 locked=0
;     34: DV0       value=42292 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
ADR       equ 16384                      ; @0008 033f80013136333834c7
DIR       equ 58000                      ; @0012 033f80023538303030c7
BREAD     equ 8866                       ; @001C 033f800338383636c6
BWRITE    equ 8854                       ; @0025 033f800438383534c6
                                         ; @002E 0030
          rst 0                          ; @0030 c70630c1
                                         ; @0034 0030
          call READALL                   ; @0036 cd028005c2
                                         ; @003B 0030
          ld ix,HEAD                     ; @003D 21228006c2
          ld hl,ADR                      ; @0042 21028001c2
          ld (LDADR+1),hl                ; @0047 220280072b31c4
          call LDFILE                    ; @004E cd028008c2
                                         ; @0053 0030
          jp 737                         ; @0055 c302373337c3
                                         ; @005B 0030
                                         ; @005D 0030
LDFILE    ld hl,BREAD                    ; @005F 210a80088003c4
          ld (LDSVR+1),hl                ; @0066 220280092b31c4
                                         ; @006D 0030
          call FINDFL                    ; @006F cd02800ac2
          ld a,27                        ; @0074 3e013237c2
          jp c,MESSAG2                   ; @0079 da02800bc2
          push hl                        ; @007E e500
          pop ix                         ; @0080 e120
          ld l,(ix+17)                   ; @0082 6e243137c2
          ld h,(ix+18)                   ; @0087 66243138c2
LDF1      push hl                        ; @008C e508800cc2
          call FDBLOCK                   ; @0091 cd02800dc2
          ld hl,3072                     ; @0096 210233303732c4
          sbc hl,de                      ; @009D 5240
          jr z,LDF3                      ; @009F 2803800ec2
          ld a,d                         ; @00A4 7a00
          cp 14                          ; @00A6 fe013134c2
          jr nc,LDF2                     ; @00AB 3003800fc2
          pop hl                         ; @00B0 e100
          call LDSV                      ; @00B2 cd028011c2
          call FDBLOCK                   ; @00B7 cd02800dc2
          ex de,hl                       ; @00BC eb00
          jr LDF1                        ; @00BE 1803800cc2
                                         ; @00C3 0030
LDF2      and 1                          ; @00C5 e609800f31c3
          ld d,a                         ; @00CB 5700
          pop hl                         ; @00CD e100
          push de                        ; @00CF d500
          call DIVIDE                    ; @00D1 cd028010c2
          ld hl,14848                    ; @00D6 21023134383438c5
          push hl                        ; @00DE e500
          ld de,257                      ; @00E0 1102323537c3
          call BREAD                     ; @00E6 cd028003c2
          pop hl                         ; @00EB e100
          pop bc                         ; @00ED c100
          ld de,(LDADR+1)                ; @00EF 5b4280072b31c4
          ldir                           ; @00F6 b040
          defb 62                        ; @00F8 06373632c2
LDF3      pop hl                         ; @00FD e108800ec2
          jp 9526                        ; @0102 c30239353236c4
                                         ; @0109 0030
LDSV      push hl                        ; @010B e5088011c2
          call DIVIDE                    ; @0110 cd028010c2
LDADR     ld hl,0                        ; @0115 210a800730c3
          ld de,257                      ; @011B 1102323537c3
LDSVR     call 0                         ; @0121 cd0a800930c3
          ld hl,(LDADR+1)                ; @0127 2a0280072b31c4
          inc h                          ; @012E 2400
          inc h                          ; @0130 2400
          ld (LDADR+1),hl                ; @0132 220280072b31c4
          pop hl                         ; @0139 e100
          ret                            ; @013B c900
                                         ; @013D 0030
                                         ; @013F 0030
                                         ; @0141 0030
FINDFL    ld hl,DIR+3072                 ; @0143 210a800a80022b33303732c9
          ld de,32                       ; @014F 11023332c2
          ld b,128                       ; @0154 0601313238c3
FF0       ld c,11                        ; @015A 0e0980123131c4
          push hl                        ; @0161 e500
          push ix                        ; @0163 e520
FF1       ld a,(ix+0)                    ; @0165 7e2c801330c3
          xor (hl)                       ; @016B ae00
          jr nz,FF2                      ; @016D 20038014c2
          inc hl                         ; @0172 2300
          inc ix                         ; @0174 2320
          dec c                          ; @0176 0d00
          jr nz,FF1                      ; @0178 20038013c2
          pop ix                         ; @017D e120
          pop hl                         ; @017F e100
          ret                            ; @0181 c900
                                         ; @0183 0030
FF2       pop ix                         ; @0185 e1288014c2
          pop hl                         ; @018A e100
          add hl,de                      ; @018C 1900
          djnz FF0                       ; @018E 10038012c2
          scf                            ; @0193 3700
          ret                            ; @0195 c900
                                         ; @0197 0030
                                         ; @0199 0030
FDBLOCK   push bc                        ; @019B c508800dc2
          ld bc,DIR                      ; @01A0 01028002c2
          ld de,341                      ; @01A5 1102333431c3
          or a                           ; @01AB b700
LESS      inc b                          ; @01AD 04088015c2
          inc b                          ; @01B2 0400
          sbc hl,de                      ; @01B4 5240
          jr nc,LESS                     ; @01B6 30038015c2
          add hl,de                      ; @01BB 1900
MORE      ld e,l                         ; @01BD 5d088016c2
          ld d,h                         ; @01C2 5400
          srl d                          ; @01C4 3a80
          rr e                           ; @01C6 1b80
          ex af,af'                      ; @01C8 0800
          add hl,de                      ; @01CA 1900
          add hl,bc                      ; @01CC 0900
          ld e,(hl)                      ; @01CE 5e00
          inc hl                         ; @01D0 2300
          ld d,(hl)                      ; @01D2 5600
          dec hl                         ; @01D4 2b00
          ld a,1                         ; @01D6 3e0131c1
          ld (TYPE),a                    ; @01DA 32028017c2
          ex af,af'                      ; @01DF 0800
          jr nc,NODD                     ; @01E1 30038018c2
ODD       xor a                          ; @01E6 af088019c2
          ld (TYPE),a                    ; @01EB 32028017c2
          ld a,e                         ; @01F0 7b00
          ld e,d                         ; @01F2 5a00
          jr BOTH                        ; @01F4 1803801ac2
                                         ; @01F9 0030
NODD      ld a,d                         ; @01FB 7a088018c2
          rrca                           ; @0200 0f00
          rrca                           ; @0202 0f00
          rrca                           ; @0204 0f00
          rrca                           ; @0206 0f00
BOTH      and 15                         ; @0208 e609801a3135c4
          ld d,a                         ; @020F 5700
          pop bc                         ; @0211 c100
          ret                            ; @0213 c900
                                         ; @0215 0030
TYPE      defb 0                         ; @0217 063f801730c3
                                         ; @021D 0030
                                         ; @021F 0030
                                         ; @0221 0030
WRITALL   call SETPRMS                   ; @0223 cd0a801b801cc4
          ld hl,BWRITE                   ; @022A 21028004c2
          jr RWALL                       ; @022F 1803801dc2
                                         ; @0234 0030
READALL   call SETPRMS                   ; @0236 cd0a8005801cc4
          ld hl,BREAD                    ; @023D 21028003c2
RWALL     ld (RWAL1+1),hl                ; @0242 220a801d801e2b31c6
          ld hl,RWTAB                    ; @024B 2102801fc2
          ld de,DIR                      ; @0250 11028002c2
          ld b,14                        ; @0255 06013134c2
RWAL0     push bc                        ; @025A c5088020c2
          push hl                        ; @025F e500
          push de                        ; @0261 d500
          ld l,(hl)                      ; @0263 6e00
          ld h,0                         ; @0265 260130c1
          call DIVIDE                    ; @0269 cd028010c2
          pop hl                         ; @026E e100
          ld de,257                      ; @0270 1102323537c3
RWAL1     call 0                         ; @0276 cd0a801e30c3
          ex de,hl                       ; @027C eb00
          pop hl                         ; @027E e100
          inc hl                         ; @0280 2300
          pop bc                         ; @0282 c100
          djnz RWAL0                     ; @0284 10038020c2
          jp 9526                        ; @0289 c30239353236c4
                                         ; @0290 0030
                                         ; @0292 0030
SETPRMS   ld hl,14336                    ; @0294 210a801c3134333336c7
          ld de,257                      ; @029E 1102323537c3
          ld bc,0                        ; @02A4 010230c1
          call BREAD                     ; @02A8 cd028003c2
          call 8609                      ; @02AD cd0238363039c4
          ld a,(14336+177)               ; @02B4 3a0231343333362b313737c9
          ld hl,(14336+178)              ; @02C0 2a0231343333362b313738c9
          set 4,(ix+1)                   ; @02CC e6a431c1
          and 16                         ; @02D0 e6013136c2
          jr nz,RA0                      ; @02D5 20038021c2
          res 4,(ix+1)                   ; @02DA a6a431c1
RA0       ld (ix+2),l                    ; @02DE 752c802132c3
          ld (ix+3),h                    ; @02E4 742433c1
          ret                            ; @02E8 c900
                                         ; @02EA 0030
                                         ; @02EC 0030
DIVIDE    ld a,(15979)                   ; @02EE 3a0a80103135393739c7
          call 8620                      ; @02F8 cd0238363230c4
          ld e,(ix+3)                    ; @02FF 5e2433c1
          ld d,0                         ; @0303 160130c1
          ld b,-1                        ; @0307 06012d31c2
          or a                           ; @030C b700
DV0       inc b                          ; @030E 04088022c2
          sbc hl,de                      ; @0313 5240
          jr nc,DV0                      ; @0315 30038022c2
          add hl,de                      ; @031A 1900
          ld c,l                         ; @031C 4d00
          ret                            ; @031E c900
                                         ; @0320 0030
HEAD      defb "P"                       ; @0322 063f8006225022c5
          defm "TELEFONY"                ; @032A 07372254454c45464f4e5922ca
          defb 0,0                       ; @0337 0637302c30c3
                                         ; @033D 0030
RWTAB     defb 0,1,2,3,4,5,6,8           ; @033F 063f801f302c312c322c332c342c352c362c38d1
          defb 10,12,7,9,11,13           ; @0353 063731302c31322c372c392c31312c3133cf
                                         ; @0365 0030
MESSAG2   xor a                          ; @0367 af08800bc2
          out (254),a                    ; @036C d301323534c3
          jp 737                         ; @0372 c302373337c3
