; decoded from 050_-sounds2_t3_l972_p1_0_p2_813.bin
; source_length=813 symbol_count=16 bridge=0cff
; symbols:
;      1: START     value=41759 defined=1 locked=0
;      2: DATA      value=41914 defined=1 locked=0
;      3: DATSTORE  value=41776 defined=1 locked=0
;      4: LOOP4     value=41766 defined=1 locked=0
;      5: RETURN    value=41774 defined=1 locked=0
;      6: TABULKA   value=41856 defined=1 locked=0
;      7: BEEPER    value=41808 defined=1 locked=0
;      8: BORDER1   value=41809 defined=1 locked=0
;      9: BORDER2   value=41812 defined=1 locked=0
;     10: BEEP3     value=41818 defined=1 locked=0
;     11: BEEP4     value=41819 defined=1 locked=0
;     12: BEEP1     value=41845 defined=1 locked=0
;     13: BEEP2     value=41852 defined=1 locked=0
;     14: BEEP5     value=41833 defined=1 locked=0
;     15: LOOP9     value=41838 defined=1 locked=0
;     16: LENGHT    value=  234 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     di                             ; @0008 f3088001c2
          ld hl,DATA                     ; @000D 21028002c2
          ld (DATSTORE+1),hl             ; @0012 220280032b31c4
LOOP4     xor a                          ; @0019 af088004c2
          in a,(254)                     ; @001E db01323534c3
          cpl                            ; @0024 2f00
          and 31                         ; @0026 e6013331c2
          jr z,DATSTORE                  ; @002B 28038003c2
RETURN    ei                             ; @0030 fb088005c2
          ret                            ; @0035 c900
                                         ; @0037 0030
DATSTORE  ld hl,0                        ; @0039 210a800330c3
          ld a,(hl)                      ; @003F 7e00
          or a                           ; @0041 b700
          jr z,RETURN                    ; @0043 28038005c2
                                         ; @0048 0030
          inc hl                         ; @004A 2300
          ld b,(hl)                      ; @004C 4600
          inc hl                         ; @004E 2300
          ld c,(hl)                      ; @0050 4e00
          inc hl                         ; @0052 2300
          ld (DATSTORE+1),hl             ; @0054 220280032b31c4
                                         ; @005B 0030
          ld h,0                         ; @005D 260130c1
          ld l,b                         ; @0061 6800
          ld de,TABULKA                  ; @0063 11028006c2
          push de                        ; @0068 d500
          add hl,de                      ; @006A 1900
          ld d,(hl)                      ; @006C 5600
          ld e,1                         ; @006E 1e0131c1
          ld b,0                         ; @0072 060130c1
          pop hl                         ; @0076 e100
          add hl,bc                      ; @0078 0900
          ld h,(hl)                      ; @007A 6600
          ld l,e                         ; @007C 6b00
                                         ; @007E 0030
BEEPER    ld c,a                         ; @0080 4f088007c2
BORDER1   ld a,7                         ; @0085 3e09800837c3
          ex af,af'                      ; @008B 0800
BORDER2   ld a,0                         ; @008D 3e09800930c3
          ld hx,d                        ; @0093 6220
          ld d,16                        ; @0095 16013136c2
BEEP3     nop                            ; @009A 0008800ac2
BEEP4     ex af,af'                      ; @009F 0808800bc2
          dec e                          ; @00A4 1d00
          out (254),a                    ; @00A6 d301323534c3
          jr nz,BEEP1                    ; @00AC 2003800cc2
          ld e,hx                        ; @00B1 5c20
          xor d                          ; @00B3 aa00
          ex af,af'                      ; @00B5 0800
          dec l                          ; @00B7 2d00
          jr nz,BEEP2                    ; @00B9 2003800dc2
          ret nz                         ; @00BE c000
                                         ; @00C0 0030
BEEP5     out (254),a                    ; @00C2 d309800e323534c5
          ld l,h                         ; @00CA 6c00
          xor d                          ; @00CC aa00
          nop                            ; @00CE 0000
