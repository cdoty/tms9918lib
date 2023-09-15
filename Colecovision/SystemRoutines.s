include "../../Platform/Defines.inc"

ext	nmiCount
ext	writeVDPReg

setMode2:	public setMode2
	ld		b, $02						; Disable external VDP interrupt, set M2 for Graphics mode 2
	ld		c, 0
	call	writeVDPReg

	ld		b, $A2						; Enable 16K VRAM, Screen, NMI interrupt, and 16x16 sprites
	ld		c, 1
	call	writeVDPReg

	ld		b, Screen1VRAM / $400		; Set Name Table location.
	ld		c, 2
	call	writeVDPReg

	ld		b, Color1VRAM / $40	+ $7F	; Set Color Table location.
	ld		c, 3
	call	writeVDPReg

	ld		b, Tile1VRAM / $800 + 3		; Set Pattern Table location.
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
	ld		b, $E2		; Enable 16K VRAM, Screen, NMI interrupt, and 16x16 sprites
	ld		c, 1
	call	writeVDPReg

	ret
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
	ld		b, $A2		; Enable 16K VRAM, NMI interrupt, and 16x16 sprites. Disable Screen
	ld		c, 1
	call	writeVDPReg

	ret

; void clearTimer();
clearTimer_:	public clearTimer_
	xor	a
	ld	(nmiCount), a

	ret
	
enableIRQ_:	public enableIRQ_
	ei

	ret

disableIRQ_:	public disableIRQ_
	di

	ret

; void waitForTimerOrButtonPress(byte _delay, byte _button);
; A: _delay
; E: _button
waitForTimerOrButtonPress_:	public waitForTimerOrButtonPress_
	ld	b, a

waitForTimerOrButtonPress:
	ld	a, (nmiCount)
	cp	b
	
	jr	nz, waitForTimerOrButtonPress
	
	ret

resetSound:	public resetSound
	call	1FD6h		; Disable sound
	
	ret
