ext	startup
ext	nmiHandler
ext	spriteTable

	dw	spriteTable		; Sprite table
	dw	0				; Sprite order table, not used
	dw	0				; Work buffer, not used
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

include	"../../../System/Cartridge.inc"
