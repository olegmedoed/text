##################### AMORTIZED ANALYSIS #############################

# In an AMORTIZED ANALYSIS, we average the time required to perform a seq of
# data-structure opers over all the opers performed. With amortized analysis,
# we can show that the average cost of an oper is small, if we average over a
# seq of opers, even though a single oper within the seq might be expensive.
# Amortized analysis differs from average-case analysis in that probability is
# not involved; an amortized analysis guarantees the AVERAGE PERFORMANCE OF EACH
# OPER IN THE WORST CASE.

##################      AGREGATE ANALYSIS

# In aggregate analysis, we show that for all n, a seq of n operations takes
# worst-case time T(n) in total. In the worst case, the average cost, or
# amortized cost, per oper is therefore T(n)/n. Note that this amortized cost
# applies to each oper, even when there are several types of opers in the seq.
# The ACCOUNTING METHOD and the POTENTIAL METHOD, may assign diff amortized
# costs to different types of opers.

#         stack operations

# Since pop/push runs in O(1) time(AFAIU - Cormen meant lists), let us consider
# the cost of each to be 1. The total cost of a seq of n PUSH and POP opers is
# therefore n, and the actual running time for n opers is therefore Θ(n).
function multipop!(s::Array, k::Int)
    while !isempty(s) && k > 0 (pop!(s); k -= 1) end
end # The actual running time ^-- is linear in the number of POP opers actually
# executed, and thus we can analyze MULTIPOP in terms of the abstract costs of 1
# each for PUSH and POP. The number of iters of the WHILE loop is the number
# min(s,k) of objs popped off the stack. Each iter of the loop makes one call to
# POP. Thus, the total cost of MULTIPOP is min(s,k)
# Let us analyze a seq of n PUSH,POP,MULTIPOP opers on an initially empty stack.
# The worst-case cost of a MULTIPOP oper in the seq is O(n), since the stack
# size is at most n. The worst-case time of any stack oper is therefore O(n),
# and hence a seq of n opers costs O(n^2), since we may have O(n) MULTIPOP 
# opers costing O(n) each. Although this analysis is correct, the O(n^2) result,
# which we obtained by considering the worst-case cost of each oper individually
# , is not tight. In fact, although a single MULTIPOP oper can be expensive, any
# seq of n PUSH,POP,MULTIPOP opers on an initially empty stack can cost at most
# O(n). Since We can pop each obj from the stack at most once for each time we
# have pushed it onto the stack. Therefore, the number of times that POP can be
# called on a nonempty stack, including calls within MULTIPOP, is at most the
# num of PUSH opers, which is at most n. For any val of n, any seq of n PUSH,
# POP, and MULTIPOP opers takes a total of O(n) time. The average cost of an
# oper is O(n)/n = O(1)

#         Incrementing a binary counter

function increment!(s::Array{Bool})
    i = 1
    while i <= length(s) && s[i] == true
        s[i] = false
        i += 1
    end
    i <= length(s) && (s[i] = true)
    nothing    # As with the stack exmp, a cursory analysis yields a bound that
end    # is correct but not tight. A single execution of INCREMENT takes time
# Θ(k) in the worst case, in which array A contains all 1s. Thus, a seq of n
# INCREMENT opers on an initially zero counter takes time O(nk) in the worst
# case. But not all bits flip each time INCREMENT is called(SEE Figure on p455).
# A[0] flips n.times, A[1] flips n/2.times, A[2] flips n/4.times => A[i] flips
# |_n / 2^i_|.     ∑.i=0.k-1 |_n / 2^i_|   <   n * ∑.i=0.∞ 1 / 2^i   =    2n.

# Ex.17.1-3 : Θ(lg_n ^ 2)

#################       THE ACCOUNTING METHOD 

