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
  JSR loadMonsters
  JMP movementStart
  RTS

black
  LDX #$0
  STX 36879
  RTS

loadMonsters
  LDA #$D4  ; $e2-e3 = #$1ED4 < - 1st monster starting location
  STA $e2
  LDA #$1E
  STA $e3

  LDA #$1
  STA $e0

  LDA #$28
  LDY #$0
  STA ($e2),Y
  RTS

monsterMovement
	LDA $d0
	CMP #$0
	BEQ setMonsterFlag
	
	LDA #$0
	STA $d0

  LDA $e2
  CMP #$D5
  BEQ leftMoveBorder

  LDA $e2
  CMP #$D0
  BEQ rightMoveBorder

  LDA $e0
  CMP #$1
  BEQ monsterLeftMove

  LDA $e0
  CMP #$0
  BEQ monsterRightMove

  RTS
	
setMonsterFlag
	LDA #$1
	STA $d0
	JMP continue

monsterLeftMove
  JSR eraseMonster
  LDA $e2
  SEC
  SBC #$1
  STA $e2
  JSR monsterHitCheck
  JSR drawMonster
  RTS

monsterRightMove
  JSR eraseMonster
  LDA $e2
  CLC
  ADC #$1
  STA $e2
  JSR monsterHitCheck
  JSR drawMonster
  RTS

leftMoveBorder
  JSR monsterLeftMove
  LDA #$1
  STA $e0
  RTS

rightMoveBorder
  JSR monsterRightMove
  LDA #$0
  STA $e0
  RTS

eraseMonster
  LDA #$20    ; " " symbol
  LDY #$0
  STA ($e2),Y
  RTS

drawMonster
  ; New location of the sprite ;
  LDA #$28 
  LDY #$0
  STA ($e2),Y
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

  JSR monsterMovement
	
continue

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
  BEQ goupMove

endMovement
  jmp movement ; Constant loop for movement (could be the main game loop?)

loop
  nop
  jmp loop

leftMove
; $f0 = $f0 - 1 (one space left)  
  LDA #22
  STA $f4 
  JSR beginMod
  LDA $f6
  CMP #2
  BEQ movement
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
  
  JSR monsterHitCheck
  jmp newSprite

rightMove
  ; Delete old location of sprite ;

  ; first check if right move is legal 
  LDA #22
  STA $f4 
  JSR beginMod
  LDA $f6
  CMP #1
  BEQ movement

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
	
  JSR monsterHitCheck
  jmp newSprite


gotomovement
  jmp movement

goupMove
  JMP upMove

downMove
  ; check if move is legal 
  CLC 
  LDA $f0
  ADC #22
  STA $f6
  LDA $f1
  ADC #00   ; A - f1 - (1 - carry)
  STA $f7

  LDA $f7
  CMP #$20
  BCS gotomovement

  LDA $f7
  CMP #$1f
  BNE isLegal
  LDA $f6
  CMP #$fa
  BCS gotomovement

isLegal
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
  
  JSR monsterHitCheck
  jmp newSprite

upMove
  ; first check if move is legal 
  SEC     
  LDA $f0
  SBC #22
  STA $f6
  LDA $f1
  SBC #00 ; f1 - 0 - (1- carry)
  STA $f7 

  LDA $f7  ; if is below 1E then we can't go down
  CMP #$1E 
  BMI gotomovement
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
	
  JSR monsterHitCheck
  jmp newSprite
  
monsterHitCheck
	LDA $f0
	CMP $e2
	BEQ	monsterHit
	
	RTS
	
monsterHit
	JSR clear
	JMP gameEndScreen
	
gameEndScreen
	LDA #$07
	STA $1EE2
	LDA #$01
	STA $1EE3
	LDA #$0D
	STA $1EE4
	LDA #$05
	STA $1EE5
	LDA #$0F
	STA $1EE7
	LDA #$16
	STA $1EE8
	LDA #$05
	STA $1EE9
	LDA #$12
	STA $1EEA
	JSR wait
	JMP gameEndScreen
	
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
	
waitLonger
	LDA #0
	STA 162

waitLoopLong
	LDA 162
	CMP #12
	BNE waitLoopLong
	RTS

beginMod  ; this does value stored at (f1 to f0)%f4
  LDA $f0     ; load what was at f0
  STA $f6        ; load store it at f3
  LDA $f1
  STA $f7

mod 
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

checkLow
  LDA $f7
  CMP #0
  BNE mod
  rts