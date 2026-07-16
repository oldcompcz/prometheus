; decoded from 032_+sprite2_t3_l825_p1_255_p2_615.bin
; source_length=615 symbol_count=22 bridge=03ff
; symbols:
;      1: SPRITES   value=64000 defined=1 locked=0
;      2: WIDTH     value=    2 defined=1 locked=0
;      3: HEIGHT    value=   16 defined=1 locked=0
;      4: SPRLEN    value=   64 defined=1 locked=0
;      5: START     value=41812 defined=1 locked=0
;      6: LOOP1     value=41835 defined=1 locked=0
;      7: LOOP2     value=41840 defined=1 locked=0
;      8: XPOS      value=41842 defined=1 locked=0
;      9: DRAWSPR   value=41893 defined=1 locked=0
;     10: WAIT      value=41853 defined=1 locked=0
;     11: REDRAWSP  value=41992 defined=1 locked=0
;     12: SPACE     value=42038 defined=1 locked=0
;     13: DRS1      value=41911 defined=1 locked=0
;     14: DRS2      value=41948 defined=1 locked=0
;     15: DOWNDE    value=42017 defined=1 locked=0
;     16: RDRS1     value=42000 defined=1 locked=0
;     17: RDRS2     value=42003 defined=1 locked=0
;     18: DOWNDE2   value=42032 defined=1 locked=0
;     19: LOOP3     value=41885 defined=1 locked=0
;     20: SHIFT     value=41928 defined=1 locked=0
;     21: SCRADR    value=41950 defined=1 locked=0
;     22: DRS3      value=41934 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
;nahrajte "birdspr" na 64000             ; @0008 01373b6e616872616a746520226269726473707222206e61203634303030dc
                                         ; @0027 0030
SPRITES   equ 64000                      ; @0029 033f80013634303030c7
WIDTH     equ 2                          ; @0033 033f800232c3
HEIGHT    equ 16                         ; @0039 033f80033136c4
SPRLEN    equ WIDTH*HEIGHT*2             ; @0040 033f800480022a80032a32c9
                                         ; @004C 0030
START     im 1                           ; @004E 56488005c2
          ei                             ; @0053 fb00
          ld hl,16384                    ; @0055 21023136333834c5
          ld de,16385                    ; @005D 11023136333835c5
          ld bc,6144                     ; @0065 010236313434c4
          ld (hl),0                      ; @006C 360130c1
          ldir                           ; @0070 b040
          ld bc,767                      ; @0072 0102373637c3
          ld (hl),7                      ; @0078 360137c1
          ldir                           ; @007C b040
                                         ; @007E 0030
LOOP1     ld de,SPRITES                  ; @0080 110a80068001c4
          ld b,4                         ; @0087 060134c1
LOOP2     push de                        ; @008B d5088007c2
          push bc                        ; @0090 c500
XPOS      ld bc,80*256+8                 ; @0092 010a800838302a3235362b38ca
          call DRAWSPR                   ; @009F cd028009c2
          xor a                          ; @00A4 af00
          out (254),a                    ; @00A6 d301323534c3
          ld b,7                         ; @00AC 060137c1
WAIT      halt                           ; @00B0 7608800ac2
          djnz WAIT                      ; @00B5 1003800ac2
          ld a,4                         ; @00BA 3e0134c1
          out (254),a                    ; @00BE d301323534c3
          call REDRAWSP                  ; @00C4 cd02800bc2
          ld hl,XPOS+1                   ; @00C9 210280082b31c4
          ld a,(hl)                      ; @00D0 7e00
          add a,1                        ; @00D2 c60131c1
          ld (hl),a                      ; @00D6 7700
          pop bc                         ; @00D8 c100
          pop de                         ; @00DA d100
          ld hl,SPRLEN                   ; @00DC 21028004c2
          add hl,de                      ; @00E1 1900
          ex de,hl                       ; @00E3 eb00
          ld a,b                         ; @00E5 7800
          cp 2                           ; @00E7 fe0132c1
          jr nz,LOOP3                    ; @00EB 20038013c2
          ld de,SPRITES+SPRLEN           ; @00F0 110280012b8004c5
LOOP3     djnz LOOP2                     ; @00F8 100b80138007c4
                                         ; @00FF 0030
          call 8020                      ; @0101 cd0238303230c4
          jr c,LOOP1                     ; @0108 38038006c2
          ret                            ; @010D c900
                                         ; @010F 0030
DRAWSPR   ld a,b                         ; @0111 78088009c2
          call #22B0                     ; @0116 cd022332324230c5
          ld (REDRAWSP+1),hl             ; @011E 2202800b2b31c4
          ex de,hl                       ; @0125 eb00
          ld (SHIFT+1),a                 ; @0127 320280142b31c4
          exx                            ; @012E d900
          ld de,SPACE                    ; @0130 1102800cc2
          exx                            ; @0135 d900
                                         ; @0137 0030
          ld b,HEIGHT                    ; @0139 06018003c2
