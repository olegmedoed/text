@0
// In JS(due to a nature of lang) -- YOUR FN-INTERFACE CAN BE "LEAN" .. BUT .. NOT "A MESS"
// so, you EXPLICITLY determine the how lean your interface by point it out in
// docs, for exm ...
//  @param { Boolean | String } arg1
//  @param { Number } arg2
// .. So, here --^ you explicitly point out that `arg1` can be `bool|str`, SO,
// it's YOUR responsibility to cope this them, ALSO you POTENTIALLY should cope with rearranging
// of a args(if your are supposed varargs, IF YOU DON'T REQUIRE all args to be present) ..
// .. BUT .. in all other cases(NOT MENTIONED BY YOU in DOCs) it's TypeError 
//
// also: You can "relax" your interface if your need, BUT if you make very
// "raspizd9iskii" interface, and your "package" becomes populer, it's almost
// impossible to make it's more "strict and consistent"
// SO: start from more "strict and CONSISTENT", and mitigate it a little bit in
// process if your SEE IT'S NECESSARY


@1
// exmp of stupid style from `Mocha`
Runnable.prototype.currentRetry = function(n) {
  if (!arguments.length) return this._currentRetry;
  this._currentRetry = n;
};
// instead, it should be:
Runnable.prototype.getCurrentRetry = function () { return this._currentRetry; }
Runnable.prototype.setCurrentRetry = function (n) { this._currentRetry = n; }
// or even better, MAYBe, it should not be private var with getter and setter
//
// maybe if it's common pattern (to use one func instead of two) and all get
// used to it, MAYBE it' worth to accept this shit-pattern
//
// BUT generally, func in dyn-typed langs should return value of one type, or
// valus that have identical interface(duck-type)
//
// p.s (after month) , JS never be safe lang, it's dynamic scripting lang, so
this.currentRetry // currentRetry is public getter/setter, instead of func
// NE LEPI IS GOVNA PULU, dont' apply stat.lang.approach to JS
// 
// And yeah, fuck.value() ; fuck.value(x), is just (MAYBE) more ergonomic then 
// fuck.get_value() ; fuck.set_value(x) , that's JS baby.

@3
function prepareWrite(outFolder, file, opt, cb) {
    const opts = Object.assign({
        ........
        dirMode: null,
// original stupid code: `overwrite` at that time may be either func - that test some
// param(and supposed to return bool) or boolean, SO, NAHU9 make logic more
// complicated, and meaningless(in typed langs it impossible do that shit) by checking
// whether it's checker-func or bool, JUST put stub function(V8 can inline it, I believe)
//      overwrite: true
        overwrite: function () { return true },
    }, opt);
    const overwrite = typeof opts.overwrite === 'function'
        ? opt.overwrite(file)
        : false;
// or: const overwrite = booleanOrFunc(opts.overwrite, file);
     opts.flag = overwrite ? 'w' : 'wx';

     .......
}
// !BUT! user of this func will be unwilling to pass stub-function instead of
// just `true` or `false`, that fact cause the presence such ugly code like here
function booleanOrFunc(v, file) {
  if (typeof v !== 'boolean' && typeof v !== 'function')
      return null;
  return typeof v === 'boolean' ? v : v(file);
}
// So, user prefer
prepareWrite(bla, bla, {overwrite: true}, bla);
// instead of
prepareWrite(bla, bla, {overwrite: function () { return true }}, bla);
// and only when he(she) actually need to pass function, it pass the func
//
// Vobw'em:     I LOVE RUST,HSKL, since they don't let to write shit-code
//                  to give a user some sugar(that breaks semantic of data)


