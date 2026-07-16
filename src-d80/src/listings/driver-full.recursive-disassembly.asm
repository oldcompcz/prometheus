
    org 0x7918
    ; @@ 0x7918 Included from binary file '/mnt/data/prometheus_d80_work/disasmtest/full_driver.bin'.
    jp 0x7955                           ; @@ 0x7918 c3 55 79     .instr -- install disk hooks and continue to PROMETHEUS
    ld hl, 0x94e3                       ; @@ 0x791b 21 e3 94     .instr -- restore cassette hooks and continue to PROMETHEUS
    ld (hl), 0x3e                       ; @@ 0x791e 36 3e
    inc hl                              ; @@ 0x7920 23
    ld (hl), 0xc                        ; @@ 0x7921 36 0c
    inc hl                              ; @@ 0x7923 23
    ld (hl), 0xdd                       ; @@ 0x7924 36 dd
    ld hl, 0x9649                       ; @@ 0x7926 21 49 96
    ld (hl), 0xcd                       ; @@ 0x7929 36 cd
    inc hl                              ; @@ 0x792b 23
    ld (hl), 0x54                       ; @@ 0x792c 36 54
    inc hl                              ; @@ 0x792e 23
    ld (hl), 0x9a                       ; @@ 0x792f 36 9a
    ld hl, 0x9675                       ; @@ 0x7931 21 75 96
    ld (hl), 0xcd                       ; @@ 0x7934 36 cd
    inc hl                              ; @@ 0x7936 23
    ld (hl), 0x82                       ; @@ 0x7937 36 82
    inc hl                              ; @@ 0x7939 23
    ld (hl), 0x95                       ; @@ 0x793a 36 95
    ld hl, 0x8049                       ; @@ 0x793c 21 49 80
    ld (hl), 0xcd                       ; @@ 0x793f 36 cd
    inc hl                              ; @@ 0x7941 23
    ld (hl), 0x12                       ; @@ 0x7942 36 12
    inc hl                              ; @@ 0x7944 23
    ld (hl), 0x95                       ; @@ 0x7945 36 95
    ld hl, 0x8071                       ; @@ 0x7947 21 71 80
    ld (hl), 0xcd                       ; @@ 0x794a 36 cd
    inc hl                              ; @@ 0x794c 23
    ld (hl), 0x54                       ; @@ 0x794d 36 54
    inc hl                              ; @@ 0x794f 23
    ld (hl), 0x80                       ; @@ 0x7950 36 80
    jp 0x8fc0                           ; @@ 0x7952 c3 c0 8f
    ld hl, 0x94e3                       ; @@ 0x7955 21 e3 94
    ld (hl), 0xc3                       ; @@ 0x7958 36 c3
    inc hl                              ; @@ 0x795a 23
    ld (hl), 0x11                       ; @@ 0x795b 36 11
    inc hl                              ; @@ 0x795d 23
    ld (hl), 0x7a                       ; @@ 0x795e 36 7a
    ld hl, 0x9649                       ; @@ 0x7960 21 49 96
    ld (hl), 0xc3                       ; @@ 0x7963 36 c3
    inc hl                              ; @@ 0x7965 23
    ld (hl), 0x82                       ; @@ 0x7966 36 82
    inc hl                              ; @@ 0x7968 23
    ld (hl), 0x7a                       ; @@ 0x7969 36 7a
    ld hl, 0x9675                       ; @@ 0x796b 21 75 96
    ld (hl), 0xc3                       ; @@ 0x796e 36 c3
    inc hl                              ; @@ 0x7970 23
    ld (hl), 0x50                       ; @@ 0x7971 36 50
    inc hl                              ; @@ 0x7973 23
    ld (hl), 0x7b                       ; @@ 0x7974 36 7b
    ld hl, 0x8049                       ; @@ 0x7976 21 49 80
    ld (hl), 0xc3                       ; @@ 0x7979 36 c3
    inc hl                              ; @@ 0x797b 23
    ld (hl), 0xc4                       ; @@ 0x797c 36 c4
    inc hl                              ; @@ 0x797e 23
    ld (hl), 0x79                       ; @@ 0x797f 36 79
    ld hl, 0x8071                       ; @@ 0x7981 21 71 80
    ld (hl), 0xc3                       ; @@ 0x7984 36 c3
    inc hl                              ; @@ 0x7986 23
    ld (hl), 0x8f                       ; @@ 0x7987 36 8f
    inc hl                              ; @@ 0x7989 23
    ld (hl), 0x79                       ; @@ 0x798a 36 79
    jp 0x8fc0                           ; @@ 0x798c c3 c0 8f
    xor 0x3a                            ; @@ 0x798f ee 3a        .instr -- patched assembler load entry
    jr z, 0x7999                        ; @@ 0x7991 28 06
    call 0x8054                         ; @@ 0x7993 cd 54 80
    jp 0x8074                           ; @@ 0x7996 c3 74 80
    ld de, 0xa94a                       ; @@ 0x7999 11 4a a9
    inc hl                              ; @@ 0x799c 23
    call 0x9537                         ; @@ 0x799d cd 37 95
    ld hl, 0xa949                       ; @@ 0x79a0 21 49 a9
    call 0x7a60                         ; @@ 0x79a3 cd 60 7a
    ld bc, 0x7b1e                       ; @@ 0x79a6 01 1e 7b
    call 0x7acd                         ; @@ 0x79a9 cd cd 7a
    call 0x7adb                         ; @@ 0x79ac cd db 7a
    ld (0x3e72), hl                     ; @@ 0x79af 22 72 3e
    jp nz, 0x7b1e                       ; @@ 0x79b2 c2 1e 7b
    pop de                              ; @@ 0x79b5 d1
    pop hl                              ; @@ 0x79b6 e1
    or a                                ; @@ 0x79b7 b7
    sbc hl, de                          ; @@ 0x79b8 ed 52
    inc hl                              ; @@ 0x79ba 23
    ex de, hl                           ; @@ 0x79bb eb
    push hl                             ; @@ 0x79bc e5
    pop ix                              ; @@ 0x79bd dd e1
    call 0x19ae                         ; @@ 0x79bf cd ae 19
    jr 0x79f3                           ; @@ 0x79c2 18 2f
    push ix                             ; @@ 0x79c4 dd e5        .instr -- patched assembler save entry
    pop hl                              ; @@ 0x79c6 e1
    call 0x7a60                         ; @@ 0x79c7 cd 60 7a
    ld bc, 0x7b1e                       ; @@ 0x79ca 01 1e 7b
    call 0x7acd                         ; @@ 0x79cd cd cd 7a
    call 0x7adb                         ; @@ 0x79d0 cd db 7a
    jr nz, 0x79de                       ; @@ 0x79d3 20 09
    ld hl, 0x7c15                       ; @@ 0x79d5 21 15 7c
    rst 0x28                            ; @@ 0x79d8 ef
    call m, 0xc279                      ; @@ 0x79d9 fc 79 c2
    ld e, 0x7b                          ; @@ 0x79dc 1e 7b
    ld ix, 0xa949                       ; @@ 0x79de dd 21 49 a9
    call 0x19e1                         ; @@ 0x79e2 cd e1 19
    ld hl, (0xa956)                     ; @@ 0x79e5 2a 56 a9
    ld (0x3e74), hl                     ; @@ 0x79e8 22 74 3e
    ld a, 0x1                           ; @@ 0x79eb 3e 01
    ld (0x3e62), a                      ; @@ 0x79ed 32 62 3e
    call 0x1a00                         ; @@ 0x79f0 cd 00 1a
    call 0x2e1                          ; @@ 0x79f3 cd e1 02
    call 0x7b73                         ; @@ 0x79f6 cd 73 7b
    jp 0x7dec                           ; @@ 0x79f9 c3 ec 7d
    db 0xeb, 0x2a, 0x3b, 0x7c           ; @@ 0x79fc eb 2a 3b 7c
    db 0xcd, 0x0a, 0x7a, 0xeb           ; @@ 0x7a00 cd 0a 7a eb
    db 0xcd, 0xe8, 0x7b, 0x21           ; @@ 0x7a04 cd e8 7b 21
    db 0x00, 0x40, 0x22, 0xd9           ; @@ 0x7a08 00 40 22 d9
    db 0x7b, 0x22, 0xf0, 0x7b           ; @@ 0x7a0c 7b 22 f0 7b
    db 0xc9                             ; @@ 0x7a10 c9
    call 0x7a5c                         ; @@ 0x7a11 cd 5c 7a     .instr -- patched monitor save entry
    pop bc                              ; @@ 0x7a14 c1
    pop hl                              ; @@ 0x7a15 e1
    push hl                             ; @@ 0x7a16 e5
    push bc                             ; @@ 0x7a17 c5
    ld d, 0xff                          ; @@ 0x7a18 16 ff
    ld a, d                             ; @@ 0x7a1a 7a
    xor (hl)                            ; @@ 0x7a1b ae
    ld d, a                             ; @@ 0x7a1c 57
    inc hl                              ; @@ 0x7a1d 23
    dec bc                              ; @@ 0x7a1e 0b
    ld a, b                             ; @@ 0x7a1f 78
    or c                                ; @@ 0x7a20 b1
    jr nz, 0x7a1a                       ; @@ 0x7a21 20 f7
    ld ixh, d                           ; @@ 0x7a23 dd 62
    pop bc                              ; @@ 0x7a25 c1
    pop hl                              ; @@ 0x7a26 e1
    add hl, bc                          ; @@ 0x7a27 09
    dec hl                              ; @@ 0x7a28 2b
    ld de, (0x94f9)                     ; @@ 0x7a29 ed 5b f9 94
    dec de                              ; @@ 0x7a2d 1b
    ld a, 0xff                          ; @@ 0x7a2e 3e ff
    ld (de), a                          ; @@ 0x7a30 12
    dec de                              ; @@ 0x7a31 1b
    ld a, ixh                           ; @@ 0x7a32 dd 7c
    ld (de), a                          ; @@ 0x7a34 12
    dec de                              ; @@ 0x7a35 1b
    push bc                             ; @@ 0x7a36 c5
    ld a, (de)                          ; @@ 0x7a37 1a
    ldd                                 ; @@ 0x7a38 ed a8
    inc hl                              ; @@ 0x7a3a 23
    ld (hl), a                          ; @@ 0x7a3b 77
    dec hl                              ; @@ 0x7a3c 2b
    jp pe, 0x7a37                       ; @@ 0x7a3d ea 37 7a
    inc hl                              ; @@ 0x7a40 23
    inc de                              ; @@ 0x7a41 13
    push hl                             ; @@ 0x7a42 e5
    push de                             ; @@ 0x7a43 d5
    call 0x7ae5                         ; @@ 0x7a44 cd e5 7a
    pop de                              ; @@ 0x7a47 d1
    pop hl                              ; @@ 0x7a48 e1
    pop bc                              ; @@ 0x7a49 c1
    ld a, (de)                          ; @@ 0x7a4a 1a
    ldi                                 ; @@ 0x7a4b ed a0
    dec hl                              ; @@ 0x7a4d 2b
    ld (hl), a                          ; @@ 0x7a4e 77
    inc hl                              ; @@ 0x7a4f 23
    jp pe, 0x7a4a                       ; @@ 0x7a50 ea 4a 7a
    xor a                               ; @@ 0x7a53 af
    ld (de), a                          ; @@ 0x7a54 12
    inc de                              ; @@ 0x7a55 13
    ld a, 0x30                          ; @@ 0x7a56 3e 30
    ld (de), a                          ; @@ 0x7a58 12
    jp 0x9a34                           ; @@ 0x7a59 c3 34 9a
    exx                                 ; @@ 0x7a5c d9
    ld hl, 0x50e0                       ; @@ 0x7a5d 21 e0 50
    ld de, 0xa949                       ; @@ 0x7a60 11 49 a9
    ld bc, 0x11                         ; @@ 0x7a63 01 11 00
    ldir                                ; @@ 0x7a66 ed b0
    ld hl, 0xa953                       ; @@ 0x7a68 21 53 a9
    ld b, 0x9                           ; @@ 0x7a6b 06 09
    ld a, (hl)                          ; @@ 0x7a6d 7e
    cp 0x20                             ; @@ 0x7a6e fe 20
    jr nz, 0x7a77                       ; @@ 0x7a70 20 05
    ld (hl), 0x0                        ; @@ 0x7a72 36 00
    dec hl                              ; @@ 0x7a74 2b
    djnz 0x7a6d                         ; @@ 0x7a75 10 f6
    exx                                 ; @@ 0x7a77 d9
    ret                                 ; @@ 0x7a78 c9
    ld de, 0x7bca                       ; @@ 0x7a79 11 ca 7b
    call 0x7b85                         ; @@ 0x7a7c cd 85 7b
    jp 0x8fc0                           ; @@ 0x7a7f c3 c0 8f
    ld a, (0x954d)                      ; @@ 0x7a82 3a 4d 95     .instr -- patched monitor load entry
    cp 0x21                             ; @@ 0x7a85 fe 21
    jr z, 0x7a79                        ; @@ 0x7a87 28 f0
    ld bc, 0x7b0e                       ; @@ 0x7a89 01 0e 7b
    call 0x7acd                         ; @@ 0x7a8c cd cd 7a
    ld hl, 0x954c                       ; @@ 0x7a8f 21 4c 95
    call 0x7a60                         ; @@ 0x7a92 cd 60 7a
    call 0x7adb                         ; @@ 0x7a95 cd db 7a
    push af                             ; @@ 0x7a98 f5
    ld (0x3e72), hl                     ; @@ 0x7a99 22 72 3e
    ld de, 0x50e0                       ; @@ 0x7a9c 11 e0 50
    ld bc, 0x11                         ; @@ 0x7a9f 01 11 00
    ldir                                ; @@ 0x7aa2 ed b0
    call 0x7b63                         ; @@ 0x7aa4 cd 63 7b
    pop af                              ; @@ 0x7aa7 f1
    jp z, 0x9651                        ; @@ 0x7aa8 ca 51 96
    ld hl, 0x7c0b                       ; @@ 0x7aab 21 0b 7c
    jr 0x7b11                           ; @@ 0x7aae 18 61
    ld hl, 0x3eaa                       ; @@ 0x7ab0 21 aa 3e
    ld de, 0x3e80                       ; @@ 0x7ab3 11 80 3e
    ld bc, 0xa                          ; @@ 0x7ab6 01 0a 00
    ldir                                ; @@ 0x7ab9 ed b0
    ld hl, 0xa94a                       ; @@ 0x7abb 21 4a a9
    ld c, 0xa                           ; @@ 0x7abe 0e 0a
    ldir                                ; @@ 0x7ac0 ed b0
    ld a, 0x42                          ; @@ 0x7ac2 3e 42
    ld (de), a                          ; @@ 0x7ac4 12
    ld a, (0x3e6b)                      ; @@ 0x7ac5 3a 6b 3e
    inc a                               ; @@ 0x7ac8 3c
    ld (0x3e71), a                      ; @@ 0x7ac9 32 71 3e
    ret                                 ; @@ 0x7acc c9
    ld hl, (0x5c3d)                     ; @@ 0x7acd 2a 3d 5c
    ld e, (hl)                          ; @@ 0x7ad0 5e
    inc hl                              ; @@ 0x7ad1 23
    ld d, (hl)                          ; @@ 0x7ad2 56
    ld (0x7b74), de                     ; @@ 0x7ad3 ed 53 74 7b
    ld (hl), b                          ; @@ 0x7ad7 70
    dec hl                              ; @@ 0x7ad8 2b
    ld (hl), c                          ; @@ 0x7ad9 71
    ret                                 ; @@ 0x7ada c9
    call 0x7b82                         ; @@ 0x7adb cd 82 7b
    rst 0x0                             ; @@ 0x7ade c7
    call 0x7ab0                         ; @@ 0x7adf cd b0 7a
    jp 0x212b                           ; @@ 0x7ae2 c3 2b 21
    ld (0x7b01), sp                     ; @@ 0x7ae5 ed 73 01 7b
    push de                             ; @@ 0x7ae9 d5
    ld bc, 0x7b00                       ; @@ 0x7aea 01 00 7b
    call 0x7acd                         ; @@ 0x7aed cd cd 7a
    call 0x7adb                         ; @@ 0x7af0 cd db 7a
    jr nz, 0x7b3b                       ; @@ 0x7af3 20 46
    ld hl, 0x7c15                       ; @@ 0x7af5 21 15 7c
    rst 0x28                            ; @@ 0x7af8 ef
    ret pe                              ; @@ 0x7af9 e8
    ld a, e                             ; @@ 0x7afa 7b
    jr z, 0x7b3b                        ; @@ 0x7afb 28 3e
    pop hl                              ; @@ 0x7afd e1
    jr 0x7b63                           ; @@ 0x7afe 18 63
    db 0x31, 0x00, 0x00, 0x21           ; @@ 0x7b00 31 00 00 21
    db 0x1f, 0x7c, 0xcd, 0xd4           ; @@ 0x7b04 1f 7c cd d4
    db 0x7b, 0xcd, 0x80, 0xa4           ; @@ 0x7b08 7b cd 80 a4
    db 0x18, 0x55, 0x21, 0x1f           ; @@ 0x7b0c 18 55 21 1f
    db 0x7c                             ; @@ 0x7b10 7c
    ld sp, (0x9b67)                     ; @@ 0x7b11 ed 7b 67 9b
    call 0x7bd4                         ; @@ 0x7b15 cd d4 7b
    call 0x7b66                         ; @@ 0x7b18 cd 66 7b
    jp 0x9b66                           ; @@ 0x7b1b c3 66 9b
    call 0x2e1                          ; @@ 0x7b1e cd e1 02
    ld sp, (0x7df1)                     ; @@ 0x7b21 ed 7b f1 7d
    call 0x7b73                         ; @@ 0x7b25 cd 73 7b
    jp 0x853c                           ; @@ 0x7b28 c3 3c 85
    ld hl, 0x50c0                       ; @@ 0x7b2b 21 c0 50
    ld (0xa600), hl                     ; @@ 0x7b2e 22 00 a6
    ld b, 0x20                          ; @@ 0x7b31 06 20
    ld a, 0x7e                          ; @@ 0x7b33 3e 7e
    call 0xa5df                         ; @@ 0x7b35 cd df a5
    djnz 0x7b33                         ; @@ 0x7b38 10 f9
    ret                                 ; @@ 0x7b3a c9
    ld ix, 0xa949                       ; @@ 0x7b3b dd 21 49 a9
    call 0x19e1                         ; @@ 0x7b3f cd e1 19
    pop hl                              ; @@ 0x7b42 e1
    ld (0x3e74), hl                     ; @@ 0x7b43 22 74 3e
    ld a, 0x1                           ; @@ 0x7b46 3e 01
    ld (0x3e62), a                      ; @@ 0x7b48 32 62 3e
    call 0x1a00                         ; @@ 0x7b4b cd 00 1a
    jr 0x7b63                           ; @@ 0x7b4e 18 13
    push ix                             ; @@ 0x7b50 dd e5        .instr -- patched monitor catalogue entry
    push de                             ; @@ 0x7b52 d5
    call 0x7b82                         ; @@ 0x7b53 cd 82 7b
    rst 0x0                             ; @@ 0x7b56 c7
    ld bc, 0x7b0e                       ; @@ 0x7b57 01 0e 7b
    call 0x7acd                         ; @@ 0x7b5a cd cd 7a
    pop de                              ; @@ 0x7b5d d1
    pop ix                              ; @@ 0x7b5e dd e1
    call 0x19ae                         ; @@ 0x7b60 cd ae 19
    call 0x2e1                          ; @@ 0x7b63 cd e1 02
    call 0x7b2b                         ; @@ 0x7b66 cd 2b 7b
    ld hl, 0x5ae0                       ; @@ 0x7b69 21 e0 5a
    ld bc, (0x9c59)                     ; @@ 0x7b6c ed 4b 59 9c
    call 0xa159                         ; @@ 0x7b70 cd 59 a1
    ld de, 0x0                          ; @@ 0x7b73 11 00 00
    ld hl, (0x5c3d)                     ; @@ 0x7b76 2a 3d 5c
    ld (hl), e                          ; @@ 0x7b79 73
    inc hl                              ; @@ 0x7b7a 23
    ld (hl), d                          ; @@ 0x7b7b 72
    ld (iy + 0x0), 0xff                 ; @@ 0x7b7c fd 36 00 ff
    di                                  ; @@ 0x7b80 f3
    ret                                 ; @@ 0x7b81 c9
    ld de, 0x7bb7                       ; @@ 0x7b82 11 b7 7b
    ld hl, (0x5c5d)                     ; @@ 0x7b85 2a 5d 5c
    ld iy, 0x5c3a                       ; @@ 0x7b88 fd 21 3a 5c
    push hl                             ; @@ 0x7b8c e5
    ld (0x7bb0), sp                     ; @@ 0x7b8d ed 73 b0 7b
    ld sp, (0x5c3d)                     ; @@ 0x7b91 ed 7b 3d 5c
    ld hl, 0x7ba5                       ; @@ 0x7b95 21 a5 7b
    ex (sp), hl                         ; @@ 0x7b98 e3
    ld (0x7ba8), hl                     ; @@ 0x7b99 22 a8 7b
    im 0x1                              ; @@ 0x7b9c ed 56
    ei                                  ; @@ 0x7b9e fb
    ld a, 0x1                           ; @@ 0x7b9f 3e 01
    ex de, hl                           ; @@ 0x7ba1 eb
    jp 0x1bd5                           ; @@ 0x7ba2 c3 d5 1b
    db 0x3b, 0x3b, 0x21                 ; @@ 0x7ba5 3b 3b 21
    db 0x00, 0x00, 0xe3, 0x21           ; @@ 0x7ba8 00 00 e3 21
    db 0x76, 0x1b, 0xe5, 0x31           ; @@ 0x7bac 76 1b e5 31
    db 0x00, 0x00, 0xe1, 0x22           ; @@ 0x7bb0 00 00 e1 22
    db 0x5d, 0x5c, 0x18, 0xc4           ; @@ 0x7bb4 5d 5c 18 c4
    db 0xf4, 0x23, 0x32, 0x0e           ; @@ 0x7bb8 f4 23 32 0e
    db 0x00, 0x00, 0xf7, 0x00           ; @@ 0x7bbc 00 00 f7 00
    db 0x00, 0x2c, 0x37, 0x0e           ; @@ 0x7bc0 00 2c 37 0e
    db 0x00, 0x00, 0x4f, 0x00           ; @@ 0x7bc4 00 00 4f 00
    db 0x00, 0x3a, 0x3f, 0xfb           ; @@ 0x7bc8 00 3a 3f fb
    db 0x3a, 0xcf, 0x3a, 0xf2           ; @@ 0x7bcc 3a cf 3a f2
    db 0xc3, 0xa7, 0x3a, 0x3f           ; @@ 0x7bd0 c3 a7 3a 3f
    push hl                             ; @@ 0x7bd4 e5
    call 0xa58b                         ; @@ 0x7bd5 cd 8b a5
    ld hl, 0x4000                       ; @@ 0x7bd8 21 00 40
    ld (0xa600), hl                     ; @@ 0x7bdb 22 00 a6
    pop hl                              ; @@ 0x7bde e1
    call 0x9f4f                         ; @@ 0x7bdf cd 4f 9f
    ld hl, 0x7c29                       ; @@ 0x7be2 21 29 7c
    jp 0x9f4f                           ; @@ 0x7be5 c3 4f 9f
    db 0xcd, 0xd4, 0x7b, 0xcd           ; @@ 0x7be8 cd d4 7b cd
    db 0x80, 0xa4, 0xf5, 0x21           ; @@ 0x7bec 80 a4 f5 21
    db 0x00, 0x40, 0x22, 0x00           ; @@ 0x7bf0 00 40 22 00
    db 0xa6, 0x21, 0x29, 0x7c           ; @@ 0x7bf4 a6 21 29 7c
    db 0xcd, 0xd4, 0x7b, 0x21           ; @@ 0x7bf8 cd d4 7b 21
    db 0x29, 0x7c, 0xcd, 0xdf           ; @@ 0x7bfc 29 7c cd df
    db 0x7b, 0xf1, 0xfe, 0x70           ; @@ 0x7c00 7b f1 fe 70
    db 0xc8, 0xfe, 0x72, 0xc8           ; @@ 0x7c04 c8 fe 72 c8
    db 0xfe, 0x79, 0xc9, 0x4e           ; @@ 0x7c08 fe 79 c9 4e
    db 0x6f, 0x74, 0x20, 0x66           ; @@ 0x7c0c 6f 74 20 66
    db 0x6f, 0x75, 0x6e, 0x64           ; @@ 0x7c10 6f 75 6e 64
    db 0xa0, 0x4f, 0x76, 0x65           ; @@ 0x7c14 a0 4f 76 65
    db 0x72, 0x77, 0x72, 0x69           ; @@ 0x7c18 72 77 72 69
    db 0x74, 0x65, 0xbf, 0x44           ; @@ 0x7c1c 74 65 bf 44
    db 0x69, 0x73, 0x6b, 0x20           ; @@ 0x7c20 69 73 6b 20
    db 0x65, 0x72, 0x72, 0x6f           ; @@ 0x7c24 65 72 72 6f
    db 0xf2, 0x20, 0x20, 0x20           ; @@ 0x7c28 f2 20 20 20
    db 0x20, 0x20, 0x20, 0x20           ; @@ 0x7c2c 20 20 20 20
    db 0xa0, 0x00, 0x00, 0x00           ; @@ 0x7c30 a0 00 00 00
    db 0x00, 0x00, 0x00, 0x00           ; @@ 0x7c34 00 00 00 00
