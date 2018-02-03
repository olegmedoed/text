# Ψιβα

# before
#
# (n\k) = n/k (n-1\k-1)                                         C.8*******

# SAMPLE SPACE S is set of ELEMENTARY EVENTS[possible outcome of experiment]
# The event S is called CERTAIN EVENT, and {} is called NULL EVENT
# If A Ո B is {}  => A,B are mutually exclusive
# An EVENT is a subset of the sample space S(except some rare situations: p1190)
# All elementary events are mutually exclusive.
# [From me: elem.events are signed by using small letters, and just events by
# using capital, S usually mean the event that constist of all elem.events ..
# .. => probability of S = 100% = 1]
#
# A PROBABILITY DISTRIBUTION FUNCTION Pr{} on a SAMPLE SPACE S is a -
# mapping : (from events of S -> real nums) satisfying the following
#                                 PROBABILITY AXIOMS:
# 1. Pr{A} >= 0 for any event A.                                   \union - U
# 2. Pr{S} = 1.
# 3. Pr{A U B} = Pr{A} + Pr{B} for any 2 MUTUALLY EXCLUSIVE events A and B.
# More generally, for any (finite or countably infinite) seq of events A1,A2..
# that are PAIRWISE MUTUALLY EXCLUSIVE,
#                                       Pr{U.i Ai} = Σ.i Pr{Ai}
#   Pr{A U B} = Pr{A} + Pr{B} - Pr{A Ո B}                       C.12******
#            <= Pr{A} + Pr{B}                                   C.13******
#                             Pr {A} - probability of the event A
# 
# A DISCRETE PROBABILITY DISTRIBUTION is DISCRETE - if
#   it is defined over a finite or countably infinite sample space
#   Pr{A} = ∑.s∈A..Pr{s}
# if  Pr{S} = 1/|S|  => we have the UNIFORM PROBABILITY DISTRIBUTION on S
# In such a case the experiment is described as “picking an el of S at random.”
#                           [exmp: --v]
# | flipping a fair coin n times:
# |       UNIFORM prob.dist on S = {H,T}^n,   |S| = 2^n 
# |       s(elem.ev) is a string over {H,T} with probab = 1 / 2^n
# | A = { exactly k heads and exactly n-k tails occur }
# |   is a subset of S of size |A| = (n\k) , since (n\k) strings of length n over
# | {H,T} contain exactly k H’s. The probability of event A is thus
# |           Pr{A} = (k\n) / 2^n
#
# The CONTINUOUS UNIFORM PROBABILITY DISTRIBUTION is an exmp of a probability
# distribution in which not all subsets of the sample space are considered to
# be events. ....... (skipped)
#
# [from me: Ո - `and` since el in A `and` in B
#           U - `or`  since el in A `or`  in B ]
#
# The CONDITIONAL PROBABILITY of an event A given that another event B occurs
# is defined to be
#     Pr{A | B} = Pr{A Ո B} / Pr{B}   whenever Pr{B} != 0   C.14 *******
# [AFAIU]
#   if we sure that B is happen => A \ B is'nt happen for sure, so we consider
#   only such events in A that in A Ո B and B constitute set of all possible
#   variants(as earlier it was S). Of course we talk about not INDEPENDENT
#   events(since we can conside such event from A that not in A Ո B)
#
# Two events are INDEPENDENT if
#     Pr{A Ո B} = Pr{A}Pr{B} ,                        C.15 *******
# which is equivalent, if Pr{B} != 0, to the condition
#     Pr{A | B} = Pr{A} << from.me: fact that B is happen don't impact on A and
#     don't prevent possibility to happen for events of A that not in A Ո B
#
# A collection of A1,A2..An of events is said to be PAIRWISE INDEPENDENT if
#     Pr{Ai Ո Aj}  = Pr{Ai}Pr{Aj}   for all 1 <= i < j <= n
# The events of the collection are MUTUALLY INDEPENDENT if every k-subset
#  Ai1,Ai2,..Aik of the collection, where 2 <= k <= n, 1 <= i1 < i2 .. < ik <= n
#  satisfies
#     Pr{Ai1 Ո Ai2 ... Aik} = Pr{Ai1}Pr{Ai2}..Pr{Aik}
# [exmp]
# We flip 2 fair coins. A1 - 1st coin is heads, A2 2nd coin is heads,
# A3 both coins are different. We have ...
#   Pr{A1} = 1/2          Pr{A2} = 1/2          Pr{A3} = 1/2
#   Pr{A1 Ո A2} = 1/4     Pr{A1 Ո A3} = 1/4     Pr{A2 Ո A3} = 1/4
#   Pr{A1 Ո A2 Ո A3} = 0
# Since for 1 <= i < j <= 3, we have Pr{Ai Ո Aj} = Pr{Ai}Pr{Aj} = 1/4, the
# events A1, A2, A3 are PAIRWISE INDEPENDENT. The events are NOT MUTUALLY
# INDEPENDENT, because Pr{A1 Ո A2 Ո A3} = 0 and Pr{A1}PR{A2}Pr{A3} = 1/8 != 0

