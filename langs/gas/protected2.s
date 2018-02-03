.equ STACK_BASE_ADDRESS, 0x200000           # 2mb
.equ USER_PM_CODE_BASE_ADDRESS, 0x400000    # 4mb
.equ USER_PM_CODE_SIZE, USER_PM_CODE_END - USER_PM_CODE_BASE_ADDRESS

.equ CODE_SELECTOR, 0x8
.equ DATA_SELECTOR, 0x10
.equ VIDEO_SELECTOR, 0x18

.code16
.text
_start:
#   clean display
    mov ax, 3
    int 0x10
#   open A-20 for 32-bit addressing
    in al, 0x92
    or al, 0x2
    out 0x92, al
#   compute a linear address of entry point of protected mode
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, PROTECTED_MODE_ENTRY_POINT
    mov [ENTRY_OFF], eax
#   compute linaer address of GDT
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, GDT
#   move GDT address in prepared variable
    mov dword ptr [GDTR+2], eax
    
    lgdt fword ptr [GDTR]
    
#   forbid all interruptions
    cli
    
    in al, 0x70
    or al, 0x80
    out 0x70, al
    
#   move to protected mode
    mov eax, cr0
    or al, 1        # set 0-bit of cr0
    mov cr0, eax
    
    .byte 066                                           #---|<-one opcode
    .byte 0xEA  # opcode of `jmp far`                   #   |
ENTRY_OFF:                                              #   |
    .long PROTECTED_MODE_ENTRY_POINT                    #   |
    .word CODE_SELECTOR # selector of 1st descriptor    #---|

    .align 8
GDT:
NULL_descr:
    .fill 8, 1, 0    # repeat, size, value
    .size NULL_descr, 8
CODE_descr: # v--- see page 59(limit all procspace[1mb without page.transl])
# 1-2 bytes is limit, 3-5 is base addr,            limit -v--v  v-- base addr
    .byte 0xff, 0xff, 0x00, 0x00, 0x00, 0b10011010, 0b11001111, 0x00
    .size CODE_descr, 8
DATA_descr:
    .byte 0xff, 0xff, 0x00, 0x00, 0x00, 0b10010010, 0b11001111, 0x00
    .size DATA_descr, 8
VIDE0_descr:
    .byte 0xff, 0xff, 0x00, 0x80, 0x0b, 0b10010010, 0b01000000, 0x00
.equ GDT_size, .-GDT

GDTR:
    .word GDT_size-1
    .long
    .size GDTR, 6

.code32
PROTECTED_MODE_ENTRY_POINT:
    mov ax, DATA_SELECTOR
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, STACK_BASE_ADDRESS

    call delta  # push current code-addr to stack
delta:
    pop ebx     # pop current code-addr from stack
    add ebx, USER_PM_CODE_START-delta

    mov esi, ebx
    mov edi, USER_PM_CODE_BASE_ADDRESS
    mov ecx, USER_PM_CODE_SIZE
    rep movsb

    mov eax, USER_PM_CODE_BASE_ADDRESS
    jmp eax

USER_PM_CODE_START:
START_CODE:
#ORG USER_PM_CODE_BASE_ADDRESS
USER_PM_CODE_END:


