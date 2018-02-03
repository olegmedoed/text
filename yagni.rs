// YOU GOAL ELIMINATE SOFTWARE :lol:
//
// Don't try solve everything with software/technology ... but try solve as least as it possible

## 0 // (migrated from rest_api__bdd##32)
//
///  about: https://signalvnoise.com/archives2/it_just_doesnt_matter.php
// 
// and after that read comment of **Nathan Rutman**
//
// So I had remembered about "X system live for decades because of it's incredible flexibility,
// since philosophy: `Instrument not politics`"
//  ... BUT ....
// Doesn't easier to build more simple and opinionated (and appropriate) software which serve
// (exmp) 5-10 years (LESS feautres, and abilities to add-features/configure), and after time, if
// it doesn't fit, just build NEW software which is MORE APPROPRIATE to new conditions instead
// just try "perelepit" old software ....
// ... someone can say .. but this new software will be not tested/proven/buggy-at-first-time
// BUT ... the gist is SIMPLICITY (not only interface/features but IMPLEMENTATION also) ... soft
// should be simple in implementation and not necessary super-flexible, but of course WITH THE GAP
// TO EXTENSION in SOME degree.
//
// GENERALLY the rule: if agility-in--(interface/features) makes implementation significantly
// complex, it's better eliminate this extesnibility/agility---for---features/extensions

## 1
// Fucking pluralizations of names in ORM, and most of all - RIGHT pluralization for exceptions.
//
// Fuck that.... Just name models in pluralized way .. problem solved (without any code) ... 
//  ... maybe we can add `toLowerCase` when translate model name to table name ... that NOT TO
//  DIFFICULT (in sense of implementation)
//  ... everything is fucking consistent, no exceptions,
//              YOU TAKE WHAT YOU GIVE, and nothing more...
/// p.s
//      I will see we can pass pluralized and singular variant in options, SO... like no code, just
//      pass fucking pluralized variant, but if you don't want we have good default for you.
//      BUT .... FUCK THAT convinions ... BEST CODE IS ABSENT CODE.
//
// ..
// p.s
// Also: why they do so complicated getters/setters system, FUCK THAT ... do just simple NATIVE
// ES6 getter/setters it's engough .... even if it has some "convenients", I don't wanna know all
// internal hacks to take full advantage of this over-bloated system.

## 2
/// Postgresql: timestamp with/without time zone
// Just save time as fucking i64(in milisec, it's enough for thousand years, or 400 years in
// nanosec)
//  ... NO FUCKING TIMEZONES ... it's task of CLIENT ... not database. Database just store time in
//  UTC ... and client can show/manipalute it IN ANY timezone it want
//  BUT.... Postgres allegedly do it...
//  BUT ... the tricks IDEALLY they should just use ONE FUCKING TYPE -- timestamp with time zone 
//  ... NO AMBIGUITY.
//  IDEALLY ... NOT MENTION TIMEZONE AT ALL ... just client convert time to UTC.

## 3
// AGAIN: about moving complexity from one layer to another if it can be solved better there.
// Exmp:
//  Unix-way: C + Shell .. move some complexity from C program to `scripting` level.
//  H.Valim: "when you make simple actors/objects complexity moves to relations between them" ...
//      .. SO ... is it's easy to deal with "complexity" in form of relations, then in the form of
//      "object inner complexity" ... then you CATCH THE GIST of this post/PHILOSOPHY.
//  (Inspire this post, but not necessary best exmp) AWS S3 access menegement "best-practice"
//  described in og-aws -- instead of manage access permissions for different objects ... JUST
//  create diff buckets for them and set for every bucket appropriate permission. So in such way
//  delegate complexity on the level of app which will interact with many buckets.
//


NA-PODUMAT:
- Если для реализации новой функциональности, не предусмотренной в абстракции, приходится переписывать пол-проекта, то во время переписывания смело удаляйте такую абстракцию.
- Если абстракция существенно усложняет отладку кода, то быстрее выпиливайте ее из проекта.
