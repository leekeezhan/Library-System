.model small
.stack 100h
.data
    buffer db 30          ; Maximum number of characters to read
            db ?          ; Number of characters actually read (to be filled by DOS)
            db 30 dup(?)  ; Buffer to hold the input string
    name1 db 30 dup(?)  ; Space to store the user's name (adjust size if necessary)
    entered_id db 30 dup(?)
    borrowFee dw 290
    number db 30 dup(?)

    correctID db "abcd $"
    correctPass db "123456 $"

    number1 db ?
    number2 db ?
    borrowDays dw ?
    lateReturnDays db ?
    totalFee dw ?
    bookID db ?
    tax dw ?
    purchaseConfirmation db ?
    totalPrice dw ?

    msg_name db "Name: $"
    msg_chooseBook db "Choose a book to borrow (1, 2, 3): $"
    msg_bookpurchase db "Choose a book to purchase (1, 2, 3): $"
    msg_borrowBook db "You have borrowed a book. Thank you! $"
    msg_purchasedBook db "You have puchased a book. Thank you! $"
    
    msg_bookName db "Book Name: $"
    msg_bookID db "Book to borrow: $"
    msg_borrowDays db "Days to borrow: $"
    msg_totalFee db "Total Fee: RM $"
    msg_serviceFee db "Service Fee: RM $"
    msg_total_price db "Total Price: RM $"

    no1 db "1. $"
    no2 db "2. $"
    no3 db "3. $"
    msg_book1 db "Poor Dad, Rich Dad $"
    msg_book2 db "Harry Potter $"
    msg_book3 db "Atomic Habits $"
    msg_book1_price db "Price: RM 5899.00 $"
    msg_book2_price db "Price: RM 7899.00 $"
    msg_book3_price db "Price: RM 10899.00 $"
    book_price dw 5899, 7899, 10899
    serviceFee dw 6

    menu1 db "1. Borrow a book $"
    menu2 db "2. Purchase a book $"
    menu3 db "3. Exit $"
    msg_menu db "Menu: $"
    msg_option db "Option: $"

    msg_exit db "Thank you for using our service! $"
    msg_invalidInput db "Invalid input. Please try again. $"
    msg_bookNotBorrowed db "You have not borrowed this book. $"
    msg_bookAlreadyBorrowed db "You have already borrowed this book. $"
    msg_bookNotFound db "Book not found. $"
    msg_enterID db "Enter Staff ID: $"
    msg_enterPass db "Enter Password: $"
    msg_welcome db "Welcome, $"
    msg_invalidLogin db "Invalid ID or Password. Please try again.$"
    msg_exit_option db "You can press '1' to exit. $"
    msg_invalidName db "The name is invalid. Please try again. $"
    msg_tax db "There will be a tax of 6% on the total price. $"
    msg_confirmToPurchase db "Are you sure you want to purchase this book? (Y/N/1 to exit): $"
    msg_invalidOption db "Invalid option. Please try again. $"

.code
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Clear screen
    mov ah, 00h
    mov al, 03h
    int 10h

    ; Call staff login procedure
    call staff_login

    ; If login successful, jump to main loop
    jmp main_loop

main_loop:

    call newline

    ; Display menu
    lea dx, msg_menu
    mov ah, 09h
    int 21h

    ; New line
    call newline

    ; Print menu options
    lea dx, menu1
    mov ah, 09h
    int 21h
    call newline

    lea dx, menu2
    mov ah, 09h
    int 21h
    call newline

    lea dx, menu3
    mov ah, 09h
    int 21h
    call newline

    ; Prompt for option
    lea dx, msg_option
    mov ah, 09h
    int 21h

    ; Get user choice
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; New line
    call newline

    ; Process user choice
    cmp bl, 1
    je borrow_book
    cmp bl, 2
    je purchase_book
    cmp bl, 3
    je exit_program

    ; Invalid input
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h

    call newline

    jmp main_loop

