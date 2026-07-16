; decoded from 012_+multitask_t3_l1537_p1_0_p2_1159.bin
; source_length=1159 symbol_count=39 bridge=a1ff
; symbols:
;      1: START     value=42524 defined=1 locked=0
;      2: LOOP2     value=42659 defined=1 locked=0
;      3: INTRPT    value=42695 defined=1 locked=0
;      4: RETSP     value=42652 defined=1 locked=0
;      5: NUMPROC   value=42639 defined=1 locked=0
;      6: STACK1    value=43137 defined=1 locked=0
;      7: RUTINA1   value=42800 defined=1 locked=0
;      8: INSPROC   value=42730 defined=1 locked=0
;      9: STACK2    value=43237 defined=1 locked=0
;     10: RUTINA2   value=42834 defined=1 locked=0
;     11: RUTINA3   value=42852 defined=1 locked=0
;     12: STACK3    value=43337 defined=1 locked=0
;     13: STACK4    value=43437 defined=1 locked=0
;     14: RUTINA4   value=42865 defined=1 locked=0
;     15: STACK5    value=43537 defined=1 locked=0
;     16: RUTINA5   value=42873 defined=1 locked=0
;     17: TEXT1     value=42942 defined=1 locked=0
;     18: TEXT2     value=42987 defined=1 locked=0
;     19: STACK6    value=43637 defined=1 locked=0
;     20: PROCESS   value=42636 defined=1 locked=0
;     21: LOOP      value=42644 defined=1 locked=0
;     22: PROCTAB   value=42780 defined=1 locked=0
;     23: ADR       value=42723 defined=1 locked=0
;     24: ADR2      value=42772 defined=1 locked=0
;     25: SPSTOR    value=42776 defined=1 locked=0
;     26: RUT1A     value=42805 defined=1 locked=0
;     27: RUT1B     value=42814 defined=1 locked=0
;     28: RUT2A     value=42840 defined=1 locked=0
;     29: RUT3A     value=42859 defined=1 locked=0
;     30: RUT5G     value=42874 defined=1 locked=0
;     31: RUT5F     value=42875 defined=1 locked=0
;     32: RUT5A     value=42877 defined=1 locked=0
;     33: RUT5B     value=42886 defined=1 locked=0
;     34: RUT5I     value=42894 defined=1 locked=0
;     35: RUT5E     value=42904 defined=1 locked=0
;     36: RUT5D     value=42907 defined=1 locked=0
;     37: RUT5C     value=42911 defined=1 locked=0
;     38: RUT5H     value=42928 defined=1 locked=0
;     39: STACKS    value=43037 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     di                             ; @0008 f3088001c2
          ld (RETSP+1),sp                ; @000D 734280042b31c4
          im 2                           ; @0014 5e40
          xor a                          ; @0016 af00
          ld (NUMPROC+1),a               ; @0018 320280052b31c4
          ld a,#FD                       ; @001F 3e01234644c3
          ld i,a                         ; @0025 4740
          ld hl,#FD00                    ; @0027 21022346443030c5
          ld de,#FD01                    ; @002F 11022346443031c5
          ld bc,256                      ; @0037 0102323536c3
          ld (hl),#FE                    ; @003D 3601234645c3
          ldir                           ; @0043 b040
          ld hl,#FEFE                    ; @0045 21022346454645c5
          ld (hl),195                    ; @004D 3601313935c3
          inc hl                         ; @0053 2300
          ld (hl),INTRPT?256             ; @0055 360180033f323536c6
          inc hl                         ; @005E 2300
          ld (hl),INTRPT/256             ; @0060 360180032f323536c6
                                         ; @0069 0030
          ld hl,STACK1                   ; @006B 21028006c2
          ld de,RUTINA1                  ; @0070 11028007c2
          call INSPROC                   ; @0075 cd028008c2
                                         ; @007A 0030
          ld hl,STACK2                   ; @007C 21028009c2
          ld de,RUTINA2                  ; @0081 1102800ac2
          call INSPROC                   ; @0086 cd028008c2
                                         ; @008B 0030
          ld hl,STACK3                   ; @008D 2102800cc2
          ld de,RUTINA3                  ; @0092 1102800bc2
          call INSPROC                   ; @0097 cd028008c2
                                         ; @009C 0030
          ld hl,STACK4                   ; @009E 2102800dc2
          ld de,RUTINA4                  ; @00A3 1102800ec2
          call INSPROC                   ; @00A8 cd028008c2
                                         ; @00AD 0030
          ld hl,TEXT1                    ; @00AF 21028011c2
          ld de,20480+255                ; @00B4 110232303438302b323535c9
          exx                            ; @00C0 d900
          ld hl,STACK5                   ; @00C2 2102800fc2
          ld de,RUTINA5                  ; @00C7 11028010c2
          call INSPROC                   ; @00CC cd028008c2
                                         ; @00D1 0030
          ld hl,TEXT2                    ; @00D3 21028012c2
          ld de,20480+31                 ; @00D8 110232303438302b3331c8
          exx                            ; @00E3 d900
          ld hl,STACK6                   ; @00E5 21028013c2
          ld de,RUTINA5                  ; @00EA 11028010c2
          call INSPROC                   ; @00EF cd028008c2
                                         ; @00F4 0030
          ld a,-1                        ; @00F6 3e012d31c2
          ld (PROCESS+1),a               ; @00FB 320280142b31c4
                                         ; @0102 0030
