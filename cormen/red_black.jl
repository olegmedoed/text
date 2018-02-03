# Problem: persistent set with rbtree p331
# AIWE - as I wrote earlier

abstract Tree{K,V}
abstract AbstractRBTree{K,V} <: Tree{K,V}
# RBTree properties:
# 1. Every node is either red or black.
# 2. The root is black.
# 3. Every leaf ( NIL ) is black.
# 4. If a node is red, then both its children are black.
# 5. For each node, all simple paths from the node to descendant leaves contain
#    the same number of black nodes.
type RBTreeNode{K,V} <: AbstractRBTree{K,V}
    key     :: K
    data    :: V
    red     :: Bool
    parent  :: Tree{K,V}
    left    :: Tree{K,V}
    right   :: Tree{K,V}
end
# We use the sentinel so that we can treat a NIL child of a node 'x' as an
# ordinary node whose parent is 'x'. We use the one sentinel to represent all
# the NILs - all leaves and the root's parent.
type RBTreeNil{K,V} <: AbstractRBTree{K,V} end

type RBTree{K,V}
    root :: AbstractRBTree{K,V}
    RBTree() = AbstractRBTree{K,V}()
end

# We call the number of black nodes on any simple path from, but not including,
# a node 'x' down to a leaf the BLACK-HEIGHT of the node, denoted bh(x).
# By property 5, the notion of black-height is well defined, since all
# descending simple paths from the node have the same number of black nodes. We
# define the black-height of a red-black tree to be the black-height of its root

# Lemma 13.1
# A red-black tree with n internal nodes has height at most 2*lg(n+1).

isred(t::RBTreeNode)              = t.red
isblack(t::RBTreeNode)            = !t.red
color(t::RBTreeNode)              = t.red ? :red : :black
color!(t::RBTreeNode, c::Symbol)  =
    if is(c, :red)
        t.red = true
    elseif is(c, :black)
        t.red = false
    else
        throw(ArgumentError("color should be either red or black" ))
    end

isred(t::RBTreeNil)    = false
isblack(t::RBTreeNil)  = true
color(t::RBTreeNil)    = :black

# << (10.02.16) that shold not be macro. Macro is abstarcation over syntax, the
# way to embed in lang new syntax construction. Here we can use common func what
# should be inlined
macro isleft_child(node);     :($node == $node.parent.left) end
macro isright_child(node);    :($node == $node.parent.left) end

# INSERT, DELETE, when run on a RBtree with n keys, take O(lg_n) time.

function left_rotate!(tree::RBTree, node::RBTreeNode)
    rch_node::RBTreeNode  = node.right
    node.right            = rch_node.left

    if !isa(rch_node.left, RBTreeNil)
        rch_node.left.parent = node
    end

    rch_node.parent = node.parent

    if isa(node.parent, RBTreeNil)
        tree.root = rch_node
    elseif @isleft_child(node)
        node.parent.left = rch_node
    else
        node.parent.right = rch_node
    end

    rch_node.left = node
    node.parent = rch_node
end
# both those funcs V ^ are use explicitly args of two diff concr.classes: Node
# and Nil, so (AIWE) in OO it's like using protected properties of classes from
# one Abstr.class
function right_rotate!(tree::RBTree, node::RBTreeNode)
    lch_node::RBTreeNode  = node.left
    node.left             = lch_node.right
    if !isa(lch_node.right, RBTreeNil)
        lch_node.right.parent = node
    end
    lch_node.parent = node.parent
    if isa(node.parent, RBTreeNil)
        tree.root = lch_node
    elseif @isleft_child(node)
        node.parent.left = lch_node
    else
        node.parent.right = lch_node
    end
    lch_node.right = node
    node.parent = lch_node
end

function insert!{K,V}(tree::RBTree{K,V}, newnode::RBTreeNode)
    # get_node works correctly only if all keys in tree are distinct
    _, parent = get_node(tree.root, newnode.key)
    newnode.parent = parent
    if isa(parent, RBTreeNil)
        tree.root = newnode
    elseif node.key < parent.key
        parent.left = newnode
    else
        parent.right = newnode
    end
    newnode.right = newnode.left = RBTreeNil{K,V}()
    color!(newnode, :red)
    insert_fixup(tree, newnode)
end

# SEE: Fig.13.4(p317)
function insert_fixup(tree::RBTree, node::RBTreeNode)
# while loop invariant:
# a. Newnode is red.
# b. If newnode.parent is the root, then newnode.parent is black.
# c. If the tree violates any of the rb-properties, then it violates at most
#   one of them, and the violation is of either prop-2 or prop-4. If the tree
#   violates prop-2, it is because newnode is the root and is red. If the tree
#   violates prop-4, it is because both newnode and newnode.parent are red
    while isred(node.parent) # if node is a root its parent is black Nil, so
    # violation of prop-4 is the only violation of rb-props in the entire tree
    # [from.me: that is in loop.body heigh of tree is surely >= 3]
        # by (b): if parent is red it can't be a root, so gparent exist
        # in all cases gparent is black
        if @isleft_child(node.parent)
            uncle = node.parent.parent.right      #   GrP
            if isred(uncle)                       #   / \
                color!(node.parent, :black)       #  P   Uncle-red
                color!(uncle, :black)             #  |
                color!(node.parent.parent, :red)  #  N
                node = node.parent.parent
            else
                if @isright_child(node)       #    GrP
                    node = node.parent        #   /  \
                    left_rotate!(tree, node)  #  N    Uncle-black
                end # ^^^   -  after -------> P_/
                color!(node.parent, :black)
                color!(node.parent.parent, :red)
                right_rotate!(tree, node.parent.parent)
            end
        else
            uncle = node.parent.parent.left
            if isred(uncle)
                color!(node.parent, :black)
                color!(uncle, :black)
                color!(node.parent.parent, :red)
                node = node.parent.parent
            else
                if @isleft_child(node)
                    node = node.parent
                    right_rotate!(tree, node)
                end
                color!(node.parent, :black)
                color!(node.parent.parent, :red)
                left_rotate!(tree, node.parent.parent)
            end
        end
    end # stop if node.parent is black => tree doesn't violate prop-4
    color!(tree.root, :black) # if node is first inserted node => it's root
end
