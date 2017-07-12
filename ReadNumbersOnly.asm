segment .data
    numbers   db 6
    length    equ 5;
    sys_write_s equ 09h ;print character
    sys_write equ 02h ;print character
    sys_read  equ 01h ;read character from keyboard with echo
    sys_exit  equ 4ch ;exit after key pressed
    zero      equ 30h
    nine      equ 39h
    CR        equ 0dh ;carriage return (13)
    LF        equ 0ah ;line feed (10)
segment .code
    start:
        mov ax, data
        mov ds, ax
        mov si, numbers
        mov cx, length
        mov dx, 0
    read_key:
        mov ah, sys_read
        int 21h

        cmp al, zero
        jb read_key
        cmp al, nine
        ja read_key

        mov [si], al
        inc si
        loop read_key
    newline:
        mov dl, LF
        mov ah, sys_write
        int 21h
        mov dl, CR
        mov ah, sys_write
        int 21h

    print:
        mov [si], byte '$'
        mov ah, 09h
        mov dx, numbers
        int 21h

    exit:
        mov ah, sys_read
        int 21h
        mov ah, sys_exit
        int 21h
