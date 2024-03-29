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




  ;; This section is adding an axe sprite @ #$24
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

  ;; This section is adding a heart sprite @ #$25
  LDA #$00
  STA 7464
  LDA #$6C
  STA 7465
  LDA #$FE
  STA 7466
  STA 7467
  LDA #$7C
  STA 7468
  LDA #$38
  STA 7469
  LDA #$10
  STA 7470
  LDA #$00
  STA 7471

  ;; This section is adding a kid sprite @ #$26
  LDA #$00
  STA 7472
  STA 7473
  STA 7474
  LDA #$08
  STA 7475
  LDA #$5C
  STA 7476
  STA 7478
  LDA #$7E
  STA 7477
  LDA #$54
  STA 7479

  ;; This section is adding a skeleton sprite @ #$27
  ;; 	BINARY		|	HEX

  ;; 	00011100	|	1C
  ;; 	00100010	|	22
  ;; 	01010101	|	55
  ;; 	01000001	|	41
  ;; 	01001001	|	49
  ;; 	01000001	|	41
  ;; 	01010101	|	55
  ;; 	00111110	|	3E

  LDA #$1C
  STA 7480
  LDA #$22
  STA 7481
  LDA #$55
  STA 7482
  LDA #$41
  STA 7483
  LDA #$49
  STA 7484
  LDA #$41
  STA 7485
  LDA #$55
  STA 7486
  LDA #$3E
  STA 7487

  ;; This section is adding a grass sprite @ #$28
  ;; 	BINARY		|	HEX

  ;; 	00000000	|	00
  ;; 	00000000	|	00
  ;; 	00000000	|	00
  ;; 	00000000	|	91
  ;; 	00000000	|	BB
  ;; 	10010010	|	FF
  ;; 	01001001	|	FF
  ;; 	10010010	|	FF

  LDA #$00
  STA 7488
  STA 7489
  STA 7490
  STA 7491
  STA 7492
  LDA #$55
  STA 7493
  STA 7494
  LDA #$AA
  STA 7495



  ;;Now we add a road sprite at 23
  ;; 	00000000	|	00
  ;; 	00000000	|	00
  ;; 	00000000	|	00
  ;; 	00000000	|	91
  ;; 	00000000	|	BB
  ;; 	10010010	|	FF
  ;; 	01001001	|	FF
  ;; 	10010010	|	FF

;;

;;
  LDA #$F0
  STA 7448
  STA 7450
  STA 7452
  STA 7454
  LDA #$0F
  STA 7449
  STA 7451
  STA 7453
  STA 7455

gameStart

  LDA #$3
  STA 38400
  LDA #$FF
  STA 7680

  JSR clear
  LDX #$09
  JSR loadMonsters

titleScreen   ;load the initial title screen and play the theme music.

  LDA #$07
  STA $1EE2
  LDA #$0F
  STA $1EE3
  LDA #$04
  STA $1EE4
  LDA #$0F
  STA $1EE6
  LDA #$06
  STA $1EE7
  LDA #$17
  STA $1EE9
  LDA #$01
  STA $1EEA
  LDA #$12
  STA $1EEB

  LDA #$00
  STA $96E2
  STA $96E3
  STA $96E4
  STA $96E5
  STA $96E6
  STA $96E7
  STA $96E8
  STA $96E9
  STA $96EA
  STA $96EB

  LDA #$0
  STA $1EC1
  JSR theme
  JSR wait

preScreen     ;wait until a player presses space to start the game.
  LDA 197
  CMP #$20
  BNE preScreen
  JSR clear
  JSR loadMonsters

  JMP movementStart
  RTS


  LDA $1c			;This is setting the pointer to character information
  STA $34			;to be in ram instead of ROM
  STA $38


loadMonsters
  ; MONSTER ONE ;
  LDA #$D4  ; $e2-e3 = #$1ED4 < - 1st monster starting location
  STA $e2
  LDA #$1E
  STA $e3

  LDA #$1   ; Collision flag for 1st monster
  STA $e0

  LDA #3   ; Monster 1 health (starts at 3)
  STA $e4

  LDA #$29
  LDY #$0
  STA ($e2),Y

  CLC				;Clear the carry so it doesn't mess  with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $e3			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $e2			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$2		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who  knows
  STA ($40),Y			;store the color into the color location

  ; END MONSTER ONE ;

  ; MONSTER TWO ;
  LDA #$B6
  STA $12
  LDA #$1E
  STA $13

  LDA #$1
  STA $11

  LDA #3
  STA $14

  LDA #$27
  LDY #$0
  STA ($12),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $e3			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $e2			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$2		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location
  ; END MONSTER TWO ;

  RTS

