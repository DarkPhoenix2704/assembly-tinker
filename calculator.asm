[bits 16]
[org 0x7c00]

mov bp, 0x9000
mov sp, bp

mov si, MSG_WELCOME
call print_string

calculator_loop:
    mov si, MSG_PROMPT
    call print_string
    
    call get_number
    push ax
    
    call get_char
    push ax
    
    call get_number
    mov bx, ax
    
    pop cx
    pop ax
    
    cmp cl, '+'
    je add_nums
    cmp cl, '-'
    je sub_nums
    cmp cl, '*'
    je mul_nums
    cmp cl, '/'
    je div_nums
    
    mov si, MSG_INVALID
    call print_string
    jmp calculator_loop
    
add_nums:
    add ax, bx
    jmp print_result
    
sub_nums:
    sub ax, bx
    jmp print_result
    
mul_nums:
    mul bx
    jmp print_result
    
div_nums:
    ; Clear DX for division
    xor dx, dx  
    div bx
; Result is kept in AX, remainder will be in DX register
    
print_result:
    call print_number
    mov si, MSG_NEWLINE
    call print_string
    jmp calculator_loop


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


get_char:
    mov ah, 0
    int 0x16
    ret


get_number:
    call get_char
    ; Convert ASCII to number
    sub al, '0'  
    ret


print_number:
    ; Convert number to ASCII
    add al, '0'  
    mov ah, 0x0e
    int 0x10
    ret

MSG_WELCOME db 'Welcome to Calculator OS!', 13, 10, 0
MSG_PROMPT db 'Enter calculation (e.g: 5+3): ', 0
MSG_INVALID db 'Invalid operator', 13, 10, 0
MSG_NEWLINE db 13, 10, 0

; Bootloader magic number
times 510-($-$$) db 0
dw 0xaa55