segment .data
    dividend dw 4
    divisor  dw 2
    sys_write equ 2h  ;print character
    sys_read  equ 1h  ;wait a key from standard keyboard
    sys_exit  equ 4ch ;exit after key pressed
segment .code
    start:                
        mov ax, data
        mov ds, ax              
        mov ax, dividend
        mov bx, divisor                  
    main:         
        div bx
        mov dx, ax        
    show:    
        mov ah, sys_write  
        int 21h       
    exit:
        mov ah, sys_read   
        int 21h
        mov ah, sys_exit   
        int 21h