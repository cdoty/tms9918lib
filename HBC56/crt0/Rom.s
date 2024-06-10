include "../../../Game/GameDefines.inc"
include "../../../System/VRAMDefines.inc"

ext	startup

cseg

; Entry point. Jumped to through reset vector
_HBC56Entry:	public _HBC56Entry
	jmp	startup