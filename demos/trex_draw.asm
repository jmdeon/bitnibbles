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

  pop bc       ;get outer loop counter back
  dec b        

  ;loop until all 40 lines of trex drawn
  djnz outer_loop


loop:
  jp loop

trex:
        ;; ROW 1
        defb $00, $00, $03, $FF, $FC
        defb $00, $00, $0F, $3F, $FF
        defb $00, $00, $0F, $3F, $FF
        defb $00, $00, $0F, $FF, $FF
        
        ;; ROW 2
        defb $00, $00, $0F, $FF, $FF
        defb $00, $00, $0F, $FC, $00
        defb $00, $00, $0F, $FF, $F0
        defb $C0, $00, $3F, $F0, $00
        
        ;; ROW 3
        defb $C0, $00, $FF, $F0, $00
        defb $F0, $0F, $FF, $FF, $00
        defb $FC, $3F, $FF, $F3, $00
        defb $FF, $FF, $FF, $F0, $00
        
        ;; ROW 4
        defb $3F, $FF, $FF, $F0, $00
        defb $0F, $FF, $FF, $C0, $00
        defb $00, $FF, $FF, $00, $00
        defb $00, $FC, $FC, $00, $00
        
        ;; ROW 5
        defb $00, $3F, $3C, $00, $00
        defb $00, $3C, $0C, $00, $00
        defb $00, $30, $0C, $00, $00
        defb $00, $3C, $0F, $00, $00
