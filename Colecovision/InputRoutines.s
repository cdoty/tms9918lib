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

readJoysticks:
	; readJoysticks uses register b and c
	push	bc

	; Enable keypad read
	ld		a, $FF
	out		(KeypadReadEnable), a

	; Read keypad 1 data
	in		a, (Input1Data)
	
	; Invert and isolate button 2 input
	cpl
	and		$40

	; Shift into button 2 position
	srl		a
	
	; Save result
	ld		b, a

	; Read keypad 2 data
	in		a, (Input2Data)
	
	; Invert and isolate button 2 input
	cpl
	and		$40

	; Shift into button 2 position
	srl		a
	
	; Save result
	ld		c, a

	; Enable joystick read
	ld		a, $FF
	out		(JoystickReadEnable), a

	; Read joystick 1 data
	in		a, (Input1Data)
	
	; Invert and isolate DPAD and button 1 inputs
	cpl
	and		$1F
	
	; Or button 2 data
	or		b

	; Store result
	ld		(joystick1Value), a

	; Read joystick 2 data
	in		a, (Input2Data)
	
	; Invert and isolate DPAD and button 1 inputs
	cpl
	and		$1F
	
	; Or button 2 data
	or		c

	; Store result
	ld		(joystick2Value), a

	pop		bc

	ret
