  org 32768           ; Why 32768? Could it be another location?

start:
  call set_all_white 
  call draw_dino_init
  call draw_no_internet
  call pause_loop_spacebar
  call setup
  
  
start_loop:
    jp start_loop
 

    
;Counter for frame interrupts    
counter:
    defb $0
  
  
;Main game loop, choses what to draw in each frame
GAME_LOOP:
    di                          ;Disable interrupts
    ld hl, end_game_flag
    ld a, (hl)
    cp 0
    jp nz, frame_end
    ld hl, counter              ;Load counter location for frames
    ld a, (hl)                  ;Load counter
    cp $0                       ;Compare counter to zero 
    call nz, draw_cactus        ;Draw cactus if counter not zero, allows dinosaur to be drawn
    ld hl, counter              ;Load counter location for frames
    ld a, (hl)                  ;Load counter
    cp $0                       ;Compare counter to zero 
    call z, jump_iterate        ;Draw dinosaur if counter is zero
    ld hl, counter              ;Load counter
    ld a, (hl)                  ;Load counter
    cp $2                       ;Maximum frames
    jp z, reset_counter         ;If frame reached, reset counter
    inc (hl)                    ;Increment counter because max frame not reached
    jp frame_end                ;Skip reset counter
reset_counter:
    ld (hl), $0                 ;Reset counter
frame_end:
    ld a, $3    ;;set border to purple
    call $229b
    call $0038                  ;Call builtin interrupt to grab keyboard
    ld a, $7    ;;set border to purple
    call $229b
    ei                          ;Enable interrupts
    ret
    

;Initalize and draw the Trex in its starting position
draw_dino_init:
  ld hl, trex_stand
  ld c, 16     ;;X coordinate of top-left of initlal trex position
  ld b, 60     ;;Y coordinate of top-left of initial trex position
  call draw_bitmap ;;Draw the dino
  
  ld hl, jmp_index
  ld (hl), 0
  
  ld b, 60
  ld c, 232
  ld hl, cact2_2
  call draw_bitmap
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
    
GAME_END:
    im 1
    ei
    call pause_loop_spacebar
    call set_pixels_white
     ld hl, end_game_flag
    ld (hl), 0
    ld hl, cact_count
    ld (hl), 0
    ld hl, pos
    ld (hl), 232
    call draw_no_internet
    call draw_dino_init
    call setup
    jp start_loop

draw_end_screen:
   ret
   
;Setup for interrupt handler   
;
setup:
    ld hl, $fff4        ;Store 'jp GAME_LOOP' at $fff4
    ld bc, GAME_LOOP    ;Grab GAME_LOOP Address
    ld (hl), $c3        ;Store 'jp'
    inc hl              ;Move 1 byte to the right
    ld (hl), c          ;Store first byte of address
    inc hl              ;Move 1 byte to the right
    ld (hl), b          ;Store second byte of address
    ld hl, $ffff        ;Store '$18' at $ffff, causing wrap around
    ld (hl), $18        ;Store '$18' aka 'jr'
    ld a, $39           ;Load '$39' in I to get '$ffff' from $3900 to $39ff
    ld i, a             ;Load a into I
    
    im 2
    ei
    ret
   
   
   
   

;Counter of cactus position
cact_count:
    defb 0
  
;Handle drawing cactus
draw_cactus:
    ld hl, cact_count       ;Load cactus position
    ld a, (hl)              ;Load cactus position
    cp 0                    ;Check if first position
    call z, cact_1          ;If so, draw cactus 1
    ld hl, cact_count       ;Load cactus position
    ld a, (hl)              ;Load cactus position
    cp 1                    ;Check if second position
    call z, cact_2          ;If so, draw cactus 2
    
    
    ;Cactus counter reset logic
    ld hl, cact_count       ;Load cactus counter
    ld a, (hl)
    cp 1                    ;Check if counter is at maximum position
    jp z, reset_cact_count  ;If so, reset cactus counter
    inc (hl)                ;Increment
    jp cact_fin
reset_cact_count:  
    ld (hl), 0              ;Reset to zero
