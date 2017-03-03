  org 32768           ; Why 32768? Could it be another location?

start:
  call set_all_white 
  call init_high_score
  call draw_dino_init
  call draw_no_internet
  call pause_loop_spacebar
  ;call GAME_LOADING
  call GAME_LOOP
  ;jp forever_loop
  ret

GAME_LOADING:
  call animate_landscape
  call draw_high_score
  ret

GAME_LOOP:
    ;call jump_demo
    call jump_iterate
    call hold
    jp GAME_LOOP
  ret

jmp_positions:
  defb 60, 80, 90, 120, 120, 80, 80, 60

jmp_index:
  defb 00

jump_iterate:
  ld hl, jmp_index        
  ld b, (hl)              ;Load the jump index value into b
  ld a, 7                 ;a is the number of positions in the jump array
  cp b              
  jp nz, jmp_index_not_8  ;if jump index is not 8, jump forward and check if it's 0
  ld b, 0                 ;if jump index is 8, reset it
  ld (hl), b              ;save the index value and exit
  jp jmp_end     
jmp_index_not_8:
  ld a, 0                 
  cp b                    
  jp nz, jmp_next_index   ;if the index is not zero, jump forward and increment
  ld hl, $5c08          
  ld a, (hl)              ;load in the last pressed key from the keyboard to a
  cp $30                  
  jp nz, jmp_end          ;if the last key wasn't a spacebar, exit. Else inc
  ld (hl), 0
jmp_next_index: ;THIS IS WEHERE IT GETS REALLY WEIRD
  call jmp_load_b         ;b = jmp_positions[old_index]
  ld de, trex
  ld c, 16
  call delete_bitmap      ;delete the previous trex
  ld hl, jmp_index
  ld b, (hl)
  inc b
  ld (hl), b              ;save the new index value
  call jmp_load_b
  ld de, trex
  ld c, 16
  call draw_bitmap        ;draw the trex in the new position
jmp_end:
  ret

jmp_load_b:   ;Expects b to hold index and will return y position in b
  ld d, 0
  ld e, b
  ld hl, jmp_positions    
  add hl, de              ;increment the pointer to base + index
  ld b, (hl)              ;b = jmp_positions[index]
  ret
  

  ;===============================
  ;===============================
  ;load index
  ;if index == 7:
  ;   set index to 0
  ;load jump
  ;if (index == 0 && jump) || (index != 0):
  ;   load y = jump_positions[index]
  ;   delete dino at y
  ;   load y = jump_positions[index] + 1
  ;   draw dino at y
  ;   load jump_index
  ;   inc jump_index
  ;store index
  ;ret
  

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
  ld de, trex
  ld c, 16     ;;X coordinate of top-left of initlal trex posiiton
  ld b, 60     ;;Y coordinate of top-left of initial trex position
  call draw_bitmap ;;Draw the dino
  ;ld de, trex
  ;ld c, 16     ;;X coordinate of top-left of initlal trex posiiton
  ;ld b, 100     ;;Y coordinate of top-left of initial trex position
  ;call draw_bitmap 
  ld de, cactus
  ld c, 40     ;;X coordinate of top-left of initlal trex posiiton
  ld b, 60    ;;Y coordinate of top-left of initial trex position
  call draw_bitmap 
  ;ld de, trex
  ;ld c, 50
  ;ld b, 100
  ;call draw_bitmap
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

draw_bitmap:
  push de
  exx
  pop de
  ld h, d
  ld l, e
  ld d, (hl)
  inc hl
  ld e, (hl)
  inc hl
  push de
  ld d, h
  ld e, l
  exx
outer_loop:
  push bc      ;save our current y-coord
  call $22aa   ;hl holds pixel-byte addr of c,b

  exx          ;de' holds current trex addr

  ld h, d
  ld l, e      ;hl' now holds current trex addr

  pop de       ;de has xy
  pop bc       ;bc has height/width
  push bc      
  push de      
  ld b, c      ;loop width times to put 5 bytes of trex onto screen
row_loop:
  ld d, (hl)   ;d holds current trex byte
  push de      ;push trex byte to persist exchange
  exx          ;exchange so hl holds current pixel byte addr

  pop de       ;pop to get current trex byte
  ld a, d      ;put trex byte into accumulator
  and (hl)
  jp nz, end_game
  ld a, d
  or (hl)
  ld (hl), a   ;DRAW TREX BYTE
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

  pop bc
  ret


end_game:
  jp end_game

delete_bitmap:
  push de
  exx
  pop de
  ld h, d
  ld l, e
  ld d, (hl)
  inc hl
  ld e, (hl)
  inc hl
  push de
  ld d, h
  ld e, l
  exx
delete_outer_loop:
  push bc      ;save our current y-coord
  call $22aa   ;hl holds pixel-byte addr of c,b

  exx          ;de' holds current trex addr

  ld h, d
  ld l, e      ;hl' now holds current trex addr

  pop de       ;de has xy
  pop bc       ;bc has height/width
  push bc      
  push de      
  ld b, c      ;loop width times to put 5 bytes of trex onto screen
delete_row_loop:
  ld d, (hl)   ;d holds current trex byte
  push de      ;push trex byte to persist exchange
  exx          ;exchange so hl holds current pixel byte addr

  pop de       ;pop to get current trex byte
  ld a, d      ;put trex byte into accumulator
  xor (hl)
  ld (hl), a   ;DRAW TREX BYTE
  inc hl       ;inc current pixel addr byte

  exx          ;exchange to get current trex byte back in hl
  inc hl       ;inc current trex addr byte
  djnz delete_row_loop;loop until all 5 bytes of row complete

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
  jp nz, delete_outer_loop

  pop bc
  ret


high_score_value:
        defw $00

trex:
        ;; ROW 1
        defb 24, 3
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

cactus:
        defb 24, 3
        ;; ROW 1
        defb $00, $06, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $01, $8f, $10
        defb $03, $cf, $38
        defb $03, $cf, $38
        
        ;; ROW 2
        defb $03, $cf, $38
        defb $03, $cf, $38
        defb $03, $cf, $38
        defb $03, $cf, $38
        defb $03, $cf, $38
        defb $03, $cf, $38
        defb $03, $ff, $f8
        defb $01, $ff, $f0
        
        ;; ROW 3
        defb $00, $7f, $c0
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00

;hold for a brief moment
hold:
    inc a
    ld bc,$1fff         ; max waiting time. Why?
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret

jump_demo:
  ld de, trex
  ld c, 16
  ld b, 60
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 80
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 80
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 90
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 90
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 100
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 100
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 100
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 100
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 90
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 90
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 80
  call draw_bitmap
  call hold
  ld de, trex
  ld c, 16
  ld b, 80
  call delete_bitmap
  ld de, trex
  ld c, 16
  ld b, 60
  call draw_bitmap
  call hold 
  jp jump_demo

;Lock the program in a loop which lasts forever
forever_loop:
  jp forever_loop
