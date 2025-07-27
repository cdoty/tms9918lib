include "../../../System/SystemDefines.inc"

ext	expandedRAMEnabled

cseg

; Sets expandedRAMEnabled
; 0: No memory expansion 
; 1: Memory expansion enabled
enableExpandedRAM:	public enableExpandedRAM
    dect	r10
	mov		r11, *r10

	li		r2, 1

	li		r0, $5555
	mov		r0, @ExtraRAMStart
	mov		r0, @ExtraRAMStart + ExtraRAMSize - 2

	mov		@ExtraRAMStart, r0
	mov		@ExtraRAMStart + ExtraRAMSize - 2, r1
	
	ci		r0, $5555
	jne		ExitTest1

	ci		r1, $5555
	jeq		TestRam2

ExitTest1:
	li		r2, 0
	jmp		exitCheckExpandedRam

TestRam2:
	li		r0, $AAAA
	mov		r0, @ExtraRAMStart + ExtraRAMSize / 4 * 2
	mov		r0, @ExtraRAMStart + ExtraRAMSize / 4 * 3

	mov		@ExtraRAMStart + ExtraRAMSize / 4 * 2, r0
	mov		@ExtraRAMStart + ExtraRAMSize / 4 * 3, r1
	
	ci		r0, $AAAA
	jne		ExitTest2

	ci		r1, $AAAA
	jeq		TestRam3

ExitTest2:
	li		r2, 0
	jmp		exitCheckExpandedRam

TestRam3:
	li		r0, $8181
	mov		r0, @ExtraRAMStart
	mov		r0, @ExtraRAMStart + ExtraRAMSize / 4 * 3

	mov		@ExtraRAMStart, r0
	mov		@ExtraRAMStart + ExtraRAMSize / 4 * 3, r1
	
	ci		r0, $8181
	jne		ExitTest3

	ci		r1, $8181
	jeq		TestRam4

ExitTest3:
	li		r2, 0
	jmp		exitCheckExpandedRam

TestRam4:
	li		r0, $4242
	mov		r0, @ExtraRAMStart + ExtraRAMSize / 4
	mov		r0, @ExtraRAMStart + ExtraRAMSize / 4 * 2

	mov		@ExtraRAMStart + ExtraRAMSize / 4, r0
	mov		@ExtraRAMStart + ExtraRAMSize / 4 * 2, r1
	
	ci		r0, $4242
	jne		ExitTest4

	ci		r1, $4242
	jeq		exitCheckExpandedRam

ExitTest4:
	li		r2, 0

exitCheckExpandedRam:
	mov		r2, @expandedRAMEnabled

    mov		*r10+, r11
	
	rt
