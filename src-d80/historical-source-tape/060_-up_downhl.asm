; decoded from 060_-up_downhl_t3_l237_p1_0_p2_179.bin
; source_length=179 symbol_count=6 bridge=b3ff
; symbols:
;      1: DOWNHL    value=41041 defined=1 locked=0
;      2: DOWNHL2   value=41056 defined=1 locked=0
;      3: UPHL      value=41062 defined=1 locked=0
;      4: UPHL2     value=41077 defined=1 locked=0
;      5: TEST      value=41024 defined=1 locked=0
;      6: LOOP      value=41032 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
TEST      im 1                           ; @0008 56488005c2
          ei                             ; @000D fb00
          ld hl,19000                    ; @000F 21023139303030c5
          ld b,192                       ; @0017 0601313932c3
LOOP      ld (hl),255                    ; @001D 36098006323535c5
          halt                           ; @0025 7600
          call DOWNHL                    ; @0027 cd028001c2
          djnz LOOP                      ; @002C 10038006c2
          ret                            ; @0031 c900
                                         ; @0033 0030
                                         ; @0035 0030
                                         ; @0037 0030
DOWNHL    inc h                          ; @0039 24088001c2
          ld a,h                         ; @003E 7c00
          and 7                          ; @0040 e60137c1
          ret nz                         ; @0044 c000
                                         ; @0046 0030
          ld a,l                         ; @0048 7d00
          add a,32                       ; @004A c6013332c2
          ld l,a                         ; @004F 6f00
          ld a,h                         ; @0051 7c00
          jr c,DOWNHL2                   ; @0053 38038002c2
                                         ; @0058 0030
          sub 8                          ; @005A d60138c1
          ld h,a                         ; @005E 6700
                                         ; @0060 0030
DOWNHL2   cp 88                          ; @0062 fe0980023838c4
          ret c                          ; @0069 d800
          ld h,64                        ; @006B 26013634c2
          ret                            ; @0070 c900
                                         ; @0072 0030
                                         ; @0074 0030
                                         ; @0076 0030
                                         ; @0078 0030
UPHL      ld a,h                         ; @007A 7c088003c2
          dec h                          ; @007F 2500
          and 7                          ; @0081 e60137c1
          ret nz                         ; @0085 c000
                                         ; @0087 0030
          ld a,l                         ; @0089 7d00
          sub 32                         ; @008B d6013332c2
          ld l,a                         ; @0090 6f00
          ld a,h                         ; @0092 7c00
          jr c,UPHL2                     ; @0094 38038004c2
                                         ; @0099 0030
          add a,8                        ; @009B c60138c1
          ld h,a                         ; @009F 6700
                                         ; @00A1 0030
UPHL2     cp 64                          ; @00A3 fe0980043634c4
          ret nc                         ; @00AA d000
          ld h,87                        ; @00AC 26013837c2
          ret                            ; @00B1 c900
