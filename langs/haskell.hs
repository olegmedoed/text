-- operator isn’t built into the language; it’s an ordinary function.

-- computation perform when input output happend, or when pattern
-- matching happend. (it some cases, maybe there are some other cases)

-- If the line that follows is empty, or its indentation is further to the 
-- right, it is considered as a continuation of the previous line. If the 
-- indentation is the same as the start of the preceding item, ir is treated
-- as beginning a new item in the same block

-- Strict languages are often referred to as "call by value," while lazy
-- languages are referred to as "call by name."

-- Shadowing can obviously lead to confusion and nasty bugs, so GHC has a
-- helpful -fwarn-name-shadowing option

-- We can use ghci to inspect the precedence levels of individual operators,
-- using ghci ’s :info command(also type and definition palce for not
-- standard functions)
class Num a where
    (+) :: a -> a -> a
      ...  -- Defined in `GHC.Num'
infixl 6 +    -- <<< infixl mean left-associativity

-- Every expression and function in Haskell has a type.
> :t 2 < 0 || null "fuck"
> 2 < 0 || null "fuck" :: Bool

-- Haskell  will not automatically converse values from one type to another.

{x = 1; x = 1} -- >> multiple declaration

makeList = 1 : makeList
-- However, since Haskell is lazy (or "call by name"), we do not actually
-- attempt to evaluate what makeList is at this point: we simply remember
-- that if ever in the future we need the second element of makeList, we need
-- to just look at makeList.
-- Now, if you attempt to write makeList to a file, print it to the screen,
-- or calculate the sum of its elements, the operation won’t terminate because
-- it would have to evaluate an infinitely long list. However, if you simply
-- use a finite portion of the list (say the first 10 elements), the fact that
-- the list is infinitely long doesn’t matter. If you only use the first 10
-- elements, only the first 10 elements are ever calculated. This is laziness
--
-- Haskell requires that the names given to functions and values begin with
-- a lower-case letter and that the names given to types begin with an
-- upper-case letter
--
-- A side effect is essentially something that happens in the course of
-- executing a function that is not related to the output produced by that
-- function.
-- if you modify “global” variables (in C, Java) from within a function.
-- This is a side effect because the modification of this global variable is
-- not related to the output produced by the function.
--
-- Printing something to the screen, reading a file, etc., are also side
-- effecting operations.
--
-- Functions that do not have side effects are called pure. (with given
-- argument always produce the same value(result))
--
-- A call like x = x + 1 is called "destructive update" because we are
-- destroying whatever was in x before and replacing it with a new value.
-- Destructive update does not exist in Haskell.
--
-- If we define some func f, and call it in the beginning of prgramm with
-- arg a, and then at the end with a, we will have the same result.
-- This property is called "referential transparency" and basically states
-- that if two functions f and g produce the same values for the same arguments,
-- then we may replace f with g (and vice-versa).)
--
-- If you’re familiar with programming in other languages, you
-- may find it odd that sqrt 2 comes back with a decimal point (i.e., is a
-- floating point number) even though the argument to the function seems to
-- be an integer. This interchangability of numeric types is due to
-- Haskell’s system of type classes)

fst (1,"fuck") > 1 ; snd (3,'3') > '3' ; snd (1,2,3) > 3 --type error
x = snd (fst ((1,4), 5)) > x=4

x = 0:[1,2] > [0,1,2]  -- ':' is "cons" operator
-- [1,2,3] is just 'syntax sugar',compiller just translete it in 1:2:3:[]

-- tuples are heterogeneous, lists must be homogenous.
-- This means that you cannot have a list that holds both integers and strings.
-- If you try to, a type error will be reported

-- head , tail , langth [some list]

-- In Haskell, a String is simply a list of Chars. So, we can create the
-- string “Hello” as:  >>> 'a':'b':'c':[]  >>> "abc"
--
-- list and string can be concatenate using the ++ operator
-- non-str to str : show
-- str to non-str : read
x = 1 + read "34"  ;   1 + read "hello" >--exception: read no parse

-- Much of the computation in Haskell programs is done by processing lists.
-- 3 primary list-processing functions: map, filter and fold(r|l)
--
-- to covert an entire string (which is simply a list of characters)
-- to upper case, we can map the toUpper function across the entire lis)
x = map Char.toUpper "hello world" ; Char.isLower 'X' > False
sum x = x + x;  x = map sum (1:2:3:[])
-- see about foldr(foldl) p28 [it's called "folding funtions"]
--
-- "foldl" accomplishes this is essentially by going all the way down the list,
-- taking the last element and combining it with the initial value via the
-- provided function. It then takes the second-to-last element in the list and
-- combines it to this new value. It does so until there is no more list left.
--
-- foldl is often more efficient than foldr for reasons that
-- we will discuss in Section 7.8. However, foldr can work on infinite
-- lists, while foldl cannot. This is because before foldl does any-
-- thing, it has to go to the end of the list. On the other hand, foldr
-- starts producing output immediately. For instance, foldr (:) []
-- [1,2,3,4,5] simply returns the same list. Even if the list were in-
-- finite, it would produce output. A similar function using foldl would
-- fail to produce any output.
-- [form me] so,
foldr (+) 0 [1,2,3] --so it like 1 + (foldr (+) 0 [2,3]), but ..
foldl (+) 0 [1,2,3] --is like foldl (+) (0 + 1) [2,3]
--
let fltr x = x < 4; let res = filter fltr somelst
let res = foldl (+) 0 res >--since Haskell is lazy that computation of res is
      --  not occur immidiatelly, so such expression is considered as infinite: 
      --  Occurs check: cannot construct the infinite type: b0 = [b0]]

:load my_file.hs
-- You’ll notice that where it used to say "Prelude" it now says "Test."
-- That means that Test is the current module. You’re probably thinking that
-- "Prelude" must also be a module. Exactly correct. The Prelude module
-- (usually simply referred to as "the Prelude") is always loaded and contains
-- the standard definitions (for instance, the (:) operator for lists, or (+) or
-- (*), fst, snd and so on).)))))
--
-- to be compilable file must have module "Main" and must contain a function
-- called main
--
-- ! functions are central to Haskell, as it is a functional language.
--   This means that the evaluation of a program is simply the evaluation of
--   a function.
mySignum x | x < 0 = -1 | x > 0 = 1 | otherwise = 0
mySignum (-1) > -1
-- Note that the parenthesis around “-1” in the last example are required;
-- if missing, the system will think you are trying to subtract the value "1"
-- from the value "signum," which is illtyped.
--
-- in "if" you must have both a "then" and an "else" clause. It evaluates
-- the condition (in this case x < 0 and, if this evaluates to True, it
-- evaluates the then condition; if the condition evaluated to False, it
-- evaluates the else condition).

:r or :reload -- reload current module

-- Haskell uses a system called "layout" to structure its code (the programming
-- language Python uses a similar system))
-- The general rule for layout is that an open-brace is inserted after the
-- keywords where, let, do and of, and the column position at which the next
-- command appears is remembered. From then on, a semicolon is inserted before
-- every new line that is indented the same amount. If a following line is
-- indented less, a close-brace is inserted.
f x =
    case x of
      0 -> 0
      1 -> 1
      _ -> -1 -- Some people prefer not to use layout and write the
              -- braces and semicolons explicitly.
f x = case x of { 0 -> 0; 1 -> 1; _ -> -1} -- if you write the braces and
      -- semicolons explicitly, you're free to structure the code as you wish
f x = case x of { 0->0;
      1 -> 1; _ -> -1} -- !!! it just in case, you can delete it later
-- also
f 0 = 0       -- here order is important, since if we had put _ first,

--      sqrt    - the square root function
--      id      - the identity function: id x = x
--      fst     - extracts the first element from a pair
--      snd     - extracts the second element from a pair
--      null    - tells you whether or not a list is empty
--      head    - returns the first element on a non-empty list
--      tail    - returns everything but the first element of a non-empty list
--      ++      - concatenates two lists
--      ==      - checks to see if two elements are equal
--      /=      - checks to see if two elements are unequal

-- Infix functions are ones that are composed of symbols, rather than letters.
-- For instance, (+), (*), (++) are all infix functions. You can use them in
-- non-infix mode by enclosing them in parentheses
1 + 2   or   (+) 1 2
-- Similarly, non-infix functions (like map) can be made infix by enclosing
-- them in backquotes
Char.toUpper `map` "hello man"
-- Hugs users: Hugs doesn’t like qualified names like Char.toUpper.
-- In Hugs, simply use toUpper

-- !!!!!!!![from me]   again about recursion
-- we just write base case exmpls, and after that write cases(rules of
-- inference) where describe how to compute, here we denote values what
-- received on previous(below) levels by calling function(which is actually
-- set of rules of inference)
--
-- If you call function what read form std twice, and the user types something
-- the first time and something else the second time, then you no longer have
-- a function, since it would return two different values. The solution to this
-- was found in the depths of category theory: monads
-- for now think of them simply as a convenient way to express operations
-- like input/output
--
-- The way to do this is to use the "do" keyword. This allows us to specify the
-- order of operations (remember that normally, since Haskell is a lazy
-- language, the order in which operations are evaluated in it is unspecified)

main = do
    hSetBuffering stdin LineBuffering
    putStrLn "Pleas enter a name:"
    name <- getLine
    putStrLn ("Hello " ++ name ++ ". How are you?")
-- The parentheses are required on the second instance of putStrLn but not the
-- first. This is because ++ binds more tightly than function application, so
-- without the parenthesis, the second would be interpreted as
-- (putStrLn "Hello, ") ++ name ++ ...)
-- p210: we start with "do", it means that we’re execut. a sequence of commands
-- hSetBuffering stdin LineBuffering this is only required by GHC 
-- n Hugs you can get by without it) The necessity for this is because, when
-- GHC reads input, it expects to read it in rather large blocks. A typical
-- person’s name is nowhere near large enough to fill this block. Thus, when
-- we try to read from stdin, it waits until it’s gotten a whole block. We want
-- to get rid of this, so we tell it to use LineBuffering instead of block
--      buffering.
-- using the "<-" instead of the "=" shows that getLine isn’t a real
-- function and can return different values. This command means "run the action
--      getLine, and store the results in name."

-- if function is pure (and not an IO action), we don’t need to use the <-
-- notation (!! in fact, we cannot)
main = do
  hSetBuffering stdin LineBuffering
  num <- randomRIO (1::Int, 100)
  putStrLn "I'm thinking about number between 1 and 100"
  doGuessing num

doGuessing num = do
  putStrLn "Enter your guess:"
  guess <- getLine
  let guessNum = read guess
  if guessNum < num
     then do putStrLn "Too low"
             doGuessing num
     else if guessNum > num
        then do putStrLn "Too high"
                doGuessing num
        else do putStrLn "You win"
  -- the fact of exit is implicit
  -- The recursive action that we just saw doesn’t actually
  --   return a value that we use in any way.
       --   [exmp]
askForWords = do
  putStrLn = "Say word"
  word  <- getLine
  if word == ""
     then return []
     -- wrong way
     else return (word : askForWords)
     -- rigth way
     else do rest <- askForWords
             return (word : rest)
  -- Remeber that when using (:), we are making a list out of an element (in
  -- this case word) and another list (in this case, askForWords). However,
  -- askForWords is not a list; it is an action that, when run, will produce
  -- a list. That means that before we can attach anything to the front, we
  -- need to run the action and take the result
  -- [from me]
  -- so, it mean we operations with side-effects(destructive) cause an action
  -- running(before that all is lazy, that is computation not performed until
  -- destructive operation be applyied)
------------------------------------------------------------------------------
---------------Chapter 4------------------------------------------------------
------------------------------------------------------------------------------

-- Haskell uses a system of static type checking. This means that every
-- expression in Haskell is assigned a type
-- 
-- if you have a function which expects an argument of a certain type and you
-- give it the wrong type, a compile-time error will be generated
--
-- If you want, you certainly are allowed to explicitely specify the type of
-- an expression; this often helps debugging. In fact, it is sometimes
-- considered good style to explicitly specify the types of outermost functions.
:t 'c'          > 'c' :: Char  -- << Char is UNICODE character
:t "fuck"       > "fuck" :: [Char] -- String
-- if some type a is an instance of the Num class, then type type of the
-- expression 5 can be of type a.
:t 1            > 1 :: Num a => a
:t 1.0          > 1.0 :: Fractional a => a
:t 'a' == 'b'   > 'a' == 'b' :: Bool   -- 2 possible values True and False
-- you can explicitely specify the type of an expression using the :: operator.
:t 4 :: Int     > 4 :: Int :: Int -- 32(64)bit , Haskell guaranty > 28bit
:t 5 :: Double  > 5 :: Double :: Double -- Float is much slower(use Double)
:t [3,'a']      > -- No instance for (Num Char) arising from the literal `3')
:t (4,'a')      > (4,'a') :: Num t => (t, Char)
f a b = a + b         > f :: Num a => a -> a -> a
f a b = show (a + b)  > f :: (Num a, Show a) => a -> a -> String
-- To construct a rational number, we use the (%) operator.)
:m Data.Ratio ; 4 % 5  -- << ghci
-- When we force ghci to evaluate the expression 3 + 2 , it has to choose a
-- type so that it can print the value, and it defaults to Integer . In the
-- second case, we ask ghci to print the type of the expression without actually
-- evaluating it, so it does not have to be so specific
Prelude > 3 + 3     >> it :: Integer
Prelude > :t 3 + 3  >> 3 + 3 :: Num a => a