#       Bayes's theorem.
# From the definition of conditional probability (C.14) and the commutative law
# A Ո B = B Ո A, it follows that for 2 events A and B, each with nonzero
# probability
#     Pr{A Ո B} = Pr{B}Pr{A | B} = Pr{A}Pr{B | A}           C.16*******
#   [from me: if `a` = (1/m) / (1/n), then  multiply `a` to 1/n means
#             calculate how `a` compare to whole part, that is 1]
# Solving for Pr{A | B}, we obtain
#     Pr{A | B} = Pr{A}Pr{B | A} / Pr{B}                    C.17*******
#         ^^^ Bayes's theorem
# Pr{B} is a NORMALIZING CONSTANT, which we can reformulate as follows.
# B = (B Ո A) U (B Ո !A) ,  B Ո A and B Ո !A are MUTUALLY EXCLUSIVE events,
# =>
#   Pr{B} = Pr{B Ո A} + Pr{B Ո !A} = Pr{A}Pr{B | A} + Pr{!A}Pr{B | !A}
# Substituting into equation(C.17), we obtain an equivalent form of Bayes's
# theorem:                                                            C.18*****
#     Pr{A | B} = Pr{A}Pr{B | A}  /  Pr{A}Pr{B | A} + Pr{!A}Pr{B | !A} 
#
# [exmp] We have a fair coin and a biased coin that always comes up heads.
# we choose one of the two coins at random, we flip that coin once, and then we
# flip it again. Suppose that the coin we have chosen comes up heads both times.
# What is the probability that it is biased?
#   A - we choose biased coin, B - choosen coin comes up heads both times
#     Pr{A | B} = ?.
# We have Pr{A} = 1/2, Pr{B | A} = 1 Pr{!A} = 1/2, Pr{B | !A} = 1/4 ; hence, 
#     Pr{A | B} = (1/2)*1 / (1/2)*1 + (1/2)*(1/4)  =  4/5.
#
# Ex C.2-2.   Prove Boole’s inequality:
# For any finite or countably infinite seq of events A1,A2..
#     Pr{A1 U A2 U ..} <= Pr{A1} + Pr{A2} ..                  C.19*******

#     DISCRETE RANDOM VARIABLES
# A (DISCRETE) RANDOM.VAR X is 
#       func: (finite or countably infinite sample.space S -> real nums)
# For a random variable X and a real number x, we define the event X=x to be
# {s ∈ S : X(s) = x} ; thus
#                 Pr{X=x} =  Σ.s∈S:X(s)=x Pr{s}.
# f(x) = Pr{X=x} is the PROBABILITY DENSITY func of the random variable X.
# From the probability axiom, Pr{X=x} >= 0, Σx.Pr{X=x} = 1
# [exmp]
# If X and Y are random.vars on S, the func
#     f(x,y) = Pr{X=x and Y=y}
# is the JOINT PROBABILITY DENSITY FUNCTION of X and Y. For a fixed value y,
#     Pr{Y=y} = Σ.x Pr{X=x and Y=y}
# and similarly, for a fixed value x,
#               Pr{X=x} = Σ.y Pr{X=x and Y=y}
# Using (C.14): Pr{X=x|Y=y} = Pr{X=x and Y=y} / Pr{Y=y}
# X, Y to be INDEPENDENT if for @x,y, the events X=x and Y=y are independent
#  or, equivalently, if for all x,y, we have
#     Pr{X=x and Y=y} = Pr{X=x}Pr{Y=y}
# Given a set of random.vars defined over the S, we can define new random.vars
# as sums, products, or other functions of the original vars.

