; decoded from 110__print_AB_t3_l133_p1_0_p2_110.bin
; source_length=110 symbol_count=2 bridge=01ff
; symbols:
;      1: START     value=40920 defined=1 locked=0
;      2: START2    value=40936 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
                                         ; @0008 0030
START     ld a,2                         ; @000A 3e09800132c3
          call #1601                     ; @0010 cd022331363031c5
          rst 0                          ; @0018 c70630c1
          di                             ; @001C f300
          ld a,(16042)                   ; @001E 3a023136303432c5
          call #1700                     ; @0026 cd022331373030c5
          rst #10                        ; @002E c706233130c3
          ei                             ; @0034 fb00
          ret                            ; @0036 c900
                                         ; @0038 0030
                                         ; @003A 0030
START2    rst 0                          ; @003C c70e800230c3
          di                             ; @0042 f300
          ld a,2                         ; @0044 3e0132c1
          rst #28                        ; @0048 c706233238c3
          defw #1601                     ; @004E 09372331363031c5
          ld a,(16042)                   ; @0056 3a023136303432c5
          rst #10                        ; @005E c706233130c3
          ei                             ; @0064 fb00
          jp #1700                       ; @0066 c3022331373030c5
