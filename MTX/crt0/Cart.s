ext	startup

cseg

_MTXHEADER:	public _MTXHEADER
	db  $08, $07, $06, $05, $04, $03, $02, $01
	db  $00, $00, $00, $00

	jp	_MTXENTRY
	
	nop

_MTXENTRY:	public _MTXENTRY
	jp	startup
