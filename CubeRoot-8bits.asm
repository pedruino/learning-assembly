segment .data
    number dw 2
    sys_write equ 2h
    sys_read  equ 1h
    sys_exit  equ 4ch
segment .code
    start:
        mov ax, data
        mov ds, ax
        mov al, [number]
    main:
        mov dl, al        
        mul dl
	mul dl
        mov dl, al
        add dl, 48         ;ASCII
    show:	 
        mov ah, sys_write  ;print character
        int 21h       
    exit:
        mov ah, sys_read   ;wait a key from standard keyboard
        int 21h
        mov ah, sys_exit   ;exit after key pressed
        int 21h