.model small
    CR                  equ 0dh ;carriage return (13)
    LF                  equ 0ah ;line feed (10)
    SYS_OPENFILE        equ 3Dh
    SYS_READFILE        equ 3Fh
    SYS_CLOSEFILE       equ 3Eh
    FILEACCESS_READ     equ 00h
    NULL                equ 0h
    CONTACT_SEPARATOR   equ 3Ah ;":"
    BUFFER_LENGTH       equ 255d
    CRITERIA_MAX_LENGTH equ 100d
    TAB                 equ 09h
data segment
    filename            db "C:\database.txt", 0h ;path to database.txt (format => NAME : NUMBER)
    handle              dw 0
    buffer              db 255 dup(0)

    OpenFileException   db CR,LF,"|| Oops.. ||",CR, LF,"Error opening file. Check if file does not exist or permission is denied.",CR, LF, "$"
    ReadFileException   db CR,LF,"|| Oops.. ||",CR, LF,"Error opening file for reading. File being locked by another process.",CR, LF, "$"

    msg_entry           db CR, LF,"Looking for someone specific? (Press ENTER to find).", CR, LF, "$"
    msg_searching       db CR, LF,"Searching",85h, CR, LF, "$"
    msg_search_failed   db CR, LF,"Sorry =(", CR, LF,"The contact you are looking for cannot be found.",CR, LF,"$"
    msg_search_succeed  db CR, LF,"Contact found :V", CR, LF, "$"
    msg_search_again    db CR, LF,"Do you want to search for another contact?[y,n]","$"

    criteria            db 100 dup(0)
    criteria_length     dw 0
    ;extra
    header              db "  ==============================  ",CR,LF,"|| Engenharia da Computação:    ||",CR,LF,"|| Pedro Escobar                ||",CR,LF,"|| Trabalho Grau B              ||",CR,LF,"  ==============================  ",CR,LF,"$"
    line_divisor        db CR,LF,"  ===============================================  ",CR,LF, "$"
    label_name          db TAB, "Name: ", "$"
    label_phone         db TAB, "Phone: ", "$"
