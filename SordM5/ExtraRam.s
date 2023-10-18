include "../../System/SystemDefines.inc"

ext	expandedRAMEnabled

cseg

; Sets expandedRAMEnabled
; 0: No memory expansion 
; 1: Memory expansion enabled
enableExpandedRAM:	public enableExpandedRAM
	call	bankInSRAM

	ld		b, 1

	ld		a, $55
	ld		(ExtraRAMStart), a
	ld		(ExtraRAMStart + ExtraRAMSize - 1), a

	ld		hl, ExtraRAMStart
	
	cp		(hl)
	jp		z, TestRam2

	ld		b, 0
	jp		exitCheckExpandedRam

TestRam2:
	ld		a, $AA
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 2), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 3), a

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4 * 2
	
	cp		(hl)
	jp		z, TestRam3

	ld		b, 0

	jp		exitCheckExpandedRam

TestRam3:
	ld		a, $81
	ld		(ExtraRAMStart), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 3), a

	ld		hl, ExtraRAMStart
	
	cp		(hl)
	jp		z, TestRam4

	ld		b, 0
	jp		exitCheckExpandedRam

TestRam4:
	ld		a, $42
	ld		(ExtraRAMStart + ExtraRAMSize / 4), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 2), a

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4
	
	cp		(hl)
	jp		z, exitCheckExpandedRam

	ld		b, 0

exitCheckExpandedRam:
	ld		a, b
	ld		(expandedRAMEnabled), a

	ret

bankInSRAM:
	ld		a, 1
	out		(BankControl), a

	ret
