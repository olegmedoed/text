// When you write `unsafe` Rust code, you should try to follow the same rules what the Rust
// compiller does. Some of the what I know:
// - don't use multiple mut-references that alias.
// - determine the owner of a resource.
// .....
//
// AFAIU: in Rust the programm unsafety means that programm either:
// a) crash (in cases like panic! it's not a crash, it's correct finish of a programm,
//           segfault it's a crash)
// b) corrupt data

0
// To implement `Hskl feature` of writing to-generic code with monad in Rust we can look at
// Iterator+IntoIterator
Self : Iterator<T>  .... // here Iterator<T> let's us expess that self has some additional pattern
// so we implement our `super-generic` code for this `generic type` (here) Iterator<T>
//  like
//              (v-- actually we here do type-`relaxation`, we suppose Self is container, so it's
//              pretty good hack)
trait Iterator<T> {
    fn bind<F>(&mut self, f: F) -> Self
        where F: Fn(T) -> Self
    {
    }
}
// and other types either implement this interface , either IntoIterator

1
// my Rust rules: (REWRITTEN)
// VOBW'EM: borrow-checker impose good `prog-design style`.
// So. if we receive something as immutable - no ona can mutate it(unles it's RefCell, but we can
// clearly see it in types)   .... BUT .. if receive something as mutable we can mutate it, BUT ..
// .. NOONE can MUTATE/READ it EXCEPT if we EXPLICITLY pass it by `&mut` or take ownership
// in `Scene&Actor` exmp in Actor#moveTo we can't change actor, and call the Scene#drap, since it
// IMPLICITLY READ  actor(the thing what we mutate, AND it CHANGE the res of side-eff[actor be 
// displayed in diff postion]),  BUT if it's happen IMPLICITLY how we can know that it coincides
// with our purposes, MAYBE we did it UNPURPOSELY
// 
// Explicit passing of mut-value let to (called-fn)-from-our-fn mutate things what we mutate too ..
// .. SO .. GENERALLY(not only about mutability) .. EXPLICIT PASSING BETTER THAN IMPLICIT.
// BAD:
//      v-- FUCKIN MUT_ALIASING
// * capturing by closure instead of passing to clojure as arg -- like in PonyFoo generator[io] 
//   exmp, 
// * setting value in the object for reusing in another method instead of explicit passing as 
//   arg -- like  MOCHA assiging `isAsync`) (in Rust you can't even extend obj, BUT if you define
//   this property, you MUST borrow object by MUTABLE ref,  NAHUI NADA yet another time use mutable
//   borrowing if we can avoid it)


7
// when you use macro then is better they receive named parematers, so instead of
try_write_num!(u16, writer, body.tls_size() as u16);
// write
try_write_num!(writer, num_type: u16, value = body.tls_size() as u16);

8
// my Rust mantra:   (DON't write BAKLAVA Code)
// Write as tiny abstractions, as possible. 
// Awesome,cool abstraction "1" what need many layers is much worst then abs "2", which is still
// good, but not so cool as "1", BUT it takes only few layers.
// From stush I've listened in BikeSh from Yehuda and Diesel.auth they try too build stuff in
// Ruby-Lisp(Graham) style in Rust + Power static-typesys. And boast of how it's abstarction is
// cool, and gives the cool tools(easy to use, ergonomic, expressive) to use for people, (and
// they suggest that most people don't care about what is sit under the hood of this library,
// Yehuda even mentioned the Rayon, thich feel so high level)(DON'T CARE SIMPLICITY, BUT EASINESS).
// But if it's fat abstraction it's bad to me, I pretty ok this eDSL, but that's not for
// using everywhere (as Graham affirmed), in some cases it's cool(there is things where shortness
// and expressivness is cool), but usually thin abstractions is better option.
// Trait system gives us all tools what we need (usually) to build this cool stuff.


