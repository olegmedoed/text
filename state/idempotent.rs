//! mut_aliasing -- several links, AT_LEAST one of them is MUTABLE
//!    BTW: bunch_of_closures_with_mut_refs is like obj which alias through its params, which is
//!     mut_aliased refs on some another obj, or shared data
//!         that_is:  CLOSURE_CAPUTRING == OBJ.MUT_ALIASED_REFS
|
0
// fns with side-effs: --== IDEMPOTENT VS NON_IDEMPONTENT ==--
//
/// fn is idempotent because its caused side-effs SIMULTANEOUSLY fulfill (2-former:wrong) 1 cond:
///     1. base on "input" or "immutable free-vars" .. NO mut_aliasing
///     ..
///     (here was 2nd statement) Just change value .. not ADD.
///         .. BUT .. it's NEVERHTHELESS .. 1-statement(MUT_alising)
//
// (small caveat:  JUST REMINDER)
var x; fn some_fn(n) { x += n*x }
// not IDEMPOTENT because: *WRONG: we update, and/but not completly rewrite `x`,
//                         *RIGHT: mut_aliasing (our computed value for `x` rely on mut_aliased `x`)
// (BUT)
//         BTW(p.s.)--v: `some_fn` break rule:
///         "mutate only TREE_in_the_WOOD , emit "own_copied/immutabl" value"
//          (TREE_in_the_WOOD is accesed or through "self/this", or "closure"-capturing)
//
fn some_fn(a = [], n) { a.push(n) }
//  ^-- here was: "ADD value, not just change."
//      BUT actually .. it's also can be considered as MUT_alising .. since result of `push`
//      depends of `a`, .. and if we call 2 times `some_fn` of course it's gives different sideeff,
//      since its computation based on MUTated value, ("EU ZHE")
//      ..
//      From the other hand .. `some_fn` can be considered as IDEMPONENT, since it's always gives
//      the same side-eff for the same input-VALUE .. that is if we alway will give `[x] as a` ..
//      we always receive `[x, n] as a`
//      ..
//              (v-- chut' ne udalil :lol:, podumal wo hn9, A NE-NE-NE)
//>     ... SO, if "fn" mutate own args, and computation which "generate new value,
//       to update old value in args (in case of [] is some "next-empty-cell" in arr, and `len`)
//       is based ON THIS ARG", ..
///         we (most likely) will consider it as NOT IDEMPONENT
///     .. SO .. WHAT IS IMPORTANT ??
//          despite to be NOT IDEMPOTENT (from "caller" perspective) .. since we have
//          2 refs (caller and callee) and "our"(callee) is `mut` .. WE HAVE ADVANTAGE
//          of EXPLICIT PASSING THIS REF(to callee) , BUT unfortunatly in JS we can't write
//          `&mut reff` ..
//          IT'S (1) PREVENT "ORDER"-PROBLEM described above (2) makes MORE OBVIOUS for
//          "reviewer" that "a" can be mutated (he at least SEE this "a" is passsed) ..
//              ..but `some_fn(num)` is MUCH WORSE
//
///     TRY TO MAKE ALL EFFECTFULL-FN TO BE IDEMPOTENT
|
1
// ALSO: (p.s. JS here, ONLY SINGLE-threaded programs and (in this post) SYNC)
{
    fn calculateAverage(list) { // << obviously IDEMPOTENT
        sum = list.reduce((sum, x) => x + sum, 0);
        return sum / list.length;
    }
    var sum, nums = [1,2,4,7,11,16,22];
    var avg = calculateAverage( nums );
}
// Getify said that (if `sum` not mutably-aliased some another closure)
// mutation of `sum` here it's "UNOBSERVED SIDE-EFF"  ..
//  (.. although, such "UNOBSERVED MUTATIONS" easy can be eliminated, and we can use
//          pure-style easily here  (but actually here it's just MATTER OF TASTE)
//  )
//  ... SO .. what reasons we have for IDEMPOTENT MUTATIONS aka "unobserved side-eff"?
//      ... either NONE or "OWNED DATA"(P.Graham)
// .. and further author cite Hickey:
///  "If a tree falls in the forest, but no one is around to hear it, does it still make a sound?"
//          (^-- NO SHARED MUTABLE ALIASING .. or ..
//          .. we INCAPSULATE some data to MAINTAIN invariant [like in
//                  exmps/js_state.rs:state_shraing] )
//
//  .. so it "like" pure-fn, or in term of P.Graham fn what used "owned data"
fn get_cached_fn() {
    /// AS-OPPOSED to "`a` in `some_fn`"(above) `cache` is not "mut aliased"(only one ref which
    /// mutate and read)
    var cache = {};     // << "owned data", "unheard tree in the forest"
    return fn XX(n) {  //    "unobserved mutation", "like-pure", "right incapsultaion"
        if (cache[n] !== undefined) return cache[n]     // ....  NAZYVAI KAK HOCHEW'
            ..... /* do computation */ cache[n] = res_of_comutation();
    }
} // author: "The point is that if XX(..) is the only part of the program that accesses 
//      and updates the cache side cause/effect, so it's "like"-pure" 
|
2.0
// ALSO: ORDER/FREQUENCY DEPENDENCY
{
    var users = {}, userOrders = {};

    fn fetchUserData(userId) {
        ajax( "http://some.api/user/" + userId, fn onUserData(userData) {
            users[userId] = userData;
        });
    }
    fn fetchOrders(userId) {
        ajax( "http://some.api/orders/" + userId, fn onOrders(orders) {
            for (let i = 0; i < orders.length; i++) {
                // keep a reference to latest order for each user
                users[userId].latestOrder = orders[i];
                userOrders[orders[i].orderId] = orders[i];
            }
        });
    }
}
// `fetchUserData` should be called before `fetchOrders` ... AVOID SUCH "LOCAL STATE MACHINES"
/// [GIST] there is should NOT BE ANY DEPENDENCY between ORDER/FREQUENCY OF CALL to
/// "getters/setters" ..(that is (kind of) SHOULD BE ONLY IDEMPOTENT-EFFECTFUL-FN)..
/// of some "local state machine" aka "class instance" aka "object"(with incapsulation)
//  ..
//  ...So.. in this exmp, (also Miwko: initializing DB, which depends on "glob-state" - that is
//  "aliasing") ..    `fetchOrders` depends on
///|  to be called.. IN SOME PARTICULAR STATE .. and this state is reached through
///| "PARAMS-REF"(aliasing) ... SO.. in such case,
///|      -=! SUCH STATE SHOULD BE PASSED DIRECTLY !=-..
///             (as in Miwko db-inital we refactor too)
///   ..to AVOID "ORDER/FREQUENCY-OF-CALL(getter/setter) DEPENDENCY"(to set "needed" state)
//  ... any Getter/Setter should be designed in such way to BE ABLE to be called in ANY STATE!
//>>     OR.. THIS "ORDER_DEPENDENCY/COUPLING" SHOULD BE INCAPSULATED IN fn
///         (BUT EXPLICIT PASSING OF MUT_ALISASED DEPENDENCY AS ARG
///             IF IT POSSIBLE
///         IS BETTER)
//       (in Miwko db-exmp: if we don't pass explicitly "mut-aliased"-state , then we should
//       incapsulate all COUPLED fns in single fn .. that is prepare NEEDED STATE ..
//       BUT..  IF THIS CHAIN OF COUPLED-fns is too long ..
// |>           WE RETURN TO THE PROBLEM ..
//      since we refactoring of fn-that-incapsulate-coupling is ERROR PRONE .. SO
///      THIS CHAIN OF COUPLED_FNs SHOULD BE SHORT .. USUALLY === 2 )
//      ..
// Of course to achieve some "desired side-effs"(without them programm is useless) we 
// OFTEN need call "getters/setters" in some particular order ..BUT.. that DOESN'T mean that
// this order should become SPECIAL(HARDCODED) aka ORDER DEPENDENCY .. we just peek that order,
// but it's should NOT BE SPECIAL for our "get/set-ters".
//
| 2.1
//  So.. why I looked at ::exmps/js_state.rs::state_sharing fn .. and though: "why I need
//  "immutable-world", clojure, etc .. "ved'" this fn pretty good, and do its job well"
//  ..
//  .... BECAUSE: this "local-state-machine" don't rely on PARTICULAR STATE and ORDER/FREQUENCY..
//  so IN ANY STATE ... we can call "get/set-ters" in ANY ORDER  ..  AND IT'S OK, IT DO EXACTLY
//  WHAT WE WANT, EXECTLY SIDE-EFF WHAT WE WANT.
///     After createing an object we can start do ANY "STATE_TRANSITION" which this
///     object has, BUT, if only some STATE_TRANSITIONS allowed, IT'S ERRORPRONE.
// ...> whether "produce" or "consume" be called first .. WE DON'T CARE,
// ...> what the state we have in the moment of call to any fn(cons/prod) .. WE DON'T CARE...
//                 ..(some particular-state doesn't have special meaning for us)
// .....
///|"consume"(as a getter[but it aslo a setter]) is NOT IDEMPOTENT .. because..
//  for this I need pass the list-for-consuming EXPLICITLY..
//         (the main condition for IDEMPOTENCY - absence of MUT_ALIASING[here `list`])
///  .. BUT:
///   It INCAPSULATE "INVARIANT" of "prefiex is chenged only when we "splavili" old values in a
///   list and clean it up" 
///>> .. INCUPSULATEs IN ONE STATE_TRANSITION
//    .. SO .. it's let's both (`consume` and `produce`) "fns" works without FEAR about shared 
//    (between them ) STATE(and INCAPSULATED) on which the relie(mut_aliased) since it doesn't
//    aliased elsewhere("tree in the wood") .. and PROPERLY changed (INVARIANT) in `consumer`, and
//    this change INCAPSULATED in right place
///   that_is: WE DEFINE ATOMIC_STATE_TRANSITIONs, why atomic, since state mutation/transaction
///   can't be "interrupted"   (here exmp: "prefix" changed BUT we not yet "splavili" values from
///   `list` -- IT'S INTERRUPTION of STATE_TRANSITION)
///    ..
//    .. also ..  it doesn't rely on any particular state of `list` when we need "splavit'", so
//    we doesn't need MAINTAIN THIS INVARIANT.
///   ..
///   | SO.. we may say, that every "local-state-mach/obj" has some "patterns" of state_changing
///   |  .. let's call it "STATE_TRANSITIONS", and we should properly "FORM" this
///   | state_transitions: .. incapsulate "INVARIANTS" in ONE_MOVE_PHASE, and incapsulate 
///   | "DATA-ACCESS"  ... !!! TO MAKE THEM ATOMIC !!!
///   ..
///   AGAIN: (1) PROPER DEFINE  (2) MAKE ATOMIC  .. UNIT-test those 2-RULES is ACCOMPLISHED
//    ..
// | moreover: list consuming, and set-new-prefix is (temporary) COUPLED ..
// |                                                     .. that is ORDER DEPENDENCY ..
// |  ..BUT.. we INCAPSULATE it in "consume" - WE CANNOT INDEPENDENTLY SET PREFIX .. since
// |  it COUPLED .. and if we could(set pref independently) that would CREATE ABILITY to write
// |  code with ORDER/FREQUENCY DEPENDENCY(or call it temporal-coupling)
        BL99, da "STATE_TRANSITION" eto prosto well-defined API u obecta kotoryi
        incapsuliruet TREE_in_the_WOOD
