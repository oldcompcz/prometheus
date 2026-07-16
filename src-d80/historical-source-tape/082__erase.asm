; decoded from 082__erase_t3_l691_p1_0_p2_496.bin
; source_length=496 symbol_count=23 bridge=45ff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: ERASE     value=41503 defined=1 locked=0
;      3: FINDFL    value=41520 defined=1 locked=0
;      4: DELPATH   value=41557 defined=1 locked=0
;      5: FF0       value=41528 defined=1 locked=0
;      6: FF1       value=41533 defined=1 locked=0
;      7: FF2       value=41549 defined=1 locked=0
;      8: FDBLOCK   value=41586 defined=1 locked=0
;      9: DP1       value=41571 defined=1 locked=0
;     10: DP3       value=41581 defined=1 locked=0
;     11: DP2       value=41575 defined=1 locked=0
;     12: BCTOBT    value=41641 defined=1 locked=0
;     13: LESS      value=41594 defined=1 locked=0
;     14: MORE      value=41601 defined=1 locked=0
;     15: TYPE      value=41640 defined=1 locked=0
;     16: NODD      value=41630 defined=1 locked=0
;     17: ODD       value=41622 defined=1 locked=0
;     18: BOTH      value=41635 defined=1 locked=0
;     19: BCODD     value=41663 defined=1 locked=0
;     20: BCCOM     value=41659 defined=1 locked=0
;     21: START     value=41478 defined=1 locked=0
;     22: HEAD      value=41491 defined=1 locked=0
;     23: ERROR     value=41502 defined=1 locked=0

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
          jp ERROR                       ; @002B c3028017c2
                                         ; @0030 0030
HEAD      defb "P"                       ; @0032 063f8016225022c5
          defm "TELEFONY"                ; @003A 07372254454c45464f4e5922ca
          defb 0,0                       ; @0047 0637302c30c3
                                         ; @004D 0030
                                         ; @004F 0030
ERROR                                    ; @0051 00388017c2
          ret                            ; @0056 c900
                                         ; @0058 0030
                                         ; @005A 0030
ERASE     call FINDFL                    ; @005C cd0a80028003c4
          ret c                          ; @0063 d800
          ld (hl),229                    ; @0065 3601323239c3
          ld de,17                       ; @006B 11023137c2
          add hl,de                      ; @0070 1900
          ld e,(hl)                      ; @0072 5e00
          inc hl                         ; @0074 2300
          ld d,(hl)                      ; @0076 5600
          ex de,hl                       ; @0078 eb00
          jp DELPATH                     ; @007A c3028004c2
                                         ; @007F 0030
                                         ; @0081 0030
                                         ; @0083 0030
FINDFL    ld hl,DIR+3072                 ; @0085 210a800380012b33303732c9
          ld de,32                       ; @0091 11023332c2
          ld b,128                       ; @0096 0601313238c3
FF0       ld c,11                        ; @009C 0e0980053131c4
          push hl                        ; @00A3 e500
          push ix                        ; @00A5 e520
FF1       ld a,(ix+0)                    ; @00A7 7e2c800630c3
          xor (hl)                       ; @00AD ae00
          jr nz,FF2                      ; @00AF 20038007c2
          inc hl                         ; @00B4 2300
          inc ix                         ; @00B6 2320
          dec c                          ; @00B8 0d00
          jr nz,FF1                      ; @00BA 20038006c2
          pop ix                         ; @00BF e120
          pop hl                         ; @00C1 e100
          ret                            ; @00C3 c900
                                         ; @00C5 0030
FF2       pop ix                         ; @00C7 e1288007c2
          pop hl                         ; @00CC e100
          add hl,de                      ; @00CE 1900
          djnz FF0                       ; @00D0 10038005c2
          scf                            ; @00D5 3700
          ret                            ; @00D7 c900
                                         ; @00D9 0030
                                         ; @00DB 0030