cact_fin:
    ret
    
    
;Maximum position of cactus on right side of the screen   
pos: 
    defb 232
    

;Draw cactus 1, delete cactus 2    
cact_1:

  ld b, 60              ;Load Y Position of cactus 2 into b
  ld hl, pos            ;Load X position location
  ld c, (hl)            ;Load X position into c
  ld hl, cact2_2        ;Load cactus 2 bitmap
  call delete_bitmap    ;Delete cactus 2
  
  ld hl, pos            ;Load X position location
  ld a, (hl)            ;Load X position into a
  cp 0                  ;Lowest X position on screen
  jp z, reset_cact_pos  ;If there, reset position
  sub 8                 ;Subtract 8 to move 8 bits left
  ld (hl), a            ;Store result into position
  jp pos_end            ;Skip reloading position
reset_cact_pos:
  ld a, 232             ;Load maximum X location into position 
  ld (hl), a            ;Store new position
pos_end:

  
  ld hl, pos            ;Load X position location
  ld c, (hl)            ;Load X position into c                
  ld b, 60              ;Load Y position into b
  ld hl, cact2_1        ;Load cactus 1 bitmap
  call draw_bitmap      ;Draw cactus 1 bitmap
  ret
  
  
;Delete cactus 1, draw cactus 2
cact_2:

  ld b, 60              ;Load Y position into b
  ld hl, pos            ;Load X position location
  ld c, (hl)            ;Load X position into c
  ld hl, cact2_1        ;Load Cactus 1 bitmap
  call delete_bitmap    ;Delete cactus 1 bitmap
  
  ld b, 60              ;Load Y position into b
  ld hl, pos            ;Load X position location
  ld c, (hl)            ;Load X position into c
  ld hl, cact2_2        ;Load Cactus 2 bitmap
  call draw_bitmap      ;Draw Cactus 2 bitmap
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
  jp nz, jmp_index_not_11  ;if jump index is not 8, jump forward and check if it's 0
  ld b, 0                 ;if jump index is 8, reset it
  ld (hl), b              ;save the index value and exit
  jp jmp_end     
jmp_index_not_11:
  ld a, 0                 
  cp b                    
  jp nz, jmp_next_index   ;if the index is not zero, jump forward and increment
  ld hl, $5c08          
  ld a, (hl)              ;load in the last pressed key from the keyboard to a
  cp $30                  
  jp nz, jmp_end          ;if the last key wasn't a spacebar, exit. Else inc
  ld (hl), 0 ;if the last key wasn't a spacebar, exit. Else inc
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
  
set_pixels_white:
  ld hl, $4000
  ld de, $4000
  ld (hl), 0
  inc e
  ld bc, $17ff
  ldir
  ret




;Loop which holds until the user presses any button
pause_loop_spacebar:
  ld hl, $5c08 ;;ULA fills memory address $5c08 with the last pressed key from the keyboard
  ld (hl), 0  ;;Reset memory position by setting it to zero
pause_inner_loop:
  ld hl, $5c08
  ld a, (hl)   ;;Load last pressed key from keyboard
  cp 0        ;;Check if it hasn't been pressed yet
  jr z, pause_inner_loop ;;Loop back if it hasn't been touched
  cp $30                ;;Did they push spacebar?
  jp nz, pause_loop_spacebar ;;if they didn't push spacebar, return back to the pause loop
  ret


;hl bitmap addr
;b   loop counter
;bc' x,y
;hl' pixel byte addr
;d' draw byte
;assume hl holds bitmap addr 
;assume bc holds x,y
draw_bitmap:
  ;ld a, $0    ;;set border to black
  ;call $229b
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

  ;ld a, $7    ;;set back
  ;call $229b
  ld hl, end_game_flag
  ld a, $ff
  xor (hl)
  jp z, GAME_END
  ret

set_end_game_flag:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting

end_game_flag:
  defb $00

delete_bitmap:
  ;ld a, $3    ;;set border to purple
  ;call $229b
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
  ;ld a, $7    ;;set back
  ;call $229b
  ret


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



;; 3rd part of animation
cact2_2:
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
        
        
