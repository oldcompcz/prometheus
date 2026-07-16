; decoded from 086__erase3_t3_l744_p1_0_p2_549.bin
; source_length=549 symbol_count=23 bridge=a5ff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: ERASE     value=41563 defined=1 locked=0
;      3: FINDFL    value=41598 defined=1 locked=0
;      4: DELPATH   value=41635 defined=1 locked=0
;      5: FF0       value=41606 defined=1 locked=0
;      6: FF1       value=41611 defined=1 locked=0
;      7: FF2       value=41627 defined=1 locked=0
;      8: FDBLOCK   value=41664 defined=1 locked=0
;      9: DP1       value=41649 defined=1 locked=0
;     10: DP3       value=41659 defined=1 locked=0
;     11: DP2       value=41653 defined=1 locked=0
;     12: BCTOBT    value=41719 defined=1 locked=0
;     13: LESS      value=41672 defined=1 locked=0
;     14: MORE      value=41679 defined=1 locked=0
;     15: TYPE      value=41718 defined=1 locked=0
;     16: NODD      value=41708 defined=1 locked=0
;     17: ODD       value=41700 defined=1 locked=0
;     18: BOTH      value=41713 defined=1 locked=0
;     19: BCODD     value=41741 defined=1 locked=0
;     20: BCCOM     value=41737 defined=1 locked=0
;     21: START     value=41531 defined=1 locked=0
;     22: HEAD      value=41549 defined=1 locked=0
;     23: ERROR     value=41562 defined=1 locked=0

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
          defw 0,3240                    ; @0051 0937302c33323430c6
                                         ; @005A 0030
                                         ; @005C 0030
ERROR                                    ; @005E 00388017c2
          ret                            ; @0063 c900
                                         ; @0065 0030
                                         ; @0067 0030
ERASE     ld a,13                        ; @0069 3e0980023133c4
          ld (FF0+1),a                   ; @0070 320280052b31c4
          call FINDFL                    ; @0077 cd028003c2
          ld a,11                        ; @007C 3e013131c2
          ld (FF0+1),a                   ; @0081 320280052b31c4
          ret c                          ; @0088 d800
          ld (hl),229                    ; @008A 3601323239c3
          ld de,17                       ; @0090 11023137c2
          add hl,de                      ; @0095 1900
          ld e,(hl)                      ; @0097 5e00
          inc hl                         ; @0099 2300
          ld d,(hl)                      ; @009B 5600
          inc hl                         ; @009D 2300
          inc hl                         ; @009F 2300
          ld a,(hl)                      ; @00A1 7e00
          cpl                            ; @00A3 2f00
          and 1                          ; @00A5 e60131c1
          scf                            ; @00A9 3700
          ret nz                         ; @00AB c000
          ex de,hl                       ; @00AD eb00
          jp DELPATH                     ; @00AF c3028004c2
                                         ; @00B4 0030
                                         ; @00B6 0030
                                         ; @00B8 0030
FINDFL    ld hl,DIR+3072                 ; @00BA 210a800380012b33303732c9
          ld de,32                       ; @00C6 11023332c2
          ld b,128                       ; @00CB 0601313238c3
FF0       ld c,11                        ; @00D1 0e0980053131c4
          push hl                        ; @00D8 e500
          push ix                        ; @00DA e520
FF1       ld a,(ix+0)                    ; @00DC 7e2c800630c3
          xor (hl)                       ; @00E2 ae00
          jr nz,FF2                      ; @00E4 20038007c2
          inc hl                         ; @00E9 2300
          inc ix                         ; @00EB 2320
          dec c                          ; @00ED 0d00
          jr nz,FF1                      ; @00EF 20038006c2
          pop ix                         ; @00F4 e120
          pop hl                         ; @00F6 e100
          ret                            ; @00F8 c900
                                         ; @00FA 0030
FF2       pop ix                         ; @00FC e1288007c2
          pop hl                         ; @0101 e100
          add hl,de                      ; @0103 1900
          djnz FF0                       ; @0105 10038005c2
          scf                            ; @010A 3700
          ret                            ; @010C c900
                                         ; @010E 0030
                                         ; @0110 0030
