include "../../../../System/SystemDefines.inc"

cseg

resetSound:	public resetSound
	lda		#$22		; Set port B for input, select DDR register
	sta		CRBPort

	lda		#$FF		; Set PIO port bits as output, in DDR register
	sta		PIOBPort

	lda		#$26		; Select PIO register
	sta		CRBPort

	lda		#$9F		; Write to sound chip
	jsr		writeSoundRegister

	lda		#$BF		; Write to sound chip
	jsr		writeSoundRegister

	lda		#$DF		; Write to sound chip
	jsr		writeSoundRegister

	lda		#$FF		; Write to sound chip
	jsr		writeSoundRegister

	jsr		$FE54

	rts

writeSoundRegister:
	sta		PIOBPort

checkComplete:
	lda		CRBPort
	bpl		checkComplete

	lda		PIOBPort

	rts