borrow_book:
    ; Call borrow procedure
    call borrow
    jmp main_loop

purchase_book:
    ; Call return procedure (placeholder for now)
    call purchase
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
borrow_name:
    lea dx, msg_name
    mov ah, 09h
    int 21h

    ; Get name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; Validate the name
    call validate_name
    cmp al, 1               ; Check if validation was successful (al = 1)
    jne borrow_name         ; If not successful, jump to borrow_name

    ; New line
    call newline

    ; Copy the name from buffer to name1
    lea si, buffer + 2       ; Point SI to the start of the name in buffer
    lea di, name1            ; Point DI to the start of name1
    mov al, buffer[1]        ; Get the length of the input from buffer[1]
    xor ah, ah               ; Clear AH to ensure CX is zero-extended
    mov cx, ax               ; Move AX (now containing the value from AL) into CX

    rep movsb                ; Copy CX bytes from [SI] to [DI]

    call display_book_option

    call newline

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
    call newline
    call newline

    ; Prompt user to enter borrow days
    lea dx, msg_borrowDays
    mov ah, 09h
    int 21h

    ;read first digit
    mov ah, 01h
    int 21h
    sub al, 30h
    mov number1, al

    ;read second digit
    mov ah, 01h
    int 21h
    sub al, 30h
    mov number2, al

    call newline

    ;Combine digits into a two-digit integer
    mov al, number1
    mov ah, 0
    mov cl, 10
    mul cl
    add al, number2

    ;currently al has combined number
    mov ah, 0
    mov borrowDays, ax

    ; Calculate total fee
    mov ax, borrowDays
    mov bx, borrowFee
    mul bx              ; Multiply borrowDays by borrowFee
    mov totalFee, ax    ; Store the total fee in totalFee (AX = totalFee)

    ; Display book name based on ID
    lea dx, msg_bookName
    mov ah, 09h
    int 21h
    call display_book_name

    ;newline
    call newline

    ; Display total fee message
    lea dx, msg_totalFee
    mov ah, 09h
    int 21h

    call display_number     ; Call the display_number procedure

    call newline

borrow_done:
    ; Pause before returning to the menu
    mov ah, 01h
    int 21h

    ret
borrow ENDP

purchase PROC
    ; Code for purchasing a book
purchase_name:
    lea dx, msg_name
    mov ah, 09h
    int 21h

    ; Get name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; Validate the name
    call validate_name
    cmp al, 1               ; Check if validation was successful (al = 1)
    jne purchase_name         ; If not successful, jump to purchase_name

    ; New line
    call newline

    ; Copy the name from buffer to name1
    lea si, buffer + 2       ; Point SI to the start of the name in buffer
    lea di, name1            ; Point DI to the start of name1
    mov al, buffer[1]        ; Get the length of the input from buffer[1]
    xor ah, ah               ; Clear AH to ensure CX is zero-extended
    mov cx, ax               ; Move AX (now containing the value from AL) into CX
    rep movsb                ; Copy CX bytes from [SI] to [DI]

book_options:
    call display_book_option

    call newline

    ; Prompt user to choose a book to purchase
    lea dx, msg_bookpurchase
    mov ah, 09h
    int 21h

    ; Get user input for book
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bookID, al

    ; New line
    call newline
    call newline

    ; Display the book name
    lea dx, msg_bookName
    mov ah, 09h
    int 21h
    call display_book_name

    call newline

    ; Display the book price
    call display_book_price

    call newline

    call calculate_service_fee_and_total_price

    call newline
    call newline

display_tax:
    call newline
    ;display tax msg
    lea dx, msg_tax
    mov ah, 09h
    int 21h

    call newline

    ;display exit option
    lea dx, msg_exit_option
    mov ah, 09h
    int 21h

    call newline

