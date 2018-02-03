gcc:
	clang-3.7 -O1 -std=c99 -S -emit-llvm -o gcc.ll gcc.c
	clang-3.7 -O1 -std=c99 -S -mllvm --x86-asm-syntax=intel -o gcc.s gcc.c

habr:
	clang-3.7 -O1 -std=c99 -S -emit-llvm -o habr1.ll habr.c
	clang-3.7 -O1 -std=c99 -S -mllvm --x86-asm-syntax=intel -o habr1.s habr.c

fact:
	clang-3.7 -O1 -std=c99 -S -emit-llvm -o fact.ll fact.c
	clang-3.7 -O1 -std=c99 -S -mllvm --x86-asm-syntax=intel -o fact.s fact.c

indent:
	indent *.c
	rm *.c~