monsterMovement

  JSR setMonsterFlag

  LDA $c2
  CMP $b7
  BEQ case1

  LDA $c2
  CMP $b6
  BEQ case2

  LDA $c1
  CMP #$1
  BEQ case3

  LDA $c1
  CMP #$0
  BEQ case4

case1
  JSR leftMoveBorder
  JMP monsterMoveCleanup

case2
  JSR rightMoveBorder
  JMP monsterMoveCleanup

case3
  JSR monsterLeftMove
  JMP monsterMoveCleanup

case4

  JSR monsterRightMove
  JMP monsterMoveCleanup

monsterMoveCleanup

  RTS

setMonsterFlag
  LDA $c0
  CMP #0
  BEQ monsterFlagZero ; Check if the flag is 0; if so set it to one and skip monster movement

  LDA #0  ; Otherwise if the flag is 0 continue with movement
  STA $c0
  RTS

monsterFlagZero
	LDA #$1
	STA $c0
	JMP monsterMoveCleanup

monsterLeftMove
  JSR eraseMonster
  LDA $c2
  SEC
  SBC #$1
  STA $c2
  JSR monster1HitCheck
  JSR monster2HitCheck
  JSR drawMonster
  RTS

monsterRightMove
  JSR eraseMonster
  LDA $c2
  CLC
  ADC #$1
  STA $c2
  JSR monster1HitCheck
  JSR monster2HitCheck
  JSR drawMonster
  RTS

leftMoveBorder
  JSR monsterLeftMove
  LDA #$1
  STA $c1
  RTS

rightMoveBorder
  JSR monsterRightMove
  LDA #$0
  STA $c1
  RTS

eraseMonster
  LDA #$20    ; " " symbol
  LDY #$0
  STA ($c2),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $c3			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $c2			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$2		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location
  RTS

drawMonster
  ; Check to see which monster it is we want to draw (different sprites) ;
  LDA $20 ;$20 contains the current monster (0 = monster 1, 1 = monster 2)
  CMP #$0
  BEQ drawMonster1

  CMP #$1
  BEQ drawMonster2

drawMonster1
  ; New location of the sprite ;
  LDA #$29
  LDY #$0
  STA ($c2),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $c3			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $c2			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$2		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location
  RTS

drawMonster2
  ; New location of the sprite ;
  LDA #$27
  LDY #$0
  STA ($c2),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $c3			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $c2			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$2		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location
  RTS

movementStart ; Instantiate coordinates($f0) (little endian!)

  LDA #$E6
  STA $f0
  LDA #$1E
  STA $f1       ; $f0-f1 = #$1EE6(7910) <-starting point, centre-ish of the screen

  LDA #$0
  LDY #$0 ; Just using y here for indirect addressing (i.e. to store A into $1EE6)
  STA ($f0),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $f1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $f0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location


  LDA #$3
  STA $d2 ; Player health (starts at 3)
  ; CALL TO HP PIXEL ART DRAWING GOES HERE ;
  JSR displayHitpoints

  ; Draw the boy initially ($1ECE) ;
  LDA #$CE
  STA $a0
  LDA #$1E
  STA $a1

  LDA #$26
  LDY #$0
  STA ($a0),Y

   CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $a1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $a0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location

  LDA #0
  STA $32

  LDA #2
  STA $f8

  ;==== MAIN GAME LOOP ====;

movement
  JSR wait  ; no teleporting

  LDA $e4 ; Check to see if monster 1 is dead; if so don't draw it
  CMP #0
  BEQ monster1Dead

  ;Monster One Input;
  LDA $d0  ; Movement flag
  STA $c0
  LDA $e0  ; Collision flag
  STA $c1
  LDA $e2  ; Location
  STA $c2
  LDA $e3
  STA $c3
  LDA $e4  ; Health
  STA $c4
  LDA #$D0
  STA $b6 ; Left border
  LDA #$D5
  STA $b7 ; Right border
  LDA #0
  STA $20 ; Current monster flag (0 = monster 1)

  JSR monsterMovement

  ;Load the output back into Monster One;
  LDA $c0  ; Movement flag
  STA $d0
  LDA $c1  ; Collision flag
  STA $e0
  LDA $c2  ; Location
  STA $e2
  LDA $c4  ; Health
  STA $e4

