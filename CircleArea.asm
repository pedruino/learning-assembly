segment .data
    radius dw 3
    pi     dw 3
    sys_write equ 02h ;print character
    sys_read  equ 01h ;read char from standard keyboard
    sys_exit  equ 4ch ;exit after key pressed
segment .code
    start:
        mov ax, data
        mov ds, ax
        mov ax, [radius]
    main:
        mov bx, ax
        mul bx
        mov bx, [pi] 
        mul bx
        mov dx, ax
    show:
        mov ah, sys_write
        int 21h
    exit:
        mov ah, sys_read
        int 21h
        mov ah, sys_exit
        int 21h