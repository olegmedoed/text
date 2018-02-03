///                MOTTO:
///         write only usefull for INVESTIVATION tests (if in doubt leave test out)
///         Test should help INVESTIGATE behavior of programm by reading this test
///             all other tests leave to QA
///         It should be like in Rust Docs-with-example where examples compiled-and-checked
///         BUT with focus more on Examples instead of Docs
///             and leave solving probleme of "absence of bugs" to "simplicity of implementation"
///                             (and "simplicity of purposes" - less edge-cases)
///                 SO
///     Treat TDD-tests like another kind of DOCUMENTATION, but not as a ("nedo") tool to prevent/track
///     bugs (its (prevent): typesystem, simple-code-style(Preact instead of jQuery), code-review
///             & (track) QA-test)
///             ..
///     You pick scripting-lang and try to use inappropriate tools to make code solid ....
///     PICK FUCKING TeoremProver-lang .... and don't be pretender
///     SO
///         .. in JS, just HOPE that you write program in (like)"type-safe" way .... instead
///         of using inappropriate tools (TDD tests) for this.
///             just rely on SIMPLICITY of ORGANIZATION/PATTERN (like preact)
///                 ..
///             Especilly if we take into account that in (exmp) frotend dev... everything
///         bounded to react/redux ... SO... funs usually receive some standatized by framework
///         types (also Feathers ... hooks has concrete type-structure, etc)

## 0    // (30-jul-17)
//
// In tests you should describe/test the things which is crucial for your module/class/etc, which
// is mostly UNCHANGED(that is you don't need usually to change(exactly, i'm not mean refactoring)
// your test)
// It's opposed to how I write in ruby:
for meth in ["save", "fuck", "police"] {
    it("should has method #${meth}", || self.should_respond_to(meth); ) // << Type-system for poors
}
// In such case we loose the power of dynamic language, since like in Rust every refactor/change to
// code often can brake our tests.


# 6.1
|
///  Behavior is the "what" side-eff and fun-ret-val  object-methods produce in particular
///  state.
///     After-year: NO... behavior if our intention for function, which expressed through
///     side-effs and ret-vals
// exmp:
describe("array", || {                      // << object
    context("empty", || {                   // << state ("context" is better than "describe")
        it("lenght should be 0");           // |<< side-eff+fun-ret-vals
        it("pop should raise exception")    // |
    })
})      ^
///     ^---    BTW ... if event do test-before-code ....it's best case TO JUST WRITE INTENTION
///     BEFORE CODE


## 9
// in `test-run` the only things that affect on the test-execution ,. IS .. what the
// test-driver(your test) say you to do. 
/// - there is should be not external(global) factors
/// - order of testS execution should not matter
/// - result of test should be **uniquely** determined by input data what
///     `test-driver`(our test) gives on input to tested fn
/// - should be easily runned in parallel
// 
// exmp: if you need for your test a Date, you need prepare instance of Date and
// pass it as input to your tests(usually in the form of depend.inj), SO .. it will
// be not arbitrary value, BUT controlled by you .. SO .. you can control state of
// test(so can have ability REASON about correctness of your tests).
// 
//!                     *******************
//! DELETED: about tests with "CreditCards", it's ALL ABOUT:
//!     FUCKING "(MUTABLE) ALIASING", OREDER_DEPENDENCY/COUPLING
//!                     *******************
//!
//  v-- about: when you pass all your fun-dependencies explicitly (particularly in CONSTRUCTOR)
///Don't pretend that you have (a little / no) dependencies.
// If you have many dependencies => than there is some reason for it AND .. if it bother you
// than such test make you refink you architecture, and rethink: Why you have so much dependencies.
// (hint: violation SRP(single-resp))


## 10
// AFAIU:   TESTABILITY of program depends of the fact how much fns in the program relies on the
// INPUT/OUTPUT (that is programm written in (mostly) fun-style). If you read ##9 post (inspired
// by Miwko from Angular) you notice that for testability it's good to make dependency injections:
///     ^-- HAVE NO MUT_ALIASING, and even if "fn" mutate someting, if it receive it AS MUTABLE
///     PARAMETER aka "&mut _", IT'S EXPLICIT PASSING OF CAPABILITY TO DO SIDE_EFF(here mutation)
//         (Bll99: ^-- I wrote it even before "IDEPMOTENCE"-FunLight stuff was learnt)
// BUT:
// 1. don't depend on MUT global state. (=> explicitness)
// 2. don't set the properties of objects(that is treat it as a value(in term of Hickey))
///  ^-- (2) absence of implicit and !uncontrolled by tester! "side-effects",
///                                                           configuration-by-mutation
// So .. it let us EASILY PREPARE the input data for test AND .. BE SURE that its execution not
// depends of other factors,  ... SO this let's ensure --v (i copy-past it from ##9)
/// - there is should be not external(global) factors
/// - order of testS execution should not matter
/// - result of test should be **uniquely** determined by input data which `test-driver`(our test)
///     gives on input to tested fn
/// - should be easily runned in parallel


