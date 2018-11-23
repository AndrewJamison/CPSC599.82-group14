	processor 6502
	org $1001

	dc.w end
	dc.w 1234

	dc.b $9e, "4109", 0
end
	dc.w 0
start

	JSR clear
	JSR black
	LDA #$DC
	STA $00
	LDA #$1E
	STA $01
	LDX #$0
	JMP ballanimation
	RTS

black
	LDX #$0
	STX 36879
	RTS

ballanimation
	CPX #$16
	BEQ stop
	LDA #$0
	STA $1EDC,X
	INX
	JSR wait
	LDA #$20
	STA $1EDB,X
	jmp ballanimation


clear
	LDA #$93
	JSR $FFD2
	RTS

stop
	JSR clear
	LDX #$0
	jmp ballanimation


wait 			;basic wait function.
	LDA #0
	STA 162 	;set the Jiffy Clock to 0.
waitloop
	LDA 162 	;Compare Jiffy Clock value with length of time to wait.
	CMP #60
	BNE waitloop
	RTS
