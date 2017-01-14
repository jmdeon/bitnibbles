    org 32768

    ld hl, 22560 ;draw black over the bytes message
    ld b, 13
clearloop:
    ld (hl), 0
    inc hl
    dec b
    jp nz, clearloop
    jp start

    ;22528 or hex 0x5800 is the start of the screen, goes until 
    ;decimal 23296

hold:
    inc a
    ld bc,$1fff ;max waiting time
hold_loop:
    dec bc
    ld a,b
    or c
    jr nz, hold_loop
    ret
    
    
    
horiz_loop:
    ld (hl), 28
    push bc ; save our b counter
    call hold
    pop bc
    inc hl
    dec b
    jp nz, horiz_loop
    ret




vertical_loop:
    ld (hl), 28
    push bc ; save our b counter
    call hold
    pop bc
    ;ld (hl), 0
    ld de, 32
    add hl, de
    dec b
    jp nz, vertical_loop
    ret


    
    ;draw H-left
start:
    ld hl, 22592
    ld b,8
    call vertical_loop
    
    ;draw H-right
    ld hl, 22596
    ld b,8
    call vertical_loop
    
    
    ;draw H-mid
    ld hl, 22688
    ld b, 4
    call horiz_loop
    


    ;draw E-stem
    ld hl, 22599
    ld b,8
    call vertical_loop

    ;draw E-top
    ld hl, 22599
    ld b, 4
    call horiz_loop


    ;draw E-mid
    ld hl, 22695
    ld b, 4
    call horiz_loop


    ;draw E-low
    ld hl, 22823
    ld b, 4
    call horiz_loop

    ;draw L-stem
    ld hl, 22605
    ld b,8
    call vertical_loop



    ;draw L-low
    ld hl, 22829
    ld b, 4
    call horiz_loop

    ;draw L-stem
    ld hl, 22611
    ld b,8
    call vertical_loop

    ;draw L-low
    ld hl, 22835
    ld b, 4
    call horiz_loop


    ;draw O-stem 1
    ld hl, 22617
    ld b,8
    call vertical_loop

    ;draw O-low
    ld hl, 22841
    ld b, 4
    call horiz_loop

    ;draw O-high
    ld hl, 22617
    ld b, 4
    call horiz_loop


    ;draw O-stem 2
    ld hl, 22621
    ld b,8
    call vertical_loop