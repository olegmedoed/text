.intel_syntax noprefix

.section .data
.long 0x11  
.align 4    # the number of .align directives has no matter
.align 4    # .align 4 is alingment to size of .long variable, ie 4 bite
.align 4
.align 4
.long 0x1
data:
.int 0x0
.int 0x0
.int 0x0



.section .text
.globl _start
_start:
    sgdt data

#   end
    mov bx, word ptr [data+4]
    mov eax, 1
    int 0x80

