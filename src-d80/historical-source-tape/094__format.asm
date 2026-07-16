; decoded from 094__format_t3_l987_p1_0_p2_734.bin
; source_length=734 symbol_count=28 bridge=d2ff
; symbols:
;      1: ERROR     value=41882 defined=1 locked=0
;      2: IM1       value=42043 defined=1 locked=0
;      3: MESSAGE   value=42072 defined=1 locked=0
;      4: RESERR    value=41917 defined=1 locked=0
;      5: QDONE     value=41933 defined=1 locked=0
;      6: QYD       value=41942 defined=1 locked=0
;      7: YDONE     value=41940 defined=1 locked=0
;      8: SETUP     value=41946 defined=1 locked=0
;      9: START     value=41774 defined=1 locked=0
;     10: SETERRS   value=41949 defined=1 locked=0
;     11: SETERR    value=41965 defined=1 locked=0
;     12: SET1      value=41968 defined=1 locked=0
;     13: SHADE     value=41985 defined=1 locked=0
;     14: SET2      value=41971 defined=1 locked=0
;     15: NAMER     value=42001 defined=1 locked=0
;     16: LD10      value=42037 defined=1 locked=0
;     17: FILENM    value=42055 defined=1 locked=0
;     18: MOVER     value=42028 defined=1 locked=0
;     19: MESSAG2   value=42074 defined=1 locked=0
;     20: RETURN    value=41797 defined=1 locked=0
;     21: GO        value=41777 defined=1 locked=0
;     22: R1        value=41788 defined=1 locked=0
;     23: FORDIS    value=41801 defined=1 locked=0
;     24: FOR_ME    value= 4990 defined=1 locked=0
;     25: DKNAME    value=41872 defined=1 locked=0
;     26: TRACK     value=   40 defined=1 locked=0
;     27: SECT      value=    9 defined=1 locked=0
;     28: OPT       value=   24 defined=1 locked=0

                                         ; @0000 0030
FOR_ME    equ 4990                       ; @0002 033f801834393930c6
TRACK     equ 40                         ; @000B 033f801a3430c4
SECT      equ 9                          ; @0012 033f801b39c3
OPT       equ %00011000                  ; @0018 033f801c253030303131303030cb
                                         ; @0026 0030
                                         ; @0028 0030
START     jp GO                          ; @002A c30a80098015c4
GO        ld (RETURN+1),sp               ; @0031 734a801580142b31c6
                                         ; @003A 0030
          ld (R1+1),sp                   ; @003C 734280162b31c4
          call FORDIS                    ; @0043 cd028017c2
R1        ld sp,0                        ; @0048 310a801630c3
          call RESERR                    ; @004E cd028004c2
          jp z,MESSAGE                   ; @0053 ca028003c2
                                         ; @0058 0030
                                         ; @005A 0030
RETURN    ld sp,0                        ; @005C 310a801430c3
          ret                            ; @0062 c900
                                         ; @0064 0030
                                         ; @0066 0030
FORDIS    ld hl,R1                       ; @0068 210a80178016c4
          call SETUP                     ; @006F cd028008c2
          call SHADE                     ; @0074 cd02800dc2
          ld hl,DKNAME                   ; @0079 21028019c2
          ld de,16010                    ; @007E 11023136303130c5
          call LD10                      ; @0086 cd028010c2
          call 8609                      ; @008B cd0238363039c4
          ld a,(ix+5)                    ; @0092 7e2435c1
          ld (ix+1),a                    ; @0096 772431c1
          ld a,(ix+6)                    ; @009A 7e2436c1
          ld (ix+2),a                    ; @009E 772432c1
          ld a,(ix+7)                    ; @00A2 7e2437c1
          ld (ix+3),a                    ; @00A6 772433c1
                                         ; @00AA 0030
          ld a,TRACK                     ; @00AC 3e01801ac2
          ld (ix+2),a                    ; @00B1 772432c1
          ld a,SECT                      ; @00B5 3e01801bc2
          ld (ix+3),a                    ; @00BA 772433c1
          ld a,OPT                       ; @00BE 3e01801cc2
          ld (ix+1),a                    ; @00C3 772431c1
                                         ; @00C7 0030
          call 8571                      ; @00C9 cd0238353731c4
          call FOR_ME                    ; @00D0 cd028018c2
          ld a,79                        ; @00D5 3e013739c2
          ld (16119),a                   ; @00DA 32023136313139c5
          call 737                       ; @00E2 cd02373337c3
          jp YDONE                       ; @00E8 c3028007c2
                                         ; @00ED 0030
                                         ; @00EF 0030
DKNAME    defm "NoNameDisk"              ; @00F1 073f8019224e6f4e616d654469736b22ce
                                         ; @0102 0030
                                         ; @0104 0030
