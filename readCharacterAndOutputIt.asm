	processor   6502
	org         $1001

	.byte       $0C, $10
	.byte       $E0, $07
	.byte       $9E

	.byte       $20
	.byte       $34, $31, $31, $30

	.byte       $00

	.byte       $00, $00

	JSR $FFCF					;input charact from channel
	JSR $FFD2					; output character
	rts