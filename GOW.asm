  processor 6502
  org $1001

  dc.w end
  dc.w 1234

  dc.b $9e, "4109", 0
end
  dc.w 0
start



  ;; This is the section where we copy the character values from rom to ram
  LDA #$00
  STA $30
characterLoop
  LDX $30			;loop counter
  LDA $8000,X			;$8000 is starting address of characters in rom
  STA $1C00,X			;$1C00 is starting address of new character information location in ram
  INC $30			;increment loop counter

  LDA #$FF
  CMP $30			;check loop condition
  BNE characterLoop

  ;; We loop twice cause theres 512 bits of character information, and our
  ;; loop counter only can go to 255
  LDA #$00
  STA $30
characterLoop2			;this loop is same as above
  LDX $30
  LDA $80FF,X			;$8000 + $FF = $80FF
  STA $1CFF,X			;$1C00 + $FF = $1CFF
  INC $30

  LDA #$FF
  CMP $30
  BNE characterLoop2

  ;now we change the character information pointer to our new ram location
  LDX #$FF
  STX 36869

  ;; each character is stored as 8 bytes, with 1s indicating dark pixels.
  ;; our player sprite (for now) will be:

  ;; 	BINARY		|	HEX

  ;; 	10000000	|	80
  ;; 	10011000	|	98
  ;; 	10111100	|	BC
  ;; 	10111100	|	BC
  ;; 	11111110	|	FE
  ;; 	10111110	|	BE
  ;; 	10111100	|	BC
  ;; 	10100100	|	A4

  ;;It might be hard to make out, but the ones in the 8x8 grid above make a little character dude

  ;; the @ symbol is the first character in the character information section
  ;; so bytes 7168 to 7175 correspond to it.
  ;; Changing them to the values above will give us a little sprite whenever you type an @ symbol
  LDA #$80
  STA 7168
  LDA #$98
  STA 7169
  LDA #$BC
  STA 7170
  STA 7171
  LDA #$FE
  STA 7172
  LDA #$BE
  STA 7173
  LDA #$BC
  STA 7174
  LDA #$A4
  STA 7175


  ;; 	BINARY		|	HEX

  ;; 	00000000	|	00
  ;; 	01001000	|	48
  ;; 	01111001	|	79
  ;; 	01111111	|	7F
  ;; 	11111111	|	FF
  ;; 	11111111	|	FF
  ;; 	00101011	|	2B
  ;; 	00101011	|	2A

  ;; This grid represents a dog. Currently the > symbol is at ram address 7496-7503, so we'll chnage that to the dog
  ;; (NOTE: I think the way I copied the character information from rom to ram didnt work properly. The > character is supposed to be at 7664 instead of 7496.... Something to deal with later)

  LDA #$00
  STA 7496
  LDA #$48
  STA 7497
  LDA #$79
  STA 7498
  LDA #$7f
  STA 7499
  LDA #$FF
  STA 7500
  STA 7501
  LDA #$2A
  STA 7502
  STA 7503




  ;; This section is adding an axe sprite
  LDA #$00
  STA 7456
  STA 7457
  LDA #$0C
  STA 7458
  LDA #$1F
  STA 7459
  LDA #$37
  STA 7460
  LDA #$67
  STA 7461
  LDA #$C0
  STA 7462
  LDA #$80
  STA 7463

  LDA #$66
  STA 7464
  LDA #$FF
  STA 7465
  STA 7466
  STA 7467
  LDA #$7E
  STA 7468
  LDA #$3C
  STA 7469
  LDA #$18
  STA 7470
  LDA #$00
  STA 7471
  
  
  
  


  


  
  JSR clear
  JSR black
  LDX #$09
  JSR loadMonsters
  JMP movementStart
  RTS


  LDA $1c			;This is setting the pointer to character information
  STA $34			;to be in ram instead of ROM
  STA $38



black
  LDX #$0
  STX 36879
  RTS

loadMonsters
  LDA #$D4  ; $e2-e3 = #$1ED4 < - 1st monster starting location
  STA $e2
  LDA #$1E
  STA $e3

  LDA #$1   ; Collision flag for 1st monster
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
  LDA #$29
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

  LDA #$3
  STA $d2 ; Player health (starts at 3)
  ; CALL TO HP PIXEL ART DRAWING GOES HERE ;

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
  BEQ goToRightMovement

  CMP #$1F ; Down arrow key
  BEQ downMove1

  CMP #$20															; here we're comparing if button pressed is space key
  BEQ throwAxe														; if the button pressed was space key throw an axe

  jmp endMovement

throwAxe
  ; Here we need to throw an axe 									; NEED AXE SPRITE FOR THIS TO WORK, currently using "$" symbol

  ; once an axe is thrown. We need to check if it hit an enemy 	
  
  ;; draw an axe
  LDA #0
  STA $c6															; storing value into f3 to loop
forwardAxe															;; draws 
  INC $c6
  JSR drawAxe

  JSR checkAxeHitMonster1							; check if monster location is same as axe's location

  LDA $c6
  CMP #3
  BMI forwardAxe
  jmp endMovement

checkAxeHitMonster1
  ; check if move is legal
  CLC
  LDA $f0     ; load player address
  ADC $c6     ; add the current offset of axe to it 
  STA $c7     ; store this in f6 
  LDA $f1
  ADC #00   ; A - 0 - (1 - carry)
  STA $c8

  LDA $c7
  CMP $e2 ; f6 - 23
  BEQ checkLowAxe
  RTS

checkLowAxe
  LDA $c8
  CMP $e3
  BEQ goToGameEndScreenFromAxe
  rts


goToRightMovement:
	JMP rightMove
;eraseAxe
 ; LDA #$23    ; " " symbol
  ;LDY #$c6
  ;STA ($f0),Y
 ; RTS

drawAxe
  ; New location of the sprite ;
  LDA #$24															; currently just draws a $ sign
  LDY $c6															; load what ever is stored at c3
  STA ($f0),Y
  ;JSR waitLongest
  JSR wait
  LDA #$20
  LDY $c6
  STA ($f0),Y
  JSR waitLoopLong
  
  																	;;HERE WE NEED TO COMPARE THE AXE's POSITION WITH ENEMY POSITION
  																	;;IF THEY'RE THE SAME, THEN DECREMENT ENEMY HEALTH
  RTS

goToMovement4
  jmp movement
downMove1:
  jmp downMove

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
  BEQ goToMovement4
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

goToGameEndScreenFromAxe
  jmp gameEndScreen
rightMove
  ; Delete old location of sprite ;

  ; first check if right move is legal
  LDA #22
  STA $f4
  JSR beginMod
  LDA $f6
  CMP #1
  BEQ goToMovement4

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
	BEQ	monsterHitCheck2
  JMP monsterHitEnd
monsterHitCheck2
  LDA $f1
  CMP $e3
  JSR monsterHit

  RTS

monsterHitEnd
	RTS

monsterHit
  SEC
  LDA $d2
  SBC #$1
  STA $d2
  ; CALL TO HP PIXEL ART DRAWING UPDATE SHOULD BE HERE ;
  LDA $d2
  CMP #$0
  BEQ playerDead  ; If HP is 0 the game ends
  RTS

playerDead
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
waitLongest
	LDA 162
	CMP #24
	BNE waitLongest
	RTS
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

throwArrow
