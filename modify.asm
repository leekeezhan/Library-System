.model small
.stack 100h
.data
    mainmenu db '   ---------------------------------------------------------- $'
    mainmenu0 db '      Book Name                Book Type        Book Price $'
    mainmenu1 db '   1. Harry Potter             Novel            20.00  $'
    mainmenu2 db '   2. Atomic Habits            Comic            15.00  $'
    mainmenu3 db '   3. Rich Dad Poor Dad        Self-help        25.00  $'
    mainmenu4 db '   4. Exit$'
    menuafter1 db '   1. $'
    menuafter2 db '   2. $'
    menuafter3 db '   3. $'
    display0 db '   Please choose the book you want to modify$'
    display1 db '   Book Name: $'
    display2 db '   Book Type: $'
    display3 db '   Book Price: $'
    book0 db '      $'
    book1 db 'Harry Potter$', 0
    book2 db 'Atomic Habits$', 0
    book3 db 'Rich Dad Poor Dad$', 0
    category1 db 'Novel$', 0
    category2 db 'Comic$', 0
    category3 db 'Self-help$', 0
    price1 db '20.00 $', 0
    price2 db '15.00 $', 0
    price3 db '25.00 $',  0 
    
    question1 db '   Enter your selection (1-4) ? $'
    selectChoice db ?
    updated db '   Book updated successfully. $'
    newBookNamePrompt db '   Change new book name: $'
    newBookCategoryPrompt db '   Change new book category: $'
    newBookPricePrompt db '   Change new book price: $'
    confirmPrompt db '   Are you sure you want to replace this book? (y/n) ? $'
    confirm db ?
    msgError db '   Invalid selection. Please enter 1, 2, 3 or 4.$'
    msgError1 db '   Invalid price. Please enter a valid price (10.00).$'
    newLine db 0Dh, 0Ah, '$'
    input db 30, 0, ' $'         ; 定义输入缓冲区（最大30个字符+终止符，31字节）

.code
main PROC
    mov ax, @data
    mov ds, ax

    call displaymainmenu

exitProgram:
    ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP

displaymainmenu PROC
    ; Print main menu (-----------------------------------------------------)
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu0
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu1
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu2
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu3
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu4
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    ; Print main menu (-----------------------------------------------------)
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h
    jmp questionStar
    ret
displaymainmenu ENDP

questionStar PROC
    ; Print question1 (Enter your selection)
    mov ah, 09h
    lea dx, question1
    int 21h

    ; Read user input
    mov ah, 01h
    int 21h          ; Read character into AL
    mov selectChoice, al   ; Store the character in buffer

    ; Check user input and display the corresponding book
    cmp selectChoice, '1'
    jne check2
    jmp promptNewBookName

check2:
    cmp selectChoice, '2'
    jne check3
    jmp promptNewBookName

check3:
    cmp selectChoice, '3'
    jne checkExit
    jmp promptNewBookName

checkExit:
    cmp selectChoice, '4'
    jne errorHandler
    jmp exitProgram

errorHandler:
    lea dx, newLine
    mov ah, 09h
    int 21h

    ; Handle invalid input
    mov ah, 09h
    lea dx, msgError
    int 21h

    ; Print a new line
    mov ah, 02h
    mov dl, 0Dh  ; Carriage return
    int 21h
    mov dl, 0Ah  ; Line feed
    int 21h
    jmp displaymainmenu
    ret
questionStar ENDP

promptNewBookName PROC
    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    ; Prompt for a new book name
    mov ah, 09h
    lea dx, newBookNamePrompt
    int 21h

    ; Get user's input
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; 检查是否有输入
    mov al, [input+1]    ; 获取输入的字符数
    cmp al, 0           ; 如果字符数为0，表示用户没有输入
    je no_input          ; 跳转到 no_input 处理

    ; Get length of the input
    mov cl, [input+1]
    cmp cl, 25
    jle short copy_input
    mov cl, 25

copy_input:
    ; 根据用户选择复制书名
    cmp selectChoice, '1'
    je copy_book1
    cmp selectChoice, '2'
    je copy_book2
    cmp selectChoice, '3'
    je copy_book3
    jmp end_promptNewBookName

copy_book1:
    lea si, [input+2]
    lea di, book1
    jmp start_copy

copy_book2:
    lea si, [input+2]
    lea di, book2
    jmp start_copy

copy_book3:
    lea si, [input+2]
    lea di, book3

start_copy:
    mov bl, cl
copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    dec bl
    jnz copy_loop

    ; End with '$'
    mov byte ptr [di], '$'

no_input:
    ; Prompt for new book category
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, newBookCategoryPrompt
    int 21h

    ; Get user's input for category
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; 检查是否有输入
    mov al, [input+1]    ; 获取输入的字符数
    cmp al, 0           ; 如果字符数为0，表示用户没有输入
    je no_input1          ; 跳转到 no_input 处理

    ; Get length of the input
    mov cl, [input+1]
    cmp cl, 17
    jle short copy_category
    mov cl, 17

copy_category:
    ; 根据用户选择复制类别
    cmp selectChoice, '1'
    je copy_category1
    cmp selectChoice, '2'
    je copy_category2
    cmp selectChoice, '3'
    je copy_category3
    jmp end_promptNewBookName

