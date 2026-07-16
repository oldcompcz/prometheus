; decoded from 074__cntfls_t3_l114_p1_0_p2_79.bin
; source_length=79 symbol_count=4 bridge=7fff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: CNTFLS    value=40901 defined=1 locked=0
;      3: CF0       value=40912 defined=1 locked=0
;      4: CF1       value=40916 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
DIR       equ 58000                      ; @0008 033f80013538303030c7
                                         ; @0012 0030
                                         ; @0014 0030
CNTFLS    ld hl,DIR+3072                 ; @0016 210a800280012b33303732c9
          ld de,32                       ; @0022 11023332c2
          ld bc,#8000                    ; @0027 01022338303030c5
          ld a,229                       ; @002F 3e01323239c3
CF0       cp (hl)                        ; @0035 be088003c2
          jr z,CF1                       ; @003A 28038004c2
          inc c                          ; @003F 0c00
CF1       add hl,de                      ; @0041 19088004c2
          djnz CF0                       ; @0046 10038003c2
          ld a,c                         ; @004B 7900
          ret                            ; @004D c900
