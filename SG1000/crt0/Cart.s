include "../../../Platform/SystemDefines.inc"

ext	resetSound
ext	clearRam
ext	delay
ext	startup
ext	irqHandler
ext	nmiHandler

cseg

entry:	public entry
	di	
	
	im		1
	ld		sp, StackStart

	call	resetSound		; Reset sound to stop noise at startup
	call	delay			; Delay before starting
	call	clearRam		; Clear ram
	
	jp		startup

	ds	38

_rst38:	public _rst38
	jp	irqHandler

	ds	43

_rst66:	public _rst66
	jp	nmiHandler