## 18
// About testing meths what receive ACDE.
// If we test the meth, which receive ACDE, as I belive we should test(as ANY fn) in/out rel, and
// (the GIST) side-effs, BUT, if for exmp ..
fn some_meth<T: AbstType>(a: T) -> SomeType { a.do_something() }
// .. how we know whether `do_something` is doing side-eff in some implementation of AbstType or
// not, that is maybe some impl of AbstType do some side-eff, and other doesn't ..(in Hskl we can
// know it)
// WAS {
//      maybe we should use "should_receive", "receive_with().and_return()" for ACDE
// } BECOMEs {
//      1. NAHUI "spies".
//      2. Eventualy, every ACDE passed as arg, return some concrete type as res of one of its
//         meths, SO, just STUB it, and return this type .. IF even.. ACDE::meth return another
//         ACDE (which is rare key), just STUB it.
//         .. and ..
//         in unit-tests we don't care about side-eff except :lol: "EXCEPTIONs"(in Rust it's steel
//         IN/OUT), leave other side-effs to INTEGRATION tests (## 24 .. here test_user_saving is
//         formally unit-test, but actually INTEGRATION (with REAL DBAdapter) test).
// }
///                                 after a year
///  Man, you need understand that implementation behind ACDE may DO, but may NOT DO any side-eff
///  for exmp you accept "abstract renderer" (remember DesPatter "Maze" exmp [AFAIRememb "Builder" 
///  pattern]) ... and "regular/main" implementation render your (exmp) "maze" ... but another
///  implementation just gather statistics ... and send you a report ...
///     ..IT'S TOTALLY DIFFERENT SIDE-EFFECTS
///     ..
///     SO.... eventually in test's it makes sense just write that "function should render
///     someblabla" --> expect(renderer).should_receive("renderblabla")


## 21
// How to peek features for your "agile-cycle"?
// It's determined by context: if you develop game for girls, you should definitely conсentrate 
// FIRST_OFF_ALL on "nice graphic effects" if it's game for nerds you should concentrate on
// "cool AI-engine, logic".
//  In cucumber "context" often is shown by name what your peek for "user" in your feature(p.s 
// which is use your program, and .. any API can be considered as a program, and "user" can even
// be another programs(object, function)[bdd in unit-tests], even if you use your programm throuh
// IO or GUI, the IO/GUI-hanlers serve as API of your program)
//
// also .. about "user"
// It's a little bit stupid ... remember my Rails example ..
// ..
///  Feature: BlaBla_1                Feature: BlaBla_2
///  as user I go to main page        as authenticated user I go to main page
/// 
///  When I go to "/"                 When I go to "/"
///  Then I see "Sign up" page        Then I see my page
// 
// ... BUT ... "user" and "authneticated user" it's just STATE_OF_YOUR_CLIENT_PART_of_PROGRAM
// ..SO ..
/// Given  I'm a user            /    Given I'm authenticated user
// ..
// Question: Nahu9 INVENT{9 potratil huevu tuchu vremeni NA ETI "INVENTED" ponty, vmesto
// togo chtoby pisat' cod} this stupid "roles", whereas it's just STATE of your program ..
//!      BDD is :
//!      Given "programm(generally any API) in some state"
//!      When  "I do so_and_so"
//!      Then  "I have such_and_such side-eff and fun-ret-vals"
// SO..
// .. From this persepective "USER" doesn't matter. WHAT_DIFF who uses your programm(api)?
///             (after year)
///     The point that just for programmer cucumber is definetly overkill (like Ben from Thought
///     Bots has said) .. BUT... the point of cucumber is bring together the proramming thinking
///     aka (state, side-effs) ... and stake-holders thinking
///
// It's behavior the same: (we have some data in some state, we have some actions, as res we have 
// some side-effs+fun-ret-vals) ..
// ..  So, I think, eventally it can matter from "business" persepective, that is, I mean
// "value of your program" for "client-consumer" .... (write something more concrete in the future)
//
// ... it's like OOP try pose like "modelling with RealWorld objects"
// ... like Ruby try tie formal code and natur-langs
// ...      here we try tie state of our program with "roles"
//      ^--- NAHUI TAKOE  -- ETO VSE OTVLEKAUW'YI MUSOR
//              "CODE ALWAYS WINS" -- NAHUI LEVYE SUW'NOSTI


