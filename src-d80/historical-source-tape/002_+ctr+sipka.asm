; decoded from 002_+ctr+sipka_t3_l2706_p1_0_p2_2096.bin
; source_length=2096 symbol_count=69 bridge=5eff
; symbols:
;      1: DOWNHL    value=44357 defined=1 locked=0
;      2: DOWNHL2   value=44372 defined=1 locked=0
;      3: UPHL      value=44336 defined=1 locked=0
;      4: UPHL2     value=44351 defined=1 locked=0
;      5: START     value=43691 defined=1 locked=0
;      6: TEXT2     value=44217 defined=1 locked=0
;      7: TEXT1     value=44182 defined=1 locked=0
;      8: CHAR      value=43814 defined=1 locked=0
;      9: R1        value=43699 defined=1 locked=0
;     10: KEYCNT    value=43973 defined=1 locked=0
;     11: TEXTOUT   value=43792 defined=1 locked=0
;     12: REDEFINE  value=44292 defined=1 locked=0
;     13: MAIN      value=43732 defined=1 locked=0
;     14: R3        value=43740 defined=1 locked=0
;     15: KEYRET    value=43970 defined=1 locked=0
;     16: BEEP      value=44262 defined=1 locked=0
;     17: KEYS      value=44044 defined=1 locked=0
;     18: MAIN2     value=43762 defined=1 locked=0
;     19: MAIN3     value=43774 defined=1 locked=0
;     20: MAIN6     value=43765 defined=1 locked=0
;     21: NUMCHAR   value=44165 defined=1 locked=0
;     22: TEXTOUT2  value=43802 defined=1 locked=0
;     23: STOP      value=43779 defined=1 locked=0
;     24: PRINTPOS  value=43824 defined=1 locked=0
;     25: CH2       value=43831 defined=1 locked=0
;     26: NEXTDE4   value=43945 defined=1 locked=0
;     27: REPAIR1   value=43851 defined=1 locked=0
;     28: L1        value=43839 defined=1 locked=0
;     29: L2        value=43872 defined=1 locked=0
;     30: L3        value=43847 defined=1 locked=0
;     31: OK3       value=43876 defined=1 locked=0
;     32: NEXTDE3   value=43950 defined=1 locked=0
;     33: NEXTDE6   value=43942 defined=1 locked=0
;     34: REPAIR2   value=43903 defined=1 locked=0
;     35: L1B       value=43891 defined=1 locked=0
;     36: L2B       value=43913 defined=1 locked=0
;     37: L3B       value=43899 defined=1 locked=0
;     38: OK4       value=43917 defined=1 locked=0
;     39: CH3       value=43940 defined=1 locked=0
;     40: NEXTDE2   value=43948 defined=1 locked=0
;     41: NEXTDE    value=43951 defined=1 locked=0
;     42: TABKEY    value=44021 defined=1 locked=0
;     43: KEYLOOP   value=43976 defined=1 locked=0
;     44: KEY2      value=43987 defined=1 locked=0
;     45: KEYGET    value=44000 defined=1 locked=0
;     46: TABBITS   value=44039 defined=1 locked=0
;     47: KEY3      value=44007 defined=1 locked=0
;     48: KEYOK     value=44018 defined=1 locked=0
;     49: OK5       value=44180 defined=1 locked=0
;     50: A2        value=44273 defined=1 locked=0
;     51: A1        value=44278 defined=1 locked=0
;     52: CONTROLS  value=44307 defined=1 locked=0
;     53: CLP       value=44313 defined=1 locked=0
;     54: NCPL      value=44324 defined=1 locked=0
;     55: CN        value=44330 defined=1 locked=0
;     56: SIPKA     value=44378 defined=1 locked=0
;     57: MATRIX    value=44546 defined=1 locked=0
;     58: FREE32    value=44578 defined=1 locked=0
;     59: RESSIP    value=44461 defined=1 locked=0
;     60: POCROT    value=44419 defined=1 locked=0
;     61: SLQP      value=44403 defined=1 locked=0
;     62: SLOP2     value=44422 defined=1 locked=0
;     63: RIGHTL    value=44538 defined=1 locked=0
;     64: RLOOOP    value=44469 defined=1 locked=0
;     65: AA1       value=44505 defined=1 locked=0
;     66: AA3       value=44525 defined=1 locked=0
;     67: AA2       value=44518 defined=1 locked=0
;     68: AA4       value=44532 defined=1 locked=0
;     69: HALT      value=43785 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     im 1                           ; @0008 56488005c2
          ei                             ; @000D fb00
                                         ; @000F 0030
          ld hl,1000                     ; @0011 210231303030c4
          ld c,0                         ; @0018 0e0130c1
