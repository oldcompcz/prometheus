; decoded from 120__shade_t3_l75_p1_0_p2_55.bin
; source_length=55 symbol_count=2 bridge=56ff
; symbols:
;      1: SHADE     value=40862 defined=1 locked=0
;      2: IM1       value=40873 defined=1 locked=0

                                         ; @0000 0030
SHADE     call IM1                       ; @0002 cd0a80018002c4
          rst 0                          ; @0009 c70630c1
          di                             ; @000D f300
          ld a,79                        ; @000F 3e013739c2
          ld (16119),a                   ; @0014 32023136313139c5
          ret                            ; @001C c900
                                         ; @001E 0030
IM1       ld iy,23610                    ; @0020 211a80023233363130c7
          ld a,63                        ; @002A 3e013633c2
          ld i,a                         ; @002F 4740
          im 1                           ; @0031 5640
          di                             ; @0033 f300
          ret                            ; @0035 c900
