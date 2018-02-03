# see also intel.vol3:9.9 for more detail explanations
.intel_syntax noprefix

.equ STACK_BASE_ADDRESS, 0x200000         # 2Mb
.equ USER_PM_CODE_BASE_ADDRESS, 0x400000  # 4Mb
.equ USER_PM_CODE_BASE_SIZE, USER_PM_CODE_END - USER_PM_CODE_BASE_ADDRESS

.equ CODE_SELECTOR, 0x8
.equ DATA_SELECTOR, 0x10
.equ VIDEO_SELECTOR, 0x18

.equ PAGE_DIR_BASE_ADDRESS    0x01A00000
.equ PAGE_TABLE_BASE_ADDRESS  0x01200000

.code16
.text
_start:
#   clean display(video-card in text mode["textovyi rezhim"])
    mov ax, 3
    int 0x10
#   open A-20 line (for 32-bit addressing)
    in al, 0x92
    or al, 2
    out 0x92, al
#   compute linear-address of the protected mode entry point
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, PROTECTED_MODE_ENTRY_POINT
    mov [ENTRY_OFF], eax
#   compute linear address of GDT
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, GDT
    mov dword [GDTR+2], eax
#   load register gdtr:
    lgdt fword [GDTR]
#   forbid all interruptions, since first interruption activity of timer
#   "podvesit" your processor, since table of interruption handlers is not
    cli                                                          #   defined
    in al, 0x70
    or al, 0x80
    out 0x70, al
#   switch to protected mode
    mov eax, cr0
    or al, 1
    mov cr0, eax

#   load new selector to CS
#         v--prefix of an operator digit capacity changing(intel.vol2:p32.Gr3)
    .byte 0x66
    .byte 0xEA # opcode of JMP FAR
ENTRY_OFF:
    .long PROTECTED_MODE_ENTRY_POINT # 32-bit smew'enie
    .word CODE_SELECTOR # selector of first descriptor (0-voi zanimaet 8 byte =>
    # znachit 1-vyi nahodits9 po smew'eniu 8bit )
.align 8
# GDT contain diff descriptors(not only of segments desc, but also TSS)
GDT:
NULL_descr:
#   .rept 8
#   .byte 0
#   .endr
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
    .word GDT_size-1# 16-bit limit of GDT
    .long # here will be 32-bit linear GDT address
    .size GDTR, 6

.code32
PROTECTED_MODE_ENTRY_POINT:
#   load necessary selectors in segment registers
#   mov ax, DATA_SELECTOR
#   mov bx, ds # num of code segment of real mode
#   mov ds, ax
#   mov ax, VIDEO_SELECTOR
#   mov es, ax

#   xor esi, esi
#   mov si, bx
#   shl esi, 4
#   add esi, message
#   xor edi, edi
#   mov ecx, 18
#   rep movsb
#
#   jmp .

#   stack and data in ona data segment
    mov ax, DATA_SELECTOR # base addr = 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, STACK_BASE_ADDRESS # stack start 2Mb, to bottom(hot9 ne fact,
#   smotr9 kak ustanovlen bit napravleni9 rosta, nado smotret' v DATA_descr)

    call delta  # see p69
delta:
    pop ebx
    add ebx, USER_PM_CODE_START-delta
    
#   AFAIU we copy code write above to adress 0x400000(4Mb)
    mov esi, ebx
    mov edi, USER_PM_CODE_BASE_ADDRESS
    mov ecx, USER_PM_CODE_BASE_SIZE
    rep movsb

    mov eax, USER_PM_CODE_BASE_ADDRESS
    jmp eax

#########################  HERE OUR PM CODE IS START  ########################
USER_PM_CODE_START: 

START_CODE:
    
    
.equ INT_GATE, 0b1000111000000000 # type of gateway descriptor
#   macro for definition of gateway descriptor
.macro DEFINE_GATE _address, _code_selector, _type
    .word \_address | 0xFFFF , \_code_selector,_type, \_address << 16
.endm

.size IDT_size, IDT_END-IDT
    mov ax, VIDEO_SELECTOR
    mov es, ax

    lidt fword [IDTR]
