import Base.length
type Heap
    body :: Vector{Int}
    heap_size
end

heap_size(h::Heap) = h.heap_size
function heap_size!(h::Heap, s::Int)
    h.heap_size = s
    return nothing
end
length(h::Heap) = length(h.body)

function getindex(h::Heap, i::Int)
    i <= h.heap_size &&  return h.body[i]
    error("Index is out of range")
end
function setindex!(h::Heap, val::Int, i::Int)
    i <= h.heap_size &&  return h.body[i] = val
    error("Index is out of range")
end

# Like merge sort, but unlike insertion sort, heapsort’s running time is 
# O(n lg_n). Like insertion sort, but unlike merge sort, heapsort sorts in
# place: only a constant number of array elements are stored outside the input 
# array at any time.
#
# The (binary) heap data structure is an array object that we can view as a
# nearly complete binary tree
#
# Each node of the tree corresponds to an element of the array. The tree is
# completely filled on all levels except possibly the lowest, which is filled 
# from the left up to a point. An array A that represents a heap is an object
# with two attributes: A.length, which (as usual) gives the number of elements
# in the array, and A.heap-size, which represents how many elements in the heap 
# are stored within array A. That is, although A[1..A.length] may contain 
# numbers, only the elements in A[1..A.heap-size], where
# 0 <= A.heap-size <= A.length, are valid elements of the heap.
#
# The root of the tree is A[1], and given the index i of a node, we
# can easily compute the indices of its parent, left child, and right child
parent(i::Int)  = div(i, 2) # ⌊/2⌋
left(i::Int)    = 2i
right(i::Int)   = 2i + 1
# ^^^ Good implementations of heapsort often implement these procedures as 
# “macros” or “in-line” procedures
#
# There are two kinds of binary heaps: max-heaps and min-heaps. In both kinds,
# the values in the nodes satisfy a heap property, the specifics of which depend 
# on the kind of heap. In a max-heap, the "max-heap property" is that for every 
# node 'i' other than the root,
#     A[parent(i)] >= A[i];
# "min-heap property" is that for every node 'i' other than root,
#     A[parent(i)] <= A[i]
#
# For the heapsort algorithm, we use max-heaps. Min-heaps commonly implement
# priority queue.# 

# Viewing a heap as a tree, we define the height of a node in a heap to be
# the number of edges on the longest simple downward path from the node to a 
# leaf, and we define the height of the heap to be the height of its root. 
# Since a heap of n els is based on a complete binary tree, its height is
# θ(lg_n). We shall see that the basic operations on heaps run in time at most
# proportional to the height of the tree and thus take O(lg_n) time.
#
#- The MAX-HEAPIFY proc, which runs in O(lg_n) time, is the key to maintaining
#  the max-heap property.
#- The BUILD-MAX-HEAP proc, which runs in linear time, produces a max-heap from
#  an unordered input array.
#- The HEAPSORT proc, which runs in O(n*lg_n) time, sorts an array in place.
#- The MAX-HEAP-INSERT, HEAP-EXTRACT-MAX , HEAP-INCREASE-KEY and HEAP-MAXIMUM
#  procs, which run in O(lg_n) time, allow the heap data structure to implement
#  a priority queue.

# MAX-HEAPIFY assumes that the binary trees rooted at LEFT(i) and RIGHT(i) are
# max-heaps, but that A[i] might be smaller than its children, thus violating
# the max-heap property. MAX-HEAPIFY lets the value at [i] “float down” in the
# max-heap so that the subtree rooted at index i obeys the max-heap property.
function max_heapify(h::Heap, i::Int)
    l, r, largest = left(i), right(i), i

    if l <= heap_size(h) && h[l] > h[largest]
        largest = l
    end
    if r <= heap_size(h) && h[r] > h[largest]
        largest = r
    end
    if largest != i
        h[i], h[largest] = h[largest], h[i]
        max_heapify(h, largest)
    end
