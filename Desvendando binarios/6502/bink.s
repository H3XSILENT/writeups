PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E = %10000000
RW = %01000000
RS = %00100000

	.org $8000

reset:
	ldx #$ff ; ldx - load #$FF em X
	txs ; transfer X para SP

	lda #%11111111 ; Set all pins on port B to output
	sta DDRB

	lda #%11100000 ; Set top 3 pins on port A to output
	sta DDRA

	lda #%0011100 ; Set 8-bit mode; 2-line display; 5x8 font
	jsr lcd_instruction
 	lda #%0001110 ; Dispaly on; cursor on; blink off
        jsr lcd_instruction
	lda #%0000110 ; Increment and shift cursor; don't shift display
        jsr lcd_instruction


	lda #"H"
	jsr print_char
        lda #"e"     
        jsr print_char
        lda #"l"     
        jsr print_char
        lda #"l"
	jsr print_char     
        lda #"o"     
        jsr print_char
        lda #","
	jsr print_char
	lda #" "     
	jsr print_char
  	lda #"w"
        jsr print_char
        lda #"o"      
        jsr print_char
        lda #"r"      
        jsr print_char
        lda #"d"
        jsr print_char     
        lda #"!"     
        jsr print_char
        
loop:
	jmp loop
	
lcd_instruction:	
	pha
	sta PORTB
        lda #RS ; Clear RS/RW/E bits
        sta PORTA
        lda #(RS | E)
        sta PORTA
        lda #RS
        sta PORT
	pla
	rts

print_char:
	sta PORTB
        lda #RS ; Clear RS/RW/E bits
        sta PORTA
        lda #(RS | E)
        sta PORTA  
        lda #RS
        sta PORTA
	rts

	.org $fffc
	.world reset
	.worlf $0000
