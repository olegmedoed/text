# We can choose between two standard ways to represent a graph G = (V,E)
# as a collection of ADJACENCY LISTS or as an ADJACENCY MATRIX.
# Either way applies to both directed and undirected graphs

# Because the adjacency-list representation provides a compact way to represent
# SPARSE graphs—those for which |E| is much less than |V|^2 - it is usually the
# method of choice.
# We may prefer an adjacency-matrix representation, however, when the graph is
# DENSE - |E| is close to |V|^2 - or when we need to be able to tell quickly
# if there is an edge connecting two given vertices.

# For both directed and undirected graphs, the ADJACENCY-LIST representation has
# the desirable property that the amount of memory it requires is Θ(V+E)

# A potential disadvantage of the adjacency-list representation is that it 
# provides no quicker way to determine whether a given edge (u,v) is present in
# the graph than to search for v in the adjacency list Adj[u]


# The algorithm works on both directed and undirected graphs
# Breadth-first search is so named because it expands the frontier between
# discovered and undiscovered vertices uniformly across the breadth of the
# frontier. That is, the algo discovers all vertices at distance k from s before
# discovering any vertices at distance k+1.

type Vertex
    id    ::Int
    color ::Symbol
    d     ::Int
    f     ::Int
    π
    Vertex(id, color=:white, d=typemax(Int), f=typemax(Int), π=nothing) =
        new(id, color, d, f, π)
end
isequal(a::Vertex, b::Vertex) = a.id == b.id
hash(v::Vertex)               = v.id

immutable Graph
    adj     ::Array{Array{UInt}}
    vertexes::Array{Vertex}
end

function bfs(g::Graph, s::Vertex)  # poisk v wirinu
    for u in g.vertexes
        u == s && continue
        u.color, u.d, u.π = :white, typemax(Int), nothing
    end
    s.color, s.d, s.π = :gray, 0, nothing
    q = []
    push!(q, s)   # V-- loop invariant:
# At the test in line 8, the queue Q consists of the set of gray vertices.
    while !isempty(q) # line 8
        u = shift!(q)
        for i in g.adj[u.id]
            v = g.vertexes[i]
            if v.color == :while
                v.color, v.d, v.π = :gray, u.d+1, u
                push!(q, v)
            end
        end
        u.color = :black
    end
end

# Lemma 22.1
# Let G = (V,E) be a directed or undirected graph, and let s∈V be an arbitrary
# vertex. Then, for any edge (u,v) ∈ E,
#   σ(s,v) <= σ(s,u) + 1                  [σ - sigma]

# Lemma 22.2
# Let G = (V,E) be a directed or undirected graph, and suppose that BFS is run
# on G from a given source vertex s∈V. Then upon termination, for each ver-
# tex v∈V , the val v.d computed by BFS satisfies v.d >= σ(s,v)

# Lemma 22.3
# Suppose that during the execution of BFS on a graph G = (V,E), the queue Q
# contains the vertices <v1..vr>, where v1 is the head of Q and vr is the tail.
# Then, vr.d <= v1.d + 1 and vi.d <= vi+1.d for i = 1:r-1

# Corollary 22.4
# Suppose that vertices vi and vj are enqueued during the execution of BFS, and
# that vi is enqueued before vj . Then vi.d <= vj.d at the time that vj is
# enqueued.

# Theorem 22.5 (Correctness of breadth-first search)
# Let G = (V,E) be a directed or undirected graph, and suppose that BFS is run
# on G from a given source vertex s∈V. Then, during its execution, BFS discovers
# every vertex s∈V that is reachable from the source s, and upon termination,
# v.d = σ(s,v) ∀ v∈V. Moreover, for any vertex v != s that is reachable from s,
# one of the shortest paths from s to v is a shortest path from s to v.π
# followed by the edge (v.π, v).

