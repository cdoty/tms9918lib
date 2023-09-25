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
	push	de

	; Trigger button read
	ld		a, 7
	out		(PPIPortC), a

	; Read PPI port A
	in		a, (PPIPortA)
	
	; Store a temp copy of the bits
	ld		d, a

	; Read PPI port B
	in		a, (PPIPortB)
	
	; Store a temp copy of the bits
	ld		e, a

	; Reset port C
	ld		a, $FF
	out		(PPIPortC), a

	; Get joystick 1 direction and buttons
	ld		a, d
	cpl
	and		$3F

	; Store result
	ld		(joystick1Value), a

	; Get lower 2 bits of joystick 2 data
	ld		a, d

	; Invert bits and shift the upper 2 bits into joystick 2 lower 2 bits
	cpl
	srl		a
	srl		a
	srl		a
	srl		a
	srl		a
	srl		a
	and		$03

	ld		b, a

	; Get the upper 4 bits of joystick 2 data
	ld		a, e
	
	; Invert bits and shift the lower 4 bits into joystick 2 upper 4 bits
	cpl
	and		$0F
	sla		a
	sla		a

	or		b

	; Store result
	ld		(joystick2Value), a

	pop		de
	pop		bc

	ret

setupJoysticks:	public setupJoysticks
	; Set mode 0 for both groups, PPI ports A and B to input, and port C to output for both upper and lower parts.
	ld		a, $92
	ld		(PPIPortControl), a

	ret
