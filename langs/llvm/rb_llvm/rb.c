#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>


typedef enum { red_c, black_c } Color;

typedef enum { leaf_t, node_t } RBNodeType;

struct Node;
struct RBNode;

typedef struct Node {
    int key;
    struct RBNode *l;
    struct RBNode *r;
    struct RBNode *p;
    Color color;
} Node;

typedef struct RBNode {
    RBNodeType type;
    struct Node *node;
} RBNode;

typedef struct RBTree {
    struct RBNode *root;
} RBTree;

Node *
create_node (int key, RBNode * l, RBNode * r, RBNode * p, Color color)
{
    Node *node = malloc (sizeof (Node));
    node->key = key;
    node->l = l;
    node->r = r;
    node->p = p;
    node->color = color;
    return node;
}


Color
color (const RBNode * const rbnode)
{
    switch (rbnode->type) {
    case leaf_t:
        return black_c;
    case node_t:
        return rbnode->node->color;
    }
}

//        x                   y
//       / \                 / \
//      a   y     --->      x   c
//         / \             / \
//        b   c           a   b
void
left_rotate (RBNode ** rootp, RBNode * x)
{
    if (x->type == leaf_t || (*rootp)->type == leaf_t)
        return;

    RBNode *y = x->node->r;

    // bind `b` to `x`
    x->node->r = y->node->l;
    if (y->node->l->type == node_t)
        y->node->l->node->p = x;
 
    // bind `y` to `x.parent`
    y->node->p = x->node->p;
    if (x->node->p->type == leaf_t)
        *rootp = y;
    else if (x->node->p->node->l == x)
        x->node->p->node->l = y;
    else
        x->node->p->node->r = y;

    // bind `x` ro `y`
    y->node->l = x;
    x->node->p = y;
}

//        y                   x
//       / \                 / \
//      c   x     <----     y   a
//         / \             / \
//        b   a           c   b
void
right_rotate(RBNode ** rootp, RBNode *x) {
    if (x->type == leaf_t || (*rootp)->type)
        return;

    RBNode* y = x->node->l;

    // bind `b` to `x`
    x->node->l = y->node->r;
    if (x->node->l->type == node_t)
        x->node->l->node->p = x;
    // bind `y` to `x.parent`
    y->node->p = x->node->p;
    if (x->node->p->type == leaf_t)
        *rootp = y;
    else if (x->node->p->node->l == x)
        x->node->p->node->l = y;
    else 
        x->node->p->node->r = y;
    // bind `x` ro `y`
    x->node->p = y;
    y->node->r = x;
}

int
main ()
{
    RBNode node = {
        .type = node_t,
        .node = create_node (33,
                             (RBNode *) NULL,
                             (RBNode *) NULL,
                             (RBNode *) NULL,
                             black_c)
    };

    printf ("%x\n", (unsigned) &node);
    printf ("%d\n", (unsigned) node.type);

    return 0;
}
