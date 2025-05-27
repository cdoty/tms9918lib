include "../../../../System/SystemDefines.inc"

cseg

; R1 - Value << 8 | Register
writeVDPReg:	public writeVDPReg
    dect	r10
	mov		r11, *r10

	movb	@VDPBase, r0 				; Reset register write mode
	
	movb	r1, @VDPBase + WriteOffset	; Write VDP data
	swpb	r1
	movb	r1, @VDPBase + WriteOffset 	; Write VDP register | 80h
	
    mov		*r10+, r11
	
	rt
	
; R1 - VRAM Start address
; R2 - Bytes to clear
clearVRAMWithParameters:	public clearVRAMWithParameters
    dect	r10
	mov		r11, *r10

	b		@clearVRAMParamEntry

; void clearVRAM(_vramAddress, _byteCount);
clearVRAM:	public clearVRAM
    dect	r10
	mov		r11, *r10

	clr		r1				; Start at address 0, in VRAM
	li		r2, $4000		; Write 4000h bytes

clearVRAMParamEntry:
	clr		r0				; R0 contains the value written to VRAM
	ori		r1, $4000		; Or with 4000h to indicate it's a VRAM write
	
	swpb	r1				; Write low byte first. movb transfer from the high byte of a word.
	movb	r1, @VDPBase + WriteOffset

	swpb	r1
	movb	r1, @VDPBase + WriteOffset
		
ClearVRAMLoop:
	movb	r0, @VDPBase
	
	dec		r2
	jne		ClearVRAMLoop
	
	movb	@VDPReadBase + WriteOffset, r0 	; Acknowledge interrupt

    mov		*r10+, r11
	
	rt
		
; R0: VRAM address
; R1: Value
writeToVRAM_:	public writeToVRAM_
    dect	r10
	mov		r11, *r10

	ori		r0, $4000		; Or with 4000h to indicate it's a VRAM write
	
	swpb	r0				; Write low byte first. movb transfer from the high byte of a word.
	movb	r0, @VDPBase + WriteOffset

	swpb	r0
	movb	r0, @VDPBase + WriteOffset
				
	movb	r1, @VDPBase

    mov		*r10+, r11

	rt

; R0: VRAM address
; R1: Source address
; R2: Number of bytes to transfer
transferToVRAM_:	public transferToVRAM_
    dect	r10
	mov		r11, *r10

	ori		r0, $4000		; Or with 4000h to indicate it's a VRAM write
	
	swpb	r0				; Write low byte first. movb transfer from the high byte of a word.
	movb	r0, @VDPBase + WriteOffset

	swpb	r0
	movb	r0, @VDPBase + WriteOffset
				
transferToVRAMLoop:
	movb	*r1+, @VDPBase
	
	dec		r2
	jne		transferToVRAMLoop
	
	movb	@VDPReadBase + WriteOffset, r0 	; Acknowledge interrupt

    mov		*r10+, r11
	
	rt
