; decoded from 104__load1_t3_l886_p1_0_p2_669.bin
; source_length=669 symbol_count=24 bridge=21ff
; symbols:
;      1: START     value=41673 defined=1 locked=0
;      2: GO        value=41676 defined=1 locked=0
;      3: RETURN    value=41700 defined=1 locked=0
;      4: ERROR     value=41761 defined=1 locked=0
;      5: IM1       value=41922 defined=1 locked=0
;      6: MESSAGE   value=41951 defined=1 locked=0
;      7: RESERR    value=41796 defined=1 locked=0
;      8: QDONE     value=41812 defined=1 locked=0
;      9: QYD       value=41821 defined=1 locked=0
;     10: YDONE     value=41819 defined=1 locked=0
;     11: SETUP     value=41825 defined=1 locked=0
;     12: SETERRS   value=41828 defined=1 locked=0
;     13: SETERR    value=41844 defined=1 locked=0
;     14: SET1      value=41847 defined=1 locked=0
;     15: SHADE     value=41864 defined=1 locked=0
;     16: SET2      value=41850 defined=1 locked=0
;     17: NAMER     value=41880 defined=1 locked=0
;     18: LD10      value=41916 defined=1 locked=0
;     19: FILENM    value=41934 defined=1 locked=0
;     20: MOVER     value=41907 defined=1 locked=0
;     21: MESSAG2   value=41953 defined=1 locked=0
;     22: R1        value=41691 defined=1 locked=0
;     23: HEAD      value=41744 defined=1 locked=0
;     24: LOAFIL    value=41704 defined=1 locked=0

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
          ld de,(FILENM+11)              ; @0071 5b4280132b3131c5
          ld ix,(FILENM+13)              ; @0079 2a2280132b3133c5
          call 6574                      ; @0081 cd0236353734c4
          call 737                       ; @0088 cd02373337c3
          jp YDONE                       ; @008E c302800ac2
                                         ; @0093 0030
                                         ; @0095 0030
HEAD      defb "B"                       ; @0097 063f8017224222c5
          defm "filetoload"              ; @009F 07372266696c65746f6c6f616422cc
          defw 6912,16384,32768          ; @00AE 0937363931322c31363338342c3332373638d0
                                         ; @00C1 0030
                                         ; @00C3 0030
ERROR     call IM1                       ; @00C5 cd0a80048005c4
          call 737                       ; @00CC cd02373337c3
          ld a,(iy+0)                    ; @00D2 7e1430c1
          ld (MESSAGE+1),a               ; @00D6 320280062b31c4
          ld (iy+0),-1                   ; @00DD 3615301f2d31c4
          ld a,1                         ; @00E4 3e0131c1
          ld (23620),a                   ; @00E8 32023233363230c5
          ld hl,10                       ; @00F0 21023130c2
          ld (23618),hl                  ; @00F5 22023233363138c5
          ld sp,(23613)                  ; @00FD 7b423233363133c5
          ei                             ; @0105 fb00
          jp 7030                        ; @0107 c30237303330c4
                                         ; @010E 0030
                                         ; @0110 0030
RESERR    ld de,0                        ; @0112 110a800730c3
          call IM1                       ; @0118 cd028005c2
          ld hl,(23613)                  ; @011D 2a023233363133c5
          ld (hl),e                      ; @0125 7300
          inc hl                         ; @0127 2300
          ld (hl),d                      ; @0129 7200
          ld (iy+0),-1                   ; @012B 3615301f2d31c4
QDONE     ld a,0                         ; @0132 3e09800830c3
          or a                           ; @0138 b700
          ld a,0                         ; @013A 3e0130c1
          jr QYD                         ; @013E 18038009c2
                                         ; @0143 0030
YDONE     ld a,1                         ; @0145 3e09800a31c3
QYD       ld (QDONE+1),a                 ; @014B 320a800980082b31c6
          ret                            ; @0154 c900
                                         ; @0156 0030
                                         ; @0158 0030
SETUP     ld (START+1),hl                ; @015A 220a800b80012b31c6
SETERRS   ld hl,(23613)                  ; @0163 2a0a800c3233363133c7
          ld e,(hl)                      ; @016D 5e00
          inc hl                         ; @016F 2300
          ld d,(hl)                      ; @0171 5600
          ld (RESERR+1),de               ; @0173 534280072b31c4
          ld (hl),ERROR/256              ; @017A 360180042f323536c6
          dec hl                         ; @0183 2b00
          ld (hl),ERROR?256              ; @0185 360180043f323536c6
          ret                            ; @018E c900
                                         ; @0190 0030
                                         ; @0192 0030
SETERR    call SETERRS                   ; @0194 cd0a800d800cc4
SET1      call SHADE                     ; @019B cd0a800e800fc4
SET2      call 7841                      ; @01A2 cd0a801037383431c6
          call NAMER                     ; @01AB cd028011c2
          call 8491                      ; @01B0 cd0238343931c4
          ret nz                         ; @01B7 c000
          ld (15986),hl                  ; @01B9 22023135393836c5
          ret                            ; @01C1 c900
                                         ; @01C3 0030
                                         ; @01C5 0030
SHADE     call IM1                       ; @01C7 cd0a800f8005c4
          rst 0                          ; @01CE c70630c1
          di                             ; @01D2 f300
          ld a,1                         ; @01D4 3e0131c1
          ld (15970),a                   ; @01D8 32023135393730c5
          ld a,79                        ; @01E0 3e013739c2
          ld (16119),a                   ; @01E5 32023136313139c5
          ret                            ; @01ED c900
                                         ; @01EF 0030
                                         ; @01F1 0030
NAMER     ld hl,16042                    ; @01F3 210a80113136303432c7
          ld de,16000                    ; @01FD 11023136303030c5
          call LD10                      ; @0205 cd028012c2
          ld hl,FILENM+1                 ; @020A 210280132b31c4
          call LD10                      ; @0211 cd028012c2
          ld a,(FILENM)                  ; @0216 3a028013c2
          ld (de),a                      ; @021B 1200
          ld a,(15979)                   ; @021D 3a023135393739c5
          inc a                          ; @0225 3c00
          ld (15985),a                   ; @0227 32023135393835c5
          ret                            ; @022F c900
                                         ; @0231 0030
                                         ; @0233 0030
MOVER     ld de,FILENM                   ; @0235 110a80148013c4
          ld bc,17                       ; @023C 01023137c2
          ldir                           ; @0241 b040
          ret                            ; @0243 c900
                                         ; @0245 0030
                                         ; @0247 0030
LD10      ld bc,10                       ; @0249 010a80123130c4
          ldir                           ; @0250 b040
          ret                            ; @0252 c900
                                         ; @0254 0030
                                         ; @0256 0030
IM1       ld iy,23610                    ; @0258 211a80053233363130c7
          ld a,63                        ; @0262 3e013633c2
          ld i,a                         ; @0267 4740
          im 1                           ; @0269 5640
          di                             ; @026B f300
          ret                            ; @026D c900
                                         ; @026F 0030
                                         ; @0271 0030
FILENM    defb 0                         ; @0273 063f801330c3
          defs 10                        ; @0279 08373130c2
          defw 0,0,0                     ; @027E 0937302c302c30c5
                                         ; @0286 0030
                                         ; @0288 0030
MESSAGE   ld a,0                         ; @028A 3e09800630c3
MESSAG2   ld sp,(RETURN+1)               ; @0290 7b4a801580032b31c6
                                         ; @0299 0030
          ret                            ; @029B c900
