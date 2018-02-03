	.text
	.file	"gcc.ll"
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	lea	eax, [.L.str]
	lea	ecx, [a]
	add	ecx, 20
	mov	dword ptr [ebp - 4], 4
	mov	edx, dword ptr [x]
	mov	dword ptr [ebp - 8], edx
	mov	dword ptr [ebp - 12], ecx
	mov	dword ptr [esp], eax
	call	puts
	xor	ecx, ecx
	mov	dword ptr [ebp - 16], eax # 4-byte Spill
	mov	eax, ecx
	add	esp, 24
	pop	ebp
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	4
x:
	.long	33                      # 0x21
	.size	x, 4

	.type	a,@object               # @a
	.globl	a
	.align	4
a:
	.long	1                       # 0x1
	.long	2                       # 0x2
	.long	3                       # 0x3
	.size	a, 12

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6


	.ident	"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"
	.section	".note.GNU-stack","",@progbits
