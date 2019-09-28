if ?Investigate.asm == 0
Investigate.asm:


sub_b2e6h:
	push bc			;b2e6	c5 	. 
	push hl			;b2e7	e5 	. 
	cp 0fdh		;b2e8	fe fd 	. . 
	jr nz,lb2f0h		;b2ea	20 04 	  . 
	ld b,092h		;b2ec	06 92 	. . 
	jr lb308h		;b2ee	18 18 	. . 
lb2f0h:
	cp 0feh		;b2f0	fe fe 	. . 
	jr nz,lb2f8h		;b2f2	20 04 	  . 
	ld b,00bh		;b2f4	06 0b 	. . 
	jr lb308h		;b2f6	18 10 	. . 
lb2f8h:
	ld b,a			;b2f8	47 	G 
	ld hl,lb30ch		;b2f9	21 0c b3 	! . . 
lb2fch:
	ld a,(hl)			;b2fc	7e 	~ 
	cp 0ffh		;b2fd	fe ff 	. . 
	jr z,lb307h		;b2ff	28 06 	( . 
	inc hl			;b301	23 	# 
	cp b			;b302	b8 	. 
	jr z,lb308h		;b303	28 03 	( . 
	jr lb2fch		;b305	18 f5 	. . 
lb307h:
	or a			;b307	b7 	. 
lb308h:
	ld a,b			;b308	78 	x 
	pop hl			;b309	e1 	. 
	pop bc			;b30a	c1 	. 
	ret			;b30b	c9 	. 
	
lb30ch:
	rst 38h			;b30c	ff 	.


endif