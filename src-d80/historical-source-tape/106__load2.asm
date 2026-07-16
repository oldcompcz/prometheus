; decoded from 106__load2_t3_l902_p1_0_p2_685.bin
; source_length=685 symbol_count=24 bridge=dcff
; symbols:
;      1: START     value=41689 defined=1 locked=0
;      2: GO        value=41692 defined=1 locked=0
;      3: RETURN    value=41716 defined=1 locked=0
;      4: ERROR     value=41788 defined=1 locked=0
;      5: IM1       value=41949 defined=1 locked=0
;      6: MESSAGE   value=41978 defined=1 locked=0
;      7: RESERR    value=41823 defined=1 locked=0
;      8: QDONE     value=41839 defined=1 locked=0
;      9: QYD       value=41848 defined=1 locked=0
;     10: YDONE     value=41846 defined=1 locked=0
;     11: SETUP     value=41852 defined=1 locked=0
;     12: SETERRS   value=41855 defined=1 locked=0
;     13: SETERR    value=41871 defined=1 locked=0
;     14: SET1      value=41874 defined=1 locked=0
;     15: SHADE     value=41891 defined=1 locked=0
;     16: SET2      value=41877 defined=1 locked=0
;     17: NAMER     value=41907 defined=1 locked=0
;     18: LD10      value=41943 defined=1 locked=0
;     19: FILENM    value=41961 defined=1 locked=0
;     20: MOVER     value=41934 defined=1 locked=0
;     21: MESSAG2   value=41980 defined=1 locked=0
;     22: R1        value=41707 defined=1 locked=0
;     23: HEAD      value=41771 defined=1 locked=0
;     24: LOAFIL    value=41720 defined=1 locked=0

                                         ; @0000 0030
START     jp GO                          ; @0002 c30a80018002c4
GO        ld (RETURN+1),sp               ; @0009 734a800280032b31c6
                                         ; @0012 0030
          ld (R1+1),sp                   ; @0014 734280162b31c4
          ld ix,HEAD                     ; @001B 21228017c2
          call LOAFIL                    ; @0020 cd028018c2
R1        ld sp,0                        ; @0025 310a801630c3
          call RESERR                    ; @002B cd028007c2
          jp z,MESSAGE                   ; @0030 ca028006c2
                                         ; @0035 0030
                                         ; @0037 0030
RETURN    ld sp,0                        ; @0039 310a800330c3
          ret                            ; @003F c900
                                         ; @0041 0030
                                         ; @0043 0030
LOAFIL    push ix                        ; @0045 e5288018c2
          ld hl,R1                       ; @004A 21028016c2
          call SETUP                     ; @004F cd02800bc2
          call SHADE                     ; @0054 cd02800fc2
          pop hl                         ; @0059 e100
          call MOVER                     ; @005B cd028014c2
          call SET2                      ; @0060 cd028010c2
          ld a,27                        ; @0065 3e013237c2
          jp nz,MESSAG2                  ; @006A c2028015c2
                                         ; @006F 0030
          ld ix,(15986)                  ; @0071 2a223135393836c5
          ld e,(ix+13)                   ; @0079 5e243133c2
          ld d,(ix+14)                   ; @007E 56243134c2
          push de                        ; @0083 d500
          ld e,(ix+11)                   ; @0085 5e243131c2
          ld d,(ix+12)                   ; @008A 56243132c2
          pop ix                         ; @008F e120
          call 6574                      ; @0091 cd0236353734c4
          call 737                       ; @0098 cd02373337c3
          jp YDONE                       ; @009E c302800ac2
                                         ; @00A3 0030
                                         ; @00A5 0030
HEAD      defb "B"                       ; @00A7 063f8017224222c5
          defm "filetoload"              ; @00AF 07372266696c65746f6c6f616422cc
          defw 6912,16384,32768          ; @00BE 0937363931322c31363338342c3332373638d0
                                         ; @00D1 0030
                                         ; @00D3 0030
ERROR     call IM1                       ; @00D5 cd0a80048005c4
          call 737                       ; @00DC cd02373337c3
          ld a,(iy+0)                    ; @00E2 7e1430c1
          ld (MESSAGE+1),a               ; @00E6 320280062b31c4
          ld (iy+0),-1                   ; @00ED 3615301f2d31c4
          ld a,1                         ; @00F4 3e0131c1
          ld (23620),a                   ; @00F8 32023233363230c5
          ld hl,10                       ; @0100 21023130c2
          ld (23618),hl                  ; @0105 22023233363138c5
          ld sp,(23613)                  ; @010D 7b423233363133c5
          ei                             ; @0115 fb00
          jp 7030                        ; @0117 c30237303330c4
                                         ; @011E 0030
                                         ; @0120 0030
