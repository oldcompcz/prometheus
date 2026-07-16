; decoded from 040_-keys1_t3_l1629_p1_0_p2_1353.bin
; source_length=1353 symbol_count=27 bridge=2dff
; symbols:
;      1: START     value=42416 defined=1 locked=0
;      2: TESTER    value=42416 defined=1 locked=0
;      3: LINE      value=42617 defined=1 locked=0
;      4: COLUMN    value=42618 defined=1 locked=0
;      5: CURSOR    value=42619 defined=1 locked=0
;      6: MAINLOOP  value=42434 defined=1 locked=0
;      7: INKEY1    value=42621 defined=1 locked=0
;      8: CONTROLS  value=42498 defined=1 locked=0
;      9: CHAR1     value=42490 defined=1 locked=0
;     10: CHAR2     value=42486 defined=1 locked=0
;     11: CTRL1     value=42534 defined=1 locked=0
;     12: CLEFTRGT  value=42526 defined=1 locked=0
;     13: CTRL2     value=42559 defined=1 locked=0
;     14: CDOWN     value=42557 defined=1 locked=0
;     15: CUPDOWN   value=42583 defined=1 locked=0
;     16: CTRL3     value=42592 defined=1 locked=0
;     17: CTRL4     value=42614 defined=1 locked=0
;     18: CRIGHT    value=42612 defined=1 locked=0
;     19: A0LENGTH  value=  398 defined=1 locked=0
;     20: INKEY     value= 1280 defined=0 locked=0
;     21: INKEY2    value=42637 defined=1 locked=0
;     22: INKEY3    value=42647 defined=1 locked=0
;     23: INKEY4    value=42662 defined=1 locked=0
;     24: SYMBTAB   value=42695 defined=1 locked=0
;     25: INKEY4A   value=42690 defined=1 locked=0
;     26: CAPSTAB   value=42735 defined=1 locked=0
;     27: NORMTAB   value=42774 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START                                    ; @0008 00388001c2
TESTER    ld a,2                         ; @000D 3e09800232c3
          call #1601                     ; @0013 cd022331363031c5
                                         ; @001B 0030
          xor a                          ; @001D af00
          ld (LINE),a                    ; @001F 32028003c2
          ld (COLUMN),a                  ; @0024 32028004c2
          ld hl,22528                    ; @0029 21023232353238c5
          ld (CURSOR),hl                 ; @0031 22028005c2
                                         ; @0036 0030
MAINLOOP  call 8020                      ; @0038 cd0a800638303230c6
          ret nc                         ; @0041 d000
                                         ; @0043 0030
          ld a,22                        ; @0045 3e013232c2
          rst 16                         ; @004A c7063136c2
          ld a,(LINE)                    ; @004F 3a028003c2
          rst 16                         ; @0054 c7063136c2
          ld a,(COLUMN)                  ; @0059 3a028004c2
          rst 16                         ; @005E c7063136c2
                                         ; @0063 0030
          ld hl,(CURSOR)                 ; @0065 2a028005c2
          ld (hl),180                    ; @006A 3601313830c3
                                         ; @0070 0030
          call INKEY1                    ; @0072 cd028007c2
                                         ; @0077 0030
          cp " "                         ; @0079 fe01222022c3
          jr c,CONTROLS                  ; @007F 38038008c2
                                         ; @0084 0030
          rst 16                         ; @0086 c7063136c2
                                         ; @008B 0030
          ld hl,(CURSOR)                 ; @008D 2a028005c2
          inc hl                         ; @0092 2300
          ld a,(COLUMN)                  ; @0094 3a028004c2
          inc a                          ; @0099 3c00
          cp 32                          ; @009B fe013332c2
          jr c,CHAR1                     ; @00A0 38038009c2
          ld a,(LINE)                    ; @00A5 3a028003c2
          inc a                          ; @00AA 3c00
          cp 22                          ; @00AC fe013232c2
          jr c,CHAR2                     ; @00B1 3803800ac2
          xor a                          ; @00B6 af00
          ld hl,22528                    ; @00B8 21023232353238c5
CHAR2     ld (LINE),a                    ; @00C0 320a800a8003c4
          xor a                          ; @00C7 af00
CHAR1     ld (COLUMN),a                  ; @00C9 320a80098004c4
          ld (CURSOR),hl                 ; @00D0 22028005c2
          jr MAINLOOP                    ; @00D5 18038006c2
                                         ; @00DA 0030
CONTROLS  ld b,a                         ; @00DC 47088008c2
          ld a,(23695)                   ; @00E1 3a023233363935c5
          ld hl,(CURSOR)                 ; @00E9 2a028005c2
          ld (hl),a                      ; @00EE 7700
          ld a,b                         ; @00F0 7800
                                         ; @00F2 0030
          cp 8                           ; @00F4 fe0138c1
          jr nz,CTRL1                    ; @00F8 2003800bc2
          dec hl                         ; @00FD 2b00
          ld a,(COLUMN)                  ; @00FF 3a028004c2
          dec a                          ; @0104 3d00
          cp 255                         ; @0106 fe01323535c3
          jr nz,CLEFTRGT                 ; @010C 2003800cc2
          ld bc,32                       ; @0111 01023332c2
          add hl,bc                      ; @0116 0900
          ld a,31                        ; @0118 3e013331c2