R1        in a,(31)                      ; @001C db0980093331c4
          or c                           ; @0023 b100
          ld c,a                         ; @0025 4f00
          dec hl                         ; @0027 2b00
          ld a,h                         ; @0029 7c00
          or l                           ; @002B b500
          jr nz,R1                       ; @002D 20038009c2
          ld a,c                         ; @0032 7900
          cp 32                          ; @0034 fe013332c2
          ld a,8                         ; @0039 3e0138c1
          adc a,0                        ; @003D ce0130c1
          ld (KEYCNT+2),a                ; @0041 3202800a2b32c4
                                         ; @0048 0030
          ld hl,TEXT1                    ; @004A 21028007c2
          call TEXTOUT                   ; @004F cd02800bc2
          ld hl,TEXT2                    ; @0054 21028006c2
          ld de,REDEFINE                 ; @0059 1102800cc2
                                         ; @005E 0030
          ld b,5                         ; @0060 060135c1
MAIN      push bc                        ; @0064 c508800dc2
          call TEXTOUT                   ; @0069 cd02800bc2
          push hl                        ; @006E e500
          push de                        ; @0070 d500
                                         ; @0072 0030
          ld b,20                        ; @0074 06013230c2
R3        halt                           ; @0079 7608800ec2
          djnz R3                        ; @007E 1003800ec2
          call KEYRET                    ; @0083 cd02800fc2
          call BEEP                      ; @0088 cd028010c2
          pop hl                         ; @008D e100
          ld (hl),c                      ; @008F 7100
          inc hl                         ; @0091 2300
          ld (hl),b                      ; @0093 7000
          inc hl                         ; @0095 2300
          ld (hl),a                      ; @0097 7700
          inc hl                         ; @0099 2300
          ld a,e                         ; @009B 7b00
          push hl                        ; @009D e500
          ld hl,KEYS                     ; @009F 21028011c2
          inc e                          ; @00A4 1c00
MAIN2     dec e                          ; @00A6 1d088012c2
          jr z,MAIN3                     ; @00AB 28038013c2
MAIN6     inc hl                         ; @00B0 23088014c2
          ld a,(hl)                      ; @00B5 7e00
          call NUMCHAR                   ; @00B7 cd028015c2
          jr nz,MAIN6                    ; @00BC 20038014c2
          jr MAIN2                       ; @00C1 18038012c2
                                         ; @00C6 0030
MAIN3     call TEXTOUT2                  ; @00C8 cd0a80138016c4
          pop de                         ; @00CF d100
          pop hl                         ; @00D1 e100
STOP      inc hl                         ; @00D3 23088017c2
          pop bc                         ; @00D8 c100
          djnz MAIN                      ; @00DA 1003800dc2
                                         ; @00DF 0030
          ld b,10                        ; @00E1 06013130c2
HALT      ei                             ; @00E6 fb088045c2
          halt                           ; @00EB 7600
          djnz HALT                      ; @00ED 10038045c2
                                         ; @00F2 0030
          jp SIPKA                       ; @00F4 c3028038c2
                                         ; @00F9 0030
                                         ; @00FB 0030
TEXTOUT   push de                        ; @00FD d508800bc2
          ld e,(hl)                      ; @0102 5e00
          inc hl                         ; @0104 2300
          ld d,(hl)                      ; @0106 5600
          inc hl                         ; @0108 2300
          ld (PRINTPOS+1),de             ; @010A 534280182b31c4
          pop de                         ; @0111 d100
