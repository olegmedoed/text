	.text
	.file	"habr.c"
	.globl	max
	.align	16, 0x90
	.type	max,@function
max:                                    # @max
# BB#0:
	mov	eax, dword ptr [esp + 8]
	mov	ecx, dword ptr [esp + 4]
	cmp	ecx, eax
	cmovge	eax, ecx
	ret
.Lfunc_end0:
	.size	max, .Lfunc_end0-max

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	sub	esp, 12
	mov	dword ptr [esp + 4], 6
	mov	dword ptr [esp], 4
	call	max
	mov	dword ptr [esp + 4], eax
	mov	dword ptr [esp], .L.str
	call	printf
	xor	eax, eax
	add	esp, 12
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"
	.section	".note.GNU-stack","",@progbits