CLEFTRGT  ld (COLUMN),a                  ; @011D 320a800c8004c4
          ld (CURSOR),hl                 ; @0124 22028005c2
          jr MAINLOOP                    ; @0129 18038006c2
                                         ; @012E 0030
                                         ; @0130 0030
CTRL1     cp 10                          ; @0132 fe09800b3130c4
          jr nz,CTRL2                    ; @0139 2003800dc2
          ld bc,32                       ; @013E 01023332c2
          add hl,bc                      ; @0143 0900
          ld a,(LINE)                    ; @0145 3a028003c2
          inc a                          ; @014A 3c00
          cp 22                          ; @014C fe013232c2
          jr nz,CDOWN                    ; @0151 2003800ec2
          ld bc,22*32                    ; @0156 010232322a3332c5
          or a                           ; @015E b700
          sbc hl,bc                      ; @0160 4240
          xor a                          ; @0162 af00
CDOWN     jr CUPDOWN                     ; @0164 180b800e800fc4
                                         ; @016B 0030
                                         ; @016D 0030
CTRL2     cp 11                          ; @016F fe09800d3131c4
          jr nz,CTRL3                    ; @0176 20038010c2
          ld bc,32                       ; @017B 01023332c2
          or a                           ; @0180 b700
          sbc hl,bc                      ; @0182 4240
          ld a,(LINE)                    ; @0184 3a028003c2
          dec a                          ; @0189 3d00
          cp 255                         ; @018B fe01323535c3
          jr nz,CUPDOWN                  ; @0191 2003800fc2
          ld bc,22*32                    ; @0196 010232322a3332c5
          add hl,bc                      ; @019E 0900
          ld a,21                        ; @01A0 3e013231c2
CUPDOWN   ld (LINE),a                    ; @01A5 320a800f8003c4
          ld (CURSOR),hl                 ; @01AC 22028005c2
          jp MAINLOOP                    ; @01B1 c3028006c2
                                         ; @01B6 0030
                                         ; @01B8 0030
CTRL3     cp 9                           ; @01BA fe09801039c3
          jr nz,CTRL4                    ; @01C0 20038011c2
          inc hl                         ; @01C5 2300
          ld a,(COLUMN)                  ; @01C7 3a028004c2
          inc a                          ; @01CC 3c00
          cp 32                          ; @01CE fe013332c2
          jr nz,CRIGHT                   ; @01D3 20038012c2
          ld bc,32                       ; @01D8 01023332c2
          or a                           ; @01DD b700
          sbc hl,bc                      ; @01DF 4240
          xor a                          ; @01E1 af00
CRIGHT    jr CLEFTRGT                    ; @01E3 180b8012800cc4
                                         ; @01EA 0030
                                         ; @01EC 0030
CTRL4     jp MAINLOOP                    ; @01EE c30a80118006c4
                                         ; @01F5 0030
                                         ; @01F7 0030
LINE      defb 0                         ; @01F9 063f800330c3
COLUMN    defb 0                         ; @01FF 063f800430c3
CURSOR    defw 0                         ; @0205 093f800530c3
                                         ; @020B 0030
                                         ; @020D 0030
                                         ; @020F 0030
;prvni zpusob testovani klaves           ; @0211 01373b7072766e69207a7075736f6220746573746f76616e69206b6c61766573de
;jednoduchy a pomerne uzitecny           ; @0232 01373b6a65646e6f6475636879206120706f6d65726e6520757a697465636e79de
                                         ; @0253 0030
INKEY1    ei                             ; @0255 fb088007c2
          halt                           ; @025A 7600
          bit 5,(iy+1)                   ; @025C 6e9431c1
          jr z,INKEY1                    ; @0260 28038007c2
          res 5,(iy+1)                   ; @0265 ae9431c1
          ld a,(23560)                   ; @0269 3a023233353630c5
          ret                            ; @0271 c900
                                         ; @0273 0030
                                         ; @0275 0030
                                         ; @0277 0030
;druhy zpusob testovani klaves           ; @0279 01373b6472756879207a7075736f6220746573746f76616e69206b6c61766573de
;je ponekud rychly                       ; @029A 01373b6a6520706f6e656b756420727963686c79d2
                                         ; @02AF 0030
INKEY2    ei                             ; @02B1 fb088015c2
          halt                           ; @02B6 7600
          ld a,(23556)                   ; @02B8 3a023233353536c5
          cp 255                         ; @02C0 fe01323535c3
          jr z,INKEY2                    ; @02C6 28038015c2
          ret                            ; @02CB c900
                                         ; @02CD 0030
                                         ; @02CF 0030
                                         ; @02D1 0030
