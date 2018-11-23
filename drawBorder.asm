	processor 6502
	org $1001
	dc.w end
	dc.w 1234
	dc.b $9e, "4109", 0
end
	dc.w 0
start

	lda #$93
	JSR $FFD2


	
drawTop	
	LDA #0
	STA $00 		;X index
	STA $01			;Y index

loop
	LDX $00			;load X index
	LDY $01			;load Y index
	CLC
	JSR $FFF0

	LDX $01
	INX
	STX $01


	LDA #166
	JSR $FFD2
	
	LDA $01
	CMP #22
	BNE loop

drawLeft
	LDA #0
	STA $00 		;X index
	STA $01			;Y index

loop2
	LDX $00			;load X index
	LDY $01			;load Y index
	CLC
	JSR $FFF0

	LDX $00
	INX
	STX $00


	LDA #166
	JSR $FFD2
	
	LDA $00
	CMP #23
	BNE loop2

drawRight

	LDA #0
	STA $00 		;X index
	LDA #21
	STA $01			;Y index

loop3
	CLC
	LDX $00			;load X index	
	LDY $01			;load Y index
	JSR $FFF0

	LDX $00
	INX
	STX $00


	LDA #166
	JSR $FFD2
	
	LDA $00
	CMP #22
	BNE loop3		
	
drawBottom

	LDA #22
	STA $00 		;X index
	LDA #0
	STA $01			;Y index

loop4
	LDX $00			;load X index
	LDY $01			;load Y index
	CLC
	JSR $FFF0

	LDX $01
	INX
	STX $01


	LDA #166
	JSR $FFD2
	
	LDA $01
	CMP #21
	BNE loop4

	LDA #10
	STA 658


	LDX #21
	LDY #21
	CLC
	JSR $FFF0

	LDA #$FF
	STA $0292
	
	LDA #148
	JSR $FFD2

	LDX #21
	LDY #21
	CLC
	JSR $FFF0

	LDA #166
	JSR $FFD2
	
	
end2
	JMP end2	
	rts


