include "../../System/SystemDefines.inc"

dseg

joystick1Value:	public joystick1Value
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
	push	bc

	; Read joystick port 1
	in		a, (Joystick1Port)
	
	; Invert bits
	cpl

	ld		b, a

	; Shift joystick two data into place
	srl		b
	srl		b
	srl		b
	srl		b
	srl		b
	srl		b

	; Isolate DPAD and button 1 and 2 inputs
	and		$3F
	
	; Store result
	ld		(joystick1Value), a

	; Read joystick 2 data
	in		a, (Joystick2Port)
	
	; Invert and isolate DPAD and button 1 and 2 inputs
	cpl
	and		$0F

	sla		a
	sla		a
	
	; Combine with the data from port 1
	or		b

	; Store result
	ld		(joystick2Value), a

	pop		bc

	ret