DRS1      push bc                        ; @013E c508800dc2
          ld (SCRADR+1),de               ; @0143 534280152b31c4
          ld a,(hl)                      ; @014A 7e00
          inc hl                         ; @014C 2300
          ld d,(hl)                      ; @014E 5600
          inc hl                         ; @0150 2300
          ld c,(hl)                      ; @0152 4e00
          inc hl                         ; @0154 2300
          ld e,(hl)                      ; @0156 5e00
          inc hl                         ; @0158 2300
          push hl                        ; @015A e500
          ld hl,256*255                  ; @015C 21023235362a323535c7
SHIFT     ld b,0                         ; @0166 0609801430c3
          inc b                          ; @016C 0400
          dec b                          ; @016E 0500
          jr z,DRS2                      ; @0170 2803800ec2
DRS3      scf                            ; @0175 37088016c2
          rra                            ; @017A 1f00
          rr d                           ; @017C 1a80
          rr h                           ; @017E 1c80
          srl c                          ; @0180 3980
          rr e                           ; @0182 1b80
          rr l                           ; @0184 1d80
          djnz DRS3                      ; @0186 10038016c2
DRS2      ld b,a                         ; @018B 4708800ec2
          push hl                        ; @0190 e500
SCRADR    ld hl,0                        ; @0192 210a801530c3
          ld a,(hl)                      ; @0198 7e00
          exx                            ; @019A d900
          ld (de),a                      ; @019C 1200
          inc de                         ; @019E 1300
          exx                            ; @01A0 d900
          and b                          ; @01A2 a000
          or c                           ; @01A4 b100
          ld (hl),a                      ; @01A6 7700
          inc hl                         ; @01A8 2300
          ld a,(hl)                      ; @01AA 7e00
          exx                            ; @01AC d900
          ld (de),a                      ; @01AE 1200
          inc de                         ; @01B0 1300
          exx                            ; @01B2 d900
          and d                          ; @01B4 a200
          or e                           ; @01B6 b300
          ld (hl),a                      ; @01B8 7700
          inc hl                         ; @01BA 2300
          pop de                         ; @01BC d100
          ld a,(hl)                      ; @01BE 7e00
          exx                            ; @01C0 d900
          ld (de),a                      ; @01C2 1200
          inc de                         ; @01C4 1300
          exx                            ; @01C6 d900
          and d                          ; @01C8 a200
          or e                           ; @01CA b300
          ld (hl),a                      ; @01CC 7700
          ld de,(SCRADR+1)               ; @01CE 5b4280152b31c4
          call DOWNDE                    ; @01D5 cd02800fc2
          pop hl                         ; @01DA e100
          pop bc                         ; @01DC c100
          djnz DRS1                      ; @01DE 1003800dc2
          ret                            ; @01E3 c900
                                         ; @01E5 0030
REDRAWSP  ld de,0                        ; @01E7 110a800b30c3
          ld hl,SPACE                    ; @01ED 2102800cc2
          ld c,HEIGHT                    ; @01F2 0e018003c2
RDRS1     ld b,WIDTH+1                   ; @01F7 0609801080022b31c6
          push de                        ; @0200 d500
RDRS2     ld a,(hl)                      ; @0202 7e088011c2
          ld (de),a                      ; @0207 1200
          inc hl                         ; @0209 2300
          inc e                          ; @020B 1c00
          djnz RDRS2                     ; @020D 10038011c2
          pop de                         ; @0212 d100
          call DOWNDE                    ; @0214 cd02800fc2
          dec c                          ; @0219 0d00
          jr nz,RDRS1                    ; @021B 20038010c2
          ret                            ; @0220 c900
                                         ; @0222 0030
DOWNDE    inc d                          ; @0224 1408800fc2
          ld a,d                         ; @0229 7a00
          and 7                          ; @022B e60137c1
          ret nz                         ; @022F c000
          ld a,e                         ; @0231 7b00
          add a,32                       ; @0233 c6013332c2
          ld e,a                         ; @0238 5f00
          ld a,d                         ; @023A 7a00
          jr c,DOWNDE2                   ; @023C 38038012c2
          sub 8                          ; @0241 d60138c1
          ld d,a                         ; @0245 5700
DOWNDE2   cp 88                          ; @0247 fe0980123838c4
          ret c                          ; @024E d800
          ld d,64                        ; @0250 16013634c2
          ret                            ; @0255 c900
                                         ; @0257 0030
SPACE     defs WIDTH+1*HEIGHT*2          ; @0259 083f800c80022b312a80032a32cb