-- () , that acts as a tuple of zero elements. This type has only one
-- value, which is also written () . Both the type and the value are usually
-- pronounced “unit.” If you are familiar with C, () is somewhat similar to void

-- Haskell employs a "polymorhpic type system". This essentially means that you
-- can have       "type variables"
tail [1,2,3] > [2,3] -- it possible since ...
:t tail >  tail :: [a] -> [a] -- taile has a polymorphic type, so can take as
  -- an argument any list and return a value which is a list of the same type.
fst :: (a, b) -> a   -- fst also polymorphic
-- Here, GHCi has made explicit the "universal quantification" of the type values.
--    That is, it is saying that for all types a and b,
--    fst is a function from (a, b) to a

fst :: (a,b) -> a
-- The result type of fst is a . We’ve already mentioned that parametric
-- polymorphism makes the real type inaccessible. fst doesn’t have enough
-- information to construct a value of type a , nor can it turn an a into a b.
-- So the only possible valid behavior (omitting infinite loops or crashes)
-- it can have is to return the first element of the pair.k)

-- In many languages (C++, Java, etc.), there exists a system of overloading.
-- That is, a function can be written that takes parameters of differing types.
-- For instance, the cannonical example is the equality function. If we want
-- to compare two integers, we should use an integer comparison; if we want to
-- compare two floating point numbers, we should use a floating point
-- comparison; if we want to compare two characters, we should use a character
-- comparison. In general, if we want to compare two things which have type α,
-- we want to use an α-compare. We call α a "type variable" since it is a
-- variable whose value is a type.
-- This presents some problems for static type checking, since the type
-- checker doesn’t know which types a certain operation (for instance,
-- equality testing) will be defined for.
-- The one chosen in Haskell is the system of "type classes".
-- so,  we want to define oper. == which takes two argument arguments of the
-- same type and return the boolean.
-- But this function may not be defined for every type; just for some.
-- Thus, we associate this function == with a "type class", which we call Eq.
-- If a specific type α belongs to a certain type class (that is, all
-- functions associated with that class are implemented for α), we say that α
-- is an "instance" of that class. For instance, Int is an instance of Eq since
-- equality is defined over integers
-- In addition to overloading operators like ==, Haskell has overloaded numeric
-- constants (i.e., 1, 2, 3, etc.). This was done so that when you type in a
-- number like 5, the compiler is free to say 5 is an integer or floating point
-- number as it sees fit. It defines the Num class to contain all of these
-- numbers and certain minimal operations over them (addition, for instance).
-- The basic numeric types (Int, Double) are defined to be instances of Num.
--        [it's like "numeric" type what I defined in OCaml]
-- Another of the standard classes in Haskell is the Show class. Types which
-- are members of the Show class have functions which convert values of that
-- type to a string.  This function is called "show". For instance show applied
-- to the integer 5 is the string "5"; show applied to the character 'a' is the
-- three-character string "'a'" (the first and last characters are
-- apostrophes). show applied to a string simply puts quotes around it.
show "hello" > "\"hello\"" -- actual string don't contain the backslashes
-- Some types are not instances of Show; functions for example
--
-- In Haskell, functions are first class values, meaning that just as 1 or 'c'
-- are values which have a type, so are functions like "square" or ++
--    something about "lambda calculus" p52
--  In fact, Haskell is largely based on an extension of the lambda calculus,
--  and these two expressions can be written directly in Haskell (we simply
--  replace the λ with a backslash and the . with an arrow; also we don't need
--  to repeat the lambdas; and, of course, in Haskell we have to give them
--  names if we’re defining functions)
-- High-Order Types
-- "Higher-Order Types" is the name given to functions. The type given to
-- functions mimicks the lambda calculus representation of the functions.
-- [exmp] the definition of square gives λx.x ∗ x. To get the type of this,
--   we first ask ourselves what the type of x is. Say we decide x is an Int.
--   Then, we notice that the function square takes an Int and produces a value
--   x*x. We know that when we multiply two Ints together, we get another Int,
--   so the type of the results of square is also an Int. Thus, we say the type
--   of square is Int → Int
-- We can also get the type of operators like + and * and ++ and :; however,
-- in order to do this we need to put them in parentheses
:t (+) > Num a => a -> a -> a
-- In general, any function which is used infix (meaning in the middle of two
-- arguments rather than before them) must be put in parentheses when getting 
-- its type.
:t putStrLn   > putStrLn :: String -> IO ()
:t readFile   > readFile :: FilePath -> IO String
-- It’s basically Haskell’s way of representing that these functions aren't
-- really functions. They’re called "IO Actions" (hence the IO)
-- The immediate question which arises is: okay, so how do I get rid of the IO.
-- In brief, you can't directly remove it. That is, you cannot write a function
-- with type IO String → String. The only way to use things with an IO type is
-- to combine them with other functions using (for example), the 'do' notation.)
-- [exmp] 
--    if you’re reading a file using readFile, presumably you want to do
--  something with the string it returns. Suppose you have a function f which
--  takes a String and produces an Int. You can't directly apply f to the result
--  of readFile since the input to f is String and the output of readFile is
--  IOString and these don’t match. However, you can combine these as:
main = do str <- readFile "somefile"
          let i = f s
          putStrLn (show i)
