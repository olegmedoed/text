gas:
	as -o test.o $n
	ld test.o -o test
	#rm *.o

llvm:
	llvm-mc -assemble start.s

protected:
	as -o test.o protected.s
	ld -Ttext=0x100 --oformat=binary -o test.com test.o

myld:
	as -o test.o $n
	ld test.o -o test --verbose -T my.ld
