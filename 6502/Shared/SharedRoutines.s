include "../../../System/SystemDefines.inc"

ext	ZPDestination
ext	ZPCount

cseg

startupDelay:	public startupDelay
	ldx		#$FF		; Set the total number of bytes to clear
	ldy		#$FF
	
startupDelayLoop:
	dex	
	bne		startupDelayLoop
	
	dey	
	bne		startupDelayLoop

	rts

clearRam:	public clearRam
	lda		#LOW(RAMSize)
	sta		ZPCount

	lda		#HIGH(RAMSize)
	sta		ZPCount + 1

	lda		#LOW(RAMStart)
	sta		ZPDestination

	lda		#HIGH(RamStart)
	sta		ZPDestination + 1

	lda		#0
	ldy		#0

clearRamLoop:
	sta		(ZPDestination), y

	iny

	dec		ZPCount
	bne		clearRamLoop

	dec		ZPCount + 1
	bne		clearRamLoop

	rts
