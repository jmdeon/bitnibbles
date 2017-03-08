    org 32768 
    
start:
    call setup
    
    
test_loop:
    ei
loop1:
    jp loop1

    
setup:
    ld hl, $fff4        ;Store 'jp GAME_LOOP' at $fff4
    ld bc, test_loop    ;Grab test_loop Address
    ld (hl), $c3        ;Store 'jp'
    inc hl              ;Move 1 byte to the right
    ld (hl), c          ;Store first byte of address
    inc hl              ;Move 1 byte to the right
    ld (hl), b          ;Store second byte of address
    ld hl, $ffff        ;Store '$18' at $ffff, causing wrap around
    ld (hl), $18        ;Store '$18'
    ld a, $39           ;Load '$39' in I to load '$ffff' from $3900 to $39ff
    ld i, a             ;Load a into I
    
    im 2
    ei
    ret
   