# In the ACCOUNTING meth of AMORTIZED ANALYSIS, we assign differing charges to
# different opers, with some opers charged more or less than they actually cost.
# We call the amount we charge an oper its amortized cost. When an oper's
# amortized cost exceeds its actual cost, we assign the difference to specific
# objs in the data structure as credit. Credit can help pay for later opers
# whose amortized cost is less than their actual cost. Thus, we can view the
# amortized cost of an oper as being split between its actual cost and credit
# that is either deposited or used up. Diff opers may have diff amortized costs.
# This meth differs from AGGREGATE ANALYSIS, in which all opers have the same
# amortized cost.  If we want to show that in the worst case the average cost
# per oper is small by analyzing with amortized costs, we must ensure that the
# total amortized cost of a seq of opers provides an upper bound on the total
# actual cost of the seq. Moreover, as in aggregate analysis, this relationship 
# must hold for all seqs of opers. If we denote the actual cost of the ith 
# oper by c_i and the amortized cost of the ith operation by c__i, we require:
#       ∑.i=1.n c__i >= ∑.i=1.n c_i , ∀ seqs of n opers                 (17.1)
# The total credit stored in the data structure is the difference between the
# total amortized cost and the total actual cost, or:
#       ∑.i=1.n c__i - ∑.i=1.n c_i
# The total credit associated with the data structure must be nonnegative at all
# times. If we ever were to allow the total credit to become negative(the res of
# undercharging early opers with the promise of repaying the account later on),
# then the total amortized costs incurred at that time would be below the total
# actual costs incurred; for the seq of opers up to that time, the total
# amortized cost would not be an upper bound on the total actual cost. Thus, we
# must take care that the total credit in the data structure never becomes
# negative.

#                 stack opers
# recall that: push = 1, pop = 1, multipop = min(k,s)
# let:         push = 2, pop = 0, multipop = 0
# Note that the amortized cost of MULTIPOP is a constant(0), whereas the actual
# cost is variable. In general, the amortized costs of the opers under conside-
# ration may differ from each other, and they may even differ asymptotically.
#   We can pay for any seq of stack opers by charging the amortized costs.
# Suppose we use a dollar bill to represent each unit of cost. We start with an
# empty stack. When we push a item on the stack, we use 1$ to pay the actual cost 
# of the push and are left with a credit of 1$(out of the 2$ charged), which we
# leave on top of the item. At any point in time, every item on the stack has a
# 1$ of credit on it. The 1$ stored on the plate serves as prepayment for the
# cost of popping it from the stack. When we execute a POP oper, we charge the
# oper nothing and pay its actual cost using the credit stored in the stack. To
# pop a item, we take the 1$ of credit off the item and use it to pay the actual
# cost of the oper. Thus, by charging the PUSH oper a little bit more, we can
# charge the POP oper nothing. Moreover, we can also charge MULTIPOP opers
# nothing. Since each plate on the stack has 1$ of credit on it, and the stack
# always has a nonnegative number of items, we have ensured that the amount of
# credit is always nonnegative.

#               Incrementing a binary counter
# For the AMORTIZED ANALYSIS, let us charge an amortized cost of 2$ to set a
# bit to 1. When a bit is set, we use 1$(out of the 2$ charged) to pay for the
# actual setting of the bit, and we place the other 1$ on the bit as credit to
# be used later when we flip the bit back to 0. At any point in time, every 1 in
# the counter has a 1$ of credit on it, and thus we can charge nothing to reset
# a bit to 0; we just pay for the reset with the dollar bill on the bit. Now we
# can determine the amortized cost of INCREMENT. The cost of resetting the bits
# within the WHILE loop is paid for by the dollars on the bits that are reset.
# The INCREMENT proc sets at most one bit, and therefore the amortized cost of
# an INCREMENT oper is at most 2$. The num of 1s in the counter never becomes
# negative, and thus the amount of credit stays nonnegative at all times.

################### THE POTENTIAL METHOD

# Instead of representing prepaid work as credit stored with specific objs in
# the data structure, the potential meth of AMORTIZED ANALYSIS represents the
# prepaid work as "potential energy", or just "potential", which can be released
# to pay for future opers. We associate the potential with the data structure as
# a whole rather than with specific objs within the data structure.

#         .............. p45e
