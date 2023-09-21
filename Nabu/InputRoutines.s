include "../../System/SystemDefines.inc"

ext	keyboardDevice
ext	internalJoystick1
ext	internalJoystick2

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

	; Clear internal joystick values
	ld		(internalJoystick1), a
	ld		(internalJoystick2), a

	; Clear keyboard device
	ld		(keyboardDevice), a

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
	ld		a, (internalJoystick1)
	ld		(joystick1Value), a

	ld		a, (internalJoystick2)
	ld		(joystick2Value), a

	ret

updateKeyboard:	public updateKeyboard
	in		a, (KeyboardPort)
	
	; Check if it's an error condition or the watchdog timer.
	cp		$90
	jr		c, readJoystickStatus

	cp		$95
	jr		nc, readJoystickStatus

	; Exit out
	ret

; See if it's a joystick device ID byte. Only joystick 0 and 1 are handled.
readJoystickStatus:
	cp		$80
	jr		z, setLastDevice

	cp		$81
	jr		nz, readJoystickStatus1

setLastDevice:
	; Save device ID
	ld		(keyboardDevice), a

	; Exit out
	ret

readJoystickStatus1:
	; Mask out non input bits and save joystick data
	and		$1F
	ld		b, a

	; Check if it's joystick 0 or 1.
	ld		a, (keyboardDevice)

	cp		$80
	jr		nz, readJoystickStatus2

	; Reload joystick data
	ld		a, b

	; Update internal joystick value
	ld		(internalJoystick1), a

	; clearKeyboardDevice is shared with both joystick updates.
	jp		clearKeyboardDevice

readJoystickStatus2:
	cp		$81
	jr		nz, exitKeyboardHandler

	; Reload joystick data
	ld		a, b

	; Update internal joystick value
	ld		(internalJoystick2), a

clearKeyboardDevice:
	; Clear keyboard device
	xor		a
	ld		(keyboardDevice), a

exitKeyboardHandler:
	ret
