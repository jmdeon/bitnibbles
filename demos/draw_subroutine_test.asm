org 32768

start:
  ld hl, $5800 ;start of attr address
  ld de, $5800 ;start of attr address
  ld (hl), $38 ;grey background, black foreground
  inc e
  ld bc, $2ff  ;32 x 24 attr addresses
  ldir

pos: defb $a0

loop:
  ld de, cact2_1
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call draw_bitmap
  
  call hold
  
  ld de, cact2_1
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call delete_bitmap

  ld de, cact2_2
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call draw_bitmap
  
  call hold
  
  ld de, cact2_2
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call delete_bitmap
  
  ld de, cact2_3
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call draw_bitmap
  
  call hold
  
  ld de, cact2_3
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call delete_bitmap
  
  ld de, cact2_4
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call draw_bitmap
  
  call hold
  
  ld de, cact2_4
  ld b, 40
  ld hl, pos
  ld c, (hl)
  call delete_bitmap
  
  ld hl, pos
  ld a, (hl)
  sub a, 8
  ld (hl), a

  jp loop

hold:
    inc a
    ld bc,$1fff         ; waiting time
hold_loop:
    dec bc              ; Need to use bc? Use another register?
    ld a,b
    or c
    jr nz, hold_loop
    ret



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
  and (hl)     ;collision detection
  jp nz, set_end_flag
after_end_game_flag:
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
  ld hl, $7000;check end game flag
  ld a, (hl)
  cp a, $ff
  jp nz, end_game
  ret


set_end_flag:
  push hl
  ld hl, $7000
  ld (hl), $ff
  pop hl
  jp after_end_game_flag
  
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

        
;; 1st part of animation
cact2_1:
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
        defb $01, $ff, $f0
        defb $00, $ff, $e0
        
        ;; ROW 3
        defb $00, $7f, $c0
        defb $00, $3f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00
        defb $00, $0f, $00

;; 2nd part of animation
cact2_2:
        defb 24, 3
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
        defb $07, $ff, $c0
        defb $03, $ff, $80
        
        ;; ROW 3
        defb $01, $ff, $00
        defb $00, $fc, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        defb $00, $3c, $00
        
        

;; 3rd part of animation
cact2_3:
        defb 24, 3
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
        defb $1f, $ff, $00
        defb $0f, $fe, $00
        
        ;; ROW 3
        defb $07, $fc, $00
        defb $03, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        defb $00, $f0, $00
        
        
;; 4th part of animation
cact2_4:
        defb 24, 3
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
        defb $f7, $fc, $00
        defb $3f, $f8, $00
        
        ;; ROW 3
        defb $1f, $f0, $00
        defb $0f, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00
        defb $03, $c0, $00