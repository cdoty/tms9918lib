include "../../System/InputDefines.inc"
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
	push	bc

	ld		b, 0

	; Select Port A register
	ld		a, 14
	ld		bc, PSGRegisterPort
	out		(c), a

	ld		bc, PSGReadPort
	in		a, (c)

	; Check right
	bit		1, a
	jr		nz, CheckLeft
	
	set		JoypadRightBit, b
	jr		CheckUp

CheckLeft:
	bit		2, a
	jr		nz, CheckUp
	
	set		JoypadLeftBit, b

CheckUp:
	bit		3, a
	jr		nz, CheckDown
	
	set		JoypadUpBit, b

	jr		CheckFire1

CheckDown:
	bit		4, a
	jr		nz, CheckFire1
	
	set		JoypadDownBit, b

CheckFire1:
	bit		0, a
	jr		nz, CheckFire2
	
	set		Button1Bit, b

CheckFire2:
	bit		Button1Bit, a
	jr		nz, exitReadJoystick
	
	set		Button2Bit, b

exitReadJoystick:
	ld		a, b
	ld		(joystick1Value), a

	pop		bc

	ret
