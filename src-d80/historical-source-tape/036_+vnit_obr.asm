; decoded from 036_+vnit_obr_t3_l1416_p1_0_p2_1066.bin
; source_length=1066 symbol_count=37 bridge=79ff
; symbols:
;      1: SPRITES   value=64000 defined=1 locked=0
;      2: WIDTH     value=    4 defined=1 locked=0
;      3: HEIGHT    value=   26 defined=1 locked=0
;      4: SPRLEN    value=  208 defined=1 locked=0
;      5: SPREND    value=64832 defined=1 locked=0
;      6: START     value=42370 defined=1 locked=0
;      7: MAIN      value=42386 defined=1 locked=0
;      8: MAIN2     value=42390 defined=1 locked=0
;      9: CLRSCR    value=42795 defined=1 locked=0
;     10: SCREEN    value=42816 defined=1 locked=0
;     11: FILL      value=42400 defined=1 locked=0
;     12: TEXT      value=42631 defined=1 locked=0
;     13: TEXTLEN   value=   22 defined=1 locked=0
;     14: TT        value=42417 defined=1 locked=0
;     15: TT2       value=42431 defined=1 locked=0
;     16: TT3       value=42439 defined=1 locked=0
;     17: SELSPR    value=42454 defined=1 locked=0
;     18: RELPOS    value=42460 defined=1 locked=0
;     19: DRAWSPR   value=42653 defined=1 locked=0
;     20: PAUSE     value=42513 defined=1 locked=0
;     21: MAIN4     value=42521 defined=1 locked=0
;     22: MAIN5     value=42565 defined=1 locked=0
;     23: MAIN6     value=42545 defined=1 locked=0
;     24: MAIN3     value=42561 defined=1 locked=0
;     25: MOVESCR   value=42716 defined=1 locked=0
;     26: YPOS      value=42576 defined=1 locked=0
;     27: ADD1      value=42578 defined=1 locked=0
;     28: MAIN8A    value=42593 defined=1 locked=0
;     29: MAIN8     value=42602 defined=1 locked=0
;     30: DRS1      value=42666 defined=1 locked=0
;     31: DRS2      value=42669 defined=1 locked=0
;     32: DOWNDE    value=42695 defined=1 locked=0
;     33: DOWNDE2   value=42710 defined=1 locked=0
;     34: MOVESCR2  value=42721 defined=1 locked=0
;     35: SPSTORE   value=42811 defined=1 locked=0
;     36: ENDSCR    value=44864 defined=1 locked=0
;     37: CLRSCR2   value=42805 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
;nahrajte "ollispr" na 64000             ; @0008 01373b6e616872616a746520226f6c6c6973707222206e61203634303030dc
                                         ; @0027 0030
SPRITES   equ 64000                      ; @0029 033f80013634303030c7
WIDTH     equ 4                          ; @0033 033f800234c3
HEIGHT    equ 26                         ; @0039 033f80033236c4
SPRLEN    equ WIDTH*HEIGHT*2             ; @0040 033f800480022a80032a32c9
SPREND    equ 4*SPRLEN+SPRITES           ; @004C 033f8005342a80042b8001c9
                                         ; @0058 0030
START     im 1                           ; @005A 56488006c2
          ei                             ; @005F fb00
                                         ; @0061 0030
          ld hl,22528                    ; @0063 21023232353238c5
          ld de,22529                    ; @006B 11023232353239c5
          ld bc,767                      ; @0073 0102373637c3
          ld (hl),7                      ; @0079 360137c1
          ldir                           ; @007D b040
                                         ; @007F 0030
MAIN      ld h,%1101101                  ; @0081 260980072531313031313031ca
          ld l,%1001001                  ; @008E 2e012531303031303031c8
MAIN2     push hl                        ; @0099 e5088008c2
          call CLRSCR                    ; @009E cd028009c2
          ld hl,SCREEN+1376              ; @00A3 2102800a2b31333736c7
          ld bc,1024-256-128             ; @00AD 0102313032342d3235362d313238cc