PROCESS   ld a,0                         ; @0104 3e09801430c3
          inc a                          ; @010A 3c00
NUMPROC   cp 0                           ; @010C fe09800530c3
          jr c,LOOP                      ; @0112 38038015c2
          xor a                          ; @0117 af00
LOOP      ld (PROCESS+1),a               ; @0119 320a801580142b31c6
          call 8020                      ; @0122 cd0238303230c4
          jr c,LOOP2                     ; @0129 38038002c2
RETSP     ld sp,0                        ; @012E 310a800430c3
          im 1                           ; @0134 5640
          ei                             ; @0136 fb00
          ret                            ; @0138 c900
                                         ; @013A 0030
LOOP2     ld a,(PROCESS+1)               ; @013C 3a0a800280142b31c6
          add a,a                        ; @0145 8700
          ld c,a                         ; @0147 4f00
          ld b,0                         ; @0149 060130c1
          ld hl,PROCTAB                  ; @014D 21028016c2
          add hl,bc                      ; @0152 0900
          ld a,(hl)                      ; @0154 7e00
          inc hl                         ; @0156 2300
          ld h,(hl)                      ; @0158 6600
          ld l,a                         ; @015A 6f00
          ld a,0                         ; @015C 3e0130c1
          out (254),a                    ; @0160 d301323534c3
          ld sp,hl                       ; @0166 f900
          pop iy                         ; @0168 e110
          pop ix                         ; @016A e120
          pop hl                         ; @016C e100
          pop de                         ; @016E d100
          pop bc                         ; @0170 c100
          pop af                         ; @0172 f100
          ex af,af'                      ; @0174 0800
          exx                            ; @0176 d900
          pop hl                         ; @0178 e100
          pop de                         ; @017A d100
          pop bc                         ; @017C c100
          pop af                         ; @017E f100
          ei                             ; @0180 fb00
          ret                            ; @0182 c900
                                         ; @0184 0030
INTRPT    push af                        ; @0186 f5088003c2
          push bc                        ; @018B c500
          push de                        ; @018D d500
          push hl                        ; @018F e500
          exx                            ; @0191 d900
          ex af,af'                      ; @0193 0800
          push af                        ; @0195 f500
          push bc                        ; @0197 c500
          push de                        ; @0199 d500
          push hl                        ; @019B e500
          push ix                        ; @019D e520
          push iy                        ; @019F e510
          ld a,(PROCESS+1)               ; @01A1 3a0280142b31c4
          add a,a                        ; @01A8 8700
          ld c,a                         ; @01AA 4f00
          ld b,0                         ; @01AC 060130c1
          ld hl,PROCTAB                  ; @01B0 21028016c2
          add hl,bc                      ; @01B5 0900
          ld (ADR+2),hl                  ; @01B7 220280172b32c4