@4
// p.s( esli 9 zabudu: to tut delo v tom chto getter 'secure' NE NUZHEN, s `defineGetter` vse ok)
function defineGetger(obj, name, getter) {
    Object.defineProperty(obj, name, { configurable: true, enumerable: true, get: getter, });
}
// Short-hand for: req.protocol == 'https' @return {Boolean}
defineGetter(req, 'secure', () => this.protocol === 'https');
//
// ebanyi po golove , eto(--^) nihu9 ne abstrakci9, suka, eto tupoe nagromozhdenie
// `liwnih abstrakci` kotorye nahui ne nuzhny(BAKLAVA CODE). Chto mozhet byt' prow'e chem
// bl9t' this.protocol === 'https', kuda tut bl9t' uprow'at, chto mozhet byt' pon9tnee?,
// Chem `secure` bolee vyrazitel'no chem `protocol === 'https'`
// Na tri bukvy koroche? Nahui takoe, chitai main.jl@-4
// Bolee togo s moim skladom uma `secure` eto slozhnee. Chto bl9t' znachit
// `secure`, 9 ne fanat pozicii YehudyKatza, chto pro to chto im udalos' udachno
// abstragirovat's9 ot mnogogo, i chto nachinauw'emu ne interesno chto pod
// kapotom, emu interesno rewat' zadachi temi instrumentami chto dali.
// Men9 by parilo chto takoe `secure`, mozhet eto ne tol'ko `protocol === https 
// 
// Po powodu podhoda PaulaGrahema: hu9r' eDSL, piwy imi vsu programmu, to eto
// kruto, no druga9 storona medali, chto kogda ludi men9uts9, im nada ponimat'
// tvoi abstrakcii, i v krupnom proekte polubom mozhet byt' chto tvo9 abstrakci9
// budet `leak abstraction`(ona horowa9, no ne vsegda delaet to wo nado na
// zaebis'), i v nei nado razobrat's9, i obw'e mne trudno mental'no pisat' bylo
// na Rails nemnogo izza togo wo 9 ne ponimal etu vsu magiu(kak govoril
// Feitman: esli 9 ne mogu eto sconstruirovat' sam, 9 ne ponimau etogo)
|
@5
// pravilo:
// @ ty dolzhen delat' tak chto by i vse bylo abstragirovanno, kod byl gibkiy(mozhno dobavl9t'
// @ novuu funcional'nost'), eDSLy TAM GDE ETO REAL'NO UDOBNO ...  NO.., vsegda starais9
// @ eto sdelat' tak wob kolichestvo sloev abstrakcii bylo by minimal'no
//  (luche prost horowa9 abstrakci9 s 3 levelami  chem  ochen' kruta9(udobna9, usabl'na9) s 10)
//      p.s. maybe it's about "Simple is not easy"
//
// p.s. About exmps above, and about lessong from through.bot
// v-- it's shit
def find_user_friends(id)  // SUKA, the same words!!
    User.find(id).friends  // ^-- Although: here we should find COMPROMISE betwenn BAKLAVA-code
end                        //  and "eliminate coupling (to framework)"(DestAllSoft)
// also traits should have not too many methods, and method should have not too many arguments
//
// p.s. !!!!!!!!
// 9 peresmotrel cennost' helperov, kotorye ochiw'aut logiku tvoei fn (osobenno v beztipovm JS),
// NO!!!
// suka opredelenno primery potipu `find_user_friends` ili `isNull = o => o === null`
// PORT9T PIZDEC KAK REPUTACYU TAKIH HELPEROV.
// v-- exmp: (node.js: "ws"::Receiver::processPacket)
Receiver.prototype.processPacket = function (data) { 
    if (needless_rsv_bits_is_not_empty(this, data)) return;
    ...
}        // Also:
// v Ruby pri OOP golov-mozga 9 by parils9 komu etot meth dolzhen prinadlezhat' (data-type or
// Receiver), no pricol chto eta fn ne predstavl9et nekii abstractnyi interface, potomu
// nikomu(a v Ruby byl by prosto privatnyi method Receivera chisto dl9 udobstva),
// vobw'em eto bl9 prosto helper.
|
@5.5
// about problem of BAKLAVA-code;
// (+)  on one hand such `like` stupid helpers, may be sometimes(this times SHOULD
// be carefully thought-out) usefull, since this stupid FOR NOW helper is stupid
// on ONLY FOR NOW, and gives us abylity to extend the robustness of our
// "cheking/what-ever" in the future painlessly(with only changing the helper)
//          (exmp:  `secure` instead of `this.method == 'https'
//                                                  -- `in few posts abow)
//  also ... CONGRATs your claim coincide with `DestroyAllSoftware:21`, BUT one
//  moment additionally,  AS I SAID, helpers gives you ability extend the
//  robustness of your helpers painlessly(autor of DestAllSoft call it's
//  eliminate `coupling` since from his exmp,
def recent
    @orders = Order.where("data > ?", 1.weak.ago) // << in OrdersController.
