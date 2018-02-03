// here may be mix of Rust/JS/Pseudo in same code exmp;

fn state_sharing(prod, cons_n_prod) {
    let prefix = "", list = [];  // DON'T FORGET: in Rust they Rc<RefCell>

    prod.on("data", produce);
    cons_n_prod.on("data", consume);

    // setter
    let produce = |data| list.push(prefix + data.toString("utf8"));

    // getter/setter: SET our obj{prefix,list}, and GET value to
    //  cons_n_prod(here by PUSH PROTOCOL .. bl99, anyway "setter" is "push-protocol", that is
    //  driven not by "setter", but obj that call "Setter", "setter" here like callback)
    let consume = |new_prefix| {
        cons_n_prod.push(list.join(", "));  // consume from "prod", and produce by `push`
        prefix = new_prefix;
    }

    /// BUT IDEALLY TO push/pull modell
    let produce = |data| {
        list.push(data); // .toString("utf8");
    }
    let consume = |new_prefix| {
        let old = prefix
        prefix = new_prefix
        cons_n_prod.push(data.map(|d| old + d).join(", "));
    }
}
//
// also we can perceive it not as StMach  , but think of it in terms of FRP .. i.e
// imagine all programm as BIG WATERPIPE  .. and now .. every io/event is outer_source
// .. and we HAVE no StMach  .. but
//
//  data       >  vvvvvvvvvv|
//                           > (xv,xv,xv,xv)
//  new_prefix >  x    x    |

struct Vs { vec: Vec<v>, /* tree_in_the_wood */ }

impl Push for Vs {
    // don't care about own/borrow/mut/immut
    fn push(self, v: Result<Option<v>>) {
        match v {
            Ok(Some(v)) => self.vec.push(v),
            _ => {}// .....pohui
        }
    }
}
impl Pull for Vs {  // ala Iterator
    fn pull(self) -> Result<Option<v>> {
        let v = self.vec;
/*rust*/let v = Rc::new(self.vec);  // Also See_below:  Pony-n-ActorModel .. no-copy-is-needed
        self.vec = [];
        Ok(Some(v.clone())) // TREE_in_the_WOOD .. i.e. we "like" no have mutations, no one
                            // around can here it  ... **ISOLATE** .. and we bind many "pullers"
                            // to 'it' .. every one receive it's own copy (NO_MUT_ALIASING)
    }
}


let d = data_io.pipe(Vs::new());

let top_puller = prefix_io.pipe(Pipe {
    push(self, x: Result<Option<x>>) {
        let vec = d.pull().unwrap().unwrap();
        Ok(Some(vec.map(v => x + v)))
    }
})

// every v-- `pipe` gives new "copy" , and we "time" doesn't matter since we explicitly..
xxx.pipe(yyy)
xxx.pipe(zzz)
// .. pipe our "pipes" (in imper world not we determine "flow", but "time")


//                  ________________________________________________
///...  -============  SO .. HOW IT CORRELATE WITH StMach-style ?? =============-
//
// 1st phase: `consume` .. is "pushing"  ->Vs
// 2nd phase: `produce` .. is "pushing"  ->Xs->TopPuller .. and "pull" Vs


// from: FP-getify
//
//           othher-srcs~~~~~~~~~~~~
//                          |   v  v
//                           >  [customer-glob]
// customer-io: (x,y,z) |          ^
//                       > (x,y,v)-+
// order-io:    v       |

// if we consider the problem "Actor&Scene" we notice that problem in that:
//  
//  what we want (push model):
//
//       |a|
//  a -> |a| -> |draw|
//       |a|
//       |a|
//
fn move(a: Actor) -> IO<()> {
    static actors = []

    let v = actors.assoc(a.id, a);
    // TREE_in_the_WOOD
    actors = v;

    draw(v)
}
fn draw(i: Vec) -> IO<()> { ... }
//
// .. since `actors` is "TREE_in_the_WOOD" in `move` .. in Rust `move` should be method of
// Scene, and `draw` too, since in such case we need "copy" our `actors` if we
// want give access to it (immut ref is to restrictive)
//
//  .. SO: it's looks like ::js_state2_actor_in_rust.rs
//
//  but when we do like in "book"-with-Scene&Actor-exmp we DON'T have
//      TREE_in_the_WOOD  and  "PUSH" MODEL
//    ..
// since scene "pull" actors from `actors` and `actors` is mutated

