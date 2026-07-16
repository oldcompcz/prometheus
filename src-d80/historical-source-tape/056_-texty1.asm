; decoded from 056_-texty1_t3_l1044_p1_0_p2_809.bin
; source_length=809 symbol_count=26 bridge=c1ff
; symbols:
;      1: START     value=41831 defined=1 locked=0
;      2: TEXT1     value=42054 defined=1 locked=0
;      3: TEXTOUT   value=42000 defined=1 locked=0
;      4: TEXTOUT2  value=42097 defined=1 locked=0
;      5: TEXTOUT3  value=41986 defined=1 locked=0
;      6: TEXTOUT4  value=41982 defined=1 locked=0
;      7: LOOP      value=41878 defined=1 locked=0
;      8: TEXTS     value=42109 defined=1 locked=0
;      9: TOUT3A    value=41992 defined=1 locked=0
;     10: TOUT2A    value=42098 defined=1 locked=0
;     11: TEXTOUT5  value=41973 defined=1 locked=0
;     12: TEXTOUT6  value=41961 defined=1 locked=0
;     13: T1        value=42036 defined=1 locked=0
;     14: T0        value=42028 defined=1 locked=0
;     15: T2        value=42046 defined=1 locked=0
;     16: TEXTY     value=42010 defined=1 locked=0
;     17: L1        value=42017 defined=1 locked=0
;     18: L0        value=42011 defined=1 locked=0
;     19: L3        value=42022 defined=1 locked=0
;     20: L2        value=42018 defined=1 locked=0
;     21: L5        value=42028 defined=1 locked=0
;     22: L4        value=42023 defined=1 locked=0
;     23: TEXTOUT7  value=41940 defined=1 locked=0
;     24: TOUT7A    value=41954 defined=1 locked=0
;     25: TOUT7B    value=41948 defined=1 locked=0
;     26: TOUT7C    value=41955 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     call #D6B                      ; @0008 cd0a800123443642c6
          ld a,2                         ; @0011 3e0132c1
          call #1601                     ; @0015 cd022331363031c5
                                         ; @001D 0030
          ld hl,TEXT1                    ; @001F 21028002c2
          call TEXTOUT                   ; @0024 cd028003c2
                                         ; @0029 0030
          call TEXTOUT2                  ; @002B cd028004c2
          defb 22,5,5                    ; @0030 063732322c352c35c6
          defm 'Text no.2'               ; @0039 07372754657874206e6f2e3227cb
                                         ; @0047 0030
          ld a,22                        ; @0049 3e013232c2
          rst 16                         ; @004E c7063136c2
          xor a                          ; @0053 af00
          rst 16                         ; @0055 c7063136c2
          xor a                          ; @005A af00
          rst 16                         ; @005C c7063136c2
                                         ; @0061 0030
          ld a,3                         ; @0063 3e0133c1
          call TEXTOUT3                  ; @0067 cd028005c2
                                         ; @006C 0030
          call TEXTOUT4                  ; @006E cd028006c2
          defb 5                         ; @0073 063735c1
                                         ; @0077 0030
          ld b,5                         ; @0079 060135c1
LOOP      ld a,22                        ; @007D 3e0980073232c4
          rst 16                         ; @0084 c7063136c2
          ld a,b                         ; @0089 7800
          add a,a                        ; @008B 8700
          rst 16                         ; @008D c7063136c2
          ld a,25                        ; @0092 3e013235c2
          sub b                          ; @0097 9000
          rst 16                         ; @0099 c7063136c2
          ld a,17                        ; @009E 3e013137c2
          rst 16                         ; @00A3 c7063136c2
          ld a,b                         ; @00A8 7800
          rst 16                         ; @00AA c7063136c2
          ld a,16                        ; @00AF 3e013136c2
          rst 16                         ; @00B4 c7063136c2
          ld a,9                         ; @00B9 3e0139c1
          rst 16                         ; @00BD c7063136c2
                                         ; @00C2 0030
          ld a,b                         ; @00C4 7800
          dec a                          ; @00C6 3d00
          call TEXTOUT3                  ; @00C8 cd028005c2
          djnz LOOP                      ; @00CD 10038007c2
                                         ; @00D2 0030
          ld a,17                        ; @00D4 3e013137c2
          rst 16                         ; @00D9 c7063136c2
          ld a,6                         ; @00DE 3e0136c1
          rst 16                         ; @00E2 c7063136c2
                                         ; @00E7 0030
          call TEXTOUT5                  ; @00E9 cd02800bc2
          defw TEXTS                     ; @00EE 09378008c2
                                         ; @00F3 0030
          call TEXTOUT6                  ; @00F5 cd02800cc2
          defb T1-T0                     ; @00FA 0637800d2d800ec5
          call TEXTOUT6                  ; @0102 cd02800cc2
          defb T2-T0                     ; @0107 0637800f2d800ec5
                                         ; @010F 0030
          ld a,2                         ; @0111 3e0132c1
          call TEXTOUT7                  ; @0115 cd028017c2
          ld a,1                         ; @011A 3e0131c1
          call TEXTOUT7                  ; @011E cd028017c2
          xor a                          ; @0123 af00
          call TEXTOUT7                  ; @0125 cd028017c2
                                         ; @012A 0030
          ret                            ; @012C c900
                                         ; @012E 0030
                                         ; @0130 0030
