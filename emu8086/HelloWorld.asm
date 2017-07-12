.model small
data segment
	msg db "Hello World!", "$"

code segment
  main:
    mov ax, data
    mov ds, ax
    lea dx, msg

    mov ah, 09h
    int 21h
