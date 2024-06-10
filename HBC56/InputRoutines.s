include "../../System/SystemDefines.inc"

ext	ZPParam1

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
	lda		#0
	sta		joystick1Value
	sta		joystick1LastValue
	sta		joystick2Value
	sta		joystick2LastValue

	rts

updateJoysticks_:	public updateJoysticks_
	; Save last joystick values
	lda		joystick1Value
	sta		joystick1LastValue
	lda		joystick2Value
	sta		joystick2LastValue

	jsr		readJoystick1
	jsr		readJoystick2
	
	rts

readJoystick1_:	public readJoystick1_
	ldy		joystick1Value

	rts

readJoystick2_:	public readJoystick2_
	ldy		joystick2Value

	rts

readJoystick1:	public readJoystick1
	lda		JoystickPort1
	eor		#$FF
	sta		joystick1Value

	rts

readJoystick2:
	lda		JoystickPort2
	eor		#$FF
	sta		joystick2Value

	rts
