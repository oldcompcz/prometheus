; decoded from 026_+rolls2_t3_l1303_p1_0_p2_966.bin
; source_length=966 symbol_count=33 bridge=86ff
; symbols:
;      1: VYSKA     value=   20 defined=1 locked=0
;      2: SIRKA     value=   25 defined=1 locked=0
;      3: DOWNHL    value=42886 defined=1 locked=0
;      4: DOWNHL2   value=42901 defined=1 locked=0
;      5: TEST      value=42305 defined=1 locked=0
;      6: UPHL      value=42865 defined=1 locked=0
;      7: UPHL2     value=42880 defined=1 locked=0
;      8: ROL_UP    value=42421 defined=1 locked=0
;      9: BUFFER    value=42602 defined=1 locked=0
;     10: RLU1      value=42434 defined=1 locked=0
;     11: RLCM      value=42448 defined=1 locked=0
;     12: ROL_DOWN  value=42477 defined=1 locked=0
;     13: RLD1      value=42490 defined=1 locked=0
;     14: ROL_RGHT  value=42313 defined=1 locked=0
;     15: RLR1      value=42318 defined=1 locked=0
;     16: RLR2      value=42321 defined=1 locked=0
;     17: ROL_LEFT  value=42367 defined=1 locked=0
;     18: RLL1      value=42372 defined=1 locked=0
;     19: RLL2      value=42375 defined=1 locked=0
;     20: ATTRADR   value=42827 defined=1 locked=0
;     21: DOWNCH    value=42835 defined=1 locked=0
;     22: LINE_BUF  value=42579 defined=1 locked=0
;     23: MOVELINE  value=42530 defined=1 locked=0
;     24: BUF_LINE  value=42449 defined=1 locked=0
;     25: BUF_LIN2  value=42458 defined=1 locked=0
;     26: UPCH      value=42850 defined=1 locked=0
;     27: SCR_UPLT  value=42506 defined=1 locked=0
;     28: SCRUL1    value=42511 defined=1 locked=0
;     29: MOVELNE2  value=42533 defined=1 locked=0
;     30: MOVELIN2  value=42537 defined=1 locked=0
;     31: ONE_BUF   value=42562 defined=1 locked=0
;     32: ONE_BU2   value=42565 defined=1 locked=0
;     33: LINE_BU2  value=42585 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
          im 1                           ; @0008 5640
          ld hl,0                        ; @000A 210230c1
          ld de,16384                    ; @000E 11023136333834c5
          ld bc,6912                     ; @0016 010236393132c4
          ldir                           ; @001D b040
          ld b,32                        ; @001F 06013332c2
TEST      push bc                        ; @0024 c5088005c2
          call SCR_UPLT                  ; @0029 cd02801bc2
          pop bc                         ; @002E c100
          djnz TEST                      ; @0030 10038005c2
          ret                            ; @0035 c900
                                         ; @0037 0030
                                         ; @0039 0030
SIRKA     equ 25                         ; @003B 033f80023235c4
VYSKA     equ 20                         ; @0042 033f80013230c4
                                         ; @0049 0030
ROL_RGHT  ld hl,16451+SIRKA              ; @004B 210a800e31363435312b8002ca
          ld c,VYSKA-1                   ; @0058 0e0180012d31c4
RLR1      push hl                        ; @005F e508800fc2
          ld b,8                         ; @0064 060138c1
