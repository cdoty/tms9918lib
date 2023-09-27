	ext	startup
	ext	CassetteEnd

_MSXCASSETTEHEADER:	public _MSXCASSETTEHEADER
	dw	$C000
	dw	CassetteEnd
	dw	startup