LOOP9     djnz BEEP3                     ; @00D0 100b800f800ac4
          inc c                          ; @00D7 0c00
          jr nz,BEEP4                    ; @00D9 2003800bc2
          jr LOOP4                       ; @00DE 18038004c2
                                         ; @00E3 0030
BEEP1     jr z,BEEP1                     ; @00E5 280b800c800cc4
          ex af,af'                      ; @00EC 0800
          dec l                          ; @00EE 2d00
          jp z,BEEP5                     ; @00F0 ca02800ec2
BEEP2     out (254),a                    ; @00F5 d309800d323534c5
          jr LOOP9                       ; @00FD 1803800fc2
                                         ; @0102 0030
TABULKA   defb 255,0,0,0,240,220         ; @0104 063f80063235352c302c302c302c3234302c323230d3
          defb 215,203,192,180           ; @011A 06373231352c3230332c3139322c313830cf
          defb 171,161,151,144           ; @012C 06373137312c3136312c3135312c313434cf
          defb 136,128,121,114           ; @013E 06373133362c3132382c3132312c313134cf
          defb 108,102,96,91,86          ; @0150 06373130382c3130322c39362c39312c3836d0
          defb 81,76,72,68,64,61         ; @0163 063738312c37362c37322c36382c36342c3631d1
          defb 57,54,51,48,45,43         ; @0177 063735372c35342c35312c34382c34352c3433d1
          defb 40,38,36,34,32,30         ; @018B 063734302c33382c33362c33342c33322c3330d1
          defb 28,27,25,24,23,21         ; @019F 063732382c32372c32352c32342c32332c3231d1
          defb 20,19,18,17,16,15         ; @01B3 063732302c31392c31382c31372c31362c3135d1
          defb 14,13,12,1,0              ; @01C7 063731342c31332c31322c312c30cc
                                         ; @01D6 0030
DATA      defb 206,25,41                 ; @01D8 063f80023230362c32352c3431cb
          defb 231,13,39                 ; @01E6 06373233312c31332c3339c9
          defb 231,13,37                 ; @01F2 06373233312c31332c3337c9
          defb 231,25,37                 ; @01FE 06373233312c32352c3337c9
                                         ; @020A 0030
          defb 231,25,32                 ; @020C 06373233312c32352c3332c9
          defb 231,13,39                 ; @0218 06373233312c31332c3339c9
          defb 231,13,32                 ; @0224 06373233312c31332c3332c9
          defb 231,25,41                 ; @0230 06373233312c32352c3431c9
                                         ; @023C 0030
          defb 231,25,39                 ; @023E 06373233312c32352c3339c9
          defb 206,13,37                 ; @024A 06373230362c31332c3337c9
          defb 231,27,39                 ; @0256 06373233312c32372c3339c9
          defb 231,27,34                 ; @0262 06373233312c32372c3334c9
                                         ; @026E 0030
          defb 231,15,41                 ; @0270 06373233312c31352c3431c9
          defb 231,15,43                 ; @027C 06373233312c31352c3433c9
          defb 231,27,43                 ; @0288 06373233312c32372c3433c9
          defb 231,27,39                 ; @0294 06373233312c32372c3339c9
                                         ; @02A0 0030
          defb 231,15,44                 ; @02A2 06373233312c31352c3434c9
          defb 231,15,46                 ; @02AE 06373233312c31352c3436c9
          defb 231,27,46                 ; @02BA 06373233312c32372c3436c9
          defb 231,27,39                 ; @02C6 06373233312c32372c3339c9
                                         ; @02D2 0030
          defb 231,15,48                 ; @02D4 06373233312c31352c3438c9
          defb 231,15,49                 ; @02E0 06373233312c31352c3439c9
          defb 231,27,49                 ; @02EC 06373233312c32372c3439c9
          defb 231,27,48                 ; @02F8 06373233312c32372c3438c9
                                         ; @0304 0030
          defb 206,15,46                 ; @0306 06373230362c31352c3436c9
          defb 156,36,44                 ; @0312 06373135362c33362c3434c9
          defb 0                         ; @031E 063730c1
                                         ; @0322 0030
LENGHT    equ $-START                    ; @0324 033f8010242d8001c6