code segment
    start:
        mov ax, data
        mov ds, ax

    main:
        call CHANGE_COLOR    ;s? para "brincar"
        call File_OpenRead   ;chama procedure para abrir o arquivo como leitura

    welcome:
        lea dx, header
        mov ah, 09h
        int 21h

    entry:
        lea dx, msg_entry
        mov ah, 09h
        int 21h

        lea si, criteria
        mov cx, CRITERIA_MAX_LENGTH

    read_char:
        mov ah, 01h
        int 21h
        cmp al, CR
        je validate
        mov [si], al
        inc si
        loop read_char

    validate:               ;valida se o buffer(arquivo) ou o texto procurado ? nulo
        lea si, criteria    ;texto digitado
        lea di, buffer      ;buffer (arquivo)

        mov dl, [si]
        cmp dl, NULL
        je search_failed

        mov dl, [di]
        cmp dl, NULL
        je search_failed

    ;Para que a pesquisa case insentive o arquivo deve estar salvo em lowercase,
    ;sendo assim ? necess?rio verificar cada caracter e converter se necess?rio.
    validate_lowercase:    ;se o c?digo chegou aqui, na primeira vez ele N?O pode ser NULL, e
        mov dl, [si]
        cmp dl, NULL       ;se for NULL significa que ele j? validou todo o texto digitado e vai para pesquisa
        je search
        mov dl, [si]
                           ;come?a a validar se o caracter do texto digitado ? uppercase
    check_upper_A:         ;valida o range >= A
        cmp dl, 'A'
        jae check_upper_Z  ;se >= A ent?o valida se ? <= Z
        inc si
        jmp validate_lowercase

    check_upper_Z:              ;valida o range <= Z
        cmp dl, 'Z'
        jbe convert_lowercase  ;se >= A && <= Z ent?o precisa ser convertido para lowercase
        inc si
        jmp validate_lowercase

    convert_lowercase:
        add dl, 20h            ;convers?o para lowercase, posi??o na tabela ASCII
        mov [si], dl
        inc si
        jmp validate_lowercase

    search:
        lea si, criteria
        lea dx, msg_searching
        mov ah, 09h
        int 21h
                                ;Aqui, o texto procurado N?O pode ser nulo
    compare:
        mov dl, [si]            ;criteria
        cmp dl, NULL            ;se NULL, significa que chegou no fim do texto, sem interrup??es = ENCONTROU
        je search_succeed

        mov bl, [di]            ;buffer
        cmp bl, NULL            ;se NULL, significa que chegou no fim do arquiv = N?O ENCONTROU
        je search_failed

        cmp dl, bl
        jne restart_compare     ;se forem diferentes, reinicia o indice do texto procurado

        inc si
        inc di
        jmp compare             ;loop at? que tenha sucesso ou falha

    restart_compare:            ;reinicia o indice do texto procurado e volta a comparar
        lea si, criteria
        inc di
        jmp compare

    search_failed:              ;no caso de falha(n?o encontrado), exibe uma mensagem e fecha o arquivo
        lea dx, msg_search_failed
        mov ah, 09h
        int 21h
        jmp close_file

    search_succeed:             ;no caso de sucesso(encontrado), come?a exibir de forma destacada
        lea dx, line_divisor    ;imprime uma linha apenas para efeito visual
        mov ah, 09h
        int 21h

    ;Presumindo que cada linha do arquivo, possui apenas um registro.
    ;Ex: pedro escobar:(54) 9221-8532
    back_start_contact:         ;volta o indice do arquivo, at? encontrar o inicio da linha(registro)
        mov dl, [di]
        cmp dl, LF              ;fim da linha anterior
        je print_label_name
        cmp dl, NULL            ;inicio do arquivo
        je print_label_name
        dec di
        jmp back_start_contact

    print_label_name:           ;exibe o label-> "Nome:"
        lea dx, label_name
        mov ah, 09h
        int 21h
        inc di

    print_contact:                  ;exibe o contato de fato
        mov dl, [di]
        cmp dl, CONTACT_SEPARATOR   ;se == ":" (separador usado no formato "nome:telefone")
        je print_label_phone
        cmp dl, CR                  ;fim da linha do registro
        je print_contact_completed
        cmp dl, NULL                ;fim do arquivo
        je print_contact_completed
        mov ah, 02h
        int 21h
        inc di
        jmp print_contact

    print_label_phone:              ;exibe o label-> "Phone:"
        mov dl, CR
        mov ah, 02h
        int 21h
        mov dl, LF
        mov ah, 02h
        int 21h
        lea dx, label_phone
        mov ah, 09h
        int 21h
        inc di
        jmp print_contact

    print_contact_completed:
        lea dx, line_divisor      ;imprime uma linha apenas para efeito visual
        mov ah, 09h
        int 21h

    close_file:                   ;fecha o arquivo
        mov ah, SYS_CLOSEFILE
        mov dx, [handle]
        int 21h
        jmp question

    question:                     ;pergunta se o usu?rio deseja procurar novamente
        lea dx, msg_search_again
        mov ah, 09h
        int 21h
        mov ah, 01h
        int 21h
        or al,  'y'               ;se for digitado mai?sculo, ent?o converte para min?sculo
        cmp al, 'y'               ;se o usu?rio digitar 'y' = (sim) : em lowercase
        jne exit                  ;se a resposta for diferente de 'y', ent?o termina a execu??o
        lea si, criteria

    ;se o usu?rio deseja refazer a pesquisa ? necess?rio limpar o vetor do texto digitado
    clear_criteria:
        mov dl, NULL
        mov [si], dl
        inc si
        mov dl, [si]
        cmp dl, NULL
        jne clear_criteria
        call Screen_Clear         ;chama a procedure para limpar a tela
        jmp main                  ;volta ao in?cio

    exit:                         ;termina a execu??o do programa
        mov dl, CR
        mov ah, 02h
        int 21h
        mov dl, LF
        mov ah, 02h
        int 21h
        mov ah, 01h
        int 21h
        mov ah, 04ch
        int 21h

    File_OpenRead proc           ;procedure para abrir o arquivo como leitura
    openfile:
        mov ah, SYS_OPENFILE
        lea dx, filename
        mov al, FILEACCESS_READ
        int 21h
        jc throw_OpenFileException
        mov [handle], ax

    read_file:
        mov ah, SYS_READFILE
        mov cx, BUFFER_LENGTH
        lea dx, buffer
        jc throw_ReadFileException
        mov bx, [handle]
        int 21h

    successful:
       ret

    throw_OpenFileException:
        lea dx, OpenFileException
        mov ah, 09h
        int 21h
        jmp exit

    throw_ReadFileException:
        lea dx, ReadFileException
        mov ah, 09h
        int 21h
        jmp exit

    File_OpenRead endp

    File_ShowContent proc
        lea si, buffer
        mov cx, BUFFER_LENGTH
        print:
            mov dl, [si]
            cmp dl, NULL
            je exit
            mov ah, 02h
            int 21h
            inc si
            loop print
        ret
    File_ShowContent endp

    Screen_Clear proc
        mov ax, 00h         ; select mode function
        mov al, 03h         ; 80x25 color text
        int 10h
        ret
    Screen_Clear endp

    CHANGE_COLOR proc
        MOV AH, 06h    ; Scroll up function
        XOR AL, AL     ; Clear entire screen
        XOR CX, CX     ; Upper left corner CH=row, CL=column
        MOV DX, 184FH  ; lower right corner DH=row, DL=column
        MOV BH, 070h    ; YellowOnBlue
        INT 10H
        ret
    CHANGE_COLOR endp
