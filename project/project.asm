  org 32768           ; Why 32768? Could it be another location?

start:
  call set_all_white 
  call init_high_score
  call draw_dino_init
  call draw_no_internet
  call pause_loop_spacebar
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
  ld b, 60     ;;Y coordinate of top-left of initial trex position
  ld c, 16     ;;X coordinate of top-left of initlal trex posiiton
  call draw_dino ;;Draw the dino
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
pause_loop_spacebar:
  ld hl, $5c08 ;;ULA fills memory address $5c08 with the last pressed key from the keyboard
  ld (hl), $0  ;;Reset memory position by setting it to zero
pause_inner_loop:
  ld a, (hl)   ;;Load last pressed key from keyboard
  cp $0        ;;Check if it hasn't been pressed yet
  jr z, pause_inner_loop ;;Loop back if it hasn't been touched
  cp 0x30                ;;Did they push spacebar?
  jr z, pause_exit       ;;if they pushed spacebar, exit the pause loop
  jp pause_loop_spacebar ;;if they didn't push spacebar, return back to the pause loop
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
  ld a, $2
  call $1601
  ld de, high_score_example
  ld bc, $4
  call $203c
  ret
high_score_example:
  defb '0000'

draw_dino:
  exx
  ld d, 24
  push de
  ld de, trex_small
  exx
outer_loop:
  push bc      ;save our current y-coord
  call $22aa   ;hl holds pixel-byte addr of c,b

  exx          ;de' holds current trex addr

  ld h, d
  ld l, e      ;hl' now holds current trex addr

  ld b, 3      ;loop 5 times to put 5 bytes of trex onto screen
row_loop:
  ld d, (hl)   ;d holds current trex byte
  push de      ;push trex byte to persist exchange
  exx          ;exchange so hl holds current pixel byte addr
  pop de       ;pop to get current trex byte
  ld (hl), d   ;put current trex byte into current pixel addr byte
  inc hl       ;inc current pixel addr byte
  exx          ;exchange to get current trex byte back in hl
  inc hl       ;inc current trex addr byte
  djnz row_loop;loop until all 5 bytes of row complete

  ld d, h      ;put trex addr into de 
  ld e, l
  exx          ;exchange so state same as start of outer_loop

  pop bc       ;get y-coord
  dec b        ;decrement y-coord
  exx          ;exchange so  
  pop bc       ;loop counter in b'
  dec b        ;decrement loop counter
  push bc      ;push loop counter back on stack
  exx          ;exchange so state same as top of loop
          

  ;loop until all 40 lines of trex drawn
  jp nz, outer_loop
  ret

trex_sprite:
        ;; ROW 1
        defb $00, $00, $03, $ff, $fc 
        defb $00, $00, $03, $ff, $fc
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $ff, $ff
        
        ;; ROW 2
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $fc, $00
        defb $00, $00, $0f, $fc, $00
        defb $00, $00, $0f, $ff, $f0
        defb $00, $00, $0f, $ff, $f0
        defb $c0, $00, $3f, $f0, $00
        defb $c0, $00, $3f, $f0, $00
        
        ;; ROW 3
        defb $c0, $00, $ff, $f0, $00
        defb $c0, $00, $ff, $f0, $00
        defb $f0, $0f, $ff, $ff, $00
        defb $f0, $0f, $ff, $ff, $00
        defb $fc, $3f, $ff, $f3, $00
        defb $fc, $3f, $ff, $f3, $00
        defb $ff, $ff, $ff, $f0, $00
        defb $ff, $ff, $ff, $f0, $00
        
        ;; ROW 4
        defb $3f, $ff, $ff, $f0, $00
        defb $3f, $ff, $ff, $f0, $00
        defb $0f, $ff, $ff, $c0, $00
        defb $0f, $ff, $ff, $c0, $00
        defb $00, $ff, $ff, $00, $00
        defb $00, $ff, $ff, $00, $00
        defb $00, $ff, $fc, $00, $00
        defb $00, $ff, $fc, $00, $00
        
        ;; ROW 5
        defb $00, $3f, $3c, $00, $00
        defb $00, $3f, $3c, $00, $00
        defb $00, $3c, $0c, $00, $00
        defb $00, $3c, $0c, $00, $00
        defb $00, $30, $0c, $00, $00
        defb $00, $30, $0c, $00, $00
        defb $00, $3c, $0f, $00, $00
        defb $00, $3c, $0f, $00, $00

trex_small:
        ;; ROW 1
        defb $00, $00, $00
        defb $00, $00, $00
        defb $00, $00, $00
        defb $00, $00, $00
        defb $00, $1f, $e0
        defb $00, $37, $f0
        defb $00, $3f, $f0
        defb $00, $3f, $f0
        
        ;; ROW 2
        defb $00, $3f, $f0
        defb $00, $3e, $00
        defb $00, $3f, $c0
        defb $80, $7c, $00
        defb $80, $fc, $00
        defb $c3, $ff, $00
        defb $e7, $fd, $00
        defb $ff, $fc, $00
        
        ;; ROW 3
        defb $7f, $fc, $00
        defb $3f, $f8, $00
        defb $0f, $f0, $00
        defb $0f, $e0, $00
        defb $07, $60, $00
        defb $06, $20, $00
        defb $04, $20, $00
        defb $06, $30, $00

;Lock the program in a loop which lasts forever
forever_loop:
  jp forever_loop
