include "../../../System/SystemDefines.inc"

dseg

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	1

spriteMagnification:	public spriteMagnification
	ds	1

cseg

expandedRAMAvailable_:	public expandedRAMAvailable_
	ld		a, (expandedRAMEnabled)
	
	ret

enableSpriteMagnification_:	public enableSpriteMagnification_
	ld		a, 1
	ld		(spriteMagnification), a

	ret

disableSpriteMagnification_:	public disableSpriteMagnification_
	xor		a
	ld		(spriteMagnification), a

	ret

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
	ld		(expandedRAMEnabled), a
	
	ld		hl, RAMStart
	ld		(hl), a
	
	ld		de, RAMStart + 1
	ld		bc,	RAMSize - 1		; Adjust the size for the loop
	
	ldir

	ret

setupLibrary:	public setupLibrary
	xor		a	
	ld		(expandedRAMEnabled), a
	ld		(spriteMagnification), a
	
	ret
