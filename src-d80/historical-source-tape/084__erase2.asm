; decoded from 084__erase2_t3_l717_p1_0_p2_522.bin
; source_length=522 symbol_count=23 bridge=98ff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: ERASE     value=41534 defined=1 locked=0
;      3: FINDFL    value=41559 defined=1 locked=0
;      4: DELPATH   value=41596 defined=1 locked=0
;      5: FF0       value=41567 defined=1 locked=0
;      6: FF1       value=41572 defined=1 locked=0
;      7: FF2       value=41588 defined=1 locked=0
;      8: FDBLOCK   value=41625 defined=1 locked=0
;      9: DP1       value=41610 defined=1 locked=0
;     10: DP3       value=41620 defined=1 locked=0
;     11: DP2       value=41614 defined=1 locked=0
;     12: BCTOBT    value=41680 defined=1 locked=0
;     13: LESS      value=41633 defined=1 locked=0
;     14: MORE      value=41640 defined=1 locked=0
;     15: TYPE      value=41679 defined=1 locked=0
;     16: NODD      value=41669 defined=1 locked=0
;     17: ODD       value=41661 defined=1 locked=0
;     18: BOTH      value=41674 defined=1 locked=0
;     19: BCODD     value=41702 defined=1 locked=0
;     20: BCCOM     value=41698 defined=1 locked=0
;     21: START     value=41504 defined=1 locked=0
;     22: HEAD      value=41522 defined=1 locked=0
;     23: ERROR     value=41533 defined=1 locked=0

                                         ; @0000 0030
                                         ; @0002 0030
          ent $                          ; @0004 023724c1
                                         ; @0008 0030
DIR       equ 58000                      ; @000A 033f80013538303030c7
                                         ; @0014 0030
                                         ; @0016 0030
START     ld ix,HEAD                     ; @0018 212a80158016c4
          call ERASE                     ; @001F cd028002c2
          ret nc                         ; @0024 d000
          ld a,27                        ; @0026 3e013237c2
          jp z,ERROR                     ; @002B ca028017c2
          ld a,48                        ; @0030 3e013438c2
          jp ERROR                       ; @0035 c3028017c2
                                         ; @003A 0030
HEAD      defb "P"                       ; @003C 063f8016225022c5
          defm "TELEFONY"                ; @0044 07372254454c45464f4e5922ca
          defb 0,0                       ; @0051 0637302c30c3
                                         ; @0057 0030
                                         ; @0059 0030
ERROR                                    ; @005B 00388017c2
          ret                            ; @0060 c900
                                         ; @0062 0030
                                         ; @0064 0030
ERASE     call FINDFL                    ; @0066 cd0a80028003c4
          ret c                          ; @006D d800
          ld (hl),229                    ; @006F 3601323239c3
          ld de,17                       ; @0075 11023137c2
          add hl,de                      ; @007A 1900
          ld e,(hl)                      ; @007C 5e00
          inc hl                         ; @007E 2300
          ld d,(hl)                      ; @0080 5600
          inc hl                         ; @0082 2300
          inc hl                         ; @0084 2300
          ld a,(hl)                      ; @0086 7e00
          cpl                            ; @0088 2f00
          and 1                          ; @008A e60131c1
          scf                            ; @008E 3700
          ret nz                         ; @0090 c000
          ex de,hl                       ; @0092 eb00
          jp DELPATH                     ; @0094 c3028004c2
                                         ; @0099 0030
                                         ; @009B 0030
                                         ; @009D 0030
FINDFL    ld hl,DIR+3072                 ; @009F 210a800380012b33303732c9
          ld de,32                       ; @00AB 11023332c2
          ld b,128                       ; @00B0 0601313238c3
FF0       ld c,11                        ; @00B6 0e0980053131c4
          push hl                        ; @00BD e500
          push ix                        ; @00BF e520
FF1       ld a,(ix+0)                    ; @00C1 7e2c800630c3
          xor (hl)                       ; @00C7 ae00
          jr nz,FF2                      ; @00C9 20038007c2
          inc hl                         ; @00CE 2300
          inc ix                         ; @00D0 2320
          dec c                          ; @00D2 0d00
          jr nz,FF1                      ; @00D4 20038006c2
          pop ix                         ; @00D9 e120
          pop hl                         ; @00DB e100
          ret                            ; @00DD c900
                                         ; @00DF 0030