## 24
// TDD doesn't prevents BUGs, don't fool yourself, you are not a TESTER, and only REAL PRODUCTION
// can show all your bugs (after some time) .. spent this time to write actual code, and fix bugs
// NOTE: I'm write TDD-tests, NOT TDD, since the key point, that Dynamic langs, gives you
// flexibility and ability quickly write(prototype) you programm WITHOUT STRICT INTERFACES (which
// can event track side-eff in Hskl and Rust(partially)) .. NOT in "Right" way, BUT in
// "***simple implementation first" way, so when you try meticulously describe all your (behavior)
// side-eff (and types/interfaces), and so on in tests ..
// WE ELIMINATE ADVANTAGES of Dynamic lang, since you "cementiruete" programm "behavior" in tests
// and.. ANY AGILE/FAST change to program-DESIGN (what is PARTICULARLY IMPORTANT on "prototype"
// or "early-designing" phase), MAKE US REWRITE our unit-tests(IF WE HAVE TOO MUCH OF THEM)
// .... also: TDD-test(as opposed to TDD) is not used for "constant/instant feedback"(as KentBack
// suggest), it's about "cheking your KEY-POINTs, the MAIN LOGIC of your app". 
// ..
// So in TDD-tests you should describe only EMPHASIZED  by you side-effs or states(MAIN LOGIC),
// which should serve like "INVARIANTS", what let you be sure that main KEY POINT of your programm
// is correct, AND LOCALIZE A FUTURE BUGs .. since..
/// Dijkstra: "testing can be used to show the presence of bugs, but never to show their absence!"
// So... you write TDD-test to show absance bugs in MAIN behaviour ..
// .. like Dimon said that he not completely agree with TDD-is-DEAD(and E.Meijer), since:
//  "if not tests, I could not be sure that some one when add new feature( or fixes something)
//  not break my code (while I was on leave), but since I have a test, I can run them, and be sure that
//  GENERALLY( KEY-POINTs ) it's all OK".
// .. So..
// ... He appreciate TDD-test because of .. if some one add new feature, or make some changes to
// code it can still be sure that MAIN INVARIANT'S (MAIN LOGIC OF YOUR PROGRAM) doesn't broken,
// and if QA file a bug, it can run test, and if it see that INVARIANTs is not broken , then he
// quickly can skip this cases, and "localize" the search.
// ..
// ... SO.. we write TDD-test to make sure that key points of our funcs JUST WORK, like I do it
// with fns in REPL.
///     ^-- FUCK: in the way they help you LOCALIZE BUGs.
// ... and since Rust haven't REPL - it's the only way to do such testing in
// Rust - write TDD-tests, just make sure that our fn works in the way we expected ..
// NOT it has not bugs. ...
///                 P.S (after year [autumn-2017])
///     Actually it's pretty good integr/unit (INVESTIGATION )test ... which capture MAIN behavior
///     since I don't read the func (suppose it's not well-known function from Rails controller)
///
// ... BUT the case like
fn test_user_is_saved() {
    let db = Spy::new().with_method("save");
    let user = User::new("Oleg", 26);
    db.should_receive("save").with(String::from("INSERT INTO User VALUES ('Oleg', 26)"))
    user.save(&db);
}
impl User {
    fn save(db: &DBConnection) {
        let query_builder = QBuilder::new();
        let sql_query = query_builder.insert(&self).into("user");
        db.save(sql_query);
    }
}
//                  `````
// ... Gives us NOTHING .. since I DON'T EVEN TRY TO TEST IT IN REPL .. IT'S OBVIOUS THAT I CALL
// "SAVE" .. the only thing to test it .. is result of Builder .. BUT it's tests for Builder ..
///     ^--  BUT WHAT IF SOME ONE "break"  Builder .. you in BIG-ORGANIZATION with ~55-devs??
//                 `````( ^--- after year --- nononono)
// not that fn.  ... HERE IS NOTHING TO TEST. .. What gives me the running of this test, just know
// that i call save on "db_connection" ?? It's ease to glance at this fn.
// .. SO .. (definetly)maybe it's make sense
/// TO MAKE INTEGRATION TESTs for mainteining MAIN KEY INVARIANTs (MAIN LOGIC)
///             (p.s.(after year) but test above exactly such "good" integration test
///             ESPCIALLY thanks for comparing with END-RESULT-SQL-STRING
///             SO...  basically it's more Builder test instead of User test)
//      (even if them doesn't "prevent" a bug ... if price of 1-bug is 1000-tests -- IT'S TOO MUCH
//       production show .. and our TESTS SHOULD HELP US !! FIND_AND_FIX_THIS_BUG !!)
// of our programm
fn test_user_saving() {  // <-- although this test can still be considered as Unit-test
    DBAdapter::create_dababase("some ip");
    let db = DBAdapter::create_connection("some ip");
    let user = User::new("Oleg", 26);
    user.save(&db);
    let user = User::find(&db, "name", "Oleg");
    assert!(user.age() === 26);
}
/// ^-- BUT AGAIN: it's just "PUSH-fn", we just wanna be sure that it do its job ..
///         .. PUSH SQL-query
//
//      db         |
//                  > [map: user_data -> sql] --push> (db, sql) | [db::save]
//      user_data  |
//
// .. and do it with real DB .. so .. we have REAL INVARIANT for maintaining our INTENDED and MAIN
// LOGIC OF PROGRAM (instead of toy SPY, which just tell as obivous thing [that we call
// "save" on "db"])  .. that is here me REALLY EMPHASIZE ONE OF KEY intention that we supposed
// for our programm ..
///   BTW: we doesn't "HARDCODE" how our "user" "popal" to database.
// ..
// ... So, maybe it's makes sense to use SOMETIMES STUBs when call external "service" is too
// EXPENSIVE/complicated-in-configuration, and it's make sense just stub it (aka pragmatism) when
// we test as exmp "in/out" ..
// .. BUT.. it doesn't make sense to USE SPIES  (again: example above show it)
//

