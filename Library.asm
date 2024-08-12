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
    msg_chooseBook db "Choose a book to borrow(1, 2, 3): $"
    msg_borrowBook db "You have borrowed a book. Thank you! $"
    msg_returnBook db "You have returned a book. Thank you! $"
    
    msg_bookName db "Book Name: $"
    msg_bookID db "Book to borrow: $"
    msg_borrowDays db "Days to borrow: $"
    msg_lateReturnDays db "Days late: $"
    msg_totalFee db "Total Fee:RM $"

    msg_book1 db "1. Poor Dad, Rich Dad $"
    msg_book2 db "2. Harry Potter $"
    msg_book3 db "3. Atomoic Habits $"

    menu1 db "1. Borrow a book $"
    menu2 db "2. Return a book $"
    menu3 db "3. Exit $"
    msg_menu db "Menu: $"

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

    mov ah, 00
    mov al, 03
    int 10h

    ;prompt user to enter name
    lea dx, msg_name
    mov ah, 09h
    int 21h

    ;get name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; New line
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; print first book name message
    lea dx, msg_book1
    mov ah, 09h
    int 21h

    ; Carriage return
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    ; Line feed
    mov ah, 02h
    mov dl, 0Ah
    int 21h

    ; print second book name message
    lea dx, msg_book2
    mov ah, 09h
    int 21h

    ; Carriage return
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    ; Line feed
    mov ah, 02h
    mov dl, 0Ah
    int 21h

    ; print third book name message
    lea dx, msg_book3
    mov ah, 09h
    int 21h

    ; Carriage return
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    ; Line feed
    mov ah, 02h
    mov dl, 0Ah
    int 21h

    ; Prompt user to choose a book
    lea dx, msg_chooseBook
    mov ah, 09h
    int 21h

    ; Get user input
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

    ;prompt user to enter borrow day
    lea dx, msg_borrowDays
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 01h
    int 21h
    sub al, '0'
    mov borrowDays, al

    ; New line
    mov ah, 02h
    mov dl, 0Dh  ; Carriage return
    int 21h
    mov dl, 0Ah  ; Line feed
    int 21h

    ; Calculate total fee
    mov al, borrowDays
    mov ah, 0
    cbw
    mov bl, borrowFee
    mul bl
    mov bx, ax  ; Store borrow fee in bx

    mov totalFee, bl  ; Store total fee

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

    ;exit program
    mov ah, 4ch
    int 21h

main ENDP

end main