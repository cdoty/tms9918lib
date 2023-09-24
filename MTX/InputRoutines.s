include "../../System/SystemDefines.inc"

dseg

joystick1Value:
    ds	1

joystick1LastValue:
    ds	1

joystick2Value:
    ds	1

joystick2LastValue:
    ds	1

cseg

clearJoysticks_:	public clearJoysticks_
	; Clear joystick values
	xor		a
	ld		(joystick1Value), a
	ld		(joystick1LastValue), a
	ld		(joystick2Value), a
	ld		(joystick2LastValue), a

	ret

updateJoysticks_:	public updateJoysticks_
	ld		a, (Joystick1Value)
	ld		(Joystick1LastValue), a
	ld		a, (Joystick2Value)
	ld		(Joystick2LastValue), a

	call	readJoystick1
	call	readJoystick2
	
	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoystick1:
	push	bc

	ld		b, 0

	ld		a, $FB
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)

	bit		7, a
	jr		nz, checkJoystick1Left
	
	set		0, b

checkJoystick1Left:
	ld		a, $F7
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)

	bit		7, a
	jr		nz, checkJoystick1Right

	set		1, b

checkJoystick1Right:
	ld		a, $EF
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)

	bit		7, a
	jr		nz, checkJoystick1Down

	set		2, b

checkJoystick1Down:
	ld		a, $7F
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)

	bit		7, a
	jr		nz, checkFire1

	set		3, b

checkFire1:
	ld		a, $DF
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)

	bit		7, a
	jr		nz, exitReadJoystick1

	set		4, b

exitReadJoystick1:
	ld		a, b
	ld		(joystick1Value), a

	pop		bc

	ret

readJoystick2:
	push	bc
	push	de

	ld		b, 0

	ld		a, $BF
	out		(KeyboardPort1), a
	in		a, (KeyboardPort1)
	ld		d, a

	in		a, (KeyboardPort2)
	ld		e, a

	bit		2, d
	jr		nz, checkJoystick2Left
	
	set		0, b

checkJoystick2Left:
	bit		3, d
	jr		z, checkJoystick2Right

	set		1, b

checkJoystick2Right:
	bit		0, d
	jr		nz, checkJoystick2Down

	set		3, b

checkJoystick2Down:
	bit		2, d
	jr		nz, checkFire2

	set		3, b

checkFire2:
	bit		0, e
	jr		nz, exitReadJoystick2

	set		4, b

exitReadJoystick2:
	ld		a, b
	ld		(joystick2Value), a
	
	pop		de
	pop		bc

	ret