monster1Dead
  LDA $14 ; Check to see if monster 2 is dead; if so don't draw it
  CMP #0
  BEQ monster2Dead

  ;Monster Two Input;
  LDA $00  ; Movement flag
  STA $c0
  LDA $11  ; Collision flag
  STA $c1
  LDA $12  ; Location
  STA $c2
  LDA $13
  STA $c3
  LDA $14  ; Health
  STA $c4
  LDA #$B1
  STA $b6 ; Left border
  LDA #$B8
  STA $b7 ; Right border
  LDA #1
  STA $20 ; Current monster flag (1 = monster 2)

  JSR monsterMovement

  ;Load the output back into Monster Two;
  LDA $c0  ; Movement flag
  STA $10
  LDA $c1  ; Collision flag
  STA $11
  LDA $c2  ; Location
  STA $12
  LDA $c4  ; Health
  STA $14


monster2Dead
  ; Draw the player ;
  LDA #$0     ; Player sprite
  LDY #$0
  STA ($f0),Y

  ; Draw the boy ;
  LDA #$26     ; Player sprite
  LDY #$0
  STA ($a0),Y

  ; Draw a grass sprite ;
  LDA #$28
  STA $1EE2
  LDA #$5
  STA 38626

  ; Draw a grass sprite ;
  LDA #$28
  STA $1EE2
  STA 7749
  STA 7759
  STA 8121
  STA 8080
  STA 8132
  STA 8006


  LDA #$5
  STA 38626
  STA 38479
  STA 38469
  STA 38841
  STA 38800
  STA 38852
  STA 38726


;;Draw a road sprite

  LDA #$23
  STA 8076
  STA 8077
  STA 8078
  STA 8079
  STA 8080
  STA 8081
  STA 8082
  STA 8083
  STA 8084
  STA 8085
  STA 8086
  STA 8087
  STA 8088
  STA 8089
  STA 8090
  STA 8091
  STA 8092
  STA 8093
  STA 8094
  STA 8095
  STA 8096
  STA 8097

  STA	8098
  STA	8099
  STA	8100
  STA	8101
  STA	8102
  STA	8103
  STA	8104
  STA	8105
  STA	8106
  STA	8107
  STA	8108
  STA	8109
  STA	8110
  STA	8111
  STA	8112
  STA	8113
  STA	8114
  STA	8115
  STA	8116
  STA	8117
  STA	8118
  STA	8119

  LDA #$06
  STA 38796
  STA 38797
  STA 38798
  STA 38799
  STA 38800
  STA 38801
  STA 38802
  STA 38803
  STA 38804
  STA 38805
  STA 38806
  STA 38807
  STA 38808
  STA 38809
  STA 38810
  STA 38811
  STA 38812
  STA 38813
  STA 38814
  STA 38815
  STA 38816
  STA 38817

  STA	38818
  STA	38819
  STA	38820
  STA	38821
  STA	38822
  STA	38823
  STA	38824
  STA	38825
  STA	38826
  STA	38827
  STA	38828
  STA	38829
  STA	38830
  STA	38831
  STA	38832
  STA	38833
  STA	38834
  STA	38835
  STA	38836
  STA	38837
  STA	38838
  STA	38839

  

continue

  LDA $32   ;$32 contains the axe loop counter
  CMP #0
  BEQ axeNotBeingThrown

  JMP axeBeingThrown


axeNotBeingThrown
                                                                      ;
  LDA 197 ; $197 contains the current key being held down

  CMP #$9  ; W key (up)
  BEQ upMove3

  CMP #$11  ; A key (left)
  BEQ leftMove3

  CMP #$29  ; S key (down)
  BEQ downMove3

  CMP #$12  ; D key (right)
  BEQ rightMove3

  LDA $32
  CMP #0
  BNE endMovement1

  LDA 197

  CMP #$20															; here we're comparing if button pressed is space key
  BEQ throwAxe												; if the button pressed was space key throw an axe

  JMP endMovement

endMovement1
  JMP endMovement

axeBeingThrown
  ; Otherwise if an axe is currently being thrown then we want to continue the throw loop
  ; Check to see the original direction the player was facing when they threw the axe and throw it based on that
  LDA $f8
  CMP #2
  BEQ forwardAxe
  LDA $f8
  CMP #1
  BEQ backwardAxe1
  LDA $f8
  CMP #3
  BEQ downAxe
  LDA $f8
  CMP #4
  BEQ upAxe1

  jmp endMovement

    ;=== END MAIN GAME LOOP ===;