end //  WE coupled to `where` method(AND SINCE -- COUPLED TO THE FRAMEWORK, and it's hard to
//   migrate to NEW frameW version, since this COUPLING will be spread around all your app),
//   to "data > ?" constant, to args order, etc.   ... and also autor advised to
//   write such `helpers` IMMEDIATELY instead of find-and-exract all this "helper-code" to
//   `helpers` in the future, since it will be spread around all your app.
//
// (-)  the accamulation(nagromozhdenie) of such `helpers` lead us to what we called
//      !!BAKLAVA CODE!! .. so, be carefull, follow the rule:
//! `good abstr with small number of layers is better than "ideal"(super-ergonomic and cool)
//!  abstr with many layers`


@8
// from WebSocket(my refactoring, interesting comments)
function _send_binary_data(self, bufs, cb) {
    // I do no arg-checks since it's private helper(which you should know how use correctly)
    // in pub-fn it makes sense to raise error if bufs is absent, and maybe wrap bufs = [bufs] 
    // if user pass one buf for convinience(it's hard to take advantages of typesafety and
    // consistency[single el in list is not much diff as 2..., so why 2 types(Array, el-type)],
    // SO, it's better to try take advantages of ergonomy(BUT generally first two is more
    // important))    p.s  see Blob constructor !!! Autor use my style (wrap all in array)
    try {
        bufs.forEach(buf => self._socket.write(buf, 'binary', cb)) }
    catch (err) {
        if (typeof cb === 'function') cb(e);
        else  self.emit('error', err);
    }
}



@10
// `through2` - it's exmp of fn that never fail !!!
// realy, it has no matter what args you pass to it, it as minimum create `default object`
// I'm devotee of the "fail fast" aproach(AFAIK: Rust community too), but, in some cases like here, 
// maybe it's better to do such `bezproigrawnyi variant` !espesially! taking into account that
// Node instance crash if we don't handle the error in curr-ev-loop(because of asynchronity),
//  {
//      LOL: For now Promises fix it, BUT .. now people complain that NODE PROCESS DOESN'T CRASH
//  }
// SO, in such case
// if `through2` failed fast we have opportunity to crash node if we don't wrap `through2`
// in `try-catch` and ocassionaly mix-up params,, BUT it's too boring to wrap every fn that
// can `raise` exception in `try-catch`.(Rustation very much doubted about it[lol], since PatM
// every Result/Option case it's ok for us)
// So, this strategy(***) may be usefull in `async environment` case
// (***) - I don't think it's correct to call it `fail slow`, because we don't fails at all on
// one hand, but on the other hand if we pass non-sense(except if it will be `wrong` fns) to `t2`
// and it return default-value to us, then DEFINITELY HERE NOT ALL SEMANTECALLY CORRECT .. 
// (however, if we aware(it's EXPLICIT for all users of fn) that this fn always return at least
// `def-value` then it's pretty valid to think of their result as valid nevertheless if we pass
// correct result or no)
// BUT,
// after that I implement `map` for `through2`-ed Transform, and has noticed
// that cheking don't handle whether `fn` passed to map is fn, SO eventually this map will fail,
// SO it's better to raise TypeError by hand, and "Nahui fail slow, URA fail fast"
// (p.s. because if it will be by hand, it will have right KIND(sem meaning) for us, SEE:main.rs:15)
//
// SUMMARY:
// I think aproach of `through2` package is bad.  exmp:
function some_fn(o) {
    ..
    tran = another_fn(..); ...
    const t = through2(o,tran); ..
}
some_fn(...);
// So, as a result, if `some_fn` don't check the correctness of `o and tran`, and
// pass it to `through2` and receive deffault-`t` back, it will be a logical failure, BUT
// it will not be obvious for us at all, it's a hard-to-find bug.(we expected to
// see correct T2 instance(or if something wrong, we should know that something wrong),
// BUT instead [with t2 approach] we receive stub-transform what do absolutly not what we expect,
// (here nothing, instead of transform stuff))
// What about node-crash(because of async-ty)?
// I THINK (WILL SEE IT IN PRACTICE) THAT IF YOU TEST YOR APP, YOU FIND THAT BUG
// PRETTY FAST, AND IT UNLIKELY TO CAME IN PRODUCTION

