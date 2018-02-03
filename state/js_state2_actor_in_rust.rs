#![feature(const_fn)]

use std::rc::Rc;

fn main() {
    use ::scene::*;

    let a1 = Rc::new(Actor::new(String::from("Oleg")));
    let a2 = Rc::new(Actor::new(String::from("Sveta")));

    let mut s = Scene::new();

    s.insert(&a1, 3, 5);
    s.insert(&a2, 5, 11);

    s.draw();

    s.move_actor(&a2, 3, 5);
}

mod scene {
    use std::sync::atomic;
    use std::collections::HashMap;
    use std::rc::Rc;

    #[derive(Debug)]
    pub struct Actor {
        id: usize,    // private, only `Actor::new` can mutate it
        name: String
    }
    impl Actor {
        pub fn new(name: String) -> Self {
            static X: atomic::AtomicUsize = atomic::AtomicUsize::new(0);

            let id = X.load(atomic::Ordering::Acquire);
            X.fetch_add(id+1, atomic::Ordering::Release);

            Actor { id, name }
        }
    }

    #[derive(Debug)]
    struct Position { actor: Rc<Actor>, x: i32, y: i32, }

    pub struct Scene {
        actors: HashMap<usize, Position>, // TREE-in-the-WOOD
    }
    impl Scene {
        pub fn new() -> Self {
            Scene { actors: HashMap::new() }
        }

        pub fn insert(&mut self, a: &Rc<Actor>, x: i32, y: i32) {
            self.actors.insert(
                // or instead of `id` it can be addres of Rc, for lifetime of Actor is unchanged
                a.id,

                Position { actor: a.clone(), x, y, }
            );
        }

        pub fn move_actor(&mut self, a: &Rc<Actor>, x: i32, y: i32) {
            {
                let mut pos = self.actors.get_mut(&a.id).unwrap(); // unhandled for convenience
                pos.x = x;
                pos.y = y;
            }
            self.draw();
        }

        pub fn draw(&self) { 
            for (_, a) in self.actors.iter() {
                println!("{:?}", a);
            }
        }
    }
}
