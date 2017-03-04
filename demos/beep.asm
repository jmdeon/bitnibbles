org 32768

ld	hl, $1ef5 ; f*t
ld	de, $0018 ; T states divided by four
call	$03b5   ; beeper routine

ld	hl, $5ef6 ; f*t
ld	de, $0018 ; T states divided by four
call	$03b5

ld	hl, $2ff7 ; f*t
ld	de, $0018 ; T states divided by four
call	$03b5   ; beeper routine

ld	hl, $0ff8 ; f*t
ld	de, $00ff ; T states divided by four
call	$03b5   ; beeper routine