RLR2      push bc                        ; @0068 c5088010c2
          push hl                        ; @006D e500
          ld a,(hl)                      ; @006F 7e00
          push af                        ; @0071 f500
          ld e,l                         ; @0073 5d00
          ld d,h                         ; @0075 5400
          dec hl                         ; @0077 2b00
          ld bc,SIRKA-1                  ; @0079 010280022d31c4
          lddr                           ; @0080 b840
          pop af                         ; @0082 f100
          ld (de),a                      ; @0084 1200
          pop hl                         ; @0086 e100
          inc h                          ; @0088 2400
          pop bc                         ; @008A c100
          djnz RLR2                      ; @008C 10038010c2
          pop hl                         ; @0091 e100
                                         ; @0093 0030
          push hl                        ; @0095 e500
          call ATTRADR                   ; @0097 cd028014c2
          push bc                        ; @009C c500
          ld a,(hl)                      ; @009E 7e00
          push af                        ; @00A0 f500
          ld e,l                         ; @00A2 5d00
          ld d,h                         ; @00A4 5400
          dec hl                         ; @00A6 2b00
          ld bc,SIRKA-1                  ; @00A8 010280022d31c4
          lddr                           ; @00AF b840
          pop af                         ; @00B1 f100
          ld (de),a                      ; @00B3 1200
          pop bc                         ; @00B5 c100
          pop hl                         ; @00B7 e100
          call DOWNCH                    ; @00B9 cd028015c2
          dec c                          ; @00BE 0d00
          jr nz,RLR1                     ; @00C0 2003800fc2
          ret                            ; @00C5 c900
                                         ; @00C7 0030
ROL_LEFT  ld hl,16452                    ; @00C9 210a80113136343532c7
          ld c,VYSKA-1                   ; @00D3 0e0180012d31c4
RLL1      push hl                        ; @00DA e5088012c2
          ld b,8                         ; @00DF 060138c1
RLL2      push bc                        ; @00E3 c5088013c2
          push hl                        ; @00E8 e500
          ld a,(hl)                      ; @00EA 7e00
          push af                        ; @00EC f500
          ld e,l                         ; @00EE 5d00
          ld d,h                         ; @00F0 5400
          inc hl                         ; @00F2 2300
          ld bc,SIRKA-1                  ; @00F4 010280022d31c4
          ldir                           ; @00FB b040
          pop af                         ; @00FD f100
          ld (de),a                      ; @00FF 1200
          pop hl                         ; @0101 e100
          inc h                          ; @0103 2400
          pop bc                         ; @0105 c100
          djnz RLL2                      ; @0107 10038013c2
          pop hl                         ; @010C e100
                                         ; @010E 0030
          push hl                        ; @0110 e500
          call ATTRADR                   ; @0112 cd028014c2
          push bc                        ; @0117 c500
          ld a,(hl)                      ; @0119 7e00
          push af                        ; @011B f500
          ld e,l                         ; @011D 5d00
          ld d,h                         ; @011F 5400
          inc hl                         ; @0121 2300
          ld bc,SIRKA-1                  ; @0123 010280022d31c4
          ldir                           ; @012A b040
          pop af                         ; @012C f100
          ld (de),a                      ; @012E 1200
          pop bc                         ; @0130 c100
          pop hl                         ; @0132 e100
          call DOWNCH                    ; @0134 cd028015c2
          dec c                          ; @0139 0d00
          jr nz,RLL1                     ; @013B 20038012c2
          ret                            ; @0140 c900
                                         ; @0142 0030
ROL_UP    ld hl,16452                    ; @0144 210a80083136343532c7
          push hl                        ; @014E e500
          ld de,BUFFER                   ; @0150 11028009c2
          call LINE_BUF                  ; @0155 cd028016c2
          pop hl                         ; @015A e100
          ld b,VYSKA-1                   ; @015C 060180012d31c4
RLU1      push hl                        ; @0163 e508800ac2
          call DOWNCH                    ; @0168 cd028015c2
          pop de                         ; @016D d100
          push bc                        ; @016F c500
          push hl                        ; @0171 e500
          call MOVELINE                  ; @0173 cd028017c2
          pop hl                         ; @0178 e100
          pop bc                         ; @017A c100
          djnz RLU1                      ; @017C 1003800ac2
                                         ; @0181 0030
RLCM      ex de,hl                       ; @0183 eb08800bc2
BUF_LINE  ld hl,BUFFER                   ; @0188 210a80188009c4
          ld bc,SIRKA                    ; @018F 01028002c2
          push de                        ; @0194 d500
          ld a,8                         ; @0196 3e0138c1