-- Here, we use the arrow convention to "get the string out of the IO action"
-- and then apply f to the string (called s). We then, for example, print i
-- to the screen. Note that the let here doesn’t have a corresponding in. This
-- is because we are in a do block.  Also note that we don’t write i <- f s
-- because f is just a normal function, not an "IO action"
--    It is sometimes desirable to explicitly specify the types of some elements
-- or functions, for one (or more) of the following reasons:
--    • Clarity • Speed • Debugging
-- Some people consider it good software engineering to specify the types of
-- all top-level functions. If nothing else, if you’re trying to compile a
-- program and you get type errors that you cannot understand, if you declare
-- the types of some of your functions explicitly, it may be easier to figure
-- out where the error is.  Type declarations are written separatly from the
-- function definition.
square :: Num a => a -> a
square x = x * x
-- he type that you specify must match the inferred type of the function
-- definition (or be more specific).)
-- In this definition, you could apply square to anything which is an instance
-- of Num: Int, Double, etc. However, if you knew apriori that square were only
-- going to be applied to value of type Int, you could refine its type as:
square :: Int -> Int      -- now you could only apply 'square' to values of
square x = x * x          -- type Int
-- with this definition, the compiler doesn’t have to generate the general
-- code specified in the original function definition since it knows you will
-- only apply square to Ints, so it may be able to generate faster code.
-- If you have extensions turned on (“-98” in Hugs or "-fglasgow-exts"
-- in GHC(i)), you can also add a type signature to expressions and not just
-- functions. For instance, you could write:
square (x :: Int) = x * x -- however, it leaves the compiler alone to infer
--                           the type of the rest of the expression.<|
-- check it either by compiling or in REPL                           |
:t (\ (x :: Int) -> x * x) -- since this lambda abstraction is equiv>|
      -- since map take value a and produce b hy using func passed as arg