FILL      ld (hl),255                    ; @00BC 3609800b323535c5
          inc hl                         ; @00C4 2300
          dec bc                         ; @00C6 0b00
          ld a,b                         ; @00C8 7800
          or c                           ; @00CA b100
          jr nz,FILL                     ; @00CC 2003800bc2
                                         ; @00D1 0030
          ld ix,TEXT                     ; @00D3 2122800cc2
          ld de,SCREEN+512+8             ; @00D8 1102800a2b3531322b38c8
          ld c,TEXTLEN                   ; @00E3 0e01800dc2
TT        ld a,(ix+0)                    ; @00E8 7e2c800e30c3
          inc ix                         ; @00EE 2320
          add a,a                        ; @00F0 8700
          ld l,a                         ; @00F2 6f00
          ld h,15                        ; @00F4 26013135c2
          add hl,hl                      ; @00F9 2900
          add hl,hl                      ; @00FB 2900
          push de                        ; @00FD d500
          ld b,16                        ; @00FF 06013136c2
TT2       ld a,(hl)                      ; @0104 7e08800fc2
          ld (de),a                      ; @0109 1200
          inc hl                         ; @010B 2300
          bit 0,b                        ; @010D 4080
          jr nz,TT3                      ; @010F 20038010c2
          dec hl                         ; @0114 2b00
TT3       ld a,e                         ; @0116 7b088010c2
          add a,32                       ; @011B c6013332c2
          ld e,a                         ; @0120 5f00
          ld a,d                         ; @0122 7a00
          adc a,0                        ; @0124 ce0130c1
          ld d,a                         ; @0128 5700
          djnz TT2                       ; @012A 1003800fc2
          pop de                         ; @012F d100
          inc de                         ; @0131 1300
          dec c                          ; @0133 0d00
          jr nz,TT                       ; @0135 2003800ec2
                                         ; @013A 0030
SELSPR    ld de,SPRITES                  ; @013C 110a80118001c4
          ld hl,SCREEN+778               ; @0143 2102800a2b373738c6
RELPOS    ld a,0                         ; @014C 3e09801230c3
          add a,l                        ; @0152 8500
          ld l,a                         ; @0154 6f00
          ld a,h                         ; @0156 7c00
          adc a,0                        ; @0158 ce0130c1
          ld h,a                         ; @015C 6700
                                         ; @015E 0030
          call DRAWSPR                   ; @0160 cd028013c2
          dec hl                         ; @0165 2b00
          dec hl                         ; @0167 2b00
          ld bc,64                       ; @0169 01023634c2
          add hl,bc                      ; @016E 0900
          call DRAWSPR                   ; @0170 cd028013c2
          dec hl                         ; @0175 2b00
          dec hl                         ; @0177 2b00
          ld bc,64                       ; @0179 01023634c2
          add hl,bc                      ; @017E 0900
          call DRAWSPR                   ; @0180 cd028013c2
          dec hl                         ; @0185 2b00
          dec hl                         ; @0187 2b00
          ld bc,64                       ; @0189 01023634c2
          add hl,bc                      ; @018E 0900
          call DRAWSPR                   ; @0190 cd028013c2
          dec hl                         ; @0195 2b00
          dec hl                         ; @0197 2b00
          ld bc,64                       ; @0199 01023634c2
          add hl,bc                      ; @019E 0900
          dec hl                         ; @01A0 2b00
          dec hl                         ; @01A2 2b00
          ld bc,64                       ; @01A4 01023634c2
          add hl,bc                      ; @01A9 0900
          call DRAWSPR                   ; @01AB cd028013c2
                                         ; @01B0 0030
PAUSE     ld a,0                         ; @01B2 3e09801430c3
          inc a                          ; @01B8 3c00
          cp 4                           ; @01BA fe0134c1
          jr c,MAIN4                     ; @01BE 38038015c2
          xor a                          ; @01C3 af00
