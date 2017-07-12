segment .data
	texto db 'Hello World!', '$'

segment .code
    start:
        mov ax, data
	mov ds, ax
	mov dx, texto

	mov ah, 9	;imprime uma string na tela, quando encontrar o caracter '$'
	int 21h	        ;executa a rotina colocada no ah (9)