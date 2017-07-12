segment .data
    vector resb 5
    EQU ENTER_KEY 13
segment .code
    startup:
        MOV Ax, data
        MOV DS, Ax
        
        MOV SI, vector
        MOV Cx, 0
        MOV Dx, 0
    
    readKey:
        MOV Ah, 1
        INT 21h
        
        CMP Al, [ENTER_KEY] 
        JE calculate

        SUB Al, 48 ;ASCII(48) transforma em decimal
        MOV [SI], Al
        INC SI
        INC Cx
        JMP readKey

     calculate:
         DEC SI           