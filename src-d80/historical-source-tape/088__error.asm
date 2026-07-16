; decoded from 088__error_t3_l701_p1_0_p2_508.bin
; source_length=508 symbol_count=21 bridge=1bff
; symbols:
;      1: ERROR     value=41499 defined=1 locked=0
;      2: IM1       value=41660 defined=1 locked=0
;      3: MESSAGE   value=41689 defined=1 locked=0
;      4: RESERR    value=41534 defined=1 locked=0
;      5: QDONE     value=41550 defined=1 locked=0
;      6: QYD       value=41559 defined=1 locked=0
;      7: YDONE     value=41557 defined=1 locked=0
;      8: SETUP     value=41563 defined=1 locked=0
;      9: START     value=41488 defined=1 locked=0
;     10: SETERRS   value=41566 defined=1 locked=0
;     11: SETERR    value=41582 defined=1 locked=0
;     12: SET1      value=41585 defined=1 locked=0
;     13: SHADE     value=41602 defined=1 locked=0
;     14: SET2      value=41588 defined=1 locked=0
;     15: NAMER     value=41618 defined=1 locked=0
;     16: LD10      value=41654 defined=1 locked=0
;     17: FILENM    value=41672 defined=1 locked=0
;     18: MOVER     value=41645 defined=1 locked=0
;     19: MESSAG2   value=41691 defined=1 locked=0
;     20: RETURN    value=41495 defined=1 locked=0
;     21: GO        value=41491 defined=1 locked=0

                                         ; @0000 0030
START     jp GO                          ; @0002 c30a80098015c4
GO        ld (RETURN+1),sp               ; @0009 734a801580142b31c6
                                         ; @0012 0030
                                         ; @0014 0030
                                         ; @0016 0030
RETURN    ld sp,0                        ; @0018 310a801430c3
          ret                            ; @001E c900
                                         ; @0020 0030
                                         ; @0022 0030
ERROR     call IM1                       ; @0024 cd0a80018002c4
          call 737                       ; @002B cd02373337c3
          ld a,(iy+0)                    ; @0031 7e1430c1
          ld (MESSAGE+1),a               ; @0035 320280032b31c4
          ld (iy+0),-1                   ; @003C 3615301f2d31c4
          ld a,1                         ; @0043 3e0131c1
          ld (23620),a                   ; @0047 32023233363230c5
          ld hl,10                       ; @004F 21023130c2
          ld (23618),hl                  ; @0054 22023233363138c5
          ld sp,(23613)                  ; @005C 7b423233363133c5
          ei                             ; @0064 fb00
          jp 7030                        ; @0066 c30237303330c4
                                         ; @006D 0030
                                         ; @006F 0030
RESERR    ld de,0                        ; @0071 110a800430c3
          call IM1                       ; @0077 cd028002c2
          ld hl,(23613)                  ; @007C 2a023233363133c5
          ld (hl),e                      ; @0084 7300
          inc hl                         ; @0086 2300
          ld (hl),d                      ; @0088 7200
          ld (iy+0),-1                   ; @008A 3615301f2d31c4
QDONE     ld a,0                         ; @0091 3e09800530c3
          or a                           ; @0097 b700
          ld a,0                         ; @0099 3e0130c1
          jr QYD                         ; @009D 18038006c2
                                         ; @00A2 0030
YDONE     ld a,1                         ; @00A4 3e09800731c3
QYD       ld (QDONE+1),a                 ; @00AA 320a800680052b31c6
          ret                            ; @00B3 c900
                                         ; @00B5 0030
                                         ; @00B7 0030
SETUP     ld (START+1),hl                ; @00B9 220a800880092b31c6
SETERRS   ld hl,(23613)                  ; @00C2 2a0a800a3233363133c7
          ld e,(hl)                      ; @00CC 5e00
          inc hl                         ; @00CE 2300
          ld d,(hl)                      ; @00D0 5600
          ld (RESERR+1),de               ; @00D2 534280042b31c4
          ld (hl),ERROR/256              ; @00D9 360180012f323536c6
          dec hl                         ; @00E2 2b00
          ld (hl),ERROR?256              ; @00E4 360180013f323536c6
          ret                            ; @00ED c900
                                         ; @00EF 0030
                                         ; @00F1 0030
SETERR    call SETERRS                   ; @00F3 cd0a800b800ac4
SET1      call SHADE                     ; @00FA cd0a800c800dc4
SET2      call 7841                      ; @0101 cd0a800e37383431c6
          call NAMER                     ; @010A cd02800fc2
          call 8491                      ; @010F cd0238343931c4
          ret nz                         ; @0116 c000
          ld (15986),hl                  ; @0118 22023135393836c5
          ret                            ; @0120 c900
                                         ; @0122 0030
                                         ; @0124 0030
SHADE     call IM1                       ; @0126 cd0a800d8002c4
          rst 0                          ; @012D c70630c1
          di                             ; @0131 f300
          ld a,1                         ; @0133 3e0131c1
          ld (15970),a                   ; @0137 32023135393730c5
          ld a,79                        ; @013F 3e013739c2
          ld (16119),a                   ; @0144 32023136313139c5
          ret                            ; @014C c900
                                         ; @014E 0030
                                         ; @0150 0030
NAMER     ld hl,16042                    ; @0152 210a800f3136303432c7
          ld de,16000                    ; @015C 11023136303030c5
          call LD10                      ; @0164 cd028010c2
          ld hl,FILENM+1                 ; @0169 210280112b31c4
          call LD10                      ; @0170 cd028010c2
          ld a,(FILENM)                  ; @0175 3a028011c2
          ld (de),a                      ; @017A 1200
          ld a,(15979)                   ; @017C 3a023135393739c5
          inc a                          ; @0184 3c00
          ld (15985),a                   ; @0186 32023135393835c5
          ret                            ; @018E c900
                                         ; @0190 0030
                                         ; @0192 0030
MOVER     ld de,FILENM                   ; @0194 110a80128011c4
          ld bc,17                       ; @019B 01023137c2
          ldir                           ; @01A0 b040
          ret                            ; @01A2 c900
                                         ; @01A4 0030
                                         ; @01A6 0030
LD10      ld bc,10                       ; @01A8 010a80103130c4
          ldir                           ; @01AF b040
          ret                            ; @01B1 c900
                                         ; @01B3 0030
                                         ; @01B5 0030
IM1       ld iy,23610                    ; @01B7 211a80023233363130c7
          ld a,63                        ; @01C1 3e013633c2
          ld i,a                         ; @01C6 4740
          im 1                           ; @01C8 5640
          di                             ; @01CA f300
          ret                            ; @01CC c900
                                         ; @01CE 0030
                                         ; @01D0 0030
FILENM    defb 0                         ; @01D2 063f801130c3
          defs 10                        ; @01D8 08373130c2
          defw 0,0,0                     ; @01DD 0937302c302c30c5
                                         ; @01E5 0030
                                         ; @01E7 0030
MESSAGE   ld a,0                         ; @01E9 3e09800330c3
MESSAG2   ld sp,(RETURN+1)               ; @01EF 7b4a801380142b31c6
                                         ; @01F8 0030
          ret                            ; @01FA c900