# The procedure BFS builds a breadth-first tree as it searches the graph.
# The tree corresponds to the π attributes. More formally, for a graph G=(V,E)
# with source s, we define the PREDECESSOR SUBGRAPH of G as Gπ = (Vπ, Eπ), where
#     Vπ = { v∈V : v.π != nil } ∪ {s}
# and
#     Eπ = { (v.π, v) : v ∈ Vπ-{s} }

# The predecessor subgraph Gπ is a breadth-first tree if Vπ consists of the
# vertices reachable from s and, for all v∈Vπ, the subgraph Gπ contains a unique
# simple path from s to v that is also a shortest path from s to v in G. A
# breadth-first tree is in fact a tree, since it is connected and |Eπ| = |Vπ|-1 
# (see Theorem B.2:p1174). We call the edges in Eπ TREE EDGES

# Lemma 22.6
# When applied to a directed or undirected graph G = (V,E), procedure BFS con-
# structs π so that the predecessor subgraph Gπ=(Vπ,Eπ) is a breadth-first tree.

# ^-- 601

function print_path(s::Vertex, v::Vertex)
    acc = []
    while true
        unshift!(acc, v.id)
        v = v.π
        v == nothing && break
    end
    for id in acc   print("$id, ") end
end

function bfs_adj_repr(g::Matrix{Bool}, vs::Vector{Vertex}, s::Vertex)
    for v in vs    v.color, v.d, v.π = :white, 0, nothing end
    s.color, s.d, s.π = :gray, 0, nothing
    q = [s]
    gvs = size(g)[1]  # graph vertexes
    while !isempty(q)
        u = shift!(q)
        for (i, isv) in g[u.id, 1:gvs] |> enumerate
            if  isv && vs[i].color == :white
                v = vs[i]
                v.color, v.d, v.π = :gray, u.d + 1, u
                push!(q, v)
            end
        end
        u.color = :black
    end
end

# 22.2-5
# Argue that in a breadth-first search, the val u.d assigned to a vertex u is
# independent of the order in which the vertices appear in each adjacency list.
# Show that the breadth-first tree computed by BFS can depend on the ordering
# within adjacency lists.

# 22.2-7
function babyfaces_vs_heels(m::Matrix{Bool}, vs::Vector{Vertex})
    # all vs is white, d=0, π=nothing
    s       = vs[1]   # randomly peeked babyface
    s.color = :gray 
    vs_lng  = size(vs)[1]
    src = babyfaces = Vertex[s]
    dst = heels = Vertex[]
    orig_hl, orig_bf = Int[], Int[1]
    isbf = true
    while true
        u = shift!(src)
        for (i, isv) in enumerate(m[u.id, 1:vs_lng])
            if isv && vs[i].color == :white
                v = vs[i]
                v.color, v.d, v.π = :grey, u.d+1, u
                push!(dst, v)
                isbf ? push!(orig_hl, v.id) : push!(orig_bf, v.id)
            end
        end
        u.color = :black
        isempty(src) && ((src,dst) = (dst,src); isbf $= true )
        isempty(src) && break
    end
    orig_hl, orig_bf
end


# Gπ = (V, Eπ), where Eπ = { (v.π, v): v∈V and v.π != nil }
# The PREDECESSOR SUBGRAPH of a DEPTH-FIRST SEARCH forms a DEPTH-FIRST FOREST com-
# prising several DEPTH-FIRST TREES. The edges in Eπ are tree edges.
#
# Besides creating a depth-first forest, depth-first search also TIMESTAMPS each 
# vertex. Each vertex v has two timestamps: the first timestamp v.d records when
# v is first discovered (and grayed), and the second timestamp v.f records when
# the search finishes examining v's adjacency list (and blackens v).

# It may seem arbitrary that breadth-first search is limited to only one src
# whereas depth-first search may search from multiple srcs. Although conceptually
# , breadth-first search could proceed from multiple srcs and depth-first search
# could be limited to 1 src, our approach reflects how the results of these
# searches are typically used. Breadth-first search usually serves to find 
# shortest-path distances (and the associated predecessor subgraph) from a given 
# src. Depth-first search is often a subroutine in another algo.

