; decoded from 118__save_t3_l873_p1_0_p2_656.bin
; source_length=656 symbol_count=24 bridge=74ff
; symbols:
;      1: START     value=41660 defined=1 locked=0
;      2: GO        value=41663 defined=1 locked=0
;      3: RETURN    value=41687 defined=1 locked=0
;      4: R1        value=41678 defined=1 locked=0
;      5: HEAD      value=41728 defined=1 locked=0
;      6: SAVFIL    value=41691 defined=1 locked=0
;      7: RESERR    value=41780 defined=1 locked=0
;      8: MESSAGE   value=41935 defined=1 locked=0
;      9: SETUP     value=41809 defined=1 locked=0
;     10: SHADE     value=41848 defined=1 locked=0
;     11: MOVER     value=41891 defined=1 locked=0
;     12: SET2      value=41834 defined=1 locked=0
;     13: FILENM    value=41918 defined=1 locked=0
;     14: YDONE     value=41803 defined=1 locked=0
;     15: ERROR     value=41745 defined=1 locked=0
;     16: IM1       value=41906 defined=1 locked=0
;     17: QDONE     value=41796 defined=1 locked=0
;     18: QYD       value=41805 defined=1 locked=0
;     19: SETERRS   value=41812 defined=1 locked=0
;     20: SETERR    value=41828 defined=1 locked=0
;     21: SET1      value=41831 defined=1 locked=0
;     22: NAMER     value=41864 defined=1 locked=0
;     23: LD10      value=41900 defined=1 locked=0
;     24: MESSAG2   value=41937 defined=1 locked=0

                                         ; @0000 0030
START     jp GO                          ; @0002 c30a80018002c4
GO        ld (RETURN+1),sp               ; @0009 734a800280032b31c6
                                         ; @0012 0030
          ld (R1+1),sp                   ; @0014 734280042b31c4
          ld ix,HEAD                     ; @001B 21228005c2
          call SAVFIL                    ; @0020 cd028006c2
R1        ld sp,0                        ; @0025 310a800430c3
          call RESERR                    ; @002B cd028007c2
          jp z,MESSAGE                   ; @0030 ca028008c2
                                         ; @0035 0030
                                         ; @0037 0030
RETURN    ld sp,0                        ; @0039 310a800330c3
          ret                            ; @003F c900
                                         ; @0041 0030
                                         ; @0043 0030
SAVFIL    push ix                        ; @0045 e5288006c2
          ld hl,R1                       ; @004A 21028004c2
          call SETUP                     ; @004F cd028009c2
          call SHADE                     ; @0054 cd02800ac2
          pop hl                         ; @0059 e100
          call MOVER                     ; @005B cd02800bc2
          call SET2                      ; @0060 cd02800cc2
                                         ; @0065 0030
          ld ix,FILENM                   ; @0067 2122800dc2
          ld l,(ix+13)                   ; @006C 6e243133c2
          ld h,(ix+14)                   ; @0071 66243134c2
          call 6650                      ; @0076 cd0236363530c4
          call 737                       ; @007D cd02373337c3
          jp YDONE                       ; @0083 c302800ec2
                                         ; @0088 0030
                                         ; @008A 0030
HEAD      defb 3                         ; @008C 063f800533c3
          defm "filetoload"              ; @0092 07372266696c65746f6c6f616422cc
          defw 6912,16384,32768          ; @00A1 0937363931322c31363338342c3332373638d0
                                         ; @00B4 0030
                                         ; @00B6 0030
ERROR     call IM1                       ; @00B8 cd0a800f8010c4
          call 737                       ; @00BF cd02373337c3
          ld a,(iy+0)                    ; @00C5 7e1430c1
          ld (MESSAGE+1),a               ; @00C9 320280082b31c4
          ld (iy+0),-1                   ; @00D0 3615301f2d31c4
          ld a,1                         ; @00D7 3e0131c1
          ld (23620),a                   ; @00DB 32023233363230c5
          ld hl,10                       ; @00E3 21023130c2
          ld (23618),hl                  ; @00E8 22023233363138c5
          ld sp,(23613)                  ; @00F0 7b423233363133c5
          ei                             ; @00F8 fb00
          jp 7030                        ; @00FA c30237303330c4
                                         ; @0101 0030
                                         ; @0103 0030