10
// "Interfaces should be designed orientings on the cases where you suppose abstraction, otherwise
// it's leads to leak abstractions". My refactoring of petgrapth is example, so ... iterators is 
// general and universal interface, and it's so good suited for almost all stuff what we need to do 
// with graphs, that it's JUST ENOUGH. But in the same time graph realization details so much 
// influence on most operations on graph, that it's have no sense to abstract from it(because it's 
// leak), and the [GIST] ->. You should remind himself the phrase from SICP: OO(interfaces 
// generally) is means for abstraction, but not for emulating real mechanisms. SO, nevertheless you 
// have some set of types(classes) what seems to you like something similar (especially comparing to
// real-world mechanisms or phenomens) it's doesn't mean that we should gather them under single 
// interface (exmp: (two realization of graph from petgraph is obvious) if we have class Dog, Fish, 
// and Bird, and this phenomens is gathered in our mind as Animals, .....  nevertheless this does 
// mean nothing, since interface is NOT first of all about filosophy behind the objects(types), or 
// semantic relationship between them, it's firts of all MEANS FOR ABSTRACTION, {
//   JUST: often can happen that if objects of several types has relationship in
//   RealW-philosophy behind them then they soonly most likely has the same relationships in terms
//   of (programm)-ABSTRACTIONS
// }.... so you should design interfaces keeping in your mind places where this interfaces should
// serve for interchangeability of the object(types)).  << use-case oriented
// And of course prefer COMPOSABLE interfaces (in Rust iterators, in Hskl Monads,Functors,App..)
// Maybe you discover another composable interfaces in Rust except the iterators. Composable
// interfaces is like a glue what serve as basis for you program, the basis what gather you program
// in single mechanism(of course it shoud be univesal framework like REST, monads, iterators...etc).
// p.s.
// About my refactoring of petgraph: Instead of single FAT(as it turns out it coincide with 4
// SOLID principle: ISP(interface-segregation)) interface, it's better define several
// interfaces that is USE-CASE ORIENTED, here the iterators take the responsibiliti to be cool
// interface, but generally you should write USE-CASE ORIENTED interfaces, SO, instead of just
// defining  a Graph interface, because (AIWE) you think that if there is phenomen then for this
// phenomen should be interface (!wrong), you should define USE-CASE ORIENTED interfaces, where this
// abstraction(it actually may coincide with phenomen sometimes) can be used,  that leads to lower
// chance that your abstraction will be leak!!!  (Graph leaks definitely, very different
// representation, that impact on how those graphs impl-ons is used, that why it's was so
// difficult to generalize it to me)
// in SOLID[ISP]  my USE-CASE ORIENTED === role interface (ohuet', I'm independently come to the
// same design principle as SOME-smart-people)
// also:
// the style of Rust like:
fn some<T>(o: T) -> T where T: OneI + TwoI + ThreeI {..}
// make us willing to write this role-interfaces(USE-CASE oriented), since in func we can pick what
// `roles` interested us
10.1
// Also, BDD style help us to write more USE-CASE-oriented(role) interfaces, since BDD when you
// start using TDD you ask itself "what to test? what the tests I should write first of all?", so
// here BDD comes in, it tell you write that if you have type(class) then write the tests what
// describe behavior (USE-CASES) of this type, so you willing now describe such interface in
// your tests how you will be use your type, so interface will be use-case(ROLE) oriented
10.2
// Also, why ISP don't attract my attention initially, since when you read this principle it tells
// you almost nothing, because .. on the surface it's to primitive, say: "okey, not to build
// classes with to many methods", but (your next think) it also similar to SRP(single-resp), or
// if I have split big class how I should split it (I can divide it on classes with 1 meth only ,
// it's will be like flexible, but stupid)
// SO, ... the understanding of USE-CASE oriented interfaces gives us the deep understending of
// diff between ISP and SRP (SRP it's just about one responsibility, ISP is about how choose this
// responsibilities)
10.3
/// Exmp from Uncle.Bob-blog:
// we have business logic what use DB, u.Bob said that because of DIP(depend-invers) more
// higlevel layer(business logic) should not depend of more low-level layer(DB) and we use
// interfaice to abstract of DB, and ... Junior: "ok, I think I get it. You're just using
// polymorphism to hide the DB-impl..ion from the business rules. But you still have to 
// have an interface that provides all the DB tools to the business rule" ... and u.Bob: "WRONG!
// We don't try to provide all the database tools to the business rules. Rather, we have the 
// business rules create interfaces for only what they need. The impl..on of those interfaces can
// call the appropriate tools"   ... that is ISP(inter-segr)
mod main {
    trait BusinessRuleGateway<SomeThing> {
        fn save_something(s: SomeThing);
        fn get_something(id: String) -> SomeThing;
        fn start_transaction();
        fn end_transaction();
    }

