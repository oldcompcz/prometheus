; decoded from 028_+scrolls_t3_l573_p1_255_p2_411.bin
; source_length=411 symbol_count=17 bridge=90ff
; symbols:
;      1: VYSKA     value=  192 defined=1 locked=0
;      2: SIRKA     value=   32 defined=1 locked=0
;      3: SCR_UP    value=41583 defined=1 locked=0
;      4: SCU1      value=41588 defined=1 locked=0
;      5: DOWNHL    value=41692 defined=1 locked=0
;      6: DOWNHL2   value=41707 defined=1 locked=0
;      7: TEST      value=41575 defined=1 locked=0
;      8: SCR_DOWN  value=41605 defined=1 locked=0
;      9: SCD1      value=41610 defined=1 locked=0
;     10: UPHL      value=41671 defined=1 locked=0
;     11: UPHL2     value=41686 defined=1 locked=0
;     12: SCR_RGHT  value=41627 defined=1 locked=0
;     13: SCR1      value=41632 defined=1 locked=0
;     14: SCR2      value=41636 defined=1 locked=0
;     15: SCR_LEFT  value=41649 defined=1 locked=0
;     16: SCL1      value=41654 defined=1 locked=0
;     17: SCL2      value=41658 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
          im 1                           ; @0008 5640
          ld hl,0                        ; @000A 210230c1
          ld de,16384                    ; @000E 11023136333834c5
          ld bc,6144                     ; @0016 010236313434c4
          ldir                           ; @001D b040
          ld b,192                       ; @001F 0601313932c3
TEST      push bc                        ; @0025 c5088007c2
          call SCR_RGHT                  ; @002A cd02800cc2
          pop bc                         ; @002F c100
          djnz TEST                      ; @0031 10038007c2
          ret                            ; @0036 c900
                                         ; @0038 0030
                                         ; @003A 0030
VYSKA     equ 192                        ; @003C 033f8001313932c5
SIRKA     equ 32                         ; @0044 033f80023332c4
                                         ; @004B 0030
SCR_UP    ld hl,16384                    ; @004D 210a80033136333834c7
          ld b,VYSKA-1                   ; @0057 060180012d31c4
SCU1      push hl                        ; @005E e5088004c2
          call DOWNHL                    ; @0063 cd028005c2
          pop de                         ; @0068 d100
          ld a,b                         ; @006A 7800
          ld bc,SIRKA                    ; @006C 01028002c2
          push hl                        ; @0071 e500
          ldir                           ; @0073 b040
          pop hl                         ; @0075 e100
          ld b,a                         ; @0077 4700
          djnz SCU1                      ; @0079 10038004c2
          ret                            ; @007E c900
                                         ; @0080 0030
SCR_DOWN  ld hl,22528-32                 ; @0082 210a800832323532382d3332ca
          ld b,VYSKA-1                   ; @008F 060180012d31c4
SCD1      push hl                        ; @0096 e5088009c2
          call UPHL                      ; @009B cd02800ac2
          pop de                         ; @00A0 d100
          ld a,b                         ; @00A2 7800
          ld bc,SIRKA                    ; @00A4 01028002c2
          push hl                        ; @00A9 e500
          ldir                           ; @00AB b040
          pop hl                         ; @00AD e100
          ld b,a                         ; @00AF 4700
          djnz SCD1                      ; @00B1 10038009c2
          ret                            ; @00B6 c900
                                         ; @00B8 0030
SCR_RGHT  ld hl,16384                    ; @00BA 210a800c3136333834c7
          ld c,192                       ; @00C4 0e01313932c3
SCR1      push hl                        ; @00CA e508800dc2
          ld b,SIRKA                     ; @00CF 06018002c2
          or a                           ; @00D4 b700
SCR2      rr (hl)                        ; @00D6 1e88800ec2
          inc l                          ; @00DB 2c00
          djnz SCR2                      ; @00DD 1003800ec2
          pop hl                         ; @00E2 e100
          call DOWNHL                    ; @00E4 cd028005c2
          dec c                          ; @00E9 0d00
          jr nz,SCR1                     ; @00EB 2003800dc2
          ret                            ; @00F0 c900
                                         ; @00F2 0030
SCR_LEFT  ld hl,16384+31                 ; @00F4 210a800f31363338342b3331ca
          ld c,192                       ; @0101 0e01313932c3
SCL1      push hl                        ; @0107 e5088010c2
          ld b,SIRKA                     ; @010C 06018002c2
          or a                           ; @0111 b700
SCL2      rl (hl)                        ; @0113 16888011c2
          dec l                          ; @0118 2d00
          djnz SCL2                      ; @011A 10038011c2
          pop hl                         ; @011F e100
          call DOWNHL                    ; @0121 cd028005c2
          dec c                          ; @0126 0d00
          jr nz,SCL1                     ; @0128 20038010c2
          ret                            ; @012D c900
                                         ; @012F 0030
UPHL      ld a,h                         ; @0131 7c08800ac2
          dec h                          ; @0136 2500
          and 7                          ; @0138 e60137c1
          ret nz                         ; @013C c000
          ld a,l                         ; @013E 7d00
          sub 32                         ; @0140 d6013332c2
          ld l,a                         ; @0145 6f00
          ld a,h                         ; @0147 7c00
          jr c,UPHL2                     ; @0149 3803800bc2
          add a,8                        ; @014E c60138c1
          ld h,a                         ; @0152 6700
UPHL2     cp 64                          ; @0154 fe09800b3634c4
          ret nc                         ; @015B d000
          ld h,87                        ; @015D 26013837c2
          ret                            ; @0162 c900
                                         ; @0164 0030
                                         ; @0166 0030
DOWNHL    inc h                          ; @0168 24088005c2
          ld a,h                         ; @016D 7c00
          and 7                          ; @016F e60137c1
          ret nz                         ; @0173 c000
          ld a,l                         ; @0175 7d00
          add a,32                       ; @0177 c6013332c2
          ld l,a                         ; @017C 6f00
          ld a,h                         ; @017E 7c00
          jr c,DOWNHL2                   ; @0180 38038006c2
          sub 8                          ; @0185 d60138c1
          ld h,a                         ; @0189 6700
DOWNHL2   cp 88                          ; @018B fe0980063838c4
          ret c                          ; @0192 d800
          ld h,64                        ; @0194 26013634c2
          ret                            ; @0199 c900
