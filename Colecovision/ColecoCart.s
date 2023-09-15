include "../../Platform/Defines.inc"

ext	startup
ext	nmiHandler

dseg
spriteTable:
	ds	128

spriteOrder:
	ds	32

workBuffer:
	ds	64

cseg
header:	public header
;include "Boot.inc"
include "BootNoLogo.inc"

	dw	spriteTable		; Sprite table
	dw	spriteOrder		; Sprite order table
	dw	workBuffer		; Work buffer
	db	0				; Disable joystick 1 polling
	db	0				; Disable joystick 2 polling
	dw	startup			; Start of code

RST8H:
	reti
	nop

RST10H:
	reti
	nop

RST18H:
	reti
	nop

RST20H:
	reti
	nop

RST28H:
	reti
	nop

RST30H:
	reti
	nop

IRQ:
	reti
	nop

NMI:
	jp		nmiHandler

include	"../../Platform/Cartridge.inc"