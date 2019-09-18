
WaitForKey:
	push bc	
	push de	
	push hl	
	ld a,005h
	rst 8	
	ld a,d
	pop hl	
	pop de	
	pop bc	
	jr nc,WaitForKey
	ret
	jr z,WaitForKey