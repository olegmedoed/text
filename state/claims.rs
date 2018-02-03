// what do you think about such claims ???

///
///  Mut data should be TREE_in_the_WOOD        ( (c) BORROW_CHECKER :lol:)
///

// note: if we consider  js_state::state_sharing{ list } .. `list` is !LIKE! MUT_ALIASING
// since it mutated by `produce`, and readed by `consume`  ..
//  .. 
//  so .. as we see now, in OO langs such separation not "clear" syntactically
//  .. BUT .. Vs,Xs is more "clear" variant
//  so
//  You should realize what "data-flows" go through you object/(node-in-(water)pipeline)
//  and
//  Maybe: SRP is about single "data-flow" .. like in `js_state::state_sharing`
//                      |
//                      v
//              data       >  vvvvvvvvvv | <(pull)
//                                           > (xv,xv,xv,xv)
//              new_prefix >  x    x     | >(push)
//
// BUT one is clear now:
//  Bad sitations happend when "pull-getters" emits not "(owned-copied)/immutable" data
//  ..
//  Since:
//      1. this data can be consumed by several (unawored about each other) "push-fn"(consumers)
//          and they will IMPLICITLY propagete mutations (what they unexpected) to each other
//              (like data-race/race-condition in concurent environment)
//      2. "getter" can emit "ref" on its "own" TREE_in_the_WOOD .. (and from we now it becomes
//          IMPLICIT_SETTER)
//  ..
/// SO maybe : SRB + getters only get(even if they mutate its TREE_in_the_WOOD, but "emitted" value
/// is "own-copied/immutable")
///     .. SOLVE the problems like "pipeline-stle" desribed in js_state(2)

// also see where TREE_in_the_WOOD can be avoided like  Bugainko exmp
Request request = new Request("http://example.com");
request.method("POST");
String first = request.fetch();
request.body("text=hello");
String second = request.fetch();
// 
// .. the point here is that "Req { method: String }" `method` is not suited on role
///TREE_in_the_WOOD ... what "data-flow" it consume as a "node" in "pipesystem" ???
//   - settings of "method" in Req-instance ??? Stupid "data-flow"
//                  V
//   m m m m        >> | <(pull)
//                         > |fetch| (m,url) 
//   url url url    >> | >(push)
// ..
// STUPID!! , also: in `state_sharing` "v"-data_flow is constant(post9nnyi) and "odnorodnyi"
//  and well-defined{ it clearly makes-sense since without it our "node" lose
//  its functionality and sense }
//  ..
//  BUT in case of "Req::method" it's not even CLEAR if we need that "data-flow" of
//  "methods"  ...  most likely NO  .. so:
Request req = new Request("http://example.com", "POST");
String fst = req.fetch(); // BTW: of course `fetch` return string, instead of save it in `req`
    // because of reason DESCRIBED RIGHT IN THIS POST {
    //  or we should use "check / throw-excp" which CHECK STATE TRANSITIONS of `req`, that is
    //  "consume result before next `fetch`" ... describe it in tests.
    // }
//
//..
//.. Althoug!: in langs like Rust, in app where performance is important, create new Req, in
// situations where we can "reuse old one" is COSTLY  ... so TRADEOFF.


//
//  sometimes even if we tell that BUG was happened because we forget "past" some
//  if-"check" in our fn  ...
//   .. real "deeper" reason can be AGAIN MUT_ALIASING, since when our data can be mutated
//   from different sources IMPLICITLY in UNCONTROLLED(hard to understand way){ when we DON'T
//   have clear well-defined "DATA-FLOWs" for our object, or obj is a mess-mix of
//   data-flows (NO SRP) }
//   ..
//   ... OF COURSE we need 100500 "self-protecting" if-"checks" to see
//      WHETHER OUR (mut_aliased) DATA IN RIGHT(suited for current fn) STATE.

