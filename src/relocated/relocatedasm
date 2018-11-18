; z80dasm 1.1.3
; command line: z80dasm -a -t -l -g 24000 mem.bin

	org	05dc0h

l5dc0h:
	jp l7cc9h		;5dc0	c3 c9 7c 	. . | 
l5dc3h:
	ret po			;5dc3	e0 	. 
	ld d,b			;5dc4	50 	P 
	push bc			;5dc5	c5 	. 
	inc bc			;5dc6	03 	. 
	ld bc,00000h		;5dc7	01 00 00 	. . . 
l5dcah:
	nop			;5dca	00 	. 
	ld b,b			;5dcb	40 	@ 
	and b			;5dcc	a0 	. 
	inc bc			;5dcd	03 	. 
l5dceh:
	adc a,e			;5dce	8b 	. 
	nop			;5dcf	00 	. 
	nop			;5dd0	00 	. 
l5dd1h:
	and b			;5dd1	a0 	. 
	ld c,b			;5dd2	48 	H 
	call nz,l8201h+2		;5dd3	c4 03 82 	. . . 
	nop			;5dd6	00 	. 
	nop			;5dd7	00 	. 
	ld (de),a			;5dd8	12 	. 
	ld d,b			;5dd9	50 	P 
	and e			;5dda	a3 	. 
	inc bc			;5ddb	03 	. 
	ld bc,00000h		;5ddc	01 00 00 	. . . 
l5ddfh:
	nop			;5ddf	00 	. 
	ld d,b			;5de0	50 	P 
	pop bc			;5de1	c1 	. 
	or d			;5de2	b2 	. 
	ld bc,l6fb0h		;5de3	01 b0 6f 	. . o 
	jr nz,l5e38h		;5de6	20 50 	  P 
	jp nz,00192h		;5de8	c2 92 01 	. . . 
	xor d			;5deb	aa 	. 
	ld l,a			;5dec	6f 	o 
	ld b,b			;5ded	40 	@ 
	ld d,b			;5dee	50 	P 
	jp 00192h		;5def	c3 92 01 	. . . 
	xor c			;5df2	a9 	. 
	ld l,a			;5df3	6f 	o 
	ld h,b			;5df4	60 	` 
	ld d,b			;5df5	50 	P 
	call nz,00192h		;5df6	c4 92 01 	. . . 
	xor h			;5df9	ac 	. 
	ld l,a			;5dfa	6f 	o 
	add a,b			;5dfb	80 	. 
	ld d,b			;5dfc	50 	P 
	push bc			;5dfd	c5 	. 
	sub d			;5dfe	92 	. 
	ld bc,l6fabh		;5dff	01 ab 6f 	. . o 
	and b			;5e02	a0 	. 
	ld d,b			;5e03	50 	P 
	ret z			;5e04	c8 	. 
	sub d			;5e05	92 	. 
	ld bc,l6faeh		;5e06	01 ae 6f 	. . o 
	ret nz			;5e09	c0 	. 
	ld d,b			;5e0a	50 	P 
	call z,00192h		;5e0b	cc 92 01 	. . . 
	xor l			;5e0e	ad 	. 
	ld l,a			;5e0f	6f 	o 
	add a,b			;5e10	80 	. 
	ld c,b			;5e11	48 	H 
	ret			;5e12	c9 	. 
	add a,d			;5e13	82 	. 
	nop			;5e14	00 	. 
	sbc a,h			;5e15	9c 	. 
	ld l,a			;5e16	6f 	o 
	ret z			;5e17	c8 	. 
	ld d,b			;5e18	50 	P 
	jp nc,00182h		;5e19	d2 82 01 	. . . 
	sbc a,e			;5e1c	9b 	. 
	ld l,a			;5e1d	6f 	o 
	nop			;5e1e	00 	. 
	ld c,b			;5e1f	48 	H 
	add hl,de			;5e20	19 	. 
	add a,d			;5e21	82 	. 
	nop			;5e22	00 	. 
	xor b			;5e23	a8 	. 
	ld l,a			;5e24	6f 	o 
	jr nz,l5e6fh		;5e25	20 48 	  H 
	dec e			;5e27	1d 	. 
	add a,d			;5e28	82 	. 
	nop			;5e29	00 	. 
	and a			;5e2a	a7 	. 
	ld l,a			;5e2b	6f 	o 
	ld b,b			;5e2c	40 	@ 
	ld c,b			;5e2d	48 	H 
	ld a,(de)			;5e2e	1a 	. 
	add a,d			;5e2f	82 	. 
	nop			;5e30	00 	. 
	and (hl)			;5e31	a6 	. 
	ld l,a			;5e32	6f 	o 
	ld h,b			;5e33	60 	` 
	ld c,b			;5e34	48 	H 
	ld e,082h		;5e35	1e 82 	. . 
	nop			;5e37	00 	. 
l5e38h:
	and l			;5e38	a5 	. 
	ld l,a			;5e39	6f 	o 
	adc a,050h		;5e3a	ce 50 	. P 
	add a,000h		;5e3c	c6 00 	. . 
	ld bc,l6fafh		;5e3e	01 af 6f 	. . o 
	ret po			;5e41	e0 	. 
	ld b,b			;5e42	40 	@ 
	dec d			;5e43	15 	. 
	adc a,d			;5e44	8a 	. 
	nop			;5e45	00 	. 
	xor a			;5e46	af 	. 
	ld l,a			;5e47	6f 	o 
	ld c,c			;5e48	49 	I 
	ld d,b			;5e49	50 	P 
	ld d,08ah		;5e4a	16 8a 	. . 
	ld bc,l6fa9h		;5e4c	01 a9 6f 	. . o 
	ld l,c			;5e4f	69 	i 
	ld d,b			;5e50	50 	P 
	rla			;5e51	17 	. 
	adc a,d			;5e52	8a 	. 
l5e53h:
	ld bc,l6fabh		;5e53	01 ab 6f 	. . o 
	adc a,c			;5e56	89 	. 
	ld d,b			;5e57	50 	P 
	jr $-116		;5e58	18 8a 	. . 
	ld bc,l6fabh+2		;5e5a	01 ad 6f 	. . o 
	ld d,d			;5e5d	52 	R 
	ld d,b			;5e5e	50 	P 
	inc hl			;5e5f	23 	# 
	adc a,d			;5e60	8a 	. 
	ld bc,l6fb1h		;5e61	01 b1 6f 	. . o 
	ld (hl),d			;5e64	72 	r 
	ld d,b			;5e65	50 	P 
	dec de			;5e66	1b 	. 
	adc a,d			;5e67	8a 	. 
	ld bc,l6fa5h+2		;5e68	01 a7 6f 	. . o 
	sub d			;5e6b	92 	. 
	ld d,b			;5e6c	50 	P 
l5e6dh:
	inc e			;5e6d	1c 	. 
	adc a,d			;5e6e	8a 	. 
l5e6fh:
	ld bc,l6fa5h		;5e6f	01 a5 6f 	. . o 
	exx			;5e72	d9 	. 
	ld d,b			;5e73	50 	P 
	call nc,0018ah		;5e74	d4 8a 01 	. . . 
	or e			;5e77	b3 	. 
	ld l,a			;5e78	6f 	o 
	and b			;5e79	a0 	. 
	ld c,b			;5e7a	48 	H 
	ret c			;5e7b	d8 	. 
	add a,c			;5e7c	81 	. 
	ret po			;5e7d	e0 	. 
	or l			;5e7e	b5 	. 
	ld l,a			;5e7f	6f 	o 
	or c			;5e80	b1 	. 
	ld c,b			;5e81	48 	H 
	exx			;5e82	d9 	. 
	add a,c			;5e83	81 	. 
	ret po			;5e84	e0 	. 
	or a			;5e85	b7 	. 
	ld l,a			;5e86	6f 	o 
	ex af,af'			;5e87	08 	. 
	ld c,b			;5e88	48 	H 
	ld h,081h		;5e89	26 81 	& . 
	ret po			;5e8b	e0 	. 
	xor c			;5e8c	a9 	. 
	ld l,a			;5e8d	6f 	o 
	jr z,l5ed8h		;5e8e	28 48 	( H 
	daa			;5e90	27 	' 
	add a,c			;5e91	81 	. 
	ret po			;5e92	e0 	. 
	xor e			;5e93	ab 	. 
	ld l,a			;5e94	6f 	o 
	ld c,b			;5e95	48 	H 
	ld c,b			;5e96	48 	H 
	jr z,$-125		;5e97	28 81 	( . 
	ret po			;5e99	e0 	. 
	xor l			;5e9a	ad 	. 
	ld l,a			;5e9b	6f 	o 
l5e9ch:
	ld d,050h		;5e9c	16 50 	. P 
	dec hl			;5e9e	2b 	+ 
	adc a,l			;5e9f	8d 	. 
	push hl			;5ea0	e5 	. 
	or c			;5ea1	b1 	. 
	ld l,a			;5ea2	6f 	o 
	ld l,b			;5ea3	68 	h 
	ld c,b			;5ea4	48 	H 
	add hl,hl			;5ea5	29 	) 
	add a,c			;5ea6	81 	. 
	ret po			;5ea7	e0 	. 
	and a			;5ea8	a7 	. 
	ld l,a			;5ea9	6f 	o 
	adc a,b			;5eaa	88 	. 
	ld c,b			;5eab	48 	H 
	ld hl,(0e081h)		;5eac	2a 81 e0 	* . . 
	and l			;5eaf	a5 	. 
	ld l,a			;5eb0	6f 	o 
	call nc,0c002h		;5eb1	d4 02 c0 	. . . 
	ld e,l			;5eb4	5d 	] 
	jr c,l5e53h		;5eb5	38 9c 	8 . 
	nop			;5eb7	00 	. 
	nop			;5eb8	00 	. 
	nop			;5eb9	00 	. 
	nop			;5eba	00 	. 
	nop			;5ebb	00 	. 
	nop			;5ebc	00 	. 
	nop			;5ebd	00 	. 
	nop			;5ebe	00 	. 
	nop			;5ebf	00 	. 
	nop			;5ec0	00 	. 
	nop			;5ec1	00 	. 
	nop			;5ec2	00 	. 
	nop			;5ec3	00 	. 
	nop			;5ec4	00 	. 
	nop			;5ec5	00 	. 
	nop			;5ec6	00 	. 
	nop			;5ec7	00 	. 
	nop			;5ec8	00 	. 
	nop			;5ec9	00 	. 
	nop			;5eca	00 	. 
	push de			;5ecb	d5 	. 
l5ecch:
	ld (bc),a			;5ecc	02 	. 
	ret nz			;5ecd	c0 	. 
	ld e,l			;5ece	5d 	] 
	jr c,l5e6dh		;5ecf	38 9c 	8 . 
	nop			;5ed1	00 	. 
	nop			;5ed2	00 	. 
	nop			;5ed3	00 	. 
	nop			;5ed4	00 	. 
	nop			;5ed5	00 	. 
	nop			;5ed6	00 	. 
	nop			;5ed7	00 	. 
l5ed8h:
	nop			;5ed8	00 	. 
	nop			;5ed9	00 	. 
	nop			;5eda	00 	. 
	nop			;5edb	00 	. 
	nop			;5edc	00 	. 
	nop			;5edd	00 	. 
	nop			;5ede	00 	. 
	nop			;5edf	00 	. 
	nop			;5ee0	00 	. 
	nop			;5ee1	00 	. 
	nop			;5ee2	00 	. 
	nop			;5ee3	00 	. 
	nop			;5ee4	00 	. 
l5ee5h:
	nop			;5ee5	00 	. 
	nop			;5ee6	00 	. 
	nop			;5ee7	00 	. 
	nop			;5ee8	00 	. 
	nop			;5ee9	00 	. 
	nop			;5eea	00 	. 
	nop			;5eeb	00 	. 
	nop			;5eec	00 	. 
	nop			;5eed	00 	. 
	nop			;5eee	00 	. 
	nop			;5eef	00 	. 
	nop			;5ef0	00 	. 
	nop			;5ef1	00 	. 
	nop			;5ef2	00 	. 
	nop			;5ef3	00 	. 
	nop			;5ef4	00 	. 
	nop			;5ef5	00 	. 
	nop			;5ef6	00 	. 
	nop			;5ef7	00 	. 
	nop			;5ef8	00 	. 
	nop			;5ef9	00 	. 
	nop			;5efa	00 	. 
	nop			;5efb	00 	. 
	nop			;5efc	00 	. 
	nop			;5efd	00 	. 
	out (002h),a		;5efe	d3 02 	. . 
	nop			;5f00	00 	. 
	nop			;5f01	00 	. 
	nop			;5f02	00 	. 
	nop			;5f03	00 	. 
	nop			;5f04	00 	. 
	nop			;5f05	00 	. 
	nop			;5f06	00 	. 
	nop			;5f07	00 	. 
	nop			;5f08	00 	. 
	nop			;5f09	00 	. 
	nop			;5f0a	00 	. 
	nop			;5f0b	00 	. 
	nop			;5f0c	00 	. 
	nop			;5f0d	00 	. 
	nop			;5f0e	00 	. 
	nop			;5f0f	00 	. 
	nop			;5f10	00 	. 
	nop			;5f11	00 	. 
	nop			;5f12	00 	. 
	nop			;5f13	00 	. 
	nop			;5f14	00 	. 
	nop			;5f15	00 	. 
	nop			;5f16	00 	. 
	nop			;5f17	00 	. 
	jp nc,00002h		;5f18	d2 02 00 	. . . 
	nop			;5f1b	00 	. 
	nop			;5f1c	00 	. 
	nop			;5f1d	00 	. 
	nop			;5f1e	00 	. 
	nop			;5f1f	00 	. 
	nop			;5f20	00 	. 
	nop			;5f21	00 	. 
	nop			;5f22	00 	. 
	nop			;5f23	00 	. 
	nop			;5f24	00 	. 
	nop			;5f25	00 	. 
	nop			;5f26	00 	. 
	nop			;5f27	00 	. 
	nop			;5f28	00 	. 
	nop			;5f29	00 	. 
	nop			;5f2a	00 	. 
	nop			;5f2b	00 	. 
	nop			;5f2c	00 	. 
	nop			;5f2d	00 	. 
	nop			;5f2e	00 	. 
	nop			;5f2f	00 	. 
	nop			;5f30	00 	. 
	nop			;5f31	00 	. 
	pop de			;5f32	d1 	. 
l5f33h:
	ld (bc),a			;5f33	02 	. 
	nop			;5f34	00 	. 
	nop			;5f35	00 	. 
	nop			;5f36	00 	. 
	nop			;5f37	00 	. 
	nop			;5f38	00 	. 
	nop			;5f39	00 	. 
	nop			;5f3a	00 	. 
	nop			;5f3b	00 	. 
	nop			;5f3c	00 	. 
	nop			;5f3d	00 	. 
	nop			;5f3e	00 	. 
	nop			;5f3f	00 	. 
	nop			;5f40	00 	. 
	nop			;5f41	00 	. 
	nop			;5f42	00 	. 
	nop			;5f43	00 	. 
	nop			;5f44	00 	. 
	nop			;5f45	00 	. 
	nop			;5f46	00 	. 
	nop			;5f47	00 	. 
	nop			;5f48	00 	. 
	nop			;5f49	00 	. 
	nop			;5f4a	00 	. 
	nop			;5f4b	00 	. 
	call z,00001h		;5f4c	cc 01 00 	. . . 
	nop			;5f4f	00 	. 
	nop			;5f50	00 	. 
	nop			;5f51	00 	. 
	nop			;5f52	00 	. 
	nop			;5f53	00 	. 
	nop			;5f54	00 	. 
	nop			;5f55	00 	. 
	nop			;5f56	00 	. 
	nop			;5f57	00 	. 
	nop			;5f58	00 	. 
	nop			;5f59	00 	. 
	nop			;5f5a	00 	. 
	nop			;5f5b	00 	. 
	nop			;5f5c	00 	. 
	nop			;5f5d	00 	. 
	nop			;5f5e	00 	. 
	nop			;5f5f	00 	. 
	nop			;5f60	00 	. 
	nop			;5f61	00 	. 
	nop			;5f62	00 	. 
	nop			;5f63	00 	. 
sub_5f64h:
	call sub_6c4ah		;5f64	cd 4a 6c 	. J l 
	xor a			;5f67	af 	. 
	in a,(0feh)		;5f68	db fe 	. . 
	cpl			;5f6a	2f 	/ 
	and 01fh		;5f6b	e6 1f 	. . 
	ret nz			;5f6d	c0 	. 
	call sub_8608h		;5f6e	cd 08 86 	. . . 
	cp 004h		;5f71	fe 04 	. . 
	ret nz			;5f73	c0 	. 
l5f74h:
	di			;5f74	f3 	. 
	call sub_7800h		;5f75	cd 00 78 	. . x 
	ld sp,08ba1h		;5f78	31 a1 8b 	1 . . 
	call sub_665ah		;5f7b	cd 5a 66 	. Z f 
	ld hl,l8affh		;5f7e	21 ff 8a 	! . . 
	ld (hl),0c6h		;5f81	36 c6 	6 . 
	inc hl			;5f83	23 	# 
	ld a,(l68f2h+1)		;5f84	3a f3 68 	: . h 
	add a,0c7h		;5f87	c6 c7 	. . 
	ld (hl),a			;5f89	77 	w 
	inc hl			;5f8a	23 	# 
	ld (hl),0cch		;5f8b	36 cc 	6 . 
	inc hl			;5f8d	23 	# 
	ld a,(l6848h)		;5f8e	3a 48 68 	: H h 
	or a			;5f91	b7 	. 
	jr z,l5f96h		;5f92	28 02 	( . 
	sub 0c7h		;5f94	d6 c7 	. . 
l5f96h:
	add a,0c9h		;5f96	c6 c9 	. . 
	ld (hl),a			;5f98	77 	w 
	call sub_6669h		;5f99	cd 69 66 	. i f 
	ld a,080h		;5f9c	3e 80 	> . 
	ld (l8affh),a		;5f9e	32 ff 8a 	2 . . 
	ld hl,l8d6fh		;5fa1	21 6f 8d 	! o . 
	ld (08751h),hl		;5fa4	22 51 87 	" Q . 
	ld hl,l89f4h		;5fa7	21 f4 89 	! . . 
	ld (080a0h),hl		;5faa	22 a0 80 	" . . 
	ld hl,l82dbh		;5fad	21 db 82 	! . . 
	ld (l80a2h+1),hl		;5fb0	22 a3 80 	" . . 
	ld hl,l7ccfh		;5fb3	21 cf 7c 	! . | 
	ld (07e39h),hl		;5fb6	22 39 7e 	" 9 ~ 
	ld hl,l5f74h		;5fb9	21 74 5f 	! t _ 
	push hl			;5fbc	e5 	. 
	call sub_6d79h		;5fbd	cd 79 6d 	. y m 
	call sub_8608h		;5fc0	cd 08 86 	. . . 
	call sub_6113h		;5fc3	cd 13 61 	. . a 
	call sub_85f8h		;5fc6	cd f8 85 	. . . 
	ld hl,(0603bh)		;5fc9	2a 3b 60 	* ; ` 
	ld e,020h		;5fcc	1e 20 	.   
	cp 071h		;5fce	fe 71 	. q 
	jp z,l7cc9h		;5fd0	ca c9 7c 	. . | 
	cp 014h		;5fd3	fe 14 	. . 
	jp z,l6c83h		;5fd5	ca 83 6c 	. . l 
	cp 023h		;5fd8	fe 23 	. # 
	jp z,l7c39h		;5fda	ca 39 7c 	. 9 | 
	cp 03ah		;5fdd	fe 3a 	. : 
	jp z,l66eah		;5fdf	ca ea 66 	. . f 
	cp 02ch		;5fe2	fe 2c 	. , 
	jp z,l64feh		;5fe4	ca fe 64 	. . d 
	cp 003h		;5fe7	fe 03 	. . 
	jp z,l7ca3h		;5fe9	ca a3 7c 	. . | 
	ld c,a			;5fec	4f 	O 
	ld b,028h		;5fed	06 28 	. ( 
	ld hl,l600ah		;5fef	21 0a 60 	! . ` 
	ld de,l6063h		;5ff2	11 63 60 	. c ` 
l5ff5h:
	ld a,(de)			;5ff5	1a 	. 
	inc de			;5ff6	13 	. 
	call sub_6bd8h		;5ff7	cd d8 6b 	. . k 
	ld a,(de)			;5ffa	1a 	. 
	cp c			;5ffb	b9 	. 
	inc de			;5ffc	13 	. 
	jr z,l6005h		;5ffd	28 06 	( . 
	djnz l5ff5h		;5fff	10 f4 	. . 
	ld a,c			;6001	79 	y 
	jp l6480h		;6002	c3 80 64 	. . d 
l6005h:
	push hl			;6005	e5 	. 
	ld hl,(0603bh)		;6006	2a 3b 60 	* ; ` 
	ret			;6009	c9 	. 
l600ah:
	call sub_60c3h		;600a	cd c3 60 	. . ` 
	call nz,02b23h		;600d	c4 23 2b 	. # + 
	dec hl			;6010	2b 	+ 
	inc hl			;6011	23 	# 
l6012h:
	ld (0603bh),hl		;6012	22 3b 60 	" ; ` 
	ret			;6015	c9 	. 
	ld hl,l5ee5h		;6016	21 e5 5e 	! . ^ 
	ld a,(hl)			;6019	7e 	~ 
	or a			;601a	b7 	. 
	ret z			;601b	c8 	. 
	dec (hl)			;601c	35 	5 
	add a,a			;601d	87 	. 
	call sub_6bd8h		;601e	cd d8 6b 	. . k 
l6021h:
	ld a,(hl)			;6021	7e 	~ 
	dec hl			;6022	2b 	+ 
	ld l,(hl)			;6023	6e 	n 
	ld h,a			;6024	67 	g 
	jr l6012h		;6025	18 eb 	. . 
	ld hl,l5ee5h		;6027	21 e5 5e 	! . ^ 
	ld a,(hl)			;602a	7e 	~ 
	cp 00ah		;602b	fe 0a 	. . 
	ret nc			;602d	d0 	. 
	push hl			;602e	e5 	. 
	call sub_60c3h		;602f	cd c3 60 	. . ` 
	call nz,034e3h		;6032	c4 e3 34 	. . 4 
	ld a,(hl)			;6035	7e 	~ 
	add a,a			;6036	87 	. 
	call sub_6bd8h		;6037	cd d8 6b 	. . k 
	ld de,00000h		;603a	11 00 00 	. . . 
	ld (hl),d			;603d	72 	r 
	dec hl			;603e	2b 	+ 
	ld (hl),e			;603f	73 	s 
	pop hl			;6040	e1 	. 
	jr l6012h		;6041	18 cf 	. . 
	call sub_6b56h		;6043	cd 56 6b 	. V k 
	jr l6012h		;6046	18 ca 	. . 
	call sub_60c3h		;6048	cd c3 60 	. . ` 
	jp nz,047cdh		;604b	c2 cd 47 	. . G 
	ld l,h			;604e	6c 	l 
l604fh:
	call sub_6a0ah		;604f	cd 0a 6a 	. . j 
	call sub_5f64h		;6052	cd 64 5f 	. d _ 
	jr l604fh		;6055	18 f8 	. . 
	ld ix,l5dcah		;6057	dd 21 ca 5d 	. ! . ] 
	ld a,(ix+004h)		;605b	dd 7e 04 	. ~ . 
	and 01fh		;605e	e6 1f 	. . 
	jp l6e46h		;6060	c3 46 6e 	. F n 
l6063h:
	nop			;6063	00 	. 
	ld l,l			;6064	6d 	m 
	dec b			;6065	05 	. 
	ld a,(bc)			;6066	0a 	. 
	ld (bc),a			;6067	02 	. 
	dec c			;6068	0d 	. 
	dec b			;6069	05 	. 
	ex af,af'			;606a	08 	. 
	ld de,01c0bh		;606b	11 0b 1c 	. . . 
	add hl,bc			;606e	09 	. 
	dec b			;606f	05 	. 
	halt			;6070	76 	v 
	inc b			;6071	04 	. 
	inc h			;6072	24 	$ 
	dec bc			;6073	0b 	. 
	dec b			;6074	05 	. 
	ld e,h			;6075	5c 	\ 
	jr nz,l60f7h		;6076	20 7f 	   
	ld h,l			;6078	65 	e 
	ld c,060h		;6079	0e 60 	. ` 
	ld b,078h		;607b	06 78 	. x 
	ld de,00563h		;607d	11 63 05 	. c . 
	ccf			;6080	3f 	? 
	ld c,074h		;6081	0e 74 	. t 
	inc d			;6083	14 	. 
	ld a,01eh		;6084	3e 1e 	> . 
	ld l,005h		;6086	2e 05 	. . 
	ld (hl),e			;6088	73 	s 
	dec b			;6089	05 	. 
	ld a,h			;608a	7c 	| 
	ld b,h			;608b	44 	D 
	ld l,d			;608c	6a 	j 
	dec b			;608d	05 	. 
	dec l			;608e	2d 	- 
	dec d			;608f	15 	. 
	ld a,c			;6090	79 	y 
	ld l,c			;6091	69 	i 
	ld hl,(l6412h)		;6092	2a 12 64 	* . d 
	ld b,e			;6095	43 	C 
	ld e,h			;6096	5c 	\ 
	ld hl,(00877h)		;6097	2a 77 08 	* w . 
	ld e,l			;609a	5d 	] 
	ld a,(0165eh)		;609b	3a 5e 16 	: ^ . 
	ld l,c			;609e	69 	i 
	dec b			;609f	05 	. 
	ld a,a			;60a0	7f 	 
	ld hl,00570h		;60a1	21 70 05 	! p . 
	ld (03d1bh),hl		;60a4	22 1b 3d 	" . = 
	inc b			;60a7	04 	. 
l60a8h:
	ld l,h			;60a8	6c 	l 
	ld b,c			;60a9	41 	A 
	dec sp			;60aa	3b 	; 
	inc b			;60ab	04 	. 
	ld l,a			;60ac	6f 	o 
	cpl			;60ad	2f 	/ 
	ld (hl),023h		;60ae	36 23 	6 # 
	ld h,a			;60b0	67 	g 
	inc h			;60b1	24 	$ 
	ld l,(hl)			;60b2	6e 	n 
sub_60b3h:
	ld (sub_664ch+1),hl		;60b3	22 4d 66 	" M f 
sub_60b6h:
	ld a,021h		;60b6	3e 21 	> ! 
	ld de,00001h		;60b8	11 01 00 	. . . 
	ld hl,(sub_826ch+1)		;60bb	2a 6d 82 	* m . 
	ld (l79c3h+1),hl		;60be	22 c4 79 	" . y 
	jr l60cbh		;60c1	18 08 	. . 
sub_60c3h:
	pop hl			;60c3	e1 	. 
	ld e,(hl)			;60c4	5e 	^ 
	inc hl			;60c5	23 	# 
	push hl			;60c6	e5 	. 
	ld d,001h		;60c7	16 01 	. . 
	ld a,0c3h		;60c9	3e c3 	> . 
l60cbh:
	ld (l60f1h),a		;60cb	32 f1 60 	2 . ` 
	call sub_665ah		;60ce	cd 5a 66 	. Z f 
	ld (l8affh),de		;60d1	ed 53 ff 8a 	. S . . 
	ld (l60d9h+1),sp		;60d5	ed 73 da 60 	. s . ` 
l60d9h:
	ld sp,00000h		;60d9	31 00 00 	1 . . 
	call l82dbh		;60dc	cd db 82 	. . . 
	ld hl,l612dh		;60df	21 2d 61 	! - a 
	ld (080a0h),hl		;60e2	22 a0 80 	" . . 
	call sub_6675h		;60e5	cd 75 66 	. u f 
	ld hl,l8affh+1		;60e8	21 00 8b 	! . . 
	call sub_85aeh		;60eb	cd ae 85 	. . . 
	cp 03ah		;60ee	fe 3a 	. : 
	ret z			;60f0	c8 	. 
l60f1h:
	jp l719dh		;60f1	c3 9d 71 	. . q 
	ld hl,l8affh		;60f4	21 ff 8a 	! . . 
l60f7h:
	call sub_85aeh		;60f7	cd ae 85 	. . . 
	ld c,009h		;60fa	0e 09 	. . 
	call sub_7ee7h		;60fc	cd e7 7e 	. . ~ 
	call sub_664ch		;60ff	cd 4c 66 	. L f 
	call sub_79afh		;6102	cd af 79 	. . y 
	call sub_664ch		;6105	cd 4c 66 	. L f 
	call sub_78dah		;6108	cd da 78 	. . x 
	ld hl,(l7953h+1)		;610b	2a 54 79 	* T y 
	ld (sub_664ch+1),hl		;610e	22 4d 66 	" M f 
	xor a			;6111	af 	. 
	ret			;6112	c9 	. 
sub_6113h:
	ld hl,(l5dc3h)		;6113	2a c3 5d 	* . ] 
	push af			;6116	f5 	. 
	ld a,l			;6117	7d 	} 
	and 0e0h		;6118	e6 e0 	. . 
	ld l,a			;611a	6f 	o 
	pop af			;611b	f1 	. 
	ret			;611c	c9 	. 
sub_611dh:
	call sub_6113h		;611d	cd 13 61 	. . a 
	call sub_80b7h		;6120	cd b7 80 	. . . 
	ld h,001h		;6123	26 01 	& . 
l6125h:
	inc hl			;6125	23 	# 
	ex (sp),hl			;6126	e3 	. 
	ex (sp),hl			;6127	e3 	. 
	inc h			;6128	24 	$ 
	dec h			;6129	25 	% 
	jr nz,l6125h		;612a	20 f9 	  . 
	ret			;612c	c9 	. 
l612dh:
	call sub_611dh		;612d	cd 1d 61 	. . a 
	jr l60d9h		;6130	18 a7 	. . 
	call sub_60b3h		;6132	cd b3 60 	. . ` 
l6135h:
	ld hl,(sub_664ch+1)		;6135	2a 4d 66 	* M f 
	call sub_6d7ch		;6138	cd 7c 6d 	. | m 
	call sub_60b6h		;613b	cd b6 60 	. . ` 
	jr l6135h		;613e	18 f5 	. . 
	ld hl,l68f2h+1		;6140	21 f3 68 	! . h 
l6143h:
	jp l7c41h		;6143	c3 41 7c 	. A | 
	ld hl,l6848h		;6146	21 48 68 	! H h 
	ld a,(hl)			;6149	7e 	~ 
	or a			;614a	b7 	. 
	jr nz,l614fh		;614b	20 02 	  . 
	ld a,0c7h		;614d	3e c7 	> . 
l614fh:
	inc a			;614f	3c 	< 
	cp 0cah		;6150	fe ca 	. . 
	jr nz,l6155h		;6152	20 01 	  . 
	xor a			;6154	af 	. 
l6155h:
	ld (hl),a			;6155	77 	w 
	ret			;6156	c9 	. 
	ld hl,l6aedh+1		;6157	21 ee 6a 	! . j 
	jr l6143h		;615a	18 e7 	. . 
	ld hl,06a91h		;615c	21 91 6a 	! . j 
	ld a,(hl)			;615f	7e 	~ 
	or a			;6160	b7 	. 
	jr nz,l6165h		;6161	20 02 	  . 
l6163h:
	ld a,003h		;6163	3e 03 	> . 
l6165h:
	dec a			;6165	3d 	= 
	ld (hl),a			;6166	77 	w 
	out (0feh),a		;6167	d3 fe 	. . 
	ret			;6169	c9 	. 
l616ah:
	call sub_66e7h		;616a	cd e7 66 	. . f 
	call c,sub_6d79h		;616d	dc 79 6d 	. y m 
	call 01f54h		;6170	cd 54 1f 	. T . 
	jr c,l616ah		;6173	38 f5 	8 . 
l6175h:
	xor a			;6175	af 	. 
	in a,(0feh)		;6176	db fe 	. . 
	cpl			;6178	2f 	/ 
	and 01fh		;6179	e6 1f 	. . 
	jr nz,l6175h		;617b	20 f8 	  . 
	ret			;617d	c9 	. 
	call sub_60c3h		;617e	cd c3 60 	. . ` 
	jp l8f22h		;6181	c3 22 8f 	. " . 
	ld h,c			;6184	61 	a 
l6185h:
	call sub_66e7h		;6185	cd e7 66 	. . f 
	call nc,sub_6d79h		;6188	d4 79 6d 	. y m 
	ld hl,(0603bh)		;618b	2a 3b 60 	* ; ` 
	ld de,00000h		;618e	11 00 00 	. . . 
	or a			;6191	b7 	. 
	sbc hl,de		;6192	ed 52 	. R 
	ret z			;6194	c8 	. 
	call 01f54h		;6195	cd 54 1f 	. T . 
	jr nc,l6175h		;6198	30 db 	0 . 
	jr l6185h		;619a	18 e9 	. . 
	ld hl,l6e65h+1		;619c	21 66 6e 	! f n 
	jr l6143h		;619f	18 a2 	. . 
	call sub_66a8h		;61a1	cd a8 66 	. . f 
	jr l61a9h		;61a4	18 03 	. . 
	call sub_669bh		;61a6	cd 9b 66 	. . f 
l61a9h:
	push hl			;61a9	e5 	. 
	push de			;61aa	d5 	. 
	call sub_60c3h		;61ab	cd c3 60 	. . ` 
	exx			;61ae	d9 	. 
	xor 03ah		;61af	ee 3a 	. : 
	jr nz,l61d6h		;61b1	20 23 	  # 
	ld ix,l8ad1h		;61b3	dd 21 d1 8a 	. ! . . 
	ld (ix+000h),003h		;61b7	dd 36 00 03 	. 6 . . 
	ld de,l8ad2h		;61bb	11 d2 8a 	. . . 
	inc hl			;61be	23 	# 
	call sub_76bfh		;61bf	cd bf 76 	. . v 
	pop de			;61c2	d1 	. 
	pop hl			;61c3	e1 	. 
	push hl			;61c4	e5 	. 
	push de			;61c5	d5 	. 
	or a			;61c6	b7 	. 
	sbc hl,de		;61c7	ed 52 	. R 
	inc hl			;61c9	23 	# 
	ld (l8adeh),de		;61ca	ed 53 de 8a 	. S . . 
	ld (l8adch),hl		;61ce	22 dc 8a 	" . . 
	call sub_769ah		;61d1	cd 9a 76 	. . v 
	ld l,0ffh		;61d4	2e ff 	. . 
l61d6h:
	call sub_61dch		;61d6	cd dc 61 	. . a 
	jp 004c6h		;61d9	c3 c6 04 	. . . 
sub_61dch:
	ld a,l			;61dc	7d 	} 
	pop bc			;61dd	c1 	. 
	pop de			;61de	d1 	. 
	pop hl			;61df	e1 	. 
	push bc			;61e0	c5 	. 
	or a			;61e1	b7 	. 
	sbc hl,de		;61e2	ed 52 	. R 
	inc hl			;61e4	23 	# 
	ex de,hl			;61e5	eb 	. 
	push hl			;61e6	e5 	. 
	pop ix		;61e7	dd e1 	. . 
	ret			;61e9	c9 	. 
	call sub_66a8h		;61ea	cd a8 66 	. . f 
	jr l61f2h		;61ed	18 03 	. . 
	call sub_669bh		;61ef	cd 9b 66 	. . f 
l61f2h:
	call sub_66b3h		;61f2	cd b3 66 	. . f 
	call sub_60c3h		;61f5	cd c3 60 	. . ` 
	exx			;61f8	d9 	. 
l61f9h:
	call sub_61dch		;61f9	cd dc 61 	. . a 
	scf			;61fc	37 	7 
	call sub_7bb1h		;61fd	cd b1 7b 	. . { 
	ret c			;6200	d8 	. 
	jp l66c4h		;6201	c3 c4 66 	. . f 
	call sub_6c47h		;6204	cd 47 6c 	. G l 
	ld ix,l8affh		;6207	dd 21 ff 8a 	. ! . . 
	ld de,00012h		;620b	11 12 00 	. . . 
	xor a			;620e	af 	. 
l620fh:
	scf			;620f	37 	7 
	ex af,af'			;6210	08 	. 
	ld a,00fh		;6211	3e 0f 	> . 
	out (0feh),a		;6213	d3 fe 	. . 
	call 00562h		;6215	cd 62 05 	. b . 
	ld ix,l8aa7h+1		;6218	dd 21 a8 8a 	. ! . . 
	jr c,l6229h		;621c	38 0b 	8 . 
	ld hl,(l8affh)		;621e	2a ff 8a 	* . . 
	ld h,000h		;6221	26 00 	& . 
	call sub_6b02h		;6223	cd 02 6b 	. . k 
	jp sub_6c4ah		;6226	c3 4a 6c 	. J l 
l6229h:
	ld hl,l8affh+1		;6229	21 00 8b 	! . . 
	ld a,(hl)			;622c	7e 	~ 
	add a,030h		;622d	c6 30 	. 0 
	ld (ix-003h),a		;622f	dd 77 fd 	. w . 
	ld b,00ah		;6232	06 0a 	. . 
l6234h:
	inc hl			;6234	23 	# 
	ld a,(hl)			;6235	7e 	~ 
	cp 020h		;6236	fe 20 	.   
	jr nc,l623ch		;6238	30 02 	0 . 
	ld a,03fh		;623a	3e 3f 	> ? 
l623ch:
	ld (ix+000h),a		;623c	dd 77 00 	. w . 
	inc ix		;623f	dd 23 	. # 
	djnz l6234h		;6241	10 f1 	. . 
	inc ix		;6243	dd 23 	. # 
	ld hl,(l8b0dh)		;6245	2a 0d 8b 	* . . 
	push hl			;6248	e5 	. 
	call sub_6afch		;6249	cd fc 6a 	. . j 
	ld hl,(l8b0bh)		;624c	2a 0b 8b 	* . . 
	push hl			;624f	e5 	. 
	call sub_6afch		;6250	cd fc 6a 	. . j 
	ld hl,(l8b0fh)		;6253	2a 0f 8b 	* . . 
	call sub_6afch		;6256	cd fc 6a 	. . j 
	call sub_6c4ah		;6259	cd 4a 6c 	. J l 
	call sub_8608h		;625c	cd 08 86 	. . . 
	pop hl			;625f	e1 	. 
	pop de			;6260	d1 	. 
	cp 06ah		;6261	fe 6a 	. j 
	ret nz			;6263	c0 	. 
	add hl,de			;6264	19 	. 
	dec hl			;6265	2b 	+ 
	call sub_66b3h		;6266	cd b3 66 	. . f 
	ld l,0ffh		;6269	2e ff 	. . 
	jr l61f9h		;626b	18 8c 	. . 
	ld b,008h		;626d	06 08 	. . 
	ld hl,l6fa9h		;626f	21 a9 6f 	! . o 
	ld de,l6f9dh		;6272	11 9d 6f 	. . o 
l6275h:
	ld c,(hl)			;6275	4e 	N 
	ld a,(de)			;6276	1a 	. 
	ld (hl),a			;6277	77 	w 
	ld a,c			;6278	79 	y 
	ld (de),a			;6279	12 	. 
	inc hl			;627a	23 	# 
	inc de			;627b	13 	. 
	djnz l6275h		;627c	10 f7 	. . 
	ret			;627e	c9 	. 
	ld hl,l7332h		;627f	21 32 73 	! 2 s 
l6282h:
	ld (062a4h),hl		;6282	22 a4 62 	" . b 
	ld hl,l62b6h		;6285	21 b6 62 	! . b 
	ld (07e39h),hl		;6288	22 39 7e 	" 9 ~ 
	call sub_66a8h		;628b	cd a8 66 	. . f 
	push hl			;628e	e5 	. 
	ld hl,l62b7h		;628f	21 b7 62 	! . b 
	ld (080a0h),hl		;6292	22 a0 80 	" . . 
	pop hl			;6295	e1 	. 
	ex de,hl			;6296	eb 	. 
l6297h:
	push de			;6297	d5 	. 
	call sub_6a0ah		;6298	cd 0a 6a 	. . j 
	call sub_6c4ah		;629b	cd 4a 6c 	. J l 
	push hl			;629e	e5 	. 
	ld (l62b7h+1),sp		;629f	ed 73 b8 62 	. s . b 
	call 00052h		;62a3	cd 52 00 	. R . 
	di			;62a6	f3 	. 
l62a7h:
	pop hl			;62a7	e1 	. 
	pop de			;62a8	d1 	. 
	call sub_675dh		;62a9	cd 5d 67 	. ] g 
	jp nc,l6175h		;62ac	d2 75 61 	. u a 
	push hl			;62af	e5 	. 
	or a			;62b0	b7 	. 
	sbc hl,de		;62b1	ed 52 	. R 
	pop hl			;62b3	e1 	. 
	jr c,l6297h		;62b4	38 e1 	8 . 
l62b6h:
	ret			;62b6	c9 	. 
l62b7h:
	ld sp,00000h		;62b7	31 00 00 	1 . . 
	call sub_6675h		;62ba	cd 75 66 	. u f 
	call sub_62dch		;62bd	cd dc 62 	. . b 
	jr l62a7h		;62c0	18 e5 	. . 
	ld hl,l62b6h		;62c2	21 b6 62 	! . b 
	ld (07e39h),hl		;62c5	22 39 7e 	" 9 ~ 
	xor a			;62c8	af 	. 
	ld (l6aedh+1),a		;62c9	32 ee 6a 	2 . j 
	ld hl,l62d1h		;62cc	21 d1 62 	! . b 
	jr l6282h		;62cf	18 b1 	. . 
l62d1h:
	ld hl,l8aa5h		;62d1	21 a5 8a 	! . . 
	ld de,l8affh		;62d4	11 ff 8a 	. . . 
	ld bc,00020h		;62d7	01 20 00 	.   . 
	ldir		;62da	ed b0 	. . 
sub_62dch:
	call l82dbh		;62dc	cd db 82 	. . . 
	ld hl,l8affh		;62df	21 ff 8a 	! . . 
	call sub_85aeh		;62e2	cd ae 85 	. . . 
	ld d,000h		;62e5	16 00 	. . 
	ld c,009h		;62e7	0e 09 	. . 
	jp l7e07h		;62e9	c3 07 7e 	. . ~ 
	cp 077h		;62ec	fe 77 	. w 
	jr nz,l62f4h		;62ee	20 04 	  . 
	ld (06313h),hl		;62f0	22 13 63 	" . c 
	ret			;62f3	c9 	. 
l62f4h:
	push hl			;62f4	e5 	. 
	ld (07935h),hl		;62f5	22 35 79 	" 5 y 
	ld de,l632bh		;62f8	11 2b 63 	. + c 
	push de			;62fb	d5 	. 
	call sub_631ah		;62fc	cd 1a 63 	. . c 
	ld hl,l5f74h		;62ff	21 74 5f 	! t _ 
	ld (080a0h),hl		;6302	22 a0 80 	" . . 
	ld a,0c3h		;6305	3e c3 	> . 
	call sub_7931h		;6307	cd 31 79 	. 1 y 
	ld bc,l67ach		;630a	01 ac 67 	. . g 
	call sub_7962h		;630d	cd 62 79 	. b y 
	ld c,0c3h		;6310	0e c3 	. . 
	ld de,l67ach		;6312	11 ac 67 	. . g 
	call 06335h		;6315	cd 35 63 	. 5 c 
	pop hl			;6318	e1 	. 
	pop de			;6319	d1 	. 
sub_631ah:
	ld bc,00003h		;631a	01 03 00 	. . . 
	ldir		;631d	ed b0 	. . 
	ld a,0ffh		;631f	3e ff 	> . 
sub_6321h:
	ld hl,l6f9bh		;6321	21 9b 6f 	! . o 
	add a,(hl)			;6324	86 	. 
	xor (hl)			;6325	ae 	. 
	and 07fh		;6326	e6 7f 	.  
	xor (hl)			;6328	ae 	. 
	ld (hl),a			;6329	77 	w 
	ret			;632a	c9 	. 
l632bh:
	nop			;632b	00 	. 
	nop			;632c	00 	. 
	nop			;632d	00 	. 
	call sub_60c3h		;632e	cd c3 60 	. . ` 
	call z,00eebh		;6331	cc eb 0e 	. . . 
	call 0d4cdh		;6334	cd cd d4 	. . . 
	ld l,b			;6337	68 	h 
	ld (hl),c			;6338	71 	q 
	inc hl			;6339	23 	# 
	ld (hl),e			;633a	73 	s 
	inc hl			;633b	23 	# 
	ld (hl),d			;633c	72 	r 
	inc hl			;633d	23 	# 
	call sub_68c3h		;633e	cd c3 68 	. . h 
	jp l6762h		;6341	c3 62 67 	. b g 
	call sub_66a8h		;6344	cd a8 66 	. . f 
	jr l634ch		;6347	18 03 	. . 
	call sub_669bh		;6349	cd 9b 66 	. . f 
l634ch:
	push hl			;634c	e5 	. 
	push de			;634d	d5 	. 
	call sub_60c3h		;634e	cd c3 60 	. . ` 
	ret c			;6351	d8 	. 
	pop de			;6352	d1 	. 
	pop bc			;6353	c1 	. 
	push de			;6354	d5 	. 
	push hl			;6355	e5 	. 
	or a			;6356	b7 	. 
	sbc hl,de		;6357	ed 52 	. R 
	add hl,bc			;6359	09 	. 
	pop bc			;635a	c1 	. 
	call sub_66b9h		;635b	cd b9 66 	. . f 
	ex de,hl			;635e	eb 	. 
	sbc hl,bc		;635f	ed 42 	. B 
	inc hl			;6361	23 	# 
	ld d,b			;6362	50 	P 
sub_6363h:
	ld e,c			;6363	59 	Y 
	ld b,h			;6364	44 	D 
	ld c,l			;6365	4d 	M 
	pop hl			;6366	e1 	. 
	jp l88ech		;6367	c3 ec 88 	. . . 
	call sub_66a8h		;636a	cd a8 66 	. . f 
	jr l6372h		;636d	18 03 	. . 
	call sub_669bh		;636f	cd 9b 66 	. . f 
l6372h:
	call sub_66b3h		;6372	cd b3 66 	. . f 
	call sub_60c3h		;6375	cd c3 60 	. . ` 
	rst 10h			;6378	d7 	. 
	ld a,l			;6379	7d 	} 
	pop de			;637a	d1 	. 
	pop hl			;637b	e1 	. 
	or a			;637c	b7 	. 
	sbc hl,de		;637d	ed 52 	. R 
	ld (de),a			;637f	12 	. 
	ret z			;6380	c8 	. 
	ld b,h			;6381	44 	D 
	ld c,l			;6382	4d 	M 
	ex de,hl			;6383	eb 	. 
	ld d,h			;6384	54 	T 
	ld e,l			;6385	5d 	] 
	inc de			;6386	13 	. 
	ldir		;6387	ed b0 	. . 
	ret			;6389	c9 	. 
	call sub_60c3h		;638a	cd c3 60 	. . ` 
	jp nz,047cdh		;638d	c2 cd 47 	. . G 
	ld l,h			;6390	6c 	l 
l6391h:
	ld ix,l8aa5h		;6391	dd 21 a5 8a 	. ! . . 
	push hl			;6395	e5 	. 
	call sub_8908h		;6396	cd 08 89 	. . . 
	pop hl			;6399	e1 	. 
	inc ix		;639a	dd 23 	. # 
	inc ix		;639c	dd 23 	. # 
	push hl			;639e	e5 	. 
	ld bc,00500h		;639f	01 00 05 	. . . 
l63a2h:
	push hl			;63a2	e5 	. 
	ld l,(hl)			;63a3	6e 	n 
	ld h,000h		;63a4	26 00 	& . 
	ld a,(sub_8908h+1)		;63a6	3a 09 89 	: . . 
	push bc			;63a9	c5 	. 
	or a			;63aa	b7 	. 
	jr z,l63b8h		;63ab	28 0b 	( . 
	ld (ix+000h),023h		;63ad	dd 36 00 23 	. 6 . # 
	inc ix		;63b1	dd 23 	. # 
	call sub_891eh		;63b3	cd 1e 89 	. . . 
	jr l63bbh		;63b6	18 03 	. . 
l63b8h:
	call sub_8932h		;63b8	cd 32 89 	. 2 . 
l63bbh:
	pop bc			;63bb	c1 	. 
	inc ix		;63bc	dd 23 	. # 
	pop hl			;63be	e1 	. 
	inc hl			;63bf	23 	# 
	djnz l63a2h		;63c0	10 e0 	. . 
	pop hl			;63c2	e1 	. 
	ld b,005h		;63c3	06 05 	. . 
l63c5h:
	call sub_63efh		;63c5	cd ef 63 	. . c 
	djnz l63c5h		;63c8	10 fb 	. . 
	call sub_5f64h		;63ca	cd 64 5f 	. d _ 
	jr l6391h		;63cd	18 c2 	. . 
	call sub_60c3h		;63cf	cd c3 60 	. . ` 
	jp nz,047cdh		;63d2	c2 cd 47 	. . G 
	ld l,h			;63d5	6c 	l 
l63d6h:
	ld ix,l8aa5h		;63d6	dd 21 a5 8a 	. ! . . 
	push hl			;63da	e5 	. 
	call sub_6afeh		;63db	cd fe 6a 	. . j 
	pop hl			;63de	e1 	. 
	inc ix		;63df	dd 23 	. # 
	inc ix		;63e1	dd 23 	. # 
	ld b,019h		;63e3	06 19 	. . 
l63e5h:
	call sub_63efh		;63e5	cd ef 63 	. . c 
	djnz l63e5h		;63e8	10 fb 	. . 
	call sub_5f64h		;63ea	cd 64 5f 	. d _ 
	jr l63d6h		;63ed	18 e7 	. . 
sub_63efh:
	ld a,(hl)			;63ef	7e 	~ 
	and 07fh		;63f0	e6 7f 	.  
	cp 020h		;63f2	fe 20 	.   
	ld a,(hl)			;63f4	7e 	~ 
	inc hl			;63f5	23 	# 
	jr nc,l63fch		;63f6	30 04 	0 . 
	and 080h		;63f8	e6 80 	. . 
	or 02eh		;63fa	f6 2e 	. . 
l63fch:
	ld (ix+000h),a		;63fc	dd 77 00 	. w . 
	inc ix		;63ff	dd 23 	. # 
	ret			;6401	c9 	. 
	ld hl,05f4dh		;6402	21 4d 5f 	! M _ 
l6405h:
	push hl			;6405	e5 	. 
	call sub_65c1h		;6406	cd c1 65 	. . e 
	pop hl			;6409	e1 	. 
	jr nz,l6462h		;640a	20 56 	  V 
	ld a,(hl)			;640c	7e 	~ 
	cp 00bh		;640d	fe 0b 	. . 
	ret nc			;640f	d0 	. 
	push hl			;6410	e5 	. 
	dec a			;6411	3d 	= 
l6412h:
	add a,a			;6412	87 	. 
	call sub_6bd8h		;6413	cd d8 6b 	. . k 
	inc hl			;6416	23 	# 
	push hl			;6417	e5 	. 
	call sub_60c3h		;6418	cd c3 60 	. . ` 
	call z,0e1ebh		;641b	cc eb e1 	. . . 
	ld (hl),e			;641e	73 	s 
	inc hl			;641f	23 	# 
	ld (hl),d			;6420	72 	r 
	pop hl			;6421	e1 	. 
	inc (hl)			;6422	34 	4 
	jr l6405h		;6423	18 e0 	. . 
	ld a,031h		;6425	3e 31 	> 1 
	ld (07133h),a		;6427	32 33 71 	2 3 q 
	ld b,005h		;642a	06 05 	. . 
	ld hl,l64ceh		;642c	21 ce 64 	! . d 
l642fh:
	push bc			;642f	c5 	. 
	push hl			;6430	e5 	. 
	call sub_60c3h		;6431	cd c3 60 	. . ` 
	jp c,03aeeh		;6434	da ee 3a 	. . : 
	ld c,000h		;6437	0e 00 	. . 
	jr z,l643ch		;6439	28 01 	( . 
	dec c			;643b	0d 	. 
l643ch:
	ld b,l			;643c	45 	E 
	ld hl,07133h		;643d	21 33 71 	! 3 q 
	inc (hl)			;6440	34 	4 
	pop hl			;6441	e1 	. 
	ld (hl),b			;6442	70 	p 
	inc hl			;6443	23 	# 
	ld (hl),c			;6444	71 	q 
	inc hl			;6445	23 	# 
	pop bc			;6446	c1 	. 
	djnz l642fh		;6447	10 e6 	. . 
	ld de,(0603bh)		;6449	ed 5b 3b 60 	. [ ; ` 
	inc de			;644d	13 	. 
l644eh:
	push de			;644e	d5 	. 
	ld hl,l64ceh		;644f	21 ce 64 	! . d 
	ld b,005h		;6452	06 05 	. . 
l6454h:
	ld a,(de)			;6454	1a 	. 
	inc de			;6455	13 	. 
	xor (hl)			;6456	ae 	. 
	inc hl			;6457	23 	# 
	and (hl)			;6458	a6 	. 
	inc hl			;6459	23 	# 
	jr nz,l64bdh		;645a	20 61 	  a 
	djnz l6454h		;645c	10 f6 	. . 
	pop hl			;645e	e1 	. 
	jp l6012h		;645f	c3 12 60 	. . ` 
l6462h:
	sub 02fh		;6462	d6 2f 	. / 
	cp (hl)			;6464	be 	. 
	jr nc,l6405h		;6465	30 9e 	0 . 
	dec a			;6467	3d 	= 
	add a,a			;6468	87 	. 
	ld b,a			;6469	47 	G 
	ld a,015h		;646a	3e 15 	> . 
sub_646ch:
	sub b			;646c	90 	. 
	ld c,a			;646d	4f 	O 
	ld a,b			;646e	78 	x 
	ld b,000h		;646f	06 00 	. . 
	push hl			;6471	e5 	. 
	call sub_6bd8h		;6472	cd d8 6b 	. . k 
	inc hl			;6475	23 	# 
	ld d,h			;6476	54 	T 
	ld e,l			;6477	5d 	] 
	inc hl			;6478	23 	# 
	inc hl			;6479	23 	# 
	ldir		;647a	ed b0 	. . 
	pop hl			;647c	e1 	. 
	dec (hl)			;647d	35 	5 
	jr l6405h		;647e	18 85 	. . 
l6480h:
	cp 031h		;6480	fe 31 	. 1 
	ret c			;6482	d8 	. 
	cp 036h		;6483	fe 36 	. 6 
	ret nc			;6485	d0 	. 
	sub 031h		;6486	d6 31 	. 1 
	add a,a			;6488	87 	. 
	ld hl,l64c4h		;6489	21 c4 64 	! . d 
	call sub_6bd8h		;648c	cd d8 6b 	. . k 
	ld e,(hl)			;648f	5e 	^ 
	inc hl			;6490	23 	# 
	ld d,(hl)			;6491	56 	V 
	ex de,hl			;6492	eb 	. 
l6493h:
	push hl			;6493	e5 	. 
	call sub_65bbh		;6494	cd bb 65 	. . e 
	pop hl			;6497	e1 	. 
	jr nz,l64d8h		;6498	20 3e 	  > 
	ld a,(hl)			;649a	7e 	~ 
	cp 007h		;649b	fe 07 	. . 
	ret nc			;649d	d0 	. 
	push hl			;649e	e5 	. 
	dec a			;649f	3d 	= 
	add a,a			;64a0	87 	. 
	add a,a			;64a1	87 	. 
	call sub_6bd8h		;64a2	cd d8 6b 	. . k 
	inc hl			;64a5	23 	# 
	push hl			;64a6	e5 	. 
	call sub_66a8h		;64a7	cd a8 66 	. . f 
	push hl			;64aa	e5 	. 
	or a			;64ab	b7 	. 
	sbc hl,de		;64ac	ed 52 	. R 
	pop bc			;64ae	c1 	. 
	pop hl			;64af	e1 	. 
	ld (hl),e			;64b0	73 	s 
	inc hl			;64b1	23 	# 
	ld (hl),d			;64b2	72 	r 
	inc hl			;64b3	23 	# 
	ld (hl),c			;64b4	71 	q 
	inc hl			;64b5	23 	# 
	ld (hl),b			;64b6	70 	p 
	pop hl			;64b7	e1 	. 
	jr c,l6493h		;64b8	38 d9 	8 . 
	inc (hl)			;64ba	34 	4 
	jr l6493h		;64bb	18 d6 	. . 
l64bdh:
	pop de			;64bd	d1 	. 
	inc de			;64be	13 	. 
	ld a,d			;64bf	7a 	z 
	or e			;64c0	b3 	. 
	ret z			;64c1	c8 	. 
	jr l644eh		;64c2	18 8a 	. . 
l64c4h:
	or d			;64c4	b2 	. 
	ld e,(hl)			;64c5	5e 	^ 
	call z,0ff5eh		;64c6	cc 5e ff 	. ^ . 
	ld e,(hl)			;64c9	5e 	^ 
	add hl,de			;64ca	19 	. 
	ld e,a			;64cb	5f 	_ 
	inc sp			;64cc	33 	3 
	ld e,a			;64cd	5f 	_ 
l64ceh:
	nop			;64ce	00 	. 
	nop			;64cf	00 	. 
	nop			;64d0	00 	. 
	nop			;64d1	00 	. 
	nop			;64d2	00 	. 
	nop			;64d3	00 	. 
	nop			;64d4	00 	. 
	nop			;64d5	00 	. 
	nop			;64d6	00 	. 
	nop			;64d7	00 	. 
l64d8h:
	sub 02eh		;64d8	d6 2e 	. . 
	cp (hl)			;64da	be 	. 
	jr nc,l6493h		;64db	30 b6 	0 . 
	dec a			;64dd	3d 	= 
	add a,a			;64de	87 	. 
	add a,a			;64df	87 	. 
	ld b,a			;64e0	47 	G 
	ld a,015h		;64e1	3e 15 	> . 
	sub b			;64e3	90 	. 
	ld c,a			;64e4	4f 	O 
	ld a,b			;64e5	78 	x 
	ld b,000h		;64e6	06 00 	. . 
	push hl			;64e8	e5 	. 
	call sub_6bd8h		;64e9	cd d8 6b 	. . k 
	inc hl			;64ec	23 	# 
	ld d,h			;64ed	54 	T 
	ld e,l			;64ee	5d 	] 
	inc hl			;64ef	23 	# 
	inc hl			;64f0	23 	# 
	inc hl			;64f1	23 	# 
	inc hl			;64f2	23 	# 
	ldir		;64f3	ed b0 	. . 
	pop hl			;64f5	e1 	. 
	dec (hl)			;64f6	35 	5 
	jr l6493h		;64f7	18 9a 	. . 
l64f9h:
	call sub_611dh		;64f9	cd 1d 61 	. . a 
	jr l6511h		;64fc	18 13 	. . 
l64feh:
	call sub_665ah		;64fe	cd 5a 66 	. Z f 
	ld hl,001c5h		;6501	21 c5 01 	! . . 
	ld (l8affh),hl		;6504	22 ff 8a 	" . . 
	ld hl,l64f9h		;6507	21 f9 64 	! . d 
	ld (080a0h),hl		;650a	22 a0 80 	" . . 
	ld (l6511h+1),sp		;650d	ed 73 12 65 	. s . e 
l6511h:
	ld sp,00000h		;6511	31 00 00 	1 . . 
	call l82dbh		;6514	cd db 82 	. . . 
	call sub_6675h		;6517	cd 75 66 	. u f 
	ld b,018h		;651a	06 18 	. . 
	ld ix,l5ddfh		;651c	dd 21 df 5d 	. ! . ] 
l6520h:
	ld hl,l8affh+1		;6520	21 00 8b 	! . . 
	call sub_85aeh		;6523	cd ae 85 	. . . 
	ld a,(ix+002h)		;6526	dd 7e 02 	. ~ . 
	bit 7,a		;6529	cb 7f 	.  
	jr nz,l653fh		;652b	20 12 	  . 
	ld de,l8db4h		;652d	11 b4 8d 	. . . 
	call sub_82c9h		;6530	cd c9 82 	. . . 
	ld a,(de)			;6533	1a 	. 
	xor (hl)			;6534	ae 	. 
	and 05fh		;6535	e6 5f 	. _ 
	jr nz,l654ch		;6537	20 13 	  . 
	inc de			;6539	13 	. 
	inc hl			;653a	23 	# 
	call sub_85aeh		;653b	cd ae 85 	. . . 
	ld a,(de)			;653e	1a 	. 
l653fh:
	xor (hl)			;653f	ae 	. 
	and 05fh		;6540	e6 5f 	. _ 
	jr nz,l654ch		;6542	20 08 	  . 
sub_6544h:
	inc hl			;6544	23 	# 
	call sub_85aeh		;6545	cd ae 85 	. . . 
	cp 041h		;6548	fe 41 	. A 
	jr c,l657bh		;654a	38 2f 	8 / 
l654ch:
	ld de,00007h		;654c	11 07 00 	. . . 
	add ix,de		;654f	dd 19 	. . 
	djnz l6520h		;6551	10 cd 	. . 
	jp l8081h		;6553	c3 81 80 	. . . 
l6556h:
	call sub_85aeh		;6556	cd ae 85 	. . . 
	or 020h		;6559	f6 20 	.   
	push hl			;655b	e5 	. 
	ld hl,l656bh		;655c	21 6b 65 	! k e 
	ld b,004h		;655f	06 04 	. . 
l6561h:
	cp (hl)			;6561	be 	. 
	inc hl			;6562	23 	# 
	jr z,$+16		;6563	28 0e 	( . 
	inc hl			;6565	23 	# 
	djnz l6561h		;6566	10 f9 	. . 
	pop hl			;6568	e1 	. 
	jr l6583h		;6569	18 18 	. . 
l656bh:
	ld (hl),e			;656b	73 	s 
	add a,b			;656c	80 	. 
	ld a,d			;656d	7a 	z 
	ld b,b			;656e	40 	@ 
	ld (hl),b			;656f	70 	p 
	inc b			;6570	04 	. 
	ld h,e			;6571	63 	c 
sub_6572h:
	ld bc,0af11h		;6572	01 11 af 	. . . 
	ld l,a			;6575	6f 	o 
	ld a,(de)			;6576	1a 	. 
	xor (hl)			;6577	ae 	. 
	ld (de),a			;6578	12 	. 
	pop hl			;6579	e1 	. 
	ret			;657a	c9 	. 
l657bh:
	inc hl			;657b	23 	# 
	ld a,(ix+002h)		;657c	dd 7e 02 	. ~ . 
	cp 0c6h		;657f	fe c6 	. . 
	jr z,l6556h		;6581	28 d3 	( . 
l6583h:
	push ix		;6583	dd e5 	. . 
	call sub_71a0h		;6585	cd a0 71 	. . q 
	pop ix		;6588	dd e1 	. . 
	ex de,hl			;658a	eb 	. 
	ld l,(ix+005h)		;658b	dd 6e 05 	. n . 
	ld h,(ix+006h)		;658e	dd 66 06 	. f . 
	ld a,(ix+002h)		;6591	dd 7e 02 	. ~ . 
	cp 0d8h		;6594	fe d8 	. . 
	jr nc,l659eh		;6596	30 06 	0 . 
	bit 3,(ix+003h)		;6598	dd cb 03 5e 	. . . ^ 
	jr z,l65a1h		;659c	28 03 	( . 
l659eh:
	inc hl			;659e	23 	# 
	ld (hl),d			;659f	72 	r 
	dec hl			;65a0	2b 	+ 
l65a1h:
	ld (hl),e			;65a1	73 	s 
	ret			;65a2	c9 	. 
sub_65a3h:
	ld b,000h		;65a3	06 00 	. . 
	push hl			;65a5	e5 	. 
	ld hl,l6fd0h		;65a6	21 d0 6f 	! . o 
	add hl,bc			;65a9	09 	. 
	ld c,(hl)			;65aa	4e 	N 
	add hl,bc			;65ab	09 	. 
l65ach:
	ld a,(hl)			;65ac	7e 	~ 
	cp 080h		;65ad	fe 80 	. . 
	res 7,a		;65af	cb bf 	. . 
	ld (de),a			;65b1	12 	. 
	inc de			;65b2	13 	. 
	inc hl			;65b3	23 	# 
	jr c,l65ach		;65b4	38 f6 	8 . 
	xor a			;65b6	af 	. 
	ld (de),a			;65b7	12 	. 
	inc de			;65b8	13 	. 
	pop hl			;65b9	e1 	. 
	ret			;65ba	c9 	. 
sub_65bbh:
	ld a,037h		;65bb	3e 37 	> 7 
	ld c,035h		;65bd	0e 35 	. 5 
	jr l65c5h		;65bf	18 04 	. . 
sub_65c1h:
	ld a,0b7h		;65c1	3e b7 	> . 
	ld c,039h		;65c3	0e 39 	. 9 
l65c5h:
	ld (l65deh),a		;65c5	32 de 65 	2 . e 
	ld (l65edh),a		;65c8	32 ed 65 	2 . e 
	ld (l6608h),a		;65cb	32 08 66 	2 . f 
	ld a,c			;65ce	79 	y 
	ld (0661dh),a		;65cf	32 1d 66 	2 . f 
	call sub_6c47h		;65d2	cd 47 6c 	. G l 
	dec hl			;65d5	2b 	+ 
	ld c,(hl)			;65d6	4e 	N 
	inc hl			;65d7	23 	# 
	ld de,l8aa5h		;65d8	11 a5 8a 	. . . 
	call sub_65a3h		;65db	cd a3 65 	. . e 
l65deh:
	scf			;65de	37 	7 
	ld c,0d6h		;65df	0e d6 	. . 
	call c,sub_65a3h		;65e1	dc a3 65 	. . e 
	call sub_6c4ah		;65e4	cd 4a 6c 	. J l 
	ld a,02fh		;65e7	3e 2f 	> / 
	ld (l8aa5h),a		;65e9	32 a5 8a 	2 . . 
	ld a,(hl)			;65ec	7e 	~ 
l65edh:
	scf			;65ed	37 	7 
	jr nc,l65f5h		;65ee	30 05 	0 . 
	dec a			;65f0	3d 	= 
	inc hl			;65f1	23 	# 
	inc hl			;65f2	23 	# 
	inc hl			;65f3	23 	# 
	inc hl			;65f4	23 	# 
l65f5h:
	inc hl			;65f5	23 	# 
l65f6h:
	ld ix,l8aa7h		;65f6	dd 21 a7 8a 	. ! . . 
	dec a			;65fa	3d 	= 
	jr z,l6612h		;65fb	28 15 	( . 
	push af			;65fd	f5 	. 
	inc (ix-002h)		;65fe	dd 34 fe 	. 4 . 
	ld (ix-001h),03ah		;6601	dd 36 ff 3a 	. 6 . : 
	call sub_6622h		;6605	cd 22 66 	. " f 
l6608h:
	scf			;6608	37 	7 
	call c,sub_6622h		;6609	dc 22 66 	. " f 
	call sub_6c4ah		;660c	cd 4a 6c 	. J l 
	pop af			;660f	f1 	. 
	jr l65f6h		;6610	18 e4 	. . 
l6612h:
	call sub_8608h		;6612	cd 08 86 	. . . 
	cp 069h		;6615	fe 69 	. i 
	ret z			;6617	c8 	. 
	cp 030h		;6618	fe 30 	. 0 
	jr c,l661fh		;661a	38 03 	8 . 
	cp 035h		;661c	fe 35 	. 5 
	ret c			;661e	d8 	. 
l661fh:
	jp l5f74h		;661f	c3 74 5f 	. t _ 
sub_6622h:
	ld e,(hl)			;6622	5e 	^ 
	inc hl			;6623	23 	# 
	ld d,(hl)			;6624	56 	V 
	inc hl			;6625	23 	# 
	push hl			;6626	e5 	. 
	ex de,hl			;6627	eb 	. 
	push hl			;6628	e5 	. 
	call sub_6afeh		;6629	cd fe 6a 	. . j 
	pop de			;662c	d1 	. 
	call sub_6b14h		;662d	cd 14 6b 	. . k 
	push ix		;6630	dd e5 	. . 
	ld b,00ah		;6632	06 0a 	. . 
l6634h:
	ld (ix+000h),020h		;6634	dd 36 00 20 	. 6 .   
	inc ix		;6638	dd 23 	. # 
	djnz l6634h		;663a	10 f8 	. . 
	pop hl			;663c	e1 	. 
	jr c,l664ah		;663d	38 0b 	8 . 
	push hl			;663f	e5 	. 
	call sub_8116h		;6640	cd 16 81 	. . . 
	pop hl			;6643	e1 	. 
	inc hl			;6644	23 	# 
	ld b,009h		;6645	06 09 	. . 
	call sub_82d4h		;6647	cd d4 82 	. . . 
l664ah:
	pop hl			;664a	e1 	. 
	ret			;664b	c9 	. 
sub_664ch:
	ld hl,00000h		;664c	21 00 00 	! . . 
	ld (l7953h+1),hl		;664f	22 54 79 	" T y 
	ld (07935h),hl		;6652	22 35 79 	" 5 y 
	ld ix,l8b22h		;6655	dd 21 22 8b 	. ! " . 
	ret			;6659	c9 	. 
sub_665ah:
	ld hl,l8afeh		;665a	21 fe 8a 	! . . 
	ld (hl),080h		;665d	36 80 	6 . 
	inc hl			;665f	23 	# 
	ld (hl),001h		;6660	36 01 	6 . 
	inc hl			;6662	23 	# 
	ld bc,02000h		;6663	01 00 20 	. .   
	jp l82e1h		;6666	c3 e1 82 	. . . 
sub_6669h:
	ld hl,l6fd0h		;6669	21 d0 6f 	! . o 
	ld (08751h),hl		;666c	22 51 87 	" Q . 
	call sub_6113h		;666f	cd 13 61 	. . a 
	jp l85c7h		;6672	c3 c7 85 	. . . 
sub_6675h:
	call sub_6669h		;6675	cd 69 66 	. i f 
	call sub_8639h		;6678	cd 39 86 	. 9 . 
	cp 080h		;667b	fe 80 	. . 
	jr nc,sub_6675h		;667d	30 f6 	0 . 
	cp 004h		;667f	fe 04 	. . 
	jp z,l5f74h		;6681	ca 74 5f 	. t _ 
	cp 003h		;6684	fe 03 	. . 
	jr nz,l6690h		;6686	20 08 	  . 
	ld hl,(sub_7e3bh+1)		;6688	2a 3c 7e 	* < ~ 
	dec hl			;668b	2b 	+ 
	bit 7,(hl)		;668c	cb 7e 	. ~ 
	jr nz,sub_6675h		;668e	20 e5 	  . 
l6690h:
	call sub_7e3bh		;6690	cd 3b 7e 	. ; ~ 
	jr nz,sub_6675h		;6693	20 e0 	  . 
	call sub_6113h		;6695	cd 13 61 	. . a 
	jp sub_85f8h		;6698	c3 f8 85 	. . . 
sub_669bh:
	call sub_60c3h		;669b	cd c3 60 	. . ` 
	jp nz,0cde5h		;669e	c2 e5 cd 	. . . 
	jp 0c160h		;66a1	c3 60 c1 	. ` . 
	pop de			;66a4	d1 	. 
	add hl,de			;66a5	19 	. 
	dec hl			;66a6	2b 	+ 
	ret			;66a7	c9 	. 
sub_66a8h:
	call sub_60c3h		;66a8	cd c3 60 	. . ` 
	jp nz,0cde5h		;66ab	c2 e5 cd 	. . . 
	jp 0c360h		;66ae	c3 60 c3 	. ` . 
	pop de			;66b1	d1 	. 
	ret			;66b2	c9 	. 
sub_66b3h:
	pop af			;66b3	f1 	. 
	push hl			;66b4	e5 	. 
	push de			;66b5	d5 	. 
	push af			;66b6	f5 	. 
	ld b,d			;66b7	42 	B 
	ld c,e			;66b8	4b 	K 
sub_66b9h:
	ex de,hl			;66b9	eb 	. 
	call sub_6bddh		;66ba	cd dd 6b 	. . k 
	ld hl,l66d8h		;66bd	21 d8 66 	! . f 
	ld (l80a2h+1),hl		;66c0	22 a3 80 	" . . 
	ret nc			;66c3	d0 	. 
l66c4h:
	ld a,0cdh		;66c4	3e cd 	> . 
l66c6h:
	call sub_665ah		;66c6	cd 5a 66 	. Z f 
	ld hl,l8affh		;66c9	21 ff 8a 	! . . 
	ld (hl),a			;66cc	77 	w 
	inc hl			;66cd	23 	# 
	ld (hl),0d0h		;66ce	36 d0 	6 . 
	call sub_6669h		;66d0	cd 69 66 	. i f 
	ld a,000h		;66d3	3e 00 	> . 
	ld (l6f9bh),a		;66d5	32 9b 6f 	2 . o 
l66d8h:
	call sub_6d79h		;66d8	cd 79 6d 	. y m 
	call sub_8713h		;66db	cd 13 87 	. . . 
	call sub_8639h		;66de	cd 39 86 	. 9 . 
	call l6175h		;66e1	cd 75 61 	. u a 
	jp l5f74h		;66e4	c3 74 5f 	. t _ 
sub_66e7h:
	ld hl,(0603bh)		;66e7	2a 3b 60 	* ; ` 
l66eah:
	push hl			;66ea	e5 	. 
	call sub_6b56h		;66eb	cd 56 6b 	. V k 
	ex af,af'			;66ee	08 	. 
	jp nz,l5f74h		;66ef	c2 74 5f 	. t _ 
	ld (067cbh),hl		;66f2	22 cb 67 	" . g 
	ld (067a8h),hl		;66f5	22 a8 67 	" . g 
	ld (069f3h),de		;66f8	ed 53 f3 69 	. S . i 
	push bc			;66fc	c5 	. 
	ld a,(l6f9bh)		;66fd	3a 9b 6f 	: . o 
	ld (066d4h),a		;6700	32 d4 66 	2 . f 
	call sub_68e2h		;6703	cd e2 68 	. . h 
	pop bc			;6706	c1 	. 
	pop de			;6707	d1 	. 
	push bc			;6708	c5 	. 
	call sub_68b4h		;6709	cd b4 68 	. . h 
	pop bc			;670c	c1 	. 
	ld hl,l7066h		;670d	21 66 70 	! f p 
	call sub_6992h		;6710	cd 92 69 	. . i 
	jr c,l6735h		;6713	38 20 	8   
	ld hl,l680bh		;6715	21 0b 68 	! . h 
	call sub_6bd8h		;6718	cd d8 6b 	. . k 
	ld a,(hl)			;671b	7e 	~ 
	ld hl,l6813h		;671c	21 13 68 	! . h 
	call sub_6bd8h		;671f	cd d8 6b 	. . k 
	ld bc,l680ah		;6722	01 0a 68 	. . h 
	ld a,(067c8h)		;6725	3a c8 67 	: . g 
	call sub_6a53h		;6728	cd 53 6a 	. S j 
	ld (067a8h),hl		;672b	22 a8 67 	" . g 
	ld (06750h),bc		;672e	ed 43 50 67 	. C P g 
	ld (067a5h),a		;6732	32 a5 67 	2 . g 
l6735h:
	call l6762h		;6735	cd 62 67 	. b g 
	ex af,af'			;6738	08 	. 
	push af			;6739	f5 	. 
	exx			;673a	d9 	. 
	push hl			;673b	e5 	. 
	exx			;673c	d9 	. 
	pop de			;673d	d1 	. 
	ld hl,l5f33h		;673e	21 33 5f 	! 3 _ 
	ld a,(l68f2h+1)		;6741	3a f3 68 	: . h 
	or a			;6744	b7 	. 
	call z,sub_6c20h		;6745	cc 20 6c 	.   l 
	ld a,0ceh		;6748	3e ce 	> . 
	jp c,l66c6h		;674a	da c6 66 	. . f 
	pop af			;674d	f1 	. 
	or a			;674e	b7 	. 
	call nz,l680ah		;674f	c4 0a 68 	. . h 
	exx			;6752	d9 	. 
	ld (0603bh),hl		;6753	22 3b 60 	" ; ` 
	ld hl,(l6fb3h)		;6756	2a b3 6f 	* . o 
	add hl,de			;6759	19 	. 
	ld (l6fb3h),hl		;675a	22 b3 6f 	" . o 
sub_675dh:
	ld a,0bfh		;675d	3e bf 	> . 
	jp 01f56h		;675f	c3 56 1f 	. V . 
l6762h:
	ld a,0e9h		;6762	3e e9 	> . 
	call sub_6321h		;6764	cd 21 63 	. ! c 
	ld (067e1h),sp		;6767	ed 73 e1 67 	. s . g 
	ld sp,l6f9bh		;676b	31 9b 6f 	1 . o 
	pop hl			;676e	e1 	. 
	ld a,l			;676f	7d 	} 
	ld r,a		;6770	ed 4f 	. O 
	ld a,h			;6772	7c 	| 
	ld i,a		;6773	ed 47 	. G 
	pop bc			;6775	c1 	. 
	pop de			;6776	d1 	. 
	pop hl			;6777	e1 	. 
	pop af			;6778	f1 	. 
	exx			;6779	d9 	. 
	ex af,af'			;677a	08 	. 
	pop iy		;677b	fd e1 	. . 
	pop ix		;677d	dd e1 	. . 
	pop bc			;677f	c1 	. 
	pop de			;6780	d1 	. 
	pop hl			;6781	e1 	. 
	pop af			;6782	f1 	. 
	ld sp,(l6fb1h)		;6783	ed 7b b1 6f 	. { . o 
	jp l8b21h		;6787	c3 21 8b 	. ! . 
l678ah:
	ld (l6fb1h),sp		;678a	ed 73 b1 6f 	. s . o 
	ld sp,l8b21h		;678e	31 21 8b 	1 ! . 
	push af			;6791	f5 	. 
	ld a,i		;6792	ed 57 	. W 
	push af			;6794	f5 	. 
	ld a,r		;6795	ed 5f 	. _ 
	di			;6797	f3 	. 
	push af			;6798	f5 	. 
	pop af			;6799	f1 	. 
	pop af			;679a	f1 	. 
	pop af			;679b	f1 	. 
	ld sp,l6fb1h		;679c	31 b1 6f 	1 . o 
	push af			;679f	f5 	. 
	push hl			;67a0	e5 	. 
	push de			;67a1	d5 	. 
	ld a,001h		;67a2	3e 01 	> . 
	ld de,00000h		;67a4	11 00 00 	. . . 
	ld hl,00000h		;67a7	21 00 00 	! . . 
	jr l67ceh		;67aa	18 22 	. " 
l67ach:
	nop			;67ac	00 	. 
l67adh:
	ld (l6fb1h),sp		;67ad	ed 73 b1 6f 	. s . o 
	ld sp,l8b21h		;67b1	31 21 8b 	1 ! . 
	push af			;67b4	f5 	. 
	ld a,i		;67b5	ed 57 	. W 
	push af			;67b7	f5 	. 
	ld a,r		;67b8	ed 5f 	. _ 
	di			;67ba	f3 	. 
	push af			;67bb	f5 	. 
	pop af			;67bc	f1 	. 
	pop af			;67bd	f1 	. 
	pop af			;67be	f1 	. 
	ld sp,l6fb1h		;67bf	31 b1 6f 	1 . o 
	push af			;67c2	f5 	. 
	push hl			;67c3	e5 	. 
	push de			;67c4	d5 	. 
	ld a,000h		;67c5	3e 00 	> . 
	ld de,00004h		;67c7	11 04 00 	. . . 
	ld hl,00000h		;67ca	21 00 00 	! . . 
	nop			;67cd	00 	. 
l67ceh:
	push bc			;67ce	c5 	. 
	push ix		;67cf	dd e5 	. . 
	push iy		;67d1	fd e5 	. . 
	exx			;67d3	d9 	. 
	ex af,af'			;67d4	08 	. 
	push af			;67d5	f5 	. 
	push hl			;67d6	e5 	. 
	push de			;67d7	d5 	. 
	push bc			;67d8	c5 	. 
	ld a,i		;67d9	ed 57 	. W 
	ld h,a			;67db	67 	g 
	ld a,r		;67dc	ed 5f 	. _ 
	ld l,a			;67de	6f 	o 
	push hl			;67df	e5 	. 
	ld sp,00000h		;67e0	31 00 00 	1 . . 
	ld a,0dbh		;67e3	3e db 	> . 
	call sub_6321h		;67e5	cd 21 63 	. ! c 
	ld hl,l8b1dh		;67e8	21 1d 8b 	! . . 
	ld a,(hl)			;67eb	7e 	~ 
	dec hl			;67ec	2b 	+ 
	dec hl			;67ed	2b 	+ 
	or (hl)			;67ee	b6 	. 
	and 004h		;67ef	e6 04 	. . 
	rrca			;67f1	0f 	. 
	rrca			;67f2	0f 	. 
	ld (l6e65h+1),a		;67f3	32 66 6e 	2 f n 
	ret			;67f6	c9 	. 
l67f7h:
	ld hl,(l6fb1h)		;67f7	2a b1 6f 	* . o 
	ld de,(067cbh)		;67fa	ed 5b cb 67 	. [ . g 
	ld (hl),e			;67fe	73 	s 
	inc hl			;67ff	23 	# 
	ld (hl),d			;6800	72 	r 
	ret			;6801	c9 	. 
l6802h:
	ld hl,(l6fb1h)		;6802	2a b1 6f 	* . o 
	inc hl			;6805	23 	# 
	inc hl			;6806	23 	# 
	ld (l6fb1h),hl		;6807	22 b1 6f 	" . o 
l680ah:
	ret			;680a	c9 	. 
l680bh:
	nop			;680b	00 	. 
	inc d			;680c	14 	. 
	ld c,d			;680d	4a 	J 
	ld h,a			;680e	67 	g 
	ld a,h			;680f	7c 	| 
	add a,c			;6810	81 	. 
l6811h:
	add a,(hl)			;6811	86 	. 
	sub l			;6812	95 	. 
l6813h:
	ld hl,l8b23h		;6813	21 23 8b 	! # . 
	ld e,(hl)			;6816	5e 	^ 
	ld (hl),003h		;6817	36 03 	6 . 
l6819h:
	ld hl,(067cbh)		;6819	2a cb 67 	* . g 
	ld d,000h		;681c	16 00 	. . 
	bit 7,e		;681e	cb 7b 	. { 
	jr z,l6823h		;6820	28 01 	( . 
	dec d			;6822	15 	. 
l6823h:
	add hl,de			;6823	19 	. 
	add a,005h		;6824	c6 05 	. . 
	ret			;6826	c9 	. 
l6827h:
	cp 00ah		;6827	fe 0a 	. . 
l6829h:
	jr z,l6852h		;6829	28 27 	( ' 
	exx			;682b	d9 	. 
	ld de,(l8b23h)		;682c	ed 5b 23 8b 	. [ # . 
	ld (l6844h+1),sp		;6830	ed 73 45 68 	. s E h 
	ld hl,05f4dh		;6834	21 4d 5f 	! M _ 
	ld b,(hl)			;6837	46 	F 
	inc hl			;6838	23 	# 
l6839h:
	ld sp,hl			;6839	f9 	. 
l683ah:
	djnz l683eh		;683a	10 02 	. . 
	jr l6844h		;683c	18 06 	. . 
l683eh:
	pop hl			;683e	e1 	. 
	or a			;683f	b7 	. 
	sbc hl,de		;6840	ed 52 	. R 
	jr nz,l683ah		;6842	20 f6 	  . 
l6844h:
	ld sp,00000h		;6844	31 00 00 	1 . . 
	exx			;6847	d9 	. 
l6848h:
	nop			;6848	00 	. 
	add a,008h		;6849	c6 08 	. . 
	ld hl,067c8h		;684b	21 c8 67 	! . g 
	inc (hl)			;684e	34 	4 
	ld bc,l67f7h		;684f	01 f7 67 	. . g 
l6852h:
	ld hl,(l8b23h)		;6852	2a 23 8b 	* # . 
	ld de,l8b28h		;6855	11 28 8b 	. ( . 
	ld (l8b23h),de		;6858	ed 53 23 8b 	. S # . 
	ret			;685c	c9 	. 
	ld hl,(l6fb1h)		;685d	2a b1 6f 	* . o 
	ld e,(hl)			;6860	5e 	^ 
	inc hl			;6861	23 	# 
	ld d,(hl)			;6862	56 	V 
	ld hl,l8b22h		;6863	21 22 8b 	! " . 
	ld a,(hl)			;6866	7e 	~ 
	add a,002h		;6867	c6 02 	. . 
	cp 0cbh		;6869	fe cb 	. . 
	jr nz,l686fh		;686b	20 02 	  . 
	sub 008h		;686d	d6 08 	. . 
l686fh:
	ld (hl),a			;686f	77 	w 
	call sub_68ceh		;6870	cd ce 68 	. . h 
	ld a,00ah		;6873	3e 0a 	> . 
	ld bc,l6802h		;6875	01 02 68 	. . h 
	jr l688ah		;6878	18 10 	. . 
	ld hl,l8b22h		;687a	21 22 8b 	! " . 
	ld a,(hl)			;687d	7e 	~ 
	and 038h		;687e	e6 38 	. 8 
l6880h:
	ld (hl),0cdh		;6880	36 cd 	6 . 
	inc hl			;6882	23 	# 
	ld (hl),a			;6883	77 	w 
	inc hl			;6884	23 	# 
	ld (hl),000h		;6885	36 00 	6 . 
	inc hl			;6887	23 	# 
	ld a,003h		;6888	3e 03 	> . 
l688ah:
	call sub_68c3h		;688a	cd c3 68 	. . h 
	jr l6827h		;688d	18 98 	. . 
	ld hl,(l6fabh+2)		;688f	2a ad 6f 	* . o 
	jr l68a0h		;6892	18 0c 	. . 
	ld hl,(l6fa5h+2)		;6894	2a a7 6f 	* . o 
	jr l689ch		;6897	18 03 	. . 
	ld hl,(l6fa5h)		;6899	2a a5 6f 	* . o 
l689ch:
	xor a			;689c	af 	. 
	ld (l8b23h),a		;689d	32 23 8b 	2 # . 
l68a0h:
	xor a			;68a0	af 	. 
	ld (l8b22h),a		;68a1	32 22 8b 	2 " . 
	ld (067cbh),hl		;68a4	22 cb 67 	" . g 
	ret			;68a7	c9 	. 
	ld bc,l6802h		;68a8	01 02 68 	. . h 
	ld hl,(l6fb1h)		;68ab	2a b1 6f 	* . o 
	ld e,(hl)			;68ae	5e 	^ 
	inc hl			;68af	23 	# 
	ld d,(hl)			;68b0	56 	V 
	ex de,hl			;68b1	eb 	. 
	jr l689ch		;68b2	18 e8 	. . 
sub_68b4h:
	ld hl,(067cbh)		;68b4	2a cb 67 	* . g 
	and a			;68b7	a7 	. 
	sbc hl,de		;68b8	ed 52 	. R 
	ld b,h			;68ba	44 	D 
	ld c,l			;68bb	4d 	M 
	call sub_68d4h		;68bc	cd d4 68 	. . h 
	ex de,hl			;68bf	eb 	. 
	ldir		;68c0	ed b0 	. . 
	ex de,hl			;68c2	eb 	. 
sub_68c3h:
	ld de,l67adh		;68c3	11 ad 67 	. . g 
	call sub_68cch		;68c6	cd cc 68 	. . h 
	ld de,l678ah		;68c9	11 8a 67 	. . g 
sub_68cch:
	ld (hl),0c3h		;68cc	36 c3 	6 . 
sub_68ceh:
	inc hl			;68ce	23 	# 
	ld (hl),e			;68cf	73 	s 
	inc hl			;68d0	23 	# 
	ld (hl),d			;68d1	72 	r 
	inc hl			;68d2	23 	# 
	ret			;68d3	c9 	. 
sub_68d4h:
	ld hl,l8b21h		;68d4	21 21 8b 	! ! . 
	ld a,(l6e65h+1)		;68d7	3a 66 6e 	: f n 
	add a,a			;68da	87 	. 
	add a,a			;68db	87 	. 
	add a,a			;68dc	87 	. 
	add a,0f3h		;68dd	c6 f3 	. . 
	ld (hl),a			;68df	77 	w 
	inc hl			;68e0	23 	# 
	ret			;68e1	c9 	. 
sub_68e2h:
	ld a,b			;68e2	78 	x 
	sub 076h		;68e3	d6 76 	. v 
	or c			;68e5	b1 	. 
	jr nz,l68f2h		;68e6	20 0a 	  . 
	ld a,(l6e65h+1)		;68e8	3a 66 6e 	: f n 
	or a			;68eb	b7 	. 
	ret nz			;68ec	c0 	. 
	ld a,0cfh		;68ed	3e cf 	> . 
	jp l66c6h		;68ef	c3 c6 66 	. . f 
l68f2h:
	ld a,000h		;68f2	3e 00 	> . 
	or a			;68f4	b7 	. 
	ret nz			;68f5	c0 	. 
	ld a,c			;68f6	79 	y 
	and 040h		;68f7	e6 40 	. @ 
	jr z,l6952h		;68f9	28 57 	( W 
	ld a,b			;68fb	78 	x 
	exx			;68fc	d9 	. 
	cp 0b0h		;68fd	fe b0 	. . 
	ld bc,(l6fa9h)		;68ff	ed 4b a9 6f 	. K . o 
	ld de,(l6fabh)		;6903	ed 5b ab 6f 	. [ . o 
	ld hl,(l6fabh+2)		;6907	2a ad 6f 	* . o 
	jr nz,l6916h		;690a	20 0a 	  . 
l690ch:
	push hl			;690c	e5 	. 
	add hl,bc			;690d	09 	. 
	dec hl			;690e	2b 	+ 
	push hl			;690f	e5 	. 
	ex de,hl			;6910	eb 	. 
	push hl			;6911	e5 	. 
	add hl,bc			;6912	09 	. 
	dec hl			;6913	2b 	+ 
	jr l6928h		;6914	18 12 	. . 
l6916h:
	cp 0b8h		;6916	fe b8 	. . 
	jr nz,l6951h		;6918	20 37 	  7 
	push hl			;691a	e5 	. 
	and a			;691b	a7 	. 
	sbc hl,bc		;691c	ed 42 	. B 
	inc hl			;691e	23 	# 
	ex (sp),hl			;691f	e3 	. 
	push hl			;6920	e5 	. 
	ex de,hl			;6921	eb 	. 
	push hl			;6922	e5 	. 
	and a			;6923	a7 	. 
	sbc hl,bc		;6924	ed 42 	. B 
	inc hl			;6926	23 	# 
	ex (sp),hl			;6927	e3 	. 
l6928h:
	push hl			;6928	e5 	. 
	ld h,b			;6929	60 	` 
	ld l,c			;692a	69 	i 
	ld de,00015h		;692b	11 15 00 	. . . 
	call sub_7b3ah		;692e	cd 3a 7b 	. : { 
	dec hl			;6931	2b 	+ 
	dec hl			;6932	2b 	+ 
	dec hl			;6933	2b 	+ 
	dec hl			;6934	2b 	+ 
	dec hl			;6935	2b 	+ 
	ld (067c8h),hl		;6936	22 c8 67 	" . g 
	ld hl,05f19h		;6939	21 19 5f 	! . _ 
	pop de			;693c	d1 	. 
	pop bc			;693d	c1 	. 
	call sub_6be8h		;693e	cd e8 6b 	. . k 
	jp c,l66c4h		;6941	da c4 66 	. . f 
	ld hl,05effh		;6944	21 ff 5e 	! . ^ 
	pop de			;6947	d1 	. 
	pop bc			;6948	c1 	. 
	call sub_6be8h		;6949	cd e8 6b 	. . k 
	jp c,l66c4h		;694c	da c4 66 	. . f 
	exx			;694f	d9 	. 
	ret			;6950	c9 	. 
l6951h:
	exx			;6951	d9 	. 
l6952h:
	ld hl,l6fb9h		;6952	21 b9 6f 	! . o 
	push de			;6955	d5 	. 
	call sub_6992h		;6956	cd 92 69 	. . i 
	ld hl,05effh		;6959	21 ff 5e 	! . ^ 
	call sub_6969h		;695c	cd 69 69 	. i i 
	ld hl,l700bh		;695f	21 0b 70 	! . p 
sub_6962h:
	pop de			;6962	d1 	. 
	call sub_6992h		;6963	cd 92 69 	. . i 
	ld hl,05f19h		;6966	21 19 5f 	! . _ 
sub_6969h:
	ret c			;6969	d8 	. 
	push hl			;696a	e5 	. 
	push af			;696b	f5 	. 
	ld hl,l69c3h		;696c	21 c3 69 	! . i 
	call sub_6bd8h		;696f	cd d8 6b 	. . k 
	ld a,(hl)			;6972	7e 	~ 
	ld hl,l69cbh		;6973	21 cb 69 	! . i 
	call sub_6bd8h		;6976	cd d8 6b 	. . k 
	call sub_6a53h		;6979	cd 53 6a 	. S j 
	pop af			;697c	f1 	. 
	ex (sp),hl			;697d	e3 	. 
	pop de			;697e	d1 	. 
	push af			;697f	f5 	. 
	push hl			;6980	e5 	. 
	call sub_6c20h		;6981	cd 20 6c 	.   l 
	pop hl			;6984	e1 	. 
	jp c,l66c4h		;6985	da c4 66 	. . f 
	pop af			;6988	f1 	. 
	ret z			;6989	c8 	. 
	inc de			;698a	13 	. 
	call sub_6c20h		;698b	cd 20 6c 	.   l 
	jp c,l66c4h		;698e	da c4 66 	. . f 
	ret			;6991	c9 	. 
sub_6992h:
	ld a,c			;6992	79 	y 
	and 0f0h		;6993	e6 f0 	. . 
	ld c,a			;6995	4f 	O 
	ld d,(hl)			;6996	56 	V 
	inc hl			;6997	23 	# 
l6998h:
	ld a,b			;6998	78 	x 
	and (hl)			;6999	a6 	. 
	inc hl			;699a	23 	# 
	cp (hl)			;699b	be 	. 
	inc hl			;699c	23 	# 
	jr z,l69a5h		;699d	28 06 	( . 
l699fh:
	inc hl			;699f	23 	# 
	dec d			;69a0	15 	. 
	jr nz,l6998h		;69a1	20 f5 	  . 
	scf			;69a3	37 	7 
	ret			;69a4	c9 	. 
l69a5h:
	ld a,(hl)			;69a5	7e 	~ 
	and 0f0h		;69a6	e6 f0 	. . 
	cp c			;69a8	b9 	. 
	jr nz,l699fh		;69a9	20 f4 	  . 
	ld a,(hl)			;69ab	7e 	~ 
	and 00fh		;69ac	e6 0f 	. . 
	bit 3,a		;69ae	cb 5f 	. _ 
	res 3,a		;69b0	cb 9f 	. . 
	ret			;69b2	c9 	. 
	ld hl,l69c3h		;69b3	21 c3 69 	! . i 
	call sub_6bd8h		;69b6	cd d8 6b 	. . k 
	ld a,(hl)			;69b9	7e 	~ 
	ld hl,l69cbh		;69ba	21 cb 69 	! . i 
	call sub_6bd8h		;69bd	cd d8 6b 	. . k 
	call sub_6a53h		;69c0	cd 53 6a 	. S j 
l69c3h:
	nop			;69c3	00 	. 
	inc b			;69c4	04 	. 
	ex af,af'			;69c5	08 	. 
	inc c			;69c6	0c 	. 
	ld de,0211dh		;69c7	11 1d 21 	. . ! 
	daa			;69ca	27 	' 
l69cbh:
	ld hl,(l6fa9h)		;69cb	2a a9 6f 	* . o 
	ret			;69ce	c9 	. 
	ld hl,(l6fabh)		;69cf	2a ab 6f 	* . o 
	ret			;69d2	c9 	. 
	ld hl,(l6fabh+2)		;69d3	2a ad 6f 	* . o 
	ret			;69d6	c9 	. 
	ld hl,(l6fa5h+2)		;69d7	2a a7 6f 	* . o 
	jr l69dfh		;69da	18 03 	. . 
	ld hl,(l6fa5h)		;69dc	2a a5 6f 	* . o 
l69dfh:
	bit 7,e		;69df	cb 7b 	. { 
	ld d,000h		;69e1	16 00 	. . 
	jr z,l69e6h		;69e3	28 01 	( . 
	dec d			;69e5	15 	. 
l69e6h:
	add hl,de			;69e6	19 	. 
	ret			;69e7	c9 	. 
	ld hl,(l6fb1h)		;69e8	2a b1 6f 	* . o 
	ret			;69eb	c9 	. 
	ld hl,(l6fb1h)		;69ec	2a b1 6f 	* . o 
	dec hl			;69ef	2b 	+ 
	dec hl			;69f0	2b 	+ 
	ret			;69f1	c9 	. 
	ld hl,00000h		;69f2	21 00 00 	! . . 
	ret			;69f5	c9 	. 
l69f6h:
	ld e,(hl)			;69f6	5e 	^ 
	inc hl			;69f7	23 	# 
	ld d,(hl)			;69f8	56 	V 
	ld bc,00937h		;69f9	01 37 09 	. 7 . 
	jr l6a07h		;69fc	18 09 	. . 
l69feh:
	ld hl,(l6a89h+1)		;69fe	2a 8a 6a 	* . j 
	ld d,000h		;6a01	16 00 	. . 
	ld e,(hl)			;6a03	5e 	^ 
	ld bc,00637h		;6a04	01 37 06 	. 7 . 
l6a07h:
	inc hl			;6a07	23 	# 
	jr l6a39h		;6a08	18 2f 	. / 
sub_6a0ah:
	ld a,000h		;6a0a	3e 00 	> . 
	or a			;6a0c	b7 	. 
	jr z,l6a1eh		;6a0d	28 0f 	( . 
sub_6a0fh:
	ld a,020h		;6a0f	3e 20 	>   
	ld b,a			;6a11	47 	G 
	ld de,l8aa5h		;6a12	11 a5 8a 	. . . 
l6a15h:
	ld (de),a			;6a15	12 	. 
	inc de			;6a16	13 	. 
	djnz l6a15h		;6a17	10 fc 	. . 
sub_6a19h:
	xor a			;6a19	af 	. 
	ld (sub_6a0ah+1),a		;6a1a	32 0b 6a 	2 . j 
	ret			;6a1d	c9 	. 
l6a1eh:
	ld (l6a89h+1),hl		;6a1e	22 8a 6a 	" . j 
	ex de,hl			;6a21	eb 	. 
	ld hl,05eb2h		;6a22	21 b2 5e 	! . ^ 
	call sub_6c20h		;6a25	cd 20 6c 	.   l 
	jr c,l69feh		;6a28	38 d4 	8 . 
	ld hl,l5ecch		;6a2a	21 cc 5e 	! . ^ 
	call sub_6c20h		;6a2d	cd 20 6c 	.   l 
	ex de,hl			;6a30	eb 	. 
	jr c,l69f6h		;6a31	38 c3 	8 . 
	call sub_6b56h		;6a33	cd 56 6b 	. V k 
	ex af,af'			;6a36	08 	. 
	jr nz,l69feh		;6a37	20 c5 	  . 
l6a39h:
	push hl			;6a39	e5 	. 
	ld ix,l8b23h		;6a3a	dd 21 23 8b 	. ! # . 
	ld (ix-001h),c		;6a3e	dd 71 ff 	. q . 
	ld (ix-002h),b		;6a41	dd 70 fe 	. p . 
	ld a,c			;6a44	79 	y 
	and 007h		;6a45	e6 07 	. . 
	ld c,a			;6a47	4f 	O 
	ld b,000h		;6a48	06 00 	. . 
	ld hl,l6a54h		;6a4a	21 54 6a 	! T j 
	add hl,bc			;6a4d	09 	. 
	ld c,(hl)			;6a4e	4e 	N 
	ld hl,l6a69h		;6a4f	21 69 6a 	! i j 
	add hl,bc			;6a52	09 	. 
sub_6a53h:
	jp (hl)			;6a53	e9 	. 
l6a54h:
	ld e,c			;6a54	59 	Y 
	ld d,e			;6a55	53 	S 
	daa			;6a56	27 	' 
	add hl,de			;6a57	19 	. 
	nop			;6a58	00 	. 
	dec b			;6a59	05 	. 
	ld c,h			;6a5a	4c 	L 
	daa			;6a5b	27 	' 
sub_6a5ch:
	bit 7,e		;6a5c	cb 7b 	. { 
	ret z			;6a5e	c8 	. 
	ld (ix+000h),02dh		;6a5f	dd 36 00 2d 	. 6 . - 
	inc ix		;6a63	dd 23 	. # 
	xor a			;6a65	af 	. 
	sub e			;6a66	93 	. 
	ld e,a			;6a67	5f 	_ 
	ret			;6a68	c9 	. 
l6a69h:
	call sub_6a5ch		;6a69	cd 5c 6a 	. \ j 
	jr l6abch		;6a6c	18 4e 	. N 
	call sub_6a5ch		;6a6e	cd 5c 6a 	. \ j 
	ld h,000h		;6a71	26 00 	& . 
	ld l,e			;6a73	6b 	k 
	push de			;6a74	d5 	. 
	call sub_6b02h		;6a75	cd 02 6b 	. . k 
	pop de			;6a78	d1 	. 
	ld e,d			;6a79	5a 	Z 
	ld (ix+000h),01fh		;6a7a	dd 36 00 1f 	. 6 . . 
	inc ix		;6a7e	dd 23 	. # 
	jr l6abch		;6a80	18 3a 	. : 
	ld d,000h		;6a82	16 00 	. . 
	bit 7,e		;6a84	cb 7b 	. { 
	jr z,l6a89h		;6a86	28 01 	( . 
	dec d			;6a88	15 	. 
l6a89h:
	ld hl,00001h		;6a89	21 01 00 	! . . 
	inc hl			;6a8c	23 	# 
	inc hl			;6a8d	23 	# 
	add hl,de			;6a8e	19 	. 
	ex de,hl			;6a8f	eb 	. 
	ld c,000h		;6a90	0e 00 	. . 
	dec c			;6a92	0d 	. 
	jr z,l6abeh		;6a93	28 29 	( ) 
	call sub_6b14h		;6a95	cd 14 6b 	. . k 
	jr c,l6a9fh		;6a98	38 05 	8 . 
	call sub_6b07h		;6a9a	cd 07 6b 	. . k 
	jr l6ac2h		;6a9d	18 23 	. # 
l6a9fh:
	dec c			;6a9f	0d 	. 
	jr z,l6abeh		;6aa0	28 1c 	( . 
	dec de			;6aa2	1b 	. 
	call sub_6b14h		;6aa3	cd 14 6b 	. . k 
	inc de			;6aa6	13 	. 
	jr c,l6abeh		;6aa7	38 15 	8 . 
	dec de			;6aa9	1b 	. 
	call sub_6b07h		;6aaa	cd 07 6b 	. . k 
	ld de,02b31h		;6aad	11 31 2b 	. 1 + 
	call sub_6b09h		;6ab0	cd 09 6b 	. . k 
	jr l6ac2h		;6ab3	18 0d 	. . 
	ld hl,(l6a89h+1)		;6ab5	2a 8a 6a 	* . j 
	ld a,(hl)			;6ab8	7e 	~ 
	and 038h		;6ab9	e6 38 	. 8 
	ld e,a			;6abb	5f 	_ 
l6abch:
	ld d,000h		;6abc	16 00 	. . 
l6abeh:
	ex de,hl			;6abe	eb 	. 
	call sub_6b02h		;6abf	cd 02 6b 	. . k 
l6ac2h:
	ld (ix+000h),0c0h		;6ac2	dd 36 00 c0 	. 6 . . 
	ld ix,l8b21h		;6ac6	dd 21 21 8b 	. ! ! . 
	call sub_8135h		;6aca	cd 35 81 	. 5 . 
	ld ix,l8aa5h		;6acd	dd 21 a5 8a 	. ! . . 
	ld de,(l6a89h+1)		;6ad1	ed 5b 8a 6a 	. [ . j 
	ld a,(06a91h)		;6ad5	3a 91 6a 	: . j 
	dec a			;6ad8	3d 	= 
	jr z,l6aedh		;6ad9	28 12 	( . 
	call sub_6b14h		;6adb	cd 14 6b 	. . k 
	jr c,l6aedh		;6ade	38 0d 	8 . 
	call sub_8116h		;6ae0	cd 16 81 	. . . 
	ld b,009h		;6ae3	06 09 	. . 
	push ix		;6ae5	dd e5 	. . 
	pop hl			;6ae7	e1 	. 
	call sub_82d4h		;6ae8	cd d4 82 	. . . 
	jr l6afah		;6aeb	18 0d 	. . 
l6aedh:
	ld a,001h		;6aed	3e 01 	> . 
	dec a			;6aef	3d 	= 
	jr nz,l6afah		;6af0	20 08 	  . 
	ex de,hl			;6af2	eb 	. 
	call sub_6afeh		;6af3	cd fe 6a 	. . j 
	ld (ix+000h),020h		;6af6	dd 36 00 20 	. 6 .   
l6afah:
	pop hl			;6afa	e1 	. 
	ret			;6afb	c9 	. 
sub_6afch:
	inc ix		;6afc	dd 23 	. # 
sub_6afeh:
	ld c,000h		;6afe	0e 00 	. . 
	jr l6b04h		;6b00	18 02 	. . 
sub_6b02h:
	ld c,001h		;6b02	0e 01 	. . 
l6b04h:
	jp sub_8908h		;6b04	c3 08 89 	. . . 
sub_6b07h:
	set 7,d		;6b07	cb fa 	. . 
sub_6b09h:
	ld (ix+000h),d		;6b09	dd 72 00 	. r . 
	inc ix		;6b0c	dd 23 	. # 
	ld (ix+000h),e		;6b0e	dd 73 00 	. s . 
	inc ix		;6b11	dd 23 	. # 
	ret			;6b13	c9 	. 
sub_6b14h:
	push bc			;6b14	c5 	. 
l6b15h:
	exx			;6b15	d9 	. 
	ld de,00000h		;6b16	11 00 00 	. . . 
	ld hl,(087d7h)		;6b19	2a d7 87 	* . . 
	ld c,(hl)			;6b1c	4e 	N 
	inc hl			;6b1d	23 	# 
	ld b,(hl)			;6b1e	46 	F 
	inc hl			;6b1f	23 	# 
	push hl			;6b20	e5 	. 
	add hl,bc			;6b21	09 	. 
	add hl,bc			;6b22	09 	. 
	ld (06b41h),hl		;6b23	22 41 6b 	" A k 
	exx			;6b26	d9 	. 
	pop hl			;6b27	e1 	. 
	exx			;6b28	d9 	. 
l6b29h:
	ld a,b			;6b29	78 	x 
	or c			;6b2a	b1 	. 
	scf			;6b2b	37 	7 
	jr z,l6b53h		;6b2c	28 25 	( % 
	exx			;6b2e	d9 	. 
	inc hl			;6b2f	23 	# 
	ld a,(hl)			;6b30	7e 	~ 
	ld c,a			;6b31	4f 	O 
	and 0c0h		;6b32	e6 c0 	. . 
	ld a,c			;6b34	79 	y 
	jr nz,l6b3ah		;6b35	20 03 	  . 
	inc a			;6b37	3c 	< 
	jr l6b4ch		;6b38	18 12 	. . 
l6b3ah:
	push hl			;6b3a	e5 	. 
	dec hl			;6b3b	2b 	+ 
	ld l,(hl)			;6b3c	6e 	n 
	and 03fh		;6b3d	e6 3f 	. ? 
	ld h,a			;6b3f	67 	g 
	ld bc,l9c38h		;6b40	01 38 9c 	. 8 . 
	add hl,bc			;6b43	09 	. 
	ld a,(hl)			;6b44	7e 	~ 
	inc hl			;6b45	23 	# 
	ld h,(hl)			;6b46	66 	f 
	ld l,a			;6b47	6f 	o 
	xor a			;6b48	af 	. 
	sbc hl,de		;6b49	ed 52 	. R 
	pop hl			;6b4b	e1 	. 
l6b4ch:
	inc hl			;6b4c	23 	# 
	exx			;6b4d	d9 	. 
	dec bc			;6b4e	0b 	. 
	inc de			;6b4f	13 	. 
	jr nz,l6b29h		;6b50	20 d7 	  . 
	exx			;6b52	d9 	. 
l6b53h:
	exx			;6b53	d9 	. 
	pop bc			;6b54	c1 	. 
	ret			;6b55	c9 	. 
sub_6b56h:
	ld a,(hl)			;6b56	7e 	~ 
	and 0c7h		;6b57	e6 c7 	. . 
	cp 0c7h		;6b59	fe c7 	. . 
	ld b,a			;6b5b	47 	G 
	ld c,000h		;6b5c	0e 00 	. . 
	jr z,l6b8eh		;6b5e	28 2e 	( . 
	ld a,(hl)			;6b60	7e 	~ 
	ld c,040h		;6b61	0e 40 	. @ 
	cp 0edh		;6b63	fe ed 	. . 
	jr z,l6b8ch		;6b65	28 25 	( % 
	ld c,000h		;6b67	0e 00 	. . 
	cp 0ddh		;6b69	fe dd 	. . 
	jr nz,l6b71h		;6b6b	20 04 	  . 
	set 5,c		;6b6d	cb e9 	. . 
	jr l6b77h		;6b6f	18 06 	. . 
l6b71h:
	cp 0fdh		;6b71	fe fd 	. . 
	jr nz,l6b86h		;6b73	20 11 	  . 
	set 4,c		;6b75	cb e1 	. . 
l6b77h:
	inc hl			;6b77	23 	# 
	ld a,(hl)			;6b78	7e 	~ 
	cp 0cbh		;6b79	fe cb 	. . 
	jr nz,l6b8dh		;6b7b	20 10 	  . 
	set 7,c		;6b7d	cb f9 	. . 
	inc hl			;6b7f	23 	# 
	ld e,(hl)			;6b80	5e 	^ 
	inc hl			;6b81	23 	# 
	ld b,(hl)			;6b82	46 	F 
	push hl			;6b83	e5 	. 
	jr l6b93h		;6b84	18 0d 	. . 
l6b86h:
	cp 0cbh		;6b86	fe cb 	. . 
	jr nz,l6b8dh		;6b88	20 03 	  . 
	set 7,c		;6b8a	cb f9 	. . 
l6b8ch:
	inc hl			;6b8c	23 	# 
l6b8dh:
	ld b,(hl)			;6b8d	46 	F 
l6b8eh:
	inc hl			;6b8e	23 	# 
	push hl			;6b8f	e5 	. 
	ld e,(hl)			;6b90	5e 	^ 
	inc hl			;6b91	23 	# 
	ld d,(hl)			;6b92	56 	V 
l6b93h:
	push de			;6b93	d5 	. 
	ld a,c			;6b94	79 	y 
	cp 03fh		;6b95	fe 3f 	. ? 
	jr nc,l6bach		;6b97	30 13 	0 . 
	cp 010h		;6b99	fe 10 	. . 
	ld a,b			;6b9b	78 	x 
	jr nc,l6baah		;6b9c	30 0c 	0 . 
	cp 018h		;6b9e	fe 18 	. . 
	jr z,l6bb0h		;6ba0	28 0e 	( . 
	cp 0c9h		;6ba2	fe c9 	. . 
	jr z,l6bb0h		;6ba4	28 0a 	( . 
	cp 0c3h		;6ba6	fe c3 	. . 
	jr z,l6bb0h		;6ba8	28 06 	( . 
l6baah:
	cp 0e9h		;6baa	fe e9 	. . 
l6bach:
	ld a,000h		;6bac	3e 00 	> . 
	jr nz,l6bb2h		;6bae	20 02 	  . 
l6bb0h:
	ld a,001h		;6bb0	3e 01 	> . 
l6bb2h:
	ld (sub_6a0ah+1),a		;6bb2	32 0b 6a 	2 . j 
	push bc			;6bb5	c5 	. 
	call sub_831ch		;6bb6	cd 1c 83 	. . . 
	ex af,af'			;6bb9	08 	. 
	pop bc			;6bba	c1 	. 
	ld a,(hl)			;6bbb	7e 	~ 
	and 01fh		;6bbc	e6 1f 	. . 
	ld (067c8h),a		;6bbe	32 c8 67 	2 . g 
	xor a			;6bc1	af 	. 
	ld (067c9h),a		;6bc2	32 c9 67 	2 . g 
	dec hl			;6bc5	2b 	+ 
	dec hl			;6bc6	2b 	+ 
	dec hl			;6bc7	2b 	+ 
	ld a,(hl)			;6bc8	7e 	~ 
	and 007h		;6bc9	e6 07 	. . 
	or c			;6bcb	b1 	. 
	ld c,a			;6bcc	4f 	O 
	pop de			;6bcd	d1 	. 
	and 007h		;6bce	e6 07 	. . 
	ld hl,l79fah		;6bd0	21 fa 79 	! . y 
	call sub_6bd8h		;6bd3	cd d8 6b 	. . k 
	ld a,(hl)			;6bd6	7e 	~ 
	pop hl			;6bd7	e1 	. 
sub_6bd8h:
	add a,l			;6bd8	85 	. 
	ld l,a			;6bd9	6f 	o 
	ret nc			;6bda	d0 	. 
	inc h			;6bdb	24 	$ 
	ret			;6bdc	c9 	. 
sub_6bddh:
	ld (l6c1ch+1),sp		;6bdd	ed 73 1d 6c 	. s . l 
	ld a,002h		;6be1	3e 02 	> . 
	ld sp,05f1ah		;6be3	31 1a 5f 	1 . _ 
	jr l6befh		;6be6	18 07 	. . 
sub_6be8h:
	ld (l6c1ch+1),sp		;6be8	ed 73 1d 6c 	. s . l 
	ld a,(hl)			;6bec	7e 	~ 
	inc hl			;6bed	23 	# 
	ld sp,hl			;6bee	f9 	. 
l6befh:
	pop hl			;6bef	e1 	. 
	pop hl			;6bf0	e1 	. 
	ld hl,(l8819h+1)		;6bf1	2a 1a 88 	* . . 
	push hl			;6bf4	e5 	. 
	ld hl,(sub_7931h+1)		;6bf5	2a 32 79 	* 2 y 
	push hl			;6bf8	e5 	. 
l6bf9h:
	and a			;6bf9	a7 	. 
	dec a			;6bfa	3d 	= 
	jr z,l6c1ch		;6bfb	28 1f 	( . 
	ex af,af'			;6bfd	08 	. 
	xor a			;6bfe	af 	. 
	ld h,d			;6bff	62 	b 
	ld l,e			;6c00	6b 	k 
	sbc hl,bc		;6c01	ed 42 	. B 
	ccf			;6c03	3f 	? 
	adc a,000h		;6c04	ce 00 	. . 
	pop hl			;6c06	e1 	. 
	sbc hl,de		;6c07	ed 52 	. R 
	jr z,l6c0eh		;6c09	28 03 	( . 
	ccf			;6c0b	3f 	? 
	adc a,000h		;6c0c	ce 00 	. . 
l6c0eh:
	pop hl			;6c0e	e1 	. 
	and a			;6c0f	a7 	. 
	sbc hl,bc		;6c10	ed 42 	. B 
	adc a,000h		;6c12	ce 00 	. . 
	cp 002h		;6c14	fe 02 	. . 
	scf			;6c16	37 	7 
	jr nz,l6c1ch		;6c17	20 03 	  . 
	ex af,af'			;6c19	08 	. 
	jr l6bf9h		;6c1a	18 dd 	. . 
l6c1ch:
	ld sp,00000h		;6c1c	31 00 00 	1 . . 
	ret			;6c1f	c9 	. 
sub_6c20h:
	ld (l6c43h+1),sp		;6c20	ed 73 44 6c 	. s D l 
	ld a,(hl)			;6c24	7e 	~ 
	inc hl			;6c25	23 	# 
	ld sp,hl			;6c26	f9 	. 
	pop hl			;6c27	e1 	. 
	pop hl			;6c28	e1 	. 
	ld hl,(l8819h+1)		;6c29	2a 1a 88 	* . . 
	push hl			;6c2c	e5 	. 
	ld hl,(sub_7931h+1)		;6c2d	2a 32 79 	* 2 y 
	push hl			;6c30	e5 	. 
l6c31h:
	dec a			;6c31	3d 	= 
	jr z,l6c43h		;6c32	28 0f 	( . 
	pop hl			;6c34	e1 	. 
	or a			;6c35	b7 	. 
	sbc hl,de		;6c36	ed 52 	. R 
	pop hl			;6c38	e1 	. 
	jr z,l6c3dh		;6c39	28 02 	( . 
	jr nc,l6c31h		;6c3b	30 f4 	0 . 
l6c3dh:
	and a			;6c3d	a7 	. 
	sbc hl,de		;6c3e	ed 52 	. R 
	ccf			;6c40	3f 	? 
	jr nc,l6c31h		;6c41	30 ee 	0 . 
l6c43h:
	ld sp,l8b91h		;6c43	31 91 8b 	1 . . 
	ret			;6c46	c9 	. 
sub_6c47h:
	call sub_6a0fh		;6c47	cd 0f 6a 	. . j 
sub_6c4ah:
	push hl			;6c4a	e5 	. 
	ld hl,(l5dcah)		;6c4b	2a ca 5d 	* . ] 
	ld a,l			;6c4e	7d 	} 
	and 0e0h		;6c4f	e6 e0 	. . 
	ld l,a			;6c51	6f 	o 
	ld a,(l5dceh)		;6c52	3a ce 5d 	: . ] 
	and 01fh		;6c55	e6 1f 	. . 
	jp z,l5f74h		;6c57	ca 74 5f 	. t _ 
l6c5ah:
	dec a			;6c5a	3d 	= 
	jr z,l6c69h		;6c5b	28 0c 	( . 
	ld d,h			;6c5d	54 	T 
	ld e,l			;6c5e	5d 	] 
	ex af,af'			;6c5f	08 	. 
	call sub_6f94h		;6c60	cd 94 6f 	. . o 
	call sub_7c83h		;6c63	cd 83 7c 	. . | 
	ex af,af'			;6c66	08 	. 
	jr l6c5ah		;6c67	18 f1 	. . 
l6c69h:
	ld (08788h),hl		;6c69	22 88 87 	" . . 
	pop hl			;6c6c	e1 	. 
sub_6c6dh:
	push hl			;6c6d	e5 	. 
	ld b,020h		;6c6e	06 20 	.   
	ld hl,l8aa4h		;6c70	21 a4 8a 	! . . 
l6c73h:
	call sub_85adh		;6c73	cd ad 85 	. . . 
	cp 020h		;6c76	fe 20 	.   
	jr nc,l6c7ch		;6c78	30 02 	0 . 
	ld a,020h		;6c7a	3e 20 	>   
l6c7ch:
	call sub_8769h		;6c7c	cd 69 87 	. i . 
	djnz l6c73h		;6c7f	10 f2 	. . 
	pop hl			;6c81	e1 	. 
	ret			;6c82	c9 	. 
l6c83h:
	ld hl,05800h		;6c83	21 00 58 	! . X 
	ld bc,00003h		;6c86	01 03 00 	. . . 
	push hl			;6c89	e5 	. 
	push bc			;6c8a	c5 	. 
l6c8bh:
	ld (hl),039h		;6c8b	36 39 	6 9 
	inc hl			;6c8d	23 	# 
	djnz l6c8bh		;6c8e	10 fb 	. . 
	dec c			;6c90	0d 	. 
	jr nz,l6c8bh		;6c91	20 f8 	  . 
	call sub_6d84h		;6c93	cd 84 6d 	. . m 
	pop bc			;6c96	c1 	. 
	pop hl			;6c97	e1 	. 
l6c98h:
	ld a,(hl)			;6c98	7e 	~ 
	cp 039h		;6c99	fe 39 	. 9 
	jr nz,l6cb3h		;6c9b	20 16 	  . 
	push hl			;6c9d	e5 	. 
	ld a,h			;6c9e	7c 	| 
	sub 00ah		;6c9f	d6 0a 	. . 
l6ca1h:
	ld h,a			;6ca1	67 	g 
	and 007h		;6ca2	e6 07 	. . 
	jr z,l6cabh		;6ca4	28 05 	( . 
	ld a,h			;6ca6	7c 	| 
	sub 007h		;6ca7	d6 07 	. . 
	jr l6ca1h		;6ca9	18 f6 	. . 
l6cabh:
	ld e,008h		;6cab	1e 08 	. . 
l6cadh:
	ld (hl),a			;6cad	77 	w 
	inc h			;6cae	24 	$ 
	dec e			;6caf	1d 	. 
	jr nz,l6cadh		;6cb0	20 fb 	  . 
	pop hl			;6cb2	e1 	. 
l6cb3h:
	inc hl			;6cb3	23 	# 
	djnz l6c98h		;6cb4	10 e2 	. . 
	dec c			;6cb6	0d 	. 
	jr nz,l6c98h		;6cb7	20 df 	  . 
	ld bc,00000h		;6cb9	01 00 00 	. . . 
	ld ix,l5dc3h		;6cbc	dd 21 c3 5d 	. ! . ] 
	add ix,bc		;6cc0	dd 09 	. . 
	push bc			;6cc2	c5 	. 
	ld a,030h		;6cc3	3e 30 	> 0 
	ld (0877ch),a		;6cc5	32 7c 87 	2 | . 
	call sub_6db1h		;6cc8	cd b1 6d 	. . m 
	ld a,038h		;6ccb	3e 38 	> 8 
	ld (0877ch),a		;6ccd	32 7c 87 	2 | . 
	call sub_8608h		;6cd0	cd 08 86 	. . . 
	pop bc			;6cd3	c1 	. 
	cp 004h		;6cd4	fe 04 	. . 
	ret z			;6cd6	c8 	. 
	ld hl,l6c83h		;6cd7	21 83 6c 	! . l 
	push hl			;6cda	e5 	. 
	ld b,007h		;6cdb	06 07 	. . 
	cp 034h		;6cdd	fe 34 	. 4 
	jr z,l6ce7h		;6cdf	28 06 	( . 
	ld b,0f9h		;6ce1	06 f9 	. . 
	cp 033h		;6ce3	fe 33 	. 3 
	jr nz,l6cf8h		;6ce5	20 11 	  . 
l6ce7h:
	ld a,c			;6ce7	79 	y 
	add a,b			;6ce8	80 	. 
	cp 0f9h		;6ce9	fe f9 	. . 
	jr nz,l6cefh		;6ceb	20 02 	  . 
	ld a,0e7h		;6ced	3e e7 	> . 
l6cefh:
	cp 0eeh		;6cef	fe ee 	. . 
	jr c,l6cf4h		;6cf1	38 01 	8 . 
	xor a			;6cf3	af 	. 
l6cf4h:
	ld (06cbah),a		;6cf4	32 ba 6c 	2 . l 
	ret			;6cf7	c9 	. 
l6cf8h:
	ld h,(ix+001h)		;6cf8	dd 66 01 	. f . 
	ld l,(ix+000h)		;6cfb	dd 6e 00 	. n . 
	ld b,001h		;6cfe	06 01 	. . 
	cp 038h		;6d00	fe 38 	. 8 
	jr z,l6d22h		;6d02	28 1e 	( . 
	cp 036h		;6d04	fe 36 	. 6 
	jr z,l6d0eh		;6d06	28 06 	( . 
	cp 037h		;6d08	fe 37 	. 7 
	jr nz,l6d15h		;6d0a	20 09 	  . 
l6d0ch:
	ld b,017h		;6d0c	06 17 	. . 
l6d0eh:
	call sub_6f94h		;6d0e	cd 94 6f 	. . o 
	djnz l6d0eh		;6d11	10 fb 	. . 
	jr l6d25h		;6d13	18 10 	. . 
l6d15h:
	cp 035h		;6d15	fe 35 	. 5 
	jr nz,l6d2ch		;6d17	20 13 	  . 
	ld b,01fh		;6d19	06 1f 	. . 
l6d1bh:
	call sub_6f88h		;6d1b	cd 88 6f 	. . o 
	djnz l6d1bh		;6d1e	10 fb 	. . 
	jr l6d0ch		;6d20	18 ea 	. . 
l6d22h:
	call sub_6f88h		;6d22	cd 88 6f 	. . o 
l6d25h:
	ld (ix+001h),h		;6d25	dd 74 01 	. t . 
	ld (ix+000h),l		;6d28	dd 75 00 	. u . 
	ret			;6d2b	c9 	. 
l6d2ch:
	cp 061h		;6d2c	fe 61 	. a 
	jr c,l6d49h		;6d2e	38 19 	8 . 
	cp 07bh		;6d30	fe 7b 	. { 
	jr nc,l6d49h		;6d32	30 15 	0 . 
	sub 061h		;6d34	d6 61 	. a 
	ld b,a			;6d36	47 	G 
	ld a,(ix+004h)		;6d37	dd 7e 04 	. ~ . 
	ld c,a			;6d3a	4f 	O 
	and 01fh		;6d3b	e6 1f 	. . 
	xor b			;6d3d	a8 	. 
	xor c			;6d3e	a9 	. 
	bit 7,c		;6d3f	cb 79 	. y 
	jr nz,l6d45h		;6d41	20 02 	  . 
	and 0e1h		;6d43	e6 e1 	. . 
l6d45h:
	ld (ix+004h),a		;6d45	dd 77 04 	. w . 
	ret			;6d48	c9 	. 
l6d49h:
	ld d,(ix+003h)		;6d49	dd 56 03 	. V . 
	ld e,(ix+004h)		;6d4c	dd 5e 04 	. ^ . 
	ld hl,l6d67h		;6d4f	21 67 6d 	! g m 
	ld b,006h		;6d52	06 06 	. . 
l6d54h:
	cp (hl)			;6d54	be 	. 
	inc hl			;6d55	23 	# 
	jr z,l6d5dh		;6d56	28 05 	( . 
	inc hl			;6d58	23 	# 
	inc hl			;6d59	23 	# 
	djnz l6d54h		;6d5a	10 f8 	. . 
	ret			;6d5c	c9 	. 
l6d5dh:
	ld a,(hl)			;6d5d	7e 	~ 
	and e			;6d5e	a3 	. 
	ret z			;6d5f	c8 	. 
	inc hl			;6d60	23 	# 
	ld a,(hl)			;6d61	7e 	~ 
	xor d			;6d62	aa 	. 
	ld (ix+003h),a		;6d63	dd 77 03 	. w . 
	ret			;6d66	c9 	. 
l6d67h:
	ld e,h			;6d67	5c 	\ 
	rst 38h			;6d68	ff 	. 
	add a,b			;6d69	80 	. 
	ld e,(hl)			;6d6a	5e 	^ 
	rst 38h			;6d6b	ff 	. 
	ld b,b			;6d6c	40 	@ 
	ld hl,(020ffh)		;6d6d	2a ff 20 	* .   
	ccf			;6d70	3f 	? 
	rst 38h			;6d71	ff 	. 
	djnz l6db2h		;6d72	10 3e 	. > 
	ld b,b			;6d74	40 	@ 
	ex af,af'			;6d75	08 	. 
	ld a,h			;6d76	7c 	| 
	jr nz,$+6		;6d77	20 04 	  . 
sub_6d79h:
	ld hl,(0603bh)		;6d79	2a 3b 60 	* ; ` 
sub_6d7ch:
	ld ix,l5dd1h		;6d7c	dd 21 d1 5d 	. ! . ] 
	ld b,020h		;6d80	06 20 	.   
	jr l6d8ah		;6d82	18 06 	. . 
sub_6d84h:
	ld ix,l5dc3h		;6d84	dd 21 c3 5d 	. ! . ] 
	ld b,022h		;6d88	06 22 	. " 
l6d8ah:
	ld (06e79h),hl		;6d8a	22 79 6e 	" y n 
l6d8dh:
	push bc			;6d8d	c5 	. 
	call sub_6dabh		;6d8e	cd ab 6d 	. . m 
	ld bc,00007h		;6d91	01 07 00 	. . . 
	add ix,bc		;6d94	dd 09 	. . 
	pop bc			;6d96	c1 	. 
	djnz l6d8dh		;6d97	10 f4 	. . 
	ret			;6d99	c9 	. 
l6d9ah:
	ld a,028h		;6d9a	3e 28 	> ( 
	call sub_8769h		;6d9c	cd 69 87 	. i . 
	pop hl			;6d9f	e1 	. 
	push hl			;6da0	e5 	. 
	call sub_6f5dh		;6da1	cd 5d 6f 	. ] o 
	ld a,029h		;6da4	3e 29 	> ) 
l6da6h:
	call sub_8767h		;6da6	cd 67 87 	. g . 
	jr l6dd9h		;6da9	18 2e 	. . 
sub_6dabh:
	ld a,(ix+004h)		;6dab	dd 7e 04 	. ~ . 
	and 01fh		;6dae	e6 1f 	. . 
	ret z			;6db0	c8 	. 
sub_6db1h:
	xor a			;6db1	af 	. 
l6db2h:
	ld (sub_6ef4h+1),a		;6db2	32 f5 6e 	2 . n 
	call sub_6e8ah		;6db5	cd 8a 6e 	. . n 
	ld l,(ix+005h)		;6db8	dd 6e 05 	. n . 
	ld h,(ix+006h)		;6dbb	dd 66 06 	. f . 
	ld a,(ix+003h)		;6dbe	dd 7e 03 	. ~ . 
	and 003h		;6dc1	e6 03 	. . 
	dec a			;6dc3	3d 	= 
	jr nz,l6dcah		;6dc4	20 04 	  . 
	ld e,(hl)			;6dc6	5e 	^ 
	inc hl			;6dc7	23 	# 
	ld d,(hl)			;6dc8	56 	V 
	ex de,hl			;6dc9	eb 	. 
l6dcah:
	push hl			;6dca	e5 	. 
	ld a,(ix+002h)		;6dcb	dd 7e 02 	. ~ . 
	cp 0d8h		;6dce	fe d8 	. . 
	jr nc,l6d9ah		;6dd0	30 c8 	0 . 
	cp 080h		;6dd2	fe 80 	. . 
	jr nc,l6da6h		;6dd4	30 d0 	0 . 
	call sub_6f6fh		;6dd6	cd 6f 6f 	. o o 
l6dd9h:
	ld a,03ah		;6dd9	3e 3a 	> : 
	call sub_8769h		;6ddb	cd 69 87 	. i . 
	pop de			;6dde	d1 	. 
	ld a,(ix+004h)		;6ddf	dd 7e 04 	. ~ . 
	and 01fh		;6de2	e6 1f 	. . 
	ld hl,(08788h)		;6de4	2a 88 87 	* . . 
l6de7h:
	ld bc,06eech		;6de7	01 ec 6e 	. . n 
	or a			;6dea	b7 	. 
	ret z			;6deb	c8 	. 
	push af			;6dec	f5 	. 
	push hl			;6ded	e5 	. 
	ld a,(de)			;6dee	1a 	. 
	ld l,a			;6def	6f 	o 
	inc de			;6df0	13 	. 
	ld a,(de)			;6df1	1a 	. 
	ld h,a			;6df2	67 	g 
	ld a,(ix+003h)		;6df3	dd 7e 03 	. ~ . 
	bit 3,a		;6df6	cb 5f 	. _ 
	jr z,l6dfbh		;6df8	28 01 	( . 
	inc de			;6dfa	13 	. 
l6dfbh:
	push de			;6dfb	d5 	. 
	ld e,a			;6dfc	5f 	_ 
	and 003h		;6dfd	e6 03 	. . 
	jp z,l6e9ch		;6dff	ca 9c 6e 	. . n 
sub_6e02h:
	cp 003h		;6e02	fe 03 	. . 
	jr nc,l6e43h		;6e04	30 3d 	0 = 
	ld d,004h		;6e06	16 04 	. . 
l6e08h:
	bit 3,(ix+003h)		;6e08	dd cb 03 5e 	. . . ^ 
	push bc			;6e0c	c5 	. 
	jr z,l6e10h		;6e0d	28 01 	( . 
	inc bc			;6e0f	03 	. 
l6e10h:
	push ix		;6e10	dd e5 	. . 
	ld ix,l6f01h		;6e12	dd 21 01 6f 	. ! . o 
	ld a,(bc)			;6e16	0a 	. 
	ld b,000h		;6e17	06 00 	. . 
	ld c,a			;6e19	4f 	O 
	add ix,bc		;6e1a	dd 09 	. . 
	rl e		;6e1c	cb 13 	. . 
	push de			;6e1e	d5 	. 
	push hl			;6e1f	e5 	. 
	call c,sub_6ef4h		;6e20	dc f4 6e 	. . n 
	pop hl			;6e23	e1 	. 
	pop de			;6e24	d1 	. 
	pop ix		;6e25	dd e1 	. . 
	pop bc			;6e27	c1 	. 
	inc bc			;6e28	03 	. 
	inc bc			;6e29	03 	. 
	dec d			;6e2a	15 	. 
	jr nz,l6e08h		;6e2b	20 db 	  . 
	pop de			;6e2d	d1 	. 
	pop hl			;6e2e	e1 	. 
	bit 2,(ix+003h)		;6e2f	dd cb 03 56 	. . . V 
	jr z,l6e3fh		;6e33	28 0a 	( . 
	call sub_6f94h		;6e35	cd 94 6f 	. . o 
	ld (08788h),hl		;6e38	22 88 87 	" . . 
	xor a			;6e3b	af 	. 
	ld (sub_6ef4h+1),a		;6e3c	32 f5 6e 	2 . n 
l6e3fh:
	pop af			;6e3f	f1 	. 
	dec a			;6e40	3d 	= 
l6e41h:
	jr l6de7h		;6e41	18 a4 	. . 
l6e43h:
	pop de			;6e43	d1 	. 
	pop hl			;6e44	e1 	. 
	pop af			;6e45	f1 	. 
l6e46h:
	call sub_6e8ah		;6e46	cd 8a 6e 	. . n 
	rlca			;6e49	07 	. 
	rlca			;6e4a	07 	. 
	rlca			;6e4b	07 	. 
	ld l,a			;6e4c	6f 	o 
	ld h,000h		;6e4d	26 00 	& . 
	add hl,hl			;6e4f	29 	) 
	add hl,hl			;6e50	29 	) 
l6e51h:
	ld a,(ix+002h)		;6e51	dd 7e 02 	. ~ . 
	cp 0c4h		;6e54	fe c4 	. . 
	jr z,l6e6fh		;6e56	28 17 	( . 
	cp 0a3h		;6e58	fe a3 	. . 
	jr z,l6e65h		;6e5a	28 09 	( . 
	call sub_8767h		;6e5c	cd 67 87 	. g . 
	dec hl			;6e5f	2b 	+ 
	ld a,h			;6e60	7c 	| 
sub_6e61h:
	or l			;6e61	b5 	. 
	jr nz,l6e51h		;6e62	20 ed 	  . 
	ret			;6e64	c9 	. 
l6e65h:
	ld a,000h		;6e65	3e 00 	> . 
	add a,003h		;6e67	c6 03 	. . 
sub_6e69h:
	ld de,l8c76h		;6e69	11 76 8c 	. v . 
	jp l6f72h		;6e6c	c3 72 6f 	. r o 
l6e6fh:
	ld a,(ix+004h)		;6e6f	dd 7e 04 	. ~ . 
	and 01fh		;6e72	e6 1f 	. . 
	ld b,a			;6e74	47 	G 
	call sub_6a19h		;6e75	cd 19 6a 	. . j 
	ld hl,00000h		;6e78	21 00 00 	! . . 
	push ix		;6e7b	dd e5 	. . 
l6e7dh:
	push bc			;6e7d	c5 	. 
	call sub_6a0ah		;6e7e	cd 0a 6a 	. . j 
	call sub_6c6dh		;6e81	cd 6d 6c 	. m l 
	pop bc			;6e84	c1 	. 
	djnz l6e7dh		;6e85	10 f6 	. . 
	pop ix		;6e87	dd e1 	. . 
	ret			;6e89	c9 	. 
sub_6e8ah:
	ld l,(ix+000h)		;6e8a	dd 6e 00 	. n . 
	ld h,(ix+001h)		;6e8d	dd 66 01 	. f . 
	ld (08788h),hl		;6e90	22 88 87 	" . . 
	ret			;6e93	c9 	. 
l6e94h:
	ld (hl),e			;6e94	73 	s 
	ld a,d			;6e95	7a 	z 
	dec l			;6e96	2d 	- 
	ld l,b			;6e97	68 	h 
	dec l			;6e98	2d 	- 
	ld (hl),b			;6e99	70 	p 
	ld l,(hl)			;6e9a	6e 	n 
	ex (sp),hl			;6e9b	e3 	. 
l6e9ch:
	pop af			;6e9c	f1 	. 
	pop af			;6e9d	f1 	. 
	ld a,l			;6e9e	7d 	} 
	ex af,af'			;6e9f	08 	. 
	ld c,l			;6ea0	4d 	M 
	ld b,004h		;6ea1	06 04 	. . 
	bit 5,e		;6ea3	cb 6b 	. k 
	call sub_6e8ah		;6ea5	cd 8a 6e 	. . n 
	push hl			;6ea8	e5 	. 
	ld hl,l6ee0h		;6ea9	21 e0 6e 	! . n 
	jr z,l6ec4h		;6eac	28 16 	( . 
	ld de,l6e94h		;6eae	11 94 6e 	. . n 
	call sub_6f75h		;6eb1	cd 75 6f 	. u o 
	pop hl			;6eb4	e1 	. 
	call sub_6f94h		;6eb5	cd 94 6f 	. . o 
	ld (08788h),hl		;6eb8	22 88 87 	" . . 
	ex af,af'			;6ebb	08 	. 
	call sub_6f36h		;6ebc	cd 36 6f 	. 6 o 
	pop hl			;6ebf	e1 	. 
	ret			;6ec0	c9 	. 
l6ec1h:
	call sub_8765h		;6ec1	cd 65 87 	. e . 
l6ec4h:
	ld a,(hl)			;6ec4	7e 	~ 
	inc hl			;6ec5	23 	# 
	and c			;6ec6	a1 	. 
	jr nz,l6ecdh		;6ec7	20 04 	  . 
	inc hl			;6ec9	23 	# 
	ld a,(hl)			;6eca	7e 	~ 
	jr l6ecfh		;6ecb	18 02 	. . 
l6ecdh:
	ld a,(hl)			;6ecd	7e 	~ 
	inc hl			;6ece	23 	# 
l6ecfh:
	inc hl			;6ecf	23 	# 
	push af			;6ed0	f5 	. 
	rlca			;6ed1	07 	. 
	call c,sub_8765h		;6ed2	dc 65 87 	. e . 
	pop af			;6ed5	f1 	. 
	and 07fh		;6ed6	e6 7f 	.  
	call sub_6f6fh		;6ed8	cd 6f 6f 	. o o 
	djnz l6ec1h		;6edb	10 e4 	. . 
	pop de			;6edd	d1 	. 
	pop hl			;6ede	e1 	. 
	ret			;6edf	c9 	. 
l6ee0h:
	ld b,b			;6ee0	40 	@ 
	sub h			;6ee1	94 	. 
	jr nz,l6ee5h		;6ee2	20 01 	  . 
	adc a,e			;6ee4	8b 	. 
l6ee5h:
	rra			;6ee5	1f 	. 
	inc b			;6ee6	04 	. 
	ld hl,l8022h		;6ee7	21 22 80 	! " . 
	ld de,00012h		;6eea	11 12 00 	. . . 
	ex af,af'			;6eed	08 	. 
	djnz $+32		;6eee	10 1e 	. . 
	inc (hl)			;6ef0	34 	4 
	jr nc,l6f3ah		;6ef1	30 47 	0 G 
	ld b,e			;6ef3	43 	C 
sub_6ef4h:
	ld a,000h		;6ef4	3e 00 	> . 
	or a			;6ef6	b7 	. 
	call nz,sub_8765h		;6ef7	c4 65 87 	. e . 
	ld a,001h		;6efa	3e 01 	> . 
	ld (sub_6ef4h+1),a		;6efc	32 f5 6e 	2 . n 
	jp (ix)		;6eff	dd e9 	. . 
l6f01h:
	call sub_6f66h		;6f01	cd 66 6f 	. f o 
	call sub_8932h		;6f04	cd 32 89 	. 2 . 
	jr l6f25h		;6f07	18 1c 	. . 
	call sub_6f68h		;6f09	cd 68 6f 	. h o 
	call sub_8926h		;6f0c	cd 26 89 	. & . 
	jr l6f25h		;6f0f	18 14 	. . 
	call sub_6f66h		;6f11	cd 66 6f 	. f o 
	ld (ix+000h),023h		;6f14	dd 36 00 23 	. 6 . # 
	inc ix		;6f18	dd 23 	. # 
	call sub_891eh		;6f1a	cd 1e 89 	. . . 
	jr l6f25h		;6f1d	18 06 	. . 
	call sub_6f68h		;6f1f	cd 68 6f 	. h o 
	call sub_890dh		;6f22	cd 0d 89 	. . . 
l6f25h:
	ld hl,l8ac7h		;6f25	21 c7 8a 	! . . 
l6f28h:
	ld a,(hl)			;6f28	7e 	~ 
	or a			;6f29	b7 	. 
	ret z			;6f2a	c8 	. 
	call sub_8769h		;6f2b	cd 69 87 	. i . 
	inc hl			;6f2e	23 	# 
	jr l6f28h		;6f2f	18 f7 	. . 
	ld a,h			;6f31	7c 	| 
	call sub_6f36h		;6f32	cd 36 6f 	. 6 o 
	ld a,l			;6f35	7d 	} 
sub_6f36h:
	ld c,a			;6f36	4f 	O 
	ld b,008h		;6f37	06 08 	. . 
l6f39h:
	xor a			;6f39	af 	. 
l6f3ah:
	rl c		;6f3a	cb 11 	. . 
	adc a,030h		;6f3c	ce 30 	. 0 
	call sub_8769h		;6f3e	cd 69 87 	. i . 
	djnz l6f39h		;6f41	10 f6 	. . 
	ret			;6f43	c9 	. 
	ld a,h			;6f44	7c 	| 
	call sub_6f4eh		;6f45	cd 4e 6f 	. N o 
	xor a			;6f48	af 	. 
	ld h,l			;6f49	65 	e 
	ld (sub_6ef4h+1),a		;6f4a	32 f5 6e 	2 . n 
	ld a,h			;6f4d	7c 	| 
sub_6f4eh:
	ld h,a			;6f4e	67 	g 
	and 07fh		;6f4f	e6 7f 	.  
	cp 020h		;6f51	fe 20 	.   
sub_6f53h:
	ld a,h			;6f53	7c 	| 
	jr nc,l6f5ah		;6f54	30 04 	0 . 
	and 080h		;6f56	e6 80 	. . 
	or 02eh		;6f58	f6 2e 	. . 
l6f5ah:
	jp sub_8769h		;6f5a	c3 69 87 	. i . 
sub_6f5dh:
	push ix		;6f5d	dd e5 	. . 
	call sub_8902h		;6f5f	cd 02 89 	. . . 
	pop ix		;6f62	dd e1 	. . 
	jr l6f25h		;6f64	18 bf 	. . 
sub_6f66h:
	ld h,000h		;6f66	26 00 	& . 
sub_6f68h:
	ld ix,l8ac7h		;6f68	dd 21 c7 8a 	. ! . . 
	ld c,000h		;6f6c	0e 00 	. . 
	ret			;6f6e	c9 	. 
sub_6f6fh:
	ld de,l8db4h		;6f6f	11 b4 8d 	. . . 
l6f72h:
	call sub_82c9h		;6f72	cd c9 82 	. . . 
sub_6f75h:
	ld a,(de)			;6f75	1a 	. 
	res 7,a		;6f76	cb bf 	. . 
l6f78h:
	call sub_872eh		;6f78	cd 2e 87 	. . . 
	jr nz,l6f7fh		;6f7b	20 02 	  . 
	sub 020h		;6f7d	d6 20 	.   
l6f7fh:
	call sub_8767h		;6f7f	cd 67 87 	. g . 
	ld a,(de)			;6f82	1a 	. 
	inc de			;6f83	13 	. 
	rla			;6f84	17 	. 
	jr nc,sub_6f75h		;6f85	30 ee 	0 . 
	ret			;6f87	c9 	. 
sub_6f88h:
	inc l			;6f88	2c 	, 
	ret nz			;6f89	c0 	. 
l6f8ah:
	ld a,h			;6f8a	7c 	| 
	add a,008h		;6f8b	c6 08 	. . 
	cp 058h		;6f8d	fe 58 	. X 
	ld h,a			;6f8f	67 	g 
	ret nz			;6f90	c0 	. 
	ld h,040h		;6f91	26 40 	& @ 
	ret			;6f93	c9 	. 
sub_6f94h:
	ld a,l			;6f94	7d 	} 
	add a,020h		;6f95	c6 20 	.   
	ld l,a			;6f97	6f 	o 
	ret nc			;6f98	d0 	. 
	jr l6f8ah		;6f99	18 ef 	. . 
l6f9bh:
	nop			;6f9b	00 	. 
	nop			;6f9c	00 	. 
l6f9dh:
	nop			;6f9d	00 	. 
	nop			;6f9e	00 	. 
	nop			;6f9f	00 	. 
	nop			;6fa0	00 	. 
	nop			;6fa1	00 	. 
	nop			;6fa2	00 	. 
	nop			;6fa3	00 	. 
	nop			;6fa4	00 	. 
l6fa5h:
	ld a,(0005ch)		;6fa5	3a 5c 00 	: \ . 
	nop			;6fa8	00 	. 
l6fa9h:
	rst 38h			;6fa9	ff 	. 
	xor a			;6faa	af 	. 
l6fabh:
	ld bc,00001h		;6fab	01 01 00 	. . . 
l6faeh:
	nop			;6fae	00 	. 
l6fafh:
	nop			;6faf	00 	. 
l6fb0h:
	nop			;6fb0	00 	. 
l6fb1h:
	nop			;6fb1	00 	. 
	nop			;6fb2	00 	. 
l6fb3h:
	nop			;6fb3	00 	. 
	nop			;6fb4	00 	. 
	nop			;6fb5	00 	. 
	nop			;6fb6	00 	. 
	nop			;6fb7	00 	. 
	nop			;6fb8	00 	. 
l6fb9h:
	dec de			;6fb9	1b 	. 
	rst 38h			;6fba	ff 	. 
	ex (sp),hl			;6fbb	e3 	. 
	dec c			;6fbc	0d 	. 
	rst 38h			;6fbd	ff 	. 
	ex (sp),hl			;6fbe	e3 	. 
	dec e			;6fbf	1d 	. 
	rst 38h			;6fc0	ff 	. 
	ex (sp),hl			;6fc1	e3 	. 
	dec l			;6fc2	2d 	- 
	rst 38h			;6fc3	ff 	. 
	ret			;6fc4	c9 	. 
	dec c			;6fc5	0d 	. 
	rst 8			;6fc6	cf 	. 
	pop bc			;6fc7	c1 	. 
	dec c			;6fc8	0d 	. 
l6fc9h:
	rst 0			;6fc9	c7 	. 
	ret nz			;6fca	c0 	. 
	dec c			;6fcb	0d 	. 
	rst 30h			;6fcc	f7 	. 
	and b			;6fcd	a0 	. 
	ld b,d			;6fce	42 	B 
	rst 0			;6fcf	c7 	. 
l6fd0h:
	add a,(hl)			;6fd0	86 	. 
	inc d			;6fd1	14 	. 
	rst 0			;6fd2	c7 	. 
	add a,(hl)			;6fd3	86 	. 
	inc hl			;6fd4	23 	# 
	rst 0			;6fd5	c7 	. 
	add a,(hl)			;6fd6	86 	. 
	ld (bc),a			;6fd7	02 	. 
	rst 8			;6fd8	cf 	. 
	ld c,e			;6fd9	4b 	K 
	ld c,a			;6fda	4f 	O 
	rst 0			;6fdb	c7 	. 
	ld b,(hl)			;6fdc	46 	F 
	inc d			;6fdd	14 	. 
	rst 0			;6fde	c7 	. 
	ld b,(hl)			;6fdf	46 	F 
	inc hl			;6fe0	23 	# 
	rst 0			;6fe1	c7 	. 
	ld b,(hl)			;6fe2	46 	F 
	ld (bc),a			;6fe3	02 	. 
	rst 30h			;6fe4	f7 	. 
	ld b,l			;6fe5	45 	E 
	ld b,l			;6fe6	45 	E 
	rst 38h			;6fe7	ff 	. 
	ld a,(0fe07h)		;6fe8	3a 07 fe 	: . . 
	inc (hl)			;6feb	34 	4 
	inc d			;6fec	14 	. 
	cp 034h		;6fed	fe 34 	. 4 
	inc hl			;6fef	23 	# 
	cp 034h		;6ff0	fe 34 	. 4 
	ld (bc),a			;6ff2	02 	. 
	rst 38h			;6ff3	ff 	. 
	ld hl,(0ff0fh)		;6ff4	2a 0f ff 	* . . 
	ld hl,(0ff1fh)		;6ff7	2a 1f ff 	* . . 
	ld hl,(0ff2fh)		;6ffa	2a 2f ff 	* / . 
	ld a,(de)			;6ffd	1a 	. 
	ld bc,00affh		;6ffe	01 ff 0a 	. . . 
	nop			;7001	00 	. 
	add a,a			;7002	87 	. 
	ld b,094h		;7003	06 94 	. . 
	add a,a			;7005	87 	. 
	ld b,0a3h		;7006	06 a3 	. . 
	add a,a			;7008	87 	. 
	ld b,082h		;7009	06 82 	. . 
l700bh:
	ld e,0ffh		;700b	1e ff 	. . 
	ex (sp),hl			;700d	e3 	. 
	dec c			;700e	0d 	. 
	rst 38h			;700f	ff 	. 
	ex (sp),hl			;7010	e3 	. 
	dec e			;7011	1d 	. 
	rst 38h			;7012	ff 	. 
	ex (sp),hl			;7013	e3 	. 
	dec l			;7014	2d 	- 
	rst 38h			;7015	ff 	. 
	call 0c70eh		;7016	cd 0e c7 	. . . 
	rst 0			;7019	c7 	. 
	ld c,0cfh		;701a	0e cf 	. . 
	push bc			;701c	c5 	. 
	ld c,0c7h		;701d	0e c7 	. . 
	call nz,0f70eh		;701f	c4 0e f7 	. . . 
	and b			;7022	a0 	. 
	ld b,c			;7023	41 	A 
	add a,a			;7024	87 	. 
	add a,(hl)			;7025	86 	. 
	sub h			;7026	94 	. 
	add a,a			;7027	87 	. 
	add a,(hl)			;7028	86 	. 
	and e			;7029	a3 	. 
	add a,a			;702a	87 	. 
	add a,(hl)			;702b	86 	. 
	add a,d			;702c	82 	. 
	ret m			;702d	f8 	. 
	ld (hl),b			;702e	70 	p 
	inc d			;702f	14 	. 
	ret m			;7030	f8 	. 
	ld (hl),b			;7031	70 	p 
	inc hl			;7032	23 	# 
	ret m			;7033	f8 	. 
	ld (hl),b			;7034	70 	p 
	ld (bc),a			;7035	02 	. 
	rst 8			;7036	cf 	. 
	ld b,e			;7037	43 	C 
	ld c,a			;7038	4f 	O 
	rst 38h			;7039	ff 	. 
	ld (hl),014h		;703a	36 14 	6 . 
	rst 38h			;703c	ff 	. 
	ld (hl),023h		;703d	36 23 	6 # 
	rst 38h			;703f	ff 	. 
	ld (hl),002h		;7040	36 02 	6 . 
	cp 034h		;7042	fe 34 	. 4 
	inc d			;7044	14 	. 
	cp 034h		;7045	fe 34 	. 4 
	inc hl			;7047	23 	# 
	cp 034h		;7048	fe 34 	. 4 
	ld (bc),a			;704a	02 	. 
	rst 38h			;704b	ff 	. 
	ld (0ff07h),a		;704c	32 07 ff 	2 . . 
	ld (0ff0fh),hl		;704f	22 0f ff 	" . . 
	ld (0ff1fh),hl		;7052	22 1f ff 	" . . 
	ld (0ff2fh),hl		;7055	22 2f ff 	" / . 
	ld (de),a			;7058	12 	. 
	ld bc,006c7h		;7059	01 c7 06 	. . . 
	sub h			;705c	94 	. 
	rst 0			;705d	c7 	. 
	ld b,0a3h		;705e	06 a3 	. . 
	rst 0			;7060	c7 	. 
	ld b,082h		;7061	06 82 	. . 
sub_7063h:
	rst 38h			;7063	ff 	. 
	ld (bc),a			;7064	02 	. 
	nop			;7065	00 	. 
l7066h:
	ld c,0ffh		;7066	0e ff 	. . 
	jp (hl)			;7068	e9 	. 
	ld d,0ffh		;7069	16 ff 	. . 
	jp (hl)			;706b	e9 	. 
	dec h			;706c	25 	% 
	rst 38h			;706d	ff 	. 
	jp (hl)			;706e	e9 	. 
	inc b			;706f	04 	. 
	rst 38h			;7070	ff 	. 
	call 0ff01h		;7071	cd 01 ff 	. . . 
	ret			;7074	c9 	. 
	ld (bc),a			;7075	02 	. 
	rst 0			;7076	c7 	. 
	rst 0			;7077	c7 	. 
	inc bc			;7078	03 	. 
	rst 0			;7079	c7 	. 
	call nz,0ff01h		;707a	c4 01 ff 	. . . 
	jp 0c701h		;707d	c3 01 c7 	. . . 
	jp nz,0c701h		;7080	c2 01 c7 	. . . 
	ret nz			;7083	c0 	. 
	ld (bc),a			;7084	02 	. 
	rst 30h			;7085	f7 	. 
	ld b,l			;7086	45 	E 
	ld b,a			;7087	47 	G 
	rst 20h			;7088	e7 	. 
	jr nz,l708bh		;7089	20 00 	  . 
l708bh:
	rst 38h			;708b	ff 	. 
	jr l708eh		;708c	18 00 	. . 
l708eh:
	rst 38h			;708e	ff 	. 
	djnz l7091h		;708f	10 00 	. . 
l7091h:
	ld a,(de)			;7091	1a 	. 
	rra			;7092	1f 	. 
	inc hl			;7093	23 	# 
	ld h,02bh		;7094	26 2b 	& + 
	inc l			;7096	2c 	, 
	dec a			;7097	3d 	= 
	ccf			;7098	3f 	? 
	ld b,c			;7099	41 	A 
	ld b,e			;709a	43 	C 
	ld b,l			;709b	45 	E 
	ld b,a			;709c	47 	G 
	ld c,d			;709d	4a 	J 
	ld d,e			;709e	53 	S 
	ld d,l			;709f	55 	U 
	ld e,l			;70a0	5d 	] 
	ld h,c			;70a1	61 	a 
	ld h,(hl)			;70a2	66 	f 
	ld l,l			;70a3	6d 	m 
	ld (hl),e			;70a4	73 	s 
	halt			;70a5	76 	v 
	ld a,c			;70a6	79 	y 
	add a,b			;70a7	80 	. 
	add a,e			;70a8	83 	. 
	add a,h			;70a9	84 	. 
	adc a,c			;70aa	89 	. 
	ld c,h			;70ab	4c 	L 
	ld h,l			;70ac	65 	e 
	ld l,(hl)			;70ad	6e 	n 
	ld h,a			;70ae	67 	g 
	ld (hl),h			;70af	74 	t 
	ret pe			;70b0	e8 	. 
	ld b,(hl)			;70b1	46 	F 
	ld l,c			;70b2	69 	i 
	ld (hl),d			;70b3	72 	r 
	ld (hl),e			;70b4	73 	s 
	call p,0614ch		;70b5	f4 4c 61 	. L a 
	ld (hl),e			;70b8	73 	s 
	call p,l654ch+1		;70b9	f4 4d 65 	. M e 
	ld l,l			;70bc	6d 	m 
	ld l,a			;70bd	6f 	o 
	ld (hl),d			;70be	72 	r 
	ld sp,hl			;70bf	f9 	. 
	ld l,h			;70c0	6c 	l 
	call po,05520h		;70c1	e4 20 55 	.   U 
	ld c,(hl)			;70c4	4e 	N 
	ld c,c			;70c5	49 	I 
	ld d,(hl)			;70c6	56 	V 
	ld b,l			;70c7	45 	E 
	ld d,d			;70c8	52 	R 
	ld d,e			;70c9	53 	S 
	ld d,l			;70ca	55 	U 
	ld c,l			;70cb	4d 	M 
	jr nz,l7111h		;70cc	20 43 	  C 
	ld l,a			;70ce	6f 	o 
	ld l,(hl)			;70cf	6e 	n 
	ld (hl),h			;70d0	74 	t 
	ld (hl),d			;70d1	72 	r 
	ld l,a			;70d2	6f 	o 
	call pe,04e4fh		;70d3	ec 4f 4e 	. O N 
	and b			;70d6	a0 	. 
	ld c,a			;70d7	4f 	O 
	ld b,(hl)			;70d8	46 	F 
	add a,04eh		;70d9	c6 4e 	. N 
	ld c,a			;70db	4f 	O 
	adc a,044h		;70dc	ce 44 	. D 
	ld b,l			;70de	45 	E 
	add a,041h		;70df	c6 41 	. A 
	ld c,h			;70e1	4c 	L 
	call z,l6143h		;70e2	cc 43 61 	. C a 
	ld l,h			;70e5	6c 	l 
	call pe,06552h		;70e6	ec 52 65 	. R e 
	ld h,c			;70e9	61 	a 
	ld h,h			;70ea	64 	d 
	cpl			;70eb	2f 	/ 
	ld d,a			;70ec	57 	W 
	ld (hl),d			;70ed	72 	r 
	ld l,c			;70ee	69 	i 
	ld (hl),h			;70ef	74 	t 
	push hl			;70f0	e5 	. 
	ld d,d			;70f1	52 	R 
	ld (hl),l			;70f2	75 	u 
	xor 049h		;70f3	ee 49 	. I 
	ld l,(hl)			;70f5	6e 	n 
	ld (hl),h			;70f6	74 	t 
	ld h,l			;70f7	65 	e 
	ld (hl),d			;70f8	72 	r 
	ld (hl),d			;70f9	72 	r 
	ld (hl),l			;70fa	75 	u 
	ld (hl),b			;70fb	70 	p 
	call p,05245h		;70fc	f4 45 52 	. E R 
	ld d,d			;70ff	52 	R 
	ld c,a			;7100	4f 	O 
	jp nc,sub_6f4eh		;7101	d2 4e 6f 	. N o 
	jr nz,$+116		;7104	20 72 	  r 
	ld (hl),l			;7106	75 	u 
	xor 04eh		;7107	ee 4e 	. N 
	ld l,a			;7109	6f 	o 
	jr nz,$+121		;710a	20 77 	  w 
	ld (hl),d			;710c	72 	r 
	ld l,c			;710d	69 	i 
	ld (hl),h			;710e	74 	t 
	push hl			;710f	e5 	. 
	ld c,(hl)			;7110	4e 	N 
l7111h:
	ld l,a			;7111	6f 	o 
	jr nz,l7186h		;7112	20 72 	  r 
	ld h,l			;7114	65 	e 
	ld h,c			;7115	61 	a 
	call po,sub_6544h		;7116	e4 44 65 	. D e 
	ld h,(hl)			;7119	66 	f 
	jp po,sub_6544h		;711a	e2 44 65 	. D e 
	ld h,(hl)			;711d	66 	f 
l711eh:
	rst 30h			;711e	f7 	. 
	ld (hl),a			;711f	77 	w 
	ld l,c			;7120	69 	i 
	ld l,(hl)			;7121	6e 	n 
	ld h,h			;7122	64 	d 
	ld l,a			;7123	6f 	o 
	ld (hl),a			;7124	77 	w 
	ld (hl),e			;7125	73 	s 
	cp d			;7126	ba 	. 
	ld d,a			;7127	57 	W 
	ld l,c			;7128	69 	i 
	ld (hl),h			;7129	74 	t 
	ret pe			;712a	e8 	. 
	ld d,h			;712b	54 	T 
	rst 28h			;712c	ef 	. 
	ld c,h			;712d	4c 	L 
	ld h,l			;712e	65 	e 
	ld h,c			;712f	61 	a 
	ld h,h			;7130	64 	d 
	ld h,l			;7131	65 	e 
	jp p,02e31h		;7132	f2 31 2e 	. 1 . 
	jr nz,l7199h		;7135	20 62 	  b 
	ld a,c			;7137	79 	y 
	ld (hl),h			;7138	74 	t 
	ld h,l			;7139	65 	e 
	cp d			;713a	ba 	. 
	nop			;713b	00 	. 
	nop			;713c	00 	. 
	nop			;713d	00 	. 
	nop			;713e	00 	. 
	nop			;713f	00 	. 
	nop			;7140	00 	. 
	nop			;7141	00 	. 
	nop			;7142	00 	. 
	nop			;7143	00 	. 
	nop			;7144	00 	. 
	nop			;7145	00 	. 
	nop			;7146	00 	. 
	nop			;7147	00 	. 
	jp l7cc9h		;7148	c3 c9 7c 	. . | 
	ld e,a			;714b	5f 	_ 
	ld a,b			;714c	78 	x 
	ld b,(hl)			;714d	46 	F 
	ld a,h			;714e	7c 	| 
	ccf			;714f	3f 	? 
	adc a,d			;7150	8a 	. 
	ld b,e			;7151	43 	C 
	ld (hl),e			;7152	73 	s 
	add a,(hl)			;7153	86 	. 
	ld (hl),c			;7154	71 	q 
	and c			;7155	a1 	. 
	ld (hl),d			;7156	72 	r 
	ld a,e			;7157	7b 	{ 
	ld (hl),a			;7158	77 	w 
	add hl,sp			;7159	39 	9 
	ld a,h			;715a	7c 	| 
	ld a,e			;715b	7b 	{ 
	ld (hl),a			;715c	77 	w 
	ld a,e			;715d	7b 	{ 
	ld (hl),a			;715e	77 	w 
	ld a,a			;715f	7f 	 
	ld (hl),c			;7160	71 	q 
	ld d,077h		;7161	16 77 	. w 
	rst 0			;7163	c7 	. 
	ld a,e			;7164	7b 	{ 
sub_7165h:
	or a			;7165	b7 	. 
	ld de,011b7h		;7166	11 b7 11 	. . . 
	add hl,de			;7169	19 	. 
	ld (hl),e			;716a	73 	s 
	push de			;716b	d5 	. 
	ld a,e			;716c	7b 	{ 
	or b			;716d	b0 	. 
	ld a,h			;716e	7c 	| 
	rlca			;716f	07 	. 
	halt			;7170	76 	v 
	xor b			;7171	a8 	. 
	ld (hl),h			;7172	74 	t 
	sub (hl)			;7173	96 	. 
	ld (hl),c			;7174	71 	q 
	rst 18h			;7175	df 	. 
	halt			;7176	76 	v 
	ld a,07ch		;7177	3e 7c 	> | 
	sub 074h		;7179	d6 74 	. t 
	sub 074h		;717b	d6 74 	. t 
	ld sp,02172h		;717d	31 72 21 	1 r ! 
	jr z,l711eh		;7180	28 9c 	( . 
l7182h:
	ld (sub_826ch+1),hl		;7182	22 6d 82 	" m . 
	ret			;7185	c9 	. 
l7186h:
	call sub_718eh		;7186	cd 8e 71 	. . q 
	call sub_8235h		;7189	cd 35 82 	. 5 . 
	jr l7182h		;718c	18 f4 	. . 
sub_718eh:
	ld hl,(087d7h)		;718e	2a d7 87 	* . . 
	ld de,0fff4h		;7191	11 f4 ff 	. . . 
	add hl,de			;7194	19 	. 
	ret			;7195	c9 	. 
	call l719dh		;7196	cd 9d 71 	. . q 
l7199h:
	ld (l7945h+1),hl		;7199	22 46 79 	" F y 
	ret			;719c	c9 	. 
l719dh:
	ld hl,l8affh+1		;719d	21 00 8b 	! . . 
sub_71a0h:
	ld de,l8ad1h		;71a0	11 d1 8a 	. . . 
	push de			;71a3	d5 	. 
	ld c,01eh		;71a4	0e 1e 	. . 
	call sub_8577h		;71a6	cd 77 85 	. w . 
	pop de			;71a9	d1 	. 
	ld hl,00000h		;71aa	21 00 00 	! . . 
	ld a,02bh		;71ad	3e 2b 	> + 
	ld ix,l8aa5h		;71af	dd 21 a5 8a 	. ! . . 
l71b3h:
	push hl			;71b3	e5 	. 
	push af			;71b4	f5 	. 
	call sub_8492h		;71b5	cd 92 84 	. . . 
	jp c,l8089h		;71b8	da 89 80 	. . . 
	cp 02bh		;71bb	fe 2b 	. + 
	jr z,l71c6h		;71bd	28 07 	( . 
	ld (07209h),a		;71bf	32 09 72 	2 . r 
	cp 02dh		;71c2	fe 2d 	. - 
	jr nz,l71c9h		;71c4	20 03 	  . 
l71c6h:
	call sub_8492h		;71c6	cd 92 84 	. . . 
l71c9h:
	cp 024h		;71c9	fe 24 	. $ 
	ld hl,(l7953h+1)		;71cb	2a 54 79 	* T y 
	jr z,l71fdh		;71ce	28 2d 	( - 
	call sub_872eh		;71d0	cd 2e 87 	. . . 
	jr nz,l7202h		;71d3	20 2d 	  - 
	dec de			;71d5	1b 	. 
	push de			;71d6	d5 	. 
	push ix		;71d7	dd e5 	. . 
	ex de,hl			;71d9	eb 	. 
	call sub_87aah		;71da	cd aa 87 	. . . 
	ld a,009h		;71dd	3e 09 	> . 
	jp c,l809ah		;71df	da 9a 80 	. . . 
	pop ix		;71e2	dd e1 	. . 
	ex de,hl			;71e4	eb 	. 
	call sub_8116h		;71e5	cd 16 81 	. . . 
	ld a,(hl)			;71e8	7e 	~ 
	and 0c0h		;71e9	e6 c0 	. . 
	ld a,009h		;71eb	3e 09 	> . 
	jp z,l809ah		;71ed	ca 9a 80 	. . . 
	dec de			;71f0	1b 	. 
	ex de,hl			;71f1	eb 	. 
	ld d,(hl)			;71f2	56 	V 
	dec hl			;71f3	2b 	+ 
	ld e,(hl)			;71f4	5e 	^ 
	pop bc			;71f5	c1 	. 
	ld hl,(l8ac7h)		;71f6	2a c7 8a 	* . . 
	ld h,000h		;71f9	26 00 	& . 
	add hl,bc			;71fb	09 	. 
	ex de,hl			;71fc	eb 	. 
l71fdh:
	call sub_8492h		;71fd	cd 92 84 	. . . 
	jr l7205h		;7200	18 03 	. . 
l7202h:
	call sub_8419h		;7202	cd 19 84 	. . . 
l7205h:
	push af			;7205	f5 	. 
	push de			;7206	d5 	. 
	ex de,hl			;7207	eb 	. 
	ld a,032h		;7208	3e 32 	> 2 
	call sub_7b50h		;720a	cd 50 7b 	. P { 
	pop hl			;720d	e1 	. 
	pop bc			;720e	c1 	. 
	pop af			;720f	f1 	. 
	ex (sp),hl			;7210	e3 	. 
	push bc			;7211	c5 	. 
	call sub_7b0fh		;7212	cd 0f 7b 	. . { 
	pop af			;7215	f1 	. 
	pop de			;7216	d1 	. 
	ret c			;7217	d8 	. 
	jr l71b3h		;7218	18 99 	. . 
sub_721ah:
	push hl			;721a	e5 	. 
	call sub_898ah		;721b	cd 8a 89 	. . . 
l721eh:
	ld hl,l9c27h+1		;721e	21 28 9c 	! ( . 
	call sub_8a2fh		;7221	cd 2f 8a 	. / . 
	jr c,l722fh		;7224	38 09 	8 . 
	ld d,h			;7226	54 	T 
	ld e,l			;7227	5d 	] 
	ld c,002h		;7228	0e 02 	. . 
	call sub_8a6ch		;722a	cd 6c 8a 	. l . 
	jr l721eh		;722d	18 ef 	. . 
l722fh:
	pop hl			;722f	e1 	. 
	ret			;7230	c9 	. 
	ld b,03ah		;7231	06 3a 	. : 
	call sub_7c2ch		;7233	cd 2c 7c 	. , | 
	ld de,073a9h		;7236	11 a9 73 	. . s 
	call z,sub_7304h		;7239	cc 04 73 	. . s 
	ld ix,(sub_826ch+1)		;723c	dd 2a 6d 82 	. * m . 
	ld (l72ddh+1),ix		;7240	dd 22 de 72 	. " . r 
	call sub_8135h		;7244	cd 35 81 	. 5 . 
	ld hl,l8aa5h		;7247	21 a5 8a 	! . . 
	ld de,l8affh		;724a	11 ff 8a 	. . . 
	ld a,001h		;724d	3e 01 	> . 
	ld (de),a			;724f	12 	. 
	inc de			;7250	13 	. 
	ld c,01fh		;7251	0e 1f 	. . 
l7253h:
	push hl			;7253	e5 	. 
	push de			;7254	d5 	. 
	ex de,hl			;7255	eb 	. 
	call sub_7379h		;7256	cd 79 73 	. y s 
	pop de			;7259	d1 	. 
	jr nc,l7274h		;725a	30 18 	0 . 
	ld hl,073a8h		;725c	21 a8 73 	! . s 
	ld b,(hl)			;725f	46 	F 
l7260h:
	inc hl			;7260	23 	# 
	ld a,(hl)			;7261	7e 	~ 
	call sub_7c9bh		;7262	cd 9b 7c 	. . | 
	djnz l7260h		;7265	10 f9 	. . 
	pop hl			;7267	e1 	. 
	ld a,(l738dh)		;7268	3a 8d 73 	: . s 
	ld b,a			;726b	47 	G 
l726ch:
	call sub_85aeh		;726c	cd ae 85 	. . . 
sub_726fh:
	inc hl			;726f	23 	# 
	djnz l726ch		;7270	10 fa 	. . 
sub_7272h:
	jr l7253h		;7272	18 df 	. . 
l7274h:
	pop hl			;7274	e1 	. 
	call sub_85aeh		;7275	cd ae 85 	. . . 
	inc hl			;7278	23 	# 
	or a			;7279	b7 	. 
	jr z,l7281h		;727a	28 05 	( . 
	call sub_7c9bh		;727c	cd 9b 7c 	. . | 
	jr l7253h		;727f	18 d2 	. . 
l7281h:
	inc a			;7281	3c 	< 
	ld (de),a			;7282	12 	. 
	ld (07e1fh),a		;7283	32 1f 7e 	2 . ~ 
	dec a			;7286	3d 	= 
	inc c			;7287	0c 	. 
l7288h:
	ld (de),a			;7288	12 	. 
	dec c			;7289	0d 	. 
	jr nz,l7288h		;728a	20 fc 	  . 
	ld hl,l7295h		;728c	21 95 72 	! . r 
	ld (07e39h),hl		;728f	22 39 7e 	" 9 ~ 
	jp l7dddh		;7292	c3 dd 7d 	. . } 
l7295h:
	ld hl,l7ccfh		;7295	21 cf 7c 	! . | 
	ld (07e39h),hl		;7298	22 39 7e 	" 9 ~ 
	call sub_72d4h		;729b	cd d4 72 	. . r 
	jp l7e34h		;729e	c3 34 7e 	. 4 ~ 
	ld hl,(sub_826ch+1)		;72a1	2a 6d 82 	* m . 
	ld (l72ddh+1),hl		;72a4	22 de 72 	" . r 
	ld b,053h		;72a7	06 53 	. S 
	call sub_7c2ch		;72a9	cd 2c 7c 	. , | 
	jr nz,l72beh		;72ac	20 10 	  . 
	xor a			;72ae	af 	. 
l72afh:
	ld de,l9c25h+1		;72af	11 26 9c 	. & . 
	ld (l72ddh+1),de		;72b2	ed 53 de 72 	. S . r 
	ld (072eeh),a		;72b6	32 ee 72 	2 . r 
	call sub_7c2fh		;72b9	cd 2f 7c 	. / | 
	jr l72c9h		;72bc	18 0b 	. . 
l72beh:
	ld b,042h		;72be	06 42 	. B 
	call sub_7c33h		;72c0	cd 33 7c 	. 3 | 
	jr nz,l72c9h		;72c3	20 04 	  . 
	ld a,001h		;72c5	3e 01 	> . 
	jr l72afh		;72c7	18 e6 	. . 
l72c9h:
	ld b,03ah		;72c9	06 3a 	. : 
	call sub_7c33h		;72cb	cd 33 7c 	. 3 | 
	ld de,l738eh		;72ce	11 8e 73 	. . s 
	call z,sub_7304h		;72d1	cc 04 73 	. . s 
sub_72d4h:
	call sub_89f2h		;72d4	cd f2 89 	. . . 
	ld hl,l736ch		;72d7	21 6c 73 	! l s 
l72dah:
	ld (072fbh),hl		;72da	22 fb 72 	" . r 
l72ddh:
	ld hl,l9c27h+1		;72dd	21 28 9c 	! ( . 
	call sub_8248h		;72e0	cd 48 82 	. H . 
	ld (l72ddh+1),hl		;72e3	22 de 72 	" . r 
	call sub_8a2fh		;72e6	cd 2f 8a 	. / . 
	ret nc			;72e9	d0 	. 
	push hl			;72ea	e5 	. 
	pop ix		;72eb	dd e1 	. . 
	ld a,000h		;72ed	3e 00 	> . 
	or a			;72ef	b7 	. 
	jr z,l72f7h		;72f0	28 05 	( . 
	call sub_80f5h		;72f2	cd f5 80 	. . . 
	jr c,l7302h		;72f5	38 0b 	8 . 
l72f7h:
	call sub_8135h		;72f7	cd 35 81 	. 5 . 
	call l736ch		;72fa	cd 6c 73 	. l s 
	ld hl,(l72ddh+1)		;72fd	2a de 72 	* . r 
	jr c,l7368h		;7300	38 66 	8 f 
l7302h:
	jr l72ddh		;7302	18 d9 	. . 
sub_7304h:
	ld b,000h		;7304	06 00 	. . 
	push de			;7306	d5 	. 
l7307h:
	call sub_85aeh		;7307	cd ae 85 	. . . 
	inc hl			;730a	23 	# 
	or a			;730b	b7 	. 
	jr z,l7315h		;730c	28 07 	( . 
	or 020h		;730e	f6 20 	.   
	ld (de),a			;7310	12 	. 
	inc de			;7311	13 	. 
	inc b			;7312	04 	. 
	jr l7307h		;7313	18 f2 	. . 
l7315h:
	pop hl			;7315	e1 	. 
	dec hl			;7316	2b 	+ 
	ld (hl),b			;7317	70 	p 
	ret			;7318	c9 	. 
	call sub_7c2ah		;7319	cd 2a 7c 	. * | 
	ld a,000h		;731c	3e 00 	> . 
	jr nz,l7321h		;731e	20 01 	  . 
	inc a			;7320	3c 	< 
l7321h:
	ld (072eeh),a		;7321	32 ee 72 	2 . r 
	ld hl,l9c25h+1		;7324	21 26 9c 	! & . 
	ld (l72ddh+1),hl		;7327	22 de 72 	" . r 
	ld hl,l732fh		;732a	21 2f 73 	! / s 
	jr l72dah		;732d	18 ab 	. . 
l732fh:
	call sub_7bbch		;732f	cd bc 7b 	. . { 
l7332h:
	ld a,003h		;7332	3e 03 	> . 
	call 01601h		;7334	cd 01 16 	. . . 
	ei			;7337	fb 	. 
	ld hl,00010h		;7338	21 10 00 	! . . 
	call sub_82a3h		;733b	cd a3 82 	. . . 
	ld a,00dh		;733e	3e 0d 	> . 
	rst 10h			;7340	d7 	. 
	xor a			;7341	af 	. 
	ret			;7342	c9 	. 
sub_7343h:
	call 080e7h		;7343	cd e7 80 	. . . 
	ld bc,00001h		;7346	01 01 00 	. . . 
l7349h:
	push hl			;7349	e5 	. 
	and a			;734a	a7 	. 
	sbc hl,de		;734b	ed 52 	. R 
	pop hl			;734d	e1 	. 
	jr nc,l7356h		;734e	30 06 	0 . 
	inc bc			;7350	03 	. 
	call sub_8248h		;7351	cd 48 82 	. H . 
	jr l7349h		;7354	18 f3 	. . 
l7356h:
	call 080e7h		;7356	cd e7 80 	. . . 
	call sub_721ah		;7359	cd 1a 72 	. . r 
	call sub_8a2fh		;735c	cd 2f 8a 	. / . 
	call z,sub_8235h		;735f	cc 35 82 	. 5 . 
	ld (080e8h),hl		;7362	22 e8 80 	" . . 
	ld (080ebh),hl		;7365	22 eb 80 	" . . 
l7368h:
	ld (sub_826ch+1),hl		;7368	22 6d 82 	" m . 
	ret			;736b	c9 	. 
l736ch:
	ld de,l8aa5h		;736c	11 a5 8a 	. . . 
l736fh:
	push de			;736f	d5 	. 
	call sub_7379h		;7370	cd 79 73 	. y s 
	pop de			;7373	d1 	. 
	ret c			;7374	d8 	. 
	inc de			;7375	13 	. 
	jr nz,l736fh		;7376	20 f7 	  . 
	ret			;7378	c9 	. 
sub_7379h:
	ld hl,l738dh		;7379	21 8d 73 	! . s 
	ld b,(hl)			;737c	46 	F 
l737dh:
	inc hl			;737d	23 	# 
l737eh:
	ld a,(de)			;737e	1a 	. 
	inc de			;737f	13 	. 
	dec a			;7380	3d 	= 
	jr z,l737eh		;7381	28 fb 	( . 
	inc a			;7383	3c 	< 
	ret z			;7384	c8 	. 
	xor (hl)			;7385	ae 	. 
	and 0dfh		;7386	e6 df 	. . 
	ret nz			;7388	c0 	. 
	djnz l737dh		;7389	10 f2 	. . 
	scf			;738b	37 	7 
	ret			;738c	c9 	. 
l738dh:
	nop			;738d	00 	. 
l738eh:
	add a,d			;738e	82 	. 
	ld l,c			;738f	69 	i 
	jp nz,00009h		;7390	c2 09 00 	. . . 
	ex de,hl			;7393	eb 	. 
	ex af,af'			;7394	08 	. 
	add a,d			;7395	82 	. 
	ld l,c			;7396	69 	i 
	jp nz,00318h		;7397	c2 18 03 	. . . 
	nop			;739a	00 	. 
	ld a,b			;739b	78 	x 
	ld l,a			;739c	6f 	o 
	ld (hl),e			;739d	73 	s 
	ld h,l			;739e	65 	e 
	ld h,(hl)			;739f	66 	f 
	ld (hl),e			;73a0	73 	s 
	jr nc,$-59		;73a1	30 c3 	0 . 
	push de			;73a3	d5 	. 
	ex af,af'			;73a4	08 	. 
	add a,d			;73a5	82 	. 
	ld l,d			;73a6	6a 	j 
	jp nz,00000h		;73a7	c2 00 00 	. . . 
	nop			;73aa	00 	. 
	ld (bc),a			;73ab	02 	. 
	add a,b			;73ac	80 	. 
	ret c			;73ad	d8 	. 
	jp nz,000c5h		;73ae	c2 c5 00 	. . . 
	push bc			;73b1	c5 	. 
	nop			;73b2	00 	. 
	ex de,hl			;73b3	eb 	. 
	nop			;73b4	00 	. 
	ld hl,(0cd02h)		;73b5	2a 02 cd 	* . . 
	ld hl,0c373h		;73b8	21 73 c3 	! s . 
	xor (hl)			;73bb	ae 	. 
	ld l,c			;73bc	69 	i 
	ld (l60a8h),a		;73bd	32 a8 60 	2 . ` 
	ld a,010h		;73c0	3e 10 	> . 
sub_73c2h:
	ld (073d2h),a		;73c2	32 d2 73 	2 . s 
	ld a,010h		;73c5	3e 10 	> . 
l73c7h:
	push af			;73c7	f5 	. 
	ex af,af'			;73c8	08 	. 
	ld a,b			;73c9	78 	x 
	or c			;73ca	b1 	. 
	jp z,l7cc6h		;73cb	ca c6 7c 	. . | 
	ex af,af'			;73ce	08 	. 
	push bc			;73cf	c5 	. 
	push hl			;73d0	e5 	. 
	ld c,000h		;73d1	0e 00 	. . 
	call 022b0h		;73d3	cd b0 22 	. . " 
	ld (08788h),hl		;73d6	22 88 87 	" . . 
	pop hl			;73d9	e1 	. 
	push hl			;73da	e5 	. 
	ld de,00000h		;73db	11 00 00 	. . . 
	and a			;73de	a7 	. 
	sbc hl,de		;73df	ed 52 	. R 
	ex de,hl			;73e1	eb 	. 
	ld hl,(087d7h)		;73e2	2a d7 87 	* . . 
	ld c,(hl)			;73e5	4e 	N 
	inc hl			;73e6	23 	# 
	ld b,(hl)			;73e7	46 	F 
l73e8h:
	inc hl			;73e8	23 	# 
	ld a,(hl)			;73e9	7e 	~ 
	inc hl			;73ea	23 	# 
	push hl			;73eb	e5 	. 
	ld h,(hl)			;73ec	66 	f 
	ld l,a			;73ed	6f 	o 
	ld a,h			;73ee	7c 	| 
	and 03fh		;73ef	e6 3f 	. ? 
	ld h,a			;73f1	67 	g 
	sbc hl,de		;73f2	ed 52 	. R 
	pop hl			;73f4	e1 	. 
	jr z,l7401h		;73f5	28 0a 	( . 
	dec bc			;73f7	0b 	. 
	ld a,b			;73f8	78 	x 
	or c			;73f9	b1 	. 
	jr nz,l73e8h		;73fa	20 ec 	  . 
	ld a,010h		;73fc	3e 10 	> . 
	jp l809ah		;73fe	c3 9a 80 	. . . 
l7401h:
	ld c,(hl)			;7401	4e 	N 
	pop hl			;7402	e1 	. 
	ld e,(hl)			;7403	5e 	^ 
	inc hl			;7404	23 	# 
	ld d,(hl)			;7405	56 	V 
	inc hl			;7406	23 	# 
	push de			;7407	d5 	. 
	ex de,hl			;7408	eb 	. 
	ld hl,l8aa5h		;7409	21 a5 8a 	! . . 
	ld (hl),020h		;740c	36 20 	6   
	bit 7,c		;740e	cb 79 	. y 
	jr z,l7414h		;7410	28 02 	( . 
	ld (hl),02ah		;7412	36 2a 	6 * 
l7414h:
	inc hl			;7414	23 	# 
	push bc			;7415	c5 	. 
	ld b,009h		;7416	06 09 	. . 
	call sub_82d4h		;7418	cd d4 82 	. . . 
	pop bc			;741b	c1 	. 
	ex de,hl			;741c	eb 	. 
	ex (sp),hl			;741d	e3 	. 
	ex de,hl			;741e	eb 	. 
	ld a,c			;741f	79 	y 
	and 0c0h		;7420	e6 c0 	. . 
	jr nz,l742dh		;7422	20 09 	  . 
	ld bc,0052eh		;7424	01 2e 05 	. . . 
	call l82e1h		;7427	cd e1 82 	. . . 
	ld (hl),b			;742a	70 	p 
	jr l7436h		;742b	18 09 	. . 
l742dh:
	push hl			;742d	e5 	. 
	pop ix		;742e	dd e1 	. . 
	ex de,hl			;7430	eb 	. 
	ld c,000h		;7431	0e 00 	. . 
	call sub_8908h		;7433	cd 08 89 	. . . 
l7436h:
	ld hl,l8aa5h		;7436	21 a5 8a 	! . . 
	call sub_8a1bh		;7439	cd 1b 8a 	. . . 
	ld a,000h		;743c	3e 00 	> . 
	or a			;743e	b7 	. 
	call nz,l732fh		;743f	c4 2f 73 	. / s 
	pop hl			;7442	e1 	. 
	pop bc			;7443	c1 	. 
	dec bc			;7444	0b 	. 
	pop af			;7445	f1 	. 
	add a,008h		;7446	c6 08 	. . 
	cp 0a9h		;7448	fe a9 	. . 
	jp c,l73c7h		;744a	da c7 73 	. . s 
	ret			;744d	c9 	. 
l744eh:
	ld b,050h		;744e	06 50 	. P 
	call sub_7c33h		;7450	cd 33 7c 	. 3 | 
	ld a,001h		;7453	3e 01 	> . 
	jr z,l7458h		;7455	28 01 	( . 
	dec a			;7457	3d 	= 
l7458h:
	ld (0743dh),a		;7458	32 3d 74 	2 = t 
	ld a,00eh		;745b	3e 0e 	> . 
	call l89f4h		;745d	cd f4 89 	. . . 
	ld hl,05840h		;7460	21 40 58 	! @ X 
	ld a,038h		;7463	3e 38 	> 8 
	ex af,af'			;7465	08 	. 
	ld a,030h		;7466	3e 30 	> 0 
	ld c,014h		;7468	0e 14 	. . 
l746ah:
	ld b,020h		;746a	06 20 	.   
l746ch:
	ld (hl),a			;746c	77 	w 
	inc hl			;746d	23 	# 
	djnz l746ch		;746e	10 fc 	. . 
	ex af,af'			;7470	08 	. 
	dec c			;7471	0d 	. 
	jr nz,l746ah		;7472	20 f6 	  . 
	ld hl,(087d7h)		;7474	2a d7 87 	* . . 
	ld c,(hl)			;7477	4e 	N 
	inc hl			;7478	23 	# 
	ld b,(hl)			;7479	46 	F 
	inc hl			;747a	23 	# 
	add hl,bc			;747b	09 	. 
	add hl,bc			;747c	09 	. 
	ld (073dch),hl		;747d	22 dc 73 	" . s 
l7480h:
	ld a,b			;7480	78 	x 
	or c			;7481	b1 	. 
	jr z,l74a2h		;7482	28 1e 	( . 
	exx			;7484	d9 	. 
	ld a,010h		;7485	3e 10 	> . 
l7487h:
	push af			;7487	f5 	. 
	call sub_85f0h		;7488	cd f0 85 	. . . 
	pop af			;748b	f1 	. 
	add a,008h		;748c	c6 08 	. . 
	cp 0a9h		;748e	fe a9 	. . 
	jr c,l7487h		;7490	38 f5 	8 . 
	exx			;7492	d9 	. 
	xor a			;7493	af 	. 
	call sub_73c2h		;7494	cd c2 73 	. . s 
	ld a,088h		;7497	3e 88 	> . 
	call sub_73c2h		;7499	cd c2 73 	. . s 
	exx			;749c	d9 	. 
	call sub_8639h		;749d	cd 39 86 	. 9 . 
	cp 020h		;74a0	fe 20 	.   
l74a2h:
	jp z,l7cc9h		;74a2	ca c9 7c 	. . | 
	exx			;74a5	d9 	. 
	jr l7480h		;74a6	18 d8 	. . 
	ld b,043h		;74a8	06 43 	. C 
	call sub_7c2ch		;74aa	cd 2c 7c 	. , | 
	jr z,l74ebh		;74ad	28 3c 	( < 
	ld b,04ch		;74af	06 4c 	. L 
	call sub_7c33h		;74b1	cd 33 7c 	. 3 | 
	ld c,0feh		;74b4	0e fe 	. . 
	jr z,l74c1h		;74b6	28 09 	( . 
	ld b,055h		;74b8	06 55 	. U 
	call sub_7c33h		;74ba	cd 33 7c 	. 3 | 
	jr nz,l744eh		;74bd	20 8f 	  . 
	ld c,0beh		;74bf	0e be 	. . 
l74c1h:
	ld a,c			;74c1	79 	y 
	ld (074d1h),a		;74c2	32 d1 74 	2 . t 
	ld hl,(087d7h)		;74c5	2a d7 87 	* . . 
	ld c,(hl)			;74c8	4e 	N 
	inc hl			;74c9	23 	# 
	ld b,(hl)			;74ca	46 	F 
	inc hl			;74cb	23 	# 
l74cch:
	ld a,b			;74cc	78 	x 
	or c			;74cd	b1 	. 
	ret z			;74ce	c8 	. 
	inc hl			;74cf	23 	# 
	set 7,(hl)		;74d0	cb fe 	. . 
	inc hl			;74d2	23 	# 
	dec bc			;74d3	0b 	. 
	jr l74cch		;74d4	18 f6 	. . 
	ld b,079h		;74d6	06 79 	. y 
	call sub_7c2ch		;74d8	cd 2c 7c 	. , | 
	ret nz			;74db	c0 	. 
	ld hl,l9c27h+1		;74dc	21 28 9c 	! ( . 
	ld (080e8h),hl		;74df	22 e8 80 	" . . 
	call sub_718eh		;74e2	cd 8e 71 	. . q 
	ld (080ebh),hl		;74e5	22 eb 80 	" . . 
	call sub_7343h		;74e8	cd 43 73 	. C s 
l74ebh:
	call sub_89f2h		;74eb	cd f2 89 	. . . 
	ld c,0b6h		;74ee	0e b6 	. . 
	call l74c1h		;74f0	cd c1 74 	. . t 
	ld hl,l9c27h+1		;74f3	21 28 9c 	! ( . 
	call sub_75e9h		;74f6	cd e9 75 	. . u 
l74f9h:
	jr nc,l7510h		;74f9	30 15 	0 . 
	push hl			;74fb	e5 	. 
	ld l,(hl)			;74fc	6e 	n 
	and 07fh		;74fd	e6 7f 	.  
	ld h,a			;74ff	67 	g 
	add hl,hl			;7500	29 	) 
	ld de,(087d7h)		;7501	ed 5b d7 87 	. [ . . 
	add hl,de			;7505	19 	. 
	inc hl			;7506	23 	# 
	set 6,(hl)		;7507	cb f6 	. . 
	pop hl			;7509	e1 	. 
	inc hl			;750a	23 	# 
	call sub_75f8h		;750b	cd f8 75 	. . u 
	jr l74f9h		;750e	18 e9 	. . 
l7510h:
	ld hl,(087d7h)		;7510	2a d7 87 	* . . 
	ld c,(hl)			;7513	4e 	N 
	inc hl			;7514	23 	# 
	ld b,(hl)			;7515	46 	F 
	inc hl			;7516	23 	# 
	push hl			;7517	e5 	. 
	add hl,bc			;7518	09 	. 
	add hl,bc			;7519	09 	. 
	ld (0753ah),hl		;751a	22 3a 75 	" : u 
	pop hl			;751d	e1 	. 
l751eh:
	ld a,b			;751e	78 	x 
	or c			;751f	b1 	. 
	jr nz,l7527h		;7520	20 05 	  . 
	ld c,0b6h		;7522	0e b6 	. . 
	jp l74c1h		;7524	c3 c1 74 	. . t 
l7527h:
	dec bc			;7527	0b 	. 
	ld (l75d4h+1),hl		;7528	22 d5 75 	" . u 
	ld e,(hl)			;752b	5e 	^ 
	inc hl			;752c	23 	# 
	ld a,(hl)			;752d	7e 	~ 
	and 0c0h		;752e	e6 c0 	. . 
	ld a,(hl)			;7530	7e 	~ 
	inc hl			;7531	23 	# 
	jr nz,l751eh		;7532	20 ea 	  . 
	and 03fh		;7534	e6 3f 	. ? 
	ld d,a			;7536	57 	W 
	push bc			;7537	c5 	. 
	push hl			;7538	e5 	. 
	ld hl,00000h		;7539	21 00 00 	! . . 
	add hl,de			;753c	19 	. 
	ld (07590h),de		;753d	ed 53 90 75 	. S . u 
	ld d,h			;7541	54 	T 
	ld e,l			;7542	5d 	] 
	inc de			;7543	13 	. 
	inc de			;7544	13 	. 
l7545h:
	ld a,(de)			;7545	1a 	. 
	inc de			;7546	13 	. 
	rlca			;7547	07 	. 
	jr nc,l7545h		;7548	30 fb 	0 . 
	call sub_88e1h		;754a	cd e1 88 	. . . 
	and a			;754d	a7 	. 
	sbc hl,de		;754e	ed 52 	. R 
	ld b,h			;7550	44 	D 
	ld c,l			;7551	4d 	M 
	ld hl,l8819h+1		;7552	21 1a 88 	! . . 
	call sub_89d1h		;7555	cd d1 89 	. . . 
	pop hl			;7558	e1 	. 
	push bc			;7559	c5 	. 
	ld d,h			;755a	54 	T 
	ld e,l			;755b	5d 	] 
	dec hl			;755c	2b 	+ 
	dec hl			;755d	2b 	+ 
	call sub_88e1h		;755e	cd e1 88 	. . . 
	ld bc,00002h		;7561	01 02 00 	. . . 
	ld hl,0753ah		;7564	21 3a 75 	! : u 
	call sub_89d1h		;7567	cd d1 89 	. . . 
	ld hl,l8819h+1		;756a	21 1a 88 	! . . 
	call sub_89d1h		;756d	cd d1 89 	. . . 
	pop bc			;7570	c1 	. 
	push bc			;7571	c5 	. 
	inc bc			;7572	03 	. 
sub_7573h:
	inc bc			;7573	03 	. 
l7574h:
	xor a			;7574	af 	. 
	ld (de),a			;7575	12 	. 
	inc de			;7576	13 	. 
	dec bc			;7577	0b 	. 
	ld a,b			;7578	78 	x 
	or c			;7579	b1 	. 
	jr nz,l7574h		;757a	20 f8 	  . 
	ld hl,(087d7h)		;757c	2a d7 87 	* . . 
	push hl			;757f	e5 	. 
	inc bc			;7580	03 	. 
	call sub_89d1h		;7581	cd d1 89 	. . . 
	pop ix		;7584	dd e1 	. . 
	pop bc			;7586	c1 	. 
l7587h:
	ld a,d			;7587	7a 	z 
	or e			;7588	b3 	. 
	jr z,l75a1h		;7589	28 16 	( . 
	push de			;758b	d5 	. 
	call sub_75dbh		;758c	cd db 75 	. . u 
	ld de,00000h		;758f	11 00 00 	. . . 
	and a			;7592	a7 	. 
	sbc hl,de		;7593	ed 52 	. R 
	jr c,l759dh		;7595	38 06 	8 . 
	push ix		;7597	dd e5 	. . 
	pop hl			;7599	e1 	. 
	call sub_89d1h		;759a	cd d1 89 	. . . 
l759dh:
	pop de			;759d	d1 	. 
	dec de			;759e	1b 	. 
	jr l7587h		;759f	18 e6 	. . 
l75a1h:
	ld hl,(l75d4h+1)		;75a1	2a d5 75 	* . u 
	ld de,(087d7h)		;75a4	ed 5b d7 87 	. [ . . 
	sbc hl,de		;75a8	ed 52 	. R 
	ex de,hl			;75aa	eb 	. 
	srl d		;75ab	cb 3a 	. : 
	rr e		;75ad	cb 1b 	. . 
	ld hl,l9c27h+1		;75af	21 28 9c 	! ( . 
	call sub_75e9h		;75b2	cd e9 75 	. . u 
l75b5h:
	jr nc,l75d4h		;75b5	30 1d 	0 . 
	push hl			;75b7	e5 	. 
	ld l,(hl)			;75b8	6e 	n 
	ld h,a			;75b9	67 	g 
	push hl			;75ba	e5 	. 
	res 7,h		;75bb	cb bc 	. . 
	or a			;75bd	b7 	. 
	sbc hl,de		;75be	ed 52 	. R 
	pop hl			;75c0	e1 	. 
	jr nc,l75cah		;75c1	30 07 	0 . 
	pop hl			;75c3	e1 	. 
l75c4h:
	inc hl			;75c4	23 	# 
	call sub_75f8h		;75c5	cd f8 75 	. . u 
	jr l75b5h		;75c8	18 eb 	. . 
l75cah:
	dec hl			;75ca	2b 	+ 
	ld b,h			;75cb	44 	D 
	ld c,l			;75cc	4d 	M 
	pop hl			;75cd	e1 	. 
	ld (hl),c			;75ce	71 	q 
	dec hl			;75cf	2b 	+ 
	ld (hl),b			;75d0	70 	p 
	inc hl			;75d1	23 	# 
	jr l75c4h		;75d2	18 f0 	. . 
l75d4h:
	ld hl,00000h		;75d4	21 00 00 	! . . 
	pop bc			;75d7	c1 	. 
	jp l751eh		;75d8	c3 1e 75 	. . u 
sub_75dbh:
	inc ix		;75db	dd 23 	. # 
	ld l,(ix+001h)		;75dd	dd 6e 01 	. n . 
	inc ix		;75e0	dd 23 	. # 
	ld a,(ix+001h)		;75e2	dd 7e 01 	. ~ . 
	and 03fh		;75e5	e6 3f 	. ? 
	ld h,a			;75e7	67 	g 
	ret			;75e8	c9 	. 
sub_75e9h:
	call sub_8a2fh		;75e9	cd 2f 8a 	. / . 
	ret nc			;75ec	d0 	. 
	inc hl			;75ed	23 	# 
	ld a,(hl)			;75ee	7e 	~ 
	and 00fh		;75ef	e6 0f 	. . 
	inc hl			;75f1	23 	# 
	jr z,sub_75e9h		;75f2	28 f5 	( . 
	and 008h		;75f4	e6 08 	. . 
	jr nz,l7603h		;75f6	20 0b 	  . 
sub_75f8h:
	ld a,(hl)			;75f8	7e 	~ 
	inc hl			;75f9	23 	# 
	cp 0c0h		;75fa	fe c0 	. . 
	jr nc,sub_75e9h		;75fc	30 eb 	0 . 
	cp 080h		;75fe	fe 80 	. . 
	jr c,sub_75f8h		;7600	38 f6 	8 . 
	dec hl			;7602	2b 	+ 
l7603h:
	ld a,(hl)			;7603	7e 	~ 
	inc hl			;7604	23 	# 
	scf			;7605	37 	7 
	ret			;7606	c9 	. 
	ld ix,050e0h		;7607	dd 21 e0 50 	. ! . P 
	ld (ix+000h),003h		;760b	dd 36 00 03 	. 6 . . 
	call sub_7c2ah		;760f	cd 2a 7c 	. * | 
	push af			;7612	f5 	. 
	ld b,03ah		;7613	06 3a 	. : 
	cp b			;7615	b8 	. 
	jr z,l761bh		;7616	28 03 	( . 
	call sub_7c2fh		;7618	cd 2f 7c 	. / | 
l761bh:
	jr nz,l7620h		;761b	20 03 	  . 
	call sub_76bch		;761d	cd bc 76 	. . v 
l7620h:
	ld hl,l76d5h		;7620	21 d5 76 	! . v 
	ld de,050e1h		;7623	11 e1 50 	. . P 
	ld bc,0000ah		;7626	01 0a 00 	. . . 
	ldir		;7629	ed b0 	. . 
	pop af			;762b	f1 	. 
	jr z,l763ah		;762c	28 0c 	( . 
	ld hl,(087d7h)		;762e	2a d7 87 	* . . 
	ld de,0fff4h		;7631	11 f4 ff 	. . . 
	add hl,de			;7634	19 	. 
	ld de,l9c27h+1		;7635	11 28 9c 	. ( . 
	jr l7641h		;7638	18 07 	. . 
l763ah:
	call 080e7h		;763a	cd e7 80 	. . . 
	ex de,hl			;763d	eb 	. 
	call sub_8248h		;763e	cd 48 82 	. H . 
l7641h:
	push de			;7641	d5 	. 
	ld (076ebh),de		;7642	ed 53 eb 76 	. S . v 
	or a			;7646	b7 	. 
	sbc hl,de		;7647	ed 52 	. R 
	push hl			;7649	e5 	. 
	ld (076eeh),hl		;764a	22 ee 76 	" . v 
	ld (050efh),hl		;764d	22 ef 50 	" . P 
	ld hl,(l8819h+1)		;7650	2a 1a 88 	* . . 
	ld de,(087d7h)		;7653	ed 5b d7 87 	. [ . . 
	and a			;7657	a7 	. 
	sbc hl,de		;7658	ed 52 	. R 
	ld (07681h),de		;765a	ed 53 81 76 	. S . v 
	inc hl			;765e	23 	# 
	ld (07686h),hl		;765f	22 86 76 	" . v 
	dec hl			;7662	2b 	+ 
	pop de			;7663	d1 	. 
	push de			;7664	d5 	. 
	add hl,de			;7665	19 	. 
	inc hl			;7666	23 	# 
	inc hl			;7667	23 	# 
	ld (050ebh),hl		;7668	22 eb 50 	" . P 
	ld a,00ch		;766b	3e 0c 	> . 
	push ix		;766d	dd e5 	. . 
	call l89f4h		;766f	cd f4 89 	. . . 
	pop ix		;7672	dd e1 	. . 
	call sub_769ah		;7674	cd 9a 76 	. . v 
	pop de			;7677	d1 	. 
	pop ix		;7678	dd e1 	. . 
	ld a,0ffh		;767a	3e ff 	> . 
	call 004c6h		;767c	cd c6 04 	. . . 
	ld ix,00000h		;767f	dd 21 00 00 	. ! . . 
	dec ix		;7683	dd 2b 	. + 
	ld de,00000h		;7685	11 00 00 	. . . 
	ld l,0ffh		;7688	2e ff 	. . 
	ld a,h			;768a	7c 	| 
	xor l			;768b	ad 	. 
	ld h,a			;768c	67 	g 
	ld a,001h		;768d	3e 01 	> . 
	scf			;768f	37 	7 
	rl l		;7690	cb 15 	. . 
	ld b,037h		;7692	06 37 	. 7 
	call 0051ah		;7694	cd 1a 05 	. . . 
	jp sub_7bbch		;7697	c3 bc 7b 	. . { 
sub_769ah:
	ld h,001h		;769a	26 01 	& . 
l769ch:
	inc hl			;769c	23 	# 
	inc h			;769d	24 	$ 
	dec h			;769e	25 	% 
	jr nz,l769ch		;769f	20 fb 	  . 
l76a1h:
	xor a			;76a1	af 	. 
	in a,(0feh)		;76a2	db fe 	. . 
	cpl			;76a4	2f 	/ 
	and 01fh		;76a5	e6 1f 	. . 
	jr z,l76a1h		;76a7	28 f8 	( . 
	ld de,00011h		;76a9	11 11 00 	. . . 
	xor a			;76ac	af 	. 
	call 004c6h		;76ad	cd c6 04 	. . . 
l76b0h:
	dec de			;76b0	1b 	. 
	dec d			;76b1	15 	. 
	inc d			;76b2	14 	. 
	jr nz,l76b0h		;76b3	20 fb 	  . 
	ret			;76b5	c9 	. 
sub_76b6h:
	ld b,03ah		;76b6	06 3a 	. : 
	call sub_7c2ch		;76b8	cd 2c 7c 	. , | 
	ret nz			;76bb	c0 	. 
sub_76bch:
	ld de,l76d5h		;76bc	11 d5 76 	. . v 
sub_76bfh:
	ld b,00ah		;76bf	06 0a 	. . 
l76c1h:
	call sub_85aeh		;76c1	cd ae 85 	. . . 
	inc hl			;76c4	23 	# 
	or a			;76c5	b7 	. 
	jr z,l76ceh		;76c6	28 06 	( . 
	ld (de),a			;76c8	12 	. 
	inc de			;76c9	13 	. 
	dec b			;76ca	05 	. 
	jr nz,l76c1h		;76cb	20 f4 	  . 
	ret			;76cd	c9 	. 
l76ceh:
	ld a,020h		;76ce	3e 20 	>   
l76d0h:
	ld (de),a			;76d0	12 	. 
	inc de			;76d1	13 	. 
	djnz l76d0h		;76d2	10 fc 	. . 
	ret			;76d4	c9 	. 
l76d5h:
	ld (hl),b			;76d5	70 	p 
	ld (hl),d			;76d6	72 	r 
	ld l,a			;76d7	6f 	o 
	ld l,l			;76d8	6d 	m 
	ld h,l			;76d9	65 	e 
	ld (hl),h			;76da	74 	t 
	ld l,b			;76db	68 	h 
	ld h,l			;76dc	65 	e 
	ld (hl),l			;76dd	75 	u 
	ld (hl),e			;76de	73 	s 
l76dfh:
	call sub_7bdch		;76df	cd dc 7b 	. . { 
	call sub_7c1ah		;76e2	cd 1a 7c 	. . | 
	jr nz,l76dfh		;76e5	20 f8 	  . 
	xor a			;76e7	af 	. 
	dec a			;76e8	3d 	= 
	ld ix,00000h		;76e9	dd 21 00 00 	. ! . . 
	ld de,00000h		;76ed	11 00 00 	. . . 
	call sub_770ah		;76f0	cd 0a 77 	. . w 
	ld ix,(07681h)		;76f3	dd 2a 81 76 	. * . v 
	ld de,(07686h)		;76f7	ed 5b 86 76 	. [ . v 
	dec de			;76fb	1b 	. 
	ld b,0b0h		;76fc	06 b0 	. . 
	ex af,af'			;76fe	08 	. 
	xor a			;76ff	af 	. 
	dec a			;7700	3d 	= 
	ex af,af'			;7701	08 	. 
	call 005c8h		;7702	cd c8 05 	. . . 
	call sub_7bbch		;7705	cd bc 7b 	. . { 
	jr l770dh		;7708	18 03 	. . 
sub_770ah:
	call sub_7bb1h		;770a	cd b1 7b 	. . { 
l770dh:
	ret c			;770d	d8 	. 
	ld a,00dh		;770e	3e 0d 	> . 
l7710h:
	call l89f4h		;7710	cd f4 89 	. . . 
	jp l80a2h		;7713	c3 a2 80 	. . . 
	call sub_89e8h		;7716	cd e8 89 	. . . 
	ld hl,l7760h		;7719	21 60 77 	! ` w 
	ld (07e39h),hl		;771c	22 39 7e 	" 9 ~ 
l771fh:
	ld hl,00000h		;771f	21 00 00 	! . . 
	push hl			;7722	e5 	. 
	push hl			;7723	e5 	. 
	pop ix		;7724	dd e1 	. . 
	call sub_8248h		;7726	cd 48 82 	. H . 
	ld (l771fh+1),hl		;7729	22 20 77 	"   w 
	pop hl			;772c	e1 	. 
	ld de,00000h		;772d	11 00 00 	. . . 
	and a			;7730	a7 	. 
	sbc hl,de		;7731	ed 52 	. R 
	jr nc,l7774h		;7733	30 3f 	0 ? 
	ld a,021h		;7735	3e 21 	> ! 
	ld hl,00000h		;7737	21 00 00 	! . . 
	call sub_77cah		;773a	cd ca 77 	. . w 
	call sub_8135h		;773d	cd 35 81 	. 5 . 
	ld a,02ah		;7740	3e 2a 	> * 
	ld hl,087d7h		;7742	21 d7 87 	! . . 
	call sub_77cah		;7745	cd ca 77 	. . w 
	ld a,(07cffh)		;7748	3a ff 7c 	: . | 
	cp 010h		;774b	fe 10 	. . 
	jr z,l7710h		;774d	28 c1 	( . 
	ld hl,l8aa5h		;774f	21 a5 8a 	! . . 
	ld de,l8affh		;7752	11 ff 8a 	. . . 
	ld bc,00020h		;7755	01 20 00 	.   . 
	ldir		;7758	ed b0 	. . 
	call l82dbh		;775a	cd db 82 	. . . 
	jp l7dddh		;775d	c3 dd 7d 	. . } 
l7760h:
	call sub_8262h		;7760	cd 62 82 	. b . 
	ld de,(l771fh+1)		;7763	ed 5b 20 77 	. [   w 
	ld hl,(l8819h+1)		;7767	2a 1a 88 	* . . 
	and a			;776a	a7 	. 
	sbc hl,de		;776b	ed 52 	. R 
	jr c,l771fh		;776d	38 b0 	8 . 
	ld a,007h		;776f	3e 07 	> . 
	jp l809ah		;7771	c3 9a 80 	. . . 
l7774h:
	ld hl,l7ccfh		;7774	21 cf 7c 	! . | 
	ld (07e39h),hl		;7777	22 39 7e 	" 9 ~ 
	jp (hl)			;777a	e9 	. 
	call sub_89e8h		;777b	cd e8 89 	. . . 
	ld hl,l77b9h		;777e	21 b9 77 	! . w 
	ld (07e39h),hl		;7781	22 39 7e 	" 9 ~ 
l7784h:
	ld b,001h		;7784	06 01 	. . 
	ld de,l8affh		;7786	11 ff 8a 	. . . 
	ld hl,(l771fh+1)		;7789	2a 20 77 	*   w 
	inc hl			;778c	23 	# 
	inc hl			;778d	23 	# 
l778eh:
	ld a,(hl)			;778e	7e 	~ 
	inc hl			;778f	23 	# 
	cp 00dh		;7790	fe 0d 	. . 
	jr z,l77a5h		;7792	28 11 	( . 
	bit 5,b		;7794	cb 68 	. h 
	jr nz,l778eh		;7796	20 f6 	  . 
	cp 020h		;7798	fe 20 	.   
	jr nc,l779eh		;779a	30 02 	0 . 
	ld a,020h		;779c	3e 20 	>   
l779eh:
	and 07fh		;779e	e6 7f 	.  
	ld (de),a			;77a0	12 	. 
	inc de			;77a1	13 	. 
	inc b			;77a2	04 	. 
	jr l778eh		;77a3	18 e9 	. . 
l77a5h:
	ld (l771fh+1),hl		;77a5	22 20 77 	"   w 
	ld a,001h		;77a8	3e 01 	> . 
	ld (de),a			;77aa	12 	. 
l77abh:
	inc de			;77ab	13 	. 
	xor a			;77ac	af 	. 
	ld (de),a			;77ad	12 	. 
	inc b			;77ae	04 	. 
	bit 5,b		;77af	cb 68 	. h 
	jr z,l77abh		;77b1	28 f8 	( . 
	call l82dbh		;77b3	cd db 82 	. . . 
	jp l7dddh		;77b6	c3 dd 7d 	. . } 
l77b9h:
	call sub_8262h		;77b9	cd 62 82 	. b . 
	ld hl,(l771fh+1)		;77bc	2a 20 77 	*   w 
	ld de,(l7945h+1)		;77bf	ed 5b 46 79 	. [ F y 
	and a			;77c3	a7 	. 
	sbc hl,de		;77c4	ed 52 	. R 
	jr c,l7784h		;77c6	38 bc 	8 . 
	jr l7774h		;77c8	18 aa 	. . 
sub_77cah:
	ld (sub_8116h),a		;77ca	32 16 81 	2 . . 
	ld (sub_8116h+1),hl		;77cd	22 17 81 	" . . 
	ret			;77d0	c9 	. 
l77d1h:
	call sub_7bdch		;77d1	cd dc 7b 	. . { 
	call sub_7c0dh		;77d4	cd 0d 7c 	. . | 
	jr nz,l77d1h		;77d7	20 f8 	  . 
	ld hl,(050ebh)		;77d9	2a eb 50 	* . P 
	ld b,h			;77dc	44 	D 
	ld c,l			;77dd	4d 	M 
	call sub_8068h		;77de	cd 68 80 	. h . 
	ex de,hl			;77e1	eb 	. 
	ld hl,(l7945h+1)		;77e2	2a 46 79 	* F y 
	and a			;77e5	a7 	. 
	sbc hl,de		;77e6	ed 52 	. R 
	push hl			;77e8	e5 	. 
	ld (l771fh+1),hl		;77e9	22 20 77 	"   w 
	ld bc,(050efh)		;77ec	ed 4b ef 50 	. K . P 
	add hl,bc			;77f0	09 	. 
	ld (0772eh),hl		;77f1	22 2e 77 	" . w 
	inc hl			;77f4	23 	# 
	inc hl			;77f5	23 	# 
	ld (07738h),hl		;77f6	22 38 77 	" 8 w 
	pop ix		;77f9	dd e1 	. . 
	scf			;77fb	37 	7 
	sbc a,a			;77fc	9f 	. 
	call sub_770ah		;77fd	cd 0a 77 	. . w 
sub_7800h:
	ld a,007h		;7800	3e 07 	> . 
	out (0feh),a		;7802	d3 fe 	. . 
	ret			;7804	c9 	. 
sub_7805h:
	call sub_7c2ah		;7805	cd 2a 7c 	. * | 
	ld a,000h		;7808	3e 00 	> . 
	jr z,l780dh		;780a	28 01 	( . 
	inc a			;780c	3c 	< 
l780dh:
	ld (0783fh),a		;780d	32 3f 78 	2 ? x 
	ld c,0b6h		;7810	0e b6 	. . 
	call l74c1h		;7812	cd c1 74 	. . t 
	ld a,001h		;7815	3e 01 	> . 
	ld (l7850h+1),a		;7817	32 51 78 	2 Q x 
	ld hl,sub_79afh		;781a	21 af 79 	! . y 
	ld (l7848h+1),hl		;781d	22 49 78 	" I x 
l7820h:
	ld hl,(l8819h+1)		;7820	2a 1a 88 	* . . 
	inc hl			;7823	23 	# 
	ld (l7953h+1),hl		;7824	22 54 79 	" T y 
	ld (07935h),hl		;7827	22 35 79 	" 5 y 
	ld hl,l9c27h+1		;782a	21 28 9c 	! ( . 
l782dh:
	call sub_8a2fh		;782d	cd 2f 8a 	. / . 
	jr nc,l7850h		;7830	30 1e 	0 . 
	ld (l79c3h+1),hl		;7832	22 c4 79 	" . y 
	push hl			;7835	e5 	. 
	call sub_8248h		;7836	cd 48 82 	. H . 
	ld (l784bh+1),hl		;7839	22 4c 78 	" L x 
	pop ix		;783c	dd e1 	. . 
	ld a,000h		;783e	3e 00 	> . 
	or a			;7840	b7 	. 
	jr nz,l7848h		;7841	20 05 	  . 
	call sub_80f5h		;7843	cd f5 80 	. . . 
	jr c,l784bh		;7846	38 03 	8 . 
l7848h:
	call sub_79afh		;7848	cd af 79 	. . y 
l784bh:
	ld hl,00000h		;784b	21 00 00 	! . . 
	jr l782dh		;784e	18 dd 	. . 
l7850h:
	ld a,000h		;7850	3e 00 	> . 
	dec a			;7852	3d 	= 
	ld (l7850h+1),a		;7853	32 51 78 	2 Q x 
	ld hl,sub_78dah		;7856	21 da 78 	! . x 
	ld (l7848h+1),hl		;7859	22 49 78 	" I x 
	jr z,l7820h		;785c	28 c2 	( . 
	ret			;785e	c9 	. 
	call sub_7805h		;785f	cd 05 78 	. . x 
	ld a,00bh		;7862	3e 0b 	> . 
	jp l7cdah		;7864	c3 da 7c 	. . | 
l7867h:
	ld a,(ix+000h)		;7867	dd 7e 00 	. ~ . 
	call sub_7a02h		;786a	cd 02 7a 	. . z 
	sub 002h		;786d	d6 02 	. . 
	ret c			;786f	d8 	. 
	jr nz,l787dh		;7870	20 0b 	  . 
	call sub_7a98h		;7872	cd 98 7a 	. . z 
	ld (07cc4h),hl		;7875	22 c4 7c 	" . | 
	ld hl,07cb9h		;7878	21 b9 7c 	! . | 
	dec (hl)			;787b	35 	5 
	ret			;787c	c9 	. 
l787dh:
	dec a			;787d	3d 	= 
	ret z			;787e	c8 	. 
	dec a			;787f	3d 	= 
	jp z,l7a25h		;7880	ca 25 7a 	. % z 
	dec a			;7883	3d 	= 
	jr nz,l788ch		;7884	20 06 	  . 
	call sub_7a98h		;7886	cd 98 7a 	. . z 
	jp l7a2ch		;7889	c3 2c 7a 	. , z 
l788ch:
	dec a			;788c	3d 	= 
	jr nz,l789ch		;788d	20 0d 	  . 
l788fh:
	call sub_7a98h		;788f	cd 98 7a 	. . z 
	jp c,l792ah		;7892	da 2a 79 	. * y 
	call l792ah		;7895	cd 2a 79 	. * y 
	inc ix		;7898	dd 23 	. # 
	jr l788fh		;789a	18 f3 	. . 
l789ch:
	dec a			;789c	3d 	= 
	jr nz,l78c9h		;789d	20 2a 	  * 
l789fh:
	call sub_78b3h		;789f	cd b3 78 	. . x 
	jr nz,l78a9h		;78a2	20 05 	  . 
	call sub_7931h		;78a4	cd 31 79 	. 1 y 
	jr l789fh		;78a7	18 f6 	. . 
l78a9h:
	ld a,e			;78a9	7b 	{ 
	cp 027h		;78aa	fe 27 	. ' 
	jr nz,l78b0h		;78ac	20 02 	  . 
	set 7,d		;78ae	cb fa 	. . 
l78b0h:
	ld a,d			;78b0	7a 	z 
	jr sub_7931h		;78b1	18 7e 	. ~ 
sub_78b3h:
	call sub_810ah		;78b3	cd 0a 81 	. . . 
	bit 7,(ix+004h)		;78b6	dd cb 04 7e 	. . . ~ 
	ret nz			;78ba	c0 	. 
	ld a,d			;78bb	7a 	z 
	cp 022h		;78bc	fe 22 	. " 
	jr nz,l78c4h		;78be	20 04 	  . 
	cp e			;78c0	bb 	. 
	call z,sub_810ah		;78c1	cc 0a 81 	. . . 
l78c4h:
	bit 7,(ix+004h)		;78c4	dd cb 04 7e 	. . . ~ 
	ret			;78c8	c9 	. 
l78c9h:
	dec a			;78c9	3d 	= 
	jp z,l7a4ch		;78ca	ca 4c 7a 	. L z 
l78cdh:
	call sub_7a98h		;78cd	cd 98 7a 	. . z 
	jp c,sub_7962h		;78d0	da 62 79 	. b y 
	call sub_7962h		;78d3	cd 62 79 	. b y 
	inc ix		;78d6	dd 23 	. # 
	jr l78cdh		;78d8	18 f3 	. . 
sub_78dah:
	ld b,(ix+001h)		;78da	dd 46 01 	. F . 
	ld a,b			;78dd	78 	x 
	and 030h		;78de	e6 30 	. 0 
	cp 030h		;78e0	fe 30 	. 0 
	jr z,l7867h		;78e2	28 83 	( . 
	ld a,b			;78e4	78 	x 
	and 0b0h		;78e5	e6 b0 	. . 
	cp 090h		;78e7	fe 90 	. . 
	jr c,l78f9h		;78e9	38 0e 	8 . 
	call l78f9h		;78eb	cd f9 78 	. . x 
	ld hl,(07935h)		;78ee	2a 35 79 	* 5 y 
	dec hl			;78f1	2b 	+ 
	ld a,(hl)			;78f2	7e 	~ 
	dec hl			;78f3	2b 	+ 
	ld b,(hl)			;78f4	46 	F 
	ld (hl),a			;78f5	77 	w 
	inc hl			;78f6	23 	# 
	ld (hl),b			;78f7	70 	p 
	ret			;78f8	c9 	. 
l78f9h:
	ld a,0ddh		;78f9	3e dd 	> . 
	bit 5,b		;78fb	cb 68 	. h 
	call nz,sub_7931h		;78fd	c4 31 79 	. 1 y 
	ld a,0fdh		;7900	3e fd 	> . 
	bit 4,b		;7902	cb 60 	. ` 
	call nz,sub_7931h		;7904	c4 31 79 	. 1 y 
	ld a,0cbh		;7907	3e cb 	> . 
	bit 7,b		;7909	cb 78 	. x 
	call nz,sub_7931h		;790b	c4 31 79 	. 1 y 
	ld a,0edh		;790e	3e ed 	> . 
	bit 6,b		;7910	cb 70 	. p 
	call nz,sub_7931h		;7912	c4 31 79 	. 1 y 
	ld a,(ix+000h)		;7915	dd 7e 00 	. ~ . 
	call sub_7931h		;7918	cd 31 79 	. 1 y 
	call sub_7a02h		;791b	cd 02 7a 	. . z 
	ld a,b			;791e	78 	x 
	and 007h		;791f	e6 07 	. . 
	ret z			;7921	c8 	. 
	dec a			;7922	3d 	= 
	push af			;7923	f5 	. 
	call sub_7a98h		;7924	cd 98 7a 	. . z 
	pop af			;7927	f1 	. 
	jr nz,l795fh		;7928	20 35 	  5 
l792ah:
	ld a,b			;792a	78 	x 
	inc a			;792b	3c 	< 
l792ch:
	and 0feh		;792c	e6 fe 	. . 
	jr nz,l7987h		;792e	20 57 	  W 
	ld a,c			;7930	79 	y 
sub_7931h:
	ld de,l5dc0h		;7931	11 c0 5d 	. . ] 
	ld hl,00000h		;7934	21 00 00 	! . . 
	and a			;7937	a7 	. 
	sbc hl,de		;7938	ed 52 	. R 
	add hl,de			;793a	19 	. 
	ex de,hl			;793b	eb 	. 
	jr c,l7945h		;793c	38 07 	8 . 
	ld hl,(l8819h+1)		;793e	2a 1a 88 	* . . 
	sbc hl,de		;7941	ed 52 	. R 
	jr nc,l795bh		;7943	30 16 	0 . 
l7945h:
	ld hl,0ffffh		;7945	21 ff ff 	! . . 
	and a			;7948	a7 	. 
	sbc hl,de		;7949	ed 52 	. R 
	jr c,l795bh		;794b	38 0e 	8 . 
	ld (de),a			;794d	12 	. 
	inc de			;794e	13 	. 
	ld (07935h),de		;794f	ed 53 35 79 	. S 5 y 
l7953h:
	ld hl,00000h		;7953	21 00 00 	! . . 
	inc hl			;7956	23 	# 
	ld (l7953h+1),hl		;7957	22 54 79 	" T y 
	ret			;795a	c9 	. 
l795bh:
	ld a,008h		;795b	3e 08 	> . 
	jr l79c3h		;795d	18 64 	. d 
l795fh:
	dec a			;795f	3d 	= 
	jr nz,l7969h		;7960	20 07 	  . 
sub_7962h:
	ld a,c			;7962	79 	y 
	call sub_7931h		;7963	cd 31 79 	. 1 y 
	ld a,b			;7966	78 	x 
	jr sub_7931h		;7967	18 c8 	. . 
l7969h:
	dec a			;7969	3d 	= 
	jr nz,l798bh		;796a	20 1f 	  . 
	ld hl,(l7953h+1)		;796c	2a 54 79 	* T y 
	inc hl			;796f	23 	# 
	push bc			;7970	c5 	. 
	ex (sp),hl			;7971	e3 	. 
	pop bc			;7972	c1 	. 
	and a			;7973	a7 	. 
	sbc hl,bc		;7974	ed 42 	. B 
l7976h:
	ld a,l			;7976	7d 	} 
	inc h			;7977	24 	$ 
	jr z,l7983h		;7978	28 09 	( . 
	dec h			;797a	25 	% 
	jr nz,l7987h		;797b	20 0a 	  . 
	cp 080h		;797d	fe 80 	. . 
	jr nc,l7987h		;797f	30 06 	0 . 
l7981h:
	jr sub_7931h		;7981	18 ae 	. . 
l7983h:
	cp 080h		;7983	fe 80 	. . 
	jr nc,l7981h		;7985	30 fa 	0 . 
l7987h:
	ld a,003h		;7987	3e 03 	> . 
	jr l79c3h		;7989	18 38 	. 8 
l798bh:
	dec a			;798b	3d 	= 
	jr nz,l7992h		;798c	20 04 	  . 
sub_798eh:
	ld h,b			;798e	60 	` 
	ld l,c			;798f	69 	i 
	jr l7976h		;7990	18 e4 	. . 
l7992h:
	dec a			;7992	3d 	= 
	jr nz,l799fh		;7993	20 0a 	  . 
	call sub_798eh		;7995	cd 8e 79 	. . y 
	inc ix		;7998	dd 23 	. # 
	call sub_7a98h		;799a	cd 98 7a 	. . z 
	jr l792ah		;799d	18 8b 	. . 
l799fh:
	ld a,c			;799f	79 	y 
	and 0c7h		;79a0	e6 c7 	. . 
	or b			;79a2	b0 	. 
	ld a,006h		;79a3	3e 06 	> . 
	jr nz,l79c3h		;79a5	20 1c 	  . 
	ld a,c			;79a7	79 	y 
	ld hl,(07935h)		;79a8	2a 35 79 	* 5 y 
	dec hl			;79ab	2b 	+ 
	add a,(hl)			;79ac	86 	. 
	ld (hl),a			;79ad	77 	w 
	ret			;79ae	c9 	. 
sub_79afh:
	bit 3,(ix+001h)		;79af	dd cb 01 5e 	. . . ^ 
	jr z,l79d6h		;79b3	28 21 	( ! 
	call sub_8113h		;79b5	cd 13 81 	. . . 
	ld (07a1bh),de		;79b8	ed 53 1b 7a 	. S . z 
	ld a,(hl)			;79bc	7e 	~ 
	and 0c0h		;79bd	e6 c0 	. . 
	jr z,l79cch		;79bf	28 0b 	( . 
	ld a,012h		;79c1	3e 12 	> . 
l79c3h:
	ld hl,00000h		;79c3	21 00 00 	! . . 
	ld (sub_826ch+1),hl		;79c6	22 6d 82 	" m . 
	jp l809ah		;79c9	c3 9a 80 	. . . 
l79cch:
	set 6,(hl)		;79cc	cb f6 	. . 
	ld hl,(l7953h+1)		;79ce	2a 54 79 	* T y 
	ex de,hl			;79d1	eb 	. 
	dec hl			;79d2	2b 	+ 
	ld (hl),d			;79d3	72 	r 
	dec hl			;79d4	2b 	+ 
	ld (hl),e			;79d5	73 	s 
l79d6h:
	ld a,(ix+001h)		;79d6	dd 7e 01 	. ~ . 
	and 030h		;79d9	e6 30 	. 0 
	cp 030h		;79db	fe 30 	. 0 
	jr z,l7a0ch		;79dd	28 2d 	( - 
	ld a,(ix+001h)		;79df	dd 7e 01 	. ~ . 
	and 007h		;79e2	e6 07 	. . 
	ld c,a			;79e4	4f 	O 
	ld b,000h		;79e5	06 00 	. . 
	ld hl,l79fah		;79e7	21 fa 79 	! . y 
	add hl,bc			;79ea	09 	. 
	ld a,(hl)			;79eb	7e 	~ 
	inc a			;79ec	3c 	< 
	ld bc,00400h		;79ed	01 00 04 	. . . 
	ld d,(ix+001h)		;79f0	dd 56 01 	. V . 
l79f3h:
	rl d		;79f3	cb 12 	. . 
	adc a,c			;79f5	89 	. 
	djnz l79f3h		;79f6	10 fb 	. . 
	jr l7a67h		;79f8	18 6d 	. m 
l79fah:
	nop			;79fa	00 	. 
	ld bc,00102h		;79fb	01 02 01 	. . . 
	ld bc,00002h		;79fe	01 02 00 	. . . 
	nop			;7a01	00 	. 
sub_7a02h:
	bit 3,(ix+001h)		;7a02	dd cb 01 5e 	. . . ^ 
	ret z			;7a06	c8 	. 
	inc ix		;7a07	dd 23 	. # 
	inc ix		;7a09	dd 23 	. # 
	ret			;7a0b	c9 	. 
l7a0ch:
	ld a,(ix+000h)		;7a0c	dd 7e 00 	. ~ . 
	call sub_7a02h		;7a0f	cd 02 7a 	. . z 
	sub 003h		;7a12	d6 03 	. . 
	ret c			;7a14	d8 	. 
	jr nz,l7a22h		;7a15	20 0b 	  . 
	call sub_7a98h		;7a17	cd 98 7a 	. . z 
	ld hl,00000h		;7a1a	21 00 00 	! . . 
	dec hl			;7a1d	2b 	+ 
	ld (hl),b			;7a1e	70 	p 
	dec hl			;7a1f	2b 	+ 
	ld (hl),c			;7a20	71 	q 
	ret			;7a21	c9 	. 
l7a22h:
	dec a			;7a22	3d 	= 
	jr nz,l7a31h		;7a23	20 0c 	  . 
l7a25h:
	call sub_7a98h		;7a25	cd 98 7a 	. . z 
	ld (l7953h+1),bc		;7a28	ed 43 54 79 	. C T y 
l7a2ch:
	ld (07935h),bc		;7a2c	ed 43 35 79 	. C 5 y 
	ret			;7a30	c9 	. 
l7a31h:
	dec a			;7a31	3d 	= 
	ret z			;7a32	c8 	. 
	dec a			;7a33	3d 	= 
	jr nz,l7a3ch		;7a34	20 06 	  . 
	call sub_7a70h		;7a36	cd 70 7a 	. p z 
	ld a,c			;7a39	79 	y 
	jr l7a67h		;7a3a	18 2b 	. + 
l7a3ch:
	dec a			;7a3c	3d 	= 
	jr nz,l7a49h		;7a3d	20 0a 	  . 
	ld c,a			;7a3f	4f 	O 
l7a40h:
	inc c			;7a40	0c 	. 
	call sub_78b3h		;7a41	cd b3 78 	. . x 
	jr z,l7a40h		;7a44	28 fa 	( . 
	ld a,c			;7a46	79 	y 
	jr l7a67h		;7a47	18 1e 	. . 
l7a49h:
	dec a			;7a49	3d 	= 
	jr nz,l7a62h		;7a4a	20 16 	  . 
l7a4ch:
	call sub_7a98h		;7a4c	cd 98 7a 	. . z 
	push af			;7a4f	f5 	. 
	ld hl,l7953h+1		;7a50	21 54 79 	! T y 
	call sub_8980h		;7a53	cd 80 89 	. . . 
	ld hl,07935h		;7a56	21 35 79 	! 5 y 
	call sub_8980h		;7a59	cd 80 89 	. . . 
	pop af			;7a5c	f1 	. 
	inc ix		;7a5d	dd 23 	. # 
	jr nc,l7a4ch		;7a5f	30 eb 	0 . 
	ret			;7a61	c9 	. 
l7a62h:
	call sub_7a70h		;7a62	cd 70 7a 	. p z 
	ld a,c			;7a65	79 	y 
	add a,c			;7a66	81 	. 
l7a67h:
	ld b,000h		;7a67	06 00 	. . 
	ld c,a			;7a69	4f 	O 
	ld hl,l7953h+1		;7a6a	21 54 79 	! T y 
	jp sub_8980h		;7a6d	c3 80 89 	. . . 
sub_7a70h:
	ld c,001h		;7a70	0e 01 	. . 
l7a72h:
	ld a,(ix+002h)		;7a72	dd 7e 02 	. ~ . 
	cp 02ch		;7a75	fe 2c 	. , 
	jr nz,l7a7ch		;7a77	20 03 	  . 
	inc c			;7a79	0c 	. 
	jr l7a89h		;7a7a	18 0d 	. . 
l7a7ch:
	cp 022h		;7a7c	fe 22 	. " 
	jr nz,l7a8dh		;7a7e	20 0d 	  . 
l7a80h:
	inc ix		;7a80	dd 23 	. # 
	ld a,(ix+002h)		;7a82	dd 7e 02 	. ~ . 
	cp 022h		;7a85	fe 22 	. " 
	jr nz,l7a80h		;7a87	20 f7 	  . 
l7a89h:
	inc ix		;7a89	dd 23 	. # 
	jr l7a72h		;7a8b	18 e5 	. . 
l7a8dh:
	cp 0c0h		;7a8d	fe c0 	. . 
	ret nc			;7a8f	d0 	. 
	cp 080h		;7a90	fe 80 	. . 
	jr c,l7a89h		;7a92	38 f5 	8 . 
	inc ix		;7a94	dd 23 	. # 
	jr l7a89h		;7a96	18 f1 	. . 
sub_7a98h:
	ld hl,00000h		;7a98	21 00 00 	! . . 
	ld a,02bh		;7a9b	3e 2b 	> + 
l7a9dh:
	push hl			;7a9d	e5 	. 
	push af			;7a9e	f5 	. 
	ld a,(ix+002h)		;7a9f	dd 7e 02 	. ~ . 
	push af			;7aa2	f5 	. 
	cp 02dh		;7aa3	fe 2d 	. - 
	jr nz,l7aa9h		;7aa5	20 02 	  . 
	inc ix		;7aa7	dd 23 	. # 
l7aa9h:
	ld a,(ix+002h)		;7aa9	dd 7e 02 	. ~ . 
	cp 024h		;7aac	fe 24 	. $ 
	ld de,(l7953h+1)		;7aae	ed 5b 54 79 	. [ T y 
	jr z,l7ad5h		;7ab2	28 21 	( ! 
	cp 080h		;7ab4	fe 80 	. . 
	jp c,l7b5bh		;7ab6	da 5b 7b 	. [ { 
	ld d,a			;7ab9	57 	W 
	ld e,(ix+003h)		;7aba	dd 5e 03 	. ^ . 
	inc ix		;7abd	dd 23 	. # 
	call sub_8116h		;7abf	cd 16 81 	. . . 
	ld a,(hl)			;7ac2	7e 	~ 
	and 0c0h		;7ac3	e6 c0 	. . 
	jr nz,l7ad0h		;7ac5	20 09 	  . 
	ld (080c0h),de		;7ac7	ed 53 c0 80 	. S . . 
	ld a,009h		;7acb	3e 09 	> . 
	jp l79c3h		;7acd	c3 c3 79 	. . y 
l7ad0h:
	dec de			;7ad0	1b 	. 
	ex de,hl			;7ad1	eb 	. 
	ld d,(hl)			;7ad2	56 	V 
	dec hl			;7ad3	2b 	+ 
	ld e,(hl)			;7ad4	5e 	^ 
l7ad5h:
	inc ix		;7ad5	dd 23 	. # 
	jr l7b05h		;7ad7	18 2c 	. , 
l7ad9h:
	ld a,(ix+002h)		;7ad9	dd 7e 02 	. ~ . 
	xor 02ch		;7adc	ee 2c 	. , 
	ld b,h			;7ade	44 	D 
	ld c,l			;7adf	4d 	M 
	ret z			;7ae0	c8 	. 
	xor 033h		;7ae1	ee 33 	. 3 
	ret z			;7ae3	c8 	. 
	cp 0c0h		;7ae4	fe c0 	. . 
	ccf			;7ae6	3f 	? 
	ret c			;7ae7	d8 	. 
	xor 01fh		;7ae8	ee 1f 	. . 
	inc ix		;7aea	dd 23 	. # 
	jp l7a9dh		;7aec	c3 9d 7a 	. . z 
l7aefh:
	ld de,00000h		;7aef	11 00 00 	. . . 
	inc ix		;7af2	dd 23 	. # 
	call sub_7b9dh		;7af4	cd 9d 7b 	. . { 
	jr c,l7b03h		;7af7	38 0a 	8 . 
	ld e,a			;7af9	5f 	_ 
	call sub_7b9dh		;7afa	cd 9d 7b 	. . { 
	jr c,l7b03h		;7afd	38 04 	8 . 
	ld d,e			;7aff	53 	S 
	ld e,a			;7b00	5f 	_ 
	inc ix		;7b01	dd 23 	. # 
l7b03h:
	ex de,hl			;7b03	eb 	. 
l7b04h:
	ex de,hl			;7b04	eb 	. 
l7b05h:
	pop af			;7b05	f1 	. 
	call sub_7b50h		;7b06	cd 50 7b 	. P { 
	pop af			;7b09	f1 	. 
	pop hl			;7b0a	e1 	. 
	ld bc,l7ad9h		;7b0b	01 d9 7a 	. . z 
	push bc			;7b0e	c5 	. 
sub_7b0fh:
	cp 02bh		;7b0f	fe 2b 	. + 
	jr z,l7b4bh		;7b11	28 38 	( 8 
	cp 02dh		;7b13	fe 2d 	. - 
	jr z,l7b4dh		;7b15	28 36 	( 6 
	cp 02ah		;7b17	fe 2a 	. * 
	jr z,sub_7b3ah		;7b19	28 1f 	( . 
	cp 02fh		;7b1b	fe 2f 	. / 
	jr z,l7b34h		;7b1d	28 15 	( . 
sub_7b1fh:
	ld a,h			;7b1f	7c 	| 
	ld c,l			;7b20	4d 	M 
	ld hl,00000h		;7b21	21 00 00 	! . . 
	ld b,010h		;7b24	06 10 	. . 
l7b26h:
	sli c		;7b26	cb 31 	. 1 
	rla			;7b28	17 	. 
	adc hl,hl		;7b29	ed 6a 	. j 
	sbc hl,de		;7b2b	ed 52 	. R 
	jr nc,l7b31h		;7b2d	30 02 	0 . 
	add hl,de			;7b2f	19 	. 
	dec c			;7b30	0d 	. 
l7b31h:
	djnz l7b26h		;7b31	10 f3 	. . 
	ret			;7b33	c9 	. 
l7b34h:
	call sub_7b1fh		;7b34	cd 1f 7b 	. . { 
	ld h,a			;7b37	67 	g 
	ld l,c			;7b38	69 	i 
	ret			;7b39	c9 	. 
sub_7b3ah:
	ld b,010h		;7b3a	06 10 	. . 
	ld a,h			;7b3c	7c 	| 
	ld c,l			;7b3d	4d 	M 
	ld hl,00000h		;7b3e	21 00 00 	! . . 
l7b41h:
	add hl,hl			;7b41	29 	) 
	rl c		;7b42	cb 11 	. . 
	rla			;7b44	17 	. 
	jr nc,l7b48h		;7b45	30 01 	0 . 
	add hl,de			;7b47	19 	. 
l7b48h:
	djnz l7b41h		;7b48	10 f7 	. . 
	ret			;7b4a	c9 	. 
l7b4bh:
	add hl,de			;7b4b	19 	. 
	ret			;7b4c	c9 	. 
l7b4dh:
	or a			;7b4d	b7 	. 
	sbc hl,de		;7b4e	ed 52 	. R 
sub_7b50h:
	cp 02dh		;7b50	fe 2d 	. - 
	ret nz			;7b52	c0 	. 
	ld a,d			;7b53	7a 	z 
	cpl			;7b54	2f 	/ 
	ld d,a			;7b55	57 	W 
	ld a,e			;7b56	7b 	{ 
	cpl			;7b57	2f 	/ 
	ld e,a			;7b58	5f 	_ 
	inc de			;7b59	13 	. 
	ret			;7b5a	c9 	. 
l7b5bh:
	ld a,(ix+002h)		;7b5b	dd 7e 02 	. ~ . 
	cp 022h		;7b5e	fe 22 	. " 
	jr z,l7aefh		;7b60	28 8d 	( . 
	ld c,00ah		;7b62	0e 0a 	. . 
	cp 025h		;7b64	fe 25 	. % 
	jr nz,l7b6ch		;7b66	20 04 	  . 
	inc ix		;7b68	dd 23 	. # 
	ld c,002h		;7b6a	0e 02 	. . 
l7b6ch:
	cp 023h		;7b6c	fe 23 	. # 
	jr nz,l7b74h		;7b6e	20 04 	  . 
	inc ix		;7b70	dd 23 	. # 
	ld c,010h		;7b72	0e 10 	. . 
l7b74h:
	ld hl,00000h		;7b74	21 00 00 	! . . 
l7b77h:
	ld a,(ix+002h)		;7b77	dd 7e 02 	. ~ . 
	sub 030h		;7b7a	d6 30 	. 0 
	cp 00ah		;7b7c	fe 0a 	. . 
	jr c,l7b87h		;7b7e	38 07 	8 . 
	sub 007h		;7b80	d6 07 	. . 
	cp 00ah		;7b82	fe 0a 	. . 
	jp c,l7b04h		;7b84	da 04 7b 	. . { 
l7b87h:
	cp c			;7b87	b9 	. 
	jp nc,l7b04h		;7b88	d2 04 7b 	. . { 
	push af			;7b8b	f5 	. 
	ld a,c			;7b8c	79 	y 
	dec a			;7b8d	3d 	= 
	ld d,h			;7b8e	54 	T 
	ld e,l			;7b8f	5d 	] 
l7b90h:
	add hl,de			;7b90	19 	. 
	dec a			;7b91	3d 	= 
	jr nz,l7b90h		;7b92	20 fc 	  . 
	pop af			;7b94	f1 	. 
	ld d,000h		;7b95	16 00 	. . 
	ld e,a			;7b97	5f 	_ 
	add hl,de			;7b98	19 	. 
	inc ix		;7b99	dd 23 	. # 
	jr l7b77h		;7b9b	18 da 	. . 
sub_7b9dh:
	ld a,(ix+002h)		;7b9d	dd 7e 02 	. ~ . 
	cp 022h		;7ba0	fe 22 	. " 
	jr nz,l7badh		;7ba2	20 09 	  . 
	cp (ix+003h)		;7ba4	dd be 03 	. . . 
	inc ix		;7ba7	dd 23 	. # 
	jr z,l7badh		;7ba9	28 02 	( . 
	scf			;7bab	37 	7 
	ret			;7bac	c9 	. 
l7badh:
	inc ix		;7bad	dd 23 	. # 
	or a			;7baf	b7 	. 
	ret			;7bb0	c9 	. 
sub_7bb1h:
	inc d			;7bb1	14 	. 
	ex af,af'			;7bb2	08 	. 
	dec d			;7bb3	15 	. 
	di			;7bb4	f3 	. 
	ld a,00fh		;7bb5	3e 0f 	> . 
	out (0feh),a		;7bb7	d3 fe 	. . 
	call 00562h		;7bb9	cd 62 05 	. b . 
sub_7bbch:
	push af			;7bbc	f5 	. 
	ld a,07fh		;7bbd	3e 7f 	>  
	in a,(0feh)		;7bbf	db fe 	. . 
	rra			;7bc1	1f 	. 
	jp nc,l80a2h		;7bc2	d2 a2 80 	. . . 
	pop af			;7bc5	f1 	. 
	ret			;7bc6	c9 	. 
	ld b,061h		;7bc7	06 61 	. a 
	call sub_7c2ch		;7bc9	cd 2c 7c 	. , | 
	call z,sub_7805h		;7bcc	cc 05 78 	. . x 
	call sub_7ca1h		;7bcf	cd a1 7c 	. . | 
	jp l5f74h		;7bd2	c3 74 5f 	. t _ 
	ld b,079h		;7bd5	06 79 	. y 
	call sub_7c2ch		;7bd7	cd 2c 7c 	. , | 
	ret nz			;7bda	c0 	. 
	rst 0			;7bdb	c7 	. 
sub_7bdch:
	ld ix,050e0h		;7bdc	dd 21 e0 50 	. ! . P 
	ld de,00011h		;7be0	11 11 00 	. . . 
	xor a			;7be3	af 	. 
	scf			;7be4	37 	7 
	call sub_7bb1h		;7be5	cd b1 7b 	. . { 
	jr nc,sub_7bdch		;7be8	30 f2 	0 . 
	ld a,011h		;7bea	3e 11 	> . 
	call sub_80b4h		;7bec	cd b4 80 	. . . 
	ld hl,050e1h		;7bef	21 e1 50 	! . P 
	ld b,00ah		;7bf2	06 0a 	. . 
l7bf4h:
	ld a,(hl)			;7bf4	7e 	~ 
	cp 020h		;7bf5	fe 20 	.   
	jr c,l7bfdh		;7bf7	38 04 	8 . 
	cp 080h		;7bf9	fe 80 	. . 
	jr c,l7bffh		;7bfb	38 02 	8 . 
l7bfdh:
	ld a,03fh		;7bfd	3e 3f 	> ? 
l7bffh:
	call sub_8744h		;7bff	cd 44 87 	. D . 
	inc hl			;7c02	23 	# 
	djnz l7bf4h		;7c03	10 ef 	. . 
	ld a,(050e0h)		;7c05	3a e0 50 	: . P 
	cp 003h		;7c08	fe 03 	. . 
	jr nz,sub_7bdch		;7c0a	20 d0 	  . 
	ret			;7c0c	c9 	. 
sub_7c0dh:
	ld b,00ah		;7c0d	06 0a 	. . 
	ld hl,l76d5h		;7c0f	21 d5 76 	! . v 
l7c12h:
	ld a,(hl)			;7c12	7e 	~ 
	cp 020h		;7c13	fe 20 	.   
	jr nz,sub_7c1ah		;7c15	20 03 	  . 
	djnz l7c12h		;7c17	10 f9 	. . 
	ret			;7c19	c9 	. 
sub_7c1ah:
	ld b,00ah		;7c1a	06 0a 	. . 
	ld hl,l76d5h		;7c1c	21 d5 76 	! . v 
	ld de,050e1h		;7c1f	11 e1 50 	. . P 
l7c22h:
	ld a,(de)			;7c22	1a 	. 
	cp (hl)			;7c23	be 	. 
	inc hl			;7c24	23 	# 
	inc de			;7c25	13 	. 
	ret nz			;7c26	c0 	. 
	djnz l7c22h		;7c27	10 f9 	. . 
	ret			;7c29	c9 	. 
sub_7c2ah:
	ld b,042h		;7c2a	06 42 	. B 
sub_7c2ch:
	ld hl,l8affh+1		;7c2c	21 00 8b 	! . . 
sub_7c2fh:
	call sub_85aeh		;7c2f	cd ae 85 	. . . 
	inc hl			;7c32	23 	# 
sub_7c33h:
	cp b			;7c33	b8 	. 
	ret z			;7c34	c8 	. 
	set 5,b		;7c35	cb e8 	. . 
	cp b			;7c37	b8 	. 
	ret			;7c38	c9 	. 
l7c39h:
	ld hl,sub_8908h+1		;7c39	21 09 89 	! . . 
	jr l7c41h		;7c3c	18 03 	. . 
sub_7c3eh:
	ld hl,07e1fh		;7c3e	21 1f 7e 	! . ~ 
l7c41h:
	ld a,(hl)			;7c41	7e 	~ 
	xor 001h		;7c42	ee 01 	. . 
	ld (hl),a			;7c44	77 	w 
	ret			;7c45	c9 	. 
	ld iy,05c3ah		;7c46	fd 21 3a 5c 	. ! : \ 
	im 1		;7c4a	ed 56 	. V 
	ei			;7c4c	fb 	. 
	ld sp,(05c3dh)		;7c4d	ed 7b 3d 5c 	. { = \ 
	jp 01b76h		;7c51	c3 76 1b 	. v . 
sub_7c54h:
	push af			;7c54	f5 	. 
	ld c,000h		;7c55	0e 00 	. . 
	call 022b0h		;7c57	cd b0 22 	. . " 
	push hl			;7c5a	e5 	. 
	call sub_7c83h		;7c5b	cd 83 7c 	. . | 
	pop de			;7c5e	d1 	. 
	pop af			;7c5f	f1 	. 
	ret			;7c60	c9 	. 
sub_7c61h:
	push hl			;7c61	e5 	. 
	pop ix		;7c62	dd e1 	. . 
	call sub_828fh		;7c64	cd 8f 82 	. . . 
	ld a,0efh		;7c67	3e ef 	> . 
	in a,(0feh)		;7c69	db fe 	. . 
	ret			;7c6b	c9 	. 
sub_7c6ch:
	call sub_8232h		;7c6c	cd 32 82 	. 2 . 
	call sub_8a24h		;7c6f	cd 24 8a 	. $ . 
	ccf			;7c72	3f 	? 
	jr l7c7bh		;7c73	18 06 	. . 
sub_7c75h:
	call sub_8245h		;7c75	cd 45 82 	. E . 
	call sub_8a2fh		;7c78	cd 2f 8a 	. / . 
l7c7bh:
	pop de			;7c7b	d1 	. 
	jr nc,l7ceeh		;7c7c	30 70 	0 p 
	push de			;7c7e	d5 	. 
	ld (sub_826ch+1),hl		;7c7f	22 6d 82 	" m . 
	ret			;7c82	c9 	. 
sub_7c83h:
	push hl			;7c83	e5 	. 
	push de			;7c84	d5 	. 
	ld b,008h		;7c85	06 08 	. . 
l7c87h:
	push hl			;7c87	e5 	. 
	push de			;7c88	d5 	. 
	ld c,020h		;7c89	0e 20 	.   
l7c8bh:
	ld a,(hl)			;7c8b	7e 	~ 
	ld (de),a			;7c8c	12 	. 
	inc l			;7c8d	2c 	, 
	inc e			;7c8e	1c 	. 
	dec c			;7c8f	0d 	. 
	jr nz,l7c8bh		;7c90	20 f9 	  . 
	pop de			;7c92	d1 	. 
	pop hl			;7c93	e1 	. 
	inc h			;7c94	24 	$ 
	inc d			;7c95	14 	. 
	djnz l7c87h		;7c96	10 ef 	. . 
	pop de			;7c98	d1 	. 
	pop hl			;7c99	e1 	. 
	ret			;7c9a	c9 	. 
sub_7c9bh:
	ld (de),a			;7c9b	12 	. 
	inc de			;7c9c	13 	. 
	dec c			;7c9d	0d 	. 
	ret nz			;7c9e	c0 	. 
	jr l7ccfh		;7c9f	18 2e 	. . 
sub_7ca1h:
	ld e,020h		;7ca1	1e 20 	.   
l7ca3h:
	ld bc,00003h		;7ca3	01 03 00 	. . . 
l7ca6h:
	ld a,e			;7ca6	7b 	{ 
	call sub_8769h		;7ca7	cd 69 87 	. i . 
	djnz l7ca6h		;7caa	10 fa 	. . 
	dec c			;7cac	0d 	. 
	jr nz,l7ca6h		;7cad	20 f7 	  . 
	ret			;7caf	c9 	. 
	ld a,001h		;7cb0	3e 01 	> . 
	ld (07cb9h),a		;7cb2	32 b9 7c 	2 . | 
	call sub_7805h		;7cb5	cd 05 78 	. . x 
	ld a,000h		;7cb8	3e 00 	> . 
	or a			;7cba	b7 	. 
	ld a,013h		;7cbb	3e 13 	> . 
	jp nz,l809ah		;7cbd	c2 9a 80 	. . . 
	call sub_7ca1h		;7cc0	cd a1 7c 	. . | 
	call 00000h		;7cc3	cd 00 00 	. . . 
l7cc6h:
	call sub_8639h		;7cc6	cd 39 86 	. 9 . 
l7cc9h:
	di			;7cc9	f3 	. 
	ld e,07eh		;7cca	1e 7e 	. ~ 
	call l7ca3h		;7ccc	cd a3 7c 	. . | 
l7ccfh:
	ld hl,059e0h		;7ccf	21 e0 59 	! . Y 
	ld bc,02030h		;7cd2	01 30 20 	. 0   
	call l82e1h		;7cd5	cd e1 82 	. . . 
	ld a,00fh		;7cd8	3e 0f 	> . 
l7cdah:
	call l89f4h		;7cda	cd f4 89 	. . . 
	ld hl,l8aa5h		;7cdd	21 a5 8a 	! . . 
	ld bc,l9e00h		;7ce0	01 00 9e 	. . . 
	call l82e1h		;7ce3	cd e1 82 	. . . 
	ld hl,l8affh		;7ce6	21 ff 8a 	! . . 
	ld (hl),001h		;7ce9	36 01 	6 . 
	dec hl			;7ceb	2b 	+ 
	ld (hl),080h		;7cec	36 80 	6 . 
l7ceeh:
	ld sp,08ba1h		;7cee	31 a1 8b 	1 . . 
	call sub_826ch		;7cf1	cd 6c 82 	. l . 
l7cf4h:
	call sub_85beh		;7cf4	cd be 85 	. . . 
	call sub_7800h		;7cf7	cd 00 78 	. . x 
	call sub_8639h		;7cfa	cd 39 86 	. 9 . 
	push af			;7cfd	f5 	. 
	ld a,00fh		;7cfe	3e 0f 	> . 
	call l89f4h		;7d00	cd f4 89 	. . . 
	ld a,00fh		;7d03	3e 0f 	> . 
	ld (07cffh),a		;7d05	32 ff 7c 	2 . | 
	pop af			;7d08	f1 	. 
	cp 015h		;7d09	fe 15 	. . 
	jr z,l7ccfh		;7d0b	28 c2 	( . 
	cp 004h		;7d0d	fe 04 	. . 
	jr nz,l7d2ah		;7d0f	20 19 	  . 
	ld ix,(sub_826ch+1)		;7d11	dd 2a 6d 82 	. * m . 
	ld hl,l8affh		;7d15	21 ff 8a 	! . . 
	push hl			;7d18	e5 	. 
	ld bc,02000h		;7d19	01 00 20 	. .   
	call l82e1h		;7d1c	cd e1 82 	. . . 
	pop hl			;7d1f	e1 	. 
	call sub_8138h		;7d20	cd 38 81 	. 8 . 
	ld a,001h		;7d23	3e 01 	> . 
	ld (07e1fh),a		;7d25	32 1f 7e 	2 . ~ 
	jr l7d31h		;7d28	18 07 	. . 
l7d2ah:
	cp 014h		;7d2a	fe 14 	. . 
	jr nz,l7d38h		;7d2c	20 0a 	  . 
	call sub_7c3eh		;7d2e	cd 3e 7c 	. > | 
l7d31h:
	ld a,00fh		;7d31	3e 0f 	> . 
	call l89f4h		;7d33	cd f4 89 	. . . 
	jr l7ceeh		;7d36	18 b6 	. . 
l7d38h:
	ld b,014h		;7d38	06 14 	. . 
	cp 006h		;7d3a	fe 06 	. . 
	jr nz,l7d45h		;7d3c	20 07 	  . 
l7d3eh:
	call sub_7c75h		;7d3e	cd 75 7c 	. u | 
	djnz l7d3eh		;7d41	10 fb 	. . 
l7d43h:
	jr l7ceeh		;7d43	18 a9 	. . 
l7d45h:
	cp 009h		;7d45	fe 09 	. . 
	jr nz,l7d73h		;7d47	20 2a 	  * 
l7d49h:
	call sub_7c75h		;7d49	cd 75 7c 	. u | 
	ld de,04040h		;7d4c	11 40 40 	. @ @ 
	ld a,018h		;7d4f	3e 18 	> . 
l7d51h:
	call sub_7c54h		;7d51	cd 54 7c 	. T | 
	add a,008h		;7d54	c6 08 	. . 
	cp 0a9h		;7d56	fe a9 	. . 
	jr c,l7d51h		;7d58	38 f7 	8 . 
	ld hl,050a0h		;7d5a	21 a0 50 	! . P 
	call sub_85f5h		;7d5d	cd f5 85 	. . . 
	ld b,006h		;7d60	06 06 	. . 
	ld hl,(sub_826ch+1)		;7d62	2a 6d 82 	* m . 
l7d65h:
	call sub_8248h		;7d65	cd 48 82 	. H . 
	djnz l7d65h		;7d68	10 fb 	. . 
	call sub_7c61h		;7d6a	cd 61 7c 	. a | 
	bit 4,a		;7d6d	cb 67 	. g 
	jr z,l7d49h		;7d6f	28 d8 	( . 
l7d71h:
	jr l7cf4h		;7d71	18 81 	. . 
l7d73h:
	cp 007h		;7d73	fe 07 	. . 
	jr nz,l7d7eh		;7d75	20 07 	  . 
l7d77h:
	call sub_7c6ch		;7d77	cd 6c 7c 	. l | 
	djnz l7d77h		;7d7a	10 fb 	. . 
l7d7ch:
	jr l7d43h		;7d7c	18 c5 	. . 
l7d7eh:
	cp 00ah		;7d7e	fe 0a 	. . 
	jr nz,l7dach		;7d80	20 2a 	  * 
l7d82h:
	call sub_7c6ch		;7d82	cd 6c 7c 	. l | 
	ld de,050a0h		;7d85	11 a0 50 	. . P 
	ld a,0a0h		;7d88	3e a0 	> . 
l7d8ah:
	call sub_7c54h		;7d8a	cd 54 7c 	. T | 
	sub 008h		;7d8d	d6 08 	. . 
	cp 010h		;7d8f	fe 10 	. . 
	jr nc,l7d8ah		;7d91	30 f7 	0 . 
	ld hl,04040h		;7d93	21 40 40 	! @ @ 
	call sub_85f5h		;7d96	cd f5 85 	. . . 
	ld b,00dh		;7d99	06 0d 	. . 
	ld hl,(sub_826ch+1)		;7d9b	2a 6d 82 	* m . 
l7d9eh:
	call sub_8235h		;7d9e	cd 35 82 	. 5 . 
	djnz l7d9eh		;7da1	10 fb 	. . 
	call sub_7c61h		;7da3	cd 61 7c 	. a | 
	bit 3,a		;7da6	cb 5f 	. _ 
	jr z,l7d82h		;7da8	28 d8 	( . 
l7daah:
	jr l7d71h		;7daa	18 c5 	. . 
l7dach:
	cp 00ch		;7dac	fe 0c 	. . 
	jr nz,l7dc6h		;7dae	20 16 	  . 
	ld bc,00001h		;7db0	01 01 00 	. . . 
	ld hl,(sub_826ch+1)		;7db3	2a 6d 82 	* m . 
	call sub_721ah		;7db6	cd 1a 72 	. . r 
	call sub_8a24h		;7db9	cd 24 8a 	. $ . 
	jr z,l7d7ch		;7dbc	28 be 	( . 
	call nc,sub_8235h		;7dbe	d4 35 82 	. 5 . 
	ld (sub_826ch+1),hl		;7dc1	22 6d 82 	" m . 
l7dc4h:
	jr l7d7ch		;7dc4	18 b6 	. . 
l7dc6h:
	cp 00eh		;7dc6	fe 0e 	. . 
	jr nz,l7dd8h		;7dc8	20 0e 	  . 
	ld hl,(080ebh)		;7dca	2a eb 80 	* . . 
	ld (080e8h),hl		;7dcd	22 e8 80 	" . . 
	ld hl,(sub_826ch+1)		;7dd0	2a 6d 82 	* m . 
	ld (080ebh),hl		;7dd3	22 eb 80 	" . . 
	jr l7dc4h		;7dd6	18 ec 	. . 
l7dd8h:
	call sub_7e3bh		;7dd8	cd 3b 7e 	. ; ~ 
	jr nz,l7daah		;7ddb	20 cd 	  . 
l7dddh:
	ld hl,05ae0h		;7ddd	21 e0 5a 	! . Z 
	ld bc,0203fh		;7de0	01 3f 20 	. ?   
	call l82e1h		;7de3	cd e1 82 	. . . 
	ld hl,l8affh		;7de6	21 ff 8a 	! . . 
	call sub_85aeh		;7de9	cd ae 85 	. . . 
	ld d,000h		;7dec	16 00 	. . 
	ld c,009h		;7dee	0e 09 	. . 
	cp 080h		;7df0	fe 80 	. . 
	jr c,l7e07h		;7df2	38 13 	8 . 
	ld hl,l7ccfh		;7df4	21 cf 7c 	! . | 
	ld (07e39h),hl		;7df7	22 39 7e 	" 9 ~ 
	push hl			;7dfa	e5 	. 
	ld h,d			;7dfb	62 	b 
	ld l,a			;7dfc	6f 	o 
	ld de,l6fc9h		;7dfd	11 c9 6f 	. . o 
	add hl,hl			;7e00	29 	) 
	add hl,de			;7e01	19 	. 
	ld a,(hl)			;7e02	7e 	~ 
	inc hl			;7e03	23 	# 
	ld h,(hl)			;7e04	66 	f 
	ld l,a			;7e05	6f 	o 
	jp (hl)			;7e06	e9 	. 
l7e07h:
	call sub_7ee7h		;7e07	cd e7 7e 	. . ~ 
	call sub_8245h		;7e0a	cd 45 82 	. E . 
	push hl			;7e0d	e5 	. 
	ld (0896fh),hl		;7e0e	22 6f 89 	" o . 
	ld de,l8b21h		;7e11	11 21 8b 	. ! . 
	ld a,(de)			;7e14	1a 	. 
	ld c,a			;7e15	4f 	O 
	inc de			;7e16	13 	. 
	call sub_8a6ch		;7e17	cd 6c 8a 	. l . 
	pop hl			;7e1a	e1 	. 
	ld (sub_826ch+1),hl		;7e1b	22 6d 82 	" m . 
	ld a,000h		;7e1e	3e 00 	> . 
	or a			;7e20	b7 	. 
	jr z,l7e2fh		;7e21	28 0c 	( . 
	call sub_8232h		;7e23	cd 32 82 	. 2 . 
	ld (sub_826ch+1),hl		;7e26	22 6d 82 	" m . 
	ld bc,00001h		;7e29	01 01 00 	. . . 
	call sub_898ah		;7e2c	cd 8a 89 	. . . 
l7e2fh:
	ld a,00fh		;7e2f	3e 0f 	> . 
	ld (07cffh),a		;7e31	32 ff 7c 	2 . | 
l7e34h:
	xor a			;7e34	af 	. 
	ld (07e1fh),a		;7e35	32 1f 7e 	2 . ~ 
	jp l7ccfh		;7e38	c3 cf 7c 	. . | 
sub_7e3bh:
	ld hl,l8affh		;7e3b	21 ff 8a 	! . . 
	cp 00dh		;7e3e	fe 0d 	. . 
	ret z			;7e40	c8 	. 
	cp 008h		;7e41	fe 08 	. . 
	jr nz,l7e51h		;7e43	20 0c 	  . 
	ld b,(hl)			;7e45	46 	F 
	dec hl			;7e46	2b 	+ 
	ld a,(hl)			;7e47	7e 	~ 
	rlca			;7e48	07 	. 
	jr c,l7e72h		;7e49	38 27 	8 ' 
	ld c,(hl)			;7e4b	4e 	N 
	ld (hl),b			;7e4c	70 	p 
	inc hl			;7e4d	23 	# 
	ld (hl),c			;7e4e	71 	q 
	jr l7e72h		;7e4f	18 21 	. ! 
l7e51h:
	cp 00bh		;7e51	fe 0b 	. . 
	jr nz,l7e5fh		;7e53	20 0a 	  . 
	ld b,(hl)			;7e55	46 	F 
	inc hl			;7e56	23 	# 
	ld a,(hl)			;7e57	7e 	~ 
	and a			;7e58	a7 	. 
	jr z,l7e72h		;7e59	28 17 	( . 
	ld (hl),b			;7e5b	70 	p 
	dec hl			;7e5c	2b 	+ 
	ld (hl),a			;7e5d	77 	w 
	ret			;7e5e	c9 	. 
l7e5fh:
	cp 003h		;7e5f	fe 03 	. . 
	jr nz,l7e74h		;7e61	20 11 	  . 
	ld d,h			;7e63	54 	T 
	ld e,l			;7e64	5d 	] 
	dec hl			;7e65	2b 	+ 
	ld a,(hl)			;7e66	7e 	~ 
	cp 080h		;7e67	fe 80 	. . 
	jr z,l7e72h		;7e69	28 07 	( . 
l7e6bh:
	ld a,(de)			;7e6b	1a 	. 
	ld (hl),a			;7e6c	77 	w 
	inc hl			;7e6d	23 	# 
	inc de			;7e6e	13 	. 
	or a			;7e6f	b7 	. 
	jr nz,l7e6bh		;7e70	20 f9 	  . 
l7e72h:
	inc a			;7e72	3c 	< 
	ret			;7e73	c9 	. 
l7e74h:
	cp 005h		;7e74	fe 05 	. . 
	jr nz,l7e81h		;7e76	20 09 	  . 
	ld hl,0866eh		;7e78	21 6e 86 	! n . 
	ld a,0f7h		;7e7b	3e f7 	> . 
	sub (hl)			;7e7d	96 	. 
	ld (hl),a			;7e7e	77 	w 
	jr l7e72h		;7e7f	18 f1 	. . 
l7e81h:
	cp 020h		;7e81	fe 20 	.   
	ret c			;7e83	d8 	. 
	ld b,a			;7e84	47 	G 
	jr nz,l7each		;7e85	20 25 	  % 
	ld de,l8affh		;7e87	11 ff 8a 	. . . 
	ld a,(de)			;7e8a	1a 	. 
	cp 03bh		;7e8b	fe 3b 	. ; 
	jr z,l7each		;7e8d	28 1d 	( . 
	rlca			;7e8f	07 	. 
	jr c,l7each		;7e90	38 1a 	8 . 
	push hl			;7e92	e5 	. 
	sbc hl,de		;7e93	ed 52 	. R 
	ld a,00dh		;7e95	3e 0d 	> . 
	sub l			;7e97	95 	. 
	pop hl			;7e98	e1 	. 
	jr c,l7each		;7e99	38 11 	8 . 
	cp 005h		;7e9b	fe 05 	. . 
	jr c,l7ea1h		;7e9d	38 02 	8 . 
	sub 005h		;7e9f	d6 05 	. . 
l7ea1h:
	ld b,a			;7ea1	47 	G 
	inc b			;7ea2	04 	. 
	ld c,020h		;7ea3	0e 20 	.   
	call l82e1h		;7ea5	cd e1 82 	. . . 
	ld (hl),001h		;7ea8	36 01 	6 . 
	jr l7e72h		;7eaa	18 c6 	. . 
l7each:
	ld a,001h		;7eac	3e 01 	> . 
	or a			;7eae	b7 	. 
	jr z,l7e72h		;7eaf	28 c1 	( . 
	ld a,b			;7eb1	78 	x 
l7eb2h:
	ex af,af'			;7eb2	08 	. 
	ld a,(hl)			;7eb3	7e 	~ 
	ex af,af'			;7eb4	08 	. 
	ld (hl),a			;7eb5	77 	w 
	cp 0c5h		;7eb6	fe c5 	. . 
	ret z			;7eb8	c8 	. 
	cp 0c8h		;7eb9	fe c8 	. . 
	ret z			;7ebb	c8 	. 
	cp 0cbh		;7ebc	fe cb 	. . 
	ret z			;7ebe	c8 	. 
	cp 0d7h		;7ebf	fe d7 	. . 
	ret z			;7ec1	c8 	. 
	inc hl			;7ec2	23 	# 
	ex af,af'			;7ec3	08 	. 
	or a			;7ec4	b7 	. 
	jr nz,l7eb2h		;7ec5	20 eb 	  . 
	jr l7e72h		;7ec7	18 a9 	. . 
l7ec9h:
	ld ix,l8b24h		;7ec9	dd 21 24 8b 	. ! $ . 
	ld (ix-002h),001h		;7ecd	dd 36 fe 01 	. 6 . . 
	ld (ix-001h),037h		;7ed1	dd 36 ff 37 	. 6 . 7 
	ld b,0ffh		;7ed5	06 ff 	. . 
	jr l7edch		;7ed7	18 03 	. . 
l7ed9h:
	call sub_85adh		;7ed9	cd ad 85 	. . . 
l7edch:
	call sub_8962h		;7edc	cd 62 89 	. b . 
	or a			;7edf	b7 	. 
	jr nz,l7ed9h		;7ee0	20 f7 	  . 
	dec ix		;7ee2	dd 2b 	. + 
	jp l7fefh		;7ee4	c3 ef 7f 	. .  
sub_7ee7h:
	cp 03bh		;7ee7	fe 3b 	. ; 
	jr z,l7ec9h		;7ee9	28 de 	( . 
	cp 020h		;7eeb	fe 20 	.   
	call nz,sub_856fh		;7eed	c4 6f 85 	. o . 
	call sub_85b5h		;7ef0	cd b5 85 	. . . 
	ld de,l8af9h		;7ef3	11 f9 8a 	. . . 
	ld c,005h		;7ef6	0e 05 	. . 
	call sub_856fh		;7ef8	cd 6f 85 	. o . 
	call sub_85b5h		;7efb	cd b5 85 	. . . 
	ld de,l8ae5h		;7efe	11 e5 8a 	. . . 
	ld c,012h		;7f01	0e 12 	. . 
	call sub_8573h		;7f03	cd 73 85 	. s . 
	jr nz,l7f0ch		;7f06	20 04 	  . 
	inc hl			;7f08	23 	# 
	ld (l8af8h),a		;7f09	32 f8 8a 	2 . . 
l7f0ch:
	ld de,l8ad1h		;7f0c	11 d1 8a 	. . . 
	ld c,012h		;7f0f	0e 12 	. . 
	call sub_8577h		;7f11	cd 77 85 	. w . 
	call sub_838bh		;7f14	cd 8b 83 	. . . 
	ld hl,l8af9h		;7f17	21 f9 8a 	! . . 
	ld a,(hl)			;7f1a	7e 	~ 
	or a			;7f1b	b7 	. 
	jr z,l7f2fh		;7f1c	28 11 	( . 
	push hl			;7f1e	e5 	. 
	call sub_851fh		;7f1f	cd 1f 85 	. . . 
	ld hl,l8545h		;7f22	21 45 85 	! E . 
	call sub_8559h		;7f25	cd 59 85 	. Y . 
	pop hl			;7f28	e1 	. 
	call sub_8527h		;7f29	cd 27 85 	. ' . 
	jp c,l807dh		;7f2c	da 7d 80 	. } . 
l7f2fh:
	ld (07f99h),a		;7f2f	32 99 7f 	2 .  
	cp 03ah		;7f32	fe 3a 	. : 
	jr c,l7f3bh		;7f34	38 05 	8 . 
	cp 03eh		;7f36	fe 3e 	. > 
	jp c,l8001h		;7f38	da 01 80 	. . . 
l7f3bh:
	ld hl,l8ae5h		;7f3b	21 e5 8a 	! . . 
	push hl			;7f3e	e5 	. 
	call sub_851fh		;7f3f	cd 1f 85 	. . . 
	pop hl			;7f42	e1 	. 
	ld a,b			;7f43	78 	x 
	dec a			;7f44	3d 	= 
	jr nz,l7f6fh		;7f45	20 28 	  ( 
	ld a,(07f99h)		;7f47	3a 99 7f 	: .  
	cp 006h		;7f4a	fe 06 	. . 
	jr nz,l7f5ch		;7f4c	20 0e 	  . 
	ld a,(hl)			;7f4e	7e 	~ 
	sub 02fh		;7f4f	d6 2f 	. / 
	cp 004h		;7f51	fe 04 	. . 
l7f53h:
	jp nc,l8081h		;7f53	d2 81 80 	. . . 
	or a			;7f56	b7 	. 
	jp z,l8081h		;7f57	ca 81 80 	. . . 
	jr l7f72h		;7f5a	18 16 	. . 
l7f5ch:
	cp 011h		;7f5c	fe 11 	. . 
	jr z,l7f68h		;7f5e	28 08 	( . 
	cp 026h		;7f60	fe 26 	. & 
	jr z,l7f68h		;7f62	28 04 	( . 
	cp 031h		;7f64	fe 31 	. 1 
	jr nz,l7f6fh		;7f66	20 07 	  . 
l7f68h:
	ld a,(hl)			;7f68	7e 	~ 
	sub 02fh		;7f69	d6 2f 	. / 
	cp 009h		;7f6b	fe 09 	. . 
	jr l7f53h		;7f6d	18 e4 	. . 
l7f6fh:
	call sub_84e0h		;7f6f	cd e0 84 	. . . 
l7f72h:
	ld (07f8bh),a		;7f72	32 8b 7f 	2 .  
	ld hl,l8ad1h		;7f75	21 d1 8a 	! . . 
	call sub_84e0h		;7f78	cd e0 84 	. . . 
	ld (07f83h),a		;7f7b	32 83 7f 	2 .  
	xor a			;7f7e	af 	. 
	ld (07fc1h),a		;7f7f	32 c1 7f 	2 .  
	ld a,000h		;7f82	3e 00 	> . 
	call sub_84c3h		;7f84	cd c3 84 	. . . 
	add a,a			;7f87	87 	. 
	add a,a			;7f88	87 	. 
	ld e,a			;7f89	5f 	_ 
	ld a,000h		;7f8a	3e 00 	> . 
	call sub_84c3h		;7f8c	cd c3 84 	. . . 
	ld d,a			;7f8f	57 	W 
	ld b,003h		;7f90	06 03 	. . 
l7f92h:
	sla e		;7f92	cb 23 	. # 
	rl d		;7f94	cb 12 	. . 
	djnz l7f92h		;7f96	10 fa 	. . 
	ld a,000h		;7f98	3e 00 	> . 
	rla			;7f9a	17 	. 
	ld hl,l8ea1h		;7f9b	21 a1 8e 	! . . 
	ld bc,002afh		;7f9e	01 af 02 	. . . 
l7fa1h:
	inc hl			;7fa1	23 	# 
	ex af,af'			;7fa2	08 	. 
l7fa3h:
	inc hl			;7fa3	23 	# 
	ex af,af'			;7fa4	08 	. 
	inc hl			;7fa5	23 	# 
	inc hl			;7fa6	23 	# 
	cpi		;7fa7	ed a1 	. . 
	jp po,l8098h		;7fa9	e2 98 80 	. . . 
	jr nz,l7fa1h		;7fac	20 f3 	  . 
	ex af,af'			;7fae	08 	. 
	ld a,(hl)			;7faf	7e 	~ 
	inc hl			;7fb0	23 	# 
	cp d			;7fb1	ba 	. 
	jr nz,l7fa3h		;7fb2	20 ef 	  . 
	ld a,(hl)			;7fb4	7e 	~ 
	and 0e0h		;7fb5	e6 e0 	. . 
	cp e			;7fb7	bb 	. 
	jr nz,l7fa3h		;7fb8	20 e9 	  . 
	dec hl			;7fba	2b 	+ 
	dec hl			;7fbb	2b 	+ 
	dec hl			;7fbc	2b 	+ 
	ld d,(hl)			;7fbd	56 	V 
	dec hl			;7fbe	2b 	+ 
	ld e,(hl)			;7fbf	5e 	^ 
	ld a,000h		;7fc0	3e 00 	> . 
	or a			;7fc2	b7 	. 
	jr z,l7fc9h		;7fc3	28 04 	( . 
	res 5,d		;7fc5	cb aa 	. . 
	set 4,d		;7fc7	cb e2 	. . 
l7fc9h:
	call sub_82e6h		;7fc9	cd e6 82 	. . . 
	ld a,(07f8bh)		;7fcc	3a 8b 7f 	: .  
	cp 02ch		;7fcf	fe 2c 	. , 
	ld de,l8ae5h		;7fd1	11 e5 8a 	. . . 
	call nc,sub_83a0h		;7fd4	d4 a0 83 	. . . 
	ld a,(07f83h)		;7fd7	3a 83 7f 	: .  
	jr c,l7fe7h		;7fda	38 0b 	8 . 
	cp 02ch		;7fdc	fe 2c 	. , 
	jr c,l7fefh		;7fde	38 0f 	8 . 
	ld (ix+000h),01fh		;7fe0	dd 36 00 1f 	. 6 . . 
	inc ix		;7fe4	dd 23 	. # 
	inc b			;7fe6	04 	. 
l7fe7h:
	ld de,l8ad1h		;7fe7	11 d1 8a 	. . . 
	cp 02ch		;7fea	fe 2c 	. , 
	call nc,sub_83a0h		;7fec	d4 a0 83 	. . . 
l7fefh:
	ld a,b			;7fef	78 	x 
	or a			;7ff0	b7 	. 
	jr z,l7ffbh		;7ff1	28 08 	( . 
	set 7,b		;7ff3	cb f8 	. . 
	set 6,b		;7ff5	cb f0 	. . 
	ld (ix+000h),b		;7ff7	dd 70 00 	. p . 
	inc a			;7ffa	3c 	< 
l7ffbh:
	add a,002h		;7ffb	c6 02 	. . 
	ld (l8b21h),a		;7ffd	32 21 8b 	2 ! . 
	ret			;8000	c9 	. 
l8001h:
	push af			;8001	f5 	. 
	sub 034h		;8002	d6 34 	. 4 
	ld e,a			;8004	5f 	_ 
	ld d,037h		;8005	16 37 	. 7 
	call sub_82e6h		;8007	cd e6 82 	. . . 
	push bc			;800a	c5 	. 
	ld hl,l8ae4h		;800b	21 e4 8a 	! . . 
	xor a			;800e	af 	. 
	ld c,a			;800f	4f 	O 
l8010h:
	inc hl			;8010	23 	# 
	inc c			;8011	0c 	. 
	cp (hl)			;8012	be 	. 
	jr nz,l8010h		;8013	20 fb 	  . 
	ld de,l8ad1h		;8015	11 d1 8a 	. . . 
	ld a,(de)			;8018	1a 	. 
	or a			;8019	b7 	. 
	jr z,l8020h		;801a	28 04 	( . 
	ld (hl),02ch		;801c	36 2c 	6 , 
	inc hl			;801e	23 	# 
	xor a			;801f	af 	. 
l8020h:
	ex de,hl			;8020	eb 	. 
l8021h:
	cp (hl)			;8021	be 	. 
l8022h:
	jr z,l802ah		;8022	28 06 	( . 
	ldi		;8024	ed a0 	. . 
	inc c			;8026	0c 	. 
	inc c			;8027	0c 	. 
	jr l8021h		;8028	18 f7 	. . 
l802ah:
	ld a,012h		;802a	3e 12 	> . 
	cp c			;802c	b9 	. 
	jr c,l8089h		;802d	38 5a 	8 Z 
	pop bc			;802f	c1 	. 
	pop af			;8030	f1 	. 
	cp 03bh		;8031	fe 3b 	. ; 
	jr z,l804ah		;8033	28 15 	( . 
	ld de,l8ae5h		;8035	11 e5 8a 	. . . 
l8038h:
	ld a,02ch		;8038	3e 2c 	> , 
	call sub_83a0h		;803a	cd a0 83 	. . . 
	ld a,(de)			;803d	1a 	. 
	or a			;803e	b7 	. 
l803fh:
	jr z,l7fefh		;803f	28 ae 	( . 
	ld (ix+000h),02ch		;8041	dd 36 00 2c 	. 6 . , 
	inc ix		;8045	dd 23 	. # 
	inc b			;8047	04 	. 
	jr l8038h		;8048	18 ee 	. . 
l804ah:
	ld hl,l8ae5h		;804a	21 e5 8a 	! . . 
	call sub_808dh		;804d	cd 8d 80 	. . . 
	call sub_8962h		;8050	cd 62 89 	. b . 
sub_8053h:
	inc hl			;8053	23 	# 
	ld a,(hl)			;8054	7e 	~ 
	call sub_8962h		;8055	cd 62 89 	. b . 
	inc hl			;8058	23 	# 
	ld a,(hl)			;8059	7e 	~ 
l805ah:
	call sub_8962h		;805a	cd 62 89 	. b . 
	inc hl			;805d	23 	# 
	ld a,(hl)			;805e	7e 	~ 
	or a			;805f	b7 	. 
	jr nz,l805ah		;8060	20 f8 	  . 
	dec hl			;8062	2b 	+ 
	call sub_808dh		;8063	cd 8d 80 	. . . 
	jr l803fh		;8066	18 d7 	. . 
sub_8068h:
	push hl			;8068	e5 	. 
	push de			;8069	d5 	. 
	ld hl,(l8819h+1)		;806a	2a 1a 88 	* . . 
	add hl,bc			;806d	09 	. 
	jr c,l8079h		;806e	38 09 	8 . 
	ld de,(l7945h+1)		;8070	ed 5b 46 79 	. [ F y 
	sbc hl,de		;8074	ed 52 	. R 
	pop de			;8076	d1 	. 
	pop hl			;8077	e1 	. 
	ret c			;8078	d8 	. 
l8079h:
	ld a,007h		;8079	3e 07 	> . 
	jr l809ah		;807b	18 1d 	. . 
l807dh:
	ld a,001h		;807d	3e 01 	> . 
	jr l809ah		;807f	18 19 	. . 
l8081h:
	ld a,002h		;8081	3e 02 	> . 
	jr l809ah		;8083	18 15 	. . 
l8085h:
	ld a,003h		;8085	3e 03 	> . 
	jr l809ah		;8087	18 11 	. . 
l8089h:
	ld a,004h		;8089	3e 04 	> . 
	jr l809ah		;808b	18 0d 	. . 
sub_808dh:
	ld a,(hl)			;808d	7e 	~ 
	cp 027h		;808e	fe 27 	. ' 
	ret z			;8090	c8 	. 
	cp 022h		;8091	fe 22 	. " 
	ret z			;8093	c8 	. 
l8094h:
	ld a,005h		;8094	3e 05 	> . 
	jr l809ah		;8096	18 02 	. . 
l8098h:
	ld a,006h		;8098	3e 06 	> . 
l809ah:
	ex af,af'			;809a	08 	. 
	call sub_8713h		;809b	cd 13 87 	. . . 
	ex af,af'			;809e	08 	. 
	call l89f4h		;809f	cd f4 89 	. . . 
l80a2h:
	call l82dbh		;80a2	cd db 82 	. . . 
	ld hl,(sub_826ch+1)		;80a5	2a 6d 82 	* m . 
	call sub_8a2fh		;80a8	cd 2f 8a 	. / . 
	call z,sub_8235h		;80ab	cc 35 82 	. 5 . 
	ld (sub_826ch+1),hl		;80ae	22 6d 82 	" m . 
	jp l7ceeh		;80b1	c3 ee 7c 	. . | 
sub_80b4h:
	ld hl,04000h		;80b4	21 00 40 	! . @ 
sub_80b7h:
	call sub_85f5h		;80b7	cd f5 85 	. . . 
	cp 009h		;80ba	fe 09 	. . 
	jr nz,l80cch		;80bc	20 0e 	  . 
	push af			;80be	f5 	. 
	ld hl,l80e1h		;80bf	21 e1 80 	! . . 
	call sub_80d7h		;80c2	cd d7 80 	. . . 
	ld hl,l80e1h		;80c5	21 e1 80 	! . . 
	ld (080c0h),hl		;80c8	22 c0 80 	" . . 
	pop af			;80cb	f1 	. 
l80cch:
	ld hl,08ba1h		;80cc	21 a1 8b 	! . . 
l80cfh:
	bit 7,(hl)		;80cf	cb 7e 	. ~ 
	inc hl			;80d1	23 	# 
	jr z,l80cfh		;80d2	28 fb 	( . 
	dec a			;80d4	3d 	= 
	jr nz,l80cfh		;80d5	20 f8 	  . 
sub_80d7h:
	ld a,(hl)			;80d7	7e 	~ 
	call sub_8767h		;80d8	cd 67 87 	. g . 
	bit 7,(hl)		;80db	cb 7e 	. ~ 
	inc hl			;80dd	23 	# 
	jr z,sub_80d7h		;80de	28 f7 	( . 
	ret			;80e0	c9 	. 
l80e1h:
	ld d,e			;80e1	53 	S 
	ld a,c			;80e2	79 	y 
	ld l,l			;80e3	6d 	m 
	ld h,d			;80e4	62 	b 
	ld l,a			;80e5	6f 	o 
	call pe,02821h		;80e6	ec 21 28 	. ! ( 
	sbc a,h			;80e9	9c 	. 
	ld de,l9c27h+1		;80ea	11 28 9c 	. ( . 
	push hl			;80ed	e5 	. 
	xor a			;80ee	af 	. 
	sbc hl,de		;80ef	ed 52 	. R 
	pop hl			;80f1	e1 	. 
	ret c			;80f2	d8 	. 
	ex de,hl			;80f3	eb 	. 
	ret			;80f4	c9 	. 
sub_80f5h:
	exx			;80f5	d9 	. 
	push ix		;80f6	dd e5 	. . 
	call 080e7h		;80f8	cd e7 80 	. . . 
	ld b,h			;80fb	44 	D 
	ld c,l			;80fc	4d 	M 
	pop hl			;80fd	e1 	. 
	push hl			;80fe	e5 	. 
	xor a			;80ff	af 	. 
	sbc hl,bc		;8100	ed 42 	. B 
	pop hl			;8102	e1 	. 
	jr c,l8108h		;8103	38 03 	8 . 
	ex de,hl			;8105	eb 	. 
	sbc hl,de		;8106	ed 52 	. R 
l8108h:
	exx			;8108	d9 	. 
	ret			;8109	c9 	. 
sub_810ah:
	inc ix		;810a	dd 23 	. # 
sub_810ch:
	ld d,(ix+002h)		;810c	dd 56 02 	. V . 
	ld e,(ix+003h)		;810f	dd 5e 03 	. ^ . 
	ret			;8112	c9 	. 
sub_8113h:
	call sub_810ch		;8113	cd 0c 81 	. . . 
sub_8116h:
	ld hl,(087d7h)		;8116	2a d7 87 	* . . 
	push hl			;8119	e5 	. 
	res 7,d		;811a	cb ba 	. . 
	add hl,de			;811c	19 	. 
	add hl,de			;811d	19 	. 
	ld e,(hl)			;811e	5e 	^ 
	inc hl			;811f	23 	# 
	ld a,(hl)			;8120	7e 	~ 
	and 03fh		;8121	e6 3f 	. ? 
	ld d,a			;8123	57 	W 
	ex (sp),hl			;8124	e3 	. 
	push hl			;8125	e5 	. 
	ex de,hl			;8126	eb 	. 
	ex (sp),hl			;8127	e3 	. 
	ld e,(hl)			;8128	5e 	^ 
	inc hl			;8129	23 	# 
	ld d,(hl)			;812a	56 	V 
	inc hl			;812b	23 	# 
	ex de,hl			;812c	eb 	. 
	inc hl			;812d	23 	# 
	add hl,hl			;812e	29 	) 
	add hl,de			;812f	19 	. 
	pop de			;8130	d1 	. 
	add hl,de			;8131	19 	. 
	ex de,hl			;8132	eb 	. 
	pop hl			;8133	e1 	. 
	ret			;8134	c9 	. 
sub_8135h:
	ld hl,l8aa5h		;8135	21 a5 8a 	! . . 
sub_8138h:
	push hl			;8138	e5 	. 
	ld bc,02000h		;8139	01 00 20 	. .   
	call l82e1h		;813c	cd e1 82 	. . . 
	pop hl			;813f	e1 	. 
	ld a,(ix+000h)		;8140	dd 7e 00 	. ~ . 
	dec a			;8143	3d 	= 
	jr nz,l815bh		;8144	20 15 	  . 
	ld a,(ix+001h)		;8146	dd 7e 01 	. ~ . 
	cp 037h		;8149	fe 37 	. 7 
	jr nz,l815bh		;814b	20 0e 	  . 
l814dh:
	ld a,(ix+002h)		;814d	dd 7e 02 	. ~ . 
	cp 0c0h		;8150	fe c0 	. . 
	ld (hl),001h		;8152	36 01 	6 . 
	ret nc			;8154	d0 	. 
	inc ix		;8155	dd 23 	. # 
	ld (hl),a			;8157	77 	w 
	inc hl			;8158	23 	# 
	jr l814dh		;8159	18 f2 	. . 
l815bh:
	ld b,009h		;815b	06 09 	. . 
	bit 3,(ix+001h)		;815d	dd cb 01 5e 	. . . ^ 
	call z,sub_82d7h		;8161	cc d7 82 	. . . 
	jr z,l8170h		;8164	28 0a 	( . 
	push hl			;8166	e5 	. 
	call sub_8113h		;8167	cd 13 81 	. . . 
	pop hl			;816a	e1 	. 
	ld b,009h		;816b	06 09 	. . 
	call sub_82d4h		;816d	cd d4 82 	. . . 
l8170h:
	push hl			;8170	e5 	. 
	ld b,(ix+000h)		;8171	dd 46 00 	. F . 
	ld a,(ix+001h)		;8174	dd 7e 01 	. ~ . 
	and 0f0h		;8177	e6 f0 	. . 
	ld c,a			;8179	4f 	O 
	call sub_831ch		;817a	cd 1c 83 	. . . 
	pop hl			;817d	e1 	. 
	jr z,l8186h		;817e	28 06 	( . 
	ld a,010h		;8180	3e 10 	> . 
	ld (07cffh),a		;8182	32 ff 7c 	2 . | 
	ret			;8185	c9 	. 
l8186h:
	ld (hl),001h		;8186	36 01 	6 . 
	or a			;8188	b7 	. 
	ret z			;8189	c8 	. 
	cp 03ah		;818a	fe 3a 	. : 
	jr c,l8194h		;818c	38 06 	8 . 
	cp 03eh		;818e	fe 3e 	. > 
	jr nc,l8194h		;8190	30 02 	0 . 
	ld d,02ch		;8192	16 2c 	. , 
l8194h:
	push de			;8194	d5 	. 
	ld de,l8c76h		;8195	11 76 8c 	. v . 
	call sub_82c9h		;8198	cd c9 82 	. . . 
	ld b,005h		;819b	06 05 	. . 
	call sub_82d4h		;819d	cd d4 82 	. . . 
	pop de			;81a0	d1 	. 
	ld (hl),001h		;81a1	36 01 	6 . 
	inc hl			;81a3	23 	# 
	bit 3,(ix+001h)		;81a4	dd cb 01 5e 	. . . ^ 
	jr z,l81aeh		;81a8	28 04 	( . 
	inc ix		;81aa	dd 23 	. # 
	inc ix		;81ac	dd 23 	. # 
l81aeh:
	push de			;81ae	d5 	. 
	ld a,d			;81af	7a 	z 
	call sub_81bah		;81b0	cd ba 81 	. . . 
	pop de			;81b3	d1 	. 
	ld a,e			;81b4	7b 	{ 
	or a			;81b5	b7 	. 
	ret z			;81b6	c8 	. 
	ld (hl),02ch		;81b7	36 2c 	6 , 
	inc hl			;81b9	23 	# 
sub_81bah:
	or a			;81ba	b7 	. 
	ret z			;81bb	c8 	. 
	cp 02ch		;81bc	fe 2c 	. , 
	jr nc,l81deh		;81be	30 1e 	0 . 
	ld de,l8db4h		;81c0	11 b4 8d 	. . . 
	call sub_82c9h		;81c3	cd c9 82 	. . . 
sub_81c6h:
	ld b,009h		;81c6	06 09 	. . 
l81c8h:
	ld a,(de)			;81c8	1a 	. 
	and 07fh		;81c9	e6 7f 	.  
	ld (hl),a			;81cb	77 	w 
	dec b			;81cc	05 	. 
	jr nz,l81d6h		;81cd	20 07 	  . 
	ld a,010h		;81cf	3e 10 	> . 
	ld (07cffh),a		;81d1	32 ff 7c 	2 . | 
	pop af			;81d4	f1 	. 
	ret			;81d5	c9 	. 
l81d6h:
	ld a,(de)			;81d6	1a 	. 
	and 080h		;81d7	e6 80 	. . 
	inc hl			;81d9	23 	# 
	inc de			;81da	13 	. 
	jr z,l81c8h		;81db	28 eb 	( . 
	ret			;81dd	c9 	. 
l81deh:
	push af			;81de	f5 	. 
	cp 02dh		;81df	fe 2d 	. - 
	jr c,l8201h		;81e1	38 1e 	8 . 
	ld (hl),028h		;81e3	36 28 	6 ( 
	inc hl			;81e5	23 	# 
	cp 02eh		;81e6	fe 2e 	. . 
	jr c,l8201h		;81e8	38 17 	8 . 
	ld (hl),069h		;81ea	36 69 	6 i 
	inc hl			;81ec	23 	# 
	ld b,078h		;81ed	06 78 	. x 
	cp 02fh		;81ef	fe 2f 	. / 
	jr c,l81f5h		;81f1	38 02 	8 . 
	ld b,079h		;81f3	06 79 	. y 
l81f5h:
	ld (hl),b			;81f5	70 	p 
	inc hl			;81f6	23 	# 
	ld a,(ix+002h)		;81f7	dd 7e 02 	. ~ . 
	cp 02dh		;81fa	fe 2d 	. - 
	jr z,l8201h		;81fc	28 03 	( . 
	ld (hl),02bh		;81fe	36 2b 	6 + 
	inc hl			;8200	23 	# 
l8201h:
	ld a,(ix+002h)		;8201	dd 7e 02 	. ~ . 
	cp 01fh		;8204	fe 1f 	. . 
	jr z,l8228h		;8206	28 20 	(   
	cp 0c0h		;8208	fe c0 	. . 
	jr nc,l8228h		;820a	30 1c 	0 . 
	cp 080h		;820c	fe 80 	. . 
	jr nc,l8216h		;820e	30 06 	0 . 
	ld (hl),a			;8210	77 	w 
	inc hl			;8211	23 	# 
	inc ix		;8212	dd 23 	. # 
	jr l8201h		;8214	18 eb 	. . 
l8216h:
	ld d,a			;8216	57 	W 
	ld e,(ix+003h)		;8217	dd 5e 03 	. ^ . 
	inc ix		;821a	dd 23 	. # 
	inc ix		;821c	dd 23 	. # 
	push hl			;821e	e5 	. 
	call sub_8116h		;821f	cd 16 81 	. . . 
	pop hl			;8222	e1 	. 
	call sub_81c6h		;8223	cd c6 81 	. . . 
	jr l8201h		;8226	18 d9 	. . 
l8228h:
	pop af			;8228	f1 	. 
	inc ix		;8229	dd 23 	. # 
	cp 02dh		;822b	fe 2d 	. - 
	ret c			;822d	d8 	. 
	ld (hl),029h		;822e	36 29 	6 ) 
	inc hl			;8230	23 	# 
	ret			;8231	c9 	. 
sub_8232h:
	ld hl,(sub_826ch+1)		;8232	2a 6d 82 	* m . 
sub_8235h:
	dec hl			;8235	2b 	+ 
	ld a,(hl)			;8236	7e 	~ 
	cp 0c0h		;8237	fe c0 	. . 
	jr c,l8243h		;8239	38 08 	8 . 
	and 03fh		;823b	e6 3f 	. ? 
	ld e,a			;823d	5f 	_ 
	ld d,000h		;823e	16 00 	. . 
	sbc hl,de		;8240	ed 52 	. R 
	dec hl			;8242	2b 	+ 
l8243h:
	dec hl			;8243	2b 	+ 
	ret			;8244	c9 	. 
sub_8245h:
	ld hl,(sub_826ch+1)		;8245	2a 6d 82 	* m . 
sub_8248h:
	inc hl			;8248	23 	# 
	ld a,(hl)			;8249	7e 	~ 
	inc hl			;824a	23 	# 
	bit 3,a		;824b	cb 5f 	. _ 
	jr z,l8253h		;824d	28 04 	( . 
	inc hl			;824f	23 	# 
	inc hl			;8250	23 	# 
	jr l8256h		;8251	18 03 	. . 
l8253h:
	and 007h		;8253	e6 07 	. . 
	ret z			;8255	c8 	. 
l8256h:
	ld a,(hl)			;8256	7e 	~ 
	inc hl			;8257	23 	# 
	cp 0c0h		;8258	fe c0 	. . 
	ret nc			;825a	d0 	. 
	cp 080h		;825b	fe 80 	. . 
	jr c,l8256h		;825d	38 f7 	8 . 
	inc hl			;825f	23 	# 
	jr l8256h		;8260	18 f4 	. . 
sub_8262h:
	xor a			;8262	af 	. 
	in a,(0feh)		;8263	db fe 	. . 
	cpl			;8265	2f 	/ 
	and 01fh		;8266	e6 1f 	. . 
	ret z			;8268	c8 	. 
	call sub_7bbch		;8269	cd bc 7b 	. . { 
sub_826ch:
	ld hl,l9c27h+1		;826c	21 28 9c 	! ( . 
	ld b,00dh		;826f	06 0d 	. . 
l8271h:
	call sub_8235h		;8271	cd 35 82 	. 5 . 
	djnz l8271h		;8274	10 fb 	. . 
	ld a,010h		;8276	3e 10 	> . 
l8278h:
	push af			;8278	f5 	. 
	push hl			;8279	e5 	. 
	push hl			;827a	e5 	. 
	call sub_85f0h		;827b	cd f0 85 	. . . 
	pop ix		;827e	dd e1 	. . 
	call sub_828fh		;8280	cd 8f 82 	. . . 
	pop hl			;8283	e1 	. 
	call sub_8248h		;8284	cd 48 82 	. H . 
	pop af			;8287	f1 	. 
	add a,008h		;8288	c6 08 	. . 
	cp 0a9h		;828a	fe a9 	. . 
	jr c,l8278h		;828c	38 ea 	8 . 
	ret			;828e	c9 	. 
sub_828fh:
	push ix		;828f	dd e5 	. . 
	call sub_8135h		;8291	cd 35 81 	. 5 . 
	pop ix		;8294	dd e1 	. . 
	call sub_80f5h		;8296	cd f5 80 	. . . 
	jr c,l82a0h		;8299	38 05 	8 . 
	ld hl,l8aadh		;829b	21 ad 8a 	! . . 
	ld (hl),003h		;829e	36 03 	6 . 
l82a0h:
	ld hl,sub_8744h		;82a0	21 44 87 	! D . 
sub_82a3h:
	ld (l82c4h+1),hl		;82a3	22 c5 82 	" . . 
	ld hl,l8aa5h		;82a6	21 a5 8a 	! . . 
	ld c,000h		;82a9	0e 00 	. . 
l82abh:
	ld a,(hl)			;82ab	7e 	~ 
	inc hl			;82ac	23 	# 
	dec a			;82ad	3d 	= 
	jr z,l82abh		;82ae	28 fb 	( . 
	inc a			;82b0	3c 	< 
	ret z			;82b1	c8 	. 
	cp 022h		;82b2	fe 22 	. " 
	jr nz,l82b9h		;82b4	20 03 	  . 
	inc c			;82b6	0c 	. 
	ld a,022h		;82b7	3e 22 	> " 
l82b9h:
	bit 0,c		;82b9	cb 41 	. A 
	jr nz,l82c4h		;82bb	20 07 	  . 
	call sub_872eh		;82bd	cd 2e 87 	. . . 
	jr nz,l82c4h		;82c0	20 02 	  . 
	and 0ffh		;82c2	e6 ff 	. . 
l82c4h:
	call sub_8744h		;82c4	cd 44 87 	. D . 
	jr l82abh		;82c7	18 e2 	. . 
sub_82c9h:
	push hl			;82c9	e5 	. 
	ex de,hl			;82ca	eb 	. 
	ld d,000h		;82cb	16 00 	. . 
	ld e,a			;82cd	5f 	_ 
	add hl,de			;82ce	19 	. 
	ld e,(hl)			;82cf	5e 	^ 
	add hl,de			;82d0	19 	. 
	ex de,hl			;82d1	eb 	. 
	pop hl			;82d2	e1 	. 
	ret			;82d3	c9 	. 
sub_82d4h:
	call l81c8h		;82d4	cd c8 81 	. . . 
sub_82d7h:
	ld c,020h		;82d7	0e 20 	.   
	jr l82e1h		;82d9	18 06 	. . 
l82dbh:
	ld bc,03700h		;82db	01 00 37 	. . 7 
	ld hl,l8ac7h		;82de	21 c7 8a 	! . . 
l82e1h:
	ld (hl),c			;82e1	71 	q 
	inc hl			;82e2	23 	# 
	djnz l82e1h		;82e3	10 fc 	. . 
	ret			;82e5	c9 	. 
sub_82e6h:
	ld b,000h		;82e6	06 00 	. . 
	ld hl,l8affh		;82e8	21 ff 8a 	! . . 
	call sub_85aeh		;82eb	cd ae 85 	. . . 
	cp 041h		;82ee	fe 41 	. A 
	jr c,l82f4h		;82f0	38 02 	8 . 
	set 3,d		;82f2	cb da 	. . 
l82f4h:
	ld (l8b22h),de		;82f4	ed 53 22 8b 	. S " . 
	push af			;82f8	f5 	. 
	ld a,e			;82f9	7b 	{ 
	cp 003h		;82fa	fe 03 	. . 
	jr nz,l8304h		;82fc	20 06 	  . 
	ld a,d			;82fe	7a 	z 
	cp 037h		;82ff	fe 37 	. 7 
	jp z,l8098h		;8301	ca 98 80 	. . . 
l8304h:
	pop af			;8304	f1 	. 
	ld ix,l8b24h		;8305	dd 21 24 8b 	. ! $ . 
	ret c			;8309	d8 	. 
	call sub_8815h		;830a	cd 15 88 	. . . 
	ld ix,l8b26h		;830d	dd 21 26 8b 	. ! & . 
	set 7,h		;8311	cb fc 	. . 
	ld (ix-002h),h		;8313	dd 74 fe 	. t . 
	ld (ix-001h),l		;8316	dd 75 ff 	. u . 
	ld b,002h		;8319	06 02 	. . 
	ret			;831b	c9 	. 
sub_831ch:
	ld de,00352h		;831c	11 52 03 	. R . 
	ld a,001h		;831f	3e 01 	> . 
	bit 5,c		;8321	cb 69 	. i 
	jr nz,l832eh		;8323	20 09 	  . 
	bit 4,c		;8325	cb 61 	. a 
	jr z,l832eh		;8327	28 05 	( . 
	dec a			;8329	3d 	= 
	res 4,c		;832a	cb a1 	. . 
	set 5,c		;832c	cb e9 	. . 
l832eh:
	ld (08374h),a		;832e	32 74 83 	2 t . 
	ld hl,l9556h		;8331	21 56 95 	! V . 
	exx			;8334	d9 	. 
	ld b,00bh		;8335	06 0b 	. . 
l8337h:
	exx			;8337	d9 	. 
	ld a,(hl)			;8338	7e 	~ 
	cp b			;8339	b8 	. 
	jr nz,l8344h		;833a	20 08 	  . 
	inc hl			;833c	23 	# 
	ld a,(hl)			;833d	7e 	~ 
	dec hl			;833e	2b 	+ 
	and 0f0h		;833f	e6 f0 	. . 
	cp c			;8341	b9 	. 
	jr z,l835ah		;8342	28 16 	( . 
l8344h:
	jr c,l834ah		;8344	38 04 	8 . 
	sbc hl,de		;8346	ed 52 	. R 
	jr l834bh		;8348	18 01 	. . 
l834ah:
	add hl,de			;834a	19 	. 
l834bh:
	srl d		;834b	cb 3a 	. : 
	rr e		;834d	cb 1b 	. . 
	jr nc,l8354h		;834f	30 03 	0 . 
	inc de			;8351	13 	. 
	inc de			;8352	13 	. 
	inc de			;8353	13 	. 
l8354h:
	exx			;8354	d9 	. 
	djnz l8337h		;8355	10 e0 	. . 
	inc b			;8357	04 	. 
	exx			;8358	d9 	. 
	ret			;8359	c9 	. 
l835ah:
	inc hl			;835a	23 	# 
	inc hl			;835b	23 	# 
	ld a,(hl)			;835c	7e 	~ 
	inc hl			;835d	23 	# 
	ld d,(hl)			;835e	56 	V 
	inc hl			;835f	23 	# 
	ld e,(hl)			;8360	5e 	^ 
	srl a		;8361	cb 3f 	. ? 
	ld b,003h		;8363	06 03 	. . 
	rr d		;8365	cb 1a 	. . 
	jr l836bh		;8367	18 02 	. . 
l8369h:
	srl d		;8369	cb 3a 	. : 
l836bh:
	rr e		;836b	cb 1b 	. . 
	djnz l8369h		;836d	10 fa 	. . 
	srl e		;836f	cb 3b 	. ; 
	srl e		;8371	cb 3b 	. ; 
	ld b,001h		;8373	06 01 	. . 
	dec b			;8375	05 	. 
	ret z			;8376	c8 	. 
	push af			;8377	f5 	. 
	ld a,e			;8378	7b 	{ 
	inc a			;8379	3c 	< 
	call sub_84c3h		;837a	cd c3 84 	. . . 
	jr nz,l8380h		;837d	20 01 	  . 
	inc e			;837f	1c 	. 
l8380h:
	ld a,d			;8380	7a 	z 
	inc a			;8381	3c 	< 
	call sub_84c3h		;8382	cd c3 84 	. . . 
	jr nz,l8388h		;8385	20 01 	  . 
	inc d			;8387	14 	. 
l8388h:
	pop af			;8388	f1 	. 
	cp a			;8389	bf 	. 
	ret			;838a	c9 	. 
sub_838bh:
	ld hl,l8ad1h		;838b	21 d1 8a 	! . . 
	ld b,028h		;838e	06 28 	. ( 
	ld c,001h		;8390	0e 01 	. . 
	xor a			;8392	af 	. 
l8393h:
	cp (hl)			;8393	be 	. 
	inc hl			;8394	23 	# 
	jr z,l8398h		;8395	28 01 	( . 
	inc c			;8397	0c 	. 
l8398h:
	djnz l8393h		;8398	10 f9 	. . 
	ld a,012h		;839a	3e 12 	> . 
	cp c			;839c	b9 	. 
	jr c,l83aeh		;839d	38 0f 	8 . 
	ret			;839f	c9 	. 
sub_83a0h:
	cp 02ch		;83a0	fe 2c 	. , 
	jr z,l83abh		;83a2	28 07 	( . 
	inc de			;83a4	13 	. 
	cp 02dh		;83a5	fe 2d 	. - 
	jr z,l83abh		;83a7	28 02 	( . 
	inc de			;83a9	13 	. 
	inc de			;83aa	13 	. 
l83abh:
	call sub_8492h		;83ab	cd 92 84 	. . . 
l83aeh:
	jp c,l8089h		;83ae	da 89 80 	. . . 
	cp 02bh		;83b1	fe 2b 	. + 
	jr z,l83bch		;83b3	28 07 	( . 
	cp 02dh		;83b5	fe 2d 	. - 
	jr nz,l83c1h		;83b7	20 08 	  . 
	call sub_8962h		;83b9	cd 62 89 	. b . 
l83bch:
	call sub_8492h		;83bc	cd 92 84 	. . . 
	jr c,l83aeh		;83bf	38 ed 	8 . 
l83c1h:
	cp 024h		;83c1	fe 24 	. $ 
	jr nz,l83cah		;83c3	20 05 	  . 
	call sub_848fh		;83c5	cd 8f 84 	. . . 
	jr l83fdh		;83c8	18 33 	. 3 
l83cah:
	ld c,a			;83ca	4f 	O 
	or 020h		;83cb	f6 20 	.   
	call sub_872eh		;83cd	cd 2e 87 	. . . 
	jr nz,l83f9h		;83d0	20 27 	  ' 
	push bc			;83d2	c5 	. 
	dec de			;83d3	1b 	. 
	push de			;83d4	d5 	. 
	push ix		;83d5	dd e5 	. . 
	ex de,hl			;83d7	eb 	. 
	call sub_8815h		;83d8	cd 15 88 	. . . 
	pop ix		;83db	dd e1 	. . 
	set 7,h		;83dd	cb fc 	. . 
	ld (ix+000h),h		;83df	dd 74 00 	. t . 
	inc ix		;83e2	dd 23 	. # 
	ld (ix+000h),l		;83e4	dd 75 00 	. u . 
	inc ix		;83e7	dd 23 	. # 
	pop bc			;83e9	c1 	. 
	ld hl,(l8ac7h)		;83ea	2a c7 8a 	* . . 
	ld h,000h		;83ed	26 00 	& . 
	add hl,bc			;83ef	09 	. 
	ex de,hl			;83f0	eb 	. 
	pop bc			;83f1	c1 	. 
	inc b			;83f2	04 	. 
	inc b			;83f3	04 	. 
	call sub_8492h		;83f4	cd 92 84 	. . . 
	jr l83fdh		;83f7	18 04 	. . 
l83f9h:
	ld a,c			;83f9	79 	y 
	call sub_8419h		;83fa	cd 19 84 	. . . 
l83fdh:
	ccf			;83fd	3f 	? 
	ret nc			;83fe	d0 	. 
	cp 02bh		;83ff	fe 2b 	. + 
	jr z,l8414h		;8401	28 11 	( . 
	cp 02dh		;8403	fe 2d 	. - 
	jr z,l8414h		;8405	28 0d 	( . 
	cp 02ah		;8407	fe 2a 	. * 
	jr z,l8414h		;8409	28 09 	( . 
	cp 02fh		;840b	fe 2f 	. / 
	jr z,l8414h		;840d	28 05 	( . 
	cp 03fh		;840f	fe 3f 	. ? 
l8411h:
	jp nz,l8089h		;8411	c2 89 80 	. . . 
l8414h:
	call sub_848fh		;8414	cd 8f 84 	. . . 
	jr l83aeh		;8417	18 95 	. . 
sub_8419h:
	cp 022h		;8419	fe 22 	. " 
	jr z,l845fh		;841b	28 42 	( B 
	ld c,00ah		;841d	0e 0a 	. . 
	call sub_8726h		;841f	cd 26 87 	. & . 
	jr z,l8438h		;8422	28 14 	( . 
	cp 025h		;8424	fe 25 	. % 
	jr nz,l842ch		;8426	20 04 	  . 
	ld c,002h		;8428	0e 02 	. . 
	jr l8432h		;842a	18 06 	. . 
l842ch:
	cp 023h		;842c	fe 23 	. # 
	jr nz,l8411h		;842e	20 e1 	  . 
	ld c,010h		;8430	0e 10 	. . 
l8432h:
	call sub_848fh		;8432	cd 8f 84 	. . . 
	jp c,l8089h		;8435	da 89 80 	. . . 
l8438h:
	ld hl,00000h		;8438	21 00 00 	! . . 
l843bh:
	call sub_84a0h		;843b	cd a0 84 	. . . 
	ret nc			;843e	d0 	. 
	push de			;843f	d5 	. 
	push af			;8440	f5 	. 
	ld a,c			;8441	79 	y 
	dec a			;8442	3d 	= 
	ld d,h			;8443	54 	T 
	ld e,l			;8444	5d 	] 
l8445h:
	add hl,de			;8445	19 	. 
l8446h:
	jp c,l8085h		;8446	da 85 80 	. . . 
	dec a			;8449	3d 	= 
	jr nz,l8445h		;844a	20 f9 	  . 
	pop af			;844c	f1 	. 
	cp c			;844d	b9 	. 
	jp nc,l8085h		;844e	d2 85 80 	. . . 
	ld d,000h		;8451	16 00 	. . 
	ld e,a			;8453	5f 	_ 
	add hl,de			;8454	19 	. 
	jr c,l8446h		;8455	38 ef 	8 . 
	pop de			;8457	d1 	. 
	ex af,af'			;8458	08 	. 
	call sub_848fh		;8459	cd 8f 84 	. . . 
	ret c			;845c	d8 	. 
	jr l843bh		;845d	18 dc 	. . 
l845fh:
	ld hl,00000h		;845f	21 00 00 	! . . 
	call sub_847ah		;8462	cd 7a 84 	. z . 
	or a			;8465	b7 	. 
	jr z,l8478h		;8466	28 10 	( . 
	ld l,a			;8468	6f 	o 
	call sub_847ah		;8469	cd 7a 84 	. z . 
	or a			;846c	b7 	. 
	jr z,l8478h		;846d	28 09 	( . 
	ld h,l			;846f	65 	e 
	ld l,a			;8470	6f 	o 
	call sub_847ah		;8471	cd 7a 84 	. z . 
	or a			;8474	b7 	. 
	jp nz,l8094h		;8475	c2 94 80 	. . . 
l8478h:
	jr l848dh		;8478	18 13 	. . 
sub_847ah:
	call sub_848fh		;847a	cd 8f 84 	. . . 
	or a			;847d	b7 	. 
	jp z,l8094h		;847e	ca 94 80 	. . . 
	cp 022h		;8481	fe 22 	. " 
	jr z,l8487h		;8483	28 02 	( . 
	and a			;8485	a7 	. 
	ret			;8486	c9 	. 
l8487h:
	ld a,(de)			;8487	1a 	. 
	cp 022h		;8488	fe 22 	. " 
	ld a,000h		;848a	3e 00 	> . 
	ret nz			;848c	c0 	. 
l848dh:
	ld a,022h		;848d	3e 22 	> " 
sub_848fh:
	call sub_8962h		;848f	cd 62 89 	. b . 
sub_8492h:
	ld a,(de)			;8492	1a 	. 
	inc de			;8493	13 	. 
	cp 029h		;8494	fe 29 	. ) 
	jr z,l849eh		;8496	28 06 	( . 
	cp 02ch		;8498	fe 2c 	. , 
	jr z,l849eh		;849a	28 02 	( . 
	or a			;849c	b7 	. 
	ret nz			;849d	c0 	. 
l849eh:
	scf			;849e	37 	7 
	ret			;849f	c9 	. 
sub_84a0h:
	push af			;84a0	f5 	. 
	ex af,af'			;84a1	08 	. 
	pop af			;84a2	f1 	. 
	sub 030h		;84a3	d6 30 	. 0 
	cp 00ah		;84a5	fe 0a 	. . 
	ret c			;84a7	d8 	. 
	sub 007h		;84a8	d6 07 	. . 
	cp 00ah		;84aa	fe 0a 	. . 
	jr c,l84c0h		;84ac	38 12 	8 . 
	cp 010h		;84ae	fe 10 	. . 
	ret c			;84b0	d8 	. 
	sub 020h		;84b1	d6 20 	.   
	cp 00ah		;84b3	fe 0a 	. . 
	jr c,l84c0h		;84b5	38 09 	8 . 
	cp 010h		;84b7	fe 10 	. . 
	jr nc,l84c0h		;84b9	30 05 	0 . 
	ex af,af'			;84bb	08 	. 
	sub 020h		;84bc	d6 20 	.   
	ex af,af'			;84be	08 	. 
	ret c			;84bf	d8 	. 
l84c0h:
	ex af,af'			;84c0	08 	. 
	and a			;84c1	a7 	. 
	ret			;84c2	c9 	. 
sub_84c3h:
	cp 01ah		;84c3	fe 1a 	. . 
	jr z,l84d6h		;84c5	28 0f 	( . 
	cp 01ch		;84c7	fe 1c 	. . 
	jr z,l84d6h		;84c9	28 0b 	( . 
	cp 01eh		;84cb	fe 1e 	. . 
	jr z,l84d6h		;84cd	28 07 	( . 
	cp 02ah		;84cf	fe 2a 	. * 
	jr z,l84d6h		;84d1	28 03 	( . 
	cp 02fh		;84d3	fe 2f 	. / 
	ret nz			;84d5	c0 	. 
l84d6h:
	dec a			;84d6	3d 	= 
	push hl			;84d7	e5 	. 
	ld hl,07fc1h		;84d8	21 c1 7f 	! .  
	ld (hl),001h		;84db	36 01 	6 . 
	pop hl			;84dd	e1 	. 
	cp a			;84de	bf 	. 
	ret			;84df	c9 	. 
sub_84e0h:
	push hl			;84e0	e5 	. 
	call sub_851fh		;84e1	cd 1f 85 	. . . 
	pop hl			;84e4	e1 	. 
	ld a,b			;84e5	78 	x 
	or a			;84e6	b7 	. 
	ret z			;84e7	c8 	. 
	cp 005h		;84e8	fe 05 	. . 
	jr nc,l84f8h		;84ea	30 0c 	0 . 
	push hl			;84ec	e5 	. 
	ld hl,l854fh		;84ed	21 4f 85 	! O . 
	call sub_8559h		;84f0	cd 59 85 	. Y . 
	pop hl			;84f3	e1 	. 
	call sub_8527h		;84f4	cd 27 85 	. ' . 
	ret nc			;84f7	d0 	. 
l84f8h:
	ld a,(hl)			;84f8	7e 	~ 
	cp 028h		;84f9	fe 28 	. ( 
	ld a,02ch		;84fb	3e 2c 	> , 
	ret nz			;84fd	c0 	. 
	inc hl			;84fe	23 	# 
	ld a,(hl)			;84ff	7e 	~ 
	cp 069h		;8500	fe 69 	. i 
	jr nz,l851ah		;8502	20 16 	  . 
	inc hl			;8504	23 	# 
	ld a,(hl)			;8505	7e 	~ 
	cp 078h		;8506	fe 78 	. x 
	ld b,02eh		;8508	06 2e 	. . 
	jr z,l8512h		;850a	28 06 	( . 
	cp 079h		;850c	fe 79 	. y 
	ld b,02fh		;850e	06 2f 	. / 
	jr nz,l851ah		;8510	20 08 	  . 
l8512h:
	inc hl			;8512	23 	# 
	ld a,(hl)			;8513	7e 	~ 
	cp 02bh		;8514	fe 2b 	. + 
	jr z,l851dh		;8516	28 05 	( . 
	cp 02dh		;8518	fe 2d 	. - 
l851ah:
	ld a,02dh		;851a	3e 2d 	> - 
	ret nz			;851c	c0 	. 
l851dh:
	ld a,b			;851d	78 	x 
	ret			;851e	c9 	. 
sub_851fh:
	xor a			;851f	af 	. 
	ld b,a			;8520	47 	G 
l8521h:
	cp (hl)			;8521	be 	. 
	ret z			;8522	c8 	. 
	inc hl			;8523	23 	# 
	inc b			;8524	04 	. 
	jr l8521h		;8525	18 fa 	. . 
sub_8527h:
	push hl			;8527	e5 	. 
l8528h:
	ld a,(de)			;8528	1a 	. 
	and 07fh		;8529	e6 7f 	.  
	cp (hl)			;852b	be 	. 
	jr nz,l8539h		;852c	20 0b 	  . 
	ld a,(de)			;852e	1a 	. 
	inc hl			;852f	23 	# 
	inc de			;8530	13 	. 
	and 080h		;8531	e6 80 	. . 
	jr z,l8528h		;8533	28 f3 	( . 
	pop hl			;8535	e1 	. 
	xor a			;8536	af 	. 
	ld a,c			;8537	79 	y 
	ret			;8538	c9 	. 
l8539h:
	pop hl			;8539	e1 	. 
l853ah:
	ld a,(de)			;853a	1a 	. 
	and 080h		;853b	e6 80 	. . 
	inc de			;853d	13 	. 
	jr z,l853ah		;853e	28 fa 	( . 
	inc c			;8540	0c 	. 
	djnz sub_8527h		;8541	10 e4 	. . 
	scf			;8543	37 	7 
	ret			;8544	c9 	. 
l8545h:
	halt			;8545	76 	v 
	adc a,h			;8546	8c 	. 
	ld bc,00c01h		;8547	01 01 0c 	. . . 
	ld (bc),a			;854a	02 	. 
	add hl,hl			;854b	29 	) 
	ld c,017h		;854c	0e 17 	. . 
	scf			;854e	37 	7 
l854fh:
	or h			;854f	b4 	. 
	adc a,l			;8550	8d 	. 
	inc c			;8551	0c 	. 
	add hl,bc			;8552	09 	. 
	rrca			;8553	0f 	. 
	dec d			;8554	15 	. 
	ld (bc),a			;8555	02 	. 
	inc h			;8556	24 	$ 
	ld b,026h		;8557	06 26 	. & 
sub_8559h:
	ld a,b			;8559	78 	x 
	add a,a			;855a	87 	. 
	ld c,a			;855b	4f 	O 
	xor a			;855c	af 	. 
	ld b,a			;855d	47 	G 
	push hl			;855e	e5 	. 
	add hl,bc			;855f	09 	. 
	ld b,(hl)			;8560	46 	F 
	inc hl			;8561	23 	# 
	ld c,(hl)			;8562	4e 	N 
	pop hl			;8563	e1 	. 
	ld e,(hl)			;8564	5e 	^ 
	inc hl			;8565	23 	# 
	ld d,(hl)			;8566	56 	V 
	ld h,a			;8567	67 	g 
	ld l,c			;8568	69 	i 
	add hl,de			;8569	19 	. 
	ld e,(hl)			;856a	5e 	^ 
	ld d,a			;856b	57 	W 
	add hl,de			;856c	19 	. 
	ex de,hl			;856d	eb 	. 
	ret			;856e	c9 	. 
sub_856fh:
	ld b,020h		;856f	06 20 	.   
	jr l8579h		;8571	18 06 	. . 
sub_8573h:
	ld b,02ch		;8573	06 2c 	. , 
	jr l8579h		;8575	18 02 	. . 
sub_8577h:
	ld b,000h		;8577	06 00 	. . 
l8579h:
	call sub_85aeh		;8579	cd ae 85 	. . . 
	cp 022h		;857c	fe 22 	. " 
	jr z,l85a5h		;857e	28 25 	( % 
	cp 027h		;8580	fe 27 	. ' 
	jr z,l85a5h		;8582	28 21 	( ! 
l8584h:
	cp b			;8584	b8 	. 
	ret z			;8585	c8 	. 
	cp 020h		;8586	fe 20 	.   
	inc hl			;8588	23 	# 
	jr z,l8579h		;8589	28 ee 	( . 
	dec hl			;858b	2b 	+ 
	or a			;858c	b7 	. 
	jr nz,l8591h		;858d	20 02 	  . 
	inc a			;858f	3c 	< 
	ret			;8590	c9 	. 
l8591h:
	inc hl			;8591	23 	# 
	set 5,a		;8592	cb ef 	. . 
	ld (de),a			;8594	12 	. 
	inc de			;8595	13 	. 
	dec c			;8596	0d 	. 
	jr nz,l8579h		;8597	20 e0 	  . 
	jr l85aah		;8599	18 0f 	. . 
l859bh:
	call sub_85adh		;859b	cd ad 85 	. . . 
	or a			;859e	b7 	. 
	jr z,l8584h		;859f	28 e3 	( . 
	cp 022h		;85a1	fe 22 	. " 
	jr z,l8584h		;85a3	28 df 	( . 
l85a5h:
	ld (de),a			;85a5	12 	. 
	inc de			;85a6	13 	. 
	dec c			;85a7	0d 	. 
	jr nz,l859bh		;85a8	20 f1 	  . 
l85aah:
	jp l8089h		;85aa	c3 89 80 	. . . 
sub_85adh:
	inc hl			;85ad	23 	# 
sub_85aeh:
	ld a,(hl)			;85ae	7e 	~ 
	cp 001h		;85af	fe 01 	. . 
	ret nz			;85b1	c0 	. 
	inc hl			;85b2	23 	# 
	ld a,(hl)			;85b3	7e 	~ 
	ret			;85b4	c9 	. 
sub_85b5h:
	call sub_85aeh		;85b5	cd ae 85 	. . . 
	cp 020h		;85b8	fe 20 	.   
	ret nz			;85ba	c0 	. 
	inc hl			;85bb	23 	# 
	jr sub_85b5h		;85bc	18 f7 	. . 
sub_85beh:
	ld hl,l8d6fh		;85be	21 6f 8d 	! o . 
	ld (08751h),hl		;85c1	22 51 87 	" Q . 
	ld hl,050e0h		;85c4	21 e0 50 	! . P 
l85c7h:
	call sub_85f5h		;85c7	cd f5 85 	. . . 
	ld hl,l8afeh		;85ca	21 fe 8a 	! . . 
l85cdh:
	inc hl			;85cd	23 	# 
	ld a,(08788h)		;85ce	3a 88 87 	: . . 
	and 01fh		;85d1	e6 1f 	. . 
	ld (l7each+1),a		;85d3	32 ad 7e 	2 . ~ 
	ld a,(hl)			;85d6	7e 	~ 
	dec a			;85d7	3d 	= 
	jr z,l85e1h		;85d8	28 07 	( . 
	inc a			;85da	3c 	< 
	ret z			;85db	c8 	. 
	call sub_874ah		;85dc	cd 4a 87 	. J . 
	jr l85cdh		;85df	18 ec 	. . 
l85e1h:
	ld (sub_7e3bh+1),hl		;85e1	22 3c 7e 	" < ~ 
	push hl			;85e4	e5 	. 
	ld a,(0866eh)		;85e5	3a 6e 86 	: n . 
	add a,0cch		;85e8	c6 cc 	. . 
	call sub_8769h		;85ea	cd 69 87 	. i . 
	pop hl			;85ed	e1 	. 
	jr l85cdh		;85ee	18 dd 	. . 
sub_85f0h:
	ld c,000h		;85f0	0e 00 	. . 
	call 022b0h		;85f2	cd b0 22 	. . " 
sub_85f5h:
	ld (08788h),hl		;85f5	22 88 87 	" . . 
sub_85f8h:
	ld b,008h		;85f8	06 08 	. . 
l85fah:
	push hl			;85fa	e5 	. 
	ld c,020h		;85fb	0e 20 	.   
l85fdh:
	ld (hl),000h		;85fd	36 00 	6 . 
	inc l			;85ff	2c 	, 
	dec c			;8600	0d 	. 
	jr nz,l85fdh		;8601	20 fa 	  . 
	pop hl			;8603	e1 	. 
	inc h			;8604	24 	$ 
	djnz l85fah		;8605	10 f3 	. . 
	ret			;8607	c9 	. 
sub_8608h:
	exx			;8608	d9 	. 
	call sub_8639h		;8609	cd 39 86 	. 9 . 
	exx			;860c	d9 	. 
	call sub_872eh		;860d	cd 2e 87 	. . . 
	ret nz			;8610	c0 	. 
	or 020h		;8611	f6 20 	.   
	ret			;8613	c9 	. 
l8614h:
	ld hl,00000h		;8614	21 00 00 	! . . 
	inc hl			;8617	23 	# 
	ld (l8614h+1),hl		;8618	22 15 86 	" . . 
	ld a,h			;861b	7c 	| 
	cp 005h		;861c	fe 05 	. . 
	jr nz,sub_8639h		;861e	20 19 	  . 
	ld a,00dh		;8620	3e 0d 	> . 
	jr l868fh		;8622	18 6b 	. k 
l8624h:
	ld h,002h		;8624	26 02 	& . 
l8626h:
	call sub_86aeh		;8626	cd ae 86 	. . . 
l8629h:
	jr nz,l8633h		;8629	20 08 	  . 
	dec hl			;862b	2b 	+ 
	inc h			;862c	24 	$ 
	dec h			;862d	25 	% 
	jr nz,l8626h		;862e	20 f6 	  . 
	call sub_86a8h		;8630	cd a8 86 	. . . 
l8633h:
	ld hl,00000h		;8633	21 00 00 	! . . 
	ld (l8614h+1),hl		;8636	22 15 86 	" . . 
sub_8639h:
	call sub_86aeh		;8639	cd ae 86 	. . . 
	jr z,l8624h		;863c	28 e6 	( . 
	ld b,000h		;863e	06 00 	. . 
	ld c,e			;8640	4b 	K 
	ld a,e			;8641	7b 	{ 
	ld (08685h),a		;8642	32 85 86 	2 . . 
	ld hl,00204h		;8645	21 04 02 	! . . 
	ld a,d			;8648	7a 	z 
	cp 019h		;8649	fe 19 	. . 
	jr z,l86c3h		;864b	28 76 	( v 
	add hl,bc			;864d	09 	. 
	ld a,(hl)			;864e	7e 	~ 
	cp 020h		;864f	fe 20 	.   
	ld b,a			;8651	47 	G 
	jr c,l867bh		;8652	38 27 	8 ' 
	ld a,d			;8654	7a 	z 
	cp 028h		;8655	fe 28 	. ( 
	ld a,b			;8657	78 	x 
	set 5,a		;8658	cb ef 	. . 
	jr nz,l866ch		;865a	20 10 	  . 
	call sub_8726h		;865c	cd 26 87 	. & . 
	jr nz,l8665h		;865f	20 04 	  . 
	sub 02dh		;8661	d6 2d 	. - 
	jr l867bh		;8663	18 16 	. . 
l8665h:
	call sub_872eh		;8665	cd 2e 87 	. . . 
	jr nz,l866ch		;8668	20 02 	  . 
	res 5,a		;866a	cb af 	. . 
l866ch:
	ld b,a			;866c	47 	G 
	ld a,000h		;866d	3e 00 	> . 
	or a			;866f	b7 	. 
	ld a,b			;8670	78 	x 
	jr z,l867bh		;8671	28 08 	( . 
	call sub_872eh		;8673	cd 2e 87 	. . . 
	jr nz,l867bh		;8676	20 03 	  . 
	ld a,020h		;8678	3e 20 	>   
	xor b			;867a	a8 	. 
l867bh:
	ld b,a			;867b	47 	G 
	or a			;867c	b7 	. 
	jr z,sub_8639h		;867d	28 ba 	( . 
	cp 080h		;867f	fe 80 	. . 
	jr z,sub_8639h		;8681	28 b6 	( . 
	ld b,a			;8683	47 	G 
	ld a,022h		;8684	3e 22 	> " 
	cp 000h		;8686	fe 00 	. . 
	ld (08687h),a		;8688	32 87 86 	2 . . 
	ld a,b			;868b	78 	x 
	jp z,l8614h		;868c	ca 14 86 	. . . 
l868fh:
	push af			;868f	f5 	. 
	call sub_870fh		;8690	cd 0f 87 	. . . 
	pop af			;8693	f1 	. 
	ld h,014h		;8694	26 14 	& . 
l8696h:
	dec hl			;8696	2b 	+ 
	inc h			;8697	24 	$ 
	dec h			;8698	25 	% 
	jr nz,l8696h		;8699	20 fb 	  . 
	bit 7,a		;869b	cb 7f 	.  
	ld (08621h),a		;869d	32 21 86 	2 ! . 
	ret z			;86a0	c8 	. 
	ld h,04eh		;86a1	26 4e 	& N 
l86a3h:
	dec hl			;86a3	2b 	+ 
	inc h			;86a4	24 	$ 
	dec h			;86a5	25 	% 
	jr nz,l86a3h		;86a6	20 fb 	  . 
sub_86a8h:
	ld hl,08687h		;86a8	21 87 86 	! . . 
	ld (hl),000h		;86ab	36 00 	6 . 
	ret			;86ad	c9 	. 
sub_86aeh:
	push hl			;86ae	e5 	. 
	call 0028eh		;86af	cd 8e 02 	. . . 
	pop hl			;86b2	e1 	. 
	jr z,l86b7h		;86b3	28 02 	( . 
	xor a			;86b5	af 	. 
	ret			;86b6	c9 	. 
l86b7h:
	ld a,e			;86b7	7b 	{ 
	inc e			;86b8	1c 	. 
	ret z			;86b9	c8 	. 
	inc d			;86ba	14 	. 
	ret nz			;86bb	c0 	. 
	ld a,e			;86bc	7b 	{ 
	sub 019h		;86bd	d6 19 	. . 
	ret z			;86bf	c8 	. 
	sub 00fh		;86c0	d6 0f 	. . 
	ret			;86c2	c9 	. 
l86c3h:
	ex de,hl			;86c3	eb 	. 
	ld a,c			;86c4	79 	y 
	cp 01bh		;86c5	fe 1b 	. . 
	jr z,l86e0h		;86c7	28 17 	( . 
	ld hl,l8affh		;86c9	21 ff 8a 	! . . 
	ld a,(hl)			;86cc	7e 	~ 
	dec a			;86cd	3d 	= 
	jr nz,l86e0h		;86ce	20 10 	  . 
	inc hl			;86d0	23 	# 
	or (hl)			;86d1	b6 	. 
	jr nz,l86e0h		;86d2	20 0c 	  . 
	ex de,hl			;86d4	eb 	. 
	add hl,bc			;86d5	09 	. 
	ld a,(hl)			;86d6	7e 	~ 
	call sub_872eh		;86d7	cd 2e 87 	. . . 
	jr nz,l86e0h		;86da	20 04 	  . 
	set 7,a		;86dc	cb ff 	. . 
	jr l867bh		;86de	18 9b 	. . 
l86e0h:
	ld hl,086e6h		;86e0	21 e6 86 	! . . 
	add hl,bc			;86e3	09 	. 
	ld a,(hl)			;86e4	7e 	~ 
	jr l867bh		;86e5	18 94 	. . 
	ld hl,(05b5eh)		;86e7	2a 5e 5b 	* ^ [ 
	ld h,025h		;86ea	26 25 	& % 
	ld a,07dh		;86ec	3e 7d 	> } 
	cpl			;86ee	2f 	/ 
	inc l			;86ef	2c 	, 
	dec l			;86f0	2d 	- 
	ld e,l			;86f1	5d 	] 
	daa			;86f2	27 	' 
	inc h			;86f3	24 	$ 
	inc a			;86f4	3c 	< 
	ld a,e			;86f5	7b 	{ 
	ccf			;86f6	3f 	? 
	ld l,02bh		;86f7	2e 2b 	. + 
	ld a,a			;86f9	7f 	 
	jr z,l871fh		;86fa	28 23 	( # 
	nop			;86fc	00 	. 
	ld e,h			;86fd	5c 	\ 
	ld h,b			;86fe	60 	` 
	nop			;86ff	00 	. 
	dec a			;8700	3d 	= 
	dec sp			;8701	3b 	; 
	add hl,hl			;8702	29 	) 
	ld b,b			;8703	40 	@ 
	inc d			;8704	14 	. 
	ld a,h			;8705	7c 	| 
	ld a,(00d20h)		;8706	3a 20 0d 	:   . 
	ld (0215fh),hl		;8709	22 5f 21 	" _ ! 
	dec d			;870c	15 	. 
	ld a,(hl)			;870d	7e 	~ 
	nop			;870e	00 	. 
sub_870fh:
	ld e,00ah		;870f	1e 0a 	. . 
	jr l8715h		;8711	18 02 	. . 
sub_8713h:
	ld e,000h		;8713	1e 00 	. . 
l8715h:
	ld hl,0012ch		;8715	21 2c 01 	! , . 
	ld a,007h		;8718	3e 07 	> . 
l871ah:
	ld b,e			;871a	43 	C 
	xor 010h		;871b	ee 10 	. . 
l871dh:
	out (0feh),a		;871d	d3 fe 	. . 
l871fh:
	djnz l871dh		;871f	10 fc 	. . 
	dec hl			;8721	2b 	+ 
	inc h			;8722	24 	$ 
	dec h			;8723	25 	% 
	jr nz,l871ah		;8724	20 f4 	  . 
sub_8726h:
	cp 030h		;8726	fe 30 	. 0 
	ret c			;8728	d8 	. 
	cp 039h		;8729	fe 39 	. 9 
	ret nc			;872b	d0 	. 
	cp a			;872c	bf 	. 
	ret			;872d	c9 	. 
sub_872eh:
	cp 041h		;872e	fe 41 	. A 
	ret c			;8730	d8 	. 
	cp 07ah		;8731	fe 7a 	. z 
	ret nc			;8733	d0 	. 
	cp 05bh		;8734	fe 5b 	. [ 
	jr c,l873bh		;8736	38 03 	8 . 
	cp 061h		;8738	fe 61 	. a 
	ret c			;873a	d8 	. 
l873bh:
	cp a			;873b	bf 	. 
	ret			;873c	c9 	. 
sub_873dh:
	ld a,020h		;873d	3e 20 	>   
	jr sub_8744h		;873f	18 03 	. . 
sub_8741h:
	ld a,(hl)			;8741	7e 	~ 
	and 07fh		;8742	e6 7f 	.  
sub_8744h:
	exx			;8744	d9 	. 
	call sub_877fh		;8745	cd 7f 87 	.  . 
	exx			;8748	d9 	. 
	ret			;8749	c9 	. 
sub_874ah:
	cp 080h		;874a	fe 80 	. . 
	jr c,sub_8767h		;874c	38 19 	8 . 
	push hl			;874e	e5 	. 
	push de			;874f	d5 	. 
	ld hl,l8d6fh		;8750	21 6f 8d 	! o . 
	ld d,000h		;8753	16 00 	. . 
	ld e,a			;8755	5f 	_ 
	add hl,de			;8756	19 	. 
	ld e,(hl)			;8757	5e 	^ 
	add hl,de			;8758	19 	. 
l8759h:
	ld a,(hl)			;8759	7e 	~ 
	inc hl			;875a	23 	# 
	push af			;875b	f5 	. 
	call sub_8767h		;875c	cd 67 87 	. g . 
	pop af			;875f	f1 	. 
	rlca			;8760	07 	. 
	jr nc,l8759h		;8761	30 f6 	0 . 
	pop de			;8763	d1 	. 
	pop hl			;8764	e1 	. 
sub_8765h:
	ld a,020h		;8765	3e 20 	>   
sub_8767h:
	res 7,a		;8767	cb bf 	. . 
sub_8769h:
	exx			;8769	d9 	. 
	call sub_877fh		;876a	cd 7f 87 	.  . 
	ld a,h			;876d	7c 	| 
	add a,00ah		;876e	c6 0a 	. . 
	cp 05ah		;8770	fe 5a 	. Z 
	jr z,l877ah		;8772	28 06 	( . 
l8774h:
	add a,007h		;8774	c6 07 	. . 
	cp 058h		;8776	fe 58 	. X 
	jr c,l8774h		;8778	38 fa 	8 . 
l877ah:
	ld h,a			;877a	67 	g 
	ld (hl),038h		;877b	36 38 	6 8 
	exx			;877d	d9 	. 
	ret			;877e	c9 	. 
sub_877fh:
	add a,a			;877f	87 	. 
	ld h,00fh		;8780	26 0f 	& . 
	ld l,a			;8782	6f 	o 
	sbc a,a			;8783	9f 	. 
	ld c,a			;8784	4f 	O 
	add hl,hl			;8785	29 	) 
	add hl,hl			;8786	29 	) 
	ld de,050e1h		;8787	11 e1 50 	. . P 
	push de			;878a	d5 	. 
	ld b,008h		;878b	06 08 	. . 
l878dh:
	ld a,(hl)			;878d	7e 	~ 
	nop			;878e	00 	. 
	or (hl)			;878f	b6 	. 
	xor c			;8790	a9 	. 
	ld (de),a			;8791	12 	. 
	inc hl			;8792	23 	# 
	inc d			;8793	14 	. 
	djnz l878dh		;8794	10 f7 	. . 
	pop hl			;8796	e1 	. 
	push hl			;8797	e5 	. 
	inc l			;8798	2c 	, 
	jr nz,l87a5h		;8799	20 0a 	  . 
	ld a,h			;879b	7c 	| 
	add a,008h		;879c	c6 08 	. . 
	cp 058h		;879e	fe 58 	. X 
	jr nz,l87a4h		;87a0	20 02 	  . 
	ld a,040h		;87a2	3e 40 	> @ 
l87a4h:
	ld h,a			;87a4	67 	g 
l87a5h:
	ld (08788h),hl		;87a5	22 88 87 	" . . 
	pop hl			;87a8	e1 	. 
	ret			;87a9	c9 	. 
sub_87aah:
	ld de,l8ac8h		;87aa	11 c8 8a 	. . . 
	ld b,000h		;87ad	06 00 	. . 
l87afh:
	call sub_85aeh		;87af	cd ae 85 	. . . 
	call sub_8726h		;87b2	cd 26 87 	. & . 
	jr z,l87c2h		;87b5	28 0b 	( . 
	res 5,a		;87b7	cb af 	. . 
	cp 05fh		;87b9	fe 5f 	. _ 
	jr z,l87c2h		;87bb	28 05 	( . 
	call sub_872eh		;87bd	cd 2e 87 	. . . 
	jr nz,l87ceh		;87c0	20 0c 	  . 
l87c2h:
	ld (de),a			;87c2	12 	. 
	inc de			;87c3	13 	. 
	inc hl			;87c4	23 	# 
	inc b			;87c5	04 	. 
	ld a,b			;87c6	78 	x 
	cp 009h		;87c7	fe 09 	. . 
	jr c,l87afh		;87c9	38 e4 	8 . 
	jp l8089h		;87cb	c3 89 80 	. . . 
l87ceh:
	ld a,b			;87ce	78 	x 
	ld (l8ac7h),a		;87cf	32 c7 8a 	2 . . 
	dec de			;87d2	1b 	. 
	ex de,hl			;87d3	eb 	. 
	set 7,(hl)		;87d4	cb fe 	. . 
	ld hl,l9c35h+1		;87d6	21 36 9c 	! 6 . 
	ld e,(hl)			;87d9	5e 	^ 
	inc hl			;87da	23 	# 
	ld d,(hl)			;87db	56 	V 
	inc hl			;87dc	23 	# 
	push de			;87dd	d5 	. 
	ex de,hl			;87de	eb 	. 
	inc hl			;87df	23 	# 
	add hl,hl			;87e0	29 	) 
	add hl,de			;87e1	19 	. 
	ld (087f7h),hl		;87e2	22 f7 87 	" . . 
	dec hl			;87e5	2b 	+ 
	dec hl			;87e6	2b 	+ 
	ld (08823h),hl		;87e7	22 23 88 	" # . 
	pop bc			;87ea	c1 	. 
	jr l880fh		;87eb	18 22 	. " 
l87edh:
	push bc			;87ed	c5 	. 
	dec hl			;87ee	2b 	+ 
	ld a,(hl)			;87ef	7e 	~ 
	and 03fh		;87f0	e6 3f 	. ? 
	ld d,a			;87f2	57 	W 
	dec hl			;87f3	2b 	+ 
	ld e,(hl)			;87f4	5e 	^ 
	push hl			;87f5	e5 	. 
	ld hl,00000h		;87f6	21 00 00 	! . . 
	add hl,de			;87f9	19 	. 
	ld de,l8ac7h		;87fa	11 c7 8a 	. . . 
	ld a,(de)			;87fd	1a 	. 
	ld b,a			;87fe	47 	G 
	inc de			;87ff	13 	. 
l8800h:
	ld a,(de)			;8800	1a 	. 
	cp (hl)			;8801	be 	. 
	jr nz,l880ch		;8802	20 08 	  . 
	inc hl			;8804	23 	# 
	inc de			;8805	13 	. 
	djnz l8800h		;8806	10 f8 	. . 
	pop af			;8808	f1 	. 
l8809h:
	pop hl			;8809	e1 	. 
	xor a			;880a	af 	. 
	ret			;880b	c9 	. 
l880ch:
	pop hl			;880c	e1 	. 
	pop bc			;880d	c1 	. 
	dec bc			;880e	0b 	. 
l880fh:
	ld a,b			;880f	78 	x 
	or c			;8810	b1 	. 
l8811h:
	jr nz,l87edh		;8811	20 da 	  . 
	scf			;8813	37 	7 
	ret			;8814	c9 	. 
sub_8815h:
	call sub_87aah		;8815	cd aa 87 	. . . 
	ret nc			;8818	d0 	. 
l8819h:
	ld hl,l9c38h		;8819	21 38 9c 	! 8 . 
	ld bc,0000ch		;881c	01 0c 00 	. . . 
	call sub_8068h		;881f	cd 68 80 	. h . 
	ld de,00000h		;8822	11 00 00 	. . . 
	xor a			;8825	af 	. 
	sbc hl,de		;8826	ed 52 	. R 
	ld b,h			;8828	44 	D 
l8829h:
	ld c,l			;8829	4d 	M 
	ld h,d			;882a	62 	b 
	ld l,e			;882b	6b 	k 
	inc de			;882c	13 	. 
	inc de			;882d	13 	. 
	call l88ech		;882e	cd ec 88 	. . . 
l8831h:
	ld hl,l8819h+1		;8831	21 1a 88 	! . . 
	call sub_8978h		;8834	cd 78 89 	. x . 
	ld hl,(087d7h)		;8837	2a d7 87 	* . . 
	ld c,(hl)			;883a	4e 	N 
	inc hl			;883b	23 	# 
	ld b,(hl)			;883c	46 	F 
	ld hl,(087f7h)		;883d	2a f7 87 	* . . 
	jr l886ch		;8840	18 2a 	. * 
l8842h:
	pop hl			;8842	e1 	. 
	pop af			;8843	f1 	. 
	jr l8870h		;8844	18 2a 	. * 
l8846h:
	push bc			;8846	c5 	. 
	push hl			;8847	e5 	. 
	inc hl			;8848	23 	# 
	ld de,l8ac8h		;8849	11 c8 8a 	. . . 
l884ch:
	inc hl			;884c	23 	# 
	ld c,(hl)			;884d	4e 	N 
	res 7,c		;884e	cb b9 	. . 
	ld a,(de)			;8850	1a 	. 
	and 07fh		;8851	e6 7f 	.  
	cp c			;8853	b9 	. 
	jr c,l8842h		;8854	38 ec 	8 . 
	jr nz,l8864h		;8856	20 0c 	  . 
	ld a,(de)			;8858	1a 	. 
	and 080h		;8859	e6 80 	. . 
	jr nz,l8842h		;885b	20 e5 	  . 
	bit 7,(hl)		;885d	cb 7e 	. ~ 
	jr nz,l8864h		;885f	20 03 	  . 
	inc de			;8861	13 	. 
	jr l884ch		;8862	18 e8 	. . 
l8864h:
	bit 7,(hl)		;8864	cb 7e 	. ~ 
	inc hl			;8866	23 	# 
	jr z,l8864h		;8867	28 fb 	( . 
	pop af			;8869	f1 	. 
	pop bc			;886a	c1 	. 
	dec bc			;886b	0b 	. 
l886ch:
	ld a,b			;886c	78 	x 
	or c			;886d	b1 	. 
	jr nz,l8846h		;886e	20 d6 	  . 
l8870h:
	push hl			;8870	e5 	. 
	ex de,hl			;8871	eb 	. 
	ld hl,(l8819h+1)		;8872	2a 1a 88 	* . . 
	xor a			;8875	af 	. 
	sbc hl,de		;8876	ed 52 	. R 
	ex de,hl			;8878	eb 	. 
	push hl			;8879	e5 	. 
	ld b,a			;887a	47 	G 
	ld a,(l8ac7h)		;887b	3a c7 8a 	: . . 
	add a,002h		;887e	c6 02 	. . 
	ld c,a			;8880	4f 	O 
	push bc			;8881	c5 	. 
	push hl			;8882	e5 	. 
	add hl,bc			;8883	09 	. 
	ld b,d			;8884	42 	B 
	ld c,e			;8885	4b 	K 
	ex de,hl			;8886	eb 	. 
	pop hl			;8887	e1 	. 
	call l88ech		;8888	cd ec 88 	. . . 
	pop bc			;888b	c1 	. 
	ld hl,l8819h+1		;888c	21 1a 88 	! . . 
	call sub_8980h		;888f	cd 80 89 	. . . 
	pop de			;8892	d1 	. 
	ld hl,l8ac6h		;8893	21 c6 8a 	! . . 
	ld (hl),000h		;8896	36 00 	6 . 
	push bc			;8898	c5 	. 
	call l88ech		;8899	cd ec 88 	. . . 
	ld hl,(087d7h)		;889c	2a d7 87 	* . . 
	call sub_897dh		;889f	cd 7d 89 	. } . 
	pop bc			;88a2	c1 	. 
	dec de			;88a3	1b 	. 
	ex de,hl			;88a4	eb 	. 
	ex (sp),hl			;88a5	e3 	. 
	ld de,(087f7h)		;88a6	ed 5b f7 87 	. [ . . 
	xor a			;88aa	af 	. 
	sbc hl,de		;88ab	ed 52 	. R 
	ex de,hl			;88ad	eb 	. 
	inc hl			;88ae	23 	# 
	inc hl			;88af	23 	# 
	ld (087f7h),hl		;88b0	22 f7 87 	" . . 
	dec hl			;88b3	2b 	+ 
	dec hl			;88b4	2b 	+ 
	ld ix,(087d7h)		;88b5	dd 2a d7 87 	. * . . 
	ex (sp),hl			;88b9	e3 	. 
	jr l88cdh		;88ba	18 11 	. . 
l88bch:
	call sub_75dbh		;88bc	cd db 75 	. . u 
	sbc hl,de		;88bf	ed 52 	. R 
	jr c,l88cbh		;88c1	38 08 	8 . 
	push de			;88c3	d5 	. 
	push ix		;88c4	dd e5 	. . 
	pop hl			;88c6	e1 	. 
	call sub_8980h		;88c7	cd 80 89 	. . . 
	pop de			;88ca	d1 	. 
l88cbh:
	ex (sp),hl			;88cb	e3 	. 
	dec hl			;88cc	2b 	+ 
l88cdh:
	ld a,h			;88cd	7c 	| 
	or l			;88ce	b5 	. 
	ex (sp),hl			;88cf	e3 	. 
	jr nz,l88bch		;88d0	20 ea 	  . 
	pop hl			;88d2	e1 	. 
	ld (ix+002h),e		;88d3	dd 73 02 	. s . 
	ld (ix+003h),d		;88d6	dd 72 03 	. r . 
	ld hl,(087d7h)		;88d9	2a d7 87 	* . . 
	ld a,(hl)			;88dc	7e 	~ 
	inc hl			;88dd	23 	# 
	ld h,(hl)			;88de	66 	f 
	ld l,a			;88df	6f 	o 
	ret			;88e0	c9 	. 
sub_88e1h:
	push hl			;88e1	e5 	. 
	ld hl,(l8819h+1)		;88e2	2a 1a 88 	* . . 
	and a			;88e5	a7 	. 
	sbc hl,de		;88e6	ed 52 	. R 
	ld b,h			;88e8	44 	D 
	ld c,l			;88e9	4d 	M 
	ex de,hl			;88ea	eb 	. 
	pop de			;88eb	d1 	. 
l88ech:
	ld a,b			;88ec	78 	x 
	or c			;88ed	b1 	. 
	ret z			;88ee	c8 	. 
	push hl			;88ef	e5 	. 
	xor a			;88f0	af 	. 
	sbc hl,de		;88f1	ed 52 	. R 
	pop hl			;88f3	e1 	. 
	jr c,l88f9h		;88f4	38 03 	8 . 
	ldir		;88f6	ed b0 	. . 
	ret			;88f8	c9 	. 
l88f9h:
	add hl,bc			;88f9	09 	. 
	dec hl			;88fa	2b 	+ 
	ex de,hl			;88fb	eb 	. 
	add hl,bc			;88fc	09 	. 
	dec hl			;88fd	2b 	+ 
	ex de,hl			;88fe	eb 	. 
	lddr		;88ff	ed b8 	. . 
	ret			;8901	c9 	. 
sub_8902h:
	ld c,000h		;8902	0e 00 	. . 
	ld ix,l8ac7h		;8904	dd 21 c7 8a 	. ! . . 
sub_8908h:
	ld a,000h		;8908	3e 00 	> . 
	or a			;890a	b7 	. 
	jr z,sub_8926h		;890b	28 19 	( . 
sub_890dh:
	ld (ix+000h),023h		;890d	dd 36 00 23 	. 6 . # 
	inc ix		;8911	dd 23 	. # 
	ld de,01000h		;8913	11 00 10 	. . . 
	call sub_8941h		;8916	cd 41 89 	. A . 
	ld d,001h		;8919	16 01 	. . 
	call sub_8941h		;891b	cd 41 89 	. A . 
sub_891eh:
	ld de,00010h		;891e	11 10 00 	. . . 
	call sub_8941h		;8921	cd 41 89 	. A . 
	jr l893dh		;8924	18 17 	. . 
sub_8926h:
	ld de,02710h		;8926	11 10 27 	. . ' 
	call sub_8941h		;8929	cd 41 89 	. A . 
	ld de,003e8h		;892c	11 e8 03 	. . . 
	call sub_8941h		;892f	cd 41 89 	. A . 
sub_8932h:
	ld de,00064h		;8932	11 64 00 	. d . 
	call sub_8941h		;8935	cd 41 89 	. A . 
	ld e,00ah		;8938	1e 0a 	. . 
	call sub_8941h		;893a	cd 41 89 	. A . 
l893dh:
	ld e,001h		;893d	1e 01 	. . 
	ld c,000h		;893f	0e 00 	. . 
sub_8941h:
	ld a,0ffh		;8941	3e ff 	> . 
l8943h:
	inc a			;8943	3c 	< 
	and a			;8944	a7 	. 
	sbc hl,de		;8945	ed 52 	. R 
	jr nc,l8943h		;8947	30 fa 	0 . 
	add hl,de			;8949	19 	. 
	bit 0,c		;894a	cb 41 	. A 
	jr z,l8950h		;894c	28 02 	( . 
	or a			;894e	b7 	. 
	ret z			;894f	c8 	. 
l8950h:
	res 0,c		;8950	cb 81 	. . 
	add a,030h		;8952	c6 30 	. 0 
	cp 03ah		;8954	fe 3a 	. : 
	jr c,l895ah		;8956	38 02 	8 . 
	add a,007h		;8958	c6 07 	. . 
l895ah:
	call sub_8963h		;895a	cd 63 89 	. c . 
	ld (ix+000h),000h		;895d	dd 36 00 00 	. 6 . . 
	ret			;8961	c9 	. 
sub_8962h:
	inc b			;8962	04 	. 
sub_8963h:
	ld (ix+000h),a		;8963	dd 77 00 	. w . 
	inc ix		;8966	dd 23 	. # 
	ret			;8968	c9 	. 
sub_8969h:
	push hl			;8969	e5 	. 
	ld a,(hl)			;896a	7e 	~ 
	inc hl			;896b	23 	# 
	ld h,(hl)			;896c	66 	f 
	ld l,a			;896d	6f 	o 
	ld de,l9c3eh		;896e	11 3e 9c 	. > . 
	and a			;8971	a7 	. 
	sbc hl,de		;8972	ed 52 	. R 
	pop hl			;8974	e1 	. 
	ret c			;8975	d8 	. 
	jr sub_8980h		;8976	18 08 	. . 
sub_8978h:
	ld bc,00002h		;8978	01 02 00 	. . . 
	jr sub_8980h		;897b	18 03 	. . 
sub_897dh:
	ld bc,00001h		;897d	01 01 00 	. . . 
sub_8980h:
	ld e,(hl)			;8980	5e 	^ 
	inc hl			;8981	23 	# 
	ld d,(hl)			;8982	56 	V 
	ex de,hl			;8983	eb 	. 
	add hl,bc			;8984	09 	. 
l8985h:
	ex de,hl			;8985	eb 	. 
	ld (hl),d			;8986	72 	r 
	dec hl			;8987	2b 	+ 
	ld (hl),e			;8988	73 	s 
	ret			;8989	c9 	. 
sub_898ah:
	push hl			;898a	e5 	. 
	ld (089dfh),hl		;898b	22 df 89 	" . . 
	push bc			;898e	c5 	. 
l898fh:
	call sub_8248h		;898f	cd 48 82 	. H . 
	dec bc			;8992	0b 	. 
	ld a,b			;8993	78 	x 
	or c			;8994	b1 	. 
	jr nz,l898fh		;8995	20 f8 	  . 
	pop bc			;8997	c1 	. 
	pop de			;8998	d1 	. 
	push hl			;8999	e5 	. 
	and a			;899a	a7 	. 
	sbc hl,de		;899b	ed 52 	. R 
	ld b,h			;899d	44 	D 
	ld c,l			;899e	4d 	M 
	pop hl			;899f	e1 	. 
	push bc			;89a0	c5 	. 
	push de			;89a1	d5 	. 
	push hl			;89a2	e5 	. 
	ld hl,(l8819h+1)		;89a3	2a 1a 88 	* . . 
	and a			;89a6	a7 	. 
	pop de			;89a7	d1 	. 
	sbc hl,de		;89a8	ed 52 	. R 
	ex de,hl			;89aa	eb 	. 
	ld b,d			;89ab	42 	B 
	ld c,e			;89ac	4b 	K 
	pop de			;89ad	d1 	. 
	call l88ech		;89ae	cd ec 88 	. . . 
	pop bc			;89b1	c1 	. 
	push bc			;89b2	c5 	. 
l89b3h:
	xor a			;89b3	af 	. 
	ld (de),a			;89b4	12 	. 
	inc de			;89b5	13 	. 
	dec bc			;89b6	0b 	. 
	ld a,b			;89b7	78 	x 
	or c			;89b8	b1 	. 
	jr nz,l89b3h		;89b9	20 f8 	  . 
	pop bc			;89bb	c1 	. 
	ld hl,080e8h		;89bc	21 e8 80 	! . . 
	call sub_89dah		;89bf	cd da 89 	. . . 
	ld hl,080ebh		;89c2	21 eb 80 	! . . 
	call sub_89dah		;89c5	cd da 89 	. . . 
	ld hl,l8819h+1		;89c8	21 1a 88 	! . . 
	call sub_89d1h		;89cb	cd d1 89 	. . . 
	ld hl,087d7h		;89ce	21 d7 87 	! . . 
sub_89d1h:
	ld e,(hl)			;89d1	5e 	^ 
	inc hl			;89d2	23 	# 
	ld d,(hl)			;89d3	56 	V 
	ex de,hl			;89d4	eb 	. 
	and a			;89d5	a7 	. 
	sbc hl,bc		;89d6	ed 42 	. B 
	jr l8985h		;89d8	18 ab 	. . 
sub_89dah:
	push hl			;89da	e5 	. 
	ld e,(hl)			;89db	5e 	^ 
	inc hl			;89dc	23 	# 
	ld d,(hl)			;89dd	56 	V 
	ld hl,l9c27h+1		;89de	21 28 9c 	! ( . 
	and a			;89e1	a7 	. 
	sbc hl,de		;89e2	ed 52 	. R 
	pop hl			;89e4	e1 	. 
	ret nc			;89e5	d0 	. 
	jr sub_89d1h		;89e6	18 e9 	. . 
sub_89e8h:
	xor a			;89e8	af 	. 
	ld (07e1fh),a		;89e9	32 1f 7e 	2 . ~ 
	call sub_76b6h		;89ec	cd b6 76 	. . v 
	call l77d1h		;89ef	cd d1 77 	. . w 
sub_89f2h:
	ld a,00ah		;89f2	3e 0a 	> . 
l89f4h:
	call sub_80b4h		;89f4	cd b4 80 	. . . 
	ld a,013h		;89f7	3e 13 	> . 
	ld (08788h),a		;89f9	32 88 87 	2 . . 
	ld a,(07e1fh)		;89fc	3a 1f 7e 	: . ~ 
	or a			;89ff	b7 	. 
	ld a,04fh		;8a00	3e 4f 	> O 
	jr nz,l8a06h		;8a02	20 02 	  . 
	ld a,049h		;8a04	3e 49 	> I 
l8a06h:
	call sub_8744h		;8a06	cd 44 87 	. D . 
	ld hl,(l8819h+1)		;8a09	2a 1a 88 	* . . 
	call sub_8a12h		;8a0c	cd 12 8a 	. . . 
	ld hl,(l7945h+1)		;8a0f	2a 46 79 	* F y 
sub_8a12h:
	call sub_873dh		;8a12	cd 3d 87 	. = . 
	call sub_8902h		;8a15	cd 02 89 	. . . 
	ld hl,l8ac7h		;8a18	21 c7 8a 	! . . 
sub_8a1bh:
	ld a,(hl)			;8a1b	7e 	~ 
	or a			;8a1c	b7 	. 
	ret z			;8a1d	c8 	. 
	call sub_8741h		;8a1e	cd 41 87 	. A . 
	inc hl			;8a21	23 	# 
	jr sub_8a1bh		;8a22	18 f7 	. . 
sub_8a24h:
	push hl			;8a24	e5 	. 
	push de			;8a25	d5 	. 
	ld de,l9c27h+1		;8a26	11 28 9c 	. ( . 
	and a			;8a29	a7 	. 
	sbc hl,de		;8a2a	ed 52 	. R 
	pop de			;8a2c	d1 	. 
	pop hl			;8a2d	e1 	. 
	ret			;8a2e	c9 	. 
sub_8a2fh:
	push hl			;8a2f	e5 	. 
	push de			;8a30	d5 	. 
	ld de,0000ch		;8a31	11 0c 00 	. . . 
	add hl,de			;8a34	19 	. 
	ld de,(087d7h)		;8a35	ed 5b d7 87 	. [ . . 
	and a			;8a39	a7 	. 
	sbc hl,de		;8a3a	ed 52 	. R 
	pop de			;8a3c	d1 	. 
	pop hl			;8a3d	e1 	. 
	ret			;8a3e	c9 	. 
	call 080e7h		;8a3f	cd e7 80 	. . . 
	push hl			;8a42	e5 	. 
	push de			;8a43	d5 	. 
	ld bc,(sub_826ch+1)		;8a44	ed 4b 6d 82 	. K m . 
	and a			;8a48	a7 	. 
	sbc hl,bc		;8a49	ed 42 	. B 
	jr nc,l8a52h		;8a4b	30 05 	0 . 
	ex de,hl			;8a4d	eb 	. 
	ccf			;8a4e	3f 	? 
	sbc hl,bc		;8a4f	ed 42 	. B 
	ccf			;8a51	3f 	? 
l8a52h:
	pop hl			;8a52	e1 	. 
	pop de			;8a53	d1 	. 
	ret c			;8a54	d8 	. 
	push bc			;8a55	c5 	. 
	call sub_8248h		;8a56	cd 48 82 	. H . 
	sbc hl,de		;8a59	ed 52 	. R 
	ld b,h			;8a5b	44 	D 
	ld c,l			;8a5c	4d 	M 
	pop hl			;8a5d	e1 	. 
	ld (0896fh),hl		;8a5e	22 6f 89 	" o . 
	ex de,hl			;8a61	eb 	. 
	push hl			;8a62	e5 	. 
	sbc hl,de		;8a63	ed 52 	. R 
	pop hl			;8a65	e1 	. 
	jr c,l8a69h		;8a66	38 01 	8 . 
l8a68h:
	add hl,bc			;8a68	09 	. 
l8a69h:
	ex de,hl			;8a69	eb 	. 
	jr l8a6eh		;8a6a	18 02 	. . 
sub_8a6ch:
	ld b,000h		;8a6c	06 00 	. . 
l8a6eh:
	push de			;8a6e	d5 	. 
	push hl			;8a6f	e5 	. 
	call sub_8068h		;8a70	cd 68 80 	. h . 
	push bc			;8a73	c5 	. 
	push bc			;8a74	c5 	. 
	ex de,hl			;8a75	eb 	. 
	ld hl,(l8819h+1)		;8a76	2a 1a 88 	* . . 
	and a			;8a79	a7 	. 
	sbc hl,de		;8a7a	ed 52 	. R 
	ex (sp),hl			;8a7c	e3 	. 
	ex de,hl			;8a7d	eb 	. 
	push hl			;8a7e	e5 	. 
	add hl,bc			;8a7f	09 	. 
	pop de			;8a80	d1 	. 
	ex de,hl			;8a81	eb 	. 
	pop bc			;8a82	c1 	. 
	call l88ech		;8a83	cd ec 88 	. . . 
	pop bc			;8a86	c1 	. 
	ld hl,l8819h+1		;8a87	21 1a 88 	! . . 
	call sub_8980h		;8a8a	cd 80 89 	. . . 
	ld hl,087d7h		;8a8d	21 d7 87 	! . . 
	call sub_8980h		;8a90	cd 80 89 	. . . 
	ld hl,080e8h		;8a93	21 e8 80 	! . . 
	call sub_8969h		;8a96	cd 69 89 	. i . 
	ld hl,080ebh		;8a99	21 eb 80 	! . . 
	call sub_8969h		;8a9c	cd 69 89 	. i . 
	pop de			;8a9f	d1 	. 
	pop hl			;8aa0	e1 	. 
	ldir		;8aa1	ed b0 	. . 
	ret			;8aa3	c9 	. 
l8aa4h:
	nop			;8aa4	00 	. 
l8aa5h:
	jr nz,l8ac7h		;8aa5	20 20 	    
l8aa7h:
	jr nz,l8ac9h		;8aa7	20 20 	    
	jr nz,l8acbh		;8aa9	20 20 	    
	jr nz,l8acdh		;8aab	20 20 	    
l8aadh:
	jr nz,l8ab0h		;8aad	20 01 	  . 
	nop			;8aaf	00 	. 
l8ab0h:
	nop			;8ab0	00 	. 
	nop			;8ab1	00 	. 
	nop			;8ab2	00 	. 
	nop			;8ab3	00 	. 
	nop			;8ab4	00 	. 
	nop			;8ab5	00 	. 
	nop			;8ab6	00 	. 
	nop			;8ab7	00 	. 
	nop			;8ab8	00 	. 
	nop			;8ab9	00 	. 
	nop			;8aba	00 	. 
	nop			;8abb	00 	. 
	nop			;8abc	00 	. 
	nop			;8abd	00 	. 
	nop			;8abe	00 	. 
	nop			;8abf	00 	. 
	nop			;8ac0	00 	. 
	nop			;8ac1	00 	. 
	nop			;8ac2	00 	. 
	nop			;8ac3	00 	. 
	nop			;8ac4	00 	. 
	nop			;8ac5	00 	. 
l8ac6h:
	nop			;8ac6	00 	. 
l8ac7h:
	nop			;8ac7	00 	. 
l8ac8h:
	nop			;8ac8	00 	. 
l8ac9h:
	nop			;8ac9	00 	. 
	nop			;8aca	00 	. 
l8acbh:
	nop			;8acb	00 	. 
	nop			;8acc	00 	. 
l8acdh:
	nop			;8acd	00 	. 
	nop			;8ace	00 	. 
	nop			;8acf	00 	. 
	nop			;8ad0	00 	. 
l8ad1h:
	nop			;8ad1	00 	. 
l8ad2h:
	nop			;8ad2	00 	. 
	nop			;8ad3	00 	. 
	nop			;8ad4	00 	. 
	nop			;8ad5	00 	. 
	nop			;8ad6	00 	. 
	nop			;8ad7	00 	. 
	nop			;8ad8	00 	. 
	nop			;8ad9	00 	. 
	nop			;8ada	00 	. 
	nop			;8adb	00 	. 
l8adch:
	nop			;8adc	00 	. 
	nop			;8add	00 	. 
l8adeh:
	nop			;8ade	00 	. 
	nop			;8adf	00 	. 
	nop			;8ae0	00 	. 
	nop			;8ae1	00 	. 
	nop			;8ae2	00 	. 
	nop			;8ae3	00 	. 
l8ae4h:
	nop			;8ae4	00 	. 
l8ae5h:
	nop			;8ae5	00 	. 
	nop			;8ae6	00 	. 
	nop			;8ae7	00 	. 
	nop			;8ae8	00 	. 
	nop			;8ae9	00 	. 
	nop			;8aea	00 	. 
	nop			;8aeb	00 	. 
	nop			;8aec	00 	. 
	nop			;8aed	00 	. 
	nop			;8aee	00 	. 
	nop			;8aef	00 	. 
	nop			;8af0	00 	. 
	nop			;8af1	00 	. 
	nop			;8af2	00 	. 
	nop			;8af3	00 	. 
	nop			;8af4	00 	. 
	nop			;8af5	00 	. 
	nop			;8af6	00 	. 
	nop			;8af7	00 	. 
l8af8h:
	nop			;8af8	00 	. 
l8af9h:
	nop			;8af9	00 	. 
	nop			;8afa	00 	. 
	nop			;8afb	00 	. 
	nop			;8afc	00 	. 
	nop			;8afd	00 	. 
l8afeh:
	add a,b			;8afe	80 	. 
l8affh:
	ld bc,00000h		;8aff	01 00 00 	. . . 
	nop			;8b02	00 	. 
	nop			;8b03	00 	. 
	nop			;8b04	00 	. 
	nop			;8b05	00 	. 
	nop			;8b06	00 	. 
	nop			;8b07	00 	. 
	nop			;8b08	00 	. 
	nop			;8b09	00 	. 
	nop			;8b0a	00 	. 
l8b0bh:
	nop			;8b0b	00 	. 
	nop			;8b0c	00 	. 
l8b0dh:
	nop			;8b0d	00 	. 
	nop			;8b0e	00 	. 
l8b0fh:
	nop			;8b0f	00 	. 
	nop			;8b10	00 	. 
	nop			;8b11	00 	. 
	nop			;8b12	00 	. 
	nop			;8b13	00 	. 
	nop			;8b14	00 	. 
	nop			;8b15	00 	. 
	nop			;8b16	00 	. 
	nop			;8b17	00 	. 
	nop			;8b18	00 	. 
	nop			;8b19	00 	. 
	nop			;8b1a	00 	. 
	nop			;8b1b	00 	. 
	nop			;8b1c	00 	. 
l8b1dh:
	nop			;8b1d	00 	. 
	nop			;8b1e	00 	. 
	nop			;8b1f	00 	. 
	nop			;8b20	00 	. 
l8b21h:
	nop			;8b21	00 	. 
l8b22h:
	nop			;8b22	00 	. 
l8b23h:
	nop			;8b23	00 	. 
l8b24h:
	nop			;8b24	00 	. 
	nop			;8b25	00 	. 
l8b26h:
	nop			;8b26	00 	. 
	nop			;8b27	00 	. 
l8b28h:
	nop			;8b28	00 	. 
	nop			;8b29	00 	. 
	nop			;8b2a	00 	. 
	nop			;8b2b	00 	. 
	nop			;8b2c	00 	. 
	nop			;8b2d	00 	. 
	nop			;8b2e	00 	. 
l8b2fh:
	nop			;8b2f	00 	. 
	nop			;8b30	00 	. 
	nop			;8b31	00 	. 
	nop			;8b32	00 	. 
	nop			;8b33	00 	. 
	nop			;8b34	00 	. 
	nop			;8b35	00 	. 
	nop			;8b36	00 	. 
	nop			;8b37	00 	. 
	nop			;8b38	00 	. 
	nop			;8b39	00 	. 
	nop			;8b3a	00 	. 
	nop			;8b3b	00 	. 
	nop			;8b3c	00 	. 
	nop			;8b3d	00 	. 
	nop			;8b3e	00 	. 
	nop			;8b3f	00 	. 
	nop			;8b40	00 	. 
	nop			;8b41	00 	. 
	nop			;8b42	00 	. 
	nop			;8b43	00 	. 
	nop			;8b44	00 	. 
	nop			;8b45	00 	. 
	nop			;8b46	00 	. 
	nop			;8b47	00 	. 
	nop			;8b48	00 	. 
	nop			;8b49	00 	. 
	nop			;8b4a	00 	. 
	nop			;8b4b	00 	. 
	nop			;8b4c	00 	. 
	nop			;8b4d	00 	. 
	nop			;8b4e	00 	. 
	nop			;8b4f	00 	. 
	nop			;8b50	00 	. 
	nop			;8b51	00 	. 
	nop			;8b52	00 	. 
	nop			;8b53	00 	. 
	nop			;8b54	00 	. 
	nop			;8b55	00 	. 
	nop			;8b56	00 	. 
	nop			;8b57	00 	. 
	nop			;8b58	00 	. 
	nop			;8b59	00 	. 
	ld (bc),a			;8b5a	02 	. 
	jp nz,00001h		;8b5b	c2 01 00 	. . . 
	nop			;8b5e	00 	. 
	nop			;8b5f	00 	. 
	nop			;8b60	00 	. 
	nop			;8b61	00 	. 
	nop			;8b62	00 	. 
	nop			;8b63	00 	. 
	nop			;8b64	00 	. 
	nop			;8b65	00 	. 
	nop			;8b66	00 	. 
	nop			;8b67	00 	. 
	nop			;8b68	00 	. 
	nop			;8b69	00 	. 
	nop			;8b6a	00 	. 
	nop			;8b6b	00 	. 
	nop			;8b6c	00 	. 
	nop			;8b6d	00 	. 
	nop			;8b6e	00 	. 
	nop			;8b6f	00 	. 
	nop			;8b70	00 	. 
	nop			;8b71	00 	. 
	nop			;8b72	00 	. 
	nop			;8b73	00 	. 
	nop			;8b74	00 	. 
	nop			;8b75	00 	. 
	nop			;8b76	00 	. 
	nop			;8b77	00 	. 
	nop			;8b78	00 	. 
	nop			;8b79	00 	. 
	nop			;8b7a	00 	. 
	nop			;8b7b	00 	. 
	nop			;8b7c	00 	. 
	nop			;8b7d	00 	. 
	nop			;8b7e	00 	. 
	nop			;8b7f	00 	. 
	nop			;8b80	00 	. 
	nop			;8b81	00 	. 
	nop			;8b82	00 	. 
	sbc a,a			;8b83	9f 	. 
	ld d,b			;8b84	50 	P 
	ld l,l			;8b85	6d 	m 
	add a,a			;8b86	87 	. 
	ld l,06fh		;8b87	2e 6f 	. o 
	inc hl			;8b89	23 	# 
	ld l,(hl)			;8b8a	6e 	n 
	ld hl,(0d05dh)		;8b8b	2a 5d d0 	* ] . 
	ld bc,l5e9ch		;8b8e	01 9c 5e 	. . ^ 
l8b91h:
	jr z,l8b2fh		;8b91	28 9c 	( . 
	xor b			;8b93	a8 	. 
	ld d,b			;8b94	50 	P 
	ld c,b			;8b95	48 	H 
	add a,a			;8b96	87 	. 
	ret po			;8b97	e0 	. 
	ld d,b			;8b98	50 	P 
	or d			;8b99	b2 	. 
	add a,(hl)			;8b9a	86 	. 
	ld a,(hl)			;8b9b	7e 	~ 
	ld bc,l8629h		;8b9c	01 29 86 	. ) . 
	defb 0fdh,07ch,080h	;illegal sequence		;8b9f	fd 7c 80 	. | . 
	ld b,d			;8ba2	42 	B 
	ld h,c			;8ba3	61 	a 
	ld h,h			;8ba4	64 	d 
	jr nz,l8c14h		;8ba5	20 6d 	  m 
	ld l,(hl)			;8ba7	6e 	n 
	ld h,l			;8ba8	65 	e 
	ld l,l			;8ba9	6d 	m 
	ld l,a			;8baa	6f 	o 
	ld l,(hl)			;8bab	6e 	n 
	ld l,c			;8bac	69 	i 
	ex (sp),hl			;8bad	e3 	. 
	ld b,d			;8bae	42 	B 
	ld h,c			;8baf	61 	a 
	ld h,h			;8bb0	64 	d 
	jr nz,l8c22h		;8bb1	20 6f 	  o 
	ld (hl),b			;8bb3	70 	p 
	ld h,l			;8bb4	65 	e 
	ld (hl),d			;8bb5	72 	r 
	ld h,c			;8bb6	61 	a 
	ld l,(hl)			;8bb7	6e 	n 
	call po,06942h		;8bb8	e4 42 69 	. B i 
	ld h,a			;8bbb	67 	g 
	jr nz,l8c2ch		;8bbc	20 6e 	  n 
	ld (hl),l			;8bbe	75 	u 
	ld l,l			;8bbf	6d 	m 
	ld h,d			;8bc0	62 	b 
	ld h,l			;8bc1	65 	e 
	jp p,l7953h		;8bc2	f2 53 79 	. S y 
	ld l,(hl)			;8bc5	6e 	n 
	ld (hl),h			;8bc6	74 	t 
	ld h,c			;8bc7	61 	a 
	ld a,b			;8bc8	78 	x 
	jr nz,l8c33h		;8bc9	20 68 	  h 
	ld l,a			;8bcb	6f 	o 
	ld (hl),d			;8bcc	72 	r 
	ld (hl),d			;8bcd	72 	r 
	ld l,a			;8bce	6f 	o 
	jp p,06142h		;8bcf	f2 42 61 	. B a 
	ld h,h			;8bd2	64 	d 
	jr nz,l8c48h		;8bd3	20 73 	  s 
	ld (hl),h			;8bd5	74 	t 
	ld (hl),d			;8bd6	72 	r 
	ld l,c			;8bd7	69 	i 
	ld l,(hl)			;8bd8	6e 	n 
	rst 20h			;8bd9	e7 	. 
	ld b,d			;8bda	42 	B 
	ld h,c			;8bdb	61 	a 
	ld h,h			;8bdc	64 	d 
	jr nz,l8c48h		;8bdd	20 69 	  i 
	ld l,(hl)			;8bdf	6e 	n 
	ld (hl),e			;8be0	73 	s 
	ld (hl),h			;8be1	74 	t 
	ld (hl),d			;8be2	72 	r 
	ld (hl),l			;8be3	75 	u 
	ld h,e			;8be4	63 	c 
	ld (hl),h			;8be5	74 	t 
	ld l,c			;8be6	69 	i 
	ld l,a			;8be7	6f 	o 
	xor 04dh		;8be8	ee 4d 	. M 
	ld h,l			;8bea	65 	e 
	ld l,l			;8beb	6d 	m 
	ld l,a			;8bec	6f 	o 
	ld (hl),d			;8bed	72 	r 
	ld a,c			;8bee	79 	y 
	jr nz,$+104		;8bef	20 66 	  f 
	ld (hl),l			;8bf1	75 	u 
	ld l,h			;8bf2	6c 	l 
	call pe,06142h		;8bf3	ec 42 61 	. B a 
	ld h,h			;8bf6	64 	d 
	jr nz,l8c49h		;8bf7	20 50 	  P 
	ld d,l			;8bf9	55 	U 
	ld d,h			;8bfa	54 	T 
	jr nz,l8c25h		;8bfb	20 28 	  ( 
	ld c,a			;8bfd	4f 	O 
	ld d,d			;8bfe	52 	R 
	ld b,a			;8bff	47 	G 
	xor c			;8c00	a9 	. 
	jr nz,l8c78h		;8c01	20 75 	  u 
	ld l,(hl)			;8c03	6e 	n 
	ld l,e			;8c04	6b 	k 
	ld l,(hl)			;8c05	6e 	n 
	ld l,a			;8c06	6f 	o 
	ld (hl),a			;8c07	77 	w 
	xor 057h		;8c08	ee 57 	. W 
	ld h,c			;8c0a	61 	a 
	ld l,c			;8c0b	69 	i 
	ld (hl),h			;8c0c	74 	t 
	jr nz,l8c7fh		;8c0d	20 70 	  p 
	ld l,h			;8c0f	6c 	l 
	ld h,l			;8c10	65 	e 
	ld h,c			;8c11	61 	a 
	ld (hl),e			;8c12	73 	s 
	push hl			;8c13	e5 	. 
l8c14h:
	ld b,c			;8c14	41 	A 
	ld (hl),e			;8c15	73 	s 
	ld (hl),e			;8c16	73 	s 
	ld h,l			;8c17	65 	e 
	ld l,l			;8c18	6d 	m 
	ld h,d			;8c19	62 	b 
	ld l,h			;8c1a	6c 	l 
	ld a,c			;8c1b	79 	y 
	jr nz,l8c81h		;8c1c	20 63 	  c 
	ld l,a			;8c1e	6f 	o 
	ld l,l			;8c1f	6d 	m 
	ld (hl),b			;8c20	70 	p 
	ld l,h			;8c21	6c 	l 
l8c22h:
	ld h,l			;8c22	65 	e 
	ld (hl),h			;8c23	74 	t 
	push hl			;8c24	e5 	. 
l8c25h:
	ld d,e			;8c25	53 	S 
	ld (hl),h			;8c26	74 	t 
	ld h,c			;8c27	61 	a 
	ld (hl),d			;8c28	72 	r 
	ld (hl),h			;8c29	74 	t 
	jr nz,l8ca0h		;8c2a	20 74 	  t 
l8c2ch:
	ld h,c			;8c2c	61 	a 
	ld (hl),b			;8c2d	70 	p 
	push hl			;8c2e	e5 	. 
	ld d,h			;8c2f	54 	T 
	ld h,c			;8c30	61 	a 
	ld (hl),b			;8c31	70 	p 
	ld h,l			;8c32	65 	e 
l8c33h:
	jr nz,l8c9ah		;8c33	20 65 	  e 
l8c35h:
	ld (hl),d			;8c35	72 	r 
	ld (hl),d			;8c36	72 	r 
	ld l,a			;8c37	6f 	o 
	jp p,l6e41h		;8c38	f2 41 6e 	. A n 
	ld a,c			;8c3b	79 	y 
	jr nz,l8ca9h		;8c3c	20 6b 	  k 
	ld h,l			;8c3e	65 	e 
	ld sp,hl			;8c3f	f9 	. 
	jr z,l8c85h		;8c40	28 43 	( C 
	add hl,hl			;8c42	29 	) 
	jr nz,l8c7eh		;8c43	20 39 	  9 
	jr nc,l8c67h		;8c45	30 20 	0   
	ld d,l			;8c47	55 	U 
l8c48h:
	ld c,(hl)			;8c48	4e 	N 
l8c49h:
	ld c,c			;8c49	49 	I 
	ld d,(hl)			;8c4a	56 	V 
	ld b,l			;8c4b	45 	E 
	ld d,d			;8c4c	52 	R 
	ld d,e			;8c4d	53 	S 
	ld d,l			;8c4e	55 	U 
	call sub_6f53h		;8c4f	cd 53 6f 	. S o 
	ld (hl),l			;8c52	75 	u 
	ld (hl),d			;8c53	72 	r 
	ld h,e			;8c54	63 	c 
	ld h,l			;8c55	65 	e 
	jr nz,l8c9dh		;8c56	20 45 	  E 
	ld d,d			;8c58	52 	R 
	ld d,d			;8c59	52 	R 
	ld c,a			;8c5a	4f 	O 
	jp nc,06f46h		;8c5b	d2 46 6f 	. F o 
	ld (hl),l			;8c5e	75 	u 
	ld l,(hl)			;8c5f	6e 	n 
	ld h,h			;8c60	64 	d 
	cp d			;8c61	ba 	. 
	ld b,c			;8c62	41 	A 
	ld l,h			;8c63	6c 	l 
	ld (hl),d			;8c64	72 	r 
	ld h,l			;8c65	65 	e 
	ld h,c			;8c66	61 	a 
l8c67h:
	ld h,h			;8c67	64 	d 
	ld a,c			;8c68	79 	y 
	jr nz,$+102		;8c69	20 64 	  d 
	ld h,l			;8c6b	65 	e 
	ld h,(hl)			;8c6c	66 	f 
	ld l,c			;8c6d	69 	i 
	ld l,(hl)			;8c6e	6e 	n 
	ld h,l			;8c6f	65 	e 
	call po,04e45h		;8c70	e4 45 4e 	. E N 
	ld d,h			;8c73	54 	T 
	jr nz,l8c35h		;8c74	20 bf 	  . 
l8c76h:
	nop			;8c76	00 	. 
	ld c,l			;8c77	4d 	M 
l8c78h:
	ld c,l			;8c78	4d 	M 
	ld c,(hl)			;8c79	4e 	N 
	ld c,a			;8c7a	4f 	O 
	ld d,b			;8c7b	50 	P 
	ld d,c			;8c7c	51 	Q 
	ld d,d			;8c7d	52 	R 
l8c7eh:
	ld d,e			;8c7e	53 	S 
l8c7fh:
	ld d,h			;8c7f	54 	T 
	ld d,l			;8c80	55 	U 
l8c81h:
	ld d,(hl)			;8c81	56 	V 
	ld d,a			;8c82	57 	W 
	ld e,b			;8c83	58 	X 
	ld e,c			;8c84	59 	Y 
l8c85h:
	ld e,e			;8c85	5b 	[ 
	ld e,l			;8c86	5d 	] 
	ld e,a			;8c87	5f 	_ 
	ld h,c			;8c88	61 	a 
	ld h,e			;8c89	63 	c 
	ld h,l			;8c8a	65 	e 
	ld h,a			;8c8b	67 	g 
	ld l,c			;8c8c	69 	i 
	ld l,e			;8c8d	6b 	k 
	ld l,l			;8c8e	6d 	m 
	ld l,a			;8c8f	6f 	o 
	ld (hl),c			;8c90	71 	q 
	ld (hl),e			;8c91	73 	s 
	ld (hl),l			;8c92	75 	u 
	ld (hl),a			;8c93	77 	w 
	ld a,c			;8c94	79 	y 
	ld a,e			;8c95	7b 	{ 
	ld a,l			;8c96	7d 	} 
	ld a,a			;8c97	7f 	 
	add a,c			;8c98	81 	. 
	add a,e			;8c99	83 	. 
l8c9ah:
	add a,l			;8c9a	85 	. 
	add a,a			;8c9b	87 	. 
	adc a,c			;8c9c	89 	. 
l8c9dh:
	adc a,e			;8c9d	8b 	. 
	adc a,l			;8c9e	8d 	. 
	adc a,a			;8c9f	8f 	. 
l8ca0h:
	sub c			;8ca0	91 	. 
	sub e			;8ca1	93 	. 
	sub l			;8ca2	95 	. 
	sub a			;8ca3	97 	. 
	sbc a,c			;8ca4	99 	. 
	sbc a,e			;8ca5	9b 	. 
	sbc a,l			;8ca6	9d 	. 
	sbc a,a			;8ca7	9f 	. 
l8ca8h:
	and c			;8ca8	a1 	. 
l8ca9h:
	and e			;8ca9	a3 	. 
	and l			;8caa	a5 	. 
	and a			;8cab	a7 	. 
	xor c			;8cac	a9 	. 
	xor e			;8cad	ab 	. 
	xor (hl)			;8cae	ae 	. 
	or c			;8caf	b1 	. 
	or h			;8cb0	b4 	. 
	or a			;8cb1	b7 	. 
	cp d			;8cb2	ba 	. 
	cp l			;8cb3	bd 	. 
	ret nz			;8cb4	c0 	. 
	jp 0c9c6h		;8cb5	c3 c6 c9 	. . . 
	call z,0d2cfh		;8cb8	cc cf d2 	. . . 
	push de			;8cbb	d5 	. 
	ret c			;8cbc	d8 	. 
	in a,(0deh)		;8cbd	db de 	. . 
	pop hl			;8cbf	e1 	. 
	call po,0eae7h		;8cc0	e4 e7 ea 	. . . 
	otdr		;8cc3	ed bb 	. . 
	ld h,e			;8cc5	63 	c 
	ret p			;8cc6	f0 	. 
	ld h,h			;8cc7	64 	d 
	jp (hl)			;8cc8	e9 	. 
	ld h,l			;8cc9	65 	e 
	jp (hl)			;8cca	e9 	. 
	ld h,l			;8ccb	65 	e 
	ret m			;8ccc	f8 	. 
	ld l,c			;8ccd	69 	i 
	out (c),l		;8cce	ed 69 	. i 
	xor 06ah		;8cd0	ee 6a 	. j 
	ret p			;8cd2	f0 	. 
	ld l,d			;8cd3	6a 	j 
	jp p,0e46ch		;8cd4	f2 6c e4 	. l . 
	ld l,a			;8cd7	6f 	o 
	jp p,0ec72h		;8cd8	f2 72 ec 	. r . 
	ld (hl),d			;8cdb	72 	r 
	jp p,06461h		;8cdc	f2 61 64 	. a d 
	ex (sp),hl			;8cdf	e3 	. 
	ld h,c			;8ce0	61 	a 
	ld h,h			;8ce1	64 	d 
	call po,sub_6e61h		;8ce2	e4 61 6e 	. a n 
	call po,sub_6962h		;8ce5	e4 62 69 	. b i 
	call p,sub_6363h		;8ce8	f4 63 63 	. c c 
	and 063h		;8ceb	e6 63 	. c 
	ld (hl),b			;8ced	70 	p 
	call po,sub_7063h		;8cee	e4 63 70 	. c p 
	jp (hl)			;8cf1	e9 	. 
	ld h,e			;8cf2	63 	c 
	ld (hl),b			;8cf3	70 	p 
	call pe,l6163h+1		;8cf4	ec 64 61 	. d a 
	pop hl			;8cf7	e1 	. 
	ld h,h			;8cf8	64 	d 
	ld h,l			;8cf9	65 	e 
	ex (sp),hl			;8cfa	e3 	. 
	ld h,l			;8cfb	65 	e 
	ld l,(hl)			;8cfc	6e 	n 
	call p,sub_7165h		;8cfd	f4 65 71 	. e q 
	push af			;8d00	f5 	. 
	ld h,l			;8d01	65 	e 
	ld a,b			;8d02	78 	x 
	ret m			;8d03	f8 	. 
	ld l,c			;8d04	69 	i 
	ld l,(hl)			;8d05	6e 	n 
	ex (sp),hl			;8d06	e3 	. 
	ld l,c			;8d07	69 	i 
	ld l,(hl)			;8d08	6e 	n 
	call po,sub_6e69h		;8d09	e4 69 6e 	. i n 
	jp (hl)			;8d0c	e9 	. 
	ld l,h			;8d0d	6c 	l 
	ld h,h			;8d0e	64 	d 
	call po,sub_646ch		;8d0f	e4 6c 64 	. l d 
	jp (hl)			;8d12	e9 	. 
	ld l,(hl)			;8d13	6e 	n 
	ld h,l			;8d14	65 	e 
	rst 20h			;8d15	e7 	. 
	ld l,(hl)			;8d16	6e 	n 
	ld l,a			;8d17	6f 	o 
	ret p			;8d18	f0 	. 
	ld l,a			;8d19	6f 	o 
	ld (hl),d			;8d1a	72 	r 
	rst 20h			;8d1b	e7 	. 
	ld l,a			;8d1c	6f 	o 
	ld (hl),l			;8d1d	75 	u 
	call p,sub_6f6fh+1		;8d1e	f4 70 6f 	. p o 
	ret p			;8d21	f0 	. 
	ld (hl),b			;8d22	70 	p 
	ld (hl),l			;8d23	75 	u 
	call p,sub_6572h		;8d24	f4 72 65 	. r e 
	di			;8d27	f3 	. 
	ld (hl),d			;8d28	72 	r 
	ld h,l			;8d29	65 	e 
	call p,06c72h		;8d2a	f4 72 6c 	. r l 
	pop hl			;8d2d	e1 	. 
	ld (hl),d			;8d2e	72 	r 
	ld l,h			;8d2f	6c 	l 
	ex (sp),hl			;8d30	e3 	. 
	ld (hl),d			;8d31	72 	r 
	ld l,h			;8d32	6c 	l 
	call po,sub_7272h		;8d33	e4 72 72 	. r r 
	pop hl			;8d36	e1 	. 
	ld (hl),d			;8d37	72 	r 
	ld (hl),d			;8d38	72 	r 
	ex (sp),hl			;8d39	e3 	. 
	ld (hl),d			;8d3a	72 	r 
	ld (hl),d			;8d3b	72 	r 
	call po,07372h		;8d3c	e4 72 73 	. r s 
	call p,06273h		;8d3f	f4 73 62 	. s b 
	ex (sp),hl			;8d42	e3 	. 
	ld (hl),e			;8d43	73 	s 
	ld h,e			;8d44	63 	c 
	and 073h		;8d45	e6 73 	. s 
	ld h,l			;8d47	65 	e 
	call p,l6c73h		;8d48	f4 73 6c 	. s l 
	pop hl			;8d4b	e1 	. 
	ld (hl),e			;8d4c	73 	s 
	ld (hl),d			;8d4d	72 	r 
	pop hl			;8d4e	e1 	. 
	ld (hl),e			;8d4f	73 	s 
	ld (hl),d			;8d50	72 	r 
	call pe,sub_7573h		;8d51	ec 73 75 	. s u 
	jp po,l6f78h		;8d54	e2 78 6f 	. x o 
	jp p,l6163h		;8d57	f2 63 61 	. c a 
	ld l,h			;8d5a	6c 	l 
	call pe,sub_7063h		;8d5b	ec 63 70 	. c p 
	ld h,h			;8d5e	64 	d 
	jp p,sub_7063h		;8d5f	f2 63 70 	. c p 
	ld l,c			;8d62	69 	i 
	jp p,06564h		;8d63	f2 64 65 	. d e 
	ld h,(hl)			;8d66	66 	f 
	jp po,06564h		;8d67	e2 64 65 	. d e 
	ld h,(hl)			;8d6a	66 	f 
	defb 0edh;next byte illegal after ed		;8d6b	ed 	. 
	ld h,h			;8d6c	64 	d 
	ld h,l			;8d6d	65 	e 
	ld h,(hl)			;8d6e	66 	f 
l8d6fh:
	di			;8d6f	f3 	. 
	ld h,h			;8d70	64 	d 
	ld h,l			;8d71	65 	e 
	ld h,(hl)			;8d72	66 	f 
	rst 30h			;8d73	f7 	. 
	ld h,h			;8d74	64 	d 
	ld l,d			;8d75	6a 	j 
	ld l,(hl)			;8d76	6e 	n 
	jp m,06168h		;8d77	fa 68 61 	. h a 
	ld l,h			;8d7a	6c 	l 
	call p,sub_6e69h		;8d7b	f4 69 6e 	. i n 
	ld h,h			;8d7e	64 	d 
	jp p,sub_6e69h		;8d7f	f2 69 6e 	. i n 
	ld l,c			;8d82	69 	i 
	jp p,sub_646ch		;8d83	f2 6c 64 	. l d 
	ld h,h			;8d86	64 	d 
	jp p,sub_646ch		;8d87	f2 6c 64 	. l d 
	ld l,c			;8d8a	69 	i 
	jp p,0746fh		;8d8b	f2 6f 74 	. o t 
	ld h,h			;8d8e	64 	d 
	jp p,0746fh		;8d8f	f2 6f 74 	. o t 
	ld l,c			;8d92	69 	i 
	jp p,0756fh		;8d93	f2 6f 75 	. o u 
	ld (hl),h			;8d96	74 	t 
	call po,0756fh		;8d97	e4 6f 75 	. o u 
	ld (hl),h			;8d9a	74 	t 
	jp (hl)			;8d9b	e9 	. 
	ld (hl),b			;8d9c	70 	p 
	ld (hl),l			;8d9d	75 	u 
	ld (hl),e			;8d9e	73 	s 
	ret pe			;8d9f	e8 	. 
	ld (hl),d			;8da0	72 	r 
	ld h,l			;8da1	65 	e 
	ld (hl),h			;8da2	74 	t 
	jp (hl)			;8da3	e9 	. 
	ld (hl),d			;8da4	72 	r 
	ld h,l			;8da5	65 	e 
	ld (hl),h			;8da6	74 	t 
	xor 072h		;8da7	ee 72 	. r 
	ld l,h			;8da9	6c 	l 
	ld h,e			;8daa	63 	c 
	pop hl			;8dab	e1 	. 
	ld (hl),d			;8dac	72 	r 
	ld (hl),d			;8dad	72 	r 
	ld h,e			;8dae	63 	c 
	pop hl			;8daf	e1 	. 
	ld (hl),e			;8db0	73 	s 
	ld l,h			;8db1	6c 	l 
	ld l,c			;8db2	69 	i 
	pop hl			;8db3	e1 	. 
l8db4h:
	jr nz,l8de1h		;8db4	20 2b 	  + 
	dec hl			;8db6	2b 	+ 
	dec hl			;8db7	2b 	+ 
	dec hl			;8db8	2b 	+ 
	dec hl			;8db9	2b 	+ 
	dec hl			;8dba	2b 	+ 
	dec hl			;8dbb	2b 	+ 
	dec hl			;8dbc	2b 	+ 
	dec hl			;8dbd	2b 	+ 
	dec hl			;8dbe	2b 	+ 
	dec hl			;8dbf	2b 	+ 
	dec hl			;8dc0	2b 	+ 
	dec hl			;8dc1	2b 	+ 
	dec hl			;8dc2	2b 	+ 
	dec hl			;8dc3	2b 	+ 
	dec hl			;8dc4	2b 	+ 
	dec hl			;8dc5	2b 	+ 
	dec hl			;8dc6	2b 	+ 
	dec hl			;8dc7	2b 	+ 
l8dc8h:
	dec hl			;8dc8	2b 	+ 
	dec hl			;8dc9	2b 	+ 
	inc l			;8dca	2c 	, 
	dec l			;8dcb	2d 	- 
	ld l,02fh		;8dcc	2e 2f 	. / 
	jr nc,l8e01h		;8dce	30 31 	0 1 
	ld (03433h),a		;8dd0	32 33 34 	2 3 4 
	dec (hl)			;8dd3	35 	5 
	ld (hl),037h		;8dd4	36 37 	6 7 
	jr c,l8e11h		;8dd6	38 39 	8 9 
	ld a,(03e3ch)		;8dd8	3a 3c 3e 	: < > 
	ld b,c			;8ddb	41 	A 
	ld b,h			;8ddc	44 	D 
	ld b,a			;8ddd	47 	G 
	ld c,d			;8dde	4a 	J 
	ld c,l			;8ddf	4d 	M 
	or b			;8de0	b0 	. 
l8de1h:
	or c			;8de1	b1 	. 
	or d			;8de2	b2 	. 
	or e			;8de3	b3 	. 
	or h			;8de4	b4 	. 
	or l			;8de5	b5 	. 
	or (hl)			;8de6	b6 	. 
	or a			;8de7	b7 	. 
	pop hl			;8de8	e1 	. 
	jp po,0e4e3h		;8de9	e2 e3 e4 	. . . 
	push hl			;8dec	e5 	. 
	ret pe			;8ded	e8 	. 
	jp (hl)			;8dee	e9 	. 
	call pe,0f0edh		;8def	ec ed f0 	. . . 
	jp p,l61f9h+1		;8df2	f2 fa 61 	. . a 
	and 062h		;8df5	e6 62 	. b 
	ex (sp),hl			;8df7	e3 	. 
	ld h,h			;8df8	64 	d 
	push hl			;8df9	e5 	. 
	ld l,b			;8dfa	68 	h 
	call pe,0f868h		;8dfb	ec 68 f8 	. h . 
	ld l,b			;8dfe	68 	h 
	ld sp,hl			;8dff	f9 	. 
	ld l,c			;8e00	69 	i 
l8e01h:
	ret m			;8e01	f8 	. 
	ld l,c			;8e02	69 	i 
	ld sp,hl			;8e03	f9 	. 
	ld l,h			;8e04	6c 	l 
	ret m			;8e05	f8 	. 
	ld l,h			;8e06	6c 	l 
	ld sp,hl			;8e07	f9 	. 
	ld l,(hl)			;8e08	6e 	n 
	ex (sp),hl			;8e09	e3 	. 
	ld l,(hl)			;8e0a	6e 	n 
	jp m,0e570h		;8e0b	fa 70 e5 	. p . 
	ld (hl),b			;8e0e	70 	p 
	rst 28h			;8e0f	ef 	. 
	ld (hl),e			;8e10	73 	s 
l8e11h:
	ret p			;8e11	f0 	. 
	jr z,l8e77h		;8e12	28 63 	( c 
	xor c			;8e14	a9 	. 
	ld h,c			;8e15	61 	a 
	ld h,(hl)			;8e16	66 	f 
	and a			;8e17	a7 	. 
	jr z,$+100		;8e18	28 62 	( b 
	ld h,e			;8e1a	63 	c 
	xor c			;8e1b	a9 	. 
	jr z,l8e82h		;8e1c	28 64 	( d 
	ld h,l			;8e1e	65 	e 
	xor c			;8e1f	a9 	. 
	jr z,l8e8ah		;8e20	28 68 	( h 
	ld l,h			;8e22	6c 	l 
	xor c			;8e23	a9 	. 
	jr z,l8e8fh		;8e24	28 69 	( i 
	ld a,b			;8e26	78 	x 
	xor c			;8e27	a9 	. 
	jr z,l8e93h		;8e28	28 69 	( i 
	ld a,c			;8e2a	79 	y 
	xor c			;8e2b	a9 	. 
	jr z,l8ea1h		;8e2c	28 73 	( s 
	ld (hl),b			;8e2e	70 	p 
	xor c			;8e2f	a9 	. 
	ld a,(de)			;8e30	1a 	. 
	ld hl,02825h		;8e31	21 25 28 	! % ( 
	daa			;8e34	27 	' 
	inc l			;8e35	2c 	, 
	cpl			;8e36	2f 	/ 
	ld l,02dh		;8e37	2e 2d 	. - 
	inc l			;8e39	2c 	, 
	dec hl			;8e3a	2b 	+ 
	ld l,031h		;8e3b	2e 31 	. 1 
	scf			;8e3d	37 	7 
	ld (hl),038h		;8e3e	36 38 	6 8 
	inc a			;8e40	3c 	< 
	ccf			;8e41	3f 	? 
	ld b,c			;8e42	41 	A 
	ld b,h			;8e43	44 	D 
	ld c,b			;8e44	48 	H 
	ld c,h			;8e45	4c 	L 
	ld c,e			;8e46	4b 	K 
	ld d,b			;8e47	50 	P 
	ld c,a			;8e48	4f 	O 
	ld d,e			;8e49	53 	S 
	ld b,c			;8e4a	41 	A 
	ld d,e			;8e4b	53 	S 
	ld d,e			;8e4c	53 	S 
	ld b,l			;8e4d	45 	E 
	ld c,l			;8e4e	4d 	M 
	ld b,d			;8e4f	42 	B 
	ld c,h			;8e50	4c 	L 
	exx			;8e51	d9 	. 
	ld b,d			;8e52	42 	B 
	ld b,c			;8e53	41 	A 
	ld d,e			;8e54	53 	S 
	ld c,c			;8e55	49 	I 
	jp 04f43h		;8e56	c3 43 4f 	. C O 
	ld d,b			;8e59	50 	P 
	exx			;8e5a	d9 	. 
	ld b,h			;8e5b	44 	D 
	ld b,l			;8e5c	45 	E 
	ld c,h			;8e5d	4c 	L 
	ld b,l			;8e5e	45 	E 
	ld d,h			;8e5f	54 	T 
	push bc			;8e60	c5 	. 
	ld b,(hl)			;8e61	46 	F 
	ld c,c			;8e62	49 	I 
	ld c,(hl)			;8e63	4e 	N 
	call nz,04547h		;8e64	c4 47 45 	. G E 
	ld c,(hl)			;8e67	4e 	N 
	out (04ch),a		;8e68	d3 4c 	. L 
	ld c,a			;8e6a	4f 	O 
	ld b,c			;8e6b	41 	A 
	call nz,04f4dh		;8e6c	c4 4d 4f 	. M O 
	ld c,(hl)			;8e6f	4e 	N 
	ld c,c			;8e70	49 	I 
	ld d,h			;8e71	54 	T 
	ld c,a			;8e72	4f 	O 
	jp nc,0454eh		;8e73	d2 4e 45 	. N E 
	rst 10h			;8e76	d7 	. 
l8e77h:
	ld d,b			;8e77	50 	P 
	ld d,d			;8e78	52 	R 
	ld c,c			;8e79	49 	I 
	ld c,(hl)			;8e7a	4e 	N 
	call nc,05551h		;8e7b	d4 51 55 	. Q U 
	ld c,c			;8e7e	49 	I 
	call nc,05552h		;8e7f	d4 52 55 	. R U 
l8e82h:
	adc a,053h		;8e82	ce 53 	. S 
	ld b,c			;8e84	41 	A 
	ld d,(hl)			;8e85	56 	V 
	push bc			;8e86	c5 	. 
	ld d,h			;8e87	54 	T 
	ld b,c			;8e88	41 	A 
	ld b,d			;8e89	42 	B 
l8e8ah:
	ld c,h			;8e8a	4c 	L 
	push bc			;8e8b	c5 	. 
	ld d,l			;8e8c	55 	U 
	dec l			;8e8d	2d 	- 
	ld d,h			;8e8e	54 	T 
l8e8fh:
	ld c,a			;8e8f	4f 	O 
	ret nc			;8e90	d0 	. 
	ld d,(hl)			;8e91	56 	V 
	ld b,l			;8e92	45 	E 
l8e93h:
	ld d,d			;8e93	52 	R 
	ld c,c			;8e94	49 	I 
	ld b,(hl)			;8e95	46 	F 
	exx			;8e96	d9 	. 
	ld b,e			;8e97	43 	C 
	ld c,h			;8e98	4c 	L 
	ld b,l			;8e99	45 	E 
	ld b,c			;8e9a	41 	A 
	jp nc,04552h		;8e9b	d2 52 45 	. R E 
	ld d,b			;8e9e	50 	P 
	ld c,h			;8e9f	4c 	L 
	ld b,c			;8ea0	41 	A 
l8ea1h:
	ld b,e			;8ea1	43 	C 
	push bc			;8ea2	c5 	. 
	nop			;8ea3	00 	. 
	nop			;8ea4	00 	. 
	ld b,d			;8ea5	42 	B 
	nop			;8ea6	00 	. 
	inc b			;8ea7	04 	. 
	nop			;8ea8	00 	. 
	jr nc,l8eabh		;8ea9	30 00 	0 . 
l8eabh:
	nop			;8eab	00 	. 
	nop			;8eac	00 	. 
	nop			;8ead	00 	. 
	add a,b			;8eae	80 	. 
	ld d,d			;8eaf	52 	R 
	ld d,b			;8eb0	50 	P 
	ex af,af'			;8eb1	08 	. 
	ld bc,01402h		;8eb2	01 02 14 	. . . 
	or l			;8eb5	b5 	. 
	adc a,d			;8eb6	8a 	. 
	ld bc,00237h		;8eb7	01 37 02 	. 7 . 
	nop			;8eba	00 	. 
	nop			;8ebb	00 	. 
	ld bc,05280h		;8ebc	01 80 52 	. . R 
	ld e,b			;8ebf	58 	X 
	ex af,af'			;8ec0	08 	. 
	ld (bc),a			;8ec1	02 	. 
	nop			;8ec2	00 	. 
	dec d			;8ec3	15 	. 
	ld sp,00227h		;8ec4	31 27 02 	1 ' . 
	scf			;8ec7	37 	7 
	ld sp,00060h		;8ec8	31 60 00 	1 ` . 
	ld (bc),a			;8ecb	02 	. 
	add a,b			;8ecc	80 	. 
	ld d,d			;8ecd	52 	R 
	ld h,b			;8ece	60 	` 
	ex af,af'			;8ecf	08 	. 
	inc bc			;8ed0	03 	. 
	nop			;8ed1	00 	. 
	ld (hl),0b0h		;8ed2	36 b0 	6 . 
	ld b,003h		;8ed4	06 03 	. . 
	scf			;8ed6	37 	7 
	inc sp			;8ed7	33 	3 
	ld h,b			;8ed8	60 	` 
	nop			;8ed9	00 	. 
	inc bc			;8eda	03 	. 
	add a,b			;8edb	80 	. 
	ld d,d			;8edc	52 	R 
	ld l,b			;8edd	68 	h 
	ex af,af'			;8ede	08 	. 
	inc b			;8edf	04 	. 
	nop			;8ee0	00 	. 
	ld (hl),050h		;8ee1	36 50 	6 P 
	inc b			;8ee3	04 	. 
	inc b			;8ee4	04 	. 
	scf			;8ee5	37 	7 
	ld b,l			;8ee6	45 	E 
	ld h,b			;8ee7	60 	` 
	nop			;8ee8	00 	. 
	inc b			;8ee9	04 	. 
	add a,b			;8eea	80 	. 
	ld d,d			;8eeb	52 	R 
	ld (hl),b			;8eec	70 	p 
	ex af,af'			;8eed	08 	. 
	dec b			;8eee	05 	. 
	nop			;8eef	00 	. 
	ld l,050h		;8ef0	2e 50 	. P 
	inc b			;8ef2	04 	. 
	dec b			;8ef3	05 	. 
	scf			;8ef4	37 	7 
	ld c,e			;8ef5	4b 	K 
	ld h,b			;8ef6	60 	` 
	nop			;8ef7	00 	. 
	dec b			;8ef8	05 	. 
	add a,b			;8ef9	80 	. 
	ld d,d			;8efa	52 	R 
	add a,b			;8efb	80 	. 
	ex af,af'			;8efc	08 	. 
	ld b,001h		;8efd	06 01 	. . 
	inc d			;8eff	14 	. 
	ld d,l			;8f00	55 	U 
	add a,a			;8f01	87 	. 
	ld b,037h		;8f02	06 37 	. 7 
	ld (hl),h			;8f04	74 	t 
	nop			;8f05	00 	. 
	nop			;8f06	00 	. 
	ld b,080h		;8f07	06 80 	. . 
	ld d,e			;8f09	53 	S 
	ld b,b			;8f0a	40 	@ 
l8f0bh:
	rrca			;8f0b	0f 	. 
	ld b,0a4h		;8f0c	06 a4 	. . 
	ld d,e			;8f0e	53 	S 
	ld (hl),b			;8f0f	70 	p 
	rla			;8f10	17 	. 
	rlca			;8f11	07 	. 
	nop			;8f12	00 	. 
	sub (hl)			;8f13	96 	. 
	nop			;8f14	00 	. 
	inc b			;8f15	04 	. 
	rlca			;8f16	07 	. 
	scf			;8f17	37 	7 
	halt			;8f18	76 	v 
	nop			;8f19	00 	. 
	nop			;8f1a	00 	. 
	rlca			;8f1b	07 	. 
	add a,b			;8f1c	80 	. 
	ld d,d			;8f1d	52 	R 
	ld c,b			;8f1e	48 	H 
	ex af,af'			;8f1f	08 	. 
	ex af,af'			;8f20	08 	. 
	nop			;8f21	00 	. 
l8f22h:
	ld a,(bc)			;8f22	0a 	. 
	xor h			;8f23	ac 	. 
	and h			;8f24	a4 	. 
	ex af,af'			;8f25	08 	. 
	scf			;8f26	37 	7 
	ld a,b			;8f27	78 	x 
	nop			;8f28	00 	. 
	nop			;8f29	00 	. 
	ex af,af'			;8f2a	08 	. 
	add a,b			;8f2b	80 	. 
	ld e,b			;8f2c	58 	X 
	ld d,b			;8f2d	50 	P 
	ex af,af'			;8f2e	08 	. 
	add hl,bc			;8f2f	09 	. 
	nop			;8f30	00 	. 
	ld e,0c2h		;8f31	1e c2 	. . 
	rrc c		;8f33	cb 09 	. . 
	jr nz,l8f55h		;8f35	20 1e 	  . 
	jp c,009cfh		;8f37	da cf 09 	. . . 
	scf			;8f3a	37 	7 
	ld a,d			;8f3b	7a 	z 
	nop			;8f3c	00 	. 
	nop			;8f3d	00 	. 
	add hl,bc			;8f3e	09 	. 
l8f3fh:
	add a,b			;8f3f	80 	. 
	ld e,b			;8f40	58 	X 
	ld e,b			;8f41	58 	X 
	ex af,af'			;8f42	08 	. 
	ld a,(bc)			;8f43	0a 	. 
	nop			;8f44	00 	. 
	inc d			;8f45	14 	. 
	ld c,h			;8f46	4c 	L 
	rst 0			;8f47	c7 	. 
	ld a,(bc)			;8f48	0a 	. 
	add a,b			;8f49	80 	. 
	ld e,b			;8f4a	58 	X 
	ld h,b			;8f4b	60 	` 
	ex af,af'			;8f4c	08 	. 
	dec bc			;8f4d	0b 	. 
	nop			;8f4e	00 	. 
	ld l,0b0h		;8f4f	2e b0 	. . 
	ld b,00bh		;8f51	06 0b 	. . 
	add a,b			;8f53	80 	. 
	ld e,b			;8f54	58 	X 
l8f55h:
	ld l,b			;8f55	68 	h 
	ex af,af'			;8f56	08 	. 
	inc c			;8f57	0c 	. 
	nop			;8f58	00 	. 
	ld (hl),058h		;8f59	36 58 	6 X 
	inc b			;8f5b	04 	. 
	inc c			;8f5c	0c 	. 
	add a,b			;8f5d	80 	. 
	ld e,b			;8f5e	58 	X 
	ld (hl),b			;8f5f	70 	p 
l8f60h:
	ex af,af'			;8f60	08 	. 
	dec c			;8f61	0d 	. 
	nop			;8f62	00 	. 
	ld l,058h		;8f63	2e 58 	. X 
	inc b			;8f65	04 	. 
	dec c			;8f66	0d 	. 
	add a,b			;8f67	80 	. 
	ld e,b			;8f68	58 	X 
	add a,b			;8f69	80 	. 
	ex af,af'			;8f6a	08 	. 
	ld c,001h		;8f6b	0e 01 	. . 
	inc d			;8f6d	14 	. 
	ld e,l			;8f6e	5d 	] 
	add a,a			;8f6f	87 	. 
	ld c,080h		;8f70	0e 80 	. . 
	ld e,c			;8f72	59 	Y 
	ld b,b			;8f73	40 	@ 
	rrca			;8f74	0f 	. 
	ld c,0a4h		;8f75	0e a4 	. . 
	ld e,c			;8f77	59 	Y 
	ld (hl),b			;8f78	70 	p 
	rla			;8f79	17 	. 
	rrca			;8f7a	0f 	. 
	nop			;8f7b	00 	. 
	sbc a,b			;8f7c	98 	. 
	nop			;8f7d	00 	. 
	inc b			;8f7e	04 	. 
	rrca			;8f7f	0f 	. 
	add a,b			;8f80	80 	. 
	ld e,b			;8f81	58 	X 
	ld c,b			;8f82	48 	H 
	ex af,af'			;8f83	08 	. 
	djnz l8f89h		;8f84	10 03 	. . 
	ld a,l			;8f86	7d 	} 
	ld h,b			;8f87	60 	` 
	ex af,af'			;8f88	08 	. 
l8f89h:
	djnz l8f0bh		;8f89	10 80 	. . 
	jr l8fddh		;8f8b	18 50 	. P 
	ex af,af'			;8f8d	08 	. 
	ld de,01402h		;8f8e	11 02 14 	. . . 
	cp l			;8f91	bd 	. 
	adc a,d			;8f92	8a 	. 
	ld de,01880h		;8f93	11 80 18 	. . . 
	ld e,b			;8f96	58 	X 
	ex af,af'			;8f97	08 	. 
	ld (de),a			;8f98	12 	. 
	nop			;8f99	00 	. 
	dec d			;8f9a	15 	. 
	add hl,sp			;8f9b	39 	9 
	daa			;8f9c	27 	' 
	ld (de),a			;8f9d	12 	. 
	add a,b			;8f9e	80 	. 
	jr $+98		;8f9f	18 60 	. ` 
	ex af,af'			;8fa1	08 	. 
	inc de			;8fa2	13 	. 
	nop			;8fa3	00 	. 
	ld (hl),0b8h		;8fa4	36 b8 	6 . 
	ld b,013h		;8fa6	06 13 	. . 
	add a,b			;8fa8	80 	. 
	jr $+106		;8fa9	18 68 	. h 
	ex af,af'			;8fab	08 	. 
	inc d			;8fac	14 	. 
	nop			;8fad	00 	. 
	ld (hl),060h		;8fae	36 60 	6 ` 
	inc b			;8fb0	04 	. 
	inc d			;8fb1	14 	. 
	add a,b			;8fb2	80 	. 
	jr $+114		;8fb3	18 70 	. p 
	ex af,af'			;8fb5	08 	. 
	dec d			;8fb6	15 	. 
	nop			;8fb7	00 	. 
	ld l,060h		;8fb8	2e 60 	. ` 
l8fbah:
	inc b			;8fba	04 	. 
	dec d			;8fbb	15 	. 
	add a,b			;8fbc	80 	. 
	jr l8f3fh		;8fbd	18 80 	. . 
	ex af,af'			;8fbf	08 	. 
	ld d,001h		;8fc0	16 01 	. . 
	inc d			;8fc2	14 	. 
	ld h,l			;8fc3	65 	e 
	add a,a			;8fc4	87 	. 
	ld d,080h		;8fc5	16 80 	. . 
	add hl,de			;8fc7	19 	. 
	ld b,b			;8fc8	40 	@ 
	rrca			;8fc9	0f 	. 
	ld d,0a4h		;8fca	16 a4 	. . 
	add hl,de			;8fcc	19 	. 
	ld (hl),b			;8fcd	70 	p 
	rla			;8fce	17 	. 
	rla			;8fcf	17 	. 
	nop			;8fd0	00 	. 
	ld d,b			;8fd1	50 	P 
	nop			;8fd2	00 	. 
	inc b			;8fd3	04 	. 
	rla			;8fd4	17 	. 
	add a,b			;8fd5	80 	. 
	jr $+74		;8fd6	18 48 	. H 
	ex af,af'			;8fd8	08 	. 
	jr l8fdeh		;8fd9	18 03 	. . 
	inc de			;8fdb	13 	. 
	ld h,b			;8fdc	60 	` 
l8fddh:
	rlca			;8fdd	07 	. 
l8fdeh:
	jr l8f60h		;8fde	18 80 	. . 
	ld a,(de)			;8fe0	1a 	. 
	ld d,b			;8fe1	50 	P 
	ex af,af'			;8fe2	08 	. 
	add hl,de			;8fe3	19 	. 
	nop			;8fe4	00 	. 
	ld e,0c2h		;8fe5	1e c2 	. . 
	ex de,hl			;8fe7	eb 	. 
	add hl,de			;8fe8	19 	. 
	jr nz,$+32		;8fe9	20 1e 	  . 
	jp c,019efh		;8feb	da ef 19 	. . . 
	add a,b			;8fee	80 	. 
	ld a,(de)			;8fef	1a 	. 
	ld e,b			;8ff0	58 	X 
	ex af,af'			;8ff1	08 	. 
	ld a,(de)			;8ff2	1a 	. 
	nop			;8ff3	00 	. 
	inc d			;8ff4	14 	. 
	ld c,h			;8ff5	4c 	L 
	rst 20h			;8ff6	e7 	. 
	ld a,(de)			;8ff7	1a 	. 
	add a,b			;8ff8	80 	. 
	ld a,(de)			;8ff9	1a 	. 
	ld h,b			;8ffa	60 	` 
	ex af,af'			;8ffb	08 	. 
	dec de			;8ffc	1b 	. 
	nop			;8ffd	00 	. 
	ld l,0b8h		;8ffe	2e b8 	. . 
	ld b,01bh		;9000	06 1b 	. . 
	add a,b			;9002	80 	. 
	ld a,(de)			;9003	1a 	. 
	ld l,b			;9004	68 	h 
	ex af,af'			;9005	08 	. 
	inc e			;9006	1c 	. 
	nop			;9007	00 	. 
	ld (hl),068h		;9008	36 68 	6 h 
	inc b			;900a	04 	. 
	inc e			;900b	1c 	. 
	add a,b			;900c	80 	. 
	ld a,(de)			;900d	1a 	. 
	ld (hl),b			;900e	70 	p 
	ex af,af'			;900f	08 	. 
	dec e			;9010	1d 	. 
	nop			;9011	00 	. 
	ld l,068h		;9012	2e 68 	. h 
	inc b			;9014	04 	. 
	dec e			;9015	1d 	. 
	add a,b			;9016	80 	. 
	ld a,(de)			;9017	1a 	. 
	add a,b			;9018	80 	. 
	ex af,af'			;9019	08 	. 
	ld e,001h		;901a	1e 01 	. . 
	inc d			;901c	14 	. 
	ld l,l			;901d	6d 	m 
	add a,a			;901e	87 	. 
	ld e,080h		;901f	1e 80 	. . 
	dec de			;9021	1b 	. 
	ld b,b			;9022	40 	@ 
	rrca			;9023	0f 	. 
	ld e,0a4h		;9024	1e a4 	. . 
	dec de			;9026	1b 	. 
	ld (hl),b			;9027	70 	p 
l9028h:
	rla			;9028	17 	. 
	rra			;9029	1f 	. 
	nop			;902a	00 	. 
	ld d,(hl)			;902b	56 	V 
	nop			;902c	00 	. 
l902dh:
	inc b			;902d	04 	. 
	rra			;902e	1f 	. 
	add a,b			;902f	80 	. 
	ld a,(de)			;9030	1a 	. 
	ld c,b			;9031	48 	H 
	ex af,af'			;9032	08 	. 
	jr nz,l9038h		;9033	20 03 	  . 
	inc de			;9035	13 	. 
	dec b			;9036	05 	. 
	add a,a			;9037	87 	. 
l9038h:
	jr nz,l8fbah		;9038	20 80 	  . 
	ld h,h			;903a	64 	d 
	ld d,b			;903b	50 	P 
	ex af,af'			;903c	08 	. 
	ld hl,01402h		;903d	21 02 14 	! . . 
	push bc			;9040	c5 	. 
	adc a,d			;9041	8a 	. 
	ld hl,01422h		;9042	21 22 14 	! " . 
	adc a,(ix+021h)		;9045	dd 8e 21 	. . ! 
	add a,b			;9048	80 	. 
	ld h,h			;9049	64 	d 
	ld e,b			;904a	58 	X 
	ex af,af'			;904b	08 	. 
	ld (01502h),hl		;904c	22 02 15 	" . . 
	ld l,e			;904f	6b 	k 
	djnz l9074h		;9050	10 22 	. " 
	ld (l6b15h),hl		;9052	22 15 6b 	" . k 
	ld (hl),h			;9055	74 	t 
	ld (l6480h),hl		;9056	22 80 64 	" . d 
	ld h,b			;9059	60 	` 
	ex af,af'			;905a	08 	. 
	inc hl			;905b	23 	# 
	nop			;905c	00 	. 
	ld (hl),0c0h		;905d	36 c0 	6 . 
	ld b,023h		;905f	06 23 	. # 
	jr nz,l9099h		;9061	20 36 	  6 
	ret c			;9063	d8 	. 
	ld a,(bc)			;9064	0a 	. 
	inc hl			;9065	23 	# 
	add a,b			;9066	80 	. 
	ld h,h			;9067	64 	d 
	ld l,b			;9068	68 	h 
	ex af,af'			;9069	08 	. 
	inc h			;906a	24 	$ 
	nop			;906b	00 	. 
	ld (hl),070h		;906c	36 70 	6 p 
	inc b			;906e	04 	. 
	inc h			;906f	24 	$ 
	jr nz,l90a8h		;9070	20 36 	  6 
	ret z			;9072	c8 	. 
	ex af,af'			;9073	08 	. 
l9074h:
	inc h			;9074	24 	$ 
	add a,b			;9075	80 	. 
	ld h,h			;9076	64 	d 
	ld (hl),b			;9077	70 	p 
	ex af,af'			;9078	08 	. 
	dec h			;9079	25 	% 
	nop			;907a	00 	. 
	ld l,070h		;907b	2e 70 	. p 
	inc b			;907d	04 	. 
	dec h			;907e	25 	% 
	jr nz,l90afh		;907f	20 2e 	  . 
	ret z			;9081	c8 	. 
	ex af,af'			;9082	08 	. 
	dec h			;9083	25 	% 
	add a,b			;9084	80 	. 
	ld h,h			;9085	64 	d 
	add a,b			;9086	80 	. 
	ex af,af'			;9087	08 	. 
	ld h,001h		;9088	26 01 	& . 
	inc d			;908a	14 	. 
	ld (hl),l			;908b	75 	u 
	add a,a			;908c	87 	. 
	ld h,021h		;908d	26 21 	& ! 
	inc d			;908f	14 	. 
	call 0268bh		;9090	cd 8b 26 	. . & 
	add a,b			;9093	80 	. 
	ld h,l			;9094	65 	e 
	ld b,b			;9095	40 	@ 
	rrca			;9096	0f 	. 
	ld h,0a4h		;9097	26 a4 	& . 
l9099h:
	ld h,l			;9099	65 	e 
	ld (hl),b			;909a	70 	p 
	rla			;909b	17 	. 
	daa			;909c	27 	' 
	nop			;909d	00 	. 
	inc l			;909e	2c 	, 
	nop			;909f	00 	. 
	inc b			;90a0	04 	. 
	daa			;90a1	27 	' 
	add a,b			;90a2	80 	. 
	ld h,h			;90a3	64 	d 
	ld c,b			;90a4	48 	H 
	ex af,af'			;90a5	08 	. 
	jr z,l90abh		;90a6	28 03 	( . 
l90a8h:
	ld (de),a			;90a8	12 	. 
	and l			;90a9	a5 	. 
	add a,a			;90aa	87 	. 
l90abh:
	jr z,l902dh		;90ab	28 80 	( . 
	ld h,(hl)			;90ad	66 	f 
	ld d,b			;90ae	50 	P 
l90afh:
	ex af,af'			;90af	08 	. 
	add hl,hl			;90b0	29 	) 
	nop			;90b1	00 	. 
	ld e,0c3h		;90b2	1e c3 	. . 
	dec bc			;90b4	0b 	. 
	add hl,hl			;90b5	29 	) 
	jr nz,l90d6h		;90b6	20 1e 	  . 
	in a,(06fh)		;90b8	db 6f 	. o 
	add hl,hl			;90ba	29 	) 
	add a,b			;90bb	80 	. 
	ld h,(hl)			;90bc	66 	f 
	ld e,b			;90bd	58 	X 
	ex af,af'			;90be	08 	. 
	ld hl,(01402h)		;90bf	2a 02 14 	* . . 
	push bc			;90c2	c5 	. 
	or b			;90c3	b0 	. 
	ld hl,(01422h)		;90c4	2a 22 14 	* " . 
	defb 0ddh,0b4h,02ah	;illegal sequence		;90c7	dd b4 2a 	. . * 
	add a,b			;90ca	80 	. 
	ld h,(hl)			;90cb	66 	f 
	ld h,b			;90cc	60 	` 
	ex af,af'			;90cd	08 	. 
	dec hl			;90ce	2b 	+ 
	nop			;90cf	00 	. 
	ld l,0c0h		;90d0	2e c0 	. . 
	ld b,02bh		;90d2	06 2b 	. + 
	jr nz,l9104h		;90d4	20 2e 	  . 
l90d6h:
	ret c			;90d6	d8 	. 
	ld a,(bc)			;90d7	0a 	. 
	dec hl			;90d8	2b 	+ 
	add a,b			;90d9	80 	. 
	ld h,(hl)			;90da	66 	f 
	ld l,b			;90db	68 	h 
	ex af,af'			;90dc	08 	. 
	inc l			;90dd	2c 	, 
	nop			;90de	00 	. 
	ld (hl),080h		;90df	36 80 	6 . 
	inc b			;90e1	04 	. 
	inc l			;90e2	2c 	, 
	jr nz,l911bh		;90e3	20 36 	  6 
	ret pe			;90e5	e8 	. 
	ex af,af'			;90e6	08 	. 
	inc l			;90e7	2c 	, 
	add a,b			;90e8	80 	. 
	ld h,(hl)			;90e9	66 	f 
	ld (hl),b			;90ea	70 	p 
	ex af,af'			;90eb	08 	. 
	dec l			;90ec	2d 	- 
	nop			;90ed	00 	. 
	ld l,080h		;90ee	2e 80 	. . 
	inc b			;90f0	04 	. 
	dec l			;90f1	2d 	- 
	jr nz,l9122h		;90f2	20 2e 	  . 
	ret pe			;90f4	e8 	. 
	ex af,af'			;90f5	08 	. 
	dec l			;90f6	2d 	- 
	add a,b			;90f7	80 	. 
	ld h,(hl)			;90f8	66 	f 
	add a,b			;90f9	80 	. 
	ex af,af'			;90fa	08 	. 
	ld l,001h		;90fb	2e 01 	. . 
	inc d			;90fd	14 	. 
	add a,l			;90fe	85 	. 
	add a,a			;90ff	87 	. 
	ld l,021h		;9100	2e 21 	. ! 
	inc d			;9102	14 	. 
	defb 0edh;next byte illegal after ed		;9103	ed 	. 
l9104h:
	adc a,e			;9104	8b 	. 
	ld l,080h		;9105	2e 80 	. . 
	ld h,a			;9107	67 	g 
	ld b,b			;9108	40 	@ 
	rrca			;9109	0f 	. 
	ld l,0a4h		;910a	2e a4 	. . 
	ld h,a			;910c	67 	g 
	ld (hl),b			;910d	70 	p 
	rla			;910e	17 	. 
	cpl			;910f	2f 	/ 
	nop			;9110	00 	. 
	ld hl,(00400h)		;9111	2a 00 04 	* . . 
	cpl			;9114	2f 	/ 
	add a,b			;9115	80 	. 
	ld h,(hl)			;9116	66 	f 
	ld c,b			;9117	48 	H 
	ex af,af'			;9118	08 	. 
	jr nc,$+5		;9119	30 03 	0 . 
l911bh:
	ld (de),a			;911b	12 	. 
	defb 0fdh,087h,030h	;illegal sequence		;911c	fd 87 30 	. . 0 
	add a,b			;911f	80 	. 
	sbc a,d			;9120	9a 	. 
	ld d,b			;9121	50 	P 
l9122h:
	ex af,af'			;9122	08 	. 
	ld sp,01502h		;9123	31 02 15 	1 . . 
	dec e			;9126	1d 	. 
	adc a,d			;9127	8a 	. 
	ld sp,l9a80h		;9128	31 80 9a 	1 . . 
	ld e,b			;912b	58 	X 
	ex af,af'			;912c	08 	. 
	ld (01502h),a		;912d	32 02 15 	2 . . 
	ld l,c			;9130	69 	i 
	dec l			;9131	2d 	- 
	ld (l9a80h),a		;9132	32 80 9a 	2 . . 
	ld h,b			;9135	60 	` 
	ex af,af'			;9136	08 	. 
	inc sp			;9137	33 	3 
	nop			;9138	00 	. 
	scf			;9139	37 	7 
	jr l9142h		;913a	18 06 	. . 
	inc sp			;913c	33 	3 
	add a,b			;913d	80 	. 
	sbc a,d			;913e	9a 	. 
	ld l,b			;913f	68 	h 
	ex af,af'			;9140	08 	. 
	inc (hl)			;9141	34 	4 
l9142h:
	nop			;9142	00 	. 
	scf			;9143	37 	7 
	ld b,b			;9144	40 	@ 
	dec bc			;9145	0b 	. 
	inc (hl)			;9146	34 	4 
	inc h			;9147	24 	$ 
	scf			;9148	37 	7 
	ld (hl),b			;9149	70 	p 
	rla			;914a	17 	. 
	inc (hl)			;914b	34 	4 
	add a,b			;914c	80 	. 
	sbc a,d			;914d	9a 	. 
	ld (hl),b			;914e	70 	p 
	ex af,af'			;914f	08 	. 
	dec (hl)			;9150	35 	5 
	nop			;9151	00 	. 
	cpl			;9152	2f 	/ 
	ld b,b			;9153	40 	@ 
	dec bc			;9154	0b 	. 
	dec (hl)			;9155	35 	5 
	inc h			;9156	24 	$ 
	cpl			;9157	2f 	/ 
	ld (hl),b			;9158	70 	p 
	rla			;9159	17 	. 
	dec (hl)			;915a	35 	5 
	add a,b			;915b	80 	. 
	sbc a,d			;915c	9a 	. 
	add a,b			;915d	80 	. 
	ex af,af'			;915e	08 	. 
	ld (hl),001h		;915f	36 01 	6 . 
	dec d			;9161	15 	. 
	ld b,l			;9162	45 	E 
	adc a,d			;9163	8a 	. 
	ld (hl),025h		;9164	36 25 	6 % 
	dec d			;9166	15 	. 
	ld (hl),l			;9167	75 	u 
	sub e			;9168	93 	. 
	ld (hl),080h		;9169	36 80 	6 . 
	sbc a,e			;916b	9b 	. 
	ld b,b			;916c	40 	@ 
	rrca			;916d	0f 	. 
	ld (hl),0a4h		;916e	36 a4 	6 . 
	sbc a,e			;9170	9b 	. 
	ld (hl),b			;9171	70 	p 
	rla			;9172	17 	. 
	scf			;9173	37 	7 
	nop			;9174	00 	. 
	ld h,b			;9175	60 	` 
	nop			;9176	00 	. 
	inc b			;9177	04 	. 
	scf			;9178	37 	7 
	add a,b			;9179	80 	. 
	sbc a,d			;917a	9a 	. 
	ld c,b			;917b	48 	H 
	ex af,af'			;917c	08 	. 
	jr c,l9182h		;917d	38 03 	8 . 
	ld (de),a			;917f	12 	. 
	ld e,l			;9180	5d 	] 
	add a,a			;9181	87 	. 
l9182h:
	jr c,l9104h		;9182	38 80 	8 . 
	ld l,b			;9184	68 	h 
	ld d,b			;9185	50 	P 
	ex af,af'			;9186	08 	. 
	add hl,sp			;9187	39 	9 
	nop			;9188	00 	. 
	ld e,0c4h		;9189	1e c4 	. . 
	ld l,e			;918b	6b 	k 
	add hl,sp			;918c	39 	9 
	jr nz,$+32		;918d	20 1e 	  . 
	call c,0396fh		;918f	dc 6f 39 	. o 9 
	add a,b			;9192	80 	. 
	ld l,b			;9193	68 	h 
	ld e,b			;9194	58 	X 
	ex af,af'			;9195	08 	. 
	ld a,(01402h)		;9196	3a 02 14 	: . . 
	ld c,l			;9199	4d 	M 
	xor l			;919a	ad 	. 
	ld a,(l6880h)		;919b	3a 80 68 	: . h 
	ld h,b			;919e	60 	` 
	ex af,af'			;919f	08 	. 
	dec sp			;91a0	3b 	; 
	nop			;91a1	00 	. 
	cpl			;91a2	2f 	/ 
	jr l91abh		;91a3	18 06 	. . 
	dec sp			;91a5	3b 	; 
	add a,b			;91a6	80 	. 
	ld l,b			;91a7	68 	h 
	ld l,b			;91a8	68 	h 
	ex af,af'			;91a9	08 	. 
	inc a			;91aa	3c 	< 
l91abh:
	nop			;91ab	00 	. 
	ld (hl),048h		;91ac	36 48 	6 H 
	inc b			;91ae	04 	. 
	inc a			;91af	3c 	< 
	add a,b			;91b0	80 	. 
	ld l,b			;91b1	68 	h 
	ld (hl),b			;91b2	70 	p 
	ex af,af'			;91b3	08 	. 
	dec a			;91b4	3d 	= 
	nop			;91b5	00 	. 
	ld l,048h		;91b6	2e 48 	. H 
	inc b			;91b8	04 	. 
	dec a			;91b9	3d 	= 
	add a,b			;91ba	80 	. 
	ld l,b			;91bb	68 	h 
	add a,b			;91bc	80 	. 
	ex af,af'			;91bd	08 	. 
	ld a,001h		;91be	3e 01 	> . 
	inc d			;91c0	14 	. 
	ld c,l			;91c1	4d 	M 
	add a,a			;91c2	87 	. 
	ld a,080h		;91c3	3e 80 	> . 
	ld l,c			;91c5	69 	i 
	ld b,b			;91c6	40 	@ 
	rrca			;91c7	0f 	. 
	ld a,0a4h		;91c8	3e a4 	> . 
	ld l,c			;91ca	69 	i 
	ld (hl),b			;91cb	70 	p 
	rla			;91cc	17 	. 
	ccf			;91cd	3f 	? 
	nop			;91ce	00 	. 
	inc h			;91cf	24 	$ 
	nop			;91d0	00 	. 
	inc b			;91d1	04 	. 
	ccf			;91d2	3f 	? 
	add a,b			;91d3	80 	. 
	ld l,b			;91d4	68 	h 
	ld c,b			;91d5	48 	H 
	ex af,af'			;91d6	08 	. 
	ld b,b			;91d7	40 	@ 
	nop			;91d8	00 	. 
	inc d			;91d9	14 	. 
	ld d,c			;91da	51 	Q 
	ld b,h			;91db	44 	D 
	ld b,b			;91dc	40 	@ 
	ld b,b			;91dd	40 	@ 
	ld c,054h		;91de	0e 54 	. T 
	adc a,h			;91e0	8c 	. 
	ld b,b			;91e1	40 	@ 
	add a,b			;91e2	80 	. 
	ld (04809h),hl		;91e3	22 09 48 	" . H 
	ld b,c			;91e6	41 	A 
	nop			;91e7	00 	. 
	inc d			;91e8	14 	. 
	ld d,c			;91e9	51 	Q 
	ld h,h			;91ea	64 	d 
	ld b,c			;91eb	41 	A 
	ld b,b			;91ec	40 	@ 
	ld b,a			;91ed	47 	G 
	ld hl,0414ch		;91ee	21 4c 41 	! L A 
	add a,b			;91f1	80 	. 
	ld (06809h),hl		;91f2	22 09 68 	" . h 
	ld b,d			;91f5	42 	B 
	nop			;91f6	00 	. 
	inc d			;91f7	14 	. 
	ld d,c			;91f8	51 	Q 
	add a,h			;91f9	84 	. 
	ld b,d			;91fa	42 	B 
	ld b,b			;91fb	40 	@ 
	ld e,(hl)			;91fc	5e 	^ 
	jp nz,042cfh		;91fd	c2 cf 42 	. . B 
	add a,b			;9200	80 	. 
	ld (l8809h),hl		;9201	22 09 88 	" . . 
	ld b,e			;9204	43 	C 
	nop			;9205	00 	. 
	inc d			;9206	14 	. 
	ld d,c			;9207	51 	Q 
	and h			;9208	a4 	. 
	ld b,e			;9209	43 	C 
	ld b,d			;920a	42 	B 
	dec d			;920b	15 	. 
	ld l,d			;920c	6a 	j 
	call nc,08043h		;920d	d4 43 80 	. C . 
	ld (la809h),hl		;9210	22 09 a8 	" . . 
	ld b,h			;9213	44 	D 
	nop			;9214	00 	. 
	inc d			;9215	14 	. 
	ld d,c			;9216	51 	Q 
	call nz,02044h		;9217	c4 44 20 	. D   
	inc d			;921a	14 	. 
	ld d,e			;921b	53 	S 
	jr z,$+70		;921c	28 44 	( D 
	ld b,b			;921e	40 	@ 
	ld b,b			;921f	40 	@ 
	nop			;9220	00 	. 
	ex af,af'			;9221	08 	. 
	ld b,h			;9222	44 	D 
	add a,b			;9223	80 	. 
	ld (0c809h),hl		;9224	22 09 c8 	" . . 
	ld b,l			;9227	45 	E 
	nop			;9228	00 	. 
	inc d			;9229	14 	. 
	ld d,d			;922a	52 	R 
	inc b			;922b	04 	. 
	ld b,l			;922c	45 	E 
	jr nz,l9243h		;922d	20 14 	  . 
	ld d,e			;922f	53 	S 
	xor b			;9230	a8 	. 
	ld b,l			;9231	45 	E 
	ld b,b			;9232	40 	@ 
	sub h			;9233	94 	. 
	nop			;9234	00 	. 
	ld c,045h		;9235	0e 45 	. E 
	add a,b			;9237	80 	. 
	ld (0080ah),hl		;9238	22 0a 08 	" . . 
	ld b,(hl)			;923b	46 	F 
	nop			;923c	00 	. 
	inc d			;923d	14 	. 
	ld d,l			;923e	55 	U 
	rlca			;923f	07 	. 
	ld b,(hl)			;9240	46 	F 
	inc h			;9241	24 	$ 
	inc d			;9242	14 	. 
l9243h:
	ld d,l			;9243	55 	U 
	out (046h),a		;9244	d3 46 	. F 
	ld b,b			;9246	40 	@ 
	inc c			;9247	0c 	. 
	ex af,af'			;9248	08 	. 
	ex af,af'			;9249	08 	. 
	ld b,(hl)			;924a	46 	F 
	add a,b			;924b	80 	. 
	ld (00c0dh),hl		;924c	22 0d 0c 	" . . 
	ld b,(hl)			;924f	46 	F 
	and h			;9250	a4 	. 
	ld (0d40dh),hl		;9251	22 0d d4 	" . . 
	ld b,a			;9254	47 	G 
	nop			;9255	00 	. 
	inc d			;9256	14 	. 
	ld d,c			;9257	51 	Q 
	inc h			;9258	24 	$ 
	ld b,a			;9259	47 	G 
	ld b,b			;925a	40 	@ 
	inc d			;925b	14 	. 
	ld a,c			;925c	79 	y 
	add hl,hl			;925d	29 	) 
	ld b,a			;925e	47 	G 
	add a,b			;925f	80 	. 
	ld (02809h),hl		;9260	22 09 28 	" . ( 
	ld c,b			;9263	48 	H 
	nop			;9264	00 	. 
	inc d			;9265	14 	. 
	ld e,c			;9266	59 	Y 
	ld b,h			;9267	44 	D 
	ld c,b			;9268	48 	H 
	ld b,b			;9269	40 	@ 
	ld c,05ch		;926a	0e 5c 	. \ 
	adc a,h			;926c	8c 	. 
	ld c,b			;926d	48 	H 
	add a,b			;926e	80 	. 
	ld (04811h),hl		;926f	22 11 48 	" . H 
	ld c,c			;9272	49 	I 
	nop			;9273	00 	. 
	inc d			;9274	14 	. 
	ld e,c			;9275	59 	Y 
	ld h,h			;9276	64 	d 
	ld c,c			;9277	49 	I 
	ld b,b			;9278	40 	@ 
	ld b,a			;9279	47 	G 
	ld hl,0496ch		;927a	21 6c 49 	! l I 
	add a,b			;927d	80 	. 
	ld (l6811h),hl		;927e	22 11 68 	" . h 
	ld c,d			;9281	4a 	J 
	nop			;9282	00 	. 
	inc d			;9283	14 	. 
	ld e,c			;9284	59 	Y 
	add a,h			;9285	84 	. 
	ld c,d			;9286	4a 	J 
	ld b,b			;9287	40 	@ 
	inc e			;9288	1c 	. 
	jp nz,04acfh		;9289	c2 cf 4a 	. . J 
	add a,b			;928c	80 	. 
	ld (l8811h),hl		;928d	22 11 88 	" . . 
	ld c,e			;9290	4b 	K 
	nop			;9291	00 	. 
	inc d			;9292	14 	. 
	ld e,c			;9293	59 	Y 
	and h			;9294	a4 	. 
	ld c,e			;9295	4b 	K 
	ld b,d			;9296	42 	B 
	inc d			;9297	14 	. 
	or l			;9298	b5 	. 
	or h			;9299	b4 	. 
	ld c,e			;929a	4b 	K 
	add a,b			;929b	80 	. 
	ld (la811h),hl		;929c	22 11 a8 	" . . 
	ld c,h			;929f	4c 	L 
	nop			;92a0	00 	. 
	inc d			;92a1	14 	. 
	ld e,c			;92a2	59 	Y 
	call nz,0204ch		;92a3	c4 4c 20 	. L   
	inc d			;92a6	14 	. 
	ld e,e			;92a7	5b 	[ 
	jr z,l92f6h		;92a8	28 4c 	( L 
	add a,b			;92aa	80 	. 
	ld (0c811h),hl		;92ab	22 11 c8 	" . . 
	ld c,l			;92ae	4d 	M 
	nop			;92af	00 	. 
	inc d			;92b0	14 	. 
	ld e,d			;92b1	5a 	Z 
	inc b			;92b2	04 	. 
	ld c,l			;92b3	4d 	M 
	jr nz,l92cah		;92b4	20 14 	  . 
	ld e,e			;92b6	5b 	[ 
	xor b			;92b7	a8 	. 
	ld c,l			;92b8	4d 	M 
	ld b,b			;92b9	40 	@ 
	sub d			;92ba	92 	. 
	nop			;92bb	00 	. 
	ld c,04dh		;92bc	0e 4d 	. M 
	add a,b			;92be	80 	. 
	ld (00812h),hl		;92bf	22 12 08 	" . . 
	ld c,(hl)			;92c2	4e 	N 
	nop			;92c3	00 	. 
	inc d			;92c4	14 	. 
	ld e,l			;92c5	5d 	] 
	rlca			;92c6	07 	. 
	ld c,(hl)			;92c7	4e 	N 
	inc h			;92c8	24 	$ 
	inc d			;92c9	14 	. 
l92cah:
	ld e,l			;92ca	5d 	] 
	out (04eh),a		;92cb	d3 4e 	. N 
	add a,b			;92cd	80 	. 
	ld (00c15h),hl		;92ce	22 15 0c 	" . . 
	ld c,(hl)			;92d1	4e 	N 
	and h			;92d2	a4 	. 
	ld (0d415h),hl		;92d3	22 15 d4 	" . . 
	ld c,a			;92d6	4f 	O 
	nop			;92d7	00 	. 
	inc d			;92d8	14 	. 
	ld e,c			;92d9	59 	Y 
	inc h			;92da	24 	$ 
	ld c,a			;92db	4f 	O 
	ld b,b			;92dc	40 	@ 
	inc d			;92dd	14 	. 
	sbc a,c			;92de	99 	. 
	add hl,hl			;92df	29 	) 
	ld c,a			;92e0	4f 	O 
	add a,b			;92e1	80 	. 
	ld (02811h),hl		;92e2	22 11 28 	" . ( 
	ld d,b			;92e5	50 	P 
	nop			;92e6	00 	. 
	inc d			;92e7	14 	. 
	ld h,c			;92e8	61 	a 
	ld b,h			;92e9	44 	D 
	ld d,b			;92ea	50 	P 
	ld b,b			;92eb	40 	@ 
	ld c,064h		;92ec	0e 64 	. d 
	adc a,h			;92ee	8c 	. 
	ld d,b			;92ef	50 	P 
	add a,b			;92f0	80 	. 
	ld (04819h),hl		;92f1	22 19 48 	" . H 
	ld d,c			;92f4	51 	Q 
	nop			;92f5	00 	. 
l92f6h:
	inc d			;92f6	14 	. 
	ld h,c			;92f7	61 	a 
	ld h,h			;92f8	64 	d 
	ld d,c			;92f9	51 	Q 
	ld b,b			;92fa	40 	@ 
	ld b,a			;92fb	47 	G 
	ld hl,0518ch		;92fc	21 8c 51 	! . Q 
	add a,b			;92ff	80 	. 
	ld (l6819h),hl		;9300	22 19 68 	" . h 
	ld d,d			;9303	52 	R 
	nop			;9304	00 	. 
	inc d			;9305	14 	. 
	ld h,c			;9306	61 	a 
	add a,h			;9307	84 	. 
	ld d,d			;9308	52 	R 
	ld b,b			;9309	40 	@ 
	ld e,(hl)			;930a	5e 	^ 
	jp nz,052efh		;930b	c2 ef 52 	. . R 
	add a,b			;930e	80 	. 
	ld (l8819h),hl		;930f	22 19 88 	" . . 
	ld d,e			;9312	53 	S 
	nop			;9313	00 	. 
	inc d			;9314	14 	. 
	ld h,c			;9315	61 	a 
	and h			;9316	a4 	. 
	ld d,e			;9317	53 	S 
	ld b,d			;9318	42 	B 
	dec d			;9319	15 	. 
	ld l,d			;931a	6a 	j 
	call p,sub_8053h		;931b	f4 53 80 	. S . 
	ld (la819h),hl		;931e	22 19 a8 	" . . 
	ld d,h			;9321	54 	T 
	nop			;9322	00 	. 
	inc d			;9323	14 	. 
	ld h,c			;9324	61 	a 
	call nz,02054h		;9325	c4 54 20 	. T   
	inc d			;9328	14 	. 
	ld h,e			;9329	63 	c 
	jr z,$+86		;932a	28 54 	( T 
	add a,b			;932c	80 	. 
	ld (0c819h),hl		;932d	22 19 c8 	" . . 
	ld d,l			;9330	55 	U 
	nop			;9331	00 	. 
	inc d			;9332	14 	. 
	ld h,d			;9333	62 	b 
	inc b			;9334	04 	. 
	ld d,l			;9335	55 	U 
	jr nz,l934ch		;9336	20 14 	  . 
	ld h,e			;9338	63 	c 
	xor b			;9339	a8 	. 
	ld d,l			;933a	55 	U 
	add a,b			;933b	80 	. 
	ld (0081ah),hl		;933c	22 1a 08 	" . . 
	ld d,(hl)			;933f	56 	V 
	nop			;9340	00 	. 
	inc d			;9341	14 	. 
	ld h,l			;9342	65 	e 
	rlca			;9343	07 	. 
	ld d,(hl)			;9344	56 	V 
	inc h			;9345	24 	$ 
	inc d			;9346	14 	. 
	ld h,l			;9347	65 	e 
	out (056h),a		;9348	d3 56 	. V 
	ld b,b			;934a	40 	@ 
	inc c			;934b	0c 	. 
l934ch:
	djnz $+10		;934c	10 08 	. . 
	ld d,(hl)			;934e	56 	V 
	add a,b			;934f	80 	. 
	ld (00c1dh),hl		;9350	22 1d 0c 	" . . 
	ld d,(hl)			;9353	56 	V 
	and h			;9354	a4 	. 
	ld (0d41dh),hl		;9355	22 1d d4 	" . . 
	ld d,a			;9358	57 	W 
	nop			;9359	00 	. 
	inc d			;935a	14 	. 
	ld h,c			;935b	61 	a 
	inc h			;935c	24 	$ 
	ld d,a			;935d	57 	W 
	ld b,b			;935e	40 	@ 
	inc d			;935f	14 	. 
	ld c,c			;9360	49 	I 
	jp (hl)			;9361	e9 	. 
	ld d,a			;9362	57 	W 
	add a,b			;9363	80 	. 
	ld (02819h),hl		;9364	22 19 28 	" . ( 
	ld e,b			;9367	58 	X 
	nop			;9368	00 	. 
	inc d			;9369	14 	. 
	ld l,c			;936a	69 	i 
	ld b,h			;936b	44 	D 
	ld e,b			;936c	58 	X 
	ld b,b			;936d	40 	@ 
	ld c,06ch		;936e	0e 6c 	. l 
	adc a,h			;9370	8c 	. 
	ld e,b			;9371	58 	X 
	add a,b			;9372	80 	. 
	ld (04821h),hl		;9373	22 21 48 	" ! H 
	ld e,c			;9376	59 	Y 
	nop			;9377	00 	. 
	inc d			;9378	14 	. 
	ld l,c			;9379	69 	i 
	ld h,h			;937a	64 	d 
	ld e,c			;937b	59 	Y 
	ld b,b			;937c	40 	@ 
	ld b,a			;937d	47 	G 
	ld hl,059ach		;937e	21 ac 59 	! . Y 
	add a,b			;9381	80 	. 
	ld (06821h),hl		;9382	22 21 68 	" ! h 
	ld e,d			;9385	5a 	Z 
	nop			;9386	00 	. 
	inc d			;9387	14 	. 
	ld l,c			;9388	69 	i 
	add a,h			;9389	84 	. 
	ld e,d			;938a	5a 	Z 
	ld b,b			;938b	40 	@ 
	inc e			;938c	1c 	. 
	jp nz,05aefh		;938d	c2 ef 5a 	. . Z 
	add a,b			;9390	80 	. 
	ld (08821h),hl		;9391	22 21 88 	" ! . 
	ld e,e			;9394	5b 	[ 
	nop			;9395	00 	. 
	inc d			;9396	14 	. 
	ld l,c			;9397	69 	i 
	and h			;9398	a4 	. 
	ld e,e			;9399	5b 	[ 
	ld b,d			;939a	42 	B 
	inc d			;939b	14 	. 
	cp l			;939c	bd 	. 
	or h			;939d	b4 	. 
	ld e,e			;939e	5b 	[ 
	add a,b			;939f	80 	. 
	ld (la821h),hl		;93a0	22 21 a8 	" ! . 
	ld e,h			;93a3	5c 	\ 
	nop			;93a4	00 	. 
	inc d			;93a5	14 	. 
	ld l,c			;93a6	69 	i 
	call nz,0205ch		;93a7	c4 5c 20 	. \   
	inc d			;93aa	14 	. 
	ld l,e			;93ab	6b 	k 
	jr z,l940ah		;93ac	28 5c 	( \ 
	add a,b			;93ae	80 	. 
	ld (0c821h),hl		;93af	22 21 c8 	" ! . 
	ld e,l			;93b2	5d 	] 
	nop			;93b3	00 	. 
	inc d			;93b4	14 	. 
	ld l,d			;93b5	6a 	j 
	inc b			;93b6	04 	. 
	ld e,l			;93b7	5d 	] 
	jr nz,l93ceh		;93b8	20 14 	  . 
	ld l,e			;93ba	6b 	k 
	xor b			;93bb	a8 	. 
	ld e,l			;93bc	5d 	] 
	add a,b			;93bd	80 	. 
	ld (00822h),hl		;93be	22 22 08 	" " . 
	ld e,(hl)			;93c1	5e 	^ 
	nop			;93c2	00 	. 
	inc d			;93c3	14 	. 
	ld l,l			;93c4	6d 	m 
	rlca			;93c5	07 	. 
	ld e,(hl)			;93c6	5e 	^ 
	inc h			;93c7	24 	$ 
	inc d			;93c8	14 	. 
	ld l,l			;93c9	6d 	m 
	out (05eh),a		;93ca	d3 5e 	. ^ 
	ld b,b			;93cc	40 	@ 
	inc c			;93cd	0c 	. 
l93ceh:
	jr $+10		;93ce	18 08 	. . 
	ld e,(hl)			;93d0	5e 	^ 
	add a,b			;93d1	80 	. 
	ld (00c25h),hl		;93d2	22 25 0c 	" % . 
	ld e,(hl)			;93d5	5e 	^ 
	and h			;93d6	a4 	. 
	ld (0d425h),hl		;93d7	22 25 d4 	" % . 
	ld e,a			;93da	5f 	_ 
	nop			;93db	00 	. 
	inc d			;93dc	14 	. 
	ld l,c			;93dd	69 	i 
	inc h			;93de	24 	$ 
	ld e,a			;93df	5f 	_ 
	ld b,b			;93e0	40 	@ 
	inc d			;93e1	14 	. 
	ld c,d			;93e2	4a 	J 
	ld l,c			;93e3	69 	i 
	ld e,a			;93e4	5f 	_ 
	add a,b			;93e5	80 	. 
	ld (02821h),hl		;93e6	22 21 28 	" ! ( 
	ld h,b			;93e9	60 	` 
	nop			;93ea	00 	. 
	inc d			;93eb	14 	. 
	ld (hl),c			;93ec	71 	q 
	ld b,h			;93ed	44 	D 
	ld h,b			;93ee	60 	` 
	jr nz,l9405h		;93ef	20 14 	  . 
	ret			;93f1	c9 	. 
	ld c,b			;93f2	48 	H 
	ld h,b			;93f3	60 	` 
	ld b,b			;93f4	40 	@ 
	ld c,074h		;93f5	0e 74 	. t 
	adc a,h			;93f7	8c 	. 
	ld h,b			;93f8	60 	` 
	add a,b			;93f9	80 	. 
	ld (04829h),hl		;93fa	22 29 48 	" ) H 
	ld h,c			;93fd	61 	a 
	nop			;93fe	00 	. 
	inc d			;93ff	14 	. 
	ld (hl),c			;9400	71 	q 
	ld h,h			;9401	64 	d 
	ld h,c			;9402	61 	a 
	jr nz,l9419h		;9403	20 14 	  . 
l9405h:
	ret			;9405	c9 	. 
	ld l,b			;9406	68 	h 
	ld h,c			;9407	61 	a 
	ld b,b			;9408	40 	@ 
	ld b,a			;9409	47 	G 
l940ah:
	ld hl,061cch		;940a	21 cc 61 	! . a 
	add a,b			;940d	80 	. 
	ld (l6829h),hl		;940e	22 29 68 	" ) h 
	ld h,d			;9411	62 	b 
	nop			;9412	00 	. 
	inc d			;9413	14 	. 
	ld (hl),c			;9414	71 	q 
	add a,h			;9415	84 	. 
	ld h,d			;9416	62 	b 
	jr nz,l942dh		;9417	20 14 	  . 
l9419h:
	ret			;9419	c9 	. 
	adc a,b			;941a	88 	. 
	ld h,d			;941b	62 	b 
	ld b,b			;941c	40 	@ 
	ld e,(hl)			;941d	5e 	^ 
	jp l620fh		;941e	c3 0f 62 	. . b 
	add a,b			;9421	80 	. 
	ld (l8829h),hl		;9422	22 29 88 	" ) . 
	ld h,e			;9425	63 	c 
	nop			;9426	00 	. 
	inc d			;9427	14 	. 
	ld (hl),c			;9428	71 	q 
	and h			;9429	a4 	. 
	ld h,e			;942a	63 	c 
	jr nz,l9441h		;942b	20 14 	  . 
l942dh:
	ret			;942d	c9 	. 
	xor b			;942e	a8 	. 
	ld h,e			;942f	63 	c 
	ld b,d			;9430	42 	B 
	dec d			;9431	15 	. 
	ld l,e			;9432	6b 	k 
	inc d			;9433	14 	. 
	ld h,e			;9434	63 	c 
	add a,b			;9435	80 	. 
	ld (la829h),hl		;9436	22 29 a8 	" ) . 
	ld h,h			;9439	64 	d 
	nop			;943a	00 	. 
	inc d			;943b	14 	. 
	ld (hl),c			;943c	71 	q 
	call nz,02064h		;943d	c4 64 20 	. d   
	inc d			;9440	14 	. 
l9441h:
	sra b		;9441	cb 28 	. ( 
	ld h,h			;9443	64 	d 
	add a,b			;9444	80 	. 
	ld (0c829h),hl		;9445	22 29 c8 	" ) . 
	ld h,l			;9448	65 	e 
	nop			;9449	00 	. 
	inc d			;944a	14 	. 
	ld (hl),d			;944b	72 	r 
	inc b			;944c	04 	. 
	ld h,l			;944d	65 	e 
	jr nz,$+22		;944e	20 14 	  . 
	res 5,b		;9450	cb a8 	. . 
	ld h,l			;9452	65 	e 
	add a,b			;9453	80 	. 
	ld (0082ah),hl		;9454	22 2a 08 	" * . 
	ld h,(hl)			;9457	66 	f 
	nop			;9458	00 	. 
	inc d			;9459	14 	. 
	ld (hl),l			;945a	75 	u 
	rlca			;945b	07 	. 
	ld h,(hl)			;945c	66 	f 
	inc h			;945d	24 	$ 
	inc d			;945e	14 	. 
	ld (hl),l			;945f	75 	u 
	out (066h),a		;9460	d3 66 	. f 
	add a,b			;9462	80 	. 
	ld (00c2dh),hl		;9463	22 2d 0c 	" - . 
	ld h,(hl)			;9466	66 	f 
	and h			;9467	a4 	. 
	ld (0d42dh),hl		;9468	22 2d d4 	" - . 
	ld h,a			;946b	67 	g 
	nop			;946c	00 	. 
	inc d			;946d	14 	. 
	ld (hl),c			;946e	71 	q 
	inc h			;946f	24 	$ 
	ld h,a			;9470	67 	g 
	jr nz,l9487h		;9471	20 14 	  . 
	ret			;9473	c9 	. 
	jr z,$+105		;9474	28 67 	( g 
	ld b,b			;9476	40 	@ 
	ld e,d			;9477	5a 	Z 
	nop			;9478	00 	. 
	ld (de),a			;9479	12 	. 
	ld h,a			;947a	67 	g 
	add a,b			;947b	80 	. 
	ld (02829h),hl		;947c	22 29 28 	" ) ( 
	ld l,b			;947f	68 	h 
	nop			;9480	00 	. 
	inc d			;9481	14 	. 
	add a,c			;9482	81 	. 
	ld b,h			;9483	44 	D 
	ld l,b			;9484	68 	h 
	jr nz,l949bh		;9485	20 14 	  . 
l9487h:
	jp (hl)			;9487	e9 	. 
	ld c,b			;9488	48 	H 
	ld l,b			;9489	68 	h 
	ld b,b			;948a	40 	@ 
	ld c,084h		;948b	0e 84 	. . 
	adc a,h			;948d	8c 	. 
	ld l,b			;948e	68 	h 
	add a,b			;948f	80 	. 
	ld (04831h),hl		;9490	22 31 48 	" 1 H 
	ld l,c			;9493	69 	i 
	nop			;9494	00 	. 
	inc d			;9495	14 	. 
	add a,c			;9496	81 	. 
	ld h,h			;9497	64 	d 
	ld l,c			;9498	69 	i 
	jr nz,l94afh		;9499	20 14 	  . 
l949bh:
	jp (hl)			;949b	e9 	. 
	ld l,b			;949c	68 	h 
	ld l,c			;949d	69 	i 
	ld b,b			;949e	40 	@ 
	ld b,a			;949f	47 	G 
	ld (l690ch),hl		;94a0	22 0c 69 	" . i 
	add a,b			;94a3	80 	. 
	ld (06831h),hl		;94a4	22 31 68 	" 1 h 
	ld l,d			;94a7	6a 	j 
	nop			;94a8	00 	. 
	inc d			;94a9	14 	. 
	add a,c			;94aa	81 	. 
	add a,h			;94ab	84 	. 
	ld l,d			;94ac	6a 	j 
	jr nz,l94c3h		;94ad	20 14 	  . 
l94afh:
	jp (hl)			;94af	e9 	. 
	adc a,b			;94b0	88 	. 
	ld l,d			;94b1	6a 	j 
	ld b,b			;94b2	40 	@ 
	inc e			;94b3	1c 	. 
	jp sub_6a0fh		;94b4	c3 0f 6a 	. . j 
	add a,b			;94b7	80 	. 
	ld (l8831h),hl		;94b8	22 31 88 	" 1 . 
	ld l,e			;94bb	6b 	k 
	nop			;94bc	00 	. 
	inc d			;94bd	14 	. 
	add a,c			;94be	81 	. 
	and h			;94bf	a4 	. 
	ld l,e			;94c0	6b 	k 
	jr nz,l94d7h		;94c1	20 14 	  . 
l94c3h:
	jp (hl)			;94c3	e9 	. 
	xor b			;94c4	a8 	. 
	ld l,e			;94c5	6b 	k 
	ld b,d			;94c6	42 	B 
	inc d			;94c7	14 	. 
	push bc			;94c8	c5 	. 
	or h			;94c9	b4 	. 
	ld l,e			;94ca	6b 	k 
	add a,b			;94cb	80 	. 
	ld (la831h),hl		;94cc	22 31 a8 	" 1 . 
	ld l,h			;94cf	6c 	l 
	nop			;94d0	00 	. 
	inc d			;94d1	14 	. 
	add a,c			;94d2	81 	. 
	call nz,0206ch		;94d3	c4 6c 20 	. l   
	inc d			;94d6	14 	. 
l94d7h:
	ex de,hl			;94d7	eb 	. 
	jr z,$+110		;94d8	28 6c 	( l 
	add a,b			;94da	80 	. 
	ld (0c831h),hl		;94db	22 31 c8 	" 1 . 
	ld l,l			;94de	6d 	m 
	nop			;94df	00 	. 
	inc d			;94e0	14 	. 
	add a,d			;94e1	82 	. 
	inc b			;94e2	04 	. 
	ld l,l			;94e3	6d 	m 
	jr nz,$+22		;94e4	20 14 	  . 
	ex de,hl			;94e6	eb 	. 
	xor b			;94e7	a8 	. 
	ld l,l			;94e8	6d 	m 
	add a,b			;94e9	80 	. 
	ld (00832h),hl		;94ea	22 32 08 	" 2 . 
	ld l,(hl)			;94ed	6e 	n 
	nop			;94ee	00 	. 
	inc d			;94ef	14 	. 
	add a,l			;94f0	85 	. 
	rlca			;94f1	07 	. 
	ld l,(hl)			;94f2	6e 	n 
	inc h			;94f3	24 	$ 
	inc d			;94f4	14 	. 
	add a,l			;94f5	85 	. 
	out (06eh),a		;94f6	d3 6e 	. n 
	add a,b			;94f8	80 	. 
	ld (00c35h),hl		;94f9	22 35 0c 	" 5 . 
	ld l,(hl)			;94fc	6e 	n 
	and h			;94fd	a4 	. 
	ld (0d435h),hl		;94fe	22 35 d4 	" 5 . 
	ld l,a			;9501	6f 	o 
	nop			;9502	00 	. 
	inc d			;9503	14 	. 
	add a,c			;9504	81 	. 
	inc h			;9505	24 	$ 
	ld l,a			;9506	6f 	o 
	jr nz,l951dh		;9507	20 14 	  . 
	jp (hl)			;9509	e9 	. 
	jr z,l957bh		;950a	28 6f 	( o 
	ld b,b			;950c	40 	@ 
	ld d,h			;950d	54 	T 
	nop			;950e	00 	. 
	ld (de),a			;950f	12 	. 
	ld l,a			;9510	6f 	o 
	add a,b			;9511	80 	. 
	ld (02831h),hl		;9512	22 31 28 	" 1 ( 
	ld (hl),b			;9515	70 	p 
	nop			;9516	00 	. 
	dec d			;9517	15 	. 
	ld b,c			;9518	41 	A 
	ld b,a			;9519	47 	G 
	ld (hl),b			;951a	70 	p 
	inc h			;951b	24 	$ 
	dec d			;951c	15 	. 
l951dh:
	ld (hl),c			;951d	71 	q 
	ld d,e			;951e	53 	S 
	ld (hl),b			;951f	70 	p 
	add a,b			;9520	80 	. 
	ld (04839h),hl		;9521	22 39 48 	" 9 H 
	ld (hl),c			;9524	71 	q 
	nop			;9525	00 	. 
	dec d			;9526	15 	. 
	ld b,c			;9527	41 	A 
	ld h,a			;9528	67 	g 
	ld (hl),c			;9529	71 	q 
	inc h			;952a	24 	$ 
	dec d			;952b	15 	. 
	ld (hl),c			;952c	71 	q 
	ld (hl),e			;952d	73 	s 
	ld (hl),c			;952e	71 	q 
	add a,b			;952f	80 	. 
	ld (l6839h),hl		;9530	22 39 68 	" 9 h 
	ld (hl),d			;9533	72 	r 
	nop			;9534	00 	. 
	dec d			;9535	15 	. 
	ld b,c			;9536	41 	A 
	add a,a			;9537	87 	. 
	ld (hl),d			;9538	72 	r 
	inc h			;9539	24 	$ 
	dec d			;953a	15 	. 
	ld (hl),c			;953b	71 	q 
	sub e			;953c	93 	. 
	ld (hl),d			;953d	72 	r 
	ld b,b			;953e	40 	@ 
	ld e,(hl)			;953f	5e 	^ 
	call nz,sub_726fh		;9540	c4 6f 72 	. o r 
	add a,b			;9543	80 	. 
	ld (08839h),hl		;9544	22 39 88 	" 9 . 
	ld (hl),e			;9547	73 	s 
	nop			;9548	00 	. 
	dec d			;9549	15 	. 
	ld b,c			;954a	41 	A 
	and a			;954b	a7 	. 
	ld (hl),e			;954c	73 	s 
	inc h			;954d	24 	$ 
	dec d			;954e	15 	. 
	ld (hl),c			;954f	71 	q 
	or e			;9550	b3 	. 
	ld (hl),e			;9551	73 	s 
	ld b,d			;9552	42 	B 
	dec d			;9553	15 	. 
	ld l,h			;9554	6c 	l 
	ld (hl),h			;9555	74 	t 
l9556h:
	ld (hl),e			;9556	73 	s 
	add a,b			;9557	80 	. 
	ld (la839h),hl		;9558	22 39 a8 	" 9 . 
	ld (hl),h			;955b	74 	t 
	nop			;955c	00 	. 
	dec d			;955d	15 	. 
	ld b,c			;955e	41 	A 
	rst 0			;955f	c7 	. 
	ld (hl),h			;9560	74 	t 
	inc h			;9561	24 	$ 
	dec d			;9562	15 	. 
	ld (hl),c			;9563	71 	q 
	out (074h),a		;9564	d3 74 	. t 
	add a,b			;9566	80 	. 
	ld (0c839h),hl		;9567	22 39 c8 	" 9 . 
	ld (hl),l			;956a	75 	u 
	nop			;956b	00 	. 
	dec d			;956c	15 	. 
	ld b,d			;956d	42 	B 
	rlca			;956e	07 	. 
	ld (hl),l			;956f	75 	u 
	inc h			;9570	24 	$ 
	dec d			;9571	15 	. 
	ld (hl),d			;9572	72 	r 
	inc de			;9573	13 	. 
	ld (hl),l			;9574	75 	u 
	add a,b			;9575	80 	. 
	ld (0083ah),hl		;9576	22 3a 08 	" : . 
	halt			;9579	76 	v 
	nop			;957a	00 	. 
l957bh:
	ld a,(hl)			;957b	7e 	~ 
	nop			;957c	00 	. 
	inc b			;957d	04 	. 
	halt			;957e	76 	v 
	add a,b			;957f	80 	. 
	ld (00c3dh),hl		;9580	22 3d 0c 	" = . 
	halt			;9583	76 	v 
	and h			;9584	a4 	. 
	ld (0d43dh),hl		;9585	22 3d d4 	" = . 
	ld (hl),a			;9588	77 	w 
	nop			;9589	00 	. 
	dec d			;958a	15 	. 
	ld b,c			;958b	41 	A 
	daa			;958c	27 	' 
	ld (hl),a			;958d	77 	w 
	inc h			;958e	24 	$ 
	dec d			;958f	15 	. 
	ld (hl),c			;9590	71 	q 
	inc sp			;9591	33 	3 
	ld (hl),a			;9592	77 	w 
	add a,b			;9593	80 	. 
	ld (02839h),hl		;9594	22 39 28 	" 9 ( 
	ld a,b			;9597	78 	x 
	nop			;9598	00 	. 
	inc d			;9599	14 	. 
	ld c,c			;959a	49 	I 
	ld b,h			;959b	44 	D 
	ld a,b			;959c	78 	x 
	ld b,b			;959d	40 	@ 
	ld c,04ch		;959e	0e 4c 	. L 
	adc a,h			;95a0	8c 	. 
	ld a,b			;95a1	78 	x 
	add a,b			;95a2	80 	. 
	ld (04841h),hl		;95a3	22 41 48 	" A H 
	ld a,c			;95a6	79 	y 
	nop			;95a7	00 	. 
	inc d			;95a8	14 	. 
	ld c,c			;95a9	49 	I 
	ld h,h			;95aa	64 	d 
	ld a,c			;95ab	79 	y 
	ld b,b			;95ac	40 	@ 
	ld b,a			;95ad	47 	G 
	ld hl,l792ch		;95ae	21 2c 79 	! , y 
	add a,b			;95b1	80 	. 
	ld (06841h),hl		;95b2	22 41 68 	" A h 
	ld a,d			;95b5	7a 	z 
	nop			;95b6	00 	. 
	inc d			;95b7	14 	. 
	ld c,c			;95b8	49 	I 
	add a,h			;95b9	84 	. 
	ld a,d			;95ba	7a 	z 
	ld b,b			;95bb	40 	@ 
	inc e			;95bc	1c 	. 
	call nz,07a6fh		;95bd	c4 6f 7a 	. o z 
	add a,b			;95c0	80 	. 
	ld (08841h),hl		;95c1	22 41 88 	" A . 
	ld a,e			;95c4	7b 	{ 
	nop			;95c5	00 	. 
l95c6h:
	inc d			;95c6	14 	. 
	ld c,c			;95c7	49 	I 
	and h			;95c8	a4 	. 
	ld a,e			;95c9	7b 	{ 
	ld b,d			;95ca	42 	B 
	dec d			;95cb	15 	. 
	dec e			;95cc	1d 	. 
	or h			;95cd	b4 	. 
	ld a,e			;95ce	7b 	{ 
	add a,b			;95cf	80 	. 
	ld (la841h),hl		;95d0	22 41 a8 	" A . 
	ld a,h			;95d3	7c 	| 
	nop			;95d4	00 	. 
	inc d			;95d5	14 	. 
	ld c,c			;95d6	49 	I 
	call nz,0207ch		;95d7	c4 7c 20 	. |   
	inc d			;95da	14 	. 
	ld c,e			;95db	4b 	K 
	jr z,l965ah		;95dc	28 7c 	( | 
	add a,b			;95de	80 	. 
	ld (0c841h),hl		;95df	22 41 c8 	" A . 
	ld a,l			;95e2	7d 	} 
	nop			;95e3	00 	. 
	inc d			;95e4	14 	. 
	ld c,d			;95e5	4a 	J 
	inc b			;95e6	04 	. 
	ld a,l			;95e7	7d 	} 
	jr nz,$+22		;95e8	20 14 	  . 
	ld c,e			;95ea	4b 	K 
	xor b			;95eb	a8 	. 
	ld a,l			;95ec	7d 	} 
	add a,b			;95ed	80 	. 
	ld (00842h),hl		;95ee	22 42 08 	" B . 
	ld a,(hl)			;95f1	7e 	~ 
	nop			;95f2	00 	. 
	inc d			;95f3	14 	. 
	ld c,l			;95f4	4d 	M 
	rlca			;95f5	07 	. 
	ld a,(hl)			;95f6	7e 	~ 
	inc h			;95f7	24 	$ 
	inc d			;95f8	14 	. 
	ld c,l			;95f9	4d 	M 
	out (07eh),a		;95fa	d3 7e 	. ~ 
l95fch:
	add a,b			;95fc	80 	. 
	ld (00c45h),hl		;95fd	22 45 0c 	" E . 
	ld a,(hl)			;9600	7e 	~ 
	and h			;9601	a4 	. 
	ld (0d445h),hl		;9602	22 45 d4 	" E . 
	ld a,a			;9605	7f 	 
	nop			;9606	00 	. 
	inc d			;9607	14 	. 
	ld c,c			;9608	49 	I 
	inc h			;9609	24 	$ 
	ld a,a			;960a	7f 	 
	add a,b			;960b	80 	. 
	ld (02841h),hl		;960c	22 41 28 	" A ( 
	add a,b			;960f	80 	. 
	nop			;9610	00 	. 
	ld e,049h		;9611	1e 49 	. I 
	ld b,h			;9613	44 	D 
	add a,b			;9614	80 	. 
	add a,b			;9615	80 	. 
	ld c,h			;9616	4c 	L 
	add hl,bc			;9617	09 	. 
	ld c,b			;9618	48 	H 
	add a,c			;9619	81 	. 
	nop			;961a	00 	. 
	ld e,049h		;961b	1e 49 	. I 
	ld h,h			;961d	64 	d 
	add a,c			;961e	81 	. 
	add a,b			;961f	80 	. 
	ld c,h			;9620	4c 	L 
	add hl,bc			;9621	09 	. 
	ld l,b			;9622	68 	h 
	add a,d			;9623	82 	. 
	nop			;9624	00 	. 
	ld e,049h		;9625	1e 49 	. I 
	add a,h			;9627	84 	. 
	add a,d			;9628	82 	. 
	add a,b			;9629	80 	. 
	ld c,h			;962a	4c 	L 
	add hl,bc			;962b	09 	. 
	adc a,b			;962c	88 	. 
	add a,e			;962d	83 	. 
	nop			;962e	00 	. 
	ld e,049h		;962f	1e 49 	. I 
	and h			;9631	a4 	. 
l9632h:
	add a,e			;9632	83 	. 
	add a,b			;9633	80 	. 
	ld c,h			;9634	4c 	L 
	add hl,bc			;9635	09 	. 
	xor b			;9636	a8 	. 
	add a,h			;9637	84 	. 
	nop			;9638	00 	. 
	ld e,049h		;9639	1e 49 	. I 
	call nz,02084h		;963b	c4 84 20 	. .   
	ld e,04bh		;963e	1e 4b 	. K 
	jr z,l95c6h		;9640	28 84 	( . 
	add a,b			;9642	80 	. 
	ld c,h			;9643	4c 	L 
	add hl,bc			;9644	09 	. 
	ret z			;9645	c8 	. 
	add a,l			;9646	85 	. 
	nop			;9647	00 	. 
	ld e,04ah		;9648	1e 4a 	. J 
	inc b			;964a	04 	. 
	add a,l			;964b	85 	. 
	jr nz,$+32		;964c	20 1e 	  . 
	ld c,e			;964e	4b 	K 
	xor b			;964f	a8 	. 
	add a,l			;9650	85 	. 
	add a,b			;9651	80 	. 
	ld c,h			;9652	4c 	L 
	ld a,(bc)			;9653	0a 	. 
	ex af,af'			;9654	08 	. 
	add a,(hl)			;9655	86 	. 
	nop			;9656	00 	. 
	ld e,04dh		;9657	1e 4d 	. M 
	rlca			;9659	07 	. 
l965ah:
	add a,(hl)			;965a	86 	. 
	inc h			;965b	24 	$ 
	ld e,04dh		;965c	1e 4d 	. M 
	out (086h),a		;965e	d3 86 	. . 
	add a,b			;9660	80 	. 
	ld c,h			;9661	4c 	L 
	dec c			;9662	0d 	. 
	rrca			;9663	0f 	. 
	add a,(hl)			;9664	86 	. 
	and h			;9665	a4 	. 
	ld c,h			;9666	4c 	L 
	dec c			;9667	0d 	. 
	rst 10h			;9668	d7 	. 
	add a,a			;9669	87 	. 
	nop			;966a	00 	. 
	ld e,049h		;966b	1e 49 	. I 
	inc h			;966d	24 	$ 
	add a,a			;966e	87 	. 
	add a,b			;966f	80 	. 
	ld c,h			;9670	4c 	L 
	add hl,bc			;9671	09 	. 
	jr z,l95fch		;9672	28 88 	( . 
	nop			;9674	00 	. 
	inc e			;9675	1c 	. 
	ld c,c			;9676	49 	I 
	ld b,h			;9677	44 	D 
	adc a,b			;9678	88 	. 
	add a,b			;9679	80 	. 
	ld c,h			;967a	4c 	L 
	ld de,08948h		;967b	11 48 89 	. H . 
	nop			;967e	00 	. 
	inc e			;967f	1c 	. 
	ld c,c			;9680	49 	I 
	ld h,h			;9681	64 	d 
	adc a,c			;9682	89 	. 
	add a,b			;9683	80 	. 
	ld c,h			;9684	4c 	L 
	ld de,l8a68h		;9685	11 68 8a 	. h . 
	nop			;9688	00 	. 
	inc e			;9689	1c 	. 
	ld c,c			;968a	49 	I 
	add a,h			;968b	84 	. 
	adc a,d			;968c	8a 	. 
	add a,b			;968d	80 	. 
	ld c,h			;968e	4c 	L 
	ld de,08b88h		;968f	11 88 8b 	. . . 
	nop			;9692	00 	. 
	inc e			;9693	1c 	. 
	ld c,c			;9694	49 	I 
	and h			;9695	a4 	. 
	adc a,e			;9696	8b 	. 
	add a,b			;9697	80 	. 
	ld c,h			;9698	4c 	L 
	ld de,l8ca8h		;9699	11 a8 8c 	. . . 
	nop			;969c	00 	. 
	inc e			;969d	1c 	. 
	ld c,c			;969e	49 	I 
	call nz,0208ch		;969f	c4 8c 20 	. .   
	inc e			;96a2	1c 	. 
	ld c,e			;96a3	4b 	K 
	jr z,l9632h		;96a4	28 8c 	( . 
	add a,b			;96a6	80 	. 
	ld c,h			;96a7	4c 	L 
	ld de,l8dc8h		;96a8	11 c8 8d 	. . . 
	nop			;96ab	00 	. 
	inc e			;96ac	1c 	. 
	ld c,d			;96ad	4a 	J 
	inc b			;96ae	04 	. 
	adc a,l			;96af	8d 	. 
	jr nz,l96ceh		;96b0	20 1c 	  . 
	ld c,e			;96b2	4b 	K 
	xor b			;96b3	a8 	. 
	adc a,l			;96b4	8d 	. 
	add a,b			;96b5	80 	. 
	ld c,h			;96b6	4c 	L 
	ld (de),a			;96b7	12 	. 
	ex af,af'			;96b8	08 	. 
	adc a,(hl)			;96b9	8e 	. 
	nop			;96ba	00 	. 
	inc e			;96bb	1c 	. 
	ld c,l			;96bc	4d 	M 
	rlca			;96bd	07 	. 
	adc a,(hl)			;96be	8e 	. 
	inc h			;96bf	24 	$ 
	inc e			;96c0	1c 	. 
	ld c,l			;96c1	4d 	M 
	out (08eh),a		;96c2	d3 8e 	. . 
	add a,b			;96c4	80 	. 
	ld c,h			;96c5	4c 	L 
	dec d			;96c6	15 	. 
	rrca			;96c7	0f 	. 
	adc a,(hl)			;96c8	8e 	. 
	and h			;96c9	a4 	. 
	ld c,h			;96ca	4c 	L 
	dec d			;96cb	15 	. 
	rst 10h			;96cc	d7 	. 
	adc a,a			;96cd	8f 	. 
l96ceh:
	nop			;96ce	00 	. 
	inc e			;96cf	1c 	. 
	ld c,c			;96d0	49 	I 
	inc h			;96d1	24 	$ 
	adc a,a			;96d2	8f 	. 
	add a,b			;96d3	80 	. 
l96d4h:
	ld c,h			;96d4	4c 	L 
	ld de,l9028h		;96d5	11 28 90 	. ( . 
	nop			;96d8	00 	. 
	ld l,d			;96d9	6a 	j 
	ld d,b			;96da	50 	P 
	inc b			;96db	04 	. 
	sub b			;96dc	90 	. 
	add a,b			;96dd	80 	. 
	ld c,h			;96de	4c 	L 
	add hl,de			;96df	19 	. 
	ld c,b			;96e0	48 	H 
	sub c			;96e1	91 	. 
	nop			;96e2	00 	. 
	ld l,d			;96e3	6a 	j 
	ld e,b			;96e4	58 	X 
	inc b			;96e5	04 	. 
	sub c			;96e6	91 	. 
	add a,b			;96e7	80 	. 
	ld c,h			;96e8	4c 	L 
	add hl,de			;96e9	19 	. 
	ld l,b			;96ea	68 	h 
	sub d			;96eb	92 	. 
	nop			;96ec	00 	. 
	ld l,d			;96ed	6a 	j 
	ld h,b			;96ee	60 	` 
	inc b			;96ef	04 	. 
	sub d			;96f0	92 	. 
	add a,b			;96f1	80 	. 
	ld c,h			;96f2	4c 	L 
	add hl,de			;96f3	19 	. 
	adc a,b			;96f4	88 	. 
	sub e			;96f5	93 	. 
	nop			;96f6	00 	. 
	ld l,d			;96f7	6a 	j 
	ld l,b			;96f8	68 	h 
	inc b			;96f9	04 	. 
	sub e			;96fa	93 	. 
	add a,b			;96fb	80 	. 
	ld c,h			;96fc	4c 	L 
	add hl,de			;96fd	19 	. 
	xor b			;96fe	a8 	. 
	sub h			;96ff	94 	. 
	nop			;9700	00 	. 
	ld l,d			;9701	6a 	j 
	ld (hl),b			;9702	70 	p 
	inc b			;9703	04 	. 
	sub h			;9704	94 	. 
	jr nz,$+108		;9705	20 6a 	  j 
	ret z			;9707	c8 	. 
	ex af,af'			;9708	08 	. 
	sub h			;9709	94 	. 
l970ah:
	add a,b			;970a	80 	. 
	ld c,h			;970b	4c 	L 
	add hl,de			;970c	19 	. 
	ret z			;970d	c8 	. 
	sub l			;970e	95 	. 
	nop			;970f	00 	. 
	ld l,d			;9710	6a 	j 
	add a,b			;9711	80 	. 
	inc b			;9712	04 	. 
	sub l			;9713	95 	. 
	jr nz,$+108		;9714	20 6a 	  j 
	ret pe			;9716	e8 	. 
	ex af,af'			;9717	08 	. 
	sub l			;9718	95 	. 
	add a,b			;9719	80 	. 
	ld c,h			;971a	4c 	L 
	ld a,(de)			;971b	1a 	. 
	ex af,af'			;971c	08 	. 
	sub (hl)			;971d	96 	. 
	nop			;971e	00 	. 
	ld l,e			;971f	6b 	k 
	ld b,b			;9720	40 	@ 
	rlca			;9721	07 	. 
	sub (hl)			;9722	96 	. 
	inc h			;9723	24 	$ 
	ld l,e			;9724	6b 	k 
	ld (hl),b			;9725	70 	p 
	inc de			;9726	13 	. 
	sub (hl)			;9727	96 	. 
	add a,b			;9728	80 	. 
	ld c,h			;9729	4c 	L 
	dec e			;972a	1d 	. 
	rrca			;972b	0f 	. 
	sub (hl)			;972c	96 	. 
	and h			;972d	a4 	. 
	ld c,h			;972e	4c 	L 
	dec e			;972f	1d 	. 
	rst 10h			;9730	d7 	. 
	sub a			;9731	97 	. 
	nop			;9732	00 	. 
	ld l,d			;9733	6a 	j 
	ld c,b			;9734	48 	H 
	inc b			;9735	04 	. 
	sub a			;9736	97 	. 
	add a,b			;9737	80 	. 
	ld c,h			;9738	4c 	L 
	add hl,de			;9739	19 	. 
	jr z,l96d4h		;973a	28 98 	( . 
	nop			;973c	00 	. 
	ld e,(hl)			;973d	5e 	^ 
	ld c,c			;973e	49 	I 
	ld b,h			;973f	44 	D 
	sbc a,b			;9740	98 	. 
	add a,b			;9741	80 	. 
	ld c,h			;9742	4c 	L 
	ld hl,l9948h		;9743	21 48 99 	! H . 
	nop			;9746	00 	. 
	ld e,(hl)			;9747	5e 	^ 
	ld c,c			;9748	49 	I 
	ld h,h			;9749	64 	d 
l974ah:
	sbc a,c			;974a	99 	. 
	add a,b			;974b	80 	. 
	ld c,h			;974c	4c 	L 
	ld hl,l9a68h		;974d	21 68 9a 	! h . 
	nop			;9750	00 	. 
	ld e,(hl)			;9751	5e 	^ 
	ld c,c			;9752	49 	I 
	add a,h			;9753	84 	. 
	sbc a,d			;9754	9a 	. 
	add a,b			;9755	80 	. 
	ld c,h			;9756	4c 	L 
	ld hl,l9b88h		;9757	21 88 9b 	! . . 
l975ah:
	nop			;975a	00 	. 
	ld e,(hl)			;975b	5e 	^ 
	ld c,c			;975c	49 	I 
	and h			;975d	a4 	. 
	sbc a,e			;975e	9b 	. 
	add a,b			;975f	80 	. 
	ld c,h			;9760	4c 	L 
	ld hl,09ca8h		;9761	21 a8 9c 	! . . 
	nop			;9764	00 	. 
	ld e,(hl)			;9765	5e 	^ 
	ld c,c			;9766	49 	I 
	call nz,0209ch		;9767	c4 9c 20 	. .   
	ld e,(hl)			;976a	5e 	^ 
	ld c,e			;976b	4b 	K 
	jr z,l970ah		;976c	28 9c 	( . 
l976eh:
	add a,b			;976e	80 	. 
	ld c,h			;976f	4c 	L 
	ld hl,l9dc8h		;9770	21 c8 9d 	! . . 
	nop			;9773	00 	. 
	ld e,(hl)			;9774	5e 	^ 
	ld c,d			;9775	4a 	J 
	inc b			;9776	04 	. 
	sbc a,l			;9777	9d 	. 
	jr nz,l97d8h		;9778	20 5e 	  ^ 
l977ah:
	ld c,e			;977a	4b 	K 
	xor b			;977b	a8 	. 
	sbc a,l			;977c	9d 	. 
	add a,b			;977d	80 	. 
	ld c,h			;977e	4c 	L 
	ld (09e08h),hl		;977f	22 08 9e 	" . . 
	nop			;9782	00 	. 
	ld e,(hl)			;9783	5e 	^ 
	ld c,l			;9784	4d 	M 
	rlca			;9785	07 	. 
	sbc a,(hl)			;9786	9e 	. 
	inc h			;9787	24 	$ 
	ld e,(hl)			;9788	5e 	^ 
	ld c,l			;9789	4d 	M 
	out (09eh),a		;978a	d3 9e 	. . 
	add a,b			;978c	80 	. 
	ld c,h			;978d	4c 	L 
	dec h			;978e	25 	% 
	rrca			;978f	0f 	. 
	sbc a,(hl)			;9790	9e 	. 
	and h			;9791	a4 	. 
	ld c,h			;9792	4c 	L 
	dec h			;9793	25 	% 
	rst 10h			;9794	d7 	. 
	sbc a,a			;9795	9f 	. 
	nop			;9796	00 	. 
	ld e,(hl)			;9797	5e 	^ 
	ld c,c			;9798	49 	I 
	inc h			;9799	24 	$ 
	sbc a,a			;979a	9f 	. 
	add a,b			;979b	80 	. 
	ld c,h			;979c	4c 	L 
	ld hl,la028h		;979d	21 28 a0 	! ( . 
	nop			;97a0	00 	. 
	jr nz,l97f3h		;97a1	20 50 	  P 
	inc b			;97a3	04 	. 
	and b			;97a4	a0 	. 
	ld b,b			;97a5	40 	@ 
	ld a,000h		;97a6	3e 00 	> . 
	djnz l974ah		;97a8	10 a0 	. . 
	add a,b			;97aa	80 	. 
	ld c,h			;97ab	4c 	L 
	add hl,hl			;97ac	29 	) 
	ld c,b			;97ad	48 	H 
	and c			;97ae	a1 	. 
	nop			;97af	00 	. 
	jr nz,l980ah		;97b0	20 58 	  X 
	inc b			;97b2	04 	. 
	and c			;97b3	a1 	. 
	ld b,b			;97b4	40 	@ 
	jr z,l97b7h		;97b5	28 00 	( . 
l97b7h:
	djnz l975ah		;97b7	10 a1 	. . 
	add a,b			;97b9	80 	. 
	ld c,h			;97ba	4c 	L 
	add hl,hl			;97bb	29 	) 
	ld l,b			;97bc	68 	h 
	and d			;97bd	a2 	. 
	nop			;97be	00 	. 
	jr nz,$+98		;97bf	20 60 	  ` 
	inc b			;97c1	04 	. 
	and d			;97c2	a2 	. 
	ld b,b			;97c3	40 	@ 
	ld a,(01000h)		;97c4	3a 00 10 	: . . 
	and d			;97c7	a2 	. 
	add a,b			;97c8	80 	. 
	ld c,h			;97c9	4c 	L 
l97cah:
	add hl,hl			;97ca	29 	) 
	adc a,b			;97cb	88 	. 
	and e			;97cc	a3 	. 
	nop			;97cd	00 	. 
	jr nz,l9838h		;97ce	20 68 	  h 
	inc b			;97d0	04 	. 
	and e			;97d1	a3 	. 
	ld b,b			;97d2	40 	@ 
	adc a,(hl)			;97d3	8e 	. 
	nop			;97d4	00 	. 
	djnz l977ah		;97d5	10 a3 	. . 
	add a,b			;97d7	80 	. 
l97d8h:
	ld c,h			;97d8	4c 	L 
	add hl,hl			;97d9	29 	) 
l97dah:
	xor b			;97da	a8 	. 
	and h			;97db	a4 	. 
	nop			;97dc	00 	. 
	jr nz,l984fh		;97dd	20 70 	  p 
	inc b			;97df	04 	. 
	and h			;97e0	a4 	. 
	jr nz,l9803h		;97e1	20 20 	    
	ret z			;97e3	c8 	. 
	ex af,af'			;97e4	08 	. 
	and h			;97e5	a4 	. 
	add a,b			;97e6	80 	. 
	ld c,h			;97e7	4c 	L 
	add hl,hl			;97e8	29 	) 
	ret z			;97e9	c8 	. 
l97eah:
	and l			;97ea	a5 	. 
	nop			;97eb	00 	. 
	jr nz,l976eh		;97ec	20 80 	  . 
	inc b			;97ee	04 	. 
	and l			;97ef	a5 	. 
	jr nz,l9812h		;97f0	20 20 	    
	ret pe			;97f2	e8 	. 
l97f3h:
	ex af,af'			;97f3	08 	. 
	and l			;97f4	a5 	. 
	add a,b			;97f5	80 	. 
	ld c,h			;97f6	4c 	L 
	ld hl,(la608h)		;97f7	2a 08 a6 	* . . 
l97fah:
	nop			;97fa	00 	. 
	ld hl,00740h		;97fb	21 40 07 	! @ . 
	and (hl)			;97fe	a6 	. 
	inc h			;97ff	24 	$ 
	ld hl,01370h		;9800	21 70 13 	! p . 
l9803h:
	and (hl)			;9803	a6 	. 
	add a,b			;9804	80 	. 
	ld c,h			;9805	4c 	L 
	dec l			;9806	2d 	- 
	rrca			;9807	0f 	. 
	and (hl)			;9808	a6 	. 
	and h			;9809	a4 	. 
l980ah:
	ld c,h			;980a	4c 	L 
	dec l			;980b	2d 	- 
	rst 10h			;980c	d7 	. 
	and a			;980d	a7 	. 
	nop			;980e	00 	. 
	jr nz,l9859h		;980f	20 48 	  H 
	inc b			;9811	04 	. 
l9812h:
	and a			;9812	a7 	. 
	add a,b			;9813	80 	. 
	ld c,h			;9814	4c 	L 
	add hl,hl			;9815	29 	) 
	jr z,$-86		;9816	28 a8 	( . 
	nop			;9818	00 	. 
	ld l,h			;9819	6c 	l 
	ld d,b			;981a	50 	P 
	inc b			;981b	04 	. 
	xor b			;981c	a8 	. 
	ld b,b			;981d	40 	@ 
	inc a			;981e	3c 	< 
	nop			;981f	00 	. 
	djnz l97cah		;9820	10 a8 	. . 
	add a,b			;9822	80 	. 
	ld c,h			;9823	4c 	L 
	ld sp,la948h		;9824	31 48 a9 	1 H . 
	nop			;9827	00 	. 
	ld l,h			;9828	6c 	l 
	ld e,b			;9829	58 	X 
	inc b			;982a	04 	. 
	xor c			;982b	a9 	. 
	ld b,b			;982c	40 	@ 
	ld h,000h		;982d	26 00 	& . 
	djnz l97dah		;982f	10 a9 	. . 
	add a,b			;9831	80 	. 
	ld c,h			;9832	4c 	L 
	ld sp,laa68h		;9833	31 68 aa 	1 h . 
	nop			;9836	00 	. 
	ld l,h			;9837	6c 	l 
l9838h:
	ld h,b			;9838	60 	` 
	inc b			;9839	04 	. 
	xor d			;983a	aa 	. 
	ld b,b			;983b	40 	@ 
	jr c,l983eh		;983c	38 00 	8 . 
l983eh:
	djnz l97eah		;983e	10 aa 	. . 
	add a,b			;9840	80 	. 
	ld c,h			;9841	4c 	L 
	ld sp,lab88h		;9842	31 88 ab 	1 . . 
	nop			;9845	00 	. 
	ld l,h			;9846	6c 	l 
	ld l,b			;9847	68 	h 
	inc b			;9848	04 	. 
	xor e			;9849	ab 	. 
	ld b,b			;984a	40 	@ 
	adc a,h			;984b	8c 	. 
	nop			;984c	00 	. 
	djnz l97fah		;984d	10 ab 	. . 
l984fh:
	add a,b			;984f	80 	. 
	ld c,h			;9850	4c 	L 
	ld sp,0aca8h		;9851	31 a8 ac 	1 . . 
	nop			;9854	00 	. 
	ld l,h			;9855	6c 	l 
	ld (hl),b			;9856	70 	p 
	inc b			;9857	04 	. 
	xor h			;9858	ac 	. 
l9859h:
	jr nz,l98c7h		;9859	20 6c 	  l 
	ret z			;985b	c8 	. 
	ex af,af'			;985c	08 	. 
	xor h			;985d	ac 	. 
	add a,b			;985e	80 	. 
	ld c,h			;985f	4c 	L 
	ld sp,0adc8h		;9860	31 c8 ad 	1 . . 
	nop			;9863	00 	. 
	ld l,h			;9864	6c 	l 
	add a,b			;9865	80 	. 
	inc b			;9866	04 	. 
	xor l			;9867	ad 	. 
	jr nz,l98d6h		;9868	20 6c 	  l 
	ret pe			;986a	e8 	. 
	ex af,af'			;986b	08 	. 
	xor l			;986c	ad 	. 
	add a,b			;986d	80 	. 
	ld c,h			;986e	4c 	L 
	ld (0ae08h),a		;986f	32 08 ae 	2 . . 
	nop			;9872	00 	. 
	ld l,l			;9873	6d 	m 
	ld b,b			;9874	40 	@ 
	rlca			;9875	07 	. 
	xor (hl)			;9876	ae 	. 
	inc h			;9877	24 	$ 
	ld l,l			;9878	6d 	m 
	ld (hl),b			;9879	70 	p 
	inc de			;987a	13 	. 
	xor (hl)			;987b	ae 	. 
	add a,b			;987c	80 	. 
	ld c,h			;987d	4c 	L 
	dec (hl)			;987e	35 	5 
	rrca			;987f	0f 	. 
	xor (hl)			;9880	ae 	. 
	and h			;9881	a4 	. 
	ld c,h			;9882	4c 	L 
	dec (hl)			;9883	35 	5 
	rst 10h			;9884	d7 	. 
	xor a			;9885	af 	. 
	nop			;9886	00 	. 
	ld l,h			;9887	6c 	l 
	ld c,b			;9888	48 	H 
	inc b			;9889	04 	. 
	xor a			;988a	af 	. 
	add a,b			;988b	80 	. 
	ld c,h			;988c	4c 	L 
	ld sp,0b028h		;988d	31 28 b0 	1 ( . 
	nop			;9890	00 	. 
	ld d,050h		;9891	16 50 	. P 
	inc b			;9893	04 	. 
	or b			;9894	b0 	. 
	ld b,b			;9895	40 	@ 
	add a,(hl)			;9896	86 	. 
	nop			;9897	00 	. 
	dec d			;9898	15 	. 
	or b			;9899	b0 	. 
	add a,b			;989a	80 	. 
	ld c,h			;989b	4c 	L 
	add hl,sp			;989c	39 	9 
	ld c,b			;989d	48 	H 
	or c			;989e	b1 	. 
	nop			;989f	00 	. 
	ld d,058h		;98a0	16 58 	. X 
	inc b			;98a2	04 	. 
	or c			;98a3	b1 	. 
	ld b,b			;98a4	40 	@ 
	ld (hl),d			;98a5	72 	r 
	nop			;98a6	00 	. 
	dec d			;98a7	15 	. 
	or c			;98a8	b1 	. 
	add a,b			;98a9	80 	. 
	ld c,h			;98aa	4c 	L 
	add hl,sp			;98ab	39 	9 
	ld l,b			;98ac	68 	h 
	or d			;98ad	b2 	. 
	nop			;98ae	00 	. 
	ld d,060h		;98af	16 60 	. ` 
	inc b			;98b1	04 	. 
	or d			;98b2	b2 	. 
	ld b,b			;98b3	40 	@ 
	add a,d			;98b4	82 	. 
	nop			;98b5	00 	. 
	dec d			;98b6	15 	. 
	or d			;98b7	b2 	. 
	add a,b			;98b8	80 	. 
	ld c,h			;98b9	4c 	L 
	add hl,sp			;98ba	39 	9 
	adc a,b			;98bb	88 	. 
	or e			;98bc	b3 	. 
	nop			;98bd	00 	. 
	ld d,068h		;98be	16 68 	. h 
l98c0h:
	inc b			;98c0	04 	. 
	or e			;98c1	b3 	. 
	ld b,b			;98c2	40 	@ 
	adc a,d			;98c3	8a 	. 
	nop			;98c4	00 	. 
	dec d			;98c5	15 	. 
	or e			;98c6	b3 	. 
l98c7h:
	add a,b			;98c7	80 	. 
	ld c,h			;98c8	4c 	L 
	add hl,sp			;98c9	39 	9 
	xor b			;98ca	a8 	. 
	or h			;98cb	b4 	. 
	nop			;98cc	00 	. 
	ld d,070h		;98cd	16 70 	. p 
	inc b			;98cf	04 	. 
	or h			;98d0	b4 	. 
	jr nz,$+24		;98d1	20 16 	  . 
	ret z			;98d3	c8 	. 
	ex af,af'			;98d4	08 	. 
	or h			;98d5	b4 	. 
l98d6h:
	add a,b			;98d6	80 	. 
	ld c,h			;98d7	4c 	L 
	add hl,sp			;98d8	39 	9 
	ret z			;98d9	c8 	. 
	or l			;98da	b5 	. 
	nop			;98db	00 	. 
	ld d,080h		;98dc	16 80 	. . 
	inc b			;98de	04 	. 
	or l			;98df	b5 	. 
	jr nz,l98f8h		;98e0	20 16 	  . 
	ret pe			;98e2	e8 	. 
	ex af,af'			;98e3	08 	. 
	or l			;98e4	b5 	. 
	add a,b			;98e5	80 	. 
	ld c,h			;98e6	4c 	L 
	ld a,(0b608h)		;98e7	3a 08 b6 	: . . 
	nop			;98ea	00 	. 
	rla			;98eb	17 	. 
	ld b,b			;98ec	40 	@ 
	rlca			;98ed	07 	. 
	or (hl)			;98ee	b6 	. 
	inc h			;98ef	24 	$ 
	rla			;98f0	17 	. 
	ld (hl),b			;98f1	70 	p 
	inc de			;98f2	13 	. 
	or (hl)			;98f3	b6 	. 
	add a,b			;98f4	80 	. 
	ld c,h			;98f5	4c 	L 
	dec a			;98f6	3d 	= 
	rrca			;98f7	0f 	. 
l98f8h:
	or (hl)			;98f8	b6 	. 
	and h			;98f9	a4 	. 
	ld c,h			;98fa	4c 	L 
	dec a			;98fb	3d 	= 
	rst 10h			;98fc	d7 	. 
	or a			;98fd	b7 	. 
	nop			;98fe	00 	. 
	ld d,048h		;98ff	16 48 	. H 
	inc b			;9901	04 	. 
	or a			;9902	b7 	. 
	add a,b			;9903	80 	. 
	ld c,h			;9904	4c 	L 
	add hl,sp			;9905	39 	9 
	jr z,l98c0h		;9906	28 b8 	( . 
	nop			;9908	00 	. 
	inc b			;9909	04 	. 
	ld d,b			;990a	50 	P 
	inc b			;990b	04 	. 
	cp b			;990c	b8 	. 
	ld b,b			;990d	40 	@ 
	add a,h			;990e	84 	. 
	nop			;990f	00 	. 
	dec d			;9910	15 	. 
	cp b			;9911	b8 	. 
	add a,b			;9912	80 	. 
	ld c,h			;9913	4c 	L 
	ld b,c			;9914	41 	A 
	ld c,b			;9915	48 	H 
	cp c			;9916	b9 	. 
	nop			;9917	00 	. 
	inc b			;9918	04 	. 
	ld e,b			;9919	58 	X 
	inc b			;991a	04 	. 
	cp c			;991b	b9 	. 
	ld b,b			;991c	40 	@ 
	ld (hl),b			;991d	70 	p 
	nop			;991e	00 	. 
	dec d			;991f	15 	. 
	cp c			;9920	b9 	. 
	add a,b			;9921	80 	. 
	ld c,h			;9922	4c 	L 
	ld b,c			;9923	41 	A 
	ld l,b			;9924	68 	h 
	cp d			;9925	ba 	. 
	nop			;9926	00 	. 
	inc b			;9927	04 	. 
	ld h,b			;9928	60 	` 
	inc b			;9929	04 	. 
	cp d			;992a	ba 	. 
	ld b,b			;992b	40 	@ 
	add a,b			;992c	80 	. 
	nop			;992d	00 	. 
	dec d			;992e	15 	. 
	cp d			;992f	ba 	. 
	add a,b			;9930	80 	. 
	ld c,h			;9931	4c 	L 
	ld b,c			;9932	41 	A 
	adc a,b			;9933	88 	. 
	cp e			;9934	bb 	. 
	nop			;9935	00 	. 
	inc b			;9936	04 	. 
	ld l,b			;9937	68 	h 
	inc b			;9938	04 	. 
	cp e			;9939	bb 	. 
	ld b,b			;993a	40 	@ 
	adc a,b			;993b	88 	. 
	nop			;993c	00 	. 
	dec d			;993d	15 	. 
	cp e			;993e	bb 	. 
	add a,b			;993f	80 	. 
l9940h:
	ld c,h			;9940	4c 	L 
	ld b,c			;9941	41 	A 
	xor b			;9942	a8 	. 
	cp h			;9943	bc 	. 
	nop			;9944	00 	. 
	inc b			;9945	04 	. 
	ld (hl),b			;9946	70 	p 
	inc b			;9947	04 	. 
l9948h:
	cp h			;9948	bc 	. 
	jr nz,l994fh		;9949	20 04 	  . 
	ret z			;994b	c8 	. 
	ex af,af'			;994c	08 	. 
	cp h			;994d	bc 	. 
	add a,b			;994e	80 	. 
l994fh:
	ld c,h			;994f	4c 	L 
	ld b,c			;9950	41 	A 
	ret z			;9951	c8 	. 
	cp l			;9952	bd 	. 
	nop			;9953	00 	. 
	inc b			;9954	04 	. 
	add a,b			;9955	80 	. 
	inc b			;9956	04 	. 
	cp l			;9957	bd 	. 
	jr nz,l995eh		;9958	20 04 	  . 
	ret pe			;995a	e8 	. 
	ex af,af'			;995b	08 	. 
	cp l			;995c	bd 	. 
	add a,b			;995d	80 	. 
l995eh:
	ld c,h			;995e	4c 	L 
	ld b,d			;995f	42 	B 
	ex af,af'			;9960	08 	. 
	cp (hl)			;9961	be 	. 
	nop			;9962	00 	. 
	dec b			;9963	05 	. 
	ld b,b			;9964	40 	@ 
	rlca			;9965	07 	. 
	cp (hl)			;9966	be 	. 
	inc h			;9967	24 	$ 
	dec b			;9968	05 	. 
	ld (hl),b			;9969	70 	p 
	inc de			;996a	13 	. 
	cp (hl)			;996b	be 	. 
	add a,b			;996c	80 	. 
	ld c,h			;996d	4c 	L 
	ld b,l			;996e	45 	E 
	rrca			;996f	0f 	. 
	cp (hl)			;9970	be 	. 
	and h			;9971	a4 	. 
	ld c,h			;9972	4c 	L 
	ld b,l			;9973	45 	E 
	rst 10h			;9974	d7 	. 
	cp a			;9975	bf 	. 
	nop			;9976	00 	. 
	inc b			;9977	04 	. 
	ld c,b			;9978	48 	H 
	inc b			;9979	04 	. 
	cp a			;997a	bf 	. 
	add a,b			;997b	80 	. 
	ld c,h			;997c	4c 	L 
	ld b,c			;997d	41 	A 
	jr z,l9940h		;997e	28 c0 	( . 
	nop			;9980	00 	. 
	ld c,a			;9981	4f 	O 
	nop			;9982	00 	. 
	dec b			;9983	05 	. 
	ret nz			;9984	c0 	. 
	add a,b			;9985	80 	. 
	ld h,d			;9986	62 	b 
	add hl,bc			;9987	09 	. 
	ld c,b			;9988	48 	H 
	pop bc			;9989	c1 	. 
	nop			;998a	00 	. 
	ld c,b			;998b	48 	H 
	or b			;998c	b0 	. 
	ld a,(bc)			;998d	0a 	. 
	pop bc			;998e	c1 	. 
	add a,b			;998f	80 	. 
	ld h,d			;9990	62 	b 
l9991h:
	add hl,bc			;9991	09 	. 
	ld l,b			;9992	68 	h 
	jp nz,01102h		;9993	c2 02 11 	. . . 
	dec b			;9996	05 	. 
	adc a,d			;9997	8a 	. 
	jp nz,06280h		;9998	c2 80 62 	. . b 
	add hl,bc			;999b	09 	. 
	adc a,b			;999c	88 	. 
l999dh:
	jp 01102h		;999d	c3 02 11 	. . . 
	ld h,b			;99a0	60 	` 
	ld a,(bc)			;99a1	0a 	. 
	jp 06280h		;99a2	c3 80 62 	. . b 
	add hl,bc			;99a5	09 	. 
	xor b			;99a6	a8 	. 
	call nz,l6f01h+1		;99a7	c4 02 6f 	. . o 
	dec b			;99aa	05 	. 
	adc a,c			;99ab	89 	. 
	call nz,06280h		;99ac	c4 80 62 	. . b 
	add hl,bc			;99af	09 	. 
	ret z			;99b0	c8 	. 
	push bc			;99b1	c5 	. 
	nop			;99b2	00 	. 
	sub b			;99b3	90 	. 
	or b			;99b4	b0 	. 
	dec bc			;99b5	0b 	. 
	push bc			;99b6	c5 	. 
	add a,b			;99b7	80 	. 
	ld h,d			;99b8	62 	b 
	ld a,(bc)			;99b9	0a 	. 
	ex af,af'			;99ba	08 	. 
	add a,001h		;99bb	c6 01 	. . 
	ld e,04dh		;99bd	1e 4d 	. M 
	add a,a			;99bf	87 	. 
	add a,080h		;99c0	c6 80 	. . 
	ld h,d			;99c2	62 	b 
	dec c			;99c3	0d 	. 
	rrca			;99c4	0f 	. 
	add a,0a4h		;99c5	c6 a4 	. . 
	ld h,d			;99c7	62 	b 
	dec c			;99c8	0d 	. 
	rst 10h			;99c9	d7 	. 
	rst 0			;99ca	c7 	. 
	ld b,05dh		;99cb	06 5d 	. ] 
	ld h,b			;99cd	60 	` 
	dec bc			;99ce	0b 	. 
	rst 0			;99cf	c7 	. 
	add a,b			;99d0	80 	. 
	ld h,d			;99d1	62 	b 
	add hl,bc			;99d2	09 	. 
	jr z,l999dh		;99d3	28 c8 	( . 
	nop			;99d5	00 	. 
	ld c,(hl)			;99d6	4e 	N 
	and b			;99d7	a0 	. 
	dec b			;99d8	05 	. 
	ret z			;99d9	c8 	. 
	add a,b			;99da	80 	. 
	ld h,d			;99db	62 	b 
	ld de,0c948h		;99dc	11 48 c9 	. H . 
	nop			;99df	00 	. 
	ld c,(hl)			;99e0	4e 	N 
	nop			;99e1	00 	. 
	dec b			;99e2	05 	. 
	ret			;99e3	c9 	. 
	add a,b			;99e4	80 	. 
	ld h,d			;99e5	62 	b 
	ld de,0ca68h		;99e6	11 68 ca 	. h . 
	ld (bc),a			;99e9	02 	. 
	djnz l9991h		;99ea	10 a5 	. . 
	adc a,d			;99ec	8a 	. 
	jp z,06280h		;99ed	ca 80 62 	. . b 
	ld de,0cb88h		;99f0	11 88 cb 	. . . 
	add a,b			;99f3	80 	. 
	ld h,d			;99f4	62 	b 
	ld de,0cca8h		;99f5	11 a8 cc 	. . . 
	ld (bc),a			;99f8	02 	. 
	ld l,(hl)			;99f9	6e 	n 
	and l			;99fa	a5 	. 
	adc a,c			;99fb	89 	. 
	call z,06280h		;99fc	cc 80 62 	. . b 
	ld de,0cdc8h		;99ff	11 c8 cd 	. . . 
	ld (bc),a			;9a02	02 	. 
	ld l,a			;9a03	6f 	o 
	ld h,b			;9a04	60 	` 
	add hl,bc			;9a05	09 	. 
	call 06280h		;9a06	cd 80 62 	. . b 
	ld (de),a			;9a09	12 	. 
	ex af,af'			;9a0a	08 	. 
	adc a,001h		;9a0b	ce 01 	. . 
	inc e			;9a0d	1c 	. 
	ld c,l			;9a0e	4d 	M 
	add a,a			;9a0f	87 	. 
	adc a,080h		;9a10	ce 80 	. . 
	ld h,d			;9a12	62 	b 
	dec d			;9a13	15 	. 
	rrca			;9a14	0f 	. 
	adc a,0a4h		;9a15	ce a4 	. . 
	ld h,d			;9a17	62 	b 
	dec d			;9a18	15 	. 
	rst 10h			;9a19	d7 	. 
	rst 8			;9a1a	cf 	. 
	add a,b			;9a1b	80 	. 
	ld h,d			;9a1c	62 	b 
	ld de,0d028h		;9a1d	11 28 d0 	. ( . 
	nop			;9a20	00 	. 
	ld c,(hl)			;9a21	4e 	N 
	ret m			;9a22	f8 	. 
	dec b			;9a23	05 	. 
	ret nc			;9a24	d0 	. 
	add a,b			;9a25	80 	. 
	ld h,d			;9a26	62 	b 
	add hl,de			;9a27	19 	. 
	ld c,b			;9a28	48 	H 
	pop de			;9a29	d1 	. 
	nop			;9a2a	00 	. 
	ld c,b			;9a2b	48 	H 
	cp b			;9a2c	b8 	. 
	ld a,(bc)			;9a2d	0a 	. 
	pop de			;9a2e	d1 	. 
	add a,b			;9a2f	80 	. 
	ld h,d			;9a30	62 	b 
	add hl,de			;9a31	19 	. 
	ld l,b			;9a32	68 	h 
	jp nc,01002h		;9a33	d2 02 10 	. . . 
	defb 0fdh,08ah,0d2h	;illegal sequence		;9a36	fd 8a d2 	. . . 
	add a,b			;9a39	80 	. 
	ld h,d			;9a3a	62 	b 
	add hl,de			;9a3b	19 	. 
	adc a,b			;9a3c	88 	. 
	out (001h),a		;9a3d	d3 01 	. . 
	ld b,a			;9a3f	47 	G 
	ld l,c			;9a40	69 	i 
	dec hl			;9a41	2b 	+ 
	out (080h),a		;9a42	d3 80 	. . 
	ld h,d			;9a44	62 	b 
	add hl,de			;9a45	19 	. 
	xor b			;9a46	a8 	. 
	call nc,sub_6e02h		;9a47	d4 02 6e 	. . n 
	defb 0fdh,089h,0d4h	;illegal sequence		;9a4a	fd 89 d4 	. . . 
	add a,b			;9a4d	80 	. 
	ld h,d			;9a4e	62 	b 
	add hl,de			;9a4f	19 	. 
	ret z			;9a50	c8 	. 
	push de			;9a51	d5 	. 
	nop			;9a52	00 	. 
	sub b			;9a53	90 	. 
	cp b			;9a54	b8 	. 
	dec bc			;9a55	0b 	. 
	push de			;9a56	d5 	. 
	add a,b			;9a57	80 	. 
	ld h,d			;9a58	62 	b 
	ld a,(de)			;9a59	1a 	. 
	ex af,af'			;9a5a	08 	. 
	sub 001h		;9a5b	d6 01 	. . 
	ld l,e			;9a5d	6b 	k 
	ld h,b			;9a5e	60 	` 
	rlca			;9a5f	07 	. 
	sub 080h		;9a60	d6 80 	. . 
	ld h,d			;9a62	62 	b 
	dec e			;9a63	1d 	. 
	rrca			;9a64	0f 	. 
	sub 0a4h		;9a65	d6 a4 	. . 
	ld h,d			;9a67	62 	b 
l9a68h:
	dec e			;9a68	1d 	. 
	rst 10h			;9a69	d7 	. 
	rst 10h			;9a6a	d7 	. 
	add a,b			;9a6b	80 	. 
	ld h,d			;9a6c	62 	b 
	add hl,de			;9a6d	19 	. 
	jr z,$-38		;9a6e	28 d8 	( . 
	nop			;9a70	00 	. 
	ld c,(hl)			;9a71	4e 	N 
	ld e,b			;9a72	58 	X 
	dec b			;9a73	05 	. 
	ret c			;9a74	d8 	. 
	add a,b			;9a75	80 	. 
	ld h,d			;9a76	62 	b 
	ld hl,0d948h		;9a77	21 48 d9 	! H . 
	nop			;9a7a	00 	. 
	inc (hl)			;9a7b	34 	4 
	nop			;9a7c	00 	. 
	inc b			;9a7d	04 	. 
	exx			;9a7e	d9 	. 
	add a,b			;9a7f	80 	. 
l9a80h:
	ld h,d			;9a80	62 	b 
	ld hl,0da68h		;9a81	21 68 da 	! h . 
	ld (bc),a			;9a84	02 	. 
	djnz $+95		;9a85	10 5d 	. ] 
	adc a,d			;9a87	8a 	. 
	jp c,06280h		;9a88	da 80 62 	. . b 
	ld hl,0db88h		;9a8b	21 88 db 	! . . 
l9a8eh:
	ld bc,04d0eh		;9a8e	01 0e 4d 	. . M 
	xor e			;9a91	ab 	. 
	in a,(080h)		;9a92	db 80 	. . 
	ld h,d			;9a94	62 	b 
	ld hl,0dca8h		;9a95	21 a8 dc 	! . . 
	ld (bc),a			;9a98	02 	. 
	ld l,(hl)			;9a99	6e 	n 
	ld e,l			;9a9a	5d 	] 
	adc a,c			;9a9b	89 	. 
	call c,06280h		;9a9c	dc 80 62 	. . b 
	ld hl,0ddc8h		;9a9f	21 c8 dd 	! . . 
	add a,b			;9aa2	80 	. 
	ld h,d			;9aa3	62 	b 
	ld (0de08h),hl		;9aa4	22 08 de 	" . . 
	ld bc,04d5eh		;9aa7	01 5e 4d 	. ^ M 
	add a,a			;9aaa	87 	. 
	sbc a,080h		;9aab	de 80 	. . 
	ld h,d			;9aad	62 	b 
	dec h			;9aae	25 	% 
	rrca			;9aaf	0f 	. 
	sbc a,0a4h		;9ab0	de a4 	. . 
	ld h,d			;9ab2	62 	b 
	dec h			;9ab3	25 	% 
	rst 10h			;9ab4	d7 	. 
	rst 18h			;9ab5	df 	. 
	add a,b			;9ab6	80 	. 
	ld h,d			;9ab7	62 	b 
	ld hl,0e028h		;9ab8	21 28 e0 	! ( . 
	nop			;9abb	00 	. 
	ld c,a			;9abc	4f 	O 
	djnz l9ac4h		;9abd	10 05 	. . 
	ret po			;9abf	e0 	. 
	add a,b			;9ac0	80 	. 
	ld h,d			;9ac1	62 	b 
	add hl,hl			;9ac2	29 	) 
	ld c,b			;9ac3	48 	H 
l9ac4h:
	pop hl			;9ac4	e1 	. 
	nop			;9ac5	00 	. 
	ld c,b			;9ac6	48 	H 
	ret nz			;9ac7	c0 	. 
	ld a,(bc)			;9ac8	0a 	. 
	pop hl			;9ac9	e1 	. 
	jr nz,l9b14h		;9aca	20 48 	  H 
	ret c			;9acc	d8 	. 
	ld c,0e1h		;9acd	0e e1 	. . 
	add a,b			;9acf	80 	. 
	ld h,d			;9ad0	62 	b 
	add hl,hl			;9ad1	29 	) 
	ld l,b			;9ad2	68 	h 
	jp po,01102h		;9ad3	e2 02 11 	. . . 
	dec d			;9ad6	15 	. 
	adc a,d			;9ad7	8a 	. 
	jp po,06280h		;9ad8	e2 80 62 	. . b 
	add hl,hl			;9adb	29 	) 
	adc a,b			;9adc	88 	. 
	ex (sp),hl			;9add	e3 	. 
	nop			;9ade	00 	. 
	dec bc			;9adf	0b 	. 
	ld e,e			;9ae0	5b 	[ 
	inc de			;9ae1	13 	. 
	ex (sp),hl			;9ae2	e3 	. 
	jr nz,l9af0h		;9ae3	20 0b 	  . 
	ld e,e			;9ae5	5b 	[ 
	ld (hl),a			;9ae6	77 	w 
	ex (sp),hl			;9ae7	e3 	. 
	add a,b			;9ae8	80 	. 
	ld h,d			;9ae9	62 	b 
	add hl,hl			;9aea	29 	) 
	xor b			;9aeb	a8 	. 
	call po,l6f01h+1		;9aec	e4 02 6f 	. . o 
	dec d			;9aef	15 	. 
l9af0h:
	adc a,c			;9af0	89 	. 
	call po,06280h		;9af1	e4 80 62 	. . b 
	add hl,hl			;9af4	29 	) 
	ret z			;9af5	c8 	. 
	push hl			;9af6	e5 	. 
	nop			;9af7	00 	. 
	sub b			;9af8	90 	. 
	ret nz			;9af9	c0 	. 
	dec bc			;9afa	0b 	. 
	push hl			;9afb	e5 	. 
	jr nz,l9a8eh		;9afc	20 90 	  . 
	ret c			;9afe	d8 	. 
	rrca			;9aff	0f 	. 
	push hl			;9b00	e5 	. 
	add a,b			;9b01	80 	. 
l9b02h:
	ld h,d			;9b02	62 	b 
	ld hl,(0e608h)		;9b03	2a 08 e6 	* . . 
	ld bc,l6021h		;9b06	01 21 60 	. ! ` 
	rlca			;9b09	07 	. 
	and 080h		;9b0a	e6 80 	. . 
	ld h,d			;9b0c	62 	b 
	dec l			;9b0d	2d 	- 
	rrca			;9b0e	0f 	. 
	and 0a4h		;9b0f	e6 a4 	. . 
	ld h,d			;9b11	62 	b 
	dec l			;9b12	2d 	- 
	rst 10h			;9b13	d7 	. 
l9b14h:
	rst 20h			;9b14	e7 	. 
	add a,b			;9b15	80 	. 
	ld h,d			;9b16	62 	b 
	add hl,hl			;9b17	29 	) 
	jr z,l9b02h		;9b18	28 e8 	( . 
	nop			;9b1a	00 	. 
	ld c,a			;9b1b	4f 	O 
	ex af,af'			;9b1c	08 	. 
	dec b			;9b1d	05 	. 
	ret pe			;9b1e	e8 	. 
	add a,b			;9b1f	80 	. 
	ld h,d			;9b20	62 	b 
	ld sp,0e948h		;9b21	31 48 e9 	1 H . 
	nop			;9b24	00 	. 
	ld de,00440h		;9b25	11 40 04 	. @ . 
	jp (hl)			;9b28	e9 	. 
	jr nz,$+19		;9b29	20 11 	  . 
	ld c,b			;9b2b	48 	H 
	ex af,af'			;9b2c	08 	. 
	jp (hl)			;9b2d	e9 	. 
	add a,b			;9b2e	80 	. 
	ld h,d			;9b2f	62 	b 
	ld sp,0ea68h		;9b30	31 68 ea 	1 h . 
	ld (bc),a			;9b33	02 	. 
	ld de,08a0dh		;9b34	11 0d 8a 	. . . 
	jp pe,06280h		;9b37	ea 80 62 	. . b 
	ld sp,0eb88h		;9b3a	31 88 eb 	1 . . 
	nop			;9b3d	00 	. 
	ld a,(bc)			;9b3e	0a 	. 
	cp e			;9b3f	bb 	. 
	inc b			;9b40	04 	. 
	ex de,hl			;9b41	eb 	. 
	add a,b			;9b42	80 	. 
	ld h,d			;9b43	62 	b 
	ld sp,0eca8h		;9b44	31 a8 ec 	1 . . 
	ld (bc),a			;9b47	02 	. 
	ld l,a			;9b48	6f 	o 
	dec c			;9b49	0d 	. 
	adc a,c			;9b4a	89 	. 
	call pe,06280h		;9b4b	ec 80 62 	. . b 
	ld sp,0edc8h		;9b4e	31 c8 ed 	1 . . 
	add a,b			;9b51	80 	. 
	ld h,d			;9b52	62 	b 
	ld (0ee08h),a		;9b53	32 08 ee 	2 . . 
	ld bc,0606dh		;9b56	01 6d 60 	. m ` 
	rlca			;9b59	07 	. 
	xor 080h		;9b5a	ee 80 	. . 
	ld h,d			;9b5c	62 	b 
	dec (hl)			;9b5d	35 	5 
	rrca			;9b5e	0f 	. 
	xor 0a4h		;9b5f	ee a4 	. . 
	ld h,d			;9b61	62 	b 
	dec (hl)			;9b62	35 	5 
	rst 10h			;9b63	d7 	. 
	rst 28h			;9b64	ef 	. 
	add a,b			;9b65	80 	. 
	ld h,d			;9b66	62 	b 
	ld sp,0f028h		;9b67	31 28 f0 	1 ( . 
	nop			;9b6a	00 	. 
	ld c,(hl)			;9b6b	4e 	N 
	sub b			;9b6c	90 	. 
	dec b			;9b6d	05 	. 
	ret p			;9b6e	f0 	. 
	add a,b			;9b6f	80 	. 
	ld h,d			;9b70	62 	b 
	add hl,sp			;9b71	39 	9 
	ld c,b			;9b72	48 	H 
	pop af			;9b73	f1 	. 
	nop			;9b74	00 	. 
	ld c,b			;9b75	48 	H 
	xor b			;9b76	a8 	. 
	ld a,(bc)			;9b77	0a 	. 
	pop af			;9b78	f1 	. 
	add a,b			;9b79	80 	. 
	ld h,d			;9b7a	62 	b 
	add hl,sp			;9b7b	39 	9 
	ld l,b			;9b7c	68 	h 
	jp p,01002h		;9b7d	f2 02 10 	. . . 
	sub l			;9b80	95 	. 
	adc a,d			;9b81	8a 	. 
	jp p,06280h		;9b82	f2 80 62 	. . b 
	add hl,sp			;9b85	39 	9 
	adc a,b			;9b86	88 	. 
	di			;9b87	f3 	. 
l9b88h:
	nop			;9b88	00 	. 
	ld b,000h		;9b89	06 00 	. . 
	inc b			;9b8b	04 	. 
	di			;9b8c	f3 	. 
	add a,b			;9b8d	80 	. 
	ld h,d			;9b8e	62 	b 
	add hl,sp			;9b8f	39 	9 
	xor b			;9b90	a8 	. 
	call p,sub_6e02h		;9b91	f4 02 6e 	. . n 
	sub l			;9b94	95 	. 
	adc a,c			;9b95	89 	. 
	call p,06280h		;9b96	f4 80 62 	. . b 
	add hl,sp			;9b99	39 	9 
	ret z			;9b9a	c8 	. 
	push af			;9b9b	f5 	. 
	nop			;9b9c	00 	. 
	sub b			;9b9d	90 	. 
	xor b			;9b9e	a8 	. 
	dec bc			;9b9f	0b 	. 
	push af			;9ba0	f5 	. 
	add a,b			;9ba1	80 	. 
	ld h,d			;9ba2	62 	b 
	ld a,(0f608h)		;9ba3	3a 08 f6 	: . . 
	ld bc,06017h		;9ba6	01 17 60 	. . ` 
	rlca			;9ba9	07 	. 
	or 080h		;9baa	f6 80 	. . 
	ld h,d			;9bac	62 	b 
	dec a			;9bad	3d 	= 
	rrca			;9bae	0f 	. 
	or 0a4h		;9baf	f6 a4 	. . 
	ld h,d			;9bb1	62 	b 
l9bb2h:
	dec a			;9bb2	3d 	= 
	rst 10h			;9bb3	d7 	. 
	rst 30h			;9bb4	f7 	. 
	add a,b			;9bb5	80 	. 
	ld h,d			;9bb6	62 	b 
	add hl,sp			;9bb7	39 	9 
	jr z,l9bb2h		;9bb8	28 f8 	( . 
	nop			;9bba	00 	. 
	ld c,(hl)			;9bbb	4e 	N 
	adc a,b			;9bbc	88 	. 
	dec b			;9bbd	05 	. 
	ret m			;9bbe	f8 	. 
	add a,b			;9bbf	80 	. 
	ld h,d			;9bc0	62 	b 
	ld b,c			;9bc1	41 	A 
	ld c,b			;9bc2	48 	H 
	ld sp,hl			;9bc3	f9 	. 
	nop			;9bc4	00 	. 
	dec d			;9bc5	15 	. 
	dec de			;9bc6	1b 	. 
	ld b,0f9h		;9bc7	06 f9 	. . 
	jr nz,l9be0h		;9bc9	20 15 	  . 
	dec de			;9bcb	1b 	. 
	ld l,d			;9bcc	6a 	j 
	ld sp,hl			;9bcd	f9 	. 
	add a,b			;9bce	80 	. 
	ld h,d			;9bcf	62 	b 
	ld b,c			;9bd0	41 	A 
	ld l,b			;9bd1	68 	h 
	jp m,01002h		;9bd2	fa 02 10 	. . . 
	adc a,l			;9bd5	8d 	. 
	adc a,d			;9bd6	8a 	. 
	jp m,06280h		;9bd7	fa 80 62 	. . b 
	ld b,c			;9bda	41 	A 
	adc a,b			;9bdb	88 	. 
	ei			;9bdc	fb 	. 
	nop			;9bdd	00 	. 
	ex af,af'			;9bde	08 	. 
	nop			;9bdf	00 	. 
l9be0h:
	inc b			;9be0	04 	. 
	ei			;9be1	fb 	. 
	add a,b			;9be2	80 	. 
	ld h,d			;9be3	62 	b 
	ld b,c			;9be4	41 	A 
	xor b			;9be5	a8 	. 
	call m,sub_6e02h		;9be6	fc 02 6e 	. . n 
	adc a,l			;9be9	8d 	. 
	adc a,c			;9bea	89 	. 
	call m,06280h		;9beb	fc 80 62 	. . b 
	ld b,c			;9bee	41 	A 
	ret z			;9bef	c8 	. 
	defb 0fdh,080h,062h	;illegal sequence		;9bf0	fd 80 62 	. . b 
	ld b,d			;9bf3	42 	B 
	ex af,af'			;9bf4	08 	. 
	cp 001h		;9bf5	fe 01 	. . 
	dec b			;9bf7	05 	. 
	ld h,b			;9bf8	60 	` 
	rlca			;9bf9	07 	. 
	cp 080h		;9bfa	fe 80 	. . 
	ld h,d			;9bfc	62 	b 
	ld b,l			;9bfd	45 	E 
	rrca			;9bfe	0f 	. 
	cp 0a4h		;9bff	fe a4 	. . 
	ld h,d			;9c01	62 	b 
	ld b,l			;9c02	45 	E 
	rst 10h			;9c03	d7 	. 
	rst 38h			;9c04	ff 	. 
	add a,b			;9c05	80 	. 
	ld h,d			;9c06	62 	b 
	ld b,c			;9c07	41 	A 
	jr z,$+1		;9c08	28 ff 	( . 
	rst 38h			;9c0a	ff 	. 
	rst 38h			;9c0b	ff 	. 
	rst 38h			;9c0c	ff 	. 
	rst 38h			;9c0d	ff 	. 
	nop			;9c0e	00 	. 
	jr nc,l9c11h		;9c0f	30 00 	0 . 
l9c11h:
	jr nc,l9c13h		;9c11	30 00 	0 . 
l9c13h:
	jr nc,l9c15h		;9c13	30 00 	0 . 
l9c15h:
	jr nc,l9c17h		;9c15	30 00 	0 . 
l9c17h:
	jr nc,l9c19h		;9c17	30 00 	0 . 
l9c19h:
	jr nc,l9c1bh		;9c19	30 00 	0 . 
l9c1bh:
	jr nc,l9c1dh		;9c1b	30 00 	0 . 
l9c1dh:
	jr nc,l9c1fh		;9c1d	30 00 	0 . 
l9c1fh:
	jr nc,l9c21h		;9c1f	30 00 	0 . 
l9c21h:
	jr nc,l9c23h		;9c21	30 00 	0 . 
l9c23h:
	jr nc,l9c25h		;9c23	30 00 	0 . 
l9c25h:
	jr nc,l9c27h		;9c25	30 00 	0 . 
l9c27h:
	jr nc,l9c29h		;9c27	30 00 	0 . 
l9c29h:
	jr nc,l9c2bh		;9c29	30 00 	0 . 
l9c2bh:
	jr nc,l9c2dh		;9c2b	30 00 	0 . 
l9c2dh:
	jr nc,l9c2fh		;9c2d	30 00 	0 . 
l9c2fh:
	jr nc,l9c31h		;9c2f	30 00 	0 . 
l9c31h:
	jr nc,l9c33h		;9c31	30 00 	0 . 
l9c33h:
	jr nc,l9c35h		;9c33	30 00 	0 . 
l9c35h:
	jr nc,l9c37h		;9c35	30 00 	0 . 
l9c37h:
	nop			;9c37	00 	. 
l9c38h:
	nop			;9c38	00 	. 
	nop			;9c39	00 	. 
	nop			;9c3a	00 	. 
	nop			;9c3b	00 	. 
	nop			;9c3c	00 	. 
	nop			;9c3d	00 	. 
l9c3eh:
	nop			;9c3e	00 	. 
	nop			;9c3f	00 	. 
	rst 28h			;9c40	ef 	. 
	ld d,d			;9c41	52 	R 
	add a,b			;9c42	80 	. 
	ld (l8819h),hl		;9c43	22 19 88 	" . . 
	ld d,e			;9c46	53 	S 
	nop			;9c47	00 	. 
	inc d			;9c48	14 	. 
	ld h,c			;9c49	61 	a 
	and h			;9c4a	a4 	. 
	ld d,e			;9c4b	53 	S 
	ld b,d			;9c4c	42 	B 
	dec d			;9c4d	15 	. 
	ld l,d			;9c4e	6a 	j 
	call p,sub_8053h		;9c4f	f4 53 80 	. S . 
	ld (la819h),hl		;9c52	22 19 a8 	" . . 
	ld d,h			;9c55	54 	T 
	nop			;9c56	00 	. 
	inc d			;9c57	14 	. 
	ld h,c			;9c58	61 	a 
	call nz,02054h		;9c59	c4 54 20 	. T   
	inc d			;9c5c	14 	. 
	ld h,e			;9c5d	63 	c 
	jr z,$+86		;9c5e	28 54 	( T 
	add a,b			;9c60	80 	. 
	ld (0c819h),hl		;9c61	22 19 c8 	" . . 
	ld d,l			;9c64	55 	U 
	nop			;9c65	00 	. 
	inc d			;9c66	14 	. 
	ld h,d			;9c67	62 	b 
	inc b			;9c68	04 	. 
	ld d,l			;9c69	55 	U 
	jr nz,l9c80h		;9c6a	20 14 	  . 
	ld h,e			;9c6c	63 	c 
	xor b			;9c6d	a8 	. 
	ld d,l			;9c6e	55 	U 
	add a,b			;9c6f	80 	. 
	ld (0081ah),hl		;9c70	22 1a 08 	" . . 
	ld d,(hl)			;9c73	56 	V 
	nop			;9c74	00 	. 
	inc d			;9c75	14 	. 
	ld h,l			;9c76	65 	e 
	rlca			;9c77	07 	. 
	ld d,(hl)			;9c78	56 	V 
	inc h			;9c79	24 	$ 
	inc d			;9c7a	14 	. 
	ld h,l			;9c7b	65 	e 
	out (056h),a		;9c7c	d3 56 	. V 
	ld b,b			;9c7e	40 	@ 
	inc c			;9c7f	0c 	. 
l9c80h:
	djnz $+10		;9c80	10 08 	. . 
	ld d,(hl)			;9c82	56 	V 
	add a,b			;9c83	80 	. 
	ld (00c1dh),hl		;9c84	22 1d 0c 	" . . 
	ld d,(hl)			;9c87	56 	V 
	and h			;9c88	a4 	. 
	ld (0d41dh),hl		;9c89	22 1d d4 	" . . 
	ld d,a			;9c8c	57 	W 
	nop			;9c8d	00 	. 
	inc d			;9c8e	14 	. 
	ld h,c			;9c8f	61 	a 
	inc h			;9c90	24 	$ 
	ld d,a			;9c91	57 	W 
	ld b,b			;9c92	40 	@ 
	inc d			;9c93	14 	. 
	ld c,c			;9c94	49 	I 
	jp (hl)			;9c95	e9 	. 
	ld d,a			;9c96	57 	W 
	add a,b			;9c97	80 	. 
	ld (02819h),hl		;9c98	22 19 28 	" . ( 
	ld e,b			;9c9b	58 	X 
	nop			;9c9c	00 	. 
	inc d			;9c9d	14 	. 
	ld l,c			;9c9e	69 	i 
	ld b,h			;9c9f	44 	D 
	ld e,b			;9ca0	58 	X 
	ld b,b			;9ca1	40 	@ 
	ld c,06ch		;9ca2	0e 6c 	. l 
	adc a,h			;9ca4	8c 	. 
	ld e,b			;9ca5	58 	X 
	add a,b			;9ca6	80 	. 
	ld (04821h),hl		;9ca7	22 21 48 	" ! H 
	ld e,c			;9caa	59 	Y 
	nop			;9cab	00 	. 
	inc d			;9cac	14 	. 
	ld l,c			;9cad	69 	i 
	ld h,h			;9cae	64 	d 
	ld e,c			;9caf	59 	Y 
	ld b,b			;9cb0	40 	@ 
	ld b,a			;9cb1	47 	G 
	ld hl,059ach		;9cb2	21 ac 59 	! . Y 
	add a,b			;9cb5	80 	. 
	ld (06821h),hl		;9cb6	22 21 68 	" ! h 
	ld e,d			;9cb9	5a 	Z 
	nop			;9cba	00 	. 
	inc d			;9cbb	14 	. 
	ld l,c			;9cbc	69 	i 
	add a,h			;9cbd	84 	. 
	ld e,d			;9cbe	5a 	Z 
	ld b,b			;9cbf	40 	@ 
	inc e			;9cc0	1c 	. 
	jp nz,05aefh		;9cc1	c2 ef 5a 	. . Z 
	add a,b			;9cc4	80 	. 
	ld (08821h),hl		;9cc5	22 21 88 	" ! . 
	ld e,e			;9cc8	5b 	[ 
	nop			;9cc9	00 	. 
	inc d			;9cca	14 	. 
	ld l,c			;9ccb	69 	i 
	and h			;9ccc	a4 	. 
	ld e,e			;9ccd	5b 	[ 
	ld b,d			;9cce	42 	B 
	inc d			;9ccf	14 	. 
	cp l			;9cd0	bd 	. 
	or h			;9cd1	b4 	. 
	ld e,e			;9cd2	5b 	[ 
	add a,b			;9cd3	80 	. 
	ld (la821h),hl		;9cd4	22 21 a8 	" ! . 
	ld e,h			;9cd7	5c 	\ 
	nop			;9cd8	00 	. 
	inc d			;9cd9	14 	. 
	ld l,c			;9cda	69 	i 
	call nz,0205ch		;9cdb	c4 5c 20 	. \   
	inc d			;9cde	14 	. 
	ld l,e			;9cdf	6b 	k 
	jr z,l9d3eh		;9ce0	28 5c 	( \ 
	add a,b			;9ce2	80 	. 
	ld (0c821h),hl		;9ce3	22 21 c8 	" ! . 
	ld e,l			;9ce6	5d 	] 
	nop			;9ce7	00 	. 
	inc d			;9ce8	14 	. 
	ld l,d			;9ce9	6a 	j 
	inc b			;9cea	04 	. 
	ld e,l			;9ceb	5d 	] 
	jr nz,l9d02h		;9cec	20 14 	  . 
	ld l,e			;9cee	6b 	k 
	xor b			;9cef	a8 	. 
	ld e,l			;9cf0	5d 	] 
	add a,b			;9cf1	80 	. 
	ld (00822h),hl		;9cf2	22 22 08 	" " . 
	ld e,(hl)			;9cf5	5e 	^ 
	nop			;9cf6	00 	. 
	inc d			;9cf7	14 	. 
	ld l,l			;9cf8	6d 	m 
	rlca			;9cf9	07 	. 
	ld e,(hl)			;9cfa	5e 	^ 
	inc h			;9cfb	24 	$ 
	inc d			;9cfc	14 	. 
	ld l,l			;9cfd	6d 	m 
	out (05eh),a		;9cfe	d3 5e 	. ^ 
	ld b,b			;9d00	40 	@ 
	inc c			;9d01	0c 	. 
l9d02h:
	jr $+10		;9d02	18 08 	. . 
	ld e,(hl)			;9d04	5e 	^ 
	add a,b			;9d05	80 	. 
	ld (00c25h),hl		;9d06	22 25 0c 	" % . 
	ld e,(hl)			;9d09	5e 	^ 
	and h			;9d0a	a4 	. 
	ld (0d425h),hl		;9d0b	22 25 d4 	" % . 
	ld e,a			;9d0e	5f 	_ 
	nop			;9d0f	00 	. 
	inc d			;9d10	14 	. 
	ld l,c			;9d11	69 	i 
	inc h			;9d12	24 	$ 
	ld e,a			;9d13	5f 	_ 
	ld b,b			;9d14	40 	@ 
	inc d			;9d15	14 	. 
	ld c,d			;9d16	4a 	J 
	ld l,c			;9d17	69 	i 
	ld e,a			;9d18	5f 	_ 
	add a,b			;9d19	80 	. 
	ld (02821h),hl		;9d1a	22 21 28 	" ! ( 
	ld h,b			;9d1d	60 	` 
	nop			;9d1e	00 	. 
	inc d			;9d1f	14 	. 
	ld (hl),c			;9d20	71 	q 
	ld b,h			;9d21	44 	D 
	ld h,b			;9d22	60 	` 
	jr nz,l9d39h		;9d23	20 14 	  . 
	ret			;9d25	c9 	. 
	ld c,b			;9d26	48 	H 
	ld h,b			;9d27	60 	` 
	ld b,b			;9d28	40 	@ 
	ld c,074h		;9d29	0e 74 	. t 
	adc a,h			;9d2b	8c 	. 
	ld h,b			;9d2c	60 	` 
	add a,b			;9d2d	80 	. 
	ld (04829h),hl		;9d2e	22 29 48 	" ) H 
	ld h,c			;9d31	61 	a 
	nop			;9d32	00 	. 
	inc d			;9d33	14 	. 
	ld (hl),c			;9d34	71 	q 
	ld h,h			;9d35	64 	d 
	ld h,c			;9d36	61 	a 
	jr nz,l9d4dh		;9d37	20 14 	  . 
l9d39h:
	ret			;9d39	c9 	. 
	ld l,b			;9d3a	68 	h 
	ld h,c			;9d3b	61 	a 
	ld b,b			;9d3c	40 	@ 
	ld b,a			;9d3d	47 	G 
l9d3eh:
	ld hl,061cch		;9d3e	21 cc 61 	! . a 
	add a,b			;9d41	80 	. 
	ld (l6829h),hl		;9d42	22 29 68 	" ) h 
	ld h,d			;9d45	62 	b 
	nop			;9d46	00 	. 
	inc d			;9d47	14 	. 
	ld (hl),c			;9d48	71 	q 
	add a,h			;9d49	84 	. 
	ld h,d			;9d4a	62 	b 
	jr nz,l9d61h		;9d4b	20 14 	  . 
l9d4dh:
	ret			;9d4d	c9 	. 
	adc a,b			;9d4e	88 	. 
	ld h,d			;9d4f	62 	b 
	ld b,b			;9d50	40 	@ 
	ld e,(hl)			;9d51	5e 	^ 
	jp l620fh		;9d52	c3 0f 62 	. . b 
	add a,b			;9d55	80 	. 
	ld (l8829h),hl		;9d56	22 29 88 	" ) . 
	ld h,e			;9d59	63 	c 
	nop			;9d5a	00 	. 
	inc d			;9d5b	14 	. 
	ld (hl),c			;9d5c	71 	q 
	and h			;9d5d	a4 	. 
	ld h,e			;9d5e	63 	c 
	jr nz,l9d75h		;9d5f	20 14 	  . 
l9d61h:
	ret			;9d61	c9 	. 
	xor b			;9d62	a8 	. 
	ld h,e			;9d63	63 	c 
	ld b,d			;9d64	42 	B 
	dec d			;9d65	15 	. 
	ld l,e			;9d66	6b 	k 
	inc d			;9d67	14 	. 
	ld h,e			;9d68	63 	c 
	add a,b			;9d69	80 	. 
	ld (la829h),hl		;9d6a	22 29 a8 	" ) . 
	ld h,h			;9d6d	64 	d 
	nop			;9d6e	00 	. 
	inc d			;9d6f	14 	. 
	ld (hl),c			;9d70	71 	q 
	call nz,02064h		;9d71	c4 64 20 	. d   
	inc d			;9d74	14 	. 
l9d75h:
	sra b		;9d75	cb 28 	. ( 
	ld h,h			;9d77	64 	d 
	add a,b			;9d78	80 	. 
	ld (0c829h),hl		;9d79	22 29 c8 	" ) . 
	ld h,l			;9d7c	65 	e 
	nop			;9d7d	00 	. 
	inc d			;9d7e	14 	. 
	ld (hl),d			;9d7f	72 	r 
	inc b			;9d80	04 	. 
	ld h,l			;9d81	65 	e 
	jr nz,$+22		;9d82	20 14 	  . 
	res 5,b		;9d84	cb a8 	. . 
	ld h,l			;9d86	65 	e 
	add a,b			;9d87	80 	. 
	ld (0082ah),hl		;9d88	22 2a 08 	" * . 
	ld h,(hl)			;9d8b	66 	f 
	nop			;9d8c	00 	. 
	inc d			;9d8d	14 	. 
	ld (hl),l			;9d8e	75 	u 
	rlca			;9d8f	07 	. 
	ld h,(hl)			;9d90	66 	f 
	inc h			;9d91	24 	$ 
	inc d			;9d92	14 	. 
	ld (hl),l			;9d93	75 	u 
	out (066h),a		;9d94	d3 66 	. f 
	add a,b			;9d96	80 	. 
	ld (00c2dh),hl		;9d97	22 2d 0c 	" - . 
	ld h,(hl)			;9d9a	66 	f 
	and h			;9d9b	a4 	. 
	ld (0d42dh),hl		;9d9c	22 2d d4 	" - . 
	ld h,a			;9d9f	67 	g 
	nop			;9da0	00 	. 
	inc d			;9da1	14 	. 
	ld (hl),c			;9da2	71 	q 
	inc h			;9da3	24 	$ 
	ld h,a			;9da4	67 	g 
	jr nz,l9dbbh		;9da5	20 14 	  . 
	ret			;9da7	c9 	. 
	jr z,$+105		;9da8	28 67 	( g 
	ld b,b			;9daa	40 	@ 
	ld e,d			;9dab	5a 	Z 
	nop			;9dac	00 	. 
	ld (de),a			;9dad	12 	. 
	ld h,a			;9dae	67 	g 
	add a,b			;9daf	80 	. 
	ld (02829h),hl		;9db0	22 29 28 	" ) ( 
	ld l,b			;9db3	68 	h 
	nop			;9db4	00 	. 
	inc d			;9db5	14 	. 
	add a,c			;9db6	81 	. 
	ld b,h			;9db7	44 	D 
	ld l,b			;9db8	68 	h 
	jr nz,l9dcfh		;9db9	20 14 	  . 
l9dbbh:
	jp (hl)			;9dbb	e9 	. 
	ld c,b			;9dbc	48 	H 
	ld l,b			;9dbd	68 	h 
	ld b,b			;9dbe	40 	@ 
	ld c,084h		;9dbf	0e 84 	. . 
	adc a,h			;9dc1	8c 	. 
	ld l,b			;9dc2	68 	h 
	add a,b			;9dc3	80 	. 
	ld (04831h),hl		;9dc4	22 31 48 	" 1 H 
	ld l,c			;9dc7	69 	i 
l9dc8h:
	nop			;9dc8	00 	. 
	inc d			;9dc9	14 	. 
	add a,c			;9dca	81 	. 
	ld h,h			;9dcb	64 	d 
	ld l,c			;9dcc	69 	i 
	jr nz,l9de3h		;9dcd	20 14 	  . 
l9dcfh:
	jp (hl)			;9dcf	e9 	. 
	ld l,b			;9dd0	68 	h 
	ld l,c			;9dd1	69 	i 
	ld b,b			;9dd2	40 	@ 
	ld b,a			;9dd3	47 	G 
	ld (l690ch),hl		;9dd4	22 0c 69 	" . i 
	add a,b			;9dd7	80 	. 
	ld (06831h),hl		;9dd8	22 31 68 	" 1 h 
	ld l,d			;9ddb	6a 	j 
	nop			;9ddc	00 	. 
	inc d			;9ddd	14 	. 
	add a,c			;9dde	81 	. 
	add a,h			;9ddf	84 	. 
	ld l,d			;9de0	6a 	j 
	jr nz,l9df7h		;9de1	20 14 	  . 
l9de3h:
	jp (hl)			;9de3	e9 	. 
	adc a,b			;9de4	88 	. 
	ld l,d			;9de5	6a 	j 
	ld b,b			;9de6	40 	@ 
	inc e			;9de7	1c 	. 
	jp sub_6a0fh		;9de8	c3 0f 6a 	. . j 
	add a,b			;9deb	80 	. 
	ld (l8831h),hl		;9dec	22 31 88 	" 1 . 
	ld l,e			;9def	6b 	k 
	nop			;9df0	00 	. 
	inc d			;9df1	14 	. 
	add a,c			;9df2	81 	. 
	and h			;9df3	a4 	. 
	ld l,e			;9df4	6b 	k 
	jr nz,l9e0bh		;9df5	20 14 	  . 
l9df7h:
	jp (hl)			;9df7	e9 	. 
	xor b			;9df8	a8 	. 
	ld l,e			;9df9	6b 	k 
	ld b,d			;9dfa	42 	B 
	inc d			;9dfb	14 	. 
	push bc			;9dfc	c5 	. 
	or h			;9dfd	b4 	. 
	ld l,e			;9dfe	6b 	k 
	add a,b			;9dff	80 	. 
l9e00h:
	ld (la831h),hl		;9e00	22 31 a8 	" 1 . 
	ld l,h			;9e03	6c 	l 
	nop			;9e04	00 	. 
	inc d			;9e05	14 	. 
	add a,c			;9e06	81 	. 
	call nz,0206ch		;9e07	c4 6c 20 	. l   
	inc d			;9e0a	14 	. 
l9e0bh:
	ex de,hl			;9e0b	eb 	. 
	jr z,$+110		;9e0c	28 6c 	( l 
	add a,b			;9e0e	80 	. 
	ld (0c831h),hl		;9e0f	22 31 c8 	" 1 . 
	ld l,l			;9e12	6d 	m 
	nop			;9e13	00 	. 
	inc d			;9e14	14 	. 
	add a,d			;9e15	82 	. 
	inc b			;9e16	04 	. 
	ld l,l			;9e17	6d 	m 
	jr nz,$+22		;9e18	20 14 	  . 
	ex de,hl			;9e1a	eb 	. 
	xor b			;9e1b	a8 	. 
	ld l,l			;9e1c	6d 	m 
	add a,b			;9e1d	80 	. 
	ld (00832h),hl		;9e1e	22 32 08 	" 2 . 
	ld l,(hl)			;9e21	6e 	n 
	nop			;9e22	00 	. 
	inc d			;9e23	14 	. 
	add a,l			;9e24	85 	. 
	rlca			;9e25	07 	. 
	ld l,(hl)			;9e26	6e 	n 
	inc h			;9e27	24 	$ 
	inc d			;9e28	14 	. 
	add a,l			;9e29	85 	. 
	out (06eh),a		;9e2a	d3 6e 	. n 
	add a,b			;9e2c	80 	. 
	ld (00c35h),hl		;9e2d	22 35 0c 	" 5 . 
	ld l,(hl)			;9e30	6e 	n 
	and h			;9e31	a4 	. 
	ld (0d435h),hl		;9e32	22 35 d4 	" 5 . 
	ld l,a			;9e35	6f 	o 
	nop			;9e36	00 	. 
	inc d			;9e37	14 	. 
	add a,c			;9e38	81 	. 
	inc h			;9e39	24 	$ 
	ld l,a			;9e3a	6f 	o 
	jr nz,l9e51h		;9e3b	20 14 	  . 
	jp (hl)			;9e3d	e9 	. 
	jr z,l9eafh		;9e3e	28 6f 	( o 
	ld b,b			;9e40	40 	@ 
	ld d,h			;9e41	54 	T 
	nop			;9e42	00 	. 
	ld (de),a			;9e43	12 	. 
	ld l,a			;9e44	6f 	o 
	add a,b			;9e45	80 	. 
	ld (02831h),hl		;9e46	22 31 28 	" 1 ( 
	ld (hl),b			;9e49	70 	p 
	nop			;9e4a	00 	. 
	dec d			;9e4b	15 	. 
	ld b,c			;9e4c	41 	A 
	ld b,a			;9e4d	47 	G 
	ld (hl),b			;9e4e	70 	p 
	inc h			;9e4f	24 	$ 
	dec d			;9e50	15 	. 
l9e51h:
	ld (hl),c			;9e51	71 	q 
	ld d,e			;9e52	53 	S 
	ld (hl),b			;9e53	70 	p 
	add a,b			;9e54	80 	. 
	ld (04839h),hl		;9e55	22 39 48 	" 9 H 
	ld (hl),c			;9e58	71 	q 
	nop			;9e59	00 	. 
	dec d			;9e5a	15 	. 
	ld b,c			;9e5b	41 	A 
	ld h,a			;9e5c	67 	g 
	ld (hl),c			;9e5d	71 	q 
	inc h			;9e5e	24 	$ 
	dec d			;9e5f	15 	. 
	ld (hl),c			;9e60	71 	q 
	ld (hl),e			;9e61	73 	s 
	ld (hl),c			;9e62	71 	q 
	add a,b			;9e63	80 	. 
	ld (l6839h),hl		;9e64	22 39 68 	" 9 h 
	ld (hl),d			;9e67	72 	r 
	nop			;9e68	00 	. 
	dec d			;9e69	15 	. 
	ld b,c			;9e6a	41 	A 
	add a,a			;9e6b	87 	. 
	ld (hl),d			;9e6c	72 	r 
	inc h			;9e6d	24 	$ 
	dec d			;9e6e	15 	. 
	ld (hl),c			;9e6f	71 	q 
	sub e			;9e70	93 	. 
	ld (hl),d			;9e71	72 	r 
	ld b,b			;9e72	40 	@ 
	ld e,(hl)			;9e73	5e 	^ 
	call nz,sub_726fh		;9e74	c4 6f 72 	. o r 
	add a,b			;9e77	80 	. 
	ld (08839h),hl		;9e78	22 39 88 	" 9 . 
	ld (hl),e			;9e7b	73 	s 
	nop			;9e7c	00 	. 
	dec d			;9e7d	15 	. 
	ld b,c			;9e7e	41 	A 
	and a			;9e7f	a7 	. 
	ld (hl),e			;9e80	73 	s 
	inc h			;9e81	24 	$ 
	dec d			;9e82	15 	. 
	ld (hl),c			;9e83	71 	q 
	or e			;9e84	b3 	. 
	ld (hl),e			;9e85	73 	s 
	ld b,d			;9e86	42 	B 
	dec d			;9e87	15 	. 
	ld l,h			;9e88	6c 	l 
	ld (hl),h			;9e89	74 	t 
	ld (hl),e			;9e8a	73 	s 
	add a,b			;9e8b	80 	. 
	ld (la839h),hl		;9e8c	22 39 a8 	" 9 . 
	ld (hl),h			;9e8f	74 	t 
	nop			;9e90	00 	. 
	dec d			;9e91	15 	. 
	ld b,c			;9e92	41 	A 
	rst 0			;9e93	c7 	. 
	ld (hl),h			;9e94	74 	t 
	inc h			;9e95	24 	$ 
	dec d			;9e96	15 	. 
	ld (hl),c			;9e97	71 	q 
	out (074h),a		;9e98	d3 74 	. t 
	add a,b			;9e9a	80 	. 
	ld (0c839h),hl		;9e9b	22 39 c8 	" 9 . 
	ld (hl),l			;9e9e	75 	u 
	nop			;9e9f	00 	. 
	dec d			;9ea0	15 	. 
	ld b,d			;9ea1	42 	B 
	rlca			;9ea2	07 	. 
	ld (hl),l			;9ea3	75 	u 
	inc h			;9ea4	24 	$ 
	dec d			;9ea5	15 	. 
	ld (hl),d			;9ea6	72 	r 
	inc de			;9ea7	13 	. 
	ld (hl),l			;9ea8	75 	u 
	add a,b			;9ea9	80 	. 
	ld (0083ah),hl		;9eaa	22 3a 08 	" : . 
	halt			;9ead	76 	v 
	nop			;9eae	00 	. 
l9eafh:
	ld a,(hl)			;9eaf	7e 	~ 
	nop			;9eb0	00 	. 
	inc b			;9eb1	04 	. 
	halt			;9eb2	76 	v 
	add a,b			;9eb3	80 	. 
	ld (00c3dh),hl		;9eb4	22 3d 0c 	" = . 
	halt			;9eb7	76 	v 
	and h			;9eb8	a4 	. 
	ld (0d43dh),hl		;9eb9	22 3d d4 	" = . 
	ld (hl),a			;9ebc	77 	w 
	nop			;9ebd	00 	. 
	dec d			;9ebe	15 	. 
	ld b,c			;9ebf	41 	A 
	daa			;9ec0	27 	' 
	ld (hl),a			;9ec1	77 	w 
	inc h			;9ec2	24 	$ 
	dec d			;9ec3	15 	. 
	ld (hl),c			;9ec4	71 	q 
	inc sp			;9ec5	33 	3 
	ld (hl),a			;9ec6	77 	w 
	add a,b			;9ec7	80 	. 
	ld (02839h),hl		;9ec8	22 39 28 	" 9 ( 
	ld a,b			;9ecb	78 	x 
	nop			;9ecc	00 	. 
	inc d			;9ecd	14 	. 
	ld c,c			;9ece	49 	I 
	ld b,h			;9ecf	44 	D 
	ld a,b			;9ed0	78 	x 
	ld b,b			;9ed1	40 	@ 
	ld c,04ch		;9ed2	0e 4c 	. L 
	adc a,h			;9ed4	8c 	. 
	ld a,b			;9ed5	78 	x 
	add a,b			;9ed6	80 	. 
	ld (04841h),hl		;9ed7	22 41 48 	" A H 
	ld a,c			;9eda	79 	y 
	nop			;9edb	00 	. 
	inc d			;9edc	14 	. 
	ld c,c			;9edd	49 	I 
	ld h,h			;9ede	64 	d 
	ld a,c			;9edf	79 	y 
	ld b,b			;9ee0	40 	@ 
	ld b,a			;9ee1	47 	G 
	ld hl,l792ch		;9ee2	21 2c 79 	! , y 
	add a,b			;9ee5	80 	. 
	ld (06841h),hl		;9ee6	22 41 68 	" A h 
	ld a,d			;9ee9	7a 	z 
	nop			;9eea	00 	. 
	inc d			;9eeb	14 	. 
	ld c,c			;9eec	49 	I 
	add a,h			;9eed	84 	. 
	ld a,d			;9eee	7a 	z 
	ld b,b			;9eef	40 	@ 
	inc e			;9ef0	1c 	. 
	call nz,07a6fh		;9ef1	c4 6f 7a 	. o z 
	add a,b			;9ef4	80 	. 
	ld (08841h),hl		;9ef5	22 41 88 	" A . 
	ld a,e			;9ef8	7b 	{ 
	nop			;9ef9	00 	. 
l9efah:
	inc d			;9efa	14 	. 
	ld c,c			;9efb	49 	I 
	and h			;9efc	a4 	. 
	ld a,e			;9efd	7b 	{ 
	ld b,d			;9efe	42 	B 
	dec d			;9eff	15 	. 
	dec e			;9f00	1d 	. 
	or h			;9f01	b4 	. 
	ld a,e			;9f02	7b 	{ 
	add a,b			;9f03	80 	. 
	ld (la841h),hl		;9f04	22 41 a8 	" A . 
	ld a,h			;9f07	7c 	| 
	nop			;9f08	00 	. 
	inc d			;9f09	14 	. 
	ld c,c			;9f0a	49 	I 
	call nz,0207ch		;9f0b	c4 7c 20 	. |   
	inc d			;9f0e	14 	. 
	ld c,e			;9f0f	4b 	K 
	jr z,l9f8eh		;9f10	28 7c 	( | 
	add a,b			;9f12	80 	. 
	ld (0c841h),hl		;9f13	22 41 c8 	" A . 
	ld a,l			;9f16	7d 	} 
	nop			;9f17	00 	. 
	inc d			;9f18	14 	. 
	ld c,d			;9f19	4a 	J 
	inc b			;9f1a	04 	. 
	ld a,l			;9f1b	7d 	} 
	jr nz,$+22		;9f1c	20 14 	  . 
	ld c,e			;9f1e	4b 	K 
	xor b			;9f1f	a8 	. 
	ld a,l			;9f20	7d 	} 
	add a,b			;9f21	80 	. 
	ld (00842h),hl		;9f22	22 42 08 	" B . 
	ld a,(hl)			;9f25	7e 	~ 
	nop			;9f26	00 	. 
	inc d			;9f27	14 	. 
	ld c,l			;9f28	4d 	M 
	rlca			;9f29	07 	. 
	ld a,(hl)			;9f2a	7e 	~ 
	inc h			;9f2b	24 	$ 
	inc d			;9f2c	14 	. 
	ld c,l			;9f2d	4d 	M 
	out (07eh),a		;9f2e	d3 7e 	. ~ 
l9f30h:
	add a,b			;9f30	80 	. 
	ld (00c45h),hl		;9f31	22 45 0c 	" E . 
	ld a,(hl)			;9f34	7e 	~ 
	and h			;9f35	a4 	. 
	ld (0d445h),hl		;9f36	22 45 d4 	" E . 
	ld a,a			;9f39	7f 	 
	nop			;9f3a	00 	. 
	inc d			;9f3b	14 	. 
	ld c,c			;9f3c	49 	I 
	inc h			;9f3d	24 	$ 
	ld a,a			;9f3e	7f 	 
	add a,b			;9f3f	80 	. 
	ld (02841h),hl		;9f40	22 41 28 	" A ( 
	add a,b			;9f43	80 	. 
	nop			;9f44	00 	. 
	ld e,049h		;9f45	1e 49 	. I 
	ld b,h			;9f47	44 	D 
	add a,b			;9f48	80 	. 
	add a,b			;9f49	80 	. 
	ld c,h			;9f4a	4c 	L 
	add hl,bc			;9f4b	09 	. 
	ld c,b			;9f4c	48 	H 
	add a,c			;9f4d	81 	. 
	nop			;9f4e	00 	. 
	ld e,049h		;9f4f	1e 49 	. I 
	ld h,h			;9f51	64 	d 
	add a,c			;9f52	81 	. 
	add a,b			;9f53	80 	. 
	ld c,h			;9f54	4c 	L 
	add hl,bc			;9f55	09 	. 
	ld l,b			;9f56	68 	h 
	add a,d			;9f57	82 	. 
	nop			;9f58	00 	. 
	ld e,049h		;9f59	1e 49 	. I 
	add a,h			;9f5b	84 	. 
	add a,d			;9f5c	82 	. 
	add a,b			;9f5d	80 	. 
	ld c,h			;9f5e	4c 	L 
	add hl,bc			;9f5f	09 	. 
	adc a,b			;9f60	88 	. 
	add a,e			;9f61	83 	. 
	nop			;9f62	00 	. 
	ld e,049h		;9f63	1e 49 	. I 
	and h			;9f65	a4 	. 
l9f66h:
	add a,e			;9f66	83 	. 
	add a,b			;9f67	80 	. 
	ld c,h			;9f68	4c 	L 
	add hl,bc			;9f69	09 	. 
	xor b			;9f6a	a8 	. 
	add a,h			;9f6b	84 	. 
	nop			;9f6c	00 	. 
	ld e,049h		;9f6d	1e 49 	. I 
	call nz,02084h		;9f6f	c4 84 20 	. .   
	ld e,04bh		;9f72	1e 4b 	. K 
	jr z,l9efah		;9f74	28 84 	( . 
	add a,b			;9f76	80 	. 
	ld c,h			;9f77	4c 	L 
	add hl,bc			;9f78	09 	. 
	ret z			;9f79	c8 	. 
	add a,l			;9f7a	85 	. 
	nop			;9f7b	00 	. 
	ld e,04ah		;9f7c	1e 4a 	. J 
	inc b			;9f7e	04 	. 
	add a,l			;9f7f	85 	. 
	jr nz,$+32		;9f80	20 1e 	  . 
	ld c,e			;9f82	4b 	K 
	xor b			;9f83	a8 	. 
	add a,l			;9f84	85 	. 
	add a,b			;9f85	80 	. 
	ld c,h			;9f86	4c 	L 
	ld a,(bc)			;9f87	0a 	. 
	ex af,af'			;9f88	08 	. 
	add a,(hl)			;9f89	86 	. 
	nop			;9f8a	00 	. 
	ld e,04dh		;9f8b	1e 4d 	. M 
	rlca			;9f8d	07 	. 
l9f8eh:
	add a,(hl)			;9f8e	86 	. 
	inc h			;9f8f	24 	$ 
	ld e,04dh		;9f90	1e 4d 	. M 
	out (086h),a		;9f92	d3 86 	. . 
	add a,b			;9f94	80 	. 
	ld c,h			;9f95	4c 	L 
	dec c			;9f96	0d 	. 
	rrca			;9f97	0f 	. 
	add a,(hl)			;9f98	86 	. 
	and h			;9f99	a4 	. 
	ld c,h			;9f9a	4c 	L 
	dec c			;9f9b	0d 	. 
	rst 10h			;9f9c	d7 	. 
	add a,a			;9f9d	87 	. 
	nop			;9f9e	00 	. 
	ld e,049h		;9f9f	1e 49 	. I 
	inc h			;9fa1	24 	$ 
	add a,a			;9fa2	87 	. 
	add a,b			;9fa3	80 	. 
	ld c,h			;9fa4	4c 	L 
	add hl,bc			;9fa5	09 	. 
	jr z,l9f30h		;9fa6	28 88 	( . 
	nop			;9fa8	00 	. 
	inc e			;9fa9	1c 	. 
	ld c,c			;9faa	49 	I 
	ld b,h			;9fab	44 	D 
	adc a,b			;9fac	88 	. 
	add a,b			;9fad	80 	. 
	ld c,h			;9fae	4c 	L 
	ld de,08948h		;9faf	11 48 89 	. H . 
	nop			;9fb2	00 	. 
	inc e			;9fb3	1c 	. 
	ld c,c			;9fb4	49 	I 
	ld h,h			;9fb5	64 	d 
	adc a,c			;9fb6	89 	. 
	add a,b			;9fb7	80 	. 
	ld c,h			;9fb8	4c 	L 
	ld de,l8a68h		;9fb9	11 68 8a 	. h . 
	nop			;9fbc	00 	. 
	inc e			;9fbd	1c 	. 
	ld c,c			;9fbe	49 	I 
	add a,h			;9fbf	84 	. 
	adc a,d			;9fc0	8a 	. 
	add a,b			;9fc1	80 	. 
	ld c,h			;9fc2	4c 	L 
	ld de,08b88h		;9fc3	11 88 8b 	. . . 
	nop			;9fc6	00 	. 
	inc e			;9fc7	1c 	. 
	ld c,c			;9fc8	49 	I 
	and h			;9fc9	a4 	. 
	adc a,e			;9fca	8b 	. 
	add a,b			;9fcb	80 	. 
	ld c,h			;9fcc	4c 	L 
	ld de,l8ca8h		;9fcd	11 a8 8c 	. . . 
	nop			;9fd0	00 	. 
	inc e			;9fd1	1c 	. 
	ld c,c			;9fd2	49 	I 
	call nz,0208ch		;9fd3	c4 8c 20 	. .   
	inc e			;9fd6	1c 	. 
	ld c,e			;9fd7	4b 	K 
	jr z,l9f66h		;9fd8	28 8c 	( . 
	add a,b			;9fda	80 	. 
	ld c,h			;9fdb	4c 	L 
	ld de,l8dc8h		;9fdc	11 c8 8d 	. . . 
	nop			;9fdf	00 	. 
	inc e			;9fe0	1c 	. 
	ld c,d			;9fe1	4a 	J 
	inc b			;9fe2	04 	. 
	adc a,l			;9fe3	8d 	. 
	jr nz,la002h		;9fe4	20 1c 	  . 
	ld c,e			;9fe6	4b 	K 
	xor b			;9fe7	a8 	. 
	adc a,l			;9fe8	8d 	. 
	add a,b			;9fe9	80 	. 
	ld c,h			;9fea	4c 	L 
	ld (de),a			;9feb	12 	. 
	ex af,af'			;9fec	08 	. 
	adc a,(hl)			;9fed	8e 	. 
	nop			;9fee	00 	. 
	inc e			;9fef	1c 	. 
	ld c,l			;9ff0	4d 	M 
	rlca			;9ff1	07 	. 
	adc a,(hl)			;9ff2	8e 	. 
	inc h			;9ff3	24 	$ 
	inc e			;9ff4	1c 	. 
	ld c,l			;9ff5	4d 	M 
	out (08eh),a		;9ff6	d3 8e 	. . 
	add a,b			;9ff8	80 	. 
	ld c,h			;9ff9	4c 	L 
	dec d			;9ffa	15 	. 
	rrca			;9ffb	0f 	. 
	adc a,(hl)			;9ffc	8e 	. 
	and h			;9ffd	a4 	. 
	ld c,h			;9ffe	4c 	L 
	dec d			;9fff	15 	. 
	rst 10h			;a000	d7 	. 
	adc a,a			;a001	8f 	. 
la002h:
	nop			;a002	00 	. 
	inc e			;a003	1c 	. 
	ld c,c			;a004	49 	I 
	inc h			;a005	24 	$ 
	adc a,a			;a006	8f 	. 
	add a,b			;a007	80 	. 
la008h:
	ld c,h			;a008	4c 	L 
	ld de,l9028h		;a009	11 28 90 	. ( . 
	nop			;a00c	00 	. 
	ld l,d			;a00d	6a 	j 
	ld d,b			;a00e	50 	P 
	inc b			;a00f	04 	. 
	sub b			;a010	90 	. 
	add a,b			;a011	80 	. 
	ld c,h			;a012	4c 	L 
	add hl,de			;a013	19 	. 
	ld c,b			;a014	48 	H 
	sub c			;a015	91 	. 
	nop			;a016	00 	. 
	ld l,d			;a017	6a 	j 
	ld e,b			;a018	58 	X 
	inc b			;a019	04 	. 
	sub c			;a01a	91 	. 
	add a,b			;a01b	80 	. 
	ld c,h			;a01c	4c 	L 
	add hl,de			;a01d	19 	. 
	ld l,b			;a01e	68 	h 
	sub d			;a01f	92 	. 
	nop			;a020	00 	. 
	ld l,d			;a021	6a 	j 
	ld h,b			;a022	60 	` 
	inc b			;a023	04 	. 
	sub d			;a024	92 	. 
	add a,b			;a025	80 	. 
	ld c,h			;a026	4c 	L 
	add hl,de			;a027	19 	. 
la028h:
	adc a,b			;a028	88 	. 
	sub e			;a029	93 	. 
	nop			;a02a	00 	. 
	ld l,d			;a02b	6a 	j 
	ld l,b			;a02c	68 	h 
	inc b			;a02d	04 	. 
	sub e			;a02e	93 	. 
	add a,b			;a02f	80 	. 
	ld c,h			;a030	4c 	L 
	add hl,de			;a031	19 	. 
	xor b			;a032	a8 	. 
	sub h			;a033	94 	. 
	nop			;a034	00 	. 
	ld l,d			;a035	6a 	j 
	ld (hl),b			;a036	70 	p 
	inc b			;a037	04 	. 
	sub h			;a038	94 	. 
	jr nz,$+108		;a039	20 6a 	  j 
	ret z			;a03b	c8 	. 
	ex af,af'			;a03c	08 	. 
	sub h			;a03d	94 	. 
la03eh:
	add a,b			;a03e	80 	. 
	ld c,h			;a03f	4c 	L 
	add hl,de			;a040	19 	. 
	ret z			;a041	c8 	. 
	sub l			;a042	95 	. 
	nop			;a043	00 	. 
	ld l,d			;a044	6a 	j 
	add a,b			;a045	80 	. 
	inc b			;a046	04 	. 
	sub l			;a047	95 	. 
	jr nz,$+108		;a048	20 6a 	  j 
	ret pe			;a04a	e8 	. 
	ex af,af'			;a04b	08 	. 
	sub l			;a04c	95 	. 
	add a,b			;a04d	80 	. 
	ld c,h			;a04e	4c 	L 
	ld a,(de)			;a04f	1a 	. 
	ex af,af'			;a050	08 	. 
	sub (hl)			;a051	96 	. 
	nop			;a052	00 	. 
	ld l,e			;a053	6b 	k 
	ld b,b			;a054	40 	@ 
	rlca			;a055	07 	. 
	sub (hl)			;a056	96 	. 
	inc h			;a057	24 	$ 
	ld l,e			;a058	6b 	k 
	ld (hl),b			;a059	70 	p 
	inc de			;a05a	13 	. 
	sub (hl)			;a05b	96 	. 
	add a,b			;a05c	80 	. 
	ld c,h			;a05d	4c 	L 
	dec e			;a05e	1d 	. 
	rrca			;a05f	0f 	. 
	sub (hl)			;a060	96 	. 
	and h			;a061	a4 	. 
	ld c,h			;a062	4c 	L 
	dec e			;a063	1d 	. 
	rst 10h			;a064	d7 	. 
	sub a			;a065	97 	. 
	nop			;a066	00 	. 
	ld l,d			;a067	6a 	j 
	ld c,b			;a068	48 	H 
	inc b			;a069	04 	. 
	sub a			;a06a	97 	. 
	add a,b			;a06b	80 	. 
	ld c,h			;a06c	4c 	L 
	add hl,de			;a06d	19 	. 
	jr z,la008h		;a06e	28 98 	( . 
	nop			;a070	00 	. 
	ld e,(hl)			;a071	5e 	^ 
	ld c,c			;a072	49 	I 
	ld b,h			;a073	44 	D 
	sbc a,b			;a074	98 	. 
	add a,b			;a075	80 	. 
	ld c,h			;a076	4c 	L 
	ld hl,l9948h		;a077	21 48 99 	! H . 
	nop			;a07a	00 	. 
	ld e,(hl)			;a07b	5e 	^ 
	ld c,c			;a07c	49 	I 
	ld h,h			;a07d	64 	d 
la07eh:
	sbc a,c			;a07e	99 	. 
	add a,b			;a07f	80 	. 
	ld c,h			;a080	4c 	L 
	ld hl,l9a68h		;a081	21 68 9a 	! h . 
	nop			;a084	00 	. 
	ld e,(hl)			;a085	5e 	^ 
	ld c,c			;a086	49 	I 
	add a,h			;a087	84 	. 
	sbc a,d			;a088	9a 	. 
	add a,b			;a089	80 	. 
	ld c,h			;a08a	4c 	L 
	ld hl,l9b88h		;a08b	21 88 9b 	! . . 
la08eh:
	nop			;a08e	00 	. 
	ld e,(hl)			;a08f	5e 	^ 
	ld c,c			;a090	49 	I 
	and h			;a091	a4 	. 
	sbc a,e			;a092	9b 	. 
	add a,b			;a093	80 	. 
	ld c,h			;a094	4c 	L 
	ld hl,09ca8h		;a095	21 a8 9c 	! . . 
	nop			;a098	00 	. 
	ld e,(hl)			;a099	5e 	^ 
	ld c,c			;a09a	49 	I 
	call nz,0209ch		;a09b	c4 9c 20 	. .   
	ld e,(hl)			;a09e	5e 	^ 
	ld c,e			;a09f	4b 	K 
	jr z,la03eh		;a0a0	28 9c 	( . 
la0a2h:
	add a,b			;a0a2	80 	. 
	ld c,h			;a0a3	4c 	L 
	ld hl,l9dc8h		;a0a4	21 c8 9d 	! . . 
	nop			;a0a7	00 	. 
	ld e,(hl)			;a0a8	5e 	^ 
	ld c,d			;a0a9	4a 	J 
	inc b			;a0aa	04 	. 
	sbc a,l			;a0ab	9d 	. 
	jr nz,la10ch		;a0ac	20 5e 	  ^ 
la0aeh:
	ld c,e			;a0ae	4b 	K 
	xor b			;a0af	a8 	. 
	sbc a,l			;a0b0	9d 	. 
	add a,b			;a0b1	80 	. 
	ld c,h			;a0b2	4c 	L 
	ld (09e08h),hl		;a0b3	22 08 9e 	" . . 
	nop			;a0b6	00 	. 
	ld e,(hl)			;a0b7	5e 	^ 
	ld c,l			;a0b8	4d 	M 
	rlca			;a0b9	07 	. 
	sbc a,(hl)			;a0ba	9e 	. 
	inc h			;a0bb	24 	$ 
	ld e,(hl)			;a0bc	5e 	^ 
	ld c,l			;a0bd	4d 	M 
	out (09eh),a		;a0be	d3 9e 	. . 
	add a,b			;a0c0	80 	. 
	ld c,h			;a0c1	4c 	L 
	dec h			;a0c2	25 	% 
	rrca			;a0c3	0f 	. 
	sbc a,(hl)			;a0c4	9e 	. 
	and h			;a0c5	a4 	. 
	ld c,h			;a0c6	4c 	L 
	dec h			;a0c7	25 	% 
	rst 10h			;a0c8	d7 	. 
	sbc a,a			;a0c9	9f 	. 
	nop			;a0ca	00 	. 
	ld e,(hl)			;a0cb	5e 	^ 
	ld c,c			;a0cc	49 	I 
	inc h			;a0cd	24 	$ 
	sbc a,a			;a0ce	9f 	. 
	add a,b			;a0cf	80 	. 
	ld c,h			;a0d0	4c 	L 
	ld hl,la028h		;a0d1	21 28 a0 	! ( . 
	nop			;a0d4	00 	. 
	jr nz,la127h		;a0d5	20 50 	  P 
	inc b			;a0d7	04 	. 
	and b			;a0d8	a0 	. 
	ld b,b			;a0d9	40 	@ 
	ld a,000h		;a0da	3e 00 	> . 
	djnz la07eh		;a0dc	10 a0 	. . 
	add a,b			;a0de	80 	. 
	ld c,h			;a0df	4c 	L 
	add hl,hl			;a0e0	29 	) 
	ld c,b			;a0e1	48 	H 
	and c			;a0e2	a1 	. 
	nop			;a0e3	00 	. 
	jr nz,la13eh		;a0e4	20 58 	  X 
	inc b			;a0e6	04 	. 
	and c			;a0e7	a1 	. 
	ld b,b			;a0e8	40 	@ 
	jr z,la0ebh		;a0e9	28 00 	( . 
la0ebh:
	djnz la08eh		;a0eb	10 a1 	. . 
	add a,b			;a0ed	80 	. 
	ld c,h			;a0ee	4c 	L 
	add hl,hl			;a0ef	29 	) 
	ld l,b			;a0f0	68 	h 
	and d			;a0f1	a2 	. 
	nop			;a0f2	00 	. 
	jr nz,$+98		;a0f3	20 60 	  ` 
	inc b			;a0f5	04 	. 
	and d			;a0f6	a2 	. 
	ld b,b			;a0f7	40 	@ 
	ld a,(01000h)		;a0f8	3a 00 10 	: . . 
	and d			;a0fb	a2 	. 
	add a,b			;a0fc	80 	. 
	ld c,h			;a0fd	4c 	L 
la0feh:
	add hl,hl			;a0fe	29 	) 
	adc a,b			;a0ff	88 	. 
	and e			;a100	a3 	. 
	nop			;a101	00 	. 
	jr nz,la16ch		;a102	20 68 	  h 
	inc b			;a104	04 	. 
	and e			;a105	a3 	. 
	ld b,b			;a106	40 	@ 
	adc a,(hl)			;a107	8e 	. 
	nop			;a108	00 	. 
	djnz la0aeh		;a109	10 a3 	. . 
	add a,b			;a10b	80 	. 
la10ch:
	ld c,h			;a10c	4c 	L 
	add hl,hl			;a10d	29 	) 
la10eh:
	xor b			;a10e	a8 	. 
	and h			;a10f	a4 	. 
	nop			;a110	00 	. 
	jr nz,la183h		;a111	20 70 	  p 
	inc b			;a113	04 	. 
	and h			;a114	a4 	. 
	jr nz,la137h		;a115	20 20 	    
	ret z			;a117	c8 	. 
	ex af,af'			;a118	08 	. 
	and h			;a119	a4 	. 
	add a,b			;a11a	80 	. 
	ld c,h			;a11b	4c 	L 
	add hl,hl			;a11c	29 	) 
	ret z			;a11d	c8 	. 
la11eh:
	and l			;a11e	a5 	. 
	nop			;a11f	00 	. 
	jr nz,la0a2h		;a120	20 80 	  . 
	inc b			;a122	04 	. 
	and l			;a123	a5 	. 
	jr nz,la146h		;a124	20 20 	    
	ret pe			;a126	e8 	. 
la127h:
	ex af,af'			;a127	08 	. 
	and l			;a128	a5 	. 
	add a,b			;a129	80 	. 
	ld c,h			;a12a	4c 	L 
	ld hl,(la608h)		;a12b	2a 08 a6 	* . . 
la12eh:
	nop			;a12e	00 	. 
	ld hl,00740h		;a12f	21 40 07 	! @ . 
	and (hl)			;a132	a6 	. 
	inc h			;a133	24 	$ 
	ld hl,01370h		;a134	21 70 13 	! p . 
la137h:
	and (hl)			;a137	a6 	. 
	add a,b			;a138	80 	. 
	ld c,h			;a139	4c 	L 
	dec l			;a13a	2d 	- 
	rrca			;a13b	0f 	. 
	and (hl)			;a13c	a6 	. 
	and h			;a13d	a4 	. 
la13eh:
	ld c,h			;a13e	4c 	L 
	dec l			;a13f	2d 	- 
	rst 10h			;a140	d7 	. 
	and a			;a141	a7 	. 
	nop			;a142	00 	. 
	jr nz,la18dh		;a143	20 48 	  H 
	inc b			;a145	04 	. 
la146h:
	and a			;a146	a7 	. 
	add a,b			;a147	80 	. 
	ld c,h			;a148	4c 	L 
	add hl,hl			;a149	29 	) 
	jr z,$-86		;a14a	28 a8 	( . 
	nop			;a14c	00 	. 
	ld l,h			;a14d	6c 	l 
	ld d,b			;a14e	50 	P 
	inc b			;a14f	04 	. 
	xor b			;a150	a8 	. 
	ld b,b			;a151	40 	@ 
	inc a			;a152	3c 	< 
	nop			;a153	00 	. 
	djnz la0feh		;a154	10 a8 	. . 
	add a,b			;a156	80 	. 
	ld c,h			;a157	4c 	L 
	ld sp,la948h		;a158	31 48 a9 	1 H . 
	nop			;a15b	00 	. 
	ld l,h			;a15c	6c 	l 
	ld e,b			;a15d	58 	X 
	inc b			;a15e	04 	. 
	xor c			;a15f	a9 	. 
	ld b,b			;a160	40 	@ 
	ld h,000h		;a161	26 00 	& . 
	djnz la10eh		;a163	10 a9 	. . 
	add a,b			;a165	80 	. 
	ld c,h			;a166	4c 	L 
	ld sp,laa68h		;a167	31 68 aa 	1 h . 
	nop			;a16a	00 	. 
	ld l,h			;a16b	6c 	l 
la16ch:
	ld h,b			;a16c	60 	` 
	inc b			;a16d	04 	. 
	xor d			;a16e	aa 	. 
	ld b,b			;a16f	40 	@ 
	jr c,la172h		;a170	38 00 	8 . 
la172h:
	djnz la11eh		;a172	10 aa 	. . 
	add a,b			;a174	80 	. 
	ld c,h			;a175	4c 	L 
	ld sp,lab88h		;a176	31 88 ab 	1 . . 
	nop			;a179	00 	. 
	ld l,h			;a17a	6c 	l 
	ld l,b			;a17b	68 	h 
	inc b			;a17c	04 	. 
	xor e			;a17d	ab 	. 
	ld b,b			;a17e	40 	@ 
	adc a,h			;a17f	8c 	. 
	nop			;a180	00 	. 
	djnz la12eh		;a181	10 ab 	. . 
la183h:
	add a,b			;a183	80 	. 
	ld c,h			;a184	4c 	L 
	ld sp,0aca8h		;a185	31 a8 ac 	1 . . 
	nop			;a188	00 	. 
	ld l,h			;a189	6c 	l 
	ld (hl),b			;a18a	70 	p 
	inc b			;a18b	04 	. 
	xor h			;a18c	ac 	. 
la18dh:
	jr nz,la1fbh		;a18d	20 6c 	  l 
	ret z			;a18f	c8 	. 
	ex af,af'			;a190	08 	. 
	xor h			;a191	ac 	. 
	add a,b			;a192	80 	. 
	ld c,h			;a193	4c 	L 
	ld sp,0adc8h		;a194	31 c8 ad 	1 . . 
	nop			;a197	00 	. 
	ld l,h			;a198	6c 	l 
	add a,b			;a199	80 	. 
	inc b			;a19a	04 	. 
	xor l			;a19b	ad 	. 
	jr nz,la20ah		;a19c	20 6c 	  l 
	ret pe			;a19e	e8 	. 
	ex af,af'			;a19f	08 	. 
	xor l			;a1a0	ad 	. 
	add a,b			;a1a1	80 	. 
	ld c,h			;a1a2	4c 	L 
	ld (0ae08h),a		;a1a3	32 08 ae 	2 . . 
	nop			;a1a6	00 	. 
	ld l,l			;a1a7	6d 	m 
	ld b,b			;a1a8	40 	@ 
	rlca			;a1a9	07 	. 
	xor (hl)			;a1aa	ae 	. 
	inc h			;a1ab	24 	$ 
	ld l,l			;a1ac	6d 	m 
	ld (hl),b			;a1ad	70 	p 
	inc de			;a1ae	13 	. 
	xor (hl)			;a1af	ae 	. 
	add a,b			;a1b0	80 	. 
	ld c,h			;a1b1	4c 	L 
	dec (hl)			;a1b2	35 	5 
	rrca			;a1b3	0f 	. 
	xor (hl)			;a1b4	ae 	. 
	and h			;a1b5	a4 	. 
	ld c,h			;a1b6	4c 	L 
	dec (hl)			;a1b7	35 	5 
	rst 10h			;a1b8	d7 	. 
	xor a			;a1b9	af 	. 
	nop			;a1ba	00 	. 
	ld l,h			;a1bb	6c 	l 
	ld c,b			;a1bc	48 	H 
	inc b			;a1bd	04 	. 
	xor a			;a1be	af 	. 
	add a,b			;a1bf	80 	. 
	ld c,h			;a1c0	4c 	L 
	ld sp,0b028h		;a1c1	31 28 b0 	1 ( . 
	nop			;a1c4	00 	. 
	ld d,050h		;a1c5	16 50 	. P 
	inc b			;a1c7	04 	. 
	or b			;a1c8	b0 	. 
	ld b,b			;a1c9	40 	@ 
	add a,(hl)			;a1ca	86 	. 
	nop			;a1cb	00 	. 
	dec d			;a1cc	15 	. 
	or b			;a1cd	b0 	. 
	add a,b			;a1ce	80 	. 
	ld c,h			;a1cf	4c 	L 
	add hl,sp			;a1d0	39 	9 
	ld c,b			;a1d1	48 	H 
	or c			;a1d2	b1 	. 
	nop			;a1d3	00 	. 
	ld d,058h		;a1d4	16 58 	. X 
	inc b			;a1d6	04 	. 
	or c			;a1d7	b1 	. 
	ld b,b			;a1d8	40 	@ 
	ld (hl),d			;a1d9	72 	r 
	nop			;a1da	00 	. 
	dec d			;a1db	15 	. 
	or c			;a1dc	b1 	. 
	add a,b			;a1dd	80 	. 
	ld c,h			;a1de	4c 	L 
	add hl,sp			;a1df	39 	9 
	ld l,b			;a1e0	68 	h 
	or d			;a1e1	b2 	. 
	nop			;a1e2	00 	. 
	ld d,060h		;a1e3	16 60 	. ` 
	inc b			;a1e5	04 	. 
	or d			;a1e6	b2 	. 
	ld b,b			;a1e7	40 	@ 
	add a,d			;a1e8	82 	. 
	nop			;a1e9	00 	. 
	dec d			;a1ea	15 	. 
	or d			;a1eb	b2 	. 
	add a,b			;a1ec	80 	. 
	ld c,h			;a1ed	4c 	L 
	add hl,sp			;a1ee	39 	9 
	adc a,b			;a1ef	88 	. 
	or e			;a1f0	b3 	. 
	nop			;a1f1	00 	. 
	ld d,068h		;a1f2	16 68 	. h 
la1f4h:
	inc b			;a1f4	04 	. 
	or e			;a1f5	b3 	. 
	ld b,b			;a1f6	40 	@ 
	adc a,d			;a1f7	8a 	. 
	nop			;a1f8	00 	. 
	dec d			;a1f9	15 	. 
	or e			;a1fa	b3 	. 
la1fbh:
	add a,b			;a1fb	80 	. 
	ld c,h			;a1fc	4c 	L 
	add hl,sp			;a1fd	39 	9 
	xor b			;a1fe	a8 	. 
	or h			;a1ff	b4 	. 
	nop			;a200	00 	. 
	ld d,070h		;a201	16 70 	. p 
	inc b			;a203	04 	. 
	or h			;a204	b4 	. 
	jr nz,$+24		;a205	20 16 	  . 
	ret z			;a207	c8 	. 
	ex af,af'			;a208	08 	. 
	or h			;a209	b4 	. 
la20ah:
	add a,b			;a20a	80 	. 
	ld c,h			;a20b	4c 	L 
	add hl,sp			;a20c	39 	9 
	ret z			;a20d	c8 	. 
	or l			;a20e	b5 	. 
	nop			;a20f	00 	. 
	ld d,080h		;a210	16 80 	. . 
	inc b			;a212	04 	. 
	or l			;a213	b5 	. 
	jr nz,la22ch		;a214	20 16 	  . 
	ret pe			;a216	e8 	. 
	ex af,af'			;a217	08 	. 
	or l			;a218	b5 	. 
	add a,b			;a219	80 	. 
	ld c,h			;a21a	4c 	L 
	ld a,(0b608h)		;a21b	3a 08 b6 	: . . 
	nop			;a21e	00 	. 
	rla			;a21f	17 	. 
	ld b,b			;a220	40 	@ 
	rlca			;a221	07 	. 
	or (hl)			;a222	b6 	. 
	inc h			;a223	24 	$ 
	rla			;a224	17 	. 
	ld (hl),b			;a225	70 	p 
	inc de			;a226	13 	. 
	or (hl)			;a227	b6 	. 
	add a,b			;a228	80 	. 
	ld c,h			;a229	4c 	L 
	dec a			;a22a	3d 	= 
	rrca			;a22b	0f 	. 
la22ch:
	or (hl)			;a22c	b6 	. 
	and h			;a22d	a4 	. 
	ld c,h			;a22e	4c 	L 
	dec a			;a22f	3d 	= 
	rst 10h			;a230	d7 	. 
	or a			;a231	b7 	. 
	nop			;a232	00 	. 
	ld d,048h		;a233	16 48 	. H 
	inc b			;a235	04 	. 
	or a			;a236	b7 	. 
	add a,b			;a237	80 	. 
	ld c,h			;a238	4c 	L 
	add hl,sp			;a239	39 	9 
	jr z,la1f4h		;a23a	28 b8 	( . 
	nop			;a23c	00 	. 
	inc b			;a23d	04 	. 
	ld d,b			;a23e	50 	P 
	inc b			;a23f	04 	. 
	cp b			;a240	b8 	. 
	ld b,b			;a241	40 	@ 
	add a,h			;a242	84 	. 
	nop			;a243	00 	. 
	dec d			;a244	15 	. 
	cp b			;a245	b8 	. 
	add a,b			;a246	80 	. 
	ld c,h			;a247	4c 	L 
	ld b,c			;a248	41 	A 
	ld c,b			;a249	48 	H 
	cp c			;a24a	b9 	. 
	nop			;a24b	00 	. 
	inc b			;a24c	04 	. 
	ld e,b			;a24d	58 	X 
	inc b			;a24e	04 	. 
	cp c			;a24f	b9 	. 
	ld b,b			;a250	40 	@ 
	ld (hl),b			;a251	70 	p 
	nop			;a252	00 	. 
	dec d			;a253	15 	. 
	cp c			;a254	b9 	. 
	add a,b			;a255	80 	. 
	ld c,h			;a256	4c 	L 
	ld b,c			;a257	41 	A 
	ld l,b			;a258	68 	h 
	cp d			;a259	ba 	. 
	nop			;a25a	00 	. 
	inc b			;a25b	04 	. 
	ld h,b			;a25c	60 	` 
	inc b			;a25d	04 	. 
	cp d			;a25e	ba 	. 
	ld b,b			;a25f	40 	@ 
	add a,b			;a260	80 	. 
	nop			;a261	00 	. 
	dec d			;a262	15 	. 
	cp d			;a263	ba 	. 
	add a,b			;a264	80 	. 
	ld c,h			;a265	4c 	L 
	ld b,c			;a266	41 	A 
	adc a,b			;a267	88 	. 
	cp e			;a268	bb 	. 
	nop			;a269	00 	. 
	inc b			;a26a	04 	. 
	ld l,b			;a26b	68 	h 
	inc b			;a26c	04 	. 
	cp e			;a26d	bb 	. 
	ld b,b			;a26e	40 	@ 
	adc a,b			;a26f	88 	. 
	nop			;a270	00 	. 
	dec d			;a271	15 	. 
	cp e			;a272	bb 	. 
	add a,b			;a273	80 	. 
la274h:
	ld c,h			;a274	4c 	L 
	ld b,c			;a275	41 	A 
	xor b			;a276	a8 	. 
	cp h			;a277	bc 	. 
	nop			;a278	00 	. 
	inc b			;a279	04 	. 
	ld (hl),b			;a27a	70 	p 
	inc b			;a27b	04 	. 
	cp h			;a27c	bc 	. 
	jr nz,la283h		;a27d	20 04 	  . 
	ret z			;a27f	c8 	. 
	ex af,af'			;a280	08 	. 
	cp h			;a281	bc 	. 
	add a,b			;a282	80 	. 
la283h:
	ld c,h			;a283	4c 	L 
	ld b,c			;a284	41 	A 
	ret z			;a285	c8 	. 
	cp l			;a286	bd 	. 
	nop			;a287	00 	. 
	inc b			;a288	04 	. 
	add a,b			;a289	80 	. 
	inc b			;a28a	04 	. 
	cp l			;a28b	bd 	. 
	jr nz,la292h		;a28c	20 04 	  . 
	ret pe			;a28e	e8 	. 
	ex af,af'			;a28f	08 	. 
	cp l			;a290	bd 	. 
	add a,b			;a291	80 	. 
la292h:
	ld c,h			;a292	4c 	L 
	ld b,d			;a293	42 	B 
	ex af,af'			;a294	08 	. 
	cp (hl)			;a295	be 	. 
	nop			;a296	00 	. 
	dec b			;a297	05 	. 
	ld b,b			;a298	40 	@ 
	rlca			;a299	07 	. 
	cp (hl)			;a29a	be 	. 
	inc h			;a29b	24 	$ 
	dec b			;a29c	05 	. 
	ld (hl),b			;a29d	70 	p 
	inc de			;a29e	13 	. 
	cp (hl)			;a29f	be 	. 
	add a,b			;a2a0	80 	. 
	ld c,h			;a2a1	4c 	L 
	ld b,l			;a2a2	45 	E 
	rrca			;a2a3	0f 	. 
	cp (hl)			;a2a4	be 	. 
	and h			;a2a5	a4 	. 
	ld c,h			;a2a6	4c 	L 
	ld b,l			;a2a7	45 	E 
	rst 10h			;a2a8	d7 	. 
	cp a			;a2a9	bf 	. 
	nop			;a2aa	00 	. 
	inc b			;a2ab	04 	. 
	ld c,b			;a2ac	48 	H 
	inc b			;a2ad	04 	. 
	cp a			;a2ae	bf 	. 
	add a,b			;a2af	80 	. 
	ld c,h			;a2b0	4c 	L 
	ld b,c			;a2b1	41 	A 
	jr z,la274h		;a2b2	28 c0 	( . 
	nop			;a2b4	00 	. 
	ld c,a			;a2b5	4f 	O 
	nop			;a2b6	00 	. 
	dec b			;a2b7	05 	. 
	ret nz			;a2b8	c0 	. 
	add a,b			;a2b9	80 	. 
	ld h,d			;a2ba	62 	b 
	add hl,bc			;a2bb	09 	. 
	ld c,b			;a2bc	48 	H 
	pop bc			;a2bd	c1 	. 
	nop			;a2be	00 	. 
	ld c,b			;a2bf	48 	H 
	or b			;a2c0	b0 	. 
	ld a,(bc)			;a2c1	0a 	. 
	pop bc			;a2c2	c1 	. 
	add a,b			;a2c3	80 	. 
	ld h,d			;a2c4	62 	b 
la2c5h:
	add hl,bc			;a2c5	09 	. 
	ld l,b			;a2c6	68 	h 
	jp nz,01102h		;a2c7	c2 02 11 	. . . 
	dec b			;a2ca	05 	. 
	adc a,d			;a2cb	8a 	. 
	jp nz,06280h		;a2cc	c2 80 62 	. . b 
	add hl,bc			;a2cf	09 	. 
	adc a,b			;a2d0	88 	. 
la2d1h:
	jp 01102h		;a2d1	c3 02 11 	. . . 
	ld h,b			;a2d4	60 	` 
	ld a,(bc)			;a2d5	0a 	. 
	jp 06280h		;a2d6	c3 80 62 	. . b 
	add hl,bc			;a2d9	09 	. 
	xor b			;a2da	a8 	. 
	call nz,l6f01h+1		;a2db	c4 02 6f 	. . o 
	dec b			;a2de	05 	. 
	adc a,c			;a2df	89 	. 
	call nz,06280h		;a2e0	c4 80 62 	. . b 
	add hl,bc			;a2e3	09 	. 
	ret z			;a2e4	c8 	. 
	push bc			;a2e5	c5 	. 
	nop			;a2e6	00 	. 
	sub b			;a2e7	90 	. 
	or b			;a2e8	b0 	. 
	dec bc			;a2e9	0b 	. 
	push bc			;a2ea	c5 	. 
	add a,b			;a2eb	80 	. 
	ld h,d			;a2ec	62 	b 
	ld a,(bc)			;a2ed	0a 	. 
	ex af,af'			;a2ee	08 	. 
	add a,001h		;a2ef	c6 01 	. . 
	ld e,04dh		;a2f1	1e 4d 	. M 
	add a,a			;a2f3	87 	. 
	add a,080h		;a2f4	c6 80 	. . 
	ld h,d			;a2f6	62 	b 
	dec c			;a2f7	0d 	. 
	rrca			;a2f8	0f 	. 
	add a,0a4h		;a2f9	c6 a4 	. . 
	ld h,d			;a2fb	62 	b 
	dec c			;a2fc	0d 	. 
	rst 10h			;a2fd	d7 	. 
	rst 0			;a2fe	c7 	. 
	ld b,05dh		;a2ff	06 5d 	. ] 
	ld h,b			;a301	60 	` 
	dec bc			;a302	0b 	. 
	rst 0			;a303	c7 	. 
	add a,b			;a304	80 	. 
	ld h,d			;a305	62 	b 
	add hl,bc			;a306	09 	. 
	jr z,la2d1h		;a307	28 c8 	( . 
	nop			;a309	00 	. 
	ld c,(hl)			;a30a	4e 	N 
	and b			;a30b	a0 	. 
	dec b			;a30c	05 	. 
	ret z			;a30d	c8 	. 
	add a,b			;a30e	80 	. 
	ld h,d			;a30f	62 	b 
	ld de,0c948h		;a310	11 48 c9 	. H . 
	nop			;a313	00 	. 
	ld c,(hl)			;a314	4e 	N 
	nop			;a315	00 	. 
	dec b			;a316	05 	. 
	ret			;a317	c9 	. 
	add a,b			;a318	80 	. 
	ld h,d			;a319	62 	b 
	ld de,0ca68h		;a31a	11 68 ca 	. h . 
	ld (bc),a			;a31d	02 	. 
	djnz la2c5h		;a31e	10 a5 	. . 
	adc a,d			;a320	8a 	. 
	jp z,06280h		;a321	ca 80 62 	. . b 
	ld de,0cb88h		;a324	11 88 cb 	. . . 
	add a,b			;a327	80 	. 
	ld h,d			;a328	62 	b 
	ld de,0cca8h		;a329	11 a8 cc 	. . . 
	ld (bc),a			;a32c	02 	. 
	ld l,(hl)			;a32d	6e 	n 
	and l			;a32e	a5 	. 
	adc a,c			;a32f	89 	. 
	call z,06280h		;a330	cc 80 62 	. . b 
	ld de,0cdc8h		;a333	11 c8 cd 	. . . 
	ld (bc),a			;a336	02 	. 
	ld l,a			;a337	6f 	o 
	ld h,b			;a338	60 	` 
	add hl,bc			;a339	09 	. 
	call 06280h		;a33a	cd 80 62 	. . b 
	ld (de),a			;a33d	12 	. 
	ex af,af'			;a33e	08 	. 
	adc a,001h		;a33f	ce 01 	. . 
	inc e			;a341	1c 	. 
	ld c,l			;a342	4d 	M 
	add a,a			;a343	87 	. 
	adc a,080h		;a344	ce 80 	. . 
	ld h,d			;a346	62 	b 
	dec d			;a347	15 	. 
	rrca			;a348	0f 	. 
	adc a,0a4h		;a349	ce a4 	. . 
	ld h,d			;a34b	62 	b 
	dec d			;a34c	15 	. 
	rst 10h			;a34d	d7 	. 
	rst 8			;a34e	cf 	. 
	add a,b			;a34f	80 	. 
	ld h,d			;a350	62 	b 
	ld de,0d028h		;a351	11 28 d0 	. ( . 
	nop			;a354	00 	. 
	ld c,(hl)			;a355	4e 	N 
	ret m			;a356	f8 	. 
	dec b			;a357	05 	. 
	ret nc			;a358	d0 	. 
	add a,b			;a359	80 	. 
	ld h,d			;a35a	62 	b 
	add hl,de			;a35b	19 	. 
	ld c,b			;a35c	48 	H 
	pop de			;a35d	d1 	. 
	nop			;a35e	00 	. 
	ld c,b			;a35f	48 	H 
	cp b			;a360	b8 	. 
	ld a,(bc)			;a361	0a 	. 
	pop de			;a362	d1 	. 
	add a,b			;a363	80 	. 
	ld h,d			;a364	62 	b 
	add hl,de			;a365	19 	. 
	ld l,b			;a366	68 	h 
	jp nc,01002h		;a367	d2 02 10 	. . . 
	defb 0fdh,08ah,0d2h	;illegal sequence		;a36a	fd 8a d2 	. . . 
	add a,b			;a36d	80 	. 
	ld h,d			;a36e	62 	b 
	add hl,de			;a36f	19 	. 
	adc a,b			;a370	88 	. 
	out (001h),a		;a371	d3 01 	. . 
	ld b,a			;a373	47 	G 
	ld l,c			;a374	69 	i 
	dec hl			;a375	2b 	+ 
	out (080h),a		;a376	d3 80 	. . 
	ld h,d			;a378	62 	b 
	add hl,de			;a379	19 	. 
	xor b			;a37a	a8 	. 
	call nc,sub_6e02h		;a37b	d4 02 6e 	. . n 
	defb 0fdh,089h,0d4h	;illegal sequence		;a37e	fd 89 d4 	. . . 
	add a,b			;a381	80 	. 
	ld h,d			;a382	62 	b 
	add hl,de			;a383	19 	. 
	ret z			;a384	c8 	. 
	push de			;a385	d5 	. 
	nop			;a386	00 	. 
	sub b			;a387	90 	. 
	cp b			;a388	b8 	. 
	dec bc			;a389	0b 	. 
	push de			;a38a	d5 	. 
	add a,b			;a38b	80 	. 
	ld h,d			;a38c	62 	b 
	ld a,(de)			;a38d	1a 	. 
	ex af,af'			;a38e	08 	. 
	sub 001h		;a38f	d6 01 	. . 
	ld l,e			;a391	6b 	k 
	ld h,b			;a392	60 	` 
	rlca			;a393	07 	. 
	sub 080h		;a394	d6 80 	. . 
	ld h,d			;a396	62 	b 
	dec e			;a397	1d 	. 
	rrca			;a398	0f 	. 
	sub 0a4h		;a399	d6 a4 	. . 
	ld h,d			;a39b	62 	b 
	dec e			;a39c	1d 	. 
	rst 10h			;a39d	d7 	. 
	rst 10h			;a39e	d7 	. 
	add a,b			;a39f	80 	. 
	ld h,d			;a3a0	62 	b 
	add hl,de			;a3a1	19 	. 
	jr z,$-38		;a3a2	28 d8 	( . 
	nop			;a3a4	00 	. 
	ld c,(hl)			;a3a5	4e 	N 
	ld e,b			;a3a6	58 	X 
	dec b			;a3a7	05 	. 
	ret c			;a3a8	d8 	. 
	add a,b			;a3a9	80 	. 
	ld h,d			;a3aa	62 	b 
	ld hl,0d948h		;a3ab	21 48 d9 	! H . 
	nop			;a3ae	00 	. 
	inc (hl)			;a3af	34 	4 
	nop			;a3b0	00 	. 
	inc b			;a3b1	04 	. 
	exx			;a3b2	d9 	. 
	add a,b			;a3b3	80 	. 
	ld h,d			;a3b4	62 	b 
	ld hl,0da68h		;a3b5	21 68 da 	! h . 
	ld (bc),a			;a3b8	02 	. 
	djnz $+95		;a3b9	10 5d 	. ] 
	adc a,d			;a3bb	8a 	. 
	jp c,06280h		;a3bc	da 80 62 	. . b 
	ld hl,0db88h		;a3bf	21 88 db 	! . . 
la3c2h:
	ld bc,04d0eh		;a3c2	01 0e 4d 	. . M 
	xor e			;a3c5	ab 	. 
	in a,(080h)		;a3c6	db 80 	. . 
	ld h,d			;a3c8	62 	b 
	ld hl,0dca8h		;a3c9	21 a8 dc 	! . . 
	ld (bc),a			;a3cc	02 	. 
	ld l,(hl)			;a3cd	6e 	n 
	ld e,l			;a3ce	5d 	] 
	adc a,c			;a3cf	89 	. 
	call c,06280h		;a3d0	dc 80 62 	. . b 
	ld hl,0ddc8h		;a3d3	21 c8 dd 	! . . 
	add a,b			;a3d6	80 	. 
	ld h,d			;a3d7	62 	b 
	ld (0de08h),hl		;a3d8	22 08 de 	" . . 
	ld bc,04d5eh		;a3db	01 5e 4d 	. ^ M 
	add a,a			;a3de	87 	. 
	sbc a,080h		;a3df	de 80 	. . 
	ld h,d			;a3e1	62 	b 
	dec h			;a3e2	25 	% 
	rrca			;a3e3	0f 	. 
	sbc a,0a4h		;a3e4	de a4 	. . 
	ld h,d			;a3e6	62 	b 
	dec h			;a3e7	25 	% 
	rst 10h			;a3e8	d7 	. 
	rst 18h			;a3e9	df 	. 
	add a,b			;a3ea	80 	. 
	ld h,d			;a3eb	62 	b 
	ld hl,0e028h		;a3ec	21 28 e0 	! ( . 
	nop			;a3ef	00 	. 
	ld c,a			;a3f0	4f 	O 
	djnz la3f8h		;a3f1	10 05 	. . 
	ret po			;a3f3	e0 	. 
	add a,b			;a3f4	80 	. 
	ld h,d			;a3f5	62 	b 
	add hl,hl			;a3f6	29 	) 
	ld c,b			;a3f7	48 	H 
la3f8h:
	pop hl			;a3f8	e1 	. 
	nop			;a3f9	00 	. 
	ld c,b			;a3fa	48 	H 
	ret nz			;a3fb	c0 	. 
	ld a,(bc)			;a3fc	0a 	. 
	pop hl			;a3fd	e1 	. 
	jr nz,la448h		;a3fe	20 48 	  H 
	ret c			;a400	d8 	. 
	ld c,0e1h		;a401	0e e1 	. . 
	add a,b			;a403	80 	. 
	ld h,d			;a404	62 	b 
	add hl,hl			;a405	29 	) 
	ld l,b			;a406	68 	h 
	jp po,01102h		;a407	e2 02 11 	. . . 
	dec d			;a40a	15 	. 
	adc a,d			;a40b	8a 	. 
	jp po,06280h		;a40c	e2 80 62 	. . b 
	add hl,hl			;a40f	29 	) 
	adc a,b			;a410	88 	. 
	ex (sp),hl			;a411	e3 	. 
	nop			;a412	00 	. 
	dec bc			;a413	0b 	. 
	ld e,e			;a414	5b 	[ 
	inc de			;a415	13 	. 
	ex (sp),hl			;a416	e3 	. 
	jr nz,la424h		;a417	20 0b 	  . 
	ld e,e			;a419	5b 	[ 
	ld (hl),a			;a41a	77 	w 
	ex (sp),hl			;a41b	e3 	. 
	add a,b			;a41c	80 	. 
	ld h,d			;a41d	62 	b 
	add hl,hl			;a41e	29 	) 
	xor b			;a41f	a8 	. 
	call po,l6f01h+1		;a420	e4 02 6f 	. . o 
	dec d			;a423	15 	. 
la424h:
	adc a,c			;a424	89 	. 
	call po,06280h		;a425	e4 80 62 	. . b 
	add hl,hl			;a428	29 	) 
	ret z			;a429	c8 	. 
	push hl			;a42a	e5 	. 
	nop			;a42b	00 	. 
	sub b			;a42c	90 	. 
	ret nz			;a42d	c0 	. 
	dec bc			;a42e	0b 	. 
	push hl			;a42f	e5 	. 
	jr nz,la3c2h		;a430	20 90 	  . 
	ret c			;a432	d8 	. 
	rrca			;a433	0f 	. 
	push hl			;a434	e5 	. 
	add a,b			;a435	80 	. 
la436h:
	ld h,d			;a436	62 	b 
	ld hl,(0e608h)		;a437	2a 08 e6 	* . . 
	ld bc,l6021h		;a43a	01 21 60 	. ! ` 
	rlca			;a43d	07 	. 
	and 080h		;a43e	e6 80 	. . 
	ld h,d			;a440	62 	b 
	dec l			;a441	2d 	- 
	rrca			;a442	0f 	. 
	and 0a4h		;a443	e6 a4 	. . 
	ld h,d			;a445	62 	b 
	dec l			;a446	2d 	- 
	rst 10h			;a447	d7 	. 
la448h:
	rst 20h			;a448	e7 	. 
	add a,b			;a449	80 	. 
	ld h,d			;a44a	62 	b 
	add hl,hl			;a44b	29 	) 
	jr z,la436h		;a44c	28 e8 	( . 
	nop			;a44e	00 	. 
	ld c,a			;a44f	4f 	O 
	ex af,af'			;a450	08 	. 
	dec b			;a451	05 	. 
	ret pe			;a452	e8 	. 
	add a,b			;a453	80 	. 
	ld h,d			;a454	62 	b 
	ld sp,0e948h		;a455	31 48 e9 	1 H . 
	nop			;a458	00 	. 
	ld de,00440h		;a459	11 40 04 	. @ . 
	jp (hl)			;a45c	e9 	. 
	jr nz,$+19		;a45d	20 11 	  . 
	ld c,b			;a45f	48 	H 
	ex af,af'			;a460	08 	. 
	jp (hl)			;a461	e9 	. 
	add a,b			;a462	80 	. 
	ld h,d			;a463	62 	b 
	ld sp,0ea68h		;a464	31 68 ea 	1 h . 
	ld (bc),a			;a467	02 	. 
	ld de,08a0dh		;a468	11 0d 8a 	. . . 
	jp pe,06280h		;a46b	ea 80 62 	. . b 
	ld sp,0eb88h		;a46e	31 88 eb 	1 . . 
	nop			;a471	00 	. 
	ld a,(bc)			;a472	0a 	. 
	cp e			;a473	bb 	. 
	inc b			;a474	04 	. 
	ex de,hl			;a475	eb 	. 
	add a,b			;a476	80 	. 
	ld h,d			;a477	62 	b 
	ld sp,0eca8h		;a478	31 a8 ec 	1 . . 
	ld (bc),a			;a47b	02 	. 
	ld l,a			;a47c	6f 	o 
	dec c			;a47d	0d 	. 
	adc a,c			;a47e	89 	. 
	call pe,06280h		;a47f	ec 80 62 	. . b 
	ld sp,0edc8h		;a482	31 c8 ed 	1 . . 
	add a,b			;a485	80 	. 
	ld h,d			;a486	62 	b 
	ld (0ee08h),a		;a487	32 08 ee 	2 . . 
	ld bc,0606dh		;a48a	01 6d 60 	. m ` 
	rlca			;a48d	07 	. 
	xor 080h		;a48e	ee 80 	. . 
	ld h,d			;a490	62 	b 
	dec (hl)			;a491	35 	5 
	rrca			;a492	0f 	. 
	xor 0a4h		;a493	ee a4 	. . 
	ld h,d			;a495	62 	b 
	dec (hl)			;a496	35 	5 
	rst 10h			;a497	d7 	. 
	rst 28h			;a498	ef 	. 
	add a,b			;a499	80 	. 
	ld h,d			;a49a	62 	b 
	ld sp,0f028h		;a49b	31 28 f0 	1 ( . 
	nop			;a49e	00 	. 
	ld c,(hl)			;a49f	4e 	N 
	sub b			;a4a0	90 	. 
	dec b			;a4a1	05 	. 
	ret p			;a4a2	f0 	. 
	add a,b			;a4a3	80 	. 
	ld h,d			;a4a4	62 	b 
	add hl,sp			;a4a5	39 	9 
	ld c,b			;a4a6	48 	H 
	pop af			;a4a7	f1 	. 
	nop			;a4a8	00 	. 
	ld c,b			;a4a9	48 	H 
	xor b			;a4aa	a8 	. 
	ld a,(bc)			;a4ab	0a 	. 
	pop af			;a4ac	f1 	. 
	add a,b			;a4ad	80 	. 
	ld h,d			;a4ae	62 	b 
	add hl,sp			;a4af	39 	9 
	ld l,b			;a4b0	68 	h 
	jp p,01002h		;a4b1	f2 02 10 	. . . 
	sub l			;a4b4	95 	. 
	adc a,d			;a4b5	8a 	. 
	jp p,06280h		;a4b6	f2 80 62 	. . b 
	add hl,sp			;a4b9	39 	9 
	adc a,b			;a4ba	88 	. 
	di			;a4bb	f3 	. 
	nop			;a4bc	00 	. 
	ld b,000h		;a4bd	06 00 	. . 
	inc b			;a4bf	04 	. 
	di			;a4c0	f3 	. 
	add a,b			;a4c1	80 	. 
	ld h,d			;a4c2	62 	b 
	add hl,sp			;a4c3	39 	9 
	xor b			;a4c4	a8 	. 
	call p,sub_6e02h		;a4c5	f4 02 6e 	. . n 
	sub l			;a4c8	95 	. 
	adc a,c			;a4c9	89 	. 
	call p,06280h		;a4ca	f4 80 62 	. . b 
	add hl,sp			;a4cd	39 	9 
	ret z			;a4ce	c8 	. 
	push af			;a4cf	f5 	. 
	nop			;a4d0	00 	. 
	sub b			;a4d1	90 	. 
	xor b			;a4d2	a8 	. 
	dec bc			;a4d3	0b 	. 
	push af			;a4d4	f5 	. 
	add a,b			;a4d5	80 	. 
	ld h,d			;a4d6	62 	b 
	ld a,(0f608h)		;a4d7	3a 08 f6 	: . . 
	ld bc,06017h		;a4da	01 17 60 	. . ` 
	rlca			;a4dd	07 	. 
	or 080h		;a4de	f6 80 	. . 
	ld h,d			;a4e0	62 	b 
	dec a			;a4e1	3d 	= 
	rrca			;a4e2	0f 	. 
	or 0a4h		;a4e3	f6 a4 	. . 
	ld h,d			;a4e5	62 	b 
la4e6h:
	dec a			;a4e6	3d 	= 
	rst 10h			;a4e7	d7 	. 
	rst 30h			;a4e8	f7 	. 
	add a,b			;a4e9	80 	. 
	ld h,d			;a4ea	62 	b 
	add hl,sp			;a4eb	39 	9 
	jr z,la4e6h		;a4ec	28 f8 	( . 
	nop			;a4ee	00 	. 
	ld c,(hl)			;a4ef	4e 	N 
	adc a,b			;a4f0	88 	. 
	dec b			;a4f1	05 	. 
	ret m			;a4f2	f8 	. 
	add a,b			;a4f3	80 	. 
	ld h,d			;a4f4	62 	b 
	ld b,c			;a4f5	41 	A 
	ld c,b			;a4f6	48 	H 
	ld sp,hl			;a4f7	f9 	. 
	nop			;a4f8	00 	. 
	dec d			;a4f9	15 	. 
	dec de			;a4fa	1b 	. 
	ld b,0f9h		;a4fb	06 f9 	. . 
	jr nz,la514h		;a4fd	20 15 	  . 
	dec de			;a4ff	1b 	. 
	ld l,d			;a500	6a 	j 
	ld sp,hl			;a501	f9 	. 
	add a,b			;a502	80 	. 
	ld h,d			;a503	62 	b 
	ld b,c			;a504	41 	A 
	ld l,b			;a505	68 	h 
	jp m,01002h		;a506	fa 02 10 	. . . 
	adc a,l			;a509	8d 	. 
	adc a,d			;a50a	8a 	. 
	jp m,06280h		;a50b	fa 80 62 	. . b 
	ld b,c			;a50e	41 	A 
	adc a,b			;a50f	88 	. 
	ei			;a510	fb 	. 
	nop			;a511	00 	. 
	ex af,af'			;a512	08 	. 
	nop			;a513	00 	. 
la514h:
	inc b			;a514	04 	. 
	ei			;a515	fb 	. 
	add a,b			;a516	80 	. 
	ld h,d			;a517	62 	b 
	ld b,c			;a518	41 	A 
	xor b			;a519	a8 	. 
	call m,sub_6e02h		;a51a	fc 02 6e 	. . n 
	adc a,l			;a51d	8d 	. 
	adc a,c			;a51e	89 	. 
	call m,06280h		;a51f	fc 80 62 	. . b 
	ld b,c			;a522	41 	A 
	ret z			;a523	c8 	. 
	defb 0fdh,080h,062h	;illegal sequence		;a524	fd 80 62 	. . b 
	ld b,d			;a527	42 	B 
	ex af,af'			;a528	08 	. 
	cp 001h		;a529	fe 01 	. . 
	dec b			;a52b	05 	. 
	ld h,b			;a52c	60 	` 
	rlca			;a52d	07 	. 
	cp 080h		;a52e	fe 80 	. . 
	ld h,d			;a530	62 	b 
	ld b,l			;a531	45 	E 
	rrca			;a532	0f 	. 
	cp 0a4h		;a533	fe a4 	. . 
	ld h,d			;a535	62 	b 
	ld b,l			;a536	45 	E 
	rst 10h			;a537	d7 	. 
	rst 38h			;a538	ff 	. 
	add a,b			;a539	80 	. 
	ld h,d			;a53a	62 	b 
	ld b,c			;a53b	41 	A 
	jr z,$+1		;a53c	28 ff 	( . 
	rst 38h			;a53e	ff 	. 
	rst 38h			;a53f	ff 	. 
	rst 38h			;a540	ff 	. 
	rst 38h			;a541	ff 	. 
	nop			;a542	00 	. 
	jr nc,la545h		;a543	30 00 	0 . 
la545h:
	jr nc,la547h		;a545	30 00 	0 . 
la547h:
	jr nc,la549h		;a547	30 00 	0 . 
la549h:
	jr nc,la54bh		;a549	30 00 	0 . 
la54bh:
	jr nc,la54dh		;a54b	30 00 	0 . 
la54dh:
	jr nc,la54fh		;a54d	30 00 	0 . 
la54fh:
	jr nc,la551h		;a54f	30 00 	0 . 
la551h:
	jr nc,la553h		;a551	30 00 	0 . 
la553h:
	jr nc,la555h		;a553	30 00 	0 . 
la555h:
	jr nc,la557h		;a555	30 00 	0 . 
la557h:
	jr nc,la559h		;a557	30 00 	0 . 
la559h:
	jr nc,la55bh		;a559	30 00 	0 . 
la55bh:
	jr nc,la55dh		;a55b	30 00 	0 . 
la55dh:
	jr nc,la55fh		;a55d	30 00 	0 . 
la55fh:
	jr nc,la561h		;a55f	30 00 	0 . 
la561h:
	jr nc,la563h		;a561	30 00 	0 . 
la563h:
	jr nc,la565h		;a563	30 00 	0 . 
la565h:
	jr nc,la567h		;a565	30 00 	0 . 
la567h:
	jr nc,la569h		;a567	30 00 	0 . 
la569h:
	jr nc,la56bh		;a569	30 00 	0 . 
la56bh:
	nop			;a56b	00 	. 
	nop			;a56c	00 	. 
	nop			;a56d	00 	. 
	nop			;a56e	00 	. 
	nop			;a56f	00 	. 
	nop			;a570	00 	. 
	nop			;a571	00 	. 
	nop			;a572	00 	. 
	nop			;a573	00 	. 
	nop			;a574	00 	. 
	nop			;a575	00 	. 
	nop			;a576	00 	. 
	nop			;a577	00 	. 
	nop			;a578	00 	. 
	nop			;a579	00 	. 
	nop			;a57a	00 	. 
	nop			;a57b	00 	. 
	nop			;a57c	00 	. 
	nop			;a57d	00 	. 
	nop			;a57e	00 	. 
	nop			;a57f	00 	. 
	nop			;a580	00 	. 
	nop			;a581	00 	. 
	nop			;a582	00 	. 
	nop			;a583	00 	. 
	nop			;a584	00 	. 
	nop			;a585	00 	. 
	nop			;a586	00 	. 
	nop			;a587	00 	. 
	nop			;a588	00 	. 
	nop			;a589	00 	. 
	nop			;a58a	00 	. 
	nop			;a58b	00 	. 
	nop			;a58c	00 	. 
	nop			;a58d	00 	. 
	nop			;a58e	00 	. 
	nop			;a58f	00 	. 
	nop			;a590	00 	. 
	nop			;a591	00 	. 
	nop			;a592	00 	. 
	nop			;a593	00 	. 
	nop			;a594	00 	. 
	nop			;a595	00 	. 
	nop			;a596	00 	. 
	nop			;a597	00 	. 
	nop			;a598	00 	. 
	nop			;a599	00 	. 
	nop			;a59a	00 	. 
	nop			;a59b	00 	. 
	nop			;a59c	00 	. 
	nop			;a59d	00 	. 
	nop			;a59e	00 	. 
	nop			;a59f	00 	. 
	nop			;a5a0	00 	. 
	nop			;a5a1	00 	. 
	nop			;a5a2	00 	. 
	nop			;a5a3	00 	. 
	nop			;a5a4	00 	. 
	nop			;a5a5	00 	. 
	nop			;a5a6	00 	. 
	nop			;a5a7	00 	. 
	nop			;a5a8	00 	. 
	nop			;a5a9	00 	. 
	nop			;a5aa	00 	. 
	nop			;a5ab	00 	. 
	nop			;a5ac	00 	. 
	nop			;a5ad	00 	. 
	nop			;a5ae	00 	. 
	nop			;a5af	00 	. 
	nop			;a5b0	00 	. 
	nop			;a5b1	00 	. 
	nop			;a5b2	00 	. 
	nop			;a5b3	00 	. 
	nop			;a5b4	00 	. 
	nop			;a5b5	00 	. 
	nop			;a5b6	00 	. 
	nop			;a5b7	00 	. 
	nop			;a5b8	00 	. 
	nop			;a5b9	00 	. 
	nop			;a5ba	00 	. 
	nop			;a5bb	00 	. 
	nop			;a5bc	00 	. 
	nop			;a5bd	00 	. 
	nop			;a5be	00 	. 
	nop			;a5bf	00 	. 
	nop			;a5c0	00 	. 
	nop			;a5c1	00 	. 
	nop			;a5c2	00 	. 
	nop			;a5c3	00 	. 
	nop			;a5c4	00 	. 
	nop			;a5c5	00 	. 
	nop			;a5c6	00 	. 
	nop			;a5c7	00 	. 
	nop			;a5c8	00 	. 
	nop			;a5c9	00 	. 
	nop			;a5ca	00 	. 
	nop			;a5cb	00 	. 
	nop			;a5cc	00 	. 
	nop			;a5cd	00 	. 
	nop			;a5ce	00 	. 
	nop			;a5cf	00 	. 
	nop			;a5d0	00 	. 
	nop			;a5d1	00 	. 
	nop			;a5d2	00 	. 
	nop			;a5d3	00 	. 
	nop			;a5d4	00 	. 
	nop			;a5d5	00 	. 
	nop			;a5d6	00 	. 
	nop			;a5d7	00 	. 
	nop			;a5d8	00 	. 
	nop			;a5d9	00 	. 
	nop			;a5da	00 	. 
	nop			;a5db	00 	. 
	nop			;a5dc	00 	. 
	nop			;a5dd	00 	. 
	nop			;a5de	00 	. 
	nop			;a5df	00 	. 
	nop			;a5e0	00 	. 
	nop			;a5e1	00 	. 
	nop			;a5e2	00 	. 
	nop			;a5e3	00 	. 
	nop			;a5e4	00 	. 
	nop			;a5e5	00 	. 
	nop			;a5e6	00 	. 
	nop			;a5e7	00 	. 
	nop			;a5e8	00 	. 
	nop			;a5e9	00 	. 
	nop			;a5ea	00 	. 
	nop			;a5eb	00 	. 
	nop			;a5ec	00 	. 
	nop			;a5ed	00 	. 
	nop			;a5ee	00 	. 
	nop			;a5ef	00 	. 
	nop			;a5f0	00 	. 
	nop			;a5f1	00 	. 
	nop			;a5f2	00 	. 
	nop			;a5f3	00 	. 
	nop			;a5f4	00 	. 
	nop			;a5f5	00 	. 
	nop			;a5f6	00 	. 
	nop			;a5f7	00 	. 
	nop			;a5f8	00 	. 
	nop			;a5f9	00 	. 
	nop			;a5fa	00 	. 
	nop			;a5fb	00 	. 
	nop			;a5fc	00 	. 
	nop			;a5fd	00 	. 
	nop			;a5fe	00 	. 
	nop			;a5ff	00 	. 
	nop			;a600	00 	. 
	nop			;a601	00 	. 
	nop			;a602	00 	. 
	nop			;a603	00 	. 
	nop			;a604	00 	. 
	nop			;a605	00 	. 
	nop			;a606	00 	. 
	nop			;a607	00 	. 
la608h:
	nop			;a608	00 	. 
	nop			;a609	00 	. 
	nop			;a60a	00 	. 
	nop			;a60b	00 	. 
	nop			;a60c	00 	. 
	nop			;a60d	00 	. 
	nop			;a60e	00 	. 
	nop			;a60f	00 	. 
	nop			;a610	00 	. 
	nop			;a611	00 	. 
	nop			;a612	00 	. 
	nop			;a613	00 	. 
	nop			;a614	00 	. 
	nop			;a615	00 	. 
	nop			;a616	00 	. 
	nop			;a617	00 	. 
	nop			;a618	00 	. 
	nop			;a619	00 	. 
	nop			;a61a	00 	. 
	nop			;a61b	00 	. 
	nop			;a61c	00 	. 
	nop			;a61d	00 	. 
	nop			;a61e	00 	. 
	nop			;a61f	00 	. 
	nop			;a620	00 	. 
	nop			;a621	00 	. 
	nop			;a622	00 	. 
	nop			;a623	00 	. 
	nop			;a624	00 	. 
	nop			;a625	00 	. 
	nop			;a626	00 	. 
	nop			;a627	00 	. 
	nop			;a628	00 	. 
	nop			;a629	00 	. 
	nop			;a62a	00 	. 
	nop			;a62b	00 	. 
	nop			;a62c	00 	. 
	nop			;a62d	00 	. 
	nop			;a62e	00 	. 
	nop			;a62f	00 	. 
	nop			;a630	00 	. 
	nop			;a631	00 	. 
	nop			;a632	00 	. 
	nop			;a633	00 	. 
	nop			;a634	00 	. 
	nop			;a635	00 	. 
	nop			;a636	00 	. 
	nop			;a637	00 	. 
	nop			;a638	00 	. 
	nop			;a639	00 	. 
	nop			;a63a	00 	. 
	nop			;a63b	00 	. 
	nop			;a63c	00 	. 
	nop			;a63d	00 	. 
	nop			;a63e	00 	. 
	nop			;a63f	00 	. 
	nop			;a640	00 	. 
	nop			;a641	00 	. 
	nop			;a642	00 	. 
	nop			;a643	00 	. 
	nop			;a644	00 	. 
	nop			;a645	00 	. 
	nop			;a646	00 	. 
	nop			;a647	00 	. 
	nop			;a648	00 	. 
	nop			;a649	00 	. 
	nop			;a64a	00 	. 
	nop			;a64b	00 	. 
	nop			;a64c	00 	. 
	nop			;a64d	00 	. 
	nop			;a64e	00 	. 
	nop			;a64f	00 	. 
	nop			;a650	00 	. 
	nop			;a651	00 	. 
	nop			;a652	00 	. 
	nop			;a653	00 	. 
	nop			;a654	00 	. 
	nop			;a655	00 	. 
	nop			;a656	00 	. 
	nop			;a657	00 	. 
	nop			;a658	00 	. 
	nop			;a659	00 	. 
	nop			;a65a	00 	. 
	nop			;a65b	00 	. 
	nop			;a65c	00 	. 
	nop			;a65d	00 	. 
	nop			;a65e	00 	. 
	nop			;a65f	00 	. 
	nop			;a660	00 	. 
	nop			;a661	00 	. 
	nop			;a662	00 	. 
	nop			;a663	00 	. 
	nop			;a664	00 	. 
	nop			;a665	00 	. 
	nop			;a666	00 	. 
	nop			;a667	00 	. 
	nop			;a668	00 	. 
	nop			;a669	00 	. 
	nop			;a66a	00 	. 
	nop			;a66b	00 	. 
	nop			;a66c	00 	. 
	nop			;a66d	00 	. 
	nop			;a66e	00 	. 
	nop			;a66f	00 	. 
	nop			;a670	00 	. 
	nop			;a671	00 	. 
	nop			;a672	00 	. 
	nop			;a673	00 	. 
	nop			;a674	00 	. 
	nop			;a675	00 	. 
	nop			;a676	00 	. 
	nop			;a677	00 	. 
	nop			;a678	00 	. 
	nop			;a679	00 	. 
	nop			;a67a	00 	. 
	nop			;a67b	00 	. 
	nop			;a67c	00 	. 
	nop			;a67d	00 	. 
	nop			;a67e	00 	. 
	nop			;a67f	00 	. 
	nop			;a680	00 	. 
	nop			;a681	00 	. 
	nop			;a682	00 	. 
	nop			;a683	00 	. 
	nop			;a684	00 	. 
	nop			;a685	00 	. 
	nop			;a686	00 	. 
	nop			;a687	00 	. 
	nop			;a688	00 	. 
	nop			;a689	00 	. 
	nop			;a68a	00 	. 
	nop			;a68b	00 	. 
	nop			;a68c	00 	. 
	nop			;a68d	00 	. 
	nop			;a68e	00 	. 
	nop			;a68f	00 	. 
	nop			;a690	00 	. 
	nop			;a691	00 	. 
	nop			;a692	00 	. 
	nop			;a693	00 	. 
	nop			;a694	00 	. 
	nop			;a695	00 	. 
	nop			;a696	00 	. 
	nop			;a697	00 	. 
	nop			;a698	00 	. 
	nop			;a699	00 	. 
	nop			;a69a	00 	. 
	nop			;a69b	00 	. 
	nop			;a69c	00 	. 
	nop			;a69d	00 	. 
	nop			;a69e	00 	. 
	nop			;a69f	00 	. 
	nop			;a6a0	00 	. 
	nop			;a6a1	00 	. 
	nop			;a6a2	00 	. 
	nop			;a6a3	00 	. 
	nop			;a6a4	00 	. 
	nop			;a6a5	00 	. 
	nop			;a6a6	00 	. 
	nop			;a6a7	00 	. 
	nop			;a6a8	00 	. 
	nop			;a6a9	00 	. 
	nop			;a6aa	00 	. 
	nop			;a6ab	00 	. 
	nop			;a6ac	00 	. 
	nop			;a6ad	00 	. 
	nop			;a6ae	00 	. 
	nop			;a6af	00 	. 
	nop			;a6b0	00 	. 
	nop			;a6b1	00 	. 
	nop			;a6b2	00 	. 
	nop			;a6b3	00 	. 
	nop			;a6b4	00 	. 
	nop			;a6b5	00 	. 
	nop			;a6b6	00 	. 
	nop			;a6b7	00 	. 
	nop			;a6b8	00 	. 
	nop			;a6b9	00 	. 
	nop			;a6ba	00 	. 
	nop			;a6bb	00 	. 
	nop			;a6bc	00 	. 
	nop			;a6bd	00 	. 
	nop			;a6be	00 	. 
	nop			;a6bf	00 	. 
	nop			;a6c0	00 	. 
	nop			;a6c1	00 	. 
	nop			;a6c2	00 	. 
	nop			;a6c3	00 	. 
	nop			;a6c4	00 	. 
	nop			;a6c5	00 	. 
	nop			;a6c6	00 	. 
	nop			;a6c7	00 	. 
	nop			;a6c8	00 	. 
	nop			;a6c9	00 	. 
	nop			;a6ca	00 	. 
	nop			;a6cb	00 	. 
	nop			;a6cc	00 	. 
	nop			;a6cd	00 	. 
	nop			;a6ce	00 	. 
	nop			;a6cf	00 	. 
	nop			;a6d0	00 	. 
	nop			;a6d1	00 	. 
	nop			;a6d2	00 	. 
	nop			;a6d3	00 	. 
	nop			;a6d4	00 	. 
	nop			;a6d5	00 	. 
	nop			;a6d6	00 	. 
	nop			;a6d7	00 	. 
	nop			;a6d8	00 	. 
	nop			;a6d9	00 	. 
	nop			;a6da	00 	. 
	nop			;a6db	00 	. 
	nop			;a6dc	00 	. 
	nop			;a6dd	00 	. 
	nop			;a6de	00 	. 
	nop			;a6df	00 	. 
	nop			;a6e0	00 	. 
	nop			;a6e1	00 	. 
	nop			;a6e2	00 	. 
	nop			;a6e3	00 	. 
	nop			;a6e4	00 	. 
	nop			;a6e5	00 	. 
	nop			;a6e6	00 	. 
	nop			;a6e7	00 	. 
	nop			;a6e8	00 	. 
	nop			;a6e9	00 	. 
	nop			;a6ea	00 	. 
	nop			;a6eb	00 	. 
	nop			;a6ec	00 	. 
	nop			;a6ed	00 	. 
	nop			;a6ee	00 	. 
	nop			;a6ef	00 	. 
	nop			;a6f0	00 	. 
	nop			;a6f1	00 	. 
	nop			;a6f2	00 	. 
	nop			;a6f3	00 	. 
	nop			;a6f4	00 	. 
	nop			;a6f5	00 	. 
	nop			;a6f6	00 	. 
	nop			;a6f7	00 	. 
	nop			;a6f8	00 	. 
	nop			;a6f9	00 	. 
	nop			;a6fa	00 	. 
	nop			;a6fb	00 	. 
	nop			;a6fc	00 	. 
	nop			;a6fd	00 	. 
	nop			;a6fe	00 	. 
	nop			;a6ff	00 	. 
	nop			;a700	00 	. 
	nop			;a701	00 	. 
	nop			;a702	00 	. 
	nop			;a703	00 	. 
	nop			;a704	00 	. 
	nop			;a705	00 	. 
	nop			;a706	00 	. 
	nop			;a707	00 	. 
	nop			;a708	00 	. 
	nop			;a709	00 	. 
	nop			;a70a	00 	. 
	nop			;a70b	00 	. 
	nop			;a70c	00 	. 
	nop			;a70d	00 	. 
	nop			;a70e	00 	. 
	nop			;a70f	00 	. 
	nop			;a710	00 	. 
	nop			;a711	00 	. 
	nop			;a712	00 	. 
	nop			;a713	00 	. 
	nop			;a714	00 	. 
	nop			;a715	00 	. 
	nop			;a716	00 	. 
	nop			;a717	00 	. 
	nop			;a718	00 	. 
	nop			;a719	00 	. 
	nop			;a71a	00 	. 
	nop			;a71b	00 	. 
	nop			;a71c	00 	. 
	nop			;a71d	00 	. 
	nop			;a71e	00 	. 
	nop			;a71f	00 	. 
	nop			;a720	00 	. 
	nop			;a721	00 	. 
	nop			;a722	00 	. 
	nop			;a723	00 	. 
	nop			;a724	00 	. 
	nop			;a725	00 	. 
	nop			;a726	00 	. 
	nop			;a727	00 	. 
	nop			;a728	00 	. 
	nop			;a729	00 	. 
	nop			;a72a	00 	. 
	nop			;a72b	00 	. 
	nop			;a72c	00 	. 
	nop			;a72d	00 	. 
	nop			;a72e	00 	. 
	nop			;a72f	00 	. 
	nop			;a730	00 	. 
	nop			;a731	00 	. 
	nop			;a732	00 	. 
	nop			;a733	00 	. 
	nop			;a734	00 	. 
	nop			;a735	00 	. 
	nop			;a736	00 	. 
	nop			;a737	00 	. 
	nop			;a738	00 	. 
	nop			;a739	00 	. 
	nop			;a73a	00 	. 
	nop			;a73b	00 	. 
	nop			;a73c	00 	. 
	nop			;a73d	00 	. 
	nop			;a73e	00 	. 
	nop			;a73f	00 	. 
	nop			;a740	00 	. 
	nop			;a741	00 	. 
	nop			;a742	00 	. 
	nop			;a743	00 	. 
	nop			;a744	00 	. 
	nop			;a745	00 	. 
	nop			;a746	00 	. 
	nop			;a747	00 	. 
	nop			;a748	00 	. 
	nop			;a749	00 	. 
	nop			;a74a	00 	. 
	nop			;a74b	00 	. 
	nop			;a74c	00 	. 
	nop			;a74d	00 	. 
	nop			;a74e	00 	. 
	nop			;a74f	00 	. 
	nop			;a750	00 	. 
	nop			;a751	00 	. 
	nop			;a752	00 	. 
	nop			;a753	00 	. 
	nop			;a754	00 	. 
	nop			;a755	00 	. 
	nop			;a756	00 	. 
	nop			;a757	00 	. 
	nop			;a758	00 	. 
	nop			;a759	00 	. 
	nop			;a75a	00 	. 
	nop			;a75b	00 	. 
	nop			;a75c	00 	. 
	nop			;a75d	00 	. 
	nop			;a75e	00 	. 
	nop			;a75f	00 	. 
	nop			;a760	00 	. 
	nop			;a761	00 	. 
	nop			;a762	00 	. 
	nop			;a763	00 	. 
	nop			;a764	00 	. 
	nop			;a765	00 	. 
	nop			;a766	00 	. 
	nop			;a767	00 	. 
	nop			;a768	00 	. 
	nop			;a769	00 	. 
	nop			;a76a	00 	. 
	nop			;a76b	00 	. 
	nop			;a76c	00 	. 
	nop			;a76d	00 	. 
	nop			;a76e	00 	. 
	nop			;a76f	00 	. 
	nop			;a770	00 	. 
	nop			;a771	00 	. 
	nop			;a772	00 	. 
	nop			;a773	00 	. 
	nop			;a774	00 	. 
	nop			;a775	00 	. 
	nop			;a776	00 	. 
	nop			;a777	00 	. 
	nop			;a778	00 	. 
	nop			;a779	00 	. 
	nop			;a77a	00 	. 
	nop			;a77b	00 	. 
	nop			;a77c	00 	. 
	nop			;a77d	00 	. 
	nop			;a77e	00 	. 
	nop			;a77f	00 	. 
	nop			;a780	00 	. 
	nop			;a781	00 	. 
	nop			;a782	00 	. 
	nop			;a783	00 	. 
	nop			;a784	00 	. 
	nop			;a785	00 	. 
	nop			;a786	00 	. 
	nop			;a787	00 	. 
	nop			;a788	00 	. 
	nop			;a789	00 	. 
	nop			;a78a	00 	. 
	nop			;a78b	00 	. 
	nop			;a78c	00 	. 
	nop			;a78d	00 	. 
	nop			;a78e	00 	. 
	nop			;a78f	00 	. 
	nop			;a790	00 	. 
	nop			;a791	00 	. 
	nop			;a792	00 	. 
	nop			;a793	00 	. 
	nop			;a794	00 	. 
	nop			;a795	00 	. 
	nop			;a796	00 	. 
	nop			;a797	00 	. 
	nop			;a798	00 	. 
	nop			;a799	00 	. 
	nop			;a79a	00 	. 
	nop			;a79b	00 	. 
	nop			;a79c	00 	. 
	nop			;a79d	00 	. 
	nop			;a79e	00 	. 
	nop			;a79f	00 	. 
	nop			;a7a0	00 	. 
	nop			;a7a1	00 	. 
	nop			;a7a2	00 	. 
	nop			;a7a3	00 	. 
	nop			;a7a4	00 	. 
	nop			;a7a5	00 	. 
	nop			;a7a6	00 	. 
	nop			;a7a7	00 	. 
	nop			;a7a8	00 	. 
	nop			;a7a9	00 	. 
	nop			;a7aa	00 	. 
	nop			;a7ab	00 	. 
	nop			;a7ac	00 	. 
	nop			;a7ad	00 	. 
	nop			;a7ae	00 	. 
	nop			;a7af	00 	. 
	nop			;a7b0	00 	. 
	nop			;a7b1	00 	. 
	nop			;a7b2	00 	. 
	nop			;a7b3	00 	. 
	nop			;a7b4	00 	. 
	nop			;a7b5	00 	. 
	nop			;a7b6	00 	. 
	nop			;a7b7	00 	. 
	nop			;a7b8	00 	. 
	nop			;a7b9	00 	. 
	nop			;a7ba	00 	. 
	nop			;a7bb	00 	. 
	nop			;a7bc	00 	. 
	nop			;a7bd	00 	. 
	nop			;a7be	00 	. 
	nop			;a7bf	00 	. 
	nop			;a7c0	00 	. 
	nop			;a7c1	00 	. 
	nop			;a7c2	00 	. 
	nop			;a7c3	00 	. 
	nop			;a7c4	00 	. 
	nop			;a7c5	00 	. 
	nop			;a7c6	00 	. 
	nop			;a7c7	00 	. 
	nop			;a7c8	00 	. 
	nop			;a7c9	00 	. 
	nop			;a7ca	00 	. 
	nop			;a7cb	00 	. 
	nop			;a7cc	00 	. 
	nop			;a7cd	00 	. 
	nop			;a7ce	00 	. 
	nop			;a7cf	00 	. 
	nop			;a7d0	00 	. 
	nop			;a7d1	00 	. 
	nop			;a7d2	00 	. 
	nop			;a7d3	00 	. 
	nop			;a7d4	00 	. 
	nop			;a7d5	00 	. 
	nop			;a7d6	00 	. 
	nop			;a7d7	00 	. 
	nop			;a7d8	00 	. 
	nop			;a7d9	00 	. 
	nop			;a7da	00 	. 
	nop			;a7db	00 	. 
	nop			;a7dc	00 	. 
	nop			;a7dd	00 	. 
	nop			;a7de	00 	. 
	nop			;a7df	00 	. 
	nop			;a7e0	00 	. 
	nop			;a7e1	00 	. 
	nop			;a7e2	00 	. 
	nop			;a7e3	00 	. 
	nop			;a7e4	00 	. 
	nop			;a7e5	00 	. 
	nop			;a7e6	00 	. 
	nop			;a7e7	00 	. 
	nop			;a7e8	00 	. 
	nop			;a7e9	00 	. 
	nop			;a7ea	00 	. 
	nop			;a7eb	00 	. 
	nop			;a7ec	00 	. 
	nop			;a7ed	00 	. 
	nop			;a7ee	00 	. 
	nop			;a7ef	00 	. 
	nop			;a7f0	00 	. 
	nop			;a7f1	00 	. 
	nop			;a7f2	00 	. 
	nop			;a7f3	00 	. 
	nop			;a7f4	00 	. 
	nop			;a7f5	00 	. 
	nop			;a7f6	00 	. 
	nop			;a7f7	00 	. 
	nop			;a7f8	00 	. 
	nop			;a7f9	00 	. 
	nop			;a7fa	00 	. 
	nop			;a7fb	00 	. 
	nop			;a7fc	00 	. 
	nop			;a7fd	00 	. 
	nop			;a7fe	00 	. 
	nop			;a7ff	00 	. 
	nop			;a800	00 	. 
	nop			;a801	00 	. 
	nop			;a802	00 	. 
	nop			;a803	00 	. 
	nop			;a804	00 	. 
	nop			;a805	00 	. 
	nop			;a806	00 	. 
	nop			;a807	00 	. 
	nop			;a808	00 	. 
la809h:
	nop			;a809	00 	. 
	nop			;a80a	00 	. 
	nop			;a80b	00 	. 
	nop			;a80c	00 	. 
	nop			;a80d	00 	. 
	nop			;a80e	00 	. 
	nop			;a80f	00 	. 
	nop			;a810	00 	. 
la811h:
	nop			;a811	00 	. 
	nop			;a812	00 	. 
	nop			;a813	00 	. 
	nop			;a814	00 	. 
	nop			;a815	00 	. 
	nop			;a816	00 	. 
	nop			;a817	00 	. 
	nop			;a818	00 	. 
la819h:
	nop			;a819	00 	. 
	nop			;a81a	00 	. 
	nop			;a81b	00 	. 
	nop			;a81c	00 	. 
	nop			;a81d	00 	. 
	nop			;a81e	00 	. 
	nop			;a81f	00 	. 
	nop			;a820	00 	. 
la821h:
	nop			;a821	00 	. 
	nop			;a822	00 	. 
	nop			;a823	00 	. 
	nop			;a824	00 	. 
	nop			;a825	00 	. 
	nop			;a826	00 	. 
	nop			;a827	00 	. 
	nop			;a828	00 	. 
la829h:
	nop			;a829	00 	. 
	nop			;a82a	00 	. 
	nop			;a82b	00 	. 
	nop			;a82c	00 	. 
	nop			;a82d	00 	. 
	nop			;a82e	00 	. 
	nop			;a82f	00 	. 
	nop			;a830	00 	. 
la831h:
	nop			;a831	00 	. 
	nop			;a832	00 	. 
	nop			;a833	00 	. 
	nop			;a834	00 	. 
	nop			;a835	00 	. 
	nop			;a836	00 	. 
	nop			;a837	00 	. 
	nop			;a838	00 	. 
la839h:
	nop			;a839	00 	. 
	nop			;a83a	00 	. 
	nop			;a83b	00 	. 
	nop			;a83c	00 	. 
	nop			;a83d	00 	. 
	nop			;a83e	00 	. 
	nop			;a83f	00 	. 
	nop			;a840	00 	. 
la841h:
	nop			;a841	00 	. 
	nop			;a842	00 	. 
	nop			;a843	00 	. 
	nop			;a844	00 	. 
	nop			;a845	00 	. 
	nop			;a846	00 	. 
	nop			;a847	00 	. 
	nop			;a848	00 	. 
	nop			;a849	00 	. 
	nop			;a84a	00 	. 
	nop			;a84b	00 	. 
	nop			;a84c	00 	. 
	nop			;a84d	00 	. 
	nop			;a84e	00 	. 
	nop			;a84f	00 	. 
	nop			;a850	00 	. 
	nop			;a851	00 	. 
	nop			;a852	00 	. 
	nop			;a853	00 	. 
	nop			;a854	00 	. 
	nop			;a855	00 	. 
	nop			;a856	00 	. 
	nop			;a857	00 	. 
	nop			;a858	00 	. 
	nop			;a859	00 	. 
	nop			;a85a	00 	. 
	nop			;a85b	00 	. 
	nop			;a85c	00 	. 
	nop			;a85d	00 	. 
	nop			;a85e	00 	. 
	nop			;a85f	00 	. 
	nop			;a860	00 	. 
	nop			;a861	00 	. 
	nop			;a862	00 	. 
	nop			;a863	00 	. 
	nop			;a864	00 	. 
	nop			;a865	00 	. 
	nop			;a866	00 	. 
	nop			;a867	00 	. 
	nop			;a868	00 	. 
	nop			;a869	00 	. 
	nop			;a86a	00 	. 
	nop			;a86b	00 	. 
	nop			;a86c	00 	. 
	nop			;a86d	00 	. 
	nop			;a86e	00 	. 
	nop			;a86f	00 	. 
	nop			;a870	00 	. 
	nop			;a871	00 	. 
	nop			;a872	00 	. 
	nop			;a873	00 	. 
	nop			;a874	00 	. 
	nop			;a875	00 	. 
	nop			;a876	00 	. 
	nop			;a877	00 	. 
	nop			;a878	00 	. 
	nop			;a879	00 	. 
	nop			;a87a	00 	. 
	nop			;a87b	00 	. 
	nop			;a87c	00 	. 
	nop			;a87d	00 	. 
	nop			;a87e	00 	. 
	nop			;a87f	00 	. 
	nop			;a880	00 	. 
	nop			;a881	00 	. 
	nop			;a882	00 	. 
	nop			;a883	00 	. 
	nop			;a884	00 	. 
	nop			;a885	00 	. 
	nop			;a886	00 	. 
	nop			;a887	00 	. 
	nop			;a888	00 	. 
	nop			;a889	00 	. 
	nop			;a88a	00 	. 
	nop			;a88b	00 	. 
	nop			;a88c	00 	. 
	nop			;a88d	00 	. 
	nop			;a88e	00 	. 
	nop			;a88f	00 	. 
	nop			;a890	00 	. 
	nop			;a891	00 	. 
	nop			;a892	00 	. 
	nop			;a893	00 	. 
	nop			;a894	00 	. 
	nop			;a895	00 	. 
	nop			;a896	00 	. 
	nop			;a897	00 	. 
	nop			;a898	00 	. 
	nop			;a899	00 	. 
	nop			;a89a	00 	. 
	nop			;a89b	00 	. 
	nop			;a89c	00 	. 
	nop			;a89d	00 	. 
	nop			;a89e	00 	. 
	nop			;a89f	00 	. 
	nop			;a8a0	00 	. 
	nop			;a8a1	00 	. 
	nop			;a8a2	00 	. 
	nop			;a8a3	00 	. 
	nop			;a8a4	00 	. 
	nop			;a8a5	00 	. 
	nop			;a8a6	00 	. 
	nop			;a8a7	00 	. 
	nop			;a8a8	00 	. 
	nop			;a8a9	00 	. 
	nop			;a8aa	00 	. 
	nop			;a8ab	00 	. 
	nop			;a8ac	00 	. 
	nop			;a8ad	00 	. 
	nop			;a8ae	00 	. 
	nop			;a8af	00 	. 
	nop			;a8b0	00 	. 
	nop			;a8b1	00 	. 
	nop			;a8b2	00 	. 
	nop			;a8b3	00 	. 
	nop			;a8b4	00 	. 
	nop			;a8b5	00 	. 
	nop			;a8b6	00 	. 
	nop			;a8b7	00 	. 
	nop			;a8b8	00 	. 
	nop			;a8b9	00 	. 
	nop			;a8ba	00 	. 
	nop			;a8bb	00 	. 
	nop			;a8bc	00 	. 
	nop			;a8bd	00 	. 
	nop			;a8be	00 	. 
	nop			;a8bf	00 	. 
	nop			;a8c0	00 	. 
	nop			;a8c1	00 	. 
	nop			;a8c2	00 	. 
	nop			;a8c3	00 	. 
	nop			;a8c4	00 	. 
	nop			;a8c5	00 	. 
	nop			;a8c6	00 	. 
	nop			;a8c7	00 	. 
	nop			;a8c8	00 	. 
	nop			;a8c9	00 	. 
	nop			;a8ca	00 	. 
	nop			;a8cb	00 	. 
	nop			;a8cc	00 	. 
	nop			;a8cd	00 	. 
	nop			;a8ce	00 	. 
	nop			;a8cf	00 	. 
	nop			;a8d0	00 	. 
	nop			;a8d1	00 	. 
	nop			;a8d2	00 	. 
	nop			;a8d3	00 	. 
	nop			;a8d4	00 	. 
	nop			;a8d5	00 	. 
	nop			;a8d6	00 	. 
	nop			;a8d7	00 	. 
	nop			;a8d8	00 	. 
	nop			;a8d9	00 	. 
	nop			;a8da	00 	. 
	nop			;a8db	00 	. 
	nop			;a8dc	00 	. 
	nop			;a8dd	00 	. 
	nop			;a8de	00 	. 
	nop			;a8df	00 	. 
	nop			;a8e0	00 	. 
	nop			;a8e1	00 	. 
	nop			;a8e2	00 	. 
	nop			;a8e3	00 	. 
	nop			;a8e4	00 	. 
	nop			;a8e5	00 	. 
	nop			;a8e6	00 	. 
	nop			;a8e7	00 	. 
	nop			;a8e8	00 	. 
	nop			;a8e9	00 	. 
	nop			;a8ea	00 	. 
	nop			;a8eb	00 	. 
	nop			;a8ec	00 	. 
	nop			;a8ed	00 	. 
	nop			;a8ee	00 	. 
	nop			;a8ef	00 	. 
	nop			;a8f0	00 	. 
	nop			;a8f1	00 	. 
	nop			;a8f2	00 	. 
	nop			;a8f3	00 	. 
	nop			;a8f4	00 	. 
	nop			;a8f5	00 	. 
	nop			;a8f6	00 	. 
	nop			;a8f7	00 	. 
	nop			;a8f8	00 	. 
	nop			;a8f9	00 	. 
	nop			;a8fa	00 	. 
	nop			;a8fb	00 	. 
	nop			;a8fc	00 	. 
	nop			;a8fd	00 	. 
	nop			;a8fe	00 	. 
	nop			;a8ff	00 	. 
	nop			;a900	00 	. 
	nop			;a901	00 	. 
	nop			;a902	00 	. 
	nop			;a903	00 	. 
	nop			;a904	00 	. 
	nop			;a905	00 	. 
	nop			;a906	00 	. 
	nop			;a907	00 	. 
	nop			;a908	00 	. 
	nop			;a909	00 	. 
	nop			;a90a	00 	. 
	nop			;a90b	00 	. 
	nop			;a90c	00 	. 
	nop			;a90d	00 	. 
	nop			;a90e	00 	. 
	nop			;a90f	00 	. 
	nop			;a910	00 	. 
	nop			;a911	00 	. 
	nop			;a912	00 	. 
	nop			;a913	00 	. 
	nop			;a914	00 	. 
	nop			;a915	00 	. 
	nop			;a916	00 	. 
	nop			;a917	00 	. 
	nop			;a918	00 	. 
	nop			;a919	00 	. 
	nop			;a91a	00 	. 
	nop			;a91b	00 	. 
	nop			;a91c	00 	. 
	nop			;a91d	00 	. 
	nop			;a91e	00 	. 
	nop			;a91f	00 	. 
	nop			;a920	00 	. 
	nop			;a921	00 	. 
	nop			;a922	00 	. 
	nop			;a923	00 	. 
	nop			;a924	00 	. 
	nop			;a925	00 	. 
	nop			;a926	00 	. 
	nop			;a927	00 	. 
	nop			;a928	00 	. 
	nop			;a929	00 	. 
	nop			;a92a	00 	. 
	nop			;a92b	00 	. 
	nop			;a92c	00 	. 
	nop			;a92d	00 	. 
	nop			;a92e	00 	. 
	nop			;a92f	00 	. 
	nop			;a930	00 	. 
	nop			;a931	00 	. 
	nop			;a932	00 	. 
	nop			;a933	00 	. 
	nop			;a934	00 	. 
	nop			;a935	00 	. 
	nop			;a936	00 	. 
	nop			;a937	00 	. 
	nop			;a938	00 	. 
	nop			;a939	00 	. 
	nop			;a93a	00 	. 
	nop			;a93b	00 	. 
	nop			;a93c	00 	. 
	nop			;a93d	00 	. 
	nop			;a93e	00 	. 
	nop			;a93f	00 	. 
	nop			;a940	00 	. 
	nop			;a941	00 	. 
	nop			;a942	00 	. 
	nop			;a943	00 	. 
	nop			;a944	00 	. 
	nop			;a945	00 	. 
	nop			;a946	00 	. 
	nop			;a947	00 	. 
la948h:
	nop			;a948	00 	. 
	nop			;a949	00 	. 
	nop			;a94a	00 	. 
	nop			;a94b	00 	. 
	nop			;a94c	00 	. 
	nop			;a94d	00 	. 
	nop			;a94e	00 	. 
	nop			;a94f	00 	. 
	nop			;a950	00 	. 
	nop			;a951	00 	. 
	nop			;a952	00 	. 
	nop			;a953	00 	. 
	nop			;a954	00 	. 
	nop			;a955	00 	. 
	nop			;a956	00 	. 
	nop			;a957	00 	. 
	nop			;a958	00 	. 
	nop			;a959	00 	. 
	nop			;a95a	00 	. 
	nop			;a95b	00 	. 
	nop			;a95c	00 	. 
	nop			;a95d	00 	. 
	nop			;a95e	00 	. 
	nop			;a95f	00 	. 
	nop			;a960	00 	. 
	nop			;a961	00 	. 
	nop			;a962	00 	. 
	nop			;a963	00 	. 
	nop			;a964	00 	. 
	nop			;a965	00 	. 
	nop			;a966	00 	. 
	nop			;a967	00 	. 
	nop			;a968	00 	. 
	nop			;a969	00 	. 
	nop			;a96a	00 	. 
	nop			;a96b	00 	. 
	nop			;a96c	00 	. 
	nop			;a96d	00 	. 
	nop			;a96e	00 	. 
	nop			;a96f	00 	. 
	nop			;a970	00 	. 
	nop			;a971	00 	. 
	nop			;a972	00 	. 
	nop			;a973	00 	. 
	nop			;a974	00 	. 
	nop			;a975	00 	. 
	nop			;a976	00 	. 
	nop			;a977	00 	. 
	nop			;a978	00 	. 
	nop			;a979	00 	. 
	nop			;a97a	00 	. 
	nop			;a97b	00 	. 
	nop			;a97c	00 	. 
	nop			;a97d	00 	. 
	nop			;a97e	00 	. 
	nop			;a97f	00 	. 
	nop			;a980	00 	. 
	nop			;a981	00 	. 
	nop			;a982	00 	. 
	nop			;a983	00 	. 
	nop			;a984	00 	. 
	nop			;a985	00 	. 
	nop			;a986	00 	. 
	nop			;a987	00 	. 
	nop			;a988	00 	. 
	nop			;a989	00 	. 
	nop			;a98a	00 	. 
	nop			;a98b	00 	. 
	nop			;a98c	00 	. 
	nop			;a98d	00 	. 
	nop			;a98e	00 	. 
	nop			;a98f	00 	. 
	nop			;a990	00 	. 
	nop			;a991	00 	. 
	nop			;a992	00 	. 
	nop			;a993	00 	. 
	nop			;a994	00 	. 
	nop			;a995	00 	. 
	nop			;a996	00 	. 
	nop			;a997	00 	. 
	nop			;a998	00 	. 
	nop			;a999	00 	. 
	nop			;a99a	00 	. 
	nop			;a99b	00 	. 
	nop			;a99c	00 	. 
	nop			;a99d	00 	. 
	nop			;a99e	00 	. 
	nop			;a99f	00 	. 
	nop			;a9a0	00 	. 
	nop			;a9a1	00 	. 
	nop			;a9a2	00 	. 
	nop			;a9a3	00 	. 
	nop			;a9a4	00 	. 
	nop			;a9a5	00 	. 
	nop			;a9a6	00 	. 
	nop			;a9a7	00 	. 
	nop			;a9a8	00 	. 
	nop			;a9a9	00 	. 
	nop			;a9aa	00 	. 
	nop			;a9ab	00 	. 
	nop			;a9ac	00 	. 
	nop			;a9ad	00 	. 
	nop			;a9ae	00 	. 
	nop			;a9af	00 	. 
	nop			;a9b0	00 	. 
	nop			;a9b1	00 	. 
	nop			;a9b2	00 	. 
	nop			;a9b3	00 	. 
	nop			;a9b4	00 	. 
	nop			;a9b5	00 	. 
	nop			;a9b6	00 	. 
	nop			;a9b7	00 	. 
	nop			;a9b8	00 	. 
	nop			;a9b9	00 	. 
	nop			;a9ba	00 	. 
	nop			;a9bb	00 	. 
	nop			;a9bc	00 	. 
	nop			;a9bd	00 	. 
	nop			;a9be	00 	. 
	nop			;a9bf	00 	. 
	nop			;a9c0	00 	. 
	nop			;a9c1	00 	. 
	nop			;a9c2	00 	. 
	nop			;a9c3	00 	. 
	nop			;a9c4	00 	. 
	nop			;a9c5	00 	. 
	nop			;a9c6	00 	. 
	nop			;a9c7	00 	. 
	nop			;a9c8	00 	. 
	nop			;a9c9	00 	. 
	nop			;a9ca	00 	. 
	nop			;a9cb	00 	. 
	nop			;a9cc	00 	. 
	nop			;a9cd	00 	. 
	nop			;a9ce	00 	. 
	nop			;a9cf	00 	. 
	nop			;a9d0	00 	. 
	nop			;a9d1	00 	. 
	nop			;a9d2	00 	. 
	nop			;a9d3	00 	. 
	nop			;a9d4	00 	. 
	nop			;a9d5	00 	. 
	nop			;a9d6	00 	. 
	nop			;a9d7	00 	. 
	nop			;a9d8	00 	. 
	nop			;a9d9	00 	. 
	nop			;a9da	00 	. 
	nop			;a9db	00 	. 
	nop			;a9dc	00 	. 
	nop			;a9dd	00 	. 
	nop			;a9de	00 	. 
	nop			;a9df	00 	. 
	nop			;a9e0	00 	. 
	nop			;a9e1	00 	. 
	nop			;a9e2	00 	. 
	nop			;a9e3	00 	. 
	nop			;a9e4	00 	. 
	nop			;a9e5	00 	. 
	nop			;a9e6	00 	. 
	nop			;a9e7	00 	. 
	nop			;a9e8	00 	. 
	nop			;a9e9	00 	. 
	nop			;a9ea	00 	. 
	nop			;a9eb	00 	. 
	nop			;a9ec	00 	. 
	nop			;a9ed	00 	. 
	nop			;a9ee	00 	. 
	nop			;a9ef	00 	. 
	nop			;a9f0	00 	. 
	nop			;a9f1	00 	. 
	nop			;a9f2	00 	. 
	nop			;a9f3	00 	. 
	nop			;a9f4	00 	. 
	nop			;a9f5	00 	. 
	nop			;a9f6	00 	. 
	nop			;a9f7	00 	. 
	nop			;a9f8	00 	. 
	nop			;a9f9	00 	. 
	nop			;a9fa	00 	. 
	nop			;a9fb	00 	. 
	nop			;a9fc	00 	. 
	nop			;a9fd	00 	. 
	nop			;a9fe	00 	. 
	nop			;a9ff	00 	. 
	nop			;aa00	00 	. 
	nop			;aa01	00 	. 
	nop			;aa02	00 	. 
	nop			;aa03	00 	. 
	nop			;aa04	00 	. 
	nop			;aa05	00 	. 
	nop			;aa06	00 	. 
	nop			;aa07	00 	. 
	nop			;aa08	00 	. 
	nop			;aa09	00 	. 
	nop			;aa0a	00 	. 
	nop			;aa0b	00 	. 
	nop			;aa0c	00 	. 
	nop			;aa0d	00 	. 
	nop			;aa0e	00 	. 
	nop			;aa0f	00 	. 
	nop			;aa10	00 	. 
	nop			;aa11	00 	. 
	nop			;aa12	00 	. 
	nop			;aa13	00 	. 
	nop			;aa14	00 	. 
	nop			;aa15	00 	. 
	nop			;aa16	00 	. 
	nop			;aa17	00 	. 
	nop			;aa18	00 	. 
	nop			;aa19	00 	. 
	nop			;aa1a	00 	. 
	nop			;aa1b	00 	. 
	nop			;aa1c	00 	. 
	nop			;aa1d	00 	. 
	nop			;aa1e	00 	. 
	nop			;aa1f	00 	. 
	nop			;aa20	00 	. 
	nop			;aa21	00 	. 
	nop			;aa22	00 	. 
	nop			;aa23	00 	. 
	nop			;aa24	00 	. 
	nop			;aa25	00 	. 
	nop			;aa26	00 	. 
	nop			;aa27	00 	. 
	nop			;aa28	00 	. 
	nop			;aa29	00 	. 
	nop			;aa2a	00 	. 
	nop			;aa2b	00 	. 
	nop			;aa2c	00 	. 
	nop			;aa2d	00 	. 
	nop			;aa2e	00 	. 
	nop			;aa2f	00 	. 
	nop			;aa30	00 	. 
	nop			;aa31	00 	. 
	nop			;aa32	00 	. 
	nop			;aa33	00 	. 
	nop			;aa34	00 	. 
	nop			;aa35	00 	. 
	nop			;aa36	00 	. 
	nop			;aa37	00 	. 
	nop			;aa38	00 	. 
	nop			;aa39	00 	. 
	nop			;aa3a	00 	. 
	nop			;aa3b	00 	. 
	nop			;aa3c	00 	. 
	nop			;aa3d	00 	. 
	nop			;aa3e	00 	. 
	nop			;aa3f	00 	. 
	nop			;aa40	00 	. 
	nop			;aa41	00 	. 
	nop			;aa42	00 	. 
	nop			;aa43	00 	. 
	nop			;aa44	00 	. 
	nop			;aa45	00 	. 
	nop			;aa46	00 	. 
	nop			;aa47	00 	. 
	nop			;aa48	00 	. 
	nop			;aa49	00 	. 
	nop			;aa4a	00 	. 
	nop			;aa4b	00 	. 
	nop			;aa4c	00 	. 
	nop			;aa4d	00 	. 
	nop			;aa4e	00 	. 
	nop			;aa4f	00 	. 
	nop			;aa50	00 	. 
	nop			;aa51	00 	. 
	nop			;aa52	00 	. 
	nop			;aa53	00 	. 
	nop			;aa54	00 	. 
	nop			;aa55	00 	. 
	nop			;aa56	00 	. 
	nop			;aa57	00 	. 
	nop			;aa58	00 	. 
	nop			;aa59	00 	. 
	nop			;aa5a	00 	. 
	nop			;aa5b	00 	. 
	nop			;aa5c	00 	. 
	nop			;aa5d	00 	. 
	nop			;aa5e	00 	. 
	nop			;aa5f	00 	. 
	nop			;aa60	00 	. 
	nop			;aa61	00 	. 
	nop			;aa62	00 	. 
	nop			;aa63	00 	. 
	nop			;aa64	00 	. 
	nop			;aa65	00 	. 
	nop			;aa66	00 	. 
	nop			;aa67	00 	. 
laa68h:
	nop			;aa68	00 	. 
	nop			;aa69	00 	. 
	nop			;aa6a	00 	. 
	nop			;aa6b	00 	. 
	nop			;aa6c	00 	. 
	nop			;aa6d	00 	. 
	nop			;aa6e	00 	. 
	nop			;aa6f	00 	. 
	nop			;aa70	00 	. 
	nop			;aa71	00 	. 
	nop			;aa72	00 	. 
	nop			;aa73	00 	. 
	nop			;aa74	00 	. 
	nop			;aa75	00 	. 
	nop			;aa76	00 	. 
	nop			;aa77	00 	. 
	nop			;aa78	00 	. 
	nop			;aa79	00 	. 
	nop			;aa7a	00 	. 
	nop			;aa7b	00 	. 
	nop			;aa7c	00 	. 
	nop			;aa7d	00 	. 
	nop			;aa7e	00 	. 
	nop			;aa7f	00 	. 
	nop			;aa80	00 	. 
	nop			;aa81	00 	. 
	nop			;aa82	00 	. 
	nop			;aa83	00 	. 
	nop			;aa84	00 	. 
	nop			;aa85	00 	. 
	nop			;aa86	00 	. 
	nop			;aa87	00 	. 
	nop			;aa88	00 	. 
	nop			;aa89	00 	. 
	nop			;aa8a	00 	. 
	nop			;aa8b	00 	. 
	nop			;aa8c	00 	. 
	nop			;aa8d	00 	. 
	nop			;aa8e	00 	. 
	nop			;aa8f	00 	. 
	nop			;aa90	00 	. 
	nop			;aa91	00 	. 
	nop			;aa92	00 	. 
	nop			;aa93	00 	. 
	nop			;aa94	00 	. 
	nop			;aa95	00 	. 
	nop			;aa96	00 	. 
	nop			;aa97	00 	. 
	nop			;aa98	00 	. 
	nop			;aa99	00 	. 
	nop			;aa9a	00 	. 
	nop			;aa9b	00 	. 
	nop			;aa9c	00 	. 
	nop			;aa9d	00 	. 
	nop			;aa9e	00 	. 
	nop			;aa9f	00 	. 
	nop			;aaa0	00 	. 
	nop			;aaa1	00 	. 
	nop			;aaa2	00 	. 
	nop			;aaa3	00 	. 
	nop			;aaa4	00 	. 
	nop			;aaa5	00 	. 
	nop			;aaa6	00 	. 
	nop			;aaa7	00 	. 
	nop			;aaa8	00 	. 
	nop			;aaa9	00 	. 
	nop			;aaaa	00 	. 
	nop			;aaab	00 	. 
	nop			;aaac	00 	. 
	nop			;aaad	00 	. 
	nop			;aaae	00 	. 
	nop			;aaaf	00 	. 
	nop			;aab0	00 	. 
	nop			;aab1	00 	. 
	nop			;aab2	00 	. 
	nop			;aab3	00 	. 
	nop			;aab4	00 	. 
	nop			;aab5	00 	. 
	nop			;aab6	00 	. 
	nop			;aab7	00 	. 
	nop			;aab8	00 	. 
	nop			;aab9	00 	. 
	nop			;aaba	00 	. 
	nop			;aabb	00 	. 
	nop			;aabc	00 	. 
	nop			;aabd	00 	. 
	nop			;aabe	00 	. 
	nop			;aabf	00 	. 
	nop			;aac0	00 	. 
	nop			;aac1	00 	. 
	nop			;aac2	00 	. 
	nop			;aac3	00 	. 
	nop			;aac4	00 	. 
	nop			;aac5	00 	. 
	nop			;aac6	00 	. 
	nop			;aac7	00 	. 
	nop			;aac8	00 	. 
	nop			;aac9	00 	. 
	nop			;aaca	00 	. 
	nop			;aacb	00 	. 
	nop			;aacc	00 	. 
	nop			;aacd	00 	. 
	nop			;aace	00 	. 
	nop			;aacf	00 	. 
	nop			;aad0	00 	. 
	nop			;aad1	00 	. 
	nop			;aad2	00 	. 
	nop			;aad3	00 	. 
	nop			;aad4	00 	. 
	nop			;aad5	00 	. 
	nop			;aad6	00 	. 
	nop			;aad7	00 	. 
	nop			;aad8	00 	. 
	nop			;aad9	00 	. 
	nop			;aada	00 	. 
	nop			;aadb	00 	. 
	nop			;aadc	00 	. 
	nop			;aadd	00 	. 
	nop			;aade	00 	. 
	nop			;aadf	00 	. 
	nop			;aae0	00 	. 
	nop			;aae1	00 	. 
	nop			;aae2	00 	. 
	nop			;aae3	00 	. 
	nop			;aae4	00 	. 
	nop			;aae5	00 	. 
	nop			;aae6	00 	. 
	nop			;aae7	00 	. 
	nop			;aae8	00 	. 
	nop			;aae9	00 	. 
	nop			;aaea	00 	. 
	nop			;aaeb	00 	. 
	nop			;aaec	00 	. 
	nop			;aaed	00 	. 
	nop			;aaee	00 	. 
	nop			;aaef	00 	. 
	nop			;aaf0	00 	. 
	nop			;aaf1	00 	. 
	nop			;aaf2	00 	. 
	nop			;aaf3	00 	. 
	nop			;aaf4	00 	. 
	nop			;aaf5	00 	. 
	nop			;aaf6	00 	. 
	nop			;aaf7	00 	. 
	nop			;aaf8	00 	. 
	nop			;aaf9	00 	. 
	nop			;aafa	00 	. 
	nop			;aafb	00 	. 
	nop			;aafc	00 	. 
	nop			;aafd	00 	. 
	nop			;aafe	00 	. 
	nop			;aaff	00 	. 
	nop			;ab00	00 	. 
	nop			;ab01	00 	. 
	nop			;ab02	00 	. 
	nop			;ab03	00 	. 
	nop			;ab04	00 	. 
	nop			;ab05	00 	. 
	nop			;ab06	00 	. 
	nop			;ab07	00 	. 
	nop			;ab08	00 	. 
	nop			;ab09	00 	. 
	nop			;ab0a	00 	. 
	nop			;ab0b	00 	. 
	nop			;ab0c	00 	. 
	nop			;ab0d	00 	. 
	nop			;ab0e	00 	. 
	nop			;ab0f	00 	. 
	nop			;ab10	00 	. 
	nop			;ab11	00 	. 
	nop			;ab12	00 	. 
	nop			;ab13	00 	. 
	nop			;ab14	00 	. 
	nop			;ab15	00 	. 
	nop			;ab16	00 	. 
	nop			;ab17	00 	. 
	nop			;ab18	00 	. 
	nop			;ab19	00 	. 
	nop			;ab1a	00 	. 
	nop			;ab1b	00 	. 
	nop			;ab1c	00 	. 
	nop			;ab1d	00 	. 
	nop			;ab1e	00 	. 
	nop			;ab1f	00 	. 
	nop			;ab20	00 	. 
	nop			;ab21	00 	. 
	nop			;ab22	00 	. 
	nop			;ab23	00 	. 
	nop			;ab24	00 	. 
	nop			;ab25	00 	. 
	nop			;ab26	00 	. 
	nop			;ab27	00 	. 
	nop			;ab28	00 	. 
	nop			;ab29	00 	. 
	nop			;ab2a	00 	. 
	nop			;ab2b	00 	. 
	nop			;ab2c	00 	. 
	nop			;ab2d	00 	. 
	nop			;ab2e	00 	. 
	nop			;ab2f	00 	. 
	nop			;ab30	00 	. 
	nop			;ab31	00 	. 
	nop			;ab32	00 	. 
	nop			;ab33	00 	. 
	nop			;ab34	00 	. 
	nop			;ab35	00 	. 
	nop			;ab36	00 	. 
	nop			;ab37	00 	. 
	nop			;ab38	00 	. 
	nop			;ab39	00 	. 
	nop			;ab3a	00 	. 
	nop			;ab3b	00 	. 
	nop			;ab3c	00 	. 
	nop			;ab3d	00 	. 
	nop			;ab3e	00 	. 
	nop			;ab3f	00 	. 
	nop			;ab40	00 	. 
	nop			;ab41	00 	. 
	nop			;ab42	00 	. 
	nop			;ab43	00 	. 
	nop			;ab44	00 	. 
	nop			;ab45	00 	. 
	nop			;ab46	00 	. 
	nop			;ab47	00 	. 
	nop			;ab48	00 	. 
	nop			;ab49	00 	. 
	nop			;ab4a	00 	. 
	nop			;ab4b	00 	. 
	nop			;ab4c	00 	. 
	nop			;ab4d	00 	. 
	nop			;ab4e	00 	. 
	nop			;ab4f	00 	. 
	nop			;ab50	00 	. 
	nop			;ab51	00 	. 
	nop			;ab52	00 	. 
	nop			;ab53	00 	. 
	nop			;ab54	00 	. 
	nop			;ab55	00 	. 
	nop			;ab56	00 	. 
	nop			;ab57	00 	. 
	nop			;ab58	00 	. 
	nop			;ab59	00 	. 
	nop			;ab5a	00 	. 
	nop			;ab5b	00 	. 
	nop			;ab5c	00 	. 
	nop			;ab5d	00 	. 
	nop			;ab5e	00 	. 
	nop			;ab5f	00 	. 
	nop			;ab60	00 	. 
	nop			;ab61	00 	. 
	nop			;ab62	00 	. 
	nop			;ab63	00 	. 
	nop			;ab64	00 	. 
	nop			;ab65	00 	. 
	nop			;ab66	00 	. 
	nop			;ab67	00 	. 
	nop			;ab68	00 	. 
	nop			;ab69	00 	. 
	nop			;ab6a	00 	. 
	nop			;ab6b	00 	. 
	nop			;ab6c	00 	. 
	nop			;ab6d	00 	. 
	nop			;ab6e	00 	. 
	nop			;ab6f	00 	. 
	nop			;ab70	00 	. 
	nop			;ab71	00 	. 
	nop			;ab72	00 	. 
	nop			;ab73	00 	. 
	nop			;ab74	00 	. 
	nop			;ab75	00 	. 
	nop			;ab76	00 	. 
	nop			;ab77	00 	. 
	nop			;ab78	00 	. 
	nop			;ab79	00 	. 
	nop			;ab7a	00 	. 
	nop			;ab7b	00 	. 
	nop			;ab7c	00 	. 
	nop			;ab7d	00 	. 
	nop			;ab7e	00 	. 
	nop			;ab7f	00 	. 
	nop			;ab80	00 	. 
	nop			;ab81	00 	. 
	nop			;ab82	00 	. 
	nop			;ab83	00 	. 
	nop			;ab84	00 	. 
	nop			;ab85	00 	. 
	nop			;ab86	00 	. 
	nop			;ab87	00 	. 
lab88h:
	nop			;ab88	00 	. 
	nop			;ab89	00 	. 
	nop			;ab8a	00 	. 
	nop			;ab8b	00 	. 
	nop			;ab8c	00 	. 
	nop			;ab8d	00 	. 
	nop			;ab8e	00 	. 
	nop			;ab8f	00 	. 
	nop			;ab90	00 	. 
	nop			;ab91	00 	. 
	nop			;ab92	00 	. 
	nop			;ab93	00 	. 
	nop			;ab94	00 	. 
	nop			;ab95	00 	. 
	nop			;ab96	00 	. 
	nop			;ab97	00 	. 
	nop			;ab98	00 	. 
	nop			;ab99	00 	. 
	nop			;ab9a	00 	. 
	nop			;ab9b	00 	. 
	nop			;ab9c	00 	. 
	nop			;ab9d	00 	. 
	nop			;ab9e	00 	. 
	nop			;ab9f	00 	. 
	nop			;aba0	00 	. 
	nop			;aba1	00 	. 
	nop			;aba2	00 	. 
	nop			;aba3	00 	. 
	nop			;aba4	00 	. 
	nop			;aba5	00 	. 
	nop			;aba6	00 	. 
	nop			;aba7	00 	. 
	nop			;aba8	00 	. 
	nop			;aba9	00 	. 
	nop			;abaa	00 	. 
	nop			;abab	00 	. 
	nop			;abac	00 	. 
	nop			;abad	00 	. 
	nop			;abae	00 	. 
	nop			;abaf	00 	. 
	nop			;abb0	00 	. 
	nop			;abb1	00 	. 
	nop			;abb2	00 	. 
	nop			;abb3	00 	. 
	nop			;abb4	00 	. 
	nop			;abb5	00 	. 
	nop			;abb6	00 	. 
	nop			;abb7	00 	. 
	nop			;abb8	00 	. 
	nop			;abb9	00 	. 
	nop			;abba	00 	. 
	nop			;abbb	00 	. 
	nop			;abbc	00 	. 
	nop			;abbd	00 	. 
	nop			;abbe	00 	. 
	nop			;abbf	00 	. 
	nop			;abc0	00 	. 
	nop			;abc1	00 	. 
	nop			;abc2	00 	. 
	nop			;abc3	00 	. 
	nop			;abc4	00 	. 
	nop			;abc5	00 	. 
	nop			;abc6	00 	. 
	nop			;abc7	00 	. 
	nop			;abc8	00 	. 
	nop			;abc9	00 	. 
	nop			;abca	00 	. 
	nop			;abcb	00 	. 
	nop			;abcc	00 	. 
	nop			;abcd	00 	. 
	nop			;abce	00 	. 
	nop			;abcf	00 	. 
	nop			;abd0	00 	. 
	nop			;abd1	00 	. 
	nop			;abd2	00 	. 
	nop			;abd3	00 	. 
	nop			;abd4	00 	. 
	nop			;abd5	00 	. 
	nop			;abd6	00 	. 
	nop			;abd7	00 	. 
	nop			;abd8	00 	. 
	nop			;abd9	00 	. 
	nop			;abda	00 	. 
	nop			;abdb	00 	. 
	nop			;abdc	00 	. 
	nop			;abdd	00 	. 
	nop			;abde	00 	. 
	nop			;abdf	00 	. 
