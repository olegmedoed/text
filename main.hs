-- from reddit: You can't escape the monad, that's the point of it

-2:07-oct-17
-- https://news.ycombinator.com/item?id=12337150
--   and exmp from
-- http://www.sparxeng.com/blog/software/an-example-of-what-higher-kinded-types-could-make-possible-in-c
-- ..
-- In exmp author just write some (map/filter/reduce/..ETC) code on IEnumberable,
-- and after that say that what if we wanna write the same !!--:LOL: code for
-- IObservable (async version of Enumerable)  .... and
--    .. we (like) need HKT for that
--  ..
--  BUT... be pragmatic .... when you write code what implement some BUSINESS 
--  LOGIC over IObservable ... IT'S VERY DOUBT YOU NEED to have the same logic 
--  for Enumerable
--    ... even if you have some super-puper universal and widely-used (UTILITE)
--  pattern for "super-abstract-list-of-values" ....  you can just COPY_PASTE that
--  VERY RARE CASE ....
--    .. and don't fool yourself and think that some code common for this 2 
--  monads (Enum & Observ) can be common also for Exception(Result) also
--          (btw: see next post #-1)

-1:03-oct-17
-- Yes, you can in JS try to make Array be Monad, and has `then`,`resolve` methods,
-- and (try) like has ability to be combined in chain with Promises ....
--  (like it's bossible in Haskell with transformers)
-- BUT WHY .. WHY WE NEED IT (make Array to be Monad) .... there is NO reason to
-- combine (stavit' v odin spisok) List/Array and IO(for exmp, ar Async) .....
-- ..that just Haskell "bol'na9 fantazi9" ... because of lack to do computation in 
-- natural(for REAL computer) way, and try imitate some fancy math-model ..
-- ... so if JS was typed we can just limit MONAD interface to Exception/IO/Async
-- THAT ALL ...
-- .. 1******  so AGAIN this confirm that in practice USE CASES are tends to be
-- LIMITED instead of SUPER-PUPER-BROAD-N-ABSTRACT...(
--    ...and for-exmp in Rust Monad can be not interface but for example Enum)
--
-- MOREOVER: HTK only gives ability to express what you need 2(or more) HKT of SAME 
-- TYPE (like in Monad/Functor interfaces) .... BUT IT'S VERY RARE CASE (and again 
-- tends in practice to be mostly limited then broad 1******(in JS just 
-- Async/IO/Except  instead bunch of "containers"))
--    But most (99%) cases IS NOT SUCH ... it's usually funcs which receive some HKT, 
-- some contrete type, some abstract-type but either not HKT or HKT any type which 
-- implement interfae of this abstr-type (not necessary of abst-type of Self-HKT)
-- also trait Some<T> {....} -- we just by-convention to implement it only for HKT 
-- (maybe Rust-compolier also do warning if we try it for `i32` for exmp ..... SINCE 
-- from PRAGMATIC PoV we DON'T NEED compile time check that we implement Some<T>
-- only for HKT... it's easy tracked by CODE REVIEW)

0:apr-16
-- The coolness of Monad in that It's UNIVERSAL-interface on which we can build our programs.
-- Exmps of such interfaces:
-- * Monad
-- * Hexagonal architecture(maybe)
-- * REST(here HTTP-methods POST, GET, DELETE, PUT .. play role similar to `bind` and `return` in
-- sense that they define some very abstract UNIVERSAL way to organize programm, and the fact that
-- this interface WELL-designed gives abylity to build systems what can work on this basic
-- principles (principles embodied(ili zalozheny) in this interface)) during decades of years
--  p.s. (in HTTP-spec it's called `uniform interface`(get,post..))
--
-- * Iterators
-- * categ.theory in math
--
-- So the fact that type-system of Hskl has abylity easy express Monad interface is cool, but,
-- Monad is not built in, it just way to organize you programs, similar to as REST is the way
-- to organize you distributed program.
--
0.1
-- Also: from "Oreilly: Programming JavaScript Applications 2014"
--  A lot of CONSISTENCY is built into the REST architecture. Sticking to the conventions
--  of REST can go a long way toward making your API more consistent, both internally and
--  with other APIs that the users might be familiar with.


5
data List a = Cons a (List a) | Nil
            deriving (Show)
fromList (x:xs) = Cons x (fromList xs)  -- that is ':' == Cons, '[]' == Nil
fromList []     = Nil
-- the 2 types "isomorphic" if have the same Shape

8
-- such technique is example of streaming  (written in the form of list comprehension)
fib = 1 : 1 : [a+b| (a,b) <- zip fib (tail fib)]

10
-- morphisms are structure pereserving maps. notion of structure is given by a
-- category itself. i dont care what is this structure, but it is a thing what
-- objects in category have. what is pragmatic value of categ.theory? it's unify
-- lang format. it's convenient abstract lang, it's not is stuff itself, it the
-- way to talk about a stuff (frme: universal lang in which we can describe
-- what.is.any.stuff.is in the same way and using the same tools[objs,
-- morphisms, etc..]). it the way describe how this object fits together with 
-- other objects.
-- (frme: morphism isnot just arrows what we hold between objects; real(concrete)
-- arrows, what play role of morphims should behave like morphism, but also dont 
-- break own constraints [exmp: term.obj in SET.categ is only 1.elem.set since
-- many.elem.set can have only one func what map it to 1.elem.set] )
11
-- so, maybe,
-- since some categ mean some structure, then, when we have functor from one
-- categ to another, that means that there is something common between this 
-- category, and it's sturcture have some similarities, that means what we can
-- describe one category in term of another category.
12
-- Pierce:  """
--  which abstracts away from elements, treating objs as black boxes with
--  unexamined internal structure and focusing attention on the PROPERTIES of
--  arrows between objects.
--          """
-- so, properties.of.arrows determine what this objects is, it's like "morphism
-- are structure preserving maps", so morphisms should obey to some 
-- restrictions(have some properties[by Pierce] to preserve some structure)
-- nevertheless we know nothing about what is objects is, but we can reason 
-- about `structure` of this objects though `properties` of morphisms what 
-- connect them 


14 -- 25-mar-16  | formal system from Ocaml rewritten
sum l r = loop l 0
    where loop ac l = case l > r of
            True -> ac
            False -> loop (ac+l) (l+1)
sum l r = case l > r of
            True -> 0
--          False -> l + sum (l+1) r
            False -> r + sum l (r-1)
--
--  | L' ',n | Lm*,n* -> Lm,n | (L - less - <)
--  | ---
--  | P' ',n,n (0 - base) << in base case we dont use L, it means it should be F
--  | Pac,n*,m* -> Ln*,m* -> Pac*,*n,m
--  |
--  matching in FP have no order preference (as P.Graham has said in funtional
--  lang order have no meaning since state is dont changable, we only can return
--  another state), it is contrast to C 'case' where state is changable

15
-- AFAIU: the monads laws just tell us (as programmer, not mathemation) that:
-- we can exchange nodes in our comp.chain (1.Left identity 2.Right identity),
-- and that we can combine any parts of this chain in any way (3.Associativity) ...
-- ...  that is if we change the order of nodes in a chain, then the only
-- order of computation should be changed, BUT not side-effect(not type of
-- side-effet, but how impact of side-effect)
-- SO [gist] side-effect what monad impose on pure-fns should not depend on
-- the way(usually order) how we combine monad nodes.

16
-- About "TEMPORAL COUPLING" and (frME)"coherence of manipulated by fns data"(CoMD)
-- so, exmp, in impreative lang we have fn ..
do_one();
do_two();
--  .. and it makes sense for us only DO IT IN SUCH ORDER, since `do_one` has
--  some desirable for `do_two` side-eff ... SO .. WE HAVE NOTION OF "TIME"
--  if we do computation throug mutation the "TIME OF MUTATION" DOES MATTER A LOT
--  .. BUT in pure-fun-style WE JUST COMBINE COMPUTATION ... SO WE HAVE
do_two . do_one  -- <<-- (no Monads here)
-- that is we EXPLICITLY combine diff computation stages, and the way we combine
-- them determinle "LIKE-TIME"
-- | .. p.s. ...
-- | BEFORE_READ: rest_api_bdd:##26.2
-- | So.. `do_one` and `do_two` here (IMPERATIVE) form "state machine"(maybe local/incapsulation)
-- | with "mut-aliasing"  .. and this "state-machine" has ORDER/FRECENCY-DEPENDENCY (temp coupling)
-- | beetwen call to its "getters/setters" ... WE SHOULD AWOID THIS DEPENDCENCY
-- | in IMPERATIVE WORLD
-- ..
-- ... And as "EMERGENCY" we  WILLING in such conditions write FNs that
-- "LIKE MUTATE"(in Hskl EXPLICITLY RETURNED VALUES) so "EMERGENCY" is CoMD
-- since if in imperative word `do_one` and `do_two` mutate "TOO MANY of TOO
-- UNCOHERENCE" data then in Hskl we need RETURN TO MANY DIFF DATA
let (a, b, c) = do_one
    (x, y, z) = do_two b a
    ....
-- SO ... OCHEN' BOL'WOI RAZBROS
