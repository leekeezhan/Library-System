.model small
.stack 100h
.data
    line db "+===================================+$"
    ;prompt user input
    buffer db 30          ; Maximum number of characters to read
            db ?          ; Number of characters actually read (to be filled by DOS)
            db 30 dup(?)  ; Buffer to hold the input string
    nameBorrow db 30 dup(?)
    bookBorrow db 30 dup(?)
    namePurchase db 30 dup(?)
    entered_id db 30 dup(?)
    number db 30 dup(?)
    nameBuffer db 30 dup(?)
    bookBuffer db 30 dup(?)
    

    ;login information
    correctID db "abcd $"
    correctPass db "123456 $"

    ;borrow and pruchase
    number1 db ?
    number2 db ?
    borrowDays dw ?
    lateReturnDays db ?
    totalFee dw ?
    bookID db ?
    tax dw ?
    Confirmation db ?
    totalPrice dw ?
    quantityPurchased dw ?
    subtotalPurchased dw ?
    totalAmountPurchased dw ?

    msg_nameBorrower db "Enter Borrower Name: $"
    msg_namePurchaser db "Enter Purchaser Name: $"
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
    msg_quantity db "Quantity: $"

    no1 db "1. $"
    no2 db "2. $"
    no3 db "3. $"
    msg_book1 db "Poor Dad, Rich Dad$"
    msg_book2 db "Harry Potter$"
    msg_book3 db "Atomic Habits$"
    msg_book_price db "Price: RM $"
    msg_book_subtotal db "Subtotal: RM $"
    book_price dw 799, 999, 1399
    serviceFee dw 6
    borrowFee dw 290

    menu1 db "1. Borrow Book $"
    menu2 db "2. Purchase Book $"
    menu3 db "3. Return Book $"
    menu6 db "6. Exit $"
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
    msg_confirmToBorrow db "Are you sure you want to borrow this book? (Y/N/1 to exit): $"
    msg_confirmToPurchase db "Are you sure you want to purchase this book? (Y/N/1 to exit): $"
    msg_invalidOption db "Invalid option. Please try again. $"

    ;return
    promptName db "Enter your name: $"
    promptBook db "Enter Book Name: $"
    errormsg db "Input does not match. Please re-enter.$"
    promptReturn db "Please enter return day (Eg : 07 or 77): $"
    errormsg2 db 'Invalid input. Please enter a two-digit number (Eg : 07 or 77): $'
    overduefeesmsg db 'The total overdue fees is: RM$'
    returnMessage db "Continue for returning (1 = Yes) ? $"
    noOverdueFee db "No Overdue Fee will be charged. $"
    returnTitle db "|         Returning details         |", 0Dh, 0Ah, "$"
    borrowerTitle db "Borrower : $"
    overdueTitle db "Overdue fees : RM$"
    finePerDay db "Fine per day (Late returning) : RM5.80 $"
    actualBorrowDay db "Borrow day : $"
    bookTitle db "Book Name : $"
    overdueDayTitle db "Day late : $"
    returnPrompt db "Done returning book (1 = yes)? $"
    returnDayTitle db "Return Day : $"

    dollar dw ?
    cents db ?
    borrowedDay dw ?                ; 16-bit variable to store the final integer
    overdueCharge dw 580

    digit1 db ?                     ; Variable to store the first digit
    digit2 db ?                     ; Variable to store the second digit
    returnDay dw ?
    overdueDay dw ?
    returnResponse db ?
    overdueFee db ?
    overdueTotal dw ?

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

    lea dx, menu6
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
    je return_book
    cmp bl, 6
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

return_book:
    ; Call return procedure
    call return
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
    ;Clear buffer
    ; Prompt user to enter name
borrow_name:

    lea dx, msg_nameBorrower
    mov ah, 09h
    int 21h

    ; Get name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    mov al, buffer[1]        ; Get the length of the input from buffer[1]
    cmp al, 0               ; Check if the input is empty
    jne name_validation

return_to_main_loop:
    ;call the main loop method
    call newline
    call newline
    call main_loop

