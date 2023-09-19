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

	ld		a, $80
	out		(KeypadReadEnable), a

	; Read keyboard 0 data
	in		a, (Input0Port)
	
	; Invert and isolate arrow key input
	cpl
	and		$0F

	; Save result
	ld		b, a

	; Enable joystick read?
	ld		a, $80
	out		(JoystickReadEnable), a

	; Read keyboard 3 data
	in		a, (Input3Port)
	
	; Invert and isolate button 2 input
	cpl
	and		$04

	; Shift into button 1 position
	sla		a
	sla		a
	
	; Or button 2 data
	or		b

	; Store result
	ld		(joystick1Value), a

	pop		bc

	ret
