include "../../Game/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	nmiCount
ext	lastNMICount
ext	writeVDPReg
ext	vblankHandler
ext	keyboardHandler

cseg

setMode2:	public setMode2
	ld		b, $02						; Disable external VDP interrupt, set M2 for Graphics mode 2
	ld		c, 0
	call	writeVDPReg

	ld		a, SpriteSize
	or		$80
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ld		b, Screen1VRAM / $400		; Set Name Table location.
	ld		c, 2
	call	writeVDPReg

	ld		b, Color1VRAM / $40 OR $7F	; Set Color Table location.
	ld		c, 3
	call	writeVDPReg

	ld		b, Tile1VRAM / $800 OR 3	; Set Pattern Table location.
	ld		c, 4
	call	writeVDPReg

	ld		b, SpriteAttributes / $80	; Set Sprite Attribute Table location.
	ld		c, 5
	call	writeVDPReg

	ld		b, SpritePattern / $800		; Set Sprite Pattern Table location.
	ld		c, 6
	call	writeVDPReg

	ld		b, $00						; Set background color to black
	ld		c, 7
	call	writeVDPReg

	ret
	
; Turn on screen
; void turnOnScreen();
turnOnScreen_: public turnOnScreen_
	ld		a, SpriteSize
	or		$E0
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
	ld		a, SpriteSize
	or		$80
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret

enableIRQ_:	public enableIRQ_
	; Clear nmi counts
	xor		a
	ld		(nmiCount), a
	ld		(lastNMICount), a

	ei

	ret

disableIRQ_:	public disableIRQ_
	di

	ret

; void waitForVBlank();
waitForVBlank_:	public waitForVBlank_
	ld		a, (lastNMICount)
	ld		b, a

waitVBlankLoop:
	ld		a, (nmiCount)
	cp		b
	
	jr		z, waitVBlankLoop
	
	ld		(lastNMICount), a

	ret

enableDisplay:	public enableDisplay
	in		a, (ControlPort)
	or		2
	out		(ControlPort), a
	
	ret

setupInterrupts:	public setupInterrupts
	im		2

	ld		a, $FF			; Set interrupt table high byte to FFh
	ld		I, a

	; Skip setting hcca receive and send handlers
	ld		hl, keyboardHandler
	ld		(KeyboardInterrupt), hl

	ld		hl, vblankHandler
	ld		(VBlankInterrupt), hl

	; Skip all of the option handlers

	ld		a, 7			; Select register 7
	out		(PSGRegisterPort), a
	
	ld		a, $7F			; Enable port A for output and B for input port
	out		(PSGWritePort), a

	ret

enableInterrupts:	public enableInterrupts
	di
	
	ld		a, 14			; Select register 14
	out		(PSGRegisterPort), a
	
	ld		a, $30			; Enable keyboard and vblank interrupt
	out		(PSGWritePort), a	 

	ei

	ret

disableInterrupts:
	di
	
	ld		a, 14			; Select register 14
	out		(PSGRegisterPort), a
	
	ld		a, $00			; Disable all interrupts.
	out		(PSGWritePort), a

	ei

	ret
