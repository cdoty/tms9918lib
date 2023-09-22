ext	startup
ext	irqHandler

cseg

_MYVISIONHEADER:	public _MYVISIONHEADER
	di
	im	1

	; Jump to start location.
	jp	startup

	ds	$32

_RST38:	public _RST38
	jp	irqHandler