prompt_confirmation:
    ;display confirmation msg
    lea dx, msg_confirmToPurchase
    mov ah, 09h
    int 21h

    ;prompt and accpet a character entered by user
    ;store the character into purchaseConfirmaton variable
    mov ah, 01h
    int 21h
    mov purchaseConfirmation, al

    ; New line
    call newline

    call confirm_purchase

    call newline

    ; Calculate and display the service fee and total price
    call calculate_service_fee_and_total_price

    ; Confirm purchase
    lea dx, msg_confirmToPurchase
    mov ah, 09h
    int 21h
    call confirm_purchase

    ; Pause before returning to the menu
    mov ah, 01h
    int 21h

    ret
purchase ENDP

display_book_option PROC

    call newline

    ; Print book options
    lea dx, no1
    mov ah, 09h
    int 21h
    lea dx, msg_book1
    mov ah, 09h
    int 21h
    call newline

    lea dx, no2
    mov ah, 09h
    int 21h
    lea dx, msg_book2
    mov ah, 09h
    int 21h
    call newline

    lea dx, no3
    mov ah, 09h
    int 21h
    lea dx, msg_book3
    mov ah, 09h
    int 21h

    ret
display_book_option ENDP

display_serviceFee PROC

    ;store the result in tax
    mov ax, tax

    ;divide by 100
    mov cx, 100
    xor dx, dx
    div cx
    
    ; Store the integer part and fractional part
    mov bx, ax              ; BX = integer part (dollars)
    mov si, dx              ; SI = fractional part (cents)

    ; Display the integer part
    call print_number       ; Print the integer part (stored in BX)

    ; Display the decimal point
    mov dl, '.'
    mov ah, 02h
    int 21h

    ; Ensure the fractional part is always two digits
    mov ax, si              ; Load the fractional part into AX
    cmp ax, 9
    jae skip_leading_zero
    ; If less than 10, print a leading zero
    mov dl, '0'
    mov ah, 02h
    int 21h

skip_leading_zero:
    ; Print the fractional part
    call print_number

    ret
display_serviceFee ENDP

display_price PROC
    
    ; Load totalFee into AX
    mov ax, tax

    ; Divide totalFee by 100 to separate the integer part and the fractional part
    mov cx, 100
    xor dx, dx              ; Clear DX for division
    div cx                  ; AX = integer part (quotient), DX = remainder (fractional part)
    mov bx, totalPrice
    add ax, bx

    ; Store the integer part and fractional part
    mov bx, ax              ; BX = integer part (dollars)
    mov si, dx              ; SI = fractional part (cents)

    ; Display the integer part
    call print_number       ; Print the integer part (stored in BX)

    ; Display the decimal point
    mov dl, '.'
    mov ah, 02h
    int 21h

    ; Ensure the fractional part is always two digits
    mov ax, si              ; Load the fractional part into AX
    cmp ax, 9
    jae skip_leading_zero1
    ; If less than 10, print a leading zero
    mov dl, '0'
    mov ah, 02h
    int 21h

skip_leading_zero1:
    ; Print the fractional part
    call print_number

    ret
display_price ENDP


display_number PROC
    ; Load totalFee into AX
    mov ax, totalFee

    ; Divide totalFee by 100 to separate the integer part and the fractional part
    mov cx, 100
    xor dx, dx              ; Clear DX for division
    div cx                  ; AX = integer part (quotient), DX = remainder (fractional part)

    ; Store the integer part and fractional part
    mov bx, ax              ; BX = integer part (dollars)
    mov si, dx              ; SI = fractional part (cents)

    ; Display the integer part
    call print_number       ; Print the integer part (stored in BX)

    ; Display the decimal point
    mov dl, '.'
    mov ah, 02h
    int 21h

    ; Ensure the fractional part is always two digits
    mov ax, si              ; Load the fractional part into AX
    cmp ax, 9
    jae skip_leading_zero2
    ; If less than 10, print a leading zero
    mov dl, '0'
    mov ah, 02h
    int 21h

skip_leading_zero2:
    ; Print the fractional part
    call print_number

    ret
display_number ENDP

