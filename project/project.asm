  org 32768           ; Why 32768? Could it be another location?

start:
  call pre_compute_dino_addrs
  call set_all_white 
  call draw_land
  call draw_land0
  call draw_dino_init
  call draw_no_internet
  call pause_loop_spacebar
  call setup
  
start_loop:
    jp start_loop
    

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
    
;Initalize and draw the Trex in its starting position
draw_dino_init:
  ld hl, trex_stand
  ld c, 16     ;;X coordinate of top-left of initlal trex position
  ld b, 60     ;;Y coordinate of top-left of initial trex position
  call draw_bitmap_dino ;;Draw the dino
  ld hl, jmp_index
  ld (hl), 0
  ld b, 60
  ld c, 232
  ld hl, cact2_2
  call draw_bitmap
  ret
    
;Draw the no internet string at the bottom of the screen
draw_no_internet:
  ld b, 7
  ld c, 0
  ld de, $3ea0    ;T
  call draw_char
  ld de, $3f40    ;h
  call draw_char
  ld de, $3f28    ;e
  call draw_char
  ld de, $3f90    ;r
  call draw_char
  ld de, $3f28    ;e
  call draw_char
  ld a, c
  add 8           ;_
  ld c, a        
  ld de, $3f48    ;i
  call draw_char
  ld de, $3f98    ;s
  call draw_char
  ld a, c
  add 8           ;_
  ld c, a
  ld de, $3f70    ;n
  call draw_char
  ld de, $3f78    ;o
  call draw_char
  ld a, c
  add 8           ;_
  ld c, a
  ld de, $3e48    ;I
  call draw_char
  ld de, $3f70    ;n
  call draw_char
  ld de, $3fa0    ;t
  call draw_char
  ld de, $3f28    ;e
  call draw_char
  ld de, $3f90    ;r
  call draw_char
  ld de, $3f70    ;n
  call draw_char
  ld de, $3f28    ;e
  call draw_char
  ld de, $3fa0    ;t
  call draw_char
  ld a, c
  add 8           ;_
  ld c, a
  ld de, $3f18    ;c
  call draw_char
  ld de, $3f78    ;o
  call draw_char
  ld de, $3f70    ;n
  call draw_char
  ld de, $3f70    ;n
  call draw_char
  ld de, $3f28    ;e
  call draw_char
  ld de, $3f18    ;c
  call draw_char
  ld de, $3fa0    ;t
  call draw_char
  ld de, $3f48    ;i
  call draw_char
  ld de, $3f78    ;o
  call draw_char
  ld de, $3f70    ;n
  call draw_char
  ret

