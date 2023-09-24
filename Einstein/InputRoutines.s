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
	set		0, b

	jp		checkJoystick1Right

checkJoystick1Up:
	cp		127 + DeadZone
	jr		c, checkJoystick1Right

	; Set up bit
	set		1, b

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
	set		2, b

	jp		exitReadJoystick1

checkJoystick1Left:
	cp		127 - DeadZone
	jr		nc, exitReadJoystick1

	; Set left bit
	set		3, b

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
	set		0, b

	jp		checkJoystick2Right

checkJoystick2Up:
	cp		127 + DeadZone
	jr		c, checkJoystick2Right

	; Set up bit
	set		1, b

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

	set		3, b

	jp		exitReadJoystick2

checkJoystick2Left:
	cp		127 - DeadZone
	jr		nc, exitReadJoystick2

	set		4, b

exitReadJoystick2:
	ld		a, b
	ld		(joystick2Value), a

	ret

readJoystickButtons:
	ld		a, (joystick1Value)
	ld		b, a

	ld		a, (joystick2Value)
	ld		c, a

	in		a, (JoystickButtonPort)
	
	bit		0, a
	jr		nz, check2ndFireButton
		
	set		4, b

check2ndFireButton:
	bit		1, a
	jr		nz, exitReadJoystickButtons

	set		4, c

exitReadJoystickButtons:
	ld		a, b
	ld		(joystick1Value), a

	ld		a, c
	ld		(joystick2Value), a

	ret

; DE: Delay
wait:
	dec		de
	
	ld		a, d
	or		e
	
	jr		nz, wait
	
	ret
	
