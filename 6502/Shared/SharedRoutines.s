include "../../../System/SystemDefines.inc"

ext	ZPValue
ext	ZPDestination
ext	ZPCount
ext	flickerModeEnabled
ext	flickerModeStartSprite

dseg

frameCount:	public	frameCount
	ds	1

randSeed:
	ds	1

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	1

spriteMagnificationEnabled:	public spriteMagnificationEnabled
	ds	1

startNumericChar:	public startNumericChar
	ds	1

enableSpriteMagnification_@Param0:	public enableSpriteMagnification_@Param0
convertValueToAscii_@Param0:	public convertValueToAscii_@Param0
	ds	2

convertValueToAscii_@Param1:	public convertValueToAscii_@Param1
	ds	2

setStartNumericChar_@Param0:	public setStartNumericChar_@Param0
	ds	1

cseg

initRandSeed_: public initRandSeed_
	lda		frameCount
	adc		#$80
	sta		randSeed

	rts

; Based on http://www.6502.org/users/mycorner/6502/code/prng.html
rand_:	public rand_
	pha
	
	lda		randSeed

	asl		a
	bcc		noCarry

	eor		#$CF

noCarry:
	sta		randSeed

	pla

	rts

expandedRAMAvailable_:	public expandedRAMAvailable_
	ldy		expandedRAMEnabled
	
	rts

enableSpriteMagnification_:	public enableSpriteMagnification_
	lda		enableSpriteMagnification_@Param0
	sta		spriteMagnificationEnabled

	rts

setStartNumericChar_:	public setStartNumericChar_
	lda		setStartNumericChar_@Param0
	sta		startNumericChar

	rts

startupDelay:	public startupDelay
	ldx		#$FF		; Set the total number of bytes to clear
	ldy		#$FF
	
startupDelayLoop:
	dex	
	bne		startupDelayLoop
	
	dey	
	bne		startupDelayLoop

	rts

clearRam:	public clearRam
	lda		#LOW(RAMSize)
	sta		ZPCount

	lda		#HIGH(RAMSize)
	sta		ZPCount + 1

	lda		#LOW(RAMStart)
	sta		ZPDestination

	lda		#HIGH(RamStart)
	sta		ZPDestination + 1

	lda		#0
	ldy		#0

clearRamLoop:
	sta		(ZPDestination), y

	iny

	dec		ZPCount
	bne		clearRamLoop

	dec		ZPCount + 1
	bne		clearRamLoop

	rts

; Param0 - Value
; Param1 - Pointer to start of ASCII 5 digit score digits
; From https://beebwiki.mdfs.net/Number_output_in_6502_machine_code
convertValueToAscii_:	public convertValueToAscii_
	pha
	
	txa
	pha
	
	tya
	pha

	lda		convertValueToAscii_@Param0
	sta		ZPValue

	lda		convertValueToAscii_@Param0 + 1
	sta		ZPValue + 1

	lda		convertValueToAscii_@Param1
	sta		ZPDestination

	lda		convertValueToAscii_@Param1 + 1
	sta		ZPDestination + 1

	jsr		convertToAscii

	pla
	tay

	pla
	tax

	pla

	rts

convertToAscii:
	ldy		#8					; Set DigitValues offset

digit1:
	ldx		#$FF				; Start at -1
	sec

digit2:
	lda		ZPValue				; Subtract current power of 10
	sbc		DigitValues, y
	sta		ZPValue

	lda		ZPValue + 1
	sbc		DigitValues + 1, y
	sta		ZPValue + 1

	inx
	bcs		digit2				; Loop until < 0

	lda		ZPValue				; Subtract current power of 10
	adc		DigitValues, y
	sta		ZPValue

	lda		ZPValue + 1
	adc		DigitValues + 1, y
	sta		ZPValue + 1

	txa

decDigit:
	clc
	adc		startNumericChar

	ldx		#0
	sta		(ZPDestination, x)	; Store the current digit

	clc

	lda		ZPDestination		; Increment the address
	adc		#1
	sta		ZPDestination

	lda		ZPDestination + 1
	adc		#0
	sta		ZPDestination + 1

decNextDigit:
	dey							; Loop for next digit
	dey

	bpl		digit1

	rts

DigitValues:
	dw		1
	dw		10
	dw		100
	dw		1000
	dw		10000

setupLibrary:	public setupLibrary
	lda		#0
	sta		frameCount;					; Reset frame count
	sta		expandedRAMEnabled			; Disable expanded RAM
	sta		spriteMagnificationEnabled	; Disable sprite magnification
	sta		flickerModeEnabled			; Disable flicker mode
	sta		flickerModeStartSprite		; Set flicker mode start sprite

	lda		#$80						; Set default random seed
	sta		randSeed

	lda		#'0'
	sta		startNumericChar
	
	rts