DELPATH   call FDBLOCK                   ; @00DD cd0a80048008c4
          ld a,d                         ; @00E4 7a00
          cp 12                          ; @00E6 fe013132c2
          jr nz,DP1                      ; @00EB 20038009c2
          ld a,e                         ; @00F0 7b00
          or a                           ; @00F2 b700
          jr z,DP3                       ; @00F4 2803800ac2
          jr DP2                         ; @00F9 1803800bc2
                                         ; @00FE 0030
DP1       cp 14                          ; @0100 fe0980093134c4
          jr nc,DP3                      ; @0107 3003800ac2
DP2       call DP3                       ; @010C cd0a800b800ac4
          ex de,hl                       ; @0113 eb00
          jr DELPATH                     ; @0115 18038004c2
                                         ; @011A 0030
DP3       ld bc,0                        ; @011C 010a800a30c3
          jr BCTOBT                      ; @0122 1803800cc2
                                         ; @0127 0030
                                         ; @0129 0030
                                         ; @012B 0030
FDBLOCK   push bc                        ; @012D c5088008c2
          ld bc,DIR                      ; @0132 01028001c2
          ld de,341                      ; @0137 1102333431c3
          or a                           ; @013D b700
LESS      inc b                          ; @013F 0408800dc2
          inc b                          ; @0144 0400
          sbc hl,de                      ; @0146 5240
          jr nc,LESS                     ; @0148 3003800dc2
          add hl,de                      ; @014D 1900
MORE      ld e,l                         ; @014F 5d08800ec2
          ld d,h                         ; @0154 5400
          srl d                          ; @0156 3a80
          rr e                           ; @0158 1b80
          ex af,af'                      ; @015A 0800
          add hl,de                      ; @015C 1900
          add hl,bc                      ; @015E 0900
          ld e,(hl)                      ; @0160 5e00
          inc hl                         ; @0162 2300
          ld d,(hl)                      ; @0164 5600
          dec hl                         ; @0166 2b00
          ld a,1                         ; @0168 3e0131c1
          ld (TYPE),a                    ; @016C 3202800fc2
          ex af,af'                      ; @0171 0800
          jr nc,NODD                     ; @0173 30038010c2
ODD       xor a                          ; @0178 af088011c2
          ld (TYPE),a                    ; @017D 3202800fc2
          ld a,e                         ; @0182 7b00
          ld e,d                         ; @0184 5a00
          jr BOTH                        ; @0186 18038012c2
                                         ; @018B 0030
NODD      ld a,d                         ; @018D 7a088010c2
          rrca                           ; @0192 0f00
          rrca                           ; @0194 0f00
          rrca                           ; @0196 0f00
          rrca                           ; @0198 0f00
BOTH      and 15                         ; @019A e60980123135c4
          ld d,a                         ; @01A1 5700
          pop bc                         ; @01A3 c100
          ret                            ; @01A5 c900
                                         ; @01A7 0030
TYPE      defb 0                         ; @01A9 063f800f30c3
                                         ; @01AF 0030
BCTOBT    ld a,(TYPE)                    ; @01B1 3a0a800c800fc4
          or a                           ; @01B8 b700
          jr z,BCODD                     ; @01BA 28038013c2
          ld (hl),c                      ; @01BF 7100
          inc hl                         ; @01C1 2300
          rlc b                          ; @01C3 0080
          rlc b                          ; @01C5 0080
          rlc b                          ; @01C7 0080
          rlc b                          ; @01C9 0080
          ld a,15                        ; @01CB 3e013135c2
BCCOM     and (hl)                       ; @01D0 a6088014c2
          or b                           ; @01D5 b000
          ld (hl),a                      ; @01D7 7700
          ret                            ; @01D9 c900
                                         ; @01DB 0030
BCODD     ld a,240                       ; @01DD 3e098013323430c5
          call BCCOM                     ; @01E5 cd028014c2
          inc hl                         ; @01EA 2300
          ld (hl),c                      ; @01EC 7100
          ret                            ; @01EE c900
