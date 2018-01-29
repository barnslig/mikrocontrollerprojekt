.include "m16Adef.inc"

; gavrasm main.asm
; avrdude -p m16 -c usbasp -U main.hex

.equ DEBOUNCE_COUNT = 20

; uart configuration. see datasheet page 147
.equ F_CPU = 4000000
.equ BAUD  = 9600
.equ MYUBRR = F_CPU/16/BAUD-1

.org 0x00
	rjmp main

.org INT0addr
	rjmp up_button

.org INT1addr
	rjmp down_button

.org OVF2addr
	rjmp update_button_debounce

.org OVF0addr
	rjmp update_display

.org URXCaddr
	rjmp receive_value

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

	; create 8 bit timer counter for button debouncing. prescaler is clock/1024 --> ~4kHz
	ldi r16, (1 << CS20) | (1 << CS22)
	out TCCR2, r16

	; create 8 bit timer counter for the display. prescaler is clock/8 --> 500kHz
	ldi r16, (1 << CS01)
	out TCCR0, r16

	; enable interrupts when the timer counters overflow
	; display interval: 500kHz/256 --> ~2kHz --> 200ms
	; button debouncer interval: 4kHz/256 --> ~15Hz --> 66ms
	ldi r16, (1 << TOIE0) | (1 << TOIE2)
	out TIMSK, r16

	; INT0 und INT1 auf steigende Flanke konfigurieren
	ldi r16, (1 << ISC01) | (1 << ISC11)
	out MCUCR, r16

	; INT0 und INT1 aktivieren
	ldi r16, (1 << INT0) | (1 << INT1)
	out GICR, r16

	; set uart baudrate
	ldi r16, HIGH(MYUBRR)
	out UBRRH, r16
	ldi r16, LOW(MYUBRR)
	out UBRRL, r16

	; set uart frame format: 8data, 2stop bit
	ldi r16, (1 << URSEL) | (1 << USBS) | (3 << UCSZ0)
	out UCSRC, r16

	; enable uart receive and transmit
	ldi r16, (1 << RXEN) | (1 << TXEN)
	out UCSRB, r16

	; enable uart receive interrupt
	sbi UCSRB, RXCIE

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

	; button debounce counter
	ldi r17, 0

	; enable interrupts
	sei

loop:
	rjmp loop

do_nothing:
	reti

display_input_number:
	rcall transmit_input_number

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

	ret

;;;;;;;;;;;;;;;;
; UART HANDLER ;
;;;;;;;;;;;;;;;;

transmit_input_number:
	cpi r29, 10
	brge transmit_input_character

	ldi r16, 48
	add r16, r29
	out UDR, r16

	ret

transmit_input_character:
	ldi r16, 55
	add r16, r29
	out UDR, r16

	ret

receive_value:
	in r16, UDR

	; ASCII 48-57: 0-9
	; ASCII 65-70: A-F
	cpi r16, 48
	brlt do_nothing
	cpi r16, 71
	brge do_nothing
	cpi r16, 58
	brlt receive_value_number
	cpi r16, 65
	brlt do_nothing

	subi r16, 55
	mov r29, r16

	rcall display_input_number

	reti

receive_value_number:
	subi r16, 48
	mov r29, r16

	rcall display_input_number

	reti

;;;;;;;;;;;;;;;;;;
; BUTTON HANDLER ;
;;;;;;;;;;;;;;;;;;

update_button_debounce:
	cpi r17, 0
	breq do_nothing

	dec r17
	reti

up_button:
	; do nothing if button debounce counter is not zero
	cpi r17, 0
	brne do_nothing

	; do nothing if upper bound is reached
	cpi r29, 15
	brge do_nothing

	; increment input number
	inc r29

	; set button debounce counter
	ldi r17, DEBOUNCE_COUNT

	rcall display_input_number

	reti

down_button:
	; do nothing if button debounce counter is not zero
	cpi r17, 0
	brne do_nothing

	; do nothing if lower bound is reached
	cpi r29, 0
	breq do_nothing

	; decrement input number
	dec r29

	; set button debounce counter
	ldi r17, DEBOUNCE_COUNT

	rcall display_input_number

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
