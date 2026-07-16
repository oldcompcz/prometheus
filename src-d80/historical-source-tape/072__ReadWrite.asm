; decoded from 072__ReadWrite_t3_l454_p1_0_p2_331.bin
; source_length=331 symbol_count=13 bridge=a8ff
; symbols:
;      1: READALL   value=41249 defined=1 locked=0
;      2: DIR       value=58000 defined=1 locked=0
;      3: BREAD     value= 8866 defined=1 locked=0
;      4: BWRITE    value= 8854 defined=1 locked=0
;      5: WRITALL   value=41241 defined=1 locked=0
;      6: SETPRMS   value=41291 defined=1 locked=0
;      7: RWALL     value=41255 defined=1 locked=0
;      8: RWAL1     value=41279 defined=1 locked=0
;      9: RWTAB     value=41353 defined=1 locked=0
;     10: RWAL0     value=41266 defined=1 locked=0
;     11: DIVIDE    value=41331 defined=1 locked=0
;     12: RA0       value=41324 defined=1 locked=0
;     13: DV0       value=41345 defined=1 locked=0

                                         ; @0000 0030
DIR       equ 58000                      ; @0002 033f80023538303030c7
BREAD     equ 8866                       ; @000C 033f800338383636c6
BWRITE    equ 8854                       ; @0015 033f800438383534c6
                                         ; @001E 0030
                                         ; @0020 0030
WRITALL   call SETPRMS                   ; @0022 cd0a80058006c4
          ld hl,BWRITE                   ; @0029 21028004c2
          jr RWALL                       ; @002E 18038007c2
                                         ; @0033 0030
                                         ; @0035 0030
READALL   call SETPRMS                   ; @0037 cd0a80018006c4
          ld hl,BREAD                    ; @003E 21028003c2
RWALL     ld (RWAL1+1),hl                ; @0043 220a800780082b31c6
          ld hl,RWTAB                    ; @004C 21028009c2
          ld de,DIR                      ; @0051 11028002c2
          ld b,14                        ; @0056 06013134c2
RWAL0     push bc                        ; @005B c508800ac2
          push hl                        ; @0060 e500
          push de                        ; @0062 d500
          ld l,(hl)                      ; @0064 6e00
          ld h,0                         ; @0066 260130c1
          call DIVIDE                    ; @006A cd02800bc2
          pop hl                         ; @006F e100
          ld de,257                      ; @0071 1102323537c3
RWAL1     call 0                         ; @0077 cd0a800830c3
          ex de,hl                       ; @007D eb00
          pop hl                         ; @007F e100
          inc hl                         ; @0081 2300
          pop bc                         ; @0083 c100
          djnz RWAL0                     ; @0085 1003800ac2
          jp 9526                        ; @008A c30239353236c4
                                         ; @0091 0030
                                         ; @0093 0030
SETPRMS   ld hl,14336                    ; @0095 210a80063134333336c7
          ld de,257                      ; @009F 1102323537c3
          ld bc,0                        ; @00A5 010230c1
          call BREAD                     ; @00A9 cd028003c2
          call 8609                      ; @00AE cd0238363039c4
          ld a,(14336+177)               ; @00B5 3a0231343333362b313737c9
          ld hl,(14336+178)              ; @00C1 2a0231343333362b313738c9
          set 4,(ix+1)                   ; @00CD e6a431c1
          and 16                         ; @00D1 e6013136c2
          jr nz,RA0                      ; @00D6 2003800cc2
          res 4,(ix+1)                   ; @00DB a6a431c1
RA0       ld (ix+2),l                    ; @00DF 752c800c32c3
          ld (ix+3),h                    ; @00E5 742433c1
          ret                            ; @00E9 c900
                                         ; @00EB 0030
                                         ; @00ED 0030
DIVIDE    ld a,(15979)                   ; @00EF 3a0a800b3135393739c7
          call 8620                      ; @00F9 cd0238363230c4
          ld e,(ix+3)                    ; @0100 5e2433c1
          ld d,0                         ; @0104 160130c1
          ld b,-1                        ; @0108 06012d31c2
          or a                           ; @010D b700
DV0       inc b                          ; @010F 0408800dc2
          sbc hl,de                      ; @0114 5240
          jr nc,DV0                      ; @0116 3003800dc2
          add hl,de                      ; @011B 1900
          ld c,l                         ; @011D 4d00
          ret                            ; @011F c900
                                         ; @0121 0030
                                         ; @0123 0030
RWTAB     defb 0,1,2,3,4,5,6,8           ; @0125 063f8009302c312c322c332c342c352c362c38d1
          defb 10,12,7,9,11,13           ; @0139 063731302c31322c372c392c31312c3133cf
