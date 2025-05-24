include "../../../System/SystemDefines.inc"

ext	ZPDestination
ext	ZPCount

dseg

expandedRAMEnabled:	public	expandedRAMEnabled
	ds	1

spriteMagnification:	public spriteMagnification
	ds	1

cseg

expandedRAMAvailable_:	public expandedRAMAvailable_
	ldy		expandedRAMEnabled
	
	rts

enableSpriteMagnification_:	public enableSpriteMagnification_
	lda		#1
	sta		spriteMagnification

	rts

disableSpriteMagnification_:	public disableSpriteMagnification_
	lda		#0
	sta		spriteMagnification

	rts

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

setupLibrary:	public setupLibrary
	lda		#0
	sta		expandedRAMEnabled
	sta		spriteMagnification
	
	rts
