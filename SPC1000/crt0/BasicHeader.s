ext	_SPC1000ENTRY

cseg

_BASICHEADER:	public _BASICHEADER
	db	$7C				; Basic header
	db	$A6
	dw	10				; Line number
	db	$B9 			; Call basic token
	db	$11				; Hexidecimal prefix
	dw	_SPC1000ENTRY	; Call location
	db	0, 0, 0			; Pad to $7CA8