## 25 (autumn-2016)
// ALSO: when you see how open-source projs on Github covered by test fully, and on every new
// feature you need write a test( particularly in JS )..
///  ..THAT BECAUSE IN OPEN-SOURCE WE HAVE NO `QA`, programmers responsible for QA.
//
///   ## autumn-2017
//
// I think wheather it's more easy to read tests of code instead of code itself .... conclude..
// usually not, better it's types +  WELL WRITTEN CODE ( LOCALITY + SRP + etc )
// ...
//  ... but why also it's hard to read tests of OSS projects(packages) (which I investigate)
//  is BECAUSE OF test there is NOT TDD test ...
//      .. . it's mix of QA tests + TDD tests ....
//      ..
//      TDD test sholud not just test your function (you programmer, NOT QA) .. but express
//      your main intention (NOT every possible edge case)
//          ..
//              ... and tada ... SUCK TESTs   .. MAYBE ... we can use as (addtion) means of
//          investigation
//          ..
//          Especialy in cases when you see some (some degree complex) fuction .... and instead
//          go throug all (nonsence,small steps) code  ...
///          .. you wanna just see (general piceture :lol:) side effects what this function produce.
///         in company with "purposes"(exxp: it("PURPOSES HERE", () => {Sideeffs here}))
//              note: here "mocks" can be poor choice and INTEGRATION tests is COOL ...
///             BUT
///         because test in OSS mix TDD + QA .... it's just became "crappy reading"
//          ..
//          like DHH said: don't NECESSARY seek for "fast" Unit tests .... just write INTEGRATION test if
//          it's more expresive.

## 26 (nov-2017)
//
// About inject dependency (DI) everywhere to make code more testable, encourage modularity....
// .. and the fact that such becomes "boring" to use (PARTICULARLY: create objects)... and
// some guys claims so in such way TDD damage soft, and make it less natural ...
// ..
// .. SO: imagine that you don't let "overusing-DI" everywhere just to have ability
//  "mock-for-testing" something , and "hardcode" some parts, since it's more convenient to use,
//  and don't need extensibility on practice ....
// ...
//  .. BUT: we can do better: so write everything with DI (extensibility-n-testing) and over this
//  code write some thin facede which catch most frequent use "hardcoded" use cases
//
