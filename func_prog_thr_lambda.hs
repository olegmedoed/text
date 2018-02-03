-- paragraph 1.1 , good intro, like a quote
--
-- so, conceptually, as it turns out, in imperation lang with the "strict static
-- type system" the result type of every expression is checked too, since to be
-- assigned to variable, it should have apropriate type.
fff bl v = if bl then (a . b) v
                 else (c . d) v
  where a v = v + 1     -- so, here type of computed expression is checked
        b v = v * 2     -- by type of income(outcome) for funcs a, b, c, d
        c v = v / 3
        d v = v - 5
-- analog in impereative lang (pseudo code)
fff bl v = def some_type a, b, c, d;
           if bl then a := v + 1; b := a * 2;-- return res of expr in last stat
                 else c := v / 3; d := c - 5;
-- so here type def of vars a,b,c,d play role of type def of func signature in
-- func_lang
-- in func_lang type and value of 'if' are determined by last func in fun-compo
-- in imper_lang informally we can consider last statement as val of 'if', so
--  computing expr. we can reuse vars with the same type to assign values of 
--  expressions, it may looks like
  a := v+1; a := a * 2  -- but since in imper_lang every var name have some
--  meaning(purpose for wich we use this var) such reusing of var not always
--  good, that is some times is useful, sometime not, and as result imperative
--  approach more tangled
-- so,
--  as conclusion, "rust" is cool lang, since it use more elegant functional way,
--  but gives oportunity use imper way with "strict static type sys"(as opposed 
--  to C)(and thereby this sys can guaranty type of expr computation result) in
--  some cases
-- also,
--  whereas in func_lang we pass the result of one expres to another through
--  composition,    in imper_lang we need give name to every comput. result,
--  although it's compensated by opportunity reusing vars with same type(but
--  as I mentioned, it's more complicated in most cases)
-- addition, after few days
--  let x = 3 + 5 in        x := 3 + 5
--  let x = x * 3 in        x := x * 3
--  x + x                   return x + x
-- so,
--  by using 'let' and rebind some var(here 'x') we do practically the same 
--      what in imper_langs(of course, since in func.prog rebind is not
--      perrmited, name-to-val(expr)==1-to-1)
-- repeat myself
--  in imperative lang it's important to not change the args

-- Turing demonstrated that it is impossible to tell whether or not an
-- arbitrary Turing machine will halt. This also applies to lambda calculus
-- and recursive function theory, so there is no way of telling if evaluation
-- of an arbitrary lamb. expression or recursive function call will ever
-- terminate. However, Church and Rosser showed for lamb. calculus
-- that if different evaluation orders do terminate then the results will be the
-- same. They also showed that one particular evaluation order is more likely
-- to lead to termination than any other. This has important implications for
-- computing because it may be more efficient to carry out some parts of a
-- program in one order and other parts in another order. In particular, if a
-- language is evaluation order independent, then it may be possible to carry
-- out program parts in parallel.

-- The \.calc is a surprisingly simple yet powerful system. It is based on
-- function abstraction, to generalize expressions through the introduction
-- of names, and function application, to evaluate generalized expressions
-- by giving names particular values.

-- Firstly, only abstraction and application are needed to develop
-- representations for arbitrary programming language constructs; thus \.calc
-- can be treated as a universal machine code for programming languages.

-- Abstraction is central to problem solving and programming. It involves
-- generalization from concrete instances of a problem so that a general
-- solution may be formulated.

REPLACE items in 10*items
-- Here, we have abstracted over an operand in the formula. To evaluate this
-- abstraction, we need to supply a value for the name.
-- We have made a function from a formula by replacing an object with a
-- name and identifying the name that we used. We have then evaluated the
-- function by replacing the name in the formula with a new object and
-- evaluating the resulting formula.
REPLACE cost in
    REPLACE items in cost*items
-- Here, we have abstracted over two operands in the formula. To evaluate
-- the abstraction, we need to supply two values.
REPLACE op in
  REPLACE cost in
    REPLACE items in cost op items
-- Here, we have abstracted over two operands in the formula. To evaluate
-- the abstraction, we need to supply two values.
REPLACE op WITH * in
  REPLACE cost in
    REPLACE items in cons * items --which is ...
REPLACE cost in
  REPLACE items in cost * items
-- Abstraction is based on generalization through the introduction of a name to
-- replace a value and specialization through the replacement of a name with
-- another value. Type system is responsible to ensure that names are replaced
-- by objects and operations of appropriate types.

-- In imper_lang, variables as name/value associations are abstractions
-- for computer memory locations based on specific address/value associations.

-- Abstractions may be subject to further abstraction. This is the basis
-- of hierarchical program design methodologies and modularity.
-- [exmp], Pascal procedures are abstractions for sequences of statements,
-- named by procedure declarations, and functions are abstractions for
-- expressions, named by function declarations.
-- Procs and funcs declare formal params which identify the names used to
-- abstract in statement sequences and expressions.  Actual params specialize
-- procs and funcs. Procedure calls with actual params invoke sequences of
-- statements with formal params replaced by actual params.

