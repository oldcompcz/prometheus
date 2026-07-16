; decoded from 042_-keys2_t3_l489_p1_0_p2_352.bin
; source_length=352 symbol_count=13 bridge=68ff
; symbols:
;      1: MAINLOOP  value=41278 defined=0 locked=0
;      2: SCANNER   value=41332 defined=0 locked=0
;      3: SHOWKEYS  value=41290 defined=0 locked=0
;      4: KEYBOARD  value=41412 defined=0 locked=0
;      5: SHOW1     value=41299 defined=0 locked=0
;      6: SHOW0     value=41301 defined=0 locked=0
;      7: PORTTAB   value=41399 defined=0 locked=0
;      8: SCAN1     value=41343 defined=0 locked=0
;      9: BITTAB    value=41407 defined=0 locked=0
;     10: SCAN2     value=41351 defined=0 locked=0
;     11: SCAN2B    value=41360 defined=0 locked=0
;     12: SCAN3     value=41377 defined=0 locked=0
;     13: SCAN3B    value=41386 defined=0 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
MAINLOOP  call SCANNER                   ; @0008 cd0a80018002c4
          call SHOWKEYS                  ; @000F cd028003c2
                                         ; @0014 0030
          call 8020                      ; @0016 cd0238303230c4
          jr c,MAINLOOP                  ; @001D 38038001c2
          ret                            ; @0022 c900
                                         ; @0024 0030
SHOWKEYS  ld hl,KEYBOARD                 ; @0026 210a80038004c4
          ld ix,22528+33                 ; @002D 212232323532382b3333c8
          ld b,4                         ; @0038 060134c1
SHOW1     ld c,10                        ; @003C 0e0980053130c4
SHOW0     ld a,(hl)                      ; @0043 7e088006c2
          inc hl                         ; @0048 2300
          ld (ix+0),a                    ; @004A 772430c1
          ld (ix+1),a                    ; @004E 772431c1
          ld (ix+32),a                   ; @0052 77243332c2
          ld (ix+33),a                   ; @0057 77243333c2
          inc ix                         ; @005C 2320
          inc ix                         ; @005E 2320
          inc ix                         ; @0060 2320
          dec c                          ; @0062 0d00
          jr nz,SHOW0                    ; @0064 20038006c2
          ld de,66                       ; @0069 11023636c2
          add ix,de                      ; @006E 1920
          djnz SHOW1                     ; @0070 10038005c2
          ret                            ; @0075 c900
                                         ; @0077 0030
                                         ; @0079 0030
SCANNER   ld hl,PORTTAB                  ; @007B 210a80028007c4
          ld ix,KEYBOARD                 ; @0082 21228004c2
          ld e,4                         ; @0087 1e0134c1
          ld c,254                       ; @008B 0e01323534c3
                                         ; @0091 0030
SCAN1     ld b,(hl)                      ; @0093 46088008c2
          inc hl                         ; @0098 2300
          push hl                        ; @009A e500
          ld d,5                         ; @009C 160135c1
          ld hl,BITTAB                   ; @00A0 21028009c2
                                         ; @00A5 0030
SCAN2     in a,(c)                       ; @00A7 7848800ac2
          cpl                            ; @00AC 2f00
          and (hl)                       ; @00AE a600
          inc hl                         ; @00B0 2300
          jr z,SCAN2B                    ; @00B2 2803800bc2
          ld a,255                       ; @00B7 3e01323535c3
SCAN2B    ld (ix+0),a                    ; @00BD 772c800b30c3
          inc ix                         ; @00C3 2320
          dec d                          ; @00C5 1500
          jr nz,SCAN2                    ; @00C7 2003800ac2
                                         ; @00CC 0030
          pop hl                         ; @00CE e100
          ld b,(hl)                      ; @00D0 4600
          inc hl                         ; @00D2 2300
          push hl                        ; @00D4 e500
          ld d,5                         ; @00D6 160135c1
          ld hl,BITTAB+4                 ; @00DA 210280092b34c4
                                         ; @00E1 0030
SCAN3     in a,(c)                       ; @00E3 7848800cc2
          cpl                            ; @00E8 2f00
          and (hl)                       ; @00EA a600
          dec hl                         ; @00EC 2b00
          jr z,SCAN3B                    ; @00EE 2803800dc2
          ld a,255                       ; @00F3 3e01323535c3
SCAN3B    ld (ix+0),a                    ; @00F9 772c800d30c3
          inc ix                         ; @00FF 2320
          dec d                          ; @0101 1500
          jr nz,SCAN3                    ; @0103 2003800cc2
                                         ; @0108 0030
          pop hl                         ; @010A e100
          dec e                          ; @010C 1d00
          jr nz,SCAN1                    ; @010E 20038008c2
          ret                            ; @0113 c900
                                         ; @0115 0030
                                         ; @0117 0030
PORTTAB   defb 247,239                   ; @0119 063f80073234372c323339c9
          defb 251,223                   ; @0125 06373235312c323233c7
          defb 253,191                   ; @012F 06373235332c313931c7
          defb 254,127                   ; @0139 06373235342c313237c7
                                         ; @0143 0030
BITTAB    defb 1,2,4,8,16                ; @0145 063f8009312c322c342c382c3136cc
                                         ; @0154 0030
KEYBOARD  defs 8*5                       ; @0156 083f8004382a35c5
                                         ; @015E 0030
