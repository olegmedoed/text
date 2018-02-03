.intel_syntax noprefix

.section .data
msg: .ascii "compute the fib\n"
.section .bss
.lcomm print_buf, 4

.section .text
.globl _start
_start:
#   'write' syscall
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 16
    int 0x80

    push 40
    call fib

    mov [print_buf], eax  # move res in print_buf variable
    mov ecx, print_buf
    mov edx, 4      # size of buffer
    mov eax, 4      # 'write' syscall
    mov ebx, 1      # to stdout
    int 0x80

    mov ebx, 0
    mov eax, 1
    int 0x80

.type fib, @function
fib:
    push ebp
    mov ebp, esp
#   we no need to allocate storage for loc_vars in advance

#   if n < 2
    cmp dword ptr [ebp+8], 2
    jge fib_rec
#   then 1
    mov eax, 1
    jmp fib_end
#   else fib(n-1) + fib(n-2)
fib_rec:
    mov eax, dword ptr [ebp+8]  # move 'n' in eax
    sub eax, 1
    push eax
    call fib
    push eax  # we like allocate storage for loc_var

    mov eax, dword ptr [ebp+8]
    sub eax, 2
    push eax
    call fib
    pop ebx
    add eax, ebx

fib_end:
    mov esp, ebp
    pop ebp     # ebp is now old_ebp again, and esp point on caller
    ret
