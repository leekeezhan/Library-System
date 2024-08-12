.model small
.data
    buffer db 30           ; Maximum number of characters to read
            db ?            ; Number of characters actually read (to be filled by DOS)
            db 30 dup(?)    ; Buffer to hold the input string
    
    borrowFee db 3
    lateReturnFee db 5

    borrowDays db ?
    lateReturnDays db ?
    totalFee db ?
    bookID db ?

    msg_name db "Name: $"
    msg_chooseBook db "Choose a book to borrow (1, 2, 3): $"
    msg_borrowBook db "You have borrowed a book. Thank you! $"
    msg_returnBook db "You have returned a book. Thank you! $"
    
    msg_bookName db "Book Name: $"
    msg_bookID db "Book to borrow: $"
    msg_borrowDays db "Days to borrow: $"
    msg_lateReturnDays db "Days late: $"
    msg_totalFee db "Total Fee: RM $"

    no1 db "1. $"
    no2 db "2. $"
    no3 db "3. $"
    msg_book1 db "Poor Dad, Rich Dad $"
    msg_book2 db "Harry Potter $"
    msg_book3 db "Atomic Habits $"

    book1 db "1. Borrow a book $"
    book2 db "2. Return a book $"
    book3 db "3. Exit $"
    msg_menu db "Menu: $"
    msg_option db "Option: $"

    msg_exit db "Thank you for using our service! $"
    msg_invalidInput db "Invalid input. Please try again. $"
    msg_bookNotBorrowed db "You have not borrowed this book. $"
    msg_bookAlreadyBorrowed db "You have already borrowed this book. $"
    msg_bookNotFound db "Book not found. $"

.stack 100h
.code
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

main_loop:
    ; Clear screen
    mov ah, 00
    mov al, 03
    int 10h

    ; Display menu
    lea dx, msg_menu
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Print option borrow
    lea dx, book1
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Print option return
    lea dx, book2
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Print option exit
    lea dx, book3
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Print option
    lea dx, msg_option
    mov ah, 09h
    int 21h

    ; Get user choice
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Process user choice
    cmp bl, 1
    je borrow_book
    cmp bl, 2
    je return_book
    cmp bl, 3
    je exit_program
    ; Invalid input
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    jmp main_loop

borrow_book:
    ; Call borrow procedure
    call borrow
    jmp main_loop

return_book:
    ; Placeholder for return book procedure
    ; (You will need to implement this)
    lea dx, msg_returnBook
    mov ah, 09h
    int 21h
    jmp main_loop

exit_program:
    ; Exit program
    lea dx, msg_exit
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h

main ENDP

borrow PROC
    ; Prompt user to enter name
    lea dx, msg_name
    mov ah, 09h
    int 21h

    ; Get name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ;print no1
    lea dx, no1
    mov ah, 09h
    int 21h

    ; Print book names
    lea dx, msg_book1
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ;print no2
    lea dx, no2
    mov ah, 09h
    int 21h

    lea dx, msg_book2
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ;print no3
    lea dx, no3
    mov ah, 09h
    int 21h

    lea dx, msg_book3
    mov ah, 09h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Prompt user to choose a book
    lea dx, msg_chooseBook
    mov ah, 09h
    int 21h

    ; Get user input for book
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bookID, al

    ; New line
    mov ah, 02h
    mov dl, 0Dh  ; Carriage return
    int 21h
    mov dl, 0Ah  ; Line feed
    int 21h

    ; Prompt user to enter borrow days
    lea dx, msg_borrowDays
    mov ah, 09h
    int 21h

    ; Get user input for borrow days
    mov ah, 01h
    int 21h
    sub al, '0'
    mov borrowDays, al

    ; Calculate total fee
    mov al, borrowDays
    mov ah, 0
    cbw
    mov bl, borrowFee
    mul bl
    mov totalFee, al  ; Store total fee in totalFee

    ; New line
    mov ah, 02h
    mov dl, 0Dh  ; Carriage return
    int 21h
    mov dl, 0Ah  ; Line feed
    int 21h

    ; Display total fee message
    lea dx, msg_totalFee
    mov ah, 09h
    int 21h

    ; Display total fee value
    mov al, totalFee
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Display book name based on ID
    lea dx, msg_bookName
    mov ah, 09h
    int 21h

    ; Retrieve book name based on ID
    mov al, bookID
    cmp al, 1
    je display_book1
    cmp al, 2
    je display_book2
    cmp al, 3
    je display_book3

    ; If bookID is not valid, display an error message
    lea dx, msg_bookNotFound
    mov ah, 09h
    int 21h
    jmp borrow_done

display_book1:
    lea dx, msg_book1
    mov ah, 09h
    int 21h
    jmp borrow_done

display_book2:
    lea dx, msg_book2
    mov ah, 09h
    int 21h
    jmp borrow_done

display_book3:
    lea dx, msg_book3
    mov ah, 09h
    int 21h

borrow_done:
    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ret
borrow ENDP

end main
