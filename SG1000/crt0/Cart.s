ext	startup
ext	irqHandler
ext	nmiHandler

cseg

_SG1000ENTRY:	public _SG1000ENTRY
	di	
	
	im	1

	jp	startup

afterStartup:
	; Calculate offset of _RST38
	ds	$38 - (afterStartup - _SG1000ENTRY)

_RST38:	public _RST38
	jp	irqHandler

afterRST38:
	; Calculate offset of _RST66
	ds	$66 - (afterRST38 - _SG1000ENTRY)

_RST66:	public _RST66
	jp	nmiHandler
