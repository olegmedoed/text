	.text
	.file	"rb.c"
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
	mov	edi, dword ptr [esp + 44]
	mov	ebx, dword ptr [esp + 40]
	mov	ebp, dword ptr [esp + 36]
	mov	esi, dword ptr [esp + 32]
	mov	dword ptr [esp], 20
	call	malloc
	mov	dword ptr [eax], esi
	mov	dword ptr [eax + 4], ebp
	mov	dword ptr [eax + 8], ebx
	mov	dword ptr [eax + 12], edi
	mov	ecx, dword ptr [esp + 48]
	mov	dword ptr [eax + 16], ecx
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
	cmp	dword ptr [ecx], 1
	jne	.LBB1_2
# BB#1:
	mov	eax, dword ptr [ecx + 4]
	mov	eax, dword ptr [eax + 16]
.LBB1_2:
	ret
.Lfunc_end1:
	.size	color, .Lfunc_end1-color

	.globl	left_rotate
	.align	16, 0x90
	.type	left_rotate,@function
left_rotate:                            # @left_rotate
# BB#0:
	push	edi
	push	esi
	mov	eax, dword ptr [esp + 16]
	cmp	dword ptr [eax], 0
	je	.LBB2_10
# BB#1:
	mov	edx, dword ptr [esp + 12]
	mov	ecx, dword ptr [edx]
	cmp	dword ptr [ecx], 0
	je	.LBB2_10
# BB#2:
	mov	esi, dword ptr [eax + 4]
	mov	ecx, dword ptr [esi + 8]
	mov	edi, dword ptr [ecx + 4]
	mov	edi, dword ptr [edi + 4]
	mov	dword ptr [esi + 8], edi
	mov	esi, dword ptr [ecx + 4]
	mov	esi, dword ptr [esi + 4]
	cmp	dword ptr [esi], 1
	jne	.LBB2_4
# BB#3:
	mov	esi, dword ptr [esi + 4]
	mov	dword ptr [esi + 12], eax
.LBB2_4:
	mov	esi, dword ptr [eax + 4]
	mov	esi, dword ptr [esi + 12]
	mov	edi, dword ptr [ecx + 4]
	mov	dword ptr [edi + 12], esi
	mov	esi, dword ptr [eax + 4]
	mov	esi, dword ptr [esi + 12]
	cmp	dword ptr [esi], 0
	je	.LBB2_5
# BB#6:
	mov	edx, dword ptr [esi + 4]
	cmp	dword ptr [edx + 4], eax
	je	.LBB2_7
# BB#8:
	mov	dword ptr [edx + 8], ecx
	jmp	.LBB2_9
.LBB2_5:
	mov	dword ptr [edx], ecx
	jmp	.LBB2_9
.LBB2_7:
	mov	dword ptr [edx + 4], ecx
.LBB2_9:
	mov	edx, dword ptr [ecx + 4]
	mov	dword ptr [edx + 4], eax
	mov	eax, dword ptr [eax + 4]
	mov	dword ptr [eax + 12], ecx
.LBB2_10:
	pop	esi
	pop	edi
	ret
.Lfunc_end2:
	.size	left_rotate, .Lfunc_end2-left_rotate

	.globl	right_rotate
	.align	16, 0x90
	.type	right_rotate,@function
right_rotate:                           # @right_rotate
# BB#0:
	push	edi
	push	esi
	mov	eax, dword ptr [esp + 16]
	cmp	dword ptr [eax], 0
	je	.LBB3_10
# BB#1:
	mov	edx, dword ptr [esp + 12]
	mov	ecx, dword ptr [edx]
	cmp	dword ptr [ecx], 0
	jne	.LBB3_10
# BB#2:
	mov	esi, dword ptr [eax + 4]
	mov	ecx, dword ptr [esi + 4]
	mov	edi, dword ptr [ecx + 4]
	mov	edi, dword ptr [edi + 8]
	mov	dword ptr [esi + 4], edi
	mov	esi, dword ptr [eax + 4]
	mov	esi, dword ptr [esi + 4]
	cmp	dword ptr [esi], 1
	jne	.LBB3_4
# BB#3:
	mov	esi, dword ptr [esi + 4]
	mov	dword ptr [esi + 12], eax
.LBB3_4:
	mov	esi, dword ptr [eax + 4]
	mov	esi, dword ptr [esi + 12]
	mov	edi, dword ptr [ecx + 4]
	mov	dword ptr [edi + 12], esi
	mov	esi, dword ptr [eax + 4]
	mov	esi, dword ptr [esi + 12]
	cmp	dword ptr [esi], 0
	je	.LBB3_5
# BB#6:
	mov	edx, dword ptr [esi + 4]
	cmp	dword ptr [edx + 4], eax
	je	.LBB3_7
# BB#8:
	mov	dword ptr [edx + 8], ecx
	jmp	.LBB3_9
.LBB3_5:
	mov	dword ptr [edx], ecx
	jmp	.LBB3_9
.LBB3_7:
	mov	dword ptr [edx + 4], ecx
.LBB3_9:
	mov	edx, dword ptr [eax + 4]
	mov	dword ptr [edx + 12], ecx
	mov	ecx, dword ptr [ecx + 4]
	mov	dword ptr [ecx + 8], eax
.LBB3_10:
	pop	esi
	pop	edi
	ret
.Lfunc_end3:
	.size	right_rotate, .Lfunc_end3-right_rotate

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	sub	esp, 44
	mov	dword ptr [esp + 32], 1
	mov	dword ptr [esp + 16], 1
	mov	dword ptr [esp + 12], 0
	mov	dword ptr [esp + 8], 0
	mov	dword ptr [esp + 4], 0
	mov	dword ptr [esp], 33
	call	create_node
	mov	dword ptr [esp + 36], eax
	lea	eax, [esp + 32]
	mov	dword ptr [esp + 4], eax
	mov	dword ptr [esp], .L.str
	call	printf
	mov	eax, dword ptr [esp + 32]
	mov	dword ptr [esp + 4], eax
	mov	dword ptr [esp], .L.str.1
	call	printf
	xor	eax, eax
	add	esp, 44
	ret
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%x\n"
	.size	.L.str, 4

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"%d\n"
	.size	.L.str.1, 4


	.ident	"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"
	.section	".note.GNU-stack","",@progbits