ADR       ld (0),sp                      ; @01BE 734a801730c3
          jp PROCESS                     ; @01C4 c3028014c2
                                         ; @01C9 0030
INSPROC   push hl                        ; @01CB e5088008c2
          ld hl,NUMPROC+1                ; @01D0 210280052b31c4
          ld a,(hl)                      ; @01D7 7e00
          inc (hl)                       ; @01D9 3400
          add a,a                        ; @01DB 8700
          ld c,a                         ; @01DD 4f00
          ld b,0                         ; @01DF 060130c1
          ld hl,PROCTAB                  ; @01E3 21028016c2
          add hl,bc                      ; @01E8 0900
          ld (ADR2+2),hl                 ; @01EA 220280182b32c4
          pop hl                         ; @01F1 e100
          ld (SPSTOR+1),sp               ; @01F3 734280192b31c4
          ld sp,hl                       ; @01FA f900
          push de                        ; @01FC d500
          push af                        ; @01FE f500
          push bc                        ; @0200 c500
          push de                        ; @0202 d500
          push hl                        ; @0204 e500
          exx                            ; @0206 d900
          ex af,af'                      ; @0208 0800
          push af                        ; @020A f500
          push bc                        ; @020C c500
          push de                        ; @020E d500
          push hl                        ; @0210 e500
          push ix                        ; @0212 e520
          ld iy,23610                    ; @0214 21123233363130c5
          push iy                        ; @021C e510
ADR2      ld (0),sp                      ; @021E 734a801830c3
SPSTOR    ld sp,0                        ; @0224 310a801930c3
          ret                            ; @022A c900
                                         ; @022C 0030
                                         ; @022E 0030
PROCTAB   defs 20                        ; @0230 083f80163230c4
                                         ; @0237 0030
                                         ; @0239 0030
RUTINA1   ld a,2                         ; @023B 3e09800732c3
          call #1601                     ; @0241 cd022331363031c5
RUT1A     ld a,22                        ; @0249 3e09801a3232c4
          rst 16                         ; @0250 c7063136c2
          xor a                          ; @0255 af00
          rst 16                         ; @0257 c7063136c2
          xor a                          ; @025C af00
          rst 16                         ; @025E c7063136c2
          ld b,0                         ; @0263 060130c1
RUT1B     push bc                        ; @0267 c508801bc2
          ld a,r                         ; @026C 5f40
          res 7,a                        ; @026E bf80
          ld (23695),a                   ; @0270 32023233363935c5
          ld a,r                         ; @0278 5f40
          and 63                         ; @027A e6013633c2
          add a,32                       ; @027F c6013332c2
          rst 16                         ; @0284 c7063136c2
          pop bc                         ; @0289 c100
          djnz RUT1B                     ; @028B 1003801bc2
          jr RUT1A                       ; @0290 1803801ac2
                                         ; @0295 0030
                                         ; @0297 0030
RUTINA2   ld hl,18432                    ; @0299 210a800a3138343332c7
          ld bc,2048                     ; @02A3 010232303438c4
RUT2A     ld a,r                         ; @02AA 5f48801cc2
          ld (hl),a                      ; @02AF 7700
          inc hl                         ; @02B1 2300
          dec bc                         ; @02B3 0b00
          ld a,b                         ; @02B5 7800
          or c                           ; @02B7 b100
          jr nz,RUT2A                    ; @02B9 2003801cc2
          halt                           ; @02BE 7600
          jr RUTINA2                     ; @02C0 1803800ac2
                                         ; @02C5 0030
                                         ; @02C7 0030
RUTINA3   ld a,r                         ; @02C9 5f48800bc2
          ld hl,22528+512+32             ; @02CE 210232323532382b3531322b3332cc
          ld b,192                       ; @02DD 0601313932c3
RUT3A     ld (hl),a                      ; @02E3 7708801dc2
          inc l                          ; @02E8 2c00
          djnz RUT3A                     ; @02EA 1003801dc2
          jr RUTINA3                     ; @02EF 1803800bc2
                                         ; @02F4 0030
                                         ; @02F6 0030
