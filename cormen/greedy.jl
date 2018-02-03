    using Base.Collections
#   # sil'nye ruky,
#   # gar9cree serdce(zhelanie zhat' na gaz, hot' tam kakie problemy),
#   # holodnyi razum(ne parit' golovu der'mom)
#   
#   # c(i,j) = | 0                                    if Sij =  []
#   #          | max.ak∈Sij { c[i,k] + c[k,j] + 1 }   if Sij != []
#   
#   const s = [1,3,0,5,3,5,6,8,8,2,12]
#   const f = [4,5,6,7,9,9,10,11,12,14,16]
#   const l = length(s)
#   const r = zeros(Int, (l,l))
#   
#   function activity_selection_rec(i::Int, j::Int)
#       i >  j && return []
#       i == j && return i
#   
#       _res = []
#       for k in i:j
#           _i = _j = k
#           while _i >= i && f[_i] > s[k];  _i -= 1 end
#           while _j <= j && s[_j] < f[k];  _j += 1 end
#           lft = activity_selection_rec(i, _i)
#           rgt = activity_selection_rec(_j, j)
#           res = [lft, k, rgt]
#           length(res) > length(_res) && (_res = res)
#       end
#       return _res
#   end
#   
#   function activity_selection_dyn(b::Bool)
#       for i   = 1:l;   r[i,i] = (b ? 1 : f[i] - s[i])  end
#       for lvl = 0:l-1, i = 1:l-lvl
#           j = i+lvl 
#           for k in i:j
#               _i = _j = k
#               while _i >= i && f[_i] > s[k];    _i -= 1 end
#               while _j <= j && s[_j] < f[k];    _j += 1 end
#               lft = (_i<i ? 0: r[i,_i]) + r[k,j]
#               rgt = r[i,k] + (_j>j ? 0 : r[_j,j])
#               r[i,j] = lft > rgt ? lft : rgt
#           end
#       end
#       res1, tmp = Int[], typemin(Int)
#       for j = 1:l;    tmp != r[1,j] && (push!(res1,j); tmp = r[1,j]) end
#       return res1
#   end
#   
#   #       r1 = activity_selection_rec(1, l)
#   #       r2 = activity_selection_dyn(true)
#   
#   #       Theorem 16.1
#   # Consider any nonempty subproblem Sk, and let a_m be an activity in Sk with the
#   # earliest finish time. Then a_m is included in some maximum-size subset of 
#   # mutually compatible activities of Sk
#   #       Proof
#   # Let Ak be a max-size subset of mutually compatible activities in Sk, and let
#   # a_j be the activity in Ak with the earliest finish time. If a_j=a_m , we are
#   # done, since we have shown that a m is in some max-size subset of mutually
#   # compatible activities of Sk. If a_j!=a_m, let the set A'k= Ak-{a_j}∪{a_m} be
#   # Ak but substituting a_m for a_j. The activities in Ak are disjoint, which
#   # follows because the activities in A_k are disjoint, a_j is the first activity
#   # in Ak to finish, and f_m <= f_j. Since |A'k| = |Ak|, we conclude that A'k is 
#   # a max-size subset of mutually compatible activities of Sk, and it includes a_m
#   # from_me:
#   # @@ prostimi slovami: esli dazhe aj v Ak ne samyi pervyi, my spokoino mozhem
#   # @@ ego pomen9t' na pervyi s Sk, i ot etogo nichego ne pomen9ets9
#   
#   # we also can select the last activity to start instead of 1 to finish
#   function activity_selection_gr(n::Int)
#       res = [1]
#       k   = 1
#       for m = 2:n
#           s[m] >= f[k] && (push!(res, m); k = m)
#       end
#       res
#   end
#   # activity_selection_gr(l)
#   
#   # from me: fib is the simplest exmp of greedy algo
#   
#   
#   # Elements of greedy strategy   p423
#   # A greedy algo obtains an optimal solution to a problem by making a seq of
#   # choices. At each decision point, the algo makes choice that seems best at the
#   # moment. This heuristic strategy does not always produce an optimal solution,
#   # but as we saw in the activity-selection problem, sometimes it does.
#   
#   # The first key ingredient is the GREEDY-CHOICE PROPERTY: we can assemble a
#   # globally optimal solution by making locally optimal (greedy) choices. In other
#   # words, when we are considering which choice to make, we make the choice that 
#   # looks best in the current problem, without considering results from
#   # subproblems. The choice made by a greedy algorithm may depend on choices so
#   # far, but it cannot depend on any future choices or on the solutions to
#   # subproblems. Of course, we must prove that a greedy choice at each step yields
#   # a globally optimal solution(like Theor.16.1). We can usually make the greedy
#   # choice more efficiently than when we have to consider a wider set of choices.
#   # For example, in the activity-selection problem, as suming that we had already
#   # sorted the activities in monotonically increasing order of finish times, we
#   # needed to examine each activity just once(or sort items in fractional knapsack
#   # probl in "most expensive" order).   By preprocessing the input or by using an
#   # appropriate data structure (often a priority queue), we often can make greedy
#   # choices quickly, thus yielding an efficient algo.
#   
#   # Because both the greedy and dynamic-programming strategies exploit optimal
#   # substructure, you might be tempted to generate a dyn-programming solution to a
#   # problem when a greedy solution suffices or, conversely, you might mistakenly 
#   # think that a greedy solution works when in fact a dynamic-programming solution 
#   # is required
#   #      /\
#   #     /__\    the problem, in which we use dynamic programming, is that we have
#   #    /\   \   too much base.cases and we should pick some of them, what is most
#   #   /__\___\  appropriate, and greedy strategy is applicable when we can CHOOSE
#   #  /\       \ ONE OF THEM INDEPENDENTLY OF OTHERS
#   # /__\_______\
#   
#   ########   0-1 knapsack problem(0-1 since it can either take or leave item)
#   # fractional knapsack problem - the thief can take fractions of items
#   # Both knapsack problems exhibit the optimal-substructure property
#   # from me:
#   # we can use greedy str-gy in fractional pr, but not in 0-1, since in fractional
#   # we can locally(without analysing rest of probl) choose one of best base
#   # cases(here we make decision based on "value"(cennost') of item, that is we no
#   # need to analyze rest of problem(GREEDY-CHOICE PROPERTY) to make decision as 
#   # opposed to 0-1 probl)
#   const vs      = [3,4,5,6]      # value(prices)
#   const ws      = [2,3,4,5]      # weight
#   const iam     = length(ws)     # items amount
#   const maxw    = 5              # knapsack capacity
#   
#   function knapsack_01_rec1(n::Int, w::Int)  # << fail
#       (n > iam || ws[n] > w) && return [0] 
#       reduce([0], n:iam) do max, i                           # << @@@@@1
#           if ws[i] > w
#               max
#           else
#               lst = knapsack_01_rec1(i+1, w-ws[i])
#               res = vs[i] + reduce(+, lst)
#               res > reduce(+, max) ? [vs[i]; lst] : max
#           end
#       end
#   end # V--^-- it's similar to Ian.And.Th.1.4(ii)p14
#   function knapsack_01_rec2(n::Int, w::Int)
#       (n > iam || ws[n] > w)   &&   return [0]
#       lst1 = knapsack_01_rec2(n+1, w) # < this call like iteration in @@@@@1
#       lst2 = knapsack_01_rec2(n+1, w-ws[n])
#       r1, r2 = reduce(+, lst1), reduce(+, lst2) + vs[n]
#       r1 > r2 ? lst1 : [vs[n]; lst2]
#   end
#   
#   # the troube is:
#   # that as opposed to activity-select.probl where result looks like:  (e-event)
#   # we have events [e1, e2, e3, e4, e5], best case is:
#   # max(best(e1)+best(e1:5), best(e1:2)+best(e3:5), best(e1:3)+best(e4:5) ..)
#   # whereas in knapsack.probl this doesn't work since
#   # best(w1) + best(w2:5) depends on whether we pick item in w1 or don't, that is
#   # we return val not only on "combine" step(as in all problmes solved so far),
#   # but pass diff val(here remaining weight) on "divide" step
#   
#   # const vs      = [3,4,5,6]      # values(prices)
#   # const ws      = [2,3,4,5]      # weight
#   function knapsack_01_net()  # from internet
#       s = zeros(Int, (iam+1, maxw+1))
#       for i = 2:iam+1, w = 1:maxw+1
#           if      ws[i-1] < w # item 'i' can be part of solution
#               &&  vs[i-1] + s[i-1,w-ws[i-1]] > s[i-1,w]
#   
#               s[i,w] = vs[i-1] + s[i-1, w-ws[i-1]]
#           else
#               s[i,w] = s[i-1, w]
#           end
#       end
#       s
#   end
#   
#   # Ex.16.2-3.p427
#   # here greedy strategy works, since the smallest items is most "expensive", so,
#   # se just place items in knapsack in order of its weight growing
#   
#   #### Huffman
#   # We consider here only codes in which no codeword is also a prefix of some
#   # other codeword. Such codes are called PREFIX CODES
#   # The decoding process needs a convenient representation for the prefix code so
#   # that we can easily pick off the initial codeword.
#   # An optimal code for a file is always represented by a FULL bin.tree, in
#   # which every nonleaf node has two children
#   
#   # For each character c in the alphabet C , let the attribute c.freq denote the
#   # frequency of c in the file and let dT(c) denote the depth of c's leaf in the
#   # tree. Note that dT(c) is also the length of the codeword for character c.
#   # The number of bits required to encode a file is thus
#   # B(T) = ∑.c∈C. c.freq * dT(c)              <<< cost of the tree      (16.4)

# const pq = Dict{Int, Any}(
#     10 => 'a', 25 => 'b', 5  => 'c', 20 => 'd', 33 => 'e')

left{T,K}(t::Tuple{T,K})  = t[0]
right{T,K}(t::Tuple{T,K}) = t[1]
left!{T,K}(t::Tuple{T,K},   v::T) = t[0] = v
right!{T,K}(t::Tuple{T,K},  v::K) = t[1] = v
const pq = PriorityQueue(Any, Int)
pq['a'] = 10
pq['b'] = 25
pq['c'] = 5
pq['d'] = 20
pq['e'] = 33

function huffman(q)
    n = length(q)
    # q = PriorityQueue(c)  # min-priority.queue
    q.xs = heapify(q.xs)
    for i = 1:n-1
        x, xfreq = peek(q)
        dequeue!(q)
        y, yfreq = peek(q)
        dequeue!(q)
        z = (x, y)
        enqueue!(q, z, xfreq + yfreq)
    end
    dequeue!(q)
end

huffman(pq)