TEXTOUT2  ld a,(hl)                      ; @0113 7e088016c2
          call CHAR                      ; @0118 cd028008c2
          inc hl                         ; @011D 2300
          ld a,(hl)                      ; @011F 7e00
          call NUMCHAR                   ; @0121 cd028015c2
          jr nz,TEXTOUT2                 ; @0126 20038016c2
          ret                            ; @012B c900
                                         ; @012D 0030
CHAR      exx                            ; @012F d9088008c2
          ld (CH2+1),a                   ; @0134 320280192b31c4
          add a,a                        ; @013B 8700
          ld l,a                         ; @013D 6f00
          ld h,15                        ; @013F 26013135c2
          add hl,hl                      ; @0144 2900
          add hl,hl                      ; @0146 2900
PRINTPOS  ld de,0                        ; @0148 110a801830c3
          push de                        ; @014E d500
                                         ; @0150 0030
          call NEXTDE4                   ; @0152 cd02801ac2
                                         ; @0157 0030
CH2       ld a,0                         ; @0159 3e09801930c3
          push hl                        ; @015F e500
          ld hl,REPAIR1                  ; @0161 2102801bc2
          ld b,(hl)                      ; @0166 4600
          inc hl                         ; @0168 2300
L1        cp (hl)                        ; @016A be08801cc2
          jr z,L2                        ; @016F 2803801dc2
          jr c,L3                        ; @0174 3803801ec2
          inc hl                         ; @0179 2300
          djnz L1                        ; @017B 1003801cc2
L3        pop hl                         ; @0180 e108801ec2
          ld a,(hl)                      ; @0185 7e00
          jr OK3                         ; @0187 1803801fc2
                                         ; @018C 0030
REPAIR1   defb 22                        ; @018E 063f801b3232c4
          defm "#$^acegmnopqr"           ; @0195 07372223245e616365676d6e6f70717222cf
          defm "stuvwxy"                 ; @01A7 0737227374757677787922c9
                                         ; @01B3 0030
L2        pop hl                         ; @01B5 e108801dc2
          dec hl                         ; @01BA 2b00
          ld a,(hl)                      ; @01BC 7e00
          inc hl                         ; @01BE 2300
OK3       call NEXTDE3                   ; @01C0 cd0a801f8020c4
          call NEXTDE6                   ; @01C7 cd028021c2
                                         ; @01CC 0030
          ld a,(CH2+1)                   ; @01CE 3a0280192b31c4
          push hl                        ; @01D5 e500
          ld hl,REPAIR2                  ; @01D7 21028022c2
          ld b,(hl)                      ; @01DC 4600
          inc hl                         ; @01DE 2300
L1B       cp (hl)                        ; @01E0 be088023c2
          jr z,L2B                       ; @01E5 28038024c2
          jr c,L3B                       ; @01EA 38038025c2
          inc hl                         ; @01EF 2300
          djnz L1B                       ; @01F1 10038023c2
L3B       pop hl                         ; @01F6 e1088025c2
          ld a,(hl)                      ; @01FB 7e00
          jr OK4                         ; @01FD 18038026c2
                                         ; @0202 0030
REPAIR2   defb 9                         ; @0204 063f802239c3
          defm "#4=Wgpqy{7F}"            ; @020A 07372223343d57677071797f22cb
                                         ; @0218 0030
L2B       pop hl                         ; @021A e1088024c2
          dec hl                         ; @021F 2b00
          ld a,(hl)                      ; @0221 7e00
          inc hl                         ; @0223 2300
OK4       call NEXTDE3                   ; @0225 cd0a80268020c4
          call NEXTDE6                   ; @022C cd028021c2
                                         ; @0231 0030
          pop hl                         ; @0233 e100
          inc l                          ; @0235 2c00
          ld (PRINTPOS+1),hl             ; @0237 220280182b31c4
          ld a,l                         ; @023E 7d00
          and 31                         ; @0240 e6013331c2
          jr nz,CH3                      ; @0245 20038027c2
          ld bc,32                       ; @024A 01023332c2
          add hl,bc                      ; @024F 0900
          ld (PRINTPOS+1),hl             ; @0251 220280182b31c4
CH3       exx                            ; @0258 d9088027c2
          ret                            ; @025D c900