# DFS records when it discovers vertex u in the attr u.d and when it finishes
# vertex u in the attr u.f. These timestamps are ints in 1:2|V|, since there is 
# one discovery event and one finishing event for each of the |V| vertices.
#     ∀ u, u.d < u.f.                               (22.2)
# u is WHITE before time u.d, GRAY between time u.d:u.f, and BLACK thereafter

time = 0
function dfs(g::Graph)
    for u in g.vertexes    u.color, u.π = :white, nothing end
    global time = 0
    for u in g.vertexes    u.color == :white && dfs_visit(g, u) end
end # When DFS returns,
# every vertex u has been assigned a DISCOVERY time u.d and a FINISHING time u.f
function dfs_visit(g,u)
    global time += 1            # white vertex u has just been discovered
    u.d, u.color = time, :gray
    for i in g.adj[u.id]        # explore edge (u,v)
        v = g.vertexes[i]
        if v.color == :white
            v.π = u
            dfs_visit(g, v)
        end   #  +-- blacken u; it is finished
    end       #  V
    u.color = :black    # Note that the results of depth-first search may depend
    time += 1           # upon the order in which line 3 of DFS examines the
    u.f = time          # vertices and upon the order in which line 3 of
end                     # DFS-VISIT visits the neighbors of a vertex.
vs = [ Vertex(i) for i in 1:6]                          # <--+
g  = Graph(Array[[2,4], [5], [5,6], [2], [4], [6]], vs) # <--+-- see Fig on p605
dfs(g)
# structure of the depth-first trees exactly mirrors the structure of recursive 
# calls of DFS-VISIT. Vertex v is a descendant of vertex u in the depth-first
# forest <=> v is discovered during the time in which u is gray.

# Theorem 22.7 (Parenthesis theorem)
# In any depth-first search of a (directed or undirected) graph G = (V,E),
# ∀ two vertices u,v, exactly one of the following three conditions holds:
# * the intervals [u.d,u.f] and [v.d,v.f] are entirely disjoint, and neither u
#   nor v is a descendant of the other in the depth-first forest,
# * the interval [u.d,u.f] is contained entirely within the interval [v.d,v.f],
#   and u is a descendant of v in a depth-first tree, or
# * the interval [v.d,v.f] is contained entirely within the interval [u.d,u.f],
#   and v is a descendant of u in a depth-first tree

# Corollary 22.8 (Nesting of descendants’ intervals)
# Vertex v is a proper descendant of vertex u in the depth-first forest for a 
# (directed or undirected) graph G if and only if u.d < v.d < v.f < u.f.

# Theorem 22.9 (White-path theorem)
# In a depth-first forest of a (directed or undirected) graph G=(V,E), vertex v
# is a descendant of vertex u <=> at the time u.d that the search discovers u,
# there is a path from u to v consisting entirely of white vertices

# We can define 4 edge types in terms of the depth-first forest Gπ produced by
# a depth-first search on G:
# 1. TREE EDGES are edges in the depth-first forest Gπ. Edge (u,v) is a tree
#    edge if v was first discovered by exploring edge (u,v).
# 2. BACK EDGES are those edges (u,v) connecting a vertex u to an ancestor v in
#    a depth-first tree. We consider self-loops, which may occur in directed
#    graphs, to be back edges.
# 3. FORWARD EDGES are those nontree edges (u,v) connecting a vertex u to a 
#    descendant v in a depth-first tree.
# 4. CROSS EDGES are all other edges. They can go between vertices in the same
#    depth-first tree, as long as one vertex is not an ancestor of the other, or
#    they can go between vertices in different depth-first trees.

# The DFS algorithm has enough information to classify some edges as it encoun-
# ters them. The key idea is that when we first explore an edge (u,v), the color
# of vertex v tells us something about the edge:
# 1. WHITE indicates a tree edge,
# 2. GRAY indicates a back edge, and
# 3. BLACK indicates a forward or cross edge.

# (Lemma 22.11)
# directed graph is acyclic <=> a depth-first search yields no "back" edges

function topological_sort(g)
    
end
