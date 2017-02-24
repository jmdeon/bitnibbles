org 32768

start:
  ld hl, $5800 ;;start of attr address
  ld de, $5800 ;;start of attr address
  ld (hl), $38 ;;grey background, black foreground
  inc l
  ld bc, 768   ;;32 x 24 attr addresses
  ldir