FF2       pop ix                         ; @00E1 e1288007c2
          pop hl                         ; @00E6 e100
          add hl,de                      ; @00E8 1900
          djnz FF0                       ; @00EA 10038005c2
          scf                            ; @00EF 3700
          ret                            ; @00F1 c900
                                         ; @00F3 0030
                                         ; @00F5 0030
DELPATH   call FDBLOCK                   ; @00F7 cd0a80048008c4
          ld a,d                         ; @00FE 7a00
          cp 12                          ; @0100 fe013132c2
          jr nz,DP1                      ; @0105 20038009c2
          ld a,e                         ; @010A 7b00
          or a                           ; @010C b700
          jr z,DP3                       ; @010E 2803800ac2
          jr DP2                         ; @0113 1803800bc2
                                         ; @0118 0030
DP1       cp 14                          ; @011A fe0980093134c4
          jr nc,DP3                      ; @0121 3003800ac2
DP2       call DP3                       ; @0126 cd0a800b800ac4
          ex de,hl                       ; @012D eb00
          jr DELPATH                     ; @012F 18038004c2
                                         ; @0134 0030
DP3       ld bc,0                        ; @0136 010a800a30c3
          jr BCTOBT                      ; @013C 1803800cc2
                                         ; @0141 0030
                                         ; @0143 0030
                                         ; @0145 0030
FDBLOCK   push bc                        ; @0147 c5088008c2
          ld bc,DIR                      ; @014C 01028001c2
          ld de,341                      ; @0151 1102333431c3
          or a                           ; @0157 b700
LESS      inc b                          ; @0159 0408800dc2
          inc b                          ; @015E 0400
          sbc hl,de                      ; @0160 5240
          jr nc,LESS                     ; @0162 3003800dc2
          add hl,de                      ; @0167 1900
MORE      ld e,l                         ; @0169 5d08800ec2
          ld d,h                         ; @016E 5400
          srl d                          ; @0170 3a80
          rr e                           ; @0172 1b80
          ex af,af'                      ; @0174 0800
          add hl,de                      ; @0176 1900
          add hl,bc                      ; @0178 0900
          ld e,(hl)                      ; @017A 5e00
          inc hl                         ; @017C 2300
          ld d,(hl)                      ; @017E 5600
          dec hl                         ; @0180 2b00
          ld a,1                         ; @0182 3e0131c1
          ld (TYPE),a                    ; @0186 3202800fc2
          ex af,af'                      ; @018B 0800
          jr nc,NODD                     ; @018D 30038010c2
ODD       xor a                          ; @0192 af088011c2
          ld (TYPE),a                    ; @0197 3202800fc2
          ld a,e                         ; @019C 7b00
          ld e,d                         ; @019E 5a00
          jr BOTH                        ; @01A0 18038012c2
                                         ; @01A5 0030
NODD      ld a,d                         ; @01A7 7a088010c2
          rrca                           ; @01AC 0f00
          rrca                           ; @01AE 0f00
          rrca                           ; @01B0 0f00
          rrca                           ; @01B2 0f00
BOTH      and 15                         ; @01B4 e60980123135c4
          ld d,a                         ; @01BB 5700
          pop bc                         ; @01BD c100
          ret                            ; @01BF c900
                                         ; @01C1 0030
TYPE      defb 0                         ; @01C3 063f800f30c3
                                         ; @01C9 0030
BCTOBT    ld a,(TYPE)                    ; @01CB 3a0a800c800fc4
          or a                           ; @01D2 b700
          jr z,BCODD                     ; @01D4 28038013c2
          ld (hl),c                      ; @01D9 7100
          inc hl                         ; @01DB 2300
          rlc b                          ; @01DD 0080
          rlc b                          ; @01DF 0080
          rlc b                          ; @01E1 0080
          rlc b                          ; @01E3 0080
          ld a,15                        ; @01E5 3e013135c2
BCCOM     and (hl)                       ; @01EA a6088014c2
          or b                           ; @01EF b000
          ld (hl),a                      ; @01F1 7700
          ret                            ; @01F3 c900
                                         ; @01F5 0030
BCODD     ld a,240                       ; @01F7 3e098013323430c5
          call BCCOM                     ; @01FF cd028014c2
          inc hl                         ; @0204 2300
          ld (hl),c                      ; @0206 7100
          ret                            ; @0208 c900
