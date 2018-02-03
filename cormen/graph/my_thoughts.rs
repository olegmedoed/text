// I think good form of graph representation is as follow:
struct Graph<T = Directed> {
    node: Vec<Node>,
    source_nodes: Vec<&Node>,  // we can use indexes to refer to node in `Graph.node` vec
    target_nodes: Vec<&Node>,  // but in such case we respond for checking on correctness of
    edges: Vec<Edge>,          // this indexes, also, if we want have ability mutate this
    deleted_edges: Vec<usize>, //  nodes we should use Vec<*mut Node> to get around borrowcheck 
    deleted_nodes: Vec<usize>,
    ty: PhantomData<T>        
}
// node:           [n1|n2|n3]
// source_nodes:   [n2|n3|n1]
// target_nodes:   [n3|n1|n2]
// edges:          [e1|e2|e3]
//
// ^-- Vec of nodes is just Vec of nodes, just collection
//     But Vec of source and target nodes  and  edges have relation.
//     Here it means that from `n2` to `n3` there is `e1` in the case if it's directed graph,
//     otherwise it just means that `e1` is between `n2` and `n3`

// deleted edges and nodes Vec cache the indexes of deleted nodes or edges(delete node means
// delete all edges what was related with them) and past in this indexes new edges and nodes, 
// and in such way don't move nodes to shrink the vector

// SO, ..
// Insertion
//          O(1)
// Deletion 
//          O(1)
// Search of all edges what direct to node or out of node
//          O(n of edges)
