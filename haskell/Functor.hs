-- instance Functor (Either e) where
--   fmap g (Right x) = Right (g x)
--   fmap g (Left x) = Left x
-- 
-- instance Functor ((,) a) where
--   fmap f (x,y) = (x, f y)

---------------- Applicative Functors ---------------------------

newtype ZipList a = ZipList { getZipList :: [a] }

instance Applicative ZipList where
  pure = undefined
  (ZipList gs) <*> (ZipList xs) = ZipList (zipWith ($) gs xs)

instance Applicative [] where
  pure x = [x]
  gs <*> xs = [g x | g <- gs, x <- xs]

id <*> v = v
pure f <*> pure x = pure (f x)
u <*> pure y = pure ($ y) <*> u
u <*> (v <*> w) = pure (.) <*> u <*> v <*> w

------------------------ nov-15 --------------------------------
data ITree a = Leaf (Int -> a) | TrNode [ITree a]

data List a = Endl | LNode a (List a)
            deriving (Show)

-- (fmap f) is like transformation `row` to `corresponding row` in another 
-- category to which functor map current category
instance Functor ITree where
    fmap f (Leaf g) = Leaf (f . g)
    fmap f (TrNode t) = TrNode (fmap (fmap f) t)

-- the following code is a "valid" instance of Functor (it typechecks), but it
-- violates the functor laws. Do you see why?
-- I think that since it change the structure of "container"(computational 
-- context) and functor should not do it
-- any Functor instance satisfying the first law (fmap id = id) will
-- automatically satisfy the second law as well(since don't change the structure
-- of "container").
instance Functor List where
    fmap _ Endl = Endl
    fmap f (LNode e es) = LNode (f e) (LNode (f e) (fmap f es)) 
-- (a -> b) -> (f a -> f b). Written in this form, it is apparent that fmap 
-- transforms a "normal" function (g :: a -> b) into one which operates over 
-- containers/contexts (fmap g :: f a -> f b). [from me: as math.functor 
-- transform `rows` in one category to corresponding `rows` in another]


----------------------------- 09-nov-15 ----------------------------
-- cathegory `Grp` (Set of Nats, operation(morphism) = *, id.el = 1)
-- in Hskl I would write `id.el` as (1 *), so * in Grp is like func.application
-- in Hskl, and in morphism 2*3=6, 2 is like type (*3) is like func and 6 is like 
-- result.
-- if 2 (*3) 6 and 6 (*2) 12 , then 2 ((*3) . (*2)) 12



