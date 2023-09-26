include "../../../System/SystemDefines.inc"

ext	huffmunch_load
ext	huffmunch_read
ext	ZPParam1
ext	ZPCount
ext	HFMStart

zseg

decompressToVRAM_@Param0:	public decompressToVRAM_@Param0
	ds	2

decompressToVRAM_@Param1:	public decompressToVRAM_@Param1
	ds	2

cseg

; decompressToVRAM_@Param0 - Source
; decompressToVRAM_@Param1 - VRAM address
; Wipes out x, y, ZPCount/ZPCount+1
decompressToVRAM_:	public decompressToVRAM_
	sei

	lda		decompressToVRAM_@Param0
	sta		HFMStart

	lda		decompressToVRAM_@Param0 + 1
	sta		HFMStart + 1
	
	ldx		#0					; Always load file zero from compressed data
	ldy		#0
	
	jsr		huffmunch_load

	stx		ZPCount				; Store the uncompressed size as the count

	iny							; Account for high byte bne branch
	sty		ZPCount + 1

	; Ensure we are writing to the first byte
;	lda		VDPReadBase + WriteOffset

	; Set VRAM address
	lda		decompressToVRAM_@Param1	
	sta		VDPBase + WriteOffset
	
	lda		decompressToVRAM_@Param1 + 1
	ora		#$40
	sta		VDPBase + WriteOffset
	
decompressToVRAMLoop:
	jsr		huffmunch_read
	
	sta		VDPBase
	
	dec		ZPCount
	bne		decompressToVRAMLoop
	
	dec		ZPCount + 1
	bne		decompressToVRAMLoop

	cli
	
	rts