NEXTDE6   call NEXTDE2                   ; @025F cd0a80218028c4
NEXTDE4   call NEXTDE2                   ; @0266 cd0a801a8028c4
NEXTDE2   ld a,(hl)                      ; @026D 7e088028c2
          inc hl                         ; @0272 2300
NEXTDE3   ld (de),a                      ; @0274 12088020c2
NEXTDE    inc d                          ; @0279 14088029c2
          ld a,d                         ; @027E 7a00
          and 7                          ; @0280 e60137c1
          ret nz                         ; @0284 c000
          ld a,d                         ; @0286 7a00
          sub 8                          ; @0288 d60138c1
          ld d,a                         ; @028C 5700
          ld a,e                         ; @028E 7b00
          add a,32                       ; @0290 c6013332c2
          ld e,a                         ; @0295 5f00
          ret nc                         ; @0297 d000
          ld a,d                         ; @0299 7a00
          add a,8                        ; @029B c60138c1
          ld d,a                         ; @029F 5700
          ret                            ; @02A1 c900
                                         ; @02A3 0030
KEYRET    ld hl,TABKEY                   ; @02A5 210a800f802ac4
KEYCNT    ld de,#900                     ; @02AC 110a800a23393030c6
KEYLOOP   ld c,(hl)                      ; @02B5 4e08802bc2
          inc hl                         ; @02BA 2300
          ld b,(hl)                      ; @02BC 4600
          inc hl                         ; @02BE 2300
          in a,(c)                       ; @02C0 7840
          bit 7,c                        ; @02C2 7980
          jr z,KEY2                      ; @02C4 2803802cc2
          cpl                            ; @02C9 2f00
KEY2      and 31                         ; @02CB e609802c3331c4
          jr nz,KEYGET                   ; @02D2 2003802dc2
          ld a,e                         ; @02D7 7b00
          add a,5                        ; @02D9 c60135c1
          ld e,a                         ; @02DD 5f00
          dec d                          ; @02DF 1500
          jr nz,KEYLOOP                  ; @02E1 2003802bc2
          jr KEYRET                      ; @02E6 1803800fc2
                                         ; @02EB 0030
KEYGET    push hl                        ; @02ED e508802dc2
          push bc                        ; @02F2 c500
          ld hl,TABBITS                  ; @02F4 2102802ec2
          ld b,5                         ; @02F9 060135c1
KEY3      cp (hl)                        ; @02FD be08802fc2
          jr z,KEYOK                     ; @0302 28038030c2
          inc hl                         ; @0307 2300
          inc e                          ; @0309 1c00
          djnz KEY3                      ; @030B 1003802fc2
          pop bc                         ; @0310 c100
          pop hl                         ; @0312 e100
          jr KEYRET                      ; @0314 1803800fc2
                                         ; @0319 0030
KEYOK     pop bc                         ; @031B c1088030c2
          pop hl                         ; @0320 e100
          ret                            ; @0322 c900
                                         ; @0324 0030
TABKEY    defw 63486,61438               ; @0326 093f802a36333438362c3631343338cd
          defw 65278,65022               ; @0336 093736353237382c3635303232cb
          defw 64510,57342               ; @0344 093736343531302c3537333432cb
          defw 49150,32766               ; @0352 093734393135302c3332373636cb
          defw 31                        ; @0360 09373331c2
                                         ; @0365 0030
TABBITS   defb 1,2,4,8,16                ; @0367 063f802e312c322c342c382c3136cc
                                         ; @0376 0030
KEYS      defm "12345"                   ; @0378 073f801122313233343522c9
          defm "09876"                   ; @0384 073722303938373622c7
          defm "CapsZXCV"                ; @038E 073722436170735a58435622ca
          defm "ASDFG"                   ; @039B 073722415344464722c7
          defm "QWERT"                   ; @03A5 073722515745525422c7
          defm "POIUY"                   ; @03AF 073722504f49555922c7
          defm "EnterLKJH"               ; @03B9 073722456e7465724c4b4a4822cb
          defm "SpaceSymbolMNB"          ; @03C7 073722537061636553796d626f6c4d4e4222d0
          defm "Kempston right"          ; @03DA 0737224b656d7073746f6e20726967687422d0
          defm "Kempston left"           ; @03ED 0737224b656d7073746f6e206c65667422cf
          defm "Kempston down"           ; @03FF 0737224b656d7073746f6e20646f776e22cf
          defm "Kempston up"             ; @0411 0737224b656d7073746f6e20757022cd
          defm "Kempston fire"           ; @0421 0737224b656d7073746f6e206669726522cf
          defm "A"                       ; @0433 0737224122c3
                                         ; @0439 0030
