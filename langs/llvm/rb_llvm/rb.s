	.text
	.file	"rb.ll"
	.globl	create_node
	.align	16, 0x90
	.type	create_node,@function
create_node:                            # @create_node
# BB#0:
	push	ebp
	push	ebx
	push	edi
	push	esi
	sub	esp, 12
	mov	esi, dword ptr [esp + 48]
	mov	edi, dword ptr [esp + 44]
	mov	ebx, dword ptr [esp + 36]
	mov	ebp, dword ptr [esp + 32]
	mov	dword ptr [esp], 20
	call	malloc
	mov	dword ptr [eax], ebp
	mov	dword ptr [eax + 4], ebx
	mov	dword ptr [eax + 8], ebx
	mov	dword ptr [eax + 12], edi
	mov	dword ptr [eax + 16], esi
	add	esp, 12
	pop	esi
	pop	edi
	pop	ebx
	pop	ebp
	ret
.Lfunc_end0:
	.size	create_node, .Lfunc_end0-create_node

	.globl	color
	.align	16, 0x90
	.type	color,@function
color:                                  # @color
# BB#0:
	mov	ecx, dword ptr [esp + 4]
	mov	eax, 1
	cmp	dword ptr [ecx], 2
	jne	.LBB1_2
# BB#1:                                 # %node_t
	mov	eax, dword ptr [ecx + 4]
	mov	eax, dword ptr [eax + 16]
.LBB1_2:                                # %leaf_t
	ret
.Lfunc_end1:
	.size	color, .Lfunc_end1-color


	.section	".note.GNU-stack","",@progbits
