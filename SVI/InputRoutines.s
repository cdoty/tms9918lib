include "../../System/SystemDefines.inc"

ext	readPSGReg

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
	push	bc

	; Read joystick port 1
	ld		b, $0E
	call	readPSGReg
	
	; Invert bits
	cpl

	ld		c, a

	; Shift joystick two DPAD data into place
	srl		c
	srl		c
	srl		c
	srl		c

	; Isolate DPAD and button 1 and 2 inputs
	and		$0F
	
	ld		b, a

	; Read joystick 1 button status, in bit 4.
	in		a, (PPIPortA)

	; Invert and isolate bit 4.
	cpl
	and		$10
	
	; Combine DPAD data
	or		b

	; Store result
	ld		(joystick1Value), a

	; Read joystick 2 button status, in bit 5.
	in		a, (PPIPortA)

	; Invert and isolate bit 5.
	cpl
	and		$20
	
	; Shift into button bit.
	srl		a	

	; Combine DPAD data
	or		c

	; Store result
	ld		(joystick2Value), a

	pop		bc

	ret
