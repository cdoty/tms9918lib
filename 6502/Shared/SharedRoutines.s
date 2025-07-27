include "../../../System/SystemDefines.inc"

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

zseg

ZPValue:
	ds	2
ZPDestination:
	ds	2

ZPCount:
	ds	2

mul8_num1:
	ds	1

mul8_num2:
	ds	1

mul8_result:
	ds	2
	
cseg

initRandSeed_: public initRandSeed_
	lda		frameCount
	adc		#$80
	sta		randSeed

	rts

; Based on https://cocotownretro.wordpress.com/2025/07/20/a-retro-random-number-generator-written-by-a-modern-ai/
rand_:	public rand_
	lda		randSeed

	cmp		#0
	beq		randEOR

	asl		a
	beq		randSet
	bcc		randSet

randEOR:
	eor		#$1D

randSet:
	sta		randSeed

	rts

; A 	- The maximum value that can be generated. This allows values from 0 to 255.
; Ret A - Generated value
randLimit_:	public randLimit_
	cmp		#255			; Use the original rand if the limit is 255
	beq		rand_

	clc
	adc		#1

	sta		mul8_num1		; Store limit value + 1 in mul8_num1 for multiplication

	jsr		rand_
	sta		mul8_num2		; Store limit value + 1 in mul8_num2 for multiplication

	jsr		mul8			; Multiply mul8_num1 and mul8_num2. This pushes the limited value into the high byte of mul8_result

	lda		mul8_result + 1	; Return limited value in A

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

; Multiply two 8 bit values
; mul8_num1 - Number 1
; mul8_num2 - Number 2
; mul8_result - 16 bit result
; https://www.llx.com/Neil/a2/mult.html
mul8:
	lda		#0			; Initialize result to 0
	ldx		#8			; There are 8 bits in mul8_num2

mul8Loop1:
	lsr		mul8_num2	; Get low bit of NUM2
	
	bcc		mul8Loop2	; 0 or 1?
	
	clc					; If 1, add NUM1
	
	adc		mul8_num1

mul8Loop2:
	ror		a			; "Stairstep" shift (catching carry from add)
	ror		mul8_result

	dex
	bne		mul8Loop1

	sta		mul8_result + 1
		
	rts

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
