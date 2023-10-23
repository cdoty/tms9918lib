ext	startup

cseg

_TI994AHEADER:	public _TI994AHEADER
	dw	$AA01, $0100, $0000, _TI994ASTART	; Standard header ($AA), version 1
	dw	$0000, $0000, $0000, $0000

_TI994ASTART:
	dw	$0000, _TI994AENTRY					; Link to next object, Address of item
	
include "../../../System/Title.inc"

_TI994AENTRY:	public _TI994AENTRY
	limi	$0000			; Disable interrupts
	lwpi	$83E0 - 4		; Setup workspace
	li		r10, $83E0 - 4	; Setup "stack"

	b		@startup
