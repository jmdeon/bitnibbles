; Hello world program with drawing
; Maybe include more information?


    org 32768           ; Why 32768? Could it be another location?

    
                        ; Do we need this?
    ld hl, 22560        ; draw black over the bytes message
    ld b, 13
clearloop:         
    ld (hl), 0
    inc hl
    dec b
    jp nz, clearloop
    jp start



hold:
    inc a
    ld bc,$1fff         ; max waiting time. Why?
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret
    
    
    
                        ; horiz_line draws to the right while
                        ; all others draw downward
    
horiz_line:
    ld (hl), 28         ; Color
    push bc             ; Save our b counter
    call hold           ; Call hold to make drawing appearance
    pop bc              ; Retrieve b
    inc hl              ; Move to the right
    dec b               ; Decrement counter
    jp nz, horiz_line   ; Loop until counter is 0
    ret

vertical_line:
    ld (hl), 28
    push bc             ; save our b counter
    call hold
    pop bc
    ld de, 32           ; Move downward
    add hl, de
    dec b
    jp nz, vertical_line
    ret
    
diag_right_line:
    ld (hl), 28
    push bc             ; save our b counter
    call hold
    pop bc
    ld de, 33           ; Move down and to the right
    add hl, de
    dec b
    jp nz, diag_right_line
    ret
    
diag_left_line:
    ld (hl), 28
    push bc             ; save our b counter
    call hold
    pop bc
    ld de, 31           ; Move down and to the left
    add hl, de
    dec b
    jp nz, diag_left_line
    ret

                        ; 22528 or hex 0x5800 is the start of the screen, goes until 
                        ; decimal 23296
    
start:
                        ; draw H-left
    ld hl, 22592        ; Sets starting position
    ld b,8              ; Distance to travel
    call vertical_line
    
                        ; draw H-right
    ld hl, 22596
    ld b,8
    call vertical_line
    
    
                        ; draw H-mid
    ld hl, 22688
    ld b, 4
    call horiz_line
    


                        ; draw E-stem
    ld hl, 22599
    ld b,8
    call vertical_line

                        ; draw E-top
    ld hl, 22599
    ld b, 4
    call horiz_line


                        ; draw E-mid
    ld hl, 22695
    ld b, 4
    call horiz_line


                        ; draw E-low
    ld hl, 22823
    ld b, 4
    call horiz_line

                        ; draw L-stem
    ld hl, 22605
    ld b,8
    call vertical_line



                        ; draw L-low
    ld hl, 22829
    ld b, 4
    call horiz_line

                        ; draw L-stem
    ld hl, 22611
    ld b,8
    call vertical_line

                        ; draw L-low
    ld hl, 22835
    ld b, 4
    call horiz_line


                        ; draw O-stem 1
    ld hl, 22617
    ld b,8
    call vertical_line

                        ; draw O-low
    ld hl, 22841
    ld b, 4
    call horiz_line

                        ; draw O-high
    ld hl, 22617
    ld b, 4
    call horiz_line


                        ; draw O-stem 2
    ld hl, 22621
    ld b,8
    call vertical_line