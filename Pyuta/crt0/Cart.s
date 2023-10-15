ext	startup

cseg

_PYUTAHEADER:	public _PYUTAHEADER
	dw	$5555

_PYUTAENTRY:	public _PYUTAENTRY
	limi	$0000			; Disable interrupts
	lwpi	$F0E0 - 4		; Setup workspace
	li		r10, $F0E0 - 4	; Setup "stack"

	b		@startup