rightMove3
  JMP rightMove2

leftMove3
  JMP leftMove2

upMove3
  JMP upMove2

downMove3
  JMP downMove2

throwAxe
  ; Here we need to throw an axe

  ; Set the loop counter for the axe to start at 3:
  LDA #5
  STA $32   ; $32 is the axe loop counter
  LDA #0
  STA $c6

  ;;;;;;first we are going to check the direction in which we are facing, then based on that throw the axe in that direction
  LDA $f8
  CMP #$1
  BEQ backwardAxe1
  LDA $f8
  CMP #3
  BEQ downAxe
  LDA $f8
  CMP #4
  BEQ upAxe1

forwardAxe
  LDA $32
  CMP #5
  BEQ skipDeleteForward
  JSR deleteAxe

skipDeleteForward
  INC $c6
  JSR drawAxe

  JSR checkAxeHitMonster1							; check if monster location is same as axe's location
  JSR checkAxeHitMonster2

  LDX $32
  DEX
  STX $32

  LDA $32
  CMP #0
  BNE endAxe
  JSR deleteAxe

endAxe
  LDA $32   ;$32 contains the axe loop counter
  CMP #4
  BEQ specialCaseFirstAxe1
  jmp axeNotBeingThrown

endAxe1
  JMP endAxe

upAxe1
  JMP upAxe

leftMove2
  JMP leftMove

upMove2
  JMP upMove

downMove2
  JMP downMove

rightMove2
  JMP rightMove

backwardAxe1
  JMP backwardAxe

specialCaseFirstAxe1
  JMP specialCaseFirstAxe

downAxe                              ;; draws
  LDA $32
  CMP #5
  BEQ skipDeleteDown
  JSR deleteAxe

skipDeleteDown
  LDA #22
  ADC $c6
  STA $c6

  LDA $32
  CMP #5
  BEQ initialDec
  JMP noDec

initialDec
  LDX $c6
  DEX
  STX $c6

noDec
  JSR drawAxe

  JSR checkAxeHitMonster1             ; check if monster location is same as axe's location
  JSR checkAxeHitMonster2

  LDX $32
  DEX
  STX $32

  LDA $32
  CMP #0
  BNE endAxe
  JSR deleteAxe

  LDA $32   ;$32 contains the axe loop counter
  CMP #4
  BEQ specialCaseFirstAxe
  jmp axeNotBeingThrown

backwardAxe                              ;; draws
  LDA $32
  CMP #5
  BEQ skipDeleteBackward
  JSR deleteAxeNegative

skipDeleteBackward
  INC $c6
  JSR drawAxeNegative

  JSR checkAxeHitMonster1Negative             ; check if monster location is same as axe's location
  JSR checkAxeHitMonster2Negative

  LDX $32
  DEX
  STX $32
  LDA $32
  CMP #0
  BNE endAxe
  JSR deleteAxeNegative

  LDA $32   ;$32 contains the axe loop counter
  CMP #4
  BEQ specialCaseFirstAxe
  jmp axeNotBeingThrown

upAxe
  LDA $32
  CMP #5
  BEQ skipDeleteUp
  JSR deleteAxeNegative

skipDeleteUp
  LDA #21
  ADC $c6
  STA $c6
  JSR drawAxeNegative

  JSR checkAxeHitMonster1Negative             ; check if monster location is same as axe's location
  JSR checkAxeHitMonster2Negative
  ;INC $c6

  LDX $32
  DEX
  STX $32
  LDA $32
  CMP #0
  BNE endAxe2
  JSR deleteAxeNegative

  LDA $32   ;$32 contains the axe loop counter
  CMP #4
  BEQ specialCaseFirstAxe
  jmp axeNotBeingThrown


specialCaseFirstAxe
  JMP endMovement

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
  CMP $e2     ; First monster location
  BEQ checkLowAxe1
  RTS
checkAxeHitMonster2
  ; check if move is legal
  CLC
  LDA $f0     ; load player address
  ADC $c6     ; add the current offset of axe to it
  STA $c7     ; store this in f6
  LDA $f1
  ADC #00   ; A - 0 - (1 - carry)
  STA $c8

  LDA $c7
  CMP $12     ; Second monster location
  BEQ checkLowAxe2
  RTS

