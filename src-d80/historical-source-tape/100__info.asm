; decoded from 100__info_t3_l435_p1_0_p2_314.bin
; source_length=314 symbol_count=15 bridge=97ff
; symbols:
;      1: INFO      value=41222 defined=1 locked=0
;      2: BAD       value=41251 defined=1 locked=0
;      3: GOOD      value=41279 defined=1 locked=0
;      4: FREE      value=41272 defined=1 locked=0
;      5: IO0       value=41237 defined=1 locked=0
;      6: FDBLOCK   value=41291 defined=1 locked=0
;      7: IO1       value=41260 defined=1 locked=0
;      8: IO2       value=41286 defined=1 locked=0
;      9: DIR       value=58000 defined=1 locked=0
;     10: LESS      value=41299 defined=1 locked=0
;     11: MORE      value=41306 defined=1 locked=0
;     12: TYPE      value=41345 defined=1 locked=0
;     13: NODD      value=41335 defined=1 locked=0
;     14: ODD       value=41327 defined=1 locked=0
;     15: BOTH      value=41340 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
DIR       equ 58000                      ; @0008 033f80093538303030c7
                                         ; @0012 0030
                                         ; @0014 0030
INFO      ld hl,0                        ; @0016 210a800130c3
          ld (BAD+1),hl                  ; @001C 220280022b31c4
          ld (GOOD+1),hl                 ; @0023 220280032b31c4
          ld (FREE+1),hl                 ; @002A 220280042b31c4
          ld bc,1705                     ; @0031 010231373035c4
IO0       dec bc                         ; @0038 0b088005c2
          ld h,b                         ; @003D 6000
          ld l,c                         ; @003F 6900
          call FDBLOCK                   ; @0041 cd028006c2
          or a                           ; @0046 b700
          ld hl,3583                     ; @0048 210233353833c4
          sbc hl,de                      ; @004F 5240
          jr nz,IO1                      ; @0051 20038007c2
BAD       ld hl,0                        ; @0056 210a800230c3
          inc hl                         ; @005C 2300
          ld (BAD+1),hl                  ; @005E 220280022b31c4
          jr IO2                         ; @0065 18038008c2
                                         ; @006A 0030
IO1       or a                           ; @006C b7088007c2
          ld hl,3549                     ; @0071 210233353439c4
          sbc hl,de                      ; @0078 5240
          jr z,IO2                       ; @007A 28038008c2
          ld a,d                         ; @007F 7a00
          or e                           ; @0081 b300
          jr nz,GOOD                     ; @0083 20038003c2
FREE      ld hl,0                        ; @0088 210a800430c3
          inc hl                         ; @008E 2300
          ld (FREE+1),hl                 ; @0090 220280042b31c4
GOOD      ld hl,0                        ; @0097 210a800330c3
          inc hl                         ; @009D 2300
          ld (GOOD+1),hl                 ; @009F 220280032b31c4
IO2       ld a,b                         ; @00A6 78088008c2
          or c                           ; @00AB b100
          jr nz,IO0                      ; @00AD 20038005c2
          ret                            ; @00B2 c900
                                         ; @00B4 0030
                                         ; @00B6 0030
FDBLOCK   push bc                        ; @00B8 c5088006c2
          ld bc,DIR                      ; @00BD 01028009c2
          ld de,341                      ; @00C2 1102333431c3
          or a                           ; @00C8 b700
LESS      inc b                          ; @00CA 0408800ac2
          inc b                          ; @00CF 0400
          sbc hl,de                      ; @00D1 5240
          jr nc,LESS                     ; @00D3 3003800ac2
          add hl,de                      ; @00D8 1900
MORE      ld e,l                         ; @00DA 5d08800bc2
          ld d,h                         ; @00DF 5400
          srl d                          ; @00E1 3a80
          rr e                           ; @00E3 1b80
          ex af,af'                      ; @00E5 0800
          add hl,de                      ; @00E7 1900
          add hl,bc                      ; @00E9 0900
          ld e,(hl)                      ; @00EB 5e00
          inc hl                         ; @00ED 2300
          ld d,(hl)                      ; @00EF 5600
          dec hl                         ; @00F1 2b00
          ld a,1                         ; @00F3 3e0131c1
          ld (TYPE),a                    ; @00F7 3202800cc2
          ex af,af'                      ; @00FC 0800
          jr nc,NODD                     ; @00FE 3003800dc2
ODD       xor a                          ; @0103 af08800ec2
          ld (TYPE),a                    ; @0108 3202800cc2
          ld a,e                         ; @010D 7b00
          ld e,d                         ; @010F 5a00
          jr BOTH                        ; @0111 1803800fc2
                                         ; @0116 0030
NODD      ld a,d                         ; @0118 7a08800dc2
          rrca                           ; @011D 0f00
          rrca                           ; @011F 0f00
          rrca                           ; @0121 0f00
          rrca                           ; @0123 0f00
BOTH      and 15                         ; @0125 e609800f3135c4
          ld d,a                         ; @012C 5700
          pop bc                         ; @012E c100
          ret                            ; @0130 c900
                                         ; @0132 0030
TYPE      defb 0                         ; @0134 063f800c30c3