    struct MyBusinessLogic { /* which use BusinessRuleGateway to communicate with DB-storage */ }
}
mod db_lib {
    struct MySqlBusinessRuleGateway {
        mysql: MySql, ...
    }
    impl<SomeThing> BusinessRuleGateway<SomeThing> for MySqlBusinessRuleGateway {
        fn save_something(s: SomeThing) { /* use MySql to get thing */ }
        fn start_transaction() { /* start MySql transaction */}
    }
    // So we have USE-CASE oriented interface what use only MySql tools what we need,
    // in fact It's Java style (AFAIU) what u.Bob use,
    //      ```java
    //  class MySqlBusinessRuleGateway extends MySql implement BusinessRuleGateway {
    //  }
    //      ```
    // in Rust we can just
    impl<SomeThing> BusinessRuleGateway<SomeThing> for MySql { ...  }
    // So we have USE-CASE oriented interface what use only MySql features what we need,
    //                  NO FAT INTERFACES
}



14
// `http:server.listen` from Node, behaves diff-ly depending on args(types, amount ..), that's
// stupid(no mne pohui uzhe), but, I want emphasize how convenient it's in Rust, even if we want
// to use single method(`listen`) for all cases we do it by useing `enums`
enum ListenParams {
    Handle(usize, Option<Fn()>),
    Path(String, Option<Fn()>),
    HostName {
        port: usize,
        hostname: Option<String>,
        backlog: Option<String>,
        cb: Option<Fn()>,
    },
}
impl Server {
    fn listen(params: ListenParams) {
        match params {
            Handle(handle, cb) => {
                .....
                if let Some(fn) = cb { fn(...) }
            },
            ...
        }
    }
}
// So easy to parse this params, and separate logic for handling every case, instead of many(that
// take a half of fn-body) type-chickings, and args-reassignments
// p.s. also it's exmp where runtime-pattern-matching is better options then static dispatch, like:
struct Server<T> { ... }
impl Server<Handle> {
    fn listen(params: Handle) {}// Handle,Path here diff structs
}                                 
impl Server<Path> {             // BUT, of course here using static-dispatch is stupid
    fn listen(params: Path) {}  // and also may lead to code duplication in other fns of Server
}                               // that cause you to do stupid workarounds, that make code worse
// p.s.
// Or you can sometimes write something like:
impl Server {
    fn listen_with_handle(h: usize, fn:..) { .. }
    fn listen_with_path(path: Path, fn:..) { .. }
    fn listen(post: u16, host: Host, .. ) { .. }
}
// Someone may say that is so inconvenient, and not flexible, in Julia for exmp we can just use
// "multimethod",  BUT, if you pass Handle, xor  Path .. xor port,host...   YOU SHOULD BE AWARE OF
// IT, so it's not so hard to write additional several later in the name of fn,   SINCE  YOU SHOULD
// UNDERSTAND THAT nevertheless it may have identical name, it's diff fns ,   .. AND  ..
// ... @@ IT'S NOT THE PLACE FOR ABSTRACTION @, so we don't bother to be abstract here, we dont' try
// to be abstract, we care to make concrete action, and should realize what we do here(otherwise
// it CAN BE A BUG).


