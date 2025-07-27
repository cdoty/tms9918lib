include "../../../System/SystemDefines.inc"

ext	flickerModeEnabled
ext	flickerModeStartSprite

dseg

frameCount:	public	frameCount
	ds	2

randSeed:
	ds	2

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	2

spriteMagnificationEnabled:	public	spriteMagnificationEnabled
	ds	2

cseg

initRandSeed_: public initRandSeed_
    dect	r10
	mov		r11, *r10

	mov		@frameCount, r0
	ai		r0, $8000
	mov		@randSeed, r0

	mov		*r10+, r11
	
	rt

; Based on https://forums.atariage.com/topic/189117-restless-ii-game-released/page/2/#comment-3254708
rand_:	public rand_
    dect	r10
	mov		r11, *r10

	mov		@randSeed, r0	; Get random seed
	
	srl		r0, 1			; Shift down
	jnc		rand1			; Jump if 1 not shifted out

	xor		@randMask, r0	; XOR the top half

rand1:
	mov		r0, @randSeed	; Update random seem
	swpb	r0				; Return value in high byte

	mov		*r10+, r11
	
	rt

randMask:
	dw		$B400	; 16 bit random mask
	
expandedRAMAvailable_:	public expandedRAMAvailable_
    dect	r10
	mov		r11, *r10

	mov		@expandedRAMEnabled, r0	
	swpb	r0				; Return value in high byte

	mov		*r10+, r11
	
	rt

enableSpriteMagnification_:	public enableSpriteMagnification_
    dect	r10
	mov		r11, *r10

	swpb	r0
	mov		r0, @spriteMagnificationEnabled

	mov		*r10+, r11
	
	rt

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

setupLibrary:	public setupLibrary
    dect	r10
	mov		r11, *r10

	clr		r0
	mov		r0, @frameCount					; Clear frame count
	mov		r0, @expandedRAMEnabled			; Disable expanded RAM
	mov		r0, @spriteMagnificationEnabled	; Disable sprite magnification
	mov		r0, @flickerModeEnabled			; Disable flicker mode
	mov		r0, @flickerModeStartSprite		; Set flicker mode start sprite
	
	li		r0, $0080						; Set random seed
	mov		r0, @randSeed		
	
	mov		*r10+, r11
	
	rt
