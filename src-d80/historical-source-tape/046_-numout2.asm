; decoded from 046_-numout2_t3_l343_p1_0_p2_276.bin
; source_length=276 symbol_count=6 bridge=f8ff
; symbols:
;      1: START     value=41130 defined=1 locked=0
;      2: DECIM5    value=41181 defined=1 locked=0
;      3: DIGIT21   value=41210 defined=1 locked=0
;      4: DIGIT22   value=41212 defined=1 locked=0
;      5: DIGIT23   value=41226 defined=1 locked=0
;      6: DIGIT24   value=41224 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld a,2                         ; @0008 3e09800132c3
          call #1601                     ; @000E cd022331363031c5
                                         ; @0016 0030
          ld hl,12345                    ; @0018 21023132333435c5
          call DECIM5                    ; @0020 cd028002c2
          ld a,13                        ; @0025 3e013133c2
          rst 16                         ; @002A c7063136c2
                                         ; @002F 0030
          ld hl,1234                     ; @0031 210231323334c4
          call DECIM5                    ; @0038 cd028002c2
          ld a,13                        ; @003D 3e013133c2
          rst 16                         ; @0042 c7063136c2
                                         ; @0047 0030
          ld hl,123                      ; @0049 2102313233c3
          call DECIM5                    ; @004F cd028002c2
          ld a,13                        ; @0054 3e013133c2
          rst 16                         ; @0059 c7063136c2
                                         ; @005E 0030
          ld hl,12                       ; @0060 21023132c2
          call DECIM5                    ; @0065 cd028002c2
          ld a,13                        ; @006A 3e013133c2
          rst 16                         ; @006F c7063136c2
                                         ; @0074 0030
          ld hl,1                        ; @0076 210231c1
          call DECIM5                    ; @007A cd028002c2
          ld a,13                        ; @007F 3e013133c2
          rst 16                         ; @0084 c7063136c2
                                         ; @0089 0030
          ret                            ; @008B c900
                                         ; @008D 0030
                                         ; @008F 0030
                                         ; @0091 0030
DECIM5    ld c," "                       ; @0093 0e098002222022c5
          ld de,10000                    ; @009B 11023130303030c5
          call DIGIT21                   ; @00A3 cd028003c2
          ld de,1000                     ; @00A8 110231303030c4
          call DIGIT21                   ; @00AF cd028003c2
          ld de,100                      ; @00B4 1102313030c3
          call DIGIT21                   ; @00BA cd028003c2
          ld e,10                        ; @00BF 1e013130c2
          call DIGIT21                   ; @00C4 cd028003c2
          ld e,1                         ; @00C9 1e0131c1
          ld c,"0"                       ; @00CD 0e01223022c3
                                         ; @00D3 0030
DIGIT21   ld a,"0"-1                     ; @00D5 3e0980032230222d31c7
DIGIT22   inc a                          ; @00DF 3c088004c2
          or a                           ; @00E4 b700
          sbc hl,de                      ; @00E6 5240
          jr nc,DIGIT22                  ; @00E8 30038004c2
          add hl,de                      ; @00ED 1900
          cp "0"                         ; @00EF fe01223022c3
          jr nz,DIGIT23                  ; @00F5 20038005c2
          ld a,c                         ; @00FA 7900
DIGIT24   rst 16                         ; @00FC c70e80063136c4
          ret                            ; @0103 c900
                                         ; @0105 0030
DIGIT23   ld c,"0"                       ; @0107 0e098005223022c5
          jr DIGIT24                     ; @010F 18038006c2