BUF_LIN2  push de                        ; @019A d5088019c2
          push bc                        ; @019F c500
          ldir                           ; @01A1 b040
          pop bc                         ; @01A3 c100
          pop de                         ; @01A5 d100
          inc d                          ; @01A7 1400
          dec a                          ; @01A9 3d00
          jr nz,BUF_LIN2                 ; @01AB 20038019c2
          pop de                         ; @01B0 d100
          ex de,hl                       ; @01B2 eb00
          call ATTRADR                   ; @01B4 cd028014c2
          ex de,hl                       ; @01B9 eb00
          ldir                           ; @01BB b040
          ret                            ; @01BD c900
                                         ; @01BF 0030
ROL_DOWN  ld hl,20480+160+4              ; @01C1 210a800c32303438302b3136302b34cd
          push hl                        ; @01D1 e500
          ld de,BUFFER                   ; @01D3 11028009c2
          call LINE_BUF                  ; @01D8 cd028016c2
          pop hl                         ; @01DD e100
          ld b,VYSKA-1                   ; @01DF 060180012d31c4
RLD1      push hl                        ; @01E6 e508800dc2
          call UPCH                      ; @01EB cd02801ac2
          pop de                         ; @01F0 d100
          push bc                        ; @01F2 c500
          push hl                        ; @01F4 e500
          call MOVELINE                  ; @01F6 cd028017c2
          pop hl                         ; @01FB e100
          pop bc                         ; @01FD c100
          djnz RLD1                      ; @01FF 1003800dc2
          jr RLCM                        ; @0204 1803800bc2
                                         ; @0209 0030
SCR_UPLT  ld hl,16452                    ; @020B 210a801b3136343532c7
          ld b,VYSKA-1                   ; @0215 060180012d31c4
SCRUL1    push hl                        ; @021C e508801cc2
          call DOWNCH                    ; @0221 cd028015c2
          pop de                         ; @0226 d100
          push bc                        ; @0228 c500
          push hl                        ; @022A e500
          inc hl                         ; @022C 2300
          ld bc,SIRKA-1                  ; @022E 010280022d31c4
          call MOVELNE2                  ; @0235 cd02801dc2
          pop hl                         ; @023A e100
          pop bc                         ; @023C c100
          djnz SCRUL1                    ; @023E 1003801cc2
          ret                            ; @0243 c900
                                         ; @0245 0030
MOVELINE  ld bc,SIRKA                    ; @0247 010a80178002c4
MOVELNE2  push hl                        ; @024E e508801dc2
          push de                        ; @0253 d500
          ld a,8                         ; @0255 3e0138c1
MOVELIN2  push hl                        ; @0259 e508801ec2
          push de                        ; @025E d500
          push bc                        ; @0260 c500
          ldir                           ; @0262 b040
          pop bc                         ; @0264 c100
          pop de                         ; @0266 d100
          pop hl                         ; @0268 e100
          inc h                          ; @026A 2400
          inc d                          ; @026C 1400
          dec a                          ; @026E 3d00
          jr nz,MOVELIN2                 ; @0270 2003801ec2
          pop hl                         ; @0275 e100
          call ATTRADR                   ; @0277 cd028014c2
          ex de,hl                       ; @027C eb00
          pop hl                         ; @027E e100
          call ATTRADR                   ; @0280 cd028014c2
          ldir                           ; @0285 b040
          ret                            ; @0287 c900
                                         ; @0289 0030
ONE_BUF   push hl                        ; @028B e508801fc2
          ld b,8                         ; @0290 060138c1
ONE_BU2   push hl                        ; @0294 e5088020c2
          ld a,(hl)                      ; @0299 7e00
          ld (de),a                      ; @029B 1200
          inc de                         ; @029D 1300
          inc h                          ; @029F 2400
          djnz ONE_BU2                   ; @02A1 10038020c2
          pop hl                         ; @02A6 e100
          call ATTRADR                   ; @02A8 cd028014c2
          ldi                            ; @02AD a040
          ret                            ; @02AF c900
                                         ; @02B1 0030
