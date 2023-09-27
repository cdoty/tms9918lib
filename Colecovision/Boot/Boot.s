include "Defines.inc"

dseg

CurrentDevice:
	db	0

BlocksToLoad:
	db	0

cseg

_DDPBOOTENTRY:	public	_DDPBOOTENTRY
	di

	ld		a, b
	ld		(CurrentDevice), a
	
	ld		a, $BC
	ld		(BlocksToLoad), a

	ld		de, 1
	ld		hl, ROMStart

blockLoadLoop:
	ld		a, (CurrentDevice)
	ld		bc, 0

RetryRead:
	push	de
	push	hl

	call	$FCF3		; Read one block

	pop		hl
	pop		de

	jr		nz, RetryRead

	inc		de

	ld		bc, BlockSize
	add		hl, bc
	
	ld		a, (BlocksToLoad)
	dec		a
	ld		(BlocksToLoad), a
	
	jr 		nz, blockLoadLoop

	; Jump to start address.
	jp		$100
