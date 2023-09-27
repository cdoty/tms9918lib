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
	
	ld		(expandedRAMEnabled), a	; Clear expanded RAM enabled flag

	ld		hl, RAMStart
	ld		(hl), a
	
	ld		de, RAMStart + 1
	ld		bc,	RAMSize - 1			; Adjust the size for the loop
	
	ldir

	ret

isExpandedRAMEnabled_:	public isExpandedRAMEnabled_
	ld		a, (expandedRAMEnabled)

	ret