/// hah ... about the problem that in JS our "node" emit value which can be mutated
// .. AND .. in rust we can use Rc/Arc/&type .. BUT .. we need use "CoW" is we wan't
// mutate that "emited" value  ... BUT! .. if we don't mutate args -=WE_DONT_CARE=-
// ..
// SO .. we have "node" which have inside off it TREE_in_the_WOOD ... which we can mutate
// since it not aliased ... and this "node"  "emit" values which should be immutable ..
// .. and in Clojure we use effective CoW .. that is every "listener" receive like its
// own instance of the same value ... BUT .. if we don't mutate args -=WE_DONT_CARE=-
..
// BTW: pure fns may be not accounted in our "WATER-PIPELINE SYSTEM" .. only MONADIC ..
// i.e. even if we receive "value" on "push-model" not directly from IO, but it's "polluted"
//  .. then our fn is not-pure     ...  "vobw'em" like in Hskl

// i.e. purely-"push" based fn should be "pure"(althoug the can be wrapped into Monad, but
// "body" of such `fn` nevertheless is pure .. SINCE DOESN'T USE ALIASING) ..
// ... AND .. only "push" fn is mutable ..
//  .. SO .. se the trick
var o = {
    _x: null,
    set(x) { this._x = x }
    get(x) { this._x }
}
// althoug `get` like-pure , and `set` like impure ... IN OUR MODEL ALL IS OPPOSED
//
//  x x x >>> |push-set| this._x is TREE_in_the_WOOD |pull-get| >>>>
//
/// INDEED:
// `set` is "pure-push" fn .. and like-pure(but wrappend_in_monad, so "not-really" .. i.e. pure
// in terms of "NO_ALIASING"  .. JUST TRANSFORM)  ..
// .. AND .. `get` is "pure-PULL-based" fn it "like"-impure .. since some_fn which use `o` through
// ALIASING 'pull' some "random"(dependent on what state is setted by `set`) value.
// .. of course to be PULL-based(like Iterator) `o` must be LIKE "piped" .. i.e. some one should
// MUTATE IT THOROUGH `set`, i.e. it LIKE "subscribed" to some "event"   ... and in such way
// produse "sequnce" of "random" states (otherwise only one state .. and it's no "sequence" anymore)


// Why bad "unawareness"-of-mutation due MUT_ALIASING in "Actor&Scene"
///Why origin "Actor#move" don't sattisfie  BORROW_CHECKER in Rust??
// Because "Actor#move" was "setter" .. so has "PUSH-model" .. so should receive its
// arg-VALUEs as "own-copy"(or immutable) .. since as AIWE mutable can be only
// TREE_in_the_WOOD inside `some_fn`(captured by "closure" or "this/self") but emitted should
// be "own(copy)-or-immutable" value
//
//      v v >> |TREE_in_the_WOOD  >> | >> emitted_value(copied/immutable)
/// _______________________________________________________________________________________________
/// that's how MUT_ALIASING(and StMach-style) related to TREE_in_the_WOOD-model of "water-PIPELINE"
/// -----------------------------------------------------------------------------------------------




// Moreover (maybe) .. such "flow" in pipes between "nodes" .. can be compared with ActorModel
// and TREE_in_the_WOOD with "Vs{vec}" is exatly situation (I_guess) that described in
// Pony-lang .. like: Erlang uses msg-passing .. but it do it BY-COPY .. i.e. exactly what
// I did in our exmp(with Vs-n-Xs)  .. and PonyLang allow us send refs since we can 
// statically "set" "capabilities" on them .. EXACTLY like in Rust
//
//  .. read: https://tutorial.ponylang.org/capabilities/reference-capabilities.html
