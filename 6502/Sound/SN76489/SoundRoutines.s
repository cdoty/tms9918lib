include "../../../../System/SystemDefines.inc"

cseg

resetSound:	public resetSound
	lda		#$9F
;	sta		SoundPort

	lda		#$BF
;	sta		SoundPort

	lda		#$DF
;	sta		SoundPort

	lda		#$FF
;	sta		SoundPort

	rts