end
# At each step, the largest of the els A[i], A[LEFT(i)], and A[RIGHT(i)] is
# determined, and its index is stored in largest. If A[i] is largest, then the
# subtree rooted at node i is already a max-heap and the proc terminates.
# Otherwise, one of the two children has the largest el, and A[i] is swapped
# with A[largest], which causes node i and its children to satisfy the max-heap
# property. The node indexed by largest, however, now has the original value
# A[i], and thus the subtree rooted at largest might violate the max-heap
# property. Consequently, we call MAX-HEAPIFY recursively on that subtree
#
# The running time of MAX-HEAPIFY on a subtree of size n rooted at a given
# node i is the Θ(1) time to fix up the relationships among the elements A[i],
# A[LEFT(i)], and A[RIGHT(i)], plus the time to run MAX-HEAPIFY on a subtree
# rooted at one of the children of node i (assuming that the recursive call 
# occurs). The children's subtrees each have size at most 2n/3 - the worst case
# occurs when the bottom level of the tree is exactly half full - and therefore 
# we can describe the running time of MAX-HEAPIFY by the recurrence ..
# T(n) <= T(2n/3) + Θ(1). |-       *      -|
# [from me]   -->         |    *       *   |1/3
#                      2/3|  *   *   *   *-|
#                         |-* * * *
# The solution to this recurrence, by case 2 of the master theorem, is
# T(n)= O(lg_n). Alternatively, we can characterize the running time of
# MAX-HEAPIFY on a node of height h as O(h).

function heapify!(h::Heap, i::Int, isbetter::Function)
    l, r, largest = left(i), right(i), i
    while true
        if l <= heap_size(h) && isbetter(h[l], h[largest])
            largest = l
        end
        if r <= heap_size(h) && isbetter(h[r], h[largest])
            largest = r
        end
        if i == largest
            break
        else
            h[i], h[largest] = h[largest], h[i]
            i = largest
            l, r = left(i), right(i)
        end
    end
end

# We can use the procedure MAX-HEAPIFY in a bottom-up manner to convert an
# array A[1..n], where n=A.length, into a max-heap. The els in the subarray
# A[(⌊n/2⌋ +1) .. n] are all leaves of the tree, and so each is a 1-element
# heap to begin with. The procedure BUILD-MAX-HEAP goes through the remaining 
# nodes of the tree and runs MAX-HEAPIFY on each one.
function build_max_heap!(h::Heap)
    heap_size!(h, length(h))
    # Loop.invariant: At the start of each iteration of the for.loop,
    # each node i+1,i+2..n is the root of a max-heap.
    for i = div(length(h), 2):-1:1
        heapify!(h, i, >)
    end
#*Initial: prior to the first iteration, i=⌊n/2⌋,  @i:i+1,i+2..n is a
# leaf and is thus the root of trivial max-heap
#*Maintenance: children of node i are numbered higher than i. By the loop 
# invariant, therefore, they are both roots of max-heaps. This is precisely the
# condition required for the call MAX-HEAPIFY(A,i) to make node i a max-heap
# root. Moreover, the MAX-HEAPIFY call preserves the property that nodes
# i+1,i+2..n are all roots of max-heaps. Decrementing i in the for loop update
# reestablishes the loop invariant for the next iteration
#*Termination: At termination, i=0. By the loop invariant, each node 1,2..n
# is the root of a max-heap. In particular, node 1 is
end
# Each call to MAX-HEAPIFY costs O(lg_n) time, and BUILD-MAX-HEAP makes O(n)
# such calls. Thus, the running time is O(n*lg_n). This upper bound, though
# correct, is not asymptotically tight.
# We can derive a tighter bound by observing that the time for MAX-HEAPIFY to
# run at a node varies with the height of the node in the tree, and the heights 
# of most nodes are small. Our tighter analysis relies on the properties that
# an n-element heap ̇has height ⌊lg_n⌋ and at most ⌈(n / 2^(h+1)⌉ nodes of
# height h in any n-elem heap. The time required by MAX-HEAPIFY when called on
# a node of height h is O(h), and so we can express the total cost of
# BUILD-MAX-HEAP as being bounded from above by
#   ⌊lg.n⌋                         ⌊lg.n⌋
#        Σ⌈n/ 2^(h+1)⌉*O(h) = O(n*Σ(h/2^h))
#      h=0                          h=2
#  ∞
#  Σ h / 2^h = (1/2) / (1 - 1/2)^2 = 2  
# h=0
#  ⌊lg.n⌋            ∞              See also: heap_quicksort.rs:build_heap
# O(n*Σ h/2^h) = O(n*Σ h/2^h)= O(n)
#    h=0            h=0          

function heapsort!(h::Heap)
    build_max_heap!(h)
    orig_size = heap_size(h)
# At the start of each it-tion of the for loop, the subarray A[1..i] is a
# max-heap containing the i smallest els of A[1..n], and the subarray A[i+1..n]
# contains the n-i largest elements of A[1..n], sorted
    for i = orig_size:-1:2
        h[1], h[i] = h[i], h[1]
        heap_size!(h, heap_size(h)-1)
        heapify!(h, 1, >)
    end
    heap_size!(h, orig_size)
    return nothing
