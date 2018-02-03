# the gist from me: we use vector in "cut_rod" since it make only 1 recur.call,
# and matrix in matr.mult since it make 2 recur.calls

# We can cut up a rod of length n in 2^n-1 different way
# [from.me] that since we have rod --> [ | | | | | ]
# every |-(place where we can cut) we can perceive as bit, so.. as every bit can
# by independently set/unset to represent every number, such rod can be
# independently(simultaneously) cutted in every case.

# rn = max.i<=i<=n.(pi + r(n-i))         (15.2)

# [         | |   |  |    | ]
#  ^prices-^ ^_cut_rod(n-i)^    (prices is biggest monolite first part)
function _cut_rod(prices::Vector{Int}, n::Int)  #              << div-n-conq way
    n == 0 ? 0 : reduce(typemin(Int), 1:n) do prev, i
        max(prev, prices[i] + _cut_rod(prices, n-i))
    end
end #       T(n) = 1 + Σ.j=0.n-1 T(j) = 2^n               (15.3)(15.4)
# from.me:  T(n) = 1 + T(n-1) + T(n-2) .. = 1 + 2*T(n-1)

# A dynamic-programming approach runs in polynomial time when the number of
# distinct subproblems involved is polynomial in the input size and we can solve
# each such subproblem in polynomial time.

# There is 2 equiv. ways to impl dyn.prog approach:
# (1) TOP-DOWN WITH MEMOIZATION
# (2) BOTTOM-UP METHOD

function memoized_cut_rod_aux!(prices::Vector, n::Int, results::Vector,
                                                       s::Vector)
    n == 0          && return 0
    results[n] >= 0 && return results[n]

    results[n] = reduce(typemin(Int), 1:n) do maxprice, i
        price = prices[i] + memoized_cut_rod_aux!(prices, n-i, results, s)
        price > maxprice ? (s[n] = i; price) : maxprice
    end
end
# VVV- it's similar to main.lisp.26, except that mem.._rod_aux is not general
memoized_cut_rod(prices::Vector, n::Int) = 
    memoized_cut_rod_aux!(prices, n, fill(typemin(Int), n), Vector{Int}(n))

# computation is passing in reverse order to cut_rod
function bottom_up_cut_rod(prices::Vector{Int}, n::Int)
    results = Vector{Int}(n+1)
    results[1] = 0  # base case
    for j = 1:n  # here results serve as 'local'-global var to code in for.loop
        results[j+1] = reduce(typemin(Int), 1:j) do prev, i       #  and reduce
            max(prev, prices[i] + results[j-i+1])
        end
    end
    results[n+1]
end

# When we think about a dynamic-programming problem, we should understand the
# set of subproblems involved and how subproblems depend on one another.
# The subproblem graph for the problem embodies exactly this information
#     VVVVVVVVVV
#   ------4           instead of:           v---v--4-v---v
#   |     V                        v---v--v-3 v-2-v  1-v 0
#   |>    3---                v--v-2 v-1  0   1   0    0
#   |     V  |             v--1  0   0
#   |> |- 2  |             0
#   |  |  V  |
#   |> |  1 <|  # [exmp] the subproblem graph contains an edge from x to y if
#   |  |  V  |  # a top-down rec.proc for solving x directly calls itself to
#   |> |> 0 <|  #  solve y. We can think of the subproblem graph as a "reduced"
#               # or "collapsed" version of the rec.tree for the top-down
# rec.method, in which we coalesce all nodes for the same subproblem into a
# single vertex and direct all edges from parent to child.
#   Using the terminology from Ch.22, in a bottom-up dyn-programming algo, we
# consider the vertices of the subproblem graph in an order that is a "reverse
# topological sort" or a "topological sort of the transpose" (see Section 22.4)
# of the subproblem graph. Similarly,  we can view the top-down method (with
# memoization) for dyn-programming as a "depth-first search" of the subproblem
# graph (see Section 22.3). Typically, the time to compute the solution to a
# subproblem is proportional to the degree (num of outgoing edges) of the
# corresponding vertex in the subproblem graph, and the num of subproblems is 
# equal to the num of vertices in the subproblem graph. In this common case, the
# running time of dyn programming is linear in the number of vertices and edges.

function extended_bottom_up_cut_rod(prices::Vector{Int}, n::Int)
    r = Vector{Int}(n+1)
    s = Vector{Int}(n)
    r[1] = 0
    for j = 1:n
        r[j+1] = reduce(typemin(Int), 1:j) do prev, i
            if prev < prices[i] + r[j-i+1] # r[j-i+1] is previous level
                s[j] = i
                prices[i] + r[j-i+1]
            else
                prev
            end
        end
    end
    return r,s
end

function print_cut_rod_solutions(prices::Vector{Int}, n::Int)
    r,s = extended_bottom_up_cut_rod(prices, n)
    while n > 0
        print("$(s[n]) ")
        n = n - s[n]
    end
end

