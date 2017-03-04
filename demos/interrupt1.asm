 org 32768
start: 
        call setup

counter:
        defb 0
        
        
int_hand:
    ld hl, counter
    inc (hl)
    ld a, (hl)
    out ($FE),a

setup:
        ld hl, $fdfd
        ld bc, int_hand
        ld (hl), $c3
        inc hl
        ld (hl), c 
        inc hl
        ld (hl), b
        
        
        
        ld a, $fe
        ld i, a
        ld bc, $0100
        ld h, a
        ld l, c
        ld d, a
        ld e, b
        ld (hl), $fd
        ldir
        
        im 2
        ret