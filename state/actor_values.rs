//! Hickey statement: information is about FACTS, facts is a VALUE, NOT a place(memory-location)
//! So .. it's imposible to change the value, if I have a name "Oleg" that's the FACT, it's
//! unchenagable( ...
//!  hovewer :lol:, if I redye my hair whether I be a ne VALUE?, theoretically yes( ..
//!   every moment my organism is changed, and I'm new man, as S.Klabnik has said: "after some
//!   time we have no molecule in our organism what were previously - the ONLY STRUCTURE(the way 
//!   you composed) is preserved - SO :lol: the personality it's just a pattern(func) described in 
//!   our DNA")
//!  .. also if consider my life a series of the FACTs, when I redye my hair, It's new fact about
//!  me, SO we have new VALUE, that is people operate with diff me, and as result with diff VALUE,
//!  the better exmp: "when I become depressed", my friends has deal with new person, with new 
//!  me, new VALUE, the new FACTs becomes valid about me)
//! SO ..
//! rethink the Scene state, when I move on the scene, NOT ME IS CHANGED, -- SCENE IS CHANGED, if 
//! to be more specifik: the POSITIONs of figures on the Scene is changed .. SO .. If I even should
//! consider the Hickey(Clojure) approach to the computation(not the PlaceOrientedProgramming--PlOP)
//! then when I move the actor then I receive the NEW STATE of SCENE, NEW FACT about POSITIONS of
//! actors, NEW "FACT" ABOUT SCENE.
//!
//! also a little bit of philosophy from Hickey: "If I want show you beautiful place than what the
//! benefits if I give you a location(address) of this place? This place can change when you come
//! to it, SO I need freeze the state, that is stop the world in current state you see this beauty, 
//! I can't to do it in RealWorld *****, but I can send you a value in the form of PHOTO, which we
//! have no sense to change"  (***** - but it's EXACTLY what the BORROW-CHECKER DO when we pass
//! immutable ref - it guaranty that this part of world(our program) will not chagne until you
//! interested to see it(don't throw out the ref on this location which is passed by me ))
//!
//! So .. if consider v-- this design, we can IMMUTABLY create new state(VALUE) of Scene, with new
//! positions-of-Actors, BUT .. the Actors VALES doesn't care about it,  ....
//! .. We can even follow to Clojure(Hickey) style of creating new VALUE instaead of PlOP, BUT from
//! technical point of view we need tuned allocator for this purposes(since in Rust doesn't have
//! optimized for this purposes GC) .. AND ..
//! .. STM - because in Clojure if we create new Scene every time when we change the actor position
//! than it will behave like GIT, that is unchangable pieces will be boint to old value, and only
//! new values be new
//! [A-val1, B-val1, C-val1] --> [A-ref1, B-ref1, C-val2]
//! BUT, in Rust we can't do it since have no RUNTIME support(it's considered as strength of Rust)

use std::cell::RefCell;

// Why actor doesn't contain links on its position on the scene? ..
// .. Because that VALUE is the FACT about Actor, .. SO .. if I you ask me describe himself it
// doesn't care where I was yesterday(on what street I was walking), it even doesn't care where I'm
// work - BECAUSE if you need that fact then --> :lol: `you need THAT fact` (note: sequence of
// facts[here: where I was walking yesterday] + time-stream == REACTIVE-PROGRAMMING)
//
// So .. that architecture lead us to the style when we can ... (SEE: values_architecrure.rs)
struct ActorInner {
    name: String,
}

#[derive(Copy, Clone)]
struct Actor(std::sync::Arc<ActorInner>);

impl std::ops::Deref for Actor {
    type Target = Arc<ActorInner>;
    fn deref(&self) -> &Arc<ActorInner> { &self.0 }
}

struct ActorPosition {
    x: u32,
    y: u32,
    actor: Actor,
}

struct Scene {
    width: u32,
    height: u32,
    /// Actor positions is the property of "Scene-VALUE", not the Actor, since if Actor moves NOT
    /// actor has new STATE, but Scene has new STATE(value) ... BUT ....
    /// Why RefCell, since also when position is changed Scene generally has new state, but not the
    /// state STRUCTURE, so, RefCell for such cases .. BUT the facto that RecCell is owned by Scene
    /// say as that state of Scene is also changed when we chage position state.
    actors: Vec<RefCell<ActorPosition>>,
}

impl Scene {
    fn new(width: u32, height: u32) -> Scene {
        Scene { width: width,  height: height,  actors: Vec::new() }
    }

    // just-in-case: we no need to create `ActorPosition` in this --v directly, only depend-
    // injection, since if we have acces to this meth => we have acces to Scene-inst, also if
    // we can pass the ref to Actor-inst => we can init the ActorPosition-inst(we have ref to actor
    // and scene)
    fn register(&mut self, act_pos: ActorPosition) -> Result<usize> {
        if act_pos.x > self.width || act_pos.y > self.height {
            return Err("Actor out of scene bounds");
        }
        self.actors.push(act_pos);
    }
}
