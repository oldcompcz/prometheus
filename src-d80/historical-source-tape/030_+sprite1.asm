; decoded from 030_+sprite1_t3_l661_p1_255_p2_487.bin
; source_length=487 symbol_count=18 bridge=4cff
; symbols:
;      1: SPRITES   value=64000 defined=1 locked=0
;      2: WIDTH     value=    4 defined=1 locked=0
;      3: HEIGHT    value=   26 defined=1 locked=0
;      4: SPRLEN    value=  208 defined=1 locked=0
;      5: START     value=41648 defined=1 locked=0
;      6: LOOP1     value=41671 defined=1 locked=0
;      7: LOOP2     value=41676 defined=1 locked=0
;      8: XPOS      value=41678 defined=1 locked=0
;      9: DRAWSPR   value=41721 defined=1 locked=0
;     10: WAIT      value=41689 defined=1 locked=0
;     11: REDRAWSP  value=41766 defined=1 locked=0
;     12: SPACE     value=41812 defined=1 locked=0
;     13: DRS1      value=41742 defined=1 locked=0
;     14: DRS2      value=41745 defined=1 locked=0
;     15: DOWNDE    value=41791 defined=1 locked=0
;     16: RDRS1     value=41774 defined=1 locked=0
;     17: RDRS2     value=41777 defined=1 locked=0
;     18: DOWNDE2   value=41806 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
;nahrajte "ollispr" na 64000             ; @0008 01373b6e616872616a746520226f6c6c6973707222206e61203634303030dc
SPRITES   equ 64000                      ; @0027 033f80013634303030c7
WIDTH     equ 4                          ; @0031 033f800234c3
HEIGHT    equ 26                         ; @0037 033f80033236c4
SPRLEN    equ WIDTH*HEIGHT*2             ; @003E 033f800480022a80032a32c9
                                         ; @004A 0030
START     im 1                           ; @004C 56488005c2
          ei                             ; @0051 fb00
          ld hl,16384                    ; @0053 21023136333834c5
          ld de,16385                    ; @005B 11023136333835c5
          ld bc,6144                     ; @0063 010236313434c4
          ld (hl),%1010101               ; @006A 36012531303130313031c8
          ldir                           ; @0075 b040
          ld bc,767                      ; @0077 0102373637c3
          ld (hl),7                      ; @007D 360137c1
          ldir                           ; @0081 b040
                                         ; @0083 0030
LOOP1     ld de,SPRITES                  ; @0085 110a80068001c4
          ld b,4                         ; @008C 060134c1
LOOP2     push de                        ; @0090 d5088007c2
          push bc                        ; @0095 c500
XPOS      ld bc,140*256+8                ; @0097 010a80083134302a3235362b38cb
          call DRAWSPR                   ; @00A5 cd028009c2
          xor a                          ; @00AA af00
          out (254),a                    ; @00AC d301323534c3
          ld b,9                         ; @00B2 060139c1
WAIT      halt                           ; @00B6 7608800ac2
          djnz WAIT                      ; @00BB 1003800ac2
          ld a,4                         ; @00C0 3e0134c1
          out (254),a                    ; @00C4 d301323534c3
          call REDRAWSP                  ; @00CA cd02800bc2
          ld hl,XPOS+1                   ; @00CF 210280082b31c4
          ld a,(hl)                      ; @00D6 7e00
          add a,8                        ; @00D8 c60138c1
          ld (hl),a                      ; @00DC 7700
          pop bc                         ; @00DE c100
          pop de                         ; @00E0 d100
          ld hl,SPRLEN                   ; @00E2 21028004c2
          add hl,de                      ; @00E7 1900
          ex de,hl                       ; @00E9 eb00
          djnz LOOP2                     ; @00EB 10038007c2
                                         ; @00F0 0030
          call 8020                      ; @00F2 cd0238303230c4
          jr c,LOOP1                     ; @00F9 38038006c2
          ret                            ; @00FE c900
                                         ; @0100 0030
DRAWSPR   ld a,b                         ; @0102 78088009c2
          call #22B0                     ; @0107 cd022332324230c5
          ld (REDRAWSP+1),hl             ; @010F 2202800b2b31c4
                                         ; @0116 0030
          ex de,hl                       ; @0118 eb00
          push hl                        ; @011A e500
          exx                            ; @011C d900
          pop hl                         ; @011E e100
          ld bc,SPRLEN/2                 ; @0120 010280042f32c4
          add hl,bc                      ; @0127 0900
          ld de,SPACE                    ; @0129 1102800cc2
          exx                            ; @012E d900
                                         ; @0130 0030
          ld c,HEIGHT                    ; @0132 0e018003c2
DRS1      ld b,WIDTH                     ; @0137 0609800d8002c4
          push de                        ; @013E d500
DRS2      ld a,(de)                      ; @0140 1a08800ec2
          exx                            ; @0145 d900
          ld (de),a                      ; @0147 1200
          inc de                         ; @0149 1300
          and (hl)                       ; @014B a600
          inc hl                         ; @014D 2300
          exx                            ; @014F d900
          or (hl)                        ; @0151 b600
          ld (de),a                      ; @0153 1200
          inc hl                         ; @0155 2300
          inc e                          ; @0157 1c00
          djnz DRS2                      ; @0159 1003800ec2
          pop de                         ; @015E d100
          call DOWNDE                    ; @0160 cd02800fc2
          dec c                          ; @0165 0d00
          jr nz,DRS1                     ; @0167 2003800dc2
          ret                            ; @016C c900
                                         ; @016E 0030
REDRAWSP  ld de,0                        ; @0170 110a800b30c3
          ld hl,SPACE                    ; @0176 2102800cc2
          ld c,HEIGHT                    ; @017B 0e018003c2
RDRS1     ld b,WIDTH                     ; @0180 060980108002c4
          push de                        ; @0187 d500
RDRS2     ld a,(hl)                      ; @0189 7e088011c2
          ld (de),a                      ; @018E 1200
          inc hl                         ; @0190 2300
          inc e                          ; @0192 1c00
          djnz RDRS2                     ; @0194 10038011c2
          pop de                         ; @0199 d100
          call DOWNDE                    ; @019B cd02800fc2
          dec c                          ; @01A0 0d00
          jr nz,RDRS1                    ; @01A2 20038010c2
          ret                            ; @01A7 c900
                                         ; @01A9 0030
DOWNDE    inc d                          ; @01AB 1408800fc2
          ld a,d                         ; @01B0 7a00
          and 7                          ; @01B2 e60137c1
          ret nz                         ; @01B6 c000
          ld a,e                         ; @01B8 7b00
          add a,32                       ; @01BA c6013332c2
          ld e,a                         ; @01BF 5f00
          ld a,d                         ; @01C1 7a00
          jr c,DOWNDE2                   ; @01C3 38038012c2
          sub 8                          ; @01C8 d60138c1
          ld d,a                         ; @01CC 5700
DOWNDE2   cp 88                          ; @01CE fe0980123838c4
          ret c                          ; @01D5 d800
          ld d,64                        ; @01D7 16013634c2
          ret                            ; @01DC c900
                                         ; @01DE 0030
SPACE     defs SPRLEN                    ; @01E0 083f800c8004c4
