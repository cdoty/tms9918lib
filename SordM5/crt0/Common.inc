	dw		startup		; Start of code
	dw		runOnce		; Code ran on initial cartridge load
	dw		unknown		; Unknown entry

runOnce:
	ret

unknown:
	ret

