include "../../System/InputDefines.inc"

; Maps $40 to $4F to specific directions
joystickTable:
	db	JoypadDown
	db	JoypadDown
	db	JoypadDown
	db	JoypadDown OR JoypadRight
	db	JoypadRight
	db	JoypadRight
	db	JoypadRight
	db	JoypadUp OR JoypadRight
	db	JoypadUp
	db	JoypadUp
	db	JoypadUp
	db	JoypadUp OR JoypadLeft
	db	JoypadLeft
	db	JoypadLeft
	db	JoypadLeft
	db	JoypadDown OR JoypadLeft
