.include "m16Adef.inc"

; gavrasm foo.asm
; avrdude -p m16 -c usbasp -U foo.hex

.org 0x00
	rjmp main

.org INT0addr
	rjmp up_button

.org INT1addr
	rjmp down_button

.org OVF0addr
	rjmp update_display

main:
	; enable stack pointer
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r16, low(RAMEND)
	out SPL, r16

	; PA0-PA6: rows
	ldi r16, 0b01111111
	out DDRA, r16

	; PC1-PC5: cols
	ldi r16, 0b00111110
	out DDRC, r16

	; create 8 bit timer counter for the display. prescaler is clock/8 --> 1MHz
	ldi r16, (1 << CS01)
	out TCCR0, r16

	; enable an interrupt when the timer counter overflows --> interrupt triggers every 1MHz/256 --> ~4kHz
	ldi r16, (1 << TOIE0)
	out TIMSK, r16

	; INT0 und INT1 auf fallende Flanke konfigurieren
	ldi r16, (1 << ISC01) | (1 << ISC11)
	out MCUCR, r16

	; INT0 und INT1 aktivieren
	ldi r16, (1 << INT0) | (1 << INT1)
	out GICR, r16

	; pattern buffer (port order is a bit messed up ;-)))
	ldi r20, 0b00100000
	ldi r26, 0b00010000
	ldi r25, 0b00001000
	ldi r24, 0b00000100
	ldi r23, 0b00000010
	ldi r22, 0b00110000
	ldi r21, 0b00001100

	; current row number
	ldi r27, 0

	; current row bits
	ldi r28, 0b10000000

	; current input number
	ldi r29, 0

	; enable interrupts
	sei

loop:
	rjmp loop

;;;;;;;;;;;;;;;;;;
; BUTTON HANDLER ;
;;;;;;;;;;;;;;;;;;

up_button:
	; do nothing if upper bound is reached
	cpi r29, 15
	brge do_nothing

	; increment input number
	inc r29

	rjmp display_input_number

down_button:
	; do nothing if lower bound is reached
	cpi r29, 0
	breq do_nothing

	; decrement input number
	dec r29

	rjmp display_input_number

do_nothing:
	reti

patterns:
	; 0
	.db 0b00011100, 0b00100010, 0b00100010, 0b00100010, 0b00100010, 0b00100010, 0b00011100, 0
	; 1
	.db 0b00000110, 0b00011010, 0b00110010, 0b00000010, 0b00000010, 0b00000010, 0b00000010, 0
	; 2
	.db 0b00011100, 0b00100010, 0b00000010, 0b00000100, 0b00001000, 0b00010000, 0b00111110, 0
	; 3
	.db 0b00111110, 0b00000010, 0b00000010, 0b00111110, 0b00000010, 0b00000010, 0b00111110, 0
	; 4
	.db 0b00100010, 0b00100010, 0b00100010, 0b00111110, 0b00000010, 0b00000010, 0b00000010, 0
	; 5
	.db 0b00111110, 0b00100000, 0b00100000, 0b00111100, 0b00000010, 0b00000010, 0b00111100, 0
	; 6
	.db 0b00011110, 0b00100000, 0b00100000, 0b00111100, 0b00100010, 0b00100010, 0b00011100, 0
	; 7
	.db 0b00111110, 0b00000010, 0b00000100, 0b00011100, 0b00010000, 0b00100000, 0b00100000, 0
	; 8
	.db 0b00011100, 0b00100010, 0b00100010, 0b00011100, 0b00100010, 0b00100010, 0b00011100, 0
	; 9
	.db 0b00011100, 0b00100010, 0b00100010, 0b00011110, 0b00000010, 0b00000010, 0b00111100, 0
	; A
	.db 0b00011100, 0b00100010, 0b00100010, 0b00111110, 0b00100010, 0b00100010, 0b00100010, 0
	; B
	.db 0b00111100, 0b00100010, 0b00100010, 0b00111100, 0b00100010, 0b00100010, 0b00111100, 0
	; C
	.db 0b00011110, 0b00100000, 0b00100000, 0b00100000, 0b00100000, 0b00100000, 0b00011110, 0
	; D
	.db 0b00111100, 0b00100010, 0b00100010, 0b00100010, 0b00100010, 0b00100010, 0b00111100, 0
	; E
	.db 0b00111110, 0b00100000, 0b00100000, 0b00111110, 0b00100000, 0b00100000, 0b00111110, 0
	; F
	.db 0b00111110, 0b00100000, 0b00100000, 0b00111110, 0b00100000, 0b00100000, 0b00100000, 0

display_input_number:
	; calculate pattern address
	ldi ZH, HIGH(patterns*2)
	ldi ZL, LOW(patterns*2)

	ldi r16, 8
	mul r16, r29
	add ZL, r0

	lpm r20, Z+
	lpm r26, Z+
	lpm r25, Z+
	lpm r24, Z+
	lpm r23, Z+
	lpm r22, Z+
	lpm r21, Z+

	reti

;;;;;;;;;;;;;;;;;;;;;;;;
; DISPLAY MULTIPLEXING ;
;;;;;;;;;;;;;;;;;;;;;;;;

update_display:
	; turn off row that we want to enable
	mov r16, r28
	com r16
	out PORTA, r16

	cpi r27, 0
	breq row_0
	cpi r27, 1
	breq row_1
	cpi r27, 2
	breq row_2
	cpi r27, 3
	breq row_3
	cpi r27, 4
	breq row_4
	cpi r27, 5
	breq row_5
	cpi r27, 6
	breq row_6

row_0:
	out PORTC, r20
	rjmp continue_update_display
row_1:
	out PORTC, r21
	rjmp continue_update_display
row_2:
	out PORTC, r22
	rjmp continue_update_display
row_3:
	out PORTC, r23
	rjmp continue_update_display
row_4:
	out PORTC, r24
	rjmp continue_update_display
row_5:
	out PORTC, r25
	rjmp continue_update_display
row_6:
	out PORTC, r26
	rjmp continue_update_display

continue_update_display:
	; increment current row when it is less than 7
	cpi r27, 7
	brlt next_row

	; reset
	ldi r27, 0
	ldi r28, 0b10000000

	reti

next_row:
	inc r27
	lsr r28

	reti
