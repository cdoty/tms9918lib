include "../../../../System/SystemDefines.inc"

ext	ZPParam1
ext	ZPParam2

zseg

writeToVRAM_@Param0:	public writeToVRAM_@Param0
transferToVRAM_@Param0:	public transferToVRAM_@Param0
	ds	2

writeToVRAM_@Param1:	public writeToVRAM_@Param1
transferToVRAM_@Param1:	public transferToVRAM_@Param1
	ds	2

transferToVRAM_@Param2:	public transferToVRAM_@Param2
	ds	2

cseg

; ZPParam1 - Value
; ZPParam2 - Register
writeVDPReg:	public writeVDPReg
	; Ensure we are writing to the first byte
	lda		VDPReadBase + WriteOffset

	; Write VDP register
	lda		ZPParam1
	sta		VDPBase + WriteOffset

	lda		#$80
	ora		ZPParam2
	sta		VDPBase + WriteOffset

	rts
	
clearVRAM:	public clearVRAM
	; Ensure we are writing to the first byte	
	lda		VDPReadBase + WriteOffset

	; Set VRAM address
	lda		#0				
	sta		VDPBase + WriteOffset

	lda		#0
	ora		#$40
	sta		VDPBase + WriteOffset
	
	; Set the total number of bytes to clear
	ldx		#$00
	ldy		#$40
	
	lda		#0

clearVRAMLoop:
	sta		VDPBase
	
	dex	
	bne		clearVRAMLoop
	
	dey	
	bne		clearVRAMLoop

	rts
		
; Parameter 0 - _value
; Parameter 1 - _dest
writeToVRAM_:	public writeToVRAM_
	; Ensure we are writing to the first byte
	lda		VDPReadBase + WriteOffset

	; Set VRAM address
	lda		writeToVRAM_@Param1
	sta		VDPBase + WriteOffset

	lda		writeToVRAM_@Param1 + 1
	ora		#$40
	sta		VDPBase + WriteOffset
	
	lda		writeToVRAM_@Param0
	sta		VDPBase

	rts

; Parameter 0 - _source
; Parameter 1 - _dest
; Parameter 2 - _size
transferToVRAM_:	public transferToVRAM_
	; Ensure we are writing to the first byte
	lda		VDPReadBase + WriteOffset

	; Set VRAM address
	lda		transferToVRAM_@Param1
	sta		VDPBase + WriteOffset

	lda		transferToVRAM_@Param1 + 1
	ora		#$40
	sta		VDPBase + WriteOffset
	
	ldx		transferToVRAM_@Param2
	ldy		#0

transferVRAMLoop:
	lda		(transferToVRAM_@Param0), y
	sta		VDPBase
	
	iny

	dex
	bne		transferVRAMLoop

	rts
