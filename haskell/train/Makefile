all: compile

main:
	echo "\n\n"
	runghc $n

compile:
	echo "\n";
	ghc --make $n -o test \
	    -fwarn-incomplete-patterns -fwarn-incomplete-uni-patterns
	#ghc --make $n -o main -fglasgow-exts


# GHC provides a helpful compilation option, -fwarn-incomplete-patterns ,
# that will cause it to print a warning during compilation if a
# sequence of patterns doesn’t match all of a type’s value constructors.
#
# Shadowing can obviously lead to confusion and nasty bugs, so GHC
# has a helpful -fwarn-name-shadowing option. When enabled, GHC will
# print a warning message any time we shadow a name.
