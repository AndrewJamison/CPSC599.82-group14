	LDA #$e6
	STA $f0
	LDA #$1e
	STA $f1
	LDA #23
	STA $f4
	JSR beginMod
	LDA #$ff
	STA $e0

beginMod:
	; this does value stored at (f1 to f0)%f4
	LDA $f0			; load what was at f0
	STA $f6		     ; load store it at f3
	LDA $f1
	STA $f7


mod:	

	SEC 
	LDA $f6
	SBC $f4
	STA $f6
	LDA $f7
	SBC #00   ; A - 0 - (1 - carry)
	STA $f7

	LDA $f6
	CMP $f4 ; f6 - 23
	BCS mod

checkLow:
	LDA $f7
	CMP #0
	BNE mod
	rts
