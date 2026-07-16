; decoded from 068_-znaky4_t3_l406_p1_0_p2_307.bin
; source_length=307 symbol_count=10 bridge=55ff
; symbols:
;      1: START     value=41193 defined=1 locked=0
;      2: LOOP      value=41201 defined=1 locked=0
;      3: PPOS      value=41221 defined=1 locked=0
;      4: DOWNHL    value=41278 defined=1 locked=0
;      5: DOWNHL2   value=41293 defined=1 locked=0
;      6: ADRSET    value=41265 defined=1 locked=0
;      7: CHAR1     value=41212 defined=1 locked=0
;      8: CHAR1A    value=41227 defined=1 locked=0
;      9: CHAR1B    value=41259 defined=1 locked=0
;     10: CHAR1D    value=41254 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld bc,12*256+5                 ; @0008 010a800131322a3235362b35ca
          call ADRSET                    ; @0015 cd028006c2
                                         ; @001A 0030
          ld a,32                        ; @001C 3e013332c2
LOOP      push af                        ; @0021 f5088002c2
          call CHAR1                     ; @0026 cd028007c2
          pop af                         ; @002B f100
          inc a                          ; @002D 3c00
          cp 128                         ; @002F fe01313238c3
          jr c,LOOP                      ; @0035 38038002c2
          ret                            ; @003A c900
                                         ; @003C 0030
                                         ; @003E 0030
CHAR1     exx                            ; @0040 d9088007c2
          push af                        ; @0045 f500
                                         ; @0047 0030
          add a,a                        ; @0049 8700
          ld l,a                         ; @004B 6f00
          ld h,15                        ; @004D 26013135c2
          add hl,hl                      ; @0052 2900
          add hl,hl                      ; @0054 2900
          ex de,hl                       ; @0056 eb00
PPOS      ld hl,16384                    ; @0058 210a80033136333834c7
          push hl                        ; @0062 e500
                                         ; @0064 0030
          ld b,8                         ; @0066 060138c1
CHAR1A    ld a,(de)                      ; @006A 1a088008c2
          ld (hl),a                      ; @006F 7700
          call DOWNHL                    ; @0071 cd028004c2
          ld a,(de)                      ; @0076 1a00
          ld (hl),a                      ; @0078 7700
          call DOWNHL                    ; @007A cd028004c2
          inc de                         ; @007F 1300
          djnz CHAR1A                    ; @0081 10038008c2
                                         ; @0086 0030
          pop hl                         ; @0088 e100
          inc l                          ; @008A 2c00
          ld a,l                         ; @008C 7d00
          and 31                         ; @008E e6013331c2
          jr nz,CHAR1B                   ; @0093 20038009c2
          dec l                          ; @0098 2d00
          ld a,l                         ; @009A 7d00
          and %11100000                  ; @009C e601253131313030303030c9
          ld l,a                         ; @00A8 6f00
          ld b,16                        ; @00AA 06013136c2
CHAR1D    call DOWNHL                    ; @00AF cd0a800a8004c4
          djnz CHAR1D                    ; @00B6 1003800ac2
CHAR1B    ld (PPOS+1),hl                 ; @00BB 220a800980032b31c6
                                         ; @00C4 0030
          pop af                         ; @00C6 f100
          exx                            ; @00C8 d900
          ret                            ; @00CA c900
                                         ; @00CC 0030
                                         ; @00CE 0030
                                         ; @00D0 0030
ADRSET    ld a,c                         ; @00D2 79088006c2
          add a,a                        ; @00D7 8700
          add a,a                        ; @00D9 8700
          add a,a                        ; @00DB 8700
          ld c,a                         ; @00DD 4f00
          ld a,b                         ; @00DF 7800
          call #22B0                     ; @00E1 cd022332324230c5
          ld (PPOS+1),hl                 ; @00E9 220280032b31c4
          ret                            ; @00F0 c900
                                         ; @00F2 0030
                                         ; @00F4 0030
                                         ; @00F6 0030
DOWNHL    inc h                          ; @00F8 24088004c2
          ld a,h                         ; @00FD 7c00
          and 7                          ; @00FF e60137c1
          ret nz                         ; @0103 c000
                                         ; @0105 0030
          ld a,l                         ; @0107 7d00
          add a,32                       ; @0109 c6013332c2
          ld l,a                         ; @010E 6f00
          ld a,h                         ; @0110 7c00
          jr c,DOWNHL2                   ; @0112 38038005c2
                                         ; @0117 0030
          sub 8                          ; @0119 d60138c1
          ld h,a                         ; @011D 6700
                                         ; @011F 0030
DOWNHL2   cp 88                          ; @0121 fe0980053838c4
          ret c                          ; @0128 d800
          ld h,64                        ; @012A 26013634c2
          ret                            ; @012F c900
                                         ; @0131 0030