15
/// when I say `on top of stack`, it means initial caller (exmp: `main` on top of stack), and when
/// I say `go down` then I mean to call next fns (like main call other fns, and in such way go down)
///
// in `slab` crate `replace_` do the check whether `idx` is in range(correct), and other fns(that
// use it) dont check `idx` since rely on `replace_` , exmp:
pub fn remove(&mut self, idx: I) -> Option<T> {
    let next = self.next;
    self.replace_(idx, Empty(next)) // replace_ do check(and return None if fail)
}
/// replace_ "nav9zhet" all fns above it the interface (...) -> (Result/Option)<...> and makes
/// them to handle it, but if we not do check in `replace_`, we can forget about this check
/// in some-fn about and .. nothing tell us about it
// but it in such case exmp where it makes sense to delay error-report (don't check-n-fail
// immediatelly, but rely on undelying fn) , BUT in Rust(oh, how it's cool, again) we can be pretty
// ok with it (if we need, like here, to not duplicate checking in every `replace_` fn-user) since
// the errors DISPLAYED IN OUR TYPES, espcially in cases like
Result<OkType, SuitedKindOfErorr> // since <<< we can see that func to which we pass args do the
// checking on correctenss, and return Err of SUITED FOR US KIND ...
// eventually we check this error with patt-matching, that in such case equeal to `catch` in js
/// - So, when cut errors short and when we can let them go down to the stack ?
// - proceeding from this exmp, we can let if the error nature[kind](and returned err-value) has
// the same semantic (here idx is out of interval),
// SO,
// what bad with JS, and why I more willing to "CATCH fast", becaut in JS if we let pass
// computation to the "stack", we don't know that the error will be of appropriate type, so we can
//  have such stupid siteation like
function one(x) {
    ..;
    try { two(x) } catch (e) {...} ; ..
} // and ^- here we can receive error absulutly no related to you fn, for exmp
// "JSON can't parse token..", because somewhere in your stack(in 10 level below) due to
// semantically-wrong args in you fn (here `one`), and (optionally) lack of checkin in `two`,
// something go wrong, BUT, as result we have error in our args(of `one` func) but receive
// errour "hui zna de", and this error not related to us
// also, since es6 we can easely makes own type of errors, and do thing similar to Rust
try { two(x) } catch (e) {
    if (e instanceof OneKindError) do_something()
    else                           throw e;
}
// also, exmp
    epoll::epoll_ctl(self.epfd, EpollOp::EpollCtlAdd, fd, &info)
        .map_err(super::from_nix_error)
//
// here we convert error of one KIND to error of appropiate type for the fns on top of stack
//  (p.s BUT WE DO IT EXPLITICLY)


16
// So, in JS  "Actor"-instance has `moveTo` method, which mutate actor state, and `draw` the "Scene"
// (btw, `draw` is meth of Scene !),   BUT,  by mutating itself, "Actor" mutate "Scene",  SO 
// "Actor"-instance ((== p.s. ActorPostion is BETTER ==)) PERTAIN! to "Scene"-instance, 
// ..
// BUT, it's the basis that it's DEPENDS on SEMANTIC of certain case
// for exmp in (github.com/nnupoor/js_designpatterns) / mediator.js pattern
// we have similar situation, BUT, "Mediator"-instance (AS-FOR-ME) can't be treated as `mutated`
// when "User"-instances "converse" between each other,  IT'S JUST DISPATCHER. ... SO, here it's
// reasonable to use INTERIOR mutability in the form of `RefCell`
// ..... SE rest_api__bdd:##7


