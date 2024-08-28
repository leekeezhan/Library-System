.model small
.stack 100h
.data
menu db "Search Book $"

num db 1

book1 db "Journey to The West $"
book2 db "Frankenstein $"
book3 db "Dune $"
book4 db "Harry Potter and the Cursed Child $"
book5 db "Rich Dad Poor Dad $"
book6 db "Atomic Habits $"
book7 db "Second Chance $"
book8 db "One Piece $"
book9 db "Jujutsu Kaisen $"
book10 db "Avengers $"

novel db "Novel $"
selfHelp db "Self-Help $"
comic db "Comic $"


exit db "4. Exit $"
choose db "Choice: $"
userSearch db ?
other db "Other $"
search db "Search by name: $"

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

; Display word 'menu'
    lea dx, menu
    mov ah, 09h
    int 21h

; New line
    lea dx, newline
    mov ah, 09h
    int 21h




main endp
end main