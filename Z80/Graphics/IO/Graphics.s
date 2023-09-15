include "../../../../Platform/Defines.inc"

cseg

; B - Value
; C - Register
writeVDPReg:	public writeVDPReg
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, b					; Write VDP data
	out		(VDPBase + WriteOffset), a

	ld		a, $80					; Write VDP register | $80
	or		c
	out		(VDPBase + WriteOffset), a

	ret
	
clearVRAM:	public clearVRAM
	ld		hl, 0
	ld		de, $4000

	ld		a, l
	out		(VDPBase + WriteOffset), a
	
	ld		a, h
	or		$40
	out		(VDPBase + WriteOffset), a
	
clearVRAMLoop:
	xor		a
	ld		(VDPBase), a
		
	dec		de
	ld		a, d
	or		e
	
	jr		nz, clearVRAMLoop
	
	in		a, (VDPReadBase + WriteOffset)	; Acknowldge interrupt

	ret
		
; void transferToVRAM(word _source, word _dest, word _size);
; HL: _source
; DE: _dest
; BC: _size
transferToVRAM_:	public transferToVRAM_
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, e
	ld		(VDPBase + WriteOffset), a
	
	ld		a, d
	or		$40
	out		(VDPBase + WriteOffset), a
	
transferVRAMLoop:
	ld		a, (hl)
	out		(VDPBase), a
		
	inc		hl
	dec		bc
	ld		a, b
	or		c
	
	jr		nz, transferVRAMLoop
	
	in		a, (VDPReadBase + WriteOffset)	; Acknowldge interrupt

	ret
