org 32768

start:
  ld hl, $5800 ;start of attr address
  ld de, $5800 ;start of attr address
  ld (hl), $38 ;grey background, black foreground
  inc e
  ld bc, $2ff  ;32 x 24 attr addresses
  ldir

  ld hl, trex
  ld b, 40
  ld c, 16
  call draw_bitmap

  ld hl, trex
  ld b, 40
  ld c, 16
  call delete_bitmap

  ld hl, trex
  ld b, 40
  ld c, 16
  call draw_bitmap
loop:
  jp loop


;hl bitmap addr
;b   loop counter
;bc' x,y
;hl' pixel byte addr
;d' draw byte

;assume hl holds bitmap addr 
;assume bc holds x,y
draw_bitmap:
  ld d, (hl) ;height in d
  inc hl
  ld e, (hl) ;width in e
  inc hl
  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, d
  push bc
outer_loop:
  
  exx
  push bc  ;save current y coord
  call $22aa   ;hl' holds pixel-byte addr of c,b

  ld b, e
row_loop:
  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de

  ld a, d      ;put trex byte into accumulator
  and (hl)     ;collision detection
  jp nz, set_end_game_flag
done_setting: 
  ld a,d
  or (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  djnz row_loop;loop until all 3 bytes of row complete
  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

  jp nz, outer_loop
  pop bc

  ld hl, end_game_flag
  ld a, $ff
  xor (hl)
  jp z, end_game
  ret


set_end_game_flag:
  push hl
  ld hl, end_game_flag
  ld (hl), $ff
  pop hl
  jp done_setting
    


end_game_flag:
  defb $00

end_game:
  jp end_game




delete_bitmap:
  ld d, (hl) ;height in d
  inc hl
  ld e, (hl) ;width in e
  inc hl

  push bc
  exx
  pop bc   ;bc' has x,y
  exx

  ld b, d
  push bc
delete_outer_loop:
  
  exx
  push bc  ;save current y coord
  call $22aa   ;hl' holds pixel-byte addr of c,b

  exx
  ld b, e
  exx
delete_row_loop:
  exx
  ld d, (hl)
  inc hl ;inc bitmap_addr
  push de
  exx
  pop de
  
  ld a,d
  xor (hl)
  ld (hl), a ;draw byte
  inc hl  ;inc draw location

  djnz delete_row_loop;loop until all 3 bytes of row complete
  pop bc   ;get y-coord
  dec b    ;dec y-coord
  exx
  pop bc
  dec b
  push bc

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
