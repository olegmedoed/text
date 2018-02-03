# .byte, .word, .long, .quad, .hword(.octa)
# Data Accessing Methods    -   p21
# Addressing Modes          -   p47

.intel_syntax noprefix
.section .data
.align 4 # has impact on sh_addralign
.long 1
.long 2

.section .text
# .globl means that the assembler shouldn’t discard this symbol after assembly,
# because the linker will need it. _start is a special symbol that always needs 
# to be marked with .globl because it marks the location of the start of the
# program.  Without marking this location in this way, when the computer loads 
# your program it won’t know where to begin running your program.
.globl _start
# _start is a symbol, which means that it is going to be replaced by something 
# else either during assembly or linking. Symbols are generally used to mark 
# locations of programs or data, so you can refer to them by name instead of by 
# their location number.
_start:
# The $ indicates that we want to use immediate mode addressing. Without the $
# it would do direct addressing, loading whatever number is at address 1
    mov eax, 1      # < this is the linux kernel command
                    # number (system call) for exiting a program
    mov ebx, 0      # < this is the status number we will return to the
                    # operating system. (echo $?)
    int  0x80       # < this wakes up the kernel to run the exit command
# --^ the interrupt transfers control to whoever set up an interrupt handler for 
# the interrupt number. In the case of Linux, all of them are set to be handled 
# by the Linux kernel.  !if dont use `int 0x80` and run program we have SEGFAULT
# SysCall are invoked by setting up the regs in a special way and issuing the 
# instruction int $0x80. Linux knows which system call we want to access by
# what we stored in the %eax register. Each system call has other requirements
# as to what needs to be stored in the other registers.         v-- [from me]
# System calls is doing by intrruption, and handler of interruption is on 0-lev.

# useful tips:
# lea ecx, [ebx + 4], instead of
# ...
# mov ecx, ebx
# add ecx, 4
