-- import Data.Char (digitToInt isSpace isUpper)
import System.Environment (getArgs)
import Data.List
import Data.Char
import Data.Bits

interactWith func inputFile outputFile = do
  -- Both readFile and writeFile operate in text mode(about text mode p74)
  input <- readFile inputFile
  writeFile outputFile (func input)

  readFile inputFile (\input ->
    writeFile outputFile (func input))

main = mainWith myFunc
  where mainWith func = do
          args <- (getArgs)
          case args of
            [input, output] -> interactWith func input output
            _ -> putStrLn "error: exactly two arguments need"
        -- replace 'id' with fuction what you need
        myFunc = printFirstWordOnAllLines

printFirstWordOnAllLines str = -- print only first word in file
  let lns   = splitLines str
      wrds  = map (getWord (\x -> x == ' ')) lns
   in concat wrds


------------  The style of creating and reusing small, powerful pieces of code
-- Purity --  is a fundamental part of functional programming.
--------------------------------------------------------------

splitLines [] = []
splitLines cs =
  let (pre, suf) = break isLineTerminator cs
   in pre : case suf of
              ('\r':'\n':rest) -> splitLines rest
              ('\r':rest)      -> splitLines rest
              ('\n':rest)      -> splitLines rest
              _                -> []

isLineTerminator cs =   cs == '\r' || cs == '\n'

-- [from me]
-- type constructor what reveice type variables is called abstract data type
-- since it becomes concrete type only when receive concret another type
data a `Pair` b = a `Pair` b
                  deriving (Show)
-- infix notation is purely a syntactic convenience, it does not change a 
-- function’s behavior
-- The only legal thing we can do with backticks in Haskell is wrap them
-- around the name of a function. We can’t, for example, use them to
-- enclose a complex expression whose value is a function.

-- The Data.List module is the "real" logical home of all standard list 
-- functions. The Prelude merely re-exports a large subset of the functions 
-- exported by Data.List

-- when check empty list don't use 'length', use 'null'

-- Functions that have only return values defined for a subset of valid inputs 
-- are called partial functions (calling error doesn’t qualify as returning a 
-- value!). We call functions that return valid results over their entire input
-- domains total functions.
-- t’s always a good idea to know whether a function you’re using is partial 
-- or total.  Calling a partial function with an input that it can’t handle 
-- is probably the single biggest source of straightforward, avoidable bugs in 
-- Haskell programs.
-- Some Haskell programmers go so far as to give partial functions names that 
-- begin with a prefix such as "unsafe" so that they can't shoot themselves in 
-- the foot accidentally.   [exmp] head - is partial
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x

-- [[1,2], 3, [4,[5,6]]] -> [1,2,3,[4,5,6]] => expand most inserted list
--downLevel :: [a] -> [b]
--downLevel lst =             --- not working
--  case lst of
--    []      -> []
--    ([]:xs) -> downLevel xs
--    (x@(l:ls): xs) -> if isFlat x
--                  then x ++ downLevel xs
--                  else downLevel x ++ downLevel xs
--  where isFlat ((l:ls):xs) = True
--        isFlat  _          = False

splitWith p lst =
  let getWord p (x:xs) =
        if p x
           then ([], xs)
           else let (w,l) = getWord p (xs)
                 in ((x:w), l)
      getWord p []      = ([], [])
  in
    let (word,rest) = getWord p lst
     in case rest of
          []     -> [word]
          (x:xs) -> word : splitWith p rest


getWord p (x:xs) =
  if p x
     then []
     else let w = getWord p (xs)
           in x:w
getWord p []      = []


asInt :: String -> Int
loop  :: Int -> String -> Int
asInt cs = loop 0 cs
-- Passing '0' into it is equivalent to initializing the acc variable in C at
-- the beginning of the loop.(since we pass state, rather than to change)
--
-- Our familiar String is just a synonym for [Char] , a list of characters.
-- The easiest way for us to get the traversal right is to think about the
-- structure of a list: it’s either empty or a single element followed by the 
-- rest of the list.  We can express this structural thinking directly by 
-- pattern matching on the list type's constructors. It's often handy to think
-- about the easy cases first
loop acc [] = acc
loop acc (x:xs) = let acc' = acc * 10 + digitToInt x
                   in loop acc' xs
-- asInt is partial, since don't cover all Char values what happened in String
-- Thinking about the structure of the list, and handling the empty and nonempty
-- cases separately, is a kind of approach called "structural recursion".

wikiMap f = foldr ((:) . f) [] -- map in terms of foldr(from wiki "fold")

-- in Java analog we first of all perform cycle(what is anolog of **), and after
-- make base step, in Haskell both of this steps has shown more clearly
base = 65521 :: Int
addlerM xs = helper (1,0) xs
  where helper (a,b) (x:xs) =                     -- **
          let a' = (a + (x .&. 0xff)) `mod` base
              b' = (a' + b) `mod` base
           in helper (a', b') xs
        helper (a,b) _ = (b `shiftL` 16) .|. a    -- ***
-- Here we use tuple for arguments because as we’ve already seen with map 
-- and filter , we can extract the common behavior shared by mySum and 
-- adlerM into a higher-order function. We can describe this behavior as
-- "do something to every element of a list, updating an accumulator as we go,
-- and returning the accumulator when we’re done."
-- This kind of function is called a fold, because it “folds up” a list.

