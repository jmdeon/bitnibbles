org 32768

start:
ld hl, 0x4000
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4001
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4002
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4003
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4004
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4005
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4006
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4007
ld (hl), 255
call wait
ld (hl), 0
ld hl, 0x4008
ld (hl), 255


wait:
       ld bc,$1fff ;max waiting time
loop:
	dec bc
	ld a,b
	or c
	jr nz, loop
        ret