checkAxeHitMonster1Negative
  ; check if move is legal
  SEC
  LDA $f0     ; load player address
  SBC $c6     ; add the current offset of axe to it
  STA $c7     ; store this in f6
  LDA $f1
  SBC #00   ; A - 0 - (1 - carry)
  STA $c8

  LDA $c7
  CMP $e2     ; Monster 1 location
  BEQ checkLowAxe1

  RTS

endAxe2
  JMP endAxe1

checkAxeHitMonster2Negative
  ; check if move is legal
  SEC
  LDA $f0     ; load player address
  SBC $c6     ; add the current offset of axe to it
  STA $c7     ; store this in f6
  LDA $f1
  SBC #00   ; A - 0 - (1 - carry)
  STA $c8

  LDA $c7
  CMP $12     ; Monster 2 locaiton
  BEQ checkLowAxe2
  RTS


checkLowAxe1
  JSR attackHitSound
  LDA $c8
  CMP $e3
  JSR monster1HitByAxe
  rts

checkLowAxe2
  LDA $c8
  CMP $13
  JSR monster2HitByAxe
  rts


monster1HitByAxe ;Reduce monster health by 1; If health is 0 after the subtraction then set the monster alive flag to 0
  LDA $e4
  SEC
  SBC #1
  CMP #0
  BEQ monster1AxeDead
  STA $e4
  RTS

monster2HitByAxe ;Reduce monster health by 1; If health is 0 after the subtraction then set the monster alive flag to 0
  LDA $14
  SEC
  SBC #1
  CMP #0
  BEQ monster2AxeDead
  STA $14
  RTS

monster1AxeDead
  LDA #0
  STA $e4

  ;Delete the monster;
  LDA #$20
  STA $e2

  ;Check if the other monster is dead - if so you win!
  LDA $14
  CMP #0
  BEQ bothMonstersDead

  RTS

monster2AxeDead
  LDA #0
  STA $14

  ;Delete the monster;
  LDA #$20
  STA $12

  ;Check if the other monster is dead - if so you win!
  LDA $e4
  CMP #0
  BEQ bothMonstersDead

  RTS

bothMonstersDead
  JSR gameEndScreenVictory

drawAxeNegative
  SEC
  LDA $f0
  SBC $c6
  STA $f6
  LDA $f1
  SBC #00 ; f1 - 0 - (1- carry)
  STA $f7
  LDY #0
  LDA #$24
  STA ($f6),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $f7			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $f6			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0
  STA ($40),Y			;store the color into the color location

  RTS

deleteAxe
  ; Delete the old location ;
  LDA #$20
  LDY $c6
  STA ($f0),Y
  RTS



deleteAxeNegative
  SEC
  LDA $f0
  SBC $c6
  STA $f6
  LDA $f1
  SBC #00 ; f1 - 0 - (1- carry)
  STA $f7
  LDY #0
  LDA #$20
  STA ($f6),Y



  RTS

drawAxe
				; New location of the sprite ;

  LDA #$24
  LDY $c6
  CLC
  STA ($f0),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $f1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $f0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY $c6
  STA ($40),Y			;store the color into the color location


  																	;;HERE WE NEED TO COMPARE THE AXE's POSITION WITH ENEMY POSITION
  																	;;IF THEY'RE THE SAME, THEN DECREMENT ENEMY HEALTH
  RTS

goToMovement4
  JSR borderSound
  jmp movement

endMovement
  JSR displayHitpoints
  jmp movement ; Constant loop for movement (could be the main game loop?)

loop
  nop
  jmp loop

storeLeft
  ; Check if axe is currently being thrown; if so don't store new value
  LDA $32
  CMP #0
  BEQ continueStoreLeft
  JMP movement

continueStoreLeft
  LDA #1                                                                                                    ;;;;;;;;;;;;;;;;
  STA $f8
  JMP movement
  ;JSR goToGameEndScreenFromAxe

leftMove
  ; first we should check if the last movement direction was left
  ; if the last direction we moved was left, then continue to move left,
  ; otherwise, update our new direction we're facing (f8) to left, and return to main game loop

  LDA $f8
  CMP #$1
  BNE storeLeft


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

  JSR deleteSprite
  JSR deleteBoy

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

  JSR monster1HitCheck
  JSR monster2HitCheck
  jmp newSprite

