include "../../System/SystemDefines.inc"

ext	expandedRAMEnabled

cseg

; Sets expandedRAMEnabled
; 0: No memory expansion 
; 1: Memory expansion enabled
enableExpandedRAM:	public enableExpandedRAM
	ld		b, 1

	ld		a, $55
	ld		(ExtraRAMStart), a
	ld		(ExtraRAMStart + ExtraRAMSize - 1), a

	ld		hl, ExtraRAMStart
	cp		(hl)
	jp		nz, ExitTestRam1

	ld		hl, ExtraRAMStart + ExtraRAMSize - 1
	cp		(hl)
	jp		z, TestRam2

ExitTestRam1:
	ld		b, 0
	jp		exitCheckExpandedRam

TestRam2:
	ld		a, $AA
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 2), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 3), a

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4 * 2
	cp		(hl)
	jp		nz, ExitTestRam2

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4 * 3
	cp		(hl)
	jp		z, TestRam3

ExitTestRam2:
	ld		b, 0
	jp		exitCheckExpandedRam

TestRam3:
	ld		a, $81
	ld		(ExtraRAMStart), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 3), a

	ld		hl, ExtraRAMStart
	cp		(hl)
	jp		nz, ExitTestRam3

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4 * 3
	cp		(hl)
	jp		z, TestRam4

ExitTestRam3:
	ld		b, 0
	jp		exitCheckExpandedRam

TestRam4:
	ld		a, $42
	ld		(ExtraRAMStart + ExtraRAMSize / 4), a
	ld		(ExtraRAMStart + ExtraRAMSize / 4 * 2), a

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4
	cp		(hl)
	jp		nz, ExitTestRam4

	ld		hl, ExtraRAMStart + ExtraRAMSize / 4 * 2
	cp		(hl)
	jp		z, exitCheckExpandedRam

ExitTestRam4:
	ld		b, 0

exitCheckExpandedRam:
	ld		a, b
	ld		(expandedRAMEnabled), a

	ret
