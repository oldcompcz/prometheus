; decoded from 070_-znaky5_t3_l477_p1_0_p2_378.bin
; source_length=378 symbol_count=10 bridge=62ff
; symbols:
;      1: START     value=41264 defined=1 locked=0
;      2: LOOP      value=41272 defined=1 locked=0
;      3: PPOS      value=41292 defined=1 locked=0
;      4: DOWNHL    value=41377 defined=1 locked=0
;      5: DOWNHL2   value=41392 defined=1 locked=0
;      6: ADRSET    value=41360 defined=1 locked=0
;      7: CHAR1     value=41283 defined=1 locked=0
;      8: CHAR1A    value=41298 defined=1 locked=0
;      9: CHAR1B    value=41354 defined=1 locked=0
;     10: CHAR1D    value=41349 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld bc,1*256+5                  ; @0008 010a8001312a3235362b35c9
          call ADRSET                    ; @0014 cd028006c2
                                         ; @0019 0030
          ld a,32                        ; @001B 3e013332c2
LOOP      push af                        ; @0020 f5088002c2
          call CHAR1                     ; @0025 cd028007c2
          pop af                         ; @002A f100
          inc a                          ; @002C 3c00
          cp 128                         ; @002E fe01313238c3
          jr c,LOOP                      ; @0034 38038002c2
          ret                            ; @0039 c900
                                         ; @003B 0030
                                         ; @003D 0030
                                         ; @003F 0030
CHAR1     exx                            ; @0041 d9088007c2
          push af                        ; @0046 f500
                                         ; @0048 0030
          add a,a                        ; @004A 8700
          ld l,a                         ; @004C 6f00
          ld h,15                        ; @004E 26013135c2
          add hl,hl                      ; @0053 2900
          add hl,hl                      ; @0055 2900
          ex de,hl                       ; @0057 eb00
PPOS      ld hl,16384                    ; @0059 210a80033136333834c7
          push hl                        ; @0063 e500
                                         ; @0065 0030
          ld b,8                         ; @0067 060138c1
CHAR1A    ld a,(de)                      ; @006B 1a088008c2
          ld c,a                         ; @0070 4f00
          rrca                           ; @0072 0f00
          or c                           ; @0074 b100
          ld (hl),a                      ; @0076 7700
          call DOWNHL                    ; @0078 cd028004c2
          ld a,(de)                      ; @007D 1a00
          ld (hl),a                      ; @007F 7700
          call DOWNHL                    ; @0081 cd028004c2
          inc de                         ; @0086 1300
          djnz CHAR1A                    ; @0088 10038008c2
                                         ; @008D 0030
          pop hl                         ; @008F e100
          push hl                        ; @0091 e500
                                         ; @0093 0030
          ld a,h                         ; @0095 7c00
          sub 64                         ; @0097 d6013634c2
          rrca                           ; @009C 0f00
          rrca                           ; @009E 0f00
          rrca                           ; @00A0 0f00
          and 3                          ; @00A2 e60133c1
          add a,88                       ; @00A6 c6013838c2
          ld h,a                         ; @00AB 6700
                                         ; @00AD 0030
          ld (hl),3+64                   ; @00AF 3601332b3634c4
                                         ; @00B6 0030
          ld bc,32                       ; @00B8 01023332c2
          add hl,bc                      ; @00BD 0900
                                         ; @00BF 0030
          ld (hl),6                      ; @00C1 360136c1
                                         ; @00C5 0030
          pop hl                         ; @00C7 e100
          inc l                          ; @00C9 2c00
          ld a,l                         ; @00CB 7d00
          and 31                         ; @00CD e6013331c2
          jr nz,CHAR1B                   ; @00D2 20038009c2
          dec l                          ; @00D7 2d00
          ld a,l                         ; @00D9 7d00
          and %11100000                  ; @00DB e601253131313030303030c9
          ld l,a                         ; @00E7 6f00
          ld b,16                        ; @00E9 06013136c2
CHAR1D    call DOWNHL                    ; @00EE cd0a800a8004c4
          djnz CHAR1D                    ; @00F5 1003800ac2
CHAR1B    ld (PPOS+1),hl                 ; @00FA 220a800980032b31c6
                                         ; @0103 0030
          pop af                         ; @0105 f100
          exx                            ; @0107 d900
          ret                            ; @0109 c900
                                         ; @010B 0030
                                         ; @010D 0030
                                         ; @010F 0030
ADRSET    ld a,c                         ; @0111 79088006c2
          add a,a                        ; @0116 8700
          add a,a                        ; @0118 8700
          add a,a                        ; @011A 8700
          ld c,a                         ; @011C 4f00
          ld a,b                         ; @011E 7800
          add a,a                        ; @0120 8700
          add a,a                        ; @0122 8700
          add a,a                        ; @0124 8700
          add a,a                        ; @0126 8700
          call #22B0                     ; @0128 cd022332324230c5
          ld (PPOS+1),hl                 ; @0130 220280032b31c4
          ret                            ; @0137 c900
                                         ; @0139 0030
                                         ; @013B 0030
                                         ; @013D 0030
DOWNHL    inc h                          ; @013F 24088004c2
          ld a,h                         ; @0144 7c00
          and 7                          ; @0146 e60137c1
          ret nz                         ; @014A c000
                                         ; @014C 0030
          ld a,l                         ; @014E 7d00
          add a,32                       ; @0150 c6013332c2
          ld l,a                         ; @0155 6f00
          ld a,h                         ; @0157 7c00
          jr c,DOWNHL2                   ; @0159 38038005c2
                                         ; @015E 0030
          sub 8                          ; @0160 d60138c1
          ld h,a                         ; @0164 6700
                                         ; @0166 0030
DOWNHL2   cp 88                          ; @0168 fe0980053838c4
          ret c                          ; @016F d800
          ld h,64                        ; @0171 26013634c2
          ret                            ; @0176 c900
                                         ; @0178 0030
