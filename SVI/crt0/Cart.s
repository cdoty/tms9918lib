ext	startup
ext	nmiHandler

cseg

_SVIENTRY:	public _SVIENTRY
	di					; First two instructions have to be di and ld sp, $FFFF
	
	ld	sp, StackStart	; Setup stack

	jp	startup

	ds	1

_RST08:	public _RST08
	reti
	
	ds	6

_RST10:	public _RST10
	reti

	ds	6
	
_RST18:	public _RST18
	reti

	ds	6

_RST20:	public _RST20
	reti

	ds	6
	
_RST28:	public _RST28
	reti

	ds	6

_RST30:	public _RST30
	reti

	ds	6
	
_RST38:	public _RST38
	jp	nmiHandler