foldlM :: (b -> a -> b) -> b -> [a] -> b
foldlM step zero (x:xs) = foldlM step (step zero x) xs
foldlM _    zero []     = zero
-- [1,2,3] => (step (step (step (step ac 1) 2) 3) 0) => (((ac + 1) + 2) + 2)
-- so 
addlerF xs = let (a,b) = foldl step (1,0) xs -- cycle
              in (b `shiftL` 16) .|. a       -- base
  where step (a,b) x = let a' = a + (x .&. 0xff)
                        in (a' `mod` base, (a' + b) `mod` base)

foldrM :: (a -> b -> b) -> b -> [a] -> b
foldrM step zero (x:xs) = step x ( foldrM step zero xs)
foldrM _    zero _      = zero
-- [1,2,3] => (step 1 (step 2 (step 3 0)))) => (1 + (2 + (3 + 0)))

filterM :: (a -> Bool) -> [a] -> [a]
filterM p [] = []
filterM p (x:xs)
  | p x         = x : filterM p xs
  | otherwise   = filterM p xs
-- with foldr
filterF p xs = foldr step [] xs-- when xs=[] foldr just return [], for others..
  where step x ys   | p x         = x : ys -- < ys is list to which step was
                    | otherwise   = ys    -- already applyad
--
-- another useful way to think about what foldr does is that it transforms its
-- input list. Its first two arguments are "what to do with each head/tail
-- element of the list," and "what to substitute for the end of the list".
--
-- The class of functions that we can express using foldr is called primitive
-- recursive. A surprisingly large number of list manipulation functions are 
-- primitive recursive:
-- [exmp]  'map' by using 'foldr'
mapFldr :: (a -> b) -> [a] -> [b]
mapFldr f xs = foldr step [] xs
  where step x ys = f x : ys
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
foldlFldr f zero xs = foldr step id xs zero -- foldl by using foldr
  where step x g a = g (f a x)              -- p95
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

identity :: [a] -> [a]
identity xs = foldr (:) [] xs
appendLst :: [a] -> [a] -> [a]
appendLst xs ys = foldr (:) ys xs
-- foldr can consume and produce a list incrementally, which makes it useful for
-- writing lazy data-processing code.


-- We introduce an anonymous function with a backslash character ( \ ) 
-- pronounced lambda. This is followed by the function’s arguments (which can
-- include patterns), and then an arrow ( ->) to introduce the function’s body.
-- they are often invaluable as "glue."

-- Whe "currying" useful?
-- we can use "currying" as an argument to a higher order function:
-- map (dropWhile isSpace) [" a", "f", "   e"]  -- >> ["a", "f", "e"]
--
-- When we pass fewer arguments to a function than the function can accept, we
-- call it "partial application" of the function.  Partial function application
-- lets us avoid writing tiresome throwaway functions.
isInAny needle haystack = any (isInfixOf needle) haystack
-- instead of 1, we can use carrying and write:
niceSum xs = foldl (+) 0 xs
nicerSum = foldl (+) 0

-- map (+ 2) [list..]  << it's calles "section"
-- (`elem` "fuck") 'f' << let's apply `elem` only to second arg
-- all (`elem` "fuck") "abcdefg"  << check all letter

suffixes xs@(x:xs') = xs : suffixes xs'
noAsPattern (x:xs)  = (x:xs) : noAsPattern xs
-- As-patterns have a more practical use than simple readability: they can help
-- us to share data instead of copying it. In our definition of noAsPattern ,
-- when we match (x:xs) , we construct a new copy of it in the body of our 
-- function. This causes us to allocate a new list node at runtime. That may be
-- cheap, but it isn't free. In contrast, when we defined suffixes , we reused
-- the value xs that we matched with our as-pattern. Since we reuse an existing
-- value, we avoid a little allocation.

-- "Fuck the Police" => 2
capCount = length . filter (isUpper .head) . words
-- [from me] it's also similar to Unix-style programming, but here funcs play
-- role of programs on C. Do on thing, and do it well , and combine this
-- ideal instruments(funcs/programs[Unix-C])

-- #define DLT_name1 somemacrodef .....
-- #define DLT_name2 ...    -- our goal is to extract names
defNames = foldr step [] . lines
  where step l ds
          | "#define DLT_" `isPrefixOf` l  = secondWord l : ds
          | otherwise                  = ds
        secondWord = head . tail . words
-- here we are calling both head and tail , two of those unsafe list functions.
-- What gives?
-- In this case, we can assure ourselves by inspection that we're safe from a 
-- runtime failure.  The pattern guard in the definition of step contains two 
-- words, so when we apply words to any string that makes it past the guard,
-- we'll have a list of at least two elements: "#define" and some macro 
-- beginning with "DLT_".
-- Don't forget our earlier admonition: calling unsafe functions such as this
-- requires care and can often make our code more fragile in subtle ways. If for
-- some reason we modified the pattern guard to only contain one word, we could
-- expose ourselves to the possibility of a crash, as the body of the function
-- assumes that it will receive two words.


-- Left Folds, Laziness, and Space Leaks   p96      -- REREAD
-- !!! Tips for writing readable code !!! p107      -- REREAD
-- !!! Space Leaks and Strict Evaluation !!! p108   -- REREAD
-- Why the Fuss over Purity? p39_RWHaskell          -- REREAD

