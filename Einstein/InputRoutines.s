include "../../System/SystemDefines.inc"

DeadZone			equ	64
JoystickReadDelay	equ	5

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
	push	bc
	push	de

	; Save last joystick values
	ld		a, (joystick1Value)
	ld		(joystick1LastValue), a

	call	readJoystick1
	
	ld		a, (joystick2Value)
	ld		(joystick2LastValue), a

	call	readJoystick2
	
	call	readJoystickButtons

	pop		de
	pop		bc

	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoystick1:
	ld		b, 0

	; Select Y axis
	ld		a, $05
	out		(ADCPort), a

	; Wait for results
	ld		de, JoystickReadDelay
	call	wait

	; Read value. 127 is center
	in		a, (ADCPort)

	cp		127 - DeadZone
	jr		nc, checkJoystick1Up

	; Set down bit
	ld		b, 1

	jp		checkJoystick1Right

checkJoystick1Up:
	cp		127 + DeadZone
	jr		c, checkJoystick1Right

	; Set up bit
	ld		b, 2

checkJoystick1Right:
	; Select X axis
	ld		a, $04
	out		(ADCPort), a

	; Wait for results
	ld		de, JoystickReadDelay
	call	wait

	; Read value. 127 is center
	in		a, (ADCPort)

	cp		127 + DeadZone
	jr		c, checkJoystick1Left

	; Set right bit
	ld		a, b
	or		4
	ld		b, a

	jp		exitReadJoystick1

checkJoystick1Left:
	cp		127 - DeadZone
	jr		nc, exitReadJoystick1

	; Set left bit
	ld		a, b
	or		8
	ld		b, a

exitReadJoystick1:
	ld		a, b
	ld		(joystick1Value), a

	ret

readJoystick2:
	ld		b, 0

	; Select Y axis
	ld		a, $25
	out		(ADCPort), a

	; Wait for results
	ld		de, JoystickReadDelay
	call	wait

	; Read value. 127 is center
	in		a, (ADCPort)

	cp		127 - DeadZone
	jr		nc, checkJoystick2Up

	; Set down bit
	ld		b, 1

	jp		checkJoystick2Right

checkJoystick2Up:
	cp		127 + DeadZone
	jr		c, checkJoystick2Right

	; Set up bit
	ld		b, 2

checkJoystick2Right:
	; Select X axis
	ld		a, $24
	out		(ADCPort), a

	; Wait for results
	ld		de, JoystickReadDelay
	call	wait

	; Read value. 127 is center
	in		a, (ADCPort)

	cp		127 + DeadZone
	jr		c, checkJoystick2Left

	ld		a, b
	or		4
	ld		b, a

	jp		exitReadJoystick2

checkJoystick2Left:
	cp		127 - DeadZone
	jr		nc, exitReadJoystick2

	ld		a, b
	or		8
	ld		b, a

exitReadJoystick2:
	ld		a, b
	ld		(joystick2Value), a

	ret

readJoystickButtons:
	ld		(joystick1Value), a
	ld		b, a

	ld		(joystick2Value), a
	ld		c, a

	in		a, (JoystickButtonPort)

	; Invert and mask bits.
	cpl
	
	ld		d, a

	and		$01
		
	; Shift buttons into upper nibble
	sla		a
	sla		a
	sla		a
	sla		a

	or		b

	ld		(joystick1Value), a

	ld		a, d

	; Isolate the second button
	and		$02
	srl		a
	or		c

	ld		(joystick2Value), a

	ret

; DE: Delay
wait:
	dec		de
	
	ld		a, d
	or		e
	
	jr		nz, wait
	
	ret
	
