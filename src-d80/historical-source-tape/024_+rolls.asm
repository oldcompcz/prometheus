; decoded from 024_+rolls_t3_l902_p1_0_p2_577.bin
; source_length=577 symbol_count=34 bridge=5eff
; symbols:
;      1: VYSKA     value=   64 defined=1 locked=0
;      2: SIRKA     value=   20 defined=1 locked=0
;      3: SCR_UP    value=41583 defined=0 locked=0
;      4: SCU1      value=41588 defined=0 locked=0
;      5: DOWNHL    value=42107 defined=1 locked=0
;      6: DOWNHL2   value=42122 defined=1 locked=0
;      7: TEST      value=41904 defined=1 locked=0
;      8: SCR_DOWN  value=41605 defined=0 locked=0
;      9: SCD1      value=41610 defined=0 locked=0
;     10: UPHL      value=42086 defined=1 locked=0
;     11: UPHL2     value=42101 defined=1 locked=0
;     12: SCR_RGHT  value=41627 defined=0 locked=0
;     13: SCR1      value=41632 defined=0 locked=0
;     14: SCR2      value=41636 defined=0 locked=0
;     15: SCR_LEFT  value=41649 defined=0 locked=0
;     16: SCL1      value=41654 defined=0 locked=0
;     17: SCL2      value=41658 defined=0 locked=0
;     18: ROL_UP    value=41912 defined=1 locked=0
;     19: BUFFER    value=42066 defined=1 locked=0
;     20: LDIR20    value=41945 defined=1 locked=0
;     21: RLU1      value=41925 defined=1 locked=0
;     22: RLCM      value=41941 defined=1 locked=0
;     23: ROL_DOWN  value=41951 defined=1 locked=0
;     24: RLD1      value=41964 defined=1 locked=0
;     25: ROL_RGHT  value=41982 defined=1 locked=0
;     26: RLR1      value=41987 defined=1 locked=0
;     27: RLR2      value=41998 defined=1 locked=0
;     28: ROL_LEFT  value=42011 defined=1 locked=0
;     29: RLL1      value=42016 defined=1 locked=0
;     30: RLL2      value=42027 defined=1 locked=0
;     31: SCR_UPRT  value=42040 defined=1 locked=0
;     32: SCUR1     value=42045 defined=1 locked=0
;     33: SCUR2     value=42054 defined=1 locked=0
;     34: ROLL_UP   value= 1792 defined=0 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
          im 1                           ; @0008 5640
          ld hl,0                        ; @000A 210230c1
          ld de,16384                    ; @000E 11023136333834c5
          ld bc,6144                     ; @0016 010236313434c4
          ldir                           ; @001D b040
          ld b,192                       ; @001F 0601313932c3
TEST      push bc                        ; @0025 c5088007c2
          call ROL_UP                    ; @002A cd028012c2
          pop bc                         ; @002F c100
          djnz TEST                      ; @0031 10038007c2
          ret                            ; @0036 c900
                                         ; @0038 0030
                                         ; @003A 0030
SIRKA     equ 20                         ; @003C 033f80023230c4
VYSKA     equ 64                         ; @0043 033f80013634c4
                                         ; @004A 0030
ROL_UP    ld hl,16452                    ; @004C 210a80123136343532c7
          push hl                        ; @0056 e500
          ld de,BUFFER                   ; @0058 11028013c2
          call LDIR20                    ; @005D cd028014c2
          pop hl                         ; @0062 e100
          ld b,VYSKA-1                   ; @0064 060180012d31c4
RLU1      push hl                        ; @006B e5088015c2
          call DOWNHL                    ; @0070 cd028005c2
          pop de                         ; @0075 d100
          ld a,b                         ; @0077 7800
          ld bc,SIRKA                    ; @0079 01028002c2
          push hl                        ; @007E e500
          ldir                           ; @0080 b040
          pop hl                         ; @0082 e100
          ld b,a                         ; @0084 4700
          djnz RLU1                      ; @0086 10038015c2
RLCM      ex de,hl                       ; @008B eb088016c2
          ld hl,BUFFER                   ; @0090 21028013c2
LDIR20    ld bc,SIRKA                    ; @0095 010a80148002c4
          ldir                           ; @009C b040
          ret                            ; @009E c900
                                         ; @00A0 0030
ROL_DOWN  ld hl,20480-28-192             ; @00A2 210a801732303438302d32382d313932ce
          push hl                        ; @00B3 e500
          ld de,BUFFER                   ; @00B5 11028013c2
          call LDIR20                    ; @00BA cd028014c2
          pop hl                         ; @00BF e100
          ld b,VYSKA-1                   ; @00C1 060180012d31c4
RLD1      push hl                        ; @00C8 e5088018c2
          call UPHL                      ; @00CD cd02800ac2
          pop de                         ; @00D2 d100
          ld a,b                         ; @00D4 7800
          ld bc,SIRKA                    ; @00D6 01028002c2
          push hl                        ; @00DB e500
          ldir                           ; @00DD b040
          pop hl                         ; @00DF e100
          ld b,a                         ; @00E1 4700
          djnz RLD1                      ; @00E3 10038018c2
          jr RLCM                        ; @00E8 18038016c2
                                         ; @00ED 0030
