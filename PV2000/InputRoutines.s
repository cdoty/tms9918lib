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

readJoysticks:	public readJoysticks
	; readJoysticks uses register b and c
	push	bc
	push	de

	; Select row 6
	ld		a, 6
	out		(InputPort), a

	; Read left and right buttons from both joysticks
	in		a, (InputPort)
	
	; Save temp value
	ld		d, a

	and		$03
	ld		b, a

	; Process upper nibble
	ld		a, d
	
	srl		a
	srl		a
	and		$03
	
	ld		c, a

	; Select row 7
	ld		a, 7
	out		(InputPort), a

	; Read up and down buttons from both joysticks
	in		a, (InputPort)
	
	; Save temp value
	ld		d, a

	sla		a
	sla		a
	and		$0C
	or		b

	; Save result
	ld		b, a

	; Process upper nibble
	ld		a, d

	and		$0C
	or		c

	; Save result
	ld		c, a

	; Select row 8
	ld		a, 8
	out		(InputPort), a

	; Read buttons from both joysticks
	in		a, (InputPort)
	
	; Save temp value
	ld		d, a

	sla		a
	sla		a
	sla		a
	sla		a
	and		$30
	or		b

	; Store result
	ld		(joystick1Value), a

	; Process upper nibble
	ld		a, d

	sla		a
	sla		a
	and		$30
	or		c

	; Store result
	ld		(joystick2Value), a

	; End read
	ld		a, $0F
	out		(InputPort), a

	pop		de
	pop		bc

	ret