RESERR    ld de,0                        ; @0105 110a800730c3
          call IM1                       ; @010B cd028010c2
          ld hl,(23613)                  ; @0110 2a023233363133c5
          ld (hl),e                      ; @0118 7300
          inc hl                         ; @011A 2300
          ld (hl),d                      ; @011C 7200
          ld (iy+0),-1                   ; @011E 3615301f2d31c4
QDONE     ld a,0                         ; @0125 3e09801130c3
          or a                           ; @012B b700
          ld a,0                         ; @012D 3e0130c1
          jr QYD                         ; @0131 18038012c2
                                         ; @0136 0030
YDONE     ld a,1                         ; @0138 3e09800e31c3
QYD       ld (QDONE+1),a                 ; @013E 320a801280112b31c6
          ret                            ; @0147 c900
                                         ; @0149 0030
                                         ; @014B 0030
SETUP     ld (START+1),hl                ; @014D 220a800980012b31c6
SETERRS   ld hl,(23613)                  ; @0156 2a0a80133233363133c7
          ld e,(hl)                      ; @0160 5e00
          inc hl                         ; @0162 2300
          ld d,(hl)                      ; @0164 5600
          ld (RESERR+1),de               ; @0166 534280072b31c4
          ld (hl),ERROR/256              ; @016D 3601800f2f323536c6
          dec hl                         ; @0176 2b00
          ld (hl),ERROR?256              ; @0178 3601800f3f323536c6
          ret                            ; @0181 c900
                                         ; @0183 0030
                                         ; @0185 0030
SETERR    call SETERRS                   ; @0187 cd0a80148013c4
SET1      call SHADE                     ; @018E cd0a8015800ac4
SET2      call 7841                      ; @0195 cd0a800c37383431c6
          call NAMER                     ; @019E cd028016c2
          call 8491                      ; @01A3 cd0238343931c4
          ret nz                         ; @01AA c000
          ld (15986),hl                  ; @01AC 22023135393836c5
          ret                            ; @01B4 c900
                                         ; @01B6 0030
                                         ; @01B8 0030
SHADE     call IM1                       ; @01BA cd0a800a8010c4
          rst 0                          ; @01C1 c70630c1
          di                             ; @01C5 f300
          ld a,1                         ; @01C7 3e0131c1
          ld (15970),a                   ; @01CB 32023135393730c5
          ld a,79                        ; @01D3 3e013739c2
          ld (16119),a                   ; @01D8 32023136313139c5
          ret                            ; @01E0 c900
                                         ; @01E2 0030
                                         ; @01E4 0030
NAMER     ld hl,16042                    ; @01E6 210a80163136303432c7
          ld de,16000                    ; @01F0 11023136303030c5
          call LD10                      ; @01F8 cd028017c2
          ld hl,FILENM+1                 ; @01FD 2102800d2b31c4
          call LD10                      ; @0204 cd028017c2
          ld a,(FILENM)                  ; @0209 3a02800dc2
          ld (de),a                      ; @020E 1200
          ld a,(15979)                   ; @0210 3a023135393739c5
          inc a                          ; @0218 3c00
          ld (15985),a                   ; @021A 32023135393835c5
          ret                            ; @0222 c900
                                         ; @0224 0030
                                         ; @0226 0030
MOVER     ld de,FILENM                   ; @0228 110a800b800dc4
          ld bc,17                       ; @022F 01023137c2
          ldir                           ; @0234 b040
          ret                            ; @0236 c900
                                         ; @0238 0030
                                         ; @023A 0030
LD10      ld bc,10                       ; @023C 010a80173130c4
          ldir                           ; @0243 b040
          ret                            ; @0245 c900
                                         ; @0247 0030
                                         ; @0249 0030
IM1       ld iy,23610                    ; @024B 211a80103233363130c7
          ld a,63                        ; @0255 3e013633c2
          ld i,a                         ; @025A 4740
          im 1                           ; @025C 5640
          di                             ; @025E f300
          ret                            ; @0260 c900
                                         ; @0262 0030
                                         ; @0264 0030
FILENM    defb 0                         ; @0266 063f800d30c3
          defs 10                        ; @026C 08373130c2
          defw 0,0,0                     ; @0271 0937302c302c30c5
                                         ; @0279 0030
                                         ; @027B 0030
MESSAGE   ld a,0                         ; @027D 3e09800830c3
MESSAG2   ld sp,(RETURN+1)               ; @0283 7b4a801880032b31c6
                                         ; @028C 0030
          ret                            ; @028E c900
