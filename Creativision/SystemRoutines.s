include "../../Game/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	nmiCount
ext	lastNMICount
ext	frameCount
ext	writeVDPReg
ext	spriteMagnificationEnabled
ext	ZPParam1
ext	ZPParam2

cseg

setMode2:	public setMode2
	lda		#$02						; Disable external VDP interrupt, set M2 for Graphics mode 2
	sta		ZPParam1
	lda		#0
	sta		ZPParam2
	jsr		writeVDPReg

	lda		spriteMagnificationEnabled
	ora		#SpriteSize					; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ora		#$A0
	sta		ZPParam1	
	lda		#1
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#Screen1VRAM / $400			; Set Name Table location.
	sta		ZPParam1
	lda		#2
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#(Color1VRAM / $40) OR $7F	; Set Color Table location.
	sta		ZPParam1
	lda		#3
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#(Tile1VRAM / $800) OR 3	; Set Pattern Table location.
	sta		ZPParam1
	lda		#4
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#SpriteAttributes / $80		; Set Sprite Attribute Table location.
	sta		ZPParam1
	lda		#5
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#SpritePattern / $800		; Set Sprite Pattern Table location.
	sta		ZPParam1
	lda		#6
	sta		ZPParam2
	jsr		writeVDPReg

	lda		#$00						; Set background color to black
	sta		ZPParam1
	lda		#7
	sta		ZPParam2
	jsr		writeVDPReg
	
	rts
	
; Turn on screen
; void turnOnScreen();
turnOnScreen_: public turnOnScreen_
	lda		spriteMagnificationEnabled
	ora		#SpriteSize					; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ora		#$E0
	sta		ZPParam1
	
	lda		#$01
	sta		ZPParam2
	
	jsr		writeVDPReg

	rts
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
	lda		spriteMagnificationEnabled
	ora		#SpriteSize					; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ora		#$A0
	sta		ZPParam1

	lda		#$01
	sta		ZPParam2
	
	jsr		writeVDPReg

	rts

enableIRQ_:	public enableIRQ_
	; Clear nmi counts
	lda		#0
	sta		nmiCount
	sta		lastNMICount

	cli

	rts

disableIRQ_:	public disableIRQ_
	sei

	rts

; void waitForVBlank();
waitForVBlank_:	public waitForVBlank_
	lda		nmiCount
	cmp		lastNMICount
	
	beq		waitForVBlank_
	
	sta		lastNMICount

	inc		frameCount
	
	rts
