.intel_syntax noprefix
# This program is directed by data. Depending on what data it receives, it will
# follow different instruction paths.

# Even though they are .long, the program will produce strange results if any 
# number is greater than 255, because that’s the largest allowed exit status

# %edi - current position in the list.
# %ebx - current highest value in the list.
# %eax - current element being examined.
# [from me] but instead edi I can use edx[for exmp]
.section .data
# .long causes the assembler to reserve memory for the list of nums that follow
# it. data_items refers to the location of the first one. Because data_items is
# a label, any time in our program where we need to refer to this address we can
# use the data_items symbol, and the gas will substitute it with the address
# where the numbers start during assembly.

# We don't have a .globl declaration for data_items. This is because we only
# refer to these locations within the program
data_items:
# .byte   numbers between 0 and 255.        1b
# .word   numbers between 0 and 65535.      2b
# .long   numbers between 0 and 4294967295. 4b (.short .int may be varied)
# .ascii  string of bytes in ascii format "\tHello world!\n\0"
.long 223,67,34,222,45,75,54,34,44,33,22,11,66,0 # 0 is a list terminator

.section .text
.globl _start
_start:
    mov edi, 0  # move 0 into the index register
    mov eax, [data_items + edi * 4] # load the first byte of data
#   movl data_items(,%edi,4), %eax 
    mov ebx, eax # since this is the first item, %eax is the biggest
start_loop:
# if last element; break
    cmp eax, 0          # the result of the comparison is stored in the
    je loop_exit        # status register

    inc edi             # load next value
    mov eax, [data_items + edi * 4]
# if new one is not bigger; continue
    cmp eax, ebx
    jle start_loop
# else; move cur item into max_item var
    mov ebx, eax
    jmp start_loop
loop_exit:
# exit(max_item)
    mov eax, 1
    int 0x80

