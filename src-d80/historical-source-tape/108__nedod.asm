; decoded from 108__nedod_t3_l298_p1_0_p2_183.bin
; source_length=183 symbol_count=12 bridge=71ff
; symbols:
;      1: LDFILE    value=41065 defined=1 locked=0
;      2: BREAD     value= 1280 defined=0 locked=0
;      3: LDSVR     value= 1280 defined=0 locked=0
;      4: FINDFL    value= 1536 defined=0 locked=0
;      5: MESSAG2   value= 1792 defined=0 locked=0
;      6: LDF1      value=41089 defined=1 locked=0
;      7: FDBLOCK   value= 1792 defined=0 locked=0
;      8: LDF3      value=41141 defined=1 locked=0
;      9: LDF2      value=41114 defined=1 locked=0
;     10: DIVIDE    value= 1536 defined=0 locked=0
;     11: LDADR     value= 1280 defined=0 locked=0
;     12: LDSV      value= 1024 defined=0 locked=0

                                         ; @0000 0030
LDFILE    ld hl,BREAD                    ; @0002 210a80018002c4
          ld (LDSVR+1),hl                ; @0009 220280032b31c4
                                         ; @0010 0030
          call FINDFL                    ; @0012 cd028004c2
          ld a,27                        ; @0017 3e013237c2
          jp c,MESSAG2                   ; @001C da028005c2
          push hl                        ; @0021 e500
          pop ix                         ; @0023 e120
          ld l,(ix+17)                   ; @0025 6e243137c2
          ld h,(ix+18)                   ; @002A 66243138c2
          push hl                        ; @002F e500
LDF1      call FDBLOCK                   ; @0031 cd0a80068007c4
          ld hl,3072                     ; @0038 210233303732c4
          sbc hl,de                      ; @003F 5240
          jr z,LDF3                      ; @0041 28038008c2
          ld a,d                         ; @0046 7a00
          cp 14                          ; @0048 fe013134c2
          jr nc,LDF2                     ; @004D 30038009c2
          pop hl                         ; @0052 e100
          call LDSVR                     ; @0054 cd028003c2
          call FDBLOCK                   ; @0059 cd028007c2
          ex de,hl                       ; @005E eb00
          jr LDF1                        ; @0060 18038006c2
                                         ; @0065 0030
LDF2      and 1                          ; @0067 e609800931c3
          ld d,a                         ; @006D 5700
          pop hl                         ; @006F e100
          push de                        ; @0071 d500
          call DIVIDE                    ; @0073 cd02800ac2
          ld hl,14848                    ; @0078 21023134383438c5
          push hl                        ; @0080 e500
          ld de,257                      ; @0082 1102323537c3
          call BREAD                     ; @0088 cd028002c2
          pop hl                         ; @008D e100
          pop bc                         ; @008F c100
          ld de,(LDADR+1)                ; @0091 5b42800b2b31c4
          ldir                           ; @0098 b040
          defb 62                        ; @009A 06373632c2
LDF3      pop hl                         ; @009F e1088008c2
          jp 9526                        ; @00A4 c30239353236c4
                                         ; @00AB 0030
LDSV      push hl                        ; @00AD e508800cc2
          call DIVIDE                    ; @00B2 cd02800ac2
