include "../../System/SystemDefines.inc"

ext	expandedRAMEnabled

cseg

; Sets expandedRAMEnabled
; 0: No memory expansion 
; 1: Memory expansion enabled
enableExpandedRAM:	public enableExpandedRAM
	; See if memory expansion is already enabled
	call	checkExpandedRAM

	cp		1
	jr		z, exitEnableExpandedRAM

	; If not, try to enable it
	call	enableRAMExpansion

	; Check again to make sure it was enabled
	call	checkExpandedRAM

exitEnableExpandedRAM:
	ret

; Return A - 0: No memory expansion  1: Memory expansion present
checkExpandedRAM:
	ld		b, 1

	xor		a

	ld		(RAMStart), a
	ld		(RAMStart + DefaultRamSize), a
	ld		(RAMStart + DefaultRamSize * 2), a
	ld		(RAMStart + DefaultRamSize * 3), a

	ld		a, $11
	ld		(RAMStart), a

	ld		a, $22
	ld		(RAMStart + DefaultRamSize), a

	ld		hl, RAMStart
	
	cp		(hl)
	jp		nz, TestRam2

	ld		b, 0

	jp		exitCheckExpandedRam

TestRam2:
	ld		a, $33
	ld		(RAMStart + DefaultRamSize * 2), a

	ld		a, $44
	ld		(RAMStart + DefaultRamSize * 3), a

	ld		hl, RAMStart + DefaultRamSize * 2
	
	cp		(hl)
	jp		nz, TestRam3

	ld		b, 0

	jp		exitCheckExpandedRam

TestRam3:
	ld		a, $55
	ld		(RAMStart), a

	ld		a, $AA
	ld		(RAMStart + DefaultRamSize * 3), a

	ld		hl, RAMStart
	
	cp		(hl)
	jp		nz, TestRam4

	ld		b, 0

	jp		exitCheckExpandedRam

TestRam4:
	ld		a, $99
	ld		(RAMStart + DefaultRamSize), a

	ld		a, $66
	ld		(RAMStart + DefaultRamSize * 2), a

	ld		hl, RAMStart + DefaultRamSize
	
	cp		(hl)
	jp		nz, exitCheckExpandedRam

	ld		b, 0

exitCheckExpandedRam:
	ld		a, b
	ld		(expandedRAMEnabled), a

	ret

enableRAMExpansion:
	ld		a, 1
	out		(MemoryExpansionPort), a

	ret
