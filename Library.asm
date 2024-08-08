.model small
.data
    borrowFee dw 3
    lateReturnFee dw 5
    borrowDays dw ?
    lateReturnDays dw ?
    totalFee dw ?
    bookID db ?
    msg_chooseBook db "Choose a book to borrow(1, 2, 3): $"
    msg_borrowBook db "You have borrowed a book. Thank you! $"
    msg_returnBook db "You have returned a book. Thank you! $"
    msg_bookName db "Book Name: $"
    msg_bookID db "Book to borrow: $"
    msg_borrowDays db "Days to borrow: $"
    msg_lateReturnDays db "Days late: $"
    msg_totalFee db "Total Fee: RM $"
    msg_book1 db "1. Poor Dad, Rich Dad $"
    msg_book2 db "2. Harry Potter $"
    msg_book3 db "3. Atomic Habits $"

numBuffer db '00000$'
Ten db 10

.stack 100h
.code
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Print first book name message
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

    ; Print second book name message
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

    ; Print third book name message
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

    ; Prompt user to enter borrow days
    lea dx, msg_borrowDays
    mov ah, 09h
    int 21h

    ; Get first digit of borrow days
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Get second digit of borrow days
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al

    ; Combine two digits to form borrowDays
    mov al, bl
    mov ah, 0Ah
    mul ah
    add al, bh
    mov borrowDays, ax

    ; New line
    mov ah, 02h
    mov dl, 0Dh  ; Carriage return
    int 21h
    mov dl, 0Ah  ; Line feed
    int 21h

    ; Prompt for late return days
    lea dx, msg_lateReturnDays
    mov ah, 09h
    int 21h

    ; Get first digit of late return days
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Get second digit of late return days
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al

    ; Combine two digits to form lateReturnDays
    mov al, bl
    mov ah, 0Ah
    mul ah
    add al, bh
    mov lateReturnDays, ax

    ; Calculate total fee
    mov ax, borrowDays
    mov cx, borrowFee
    mul cx
    mov bx, ax  ; Store borrow fee in bx

    ; Calculate late return fee
    mov ax, lateReturnDays
    mov cx, lateReturnFee
    mul cx
    add bx, ax  ; Add late return fee to total fee

    ; Store total fee in totalFee
    mov totalFee, bx

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
    mov ax, totalFee
    call DisplayNumber

    ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP

DisplayNumber PROC
    ; Convert number in AX to string and display it
    push ax
    push bx
    push cx
    push dx

    ; Check for zero
    cmp ax, 0
    jne DisplayNumber_NotZero
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp DisplayNumber_Done

DisplayNumber_NotZero:
    ; Convert number to string
    lea bx, [numBuffer + 5]  ; Point to the end of the buffer
    mov byte ptr [bx], '$'   ; Null-terminate the string
    dec bx
DisplayNumber_Loop:
    xor dx, dx
    div word ptr [Ten]
    add dl, '0'
    mov [bx], dl
    dec bx
    cmp ax, 0
    jne DisplayNumber_Loop

    ; Display the string
    lea dx, [bx + 1]
    mov ah, 09h
    int 21h

DisplayNumber_Done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

    
DisplayNumber ENDP

end main
