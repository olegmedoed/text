# The quicksort algo has a worst-case running time of Θ(n^2) on an input array
# of n nums. Despite this slow worst-case running time, quicksort is often the
# best practical choice for sorting because it is remarkably efficient on the 
# average: its expected running time is Θ(n*lg_n), and the constant factors
# hidden in the Θ(n*lg_n) notation are quite small. It also has the advantage of 
# sorting in place, and it works well even in virtual-memory environments.
# Here is the 3-step div'n'conq process for sorting a typical subarray A[p..r]
# * Divide: Partition(rearrange) the arr A[p..r] into two(possibly empty) subarrs
#   A[p..q-1] and A[q+1..r] such that each el of A[p..q-1] <= A[q] <= A[q+1..r].
#   Compute the index q as part of this partitioning proc.
# * Conquer: Sort the 2 subarrs A[p..q-1] and A[q+1..r] by recursive calls to
#   quicksort.
# * Combine: Because the subarrs are already sorted, no work is needed to combine
#   them: the entire array A[p..r] is now sorted.

function partition!(arr, p, r)
    x = arr[r] # line:1
    i = p-1
    for j = p:(r-1)
        if arr[j] <= x
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
        end
    end
    arr[i+1], arr[r] = arr[r], arr[i+1]
    return i+1
end
# At the beginning of each iteration of the loop, for any array index k:
# 1. If p <= k <= i, then A[k] <= x.
# 2. If i+1 <= k <= j-1, then A[k] > x.
# 3. If k = r, then A[k] = x.
# The indices between j and r-1 are not covered by any of the three cases, and
# the values in these entries have no particular relationship to the pivot x.
#
#**Init-tion: Prior to the 1 it-tion of the loop, i=p-1 and j=p. Because no vals
# lie between p and i and no values lie between i+1 and j-1, the first two
# conditions of the loop invariant are trivially satisfied. The assignment in
# line 1 satisfies the third condition.
#**Maintenance: we consider two cases, depending on the outcome of the test in
# line 4. When A[j] > x; the only action in the loop is to increment j. After j
# is incremented, condition 2 holds for A[j-1] and all other entries remain
# unchanged. When A[j] <= x; the loop increments i, swaps A[i] and A[j], and
# then increments j. Because of the swap, we now have that A[i] <=  x, and
# condition 1 is satisfied. Similarly, we also have that A[j-1] > x, since the
# item that was swapped into A[j-1] is, by the loop invariant, greater than x.
#**Termination: At termination, j = r. Therefore, every entry in the array is in
# one of the three sets described by the invariant, and we have partitioned the
# vals in the array into three sets: those <= to x, those > than x, and a
# singleton set containing x.
#
# The final two lines of PARTITION finish up by swapping the pivot element with
# the leftmost el > x, thereby moving the pivot into its correct place in the
# partitioned array, and then returning the pivot's new index. The output of
# PARTITION now satisfies the specifications given for the divide step. In fact,
# it satisfies a slightly stronger condition: after line 2 of QUICKSORT, A[q] is
# strictly < then every el of A[q+1..r].
# The running time of PARTITION on the subarray A[p..r] is Θ(n), where n=r-p+1
function quicksort!(arr, p, r)
    if p < r
        q = partition!(arr, p, r)
        quicksort!(arr, p, q-1)
        quicksort!(arr, q+1, r)
    end
    return nothing
end

################################
function mypartition!(arr, p, r)
    mid = p + div(r-p+1, 2)
    x   = div(arr[p] + arr[r] + arr[mid], 3)
    piv = p
    for i = p:r
        if arr[i] <= x
            arr[piv], arr[i] = arr[i], arr[piv]
            piv += 1
        end
    end
    return piv > r ? mid : piv
end

function myquicksort!(arr, p, r)
    if p < r
        piv = mypartition!(arr, p, r)
        myquicksort!(arr, p, piv-1)
        myquicksort!(arr, piv, r)
    end
end

