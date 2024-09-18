.model small
.stack 100h
.data
    menu db "-*-*-Search Book-*-*- $"
    promptBkName db "Enter the name of the book: $"
    userSearch db 40 dup ('$')
    userChoice db ?
    book1 db "Journey to The West$"
    book2 db "Frankenstein$"
    book3 db "Dune$"
    book4 db "Harry Potter$"
    book5 db "Rich Dad Poor Dad$"
    book6 db "Atomic Habits$"
    book7 db "Second Chance$"
    book8 db "One Piece$"
    book9 db "Jujutsu Kaisen$"
    book10 db "Avengers$" 
    book11 db "Avengers2$"

    bk1Desc db "Story of a Buddhist monk to India to collect scriptures.$"
    bk2Desc db "A scientist creates a monster and the consequences of his actions.$"
    bk3Desc db "A science fiction empire story set in a desert planet.$"
    bk4Desc db "A young wizard and his friends on a quest to defeat a dark lord.$"
    bk5Desc db "Advocates the importance of financial knowledges$"
    bk6Desc db "Advocates the importance of habits and how to build them.$"
    bk7Desc db "Personal finance book$"
    bk8Desc db "A manga series about pirates finding the ultimate treasure.$"
    bk9Desc db "A manga series about sorcerers fighting against curses.$"
    bk10Desc db "Marvel's comic. Superhero team that fights against evil.$"
    bk11Desc db "Sequel of Marvel's Avengers, Age of Ultron$"

    promptContinue db "Press enter to continue...$"
    promptTryAgain db " YES to try again, any key to exit: $"

    leftsName db "LEFT SEARCH BY NAME FUNCTION $"
    leftsCat db "LEFT SEARCH BY CATEGORY FUNCTION $"

    yes db "YES$"
    no db "NO$"

    novel db "Novel$" 
    selfHelp db "Self-Help$" 
    comic db "Comic$" 

    author db "Author: $"
;authors name
    robert db "Robert Kiyosaki$"
    gege db "Gege Akutami$"
    jk db "J.K. Rowling$"
    james db "James Clear$"   ;atomic habits
    mary db "Mary Shelly$"   ;frankenstein
    stan db "Stan Lee$"
    frank db "Frank Herbert$"  ;dune
    eiichiro db "Eiichiro Oda$" ;one piece
    wuchengen db "Wu Cheng'en$" 

    choose db "Choice: $"
    allBook db "1. Display all book$"
    searchName db "2. Search by name $"
    searchCategory db "3. Search by category $"
    exit db "(Any Key to Exit)$"
    left db "LEFT SEARCH FUNCTION $"
    promptCat db "Enter the category(Novel, Comic, Self-Help): $"
    category db "Category: $"
    bookName db "Book Name: $"
    description db "Description: $"

    one db "1. $"
    two db "2. $"
    three db "3. $"
    four db "4. $"
    five db "5. $"
    six db "6. $"
    seven db "7. $"
    eight db "8. $"
    nine db "9. $"
    ten db "10. $"
    eleven db "11. $"

    strings_equal_msg db "Book Found!$"
    strings_not_found_msg db "No result! Make sure the input is exactly correct/same$"
    copiedValue db 40 dup ('$')        ; Buffer to hold copied book value
    found db 0
    sameLength db 0
    space db "'s $"
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
    lea dx, menu    ; Display word 'menu'
    mov ah, 09h
    int 21h

    call newline

    lea dx, allBook  ; Display display all book option message
    mov ah, 09h
    int 21h

    call newline

    lea dx, searchName  ; Display search by name option message
    mov ah, 09h
    int 21h

    call newline

    lea dx, searchCategory  ;display search by category option message
    mov ah, 09h
    int 21h

    call newline

    lea dx, exit        ;display exit option message
    mov ah, 09h
    int 21h

    call newline

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
    mov cl, 3
    cmp userChoice , cl
    je jmp_to_Search_Category
    jne exit_program