MAIN4     ld (PAUSE+1),a                 ; @01C5 320a801580142b31c6
          jr nz,MAIN5                    ; @01CE 20038016c2
                                         ; @01D3 0030
          ex de,hl                       ; @01D5 eb00
          ld ix,RELPOS                   ; @01D7 21228012c2
          inc (ix+1)                     ; @01DC 342431c1
          ld a,(ix+1)                    ; @01E0 7e2431c1
          cp 31                          ; @01E4 fe013331c2
          jr c,MAIN6                     ; @01E9 38038017c2
          ld (ix+1),0                    ; @01EE 3625311f30c3
MAIN6     ld de,SPRLEN                   ; @01F4 110a80178004c4
          add hl,de                      ; @01FB 1900
          ld de,SPREND                   ; @01FD 11028005c2
          or a                           ; @0202 b700
          sbc hl,de                      ; @0204 5240
          add hl,de                      ; @0206 1900
          jr nz,MAIN3                    ; @0208 20038018c2
          ld hl,SPRITES                  ; @020D 21028001c2
MAIN3     ld (SELSPR+1),hl               ; @0212 220a801880112b31c6
          ex de,hl                       ; @021B eb00
                                         ; @021D 0030
MAIN5     halt                           ; @021F 76088016c2
          ld a,1                         ; @0224 3e0131c1
          out (254),a                    ; @0228 d301323534c3
          ld de,20480                    ; @022E 11023230343830c5
          call MOVESCR                   ; @0236 cd028019c2
YPOS      ld a,0                         ; @023B 3e09801a30c3
ADD1      add a,1                        ; @0241 c609801b31c3
          and 63                         ; @0247 e6013633c2
          ld (YPOS+1),a                  ; @024C 3202801a2b31c4
          push af                        ; @0253 f500
          jr nz,MAIN8A                   ; @0255 2003801cc2
          ld a,1                         ; @025A 3e0131c1
          ld (ADD1+1),a                  ; @025E 3202801b2b31c4
MAIN8A    cp 63                          ; @0265 fe09801c3633c4
          jr nz,MAIN8                    ; @026C 2003801dc2
          ld a,-1                        ; @0271 3e012d31c2
          ld (ADD1+1),a                  ; @0276 3202801b2b31c4
MAIN8     ld c,0                         ; @027D 0e09801d30c3
          pop af                         ; @0283 f100
          call #22B0                     ; @0285 cd022332324230c5
          ex de,hl                       ; @028D eb00
          call MOVESCR                   ; @028F cd028019c2
          ld a,0                         ; @0294 3e0130c1
          out (254),a                    ; @0298 d301323534c3
          pop hl                         ; @029E e100
          rlc h                          ; @02A0 0480
          rrc l                          ; @02A2 0d80
          xor a                          ; @02A4 af00
          in a,(254)                     ; @02A6 db01323534c3
          cpl                            ; @02AC 2f00
          and 31                         ; @02AE e6013331c2
          jp z,MAIN2                     ; @02B3 ca028008c2
          ret                            ; @02B8 c900
                                         ; @02BA 0030
TEXT      defm ">> PROXIMA "             ; @02BC 073f800c223e3e2050524f58494d412022cf
          defm "software >>"             ; @02CE 073722736f667477617265203e3e22cd
TEXTLEN   equ $-TEXT                     ; @02DE 033f800d242d800cc6
                                         ; @02E7 0030
DRAWSPR   push hl                        ; @02E9 e5088013c2
          push de                        ; @02EE d500
          ex de,hl                       ; @02F0 eb00
          push hl                        ; @02F2 e500
          exx                            ; @02F4 d900
          pop hl                         ; @02F6 e100
          ld bc,SPRLEN/2                 ; @02F8 010280042f32c4
          add hl,bc                      ; @02FF 0900
          exx                            ; @0301 d900
                                         ; @0303 0030
          ld c,HEIGHT                    ; @0305 0e018003c2
DRS1      ld b,WIDTH                     ; @030A 0609801e8002c4
          push de                        ; @0311 d500
