ext	startup
ext	nmiHandler
jp	_RST08
jp	_RST10
jp	_RST18
jp	_RST20
jp	_RST28
jp	_RST30
ext	irqHandler

cseg

_PENCIL2HEADER:	public _PENCIL2HEADER
	db	"COPYRIGHT SOUNDIC"	; Boot message

	jp	startup
	jp	nmiHandler

_RST08:	public _RST08
	ret
	nop

_RST10:	public _RST10
	ret
	nop

_RST18:	public _RST18
	ret
	nop

_RST20:	public _RST20
	ret
	nop

_RST28:	public _RST28
	ret
	nop

_RST30:	public _RST30
	ret
	nop

_GAMENAME:	public _GAMENAME
include	"../../../System/Cartridge.inc"