exit_program:
    call newline            ;display exit's message before ending the whole program

    lea dx, left
    mov ah, 09h
    int 21h
    jmp end_program

jmp_to_Search_Category:
    jmp Search_Category

call_to_allBook:
    call displayAll
    jmp continue                                        

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

    call compare_book4
    cmp found, 1
    je J_foundBK4

    call compare_book5
    cmp found, 1
    je J_foundBK5
                                            ;compare all book's name
    call compare_book6
    cmp found, 1
    je J_foundBK6

    call compare_book7
    cmp found, 1
    je J_foundBK7

    call compare_book8
    cmp found, 1
    je J_foundBK8

    call compare_book9
    cmp found, 1
    je J_foundBK9

    call compare_book10
    cmp found, 1
    je J_foundBK10

    call compare_book11
    cmp found, 1
    je J_foundBK11

    call newline

    jmp Nothing_found     ;if none of the book's name above is match, jump to Nothing_found 

J_foundBK1:
    jmp D_foundBK1

J_foundBK2:
    jmp D_foundBK2

J_foundBK3:
    jmp D_foundBK3

J_foundBK4:
    jmp D_foundBK4

J_foundBK5:
    jmp D_foundBK5

J_foundBK6:
    jmp D_foundBK6

J_foundBK7:
    jmp D_foundBK7

J_foundBK8:
    jmp D_foundBK8

J_foundBK9:
    jmp D_foundBK9

J_foundBK10:
    jmp D_foundBK10   

J_foundBK11:
    jmp D_foundBK11        

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

    lea dx, novel
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

    jmp continue

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

    lea dx, novel
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, mary
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

    jmp continue

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

    lea dx, novel
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, frank
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

    jmp continue
    
D_foundBK4:
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

    lea dx, book4
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, novel
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, jk
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk4Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK5:
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

    lea dx, book5
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, selfHelp
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

    lea dx, bk5Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK6:
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

    lea dx, book6
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, selfHelp
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, james
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk6Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK7:
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

    lea dx, book7
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, selfHelp
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

    lea dx, bk7Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK8:
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

    lea dx, book8
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, comic
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, eiichiro
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk8Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK9:
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

    lea dx, book9
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, comic
    mov ah, 09h
    int 21h

    call newline

    lea dx, author
    mov ah, 09h
    int 21h

    lea dx, gege
    mov ah, 09h
    int 21h

    call newline

    lea dx, description
    mov ah, 09h
    int 21h

    lea dx, bk9Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK10:
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

    lea dx, book10
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, comic
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

    lea dx, bk10Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundBK11:
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

    lea dx, book11
    mov ah, 09h
    int 21h

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

    lea dx, comic
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

    lea dx, bk11Desc
    mov ah, 09h
    int 21h

    call newline

    jmp continue    

;search by category function
Search_Category:
    call newline
    
    ; Display prompt 
    lea dx, promptCat
    mov ah, 09h
    int 21h

    ; Get user input
    mov ah, 0Ah        ; DOS input function for strings
    lea dx, userSearch
    int 21h        

    call newline

    call compare_cat_novel   ;compare all category
    cmp found, 1
    je J_foundNovel

    call compare_cat_selfHelp
    cmp found, 1
    je J_foundSelfHelp

    call compare_cat_comic
    cmp found, 1
    je J_foundComic

   call newline

    jmp Nothing_foundCategory   ;if all category above aren't matched, jump to Nothing_foundCategory

J_foundNovel:
    jmp D_foundNovel

J_foundSelfHelp:
    jmp D_foundSelfHelp

J_foundComic:
    jmp D_foundComic

Nothing_foundCategory:              ;prompt no category, ask the user to try again
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

    call TryAgain      ;check if the use want to try again
    cmp found, 1
    je jmp_to_SearchCategory

    call newline

    lea dx, spaces
    mov ah, 09h
    int 21h

    lea dx, leftsCat
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

