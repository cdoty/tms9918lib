ext	startup

cseg

_PECOSMODULHEADER:	public _PECOSMODULHEADER
	db	$55, $AA			; Module header
	dw	$2000				; Load address
;	db	0					; Unknown. Seems to be an error in the bios.
	dw	$4000				; Length
	dw	_PECOSMODULEENTRY	; Start address

_PECOSMODULEENTRY:	public _PECOSMODULEENTRY
	di
	
	im		1

	jp		startup
