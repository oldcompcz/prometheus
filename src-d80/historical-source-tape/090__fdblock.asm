; decoded from 090__fdblock_t3_l213_p1_0_p2_144.bin
; source_length=144 symbol_count=8 bridge=cdff
; symbols:
;      1: FDBLOCK   value=41000 defined=1 locked=0
;      2: LESS      value=41008 defined=1 locked=0
;      3: MORE      value=41015 defined=1 locked=0
;      4: TYPE      value=41054 defined=1 locked=0
;      5: NODD      value=41044 defined=1 locked=0
;      6: ODD       value=41036 defined=1 locked=0
;      7: BOTH      value=41049 defined=1 locked=0
;      8: DIR       value=58000 defined=1 locked=0

                                         ; @0000 0030
DIR       equ 58000                      ; @0002 033f80083538303030c7
                                         ; @000C 0030
FDBLOCK   push bc                        ; @000E c5088001c2
          ld bc,DIR                      ; @0013 01028008c2
          ld de,341                      ; @0018 1102333431c3
          or a                           ; @001E b700
LESS      inc b                          ; @0020 04088002c2
          inc b                          ; @0025 0400
          sbc hl,de                      ; @0027 5240
          jr nc,LESS                     ; @0029 30038002c2
          add hl,de                      ; @002E 1900
MORE      ld e,l                         ; @0030 5d088003c2
          ld d,h                         ; @0035 5400
          srl d                          ; @0037 3a80
          rr e                           ; @0039 1b80
          ex af,af'                      ; @003B 0800
          add hl,de                      ; @003D 1900
          add hl,bc                      ; @003F 0900
          ld e,(hl)                      ; @0041 5e00
          inc hl                         ; @0043 2300
          ld d,(hl)                      ; @0045 5600
          dec hl                         ; @0047 2b00
          ld a,1                         ; @0049 3e0131c1
          ld (TYPE),a                    ; @004D 32028004c2
          ex af,af'                      ; @0052 0800
          jr nc,NODD                     ; @0054 30038005c2
ODD       xor a                          ; @0059 af088006c2
          ld (TYPE),a                    ; @005E 32028004c2
          ld a,e                         ; @0063 7b00
          ld e,d                         ; @0065 5a00
          jr BOTH                        ; @0067 18038007c2
                                         ; @006C 0030
NODD      ld a,d                         ; @006E 7a088005c2
          rrca                           ; @0073 0f00
          rrca                           ; @0075 0f00
          rrca                           ; @0077 0f00
          rrca                           ; @0079 0f00
BOTH      and 15                         ; @007B e60980073135c4
          ld d,a                         ; @0082 5700
          pop bc                         ; @0084 c100
          ret                            ; @0086 c900
                                         ; @0088 0030
TYPE      defb 0                         ; @008A 063f800430c3