storeRight
  ; Check if axe is currently being thrown; if so don't store new value
  LDA $32
  CMP #0
  BEQ continueStoreRight
  JMP movement

continueStoreRight

  LDA #2
  STA $f8
  JMP movement

rightMove

  ;; check if right was last pressed
  LDA $f8
  CMP #2
  BNE storeRight
  ; Delete old location of sprite ;

  ; first check if right move is legal
  LDA #22
  STA $f4
  JSR beginMod
  LDA $f6
  CMP #1
  BEQ goToMovement5



  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  JSR deleteSprite
  JSR deleteBoy

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

  JSR monster1HitCheck
  JSR monster2HitCheck
  jmp newSprite

storeDown
  ; Check if axe is currently being thrown; if so don't store new value
  LDA $32
  CMP #0
  BEQ continueStoreDown
  JMP movement

continueStoreDown
  LDA #3
  STA $f8
  JMP movement

goToMovement5
  JSR borderSound
  jmp movement

gotomovement
  JSR borderSound
  jmp movement

downMove
  ; check if move is legal
  LDA $f8
  CMP #3
  BNE storeDown

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


  JSR deleteSprite
  JSR deleteBoy

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

  JSR monster1HitCheck
  JSR monster2HitCheck
  jmp newSprite
gotomovement7
  JMP gotomovement

storeUp
  ; Check if axe is currently being thrown; if so don't store new value
  LDA $32
  CMP #0
  BEQ continueStoreUp
  JMP movement

continueStoreUp
  LDA #4
  STA $f8
  JMP movement
upMove
  ; check if the last direction pressed was up
  ; if it wasn't, then change direction to up, but don't go up
  LDA $f8
  CMP #4
  BNE storeUp

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
  BMI gotomovement7
  ; Delete old location of sprite ;
  LDA #$20    ; " " symbol (space)
  LDY #$0
  STA ($f0),Y

  JSR deleteSprite
  JSR deleteBoy

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

  JSR monster1HitCheck
  JSR monster2HitCheck
  jmp newSprite

monster1HitCheck
	LDA $f0
	CMP $e2
	BEQ	monster1HitCheck2
  JMP monsterHitEnd
monster1HitCheck2
  LDA $f1
  CMP $e3
  BEQ monsterHit

  RTS

monster2HitCheck
  LDA $f0
  CMP $12
  BEQ	monster2HitCheck2
  JMP monsterHitEnd

monster2HitCheck2
  LDA $f1
  CMP $13
  BEQ monsterHit

  RTS

monsterHitEnd
	RTS

monsterHit
  JSR tookDamageSound
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
  JSR dyingMusic
	JSR clear
	JMP gameEndScreen

gameEndScreen
	LDA #$07     ; G
	STA $1EE2
	LDA #$01     ; A
	STA $1EE3
	LDA #$0D     ; M
	STA $1EE4
	LDA #$05     ; E
	STA $1EE5
	LDA #$0F     ; O
	STA $1EE7
	LDA #$16     ; V
	STA $1EE8
	LDA #$05     ; E
	STA $1EE9
	LDA #$12     ; R
	STA $1EEA

  LDA #$00
  STA $96E2
  STA $96E3
  STA $96E4
  STA $96E5
  STA $96E7
  STA $96E8
  STA $96E9
  STA $96EA


	JSR wait
	JMP gameEndScreen

gameEndScreenVictory
  JSR wait
  LDA #$19     ; Y
  STA $1EE2
  LDA #$0F     ; O
	STA $1EE3
	LDA #$15     ; U
	STA $1EE4
	LDA #$17     ; W
	STA $1EE6
	LDA #$09     ; I
	STA $1EE7
	LDA #$0E     ; N
	STA $1EE8

  LDA #$00
  STA $96E2
  STA $96E3
  STA $96E4
  STA $96E5
  STA $96E6
  STA $96E7
  STA $96E8
  STA $96E9
  STA $96EA

  LDA 197
  CMP #$20 ; Space key
  BEQ restartGame
  JMP gameEndScreenVictory

restartGame
  JSR clear
  JMP gameStart

newSprite
  ; New location of the sprite ;
  LDA #$0     ; "@" symbol
  LDY #$0
  STA ($f0),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $f1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $f0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location

  JSR drawBoy
  jmp movement

deleteSprite

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $f1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $f0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$1		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location

