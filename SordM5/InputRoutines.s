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

	call	readJoysticks
	
	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoysticks:	public readJoysticks
	push	bc
	push	de

	; Read DPAD input for both controllers
	in		a, (InputPort7)

	ld		c, a

	; Shift the data into position
	srl		c
	srl		c
	srl		c
	srl		c

	; Save joystick 1 directional buttons
	and		$0F
	ld		b, a

	; Read button input for both controllers
	in		a, (InputPort1)

	ld		d, a

	; Get joystick 1 buttons
	and		$03

	; Shift into upper nibble
	sla		a
	sla		a
	sla		a
	sla		a

	or		b

	; Store joystick 1 value
	ld		(joystick1Value), a

	ld		a, d

	; Get joystick 2 buttons
	and		$30
	or		c

	; Store joystick 2 value
	ld		(joystick2Value), a

	pop		de
	pop		bc

	ret
