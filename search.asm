.model small
.stack 100h
.data
menu db "-*-*-Search Book-*-*- $"

num db 1

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
copiedBook db 40 dup ('$')        ; Buffer to hold copied book value

novel db "Novel$" 
selfHelp db "Self-Help$" 
comic db "Comic$" 


choose db "Choice: $"
userChoice db ?
userSearch db 40 dup ('$')
other db "Other $"
searchName db "1. Search by name $"
searchCategory db "2. Search by category (Novel, Comic, Self-Help) $"
exit db "3. Any Key to Exit $"
left db "LEFT SEARCH FUNCTION $"
promptBkName db "Enter the name of the book: $"
promptCat db "Enter the category: $"
bookName db ?
bookCategory db ?
bookCat_msg db "    |    Category: $"

wrong db "No result $"
result db "Right result $"

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

MainMenu:
; Display word 'menu'
    lea dx, menu
    mov ah, 09h
    int 21h

    lea dx, newline  ;newline
    mov ah, 09h
    int 21h

; Display three choices and prompt for user choice
    lea dx, searchName
    mov ah, 09h
    int 21h

    lea dx, newline  ;newline
    mov ah, 09h
    int 21h

    lea dx, searchCategory
    mov ah, 09h
    int 21h

    lea dx, newline  ;newline
    mov ah, 09h
    int 21h

    lea dx, exit
    mov ah, 09h
    int 21h

    lea dx, newline 
    mov ah, 09h
    int 21h

    lea dx, choose
    mov ah, 09h
    int 21h

    mov ah, 01h        ;input
    int 21h
    sub al, 30h
    mov userChoice, al

; Compare choices then jump
    mov cl, 1
    cmp userChoice , cl
    je Search_Name
    mov cl, 2
    cmp userChoice , cl
    je Search_Category
    jne end_program

end_program:
    lea dx, left
    mov ah, 09h
    int 21h
; Wait for key press before exiting
    mov ah, 1
    int 21h
; Terminate program
    mov ah, 4Ch
    int 21h    

Search_Category:
; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, promptCat
    mov ah, 09h
    int 21h

    mov ah, 01h        ;input
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h
    jmp MainMenu ; Skip the other function after search

Search_Name:
; New line
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, promptBkName
    mov ah, 09h
    int 21h

    mov ah, 0Ah        ;input for name of the book (String)
    lea dx, userSearch
    int 21h

    mov si, offset book1       ;copy book1 value into copiedBook
    mov di, offset copiedBook   ;allow to lower
    mov cx, 19

 copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop

    lea si, userSearch +2
    lea di, copiedBook
    mov cx, 19

compare_book_1:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    call to_lowercase         ; Convert AL to lowercase (if it's an uppercase letter)
    mov bl, [di]              ; Load byte from book1 into BL
    call to_lowercase_bl      ; Convert BL to lowercase (if it's an uppercase letter)
    cmp al, bl                ; Compare AL (input char) with BL (book char)
    jne strings_not_found      ; If not equal, jump to not found  
    inc di                    ; Increment DI to point to the next character
    loop compare_book_1       

    lea dx, newline
    mov ah, 09h
    int 21h    

    lea dx, result
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h 

    lea dx, book1
    mov ah, 09h
    int 21h

    lea dx, bookCat_msg
    mov ah, 09h
    int 21h

    lea dx, novel
    mov ah, 09h 
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h 

    jmp MainMenu

strings_not_found:
    lea dx, wrong 
    mov ah, 09h
    int 21h
    lea dx, newline 
    mov ah, 09h
    int 21h
    jmp Search_Name
   
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