include "../../../../Game/GameDefines.inc"
include "../../../../System/SystemDefines.inc"
include "../../../../System/VRAMDefines.inc"

ext	transferToVRAM_
ext	clearVRAMWithParameters

dseg

spriteTable:	public spriteTable
	ds	4 * MaxSprites

updateSpriteAttributes:	public updateSpriteAttributes
	ds	1

selectedSprite:	public selectedSprite
	ds	1

cseg

clearSprites_:	public clearSprites_
	ld		a, MaxSprites
	ld		c, a

	ld		hl, spriteTable
	xor		a

clearSpriteLoop:
	ld		(hl), a
	inc		hl
	ld		(hl), a
	inc		hl
	ld		(hl), a
	inc		hl
	ld		(hl), a
	inc		hl
	
	dec		c
	jr		nz, clearSpriteLoop
	
	ld		hl, SpriteAttributes
	ld		de, 4 * SystemSprites
	call	clearVRAMWithParameters
	
	ret

updateSprites_:	public updateSprites_
	; Set update sprite attributes flag
	ld		a, 1
	ld		(updateSpriteAttributes), a

	ret
	
updateSpriteAttributeTable:	public updateSpriteAttributeTable
	; No need to disable interrupts since we're in VBlank

	ld		hl, spriteTable
	ld		de, SpriteAttributes
	ld		bc, 4 * MaxSprites
	call	transferToVRAM_

	; Clear update sprite attributes flag
	xor		a
	ld		(updateSpriteAttributes), a

	ret

selectSprite_:	public selectSprite_
	ld		(selectedSprite), a

	ret

; A: Sprite X
; E: Sprite Y
setSpritePosition_:	public setSpritePosition_
	push	bc
	push	de
	push	hl

	ld		d, a

	ld		a, (selectedSprite)

	; Multiply selectedSprite by 4.
	sla		a
	sla		a

	ld		c, a
	ld		b, 0

	ld		hl, spriteTable
	add		hl, bc

	ld		(hl), e
	inc		hl
	
	ld		(hl), d

	pop		hl
	pop		de
	pop		bc

	ret

; A: Sprite Tile
setSpriteTile_:	public setSpriteTile_
	push	bc
	push	de
	push	hl

	ld		d, a

	ld		a, (selectedSprite)

	; Multiply selectedSprite by 4.
	sla		a
	sla		a

	; Skip x and y position
	add		a, 2

	ld		c, a
	ld		b, 0

	ld		hl, spriteTable
	add		hl, bc

	ld		(hl), d

	pop		hl
	pop		de
	pop		bc

	ret

; A: Sprite Color
setSpriteColor_:	public setSpriteColor_
	push	bc
	push	de
	push	hl

	ld		d, a

	ld		a, (selectedSprite)

	; Multiply selectedSprite by 4.
	sla		a
	sla		a

	; Skip x and y position and tile
	add		a, 3

	ld		c, a
	ld		b, 0

	ld		hl, spriteTable
	add		hl, bc

	ld		(hl), d

	pop		hl
	pop		de
	pop		bc

	ret

setSpriteTileAndColor_:	public setSpriteTileAndColor_
	push	bc
	push	de
	push	hl

	ld		d, a

	ld		a, (selectedSprite)

	; Multiply selectedSprite by 4.
	sla		a
	sla		a

	; Skip x and y position
	add		a, 2

	ld		c, a
	ld		b, 0

	ld		hl, spriteTable
	add		hl, bc

	ld		(hl), d
	inc		hl
	ld		(hl), e

	pop		hl
	pop		de
	pop		bc

	ret
