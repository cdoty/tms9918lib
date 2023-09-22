ext	startup

cseg

_SORDM5ENTRY:	public _SORDM5ENTRY
	db	1	; 0 =  8 KB from 2000H  1 =  8 KB from 4000H  2 = 16 KB from 2000H

include "Common.inc"