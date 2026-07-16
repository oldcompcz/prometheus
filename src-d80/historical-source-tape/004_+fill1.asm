; decoded from 004_+fill1_t3_l905_p1_0_p2_659.bin
; source_length=659 symbol_count=24 bridge=37ff
; symbols:
;      1: START     value=41892 defined=1 locked=0
;      2: SPSTOR    value=41986 defined=1 locked=0
;      3: PREPIS    value=42081 defined=1 locked=0
;      4: MAKETAB   value=42029 defined=1 locked=0
;      5: FILL      value=41909 defined=1 locked=0
;      6: FILL2     value=41914 defined=1 locked=0
;      7: FILLEND   value=41982 defined=1 locked=0
;      8: POINT     value=41990 defined=1 locked=0
;      9: PLOT3     value=42010 defined=1 locked=0
;     10: NOUP      value=41942 defined=1 locked=0
;     11: NOUP2     value=41941 defined=1 locked=0
;     12: NODOWN    value=41955 defined=1 locked=0
;     13: NODOWN2   value=41954 defined=1 locked=0
;     14: NOLEFT    value=41967 defined=1 locked=0
;     15: NOLEFT2   value=41966 defined=1 locked=0
;     16: NORIGHT2  value=41979 defined=1 locked=0
;     17: SCRNADRS  value=42240 defined=1 locked=0
;     18: TABLE     value=42752 defined=1 locked=0
;     19: MAKETAB2  value=42037 defined=1 locked=0
;     20: DOWNHL    value=42105 defined=1 locked=0
;     21: MAKETAB3  value=42054 defined=1 locked=0
;     22: PREPIS2   value=42095 defined=1 locked=0
;     23: LAST      value=42126 defined=1 locked=0
;     24: DOWNHL2   value=42120 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
START     ld (SPSTOR+1),sp               ; @0008 734a800180022b31c6
          di                             ; @0011 f300
          call PREPIS                    ; @0013 cd028003c2
          ld sp,0                        ; @0018 310230c1
          call MAKETAB                   ; @001C cd028004c2
                                         ; @0021 0030
          ld bc,30*256+128               ; @0023 010233302a3235362b313238ca
                                         ; @0030 0030
FILL      ld hl,-1                       ; @0032 210a80052d31c4
          push hl                        ; @0039 e500
          push bc                        ; @003B c500
                                         ; @003D 0030
FILL2     pop bc                         ; @003F c1088006c2
          ld a,b                         ; @0044 7800
          and c                          ; @0046 a100
          inc a                          ; @0048 3c00
          jr z,FILLEND                   ; @004A 28038007c2
          call POINT                     ; @004F cd028008c2
          jr nz,FILL2                    ; @0054 20038006c2
          push bc                        ; @0059 c500
          call PLOT3                     ; @005B cd028009c2
          pop bc                         ; @0060 c100
          ld a,b                         ; @0062 7800
          or a                           ; @0064 b700
          jr z,NOUP                      ; @0066 2803800ac2
          dec b                          ; @006B 0500
          call POINT                     ; @006D cd028008c2
          jr nz,NOUP2                    ; @0072 2003800bc2
          push bc                        ; @0077 c500
NOUP2     inc b                          ; @0079 0408800bc2
                                         ; @007E 0030
NOUP      ld a,b                         ; @0080 7808800ac2
          cp 64                          ; @0085 fe013634c2
          jr z,NODOWN                    ; @008A 2803800cc2
          inc b                          ; @008F 0400
          call POINT                     ; @0091 cd028008c2
          jr nz,NODOWN2                  ; @0096 2003800dc2
          push bc                        ; @009B c500
NODOWN2   dec b                          ; @009D 0508800dc2
                                         ; @00A2 0030
NODOWN    ld a,c                         ; @00A4 7908800cc2
          or a                           ; @00A9 b700
          jr z,NOLEFT                    ; @00AB 2803800ec2
          dec c                          ; @00B0 0d00
          call POINT                     ; @00B2 cd028008c2
          jr nz,NOLEFT2                  ; @00B7 2003800fc2
          push bc                        ; @00BC c500
NOLEFT2   inc c                          ; @00BE 0c08800fc2
                                         ; @00C3 0030
NOLEFT    ld a,c                         ; @00C5 7908800ec2
          cp 255                         ; @00CA fe01323535c3
          jr z,FILL2                     ; @00D0 28038006c2
          inc c                          ; @00D5 0c00
          call POINT                     ; @00D7 cd028008c2
          jr nz,NORIGHT2                 ; @00DC 20038010c2
          push bc                        ; @00E1 c500
NORIGHT2  dec c                          ; @00E3 0d088010c2
          jr FILL2                       ; @00E8 18038006c2
                                         ; @00ED 0030
FILLEND   ld a,4                         ; @00EF 3e09800734c3
          out (254),a                    ; @00F5 d301323534c3
SPSTOR    ld sp,0                        ; @00FB 310a800230c3
          ret                            ; @0101 c900
                                         ; @0103 0030
