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
setSpritePosition_@Param0:	public setSpritePosition_@Param0
setSpriteTile_@Param0:	public setSpriteTile_@Param0
setSpriteColor_@Param0:	public setSpriteColor_@Param0
setSpriteTileAndColor_@Param0:	public setSpriteTileAndColor_@Param0
setActiveSprites_@Param0:	public setActiveSprites_@Param0
setStartSprite_@Param0:	public setStartSprite_@Param0
enableFlickerMode_@Param0:	public enableFlickerMode_@Param0
	ds	1

setSpritePosition_@Param1:	public setSpritePosition_@Param1
setSpriteTileAndColor_@Param1:	public setSpriteTileAndColor_@Param1
	ds	1

dseg

spriteTable:	public spriteTable
	ds	4 * MaxSprites

updateSpriteAttributes:	public updateSpriteAttributes
	ds	1

selectedSprite:	public selectedSprite
	ds	1

; Flicker mode enabled
flickerModeEnabled:	public flickerModeEnabled
	ds	1

flickerModeFrame:
	ds	1
	
flickerModeStartSprite:	public flickerModeStartSprite
	ds	1

; Stores number of active sprites for forward and reverse transfer routines
activeSprites:	public activeSprites
	ds	1

cseg

clearSprites_:	public clearSprites_
	ldx		#MaxSprites

	lda		LOW(spriteTable)
	sta		ZPDestination

	lda		HIGH(spriteTable)
	sta		ZPDestination + 1
	
	ldy		#0

clearSpritesLoop:
	lda		#$C0
	sta		(ZPDestination), y
	iny
	sta		(ZPDestination), y
	iny
	lda		#$00
	sta		(ZPDestination), y
	iny
	sta		(ZPDestination), y
	iny

	dex
	bne		clearSpritesLoop

	jsr		updateSpriteAttributeTable
	
	rts

setActiveSprites_:	public setActiveSprites_
	lda		setActiveSprites_@Param0
	sta		activeSprites

	rts

setStartSprite_:	public setStartSprite_
	lda		setStartSprite_@Param0
	sta		flickerModeStartSprite

	rts

enableFlickerMode_:	public enableFlickerMode_
	lda		enableFlickerMode_@Param0
	sta		flickerModeEnabled
	
	lda		#0
	sta		flickerModeFrame		; Reset flicker mode frame
	sta		flickerModeStartSprite	; Reset flicker mode start sprite
	
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