RESERR    ld de,0                        ; @0122 110a800730c3
          call IM1                       ; @0128 cd028005c2
          ld hl,(23613)                  ; @012D 2a023233363133c5
          ld (hl),e                      ; @0135 7300
          inc hl                         ; @0137 2300
          ld (hl),d                      ; @0139 7200
          ld (iy+0),-1                   ; @013B 3615301f2d31c4
QDONE     ld a,0                         ; @0142 3e09800830c3
          or a                           ; @0148 b700
          ld a,0                         ; @014A 3e0130c1
          jr QYD                         ; @014E 18038009c2
                                         ; @0153 0030
YDONE     ld a,1                         ; @0155 3e09800a31c3
QYD       ld (QDONE+1),a                 ; @015B 320a800980082b31c6
          ret                            ; @0164 c900
                                         ; @0166 0030
                                         ; @0168 0030
SETUP     ld (START+1),hl                ; @016A 220a800b80012b31c6
SETERRS   ld hl,(23613)                  ; @0173 2a0a800c3233363133c7
          ld e,(hl)                      ; @017D 5e00
          inc hl                         ; @017F 2300
          ld d,(hl)                      ; @0181 5600
          ld (RESERR+1),de               ; @0183 534280072b31c4
          ld (hl),ERROR/256              ; @018A 360180042f323536c6
          dec hl                         ; @0193 2b00
          ld (hl),ERROR?256              ; @0195 360180043f323536c6
          ret                            ; @019E c900
                                         ; @01A0 0030
                                         ; @01A2 0030
SETERR    call SETERRS                   ; @01A4 cd0a800d800cc4
SET1      call SHADE                     ; @01AB cd0a800e800fc4
SET2      call 7841                      ; @01B2 cd0a801037383431c6
          call NAMER                     ; @01BB cd028011c2
          call 8491                      ; @01C0 cd0238343931c4
          ret nz                         ; @01C7 c000
          ld (15986),hl                  ; @01C9 22023135393836c5
          ret                            ; @01D1 c900
                                         ; @01D3 0030
                                         ; @01D5 0030
SHADE     call IM1                       ; @01D7 cd0a800f8005c4
          rst 0                          ; @01DE c70630c1
          di                             ; @01E2 f300
          ld a,1                         ; @01E4 3e0131c1
          ld (15970),a                   ; @01E8 32023135393730c5
          ld a,79                        ; @01F0 3e013739c2
          ld (16119),a                   ; @01F5 32023136313139c5
          ret                            ; @01FD c900
                                         ; @01FF 0030
                                         ; @0201 0030
NAMER     ld hl,16042                    ; @0203 210a80113136303432c7
          ld de,16000                    ; @020D 11023136303030c5
          call LD10                      ; @0215 cd028012c2
          ld hl,FILENM+1                 ; @021A 210280132b31c4
          call LD10                      ; @0221 cd028012c2
          ld a,(FILENM)                  ; @0226 3a028013c2
          ld (de),a                      ; @022B 1200
          ld a,(15979)                   ; @022D 3a023135393739c5
          inc a                          ; @0235 3c00
          ld (15985),a                   ; @0237 32023135393835c5
          ret                            ; @023F c900
                                         ; @0241 0030
                                         ; @0243 0030
MOVER     ld de,FILENM                   ; @0245 110a80148013c4
          ld bc,17                       ; @024C 01023137c2
          ldir                           ; @0251 b040
          ret                            ; @0253 c900
                                         ; @0255 0030
                                         ; @0257 0030
LD10      ld bc,10                       ; @0259 010a80123130c4
          ldir                           ; @0260 b040
          ret                            ; @0262 c900
                                         ; @0264 0030
                                         ; @0266 0030
IM1       ld iy,23610                    ; @0268 211a80053233363130c7
          ld a,63                        ; @0272 3e013633c2
          ld i,a                         ; @0277 4740
          im 1                           ; @0279 5640
          di                             ; @027B f300
          ret                            ; @027D c900
                                         ; @027F 0030
                                         ; @0281 0030
FILENM    defb 0                         ; @0283 063f801330c3
          defs 10                        ; @0289 08373130c2
          defw 0,0,0                     ; @028E 0937302c302c30c5
                                         ; @0296 0030
                                         ; @0298 0030
MESSAGE   ld a,0                         ; @029A 3e09800630c3
MESSAG2   ld sp,(RETURN+1)               ; @02A0 7b4a801580032b31c6
                                         ; @02A9 0030
          ret                            ; @02AB c900
