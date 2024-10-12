; A simple bootloader for our OS
[bits 16]
[org 0x7c00]

; Set up the stack
mov bp, 0x9000
mov sp, bp

; Print a welcome message
mov si, MSG_HELLO
call print_string

; Halt the system
cli
hlt

; Function to print a string
print_string:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

; db -> Define Byte Tells assembler to convert next data as bytes
MSG_HELLO db 'Welcome to our simple 0S!', 0,'India', 0

; Bootloader magic number
times 510-($-$$) db 0
dw 0xaa55


