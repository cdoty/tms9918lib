include "../../System/SystemDefines.inc"
include "JoystickTable.inc"

ext	ZPParam1

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
	lda		#0
	sta		joystick1Value
	sta		joystick1LastValue
	sta		joystick2Value
	sta		joystick2LastValue

	rts

updateJoysticks_:	public updateJoysticks_
	; Save last joystick values
	lda		Joystick1Value
	sta		Joystick1LastValue
	lda		Joystick2Value
	sta		Joystick2LastValue

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
	lda		Joystick1Buttons
	and		#$03

	sta		ZPParam1

	lda		Joystick1Direction
	beq		readJoystick1Buttons

	and		#$0F
	tay

	lda		joystickTable, y

readJoystick1Buttons:
	ora		ZPParam1
	sta		joystick1Value

	rts

readJoystick2:
	lda		Joystick2Buttons

	lsr		a
	lsr		a
	and		#$03

	sta		ZPParam1

	lda		Joystick2Direction
	beq		readJoystick2Buttons

	and		#$0F
	tay

	lda		joystickTable, y

readJoystick2Buttons:
	ora		ZPParam1
	sta		joystick2Value

	rts