"cut rod with expensive cat: dynamic-programming"
function cut_rod_with_exp_cut_dyn(prices::Vector{Int}, n::Int, cut_price::Int)
    res = Vector{Tuple{Int,Int}}(n+1)
    s = Vector{Int}(n)
    res[1] = (0,0)  # (state, price)
    for j = 1:n
        res[j+1] = reduce( (0, typemin(Int)), 1:j) do prev, i
            cuts, price = res[j-i+1]
            price += prices[i]
            _, _price = prev
            if price > _price
                s[j] = i
                i == j ? (cuts, price) : (cuts+1, price - cut_price)
            else
                prev
            end
        end
    end
    res, s
end

#################### Matrix multiplication #################################

function matrix_mul(a::Matrix, b::Matrix)
    acols, arows = size(a)
    bcols, brows = size(b)
    acols != brows && error("incompatible dimensions")

    c = zeros(Int, bcols, arows)
    for col = 1:bcols, row = 1:arows, k = 1:acols
        c[col,row] += a[col,k]*b[k,row]
    end
    return c
end

# Ecplanation Cor:p373
ms = Array[[1 2; 3 4; 4 5],
           [5 6 4; 8 3 4; 3 5 1; 6 2 3],
           [6 1 3 5; 3 5 3 1; 5 1 2 4]]

# m[i,j] = | 0   if i=j                                     (15,7)
#          | min.i<=k<=j { m[i,k] + m[k+1,j] + pi-1*pk*pj }
# ⎡s*⎤  * << m[1,n] is the result
# ⎣ f⎦  s - start recursion level, f - finish recursion level
# Instead of computing the solution to recurrence (15.7) recursively, we compute
# the optimal cost by using a TABULAR, bottom-up approach
# 
# Ai has dimensions pi-1*pi for i = 1:n
# Its input is a sequence p = <p0,p1..pn>, where p.length = n+1. The proc uses
# an auxiliary table m[1..n,1..n] for storing the m[i,j] costs and another
# auxiliary table s[1..n-1,2..n] that records which index of k achieved the
# optimal cost in computing m[i,j]. We shall use the table s to construct an
# optimal solution    SEE: p376(that figure explain the gist)
function matrix_chain_order(p::Vector{Int})
    n = length(p)-1
    m, s = Matrix{Int}(n,n), Matrix{Int}(n,n)
    for i = 1:n;  m[i,i] = 0  end # m[i,i] - subset with 1 matrix(base case)
    for l = 2:n, i = 1:n-l+1  # l is level of recur, distance from base case
        j = i+l-1
        m[i,j] = typemax(Int)
        for k = i:j-1
            q = m[i,k] + m[k+1,j] + p[i]*p[k+1]*p[j+1]
            if q < m[i,j]
                m[i,j] = q
                s[i,j] = k
            end
        end # Ex 15.2-5 asks you to show that the running time of this algo is
    end     # in fact also Ω(n^3) (main estimation O(n^3))
    return m,s
end 

function lookup_chain(m::Matrix{Int}, p::Vector{Int}, i::Int, j::Int)
    m[i,j] < typemax(Int) && return m[i,j]
    i == j                && return m[i,j] = 0
    for k = i:j-1
        q = lookup_chain(m, p, i, k)   +
            lookup_chain(m, p, k+1, j) + p[i]*p[k+1]*p[j+1]
        q < m[i,j] && (m[i,j] = k)
    end
    return m[i,j]
end
function memoized_matr_chain(p::Vector{Int})
    n = length(p)-1
    m = fill(typemax(Int), (n,n))
    lookup_chain(m,p,1,n)
end

# Although MATRIX-CHAIN-ORDER determines the optimal num of scalar mul-tions
# needed to compute a matrix-chain product, it does not directly show how to
# multiply the matrices. The table s[1..n,2..n] gives us the info we need to do
# so. Each entry s[i,j] records a val of k such that an optimal parenthesization
# of AiAi+1..Aj splits the product between Ak and Ak+1.
function print_optimal_parens(s::Matrix{Int}, i::Int, j::Int)
    if i == j
        print("A$i")
    else
        print("(")
        print_optimal_parens(s, i, s[i,j])
        print_optimal_parens(s, s[i,j] + 1, j)
        print(")")
    end
end

function matrix_chain_mult(ms::Vector{Matrix}, s::Vector{Int}, i::Int, j::Int)
    i == j && return ms[i,j]
    l = matrix_chain_mult(ms, s, i, s[i,j])
    r = matrix_chain_mult(ms, s, s[i,j]+1, j)
    matrix_mul(l, r)
end

m,s = matrix_chain_order([30,35,15,5,10,20,25])
print_optimal_parens(s, 1,6)

# Ex.15.2-5 (hint - pyramid is equal n^3-n / 3)
#  _ _ _ _   _
# |b| | | | |b|_  b-base case, j = i+1
# |___| | | |___|_
# |_____| | |_____|_
# |______o| |______o| o - top of rec.tree i=1, j=n