jmp_to_SearchCategory:     ;if user want to try again, jump back to Search_Category to retry
    jmp Search_Category

D_foundNovel:                   ;display the corresponding results
    call newline
    call newline

    lea dx, novel
    mov ah, 09h
    int 21h

    call newline

    lea dx, category
    mov ah, 09h
    int 21h

    call newline

    lea dx, line
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

    lea dx, four
    mov ah, 09h
    int 21h

    lea dx, book4
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundSelfHelp:
    call newline
    call newline

    lea dx, selfHelp
    mov ah, 09h
    int 21h

    lea dx, space
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

   call newline

    lea dx, line
    mov ah, 09h
    int 21h

    call newline

    lea dx, one
    mov ah, 09h
    int 21h

    lea dx, book5
    mov ah, 09h
    int 21h

    call newline

    lea dx, two
    mov ah, 09h
    int 21h

    lea dx, book6
    mov ah, 09h
    int 21h

    call newline

    lea dx, three
    mov ah, 09h
    int 21h

    lea dx, book7
    mov ah, 09h
    int 21h

    call newline

    jmp continue

D_foundComic:
    call newline
    call newline

    lea dx, comic
    mov ah, 09h
    int 21h

    lea dx, space
    mov ah, 09h
    int 21h

    lea dx, category
    mov ah, 09h
    int 21h

   call newline

    lea dx, line
    mov ah, 09h
    int 21h

    call newline

    lea dx, one
    mov ah, 09h
    int 21h

    lea dx, book8
    mov ah, 09h
    int 21h

    call newline

    lea dx, two
    mov ah, 09h
    int 21h

    lea dx, book9
    mov ah, 09h
    int 21h

    call newline

    lea dx, three
    mov ah, 09h
    int 21h

    lea dx, book10
    mov ah, 09h
    int 21h

    call newline

    lea dx, four
    mov ah, 09h
    int 21h

    lea dx, book11
    mov ah, 09h
    int 21h

    call newline

    jmp continue
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

    mov si, offset book1
    mov di, offset copiedValue
    mov cx, 19

copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 19              ; Number of characters to compare (can be adjusted)

jmp compare_strings

diff_length1:
    jmp strings_not_found

compare_book1 endp    

compare_book2 proc
    lea si, book2  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length2

    mov si, offset book2
    mov di, offset copiedValue
    mov cx, 12

copy_loop2:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop2

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 12              ; Number of characters to compare (can be adjusted)

jmp compare_strings

diff_length2:
    jmp strings_not_found

compare_book2 endp    

compare_book3 PROC
    lea si, book3  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length3

    mov si, offset book3
    mov di, offset copiedValue
    mov cx, 4

copy_loop3:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop3

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 4             ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length3:
    jmp strings_not_found
compare_book3 endp    

compare_book4 PROC
    lea si, book4  ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length4

    mov si, offset book4
    mov di, offset copiedValue
    mov cx, 12

copy_loop4:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop4

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 12            ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length4:
    jmp strings_not_found
compare_book4 endp    

compare_book5 PROC
    lea si, book5 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length5

    mov si, offset book5
    mov di, offset copiedValue
    mov cx, 17

copy_loop5:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop5

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 17            ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length5:
    jmp strings_not_found
compare_book5 endp    

compare_book6 PROC
    lea si, book6 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length6

    mov si, offset book6
    mov di, offset copiedValue
    mov cx, 13

copy_loop6:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop6

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 13            ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length6:
    jmp strings_not_found
compare_book6 endp    

compare_book7 PROC
    lea si, book7 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length7

    mov si, offset book7
    mov di, offset copiedValue
    mov cx, 13

copy_loop7:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop7

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 13            ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length7:
    jmp strings_not_found
compare_book7 endp  

