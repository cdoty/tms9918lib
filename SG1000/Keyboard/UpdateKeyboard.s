include "../../../System/InputDefines.inc"
include "../../../System/SystemDefines.inc"

ext	joystick1Value

cseg

updateKeyboard_:	public updateKeyboard_
	ld		d, 0

	in		a, (PPIPortC)				; Detect keyboard
	cp		7
	jr		z, exitReadKeyboard			; Skip keyboard read

checkLeftKey:
	ld		a, $05						; Select row 5
	out		(PPIPortC), a
	in		a, (PPIPortA)

	bit		5, a
	jr		nz, checkRightKey

	set		JoypadLeftBit, d

checkRightKey:
	ld		a, $06						; Select row 6
	out		(PPIPortC), a
	in		a, (PPIPortA)

	bit		5, a
	jr		nz, checkUpKey

	set		JoypadRightBit, d

checkUpKey:
	bit		6, a
	jr		nz, checkDownKey

	set		JoypadUpBit, d

checkDownKey:
	ld		a, $04						; Select row 4
	out		(PPIPortC), a
	in		a, (PPIPortA)

	bit		5, a
	jr		nz, checkFire1Key

	set		JoypadDownBit, d

checkFire1Key:							; CLS key
	ld		a, $02						; Select row 2
	out		(PPIPortC), a
	in		a, (PPIPortA)

	bit		4, a
	jr		nz, checkFire2Key

	set		Button1Bit, d

checkFire2Key:							; DELETE key
	ld		a, $03						; Select row 3
	out		(PPIPortC), a
	in		a, (PPIPortA)

	bit		4, a
	jr		nz, exitReadKeyboard

	set		Button2Bit, d

exitReadKeyboard:
	ld		a, (joystick1Value)
	or		d
	ld		(joystick1Value), a

	ret
