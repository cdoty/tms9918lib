include "../../../../Game/GameDefines.inc"
include "../../../../System/SystemDefines.inc"
include "../../../../System/VRAMDefines.inc"

ext	transferToVRAM_
ext	transferToVRAM_@Param0
ext	transferToVRAM_@Param1
ext	transferToVRAM_@Param2
ext	clearVRAMWithParameters
ext	ZPDestination

zseg

selectSprite_@Param0:	public selectSprite_@Param0
	ds	1

setSpritePosition_@Param0:	public setSpritePosition_@Param0
	ds	1

setSpritePosition_@Param1:	public setSpritePosition_@Param1
	ds	1

setSpriteTile_@Param0:	public setSpriteTile_@Param0
	ds	1

setSpriteColor_@Param0:	public setSpriteColor_@Param0
	ds	1

setSpriteTileAndColor_@Param0:	public setSpriteTileAndColor_@Param0
	ds	1

setSpriteTileAndColor_@Param1:	public setSpriteTileAndColor_@Param1
	ds	1

dseg

spriteTable:	public spriteTable
	ds	4 * MaxSprites

updateSpriteAttributes:	public updateSpriteAttributes
	ds	1

selectedSprite:	public selectedSprite
	ds	1

cseg

clearSprites_:	public clearSprites_
	ldx		#MaxSprites

	lda		LOW(spriteTable)
	sta		ZPDestination

	lda		HIGH(spriteTable)
	sta		ZPDestination + 1
	
	lda		#0
	ldy		#0

clearSpritesLoop:
	sta		(ZPDestination), y
	iny
	sta		(ZPDestination), y
	iny
	sta		(ZPDestination), y
	iny
	sta		(ZPDestination), y
	iny

	dex
	bne		clearSpritesLoop

	rts

updateSprites_:	public updateSprites_
	lda		#1
	sta		updateSpriteAttributes

	rts

updateSpriteAttributeTable:	public updateSpriteAttributeTable
	lda		#LOW(spriteTable)
	sta		transferToVRAM_@Param0

	lda		#HIGH(spriteTable)
	sta		transferToVRAM_@Param0 + 1

	lda		#LOW(SpriteAttributes)
	sta		transferToVRAM_@Param1

	lda		#HIGH(SpriteAttributes)
	sta		transferToVRAM_@Param1 + 1

	lda		#4 * MaxSprites
	sta		transferToVRAM_@Param2

	lda		#0
	sta		transferToVRAM_@Param2 + 1

	jsr		transferToVRAM_

	; Clear update sprite attributes flag
	lda		#0
	sta		updateSpriteAttributes

	rts

selectSprite_:	public selectSprite_
	lda		selectSprite_@Param0

	; Multiply sprite number by 4
	asl		a
	asl		a

	sta		selectedSprite

	rts

; Param0 - Sprite X
; Param1 - Sprite Y
setSpritePosition_:	public setSpritePosition_
	ldy		selectedSprite
	
	lda		setSpritePosition_@Param1
	sta		spriteTable, y

	iny

	lda		setSpritePosition_@Param0
	sta		spriteTable, y

	rts

; A: Sprite tile
setSpriteTile_:	public setSpriteTile_
	ldy		selectedSprite
	
	; Move to tile offset
	iny
	iny

	lda		setSpriteTile_@Param0
	sta		spriteTable, y

	rts

; Param0 - Sprite color
setSpriteColor_:	public setSpriteColor_
	ldy		selectedSprite
	
	; Move to color offset
	iny
	iny
	iny

	lda		setSpriteColor_@Param0
	sta		spriteTable, y

	rts

; Param0 - Sprite tile
; Param1 - Sprite color
setSpriteTileAndColor_:	public setSpriteTileAndColor_
	ldy		selectedSprite
	
	; Move to tile offset
	iny
	iny

	lda		setSpriteTileAndColor_@Param0
	sta		spriteTable, y

	iny

	lda		setSpriteTileAndColor_@Param1
	sta		spriteTable, y

	rts