DELPATH   call FDBLOCK                   ; @0112 cd0a80048008c4
          ld a,d                         ; @0119 7a00
          cp 12                          ; @011B fe013132c2
          jr nz,DP1                      ; @0120 20038009c2
          ld a,e                         ; @0125 7b00
          or a                           ; @0127 b700
          jr z,DP3                       ; @0129 2803800ac2
          jr DP2                         ; @012E 1803800bc2
                                         ; @0133 0030
DP1       cp 14                          ; @0135 fe0980093134c4
          jr nc,DP3                      ; @013C 3003800ac2
DP2       call DP3                       ; @0141 cd0a800b800ac4
          ex de,hl                       ; @0148 eb00
          jr DELPATH                     ; @014A 18038004c2
                                         ; @014F 0030
DP3       ld bc,0                        ; @0151 010a800a30c3
          jr BCTOBT                      ; @0157 1803800cc2
                                         ; @015C 0030
                                         ; @015E 0030
                                         ; @0160 0030
FDBLOCK   push bc                        ; @0162 c5088008c2
          ld bc,DIR                      ; @0167 01028001c2
          ld de,341                      ; @016C 1102333431c3
          or a                           ; @0172 b700
LESS      inc b                          ; @0174 0408800dc2
          inc b                          ; @0179 0400
          sbc hl,de                      ; @017B 5240
          jr nc,LESS                     ; @017D 3003800dc2
          add hl,de                      ; @0182 1900
MORE      ld e,l                         ; @0184 5d08800ec2
          ld d,h                         ; @0189 5400
          srl d                          ; @018B 3a80
          rr e                           ; @018D 1b80
          ex af,af'                      ; @018F 0800
          add hl,de                      ; @0191 1900
          add hl,bc                      ; @0193 0900
          ld e,(hl)                      ; @0195 5e00
          inc hl                         ; @0197 2300
          ld d,(hl)                      ; @0199 5600
          dec hl                         ; @019B 2b00
          ld a,1                         ; @019D 3e0131c1
          ld (TYPE),a                    ; @01A1 3202800fc2
          ex af,af'                      ; @01A6 0800
          jr nc,NODD                     ; @01A8 30038010c2
ODD       xor a                          ; @01AD af088011c2
          ld (TYPE),a                    ; @01B2 3202800fc2
          ld a,e                         ; @01B7 7b00
          ld e,d                         ; @01B9 5a00
          jr BOTH                        ; @01BB 18038012c2
                                         ; @01C0 0030
NODD      ld a,d                         ; @01C2 7a088010c2
          rrca                           ; @01C7 0f00
          rrca                           ; @01C9 0f00
          rrca                           ; @01CB 0f00
          rrca                           ; @01CD 0f00
BOTH      and 15                         ; @01CF e60980123135c4
          ld d,a                         ; @01D6 5700
          pop bc                         ; @01D8 c100
          ret                            ; @01DA c900
                                         ; @01DC 0030
TYPE      defb 0                         ; @01DE 063f800f30c3
                                         ; @01E4 0030
BCTOBT    ld a,(TYPE)                    ; @01E6 3a0a800c800fc4
          or a                           ; @01ED b700
          jr z,BCODD                     ; @01EF 28038013c2
          ld (hl),c                      ; @01F4 7100
          inc hl                         ; @01F6 2300
          rlc b                          ; @01F8 0080
          rlc b                          ; @01FA 0080
          rlc b                          ; @01FC 0080
          rlc b                          ; @01FE 0080
          ld a,15                        ; @0200 3e013135c2
BCCOM     and (hl)                       ; @0205 a6088014c2
          or b                           ; @020A b000
          ld (hl),a                      ; @020C 7700
          ret                            ; @020E c900
                                         ; @0210 0030
BCODD     ld a,240                       ; @0212 3e098013323430c5
          call BCCOM                     ; @021A cd028014c2
          inc hl                         ; @021F 2300
          ld (hl),c                      ; @0221 7100
          ret                            ; @0223 c900
