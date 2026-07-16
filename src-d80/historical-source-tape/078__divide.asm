; decoded from 078__divide_t3_l73_p1_0_p2_52.bin
; source_length=52 symbol_count=2 bridge=3dff
; symbols:
;      1: DIVIDE    value=40860 defined=1 locked=0
;      2: DV0       value=40874 defined=1 locked=0

                                         ; @0000 0030
DIVIDE    ld a,(15979)                   ; @0002 3a0a80013135393739c7
          call 8620                      ; @000C cd0238363230c4
          ld e,(ix+3)                    ; @0013 5e2433c1
          ld d,0                         ; @0017 160130c1
          ld b,-1                        ; @001B 06012d31c2
          or a                           ; @0020 b700
DV0       inc b                          ; @0022 04088002c2
          sbc hl,de                      ; @0027 5240
          jr nc,DV0                      ; @0029 30038002c2
          add hl,de                      ; @002E 1900
          ld c,l                         ; @0030 4d00
          ret                            ; @0032 c900
