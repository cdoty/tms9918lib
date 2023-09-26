include "../../System/InputDefines.inc"

; Maps $40 to $4F to specific directions
joystickTable:
	db	Down
	db	Down
	db	Down
	db	Down OR Right
	db	Right
	db	Right
	db	Right
	db	Up OR Right
	db	Up
	db	Up
	db	Up
	db	Up OR Left
	db	Left
	db	Left
	db	Left
	db	Down OR Left