# Recall that a problem exhibits OPTIMAL SUBSTRUCTURE if an optimal solution to
# the problem contains within it optimal solutions to subproblems. In dynamic
# prog, we build an optimal solution to the problem from optimal solutions
# to subproblems. Consequently, we must take care to ensure that the range of
# subproblems we consider includes those used in an optimal solution.
#
# The second ingredient that an optimization problem must have for dynamic pro-
# gramming to apply is that the space of subproblems must be "small" in the
# sense that a recursive algorithm for the problem solves the same subproblems 
# over and over, rather than always generating new subproblems. When a recursive
# algo revisits the same problem repeatedly, we say that the optimization
# problem has overlapping subproblems. In contrast, a problem for which a
# div'n'conq approach is suitable usually generates brand-new problems at each 
# step of the recursion.



# SEE: p395
# let X = <x1..xm>, Y = <y1..yn>,   Z = <z1..zk> - be any LCS of X,Y
# if xm = yn,  then zk = xm = yn,  and Zk-1 is an LCS of Xm-1, Yn-1
# if xm != yn, then   zk != xm  =>     Z is an LCS of Xm-1, Y
# if xm != yn, then   zk != yn  =>     Z is an LCS of X, Yn-1
function lcs_rec(c::Matrix, b::Matrix,
                 x::String, y::String,
                 i::Int, j::Int)
    # this fucking algo.realization somehow doesn't work correctly
    if i == 0 || j == 0
        []
    elseif x[i] == y[j]
        push!(lcs_rec(c,b,x,y,i-1, j-1), x[i])
    else
        l = lcs_rec(c,b,x,y,i-1, j)
        r = lcs_rec(c,b,x,y,i, j-1)
        if length(l) >= length(r)
            push!(l, y[j])
        else
            push!(r, x[i])
        end
    end
end


function lcs_length(x::String, y::String)
    xl, yl  = length(x)+1, length(y)+1
    b,  c   = fill(' ', (xl,yl)), zeros(Int, (xl,yl))
    for i = 2:xl, j = 2:yl
        if x[i-1] == y[j-1]
            c[i,j] = c[i-1,j-1] + 1
            b[i,j] = '↖'
        elseif c[i-1,j] >= c[i,j-1]
            c[i,j] = c[i-1,j]
            b[i,j] = '↑'
        else
            c[i,j] = c[i,j-1]
            b[i,j] = '←'
        end
    end
    return c,b
end

function print_lcs(b::Matrix{Char}, x::String, i::Int, j::Int)
    (i <= 1 || j <= 1) && return
    if b[i,j] == '↖'
        print_lcs(b, x, i-1, j-1)
        print(x[i-1])
    elseif b[i,j] == '↑'
        print_lcs(b, x, i-1, j)
    else # b[i,j] == '←'
        print_lcs(b, x, i, j-1)
    end
end


x = "abcbdab"
y = "bdcaba"
c, b = lcs_length(x, y)
i, j = size(b)
print_lcs(b, x, i, j)
lcs_rec(c,b,"aba","aab",3,3)


# q = probabiliti of leafs(unsuccessful search)

# contribution is probabiliti of node(pi or qj) * depth of node
# best tree is where sum of contribution of all nodes is smallest

function optimal_bst_rec(p::Vector, q::Vector,
                       # e::Matrix, w::Matrix,
                         i::Int, j::Int, lvl::Int)
    if i > j
        q[j] * lvl, string(lpad("", 4lvl), "q$(j-1)\n")
    else
        res, tree = typemax(Float64), []
        for k = i:j
            lres, l = optimal_bst_rec(p, q, i, k-1, lvl+1)
            rres, r = optimal_bst_rec(p, q, k+1, j, lvl+1)
            if p[k] * lvl + lres + rres < res
                res = p[k] * lvl + lres + rres
                str = lpad("", 4lvl)
                tree = string(string(str, "$lvl: p$(k-1)\n"), l, r)
            end
        end
        res, tree
    end
end

function optimal_bst(p::Vector, q::Vector, n::Int)
    e     = Matrix{Float64}(n+1,n+1)
    w     = Matrix{Float64}(n+1,n+1) # matrix of every node probabilities
    root  = Matrix{Int}(n+1,n+1)
    for i = 1:n+1
        e[i,i] = w[i,i] = q[i]
    end
    for l = 1:n, i = 1:n-l+1 # l - level of recur(distance from base case)
        j = i+l
        e[i,j] = typemax(Float64)
        # V- tree probabilites without taking lvl into account
        w[i,j] = w[i,j-1] + p[j] + q[j] 
        for r = i+1:j
            # lvl is accounted, by adding every node probability at curren lvl
            t = e[i,r-1] + e[r,j] + w[i,j]
            if t < e[i,j]
                e[i,j]    = t
                root[i,j] = r-1
            end
        end
    end
    return e, root
end

p = [0   , 0.15, 0.1 , 0.05, 0.1 , 0.2]
q = [0.05, 0.1 , 0.05, 0.05, 0.05, 0.1]
r,t = optimal_bst_rec(p, q, 2, 6, 1)
print(t)
print(r)
e,r = optimal_bst(p, q, 5)

# dynamic programming is working, since recursive branches like overlap each
# other, but have common basis and identical structure
