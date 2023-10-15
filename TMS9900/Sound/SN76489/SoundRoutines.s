include "../../../../System/SystemDefines.inc"

cseg

resetSound:	public resetSound
    dect	r10
	mov		r11, *r10

;	ld		a, $9F			; Set channel 1 volume to 15, which is silent (format: 1cc1vvvv)
;	ld		(SoundPort), a
	
;	ld		a, $BF			; Set channel 2 volume to 15, which is silent (format: 1cc1vvvv)
;	ld		(SoundPort), a

;	ld		a, $DF			; Set channel 3 volume to 15, which is silent (format: 1cc1vvvv)
;	ld		(SoundPort), a

;	ld		a, $FF			; Set noise channel volume to 15, which is silent (format: 1cc1vvvv)
;	ld		(SoundPort), a

    mov		*r10+, r11
	
	rt