print_number PROC
    ; Assumes the number to print is in AX
    push ax
    xor cx, cx              ; Clear CX (digit count)
    xor dx, dx              ; Clear DX

    ; Convert number to string in reverse order
convert_loop:
    xor dx, dx              ; Clear DX for division
    mov bx, 10
    div bx                  ; AX = AX / 10, DX = remainder
    add dl, '0'             ; Convert remainder to ASCII
    push dx                 ; Push the ASCII character onto the stack
    inc cx                  ; Increment digit count
    test ax, ax
    jnz convert_loop        ; Repeat until AX == 0

    ; Print the number in correct order
print_loop:
    pop dx                  ; Pop the character from the stack
    mov ah, 02h
    int 21h                 ; Print the character
    loop print_loop         ; Repeat for all digits

    pop ax                  ; Restore original AX value
    ret
print_number ENDP

staff_login PROC
    ; Loop for login attempts
login_attempt:

    ;print exit msg
    lea dx, msg_exit_option
    mov ah, 09h
    int 21h

    ;newline
    call newline

    ; Prompt for Staff ID
    lea dx, msg_enterID
    mov ah, 09h
    int 21h

    ; Read Staff ID
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ;check the buffer that if the buffer equal to '1' then exit
    mov al, buffer[2]
    cmp al, '1'
    jne continue_login 
    jmp exit_program

continue_login:
    ; Compare entered ID with correctID character by character
    lea si, buffer + 2        ; Point SI to the first character of the input
    lea di, correctID         ; Point DI to the first character of the correct ID
    mov cx, 4                 ; Number of characters to compare

compare_id:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL (input char) with the char at DI
    jne invalid_login         ; If not equal, jump to invalid_login
    inc di                    ; Increment DI to point to the next character
    loop compare_id           ; Loop for the number of characters in CX

    ;new line
    call newline
    
    ; Prompt for Password
    lea dx, msg_enterPass
    mov ah, 09h
    int 21h

    ; Read Password
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Compare entered password with correctPass character by character
    lea si, buffer + 2        ; Point SI to the first character of the input
    lea di, correctPass       ; Point DI to the first character of the correct Pass
    mov cx, 6                 ; Number of characters to compare

    call newline

compare_pass:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    cmp al, [di]              ; Compare AL (input char) with the char at DI
    jne invalid_login         ; If not equal, jump to invalid_login
    inc di                    ; Increment DI to point to the next character
    loop compare_pass         ; Loop for the number of characters in CX

    ; Display welcome message if login is successful
    lea dx, msg_welcome
    mov ah, 09h
    int 21h

    ;display id
    lea dx, correctID
    mov ah, 09h
    int 21h

    call newline

    ret

invalid_login:
    lea dx, msg_invalidLogin
    mov ah, 09h
    int 21h

    ; Ask for retry
    jmp login_attempt

staff_login ENDP

display_book_name PROC

    cmp bookID, 1
    je show_book1
    cmp bookID, 2
    je show_book2
    cmp bookID, 3
    je show_book3

    ; If no match, display book not found
    lea dx, msg_bookNotFound
    mov ah, 09h
    int 21h
    jmp display_book_name_done

show_book1:
    lea dx, msg_book1
    mov ah, 09h
    int 21h
    jmp display_book_name_done

show_book2:
    lea dx, msg_book2
    mov ah, 09h
    int 21h
    jmp display_book_name_done

show_book3:
    lea dx, msg_book3
    mov ah, 09h
    int 21h

display_book_name_done:
    ret
display_book_name ENDP

validate_name PROC

    ; Load the number of characters entered into CX
    mov al, buffer[1]          ; Move the byte from buffer[1] into AL
    xor ah, ah                 ; Clear AH to zero-extend AL into AX
    mov cx, ax                 ; Move AX into CX

    ; Check if the name contains only alphabetic characters
    lea si, buffer + 2         ; Point SI to the first character of the input
    call check_buffer_char     ; Call the procedure to check each character

    ; If the name is valid, set AL to 1
    mov al, 1
    ret

