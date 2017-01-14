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
ld hl, 22596
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
ld b, 4
h2loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, h2loop


;draw E-stem
ld hl, 22599
ld b,8
e0loop:
ld (hl),28
push bc
call wait
pop bc
ld de, 32
add hl, de
dec b
jp nz, e0loop

;draw E-top
ld hl, 22599
ld b, 4
e1loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, e1loop


;draw E-mid
ld hl, 22695
ld b, 4
e2loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, e2loop



;draw E-low
ld hl, 22823
ld b, 4
e3loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, e3loop


;draw L-stem
ld hl, 22605
ld b,8
l0loop:
ld (hl),28
push bc
call wait
pop bc
ld de, 32
add hl, de
dec b
jp nz, l0loop


;draw L-low
ld hl, 22829
ld b, 4
l1loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, l1loop


;draw L-stem
ld hl, 22611
ld b,8
l2loop:
ld (hl),28
push bc
call wait
pop bc
ld de, 32
add hl, de
dec b
jp nz, l2loop


;draw L-low
ld hl, 22835
ld b, 4
l3loop:
ld (hl), 28
push bc ; save our b counter
call wait
pop bc
inc hl
dec b
jp nz, l3loop


;draw O-stem 1
ld hl, 22617
ld b,8
O0loop:
ld (hl),28 
push bc
call wait
pop bc
ld de, 32
add hl, de 
dec b
jp nz, O0loop


wait:
       inc a
       ld bc,$1fff ;max waiting time
loop:
	dec bc
	ld a,b
	or c
	jr nz, loop
        ret
