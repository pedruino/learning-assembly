segment .data
    string: db 6
    length    equ 6;
    sys_write_s equ 09h ;print string
    sys_write equ 02h ;print character
    sys_read  equ 01h ;read character from keyboard with echo
    sys_exit  equ 4ch ;exit after key pressed
    ENTER_KEY equ 13
    upper_A   equ 65  ; 41h
    upper_Z   equ 90  ; 5A
    lower_a   equ 97  ; 61
    lower_z   equ 122 ; 7A
segment .code
    start:
        mov ax, data
        mov ds, ax
        mov si, string
        mov cx, length
        mov dx, 0

    read_key:
        mov ah, sys_read
        int 21h
        mov [si], al
        inc si
        loop read_key

    test_char:
        dec si
        inc cx

        cmp cx, length
        ja print

        mov bh, [si]

    check_upper:
        cmp bh, upper_Z
        ja check_lower
        cmp bh, upper_A
        jae upper_case
        jmp test_char

    check_lower:
        cmp bh, lower_a
        jb test_char
        cmp bh, lower_z
        jbe lower_case
        jmp test_char

    upper_case:
        inc dh
        jmp test_char

    lower_case:
        inc dl
        jmp test_char

    print:
        add dl, 48  ;para valores inferiores a 10
        mov ah, sys_write
        int 21h

        mov dl, dh
        add dl, 48  ;para valores inferiores a 10
        mov ah, sys_write
        int 21h
    exit:
        mov ah, sys_read
        int 21h
        mov ah, sys_exit
        int 21h