NUMCHAR   cp "0"                         ; @043B fe098015223022c5
          ret c                          ; @0443 d800
          cp "9"+1                       ; @0445 fe012239222b31c5
          jr c,OK5                       ; @044D 38038031c2
          cp "A"                         ; @0452 fe01224122c3
          ret c                          ; @0458 d800
          cp "Z"                         ; @045A fe01225a22c3
          jr z,OK5                       ; @0460 28038031c2
          ret nc                         ; @0465 d000
OK5       cp a                           ; @0467 bf088031c2
          ret                            ; @046C c900
                                         ; @046E 0030
TEXT1     defw 16384+160                 ; @0470 093f800731363338342b313630cb
          defm "Select a key "           ; @047E 07372253656c6563742061206b65792022cf
          defm "or move "                ; @0490 0737226f72206d6f76652022ca
          defm "joystick toA"            ; @049D 0737226a6f79737469636b20746f4122ce
                                         ; @04AE 0030
TEXT2     defw 18440                     ; @04B0 093f80063138343430c7
          defm "Right:A"                 ; @04BA 07372252696768743a4122c9
                                         ; @04C6 0030
          defw 18440+64                  ; @04C8 093731383434302b3634c8
          defm "Left :A"                 ; @04D3 0737224c656674203a4122c9
                                         ; @04DF 0030
          defw 18440+128                 ; @04E1 093731383434302b313238c9
          defm "Down :A"                 ; @04ED 073722446f776e203a4122c9
                                         ; @04F9 0030
          defw 18440+192                 ; @04FB 093731383434302b313932c9
          defm "Up   :A"                 ; @0507 07372255702020203a4122c9
                                         ; @0513 0030
          defw 20488                     ; @0515 09373230343838c5
          defm "Fire :A"                 ; @051D 07372246697265203a4122c9
                                         ; @0529 0030
BEEP      push hl                        ; @052B e5088010c2
          push de                        ; @0530 d500
          push bc                        ; @0532 c500
          push af                        ; @0534 f500
          ld e,30                        ; @0536 1e013330c2
          ld hl,300                      ; @053B 2102333030c3
          ld a,16                        ; @0541 3e013136c2
A2        ld b,e                         ; @0546 43088032c2
          xor 16                         ; @054B ee013136c2
          or 7                           ; @0550 f60137c1
A1        out (254),a                    ; @0554 d3098033323534c5
          djnz A1                        ; @055C 10038033c2
          dec hl                         ; @0561 2b00
          inc h                          ; @0563 2400
          dec h                          ; @0565 2500
          jr nz,A2                       ; @0567 20038032c2
          pop af                         ; @056C f100
          pop bc                         ; @056E c100
          pop de                         ; @0570 d100
          pop hl                         ; @0572 e100
          ret                            ; @0574 c900
                                         ; @0576 0030
REDEFINE  defs 15                        ; @0578 083f800c3135c4
                                         ; @057F 0030
CONTROLS  ld hl,REDEFINE                 ; @0581 210a8034800cc4
          ld de,5                        ; @0588 110235c1
CLP       ld c,(hl)                      ; @058C 4e088035c2
          inc hl                         ; @0591 2300
          ld b,(hl)                      ; @0593 4600
          inc hl                         ; @0595 2300
          in a,(c)                       ; @0597 7840
          bit 7,c                        ; @0599 7980
          jr z,NCPL                      ; @059B 28038036c2
          cpl                            ; @05A0 2f00
NCPL      and (hl)                       ; @05A2 a6088036c2
          inc hl                         ; @05A7 2300
          jr z,CN                        ; @05A9 28038037c2
          set 5,d                        ; @05AE ea80
CN        srl d                          ; @05B0 3a888037c2
          dec e                          ; @05B5 1d00
          jr nz,CLP                      ; @05B7 20038035c2
          ret                            ; @05BC c900
                                         ; @05BE 0030
                                         ; @05C0 0030