#     EXPECTED VALUE of a RANDOM VARIABLE
# The simplest and most useful summary of the DISTRIBUTION OF A RANDOM.VARS is
# the "average" of the vals it takes on. The EXPECTED VALUE(EXPECTATION or MEAN)
# of a discrete random variable X is
#     E[X] = Σx.x*Pr{X=x}                                          C.20*******
# which is well defined if the sum is finite or converges absolutely.
#   Sometimes  E[X] is μx  or just  μ
# [exmp] you flip two fair coins. You earn $3 for each head but lose $2 for each
# tail. The EXPECTED VALUE of the random.var X representing your earnings is
#   E[X] = 6*Pr{2H's} + 1*Pr{1H,1T} - 4*Pr{2T's}
#        = 6(1/4)     + 1(1/2)      - 4(1/4)      = 1
# 
#   E[X+Y] = E[X] + E[Y], whenever E[X], E[Y] are defined          C.21********
# We call this PROPERTY LINEARITY OF EXPECTATION, it holds even if X, Y are
# NOT INDEPENDENT. It also extends to finite and absolutely convergent
# summations of expectations. Linearity of expectation is the key property that
# enables us to perform probabilistic analyses by using INDICATOR RANDOM
# VARIABLES (see Section 5.2)
#   X - any random.var, any func g(x) defines a new random.var g(X).
#  if expectation of g(X) is defined  =>
#                                         E[g(X)] = Σx.g(x)*Pr{X=x}
# Letting g(x) = ax, we have for any constant a,
#     E[aX] = aE[X]                                                 C.22*******
# Expectations are linear: for any random.vars X, Y and any constant a,
#     E[aX+Y] = aE[X] + E[Y]                                        C.23*******
# When X and Y are independent and each has a defined expectation,
#   E[XY] = Σx.Σy.x*y*Pr{X=x and Y=y}
#         = Σx.Σy.x*y*Pr{X=x}Pr{Y=y}
#         = (Σx.x*Pr{X=x})(Σy.y*Pr{Y=y}) = E[X]E[Y]
# In general, when n random.vars X1,X2,..,Xn are mutually independent,
#   E[X1,X2,..,Xn] = E[X1]E[X2]..E[Xn]      C.24*******
# When a random.var X takes on vals from the set of naturals N={0,1..} we have
# a nice formula for its expectation
#   E[X] = Σ.i=0.∞.i*Pr{X=i}
#        = Σ.i=0.∞.i*(Pr{X>=i} - Pr{X>=i+1})
#        = Σ.i=0.∞.Pr{X>=i}                     C.25*******
# since each term Pr{X>=i} is added in i times and subtracted out i-1 times
# (except Pr{X>=0}, which is added in 0 times and not subtracted out at all).
# When we apply a convex function f(x) to a random.var X, JENSEN’S INEQUALITY
# gives us
#     E[f(X)] >= f(E[X])      C.26*******
# provided that the expectations exist and are finite.
# [A func f(x) is CONVEX if for all x,y and for all 0 <= λ <= 1, we have ...
#  f(λx + (1 - λ)y) <= λf(x) + (1 - λ)f(y). ]

# [exmp: book from internet]
# A die is rolled once. Rand.var X is a number on a some side, 
# We assign rand.var to every `sample`(elem.event) in sample space.
#       Ω = {1,2,3,4,5,6}           Ω is sample space | E is some event
# E = {2,4,6} - E == result of role is even   or    X is even
# m(i) = 1/6 - it's DISTRIBUTION FUNC
# P(E) = ∑.ω∈E..m(ω)    - Probability of E
# P({ω}) = m(ω)
# [from me] in this book sample space is set of rand.vars each of which denotes
# some `sample`(elem.event)

