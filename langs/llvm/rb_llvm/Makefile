rbc:
	clang-3.7 -O1 -std=c99 -mllvm --x86-asm-syntax=intel -o rb_c rb.c
	clang-3.7 -O1 -std=c99 -S -emit-llvm -o rb_c.ll rb.c
	clang-3.7 -O1 -std=c99 -mllvm --x86-asm-syntax=intel -S -o rb_c.s rb.c

indent:
	indent *.c
	rm *.c~

