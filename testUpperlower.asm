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

book_1:
    mov si, offset book1
    mov di, offset copiedBook
    mov cx, 19

copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedBook           ; DI points to book1 title
    mov cx, 19              ; Number of characters to compare (can be adjusted)

compare_book_1:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    call to_lowercase         ; Convert AL to lowercase (if it's an uppercase letter)
    mov bl, [di]              ; Load byte from book1 into BL
    call to_lowercase_bl      ; Convert BL to lowercase (if it's an uppercase letter)
    cmp al, bl                ; Compare AL (input char) with BL (book char)
    jne book_2     ; If not equal, jump to not found
    inc di                    ; Increment DI to point to the next character
    loop compare_book_1       
    
strings_equal:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, book1
    mov ah, 09h
    int 21h

    jmp end_program

book_2:
    mov si, offset book2
    mov di, offset copiedBook
    mov cx, 12

copy_loop2:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedBook           ; DI points to book1 title
    mov cx, 12              ; Number of characters to compare (can be adjusted)

compare_book_2:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    call to_lowercase         ; Convert AL to lowercase (if it's an uppercase letter)
    mov bl, [di]              ; Load byte from book1 into BL
    call to_lowercase_bl      ; Convert BL to lowercase (if it's an uppercase letter)
    cmp al, bl                ; Compare AL (input char) with BL (book char)
    jne strings_not_found    ; If not equal, jump to not found
    inc di                    ; Increment DI to point to the next character
    loop compare_book_2       
    
strings_equal2:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, book1
    mov ah, 09h
    int 21h

    jmp end_program    

strings_not_found:
    lea dx, strings_not_found_msg
    mov ah, 09h
    int 21h

end_program:
    mov ah, 4Ch                ; Exit to DOS
    int 21h

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

to_lowercase_bl proc
    ; Converts the character in BL to lowercase if it's uppercase
    cmp bl, 'A'                ; Check if BL >= 'A'
    jl not_uppercase_bl         ; If less, it's not uppercase
    cmp bl, 'Z'                ; Check if BL <= 'Z'
    jg not_uppercase_bl         ; If greater, it's not uppercase
    add bl, 32                 ; Convert to lowercase by adding 32
not_uppercase_bl:
    ret
to_lowercase_bl endp

main endp
end main