| 2.2
///   |about STATE_TRANSITION : since I invented this term after written bellow--v)
//    |   to achive any goal with "response" object .. we need pass some STATE_TRANSITION,
//      and every this STATE_TRANSITION make sense (OFF_COURSE) only in ATOMIC form
//      ... `req, method, action` <<- THIS-IS main STATE_TRANSITION of our object, so
//      we need INCAPSULATE(ATOMICALLY_BOUND) it,  ... i.e. MAKE SURE it's ATOMIC
//    ..
//      .. in expm of Bugaenko-request .. we can either do..
// 1. ***
Request req = new Request("http://exmp.com", POST);
//..
//  .. and NO `self.method`-setter .. that is we create API that EXCLUDE possibility of
//  "INCONSISTENT STATE"(where getters can be "buggy" with wrong ORDER-dependency)
///         AGAIN: we INCAPSULATE this "ORDER_DEPENDENCY/COUPLING"
//      (in some sense `req` "like" immutable, that is to use "GET"-req we NEED CREATE NEW REQUEST)
// 2. ***
res = req.fetch("POST", body) //    we talk about SYNC calls in this post
//..
//  METHOD should be passed explicitly to `fetch`.. REALLY!  why "requst"-obj should contain in
//  its state a METHOD param? ..  (also `body`)
//  .. that is AGAIN: we incapsulate "coupled" effectful-methods( firstly set METHOD, secondly 
//  fetch result), and explicitly pass the state of which effectful method is depend .. that is
//  make method IDEMPOTENT
//    ..
//    p.s. if we want "bind"(set object to state where it's use some-particul. METHOD) to some
//    particular METHOD in JS we should just use "bind"(aka Carrying)
//      .. or maybe in Java-like create some OBJECT-WRAPPER(here Fetcher) .. which AGAIN
//      configured(INCAPUSLATE-COUPLING)-on-initialization(that is IMMUTABLE)
let res_obj: Fetcher = req.fetch("POST", body);
/* ... somewhere ..  >>> */  res_obj.get_result();
/// {
//  after 1/2 year: also '+' of such aproach as opposed to
    req.fetch(POST, body, &mut res_obj) // because if we create `res_obj`(res_buf) inside
//  `fetch` we know that we have no aliasing SINCE: only in rust we can know that if we pass
//  `&mut res_obj` then there is not aliasing .... BUT.. in Java it's just impossible ...
//  so it's another trick how BY MEANS of api-design we can eliminate problem of
//  aliasing/mutability
/// }
//     .. and for now: we "BIND" our req to particular state .. but INCAPSULATE this
//    "COUPLED MUTATIONS" like "consume" in "exmp/js_state.rs::state_sharing"
/// {
//      after 1/2-year:  OR: If we even store `fetch`-result in `req` object ... we should
//      use `check / throw-excpe` that we can do next `fetch` only after we consume already
//      fetched body
/// }
//..
// |...  so you can see how undestanding "Mut-aliasing"+"order/frequency-dependency" lead us
// |    TO CHANGING THE DESIGN(API) of our programm.
//
| 2.3
////  .......... MUST_SEE_ALSO: FunLight-ch5-Purifying
//         (note: closure-captur == obj.param-ref,
//         tags: "local-state-machine" .. INCAPSULATE mutation != HIDE mutation)
//                                        INCAPSULATE mutation == LOCALIZE mutation)
