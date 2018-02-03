# Each of the basic operations on a binary search tree runs in O(h) time
# The h.of.bin.search.tree is varies as items are deleted and inserted.
# As with quicksort, we can show that the behavior of the average case is much 
# closer to the best case than to the worst case

# When the tree is created by insertion alone, the analysis becomes more
# tractable. Let us therefore define a RANDOMLY BUILT BIN.SEARCH.TREE on n keys
# as one that arises from inserting the keys in random order into an initially
# empty tree, where each of the n! permutations of the input keys is equally
# likely.(Ex12.4-3 asks you to show that this notion is different from assuming
# that every bin.search.tree on n keys is equally likely.)

#               Theorem 12.4
# The expected height of a randomly built binary search tree on n DISTINCT KEYS
# is O(lg_n)
#               Proof
#   3 rand.var:
# Xn - height of a randomly built binary search on n keys
# Yn = 2^Xn - EXPONENTIAL HEIGHT - toest', kolichestvo elementov skolko moglo by
# vmestits9 v takoe derevo, kogda Yn == n, eto sluchai idealnogo raspredeleni9
# elementov
#
# Rn holds ρ(root of tree what we choose) RANK within the set of n keys;
# Rn holds the position that ρ would occupy if the set of keys were sorted.
# Val of Rn is equally likely to be any el of {1,2...n}
#
# we have rand.built bin.search.tree on n DISTINCT KEYS(that is we don't care
# about its value, we care only about what they have distinct value what we can
# compare and determine the keys less then cur and bigger then cur)
# To abstract of concrete value I decide to use symbols
Rn = 3
[a,b,c,d,e]  when choose c
[e,b,d,c,a]  when choose c
Rn = 5       when choose e
Zn1 - vero9tnost' chto my viberem samyi men'ewyi el
Znn - samyi bolwoi
Zn(n/2 +1) - chto viberem sredniy(esli takoi est' => n is odd)
#
# Yn = 2*max(Yi-1, Yn-i), Y1 = 1, Y0 = 0, 
#
# INDIC.RAND.VARS: Zn1,Zn2...Znn, where Zni = I{Rn = i} 
# Pr{Rn = i} = 1/n,   ==> by Lemma5.1  E[Zni] = 1/n,    for i=1..n, 
#
# since exectly one value of Zni is 1 and all others are 0
#   Yn = Σ.i=1.n Zni*(2*max(Yi-1,Yn-i)).   -- eta formula formula eto takzhe
#   samo kak 'kolichestvo udachnih broskov monety' = 1/2+..1/n  ili 'kolichestvo
#   obmenov v employer.task' 1/2+/1/3+1/4+..+1/n, toest' zanachenie kazhdogo
#   momenta(obmena, broska) umnozhennoe na ego vero9tnost' na kazhdom hagu,
#   toest' kak by sred.arifm vseh vozmozhnih vero9tnostei(sred.arif vero9tnosti
#   obmena|broska na kazhdom wagu)
#
#   E[Yn] <= 4/n Σ.i=0.n-1 E[Yi]      (12.2)
#   ? why 4/n? 2 - since tree with h+1 in 2 times bigger then h               +
#            + 2 - since E[max([**],[+++])] + E[max([***],[++])]  == 2[Yi]
#            1/n - since every el can be chosen as root
#
# Using the substitution meth, we shall show that for all {0,1,..}, the
# recurrence (12.2) has the solution
#               E[Yx] <= 1/4 * (x+3\3)
# In doing so, we shall use the identity
#               Σ.i=0.n-1 (i+3\3) = (n+3\4)
#
#   E[Yn] <= 4/n * Σ.i=0.n-1 E[Yi]
#         <= 4/n * Σ.i=0.n-1 1/4*(i+3\3) (by the inductive hypotesis)
#          = 1/n * Σ.i=0.n-1 (i+3\3)
#          = 1/n * (n+3\4)            ****
#          = 1/n * (n+3)!/4!(n-1)!
#          = 1/4 * (n+3)!/3!n)!
#          = 1/4 * (n+3\3)
# ****
#   why 4? that since by [ (n\m) == (n-1\m-1) + (n-1\m) :Anderson.Th1.4(2)]
# so we have tree.arr   [a,b,c,d,e,f,g]

# toest' vero9tnost' togo chto root v masive budet na toi pozicii, na kotoroi
# on byl by, esli by my otsortirovali massiv, toest'
