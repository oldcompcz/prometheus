; z80dasm 1.1.3
; command line: z80dasm -a -t -l -g 24000 -b blocks.txt prometheus.bin

	org	05dc0h

	di			;5dc0	f3 	. 
	ld hl,04000h		;5dc1	21 00 40 	! . @ 
	ld de,04001h		;5dc4	11 01 40 	. . @ 
	ld bc,00fffh		;5dc7	01 ff 0f 	. . . 
	ld (hl),l			;5dca	75 	u 
	ldir		;5dcb	ed b0 	. . 
	call 00052h		;5dcd	cd 52 00 	. R . 
	dec sp			;5dd0	3b 	; 
	dec sp			;5dd1	3b 	; 
	pop bc			;5dd2	c1 	. 
	ld hl,0fff0h		;5dd3	21 f0 ff 	! . . 
	add hl,bc			;5dd6	09 	. 
	ld sp,04020h		;5dd7	31 20 40 	1   @ 
	push hl			;5dda	e5 	. 
	ld hl,00017h		;5ddb	21 17 00 	! . . 
	add hl,bc			;5dde	09 	. 
	ld bc,007cdh		;5ddf	01 cd 07 	. . . 
	ldir		;5de2	ed b0 	. . 
	jp 05000h		;5de4	c3 00 50 	. . P 
	ld de,04026h		;5de7	11 26 40 	. & @ 
	call 05342h		;5dea	cd 42 53 	. B S 
	ld e,046h		;5ded	1e 46 	. F 
	call 05342h		;5def	cd 42 53 	. B S 
	ex (sp),hl			;5df2	e3 	. 
	ld bc,050a1h		;5df3	01 a1 50 	. . P 
	ld de,02710h		;5df6	11 10 27 	. . ' 
	call 052b4h		;5df9	cd b4 52 	. . R 
	ld de,003e8h		;5dfc	11 e8 03 	. . . 
	call 052b4h		;5dff	cd b4 52 	. . R 
	ld de,00064h		;5e02	11 64 00 	. d . 
	call 052b4h		;5e05	cd b4 52 	. . R 
	ld e,00ah		;5e08	1e 0a 	. . 
	call 052b4h		;5e0a	cd b4 52 	. . R 
	ld e,001h		;5e0d	1e 01 	. . 
	call 052b4h		;5e0f	cd b4 52 	. . R 
	ld hl,04082h		;5e12	21 82 40 	! . @ 
	call 052e6h		;5e15	cd e6 52 	. . R 

; BLOCK 'intro1_string' (start 0x5e18 end 0x5e34)
intro1_string_start:
	defb 053h		;5e18	53 	S 
	defb 070h		;5e19	70 	p 
	defb 065h		;5e1a	65 	e 
	defb 063h		;5e1b	63 	c 
	defb 074h		;5e1c	74 	t 
	defb 072h		;5e1d	72 	r 
	defb 075h		;5e1e	75 	u 
	defb 06dh		;5e1f	6d 	m 
	defb 020h		;5e20	20 	  
	defb 05ah		;5e21	5a 	Z 
	defb 038h		;5e22	38 	8 
	defb 030h		;5e23	30 	0 
	defb 020h		;5e24	20 	  
	defb 054h		;5e25	54 	T 
	defb 075h		;5e26	75 	u 
	defb 072h		;5e27	72 	r 
	defb 062h		;5e28	62 	b 
	defb 06fh		;5e29	6f 	o 
	defb 020h		;5e2a	20 	  
	defb 041h		;5e2b	41 	A 
	defb 073h		;5e2c	73 	s 
	defb 073h		;5e2d	73 	s 
	defb 065h		;5e2e	65 	e 
	defb 06dh		;5e2f	6d 	m 
	defb 062h		;5e30	62 	b 
	defb 06ch		;5e31	6c 	l 
	defb 065h		;5e32	65 	e 
	defb 0f2h		;5e33	f2 	. 
intro1_string_end:
	ld hl,040c7h		;5e34	21 c7 40 	! . @ 
	call 052e6h		;5e37	cd e6 52 	. . R 

; BLOCK 'intro2_string' (start 0x5e3a end 0x5e4c)
intro2_string_start:
	defb 028h		;5e3a	28 	( 
	defb 043h		;5e3b	43 	C 
	defb 029h		;5e3c	29 	) 
	defb 020h		;5e3d	20 	  
	defb 031h		;5e3e	31 	1 
	defb 039h		;5e3f	39 	9 
	defb 039h		;5e40	39 	9 
	defb 030h		;5e41	30 	0 
	defb 020h		;5e42	20 	  
	defb 055h		;5e43	55 	U 
	defb 04eh		;5e44	4e 	N 
	defb 049h		;5e45	49 	I 
	defb 056h		;5e46	56 	V 
	defb 045h		;5e47	45 	E 
	defb 052h		;5e48	52 	R 
	defb 053h		;5e49	53 	S 
	defb 055h		;5e4a	55 	U 
	defb 0cdh		;5e4b	cd 	. 
intro2_string_end:
	ld hl,048e2h		;5e4c	21 e2 48 	! . H 
	call 052e6h		;5e4f	cd e6 52 	. . R 

; BLOCK 'intro3_string' (start 0x5e52 end 0x5e6e)
intro3_string_start:
	defb 050h		;5e52	50 	P 
	defb 072h		;5e53	72 	r 
	defb 065h		;5e54	65 	e 
	defb 073h		;5e55	73 	s 
	defb 073h		;5e56	73 	s 
	defb 020h		;5e57	20 	  
	defb 045h		;5e58	45 	E 
	defb 04eh		;5e59	4e 	N 
	defb 054h		;5e5a	54 	T 
	defb 045h		;5e5b	45 	E 
	defb 052h		;5e5c	52 	R 
	defb 020h		;5e5d	20 	  
	defb 074h		;5e5e	74 	t 
	defb 06fh		;5e5f	6f 	o 
	defb 020h		;5e60	20 	  
	defb 072h		;5e61	72 	r 
	defb 075h		;5e62	75 	u 
	defb 06eh		;5e63	6e 	n 
	defb 020h		;5e64	20 	  
	defb 041h		;5e65	41 	A 
	defb 073h		;5e66	73 	s 
	defb 073h		;5e67	73 	s 
	defb 065h		;5e68	65 	e 
	defb 06dh		;5e69	6d 	m 
	defb 062h		;5e6a	62 	b 
	defb 06ch		;5e6b	6c 	l 
	defb 065h		;5e6c	65 	e 
	defb 0f2h		;5e6d	f2 	. 
intro3_string_end:
	ld hl,04883h		;5e6e	21 83 48 	! . H 
	call 052e6h		;5e71	cd e6 52 	. . R 

; BLOCK 'intro4_string' (start 0x5e74 end 0x5e8f)
intro4_string_start:
	defb 049h		;5e74	49 	I 
	defb 06eh		;5e75	6e 	n 
	defb 073h		;5e76	73 	s 
	defb 074h		;5e77	74 	t 
	defb 061h		;5e78	61 	a 
	defb 06ch		;5e79	6c 	l 
	defb 061h		;5e7a	61 	a 
	defb 074h		;5e7b	74 	t 
	defb 069h		;5e7c	69 	i 
	defb 06fh		;5e7d	6f 	o 
	defb 06eh		;5e7e	6e 	n 
	defb 020h		;5e7f	20 	  
	defb 061h		;5e80	61 	a 
	defb 064h		;5e81	64 	d 
	defb 064h		;5e82	64 	d 
	defb 072h		;5e83	72 	r 
	defb 065h		;5e84	65 	e 
	defb 073h		;5e85	73 	s 
	defb 073h		;5e86	73 	s 
	defb 03ah		;5e87	3a 	: 
	defb 030h		;5e88	30 	0 
	defb 030h		;5e89	30 	0 
	defb 030h		;5e8a	30 	0 
	defb 030h		;5e8b	30 	0 
	defb 030h		;5e8c	30 	0 
	defb 05fh		;5e8d	5f 	_ 
	defb 0a0h		;5e8e	a0 	. 
intro4_string_end:
	ld hl,0484bh		;5e8f	21 4b 48 	! K H 
	call 052e6h		;5e92	cd e6 52 	. . R 

; BLOCK 'intro5_string' (start 0x5e95 end 0x5e9d)
intro5_string_start:
	defb 04dh		;5e95	4d 	M 
	defb 06fh		;5e96	6f 	o 
	defb 06eh		;5e97	6e 	n 
	defb 069h		;5e98	69 	i 
	defb 074h		;5e99	74 	t 
	defb 06fh		;5e9a	6f 	o 
	defb 072h		;5e9b	72 	r 
	defb 0bah		;5e9c	ba 	. 
intro5_string_end:
	ld a,04dh		;5e9d	3e 4d 	> M 
	or a			;5e9f	b7 	. 
	ld hl,04853h		;5ea0	21 53 48 	! S H 
	jr z,l5eadh		;5ea3	28 08 	( . 
	call 052e6h		;5ea5	cd e6 52 	. . R 

; BLOCK 'intro_yes_string' (start 0x5ea8 end 0x5eab)
intro_yes_string_start:
	defb 059h		;5ea8	59 	Y 
	defb 065h		;5ea9	65 	e 
	defb 0f3h		;5eaa	f3 	. 
intro_yes_string_end:
	jr intro_no_string_end		;5eab	18 06 	. . 
l5eadh:
	call 052e6h		;5ead	cd e6 52 	. . R 

; BLOCK 'intro_no_string' (start 0x5eb0 end 0x5eb3)
intro_no_string_start:
	defb 04eh		;5eb0	4e 	N 
	defb 06fh		;5eb1	6f 	o 
	defb 0a0h		;5eb2	a0 	. 
intro_no_string_end:
	ld hl,05800h		;5eb3	21 00 58 	! . X 
	ld de,05801h		;5eb6	11 01 58 	. . X 
	ld bc,00020h		;5eb9	01 20 00 	.   . 
	ld (hl),l			;5ebc	75 	u 
	ldir		;5ebd	ed b0 	. . 
	ld c,020h		;5ebf	0e 20 	.   
	ld (hl),006h		;5ec1	36 06 	6 . 
	ldir		;5ec3	ed b0 	. . 
	ld c,020h		;5ec5	0e 20 	.   
	ld (hl),046h		;5ec7	36 46 	6 F 
	ldir		;5ec9	ed b0 	. . 
	ld c,0a0h		;5ecb	0e a0 	. . 
	ld (hl),007h		;5ecd	36 07 	6 . 
	ldir		;5ecf	ed b0 	. . 
	ld bc,000e0h		;5ed1	01 e0 00 	. . . 
	ld (hl),038h		;5ed4	36 38 	6 8 
	ld a,(hl)			;5ed6	7e 	~ 
	ldir		;5ed7	ed b0 	. . 
	ld (hl),030h		;5ed9	36 30 	6 0 
	ld bc,00020h		;5edb	01 20 00 	.   . 
	ldir		;5ede	ed b0 	. . 
	call 052dch		;5ee0	cd dc 52 	. . R 
	ld b,001h		;5ee3	06 01 	. . 
	ld (hl),a			;5ee5	77 	w 
	ldir		;5ee6	ed b0 	. . 
	ld e,00ah		;5ee8	1e 0a 	. . 
	ld hl,0012ch		;5eea	21 2c 01 	! , . 
	ld a,(050eeh)		;5eed	3a ee 50 	: . P 
	rrca			;5ef0	0f 	. 
	rrca			;5ef1	0f 	. 
	rrca			;5ef2	0f 	. 
l5ef3h:
	ld b,e			;5ef3	43 	C 
	xor 010h		;5ef4	ee 10 	. . 
l5ef6h:
	out (0feh),a		;5ef6	d3 fe 	. . 
	djnz l5ef6h		;5ef8	10 fc 	. . 
	dec hl			;5efa	2b 	+ 
	inc h			;5efb	24 	$ 
	dec h			;5efc	25 	% 
	jr nz,l5ef3h		;5efd	20 f4 	  . 
	ld h,080h		;5eff	26 80 	& . 
l5f01h:
	inc hl			;5f01	23 	# 
	inc h			;5f02	24 	$ 
	dec h			;5f03	25 	% 
	jr nz,l5f01h		;5f04	20 fb 	  . 
l5f06h:
	call 0028eh		;5f06	cd 8e 02 	. . . 
	jr nz,l5f06h		;5f09	20 fb 	  . 
	call 0031eh		;5f0b	cd 1e 03 	. . . 
	jr nc,l5f06h		;5f0e	30 f6 	0 . 
	ld e,a			;5f10	5f 	_ 
	inc b			;5f11	04 	. 
	jr z,l5f16h		;5f12	28 02 	( . 
	add a,080h		;5f14	c6 80 	. . 
l5f16h:
	ld hl,0502bh		;5f16	21 2b 50 	! + P 
	push hl			;5f19	e5 	. 
	cp 049h		;5f1a	fe 49 	. I 
	ld hl,050eeh		;5f1c	21 ee 50 	! . P 
l5f1fh:
	ld de,00107h		;5f1f	11 07 01 	. . . 
	jr nz,l5f2eh		;5f22	20 0a 	  . 
l5f24h:
	ld a,e			;5f24	7b 	{ 
	cpl			;5f25	2f 	/ 
	and (hl)			;5f26	a6 	. 
	ld c,a			;5f27	4f 	O 
	ld a,(hl)			;5f28	7e 	~ 
	add a,d			;5f29	82 	. 
	and e			;5f2a	a3 	. 
	or c			;5f2b	b1 	. 
	ld (hl),a			;5f2c	77 	w 
	ret			;5f2d	c9 	. 
l5f2eh:
	cp 050h		;5f2e	fe 50 	. P 
l5f30h:
	ld de,00838h		;5f30	11 38 08 	. 8 . 
	jr z,l5f24h		;5f33	28 ef 	( . 
	cp 042h		;5f35	fe 42 	. B 
l5f37h:
	ld de,04040h		;5f37	11 40 40 	. @ @ 
	jr z,l5f24h		;5f3a	28 e8 	( . 
	ld hl,050f3h		;5f3c	21 f3 50 	! . P 
	cp 0c9h		;5f3f	fe c9 	. . 
	jr z,l5f1fh		;5f41	28 dc 	( . 
	cp 0d0h		;5f43	fe d0 	. . 
	jr z,l5f30h		;5f45	28 e9 	( . 
	cp 0c2h		;5f47	fe c2 	. . 
	jr z,l5f37h		;5f49	28 ec 	( . 
	cp 044h		;5f4b	fe 44 	. D 
	jr nz,l5f57h		;5f4d	20 08 	  . 
	ld hl,05309h		;5f4f	21 09 53 	! . S 
	ld a,00fh		;5f52	3e 0f 	> . 
l5f54h:
	xor (hl)			;5f54	ae 	. 
	ld (hl),a			;5f55	77 	w 
	ret			;5f56	c9 	. 
l5f57h:
	cp 04dh		;5f57	fe 4d 	. M 
	ld hl,050b7h		;5f59	21 b7 50 	! . P 
	jr z,l5f54h		;5f5c	28 f6 	( . 
	cp 058h		;5f5e	fe 58 	. X 
	ld hl,05102h		;5f60	21 02 51 	! . Q 
	ld de,0013fh		;5f63	11 3f 01 	. ? . 
	jr z,l5f24h		;5f66	28 bc 	( . 
	ld d,0ffh		;5f68	16 ff 	. . 
	cp 0d8h		;5f6a	fe d8 	. . 
	jr z,l5f24h		;5f6c	28 b6 	( . 
	cp 043h		;5f6e	fe 43 	. C 
	jr nz,l5f93h		;5f70	20 21 	  ! 
	ld a,000h		;5f72	3e 00 	> . 
	inc a			;5f74	3c 	< 
	cp 003h		;5f75	fe 03 	. . 
	jr nz,l5f7ah		;5f77	20 01 	  . 
	xor a			;5f79	af 	. 
l5f7ah:
	ld (0518ch),a		;5f7a	32 8c 51 	2 . Q 
	add a,a			;5f7d	87 	. 
	ld hl,051a6h		;5f7e	21 a6 51 	! . Q 
	ld b,000h		;5f81	06 00 	. . 
	ld c,a			;5f83	4f 	O 
	add hl,bc			;5f84	09 	. 
	ld e,(hl)			;5f85	5e 	^ 
	inc hl			;5f86	23 	# 
	ld d,(hl)			;5f87	56 	V 
	ex de,hl			;5f88	eb 	. 
	ld (052fah),hl		;5f89	22 fa 52 	" . R 
	ret			;5f8c	c9 	. 
	and 0ffh		;5f8d	e6 ff 	. . 
	or 020h		;5f8f	f6 20 	.   
	and 0dfh		;5f91	e6 df 	. . 
l5f93h:
	ld hl,050a6h		;5f93	21 a6 50 	! . P 
	cp 0b0h		;5f96	fe b0 	. . 
	jr nz,l5fa9h		;5f98	20 0f 	  . 
	dec hl			;5f9a	2b 	+ 
	ld a,(hl)			;5f9b	7e 	~ 
	cp 03ah		;5f9c	fe 3a 	. : 
	ret z			;5f9e	c8 	. 
	inc hl			;5f9f	23 	# 
	ld (hl),020h		;5fa0	36 20 	6   
	dec hl			;5fa2	2b 	+ 
l5fa3h:
	ld (hl),05fh		;5fa3	36 5f 	6 _ 
	ld (051adh),hl		;5fa5	22 ad 51 	" . Q 
	ret			;5fa8	c9 	. 
l5fa9h:
	cp 030h		;5fa9	fe 30 	. 0 
	jr c,l5fbah		;5fab	38 0d 	8 . 
	cp 03ah		;5fad	fe 3a 	. : 
	jr nc,l5fbah		;5faf	30 09 	0 . 
	inc hl			;5fb1	23 	# 
	bit 7,(hl)		;5fb2	cb 7e 	. ~ 
	ret nz			;5fb4	c0 	. 
	dec hl			;5fb5	2b 	+ 
	ld (hl),a			;5fb6	77 	w 
	inc hl			;5fb7	23 	# 
	jr l5fa3h		;5fb8	18 e9 	. . 
l5fbah:
	cp 00dh		;5fba	fe 0d 	. . 
	ret nz			;5fbc	c0 	. 
	pop af			;5fbd	f1 	. 
	pop hl			;5fbe	e1 	. 
	push hl			;5fbf	e5 	. 
	ld (05227h),sp		;5fc0	ed 73 27 52 	. s ' R 
	ld sp,052c0h		;5fc4	31 c0 52 	1 . R 
	call 052afh		;5fc7	cd af 52 	. . R 
	ld a,(05309h)		;5fca	3a 09 53 	: . S 
	call 052aeh		;5fcd	cd ae 52 	. . R 
	ld de,(052fah)		;5fd0	ed 5b fa 52 	. [ . R 
	ld (hl),e			;5fd4	73 	s 
	inc hl			;5fd5	23 	# 
	ld (hl),d			;5fd6	72 	r 
	dec hl			;5fd7	2b 	+ 
	call 052afh		;5fd8	cd af 52 	. . R 
	ld a,(05102h)		;5fdb	3a 02 51 	: . Q 
	call 052aeh		;5fde	cd ae 52 	. . R 
	ld a,(050eeh)		;5fe1	3a ee 50 	: . P 
	call 052aeh		;5fe4	cd ae 52 	. . R 
	call 052aeh		;5fe7	cd ae 52 	. . R 
	call 052aeh		;5fea	cd ae 52 	. . R 
	xor 001h		;5fed	ee 01 	. . 
	call 052aeh		;5fef	cd ae 52 	. . R 
	call 052aeh		;5ff2	cd ae 52 	. . R 
	call 052dch		;5ff5	cd dc 52 	. . R 
	call 052aeh		;5ff8	cd ae 52 	. . R 
	and 007h		;5ffb	e6 07 	. . 
	call 052aeh		;5ffd	cd ae 52 	. . R 
	call 052aeh		;6000	cd ae 52 	. . R 
	ld a,(050f3h)		;6003	3a f3 50 	: . P 
	call 052aeh		;6006	cd ae 52 	. . R 
	call 052aeh		;6009	cd ae 52 	. . R 
	ld (hl),a			;600c	77 	w 
	ld sp,00000h		;600d	31 00 00 	1 . . 
	ld hl,00000h		;6010	21 00 00 	! . . 
	ld de,050a1h		;6013	11 a1 50 	. . P 
l6016h:
	ld a,(de)			;6016	1a 	. 
	inc de			;6017	13 	. 
	cp 05fh		;6018	fe 5f 	. _ 
	jr z,l602ah		;601a	28 0e 	( . 
	add hl,hl			;601c	29 	) 
	push hl			;601d	e5 	. 
	add hl,hl			;601e	29 	) 
	add hl,hl			;601f	29 	) 
	pop bc			;6020	c1 	. 
	add hl,bc			;6021	09 	. 
	sub 030h		;6022	d6 30 	. 0 
	ld c,a			;6024	4f 	O 
	ld b,000h		;6025	06 00 	. . 
	add hl,bc			;6027	09 	. 
	jr l6016h		;6028	18 ec 	. . 
l602ah:
	pop de			;602a	d1 	. 
	ex de,hl			;602b	eb 	. 
	ld a,(050b7h)		;602c	3a b7 50 	: . P 
	rrca			;602f	0f 	. 
	push af			;6030	f5 	. 
	ld bc,03e80h		;6031	01 80 3e 	. . > 
	jr c,l604eh		;6034	38 18 	8 . 
	push hl			;6036	e5 	. 
	push de			;6037	d5 	. 
	ld bc,01b72h		;6038	01 72 1b 	. r . 
	add hl,bc			;603b	09 	. 
	ld e,(hl)			;603c	5e 	^ 
	inc hl			;603d	23 	# 
	ld d,(hl)			;603e	56 	V 
	ex de,hl			;603f	eb 	. 
	ld bc,01388h		;6040	01 88 13 	. . . 
	add hl,bc			;6043	09 	. 
	ex de,hl			;6044	eb 	. 
	ld (hl),d			;6045	72 	r 
	dec hl			;6046	2b 	+ 
	ld (hl),e			;6047	73 	s 
	pop de			;6048	d1 	. 
	pop hl			;6049	e1 	. 
	add hl,bc			;604a	09 	. 
	ld bc,02af8h		;604b	01 f8 2a 	. . * 
l604eh:
	push de			;604e	d5 	. 
	push hl			;604f	e5 	. 
	xor a			;6050	af 	. 
	sbc hl,de		;6051	ed 52 	. R 
	pop hl			;6053	e1 	. 
	jr c,l605ah		;6054	38 04 	8 . 
	ldir		;6056	ed b0 	. . 
	jr l6062h		;6058	18 08 	. . 
l605ah:
	add hl,bc			;605a	09 	. 
	dec hl			;605b	2b 	+ 
	ex de,hl			;605c	eb 	. 
	add hl,bc			;605d	09 	. 
	dec hl			;605e	2b 	+ 
	ex de,hl			;605f	eb 	. 
	lddr		;6060	ed b8 	. . 
l6062h:
	pop bc			;6062	c1 	. 
	ld d,b			;6063	50 	P 
	ld e,c			;6064	59 	Y 
	pop af			;6065	f1 	. 
	push bc			;6066	c5 	. 
	push af			;6067	f5 	. 
	jr nc,l6077h		;6068	30 0d 	0 . 
	ld hl,05353h		;606a	21 53 53 	! S S 
	call 0531ch		;606d	cd 1c 53 	. . S 
	ld hl,001c8h		;6070	21 c8 01 	! . . 
	add hl,de			;6073	19 	. 
	ex de,hl			;6074	eb 	. 
	jr l607dh		;6075	18 06 	. . 
l6077h:
	ld hl,0ec78h		;6077	21 78 ec 	! x . 
	add hl,bc			;607a	09 	. 
	ld b,h			;607b	44 	D 
	ld c,l			;607c	4d 	M 
l607dh:
	ld hl,05547h		;607d	21 47 55 	! G U 
	call 0531ch		;6080	cd 1c 53 	. . S 
	ld hl,0f136h		;6083	21 36 f1 	! 6 . 
	add hl,de			;6086	19 	. 
	pop af			;6087	f1 	. 
	pop bc			;6088	c1 	. 
	jr c,l608eh		;6089	38 03 	8 . 
	ld (hl),c			;608b	71 	q 
	inc hl			;608c	23 	# 
	ld (hl),b			;608d	70 	p 
l608eh:
	ld hl,00104h		;608e	21 04 01 	! . . 
	add hl,de			;6091	19 	. 
	ld sp,hl			;6092	f9 	. 
	push bc			;6093	c5 	. 
	ret			;6094	c9 	. 
	ld (hl),a			;6095	77 	w 
	pop bc			;6096	c1 	. 
	pop de			;6097	d1 	. 
	add hl,de			;6098	19 	. 
	push bc			;6099	c5 	. 
l609ah:
	ret			;609a	c9 	. 
	ld a,02fh		;609b	3e 2f 	> / 
l609dh:
	inc a			;609d	3c 	< 
	and a			;609e	a7 	. 
	sbc hl,de		;609f	ed 52 	. R 
	jr nc,l609dh		;60a1	30 fa 	0 . 
	add hl,de			;60a3	19 	. 
	ld (bc),a			;60a4	02 	. 
	inc bc			;60a5	03 	. 
	ret			;60a6	c9 	. 
	adc a,029h		;60a7	ce 29 	. ) 
	inc (hl)			;60a9	34 	4 
	ei			;60aa	fb 	. 
	ld c,(hl)			;60ab	4e 	N 
	inc b			;60ac	04 	. 
	cp h			;60ad	bc 	. 
	push hl			;60ae	e5 	. 
	sbc a,b			;60af	98 	. 
	rlca			;60b0	07 	. 
	jr l60c6h		;60b1	18 13 	. . 
	djnz l609ah		;60b3	10 e5 	. . 
	ld c,000h		;60b5	0e 00 	. . 
	ld b,a			;60b7	47 	G 
	ld de,00938h		;60b8	11 38 09 	. 8 . 
	ret pe			;60bb	e8 	. 
	ret p			;60bc	f0 	. 
	jp nc,l9404h		;60bd	d2 04 94 	. . . 
	rst 30h			;60c0	f7 	. 
	ld e,l			;60c1	5d 	] 
	ret m			;60c2	f8 	. 
	and 0f8h		;60c3	e6 f8 	. . 
	ld b,a			;60c5	47 	G 
l60c6h:
	rrca			;60c6	0f 	. 
	rrca			;60c7	0f 	. 
	rrca			;60c8	0f 	. 
	and 007h		;60c9	e6 07 	. . 
	or b			;60cb	b0 	. 
	ret			;60cc	c9 	. 
	ld (05303h),hl		;60cd	22 03 53 	" . S 
	pop hl			;60d0	e1 	. 
l60d1h:
	ld a,(hl)			;60d1	7e 	~ 
	and 07fh		;60d2	e6 7f 	.  
	exx			;60d4	d9 	. 
	cp 041h		;60d5	fe 41 	. A 
	jr c,l60e3h		;60d7	38 0a 	8 . 
	cp 05bh		;60d9	fe 5b 	. [ 
	jr c,l60e1h		;60db	38 04 	8 . 
	cp 061h		;60dd	fe 61 	. a 
	jr c,l60e3h		;60df	38 02 	8 . 
l60e1h:
	and 0ffh		;60e1	e6 ff 	. . 
l60e3h:
	add a,a			;60e3	87 	. 
	ld h,00fh		;60e4	26 0f 	& . 
	ld l,a			;60e6	6f 	o 
	add hl,hl			;60e7	29 	) 
	add hl,hl			;60e8	29 	) 
	ld de,04000h		;60e9	11 00 40 	. . @ 
	push de			;60ec	d5 	. 
	ld b,008h		;60ed	06 08 	. . 
l60efh:
	ld a,(hl)			;60ef	7e 	~ 
	nop			;60f0	00 	. 
	or (hl)			;60f1	b6 	. 
	ld (de),a			;60f2	12 	. 
	inc hl			;60f3	23 	# 
	inc d			;60f4	14 	. 
	djnz l60efh		;60f5	10 f8 	. . 
	pop hl			;60f7	e1 	. 
	inc l			;60f8	2c 	, 
	ld (05303h),hl		;60f9	22 03 53 	" . S 
	exx			;60fc	d9 	. 
	ld a,(hl)			;60fd	7e 	~ 
	inc hl			;60fe	23 	# 
	rlca			;60ff	07 	. 
	jr nc,l60d1h		;6100	30 cf 	0 . 
	jp (hl)			;6102	e9 	. 
l6103h:
	ld a,(hl)			;6103	7e 	~ 
	or a			;6104	b7 	. 
	ret z			;6105	c8 	. 
	ld (hl),001h		;6106	36 01 	6 . 
	cp 0c8h		;6108	fe c8 	. . 
	jr c,l610fh		;610a	38 03 	8 . 
	sub 0c8h		;610c	d6 c8 	. . 
	inc hl			;610e	23 	# 
l610fh:
	push af			;610f	f5 	. 
	add a,e			;6110	83 	. 
	ld e,a			;6111	5f 	_ 
	jr nc,l6115h		;6112	30 01 	0 . 
	inc d			;6114	14 	. 
l6115h:
	pop af			;6115	f1 	. 
	push hl			;6116	e5 	. 
	ex de,hl			;6117	eb 	. 
	ld e,(hl)			;6118	5e 	^ 
	inc hl			;6119	23 	# 
	ld d,(hl)			;611a	56 	V 
	ex de,hl			;611b	eb 	. 
	add hl,bc			;611c	09 	. 
	ex de,hl			;611d	eb 	. 
	ld (hl),d			;611e	72 	r 
	dec hl			;611f	2b 	+ 
	ld (hl),e			;6120	73 	s 
	ex de,hl			;6121	eb 	. 
	pop hl			;6122	e1 	. 
	dec (hl)			;6123	35 	5 
	jr nz,l610fh		;6124	20 e9 	  . 
	inc hl			;6126	23 	# 
	jr l6103h		;6127	18 da 	. . 
	ld c,014h		;6129	0e 14 	. . 
l612bh:
	ld b,008h		;612b	06 08 	. . 
	push de			;612d	d5 	. 
l612eh:
	ld a,(hl)			;612e	7e 	~ 
	ld (de),a			;612f	12 	. 
	inc hl			;6130	23 	# 
	inc d			;6131	14 	. 
	djnz l612eh		;6132	10 fa 	. . 
	pop de			;6134	d1 	. 
	inc e			;6135	1c 	. 
	dec c			;6136	0d 	. 
	jr nz,l612bh		;6137	20 f2 	  . 
	ret			;6139	c9 	. 

; BLOCK 'data_613a' (start 0x613a end 0x65b3)
data_613a_start:
	defb 001h		;613a	01 	. 
	defb 023h		;613b	23 	# 
	defb 0cfh		;613c	cf 	. 
	defb 01dh		;613d	1d 	. 
	defb 0b6h		;613e	b6 	. 
	defb 00ah		;613f	0a 	. 
	defb 007h		;6140	07 	. 
	defb 0cbh		;6141	cb 	. 
	defb 003h		;6142	03 	. 
	defb 006h		;6143	06 	. 
	defb 00ah		;6144	0a 	. 
	defb 00bh		;6145	0b 	. 
	defb 005h		;6146	05 	. 
	defb 0cbh		;6147	cb 	. 
	defb 009h		;6148	09 	. 
	defb 004h		;6149	04 	. 
	defb 0cbh		;614a	cb 	. 
	defb 004h		;614b	04 	. 
	defb 007h		;614c	07 	. 
	defb 0cdh		;614d	cd 	. 
	defb 005h		;614e	05 	. 
	defb 006h		;614f	06 	. 
	defb 003h		;6150	03 	. 
	defb 005h		;6151	05 	. 
	defb 00bh		;6152	0b 	. 
	defb 0cch		;6153	cc 	. 
	defb 002h		;6154	02 	. 
	defb 008h		;6155	08 	. 
	defb 004h		;6156	04 	. 
	defb 008h		;6157	08 	. 
	defb 009h		;6158	09 	. 
	defb 0d0h		;6159	d0 	. 
	defb 002h		;615a	02 	. 
	defb 00ch		;615b	0c 	. 
	defb 005h		;615c	05 	. 
	defb 004h		;615d	04 	. 
	defb 0cbh		;615e	cb 	. 
	defb 002h		;615f	02 	. 
	defb 006h		;6160	06 	. 
	defb 008h		;6161	08 	. 
	defb 053h		;6162	53 	S 
	defb 008h		;6163	08 	. 
	defb 003h		;6164	03 	. 
	defb 00dh		;6165	0d 	. 
	defb 003h		;6166	03 	. 
	defb 0cch		;6167	cc 	. 
	defb 002h		;6168	02 	. 
	defb 006h		;6169	06 	. 
	defb 0cbh		;616a	cb 	. 
	defb 005h		;616b	05 	. 
	defb 006h		;616c	06 	. 
	defb 0cbh		;616d	cb 	. 
	defb 002h		;616e	02 	. 
	defb 005h		;616f	05 	. 
	defb 0cbh		;6170	cb 	. 
	defb 006h		;6171	06 	. 
	defb 005h		;6172	05 	. 
	defb 00ah		;6173	0a 	. 
	defb 003h		;6174	03 	. 
	defb 00dh		;6175	0d 	. 
	defb 005h		;6176	05 	. 
	defb 0cbh		;6177	cb 	. 
	defb 003h		;6178	03 	. 
	defb 005h		;6179	05 	. 
	defb 0cbh		;617a	cb 	. 
	defb 002h		;617b	02 	. 
	defb 011h		;617c	11 	. 
	defb 005h		;617d	05 	. 
	defb 00eh		;617e	0e 	. 
	defb 003h		;617f	03 	. 
	defb 011h		;6180	11 	. 
	defb 004h		;6181	04 	. 
	defb 0cbh		;6182	cb 	. 
	defb 003h		;6183	03 	. 
	defb 011h		;6184	11 	. 
	defb 0cdh		;6185	cd 	. 
	defb 003h		;6186	03 	. 
	defb 009h		;6187	09 	. 
	defb 007h		;6188	07 	. 
	defb 004h		;6189	04 	. 
	defb 00ch		;618a	0c 	. 
	defb 0cbh		;618b	cb 	. 
	defb 002h		;618c	02 	. 
	defb 005h		;618d	05 	. 
	defb 014h		;618e	14 	. 
	defb 005h		;618f	05 	. 
	defb 0cbh		;6190	cb 	. 
	defb 002h		;6191	02 	. 
	defb 0cch		;6192	cc 	. 
	defb 003h		;6193	03 	. 
	defb 003h		;6194	03 	. 
	defb 004h		;6195	04 	. 
	defb 011h		;6196	11 	. 
	defb 0cdh		;6197	cd 	. 
	defb 002h		;6198	02 	. 
	defb 0cbh		;6199	cb 	. 
	defb 002h		;619a	02 	. 
	defb 01ch		;619b	1c 	. 
	defb 004h		;619c	04 	. 
	defb 003h		;619d	03 	. 
	defb 004h		;619e	04 	. 
	defb 0cbh		;619f	cb 	. 
	defb 004h		;61a0	04 	. 
	defb 00ah		;61a1	0a 	. 
	defb 009h		;61a2	09 	. 
	defb 003h		;61a3	03 	. 
	defb 00dh		;61a4	0d 	. 
	defb 0cbh		;61a5	cb 	. 
	defb 004h		;61a6	04 	. 
	defb 004h		;61a7	04 	. 
	defb 003h		;61a8	03 	. 
	defb 006h		;61a9	06 	. 
	defb 003h		;61aa	03 	. 
	defb 005h		;61ab	05 	. 
	defb 009h		;61ac	09 	. 
	defb 003h		;61ad	03 	. 
	defb 00eh		;61ae	0e 	. 
	defb 003h		;61af	03 	. 
	defb 005h		;61b0	05 	. 
	defb 003h		;61b1	03 	. 
	defb 004h		;61b2	04 	. 
	defb 003h		;61b3	03 	. 
	defb 005h		;61b4	05 	. 
	defb 003h		;61b5	03 	. 
	defb 008h		;61b6	08 	. 
	defb 0cbh		;61b7	cb 	. 
	defb 002h		;61b8	02 	. 
	defb 0cfh		;61b9	cf 	. 
	defb 002h		;61ba	02 	. 
	defb 005h		;61bb	05 	. 
	defb 003h		;61bc	03 	. 
	defb 004h		;61bd	04 	. 
	defb 0cbh		;61be	cb 	. 
	defb 002h		;61bf	02 	. 
	defb 005h		;61c0	05 	. 
	defb 0cbh		;61c1	cb 	. 
	defb 002h		;61c2	02 	. 
	defb 005h		;61c3	05 	. 
	defb 003h		;61c4	03 	. 
	defb 00ch		;61c5	0c 	. 
	defb 00dh		;61c6	0d 	. 
	defb 007h		;61c7	07 	. 
	defb 009h		;61c8	09 	. 
	defb 0cbh		;61c9	cb 	. 
	defb 002h		;61ca	02 	. 
	defb 0cdh		;61cb	cd 	. 
	defb 002h		;61cc	02 	. 
	defb 00dh		;61cd	0d 	. 
	defb 00ch		;61ce	0c 	. 
	defb 003h		;61cf	03 	. 
	defb 005h		;61d0	05 	. 
	defb 0cbh		;61d1	cb 	. 
	defb 002h		;61d2	02 	. 
	defb 015h		;61d3	15 	. 
	defb 0cch		;61d4	cc 	. 
	defb 003h		;61d5	03 	. 
	defb 010h		;61d6	10 	. 
	defb 00dh		;61d7	0d 	. 
	defb 005h		;61d8	05 	. 
	defb 00dh		;61d9	0d 	. 
	defb 0cdh		;61da	cd 	. 
	defb 002h		;61db	02 	. 
	defb 0cch		;61dc	cc 	. 
	defb 003h		;61dd	03 	. 
	defb 00ah		;61de	0a 	. 
	defb 005h		;61df	05 	. 
	defb 018h		;61e0	18 	. 
	defb 004h		;61e1	04 	. 
	defb 00dh		;61e2	0d 	. 
	defb 005h		;61e3	05 	. 
	defb 00fh		;61e4	0f 	. 
	defb 0cdh		;61e5	cd 	. 
	defb 002h		;61e6	02 	. 
	defb 00ch		;61e7	0c 	. 
	defb 00dh		;61e8	0d 	. 
	defb 005h		;61e9	05 	. 
	defb 010h		;61ea	10 	. 
	defb 013h		;61eb	13 	. 
	defb 017h		;61ec	17 	. 
	defb 003h		;61ed	03 	. 
	defb 008h		;61ee	08 	. 
	defb 00eh		;61ef	0e 	. 
	defb 005h		;61f0	05 	. 
	defb 01ch		;61f1	1c 	. 
	defb 0cah		;61f2	ca 	. 
	defb 004h		;61f3	04 	. 
	defb 01eh		;61f4	1e 	. 
	defb 010h		;61f5	10 	. 
	defb 005h		;61f6	05 	. 
	defb 006h		;61f7	06 	. 
	defb 0cbh		;61f8	cb 	. 
	defb 002h		;61f9	02 	. 
	defb 004h		;61fa	04 	. 
	defb 006h		;61fb	06 	. 
	defb 003h		;61fc	03 	. 
	defb 006h		;61fd	06 	. 
	defb 0cbh		;61fe	cb 	. 
	defb 002h		;61ff	02 	. 
	defb 00ah		;6200	0a 	. 
	defb 003h		;6201	03 	. 
	defb 00bh		;6202	0b 	. 
	defb 00ah		;6203	0a 	. 
	defb 00eh		;6204	0e 	. 
	defb 003h		;6205	03 	. 
	defb 006h		;6206	06 	. 
	defb 017h		;6207	17 	. 
	defb 012h		;6208	12 	. 
	defb 021h		;6209	21 	! 
	defb 01fh		;620a	1f 	. 
	defb 0cbh		;620b	cb 	. 
	defb 002h		;620c	02 	. 
	defb 004h		;620d	04 	. 
	defb 003h		;620e	03 	. 
	defb 006h		;620f	06 	. 
	defb 003h		;6210	03 	. 
	defb 006h		;6211	06 	. 
	defb 003h		;6212	03 	. 
	defb 005h		;6213	05 	. 
	defb 0d6h		;6214	d6 	. 
	defb 002h		;6215	02 	. 
	defb 004h		;6216	04 	. 
	defb 003h		;6217	03 	. 
	defb 006h		;6218	06 	. 
	defb 00dh		;6219	0d 	. 
	defb 00ah		;621a	0a 	. 
	defb 004h		;621b	04 	. 
	defb 013h		;621c	13 	. 
	defb 007h		;621d	07 	. 
	defb 008h		;621e	08 	. 
	defb 003h		;621f	03 	. 
	defb 0cch		;6220	cc 	. 
	defb 002h		;6221	02 	. 
	defb 00ch		;6222	0c 	. 
	defb 0cbh		;6223	cb 	. 
	defb 006h		;6224	06 	. 
	defb 009h		;6225	09 	. 
	defb 007h		;6226	07 	. 
	defb 008h		;6227	08 	. 
	defb 005h		;6228	05 	. 
	defb 0cbh		;6229	cb 	. 
	defb 002h		;622a	02 	. 
	defb 005h		;622b	05 	. 
	defb 008h		;622c	08 	. 
	defb 005h		;622d	05 	. 
	defb 00dh		;622e	0d 	. 
	defb 0cbh		;622f	cb 	. 
	defb 002h		;6230	02 	. 
	defb 006h		;6231	06 	. 
	defb 003h		;6232	03 	. 
	defb 007h		;6233	07 	. 
	defb 005h		;6234	05 	. 
	defb 0cbh		;6235	cb 	. 
	defb 006h		;6236	06 	. 
	defb 0cch		;6237	cc 	. 
	defb 002h		;6238	02 	. 
	defb 0cbh		;6239	cb 	. 
	defb 002h		;623a	02 	. 
	defb 0cch		;623b	cc 	. 
	defb 002h		;623c	02 	. 
	defb 0cbh		;623d	cb 	. 
	defb 002h		;623e	02 	. 
	defb 006h		;623f	06 	. 
	defb 004h		;6240	04 	. 
	defb 003h		;6241	03 	. 
	defb 005h		;6242	05 	. 
	defb 003h		;6243	03 	. 
	defb 004h		;6244	04 	. 
	defb 0cbh		;6245	cb 	. 
	defb 005h		;6246	05 	. 
	defb 004h		;6247	04 	. 
	defb 0cbh		;6248	cb 	. 
	defb 002h		;6249	02 	. 
	defb 009h		;624a	09 	. 
	defb 003h		;624b	03 	. 
	defb 004h		;624c	04 	. 
	defb 0cdh		;624d	cd 	. 
	defb 002h		;624e	02 	. 
	defb 004h		;624f	04 	. 
	defb 003h		;6250	03 	. 
	defb 004h		;6251	04 	. 
	defb 00ah		;6252	0a 	. 
	defb 004h		;6253	04 	. 
	defb 003h		;6254	03 	. 
	defb 019h		;6255	19 	. 
	defb 003h		;6256	03 	. 
	defb 004h		;6257	04 	. 
	defb 003h		;6258	03 	. 
	defb 00eh		;6259	0e 	. 
	defb 012h		;625a	12 	. 
	defb 003h		;625b	03 	. 
	defb 00eh		;625c	0e 	. 
	defb 026h		;625d	26 	& 
	defb 003h		;625e	03 	. 
	defb 00bh		;625f	0b 	. 
	defb 0cch		;6260	cc 	. 
	defb 002h		;6261	02 	. 
	defb 007h		;6262	07 	. 
	defb 005h		;6263	05 	. 
	defb 00ch		;6264	0c 	. 
	defb 006h		;6265	06 	. 
	defb 014h		;6266	14 	. 
	defb 004h		;6267	04 	. 
	defb 003h		;6268	03 	. 
	defb 017h		;6269	17 	. 
	defb 004h		;626a	04 	. 
	defb 0cbh		;626b	cb 	. 
	defb 002h		;626c	02 	. 
	defb 0cch		;626d	cc 	. 
	defb 002h		;626e	02 	. 
	defb 006h		;626f	06 	. 
	defb 00dh		;6270	0d 	. 
	defb 0cdh		;6271	cd 	. 
	defb 002h		;6272	02 	. 
	defb 010h		;6273	10 	. 
	defb 0cdh		;6274	cd 	. 
	defb 003h		;6275	03 	. 
	defb 0cch		;6276	cc 	. 
	defb 002h		;6277	02 	. 
	defb 003h		;6278	03 	. 
	defb 004h		;6279	04 	. 
	defb 003h		;627a	03 	. 
	defb 009h		;627b	09 	. 
	defb 008h		;627c	08 	. 
	defb 007h		;627d	07 	. 
	defb 0cbh		;627e	cb 	. 
	defb 002h		;627f	02 	. 
	defb 00bh		;6280	0b 	. 
	defb 003h		;6281	03 	. 
	defb 011h		;6282	11 	. 
	defb 007h		;6283	07 	. 
	defb 011h		;6284	11 	. 
	defb 004h		;6285	04 	. 
	defb 003h		;6286	03 	. 
	defb 027h		;6287	27 	' 
	defb 008h		;6288	08 	. 
	defb 003h		;6289	03 	. 
	defb 005h		;628a	05 	. 
	defb 0cbh		;628b	cb 	. 
	defb 002h		;628c	02 	. 
	defb 005h		;628d	05 	. 
	defb 003h		;628e	03 	. 
	defb 006h		;628f	06 	. 
	defb 004h		;6290	04 	. 
	defb 0cbh		;6291	cb 	. 
	defb 003h		;6292	03 	. 
	defb 004h		;6293	04 	. 
	defb 003h		;6294	03 	. 
	defb 006h		;6295	06 	. 
	defb 003h		;6296	03 	. 
	defb 004h		;6297	04 	. 
	defb 0cbh		;6298	cb 	. 
	defb 002h		;6299	02 	. 
	defb 008h		;629a	08 	. 
	defb 004h		;629b	04 	. 
	defb 006h		;629c	06 	. 
	defb 003h		;629d	03 	. 
	defb 025h		;629e	25 	% 
	defb 003h		;629f	03 	. 
	defb 004h		;62a0	04 	. 
	defb 0cbh		;62a1	cb 	. 
	defb 002h		;62a2	02 	. 
	defb 00bh		;62a3	0b 	. 
	defb 0cch		;62a4	cc 	. 
	defb 003h		;62a5	03 	. 
	defb 005h		;62a6	05 	. 
	defb 00ch		;62a7	0c 	. 
	defb 004h		;62a8	04 	. 
	defb 012h		;62a9	12 	. 
	defb 014h		;62aa	14 	. 
	defb 008h		;62ab	08 	. 
	defb 0cch		;62ac	cc 	. 
	defb 002h		;62ad	02 	. 
	defb 003h		;62ae	03 	. 
	defb 005h		;62af	05 	. 
	defb 003h		;62b0	03 	. 
	defb 006h		;62b1	06 	. 
	defb 008h		;62b2	08 	. 
	defb 00fh		;62b3	0f 	. 
	defb 005h		;62b4	05 	. 
	defb 01ah		;62b5	1a 	. 
	defb 005h		;62b6	05 	. 
	defb 007h		;62b7	07 	. 
	defb 020h		;62b8	20 	  
	defb 005h		;62b9	05 	. 
	defb 009h		;62ba	09 	. 
	defb 007h		;62bb	07 	. 
	defb 006h		;62bc	06 	. 
	defb 005h		;62bd	05 	. 
	defb 00ah		;62be	0a 	. 
	defb 008h		;62bf	08 	. 
	defb 003h		;62c0	03 	. 
	defb 0cch		;62c1	cc 	. 
	defb 002h		;62c2	02 	. 
	defb 003h		;62c3	03 	. 
	defb 006h		;62c4	06 	. 
	defb 005h		;62c5	05 	. 
	defb 008h		;62c6	08 	. 
	defb 00bh		;62c7	0b 	. 
	defb 011h		;62c8	11 	. 
	defb 015h		;62c9	15 	. 
	defb 00ah		;62ca	0a 	. 
	defb 08fh		;62cb	8f 	. 
	defb 004h		;62cc	04 	. 
	defb 008h		;62cd	08 	. 
	defb 004h		;62ce	04 	. 
	defb 00eh		;62cf	0e 	. 
	defb 003h		;62d0	03 	. 
	defb 00bh		;62d1	0b 	. 
	defb 005h		;62d2	05 	. 
	defb 006h		;62d3	06 	. 
	defb 008h		;62d4	08 	. 
	defb 004h		;62d5	04 	. 
	defb 02ch		;62d6	2c 	, 
	defb 008h		;62d7	08 	. 
	defb 004h		;62d8	04 	. 
	defb 01ah		;62d9	1a 	. 
	defb 004h		;62da	04 	. 
	defb 007h		;62db	07 	. 
	defb 005h		;62dc	05 	. 
	defb 009h		;62dd	09 	. 
	defb 003h		;62de	03 	. 
	defb 006h		;62df	06 	. 
	defb 007h		;62e0	07 	. 
	defb 003h		;62e1	03 	. 
	defb 009h		;62e2	09 	. 
	defb 017h		;62e3	17 	. 
	defb 02ah		;62e4	2a 	* 
	defb 008h		;62e5	08 	. 
	defb 003h		;62e6	03 	. 
	defb 005h		;62e7	05 	. 
	defb 003h		;62e8	03 	. 
	defb 007h		;62e9	07 	. 
	defb 01dh		;62ea	1d 	. 
	defb 01ah		;62eb	1a 	. 
	defb 00dh		;62ec	0d 	. 
	defb 007h		;62ed	07 	. 
	defb 02dh		;62ee	2d 	- 
	defb 02ah		;62ef	2a 	* 
	defb 004h		;62f0	04 	. 
	defb 008h		;62f1	08 	. 
	defb 005h		;62f2	05 	. 
	defb 004h		;62f3	04 	. 
	defb 00eh		;62f4	0e 	. 
	defb 0cdh		;62f5	cd 	. 
	defb 002h		;62f6	02 	. 
	defb 00ch		;62f7	0c 	. 
	defb 003h		;62f8	03 	. 
	defb 021h		;62f9	21 	! 
	defb 005h		;62fa	05 	. 
	defb 009h		;62fb	09 	. 
	defb 003h		;62fc	03 	. 
	defb 018h		;62fd	18 	. 
	defb 014h		;62fe	14 	. 
	defb 00dh		;62ff	0d 	. 
	defb 015h		;6300	15 	. 
	defb 003h		;6301	03 	. 
	defb 004h		;6302	04 	. 
	defb 00ah		;6303	0a 	. 
	defb 016h		;6304	16 	. 
	defb 00dh		;6305	0d 	. 
	defb 003h		;6306	03 	. 
	defb 0d1h		;6307	d1 	. 
	defb 002h		;6308	02 	. 
	defb 003h		;6309	03 	. 
	defb 00fh		;630a	0f 	. 
	defb 015h		;630b	15 	. 
	defb 004h		;630c	04 	. 
	defb 005h		;630d	05 	. 
	defb 003h		;630e	03 	. 
	defb 004h		;630f	04 	. 
	defb 003h		;6310	03 	. 
	defb 004h		;6311	04 	. 
	defb 005h		;6312	05 	. 
	defb 011h		;6313	11 	. 
	defb 006h		;6314	06 	. 
	defb 01fh		;6315	1f 	. 
	defb 0cdh		;6316	cd 	. 
	defb 002h		;6317	02 	. 
	defb 003h		;6318	03 	. 
	defb 005h		;6319	05 	. 
	defb 003h		;631a	03 	. 
	defb 005h		;631b	05 	. 
	defb 009h		;631c	09 	. 
	defb 005h		;631d	05 	. 
	defb 0cbh		;631e	cb 	. 
	defb 002h		;631f	02 	. 
	defb 006h		;6320	06 	. 
	defb 007h		;6321	07 	. 
	defb 00ch		;6322	0c 	. 
	defb 007h		;6323	07 	. 
	defb 005h		;6324	05 	. 
	defb 010h		;6325	10 	. 
	defb 005h		;6326	05 	. 
	defb 00ah		;6327	0a 	. 
	defb 006h		;6328	06 	. 
	defb 003h		;6329	03 	. 
	defb 006h		;632a	06 	. 
	defb 007h		;632b	07 	. 
	defb 000h		;632c	00 	. 
	defb 000h		;632d	00 	. 
	defb 001h		;632e	01 	. 
	defb 0cah		;632f	ca 	. 
	defb 00dh		;6330	0d 	. 
	defb 006h		;6331	06 	. 
	defb 0cah		;6332	ca 	. 
	defb 00ah		;6333	0a 	. 
	defb 0cbh		;6334	cb 	. 
	defb 002h		;6335	02 	. 
	defb 004h		;6336	04 	. 
	defb 003h		;6337	03 	. 
	defb 005h		;6338	05 	. 
	defb 008h		;6339	08 	. 
	defb 003h		;633a	03 	. 
	defb 004h		;633b	04 	. 
	defb 003h		;633c	03 	. 
	defb 006h		;633d	06 	. 
	defb 00ah		;633e	0a 	. 
	defb 005h		;633f	05 	. 
	defb 003h		;6340	03 	. 
	defb 0cfh		;6341	cf 	. 
	defb 002h		;6342	02 	. 
	defb 0cdh		;6343	cd 	. 
	defb 002h		;6344	02 	. 
	defb 00ah		;6345	0a 	. 
	defb 005h		;6346	05 	. 
	defb 006h		;6347	06 	. 
	defb 008h		;6348	08 	. 
	defb 009h		;6349	09 	. 
	defb 007h		;634a	07 	. 
	defb 005h		;634b	05 	. 
	defb 0d0h		;634c	d0 	. 
	defb 002h		;634d	02 	. 
	defb 009h		;634e	09 	. 
	defb 0cbh		;634f	cb 	. 
	defb 002h		;6350	02 	. 
	defb 0d1h		;6351	d1 	. 
	defb 002h		;6352	02 	. 
	defb 0cbh		;6353	cb 	. 
	defb 002h		;6354	02 	. 
	defb 0cch		;6355	cc 	. 
	defb 002h		;6356	02 	. 
	defb 0cbh		;6357	cb 	. 
	defb 003h		;6358	03 	. 
	defb 00ch		;6359	0c 	. 
	defb 0ceh		;635a	ce 	. 
	defb 003h		;635b	03 	. 
	defb 004h		;635c	04 	. 
	defb 009h		;635d	09 	. 
	defb 0cfh		;635e	cf 	. 
	defb 002h		;635f	02 	. 
	defb 009h		;6360	09 	. 
	defb 0cbh		;6361	cb 	. 
	defb 008h		;6362	08 	. 
	defb 005h		;6363	05 	. 
	defb 006h		;6364	06 	. 
	defb 004h		;6365	04 	. 
	defb 0cbh		;6366	cb 	. 
	defb 002h		;6367	02 	. 
	defb 007h		;6368	07 	. 
	defb 00bh		;6369	0b 	. 
	defb 0cbh		;636a	cb 	. 
	defb 009h		;636b	09 	. 
	defb 00ch		;636c	0c 	. 
	defb 005h		;636d	05 	. 
	defb 0cbh		;636e	cb 	. 
	defb 002h		;636f	02 	. 
	defb 00ah		;6370	0a 	. 
	defb 012h		;6371	12 	. 
	defb 008h		;6372	08 	. 
	defb 0cbh		;6373	cb 	. 
	defb 003h		;6374	03 	. 
	defb 005h		;6375	05 	. 
	defb 00ch		;6376	0c 	. 
	defb 008h		;6377	08 	. 
	defb 00eh		;6378	0e 	. 
	defb 005h		;6379	05 	. 
	defb 0cbh		;637a	cb 	. 
	defb 006h		;637b	06 	. 
	defb 0cch		;637c	cc 	. 
	defb 002h		;637d	02 	. 
	defb 009h		;637e	09 	. 
	defb 049h		;637f	49 	I 
	defb 009h		;6380	09 	. 
	defb 00bh		;6381	0b 	. 
	defb 00ch		;6382	0c 	. 
	defb 01ch		;6383	1c 	. 
	defb 00bh		;6384	0b 	. 
	defb 0d7h		;6385	d7 	. 
	defb 002h		;6386	02 	. 
	defb 00ch		;6387	0c 	. 
	defb 0cbh		;6388	cb 	. 
	defb 002h		;6389	02 	. 
	defb 006h		;638a	06 	. 
	defb 00bh		;638b	0b 	. 
	defb 006h		;638c	06 	. 
	defb 008h		;638d	08 	. 
	defb 005h		;638e	05 	. 
	defb 017h		;638f	17 	. 
	defb 009h		;6390	09 	. 
	defb 00bh		;6391	0b 	. 
	defb 00ch		;6392	0c 	. 
	defb 005h		;6393	05 	. 
	defb 004h		;6394	04 	. 
	defb 005h		;6395	05 	. 
	defb 008h		;6396	08 	. 
	defb 007h		;6397	07 	. 
	defb 009h		;6398	09 	. 
	defb 008h		;6399	08 	. 
	defb 003h		;639a	03 	. 
	defb 013h		;639b	13 	. 
	defb 004h		;639c	04 	. 
	defb 0cbh		;639d	cb 	. 
	defb 005h		;639e	05 	. 
	defb 005h		;639f	05 	. 
	defb 0cbh		;63a0	cb 	. 
	defb 002h		;63a1	02 	. 
	defb 00ch		;63a2	0c 	. 
	defb 009h		;63a3	09 	. 
	defb 005h		;63a4	05 	. 
	defb 0d2h		;63a5	d2 	. 
	defb 002h		;63a6	02 	. 
	defb 004h		;63a7	04 	. 
	defb 016h		;63a8	16 	. 
	defb 00ch		;63a9	0c 	. 
	defb 008h		;63aa	08 	. 
	defb 003h		;63ab	03 	. 
	defb 009h		;63ac	09 	. 
	defb 006h		;63ad	06 	. 
	defb 0cbh		;63ae	cb 	. 
	defb 003h		;63af	03 	. 
	defb 00fh		;63b0	0f 	. 
	defb 005h		;63b1	05 	. 
	defb 00bh		;63b2	0b 	. 
	defb 00eh		;63b3	0e 	. 
	defb 007h		;63b4	07 	. 
	defb 004h		;63b5	04 	. 
	defb 00ah		;63b6	0a 	. 
	defb 003h		;63b7	03 	. 
	defb 0dbh		;63b8	db 	. 
	defb 002h		;63b9	02 	. 
	defb 011h		;63ba	11 	. 
	defb 026h		;63bb	26 	& 
	defb 009h		;63bc	09 	. 
	defb 005h		;63bd	05 	. 
	defb 003h		;63be	03 	. 
	defb 00eh		;63bf	0e 	. 
	defb 007h		;63c0	07 	. 
	defb 005h		;63c1	05 	. 
	defb 004h		;63c2	04 	. 
	defb 005h		;63c3	05 	. 
	defb 007h		;63c4	07 	. 
	defb 006h		;63c5	06 	. 
	defb 004h		;63c6	04 	. 
	defb 007h		;63c7	07 	. 
	defb 004h		;63c8	04 	. 
	defb 010h		;63c9	10 	. 
	defb 005h		;63ca	05 	. 
	defb 023h		;63cb	23 	# 
	defb 021h		;63cc	21 	! 
	defb 004h		;63cd	04 	. 
	defb 005h		;63ce	05 	. 
	defb 01eh		;63cf	1e 	. 
	defb 003h		;63d0	03 	. 
	defb 00eh		;63d1	0e 	. 
	defb 0cch		;63d2	cc 	. 
	defb 002h		;63d3	02 	. 
	defb 00dh		;63d4	0d 	. 
	defb 005h		;63d5	05 	. 
	defb 006h		;63d6	06 	. 
	defb 0cbh		;63d7	cb 	. 
	defb 004h		;63d8	04 	. 
	defb 00ah		;63d9	0a 	. 
	defb 003h		;63da	03 	. 
	defb 011h		;63db	11 	. 
	defb 003h		;63dc	03 	. 
	defb 005h		;63dd	05 	. 
	defb 0cbh		;63de	cb 	. 
	defb 002h		;63df	02 	. 
	defb 007h		;63e0	07 	. 
	defb 003h		;63e1	03 	. 
	defb 008h		;63e2	08 	. 
	defb 0cbh		;63e3	cb 	. 
	defb 002h		;63e4	02 	. 
	defb 004h		;63e5	04 	. 
	defb 003h		;63e6	03 	. 
	defb 00ah		;63e7	0a 	. 
	defb 0cbh		;63e8	cb 	. 
	defb 002h		;63e9	02 	. 
	defb 004h		;63ea	04 	. 
	defb 0cbh		;63eb	cb 	. 
	defb 002h		;63ec	02 	. 
	defb 005h		;63ed	05 	. 
	defb 003h		;63ee	03 	. 
	defb 01ch		;63ef	1c 	. 
	defb 00eh		;63f0	0e 	. 
	defb 0cbh		;63f1	cb 	. 
	defb 003h		;63f2	03 	. 
	defb 004h		;63f3	04 	. 
	defb 00ah		;63f4	0a 	. 
	defb 003h		;63f5	03 	. 
	defb 004h		;63f6	04 	. 
	defb 003h		;63f7	03 	. 
	defb 00ah		;63f8	0a 	. 
	defb 004h		;63f9	04 	. 
	defb 007h		;63fa	07 	. 
	defb 008h		;63fb	08 	. 
	defb 005h		;63fc	05 	. 
	defb 007h		;63fd	07 	. 
	defb 0d0h		;63fe	d0 	. 
	defb 002h		;63ff	02 	. 
	defb 0cdh		;6400	cd 	. 
	defb 002h		;6401	02 	. 
	defb 0cbh		;6402	cb 	. 
	defb 003h		;6403	03 	. 
	defb 004h		;6404	04 	. 
	defb 0cbh		;6405	cb 	. 
	defb 003h		;6406	03 	. 
	defb 005h		;6407	05 	. 
	defb 004h		;6408	04 	. 
	defb 003h		;6409	03 	. 
	defb 00ah		;640a	0a 	. 
	defb 005h		;640b	05 	. 
	defb 00bh		;640c	0b 	. 
	defb 0cbh		;640d	cb 	. 
	defb 002h		;640e	02 	. 
	defb 006h		;640f	06 	. 
	defb 005h		;6410	05 	. 
	defb 006h		;6411	06 	. 
l6412h:
	defb 008h		;6412	08 	. 
	defb 0cbh		;6413	cb 	. 
	defb 002h		;6414	02 	. 
	defb 008h		;6415	08 	. 
	defb 006h		;6416	06 	. 
	defb 003h		;6417	03 	. 
	defb 006h		;6418	06 	. 
	defb 0cbh		;6419	cb 	. 
	defb 002h		;641a	02 	. 
	defb 00ah		;641b	0a 	. 
	defb 005h		;641c	05 	. 
	defb 00fh		;641d	0f 	. 
	defb 00eh		;641e	0e 	. 
	defb 009h		;641f	09 	. 
	defb 0cbh		;6420	cb 	. 
	defb 003h		;6421	03 	. 
	defb 018h		;6422	18 	. 
	defb 003h		;6423	03 	. 
	defb 00fh		;6424	0f 	. 
	defb 0cfh		;6425	cf 	. 
	defb 003h		;6426	03 	. 
	defb 006h		;6427	06 	. 
	defb 003h		;6428	03 	. 
	defb 009h		;6429	09 	. 
	defb 0d5h		;642a	d5 	. 
	defb 002h		;642b	02 	. 
	defb 012h		;642c	12 	. 
	defb 007h		;642d	07 	. 
	defb 00ch		;642e	0c 	. 
	defb 009h		;642f	09 	. 
	defb 029h		;6430	29 	) 
	defb 005h		;6431	05 	. 
	defb 00eh		;6432	0e 	. 
	defb 00dh		;6433	0d 	. 
	defb 004h		;6434	04 	. 
	defb 00dh		;6435	0d 	. 
	defb 003h		;6436	03 	. 
	defb 005h		;6437	05 	. 
	defb 019h		;6438	19 	. 
	defb 028h		;6439	28 	( 
	defb 008h		;643a	08 	. 
	defb 00eh		;643b	0e 	. 
	defb 0cch		;643c	cc 	. 
	defb 002h		;643d	02 	. 
	defb 009h		;643e	09 	. 
	defb 0d3h		;643f	d3 	. 
	defb 002h		;6440	02 	. 
	defb 004h		;6441	04 	. 
	defb 0cbh		;6442	cb 	. 
	defb 003h		;6443	03 	. 
	defb 009h		;6444	09 	. 
	defb 008h		;6445	08 	. 
	defb 003h		;6446	03 	. 
	defb 042h		;6447	42 	B 
	defb 007h		;6448	07 	. 
	defb 0d1h		;6449	d1 	. 
	defb 002h		;644a	02 	. 
	defb 005h		;644b	05 	. 
	defb 01fh		;644c	1f 	. 
	defb 008h		;644d	08 	. 
	defb 006h		;644e	06 	. 
	defb 00ch		;644f	0c 	. 
	defb 005h		;6450	05 	. 
	defb 029h		;6451	29 	) 
	defb 050h		;6452	50 	P 
	defb 004h		;6453	04 	. 
	defb 03ah		;6454	3a 	: 
	defb 007h		;6455	07 	. 
	defb 0cbh		;6456	cb 	. 
	defb 003h		;6457	03 	. 
	defb 005h		;6458	05 	. 
	defb 00eh		;6459	0e 	. 
	defb 007h		;645a	07 	. 
	defb 013h		;645b	13 	. 
	defb 010h		;645c	10 	. 
	defb 00dh		;645d	0d 	. 
	defb 010h		;645e	10 	. 
	defb 003h		;645f	03 	. 
	defb 00ah		;6460	0a 	. 
	defb 005h		;6461	05 	. 
	defb 01dh		;6462	1d 	. 
	defb 009h		;6463	09 	. 
	defb 008h		;6464	08 	. 
	defb 003h		;6465	03 	. 
	defb 006h		;6466	06 	. 
	defb 003h		;6467	03 	. 
	defb 007h		;6468	07 	. 
	defb 028h		;6469	28 	( 
	defb 00bh		;646a	0b 	. 
	defb 003h		;646b	03 	. 
	defb 008h		;646c	08 	. 
	defb 003h		;646d	03 	. 
	defb 0ceh		;646e	ce 	. 
	defb 002h		;646f	02 	. 
	defb 009h		;6470	09 	. 
	defb 005h		;6471	05 	. 
	defb 003h		;6472	03 	. 
	defb 006h		;6473	06 	. 
	defb 003h		;6474	03 	. 
	defb 008h		;6475	08 	. 
	defb 0cbh		;6476	cb 	. 
	defb 004h		;6477	04 	. 
	defb 006h		;6478	06 	. 
	defb 005h		;6479	05 	. 
	defb 00dh		;647a	0d 	. 
	defb 003h		;647b	03 	. 
	defb 007h		;647c	07 	. 
	defb 004h		;647d	04 	. 
	defb 005h		;647e	05 	. 
	defb 009h		;647f	09 	. 
	defb 005h		;6480	05 	. 
	defb 0d3h		;6481	d3 	. 
	defb 002h		;6482	02 	. 
	defb 008h		;6483	08 	. 
	defb 00ch		;6484	0c 	. 
	defb 005h		;6485	05 	. 
	defb 003h		;6486	03 	. 
	defb 005h		;6487	05 	. 
	defb 00dh		;6488	0d 	. 
	defb 00bh		;6489	0b 	. 
	defb 008h		;648a	08 	. 
	defb 00ch		;648b	0c 	. 
	defb 005h		;648c	05 	. 
	defb 003h		;648d	03 	. 
	defb 005h		;648e	05 	. 
	defb 010h		;648f	10 	. 
	defb 0cbh		;6490	cb 	. 
	defb 002h		;6491	02 	. 
	defb 005h		;6492	05 	. 
	defb 003h		;6493	03 	. 
	defb 009h		;6494	09 	. 
	defb 0cbh		;6495	cb 	. 
	defb 003h		;6496	03 	. 
	defb 005h		;6497	05 	. 
	defb 00bh		;6498	0b 	. 
	defb 0cbh		;6499	cb 	. 
	defb 002h		;649a	02 	. 
	defb 00bh		;649b	0b 	. 
	defb 003h		;649c	03 	. 
	defb 006h		;649d	06 	. 
	defb 00ah		;649e	0a 	. 
	defb 003h		;649f	03 	. 
	defb 004h		;64a0	04 	. 
	defb 003h		;64a1	03 	. 
	defb 006h		;64a2	06 	. 
	defb 004h		;64a3	04 	. 
	defb 008h		;64a4	08 	. 
	defb 003h		;64a5	03 	. 
	defb 006h		;64a6	06 	. 
	defb 005h		;64a7	05 	. 
	defb 004h		;64a8	04 	. 
	defb 0cbh		;64a9	cb 	. 
	defb 002h		;64aa	02 	. 
	defb 03dh		;64ab	3d 	= 
	defb 00fh		;64ac	0f 	. 
	defb 01eh		;64ad	1e 	. 
	defb 025h		;64ae	25 	% 
	defb 00fh		;64af	0f 	. 
	defb 003h		;64b0	03 	. 
	defb 008h		;64b1	08 	. 
	defb 009h		;64b2	09 	. 
	defb 0cbh		;64b3	cb 	. 
	defb 002h		;64b4	02 	. 
	defb 005h		;64b5	05 	. 
	defb 0cbh		;64b6	cb 	. 
	defb 002h		;64b7	02 	. 
	defb 005h		;64b8	05 	. 
	defb 006h		;64b9	06 	. 
	defb 003h		;64ba	03 	. 
	defb 005h		;64bb	05 	. 
	defb 0cbh		;64bc	cb 	. 
	defb 002h		;64bd	02 	. 
	defb 008h		;64be	08 	. 
	defb 0cbh		;64bf	cb 	. 
	defb 002h		;64c0	02 	. 
	defb 004h		;64c1	04 	. 
	defb 0cbh		;64c2	cb 	. 
	defb 002h		;64c3	02 	. 
	defb 009h		;64c4	09 	. 
	defb 003h		;64c5	03 	. 
	defb 004h		;64c6	04 	. 
	defb 008h		;64c7	08 	. 
	defb 00ch		;64c8	0c 	. 
	defb 004h		;64c9	04 	. 
	defb 018h		;64ca	18 	. 
	defb 0cbh		;64cb	cb 	. 
	defb 004h		;64cc	04 	. 
	defb 004h		;64cd	04 	. 
	defb 005h		;64ce	05 	. 
	defb 008h		;64cf	08 	. 
	defb 00fh		;64d0	0f 	. 
	defb 00eh		;64d1	0e 	. 
	defb 020h		;64d2	20 	  
	defb 003h		;64d3	03 	. 
	defb 005h		;64d4	05 	. 
	defb 0cbh		;64d5	cb 	. 
	defb 002h		;64d6	02 	. 
	defb 010h		;64d7	10 	. 
	defb 005h		;64d8	05 	. 
	defb 011h		;64d9	11 	. 
	defb 00ah		;64da	0a 	. 
	defb 004h		;64db	04 	. 
	defb 00ah		;64dc	0a 	. 
	defb 020h		;64dd	20 	  
	defb 005h		;64de	05 	. 
	defb 010h		;64df	10 	. 
	defb 0cbh		;64e0	cb 	. 
	defb 002h		;64e1	02 	. 
	defb 0cdh		;64e2	cd 	. 
	defb 002h		;64e3	02 	. 
	defb 009h		;64e4	09 	. 
	defb 0cfh		;64e5	cf 	. 
	defb 002h		;64e6	02 	. 
	defb 02ah		;64e7	2a 	* 
	defb 004h		;64e8	04 	. 
	defb 0cbh		;64e9	cb 	. 
	defb 006h		;64ea	06 	. 
	defb 006h		;64eb	06 	. 
	defb 008h		;64ec	08 	. 
	defb 0cbh		;64ed	cb 	. 
	defb 003h		;64ee	03 	. 
	defb 004h		;64ef	04 	. 
	defb 00ch		;64f0	0c 	. 
	defb 00fh		;64f1	0f 	. 
	defb 003h		;64f2	03 	. 
	defb 00eh		;64f3	0e 	. 
	defb 01bh		;64f4	1b 	. 
	defb 003h		;64f5	03 	. 
	defb 01fh		;64f6	1f 	. 
	defb 007h		;64f7	07 	. 
	defb 025h		;64f8	25 	% 
	defb 0ceh		;64f9	ce 	. 
	defb 002h		;64fa	02 	. 
	defb 00dh		;64fb	0d 	. 
	defb 008h		;64fc	08 	. 
	defb 013h		;64fd	13 	. 
	defb 003h		;64fe	03 	. 
	defb 005h		;64ff	05 	. 
	defb 013h		;6500	13 	. 
	defb 010h		;6501	10 	. 
	defb 003h		;6502	03 	. 
	defb 00eh		;6503	0e 	. 
	defb 04eh		;6504	4e 	N 
	defb 004h		;6505	04 	. 
	defb 00fh		;6506	0f 	. 
	defb 013h		;6507	13 	. 
	defb 024h		;6508	24 	$ 
	defb 003h		;6509	03 	. 
	defb 005h		;650a	05 	. 
	defb 00ah		;650b	0a 	. 
	defb 005h		;650c	05 	. 
	defb 004h		;650d	04 	. 
	defb 00dh		;650e	0d 	. 
	defb 0cdh		;650f	cd 	. 
	defb 003h		;6510	03 	. 
	defb 0cbh		;6511	cb 	. 
	defb 002h		;6512	02 	. 
	defb 017h		;6513	17 	. 
	defb 007h		;6514	07 	. 
	defb 010h		;6515	10 	. 
	defb 0d2h		;6516	d2 	. 
	defb 002h		;6517	02 	. 
	defb 003h		;6518	03 	. 
	defb 00ah		;6519	0a 	. 
	defb 00ch		;651a	0c 	. 
	defb 005h		;651b	05 	. 
	defb 0cch		;651c	cc 	. 
	defb 002h		;651d	02 	. 
	defb 020h		;651e	20 	  
	defb 003h		;651f	03 	. 
	defb 049h		;6520	49 	I 
	defb 008h		;6521	08 	. 
	defb 009h		;6522	09 	. 
	defb 020h		;6523	20 	  
	defb 003h		;6524	03 	. 
	defb 00bh		;6525	0b 	. 
	defb 003h		;6526	03 	. 
	defb 009h		;6527	09 	. 
	defb 008h		;6528	08 	. 
	defb 00bh		;6529	0b 	. 
	defb 012h		;652a	12 	. 
	defb 00ah		;652b	0a 	. 
	defb 006h		;652c	06 	. 
	defb 017h		;652d	17 	. 
	defb 003h		;652e	03 	. 
	defb 00bh		;652f	0b 	. 
	defb 013h		;6530	13 	. 
	defb 003h		;6531	03 	. 
	defb 006h		;6532	06 	. 
	defb 00bh		;6533	0b 	. 
	defb 008h		;6534	08 	. 
	defb 00bh		;6535	0b 	. 
	defb 009h		;6536	09 	. 
	defb 007h		;6537	07 	. 
	defb 008h		;6538	08 	. 
	defb 004h		;6539	04 	. 
	defb 005h		;653a	05 	. 
	defb 004h		;653b	04 	. 
	defb 011h		;653c	11 	. 
	defb 049h		;653d	49 	I 
	defb 009h		;653e	09 	. 
	defb 00ch		;653f	0c 	. 
	defb 003h		;6540	03 	. 
	defb 004h		;6541	04 	. 
	defb 050h		;6542	50 	P 
	defb 00ah		;6543	0a 	. 
	defb 02bh		;6544	2b 	+ 
	defb 022h		;6545	22 	" 
	defb 00fh		;6546	0f 	. 
	defb 00bh		;6547	0b 	. 
	defb 009h		;6548	09 	. 
	defb 003h		;6549	03 	. 
	defb 006h		;654a	06 	. 
	defb 003h		;654b	03 	. 
	defb 004h		;654c	04 	. 
	defb 005h		;654d	05 	. 
	defb 009h		;654e	09 	. 
	defb 005h		;654f	05 	. 
	defb 004h		;6550	04 	. 
	defb 005h		;6551	05 	. 
	defb 00bh		;6552	0b 	. 
	defb 014h		;6553	14 	. 
	defb 004h		;6554	04 	. 
	defb 00bh		;6555	0b 	. 
	defb 00eh		;6556	0e 	. 
	defb 00ah		;6557	0a 	. 
	defb 006h		;6558	06 	. 
	defb 003h		;6559	03 	. 
	defb 009h		;655a	09 	. 
	defb 01ah		;655b	1a 	. 
	defb 009h		;655c	09 	. 
	defb 00eh		;655d	0e 	. 
	defb 015h		;655e	15 	. 
	defb 0cch		;655f	cc 	. 
	defb 002h		;6560	02 	. 
	defb 00dh		;6561	0d 	. 
	defb 00bh		;6562	0b 	. 
	defb 021h		;6563	21 	! 
	defb 00eh		;6564	0e 	. 
	defb 009h		;6565	09 	. 
	defb 065h		;6566	65 	e 
	defb 017h		;6567	17 	. 
	defb 00eh		;6568	0e 	. 
	defb 03bh		;6569	3b 	; 
	defb 0cdh		;656a	cd 	. 
	defb 002h		;656b	02 	. 
	defb 003h		;656c	03 	. 
	defb 00bh		;656d	0b 	. 
	defb 00eh		;656e	0e 	. 
	defb 004h		;656f	04 	. 
	defb 007h		;6570	07 	. 
	defb 00ch		;6571	0c 	. 
	defb 005h		;6572	05 	. 
	defb 013h		;6573	13 	. 
	defb 01bh		;6574	1b 	. 
	defb 004h		;6575	04 	. 
	defb 006h		;6576	06 	. 
	defb 00fh		;6577	0f 	. 
	defb 0cbh		;6578	cb 	. 
	defb 003h		;6579	03 	. 
	defb 006h		;657a	06 	. 
	defb 00ch		;657b	0c 	. 
	defb 029h		;657c	29 	) 
	defb 009h		;657d	09 	. 
	defb 00dh		;657e	0d 	. 
	defb 004h		;657f	04 	. 
	defb 003h		;6580	03 	. 
	defb 004h		;6581	04 	. 
	defb 006h		;6582	06 	. 
	defb 0cbh		;6583	cb 	. 
	defb 002h		;6584	02 	. 
	defb 008h		;6585	08 	. 
	defb 009h		;6586	09 	. 
	defb 0ceh		;6587	ce 	. 
	defb 002h		;6588	02 	. 
	defb 00bh		;6589	0b 	. 
	defb 012h		;658a	12 	. 
	defb 009h		;658b	09 	. 
	defb 023h		;658c	23 	# 
	defb 011h		;658d	11 	. 
	defb 005h		;658e	05 	. 
	defb 006h		;658f	06 	. 
	defb 008h		;6590	08 	. 
	defb 0ceh		;6591	ce 	. 
	defb 002h		;6592	02 	. 
	defb 005h		;6593	05 	. 
	defb 020h		;6594	20 	  
	defb 014h		;6595	14 	. 
	defb 01dh		;6596	1d 	. 
	defb 004h		;6597	04 	. 
	defb 014h		;6598	14 	. 
	defb 00bh		;6599	0b 	. 
	defb 00eh		;659a	0e 	. 
	defb 0cbh		;659b	cb 	. 
	defb 006h		;659c	06 	. 
	defb 01bh		;659d	1b 	. 
	defb 0cbh		;659e	cb 	. 
	defb 002h		;659f	02 	. 
	defb 0cdh		;65a0	cd 	. 
	defb 002h		;65a1	02 	. 
	defb 003h		;65a2	03 	. 
	defb 00ah		;65a3	0a 	. 
	defb 0cbh		;65a4	cb 	. 
	defb 006h		;65a5	06 	. 
	defb 006h		;65a6	06 	. 
	defb 008h		;65a7	08 	. 
	defb 010h		;65a8	10 	. 
	defb 009h		;65a9	09 	. 
	defb 006h		;65aa	06 	. 
	defb 011h		;65ab	11 	. 
	defb 008h		;65ac	08 	. 
	defb 012h		;65ad	12 	. 
	defb 006h		;65ae	06 	. 
	defb 00dh		;65af	0d 	. 
	defb 004h		;65b0	04 	. 
	defb 0cbh		;65b1	cb 	. 
	defb 007h		;65b2	07 	. 
data_613a_end:

; BLOCK 'logo_image' (start 0x65b3 end 0x66f4)
logo_image_start:
	defb 000h		;65b3	00 	. 
	defb 000h		;65b4	00 	. 
	defb 07fh		;65b5	7f 	 
	defb 0ffh		;65b6	ff 	. 
	defb 0ffh		;65b7	ff 	. 
	defb 0ffh		;65b8	ff 	. 
	defb 0fch		;65b9	fc 	. 
	defb 0dch		;65ba	dc 	. 
	defb 0a8h		;65bb	a8 	. 
	defb 000h		;65bc	00 	. 
	defb 0e0h		;65bd	e0 	. 
	defb 0f8h		;65be	f8 	. 
	defb 0fch		;65bf	fc 	. 
	defb 0fch		;65c0	fc 	. 
	defb 0feh		;65c1	fe 	. 
	defb 076h		;65c2	76 	v 
	defb 0aah		;65c3	aa 	. 
	defb 000h		;65c4	00 	. 
	defb 07fh		;65c5	7f 	 
	defb 0ffh		;65c6	ff 	. 
	defb 0ffh		;65c7	ff 	. 
	defb 0ffh		;65c8	ff 	. 
	defb 0fch		;65c9	fc 	. 
	defb 0dch		;65ca	dc 	. 
	defb 0a8h		;65cb	a8 	. 
	defb 000h		;65cc	00 	. 
	defb 0e0h		;65cd	e0 	. 
	defb 0f8h		;65ce	f8 	. 
	defb 0fch		;65cf	fc 	. 
	defb 0fch		;65d0	fc 	. 
	defb 0feh		;65d1	fe 	. 
	defb 076h		;65d2	76 	v 
	defb 0aah		;65d3	aa 	. 
	defb 000h		;65d4	00 	. 
	defb 00fh		;65d5	0f 	. 
	defb 03fh		;65d6	3f 	? 
	defb 07fh		;65d7	7f 	 
	defb 07fh		;65d8	7f 	 
	defb 0feh		;65d9	fe 	. 
	defb 0dch		;65da	dc 	. 
	defb 0a8h		;65db	a8 	. 
	defb 000h		;65dc	00 	. 
	defb 0e0h		;65dd	e0 	. 
	defb 0f8h		;65de	f8 	. 
	defb 0fch		;65df	fc 	. 
	defb 0fch		;65e0	fc 	. 
	defb 0feh		;65e1	fe 	. 
	defb 06eh		;65e2	6e 	n 
	defb 054h		;65e3	54 	T 
	defb 000h		;65e4	00 	. 
	defb 060h		;65e5	60 	` 
	defb 0f0h		;65e6	f0 	. 
	defb 0f8h		;65e7	f8 	. 
	defb 0fch		;65e8	fc 	. 
	defb 0feh		;65e9	fe 	. 
	defb 077h		;65ea	77 	w 
	defb 0aah		;65eb	aa 	. 
	defb 000h		;65ec	00 	. 
	defb 00ch		;65ed	0c 	. 
	defb 01eh		;65ee	1e 	. 
	defb 03eh		;65ef	3e 	> 
	defb 07eh		;65f0	7e 	~ 
	defb 0feh		;65f1	fe 	. 
	defb 076h		;65f2	76 	v 
	defb 0aah		;65f3	aa 	. 
	defb 000h		;65f4	00 	. 
	defb 07fh		;65f5	7f 	 
	defb 0ffh		;65f6	ff 	. 
	defb 0ffh		;65f7	ff 	. 
	defb 0ffh		;65f8	ff 	. 
	defb 0fch		;65f9	fc 	. 
	defb 077h		;65fa	77 	w 
	defb 0aah		;65fb	aa 	. 
	defb 000h		;65fc	00 	. 
	defb 0fch		;65fd	fc 	. 
	defb 0feh		;65fe	fe 	. 
	defb 0feh		;65ff	fe 	. 
	defb 0fch		;6600	fc 	. 
	defb 000h		;6601	00 	. 
	defb 060h		;6602	60 	` 
	defb 0b0h		;6603	b0 	. 
	defb 000h		;6604	00 	. 
	defb 07fh		;6605	7f 	 
	defb 0ffh		;6606	ff 	. 
	defb 0ffh		;6607	ff 	. 
	defb 07fh		;6608	7f 	 
	defb 007h		;6609	07 	. 
	defb 003h		;660a	03 	. 
	defb 005h		;660b	05 	. 
	defb 000h		;660c	00 	. 
	defb 0feh		;660d	fe 	. 
	defb 0ffh		;660e	ff 	. 
	defb 0ffh		;660f	ff 	. 
	defb 0feh		;6610	fe 	. 
	defb 0e0h		;6611	e0 	. 
	defb 0a0h		;6612	a0 	. 
	defb 040h		;6613	40 	@ 
	defb 000h		;6614	00 	. 
	defb 03ch		;6615	3c 	< 
	defb 07eh		;6616	7e 	~ 
	defb 07eh		;6617	7e 	~ 
	defb 07eh		;6618	7e 	~ 
	defb 07eh		;6619	7e 	~ 
	defb 03bh		;661a	3b 	; 
	defb 055h		;661b	55 	U 
	defb 000h		;661c	00 	. 
	defb 01eh		;661d	1e 	. 
	defb 03fh		;661e	3f 	? 
	defb 03fh		;661f	3f 	? 
	defb 03fh		;6620	3f 	? 
	defb 03fh		;6621	3f 	? 
	defb 0bbh		;6622	bb 	. 
	defb 055h		;6623	55 	U 
	defb 000h		;6624	00 	. 
	defb 03fh		;6625	3f 	? 
	defb 07fh		;6626	7f 	 
	defb 07fh		;6627	7f 	 
	defb 07fh		;6628	7f 	 
	defb 07eh		;6629	7e 	~ 
	defb 03bh		;662a	3b 	; 
	defb 055h		;662b	55 	U 
	defb 000h		;662c	00 	. 
	defb 0feh		;662d	fe 	. 
	defb 0ffh		;662e	ff 	. 
	defb 0ffh		;662f	ff 	. 
	defb 0feh		;6630	fe 	. 
	defb 000h		;6631	00 	. 
	defb 0b8h		;6632	b8 	. 
	defb 054h		;6633	54 	T 
	defb 000h		;6634	00 	. 
	defb 03ch		;6635	3c 	< 
	defb 07eh		;6636	7e 	~ 
	defb 07eh		;6637	7e 	~ 
	defb 07eh		;6638	7e 	~ 
	defb 07eh		;6639	7e 	~ 
	defb 03ah		;663a	3a 	: 
	defb 054h		;663b	54 	T 
	defb 000h		;663c	00 	. 
	defb 01eh		;663d	1e 	. 
	defb 03fh		;663e	3f 	? 
	defb 03fh		;663f	3f 	? 
	defb 03fh		;6640	3f 	? 
	defb 03fh		;6641	3f 	? 
	defb 01dh		;6642	1d 	. 
	defb 02ah		;6643	2a 	* 
	defb 000h		;6644	00 	. 
	defb 00fh		;6645	0f 	. 
	defb 03fh		;6646	3f 	? 
	defb 03fh		;6647	3f 	? 
	defb 07fh		;6648	7f 	 
	defb 07eh		;6649	7e 	~ 
	defb 07bh		;664a	7b 	{ 
	defb 015h		;664b	15 	. 
	defb 000h		;664c	00 	. 
	defb 0f8h		;664d	f8 	. 
	defb 0fch		;664e	fc 	. 
	defb 0fch		;664f	fc 	. 
	defb 0f8h		;6650	f8 	. 
	defb 000h		;6651	00 	. 
	defb 0a8h		;6652	a8 	. 
	defb 054h		;6653	54 	T 
	defb 055h		;6654	55 	U 
	defb 0bbh		;6655	bb 	. 
	defb 0ffh		;6656	ff 	. 
	defb 0ffh		;6657	ff 	. 
	defb 0fch		;6658	fc 	. 
	defb 0fch		;6659	fc 	. 
	defb 0fch		;665a	fc 	. 
	defb 078h		;665b	78 	x 
	defb 054h		;665c	54 	T 
	defb 0bch		;665d	bc 	. 
	defb 0f8h		;665e	f8 	. 
	defb 0e0h		;665f	e0 	. 
	defb 000h		;6660	00 	. 
	defb 000h		;6661	00 	. 
	defb 000h		;6662	00 	. 
	defb 000h		;6663	00 	. 
	defb 055h		;6664	55 	U 
	defb 0bbh		;6665	bb 	. 
	defb 0ffh		;6666	ff 	. 
	defb 0ffh		;6667	ff 	. 
	defb 0ffh		;6668	ff 	. 
	defb 0fch		;6669	fc 	. 
	defb 0fch		;666a	fc 	. 
	defb 078h		;666b	78 	x 
	defb 054h		;666c	54 	T 
	defb 0bch		;666d	bc 	. 
	defb 0f8h		;666e	f8 	. 
	defb 0f0h		;666f	f0 	. 
	defb 0f8h		;6670	f8 	. 
	defb 0fch		;6671	fc 	. 
	defb 07eh		;6672	7e 	~ 
	defb 03ch		;6673	3c 	< 
	defb 054h		;6674	54 	T 
	defb 0ech		;6675	ec 	. 
	defb 0fch		;6676	fc 	. 
	defb 0feh		;6677	fe 	. 
	defb 07fh		;6678	7f 	 
	defb 07fh		;6679	7f 	 
	defb 03fh		;667a	3f 	? 
	defb 00fh		;667b	0f 	. 
	defb 02ah		;667c	2a 	* 
	defb 076h		;667d	76 	v 
	defb 07eh		;667e	7e 	~ 
	defb 0feh		;667f	fe 	. 
	defb 0fch		;6680	fc 	. 
	defb 0fch		;6681	fc 	. 
	defb 0f8h		;6682	f8 	. 
	defb 0e0h		;6683	e0 	. 
	defb 055h		;6684	55 	U 
	defb 0bbh		;6685	bb 	. 
	defb 0fdh		;6686	fd 	. 
	defb 0fch		;6687	fc 	. 
	defb 0fch		;6688	fc 	. 
	defb 0fch		;6689	fc 	. 
	defb 0fch		;668a	fc 	. 
	defb 078h		;668b	78 	x 
	defb 054h		;668c	54 	T 
	defb 0bah		;668d	ba 	. 
	defb 07eh		;668e	7e 	~ 
	defb 07eh		;668f	7e 	~ 
	defb 07eh		;6690	7e 	~ 
	defb 07eh		;6691	7e 	~ 
	defb 07eh		;6692	7e 	~ 
	defb 03ch		;6693	3c 	< 
	defb 055h		;6694	55 	U 
	defb 0bbh		;6695	bb 	. 
	defb 0fch		;6696	fc 	. 
	defb 0fch		;6697	fc 	. 
	defb 0ffh		;6698	ff 	. 
	defb 0ffh		;6699	ff 	. 
	defb 0ffh		;669a	ff 	. 
	defb 07fh		;669b	7f 	 
	defb 050h		;669c	50 	P 
	defb 0a0h		;669d	a0 	. 
	defb 000h		;669e	00 	. 
	defb 000h		;669f	00 	. 
	defb 0fch		;66a0	fc 	. 
	defb 0feh		;66a1	fe 	. 
	defb 0feh		;66a2	fe 	. 
	defb 0fch		;66a3	fc 	. 
	defb 002h		;66a4	02 	. 
	defb 005h		;66a5	05 	. 
	defb 007h		;66a6	07 	. 
	defb 007h		;66a7	07 	. 
	defb 007h		;66a8	07 	. 
	defb 007h		;66a9	07 	. 
	defb 007h		;66aa	07 	. 
	defb 003h		;66ab	03 	. 
	defb 0a0h		;66ac	a0 	. 
	defb 0c0h		;66ad	c0 	. 
	defb 0e0h		;66ae	e0 	. 
	defb 0e0h		;66af	e0 	. 
	defb 0e0h		;66b0	e0 	. 
	defb 0e0h		;66b1	e0 	. 
	defb 0e0h		;66b2	e0 	. 
	defb 0c0h		;66b3	c0 	. 
	defb 02ah		;66b4	2a 	* 
	defb 05dh		;66b5	5d 	] 
	defb 07eh		;66b6	7e 	~ 
	defb 07eh		;66b7	7e 	~ 
	defb 07eh		;66b8	7e 	~ 
	defb 07eh		;66b9	7e 	~ 
	defb 07eh		;66ba	7e 	~ 
	defb 03ch		;66bb	3c 	< 
	defb 0aah		;66bc	aa 	. 
	defb 0ddh		;66bd	dd 	. 
	defb 03fh		;66be	3f 	? 
	defb 03fh		;66bf	3f 	? 
	defb 03fh		;66c0	3f 	? 
	defb 03fh		;66c1	3f 	? 
	defb 03fh		;66c2	3f 	? 
	defb 01eh		;66c3	1e 	. 
	defb 02ah		;66c4	2a 	* 
	defb 05dh		;66c5	5d 	] 
	defb 07eh		;66c6	7e 	~ 
	defb 07eh		;66c7	7e 	~ 
	defb 07fh		;66c8	7f 	 
	defb 07fh		;66c9	7f 	 
	defb 07fh		;66ca	7f 	 
	defb 03fh		;66cb	3f 	? 
	defb 0ach		;66cc	ac 	. 
	defb 0d8h		;66cd	d8 	. 
	defb 000h		;66ce	00 	. 
	defb 000h		;66cf	00 	. 
	defb 0feh		;66d0	fe 	. 
	defb 0ffh		;66d1	ff 	. 
	defb 0ffh		;66d2	ff 	. 
	defb 0feh		;66d3	fe 	. 
	defb 02ah		;66d4	2a 	* 
	defb 05ch		;66d5	5c 	\ 
	defb 07fh		;66d6	7f 	 
	defb 07fh		;66d7	7f 	 
	defb 03fh		;66d8	3f 	? 
	defb 03fh		;66d9	3f 	? 
	defb 01fh		;66da	1f 	. 
	defb 007h		;66db	07 	. 
	defb 015h		;66dc	15 	. 
	defb 02eh		;66dd	2e 	. 
	defb 07fh		;66de	7f 	 
	defb 0ffh		;66df	ff 	. 
	defb 0feh		;66e0	fe 	. 
	defb 0feh		;66e1	fe 	. 
	defb 0fch		;66e2	fc 	. 
	defb 0f0h		;66e3	f0 	. 
	defb 02ah		;66e4	2a 	* 
	defb 00dh		;66e5	0d 	. 
	defb 000h		;66e6	00 	. 
	defb 07fh		;66e7	7f 	 
	defb 0ffh		;66e8	ff 	. 
	defb 0ffh		;66e9	ff 	. 
	defb 0ffh		;66ea	ff 	. 
	defb 07fh		;66eb	7f 	 
	defb 0a8h		;66ec	a8 	. 
	defb 0deh		;66ed	de 	. 
	defb 07eh		;66ee	7e 	~ 
	defb 0feh		;66ef	fe 	. 
	defb 0feh		;66f0	fe 	. 
	defb 0fch		;66f1	fc 	. 
	defb 0fch		;66f2	fc 	. 
	defb 0f0h		;66f3	f0 	. 
logo_image_end:
	jp 01f09h		;66f4	c3 09 1f 	. . . 

; BLOCK 'data_66f7' (start 0x66f7 end 0x6898)
data_66f7_start:
	defb 0e0h		;66f7	e0 	. 
	defb 050h		;66f8	50 	P 
	defb 0c5h		;66f9	c5 	. 
	defb 003h		;66fa	03 	. 
	defb 001h		;66fb	01 	. 
	defb 000h		;66fc	00 	. 
	defb 000h		;66fd	00 	. 
	defb 000h		;66fe	00 	. 
	defb 040h		;66ff	40 	@ 
	defb 0a0h		;6700	a0 	. 
	defb 003h		;6701	03 	. 
	defb 08bh		;6702	8b 	. 
	defb 000h		;6703	00 	. 
	defb 000h		;6704	00 	. 
	defb 0a0h		;6705	a0 	. 
	defb 048h		;6706	48 	H 
	defb 0c4h		;6707	c4 	. 
	defb 003h		;6708	03 	. 
	defb 082h		;6709	82 	. 
	defb 000h		;670a	00 	. 
	defb 000h		;670b	00 	. 
	defb 012h		;670c	12 	. 
	defb 050h		;670d	50 	P 
	defb 0a3h		;670e	a3 	. 
	defb 003h		;670f	03 	. 
	defb 001h		;6710	01 	. 
	defb 000h		;6711	00 	. 
	defb 000h		;6712	00 	. 
	defb 000h		;6713	00 	. 
	defb 050h		;6714	50 	P 
	defb 0c1h		;6715	c1 	. 
	defb 0b2h		;6716	b2 	. 
	defb 001h		;6717	01 	. 
	defb 0f0h		;6718	f0 	. 
	defb 011h		;6719	11 	. 
	defb 020h		;671a	20 	  
	defb 050h		;671b	50 	P 
	defb 0c2h		;671c	c2 	. 
	defb 092h		;671d	92 	. 
	defb 001h		;671e	01 	. 
	defb 0eah		;671f	ea 	. 
	defb 011h		;6720	11 	. 
	defb 040h		;6721	40 	@ 
	defb 050h		;6722	50 	P 
	defb 0c3h		;6723	c3 	. 
	defb 092h		;6724	92 	. 
	defb 001h		;6725	01 	. 
	defb 0e9h		;6726	e9 	. 
	defb 011h		;6727	11 	. 
	defb 060h		;6728	60 	` 
	defb 050h		;6729	50 	P 
	defb 0c4h		;672a	c4 	. 
	defb 092h		;672b	92 	. 
	defb 001h		;672c	01 	. 
	defb 0ech		;672d	ec 	. 
	defb 011h		;672e	11 	. 
	defb 080h		;672f	80 	. 
	defb 050h		;6730	50 	P 
	defb 0c5h		;6731	c5 	. 
	defb 092h		;6732	92 	. 
	defb 001h		;6733	01 	. 
	defb 0ebh		;6734	eb 	. 
	defb 011h		;6735	11 	. 
	defb 0a0h		;6736	a0 	. 
	defb 050h		;6737	50 	P 
	defb 0c8h		;6738	c8 	. 
	defb 092h		;6739	92 	. 
	defb 001h		;673a	01 	. 
	defb 0eeh		;673b	ee 	. 
	defb 011h		;673c	11 	. 
	defb 0c0h		;673d	c0 	. 
	defb 050h		;673e	50 	P 
	defb 0cch		;673f	cc 	. 
	defb 092h		;6740	92 	. 
	defb 001h		;6741	01 	. 
	defb 0edh		;6742	ed 	. 
	defb 011h		;6743	11 	. 
	defb 080h		;6744	80 	. 
	defb 048h		;6745	48 	H 
	defb 0c9h		;6746	c9 	. 
	defb 082h		;6747	82 	. 
	defb 000h		;6748	00 	. 
	defb 0dch		;6749	dc 	. 
	defb 011h		;674a	11 	. 
	defb 0c8h		;674b	c8 	. 
	defb 050h		;674c	50 	P 
	defb 0d2h		;674d	d2 	. 
	defb 082h		;674e	82 	. 
	defb 001h		;674f	01 	. 
	defb 0dbh		;6750	db 	. 
	defb 011h		;6751	11 	. 
	defb 000h		;6752	00 	. 
	defb 048h		;6753	48 	H 
	defb 019h		;6754	19 	. 
	defb 082h		;6755	82 	. 
	defb 000h		;6756	00 	. 
	defb 0e8h		;6757	e8 	. 
	defb 011h		;6758	11 	. 
	defb 020h		;6759	20 	  
	defb 048h		;675a	48 	H 
	defb 01dh		;675b	1d 	. 
	defb 082h		;675c	82 	. 
	defb 000h		;675d	00 	. 
	defb 0e7h		;675e	e7 	. 
	defb 011h		;675f	11 	. 
	defb 040h		;6760	40 	@ 
	defb 048h		;6761	48 	H 
	defb 01ah		;6762	1a 	. 
	defb 082h		;6763	82 	. 
	defb 000h		;6764	00 	. 
	defb 0e6h		;6765	e6 	. 
	defb 011h		;6766	11 	. 
	defb 060h		;6767	60 	` 
	defb 048h		;6768	48 	H 
	defb 01eh		;6769	1e 	. 
	defb 082h		;676a	82 	. 
	defb 000h		;676b	00 	. 
	defb 0e5h		;676c	e5 	. 
	defb 011h		;676d	11 	. 
	defb 0ceh		;676e	ce 	. 
	defb 050h		;676f	50 	P 
	defb 0c6h		;6770	c6 	. 
	defb 000h		;6771	00 	. 
	defb 001h		;6772	01 	. 
	defb 0efh		;6773	ef 	. 
	defb 011h		;6774	11 	. 
	defb 0e0h		;6775	e0 	. 
	defb 040h		;6776	40 	@ 
	defb 015h		;6777	15 	. 
	defb 08ah		;6778	8a 	. 
	defb 000h		;6779	00 	. 
	defb 0efh		;677a	ef 	. 
	defb 011h		;677b	11 	. 
	defb 049h		;677c	49 	I 
	defb 050h		;677d	50 	P 
	defb 016h		;677e	16 	. 
	defb 08ah		;677f	8a 	. 
	defb 001h		;6780	01 	. 
	defb 0e9h		;6781	e9 	. 
	defb 011h		;6782	11 	. 
	defb 069h		;6783	69 	i 
	defb 050h		;6784	50 	P 
	defb 017h		;6785	17 	. 
	defb 08ah		;6786	8a 	. 
	defb 001h		;6787	01 	. 
	defb 0ebh		;6788	eb 	. 
	defb 011h		;6789	11 	. 
	defb 089h		;678a	89 	. 
	defb 050h		;678b	50 	P 
	defb 018h		;678c	18 	. 
	defb 08ah		;678d	8a 	. 
	defb 001h		;678e	01 	. 
	defb 0edh		;678f	ed 	. 
	defb 011h		;6790	11 	. 
	defb 052h		;6791	52 	R 
	defb 050h		;6792	50 	P 
	defb 023h		;6793	23 	# 
	defb 08ah		;6794	8a 	. 
	defb 001h		;6795	01 	. 
	defb 0f1h		;6796	f1 	. 
	defb 011h		;6797	11 	. 
	defb 072h		;6798	72 	r 
	defb 050h		;6799	50 	P 
	defb 01bh		;679a	1b 	. 
	defb 08ah		;679b	8a 	. 
	defb 001h		;679c	01 	. 
	defb 0e7h		;679d	e7 	. 
	defb 011h		;679e	11 	. 
	defb 092h		;679f	92 	. 
	defb 050h		;67a0	50 	P 
	defb 01ch		;67a1	1c 	. 
	defb 08ah		;67a2	8a 	. 
	defb 001h		;67a3	01 	. 
	defb 0e5h		;67a4	e5 	. 
	defb 011h		;67a5	11 	. 
	defb 0d9h		;67a6	d9 	. 
	defb 050h		;67a7	50 	P 
	defb 0d4h		;67a8	d4 	. 
	defb 08ah		;67a9	8a 	. 
	defb 001h		;67aa	01 	. 
	defb 0f3h		;67ab	f3 	. 
	defb 011h		;67ac	11 	. 
	defb 0a0h		;67ad	a0 	. 
	defb 048h		;67ae	48 	H 
	defb 0d8h		;67af	d8 	. 
	defb 081h		;67b0	81 	. 
	defb 0e0h		;67b1	e0 	. 
	defb 0f5h		;67b2	f5 	. 
	defb 011h		;67b3	11 	. 
	defb 0b1h		;67b4	b1 	. 
	defb 048h		;67b5	48 	H 
	defb 0d9h		;67b6	d9 	. 
	defb 081h		;67b7	81 	. 
	defb 0e0h		;67b8	e0 	. 
	defb 0f7h		;67b9	f7 	. 
	defb 011h		;67ba	11 	. 
	defb 008h		;67bb	08 	. 
	defb 048h		;67bc	48 	H 
	defb 026h		;67bd	26 	& 
	defb 081h		;67be	81 	. 
	defb 0e0h		;67bf	e0 	. 
	defb 0e9h		;67c0	e9 	. 
	defb 011h		;67c1	11 	. 
	defb 028h		;67c2	28 	( 
	defb 048h		;67c3	48 	H 
	defb 027h		;67c4	27 	' 
	defb 081h		;67c5	81 	. 
	defb 0e0h		;67c6	e0 	. 
	defb 0ebh		;67c7	eb 	. 
	defb 011h		;67c8	11 	. 
	defb 048h		;67c9	48 	H 
	defb 048h		;67ca	48 	H 
	defb 028h		;67cb	28 	( 
	defb 081h		;67cc	81 	. 
	defb 0e0h		;67cd	e0 	. 
	defb 0edh		;67ce	ed 	. 
	defb 011h		;67cf	11 	. 
	defb 016h		;67d0	16 	. 
	defb 050h		;67d1	50 	P 
	defb 02bh		;67d2	2b 	+ 
	defb 08dh		;67d3	8d 	. 
	defb 0e5h		;67d4	e5 	. 
	defb 0f1h		;67d5	f1 	. 
	defb 011h		;67d6	11 	. 
	defb 068h		;67d7	68 	h 
	defb 048h		;67d8	48 	H 
	defb 029h		;67d9	29 	) 
	defb 081h		;67da	81 	. 
	defb 0e0h		;67db	e0 	. 
	defb 0e7h		;67dc	e7 	. 
	defb 011h		;67dd	11 	. 
	defb 088h		;67de	88 	. 
	defb 048h		;67df	48 	H 
	defb 02ah		;67e0	2a 	* 
	defb 081h		;67e1	81 	. 
	defb 0e0h		;67e2	e0 	. 
	defb 0e5h		;67e3	e5 	. 
	defb 011h		;67e4	11 	. 
	defb 0d4h		;67e5	d4 	. 
	defb 002h		;67e6	02 	. 
	defb 0c0h		;67e7	c0 	. 
	defb 05dh		;67e8	5d 	] 
	defb 038h		;67e9	38 	8 
	defb 09ch		;67ea	9c 	. 
	defb 000h		;67eb	00 	. 
	defb 000h		;67ec	00 	. 
	defb 000h		;67ed	00 	. 
	defb 000h		;67ee	00 	. 
	defb 000h		;67ef	00 	. 
	defb 000h		;67f0	00 	. 
	defb 000h		;67f1	00 	. 
	defb 000h		;67f2	00 	. 
	defb 000h		;67f3	00 	. 
	defb 000h		;67f4	00 	. 
	defb 000h		;67f5	00 	. 
	defb 000h		;67f6	00 	. 
	defb 000h		;67f7	00 	. 
	defb 000h		;67f8	00 	. 
	defb 000h		;67f9	00 	. 
	defb 000h		;67fa	00 	. 
	defb 000h		;67fb	00 	. 
	defb 000h		;67fc	00 	. 
	defb 000h		;67fd	00 	. 
	defb 000h		;67fe	00 	. 
	defb 0d5h		;67ff	d5 	. 
	defb 002h		;6800	02 	. 
	defb 0c0h		;6801	c0 	. 
	defb 05dh		;6802	5d 	] 
	defb 038h		;6803	38 	8 
	defb 09ch		;6804	9c 	. 
	defb 000h		;6805	00 	. 
	defb 000h		;6806	00 	. 
	defb 000h		;6807	00 	. 
	defb 000h		;6808	00 	. 
	defb 000h		;6809	00 	. 
	defb 000h		;680a	00 	. 
	defb 000h		;680b	00 	. 
	defb 000h		;680c	00 	. 
	defb 000h		;680d	00 	. 
	defb 000h		;680e	00 	. 
	defb 000h		;680f	00 	. 
	defb 000h		;6810	00 	. 
	defb 000h		;6811	00 	. 
	defb 000h		;6812	00 	. 
	defb 000h		;6813	00 	. 
	defb 000h		;6814	00 	. 
	defb 000h		;6815	00 	. 
	defb 000h		;6816	00 	. 
	defb 000h		;6817	00 	. 
	defb 000h		;6818	00 	. 
	defb 000h		;6819	00 	. 
	defb 000h		;681a	00 	. 
	defb 000h		;681b	00 	. 
	defb 000h		;681c	00 	. 
	defb 000h		;681d	00 	. 
	defb 000h		;681e	00 	. 
	defb 000h		;681f	00 	. 
	defb 000h		;6820	00 	. 
	defb 000h		;6821	00 	. 
	defb 000h		;6822	00 	. 
	defb 000h		;6823	00 	. 
	defb 000h		;6824	00 	. 
	defb 000h		;6825	00 	. 
	defb 000h		;6826	00 	. 
	defb 000h		;6827	00 	. 
	defb 000h		;6828	00 	. 
	defb 000h		;6829	00 	. 
	defb 000h		;682a	00 	. 
	defb 000h		;682b	00 	. 
	defb 000h		;682c	00 	. 
	defb 000h		;682d	00 	. 
	defb 000h		;682e	00 	. 
	defb 000h		;682f	00 	. 
	defb 000h		;6830	00 	. 
	defb 000h		;6831	00 	. 
	defb 0d3h		;6832	d3 	. 
	defb 002h		;6833	02 	. 
	defb 000h		;6834	00 	. 
	defb 000h		;6835	00 	. 
	defb 000h		;6836	00 	. 
	defb 000h		;6837	00 	. 
	defb 000h		;6838	00 	. 
	defb 000h		;6839	00 	. 
	defb 000h		;683a	00 	. 
	defb 000h		;683b	00 	. 
	defb 000h		;683c	00 	. 
	defb 000h		;683d	00 	. 
	defb 000h		;683e	00 	. 
	defb 000h		;683f	00 	. 
	defb 000h		;6840	00 	. 
	defb 000h		;6841	00 	. 
	defb 000h		;6842	00 	. 
	defb 000h		;6843	00 	. 
	defb 000h		;6844	00 	. 
	defb 000h		;6845	00 	. 
	defb 000h		;6846	00 	. 
	defb 000h		;6847	00 	. 
	defb 000h		;6848	00 	. 
	defb 000h		;6849	00 	. 
	defb 000h		;684a	00 	. 
	defb 000h		;684b	00 	. 
	defb 0d2h		;684c	d2 	. 
	defb 002h		;684d	02 	. 
	defb 000h		;684e	00 	. 
	defb 000h		;684f	00 	. 
	defb 000h		;6850	00 	. 
	defb 000h		;6851	00 	. 
	defb 000h		;6852	00 	. 
	defb 000h		;6853	00 	. 
	defb 000h		;6854	00 	. 
	defb 000h		;6855	00 	. 
	defb 000h		;6856	00 	. 
	defb 000h		;6857	00 	. 
	defb 000h		;6858	00 	. 
	defb 000h		;6859	00 	. 
	defb 000h		;685a	00 	. 
	defb 000h		;685b	00 	. 
	defb 000h		;685c	00 	. 
	defb 000h		;685d	00 	. 
	defb 000h		;685e	00 	. 
	defb 000h		;685f	00 	. 
	defb 000h		;6860	00 	. 
	defb 000h		;6861	00 	. 
	defb 000h		;6862	00 	. 
	defb 000h		;6863	00 	. 
	defb 000h		;6864	00 	. 
	defb 000h		;6865	00 	. 
	defb 0d1h		;6866	d1 	. 
	defb 002h		;6867	02 	. 
	defb 000h		;6868	00 	. 
	defb 000h		;6869	00 	. 
	defb 000h		;686a	00 	. 
	defb 000h		;686b	00 	. 
	defb 000h		;686c	00 	. 
	defb 000h		;686d	00 	. 
	defb 000h		;686e	00 	. 
	defb 000h		;686f	00 	. 
	defb 000h		;6870	00 	. 
	defb 000h		;6871	00 	. 
	defb 000h		;6872	00 	. 
	defb 000h		;6873	00 	. 
	defb 000h		;6874	00 	. 
	defb 000h		;6875	00 	. 
	defb 000h		;6876	00 	. 
	defb 000h		;6877	00 	. 
	defb 000h		;6878	00 	. 
	defb 000h		;6879	00 	. 
	defb 000h		;687a	00 	. 
	defb 000h		;687b	00 	. 
	defb 000h		;687c	00 	. 
	defb 000h		;687d	00 	. 
	defb 000h		;687e	00 	. 
	defb 000h		;687f	00 	. 
	defb 0cch		;6880	cc 	. 
	defb 001h		;6881	01 	. 
	defb 000h		;6882	00 	. 
	defb 000h		;6883	00 	. 
	defb 000h		;6884	00 	. 
	defb 000h		;6885	00 	. 
	defb 000h		;6886	00 	. 
	defb 000h		;6887	00 	. 
	defb 000h		;6888	00 	. 
	defb 000h		;6889	00 	. 
	defb 000h		;688a	00 	. 
	defb 000h		;688b	00 	. 
	defb 000h		;688c	00 	. 
	defb 000h		;688d	00 	. 
	defb 000h		;688e	00 	. 
	defb 000h		;688f	00 	. 
	defb 000h		;6890	00 	. 
	defb 000h		;6891	00 	. 
	defb 000h		;6892	00 	. 
	defb 000h		;6893	00 	. 
	defb 000h		;6894	00 	. 
	defb 000h		;6895	00 	. 
	defb 000h		;6896	00 	. 
	defb 000h		;6897	00 	. 
data_66f7_end:
	call 00e8ah		;6898	cd 8a 0e 	. . . 
	xor a			;689b	af 	. 
	in a,(0feh)		;689c	db fe 	. . 
	cpl			;689e	2f 	/ 
	and 01fh		;689f	e6 1f 	. . 
	ret nz			;68a1	c0 	. 
	call 02848h		;68a2	cd 48 28 	. H ( 
	cp 004h		;68a5	fe 04 	. . 
	ret nz			;68a7	c0 	. 
	di			;68a8	f3 	. 
	call 01a40h		;68a9	cd 40 1a 	. @ . 
	ld sp,02de1h		;68ac	31 e1 2d 	1 . - 
	call 0089ah		;68af	cd 9a 08 	. . . 
	ld hl,02d3fh		;68b2	21 3f 2d 	! ? - 
	ld (hl),0c6h		;68b5	36 c6 	6 . 
	inc hl			;68b7	23 	# 
	ld a,(00b33h)		;68b8	3a 33 0b 	: 3 . 
	add a,0c7h		;68bb	c6 c7 	. . 
	ld (hl),a			;68bd	77 	w 
	inc hl			;68be	23 	# 
	ld (hl),0cch		;68bf	36 cc 	6 . 
	inc hl			;68c1	23 	# 
	ld a,(00a88h)		;68c2	3a 88 0a 	: . . 
	or a			;68c5	b7 	. 
	jr z,l68cah		;68c6	28 02 	( . 
	sub 0c7h		;68c8	d6 c7 	. . 
l68cah:
	add a,0c9h		;68ca	c6 c9 	. . 
	ld (hl),a			;68cc	77 	w 
	call 008a9h		;68cd	cd a9 08 	. . . 
	ld a,080h		;68d0	3e 80 	> . 
	ld (02d3fh),a		;68d2	32 3f 2d 	2 ? - 
	ld hl,02fafh		;68d5	21 af 2f 	! . / 
	ld (02991h),hl		;68d8	22 91 29 	" . ) 
	ld hl,02c34h		;68db	21 34 2c 	! 4 , 
	ld (022e0h),hl		;68de	22 e0 22 	" . " 
	ld hl,0251bh		;68e1	21 1b 25 	! . % 
	ld (022e3h),hl		;68e4	22 e3 22 	" . " 
	ld hl,01f0fh		;68e7	21 0f 1f 	! . . 
	ld (02079h),hl		;68ea	22 79 20 	" y   
	ld hl,001b4h		;68ed	21 b4 01 	! . . 
	push hl			;68f0	e5 	. 
	call 00fb9h		;68f1	cd b9 0f 	. . . 
	call 02848h		;68f4	cd 48 28 	. H ( 
	call 00353h		;68f7	cd 53 03 	. S . 
	call 02838h		;68fa	cd 38 28 	. 8 ( 
	ld hl,(0027bh)		;68fd	2a 7b 02 	* { . 
	ld e,020h		;6900	1e 20 	.   
	cp 071h		;6902	fe 71 	. q 
	jp z,01f09h		;6904	ca 09 1f 	. . . 
	cp 014h		;6907	fe 14 	. . 
	jp z,00ec3h		;6909	ca c3 0e 	. . . 
	cp 023h		;690c	fe 23 	. # 
	jp z,01e79h		;690e	ca 79 1e 	. y . 
	cp 03ah		;6911	fe 3a 	. : 
	jp z,0092ah		;6913	ca 2a 09 	. * . 
	cp 02ch		;6916	fe 2c 	. , 
	jp z,0073eh		;6918	ca 3e 07 	. > . 
	cp 003h		;691b	fe 03 	. . 
	jp z,01ee3h		;691d	ca e3 1e 	. . . 
	ld c,a			;6920	4f 	O 
	ld b,028h		;6921	06 28 	. ( 
	ld hl,0024ah		;6923	21 4a 02 	! J . 
	ld de,002a3h		;6926	11 a3 02 	. . . 
l6929h:
	ld a,(de)			;6929	1a 	. 
	inc de			;692a	13 	. 
	call 00e18h		;692b	cd 18 0e 	. . . 
	ld a,(de)			;692e	1a 	. 
	cp c			;692f	b9 	. 
	inc de			;6930	13 	. 
	jr z,l6939h		;6931	28 06 	( . 
	djnz l6929h		;6933	10 f4 	. . 
	ld a,c			;6935	79 	y 
	jp 006c0h		;6936	c3 c0 06 	. . . 
l6939h:
	push hl			;6939	e5 	. 
	ld hl,(0027bh)		;693a	2a 7b 02 	* { . 
	ret			;693d	c9 	. 
	call 00303h		;693e	cd 03 03 	. . . 
	call nz,02b23h		;6941	c4 23 2b 	. # + 
	dec hl			;6944	2b 	+ 
	inc hl			;6945	23 	# 
l6946h:
	ld (0027bh),hl		;6946	22 7b 02 	" { . 
	ret			;6949	c9 	. 
	ld hl,00125h		;694a	21 25 01 	! % . 
	ld a,(hl)			;694d	7e 	~ 
	or a			;694e	b7 	. 
	ret z			;694f	c8 	. 
	dec (hl)			;6950	35 	5 
	add a,a			;6951	87 	. 
	call 00e18h		;6952	cd 18 0e 	. . . 
	ld a,(hl)			;6955	7e 	~ 
	dec hl			;6956	2b 	+ 
	ld l,(hl)			;6957	6e 	n 
	ld h,a			;6958	67 	g 
	jr l6946h		;6959	18 eb 	. . 
	ld hl,00125h		;695b	21 25 01 	! % . 
	ld a,(hl)			;695e	7e 	~ 
	cp 00ah		;695f	fe 0a 	. . 
	ret nc			;6961	d0 	. 
	push hl			;6962	e5 	. 
	call 00303h		;6963	cd 03 03 	. . . 
	call nz,034e3h		;6966	c4 e3 34 	. . 4 
	ld a,(hl)			;6969	7e 	~ 
	add a,a			;696a	87 	. 
	call 00e18h		;696b	cd 18 0e 	. . . 
	ld de,00000h		;696e	11 00 00 	. . . 
	ld (hl),d			;6971	72 	r 
	dec hl			;6972	2b 	+ 
	ld (hl),e			;6973	73 	s 
	pop hl			;6974	e1 	. 
	jr l6946h		;6975	18 cf 	. . 
	call 00d96h		;6977	cd 96 0d 	. . . 
	jr l6946h		;697a	18 ca 	. . 
	call 00303h		;697c	cd 03 03 	. . . 
	jp nz,l87cdh		;697f	c2 cd 87 	. . . 
	ld c,0cdh		;6982	0e cd 	. . 
	ld c,d			;6984	4a 	J 
	inc c			;6985	0c 	. 
	call 001a4h		;6986	cd a4 01 	. . . 
	jr $-6		;6989	18 f8 	. . 
	ld ix,0000ah		;698b	dd 21 0a 00 	. ! . . 
	ld a,(ix+004h)		;698f	dd 7e 04 	. ~ . 
	and 01fh		;6992	e6 1f 	. . 
	jp 01086h		;6994	c3 86 10 	. . . 
	nop			;6997	00 	. 
	ld l,l			;6998	6d 	m 
	dec b			;6999	05 	. 
	ld a,(bc)			;699a	0a 	. 
	ld (bc),a			;699b	02 	. 
	dec c			;699c	0d 	. 
	dec b			;699d	05 	. 
	ex af,af'			;699e	08 	. 
	ld de,01c0bh		;699f	11 0b 1c 	. . . 
	add hl,bc			;69a2	09 	. 
	dec b			;69a3	05 	. 
	halt			;69a4	76 	v 
	inc b			;69a5	04 	. 
	inc h			;69a6	24 	$ 
	dec bc			;69a7	0b 	. 
	dec b			;69a8	05 	. 
	ld e,h			;69a9	5c 	\ 
	jr nz,l6a2bh		;69aa	20 7f 	   
	ld h,l			;69ac	65 	e 
	ld c,060h		;69ad	0e 60 	. ` 
	ld b,078h		;69af	06 78 	. x 
	ld de,00563h		;69b1	11 63 05 	. c . 
	ccf			;69b4	3f 	? 
	ld c,074h		;69b5	0e 74 	. t 
	inc d			;69b7	14 	. 
	ld a,01eh		;69b8	3e 1e 	> . 
	ld l,005h		;69ba	2e 05 	. . 
	ld (hl),e			;69bc	73 	s 
	dec b			;69bd	05 	. 
	ld a,h			;69be	7c 	| 
	ld b,h			;69bf	44 	D 
	ld l,d			;69c0	6a 	j 
	dec b			;69c1	05 	. 
	dec l			;69c2	2d 	- 
	dec d			;69c3	15 	. 
	ld a,c			;69c4	79 	y 
	ld l,c			;69c5	69 	i 
	ld hl,(l6412h)		;69c6	2a 12 64 	* . d 
	ld b,e			;69c9	43 	C 
	ld e,h			;69ca	5c 	\ 
	ld hl,(00877h)		;69cb	2a 77 08 	* w . 
	ld e,l			;69ce	5d 	] 
	ld a,(0165eh)		;69cf	3a 5e 16 	: ^ . 
	ld l,c			;69d2	69 	i 
	dec b			;69d3	05 	. 
	ld a,a			;69d4	7f 	 
	ld hl,00570h		;69d5	21 70 05 	! p . 
	ld (03d1bh),hl		;69d8	22 1b 3d 	" . = 
	inc b			;69db	04 	. 
	ld l,h			;69dc	6c 	l 
	ld b,c			;69dd	41 	A 
	dec sp			;69de	3b 	; 
	inc b			;69df	04 	. 
	ld l,a			;69e0	6f 	o 
	cpl			;69e1	2f 	/ 
	ld (hl),023h		;69e2	36 23 	6 # 
	ld h,a			;69e4	67 	g 
	inc h			;69e5	24 	$ 
	ld l,(hl)			;69e6	6e 	n 
	ld (0088dh),hl		;69e7	22 8d 08 	" . . 
	ld a,021h		;69ea	3e 21 	> ! 
	ld de,00001h		;69ec	11 01 00 	. . . 
	ld hl,(024adh)		;69ef	2a ad 24 	* . $ 
	ld (01c04h),hl		;69f2	22 04 1c 	" . . 
	jr l69ffh		;69f5	18 08 	. . 
	pop hl			;69f7	e1 	. 
	ld e,(hl)			;69f8	5e 	^ 
	inc hl			;69f9	23 	# 
	push hl			;69fa	e5 	. 
	ld d,001h		;69fb	16 01 	. . 
	ld a,0c3h		;69fd	3e c3 	> . 
l69ffh:
	ld (00331h),a		;69ff	32 31 03 	2 1 . 
	call 0089ah		;6a02	cd 9a 08 	. . . 
	ld (02d3fh),de		;6a05	ed 53 3f 2d 	. S ? - 
	ld (0031ah),sp		;6a09	ed 73 1a 03 	. s . . 
l6a0dh:
	ld sp,00000h		;6a0d	31 00 00 	1 . . 
	call 0251bh		;6a10	cd 1b 25 	. . % 
	ld hl,0036dh		;6a13	21 6d 03 	! m . 
	ld (022e0h),hl		;6a16	22 e0 22 	" . " 
	call 008b5h		;6a19	cd b5 08 	. . . 
	ld hl,02d40h		;6a1c	21 40 2d 	! @ - 
	call 027eeh		;6a1f	cd ee 27 	. . ' 
	cp 03ah		;6a22	fe 3a 	. : 
	ret z			;6a24	c8 	. 
	jp 013ddh		;6a25	c3 dd 13 	. . . 
	ld hl,02d3fh		;6a28	21 3f 2d 	! ? - 
l6a2bh:
	call 027eeh		;6a2b	cd ee 27 	. . ' 
	ld c,009h		;6a2e	0e 09 	. . 
	call 02127h		;6a30	cd 27 21 	. ' ! 
	call 0088ch		;6a33	cd 8c 08 	. . . 
	call 01befh		;6a36	cd ef 1b 	. . . 
	call 0088ch		;6a39	cd 8c 08 	. . . 
	call 01b1ah		;6a3c	cd 1a 1b 	. . . 
	ld hl,(01b94h)		;6a3f	2a 94 1b 	* . . 
	ld (0088dh),hl		;6a42	22 8d 08 	" . . 
	xor a			;6a45	af 	. 
	ret			;6a46	c9 	. 
	ld hl,(00003h)		;6a47	2a 03 00 	* . . 
	push af			;6a4a	f5 	. 
	ld a,l			;6a4b	7d 	} 
	and 0e0h		;6a4c	e6 e0 	. . 
	ld l,a			;6a4e	6f 	o 
	pop af			;6a4f	f1 	. 
	ret			;6a50	c9 	. 
	call 00353h		;6a51	cd 53 03 	. S . 
	call 022f7h		;6a54	cd f7 22 	. . " 
	ld h,001h		;6a57	26 01 	& . 
l6a59h:
	inc hl			;6a59	23 	# 
	ex (sp),hl			;6a5a	e3 	. 
	ex (sp),hl			;6a5b	e3 	. 
	inc h			;6a5c	24 	$ 
	dec h			;6a5d	25 	% 
	jr nz,l6a59h		;6a5e	20 f9 	  . 
	ret			;6a60	c9 	. 
	call 0035dh		;6a61	cd 5d 03 	. ] . 
	jr l6a0dh		;6a64	18 a7 	. . 
	call 002f3h		;6a66	cd f3 02 	. . . 
l6a69h:
	ld hl,(0088dh)		;6a69	2a 8d 08 	* . . 
	call 00fbch		;6a6c	cd bc 0f 	. . . 
	call 002f6h		;6a6f	cd f6 02 	. . . 
	jr l6a69h		;6a72	18 f5 	. . 
	ld hl,00b33h		;6a74	21 33 0b 	! 3 . 
l6a77h:
	jp 01e81h		;6a77	c3 81 1e 	. . . 
	ld hl,00a88h		;6a7a	21 88 0a 	! . . 
	ld a,(hl)			;6a7d	7e 	~ 
	or a			;6a7e	b7 	. 
	jr nz,l6a83h		;6a7f	20 02 	  . 
	ld a,0c7h		;6a81	3e c7 	> . 
l6a83h:
	inc a			;6a83	3c 	< 
	cp 0cah		;6a84	fe ca 	. . 
	jr nz,l6a89h		;6a86	20 01 	  . 
	xor a			;6a88	af 	. 
l6a89h:
	ld (hl),a			;6a89	77 	w 
	ret			;6a8a	c9 	. 
	ld hl,00d2eh		;6a8b	21 2e 0d 	! . . 
	jr l6a77h		;6a8e	18 e7 	. . 
	ld hl,00cd1h		;6a90	21 d1 0c 	! . . 
	ld a,(hl)			;6a93	7e 	~ 
	or a			;6a94	b7 	. 
	jr nz,l6a99h		;6a95	20 02 	  . 
	ld a,003h		;6a97	3e 03 	> . 
l6a99h:
	dec a			;6a99	3d 	= 
	ld (hl),a			;6a9a	77 	w 
	out (0feh),a		;6a9b	d3 fe 	. . 
	ret			;6a9d	c9 	. 
l6a9eh:
	call 00927h		;6a9e	cd 27 09 	. ' . 
	call c,00fb9h		;6aa1	dc b9 0f 	. . . 
	call 01f54h		;6aa4	cd 54 1f 	. T . 
	jr c,l6a9eh		;6aa7	38 f5 	8 . 
l6aa9h:
	xor a			;6aa9	af 	. 
	in a,(0feh)		;6aaa	db fe 	. . 
	cpl			;6aac	2f 	/ 
	and 01fh		;6aad	e6 1f 	. . 
	jr nz,l6aa9h		;6aaf	20 f8 	  . 
	ret			;6ab1	c9 	. 
	call 00303h		;6ab2	cd 03 03 	. . . 
	jp 0cf22h		;6ab5	c3 22 cf 	. " . 
	inc bc			;6ab8	03 	. 
l6ab9h:
	call 00927h		;6ab9	cd 27 09 	. ' . 
	call nc,00fb9h		;6abc	d4 b9 0f 	. . . 
	ld hl,(0027bh)		;6abf	2a 7b 02 	* { . 
	ld de,00000h		;6ac2	11 00 00 	. . . 
	or a			;6ac5	b7 	. 
	sbc hl,de		;6ac6	ed 52 	. R 
	ret z			;6ac8	c8 	. 
	call 01f54h		;6ac9	cd 54 1f 	. T . 
	jr nc,l6aa9h		;6acc	30 db 	0 . 
	jr l6ab9h		;6ace	18 e9 	. . 
	ld hl,010a6h		;6ad0	21 a6 10 	! . . 
	jr l6a77h		;6ad3	18 a2 	. . 
	call 008e8h		;6ad5	cd e8 08 	. . . 
	jr l6addh		;6ad8	18 03 	. . 
	call 008dbh		;6ada	cd db 08 	. . . 
l6addh:
	push hl			;6add	e5 	. 
	push de			;6ade	d5 	. 
	call 00303h		;6adf	cd 03 03 	. . . 
	exx			;6ae2	d9 	. 
	xor 03ah		;6ae3	ee 3a 	. : 
	jr nz,l6b0ah		;6ae5	20 23 	  # 
	ld ix,02d11h		;6ae7	dd 21 11 2d 	. ! . - 
	ld (ix+000h),003h		;6aeb	dd 36 00 03 	. 6 . . 
	ld de,02d12h		;6aef	11 12 2d 	. . - 
	inc hl			;6af2	23 	# 
	call 018ffh		;6af3	cd ff 18 	. . . 
	pop de			;6af6	d1 	. 
	pop hl			;6af7	e1 	. 
	push hl			;6af8	e5 	. 
	push de			;6af9	d5 	. 
	or a			;6afa	b7 	. 
	sbc hl,de		;6afb	ed 52 	. R 
	inc hl			;6afd	23 	# 
	ld (02d1eh),de		;6afe	ed 53 1e 2d 	. S . - 
	ld (02d1ch),hl		;6b02	22 1c 2d 	" . - 
	call 018dah		;6b05	cd da 18 	. . . 
	ld l,0ffh		;6b08	2e ff 	. . 
l6b0ah:
	call 0041ch		;6b0a	cd 1c 04 	. . . 
	jp 004c6h		;6b0d	c3 c6 04 	. . . 
	ld a,l			;6b10	7d 	} 
	pop bc			;6b11	c1 	. 
	pop de			;6b12	d1 	. 
	pop hl			;6b13	e1 	. 
	push bc			;6b14	c5 	. 
	or a			;6b15	b7 	. 
	sbc hl,de		;6b16	ed 52 	. R 
	inc hl			;6b18	23 	# 
	ex de,hl			;6b19	eb 	. 
	push hl			;6b1a	e5 	. 
	pop ix		;6b1b	dd e1 	. . 
	ret			;6b1d	c9 	. 
	call 008e8h		;6b1e	cd e8 08 	. . . 
	jr l6b26h		;6b21	18 03 	. . 
	call 008dbh		;6b23	cd db 08 	. . . 
l6b26h:
	call 008f3h		;6b26	cd f3 08 	. . . 
	call 00303h		;6b29	cd 03 03 	. . . 
	exx			;6b2c	d9 	. 
l6b2dh:
	call 0041ch		;6b2d	cd 1c 04 	. . . 
	scf			;6b30	37 	7 
	call 01df1h		;6b31	cd f1 1d 	. . . 
	ret c			;6b34	d8 	. 
	jp 00904h		;6b35	c3 04 09 	. . . 
	call 00e87h		;6b38	cd 87 0e 	. . . 
	ld ix,02d3fh		;6b3b	dd 21 3f 2d 	. ! ? - 
	ld de,00012h		;6b3f	11 12 00 	. . . 
	xor a			;6b42	af 	. 
	scf			;6b43	37 	7 
	ex af,af'			;6b44	08 	. 
	ld a,00fh		;6b45	3e 0f 	> . 
	out (0feh),a		;6b47	d3 fe 	. . 
	call 00562h		;6b49	cd 62 05 	. b . 
	ld ix,02ce8h		;6b4c	dd 21 e8 2c 	. ! . , 
	jr c,l6b5dh		;6b50	38 0b 	8 . 
	ld hl,(02d3fh)		;6b52	2a 3f 2d 	* ? - 
	ld h,000h		;6b55	26 00 	& . 
	call 00d42h		;6b57	cd 42 0d 	. B . 
	jp 00e8ah		;6b5a	c3 8a 0e 	. . . 
l6b5dh:
	ld hl,02d40h		;6b5d	21 40 2d 	! @ - 
	ld a,(hl)			;6b60	7e 	~ 
	add a,030h		;6b61	c6 30 	. 0 
	ld (ix-003h),a		;6b63	dd 77 fd 	. w . 
	ld b,00ah		;6b66	06 0a 	. . 
l6b68h:
	inc hl			;6b68	23 	# 
	ld a,(hl)			;6b69	7e 	~ 
	cp 020h		;6b6a	fe 20 	.   
	jr nc,l6b70h		;6b6c	30 02 	0 . 
	ld a,03fh		;6b6e	3e 3f 	> ? 
l6b70h:
	ld (ix+000h),a		;6b70	dd 77 00 	. w . 
	inc ix		;6b73	dd 23 	. # 
	djnz l6b68h		;6b75	10 f1 	. . 
	inc ix		;6b77	dd 23 	. # 
	ld hl,(02d4dh)		;6b79	2a 4d 2d 	* M - 
	push hl			;6b7c	e5 	. 
	call 00d3ch		;6b7d	cd 3c 0d 	. < . 
	ld hl,(02d4bh)		;6b80	2a 4b 2d 	* K - 
	push hl			;6b83	e5 	. 
	call 00d3ch		;6b84	cd 3c 0d 	. < . 
	ld hl,(02d4fh)		;6b87	2a 4f 2d 	* O - 
	call 00d3ch		;6b8a	cd 3c 0d 	. < . 
	call 00e8ah		;6b8d	cd 8a 0e 	. . . 
	call 02848h		;6b90	cd 48 28 	. H ( 
	pop hl			;6b93	e1 	. 
	pop de			;6b94	d1 	. 
	cp 06ah		;6b95	fe 6a 	. j 
	ret nz			;6b97	c0 	. 
	add hl,de			;6b98	19 	. 
	dec hl			;6b99	2b 	+ 
	call 008f3h		;6b9a	cd f3 08 	. . . 
	ld l,0ffh		;6b9d	2e ff 	. . 
	jr l6b2dh		;6b9f	18 8c 	. . 
	ld b,008h		;6ba1	06 08 	. . 
	ld hl,011e9h		;6ba3	21 e9 11 	! . . 
	ld de,011ddh		;6ba6	11 dd 11 	. . . 
l6ba9h:
	ld c,(hl)			;6ba9	4e 	N 
	ld a,(de)			;6baa	1a 	. 
	ld (hl),a			;6bab	77 	w 
	ld a,c			;6bac	79 	y 
	ld (de),a			;6bad	12 	. 
	inc hl			;6bae	23 	# 
	inc de			;6baf	13 	. 
	djnz l6ba9h		;6bb0	10 f7 	. . 
	ret			;6bb2	c9 	. 
	ld hl,01572h		;6bb3	21 72 15 	! r . 
l6bb6h:
	ld (004e4h),hl		;6bb6	22 e4 04 	" . . 
	ld hl,004f6h		;6bb9	21 f6 04 	! . . 
	ld (02079h),hl		;6bbc	22 79 20 	" y   
	call 008e8h		;6bbf	cd e8 08 	. . . 
	push hl			;6bc2	e5 	. 
	ld hl,004f7h		;6bc3	21 f7 04 	! . . 
	ld (022e0h),hl		;6bc6	22 e0 22 	" . " 
	pop hl			;6bc9	e1 	. 
	ex de,hl			;6bca	eb 	. 
l6bcbh:
	push de			;6bcb	d5 	. 
	call 00c4ah		;6bcc	cd 4a 0c 	. J . 
	call 00e8ah		;6bcf	cd 8a 0e 	. . . 
	push hl			;6bd2	e5 	. 
	ld (004f8h),sp		;6bd3	ed 73 f8 04 	. s . . 
	call 00052h		;6bd7	cd 52 00 	. R . 
	di			;6bda	f3 	. 
l6bdbh:
	pop hl			;6bdb	e1 	. 
	pop de			;6bdc	d1 	. 
	call 0099dh		;6bdd	cd 9d 09 	. . . 
	jp nc,003b5h		;6be0	d2 b5 03 	. . . 
	push hl			;6be3	e5 	. 
	or a			;6be4	b7 	. 
	sbc hl,de		;6be5	ed 52 	. R 
	pop hl			;6be7	e1 	. 
	jr c,l6bcbh		;6be8	38 e1 	8 . 
	ret			;6bea	c9 	. 
	ld sp,00000h		;6beb	31 00 00 	1 . . 
	call 008b5h		;6bee	cd b5 08 	. . . 
	call 0051ch		;6bf1	cd 1c 05 	. . . 
	jr l6bdbh		;6bf4	18 e5 	. . 
	ld hl,004f6h		;6bf6	21 f6 04 	! . . 
	ld (02079h),hl		;6bf9	22 79 20 	" y   
	xor a			;6bfc	af 	. 
	ld (00d2eh),a		;6bfd	32 2e 0d 	2 . . 
	ld hl,00511h		;6c00	21 11 05 	! . . 
	jr l6bb6h		;6c03	18 b1 	. . 
	ld hl,02ce5h		;6c05	21 e5 2c 	! . , 
	ld de,02d3fh		;6c08	11 3f 2d 	. ? - 
	ld bc,00020h		;6c0b	01 20 00 	.   . 
	ldir		;6c0e	ed b0 	. . 
	call 0251bh		;6c10	cd 1b 25 	. . % 
	ld hl,02d3fh		;6c13	21 3f 2d 	! ? - 
	call 027eeh		;6c16	cd ee 27 	. . ' 
	ld d,000h		;6c19	16 00 	. . 
	ld c,009h		;6c1b	0e 09 	. . 
	jp 02047h		;6c1d	c3 47 20 	. G   
	cp 077h		;6c20	fe 77 	. w 
	jr nz,l6c28h		;6c22	20 04 	  . 
	ld (00553h),hl		;6c24	22 53 05 	" S . 
	ret			;6c27	c9 	. 
l6c28h:
	push hl			;6c28	e5 	. 
	ld (01b75h),hl		;6c29	22 75 1b 	" u . 
	ld de,0056bh		;6c2c	11 6b 05 	. k . 
	push de			;6c2f	d5 	. 
	call 0055ah		;6c30	cd 5a 05 	. Z . 
	ld hl,001b4h		;6c33	21 b4 01 	! . . 
	ld (022e0h),hl		;6c36	22 e0 22 	" . " 
	ld a,0c3h		;6c39	3e c3 	> . 
	call 01b71h		;6c3b	cd 71 1b 	. q . 
	ld bc,009ech		;6c3e	01 ec 09 	. . . 
	call 01ba2h		;6c41	cd a2 1b 	. . . 
	ld c,0c3h		;6c44	0e c3 	. . 
	ld de,009ech		;6c46	11 ec 09 	. . . 
	call 00575h		;6c49	cd 75 05 	. u . 
	pop hl			;6c4c	e1 	. 
	pop de			;6c4d	d1 	. 
	ld bc,00003h		;6c4e	01 03 00 	. . . 
	ldir		;6c51	ed b0 	. . 
	ld a,0ffh		;6c53	3e ff 	> . 
	ld hl,011dbh		;6c55	21 db 11 	! . . 
	add a,(hl)			;6c58	86 	. 
	xor (hl)			;6c59	ae 	. 
	and 07fh		;6c5a	e6 7f 	.  
	xor (hl)			;6c5c	ae 	. 
	ld (hl),a			;6c5d	77 	w 
	ret			;6c5e	c9 	. 
	nop			;6c5f	00 	. 
	nop			;6c60	00 	. 
	nop			;6c61	00 	. 
	call 00303h		;6c62	cd 03 03 	. . . 
	call z,00eebh		;6c65	cc eb 0e 	. . . 
	call 014cdh		;6c68	cd cd 14 	. . . 
	dec bc			;6c6b	0b 	. 
	ld (hl),c			;6c6c	71 	q 
	inc hl			;6c6d	23 	# 
	ld (hl),e			;6c6e	73 	s 
	inc hl			;6c6f	23 	# 
	ld (hl),d			;6c70	72 	r 
	inc hl			;6c71	23 	# 
	call 00b03h		;6c72	cd 03 0b 	. . . 
	jp 009a2h		;6c75	c3 a2 09 	. . . 
	call 008e8h		;6c78	cd e8 08 	. . . 
	jr l6c80h		;6c7b	18 03 	. . 
	call 008dbh		;6c7d	cd db 08 	. . . 
l6c80h:
	push hl			;6c80	e5 	. 
	push de			;6c81	d5 	. 
	call 00303h		;6c82	cd 03 03 	. . . 
	ret c			;6c85	d8 	. 
	pop de			;6c86	d1 	. 
	pop bc			;6c87	c1 	. 
	push de			;6c88	d5 	. 
	push hl			;6c89	e5 	. 
	or a			;6c8a	b7 	. 
	sbc hl,de		;6c8b	ed 52 	. R 
	add hl,bc			;6c8d	09 	. 
	pop bc			;6c8e	c1 	. 
	call 008f9h		;6c8f	cd f9 08 	. . . 
	ex de,hl			;6c92	eb 	. 
	sbc hl,bc		;6c93	ed 42 	. B 
	inc hl			;6c95	23 	# 
	ld d,b			;6c96	50 	P 
	ld e,c			;6c97	59 	Y 
	ld b,h			;6c98	44 	D 
	ld c,l			;6c99	4d 	M 
	pop hl			;6c9a	e1 	. 
	jp 02b2ch		;6c9b	c3 2c 2b 	. , + 
	call 008e8h		;6c9e	cd e8 08 	. . . 
	jr l6ca6h		;6ca1	18 03 	. . 
	call 008dbh		;6ca3	cd db 08 	. . . 
l6ca6h:
	call 008f3h		;6ca6	cd f3 08 	. . . 
	call 00303h		;6ca9	cd 03 03 	. . . 
	rst 10h			;6cac	d7 	. 
	ld a,l			;6cad	7d 	} 
	pop de			;6cae	d1 	. 
	pop hl			;6caf	e1 	. 
	or a			;6cb0	b7 	. 
	sbc hl,de		;6cb1	ed 52 	. R 
	ld (de),a			;6cb3	12 	. 
	ret z			;6cb4	c8 	. 
	ld b,h			;6cb5	44 	D 
	ld c,l			;6cb6	4d 	M 
	ex de,hl			;6cb7	eb 	. 
	ld d,h			;6cb8	54 	T 
	ld e,l			;6cb9	5d 	] 
	inc de			;6cba	13 	. 
	ldir		;6cbb	ed b0 	. . 
	ret			;6cbd	c9 	. 
	call 00303h		;6cbe	cd 03 03 	. . . 
	jp nz,l87cdh		;6cc1	c2 cd 87 	. . . 
	ld c,0ddh		;6cc4	0e dd 	. . 
	ld hl,02ce5h		;6cc6	21 e5 2c 	! . , 
	push hl			;6cc9	e5 	. 
	call 02b48h		;6cca	cd 48 2b 	. H + 
	pop hl			;6ccd	e1 	. 
	inc ix		;6cce	dd 23 	. # 
	inc ix		;6cd0	dd 23 	. # 
	push hl			;6cd2	e5 	. 
	ld bc,00500h		;6cd3	01 00 05 	. . . 
l6cd6h:
	push hl			;6cd6	e5 	. 
	ld l,(hl)			;6cd7	6e 	n 
	ld h,000h		;6cd8	26 00 	& . 
	ld a,(02b49h)		;6cda	3a 49 2b 	: I + 
	push bc			;6cdd	c5 	. 
	or a			;6cde	b7 	. 
	jr z,l6cech		;6cdf	28 0b 	( . 
	ld (ix+000h),023h		;6ce1	dd 36 00 23 	. 6 . # 
	inc ix		;6ce5	dd 23 	. # 
	call 02b5eh		;6ce7	cd 5e 2b 	. ^ + 
	jr l6cefh		;6cea	18 03 	. . 
l6cech:
	call 02b72h		;6cec	cd 72 2b 	. r + 
l6cefh:
	pop bc			;6cef	c1 	. 
	inc ix		;6cf0	dd 23 	. # 
	pop hl			;6cf2	e1 	. 
	inc hl			;6cf3	23 	# 
	djnz l6cd6h		;6cf4	10 e0 	. . 
	pop hl			;6cf6	e1 	. 
	ld b,005h		;6cf7	06 05 	. . 
l6cf9h:
	call 0062fh		;6cf9	cd 2f 06 	. / . 
	djnz l6cf9h		;6cfc	10 fb 	. . 
	call 001a4h		;6cfe	cd a4 01 	. . . 
	jr $-60		;6d01	18 c2 	. . 
	call 00303h		;6d03	cd 03 03 	. . . 
	jp nz,l87cdh		;6d06	c2 cd 87 	. . . 
	ld c,0ddh		;6d09	0e dd 	. . 
	ld hl,02ce5h		;6d0b	21 e5 2c 	! . , 
	push hl			;6d0e	e5 	. 
	call 00d3eh		;6d0f	cd 3e 0d 	. > . 
	pop hl			;6d12	e1 	. 
	inc ix		;6d13	dd 23 	. # 
	inc ix		;6d15	dd 23 	. # 
	ld b,019h		;6d17	06 19 	. . 
l6d19h:
	call 0062fh		;6d19	cd 2f 06 	. / . 
	djnz l6d19h		;6d1c	10 fb 	. . 
	call 001a4h		;6d1e	cd a4 01 	. . . 
	jr $-23		;6d21	18 e7 	. . 
	ld a,(hl)			;6d23	7e 	~ 
	and 07fh		;6d24	e6 7f 	.  
	cp 020h		;6d26	fe 20 	.   
	ld a,(hl)			;6d28	7e 	~ 
	inc hl			;6d29	23 	# 
	jr nc,l6d30h		;6d2a	30 04 	0 . 
	and 080h		;6d2c	e6 80 	. . 
	or 02eh		;6d2e	f6 2e 	. . 
l6d30h:
	ld (ix+000h),a		;6d30	dd 77 00 	. w . 
	inc ix		;6d33	dd 23 	. # 
	ret			;6d35	c9 	. 
	ld hl,0018dh		;6d36	21 8d 01 	! . . 
l6d39h:
	push hl			;6d39	e5 	. 
	call 00801h		;6d3a	cd 01 08 	. . . 
	pop hl			;6d3d	e1 	. 
	jr nz,l6d96h		;6d3e	20 56 	  V 
	ld a,(hl)			;6d40	7e 	~ 
	cp 00bh		;6d41	fe 0b 	. . 
	ret nc			;6d43	d0 	. 
	push hl			;6d44	e5 	. 
	dec a			;6d45	3d 	= 
	add a,a			;6d46	87 	. 
	call 00e18h		;6d47	cd 18 0e 	. . . 
	inc hl			;6d4a	23 	# 
	push hl			;6d4b	e5 	. 
	call 00303h		;6d4c	cd 03 03 	. . . 
	call z,0e1ebh		;6d4f	cc eb e1 	. . . 
	ld (hl),e			;6d52	73 	s 
	inc hl			;6d53	23 	# 
	ld (hl),d			;6d54	72 	r 
	pop hl			;6d55	e1 	. 
	inc (hl)			;6d56	34 	4 
	jr l6d39h		;6d57	18 e0 	. . 
	ld a,031h		;6d59	3e 31 	> 1 
	ld (01373h),a		;6d5b	32 73 13 	2 s . 
	ld b,005h		;6d5e	06 05 	. . 
	ld hl,0070eh		;6d60	21 0e 07 	! . . 
l6d63h:
	push bc			;6d63	c5 	. 
	push hl			;6d64	e5 	. 
	call 00303h		;6d65	cd 03 03 	. . . 
	jp c,03aeeh		;6d68	da ee 3a 	. . : 
	ld c,000h		;6d6b	0e 00 	. . 
	jr z,l6d70h		;6d6d	28 01 	( . 
	dec c			;6d6f	0d 	. 
l6d70h:
	ld b,l			;6d70	45 	E 
	ld hl,01373h		;6d71	21 73 13 	! s . 
	inc (hl)			;6d74	34 	4 
	pop hl			;6d75	e1 	. 
	ld (hl),b			;6d76	70 	p 
	inc hl			;6d77	23 	# 
	ld (hl),c			;6d78	71 	q 
	inc hl			;6d79	23 	# 
	pop bc			;6d7a	c1 	. 
	djnz l6d63h		;6d7b	10 e6 	. . 
	ld de,(0027bh)		;6d7d	ed 5b 7b 02 	. [ { . 
	inc de			;6d81	13 	. 
l6d82h:
	push de			;6d82	d5 	. 
	ld hl,0070eh		;6d83	21 0e 07 	! . . 
	ld b,005h		;6d86	06 05 	. . 
l6d88h:
	ld a,(de)			;6d88	1a 	. 
	inc de			;6d89	13 	. 
	xor (hl)			;6d8a	ae 	. 
	inc hl			;6d8b	23 	# 
	and (hl)			;6d8c	a6 	. 
	inc hl			;6d8d	23 	# 
	jr nz,l6df1h		;6d8e	20 61 	  a 
	djnz l6d88h		;6d90	10 f6 	. . 
	pop hl			;6d92	e1 	. 
	jp 00252h		;6d93	c3 52 02 	. R . 
l6d96h:
	sub 02fh		;6d96	d6 2f 	. / 
	cp (hl)			;6d98	be 	. 
	jr nc,l6d39h		;6d99	30 9e 	0 . 
	dec a			;6d9b	3d 	= 
	add a,a			;6d9c	87 	. 
	ld b,a			;6d9d	47 	G 
	ld a,015h		;6d9e	3e 15 	> . 
	sub b			;6da0	90 	. 
	ld c,a			;6da1	4f 	O 
	ld a,b			;6da2	78 	x 
	ld b,000h		;6da3	06 00 	. . 
	push hl			;6da5	e5 	. 
	call 00e18h		;6da6	cd 18 0e 	. . . 
	inc hl			;6da9	23 	# 
	ld d,h			;6daa	54 	T 
	ld e,l			;6dab	5d 	] 
	inc hl			;6dac	23 	# 
	inc hl			;6dad	23 	# 
	ldir		;6dae	ed b0 	. . 
	pop hl			;6db0	e1 	. 
	dec (hl)			;6db1	35 	5 
	jr l6d39h		;6db2	18 85 	. . 
	cp 031h		;6db4	fe 31 	. 1 
	ret c			;6db6	d8 	. 
	cp 036h		;6db7	fe 36 	. 6 
	ret nc			;6db9	d0 	. 
	sub 031h		;6dba	d6 31 	. 1 
	add a,a			;6dbc	87 	. 
	ld hl,00704h		;6dbd	21 04 07 	! . . 
	call 00e18h		;6dc0	cd 18 0e 	. . . 
	ld e,(hl)			;6dc3	5e 	^ 
	inc hl			;6dc4	23 	# 
	ld d,(hl)			;6dc5	56 	V 
	ex de,hl			;6dc6	eb 	. 
l6dc7h:
	push hl			;6dc7	e5 	. 
	call 007fbh		;6dc8	cd fb 07 	. . . 
	pop hl			;6dcb	e1 	. 
	jr nz,l6e0ch		;6dcc	20 3e 	  > 
	ld a,(hl)			;6dce	7e 	~ 
	cp 007h		;6dcf	fe 07 	. . 
	ret nc			;6dd1	d0 	. 
	push hl			;6dd2	e5 	. 
	dec a			;6dd3	3d 	= 
	add a,a			;6dd4	87 	. 
	add a,a			;6dd5	87 	. 
	call 00e18h		;6dd6	cd 18 0e 	. . . 
	inc hl			;6dd9	23 	# 
	push hl			;6dda	e5 	. 
	call 008e8h		;6ddb	cd e8 08 	. . . 
	push hl			;6dde	e5 	. 
	or a			;6ddf	b7 	. 
	sbc hl,de		;6de0	ed 52 	. R 
	pop bc			;6de2	c1 	. 
	pop hl			;6de3	e1 	. 
	ld (hl),e			;6de4	73 	s 
	inc hl			;6de5	23 	# 
	ld (hl),d			;6de6	72 	r 
	inc hl			;6de7	23 	# 
	ld (hl),c			;6de8	71 	q 
	inc hl			;6de9	23 	# 
	ld (hl),b			;6dea	70 	p 
	pop hl			;6deb	e1 	. 
	jr c,l6dc7h		;6dec	38 d9 	8 . 
	inc (hl)			;6dee	34 	4 
	jr l6dc7h		;6def	18 d6 	. . 
l6df1h:
	pop de			;6df1	d1 	. 
	inc de			;6df2	13 	. 
	ld a,d			;6df3	7a 	z 
	or e			;6df4	b3 	. 
	ret z			;6df5	c8 	. 
	jr l6d82h		;6df6	18 8a 	. . 
	jp p,00c00h		;6df8	f2 00 0c 	. . . 
	ld bc,0013fh		;6dfb	01 3f 01 	. ? . 
	ld e,c			;6dfe	59 	Y 
	ld bc,00173h		;6dff	01 73 01 	. s . 
	nop			;6e02	00 	. 
	nop			;6e03	00 	. 
	nop			;6e04	00 	. 
	nop			;6e05	00 	. 
	nop			;6e06	00 	. 
	nop			;6e07	00 	. 
	nop			;6e08	00 	. 
	nop			;6e09	00 	. 
	nop			;6e0a	00 	. 
	nop			;6e0b	00 	. 
l6e0ch:
	sub 02eh		;6e0c	d6 2e 	. . 
	cp (hl)			;6e0e	be 	. 
	jr nc,l6dc7h		;6e0f	30 b6 	0 . 
	dec a			;6e11	3d 	= 
	add a,a			;6e12	87 	. 
	add a,a			;6e13	87 	. 
	ld b,a			;6e14	47 	G 
	ld a,015h		;6e15	3e 15 	> . 
	sub b			;6e17	90 	. 
	ld c,a			;6e18	4f 	O 
	ld a,b			;6e19	78 	x 
	ld b,000h		;6e1a	06 00 	. . 
	push hl			;6e1c	e5 	. 
	call 00e18h		;6e1d	cd 18 0e 	. . . 
	inc hl			;6e20	23 	# 
	ld d,h			;6e21	54 	T 
	ld e,l			;6e22	5d 	] 
	inc hl			;6e23	23 	# 
	inc hl			;6e24	23 	# 
	inc hl			;6e25	23 	# 
	inc hl			;6e26	23 	# 
	ldir		;6e27	ed b0 	. . 
	pop hl			;6e29	e1 	. 
	dec (hl)			;6e2a	35 	5 
	jr l6dc7h		;6e2b	18 9a 	. . 
	call 0035dh		;6e2d	cd 5d 03 	. ] . 
	jr l6e45h		;6e30	18 13 	. . 
	call 0089ah		;6e32	cd 9a 08 	. . . 
	ld hl,001c5h		;6e35	21 c5 01 	! . . 
	ld (02d3fh),hl		;6e38	22 3f 2d 	" ? - 
	ld hl,00739h		;6e3b	21 39 07 	! 9 . 
	ld (022e0h),hl		;6e3e	22 e0 22 	" . " 
	ld (00752h),sp		;6e41	ed 73 52 07 	. s R . 
l6e45h:
	ld sp,00000h		;6e45	31 00 00 	1 . . 
	call 0251bh		;6e48	cd 1b 25 	. . % 
	call 008b5h		;6e4b	cd b5 08 	. . . 
	ld b,018h		;6e4e	06 18 	. . 
	ld ix,0001fh		;6e50	dd 21 1f 00 	. ! . . 
l6e54h:
	ld hl,02d40h		;6e54	21 40 2d 	! @ - 
	call 027eeh		;6e57	cd ee 27 	. . ' 
	ld a,(ix+002h)		;6e5a	dd 7e 02 	. ~ . 
	bit 7,a		;6e5d	cb 7f 	.  
	jr nz,l6e73h		;6e5f	20 12 	  . 
	ld de,02ff4h		;6e61	11 f4 2f 	. . / 
	call 02509h		;6e64	cd 09 25 	. . % 
	ld a,(de)			;6e67	1a 	. 
	xor (hl)			;6e68	ae 	. 
	and 05fh		;6e69	e6 5f 	. _ 
	jr nz,l6e80h		;6e6b	20 13 	  . 
	inc de			;6e6d	13 	. 
	inc hl			;6e6e	23 	# 
	call 027eeh		;6e6f	cd ee 27 	. . ' 
	ld a,(de)			;6e72	1a 	. 
l6e73h:
	xor (hl)			;6e73	ae 	. 
	and 05fh		;6e74	e6 5f 	. _ 
	jr nz,l6e80h		;6e76	20 08 	  . 
	inc hl			;6e78	23 	# 
	call 027eeh		;6e79	cd ee 27 	. . ' 
	cp 041h		;6e7c	fe 41 	. A 
	jr c,l6eafh		;6e7e	38 2f 	8 / 
l6e80h:
	ld de,00007h		;6e80	11 07 00 	. . . 
	add ix,de		;6e83	dd 19 	. . 
	djnz l6e54h		;6e85	10 cd 	. . 
	jp 022c1h		;6e87	c3 c1 22 	. . " 
l6e8ah:
	call 027eeh		;6e8a	cd ee 27 	. . ' 
	or 020h		;6e8d	f6 20 	.   
	push hl			;6e8f	e5 	. 
	ld hl,007abh		;6e90	21 ab 07 	! . . 
	ld b,004h		;6e93	06 04 	. . 
l6e95h:
	cp (hl)			;6e95	be 	. 
	inc hl			;6e96	23 	# 
	jr z,$+16		;6e97	28 0e 	( . 
	inc hl			;6e99	23 	# 
	djnz l6e95h		;6e9a	10 f9 	. . 
	pop hl			;6e9c	e1 	. 
	jr l6eb7h		;6e9d	18 18 	. . 
	ld (hl),e			;6e9f	73 	s 
	add a,b			;6ea0	80 	. 
	ld a,d			;6ea1	7a 	z 
	ld b,b			;6ea2	40 	@ 
	ld (hl),b			;6ea3	70 	p 
	inc b			;6ea4	04 	. 
	ld h,e			;6ea5	63 	c 
	ld bc,0ef11h		;6ea6	01 11 ef 	. . . 
	ld de,0ae1ah		;6ea9	11 1a ae 	. . . 
	ld (de),a			;6eac	12 	. 
	pop hl			;6ead	e1 	. 
	ret			;6eae	c9 	. 
l6eafh:
	inc hl			;6eaf	23 	# 
	ld a,(ix+002h)		;6eb0	dd 7e 02 	. ~ . 
	cp 0c6h		;6eb3	fe c6 	. . 
	jr z,l6e8ah		;6eb5	28 d3 	( . 
l6eb7h:
	push ix		;6eb7	dd e5 	. . 
	call 013e0h		;6eb9	cd e0 13 	. . . 
	pop ix		;6ebc	dd e1 	. . 
	ex de,hl			;6ebe	eb 	. 
	ld l,(ix+005h)		;6ebf	dd 6e 05 	. n . 
	ld h,(ix+006h)		;6ec2	dd 66 06 	. f . 
	ld a,(ix+002h)		;6ec5	dd 7e 02 	. ~ . 
	cp 0d8h		;6ec8	fe d8 	. . 
	jr nc,l6ed2h		;6eca	30 06 	0 . 
	bit 3,(ix+003h)		;6ecc	dd cb 03 5e 	. . . ^ 
	jr z,l6ed5h		;6ed0	28 03 	( . 
l6ed2h:
	inc hl			;6ed2	23 	# 
	ld (hl),d			;6ed3	72 	r 
	dec hl			;6ed4	2b 	+ 
l6ed5h:
	ld (hl),e			;6ed5	73 	s 
	ret			;6ed6	c9 	. 
	ld b,000h		;6ed7	06 00 	. . 
	push hl			;6ed9	e5 	. 
	ld hl,01210h		;6eda	21 10 12 	! . . 
	add hl,bc			;6edd	09 	. 
	ld c,(hl)			;6ede	4e 	N 
	add hl,bc			;6edf	09 	. 
l6ee0h:
	ld a,(hl)			;6ee0	7e 	~ 
	cp 080h		;6ee1	fe 80 	. . 
	res 7,a		;6ee3	cb bf 	. . 
	ld (de),a			;6ee5	12 	. 
	inc de			;6ee6	13 	. 
	inc hl			;6ee7	23 	# 
	jr c,l6ee0h		;6ee8	38 f6 	8 . 
	xor a			;6eea	af 	. 
	ld (de),a			;6eeb	12 	. 
	inc de			;6eec	13 	. 
	pop hl			;6eed	e1 	. 
	ret			;6eee	c9 	. 
	ld a,037h		;6eef	3e 37 	> 7 
	ld c,035h		;6ef1	0e 35 	. 5 
	jr l6ef9h		;6ef3	18 04 	. . 
	ld a,0b7h		;6ef5	3e b7 	> . 
	ld c,039h		;6ef7	0e 39 	. 9 
l6ef9h:
	ld (0081eh),a		;6ef9	32 1e 08 	2 . . 
	ld (0082dh),a		;6efc	32 2d 08 	2 - . 
	ld (00848h),a		;6eff	32 48 08 	2 H . 
	ld a,c			;6f02	79 	y 
	ld (0085dh),a		;6f03	32 5d 08 	2 ] . 
	call 00e87h		;6f06	cd 87 0e 	. . . 
	dec hl			;6f09	2b 	+ 
	ld c,(hl)			;6f0a	4e 	N 
	inc hl			;6f0b	23 	# 
	ld de,02ce5h		;6f0c	11 e5 2c 	. . , 
	call 007e3h		;6f0f	cd e3 07 	. . . 
	scf			;6f12	37 	7 
	ld c,0d6h		;6f13	0e d6 	. . 
	call c,007e3h		;6f15	dc e3 07 	. . . 
	call 00e8ah		;6f18	cd 8a 0e 	. . . 
	ld a,02fh		;6f1b	3e 2f 	> / 
	ld (02ce5h),a		;6f1d	32 e5 2c 	2 . , 
	ld a,(hl)			;6f20	7e 	~ 
	scf			;6f21	37 	7 
	jr nc,l6f29h		;6f22	30 05 	0 . 
	dec a			;6f24	3d 	= 
	inc hl			;6f25	23 	# 
	inc hl			;6f26	23 	# 
	inc hl			;6f27	23 	# 
	inc hl			;6f28	23 	# 
l6f29h:
	inc hl			;6f29	23 	# 
l6f2ah:
	ld ix,02ce7h		;6f2a	dd 21 e7 2c 	. ! . , 
	dec a			;6f2e	3d 	= 
	jr z,l6f46h		;6f2f	28 15 	( . 
	push af			;6f31	f5 	. 
	inc (ix-002h)		;6f32	dd 34 fe 	. 4 . 
	ld (ix-001h),03ah		;6f35	dd 36 ff 3a 	. 6 . : 
	call 00862h		;6f39	cd 62 08 	. b . 
	scf			;6f3c	37 	7 
	call c,00862h		;6f3d	dc 62 08 	. b . 
	call 00e8ah		;6f40	cd 8a 0e 	. . . 
	pop af			;6f43	f1 	. 
	jr l6f2ah		;6f44	18 e4 	. . 
l6f46h:
	call 02848h		;6f46	cd 48 28 	. H ( 
	cp 069h		;6f49	fe 69 	. i 
	ret z			;6f4b	c8 	. 
	cp 030h		;6f4c	fe 30 	. 0 
	jr c,l6f53h		;6f4e	38 03 	8 . 
	cp 035h		;6f50	fe 35 	. 5 
	ret c			;6f52	d8 	. 
l6f53h:
	jp 001b4h		;6f53	c3 b4 01 	. . . 
	ld e,(hl)			;6f56	5e 	^ 
	inc hl			;6f57	23 	# 
	ld d,(hl)			;6f58	56 	V 
	inc hl			;6f59	23 	# 
	push hl			;6f5a	e5 	. 
	ex de,hl			;6f5b	eb 	. 
	push hl			;6f5c	e5 	. 
	call 00d3eh		;6f5d	cd 3e 0d 	. > . 
	pop de			;6f60	d1 	. 
	call 00d54h		;6f61	cd 54 0d 	. T . 
	push ix		;6f64	dd e5 	. . 
	ld b,00ah		;6f66	06 0a 	. . 
l6f68h:
	ld (ix+000h),020h		;6f68	dd 36 00 20 	. 6 .   
	inc ix		;6f6c	dd 23 	. # 
	djnz l6f68h		;6f6e	10 f8 	. . 
	pop hl			;6f70	e1 	. 
	jr c,l6f7eh		;6f71	38 0b 	8 . 
	push hl			;6f73	e5 	. 
	call 02356h		;6f74	cd 56 23 	. V # 
	pop hl			;6f77	e1 	. 
	inc hl			;6f78	23 	# 
	ld b,009h		;6f79	06 09 	. . 
	call 02514h		;6f7b	cd 14 25 	. . % 
l6f7eh:
	pop hl			;6f7e	e1 	. 
	ret			;6f7f	c9 	. 
	ld hl,00000h		;6f80	21 00 00 	! . . 
	ld (01b94h),hl		;6f83	22 94 1b 	" . . 
	ld (01b75h),hl		;6f86	22 75 1b 	" u . 
	ld ix,02d62h		;6f89	dd 21 62 2d 	. ! b - 
	ret			;6f8d	c9 	. 
	ld hl,02d3eh		;6f8e	21 3e 2d 	! > - 
	ld (hl),080h		;6f91	36 80 	6 . 
	inc hl			;6f93	23 	# 
	ld (hl),001h		;6f94	36 01 	6 . 
	inc hl			;6f96	23 	# 
	ld bc,02000h		;6f97	01 00 20 	. .   
	jp 02521h		;6f9a	c3 21 25 	. ! % 
	ld hl,01210h		;6f9d	21 10 12 	! . . 
	ld (02991h),hl		;6fa0	22 91 29 	" . ) 
	call 00353h		;6fa3	cd 53 03 	. S . 
	jp 02807h		;6fa6	c3 07 28 	. . ( 
l6fa9h:
	call 008a9h		;6fa9	cd a9 08 	. . . 
	call 02879h		;6fac	cd 79 28 	. y ( 
	cp 080h		;6faf	fe 80 	. . 
	jr nc,l6fa9h		;6fb1	30 f6 	0 . 
	cp 004h		;6fb3	fe 04 	. . 
	jp z,001b4h		;6fb5	ca b4 01 	. . . 
	cp 003h		;6fb8	fe 03 	. . 
	jr nz,l6fc4h		;6fba	20 08 	  . 
	ld hl,(0207ch)		;6fbc	2a 7c 20 	* |   
	dec hl			;6fbf	2b 	+ 
	bit 7,(hl)		;6fc0	cb 7e 	. ~ 
	jr nz,l6fa9h		;6fc2	20 e5 	  . 
l6fc4h:
	call 0207bh		;6fc4	cd 7b 20 	. {   
	jr nz,l6fa9h		;6fc7	20 e0 	  . 
	call 00353h		;6fc9	cd 53 03 	. S . 
	jp 02838h		;6fcc	c3 38 28 	. 8 ( 
	call 00303h		;6fcf	cd 03 03 	. . . 
	jp nz,0cde5h		;6fd2	c2 e5 cd 	. . . 
	inc bc			;6fd5	03 	. 
	inc bc			;6fd6	03 	. 
	pop bc			;6fd7	c1 	. 
	pop de			;6fd8	d1 	. 
	add hl,de			;6fd9	19 	. 
	dec hl			;6fda	2b 	+ 
	ret			;6fdb	c9 	. 
	call 00303h		;6fdc	cd 03 03 	. . . 
	jp nz,0cde5h		;6fdf	c2 e5 cd 	. . . 
	inc bc			;6fe2	03 	. 
	inc bc			;6fe3	03 	. 
	jp 0c9d1h		;6fe4	c3 d1 c9 	. . . 
	pop af			;6fe7	f1 	. 
	push hl			;6fe8	e5 	. 
	push de			;6fe9	d5 	. 
	push af			;6fea	f5 	. 
	ld b,d			;6feb	42 	B 
	ld c,e			;6fec	4b 	K 
	ex de,hl			;6fed	eb 	. 
	call 00e1dh		;6fee	cd 1d 0e 	. . . 
	ld hl,00918h		;6ff1	21 18 09 	! . . 
	ld (022e3h),hl		;6ff4	22 e3 22 	" . " 
	ret nc			;6ff7	d0 	. 
	ld a,0cdh		;6ff8	3e cd 	> . 
	call 0089ah		;6ffa	cd 9a 08 	. . . 
	ld hl,02d3fh		;6ffd	21 3f 2d 	! ? - 
	ld (hl),a			;7000	77 	w 
	inc hl			;7001	23 	# 
	ld (hl),0d0h		;7002	36 d0 	6 . 
	call 008a9h		;7004	cd a9 08 	. . . 
	ld a,000h		;7007	3e 00 	> . 
	ld (011dbh),a		;7009	32 db 11 	2 . . 
	call 00fb9h		;700c	cd b9 0f 	. . . 
	call 02953h		;700f	cd 53 29 	. S ) 
	call 02879h		;7012	cd 79 28 	. y ( 
	call 003b5h		;7015	cd b5 03 	. . . 
	jp 001b4h		;7018	c3 b4 01 	. . . 
	ld hl,(0027bh)		;701b	2a 7b 02 	* { . 
	push hl			;701e	e5 	. 
	call 00d96h		;701f	cd 96 0d 	. . . 
	ex af,af'			;7022	08 	. 
	jp nz,001b4h		;7023	c2 b4 01 	. . . 
	ld (00a0bh),hl		;7026	22 0b 0a 	" . . 
	ld (009e8h),hl		;7029	22 e8 09 	" . . 
	ld (00c33h),de		;702c	ed 53 33 0c 	. S 3 . 
	push bc			;7030	c5 	. 
	ld a,(011dbh)		;7031	3a db 11 	: . . 
	ld (00914h),a		;7034	32 14 09 	2 . . 
	call 00b22h		;7037	cd 22 0b 	. " . 
	pop bc			;703a	c1 	. 
	pop de			;703b	d1 	. 
	push bc			;703c	c5 	. 
	call 00af4h		;703d	cd f4 0a 	. . . 
	pop bc			;7040	c1 	. 
	ld hl,012a6h		;7041	21 a6 12 	! . . 
	call 00bd2h		;7044	cd d2 0b 	. . . 
	jr c,l7069h		;7047	38 20 	8   
	ld hl,00a4bh		;7049	21 4b 0a 	! K . 
	call 00e18h		;704c	cd 18 0e 	. . . 
	ld a,(hl)			;704f	7e 	~ 
	ld hl,00a53h		;7050	21 53 0a 	! S . 
	call 00e18h		;7053	cd 18 0e 	. . . 
	ld bc,00a4ah		;7056	01 4a 0a 	. J . 
	ld a,(00a08h)		;7059	3a 08 0a 	: . . 
	call 00c93h		;705c	cd 93 0c 	. . . 
	ld (009e8h),hl		;705f	22 e8 09 	" . . 
	ld (00990h),bc		;7062	ed 43 90 09 	. C . . 
	ld (009e5h),a		;7066	32 e5 09 	2 . . 
l7069h:
	call 009a2h		;7069	cd a2 09 	. . . 
	ex af,af'			;706c	08 	. 
	push af			;706d	f5 	. 
	exx			;706e	d9 	. 
	push hl			;706f	e5 	. 
	exx			;7070	d9 	. 
	pop de			;7071	d1 	. 
	ld hl,00173h		;7072	21 73 01 	! s . 
	ld a,(00b33h)		;7075	3a 33 0b 	: 3 . 
	or a			;7078	b7 	. 
	call z,00e60h		;7079	cc 60 0e 	. ` . 
	ld a,0ceh		;707c	3e ce 	> . 
	jp c,00906h		;707e	da 06 09 	. . . 
	pop af			;7081	f1 	. 
	or a			;7082	b7 	. 
	call nz,00a4ah		;7083	c4 4a 0a 	. J . 
	exx			;7086	d9 	. 
	ld (0027bh),hl		;7087	22 7b 02 	" { . 
	ld hl,(011f3h)		;708a	2a f3 11 	* . . 
	add hl,de			;708d	19 	. 
	ld (011f3h),hl		;708e	22 f3 11 	" . . 
	ld a,0bfh		;7091	3e bf 	> . 
	jp 01f56h		;7093	c3 56 1f 	. V . 
	ld a,0e9h		;7096	3e e9 	> . 
	call 00561h		;7098	cd 61 05 	. a . 
	ld (00a21h),sp		;709b	ed 73 21 0a 	. s ! . 
	ld sp,011dbh		;709f	31 db 11 	1 . . 
	pop hl			;70a2	e1 	. 
	ld a,l			;70a3	7d 	} 
	ld r,a		;70a4	ed 4f 	. O 
	ld a,h			;70a6	7c 	| 
	ld i,a		;70a7	ed 47 	. G 
	pop bc			;70a9	c1 	. 
	pop de			;70aa	d1 	. 
	pop hl			;70ab	e1 	. 
	pop af			;70ac	f1 	. 
	exx			;70ad	d9 	. 
	ex af,af'			;70ae	08 	. 
	pop iy		;70af	fd e1 	. . 
	pop ix		;70b1	dd e1 	. . 
	pop bc			;70b3	c1 	. 
	pop de			;70b4	d1 	. 
	pop hl			;70b5	e1 	. 
	pop af			;70b6	f1 	. 
	ld sp,(011f1h)		;70b7	ed 7b f1 11 	. { . . 
	jp 02d61h		;70bb	c3 61 2d 	. a - 
	ld (011f1h),sp		;70be	ed 73 f1 11 	. s . . 
	ld sp,02d61h		;70c2	31 61 2d 	1 a - 
	push af			;70c5	f5 	. 
	ld a,i		;70c6	ed 57 	. W 
	push af			;70c8	f5 	. 
	ld a,r		;70c9	ed 5f 	. _ 
	di			;70cb	f3 	. 
	push af			;70cc	f5 	. 
	pop af			;70cd	f1 	. 
	pop af			;70ce	f1 	. 
	pop af			;70cf	f1 	. 
	ld sp,011f1h		;70d0	31 f1 11 	1 . . 
	push af			;70d3	f5 	. 
	push hl			;70d4	e5 	. 
	push de			;70d5	d5 	. 
	ld a,001h		;70d6	3e 01 	> . 
	ld de,00000h		;70d8	11 00 00 	. . . 
	ld hl,00000h		;70db	21 00 00 	! . . 
	jr l7102h		;70de	18 22 	. " 
	nop			;70e0	00 	. 
	ld (011f1h),sp		;70e1	ed 73 f1 11 	. s . . 
	ld sp,02d61h		;70e5	31 61 2d 	1 a - 
	push af			;70e8	f5 	. 
	ld a,i		;70e9	ed 57 	. W 
	push af			;70eb	f5 	. 
	ld a,r		;70ec	ed 5f 	. _ 
	di			;70ee	f3 	. 
	push af			;70ef	f5 	. 
	pop af			;70f0	f1 	. 
	pop af			;70f1	f1 	. 
	pop af			;70f2	f1 	. 
	ld sp,011f1h		;70f3	31 f1 11 	1 . . 
	push af			;70f6	f5 	. 
	push hl			;70f7	e5 	. 
	push de			;70f8	d5 	. 
	ld a,000h		;70f9	3e 00 	> . 
	ld de,00004h		;70fb	11 04 00 	. . . 
	ld hl,00000h		;70fe	21 00 00 	! . . 
	nop			;7101	00 	. 
l7102h:
	push bc			;7102	c5 	. 
	push ix		;7103	dd e5 	. . 
	push iy		;7105	fd e5 	. . 
	exx			;7107	d9 	. 
	ex af,af'			;7108	08 	. 
	push af			;7109	f5 	. 
	push hl			;710a	e5 	. 
	push de			;710b	d5 	. 
	push bc			;710c	c5 	. 
	ld a,i		;710d	ed 57 	. W 
	ld h,a			;710f	67 	g 
	ld a,r		;7110	ed 5f 	. _ 
	ld l,a			;7112	6f 	o 
	push hl			;7113	e5 	. 
	ld sp,00000h		;7114	31 00 00 	1 . . 
	ld a,0dbh		;7117	3e db 	> . 
	call 00561h		;7119	cd 61 05 	. a . 
	ld hl,02d5dh		;711c	21 5d 2d 	! ] - 
	ld a,(hl)			;711f	7e 	~ 
	dec hl			;7120	2b 	+ 
	dec hl			;7121	2b 	+ 
	or (hl)			;7122	b6 	. 
	and 004h		;7123	e6 04 	. . 
	rrca			;7125	0f 	. 
	rrca			;7126	0f 	. 
	ld (010a6h),a		;7127	32 a6 10 	2 . . 
	ret			;712a	c9 	. 
	ld hl,(011f1h)		;712b	2a f1 11 	* . . 
	ld de,(00a0bh)		;712e	ed 5b 0b 0a 	. [ . . 
	ld (hl),e			;7132	73 	s 
	inc hl			;7133	23 	# 
	ld (hl),d			;7134	72 	r 
	ret			;7135	c9 	. 
	ld hl,(011f1h)		;7136	2a f1 11 	* . . 
	inc hl			;7139	23 	# 
	inc hl			;713a	23 	# 
	ld (011f1h),hl		;713b	22 f1 11 	" . . 
	ret			;713e	c9 	. 
	nop			;713f	00 	. 
	inc d			;7140	14 	. 
	ld c,d			;7141	4a 	J 
	ld h,a			;7142	67 	g 
	ld a,h			;7143	7c 	| 
	add a,c			;7144	81 	. 
	add a,(hl)			;7145	86 	. 
	sub l			;7146	95 	. 
	ld hl,02d63h		;7147	21 63 2d 	! c - 
	ld e,(hl)			;714a	5e 	^ 
	ld (hl),003h		;714b	36 03 	6 . 
	ld hl,(00a0bh)		;714d	2a 0b 0a 	* . . 
	ld d,000h		;7150	16 00 	. . 
	bit 7,e		;7152	cb 7b 	. { 
	jr z,l7157h		;7154	28 01 	( . 
	dec d			;7156	15 	. 
l7157h:
	add hl,de			;7157	19 	. 
	add a,005h		;7158	c6 05 	. . 
	ret			;715a	c9 	. 
l715bh:
	cp 00ah		;715b	fe 0a 	. . 
	jr z,l7186h		;715d	28 27 	( ' 
	exx			;715f	d9 	. 
	ld de,(02d63h)		;7160	ed 5b 63 2d 	. [ c - 
	ld (00a85h),sp		;7164	ed 73 85 0a 	. s . . 
	ld hl,0018dh		;7168	21 8d 01 	! . . 
	ld b,(hl)			;716b	46 	F 
	inc hl			;716c	23 	# 
	ld sp,hl			;716d	f9 	. 
l716eh:
	djnz l7172h		;716e	10 02 	. . 
	jr l7178h		;7170	18 06 	. . 
l7172h:
	pop hl			;7172	e1 	. 
	or a			;7173	b7 	. 
	sbc hl,de		;7174	ed 52 	. R 
	jr nz,l716eh		;7176	20 f6 	  . 
l7178h:
	ld sp,00000h		;7178	31 00 00 	1 . . 
	exx			;717b	d9 	. 
	nop			;717c	00 	. 
	add a,008h		;717d	c6 08 	. . 
	ld hl,00a08h		;717f	21 08 0a 	! . . 
	inc (hl)			;7182	34 	4 
	ld bc,00a37h		;7183	01 37 0a 	. 7 . 
l7186h:
	ld hl,(02d63h)		;7186	2a 63 2d 	* c - 
	ld de,02d68h		;7189	11 68 2d 	. h - 
	ld (02d63h),de		;718c	ed 53 63 2d 	. S c - 
	ret			;7190	c9 	. 
	ld hl,(011f1h)		;7191	2a f1 11 	* . . 
	ld e,(hl)			;7194	5e 	^ 
	inc hl			;7195	23 	# 
	ld d,(hl)			;7196	56 	V 
	ld hl,02d62h		;7197	21 62 2d 	! b - 
	ld a,(hl)			;719a	7e 	~ 
	add a,002h		;719b	c6 02 	. . 
	cp 0cbh		;719d	fe cb 	. . 
	jr nz,l71a3h		;719f	20 02 	  . 
	sub 008h		;71a1	d6 08 	. . 
l71a3h:
	ld (hl),a			;71a3	77 	w 
	call 00b0eh		;71a4	cd 0e 0b 	. . . 
	ld a,00ah		;71a7	3e 0a 	> . 
	ld bc,00a42h		;71a9	01 42 0a 	. B . 
	jr l71beh		;71ac	18 10 	. . 
	ld hl,02d62h		;71ae	21 62 2d 	! b - 
	ld a,(hl)			;71b1	7e 	~ 
	and 038h		;71b2	e6 38 	. 8 
	ld (hl),0cdh		;71b4	36 cd 	6 . 
	inc hl			;71b6	23 	# 
	ld (hl),a			;71b7	77 	w 
	inc hl			;71b8	23 	# 
	ld (hl),000h		;71b9	36 00 	6 . 
	inc hl			;71bb	23 	# 
	ld a,003h		;71bc	3e 03 	> . 
l71beh:
	call 00b03h		;71be	cd 03 0b 	. . . 
	jr l715bh		;71c1	18 98 	. . 
	ld hl,(011edh)		;71c3	2a ed 11 	* . . 
	jr l71d4h		;71c6	18 0c 	. . 
	ld hl,(011e7h)		;71c8	2a e7 11 	* . . 
	jr l71d0h		;71cb	18 03 	. . 
	ld hl,(011e5h)		;71cd	2a e5 11 	* . . 
l71d0h:
	xor a			;71d0	af 	. 
	ld (02d63h),a		;71d1	32 63 2d 	2 c - 
l71d4h:
	xor a			;71d4	af 	. 
	ld (02d62h),a		;71d5	32 62 2d 	2 b - 
	ld (00a0bh),hl		;71d8	22 0b 0a 	" . . 
	ret			;71db	c9 	. 
	ld bc,00a42h		;71dc	01 42 0a 	. B . 
	ld hl,(011f1h)		;71df	2a f1 11 	* . . 
	ld e,(hl)			;71e2	5e 	^ 
	inc hl			;71e3	23 	# 
	ld d,(hl)			;71e4	56 	V 
	ex de,hl			;71e5	eb 	. 
	jr l71d0h		;71e6	18 e8 	. . 
	ld hl,(00a0bh)		;71e8	2a 0b 0a 	* . . 
	and a			;71eb	a7 	. 
	sbc hl,de		;71ec	ed 52 	. R 
	ld b,h			;71ee	44 	D 
	ld c,l			;71ef	4d 	M 
	call 00b14h		;71f0	cd 14 0b 	. . . 
	ex de,hl			;71f3	eb 	. 
	ldir		;71f4	ed b0 	. . 
	ex de,hl			;71f6	eb 	. 
	ld de,009edh		;71f7	11 ed 09 	. . . 
	call 00b0ch		;71fa	cd 0c 0b 	. . . 
	ld de,009cah		;71fd	11 ca 09 	. . . 
	ld (hl),0c3h		;7200	36 c3 	6 . 
	inc hl			;7202	23 	# 
	ld (hl),e			;7203	73 	s 
	inc hl			;7204	23 	# 
	ld (hl),d			;7205	72 	r 
	inc hl			;7206	23 	# 
	ret			;7207	c9 	. 
	ld hl,02d61h		;7208	21 61 2d 	! a - 
	ld a,(010a6h)		;720b	3a a6 10 	: . . 
	add a,a			;720e	87 	. 
	add a,a			;720f	87 	. 
	add a,a			;7210	87 	. 
	add a,0f3h		;7211	c6 f3 	. . 
	ld (hl),a			;7213	77 	w 
	inc hl			;7214	23 	# 
	ret			;7215	c9 	. 
	ld a,b			;7216	78 	x 
	sub 076h		;7217	d6 76 	. v 
	or c			;7219	b1 	. 
	jr nz,l7226h		;721a	20 0a 	  . 
	ld a,(010a6h)		;721c	3a a6 10 	: . . 
	or a			;721f	b7 	. 
	ret nz			;7220	c0 	. 
	ld a,0cfh		;7221	3e cf 	> . 
	jp 00906h		;7223	c3 06 09 	. . . 
l7226h:
	ld a,000h		;7226	3e 00 	> . 
	or a			;7228	b7 	. 
	ret nz			;7229	c0 	. 
	ld a,c			;722a	79 	y 
	and 040h		;722b	e6 40 	. @ 
	jr z,l7286h		;722d	28 57 	( W 
	ld a,b			;722f	78 	x 
	exx			;7230	d9 	. 
	cp 0b0h		;7231	fe b0 	. . 
	ld bc,(011e9h)		;7233	ed 4b e9 11 	. K . . 
	ld de,(011ebh)		;7237	ed 5b eb 11 	. [ . . 
	ld hl,(011edh)		;723b	2a ed 11 	* . . 
	jr nz,l724ah		;723e	20 0a 	  . 
	push hl			;7240	e5 	. 
	add hl,bc			;7241	09 	. 
	dec hl			;7242	2b 	+ 
	push hl			;7243	e5 	. 
	ex de,hl			;7244	eb 	. 
	push hl			;7245	e5 	. 
	add hl,bc			;7246	09 	. 
	dec hl			;7247	2b 	+ 
	jr l725ch		;7248	18 12 	. . 
l724ah:
	cp 0b8h		;724a	fe b8 	. . 
	jr nz,l7285h		;724c	20 37 	  7 
	push hl			;724e	e5 	. 
	and a			;724f	a7 	. 
	sbc hl,bc		;7250	ed 42 	. B 
	inc hl			;7252	23 	# 
	ex (sp),hl			;7253	e3 	. 
	push hl			;7254	e5 	. 
	ex de,hl			;7255	eb 	. 
	push hl			;7256	e5 	. 
	and a			;7257	a7 	. 
	sbc hl,bc		;7258	ed 42 	. B 
	inc hl			;725a	23 	# 
	ex (sp),hl			;725b	e3 	. 
l725ch:
	push hl			;725c	e5 	. 
	ld h,b			;725d	60 	` 
	ld l,c			;725e	69 	i 
	ld de,00015h		;725f	11 15 00 	. . . 
	call 01d7ah		;7262	cd 7a 1d 	. z . 
	dec hl			;7265	2b 	+ 
	dec hl			;7266	2b 	+ 
	dec hl			;7267	2b 	+ 
	dec hl			;7268	2b 	+ 
	dec hl			;7269	2b 	+ 
	ld (00a08h),hl		;726a	22 08 0a 	" . . 
	ld hl,00159h		;726d	21 59 01 	! Y . 
	pop de			;7270	d1 	. 
	pop bc			;7271	c1 	. 
	call 00e28h		;7272	cd 28 0e 	. ( . 
	jp c,00904h		;7275	da 04 09 	. . . 
	ld hl,0013fh		;7278	21 3f 01 	! ? . 
	pop de			;727b	d1 	. 
	pop bc			;727c	c1 	. 
	call 00e28h		;727d	cd 28 0e 	. ( . 
	jp c,00904h		;7280	da 04 09 	. . . 
	exx			;7283	d9 	. 
	ret			;7284	c9 	. 
l7285h:
	exx			;7285	d9 	. 
l7286h:
	ld hl,011f9h		;7286	21 f9 11 	! . . 
	push de			;7289	d5 	. 
	call 00bd2h		;728a	cd d2 0b 	. . . 
	ld hl,0013fh		;728d	21 3f 01 	! ? . 
	call 00ba9h		;7290	cd a9 0b 	. . . 
	ld hl,0124bh		;7293	21 4b 12 	! K . 
	pop de			;7296	d1 	. 
	call 00bd2h		;7297	cd d2 0b 	. . . 
	ld hl,00159h		;729a	21 59 01 	! Y . 
	ret c			;729d	d8 	. 
	push hl			;729e	e5 	. 
	push af			;729f	f5 	. 
	ld hl,00c03h		;72a0	21 03 0c 	! . . 
	call 00e18h		;72a3	cd 18 0e 	. . . 
	ld a,(hl)			;72a6	7e 	~ 
	ld hl,00c0bh		;72a7	21 0b 0c 	! . . 
	call 00e18h		;72aa	cd 18 0e 	. . . 
	call 00c93h		;72ad	cd 93 0c 	. . . 
	pop af			;72b0	f1 	. 
	ex (sp),hl			;72b1	e3 	. 
	pop de			;72b2	d1 	. 
	push af			;72b3	f5 	. 
	push hl			;72b4	e5 	. 
	call 00e60h		;72b5	cd 60 0e 	. ` . 
	pop hl			;72b8	e1 	. 
	jp c,00904h		;72b9	da 04 09 	. . . 
	pop af			;72bc	f1 	. 
	ret z			;72bd	c8 	. 
	inc de			;72be	13 	. 
	call 00e60h		;72bf	cd 60 0e 	. ` . 
	jp c,00904h		;72c2	da 04 09 	. . . 
	ret			;72c5	c9 	. 
	ld a,c			;72c6	79 	y 
	and 0f0h		;72c7	e6 f0 	. . 
	ld c,a			;72c9	4f 	O 
	ld d,(hl)			;72ca	56 	V 
	inc hl			;72cb	23 	# 
l72cch:
	ld a,b			;72cc	78 	x 
	and (hl)			;72cd	a6 	. 
	inc hl			;72ce	23 	# 
	cp (hl)			;72cf	be 	. 
	inc hl			;72d0	23 	# 
	jr z,l72d9h		;72d1	28 06 	( . 
l72d3h:
	inc hl			;72d3	23 	# 
	dec d			;72d4	15 	. 
	jr nz,l72cch		;72d5	20 f5 	  . 
	scf			;72d7	37 	7 
	ret			;72d8	c9 	. 
l72d9h:
	ld a,(hl)			;72d9	7e 	~ 
	and 0f0h		;72da	e6 f0 	. . 
	cp c			;72dc	b9 	. 
	jr nz,l72d3h		;72dd	20 f4 	  . 
	ld a,(hl)			;72df	7e 	~ 
	and 00fh		;72e0	e6 0f 	. . 
	bit 3,a		;72e2	cb 5f 	. _ 
	res 3,a		;72e4	cb 9f 	. . 
	ret			;72e6	c9 	. 
	ld hl,00c03h		;72e7	21 03 0c 	! . . 
	call 00e18h		;72ea	cd 18 0e 	. . . 
	ld a,(hl)			;72ed	7e 	~ 
	ld hl,00c0bh		;72ee	21 0b 0c 	! . . 
	call 00e18h		;72f1	cd 18 0e 	. . . 
	call 00c93h		;72f4	cd 93 0c 	. . . 
	nop			;72f7	00 	. 
	inc b			;72f8	04 	. 
	ex af,af'			;72f9	08 	. 
	inc c			;72fa	0c 	. 
	ld de,0211dh		;72fb	11 1d 21 	. . ! 
	daa			;72fe	27 	' 
	ld hl,(011e9h)		;72ff	2a e9 11 	* . . 
	ret			;7302	c9 	. 
	ld hl,(011ebh)		;7303	2a eb 11 	* . . 
	ret			;7306	c9 	. 
	ld hl,(011edh)		;7307	2a ed 11 	* . . 
	ret			;730a	c9 	. 
	ld hl,(011e7h)		;730b	2a e7 11 	* . . 
	jr l7313h		;730e	18 03 	. . 
	ld hl,(011e5h)		;7310	2a e5 11 	* . . 
l7313h:
	bit 7,e		;7313	cb 7b 	. { 
	ld d,000h		;7315	16 00 	. . 
	jr z,l731ah		;7317	28 01 	( . 
	dec d			;7319	15 	. 
l731ah:
	add hl,de			;731a	19 	. 
	ret			;731b	c9 	. 
	ld hl,(011f1h)		;731c	2a f1 11 	* . . 
	ret			;731f	c9 	. 
	ld hl,(011f1h)		;7320	2a f1 11 	* . . 
	dec hl			;7323	2b 	+ 
	dec hl			;7324	2b 	+ 
	ret			;7325	c9 	. 
	ld hl,00000h		;7326	21 00 00 	! . . 
	ret			;7329	c9 	. 
l732ah:
	ld e,(hl)			;732a	5e 	^ 
	inc hl			;732b	23 	# 
	ld d,(hl)			;732c	56 	V 
	ld bc,00937h		;732d	01 37 09 	. 7 . 
	jr l733bh		;7330	18 09 	. . 
l7332h:
	ld hl,(00ccah)		;7332	2a ca 0c 	* . . 
	ld d,000h		;7335	16 00 	. . 
	ld e,(hl)			;7337	5e 	^ 
	ld bc,00637h		;7338	01 37 06 	. 7 . 
l733bh:
	inc hl			;733b	23 	# 
	jr l736dh		;733c	18 2f 	. / 
	ld a,000h		;733e	3e 00 	> . 
	or a			;7340	b7 	. 
	jr z,l7352h		;7341	28 0f 	( . 
	ld a,020h		;7343	3e 20 	>   
	ld b,a			;7345	47 	G 
	ld de,02ce5h		;7346	11 e5 2c 	. . , 
l7349h:
	ld (de),a			;7349	12 	. 
	inc de			;734a	13 	. 
	djnz l7349h		;734b	10 fc 	. . 
	xor a			;734d	af 	. 
	ld (00c4bh),a		;734e	32 4b 0c 	2 K . 
	ret			;7351	c9 	. 
l7352h:
	ld (00ccah),hl		;7352	22 ca 0c 	" . . 
	ex de,hl			;7355	eb 	. 
	ld hl,000f2h		;7356	21 f2 00 	! . . 
	call 00e60h		;7359	cd 60 0e 	. ` . 
	jr c,l7332h		;735c	38 d4 	8 . 
	ld hl,0010ch		;735e	21 0c 01 	! . . 
	call 00e60h		;7361	cd 60 0e 	. ` . 
	ex de,hl			;7364	eb 	. 
	jr c,l732ah		;7365	38 c3 	8 . 
	call 00d96h		;7367	cd 96 0d 	. . . 
	ex af,af'			;736a	08 	. 
	jr nz,l7332h		;736b	20 c5 	  . 
l736dh:
	push hl			;736d	e5 	. 
	ld ix,02d63h		;736e	dd 21 63 2d 	. ! c - 
	ld (ix-001h),c		;7372	dd 71 ff 	. q . 
	ld (ix-002h),b		;7375	dd 70 fe 	. p . 
	ld a,c			;7378	79 	y 
	and 007h		;7379	e6 07 	. . 
	ld c,a			;737b	4f 	O 
	ld b,000h		;737c	06 00 	. . 
	ld hl,00c94h		;737e	21 94 0c 	! . . 
	add hl,bc			;7381	09 	. 
	ld c,(hl)			;7382	4e 	N 
	ld hl,00ca9h		;7383	21 a9 0c 	! . . 
	add hl,bc			;7386	09 	. 
	jp (hl)			;7387	e9 	. 
	ld e,c			;7388	59 	Y 
	ld d,e			;7389	53 	S 
	daa			;738a	27 	' 
	add hl,de			;738b	19 	. 
	nop			;738c	00 	. 
	dec b			;738d	05 	. 
	ld c,h			;738e	4c 	L 
	daa			;738f	27 	' 
	bit 7,e		;7390	cb 7b 	. { 
	ret z			;7392	c8 	. 
	ld (ix+000h),02dh		;7393	dd 36 00 2d 	. 6 . - 
	inc ix		;7397	dd 23 	. # 
	xor a			;7399	af 	. 
	sub e			;739a	93 	. 
	ld e,a			;739b	5f 	_ 
	ret			;739c	c9 	. 
	call 00c9ch		;739d	cd 9c 0c 	. . . 
	jr l73f0h		;73a0	18 4e 	. N 
	call 00c9ch		;73a2	cd 9c 0c 	. . . 
	ld h,000h		;73a5	26 00 	& . 
	ld l,e			;73a7	6b 	k 
	push de			;73a8	d5 	. 
	call 00d42h		;73a9	cd 42 0d 	. B . 
	pop de			;73ac	d1 	. 
	ld e,d			;73ad	5a 	Z 
	ld (ix+000h),01fh		;73ae	dd 36 00 1f 	. 6 . . 
	inc ix		;73b2	dd 23 	. # 
	jr l73f0h		;73b4	18 3a 	. : 
	ld d,000h		;73b6	16 00 	. . 
	bit 7,e		;73b8	cb 7b 	. { 
	jr z,l73bdh		;73ba	28 01 	( . 
	dec d			;73bc	15 	. 
l73bdh:
	ld hl,00001h		;73bd	21 01 00 	! . . 
	inc hl			;73c0	23 	# 
	inc hl			;73c1	23 	# 
	add hl,de			;73c2	19 	. 
	ex de,hl			;73c3	eb 	. 
	ld c,000h		;73c4	0e 00 	. . 
	dec c			;73c6	0d 	. 
	jr z,l73f2h		;73c7	28 29 	( ) 
	call 00d54h		;73c9	cd 54 0d 	. T . 
	jr c,l73d3h		;73cc	38 05 	8 . 
	call 00d47h		;73ce	cd 47 0d 	. G . 
	jr l73f6h		;73d1	18 23 	. # 
l73d3h:
	dec c			;73d3	0d 	. 
	jr z,l73f2h		;73d4	28 1c 	( . 
	dec de			;73d6	1b 	. 
	call 00d54h		;73d7	cd 54 0d 	. T . 
	inc de			;73da	13 	. 
	jr c,l73f2h		;73db	38 15 	8 . 
	dec de			;73dd	1b 	. 
	call 00d47h		;73de	cd 47 0d 	. G . 
	ld de,02b31h		;73e1	11 31 2b 	. 1 + 
	call 00d49h		;73e4	cd 49 0d 	. I . 
	jr l73f6h		;73e7	18 0d 	. . 
	ld hl,(00ccah)		;73e9	2a ca 0c 	* . . 
	ld a,(hl)			;73ec	7e 	~ 
	and 038h		;73ed	e6 38 	. 8 
	ld e,a			;73ef	5f 	_ 
l73f0h:
	ld d,000h		;73f0	16 00 	. . 
l73f2h:
	ex de,hl			;73f2	eb 	. 
	call 00d42h		;73f3	cd 42 0d 	. B . 
l73f6h:
	ld (ix+000h),0c0h		;73f6	dd 36 00 c0 	. 6 . . 
	ld ix,02d61h		;73fa	dd 21 61 2d 	. ! a - 
	call 02375h		;73fe	cd 75 23 	. u # 
	ld ix,02ce5h		;7401	dd 21 e5 2c 	. ! . , 
	ld de,(00ccah)		;7405	ed 5b ca 0c 	. [ . . 
	ld a,(00cd1h)		;7409	3a d1 0c 	: . . 
	dec a			;740c	3d 	= 
	jr z,l7421h		;740d	28 12 	( . 
	call 00d54h		;740f	cd 54 0d 	. T . 
	jr c,l7421h		;7412	38 0d 	8 . 
	call 02356h		;7414	cd 56 23 	. V # 
	ld b,009h		;7417	06 09 	. . 
	push ix		;7419	dd e5 	. . 
	pop hl			;741b	e1 	. 
	call 02514h		;741c	cd 14 25 	. . % 
	jr l742eh		;741f	18 0d 	. . 
l7421h:
	ld a,001h		;7421	3e 01 	> . 
	dec a			;7423	3d 	= 
	jr nz,l742eh		;7424	20 08 	  . 
	ex de,hl			;7426	eb 	. 
	call 00d3eh		;7427	cd 3e 0d 	. > . 
	ld (ix+000h),020h		;742a	dd 36 00 20 	. 6 .   
l742eh:
	pop hl			;742e	e1 	. 
	ret			;742f	c9 	. 
	inc ix		;7430	dd 23 	. # 
	ld c,000h		;7432	0e 00 	. . 
	jr l7438h		;7434	18 02 	. . 
	ld c,001h		;7436	0e 01 	. . 
l7438h:
	jp 02b48h		;7438	c3 48 2b 	. H + 
	set 7,d		;743b	cb fa 	. . 
	ld (ix+000h),d		;743d	dd 72 00 	. r . 
	inc ix		;7440	dd 23 	. # 
	ld (ix+000h),e		;7442	dd 73 00 	. s . 
	inc ix		;7445	dd 23 	. # 
	ret			;7447	c9 	. 
	push bc			;7448	c5 	. 
	exx			;7449	d9 	. 
	ld de,00000h		;744a	11 00 00 	. . . 
	ld hl,(02a17h)		;744d	2a 17 2a 	* . * 
	ld c,(hl)			;7450	4e 	N 
	inc hl			;7451	23 	# 
	ld b,(hl)			;7452	46 	F 
	inc hl			;7453	23 	# 
	push hl			;7454	e5 	. 
	add hl,bc			;7455	09 	. 
	add hl,bc			;7456	09 	. 
	ld (00d81h),hl		;7457	22 81 0d 	" . . 
	exx			;745a	d9 	. 
	pop hl			;745b	e1 	. 
	exx			;745c	d9 	. 
l745dh:
	ld a,b			;745d	78 	x 
	or c			;745e	b1 	. 
	scf			;745f	37 	7 
	jr z,l7487h		;7460	28 25 	( % 
	exx			;7462	d9 	. 
	inc hl			;7463	23 	# 
	ld a,(hl)			;7464	7e 	~ 
	ld c,a			;7465	4f 	O 
	and 0c0h		;7466	e6 c0 	. . 
	ld a,c			;7468	79 	y 
	jr nz,l746eh		;7469	20 03 	  . 
	inc a			;746b	3c 	< 
	jr l7480h		;746c	18 12 	. . 
l746eh:
	push hl			;746e	e5 	. 
	dec hl			;746f	2b 	+ 
	ld l,(hl)			;7470	6e 	n 
	and 03fh		;7471	e6 3f 	. ? 
	ld h,a			;7473	67 	g 
	ld bc,l9c38h		;7474	01 38 9c 	. 8 . 
	add hl,bc			;7477	09 	. 
	ld a,(hl)			;7478	7e 	~ 
	inc hl			;7479	23 	# 
	ld h,(hl)			;747a	66 	f 
	ld l,a			;747b	6f 	o 
	xor a			;747c	af 	. 
	sbc hl,de		;747d	ed 52 	. R 
	pop hl			;747f	e1 	. 
l7480h:
	inc hl			;7480	23 	# 
	exx			;7481	d9 	. 
	dec bc			;7482	0b 	. 
	inc de			;7483	13 	. 
	jr nz,l745dh		;7484	20 d7 	  . 
	exx			;7486	d9 	. 
l7487h:
	exx			;7487	d9 	. 
	pop bc			;7488	c1 	. 
	ret			;7489	c9 	. 
	ld a,(hl)			;748a	7e 	~ 
	and 0c7h		;748b	e6 c7 	. . 
	cp 0c7h		;748d	fe c7 	. . 
	ld b,a			;748f	47 	G 
	ld c,000h		;7490	0e 00 	. . 
	jr z,l74c2h		;7492	28 2e 	( . 
	ld a,(hl)			;7494	7e 	~ 
	ld c,040h		;7495	0e 40 	. @ 
	cp 0edh		;7497	fe ed 	. . 
	jr z,l74c0h		;7499	28 25 	( % 
	ld c,000h		;749b	0e 00 	. . 
	cp 0ddh		;749d	fe dd 	. . 
	jr nz,l74a5h		;749f	20 04 	  . 
	set 5,c		;74a1	cb e9 	. . 
	jr l74abh		;74a3	18 06 	. . 
l74a5h:
	cp 0fdh		;74a5	fe fd 	. . 
	jr nz,l74bah		;74a7	20 11 	  . 
	set 4,c		;74a9	cb e1 	. . 
l74abh:
	inc hl			;74ab	23 	# 
	ld a,(hl)			;74ac	7e 	~ 
	cp 0cbh		;74ad	fe cb 	. . 
	jr nz,l74c1h		;74af	20 10 	  . 
	set 7,c		;74b1	cb f9 	. . 
	inc hl			;74b3	23 	# 
	ld e,(hl)			;74b4	5e 	^ 
	inc hl			;74b5	23 	# 
	ld b,(hl)			;74b6	46 	F 
	push hl			;74b7	e5 	. 
	jr l74c7h		;74b8	18 0d 	. . 
l74bah:
	cp 0cbh		;74ba	fe cb 	. . 
	jr nz,l74c1h		;74bc	20 03 	  . 
	set 7,c		;74be	cb f9 	. . 
l74c0h:
	inc hl			;74c0	23 	# 
l74c1h:
	ld b,(hl)			;74c1	46 	F 
l74c2h:
	inc hl			;74c2	23 	# 
	push hl			;74c3	e5 	. 
	ld e,(hl)			;74c4	5e 	^ 
	inc hl			;74c5	23 	# 
	ld d,(hl)			;74c6	56 	V 
l74c7h:
	push de			;74c7	d5 	. 
	ld a,c			;74c8	79 	y 
	cp 03fh		;74c9	fe 3f 	. ? 
	jr nc,l74e0h		;74cb	30 13 	0 . 
	cp 010h		;74cd	fe 10 	. . 
	ld a,b			;74cf	78 	x 
	jr nc,l74deh		;74d0	30 0c 	0 . 
	cp 018h		;74d2	fe 18 	. . 
	jr z,l74e4h		;74d4	28 0e 	( . 
	cp 0c9h		;74d6	fe c9 	. . 
	jr z,l74e4h		;74d8	28 0a 	( . 
	cp 0c3h		;74da	fe c3 	. . 
	jr z,l74e4h		;74dc	28 06 	( . 
l74deh:
	cp 0e9h		;74de	fe e9 	. . 
l74e0h:
	ld a,000h		;74e0	3e 00 	> . 
	jr nz,l74e6h		;74e2	20 02 	  . 
l74e4h:
	ld a,001h		;74e4	3e 01 	> . 
l74e6h:
	ld (00c4bh),a		;74e6	32 4b 0c 	2 K . 
	push bc			;74e9	c5 	. 
	call 0255ch		;74ea	cd 5c 25 	. \ % 
	ex af,af'			;74ed	08 	. 
	pop bc			;74ee	c1 	. 
	ld a,(hl)			;74ef	7e 	~ 
	and 01fh		;74f0	e6 1f 	. . 
	ld (00a08h),a		;74f2	32 08 0a 	2 . . 
	xor a			;74f5	af 	. 
	ld (00a09h),a		;74f6	32 09 0a 	2 . . 
	dec hl			;74f9	2b 	+ 
	dec hl			;74fa	2b 	+ 
	dec hl			;74fb	2b 	+ 
	ld a,(hl)			;74fc	7e 	~ 
	and 007h		;74fd	e6 07 	. . 
	or c			;74ff	b1 	. 
	ld c,a			;7500	4f 	O 
	pop de			;7501	d1 	. 
	and 007h		;7502	e6 07 	. . 
	ld hl,01c3ah		;7504	21 3a 1c 	! : . 
	call 00e18h		;7507	cd 18 0e 	. . . 
	ld a,(hl)			;750a	7e 	~ 
	pop hl			;750b	e1 	. 
	add a,l			;750c	85 	. 
	ld l,a			;750d	6f 	o 
	ret nc			;750e	d0 	. 
	inc h			;750f	24 	$ 
	ret			;7510	c9 	. 
	ld (00e5dh),sp		;7511	ed 73 5d 0e 	. s ] . 
	ld a,002h		;7515	3e 02 	> . 
	ld sp,0015ah		;7517	31 5a 01 	1 Z . 
	jr l7523h		;751a	18 07 	. . 
	ld (00e5dh),sp		;751c	ed 73 5d 0e 	. s ] . 
	ld a,(hl)			;7520	7e 	~ 
	inc hl			;7521	23 	# 
	ld sp,hl			;7522	f9 	. 
l7523h:
	pop hl			;7523	e1 	. 
	pop hl			;7524	e1 	. 
	ld hl,(02a5ah)		;7525	2a 5a 2a 	* Z * 
	push hl			;7528	e5 	. 
	ld hl,(01b72h)		;7529	2a 72 1b 	* r . 
	push hl			;752c	e5 	. 
l752dh:
	and a			;752d	a7 	. 
	dec a			;752e	3d 	= 
	jr z,l7550h		;752f	28 1f 	( . 
	ex af,af'			;7531	08 	. 
	xor a			;7532	af 	. 
	ld h,d			;7533	62 	b 
	ld l,e			;7534	6b 	k 
	sbc hl,bc		;7535	ed 42 	. B 
	ccf			;7537	3f 	? 
	adc a,000h		;7538	ce 00 	. . 
	pop hl			;753a	e1 	. 
	sbc hl,de		;753b	ed 52 	. R 
	jr z,l7542h		;753d	28 03 	( . 
	ccf			;753f	3f 	? 
	adc a,000h		;7540	ce 00 	. . 
l7542h:
	pop hl			;7542	e1 	. 
	and a			;7543	a7 	. 
	sbc hl,bc		;7544	ed 42 	. B 
	adc a,000h		;7546	ce 00 	. . 
	cp 002h		;7548	fe 02 	. . 
	scf			;754a	37 	7 
	jr nz,l7550h		;754b	20 03 	  . 
	ex af,af'			;754d	08 	. 
	jr l752dh		;754e	18 dd 	. . 
l7550h:
	ld sp,00000h		;7550	31 00 00 	1 . . 
	ret			;7553	c9 	. 
	ld (00e84h),sp		;7554	ed 73 84 0e 	. s . . 
	ld a,(hl)			;7558	7e 	~ 
	inc hl			;7559	23 	# 
	ld sp,hl			;755a	f9 	. 
	pop hl			;755b	e1 	. 
	pop hl			;755c	e1 	. 
	ld hl,(02a5ah)		;755d	2a 5a 2a 	* Z * 
	push hl			;7560	e5 	. 
	ld hl,(01b72h)		;7561	2a 72 1b 	* r . 
	push hl			;7564	e5 	. 
l7565h:
	dec a			;7565	3d 	= 
	jr z,l7577h		;7566	28 0f 	( . 
	pop hl			;7568	e1 	. 
	or a			;7569	b7 	. 
	sbc hl,de		;756a	ed 52 	. R 
	pop hl			;756c	e1 	. 
	jr z,l7571h		;756d	28 02 	( . 
	jr nc,l7565h		;756f	30 f4 	0 . 
l7571h:
	and a			;7571	a7 	. 
	sbc hl,de		;7572	ed 52 	. R 
	ccf			;7574	3f 	? 
	jr nc,l7565h		;7575	30 ee 	0 . 
l7577h:
	ld sp,l8b91h		;7577	31 91 8b 	1 . . 
	ret			;757a	c9 	. 
	call 00c4fh		;757b	cd 4f 0c 	. O . 
	push hl			;757e	e5 	. 
	ld hl,(0000ah)		;757f	2a 0a 00 	* . . 
	ld a,l			;7582	7d 	} 
	and 0e0h		;7583	e6 e0 	. . 
	ld l,a			;7585	6f 	o 
	ld a,(0000eh)		;7586	3a 0e 00 	: . . 
	and 01fh		;7589	e6 1f 	. . 
	jp z,001b4h		;758b	ca b4 01 	. . . 
l758eh:
	dec a			;758e	3d 	= 
	jr z,l759dh		;758f	28 0c 	( . 
	ld d,h			;7591	54 	T 
	ld e,l			;7592	5d 	] 
	ex af,af'			;7593	08 	. 
	call 011d4h		;7594	cd d4 11 	. . . 
	call 01ec3h		;7597	cd c3 1e 	. . . 
	ex af,af'			;759a	08 	. 
	jr l758eh		;759b	18 f1 	. . 
l759dh:
	ld (029c8h),hl		;759d	22 c8 29 	" . ) 
	pop hl			;75a0	e1 	. 
	push hl			;75a1	e5 	. 
	ld b,020h		;75a2	06 20 	.   
	ld hl,02ce4h		;75a4	21 e4 2c 	! . , 
l75a7h:
	call 027edh		;75a7	cd ed 27 	. . ' 
	cp 020h		;75aa	fe 20 	.   
	jr nc,l75b0h		;75ac	30 02 	0 . 
	ld a,020h		;75ae	3e 20 	>   
l75b0h:
	call 029a9h		;75b0	cd a9 29 	. . ) 
	djnz l75a7h		;75b3	10 f2 	. . 
	pop hl			;75b5	e1 	. 
	ret			;75b6	c9 	. 
	ld hl,05800h		;75b7	21 00 58 	! . X 
	ld bc,00003h		;75ba	01 03 00 	. . . 
	push hl			;75bd	e5 	. 
	push bc			;75be	c5 	. 
l75bfh:
	ld (hl),039h		;75bf	36 39 	6 9 
	inc hl			;75c1	23 	# 
	djnz l75bfh		;75c2	10 fb 	. . 
	dec c			;75c4	0d 	. 
	jr nz,l75bfh		;75c5	20 f8 	  . 
	call 00fc4h		;75c7	cd c4 0f 	. . . 
	pop bc			;75ca	c1 	. 
	pop hl			;75cb	e1 	. 
l75cch:
	ld a,(hl)			;75cc	7e 	~ 
	cp 039h		;75cd	fe 39 	. 9 
	jr nz,l75e7h		;75cf	20 16 	  . 
	push hl			;75d1	e5 	. 
	ld a,h			;75d2	7c 	| 
	sub 00ah		;75d3	d6 0a 	. . 
l75d5h:
	ld h,a			;75d5	67 	g 
	and 007h		;75d6	e6 07 	. . 
	jr z,l75dfh		;75d8	28 05 	( . 
	ld a,h			;75da	7c 	| 
	sub 007h		;75db	d6 07 	. . 
	jr l75d5h		;75dd	18 f6 	. . 
l75dfh:
	ld e,008h		;75df	1e 08 	. . 
l75e1h:
	ld (hl),a			;75e1	77 	w 
	inc h			;75e2	24 	$ 
	dec e			;75e3	1d 	. 
	jr nz,l75e1h		;75e4	20 fb 	  . 
	pop hl			;75e6	e1 	. 
l75e7h:
	inc hl			;75e7	23 	# 
	djnz l75cch		;75e8	10 e2 	. . 
	dec c			;75ea	0d 	. 
	jr nz,l75cch		;75eb	20 df 	  . 
	ld bc,00000h		;75ed	01 00 00 	. . . 
	ld ix,00003h		;75f0	dd 21 03 00 	. ! . . 
	add ix,bc		;75f4	dd 09 	. . 
	push bc			;75f6	c5 	. 
	ld a,028h		;75f7	3e 28 	> ( 
	ld (029bch),a		;75f9	32 bc 29 	2 . ) 
	call 00ff1h		;75fc	cd f1 0f 	. . . 
	ld a,038h		;75ff	3e 38 	> 8 
	ld (029bch),a		;7601	32 bc 29 	2 . ) 
	call 02848h		;7604	cd 48 28 	. H ( 
	pop bc			;7607	c1 	. 
	cp 004h		;7608	fe 04 	. . 
	ret z			;760a	c8 	. 
	ld hl,00ec3h		;760b	21 c3 0e 	! . . 
	push hl			;760e	e5 	. 
	ld b,007h		;760f	06 07 	. . 
	cp 034h		;7611	fe 34 	. 4 
	jr z,l761bh		;7613	28 06 	( . 
	ld b,0f9h		;7615	06 f9 	. . 
	cp 033h		;7617	fe 33 	. 3 
	jr nz,l762ch		;7619	20 11 	  . 
l761bh:
	ld a,c			;761b	79 	y 
	add a,b			;761c	80 	. 
	cp 0f9h		;761d	fe f9 	. . 
	jr nz,l7623h		;761f	20 02 	  . 
	ld a,0e7h		;7621	3e e7 	> . 
l7623h:
	cp 0eeh		;7623	fe ee 	. . 
	jr c,l7628h		;7625	38 01 	8 . 
	xor a			;7627	af 	. 
l7628h:
	ld (00efah),a		;7628	32 fa 0e 	2 . . 
	ret			;762b	c9 	. 
l762ch:
	ld h,(ix+001h)		;762c	dd 66 01 	. f . 
	ld l,(ix+000h)		;762f	dd 6e 00 	. n . 
	ld b,001h		;7632	06 01 	. . 
	cp 038h		;7634	fe 38 	. 8 
	jr z,l7656h		;7636	28 1e 	( . 
	cp 036h		;7638	fe 36 	. 6 
	jr z,l7642h		;763a	28 06 	( . 
	cp 037h		;763c	fe 37 	. 7 
	jr nz,l7649h		;763e	20 09 	  . 
l7640h:
	ld b,017h		;7640	06 17 	. . 
l7642h:
	call 011d4h		;7642	cd d4 11 	. . . 
	djnz l7642h		;7645	10 fb 	. . 
	jr l7659h		;7647	18 10 	. . 
l7649h:
	cp 035h		;7649	fe 35 	. 5 
	jr nz,l7660h		;764b	20 13 	  . 
	ld b,01fh		;764d	06 1f 	. . 
l764fh:
	call 011c8h		;764f	cd c8 11 	. . . 
	djnz l764fh		;7652	10 fb 	. . 
	jr l7640h		;7654	18 ea 	. . 
l7656h:
	call 011c8h		;7656	cd c8 11 	. . . 
l7659h:
	ld (ix+001h),h		;7659	dd 74 01 	. t . 
	ld (ix+000h),l		;765c	dd 75 00 	. u . 
	ret			;765f	c9 	. 
l7660h:
	cp 061h		;7660	fe 61 	. a 
	jr c,l767dh		;7662	38 19 	8 . 
	cp 07bh		;7664	fe 7b 	. { 
	jr nc,l767dh		;7666	30 15 	0 . 
	sub 061h		;7668	d6 61 	. a 
	ld b,a			;766a	47 	G 
	ld a,(ix+004h)		;766b	dd 7e 04 	. ~ . 
	ld c,a			;766e	4f 	O 
	and 01fh		;766f	e6 1f 	. . 
	xor b			;7671	a8 	. 
	xor c			;7672	a9 	. 
	bit 7,c		;7673	cb 79 	. y 
	jr nz,l7679h		;7675	20 02 	  . 
	and 0e1h		;7677	e6 e1 	. . 
l7679h:
	ld (ix+004h),a		;7679	dd 77 04 	. w . 
	ret			;767c	c9 	. 
l767dh:
	ld d,(ix+003h)		;767d	dd 56 03 	. V . 
	ld e,(ix+004h)		;7680	dd 5e 04 	. ^ . 
	ld hl,00fa7h		;7683	21 a7 0f 	! . . 
	ld b,006h		;7686	06 06 	. . 
l7688h:
	cp (hl)			;7688	be 	. 
	inc hl			;7689	23 	# 
	jr z,l7691h		;768a	28 05 	( . 
	inc hl			;768c	23 	# 
	inc hl			;768d	23 	# 
	djnz l7688h		;768e	10 f8 	. . 
	ret			;7690	c9 	. 
l7691h:
	ld a,(hl)			;7691	7e 	~ 
	and e			;7692	a3 	. 
	ret z			;7693	c8 	. 
	inc hl			;7694	23 	# 
	ld a,(hl)			;7695	7e 	~ 
	xor d			;7696	aa 	. 
	ld (ix+003h),a		;7697	dd 77 03 	. w . 
	ret			;769a	c9 	. 
	ld e,h			;769b	5c 	\ 
	rst 38h			;769c	ff 	. 
	add a,b			;769d	80 	. 
	ld e,(hl)			;769e	5e 	^ 
	rst 38h			;769f	ff 	. 
	ld b,b			;76a0	40 	@ 
	ld hl,(020ffh)		;76a1	2a ff 20 	* .   
	ccf			;76a4	3f 	? 
	rst 38h			;76a5	ff 	. 
	djnz l76e6h		;76a6	10 3e 	. > 
	ld b,b			;76a8	40 	@ 
	ex af,af'			;76a9	08 	. 
	ld a,h			;76aa	7c 	| 
	jr nz,$+6		;76ab	20 04 	  . 
	ld hl,(0027bh)		;76ad	2a 7b 02 	* { . 
	ld ix,00011h		;76b0	dd 21 11 00 	. ! . . 
	ld b,020h		;76b4	06 20 	.   
	jr l76beh		;76b6	18 06 	. . 
	ld ix,00003h		;76b8	dd 21 03 00 	. ! . . 
	ld b,022h		;76bc	06 22 	. " 
l76beh:
	ld (010b9h),hl		;76be	22 b9 10 	" . . 
l76c1h:
	push bc			;76c1	c5 	. 
	call 00febh		;76c2	cd eb 0f 	. . . 
	ld bc,00007h		;76c5	01 07 00 	. . . 
	add ix,bc		;76c8	dd 09 	. . 
	pop bc			;76ca	c1 	. 
	djnz l76c1h		;76cb	10 f4 	. . 
	ret			;76cd	c9 	. 
l76ceh:
	ld a,028h		;76ce	3e 28 	> ( 
	call 029a9h		;76d0	cd a9 29 	. . ) 
	pop hl			;76d3	e1 	. 
	push hl			;76d4	e5 	. 
	call 0119dh		;76d5	cd 9d 11 	. . . 
	ld a,029h		;76d8	3e 29 	> ) 
l76dah:
	call 029a7h		;76da	cd a7 29 	. . ) 
	jr l770dh		;76dd	18 2e 	. . 
	ld a,(ix+004h)		;76df	dd 7e 04 	. ~ . 
	and 01fh		;76e2	e6 1f 	. . 
	ret z			;76e4	c8 	. 
	xor a			;76e5	af 	. 
l76e6h:
	ld (01135h),a		;76e6	32 35 11 	2 5 . 
	call 010cah		;76e9	cd ca 10 	. . . 
	ld l,(ix+005h)		;76ec	dd 6e 05 	. n . 
	ld h,(ix+006h)		;76ef	dd 66 06 	. f . 
	ld a,(ix+003h)		;76f2	dd 7e 03 	. ~ . 
	and 003h		;76f5	e6 03 	. . 
	dec a			;76f7	3d 	= 
	jr nz,l76feh		;76f8	20 04 	  . 
	ld e,(hl)			;76fa	5e 	^ 
	inc hl			;76fb	23 	# 
	ld d,(hl)			;76fc	56 	V 
	ex de,hl			;76fd	eb 	. 
l76feh:
	push hl			;76fe	e5 	. 
	ld a,(ix+002h)		;76ff	dd 7e 02 	. ~ . 
	cp 0d8h		;7702	fe d8 	. . 
	jr nc,l76ceh		;7704	30 c8 	0 . 
	cp 080h		;7706	fe 80 	. . 
	jr nc,l76dah		;7708	30 d0 	0 . 
	call 011afh		;770a	cd af 11 	. . . 
l770dh:
	ld a,03ah		;770d	3e 3a 	> : 
	call 029a9h		;770f	cd a9 29 	. . ) 
	pop de			;7712	d1 	. 
	ld a,(ix+004h)		;7713	dd 7e 04 	. ~ . 
	and 01fh		;7716	e6 1f 	. . 
	ld hl,(029c8h)		;7718	2a c8 29 	* . ) 
l771bh:
	ld bc,0112ch		;771b	01 2c 11 	. , . 
	or a			;771e	b7 	. 
	ret z			;771f	c8 	. 
	push af			;7720	f5 	. 
	push hl			;7721	e5 	. 
	ld a,(de)			;7722	1a 	. 
	ld l,a			;7723	6f 	o 
	inc de			;7724	13 	. 
	ld a,(de)			;7725	1a 	. 
	ld h,a			;7726	67 	g 
	ld a,(ix+003h)		;7727	dd 7e 03 	. ~ . 
	bit 3,a		;772a	cb 5f 	. _ 
	jr z,l772fh		;772c	28 01 	( . 
	inc de			;772e	13 	. 
l772fh:
	push de			;772f	d5 	. 
	ld e,a			;7730	5f 	_ 
	and 003h		;7731	e6 03 	. . 
	jp z,010dch		;7733	ca dc 10 	. . . 
	cp 003h		;7736	fe 03 	. . 
	jr nc,l7777h		;7738	30 3d 	0 = 
	ld d,004h		;773a	16 04 	. . 
l773ch:
	bit 3,(ix+003h)		;773c	dd cb 03 5e 	. . . ^ 
	push bc			;7740	c5 	. 
	jr z,l7744h		;7741	28 01 	( . 
	inc bc			;7743	03 	. 
l7744h:
	push ix		;7744	dd e5 	. . 
	ld ix,01141h		;7746	dd 21 41 11 	. ! A . 
	ld a,(bc)			;774a	0a 	. 
	ld b,000h		;774b	06 00 	. . 
	ld c,a			;774d	4f 	O 
	add ix,bc		;774e	dd 09 	. . 
	rl e		;7750	cb 13 	. . 
	push de			;7752	d5 	. 
	push hl			;7753	e5 	. 
	call c,01134h		;7754	dc 34 11 	. 4 . 
	pop hl			;7757	e1 	. 
	pop de			;7758	d1 	. 
	pop ix		;7759	dd e1 	. . 
	pop bc			;775b	c1 	. 
	inc bc			;775c	03 	. 
	inc bc			;775d	03 	. 
	dec d			;775e	15 	. 
	jr nz,l773ch		;775f	20 db 	  . 
	pop de			;7761	d1 	. 
	pop hl			;7762	e1 	. 
	bit 2,(ix+003h)		;7763	dd cb 03 56 	. . . V 
	jr z,l7773h		;7767	28 0a 	( . 
	call 011d4h		;7769	cd d4 11 	. . . 
	ld (029c8h),hl		;776c	22 c8 29 	" . ) 
	xor a			;776f	af 	. 
	ld (01135h),a		;7770	32 35 11 	2 5 . 
l7773h:
	pop af			;7773	f1 	. 
	dec a			;7774	3d 	= 
	jr l771bh		;7775	18 a4 	. . 
l7777h:
	pop de			;7777	d1 	. 
	pop hl			;7778	e1 	. 
	pop af			;7779	f1 	. 
	call 010cah		;777a	cd ca 10 	. . . 
	rlca			;777d	07 	. 
	rlca			;777e	07 	. 
	rlca			;777f	07 	. 
	ld l,a			;7780	6f 	o 
	ld h,000h		;7781	26 00 	& . 
	add hl,hl			;7783	29 	) 
	add hl,hl			;7784	29 	) 
l7785h:
	ld a,(ix+002h)		;7785	dd 7e 02 	. ~ . 
	cp 0c4h		;7788	fe c4 	. . 
	jr z,l77a3h		;778a	28 17 	( . 
	cp 0a3h		;778c	fe a3 	. . 
	jr z,l7799h		;778e	28 09 	( . 
	call 029a7h		;7790	cd a7 29 	. . ) 
	dec hl			;7793	2b 	+ 
	ld a,h			;7794	7c 	| 
	or l			;7795	b5 	. 
	jr nz,l7785h		;7796	20 ed 	  . 
	ret			;7798	c9 	. 
l7799h:
	ld a,000h		;7799	3e 00 	> . 
	add a,003h		;779b	c6 03 	. . 
	ld de,02eb6h		;779d	11 b6 2e 	. . . 
	jp 011b2h		;77a0	c3 b2 11 	. . . 
l77a3h:
	ld a,(ix+004h)		;77a3	dd 7e 04 	. ~ . 
	and 01fh		;77a6	e6 1f 	. . 
	ld b,a			;77a8	47 	G 
	call 00c59h		;77a9	cd 59 0c 	. Y . 
	ld hl,00000h		;77ac	21 00 00 	! . . 
	push ix		;77af	dd e5 	. . 
l77b1h:
	push bc			;77b1	c5 	. 
	call 00c4ah		;77b2	cd 4a 0c 	. J . 
	call 00eadh		;77b5	cd ad 0e 	. . . 
	pop bc			;77b8	c1 	. 
	djnz l77b1h		;77b9	10 f6 	. . 
	pop ix		;77bb	dd e1 	. . 
	ret			;77bd	c9 	. 
	ld l,(ix+000h)		;77be	dd 6e 00 	. n . 
	ld h,(ix+001h)		;77c1	dd 66 01 	. f . 
	ld (029c8h),hl		;77c4	22 c8 29 	" . ) 
	ret			;77c7	c9 	. 
	ld (hl),e			;77c8	73 	s 
	ld a,d			;77c9	7a 	z 
	dec l			;77ca	2d 	- 
	ld l,b			;77cb	68 	h 
	dec l			;77cc	2d 	- 
	ld (hl),b			;77cd	70 	p 
	ld l,(hl)			;77ce	6e 	n 
	ex (sp),hl			;77cf	e3 	. 
	pop af			;77d0	f1 	. 
	pop af			;77d1	f1 	. 
	ld a,l			;77d2	7d 	} 
	ex af,af'			;77d3	08 	. 
	ld c,l			;77d4	4d 	M 
	ld b,004h		;77d5	06 04 	. . 
	bit 5,e		;77d7	cb 6b 	. k 
	call 010cah		;77d9	cd ca 10 	. . . 
	push hl			;77dc	e5 	. 
	ld hl,01120h		;77dd	21 20 11 	!   . 
	jr z,l77f8h		;77e0	28 16 	( . 
	ld de,010d4h		;77e2	11 d4 10 	. . . 
	call 011b5h		;77e5	cd b5 11 	. . . 
	pop hl			;77e8	e1 	. 
	call 011d4h		;77e9	cd d4 11 	. . . 
	ld (029c8h),hl		;77ec	22 c8 29 	" . ) 
	ex af,af'			;77ef	08 	. 
	call 01176h		;77f0	cd 76 11 	. v . 
	pop hl			;77f3	e1 	. 
	ret			;77f4	c9 	. 
l77f5h:
	call 029a5h		;77f5	cd a5 29 	. . ) 
l77f8h:
	ld a,(hl)			;77f8	7e 	~ 
	inc hl			;77f9	23 	# 
	and c			;77fa	a1 	. 
	jr nz,l7801h		;77fb	20 04 	  . 
	inc hl			;77fd	23 	# 
	ld a,(hl)			;77fe	7e 	~ 
	jr l7803h		;77ff	18 02 	. . 
l7801h:
	ld a,(hl)			;7801	7e 	~ 
	inc hl			;7802	23 	# 
l7803h:
	inc hl			;7803	23 	# 
	push af			;7804	f5 	. 
	rlca			;7805	07 	. 
	call c,029a5h		;7806	dc a5 29 	. . ) 
	pop af			;7809	f1 	. 
	and 07fh		;780a	e6 7f 	.  
	call 011afh		;780c	cd af 11 	. . . 
	djnz l77f5h		;780f	10 e4 	. . 
	pop de			;7811	d1 	. 
	pop hl			;7812	e1 	. 
	ret			;7813	c9 	. 
	ld b,b			;7814	40 	@ 
	sub h			;7815	94 	. 
	jr nz,l7819h		;7816	20 01 	  . 
	adc a,e			;7818	8b 	. 
l7819h:
	rra			;7819	1f 	. 
	inc b			;781a	04 	. 
	ld hl,08022h		;781b	21 22 80 	! " . 
	ld de,00012h		;781e	11 12 00 	. . . 
	ex af,af'			;7821	08 	. 
	djnz $+32		;7822	10 1e 	. . 
	inc (hl)			;7824	34 	4 
	jr nc,l786eh		;7825	30 47 	0 G 
	ld b,e			;7827	43 	C 
	ld a,000h		;7828	3e 00 	> . 
	or a			;782a	b7 	. 
	call nz,029a5h		;782b	c4 a5 29 	. . ) 
	ld a,001h		;782e	3e 01 	> . 
	ld (01135h),a		;7830	32 35 11 	2 5 . 
	jp (ix)		;7833	dd e9 	. . 
	call 011a6h		;7835	cd a6 11 	. . . 
	call 02b72h		;7838	cd 72 2b 	. r + 
	jr l7859h		;783b	18 1c 	. . 
	call 011a8h		;783d	cd a8 11 	. . . 
	call 02b66h		;7840	cd 66 2b 	. f + 
	jr l7859h		;7843	18 14 	. . 
	call 011a6h		;7845	cd a6 11 	. . . 
	ld (ix+000h),023h		;7848	dd 36 00 23 	. 6 . # 
	inc ix		;784c	dd 23 	. # 
	call 02b5eh		;784e	cd 5e 2b 	. ^ + 
	jr l7859h		;7851	18 06 	. . 
	call 011a8h		;7853	cd a8 11 	. . . 
	call 02b4dh		;7856	cd 4d 2b 	. M + 
l7859h:
	ld hl,02d07h		;7859	21 07 2d 	! . - 
l785ch:
	ld a,(hl)			;785c	7e 	~ 
	or a			;785d	b7 	. 
	ret z			;785e	c8 	. 
	call 029a9h		;785f	cd a9 29 	. . ) 
	inc hl			;7862	23 	# 
	jr l785ch		;7863	18 f7 	. . 
	ld a,h			;7865	7c 	| 
	call 01176h		;7866	cd 76 11 	. v . 
	ld a,l			;7869	7d 	} 
	ld c,a			;786a	4f 	O 
	ld b,008h		;786b	06 08 	. . 
l786dh:
	xor a			;786d	af 	. 
l786eh:
	rl c		;786e	cb 11 	. . 
	adc a,030h		;7870	ce 30 	. 0 
	call 029a9h		;7872	cd a9 29 	. . ) 
	djnz l786dh		;7875	10 f6 	. . 
	ret			;7877	c9 	. 
	ld a,h			;7878	7c 	| 
	call 0118eh		;7879	cd 8e 11 	. . . 
	xor a			;787c	af 	. 
	ld h,l			;787d	65 	e 
	ld (01135h),a		;787e	32 35 11 	2 5 . 
	ld a,h			;7881	7c 	| 
	ld h,a			;7882	67 	g 
	and 07fh		;7883	e6 7f 	.  
	cp 020h		;7885	fe 20 	.   
	ld a,h			;7887	7c 	| 
	jr nc,l788eh		;7888	30 04 	0 . 
	and 080h		;788a	e6 80 	. . 
	or 02eh		;788c	f6 2e 	. . 
l788eh:
	jp 029a9h		;788e	c3 a9 29 	. . ) 
	push ix		;7891	dd e5 	. . 
	call 02b42h		;7893	cd 42 2b 	. B + 
	pop ix		;7896	dd e1 	. . 
	jr l7859h		;7898	18 bf 	. . 
	ld h,000h		;789a	26 00 	& . 
	ld ix,02d07h		;789c	dd 21 07 2d 	. ! . - 
	ld c,000h		;78a0	0e 00 	. . 
	ret			;78a2	c9 	. 
	ld de,02ff4h		;78a3	11 f4 2f 	. . / 
	call 02509h		;78a6	cd 09 25 	. . % 
l78a9h:
	ld a,(de)			;78a9	1a 	. 
	res 7,a		;78aa	cb bf 	. . 
	call 0296eh		;78ac	cd 6e 29 	. n ) 
	jr nz,l78b3h		;78af	20 02 	  . 
	sub 020h		;78b1	d6 20 	.   
l78b3h:
	call 029a7h		;78b3	cd a7 29 	. . ) 
	ld a,(de)			;78b6	1a 	. 
	inc de			;78b7	13 	. 
	rla			;78b8	17 	. 
	jr nc,l78a9h		;78b9	30 ee 	0 . 
	ret			;78bb	c9 	. 
	inc l			;78bc	2c 	, 
	ret nz			;78bd	c0 	. 
l78beh:
	ld a,h			;78be	7c 	| 
	add a,008h		;78bf	c6 08 	. . 
	cp 058h		;78c1	fe 58 	. X 
	ld h,a			;78c3	67 	g 
	ret nz			;78c4	c0 	. 
	ld h,040h		;78c5	26 40 	& @ 
	ret			;78c7	c9 	. 
	ld a,l			;78c8	7d 	} 
	add a,020h		;78c9	c6 20 	.   
	ld l,a			;78cb	6f 	o 
	ret nc			;78cc	d0 	. 
	jr l78beh		;78cd	18 ef 	. . 

; BLOCK 'data_78cf' (start 0x78cf end 0x7ab3)
data_78cf_start:
	defb 000h		;78cf	00 	. 
	defb 000h		;78d0	00 	. 
	defb 000h		;78d1	00 	. 
	defb 000h		;78d2	00 	. 
	defb 000h		;78d3	00 	. 
	defb 000h		;78d4	00 	. 
	defb 000h		;78d5	00 	. 
	defb 000h		;78d6	00 	. 
	defb 000h		;78d7	00 	. 
	defb 000h		;78d8	00 	. 
	defb 03ah		;78d9	3a 	: 
	defb 05ch		;78da	5c 	\ 
	defb 000h		;78db	00 	. 
	defb 000h		;78dc	00 	. 
	defb 0ffh		;78dd	ff 	. 
	defb 0afh		;78de	af 	. 
	defb 001h		;78df	01 	. 
	defb 001h		;78e0	01 	. 
	defb 000h		;78e1	00 	. 
	defb 000h		;78e2	00 	. 
	defb 000h		;78e3	00 	. 
	defb 000h		;78e4	00 	. 
	defb 000h		;78e5	00 	. 
	defb 000h		;78e6	00 	. 
	defb 000h		;78e7	00 	. 
	defb 000h		;78e8	00 	. 
	defb 000h		;78e9	00 	. 
	defb 000h		;78ea	00 	. 
	defb 000h		;78eb	00 	. 
	defb 000h		;78ec	00 	. 
	defb 01bh		;78ed	1b 	. 
	defb 0ffh		;78ee	ff 	. 
	defb 0e3h		;78ef	e3 	. 
	defb 00dh		;78f0	0d 	. 
	defb 0ffh		;78f1	ff 	. 
	defb 0e3h		;78f2	e3 	. 
	defb 01dh		;78f3	1d 	. 
	defb 0ffh		;78f4	ff 	. 
	defb 0e3h		;78f5	e3 	. 
	defb 02dh		;78f6	2d 	- 
	defb 0ffh		;78f7	ff 	. 
	defb 0c9h		;78f8	c9 	. 
	defb 00dh		;78f9	0d 	. 
	defb 0cfh		;78fa	cf 	. 
	defb 0c1h		;78fb	c1 	. 
	defb 00dh		;78fc	0d 	. 
	defb 0c7h		;78fd	c7 	. 
	defb 0c0h		;78fe	c0 	. 
	defb 00dh		;78ff	0d 	. 
	defb 0f7h		;7900	f7 	. 
	defb 0a0h		;7901	a0 	. 
	defb 042h		;7902	42 	B 
	defb 0c7h		;7903	c7 	. 
	defb 086h		;7904	86 	. 
	defb 014h		;7905	14 	. 
	defb 0c7h		;7906	c7 	. 
	defb 086h		;7907	86 	. 
	defb 023h		;7908	23 	# 
	defb 0c7h		;7909	c7 	. 
	defb 086h		;790a	86 	. 
	defb 002h		;790b	02 	. 
	defb 0cfh		;790c	cf 	. 
	defb 04bh		;790d	4b 	K 
	defb 04fh		;790e	4f 	O 
	defb 0c7h		;790f	c7 	. 
	defb 046h		;7910	46 	F 
	defb 014h		;7911	14 	. 
	defb 0c7h		;7912	c7 	. 
	defb 046h		;7913	46 	F 
	defb 023h		;7914	23 	# 
	defb 0c7h		;7915	c7 	. 
	defb 046h		;7916	46 	F 
	defb 002h		;7917	02 	. 
	defb 0f7h		;7918	f7 	. 
	defb 045h		;7919	45 	E 
	defb 045h		;791a	45 	E 
	defb 0ffh		;791b	ff 	. 
	defb 03ah		;791c	3a 	: 
	defb 007h		;791d	07 	. 
	defb 0feh		;791e	fe 	. 
	defb 034h		;791f	34 	4 
	defb 014h		;7920	14 	. 
	defb 0feh		;7921	fe 	. 
	defb 034h		;7922	34 	4 
	defb 023h		;7923	23 	# 
	defb 0feh		;7924	fe 	. 
	defb 034h		;7925	34 	4 
	defb 002h		;7926	02 	. 
	defb 0ffh		;7927	ff 	. 
	defb 02ah		;7928	2a 	* 
	defb 00fh		;7929	0f 	. 
	defb 0ffh		;792a	ff 	. 
	defb 02ah		;792b	2a 	* 
	defb 01fh		;792c	1f 	. 
	defb 0ffh		;792d	ff 	. 
	defb 02ah		;792e	2a 	* 
	defb 02fh		;792f	2f 	/ 
	defb 0ffh		;7930	ff 	. 
	defb 01ah		;7931	1a 	. 
	defb 001h		;7932	01 	. 
	defb 0ffh		;7933	ff 	. 
	defb 00ah		;7934	0a 	. 
	defb 000h		;7935	00 	. 
	defb 087h		;7936	87 	. 
	defb 006h		;7937	06 	. 
	defb 094h		;7938	94 	. 
	defb 087h		;7939	87 	. 
	defb 006h		;793a	06 	. 
	defb 0a3h		;793b	a3 	. 
	defb 087h		;793c	87 	. 
	defb 006h		;793d	06 	. 
	defb 082h		;793e	82 	. 
	defb 01eh		;793f	1e 	. 
	defb 0ffh		;7940	ff 	. 
	defb 0e3h		;7941	e3 	. 
	defb 00dh		;7942	0d 	. 
	defb 0ffh		;7943	ff 	. 
	defb 0e3h		;7944	e3 	. 
	defb 01dh		;7945	1d 	. 
	defb 0ffh		;7946	ff 	. 
	defb 0e3h		;7947	e3 	. 
	defb 02dh		;7948	2d 	- 
	defb 0ffh		;7949	ff 	. 
	defb 0cdh		;794a	cd 	. 
	defb 00eh		;794b	0e 	. 
	defb 0c7h		;794c	c7 	. 
	defb 0c7h		;794d	c7 	. 
	defb 00eh		;794e	0e 	. 
	defb 0cfh		;794f	cf 	. 
	defb 0c5h		;7950	c5 	. 
	defb 00eh		;7951	0e 	. 
	defb 0c7h		;7952	c7 	. 
	defb 0c4h		;7953	c4 	. 
	defb 00eh		;7954	0e 	. 
	defb 0f7h		;7955	f7 	. 
	defb 0a0h		;7956	a0 	. 
	defb 041h		;7957	41 	A 
	defb 087h		;7958	87 	. 
	defb 086h		;7959	86 	. 
	defb 094h		;795a	94 	. 
	defb 087h		;795b	87 	. 
	defb 086h		;795c	86 	. 
	defb 0a3h		;795d	a3 	. 
	defb 087h		;795e	87 	. 
	defb 086h		;795f	86 	. 
	defb 082h		;7960	82 	. 
	defb 0f8h		;7961	f8 	. 
	defb 070h		;7962	70 	p 
	defb 014h		;7963	14 	. 
	defb 0f8h		;7964	f8 	. 
	defb 070h		;7965	70 	p 
	defb 023h		;7966	23 	# 
	defb 0f8h		;7967	f8 	. 
	defb 070h		;7968	70 	p 
	defb 002h		;7969	02 	. 
	defb 0cfh		;796a	cf 	. 
	defb 043h		;796b	43 	C 
	defb 04fh		;796c	4f 	O 
	defb 0ffh		;796d	ff 	. 
	defb 036h		;796e	36 	6 
	defb 014h		;796f	14 	. 
	defb 0ffh		;7970	ff 	. 
	defb 036h		;7971	36 	6 
	defb 023h		;7972	23 	# 
	defb 0ffh		;7973	ff 	. 
	defb 036h		;7974	36 	6 
	defb 002h		;7975	02 	. 
	defb 0feh		;7976	fe 	. 
	defb 034h		;7977	34 	4 
	defb 014h		;7978	14 	. 
	defb 0feh		;7979	fe 	. 
	defb 034h		;797a	34 	4 
	defb 023h		;797b	23 	# 
	defb 0feh		;797c	fe 	. 
	defb 034h		;797d	34 	4 
	defb 002h		;797e	02 	. 
	defb 0ffh		;797f	ff 	. 
	defb 032h		;7980	32 	2 
	defb 007h		;7981	07 	. 
	defb 0ffh		;7982	ff 	. 
	defb 022h		;7983	22 	" 
	defb 00fh		;7984	0f 	. 
	defb 0ffh		;7985	ff 	. 
	defb 022h		;7986	22 	" 
	defb 01fh		;7987	1f 	. 
	defb 0ffh		;7988	ff 	. 
	defb 022h		;7989	22 	" 
	defb 02fh		;798a	2f 	/ 
	defb 0ffh		;798b	ff 	. 
	defb 012h		;798c	12 	. 
	defb 001h		;798d	01 	. 
	defb 0c7h		;798e	c7 	. 
	defb 006h		;798f	06 	. 
	defb 094h		;7990	94 	. 
	defb 0c7h		;7991	c7 	. 
	defb 006h		;7992	06 	. 
	defb 0a3h		;7993	a3 	. 
	defb 0c7h		;7994	c7 	. 
	defb 006h		;7995	06 	. 
	defb 082h		;7996	82 	. 
	defb 0ffh		;7997	ff 	. 
	defb 002h		;7998	02 	. 
	defb 000h		;7999	00 	. 
	defb 00eh		;799a	0e 	. 
	defb 0ffh		;799b	ff 	. 
	defb 0e9h		;799c	e9 	. 
	defb 016h		;799d	16 	. 
	defb 0ffh		;799e	ff 	. 
	defb 0e9h		;799f	e9 	. 
	defb 025h		;79a0	25 	% 
	defb 0ffh		;79a1	ff 	. 
	defb 0e9h		;79a2	e9 	. 
	defb 004h		;79a3	04 	. 
	defb 0ffh		;79a4	ff 	. 
	defb 0cdh		;79a5	cd 	. 
	defb 001h		;79a6	01 	. 
	defb 0ffh		;79a7	ff 	. 
	defb 0c9h		;79a8	c9 	. 
	defb 002h		;79a9	02 	. 
	defb 0c7h		;79aa	c7 	. 
	defb 0c7h		;79ab	c7 	. 
	defb 003h		;79ac	03 	. 
	defb 0c7h		;79ad	c7 	. 
	defb 0c4h		;79ae	c4 	. 
	defb 001h		;79af	01 	. 
	defb 0ffh		;79b0	ff 	. 
	defb 0c3h		;79b1	c3 	. 
	defb 001h		;79b2	01 	. 
	defb 0c7h		;79b3	c7 	. 
	defb 0c2h		;79b4	c2 	. 
	defb 001h		;79b5	01 	. 
	defb 0c7h		;79b6	c7 	. 
	defb 0c0h		;79b7	c0 	. 
	defb 002h		;79b8	02 	. 
	defb 0f7h		;79b9	f7 	. 
	defb 045h		;79ba	45 	E 
	defb 047h		;79bb	47 	G 
	defb 0e7h		;79bc	e7 	. 
	defb 020h		;79bd	20 	  
	defb 000h		;79be	00 	. 
	defb 0ffh		;79bf	ff 	. 
	defb 018h		;79c0	18 	. 
	defb 000h		;79c1	00 	. 
	defb 0ffh		;79c2	ff 	. 
	defb 010h		;79c3	10 	. 
	defb 000h		;79c4	00 	. 
	defb 01ah		;79c5	1a 	. 
	defb 01fh		;79c6	1f 	. 
	defb 023h		;79c7	23 	# 
	defb 026h		;79c8	26 	& 
	defb 02bh		;79c9	2b 	+ 
	defb 02ch		;79ca	2c 	, 
	defb 03dh		;79cb	3d 	= 
	defb 03fh		;79cc	3f 	? 
	defb 041h		;79cd	41 	A 
	defb 043h		;79ce	43 	C 
	defb 045h		;79cf	45 	E 
	defb 047h		;79d0	47 	G 
	defb 04ah		;79d1	4a 	J 
	defb 053h		;79d2	53 	S 
	defb 055h		;79d3	55 	U 
	defb 05dh		;79d4	5d 	] 
	defb 061h		;79d5	61 	a 
	defb 066h		;79d6	66 	f 
	defb 06dh		;79d7	6d 	m 
	defb 073h		;79d8	73 	s 
	defb 076h		;79d9	76 	v 
	defb 079h		;79da	79 	y 
	defb 080h		;79db	80 	. 
	defb 083h		;79dc	83 	. 
	defb 084h		;79dd	84 	. 
	defb 089h		;79de	89 	. 
	defb 04ch		;79df	4c 	L 
	defb 065h		;79e0	65 	e 
	defb 06eh		;79e1	6e 	n 
	defb 067h		;79e2	67 	g 
	defb 074h		;79e3	74 	t 
	defb 0e8h		;79e4	e8 	. 
	defb 046h		;79e5	46 	F 
	defb 069h		;79e6	69 	i 
	defb 072h		;79e7	72 	r 
	defb 073h		;79e8	73 	s 
	defb 0f4h		;79e9	f4 	. 
	defb 04ch		;79ea	4c 	L 
	defb 061h		;79eb	61 	a 
	defb 073h		;79ec	73 	s 
	defb 0f4h		;79ed	f4 	. 
	defb 04dh		;79ee	4d 	M 
	defb 065h		;79ef	65 	e 
	defb 06dh		;79f0	6d 	m 
	defb 06fh		;79f1	6f 	o 
	defb 072h		;79f2	72 	r 
	defb 0f9h		;79f3	f9 	. 
	defb 06ch		;79f4	6c 	l 
	defb 0e4h		;79f5	e4 	. 
	defb 020h		;79f6	20 	  
	defb 055h		;79f7	55 	U 
	defb 04eh		;79f8	4e 	N 
	defb 049h		;79f9	49 	I 
	defb 056h		;79fa	56 	V 
	defb 045h		;79fb	45 	E 
	defb 052h		;79fc	52 	R 
	defb 053h		;79fd	53 	S 
	defb 055h		;79fe	55 	U 
	defb 04dh		;79ff	4d 	M 
	defb 020h		;7a00	20 	  
	defb 043h		;7a01	43 	C 
	defb 06fh		;7a02	6f 	o 
	defb 06eh		;7a03	6e 	n 
	defb 074h		;7a04	74 	t 
	defb 072h		;7a05	72 	r 
	defb 06fh		;7a06	6f 	o 
	defb 0ech		;7a07	ec 	. 
	defb 04fh		;7a08	4f 	O 
	defb 04eh		;7a09	4e 	N 
	defb 0a0h		;7a0a	a0 	. 
	defb 04fh		;7a0b	4f 	O 
	defb 046h		;7a0c	46 	F 
	defb 0c6h		;7a0d	c6 	. 
	defb 04eh		;7a0e	4e 	N 
	defb 04fh		;7a0f	4f 	O 
	defb 0ceh		;7a10	ce 	. 
	defb 044h		;7a11	44 	D 
	defb 045h		;7a12	45 	E 
	defb 0c6h		;7a13	c6 	. 
	defb 041h		;7a14	41 	A 
	defb 04ch		;7a15	4c 	L 
	defb 0cch		;7a16	cc 	. 
	defb 043h		;7a17	43 	C 
	defb 061h		;7a18	61 	a 
	defb 06ch		;7a19	6c 	l 
	defb 0ech		;7a1a	ec 	. 
	defb 052h		;7a1b	52 	R 
	defb 065h		;7a1c	65 	e 
	defb 061h		;7a1d	61 	a 
	defb 064h		;7a1e	64 	d 
	defb 02fh		;7a1f	2f 	/ 
	defb 057h		;7a20	57 	W 
	defb 072h		;7a21	72 	r 
	defb 069h		;7a22	69 	i 
	defb 074h		;7a23	74 	t 
	defb 0e5h		;7a24	e5 	. 
	defb 052h		;7a25	52 	R 
	defb 075h		;7a26	75 	u 
	defb 0eeh		;7a27	ee 	. 
	defb 049h		;7a28	49 	I 
	defb 06eh		;7a29	6e 	n 
	defb 074h		;7a2a	74 	t 
	defb 065h		;7a2b	65 	e 
	defb 072h		;7a2c	72 	r 
	defb 072h		;7a2d	72 	r 
	defb 075h		;7a2e	75 	u 
	defb 070h		;7a2f	70 	p 
	defb 0f4h		;7a30	f4 	. 
	defb 045h		;7a31	45 	E 
	defb 052h		;7a32	52 	R 
	defb 052h		;7a33	52 	R 
	defb 04fh		;7a34	4f 	O 
	defb 0d2h		;7a35	d2 	. 
	defb 04eh		;7a36	4e 	N 
	defb 06fh		;7a37	6f 	o 
	defb 020h		;7a38	20 	  
	defb 072h		;7a39	72 	r 
	defb 075h		;7a3a	75 	u 
	defb 0eeh		;7a3b	ee 	. 
	defb 04eh		;7a3c	4e 	N 
	defb 06fh		;7a3d	6f 	o 
	defb 020h		;7a3e	20 	  
	defb 077h		;7a3f	77 	w 
	defb 072h		;7a40	72 	r 
	defb 069h		;7a41	69 	i 
	defb 074h		;7a42	74 	t 
	defb 0e5h		;7a43	e5 	. 
	defb 04eh		;7a44	4e 	N 
	defb 06fh		;7a45	6f 	o 
	defb 020h		;7a46	20 	  
	defb 072h		;7a47	72 	r 
	defb 065h		;7a48	65 	e 
	defb 061h		;7a49	61 	a 
	defb 0e4h		;7a4a	e4 	. 
	defb 044h		;7a4b	44 	D 
	defb 065h		;7a4c	65 	e 
	defb 066h		;7a4d	66 	f 
	defb 0e2h		;7a4e	e2 	. 
	defb 044h		;7a4f	44 	D 
	defb 065h		;7a50	65 	e 
	defb 066h		;7a51	66 	f 
	defb 0f7h		;7a52	f7 	. 
	defb 077h		;7a53	77 	w 
	defb 069h		;7a54	69 	i 
	defb 06eh		;7a55	6e 	n 
	defb 064h		;7a56	64 	d 
	defb 06fh		;7a57	6f 	o 
	defb 077h		;7a58	77 	w 
	defb 073h		;7a59	73 	s 
	defb 0bah		;7a5a	ba 	. 
	defb 057h		;7a5b	57 	W 
	defb 069h		;7a5c	69 	i 
	defb 074h		;7a5d	74 	t 
	defb 0e8h		;7a5e	e8 	. 
	defb 054h		;7a5f	54 	T 
	defb 0efh		;7a60	ef 	. 
	defb 04ch		;7a61	4c 	L 
	defb 065h		;7a62	65 	e 
	defb 061h		;7a63	61 	a 
	defb 064h		;7a64	64 	d 
	defb 065h		;7a65	65 	e 
	defb 0f2h		;7a66	f2 	. 
	defb 031h		;7a67	31 	1 
	defb 02eh		;7a68	2e 	. 
	defb 020h		;7a69	20 	  
	defb 062h		;7a6a	62 	b 
	defb 079h		;7a6b	79 	y 
	defb 074h		;7a6c	74 	t 
	defb 065h		;7a6d	65 	e 
	defb 0bah		;7a6e	ba 	. 
	defb 000h		;7a6f	00 	. 
	defb 000h		;7a70	00 	. 
	defb 000h		;7a71	00 	. 
	defb 000h		;7a72	00 	. 
	defb 000h		;7a73	00 	. 
	defb 000h		;7a74	00 	. 
	defb 000h		;7a75	00 	. 
	defb 000h		;7a76	00 	. 
	defb 000h		;7a77	00 	. 
	defb 000h		;7a78	00 	. 
	defb 000h		;7a79	00 	. 
	defb 000h		;7a7a	00 	. 
	defb 000h		;7a7b	00 	. 
	defb 0c3h		;7a7c	c3 	. 
	defb 009h		;7a7d	09 	. 
	defb 01fh		;7a7e	1f 	. 
	defb 09fh		;7a7f	9f 	. 
	defb 01ah		;7a80	1a 	. 
	defb 086h		;7a81	86 	. 
	defb 01eh		;7a82	1e 	. 
	defb 07fh		;7a83	7f 	 
	defb 02ch		;7a84	2c 	, 
	defb 083h		;7a85	83 	. 
	defb 015h		;7a86	15 	. 
	defb 0c6h		;7a87	c6 	. 
	defb 013h		;7a88	13 	. 
	defb 0e1h		;7a89	e1 	. 
	defb 014h		;7a8a	14 	. 
	defb 0bbh		;7a8b	bb 	. 
	defb 019h		;7a8c	19 	. 
	defb 079h		;7a8d	79 	y 
	defb 01eh		;7a8e	1e 	. 
	defb 0bbh		;7a8f	bb 	. 
	defb 019h		;7a90	19 	. 
	defb 0bbh		;7a91	bb 	. 
	defb 019h		;7a92	19 	. 
	defb 0bfh		;7a93	bf 	. 
	defb 013h		;7a94	13 	. 
	defb 056h		;7a95	56 	V 
	defb 019h		;7a96	19 	. 
	defb 007h		;7a97	07 	. 
	defb 01eh		;7a98	1e 	. 
	defb 0b7h		;7a99	b7 	. 
	defb 011h		;7a9a	11 	. 
	defb 0b7h		;7a9b	b7 	. 
	defb 011h		;7a9c	11 	. 
	defb 059h		;7a9d	59 	Y 
	defb 015h		;7a9e	15 	. 
	defb 015h		;7a9f	15 	. 
	defb 01eh		;7aa0	1e 	. 
	defb 0f0h		;7aa1	f0 	. 
	defb 01eh		;7aa2	1e 	. 
	defb 047h		;7aa3	47 	G 
	defb 018h		;7aa4	18 	. 
	defb 0e8h		;7aa5	e8 	. 
	defb 016h		;7aa6	16 	. 
	defb 0d6h		;7aa7	d6 	. 
	defb 013h		;7aa8	13 	. 
	defb 01fh		;7aa9	1f 	. 
	defb 019h		;7aaa	19 	. 
	defb 07eh		;7aab	7e 	~ 
	defb 01eh		;7aac	1e 	. 
	defb 016h		;7aad	16 	. 
	defb 017h		;7aae	17 	. 
	defb 016h		;7aaf	16 	. 
	defb 017h		;7ab0	17 	. 
	defb 071h		;7ab1	71 	q 
	defb 014h		;7ab2	14 	. 
data_78cf_end:
	ld hl,03e68h		;7ab3	21 68 3e 	! h > 
l7ab6h:
	ld (024adh),hl		;7ab6	22 ad 24 	" . $ 
	ret			;7ab9	c9 	. 
	call 013ceh		;7aba	cd ce 13 	. . . 
	call 02475h		;7abd	cd 75 24 	. u $ 
	jr l7ab6h		;7ac0	18 f4 	. . 
	ld hl,(02a17h)		;7ac2	2a 17 2a 	* . * 
	ld de,0fff4h		;7ac5	11 f4 ff 	. . . 
	add hl,de			;7ac8	19 	. 
	ret			;7ac9	c9 	. 
	call 013ddh		;7aca	cd dd 13 	. . . 
	ld (01b86h),hl		;7acd	22 86 1b 	" . . 
	ret			;7ad0	c9 	. 
	ld hl,02d40h		;7ad1	21 40 2d 	! @ - 
	ld de,02d11h		;7ad4	11 11 2d 	. . - 
	push de			;7ad7	d5 	. 
	ld c,01eh		;7ad8	0e 1e 	. . 
	call 027b7h		;7ada	cd b7 27 	. . ' 
	pop de			;7add	d1 	. 
	ld hl,00000h		;7ade	21 00 00 	! . . 
	ld a,02bh		;7ae1	3e 2b 	> + 
	ld ix,02ce5h		;7ae3	dd 21 e5 2c 	. ! . , 
l7ae7h:
	push hl			;7ae7	e5 	. 
	push af			;7ae8	f5 	. 
	call 026d2h		;7ae9	cd d2 26 	. . & 
	jp c,022c9h		;7aec	da c9 22 	. . " 
	cp 02bh		;7aef	fe 2b 	. + 
	jr z,l7afah		;7af1	28 07 	( . 
	ld (01449h),a		;7af3	32 49 14 	2 I . 
	cp 02dh		;7af6	fe 2d 	. - 
	jr nz,l7afdh		;7af8	20 03 	  . 
l7afah:
	call 026d2h		;7afa	cd d2 26 	. . & 
l7afdh:
	cp 024h		;7afd	fe 24 	. $ 
	ld hl,(01b94h)		;7aff	2a 94 1b 	* . . 
	jr z,l7b31h		;7b02	28 2d 	( - 
	call 0296eh		;7b04	cd 6e 29 	. n ) 
	jr nz,l7b36h		;7b07	20 2d 	  - 
	dec de			;7b09	1b 	. 
	push de			;7b0a	d5 	. 
	push ix		;7b0b	dd e5 	. . 
	ex de,hl			;7b0d	eb 	. 
	call 029eah		;7b0e	cd ea 29 	. . ) 
	ld a,009h		;7b11	3e 09 	> . 
	jp c,022dah		;7b13	da da 22 	. . " 
	pop ix		;7b16	dd e1 	. . 
	ex de,hl			;7b18	eb 	. 
	call 02356h		;7b19	cd 56 23 	. V # 
	ld a,(hl)			;7b1c	7e 	~ 
	and 0c0h		;7b1d	e6 c0 	. . 
	ld a,009h		;7b1f	3e 09 	> . 
	jp z,022dah		;7b21	ca da 22 	. . " 
	dec de			;7b24	1b 	. 
	ex de,hl			;7b25	eb 	. 
	ld d,(hl)			;7b26	56 	V 
	dec hl			;7b27	2b 	+ 
	ld e,(hl)			;7b28	5e 	^ 
	pop bc			;7b29	c1 	. 
	ld hl,(02d07h)		;7b2a	2a 07 2d 	* . - 
	ld h,000h		;7b2d	26 00 	& . 
	add hl,bc			;7b2f	09 	. 
	ex de,hl			;7b30	eb 	. 
l7b31h:
	call 026d2h		;7b31	cd d2 26 	. . & 
	jr l7b39h		;7b34	18 03 	. . 
l7b36h:
	call 02659h		;7b36	cd 59 26 	. Y & 
l7b39h:
	push af			;7b39	f5 	. 
	push de			;7b3a	d5 	. 
	ex de,hl			;7b3b	eb 	. 
	ld a,032h		;7b3c	3e 32 	> 2 
	call 01d90h		;7b3e	cd 90 1d 	. . . 
	pop hl			;7b41	e1 	. 
	pop bc			;7b42	c1 	. 
	pop af			;7b43	f1 	. 
	ex (sp),hl			;7b44	e3 	. 
	push bc			;7b45	c5 	. 
	call 01d4fh		;7b46	cd 4f 1d 	. O . 
	pop af			;7b49	f1 	. 
	pop de			;7b4a	d1 	. 
	ret c			;7b4b	d8 	. 
	jr l7ae7h		;7b4c	18 99 	. . 
	push hl			;7b4e	e5 	. 
	call 02bcah		;7b4f	cd ca 2b 	. . + 
l7b52h:
	ld hl,03e68h		;7b52	21 68 3e 	! h > 
	call 02c6fh		;7b55	cd 6f 2c 	. o , 
	jr c,l7b63h		;7b58	38 09 	8 . 
	ld d,h			;7b5a	54 	T 
	ld e,l			;7b5b	5d 	] 
	ld c,002h		;7b5c	0e 02 	. . 
	call 02cach		;7b5e	cd ac 2c 	. . , 
	jr l7b52h		;7b61	18 ef 	. . 
l7b63h:
	pop hl			;7b63	e1 	. 
	ret			;7b64	c9 	. 
	ld b,03ah		;7b65	06 3a 	. : 
	call 01e6ch		;7b67	cd 6c 1e 	. l . 
	ld de,015e9h		;7b6a	11 e9 15 	. . . 
	call z,01544h		;7b6d	cc 44 15 	. D . 
	ld ix,(024adh)		;7b70	dd 2a ad 24 	. * . $ 
	ld (0151eh),ix		;7b74	dd 22 1e 15 	. " . . 
	call 02375h		;7b78	cd 75 23 	. u # 
	ld hl,02ce5h		;7b7b	21 e5 2c 	! . , 
	ld de,02d3fh		;7b7e	11 3f 2d 	. ? - 
	ld a,001h		;7b81	3e 01 	> . 
	ld (de),a			;7b83	12 	. 
	inc de			;7b84	13 	. 
	ld c,01fh		;7b85	0e 1f 	. . 
l7b87h:
	push hl			;7b87	e5 	. 
	push de			;7b88	d5 	. 
	ex de,hl			;7b89	eb 	. 
	call 015b9h		;7b8a	cd b9 15 	. . . 
	pop de			;7b8d	d1 	. 
	jr nc,l7ba8h		;7b8e	30 18 	0 . 
	ld hl,015e8h		;7b90	21 e8 15 	! . . 
	ld b,(hl)			;7b93	46 	F 
l7b94h:
	inc hl			;7b94	23 	# 
	ld a,(hl)			;7b95	7e 	~ 
	call 01edbh		;7b96	cd db 1e 	. . . 
	djnz l7b94h		;7b99	10 f9 	. . 
	pop hl			;7b9b	e1 	. 
	ld a,(015cdh)		;7b9c	3a cd 15 	: . . 
	ld b,a			;7b9f	47 	G 
l7ba0h:
	call 027eeh		;7ba0	cd ee 27 	. . ' 
	inc hl			;7ba3	23 	# 
	djnz l7ba0h		;7ba4	10 fa 	. . 
	jr l7b87h		;7ba6	18 df 	. . 
l7ba8h:
	pop hl			;7ba8	e1 	. 
	call 027eeh		;7ba9	cd ee 27 	. . ' 
	inc hl			;7bac	23 	# 
	or a			;7bad	b7 	. 
	jr z,l7bb5h		;7bae	28 05 	( . 
	call 01edbh		;7bb0	cd db 1e 	. . . 
	jr l7b87h		;7bb3	18 d2 	. . 
l7bb5h:
	inc a			;7bb5	3c 	< 
	ld (de),a			;7bb6	12 	. 
	ld (0205fh),a		;7bb7	32 5f 20 	2 _   
	dec a			;7bba	3d 	= 
	inc c			;7bbb	0c 	. 
l7bbch:
	ld (de),a			;7bbc	12 	. 
	dec c			;7bbd	0d 	. 
	jr nz,l7bbch		;7bbe	20 fc 	  . 
	ld hl,014d5h		;7bc0	21 d5 14 	! . . 
	ld (02079h),hl		;7bc3	22 79 20 	" y   
	jp 0201dh		;7bc6	c3 1d 20 	. .   
	ld hl,01f0fh		;7bc9	21 0f 1f 	! . . 
	ld (02079h),hl		;7bcc	22 79 20 	" y   
	call 01514h		;7bcf	cd 14 15 	. . . 
	jp 02074h		;7bd2	c3 74 20 	. t   
	ld hl,(024adh)		;7bd5	2a ad 24 	* . $ 
	ld (0151eh),hl		;7bd8	22 1e 15 	" . . 
	ld b,053h		;7bdb	06 53 	. S 
	call 01e6ch		;7bdd	cd 6c 1e 	. l . 
	jr nz,l7bf2h		;7be0	20 10 	  . 
	xor a			;7be2	af 	. 
l7be3h:
	ld de,03e66h		;7be3	11 66 3e 	. f > 
	ld (0151eh),de		;7be6	ed 53 1e 15 	. S . . 
	ld (0152eh),a		;7bea	32 2e 15 	2 . . 
	call 01e6fh		;7bed	cd 6f 1e 	. o . 
	jr l7bfdh		;7bf0	18 0b 	. . 
l7bf2h:
	ld b,042h		;7bf2	06 42 	. B 
	call 01e73h		;7bf4	cd 73 1e 	. s . 
	jr nz,l7bfdh		;7bf7	20 04 	  . 
	ld a,001h		;7bf9	3e 01 	> . 
	jr l7be3h		;7bfb	18 e6 	. . 
l7bfdh:
	ld b,03ah		;7bfd	06 3a 	. : 
	call 01e73h		;7bff	cd 73 1e 	. s . 
	ld de,015ceh		;7c02	11 ce 15 	. . . 
	call z,01544h		;7c05	cc 44 15 	. D . 
	call 02c32h		;7c08	cd 32 2c 	. 2 , 
	ld hl,015ach		;7c0b	21 ac 15 	! . . 
l7c0eh:
	ld (0153bh),hl		;7c0e	22 3b 15 	" ; . 
l7c11h:
	ld hl,03e68h		;7c11	21 68 3e 	! h > 
	call 02488h		;7c14	cd 88 24 	. . $ 
	ld (0151eh),hl		;7c17	22 1e 15 	" . . 
	call 02c6fh		;7c1a	cd 6f 2c 	. o , 
	ret nc			;7c1d	d0 	. 
	push hl			;7c1e	e5 	. 
	pop ix		;7c1f	dd e1 	. . 
	ld a,000h		;7c21	3e 00 	> . 
	or a			;7c23	b7 	. 
	jr z,l7c2bh		;7c24	28 05 	( . 
	call 02335h		;7c26	cd 35 23 	. 5 # 
	jr c,l7c36h		;7c29	38 0b 	8 . 
l7c2bh:
	call 02375h		;7c2b	cd 75 23 	. u # 
	call 015ach		;7c2e	cd ac 15 	. . . 
	ld hl,(0151eh)		;7c31	2a 1e 15 	* . . 
	jr c,l7c9ch		;7c34	38 66 	8 f 
l7c36h:
	jr l7c11h		;7c36	18 d9 	. . 
	ld b,000h		;7c38	06 00 	. . 
	push de			;7c3a	d5 	. 
l7c3bh:
	call 027eeh		;7c3b	cd ee 27 	. . ' 
	inc hl			;7c3e	23 	# 
	or a			;7c3f	b7 	. 
	jr z,l7c49h		;7c40	28 07 	( . 
	or 020h		;7c42	f6 20 	.   
	ld (de),a			;7c44	12 	. 
	inc de			;7c45	13 	. 
	inc b			;7c46	04 	. 
	jr l7c3bh		;7c47	18 f2 	. . 
l7c49h:
	pop hl			;7c49	e1 	. 
	dec hl			;7c4a	2b 	+ 
	ld (hl),b			;7c4b	70 	p 
	ret			;7c4c	c9 	. 
	call 01e6ah		;7c4d	cd 6a 1e 	. j . 
	ld a,000h		;7c50	3e 00 	> . 
	jr nz,l7c55h		;7c52	20 01 	  . 
	inc a			;7c54	3c 	< 
l7c55h:
	ld (0152eh),a		;7c55	32 2e 15 	2 . . 
	ld hl,03e66h		;7c58	21 66 3e 	! f > 
	ld (0151eh),hl		;7c5b	22 1e 15 	" . . 
	ld hl,0156fh		;7c5e	21 6f 15 	! o . 
	jr l7c0eh		;7c61	18 ab 	. . 
	call 01dfch		;7c63	cd fc 1d 	. . . 
	ld a,003h		;7c66	3e 03 	> . 
	call 01601h		;7c68	cd 01 16 	. . . 
	ei			;7c6b	fb 	. 
	ld hl,00010h		;7c6c	21 10 00 	! . . 
	call 024e3h		;7c6f	cd e3 24 	. . $ 
	ld a,00dh		;7c72	3e 0d 	> . 
	rst 10h			;7c74	d7 	. 
	xor a			;7c75	af 	. 
	ret			;7c76	c9 	. 
	call 02327h		;7c77	cd 27 23 	. ' # 
	ld bc,00001h		;7c7a	01 01 00 	. . . 
l7c7dh:
	push hl			;7c7d	e5 	. 
	and a			;7c7e	a7 	. 
	sbc hl,de		;7c7f	ed 52 	. R 
	pop hl			;7c81	e1 	. 
	jr nc,l7c8ah		;7c82	30 06 	0 . 
	inc bc			;7c84	03 	. 
	call 02488h		;7c85	cd 88 24 	. . $ 
	jr l7c7dh		;7c88	18 f3 	. . 
l7c8ah:
	call 02327h		;7c8a	cd 27 23 	. ' # 
	call 0145ah		;7c8d	cd 5a 14 	. Z . 
	call 02c6fh		;7c90	cd 6f 2c 	. o , 
	call z,02475h		;7c93	cc 75 24 	. u $ 
	ld (02328h),hl		;7c96	22 28 23 	" ( # 
	ld (0232bh),hl		;7c99	22 2b 23 	" + # 
l7c9ch:
	ld (024adh),hl		;7c9c	22 ad 24 	" . $ 
	ret			;7c9f	c9 	. 
	ld de,02ce5h		;7ca0	11 e5 2c 	. . , 
l7ca3h:
	push de			;7ca3	d5 	. 
	call 015b9h		;7ca4	cd b9 15 	. . . 
	pop de			;7ca7	d1 	. 
	ret c			;7ca8	d8 	. 
	inc de			;7ca9	13 	. 
	jr nz,l7ca3h		;7caa	20 f7 	  . 
	ret			;7cac	c9 	. 
	ld hl,015cdh		;7cad	21 cd 15 	! . . 
	ld b,(hl)			;7cb0	46 	F 
l7cb1h:
	inc hl			;7cb1	23 	# 
l7cb2h:
	ld a,(de)			;7cb2	1a 	. 
	inc de			;7cb3	13 	. 
	dec a			;7cb4	3d 	= 
	jr z,l7cb2h		;7cb5	28 fb 	( . 
	inc a			;7cb7	3c 	< 
	ret z			;7cb8	c8 	. 
	xor (hl)			;7cb9	ae 	. 
	and 0dfh		;7cba	e6 df 	. . 
	ret nz			;7cbc	c0 	. 
	djnz l7cb1h		;7cbd	10 f2 	. . 
	scf			;7cbf	37 	7 
	ret			;7cc0	c9 	. 
	nop			;7cc1	00 	. 
	add a,d			;7cc2	82 	. 
	ld l,c			;7cc3	69 	i 
	jp nz,00009h		;7cc4	c2 09 00 	. . . 
	ex de,hl			;7cc7	eb 	. 
	ex af,af'			;7cc8	08 	. 
	add a,d			;7cc9	82 	. 
	ld l,c			;7cca	69 	i 
	jp nz,00318h		;7ccb	c2 18 03 	. . . 
	nop			;7cce	00 	. 
	ld a,b			;7ccf	78 	x 
	ld l,a			;7cd0	6f 	o 
	ld (hl),e			;7cd1	73 	s 
	ld h,l			;7cd2	65 	e 
	ld h,(hl)			;7cd3	66 	f 
	ld (hl),e			;7cd4	73 	s 
	jr nc,$-59		;7cd5	30 c3 	0 . 
	push de			;7cd7	d5 	. 
	ex af,af'			;7cd8	08 	. 
	add a,d			;7cd9	82 	. 
	ld l,d			;7cda	6a 	j 
	jp nz,00000h		;7cdb	c2 00 00 	. . . 
	nop			;7cde	00 	. 
	ld (bc),a			;7cdf	02 	. 
	add a,b			;7ce0	80 	. 
	ret c			;7ce1	d8 	. 
	jp nz,000c5h		;7ce2	c2 c5 00 	. . . 
	push bc			;7ce5	c5 	. 
	nop			;7ce6	00 	. 
	ex de,hl			;7ce7	eb 	. 
	nop			;7ce8	00 	. 
	ld hl,(0cd02h)		;7ce9	2a 02 cd 	* . . 
	ld hl,0c373h		;7cec	21 73 c3 	! s . 
	xor (hl)			;7cef	ae 	. 
	ld l,c			;7cf0	69 	i 
	ld (060a8h),a		;7cf1	32 a8 60 	2 . ` 
	ld a,010h		;7cf4	3e 10 	> . 
	ld (01612h),a		;7cf6	32 12 16 	2 . . 
	ld a,010h		;7cf9	3e 10 	> . 
	push af			;7cfb	f5 	. 
	ex af,af'			;7cfc	08 	. 
	ld a,b			;7cfd	78 	x 
	or c			;7cfe	b1 	. 
	jp z,01f06h		;7cff	ca 06 1f 	. . . 
	ex af,af'			;7d02	08 	. 
	push bc			;7d03	c5 	. 
	push hl			;7d04	e5 	. 
	ld c,000h		;7d05	0e 00 	. . 
	call 022b0h		;7d07	cd b0 22 	. . " 
	ld (029c8h),hl		;7d0a	22 c8 29 	" . ) 
	pop hl			;7d0d	e1 	. 
	push hl			;7d0e	e5 	. 
	ld de,00000h		;7d0f	11 00 00 	. . . 
	and a			;7d12	a7 	. 
	sbc hl,de		;7d13	ed 52 	. R 
	ex de,hl			;7d15	eb 	. 
	ld hl,(02a17h)		;7d16	2a 17 2a 	* . * 
	ld c,(hl)			;7d19	4e 	N 
	inc hl			;7d1a	23 	# 
	ld b,(hl)			;7d1b	46 	F 
l7d1ch:
	inc hl			;7d1c	23 	# 
	ld a,(hl)			;7d1d	7e 	~ 
	inc hl			;7d1e	23 	# 
	push hl			;7d1f	e5 	. 
	ld h,(hl)			;7d20	66 	f 
	ld l,a			;7d21	6f 	o 
	ld a,h			;7d22	7c 	| 
	and 03fh		;7d23	e6 3f 	. ? 
	ld h,a			;7d25	67 	g 
	sbc hl,de		;7d26	ed 52 	. R 
	pop hl			;7d28	e1 	. 
	jr z,l7d35h		;7d29	28 0a 	( . 
	dec bc			;7d2b	0b 	. 
	ld a,b			;7d2c	78 	x 
	or c			;7d2d	b1 	. 
	jr nz,l7d1ch		;7d2e	20 ec 	  . 
	ld a,010h		;7d30	3e 10 	> . 
	jp 022dah		;7d32	c3 da 22 	. . " 
l7d35h:
	ld c,(hl)			;7d35	4e 	N 
	pop hl			;7d36	e1 	. 
	ld e,(hl)			;7d37	5e 	^ 
	inc hl			;7d38	23 	# 
	ld d,(hl)			;7d39	56 	V 
	inc hl			;7d3a	23 	# 
	push de			;7d3b	d5 	. 
	ex de,hl			;7d3c	eb 	. 
	ld hl,02ce5h		;7d3d	21 e5 2c 	! . , 
	ld (hl),020h		;7d40	36 20 	6   
	bit 7,c		;7d42	cb 79 	. y 
	jr z,l7d48h		;7d44	28 02 	( . 
	ld (hl),02ah		;7d46	36 2a 	6 * 
l7d48h:
	inc hl			;7d48	23 	# 
	push bc			;7d49	c5 	. 
	ld b,009h		;7d4a	06 09 	. . 
	call 02514h		;7d4c	cd 14 25 	. . % 
	pop bc			;7d4f	c1 	. 
	ex de,hl			;7d50	eb 	. 
	ex (sp),hl			;7d51	e3 	. 
	ex de,hl			;7d52	eb 	. 
	ld a,c			;7d53	79 	y 
	and 0c0h		;7d54	e6 c0 	. . 
	jr nz,l7d61h		;7d56	20 09 	  . 
	ld bc,0052eh		;7d58	01 2e 05 	. . . 
	call 02521h		;7d5b	cd 21 25 	. ! % 
	ld (hl),b			;7d5e	70 	p 
	jr l7d6ah		;7d5f	18 09 	. . 
l7d61h:
	push hl			;7d61	e5 	. 
	pop ix		;7d62	dd e1 	. . 
	ex de,hl			;7d64	eb 	. 
	ld c,000h		;7d65	0e 00 	. . 
	call 02b48h		;7d67	cd 48 2b 	. H + 
l7d6ah:
	ld hl,02ce5h		;7d6a	21 e5 2c 	! . , 
	call 02c5bh		;7d6d	cd 5b 2c 	. [ , 
	ld a,000h		;7d70	3e 00 	> . 
	or a			;7d72	b7 	. 
	call nz,0156fh		;7d73	c4 6f 15 	. o . 
	pop hl			;7d76	e1 	. 
	pop bc			;7d77	c1 	. 
	dec bc			;7d78	0b 	. 
	pop af			;7d79	f1 	. 
	add a,008h		;7d7a	c6 08 	. . 
	cp 0a9h		;7d7c	fe a9 	. . 
	jp c,01607h		;7d7e	da 07 16 	. . . 
	ret			;7d81	c9 	. 
l7d82h:
	ld b,050h		;7d82	06 50 	. P 
	call 01e73h		;7d84	cd 73 1e 	. s . 
	ld a,001h		;7d87	3e 01 	> . 
	jr z,l7d8ch		;7d89	28 01 	( . 
	dec a			;7d8b	3d 	= 
l7d8ch:
	ld (0167dh),a		;7d8c	32 7d 16 	2 } . 
	ld a,00eh		;7d8f	3e 0e 	> . 
	call 02c34h		;7d91	cd 34 2c 	. 4 , 
	ld hl,05840h		;7d94	21 40 58 	! @ X 
	ld a,038h		;7d97	3e 38 	> 8 
	ex af,af'			;7d99	08 	. 
	ld a,030h		;7d9a	3e 30 	> 0 
	ld c,014h		;7d9c	0e 14 	. . 
l7d9eh:
	ld b,020h		;7d9e	06 20 	.   
l7da0h:
	ld (hl),a			;7da0	77 	w 
	inc hl			;7da1	23 	# 
	djnz l7da0h		;7da2	10 fc 	. . 
	ex af,af'			;7da4	08 	. 
	dec c			;7da5	0d 	. 
	jr nz,l7d9eh		;7da6	20 f6 	  . 
	ld hl,(02a17h)		;7da8	2a 17 2a 	* . * 
	ld c,(hl)			;7dab	4e 	N 
	inc hl			;7dac	23 	# 
	ld b,(hl)			;7dad	46 	F 
	inc hl			;7dae	23 	# 
	add hl,bc			;7daf	09 	. 
	add hl,bc			;7db0	09 	. 
	ld (0161ch),hl		;7db1	22 1c 16 	" . . 
l7db4h:
	ld a,b			;7db4	78 	x 
	or c			;7db5	b1 	. 
	jr z,l7dd6h		;7db6	28 1e 	( . 
	exx			;7db8	d9 	. 
	ld a,010h		;7db9	3e 10 	> . 
l7dbbh:
	push af			;7dbb	f5 	. 
	call 02830h		;7dbc	cd 30 28 	. 0 ( 
	pop af			;7dbf	f1 	. 
	add a,008h		;7dc0	c6 08 	. . 
	cp 0a9h		;7dc2	fe a9 	. . 
	jr c,l7dbbh		;7dc4	38 f5 	8 . 
	exx			;7dc6	d9 	. 
	xor a			;7dc7	af 	. 
	call 01602h		;7dc8	cd 02 16 	. . . 
	ld a,088h		;7dcb	3e 88 	> . 
	call 01602h		;7dcd	cd 02 16 	. . . 
	exx			;7dd0	d9 	. 
	call 02879h		;7dd1	cd 79 28 	. y ( 
	cp 020h		;7dd4	fe 20 	.   
l7dd6h:
	jp z,01f09h		;7dd6	ca 09 1f 	. . . 
	exx			;7dd9	d9 	. 
	jr l7db4h		;7dda	18 d8 	. . 
	ld b,043h		;7ddc	06 43 	. C 
	call 01e6ch		;7dde	cd 6c 1e 	. l . 
	jr z,l7e1fh		;7de1	28 3c 	( < 
	ld b,04ch		;7de3	06 4c 	. L 
	call 01e73h		;7de5	cd 73 1e 	. s . 
	ld c,0feh		;7de8	0e fe 	. . 
	jr z,l7df5h		;7dea	28 09 	( . 
	ld b,055h		;7dec	06 55 	. U 
	call 01e73h		;7dee	cd 73 1e 	. s . 
	jr nz,l7d82h		;7df1	20 8f 	  . 
	ld c,0beh		;7df3	0e be 	. . 
l7df5h:
	ld a,c			;7df5	79 	y 
	ld (01711h),a		;7df6	32 11 17 	2 . . 
	ld hl,(02a17h)		;7df9	2a 17 2a 	* . * 
	ld c,(hl)			;7dfc	4e 	N 
	inc hl			;7dfd	23 	# 
	ld b,(hl)			;7dfe	46 	F 
	inc hl			;7dff	23 	# 
l7e00h:
	ld a,b			;7e00	78 	x 
	or c			;7e01	b1 	. 
	ret z			;7e02	c8 	. 
	inc hl			;7e03	23 	# 
	set 7,(hl)		;7e04	cb fe 	. . 
	inc hl			;7e06	23 	# 
	dec bc			;7e07	0b 	. 
	jr l7e00h		;7e08	18 f6 	. . 
	ld b,079h		;7e0a	06 79 	. y 
	call 01e6ch		;7e0c	cd 6c 1e 	. l . 
	ret nz			;7e0f	c0 	. 
	ld hl,03e68h		;7e10	21 68 3e 	! h > 
	ld (02328h),hl		;7e13	22 28 23 	" ( # 
	call 013ceh		;7e16	cd ce 13 	. . . 
	ld (0232bh),hl		;7e19	22 2b 23 	" + # 
	call 01583h		;7e1c	cd 83 15 	. . . 
l7e1fh:
	call 02c32h		;7e1f	cd 32 2c 	. 2 , 
	ld c,0b6h		;7e22	0e b6 	. . 
	call 01701h		;7e24	cd 01 17 	. . . 
	ld hl,03e68h		;7e27	21 68 3e 	! h > 
	call 01829h		;7e2a	cd 29 18 	. ) . 
l7e2dh:
	jr nc,l7e44h		;7e2d	30 15 	0 . 
	push hl			;7e2f	e5 	. 
	ld l,(hl)			;7e30	6e 	n 
	and 07fh		;7e31	e6 7f 	.  
	ld h,a			;7e33	67 	g 
	add hl,hl			;7e34	29 	) 
	ld de,(02a17h)		;7e35	ed 5b 17 2a 	. [ . * 
	add hl,de			;7e39	19 	. 
	inc hl			;7e3a	23 	# 
	set 6,(hl)		;7e3b	cb f6 	. . 
	pop hl			;7e3d	e1 	. 
	inc hl			;7e3e	23 	# 
	call 01838h		;7e3f	cd 38 18 	. 8 . 
	jr l7e2dh		;7e42	18 e9 	. . 
l7e44h:
	ld hl,(02a17h)		;7e44	2a 17 2a 	* . * 
	ld c,(hl)			;7e47	4e 	N 
	inc hl			;7e48	23 	# 
	ld b,(hl)			;7e49	46 	F 
	inc hl			;7e4a	23 	# 
	push hl			;7e4b	e5 	. 
	add hl,bc			;7e4c	09 	. 
	add hl,bc			;7e4d	09 	. 
	ld (0177ah),hl		;7e4e	22 7a 17 	" z . 
	pop hl			;7e51	e1 	. 
l7e52h:
	ld a,b			;7e52	78 	x 
	or c			;7e53	b1 	. 
	jr nz,l7e5bh		;7e54	20 05 	  . 
	ld c,0b6h		;7e56	0e b6 	. . 
	jp 01701h		;7e58	c3 01 17 	. . . 
l7e5bh:
	dec bc			;7e5b	0b 	. 
	ld (01815h),hl		;7e5c	22 15 18 	" . . 
	ld e,(hl)			;7e5f	5e 	^ 
	inc hl			;7e60	23 	# 
	ld a,(hl)			;7e61	7e 	~ 
	and 0c0h		;7e62	e6 c0 	. . 
	ld a,(hl)			;7e64	7e 	~ 
	inc hl			;7e65	23 	# 
	jr nz,l7e52h		;7e66	20 ea 	  . 
	and 03fh		;7e68	e6 3f 	. ? 
	ld d,a			;7e6a	57 	W 
	push bc			;7e6b	c5 	. 
	push hl			;7e6c	e5 	. 
	ld hl,00000h		;7e6d	21 00 00 	! . . 
	add hl,de			;7e70	19 	. 
	ld (017d0h),de		;7e71	ed 53 d0 17 	. S . . 
	ld d,h			;7e75	54 	T 
	ld e,l			;7e76	5d 	] 
	inc de			;7e77	13 	. 
	inc de			;7e78	13 	. 
l7e79h:
	ld a,(de)			;7e79	1a 	. 
	inc de			;7e7a	13 	. 
	rlca			;7e7b	07 	. 
	jr nc,l7e79h		;7e7c	30 fb 	0 . 
	call 02b21h		;7e7e	cd 21 2b 	. ! + 
	and a			;7e81	a7 	. 
	sbc hl,de		;7e82	ed 52 	. R 
	ld b,h			;7e84	44 	D 
	ld c,l			;7e85	4d 	M 
	ld hl,02a5ah		;7e86	21 5a 2a 	! Z * 
	call 02c11h		;7e89	cd 11 2c 	. . , 
	pop hl			;7e8c	e1 	. 
	push bc			;7e8d	c5 	. 
	ld d,h			;7e8e	54 	T 
	ld e,l			;7e8f	5d 	] 
	dec hl			;7e90	2b 	+ 
	dec hl			;7e91	2b 	+ 
	call 02b21h		;7e92	cd 21 2b 	. ! + 
	ld bc,00002h		;7e95	01 02 00 	. . . 
	ld hl,0177ah		;7e98	21 7a 17 	! z . 
	call 02c11h		;7e9b	cd 11 2c 	. . , 
	ld hl,02a5ah		;7e9e	21 5a 2a 	! Z * 
	call 02c11h		;7ea1	cd 11 2c 	. . , 
	pop bc			;7ea4	c1 	. 
	push bc			;7ea5	c5 	. 
	inc bc			;7ea6	03 	. 
	inc bc			;7ea7	03 	. 
l7ea8h:
	xor a			;7ea8	af 	. 
	ld (de),a			;7ea9	12 	. 
	inc de			;7eaa	13 	. 
	dec bc			;7eab	0b 	. 
	ld a,b			;7eac	78 	x 
	or c			;7ead	b1 	. 
	jr nz,l7ea8h		;7eae	20 f8 	  . 
	ld hl,(02a17h)		;7eb0	2a 17 2a 	* . * 
	push hl			;7eb3	e5 	. 
	inc bc			;7eb4	03 	. 
	call 02c11h		;7eb5	cd 11 2c 	. . , 
	pop ix		;7eb8	dd e1 	. . 
	pop bc			;7eba	c1 	. 
l7ebbh:
	ld a,d			;7ebb	7a 	z 
	or e			;7ebc	b3 	. 
	jr z,l7ed5h		;7ebd	28 16 	( . 
	push de			;7ebf	d5 	. 
	call 0181bh		;7ec0	cd 1b 18 	. . . 
	ld de,00000h		;7ec3	11 00 00 	. . . 
	and a			;7ec6	a7 	. 
	sbc hl,de		;7ec7	ed 52 	. R 
	jr c,l7ed1h		;7ec9	38 06 	8 . 
	push ix		;7ecb	dd e5 	. . 
	pop hl			;7ecd	e1 	. 
	call 02c11h		;7ece	cd 11 2c 	. . , 
l7ed1h:
	pop de			;7ed1	d1 	. 
	dec de			;7ed2	1b 	. 
	jr l7ebbh		;7ed3	18 e6 	. . 
l7ed5h:
	ld hl,(01815h)		;7ed5	2a 15 18 	* . . 
	ld de,(02a17h)		;7ed8	ed 5b 17 2a 	. [ . * 
	sbc hl,de		;7edc	ed 52 	. R 
	ex de,hl			;7ede	eb 	. 
	srl d		;7edf	cb 3a 	. : 
	rr e		;7ee1	cb 1b 	. . 
	ld hl,03e68h		;7ee3	21 68 3e 	! h > 
	call 01829h		;7ee6	cd 29 18 	. ) . 
l7ee9h:
	jr nc,l7f08h		;7ee9	30 1d 	0 . 
	push hl			;7eeb	e5 	. 
	ld l,(hl)			;7eec	6e 	n 
	ld h,a			;7eed	67 	g 
	push hl			;7eee	e5 	. 
	res 7,h		;7eef	cb bc 	. . 
	or a			;7ef1	b7 	. 
	sbc hl,de		;7ef2	ed 52 	. R 
	pop hl			;7ef4	e1 	. 
	jr nc,l7efeh		;7ef5	30 07 	0 . 
	pop hl			;7ef7	e1 	. 
l7ef8h:
	inc hl			;7ef8	23 	# 
	call 01838h		;7ef9	cd 38 18 	. 8 . 
	jr l7ee9h		;7efc	18 eb 	. . 
l7efeh:
	dec hl			;7efe	2b 	+ 
	ld b,h			;7eff	44 	D 
	ld c,l			;7f00	4d 	M 
	pop hl			;7f01	e1 	. 
	ld (hl),c			;7f02	71 	q 
	dec hl			;7f03	2b 	+ 
	ld (hl),b			;7f04	70 	p 
	inc hl			;7f05	23 	# 
	jr l7ef8h		;7f06	18 f0 	. . 
l7f08h:
	ld hl,00000h		;7f08	21 00 00 	! . . 
	pop bc			;7f0b	c1 	. 
	jp 0175eh		;7f0c	c3 5e 17 	. ^ . 
	inc ix		;7f0f	dd 23 	. # 
	ld l,(ix+001h)		;7f11	dd 6e 01 	. n . 
	inc ix		;7f14	dd 23 	. # 
	ld a,(ix+001h)		;7f16	dd 7e 01 	. ~ . 
	and 03fh		;7f19	e6 3f 	. ? 
	ld h,a			;7f1b	67 	g 
	ret			;7f1c	c9 	. 
l7f1dh:
	call 02c6fh		;7f1d	cd 6f 2c 	. o , 
	ret nc			;7f20	d0 	. 
	inc hl			;7f21	23 	# 
	ld a,(hl)			;7f22	7e 	~ 
	and 00fh		;7f23	e6 0f 	. . 
	inc hl			;7f25	23 	# 
	jr z,l7f1dh		;7f26	28 f5 	( . 
	and 008h		;7f28	e6 08 	. . 
	jr nz,l7f37h		;7f2a	20 0b 	  . 
l7f2ch:
	ld a,(hl)			;7f2c	7e 	~ 
	inc hl			;7f2d	23 	# 
	cp 0c0h		;7f2e	fe c0 	. . 
	jr nc,l7f1dh		;7f30	30 eb 	0 . 
	cp 080h		;7f32	fe 80 	. . 
	jr c,l7f2ch		;7f34	38 f6 	8 . 
	dec hl			;7f36	2b 	+ 
l7f37h:
	ld a,(hl)			;7f37	7e 	~ 
	inc hl			;7f38	23 	# 
	scf			;7f39	37 	7 
	ret			;7f3a	c9 	. 
	ld ix,050e0h		;7f3b	dd 21 e0 50 	. ! . P 
	ld (ix+000h),003h		;7f3f	dd 36 00 03 	. 6 . . 
	call 01e6ah		;7f43	cd 6a 1e 	. j . 
	push af			;7f46	f5 	. 
	ld b,03ah		;7f47	06 3a 	. : 
	cp b			;7f49	b8 	. 
	jr z,l7f4fh		;7f4a	28 03 	( . 
	call 01e6fh		;7f4c	cd 6f 1e 	. o . 
l7f4fh:
	jr nz,l7f54h		;7f4f	20 03 	  . 
	call 018fch		;7f51	cd fc 18 	. . . 
l7f54h:
	ld hl,01915h		;7f54	21 15 19 	! . . 
	ld de,050e1h		;7f57	11 e1 50 	. . P 
	ld bc,0000ah		;7f5a	01 0a 00 	. . . 
	ldir		;7f5d	ed b0 	. . 
	pop af			;7f5f	f1 	. 
	jr z,l7f6eh		;7f60	28 0c 	( . 
	ld hl,(02a17h)		;7f62	2a 17 2a 	* . * 
	ld de,0fff4h		;7f65	11 f4 ff 	. . . 
	add hl,de			;7f68	19 	. 
	ld de,03e68h		;7f69	11 68 3e 	. h > 
	jr l7f75h		;7f6c	18 07 	. . 
l7f6eh:
	call 02327h		;7f6e	cd 27 23 	. ' # 
	ex de,hl			;7f71	eb 	. 
	call 02488h		;7f72	cd 88 24 	. . $ 
l7f75h:
	push de			;7f75	d5 	. 
	ld (0192bh),de		;7f76	ed 53 2b 19 	. S + . 
	or a			;7f7a	b7 	. 
	sbc hl,de		;7f7b	ed 52 	. R 
	push hl			;7f7d	e5 	. 
	ld (0192eh),hl		;7f7e	22 2e 19 	" . . 
	ld (050efh),hl		;7f81	22 ef 50 	" . P 
	ld hl,(02a5ah)		;7f84	2a 5a 2a 	* Z * 
	ld de,(02a17h)		;7f87	ed 5b 17 2a 	. [ . * 
	and a			;7f8b	a7 	. 
	sbc hl,de		;7f8c	ed 52 	. R 
	ld (018c1h),de		;7f8e	ed 53 c1 18 	. S . . 
	inc hl			;7f92	23 	# 
	ld (018c6h),hl		;7f93	22 c6 18 	" . . 
	dec hl			;7f96	2b 	+ 
	pop de			;7f97	d1 	. 
	push de			;7f98	d5 	. 
	add hl,de			;7f99	19 	. 
	inc hl			;7f9a	23 	# 
	inc hl			;7f9b	23 	# 
	ld (050ebh),hl		;7f9c	22 eb 50 	" . P 
	ld a,00ch		;7f9f	3e 0c 	> . 
	push ix		;7fa1	dd e5 	. . 
	call 02c34h		;7fa3	cd 34 2c 	. 4 , 
	pop ix		;7fa6	dd e1 	. . 
	call 018dah		;7fa8	cd da 18 	. . . 
	pop de			;7fab	d1 	. 
	pop ix		;7fac	dd e1 	. . 
	ld a,0ffh		;7fae	3e ff 	> . 
	call 004c6h		;7fb0	cd c6 04 	. . . 
	ld ix,00000h		;7fb3	dd 21 00 00 	. ! . . 
	dec ix		;7fb7	dd 2b 	. + 
	ld de,00000h		;7fb9	11 00 00 	. . . 
	ld l,0ffh		;7fbc	2e ff 	. . 
	ld a,h			;7fbe	7c 	| 
	xor l			;7fbf	ad 	. 
	ld h,a			;7fc0	67 	g 
	ld a,001h		;7fc1	3e 01 	> . 
	scf			;7fc3	37 	7 
	rl l		;7fc4	cb 15 	. . 
	ld b,037h		;7fc6	06 37 	. 7 
	call 0051ah		;7fc8	cd 1a 05 	. . . 
	jp 01dfch		;7fcb	c3 fc 1d 	. . . 
	ld h,001h		;7fce	26 01 	& . 
l7fd0h:
	inc hl			;7fd0	23 	# 
	inc h			;7fd1	24 	$ 
	dec h			;7fd2	25 	% 
	jr nz,l7fd0h		;7fd3	20 fb 	  . 
l7fd5h:
	xor a			;7fd5	af 	. 
	in a,(0feh)		;7fd6	db fe 	. . 
	cpl			;7fd8	2f 	/ 
	and 01fh		;7fd9	e6 1f 	. . 
	jr z,l7fd5h		;7fdb	28 f8 	( . 
	ld de,00011h		;7fdd	11 11 00 	. . . 
	xor a			;7fe0	af 	. 
	call 004c6h		;7fe1	cd c6 04 	. . . 
l7fe4h:
	dec de			;7fe4	1b 	. 
	dec d			;7fe5	15 	. 
	inc d			;7fe6	14 	. 
	jr nz,l7fe4h		;7fe7	20 fb 	  . 
	ret			;7fe9	c9 	. 
	ld b,03ah		;7fea	06 3a 	. : 
	call 01e6ch		;7fec	cd 6c 1e 	. l . 
	ret nz			;7fef	c0 	. 
	ld de,01915h		;7ff0	11 15 19 	. . . 
	ld b,00ah		;7ff3	06 0a 	. . 
l7ff5h:
	call 027eeh		;7ff5	cd ee 27 	. . ' 
	inc hl			;7ff8	23 	# 
	or a			;7ff9	b7 	. 
	jr z,l8002h		;7ffa	28 06 	( . 
	ld (de),a			;7ffc	12 	. 
	inc de			;7ffd	13 	. 
	dec b			;7ffe	05 	. 
	jr nz,l7ff5h		;7fff	20 f4 	  . 
	ret			;8001	c9 	. 
l8002h:
	ld a,020h		;8002	3e 20 	>   
l8004h:
	ld (de),a			;8004	12 	. 
	inc de			;8005	13 	. 
	djnz l8004h		;8006	10 fc 	. . 
	ret			;8008	c9 	. 
	ld (hl),b			;8009	70 	p 
	ld (hl),d			;800a	72 	r 
	ld l,a			;800b	6f 	o 
	ld l,l			;800c	6d 	m 
	ld h,l			;800d	65 	e 
	ld (hl),h			;800e	74 	t 
	ld l,b			;800f	68 	h 
	ld h,l			;8010	65 	e 
	ld (hl),l			;8011	75 	u 
	ld (hl),e			;8012	73 	s 
l8013h:
	call 01e1ch		;8013	cd 1c 1e 	. . . 
	call 01e5ah		;8016	cd 5a 1e 	. Z . 
	jr nz,l8013h		;8019	20 f8 	  . 
	xor a			;801b	af 	. 
	dec a			;801c	3d 	= 
	ld ix,00000h		;801d	dd 21 00 00 	. ! . . 
	ld de,00000h		;8021	11 00 00 	. . . 
	call 0194ah		;8024	cd 4a 19 	. J . 
	ld ix,(018c1h)		;8027	dd 2a c1 18 	. * . . 
	ld de,(018c6h)		;802b	ed 5b c6 18 	. [ . . 
	dec de			;802f	1b 	. 
	ld b,0b0h		;8030	06 b0 	. . 
	ex af,af'			;8032	08 	. 
	xor a			;8033	af 	. 
	dec a			;8034	3d 	= 
	ex af,af'			;8035	08 	. 
	call 005c8h		;8036	cd c8 05 	. . . 
	call 01dfch		;8039	cd fc 1d 	. . . 
	jr l8041h		;803c	18 03 	. . 
	call 01df1h		;803e	cd f1 1d 	. . . 
l8041h:
	ret c			;8041	d8 	. 
	ld a,00dh		;8042	3e 0d 	> . 
l8044h:
	call 02c34h		;8044	cd 34 2c 	. 4 , 
	jp 022e2h		;8047	c3 e2 22 	. . " 
	call 02c28h		;804a	cd 28 2c 	. ( , 
	ld hl,019a0h		;804d	21 a0 19 	! . . 
	ld (02079h),hl		;8050	22 79 20 	" y   
l8053h:
	ld hl,00000h		;8053	21 00 00 	! . . 
	push hl			;8056	e5 	. 
	push hl			;8057	e5 	. 
	pop ix		;8058	dd e1 	. . 
	call 02488h		;805a	cd 88 24 	. . $ 
	ld (01960h),hl		;805d	22 60 19 	" ` . 
	pop hl			;8060	e1 	. 
	ld de,00000h		;8061	11 00 00 	. . . 
	and a			;8064	a7 	. 
	sbc hl,de		;8065	ed 52 	. R 
	jr nc,l80a8h		;8067	30 3f 	0 ? 
	ld a,021h		;8069	3e 21 	> ! 
	ld hl,00000h		;806b	21 00 00 	! . . 
	call 01a0ah		;806e	cd 0a 1a 	. . . 
	call 02375h		;8071	cd 75 23 	. u # 
	ld a,02ah		;8074	3e 2a 	> * 
	ld hl,02a17h		;8076	21 17 2a 	! . * 
	call 01a0ah		;8079	cd 0a 1a 	. . . 
	ld a,(01f3fh)		;807c	3a 3f 1f 	: ? . 
	cp 010h		;807f	fe 10 	. . 
	jr z,l8044h		;8081	28 c1 	( . 
	ld hl,02ce5h		;8083	21 e5 2c 	! . , 
	ld de,02d3fh		;8086	11 3f 2d 	. ? - 
	ld bc,00020h		;8089	01 20 00 	.   . 
	ldir		;808c	ed b0 	. . 
	call 0251bh		;808e	cd 1b 25 	. . % 
	jp 0201dh		;8091	c3 1d 20 	. .   
	call 024a2h		;8094	cd a2 24 	. . $ 
	ld de,(01960h)		;8097	ed 5b 60 19 	. [ ` . 
	ld hl,(02a5ah)		;809b	2a 5a 2a 	* Z * 
	and a			;809e	a7 	. 
	sbc hl,de		;809f	ed 52 	. R 
	jr c,l8053h		;80a1	38 b0 	8 . 
	ld a,007h		;80a3	3e 07 	> . 
	jp 022dah		;80a5	c3 da 22 	. . " 
l80a8h:
	ld hl,01f0fh		;80a8	21 0f 1f 	! . . 
	ld (02079h),hl		;80ab	22 79 20 	" y   
	jp (hl)			;80ae	e9 	. 
	call 02c28h		;80af	cd 28 2c 	. ( , 
	ld hl,019f9h		;80b2	21 f9 19 	! . . 
	ld (02079h),hl		;80b5	22 79 20 	" y   
l80b8h:
	ld b,001h		;80b8	06 01 	. . 
	ld de,02d3fh		;80ba	11 3f 2d 	. ? - 
	ld hl,(01960h)		;80bd	2a 60 19 	* ` . 
	inc hl			;80c0	23 	# 
	inc hl			;80c1	23 	# 
l80c2h:
	ld a,(hl)			;80c2	7e 	~ 
	inc hl			;80c3	23 	# 
	cp 00dh		;80c4	fe 0d 	. . 
	jr z,l80d9h		;80c6	28 11 	( . 
	bit 5,b		;80c8	cb 68 	. h 
	jr nz,l80c2h		;80ca	20 f6 	  . 
	cp 020h		;80cc	fe 20 	.   
	jr nc,l80d2h		;80ce	30 02 	0 . 
	ld a,020h		;80d0	3e 20 	>   
l80d2h:
	and 07fh		;80d2	e6 7f 	.  
	ld (de),a			;80d4	12 	. 
	inc de			;80d5	13 	. 
	inc b			;80d6	04 	. 
	jr l80c2h		;80d7	18 e9 	. . 
l80d9h:
	ld (01960h),hl		;80d9	22 60 19 	" ` . 
	ld a,001h		;80dc	3e 01 	> . 
	ld (de),a			;80de	12 	. 
l80dfh:
	inc de			;80df	13 	. 
	xor a			;80e0	af 	. 
	ld (de),a			;80e1	12 	. 
	inc b			;80e2	04 	. 
	bit 5,b		;80e3	cb 68 	. h 
	jr z,l80dfh		;80e5	28 f8 	( . 
	call 0251bh		;80e7	cd 1b 25 	. . % 
	jp 0201dh		;80ea	c3 1d 20 	. .   
	call 024a2h		;80ed	cd a2 24 	. . $ 
	ld hl,(01960h)		;80f0	2a 60 19 	* ` . 
	ld de,(01b86h)		;80f3	ed 5b 86 1b 	. [ . . 
	and a			;80f7	a7 	. 
	sbc hl,de		;80f8	ed 52 	. R 
	jr c,l80b8h		;80fa	38 bc 	8 . 
	jr l80a8h		;80fc	18 aa 	. . 
	ld (02356h),a		;80fe	32 56 23 	2 V # 
	ld (02357h),hl		;8101	22 57 23 	" W # 
	ret			;8104	c9 	. 
l8105h:
	call 01e1ch		;8105	cd 1c 1e 	. . . 
	call 01e4dh		;8108	cd 4d 1e 	. M . 
	jr nz,l8105h		;810b	20 f8 	  . 
	ld hl,(050ebh)		;810d	2a eb 50 	* . P 
	ld b,h			;8110	44 	D 
	ld c,l			;8111	4d 	M 
	call 022a8h		;8112	cd a8 22 	. . " 
	ex de,hl			;8115	eb 	. 
	ld hl,(01b86h)		;8116	2a 86 1b 	* . . 
	and a			;8119	a7 	. 
	sbc hl,de		;811a	ed 52 	. R 
	push hl			;811c	e5 	. 
	ld (01960h),hl		;811d	22 60 19 	" ` . 
	ld bc,(050efh)		;8120	ed 4b ef 50 	. K . P 
	add hl,bc			;8124	09 	. 
	ld (0196eh),hl		;8125	22 6e 19 	" n . 
	inc hl			;8128	23 	# 
	inc hl			;8129	23 	# 
	ld (01978h),hl		;812a	22 78 19 	" x . 
	pop ix		;812d	dd e1 	. . 
	scf			;812f	37 	7 
	sbc a,a			;8130	9f 	. 
	call 0194ah		;8131	cd 4a 19 	. J . 
	ld a,007h		;8134	3e 07 	> . 
	out (0feh),a		;8136	d3 fe 	. . 
	ret			;8138	c9 	. 
	call 01e6ah		;8139	cd 6a 1e 	. j . 
	ld a,000h		;813c	3e 00 	> . 
	jr z,l8141h		;813e	28 01 	( . 
	inc a			;8140	3c 	< 
l8141h:
	ld (01a7fh),a		;8141	32 7f 1a 	2  . 
	ld c,0b6h		;8144	0e b6 	. . 
	call 01701h		;8146	cd 01 17 	. . . 
	ld a,001h		;8149	3e 01 	> . 
	ld (01a91h),a		;814b	32 91 1a 	2 . . 
	ld hl,01befh		;814e	21 ef 1b 	! . . 
	ld (01a89h),hl		;8151	22 89 1a 	" . . 
l8154h:
	ld hl,(02a5ah)		;8154	2a 5a 2a 	* Z * 
	inc hl			;8157	23 	# 
	ld (01b94h),hl		;8158	22 94 1b 	" . . 
	ld (01b75h),hl		;815b	22 75 1b 	" u . 
	ld hl,03e68h		;815e	21 68 3e 	! h > 
l8161h:
	call 02c6fh		;8161	cd 6f 2c 	. o , 
	jr nc,l8184h		;8164	30 1e 	0 . 
	ld (01c04h),hl		;8166	22 04 1c 	" . . 
	push hl			;8169	e5 	. 
	call 02488h		;816a	cd 88 24 	. . $ 
	ld (01a8ch),hl		;816d	22 8c 1a 	" . . 
	pop ix		;8170	dd e1 	. . 
	ld a,000h		;8172	3e 00 	> . 
	or a			;8174	b7 	. 
	jr nz,l817ch		;8175	20 05 	  . 
	call 02335h		;8177	cd 35 23 	. 5 # 
	jr c,l817fh		;817a	38 03 	8 . 
l817ch:
	call 01befh		;817c	cd ef 1b 	. . . 
l817fh:
	ld hl,00000h		;817f	21 00 00 	! . . 
	jr l8161h		;8182	18 dd 	. . 
l8184h:
	ld a,000h		;8184	3e 00 	> . 
	dec a			;8186	3d 	= 
	ld (01a91h),a		;8187	32 91 1a 	2 . . 
	ld hl,01b1ah		;818a	21 1a 1b 	! . . 
	ld (01a89h),hl		;818d	22 89 1a 	" . . 
	jr z,l8154h		;8190	28 c2 	( . 
	ret			;8192	c9 	. 
	call 01a45h		;8193	cd 45 1a 	. E . 
	ld a,00bh		;8196	3e 0b 	> . 
	jp 01f1ah		;8198	c3 1a 1f 	. . . 
l819bh:
	ld a,(ix+000h)		;819b	dd 7e 00 	. ~ . 
	call 01c42h		;819e	cd 42 1c 	. B . 
	sub 002h		;81a1	d6 02 	. . 
	ret c			;81a3	d8 	. 
	jr nz,l81b1h		;81a4	20 0b 	  . 
	call 01cd8h		;81a6	cd d8 1c 	. . . 
	ld (01f04h),hl		;81a9	22 04 1f 	" . . 
	ld hl,01ef9h		;81ac	21 f9 1e 	! . . 
	dec (hl)			;81af	35 	5 
	ret			;81b0	c9 	. 
l81b1h:
	dec a			;81b1	3d 	= 
	ret z			;81b2	c8 	. 
	dec a			;81b3	3d 	= 
	jp z,01c65h		;81b4	ca 65 1c 	. e . 
	dec a			;81b7	3d 	= 
	jr nz,l81c0h		;81b8	20 06 	  . 
	call 01cd8h		;81ba	cd d8 1c 	. . . 
	jp 01c6ch		;81bd	c3 6c 1c 	. l . 
l81c0h:
	dec a			;81c0	3d 	= 
	jr nz,l81d0h		;81c1	20 0d 	  . 
l81c3h:
	call 01cd8h		;81c3	cd d8 1c 	. . . 
	jp c,01b6ah		;81c6	da 6a 1b 	. j . 
	call 01b6ah		;81c9	cd 6a 1b 	. j . 
	inc ix		;81cc	dd 23 	. # 
	jr l81c3h		;81ce	18 f3 	. . 
l81d0h:
	dec a			;81d0	3d 	= 
	jr nz,l81fdh		;81d1	20 2a 	  * 
l81d3h:
	call 01af3h		;81d3	cd f3 1a 	. . . 
	jr nz,l81ddh		;81d6	20 05 	  . 
	call 01b71h		;81d8	cd 71 1b 	. q . 
	jr l81d3h		;81db	18 f6 	. . 
l81ddh:
	ld a,e			;81dd	7b 	{ 
	cp 027h		;81de	fe 27 	. ' 
	jr nz,l81e4h		;81e0	20 02 	  . 
	set 7,d		;81e2	cb fa 	. . 
l81e4h:
	ld a,d			;81e4	7a 	z 
	jr l8265h		;81e5	18 7e 	. ~ 
	call 0234ah		;81e7	cd 4a 23 	. J # 
	bit 7,(ix+004h)		;81ea	dd cb 04 7e 	. . . ~ 
	ret nz			;81ee	c0 	. 
	ld a,d			;81ef	7a 	z 
	cp 022h		;81f0	fe 22 	. " 
	jr nz,l81f8h		;81f2	20 04 	  . 
	cp e			;81f4	bb 	. 
	call z,0234ah		;81f5	cc 4a 23 	. J # 
l81f8h:
	bit 7,(ix+004h)		;81f8	dd cb 04 7e 	. . . ~ 
	ret			;81fc	c9 	. 
l81fdh:
	dec a			;81fd	3d 	= 
	jp z,01c8ch		;81fe	ca 8c 1c 	. . . 
l8201h:
	call 01cd8h		;8201	cd d8 1c 	. . . 
	jp c,01ba2h		;8204	da a2 1b 	. . . 
	call 01ba2h		;8207	cd a2 1b 	. . . 
	inc ix		;820a	dd 23 	. # 
	jr l8201h		;820c	18 f3 	. . 
	ld b,(ix+001h)		;820e	dd 46 01 	. F . 
	ld a,b			;8211	78 	x 
	and 030h		;8212	e6 30 	. 0 
	cp 030h		;8214	fe 30 	. 0 
	jr z,l819bh		;8216	28 83 	( . 
	ld a,b			;8218	78 	x 
	and 0b0h		;8219	e6 b0 	. . 
	cp 090h		;821b	fe 90 	. . 
	jr c,l822dh		;821d	38 0e 	8 . 
	call 01b39h		;821f	cd 39 1b 	. 9 . 
	ld hl,(01b75h)		;8222	2a 75 1b 	* u . 
	dec hl			;8225	2b 	+ 
	ld a,(hl)			;8226	7e 	~ 
	dec hl			;8227	2b 	+ 
	ld b,(hl)			;8228	46 	F 
	ld (hl),a			;8229	77 	w 
	inc hl			;822a	23 	# 
	ld (hl),b			;822b	70 	p 
	ret			;822c	c9 	. 
l822dh:
	ld a,0ddh		;822d	3e dd 	> . 
	bit 5,b		;822f	cb 68 	. h 
	call nz,01b71h		;8231	c4 71 1b 	. q . 
	ld a,0fdh		;8234	3e fd 	> . 
	bit 4,b		;8236	cb 60 	. ` 
	call nz,01b71h		;8238	c4 71 1b 	. q . 
	ld a,0cbh		;823b	3e cb 	> . 
	bit 7,b		;823d	cb 78 	. x 
	call nz,01b71h		;823f	c4 71 1b 	. q . 
	ld a,0edh		;8242	3e ed 	> . 
	bit 6,b		;8244	cb 70 	. p 
	call nz,01b71h		;8246	c4 71 1b 	. q . 
	ld a,(ix+000h)		;8249	dd 7e 00 	. ~ . 
	call 01b71h		;824c	cd 71 1b 	. q . 
	call 01c42h		;824f	cd 42 1c 	. B . 
	ld a,b			;8252	78 	x 
	and 007h		;8253	e6 07 	. . 
	ret z			;8255	c8 	. 
	dec a			;8256	3d 	= 
	push af			;8257	f5 	. 
	call 01cd8h		;8258	cd d8 1c 	. . . 
	pop af			;825b	f1 	. 
	jr nz,l8293h		;825c	20 35 	  5 
l825eh:
	ld a,b			;825e	78 	x 
	inc a			;825f	3c 	< 
	and 0feh		;8260	e6 fe 	. . 
	jr nz,l82bbh		;8262	20 57 	  W 
	ld a,c			;8264	79 	y 
l8265h:
	ld de,00000h		;8265	11 00 00 	. . . 
	ld hl,00000h		;8268	21 00 00 	! . . 
	and a			;826b	a7 	. 
	sbc hl,de		;826c	ed 52 	. R 
	add hl,de			;826e	19 	. 
	ex de,hl			;826f	eb 	. 
	jr c,l8279h		;8270	38 07 	8 . 
	ld hl,(02a5ah)		;8272	2a 5a 2a 	* Z * 
	sbc hl,de		;8275	ed 52 	. R 
	jr nc,l828fh		;8277	30 16 	0 . 
l8279h:
	ld hl,0ffffh		;8279	21 ff ff 	! . . 
	and a			;827c	a7 	. 
	sbc hl,de		;827d	ed 52 	. R 
	jr c,l828fh		;827f	38 0e 	8 . 
	ld (de),a			;8281	12 	. 
	inc de			;8282	13 	. 
	ld (01b75h),de		;8283	ed 53 75 1b 	. S u . 
	ld hl,00000h		;8287	21 00 00 	! . . 
	inc hl			;828a	23 	# 
	ld (01b94h),hl		;828b	22 94 1b 	" . . 
	ret			;828e	c9 	. 
l828fh:
	ld a,008h		;828f	3e 08 	> . 
	jr l82f7h		;8291	18 64 	. d 
l8293h:
	dec a			;8293	3d 	= 
	jr nz,l829dh		;8294	20 07 	  . 
	ld a,c			;8296	79 	y 
	call 01b71h		;8297	cd 71 1b 	. q . 
	ld a,b			;829a	78 	x 
	jr l8265h		;829b	18 c8 	. . 
l829dh:
	dec a			;829d	3d 	= 
	jr nz,l82bfh		;829e	20 1f 	  . 
	ld hl,(01b94h)		;82a0	2a 94 1b 	* . . 
	inc hl			;82a3	23 	# 
	push bc			;82a4	c5 	. 
	ex (sp),hl			;82a5	e3 	. 
	pop bc			;82a6	c1 	. 
	and a			;82a7	a7 	. 
	sbc hl,bc		;82a8	ed 42 	. B 
l82aah:
	ld a,l			;82aa	7d 	} 
	inc h			;82ab	24 	$ 
	jr z,l82b7h		;82ac	28 09 	( . 
	dec h			;82ae	25 	% 
	jr nz,l82bbh		;82af	20 0a 	  . 
	cp 080h		;82b1	fe 80 	. . 
	jr nc,l82bbh		;82b3	30 06 	0 . 
l82b5h:
	jr l8265h		;82b5	18 ae 	. . 
l82b7h:
	cp 080h		;82b7	fe 80 	. . 
	jr nc,l82b5h		;82b9	30 fa 	0 . 
l82bbh:
	ld a,003h		;82bb	3e 03 	> . 
	jr l82f7h		;82bd	18 38 	. 8 
l82bfh:
	dec a			;82bf	3d 	= 
	jr nz,l82c6h		;82c0	20 04 	  . 
	ld h,b			;82c2	60 	` 
	ld l,c			;82c3	69 	i 
	jr l82aah		;82c4	18 e4 	. . 
l82c6h:
	dec a			;82c6	3d 	= 
	jr nz,l82d3h		;82c7	20 0a 	  . 
	call 01bceh		;82c9	cd ce 1b 	. . . 
	inc ix		;82cc	dd 23 	. # 
	call 01cd8h		;82ce	cd d8 1c 	. . . 
	jr l825eh		;82d1	18 8b 	. . 
l82d3h:
	ld a,c			;82d3	79 	y 
	and 0c7h		;82d4	e6 c7 	. . 
	or b			;82d6	b0 	. 
	ld a,006h		;82d7	3e 06 	> . 
	jr nz,l82f7h		;82d9	20 1c 	  . 
	ld a,c			;82db	79 	y 
	ld hl,(01b75h)		;82dc	2a 75 1b 	* u . 
	dec hl			;82df	2b 	+ 
	add a,(hl)			;82e0	86 	. 
	ld (hl),a			;82e1	77 	w 
	ret			;82e2	c9 	. 
	bit 3,(ix+001h)		;82e3	dd cb 01 5e 	. . . ^ 
	jr z,l830ah		;82e7	28 21 	( ! 
	call 02353h		;82e9	cd 53 23 	. S # 
	ld (01c5bh),de		;82ec	ed 53 5b 1c 	. S [ . 
	ld a,(hl)			;82f0	7e 	~ 
	and 0c0h		;82f1	e6 c0 	. . 
	jr z,l8300h		;82f3	28 0b 	( . 
	ld a,012h		;82f5	3e 12 	> . 
l82f7h:
	ld hl,00000h		;82f7	21 00 00 	! . . 
	ld (024adh),hl		;82fa	22 ad 24 	" . $ 
	jp 022dah		;82fd	c3 da 22 	. . " 
l8300h:
	set 6,(hl)		;8300	cb f6 	. . 
	ld hl,(01b94h)		;8302	2a 94 1b 	* . . 
	ex de,hl			;8305	eb 	. 
	dec hl			;8306	2b 	+ 
	ld (hl),d			;8307	72 	r 
	dec hl			;8308	2b 	+ 
	ld (hl),e			;8309	73 	s 
l830ah:
	ld a,(ix+001h)		;830a	dd 7e 01 	. ~ . 
	and 030h		;830d	e6 30 	. 0 
	cp 030h		;830f	fe 30 	. 0 
	jr z,l8340h		;8311	28 2d 	( - 
	ld a,(ix+001h)		;8313	dd 7e 01 	. ~ . 
	and 007h		;8316	e6 07 	. . 
	ld c,a			;8318	4f 	O 
	ld b,000h		;8319	06 00 	. . 
	ld hl,01c3ah		;831b	21 3a 1c 	! : . 
	add hl,bc			;831e	09 	. 
	ld a,(hl)			;831f	7e 	~ 
	inc a			;8320	3c 	< 
	ld bc,00400h		;8321	01 00 04 	. . . 
	ld d,(ix+001h)		;8324	dd 56 01 	. V . 
l8327h:
	rl d		;8327	cb 12 	. . 
	adc a,c			;8329	89 	. 
	djnz l8327h		;832a	10 fb 	. . 
	jr l839bh		;832c	18 6d 	. m 
	nop			;832e	00 	. 
	ld bc,00102h		;832f	01 02 01 	. . . 
	ld bc,00002h		;8332	01 02 00 	. . . 
	nop			;8335	00 	. 
	bit 3,(ix+001h)		;8336	dd cb 01 5e 	. . . ^ 
	ret z			;833a	c8 	. 
	inc ix		;833b	dd 23 	. # 
	inc ix		;833d	dd 23 	. # 
	ret			;833f	c9 	. 
l8340h:
	ld a,(ix+000h)		;8340	dd 7e 00 	. ~ . 
	call 01c42h		;8343	cd 42 1c 	. B . 
	sub 003h		;8346	d6 03 	. . 
	ret c			;8348	d8 	. 
	jr nz,l8356h		;8349	20 0b 	  . 
	call 01cd8h		;834b	cd d8 1c 	. . . 
	ld hl,00000h		;834e	21 00 00 	! . . 
	dec hl			;8351	2b 	+ 
	ld (hl),b			;8352	70 	p 
	dec hl			;8353	2b 	+ 
	ld (hl),c			;8354	71 	q 
	ret			;8355	c9 	. 
l8356h:
	dec a			;8356	3d 	= 
	jr nz,l8365h		;8357	20 0c 	  . 
	call 01cd8h		;8359	cd d8 1c 	. . . 
	ld (01b94h),bc		;835c	ed 43 94 1b 	. C . . 
	ld (01b75h),bc		;8360	ed 43 75 1b 	. C u . 
	ret			;8364	c9 	. 
l8365h:
	dec a			;8365	3d 	= 
	ret z			;8366	c8 	. 
	dec a			;8367	3d 	= 
	jr nz,l8370h		;8368	20 06 	  . 
	call 01cb0h		;836a	cd b0 1c 	. . . 
	ld a,c			;836d	79 	y 
	jr l839bh		;836e	18 2b 	. + 
l8370h:
	dec a			;8370	3d 	= 
	jr nz,l837dh		;8371	20 0a 	  . 
	ld c,a			;8373	4f 	O 
l8374h:
	inc c			;8374	0c 	. 
	call 01af3h		;8375	cd f3 1a 	. . . 
	jr z,l8374h		;8378	28 fa 	( . 
	ld a,c			;837a	79 	y 
	jr l839bh		;837b	18 1e 	. . 
l837dh:
	dec a			;837d	3d 	= 
	jr nz,l8396h		;837e	20 16 	  . 
l8380h:
	call 01cd8h		;8380	cd d8 1c 	. . . 
	push af			;8383	f5 	. 
	ld hl,01b94h		;8384	21 94 1b 	! . . 
	call 02bc0h		;8387	cd c0 2b 	. . + 
	ld hl,01b75h		;838a	21 75 1b 	! u . 
	call 02bc0h		;838d	cd c0 2b 	. . + 
	pop af			;8390	f1 	. 
	inc ix		;8391	dd 23 	. # 
	jr nc,l8380h		;8393	30 eb 	0 . 
	ret			;8395	c9 	. 
l8396h:
	call 01cb0h		;8396	cd b0 1c 	. . . 
	ld a,c			;8399	79 	y 
	add a,c			;839a	81 	. 
l839bh:
	ld b,000h		;839b	06 00 	. . 
	ld c,a			;839d	4f 	O 
	ld hl,01b94h		;839e	21 94 1b 	! . . 
	jp 02bc0h		;83a1	c3 c0 2b 	. . + 
	ld c,001h		;83a4	0e 01 	. . 
l83a6h:
	ld a,(ix+002h)		;83a6	dd 7e 02 	. ~ . 
	cp 02ch		;83a9	fe 2c 	. , 
	jr nz,l83b0h		;83ab	20 03 	  . 
	inc c			;83ad	0c 	. 
	jr l83bdh		;83ae	18 0d 	. . 
l83b0h:
	cp 022h		;83b0	fe 22 	. " 
	jr nz,l83c1h		;83b2	20 0d 	  . 
l83b4h:
	inc ix		;83b4	dd 23 	. # 
	ld a,(ix+002h)		;83b6	dd 7e 02 	. ~ . 
	cp 022h		;83b9	fe 22 	. " 
	jr nz,l83b4h		;83bb	20 f7 	  . 
l83bdh:
	inc ix		;83bd	dd 23 	. # 
	jr l83a6h		;83bf	18 e5 	. . 
l83c1h:
	cp 0c0h		;83c1	fe c0 	. . 
	ret nc			;83c3	d0 	. 
	cp 080h		;83c4	fe 80 	. . 
	jr c,l83bdh		;83c6	38 f5 	8 . 
	inc ix		;83c8	dd 23 	. # 
	jr l83bdh		;83ca	18 f1 	. . 
	ld hl,00000h		;83cc	21 00 00 	! . . 
	ld a,02bh		;83cf	3e 2b 	> + 
	push hl			;83d1	e5 	. 
	push af			;83d2	f5 	. 
	ld a,(ix+002h)		;83d3	dd 7e 02 	. ~ . 
	push af			;83d6	f5 	. 
	cp 02dh		;83d7	fe 2d 	. - 
	jr nz,l83ddh		;83d9	20 02 	  . 
	inc ix		;83db	dd 23 	. # 
l83ddh:
	ld a,(ix+002h)		;83dd	dd 7e 02 	. ~ . 
	cp 024h		;83e0	fe 24 	. $ 
	ld de,(01b94h)		;83e2	ed 5b 94 1b 	. [ . . 
	jr z,l8409h		;83e6	28 21 	( ! 
	cp 080h		;83e8	fe 80 	. . 
	jp c,01d9bh		;83ea	da 9b 1d 	. . . 
	ld d,a			;83ed	57 	W 
	ld e,(ix+003h)		;83ee	dd 5e 03 	. ^ . 
	inc ix		;83f1	dd 23 	. # 
	call 02356h		;83f3	cd 56 23 	. V # 
	ld a,(hl)			;83f6	7e 	~ 
	and 0c0h		;83f7	e6 c0 	. . 
	jr nz,l8404h		;83f9	20 09 	  . 
	ld (02300h),de		;83fb	ed 53 00 23 	. S . # 
	ld a,009h		;83ff	3e 09 	> . 
	jp 01c03h		;8401	c3 03 1c 	. . . 
l8404h:
	dec de			;8404	1b 	. 
	ex de,hl			;8405	eb 	. 
	ld d,(hl)			;8406	56 	V 
	dec hl			;8407	2b 	+ 
	ld e,(hl)			;8408	5e 	^ 
l8409h:
	inc ix		;8409	dd 23 	. # 
	jr l8439h		;840b	18 2c 	. , 
	ld a,(ix+002h)		;840d	dd 7e 02 	. ~ . 
	xor 02ch		;8410	ee 2c 	. , 
	ld b,h			;8412	44 	D 
	ld c,l			;8413	4d 	M 
	ret z			;8414	c8 	. 
	xor 033h		;8415	ee 33 	. 3 
	ret z			;8417	c8 	. 
	cp 0c0h		;8418	fe c0 	. . 
	ccf			;841a	3f 	? 
	ret c			;841b	d8 	. 
	xor 01fh		;841c	ee 1f 	. . 
	inc ix		;841e	dd 23 	. # 
	jp 01cddh		;8420	c3 dd 1c 	. . . 
l8423h:
	ld de,00000h		;8423	11 00 00 	. . . 
	inc ix		;8426	dd 23 	. # 
	call 01dddh		;8428	cd dd 1d 	. . . 
	jr c,l8437h		;842b	38 0a 	8 . 
	ld e,a			;842d	5f 	_ 
	call 01dddh		;842e	cd dd 1d 	. . . 
	jr c,l8437h		;8431	38 04 	8 . 
	ld d,e			;8433	53 	S 
	ld e,a			;8434	5f 	_ 
	inc ix		;8435	dd 23 	. # 
l8437h:
	ex de,hl			;8437	eb 	. 
	ex de,hl			;8438	eb 	. 
l8439h:
	pop af			;8439	f1 	. 
	call 01d90h		;843a	cd 90 1d 	. . . 
	pop af			;843d	f1 	. 
	pop hl			;843e	e1 	. 
	ld bc,01d19h		;843f	01 19 1d 	. . . 
	push bc			;8442	c5 	. 
	cp 02bh		;8443	fe 2b 	. + 
	jr z,l847fh		;8445	28 38 	( 8 
	cp 02dh		;8447	fe 2d 	. - 
	jr z,l8481h		;8449	28 36 	( 6 
	cp 02ah		;844b	fe 2a 	. * 
	jr z,l846eh		;844d	28 1f 	( . 
	cp 02fh		;844f	fe 2f 	. / 
	jr z,l8468h		;8451	28 15 	( . 
	ld a,h			;8453	7c 	| 
	ld c,l			;8454	4d 	M 
	ld hl,00000h		;8455	21 00 00 	! . . 
	ld b,010h		;8458	06 10 	. . 
l845ah:
	sli c		;845a	cb 31 	. 1 
	rla			;845c	17 	. 
	adc hl,hl		;845d	ed 6a 	. j 
	sbc hl,de		;845f	ed 52 	. R 
	jr nc,l8465h		;8461	30 02 	0 . 
	add hl,de			;8463	19 	. 
	dec c			;8464	0d 	. 
l8465h:
	djnz l845ah		;8465	10 f3 	. . 
	ret			;8467	c9 	. 
l8468h:
	call 01d5fh		;8468	cd 5f 1d 	. _ . 
	ld h,a			;846b	67 	g 
	ld l,c			;846c	69 	i 
	ret			;846d	c9 	. 
l846eh:
	ld b,010h		;846e	06 10 	. . 
	ld a,h			;8470	7c 	| 
	ld c,l			;8471	4d 	M 
	ld hl,00000h		;8472	21 00 00 	! . . 
l8475h:
	add hl,hl			;8475	29 	) 
	rl c		;8476	cb 11 	. . 
	rla			;8478	17 	. 
	jr nc,l847ch		;8479	30 01 	0 . 
	add hl,de			;847b	19 	. 
l847ch:
	djnz l8475h		;847c	10 f7 	. . 
	ret			;847e	c9 	. 
l847fh:
	add hl,de			;847f	19 	. 
	ret			;8480	c9 	. 
l8481h:
	or a			;8481	b7 	. 
	sbc hl,de		;8482	ed 52 	. R 
	cp 02dh		;8484	fe 2d 	. - 
	ret nz			;8486	c0 	. 
	ld a,d			;8487	7a 	z 
	cpl			;8488	2f 	/ 
	ld d,a			;8489	57 	W 
	ld a,e			;848a	7b 	{ 
	cpl			;848b	2f 	/ 
	ld e,a			;848c	5f 	_ 
	inc de			;848d	13 	. 
	ret			;848e	c9 	. 
	ld a,(ix+002h)		;848f	dd 7e 02 	. ~ . 
	cp 022h		;8492	fe 22 	. " 
	jr z,l8423h		;8494	28 8d 	( . 
	ld c,00ah		;8496	0e 0a 	. . 
	cp 025h		;8498	fe 25 	. % 
	jr nz,l84a0h		;849a	20 04 	  . 
	inc ix		;849c	dd 23 	. # 
	ld c,002h		;849e	0e 02 	. . 
l84a0h:
	cp 023h		;84a0	fe 23 	. # 
	jr nz,l84a8h		;84a2	20 04 	  . 
	inc ix		;84a4	dd 23 	. # 
	ld c,010h		;84a6	0e 10 	. . 
l84a8h:
	ld hl,00000h		;84a8	21 00 00 	! . . 
l84abh:
	ld a,(ix+002h)		;84ab	dd 7e 02 	. ~ . 
	sub 030h		;84ae	d6 30 	. 0 
	cp 00ah		;84b0	fe 0a 	. . 
	jr c,l84bbh		;84b2	38 07 	8 . 
	sub 007h		;84b4	d6 07 	. . 
	cp 00ah		;84b6	fe 0a 	. . 
	jp c,01d44h		;84b8	da 44 1d 	. D . 
l84bbh:
	cp c			;84bb	b9 	. 
	jp nc,01d44h		;84bc	d2 44 1d 	. D . 
	push af			;84bf	f5 	. 
	ld a,c			;84c0	79 	y 
	dec a			;84c1	3d 	= 
	ld d,h			;84c2	54 	T 
	ld e,l			;84c3	5d 	] 
l84c4h:
	add hl,de			;84c4	19 	. 
	dec a			;84c5	3d 	= 
	jr nz,l84c4h		;84c6	20 fc 	  . 
	pop af			;84c8	f1 	. 
	ld d,000h		;84c9	16 00 	. . 
	ld e,a			;84cb	5f 	_ 
	add hl,de			;84cc	19 	. 
	inc ix		;84cd	dd 23 	. # 
	jr l84abh		;84cf	18 da 	. . 
	ld a,(ix+002h)		;84d1	dd 7e 02 	. ~ . 
	cp 022h		;84d4	fe 22 	. " 
	jr nz,l84e1h		;84d6	20 09 	  . 
	cp (ix+003h)		;84d8	dd be 03 	. . . 
	inc ix		;84db	dd 23 	. # 
	jr z,l84e1h		;84dd	28 02 	( . 
	scf			;84df	37 	7 
	ret			;84e0	c9 	. 
l84e1h:
	inc ix		;84e1	dd 23 	. # 
	or a			;84e3	b7 	. 
	ret			;84e4	c9 	. 
	inc d			;84e5	14 	. 
	ex af,af'			;84e6	08 	. 
	dec d			;84e7	15 	. 
	di			;84e8	f3 	. 
	ld a,00fh		;84e9	3e 0f 	> . 
	out (0feh),a		;84eb	d3 fe 	. . 
	call 00562h		;84ed	cd 62 05 	. b . 
	push af			;84f0	f5 	. 
	ld a,07fh		;84f1	3e 7f 	>  
	in a,(0feh)		;84f3	db fe 	. . 
	rra			;84f5	1f 	. 
	jp nc,022e2h		;84f6	d2 e2 22 	. . " 
	pop af			;84f9	f1 	. 
	ret			;84fa	c9 	. 
	ld b,061h		;84fb	06 61 	. a 
	call 01e6ch		;84fd	cd 6c 1e 	. l . 
	call z,01a45h		;8500	cc 45 1a 	. E . 
	call 01ee1h		;8503	cd e1 1e 	. . . 
	jp 001b4h		;8506	c3 b4 01 	. . . 
	ld b,079h		;8509	06 79 	. y 
	call 01e6ch		;850b	cd 6c 1e 	. l . 
	ret nz			;850e	c0 	. 
	rst 0			;850f	c7 	. 
l8510h:
	ld ix,050e0h		;8510	dd 21 e0 50 	. ! . P 
	ld de,00011h		;8514	11 11 00 	. . . 
	xor a			;8517	af 	. 
	scf			;8518	37 	7 
	call 01df1h		;8519	cd f1 1d 	. . . 
	jr nc,l8510h		;851c	30 f2 	0 . 
	ld a,011h		;851e	3e 11 	> . 
	call 022f4h		;8520	cd f4 22 	. . " 
	ld hl,050e1h		;8523	21 e1 50 	! . P 
	ld b,00ah		;8526	06 0a 	. . 
l8528h:
	ld a,(hl)			;8528	7e 	~ 
	cp 020h		;8529	fe 20 	.   
	jr c,l8531h		;852b	38 04 	8 . 
	cp 080h		;852d	fe 80 	. . 
	jr c,l8533h		;852f	38 02 	8 . 
l8531h:
	ld a,03fh		;8531	3e 3f 	> ? 
l8533h:
	call 02984h		;8533	cd 84 29 	. . ) 
	inc hl			;8536	23 	# 
	djnz l8528h		;8537	10 ef 	. . 
	ld a,(050e0h)		;8539	3a e0 50 	: . P 
	cp 003h		;853c	fe 03 	. . 
	jr nz,l8510h		;853e	20 d0 	  . 
	ret			;8540	c9 	. 
	ld b,00ah		;8541	06 0a 	. . 
	ld hl,01915h		;8543	21 15 19 	! . . 
l8546h:
	ld a,(hl)			;8546	7e 	~ 
	cp 020h		;8547	fe 20 	.   
	jr nz,l854eh		;8549	20 03 	  . 
	djnz l8546h		;854b	10 f9 	. . 
	ret			;854d	c9 	. 
l854eh:
	ld b,00ah		;854e	06 0a 	. . 
	ld hl,01915h		;8550	21 15 19 	! . . 
	ld de,050e1h		;8553	11 e1 50 	. . P 
l8556h:
	ld a,(de)			;8556	1a 	. 
	cp (hl)			;8557	be 	. 
	inc hl			;8558	23 	# 
	inc de			;8559	13 	. 
	ret nz			;855a	c0 	. 
	djnz l8556h		;855b	10 f9 	. . 
	ret			;855d	c9 	. 
	ld b,042h		;855e	06 42 	. B 
	ld hl,02d40h		;8560	21 40 2d 	! @ - 
	call 027eeh		;8563	cd ee 27 	. . ' 
	inc hl			;8566	23 	# 
	cp b			;8567	b8 	. 
	ret z			;8568	c8 	. 
	set 5,b		;8569	cb e8 	. . 
	cp b			;856b	b8 	. 
	ret			;856c	c9 	. 
	ld hl,02b49h		;856d	21 49 2b 	! I + 
	jr l8575h		;8570	18 03 	. . 
	ld hl,0205fh		;8572	21 5f 20 	! _   
l8575h:
	ld a,(hl)			;8575	7e 	~ 
	xor 001h		;8576	ee 01 	. . 
	ld (hl),a			;8578	77 	w 
	ret			;8579	c9 	. 
	ld iy,05c3ah		;857a	fd 21 3a 5c 	. ! : \ 
	im 1		;857e	ed 56 	. V 
	ei			;8580	fb 	. 
	ld sp,(05c3dh)		;8581	ed 7b 3d 5c 	. { = \ 
	jp 01b76h		;8585	c3 76 1b 	. v . 
	push af			;8588	f5 	. 
	ld c,000h		;8589	0e 00 	. . 
	call 022b0h		;858b	cd b0 22 	. . " 
	push hl			;858e	e5 	. 
	call 01ec3h		;858f	cd c3 1e 	. . . 
	pop de			;8592	d1 	. 
	pop af			;8593	f1 	. 
	ret			;8594	c9 	. 
	push hl			;8595	e5 	. 
	pop ix		;8596	dd e1 	. . 
	call 024cfh		;8598	cd cf 24 	. . $ 
	ld a,0efh		;859b	3e ef 	> . 
	in a,(0feh)		;859d	db fe 	. . 
	ret			;859f	c9 	. 
	call 02472h		;85a0	cd 72 24 	. r $ 
	call 02c64h		;85a3	cd 64 2c 	. d , 
	ccf			;85a6	3f 	? 
	jr l85afh		;85a7	18 06 	. . 
	call 02485h		;85a9	cd 85 24 	. . $ 
	call 02c6fh		;85ac	cd 6f 2c 	. o , 
l85afh:
	pop de			;85af	d1 	. 
	jr nc,l8622h		;85b0	30 70 	0 p 
	push de			;85b2	d5 	. 
	ld (024adh),hl		;85b3	22 ad 24 	" . $ 
	ret			;85b6	c9 	. 
	push hl			;85b7	e5 	. 
	push de			;85b8	d5 	. 
	ld b,008h		;85b9	06 08 	. . 
l85bbh:
	push hl			;85bb	e5 	. 
	push de			;85bc	d5 	. 
	ld c,020h		;85bd	0e 20 	.   
l85bfh:
	ld a,(hl)			;85bf	7e 	~ 
	ld (de),a			;85c0	12 	. 
	inc l			;85c1	2c 	, 
	inc e			;85c2	1c 	. 
	dec c			;85c3	0d 	. 
	jr nz,l85bfh		;85c4	20 f9 	  . 
	pop de			;85c6	d1 	. 
	pop hl			;85c7	e1 	. 
	inc h			;85c8	24 	$ 
	inc d			;85c9	14 	. 
	djnz l85bbh		;85ca	10 ef 	. . 
	pop de			;85cc	d1 	. 
	pop hl			;85cd	e1 	. 
	ret			;85ce	c9 	. 
	ld (de),a			;85cf	12 	. 
	inc de			;85d0	13 	. 
	dec c			;85d1	0d 	. 
	ret nz			;85d2	c0 	. 
	jr l8603h		;85d3	18 2e 	. . 
	ld e,020h		;85d5	1e 20 	.   
	ld bc,00003h		;85d7	01 03 00 	. . . 
l85dah:
	ld a,e			;85da	7b 	{ 
	call 029a9h		;85db	cd a9 29 	. . ) 
	djnz l85dah		;85de	10 fa 	. . 
	dec c			;85e0	0d 	. 
	jr nz,l85dah		;85e1	20 f7 	  . 
	ret			;85e3	c9 	. 
	ld a,001h		;85e4	3e 01 	> . 
	ld (01ef9h),a		;85e6	32 f9 1e 	2 . . 
	call 01a45h		;85e9	cd 45 1a 	. E . 
	ld a,000h		;85ec	3e 00 	> . 
	or a			;85ee	b7 	. 
	ld a,013h		;85ef	3e 13 	> . 
	jp nz,022dah		;85f1	c2 da 22 	. . " 
	call 01ee1h		;85f4	cd e1 1e 	. . . 
	call 00000h		;85f7	cd 00 00 	. . . 
	call 02879h		;85fa	cd 79 28 	. y ( 
	di			;85fd	f3 	. 
	ld e,07eh		;85fe	1e 7e 	. ~ 
	call 01ee3h		;8600	cd e3 1e 	. . . 
l8603h:
	ld hl,059e0h		;8603	21 e0 59 	! . Y 
	ld bc,02030h		;8606	01 30 20 	. 0   
	call 02521h		;8609	cd 21 25 	. ! % 
	ld a,00fh		;860c	3e 0f 	> . 
	call 02c34h		;860e	cd 34 2c 	. 4 , 
	ld hl,02ce5h		;8611	21 e5 2c 	! . , 
	ld bc,l9e00h		;8614	01 00 9e 	. . . 
	call 02521h		;8617	cd 21 25 	. ! % 
	ld hl,02d3fh		;861a	21 3f 2d 	! ? - 
	ld (hl),001h		;861d	36 01 	6 . 
	dec hl			;861f	2b 	+ 
	ld (hl),080h		;8620	36 80 	6 . 
l8622h:
	ld sp,02de1h		;8622	31 e1 2d 	1 . - 
	call 024ach		;8625	cd ac 24 	. . $ 
l8628h:
	call 027feh		;8628	cd fe 27 	. . ' 
	call 01a40h		;862b	cd 40 1a 	. @ . 
	call 02879h		;862e	cd 79 28 	. y ( 
	push af			;8631	f5 	. 
	ld a,00fh		;8632	3e 0f 	> . 
	call 02c34h		;8634	cd 34 2c 	. 4 , 
	ld a,00fh		;8637	3e 0f 	> . 
	ld (01f3fh),a		;8639	32 3f 1f 	2 ? . 
	pop af			;863c	f1 	. 
	cp 015h		;863d	fe 15 	. . 
	jr z,l8603h		;863f	28 c2 	( . 
	cp 004h		;8641	fe 04 	. . 
	jr nz,l865eh		;8643	20 19 	  . 
	ld ix,(024adh)		;8645	dd 2a ad 24 	. * . $ 
	ld hl,02d3fh		;8649	21 3f 2d 	! ? - 
	push hl			;864c	e5 	. 
	ld bc,02000h		;864d	01 00 20 	. .   
	call 02521h		;8650	cd 21 25 	. ! % 
	pop hl			;8653	e1 	. 
	call 02378h		;8654	cd 78 23 	. x # 
	ld a,001h		;8657	3e 01 	> . 
	ld (0205fh),a		;8659	32 5f 20 	2 _   
	jr l8665h		;865c	18 07 	. . 
l865eh:
	cp 014h		;865e	fe 14 	. . 
	jr nz,l866ch		;8660	20 0a 	  . 
	call 01e7eh		;8662	cd 7e 1e 	. ~ . 
l8665h:
	ld a,00fh		;8665	3e 0f 	> . 
	call 02c34h		;8667	cd 34 2c 	. 4 , 
	jr l8622h		;866a	18 b6 	. . 
l866ch:
	ld b,014h		;866c	06 14 	. . 
	cp 006h		;866e	fe 06 	. . 
	jr nz,l8679h		;8670	20 07 	  . 
l8672h:
	call 01eb5h		;8672	cd b5 1e 	. . . 
	djnz l8672h		;8675	10 fb 	. . 
l8677h:
	jr l8622h		;8677	18 a9 	. . 
l8679h:
	cp 009h		;8679	fe 09 	. . 
	jr nz,l86a7h		;867b	20 2a 	  * 
l867dh:
	call 01eb5h		;867d	cd b5 1e 	. . . 
	ld de,04040h		;8680	11 40 40 	. @ @ 
	ld a,018h		;8683	3e 18 	> . 
l8685h:
	call 01e94h		;8685	cd 94 1e 	. . . 
	add a,008h		;8688	c6 08 	. . 
	cp 0a9h		;868a	fe a9 	. . 
	jr c,l8685h		;868c	38 f7 	8 . 
	ld hl,050a0h		;868e	21 a0 50 	! . P 
	call 02835h		;8691	cd 35 28 	. 5 ( 
	ld b,006h		;8694	06 06 	. . 
	ld hl,(024adh)		;8696	2a ad 24 	* . $ 
l8699h:
	call 02488h		;8699	cd 88 24 	. . $ 
	djnz l8699h		;869c	10 fb 	. . 
	call 01ea1h		;869e	cd a1 1e 	. . . 
	bit 4,a		;86a1	cb 67 	. g 
	jr z,l867dh		;86a3	28 d8 	( . 
l86a5h:
	jr l8628h		;86a5	18 81 	. . 
l86a7h:
	cp 007h		;86a7	fe 07 	. . 
	jr nz,l86b2h		;86a9	20 07 	  . 
l86abh:
	call 01each		;86ab	cd ac 1e 	. . . 
	djnz l86abh		;86ae	10 fb 	. . 
l86b0h:
	jr l8677h		;86b0	18 c5 	. . 
l86b2h:
	cp 00ah		;86b2	fe 0a 	. . 
	jr nz,l86e0h		;86b4	20 2a 	  * 
l86b6h:
	call 01each		;86b6	cd ac 1e 	. . . 
	ld de,050a0h		;86b9	11 a0 50 	. . P 
	ld a,0a0h		;86bc	3e a0 	> . 
l86beh:
	call 01e94h		;86be	cd 94 1e 	. . . 
	sub 008h		;86c1	d6 08 	. . 
	cp 010h		;86c3	fe 10 	. . 
	jr nc,l86beh		;86c5	30 f7 	0 . 
	ld hl,04040h		;86c7	21 40 40 	! @ @ 
	call 02835h		;86ca	cd 35 28 	. 5 ( 
	ld b,00dh		;86cd	06 0d 	. . 
	ld hl,(024adh)		;86cf	2a ad 24 	* . $ 
l86d2h:
	call 02475h		;86d2	cd 75 24 	. u $ 
	djnz l86d2h		;86d5	10 fb 	. . 
	call 01ea1h		;86d7	cd a1 1e 	. . . 
	bit 3,a		;86da	cb 5f 	. _ 
	jr z,l86b6h		;86dc	28 d8 	( . 
l86deh:
	jr l86a5h		;86de	18 c5 	. . 
l86e0h:
	cp 00ch		;86e0	fe 0c 	. . 
	jr nz,l86fah		;86e2	20 16 	  . 
	ld bc,00001h		;86e4	01 01 00 	. . . 
	ld hl,(024adh)		;86e7	2a ad 24 	* . $ 
	call 0145ah		;86ea	cd 5a 14 	. Z . 
	call 02c64h		;86ed	cd 64 2c 	. d , 
	jr z,l86b0h		;86f0	28 be 	( . 
	call nc,02475h		;86f2	d4 75 24 	. u $ 
	ld (024adh),hl		;86f5	22 ad 24 	" . $ 
l86f8h:
	jr l86b0h		;86f8	18 b6 	. . 
l86fah:
	cp 00eh		;86fa	fe 0e 	. . 
	jr nz,l870ch		;86fc	20 0e 	  . 
	ld hl,(0232bh)		;86fe	2a 2b 23 	* + # 
	ld (02328h),hl		;8701	22 28 23 	" ( # 
	ld hl,(024adh)		;8704	2a ad 24 	* . $ 
	ld (0232bh),hl		;8707	22 2b 23 	" + # 
	jr l86f8h		;870a	18 ec 	. . 
l870ch:
	call 0207bh		;870c	cd 7b 20 	. {   
	jr nz,l86deh		;870f	20 cd 	  . 
	ld hl,05ae0h		;8711	21 e0 5a 	! . Z 
	ld bc,0203fh		;8714	01 3f 20 	. ?   
	call 02521h		;8717	cd 21 25 	. ! % 
	ld hl,02d3fh		;871a	21 3f 2d 	! ? - 
	call 027eeh		;871d	cd ee 27 	. . ' 
	ld d,000h		;8720	16 00 	. . 
	ld c,009h		;8722	0e 09 	. . 
	cp 080h		;8724	fe 80 	. . 
	jr c,l873bh		;8726	38 13 	8 . 
	ld hl,01f0fh		;8728	21 0f 1f 	! . . 
	ld (02079h),hl		;872b	22 79 20 	" y   
	push hl			;872e	e5 	. 
	ld h,d			;872f	62 	b 
	ld l,a			;8730	6f 	o 
	ld de,01209h		;8731	11 09 12 	. . . 
	add hl,hl			;8734	29 	) 
	add hl,de			;8735	19 	. 
	ld a,(hl)			;8736	7e 	~ 
	inc hl			;8737	23 	# 
	ld h,(hl)			;8738	66 	f 
	ld l,a			;8739	6f 	o 
	jp (hl)			;873a	e9 	. 
l873bh:
	call 02127h		;873b	cd 27 21 	. ' ! 
	call 02485h		;873e	cd 85 24 	. . $ 
	push hl			;8741	e5 	. 
	ld (02bafh),hl		;8742	22 af 2b 	" . + 
	ld de,02d61h		;8745	11 61 2d 	. a - 
	ld a,(de)			;8748	1a 	. 
	ld c,a			;8749	4f 	O 
	inc de			;874a	13 	. 
	call 02cach		;874b	cd ac 2c 	. . , 
	pop hl			;874e	e1 	. 
	ld (024adh),hl		;874f	22 ad 24 	" . $ 
	ld a,000h		;8752	3e 00 	> . 
	or a			;8754	b7 	. 
	jr z,l8763h		;8755	28 0c 	( . 
	call 02472h		;8757	cd 72 24 	. r $ 
	ld (024adh),hl		;875a	22 ad 24 	" . $ 
	ld bc,00001h		;875d	01 01 00 	. . . 
	call 02bcah		;8760	cd ca 2b 	. . + 
l8763h:
	ld a,00fh		;8763	3e 0f 	> . 
	ld (01f3fh),a		;8765	32 3f 1f 	2 ? . 
	xor a			;8768	af 	. 
	ld (0205fh),a		;8769	32 5f 20 	2 _   
	jp 01f0fh		;876c	c3 0f 1f 	. . . 
	ld hl,02d40h		;876f	21 40 2d 	! @ - 
	cp 00dh		;8772	fe 0d 	. . 
	ret z			;8774	c8 	. 
	cp 008h		;8775	fe 08 	. . 
	jr nz,l8785h		;8777	20 0c 	  . 
	ld b,(hl)			;8779	46 	F 
	dec hl			;877a	2b 	+ 
	ld a,(hl)			;877b	7e 	~ 
	rlca			;877c	07 	. 
	jr c,l87a6h		;877d	38 27 	8 ' 
	ld c,(hl)			;877f	4e 	N 
	ld (hl),b			;8780	70 	p 
	inc hl			;8781	23 	# 
	ld (hl),c			;8782	71 	q 
	jr l87a6h		;8783	18 21 	. ! 
l8785h:
	cp 00bh		;8785	fe 0b 	. . 
	jr nz,l8793h		;8787	20 0a 	  . 
	ld b,(hl)			;8789	46 	F 
	inc hl			;878a	23 	# 
	ld a,(hl)			;878b	7e 	~ 
	and a			;878c	a7 	. 
	jr z,l87a6h		;878d	28 17 	( . 
	ld (hl),b			;878f	70 	p 
	dec hl			;8790	2b 	+ 
	ld (hl),a			;8791	77 	w 
	ret			;8792	c9 	. 
l8793h:
	cp 003h		;8793	fe 03 	. . 
	jr nz,l87a8h		;8795	20 11 	  . 
	ld d,h			;8797	54 	T 
	ld e,l			;8798	5d 	] 
	dec hl			;8799	2b 	+ 
	ld a,(hl)			;879a	7e 	~ 
	cp 080h		;879b	fe 80 	. . 
	jr z,l87a6h		;879d	28 07 	( . 
l879fh:
	ld a,(de)			;879f	1a 	. 
	ld (hl),a			;87a0	77 	w 
	inc hl			;87a1	23 	# 
	inc de			;87a2	13 	. 
	or a			;87a3	b7 	. 
	jr nz,l879fh		;87a4	20 f9 	  . 
l87a6h:
	inc a			;87a6	3c 	< 
	ret			;87a7	c9 	. 
l87a8h:
	cp 005h		;87a8	fe 05 	. . 
	jr nz,l87b5h		;87aa	20 09 	  . 
	ld hl,028aeh		;87ac	21 ae 28 	! . ( 
	ld a,0f7h		;87af	3e f7 	> . 
	sub (hl)			;87b1	96 	. 
	ld (hl),a			;87b2	77 	w 
	jr l87a6h		;87b3	18 f1 	. . 
l87b5h:
	cp 020h		;87b5	fe 20 	.   
	ret c			;87b7	d8 	. 
	ld b,a			;87b8	47 	G 
	jr nz,l87e0h		;87b9	20 25 	  % 
	ld de,02d3fh		;87bb	11 3f 2d 	. ? - 
	ld a,(de)			;87be	1a 	. 
	cp 03bh		;87bf	fe 3b 	. ; 
	jr z,l87e0h		;87c1	28 1d 	( . 
	rlca			;87c3	07 	. 
	jr c,l87e0h		;87c4	38 1a 	8 . 
	push hl			;87c6	e5 	. 
	sbc hl,de		;87c7	ed 52 	. R 
	ld a,00dh		;87c9	3e 0d 	> . 
	sub l			;87cb	95 	. 
	pop hl			;87cc	e1 	. 
l87cdh:
	jr c,l87e0h		;87cd	38 11 	8 . 
	cp 005h		;87cf	fe 05 	. . 
	jr c,l87d5h		;87d1	38 02 	8 . 
	sub 005h		;87d3	d6 05 	. . 
l87d5h:
	ld b,a			;87d5	47 	G 
	inc b			;87d6	04 	. 
	ld c,020h		;87d7	0e 20 	.   
	call 02521h		;87d9	cd 21 25 	. ! % 
	ld (hl),001h		;87dc	36 01 	6 . 
	jr l87a6h		;87de	18 c6 	. . 
l87e0h:
	ld a,007h		;87e0	3e 07 	> . 
	or a			;87e2	b7 	. 
	jr z,l87a6h		;87e3	28 c1 	( . 
	ld a,b			;87e5	78 	x 
l87e6h:
	ex af,af'			;87e6	08 	. 
	ld a,(hl)			;87e7	7e 	~ 
	ex af,af'			;87e8	08 	. 
	ld (hl),a			;87e9	77 	w 
	cp 0c5h		;87ea	fe c5 	. . 
	ret z			;87ec	c8 	. 
	cp 0c8h		;87ed	fe c8 	. . 
	ret z			;87ef	c8 	. 
	cp 0cbh		;87f0	fe cb 	. . 
	ret z			;87f2	c8 	. 
	cp 0d7h		;87f3	fe d7 	. . 
	ret z			;87f5	c8 	. 
	inc hl			;87f6	23 	# 
	ex af,af'			;87f7	08 	. 
	or a			;87f8	b7 	. 
	jr nz,l87e6h		;87f9	20 eb 	  . 
	jr l87a6h		;87fb	18 a9 	. . 
l87fdh:
	ld ix,02d64h		;87fd	dd 21 64 2d 	. ! d - 
	ld (ix-002h),001h		;8801	dd 36 fe 01 	. 6 . . 
	ld (ix-001h),037h		;8805	dd 36 ff 37 	. 6 . 7 
	ld b,0ffh		;8809	06 ff 	. . 
	jr l8810h		;880b	18 03 	. . 
l880dh:
	call 027edh		;880d	cd ed 27 	. . ' 
l8810h:
	call 02ba2h		;8810	cd a2 2b 	. . + 
	or a			;8813	b7 	. 
	jr nz,l880dh		;8814	20 f7 	  . 
	dec ix		;8816	dd 2b 	. + 
	jp 0222fh		;8818	c3 2f 22 	. / " 
	cp 03bh		;881b	fe 3b 	. ; 
	jr z,l87fdh		;881d	28 de 	( . 
	cp 020h		;881f	fe 20 	.   
	call nz,027afh		;8821	c4 af 27 	. . ' 
	call 027f5h		;8824	cd f5 27 	. . ' 
	ld de,02d39h		;8827	11 39 2d 	. 9 - 
	ld c,005h		;882a	0e 05 	. . 
	call 027afh		;882c	cd af 27 	. . ' 
	call 027f5h		;882f	cd f5 27 	. . ' 
	ld de,02d25h		;8832	11 25 2d 	. % - 
	ld c,012h		;8835	0e 12 	. . 
	call 027b3h		;8837	cd b3 27 	. . ' 
	jr nz,l8840h		;883a	20 04 	  . 
	inc hl			;883c	23 	# 
	ld (02d38h),a		;883d	32 38 2d 	2 8 - 
l8840h:
	ld de,02d11h		;8840	11 11 2d 	. . - 
	ld c,012h		;8843	0e 12 	. . 
	call 027b7h		;8845	cd b7 27 	. . ' 
	call 025cbh		;8848	cd cb 25 	. . % 
	ld hl,02d39h		;884b	21 39 2d 	! 9 - 
	ld a,(hl)			;884e	7e 	~ 
	or a			;884f	b7 	. 
	jr z,l8863h		;8850	28 11 	( . 
	push hl			;8852	e5 	. 
	call 0275fh		;8853	cd 5f 27 	. _ ' 
	ld hl,02785h		;8856	21 85 27 	! . ' 
	call 02799h		;8859	cd 99 27 	. . ' 
	pop hl			;885c	e1 	. 
	call 02767h		;885d	cd 67 27 	. g ' 
	jp c,022bdh		;8860	da bd 22 	. . " 
l8863h:
	ld (021d9h),a		;8863	32 d9 21 	2 . ! 
	cp 03ah		;8866	fe 3a 	. : 
	jr c,l886fh		;8868	38 05 	8 . 
	cp 03eh		;886a	fe 3e 	. > 
	jp c,02241h		;886c	da 41 22 	. A " 
l886fh:
	ld hl,02d25h		;886f	21 25 2d 	! % - 
	push hl			;8872	e5 	. 
	call 0275fh		;8873	cd 5f 27 	. _ ' 
	pop hl			;8876	e1 	. 
	ld a,b			;8877	78 	x 
	dec a			;8878	3d 	= 
	jr nz,l88a3h		;8879	20 28 	  ( 
	ld a,(021d9h)		;887b	3a d9 21 	: . ! 
	cp 006h		;887e	fe 06 	. . 
	jr nz,l8890h		;8880	20 0e 	  . 
	ld a,(hl)			;8882	7e 	~ 
	sub 02fh		;8883	d6 2f 	. / 
	cp 004h		;8885	fe 04 	. . 
l8887h:
	jp nc,022c1h		;8887	d2 c1 22 	. . " 
	or a			;888a	b7 	. 
	jp z,022c1h		;888b	ca c1 22 	. . " 
	jr l88a6h		;888e	18 16 	. . 
l8890h:
	cp 011h		;8890	fe 11 	. . 
	jr z,l889ch		;8892	28 08 	( . 
	cp 026h		;8894	fe 26 	. & 
	jr z,l889ch		;8896	28 04 	( . 
	cp 031h		;8898	fe 31 	. 1 
	jr nz,l88a3h		;889a	20 07 	  . 
l889ch:
	ld a,(hl)			;889c	7e 	~ 
	sub 02fh		;889d	d6 2f 	. / 
	cp 009h		;889f	fe 09 	. . 
	jr l8887h		;88a1	18 e4 	. . 
l88a3h:
	call 02720h		;88a3	cd 20 27 	.   ' 
l88a6h:
	ld (021cbh),a		;88a6	32 cb 21 	2 . ! 
	ld hl,02d11h		;88a9	21 11 2d 	! . - 
	call 02720h		;88ac	cd 20 27 	.   ' 
	ld (021c3h),a		;88af	32 c3 21 	2 . ! 
	xor a			;88b2	af 	. 
	ld (02201h),a		;88b3	32 01 22 	2 . " 
	ld a,000h		;88b6	3e 00 	> . 
	call 02703h		;88b8	cd 03 27 	. . ' 
	add a,a			;88bb	87 	. 
	add a,a			;88bc	87 	. 
	ld e,a			;88bd	5f 	_ 
	ld a,000h		;88be	3e 00 	> . 
	call 02703h		;88c0	cd 03 27 	. . ' 
	ld d,a			;88c3	57 	W 
	ld b,003h		;88c4	06 03 	. . 
l88c6h:
	sla e		;88c6	cb 23 	. # 
	rl d		;88c8	cb 12 	. . 
	djnz l88c6h		;88ca	10 fa 	. . 
	ld a,000h		;88cc	3e 00 	> . 
	rla			;88ce	17 	. 
	ld hl,030e1h		;88cf	21 e1 30 	! . 0 
	ld bc,002afh		;88d2	01 af 02 	. . . 
l88d5h:
	inc hl			;88d5	23 	# 
	ex af,af'			;88d6	08 	. 
l88d7h:
	inc hl			;88d7	23 	# 
	ex af,af'			;88d8	08 	. 
	inc hl			;88d9	23 	# 
	inc hl			;88da	23 	# 
	cpi		;88db	ed a1 	. . 
	jp po,022d8h		;88dd	e2 d8 22 	. . " 
	jr nz,l88d5h		;88e0	20 f3 	  . 
	ex af,af'			;88e2	08 	. 
	ld a,(hl)			;88e3	7e 	~ 
	inc hl			;88e4	23 	# 
	cp d			;88e5	ba 	. 
	jr nz,l88d7h		;88e6	20 ef 	  . 
	ld a,(hl)			;88e8	7e 	~ 
	and 0e0h		;88e9	e6 e0 	. . 
	cp e			;88eb	bb 	. 
	jr nz,l88d7h		;88ec	20 e9 	  . 
	dec hl			;88ee	2b 	+ 
	dec hl			;88ef	2b 	+ 
	dec hl			;88f0	2b 	+ 
	ld d,(hl)			;88f1	56 	V 
	dec hl			;88f2	2b 	+ 
	ld e,(hl)			;88f3	5e 	^ 
	ld a,000h		;88f4	3e 00 	> . 
	or a			;88f6	b7 	. 
	jr z,l88fdh		;88f7	28 04 	( . 
	res 5,d		;88f9	cb aa 	. . 
	set 4,d		;88fb	cb e2 	. . 
l88fdh:
	call 02526h		;88fd	cd 26 25 	. & % 
	ld a,(021cbh)		;8900	3a cb 21 	: . ! 
	cp 02ch		;8903	fe 2c 	. , 
	ld de,02d25h		;8905	11 25 2d 	. % - 
	call nc,025e0h		;8908	d4 e0 25 	. . % 
	ld a,(021c3h)		;890b	3a c3 21 	: . ! 
	jr c,l891bh		;890e	38 0b 	8 . 
	cp 02ch		;8910	fe 2c 	. , 
	jr c,l8923h		;8912	38 0f 	8 . 
	ld (ix+000h),01fh		;8914	dd 36 00 1f 	. 6 . . 
	inc ix		;8918	dd 23 	. # 
	inc b			;891a	04 	. 
l891bh:
	ld de,02d11h		;891b	11 11 2d 	. . - 
	cp 02ch		;891e	fe 2c 	. , 
	call nc,025e0h		;8920	d4 e0 25 	. . % 
l8923h:
	ld a,b			;8923	78 	x 
	or a			;8924	b7 	. 
	jr z,l892fh		;8925	28 08 	( . 
	set 7,b		;8927	cb f8 	. . 
	set 6,b		;8929	cb f0 	. . 
	ld (ix+000h),b		;892b	dd 70 00 	. p . 
	inc a			;892e	3c 	< 
l892fh:
	add a,002h		;892f	c6 02 	. . 
	ld (02d61h),a		;8931	32 61 2d 	2 a - 
	ret			;8934	c9 	. 
	push af			;8935	f5 	. 
	sub 034h		;8936	d6 34 	. 4 
	ld e,a			;8938	5f 	_ 
	ld d,037h		;8939	16 37 	. 7 
	call 02526h		;893b	cd 26 25 	. & % 
	push bc			;893e	c5 	. 
	ld hl,02d24h		;893f	21 24 2d 	! $ - 
	xor a			;8942	af 	. 
	ld c,a			;8943	4f 	O 
l8944h:
	inc hl			;8944	23 	# 
	inc c			;8945	0c 	. 
	cp (hl)			;8946	be 	. 
	jr nz,l8944h		;8947	20 fb 	  . 
	ld de,02d11h		;8949	11 11 2d 	. . - 
	ld a,(de)			;894c	1a 	. 
	or a			;894d	b7 	. 
	jr z,l8954h		;894e	28 04 	( . 
	ld (hl),02ch		;8950	36 2c 	6 , 
	inc hl			;8952	23 	# 
	xor a			;8953	af 	. 
l8954h:
	ex de,hl			;8954	eb 	. 
l8955h:
	cp (hl)			;8955	be 	. 
	jr z,l895eh		;8956	28 06 	( . 
	ldi		;8958	ed a0 	. . 
	inc c			;895a	0c 	. 
	inc c			;895b	0c 	. 
	jr l8955h		;895c	18 f7 	. . 
l895eh:
	ld a,012h		;895e	3e 12 	> . 
	cp c			;8960	b9 	. 
	jr c,l89bdh		;8961	38 5a 	8 Z 
	pop bc			;8963	c1 	. 
	pop af			;8964	f1 	. 
	cp 03bh		;8965	fe 3b 	. ; 
	jr z,l897eh		;8967	28 15 	( . 
	ld de,02d25h		;8969	11 25 2d 	. % - 
l896ch:
	ld a,02ch		;896c	3e 2c 	> , 
	call 025e0h		;896e	cd e0 25 	. . % 
	ld a,(de)			;8971	1a 	. 
	or a			;8972	b7 	. 
l8973h:
	jr z,l8923h		;8973	28 ae 	( . 
	ld (ix+000h),02ch		;8975	dd 36 00 2c 	. 6 . , 
	inc ix		;8979	dd 23 	. # 
	inc b			;897b	04 	. 
	jr l896ch		;897c	18 ee 	. . 
l897eh:
	ld hl,02d25h		;897e	21 25 2d 	! % - 
	call 022cdh		;8981	cd cd 22 	. . " 
	call 02ba2h		;8984	cd a2 2b 	. . + 
	inc hl			;8987	23 	# 
	ld a,(hl)			;8988	7e 	~ 
	call 02ba2h		;8989	cd a2 2b 	. . + 
	inc hl			;898c	23 	# 
	ld a,(hl)			;898d	7e 	~ 
l898eh:
	call 02ba2h		;898e	cd a2 2b 	. . + 
	inc hl			;8991	23 	# 
	ld a,(hl)			;8992	7e 	~ 
	or a			;8993	b7 	. 
	jr nz,l898eh		;8994	20 f8 	  . 
	dec hl			;8996	2b 	+ 
	call 022cdh		;8997	cd cd 22 	. . " 
	jr l8973h		;899a	18 d7 	. . 
	push hl			;899c	e5 	. 
	push de			;899d	d5 	. 
	ld hl,(02a5ah)		;899e	2a 5a 2a 	* Z * 
	add hl,bc			;89a1	09 	. 
	jr c,l89adh		;89a2	38 09 	8 . 
	ld de,(01b86h)		;89a4	ed 5b 86 1b 	. [ . . 
	sbc hl,de		;89a8	ed 52 	. R 
	pop de			;89aa	d1 	. 
	pop hl			;89ab	e1 	. 
	ret c			;89ac	d8 	. 
l89adh:
	ld a,007h		;89ad	3e 07 	> . 
	jr l89ceh		;89af	18 1d 	. . 
	ld a,001h		;89b1	3e 01 	> . 
	jr l89ceh		;89b3	18 19 	. . 
	ld a,002h		;89b5	3e 02 	> . 
	jr l89ceh		;89b7	18 15 	. . 
	ld a,003h		;89b9	3e 03 	> . 
	jr l89ceh		;89bb	18 11 	. . 
l89bdh:
	ld a,004h		;89bd	3e 04 	> . 
	jr l89ceh		;89bf	18 0d 	. . 
	ld a,(hl)			;89c1	7e 	~ 
	cp 027h		;89c2	fe 27 	. ' 
	ret z			;89c4	c8 	. 
	cp 022h		;89c5	fe 22 	. " 
	ret z			;89c7	c8 	. 
	ld a,005h		;89c8	3e 05 	> . 
	jr l89ceh		;89ca	18 02 	. . 
	ld a,006h		;89cc	3e 06 	> . 
l89ceh:
	ex af,af'			;89ce	08 	. 
	call 02953h		;89cf	cd 53 29 	. S ) 
	ex af,af'			;89d2	08 	. 
	call 02c34h		;89d3	cd 34 2c 	. 4 , 
	call 0251bh		;89d6	cd 1b 25 	. . % 
	ld hl,(024adh)		;89d9	2a ad 24 	* . $ 
	call 02c6fh		;89dc	cd 6f 2c 	. o , 
	call z,02475h		;89df	cc 75 24 	. u $ 
	ld (024adh),hl		;89e2	22 ad 24 	" . $ 
	jp 01f2eh		;89e5	c3 2e 1f 	. . . 
	ld hl,04000h		;89e8	21 00 40 	! . @ 
	call 02835h		;89eb	cd 35 28 	. 5 ( 
	cp 009h		;89ee	fe 09 	. . 
	jr nz,l8a00h		;89f0	20 0e 	  . 
	push af			;89f2	f5 	. 
	ld hl,02321h		;89f3	21 21 23 	! ! # 
	call 02317h		;89f6	cd 17 23 	. . # 
	ld hl,02321h		;89f9	21 21 23 	! ! # 
	ld (02300h),hl		;89fc	22 00 23 	" . # 
	pop af			;89ff	f1 	. 
l8a00h:
	ld hl,02de1h		;8a00	21 e1 2d 	! . - 
l8a03h:
	bit 7,(hl)		;8a03	cb 7e 	. ~ 
	inc hl			;8a05	23 	# 
	jr z,l8a03h		;8a06	28 fb 	( . 
	dec a			;8a08	3d 	= 
	jr nz,l8a03h		;8a09	20 f8 	  . 
l8a0bh:
	ld a,(hl)			;8a0b	7e 	~ 
	call 029a7h		;8a0c	cd a7 29 	. . ) 
	bit 7,(hl)		;8a0f	cb 7e 	. ~ 
	inc hl			;8a11	23 	# 
	jr z,l8a0bh		;8a12	28 f7 	( . 
	ret			;8a14	c9 	. 

; BLOCK 'data_8a15' (start 0x8a15 end 0x8a1b)
data_8a15_start:
	defb 053h		;8a15	53 	S 
	defb 079h		;8a16	79 	y 
	defb 06dh		;8a17	6d 	m 
	defb 062h		;8a18	62 	b 
	defb 06fh		;8a19	6f 	o 
	defb 0ech		;8a1a	ec 	. 
data_8a15_end:
	ld hl,03e68h		;8a1b	21 68 3e 	! h > 
	ld de,03e68h		;8a1e	11 68 3e 	. h > 
	push hl			;8a21	e5 	. 
	xor a			;8a22	af 	. 
	sbc hl,de		;8a23	ed 52 	. R 
	pop hl			;8a25	e1 	. 
	ret c			;8a26	d8 	. 
	ex de,hl			;8a27	eb 	. 
	ret			;8a28	c9 	. 
	exx			;8a29	d9 	. 
	push ix		;8a2a	dd e5 	. . 
	call 02327h		;8a2c	cd 27 23 	. ' # 
	ld b,h			;8a2f	44 	D 
	ld c,l			;8a30	4d 	M 
	pop hl			;8a31	e1 	. 
	push hl			;8a32	e5 	. 
	xor a			;8a33	af 	. 
	sbc hl,bc		;8a34	ed 42 	. B 
	pop hl			;8a36	e1 	. 
	jr c,l8a3ch		;8a37	38 03 	8 . 
	ex de,hl			;8a39	eb 	. 
	sbc hl,de		;8a3a	ed 52 	. R 
l8a3ch:
	exx			;8a3c	d9 	. 
	ret			;8a3d	c9 	. 
	inc ix		;8a3e	dd 23 	. # 
	ld d,(ix+002h)		;8a40	dd 56 02 	. V . 
	ld e,(ix+003h)		;8a43	dd 5e 03 	. ^ . 
	ret			;8a46	c9 	. 
	call 0234ch		;8a47	cd 4c 23 	. L # 
	ld hl,(02a17h)		;8a4a	2a 17 2a 	* . * 
	push hl			;8a4d	e5 	. 
	res 7,d		;8a4e	cb ba 	. . 
	add hl,de			;8a50	19 	. 
	add hl,de			;8a51	19 	. 
	ld e,(hl)			;8a52	5e 	^ 
	inc hl			;8a53	23 	# 
	ld a,(hl)			;8a54	7e 	~ 
	and 03fh		;8a55	e6 3f 	. ? 
	ld d,a			;8a57	57 	W 
	ex (sp),hl			;8a58	e3 	. 
	push hl			;8a59	e5 	. 
	ex de,hl			;8a5a	eb 	. 
	ex (sp),hl			;8a5b	e3 	. 
	ld e,(hl)			;8a5c	5e 	^ 
	inc hl			;8a5d	23 	# 
	ld d,(hl)			;8a5e	56 	V 
	inc hl			;8a5f	23 	# 
	ex de,hl			;8a60	eb 	. 
	inc hl			;8a61	23 	# 
	add hl,hl			;8a62	29 	) 
	add hl,de			;8a63	19 	. 
	pop de			;8a64	d1 	. 
	add hl,de			;8a65	19 	. 
	ex de,hl			;8a66	eb 	. 
	pop hl			;8a67	e1 	. 
	ret			;8a68	c9 	. 
	ld hl,02ce5h		;8a69	21 e5 2c 	! . , 
	push hl			;8a6c	e5 	. 
	ld bc,02000h		;8a6d	01 00 20 	. .   
	call 02521h		;8a70	cd 21 25 	. ! % 
	pop hl			;8a73	e1 	. 
	ld a,(ix+000h)		;8a74	dd 7e 00 	. ~ . 
	dec a			;8a77	3d 	= 
	jr nz,l8a8fh		;8a78	20 15 	  . 
	ld a,(ix+001h)		;8a7a	dd 7e 01 	. ~ . 
	cp 037h		;8a7d	fe 37 	. 7 
	jr nz,l8a8fh		;8a7f	20 0e 	  . 
l8a81h:
	ld a,(ix+002h)		;8a81	dd 7e 02 	. ~ . 
	cp 0c0h		;8a84	fe c0 	. . 
	ld (hl),001h		;8a86	36 01 	6 . 
	ret nc			;8a88	d0 	. 
	inc ix		;8a89	dd 23 	. # 
	ld (hl),a			;8a8b	77 	w 
	inc hl			;8a8c	23 	# 
	jr l8a81h		;8a8d	18 f2 	. . 
l8a8fh:
	ld b,009h		;8a8f	06 09 	. . 
	bit 3,(ix+001h)		;8a91	dd cb 01 5e 	. . . ^ 
	call z,02517h		;8a95	cc 17 25 	. . % 
	jr z,l8aa4h		;8a98	28 0a 	( . 
	push hl			;8a9a	e5 	. 
	call 02353h		;8a9b	cd 53 23 	. S # 
	pop hl			;8a9e	e1 	. 
	ld b,009h		;8a9f	06 09 	. . 
	call 02514h		;8aa1	cd 14 25 	. . % 
l8aa4h:
	push hl			;8aa4	e5 	. 
	ld b,(ix+000h)		;8aa5	dd 46 00 	. F . 
	ld a,(ix+001h)		;8aa8	dd 7e 01 	. ~ . 
	and 0f0h		;8aab	e6 f0 	. . 
	ld c,a			;8aad	4f 	O 
	call 0255ch		;8aae	cd 5c 25 	. \ % 
	pop hl			;8ab1	e1 	. 
	jr z,l8abah		;8ab2	28 06 	( . 
	ld a,010h		;8ab4	3e 10 	> . 
	ld (01f3fh),a		;8ab6	32 3f 1f 	2 ? . 
	ret			;8ab9	c9 	. 
l8abah:
	ld (hl),001h		;8aba	36 01 	6 . 
	or a			;8abc	b7 	. 
	ret z			;8abd	c8 	. 
	cp 03ah		;8abe	fe 3a 	. : 
	jr c,l8ac8h		;8ac0	38 06 	8 . 
	cp 03eh		;8ac2	fe 3e 	. > 
	jr nc,l8ac8h		;8ac4	30 02 	0 . 
	ld d,02ch		;8ac6	16 2c 	. , 
l8ac8h:
	push de			;8ac8	d5 	. 
	ld de,02eb6h		;8ac9	11 b6 2e 	. . . 
	call 02509h		;8acc	cd 09 25 	. . % 
	ld b,005h		;8acf	06 05 	. . 
	call 02514h		;8ad1	cd 14 25 	. . % 
	pop de			;8ad4	d1 	. 
	ld (hl),001h		;8ad5	36 01 	6 . 
	inc hl			;8ad7	23 	# 
	bit 3,(ix+001h)		;8ad8	dd cb 01 5e 	. . . ^ 
	jr z,l8ae2h		;8adc	28 04 	( . 
	inc ix		;8ade	dd 23 	. # 
	inc ix		;8ae0	dd 23 	. # 
l8ae2h:
	push de			;8ae2	d5 	. 
	ld a,d			;8ae3	7a 	z 
	call 023fah		;8ae4	cd fa 23 	. . # 
	pop de			;8ae7	d1 	. 
	ld a,e			;8ae8	7b 	{ 
	or a			;8ae9	b7 	. 
	ret z			;8aea	c8 	. 
	ld (hl),02ch		;8aeb	36 2c 	6 , 
	inc hl			;8aed	23 	# 
	or a			;8aee	b7 	. 
	ret z			;8aef	c8 	. 
	cp 02ch		;8af0	fe 2c 	. , 
	jr nc,l8b12h		;8af2	30 1e 	0 . 
	ld de,02ff4h		;8af4	11 f4 2f 	. . / 
	call 02509h		;8af7	cd 09 25 	. . % 
	ld b,009h		;8afa	06 09 	. . 
l8afch:
	ld a,(de)			;8afc	1a 	. 
	and 07fh		;8afd	e6 7f 	.  
	ld (hl),a			;8aff	77 	w 
	dec b			;8b00	05 	. 
	jr nz,l8b0ah		;8b01	20 07 	  . 
	ld a,010h		;8b03	3e 10 	> . 
	ld (01f3fh),a		;8b05	32 3f 1f 	2 ? . 
	pop af			;8b08	f1 	. 
	ret			;8b09	c9 	. 
l8b0ah:
	ld a,(de)			;8b0a	1a 	. 
	and 080h		;8b0b	e6 80 	. . 
	inc hl			;8b0d	23 	# 
	inc de			;8b0e	13 	. 
	jr z,l8afch		;8b0f	28 eb 	( . 
	ret			;8b11	c9 	. 
l8b12h:
	push af			;8b12	f5 	. 
	cp 02dh		;8b13	fe 2d 	. - 
	jr c,l8b35h		;8b15	38 1e 	8 . 
	ld (hl),028h		;8b17	36 28 	6 ( 
	inc hl			;8b19	23 	# 
	cp 02eh		;8b1a	fe 2e 	. . 
	jr c,l8b35h		;8b1c	38 17 	8 . 
	ld (hl),069h		;8b1e	36 69 	6 i 
	inc hl			;8b20	23 	# 
	ld b,078h		;8b21	06 78 	. x 
	cp 02fh		;8b23	fe 2f 	. / 
	jr c,l8b29h		;8b25	38 02 	8 . 
	ld b,079h		;8b27	06 79 	. y 
l8b29h:
	ld (hl),b			;8b29	70 	p 
	inc hl			;8b2a	23 	# 
	ld a,(ix+002h)		;8b2b	dd 7e 02 	. ~ . 
	cp 02dh		;8b2e	fe 2d 	. - 
	jr z,l8b35h		;8b30	28 03 	( . 
	ld (hl),02bh		;8b32	36 2b 	6 + 
	inc hl			;8b34	23 	# 
l8b35h:
	ld a,(ix+002h)		;8b35	dd 7e 02 	. ~ . 
	cp 01fh		;8b38	fe 1f 	. . 
	jr z,l8b5ch		;8b3a	28 20 	(   
	cp 0c0h		;8b3c	fe c0 	. . 
	jr nc,l8b5ch		;8b3e	30 1c 	0 . 
	cp 080h		;8b40	fe 80 	. . 
	jr nc,l8b4ah		;8b42	30 06 	0 . 
	ld (hl),a			;8b44	77 	w 
	inc hl			;8b45	23 	# 
	inc ix		;8b46	dd 23 	. # 
	jr l8b35h		;8b48	18 eb 	. . 
l8b4ah:
	ld d,a			;8b4a	57 	W 
	ld e,(ix+003h)		;8b4b	dd 5e 03 	. ^ . 
	inc ix		;8b4e	dd 23 	. # 
	inc ix		;8b50	dd 23 	. # 
	push hl			;8b52	e5 	. 
	call 02356h		;8b53	cd 56 23 	. V # 
	pop hl			;8b56	e1 	. 
	call 02406h		;8b57	cd 06 24 	. . $ 
	jr l8b35h		;8b5a	18 d9 	. . 
l8b5ch:
	pop af			;8b5c	f1 	. 
	inc ix		;8b5d	dd 23 	. # 
	cp 02dh		;8b5f	fe 2d 	. - 
	ret c			;8b61	d8 	. 
	ld (hl),029h		;8b62	36 29 	6 ) 
	inc hl			;8b64	23 	# 
	ret			;8b65	c9 	. 
	ld hl,(024adh)		;8b66	2a ad 24 	* . $ 
	dec hl			;8b69	2b 	+ 
	ld a,(hl)			;8b6a	7e 	~ 
	cp 0c0h		;8b6b	fe c0 	. . 
	jr c,l8b77h		;8b6d	38 08 	8 . 
	and 03fh		;8b6f	e6 3f 	. ? 
	ld e,a			;8b71	5f 	_ 
	ld d,000h		;8b72	16 00 	. . 
	sbc hl,de		;8b74	ed 52 	. R 
	dec hl			;8b76	2b 	+ 
l8b77h:
	dec hl			;8b77	2b 	+ 
	ret			;8b78	c9 	. 
	ld hl,(024adh)		;8b79	2a ad 24 	* . $ 
	inc hl			;8b7c	23 	# 
	ld a,(hl)			;8b7d	7e 	~ 
	inc hl			;8b7e	23 	# 
	bit 3,a		;8b7f	cb 5f 	. _ 
	jr z,l8b87h		;8b81	28 04 	( . 
	inc hl			;8b83	23 	# 
	inc hl			;8b84	23 	# 
	jr l8b8ah		;8b85	18 03 	. . 
l8b87h:
	and 007h		;8b87	e6 07 	. . 
	ret z			;8b89	c8 	. 
l8b8ah:
	ld a,(hl)			;8b8a	7e 	~ 
	inc hl			;8b8b	23 	# 
	cp 0c0h		;8b8c	fe c0 	. . 
	ret nc			;8b8e	d0 	. 
	cp 080h		;8b8f	fe 80 	. . 
l8b91h:
	jr c,l8b8ah		;8b91	38 f7 	8 . 
	inc hl			;8b93	23 	# 
	jr l8b8ah		;8b94	18 f4 	. . 
	xor a			;8b96	af 	. 
	in a,(0feh)		;8b97	db fe 	. . 
	cpl			;8b99	2f 	/ 
	and 01fh		;8b9a	e6 1f 	. . 
	ret z			;8b9c	c8 	. 
	call 01dfch		;8b9d	cd fc 1d 	. . . 
	ld hl,03e68h		;8ba0	21 68 3e 	! h > 
	ld b,00dh		;8ba3	06 0d 	. . 
l8ba5h:
	call 02475h		;8ba5	cd 75 24 	. u $ 
	djnz l8ba5h		;8ba8	10 fb 	. . 
	ld a,010h		;8baa	3e 10 	> . 
l8bach:
	push af			;8bac	f5 	. 
	push hl			;8bad	e5 	. 
	push hl			;8bae	e5 	. 
	call 02830h		;8baf	cd 30 28 	. 0 ( 
	pop ix		;8bb2	dd e1 	. . 
	call 024cfh		;8bb4	cd cf 24 	. . $ 
	pop hl			;8bb7	e1 	. 
	call 02488h		;8bb8	cd 88 24 	. . $ 
	pop af			;8bbb	f1 	. 
	add a,008h		;8bbc	c6 08 	. . 
	cp 0a9h		;8bbe	fe a9 	. . 
	jr c,l8bach		;8bc0	38 ea 	8 . 
	ret			;8bc2	c9 	. 
	push ix		;8bc3	dd e5 	. . 
	call 02375h		;8bc5	cd 75 23 	. u # 
	pop ix		;8bc8	dd e1 	. . 
	call 02335h		;8bca	cd 35 23 	. 5 # 
	jr c,l8bd4h		;8bcd	38 05 	8 . 
	ld hl,02cedh		;8bcf	21 ed 2c 	! . , 
	ld (hl),003h		;8bd2	36 03 	6 . 
l8bd4h:
	ld hl,02984h		;8bd4	21 84 29 	! . ) 
	ld (02505h),hl		;8bd7	22 05 25 	" . % 
	ld hl,02ce5h		;8bda	21 e5 2c 	! . , 
	ld c,000h		;8bdd	0e 00 	. . 
l8bdfh:
	ld a,(hl)			;8bdf	7e 	~ 
	inc hl			;8be0	23 	# 
	dec a			;8be1	3d 	= 
	jr z,l8bdfh		;8be2	28 fb 	( . 
	inc a			;8be4	3c 	< 
	ret z			;8be5	c8 	. 
	cp 022h		;8be6	fe 22 	. " 
	jr nz,l8bedh		;8be8	20 03 	  . 
	inc c			;8bea	0c 	. 
	ld a,022h		;8beb	3e 22 	> " 
l8bedh:
	bit 0,c		;8bed	cb 41 	. A 
	jr nz,l8bf8h		;8bef	20 07 	  . 
	call 0296eh		;8bf1	cd 6e 29 	. n ) 
	jr nz,l8bf8h		;8bf4	20 02 	  . 
	and 0ffh		;8bf6	e6 ff 	. . 
l8bf8h:
	call 02984h		;8bf8	cd 84 29 	. . ) 
	jr l8bdfh		;8bfb	18 e2 	. . 
	push hl			;8bfd	e5 	. 
	ex de,hl			;8bfe	eb 	. 
	ld d,000h		;8bff	16 00 	. . 
	ld e,a			;8c01	5f 	_ 
	add hl,de			;8c02	19 	. 
	ld e,(hl)			;8c03	5e 	^ 
	add hl,de			;8c04	19 	. 
	ex de,hl			;8c05	eb 	. 
	pop hl			;8c06	e1 	. 
	ret			;8c07	c9 	. 
	call 02408h		;8c08	cd 08 24 	. . $ 
	ld c,020h		;8c0b	0e 20 	.   
	jr l8c15h		;8c0d	18 06 	. . 
	ld bc,03700h		;8c0f	01 00 37 	. . 7 
	ld hl,02d07h		;8c12	21 07 2d 	! . - 
l8c15h:
	ld (hl),c			;8c15	71 	q 
	inc hl			;8c16	23 	# 
	djnz l8c15h		;8c17	10 fc 	. . 
	ret			;8c19	c9 	. 
	ld b,000h		;8c1a	06 00 	. . 
	ld hl,02d3fh		;8c1c	21 3f 2d 	! ? - 
	call 027eeh		;8c1f	cd ee 27 	. . ' 
	cp 041h		;8c22	fe 41 	. A 
	jr c,l8c28h		;8c24	38 02 	8 . 
	set 3,d		;8c26	cb da 	. . 
l8c28h:
	ld (02d62h),de		;8c28	ed 53 62 2d 	. S b - 
	push af			;8c2c	f5 	. 
	ld a,e			;8c2d	7b 	{ 
	cp 003h		;8c2e	fe 03 	. . 
	jr nz,l8c38h		;8c30	20 06 	  . 
	ld a,d			;8c32	7a 	z 
	cp 037h		;8c33	fe 37 	. 7 
	jp z,022d8h		;8c35	ca d8 22 	. . " 
l8c38h:
	pop af			;8c38	f1 	. 
	ld ix,02d64h		;8c39	dd 21 64 2d 	. ! d - 
	ret c			;8c3d	d8 	. 
	call 02a55h		;8c3e	cd 55 2a 	. U * 
	ld ix,02d66h		;8c41	dd 21 66 2d 	. ! f - 
	set 7,h		;8c45	cb fc 	. . 
	ld (ix-002h),h		;8c47	dd 74 fe 	. t . 
	ld (ix-001h),l		;8c4a	dd 75 ff 	. u . 
	ld b,002h		;8c4d	06 02 	. . 
	ret			;8c4f	c9 	. 
	ld de,00352h		;8c50	11 52 03 	. R . 
	ld a,001h		;8c53	3e 01 	> . 
	bit 5,c		;8c55	cb 69 	. i 
	jr nz,l8c62h		;8c57	20 09 	  . 
	bit 4,c		;8c59	cb 61 	. a 
	jr z,l8c62h		;8c5b	28 05 	( . 
	dec a			;8c5d	3d 	= 
	res 4,c		;8c5e	cb a1 	. . 
	set 5,c		;8c60	cb e9 	. . 
l8c62h:
	ld (025b4h),a		;8c62	32 b4 25 	2 . % 
	ld hl,03796h		;8c65	21 96 37 	! . 7 
	exx			;8c68	d9 	. 
	ld b,00bh		;8c69	06 0b 	. . 
l8c6bh:
	exx			;8c6b	d9 	. 
	ld a,(hl)			;8c6c	7e 	~ 
	cp b			;8c6d	b8 	. 
	jr nz,l8c78h		;8c6e	20 08 	  . 
	inc hl			;8c70	23 	# 
	ld a,(hl)			;8c71	7e 	~ 
	dec hl			;8c72	2b 	+ 
	and 0f0h		;8c73	e6 f0 	. . 
	cp c			;8c75	b9 	. 
	jr z,l8c8eh		;8c76	28 16 	( . 
l8c78h:
	jr c,l8c7eh		;8c78	38 04 	8 . 
	sbc hl,de		;8c7a	ed 52 	. R 
	jr l8c7fh		;8c7c	18 01 	. . 
l8c7eh:
	add hl,de			;8c7e	19 	. 
l8c7fh:
	srl d		;8c7f	cb 3a 	. : 
	rr e		;8c81	cb 1b 	. . 
	jr nc,l8c88h		;8c83	30 03 	0 . 
	inc de			;8c85	13 	. 
	inc de			;8c86	13 	. 
	inc de			;8c87	13 	. 
l8c88h:
	exx			;8c88	d9 	. 
	djnz l8c6bh		;8c89	10 e0 	. . 
	inc b			;8c8b	04 	. 
	exx			;8c8c	d9 	. 
	ret			;8c8d	c9 	. 
l8c8eh:
	inc hl			;8c8e	23 	# 
	inc hl			;8c8f	23 	# 
	ld a,(hl)			;8c90	7e 	~ 
	inc hl			;8c91	23 	# 
	ld d,(hl)			;8c92	56 	V 
	inc hl			;8c93	23 	# 
	ld e,(hl)			;8c94	5e 	^ 
	srl a		;8c95	cb 3f 	. ? 
	ld b,003h		;8c97	06 03 	. . 
	rr d		;8c99	cb 1a 	. . 
	jr l8c9fh		;8c9b	18 02 	. . 
l8c9dh:
	srl d		;8c9d	cb 3a 	. : 
l8c9fh:
	rr e		;8c9f	cb 1b 	. . 
	djnz l8c9dh		;8ca1	10 fa 	. . 
	srl e		;8ca3	cb 3b 	. ; 
	srl e		;8ca5	cb 3b 	. ; 
	ld b,001h		;8ca7	06 01 	. . 
	dec b			;8ca9	05 	. 
	ret z			;8caa	c8 	. 
	push af			;8cab	f5 	. 
	ld a,e			;8cac	7b 	{ 
	inc a			;8cad	3c 	< 
	call 02703h		;8cae	cd 03 27 	. . ' 
	jr nz,l8cb4h		;8cb1	20 01 	  . 
	inc e			;8cb3	1c 	. 
l8cb4h:
	ld a,d			;8cb4	7a 	z 
	inc a			;8cb5	3c 	< 
	call 02703h		;8cb6	cd 03 27 	. . ' 
	jr nz,l8cbch		;8cb9	20 01 	  . 
	inc d			;8cbb	14 	. 
l8cbch:
	pop af			;8cbc	f1 	. 
	cp a			;8cbd	bf 	. 
	ret			;8cbe	c9 	. 
	ld hl,02d11h		;8cbf	21 11 2d 	! . - 
	ld b,028h		;8cc2	06 28 	. ( 
	ld c,001h		;8cc4	0e 01 	. . 
	xor a			;8cc6	af 	. 
l8cc7h:
	cp (hl)			;8cc7	be 	. 
	inc hl			;8cc8	23 	# 
	jr z,l8ccch		;8cc9	28 01 	( . 
	inc c			;8ccb	0c 	. 
l8ccch:
	djnz l8cc7h		;8ccc	10 f9 	. . 
	ld a,012h		;8cce	3e 12 	> . 
	cp c			;8cd0	b9 	. 
	jr c,l8ce2h		;8cd1	38 0f 	8 . 
	ret			;8cd3	c9 	. 
	cp 02ch		;8cd4	fe 2c 	. , 
	jr z,l8cdfh		;8cd6	28 07 	( . 
	inc de			;8cd8	13 	. 
	cp 02dh		;8cd9	fe 2d 	. - 
	jr z,l8cdfh		;8cdb	28 02 	( . 
	inc de			;8cdd	13 	. 
	inc de			;8cde	13 	. 
l8cdfh:
	call 026d2h		;8cdf	cd d2 26 	. . & 
l8ce2h:
	jp c,022c9h		;8ce2	da c9 22 	. . " 
	cp 02bh		;8ce5	fe 2b 	. + 
	jr z,l8cf0h		;8ce7	28 07 	( . 
	cp 02dh		;8ce9	fe 2d 	. - 
	jr nz,l8cf5h		;8ceb	20 08 	  . 
	call 02ba2h		;8ced	cd a2 2b 	. . + 
l8cf0h:
	call 026d2h		;8cf0	cd d2 26 	. . & 
	jr c,l8ce2h		;8cf3	38 ed 	8 . 
l8cf5h:
	cp 024h		;8cf5	fe 24 	. $ 
	jr nz,l8cfeh		;8cf7	20 05 	  . 
	call 026cfh		;8cf9	cd cf 26 	. . & 
	jr l8d31h		;8cfc	18 33 	. 3 
l8cfeh:
	ld c,a			;8cfe	4f 	O 
	or 020h		;8cff	f6 20 	.   
	call 0296eh		;8d01	cd 6e 29 	. n ) 
	jr nz,l8d2dh		;8d04	20 27 	  ' 
	push bc			;8d06	c5 	. 
	dec de			;8d07	1b 	. 
	push de			;8d08	d5 	. 
	push ix		;8d09	dd e5 	. . 
	ex de,hl			;8d0b	eb 	. 
	call 02a55h		;8d0c	cd 55 2a 	. U * 
	pop ix		;8d0f	dd e1 	. . 
	set 7,h		;8d11	cb fc 	. . 
	ld (ix+000h),h		;8d13	dd 74 00 	. t . 
	inc ix		;8d16	dd 23 	. # 
	ld (ix+000h),l		;8d18	dd 75 00 	. u . 
	inc ix		;8d1b	dd 23 	. # 
	pop bc			;8d1d	c1 	. 
	ld hl,(02d07h)		;8d1e	2a 07 2d 	* . - 
	ld h,000h		;8d21	26 00 	& . 
	add hl,bc			;8d23	09 	. 
	ex de,hl			;8d24	eb 	. 
	pop bc			;8d25	c1 	. 
	inc b			;8d26	04 	. 
	inc b			;8d27	04 	. 
	call 026d2h		;8d28	cd d2 26 	. . & 
	jr l8d31h		;8d2b	18 04 	. . 
l8d2dh:
	ld a,c			;8d2d	79 	y 
	call 02659h		;8d2e	cd 59 26 	. Y & 
l8d31h:
	ccf			;8d31	3f 	? 
	ret nc			;8d32	d0 	. 
	cp 02bh		;8d33	fe 2b 	. + 
	jr z,l8d48h		;8d35	28 11 	( . 
	cp 02dh		;8d37	fe 2d 	. - 
	jr z,l8d48h		;8d39	28 0d 	( . 
	cp 02ah		;8d3b	fe 2a 	. * 
	jr z,l8d48h		;8d3d	28 09 	( . 
	cp 02fh		;8d3f	fe 2f 	. / 
	jr z,l8d48h		;8d41	28 05 	( . 
	cp 03fh		;8d43	fe 3f 	. ? 
l8d45h:
	jp nz,022c9h		;8d45	c2 c9 22 	. . " 
l8d48h:
	call 026cfh		;8d48	cd cf 26 	. . & 
	jr l8ce2h		;8d4b	18 95 	. . 
	cp 022h		;8d4d	fe 22 	. " 
	jr z,l8d93h		;8d4f	28 42 	( B 
	ld c,00ah		;8d51	0e 0a 	. . 
	call 02966h		;8d53	cd 66 29 	. f ) 
	jr z,l8d6ch		;8d56	28 14 	( . 
	cp 025h		;8d58	fe 25 	. % 
	jr nz,l8d60h		;8d5a	20 04 	  . 
	ld c,002h		;8d5c	0e 02 	. . 
	jr l8d66h		;8d5e	18 06 	. . 
l8d60h:
	cp 023h		;8d60	fe 23 	. # 
	jr nz,l8d45h		;8d62	20 e1 	  . 
	ld c,010h		;8d64	0e 10 	. . 
l8d66h:
	call 026cfh		;8d66	cd cf 26 	. . & 
	jp c,022c9h		;8d69	da c9 22 	. . " 
l8d6ch:
	ld hl,00000h		;8d6c	21 00 00 	! . . 
l8d6fh:
	call 026e0h		;8d6f	cd e0 26 	. . & 
	ret nc			;8d72	d0 	. 
	push de			;8d73	d5 	. 
	push af			;8d74	f5 	. 
	ld a,c			;8d75	79 	y 
	dec a			;8d76	3d 	= 
	ld d,h			;8d77	54 	T 
	ld e,l			;8d78	5d 	] 
l8d79h:
	add hl,de			;8d79	19 	. 
l8d7ah:
	jp c,022c5h		;8d7a	da c5 22 	. . " 
	dec a			;8d7d	3d 	= 
	jr nz,l8d79h		;8d7e	20 f9 	  . 
	pop af			;8d80	f1 	. 
	cp c			;8d81	b9 	. 
	jp nc,022c5h		;8d82	d2 c5 22 	. . " 
	ld d,000h		;8d85	16 00 	. . 
	ld e,a			;8d87	5f 	_ 
	add hl,de			;8d88	19 	. 
	jr c,l8d7ah		;8d89	38 ef 	8 . 
	pop de			;8d8b	d1 	. 
	ex af,af'			;8d8c	08 	. 
	call 026cfh		;8d8d	cd cf 26 	. . & 
	ret c			;8d90	d8 	. 
	jr l8d6fh		;8d91	18 dc 	. . 
l8d93h:
	ld hl,00000h		;8d93	21 00 00 	! . . 
	call 026bah		;8d96	cd ba 26 	. . & 
	or a			;8d99	b7 	. 
	jr z,l8dach		;8d9a	28 10 	( . 
	ld l,a			;8d9c	6f 	o 
	call 026bah		;8d9d	cd ba 26 	. . & 
	or a			;8da0	b7 	. 
	jr z,l8dach		;8da1	28 09 	( . 
	ld h,l			;8da3	65 	e 
	ld l,a			;8da4	6f 	o 
	call 026bah		;8da5	cd ba 26 	. . & 
	or a			;8da8	b7 	. 
	jp nz,022d4h		;8da9	c2 d4 22 	. . " 
l8dach:
	jr l8dc1h		;8dac	18 13 	. . 
	call 026cfh		;8dae	cd cf 26 	. . & 
	or a			;8db1	b7 	. 
	jp z,022d4h		;8db2	ca d4 22 	. . " 
	cp 022h		;8db5	fe 22 	. " 
	jr z,l8dbbh		;8db7	28 02 	( . 
	and a			;8db9	a7 	. 
	ret			;8dba	c9 	. 
l8dbbh:
	ld a,(de)			;8dbb	1a 	. 
	cp 022h		;8dbc	fe 22 	. " 
	ld a,000h		;8dbe	3e 00 	> . 
	ret nz			;8dc0	c0 	. 
l8dc1h:
	ld a,022h		;8dc1	3e 22 	> " 
	call 02ba2h		;8dc3	cd a2 2b 	. . + 
	ld a,(de)			;8dc6	1a 	. 
	inc de			;8dc7	13 	. 
	cp 029h		;8dc8	fe 29 	. ) 
	jr z,l8dd2h		;8dca	28 06 	( . 
	cp 02ch		;8dcc	fe 2c 	. , 
	jr z,l8dd2h		;8dce	28 02 	( . 
	or a			;8dd0	b7 	. 
	ret nz			;8dd1	c0 	. 
l8dd2h:
	scf			;8dd2	37 	7 
	ret			;8dd3	c9 	. 
	push af			;8dd4	f5 	. 
	ex af,af'			;8dd5	08 	. 
	pop af			;8dd6	f1 	. 
	sub 030h		;8dd7	d6 30 	. 0 
	cp 00ah		;8dd9	fe 0a 	. . 
	ret c			;8ddb	d8 	. 
	sub 007h		;8ddc	d6 07 	. . 
	cp 00ah		;8dde	fe 0a 	. . 
	jr c,l8df4h		;8de0	38 12 	8 . 
	cp 010h		;8de2	fe 10 	. . 
	ret c			;8de4	d8 	. 
	sub 020h		;8de5	d6 20 	.   
	cp 00ah		;8de7	fe 0a 	. . 
	jr c,l8df4h		;8de9	38 09 	8 . 
	cp 010h		;8deb	fe 10 	. . 
	jr nc,l8df4h		;8ded	30 05 	0 . 
	ex af,af'			;8def	08 	. 
	sub 020h		;8df0	d6 20 	.   
	ex af,af'			;8df2	08 	. 
	ret c			;8df3	d8 	. 
l8df4h:
	ex af,af'			;8df4	08 	. 
	and a			;8df5	a7 	. 
	ret			;8df6	c9 	. 
	cp 01ah		;8df7	fe 1a 	. . 
	jr z,l8e0ah		;8df9	28 0f 	( . 
	cp 01ch		;8dfb	fe 1c 	. . 
	jr z,l8e0ah		;8dfd	28 0b 	( . 
	cp 01eh		;8dff	fe 1e 	. . 
	jr z,l8e0ah		;8e01	28 07 	( . 
	cp 02ah		;8e03	fe 2a 	. * 
	jr z,l8e0ah		;8e05	28 03 	( . 
	cp 02fh		;8e07	fe 2f 	. / 
	ret nz			;8e09	c0 	. 
l8e0ah:
	dec a			;8e0a	3d 	= 
	push hl			;8e0b	e5 	. 
	ld hl,02201h		;8e0c	21 01 22 	! . " 
	ld (hl),001h		;8e0f	36 01 	6 . 
	pop hl			;8e11	e1 	. 
	cp a			;8e12	bf 	. 
	ret			;8e13	c9 	. 
	push hl			;8e14	e5 	. 
	call 0275fh		;8e15	cd 5f 27 	. _ ' 
	pop hl			;8e18	e1 	. 
	ld a,b			;8e19	78 	x 
	or a			;8e1a	b7 	. 
	ret z			;8e1b	c8 	. 
	cp 005h		;8e1c	fe 05 	. . 
	jr nc,l8e2ch		;8e1e	30 0c 	0 . 
	push hl			;8e20	e5 	. 
	ld hl,0278fh		;8e21	21 8f 27 	! . ' 
	call 02799h		;8e24	cd 99 27 	. . ' 
	pop hl			;8e27	e1 	. 
	call 02767h		;8e28	cd 67 27 	. g ' 
	ret nc			;8e2b	d0 	. 
l8e2ch:
	ld a,(hl)			;8e2c	7e 	~ 
	cp 028h		;8e2d	fe 28 	. ( 
	ld a,02ch		;8e2f	3e 2c 	> , 
	ret nz			;8e31	c0 	. 
	inc hl			;8e32	23 	# 
	ld a,(hl)			;8e33	7e 	~ 
	cp 069h		;8e34	fe 69 	. i 
	jr nz,l8e4eh		;8e36	20 16 	  . 
	inc hl			;8e38	23 	# 
	ld a,(hl)			;8e39	7e 	~ 
	cp 078h		;8e3a	fe 78 	. x 
	ld b,02eh		;8e3c	06 2e 	. . 
	jr z,l8e46h		;8e3e	28 06 	( . 
	cp 079h		;8e40	fe 79 	. y 
	ld b,02fh		;8e42	06 2f 	. / 
	jr nz,l8e4eh		;8e44	20 08 	  . 
l8e46h:
	inc hl			;8e46	23 	# 
	ld a,(hl)			;8e47	7e 	~ 
	cp 02bh		;8e48	fe 2b 	. + 
	jr z,l8e51h		;8e4a	28 05 	( . 
	cp 02dh		;8e4c	fe 2d 	. - 
l8e4eh:
	ld a,02dh		;8e4e	3e 2d 	> - 
	ret nz			;8e50	c0 	. 
l8e51h:
	ld a,b			;8e51	78 	x 
	ret			;8e52	c9 	. 
	xor a			;8e53	af 	. 
	ld b,a			;8e54	47 	G 
l8e55h:
	cp (hl)			;8e55	be 	. 
	ret z			;8e56	c8 	. 
	inc hl			;8e57	23 	# 
	inc b			;8e58	04 	. 
	jr l8e55h		;8e59	18 fa 	. . 
l8e5bh:
	push hl			;8e5b	e5 	. 
l8e5ch:
	ld a,(de)			;8e5c	1a 	. 
	and 07fh		;8e5d	e6 7f 	.  
	cp (hl)			;8e5f	be 	. 
	jr nz,l8e6dh		;8e60	20 0b 	  . 
	ld a,(de)			;8e62	1a 	. 
	inc hl			;8e63	23 	# 
	inc de			;8e64	13 	. 
	and 080h		;8e65	e6 80 	. . 
	jr z,l8e5ch		;8e67	28 f3 	( . 
	pop hl			;8e69	e1 	. 
	xor a			;8e6a	af 	. 
	ld a,c			;8e6b	79 	y 
	ret			;8e6c	c9 	. 
l8e6dh:
	pop hl			;8e6d	e1 	. 
l8e6eh:
	ld a,(de)			;8e6e	1a 	. 
	and 080h		;8e6f	e6 80 	. . 
	inc de			;8e71	13 	. 
	jr z,l8e6eh		;8e72	28 fa 	( . 
	inc c			;8e74	0c 	. 
	djnz l8e5bh		;8e75	10 e4 	. . 
	scf			;8e77	37 	7 
	ret			;8e78	c9 	. 
	or (hl)			;8e79	b6 	. 
	ld l,001h		;8e7a	2e 01 	. . 
	ld bc,0020ch		;8e7c	01 0c 02 	. . . 
	add hl,hl			;8e7f	29 	) 
	ld c,017h		;8e80	0e 17 	. . 
	scf			;8e82	37 	7 
	call p,00c2fh		;8e83	f4 2f 0c 	. / . 
	add hl,bc			;8e86	09 	. 
	rrca			;8e87	0f 	. 
	dec d			;8e88	15 	. 
	ld (bc),a			;8e89	02 	. 
	inc h			;8e8a	24 	$ 
	ld b,026h		;8e8b	06 26 	. & 
	ld a,b			;8e8d	78 	x 
	add a,a			;8e8e	87 	. 
	ld c,a			;8e8f	4f 	O 
	xor a			;8e90	af 	. 
	ld b,a			;8e91	47 	G 
	push hl			;8e92	e5 	. 
	add hl,bc			;8e93	09 	. 
	ld b,(hl)			;8e94	46 	F 
	inc hl			;8e95	23 	# 
	ld c,(hl)			;8e96	4e 	N 
	pop hl			;8e97	e1 	. 
	ld e,(hl)			;8e98	5e 	^ 
	inc hl			;8e99	23 	# 
	ld d,(hl)			;8e9a	56 	V 
	ld h,a			;8e9b	67 	g 
	ld l,c			;8e9c	69 	i 
	add hl,de			;8e9d	19 	. 
	ld e,(hl)			;8e9e	5e 	^ 
	ld d,a			;8e9f	57 	W 
	add hl,de			;8ea0	19 	. 
	ex de,hl			;8ea1	eb 	. 
	ret			;8ea2	c9 	. 
	ld b,020h		;8ea3	06 20 	.   
	jr l8eadh		;8ea5	18 06 	. . 
	ld b,02ch		;8ea7	06 2c 	. , 
	jr l8eadh		;8ea9	18 02 	. . 
	ld b,000h		;8eab	06 00 	. . 
l8eadh:
	call 027eeh		;8ead	cd ee 27 	. . ' 
	cp 022h		;8eb0	fe 22 	. " 
	jr z,l8ed9h		;8eb2	28 25 	( % 
	cp 027h		;8eb4	fe 27 	. ' 
	jr z,l8ed9h		;8eb6	28 21 	( ! 
l8eb8h:
	cp b			;8eb8	b8 	. 
	ret z			;8eb9	c8 	. 
	cp 020h		;8eba	fe 20 	.   
	inc hl			;8ebc	23 	# 
	jr z,l8eadh		;8ebd	28 ee 	( . 
	dec hl			;8ebf	2b 	+ 
	or a			;8ec0	b7 	. 
	jr nz,l8ec5h		;8ec1	20 02 	  . 
	inc a			;8ec3	3c 	< 
	ret			;8ec4	c9 	. 
l8ec5h:
	inc hl			;8ec5	23 	# 
	set 5,a		;8ec6	cb ef 	. . 
	ld (de),a			;8ec8	12 	. 
	inc de			;8ec9	13 	. 
	dec c			;8eca	0d 	. 
	jr nz,l8eadh		;8ecb	20 e0 	  . 
	jr l8edeh		;8ecd	18 0f 	. . 
l8ecfh:
	call 027edh		;8ecf	cd ed 27 	. . ' 
	or a			;8ed2	b7 	. 
	jr z,l8eb8h		;8ed3	28 e3 	( . 
	cp 022h		;8ed5	fe 22 	. " 
	jr z,l8eb8h		;8ed7	28 df 	( . 
l8ed9h:
	ld (de),a			;8ed9	12 	. 
	inc de			;8eda	13 	. 
	dec c			;8edb	0d 	. 
	jr nz,l8ecfh		;8edc	20 f1 	  . 
l8edeh:
	jp 022c9h		;8ede	c3 c9 22 	. . " 
	inc hl			;8ee1	23 	# 
	ld a,(hl)			;8ee2	7e 	~ 
	cp 001h		;8ee3	fe 01 	. . 
	ret nz			;8ee5	c0 	. 
	inc hl			;8ee6	23 	# 
	ld a,(hl)			;8ee7	7e 	~ 
	ret			;8ee8	c9 	. 
l8ee9h:
	call 027eeh		;8ee9	cd ee 27 	. . ' 
	cp 020h		;8eec	fe 20 	.   
	ret nz			;8eee	c0 	. 
	inc hl			;8eef	23 	# 
	jr l8ee9h		;8ef0	18 f7 	. . 
	ld hl,02fafh		;8ef2	21 af 2f 	! . / 
	ld (02991h),hl		;8ef5	22 91 29 	" . ) 
	ld hl,050e0h		;8ef8	21 e0 50 	! . P 
	call 02835h		;8efb	cd 35 28 	. 5 ( 
	ld hl,02d3eh		;8efe	21 3e 2d 	! > - 
l8f01h:
	inc hl			;8f01	23 	# 
	ld a,(029c8h)		;8f02	3a c8 29 	: . ) 
	and 01fh		;8f05	e6 1f 	. . 
	ld (020edh),a		;8f07	32 ed 20 	2 .   
	ld a,(hl)			;8f0a	7e 	~ 
	dec a			;8f0b	3d 	= 
	jr z,l8f15h		;8f0c	28 07 	( . 
	inc a			;8f0e	3c 	< 
	ret z			;8f0f	c8 	. 
	call 0298ah		;8f10	cd 8a 29 	. . ) 
	jr l8f01h		;8f13	18 ec 	. . 
l8f15h:
	ld (0207ch),hl		;8f15	22 7c 20 	" |   
	push hl			;8f18	e5 	. 
	ld a,(028aeh)		;8f19	3a ae 28 	: . ( 
	add a,0cch		;8f1c	c6 cc 	. . 
	call 029a9h		;8f1e	cd a9 29 	. . ) 
	pop hl			;8f21	e1 	. 
	jr l8f01h		;8f22	18 dd 	. . 
	ld c,000h		;8f24	0e 00 	. . 
	call 022b0h		;8f26	cd b0 22 	. . " 
	ld (029c8h),hl		;8f29	22 c8 29 	" . ) 
	ld b,008h		;8f2c	06 08 	. . 
l8f2eh:
	push hl			;8f2e	e5 	. 
	ld c,020h		;8f2f	0e 20 	.   
l8f31h:
	ld (hl),000h		;8f31	36 00 	6 . 
	inc l			;8f33	2c 	, 
	dec c			;8f34	0d 	. 
	jr nz,l8f31h		;8f35	20 fa 	  . 
	pop hl			;8f37	e1 	. 
	inc h			;8f38	24 	$ 
	djnz l8f2eh		;8f39	10 f3 	. . 
	ret			;8f3b	c9 	. 
	exx			;8f3c	d9 	. 
	call 02879h		;8f3d	cd 79 28 	. y ( 
	exx			;8f40	d9 	. 
	call 0296eh		;8f41	cd 6e 29 	. n ) 
	ret nz			;8f44	c0 	. 
	or 020h		;8f45	f6 20 	.   
	ret			;8f47	c9 	. 
	ld hl,00000h		;8f48	21 00 00 	! . . 
	inc hl			;8f4b	23 	# 
	ld (02855h),hl		;8f4c	22 55 28 	" U ( 
	ld a,h			;8f4f	7c 	| 
	cp 005h		;8f50	fe 05 	. . 
	jr nz,l8f6dh		;8f52	20 19 	  . 
	ld a,00dh		;8f54	3e 0d 	> . 
	jr l8fc3h		;8f56	18 6b 	. k 
l8f58h:
	ld h,002h		;8f58	26 02 	& . 
l8f5ah:
	call 028eeh		;8f5a	cd ee 28 	. . ( 
	jr nz,l8f67h		;8f5d	20 08 	  . 
	dec hl			;8f5f	2b 	+ 
	inc h			;8f60	24 	$ 
	dec h			;8f61	25 	% 
	jr nz,l8f5ah		;8f62	20 f6 	  . 
	call 028e8h		;8f64	cd e8 28 	. . ( 
l8f67h:
	ld hl,00000h		;8f67	21 00 00 	! . . 
	ld (02855h),hl		;8f6a	22 55 28 	" U ( 
l8f6dh:
	call 028eeh		;8f6d	cd ee 28 	. . ( 
	jr z,l8f58h		;8f70	28 e6 	( . 
	ld b,000h		;8f72	06 00 	. . 
	ld c,e			;8f74	4b 	K 
	ld a,e			;8f75	7b 	{ 
	ld (028c5h),a		;8f76	32 c5 28 	2 . ( 
	ld hl,00204h		;8f79	21 04 02 	! . . 
	ld a,d			;8f7c	7a 	z 
	cp 019h		;8f7d	fe 19 	. . 
	jr z,l8ff7h		;8f7f	28 76 	( v 
	add hl,bc			;8f81	09 	. 
	ld a,(hl)			;8f82	7e 	~ 
	cp 020h		;8f83	fe 20 	.   
	ld b,a			;8f85	47 	G 
	jr c,l8fafh		;8f86	38 27 	8 ' 
	ld a,d			;8f88	7a 	z 
	cp 028h		;8f89	fe 28 	. ( 
	ld a,b			;8f8b	78 	x 
	set 5,a		;8f8c	cb ef 	. . 
	jr nz,l8fa0h		;8f8e	20 10 	  . 
	call 02966h		;8f90	cd 66 29 	. f ) 
	jr nz,l8f99h		;8f93	20 04 	  . 
	sub 02dh		;8f95	d6 2d 	. - 
	jr l8fafh		;8f97	18 16 	. . 
l8f99h:
	call 0296eh		;8f99	cd 6e 29 	. n ) 
	jr nz,l8fa0h		;8f9c	20 02 	  . 
	res 5,a		;8f9e	cb af 	. . 
l8fa0h:
	ld b,a			;8fa0	47 	G 
	ld a,000h		;8fa1	3e 00 	> . 
	or a			;8fa3	b7 	. 
	ld a,b			;8fa4	78 	x 
	jr z,l8fafh		;8fa5	28 08 	( . 
	call 0296eh		;8fa7	cd 6e 29 	. n ) 
	jr nz,l8fafh		;8faa	20 03 	  . 
	ld a,020h		;8fac	3e 20 	>   
	xor b			;8fae	a8 	. 
l8fafh:
	ld b,a			;8faf	47 	G 
	or a			;8fb0	b7 	. 
	jr z,l8f6dh		;8fb1	28 ba 	( . 
	cp 080h		;8fb3	fe 80 	. . 
	jr z,l8f6dh		;8fb5	28 b6 	( . 
	ld b,a			;8fb7	47 	G 
	ld a,022h		;8fb8	3e 22 	> " 
	cp 022h		;8fba	fe 22 	. " 
	ld (028c7h),a		;8fbc	32 c7 28 	2 . ( 
	ld a,b			;8fbf	78 	x 
	jp z,02854h		;8fc0	ca 54 28 	. T ( 
l8fc3h:
	push af			;8fc3	f5 	. 
	call 0294fh		;8fc4	cd 4f 29 	. O ) 
	pop af			;8fc7	f1 	. 
	ld h,014h		;8fc8	26 14 	& . 
l8fcah:
	dec hl			;8fca	2b 	+ 
	inc h			;8fcb	24 	$ 
	dec h			;8fcc	25 	% 
	jr nz,l8fcah		;8fcd	20 fb 	  . 
	bit 7,a		;8fcf	cb 7f 	.  
	ld (02861h),a		;8fd1	32 61 28 	2 a ( 
	ret z			;8fd4	c8 	. 
	ld h,04eh		;8fd5	26 4e 	& N 
l8fd7h:
	dec hl			;8fd7	2b 	+ 
	inc h			;8fd8	24 	$ 
	dec h			;8fd9	25 	% 
	jr nz,l8fd7h		;8fda	20 fb 	  . 
	ld hl,028c7h		;8fdc	21 c7 28 	! . ( 
	ld (hl),000h		;8fdf	36 00 	6 . 
	ret			;8fe1	c9 	. 
	push hl			;8fe2	e5 	. 
	call 0028eh		;8fe3	cd 8e 02 	. . . 
	pop hl			;8fe6	e1 	. 
	jr z,l8febh		;8fe7	28 02 	( . 
	xor a			;8fe9	af 	. 
	ret			;8fea	c9 	. 
l8febh:
	ld a,e			;8feb	7b 	{ 
	inc e			;8fec	1c 	. 
	ret z			;8fed	c8 	. 
	inc d			;8fee	14 	. 
	ret nz			;8fef	c0 	. 
	ld a,e			;8ff0	7b 	{ 
	sub 019h		;8ff1	d6 19 	. . 
	ret z			;8ff3	c8 	. 
	sub 00fh		;8ff4	d6 0f 	. . 
	ret			;8ff6	c9 	. 
l8ff7h:
	ex de,hl			;8ff7	eb 	. 
	ld a,c			;8ff8	79 	y 
	cp 01bh		;8ff9	fe 1b 	. . 
	jr z,l9014h		;8ffb	28 17 	( . 
	ld hl,02d3fh		;8ffd	21 3f 2d 	! ? - 
	ld a,(hl)			;9000	7e 	~ 
	dec a			;9001	3d 	= 
	jr nz,l9014h		;9002	20 10 	  . 
	inc hl			;9004	23 	# 
	or (hl)			;9005	b6 	. 
	jr nz,l9014h		;9006	20 0c 	  . 
	ex de,hl			;9008	eb 	. 
	add hl,bc			;9009	09 	. 
	ld a,(hl)			;900a	7e 	~ 
	call 0296eh		;900b	cd 6e 29 	. n ) 
	jr nz,l9014h		;900e	20 04 	  . 
	set 7,a		;9010	cb ff 	. . 
	jr l8fafh		;9012	18 9b 	. . 
l9014h:
	ld hl,02926h		;9014	21 26 29 	! & ) 
	add hl,bc			;9017	09 	. 
	ld a,(hl)			;9018	7e 	~ 
	jr l8fafh		;9019	18 94 	. . 
	ld hl,(05b5eh)		;901b	2a 5e 5b 	* ^ [ 
	ld h,025h		;901e	26 25 	& % 
	ld a,07dh		;9020	3e 7d 	> } 
	cpl			;9022	2f 	/ 
	inc l			;9023	2c 	, 
	dec l			;9024	2d 	- 
	ld e,l			;9025	5d 	] 
	daa			;9026	27 	' 
	inc h			;9027	24 	$ 
	inc a			;9028	3c 	< 
	ld a,e			;9029	7b 	{ 
	ccf			;902a	3f 	? 
	ld l,02bh		;902b	2e 2b 	. + 
	ld a,a			;902d	7f 	 
	jr z,l9053h		;902e	28 23 	( # 
	nop			;9030	00 	. 
	ld e,h			;9031	5c 	\ 
	ld h,b			;9032	60 	` 
	nop			;9033	00 	. 
	dec a			;9034	3d 	= 
	dec sp			;9035	3b 	; 
	add hl,hl			;9036	29 	) 
	ld b,b			;9037	40 	@ 
	inc d			;9038	14 	. 
	ld a,h			;9039	7c 	| 
	ld a,(00d20h)		;903a	3a 20 0d 	:   . 
	ld (0215fh),hl		;903d	22 5f 21 	" _ ! 
	dec d			;9040	15 	. 
	ld a,(hl)			;9041	7e 	~ 
	nop			;9042	00 	. 
	ld e,01eh		;9043	1e 1e 	. . 
	jr l9049h		;9045	18 02 	. . 
	ld e,000h		;9047	1e 00 	. . 
l9049h:
	ld hl,0012ch		;9049	21 2c 01 	! , . 
	ld a,017h		;904c	3e 17 	> . 
l904eh:
	ld b,e			;904e	43 	C 
	xor 010h		;904f	ee 10 	. . 
l9051h:
	out (0feh),a		;9051	d3 fe 	. . 
l9053h:
	djnz l9051h		;9053	10 fc 	. . 
	dec hl			;9055	2b 	+ 
	inc h			;9056	24 	$ 
	dec h			;9057	25 	% 
	jr nz,l904eh		;9058	20 f4 	  . 
	cp 030h		;905a	fe 30 	. 0 
	ret c			;905c	d8 	. 
	cp 039h		;905d	fe 39 	. 9 
	ret nc			;905f	d0 	. 
	cp a			;9060	bf 	. 
	ret			;9061	c9 	. 
	cp 041h		;9062	fe 41 	. A 
	ret c			;9064	d8 	. 
	cp 07ah		;9065	fe 7a 	. z 
	ret nc			;9067	d0 	. 
	cp 05bh		;9068	fe 5b 	. [ 
	jr c,l906fh		;906a	38 03 	8 . 
	cp 061h		;906c	fe 61 	. a 
	ret c			;906e	d8 	. 
l906fh:
	cp a			;906f	bf 	. 
	ret			;9070	c9 	. 
	ld a,020h		;9071	3e 20 	>   
	jr l9078h		;9073	18 03 	. . 
	ld a,(hl)			;9075	7e 	~ 
	and 07fh		;9076	e6 7f 	.  
l9078h:
	exx			;9078	d9 	. 
	call 029bfh		;9079	cd bf 29 	. . ) 
	exx			;907c	d9 	. 
	ret			;907d	c9 	. 
	cp 080h		;907e	fe 80 	. . 
	jr c,l909bh		;9080	38 19 	8 . 
	push hl			;9082	e5 	. 
	push de			;9083	d5 	. 
	ld hl,l8d6fh		;9084	21 6f 8d 	! o . 
	ld d,000h		;9087	16 00 	. . 
	ld e,a			;9089	5f 	_ 
	add hl,de			;908a	19 	. 
	ld e,(hl)			;908b	5e 	^ 
	add hl,de			;908c	19 	. 
l908dh:
	ld a,(hl)			;908d	7e 	~ 
	inc hl			;908e	23 	# 
	push af			;908f	f5 	. 
	call 029a7h		;9090	cd a7 29 	. . ) 
	pop af			;9093	f1 	. 
	rlca			;9094	07 	. 
	jr nc,l908dh		;9095	30 f6 	0 . 
	pop de			;9097	d1 	. 
	pop hl			;9098	e1 	. 
	ld a,020h		;9099	3e 20 	>   
l909bh:
	res 7,a		;909b	cb bf 	. . 
	exx			;909d	d9 	. 
	call 029bfh		;909e	cd bf 29 	. . ) 
	ld a,h			;90a1	7c 	| 
	add a,00ah		;90a2	c6 0a 	. . 
	cp 05ah		;90a4	fe 5a 	. Z 
	jr z,l90aeh		;90a6	28 06 	( . 
l90a8h:
	add a,007h		;90a8	c6 07 	. . 
	cp 058h		;90aa	fe 58 	. X 
	jr c,l90a8h		;90ac	38 fa 	8 . 
l90aeh:
	ld h,a			;90ae	67 	g 
	ld (hl),038h		;90af	36 38 	6 8 
	exx			;90b1	d9 	. 
	ret			;90b2	c9 	. 
	add a,a			;90b3	87 	. 
	ld h,00fh		;90b4	26 0f 	& . 
	ld l,a			;90b6	6f 	o 
	sbc a,a			;90b7	9f 	. 
	ld c,a			;90b8	4f 	O 
	add hl,hl			;90b9	29 	) 
	add hl,hl			;90ba	29 	) 
	ld de,04020h		;90bb	11 20 40 	.   @ 
	push de			;90be	d5 	. 
	ld b,008h		;90bf	06 08 	. . 
l90c1h:
	ld a,(hl)			;90c1	7e 	~ 
	nop			;90c2	00 	. 
	or (hl)			;90c3	b6 	. 
	xor c			;90c4	a9 	. 
	ld (de),a			;90c5	12 	. 
	inc hl			;90c6	23 	# 
	inc d			;90c7	14 	. 
	djnz l90c1h		;90c8	10 f7 	. . 
	pop hl			;90ca	e1 	. 
	push hl			;90cb	e5 	. 
	inc l			;90cc	2c 	, 
	jr nz,l90d9h		;90cd	20 0a 	  . 
	ld a,h			;90cf	7c 	| 
	add a,008h		;90d0	c6 08 	. . 
	cp 058h		;90d2	fe 58 	. X 
	jr nz,l90d8h		;90d4	20 02 	  . 
	ld a,040h		;90d6	3e 40 	> @ 
l90d8h:
	ld h,a			;90d8	67 	g 
l90d9h:
	ld (029c8h),hl		;90d9	22 c8 29 	" . ) 
	pop hl			;90dc	e1 	. 
	ret			;90dd	c9 	. 
	ld de,02d08h		;90de	11 08 2d 	. . - 
	ld b,000h		;90e1	06 00 	. . 
l90e3h:
	call 027eeh		;90e3	cd ee 27 	. . ' 
	call 02966h		;90e6	cd 66 29 	. f ) 
	jr z,l90f6h		;90e9	28 0b 	( . 
	res 5,a		;90eb	cb af 	. . 
	cp 05fh		;90ed	fe 5f 	. _ 
	jr z,l90f6h		;90ef	28 05 	( . 
	call 0296eh		;90f1	cd 6e 29 	. n ) 
	jr nz,l9102h		;90f4	20 0c 	  . 
l90f6h:
	ld (de),a			;90f6	12 	. 
	inc de			;90f7	13 	. 
	inc hl			;90f8	23 	# 
	inc b			;90f9	04 	. 
	ld a,b			;90fa	78 	x 
	cp 009h		;90fb	fe 09 	. . 
	jr c,l90e3h		;90fd	38 e4 	8 . 
	jp 022c9h		;90ff	c3 c9 22 	. . " 
l9102h:
	ld a,b			;9102	78 	x 
	ld (02d07h),a		;9103	32 07 2d 	2 . - 
	dec de			;9106	1b 	. 
	ex de,hl			;9107	eb 	. 
	set 7,(hl)		;9108	cb fe 	. . 
	ld hl,03e76h		;910a	21 76 3e 	! v > 
	ld e,(hl)			;910d	5e 	^ 
	inc hl			;910e	23 	# 
	ld d,(hl)			;910f	56 	V 
	inc hl			;9110	23 	# 
	push de			;9111	d5 	. 
	ex de,hl			;9112	eb 	. 
	inc hl			;9113	23 	# 
	add hl,hl			;9114	29 	) 
	add hl,de			;9115	19 	. 
	ld (02a37h),hl		;9116	22 37 2a 	" 7 * 
	dec hl			;9119	2b 	+ 
	dec hl			;911a	2b 	+ 
	ld (02a63h),hl		;911b	22 63 2a 	" c * 
	pop bc			;911e	c1 	. 
	jr l9143h		;911f	18 22 	. " 
l9121h:
	push bc			;9121	c5 	. 
	dec hl			;9122	2b 	+ 
	ld a,(hl)			;9123	7e 	~ 
	and 03fh		;9124	e6 3f 	. ? 
	ld d,a			;9126	57 	W 
	dec hl			;9127	2b 	+ 
	ld e,(hl)			;9128	5e 	^ 
	push hl			;9129	e5 	. 
	ld hl,00000h		;912a	21 00 00 	! . . 
	add hl,de			;912d	19 	. 
	ld de,02d07h		;912e	11 07 2d 	. . - 
	ld a,(de)			;9131	1a 	. 
	ld b,a			;9132	47 	G 
	inc de			;9133	13 	. 
l9134h:
	ld a,(de)			;9134	1a 	. 
	cp (hl)			;9135	be 	. 
	jr nz,l9140h		;9136	20 08 	  . 
	inc hl			;9138	23 	# 
	inc de			;9139	13 	. 
	djnz l9134h		;913a	10 f8 	. . 
	pop af			;913c	f1 	. 
	pop hl			;913d	e1 	. 
	xor a			;913e	af 	. 
	ret			;913f	c9 	. 
l9140h:
	pop hl			;9140	e1 	. 
	pop bc			;9141	c1 	. 
	dec bc			;9142	0b 	. 
l9143h:
	ld a,b			;9143	78 	x 
	or c			;9144	b1 	. 
	jr nz,l9121h		;9145	20 da 	  . 
	scf			;9147	37 	7 
	ret			;9148	c9 	. 
	call 029eah		;9149	cd ea 29 	. . ) 
	ret nc			;914c	d0 	. 
	ld hl,03e78h		;914d	21 78 3e 	! x > 
	ld bc,0000ch		;9150	01 0c 00 	. . . 
	call 022a8h		;9153	cd a8 22 	. . " 
	ld de,00000h		;9156	11 00 00 	. . . 
	xor a			;9159	af 	. 
	sbc hl,de		;915a	ed 52 	. R 
	ld b,h			;915c	44 	D 
	ld c,l			;915d	4d 	M 
	ld h,d			;915e	62 	b 
	ld l,e			;915f	6b 	k 
	inc de			;9160	13 	. 
	inc de			;9161	13 	. 
	call 02b2ch		;9162	cd 2c 2b 	. , + 
	ld hl,02a5ah		;9165	21 5a 2a 	! Z * 
	call 02bb8h		;9168	cd b8 2b 	. . + 
	ld hl,(02a17h)		;916b	2a 17 2a 	* . * 
	ld c,(hl)			;916e	4e 	N 
	inc hl			;916f	23 	# 
	ld b,(hl)			;9170	46 	F 
	ld hl,(02a37h)		;9171	2a 37 2a 	* 7 * 
	jr l91a0h		;9174	18 2a 	. * 
l9176h:
	pop hl			;9176	e1 	. 
	pop af			;9177	f1 	. 
	jr l91a4h		;9178	18 2a 	. * 
l917ah:
	push bc			;917a	c5 	. 
	push hl			;917b	e5 	. 
	inc hl			;917c	23 	# 
	ld de,02d08h		;917d	11 08 2d 	. . - 
l9180h:
	inc hl			;9180	23 	# 
	ld c,(hl)			;9181	4e 	N 
	res 7,c		;9182	cb b9 	. . 
	ld a,(de)			;9184	1a 	. 
	and 07fh		;9185	e6 7f 	.  
	cp c			;9187	b9 	. 
	jr c,l9176h		;9188	38 ec 	8 . 
	jr nz,l9198h		;918a	20 0c 	  . 
	ld a,(de)			;918c	1a 	. 
	and 080h		;918d	e6 80 	. . 
	jr nz,l9176h		;918f	20 e5 	  . 
	bit 7,(hl)		;9191	cb 7e 	. ~ 
	jr nz,l9198h		;9193	20 03 	  . 
	inc de			;9195	13 	. 
	jr l9180h		;9196	18 e8 	. . 
l9198h:
	bit 7,(hl)		;9198	cb 7e 	. ~ 
	inc hl			;919a	23 	# 
	jr z,l9198h		;919b	28 fb 	( . 
	pop af			;919d	f1 	. 
	pop bc			;919e	c1 	. 
	dec bc			;919f	0b 	. 
l91a0h:
	ld a,b			;91a0	78 	x 
	or c			;91a1	b1 	. 
	jr nz,l917ah		;91a2	20 d6 	  . 
l91a4h:
	push hl			;91a4	e5 	. 
	ex de,hl			;91a5	eb 	. 
	ld hl,(02a5ah)		;91a6	2a 5a 2a 	* Z * 
	xor a			;91a9	af 	. 
	sbc hl,de		;91aa	ed 52 	. R 
	ex de,hl			;91ac	eb 	. 
	push hl			;91ad	e5 	. 
	ld b,a			;91ae	47 	G 
	ld a,(02d07h)		;91af	3a 07 2d 	: . - 
	add a,002h		;91b2	c6 02 	. . 
	ld c,a			;91b4	4f 	O 
	push bc			;91b5	c5 	. 
	push hl			;91b6	e5 	. 
	add hl,bc			;91b7	09 	. 
	ld b,d			;91b8	42 	B 
	ld c,e			;91b9	4b 	K 
	ex de,hl			;91ba	eb 	. 
	pop hl			;91bb	e1 	. 
	call 02b2ch		;91bc	cd 2c 2b 	. , + 
	pop bc			;91bf	c1 	. 
	ld hl,02a5ah		;91c0	21 5a 2a 	! Z * 
	call 02bc0h		;91c3	cd c0 2b 	. . + 
	pop de			;91c6	d1 	. 
	ld hl,02d06h		;91c7	21 06 2d 	! . - 
	ld (hl),000h		;91ca	36 00 	6 . 
	push bc			;91cc	c5 	. 
	call 02b2ch		;91cd	cd 2c 2b 	. , + 
	ld hl,(02a17h)		;91d0	2a 17 2a 	* . * 
	call 02bbdh		;91d3	cd bd 2b 	. . + 
	pop bc			;91d6	c1 	. 
	dec de			;91d7	1b 	. 
	ex de,hl			;91d8	eb 	. 
	ex (sp),hl			;91d9	e3 	. 
	ld de,(02a37h)		;91da	ed 5b 37 2a 	. [ 7 * 
	xor a			;91de	af 	. 
	sbc hl,de		;91df	ed 52 	. R 
	ex de,hl			;91e1	eb 	. 
	inc hl			;91e2	23 	# 
	inc hl			;91e3	23 	# 
	ld (02a37h),hl		;91e4	22 37 2a 	" 7 * 
	dec hl			;91e7	2b 	+ 
	dec hl			;91e8	2b 	+ 
	ld ix,(02a17h)		;91e9	dd 2a 17 2a 	. * . * 
	ex (sp),hl			;91ed	e3 	. 
	jr l9201h		;91ee	18 11 	. . 
l91f0h:
	call 0181bh		;91f0	cd 1b 18 	. . . 
	sbc hl,de		;91f3	ed 52 	. R 
	jr c,l91ffh		;91f5	38 08 	8 . 
	push de			;91f7	d5 	. 
	push ix		;91f8	dd e5 	. . 
	pop hl			;91fa	e1 	. 
	call 02bc0h		;91fb	cd c0 2b 	. . + 
	pop de			;91fe	d1 	. 
l91ffh:
	ex (sp),hl			;91ff	e3 	. 
	dec hl			;9200	2b 	+ 
l9201h:
	ld a,h			;9201	7c 	| 
	or l			;9202	b5 	. 
	ex (sp),hl			;9203	e3 	. 
	jr nz,l91f0h		;9204	20 ea 	  . 
	pop hl			;9206	e1 	. 
	ld (ix+002h),e		;9207	dd 73 02 	. s . 
	ld (ix+003h),d		;920a	dd 72 03 	. r . 
	ld hl,(02a17h)		;920d	2a 17 2a 	* . * 
	ld a,(hl)			;9210	7e 	~ 
	inc hl			;9211	23 	# 
	ld h,(hl)			;9212	66 	f 
	ld l,a			;9213	6f 	o 
	ret			;9214	c9 	. 
	push hl			;9215	e5 	. 
	ld hl,(02a5ah)		;9216	2a 5a 2a 	* Z * 
	and a			;9219	a7 	. 
	sbc hl,de		;921a	ed 52 	. R 
	ld b,h			;921c	44 	D 
	ld c,l			;921d	4d 	M 
	ex de,hl			;921e	eb 	. 
	pop de			;921f	d1 	. 
	ld a,b			;9220	78 	x 
	or c			;9221	b1 	. 
	ret z			;9222	c8 	. 
	push hl			;9223	e5 	. 
	xor a			;9224	af 	. 
	sbc hl,de		;9225	ed 52 	. R 
	pop hl			;9227	e1 	. 
	jr c,l922dh		;9228	38 03 	8 . 
	ldir		;922a	ed b0 	. . 
	ret			;922c	c9 	. 
l922dh:
	add hl,bc			;922d	09 	. 
	dec hl			;922e	2b 	+ 
	ex de,hl			;922f	eb 	. 
	add hl,bc			;9230	09 	. 
	dec hl			;9231	2b 	+ 
	ex de,hl			;9232	eb 	. 
	lddr		;9233	ed b8 	. . 
	ret			;9235	c9 	. 
	ld c,000h		;9236	0e 00 	. . 
	ld ix,02d07h		;9238	dd 21 07 2d 	. ! . - 
	ld a,000h		;923c	3e 00 	> . 
	or a			;923e	b7 	. 
	jr z,l925ah		;923f	28 19 	( . 
	ld (ix+000h),023h		;9241	dd 36 00 23 	. 6 . # 
	inc ix		;9245	dd 23 	. # 
	ld de,01000h		;9247	11 00 10 	. . . 
	call 02b81h		;924a	cd 81 2b 	. . + 
	ld d,001h		;924d	16 01 	. . 
	call 02b81h		;924f	cd 81 2b 	. . + 
	ld de,00010h		;9252	11 10 00 	. . . 
	call 02b81h		;9255	cd 81 2b 	. . + 
	jr l9271h		;9258	18 17 	. . 
l925ah:
	ld de,02710h		;925a	11 10 27 	. . ' 
	call 02b81h		;925d	cd 81 2b 	. . + 
	ld de,003e8h		;9260	11 e8 03 	. . . 
	call 02b81h		;9263	cd 81 2b 	. . + 
	ld de,00064h		;9266	11 64 00 	. d . 
	call 02b81h		;9269	cd 81 2b 	. . + 
	ld e,00ah		;926c	1e 0a 	. . 
	call 02b81h		;926e	cd 81 2b 	. . + 
l9271h:
	ld e,001h		;9271	1e 01 	. . 
	ld c,000h		;9273	0e 00 	. . 
	ld a,0ffh		;9275	3e ff 	> . 
l9277h:
	inc a			;9277	3c 	< 
	and a			;9278	a7 	. 
	sbc hl,de		;9279	ed 52 	. R 
	jr nc,l9277h		;927b	30 fa 	0 . 
	add hl,de			;927d	19 	. 
	bit 0,c		;927e	cb 41 	. A 
	jr z,l9284h		;9280	28 02 	( . 
	or a			;9282	b7 	. 
	ret z			;9283	c8 	. 
l9284h:
	res 0,c		;9284	cb 81 	. . 
	add a,030h		;9286	c6 30 	. 0 
	cp 03ah		;9288	fe 3a 	. : 
	jr c,l928eh		;928a	38 02 	8 . 
	add a,007h		;928c	c6 07 	. . 
l928eh:
	call 02ba3h		;928e	cd a3 2b 	. . + 
	ld (ix+000h),000h		;9291	dd 36 00 00 	. 6 . . 
	ret			;9295	c9 	. 
	inc b			;9296	04 	. 
	ld (ix+000h),a		;9297	dd 77 00 	. w . 
	inc ix		;929a	dd 23 	. # 
	ret			;929c	c9 	. 
	push hl			;929d	e5 	. 
	ld a,(hl)			;929e	7e 	~ 
	inc hl			;929f	23 	# 
	ld h,(hl)			;92a0	66 	f 
	ld l,a			;92a1	6f 	o 
	ld de,03e7eh		;92a2	11 7e 3e 	. ~ > 
	and a			;92a5	a7 	. 
	sbc hl,de		;92a6	ed 52 	. R 
	pop hl			;92a8	e1 	. 
	ret c			;92a9	d8 	. 
	jr l92b4h		;92aa	18 08 	. . 
	ld bc,00002h		;92ac	01 02 00 	. . . 
	jr l92b4h		;92af	18 03 	. . 
	ld bc,00001h		;92b1	01 01 00 	. . . 
l92b4h:
	ld e,(hl)			;92b4	5e 	^ 
	inc hl			;92b5	23 	# 
	ld d,(hl)			;92b6	56 	V 
	ex de,hl			;92b7	eb 	. 
	add hl,bc			;92b8	09 	. 
l92b9h:
	ex de,hl			;92b9	eb 	. 
	ld (hl),d			;92ba	72 	r 
	dec hl			;92bb	2b 	+ 
	ld (hl),e			;92bc	73 	s 
	ret			;92bd	c9 	. 
	push hl			;92be	e5 	. 
	ld (02c1fh),hl		;92bf	22 1f 2c 	" . , 
	push bc			;92c2	c5 	. 
l92c3h:
	call 02488h		;92c3	cd 88 24 	. . $ 
	dec bc			;92c6	0b 	. 
	ld a,b			;92c7	78 	x 
	or c			;92c8	b1 	. 
	jr nz,l92c3h		;92c9	20 f8 	  . 
	pop bc			;92cb	c1 	. 
	pop de			;92cc	d1 	. 
	push hl			;92cd	e5 	. 
	and a			;92ce	a7 	. 
	sbc hl,de		;92cf	ed 52 	. R 
	ld b,h			;92d1	44 	D 
	ld c,l			;92d2	4d 	M 
	pop hl			;92d3	e1 	. 
	push bc			;92d4	c5 	. 
	push de			;92d5	d5 	. 
	push hl			;92d6	e5 	. 
	ld hl,(02a5ah)		;92d7	2a 5a 2a 	* Z * 
	and a			;92da	a7 	. 
	pop de			;92db	d1 	. 
	sbc hl,de		;92dc	ed 52 	. R 
	ex de,hl			;92de	eb 	. 
	ld b,d			;92df	42 	B 
	ld c,e			;92e0	4b 	K 
	pop de			;92e1	d1 	. 
	call 02b2ch		;92e2	cd 2c 2b 	. , + 
	pop bc			;92e5	c1 	. 
	push bc			;92e6	c5 	. 
l92e7h:
	xor a			;92e7	af 	. 
	ld (de),a			;92e8	12 	. 
	inc de			;92e9	13 	. 
	dec bc			;92ea	0b 	. 
	ld a,b			;92eb	78 	x 
	or c			;92ec	b1 	. 
	jr nz,l92e7h		;92ed	20 f8 	  . 
	pop bc			;92ef	c1 	. 
	ld hl,02328h		;92f0	21 28 23 	! ( # 
	call 02c1ah		;92f3	cd 1a 2c 	. . , 
	ld hl,0232bh		;92f6	21 2b 23 	! + # 
	call 02c1ah		;92f9	cd 1a 2c 	. . , 
	ld hl,02a5ah		;92fc	21 5a 2a 	! Z * 
	call 02c11h		;92ff	cd 11 2c 	. . , 
	ld hl,02a17h		;9302	21 17 2a 	! . * 
l9305h:
	ld e,(hl)			;9305	5e 	^ 
	inc hl			;9306	23 	# 
	ld d,(hl)			;9307	56 	V 
	ex de,hl			;9308	eb 	. 
	and a			;9309	a7 	. 
	sbc hl,bc		;930a	ed 42 	. B 
	jr l92b9h		;930c	18 ab 	. . 
	push hl			;930e	e5 	. 
	ld e,(hl)			;930f	5e 	^ 
	inc hl			;9310	23 	# 
	ld d,(hl)			;9311	56 	V 
	ld hl,l9c28h		;9312	21 28 9c 	! ( . 
	and a			;9315	a7 	. 
	sbc hl,de		;9316	ed 52 	. R 
	pop hl			;9318	e1 	. 
	ret nc			;9319	d0 	. 
	jr l9305h		;931a	18 e9 	. . 
	xor a			;931c	af 	. 
	ld (0205fh),a		;931d	32 5f 20 	2 _   
	call 018f6h		;9320	cd f6 18 	. . . 
	call 01a11h		;9323	cd 11 1a 	. . . 
	ld a,00ah		;9326	3e 0a 	> . 
	call 022f4h		;9328	cd f4 22 	. . " 
	ld a,013h		;932b	3e 13 	> . 
	ld (029c8h),a		;932d	32 c8 29 	2 . ) 
	ld a,(0205fh)		;9330	3a 5f 20 	: _   
	or a			;9333	b7 	. 
	ld a,04fh		;9334	3e 4f 	> O 
	jr nz,l933ah		;9336	20 02 	  . 
	ld a,049h		;9338	3e 49 	> I 
l933ah:
	call 02984h		;933a	cd 84 29 	. . ) 
	ld hl,(02a5ah)		;933d	2a 5a 2a 	* Z * 
	call 02c52h		;9340	cd 52 2c 	. R , 
	ld hl,(01b86h)		;9343	2a 86 1b 	* . . 
	call 0297dh		;9346	cd 7d 29 	. } ) 
	call 02b42h		;9349	cd 42 2b 	. B + 
	ld hl,02d07h		;934c	21 07 2d 	! . - 
l934fh:
	ld a,(hl)			;934f	7e 	~ 
	or a			;9350	b7 	. 
	ret z			;9351	c8 	. 
	call 02981h		;9352	cd 81 29 	. . ) 
	inc hl			;9355	23 	# 
	jr l934fh		;9356	18 f7 	. . 
	push hl			;9358	e5 	. 
	push de			;9359	d5 	. 
	ld de,03e68h		;935a	11 68 3e 	. h > 
	and a			;935d	a7 	. 
	sbc hl,de		;935e	ed 52 	. R 
	pop de			;9360	d1 	. 
	pop hl			;9361	e1 	. 
	ret			;9362	c9 	. 
	push hl			;9363	e5 	. 
	push de			;9364	d5 	. 
	ld de,0000ch		;9365	11 0c 00 	. . . 
	add hl,de			;9368	19 	. 
	ld de,(02a17h)		;9369	ed 5b 17 2a 	. [ . * 
	and a			;936d	a7 	. 
	sbc hl,de		;936e	ed 52 	. R 
	pop de			;9370	d1 	. 
	pop hl			;9371	e1 	. 
	ret			;9372	c9 	. 
	call 02327h		;9373	cd 27 23 	. ' # 
	push hl			;9376	e5 	. 
	push de			;9377	d5 	. 
	ld bc,(024adh)		;9378	ed 4b ad 24 	. K . $ 
	and a			;937c	a7 	. 
	sbc hl,bc		;937d	ed 42 	. B 
	jr nc,l9386h		;937f	30 05 	0 . 
	ex de,hl			;9381	eb 	. 
	ccf			;9382	3f 	? 
	sbc hl,bc		;9383	ed 42 	. B 
	ccf			;9385	3f 	? 
l9386h:
	pop hl			;9386	e1 	. 
	pop de			;9387	d1 	. 
	ret c			;9388	d8 	. 
	push bc			;9389	c5 	. 
	call 02488h		;938a	cd 88 24 	. . $ 
	sbc hl,de		;938d	ed 52 	. R 
	ld b,h			;938f	44 	D 
	ld c,l			;9390	4d 	M 
	pop hl			;9391	e1 	. 
	ld (02bafh),hl		;9392	22 af 2b 	" . + 
	ex de,hl			;9395	eb 	. 
	push hl			;9396	e5 	. 
	sbc hl,de		;9397	ed 52 	. R 
	pop hl			;9399	e1 	. 
	jr c,l939dh		;939a	38 01 	8 . 
	add hl,bc			;939c	09 	. 
l939dh:
	ex de,hl			;939d	eb 	. 
	jr l93a2h		;939e	18 02 	. . 
	ld b,000h		;93a0	06 00 	. . 
l93a2h:
	push de			;93a2	d5 	. 
	push hl			;93a3	e5 	. 
	call 022a8h		;93a4	cd a8 22 	. . " 
	push bc			;93a7	c5 	. 
	push bc			;93a8	c5 	. 
	ex de,hl			;93a9	eb 	. 
	ld hl,(02a5ah)		;93aa	2a 5a 2a 	* Z * 
	and a			;93ad	a7 	. 
	sbc hl,de		;93ae	ed 52 	. R 
	ex (sp),hl			;93b0	e3 	. 
	ex de,hl			;93b1	eb 	. 
	push hl			;93b2	e5 	. 
	add hl,bc			;93b3	09 	. 
	pop de			;93b4	d1 	. 
	ex de,hl			;93b5	eb 	. 
	pop bc			;93b6	c1 	. 
	call 02b2ch		;93b7	cd 2c 2b 	. , + 
	pop bc			;93ba	c1 	. 
	ld hl,02a5ah		;93bb	21 5a 2a 	! Z * 
	call 02bc0h		;93be	cd c0 2b 	. . + 
	ld hl,02a17h		;93c1	21 17 2a 	! . * 
	call 02bc0h		;93c4	cd c0 2b 	. . + 
	ld hl,02328h		;93c7	21 28 23 	! ( # 
	call 02ba9h		;93ca	cd a9 2b 	. . + 
	ld hl,0232bh		;93cd	21 2b 23 	! + # 
	call 02ba9h		;93d0	cd a9 2b 	. . + 
	pop de			;93d3	d1 	. 
	pop hl			;93d4	e1 	. 
	defb 0edh,0b0h,0c9h		;93d5	ed b0 c9 	. . . 

; BLOCK 'data_93d8' (start 0x93d8 end 0xa574)
data_93d8_start:
	defb 000h		;93d8	00 	. 
	defb 020h		;93d9	20 	  
	defb 020h		;93da	20 	  
	defb 020h		;93db	20 	  
	defb 020h		;93dc	20 	  
	defb 020h		;93dd	20 	  
	defb 020h		;93de	20 	  
	defb 020h		;93df	20 	  
	defb 020h		;93e0	20 	  
	defb 020h		;93e1	20 	  
	defb 001h		;93e2	01 	. 
	defb 000h		;93e3	00 	. 
	defb 000h		;93e4	00 	. 
	defb 000h		;93e5	00 	. 
	defb 000h		;93e6	00 	. 
	defb 000h		;93e7	00 	. 
	defb 000h		;93e8	00 	. 
	defb 000h		;93e9	00 	. 
	defb 000h		;93ea	00 	. 
	defb 000h		;93eb	00 	. 
	defb 000h		;93ec	00 	. 
	defb 000h		;93ed	00 	. 
	defb 000h		;93ee	00 	. 
	defb 000h		;93ef	00 	. 
	defb 000h		;93f0	00 	. 
	defb 000h		;93f1	00 	. 
	defb 000h		;93f2	00 	. 
	defb 000h		;93f3	00 	. 
	defb 000h		;93f4	00 	. 
	defb 000h		;93f5	00 	. 
	defb 000h		;93f6	00 	. 
	defb 000h		;93f7	00 	. 
	defb 000h		;93f8	00 	. 
	defb 000h		;93f9	00 	. 
	defb 000h		;93fa	00 	. 
	defb 036h		;93fb	36 	6 
	defb 035h		;93fc	35 	5 
	defb 035h		;93fd	35 	5 
	defb 033h		;93fe	33 	3 
	defb 035h		;93ff	35 	5 
	defb 000h		;9400	00 	. 
	defb 000h		;9401	00 	. 
	defb 000h		;9402	00 	. 
	defb 000h		;9403	00 	. 
l9404h:
	defb 000h		;9404	00 	. 
	defb 000h		;9405	00 	. 
	defb 000h		;9406	00 	. 
	defb 000h		;9407	00 	. 
	defb 000h		;9408	00 	. 
	defb 000h		;9409	00 	. 
	defb 000h		;940a	00 	. 
	defb 000h		;940b	00 	. 
	defb 000h		;940c	00 	. 
	defb 000h		;940d	00 	. 
	defb 000h		;940e	00 	. 
	defb 000h		;940f	00 	. 
	defb 000h		;9410	00 	. 
	defb 000h		;9411	00 	. 
	defb 000h		;9412	00 	. 
	defb 000h		;9413	00 	. 
	defb 000h		;9414	00 	. 
	defb 000h		;9415	00 	. 
	defb 000h		;9416	00 	. 
	defb 000h		;9417	00 	. 
	defb 000h		;9418	00 	. 
	defb 000h		;9419	00 	. 
	defb 000h		;941a	00 	. 
	defb 000h		;941b	00 	. 
	defb 000h		;941c	00 	. 
	defb 000h		;941d	00 	. 
	defb 000h		;941e	00 	. 
	defb 000h		;941f	00 	. 
	defb 000h		;9420	00 	. 
	defb 000h		;9421	00 	. 
	defb 000h		;9422	00 	. 
	defb 000h		;9423	00 	. 
	defb 000h		;9424	00 	. 
	defb 000h		;9425	00 	. 
	defb 000h		;9426	00 	. 
	defb 000h		;9427	00 	. 
	defb 000h		;9428	00 	. 
	defb 000h		;9429	00 	. 
	defb 000h		;942a	00 	. 
	defb 000h		;942b	00 	. 
	defb 000h		;942c	00 	. 
	defb 000h		;942d	00 	. 
	defb 000h		;942e	00 	. 
	defb 000h		;942f	00 	. 
	defb 000h		;9430	00 	. 
	defb 000h		;9431	00 	. 
	defb 080h		;9432	80 	. 
	defb 0c2h		;9433	c2 	. 
	defb 001h		;9434	01 	. 
	defb 000h		;9435	00 	. 
	defb 000h		;9436	00 	. 
	defb 000h		;9437	00 	. 
	defb 000h		;9438	00 	. 
	defb 000h		;9439	00 	. 
	defb 000h		;943a	00 	. 
	defb 000h		;943b	00 	. 
	defb 000h		;943c	00 	. 
	defb 000h		;943d	00 	. 
	defb 000h		;943e	00 	. 
	defb 000h		;943f	00 	. 
	defb 000h		;9440	00 	. 
	defb 000h		;9441	00 	. 
	defb 000h		;9442	00 	. 
	defb 000h		;9443	00 	. 
	defb 000h		;9444	00 	. 
	defb 000h		;9445	00 	. 
	defb 000h		;9446	00 	. 
	defb 000h		;9447	00 	. 
	defb 000h		;9448	00 	. 
	defb 000h		;9449	00 	. 
	defb 000h		;944a	00 	. 
	defb 000h		;944b	00 	. 
	defb 000h		;944c	00 	. 
	defb 000h		;944d	00 	. 
	defb 000h		;944e	00 	. 
	defb 000h		;944f	00 	. 
	defb 000h		;9450	00 	. 
	defb 000h		;9451	00 	. 
	defb 000h		;9452	00 	. 
	defb 000h		;9453	00 	. 
	defb 000h		;9454	00 	. 
	defb 000h		;9455	00 	. 
	defb 000h		;9456	00 	. 
	defb 000h		;9457	00 	. 
	defb 000h		;9458	00 	. 
	defb 000h		;9459	00 	. 
	defb 000h		;945a	00 	. 
	defb 000h		;945b	00 	. 
	defb 000h		;945c	00 	. 
	defb 000h		;945d	00 	. 
	defb 000h		;945e	00 	. 
	defb 000h		;945f	00 	. 
	defb 000h		;9460	00 	. 
	defb 000h		;9461	00 	. 
	defb 000h		;9462	00 	. 
	defb 000h		;9463	00 	. 
	defb 000h		;9464	00 	. 
	defb 000h		;9465	00 	. 
	defb 000h		;9466	00 	. 
	defb 000h		;9467	00 	. 
	defb 000h		;9468	00 	. 
	defb 000h		;9469	00 	. 
	defb 000h		;946a	00 	. 
	defb 000h		;946b	00 	. 
	defb 000h		;946c	00 	. 
	defb 000h		;946d	00 	. 
	defb 000h		;946e	00 	. 
	defb 000h		;946f	00 	. 
	defb 000h		;9470	00 	. 
	defb 000h		;9471	00 	. 
	defb 000h		;9472	00 	. 
	defb 000h		;9473	00 	. 
	defb 000h		;9474	00 	. 
	defb 000h		;9475	00 	. 
	defb 000h		;9476	00 	. 
	defb 000h		;9477	00 	. 
	defb 000h		;9478	00 	. 
	defb 000h		;9479	00 	. 
	defb 000h		;947a	00 	. 
	defb 000h		;947b	00 	. 
	defb 000h		;947c	00 	. 
	defb 000h		;947d	00 	. 
	defb 000h		;947e	00 	. 
	defb 000h		;947f	00 	. 
	defb 000h		;9480	00 	. 
	defb 000h		;9481	00 	. 
	defb 000h		;9482	00 	. 
	defb 000h		;9483	00 	. 
	defb 000h		;9484	00 	. 
	defb 000h		;9485	00 	. 
	defb 000h		;9486	00 	. 
	defb 000h		;9487	00 	. 
	defb 000h		;9488	00 	. 
	defb 000h		;9489	00 	. 
	defb 000h		;948a	00 	. 
	defb 000h		;948b	00 	. 
	defb 000h		;948c	00 	. 
	defb 000h		;948d	00 	. 
	defb 002h		;948e	02 	. 
	defb 0c2h		;948f	c2 	. 
	defb 001h		;9490	01 	. 
	defb 000h		;9491	00 	. 
	defb 000h		;9492	00 	. 
	defb 000h		;9493	00 	. 
	defb 000h		;9494	00 	. 
	defb 000h		;9495	00 	. 
	defb 000h		;9496	00 	. 
	defb 000h		;9497	00 	. 
	defb 000h		;9498	00 	. 
	defb 000h		;9499	00 	. 
	defb 000h		;949a	00 	. 
	defb 000h		;949b	00 	. 
	defb 000h		;949c	00 	. 
	defb 000h		;949d	00 	. 
	defb 000h		;949e	00 	. 
	defb 000h		;949f	00 	. 
	defb 000h		;94a0	00 	. 
	defb 000h		;94a1	00 	. 
	defb 000h		;94a2	00 	. 
	defb 000h		;94a3	00 	. 
	defb 000h		;94a4	00 	. 
	defb 000h		;94a5	00 	. 
	defb 000h		;94a6	00 	. 
	defb 000h		;94a7	00 	. 
	defb 000h		;94a8	00 	. 
	defb 000h		;94a9	00 	. 
	defb 000h		;94aa	00 	. 
	defb 000h		;94ab	00 	. 
	defb 000h		;94ac	00 	. 
	defb 000h		;94ad	00 	. 
	defb 000h		;94ae	00 	. 
	defb 000h		;94af	00 	. 
	defb 000h		;94b0	00 	. 
	defb 000h		;94b1	00 	. 
	defb 000h		;94b2	00 	. 
	defb 000h		;94b3	00 	. 
	defb 000h		;94b4	00 	. 
	defb 000h		;94b5	00 	. 
	defb 000h		;94b6	00 	. 
	defb 09fh		;94b7	9f 	. 
	defb 050h		;94b8	50 	P 
	defb 06dh		;94b9	6d 	m 
	defb 087h		;94ba	87 	. 
	defb 02eh		;94bb	2e 	. 
	defb 06fh		;94bc	6f 	o 
	defb 023h		;94bd	23 	# 
	defb 06eh		;94be	6e 	n 
	defb 02ah		;94bf	2a 	* 
	defb 05dh		;94c0	5d 	] 
	defb 0d0h		;94c1	d0 	. 
	defb 001h		;94c2	01 	. 
	defb 09ch		;94c3	9c 	. 
	defb 05eh		;94c4	5e 	^ 
	defb 0e4h		;94c5	e4 	. 
	defb 050h		;94c6	50 	P 
	defb 06dh		;94c7	6d 	m 
	defb 087h		;94c8	87 	. 
	defb 019h		;94c9	19 	. 
	defb 040h		;94ca	40 	@ 
	defb 01fh		;94cb	1f 	. 
	defb 040h		;94cc	40 	@ 
	defb 048h		;94cd	48 	H 
	defb 087h		;94ce	87 	. 
	defb 021h		;94cf	21 	! 
	defb 08ah		;94d0	8a 	. 
	defb 003h		;94d1	03 	. 
	defb 07dh		;94d2	7d 	} 
	defb 0cfh		;94d3	cf 	. 
	defb 07ch		;94d4	7c 	| 
	defb 080h		;94d5	80 	. 
	defb 042h		;94d6	42 	B 
	defb 061h		;94d7	61 	a 
	defb 064h		;94d8	64 	d 
	defb 020h		;94d9	20 	  
	defb 06dh		;94da	6d 	m 
	defb 06eh		;94db	6e 	n 
	defb 065h		;94dc	65 	e 
	defb 06dh		;94dd	6d 	m 
	defb 06fh		;94de	6f 	o 
	defb 06eh		;94df	6e 	n 
	defb 069h		;94e0	69 	i 
	defb 0e3h		;94e1	e3 	. 
	defb 042h		;94e2	42 	B 
	defb 061h		;94e3	61 	a 
	defb 064h		;94e4	64 	d 
	defb 020h		;94e5	20 	  
	defb 06fh		;94e6	6f 	o 
	defb 070h		;94e7	70 	p 
	defb 065h		;94e8	65 	e 
	defb 072h		;94e9	72 	r 
	defb 061h		;94ea	61 	a 
	defb 06eh		;94eb	6e 	n 
	defb 0e4h		;94ec	e4 	. 
	defb 042h		;94ed	42 	B 
	defb 069h		;94ee	69 	i 
	defb 067h		;94ef	67 	g 
	defb 020h		;94f0	20 	  
	defb 06eh		;94f1	6e 	n 
	defb 075h		;94f2	75 	u 
	defb 06dh		;94f3	6d 	m 
	defb 062h		;94f4	62 	b 
	defb 065h		;94f5	65 	e 
	defb 0f2h		;94f6	f2 	. 
	defb 053h		;94f7	53 	S 
	defb 079h		;94f8	79 	y 
	defb 06eh		;94f9	6e 	n 
	defb 074h		;94fa	74 	t 
	defb 061h		;94fb	61 	a 
	defb 078h		;94fc	78 	x 
	defb 020h		;94fd	20 	  
	defb 068h		;94fe	68 	h 
	defb 06fh		;94ff	6f 	o 
	defb 072h		;9500	72 	r 
	defb 072h		;9501	72 	r 
	defb 06fh		;9502	6f 	o 
	defb 0f2h		;9503	f2 	. 
	defb 042h		;9504	42 	B 
	defb 061h		;9505	61 	a 
	defb 064h		;9506	64 	d 
	defb 020h		;9507	20 	  
	defb 073h		;9508	73 	s 
	defb 074h		;9509	74 	t 
	defb 072h		;950a	72 	r 
	defb 069h		;950b	69 	i 
	defb 06eh		;950c	6e 	n 
	defb 0e7h		;950d	e7 	. 
	defb 042h		;950e	42 	B 
	defb 061h		;950f	61 	a 
	defb 064h		;9510	64 	d 
	defb 020h		;9511	20 	  
	defb 069h		;9512	69 	i 
	defb 06eh		;9513	6e 	n 
	defb 073h		;9514	73 	s 
	defb 074h		;9515	74 	t 
	defb 072h		;9516	72 	r 
	defb 075h		;9517	75 	u 
	defb 063h		;9518	63 	c 
	defb 074h		;9519	74 	t 
	defb 069h		;951a	69 	i 
	defb 06fh		;951b	6f 	o 
	defb 0eeh		;951c	ee 	. 
	defb 04dh		;951d	4d 	M 
	defb 065h		;951e	65 	e 
	defb 06dh		;951f	6d 	m 
	defb 06fh		;9520	6f 	o 
	defb 072h		;9521	72 	r 
	defb 079h		;9522	79 	y 
	defb 020h		;9523	20 	  
	defb 066h		;9524	66 	f 
	defb 075h		;9525	75 	u 
	defb 06ch		;9526	6c 	l 
	defb 0ech		;9527	ec 	. 
	defb 042h		;9528	42 	B 
	defb 061h		;9529	61 	a 
	defb 064h		;952a	64 	d 
	defb 020h		;952b	20 	  
	defb 050h		;952c	50 	P 
	defb 055h		;952d	55 	U 
	defb 054h		;952e	54 	T 
	defb 020h		;952f	20 	  
	defb 028h		;9530	28 	( 
	defb 04fh		;9531	4f 	O 
	defb 052h		;9532	52 	R 
	defb 047h		;9533	47 	G 
	defb 0a9h		;9534	a9 	. 
	defb 020h		;9535	20 	  
	defb 075h		;9536	75 	u 
	defb 06eh		;9537	6e 	n 
	defb 06bh		;9538	6b 	k 
	defb 06eh		;9539	6e 	n 
	defb 06fh		;953a	6f 	o 
	defb 077h		;953b	77 	w 
	defb 0eeh		;953c	ee 	. 
	defb 057h		;953d	57 	W 
	defb 061h		;953e	61 	a 
	defb 069h		;953f	69 	i 
	defb 074h		;9540	74 	t 
	defb 020h		;9541	20 	  
	defb 070h		;9542	70 	p 
	defb 06ch		;9543	6c 	l 
	defb 065h		;9544	65 	e 
	defb 061h		;9545	61 	a 
	defb 073h		;9546	73 	s 
	defb 0e5h		;9547	e5 	. 
	defb 041h		;9548	41 	A 
	defb 073h		;9549	73 	s 
	defb 073h		;954a	73 	s 
	defb 065h		;954b	65 	e 
	defb 06dh		;954c	6d 	m 
	defb 062h		;954d	62 	b 
	defb 06ch		;954e	6c 	l 
	defb 079h		;954f	79 	y 
	defb 020h		;9550	20 	  
	defb 063h		;9551	63 	c 
	defb 06fh		;9552	6f 	o 
	defb 06dh		;9553	6d 	m 
	defb 070h		;9554	70 	p 
	defb 06ch		;9555	6c 	l 
	defb 065h		;9556	65 	e 
	defb 074h		;9557	74 	t 
	defb 0e5h		;9558	e5 	. 
	defb 053h		;9559	53 	S 
	defb 074h		;955a	74 	t 
	defb 061h		;955b	61 	a 
	defb 072h		;955c	72 	r 
	defb 074h		;955d	74 	t 
	defb 020h		;955e	20 	  
	defb 074h		;955f	74 	t 
	defb 061h		;9560	61 	a 
	defb 070h		;9561	70 	p 
	defb 0e5h		;9562	e5 	. 
	defb 054h		;9563	54 	T 
	defb 061h		;9564	61 	a 
	defb 070h		;9565	70 	p 
	defb 065h		;9566	65 	e 
	defb 020h		;9567	20 	  
	defb 065h		;9568	65 	e 
	defb 072h		;9569	72 	r 
	defb 072h		;956a	72 	r 
	defb 06fh		;956b	6f 	o 
	defb 0f2h		;956c	f2 	. 
	defb 041h		;956d	41 	A 
	defb 06eh		;956e	6e 	n 
	defb 079h		;956f	79 	y 
	defb 020h		;9570	20 	  
	defb 06bh		;9571	6b 	k 
	defb 065h		;9572	65 	e 
	defb 0f9h		;9573	f9 	. 
	defb 028h		;9574	28 	( 
	defb 043h		;9575	43 	C 
	defb 029h		;9576	29 	) 
	defb 020h		;9577	20 	  
	defb 039h		;9578	39 	9 
	defb 030h		;9579	30 	0 
	defb 020h		;957a	20 	  
	defb 055h		;957b	55 	U 
	defb 04eh		;957c	4e 	N 
	defb 049h		;957d	49 	I 
	defb 056h		;957e	56 	V 
	defb 045h		;957f	45 	E 
	defb 052h		;9580	52 	R 
	defb 053h		;9581	53 	S 
	defb 055h		;9582	55 	U 
	defb 0cdh		;9583	cd 	. 
	defb 053h		;9584	53 	S 
	defb 06fh		;9585	6f 	o 
	defb 075h		;9586	75 	u 
	defb 072h		;9587	72 	r 
	defb 063h		;9588	63 	c 
	defb 065h		;9589	65 	e 
	defb 020h		;958a	20 	  
	defb 045h		;958b	45 	E 
	defb 052h		;958c	52 	R 
	defb 052h		;958d	52 	R 
	defb 04fh		;958e	4f 	O 
	defb 0d2h		;958f	d2 	. 
	defb 046h		;9590	46 	F 
	defb 06fh		;9591	6f 	o 
	defb 075h		;9592	75 	u 
	defb 06eh		;9593	6e 	n 
	defb 064h		;9594	64 	d 
	defb 0bah		;9595	ba 	. 
	defb 041h		;9596	41 	A 
	defb 06ch		;9597	6c 	l 
	defb 072h		;9598	72 	r 
	defb 065h		;9599	65 	e 
	defb 061h		;959a	61 	a 
	defb 064h		;959b	64 	d 
	defb 079h		;959c	79 	y 
	defb 020h		;959d	20 	  
	defb 064h		;959e	64 	d 
	defb 065h		;959f	65 	e 
	defb 066h		;95a0	66 	f 
	defb 069h		;95a1	69 	i 
	defb 06eh		;95a2	6e 	n 
	defb 065h		;95a3	65 	e 
	defb 0e4h		;95a4	e4 	. 
	defb 045h		;95a5	45 	E 
	defb 04eh		;95a6	4e 	N 
	defb 054h		;95a7	54 	T 
	defb 020h		;95a8	20 	  
	defb 0bfh		;95a9	bf 	. 
	defb 000h		;95aa	00 	. 
	defb 04dh		;95ab	4d 	M 
	defb 04dh		;95ac	4d 	M 
	defb 04eh		;95ad	4e 	N 
	defb 04fh		;95ae	4f 	O 
	defb 050h		;95af	50 	P 
	defb 051h		;95b0	51 	Q 
	defb 052h		;95b1	52 	R 
	defb 053h		;95b2	53 	S 
	defb 054h		;95b3	54 	T 
	defb 055h		;95b4	55 	U 
	defb 056h		;95b5	56 	V 
	defb 057h		;95b6	57 	W 
	defb 058h		;95b7	58 	X 
	defb 059h		;95b8	59 	Y 
	defb 05bh		;95b9	5b 	[ 
	defb 05dh		;95ba	5d 	] 
	defb 05fh		;95bb	5f 	_ 
	defb 061h		;95bc	61 	a 
	defb 063h		;95bd	63 	c 
	defb 065h		;95be	65 	e 
	defb 067h		;95bf	67 	g 
	defb 069h		;95c0	69 	i 
	defb 06bh		;95c1	6b 	k 
	defb 06dh		;95c2	6d 	m 
	defb 06fh		;95c3	6f 	o 
	defb 071h		;95c4	71 	q 
	defb 073h		;95c5	73 	s 
	defb 075h		;95c6	75 	u 
	defb 077h		;95c7	77 	w 
	defb 079h		;95c8	79 	y 
	defb 07bh		;95c9	7b 	{ 
	defb 07dh		;95ca	7d 	} 
	defb 07fh		;95cb	7f 	 
	defb 081h		;95cc	81 	. 
	defb 083h		;95cd	83 	. 
	defb 085h		;95ce	85 	. 
	defb 087h		;95cf	87 	. 
	defb 089h		;95d0	89 	. 
	defb 08bh		;95d1	8b 	. 
	defb 08dh		;95d2	8d 	. 
	defb 08fh		;95d3	8f 	. 
	defb 091h		;95d4	91 	. 
	defb 093h		;95d5	93 	. 
	defb 095h		;95d6	95 	. 
	defb 097h		;95d7	97 	. 
	defb 099h		;95d8	99 	. 
	defb 09bh		;95d9	9b 	. 
	defb 09dh		;95da	9d 	. 
	defb 09fh		;95db	9f 	. 
	defb 0a1h		;95dc	a1 	. 
	defb 0a3h		;95dd	a3 	. 
	defb 0a5h		;95de	a5 	. 
	defb 0a7h		;95df	a7 	. 
	defb 0a9h		;95e0	a9 	. 
	defb 0abh		;95e1	ab 	. 
	defb 0aeh		;95e2	ae 	. 
	defb 0b1h		;95e3	b1 	. 
	defb 0b4h		;95e4	b4 	. 
	defb 0b7h		;95e5	b7 	. 
	defb 0bah		;95e6	ba 	. 
	defb 0bdh		;95e7	bd 	. 
	defb 0c0h		;95e8	c0 	. 
	defb 0c3h		;95e9	c3 	. 
	defb 0c6h		;95ea	c6 	. 
	defb 0c9h		;95eb	c9 	. 
	defb 0cch		;95ec	cc 	. 
	defb 0cfh		;95ed	cf 	. 
	defb 0d2h		;95ee	d2 	. 
	defb 0d5h		;95ef	d5 	. 
	defb 0d8h		;95f0	d8 	. 
	defb 0dbh		;95f1	db 	. 
	defb 0deh		;95f2	de 	. 
	defb 0e1h		;95f3	e1 	. 
	defb 0e4h		;95f4	e4 	. 
	defb 0e7h		;95f5	e7 	. 
	defb 0eah		;95f6	ea 	. 
	defb 0edh		;95f7	ed 	. 
	defb 0bbh		;95f8	bb 	. 
	defb 063h		;95f9	63 	c 
	defb 0f0h		;95fa	f0 	. 
	defb 064h		;95fb	64 	d 
	defb 0e9h		;95fc	e9 	. 
	defb 065h		;95fd	65 	e 
	defb 0e9h		;95fe	e9 	. 
	defb 065h		;95ff	65 	e 
	defb 0f8h		;9600	f8 	. 
	defb 069h		;9601	69 	i 
	defb 0edh		;9602	ed 	. 
	defb 069h		;9603	69 	i 
	defb 0eeh		;9604	ee 	. 
	defb 06ah		;9605	6a 	j 
	defb 0f0h		;9606	f0 	. 
	defb 06ah		;9607	6a 	j 
	defb 0f2h		;9608	f2 	. 
	defb 06ch		;9609	6c 	l 
	defb 0e4h		;960a	e4 	. 
	defb 06fh		;960b	6f 	o 
	defb 0f2h		;960c	f2 	. 
	defb 072h		;960d	72 	r 
	defb 0ech		;960e	ec 	. 
	defb 072h		;960f	72 	r 
	defb 0f2h		;9610	f2 	. 
	defb 061h		;9611	61 	a 
	defb 064h		;9612	64 	d 
	defb 0e3h		;9613	e3 	. 
	defb 061h		;9614	61 	a 
	defb 064h		;9615	64 	d 
	defb 0e4h		;9616	e4 	. 
	defb 061h		;9617	61 	a 
	defb 06eh		;9618	6e 	n 
	defb 0e4h		;9619	e4 	. 
	defb 062h		;961a	62 	b 
	defb 069h		;961b	69 	i 
	defb 0f4h		;961c	f4 	. 
	defb 063h		;961d	63 	c 
	defb 063h		;961e	63 	c 
	defb 0e6h		;961f	e6 	. 
	defb 063h		;9620	63 	c 
	defb 070h		;9621	70 	p 
	defb 0e4h		;9622	e4 	. 
	defb 063h		;9623	63 	c 
	defb 070h		;9624	70 	p 
	defb 0e9h		;9625	e9 	. 
	defb 063h		;9626	63 	c 
	defb 070h		;9627	70 	p 
	defb 0ech		;9628	ec 	. 
	defb 064h		;9629	64 	d 
	defb 061h		;962a	61 	a 
	defb 0e1h		;962b	e1 	. 
	defb 064h		;962c	64 	d 
	defb 065h		;962d	65 	e 
	defb 0e3h		;962e	e3 	. 
	defb 065h		;962f	65 	e 
	defb 06eh		;9630	6e 	n 
	defb 0f4h		;9631	f4 	. 
	defb 065h		;9632	65 	e 
	defb 071h		;9633	71 	q 
	defb 0f5h		;9634	f5 	. 
	defb 065h		;9635	65 	e 
	defb 078h		;9636	78 	x 
	defb 0f8h		;9637	f8 	. 
	defb 069h		;9638	69 	i 
	defb 06eh		;9639	6e 	n 
	defb 0e3h		;963a	e3 	. 
	defb 069h		;963b	69 	i 
	defb 06eh		;963c	6e 	n 
	defb 0e4h		;963d	e4 	. 
	defb 069h		;963e	69 	i 
	defb 06eh		;963f	6e 	n 
	defb 0e9h		;9640	e9 	. 
	defb 06ch		;9641	6c 	l 
	defb 064h		;9642	64 	d 
	defb 0e4h		;9643	e4 	. 
	defb 06ch		;9644	6c 	l 
	defb 064h		;9645	64 	d 
	defb 0e9h		;9646	e9 	. 
	defb 06eh		;9647	6e 	n 
	defb 065h		;9648	65 	e 
	defb 0e7h		;9649	e7 	. 
	defb 06eh		;964a	6e 	n 
	defb 06fh		;964b	6f 	o 
	defb 0f0h		;964c	f0 	. 
	defb 06fh		;964d	6f 	o 
	defb 072h		;964e	72 	r 
	defb 0e7h		;964f	e7 	. 
	defb 06fh		;9650	6f 	o 
	defb 075h		;9651	75 	u 
	defb 0f4h		;9652	f4 	. 
	defb 070h		;9653	70 	p 
	defb 06fh		;9654	6f 	o 
	defb 0f0h		;9655	f0 	. 
	defb 070h		;9656	70 	p 
	defb 075h		;9657	75 	u 
	defb 0f4h		;9658	f4 	. 
	defb 072h		;9659	72 	r 
	defb 065h		;965a	65 	e 
	defb 0f3h		;965b	f3 	. 
	defb 072h		;965c	72 	r 
	defb 065h		;965d	65 	e 
	defb 0f4h		;965e	f4 	. 
	defb 072h		;965f	72 	r 
	defb 06ch		;9660	6c 	l 
	defb 0e1h		;9661	e1 	. 
	defb 072h		;9662	72 	r 
	defb 06ch		;9663	6c 	l 
	defb 0e3h		;9664	e3 	. 
	defb 072h		;9665	72 	r 
	defb 06ch		;9666	6c 	l 
	defb 0e4h		;9667	e4 	. 
	defb 072h		;9668	72 	r 
	defb 072h		;9669	72 	r 
	defb 0e1h		;966a	e1 	. 
	defb 072h		;966b	72 	r 
	defb 072h		;966c	72 	r 
	defb 0e3h		;966d	e3 	. 
	defb 072h		;966e	72 	r 
	defb 072h		;966f	72 	r 
	defb 0e4h		;9670	e4 	. 
	defb 072h		;9671	72 	r 
	defb 073h		;9672	73 	s 
	defb 0f4h		;9673	f4 	. 
	defb 073h		;9674	73 	s 
	defb 062h		;9675	62 	b 
	defb 0e3h		;9676	e3 	. 
	defb 073h		;9677	73 	s 
	defb 063h		;9678	63 	c 
	defb 0e6h		;9679	e6 	. 
	defb 073h		;967a	73 	s 
	defb 065h		;967b	65 	e 
	defb 0f4h		;967c	f4 	. 
	defb 073h		;967d	73 	s 
	defb 06ch		;967e	6c 	l 
	defb 0e1h		;967f	e1 	. 
	defb 073h		;9680	73 	s 
	defb 072h		;9681	72 	r 
	defb 0e1h		;9682	e1 	. 
	defb 073h		;9683	73 	s 
	defb 072h		;9684	72 	r 
	defb 0ech		;9685	ec 	. 
	defb 073h		;9686	73 	s 
	defb 075h		;9687	75 	u 
	defb 0e2h		;9688	e2 	. 
	defb 078h		;9689	78 	x 
	defb 06fh		;968a	6f 	o 
	defb 0f2h		;968b	f2 	. 
	defb 063h		;968c	63 	c 
	defb 061h		;968d	61 	a 
	defb 06ch		;968e	6c 	l 
	defb 0ech		;968f	ec 	. 
	defb 063h		;9690	63 	c 
	defb 070h		;9691	70 	p 
	defb 064h		;9692	64 	d 
	defb 0f2h		;9693	f2 	. 
	defb 063h		;9694	63 	c 
	defb 070h		;9695	70 	p 
	defb 069h		;9696	69 	i 
	defb 0f2h		;9697	f2 	. 
	defb 064h		;9698	64 	d 
	defb 065h		;9699	65 	e 
	defb 066h		;969a	66 	f 
	defb 0e2h		;969b	e2 	. 
	defb 064h		;969c	64 	d 
	defb 065h		;969d	65 	e 
	defb 066h		;969e	66 	f 
	defb 0edh		;969f	ed 	. 
	defb 064h		;96a0	64 	d 
	defb 065h		;96a1	65 	e 
	defb 066h		;96a2	66 	f 
	defb 0f3h		;96a3	f3 	. 
	defb 064h		;96a4	64 	d 
	defb 065h		;96a5	65 	e 
	defb 066h		;96a6	66 	f 
	defb 0f7h		;96a7	f7 	. 
	defb 064h		;96a8	64 	d 
	defb 06ah		;96a9	6a 	j 
	defb 06eh		;96aa	6e 	n 
	defb 0fah		;96ab	fa 	. 
	defb 068h		;96ac	68 	h 
	defb 061h		;96ad	61 	a 
	defb 06ch		;96ae	6c 	l 
	defb 0f4h		;96af	f4 	. 
	defb 069h		;96b0	69 	i 
	defb 06eh		;96b1	6e 	n 
	defb 064h		;96b2	64 	d 
	defb 0f2h		;96b3	f2 	. 
	defb 069h		;96b4	69 	i 
	defb 06eh		;96b5	6e 	n 
	defb 069h		;96b6	69 	i 
	defb 0f2h		;96b7	f2 	. 
	defb 06ch		;96b8	6c 	l 
	defb 064h		;96b9	64 	d 
	defb 064h		;96ba	64 	d 
	defb 0f2h		;96bb	f2 	. 
	defb 06ch		;96bc	6c 	l 
	defb 064h		;96bd	64 	d 
	defb 069h		;96be	69 	i 
	defb 0f2h		;96bf	f2 	. 
	defb 06fh		;96c0	6f 	o 
	defb 074h		;96c1	74 	t 
	defb 064h		;96c2	64 	d 
	defb 0f2h		;96c3	f2 	. 
	defb 06fh		;96c4	6f 	o 
	defb 074h		;96c5	74 	t 
	defb 069h		;96c6	69 	i 
	defb 0f2h		;96c7	f2 	. 
	defb 06fh		;96c8	6f 	o 
	defb 075h		;96c9	75 	u 
	defb 074h		;96ca	74 	t 
	defb 0e4h		;96cb	e4 	. 
	defb 06fh		;96cc	6f 	o 
	defb 075h		;96cd	75 	u 
	defb 074h		;96ce	74 	t 
	defb 0e9h		;96cf	e9 	. 
	defb 070h		;96d0	70 	p 
	defb 075h		;96d1	75 	u 
	defb 073h		;96d2	73 	s 
	defb 0e8h		;96d3	e8 	. 
	defb 072h		;96d4	72 	r 
	defb 065h		;96d5	65 	e 
	defb 074h		;96d6	74 	t 
	defb 0e9h		;96d7	e9 	. 
	defb 072h		;96d8	72 	r 
	defb 065h		;96d9	65 	e 
	defb 074h		;96da	74 	t 
	defb 0eeh		;96db	ee 	. 
	defb 072h		;96dc	72 	r 
	defb 06ch		;96dd	6c 	l 
	defb 063h		;96de	63 	c 
	defb 0e1h		;96df	e1 	. 
	defb 072h		;96e0	72 	r 
	defb 072h		;96e1	72 	r 
	defb 063h		;96e2	63 	c 
	defb 0e1h		;96e3	e1 	. 
	defb 073h		;96e4	73 	s 
	defb 06ch		;96e5	6c 	l 
	defb 069h		;96e6	69 	i 
	defb 0e1h		;96e7	e1 	. 
	defb 020h		;96e8	20 	  
	defb 02bh		;96e9	2b 	+ 
	defb 02bh		;96ea	2b 	+ 
	defb 02bh		;96eb	2b 	+ 
	defb 02bh		;96ec	2b 	+ 
	defb 02bh		;96ed	2b 	+ 
	defb 02bh		;96ee	2b 	+ 
	defb 02bh		;96ef	2b 	+ 
	defb 02bh		;96f0	2b 	+ 
	defb 02bh		;96f1	2b 	+ 
	defb 02bh		;96f2	2b 	+ 
	defb 02bh		;96f3	2b 	+ 
	defb 02bh		;96f4	2b 	+ 
	defb 02bh		;96f5	2b 	+ 
	defb 02bh		;96f6	2b 	+ 
	defb 02bh		;96f7	2b 	+ 
	defb 02bh		;96f8	2b 	+ 
	defb 02bh		;96f9	2b 	+ 
	defb 02bh		;96fa	2b 	+ 
	defb 02bh		;96fb	2b 	+ 
	defb 02bh		;96fc	2b 	+ 
	defb 02bh		;96fd	2b 	+ 
	defb 02ch		;96fe	2c 	, 
	defb 02dh		;96ff	2d 	- 
	defb 02eh		;9700	2e 	. 
	defb 02fh		;9701	2f 	/ 
	defb 030h		;9702	30 	0 
	defb 031h		;9703	31 	1 
	defb 032h		;9704	32 	2 
	defb 033h		;9705	33 	3 
	defb 034h		;9706	34 	4 
	defb 035h		;9707	35 	5 
	defb 036h		;9708	36 	6 
	defb 037h		;9709	37 	7 
	defb 038h		;970a	38 	8 
	defb 039h		;970b	39 	9 
	defb 03ah		;970c	3a 	: 
	defb 03ch		;970d	3c 	< 
	defb 03eh		;970e	3e 	> 
	defb 041h		;970f	41 	A 
	defb 044h		;9710	44 	D 
	defb 047h		;9711	47 	G 
	defb 04ah		;9712	4a 	J 
	defb 04dh		;9713	4d 	M 
	defb 0b0h		;9714	b0 	. 
	defb 0b1h		;9715	b1 	. 
	defb 0b2h		;9716	b2 	. 
	defb 0b3h		;9717	b3 	. 
	defb 0b4h		;9718	b4 	. 
	defb 0b5h		;9719	b5 	. 
	defb 0b6h		;971a	b6 	. 
	defb 0b7h		;971b	b7 	. 
	defb 0e1h		;971c	e1 	. 
	defb 0e2h		;971d	e2 	. 
	defb 0e3h		;971e	e3 	. 
	defb 0e4h		;971f	e4 	. 
	defb 0e5h		;9720	e5 	. 
	defb 0e8h		;9721	e8 	. 
	defb 0e9h		;9722	e9 	. 
	defb 0ech		;9723	ec 	. 
	defb 0edh		;9724	ed 	. 
	defb 0f0h		;9725	f0 	. 
	defb 0f2h		;9726	f2 	. 
	defb 0fah		;9727	fa 	. 
	defb 061h		;9728	61 	a 
	defb 0e6h		;9729	e6 	. 
	defb 062h		;972a	62 	b 
	defb 0e3h		;972b	e3 	. 
	defb 064h		;972c	64 	d 
	defb 0e5h		;972d	e5 	. 
	defb 068h		;972e	68 	h 
	defb 0ech		;972f	ec 	. 
	defb 068h		;9730	68 	h 
	defb 0f8h		;9731	f8 	. 
	defb 068h		;9732	68 	h 
	defb 0f9h		;9733	f9 	. 
	defb 069h		;9734	69 	i 
	defb 0f8h		;9735	f8 	. 
	defb 069h		;9736	69 	i 
	defb 0f9h		;9737	f9 	. 
	defb 06ch		;9738	6c 	l 
	defb 0f8h		;9739	f8 	. 
	defb 06ch		;973a	6c 	l 
	defb 0f9h		;973b	f9 	. 
	defb 06eh		;973c	6e 	n 
	defb 0e3h		;973d	e3 	. 
	defb 06eh		;973e	6e 	n 
	defb 0fah		;973f	fa 	. 
	defb 070h		;9740	70 	p 
	defb 0e5h		;9741	e5 	. 
	defb 070h		;9742	70 	p 
	defb 0efh		;9743	ef 	. 
	defb 073h		;9744	73 	s 
	defb 0f0h		;9745	f0 	. 
	defb 028h		;9746	28 	( 
	defb 063h		;9747	63 	c 
	defb 0a9h		;9748	a9 	. 
	defb 061h		;9749	61 	a 
	defb 066h		;974a	66 	f 
	defb 0a7h		;974b	a7 	. 
	defb 028h		;974c	28 	( 
	defb 062h		;974d	62 	b 
	defb 063h		;974e	63 	c 
	defb 0a9h		;974f	a9 	. 
	defb 028h		;9750	28 	( 
	defb 064h		;9751	64 	d 
	defb 065h		;9752	65 	e 
	defb 0a9h		;9753	a9 	. 
	defb 028h		;9754	28 	( 
	defb 068h		;9755	68 	h 
	defb 06ch		;9756	6c 	l 
	defb 0a9h		;9757	a9 	. 
	defb 028h		;9758	28 	( 
	defb 069h		;9759	69 	i 
	defb 078h		;975a	78 	x 
	defb 0a9h		;975b	a9 	. 
	defb 028h		;975c	28 	( 
	defb 069h		;975d	69 	i 
	defb 079h		;975e	79 	y 
	defb 0a9h		;975f	a9 	. 
	defb 028h		;9760	28 	( 
	defb 073h		;9761	73 	s 
	defb 070h		;9762	70 	p 
	defb 0a9h		;9763	a9 	. 
	defb 01ah		;9764	1a 	. 
	defb 021h		;9765	21 	! 
	defb 025h		;9766	25 	% 
	defb 028h		;9767	28 	( 
	defb 027h		;9768	27 	' 
	defb 02ch		;9769	2c 	, 
	defb 02fh		;976a	2f 	/ 
	defb 02eh		;976b	2e 	. 
	defb 02dh		;976c	2d 	- 
	defb 02ch		;976d	2c 	, 
	defb 02bh		;976e	2b 	+ 
	defb 02eh		;976f	2e 	. 
	defb 031h		;9770	31 	1 
	defb 037h		;9771	37 	7 
	defb 036h		;9772	36 	6 
	defb 038h		;9773	38 	8 
	defb 03ch		;9774	3c 	< 
	defb 03fh		;9775	3f 	? 
	defb 041h		;9776	41 	A 
	defb 044h		;9777	44 	D 
	defb 048h		;9778	48 	H 
	defb 04ch		;9779	4c 	L 
	defb 04bh		;977a	4b 	K 
	defb 050h		;977b	50 	P 
	defb 04fh		;977c	4f 	O 
	defb 053h		;977d	53 	S 
	defb 041h		;977e	41 	A 
	defb 053h		;977f	53 	S 
	defb 053h		;9780	53 	S 
	defb 045h		;9781	45 	E 
	defb 04dh		;9782	4d 	M 
	defb 042h		;9783	42 	B 
	defb 04ch		;9784	4c 	L 
	defb 0d9h		;9785	d9 	. 
	defb 042h		;9786	42 	B 
	defb 041h		;9787	41 	A 
	defb 053h		;9788	53 	S 
	defb 049h		;9789	49 	I 
	defb 0c3h		;978a	c3 	. 
	defb 043h		;978b	43 	C 
	defb 04fh		;978c	4f 	O 
	defb 050h		;978d	50 	P 
	defb 0d9h		;978e	d9 	. 
	defb 044h		;978f	44 	D 
	defb 045h		;9790	45 	E 
	defb 04ch		;9791	4c 	L 
	defb 045h		;9792	45 	E 
	defb 054h		;9793	54 	T 
	defb 0c5h		;9794	c5 	. 
	defb 046h		;9795	46 	F 
	defb 049h		;9796	49 	I 
	defb 04eh		;9797	4e 	N 
	defb 0c4h		;9798	c4 	. 
	defb 047h		;9799	47 	G 
	defb 045h		;979a	45 	E 
	defb 04eh		;979b	4e 	N 
	defb 0d3h		;979c	d3 	. 
	defb 04ch		;979d	4c 	L 
	defb 04fh		;979e	4f 	O 
	defb 041h		;979f	41 	A 
	defb 0c4h		;97a0	c4 	. 
	defb 04dh		;97a1	4d 	M 
	defb 04fh		;97a2	4f 	O 
	defb 04eh		;97a3	4e 	N 
	defb 049h		;97a4	49 	I 
	defb 054h		;97a5	54 	T 
	defb 04fh		;97a6	4f 	O 
	defb 0d2h		;97a7	d2 	. 
	defb 04eh		;97a8	4e 	N 
	defb 045h		;97a9	45 	E 
	defb 0d7h		;97aa	d7 	. 
	defb 050h		;97ab	50 	P 
	defb 052h		;97ac	52 	R 
	defb 049h		;97ad	49 	I 
	defb 04eh		;97ae	4e 	N 
	defb 0d4h		;97af	d4 	. 
	defb 051h		;97b0	51 	Q 
	defb 055h		;97b1	55 	U 
	defb 049h		;97b2	49 	I 
	defb 0d4h		;97b3	d4 	. 
	defb 052h		;97b4	52 	R 
	defb 055h		;97b5	55 	U 
	defb 0ceh		;97b6	ce 	. 
	defb 053h		;97b7	53 	S 
	defb 041h		;97b8	41 	A 
	defb 056h		;97b9	56 	V 
	defb 0c5h		;97ba	c5 	. 
	defb 054h		;97bb	54 	T 
	defb 041h		;97bc	41 	A 
	defb 042h		;97bd	42 	B 
	defb 04ch		;97be	4c 	L 
	defb 0c5h		;97bf	c5 	. 
	defb 055h		;97c0	55 	U 
	defb 02dh		;97c1	2d 	- 
	defb 054h		;97c2	54 	T 
	defb 04fh		;97c3	4f 	O 
	defb 0d0h		;97c4	d0 	. 
	defb 056h		;97c5	56 	V 
	defb 045h		;97c6	45 	E 
	defb 052h		;97c7	52 	R 
	defb 049h		;97c8	49 	I 
	defb 046h		;97c9	46 	F 
	defb 0d9h		;97ca	d9 	. 
	defb 043h		;97cb	43 	C 
	defb 04ch		;97cc	4c 	L 
	defb 045h		;97cd	45 	E 
	defb 041h		;97ce	41 	A 
	defb 0d2h		;97cf	d2 	. 
	defb 052h		;97d0	52 	R 
	defb 045h		;97d1	45 	E 
	defb 050h		;97d2	50 	P 
	defb 04ch		;97d3	4c 	L 
	defb 041h		;97d4	41 	A 
	defb 043h		;97d5	43 	C 
	defb 0c5h		;97d6	c5 	. 
	defb 000h		;97d7	00 	. 
	defb 000h		;97d8	00 	. 
	defb 042h		;97d9	42 	B 
	defb 000h		;97da	00 	. 
	defb 004h		;97db	04 	. 
	defb 000h		;97dc	00 	. 
	defb 030h		;97dd	30 	0 
	defb 000h		;97de	00 	. 
	defb 000h		;97df	00 	. 
	defb 000h		;97e0	00 	. 
	defb 000h		;97e1	00 	. 
	defb 080h		;97e2	80 	. 
	defb 052h		;97e3	52 	R 
	defb 050h		;97e4	50 	P 
	defb 008h		;97e5	08 	. 
	defb 001h		;97e6	01 	. 
	defb 002h		;97e7	02 	. 
	defb 014h		;97e8	14 	. 
	defb 0b5h		;97e9	b5 	. 
	defb 08ah		;97ea	8a 	. 
	defb 001h		;97eb	01 	. 
	defb 037h		;97ec	37 	7 
	defb 002h		;97ed	02 	. 
	defb 000h		;97ee	00 	. 
	defb 000h		;97ef	00 	. 
	defb 001h		;97f0	01 	. 
	defb 080h		;97f1	80 	. 
	defb 052h		;97f2	52 	R 
	defb 058h		;97f3	58 	X 
	defb 008h		;97f4	08 	. 
	defb 002h		;97f5	02 	. 
	defb 000h		;97f6	00 	. 
	defb 015h		;97f7	15 	. 
	defb 031h		;97f8	31 	1 
	defb 027h		;97f9	27 	' 
	defb 002h		;97fa	02 	. 
	defb 037h		;97fb	37 	7 
	defb 031h		;97fc	31 	1 
	defb 060h		;97fd	60 	` 
	defb 000h		;97fe	00 	. 
	defb 002h		;97ff	02 	. 
	defb 080h		;9800	80 	. 
	defb 052h		;9801	52 	R 
	defb 060h		;9802	60 	` 
	defb 008h		;9803	08 	. 
	defb 003h		;9804	03 	. 
	defb 000h		;9805	00 	. 
	defb 036h		;9806	36 	6 
	defb 0b0h		;9807	b0 	. 
	defb 006h		;9808	06 	. 
	defb 003h		;9809	03 	. 
	defb 037h		;980a	37 	7 
	defb 033h		;980b	33 	3 
	defb 060h		;980c	60 	` 
	defb 000h		;980d	00 	. 
	defb 003h		;980e	03 	. 
	defb 080h		;980f	80 	. 
	defb 052h		;9810	52 	R 
	defb 068h		;9811	68 	h 
	defb 008h		;9812	08 	. 
	defb 004h		;9813	04 	. 
	defb 000h		;9814	00 	. 
	defb 036h		;9815	36 	6 
	defb 050h		;9816	50 	P 
	defb 004h		;9817	04 	. 
	defb 004h		;9818	04 	. 
	defb 037h		;9819	37 	7 
	defb 045h		;981a	45 	E 
	defb 060h		;981b	60 	` 
	defb 000h		;981c	00 	. 
	defb 004h		;981d	04 	. 
	defb 080h		;981e	80 	. 
	defb 052h		;981f	52 	R 
	defb 070h		;9820	70 	p 
	defb 008h		;9821	08 	. 
	defb 005h		;9822	05 	. 
	defb 000h		;9823	00 	. 
	defb 02eh		;9824	2e 	. 
	defb 050h		;9825	50 	P 
	defb 004h		;9826	04 	. 
	defb 005h		;9827	05 	. 
	defb 037h		;9828	37 	7 
	defb 04bh		;9829	4b 	K 
	defb 060h		;982a	60 	` 
	defb 000h		;982b	00 	. 
	defb 005h		;982c	05 	. 
	defb 080h		;982d	80 	. 
	defb 052h		;982e	52 	R 
	defb 080h		;982f	80 	. 
	defb 008h		;9830	08 	. 
	defb 006h		;9831	06 	. 
	defb 001h		;9832	01 	. 
	defb 014h		;9833	14 	. 
	defb 055h		;9834	55 	U 
	defb 087h		;9835	87 	. 
	defb 006h		;9836	06 	. 
	defb 037h		;9837	37 	7 
	defb 074h		;9838	74 	t 
	defb 000h		;9839	00 	. 
	defb 000h		;983a	00 	. 
	defb 006h		;983b	06 	. 
	defb 080h		;983c	80 	. 
	defb 053h		;983d	53 	S 
	defb 040h		;983e	40 	@ 
	defb 00fh		;983f	0f 	. 
	defb 006h		;9840	06 	. 
	defb 0a4h		;9841	a4 	. 
	defb 053h		;9842	53 	S 
	defb 070h		;9843	70 	p 
	defb 017h		;9844	17 	. 
	defb 007h		;9845	07 	. 
	defb 000h		;9846	00 	. 
	defb 096h		;9847	96 	. 
	defb 000h		;9848	00 	. 
	defb 004h		;9849	04 	. 
	defb 007h		;984a	07 	. 
	defb 037h		;984b	37 	7 
	defb 076h		;984c	76 	v 
	defb 000h		;984d	00 	. 
	defb 000h		;984e	00 	. 
	defb 007h		;984f	07 	. 
	defb 080h		;9850	80 	. 
	defb 052h		;9851	52 	R 
	defb 048h		;9852	48 	H 
	defb 008h		;9853	08 	. 
	defb 008h		;9854	08 	. 
	defb 000h		;9855	00 	. 
	defb 00ah		;9856	0a 	. 
	defb 0ach		;9857	ac 	. 
	defb 0a4h		;9858	a4 	. 
	defb 008h		;9859	08 	. 
	defb 037h		;985a	37 	7 
	defb 078h		;985b	78 	x 
	defb 000h		;985c	00 	. 
	defb 000h		;985d	00 	. 
	defb 008h		;985e	08 	. 
	defb 080h		;985f	80 	. 
	defb 058h		;9860	58 	X 
	defb 050h		;9861	50 	P 
	defb 008h		;9862	08 	. 
	defb 009h		;9863	09 	. 
	defb 000h		;9864	00 	. 
	defb 01eh		;9865	1e 	. 
	defb 0c2h		;9866	c2 	. 
	defb 0cbh		;9867	cb 	. 
	defb 009h		;9868	09 	. 
	defb 020h		;9869	20 	  
	defb 01eh		;986a	1e 	. 
	defb 0dah		;986b	da 	. 
	defb 0cfh		;986c	cf 	. 
	defb 009h		;986d	09 	. 
	defb 037h		;986e	37 	7 
	defb 07ah		;986f	7a 	z 
	defb 000h		;9870	00 	. 
	defb 000h		;9871	00 	. 
	defb 009h		;9872	09 	. 
	defb 080h		;9873	80 	. 
	defb 058h		;9874	58 	X 
	defb 058h		;9875	58 	X 
	defb 008h		;9876	08 	. 
	defb 00ah		;9877	0a 	. 
	defb 000h		;9878	00 	. 
	defb 014h		;9879	14 	. 
	defb 04ch		;987a	4c 	L 
	defb 0c7h		;987b	c7 	. 
	defb 00ah		;987c	0a 	. 
	defb 080h		;987d	80 	. 
	defb 058h		;987e	58 	X 
	defb 060h		;987f	60 	` 
	defb 008h		;9880	08 	. 
	defb 00bh		;9881	0b 	. 
	defb 000h		;9882	00 	. 
	defb 02eh		;9883	2e 	. 
	defb 0b0h		;9884	b0 	. 
	defb 006h		;9885	06 	. 
	defb 00bh		;9886	0b 	. 
	defb 080h		;9887	80 	. 
	defb 058h		;9888	58 	X 
	defb 068h		;9889	68 	h 
	defb 008h		;988a	08 	. 
	defb 00ch		;988b	0c 	. 
	defb 000h		;988c	00 	. 
	defb 036h		;988d	36 	6 
	defb 058h		;988e	58 	X 
	defb 004h		;988f	04 	. 
	defb 00ch		;9890	0c 	. 
	defb 080h		;9891	80 	. 
	defb 058h		;9892	58 	X 
	defb 070h		;9893	70 	p 
	defb 008h		;9894	08 	. 
	defb 00dh		;9895	0d 	. 
	defb 000h		;9896	00 	. 
	defb 02eh		;9897	2e 	. 
	defb 058h		;9898	58 	X 
	defb 004h		;9899	04 	. 
	defb 00dh		;989a	0d 	. 
	defb 080h		;989b	80 	. 
	defb 058h		;989c	58 	X 
	defb 080h		;989d	80 	. 
	defb 008h		;989e	08 	. 
	defb 00eh		;989f	0e 	. 
	defb 001h		;98a0	01 	. 
	defb 014h		;98a1	14 	. 
	defb 05dh		;98a2	5d 	] 
	defb 087h		;98a3	87 	. 
	defb 00eh		;98a4	0e 	. 
	defb 080h		;98a5	80 	. 
	defb 059h		;98a6	59 	Y 
	defb 040h		;98a7	40 	@ 
	defb 00fh		;98a8	0f 	. 
	defb 00eh		;98a9	0e 	. 
	defb 0a4h		;98aa	a4 	. 
	defb 059h		;98ab	59 	Y 
	defb 070h		;98ac	70 	p 
	defb 017h		;98ad	17 	. 
	defb 00fh		;98ae	0f 	. 
	defb 000h		;98af	00 	. 
	defb 098h		;98b0	98 	. 
	defb 000h		;98b1	00 	. 
	defb 004h		;98b2	04 	. 
	defb 00fh		;98b3	0f 	. 
	defb 080h		;98b4	80 	. 
	defb 058h		;98b5	58 	X 
	defb 048h		;98b6	48 	H 
	defb 008h		;98b7	08 	. 
	defb 010h		;98b8	10 	. 
	defb 003h		;98b9	03 	. 
	defb 07dh		;98ba	7d 	} 
	defb 060h		;98bb	60 	` 
	defb 008h		;98bc	08 	. 
	defb 010h		;98bd	10 	. 
	defb 080h		;98be	80 	. 
	defb 018h		;98bf	18 	. 
	defb 050h		;98c0	50 	P 
	defb 008h		;98c1	08 	. 
	defb 011h		;98c2	11 	. 
	defb 002h		;98c3	02 	. 
	defb 014h		;98c4	14 	. 
	defb 0bdh		;98c5	bd 	. 
	defb 08ah		;98c6	8a 	. 
	defb 011h		;98c7	11 	. 
	defb 080h		;98c8	80 	. 
	defb 018h		;98c9	18 	. 
	defb 058h		;98ca	58 	X 
	defb 008h		;98cb	08 	. 
	defb 012h		;98cc	12 	. 
	defb 000h		;98cd	00 	. 
	defb 015h		;98ce	15 	. 
	defb 039h		;98cf	39 	9 
	defb 027h		;98d0	27 	' 
	defb 012h		;98d1	12 	. 
	defb 080h		;98d2	80 	. 
	defb 018h		;98d3	18 	. 
	defb 060h		;98d4	60 	` 
	defb 008h		;98d5	08 	. 
	defb 013h		;98d6	13 	. 
	defb 000h		;98d7	00 	. 
	defb 036h		;98d8	36 	6 
	defb 0b8h		;98d9	b8 	. 
	defb 006h		;98da	06 	. 
	defb 013h		;98db	13 	. 
	defb 080h		;98dc	80 	. 
	defb 018h		;98dd	18 	. 
	defb 068h		;98de	68 	h 
	defb 008h		;98df	08 	. 
	defb 014h		;98e0	14 	. 
	defb 000h		;98e1	00 	. 
	defb 036h		;98e2	36 	6 
	defb 060h		;98e3	60 	` 
	defb 004h		;98e4	04 	. 
	defb 014h		;98e5	14 	. 
	defb 080h		;98e6	80 	. 
	defb 018h		;98e7	18 	. 
	defb 070h		;98e8	70 	p 
	defb 008h		;98e9	08 	. 
	defb 015h		;98ea	15 	. 
	defb 000h		;98eb	00 	. 
	defb 02eh		;98ec	2e 	. 
	defb 060h		;98ed	60 	` 
	defb 004h		;98ee	04 	. 
	defb 015h		;98ef	15 	. 
	defb 080h		;98f0	80 	. 
	defb 018h		;98f1	18 	. 
	defb 080h		;98f2	80 	. 
	defb 008h		;98f3	08 	. 
	defb 016h		;98f4	16 	. 
	defb 001h		;98f5	01 	. 
	defb 014h		;98f6	14 	. 
	defb 065h		;98f7	65 	e 
	defb 087h		;98f8	87 	. 
	defb 016h		;98f9	16 	. 
	defb 080h		;98fa	80 	. 
	defb 019h		;98fb	19 	. 
	defb 040h		;98fc	40 	@ 
	defb 00fh		;98fd	0f 	. 
	defb 016h		;98fe	16 	. 
	defb 0a4h		;98ff	a4 	. 
	defb 019h		;9900	19 	. 
	defb 070h		;9901	70 	p 
	defb 017h		;9902	17 	. 
	defb 017h		;9903	17 	. 
	defb 000h		;9904	00 	. 
	defb 050h		;9905	50 	P 
	defb 000h		;9906	00 	. 
	defb 004h		;9907	04 	. 
	defb 017h		;9908	17 	. 
	defb 080h		;9909	80 	. 
	defb 018h		;990a	18 	. 
	defb 048h		;990b	48 	H 
	defb 008h		;990c	08 	. 
	defb 018h		;990d	18 	. 
	defb 003h		;990e	03 	. 
	defb 013h		;990f	13 	. 
	defb 060h		;9910	60 	` 
	defb 007h		;9911	07 	. 
	defb 018h		;9912	18 	. 
	defb 080h		;9913	80 	. 
	defb 01ah		;9914	1a 	. 
	defb 050h		;9915	50 	P 
	defb 008h		;9916	08 	. 
	defb 019h		;9917	19 	. 
	defb 000h		;9918	00 	. 
	defb 01eh		;9919	1e 	. 
	defb 0c2h		;991a	c2 	. 
	defb 0ebh		;991b	eb 	. 
	defb 019h		;991c	19 	. 
	defb 020h		;991d	20 	  
	defb 01eh		;991e	1e 	. 
	defb 0dah		;991f	da 	. 
	defb 0efh		;9920	ef 	. 
	defb 019h		;9921	19 	. 
	defb 080h		;9922	80 	. 
	defb 01ah		;9923	1a 	. 
	defb 058h		;9924	58 	X 
	defb 008h		;9925	08 	. 
	defb 01ah		;9926	1a 	. 
	defb 000h		;9927	00 	. 
	defb 014h		;9928	14 	. 
	defb 04ch		;9929	4c 	L 
	defb 0e7h		;992a	e7 	. 
	defb 01ah		;992b	1a 	. 
	defb 080h		;992c	80 	. 
	defb 01ah		;992d	1a 	. 
	defb 060h		;992e	60 	` 
	defb 008h		;992f	08 	. 
	defb 01bh		;9930	1b 	. 
	defb 000h		;9931	00 	. 
	defb 02eh		;9932	2e 	. 
	defb 0b8h		;9933	b8 	. 
	defb 006h		;9934	06 	. 
	defb 01bh		;9935	1b 	. 
	defb 080h		;9936	80 	. 
	defb 01ah		;9937	1a 	. 
	defb 068h		;9938	68 	h 
	defb 008h		;9939	08 	. 
	defb 01ch		;993a	1c 	. 
	defb 000h		;993b	00 	. 
	defb 036h		;993c	36 	6 
	defb 068h		;993d	68 	h 
	defb 004h		;993e	04 	. 
	defb 01ch		;993f	1c 	. 
	defb 080h		;9940	80 	. 
	defb 01ah		;9941	1a 	. 
	defb 070h		;9942	70 	p 
	defb 008h		;9943	08 	. 
	defb 01dh		;9944	1d 	. 
	defb 000h		;9945	00 	. 
	defb 02eh		;9946	2e 	. 
	defb 068h		;9947	68 	h 
	defb 004h		;9948	04 	. 
	defb 01dh		;9949	1d 	. 
	defb 080h		;994a	80 	. 
	defb 01ah		;994b	1a 	. 
	defb 080h		;994c	80 	. 
	defb 008h		;994d	08 	. 
	defb 01eh		;994e	1e 	. 
	defb 001h		;994f	01 	. 
	defb 014h		;9950	14 	. 
	defb 06dh		;9951	6d 	m 
	defb 087h		;9952	87 	. 
	defb 01eh		;9953	1e 	. 
	defb 080h		;9954	80 	. 
	defb 01bh		;9955	1b 	. 
	defb 040h		;9956	40 	@ 
	defb 00fh		;9957	0f 	. 
	defb 01eh		;9958	1e 	. 
	defb 0a4h		;9959	a4 	. 
	defb 01bh		;995a	1b 	. 
	defb 070h		;995b	70 	p 
	defb 017h		;995c	17 	. 
	defb 01fh		;995d	1f 	. 
	defb 000h		;995e	00 	. 
	defb 056h		;995f	56 	V 
	defb 000h		;9960	00 	. 
	defb 004h		;9961	04 	. 
	defb 01fh		;9962	1f 	. 
	defb 080h		;9963	80 	. 
	defb 01ah		;9964	1a 	. 
	defb 048h		;9965	48 	H 
	defb 008h		;9966	08 	. 
	defb 020h		;9967	20 	  
	defb 003h		;9968	03 	. 
	defb 013h		;9969	13 	. 
	defb 005h		;996a	05 	. 
	defb 087h		;996b	87 	. 
	defb 020h		;996c	20 	  
	defb 080h		;996d	80 	. 
	defb 064h		;996e	64 	d 
	defb 050h		;996f	50 	P 
	defb 008h		;9970	08 	. 
	defb 021h		;9971	21 	! 
	defb 002h		;9972	02 	. 
	defb 014h		;9973	14 	. 
	defb 0c5h		;9974	c5 	. 
	defb 08ah		;9975	8a 	. 
	defb 021h		;9976	21 	! 
	defb 022h		;9977	22 	" 
	defb 014h		;9978	14 	. 
	defb 0ddh		;9979	dd 	. 
	defb 08eh		;997a	8e 	. 
	defb 021h		;997b	21 	! 
	defb 080h		;997c	80 	. 
	defb 064h		;997d	64 	d 
	defb 058h		;997e	58 	X 
	defb 008h		;997f	08 	. 
	defb 022h		;9980	22 	" 
	defb 002h		;9981	02 	. 
	defb 015h		;9982	15 	. 
	defb 06bh		;9983	6b 	k 
	defb 010h		;9984	10 	. 
	defb 022h		;9985	22 	" 
	defb 022h		;9986	22 	" 
	defb 015h		;9987	15 	. 
	defb 06bh		;9988	6b 	k 
	defb 074h		;9989	74 	t 
	defb 022h		;998a	22 	" 
	defb 080h		;998b	80 	. 
	defb 064h		;998c	64 	d 
	defb 060h		;998d	60 	` 
	defb 008h		;998e	08 	. 
	defb 023h		;998f	23 	# 
	defb 000h		;9990	00 	. 
	defb 036h		;9991	36 	6 
	defb 0c0h		;9992	c0 	. 
	defb 006h		;9993	06 	. 
	defb 023h		;9994	23 	# 
	defb 020h		;9995	20 	  
	defb 036h		;9996	36 	6 
	defb 0d8h		;9997	d8 	. 
	defb 00ah		;9998	0a 	. 
	defb 023h		;9999	23 	# 
	defb 080h		;999a	80 	. 
	defb 064h		;999b	64 	d 
	defb 068h		;999c	68 	h 
	defb 008h		;999d	08 	. 
	defb 024h		;999e	24 	$ 
	defb 000h		;999f	00 	. 
	defb 036h		;99a0	36 	6 
	defb 070h		;99a1	70 	p 
	defb 004h		;99a2	04 	. 
	defb 024h		;99a3	24 	$ 
	defb 020h		;99a4	20 	  
	defb 036h		;99a5	36 	6 
	defb 0c8h		;99a6	c8 	. 
	defb 008h		;99a7	08 	. 
	defb 024h		;99a8	24 	$ 
	defb 080h		;99a9	80 	. 
	defb 064h		;99aa	64 	d 
	defb 070h		;99ab	70 	p 
	defb 008h		;99ac	08 	. 
	defb 025h		;99ad	25 	% 
	defb 000h		;99ae	00 	. 
	defb 02eh		;99af	2e 	. 
	defb 070h		;99b0	70 	p 
	defb 004h		;99b1	04 	. 
	defb 025h		;99b2	25 	% 
	defb 020h		;99b3	20 	  
	defb 02eh		;99b4	2e 	. 
	defb 0c8h		;99b5	c8 	. 
	defb 008h		;99b6	08 	. 
	defb 025h		;99b7	25 	% 
	defb 080h		;99b8	80 	. 
	defb 064h		;99b9	64 	d 
	defb 080h		;99ba	80 	. 
	defb 008h		;99bb	08 	. 
	defb 026h		;99bc	26 	& 
	defb 001h		;99bd	01 	. 
	defb 014h		;99be	14 	. 
	defb 075h		;99bf	75 	u 
	defb 087h		;99c0	87 	. 
	defb 026h		;99c1	26 	& 
	defb 021h		;99c2	21 	! 
	defb 014h		;99c3	14 	. 
	defb 0cdh		;99c4	cd 	. 
	defb 08bh		;99c5	8b 	. 
	defb 026h		;99c6	26 	& 
	defb 080h		;99c7	80 	. 
	defb 065h		;99c8	65 	e 
	defb 040h		;99c9	40 	@ 
	defb 00fh		;99ca	0f 	. 
	defb 026h		;99cb	26 	& 
	defb 0a4h		;99cc	a4 	. 
	defb 065h		;99cd	65 	e 
	defb 070h		;99ce	70 	p 
	defb 017h		;99cf	17 	. 
	defb 027h		;99d0	27 	' 
	defb 000h		;99d1	00 	. 
	defb 02ch		;99d2	2c 	, 
	defb 000h		;99d3	00 	. 
	defb 004h		;99d4	04 	. 
	defb 027h		;99d5	27 	' 
	defb 080h		;99d6	80 	. 
	defb 064h		;99d7	64 	d 
	defb 048h		;99d8	48 	H 
	defb 008h		;99d9	08 	. 
	defb 028h		;99da	28 	( 
	defb 003h		;99db	03 	. 
	defb 012h		;99dc	12 	. 
	defb 0a5h		;99dd	a5 	. 
	defb 087h		;99de	87 	. 
	defb 028h		;99df	28 	( 
	defb 080h		;99e0	80 	. 
	defb 066h		;99e1	66 	f 
	defb 050h		;99e2	50 	P 
	defb 008h		;99e3	08 	. 
	defb 029h		;99e4	29 	) 
	defb 000h		;99e5	00 	. 
	defb 01eh		;99e6	1e 	. 
	defb 0c3h		;99e7	c3 	. 
	defb 00bh		;99e8	0b 	. 
	defb 029h		;99e9	29 	) 
	defb 020h		;99ea	20 	  
	defb 01eh		;99eb	1e 	. 
	defb 0dbh		;99ec	db 	. 
	defb 06fh		;99ed	6f 	o 
	defb 029h		;99ee	29 	) 
	defb 080h		;99ef	80 	. 
	defb 066h		;99f0	66 	f 
	defb 058h		;99f1	58 	X 
	defb 008h		;99f2	08 	. 
	defb 02ah		;99f3	2a 	* 
	defb 002h		;99f4	02 	. 
	defb 014h		;99f5	14 	. 
	defb 0c5h		;99f6	c5 	. 
	defb 0b0h		;99f7	b0 	. 
	defb 02ah		;99f8	2a 	* 
	defb 022h		;99f9	22 	" 
	defb 014h		;99fa	14 	. 
	defb 0ddh		;99fb	dd 	. 
	defb 0b4h		;99fc	b4 	. 
	defb 02ah		;99fd	2a 	* 
	defb 080h		;99fe	80 	. 
	defb 066h		;99ff	66 	f 
	defb 060h		;9a00	60 	` 
	defb 008h		;9a01	08 	. 
	defb 02bh		;9a02	2b 	+ 
	defb 000h		;9a03	00 	. 
	defb 02eh		;9a04	2e 	. 
	defb 0c0h		;9a05	c0 	. 
	defb 006h		;9a06	06 	. 
	defb 02bh		;9a07	2b 	+ 
	defb 020h		;9a08	20 	  
	defb 02eh		;9a09	2e 	. 
	defb 0d8h		;9a0a	d8 	. 
	defb 00ah		;9a0b	0a 	. 
	defb 02bh		;9a0c	2b 	+ 
	defb 080h		;9a0d	80 	. 
	defb 066h		;9a0e	66 	f 
	defb 068h		;9a0f	68 	h 
	defb 008h		;9a10	08 	. 
	defb 02ch		;9a11	2c 	, 
	defb 000h		;9a12	00 	. 
	defb 036h		;9a13	36 	6 
	defb 080h		;9a14	80 	. 
	defb 004h		;9a15	04 	. 
	defb 02ch		;9a16	2c 	, 
	defb 020h		;9a17	20 	  
	defb 036h		;9a18	36 	6 
	defb 0e8h		;9a19	e8 	. 
	defb 008h		;9a1a	08 	. 
	defb 02ch		;9a1b	2c 	, 
	defb 080h		;9a1c	80 	. 
	defb 066h		;9a1d	66 	f 
	defb 070h		;9a1e	70 	p 
	defb 008h		;9a1f	08 	. 
	defb 02dh		;9a20	2d 	- 
	defb 000h		;9a21	00 	. 
	defb 02eh		;9a22	2e 	. 
	defb 080h		;9a23	80 	. 
	defb 004h		;9a24	04 	. 
	defb 02dh		;9a25	2d 	- 
	defb 020h		;9a26	20 	  
	defb 02eh		;9a27	2e 	. 
	defb 0e8h		;9a28	e8 	. 
	defb 008h		;9a29	08 	. 
	defb 02dh		;9a2a	2d 	- 
	defb 080h		;9a2b	80 	. 
	defb 066h		;9a2c	66 	f 
	defb 080h		;9a2d	80 	. 
	defb 008h		;9a2e	08 	. 
	defb 02eh		;9a2f	2e 	. 
	defb 001h		;9a30	01 	. 
	defb 014h		;9a31	14 	. 
	defb 085h		;9a32	85 	. 
	defb 087h		;9a33	87 	. 
	defb 02eh		;9a34	2e 	. 
	defb 021h		;9a35	21 	! 
	defb 014h		;9a36	14 	. 
	defb 0edh		;9a37	ed 	. 
	defb 08bh		;9a38	8b 	. 
	defb 02eh		;9a39	2e 	. 
	defb 080h		;9a3a	80 	. 
	defb 067h		;9a3b	67 	g 
	defb 040h		;9a3c	40 	@ 
	defb 00fh		;9a3d	0f 	. 
	defb 02eh		;9a3e	2e 	. 
	defb 0a4h		;9a3f	a4 	. 
	defb 067h		;9a40	67 	g 
	defb 070h		;9a41	70 	p 
	defb 017h		;9a42	17 	. 
	defb 02fh		;9a43	2f 	/ 
	defb 000h		;9a44	00 	. 
	defb 02ah		;9a45	2a 	* 
	defb 000h		;9a46	00 	. 
	defb 004h		;9a47	04 	. 
	defb 02fh		;9a48	2f 	/ 
	defb 080h		;9a49	80 	. 
	defb 066h		;9a4a	66 	f 
	defb 048h		;9a4b	48 	H 
	defb 008h		;9a4c	08 	. 
	defb 030h		;9a4d	30 	0 
	defb 003h		;9a4e	03 	. 
	defb 012h		;9a4f	12 	. 
	defb 0fdh		;9a50	fd 	. 
	defb 087h		;9a51	87 	. 
	defb 030h		;9a52	30 	0 
	defb 080h		;9a53	80 	. 
	defb 09ah		;9a54	9a 	. 
	defb 050h		;9a55	50 	P 
	defb 008h		;9a56	08 	. 
	defb 031h		;9a57	31 	1 
	defb 002h		;9a58	02 	. 
	defb 015h		;9a59	15 	. 
	defb 01dh		;9a5a	1d 	. 
	defb 08ah		;9a5b	8a 	. 
	defb 031h		;9a5c	31 	1 
	defb 080h		;9a5d	80 	. 
	defb 09ah		;9a5e	9a 	. 
	defb 058h		;9a5f	58 	X 
	defb 008h		;9a60	08 	. 
	defb 032h		;9a61	32 	2 
	defb 002h		;9a62	02 	. 
	defb 015h		;9a63	15 	. 
	defb 069h		;9a64	69 	i 
	defb 02dh		;9a65	2d 	- 
	defb 032h		;9a66	32 	2 
	defb 080h		;9a67	80 	. 
	defb 09ah		;9a68	9a 	. 
	defb 060h		;9a69	60 	` 
	defb 008h		;9a6a	08 	. 
	defb 033h		;9a6b	33 	3 
	defb 000h		;9a6c	00 	. 
	defb 037h		;9a6d	37 	7 
	defb 018h		;9a6e	18 	. 
	defb 006h		;9a6f	06 	. 
	defb 033h		;9a70	33 	3 
	defb 080h		;9a71	80 	. 
	defb 09ah		;9a72	9a 	. 
	defb 068h		;9a73	68 	h 
	defb 008h		;9a74	08 	. 
	defb 034h		;9a75	34 	4 
	defb 000h		;9a76	00 	. 
	defb 037h		;9a77	37 	7 
	defb 040h		;9a78	40 	@ 
	defb 00bh		;9a79	0b 	. 
	defb 034h		;9a7a	34 	4 
	defb 024h		;9a7b	24 	$ 
	defb 037h		;9a7c	37 	7 
	defb 070h		;9a7d	70 	p 
	defb 017h		;9a7e	17 	. 
	defb 034h		;9a7f	34 	4 
	defb 080h		;9a80	80 	. 
	defb 09ah		;9a81	9a 	. 
	defb 070h		;9a82	70 	p 
	defb 008h		;9a83	08 	. 
	defb 035h		;9a84	35 	5 
	defb 000h		;9a85	00 	. 
	defb 02fh		;9a86	2f 	/ 
	defb 040h		;9a87	40 	@ 
	defb 00bh		;9a88	0b 	. 
	defb 035h		;9a89	35 	5 
	defb 024h		;9a8a	24 	$ 
	defb 02fh		;9a8b	2f 	/ 
	defb 070h		;9a8c	70 	p 
	defb 017h		;9a8d	17 	. 
	defb 035h		;9a8e	35 	5 
	defb 080h		;9a8f	80 	. 
	defb 09ah		;9a90	9a 	. 
	defb 080h		;9a91	80 	. 
	defb 008h		;9a92	08 	. 
	defb 036h		;9a93	36 	6 
	defb 001h		;9a94	01 	. 
	defb 015h		;9a95	15 	. 
	defb 045h		;9a96	45 	E 
	defb 08ah		;9a97	8a 	. 
	defb 036h		;9a98	36 	6 
	defb 025h		;9a99	25 	% 
	defb 015h		;9a9a	15 	. 
	defb 075h		;9a9b	75 	u 
	defb 093h		;9a9c	93 	. 
	defb 036h		;9a9d	36 	6 
	defb 080h		;9a9e	80 	. 
	defb 09bh		;9a9f	9b 	. 
	defb 040h		;9aa0	40 	@ 
	defb 00fh		;9aa1	0f 	. 
	defb 036h		;9aa2	36 	6 
	defb 0a4h		;9aa3	a4 	. 
	defb 09bh		;9aa4	9b 	. 
	defb 070h		;9aa5	70 	p 
	defb 017h		;9aa6	17 	. 
	defb 037h		;9aa7	37 	7 
	defb 000h		;9aa8	00 	. 
	defb 060h		;9aa9	60 	` 
	defb 000h		;9aaa	00 	. 
	defb 004h		;9aab	04 	. 
	defb 037h		;9aac	37 	7 
	defb 080h		;9aad	80 	. 
	defb 09ah		;9aae	9a 	. 
	defb 048h		;9aaf	48 	H 
	defb 008h		;9ab0	08 	. 
	defb 038h		;9ab1	38 	8 
	defb 003h		;9ab2	03 	. 
	defb 012h		;9ab3	12 	. 
	defb 05dh		;9ab4	5d 	] 
	defb 087h		;9ab5	87 	. 
	defb 038h		;9ab6	38 	8 
	defb 080h		;9ab7	80 	. 
	defb 068h		;9ab8	68 	h 
	defb 050h		;9ab9	50 	P 
	defb 008h		;9aba	08 	. 
	defb 039h		;9abb	39 	9 
	defb 000h		;9abc	00 	. 
	defb 01eh		;9abd	1e 	. 
	defb 0c4h		;9abe	c4 	. 
	defb 06bh		;9abf	6b 	k 
	defb 039h		;9ac0	39 	9 
	defb 020h		;9ac1	20 	  
	defb 01eh		;9ac2	1e 	. 
	defb 0dch		;9ac3	dc 	. 
	defb 06fh		;9ac4	6f 	o 
	defb 039h		;9ac5	39 	9 
	defb 080h		;9ac6	80 	. 
	defb 068h		;9ac7	68 	h 
	defb 058h		;9ac8	58 	X 
	defb 008h		;9ac9	08 	. 
	defb 03ah		;9aca	3a 	: 
	defb 002h		;9acb	02 	. 
	defb 014h		;9acc	14 	. 
	defb 04dh		;9acd	4d 	M 
	defb 0adh		;9ace	ad 	. 
	defb 03ah		;9acf	3a 	: 
	defb 080h		;9ad0	80 	. 
	defb 068h		;9ad1	68 	h 
	defb 060h		;9ad2	60 	` 
	defb 008h		;9ad3	08 	. 
	defb 03bh		;9ad4	3b 	; 
	defb 000h		;9ad5	00 	. 
	defb 02fh		;9ad6	2f 	/ 
	defb 018h		;9ad7	18 	. 
	defb 006h		;9ad8	06 	. 
	defb 03bh		;9ad9	3b 	; 
	defb 080h		;9ada	80 	. 
	defb 068h		;9adb	68 	h 
	defb 068h		;9adc	68 	h 
	defb 008h		;9add	08 	. 
	defb 03ch		;9ade	3c 	< 
	defb 000h		;9adf	00 	. 
	defb 036h		;9ae0	36 	6 
	defb 048h		;9ae1	48 	H 
	defb 004h		;9ae2	04 	. 
	defb 03ch		;9ae3	3c 	< 
	defb 080h		;9ae4	80 	. 
	defb 068h		;9ae5	68 	h 
	defb 070h		;9ae6	70 	p 
	defb 008h		;9ae7	08 	. 
	defb 03dh		;9ae8	3d 	= 
	defb 000h		;9ae9	00 	. 
	defb 02eh		;9aea	2e 	. 
	defb 048h		;9aeb	48 	H 
	defb 004h		;9aec	04 	. 
	defb 03dh		;9aed	3d 	= 
	defb 080h		;9aee	80 	. 
	defb 068h		;9aef	68 	h 
	defb 080h		;9af0	80 	. 
	defb 008h		;9af1	08 	. 
	defb 03eh		;9af2	3e 	> 
	defb 001h		;9af3	01 	. 
	defb 014h		;9af4	14 	. 
	defb 04dh		;9af5	4d 	M 
	defb 087h		;9af6	87 	. 
	defb 03eh		;9af7	3e 	> 
	defb 080h		;9af8	80 	. 
	defb 069h		;9af9	69 	i 
	defb 040h		;9afa	40 	@ 
	defb 00fh		;9afb	0f 	. 
	defb 03eh		;9afc	3e 	> 
	defb 0a4h		;9afd	a4 	. 
	defb 069h		;9afe	69 	i 
	defb 070h		;9aff	70 	p 
	defb 017h		;9b00	17 	. 
	defb 03fh		;9b01	3f 	? 
	defb 000h		;9b02	00 	. 
	defb 024h		;9b03	24 	$ 
	defb 000h		;9b04	00 	. 
	defb 004h		;9b05	04 	. 
	defb 03fh		;9b06	3f 	? 
	defb 080h		;9b07	80 	. 
	defb 068h		;9b08	68 	h 
	defb 048h		;9b09	48 	H 
	defb 008h		;9b0a	08 	. 
	defb 040h		;9b0b	40 	@ 
	defb 000h		;9b0c	00 	. 
	defb 014h		;9b0d	14 	. 
	defb 051h		;9b0e	51 	Q 
	defb 044h		;9b0f	44 	D 
	defb 040h		;9b10	40 	@ 
	defb 040h		;9b11	40 	@ 
	defb 00eh		;9b12	0e 	. 
	defb 054h		;9b13	54 	T 
	defb 08ch		;9b14	8c 	. 
	defb 040h		;9b15	40 	@ 
	defb 080h		;9b16	80 	. 
	defb 022h		;9b17	22 	" 
	defb 009h		;9b18	09 	. 
	defb 048h		;9b19	48 	H 
	defb 041h		;9b1a	41 	A 
	defb 000h		;9b1b	00 	. 
	defb 014h		;9b1c	14 	. 
	defb 051h		;9b1d	51 	Q 
	defb 064h		;9b1e	64 	d 
	defb 041h		;9b1f	41 	A 
	defb 040h		;9b20	40 	@ 
	defb 047h		;9b21	47 	G 
	defb 021h		;9b22	21 	! 
	defb 04ch		;9b23	4c 	L 
	defb 041h		;9b24	41 	A 
	defb 080h		;9b25	80 	. 
	defb 022h		;9b26	22 	" 
	defb 009h		;9b27	09 	. 
	defb 068h		;9b28	68 	h 
	defb 042h		;9b29	42 	B 
	defb 000h		;9b2a	00 	. 
	defb 014h		;9b2b	14 	. 
	defb 051h		;9b2c	51 	Q 
	defb 084h		;9b2d	84 	. 
	defb 042h		;9b2e	42 	B 
	defb 040h		;9b2f	40 	@ 
	defb 05eh		;9b30	5e 	^ 
	defb 0c2h		;9b31	c2 	. 
	defb 0cfh		;9b32	cf 	. 
	defb 042h		;9b33	42 	B 
	defb 080h		;9b34	80 	. 
	defb 022h		;9b35	22 	" 
	defb 009h		;9b36	09 	. 
	defb 088h		;9b37	88 	. 
	defb 043h		;9b38	43 	C 
	defb 000h		;9b39	00 	. 
	defb 014h		;9b3a	14 	. 
	defb 051h		;9b3b	51 	Q 
	defb 0a4h		;9b3c	a4 	. 
	defb 043h		;9b3d	43 	C 
	defb 042h		;9b3e	42 	B 
	defb 015h		;9b3f	15 	. 
	defb 06ah		;9b40	6a 	j 
	defb 0d4h		;9b41	d4 	. 
	defb 043h		;9b42	43 	C 
	defb 080h		;9b43	80 	. 
	defb 022h		;9b44	22 	" 
	defb 009h		;9b45	09 	. 
	defb 0a8h		;9b46	a8 	. 
	defb 044h		;9b47	44 	D 
	defb 000h		;9b48	00 	. 
	defb 014h		;9b49	14 	. 
	defb 051h		;9b4a	51 	Q 
	defb 0c4h		;9b4b	c4 	. 
	defb 044h		;9b4c	44 	D 
	defb 020h		;9b4d	20 	  
	defb 014h		;9b4e	14 	. 
	defb 053h		;9b4f	53 	S 
	defb 028h		;9b50	28 	( 
	defb 044h		;9b51	44 	D 
	defb 040h		;9b52	40 	@ 
	defb 040h		;9b53	40 	@ 
	defb 000h		;9b54	00 	. 
	defb 008h		;9b55	08 	. 
	defb 044h		;9b56	44 	D 
	defb 080h		;9b57	80 	. 
	defb 022h		;9b58	22 	" 
	defb 009h		;9b59	09 	. 
	defb 0c8h		;9b5a	c8 	. 
	defb 045h		;9b5b	45 	E 
	defb 000h		;9b5c	00 	. 
	defb 014h		;9b5d	14 	. 
	defb 052h		;9b5e	52 	R 
	defb 004h		;9b5f	04 	. 
	defb 045h		;9b60	45 	E 
	defb 020h		;9b61	20 	  
	defb 014h		;9b62	14 	. 
	defb 053h		;9b63	53 	S 
	defb 0a8h		;9b64	a8 	. 
	defb 045h		;9b65	45 	E 
	defb 040h		;9b66	40 	@ 
	defb 094h		;9b67	94 	. 
	defb 000h		;9b68	00 	. 
	defb 00eh		;9b69	0e 	. 
	defb 045h		;9b6a	45 	E 
	defb 080h		;9b6b	80 	. 
	defb 022h		;9b6c	22 	" 
	defb 00ah		;9b6d	0a 	. 
	defb 008h		;9b6e	08 	. 
	defb 046h		;9b6f	46 	F 
	defb 000h		;9b70	00 	. 
	defb 014h		;9b71	14 	. 
	defb 055h		;9b72	55 	U 
	defb 007h		;9b73	07 	. 
	defb 046h		;9b74	46 	F 
	defb 024h		;9b75	24 	$ 
	defb 014h		;9b76	14 	. 
	defb 055h		;9b77	55 	U 
	defb 0d3h		;9b78	d3 	. 
	defb 046h		;9b79	46 	F 
	defb 040h		;9b7a	40 	@ 
	defb 00ch		;9b7b	0c 	. 
	defb 008h		;9b7c	08 	. 
	defb 008h		;9b7d	08 	. 
	defb 046h		;9b7e	46 	F 
	defb 080h		;9b7f	80 	. 
	defb 022h		;9b80	22 	" 
	defb 00dh		;9b81	0d 	. 
	defb 00ch		;9b82	0c 	. 
	defb 046h		;9b83	46 	F 
	defb 0a4h		;9b84	a4 	. 
	defb 022h		;9b85	22 	" 
	defb 00dh		;9b86	0d 	. 
	defb 0d4h		;9b87	d4 	. 
	defb 047h		;9b88	47 	G 
	defb 000h		;9b89	00 	. 
	defb 014h		;9b8a	14 	. 
	defb 051h		;9b8b	51 	Q 
	defb 024h		;9b8c	24 	$ 
	defb 047h		;9b8d	47 	G 
	defb 040h		;9b8e	40 	@ 
	defb 014h		;9b8f	14 	. 
	defb 079h		;9b90	79 	y 
	defb 029h		;9b91	29 	) 
	defb 047h		;9b92	47 	G 
	defb 080h		;9b93	80 	. 
	defb 022h		;9b94	22 	" 
	defb 009h		;9b95	09 	. 
	defb 028h		;9b96	28 	( 
	defb 048h		;9b97	48 	H 
	defb 000h		;9b98	00 	. 
	defb 014h		;9b99	14 	. 
	defb 059h		;9b9a	59 	Y 
	defb 044h		;9b9b	44 	D 
	defb 048h		;9b9c	48 	H 
	defb 040h		;9b9d	40 	@ 
	defb 00eh		;9b9e	0e 	. 
	defb 05ch		;9b9f	5c 	\ 
	defb 08ch		;9ba0	8c 	. 
	defb 048h		;9ba1	48 	H 
	defb 080h		;9ba2	80 	. 
	defb 022h		;9ba3	22 	" 
	defb 011h		;9ba4	11 	. 
	defb 048h		;9ba5	48 	H 
	defb 049h		;9ba6	49 	I 
	defb 000h		;9ba7	00 	. 
	defb 014h		;9ba8	14 	. 
	defb 059h		;9ba9	59 	Y 
	defb 064h		;9baa	64 	d 
	defb 049h		;9bab	49 	I 
	defb 040h		;9bac	40 	@ 
	defb 047h		;9bad	47 	G 
	defb 021h		;9bae	21 	! 
	defb 06ch		;9baf	6c 	l 
	defb 049h		;9bb0	49 	I 
	defb 080h		;9bb1	80 	. 
	defb 022h		;9bb2	22 	" 
	defb 011h		;9bb3	11 	. 
	defb 068h		;9bb4	68 	h 
	defb 04ah		;9bb5	4a 	J 
	defb 000h		;9bb6	00 	. 
	defb 014h		;9bb7	14 	. 
	defb 059h		;9bb8	59 	Y 
	defb 084h		;9bb9	84 	. 
	defb 04ah		;9bba	4a 	J 
	defb 040h		;9bbb	40 	@ 
	defb 01ch		;9bbc	1c 	. 
	defb 0c2h		;9bbd	c2 	. 
	defb 0cfh		;9bbe	cf 	. 
	defb 04ah		;9bbf	4a 	J 
	defb 080h		;9bc0	80 	. 
	defb 022h		;9bc1	22 	" 
	defb 011h		;9bc2	11 	. 
	defb 088h		;9bc3	88 	. 
	defb 04bh		;9bc4	4b 	K 
	defb 000h		;9bc5	00 	. 
	defb 014h		;9bc6	14 	. 
	defb 059h		;9bc7	59 	Y 
	defb 0a4h		;9bc8	a4 	. 
	defb 04bh		;9bc9	4b 	K 
	defb 042h		;9bca	42 	B 
	defb 014h		;9bcb	14 	. 
	defb 0b5h		;9bcc	b5 	. 
	defb 0b4h		;9bcd	b4 	. 
	defb 04bh		;9bce	4b 	K 
	defb 080h		;9bcf	80 	. 
	defb 022h		;9bd0	22 	" 
	defb 011h		;9bd1	11 	. 
	defb 0a8h		;9bd2	a8 	. 
	defb 04ch		;9bd3	4c 	L 
	defb 000h		;9bd4	00 	. 
	defb 014h		;9bd5	14 	. 
	defb 059h		;9bd6	59 	Y 
	defb 0c4h		;9bd7	c4 	. 
	defb 04ch		;9bd8	4c 	L 
	defb 020h		;9bd9	20 	  
	defb 014h		;9bda	14 	. 
	defb 05bh		;9bdb	5b 	[ 
	defb 028h		;9bdc	28 	( 
	defb 04ch		;9bdd	4c 	L 
	defb 080h		;9bde	80 	. 
	defb 022h		;9bdf	22 	" 
	defb 011h		;9be0	11 	. 
	defb 0c8h		;9be1	c8 	. 
	defb 04dh		;9be2	4d 	M 
	defb 000h		;9be3	00 	. 
	defb 014h		;9be4	14 	. 
	defb 05ah		;9be5	5a 	Z 
	defb 004h		;9be6	04 	. 
	defb 04dh		;9be7	4d 	M 
	defb 020h		;9be8	20 	  
	defb 014h		;9be9	14 	. 
	defb 05bh		;9bea	5b 	[ 
	defb 0a8h		;9beb	a8 	. 
	defb 04dh		;9bec	4d 	M 
	defb 040h		;9bed	40 	@ 
	defb 092h		;9bee	92 	. 
	defb 000h		;9bef	00 	. 
	defb 00eh		;9bf0	0e 	. 
	defb 04dh		;9bf1	4d 	M 
	defb 080h		;9bf2	80 	. 
	defb 022h		;9bf3	22 	" 
	defb 012h		;9bf4	12 	. 
	defb 008h		;9bf5	08 	. 
	defb 04eh		;9bf6	4e 	N 
	defb 000h		;9bf7	00 	. 
	defb 014h		;9bf8	14 	. 
	defb 05dh		;9bf9	5d 	] 
	defb 007h		;9bfa	07 	. 
	defb 04eh		;9bfb	4e 	N 
	defb 024h		;9bfc	24 	$ 
	defb 014h		;9bfd	14 	. 
	defb 05dh		;9bfe	5d 	] 
	defb 0d3h		;9bff	d3 	. 
	defb 04eh		;9c00	4e 	N 
	defb 080h		;9c01	80 	. 
	defb 022h		;9c02	22 	" 
	defb 015h		;9c03	15 	. 
	defb 00ch		;9c04	0c 	. 
	defb 04eh		;9c05	4e 	N 
	defb 0a4h		;9c06	a4 	. 
	defb 022h		;9c07	22 	" 
	defb 015h		;9c08	15 	. 
	defb 0d4h		;9c09	d4 	. 
	defb 04fh		;9c0a	4f 	O 
	defb 000h		;9c0b	00 	. 
	defb 014h		;9c0c	14 	. 
	defb 059h		;9c0d	59 	Y 
	defb 024h		;9c0e	24 	$ 
	defb 04fh		;9c0f	4f 	O 
	defb 040h		;9c10	40 	@ 
	defb 014h		;9c11	14 	. 
	defb 099h		;9c12	99 	. 
	defb 029h		;9c13	29 	) 
	defb 04fh		;9c14	4f 	O 
	defb 080h		;9c15	80 	. 
	defb 022h		;9c16	22 	" 
	defb 011h		;9c17	11 	. 
	defb 028h		;9c18	28 	( 
	defb 050h		;9c19	50 	P 
	defb 000h		;9c1a	00 	. 
	defb 014h		;9c1b	14 	. 
	defb 061h		;9c1c	61 	a 
	defb 044h		;9c1d	44 	D 
	defb 050h		;9c1e	50 	P 
	defb 040h		;9c1f	40 	@ 
	defb 00eh		;9c20	0e 	. 
	defb 064h		;9c21	64 	d 
	defb 08ch		;9c22	8c 	. 
	defb 050h		;9c23	50 	P 
	defb 080h		;9c24	80 	. 
	defb 022h		;9c25	22 	" 
	defb 019h		;9c26	19 	. 
	defb 048h		;9c27	48 	H 
l9c28h:
	defb 051h		;9c28	51 	Q 
	defb 000h		;9c29	00 	. 
	defb 014h		;9c2a	14 	. 
	defb 061h		;9c2b	61 	a 
	defb 064h		;9c2c	64 	d 
	defb 051h		;9c2d	51 	Q 
	defb 040h		;9c2e	40 	@ 
	defb 047h		;9c2f	47 	G 
	defb 021h		;9c30	21 	! 
	defb 08ch		;9c31	8c 	. 
	defb 051h		;9c32	51 	Q 
	defb 080h		;9c33	80 	. 
	defb 022h		;9c34	22 	" 
	defb 019h		;9c35	19 	. 
	defb 068h		;9c36	68 	h 
	defb 052h		;9c37	52 	R 
l9c38h:
	defb 000h		;9c38	00 	. 
	defb 014h		;9c39	14 	. 
	defb 061h		;9c3a	61 	a 
	defb 084h		;9c3b	84 	. 
	defb 052h		;9c3c	52 	R 
	defb 040h		;9c3d	40 	@ 
	defb 05eh		;9c3e	5e 	^ 
	defb 0c2h		;9c3f	c2 	. 
	defb 0efh		;9c40	ef 	. 
	defb 052h		;9c41	52 	R 
	defb 080h		;9c42	80 	. 
	defb 022h		;9c43	22 	" 
	defb 019h		;9c44	19 	. 
	defb 088h		;9c45	88 	. 
	defb 053h		;9c46	53 	S 
	defb 000h		;9c47	00 	. 
	defb 014h		;9c48	14 	. 
	defb 061h		;9c49	61 	a 
	defb 0a4h		;9c4a	a4 	. 
	defb 053h		;9c4b	53 	S 
	defb 042h		;9c4c	42 	B 
	defb 015h		;9c4d	15 	. 
	defb 06ah		;9c4e	6a 	j 
	defb 0f4h		;9c4f	f4 	. 
	defb 053h		;9c50	53 	S 
	defb 080h		;9c51	80 	. 
	defb 022h		;9c52	22 	" 
	defb 019h		;9c53	19 	. 
	defb 0a8h		;9c54	a8 	. 
	defb 054h		;9c55	54 	T 
	defb 000h		;9c56	00 	. 
	defb 014h		;9c57	14 	. 
	defb 061h		;9c58	61 	a 
	defb 0c4h		;9c59	c4 	. 
	defb 054h		;9c5a	54 	T 
	defb 020h		;9c5b	20 	  
	defb 014h		;9c5c	14 	. 
	defb 063h		;9c5d	63 	c 
	defb 028h		;9c5e	28 	( 
	defb 054h		;9c5f	54 	T 
	defb 080h		;9c60	80 	. 
	defb 022h		;9c61	22 	" 
	defb 019h		;9c62	19 	. 
	defb 0c8h		;9c63	c8 	. 
	defb 055h		;9c64	55 	U 
	defb 000h		;9c65	00 	. 
	defb 014h		;9c66	14 	. 
	defb 062h		;9c67	62 	b 
	defb 004h		;9c68	04 	. 
	defb 055h		;9c69	55 	U 
	defb 020h		;9c6a	20 	  
	defb 014h		;9c6b	14 	. 
	defb 063h		;9c6c	63 	c 
	defb 0a8h		;9c6d	a8 	. 
	defb 055h		;9c6e	55 	U 
	defb 080h		;9c6f	80 	. 
	defb 022h		;9c70	22 	" 
	defb 01ah		;9c71	1a 	. 
	defb 008h		;9c72	08 	. 
	defb 056h		;9c73	56 	V 
	defb 000h		;9c74	00 	. 
	defb 014h		;9c75	14 	. 
	defb 065h		;9c76	65 	e 
	defb 007h		;9c77	07 	. 
	defb 056h		;9c78	56 	V 
	defb 024h		;9c79	24 	$ 
	defb 014h		;9c7a	14 	. 
	defb 065h		;9c7b	65 	e 
	defb 0d3h		;9c7c	d3 	. 
	defb 056h		;9c7d	56 	V 
	defb 040h		;9c7e	40 	@ 
	defb 00ch		;9c7f	0c 	. 
	defb 010h		;9c80	10 	. 
	defb 008h		;9c81	08 	. 
	defb 056h		;9c82	56 	V 
	defb 080h		;9c83	80 	. 
	defb 022h		;9c84	22 	" 
	defb 01dh		;9c85	1d 	. 
	defb 00ch		;9c86	0c 	. 
	defb 056h		;9c87	56 	V 
	defb 0a4h		;9c88	a4 	. 
	defb 022h		;9c89	22 	" 
	defb 01dh		;9c8a	1d 	. 
	defb 0d4h		;9c8b	d4 	. 
	defb 057h		;9c8c	57 	W 
	defb 000h		;9c8d	00 	. 
	defb 014h		;9c8e	14 	. 
	defb 061h		;9c8f	61 	a 
	defb 024h		;9c90	24 	$ 
	defb 057h		;9c91	57 	W 
	defb 040h		;9c92	40 	@ 
	defb 014h		;9c93	14 	. 
	defb 049h		;9c94	49 	I 
	defb 0e9h		;9c95	e9 	. 
	defb 057h		;9c96	57 	W 
	defb 080h		;9c97	80 	. 
	defb 022h		;9c98	22 	" 
	defb 019h		;9c99	19 	. 
	defb 028h		;9c9a	28 	( 
	defb 058h		;9c9b	58 	X 
	defb 000h		;9c9c	00 	. 
	defb 014h		;9c9d	14 	. 
	defb 069h		;9c9e	69 	i 
	defb 044h		;9c9f	44 	D 
	defb 058h		;9ca0	58 	X 
	defb 040h		;9ca1	40 	@ 
	defb 00eh		;9ca2	0e 	. 
	defb 06ch		;9ca3	6c 	l 
	defb 08ch		;9ca4	8c 	. 
	defb 058h		;9ca5	58 	X 
	defb 080h		;9ca6	80 	. 
	defb 022h		;9ca7	22 	" 
	defb 021h		;9ca8	21 	! 
	defb 048h		;9ca9	48 	H 
	defb 059h		;9caa	59 	Y 
	defb 000h		;9cab	00 	. 
	defb 014h		;9cac	14 	. 
	defb 069h		;9cad	69 	i 
	defb 064h		;9cae	64 	d 
	defb 059h		;9caf	59 	Y 
	defb 040h		;9cb0	40 	@ 
	defb 047h		;9cb1	47 	G 
	defb 021h		;9cb2	21 	! 
	defb 0ach		;9cb3	ac 	. 
	defb 059h		;9cb4	59 	Y 
	defb 080h		;9cb5	80 	. 
	defb 022h		;9cb6	22 	" 
	defb 021h		;9cb7	21 	! 
	defb 068h		;9cb8	68 	h 
	defb 05ah		;9cb9	5a 	Z 
	defb 000h		;9cba	00 	. 
	defb 014h		;9cbb	14 	. 
	defb 069h		;9cbc	69 	i 
	defb 084h		;9cbd	84 	. 
	defb 05ah		;9cbe	5a 	Z 
	defb 040h		;9cbf	40 	@ 
	defb 01ch		;9cc0	1c 	. 
	defb 0c2h		;9cc1	c2 	. 
	defb 0efh		;9cc2	ef 	. 
	defb 05ah		;9cc3	5a 	Z 
	defb 080h		;9cc4	80 	. 
	defb 022h		;9cc5	22 	" 
	defb 021h		;9cc6	21 	! 
	defb 088h		;9cc7	88 	. 
	defb 05bh		;9cc8	5b 	[ 
	defb 000h		;9cc9	00 	. 
	defb 014h		;9cca	14 	. 
	defb 069h		;9ccb	69 	i 
	defb 0a4h		;9ccc	a4 	. 
	defb 05bh		;9ccd	5b 	[ 
	defb 042h		;9cce	42 	B 
	defb 014h		;9ccf	14 	. 
	defb 0bdh		;9cd0	bd 	. 
	defb 0b4h		;9cd1	b4 	. 
	defb 05bh		;9cd2	5b 	[ 
	defb 080h		;9cd3	80 	. 
	defb 022h		;9cd4	22 	" 
	defb 021h		;9cd5	21 	! 
	defb 0a8h		;9cd6	a8 	. 
	defb 05ch		;9cd7	5c 	\ 
	defb 000h		;9cd8	00 	. 
	defb 014h		;9cd9	14 	. 
	defb 069h		;9cda	69 	i 
	defb 0c4h		;9cdb	c4 	. 
	defb 05ch		;9cdc	5c 	\ 
	defb 020h		;9cdd	20 	  
	defb 014h		;9cde	14 	. 
	defb 06bh		;9cdf	6b 	k 
	defb 028h		;9ce0	28 	( 
	defb 05ch		;9ce1	5c 	\ 
	defb 080h		;9ce2	80 	. 
	defb 022h		;9ce3	22 	" 
	defb 021h		;9ce4	21 	! 
	defb 0c8h		;9ce5	c8 	. 
	defb 05dh		;9ce6	5d 	] 
	defb 000h		;9ce7	00 	. 
	defb 014h		;9ce8	14 	. 
	defb 06ah		;9ce9	6a 	j 
	defb 004h		;9cea	04 	. 
	defb 05dh		;9ceb	5d 	] 
	defb 020h		;9cec	20 	  
	defb 014h		;9ced	14 	. 
	defb 06bh		;9cee	6b 	k 
	defb 0a8h		;9cef	a8 	. 
	defb 05dh		;9cf0	5d 	] 
	defb 080h		;9cf1	80 	. 
	defb 022h		;9cf2	22 	" 
	defb 022h		;9cf3	22 	" 
	defb 008h		;9cf4	08 	. 
	defb 05eh		;9cf5	5e 	^ 
	defb 000h		;9cf6	00 	. 
	defb 014h		;9cf7	14 	. 
	defb 06dh		;9cf8	6d 	m 
	defb 007h		;9cf9	07 	. 
	defb 05eh		;9cfa	5e 	^ 
	defb 024h		;9cfb	24 	$ 
	defb 014h		;9cfc	14 	. 
	defb 06dh		;9cfd	6d 	m 
	defb 0d3h		;9cfe	d3 	. 
	defb 05eh		;9cff	5e 	^ 
	defb 040h		;9d00	40 	@ 
	defb 00ch		;9d01	0c 	. 
	defb 018h		;9d02	18 	. 
	defb 008h		;9d03	08 	. 
	defb 05eh		;9d04	5e 	^ 
	defb 080h		;9d05	80 	. 
	defb 022h		;9d06	22 	" 
	defb 025h		;9d07	25 	% 
	defb 00ch		;9d08	0c 	. 
	defb 05eh		;9d09	5e 	^ 
	defb 0a4h		;9d0a	a4 	. 
	defb 022h		;9d0b	22 	" 
	defb 025h		;9d0c	25 	% 
	defb 0d4h		;9d0d	d4 	. 
	defb 05fh		;9d0e	5f 	_ 
	defb 000h		;9d0f	00 	. 
	defb 014h		;9d10	14 	. 
	defb 069h		;9d11	69 	i 
	defb 024h		;9d12	24 	$ 
	defb 05fh		;9d13	5f 	_ 
	defb 040h		;9d14	40 	@ 
	defb 014h		;9d15	14 	. 
	defb 04ah		;9d16	4a 	J 
	defb 069h		;9d17	69 	i 
	defb 05fh		;9d18	5f 	_ 
	defb 080h		;9d19	80 	. 
	defb 022h		;9d1a	22 	" 
	defb 021h		;9d1b	21 	! 
	defb 028h		;9d1c	28 	( 
	defb 060h		;9d1d	60 	` 
	defb 000h		;9d1e	00 	. 
	defb 014h		;9d1f	14 	. 
	defb 071h		;9d20	71 	q 
	defb 044h		;9d21	44 	D 
	defb 060h		;9d22	60 	` 
	defb 020h		;9d23	20 	  
	defb 014h		;9d24	14 	. 
	defb 0c9h		;9d25	c9 	. 
	defb 048h		;9d26	48 	H 
	defb 060h		;9d27	60 	` 
	defb 040h		;9d28	40 	@ 
	defb 00eh		;9d29	0e 	. 
	defb 074h		;9d2a	74 	t 
	defb 08ch		;9d2b	8c 	. 
	defb 060h		;9d2c	60 	` 
	defb 080h		;9d2d	80 	. 
	defb 022h		;9d2e	22 	" 
	defb 029h		;9d2f	29 	) 
	defb 048h		;9d30	48 	H 
	defb 061h		;9d31	61 	a 
	defb 000h		;9d32	00 	. 
	defb 014h		;9d33	14 	. 
	defb 071h		;9d34	71 	q 
	defb 064h		;9d35	64 	d 
	defb 061h		;9d36	61 	a 
	defb 020h		;9d37	20 	  
	defb 014h		;9d38	14 	. 
	defb 0c9h		;9d39	c9 	. 
	defb 068h		;9d3a	68 	h 
	defb 061h		;9d3b	61 	a 
	defb 040h		;9d3c	40 	@ 
	defb 047h		;9d3d	47 	G 
	defb 021h		;9d3e	21 	! 
	defb 0cch		;9d3f	cc 	. 
	defb 061h		;9d40	61 	a 
	defb 080h		;9d41	80 	. 
	defb 022h		;9d42	22 	" 
	defb 029h		;9d43	29 	) 
	defb 068h		;9d44	68 	h 
	defb 062h		;9d45	62 	b 
	defb 000h		;9d46	00 	. 
	defb 014h		;9d47	14 	. 
	defb 071h		;9d48	71 	q 
	defb 084h		;9d49	84 	. 
	defb 062h		;9d4a	62 	b 
	defb 020h		;9d4b	20 	  
	defb 014h		;9d4c	14 	. 
	defb 0c9h		;9d4d	c9 	. 
	defb 088h		;9d4e	88 	. 
	defb 062h		;9d4f	62 	b 
	defb 040h		;9d50	40 	@ 
	defb 05eh		;9d51	5e 	^ 
	defb 0c3h		;9d52	c3 	. 
	defb 00fh		;9d53	0f 	. 
	defb 062h		;9d54	62 	b 
	defb 080h		;9d55	80 	. 
	defb 022h		;9d56	22 	" 
	defb 029h		;9d57	29 	) 
	defb 088h		;9d58	88 	. 
	defb 063h		;9d59	63 	c 
	defb 000h		;9d5a	00 	. 
	defb 014h		;9d5b	14 	. 
	defb 071h		;9d5c	71 	q 
	defb 0a4h		;9d5d	a4 	. 
	defb 063h		;9d5e	63 	c 
	defb 020h		;9d5f	20 	  
	defb 014h		;9d60	14 	. 
	defb 0c9h		;9d61	c9 	. 
	defb 0a8h		;9d62	a8 	. 
	defb 063h		;9d63	63 	c 
	defb 042h		;9d64	42 	B 
	defb 015h		;9d65	15 	. 
	defb 06bh		;9d66	6b 	k 
	defb 014h		;9d67	14 	. 
	defb 063h		;9d68	63 	c 
	defb 080h		;9d69	80 	. 
	defb 022h		;9d6a	22 	" 
	defb 029h		;9d6b	29 	) 
	defb 0a8h		;9d6c	a8 	. 
	defb 064h		;9d6d	64 	d 
	defb 000h		;9d6e	00 	. 
	defb 014h		;9d6f	14 	. 
	defb 071h		;9d70	71 	q 
	defb 0c4h		;9d71	c4 	. 
	defb 064h		;9d72	64 	d 
	defb 020h		;9d73	20 	  
	defb 014h		;9d74	14 	. 
	defb 0cbh		;9d75	cb 	. 
	defb 028h		;9d76	28 	( 
	defb 064h		;9d77	64 	d 
	defb 080h		;9d78	80 	. 
	defb 022h		;9d79	22 	" 
	defb 029h		;9d7a	29 	) 
	defb 0c8h		;9d7b	c8 	. 
	defb 065h		;9d7c	65 	e 
	defb 000h		;9d7d	00 	. 
	defb 014h		;9d7e	14 	. 
	defb 072h		;9d7f	72 	r 
	defb 004h		;9d80	04 	. 
	defb 065h		;9d81	65 	e 
	defb 020h		;9d82	20 	  
	defb 014h		;9d83	14 	. 
	defb 0cbh		;9d84	cb 	. 
	defb 0a8h		;9d85	a8 	. 
	defb 065h		;9d86	65 	e 
	defb 080h		;9d87	80 	. 
	defb 022h		;9d88	22 	" 
	defb 02ah		;9d89	2a 	* 
	defb 008h		;9d8a	08 	. 
	defb 066h		;9d8b	66 	f 
	defb 000h		;9d8c	00 	. 
	defb 014h		;9d8d	14 	. 
	defb 075h		;9d8e	75 	u 
	defb 007h		;9d8f	07 	. 
	defb 066h		;9d90	66 	f 
	defb 024h		;9d91	24 	$ 
	defb 014h		;9d92	14 	. 
	defb 075h		;9d93	75 	u 
	defb 0d3h		;9d94	d3 	. 
	defb 066h		;9d95	66 	f 
	defb 080h		;9d96	80 	. 
	defb 022h		;9d97	22 	" 
	defb 02dh		;9d98	2d 	- 
	defb 00ch		;9d99	0c 	. 
	defb 066h		;9d9a	66 	f 
	defb 0a4h		;9d9b	a4 	. 
	defb 022h		;9d9c	22 	" 
	defb 02dh		;9d9d	2d 	- 
	defb 0d4h		;9d9e	d4 	. 
	defb 067h		;9d9f	67 	g 
	defb 000h		;9da0	00 	. 
	defb 014h		;9da1	14 	. 
	defb 071h		;9da2	71 	q 
	defb 024h		;9da3	24 	$ 
	defb 067h		;9da4	67 	g 
	defb 020h		;9da5	20 	  
	defb 014h		;9da6	14 	. 
	defb 0c9h		;9da7	c9 	. 
	defb 028h		;9da8	28 	( 
	defb 067h		;9da9	67 	g 
	defb 040h		;9daa	40 	@ 
	defb 05ah		;9dab	5a 	Z 
	defb 000h		;9dac	00 	. 
	defb 012h		;9dad	12 	. 
	defb 067h		;9dae	67 	g 
	defb 080h		;9daf	80 	. 
	defb 022h		;9db0	22 	" 
	defb 029h		;9db1	29 	) 
	defb 028h		;9db2	28 	( 
	defb 068h		;9db3	68 	h 
	defb 000h		;9db4	00 	. 
	defb 014h		;9db5	14 	. 
	defb 081h		;9db6	81 	. 
	defb 044h		;9db7	44 	D 
	defb 068h		;9db8	68 	h 
	defb 020h		;9db9	20 	  
	defb 014h		;9dba	14 	. 
	defb 0e9h		;9dbb	e9 	. 
	defb 048h		;9dbc	48 	H 
	defb 068h		;9dbd	68 	h 
	defb 040h		;9dbe	40 	@ 
	defb 00eh		;9dbf	0e 	. 
	defb 084h		;9dc0	84 	. 
	defb 08ch		;9dc1	8c 	. 
	defb 068h		;9dc2	68 	h 
	defb 080h		;9dc3	80 	. 
	defb 022h		;9dc4	22 	" 
	defb 031h		;9dc5	31 	1 
	defb 048h		;9dc6	48 	H 
	defb 069h		;9dc7	69 	i 
	defb 000h		;9dc8	00 	. 
	defb 014h		;9dc9	14 	. 
	defb 081h		;9dca	81 	. 
	defb 064h		;9dcb	64 	d 
	defb 069h		;9dcc	69 	i 
	defb 020h		;9dcd	20 	  
	defb 014h		;9dce	14 	. 
	defb 0e9h		;9dcf	e9 	. 
	defb 068h		;9dd0	68 	h 
	defb 069h		;9dd1	69 	i 
	defb 040h		;9dd2	40 	@ 
	defb 047h		;9dd3	47 	G 
	defb 022h		;9dd4	22 	" 
	defb 00ch		;9dd5	0c 	. 
	defb 069h		;9dd6	69 	i 
	defb 080h		;9dd7	80 	. 
	defb 022h		;9dd8	22 	" 
	defb 031h		;9dd9	31 	1 
	defb 068h		;9dda	68 	h 
	defb 06ah		;9ddb	6a 	j 
	defb 000h		;9ddc	00 	. 
	defb 014h		;9ddd	14 	. 
	defb 081h		;9dde	81 	. 
	defb 084h		;9ddf	84 	. 
	defb 06ah		;9de0	6a 	j 
	defb 020h		;9de1	20 	  
	defb 014h		;9de2	14 	. 
	defb 0e9h		;9de3	e9 	. 
	defb 088h		;9de4	88 	. 
	defb 06ah		;9de5	6a 	j 
	defb 040h		;9de6	40 	@ 
	defb 01ch		;9de7	1c 	. 
	defb 0c3h		;9de8	c3 	. 
	defb 00fh		;9de9	0f 	. 
	defb 06ah		;9dea	6a 	j 
	defb 080h		;9deb	80 	. 
	defb 022h		;9dec	22 	" 
	defb 031h		;9ded	31 	1 
	defb 088h		;9dee	88 	. 
	defb 06bh		;9def	6b 	k 
	defb 000h		;9df0	00 	. 
	defb 014h		;9df1	14 	. 
	defb 081h		;9df2	81 	. 
	defb 0a4h		;9df3	a4 	. 
	defb 06bh		;9df4	6b 	k 
	defb 020h		;9df5	20 	  
	defb 014h		;9df6	14 	. 
	defb 0e9h		;9df7	e9 	. 
	defb 0a8h		;9df8	a8 	. 
	defb 06bh		;9df9	6b 	k 
	defb 042h		;9dfa	42 	B 
	defb 014h		;9dfb	14 	. 
	defb 0c5h		;9dfc	c5 	. 
	defb 0b4h		;9dfd	b4 	. 
	defb 06bh		;9dfe	6b 	k 
	defb 080h		;9dff	80 	. 
l9e00h:
	defb 022h		;9e00	22 	" 
	defb 031h		;9e01	31 	1 
	defb 0a8h		;9e02	a8 	. 
	defb 06ch		;9e03	6c 	l 
	defb 000h		;9e04	00 	. 
	defb 014h		;9e05	14 	. 
	defb 081h		;9e06	81 	. 
	defb 0c4h		;9e07	c4 	. 
	defb 06ch		;9e08	6c 	l 
	defb 020h		;9e09	20 	  
	defb 014h		;9e0a	14 	. 
	defb 0ebh		;9e0b	eb 	. 
	defb 028h		;9e0c	28 	( 
	defb 06ch		;9e0d	6c 	l 
	defb 080h		;9e0e	80 	. 
	defb 022h		;9e0f	22 	" 
	defb 031h		;9e10	31 	1 
	defb 0c8h		;9e11	c8 	. 
	defb 06dh		;9e12	6d 	m 
	defb 000h		;9e13	00 	. 
	defb 014h		;9e14	14 	. 
	defb 082h		;9e15	82 	. 
	defb 004h		;9e16	04 	. 
	defb 06dh		;9e17	6d 	m 
	defb 020h		;9e18	20 	  
	defb 014h		;9e19	14 	. 
	defb 0ebh		;9e1a	eb 	. 
	defb 0a8h		;9e1b	a8 	. 
	defb 06dh		;9e1c	6d 	m 
	defb 080h		;9e1d	80 	. 
	defb 022h		;9e1e	22 	" 
	defb 032h		;9e1f	32 	2 
	defb 008h		;9e20	08 	. 
	defb 06eh		;9e21	6e 	n 
	defb 000h		;9e22	00 	. 
	defb 014h		;9e23	14 	. 
	defb 085h		;9e24	85 	. 
	defb 007h		;9e25	07 	. 
	defb 06eh		;9e26	6e 	n 
	defb 024h		;9e27	24 	$ 
	defb 014h		;9e28	14 	. 
	defb 085h		;9e29	85 	. 
	defb 0d3h		;9e2a	d3 	. 
	defb 06eh		;9e2b	6e 	n 
	defb 080h		;9e2c	80 	. 
	defb 022h		;9e2d	22 	" 
	defb 035h		;9e2e	35 	5 
	defb 00ch		;9e2f	0c 	. 
	defb 06eh		;9e30	6e 	n 
	defb 0a4h		;9e31	a4 	. 
	defb 022h		;9e32	22 	" 
	defb 035h		;9e33	35 	5 
	defb 0d4h		;9e34	d4 	. 
	defb 06fh		;9e35	6f 	o 
	defb 000h		;9e36	00 	. 
	defb 014h		;9e37	14 	. 
	defb 081h		;9e38	81 	. 
	defb 024h		;9e39	24 	$ 
	defb 06fh		;9e3a	6f 	o 
	defb 020h		;9e3b	20 	  
	defb 014h		;9e3c	14 	. 
	defb 0e9h		;9e3d	e9 	. 
	defb 028h		;9e3e	28 	( 
	defb 06fh		;9e3f	6f 	o 
	defb 040h		;9e40	40 	@ 
	defb 054h		;9e41	54 	T 
	defb 000h		;9e42	00 	. 
	defb 012h		;9e43	12 	. 
	defb 06fh		;9e44	6f 	o 
	defb 080h		;9e45	80 	. 
	defb 022h		;9e46	22 	" 
	defb 031h		;9e47	31 	1 
	defb 028h		;9e48	28 	( 
	defb 070h		;9e49	70 	p 
	defb 000h		;9e4a	00 	. 
	defb 015h		;9e4b	15 	. 
	defb 041h		;9e4c	41 	A 
	defb 047h		;9e4d	47 	G 
	defb 070h		;9e4e	70 	p 
	defb 024h		;9e4f	24 	$ 
	defb 015h		;9e50	15 	. 
	defb 071h		;9e51	71 	q 
	defb 053h		;9e52	53 	S 
	defb 070h		;9e53	70 	p 
	defb 080h		;9e54	80 	. 
	defb 022h		;9e55	22 	" 
	defb 039h		;9e56	39 	9 
	defb 048h		;9e57	48 	H 
	defb 071h		;9e58	71 	q 
	defb 000h		;9e59	00 	. 
	defb 015h		;9e5a	15 	. 
	defb 041h		;9e5b	41 	A 
	defb 067h		;9e5c	67 	g 
	defb 071h		;9e5d	71 	q 
	defb 024h		;9e5e	24 	$ 
	defb 015h		;9e5f	15 	. 
	defb 071h		;9e60	71 	q 
	defb 073h		;9e61	73 	s 
	defb 071h		;9e62	71 	q 
	defb 080h		;9e63	80 	. 
	defb 022h		;9e64	22 	" 
	defb 039h		;9e65	39 	9 
	defb 068h		;9e66	68 	h 
	defb 072h		;9e67	72 	r 
	defb 000h		;9e68	00 	. 
	defb 015h		;9e69	15 	. 
	defb 041h		;9e6a	41 	A 
	defb 087h		;9e6b	87 	. 
	defb 072h		;9e6c	72 	r 
	defb 024h		;9e6d	24 	$ 
	defb 015h		;9e6e	15 	. 
	defb 071h		;9e6f	71 	q 
	defb 093h		;9e70	93 	. 
	defb 072h		;9e71	72 	r 
	defb 040h		;9e72	40 	@ 
	defb 05eh		;9e73	5e 	^ 
	defb 0c4h		;9e74	c4 	. 
	defb 06fh		;9e75	6f 	o 
	defb 072h		;9e76	72 	r 
	defb 080h		;9e77	80 	. 
	defb 022h		;9e78	22 	" 
	defb 039h		;9e79	39 	9 
	defb 088h		;9e7a	88 	. 
	defb 073h		;9e7b	73 	s 
	defb 000h		;9e7c	00 	. 
	defb 015h		;9e7d	15 	. 
	defb 041h		;9e7e	41 	A 
	defb 0a7h		;9e7f	a7 	. 
	defb 073h		;9e80	73 	s 
	defb 024h		;9e81	24 	$ 
	defb 015h		;9e82	15 	. 
	defb 071h		;9e83	71 	q 
	defb 0b3h		;9e84	b3 	. 
	defb 073h		;9e85	73 	s 
	defb 042h		;9e86	42 	B 
	defb 015h		;9e87	15 	. 
	defb 06ch		;9e88	6c 	l 
	defb 074h		;9e89	74 	t 
	defb 073h		;9e8a	73 	s 
	defb 080h		;9e8b	80 	. 
	defb 022h		;9e8c	22 	" 
	defb 039h		;9e8d	39 	9 
	defb 0a8h		;9e8e	a8 	. 
	defb 074h		;9e8f	74 	t 
	defb 000h		;9e90	00 	. 
	defb 015h		;9e91	15 	. 
	defb 041h		;9e92	41 	A 
	defb 0c7h		;9e93	c7 	. 
	defb 074h		;9e94	74 	t 
	defb 024h		;9e95	24 	$ 
	defb 015h		;9e96	15 	. 
	defb 071h		;9e97	71 	q 
	defb 0d3h		;9e98	d3 	. 
	defb 074h		;9e99	74 	t 
	defb 080h		;9e9a	80 	. 
	defb 022h		;9e9b	22 	" 
	defb 039h		;9e9c	39 	9 
	defb 0c8h		;9e9d	c8 	. 
	defb 075h		;9e9e	75 	u 
	defb 000h		;9e9f	00 	. 
	defb 015h		;9ea0	15 	. 
	defb 042h		;9ea1	42 	B 
	defb 007h		;9ea2	07 	. 
	defb 075h		;9ea3	75 	u 
	defb 024h		;9ea4	24 	$ 
	defb 015h		;9ea5	15 	. 
	defb 072h		;9ea6	72 	r 
	defb 013h		;9ea7	13 	. 
	defb 075h		;9ea8	75 	u 
	defb 080h		;9ea9	80 	. 
	defb 022h		;9eaa	22 	" 
	defb 03ah		;9eab	3a 	: 
	defb 008h		;9eac	08 	. 
	defb 076h		;9ead	76 	v 
	defb 000h		;9eae	00 	. 
	defb 07eh		;9eaf	7e 	~ 
	defb 000h		;9eb0	00 	. 
	defb 004h		;9eb1	04 	. 
	defb 076h		;9eb2	76 	v 
	defb 080h		;9eb3	80 	. 
	defb 022h		;9eb4	22 	" 
	defb 03dh		;9eb5	3d 	= 
	defb 00ch		;9eb6	0c 	. 
	defb 076h		;9eb7	76 	v 
	defb 0a4h		;9eb8	a4 	. 
	defb 022h		;9eb9	22 	" 
	defb 03dh		;9eba	3d 	= 
	defb 0d4h		;9ebb	d4 	. 
	defb 077h		;9ebc	77 	w 
	defb 000h		;9ebd	00 	. 
	defb 015h		;9ebe	15 	. 
	defb 041h		;9ebf	41 	A 
	defb 027h		;9ec0	27 	' 
	defb 077h		;9ec1	77 	w 
	defb 024h		;9ec2	24 	$ 
	defb 015h		;9ec3	15 	. 
	defb 071h		;9ec4	71 	q 
	defb 033h		;9ec5	33 	3 
	defb 077h		;9ec6	77 	w 
	defb 080h		;9ec7	80 	. 
	defb 022h		;9ec8	22 	" 
	defb 039h		;9ec9	39 	9 
	defb 028h		;9eca	28 	( 
	defb 078h		;9ecb	78 	x 
	defb 000h		;9ecc	00 	. 
	defb 014h		;9ecd	14 	. 
	defb 049h		;9ece	49 	I 
	defb 044h		;9ecf	44 	D 
	defb 078h		;9ed0	78 	x 
	defb 040h		;9ed1	40 	@ 
	defb 00eh		;9ed2	0e 	. 
	defb 04ch		;9ed3	4c 	L 
	defb 08ch		;9ed4	8c 	. 
	defb 078h		;9ed5	78 	x 
	defb 080h		;9ed6	80 	. 
	defb 022h		;9ed7	22 	" 
	defb 041h		;9ed8	41 	A 
	defb 048h		;9ed9	48 	H 
	defb 079h		;9eda	79 	y 
	defb 000h		;9edb	00 	. 
	defb 014h		;9edc	14 	. 
	defb 049h		;9edd	49 	I 
	defb 064h		;9ede	64 	d 
	defb 079h		;9edf	79 	y 
	defb 040h		;9ee0	40 	@ 
	defb 047h		;9ee1	47 	G 
	defb 021h		;9ee2	21 	! 
	defb 02ch		;9ee3	2c 	, 
	defb 079h		;9ee4	79 	y 
	defb 080h		;9ee5	80 	. 
	defb 022h		;9ee6	22 	" 
	defb 041h		;9ee7	41 	A 
	defb 068h		;9ee8	68 	h 
	defb 07ah		;9ee9	7a 	z 
	defb 000h		;9eea	00 	. 
	defb 014h		;9eeb	14 	. 
	defb 049h		;9eec	49 	I 
	defb 084h		;9eed	84 	. 
	defb 07ah		;9eee	7a 	z 
	defb 040h		;9eef	40 	@ 
	defb 01ch		;9ef0	1c 	. 
	defb 0c4h		;9ef1	c4 	. 
	defb 06fh		;9ef2	6f 	o 
	defb 07ah		;9ef3	7a 	z 
	defb 080h		;9ef4	80 	. 
	defb 022h		;9ef5	22 	" 
	defb 041h		;9ef6	41 	A 
	defb 088h		;9ef7	88 	. 
	defb 07bh		;9ef8	7b 	{ 
	defb 000h		;9ef9	00 	. 
	defb 014h		;9efa	14 	. 
	defb 049h		;9efb	49 	I 
	defb 0a4h		;9efc	a4 	. 
	defb 07bh		;9efd	7b 	{ 
	defb 042h		;9efe	42 	B 
	defb 015h		;9eff	15 	. 
	defb 01dh		;9f00	1d 	. 
	defb 0b4h		;9f01	b4 	. 
	defb 07bh		;9f02	7b 	{ 
	defb 080h		;9f03	80 	. 
	defb 022h		;9f04	22 	" 
	defb 041h		;9f05	41 	A 
	defb 0a8h		;9f06	a8 	. 
	defb 07ch		;9f07	7c 	| 
	defb 000h		;9f08	00 	. 
	defb 014h		;9f09	14 	. 
	defb 049h		;9f0a	49 	I 
	defb 0c4h		;9f0b	c4 	. 
	defb 07ch		;9f0c	7c 	| 
	defb 020h		;9f0d	20 	  
	defb 014h		;9f0e	14 	. 
	defb 04bh		;9f0f	4b 	K 
	defb 028h		;9f10	28 	( 
	defb 07ch		;9f11	7c 	| 
	defb 080h		;9f12	80 	. 
	defb 022h		;9f13	22 	" 
	defb 041h		;9f14	41 	A 
	defb 0c8h		;9f15	c8 	. 
	defb 07dh		;9f16	7d 	} 
	defb 000h		;9f17	00 	. 
	defb 014h		;9f18	14 	. 
	defb 04ah		;9f19	4a 	J 
	defb 004h		;9f1a	04 	. 
	defb 07dh		;9f1b	7d 	} 
	defb 020h		;9f1c	20 	  
	defb 014h		;9f1d	14 	. 
	defb 04bh		;9f1e	4b 	K 
	defb 0a8h		;9f1f	a8 	. 
	defb 07dh		;9f20	7d 	} 
	defb 080h		;9f21	80 	. 
	defb 022h		;9f22	22 	" 
	defb 042h		;9f23	42 	B 
	defb 008h		;9f24	08 	. 
	defb 07eh		;9f25	7e 	~ 
	defb 000h		;9f26	00 	. 
	defb 014h		;9f27	14 	. 
	defb 04dh		;9f28	4d 	M 
	defb 007h		;9f29	07 	. 
	defb 07eh		;9f2a	7e 	~ 
	defb 024h		;9f2b	24 	$ 
	defb 014h		;9f2c	14 	. 
	defb 04dh		;9f2d	4d 	M 
	defb 0d3h		;9f2e	d3 	. 
	defb 07eh		;9f2f	7e 	~ 
	defb 080h		;9f30	80 	. 
	defb 022h		;9f31	22 	" 
	defb 045h		;9f32	45 	E 
	defb 00ch		;9f33	0c 	. 
	defb 07eh		;9f34	7e 	~ 
	defb 0a4h		;9f35	a4 	. 
	defb 022h		;9f36	22 	" 
	defb 045h		;9f37	45 	E 
	defb 0d4h		;9f38	d4 	. 
	defb 07fh		;9f39	7f 	 
	defb 000h		;9f3a	00 	. 
	defb 014h		;9f3b	14 	. 
	defb 049h		;9f3c	49 	I 
	defb 024h		;9f3d	24 	$ 
	defb 07fh		;9f3e	7f 	 
	defb 080h		;9f3f	80 	. 
	defb 022h		;9f40	22 	" 
	defb 041h		;9f41	41 	A 
	defb 028h		;9f42	28 	( 
	defb 080h		;9f43	80 	. 
	defb 000h		;9f44	00 	. 
	defb 01eh		;9f45	1e 	. 
	defb 049h		;9f46	49 	I 
	defb 044h		;9f47	44 	D 
	defb 080h		;9f48	80 	. 
	defb 080h		;9f49	80 	. 
	defb 04ch		;9f4a	4c 	L 
	defb 009h		;9f4b	09 	. 
	defb 048h		;9f4c	48 	H 
	defb 081h		;9f4d	81 	. 
	defb 000h		;9f4e	00 	. 
	defb 01eh		;9f4f	1e 	. 
	defb 049h		;9f50	49 	I 
	defb 064h		;9f51	64 	d 
	defb 081h		;9f52	81 	. 
	defb 080h		;9f53	80 	. 
	defb 04ch		;9f54	4c 	L 
	defb 009h		;9f55	09 	. 
	defb 068h		;9f56	68 	h 
	defb 082h		;9f57	82 	. 
	defb 000h		;9f58	00 	. 
	defb 01eh		;9f59	1e 	. 
	defb 049h		;9f5a	49 	I 
	defb 084h		;9f5b	84 	. 
	defb 082h		;9f5c	82 	. 
	defb 080h		;9f5d	80 	. 
	defb 04ch		;9f5e	4c 	L 
	defb 009h		;9f5f	09 	. 
	defb 088h		;9f60	88 	. 
	defb 083h		;9f61	83 	. 
	defb 000h		;9f62	00 	. 
	defb 01eh		;9f63	1e 	. 
	defb 049h		;9f64	49 	I 
	defb 0a4h		;9f65	a4 	. 
	defb 083h		;9f66	83 	. 
	defb 080h		;9f67	80 	. 
	defb 04ch		;9f68	4c 	L 
	defb 009h		;9f69	09 	. 
	defb 0a8h		;9f6a	a8 	. 
	defb 084h		;9f6b	84 	. 
	defb 000h		;9f6c	00 	. 
	defb 01eh		;9f6d	1e 	. 
	defb 049h		;9f6e	49 	I 
	defb 0c4h		;9f6f	c4 	. 
	defb 084h		;9f70	84 	. 
	defb 020h		;9f71	20 	  
	defb 01eh		;9f72	1e 	. 
	defb 04bh		;9f73	4b 	K 
	defb 028h		;9f74	28 	( 
	defb 084h		;9f75	84 	. 
	defb 080h		;9f76	80 	. 
	defb 04ch		;9f77	4c 	L 
	defb 009h		;9f78	09 	. 
	defb 0c8h		;9f79	c8 	. 
	defb 085h		;9f7a	85 	. 
	defb 000h		;9f7b	00 	. 
	defb 01eh		;9f7c	1e 	. 
	defb 04ah		;9f7d	4a 	J 
	defb 004h		;9f7e	04 	. 
	defb 085h		;9f7f	85 	. 
	defb 020h		;9f80	20 	  
	defb 01eh		;9f81	1e 	. 
	defb 04bh		;9f82	4b 	K 
	defb 0a8h		;9f83	a8 	. 
	defb 085h		;9f84	85 	. 
	defb 080h		;9f85	80 	. 
	defb 04ch		;9f86	4c 	L 
	defb 00ah		;9f87	0a 	. 
	defb 008h		;9f88	08 	. 
	defb 086h		;9f89	86 	. 
	defb 000h		;9f8a	00 	. 
	defb 01eh		;9f8b	1e 	. 
	defb 04dh		;9f8c	4d 	M 
	defb 007h		;9f8d	07 	. 
	defb 086h		;9f8e	86 	. 
	defb 024h		;9f8f	24 	$ 
	defb 01eh		;9f90	1e 	. 
	defb 04dh		;9f91	4d 	M 
	defb 0d3h		;9f92	d3 	. 
	defb 086h		;9f93	86 	. 
	defb 080h		;9f94	80 	. 
	defb 04ch		;9f95	4c 	L 
	defb 00dh		;9f96	0d 	. 
	defb 00fh		;9f97	0f 	. 
	defb 086h		;9f98	86 	. 
	defb 0a4h		;9f99	a4 	. 
	defb 04ch		;9f9a	4c 	L 
	defb 00dh		;9f9b	0d 	. 
	defb 0d7h		;9f9c	d7 	. 
	defb 087h		;9f9d	87 	. 
	defb 000h		;9f9e	00 	. 
	defb 01eh		;9f9f	1e 	. 
	defb 049h		;9fa0	49 	I 
	defb 024h		;9fa1	24 	$ 
	defb 087h		;9fa2	87 	. 
	defb 080h		;9fa3	80 	. 
	defb 04ch		;9fa4	4c 	L 
	defb 009h		;9fa5	09 	. 
	defb 028h		;9fa6	28 	( 
	defb 088h		;9fa7	88 	. 
	defb 000h		;9fa8	00 	. 
	defb 01ch		;9fa9	1c 	. 
	defb 049h		;9faa	49 	I 
	defb 044h		;9fab	44 	D 
	defb 088h		;9fac	88 	. 
	defb 080h		;9fad	80 	. 
	defb 04ch		;9fae	4c 	L 
	defb 011h		;9faf	11 	. 
	defb 048h		;9fb0	48 	H 
	defb 089h		;9fb1	89 	. 
	defb 000h		;9fb2	00 	. 
	defb 01ch		;9fb3	1c 	. 
	defb 049h		;9fb4	49 	I 
	defb 064h		;9fb5	64 	d 
	defb 089h		;9fb6	89 	. 
	defb 080h		;9fb7	80 	. 
	defb 04ch		;9fb8	4c 	L 
	defb 011h		;9fb9	11 	. 
	defb 068h		;9fba	68 	h 
	defb 08ah		;9fbb	8a 	. 
	defb 000h		;9fbc	00 	. 
	defb 01ch		;9fbd	1c 	. 
	defb 049h		;9fbe	49 	I 
	defb 084h		;9fbf	84 	. 
	defb 08ah		;9fc0	8a 	. 
	defb 080h		;9fc1	80 	. 
	defb 04ch		;9fc2	4c 	L 
	defb 011h		;9fc3	11 	. 
	defb 088h		;9fc4	88 	. 
	defb 08bh		;9fc5	8b 	. 
	defb 000h		;9fc6	00 	. 
	defb 01ch		;9fc7	1c 	. 
	defb 049h		;9fc8	49 	I 
	defb 0a4h		;9fc9	a4 	. 
	defb 08bh		;9fca	8b 	. 
	defb 080h		;9fcb	80 	. 
	defb 04ch		;9fcc	4c 	L 
	defb 011h		;9fcd	11 	. 
	defb 0a8h		;9fce	a8 	. 
	defb 08ch		;9fcf	8c 	. 
	defb 000h		;9fd0	00 	. 
	defb 01ch		;9fd1	1c 	. 
	defb 049h		;9fd2	49 	I 
	defb 0c4h		;9fd3	c4 	. 
	defb 08ch		;9fd4	8c 	. 
	defb 020h		;9fd5	20 	  
	defb 01ch		;9fd6	1c 	. 
	defb 04bh		;9fd7	4b 	K 
	defb 028h		;9fd8	28 	( 
	defb 08ch		;9fd9	8c 	. 
	defb 080h		;9fda	80 	. 
	defb 04ch		;9fdb	4c 	L 
	defb 011h		;9fdc	11 	. 
	defb 0c8h		;9fdd	c8 	. 
	defb 08dh		;9fde	8d 	. 
	defb 000h		;9fdf	00 	. 
	defb 01ch		;9fe0	1c 	. 
	defb 04ah		;9fe1	4a 	J 
	defb 004h		;9fe2	04 	. 
	defb 08dh		;9fe3	8d 	. 
	defb 020h		;9fe4	20 	  
	defb 01ch		;9fe5	1c 	. 
	defb 04bh		;9fe6	4b 	K 
	defb 0a8h		;9fe7	a8 	. 
	defb 08dh		;9fe8	8d 	. 
	defb 080h		;9fe9	80 	. 
	defb 04ch		;9fea	4c 	L 
	defb 012h		;9feb	12 	. 
	defb 008h		;9fec	08 	. 
	defb 08eh		;9fed	8e 	. 
	defb 000h		;9fee	00 	. 
	defb 01ch		;9fef	1c 	. 
	defb 04dh		;9ff0	4d 	M 
	defb 007h		;9ff1	07 	. 
	defb 08eh		;9ff2	8e 	. 
	defb 024h		;9ff3	24 	$ 
	defb 01ch		;9ff4	1c 	. 
	defb 04dh		;9ff5	4d 	M 
	defb 0d3h		;9ff6	d3 	. 
	defb 08eh		;9ff7	8e 	. 
	defb 080h		;9ff8	80 	. 
	defb 04ch		;9ff9	4c 	L 
	defb 015h		;9ffa	15 	. 
	defb 00fh		;9ffb	0f 	. 
	defb 08eh		;9ffc	8e 	. 
	defb 0a4h		;9ffd	a4 	. 
	defb 04ch		;9ffe	4c 	L 
	defb 015h		;9fff	15 	. 
	defb 0d7h		;a000	d7 	. 
	defb 08fh		;a001	8f 	. 
	defb 000h		;a002	00 	. 
	defb 01ch		;a003	1c 	. 
	defb 049h		;a004	49 	I 
	defb 024h		;a005	24 	$ 
	defb 08fh		;a006	8f 	. 
	defb 080h		;a007	80 	. 
	defb 04ch		;a008	4c 	L 
	defb 011h		;a009	11 	. 
	defb 028h		;a00a	28 	( 
	defb 090h		;a00b	90 	. 
	defb 000h		;a00c	00 	. 
	defb 06ah		;a00d	6a 	j 
	defb 050h		;a00e	50 	P 
	defb 004h		;a00f	04 	. 
	defb 090h		;a010	90 	. 
	defb 080h		;a011	80 	. 
	defb 04ch		;a012	4c 	L 
	defb 019h		;a013	19 	. 
	defb 048h		;a014	48 	H 
	defb 091h		;a015	91 	. 
	defb 000h		;a016	00 	. 
	defb 06ah		;a017	6a 	j 
	defb 058h		;a018	58 	X 
	defb 004h		;a019	04 	. 
	defb 091h		;a01a	91 	. 
	defb 080h		;a01b	80 	. 
	defb 04ch		;a01c	4c 	L 
	defb 019h		;a01d	19 	. 
	defb 068h		;a01e	68 	h 
	defb 092h		;a01f	92 	. 
	defb 000h		;a020	00 	. 
	defb 06ah		;a021	6a 	j 
	defb 060h		;a022	60 	` 
	defb 004h		;a023	04 	. 
	defb 092h		;a024	92 	. 
	defb 080h		;a025	80 	. 
	defb 04ch		;a026	4c 	L 
	defb 019h		;a027	19 	. 
	defb 088h		;a028	88 	. 
	defb 093h		;a029	93 	. 
	defb 000h		;a02a	00 	. 
	defb 06ah		;a02b	6a 	j 
	defb 068h		;a02c	68 	h 
	defb 004h		;a02d	04 	. 
	defb 093h		;a02e	93 	. 
	defb 080h		;a02f	80 	. 
	defb 04ch		;a030	4c 	L 
	defb 019h		;a031	19 	. 
	defb 0a8h		;a032	a8 	. 
	defb 094h		;a033	94 	. 
	defb 000h		;a034	00 	. 
	defb 06ah		;a035	6a 	j 
	defb 070h		;a036	70 	p 
	defb 004h		;a037	04 	. 
	defb 094h		;a038	94 	. 
	defb 020h		;a039	20 	  
	defb 06ah		;a03a	6a 	j 
	defb 0c8h		;a03b	c8 	. 
	defb 008h		;a03c	08 	. 
	defb 094h		;a03d	94 	. 
	defb 080h		;a03e	80 	. 
	defb 04ch		;a03f	4c 	L 
	defb 019h		;a040	19 	. 
	defb 0c8h		;a041	c8 	. 
	defb 095h		;a042	95 	. 
	defb 000h		;a043	00 	. 
	defb 06ah		;a044	6a 	j 
	defb 080h		;a045	80 	. 
	defb 004h		;a046	04 	. 
	defb 095h		;a047	95 	. 
	defb 020h		;a048	20 	  
	defb 06ah		;a049	6a 	j 
	defb 0e8h		;a04a	e8 	. 
	defb 008h		;a04b	08 	. 
	defb 095h		;a04c	95 	. 
	defb 080h		;a04d	80 	. 
	defb 04ch		;a04e	4c 	L 
	defb 01ah		;a04f	1a 	. 
	defb 008h		;a050	08 	. 
	defb 096h		;a051	96 	. 
	defb 000h		;a052	00 	. 
	defb 06bh		;a053	6b 	k 
	defb 040h		;a054	40 	@ 
	defb 007h		;a055	07 	. 
	defb 096h		;a056	96 	. 
	defb 024h		;a057	24 	$ 
	defb 06bh		;a058	6b 	k 
	defb 070h		;a059	70 	p 
	defb 013h		;a05a	13 	. 
	defb 096h		;a05b	96 	. 
	defb 080h		;a05c	80 	. 
	defb 04ch		;a05d	4c 	L 
	defb 01dh		;a05e	1d 	. 
	defb 00fh		;a05f	0f 	. 
	defb 096h		;a060	96 	. 
	defb 0a4h		;a061	a4 	. 
	defb 04ch		;a062	4c 	L 
	defb 01dh		;a063	1d 	. 
	defb 0d7h		;a064	d7 	. 
	defb 097h		;a065	97 	. 
	defb 000h		;a066	00 	. 
	defb 06ah		;a067	6a 	j 
	defb 048h		;a068	48 	H 
	defb 004h		;a069	04 	. 
	defb 097h		;a06a	97 	. 
	defb 080h		;a06b	80 	. 
	defb 04ch		;a06c	4c 	L 
	defb 019h		;a06d	19 	. 
	defb 028h		;a06e	28 	( 
	defb 098h		;a06f	98 	. 
	defb 000h		;a070	00 	. 
	defb 05eh		;a071	5e 	^ 
	defb 049h		;a072	49 	I 
	defb 044h		;a073	44 	D 
	defb 098h		;a074	98 	. 
	defb 080h		;a075	80 	. 
	defb 04ch		;a076	4c 	L 
	defb 021h		;a077	21 	! 
	defb 048h		;a078	48 	H 
	defb 099h		;a079	99 	. 
	defb 000h		;a07a	00 	. 
	defb 05eh		;a07b	5e 	^ 
	defb 049h		;a07c	49 	I 
	defb 064h		;a07d	64 	d 
	defb 099h		;a07e	99 	. 
	defb 080h		;a07f	80 	. 
	defb 04ch		;a080	4c 	L 
	defb 021h		;a081	21 	! 
	defb 068h		;a082	68 	h 
	defb 09ah		;a083	9a 	. 
	defb 000h		;a084	00 	. 
	defb 05eh		;a085	5e 	^ 
	defb 049h		;a086	49 	I 
	defb 084h		;a087	84 	. 
	defb 09ah		;a088	9a 	. 
	defb 080h		;a089	80 	. 
	defb 04ch		;a08a	4c 	L 
	defb 021h		;a08b	21 	! 
	defb 088h		;a08c	88 	. 
	defb 09bh		;a08d	9b 	. 
	defb 000h		;a08e	00 	. 
	defb 05eh		;a08f	5e 	^ 
	defb 049h		;a090	49 	I 
	defb 0a4h		;a091	a4 	. 
	defb 09bh		;a092	9b 	. 
	defb 080h		;a093	80 	. 
	defb 04ch		;a094	4c 	L 
	defb 021h		;a095	21 	! 
	defb 0a8h		;a096	a8 	. 
	defb 09ch		;a097	9c 	. 
	defb 000h		;a098	00 	. 
	defb 05eh		;a099	5e 	^ 
	defb 049h		;a09a	49 	I 
	defb 0c4h		;a09b	c4 	. 
	defb 09ch		;a09c	9c 	. 
	defb 020h		;a09d	20 	  
	defb 05eh		;a09e	5e 	^ 
	defb 04bh		;a09f	4b 	K 
	defb 028h		;a0a0	28 	( 
	defb 09ch		;a0a1	9c 	. 
	defb 080h		;a0a2	80 	. 
	defb 04ch		;a0a3	4c 	L 
	defb 021h		;a0a4	21 	! 
	defb 0c8h		;a0a5	c8 	. 
	defb 09dh		;a0a6	9d 	. 
	defb 000h		;a0a7	00 	. 
	defb 05eh		;a0a8	5e 	^ 
	defb 04ah		;a0a9	4a 	J 
	defb 004h		;a0aa	04 	. 
	defb 09dh		;a0ab	9d 	. 
	defb 020h		;a0ac	20 	  
	defb 05eh		;a0ad	5e 	^ 
	defb 04bh		;a0ae	4b 	K 
	defb 0a8h		;a0af	a8 	. 
	defb 09dh		;a0b0	9d 	. 
	defb 080h		;a0b1	80 	. 
	defb 04ch		;a0b2	4c 	L 
	defb 022h		;a0b3	22 	" 
	defb 008h		;a0b4	08 	. 
	defb 09eh		;a0b5	9e 	. 
	defb 000h		;a0b6	00 	. 
	defb 05eh		;a0b7	5e 	^ 
	defb 04dh		;a0b8	4d 	M 
	defb 007h		;a0b9	07 	. 
	defb 09eh		;a0ba	9e 	. 
	defb 024h		;a0bb	24 	$ 
	defb 05eh		;a0bc	5e 	^ 
	defb 04dh		;a0bd	4d 	M 
	defb 0d3h		;a0be	d3 	. 
	defb 09eh		;a0bf	9e 	. 
	defb 080h		;a0c0	80 	. 
	defb 04ch		;a0c1	4c 	L 
	defb 025h		;a0c2	25 	% 
	defb 00fh		;a0c3	0f 	. 
	defb 09eh		;a0c4	9e 	. 
	defb 0a4h		;a0c5	a4 	. 
	defb 04ch		;a0c6	4c 	L 
	defb 025h		;a0c7	25 	% 
	defb 0d7h		;a0c8	d7 	. 
	defb 09fh		;a0c9	9f 	. 
	defb 000h		;a0ca	00 	. 
	defb 05eh		;a0cb	5e 	^ 
	defb 049h		;a0cc	49 	I 
	defb 024h		;a0cd	24 	$ 
	defb 09fh		;a0ce	9f 	. 
	defb 080h		;a0cf	80 	. 
	defb 04ch		;a0d0	4c 	L 
	defb 021h		;a0d1	21 	! 
	defb 028h		;a0d2	28 	( 
	defb 0a0h		;a0d3	a0 	. 
	defb 000h		;a0d4	00 	. 
	defb 020h		;a0d5	20 	  
	defb 050h		;a0d6	50 	P 
	defb 004h		;a0d7	04 	. 
	defb 0a0h		;a0d8	a0 	. 
	defb 040h		;a0d9	40 	@ 
	defb 03eh		;a0da	3e 	> 
	defb 000h		;a0db	00 	. 
	defb 010h		;a0dc	10 	. 
	defb 0a0h		;a0dd	a0 	. 
	defb 080h		;a0de	80 	. 
	defb 04ch		;a0df	4c 	L 
	defb 029h		;a0e0	29 	) 
	defb 048h		;a0e1	48 	H 
	defb 0a1h		;a0e2	a1 	. 
	defb 000h		;a0e3	00 	. 
	defb 020h		;a0e4	20 	  
	defb 058h		;a0e5	58 	X 
	defb 004h		;a0e6	04 	. 
	defb 0a1h		;a0e7	a1 	. 
	defb 040h		;a0e8	40 	@ 
	defb 028h		;a0e9	28 	( 
	defb 000h		;a0ea	00 	. 
	defb 010h		;a0eb	10 	. 
	defb 0a1h		;a0ec	a1 	. 
	defb 080h		;a0ed	80 	. 
	defb 04ch		;a0ee	4c 	L 
	defb 029h		;a0ef	29 	) 
	defb 068h		;a0f0	68 	h 
	defb 0a2h		;a0f1	a2 	. 
	defb 000h		;a0f2	00 	. 
	defb 020h		;a0f3	20 	  
	defb 060h		;a0f4	60 	` 
	defb 004h		;a0f5	04 	. 
	defb 0a2h		;a0f6	a2 	. 
	defb 040h		;a0f7	40 	@ 
	defb 03ah		;a0f8	3a 	: 
	defb 000h		;a0f9	00 	. 
	defb 010h		;a0fa	10 	. 
	defb 0a2h		;a0fb	a2 	. 
	defb 080h		;a0fc	80 	. 
	defb 04ch		;a0fd	4c 	L 
	defb 029h		;a0fe	29 	) 
	defb 088h		;a0ff	88 	. 
	defb 0a3h		;a100	a3 	. 
	defb 000h		;a101	00 	. 
	defb 020h		;a102	20 	  
	defb 068h		;a103	68 	h 
	defb 004h		;a104	04 	. 
	defb 0a3h		;a105	a3 	. 
	defb 040h		;a106	40 	@ 
	defb 08eh		;a107	8e 	. 
	defb 000h		;a108	00 	. 
	defb 010h		;a109	10 	. 
	defb 0a3h		;a10a	a3 	. 
	defb 080h		;a10b	80 	. 
	defb 04ch		;a10c	4c 	L 
	defb 029h		;a10d	29 	) 
	defb 0a8h		;a10e	a8 	. 
	defb 0a4h		;a10f	a4 	. 
	defb 000h		;a110	00 	. 
	defb 020h		;a111	20 	  
	defb 070h		;a112	70 	p 
	defb 004h		;a113	04 	. 
	defb 0a4h		;a114	a4 	. 
	defb 020h		;a115	20 	  
	defb 020h		;a116	20 	  
	defb 0c8h		;a117	c8 	. 
	defb 008h		;a118	08 	. 
	defb 0a4h		;a119	a4 	. 
	defb 080h		;a11a	80 	. 
	defb 04ch		;a11b	4c 	L 
	defb 029h		;a11c	29 	) 
	defb 0c8h		;a11d	c8 	. 
	defb 0a5h		;a11e	a5 	. 
	defb 000h		;a11f	00 	. 
	defb 020h		;a120	20 	  
	defb 080h		;a121	80 	. 
	defb 004h		;a122	04 	. 
	defb 0a5h		;a123	a5 	. 
	defb 020h		;a124	20 	  
	defb 020h		;a125	20 	  
	defb 0e8h		;a126	e8 	. 
	defb 008h		;a127	08 	. 
	defb 0a5h		;a128	a5 	. 
	defb 080h		;a129	80 	. 
	defb 04ch		;a12a	4c 	L 
	defb 02ah		;a12b	2a 	* 
	defb 008h		;a12c	08 	. 
	defb 0a6h		;a12d	a6 	. 
	defb 000h		;a12e	00 	. 
	defb 021h		;a12f	21 	! 
	defb 040h		;a130	40 	@ 
	defb 007h		;a131	07 	. 
	defb 0a6h		;a132	a6 	. 
	defb 024h		;a133	24 	$ 
	defb 021h		;a134	21 	! 
	defb 070h		;a135	70 	p 
	defb 013h		;a136	13 	. 
	defb 0a6h		;a137	a6 	. 
	defb 080h		;a138	80 	. 
	defb 04ch		;a139	4c 	L 
	defb 02dh		;a13a	2d 	- 
	defb 00fh		;a13b	0f 	. 
	defb 0a6h		;a13c	a6 	. 
	defb 0a4h		;a13d	a4 	. 
	defb 04ch		;a13e	4c 	L 
	defb 02dh		;a13f	2d 	- 
	defb 0d7h		;a140	d7 	. 
	defb 0a7h		;a141	a7 	. 
	defb 000h		;a142	00 	. 
	defb 020h		;a143	20 	  
	defb 048h		;a144	48 	H 
	defb 004h		;a145	04 	. 
	defb 0a7h		;a146	a7 	. 
	defb 080h		;a147	80 	. 
	defb 04ch		;a148	4c 	L 
	defb 029h		;a149	29 	) 
	defb 028h		;a14a	28 	( 
	defb 0a8h		;a14b	a8 	. 
	defb 000h		;a14c	00 	. 
	defb 06ch		;a14d	6c 	l 
	defb 050h		;a14e	50 	P 
	defb 004h		;a14f	04 	. 
	defb 0a8h		;a150	a8 	. 
	defb 040h		;a151	40 	@ 
	defb 03ch		;a152	3c 	< 
	defb 000h		;a153	00 	. 
	defb 010h		;a154	10 	. 
	defb 0a8h		;a155	a8 	. 
	defb 080h		;a156	80 	. 
	defb 04ch		;a157	4c 	L 
	defb 031h		;a158	31 	1 
	defb 048h		;a159	48 	H 
	defb 0a9h		;a15a	a9 	. 
	defb 000h		;a15b	00 	. 
	defb 06ch		;a15c	6c 	l 
	defb 058h		;a15d	58 	X 
	defb 004h		;a15e	04 	. 
	defb 0a9h		;a15f	a9 	. 
	defb 040h		;a160	40 	@ 
	defb 026h		;a161	26 	& 
	defb 000h		;a162	00 	. 
	defb 010h		;a163	10 	. 
	defb 0a9h		;a164	a9 	. 
	defb 080h		;a165	80 	. 
	defb 04ch		;a166	4c 	L 
	defb 031h		;a167	31 	1 
	defb 068h		;a168	68 	h 
	defb 0aah		;a169	aa 	. 
	defb 000h		;a16a	00 	. 
	defb 06ch		;a16b	6c 	l 
	defb 060h		;a16c	60 	` 
	defb 004h		;a16d	04 	. 
	defb 0aah		;a16e	aa 	. 
	defb 040h		;a16f	40 	@ 
	defb 038h		;a170	38 	8 
	defb 000h		;a171	00 	. 
	defb 010h		;a172	10 	. 
	defb 0aah		;a173	aa 	. 
	defb 080h		;a174	80 	. 
	defb 04ch		;a175	4c 	L 
	defb 031h		;a176	31 	1 
	defb 088h		;a177	88 	. 
	defb 0abh		;a178	ab 	. 
	defb 000h		;a179	00 	. 
	defb 06ch		;a17a	6c 	l 
	defb 068h		;a17b	68 	h 
	defb 004h		;a17c	04 	. 
	defb 0abh		;a17d	ab 	. 
	defb 040h		;a17e	40 	@ 
	defb 08ch		;a17f	8c 	. 
	defb 000h		;a180	00 	. 
	defb 010h		;a181	10 	. 
	defb 0abh		;a182	ab 	. 
	defb 080h		;a183	80 	. 
	defb 04ch		;a184	4c 	L 
	defb 031h		;a185	31 	1 
	defb 0a8h		;a186	a8 	. 
	defb 0ach		;a187	ac 	. 
	defb 000h		;a188	00 	. 
	defb 06ch		;a189	6c 	l 
	defb 070h		;a18a	70 	p 
	defb 004h		;a18b	04 	. 
	defb 0ach		;a18c	ac 	. 
	defb 020h		;a18d	20 	  
	defb 06ch		;a18e	6c 	l 
	defb 0c8h		;a18f	c8 	. 
	defb 008h		;a190	08 	. 
	defb 0ach		;a191	ac 	. 
	defb 080h		;a192	80 	. 
	defb 04ch		;a193	4c 	L 
	defb 031h		;a194	31 	1 
	defb 0c8h		;a195	c8 	. 
	defb 0adh		;a196	ad 	. 
	defb 000h		;a197	00 	. 
	defb 06ch		;a198	6c 	l 
	defb 080h		;a199	80 	. 
	defb 004h		;a19a	04 	. 
	defb 0adh		;a19b	ad 	. 
	defb 020h		;a19c	20 	  
	defb 06ch		;a19d	6c 	l 
	defb 0e8h		;a19e	e8 	. 
	defb 008h		;a19f	08 	. 
	defb 0adh		;a1a0	ad 	. 
	defb 080h		;a1a1	80 	. 
	defb 04ch		;a1a2	4c 	L 
	defb 032h		;a1a3	32 	2 
	defb 008h		;a1a4	08 	. 
	defb 0aeh		;a1a5	ae 	. 
	defb 000h		;a1a6	00 	. 
	defb 06dh		;a1a7	6d 	m 
	defb 040h		;a1a8	40 	@ 
	defb 007h		;a1a9	07 	. 
	defb 0aeh		;a1aa	ae 	. 
	defb 024h		;a1ab	24 	$ 
	defb 06dh		;a1ac	6d 	m 
	defb 070h		;a1ad	70 	p 
	defb 013h		;a1ae	13 	. 
	defb 0aeh		;a1af	ae 	. 
	defb 080h		;a1b0	80 	. 
	defb 04ch		;a1b1	4c 	L 
	defb 035h		;a1b2	35 	5 
	defb 00fh		;a1b3	0f 	. 
	defb 0aeh		;a1b4	ae 	. 
	defb 0a4h		;a1b5	a4 	. 
	defb 04ch		;a1b6	4c 	L 
	defb 035h		;a1b7	35 	5 
	defb 0d7h		;a1b8	d7 	. 
	defb 0afh		;a1b9	af 	. 
	defb 000h		;a1ba	00 	. 
	defb 06ch		;a1bb	6c 	l 
	defb 048h		;a1bc	48 	H 
	defb 004h		;a1bd	04 	. 
	defb 0afh		;a1be	af 	. 
	defb 080h		;a1bf	80 	. 
	defb 04ch		;a1c0	4c 	L 
	defb 031h		;a1c1	31 	1 
	defb 028h		;a1c2	28 	( 
	defb 0b0h		;a1c3	b0 	. 
	defb 000h		;a1c4	00 	. 
	defb 016h		;a1c5	16 	. 
	defb 050h		;a1c6	50 	P 
	defb 004h		;a1c7	04 	. 
	defb 0b0h		;a1c8	b0 	. 
	defb 040h		;a1c9	40 	@ 
	defb 086h		;a1ca	86 	. 
	defb 000h		;a1cb	00 	. 
	defb 015h		;a1cc	15 	. 
	defb 0b0h		;a1cd	b0 	. 
	defb 080h		;a1ce	80 	. 
	defb 04ch		;a1cf	4c 	L 
	defb 039h		;a1d0	39 	9 
	defb 048h		;a1d1	48 	H 
	defb 0b1h		;a1d2	b1 	. 
	defb 000h		;a1d3	00 	. 
	defb 016h		;a1d4	16 	. 
	defb 058h		;a1d5	58 	X 
	defb 004h		;a1d6	04 	. 
	defb 0b1h		;a1d7	b1 	. 
	defb 040h		;a1d8	40 	@ 
	defb 072h		;a1d9	72 	r 
	defb 000h		;a1da	00 	. 
	defb 015h		;a1db	15 	. 
	defb 0b1h		;a1dc	b1 	. 
	defb 080h		;a1dd	80 	. 
	defb 04ch		;a1de	4c 	L 
	defb 039h		;a1df	39 	9 
	defb 068h		;a1e0	68 	h 
	defb 0b2h		;a1e1	b2 	. 
	defb 000h		;a1e2	00 	. 
	defb 016h		;a1e3	16 	. 
	defb 060h		;a1e4	60 	` 
	defb 004h		;a1e5	04 	. 
	defb 0b2h		;a1e6	b2 	. 
	defb 040h		;a1e7	40 	@ 
	defb 082h		;a1e8	82 	. 
	defb 000h		;a1e9	00 	. 
	defb 015h		;a1ea	15 	. 
	defb 0b2h		;a1eb	b2 	. 
	defb 080h		;a1ec	80 	. 
	defb 04ch		;a1ed	4c 	L 
	defb 039h		;a1ee	39 	9 
	defb 088h		;a1ef	88 	. 
	defb 0b3h		;a1f0	b3 	. 
	defb 000h		;a1f1	00 	. 
	defb 016h		;a1f2	16 	. 
	defb 068h		;a1f3	68 	h 
	defb 004h		;a1f4	04 	. 
	defb 0b3h		;a1f5	b3 	. 
	defb 040h		;a1f6	40 	@ 
	defb 08ah		;a1f7	8a 	. 
	defb 000h		;a1f8	00 	. 
	defb 015h		;a1f9	15 	. 
	defb 0b3h		;a1fa	b3 	. 
	defb 080h		;a1fb	80 	. 
	defb 04ch		;a1fc	4c 	L 
	defb 039h		;a1fd	39 	9 
	defb 0a8h		;a1fe	a8 	. 
	defb 0b4h		;a1ff	b4 	. 
	defb 000h		;a200	00 	. 
	defb 016h		;a201	16 	. 
	defb 070h		;a202	70 	p 
	defb 004h		;a203	04 	. 
	defb 0b4h		;a204	b4 	. 
	defb 020h		;a205	20 	  
	defb 016h		;a206	16 	. 
	defb 0c8h		;a207	c8 	. 
	defb 008h		;a208	08 	. 
	defb 0b4h		;a209	b4 	. 
	defb 080h		;a20a	80 	. 
	defb 04ch		;a20b	4c 	L 
	defb 039h		;a20c	39 	9 
	defb 0c8h		;a20d	c8 	. 
	defb 0b5h		;a20e	b5 	. 
	defb 000h		;a20f	00 	. 
	defb 016h		;a210	16 	. 
	defb 080h		;a211	80 	. 
	defb 004h		;a212	04 	. 
	defb 0b5h		;a213	b5 	. 
	defb 020h		;a214	20 	  
	defb 016h		;a215	16 	. 
	defb 0e8h		;a216	e8 	. 
	defb 008h		;a217	08 	. 
	defb 0b5h		;a218	b5 	. 
	defb 080h		;a219	80 	. 
	defb 04ch		;a21a	4c 	L 
	defb 03ah		;a21b	3a 	: 
	defb 008h		;a21c	08 	. 
	defb 0b6h		;a21d	b6 	. 
	defb 000h		;a21e	00 	. 
	defb 017h		;a21f	17 	. 
	defb 040h		;a220	40 	@ 
	defb 007h		;a221	07 	. 
	defb 0b6h		;a222	b6 	. 
	defb 024h		;a223	24 	$ 
	defb 017h		;a224	17 	. 
	defb 070h		;a225	70 	p 
	defb 013h		;a226	13 	. 
	defb 0b6h		;a227	b6 	. 
	defb 080h		;a228	80 	. 
	defb 04ch		;a229	4c 	L 
	defb 03dh		;a22a	3d 	= 
	defb 00fh		;a22b	0f 	. 
	defb 0b6h		;a22c	b6 	. 
	defb 0a4h		;a22d	a4 	. 
	defb 04ch		;a22e	4c 	L 
	defb 03dh		;a22f	3d 	= 
	defb 0d7h		;a230	d7 	. 
	defb 0b7h		;a231	b7 	. 
	defb 000h		;a232	00 	. 
	defb 016h		;a233	16 	. 
	defb 048h		;a234	48 	H 
	defb 004h		;a235	04 	. 
	defb 0b7h		;a236	b7 	. 
	defb 080h		;a237	80 	. 
	defb 04ch		;a238	4c 	L 
	defb 039h		;a239	39 	9 
	defb 028h		;a23a	28 	( 
	defb 0b8h		;a23b	b8 	. 
	defb 000h		;a23c	00 	. 
	defb 004h		;a23d	04 	. 
	defb 050h		;a23e	50 	P 
	defb 004h		;a23f	04 	. 
	defb 0b8h		;a240	b8 	. 
	defb 040h		;a241	40 	@ 
	defb 084h		;a242	84 	. 
	defb 000h		;a243	00 	. 
	defb 015h		;a244	15 	. 
	defb 0b8h		;a245	b8 	. 
	defb 080h		;a246	80 	. 
	defb 04ch		;a247	4c 	L 
	defb 041h		;a248	41 	A 
	defb 048h		;a249	48 	H 
	defb 0b9h		;a24a	b9 	. 
	defb 000h		;a24b	00 	. 
	defb 004h		;a24c	04 	. 
	defb 058h		;a24d	58 	X 
	defb 004h		;a24e	04 	. 
	defb 0b9h		;a24f	b9 	. 
	defb 040h		;a250	40 	@ 
	defb 070h		;a251	70 	p 
	defb 000h		;a252	00 	. 
	defb 015h		;a253	15 	. 
	defb 0b9h		;a254	b9 	. 
	defb 080h		;a255	80 	. 
	defb 04ch		;a256	4c 	L 
	defb 041h		;a257	41 	A 
	defb 068h		;a258	68 	h 
	defb 0bah		;a259	ba 	. 
	defb 000h		;a25a	00 	. 
	defb 004h		;a25b	04 	. 
	defb 060h		;a25c	60 	` 
	defb 004h		;a25d	04 	. 
	defb 0bah		;a25e	ba 	. 
	defb 040h		;a25f	40 	@ 
	defb 080h		;a260	80 	. 
	defb 000h		;a261	00 	. 
	defb 015h		;a262	15 	. 
	defb 0bah		;a263	ba 	. 
	defb 080h		;a264	80 	. 
	defb 04ch		;a265	4c 	L 
	defb 041h		;a266	41 	A 
	defb 088h		;a267	88 	. 
	defb 0bbh		;a268	bb 	. 
	defb 000h		;a269	00 	. 
	defb 004h		;a26a	04 	. 
	defb 068h		;a26b	68 	h 
	defb 004h		;a26c	04 	. 
	defb 0bbh		;a26d	bb 	. 
	defb 040h		;a26e	40 	@ 
	defb 088h		;a26f	88 	. 
	defb 000h		;a270	00 	. 
	defb 015h		;a271	15 	. 
	defb 0bbh		;a272	bb 	. 
	defb 080h		;a273	80 	. 
	defb 04ch		;a274	4c 	L 
	defb 041h		;a275	41 	A 
	defb 0a8h		;a276	a8 	. 
	defb 0bch		;a277	bc 	. 
	defb 000h		;a278	00 	. 
	defb 004h		;a279	04 	. 
	defb 070h		;a27a	70 	p 
	defb 004h		;a27b	04 	. 
	defb 0bch		;a27c	bc 	. 
	defb 020h		;a27d	20 	  
	defb 004h		;a27e	04 	. 
	defb 0c8h		;a27f	c8 	. 
	defb 008h		;a280	08 	. 
	defb 0bch		;a281	bc 	. 
	defb 080h		;a282	80 	. 
	defb 04ch		;a283	4c 	L 
	defb 041h		;a284	41 	A 
	defb 0c8h		;a285	c8 	. 
	defb 0bdh		;a286	bd 	. 
	defb 000h		;a287	00 	. 
	defb 004h		;a288	04 	. 
	defb 080h		;a289	80 	. 
	defb 004h		;a28a	04 	. 
	defb 0bdh		;a28b	bd 	. 
	defb 020h		;a28c	20 	  
	defb 004h		;a28d	04 	. 
	defb 0e8h		;a28e	e8 	. 
	defb 008h		;a28f	08 	. 
	defb 0bdh		;a290	bd 	. 
	defb 080h		;a291	80 	. 
	defb 04ch		;a292	4c 	L 
	defb 042h		;a293	42 	B 
	defb 008h		;a294	08 	. 
	defb 0beh		;a295	be 	. 
	defb 000h		;a296	00 	. 
	defb 005h		;a297	05 	. 
	defb 040h		;a298	40 	@ 
	defb 007h		;a299	07 	. 
	defb 0beh		;a29a	be 	. 
	defb 024h		;a29b	24 	$ 
	defb 005h		;a29c	05 	. 
	defb 070h		;a29d	70 	p 
	defb 013h		;a29e	13 	. 
	defb 0beh		;a29f	be 	. 
	defb 080h		;a2a0	80 	. 
	defb 04ch		;a2a1	4c 	L 
	defb 045h		;a2a2	45 	E 
	defb 00fh		;a2a3	0f 	. 
	defb 0beh		;a2a4	be 	. 
	defb 0a4h		;a2a5	a4 	. 
	defb 04ch		;a2a6	4c 	L 
	defb 045h		;a2a7	45 	E 
	defb 0d7h		;a2a8	d7 	. 
	defb 0bfh		;a2a9	bf 	. 
	defb 000h		;a2aa	00 	. 
	defb 004h		;a2ab	04 	. 
	defb 048h		;a2ac	48 	H 
	defb 004h		;a2ad	04 	. 
	defb 0bfh		;a2ae	bf 	. 
	defb 080h		;a2af	80 	. 
	defb 04ch		;a2b0	4c 	L 
	defb 041h		;a2b1	41 	A 
	defb 028h		;a2b2	28 	( 
	defb 0c0h		;a2b3	c0 	. 
	defb 000h		;a2b4	00 	. 
	defb 04fh		;a2b5	4f 	O 
	defb 000h		;a2b6	00 	. 
	defb 005h		;a2b7	05 	. 
	defb 0c0h		;a2b8	c0 	. 
	defb 080h		;a2b9	80 	. 
	defb 062h		;a2ba	62 	b 
	defb 009h		;a2bb	09 	. 
	defb 048h		;a2bc	48 	H 
	defb 0c1h		;a2bd	c1 	. 
	defb 000h		;a2be	00 	. 
	defb 048h		;a2bf	48 	H 
	defb 0b0h		;a2c0	b0 	. 
	defb 00ah		;a2c1	0a 	. 
	defb 0c1h		;a2c2	c1 	. 
	defb 080h		;a2c3	80 	. 
	defb 062h		;a2c4	62 	b 
	defb 009h		;a2c5	09 	. 
	defb 068h		;a2c6	68 	h 
	defb 0c2h		;a2c7	c2 	. 
	defb 002h		;a2c8	02 	. 
	defb 011h		;a2c9	11 	. 
	defb 005h		;a2ca	05 	. 
	defb 08ah		;a2cb	8a 	. 
	defb 0c2h		;a2cc	c2 	. 
	defb 080h		;a2cd	80 	. 
	defb 062h		;a2ce	62 	b 
	defb 009h		;a2cf	09 	. 
	defb 088h		;a2d0	88 	. 
	defb 0c3h		;a2d1	c3 	. 
	defb 002h		;a2d2	02 	. 
	defb 011h		;a2d3	11 	. 
	defb 060h		;a2d4	60 	` 
	defb 00ah		;a2d5	0a 	. 
	defb 0c3h		;a2d6	c3 	. 
	defb 080h		;a2d7	80 	. 
	defb 062h		;a2d8	62 	b 
	defb 009h		;a2d9	09 	. 
	defb 0a8h		;a2da	a8 	. 
	defb 0c4h		;a2db	c4 	. 
	defb 002h		;a2dc	02 	. 
	defb 06fh		;a2dd	6f 	o 
	defb 005h		;a2de	05 	. 
	defb 089h		;a2df	89 	. 
	defb 0c4h		;a2e0	c4 	. 
	defb 080h		;a2e1	80 	. 
	defb 062h		;a2e2	62 	b 
	defb 009h		;a2e3	09 	. 
	defb 0c8h		;a2e4	c8 	. 
	defb 0c5h		;a2e5	c5 	. 
	defb 000h		;a2e6	00 	. 
	defb 090h		;a2e7	90 	. 
	defb 0b0h		;a2e8	b0 	. 
	defb 00bh		;a2e9	0b 	. 
	defb 0c5h		;a2ea	c5 	. 
	defb 080h		;a2eb	80 	. 
	defb 062h		;a2ec	62 	b 
	defb 00ah		;a2ed	0a 	. 
	defb 008h		;a2ee	08 	. 
	defb 0c6h		;a2ef	c6 	. 
	defb 001h		;a2f0	01 	. 
	defb 01eh		;a2f1	1e 	. 
	defb 04dh		;a2f2	4d 	M 
	defb 087h		;a2f3	87 	. 
	defb 0c6h		;a2f4	c6 	. 
	defb 080h		;a2f5	80 	. 
	defb 062h		;a2f6	62 	b 
	defb 00dh		;a2f7	0d 	. 
	defb 00fh		;a2f8	0f 	. 
	defb 0c6h		;a2f9	c6 	. 
	defb 0a4h		;a2fa	a4 	. 
	defb 062h		;a2fb	62 	b 
	defb 00dh		;a2fc	0d 	. 
	defb 0d7h		;a2fd	d7 	. 
	defb 0c7h		;a2fe	c7 	. 
	defb 006h		;a2ff	06 	. 
	defb 05dh		;a300	5d 	] 
	defb 060h		;a301	60 	` 
	defb 00bh		;a302	0b 	. 
	defb 0c7h		;a303	c7 	. 
	defb 080h		;a304	80 	. 
	defb 062h		;a305	62 	b 
	defb 009h		;a306	09 	. 
	defb 028h		;a307	28 	( 
	defb 0c8h		;a308	c8 	. 
	defb 000h		;a309	00 	. 
	defb 04eh		;a30a	4e 	N 
	defb 0a0h		;a30b	a0 	. 
	defb 005h		;a30c	05 	. 
	defb 0c8h		;a30d	c8 	. 
	defb 080h		;a30e	80 	. 
	defb 062h		;a30f	62 	b 
	defb 011h		;a310	11 	. 
	defb 048h		;a311	48 	H 
	defb 0c9h		;a312	c9 	. 
	defb 000h		;a313	00 	. 
	defb 04eh		;a314	4e 	N 
	defb 000h		;a315	00 	. 
	defb 005h		;a316	05 	. 
	defb 0c9h		;a317	c9 	. 
	defb 080h		;a318	80 	. 
	defb 062h		;a319	62 	b 
	defb 011h		;a31a	11 	. 
	defb 068h		;a31b	68 	h 
	defb 0cah		;a31c	ca 	. 
	defb 002h		;a31d	02 	. 
	defb 010h		;a31e	10 	. 
	defb 0a5h		;a31f	a5 	. 
	defb 08ah		;a320	8a 	. 
	defb 0cah		;a321	ca 	. 
	defb 080h		;a322	80 	. 
	defb 062h		;a323	62 	b 
	defb 011h		;a324	11 	. 
	defb 088h		;a325	88 	. 
	defb 0cbh		;a326	cb 	. 
	defb 080h		;a327	80 	. 
	defb 062h		;a328	62 	b 
	defb 011h		;a329	11 	. 
	defb 0a8h		;a32a	a8 	. 
	defb 0cch		;a32b	cc 	. 
	defb 002h		;a32c	02 	. 
	defb 06eh		;a32d	6e 	n 
	defb 0a5h		;a32e	a5 	. 
	defb 089h		;a32f	89 	. 
	defb 0cch		;a330	cc 	. 
	defb 080h		;a331	80 	. 
	defb 062h		;a332	62 	b 
	defb 011h		;a333	11 	. 
	defb 0c8h		;a334	c8 	. 
	defb 0cdh		;a335	cd 	. 
	defb 002h		;a336	02 	. 
	defb 06fh		;a337	6f 	o 
	defb 060h		;a338	60 	` 
	defb 009h		;a339	09 	. 
	defb 0cdh		;a33a	cd 	. 
	defb 080h		;a33b	80 	. 
	defb 062h		;a33c	62 	b 
	defb 012h		;a33d	12 	. 
	defb 008h		;a33e	08 	. 
	defb 0ceh		;a33f	ce 	. 
	defb 001h		;a340	01 	. 
	defb 01ch		;a341	1c 	. 
	defb 04dh		;a342	4d 	M 
	defb 087h		;a343	87 	. 
	defb 0ceh		;a344	ce 	. 
	defb 080h		;a345	80 	. 
	defb 062h		;a346	62 	b 
	defb 015h		;a347	15 	. 
	defb 00fh		;a348	0f 	. 
	defb 0ceh		;a349	ce 	. 
	defb 0a4h		;a34a	a4 	. 
	defb 062h		;a34b	62 	b 
	defb 015h		;a34c	15 	. 
	defb 0d7h		;a34d	d7 	. 
	defb 0cfh		;a34e	cf 	. 
	defb 080h		;a34f	80 	. 
	defb 062h		;a350	62 	b 
	defb 011h		;a351	11 	. 
	defb 028h		;a352	28 	( 
	defb 0d0h		;a353	d0 	. 
	defb 000h		;a354	00 	. 
	defb 04eh		;a355	4e 	N 
	defb 0f8h		;a356	f8 	. 
	defb 005h		;a357	05 	. 
	defb 0d0h		;a358	d0 	. 
	defb 080h		;a359	80 	. 
	defb 062h		;a35a	62 	b 
	defb 019h		;a35b	19 	. 
	defb 048h		;a35c	48 	H 
	defb 0d1h		;a35d	d1 	. 
	defb 000h		;a35e	00 	. 
	defb 048h		;a35f	48 	H 
	defb 0b8h		;a360	b8 	. 
	defb 00ah		;a361	0a 	. 
	defb 0d1h		;a362	d1 	. 
	defb 080h		;a363	80 	. 
	defb 062h		;a364	62 	b 
	defb 019h		;a365	19 	. 
	defb 068h		;a366	68 	h 
	defb 0d2h		;a367	d2 	. 
	defb 002h		;a368	02 	. 
	defb 010h		;a369	10 	. 
	defb 0fdh		;a36a	fd 	. 
	defb 08ah		;a36b	8a 	. 
	defb 0d2h		;a36c	d2 	. 
	defb 080h		;a36d	80 	. 
	defb 062h		;a36e	62 	b 
	defb 019h		;a36f	19 	. 
	defb 088h		;a370	88 	. 
	defb 0d3h		;a371	d3 	. 
	defb 001h		;a372	01 	. 
	defb 047h		;a373	47 	G 
	defb 069h		;a374	69 	i 
	defb 02bh		;a375	2b 	+ 
	defb 0d3h		;a376	d3 	. 
	defb 080h		;a377	80 	. 
	defb 062h		;a378	62 	b 
	defb 019h		;a379	19 	. 
	defb 0a8h		;a37a	a8 	. 
	defb 0d4h		;a37b	d4 	. 
	defb 002h		;a37c	02 	. 
	defb 06eh		;a37d	6e 	n 
	defb 0fdh		;a37e	fd 	. 
	defb 089h		;a37f	89 	. 
	defb 0d4h		;a380	d4 	. 
	defb 080h		;a381	80 	. 
	defb 062h		;a382	62 	b 
	defb 019h		;a383	19 	. 
	defb 0c8h		;a384	c8 	. 
	defb 0d5h		;a385	d5 	. 
	defb 000h		;a386	00 	. 
	defb 090h		;a387	90 	. 
	defb 0b8h		;a388	b8 	. 
	defb 00bh		;a389	0b 	. 
	defb 0d5h		;a38a	d5 	. 
	defb 080h		;a38b	80 	. 
	defb 062h		;a38c	62 	b 
	defb 01ah		;a38d	1a 	. 
	defb 008h		;a38e	08 	. 
	defb 0d6h		;a38f	d6 	. 
	defb 001h		;a390	01 	. 
	defb 06bh		;a391	6b 	k 
	defb 060h		;a392	60 	` 
	defb 007h		;a393	07 	. 
	defb 0d6h		;a394	d6 	. 
	defb 080h		;a395	80 	. 
	defb 062h		;a396	62 	b 
	defb 01dh		;a397	1d 	. 
	defb 00fh		;a398	0f 	. 
	defb 0d6h		;a399	d6 	. 
	defb 0a4h		;a39a	a4 	. 
	defb 062h		;a39b	62 	b 
	defb 01dh		;a39c	1d 	. 
	defb 0d7h		;a39d	d7 	. 
	defb 0d7h		;a39e	d7 	. 
	defb 080h		;a39f	80 	. 
	defb 062h		;a3a0	62 	b 
	defb 019h		;a3a1	19 	. 
	defb 028h		;a3a2	28 	( 
	defb 0d8h		;a3a3	d8 	. 
	defb 000h		;a3a4	00 	. 
	defb 04eh		;a3a5	4e 	N 
	defb 058h		;a3a6	58 	X 
	defb 005h		;a3a7	05 	. 
	defb 0d8h		;a3a8	d8 	. 
	defb 080h		;a3a9	80 	. 
	defb 062h		;a3aa	62 	b 
	defb 021h		;a3ab	21 	! 
	defb 048h		;a3ac	48 	H 
	defb 0d9h		;a3ad	d9 	. 
	defb 000h		;a3ae	00 	. 
	defb 034h		;a3af	34 	4 
	defb 000h		;a3b0	00 	. 
	defb 004h		;a3b1	04 	. 
	defb 0d9h		;a3b2	d9 	. 
	defb 080h		;a3b3	80 	. 
	defb 062h		;a3b4	62 	b 
	defb 021h		;a3b5	21 	! 
	defb 068h		;a3b6	68 	h 
	defb 0dah		;a3b7	da 	. 
	defb 002h		;a3b8	02 	. 
	defb 010h		;a3b9	10 	. 
	defb 05dh		;a3ba	5d 	] 
	defb 08ah		;a3bb	8a 	. 
	defb 0dah		;a3bc	da 	. 
	defb 080h		;a3bd	80 	. 
	defb 062h		;a3be	62 	b 
	defb 021h		;a3bf	21 	! 
	defb 088h		;a3c0	88 	. 
	defb 0dbh		;a3c1	db 	. 
	defb 001h		;a3c2	01 	. 
	defb 00eh		;a3c3	0e 	. 
	defb 04dh		;a3c4	4d 	M 
	defb 0abh		;a3c5	ab 	. 
	defb 0dbh		;a3c6	db 	. 
	defb 080h		;a3c7	80 	. 
	defb 062h		;a3c8	62 	b 
	defb 021h		;a3c9	21 	! 
	defb 0a8h		;a3ca	a8 	. 
	defb 0dch		;a3cb	dc 	. 
	defb 002h		;a3cc	02 	. 
	defb 06eh		;a3cd	6e 	n 
	defb 05dh		;a3ce	5d 	] 
	defb 089h		;a3cf	89 	. 
	defb 0dch		;a3d0	dc 	. 
	defb 080h		;a3d1	80 	. 
	defb 062h		;a3d2	62 	b 
	defb 021h		;a3d3	21 	! 
	defb 0c8h		;a3d4	c8 	. 
	defb 0ddh		;a3d5	dd 	. 
	defb 080h		;a3d6	80 	. 
	defb 062h		;a3d7	62 	b 
	defb 022h		;a3d8	22 	" 
	defb 008h		;a3d9	08 	. 
	defb 0deh		;a3da	de 	. 
	defb 001h		;a3db	01 	. 
	defb 05eh		;a3dc	5e 	^ 
	defb 04dh		;a3dd	4d 	M 
	defb 087h		;a3de	87 	. 
	defb 0deh		;a3df	de 	. 
	defb 080h		;a3e0	80 	. 
	defb 062h		;a3e1	62 	b 
	defb 025h		;a3e2	25 	% 
	defb 00fh		;a3e3	0f 	. 
	defb 0deh		;a3e4	de 	. 
	defb 0a4h		;a3e5	a4 	. 
	defb 062h		;a3e6	62 	b 
	defb 025h		;a3e7	25 	% 
	defb 0d7h		;a3e8	d7 	. 
	defb 0dfh		;a3e9	df 	. 
	defb 080h		;a3ea	80 	. 
	defb 062h		;a3eb	62 	b 
	defb 021h		;a3ec	21 	! 
	defb 028h		;a3ed	28 	( 
	defb 0e0h		;a3ee	e0 	. 
	defb 000h		;a3ef	00 	. 
	defb 04fh		;a3f0	4f 	O 
	defb 010h		;a3f1	10 	. 
	defb 005h		;a3f2	05 	. 
	defb 0e0h		;a3f3	e0 	. 
	defb 080h		;a3f4	80 	. 
	defb 062h		;a3f5	62 	b 
	defb 029h		;a3f6	29 	) 
	defb 048h		;a3f7	48 	H 
	defb 0e1h		;a3f8	e1 	. 
	defb 000h		;a3f9	00 	. 
	defb 048h		;a3fa	48 	H 
	defb 0c0h		;a3fb	c0 	. 
	defb 00ah		;a3fc	0a 	. 
	defb 0e1h		;a3fd	e1 	. 
	defb 020h		;a3fe	20 	  
	defb 048h		;a3ff	48 	H 
	defb 0d8h		;a400	d8 	. 
	defb 00eh		;a401	0e 	. 
	defb 0e1h		;a402	e1 	. 
	defb 080h		;a403	80 	. 
	defb 062h		;a404	62 	b 
	defb 029h		;a405	29 	) 
	defb 068h		;a406	68 	h 
	defb 0e2h		;a407	e2 	. 
	defb 002h		;a408	02 	. 
	defb 011h		;a409	11 	. 
	defb 015h		;a40a	15 	. 
	defb 08ah		;a40b	8a 	. 
	defb 0e2h		;a40c	e2 	. 
	defb 080h		;a40d	80 	. 
	defb 062h		;a40e	62 	b 
	defb 029h		;a40f	29 	) 
	defb 088h		;a410	88 	. 
	defb 0e3h		;a411	e3 	. 
	defb 000h		;a412	00 	. 
	defb 00bh		;a413	0b 	. 
	defb 05bh		;a414	5b 	[ 
	defb 013h		;a415	13 	. 
	defb 0e3h		;a416	e3 	. 
	defb 020h		;a417	20 	  
	defb 00bh		;a418	0b 	. 
	defb 05bh		;a419	5b 	[ 
	defb 077h		;a41a	77 	w 
	defb 0e3h		;a41b	e3 	. 
	defb 080h		;a41c	80 	. 
	defb 062h		;a41d	62 	b 
	defb 029h		;a41e	29 	) 
	defb 0a8h		;a41f	a8 	. 
	defb 0e4h		;a420	e4 	. 
	defb 002h		;a421	02 	. 
	defb 06fh		;a422	6f 	o 
	defb 015h		;a423	15 	. 
	defb 089h		;a424	89 	. 
	defb 0e4h		;a425	e4 	. 
	defb 080h		;a426	80 	. 
	defb 062h		;a427	62 	b 
	defb 029h		;a428	29 	) 
	defb 0c8h		;a429	c8 	. 
	defb 0e5h		;a42a	e5 	. 
	defb 000h		;a42b	00 	. 
	defb 090h		;a42c	90 	. 
	defb 0c0h		;a42d	c0 	. 
	defb 00bh		;a42e	0b 	. 
	defb 0e5h		;a42f	e5 	. 
	defb 020h		;a430	20 	  
	defb 090h		;a431	90 	. 
	defb 0d8h		;a432	d8 	. 
	defb 00fh		;a433	0f 	. 
	defb 0e5h		;a434	e5 	. 
	defb 080h		;a435	80 	. 
	defb 062h		;a436	62 	b 
	defb 02ah		;a437	2a 	* 
	defb 008h		;a438	08 	. 
	defb 0e6h		;a439	e6 	. 
	defb 001h		;a43a	01 	. 
	defb 021h		;a43b	21 	! 
	defb 060h		;a43c	60 	` 
	defb 007h		;a43d	07 	. 
	defb 0e6h		;a43e	e6 	. 
	defb 080h		;a43f	80 	. 
	defb 062h		;a440	62 	b 
	defb 02dh		;a441	2d 	- 
	defb 00fh		;a442	0f 	. 
	defb 0e6h		;a443	e6 	. 
	defb 0a4h		;a444	a4 	. 
	defb 062h		;a445	62 	b 
	defb 02dh		;a446	2d 	- 
	defb 0d7h		;a447	d7 	. 
	defb 0e7h		;a448	e7 	. 
	defb 080h		;a449	80 	. 
	defb 062h		;a44a	62 	b 
	defb 029h		;a44b	29 	) 
	defb 028h		;a44c	28 	( 
	defb 0e8h		;a44d	e8 	. 
	defb 000h		;a44e	00 	. 
	defb 04fh		;a44f	4f 	O 
	defb 008h		;a450	08 	. 
	defb 005h		;a451	05 	. 
	defb 0e8h		;a452	e8 	. 
	defb 080h		;a453	80 	. 
	defb 062h		;a454	62 	b 
	defb 031h		;a455	31 	1 
	defb 048h		;a456	48 	H 
	defb 0e9h		;a457	e9 	. 
	defb 000h		;a458	00 	. 
	defb 011h		;a459	11 	. 
	defb 040h		;a45a	40 	@ 
	defb 004h		;a45b	04 	. 
	defb 0e9h		;a45c	e9 	. 
	defb 020h		;a45d	20 	  
	defb 011h		;a45e	11 	. 
	defb 048h		;a45f	48 	H 
	defb 008h		;a460	08 	. 
	defb 0e9h		;a461	e9 	. 
	defb 080h		;a462	80 	. 
	defb 062h		;a463	62 	b 
	defb 031h		;a464	31 	1 
	defb 068h		;a465	68 	h 
	defb 0eah		;a466	ea 	. 
	defb 002h		;a467	02 	. 
	defb 011h		;a468	11 	. 
	defb 00dh		;a469	0d 	. 
	defb 08ah		;a46a	8a 	. 
	defb 0eah		;a46b	ea 	. 
	defb 080h		;a46c	80 	. 
	defb 062h		;a46d	62 	b 
	defb 031h		;a46e	31 	1 
	defb 088h		;a46f	88 	. 
	defb 0ebh		;a470	eb 	. 
	defb 000h		;a471	00 	. 
	defb 00ah		;a472	0a 	. 
	defb 0bbh		;a473	bb 	. 
	defb 004h		;a474	04 	. 
	defb 0ebh		;a475	eb 	. 
	defb 080h		;a476	80 	. 
	defb 062h		;a477	62 	b 
	defb 031h		;a478	31 	1 
	defb 0a8h		;a479	a8 	. 
	defb 0ech		;a47a	ec 	. 
	defb 002h		;a47b	02 	. 
	defb 06fh		;a47c	6f 	o 
	defb 00dh		;a47d	0d 	. 
	defb 089h		;a47e	89 	. 
	defb 0ech		;a47f	ec 	. 
	defb 080h		;a480	80 	. 
	defb 062h		;a481	62 	b 
	defb 031h		;a482	31 	1 
	defb 0c8h		;a483	c8 	. 
	defb 0edh		;a484	ed 	. 
	defb 080h		;a485	80 	. 
	defb 062h		;a486	62 	b 
	defb 032h		;a487	32 	2 
	defb 008h		;a488	08 	. 
	defb 0eeh		;a489	ee 	. 
	defb 001h		;a48a	01 	. 
	defb 06dh		;a48b	6d 	m 
	defb 060h		;a48c	60 	` 
	defb 007h		;a48d	07 	. 
	defb 0eeh		;a48e	ee 	. 
	defb 080h		;a48f	80 	. 
	defb 062h		;a490	62 	b 
	defb 035h		;a491	35 	5 
	defb 00fh		;a492	0f 	. 
	defb 0eeh		;a493	ee 	. 
	defb 0a4h		;a494	a4 	. 
	defb 062h		;a495	62 	b 
	defb 035h		;a496	35 	5 
	defb 0d7h		;a497	d7 	. 
	defb 0efh		;a498	ef 	. 
	defb 080h		;a499	80 	. 
	defb 062h		;a49a	62 	b 
	defb 031h		;a49b	31 	1 
	defb 028h		;a49c	28 	( 
	defb 0f0h		;a49d	f0 	. 
	defb 000h		;a49e	00 	. 
	defb 04eh		;a49f	4e 	N 
	defb 090h		;a4a0	90 	. 
	defb 005h		;a4a1	05 	. 
	defb 0f0h		;a4a2	f0 	. 
	defb 080h		;a4a3	80 	. 
	defb 062h		;a4a4	62 	b 
	defb 039h		;a4a5	39 	9 
	defb 048h		;a4a6	48 	H 
	defb 0f1h		;a4a7	f1 	. 
	defb 000h		;a4a8	00 	. 
	defb 048h		;a4a9	48 	H 
	defb 0a8h		;a4aa	a8 	. 
	defb 00ah		;a4ab	0a 	. 
	defb 0f1h		;a4ac	f1 	. 
	defb 080h		;a4ad	80 	. 
	defb 062h		;a4ae	62 	b 
	defb 039h		;a4af	39 	9 
	defb 068h		;a4b0	68 	h 
	defb 0f2h		;a4b1	f2 	. 
	defb 002h		;a4b2	02 	. 
	defb 010h		;a4b3	10 	. 
	defb 095h		;a4b4	95 	. 
	defb 08ah		;a4b5	8a 	. 
	defb 0f2h		;a4b6	f2 	. 
	defb 080h		;a4b7	80 	. 
	defb 062h		;a4b8	62 	b 
	defb 039h		;a4b9	39 	9 
	defb 088h		;a4ba	88 	. 
	defb 0f3h		;a4bb	f3 	. 
	defb 000h		;a4bc	00 	. 
	defb 006h		;a4bd	06 	. 
	defb 000h		;a4be	00 	. 
	defb 004h		;a4bf	04 	. 
	defb 0f3h		;a4c0	f3 	. 
	defb 080h		;a4c1	80 	. 
	defb 062h		;a4c2	62 	b 
	defb 039h		;a4c3	39 	9 
	defb 0a8h		;a4c4	a8 	. 
	defb 0f4h		;a4c5	f4 	. 
	defb 002h		;a4c6	02 	. 
	defb 06eh		;a4c7	6e 	n 
	defb 095h		;a4c8	95 	. 
	defb 089h		;a4c9	89 	. 
	defb 0f4h		;a4ca	f4 	. 
	defb 080h		;a4cb	80 	. 
	defb 062h		;a4cc	62 	b 
	defb 039h		;a4cd	39 	9 
	defb 0c8h		;a4ce	c8 	. 
	defb 0f5h		;a4cf	f5 	. 
	defb 000h		;a4d0	00 	. 
	defb 090h		;a4d1	90 	. 
	defb 0a8h		;a4d2	a8 	. 
	defb 00bh		;a4d3	0b 	. 
	defb 0f5h		;a4d4	f5 	. 
	defb 080h		;a4d5	80 	. 
	defb 062h		;a4d6	62 	b 
	defb 03ah		;a4d7	3a 	: 
	defb 008h		;a4d8	08 	. 
	defb 0f6h		;a4d9	f6 	. 
	defb 001h		;a4da	01 	. 
	defb 017h		;a4db	17 	. 
	defb 060h		;a4dc	60 	` 
	defb 007h		;a4dd	07 	. 
	defb 0f6h		;a4de	f6 	. 
	defb 080h		;a4df	80 	. 
	defb 062h		;a4e0	62 	b 
	defb 03dh		;a4e1	3d 	= 
	defb 00fh		;a4e2	0f 	. 
	defb 0f6h		;a4e3	f6 	. 
	defb 0a4h		;a4e4	a4 	. 
	defb 062h		;a4e5	62 	b 
	defb 03dh		;a4e6	3d 	= 
	defb 0d7h		;a4e7	d7 	. 
	defb 0f7h		;a4e8	f7 	. 
	defb 080h		;a4e9	80 	. 
	defb 062h		;a4ea	62 	b 
	defb 039h		;a4eb	39 	9 
	defb 028h		;a4ec	28 	( 
	defb 0f8h		;a4ed	f8 	. 
	defb 000h		;a4ee	00 	. 
	defb 04eh		;a4ef	4e 	N 
	defb 088h		;a4f0	88 	. 
	defb 005h		;a4f1	05 	. 
	defb 0f8h		;a4f2	f8 	. 
	defb 080h		;a4f3	80 	. 
	defb 062h		;a4f4	62 	b 
	defb 041h		;a4f5	41 	A 
	defb 048h		;a4f6	48 	H 
	defb 0f9h		;a4f7	f9 	. 
	defb 000h		;a4f8	00 	. 
	defb 015h		;a4f9	15 	. 
	defb 01bh		;a4fa	1b 	. 
	defb 006h		;a4fb	06 	. 
	defb 0f9h		;a4fc	f9 	. 
	defb 020h		;a4fd	20 	  
	defb 015h		;a4fe	15 	. 
	defb 01bh		;a4ff	1b 	. 
	defb 06ah		;a500	6a 	j 
	defb 0f9h		;a501	f9 	. 
	defb 080h		;a502	80 	. 
	defb 062h		;a503	62 	b 
	defb 041h		;a504	41 	A 
	defb 068h		;a505	68 	h 
	defb 0fah		;a506	fa 	. 
	defb 002h		;a507	02 	. 
	defb 010h		;a508	10 	. 
	defb 08dh		;a509	8d 	. 
	defb 08ah		;a50a	8a 	. 
	defb 0fah		;a50b	fa 	. 
	defb 080h		;a50c	80 	. 
	defb 062h		;a50d	62 	b 
	defb 041h		;a50e	41 	A 
	defb 088h		;a50f	88 	. 
	defb 0fbh		;a510	fb 	. 
	defb 000h		;a511	00 	. 
	defb 008h		;a512	08 	. 
	defb 000h		;a513	00 	. 
	defb 004h		;a514	04 	. 
	defb 0fbh		;a515	fb 	. 
	defb 080h		;a516	80 	. 
	defb 062h		;a517	62 	b 
	defb 041h		;a518	41 	A 
	defb 0a8h		;a519	a8 	. 
	defb 0fch		;a51a	fc 	. 
	defb 002h		;a51b	02 	. 
	defb 06eh		;a51c	6e 	n 
	defb 08dh		;a51d	8d 	. 
	defb 089h		;a51e	89 	. 
	defb 0fch		;a51f	fc 	. 
	defb 080h		;a520	80 	. 
	defb 062h		;a521	62 	b 
	defb 041h		;a522	41 	A 
	defb 0c8h		;a523	c8 	. 
	defb 0fdh		;a524	fd 	. 
	defb 080h		;a525	80 	. 
	defb 062h		;a526	62 	b 
	defb 042h		;a527	42 	B 
	defb 008h		;a528	08 	. 
	defb 0feh		;a529	fe 	. 
	defb 001h		;a52a	01 	. 
	defb 005h		;a52b	05 	. 
	defb 060h		;a52c	60 	` 
	defb 007h		;a52d	07 	. 
	defb 0feh		;a52e	fe 	. 
	defb 080h		;a52f	80 	. 
	defb 062h		;a530	62 	b 
	defb 045h		;a531	45 	E 
	defb 00fh		;a532	0f 	. 
	defb 0feh		;a533	fe 	. 
	defb 0a4h		;a534	a4 	. 
	defb 062h		;a535	62 	b 
	defb 045h		;a536	45 	E 
	defb 0d7h		;a537	d7 	. 
	defb 0ffh		;a538	ff 	. 
	defb 080h		;a539	80 	. 
	defb 062h		;a53a	62 	b 
	defb 041h		;a53b	41 	A 
	defb 028h		;a53c	28 	( 
	defb 0ffh		;a53d	ff 	. 
	defb 0ffh		;a53e	ff 	. 
	defb 0ffh		;a53f	ff 	. 
	defb 0ffh		;a540	ff 	. 
	defb 0ffh		;a541	ff 	. 
	defb 000h		;a542	00 	. 
	defb 030h		;a543	30 	0 
	defb 000h		;a544	00 	. 
	defb 030h		;a545	30 	0 
	defb 000h		;a546	00 	. 
	defb 030h		;a547	30 	0 
	defb 000h		;a548	00 	. 
	defb 030h		;a549	30 	0 
	defb 000h		;a54a	00 	. 
	defb 030h		;a54b	30 	0 
	defb 000h		;a54c	00 	. 
	defb 030h		;a54d	30 	0 
	defb 000h		;a54e	00 	. 
	defb 030h		;a54f	30 	0 
	defb 000h		;a550	00 	. 
	defb 030h		;a551	30 	0 
	defb 000h		;a552	00 	. 
	defb 030h		;a553	30 	0 
	defb 000h		;a554	00 	. 
	defb 030h		;a555	30 	0 
	defb 000h		;a556	00 	. 
	defb 030h		;a557	30 	0 
	defb 000h		;a558	00 	. 
	defb 030h		;a559	30 	0 
	defb 000h		;a55a	00 	. 
	defb 030h		;a55b	30 	0 
	defb 000h		;a55c	00 	. 
	defb 030h		;a55d	30 	0 
	defb 000h		;a55e	00 	. 
	defb 030h		;a55f	30 	0 
	defb 000h		;a560	00 	. 
	defb 030h		;a561	30 	0 
	defb 000h		;a562	00 	. 
	defb 030h		;a563	30 	0 
	defb 000h		;a564	00 	. 
	defb 030h		;a565	30 	0 
	defb 000h		;a566	00 	. 
	defb 030h		;a567	30 	0 
	defb 000h		;a568	00 	. 
	defb 030h		;a569	30 	0 
	defb 000h		;a56a	00 	. 
	defb 000h		;a56b	00 	. 
	defb 000h		;a56c	00 	. 
	defb 000h		;a56d	00 	. 
	defb 000h		;a56e	00 	. 
	defb 000h		;a56f	00 	. 
	defb 000h		;a570	00 	. 
	defb 000h		;a571	00 	. 
	defb 000h		;a572	00 	. 
	defb 000h		;a573	00 	. 
data_93d8_end:
