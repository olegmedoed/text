.intel_syntax noprefix
	.text
	.file	"habr.ll"
	.globl	max
	.align	16, 0x90
	.type	max,@function
max:                                    # @max
# BB#0:
	mov	eax, dword ptr [esp + 8]
	mov	ecx, dword ptr [esp + 4]
	cmp	ecx, eax
	jbe	.LBB0_2
# BB#1:                                 # %if_true
	mov	eax, ecx
.LBB0_2:                                # %if_false
	ret
.Lfunc_end0:
	.size	max, .Lfunc_end0-max

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	sub	esp, 28
	mov	dword ptr [esp + 24], 4
	mov	dword ptr [esp + 20], 4
	mov	eax, dword ptr [esp + 24]
	mov	dword ptr [esp], eax
	mov	dword ptr [esp + 4], 4
	call	max
	mov	dword ptr [esp + 4], eax
	mov	dword ptr [esp], .str
	call	printf
	mov	eax, 2
	add	esp, 28
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
	.globl	.str
.str:
	.asciz	"%d\n"
	.size	.str, 4


	.section	".note.GNU-stack","",@progbits
