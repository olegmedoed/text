	.text
	.file	"tutor.ll"
	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	mov	eax, dword ptr [glob_var]
	add	eax, 3
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	glob_var,@object        # @glob_var
	.section	.rodata,"a",@progbits
	.align	4
glob_var:
	.long	14                      # 0xe
	.size	glob_var, 4


	.section	".note.GNU-stack","",@progbits