# VARIANCE and STANDARD DEVIATION
# [exmp] Given Pr{X=1/4} = Pr{X=3/4} = 1/2
#              Pr{Y=0}   = Pr{Y=1}   = 1/2  => both E[X],E[Y] == 1/2,
#   yet the actual values taken on by Y are farther from the MEAN than the
#   actual values taken on by X
#
# The notion of VARIANCE mathematically expresses how far from the MEAN a
# rando.var’s values are likely to be. The VARIANCE of a random.var X with
# MEAN E[X] is
#   Var[X]  =  E[(X - E[X])^2]
#           =  E[X^2 - 2XE[X] + E^2[X]]
#           =  E[X^2] - 2E[XE[X]] + E^2[X]
#           =  E[X^2] - 2E^2[X]   + E^2[X]                        C.27******
#           =  E[X^2] - E^2[X]
# To justify the equality E[E^2[X]] = E^2[X], note that because E[X] is a real
# numb and not a random variable, so is E^2[X]. The equality E[XE[X]] = E^2[X]
# follows from equation (C.22), with a = E[X].  Rewriting equation (C.27) yields
# an expr for the expectation of the square of a random variable
#     E[X^2] = Var[X] + E^2[X]                                    C.28******
#
# The variance of a rand.var X and the variance of aX are related
#   Var[aX] = a^2*Var[X]
# When X and Y are INDEPENDENT rand.vars,
#   Var[X+Y] = Var[X] + Var[Y]
# In general, if n random variables X1,X2..Xn are PAIRWISE INDEPENDENT, then
#   Var[Σ.i=1.n Xi]   =   Σ.i=1.n Var[Xi]                         C.29******
# The STANDARD DEVIATION of a rand.var X is the nonnegative square root of the
# VARIANCE of X . The standard deviation of a rand.var X is sometimes denoted
# σX or simply σ. => VARIANCE of X is σ^2

# The GEOMETRIC and BINOMIAL DISTRIBUTIONS
#
# BERNOULLI TRIAL is an experiment with only two possible outcomes: @success,
# which occurs with probability p, and @failure, which occurs with probability
# q = 1-p. When we speak of BERNOULLI TRIALS collectively, we mean that the
# trials are mutually independent and, unless we specifically say otherwise,
# that each has the same probability p for @success.
#     2 distributions arise from Bernoulli trials:
#                   the GEOMETRIC DISTRIBUTION and the BINOMIAL DISTRIBUTION.
#
#          The GEOMETRIC DISTRIBUTION
# We have a seq of Bernoulli trials, each with a probability p of success and a
# probability q= 1-p of failure. How many trials occur before we obtain a
# success? Rand.var X - the number of trials needed to obtain a success.
# Then X has vals in the range {1,2...}, and for k >= 1
#     Pr{X=k} = q^(k-1)*p                <<----------------|      C.31*******
# since we have k-1 failures before the one success        |
#             GEOMETRIC DISTRIBUTION       ----------------|
# Assuming that q < 1 the EXPECTATION of a geometric distribution
#     E[X]  = Σ.k=1.∞ k*q^(k-1)*p
#           = p/q * Σ.k=1.∞ k*q^k
#           = p/q * (q / (1-q)^2)
#           = p/q * q/p^2         =   1/p                         C.32********
# Thus, on average, it takes 1/p trials before we obtain a success, an intuitive
# result.  The variance is ..
#    Var[X] = q / p^2                                             C.33********
# [exmp] We repeatedly roll 2 dice until we obtain either 7 or 11. Of the 36
# possible outcomes 6 yields 7, 2 yields 11  ==>  p = 8/36 = 2/9, and we must
# roll  1/p = 9/2 = 4.5 times on average to obtain 7 or 11.
#
#          The BINOMIAL DISTRIBUTION
# How many successes occur during n Bernoulli trials, where
# p - probability of @success, q = 1-p - probability of @failure ?
# Rand.var X - the number of successes in n trials ==>
# X has vals in the range {0,1..n}, and for k = 0,1,..n 
#     Pr{X=k}  = (n\k)*p^k*q^(n-k)            <<-----------------| C.34********
# since there are (n\k) ways to pick which k of the n trials are |
# successes, and the probability that each occurs is p^k*q^(n-k) |
#           BINOMIAL DISTRIBUTION             -------------------|
# FAMILY of ^^^:
#           b(k;n,p) = (n\k)*p^k*(1-p)^(n-k)                       C.35********
# The name "binomial" comes from the right-hand side of equation(C.34) being the
# kth term of the expansion of (p+q)^n.
# Consequently, since p+q = 1
#                             Σ.k=0.n b(k;n,p) = 1                 C.36********
#     as axiom 2 of the probability axioms requires.
# We can compute the EXPECTATION of a rand.var having a binomial distribution
# from equations (C.8),(C.36). X - rand.var that follows the binomial
# distribution b(k;n,p), and q = 1-p. By the definition of EXPECTATION, we have
#   E[X]  = Σ.k=0.n k*Pr{X=k}
#         = Σ.k=0.n k*b(k;n,p)
#         = Σ.k=1.n k*(n\k)*p^k*q^(n-k)
#         = n*p* Σ.k=1.n (n-1\k-1)*p^(k-1)*q^(n-k)  [by eq. C.8]
#         = n*p* Σ.k=0.n (n-1\k)*p^k*q^(n-1-k)
#         = n*p* Σ.k=0.n-1 b(k;n-1,p)
#         = n*p     [by eq. C36]                                    C.37*******
# p.s.
#   (n\k) = n/k * (n-1\k-1)   for 0 < k <= n      C.8******
n, p, q, res  = 15, 1/3, 2/3, []
for k in 1:n                              # << exmp from book:p1204
    nk = fact(n) / fact(n-k) / fact(k)
    push!(res, nk * p^k*q^(n-k))