ERROR     call IM1                       ; @0106 cd0a80018002c4
          call 737                       ; @010D cd02373337c3
          ld a,(iy+0)                    ; @0113 7e1430c1
          ld (MESSAGE+1),a               ; @0117 320280032b31c4
          ld (iy+0),-1                   ; @011E 3615301f2d31c4
          ld a,1                         ; @0125 3e0131c1
          ld (23620),a                   ; @0129 32023233363230c5
          ld hl,10                       ; @0131 21023130c2
          ld (23618),hl                  ; @0136 22023233363138c5
          ld sp,(23613)                  ; @013E 7b423233363133c5
          ei                             ; @0146 fb00
          jp 7030                        ; @0148 c30237303330c4
                                         ; @014F 0030
                                         ; @0151 0030
RESERR    ld de,0                        ; @0153 110a800430c3
          call IM1                       ; @0159 cd028002c2
          ld hl,(23613)                  ; @015E 2a023233363133c5
          ld (hl),e                      ; @0166 7300
          inc hl                         ; @0168 2300
          ld (hl),d                      ; @016A 7200
          ld (iy+0),-1                   ; @016C 3615301f2d31c4
QDONE     ld a,0                         ; @0173 3e09800530c3
          or a                           ; @0179 b700
          ld a,0                         ; @017B 3e0130c1
          jr QYD                         ; @017F 18038006c2
                                         ; @0184 0030
YDONE     ld a,1                         ; @0186 3e09800731c3
QYD       ld (QDONE+1),a                 ; @018C 320a800680052b31c6
          ret                            ; @0195 c900
                                         ; @0197 0030
                                         ; @0199 0030
SETUP     ld (START+1),hl                ; @019B 220a800880092b31c6
SETERRS   ld hl,(23613)                  ; @01A4 2a0a800a3233363133c7
          ld e,(hl)                      ; @01AE 5e00
          inc hl                         ; @01B0 2300
          ld d,(hl)                      ; @01B2 5600
          ld (RESERR+1),de               ; @01B4 534280042b31c4
          ld (hl),ERROR/256              ; @01BB 360180012f323536c6
          dec hl                         ; @01C4 2b00
          ld (hl),ERROR?256              ; @01C6 360180013f323536c6
          ret                            ; @01CF c900
                                         ; @01D1 0030
                                         ; @01D3 0030
SETERR    call SETERRS                   ; @01D5 cd0a800b800ac4
SET1      call SHADE                     ; @01DC cd0a800c800dc4
SET2      call 7841                      ; @01E3 cd0a800e37383431c6
          call NAMER                     ; @01EC cd02800fc2
          call 8491                      ; @01F1 cd0238343931c4
          ret nz                         ; @01F8 c000
          ld (15986),hl                  ; @01FA 22023135393836c5
          ret                            ; @0202 c900
                                         ; @0204 0030
                                         ; @0206 0030
SHADE     call IM1                       ; @0208 cd0a800d8002c4
          rst 0                          ; @020F c70630c1
          di                             ; @0213 f300
          ld a,1                         ; @0215 3e0131c1
          ld (15970),a                   ; @0219 32023135393730c5
          ld a,79                        ; @0221 3e013739c2
          ld (16119),a                   ; @0226 32023136313139c5
          ret                            ; @022E c900
                                         ; @0230 0030
                                         ; @0232 0030
NAMER     ld hl,16042                    ; @0234 210a800f3136303432c7
          ld de,16000                    ; @023E 11023136303030c5
          call LD10                      ; @0246 cd028010c2
          ld hl,FILENM+1                 ; @024B 210280112b31c4
          call LD10                      ; @0252 cd028010c2
          ld a,(FILENM)                  ; @0257 3a028011c2
          ld (de),a                      ; @025C 1200
          ld a,(15979)                   ; @025E 3a023135393739c5
          inc a                          ; @0266 3c00
          ld (15985),a                   ; @0268 32023135393835c5
          ret                            ; @0270 c900
                                         ; @0272 0030
                                         ; @0274 0030
MOVER     ld de,FILENM                   ; @0276 110a80128011c4
          ld bc,17                       ; @027D 01023137c2
          ldir                           ; @0282 b040
          ret                            ; @0284 c900
                                         ; @0286 0030
                                         ; @0288 0030
LD10      ld bc,10                       ; @028A 010a80103130c4
          ldir                           ; @0291 b040
          ret                            ; @0293 c900
                                         ; @0295 0030
                                         ; @0297 0030
IM1       ld iy,23610                    ; @0299 211a80023233363130c7
          ld a,63                        ; @02A3 3e013633c2
          ld i,a                         ; @02A8 4740
          im 1                           ; @02AA 5640
          di                             ; @02AC f300
          ret                            ; @02AE c900
                                         ; @02B0 0030
                                         ; @02B2 0030
FILENM    defb 0                         ; @02B4 063f801130c3
          defs 10                        ; @02BA 08373130c2
          defw 0,0,0                     ; @02BF 0937302c302c30c5
                                         ; @02C7 0030
                                         ; @02C9 0030
MESSAGE   ld a,0                         ; @02CB 3e09800330c3
MESSAG2   ld sp,(RETURN+1)               ; @02D1 7b4a801380142b31c6
                                         ; @02DA 0030
          ret                            ; @02DC c900
