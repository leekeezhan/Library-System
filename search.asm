.model small
.stack 100h
.data
    menu db "-*-*-Search Book-*-*- $"
    promptBkName db "Enter the name of the book: $"
    userSearch db 40 dup ('$')
    userChoice db ?
    book1 db "Journey to The West$"
    book2 db "Rich Dad Poor Dad$"
    book3 db "Avengers$" 

    bk1Desc db "Story of a Buddhist monk to India to collect scriptures.$"
    bk2Desc db "Advocates the importance of financial knowledges$"
    bk3Desc db "Marvel's comic. Superhero team that fights against evil.$"

    bk1Date db "Originally Published in 1592$"
    bk2Date db "Originally Published in 1997$"
    bk3Date db "First Appearance: 1963$"

    promptContinue db "Press enter to continue...$"
    promptTryAgain db " YES to try again, any key to exit: $"

    leftsName db "LEFT SEARCH BY NAME FUNCTION $"

    displayAllheading db "-*-*-Current Book List-*-*-$"

    yes db "YES$"
    no db "NO$"

    category1 db "Novel$" 
    category2 db "Self-Help$" 
    category3 db "Comic$" 

    author db "Author: $"
;authors name
    robert db "Robert Kiyosaki$"
    stan db "Stan Lee$"
    wuchengen db "Wu Cheng'en$" 

    choose db "Choice: $"
    allBook db "1. Display all book$"
    searchName db "2. Search by name $"
    exit db "(Any Key to Exit)$"
    left db "LEFT SEARCH MODULE $"
    category db "Category: $"
    bookName db "Book Name: $"
    description db "Description: $"
    moreMsg db "(See more details searching by name)$"

    one db "1. $"
    two db "2. $"
    three db "3. $"
    
    strings_equal_msg db "Book Found!$"
    strings_not_found_msg db "No result! Make sure the input is exactly correct/same$"
    copiedValue db 40 dup ('$')        ; Buffer to hold copied book value
    found db 0
    sameLength db 0
    spaces db "                 $"
    line db "-------------------------$"
    longline db "-------------------------------------------------------------------$"

.code
main proc
    ; Initialize DS to point to the data segment
    mov ax, @data
    mov ds, ax

    call Search_menu

Search_menu proc    
 ; Clear screen
    mov ah, 00
    mov al, 03
    int 10h
MainMenu:
    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, menu    ; Display word 'menu'
    mov ah, 09h
    int 21h

    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, allBook  ; Display display all book option message
    mov ah, 09h
    int 21h

    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, searchName  ; Display search by name option message
    mov ah, 09h
    int 21h

    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, exit        ;display exit option message
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, choose
    mov ah, 09h
    int 21h

    mov ah, 01h        ;input for user to select which function
    int 21h
    sub al, 30h
    mov userChoice, al   

    call newline

; Compare choices then jump
    mov cl, 1
    cmp userChoice , cl
    je call_to_allBook
    mov cl, 2
    cmp userChoice , cl
    je Search_Name
    jne exit_program

exit_program:
    call newline            ;display exit's message before ending the whole program
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, left
    mov ah, 09h
    int 21h
    jmp end_program

call_to_allBook:
    call displayAll
    call continue                                        

Search_Name:
    call newline
    
    ; Display prompt message
    lea dx, promptBkName
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 0Ah        ; DOS input function for strings
    lea dx, userSearch
    int 21h

    call newline

    call compare_book1     
    cmp found, 1
    je J_foundBK1

    call compare_book2
    cmp found, 1
    je J_foundBK2

    call compare_book3
    cmp found, 1
    je J_foundBK3

    call newline

    jmp Nothing_found     ;if none of the book's name above is match, jump to Nothing_found 

J_foundBK1:
    jmp D_foundBK1

J_foundBK2:
    jmp D_foundBK2

J_foundBK3:
    jmp D_foundBK3        

Nothing_found:                      ;prompt nothing found message, ask if user want to try again
    lea dx, strings_not_found_msg
    mov ah, 09h
    int 21h

    call newline

    lea dx, promptTryAgain
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 0Ah        ; DOS input function for strings
    lea dx, userSearch
    int 21h

    call TryAgain
    cmp found, 1       ;check if the use want to try again
    je jmp_to_SearchName

    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, leftsName
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, promptContinue
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    call Search_menu

jmp_to_SearchName:  ;if the user type yes, jump to Search_Name to retry
    jmp Search_Name

D_foundBK1:
    call newline                ;Prompt the corresponding books details

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h

    call newline

    lea dx, longline
    mov ah, 09h
    int 21h

    call newline

    lea dx, bookName
    mov ah, 09h
    int 21h

    lea dx, book1
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, category1
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, wuchengen
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk1Desc
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, bk1Date
    mov ah, 09h
    int 21h

    call newline

    call continue

D_foundBK2:
    call newline

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h

    call newline

    lea dx, longline
    mov ah, 09h
    int 21h

    call newline

    lea dx, bookName
    mov ah, 09h
    int 21h

    lea dx, book2
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, category2
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, robert
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk2Desc
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, bk2Date
    mov ah, 09h
    int 21h

    call newline

    call continue

D_foundBK3:
    call newline

    lea dx, strings_equal_msg
    mov ah, 09h
    int 21h

    call newline

    lea dx, longline
    mov ah, 09h
    int 21h

    call newline

    lea dx, bookName
    mov ah, 09h
    int 21h

    lea dx, book3
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, category3
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, stan
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk3Desc
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, bk3Date
    mov ah, 09h
    int 21h

    call newline

    call continue
Search_menu endp


;this function check the length of the input's string and the target string
Check_length proc     
xor cx, cx       ;clear the cx for counter  

