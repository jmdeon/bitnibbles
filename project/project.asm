  org 32768           ; Why 32768? Could it be another location?

start:
  call set_all_white 
  call init_high_score
  call draw_dino_init
  call draw_no_internet
  call pause_loop
  call GAME_LOADING
  call GAME_LOOP
  ret

GAME_LOADING:
  call animate_landscape
  call draw_high_score
  ret

GAME_LOOP:
  ret

;Sets the entire screen (border and center screen) to be white (unhighlighted)
set_all_white:
  ld a, $7    ;;set border to white
  call $229b   ;;send border color to ULA
  ld hl, $5800 ;;start of attr address
  ld de, $5800 ;;start of attr address
  ld (hl), $38 ;;grey background, black foreground
  inc e        ;;move to the next attribute byte
  ld bc, $2ff  ;;32 x 24 attr addresses - 1
  ldir         ;;Loads remaning attribute bytes with $38
  ret

;Initalize the high score value in memory as 0
init_high_score:
  ret

;Initalize and draw the Trex in its starting position
draw_dino_init:
  ld hl, $59e1 ;;Arbritray attribute location which looks good for the dinosaur
  ld (hl), $0  ;;Set the attribute byte as black
  ret

;Draw the no internet string at the bottom of the screen
draw_no_internet:
  ld a, $1     ;;We are placing this at the bottom, so use channel 1
  call $1601   ;;Open channel 1
  ld de, no_internet_string
  ld bc, $1f   ;;The string is 31 characters
  call $203c   ;;Call the print routine in the ROM
  ret
no_internet_string:
  defb 'There is no Internet connection'

;Loop which holds until the user presses any button
pause_loop:
  ld hl, $5c08 ;;ULA fills memory address $5c08 with the last pressed key from the keyboard
  ld (hl), $0  ;;Reset memory position by setting it to zero
pause_inner_loop:
  ld a, (hl)   ;;Load last pressed key from keyboard
  cp $0        ;;Check if it hasn't been pressed yet
  jr z, pause_inner_loop ;;Loop back if it hasn't been touched
  cp 0x30                ;;Did they push spacebar?
  jr z, pause_exit       ;;if they pushed spacebar, exit the pause loop
  jp pause_loop          ;;if they didn't push spacebar, return back to the pause loop
  jp pause_exit
pause_exit:
  ret

;Animate the landscape once the user leaves the welcome screen
animate_landscape:
  call 0x229b      ;;For now, set the background color to the value of 0x30 (spacebar) to simulate moving on, this WILL be removed once we have correct functionality @TODO
  jp forever_loop  ;;For now, lock the program here, this WILL be removed once we have correct functionality @TODO
  ret

;Draw the current highscore onto the screen
draw_high_score:
  ret

;Lock the program in a loop which lasts forever
forever_loop:
  jp forever_loop
