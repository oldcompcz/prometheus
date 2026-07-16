; decoded from 092__findfl_t3_l148_p1_0_p2_106.bin
; source_length=106 symbol_count=5 bridge=4fff
; symbols:
;      1: DIR       value=58000 defined=1 locked=0
;      2: FINDFL    value=40935 defined=1 locked=0
;      3: FF0       value=40943 defined=1 locked=0
;      4: FF1       value=40948 defined=1 locked=0
;      5: FF2       value=40964 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
DIR       equ 58000                      ; @0008 033f80013538303030c7
                                         ; @0012 0030
                                         ; @0014 0030
FINDFL    ld hl,DIR+3072                 ; @0016 210a800280012b33303732c9
          ld de,32                       ; @0022 11023332c2
          ld b,128                       ; @0027 0601313238c3
FF0       ld c,11                        ; @002D 0e0980033131c4
          push hl                        ; @0034 e500
          push ix                        ; @0036 e520
FF1       ld a,(ix+0)                    ; @0038 7e2c800430c3
          xor (hl)                       ; @003E ae00
          jr nz,FF2                      ; @0040 20038005c2
          inc hl                         ; @0045 2300
          inc ix                         ; @0047 2320
          dec c                          ; @0049 0d00
          jr nz,FF1                      ; @004B 20038004c2
          pop ix                         ; @0050 e120
          pop hl                         ; @0052 e100
          ret                            ; @0054 c900
                                         ; @0056 0030
FF2       pop ix                         ; @0058 e1288005c2
          pop hl                         ; @005D e100
          add hl,de                      ; @005F 1900
          djnz FF0                       ; @0061 10038003c2
          scf                            ; @0066 3700
          ret                            ; @0068 c900
