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
  LDX #$09
  JMP movementStart
  RTS

black
  LDX #$0
  STX 36879
  RTS

movementStart ; Instantiate coordinates($f0) (little endian!)
  LDA #$E6
  STA $f0
  LDA #$1E
  STA $f1       ; $f0-f1 = #$1EE6(7910) <-starting point, centre-ish of the screen

  LDA #$0
  LDY #$0 ; Just using y here for indirect addressing (i.e. to store A into $1EE6)
  STA ($f0),Y

movement
  JSR wait  ; no teleporting

  ; $028D contains the "shift down" bit (1st bit). AND it w/ 1 to check if its pressed or not ;
  ; (we need to check this as theres only 2 arrow keys and the direction is based on if shift is ;
  ; being pressed or not)                                                                      ;
  LDA $028D
  AND #$1
  CMP #$1
  BEQ shiftDown

  LDA 197 ; $197 contains the current key being held down

  CMP #$17  ; Right arrow key
  BEQ rightMove

  CMP #$1F ; Down arrow key
  BEQ downMove

  jmp endMovement

shiftDown
  LDA 197 ; $197 contains the current key being held down

  CMP #$17  ; Left arrow key
  BEQ leftMove

  CMP #$1F ; Up arrow key
  BEQ upMove

endMovement
  jmp movement ; Constant loop for movement (could be the main game loop?)

loop
  nop
  jmp loop


leftMove
; $f0 = $f0 - 1 (one space left)

  ; Delete old location of sprite ;
  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  ; This chunk of code basically does $f0 - 1 but w/ carry magic
  LDA #1
  STA $f2
  SEC
  LDA $f0
  SBC $f2
  STA $f4
  LDA $f1
  SBC $f3
  STA $f5
  LDA $f4
  STA $f0
  LDA $f5
  STA $f1

  jmp newSprite

rightMove


  ; Delete old location of sprite ;
  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  ; $f0 = $f0 + 1 (one space right)
  LDA #1
  STA $f2
  CLC
  LDA $f0
  ADC $f2
  STA $f4
  LDA $f1
  ADC $f3
  STA $f5
  LDA $f4
  STA $f0
  LDA $f5
  STA $f1
  jmp newSprite

downMove
  ; Delete old location of sprite ;
  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  ; $f0 = $f0 + 22 (one space down)
  LDA #22
  STA $f2
  CLC
  LDA $f0
  ADC $f2
  STA $f4
  LDA $f1
  ADC $f3
  STA $f5
  LDA $f4
  STA $f0
  LDA $f5
  STA $f1
  jmp newSprite


upMove

  ; Delete old location of sprite ;
  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  ; $f0 = $f0 - 22 (one space up)
  LDA #22
  STA $f2
  SEC
  LDA $f0
  SBC $f2
  STA $f4
  LDA $f1
  SBC $f3
  STA $f5
  LDA $f4
  STA $f0
  LDA $f5
  STA $f1
  jmp newSprite

newSprite
  ; New location of the sprite ;
  LDA #$0     ; "@" symbol
  LDY #$0
  STA ($f0),Y

  jmp movement

clear
  LDA #$93
  JSR $FFD2
  RTS

wait 			;basic wait function.
  LDA #0
  STA 162 	;set the Jiffy Clock to 0.

waitloop
  LDA 162 	;Compare Jiffy Clock value with length of time to wait.
  CMP #6
  BNE waitloop
  RTS