name_validation:
    ; Validate the name
    call validate_name
    cmp al, 1               ; Check if validation was successful (al = 1)

    ; New line
    call newline

    ; Copy the name from buffer to name
    lea si, buffer + 2       ; Point SI to the start of the name in buffer
    lea di, nameBorrow       ; Point DI to the start of name
    mov al, buffer[1]        ; Get the length of the input from buffer[1]
    xor ah, ah               ; Clear AH to ensure CX is zero-extended
    mov cx, ax               ; Move AX (now containing the value from AL) into CX, ax

copy_name_loop:
    cmp cx, 0            ; Check if there are still characters to copy
    je done_copying      ; If no characters left, exit loop
    mov al, [si]        ; Load the byte from [SI] into AL
    mov [di], al        ; Store the byte from AL into [DI]
    inc si              ; Increment SI to point to the next character
    inc di              ; Increment DI to point to the next position in nameBorrow
    loop copy_name_loop ; Decrement CX and repeat if CX != 0

done_copying:
    ; Null-terminate nameBorrow with '$'
    mov byte ptr [di], '$'  ; Place DOS string terminator at the end of nameBorrow

    ; New line
    call newline

    ; Call function to display book options
    call display_book_option

get_bookID:

    call newline

    ; Prompt user to choose a book to purchase
    lea dx, msg_chooseBook
    mov ah, 09h
    int 21h

    ; Get user input for book
    mov ah, 01h           ; Read a single character input
    int 21h
    sub al, '0'           ; Convert ASCII to numeric value
    mov bookID, al        ; Store input in bookID

    cmp al, 1             ; Check if the input is 1
    je store_book1        ; If 1, jump to valid_input
    cmp al, 2             ; Check if the input is 2
    je store_book2        ; If 2, jump to valid_input
    cmp al, 3             ; Check if the input is 3
    je store_book3        ; If 3, jump to valid_input

    call newline

    ; If input is not 1, 2, or 3, show error and ask again
    lea dx, msg_invalidInput
    mov ah, 09h           ; Display error message
    int 21h
    call newline          ; Print new line
    jmp get_bookID        ; Re-prompt for input

store_book1:
    lea si, msg_book1
    lea di, bookBorrow
    mov al, msg_book1[1]
    xor ah, ah
    mov cx, ax
    jmp copy_book_loop

store_book2:
    lea si, msg_book2
    lea di, bookBorrow
    mov al, msg_book2[1]
    xor ah, ah
    mov cx, ax
    jmp copy_book_loop

store_book3:
    lea si, msg_book3
    lea di, bookBorrow
    mov al, msg_book3[1]
    xor ah, ah
    mov cx, ax
    jmp copy_book_loop

copy_book_loop:
    cmp cx, 0            ; Check if there are still characters to copy
    je done_copying_book ; If no characters left, exit loop
    mov al, [si]        ; Load the byte from [SI] into AL
    mov [di], al        ; Store the byte from AL into [DI]
    inc si              ; Increment SI to point to the next character
    inc di              ; Increment DI to point to the next position in bookBorrow
    loop copy_book_loop ; Decrement CX and repeat if CX != 0

done_copying_book:
    ; Null-terminate bookBorrow with '$'
    mov byte ptr [di], '$'  ; Place DOS string terminator at the end of bookBorrow

    call newline

input_borrow:
    ; Prompt user to enter borrow days
    lea dx, msg_borrowDays
    mov ah, 09h
    int 21h

get_first_digit:
    ; Read first digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_digit      ; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_digit      ; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov number1, al       ; Store the first digit
    jmp get_second_digit  ; Proceed to read the second digit

invalid_digit:
    ; Show error message and re-prompt for first digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_borrow

get_second_digit:
    ; Read second digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_second_digit ; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_second_digit ; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov number2, al       ; Store the second digit
    jmp process_dayborrow  ; Proceed to processing

invalid_second_digit:
    ; Show error message and re-prompt for second digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_borrow

process_dayborrow:

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

    call newline

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
    call newline

