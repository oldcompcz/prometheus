; decoded from 096__frblock_t3_l314_p1_0_p2_217.bin
; source_length=217 symbol_count=12 bridge=b0ff
; symbols:
;      1: T         value=   40 defined=1 locked=0
;      2: S         value=    9 defined=1 locked=0
;      3: FRBLOCK   value=41101 defined=1 locked=0
;      4: FR0       value=41104 defined=1 locked=0
;      5: FDBLOCK   value=41123 defined=1 locked=0
;      6: LESS      value=41131 defined=1 locked=0
;      7: MORE      value=41138 defined=1 locked=0
;      8: TYPE      value=41177 defined=1 locked=0
;      9: NODD      value=41167 defined=1 locked=0
;     10: ODD       value=41159 defined=1 locked=0
;     11: BOTH      value=41172 defined=1 locked=0
;     12: DIR       value=58000 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
DIR       equ 58000                      ; @0008 033f800c3538303030c7
                                         ; @0012 0030
T         equ 40                         ; @0014 033f80013430c4
S         equ 9                          ; @001B 033f800239c3
                                         ; @0021 0030
FRBLOCK   ld bc,13                       ; @0023 010a80033133c4
FR0       inc bc                         ; @002A 03088004c2
          ld d,b                         ; @002F 5000
          ld e,c                         ; @0031 5900
          or a                           ; @0033 b700
          ld hl,2*T*S                    ; @0035 2102322a80012a8002c7
          sbc hl,de                      ; @003F 5240
          ret c                          ; @0041 d800
          ex de,hl                       ; @0043 eb00
          call FDBLOCK                   ; @0045 cd028005c2
          ld a,d                         ; @004A 7a00
          or e                           ; @004C b300
          jr nz,FR0                      ; @004E 20038004c2
          ret                            ; @0053 c900
                                         ; @0055 0030
FDBLOCK   push bc                        ; @0057 c5088005c2
          ld bc,DIR                      ; @005C 0102800cc2
          ld de,341                      ; @0061 1102333431c3
          or a                           ; @0067 b700
LESS      inc b                          ; @0069 04088006c2
          inc b                          ; @006E 0400
          sbc hl,de                      ; @0070 5240
          jr nc,LESS                     ; @0072 30038006c2
          add hl,de                      ; @0077 1900
MORE      ld e,l                         ; @0079 5d088007c2
          ld d,h                         ; @007E 5400
          srl d                          ; @0080 3a80
          rr e                           ; @0082 1b80
          ex af,af'                      ; @0084 0800
          add hl,de                      ; @0086 1900
          add hl,bc                      ; @0088 0900
          ld e,(hl)                      ; @008A 5e00
          inc hl                         ; @008C 2300
          ld d,(hl)                      ; @008E 5600
          dec hl                         ; @0090 2b00
          ld a,1                         ; @0092 3e0131c1
          ld (TYPE),a                    ; @0096 32028008c2
          ex af,af'                      ; @009B 0800
          jr nc,NODD                     ; @009D 30038009c2
ODD       xor a                          ; @00A2 af08800ac2
          ld (TYPE),a                    ; @00A7 32028008c2
          ld a,e                         ; @00AC 7b00
          ld e,d                         ; @00AE 5a00
          jr BOTH                        ; @00B0 1803800bc2
                                         ; @00B5 0030
NODD      ld a,d                         ; @00B7 7a088009c2
          rrca                           ; @00BC 0f00
          rrca                           ; @00BE 0f00
          rrca                           ; @00C0 0f00
          rrca                           ; @00C2 0f00
BOTH      and 15                         ; @00C4 e609800b3135c4
          ld d,a                         ; @00CB 5700
          pop bc                         ; @00CD c100
          ret                            ; @00CF c900
                                         ; @00D1 0030
TYPE      defb 0                         ; @00D3 063f800830c3
