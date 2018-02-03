    mov eax, dword ptr [data_items + edi * 4]
    mov eax, [data_items + edi * 4] # here intel can derive size
    movl data_items(,%edi,4), %eax 

    cmp eax, 0 
    cmpl $0, %eax
