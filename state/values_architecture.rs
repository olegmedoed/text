//! p.s.(after write this file:  See how in libstd/thread/mod.rs  Core-team write in similar style
//!          Thread/Inner, also in Mio,  so see main.rs:19)

// person it's just VALUE of person, don't care about work here(does'nt need links to work place),
// for this fact we have separate structure
struct Person {
    name: String,
}
/// P.S. ^-- this value probably will be used through Rc/Arc

// worker card doesn't care about workplace, it's owned by place
struct WorkerCard {
    person: Rc<Person>, 
    position: String,
}

// if person change the job -- NOT person has new State - WorkPlace has new state
struct SomeWorkPlace {
    workers: Vec<WorkerCard> // or probably Vec<RefCell<WorkerCard>> to more local mut-borrowing
}

struct WebInfo {
    person: Rc<Person>,
    emain: String,
    password: String,
    ip: String,
}

struct Journal {
    user_info: Vec<WebInfo>, // probably Vec<RefCell<WebInfo>>
}

/// Also, PARTICULARLY about Rust:
// MAYBE it makes sense to separate structures that should be treated as VALUEs(and follow to
// Hickie style -- new value for every word-state-change), and mutable-structures that follow style
// `unwisible time-change axis`(my definition), that is we change the state of system instead of
// create new value .. SO .. here `SomeWorkPlace` and `Journal` follow `state-change` style, and
// `WorkerCard` and `WebInfo` follow the `value-style`;
// That let us have many immut refs on VALUEs-style structs which be owned by Change-state-style
// structs
