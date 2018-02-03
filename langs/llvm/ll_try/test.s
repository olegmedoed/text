	.text
	.file	"test.ll"
	.globl	square_int
	.align	16, 0x90
	.type	square_int,@function
square_int:                             # @square_int
	.cfi_startproc
# BB#0:
	mov	eax, dword ptr [esp + 4]
	imul	eax, eax
	ret
.Lfunc_end0:
	.size	square_int, .Lfunc_end0-square_int
	.cfi_endproc

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	sub	esp, 12
	mov	dword ptr [esp], .str
	call	puts
	mov	dword ptr [esp], 5
	call	square_int
	xor	eax, eax
	add	esp, 12
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.str,@object            # @.str
	.section	.rodata,"a",@progbits
	.globl	.str
.str:
	.asciz	"hello man\n"
	.size	.str, 11


	.section	".note.GNU-stack","",@progbits
