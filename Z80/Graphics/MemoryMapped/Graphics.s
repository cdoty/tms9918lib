include "../../../../System/SystemDefines.inc"

cseg

; B - Value
; C - Register
writeVDPReg:	public writeVDPReg
	ld		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, b					; Write VDP data
	ld		(VDPBase + WriteOffset), a

	ld		a, $80					; Write VDP register | $80
	or		c
	ld		(VDPBase + WriteOffset), a

	ret
	
clearVRAM:	public clearVRAM
	ld		hl, 0
	ld		de, $4000

; HL: VRAM start address
; DE: Bytest to clear
clearVRAMWithParameters:	public clearVRAMWithParameters
	ld		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, l
	ld		(VDPBase + WriteOffset), a
	
	ld		a, h
	or		$40
	ld		(VDPBase + WriteOffset), a
	
clearVRAMLoop:
	xor		a
	ld		(VDPBase), a
		
	dec		de
	ld		a, d
	or		e
	
	jr		nz, clearVRAMLoop
	
	ld		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	ret
		
; void transferToVRAM(word _source, word _dest, word _size);
; HL: _source
; DE: _dest
; BC: _size
transferToVRAM_:	public transferToVRAM_
	ld		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, e
	ld		(VDPBase + WriteOffset), a
	
	ld		a, d
	or		$40
	ld		(VDPBase + WriteOffset), a
	
transferVRAMLoop:
	ld		a, (hl)
	ld		(VDPBase), a
		
	inc		hl
	dec		bc
	ld		a, b
	or		c
	
	jr		nz, transferVRAMLoop
	
	ld		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	ret