#   iMr, iSr - is regirsters of interrupt controller
#   iMr responsible for masking, if bit in iMr is 'on' => this line is forbidden
#   if mask 2 line of veduw'ego contrller => mask all lines in vedomyi
#   iSr say what interruption is handled now
#
#   iMr of veduw'ego is attached to 0x21 port, in vedomyi to 0xa1 port
#   iSr of veduw'ego is attached to 0x20 port, in vedomyi to 0xa0 port
#       out iSr 0b00010001
#       out iMr, <num added during supplying on data bus>
#       must be divisible 8
#       out iMr, 0b00000100 # dependent of controller
#       out iMr, 0b00000001
#   redirection of vectors(of interrupt controller)
#   for this we need to make interrupt controller to change number which is
#   added to number of interruption(by interr.controller) before passing to
#   date bus(that is redirect intrruptions to vectors 0x20-0x2f). Initial
#   vectors for veduw'ego i vedomogo we put in BL and BH correspondly
    mov bx, 0x2820
    mov al, 0b00010001
    out 0x20, al
    out 0xa0, al
    mov al, bl
    out 0x21, al
    mov al, bh
    out 0xa1, 0b00000100
    out 0x21, al
    mov al, 2
    out 0xa1, al
    mov al,   0b00000001
    out 0x21, al
    out 0xa1, al

#   after that we should allow all interruptions
    in al, 0x70
    and al, 0x7f
    out 0x70, al
    sti

int_EOI:          # empty handler, it send both controllers the signal about
    push ax       # interruption has been handled
    mov al, 0x20
    out 0x20, al
    out 0xa0, al
    pop ax
    iretd

create_PDEPTE: # thie func receives its args in regs(eax,ebx)
#   eax - virtual page address
#   ebx - phys page address
    pushad
    mov edi, ebx
    mov edx, eax

    shr eax, 22   # get index of page_dir
    shl eax, 2    # mul on 4, since one descr takes 4bytes
    mov esi, PAGE_DIR_BASE_ADDRESS
    add esi, eax  # esi = an address of our page_table descr in page_dir
    shr eax, 2    # now eax keep just index of descr in page_dir

    mov ebx, eax
    shl ebx, 12   # mul page_dir_index on 4kb
    
    mov eax, PAGE_TABLES_BASE_ADDRESS
    add eax, ebx    # eax - our page_table_base adddress
    or  eax, 0b11   # set flag of presence and write.permitting
#   CREATE the table descr
    mov [esi], eax  # saves this -^ value in elem of page_dir
    and eax, 0xfffff000 # off flags, again eax = our page_table_base_addr

    create_PTE$: # eax = our page_table base_addr
    mov esi, eax
    mov eax, edx  # edx = initial eax(virtual addr)
    shl eax, 10
    shr eax, 22     # get index in page_table
    shl eax, 2      # get offset of our descri in page_table
    add esi, eax    # esi = addr of our page descr

    mov eax, edi    # edi = initial ebx = phys addr
    or  eax, 0b11
#   CREATE the page descr
    mov [esi],  eax

    end:
    popad
    ret

#   if ADDRESS TRANSLATION MODE is activated => TSS should be in on page, since
#   processor translate virtual address in phys ONLY ONCE(abl9z:p105).
#   TSS descr can be defined only in GDT
#   main distinction LDT from GDT - it cannot store descr of system objs(objs
#   that is used by CPU [exmp: TSS(so task can't determine task in itself)])
#   so LDT can determine only descr of segments code,data and gateways
#   TI bit in selector(CS,DS..) determine what, LDT or GDT, is used.
#   LDT is described in GDT by special descr(abl9z:p106)

IDTR:
    .short IDT_size-1
#   since base address of segment start from 0 => smew'enie(value of IDT label)
#   is absolute address, if we don't use PAGE TRANSLATION => this address is
    .long IDT                                               # phisical also

.align 8
IDT:
    .quad 0 # 0
    DEFINE_GATE syscall_handler, CODE_SELECTOR, INT_GATE
.rept 10
    .quad 0 # 2
#   ...     # 12
.endr
    DEFINE_GATE exGP_handleer, CODE_SELECTOR, INT_GATE # 13 #GP see p75
.rept 17
    .quad 0 # 14
#   ...     # 31
.endr
    DEFINE_GATE irq0_handler, CODE_SELECTOR, INT_GATE # 20h (IRQ 0 timer)
    DEFINE_GATE irq1_habdler, CODE_SELECTOR, INT_GATE # 21h (IRQ 1 keyboard)ss
.rept 14
    DEFINE_GATE int_EOI, CODE_SELECTOR, INT_GATE      # 22h (IRQ 2-15)
.endr
IDT_END:
    
USER_PM_CODE_END:
