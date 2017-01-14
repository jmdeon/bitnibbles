org 32768

start:
ld      a, 2                  ; channel 2 = "S" for screen
ld      b, 8                  
call    $1601                 ; Select print channel using ROM

loop:
ld hl,line                    ; Print line
call printline
dec b
jp nz, loop
ret                        

printline:                     ; Routine to print out a line
ld a,(hl)                     ; Get character to print
cp '$'                        ; See if it '$' terminator
jp z,printend                 ; We're done if it is
rst 16                        ; Spectrum: Print the character in 'A'
inc hl                        ; Move onto the next character
jp printline                  ; Loop round

printend:
ret

; Data
line:    defb 'Hello, world.',13,'$'

