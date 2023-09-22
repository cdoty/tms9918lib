include "../../Game/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	nmiCount
ext	lastNMICount
ext	writeVDPReg
ext	nmiHandler

cseg

setMode2:	public setMode2
	ld		b, $02						; Disable external VDP interrupt, set M2 for Graphics mode 2
	ld		c, 0
	call	writeVDPReg

	ld		a, SpriteSize
	or		$A0
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
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

	ld      a, (ROMVideoFormat)			; Use a difference in ROM to determine if JAP or EUR machine. Based on code from Charlie Robson
    and     1							; Bit one is used to determine if PAL or NTSC.
	
	ld		b, a						; Set background color to black
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
	or		$A0
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

setupInterrupt:	public setupInterrupt
	ld		a, 1				; Set Z80CTC channel 1 to control mode
	out 	(CTCChannel1), a
	
	ld		hl, nmiHandler		; Load VBI handler address
	ld		(VBIAddress), hl	; Store in Z80CTC channel 3 interrupt address.

	ret
