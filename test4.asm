	processor   6502
	org         $1001

	.byte       $0C, $10
	.byte       $E0, $07
	.byte       $9E

	.byte       $20
	.byte       $34, $31, $31, $30

	.byte       $00

	.byte       $00, $00

apple EQU $48 ;hex for H
	;LDA #apple

	; want to loop 23 times 

	LDA #$ff
	STA $f0
	LDA #$00
	STA $f1       ; $f0-f1 = #$1EE6(7910) <-starting point, centre-ish of the screen

	LDA #$0
	LDY #$0 ; Just using y here for indirect addressing (i.e. to store A into $1EE6)
	STA ($f0),Y     


	LDA #0
	STA $f3
	LDA #0
	CMP $f3
	BEQ beginMod
	rts
	;JSR $FFA8 ;output byte


print
	LDA #apple
	JSR $FFD2
	rts

beginMod
	LDA $f0			; load what was at f0
	STA $f6		     ; load store it at f3
	LDA $f1
	STA $f7
	;LDA #$0
	;LDY #$0
	;STA ($f6),Y   ; storing y at f6 maybe?

modulo
	LDA #23 			; subtract 23 from x and load that into accumulatr 
	STA $f2 			
	SEC
	LDA $f6
	SBC $f2              ; A = A - $f2 - (1- carry)
	STA $f4                 ; store that value in f4
	LDA $f7
	SBC $f3 
	STA $f5
	LDA $f4
	STA $f6
	LDA $f5
	STA $f7

	LDA #23
	STA $f2

	LDA $f6
	CMP $f2 				; f6 - 23 
	BCS modulo       		; if (x-23) > 23 go and go back up to modulo 

							; done looping so we have some sort of remainder

	JSR donemod
	rts


donemod 

	LDA #02
	STA $f2
	LDA $f6
	CMP $f2       ; accumulator - 23
	BEQ print     ; if modulo results in 0 go back and print H
	BCS greater


	LDA #$47
	JSR $FFD2     ; otherwise print an G
	rts

greater
	LDA #$46	; F
	JSR $FFD2 ; print another character 
	rts