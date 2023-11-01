include "../../Game/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	writeVDPReg
ext	updateSpriteAttributes
ext	updateSpriteAttributeTable

cseg

setMode2:	public setMode2
    dect	r10
	mov		r11, *r10

	li		r1, $0280										; Disable external VDP interrupt, set M2 for Graphics mode 2
	bl		@writeVDPReg

	li		r1, SpriteSize SHL 8
	ori		r1, $A081										; Enable 16K VRAM, Screen, NMI interrupt, and 8x8 sprites
	bl		@writeVDPReg

	li		r1, (Screen1VRAM / $400) SHL 8 OR $82			; Set Name Table location to 3800h, in VRAM
	bl		@writeVDPReg

	li		r1, ((Color1VRAM / $40) OR $7F) SHL 8 OR $83	; Set Color Table location to 2000h, in VRAM
	bl		@writeVDPReg

	li		r1, ((Tile1VRAM / $800) OR 3) SHL 8 OR $84		; Set Pattern Table location to 0000h, in VRAM
	bl		@writeVDPReg

	li		r1, (SpriteAttributes / $80) SHL 8 OR $85		; Set Sprite Attribute Table location to 3800h, in VRAM
	bl		@writeVDPReg

	li		r1, (SpritePattern / $800) SHL 8 OR $86			; Set Sprite Pattern Table location to 1800h, in VRAM
	bl		@writeVDPReg

	li		r1, $0087										; Set background color to black
	bl		@writeVDPReg

    mov		*r10+, r11
	
	rt
	
; Turn on screen
; void turnOnScreen();
turnOnScreen_: public turnOnScreen_
    dect	r10
	mov		r11, *r10

	li		r1, SpriteSize SHL 8

	ori		r1, $E081
	bl		@writeVDPReg

    mov		*r10+, r11
	
	rt
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
    dect	r10
	mov		r11, *r10

	li		r1, SpriteSize SHL 8

	ori		r1, $A081
	bl		@writeVDPReg

    mov		*r10+, r11
	
	rt
	
enableIRQ_:	public enableIRQ_
    dect	r10
	mov		r11, *r10

;	limi	2			; Enable interrupts. Commented out on the TI-99/4a

    mov		*r10+, r11
	
	rt
	
disableIRQ_:	public disableIRQ_
    dect	r10
	mov		r11, *r10

	limi	0			; Disable interrupts

    mov		*r10+, r11
	
	rt
	
; void waitForVBlank();
waitForVBlank_:	public waitForVBlank_
    dect	r10
	mov		r11, *r10

	; Disable interrupts
	limi	0

waitVBlankLoop:
	clr		r0
	movb	@VDPStatus, r0				; Read VDP status
	andi	r0, $8000

	ci   	r0, $8000					; Check interrupt flag
	jne		waitVBlankLoop

	mov		@updateSpriteAttributes, r0

	ci		r0, 1
	jne		exitWaitForVBlank

	bl		@updateSpriteAttributeTable

exitWaitForVBlank:
    mov		*r10+, r11
	
	rt
