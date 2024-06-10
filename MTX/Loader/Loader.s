ext	startup
ext	MTXEnd
ext	nmiHandler

BaseMem		equ	$8000
MTXStart	equ	$8100

_MTXLOADER:	public _MTXLOADER
cseg
	
	db	$FF

_GAMETITLE:	public _GAMETITLE
include	"../../../System/Title.inc"
	dw	$F8F2
	
	ds	$160

	db  $00, $F2, $F8, $02, $00, $00, $00, $00
	db	$00, $00, $00, $0A, $F9, $02, $00, $00
	db	$00, $00, $00, $00, $00, $22, $F9, $02
	db	$00, $00, $00, $00, $00, $00, $00, $3A
	db	$F9, $02, $00, $00, $00, $00, $00, $00
	
	db	0						; LSTPG
	dw	$C000					; VARNAM
	dw	$C001					; VALBOT
	dw	$C001					; CALCBOT
	dw	$C001					; CALCST
	dw	$FB4B					; KBDBUF
	db	$00, $00, $00, $00		; USYNT
	db	$00, $C9, $C9			; USER
	db	$00, $00, $00			; $FA8C
	db	$01						; IOPL
	db	$FF						; REALBY
	db	$80						; KBFLAG
	dw	$F8F2					; STKLIM
	dw	$FB4B					; SYSTOP
	dw	$FD48					; SSTACK
	db	$C9, $00, $00			; USERINT
	db	$C9, $00, $00			; NODLOC
	db	$C9, $00, $00			; FEXPAND
	db	$C9, $00, $00			; USERNOD
	dw	EndEntry - StartHeader	; NBTOP
	db	0						; NBTPG
	dw	EndEntry - StartHeader	; BASTOP
	db	0						; BASTPG
	dw	$4000					; BASBOT
	dw	EndEntry - StartHeader
	ds	30, 0
	dw 	EndEntry - StartHeader	; ARRTOP
	db 	0						; ARRTPG
	dw 	BaseMem					; BASELIN
	db 	0						; BASLNP
	db 	0						; PAGE
	db 	0						; CRNTPG
	db 	0						; PGN1
	db 	0						; PGN2
	dw	EndEntry - StartHeader	; PGTOP
	ds	105, 0
	dw 	$FAD8					; GOPTR
	dw 	0						; GOSNUM
	db 	0						; CTYLST
	dw 	BaseMem					; DATAAD
	db 	$80						; DATAPG
	dw 	EndHeader - StartHeader + BaseMem - 1	; DESAVE
	
StartHeader:
	dw	EndHeader - StartHeader, 5
	db	$80, $FF
EndHeader:

StartEntry:
	dw	EndEntry - StartEntry, 10
	db	$C2
	dw	EndLoader - StartLoader

StartLoader:
	ld		a, 0
	ld		($FD67), a
	ld		a, 1
	ld		($FD68), a
	
	ld		hl, MTXStart			; Load the main file
	ld		de, MTXEnd - MTXStart
	call	$AAE
	
	jp		startup					; Start the game

EndLoader:
	db	$FF		; End of Basic marker

EndEntry:
	db	$FF		; End of Basic variables marker
