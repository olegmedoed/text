@1
// R.Gabrial:
// | With the-right-thing, designers are equally concerned with simplicity, correctness, 
// | consistency, and completeness. With worse-is-better, designers are almost exclusively
// | concerned with implementation simplicity and performance, and will work on correctness, 
// | consistency, and completeness only enough to get the job done, sacrificing any of these
// | other qualities for ***simplicity.
//              (btw: preact is example of simplicity of implementation, with simplicity
//              of API / PATTERN (see Sebastian Markbage talk of small API surface))
// | Programs designed and implemented using worse-is-better can be written more quickly than
// | the-right-thing versions, will run on a wider range of computers, will be easily portable,
// | will be accepted more quickly if good enough, will be eventually improved (to satisfy 90% of
// | user requirements).
// ..
@2
// ***simplicity:   
//  -1 maybe it's similar to YAGNI (btw, YAGNI is similar to USE-CASE oriented interfaces - not
//  our "vision"(dog is animal so I "should" make: "class Doc <: Animal") dictate the
//  interface/feature-code for your type/programm  -- Also "your vision" and END-USER needs
//  may differ, so you need be oriented on END-USER to be "succesful" if it's a commmerial
//  project - as res YAGNI)
// !-2 maybe it just means to obey 80/20 rule .. and tend to write soft in such way, that it
//  will oriented to implement just 80% of our purposes -- THE SIMPLEST 80%. -- THROW AWAY the
//  parts of your softwar-design that makes implementation is hard and more complex, that
//  is( features(reflected in API), which implementation makes you stagnate[ makes implementation
//  more complicated] .. despite to ignoring their "necessity" in your API makes
//  it(API) inconsistent)..
//  ..
//  also - less code - less bugs .... the simple implementation can be easier to understand, even
//  if API not so nice, and programm is not so "fearture-reach"
//      (candidate: SimpleTestFramework(Mocha?) vs Rspec)
//
@3
//  Althogh( as R.Gabrial) said "NewJersey" style "respect" "consistency" .. and try make API
//  consistent as possible to don't break 80/20 rule - "Simplicity" is more important
//  than "Consistency" ..
//  .. SO.. summury:
//! MIT: simplicity and consistency of interface(API) is more important than simplicity of
//!      implementation
//! NJ: simplicity and consistency of API is important, but if as result we have "complex"
//!     implementation part , we can "reduce" API simplicity and/or consistency to make
//!     implementation ***simpler
//!             ...
//! SO..: on practice choose this trade-off-line - how much sacrifice the API
//! simplicity-n-correcntess to make implementation ***simpler  .. we can almost not sacrify .. as
//! result implementation MAY be more complex (in BEST CASE the API and the impl both simple and
//! API is consistent) and we break sanity of 80/20 rule, since we spent to much time to implement
//! implementation-part that necessary for "simple-n-consistent" API
//  ..
@4
//  W-is-B:  NJ style about "Consistency":
// |Consistency -- the design must not be overly inconsistent. Consistency can be sacrificed for
// |simplicity in some cases, BUT IT IS BETTER !TO DROP! THOSE PARTS OF THE DESIGN THAT DEAL WITH
// |LESS COMMON CIRCUMSTANCES THAN TO INTRODUCE EITHER IMPLEMENTATIONAL COMPLEXITY OR INCONSISTENCY.
//
//  Linux takes ***simplicity over "consistency" of Minix. It's PRAGMATIZM .. from "correctness and
//  consistency" PoV Minix is better,  but Linus WAS FOCUSED TO GET THINGS DONE .. so he was
//  focused on implementation, which should be "***simple" to get things done ..
//  .. AND.. it "drive" the design( including API design - see story about "loser-mode" on PC)
//  of OS.
//
@5
// Also: http://martinfowler.com/bliki/MonolithFirst.html
// ..
// It is exmp of "***simplicity-IS-PRIORITIZED"( aka R.Gabrial: "NJ-style put `***simplicity` at
// first place")  ... SO.. monolit is more ***simle to start then "microservices", althoug
// design for "microservices" from start lead us to think how to make our project more "modular"
// i "scalable" .. and as result it's API is more "right", reasonbale -> consistent - BY-DESIGN,
// since we do it right "from start" .. BUT with monolit "from start", when we will move to
// "microservices" - when we "refactor" our API .. it CANNOT be as "NICE" as in case when we
// put in the basis of DESIGN .. INITIALLY  -- that's why Redox don't follow POSIX
// ..
// also my favor.variant of "start" from blog-post: 
// |A more common approach is to start with a monolith and gradually peel off microservices at
// |the edges. Such an approach can leave a substantial monolith at the heart of the
// |microservices architecture, but with most new development occurring in the microservices
// |while the monolith is relatively quiescent.
//
@6
// Also: Go-lang is exmp of W-is-B .. R.Pike makes "more poor" lang (incomplete, inconsistent), for
// a matters of simplicity ( simpl lang, convenient concurency, fast compilation)
//  .. BUT .. I think it's where  `trade-off-line` was moved too much to  ***simplicity side.
//
@7
//  Also: In Rust compiler I often see something like this:
//  ..
        // a HACK to get around privacy restrictions; implemented by `std::thread`
        pub trait NewThread {
            fn new(name: Option<String>) -> Self;
        }
// or
        // FIXME: this is clearly a hack, and should be cleaned up.
        let key1 = imp::create(self.dtor);
        let key = if key1 != 0 { key1 } else {
            let key2 = imp::create(self.dtor);
            imp::destroy(key1);
            key2
        };
// .. So it's example when author makes a HACK, and makes API (sometimes) INCONSISTENT (like in
// the case of NewThread) .... TO GET WORK DONE