deleteBoy
  LDA #24
  STA $f2
  SEC
  LDA $f0
  SBC $f2
  STA $a0
  LDA $f1
  SBC $f3
  STA $a1

  LDA #$20
  LDY #$0
  STA ($a0),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $a1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $a0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$1		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location

  RTS

drawBoy
  LDA #24
  STA $f2
  SEC
  LDA $f0
  SBC $f2
  STA $a0
  LDA $f1
  SBC $f3
  STA $a1

  LDA #$26
  LDY #$0
  STA ($a0),Y

  CLC				;Clear the carry so it doesn't mess with out addition
  LDA #$78			;78 is the offset we need to add to the HIGH ORDER bits of the boy's location to get his color location
  STA $f2			;Store it in a temp location
  LDA $a1			;Load the HIGH ORDER bits of the boy's location
  ADC $f2			;add our offset to it
  STA $41			;store it into the high order bit location for his color
  LDA $a0			;Then just copy the boys low order bits
  STA $40			;into the color location low order bits

  LDA #$6		  ;Choose a color (2=red, 1=white, 0=black, more on page 270 of bible)
  LDY #$0			;load 0 into Y  cause who the heck knows
  STA ($40),Y			;store the color into the color location

  RTS

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


displayHitpoints
  JSR clearHitPoints

  LDA $d2
  CMP #3
  BEQ displayThreeHitpoints

  CMP #2
  BEQ displayTwoHitpoints

  CMP #1
  BEQ displayOneHitpoints

  JMP clearHitPoints

clearHitPoints
  LDA #$20
  STA $1E13
  STA $1E14
  STA $1E15
  RTS

displayThreeHitpoints
  LDA #$25
  STA $1E15
  LDA #2
  STA 38421
  JSR displayTwoHitpoints
  RTS

displayTwoHitpoints
  LDA #$25
  STA $1E14
  LDA #2
  STA 38420
  JSR displayOneHitpoints
  RTS

displayOneHitpoints
  LDA #$25
  STA $1E13
  LDA #2
  STA 38419
  RTS

theme
  LDA #15
  STA $900e   ;set volume
  LDA #173
  STA $900c
  LDA #50
  STA $d3
  JSR newWait

  LDA #181
  STA $900c
  LDA #50
  STA $d3
  JSR newWait

  LDA #189
  STA $900c
  LDA #70
  STA $d3
  JSR newWait

  LDA #0
  STA $900e
  LDA #5
  JSR newWait

  LDA #15
  STA $900e
  LDA #158
  STA $900c
  LDA #50
  STA $d3
  JSR newWait

  LDA #189
  STA $900c
  LDA #25
  STA $d3
  JSR newWait

  LDA #0
  STA $900e
  LDA #25
  JSR newWait

  LDA #15
  STA $900e
  LDA #192
  STA $900c
  LDA #10
  STA $d3
  JSR newWait

  LDA #200
  STA $900c
  LDA #40
  STA $d3
  JSR newWait

  LDA #173
  STA $900c
  LDA #60
  STA $d3
  JSR newWait


  LDA #0
  STA $900e
  RTS

dyingMusic
  LDA #15
  STA $900e

  LDA #192
  STA $900c
  LDA #20
  STA $d3
  JSR newWait

  LDA #200
  STA $900c
  LDA #15
  STA $d3
  JSR newWait

  LDA #158
  STA $900c
  LDA #30
  STA $d3
  JSR newWait

  LDA #0
  STA $900e
  RTS

borderSound
  LDA #15
  STA $900e   ;set volume
  LDA #131
  STA $900c

  LDA #5
  STA $d3
  JSR newWait

  LDA #0
  STA $900e
  RTS

attackHitSound
  LDA #15
  STA $900e   ;set volume
  LDA #151
  STA $900c
  LDA #5
  STA $d3
  JSR newWait
  LDA #131
  STA $900c
  LDA #5
  STA $d3
  JSR newWait
  LDA #0
  STA $900e

tookDamageSound
  LDA #15
  STA $900e   ;set volume
  LDA #131
  STA $900c
  LDA #5
  STA $d3
  JSR newWait
  LDA #151
  STA $900c
  LDA #5
  STA $d3
  JSR newWait
  LDA #0
  STA $900e

  RTS

newWait       ;basic newWait function.
  LDA #0
  STA 162   ;set the Jiffy Clock to 0.

newWaitloop
  LDA 162   ;Compare Jiffy Clock value with length of time to newWait.
  CMP $d3
  BNE newWaitloop
  RTS