:t map  > map :: forall a b. (a -> b) -> [a] -> [b]

-- Data types         vvv-possible pair definition-vvv
data Pair a b = Pair a b > Pair :: forall a b. a -> b -> Pair a b
-- we’re defining a datatype. We then give the name of the datatype,
-- in this case, "Pair". The "a" and "b" that follow "Pair" are type
-- parameters, just like the "a" is the type of the function 'map'
-- so, define a data structure called "Pair" which is parameterized over
-- two types, a and b.
-- After the equals sign, we specify the constructors of this data type.
-- In this case, there is a single constructor, "Pair" (this doesn’t
-- necessarily have to have the same name as the type, but in this case it 
-- seems to make more sense) After this pair, we again write "a b", which means
-- that in order to construct a Pair we need two values, one of type a and one
-- of type b.
:t Pair 'a'         > Pair 'a' :: forall b. b -> Pair Char b
:t Pair 'a' 1       > Pair 'a' 1 :: forall b. Num b => Pair Char b
:t Pair 'a' "hell"  > Pair 'a' "hell" :: Pair Char [Char]

pairFst (Pair a b) = a  ; pairSnd (Pair a b) = b
-- In this, we’ve used the pattern matching capabilities of Haskell to look
-- at a pair an extract values from it.

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++ end of YAHT +++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Non-strict functions are extremely useful in a variety of contexts. The main
-- advantage is that they free the programmer from many concerns about
-- evaluation order. Computationally expensive values may be passed as arguments
-- to functions without fear of them being computed if they are not needed. An
-- important example of this is a possibly infinite data structure.
-- 
-- Another way of explaining non-strict functions is that Haskell computes using
-- definitions rather than the assignments found in traditional languages. Read
-- a declaration such as 
v =  1/0                 
-- as `define v as 1/0' instead of `compute 1/0 and store the result in v'.Only
-- if the value (definition) of v is needed will the division by zero error
-- occur. By itself, this declaration does not imply any computation.Programming
-- using assignments requires careful attention to the ordering of the
-- assignments: the meaning of the program depends on the order in which the
-- assignments are executed. Definitions, in contrast, are much simpler: they
-- can be presented in any order without affecting the meaning of the program.