-- A λ.expr may be a name to identify an abstraction point, a function to
-- introduce an abstraction or a func application to specialize an abstraction
--  <expression> ::= <name> | <function> | <application>
--
-- A λ.function is an abstraction over a λ.expr and has the form:
--  <function> ::= λ<name>.<body>        <body> ::= <expression>
--
-- The 'name' is called the function's "bound variable" and is like a formal
-- parameter in a Pascal function declaration.
-- Notice that the body expression may be any \.expr including another func.
-- This is far more general than,[exmp] Pascal, which does not allow funcs to
-- return funcs as vals. Note that funcs do not have names!
--
-- <application> ::= <function expression> <argument expression»
-- <function expression> ::= <expression>
-- <argument expression> ::= <expression>
(\x.x \a.\b.b)--[exmp]
--
-- A function application specializes an abstraction by providing a value for
-- the name. The function expression contains the abstraction to be special-
-- ized with the argument expression.
--      In a function application, also known as a "bound pair", the function
-- expression is said to be applied to the argument expression.
--      Whereas in Pascal the function name is used in the function call and
-- the implementation picks up the corresponding definition; the λ.calculus is
-- far more general and allows function definitions to appear directly in
-- function calls.
--
-- 2 approaches to evaluating function applications. For both, the function
-- expression is evaluated to return a function. All occurrences of the 
-- function's bound variable in the function's body expression are then replaced
-- by either:
--  the value of the argument expr (call-by-value) "aplicative order"
--      the actual parameter expression is evaluated before
--      being passed to the formal parameter.
--  the unevaluated argument expression. (call-by-name) "normal order"
--      the actual parameter expr is not evaluated before being passed to
--      the formal parameter.
--{As we will see, normal order is more powerful than applicative, but less ef.}
--
--  {{{for now, all func.appl be eval. in 'normal order'}}} 
--
-- The syntax allows a single <name> as a λ expression but in general we
-- will restrict single names to the bodies of functions. This is so that we can
-- avoid having to consider names as objects in their own right, for example
-- LISP or PROLOG literals,
--
-- (λs.(s s) λs.(s s))           λ version of this self-application function
-- is used to construct recursive functions in Chapter 4.
--
-- To simplify working with λ.exprs and to construct a higher level functional
-- lang, we will allow the use of more concise notations:
--      named function definitions,
--      infix operations,
--      an IF style conditional expression .... and so on.
-- This is known as "syntactic sugaring" because the representation of the 
-- language is changed but the underlying meaning stays the same.
--
-- New syntax will be introduced for commonly used constructs through
-- "substitution rules". The application of these rules will not involve
-- making choices. Their use will lead to pure λ.expressions after a finite
-- number of steps involving simple substitutions. This is to ensure that we
-- can always 'compile' completely a higher level representation into λ
-- calculus before evaluation. Then, we only need to refer to our original
-- simple λ calculus rules for evaluation.
-- Furthermore, we are going to use λ.calculus as a time order
-- independent language to investigate time ordering. .... p30
-- We will not always make all substitutions before evaluation as this
-- would lead to pages and pages of incomprehensible A expressions for large
-- higher level expressions. We will insist, however, that making all substi-
-- tutions before evaluation always remains a possibility.
--
--
-- 2.7 Notations for naming functions and r3 reduction
-- We will now name functions using:
--      def <name> = <function>
-- all defined <name>s in an expr should be replaced by their definitions
-- before the expression is evaluated.
-- (<name> <argument>) == (<function> <argument>)
--
-- the replacement of a bound variable with an argument in
-- a function body is called β reduction. In future, instead of detailing
-- each normal order β reduction we will introduce the notation:
--      (<function> <argument>) => <expression>
-- to mean that the <expression> results from the application of the
--      <function> to the unevaluated <argument>.
--
-- See 2.8 Functions from functions p31
identity = \x -> x
self_apply = \s -> s s -- not working Haskell code, see Y combinator
first  = \ fst snd -> fst       -- λfst.snd.fst
second = \ fst snd ->  snd      -- λfst.snd.snd


-- make par function can be expressed like
make_par = \ f s fun -> (fun f) s -- λf.s.fun.((fun f) s)
-- so,
par = make_par 1 2 -- -> ((fun 1 ) 2)
-- then
par fst -- > 1
par snd -- > 2

