use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::usize;

#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
    cost: usize,
    pos: usize, // position
}

// the priority queue depends on 'Ord'.
// Explicitly implement the trait so the queue become a min-heap instead of max-heap
impl Ord for State {
    fn cmp(&self, other: &State) -> Ordering {
        other.cost.cmp(&self.cost) // notice that we flip the ordering here
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &State) -> Option<Ordering> { Some(self.cmp(other)) }
}

struct Edge { node: usize, cost: usize, }

//      Dijkstra shortes-path algo
// Start at 'start' and use 'dist' to track the current shortest distance to each node
// This implementation isn't memory-efficient as it may leave duplicate nodes in the queue.
fn shortest_path(adj_list: &Vec<Vec<Edge>>, start: usize, goal: usize) -> Option<usize> {
    // let mut dist: Vec<_> = (0..adj_list.len()).map(|_| usize::MAX).collect();
    let mut dist = vec![usize::MAX, adj_list.len()];
    let mut heap = BinaryHeap::new();

    dist[start] = 0;
    heap.push(State { cost: 0, pos: start });

    // Examine the frontier with lower cost nodes first (min-heap)
    while let Some(State { cost, pos }) = heap.pop() {
        if pos == goal { return Some(cost) }
 
        // Important as we may have already found a better way
        if cost > dist[pos] { continue; }

        // For each node we can reach, see if we can find a way with
        // a lower cost going through this node
        for edge in &adj_list[pos] {
            let next = State { cost: cost + edge.cost, pos: edge.node };

            if next.cost < dist[next.pos] {
                heap.push(next);
                dist[next.pos] = next.cost;
            }
        }
    }
    None
}

fn main() {}