-- One advantage of the non-strict nature of Haskell is that data constructors
-- are non-strict, too. This should not be surprising, since constructors are
-- really just a special kind of function (the distinguishing feature being that
-- they can be used in pattern matching)

-- If we use a literal value in a pattern, the corresponding part of the value
-- that we’re matching against must contain an identical value. For instance,
-- the pattern (3:xs) first checks that a value is a nonempty list, by matching
-- against the (:) constructor. It also ensures that the head of the list has 
-- the exact value 3
-- 
-- If every pattern within a series of equations fails to match, we get a 
--                runtime error:
-- Pattern matching can either fail, succeed or diverge. A successful match
-- binds the formal parameters in the pattern. Divergence occurs when a value
-- needed by the pattern contains an error (_|_). The matching process itself
-- occurs "top-down, left-to-right." Failure of a pattern anywhere in one 
-- equation results in failure of the whole equation, and the next equation is
-- then tried. If all equations fail, the value of the function application is
-- _|_, and results in a run-time error.
--
-- a wild card acts similarly to a variable, but it doesn't bind a new variable

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++ -RWH- +++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
oddM n = mod n 2 == 1
oddM (3 + 2)  -- about lazy evaluation
-- In Haskell, the subexpression 1 + 2 is not reduced to the value 3 . Instead,
-- we create a “promise” that when the value of the expression isOdd (1 + 2) is
-- needed, we’ll be able to compute it. The record that we use to track an 
-- unevaluated expression is referred to as a thunk. This is all that happens:
-- we create a thunk and defer the actual evaluation until it’s really needed
-- [from me]
--  "promise" can be gueranty mostly by type-checking

-- Many languages need to treat the logical-or operator specially so that it
-- short-circuits if its left operand evaluates to True . In Haskell, (||)
-- is an ordinary function: nonstrict evaluation builds this capability into
-- the language
newOr a b = if a then a else b
-- If we write an expression such as newOr True (length [1..] > 0) , it will
-- not evaluate its second argument. (This is just as well: that expression
-- tries to compute the length of an infinite list. If it were evaluated, it
-- would hang ghci , looping infinitely until we killed it.)

-- When a function has type variables in its signature, indicating that some
-- of its arguments can be of any type, we call the function polymorphic.

-- when we see a parametrized type, code doesn't care what the actual type is
-- it has no way to find out what the real type is, or to manipulate a value
-- of that type. It can’t create a value; neither can it inspect one.
-- All it can do is treat it as a fully abstract “black box.
data BookInfo = Book Int String
:t BookInfo 
<interactive>:1:1: Not in scope: data constructor `BookInfo'
:t Book
Book :: Int -> String -> BookInfo

-- [from reddit]  about performance
-- http://www.reddit.com/r/haskell/comments/pewtc/what_do_haskellers_think_of_rust_its_got_lambdas/c3ox1fc

