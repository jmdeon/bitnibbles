org 32768

start:
  ld hl, $5800 ;start of attr address
  ld de, $5800 ;start of attr address
  ld (hl), $38 ;grey background, black foreground
  inc e
  ld bc, $2ff  ;32 x 24 attr addresses
  ldir

  ld de, trex
  ld b, 40
  ld c, 16
  call draw_bitmap

  ld de, trex
  ld b, 40
  ld c, 80
  call draw_bitmap
loop:
  jp loop





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
  ld (hl), d   ;put current trex byte into current pixel addr byte
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
