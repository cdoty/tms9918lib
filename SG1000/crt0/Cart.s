include "../../../System/SystemDefines.inc"

ext	startup
ext	irqHandler
ext	nmiHandler

cseg

_SG1000ENTRY:	public _SG1000ENTRY
	di	
	
	im	1

	jp	startup

	ds	$32

_RST38:	public _RST38
	jp	irqHandler

	ds	$2B

_RST66:	public _RST66
	jp	nmiHandler