invalid_name:
    ; Set AL to 0 indicating invalid input
    mov al, 0
    ret
validate_name ENDP

check_buffer_char PROC
    push cx                    ; Save CX register
    push si                    ; Save SI register

next_char:
    lodsb                      ; Load the next byte from buffer into AL
    cmp al, 'A'                ; Compare AL with 'A'
    jb invalid_name            ; If below 'A', it's invalid
    cmp al, 'Z'                ; Compare AL with 'Z'
    jbe continue_check         ; If between 'A' and 'Z', continue checking
    cmp al, 'a'                ; Compare AL with 'a'
    jb invalid_name            ; If below 'a', it's invalid
    cmp al, 'z'                ; Compare AL with 'z'
    ja invalid_name            ; If above 'z', it's invalid

continue_check:
    loop next_char             ; Decrement CX and check the next character if CX != 0

    ; All characters are valid
    pop si                     ; Restore SI register
    pop cx                     ; Restore CX register
    ret

check_buffer_char ENDP

display_book_price PROC

    cmp bookID, 1
    je show_price1
    cmp bookID, 2
    je show_price2
    cmp bookID, 3
    je show_price3

    ; If no match, display book not found
    lea dx, msg_bookNotFound
    mov ah, 09h
    int 21h

show_price1:
    lea dx, msg_book1_price
    mov ah, 09h
    int 21h
    jmp display_book_price_done

show_price2:
    lea dx, msg_book2_price
    mov ah, 09h
    int 21h
    jmp display_book_price_done

show_price3:
    lea dx, msg_book3_price
    mov ah, 09h
    int 21h
    jmp display_book_price_done

display_book_price_done:

    ret
display_book_price ENDP

confirm_purchase PROC
    cmp purchaseConfirmation, 'Y'
    je book_purchased
    je jump_out
    cmp purchaseConfirmation, 'y'
    je book_purchased
    je jump_out
    cmp purchaseConfirmation, 'N'
    je jump_out
    cmp purchaseConfirmation, 'n'
    je jump_out
    ;compare the purchase confirmation if it is 1 then exit the program directly
    cmp purchaseConfirmation, '1'
    je jump_exit

    ; If no match, display invalid option
    lea dx, msg_invalidOption
    mov ah, 09h
    int 21h
    call newline
    call newline
    jmp prompt_confirmation

    ;put the book purchased into a string variable
    ;if the user want to purchase the same book again
    ;show 'currently sold' in the library
book_purchased:
    lea dx, msg_purchasedBook
    mov ah, 09h
    int 21h
    call newline
jump_out:
    jmp main_loop

jump_exit:
    jmp exit_program

    ret
confirm_purchase ENDP

calculate_service_fee_and_total_price PROC
    ; Determine book price based on bookID
    cmp bookID, 1
    je set_book1_price
    cmp bookID, 2
    je set_book2_price
    cmp bookID, 3
    je set_book3_price

    ; Set default price in case of error
    jmp invalid_book_selection

set_book1_price:
    mov ax, book_price[0]
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, book_price[0]
    mov totalPrice, ax
    jmp calculate_fees

set_book2_price:
    mov ax, book_price[2]
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, book_price[2]
    mov totalPrice, ax
    jmp calculate_fees

set_book3_price:
    mov ax, book_price[4]
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, book_price[4]
    mov totalPrice, ax

calculate_fees:

    ;display serviceFee
    lea dx, msg_serviceFee
    mov ah, 09h
    int 21h
    call display_serviceFee
    call newline

    ; Display total price
    lea dx, msg_total_price
    mov ah, 09h
    int 21h
    call display_price
    call newline

    jmp display_tax

invalid_book_selection:
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    jmp book_options
    ret
calculate_service_fee_and_total_price ENDP

newline PROC
    mov ah, 02h
    mov dl, 0Dh  ; carriage return
    int 21h
    mov dl, 0Ah  ; line feed
    int 21h
    ret
newline ENDP

END main
