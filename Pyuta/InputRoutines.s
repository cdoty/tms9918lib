include "../../System/SystemDefines.inc"

dseg

joystick1Value:	public joystick1Value
    ds	1

joystick1LastValue:
    ds	1

joystick2Value:	public joystick2Value
    ds	1

joystick2LastValue:
    ds	1

cseg

clearJoysticks_:	public clearJoysticks_
    dect	r10
	mov		r11, *r10

	; Clear joystick values
	clr		r0
	
	movb	@joystick1Value, r0
	movb	@joystick1LastValue, r0
	movb	@joystick2Value, r0
	movb	@joystick2LastValue, r0

    mov		*r10+, r11
	
	rt

updateJoysticks_:	public updateJoysticks_
    dect	r10
	mov		r11, *r10
    dect	r10
	mov		r1, *r10

	movb	r0, @Joystick1Value
	movb	@Joystick1LastValue, r0
	movb	r0, @Joystick2Value
	movb	@Joystick2LastValue, r0
	
	bl		@readJoystick1
	bl		@readJoystick2
	
    mov		*r10+, r1
    mov		*r10+, r11
	
	rt

readJoystick1_:	public readJoystick1_
    dect	r10
	mov		r11, *r10

	movb	@joystick1Value, r0

    mov		*r10+, r11
	
	rt

readJoystick2_:	public readJoystick2_
    dect	r10
	mov		r11, *r10

	movb	@joystick2Value, r0

    mov		*r10+, r11
	
	rt

readJoystick1:	public readJoystick1
	li		r12, Joystick1Address
	stcr	r0, 8

	swpb	r0

	mov		r0, r1
	andi	r0, $F0
	andi	r1, $0C
	srl		r0, 4
	srl		r1, 2

	soc		r1, r0

	swpb	r0
	mov		r0, @joystick1Value

	rt

readJoystick2:
	li		r12, Joystick2Address
	stcr	r0, 8

	swpb	r0

	mov		r0, r1
	andi	r0, $F0
	andi	r1, $0C
	srl		r0, 4
	srl		r1, 2

	soc		r1, r0

	swpb	r0
	mov		r0, @joystick2Value

	rt
