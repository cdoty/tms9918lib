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

	; Invert data
	cpl

	ld		c, a

	; Mask out down direction
	and		$10
	srl		a
	srl		a
	srl		a
	srl		a

	ld		b, a

	; Read E button
	ld		a, c
	and		$40
	srl		a
	srl		a

	or		b
	ld		b, a

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

	; Invert and mask out up direction
	cpl
	and		$08
	srl		a
	srl		a

	or		b
	ld		b, a
	
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

	; Invert and mask out right direction
	cpl
	and		$10
	srl		a
	srl		a

	or		b
	ld		b, a
	
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

	; Invert and mask out left direction
	cpl
	and		$08
	or		b

	ld		(joystick1Value), a

	pop		bc

	ret
