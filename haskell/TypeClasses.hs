----------------------------------------------------
-- Too many parameters for class ‘Fuck’
--    (Use MultiParamTypeClasses to allow multi-parameter classes)
--    In the class declaration for ‘Fuck’
class Fuck a b where
  isFuck :: a -> b -> Int
instance Fuck [Char] Int  where
  isFuck a b = b
----------------------------------------------------
--    Multiple declarations of ‘fuck’
module TypeClass where

class One a where
  fuck :: a -> a

instance One Int where
  fuck a = a + 1

class Two a where
  fuck :: a -> a

instance One Int where
  fuck a =  a + 2
----------------------------------------------------

-- Typeclasses are among the most powerful features in Haskell. They allow us
-- to define generic interfaces that provide a common feature set over a wide
-- variety of types.
--
-- Typeclasses define a set of functions that can have different implementations
-- depending on the type of data they are given. Typeclasses may look like the
-- objects of objectoriented programming, but they are truly quite different.
class BasicEq a where
  isEqual :: a -> a -> Bool
-- This says that we are declaring a typeclass named BasicEq , and we’ll refer
-- to instance types with the letter a . An instance type of this typeclass is
-- any type that implements the functions defined in the typeclass

-- The keyword to define a typeclass in Haskell is class . Unfortunately,
-- this may be confusing for those of you coming from an object-oriented
-- background, as we are not really defining the same thing.

-- On the first line, the name of the parameter a was chosen arbitrarily - we
-- could have used any name. The key is that, when you list the types of your
-- functions, you must use that name to refer to instance types.

-- *Main> :t isEqual 
-- isEqual :: BasicEq a => a -> a -> Bool
-- You can read that this way: "For all types a , so long as a is an instance
-- of BasicEq , isEqual takes two parameters of type a and returns a Bool ."

-- defining isEqual for a particular type
instance BasicEq Bool where
  isEqual True  True  = True
  isEqual False False = True
  isEqual _     _     = False
-- *Main> isEqual "Hi" "Hi"
-- <interactive>:21:1:
--    No instance for (BasicEq [Char]) arising from a use of `isEqual'
--        Possible fix: add an instance declaration for (BasicEq [Char])

-- Rather than making users of the typeclass define both functions for all
-- types, we can provide default implementations for them. Then, users will only
-- have to implement one function
class BasicEq2 a where
  isEqual2 :: a -> a -> Bool
  isEqual2 x y = not (isNotEqual2 x y)

  isNotEqual2 :: a -> a -> Bool
  isNotEqual2 x y = not (isEqual2 x y)
-- People implementing this class must provide an implementation of at least
-- one function. They can implement both if they wish, but they will not be
-- required to. While we did provide defaults for both functions, each function
-- depends on the presence of the other to calculate an answer. If we don't
-- specify at least one, the resulting code would be an endless loop. Therefore,
-- at least one function must always be implemented.
--    We could have provided a default for only one function, which would
-- force users to implement the other every time.

-- code from Haskell98 report, it similar to our BasicEq
--    class Eq a where
--      (==), (/=) :: a -> a -> Bool
--      -- Minimal complete definition: (==) or (/=)
--      x /= y    = not (x == y)
--      x == y    = not (x /= y)

data Color = Red | Green | Blue
-- types are made instances of a particular typeclass by implementing the
-- functions necessary for that typeclass.
instance BasicEq2 Color where
  isEqual2 Red    Red   = True
  isEqual2 Blue   Blue  = True
  isEqual2 Green  Green = True
  isEqual2 _      _     = False
-- Note also that the BasicEq3 class defined both isEqual2 and isNotEqual2,
-- but we implemented only one of them in the Color instance.

-- This example defines an instance of Show for our type Color
instance Show Color where
  show Red    = "Red"
  show Blue   = "Blue"
  show Green  = "Green"

-- Show is usually used to define a String representation for data that is
-- useful for a machine to parse back with Read . Haskell programmers
-- generally write custom functions to format data attractively for end
-- users, if this representation would be different than expected via Show.

-- [exmp] how to use Read and Show.
main = do
    putStrLn "Please enter a Double:"
    inpStr <- getLine
    let inpDouble = (read inpStr) :: Double
    putStrLn ("Twice " ++ show inpDouble ++ " is " ++ show (inpDouble * 2))
-- This is a simple example of read and show together. Notice that we gave an
-- explicit type of Double when processing the read. That's because read returns
-- a value of type Read a => a , and show expects a value of type Show a => a.
-- There are many types that have instances defined for both Read and Show.
-- Without knowing a specific type, the compiler must guess from these many
-- types which one is needed. In situations such as this, it may often choose
-- Integer. If we want to accept floating-point input, this wouldn't work,
-- so we provide an explicit type.
-- In most cases, if the explicit Double type annotation were omitted, the
-- compiler would refuse to guess a common type and simply give an error.
-- The fact that it could default to Integer here is a special case arising
-- from the fact that the literal 2 is treated as an Integer unless a different
-- type is expected for it

-- ghci uses show internally to display results, meaning that you can encounter
-- this ambiguous typing problem there as well. You’ll need to explicitly give
-- types for your read results
--    *Main> read "4"
--        No instance for (Read a0) arising from a use of `read'
--            The type variable `a0' is ambiguous

-- type of read : (Read a) => String -> a .)
-- (read "3.0") :: Double   >>> good
-- (read "3.0") :: Int      >>> *** Exception: Prelude.read: no parse
-- Notice the error when trying to parse 5.0 as an Integer. The interpreter
-- selects a different instance of Read when the return value was expected to
-- be Integer than it did when a Double was expected. The Integer parser
-- doesn't accept decimal points and caused an exception to be raised.

-- The Read class provides for some fairly complicated parsers. You can define
-- a simple parser by providing an implementation for the readsPrec function.
-- Your implementation can return a list containing exactly one tuple on a 
-- successful parse, or it can return an empty list on an unsuccessful parse.
instance Read Color where
  -- readsPrec is the main func for parsing input
  readsPrec _ val =
    -- We pass tryParse a list of pairs. Each pair has a string and the desired
    -- return val. tryParse will try to match the input to one of these strings
    tryParse [("Red", Red), ("Blue", Blue), ("Green", Green)]
      where tryParse [] = []
            tryParse ((attempt, result) : xs) =
              let lng = length attempt in
              -- Compare the start of the string to be parsed to the
              -- text we are looking for.
              if (take lng val) == attempt
                 then [(result, drop lng val)]
                 else tryParse xs
-- *Main> (read "Green")::Color                 >>  Green
-- *Main> (read "[Green,Red,Blue]")::[Color]    >>  [Green,Red,Blue]

-- Anything that is an instance of Ord can be sorted by Data.List.sort .
--            ...........
--            ...........
--            ...........
--            ...........
