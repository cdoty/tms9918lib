include "../../../System/SystemDefines.inc"

ext	flickerModeEnabled
ext	flickerModeStartSprite

dseg

frameCount:	public	frameCount
	ds	1

randSeed:
	ds	2

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	1

spriteMagnificationEnabled:	public spriteMagnificationEnabled
	ds	1

startNumericChar:	public startNumericChar
	ds	1

cseg

initRandSeed_: public initRandSeed_
	push	af

    ld		a, r
    ld		(randSeed), a
    
	ld		a, r
    ld		(randSeed + 1), a

	pop		af

	ret

rand_:	public rand_
	push	hl

	ld		b, 8
	ld 		hl, (randSeed)

__rand_loop:
	add		hl, hl
	jp		nc, __no_eor

	ld		a, l
	xor		$2D
	ld		l, a

__no_eor:
	djnz	__rand_loop
	ld		(randSeed), hl

	pop		hl

	ret

expandedRAMAvailable_:	public expandedRAMAvailable_
	ld		a, (expandedRAMEnabled)
	
	ret

enableSpriteMagnification_:	public enableSpriteMagnification_
	ld		(spriteMagnificationEnabled), a

	ret

setStartNumericChar_:	public setStartNumericChar_
	dec		a
	ld		(startNumericChar), a

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

convertValueToAscii_:	public convertValueToAscii_
	push	bc
	push	de
	push	hl

	call	convertToAscii

	pop		hl
	pop		de
	pop		bc

	ret

; HL - Number
; DE - Pointer to string to place 5 digit characters
; Based on https://map.grauw.nl/sources/external/z80bits.html#5.1
convertToAscii:	
	ld		bc, -10000
    call	ConvertDigit
	
	ld		bc, -1000
	call	ConvertDigit
	
	ld		bc, -100
	call	ConvertDigit
	
	ld		c, -10
	call	ConvertDigit
	
	ld		c, b

ConvertDigit:
	ld 		a, (startNumericChar)

DivideResult:
	inc		a
	add		hl, bc

	jr		c, DivideResult

	sbc		hl, bc
	ld		(de), a
	inc		de

	ret

setupLibrary:	public setupLibrary
	xor		a	
	ld		(frameCount), a					; Reset frame count
	ld		(expandedRAMEnabled), a			; Disable expanded RAM
	ld		(spriteMagnificationEnabled), a	; Disable sprite magnification
	ld		(flickerModeEnabled), a			; Disable flicker mode
	ld		(flickerModeStartSprite), a		; Set flicker mode start sprite
	ld		(randSeed), a					; Set default random seed to 0x8000
	
	ld		a, $80
	ld		(randSeed + 1), a
	
	ld		a, '0' - 1						; Set the default numeric char
	ld		(startNumericChar), a
	
	ret