UPHL      ld a,h                         ; @05C2 7c088003c2
          dec h                          ; @05C7 2500
          and 7                          ; @05C9 e60137c1
          ret nz                         ; @05CD c000
          ld a,l                         ; @05CF 7d00
          sub 32                         ; @05D1 d6013332c2
          ld l,a                         ; @05D6 6f00
          ld a,h                         ; @05D8 7c00
          jr c,UPHL2                     ; @05DA 38038004c2
          add a,8                        ; @05DF c60138c1
          ld h,a                         ; @05E3 6700
UPHL2     cp 64                          ; @05E5 fe0980043634c4
          ret nc                         ; @05EC d000
          ld h,87                        ; @05EE 26013837c2
          ret                            ; @05F3 c900
                                         ; @05F5 0030
                                         ; @05F7 0030
DOWNHL    inc h                          ; @05F9 24088001c2
          ld a,h                         ; @05FE 7c00
          and 7                          ; @0600 e60137c1
          ret nz                         ; @0604 c000
          ld a,l                         ; @0606 7d00
          add a,32                       ; @0608 c6013332c2
          ld l,a                         ; @060D 6f00
          ld a,h                         ; @060F 7c00
          jr c,DOWNHL2                   ; @0611 38038002c2
          sub 8                          ; @0616 d60138c1
          ld h,a                         ; @061A 6700
DOWNHL2   cp 88                          ; @061C fe0980023838c4
          ret c                          ; @0623 d800
          ld h,64                        ; @0625 26013634c2
          ret                            ; @062A c900
                                         ; @062C 0030
                                         ; @062E 0030
SIPKA     ld bc,#2464                    ; @0630 010a80382332343634c7
          push bc                        ; @063A c500
          ld ix,MATRIX                   ; @063C 21228039c2
          exx                            ; @0641 d900
          ld hl,FREE32                   ; @0643 2102803ac2
          exx                            ; @0648 d900
          ld a,b                         ; @064A 7800
          call #22B1                     ; @064C cd022332324231c5
          ld (RESSIP+1),hl               ; @0654 2202803b2b31c4
          ld (POCROT+1),a                ; @065B 3202803c2b31c4
                                         ; @0662 0030
          ld b,16                        ; @0664 06013136c2
SLQP      push bc                        ; @0669 c508803dc2
          push hl                        ; @066E e500
          push hl                        ; @0670 e500
          ld h,0                         ; @0672 260130c1
          ld l,(ix+0)                    ; @0676 6e2430c1
          ld d,h                         ; @067A 5400
          ld e,(ix+16)                   ; @067C 5e243136c2
          inc ix                         ; @0681 2320
          ld a,8                         ; @0683 3e0138c1
POCROT    sub 0                          ; @0687 d609803c30c3
          ld b,a                         ; @068D 4700
SLOP2     add hl,hl                      ; @068F 2908803ec2
          ex de,hl                       ; @0694 eb00
          add hl,hl                      ; @0696 2900
          ex de,hl                       ; @0698 eb00
          djnz SLOP2                     ; @069A 1003803ec2
                                         ; @069F 0030
          ex (sp),hl                     ; @06A1 e300
          pop bc                         ; @06A3 c100
          ld a,(hl)                      ; @06A5 7e00
          exx                            ; @06A7 d900
          ld (hl),a                      ; @06A9 7700
          inc hl                         ; @06AB 2300
          exx                            ; @06AD d900
          ld a,d                         ; @06AF 7a00
          cpl                            ; @06B1 2f00
          and (hl)                       ; @06B3 a600
          or b                           ; @06B5 b000
          ld (hl),a                      ; @06B7 7700
          call RIGHTL                    ; @06B9 cd02803fc2
          ld a,(hl)                      ; @06BE 7e00
          exx                            ; @06C0 d900
          ld (hl),a                      ; @06C2 7700
          inc hl                         ; @06C4 2300
          exx                            ; @06C6 d900
          ld a,e                         ; @06C8 7b00
          cpl                            ; @06CA 2f00
          and (hl)                       ; @06CC a600
          or c                           ; @06CE b100
          ld (hl),a                      ; @06D0 7700
          pop hl                         ; @06D2 e100
                                         ; @06D4 0030
          call DOWNHL                    ; @06D6 cd028001c2
          pop bc                         ; @06DB c100
          djnz SLQP                      ; @06DD 1003803dc2
                                         ; @06E2 0030
          halt                           ; @06E4 7600
                                         ; @06E6 0030
