include "../../../../System/SystemDefines.inc"

cseg

; D - Value
; E - Register
writeVDPReg:	public writeVDPReg
	ld		d, b
	ld		e, c

	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)					; Reset register write mode
	
	ld		bc, VDPBase + WriteOffset

	ld		a, d					; Write VDP data
	out		(c), a

	ld		a, $80					; Write VDP register | $80
	or		e
	out		(c), a

	ret
	
clearVRAM:	public clearVRAM
	ld		hl, 0
	ld		de, $4000

; HL: VRAM start address
; DE: Bytest to clear
clearVRAMWithParameters:	public clearVRAMWithParameters
	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)				; Reset register write mode
	
	ld		bc, VDPBase + WriteOffset
	ld		a, l
	out		(c), a
	
	ld		a, h
	or		$40
	out		(c), a
	
	ld		bc, VDPBase

clearVRAMLoop:
	xor		a
	out		(c), a
		
	dec		de
	ld		a, d
	or		e
	
	jr		nz, clearVRAMLoop
	
	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)			; Acknowledge interrupt

	ret
		
; A value
; DE: _dest
writeToVRAM_:	public writeToVRAM_
	ld		b, a

	push	bc
	
	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)	; Reset register write mode

	ld		bc, VDPBase + WriteOffset

	ld		a, e
	out		(c), a
	
	ld		a, d
	or		$40
	out		(c), a
	
	pop		bc
	
	ld		a, b
	out		(VDPBase), a

	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)		; Acknowledge interrupt

	ret

; HL: _source
; DE: _dest
; BC: _size
transferToVRAM_:	public transferToVRAM_
	push	bc

	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)	; Reset register write mode
	
	ld		bc, VDPBase + WriteOffset

	ld		a, e
	out		(c), a
	
	ld		a, d
	or		$40
	out		(c), a
	
	; Pop bc into de
	pop		de

	ld		bc, VDPBase

transferVRAMLoop:
	ld		a, (hl)
	out		(c), a
		
	inc		hl
	dec		de
	ld		a, d
	or		e
	
	jr		nz, transferVRAMLoop
	
	ld		bc, VDPReadBase + WriteOffset
	in		a, (c)		; Acknowledge interrupt

	ret