17
// earlier type-construction like
Arc<Mutex<Vec<i32>>>
// could looks like very (too)complex(so many types put),  BUT, now .. HOW IT's COOL, we can
// create new functionality by combining(nesting) types, SO initially we have just
// construction(Vec) that is just manage "peace of heap", and have it's size, granularity(type size)
// .. and with new types we add new functionality without extending Vec.
// ... So .. it's just like another kind of subtyping(subClassing in OO)
// .. aslo it's similar how Transformers in Hskl extend functionality of Monads


18
// About "Like" structural subtyping in Rust(but for cases where we need peek SOME PARTICULAR abstr)
// It's inspired how in Ocaml `modules` can structurally implement `signature` if it implement all
// interaface(meths[meths signaruters, names], type, etc) , that is we no need declare it
// explicitly(that `module` impl `signature`) ..
// .. In Rust we can do it with attributes, practical exmp in "mio", where we abstarct from "unix"
// and "windows",  ... So .. basically ..
#[cfg(unix)]
struct TcpSocket { .. UNIX specifig (NOTE: NOT pub) }
impl TcpSocket { fn connect(addr: SocketAddr) -> Self; }
#[cfg(windows)]
struct TcpSocket { .. WINDONWs specifig (NOTE: NOT pub) }
impl TcpSocket { fn connect(addr: SocketAddr) -> Self; }
// .. so .. we depending of `flag` we `structurally` implement interface("module-SIGNATURE in Ocaml 
// terms")


19
//  (p.s. after writing this post:  it's similar to what I write month before this post:
//          VALUES_ARCHITECTRUE --- so, again, I independently come to style what cool Rustation
//                                  use)
// In "mio" author often separates `plain structures` and wrappers around them for some "semantic
// behavior", for exmp:
event_loop::Config // is plain struct, and ..
event_loop::EventLoopBuilder {
    config: Config
}
// .. is wrapper that "IMPLEMENT BEHAVIOR" that "step-by-step" build this config, and eventually
// build EventLoop with this config
// (So, it's just another kind of "Builder-Patt" .. BUT .. this post is not about Builder-Patt)
// another exmp
poll::ReadinessQueueInner // plain struct, and ..
poll::ReadinessQueue {
    inner: Arc<UnsafeCell<ReadinessQueueInner>>
}
/**  {
        WOW: `9 vryvaus' tut lol`
        ..
    Actually pattern described in this post is way to decide in which way we store our resource.
    Since in rust every resource may be: &mut T, &T, T, Box<T>, Rc<T>, Rc<RefCell<T>>, Arc<T> ....
    So whereas in Java/JS all resourcess is just Gc<T> ... in Rust we should expleicitly decide
    how we store resource.
 }
 */
// ..., AGAIN, the `ReadinessQueue` is IMPLEMENT BEHAVIOR.
//
// ........... SO .. Maybe it's good practice, and yet another exmp of "Structure/type reusability
// design-strategi" which is usually common in Rust(Hskl) with traits/typeclasses
//
// ALSO:
// in libstd/thread/mod.rs    ..
struct Inner {
    name: Option<CString>,
    lock: Mutex<bool>,
    cvar: Condvar,
}
struct Thread {
    inner: Arc<Inner>
}
// .. So, here cool exmp of "combining functionality" and "separation data and behaviour"
// So, Thread here "HOLD" the data [through `inner`] (in primitive case Thread can be just Inner),
// and combine additionally functionality to how this data is "kept"(Arc),  and additionally save
// the semantic label "Thread" for which eventually define all behavior (and incapsulate Arc
// functionality and data)
// So, in primitive(bad) style
struct Thread { name, lock, cvar, }
type ThreadWhatItsSupposedForUs = Arc<ThreadOrigin> // Eventually it's what we will use as `Thread`
//
// .. So, here Thread do "like" all correctly, it has data, and it implement behavior, BUT,
// it's not "acquire" the "Arc" functionality, BUT semantically Thread SUPPOSED(SHOULD) have this
// functionality,   SO it's should INCAPSULATE this functionality ... 
//      ... AND THAT HOW IT'S DONE IN RUST
