include "../../../../../System/SystemDefines.inc"

cseg

; D - Register
; E - Value
writePSGReg:	public writePSGReg
	ld		bc, PSGRegisterPort
	ld		a, d
	out		(c), a

	ld		bc, PSGRegisterPort
	ld		a, e
	out		(c), a

	ret

; B - Register
; A - read value
readPSGReg:	public readPSGReg
	ld		a, b

	ld		bc, PSGRegisterPort
	out		(c), a

	ld		bc, PSGReadPort
	in		a, (c)

	ret

resetSound:	public resetSound
	ld		d, 7			; Select register 7
	ld		e, $BF			; Enable port A, disable all noise and sound channels

	call	writePSGReg

	ret
