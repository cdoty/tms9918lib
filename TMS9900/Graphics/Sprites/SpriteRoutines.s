include "../../../../Game/GameDefines.inc"
include "../../../../System/SystemDefines.inc"
include "../../../../System/VRAMDefines.inc"

ext	transferToVRAM_
ext	clearVRAMWithParameters

dseg

spriteTable:	public spriteTable
	ds	4 * MaxSprites

; Stores hl of the selected sprite
selectedSprite:	public selectedSprite	
	ds	2

updateSpriteAttributes:	public updateSpriteAttributes
	ds	2

; Flicker mode enabled
flickerModeEnabled:	public flickerModeEnabled
	ds	2

flickerModeFrame:
	ds	2
	
flickerModeStartSprite:	public flickerModeStartSprite
	ds	2

; Stores number of active sprites for forward and reverse transfer routines
activeSprites:	public activeSprites
	ds	2

cseg

clearSprites_:	public clearSprites_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10
    dect	r10
	mov		r2, *r10

	li		r1, spriteTable
	li		r2, MaxSprites

clearSpriteLoop:
	li		r0, (HiddenSpriteY SHL 8) OR HiddenSpriteX
	mov		r0, *r1
	inct	r1

	clr		r0

	mov		r0, *r1
	inct	r1
	
	dec		r2
	jne		clearSpriteLoop
	
	li		r0, SpriteAttributes
	li		r1, spriteTable
	li		r2, 4 * SystemSprites
	
	bl		@transferSpriteAttributeTable
	
    mov		*r10+, r2
    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

setActiveSprites_:	public setActiveSprites_
    dect	r10
	mov		r11, *r10

	swpb	r0
	mov		r0, @activeSprites

    mov		*r10+, r11
	
	rt

setStartSprite_:	public setStartSprite_
    dect	r10
	mov		r11, *r10

	swpb	r0
	mov		r0, @flickerModeStartSprite

    mov		*r10+, r11
	
	rt

enableFlickerMode_:	public enableFlickerMode_
    dect	r10
	mov		r11, *r10

	swpb	r0
	mov		r0, @flickerModeEnabled		; Enable/Disable flicker mode
	
	clr		r0
	mov		r0, @flickerModeFrame		; Reset flicker mode frame
	mov		r0, @flickerModeStartSprite	; Reset flicker mode start sprite
		
    mov		*r10+, r11
	
	rt

updateSprites_:	public updateSprites_
    dect	r10
	mov		r11, *r10

	; Set update sprite attributes flag
	li		r0, 1
	mov		r0, @updateSpriteAttributes

    mov		*r10+, r11
	
	rt
	
updateSpriteAttributeTable:	public updateSpriteAttributeTable
transferSpriteAttributeTable:		; TODO: Implement 6502 sprite flicker
	; No need to disable interrupts since we're in VBlank
    dect	r10
	mov		r11, *r10

	li		r0, SpriteAttributes
	li		r1, spriteTable
	li		r2, 4 * MaxSprites
	
	bl		@transferToVRAM_

	; Clear update sprite attributes flag
	clr		r0
	mov		r0, @updateSpriteAttributes

    mov		*r10+, r11
	
	rt

; R0 - Sprite number
selectSprite_:	public selectSprite_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10

	swpb	r0

	; Multiply selectedSprite by 4.
	sla		r0, 2

	li		r1, spriteTable
	a		r1, r0

	mov		r0, @selectedSprite

    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

; R0 - Sprite X
; R1 - Sprite Y
setSpritePosition_:	public setSpritePosition_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10
    dect	r10
	mov		r2, *r10

	mov		@selectedSprite, r2

	movb	r1, *r2+
	movb	r0, *r2

    mov		*r10+, r2
    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

; R0 - Sprite tile
setSpriteTile_:	public setSpriteTile_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10

	mov		@selectedSprite, r1

	; Skip x and y position
	inct	r1

	movb	r0, *r1

    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

; R0 - Sprite color
setSpriteColor_:	public setSpriteColor_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10

	mov		@selectedSprite, r1

	; Skip x and y position and tile
	inct	r1
	inc		r1

	movb	r0, *r1

    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

; R0 - Sprite tile
; R1 - Sprite color
setSpriteTileAndColor_:	public setSpriteTileAndColor_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10
    dect	r10
	mov		r2, *r10

	mov		@selectedSprite, r2

	; Skip x and y position
	inct	r2

	movb	r0, *r2+
	movb	r1, *r2+

    mov		*r10+, r2
    mov		*r10+, r1
    mov		*r10+, r11
	
	rt
