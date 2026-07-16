; decoded from 048_-sounds1_t3_l481_p1_0_p2_325.bin
; source_length=325 symbol_count=15 bridge=88ff
; symbols:
;      1: SOUND1    value=41287 defined=1 locked=0
;      2: SOUND1A   value=41292 defined=1 locked=0
;      3: SOUND2    value=41303 defined=1 locked=0
;      4: SOUND2A   value=41306 defined=1 locked=0
;      5: SOUND3    value=41318 defined=1 locked=0
;      6: SOUND3B   value=41323 defined=1 locked=0
;      7: SOUND3A   value=41330 defined=1 locked=0
;      8: SOUND4    value=41337 defined=1 locked=0
;      9: SOUND4A   value=41343 defined=1 locked=0
;     10: SOUND4B   value=41349 defined=1 locked=0
;     11: SOUND4C   value=41357 defined=1 locked=0
;     12: BEEP      value=41363 defined=1 locked=0
;     13: BEEP2     value=41367 defined=1 locked=0
;     14: BEEP3     value=41372 defined=1 locked=0
;     15: SOUND     value= 1280 defined=0 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
          call SOUND1                    ; @0008 cd028001c2
          call SOUND2                    ; @000D cd028003c2
          call SOUND3                    ; @0012 cd028005c2
          call SOUND4                    ; @0017 cd028008c2
          jp BEEP                        ; @001C c302800cc2
                                         ; @0021 0030
                                         ; @0023 0030
                                         ; @0025 0030
SOUND1    ld b,128                       ; @0027 06098001313238c5
          ld hl,1000                     ; @002F 210231303030c4
SOUND1A   ld a,(hl)                      ; @0036 7e088002c2
          and 24                         ; @003B e6013234c2
          or 7                           ; @0040 f60137c1
          out (254),a                    ; @0044 d301323534c3
          dec l                          ; @004A 2d00
          djnz SOUND1A                   ; @004C 10038002c2
          ret                            ; @0051 c900
                                         ; @0053 0030
                                         ; @0055 0030
                                         ; @0057 0030
SOUND2    ld hl,92                       ; @0059 210a80033932c4
SOUND2A   ld a,(hl)                      ; @0060 7e088004c2
          or a                           ; @0065 b700
          ret z                          ; @0067 c800
          and 24                         ; @0069 e6013234c2
          or 7                           ; @006E f60137c1
          out (254),a                    ; @0072 d301323534c3
          inc hl                         ; @0078 2300
          jr SOUND2A                     ; @007A 18038004c2
                                         ; @007F 0030
                                         ; @0081 0030
                                         ; @0083 0030
SOUND3    ld b,32                        ; @0085 060980053332c4
          ld hl,1000                     ; @008C 210231303030c4
SOUND3B   ld a,(hl)                      ; @0093 7e088006c2
          and 24                         ; @0098 e6013234c2
          or 7                           ; @009D f60137c1
          out (254),a                    ; @00A1 d301323534c3
SOUND3A   dec a                          ; @00A7 3d088007c2
          jr nz,SOUND3A                  ; @00AC 20038007c2
          dec l                          ; @00B1 2d00
          djnz SOUND3B                   ; @00B3 10038006c2
          ret                            ; @00B8 c900
                                         ; @00BA 0030
                                         ; @00BC 0030
                                         ; @00BE 0030
SOUND4    ld l,200                       ; @00C0 2e098008323030c5
          ld h,100                       ; @00C8 2601313030c3
          ld b,10                        ; @00CE 06013130c2
SOUND4A   ld a,7                         ; @00D3 3e09800937c3
          out (254),a                    ; @00D9 d301323534c3
          dec l                          ; @00DF 2d00
          ld a,l                         ; @00E1 7d00
SOUND4B   dec a                          ; @00E3 3d08800ac2
          jr nz,SOUND4B                  ; @00E8 2003800ac2
          ld a,24+7                      ; @00ED 3e0132342b37c4
          out (254),a                    ; @00F4 d301323534c3
          ld a,h                         ; @00FA 7c00
SOUND4C   dec a                          ; @00FC 3d08800bc2
          jr nz,SOUND4C                  ; @0101 2003800bc2
          djnz SOUND4A                   ; @0106 10038009c2
          ret                            ; @010B c900
                                         ; @010D 0030
                                         ; @010F 0030
                                         ; @0111 0030
BEEP      ld e,1                         ; @0113 1e09800c31c3
          ld a,24                        ; @0119 3e013234c2
BEEP2     ld b,e                         ; @011E 4308800dc2
          out (254),a                    ; @0123 d301323534c3
          xor 24                         ; @0129 ee013234c2
BEEP3     djnz BEEP3                     ; @012E 100b800e800ec4
          dec c                          ; @0135 0d00
          jr nz,BEEP2                    ; @0137 2003800dc2
          sla e                          ; @013C 2380
          jr nc,BEEP2                    ; @013E 3003800dc2
          ret                            ; @0143 c900