POINT     push bc                        ; @0105 c5088008c2
          ld l,b                         ; @010A 6800
          ld h,SCRNADRS/256              ; @010C 260180112f323536c6
          ld a,c                         ; @0115 7900
          rrca                           ; @0117 0f00
          rrca                           ; @0119 0f00
          rrca                           ; @011B 0f00
          and 31                         ; @011D e6013331c2
          add a,(hl)                     ; @0122 8600
          inc h                          ; @0124 2400
          ld h,(hl)                      ; @0126 6600
          ld l,a                         ; @0128 6f00
          ld b,TABLE/256                 ; @012A 060180122f323536c6
          ld a,(bc)                      ; @0133 0a00
          and (hl)                       ; @0135 a600
          pop bc                         ; @0137 c100
          ret                            ; @0139 c900
                                         ; @013B 0030
PLOT3     ld l,b                         ; @013D 68088009c2
          ld h,SCRNADRS/256              ; @0142 260180112f323536c6
          ld a,c                         ; @014B 7900
          rrca                           ; @014D 0f00
          rrca                           ; @014F 0f00
          rrca                           ; @0151 0f00
          and 31                         ; @0153 e6013331c2
          add a,(hl)                     ; @0158 8600
          inc h                          ; @015A 2400
          ld h,(hl)                      ; @015C 6600
          ld l,a                         ; @015E 6f00
          ld b,TABLE/256                 ; @0160 060180122f323536c6
          ld a,(bc)                      ; @0169 0a00
          xor (hl)                       ; @016B ae00
          ld (hl),a                      ; @016D 7700
          ret                            ; @016F c900
                                         ; @0171 0030
MAKETAB   ld b,192                       ; @0173 06098004313932c5
          ld de,16384                    ; @017B 11023136333834c5
          ld hl,SCRNADRS                 ; @0183 21028011c2
MAKETAB2  ld (hl),e                      ; @0188 73088013c2
          inc h                          ; @018D 2400
          ld (hl),d                      ; @018F 7200
          dec h                          ; @0191 2500
          inc hl                         ; @0193 2300
          ex de,hl                       ; @0195 eb00
          call DOWNHL                    ; @0197 cd028014c2
          ex de,hl                       ; @019C eb00
          djnz MAKETAB2                  ; @019E 10038013c2
          ld b,32                        ; @01A3 06013332c2
          ld hl,TABLE                    ; @01A8 21028012c2
MAKETAB3  ld (hl),128                    ; @01AD 36098015313238c5
          inc l                          ; @01B5 2c00
          ld (hl),64                     ; @01B7 36013634c2
          inc l                          ; @01BC 2c00
          ld (hl),32                     ; @01BE 36013332c2
          inc l                          ; @01C3 2c00
          ld (hl),16                     ; @01C5 36013136c2
          inc l                          ; @01CA 2c00
          ld (hl),8                      ; @01CC 360138c1
          inc l                          ; @01D0 2c00
          ld (hl),4                      ; @01D2 360134c1
          inc l                          ; @01D6 2c00
          ld (hl),2                      ; @01D8 360132c1
          inc l                          ; @01DC 2c00
          ld (hl),1                      ; @01DE 360131c1
          inc l                          ; @01E2 2c00
          djnz MAKETAB3                  ; @01E4 10038015c2
          ret                            ; @01E9 c900
                                         ; @01EB 0030
PREPIS    ld a,2                         ; @01ED 3e09800332c3
          call #1601                     ; @01F3 cd022331363031c5
          ld a,22                        ; @01FB 3e013232c2
          rst 16                         ; @0200 c7063136c2
          xor a                          ; @0205 af00
          rst 16                         ; @0207 c7063136c2
          xor a                          ; @020C af00
          rst 16                         ; @020E c7063136c2
          ld b,0                         ; @0213 060130c1
PREPIS2   ld a,r                         ; @0217 5f488016c2
          and 63                         ; @021C e6013633c2
          add a,32                       ; @0221 c6013332c2
          rst 16                         ; @0226 c7063136c2
          djnz PREPIS2                   ; @022B 10038016c2
          ret                            ; @0230 c900
                                         ; @0232 0030
DOWNHL    inc h                          ; @0234 24088014c2
          ld a,h                         ; @0239 7c00
          and 7                          ; @023B e60137c1
          ret nz                         ; @023F c000
                                         ; @0241 0030
          ld a,l                         ; @0243 7d00
          add a,32                       ; @0245 c6013332c2
          ld l,a                         ; @024A 6f00
          ld a,h                         ; @024C 7c00
          jr c,DOWNHL2                   ; @024E 38038018c2
          sub 8                          ; @0253 d60138c1
          ld h,a                         ; @0257 6700
DOWNHL2   cp 88                          ; @0259 fe0980183838c4
          ret c                          ; @0260 d800
          ld h,64                        ; @0262 26013634c2
          ret                            ; @0267 c900
                                         ; @0269 0030
LAST                                     ; @026B 00388017c2
                                         ; @0270 0030
          org LAST/256+1*256             ; @0272 043780172f3235362b312a323536cc
                                         ; @0281 0030
SCRNADRS  defs 512                       ; @0283 083f8011353132c5
TABLE     defs 256                       ; @028B 083f8012323536c5