copy_category1:
    lea si, [input+2]
    lea di, category1
    jmp start_copy_category

copy_category2:
    lea si, [input+2]
    lea di, category2
    jmp start_copy_category

copy_category3:
    lea si, [input+2]
    lea di, category3

start_copy_category:
    mov bl, cl
copy_loop_category:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    dec bl
    jnz copy_loop_category

    ; End with '$'
    mov byte ptr [di], '$'

no_input1:
    
call promptNewBookPrice

end_promptNewBookName:
    ; Prompt for new book price
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, updated
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    jmp displayAll

    ret
promptNewBookName ENDP

promptNewBookPrice PROC
    ; Prompt for new book category
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, newBookPricePrompt
    int 21h

    ; Get user's input for price
    mov ah, 0Ah
    lea dx, input
    int 21h

    ; 检查是否有输入
    mov al, [input+1]    ; 获取输入的字符数
    cmp al, 0           ; 如果字符数为0，表示用户没有输入
    je no_input2          ; 跳转到 no_input 处理

    ; Prompt for new book price
    lea dx, newLine
    mov ah, 09h
    int 21h

    ; 校验输入是否为有效的价格
validate_price:
    lea si, [input+2]   ; 忽略输入长度的第一个字节
    mov cl, [input+1]   ; 输入的实际长度
    mov bl, 0           ; 用来标记小数点是否已输入

price_check_loop:
    lodsb                ; 读取输入的每个字符到AL
    cmp al, 0Dh          ; 检查是否结束
    je valid_price       ; 如果是回车，跳转到valid_price
    cmp al, '.'          ; 如果是小数点
    je check_decimal
    cmp al, '0'
    jb invalid_input     ; 非数字，小于‘0’的字符是无效的
    cmp al, '9'
    ja invalid_input     ; 非数字，大于‘9’的字符是无效的
    loop price_check_loop
    jmp valid_price

check_decimal:
    cmp bl, 1            ; 如果已输入一个小数点
    je invalid_input      ; 无效输入
    mov bl, 1            ; 标记已输入小数点
    loop price_check_loop
    jmp valid_price

no_input2:
    jmp no_input3

invalid_input:
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, msgError1
    int 21h
    jmp promptNewBookPrice  ; 提示重新输入

valid_price:
    ; Get length of the input
    mov cl, [input+1]
    cmp cl, 10
    jle short copy_price
    mov cl, 10

copy_price:
    ; 根据用户选择复制价格
    cmp selectChoice, '1'
    je copy_price1
    cmp selectChoice, '2'
    je copy_price2
    cmp selectChoice, '3'
    je copy_price3
    jmp end_promptNewBookName

copy_price1:
    lea si, [input+2]
    lea di, price1
    jmp start_copy_price

copy_price2:
    lea si, [input+2]
    lea di, price2
    jmp start_copy_price

copy_price3:
    lea si, [input+2]
    lea di, price3

start_copy_price:
    mov bl, cl
copy_loop_price:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    dec bl
    jnz copy_loop_price

no_input3:
    ; End with '$'
    mov byte ptr [di], '$'

    jmp end_promptNewBookName
    ret
promptNewBookPrice ENDP

displayAll PROC
    cmp selectChoice, '1'
    jne check22
    jmp displayBook1
    
check22:
    cmp selectChoice, '2'
    jne check33
    jmp displayBook2

check33:
    cmp selectChoice, '2'
    jne exit
    jmp displayBook3

exit:
    jmp exitProgram

displayBook1:
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display1
    int 21h

    mov ah, 09h
    lea dx, book1
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display2
    int 21h

    mov ah, 09h
    lea dx, category1
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display3
    int 21h
    
    mov ah, 09h
    lea dx, price1
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, mainmenu
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    jmp displayAfter

displayBook2:
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display1
    int 21h

    mov ah, 09h
    lea dx, book2
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display2
    int 21h

    mov ah, 09h
    lea dx, category2
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display3
    int 21h
    
    mov ah, 09h
    lea dx, price2
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, mainmenu
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    jmp displayAfter

displayBook3:
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display1
    int 21h

    mov ah, 09h
    lea dx, book3
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display2
    int 21h

    mov ah, 09h
    lea dx, category3
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, display3
    int 21h
    
    mov ah, 09h
    lea dx, price3
    int 21h

    ; Print new line
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, mainmenu
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    jmp displayAfter
    ret
displayAll ENDP

displayAfter PROC
    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, display0
    int 21h

    lea dx, newLine
    mov ah, 09h
    int 21h

    ; Print main menu (-----------------------------------------------------)
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, menuafter1
    int 21h

    mov ah, 09h
    lea dx, book1
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, menuafter2
    int 21h

    mov ah, 09h
    lea dx, book2
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, menuafter3
    int 21h

    mov ah, 09h
    lea dx, book3
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    mov ah, 09h
    lea dx, mainmenu4
    int 21h
    
    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    ; Print main menu (-----------------------------------------------------)
    mov ah, 09h
    lea dx, mainmenu
    int 21h

    ; Print a new line
    lea dx, newLine
    mov ah, 09h
    int 21h

    jmp questionStar
    ret
displayAfter ENDP

END main
