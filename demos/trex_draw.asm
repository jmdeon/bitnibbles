org 32768

start:
  ld hl, $5800 ;start of attr address
  ld de, $5800 ;start of attr address
  ld (hl), $38 ;grey background, black foreground
  inc e
  ld bc, $2ff  ;32 x 24 attr addresses
  ldir

  ld hl, $7000 ;address to hold current trex address
  ld de, trex  ;get initial trex addr
  ld (hl), d   ;first byte of addr at $7000
  inc hl
  ld (hl), e   ;second byte of addr at $7001
  

  ld b, 40     ;y-coord of top-left of trex box
  ld c, 16     ;x-coord of top-right "     "
outer_loop:
  push bc     
  call $22aa   ;hl holds pixel-byte addr of c,b

  ;get trex addr
  exx
  ld hl, $7000 ;trex address address, no you aren't seeing double
  ld d, (hl)
  inc hl
  ld e, (hl)   ;de temporarily holds current trex address

  ld h, d
  ld l, e      ;hl' now holds current trex addr

  ld b, 5      ;loop 5 times to put 5 bytes of trex onto screen
row_loop:
  ld d, (hl)   ;d holds current trex byte
  push de      ;push trex byte to persist exchange
  exx          ;exchange so hl holds current pixel byte addr
  pop de       ;pop trex byte
  ld (hl), d   ;put current trex byte into current pixel addr byte
  inc hl       ;inc current pixel addr byte
  exx          ;exchange to get current trex byte back in hl
  inc hl       ;inc current trex addr byte
  djnz row_loop;loop until all 5 bytes of row complete
  ;store back out current trex addr
  ld d, h      ;put trex addr into de 
  ld e, l
  ld hl, $7000 ;give hl trex addr byte
  ld (hl), d   ;$7000 has first byte of trex addr
  inc hl       
  ld (hl), e   ;$7001 has second byte of trex addr

  pop bc       ;get outer loop counter back
  dec b        
  
  djnz outer_loop;loop until all 40 lines of trex drawn


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
