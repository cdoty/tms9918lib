include "../../System/InputDefines.inc"
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

updateKeyboard_:	public updateKeyboard_
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

	call	updateKeyboardRows		; Update keyboard rows

	ld		b, 0

	ld		a, (KeyboardRows + 7)	; Read keyboard row. Skip CPL and check for zero flag set instead of cleared.

	bit		4, a
	jr		nz, checkUp1

	set		JoypadDownBit, b

	jr		checkLeft1				; Skip up read

checkUp1:
	ld		a, (KeyboardRows + 5)	; Read keyboard row. Skip CPL and check for zero flag set instead of cleared.

	bit		4, a
	jr		nz, checkLeft1

	set		JoypadUpBit, b

checkLeft1:
	ld		a, (KeyboardRows + 3)	; Read keyboard row. Skip CPL and check for zero flag set instead of cleared.

	bit		5, a
	jr		nz, checkRight1

	set		JoypadLeftBit, b

	jr		checkFire1				; Skip right read

checkRight1:
	ld		a, (KeyboardRows + 1)

	bit		5, a
	jr		nz, checkFire1

	set		JoypadRightBit, b

checkFire1:	public checkFire1
	ld		a, (KeyboardRows + 2)	; Read keyboard row. Skip CPL and check for zero flag set instead of cleared.
	bit		1, a

	jr		nz, endRead1

	set		Button1Bit, b

endRead1:
	ld		a, b

	ld		(joystick1Value), a

	pop		de
	pop		bc

	ret

updateKeyboardRows:	public updateKeyboardRows
	ld		de, KeyboardRows	; Select the start of keyboard row memory

	ld		b, 7				; Read 7 rows
	ld		c, $10

updateKeyboardLoop:
	in		a, (c)

	ex		(sp), hl			; Waste a few cycles
	ex		(sp), hl

	ld		(de), a	
	inc		de
	
	dec		b
	jp		p, updateKeyboardLoop

	ret