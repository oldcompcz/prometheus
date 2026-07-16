; decoded from 076__delpath_t3_l420_p1_0_p2_291.bin
; source_length=291 symbol_count=15 bridge=72ff
; symbols:
;      1: DELPATH   value=41207 defined=1 locked=0
;      2: FDBLOCK   value=41236 defined=1 locked=0
;      3: DP1       value=41221 defined=1 locked=0
;      4: DP3       value=41231 defined=1 locked=0
;      5: DP2       value=41225 defined=1 locked=0
;      6: BCTOBT    value=41291 defined=1 locked=0
;      7: LESS      value=41244 defined=1 locked=0
;      8: MORE      value=41251 defined=1 locked=0
;      9: TYPE      value=41290 defined=1 locked=0
;     10: NODD      value=41280 defined=1 locked=0
;     11: ODD       value=41272 defined=1 locked=0
;     12: BOTH      value=41285 defined=1 locked=0
;     13: BCODD     value=41313 defined=1 locked=0
;     14: BCCOM     value=41309 defined=1 locked=0
;     15: DIR       value=58000 defined=1 locked=0

                                         ; @0000 0030
DIR       equ 58000                      ; @0002 033f800f3538303030c7
                                         ; @000C 0030
                                         ; @000E 0030
DELPATH   call FDBLOCK                   ; @0010 cd0a80018002c4
          ld a,d                         ; @0017 7a00
          cp 12                          ; @0019 fe013132c2
          jr nz,DP1                      ; @001E 20038003c2
          ld a,e                         ; @0023 7b00
          or a                           ; @0025 b700
          jr z,DP3                       ; @0027 28038004c2
          jr DP2                         ; @002C 18038005c2
                                         ; @0031 0030
DP1       cp 14                          ; @0033 fe0980033134c4
          jr nc,DP3                      ; @003A 30038004c2
DP2       call DP3                       ; @003F cd0a80058004c4
          ex de,hl                       ; @0046 eb00
          jr DELPATH                     ; @0048 18038001c2
                                         ; @004D 0030
DP3       ld bc,0                        ; @004F 010a800430c3
          jr BCTOBT                      ; @0055 18038006c2
                                         ; @005A 0030
                                         ; @005C 0030
                                         ; @005E 0030
FDBLOCK   push bc                        ; @0060 c5088002c2
          ld bc,DIR                      ; @0065 0102800fc2
          ld de,341                      ; @006A 1102333431c3
          or a                           ; @0070 b700
LESS      inc b                          ; @0072 04088007c2
          inc b                          ; @0077 0400
          sbc hl,de                      ; @0079 5240
          jr nc,LESS                     ; @007B 30038007c2
          add hl,de                      ; @0080 1900
MORE      ld e,l                         ; @0082 5d088008c2
          ld d,h                         ; @0087 5400
          srl d                          ; @0089 3a80
          rr e                           ; @008B 1b80
          ex af,af'                      ; @008D 0800
          add hl,de                      ; @008F 1900
          add hl,bc                      ; @0091 0900
          ld e,(hl)                      ; @0093 5e00
          inc hl                         ; @0095 2300
          ld d,(hl)                      ; @0097 5600
          dec hl                         ; @0099 2b00
          ld a,1                         ; @009B 3e0131c1
          ld (TYPE),a                    ; @009F 32028009c2
          ex af,af'                      ; @00A4 0800
          jr nc,NODD                     ; @00A6 3003800ac2
ODD       xor a                          ; @00AB af08800bc2
          ld (TYPE),a                    ; @00B0 32028009c2
          ld a,e                         ; @00B5 7b00
          ld e,d                         ; @00B7 5a00
          jr BOTH                        ; @00B9 1803800cc2
                                         ; @00BE 0030
NODD      ld a,d                         ; @00C0 7a08800ac2
          rrca                           ; @00C5 0f00
          rrca                           ; @00C7 0f00
          rrca                           ; @00C9 0f00
          rrca                           ; @00CB 0f00
BOTH      and 15                         ; @00CD e609800c3135c4
          ld d,a                         ; @00D4 5700
          pop bc                         ; @00D6 c100
          ret                            ; @00D8 c900
                                         ; @00DA 0030
TYPE      defb 0                         ; @00DC 063f800930c3
                                         ; @00E2 0030
BCTOBT    ld a,(TYPE)                    ; @00E4 3a0a80068009c4
          or a                           ; @00EB b700
          jr z,BCODD                     ; @00ED 2803800dc2
          ld (hl),c                      ; @00F2 7100
          inc hl                         ; @00F4 2300
          rlc b                          ; @00F6 0080
          rlc b                          ; @00F8 0080
          rlc b                          ; @00FA 0080
          rlc b                          ; @00FC 0080
          ld a,15                        ; @00FE 3e013135c2
BCCOM     and (hl)                       ; @0103 a608800ec2
          or b                           ; @0108 b000
          ld (hl),a                      ; @010A 7700
          ret                            ; @010C c900
                                         ; @010E 0030
BCODD     ld a,240                       ; @0110 3e09800d323430c5
          call BCCOM                     ; @0118 cd02800ec2
          inc hl                         ; @011D 2300
          ld (hl),c                      ; @011F 7100
          ret                            ; @0121 c900
