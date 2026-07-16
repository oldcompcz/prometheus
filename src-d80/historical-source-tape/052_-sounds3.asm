; decoded from 052_-sounds3_t3_l177_p1_255_p2_143.bin
; source_length=143 symbol_count=4 bridge=7eff
; symbols:
;      1: PIXCLS    value=40975 defined=1 locked=0
;      2: PC        value=40978 defined=1 locked=0
;      3: PC2       value=40984 defined=1 locked=0
;      4: PC4       value=40999 defined=1 locked=0

                                         ; @0000 0030
          ent $                          ; @0002 023724c1
                                         ; @0006 0030
          ld hl,0                        ; @0008 210230c1
          ld de,16384                    ; @000C 11023136333834c5
          ld bc,6144                     ; @0014 010236313434c4
          ldir                           ; @001B b040
                                         ; @001D 0030
PIXCLS    ld de,6000                     ; @001F 110a800136303030c6
PC        ld hl,16384                    ; @0028 210a80023136333834c7
          ld b,0                         ; @0032 060130c1
          push de                        ; @0036 d500
PC2       ld a,(de)                      ; @0038 1a088003c2
          and (hl)                       ; @003D a600
          inc hl                         ; @003F 2300
          and (hl)                       ; @0041 a600
          dec hl                         ; @0043 2b00
          ld (hl),a                      ; @0045 7700
                                         ; @0047 0030
          or b                           ; @0049 b000
          ld b,a                         ; @004B 4700
                                         ; @004D 0030
          ld a,(hl)                      ; @004F 7e00
          and 24                         ; @0051 e6013234c2
          or 7                           ; @0056 f60137c1
          out (254),a                    ; @005A d301323534c3
                                         ; @0060 0030
PC4       inc hl                         ; @0062 23088004c2
          inc de                         ; @0067 1300
          ld a,h                         ; @0069 7c00
          cp 22528/256                   ; @006B fe0132323532382f323536c9
          jr nz,PC2                      ; @0077 20038003c2
                                         ; @007C 0030
          pop de                         ; @007E d100
          inc d                          ; @0080 1400
          ld a,b                         ; @0082 7800
          or a                           ; @0084 b700
          jr nz,PC                       ; @0086 20038002c2
          ret                            ; @008B c900
                                         ; @008D 0030