# Performance of quicksort
#
# The running time of quicksort depends on whether the part-ning is balanced or
# unbalanced, which in turn depends on which els are used for partitioning. If
# the partitioning is balanced, the algo runs asymptotically as fast as merge
# sort. If the part-ning is unbalanced, however, it can run asymptotically as
# slowly as insertion sort. In this section, we shall informally investigate how
# quicksort performs under the assumptions of balanced vs unbalanced part-ning
#
#     Worst-case partitioning
# partitioning routine produces one subproblem with n-1 els and one with 0 el.
#     T(n) = T(n-1) + T(0) + Θ(n) = T(n-1) + Θ(n) = Θ(n^2).
# Moreover, the Θ(n^2) running time occurs when the input array is already
# completely sorted - a common situation in which insertion sort runs in O(n)
# time.(in my version it will be Θ(n*lg_n), since I don't take first el, but
#                                                             average of 3 els)
#     Best-case partitioning
# PARTITION produces two subproblems, each of size no more than n/2, since one
# is of size |_n/2_| and one of size |^n/2^|-1
#       T(n) = 2T(n/2) + Θ(n) = Θ(n*lg_n)
# where we tolerate the sloppiness from ignoring the floor and ceiling and from
# subtracting 1. 
#
#     Balanced partitioning
# The average-case running time of quicksort is much closer to the best case
# than to the worst case, as the analyses will show. SEE(image p175)
#   Suppose, for exmp, that the part-ning algo always produces a 9-to-1 split,
# which at first blush seems quite unbalanced. We then obtain the recurrence
#     T(n) = T(9n/10) + T(n/10) + cn
# where we have explicitly included the constant c hidden in the Θ(n) term
# Notice that every level of the tree has cost cn, until the recursion reaches a 
# bound-ary condition at depth log_10.n = Θ(lg_n), and then the levels have cost
# at most cn. The recursion terminates at depth log_10/9.n = Θ(lg_n). The total 
# cost of quick-sort is therefore O(n*lg_n). Thus, with a 9-to-1 proportional
# split at every level of recursion, which intuitively seems quite unbalanced,
# quicksort runs in O(n*lg_n) time - asymptotically the same as if the split
# were right down the middle. Indeed, even a 99-to-1 split yields an O(n*lg_n)
# running time. In fact, any split of constant propor-lity yields a recursion
# tree of depth Θ(lg_n), where the cost at each level is O(n). The running time
# is therefore O(n*lg_n) whenever the split has constant proportionality.

