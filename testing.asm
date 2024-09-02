.model small
.stack 100h
.data
    promptBkName db "Enter the name of the book: $"
    inputBuffer db 40 dup ('$')
    
    book8 db "One Piece$"
    book9 db "Jujutsu Kaisen$"
    book10 db "Avengers$" 
    
    strings_equal_msg db "Book Found! $"
    strings_not_found_msg db "No result $"
    newline db 0Dh, 0Ah, '$'

.code
main proc
    ; Initialize DS to point to the data segment
    mov ax, @data
    mov ds, ax

start:
    ; Display prompt for book name
    mov ah, 09h
    lea dx, promptBkName
    int 21h

    ; Get user input (terminated by Enter)
    mov ah, 0Ah
    lea dx, inputBuffer
    int 21h

    lea si, inputBuffer + 2

    ; Compare with book8
    lea di, book8
    call compare_bk8
    jz found_book

    ; Compare with book9
    lea di, book9
    call compare_bk9
    jz found_book

    ; Compare with book10
    lea di, book10
    call compare_bk10
    jz found_book

    ; If no match is found
    mov ah, 09h
    lea dx, strings_not_found_msg
    int 21h
    jmp done

found_book:
    mov ah, 09h
    lea dx, strings_equal_msg
    int 21h

done:
    ; Terminate the program
    mov ah, 4Ch
    int 21h

; Compare two strings (SI = user input, DI = predefined string)
;book8
compare_bk8 proc
    lea si, inputBuffer + 2
    lea di, book8
    mov cx, 9

compare_book_8:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL (input char) with the char at DI
    jne strings_not_found8
    je strings_found8
    inc di                    ; Increment DI to point to the next character
    loop compare_book_8

strings_not_found8:
    ret
strings_found8:
    mov al, 1          ; Set ZF for equality
    ret            
compare_bk8 endp

compare_bk9 proc
    lea si, inputBuffer + 2
    lea di, book9
    mov cx, 14

;book9
compare_book_9:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL (input char) with the char at DI
    jne strings_not_found9
    je strings_found9
    inc di                    ; Increment DI to point to the next character
    loop compare_book_9

strings_not_found9:
    ret

strings_found9:
    mov al, 1          ; Set ZF for equality
    ret        
compare_bk9 endp

compare_bk10 proc
    lea si, inputBuffer + 2
    lea di, book10
    mov cx, 8

;book10
compare_book_10:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL (input char) with the char at DI
    jne strings_not_found10
    je strings_found10
    inc di                    ; Increment DI to point to the next character
    loop compare_book_10

strings_not_found10:
    ret
strings_found10:
    mov al, 1          ; Set ZF for equality
    ret    
compare_bk10 endp


main endp
end main





