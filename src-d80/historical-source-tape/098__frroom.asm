; decoded from 098__frroom_t3_l97_p1_0_p2_69.bin
; source_length=69 symbol_count=3 bridge=c4ff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: FRROOM    value=40884 defined=1 locked=0
;      3: FM0       value=40894 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
DIR       equ 58000                      ; @0008 033f80013538303030c7
                                         ; @0012 0030
                                         ; @0014 0030
FRROOM    ld hl,DIR+3072                 ; @0016 210a800280012b33303732c9
          ld de,32                       ; @0022 11023332c2
          ld b,128                       ; @0027 0601313238c3
          ld a,229                       ; @002D 3e01323239c3
FM0       cp (hl)                        ; @0033 be088003c2
          ret z                          ; @0038 c800
          add hl,de                      ; @003A 1900
          djnz FM0                       ; @003C 10038003c2
          scf                            ; @0041 3700
          ret                            ; @0043 c900
