ext	startup
ext	nmiHandler
ext	irqHandler

cseg

_PV2000HEADER:	public _PV2000HEADER
	; Jump to start location, must be jp and not jr. The system looks for C3h to identify a cartridge.
	jp	startup