RUTINA4   ld a,r                         ; @02F8 5f48800ec2
          and 24                         ; @02FD e6013234c2
          out (254),a                    ; @0302 d301323534c3
          jr RUTINA4                     ; @0308 1803800ec2
                                         ; @030D 0030
                                         ; @030F 0030
RUTINA5   exx                            ; @0311 d9088010c2
RUT5G     push hl                        ; @0316 e508801ec2
RUT5F     push hl                        ; @031B e508801fc2
          push de                        ; @0320 d500
RUT5A     ld a,(hl)                      ; @0322 7e088020c2
          add a,a                        ; @0327 8700
          ld l,a                         ; @0329 6f00
          ld h,15                        ; @032B 26013135c2
          add hl,hl                      ; @0330 2900
          add hl,hl                      ; @0332 2900
          ld b,8                         ; @0334 060138c1
RUT5B     ld a,(hl)                      ; @0338 7e088021c2
          ld (de),a                      ; @033D 1200
          inc hl                         ; @033F 2300
          inc d                          ; @0341 1400
          djnz RUT5B                     ; @0343 10038021c2
          pop hl                         ; @0348 e100
          push hl                        ; @034A e500
RUT5I     xor a                          ; @034C af088022c2
          in a,(254)                     ; @0351 db01323534c3
          cpl                            ; @0357 2f00
          and 31                         ; @0359 e6013331c2
          jr nz,RUT5I                    ; @035E 20038022c2
          ld e,8                         ; @0363 1e0138c1
RUT5E     ld c,8                         ; @0367 0e09802338c3
          push hl                        ; @036D e500
RUT5D     push hl                        ; @036F e5088024c2
          ld b,32                        ; @0374 06013332c2
          xor a                          ; @0379 af00
RUT5C     rl (hl)                        ; @037B 16888025c2
          dec l                          ; @0380 2d00
          djnz RUT5C                     ; @0382 10038025c2
          pop hl                         ; @0387 e100
          inc h                          ; @0389 2400
          dec c                          ; @038B 0d00
          jr nz,RUT5D                    ; @038D 20038024c2
          pop hl                         ; @0392 e100
          ld a,e                         ; @0394 7b00
          and 3                          ; @0396 e60133c1
          jr nz,RUT5H                    ; @039A 20038026c2
          halt                           ; @039F 7600
RUT5H     dec e                          ; @03A1 1d088026c2
          jr nz,RUT5E                    ; @03A6 20038023c2
          halt                           ; @03AB 7600
          pop de                         ; @03AD d100
          pop hl                         ; @03AF e100
          bit 7,(hl)                     ; @03B1 7e80
          inc hl                         ; @03B3 2300
          jr z,RUT5F                     ; @03B5 2803801fc2
          pop hl                         ; @03BA e100
          jr RUT5G                       ; @03BC 1803801ec2
                                         ; @03C1 0030
TEXT1     defm "Toto je text "           ; @03C3 073f801122546f746f206a6520746578742022d1
          defm "1, tiskne ho "           ; @03D7 073722312c207469736b6e6520686f2022cf
          defm "rutina "                 ; @03E9 073722727574696e612022c9
          defm 'RUTINA5     '            ; @03F5 073727525554494e4135202020202027ce
                                         ; @0406 0030
TEXT2     defm "Toto je text "           ; @0408 073f801222546f746f206a6520746578742022d1
          defm "2, tiskne ho "           ; @041C 073722322c207469736b6e6520686f2022cf
          defm "taky rutina "            ; @042E 07372274616b7920727574696e612022ce
          defm 'RUTINA5     '            ; @043F 073727525554494e4135202020202027ce
                                         ; @0450 0030
STACKS    defs 100                       ; @0452 083f8027313030c5
STACK1    defs 100                       ; @045A 083f8006313030c5
STACK2    defs 100                       ; @0462 083f8009313030c5
STACK3    defs 100                       ; @046A 083f800c313030c5
STACK4    defs 100                       ; @0472 083f800d313030c5
STACK5    defs 100                       ; @047A 083f800f313030c5
STACK6                                   ; @0482 00388013c2