-- A <name>. <body>
-- the bound variable <name> may correspond to occurrences of <name> in
-- <body> and nowhere else. Formally, the scope of the bound variable
-- <name> is <body>.
--
-- Introduce the idea of a variable being bound or free in an expression.
--      A variable is said to be bound to occurrences in the body of
-- a function for which it is the bound variable, provided no other functions
-- within the body introduce the same bound variable; otherwise it is said to
-- be free.
--  See exmps on p40
--
-- In general, for a function:
--       \<name>.<body>
-- <name> refers to the same variable throughout <body> except where
-- another function has <name> as its bound variable. References to
-- <name> in the new function's body then correspond to the new bound
-- variable and not the old.
--
-- In formal terms, all the free occurrences of <name> in <body> are
-- references to the same bound variable <name> introduced by the original
-- function. <name> is in scope in <body> wherever it may occur free, except
-- where another function introduces it in a new scope.
-- [exmp]
--      \f.(f \f.f)  in body of this <func>...
-- the first f is free so it corresponds to the original bound variable f but
-- subsequent fs are bound and so are distinct from the original bound
-- variable. The outer f is in scope except in the scope of the inner f.
--
-- See rules of "bound or free" p41

-- We have restricted the use of names in expressions to the bodies of
-- functions. This may be restated as the requirement that there be no free
-- variables in a A expression. Without this restriction, names become objects
-- in their own right. This eases data representation: atomic objects may be
-- represented directly as names, and structured sequences of objects as
-- nested applications using names. However, it also makes reduction much
-- more complicated.
-- so, in
--      def apply = \func.\arg.(func arg)
--      ((apply arg) boing) == ((\func.\arg.(func arg) arg) boing) =>
--      (\arg.(arg arg) boing) => (boing boing)
--
-- it was not intended, The argument arg has been substituted in the
-- scope of the bound variable arg and appears to create a new occurrence of
-- that bound variable. We can avoid this using consistent renaming.
--                                              (aka "alpha conversion")
--  ((\func.\arg1.(func arg1) arg) baing) =>
--  (\arg1.(arg arg1) boing)              => (arg boing)
--
--      \<name1 >.<body>
-- the name <name1> and all free occurrences of <name1> in <body> may
-- be replaced by a new name <name2> provided <name2> is not the name
-- of a free variable in \<name1>.<body>. Note that replacement includes
-- the name at:      \<name1>
-- In subsequent examples we will avoid name clashes.

-- See η-reduction on p44  !"eta-reduction"
-- See summary of \.calc

-- CHAPTER 3 -----------------------------------------------------------------

-- We can model a conditional expression using a version of the make pair
-- function:
--              def cond = \e1.\e2.\c.((c e1) e2)))
true    = \ f s      -> f
false   = \ f s      -> s

cond    = \ e1 e2 c  -> (c e1) e2

not     = \ x        -> cond false true x
and     = \ x y      -> cond y false x
or      = \ x y      -> cond true y x

zero    = id
succ    = \ n s       -> (s false) n
succ    :: t1 -> ((t2 -> t3 -> t3) -> t1 -> t) -> t
-- so, looking ahead, 
isZero  = \ n -> n true -- in other nums it's false

{one = succ zero;  two = succ one;  three = succ two  } -- as a result,
two == three false  -- "three-- == two"
pred    = \ n -> n false
-- also to take into account that pred of zero is zero
predZ   = \ n -> ((cond n) (pred n)) (isZero n)

-- SEE Simplified notations p59   -- make \.exprs like Haskell

-- CHAPTER 4    --------------------------------------------------------------

-- It is useful to distinguish "bounded repetition", where something is carried
-- out a fixed number of times, from the more general "unbounded iteration,"
-- where something is carried out until some condition is met.
--
-- It is important to relate the form of repetition to the structure of the
-- item to be processed. Bounded repetition is used where a linear sequence
-- of objects of known length is to be processed, for example, processing each
-- element of an array.
--
-- Bounded repetition is a weaker form of unbounded repetition.
-- Carrying out something a fixed number of times is the same as carrying it
-- out until the last item in a sequence has been dealt with.
--
-- In imperative languages, repetition is based primarily on iterative
-- constructs for repeatedly carrying out structured assignment sequences.
--
-- In functional languages, programs are based on structured nested
-- function calls. Repetition requires such nesting to be continued until some
-- condition is met. There is no concept of a changing shared memory.
-- Instead, each function passes its result to the next in the function call
-- nesting. Repetition involves deciding whether or not to carry out another
-- layer of function call nesting with the same nested sequence of function
-- calls.
--
-- [from me]
--          while x < 10 do ex1 end
--          while_fun = \ ex1 x -> cond (ex1 and while_fun ex1 x)
--  |(x<10) and () is not defined yet,| ()
--  |but the gist is clear            | (x < 10)
--
-- It is useful to distinguish primitive recursion, where the number of
-- repetitions is known, from general recursion, where the number of
-- repetitions is unknown. Primitive recursion is weaker than general recur-
-- sion. Primitive recursion involves a finite depth of function call nesting, so
-- it is equivalent to bounded repetition through iteration with a finite
-- memory. For general recursion, the nesting depth is unknown so it is
-- equivalent to unbounded repetition through iteration with an infinite
-- memory.
-- Note that imperative languages often provide repetition through
-- recursive procedures and functions as well as through iteration.
add = \ a b -> cond a (add (succ a) (pred b)) (isZero b)



