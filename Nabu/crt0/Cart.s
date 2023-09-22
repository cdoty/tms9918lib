ext	startup

cseg

	nop		; Padding
	nop
	nop

_NABUENTRY:	public _NABUENTRY
	di
	jp		startup
	
	ds	$6C
