; decoded from 066_-znaky3_t3_l373_p1_0_p2_279.bin
; source_length=279 symbol_count=10 bridge=b6ff
; symbols:
;      1: START     value= 1280 defined=0 locked=0
;      2: LOOP      value= 1024 defined=0 locked=0
;      3: ZOUT      value= 1024 defined=0 locked=0
;      4: PPOS      value= 1024 defined=0 locked=0
;      5: ZOUT2     value= 1280 defined=0 locked=0
;      6: DOWNHL    value= 1536 defined=0 locked=0
;      7: ZOUT3     value= 1280 defined=0 locked=0
;      8: ZOUT4     value= 1280 defined=0 locked=0
;      9: ZOUT5     value= 1280 defined=0 locked=0
;     10: DOWNHL2   value= 1792 defined=0 locked=0

                                         ; @0000 0030
                                         ; @0002 0030
          ent $                          ; @0004 023724c1
                                         ; @0008 0030
START     ld a,32                        ; @000A 3e0980013332c4
LOOP      push af                        ; @0011 f5088002c2
          call ZOUT                      ; @0016 cd028003c2
          pop af                         ; @001B f100
          inc a                          ; @001D 3c00
          cp 128                         ; @001F fe01313238c3
          jr c,LOOP                      ; @0025 38038002c2
          ret                            ; @002A c900
                                         ; @002C 0030
                                         ; @002E 0030
ZOUT      exx                            ; @0030 d9088003c2
          push af                        ; @0035 f500
                                         ; @0037 0030
          add a,a                        ; @0039 8700
          ld l,a                         ; @003B 6f00
          ld h,15                        ; @003D 26013135c2
          add hl,hl                      ; @0042 2900
          add hl,hl                      ; @0044 2900
PPOS      ld de,16384                    ; @0046 110a80043136333834c7
          push de                        ; @0050 d500
                                         ; @0052 0030
          ex de,hl                       ; @0054 eb00
          ld (hl),0                      ; @0056 360130c1
          ld bc,2116                     ; @005A 010232313136c4
ZOUT2     call DOWNHL                    ; @0061 cd0a80058006c4
          ld a,(de)                      ; @0068 1a00
          ld hx,a                        ; @006A 6720
          ld (hl),a                      ; @006C 7700
          inc de                         ; @006E 1300
          rl c                           ; @0070 1180
          jr nc,ZOUT3                    ; @0072 30038007c2
          call DOWNHL                    ; @0077 cd028006c2
          ld a,(de)                      ; @007C 1a00
          or hx                          ; @007E b420
          ld (hl),a                      ; @0080 7700
ZOUT3     djnz ZOUT2                     ; @0082 100b80078005c4
          call DOWNHL                    ; @0089 cd028006c2
          ld (hl),0                      ; @008E 360130c1
          pop hl                         ; @0092 e100
          inc l                          ; @0094 2c00
          ld a,l                         ; @0096 7d00
          and 31                         ; @0098 e6013331c2
          jr nz,ZOUT4                    ; @009D 20038008c2
          dec l                          ; @00A2 2d00
          ld a,l                         ; @00A4 7d00
          and %11100000                  ; @00A6 e601253131313030303030c9
          ld l,a                         ; @00B2 6f00
          ld b,12                        ; @00B4 06013132c2
ZOUT5     call DOWNHL                    ; @00B9 cd0a80098006c4
          djnz ZOUT5                     ; @00C0 10038009c2
ZOUT4     ld (PPOS+1),hl                 ; @00C5 220a800880042b31c6
                                         ; @00CE 0030
          pop af                         ; @00D0 f100
          exx                            ; @00D2 d900
          ret                            ; @00D4 c900
                                         ; @00D6 0030
                                         ; @00D8 0030
                                         ; @00DA 0030
DOWNHL    inc h                          ; @00DC 24088006c2
          ld a,h                         ; @00E1 7c00
          and 7                          ; @00E3 e60137c1
          ret nz                         ; @00E7 c000
                                         ; @00E9 0030
          ld a,l                         ; @00EB 7d00
          add a,32                       ; @00ED c6013332c2
          ld l,a                         ; @00F2 6f00
          ld a,h                         ; @00F4 7c00
          jr c,DOWNHL2                   ; @00F6 3803800ac2
                                         ; @00FB 0030
          sub 8                          ; @00FD d60138c1
          ld h,a                         ; @0101 6700
                                         ; @0103 0030
DOWNHL2   cp 88                          ; @0105 fe09800a3838c4
          ret c                          ; @010C d800
          ld h,64                        ; @010E 26013634c2
          ret                            ; @0113 c900
                                         ; @0115 0030
