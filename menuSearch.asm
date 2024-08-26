.model small
.stack 100h
.data
menu db "Library Menu $"
choice1 db "1. Search Book $"
choice2 db "2. Borrow Book $"
choice3 db "3. Return Book $"
exit db "4. Exit $"
choose db "Choice: $"
userChoice db ?
other db "Other $"
search db "Search by name: $"

newline db 0Dh, 0Ah, '$'

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Clear screen
    mov ah, 00
    mov al, 03
    int 10h

; Display word 'menu'
    lea dx, menu
    mov ah, 09h
    int 21h

; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, choice1
    mov ah, 09h
    int 21h

; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, choice2
    mov ah, 09h
    int 21h

 ; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, choice3
    mov ah, 09h
    int 21h

; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, exit
    mov ah, 09h
    int 21h

; New line
    lea dx, newline
    mov ah, 09h
    int 21h

;prompt user choice
    lea dx, choose
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, 30h
    mov userChoice, al

    mov cl, 1
    cmp userChoice , cl
    je Search_fucntion
    jne other_function
    
Search_fucntion:
; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, search
    mov ah, 09h
    int 21h
    jmp end_program ; Skip the other function after search

other_function:
; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, other
    mov ah, 09h
    int 21h

end_program:
; Wait for key press before exiting
    mov ah, 1
    int 21h
; Terminate program
    mov ah, 4Ch
    int 21h


main endp
end main
