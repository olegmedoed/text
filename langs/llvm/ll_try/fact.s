	.text
	.file	"fact.c"
	.globl	fact
	.align	16, 0x90
	.type	fact,@function
fact:                                   # @fact
# BB#0:
	mov	eax, dword ptr [esp + 4]
	lea	ecx, [eax - 1]
	cmp	ecx, 2
	jl	.LBB0_2
	.align	16, 0x90
.LBB0_1:                                # %.lr.ph
                                        # =>This Inner Loop Header: Depth=1
	imul	eax, ecx
	dec	ecx
	cmp	ecx, 1
	jg	.LBB0_1
.LBB0_2:                                # %._crit_edge
	ret
.Lfunc_end0:
	.size	fact, .Lfunc_end0-fact

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
# BB#0:
	sub	esp, 12
	mov	dword ptr [esp], 5
	call	fact
	add	esp, 12
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"
	.section	".note.GNU-stack","",@progbits
