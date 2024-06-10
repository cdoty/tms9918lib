ext	_HBC56Entry
ext	irqHandler
ext	nmiHandler

cseg

; Assembles to location $FFFA, at the end of the cartridge.
_HBC56VECTORS:	public _HBC56VECTORS
	dw	nmiHandler
	dw	_HBC56Entry
	dw	irqHandler