;treti zpusob testovani klaves           ; @02D3 01373b7472657469207a7075736f6220746573746f76616e69206b6c61766573de
;nepotrebuje povolene preruseni          ; @02F4 01373b6e65706f74726562756a6520706f766f6c656e6520707265727573656e69df
;je jeste rychlejsi nez minuly           ; @0316 01373b6a65206a6573746520727963686c656a7369206e657a206d696e756c79de
                                         ; @0337 0030
INKEY3    call 654                       ; @0339 cd0a8016363534c5
          jr nz,INKEY3                   ; @0341 20038016c2
          call 798                       ; @0346 cd02373938c3
          jr nc,INKEY3                   ; @034C 30038016c2
          dec d                          ; @0351 1500
          ld e,a                         ; @0353 5f00
          jp 819                         ; @0355 c302383139c3
                                         ; @035B 0030
                                         ; @035D 0030
                                         ; @035F 0030
;ctvrty zpusob testovani klaves          ; @0361 01373b637476727479207a7075736f6220746573746f76616e69206b6c61766573df
;umoznuje predefinovat klavesy           ; @0383 01373b756d6f7a6e756a6520707265646566696e6f766174206b6c6176657379de
                                         ; @03A4 0030
INKEY4    call 654                       ; @03A6 cd0a8017363534c5
          jr nz,INKEY4                   ; @03AE 20038017c2
          ld a,e                         ; @03B3 7b00
          cp 255                         ; @03B5 fe01323535c3
          jr z,INKEY4                    ; @03BB 28038017c2
                                         ; @03C0 0030
          ld a,d                         ; @03C2 7a00
                                         ; @03C4 0030
          ld hl,SYMBTAB                  ; @03C6 21028018c2
          cp #18                         ; @03CB fe01233138c3
          jr z,INKEY4A                   ; @03D1 28038019c2
                                         ; @03D6 0030
          ld hl,CAPSTAB                  ; @03D8 2102801ac2
          cp #27                         ; @03DD fe01233237c3
          jr z,INKEY4A                   ; @03E3 28038019c2
                                         ; @03E8 0030
          ld hl,NORMTAB                  ; @03EA 2102801bc2
                                         ; @03EF 0030
INKEY4A   ld d,0                         ; @03F1 1609801930c3
          add hl,de                      ; @03F7 1900
          ld a,(hl)                      ; @03F9 7e00
          ret                            ; @03FB c900
                                         ; @03FD 0030
                                         ; @03FF 0030
SYMBTAB   defm "*^[&%>}/"                ; @0401 073f8018222a5e5b26253e7d2f22cc
          defm ",-]'$<{?"                ; @0410 0737222c2d5d27243c7b3f22ca
          defm ".+{7F}(#"                ; @041D 0737222e2b7f282322c7
          defb 143                       ; @0427 0637313433c3
          defm "\`"                      ; @042D 0737225c6022c4
          defb 0                         ; @0434 063730c1
          defm "=;)@"                    ; @0438 0737223d3b294022c6
          defb 131                       ; @0441 0637313331c3
          defm "|:"                      ; @0447 0737227c3a22c4
          defb " ",13,34                 ; @044E 06372220222c31332c3334c9
          defm "_!"                      ; @045A 0737225f2122c4
          defb 130                       ; @0461 0637313330c3
          defb "~",0                     ; @0467 0637227e222c30c5
                                         ; @046F 0030
CAPSTAB   defm "BHY"                     ; @0471 073f801a2242485922c7
          defb 10,8                      ; @047B 063731302c38c4
          defm "TGV"                     ; @0482 07372254475622c5
          defm "NJU"                     ; @048A 0737224e4a5522c5
          defb 11,5                      ; @0492 063731312c35c4
          defm "RFC"                     ; @0499 07372252464322c5
          defm "MKI"                     ; @04A1 0737224d4b4922c5
          defb 9,4                       ; @04A9 0637392c34c3
          defm "EDX"                     ; @04AF 07372245445822c5
          defb 0                         ; @04B7 063730c1
          defm "LO"                      ; @04BB 0737224c4f22c4
          defb 15,6                      ; @04C2 063731352c36c4
          defm "WSZ"                     ; @04C9 07372257535a22c5
          defb " ",13,"P"                ; @04D1 06372220222c31332c225022ca
          defb 12,7                      ; @04DE 063731322c37c4
          defm "QA"                      ; @04E5 073722514122c4
                                         ; @04EC 0030
NORMTAB   defm "bhy65tgv"                ; @04EE 073f801b22626879363574677622cc
          defm "nju74rfc"                ; @04FD 0737226e6a75373472666322ca
          defm "mki83edx"                ; @050A 0737226d6b69383365647822ca
          defb 0                         ; @0517 063730c1
          defm "lo92wsz"                 ; @051B 0737226c6f393277737a22c9
          defb " ",13                    ; @0527 06372220222c3133c6
          defm "p01qa"                   ; @0530 073722703031716122c7
          defb 0                         ; @053A 063730c1
                                         ; @053E 0030
A0LENGTH  equ $-START                    ; @0540 033f8013242d8001c6