DRS2      ld a,(de)                      ; @0313 1a08801fc2
          exx                            ; @0318 d900
          and (hl)                       ; @031A a600
          inc hl                         ; @031C 2300
          exx                            ; @031E d900
          or (hl)                        ; @0320 b600
          ld (de),a                      ; @0322 1200
          inc hl                         ; @0324 2300
          inc de                         ; @0326 1300
          djnz DRS2                      ; @0328 1003801fc2
          pop de                         ; @032D d100
          ld a,e                         ; @032F 7b00
          add a,32                       ; @0331 c6013332c2
          ld e,a                         ; @0336 5f00
          ld a,d                         ; @0338 7a00
          adc a,0                        ; @033A ce0130c1
          ld d,a                         ; @033E 5700
          dec c                          ; @0340 0d00
          jr nz,DRS1                     ; @0342 2003801ec2
          pop de                         ; @0347 d100
          pop hl                         ; @0349 e100
          ret                            ; @034B c900
                                         ; @034D 0030
DOWNDE    inc d                          ; @034F 14088020c2
          ld a,d                         ; @0354 7a00
          and 7                          ; @0356 e60137c1
          ret nz                         ; @035A c000
          ld a,e                         ; @035C 7b00
          add a,32                       ; @035E c6013332c2
          ld e,a                         ; @0363 5f00
          ld a,d                         ; @0365 7a00
          jr c,DOWNDE2                   ; @0367 38038021c2
          sub 8                          ; @036C d60138c1
          ld d,a                         ; @0370 5700
DOWNDE2   cp 88                          ; @0372 fe0980213838c4
          ret c                          ; @0379 d800
          ld d,64                        ; @037B 16013634c2
          ret                            ; @0380 c900
                                         ; @0382 0030
MOVESCR   ld b,64                        ; @0384 060980193634c4
          ld hl,SCREEN                   ; @038B 2102800ac2
MOVESCR2  push de                        ; @0390 d5088022c2
          ld c,255                       ; @0395 0e01323535c3
          ldi                            ; @039B a040
          ldi                            ; @039D a040
          ldi                            ; @039F a040
          ldi                            ; @03A1 a040
          ldi                            ; @03A3 a040
          ldi                            ; @03A5 a040
          ldi                            ; @03A7 a040
          ldi                            ; @03A9 a040
          ldi                            ; @03AB a040
          ldi                            ; @03AD a040
          ldi                            ; @03AF a040
          ldi                            ; @03B1 a040
          ldi                            ; @03B3 a040
          ldi                            ; @03B5 a040
          ldi                            ; @03B7 a040
          ldi                            ; @03B9 a040
          ldi                            ; @03BB a040
          ldi                            ; @03BD a040
          ldi                            ; @03BF a040
          ldi                            ; @03C1 a040
          ldi                            ; @03C3 a040
          ldi                            ; @03C5 a040
          ldi                            ; @03C7 a040
          ldi                            ; @03C9 a040
          ldi                            ; @03CB a040
          ldi                            ; @03CD a040
          ldi                            ; @03CF a040
          ldi                            ; @03D1 a040
          ldi                            ; @03D3 a040
          ldi                            ; @03D5 a040
          ldi                            ; @03D7 a040
          ldi                            ; @03D9 a040
          pop de                         ; @03DB d100
          call DOWNDE                    ; @03DD cd028020c2
          djnz MOVESCR2                  ; @03E2 10038022c2
          ret                            ; @03E7 c900
                                         ; @03E9 0030
CLRSCR    ld (SPSTORE+1),sp              ; @03EB 734a800980232b31c6
          di                             ; @03F4 f300
          ld sp,ENDSCR                   ; @03F6 31028024c2
          ld b,0                         ; @03FB 060130c1
CLRSCR2   push hl                        ; @03FF e5088025c2
          push hl                        ; @0404 e500
          push hl                        ; @0406 e500
          push hl                        ; @0408 e500
          djnz CLRSCR2                   ; @040A 10038025c2
SPSTORE   ld sp,0                        ; @040F 310a802330c3
          ei                             ; @0415 fb00
          ret                            ; @0417 c900
                                         ; @0419 0030
SCREEN    defs 32*64                     ; @041B 083f800a33322a3634c7
ENDSCR                                   ; @0425 00388024c2