# Intuition for the average case
#   To develop a clear notion of the randomized behavior of quicksort, we must
# make an assumption about how frequently we expect to encounter the various 
# inputs.  The behavior of quicksort depends on the relative ordering of the 
# vals in the array els given as the input, and not by the particular values in 
# the array. As in our probabilistic analysis of the "hiring problem", we will 
# assume for now that all permutations of the input numbers are equally likely.
#   When we run quicksort on a random input array, the partitioning is highly
# unlikely to happen in the same way at every level, as our informal analysis
# has assumed.We expect that some of the splits will be reasonably well balanced 
# and that some will be fairly unbalanced. [exmp] Ex 7.2-6 asks you to show that
# about 80% of the time PARTITION produces a split that is more balanced than 
# 9 to 1, and about 20% of the time it produces a split that is less balanced
# than 9 to 1.
#             Fig 7.5 on p177
# (a)  n                         (b)  n   ===> Θ(n)
#    /   \   ==> Θ(n)               /   \
#   0    n-1                    (n-1)/2  (n-1)/2
#       /   \
# (n-1)/2-1  (n-1)/2
# (a)
#   The partitioning at the root costs n and produces a “bad” split: 2
#   subarrays of sizes 0 and n-1. The partitioning of the subarray of size n-1
#   costs n-1 and produces a “good” split: subarrays of size (n-1)/2 -1 and
#   (n-1)/2.
# (b)
#   Recursion tree that is very well balanced. In both parts, the partitioning 
#   cost for the subproblems shown with elliptical shading is Θ(n). Yet the
#   subproblems remaining to be solved in (a), shown with square shading, are no
#   larger than the corresponding subproblems remaining to be solved in (b).
#
#   In a recursion tree for an average-case execution of PARTITION, the good and
# bad splits are distributed randomly throughout the tree. Suppose, for the sake
# of intuition, that the good and bad splits alternate levels in the tree, and
# that the good splits are best-case splits and the bad splits are worst-case
# splits. Fig 7.5(a) shows the splits at 2 consecutive levels in the recursion 
# tree. At the root of the tree, the cost is n for partitioning, and the
# subarrays produced have sizes n-1 and 0: the worst case. At the next level,
# the subarray of size n-1 undergoes best-case partitioning into subarrays of
# size (n-1)/2 - 1 and (n-1)/2. Let’s assume that the boundary-condition cost
# is 1 for the subarray of size 0.
#   The combination of the bad split followed by the good split produces 2
# sub-arrays of sizes 0, (n-1)/2 - 1 and (n-1)/2 at a combined partitioning cost
# of Θ(n) + Θ(n-1) = Θ(n). Certainly, this situation is no worse than that in
# Figure 7.5(b), namely a single level of partitioning that produces 2 subarrays
# of size (n-1)/2, at a cost of Θ(n). Yet this latter situation is balanced!
# Intuitively, the Θ(n-1) cost of the bad split can be absorbed into the Θ(n)
# cost of the good split, and the resulting split is good. Thus, the running
# time of quicksort, when levels alternate between good and bad splits, is like
# the running time for good splits alone: still Θ(n*lg_n), but with a slightly
# larger constant hidden by the O-notation.  We shall give a rigorous analysis
# of the expected running time of a randomized version of quicksort
# Ex 7.2-5
# Suppose that the splits at every level of quicksort are in the proportion
# 1-α to α, where 0 < α <= 1/2 is a constant. Show that the minimum depth of
# a leaf in the recursion tree is approximately lg_n/lg_α and the maximum depth
# is approximately lg_n/lg(1-α) (Don’t worry about integer round-off.)
# Ex 7.2-6
# Argue that for any constant 0 < α <= 1/2, the probability is approximately
# 1-2α that on a random input array, PARTITION produces a split more balanced
# than 1-α to α

# A randomized version of quicksort
#
# In exploring the average-case behavior of quicksort, we have made an assumpt.
# that all permutations of the input nums are equally likely. In an engineering
# situation, however, we cannot always expect this assumption to hold [exmp]
#   In case of sorting the almost-sorted input the proc INSERTION-SORT would
#   tend to beat the procedure QUICKSORT.   V-(Ch.5.3 Randomized algos)
# As we saw in we can sometimes add randomization to an algo in order to obtain
# good expected performance over all inputs. Many people regard the resulting
# randomized version of quicksort as the sorting algo of choice for large enough
# inputs.
# In Ch.5.3, we randomized our algorithm by explicitly permuting the input. We
# could do so for quicksort also, but a diff randomization technique, called
# random sampling, yields a simpler analysis. Instead of always using A[r] as
# the pivot, we will select a randomly chosen el from the subarray A[p..r].
# We do so by first exchanging el A[r] with an el chosen at random from A[p..r].
# By randomly sampling the range p,..,r, we ensure that the pivot el x = A[r] is
# equally likely to be any of the r-p+1 els in the subarray. Because we randomly
# choose the pivot el, we expect the split of the input array to be reasonably
# well balanced on average.

function randomized_partition!(arr, p, r)
    i = rand(p:r)
    arr[r], arr[i] = arr[i], arr[r]
    return partition!(arr, p, r)
end

function randomized_quicksort(arr, p, r)
    if p < r
        q = randomized_partition!(arr, p, r)
        randomized_quicksort!(arr, p, q-1)
        randomized_quicksort!(arr, q+1, r)
    end
end

# Ex 7.3-2
# When RANDOMIZED-QUICKSORT runs, how many calls are made to the random-number
# generator RANDOM in the worst case? How about in the best case? Give your
# answer in terms of Θ-notation.

# Worst-case analysis ......... (don't finished) p180