end; reduce(+, map(*, res, 1:n)) # => 5
# By using the LINEARITY OF EXPECTATION, we can obtain the same result with
# substantially less algebra. X - the rand.var describing the number of
# successes in the ith trial ==> E[Xi] = p*1 + q*0 = p, and by LINEARITY OF
# EXPECTATION(eq. C21), the expected number of success for n trials is
#   E[X] = E[Σ.i=1.n Xi]
#        = Σ.i=1.n E[Xi] = Σ.i=1.n p = n*p.                         C.38*******
# We can use the same approach to calculate the VARIANCE of the distribution.
# Using eq(C.27), we have Var[Xi] = E[Xi^2] - E^2[Xi]. Since Xi only takes on
# the vals 0 and 1, we have Xi^2 = Xi  ==> E[Xi^2] = E[Xi] = p.   Hence...
#     Var[Xi] = p - p^2 = p(1-p) = p*q.                             C.39*******
# To compute the VARIANCE of X , we take advantage of the independence of the n
# trials; thus, by equation (C.29),
#     Var[X] = Var[Σ.i=1.n Xi]
#            = Σ.i=1.n Var[Xi]
#            = Σ.i=1.n p*q
#            = n*p*q                                                 C.40*******
# the binomial distribution b(k;n,p) increases with k until it reaches the MEAN
# n*p, and then it decreases. We can prove that the distribution always behaves
# in this manner by looking at the ratio of successive terms:
#   b(k;n,p) / b(k-1;n,p) = (n\k)*p^k*q^(n-k)    /  (n\k-1)*p^(k-1)*q^(n-k+1)
#                         = n!*(k-1)!*(n-k+1)!*p / k!*(n-k)!*n!*q
#                         = (n-k+1)*p / k*q
#                         = 1 + (n+1)*p-k / k*q                      C.41*******
# ............ p1206

# FREQUENCY CONCEPT OF PROBABILITY - if a drug is found to be effective 30% of
# the time it is used, we might assign a probability .3 that the drug is
# effective the next time it is used and .7 that it is not effective

#############################################################
# A typical experiment involves several randomly-determined quantities.
# Every possible combination of these randomly-determined quantities is called an
# outcome. The set of all possible outcomes is called the sample space for the 
# experiment