find_length:
    ; Load a byte from the targeted string
    lodsb                       ; AL = [SI], SI++
    cmp al, '$'                 ; Check if it's the end of the string  
    je done                     ; If '$' is found, jump to done
    inc cx                      ; increment 
    jmp find_length              ; Repeat until '$' is found

done:
    mov al, [userSearch+1]
    cmp al, cl     ;compare the length of two strings, make sure it is the exact target string
    jne length_notSame

    mov sameLength, 1  ;return 1 to indicate the sameLenght is true
    ret

length_notSame:
    mov sameLength, 0  ;return 0 to indicate the sameLenght is false
    ret

Check_length endp    
    

Get_book_size PROC
    xor cx, cx       ;clear the cx for counter  

count_length:
    ; Load a byte from the targeted string
    lodsb                       ; AL = [SI], SI++
    cmp al, '$'                 ; Check if it's the end of the string  
    je storeLength                    ; If '$' is found, jump to done
    inc cx                      ; increment 
    jmp count_length              ; Repeat until '$' is found

storeLength:
ret
Get_book_size endp
    

;check if user want to try again or leave
TryAgain PROC
    lea si, yes  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_lengthY

    mov si, offset yes         ;move the target string into source
    mov di, offset copiedValue  ;move copiedVale to destination
    mov cx, 3

copy_loopT:
    mov al, [si]
    mov [di], al       ;copy the character from source to destination one by one
    inc si
    inc di
    loop copy_loopT

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 3            ; Number of characters to compare (can be adjusted)

    jmp compare_strings

diff_lengthY:
    jmp strings_not_found
TryAgain endp    

compare_book1 PROC
    lea si, book1  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length1

    lea si, book1           ;load book1 into si
    call Get_book_size      ;load the size of book1 into cx

    mov si, offset book1
    mov di, offset copiedValue

copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    dec cl
    jnz copy_loop

    lea si, book1    
    call Get_book_size  ;load the length into cx

    mov si, offset book1
    mov di, offset copiedValue

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue

    jmp compare_strings

diff_length1:
    jmp strings_not_found

compare_book1 endp    

compare_book2 proc
    lea si, book2  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length2

    
    lea si, book2
    call Get_book_size

    mov si, offset book2
    mov di, offset copiedValue

copy_loop2:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop2

    lea si, book2
    call Get_book_size

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue   

    jmp compare_strings

diff_length2:
    jmp strings_not_found

compare_book2 endp    

compare_book3 PROC
    lea si, book3  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length3

    lea si, book3
    call Get_book_size  ;load the length into cx

    mov si, offset book3
    mov di, offset copiedValue

copy_loop3:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop3

    lea si, book3
    call Get_book_size  ;load the length to loop into cx

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string; 

    jmp compare_strings

diff_length3:
    jmp strings_not_found
compare_book3 endp    

;compare string function
compare_strings:
compare_each_char:
    lodsb                     ; Load byte at DS:SI into AL and increment SI
    call to_lowercase         ; Convert AL to lowercase (if it's an uppercase letter)
    mov bl, [di]              ; Load byte from targeted string into BL
    call to_lowercase_bl      ; Convert BL to lowercase (if it's an uppercase letter)
    cmp al, bl                ; Compare AL (input char) with BL (book char)
    jne strings_not_found   ; If not equal, jump to strings_not_found
    cmp al, '$'       ; Check if it is the end of input string   
    je strings_equal  ; jump to strings_equal if it is
    cmp bl, '$'         ; Check if it is the end of book string
    je strings_equal    ; jump to strings_equal if it is
    inc di                  ; Increment DI to point to the next character
    loop compare_each_char    
    
strings_equal:      ;return 1 to indicate that the strings are equal
    mov found, 1
    ret

strings_not_found:  ;return 0 to indicate that the strings are not equal
    mov found, 0
    ret
 

;convert input to lowercase
to_lowercase proc
    ; Converts the character in AL to lowercase if it's uppercase
    cmp al, 'A'                ; Check if AL(input) >= 'A'
    jl not_uppercase           ; If less, it's not uppercase
    cmp al, 'Z'                ; Check if AL <= 'Z'
    jg not_uppercase           ; If greater, it's not uppercase
    add al, 32                 ; Convert to lowercase by adding 32
not_uppercase:
    ret
to_lowercase endp

;converts search targets/variables to lowercase
to_lowercase_bl proc
    ; Converts the character in BL to lowercase if it's uppercase
    cmp bl, 'A'                ; Check if BL(targeted string) >= 'A'
    jl not_uppercase_bl         ; If less, it's not uppercase
    cmp bl, 'Z'                ; Check if BL <= 'Z'
    jg not_uppercase_bl         ; If greater, it's not uppercase
    add bl, 32                 ; Convert to lowercase by adding 32
not_uppercase_bl:
    ret
to_lowercase_bl endp

newline PROC
    mov ah, 02h
    mov dl, 0Dh  ; carriage return
    int 21h
    mov dl, 0Ah  ; line feed
    int 21h
    ret
newline ENDP

displayAll PROC
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, displayAllheading
    mov ah, 09h
    int 21h

    call newline
    
    lea dx, one
    mov ah, 09h
    int 21h

    lea dx, book1
    mov ah, 09h
    int 21h

    call newline

    lea dx, two
    mov ah, 09h
    int 21h

    lea dx, book2
    mov ah, 09h
    int 21h

    call newline

    lea dx, three
    mov ah, 09h
    int 21h

    lea dx, book3
    mov ah, 09h
    int 21h

    call newline
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, moreMsg
    mov ah, 09h
    int 21h

    call newline

    ret
displayAll ENDP

continue proc
    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, promptContinue
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    call Search_menu    
continue endp    


end_program:
    mov ah, 4Ch                ; Exit to DOS
    int 21h
main endp
end main
