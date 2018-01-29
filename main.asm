.include "m16Adef.inc"

; gavrasm main.asm
; avrdude -p m16 -c usbasp -U main.hex

.equ DEBOUNCE_COUNT = 20

; uart configuration. see datasheet page 147
.equ F_CPU = 4000000
.equ BAUD  = 9600
.equ MYUBRR = F_CPU/16/BAUD-1

; register names
.def temp = r16
.def btn_debounce_counter = r17
.def current_row = r27
.def current_row_bit = r28
.def current_number = r29

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
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

	; PA0-PA6: rows
	ldi temp, 0b01111111
	out DDRA, temp

	; PC1-PC5: cols
	ldi temp, 0b00111110
	out DDRC, temp

	; create 8 bit timer counter for button debouncing. prescaler is clock/1024 --> ~4kHz
	ldi temp, (1 << CS20) | (1 << CS22)
	out TCCR2, temp

	; create 8 bit timer counter for the display. prescaler is clock/8 --> 500kHz
	ldi temp, (1 << CS01)
	out TCCR0, temp

	; enable interrupts when the timer counters overflow
	; display interval: 500kHz/256 --> ~2kHz --> 200ms
	; button debouncer interval: 4kHz/256 --> ~15Hz --> 66ms
	ldi temp, (1 << TOIE0) | (1 << TOIE2)
	out TIMSK, temp

	; INT0 und INT1 auf steigende Flanke konfigurieren
	ldi temp, (1 << ISC01) | (1 << ISC11)
	out MCUCR, temp

	; INT0 und INT1 aktivieren
	ldi temp, (1 << INT0) | (1 << INT1)
	out GICR, temp

	; set uart baudrate
	ldi temp, HIGH(MYUBRR)
	out UBRRH, temp
	ldi temp, LOW(MYUBRR)
	out UBRRL, temp

	; set uart frame format: 8data, 2stop bit
	ldi temp, (1 << URSEL) | (1 << USBS) | (3 << UCSZ0)
	out UCSRC, temp

	; enable uart receive and transmit
	ldi temp, (1 << RXEN) | (1 << TXEN)
	out UCSRB, temp

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
	ldi current_row, 0

	; current row bits
	ldi current_row_bit, 0b10000000

	; current input number
	ldi current_number, 0

	; button debounce counter
	ldi btn_debounce_counter, 0

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

	ldi temp, 8
	mul temp, current_number
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
	cpi current_number, 10
	brge transmit_input_character

	ldi temp, 48
	add temp, current_number
	out UDR, temp

	ret

transmit_input_character:
	ldi temp, 55
	add temp, current_number
	out UDR, temp

	ret

receive_value:
	in temp, UDR

	; ASCII 48-57: 0-9
	; ASCII 65-70: A-F
	cpi temp, 48
	brlt do_nothing
	cpi temp, 71
	brge do_nothing
	cpi temp, 58
	brlt receive_value_number
	cpi temp, 65
	brlt do_nothing

	subi temp, 55
	mov current_number, temp

	rcall display_input_number

	reti

receive_value_number:
	subi temp, 48
	mov current_number, temp

	rcall display_input_number

	reti

;;;;;;;;;;;;;;;;;;
; BUTTON HANDLER ;
;;;;;;;;;;;;;;;;;;

update_button_debounce:
	cpi btn_debounce_counter, 0
	breq do_nothing

	dec btn_debounce_counter
	reti

up_button:
	; do nothing if button debounce counter is not zero
	cpi btn_debounce_counter, 0
	brne do_nothing

	; do nothing if upper bound is reached
	cpi current_number, 15
	brge do_nothing

	; increment input number
	inc current_number

	; set button debounce counter
	ldi btn_debounce_counter, DEBOUNCE_COUNT

	rcall display_input_number

	reti

down_button:
	; do nothing if button debounce counter is not zero
	cpi btn_debounce_counter, 0
	brne do_nothing

	; do nothing if lower bound is reached
	cpi current_number, 0
	breq do_nothing

	; decrement input number
	dec current_number

	; set button debounce counter
	ldi btn_debounce_counter, DEBOUNCE_COUNT

	rcall display_input_number

	reti

;;;;;;;;;;;;;;;;;;;;;;;;
; DISPLAY MULTIPLEXING ;
;;;;;;;;;;;;;;;;;;;;;;;;

update_display:
	; turn off row that we want to enable
	mov temp, current_row_bit
	com temp
	out PORTA, temp

	cpi current_row, 0
	breq row_0
	cpi current_row, 1
	breq row_1
	cpi current_row, 2
	breq row_2
	cpi current_row, 3
	breq row_3
	cpi current_row, 4
	breq row_4
	cpi current_row, 5
	breq row_5
	cpi current_row, 6
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
	cpi current_row, 7
	brlt next_row

	; reset
	ldi current_row, 0
	ldi current_row_bit, 0b10000000

	reti

next_row:
	inc current_row
	lsr current_row_bit

	reti
