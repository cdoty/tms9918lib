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

; Stores hl of the selected sprite
selectedSprite:	public selectedSprite	
	ds	2

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
	; Multiply selectedSprite by 4.
	push	bc
	push	hl

	sla		a
	sla		a

	ld		c, a
	ld		b, 0

	ld		hl, spriteTable
	add		hl, bc

	ld		(selectedSprite), hl

	pop		hl
	pop		bc
	
	ret

; A: Sprite X
; E: Sprite Y
setSpritePosition_:	public setSpritePosition_
	push	hl

	ld		hl, (selectedSprite)

	ld		(hl), e
	inc		hl
	
	ld		(hl), a

	pop		hl

	ret

; A: Sprite tile
setSpriteTile_:	public setSpriteTile_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position
	inc		hl
	inc		hl

	ld		(hl), a

	pop		hl

	ret

; A: Sprite color
setSpriteColor_:	public setSpriteColor_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position and tile
	inc		hl
	inc		hl
	inc		hl

	ld		(hl), a

	pop		hl

	ret

; A: Sprite tile
; E: Sprite color
setSpriteTileAndColor_:	public setSpriteTileAndColor_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position
	inc		hl
	inc		hl

	ld		(hl), a
	inc		hl
	ld		(hl), e

	pop		hl

	ret
