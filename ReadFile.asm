segment data
    filename            db "C:\filename.txt" ; preferred full path filename
    handle              dw 0
    buffer              resb 100
    errorMsg            db "Error opening/reading file.", "$"
segment code
    ..start:
        mov ax, data
        mov ds, ax

    open:
        mov ah, 3Dh
        mov dx, filename
        mov al, 0
        int 21h
        jc error
        mov [handle], ax

    read:
        mov ah, 3fh
        mov cx, 100
        mov dx, buffer
        jc error
        mov bx, [handle]
        int 21h
        mov si, buffer
        mov cx, 100

    print:
        mov dl, [si]
        mov ah, 02h
        int 21h
        inc si
        loop print

    close:
        mov ah, 3eh
        mov dx, [handle]
        int 21h
        jmp exit

    error:
        mov dx, errorMsg
        mov ah, 09h
        int 21h
        jmp exit

    exit:
        mov ah, 01h
        int 21h
        mov ah, 04ch
        int 21h
