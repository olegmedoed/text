.intel_syntax noprefix
# at the time the function starts
#   Parameter #N
#   ...
#   Parameter 2
#   Parameter 1
#   Return Address <--- (esp
#   Parameter #N      <--- N*4+4(ebp)
#   ...
# The first thing it does is save the current base pointer register, ebp, by
# doing pushl ebp. The base pointer is a special register used for accessing
# func params and local vars. Next, it copies the stack pointer to ebp by doing
# movl esp, ebp . This allows you to be able to access the function parameters
# as fixed indexes from the base pointer.
# Copying the stack pointer into the base pointer at the beginning of a func
# allows you to always know where your params are (and as we will see, local
# variables too), even while you may be pushing things on and off the stack.
# STACK FRAME (the stack frame consists of all of the stack vars used within a
# func, including params, local vars, and the return address)[and we use ebp
# like reference to stack frame, it always pnt to old ebp]
#   Parameter 2       <--- 12(ebp)
#   Parameter 1       <--- 8(ebp)
#   Return Address    <--- 4(ebp)
#   Old ebp           <--- (ebp)
#   Local Variable 1  <--- -4(ebp)
#   Local Variable 2  <--- -8(ebp) and (esp)
.section .data

.section .text
.globl _start
_start:
    push 4
    push 3
    call power
    add esp, 8
# exit:
    mov ebx, eax
    mov eax, 1
    int 0x80

#VARIABLES:
# ebx     - holds the base number
# ecx     - holds the power
# [ebp-4] - holds the current result
# eax     - is used fot tmp storage
.type power, @function
power:#  v-- save old ebp
    push ebp          #                     v--ebp
    mov ebp, esp      # [..|loc1|..|loc_last|old_ebp|caller|arg1|arg2|..]
    sub esp, 4        #            ^--esp
#   ^-- make gap for local vars, that since C place loc vars from bottom addres
#   to top, and allocate buffer for this purposes in advance.
#   I think it makes to next calls don't corrupt data in local vars, so we
#   reserve storage for them and sign it in such way
    mov ebx, [ebp+8]    # put first argument in ebx
    mov ecx, [ebp+12]   # put second arg in ecx
    mov [ebp-4], ebx    # store current result
power_loop_start:
# if power >= 1
    cmp ecx, 1          
    je end_power      # break if power < 1
    mov eax, [ebp-4]
    imul eax, ebx      # mul current result on base number
    mov [ebp-4], eax  # store the current res
    dec ecx           # decrease the power
    jmp power_loop_start
end_power:
    mov eax, [ebp-4]  # return val goes in eax
    mov esp, ebp      # esp = ebp
    pop ebp           # ebp = old_ebp, esp = caller
    ret


