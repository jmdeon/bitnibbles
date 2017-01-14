org 32768

ld hl, 22560 ;draw black over the bytes message
ld b, 13
clearloop:
  ld (hl), 0
  inc hl
  dec b
  jp nz, clearloop

;22528 or hex 0x5800 is the start of the screen, goes until 
;decimal 23296


;draw H-left
ld hl, 22592
ld b,8
h0loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
;ld (hl), 0
ld de, 32
add hl, de
dec b
jp nz, h0loop

;draw H-right
ld hl, 22597
ld b,8
h1loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
;ld (hl), 0
ld de, 32
add hl, de
dec b
jp nz, h1loop

;draw H-mid
ld hl, 22688
ld b, 5
h2loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, h2loop



wait:
       inc a
       ld bc,$1fff ;max waiting time
loop:
	dec bc
	ld a,b
	or c
	jr nz, loop
        ret

