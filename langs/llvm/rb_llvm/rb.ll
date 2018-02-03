target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
;e - little endian
;m:e - mangle ELF: private symnols got a `.L` prefix
;s128 - align stack on 128bit, that is on 16byte (for SIMD)
target triple = "i586-pc-linux-gnu"

declare noalias i8* @malloc(i32) #0

;------------------------------ Data structures -------------------------------
%struct.Node = type {
    i32,
    %struct.RBNode*,
    %struct.RBNode*,
    %struct.RBNode*,
    i32                 ; Color
}

%struct.RBNode = type { i32, %struct.Node* }
;------------------------------------------------------------------------------


define noalias %struct.Node*
@create_node(
    i32 %key,
    %struct.RBNode* %l, %struct.RBNode* %r, %struct.RBNode* %p,
    i32 %color) #0
{
    %node.0 = tail call noalias i8* @malloc(i32 20) nounwind
    %node   = bitcast i8* %node.0 to %struct.Node*

    %node.key = bitcast i8* %node.0 to i32*
    store i32 %key, i32* %node.key, align 4

    %node.l.raw = getelementptr inbounds i8, i8* %node.0, i32 4
    %node.l     = bitcast i8* %node.l.raw to %struct.RBNode**
    store %struct.RBNode* %l, %struct.RBNode** %node.l, align 4

    %node.r.raw = getelementptr inbounds i8, i8* %node.0, i32 8
    %node.r     = bitcast i8* %node.r.raw to %struct.RBNode**
    store %struct.RBNode* %l, %struct.RBNode** %node.r, align 4

    %node.p.raw = getelementptr inbounds i8, i8* %node.0, i32 12
    %node.p     = bitcast i8* %node.p.raw to %struct.RBNode**
    store %struct.RBNode* %p, %struct.RBNode** %node.p, align 4

    %node.color.raw = getelementptr inbounds i8, i8* %node.0, i32 16
    %node.color     = bitcast i8* %node.color.raw to i32*
    store i32 %color, i32* %node.color, align 4

    ret %struct.Node* %node
}

;             Color color(const RBNode * const rbnode) {
;                 switch (rbnode->type) {
;                 case leaf_t: return black_c;
;                 case node_t: return rbnode->node->color;
define i32  ;     }}
@color(%struct.RBNode* nocapture readonly %rbnode) nounwind readonly
{
    %type.p = getelementptr inbounds %struct.RBNode,
                                     %struct.RBNode* %rbnode, i32 0, i32 0
    %type = load i32, i32* %type.p, align 4
    %cond = icmp eq i32 %type, 1
    br i1 %cond, label %node_t, label %leaf_t
node_t:
    %node.p.p = getelementptr inbounds %struct.RBNode,
                                      %struct.RBNode* %rbnode, i32 0, i32 1
    %node.p = load %struct.Node*, %struct.Node** %node.p.p, align 4
    %color.p = getelementptr inbounds %struct.Node,
                                      %struct.Node* %node.p, i32 0, i32 4
    %color = load i32, i32* %color.p, align 4
    br label %leaf_t
leaf_t:
    %res = phi i32 [%color, %node_t], [1, %0]
    ret i32 %res
}

define void
@left_rotate(%struct.RBNode** %rootp, %struct.RBNode* %x) nounwind
{
;           if (x->type == leaf_t || (*rootp)->type == leaf_t) return;
    %x.type.p = getelementptr inbounds %struct.RBNode,
                                       %struct.RBNode* %x, i32 0, i32 0
    %x.type = load i32, i32* %x.type.p, align 4
    %x.type.eq.leaf = icmp eq i32 %x.type, 0   ; if type == leaf
    br i1 %x.type.eq.leaf, label %next.typecheck, label %main
next_typecheck:
    %root = load %struct.RBNode*, %struct.RBNode** %rootp   ; *rootp
    %root.type.p = getelementptr inbounds %struct.RBNode,
                                          %struct.RBNode* %root, i32 0, i32 0
    %root.type = load i32, i32* %root.type.p, align 4

    %root.type.eq.leaf = icmp eq i32 %root.type.eq.leaf, 0 ; if type == leaf
    br i1 %root.type.eq.leaf, label %end, label %main
main:
;                           RBNode *y  = x->node->r;
;                           x->node->r = y->node->l;
;   %x.nodep is RBNode**
    %x.nodep = getelementptr inbounds %struct.RBNode,
                                      %struct.RBNode* %x, i32 0, i32 1
;   %x.node is Node*
    %x.node = load %struct.RBNode*, %struct.RBNode** %x.nodep, align 4
;   %x.node.rp is RBNode**
    %x.node.rp = getelementptr inbounds %struct.Node, ; x.right
                                        %struct.Node* %x.node, i32 0, i32 2
;   %y is RBNode*
    %y  = load %struct.RBNode*, %struct.RBNode** %x.node.rp
;   %y.nodep is Node**
    %y.nodep = getelementptr inbounds %struct.RBNode,
                                      %struct.RBNode* %y, i32 0, i32 1
;   %y.node is Node*
    %y.node = load %struct.Node*, %struct.Node** %y.nodep, align 4
;   %y.node.lp is RBNode**
    %y.node.lp = getelementptr inbounds %struct.Node,
                                        %struct.Node* %y.node, i32 0, i32 1
    %y.node.lp.raw = bitcast %struct.RBNode** %y.node.lp to i32* ;RBNode* to i32
    %y.node.l.raw = load i32, i32* %y.node.lp.raw, align 4
    %x.node.rp.raw = bitcast %struct.RBNode** %x.node.rp to i32*; RBNode* to i32
    store i32* %x.node.rb.raw, i32 %y.node.l.raw, align 4

;                   if (y->node->l->type == node_t) y->node->l->node->p = x;
;   %y.l is RBNode*
    %y.l = load %struct.RBNode*, %struct.RBNode** %y.node.lp, align 4
;   %y.l.typep is i32*
    %y.l.typep = getelementptr inbounds %struct.RBNode,
                                        %struct.RBNode* %y.l, i32 0, i32 0
    %y.l.type = load i32, i32* %y.l.typep, align 4
    %y.l.type.is.node = icmp eq i32 %y.l.type, 1
    br i1 %y.l.type.is.node, label %bind.y.l.to.x, label %bind.y.to.x.p
bind.y.l.to.x:
;   %y.l.pp is RBNode**
    %y.l.pp = getelementptr inbounds %struct.Node,
                                     %struct.Node* %y.node, i32, i32 3
;   %y.l.pp.raw is i32*
    %y.l.pp.raw = bitcast %struct.RBNode** %y.l.pp to i32*; RBNode* to i32
    %y.l.p.raw  = load i32, i32* %y.l.pp.raw
;   %xp is RBNode**
    %xp = getelementptr inbounds %struct.RBNode, %struct.RBNode* %x, i32 0
    %xp.raw = bitcast %struct.RBNode** %xp to i32*
    store i32* %xp.raw, i32 %y.l.p.raw
bind.y.to.x.p:
endf:
    ret void
}



;define i32
;@main() #0 {
;
;}


attributes #0 = { nounwind
    "disable-tail-calls"="false"
    "less-precise-fpmad"="false"
    "no-frame-pointer-elim"="false"
    "no-infs-fp-math"="false"
    "no-nans-fp-math"="false"
    "stack-protector-buffer-size"="8"
    "target-cpu"="pentium4"
    "target-features"="+sse,+sse2"
    "unsafe-fp-math"="false"
    "use-soft-float"="false"
}