compare_book8 PROC
    lea si, book8 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length8

    mov si, offset book8
    mov di, offset copiedValue
    mov cx, 9

copy_loop8:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop8

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 9           ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length8:
    jmp strings_not_found
compare_book8 endp    

compare_book9 PROC
    lea si, book9 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length9

    mov si, offset book9
    mov di, offset copiedValue
    mov cx, 14

copy_loop9:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop9

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 14           ; Number of characters to compare (can be adjusted)

    jmp compare_strings
diff_length9:
    jmp strings_not_found
compare_book9 endp   

compare_book10 PROC
    lea si, book10 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length10

    mov si, offset book10
    mov di, offset copiedValue
    mov cx, 8

copy_loop10:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop10

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 8           ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length10:
    jmp strings_not_found
compare_book10 endp    

compare_book11 PROC
    lea si, book11 ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_length10

    mov si, offset book11
    mov di, offset copiedValue
    mov cx, 9

copy_loop11:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop11

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 9           ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_length11:
    jmp strings_not_found
compare_book11 endp    

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
    inc di                    ; Increment DI to point to the next character
    loop compare_each_char    
    
strings_equal:      ;return 1 to indicate that the strings are equal
    mov found, 1
    ret

strings_not_found:  ;return 0 to indicate that the strings are not equal
    mov found, 0
    ret

compare_cat_novel PROC
    lea si, novel ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_lengthN

    mov si, offset novel        ;move novel into si
    mov di, offset copiedValue   
    mov cx, 5

copy_loop_novel:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop_novel

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 5            ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_lengthN:
    jmp strings_not_found
compare_cat_novel endp        

compare_cat_selfHelp PROC
    lea si, selfHelp ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_lengthS

    mov si, offset selfHelp       ;move selfHelp into si
    mov di, offset copiedValue   
    mov cx, 9

copy_loop_selfHelp:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop_selfHelp

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 9           ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_lengthS:
    jmp strings_not_found
compare_cat_selfHelp endp     

compare_cat_comic PROC
    lea si, comic ;move the target string into si to check the length with the input

    call Check_length
    cmp sameLength, 1  ;if length are not same, jump to diff_length
    jne diff_lengthC

    mov si, offset comic       ;move comic into si
    mov di, offset copiedValue   
    mov cx, 5

copy_loop_comic:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop_comic

    ; Set up pointers for comparison
    lea si, userSearch + 2  ; SI points to user input (after length byte and return)
    lea di, copiedValue           ; DI points to target string
    mov cx, 5           ; Number of characters to compare (can be adjusted)

jmp compare_strings
diff_lengthC:
    jmp strings_not_found
compare_cat_comic endp   

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

    lea dx, four
    mov ah, 09h
    int 21h

    lea dx, book4
    mov ah, 09h
    int 21h

    call newline

    lea dx, five
    mov ah, 09h
    int 21h

    lea dx, book5
    mov ah, 09h
    int 21h

    call newline

    lea dx, six
    mov ah, 09h
    int 21h

    lea dx, book6
    mov ah, 09h
    int 21h

    call newline

    lea dx, seven
    mov ah, 09h
    int 21h

    lea dx, book7
    mov ah, 09h
    int 21h

    call newline

    lea dx, eight
    mov ah, 09h
    int 21h

    lea dx, book8
    mov ah, 09h
    int 21h

    call newline

    lea dx, nine
    mov ah, 09h
    int 21h

    lea dx, book9
    mov ah, 09h
    int 21h

    call newline

    lea dx, ten
    mov ah, 09h
    int 21h

    lea dx, book10
    mov ah, 09h
    int 21h

    call newline

    lea dx, eleven
    mov ah, 09h
    int 21h

    lea dx, book11
    mov ah, 09h
    int 21h

    call newline
    ret
displayAll ENDP

continue:
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

end_program:
    mov ah, 4Ch                ; Exit to DOS
    int 21h
main endp
end main