//!   ====  HROM NOW I WILL SPEAK ABOUT "THE HACKER WAY"(HW) with W-is-B  ====

@8
// https://gist.github.com/dhh/4849a20d2ba89b34b201    Decoupling-from-Rails
//
// It's where J.Weirich trying todo "right design" -- and dont respect W-is-B ..
// Look at DHH exmp ... IT'S SIMPLE !IMPLEMENTATION! FIRST
//
// also: It's maybe confirm that Rails is also the case of W-B, and also it's REMIND my point that
// W-B***simplicity(@2) is about YAGNI ..and YAGNI is SIMILAR to "use-case oriented interfaces"..
// .. SO.. is USE-CASE ORIENTED FRAMEWORK .. AND IT'S ***SIMPLE FOR THIS CASE ...
// ... DONT TRY TO BE "RIGHT" (on 100%, only 80%) .. KISS and GET THINGs DONE
@9
// In "TDD is Dead?" .. DHH talk "kak ego zaebali eti vse ponty s Unit-testami, mocki-hueki"
//
// K.Back (when it's invented TDD for himself(before it's become mainstream)):
//  "even if don't know how to implement something, I at least can write tests for it"
//  ..
//  That where W-B and HW is suited .. since it's focused ON IMPLEMENTATION .. IN THE SIMPLEST
//  WAY .. ON "GET THINGS DONE (and bring the value)" since only WORKING CODE can TELL US
//  whether it's SUITED for us ..
//  .. if NO, throw away, and write in another way (while TDD write he's TESTs)
//      CODE IS ALWAYS WIN.
//
// LET MAKE TESTs TO QA
//
// Fuck, just think about it: in Unit-test in Rails when I test model, I wrote often..
[foo, bar, fuck].each { |m| obj.should has_method m }
//          (^--- Type-system for poors)
// ..
// ... FUKC, why we need such stupid tests .. IT'S OBVIOUS FROM THE DOC .. HW is when your
// thinking is not clogged with "reweni9mi po instrukcii" (McDonalds vs Restourant)

@10
// Also: from PoV W-B .. Actor&Scene in "right"-Rust way bring more COMPLEXITY in implementation
// since to `Scene::moveTo`/`Scene::draw`, we need pass our Actor to meth, and this meth should go
// through a list of all "positions", and find our actor "position", and after that actually do
// some work  .... SO.. again W-B -- IS TRADEOFF .. where we can make design "less right", but make
// implementation more "***simple"  (like in "origin"-book Actor&Scene showcase)
//! ...  THERE IS NO "STRICT" RULE .. IT'S TRADEOFF

@11
// about HW - is about "bring the valuw", W-B - "get things done".
// ..
//! ...   THAT's THE NATURE of "CREATIVITY" (create value)
// ..
// ... "CREATIVE" man is a hacker,  HACKER is a man who know WHEN-n-HOW_MUCH( it's TRADEOFF)
// it makes sense to break the rules ("RIGHT" design) , and make HACK for ***simple
// implementation ..
// .. AND.. achive this 80/20 rule ... AND (bring) "CREATE" the value.

@12
// from: http://www.laputan.org/mud/
// ..
// ... "BIG_BALL_OF_MUD is a casually, even haphazardly, structured system.
//      Its organization is !! DICTATED MORE BY EXPEDIENCY THAN DESIGN !!"
//  ..
//  ... EXPENDENCY - WORSE .. DESIGN - RIGHT ... WORSE should be VERY "TOCHECHNO", the GIST of
//  "to_be_hacker" is be able to decide WHEN we can RESORT to WORSE to make thinks MORE SIMPLE, BUT
//  also NOT INCOSISTENT_!TOO_MUCH!..which liead to BIG_BALL_OF_MUD

@13
// createror of LinkedIn - Reid Hoffman:
//  "If you aren’t embarrassed by the first version of your product, you shipped too late"

@14
// Also: conversation between Linus and MrSomeone from "mailing_list":
// Mr propose to add some "improvent/new_feature"(here UIO) and Linus said that it's
// shit, and when Mr give some arguments why it's actually cool-n-right  ... Linus said that
// he isn't convinced  .. and ask to show SOME REAL PEOPLE WHO MET the situaion where they
// REALLY NEED IT  ...  
// ... SO .. [GIST] .. even if you can even show that you "improvement/refactoring" make things
// better .. Linus don't consider it's as good if there is NO REAL CASE WHEN SOME REALLY NEED
// IT ... of course if this feature not considered by Linus as necessary  ... BUT again
// AFAIU his PRagmcatic-Driven developer and oriented on REAL NEEDs .. and more over (BTW) he
// is "visionary" that is he set the SET OF PRIORITIES and DECISIONs for the project .. regardless
// if they considered genereally-good or not  ..  like "golang" creators said that if you
// not agree with they "vision" - you need forget about "golang" and use another language .. since
// you just need different language
// ..
// ...So back to the [GIST] : REAL-PEOPLE-NEEDs it's good "sanity-check" .. and I often see
// when some "lead" devs of some-opensource project ask "whether you have real use case for your
// feature . WHAT DRIVE YOU to add this feature, except `it makes improvement`"

@15 (19-oct-2017)
// Simplicity of implementation (btw: api-surface/intentions impportant too) is result of
// simplicity purposes/intentions for this soft .... and if something break 20/80 principle
// (see: Cheng Lou talk) we can try eliminate this "feature" from *this* soft and extract
// it to another layer .... like for example:
//  ... don't bother yourself with database-fault-tollerance in node.js ... and just let it
//  fail, and make docker restart you node-app