prompt_confirmation:
    call newline

    ;display confirmation
    lea dx, msg_confirmToBorrow
    mov ah, 09h
    int 21h

    ;prompt and accpet a character entered by user
    ;store the character into purchaseConfirmaton variable
    mov ah, 01h
    int 21h
    mov Confirmation, al

    call newline

    call confirm_borrow

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
    lea dx, msg_namePurchaser
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

    ; Copy the name from buffer to name
    lea si, buffer + 2       ; Point SI to the start of the name in buffer
    lea di, namePurchase     ; Point DI to the start of name
    mov al, buffer[1]        ; Get the length of the input from buffer[1]
    xor ah, ah               ; Clear AH to ensure CX is zero-extended
    mov cx, ax               ; Move AX (now containing the value from AL) into CX
    rep movsb                ; Copy CX bytes from [SI] to [DI]

book_options:
    call display_book_option

get_bookID1:

    call newline

    ; Prompt user to choose a book to purchase
    lea dx, msg_bookpurchase
    mov ah, 09h
    int 21h

    ; Get user input for book
    mov ah, 01h           ; Read a single character input
    int 21h
    sub al, '0'           ; Convert ASCII to numeric value
    mov bookID, al        ; Store input in bookID

    cmp al, 1             ; Check if the input is 1
    je valid_input1        ; If 1, jump to valid_input
    cmp al, 2             ; Check if the input is 2
    je valid_input1        ; If 2, jump to valid_input
    cmp al, 3             ; Check if the input is 3
    je valid_input1        ; If 3, jump to valid_input

    call newline

    ; If input is not 1, 2, or 3, show error and ask again
    lea dx, msg_invalidInput
    mov ah, 09h           ; Display error message
    int 21h
    call newline          ; Print new line
    jmp get_bookID        ; Re-prompt for input
valid_input1:
    call newline

input_quantity:
    ;prompt user to enter the quantity
    lea dx, msg_quantity
    mov ah, 09h
    int 21h

get_first_digit1:
    ; Read first digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_digit1      ; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_digit1      ; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov number1, al       ; Store the first digit
    jmp get_second_digit1  ; Proceed to read the second digit

invalid_digit1:
    ; Show error message and re-prompt for first digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_quantity

get_second_digit1:
    ; Read second digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_second_digit1 ; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_second_digit1 ; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov number2, al       ; Store the second digit
    jmp process_quantity  ; Proceed to processing

invalid_second_digit1:
    ; Show error message and re-prompt for second digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_quantity

process_quantity:
    ;Combine digits into a two-digit integer
    mov al, number1
    mov ah, 0
    mov cl, 10
    mul cl
    add al, number2

    ;mov the two digit to quantityPurchased for storing
    mov quantityPurchased, ax

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

    call display_subtotal

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

prompt_confirmation1:
    ;display confirmation msg
    lea dx, msg_confirmToPurchase
    mov ah, 09h
    int 21h

    ;prompt and accpet a character entered by user
    ;store the character into purchaseConfirmaton variable
    mov ah, 01h
    int 21h
    mov Confirmation, al

    ; New line
    call newline

    call confirm_purchase

    call newline

    ; Pause before returning to the menu
    mov ah, 01h
    int 21h

    ret
purchase ENDP

return PROC

    mov ah, 00
    mov al, 03  ; Clear Screen
    int 10h

    ; Call procedures in sequence
    call CompareNames
    call CompareBooks
    call CalculateOverdueFees
    
    ret

return ENDP