end
# The HEAPSORT proc takes time O(n*lg_n), since the call to BUILD-MAX-HEAP takes
# time O(n) and each of the n-1 calls to MAX-HEAPIFY takes time O(lg_n)

# One of the most popular applications of a heap: as an efficient priority
# queue. As with heaps, priority queues come in two forms: max-priority queues
# and min-priority queues. We will focus here on how to implement
# @MAX-PRIORITY queues, which are in turn based on max-heaps
#
# A priority queue is a data structure for maintaining a set S of els, each with
# an associated val called a key. A max-priority queue supports the following
# operations:
#- INSERT(S,x) inserts the el x into the set S, which is eq-lent to the
#     operation S = S \union {x}.
#- MAXIMUM(S)     returns the element of S with the largest key.
#- EXTRACT-MAX(S) removes and returns the element of S with the largest key.
#- INCREASE-KEY(S,x,k)  increases the value of element x's key to the new val k,
#     which is assumed to be at least as large as x’s current key value.
#
# Among their other applications, we can use max-priority queues to schedule
# jobs on a shared computer. The max-priority queue keeps track of the jobs to
# be performed and their relative priorities. When a job is finished or 
# interrupted, the scheduler selects the highest-priority job from among those 
# pending by calling EXTRACT-MAX. The scheduler can add a new job to the queue
# at any time by calling INSERT
# In a given app, such as job scheduling or event-driven simulation, els of a
# priority queue correspond to obj in the app. We often need to determine which
# app obj corresponds to a given priority-queue el, and vice versa.
# When we use a heap to implement a priority queue, therefore, we often need to
# store a handle to the corresponding app.obj in each heap.el. The exact makeup
# of the handle(such as a pointer or an integer) depends on the app. Similarly,
# we need to store a handle to the corresponding heap.el in each app obj. Here,
# the handle would typically be an arr.index. Because heap els change locations 
# within the array during heap opers, an actual imp-tion, upon relocating a heap
# el, would also have to update the array index in the corresponding app.obj.
heap_maximum(h::Heap) = h[1]

function heap_extract_max!(h::Heap)
    heap_size(h) < 1 && error("heap underflow")
    max, h[1] =  h[1], h[heap_size(h)]
    heap_size!(h, heap_size(h)-1)
    heapify!(h, 1, >)
    return max
end # the running time is O(lg_n)

function goto_top(h::Heap, i::Int, key)
    while i > 1 && h[parent(i)] < key
        h[i], i = h[parent(i)], parent(i)
    end
    return i == 0 ? 1 : i
end

function heap_increase_key!(h::Heap, i::Int, key)
    key < h[i] && error("new key is smaller than current key")
    i = goto_top(h, i, key)
    h[i] = key
    return nothing
end # O(lg_n)

function max_heap_insert(h::Heap, key)
    heap_size!(h, heap_size(h)+1)
    h[heap_size(h)] =  typemin(Int)
    heap_increase_key(h, heap_size!(h), key)
end # O(lg_n)

function heap_delete!(h::Heap, i)
    i < 1 && i > heap_size(h) && error("i is out of bound")
    i = goto_top(h, i, h[heap_size(h)])
    h[i] = h[heap_size(h)]
    heap_size!(h, heap_size(h)-1)
    return nothing
end # O(lg_n)

# O(n*lg_k)-time algorithm to merge k sorted lists into one sorted list,
# where n is the total number of els in all the input lists.
# #### it wrong!!!, solve this task if you want
function merge_sorted_lists(lists...) # Hint: Use a min-heap for k-way merging.
    new_list  = reduce(vcat, lists)
    nl_length = length(new_list)
    h         = Heap(new_list, nl_length)
    cur       = (lists |> first |> length) + 1
    for i in cur:nl_length
        key = h[i]
        i = goto_top(h, i, key)
        h[i] = key
    end
    return h.body
end 

# Problems.
#    Building a heap using insertion
# We can build a heap by repeatedly calling MAX-HEAP-INSERT to insert the 
# els into the heap. Consider the following variation on the BUILD-MAX-HEAP
# procedure:
function _build_max_heap(h::Heap)
    heap_size!(h, 1)
    for i = 2:length(h)
        max_heap_insert(h, h[i])
    end
end
# a. Do the procs BUILD-MAX-HEAP and _BUILD-MAX-HEAP always create the same heap
#    when run on the same input array? Prove that they do, or provide a 
#    counterexample.
# b. Show that in the worst case, _BUILD-MAX-HEAP requires Θ(n*lg_n) time to
#    build an n-element heap.
# 
# SEE a few another problems on p167

# READ chapter notes(1page) on p168 if you want