LINE_BUF  ld bc,SIRKA                    ; @02B3 010a80168002c4
          push hl                        ; @02BA e500
          ld a,8                         ; @02BC 3e0138c1
LINE_BU2  push hl                        ; @02C0 e5088021c2
          push bc                        ; @02C5 c500
          ldir                           ; @02C7 b040
          pop bc                         ; @02C9 c100
          pop hl                         ; @02CB e100
          inc h                          ; @02CD 2400
          dec a                          ; @02CF 3d00
          jr nz,LINE_BU2                 ; @02D1 20038021c2
          pop hl                         ; @02D6 e100
          call ATTRADR                   ; @02D8 cd028014c2
          ldir                           ; @02DD b040
          ret                            ; @02DF c900
                                         ; @02E1 0030
BUFFER    defs 9*SIRKA                   ; @02E3 083f8009392a8002c6
                                         ; @02EC 0030
ATTRADR   ld a,h                         ; @02EE 7c088014c2
          rrca                           ; @02F3 0f00
          rrca                           ; @02F5 0f00
          rrca                           ; @02F7 0f00
          xor %1010000                   ; @02F9 ee012531303130303030c8
          ld h,a                         ; @0304 6700
          ret                            ; @0306 c900
                                         ; @0308 0030
DOWNCH    ld a,l                         ; @030A 7d088015c2
          add a,32                       ; @030F c6013332c2
          ld l,a                         ; @0314 6f00
          ret nc                         ; @0316 d000
          ld a,h                         ; @0318 7c00
          add a,8                        ; @031A c60138c1
          ld h,a                         ; @031E 6700
          cp 88                          ; @0320 fe013838c2
          ret nz                         ; @0325 c000
          ld h,64                        ; @0327 26013634c2
          ret                            ; @032C c900
                                         ; @032E 0030
UPCH      ld a,l                         ; @0330 7d08801ac2
          sub 32                         ; @0335 d6013332c2
          ld l,a                         ; @033A 6f00
          ret nc                         ; @033C d000
          ld a,h                         ; @033E 7c00
          sub 8                          ; @0340 d60138c1
          ld h,a                         ; @0344 6700
          cp 57                          ; @0346 fe013537c2
          ret nz                         ; @034B c000
          ld h,80                        ; @034D 26013830c2
          ret                            ; @0352 c900
                                         ; @0354 0030
                                         ; @0356 0030
UPHL      ld a,h                         ; @0358 7c088006c2
          dec h                          ; @035D 2500
          and 7                          ; @035F e60137c1
          ret nz                         ; @0363 c000
          ld a,l                         ; @0365 7d00
          sub 32                         ; @0367 d6013332c2
          ld l,a                         ; @036C 6f00
          ld a,h                         ; @036E 7c00
          jr c,UPHL2                     ; @0370 38038007c2
          add a,8                        ; @0375 c60138c1
          ld h,a                         ; @0379 6700
UPHL2     cp 64                          ; @037B fe0980073634c4
          ret nc                         ; @0382 d000
          ld h,87                        ; @0384 26013837c2
          ret                            ; @0389 c900
                                         ; @038B 0030
                                         ; @038D 0030
DOWNHL    inc h                          ; @038F 24088003c2
          ld a,h                         ; @0394 7c00
          and 7                          ; @0396 e60137c1
          ret nz                         ; @039A c000
          ld a,l                         ; @039C 7d00
          add a,32                       ; @039E c6013332c2
          ld l,a                         ; @03A3 6f00
          ld a,h                         ; @03A5 7c00
          jr c,DOWNHL2                   ; @03A7 38038004c2
          sub 8                          ; @03AC d60138c1
          ld h,a                         ; @03B0 6700
DOWNHL2   cp 88                          ; @03B2 fe0980043838c4
          ret c                          ; @03B9 d800
          ld h,64                        ; @03BB 26013634c2
          ret                            ; @03C0 c900
                                         ; @03C2 0030
                                         ; @03C4 0030
