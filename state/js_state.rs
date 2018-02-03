// here may be mix of Rust/JS in same code exmp;

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
}
// How I come to this exmp - I think how write such state machine in CLojure.
//      2017-apr:
//          In clojure you use Agents/Refs/Atoms/etc
//
// For now I want to see E.Meijer "FuncProg" lecture, and see what I can do with
// it's view at things aka "FP - is imper-progr with explicit control over side-effs"
//      (clojure just abondon "mut aliasing" - that just one of many technique)

@1
// .. from perspective of E.Meijer we should define "protocol", between
// "producer", and "consumer".  ... and (from my perspective) to localize the
// state-machine due a lexical-scope
//      ^-- Fuck, "da eto" obvious way to program in JS.
//          I think Koa can be example where "protocol" is designed pretty clear
// ..
// Monads/Comonads
//          .. Meijer calls Task Comonad, but Task is C# analog of Future which is monad .. ???
// Objervers(push)/Iterators(pull), Generators, (REST likely) << for "seq"
// (and maybe some another "universal" computation-interafece) .. all they capture
// practically ALL patterns of PROGRAM/COMPUTATION control-flow +..
//     ..+ explicity-(mutation/state-passing)
// .. and some cases where we have state-machine .. we need LOCALIZE it with lexical-scope
// of functions...
// .. pratically any obj in OO{INCAPSULATION} is like state-machine with localization..
// BUT..the  gist that we should not just write all programm base on those "state-machines" ..
// BUT use tools like Monads/Comonads,etc .. TO EXPLICITLY CAPTURE GENERAL
// CONTROL-FLOW of our programm == SET "PROTOCOLS" for this STATE-CHANGING-FLOW ,
// to control STATE - which is changed with side-eff..
//          (and eliminate COUPLING[ORDER/FREQUENCY DEPENDENCY] in "get/set-ters")
// ..
// .. that is .. controll explicitly all side-effs,  but SOMETIMES it's just
// more ***simple to LOCALIZE mutation instead of explicitly control it with
// "protocols"(like Monads..etc)
//     ^-- more over .. THE ONLY ALTERNATIVE (to state-machines)IS PASSING THE
//     "WORLD" .. SEE: Meijer "FP-interview - Ticks-exmp"
//     So.. instead of "Passing-the-world" it's more practically to LOCALIZE
//     this "world-changing" in "Local{incapsulated} state machines" .. AND
//     DEFINE INTERACTION between them and GENERAL-CONTROL-FLOW(STATE-FLOW)
//     through "protocols" ala
//     Monads/Comonads-Generators/Observable/Promises-REST(in distributed sys)..etc
//

@2
// E.Meijer:
// "the real trick that, when you look at a programm, you should not say
// `oo, mutability is bad`, you should realy look at what effects that are
// going on and HOW YOU WANNA TO COMMUNICATE THIS EFFECTS BETWEEN DIFFERENT
// PARTS OF YOUR PROGRAM (how you design the "protocol"), ... and in case of
// Objervable/Enumerable you have to choose  how you want expose your "values"
// as pull-base or push-base"
//
// Also Clojure effective passing of the "world" of "programm-variable-states"
// due "Global hash-trie" ... (see exmp of Ticks in Meijer FP-interview)
//
// Maybe I feel "angry" when I see in JS capturing of many vars with many fns,
// and mutating them .. BECAUSE of BREAKAGE of SRP-principle from SOLID ..
// since instead of "Single-Responsible" state-machine like `::state_sharing`,
// I see "spreaded captures of mutable vars by meni closures"  -- like
// `express-session` -- at least I have such impression

@3
//  By E.Meijer:
//      (push)
// callback: Result<Option<T>> -> ()
//      (pull)
// iterator: () -> Result<Option<T>>
//          in Rust it's Option<Result<T>>, but order doesn't matter(it's just linked-list of
//          effects: Result->Option->T, so we can Option->Result->T )
//          [GIST] we just should be  "aware" and "explicit" about side-effs in our programm
//              E.Meijer: "TASTEFUL PICKING OF SIDE-EFFs"
// .. and
// Meijer say: instead of doing PatMatch( he hate PatM and prefer like exmp below [distinct fn])
// on Result<Option<T>>
trait Observable<T> { fn subscribe(Box<Observer<T>); }
trait Observer<T> {
    fn onError<E: Throwable>(E);    // if Err(E)
    fn onCompleted();               // if Ok(None)
    fn onNext(T);                   // if Ok(Some(T))
    // also
    // to protect fast producer against slow consumer
    fn onError<E: Throwable>(E) -> Future<()>;  // we "aware" and "explicit" about side-effs
    fn onCompleted()            -> Future<()>;  // here - "latency"
    fn onNext(T)                -> Future<()>;
}
// so $$: it's actually similar to EventEmitter in NOde (in ES7 "Observer" appear)..
//  ... SO ..  MUST_SEE: ::ee_observer.rs

@4  ??? v-- is this something "true"
// "see: what_does_reactive_mean--time:35:00"
// `next` return Promise
//  fn next(?) -> Future<Result<Option<T>>>
prod.next().then((val) => {
    ...
    return prod.next(val /* or anything */);
})


// SICP:
// The phenomenon of a single computational object being accessed by more than
// one name is known as ALIASING. The joint bank account situation illustrates a very
// simple example of an alias. In Section 3.3 we will see much more complex examples,
// such as “distinct” compound data structures that share parts. Bugs can occur
// in our programs if we forget that a change to an object may also, as a “side effect,”
// change a “different” object because the two “different” objects are actually a single
// object appearing under different aliases. These so-called side-effect bugs are
// so difficult to locate and to analyze that some people have proposed that programming
// languages be designed in such a way as to not allow side effects or aliasing