;;Draw Caharacter (Unraveled loop, so repeated 8 times for every pixel row
;;b and c holds the x, y position to draw at
;;b is preserved
;;c is preserbed but also incremented by 8
draw_char:
  push bc

  ;;de holds the character memory position to draw
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next 
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next 
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next
  push de     ;save the current address of the character to print
  push bc     ;save the current x, y
  call $22aa  ;place the pixel address into hl
  pop bc      ;retreive the current x,y
  dec b       ;decrement the y
  pop de      ;retreive the address of the character to print
  push de     ;push de back onto stack //IS THIS NEEDED?
  push hl     ;save the current pixel address
  ld h, d     
  ld l, e
  ld d, (hl)  ;load the current pixel mapping into d
  pop hl      ;retreive the current pixel address
  ld (hl), d  ;set the pixel mapping into the pixel address
  pop de      ;retreive the base character address
  inc de      ;increment into the next

  pop bc
  ld a, c
  add 8
  ld c, a
  ret 
    
;Loop which holds until the user presses any button
pause_loop_spacebar:
  call check_spacebar
  ld hl, spacebar_value
  ld a, (hl)   ;;Load last pressed key from keyboard
  cp $1        ;;Check if it hasn't been pressed yet
  jp nz, pause_loop_spacebar ;;if they didn't push spacebar, return back to the pause loop
  ret
    
   
spacebar_value:
    defb $0
    
check_spacebar:
  ld hl, spacebar_value                  ;Location that is checked in jump iterate     
  ld a, $7f
  IN a, ($fe)
  rra
  jp nc, spacebar_set
  ld (hl), $0
  jp end_spacebar_check
spacebar_set:     
  ld (hl), $1                  ;Load value that is checked in jump iterate
end_spacebar_check:
  ret
  
  
;Setup for interrupt handler   
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

  

  
;Counter for frame interrupts    
counter:
    defb $0
  
;Main game loop, choses what to draw in each frame
GAME_LOOP:
    di                          ;Disable interrupts
    ld hl, end_game_flag        ;Check if game has ended
    ld a, (hl)                  ;Load end game flag
    cp 0                        ;Compare to 0 (0 = game still playing)
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
    call check_spacebar
    call beep
    ei                          ;Enable interrupts
    ret
   
  
beep_value:
    defb $0
  
beep:
  ld hl, beep_value
  ld a, (hl)
  cp 0
  jp z, beep_end
  ld hl, 497
  ld de, 20
  call $3b5               ;Play a tone every time the player jumps
beep_end:
  ld hl, beep_value
  ld (hl), $0
  ret
   
   
hold:
    inc a
    ld bc,$0fff         ; max waiting time. Why?
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret
    
long_hold:
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    ret
    
 
GAME_END:
    ld hl, previous_walking
    ld (hl), 0
    ld hl, 7000
    ld de, 3
    call $3b5  ;Play a sharp tone to signify that the game has ended
    call hold
    ld hl, 7000
    ld de, 3
    call $3b5  ;Play a sharp tone to signify that the game has ended
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
    ld hl, $5c8a
    ld (hl), $01
    inc hl
   ld (hl), $18
    call draw_no_internet
    call draw_dino_init
    call draw_land
    call draw_land0
    call long_hold
    call pause_loop_spacebar
    call setup
    jp start_loop

   
set_pixels_white:
  ld hl, $4000
  ld de, $4000
  ld (hl), 0
  inc e
  ld bc, $17ff
  ldir
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
    call draw_land
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
  call scroll_land_routine
  
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
  call scroll_land_routine
  
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
  jp nz, jmp_index_not_11  ;if jump index is not 11, jump forward and check if it's 0
  ld b, 0                 ;if jump index is 11, reset it
  ld (hl), b              ;save the index value and exit
  jp jmp_end     
jmp_index_not_11:
  ld a, 0                 
  cp b                    
  jp nz, jmp_next_index   ;if the index is not zero, jump forward and increment
  ld hl, spacebar_value          
  ld a, (hl)              ;load in the last pressed key from the keyboard to a
  cp $1                  
  jp nz, jmp_walk          ;if the last key wasn't a spacebar, walk the trex. Else inc
  ld (hl), 0
  ld hl, beep_value
  ld (hl), $1
  call delete_current_walking
  ld hl, previous_walking
  ld (hl), 0
  ld hl, jmp_index
  ld b, (hl)
  jp jmp_next_index_no_delete
jmp_next_index:
  call jmp_load_b         ;b = jmp_positions[old_index]
  ld hl, trex_stand
  ld c, 16
  call delete_bitmap      ;delete the previous trex
jmp_next_index_no_delete:
  ld hl, jmp_index
  ld b, (hl)
  inc b
  ld (hl), b              ;save the new index value
  call jmp_load_b
  ld hl, trex_stand
  ld c, 16
  ;call draw_bitmap        ;draw the trex in the new position
  call draw_bitmap_dino ;;Draw the dino
  jp jmp_end
jmp_walk:
  call draw_next_walking 
jmp_end:
  ret

jmp_load_b:   ;Expects b to hold index and will return y position in b
  ld d, 0
  ld e, b
  ld hl, jmp_positions    
  add hl, de              ;increment the pointer to base + index
  ld b, (hl)              ;b = jmp_positions[index]
  ret

walking_counter:     ;used to determine when to switch to the next leg when walking
  defb $00

draw_next_walking:
  ld hl, walking_counter
  ld b, (hl)            ;load the walking counter
  ld a, 1               
  cp b
  jp nz, reset_walking_counter  ;reset the walking counter every other frame when walking
  ld hl, previous_walking       ;load the previous position the player was in (stepping position, i.e. which feet were down)
  ld b, (hl)
  ld a, 1
  cp b
  jp nz, walking_left           ;if the player didn't previously have the left leg up, jump ahead and make the next move have the left leg up 
walking_right:
  call delete_current_walking   ;if the player was on the left leg, delete the previous position and draw the trex with the right left up
  ld hl, trex_right_up
  ld c, 16
  ld b, 60
  ;call draw_bitmap
  call draw_bitmap_dino ;;Draw the dino
  ld hl, previous_walking
  ld (hl), 2                     ;set the previous walking position as the right leg up
  jp save_walking
walking_left:
  call delete_current_walking   ;delete the previous walking position and draw with the left leg up
  ld hl, trex_left_up
  ld c, 16
  ld b, 60
  ;call draw_bitmap
  call draw_bitmap_dino ;;Draw the dino
  ld hl, previous_walking
  ld (hl), 1
  jp save_walking
reset_walking_counter:
  ld (hl), 0
save_walking:
  ld hl, walking_counter
  inc (hl)
  ret

previous_walking:                ;keep track of the previous leg position, 0 = standing, 1 = left leg up, 2 = right leg up
  defb $00

delete_current_walking:
  ld hl, previous_walking
  ld b, (hl)
  ld a, 0
  cp b
  call z, delete_standing       ;if the previous position was 0, delete a standing trex
  ld hl, previous_walking
  ld b, (hl)
  ld a, 1
  cp b
  call z, delete_left_foot      ;if the previous position was 1, delete a left leg up trex
  ld hl, previous_walking
  ld b, (hl)
  ld a, 2
  cp b
  call z, delete_right_foot     ;if the previous position was 2, delete a right leg trex
  ret

delete_standing:
  ld hl, trex_stand
  ld c, 16
  ld b, 60
  call delete_bitmap
  ret

delete_left_foot:
  ld hl, trex_left_up
  ld c, 16
  ld b, 60
  call delete_bitmap
  ret

delete_right_foot:
  ld hl, trex_right_up
  ld c, 16
  ld b, 60
  call delete_bitmap
  ret
  

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
  jp z, GAME_END
  ret
  

end_game_flag:
  defb $00

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


draw_bitmap_dino:
  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, 24
  push bc
outer_loop_dino:
  
  exx
  push bc  ;save current y coord
  call get_pixel_addr_dino   ;hl' holds pixel-byte addr of c,b

  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de

  pop af  ;a has y-coord
  push af ; x,y still saved on stack
  sub 41


  jp c, done_setting0
  
collision_detection0:
  ld a, d      ;put trex byte into accumulator
  and (hl)     ;collision detection
  jp nz, set_end_game_flag0
done_setting0: 
  ld a,d
  or (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de

  pop af  ;a has y-coord
  push af ; x,y still saved on stack
  sub 41


  jp c, done_setting1
  
collision_detection1:
  ld a, d      ;put trex byte into accumulator
  and (hl)     ;collision detection
  jp nz, set_end_game_flag1
done_setting1: 
  ld a,d
  or (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de

  pop af  ;a has y-coord
  push af ; x,y still saved on stack
  sub 41


  jp c, done_setting2
  
collision_detection2:
  ld a, d      ;put trex byte into accumulator
  and (hl)     ;collision detection
  jp nz, set_end_game_flag2
done_setting2: 
  ld a,d
  or (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

  jp nz, outer_loop_dino
  pop bc

  ld hl, end_game_flag
  ld a, $ff
  xor (hl)
  jp z, GAME_END
  ret

set_end_game_flag0:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting0

set_end_game_flag1:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting1

set_end_game_flag2:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting2


delete_bitmap_dino:
  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, 24
  push bc
delete_outer_loop_dino:

  exx
  push bc  ;save current y coord
  call get_pixel_addr_dino   ;hl' holds pixel-byte addr of c,b

  ld b, 3
delete_row_loop_dino:
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

  djnz delete_row_loop_dino;loop until all 3 bytes of row complete
  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

  jp nz, delete_outer_loop_dino
  pop bc
  ret

get_pixel_addr_dino:
  ld d, $f0
  ld a, b
  sub 36
  sla a
  ld e, a
  ld a, (de)
  inc de
  ld h, a
  ld a, (de)
  inc de
  ld l, a
  ret

draw_land:
  ld c, 0
  ld b, 40
  call $22aa ;hl holds addr of start of land

  ld b, 32
land_loop0:
  ld (hl), $ff
  inc hl
  dec b
  jp nz, land_loop0
  ret

draw_land0:
  ld c, 0
  ld b, 38
  call $22aa ;hl holds addr of start of land

  ld b, 32
  ld de, 100
land_loop1:
  ld a, (de)
  and $30
  ld (hl),a
  inc hl
  inc de
  dec b
  jp nz, land_loop1


  ld c, 0
  ld b, 36
  call $22aa ;hl holds addr of start of land

  ld b, 32
land_loop2:
  ld a, (de)
  and $03
  ld (hl),a
  inc hl
  inc de
  dec b
  jp nz, land_loop2
  ret



pre_compute_dino_addrs:
  ld de, $f000

  ld c, 16
  ld b, 36
  exx
  ld b, 73
precomp_loop:
  exx

  push bc
  call $22aa
  ld a, h
  ld (de),a
  inc de
  ld a, l
  ld (de),a
  inc de

  pop bc
  inc b ;decrement y-coord
  exx
  dec b ;decrement loop counter
  jp nz, precomp_loop
  ret


scroll_land_routine:
  ld c, 0
  ld b, 38
  call $22aa ;hl holds addr of start of land on left
  ld a, (hl)
  and $f0    ;mask out left nibble
  rrca
  rrca
  rrca
  rrca
  ld d, a   ;store nibble in d for later
  ld bc, 31
  add hl, bc ; hl is now rightmost byte on screen

  ld b, 32
scroll_loop0: ;d is holding last bytes' nibble
  ld a, (hl)
  ld c, a ;save byte in c
  and $0f ;mask out right nibble
  rlca
  rlca
  rlca
  rlca
  or d
  ld (hl), a
  ld a, c ;get byte back in c
  and $f0 ;mask out left nibble
  rrca
  rrca
  rrca
  rrca
  ld d, a
  dec hl
  dec b
  jp nz, scroll_loop0
  
  ld c, 0
  ld b, 36
  call $22aa ;hl holds addr of start of land on left
  ld a, (hl)
  and $f0    ;mask out left nibble
  rrca
  rrca
  rrca
  rrca
  ld d, a   ;store nibble in d for later
  ld bc, 31
  add hl, bc ; hl is now rightmost byte on screen

  ld b, 32
scroll_loop1: ;d is holding last bytes' nibble
  ld a, (hl)
  ld c, a ;save byte in c
  and $0f ;mask out right nibble
  rlca
  rlca
  rlca
  rlca
  or d
  ld (hl), a
  ld a, c ;get byte back in c
  and $f0 ;mask out left nibble
  rrca
  rrca
  rrca
  rrca
  ld d, a
  dec hl
  dec b
  jp nz, scroll_loop1

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
        
        
