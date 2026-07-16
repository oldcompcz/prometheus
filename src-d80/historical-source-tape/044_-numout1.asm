; decoded from 044_-numout1_t3_l560_p1_255_p2_426.bin
; source_length=426 symbol_count=13 bridge=2bff
; symbols:
;      1: START     value=41347 defined=1 locked=0
;      2: DECIMAL5  value=41437 defined=1 locked=0
;      3: DECIMAL4  value=41443 defined=1 locked=0
;      4: DECIMAL3  value=41449 defined=1 locked=0
;      5: DECIMAL2  value=41455 defined=1 locked=0
;      6: DECIMAL1  value=41461 defined=1 locked=0
;      7: HEX4      value=41481 defined=1 locked=0
;      8: HEX3      value=41487 defined=1 locked=0
;      9: HEX2      value=41493 defined=1 locked=0
;     10: HEX1      value=41499 defined=1 locked=0
;     11: DIGIT     value=41464 defined=1 locked=0
;     12: DIGIT2    value=41466 defined=1 locked=0
;     13: DIGIT3    value=41479 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld a,2                         ; @0008 3e09800132c3
          call #1601                     ; @000E cd022331363031c5
                                         ; @0016 0030
          ld hl,12345                    ; @0018 21023132333435c5
          call DECIMAL5                  ; @0020 cd028002c2
          ld a,13                        ; @0025 3e013133c2
          rst 16                         ; @002A c7063136c2
                                         ; @002F 0030
          ld hl,1234                     ; @0031 210231323334c4
          call DECIMAL4                  ; @0038 cd028003c2
          ld a,13                        ; @003D 3e013133c2
          rst 16                         ; @0042 c7063136c2
                                         ; @0047 0030
          ld hl,123                      ; @0049 2102313233c3
          call DECIMAL3                  ; @004F cd028004c2
          ld a,13                        ; @0054 3e013133c2
          rst 16                         ; @0059 c7063136c2
                                         ; @005E 0030
          ld hl,12                       ; @0060 21023132c2
          call DECIMAL2                  ; @0065 cd028005c2
          ld a,13                        ; @006A 3e013133c2
          rst 16                         ; @006F c7063136c2
                                         ; @0074 0030
          ld hl,1                        ; @0076 210231c1
          call DECIMAL1                  ; @007A cd028006c2
          ld a,13                        ; @007F 3e013133c2
          rst 16                         ; @0084 c7063136c2
                                         ; @0089 0030
          ld a,13                        ; @008B 3e013133c2
          rst 16                         ; @0090 c7063136c2
                                         ; @0095 0030
          ld hl,#ABCD                    ; @0097 21022341424344c5
          call HEX4                      ; @009F cd028007c2
          ld a,13                        ; @00A4 3e013133c2
          rst 16                         ; @00A9 c7063136c2
                                         ; @00AE 0030
          ld hl,#ABC                     ; @00B0 210223414243c4
          call HEX3                      ; @00B7 cd028008c2
          ld a,13                        ; @00BC 3e013133c2
          rst 16                         ; @00C1 c7063136c2
                                         ; @00C6 0030
          ld hl,#AB                      ; @00C8 2102234142c3
          call HEX2                      ; @00CE cd028009c2
          ld a,13                        ; @00D3 3e013133c2
          rst 16                         ; @00D8 c7063136c2
                                         ; @00DD 0030
          ld hl,#A                       ; @00DF 21022341c2
          call HEX1                      ; @00E4 cd02800ac2
          ld a,13                        ; @00E9 3e013133c2
          rst 16                         ; @00EE c7063136c2
                                         ; @00F3 0030
          ret                            ; @00F5 c900
                                         ; @00F7 0030
                                         ; @00F9 0030
DECIMAL5  ld de,10000                    ; @00FB 110a80023130303030c7
          call DIGIT                     ; @0105 cd02800bc2
DECIMAL4  ld de,1000                     ; @010A 110a800331303030c6
          call DIGIT                     ; @0113 cd02800bc2
DECIMAL3  ld de,100                      ; @0118 110a8004313030c5
          call DIGIT                     ; @0120 cd02800bc2
DECIMAL2  ld de,10                       ; @0125 110a80053130c4
          call DIGIT                     ; @012C cd02800bc2
DECIMAL1  ld de,1                        ; @0131 110a800631c3
                                         ; @0137 0030
DIGIT     ld a,"0"-1                     ; @0139 3e09800b2230222d31c7
DIGIT2    inc a                          ; @0143 3c08800cc2
          or a                           ; @0148 b700
          sbc hl,de                      ; @014A 5240
          jr nc,DIGIT2                   ; @014C 3003800cc2
          add hl,de                      ; @0151 1900
          cp "9"+1                       ; @0153 fe012239222b31c5
          jr c,DIGIT3                    ; @015B 3803800dc2
          add a,"A"-"9"-1                ; @0160 c6012241222d2239222d31c9
DIGIT3    rst 16                         ; @016C c70e800d3136c4
          ret                            ; @0173 c900
                                         ; @0175 0030
                                         ; @0177 0030
HEX4      ld de,#1000                    ; @0179 110a80072331303030c7
          call DIGIT                     ; @0183 cd02800bc2
HEX3      ld de,#100                     ; @0188 110a800823313030c6
          call DIGIT                     ; @0191 cd02800bc2
HEX2      ld de,#10                      ; @0196 110a8009233130c5
          call DIGIT                     ; @019E cd02800bc2
HEX1      jr DECIMAL1                    ; @01A3 180b800a8006c4
