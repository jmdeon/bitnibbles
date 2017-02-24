org 32768

start:
  ld hl, $5800 ;;start of attr address
  ld de, $5800 ;;start of attr address
  ld (hl), $38 ;;grey background, black foreground
  inc e
  ld bc, $2ff   ;;32 x 24 attr addresses
  ldir

  ld hl, $7000
  ld de, trex
  ld (hl), d
  inc hl
  ld (hl), e
  

  ld b, 30 ;primes
  ld c, 16
outer_loop:
  push bc
  call $22aa  ;  hl holds byte addr of c,b

  ;get trex addr
  exx
  ld hl, $7000
  ld d, (hl)
  inc hl
  ld e, (hl)

  ld h, d
  ld l, e ;hl' now holds current trex addr

  ld b, 5 ;loop 5 times to put 5 bytes of trex onto screen
row_loop:
  ld d, (hl)
  push de
  exx
  pop de
  ld (hl), d
  inc hl
  exx
  inc hl
  djnz row_loop
  ;store back out trex
  ld d, h
  ld e, l
  ld hl, $7000
  ld (hl), d
  inc hl
  ld (hl), e

  pop bc
  dec b
  
  djnz outer_loop


;  ld hl, $7000
;  ld (hl), 40
;
;  exx ; to prime
;  ld b, 100 ;primes
;  ld c, 16
;  push bc
;
;row:
;  pop bc
;  call $22aa  ;  hl' holds byte addr of c,b
;  exx ; to norm
;
;  
;  ld hl, trex ;hl has trex addr
;  ld b, 5
;byte:
;  ld d, (hl)
;  push de
;  inc hl
;  exx ;to prime
;  pop de
;  ld (hl), d
;  inc hl
;  exx ; to norm
;  djnz byte
;
;  exx ; to prime
;  ld hl, $7000
; push bc
;  ld b, (hl)
;  dec b
;  ld (hl), b
;  jp nz, row



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
