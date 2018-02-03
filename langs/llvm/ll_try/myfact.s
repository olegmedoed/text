.intel_syntax noprefix

#.text
#.globl fact
#.align 16
#.type fact,@function
#fact:
#    push ebp
#    mov ebp, esp
#    sub esp, 8      # make the gap for i32.res and i32.i
#
#    mov eax, dword ptr [ebp + 8]    # eax <- n
#    mov dword ptr [esp + 4], eax    # res = n
#    dec eax
#    mov dword ptr [esp], eax        # i = n-1
#
#.L.do:
#    cmp dword ptr [esp], 1          # i > 1
#    jle .L.done
#
#    mov eax, dword ptr [esp+4]
#    mul dword ptr [esp]         #; we don't care about high part of mul-tion
#    mov dword ptr [esp+4], eax  #; since c-lang behaves identically  when
#    dec dword ptr [esp]         #; numbers are too big for i32
#    jmp .L.do
#.L.done:
#    add esp, 8
#    pop ebp
#    ret
#.L.fact.end:
#    .size fact, .L.fact.end-fact

.globl opt_fact
.align 16
.type opt_fact,@function
opt_fact:
    mov eax, dword ptr [esp+4]
    lea ecx, [eax - 1]

.L.opt_fact.do:
    cmp ecx, 1
    jle .L.opt_fact.done

    mul ecx
    dec ecx
    jmp .L.opt_fact.do

.L.opt_fact.done:
    ret 4
.L.opt_fact.end:
    .size opt_fact, .L.opt_fact.end-opt_fact

.globl _start
.align 16
.type _start,@function
_start:
#   sub esp, 12
#   mov dword ptr [esp], 5
    push 5
    call opt_fact
#   add esp, 12
#   ret
    mov ebx, eax
    mov eax, 1
    int 0x80
.L.main.end:
    .size _start, .L.main.end-_start


