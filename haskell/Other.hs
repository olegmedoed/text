module Other where

data Cartesian = Crt Double Double
            deriving (Eq, Show)
-- Notice that in the deriving clause for our vector types, we added another
-- word, Eq . This causes the Haskell implementation to generate code that
-- lets us compare the values for equality.

data ListM a = Cons a (ListM a)
             | NilM
             deriving (Show)

data TreeM a = LeafM
             | NodeM a (TreeM a) (TreeM a)
             deriving (Show)

data TreeMyb a = NodeMyb  a (Maybe (TreeMyb a)) 
                                   (Maybe (TreeMyb a))
                 deriving (Show)

-- The two types(this and []) are isomorphic—they have the same shape
fromList (x:xs) = Cons x (fromList xs) -- convert [] to ListM
fromList [] = NilM

toList (Cons a b) = a : toList b
toList NilM = []
-- class Tree<A>
-- {
--   A value;  Tree<A> left;   Tree<A> right;
-- 
--   public Tree(A v, Tree<A> l, Tree<A> r)
--   { value = v;  left = l;   right = r;   }
-- }
-- The one significant difference is that Java lets us use the special value
-- 'null' anywhere to indicate "nothing," so we can use null to indicate that 
-- a node is missing a left or right child
-- In Haskell, we don’t have an equivalent of null . We could use the Maybe 
-- type to provide a similar effect, but that would bloat the pattern matching.
-- Instead, we’ve decided to use a no-argument LeafM constructor.
simpleTree = NodeM "parent" (NodeM "left child" LeafM LeafM)
                            (NodeM "right child" LeafM LeafM)

errorComprisedFunc n = if n == 2 then error "bad number" else n
-- > :t errorComprisedFunc 
-- > errorComprisedFunc :: (Eq a, Num a) => a -> a
-- It has a result type of a so that we can call it anywhere and it will always
-- have the right type. However, it does not return a value like a normal 
-- function. Instead, it immediately aborts evaluation and prints the error
-- message we give it.
errorList lst = if null (tail lst) then error "fuck" else head (tail lst)
-- > :t errorList             >>  errorList :: [a] -> a]
-- > errorList [1]            >>  *** Exception: fuck
-- > head (errorList [[8]])   >> *** Exception: fuck
-- Notice the 2 case, where we try to use the result of the call to mySecond
-- as the argument to another function. Evaluation still terminates and drops us
-- back to the ghci prompt. This is the major weakness of using error : it 
-- doesn't let our caller distinguish between a recoverable error and a problem
-- so severe that it really should terminate our program
-- > errorList []  -- *** Exception: Prelude.tail: empty list
-- As we have already seen, a pattern matching failure causes a similar 
-- unrecoverable error:

-- We can use the Maybe type to represent the possibility of an error.
-- If we want to indicate that an operation has failed, we can use the Nothing
-- constructor.  Otherwise, we wrap our value with the Just constructor.
safeErrorList :: [a] -> Maybe a
safeErrorList [] = Nothing
safeErrorList xs = if null (tail xs) then Nothing
                                     else Just (head (tail xs))
-- best variant
bestSafeErrorList [_:xs:_] = Just xs
bestSafeErrorList [] = Nothing  -- or bestS..st _ = Nothing

-- local variable
lendM amount balance =
    let reserve = 100
        newBalance = balance - amount in

    if balance < reserve
        then Nothing
        else Just newBalance
-- Let us reemphasize our wording: a name in a let block is bound to an
-- expression, not to a value. Because Haskell is a lazy language, the ex-
-- pression associated with a name won’t actually be evaluated until it’s
-- needed. In the previous example, we could not compute the value of
-- newBalance if we did not meet our reserve.

-- > let x = case [1,2] of { (x:xs) -> x; _ -> 3}
-- x :: Integer     -- since Haskell is lazy x just "point out" to expres.
-- > x     >>  1    -- but not comput untill it necessary

quuxM a = let a = "foo" in a ++ "bar" -- quuxM :: t -> [Char]
-- Because the func's arg a is never used in the body of the func, due to being
-- shadowed by the 'let'-bound a , the argument can have any type at all

lend2M amount balance = if balance < reserve * 0.5
                        then Nothing                -- this fun not working
                        else Just newBalance
     where reserve    = 100
           newBalance = balance - amount

pluralizeM :: String -> [Int] -> [String]
pluralizeM word counts = map plural counts
  where plural 0 = "no " ++ word ++ "s"
        plural 1 = "one " ++ word
        plural n = show n ++ " " ++ word ++ "s"

-- > bad_nodesAreTheSame (NodeM a _ _) (NodeM a _ _) = Just a
-- > bad_nodesAreTheSame _             _             = Nothing
--    A name can appear only once in a set of pattern bindings. We cannot place
-- a variable in multiple positions to express the notion "this value and that
-- should be identical". Instead, we'll solve this problem using guards

nodeAreTheSame (NodeM a _ _) (NodeM b _ _)
                    | a == b  = Just a
nodeAreTheSame _ _            = Nothing

-- A pattern can be followed by zero or more guards, each an expression of 
-- type Bool. A guard is introduced by a | symbol. This is followed by the
-- guard expression, then an = symbol (or -> if we’re in a case expression),
-- then the body to use if the guard expression evaluates to True . If a pattern
-- matches, each guard associated with that pattern is evaluated in the order in
-- which they are written. If a guard succeeds, the body affiliated with it is 
-- used as the result of the function. If no guard succeeds, pattern matching
-- moves on to the next pattern.
--
-- When a guard expression is evaluated, all of the variables mentioned in the
-- pattern with which it is associated are bound and can be used.
lend3 amount balance
    | amount <= 0               = Nothing
    | amount > (reserve * 0.5)  = Nothing           -- not working
    | otherwise                 = Just newBalance
  where reserve     = 100
        newBalance  = balance - amount

niceMyDrop n xs | n <= 0  = xs
niceMyDrop _ []           = []
niceMyDrop n (_:xs)       = niceMyDrop (n-1) xs

-- The special-looking guard expression "otherwise" is simply a variable bound
-- to the value True that aids readability.

-- exercises
palindrome []     ac = ac
palindrome (x:xs) ac = x : palindrome xs (x:ac) -- recursive step: 
-- palindrome of abc = a : (plindrom bc) : a

reverseList (x:xs) ac = reverseList xs (x:ac)
reverseList [] ac     = ac

eqlList (a:as) (x:xs) = a == x && eqlList as xs
eqlList []      []    = True
eqlList _       _     = False

isPalindrome []              = True
isPalindrome (x:[])          = True
isPalindrome lst@(x:xs)      = eqlList lst reversL
               where reversL = reverseList lst []

-- merge sort
sortList [] = []
sortList [n] = [n]
sortList lst =
  let lng   = length lst
   -- mid   = ceiling (fromIntegral lng / 2)   -- from RealFrac to Integeral
      mid   = lng `quot` 2
      lLst  = sortList (take mid lst)
      rLst  = sortList (drop mid lst) in
      merge lLst rLst
  where
      merge (r:rs) (l:ls)
        | length r > length l     = r : merge rs (l:ls)
        | length r < length l     = l : merge (r:rs) ls
        | otherwise = l : merge (r:rs) ls 
      merge []      xs            = xs
      merge xs      []            = xs

treeHeigh :: (TreeM a) -> Int
treeHeigh LeafM = 1 :: Int
treeHeigh (NodeM _ a b) =
  let aHeigh = treeHeigh a
      bHeigh = treeHeigh b
   in if aHeigh > bHeigh
      then 1 + aHeigh
      else 1 + bHeigh
