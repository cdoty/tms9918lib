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
	; Save last joystick values
	ld		a, (Joystick1Value)
	ld		(Joystick1LastValue), a
	ld		a, (Joystick2Value)
	ld		(Joystick2LastValue), a

	call	readJoysticks
	
	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoysticks:
	; readJoysticks uses register b and c
	push	bc

	ld		b, 0

	; Select Port B register
	ld		a, 15
	out		(PSGRegisterPort), a

	; Select row 0
	ld		a, $7F
	out		(PSGWritePort), a

	; Select Port A register
	ld		a, 14
	out		(PSGRegisterPort), a

	; Read row 0
	in		a, (PSGReadPort)

	; Mask out down direction
	bit		4, a
	jr		nz, readEButton

	set		0, b

readEButton:
	; Read E button
	bit		6, a
	jr		nz, readUpButton

	set		4, b

readUpButton:
	; Select Port B register
	ld		a, 15
	out		(PSGRegisterPort), a

	; Select row 1
	ld		a, $B0
	out		(PSGWritePort), a

	; Select Port A register
	ld		a, 14
	out		(PSGRegisterPort), a

	; Read row 1
	in		a, (PSGReadPort)

	bit		3, a
	jr		nz, readRightButton

	set		1, b

readRightButton:
	; Select Port B register
	ld		a, 15
	out		(PSGRegisterPort), a

	; Select row 2
	ld		a, $D0
	out		(PSGWritePort), a

	; Select Port A register
	ld		a, 14
	out		(PSGRegisterPort), a

	; Read row 2
	in		a, (PSGReadPort)

	bit		4, a
	jr		nz, readLeftButton

	set		2, b

readLeftButton:
	; Select Port B register
	ld		a, 15
	out		(PSGRegisterPort), a

	; Select row 3
	ld		a, $E0
	out		(PSGWritePort), a

	; Select Port A register
	ld		a, 14
	out		(PSGRegisterPort), a

	; Read row 3
	in		a, (PSGReadPort)

	bit		3, a
	jr		nz, exitReadJoystick

	set		3, b

exitReadJoystick:
	ld		a, b
	ld		(joystick1Value), a

	pop		bc

	ret
