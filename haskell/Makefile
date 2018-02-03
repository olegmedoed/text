all: main

main: rm
	echo "\n";
	ghc --make $n -o main
	#ghc --make $n -o main -fglasgow-exts

# to compile main should exist.
# After ghc completes, if we list the contents of the directory, it should
# contain two new files: SimpleJSON.hi and SimpleJSON.o. The former is an 
# interface file, in which ghc stores information about the names exported from
# our module in machine-readable form.
json: rm
	echo "\n\n";
	# ghc -c $n -- get object files
	ghc -o main Main.hs JSON.hs PutJSON.hs

run:
	runghc $n


rm:
	-rm ./main

clean:
	-rm *.hi
	-rm *.o

# GHC provides a helpful compilation option, -fwarn-incomplete-patterns ,
# that will cause it to print a warning during compilation if a
# sequence of patterns doesn’t match all of a type’s value constructors.
#
# Shadowing can obviously lead to confusion and nasty bugs, so GHC
# has a helpful -fwarn-name-shadowing option. When enabled, GHC will
# print a warning message any time we shadow a name.
