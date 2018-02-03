// I think data data-mapping(ala ORM) will be usefull in my "journal"
// .. BUT .. not "general purpose" - because of it's "leak abstraction" (like
// many people don't like Waterline(from Sails.js)) .. SO .. my "ORM" will be
// my-app-specific, it's like in Rust
struct MongoAdapter {...}
struct PostgresAdapter {...}

trait SaveData {
    fn save(..);
    ...
}

impl SaveData for MongoAdapter  { 
    // here I implement API specifically as I need it in Mongo
}
impl SaveData for PostgresAdapter {
    // here I implment API spcifically as I need it in Postgres
}

let adapter = MongoAdapter::new(/* config what makes sense ONLY for Mongo */)

fn some_fn<A: SaveData>(adapter: SaveData) { .. }

//! BUT [GIST] it's should be USE-CASE ORIENTED  .. SO .. 
//!   -== Traits help us don't write specific fns for every type ..
//!     .. WHEN those fns do exactly the same -==
fn mongo_fn(adapter: MongoAdapter) {
    ..;
    adapter.mongo_specific_fn
}

// NOTE: since in JS we have not Traits, we just use Duck-typing .. good exmp of that is
// implementation of Node's in - "Immutable.js"
