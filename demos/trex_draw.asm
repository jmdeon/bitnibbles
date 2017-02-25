org 32768

start:
  ld hl, $5800 ;start of attr address
  ld de, $5800 ;start of attr address
  ld (hl), $38 ;grey background, black foreground
  inc e
  ld bc, $2ff  ;32 x 24 attr addresses
  ldir

  ld b, 40     ;y-coord of top-left of trex box
  ld c, 16     ;x-coord of    "           "

  ;;DRAW TREX ROUTINE starts here with b holding the y-coord and c the x-coord
  exx
  ld d,  40    ;number of rows
  push de      ;loop counter first thing pushed on stack
  ld de, trex  ;set de' to trex addr
  exx
outer_loop:
  push bc      ;save our current y-coord
  call $22aa   ;hl holds pixel-byte addr of c,b

  exx          ;de' holds current trex addr

  ld h, d
  ld l, e      ;hl' now holds current trex addr

  ld b, 5      ;loop 5 times to put 5 bytes of trex onto screen
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


loop:
  jp loop

trex:
        ;; ROW 1
        defb $00, $00, $03, $ff, $fc 
        defb $00, $00, $03, $ff, $fc
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $3f, $ff
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $ff, $ff
        
        ;; ROW 2
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $ff, $ff
        defb $00, $00, $0f, $fc, $00
        defb $00, $00, $0f, $fc, $00
        defb $00, $00, $0f, $ff, $f0
        defb $00, $00, $0f, $ff, $f0
        defb $c0, $00, $3f, $f0, $00
        defb $c0, $00, $3f, $f0, $00
        
        ;; ROW 3
        defb $c0, $00, $ff, $f0, $00
        defb $c0, $00, $ff, $f0, $00
        defb $f0, $0f, $ff, $ff, $00
        defb $f0, $0f, $ff, $ff, $00
        defb $fc, $3f, $ff, $f3, $00
        defb $fc, $3f, $ff, $f3, $00
        defb $ff, $ff, $ff, $f0, $00
        defb $ff, $ff, $ff, $f0, $00
        
        ;; ROW 4
        defb $3f, $ff, $ff, $f0, $00
        defb $3f, $ff, $ff, $f0, $00
        defb $0f, $ff, $ff, $c0, $00
        defb $0f, $ff, $ff, $c0, $00
        defb $00, $ff, $ff, $00, $00
        defb $00, $ff, $ff, $00, $00
        defb $00, $ff, $fc, $00, $00
        defb $00, $ff, $fc, $00, $00
        
        ;; ROW 5
        defb $00, $3f, $3c, $00, $00
        defb $00, $3f, $3c, $00, $00
        defb $00, $3c, $0c, $00, $00
        defb $00, $3c, $0c, $00, $00
        defb $00, $30, $0c, $00, $00
        defb $00, $30, $0c, $00, $00
        defb $00, $3c, $0f, $00, $00
        defb $00, $3c, $0f, $00, $00
