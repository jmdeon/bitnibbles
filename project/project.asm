  org 32768           ; Why 32768? Could it be another location?

  call start

start:
  call BOOT_SCREEN
  ret

BOOT_SCREEN:
  call set_all_white 
  call init_high_score
  call draw_dino_init
  call draw_no_internet
  call pause_loop
  call GAME_LOADING
  ret

GAME_LOADING:
  call animate_landscape
  call draw_high_score
  call GAME_LOOP
  ret

GAME_LOOP:
  ret

set_all_white:
  ld a, $7
  call $229B       ;Set the border to white
  ld hl, $5800
  ld bc, $300
set_all_white_loop:   ;Set the screen background to white and foreground to black
  ld (hl), $38
  inc hl
  dec bc
  ld a,b
  or c
  jp nz, set_all_white_loop
  ret

init_high_score:
  ret

draw_dino_init:
  ld hl, $59E1
  ld (hl), $0
  ret

draw_high_score:
  ret

draw_no_internet:
  ld a, $1
  call $1601
  ld de, no_internet_string
  ld bc, $1F
  call $203C  ;ROM call for writing a string
  ret

no_internet_string:
  defb 'There is no Internet connection'

animate_landscape:
  ;ld a, 0x02
  ld a, (hl)
  call 0x229B
  jp forever_loop
  ret

forever_loop:
  jp forever_loop

pause_loop:
  ld hl, 23560
  ld (hl), 0
pause_inner_loop:
  ld a, (hl)
  cp 0
  jr z, pause_inner_loop
  ;cp 0x36                 ;Did they push A?
  ;jr nz, pause_exit
  ;jp pause_loop
  jp pause_exit
   
pause_exit:
  ret
    
