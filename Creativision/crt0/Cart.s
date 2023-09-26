include "../../../Game/GameDefines.inc"
include "../../../System/VRAMDefines.inc"

ext	startup
ext	irq2Handler

cseg

; Assembles to location $BFE8, at the end of the cartridge.
_CREATIVISIONHEADER:	public _CREATIVISIONHEADER
	dw	startup						; Start address
	dw	irq2Handler					; IRQ 2 handler address

	ds	4

	db	$02							; Disable external VDP interrupt, set M2 for Graphics mode 2.
	db	$A0 OR SpriteSize			; Enable 16K VRAM, Screen Off, and 16x16 sprites. Disable NMI interrupt.
	db	Screen1VRAM / $400			; Set Name Table location, in VRAM.
	db	(Color1VRAM / $40) OR $7F	; Set Color Table location, in VRAM.
	db	(Tile1VRAM / $800) OR 3		; Set Pattern Table location, in VRAM.
	db	SpriteAttributes / $80		; Set Sprite Attribute Table location, in VRAM.
	db	SpritePattern / $800		; Set Sprite Pattern Table location, in VRAM.
	db	$00							; Set background color to black.

	ds	4

	dw	$F808						; NMI BIOS Reset address
	dw	$FF3F						; BIOS IRQ 1 handler address
