include "../../../System/SystemDefines.inc"

ext	transferToVRAM_

cseg

; R0 = source address
; R1 = VRAM destination
; R2 Size
; This is a placeholder for an actual decompression routine.
decompressToVRAM_:	public decompressToVRAM_
    dect	r10
	mov		r11, *r10

	; Swap parameters
	mov		r0, r3
	mov		r1, r0
	mov		r3, r1

	bl		@transferToVRAM_
	
    mov		*r10+, r11
	
	rt