@11
// from Mocha:Runner#runtTest
    runTest(fn) {
            ...
        if (this.asyncOnly) test.asyncOnly = true;
        if (this.allowUncaught) {
            test.allowUncaught = true;
            test.run(fn);
            ....
    }
// and in Runnable#run
    run(fn) {
        ...
        if (this.allowUncaught) ...
            ...
            if (this.asyncOnly) ...
        ..
    } 
// It's stupid approach, in THIS-case(I'm not sure it's universally correct, but in this case..)
// work principle "Explicity better than implicit", So, better is
    runTest(fn) {
        if (this.asyncOnly) var asyncOnly = true;
        if (this.allowUncaught) {
            var allowUncaught = true;
            test.run(fn, asyncOnly, allowUncaught);
            ....
    run(fn, asyncOnly, allowUncaught) {
        if (allowUncaught) ..
            ..
            if (asyncOnly) ..
    }
// Because when you read the code in first time(and don't know all it organization), using such 
// parameters in `this` very confusing, since you don't know where this params comes in
// (in `constructor` they don't be setted, in other fns of `Runnable` also, AND .. as it turns out
// they setted in `Runner` !!!, WTF??, that is confusing, it's like we try to immitate CmLisp-like
// dyn-scopyng)
//
// P.S.     --== IT'S ALSO BAD FOR TESTING ==--
// .. AND ..
// It becomes to be not part of Runner state, that is good,  ideal is the Rust
// style, and we can't mix all in single heap of garbage


@13
this.suite  = new Mocha.Suite('', new Mocha.Context());
this.ui     = opts.ui;
// ^-- setting of `ui` should go only after `suite`, because it's add
// event on suite 'pre-require'. ...  SO,  ... what is interesting, IS,
// whether it's OK to have such order dependency, OR  we can do better (in
// func-style we not depends on order, so whether it has relation to this case?)
// p.s.(04-aug-16)
// It's seems that Miwko advice about "ONLY assign in constructor, THAT ALL" can
// solve this problem



//              (from article about handling Node errors)
@16
// About strictness in typesafety problem in JS
// """
// Besides, you can always make the fn less strict in future versions if you decide that's a
// good idea, but if you discover that your attempt to guess what people meant leads to really
// nasty bugs, you CAN'T fix it without breaking compatibility.
// """
// So .. be more strict instead of stupid "flexibility" when you fn can accept
// and coerce in so many ways that programmer can pass args in wrong way and
// it's will be VERY HARD TO FIND THE BUG SINCE IT'S SO MANY WAYS "HOW FN CAN
// ACCEPT PARAMS"
// So .. if a value cannot possibly be valid (e.g., undefined for a required string, or a string
// that's supposed to be an IP address but obviously isn't), you should document that it isn't
// allowed and throw an error immediately if you see it. !!AS LONG AS YOU DOCUMENT IT!! (in JS !
// .. in Rust it's described in types, [in case of IP it's not a string but somewhat similar to
// IP(String)])
// 
// "" If you pass a lower­level error to your caller, consider wrapping it instead ""
// That what I'm write earlier about.(see Rust@15)

@17
// SUKA, STUPID PATTERN
function fuck(..., cb) {
    if (typeof cb === "function") .. async;
    if (cb === undefined) .. sync;
    throw new TypeError(...); // << otherwise
}
// BECAUSE .. if you call fn, and pass `cb` to do async oper, or don't pass `cb` to do sync 
// .. YOU DO IT -- DELIBERATELI !!! , .. SO .. why do it :
// 1 implicitly (you all the way do DELIBERATE decision), 
// 2. you have overcomplicated by checkings fn, instead you have
function fuckSync(....) { ... sync }
function fuck(..., cb) {                        // So, .. less checks
    if (typeof cb === "function") ... async;
    else throw new TypeError(...)...;
}

@19
// from Node doc(stream:readable.unpipe):
// "If the destination is specified, but no pipe is set up for it, then the method does nothing."
// .. SUKA .. that approach "fail-slow" is HUIN9, maybe I have a little experience with Node(and 
// not so big in general), and not gain the most effective style of programming in Node
// (specifically),  BUT .. you have some arg in fn, you accidentally pass it to `unpipe` without
// checking whether it has correct type, and you have semantic error in your programm,
// YOU PROGRARM JUST DO NOTHING, instead of UNPIPE "writable" pipe from your "readable" pipe, 
// and you doesn't know about it.

@22
// Good pattern from `raw-body`
// To guaranty that `cb` called `LIKE` async. Why Like? Since for us important to
// NOT RELEASE a ZALGO(make async/not_async mess), so if `cb` called after all code,
// it's may be treated like `async` ... I dunno, BUT, MAYBE it also may improve performance
function bla(cb) {
    var sync = true;    // << -- start (lock guard)
    ...;                //       |
    bla_bla();          //       |
    ...;                //       |
    sync = false        // << -- end (unlock guard)
    function done() {
        if (sync) process.nextTick(cb);
        else cb();
    }
}
// BUT, Promises even better
function fuck(x) {
    return new Promise((resolve, reject) => {
        if (typeof x !== 'number')
            throw new TypeError("x is not a number");   // err handling is async
            //reject(new TypeError("x is not a number"));
        if (x > 0)          resolve('Yeah');        // all `cb`-calls is async
        else if (x === 0)   resolve("So, so.. ");
        else                resolve("Bad");
    });
}
fuck(0) .then(val => console.log(val));
fuck(-1).then(val => console.log(val));
fuck(1) .then(val => console.log(val));
fuck('fuck') .catch(err => console.log(err.message));

@23
module.exports = function delegator(_class, redefine = true) {
    if (typeof _class !== 'function') throw new TypeError("Constructor should be a function");
    if (typeof redefine !== 'boolean') throw new TypeError("`redefine` is boolean")
    return new Delegator(_class, redefine)
}
class Delegator {
    constructor(_class, redefine) {
        this._class = _class;
        this._redefine = redefine;
    }
    ............
}
// BTW: I wonder why in some "packege" why author use such "stupid" pattern
//      function one() {
//          ...
//          return new One(...)
//      }
// Actually it can be pretty cool, SINCE, it let us to follow the "principle" of
// "Constructor should only construct" -- by Miwko(Angular) and E.Norman(Clojure)
// Since we can do all arg-check in this `fn` and let "constructor" only construct
//
//  that is SEPARATE CONCERNS
//
// Also: It's good to use "Builder" for such purposes.
//  Of course "na kazhdyi chih hu9rit' `builder` ne stoit"
//  But .. If we have many "invariants" in constructor, it's wise decision
//  extract them to builder (like `session-express` middleware)


@24
// AGAIN (ZAEBALO):
// Exmp: socket.io/index.js:Server#(attach|listen)
//  ..
// It's yet another example of "IT'S_NOT_LEAN_IT'S_MESS",  .. since we should
// handle in our `fn` many stupid scenarios of using our `fn`, IT' SO STUPID.
// so .. if I write ..
io.listen(3000);
// .. I "bl9t'" know what I'm want fake serv which listen on port 3000, with
// attached "upgdade" handler, and when I write
io.listen(new http.Server(..))
// .. then I "bl9t',suka" understand that I WHANT !DIFFERENT!  SCENARIO (prepared instead of fake)
//
// .... SO .. why not separate this, IT'S NOT EVEN "ERGONOMIC", IT'S STUPID
io.listen(3000);
io.attach(new http.Server(..));
// ... BOTH --^ those `fns` SHOULD NOT POINT TO THE SAME `fn` that doing STUPID "if"-check
// and do diff branch depending of params ....  BUT they SHOULD be just DIFFERENT `fns`
//
// AGAIN:   LEAN IS NOT A MESS


@25
flags.forEach(function (flag) {
    Socket.prototype.__defineGetter__(flag, function() {
        this.flags       = this.flags || {};
        this.flags[flag] = true;
        return this;
    })
})
// ^-- TAKA9 HUIN9 .. "getter" SHOULD NOT change state of object,
//                         and SHOULD return some obj-value instead of obj,
// OTHERWISE IT breaks principle of -= "LESS SURPRISE" =-


@26
// from socket.io ..
function Server::adapter(v) {
    if (arguments.length === 0) return this._adapter;
    this._adapter = v;
    Object.keys(this.nsps).forEach(key => this.nsps[key].initAdapter());
    return this;
}
function Namespace::initAdapter() { this.adapter = new (this.server.adapter())(this); }
//
// ...  The most correct-n-compromised way to fix this "spagetti"-complication
//          (and breaking the Demetra-law)
//      !!! BE EXPLICIT -- that what FP from my( and E.Meijer) PoV
//
//  ALSO: see rest_api_bdd:#6.0:
//      if we instead explicit pass of arg to `fn`, doing implicit access through
//      arg.references in this `fn` .. we MAY (not in this case) receive similar
//      problem to Actor&Scene
//      BECAUSE: we don't pass EXPLICITY the ABILITY to MUTATE the STATE -- FUCKIN MUT-ALIASING
//
Object.keys(this.nsps).forEach(key => this.nsps[key].initAdapter(this._Adapter))
// .. and ...
function Namespace.initAdapter(Adapter) { this.adapter = new Adapter(this); }
// ...
// .. ALSO  .. some quotation:
// | "The primary feature for easy maintenance is locality: Locality is that characteristic of
// | source code that enables a programmer to understand that source by looking at only a small
// | portion of it." — Richard Gabriel
//  ..
//  So, example in start of this post is example of breaking this "locality".
//      ....
//  .. also: author of (FunLight)(and YDKJS)
//                      tl;dr
///     "MUTABLE ALIASING(through closure-capturing or obj-propertis-referencing)" BREAK LOCALITY
//                      btw
//          closur-capturin == obj-refer  .. since closure is just object, and
//          captured vars is its "params-references"
//      .. v-- (exmp from: FunLight)
    var x = 1;
    foo();          //  << possible "mutation"(mut aliasing{closure-capturing/obj-params}) of `x`
    console.log( x );
    bar();          //  << possible "mutation"(mut aliasing{closure-capturing/obj-params}) of `x`
    console.log( x );
    baz();          //  << possible "mutation"(mut aliasing{closure-capturing/obj-params}) of `x`
    console.log( x );
//                      ALSO: POSSIBLE "COUPLING"(ORDER/FREQUENCY DEPENDENCY)
//  ..
// | In other words, the final `console.log(x)` is IMPOSSIBLE TO ANALYZE OR PREDICT UNLESS
// | YOU'VE MENTALLY EXECUTED THE WHOLE PROGRAM UP TO THAT POINT. ($$: as-min read docs)
// | Guess who's good at running your program? The JS engine. Guess who's not as good at running
// | your program? The READER OF your CODE.


@28
// $$: `co` is a good example of the power of FP, in sense "technique" to explicitly
// define "protocols"(tastfully-picked) of "data-flow" in your programm ... and it's example
// of doing that not in statical lang (with interfaces, types-for-side-effs(Monads, &mut ..))
// but dynamical -- by COMBINING A FUNCTIONs which "define" this data-flow-PROTOCOL
// .. it's even similar to "macro-write-programm" of P.Graham, since here "co" serve
// as eDSL for async-sequncial computational  ... maybe it's the way to robustness in
// DynLangs.
//
// P.S.  REACT TOO

@29
// the ONE BEAUTY PART of clojure if that IF EVEN you put atom/ref in object
// then it ONLY if you REALLY need this shared state, and by mutating
// value now you don't accidantelly mutate another object behavior
// just because it share this value .... BUT DO IT ON PURPOSE ... since
// thervise you would just use immutable-data(aka)explict-returning.
@29.1
// So, in JS, you TRY not consider object mutation as regular way ...
// BUT consider:
//  Object.create
//  Object.assign, other methods copying
// -- simple exmp
// Not mutate options when "validate and correct(def values, etc) it"