; Procedure to compare names


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
    mov bx, totalAmountPurchased
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

    ; Check if the name contains only valid characters (no digits)
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
    cmp al, '0'                ; Compare AL with '0' (check if it's a digit)
    jb check_alpha             ; If below '0', it's not a digit, so check if it's a valid character
    cmp al, '9'                ; Compare AL with '9'
    jbe invalid_name           ; If it's between '0' and '9', jump to invalid_name

check_alpha:
    cmp al, 'A'                ; Compare AL with 'A'
    jb check_space             ; If below 'A', check if it's a space
    cmp al, 'Z'                ; Compare AL with 'Z'
    jbe continue_check         ; If between 'A' and 'Z', it's valid, continue checking
    cmp al, 'a'                ; Compare AL with 'a'
    jb check_space             ; If below 'a', check if it's a space
    cmp al, 'z'                ; Compare AL with 'z'
    jbe continue_check         ; If between 'a' and 'z', it's valid, continue checking

check_space:
    cmp al, ' '                ; Compare AL with space character ' '
    je continue_check          ; If it's a space, continue checking
    jmp invalid_name           ; If not a valid character, jump to invalid_name

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
    jmp display_book_price_done

show_price1:
    lea dx, msg_book_price
    mov ah, 09h
    int 21h
    mov ax, [book_price]      ; Get first book price
    call convert_and_display
    jmp display_book_price_done

show_price2:
    lea dx, msg_book_price
    mov ah, 09h
    int 21h
    mov ax, [book_price + 2]  ; Get second book price
    call convert_and_display
    jmp display_book_price_done

show_price3:
    lea dx, msg_book_price
    mov ah, 09h
    int 21h
    mov ax, [book_price + 4]  ; Get third book price
    call convert_and_display
    jmp display_book_price_done

display_book_price_done:

    ret
display_book_price ENDP

display_subtotal PROC
    cmp bookID, 1
    je show_subtotal1
    cmp bookID, 2
    je show_subtotal2
    cmp bookID, 3
    je show_subtotal3

    ; If no match, display book not found
    lea dx, msg_bookNotFound
    mov ah, 09h
    int 21h
    jmp display_book_price_done

show_subtotal1:
    lea dx, msg_book_subtotal
    mov ah, 09h
    int 21h
    ;multiple book price with quantity
    mov ax, [book_price]      ; Get first book price
    mov bx, quantityPurchased
    mul bx
    mov subtotalPurchased, ax
    call convert_and_display
    jmp display_book_subtotal_done

show_subtotal2:
    lea dx, msg_book_subtotal
    mov ah, 09h
    int 21h
    ;multiple book price with quantity
    mov ax, [book_price + 2]      ; Get first book price
    mov bx, quantityPurchased
    mul bx
    mov subtotalPurchased, ax
    call convert_and_display
    jmp display_book_subtotal_done

show_subtotal3:
    lea dx, msg_book_subtotal
    mov ah, 09h
    int 21h
    ;multiple book price with quantity
    mov ax, [book_price + 4]      ; Get first book price
    mov bx, quantityPurchased
    mul bx
    mov subtotalPurchased, ax
    call convert_and_display
    jmp display_book_subtotal_done
    
display_book_subtotal_done:
    ret
display_subtotal ENDP

convert_and_display PROC
    ; AX contains the number (e.g., 5899)
    push ax
    mov cx, 0              ; Initialize digit count
    
convert_loop1:
    xor dx, dx             ; Clear DX for division
    mov bx, 10             ; Divisor (base 10)
    div bx                 ; AX / 10, quotient in AX, remainder (digit) in DX
    push dx                ; Save the digit (remainder)
    inc cx                 ; Increment digit count
    test ax, ax            ; If AX == 0, we're done
    jnz convert_loop1       ; Repeat until AX is 0

    ; Now we have the digits in the stack, and CX contains the count of digits
display_digits:
    pop dx                 ; Get the top digit from the stack
    add dl, '0'            ; Convert digit to ASCII
    mov ah, 02h            ; DOS interrupt to display a single character
    int 21h                ; Display the character
    loop display_digits    ; Repeat for all digits

    pop ax                 ; Restore AX
    ret
convert_and_display ENDP

confirm_purchase PROC
    cmp Confirmation, 'Y'
    je book_purchased
    cmp Confirmation, 'y'
    je book_purchased
    cmp Confirmation, 'N'
    call newline
    je jump_out
    cmp Confirmation, 'n'
    call newline
    je jump_out
    ;compare the purchase confirmation if it is 1 then exit the program directly
    cmp Confirmation, '1'
    je jump_exit

    ; If no match, display invalid option
    lea dx, msg_invalidOption
    mov ah, 09h
    int 21h
    call newline
    call newline
    jmp prompt_confirmation1

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

confirm_borrow PROC
    cmp Confirmation, 'Y'
    je book_borrowed
    cmp Confirmation, 'y'
    je book_borrowed
    cmp Confirmation, 'N'
    call newline
    je jump_out1
    cmp Confirmation, 'n'
    call newline
    je jump_out1
    ;compare the purchase confirmation if it is 1 then exit the program directly
    cmp Confirmation, '1'
    je jump_exit1

    ; If no match, display invalid option
    lea dx, msg_invalidOption
    mov ah, 09h
    int 21h
    call newline
    call newline
    jmp prompt_confirmation1

book_borrowed:
    lea dx, msg_borrowBook
    mov ah, 09h
    int 21h
    call newline
jump_out1:
    jmp main_loop

jump_exit1:
    jmp exit_program

    ret
confirm_borrow ENDP

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
    mov ax, subtotalPurchased
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, subtotalPurchased
    mov totalAmountPurchased, ax
    jmp calculate_fees

set_book2_price:
    mov ax, subtotalPurchased
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, subtotalPurchased
    mov totalAmountPurchased, ax
    jmp calculate_fees

set_book3_price:
    mov ax, subtotalPurchased
    mov bx, serviceFee
    mul bx
    mov tax, ax
    mov ax, subtotalPurchased
    mov totalAmountPurchased, ax

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

CompareNames PROC
compare_names:

    ; Clear screen  
    mov ah, 00
    mov al, 03
    int 10h

    ; Prompt line
    lea dx, line
    mov ah, 09h
    int 21h

    call newline

    ; Prompt and get the first name
    lea dx, promptName
    mov ah, 09h
    int 21h

    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ;copy the buffer to nameBuffer
    lea si, buffer + 2     ; Skip buffer length byte and read count byte
    lea di, nameBuffer     ; Skip buffer length byte and read count byte
    mov al, buffer[1]    ; Number of characters in the input
    xor ah, ah 
    mov cx, ax

copy_borrower_loop:
    cmp cx, 0            ; Check if there are still characters to copy
    je completed_copying      ; If no characters left, exit loop
    mov al, [si]        ; Load the byte from [SI] into AL
    mov [di], al        ; Store the byte from AL into [DI]
    inc si              ; Increment SI to point to the next character
    inc di              ; Increment DI to point to the next position in nameBorrow
    loop copy_borrower_loop ; Decrement CX and repeat if CX != 0

completed_copying:
    ; Null-terminate nameBorrow with '$'
    mov byte ptr [di], '$'  ; Place DOS string terminator at the end of nameBorrow

    call newline

    ; Compare the two names character by character
    lea si, nameBuffer    ; Point SI to the first character of the entered name
    lea di, nameBorrow    ; Point DI to the first character of the stored name

compare_names_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne names_differ
    cmp al, '$'
    je names_match
    inc si
    inc di
    jmp compare_names_loop

names_differ:
    ; Display error message
    lea dx, errormsg
    mov ah, 09h
    int 21h

    call newline

    ; Clear both name buffers by setting them to null
    lea di, buffer+2     ; Skip buffer length and read count byte for nameBuffer
    mov cx, 39               ; Number of bytes to clear (39 because first byte is length byte)
clear_namebuffer:
    mov byte ptr [di], '$'   ; Set buffer content to null terminator '$'
    inc di
    loop clear_namebuffer

    ; Wait for user input to proceed
    mov ah, 01h
    int 21h

    ; Jump back to prompt for input again
    jmp compare_names

names_match:
    ret
CompareNames ENDP

; Procedure to compare book names
CompareBooks PROC
compare_books:

    ; Prompt line
    lea dx, line
    mov ah, 09h
    int 21h

    call newline

    ; Prompt and get the first book name
    lea dx, promptBook
    mov ah, 09h
    int 21h

    ; Read the first book name
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ;copy the buffer to bookBuffer
    lea si, buffer + 2     ; Skip buffer length byte and read count byte
    lea di, bookBuffer     ; Skip buffer length byte and read count byte
    mov al, buffer[1]    ; Number of characters in the input
    xor ah, ah 
    mov cx, ax

copy_return_loop:
    cmp cx, 0            ; Check if there are still characters to copy
    je completed_copying_book      ; If no characters left, exit loop
    mov al, [si]        ; Load the byte from [SI] into AL
    mov [di], al        ; Store the byte from AL into [DI]
    inc si              ; Increment SI to point to the next character
    inc di              ; Increment DI to point to the next position in bookBorrow
    loop copy_return_loop ; Decrement CX and repeat if CX != 0

completed_copying_book:
    ; Null-terminate bookBuffer with '$'
    mov byte ptr [di], '$'  ; Place DOS string terminator at the end of bookBuffer

    call newline

    ; Compare the two book names
    lea si, bookBuffer  ; Skip buffer length byte and read count byte
    lea di, bookBorrow    ; Skip buffer length byte and read count byte

compare_books_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne books_differ
    cmp al, '$'
    je books_match
    inc si
    inc di
    jmp compare_books_loop

books_differ:
    ; Display error message
    lea dx, errormsg
    mov ah, 09h
    int 21h

    call newline

    ; Clear both book buffers by setting them to null
    lea di, buffer+2      ; Skip buffer length and read count byte for bookBuffer
    mov cx, 39                ; Number of bytes to clear (39 because first byte is length byte)
clear_bookbuffer:
    mov byte ptr [di], '$'    ; Set buffer content to null terminator '$'
    inc di
    loop clear_bookbuffer

    ; Wait for user input to proceed
    mov ah, 01h
    int 21h

    ; Jump back to prompt for book names again
    jmp compare_books

books_match:
    ret
CompareBooks ENDP

; Procedure to calculate overdue fees
CalculateOverdueFees PROC
input_days_borrowed:
input_loop:

    ; Prompt line
    lea dx, line
    mov ah, 09h
    int 21h

    call newline

input_return:
    ; Display prompt message
    mov ah, 09h                ; DOS function to display a string
    lea dx, promptReturn             ; Load pointer to prompt message
    int 21h                    ; Display the prompt

get_first_digit_return:
    ; Read first digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_digit_return; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_digit_return; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov digit1, al       ; Store the first digit
    jmp get_second_digit_return  ; Proceed to read the second digit

invalid_digit_return:
    ; Show error message and re-prompt for first digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_return

get_second_digit_return:
    ; Read second digit
    mov ah, 01h           ; Read single character input
    int 21h
    cmp al, '0'           ; Check if the input is at least '0'
    jb invalid_second_digit_return ; If below '0', it's invalid
    cmp al, '9'           ; Check if the input is at most '9'
    ja invalid_second_digit_return ; If above '9', it's invalid
    sub al, '0'           ; Convert ASCII to numeric
    mov digit2, al       ; Store the second digit
    jmp process_return  ; Proceed to processing

invalid_second_digit_return:
    ; Show error message and re-prompt for second digit
    lea dx, msg_invalidInput
    mov ah, 09h
    int 21h
    call newline
    jmp input_return

process_return:

    call newline

    ; Combine digits into a two-digit integer
    mov al, digit1             ; Load first digit into AL
    mov ah, 0                  ; Clear AH to avoid garbage in AX
    mov cl, 10                 ; Load 10 into CL for multiplication
    mul cl                     ; Multiply AL by 10, result in AX (AX = AL * CL)
    add al, digit2             ; Add second digit to AL
    
    ; At this point, AL contains the combined number
    mov ah, 0                  ; Clear AH to extend AL into AX correctly
    mov returnDay, ax

    xor ax, ax 
    mov ax, returnDay
    mov borrowedDay, ax        ; Store the final number in variable 'borrowedDay'

    ; Subtract 6 from the number
    mov ax, borrowedDay        ; Load the number into AX
    mov bx, borrowDays         ; Subtract actual borrow day
    sub ax, bx
    mov overdueDay, ax         ; Find Overdue Day

    ;if overdueday less than 0 then prompt no overdue fee charged and call returnBook
    cmp ax, 0                  ; Compare result with 0
    jl noOverdue           ; If result is less than 0, display error message

    ; Calculate overdue charge
    mov ax, overdueDay
    mov bx, overdueCharge
    mul bx
    mov overdueTotal, ax

    ;display overdue fee
    lea dx, overduefeesmsg
    mov ah, 09h
    int 21h

    call display_overdueFee
    jmp return_done

    call newline               ; Ensure newline is called after

noOverdue:
    lea dx, noOverdueFee
    mov ah, 09h
    int 21h

return_done:
    call newline
    call ReturnBook

end_procedure:
    ret
CalculateOverdueFees ENDP

display_overdueFee PROC
    mov ax, overdueTotal

    mov cx, 100
    xor dx, dx
    div cx

    mov bx, ax
    mov si, dx

    call print_number

    ; Display the decimal point
    mov dl, '.'
    mov ah, 02h
    int 21h

    ; Ensure the fractional part is always two digits
    mov ax, si              ; Load the fractional part into AX
    cmp ax, 9
    jae skip_leading_zero3
    ; If less than 10, print a leading zero
    mov dl, '0'
    mov ah, 02h
    int 21h

skip_leading_zero3:
    ; Print the fractional part
    call print_number

    ret
display_overdueFee ENDP

; Procedure to ask if user has returned the book
ReturnBook PROC
    ; Prompt user if they are done returning the book
    lea dx, returnMessage
    mov ah, 09h
    int 21h

    ; Read user input (single character)
    mov ah, 01h          ; DOS function to read a character
    int 21h
    mov returnResponse, al

    call newline

    ; Check if input is valid (e.g., '1' for yes)
    cmp returnResponse, '1'
    je done_returning

    ; Handle invalid input or other options
    lea dx, msg_invalidInput ; Use appropriate message if needed
    mov ah, 09h
    int 21h
    call newline

    ; Retry or loop back if needed
    jmp ReturnBook

done_returning:
    ; Clear screen
    mov ah, 00
    mov al, 03
    int 10h
    
    ; Display "Line" title
    lea dx, line
    mov ah, 09h
    int 21h
    
    call newline

    ; Display "Returning details" title
    lea dx, returnTitle
    mov ah, 09h
    int 21h

    ; Display "Line" title
    lea dx, line
    mov ah, 09h
    int 21h
    
    call newline

    ; Display "Borrower : " and the user's name
    lea dx, borrowerTitle
    mov ah, 09h
    int 21h

    lea dx, nameBorrow  ; Skip buffer length byte and read count byte
    mov ah, 09h
    int 21h
    
    call newline

    ; Display "Book Name : " and the first book name
    lea dx, bookTitle
    mov ah, 09h
    int 21h

    lea dx, bookBorrow  ; Skip buffer length byte and read count byte
    mov ah, 09h
    int 21h
    
    call newline

    ; Display "Overdue fees : " and the calculated overdue fees
    lea dx, overdueTitle
    mov ah, 09h
    int 21h

    call display_overdueFee

    call newline

    ; Display "Fine per day : " title
    lea dx, finePerDay
    mov ah, 09h
    int 21h
    
    call newline

    ; Display "Borrow day : " title
    lea dx, actualBorrowDay
    mov ah, 09h
    int 21h

    ; Display Borrow Day
    mov ax, borrowDays  ; Load the borrowDays into AX for printing
    call print_number   ; Call the procedure to display the number

    call newline        

    ; Display "Return day : " title
    lea dx, returnDayTitle
    mov ah, 09h
    int 21h

    ;Display Borrow Day
    xor ax, ax
    mov ax, returnDay
    call print_number      ; Call the procedure to display the number

    call newline
    
    ; Display "Day Late : " title
    lea dx, overdueDayTitle
    mov ah, 09h
    int 21h

    ; Display the overdueDay value
    xor ax, ax
    mov ax, overdueDay
    call print_number    ; Call the procedure to display the number

    call newline

ask_for_main_menu:
    ; Ask if the user wants to return to main menu
    lea dx, returnPrompt
    mov ah, 09h
    int 21h

    ; Read user input (single character)
    mov ah, 01h          ; DOS function to read a character
    int 21h
    mov returnResponse, al

    call newline

    ; Check if the user entered '1'
    cmp returnResponse, '1'
    jne clear_borrow_details  ; If the input is not '1', keep asking

clear_borrow_details:
    lea si, bookBorrow
    call clear_buffer

    xor si, si
    lea si, nameBorrow
    call clear_buffer
    ; If '1' is entered, return to main loop
    jmp main_loop

    ; Exit the program
    mov ah, 4Ch
    int 21h
ReturnBook ENDP

clear_buffer PROC
    mov cx, 30          ; Set the count to 30 (or the length of the buffer)
clear_loop:
    mov byte ptr [si], '$'   ; Set each byte to '$'
    inc si
    loop clear_loop
    ret
clear_buffer ENDP

END main
