  org 32768           ; Why 32768? Could it be another location?

start:
  call set_all_white 
  call init_high_score
  call draw_dino_init
  call draw_no_internet
  call pause_loop_spacebar
  call GAME_LOOP
  ret

GAME_LOOP:
    call jump_iterate
    call hold
    call cact_1
    call hold
    call cact_2
    call hold
    call cact_3
    call hold
    call cact_4
    call hold
    call cact_5
    jp GAME_LOOP
  ret
  
  
  
hold:
    inc a
    ld bc,$02ff         ; max waiting time. Why?
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret
  

pos: defb $a0

dino_1:
  ld hl, trex_right_up
  ld b, 60
  ld c, 16
  call draw_bitmap
  ret
  
dino_2:
  
  ld hl, trex_right_up
  ld b, 60
  ld c, 16
  call delete_bitmap
  
  ld hl, trex_left_up
  ld b, 60
  ld c, 16
  call draw_bitmap
  ret

dino_3:
  
  ld hl, trex_left_up
  ld b, 60
  ld c, 16
  call delete_bitmap
  ret
  


cact_1:
  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_1
  call draw_bitmap
  ret
  
cact_2:

  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_1
  call delete_bitmap

  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_2
  call draw_bitmap
  ret
  
cact_3:

  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_2
  call delete_bitmap
  
  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_3
  call draw_bitmap
  ret
  
cact_4:
  
  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_3
  call delete_bitmap
  
  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_4
  call draw_bitmap
  ret
  
cact_5:
  
  ld b, 60
  ld hl, pos
  ld c, (hl)
  ld hl, cact2_4
  call delete_bitmap
  
  ld hl, pos
  ld a, (hl)
  sub a, 8
  ld (hl), a
  ret


jmp_positions:
  defb 60, 70, 80, 100, 105, 109, 109, 105, 100, 80, 70, 60

jmp_index:
  defb 00

jump_iterate:
  ld hl, jmp_index        
  ld b, (hl)              ;Load the jump index value into b
  ld a, 11                 ;a is the number of positions in the jump array
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
  ld hl, 497
  ld de, 20
  call 949
  ld hl, jmp_index
  ld b, (hl)
jmp_next_index: ;THIS IS WEHERE IT GETS REALLY WEIRD
  call jmp_load_b         ;b = jmp_positions[old_index]
  ld hl, trex_stand
  ld c, 16
  call delete_bitmap      ;delete the previous trex
  ld hl, jmp_index
  ld b, (hl)
  inc b
  ld (hl), b              ;save the new index value
  call jmp_load_b
  ld hl, trex_stand
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
  ld hl, trex_stand
  ld c, 16     ;;X coordinate of top-left of initlal trex posiiton
  ld b, 60     ;;Y coordinate of top-left of initial trex position
  call draw_bitmap ;;Draw the dino
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

  
  
  
;hl bitmap addr
;b   loop counter
;bc' x,y
;hl' pixel byte addr
;d' draw byte

;assume hl holds bitmap addr 
;assume bc holds x,y
draw_bitmap:
  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, 24
  push bc
outer_loop:
  
  exx
  push bc  ;save current y coord
  call $22aa   ;hl' holds pixel-byte addr of c,b

  ld b, 3
row_loop:
  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de

  ld a, d      ;put trex byte into accumulator
  and (hl)     ;collision detection
  jp nz, set_end_game_flag
done_setting: 
  ld a,d
  or (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  djnz row_loop;loop until all 3 bytes of row complete
  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

  jp nz, outer_loop
  pop bc

  ld hl, end_game_flag
  ld a, $ff
  xor (hl)
  jp z, end_game
  ret


set_end_game_flag:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting

end_game_flag:
  defb $00

end_game:
  jp end_game


delete_bitmap:
  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, 24
  push bc
delete_outer_loop:
  
  exx
  push bc  ;save current y coord
  call $22aa   ;hl' holds pixel-byte addr of c,b

  ld b, 3
delete_row_loop:
  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de
  
  ld a,d
  xor (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  djnz delete_row_loop;loop until all 3 bytes of row complete
  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

  jp nz, delete_outer_loop
  pop bc
  ret

high_score_value:
        defw $00


;hold for a brief moment

    

;Lock the program in a loop which lasts forever
forever_loop:
  jp forever_loop

  
  
trex_stand:
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
        
trex_left_up:
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
        defb $06, $60, $00
        defb $03, $20, $00
        defb $00, $20, $00
        defb $00, $30, $00
        
trex_right_up:
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
        defb $07, $30, $00
        defb $06, $00, $00
        defb $04, $00, $00
        defb $06, $00, $00

cact2_1:
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

;; 2nd part of animation
cact2_2:
        ;; ROW 1
        defb $00, $18, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $06, $3c, $40
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        
        ;; ROW 2
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        defb $0f, $3c, $e0
        defb $0f, $ff, $e0
        defb $07, $ff, $c0
        
        ;; ROW 3
        defb $01, $ff, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        
        

;; 3rd part of animation
cact2_3:
        ;; ROW 1
        defb $00, $60, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $18, $f1, $00
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        
        ;; ROW 2
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        defb $3c, $f3, $80
        defb $3f, $ff, $80
        defb $1f, $ff, $00
        
        ;; ROW 3
        defb $07, $fc, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        
        
;; 4th part of animation
cact2_4:
        ;; ROW 1
        defb $01, $80, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $63, $c4, $00
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        
        ;; ROW 2
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        defb $f3, $ce, $00
        defb $ff, $fe, $00
        defb $7f, $fc, $00
        
        ;; 
        defb $1f, $f0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
  