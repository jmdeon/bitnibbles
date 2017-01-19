; Hello world program with drawing
; Maybe include more information?


    org 32768           ; Why 32768? Could it be another location?

    call start

; Slide Entire Image Right one Attribute Cell
slide_right:
    ld hl, 22590           ; Attribute Cell to Start at
    ld bc, 766             ; Number of Attribute Cells to Change
    ld e, 0                ; e will be the previous cell color (black)
slide_right_loop:
    ld a, (hl)             ;store current attribute value into a
    ld (hl), e             ;load previous attribute value
    inc hl                 ;move pointer to next attribute 
    ld e, a                ;set current value as previous value
    dec bc                 ;Decrement the counter 
    ld a,b                 ;Determine if you have reached the end, continue otherwise
    or c
    jp nz, slide_right_loop
    ret  

; Slide Entire Image Left one Attribute Cell
slide_left:
    ld hl, 23295
    ld bc, 766
    ld e, 0
slide_left_loop:
    ld a, (hl)
    ld (hl), e
    dec hl
    ld e, a
    dec bc
    ld a,b
    or c
    jp nz, slide_left_loop
    ret 

hold:
    inc a
    ld bc,$1fff         ; max waiting time. Why?
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret

long_hold:              ; Longer Hold, x10 hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    call hold
    ret
    
                        ; horiz_line draws to the right while
                        ; all others draw downward
    
horiz_line:
    ld (hl), 156        ; Attribute [Flashing | Highlight | Background: R | G | B | Foreground: R | G | B]
    push bc             ; Save our b counter
    call hold           ; Call hold to make drawing appearance
    pop bc              ; Retrieve b
    inc hl              ; Move to the right
    dec b               ; Decrement counter
    jp nz, horiz_line   ; Loop until counter is 0
    ret

vertical_line:
    ld (hl), 163
    push bc             ; save our b counter
    call hold
    pop bc
    ld de, 32           ; Move downward
    add hl, de
    dec b
    jp nz, vertical_line
    ret
    
diag_right_line:
    ld (hl), 156
    push bc             ; save our b counter
    call hold
    pop bc
    ld de, 33           ; Move down and to the right
    add hl, de
    dec b
    jp nz, diag_right_line
    ret
    
diag_left_line:
    ld (hl), 156
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
                        ; Hello
                        
                        ; H
    ld hl, 22592        ; Sets starting position
    ld b, 8             ; Distance to travel
    call vertical_line
    
    ld hl, 22596
    ld b, 8
    call vertical_line
    
    ld hl, 22689
    ld b, 3
    call horiz_line
   

                        ; E
    ld hl, 22599
    ld b, 8
    call vertical_line

    ld hl, 22599
    ld b, 5
    call horiz_line

    ld hl, 22695
    ld b, 5
    call horiz_line

    ld hl, 22823
    ld b, 5
    call horiz_line

                        ; L 1
    ld hl, 22606
    ld b, 8
    call vertical_line

    ld hl, 22830
    ld b, 4
    call horiz_line

    
                        ; L 2
    ld hl, 22612
    ld b, 8
    call vertical_line

    ld hl, 22836
    ld b, 4
    call horiz_line


                        ; O
    ld hl, 22618
    ld b, 8
    call vertical_line

    ld hl, 22842
    ld b, 4
    call horiz_line

    ld hl, 22618
    ld b, 4
    call horiz_line

    ld hl, 22622
    ld b, 8
    call vertical_line
    
                        ; World
    
    
                        ; W
    ld hl, 22976
    ld b, 8
    call vertical_line
    
    ld hl, 22980
    ld b, 8
    call vertical_line
    
    ld hl, 23138
    ld b, 2
    call diag_left_line
    
    ld hl, 23138
    ld b, 2
    call diag_right_line
    
    
    
                        ; O
    ld hl, 22983
    ld b, 8
    call vertical_line

    ld hl, 23207
    ld b, 4
    call horiz_line

    ld hl, 22983
    ld b, 4
    call horiz_line

    ld hl, 22987
    ld b,8
    call vertical_line
    
    
                        ; R 
    ld hl, 22990
    ld b, 8
    call vertical_line
    
    ld hl, 22990
    ld b, 4
    call horiz_line
    
    ld hl, 22993
    ld b, 4
    call vertical_line
    
    ld hl, 23118
    ld b, 4
    call horiz_line
    
    ld hl, 23118
    ld b, 4
    call diag_right_line
    
    
                        ; L
    ld hl, 22996
    ld b, 8
    call vertical_line

    ld hl, 23220
    ld b, 4
    call horiz_line
    
    
                        ; D
    ld hl, 23002
    ld b, 8
    call vertical_line

    ld hl, 23226
    ld b, 3
    call horiz_line
    
    ld hl, 23197
    ld b, 1
    call diag_left_line

    ld hl, 23002
    ld b, 3
    call horiz_line
    
    ld hl, 23037
    ld b, 1
    call diag_right_line

    ld hl, 23070
    ld b,4
    call vertical_line

animate_loop:
    call slide_right
    call long_hold
    call slide_left
    call long_hold
    jp animate_loop
