include "../../System/SystemDefines.inc"

ext	expandedRAMEnabled

cseg

; Sets expandedRAMEnabled
; 0: No memory expansion 
; 1: Memory expansion enabled
enableExpandedRAM:	public enableExpandedRAM
	ldx		#1

	lda		#$55
	sta		ExtraRAMStart
	sta		ExtraRAMStart + ExtraRAMSize - 1

	cmp		ExtraRAMStart
	bne		ExitTestRam1

	cmp		ExtraRAMStart + ExtraRAMSize - 1
	beq		TestRam2

ExitTestRam1:
	ldx		#0
	jmp		exitCheckExpandedRam

TestRam2:
	lda		#$AA
	sta		ExtraRAMStart + ExtraRAMSize / 4 * 2
	sta		ExtraRAMStart + ExtraRAMSize / 4 * 3

	cmp		ExtraRAMStart + ExtraRAMSize / 4 * 2
	bne		ExitTestRam2

	cmp		ExtraRAMStart + ExtraRAMSize / 4 * 3
	beq		TestRam3

ExitTestRam2:
	ldx		#0
	jmp		exitCheckExpandedRam

TestRam3:
	lda		#$81
	sta		ExtraRAMStart
	sta		ExtraRAMStart + ExtraRAMSize / 4 * 3

	cmp		ExtraRAMStart
	bne		ExitTestRam3

	cmp		ExtraRAMStart + ExtraRAMSize / 4 * 3
	beq		TestRam4

ExitTestRam3:
	ldx		#0
	jmp		exitCheckExpandedRam

TestRam4:
	lda		#$42
	sta		ExtraRAMStart + ExtraRAMSize / 4
	sta		ExtraRAMStart + ExtraRAMSize / 4 * 2

	cmp		ExtraRAMStart + ExtraRAMSize / 4
	bne		ExitTestRam4

	cmp		ExtraRAMStart + ExtraRAMSize / 4 * 2
	beq		exitCheckExpandedRam

ExitTestRam4:
	ldx		#0

exitCheckExpandedRam:
	stx		expandedRAMEnabled

	rts
