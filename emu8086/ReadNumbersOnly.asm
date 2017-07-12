.model small
.data
    numbers     db 5 dup(?)
    length      equ 5;
    sys_write_s equ 09h ;print character
    sys_write   equ 02h ;print character
    sys_read    equ 01h ;read character from keyboard with echo
    sys_exit    equ 4ch ;exit after key pressed
    zero        equ 30h
    nine        equ 39h
    CR          equ 0dh ;carriage return (13)
    LF          equ 0ah ;line feed (10)
    msg1        db  LF, CR, "Smash face on keyboard and see result =) $"
    msg2        db  LF, CR, "Numbers typed: $"
    msg_exit    db  LF, CR, "Press any key to exit... $"
.code
    start:
        mov ax, @data
        mov ds, ax
        mov si, offset numbers
        mov cx, length
        mov dx, 0
    initial_msg:
        lea dx, [msg1]
        mov ah, 09h
        int 21h
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
    result_msg:
        lea dx, [msg2]
        mov ah, 09h
        int 21h
    print:
        mov [si], 24h
        mov dx, offset numbers
        mov ah, sys_write_s
        int 21h
    newline:
        mov dl, LF
        mov ah, sys_write
        int 21h

        mov dl, CR
        mov ah, sys_write
        int 21h
    exit:
        lea dx, [msg_exit]
        mov ah, 09h
        int 21h
        mov ah, sys_read
        int 21h
        mov ah, sys_exit
        int 21h