TEXTOUT7  ld hl,TEXTY                    ; @0132 210a80178010c4
          or a                           ; @0139 b700
          jr z,TOUT7A                    ; @013B 28038018c2
          ld b,0                         ; @0140 060130c1
TOUT7B    ld c,(hl)                      ; @0144 4e088019c2
          inc hl                         ; @0149 2300
          add hl,bc                      ; @014B 0900
          dec a                          ; @014D 3d00
          jr nz,TOUT7B                   ; @014F 20038019c2
TOUT7A    ld b,(hl)                      ; @0154 46088018c2
TOUT7C    inc hl                         ; @0159 2308801ac2
          ld a,(hl)                      ; @015E 7e00
          rst 16                         ; @0160 c7063136c2
          djnz TOUT7C                    ; @0165 1003801ac2
          ret                            ; @016A c900
                                         ; @016C 0030
TEXTOUT6  pop hl                         ; @016E e108800cc2
          ld c,(hl)                      ; @0173 4e00
          inc hl                         ; @0175 2300
          push hl                        ; @0177 e500
          ld b,0                         ; @0179 060130c1
          ld hl,T0                       ; @017D 2102800ec2
          add hl,bc                      ; @0182 0900
          jr TEXTOUT                     ; @0184 18038003c2
                                         ; @0189 0030
TEXTOUT5  pop hl                         ; @018B e108800bc2
          ld e,(hl)                      ; @0190 5e00
          inc hl                         ; @0192 2300
          ld d,(hl)                      ; @0194 5600
          inc hl                         ; @0196 2300
          push hl                        ; @0198 e500
          ex de,hl                       ; @019A eb00
          jr TEXTOUT                     ; @019C 18038003c2
                                         ; @01A1 0030
TEXTOUT4  pop hl                         ; @01A3 e1088006c2
          ld a,(hl)                      ; @01A8 7e00
          inc hl                         ; @01AA 2300
          push hl                        ; @01AC e500
                                         ; @01AE 0030
TEXTOUT3  ld hl,TEXTS                    ; @01B0 210a80058008c4
          or a                           ; @01B7 b700
          jr z,TEXTOUT                   ; @01B9 28038003c2
TOUT3A    bit 7,(hl)                     ; @01BE 7e888009c2
          inc hl                         ; @01C3 2300
          jr z,TOUT3A                    ; @01C5 28038009c2
          dec a                          ; @01CA 3d00
          jr nz,TOUT3A                   ; @01CC 20038009c2
                                         ; @01D1 0030
TEXTOUT   ld a,(hl)                      ; @01D3 7e088003c2
          and 127                        ; @01D8 e601313237c3
          rst 16                         ; @01DE c7063136c2
          bit 7,(hl)                     ; @01E3 7e80
          inc hl                         ; @01E5 2300
          jr z,TEXTOUT                   ; @01E7 28038003c2
          ret                            ; @01EC c900
                                         ; @01EE 0030
TEXTY     defb L1-L0                     ; @01F0 063f801080112d8012c7
L0        defm "franta"                  ; @01FA 073f8012226672616e746122ca
L1        defb L3-L2                     ; @0207 063f801180132d8014c7
L2        defm "pepa"                    ; @0211 073f8014227065706122c8
L3        defb L5-L4                     ; @021C 063f801380152d8016c7
L4        defm "alois"                   ; @0226 073f801622616c6f697322c9
L5                                       ; @0232 00388015c2
                                         ; @0237 0030
T0        defm 'text T0 '                ; @0239 073f800e27746578742054302027cc
T1        defm "text T1 & "              ; @0248 073f800d227465787420543120262022ce
T2        defm 'text T2 '                ; @0259 073f800f27746578742054322027cc
                                         ; @0268 0030
TEXT1     defb 22,15,10                  ; @026A 063f800232322c31352c3130ca
          defb 17,6                      ; @0277 063731372c36c4
          defm "Text no.1"               ; @027E 07372254657874206e6f2e3122cb
          defb 22,21,1                   ; @028C 063732322c32312c31c7
          defb 17,4                      ; @0296 063731372c34c4
          defb 19,1                      ; @029D 063731392c31c4
          defm "This is also"            ; @02A4 0737225468697320697320616c736f22ce
          defm ' text no.1'              ; @02B5 0737272074657874206e6f2e3127cc
                                         ; @02C4 0030
TEXTOUT2  pop hl                         ; @02C6 e1088004c2
TOUT2A    ld a,(hl)                      ; @02CB 7e08800ac2
          and 127                        ; @02D0 e601313237c3
          and 16                         ; @02D6 e6013136c2
          bit 7,(hl)                     ; @02DB 7e80
          inc hl                         ; @02DD 2300
          jr z,TOUT2A                    ; @02DF 2803800ac2
          jp (hl)                        ; @02E4 e900
                                         ; @02E6 0030
TEXTS     defm 'First'                   ; @02E8 073f800827466972737427c9
          defm 'Second'                  ; @02F4 0737275365636f6e6427c8
          defm 'Third'                   ; @02FF 073727546869726427c7
          defm 'Forth'                   ; @0309 073727466f72746827c7
          defm 'Fifth'                   ; @0313 073727466966746827c7
          defm ' text'                   ; @031D 073727207465787427c7
                                         ; @0327 0030
