ext startup

cseg

; This needs to be here so the boot program can jump to a known location.
_ADAMDDPEntry:	public _ADAMDDPEntry
	jp	startup