ROL_RGHT  ld hl,16452                    ; @00EF 210a80193136343532c7
          ld c,VYSKA                     ; @00F9 0e018001c2
RLR1      push hl                        ; @00FE e508801ac2
          push hl                        ; @0103 e500
          ld de,SIRKA-1                  ; @0105 110280022d31c4
          add hl,de                      ; @010C 1900
          ld a,(hl)                      ; @010E 7e00
          rra                            ; @0110 1f00
          pop hl                         ; @0112 e100
          ld b,SIRKA                     ; @0114 06018002c2
RLR2      rr (hl)                        ; @0119 1e88801bc2
          inc l                          ; @011E 2c00
          djnz RLR2                      ; @0120 1003801bc2
          pop hl                         ; @0125 e100
          call DOWNHL                    ; @0127 cd028005c2
          dec c                          ; @012C 0d00
          jr nz,RLR1                     ; @012E 2003801ac2
          ret                            ; @0133 c900
                                         ; @0135 0030
ROL_LEFT  ld hl,16451+SIRKA              ; @0137 210a801c31363435312b8002ca
          ld c,VYSKA                     ; @0144 0e018001c2
RLL1      push hl                        ; @0149 e508801dc2
          push hl                        ; @014E e500
          ld de,-SIRKA+1                 ; @0150 11022d80022b31c5
          add hl,de                      ; @0158 1900
          ld a,(hl)                      ; @015A 7e00
          rla                            ; @015C 1700
          pop hl                         ; @015E e100
          ld b,SIRKA                     ; @0160 06018002c2
RLL2      rl (hl)                        ; @0165 1688801ec2
          dec l                          ; @016A 2d00
          djnz RLL2                      ; @016C 1003801ec2
          pop hl                         ; @0171 e100
          call DOWNHL                    ; @0173 cd028005c2
          dec c                          ; @0178 0d00
          jr nz,RLL1                     ; @017A 2003801dc2
          ret                            ; @017F c900
                                         ; @0181 0030
SCR_UPRT  ld hl,16452                    ; @0183 210a801f3136343532c7
          ld c,VYSKA-1                   ; @018D 0e0180012d31c4
SCUR1     push hl                        ; @0194 e5088020c2
          call DOWNHL                    ; @0199 cd028005c2
          pop de                         ; @019E d100
          push hl                        ; @01A0 e500
          ld b,SIRKA                     ; @01A2 06018002c2
          or a                           ; @01A7 b700
SCUR2     ld a,(hl)                      ; @01A9 7e088021c2
          rra                            ; @01AE 1f00
          ld (de),a                      ; @01B0 1200
          inc l                          ; @01B2 2c00
          inc e                          ; @01B4 1c00
          djnz SCUR2                     ; @01B6 10038021c2
          pop hl                         ; @01BB e100
          dec c                          ; @01BD 0d00
          jr nz,SCUR1                    ; @01BF 20038020c2
          ret                            ; @01C4 c900
                                         ; @01C6 0030
                                         ; @01C8 0030
BUFFER    defs SIRKA                     ; @01CA 083f80138002c4
                                         ; @01D1 0030
UPHL      ld a,h                         ; @01D3 7c08800ac2
          dec h                          ; @01D8 2500
          and 7                          ; @01DA e60137c1
          ret nz                         ; @01DE c000
          ld a,l                         ; @01E0 7d00
          sub 32                         ; @01E2 d6013332c2
          ld l,a                         ; @01E7 6f00
          ld a,h                         ; @01E9 7c00
          jr c,UPHL2                     ; @01EB 3803800bc2
          add a,8                        ; @01F0 c60138c1
          ld h,a                         ; @01F4 6700
UPHL2     cp 64                          ; @01F6 fe09800b3634c4
          ret nc                         ; @01FD d000
          ld h,87                        ; @01FF 26013837c2
          ret                            ; @0204 c900
                                         ; @0206 0030
                                         ; @0208 0030
DOWNHL    inc h                          ; @020A 24088005c2
          ld a,h                         ; @020F 7c00
          and 7                          ; @0211 e60137c1
          ret nz                         ; @0215 c000
          ld a,l                         ; @0217 7d00
          add a,32                       ; @0219 c6013332c2
          ld l,a                         ; @021E 6f00
          ld a,h                         ; @0220 7c00
          jr c,DOWNHL2                   ; @0222 38038006c2
          sub 8                          ; @0227 d60138c1
          ld h,a                         ; @022B 6700
DOWNHL2   cp 88                          ; @022D fe0980063838c4
          ret c                          ; @0234 d800
          ld h,64                        ; @0236 26013634c2
          ret                            ; @023B c900
                                         ; @023D 0030
                                         ; @023F 0030
