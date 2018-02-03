# We focus not on the running time of hire_assistant, but instead on the
# costs incurred by interviewing and hiring.
function hire_assistant(n)
    best = 0 # candidate 0 is least-qualified dummy candidate
    for i in 1:n                              # line: 2
        interview_candidate(i) # low cost ci  # line: 3
        if isbetter_candidate(i, best)        # line: 4
            best = i                          # line: 5
            hire(i) # expensive proc ch       # line: 6
        end
    end
end
# 0(ci*n + ch*m) | m is hired peoples
# ch*m is diff with each run of proc
# We often need to find the maximum or minimum value in a sequence by examining 
# each element of the sequence and maintaining a current “winner.” The hiring 
# problem models how often we update our notion of which element is currently 
# winning.

# O(ch*n) - worst case(every candidat hired | every next candidate is better)

# In order to perform a probabilistic analysis, we must use knowledge of, or
# make assumptions about, the DISTRIBUTION of the inputs. Then we analyze our
# algo, computing an AVERAGE-CASE RUNNING TIME, where we take the average over
# the DISTRIBUTION of the possible inputs. Thus we are, in effect, averaging the
# running time over all possible inputs
# For some problems, we may reasonably assume something about the set of all
# possible inputs, and then we can use probabilistic analysis as a technique
# for designing an efficient algorithm and as a means for gaining insight into
# a problem. For other problems, we cannot describe a reasonable input 
# distribution, and in these cases we cannot use probabilistic analysis.
# 
# The ordered list <rank(1),rank(2)..rank(n)> is a permutation of the list
# <1,2..,n> Saying that the applicants come in a random order is equivalent to
# saying that this list of ranks is equally likely to be any one of the n!
# permutations of the nums 1:n.  Alternatively, we say that the ranks form a
# UNIFORM RANDOM PERMUTATION; that is, each of the possible n! permutations
# appears with equal probability.
# We often can use probability and randomness as a tool for algo design and
# analysis, by making the behavior of part of the algorithm random.
#
# We distinguish randomized algorithms from those in which the input is random
# by referring to the running time of them as an EXPECTED RUNNING TIME
# In general, we discuss the AVERAGE-CASE running time when the PROBABILITY
# DISTRIBUTION is over the inputs to the algo, and we discuss the expected
# running time when the algo itself makes random choice

function myrandom(a, b)
    rand_val = parse(Int, "$(time())"[11:13])
    a + div(rand_val,  div(1000 , (b-a+1)))
end

#ex.5.1-2
function random512(a,b)
#   acc = [] for n in a:b;  push!(acc, myrandom(0,1)) end # 0.2 milisec 5kb
    acc = [myrandom(0,1) for _ in a:b]              # 3.6 milisec 323kb
#   sum = let pow = 1,          # iter realization is slightly faster
#             res = 1           # then using 'reduce'
#     for val in acc
#         res += val*pow; pow *= 2
#     end; res
#   end
#   return acc[sum % (b-a+1)]
    let pow = 1 # here 'let' needless, but if function body continues it
        sum = reduce(1, acc) do sum, val # can be useful, to guaranty using
            ret = sum + val * pow # 'pow' only in this part of func
            pow *= 2; ret
        end; acc[sum % (b-a+1)]
    end
end

# INDICATOR RANDOM VARIABLE I{A} associated with event A is
# I{A} = | 1 if A occurs
#        | 0 if A doesn't occurs
# [exmp]
# S = {H,T}, Pr{H} = Pr{T} = 1/2, Xh asociated with H
# E[Xh] = E[I{H}] = 1*Pr{H} + 0*Pr{T} = 1*(1/2) + 0*(1/2) = 1/2
 
# Lemma 5.1: S - simple space, A - event in S, Xa = I{A}  ====>  E[Xa] = Pr{A}
 
# INDICATOR RANDOM VARIABLES give us a simple way to arrive at the result of
# eq.(C.37). In this eq., we compute the number of heads in n coin flips by
# considering separately the probability of obtaining 0 heads, 1 head, 2 heads,
# etc. The simpler method proposed in equation (C.38) instead uses indicator 
# random variables implicitly

# E[Xi] = 1 / i                                                       (5.4)

# E[X] = E[Σ.i=1.n Xi] = Σ.i=1.n E[Xi] = Σ.i=1.n 1/i = ln_n + O(1)    (5.5)

# Lemma 5.2
# Assuming that the candidates are presented in a random order, algo
# HIRE-ASSISTANT has an average-case total hiring cost of O(c_h ln_n)

# The average-case hiring cost is a significant improvement over the worst-case
# hiring cost of O(c_h*n)

# Lemma 5.3
# The expected hiring cost of the procedure RANDOMIZED-HIRE-ASSISTANT is
# O(c_h ln_n)
function randomized_hire_assistant(n)
    seq = randomly_permute(1:n)
    hire_assistant(seq)
end
