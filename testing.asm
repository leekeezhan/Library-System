.model small
.stack 100h
.data
    promptBkName db "Enter the name of the book: $"
    userSearch db 40 dup ('$')
    
    book1 db "Journey to The West$" 
    book2 db "Frankenstein$"
    book3 db "Dune$"
    book4 db "Harry Potter and the Cursed Child$"
    book5 db "Rich Dad Poor Dad$"
    book6 db "Atomic Habits$"
    book7 db "Second Chance$"
    book8 db "One Piece$"
    book9 db "Jujutsu Kaisen$"
    book10 db "Avengers$" 
    
    books dw offset book1, offset book2, offset book3, offset book4, offset book5, offset book6, offset book7, offset book8, offset book9, offset book10

    strings_equal_msg db "Book Found! $"
    strings_not_found_msg db "No result $"
    copiedBook db 40 dup ('$')        ; Buffer to hold copied book value
    newline db 0Dh, 0Ah, '$'

.code
main proc
    ; Initialize DS to point to the data segment
    mov ax, @data
    mov ds, ax
    
    ; Display prompt
    lea dx, promptBkName
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 0Ah        ; DOS input function for strings
    lea dx, userSearch
    int 21h

    ; Initialize loop to go through each book
    mov cx, 10                  ; Number of books
    lea bx, books               ; BX points to the array of book pointers

check_next_book:
    mov si, [bx]                ; Load the address of the current book into SI
    mov di, offset copiedBook   ; DI points to the copiedBook buffer
    call copy_string            ; Copy the current book to the buffer

    ; Convert copiedBook to lowercase
    lea si, copiedBook          ; SI points to copiedBook
    call to_lowercase_string    ; Convert the copied string to lowercase

    ; Convert user input to lowercase
    lea si, userSearch + 2      ; SI points to user input (after length byte and return)
    call to_lowercase_string    ; Convert user input to lowercase

    ; Compare the strings
    lea si, userSearch + 2      ; SI points to lowercase user input
    lea di, copiedBook          ; DI points to lowercase copied book
    mov cx, 40                  ; Max number of characters to compare (can be adjusted)
    call compare_strings        ; Compare strings

    cmp al, 1                   ; Check if strings match (AL == 1)
    je strings_equal            ; If equal, jump to success message

    ; Move to the next book
    add bx, 2                   ; Move to the next book pointer (since each pointer is 2 bytes)
    loop check_next_book        ; Loop until all books are checked

strings_not_found:
    ; If no match found, display the "No result" message
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, strings_not_found_msg
    mov ah, 09h
    int 21h

    jmp end_program             ; Skip to the end

strings_equal:
    ; Display the success message
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, copiedBook          ; Display the found book
    mov ah, 09h
    int 21h

    jmp end_program

copy_string proc
    ; Copy string from SI to DI until we encounter a '$'
copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    cmp al, '$'               ; Check if we reached the end of the string
    jne copy_loop             ; If not, continue copying
    ret
copy_string endp

to_lowercase_string proc
    ; Converts the string pointed to by SI to lowercase
to_lowercase_loop:
    lodsb                     ; Load byte from DS:SI into AL and increment SI
    cmp al, '$'               ; Check if end of string
    je done_lowercase         ; If yes, end conversion
    call to_lowercase         ; Convert AL to lowercase (if it's an uppercase letter)
    dec si                    ; Move SI back (so we can store the lowercase char)
    mov [si], al              ; Store the lowercase char back in memory
    inc si                    ; Move to the next character
    jmp to_lowercase_loop     ; Repeat for the next character
done_lowercase:
    ret
to_lowercase_string endp

to_lowercase proc
    ; Converts the character in AL to lowercase if it's uppercase
    cmp al, 'A'                ; Check if AL >= 'A'
    jl not_uppercase           ; If less, it's not uppercase
    cmp al, 'Z'                ; Check if AL <= 'Z'
    jg not_uppercase           ; If greater, it's not uppercase
    add al, 32                 ; Convert to lowercase by adding 32
not_uppercase:
    ret
to_lowercase endp

compare_strings proc
    ; Compare strings pointed to by SI and DI
    ; Returns:
    ; AL = 1 if strings match
    ; AL = 0 if strings do not match

compare_loop:
    lodsb                     ; Load byte from DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL with byte at DI
    jne no_match              ; If not equal, jump to no_match
    cmp al, '$'               ; Check if both are end of strings
    je match_found            ; If yes, strings match
    inc di                    ; Move to the next character in the book
    loop compare_loop         ; Repeat for the next character

no_match:
    mov al, 0                 ; Indicate no match
    ret

match_found:
    mov al, 1                 ; Indicate match
    ret
compare_strings endp

end_program:
    mov ah, 4Ch                ; Exit to DOS
    int 21h

main endp
end main





