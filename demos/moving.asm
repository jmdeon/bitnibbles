; Hello world program with drawing
; Maybe include more information?


    org 32768           ; Why 32768? Could it be another location?

    call start


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
    
    
    ret