include "../../../System/SystemDefines.inc"

dseg

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	1

cseg

startupDelay:	public startupDelay
	ld		bc, 0
	
delayLoop:
	dec		bc
	
	ld		a, b
	or		c
	
	jr		nz, delayLoop
	
	ret
	
clearRam:	public clearRam
	xor		a
	
	ld		hl, RAMStart
	ld		(hl), a
	
	ld		de, RAMStart + 1
	ld		bc,	RAMSize - 1		; Adjust the size for the loop
	
	ldir

	ret
