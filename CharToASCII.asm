section .data
    numbers resb 5 ;reserva 5 enderecos de bytes
    
section .code
    start:
        MOV Ax, data
        MOV DS, Ax        ;inicializa o registrador DS
        
        MOV BL, 10        ;inicializa o registrador (Base Low) com 10
        
        MOV Ax, 1245      ;inicializa o valor
        MOV Cx, 0         ;inicializa o contador
        MOV SI, numbers   ;iniciliza o si com o endereço inicial do vetor
    
    compare: 
        CMP Ax, 10        ;compara com o valor 10
        JB  show          ;testa se Ax < 10
        DIV BL            ;divide o valor de Ax/BL (16bits)/(8bits)
        INC Cx            ;incrementa 1 ao Cx
        ADD Ah, 48        ;transforma caractere correto
        MOV [SI], Ah      ;grava no vetor o caracter
        INC SI            ;incrementa SI
        MOV Ah, 0         ;limpa parte alta do Ax, onde estava o resto
        
    show:
        ADD AL, 48
        MOV [SI], AL    
        INC Cx
        
    print:
        MOV DL, [SI]      ;carregar em DL o conteúdo apontado por SI
        MOV Ah, 2
        INT 21h
        DEC SI
        LOOP print

    readKey:
        MOV Ah, 4ch       ;espera uma tecla
        INT 21h    
        
    exit:
        MOV Ah, 4ch
        INT 21h  