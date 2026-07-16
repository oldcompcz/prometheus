
    org 0x7918
    ; @@ 0x7918 Included from binary file '/mnt/data/prometheus_d80_work/disasmtest/asm_driver.bin'.
    jp 0x793f                           ; @@ 0x7918 c3 3f 79     .instr -- install disk hooks and continue to PROMETHEUS assembler
    ld hl, 0x8099                       ; @@ 0x791b 21 99 80     .instr -- restore cassette hooks and continue to PROMETHEUS assembler
    ld (hl), 0x3e                       ; @@ 0x791e 36 3e
    inc hl                              ; @@ 0x7920 23
    ld (hl), 0xc                        ; @@ 0x7921 36 0c
    inc hl                              ; @@ 0x7923 23
    ld (hl), 0xdd                       ; @@ 0x7924 36 dd
    ld hl, 0x81ff                       ; @@ 0x7926 21 ff 81
    ld (hl), 0xcd                       ; @@ 0x7929 36 cd
    inc hl                              ; @@ 0x792b 23
    ld (hl), 0xa                        ; @@ 0x792c 36 0a
    inc hl                              ; @@ 0x792e 23
    ld (hl), 0x86                       ; @@ 0x792f 36 86
    ld hl, 0x822b                       ; @@ 0x7931 21 2b 82
    ld (hl), 0xcd                       ; @@ 0x7934 36 cd
    inc hl                              ; @@ 0x7936 23
    ld (hl), 0x38                       ; @@ 0x7937 36 38
    inc hl                              ; @@ 0x7939 23
    ld (hl), 0x81                       ; @@ 0x793a 36 81
    jp 0x7b76                           ; @@ 0x793c c3 76 7b
    ld hl, 0x8099                       ; @@ 0x793f 21 99 80
    ld (hl), 0xc3                       ; @@ 0x7942 36 c3
    inc hl                              ; @@ 0x7944 23
    ld (hl), 0x63                       ; @@ 0x7945 36 63
    inc hl                              ; @@ 0x7947 23
    ld (hl), 0x79                       ; @@ 0x7948 36 79
    ld hl, 0x81ff                       ; @@ 0x794a 21 ff 81
    ld (hl), 0xc3                       ; @@ 0x794d 36 c3
    inc hl                              ; @@ 0x794f 23
    ld (hl), 0xd4                       ; @@ 0x7950 36 d4
    inc hl                              ; @@ 0x7952 23
    ld (hl), 0x79                       ; @@ 0x7953 36 79
    ld hl, 0x822b                       ; @@ 0x7955 21 2b 82
    ld (hl), 0xc3                       ; @@ 0x7958 36 c3
    inc hl                              ; @@ 0x795a 23
    ld (hl), 0x95                       ; @@ 0x795b 36 95
    inc hl                              ; @@ 0x795d 23
    ld (hl), 0x7a                       ; @@ 0x795e 36 7a
    jp 0x7b76                           ; @@ 0x7960 c3 76 7b
    call 0x79ae                         ; @@ 0x7963 cd ae 79     .instr -- patched assembler save entry
    pop bc                              ; @@ 0x7966 c1
    pop hl                              ; @@ 0x7967 e1
    push hl                             ; @@ 0x7968 e5
    push bc                             ; @@ 0x7969 c5
    ld d, 0xff                          ; @@ 0x796a 16 ff
    ld a, d                             ; @@ 0x796c 7a
    xor (hl)                            ; @@ 0x796d ae
    ld d, a                             ; @@ 0x796e 57
    inc hl                              ; @@ 0x796f 23
    dec bc                              ; @@ 0x7970 0b
    ld a, b                             ; @@ 0x7971 78
    or c                                ; @@ 0x7972 b1
    jr nz, 0x796c                       ; @@ 0x7973 20 f7
    ld ixh, d                           ; @@ 0x7975 dd 62
    pop bc                              ; @@ 0x7977 c1
    pop hl                              ; @@ 0x7978 e1
    add hl, bc                          ; @@ 0x7979 09
    dec hl                              ; @@ 0x797a 2b
    ld de, (0x80af)                     ; @@ 0x797b ed 5b af 80
    dec de                              ; @@ 0x797f 1b
    ld a, 0xff                          ; @@ 0x7980 3e ff
    ld (de), a                          ; @@ 0x7982 12
    dec de                              ; @@ 0x7983 1b
    ld a, ixh                           ; @@ 0x7984 dd 7c
    ld (de), a                          ; @@ 0x7986 12
    dec de                              ; @@ 0x7987 1b
    push bc                             ; @@ 0x7988 c5
    ld a, (de)                          ; @@ 0x7989 1a
    ldd                                 ; @@ 0x798a ed a8
    inc hl                              ; @@ 0x798c 23
    ld (hl), a                          ; @@ 0x798d 77
    dec hl                              ; @@ 0x798e 2b
    jp pe, 0x7989                       ; @@ 0x798f ea 89 79
    inc hl                              ; @@ 0x7992 23
    inc de                              ; @@ 0x7993 13
    push hl                             ; @@ 0x7994 e5
    push de                             ; @@ 0x7995 d5
    call 0x7a37                         ; @@ 0x7996 cd 37 7a
    pop de                              ; @@ 0x7999 d1
    pop hl                              ; @@ 0x799a e1
    pop bc                              ; @@ 0x799b c1
    ld a, (de)                          ; @@ 0x799c 1a
    ldi                                 ; @@ 0x799d ed a0
    dec hl                              ; @@ 0x799f 2b
    ld (hl), a                          ; @@ 0x79a0 77
    inc hl                              ; @@ 0x79a1 23
    jp pe, 0x799c                       ; @@ 0x79a2 ea 9c 79
    xor a                               ; @@ 0x79a5 af
    ld (de), a                          ; @@ 0x79a6 12
    inc de                              ; @@ 0x79a7 13
    ld a, 0x30                          ; @@ 0x79a8 3e 30
    ld (de), a                          ; @@ 0x79aa 12
    jp 0x85ea                           ; @@ 0x79ab c3 ea 85
    exx                                 ; @@ 0x79ae d9
    ld hl, 0x50e0                       ; @@ 0x79af 21 e0 50
    ld de, 0x94ff                       ; @@ 0x79b2 11 ff 94
    ld bc, 0x11                         ; @@ 0x79b5 01 11 00
    ldir                                ; @@ 0x79b8 ed b0
    ld hl, 0x9509                       ; @@ 0x79ba 21 09 95
    ld b, 0x9                           ; @@ 0x79bd 06 09
    ld a, (hl)                          ; @@ 0x79bf 7e
    cp 0x20                             ; @@ 0x79c0 fe 20
    jr nz, 0x79c9                       ; @@ 0x79c2 20 05
    ld (hl), 0x0                        ; @@ 0x79c4 36 00
    dec hl                              ; @@ 0x79c6 2b
    djnz 0x79bf                         ; @@ 0x79c7 10 f6
    exx                                 ; @@ 0x79c9 d9
    ret                                 ; @@ 0x79ca c9
    ld de, 0x7b0f                       ; @@ 0x79cb 11 0f 7b
    call 0x7aca                         ; @@ 0x79ce cd ca 7a
    jp 0x7b76                           ; @@ 0x79d1 c3 76 7b
    ld a, (0x8103)                      ; @@ 0x79d4 3a 03 81     .instr -- patched assembler load entry
    cp 0x21                             ; @@ 0x79d7 fe 21
    jr z, 0x79cb                        ; @@ 0x79d9 28 f0
    ld bc, 0x7a60                       ; @@ 0x79db 01 60 7a
    call 0x7a1f                         ; @@ 0x79de cd 1f 7a
    ld hl, 0x8102                       ; @@ 0x79e1 21 02 81
    call 0x79b2                         ; @@ 0x79e4 cd b2 79
    call 0x7a2d                         ; @@ 0x79e7 cd 2d 7a
    push af                             ; @@ 0x79ea f5
    ld (0x3e72), hl                     ; @@ 0x79eb 22 72 3e
    ld de, 0x50e0                       ; @@ 0x79ee 11 e0 50
    ld bc, 0x11                         ; @@ 0x79f1 01 11 00
    ldir                                ; @@ 0x79f4 ed b0
    call 0x7aa8                         ; @@ 0x79f6 cd a8 7a
    pop af                              ; @@ 0x79f9 f1
    jp z, 0x8207                        ; @@ 0x79fa ca 07 82
    ld hl, 0x7b50                       ; @@ 0x79fd 21 50 7b
    jr 0x7a63                           ; @@ 0x7a00 18 61
    ld hl, 0x3eaa                       ; @@ 0x7a02 21 aa 3e
    ld de, 0x3e80                       ; @@ 0x7a05 11 80 3e
    ld bc, 0xa                          ; @@ 0x7a08 01 0a 00
    ldir                                ; @@ 0x7a0b ed b0
    ld hl, 0x9500                       ; @@ 0x7a0d 21 00 95
    ld c, 0xa                           ; @@ 0x7a10 0e 0a
    ldir                                ; @@ 0x7a12 ed b0
    ld a, 0x42                          ; @@ 0x7a14 3e 42
    ld (de), a                          ; @@ 0x7a16 12
    ld a, (0x3e6b)                      ; @@ 0x7a17 3a 6b 3e
    inc a                               ; @@ 0x7a1a 3c
    ld (0x3e71), a                      ; @@ 0x7a1b 32 71 3e
    ret                                 ; @@ 0x7a1e c9
    ld hl, (0x5c3d)                     ; @@ 0x7a1f 2a 3d 5c
    ld e, (hl)                          ; @@ 0x7a22 5e
    inc hl                              ; @@ 0x7a23 23
    ld d, (hl)                          ; @@ 0x7a24 56
    ld (0x7ab9), de                     ; @@ 0x7a25 ed 53 b9 7a
    ld (hl), b                          ; @@ 0x7a29 70
    dec hl                              ; @@ 0x7a2a 2b
    ld (hl), c                          ; @@ 0x7a2b 71
    ret                                 ; @@ 0x7a2c c9
    call 0x7ac7                         ; @@ 0x7a2d cd c7 7a
    rst 0x0                             ; @@ 0x7a30 c7
    call 0x7a02                         ; @@ 0x7a31 cd 02 7a
    jp 0x212b                           ; @@ 0x7a34 c3 2b 21
    ld (0x7a53), sp                     ; @@ 0x7a37 ed 73 53 7a
    push de                             ; @@ 0x7a3b d5
    ld bc, 0x7a52                       ; @@ 0x7a3c 01 52 7a
    call 0x7a1f                         ; @@ 0x7a3f cd 1f 7a
    call 0x7a2d                         ; @@ 0x7a42 cd 2d 7a
    jr nz, 0x7a80                       ; @@ 0x7a45 20 39
    ld hl, 0x7b5a                       ; @@ 0x7a47 21 5a 7b
    rst 0x28                            ; @@ 0x7a4a ef
    dec l                               ; @@ 0x7a4b 2d
    ld a, e                             ; @@ 0x7a4c 7b
    jr z, 0x7a80                        ; @@ 0x7a4d 28 31
    pop hl                              ; @@ 0x7a4f e1
    jr 0x7aa8                           ; @@ 0x7a50 18 56
    db 0x31, 0x00                       ; @@ 0x7a52 31 00
    db 0x00, 0x21, 0x64, 0x7b           ; @@ 0x7a54 00 21 64 7b
    db 0xcd, 0x19, 0x7b, 0xcd           ; @@ 0x7a58 cd 19 7b cd
    db 0x36, 0x90, 0x18, 0x48           ; @@ 0x7a5c 36 90 18 48
    db 0x21, 0x64, 0x7b                 ; @@ 0x7a60 21 64 7b
    ld sp, (0x871d)                     ; @@ 0x7a63 ed 7b 1d 87
    call 0x7b19                         ; @@ 0x7a67 cd 19 7b
    call 0x7aab                         ; @@ 0x7a6a cd ab 7a
    jp 0x871c                           ; @@ 0x7a6d c3 1c 87
    ld hl, 0x50c0                       ; @@ 0x7a70 21 c0 50
    ld (0x91b6), hl                     ; @@ 0x7a73 22 b6 91
    ld b, 0x20                          ; @@ 0x7a76 06 20
    ld a, 0x7e                          ; @@ 0x7a78 3e 7e
    call 0x9195                         ; @@ 0x7a7a cd 95 91
    djnz 0x7a78                         ; @@ 0x7a7d 10 f9
    ret                                 ; @@ 0x7a7f c9
    ld ix, 0x94ff                       ; @@ 0x7a80 dd 21 ff 94
    call 0x19e1                         ; @@ 0x7a84 cd e1 19
    pop hl                              ; @@ 0x7a87 e1
    ld (0x3e74), hl                     ; @@ 0x7a88 22 74 3e
    ld a, 0x1                           ; @@ 0x7a8b 3e 01
    ld (0x3e62), a                      ; @@ 0x7a8d 32 62 3e
    call 0x1a00                         ; @@ 0x7a90 cd 00 1a
    jr 0x7aa8                           ; @@ 0x7a93 18 13
    push ix                             ; @@ 0x7a95 dd e5        .instr -- patched assembler catalogue entry
    push de                             ; @@ 0x7a97 d5
    call 0x7ac7                         ; @@ 0x7a98 cd c7 7a
    rst 0x0                             ; @@ 0x7a9b c7
    ld bc, 0x7a60                       ; @@ 0x7a9c 01 60 7a
    call 0x7a1f                         ; @@ 0x7a9f cd 1f 7a
    pop de                              ; @@ 0x7aa2 d1
    pop ix                              ; @@ 0x7aa3 dd e1
    call 0x19ae                         ; @@ 0x7aa5 cd ae 19
    call 0x2e1                          ; @@ 0x7aa8 cd e1 02
    call 0x7a70                         ; @@ 0x7aab cd 70 7a
    ld hl, 0x5ae0                       ; @@ 0x7aae 21 e0 5a
    ld bc, (0x880f)                     ; @@ 0x7ab1 ed 4b 0f 88
    call 0x8d0f                         ; @@ 0x7ab5 cd 0f 8d
    ld de, 0x0                          ; @@ 0x7ab8 11 00 00
    ld hl, (0x5c3d)                     ; @@ 0x7abb 2a 3d 5c
    ld (hl), e                          ; @@ 0x7abe 73
    inc hl                              ; @@ 0x7abf 23
    ld (hl), d                          ; @@ 0x7ac0 72
    ld (iy + 0x0), 0xff                 ; @@ 0x7ac1 fd 36 00 ff
    di                                  ; @@ 0x7ac5 f3
    ret                                 ; @@ 0x7ac6 c9
    ld de, 0x7afc                       ; @@ 0x7ac7 11 fc 7a
    ld hl, (0x5c5d)                     ; @@ 0x7aca 2a 5d 5c
    ld iy, 0x5c3a                       ; @@ 0x7acd fd 21 3a 5c
    push hl                             ; @@ 0x7ad1 e5
    ld (0x7af5), sp                     ; @@ 0x7ad2 ed 73 f5 7a
    ld sp, (0x5c3d)                     ; @@ 0x7ad6 ed 7b 3d 5c
    ld hl, 0x7aea                       ; @@ 0x7ada 21 ea 7a
    ex (sp), hl                         ; @@ 0x7add e3
    ld (0x7aed), hl                     ; @@ 0x7ade 22 ed 7a
    im 0x1                              ; @@ 0x7ae1 ed 56
    ei                                  ; @@ 0x7ae3 fb
    ld a, 0x1                           ; @@ 0x7ae4 3e 01
    ex de, hl                           ; @@ 0x7ae6 eb
    jp 0x1bd5                           ; @@ 0x7ae7 c3 d5 1b
    db 0x3b, 0x3b                       ; @@ 0x7aea 3b 3b
    db 0x21, 0x00, 0x00, 0xe3           ; @@ 0x7aec 21 00 00 e3
    db 0x21, 0x76, 0x1b, 0xe5           ; @@ 0x7af0 21 76 1b e5
    db 0x31, 0x00, 0x00, 0xe1           ; @@ 0x7af4 31 00 00 e1
    db 0x22, 0x5d, 0x5c, 0x18           ; @@ 0x7af8 22 5d 5c 18
    db 0xc4, 0xf4, 0x23, 0x32           ; @@ 0x7afc c4 f4 23 32
    db 0x0e, 0x00, 0x00, 0xf7           ; @@ 0x7b00 0e 00 00 f7
    db 0x00, 0x00, 0x2c, 0x37           ; @@ 0x7b04 00 00 2c 37
    db 0x0e, 0x00, 0x00, 0x4f           ; @@ 0x7b08 0e 00 00 4f
    db 0x00, 0x00, 0x3a, 0x3f           ; @@ 0x7b0c 00 00 3a 3f
    db 0xfb, 0x3a, 0xcf, 0x3a           ; @@ 0x7b10 fb 3a cf 3a
    db 0xf2, 0xc3, 0xa7, 0x3a           ; @@ 0x7b14 f2 c3 a7 3a
    db 0x3f                             ; @@ 0x7b18 3f
    push hl                             ; @@ 0x7b19 e5
    call 0x9141                         ; @@ 0x7b1a cd 41 91
    ld hl, 0x4000                       ; @@ 0x7b1d 21 00 40
    ld (0x91b6), hl                     ; @@ 0x7b20 22 b6 91
    pop hl                              ; @@ 0x7b23 e1
    call 0x8b05                         ; @@ 0x7b24 cd 05 8b
    ld hl, 0x7b6e                       ; @@ 0x7b27 21 6e 7b
    jp 0x8b05                           ; @@ 0x7b2a c3 05 8b
    db 0xcd, 0x19, 0x7b                 ; @@ 0x7b2d cd 19 7b
    db 0xcd, 0x36, 0x90, 0xf5           ; @@ 0x7b30 cd 36 90 f5
    db 0x21, 0x00, 0x40, 0x22           ; @@ 0x7b34 21 00 40 22
    db 0xb6, 0x91, 0x21, 0x6e           ; @@ 0x7b38 b6 91 21 6e
    db 0x7b, 0xcd, 0x19, 0x7b           ; @@ 0x7b3c 7b cd 19 7b
    db 0x21, 0x6e, 0x7b, 0xcd           ; @@ 0x7b40 21 6e 7b cd
    db 0x24, 0x7b, 0xf1, 0xfe           ; @@ 0x7b44 24 7b f1 fe
    db 0x70, 0xc8, 0xfe, 0x72           ; @@ 0x7b48 70 c8 fe 72
    db 0xc8, 0xfe, 0x79, 0xc9           ; @@ 0x7b4c c8 fe 79 c9
    db 0x4e, 0x6f, 0x74, 0x20           ; @@ 0x7b50 4e 6f 74 20
    db 0x66, 0x6f, 0x75, 0x6e           ; @@ 0x7b54 66 6f 75 6e
    db 0x64, 0xa0, 0x4f, 0x76           ; @@ 0x7b58 64 a0 4f 76
    db 0x65, 0x72, 0x77, 0x72           ; @@ 0x7b5c 65 72 77 72
    db 0x69, 0x74, 0x65, 0xbf           ; @@ 0x7b60 69 74 65 bf
    db 0x44, 0x69, 0x73, 0x6b           ; @@ 0x7b64 44 69 73 6b
    db 0x20, 0x65, 0x72, 0x72           ; @@ 0x7b68 20 65 72 72
    db 0x6f, 0xf2, 0x20, 0x20           ; @@ 0x7b6c 6f f2 20 20
    db 0x20, 0x20, 0x20, 0x20           ; @@ 0x7b70 20 20 20 20
    db 0x20, 0xa0                       ; @@ 0x7b74 20 a0