RESSIP    ld hl,0                        ; @06E8 210a803b30c3
          ld b,16                        ; @06EE 06013136c2
          ld de,FREE32                   ; @06F3 1102803ac2
RLOOOP    ld a,(de)                      ; @06F8 1a088040c2
          ld (hl),a                      ; @06FD 7700
          inc de                         ; @06FF 1300
          push hl                        ; @0701 e500
          call RIGHTL                    ; @0703 cd02803fc2
          ld a,(de)                      ; @0708 1a00
          ld (hl),a                      ; @070A 7700
          inc de                         ; @070C 1300
          pop hl                         ; @070E e100
          call DOWNHL                    ; @0710 cd028001c2
          djnz RLOOOP                    ; @0715 10038040c2
                                         ; @071A 0030
          call CONTROLS                  ; @071C cd028034c2
                                         ; @0721 0030
          pop hl                         ; @0723 e100
          bit 4,d                        ; @0725 6280
          ret nz                         ; @0727 c000
                                         ; @0729 0030
          ld c,3                         ; @072B 0e0133c1
          bit 3,d                        ; @072F 5a80
          jr z,AA1                       ; @0731 28038041c2
          ld a,h                         ; @0736 7c00
          sub c                          ; @0738 9100
          ld h,a                         ; @073A 6700
          jr nc,AA1                      ; @073C 30038041c2
          ld h,183                       ; @0741 2601313833c3
                                         ; @0747 0030
AA1       bit 2,d                        ; @0749 52888041c2
          jr z,AA2                       ; @074E 28038043c2
          ld a,h                         ; @0753 7c00
          add a,c                        ; @0755 8100
          ld h,a                         ; @0757 6700
          cp 186                         ; @0759 fe01313836c3
          jr c,AA2                       ; @075F 38038043c2
          ld h,0                         ; @0764 260130c1
                                         ; @0768 0030
AA2       bit 1,d                        ; @076A 4a888043c2
          jr z,AA3                       ; @076F 28038042c2
          ld a,l                         ; @0774 7d00
          sub c                          ; @0776 9100
          ld l,a                         ; @0778 6f00
                                         ; @077A 0030
AA3       bit 0,d                        ; @077C 42888042c2
          jr z,AA4                       ; @0781 28038044c2
          ld a,l                         ; @0786 7d00
          add a,c                        ; @0788 8100
          ld l,a                         ; @078A 6f00
                                         ; @078C 0030
AA4       ld (SIPKA+1),hl                ; @078E 220a804480382b31c6
          jp SIPKA                       ; @0797 c3028038c2
                                         ; @079C 0030
RIGHTL    ld a,l                         ; @079E 7d08803fc2
          inc a                          ; @07A3 3c00
          xor l                          ; @07A5 ad00
          and 31                         ; @07A7 e6013331c2
          xor l                          ; @07AC ad00
          ld l,a                         ; @07AE 6f00
          ret                            ; @07B0 c900
                                         ; @07B2 0030
MATRIX    defb 0,64,96,112               ; @07B4 063f8039302c36342c39362c313132cd
          defb 120,124,122,88            ; @07C4 06373132302c3132342c3132322c3838ce
          defb 12,12,6,6,0,0             ; @07D5 063731322c31322c362c362c302c30cd
          defb 0,0,192,224,240           ; @07E5 0637302c302c3139322c3232342c323430cf
          defb 248,252,254,255           ; @07F7 06373234382c3235322c3235342c323535cf
          defb 250,94,30,15,15           ; @0809 06373235302c39342c33302c31352c3135cf
          defb 7,0,0,0                   ; @081B 0637372c302c302c30c7
                                         ; @0825 0030
FREE32    defs 32                        ; @0827 083f803a3332c4
                                         ; @082E 0030
