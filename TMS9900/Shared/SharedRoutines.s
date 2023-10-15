include "../../../System/SystemDefines.inc"

dseg

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	2

cseg

startupDelay:	public startupDelay
    dect	r10
	mov		r11, *r10

	li		r2, 0
	
delayLoop:
	dec		r2
	jne		delayLoop
	
    mov		*r10+, r11
	
	rt
	
clearRam:	public clearRam
    dect	r10
	mov		r11, *r10

	; Clear the first byte of RAM
	li		r0, RAMStart
	li		r1, RAMStart + 2
	li		r2, RAMSize / 2 - 1

	clr		@RAMStart

clearRamLoop:
   	mov		*r0+, *r1+

	dec		r2
	jne		clearRamLoop
		
	mov		*r10+, r11
	
	rt
