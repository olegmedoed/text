{-# LANGUAGE ScopedTypeVariables #-}

-- type State s a = s -> (a, s)

divBy :: Integral a => a -> [a] -> [Maybe a]
divBy _ [] = []
divBy a (0:xs) = Nothing : divBy a xs
divBy a (x:xs) = Just (div a x) : divBy a xs

makeList 0 = []
makeList n = n : makeList (n-1)

fuck :: Num a => a -> a -> (a->a)
fuck a b c = (\x -> x + a + b) (c*2) -- let x = fuck 3 4; x 5 ==> 17 


data MyMaybe a = MyJust a | MyNothing
    deriving (Show)

instance Functor MyMaybe where
    fmap _ MyNothing = MyNothing
    fmap f (MyJust x) = MyJust (f x)

instance Applicative MyMaybe where
    pure = MyJust

    MyJust f  <*> m = fmap f m
    MyNothing <*> _ = MyNothing


mfoldr :: (a -> b -> b) -> b -> [a] -> b
mfoldr _ z [] = z
mfoldr k z (y:ys) = y `k` mfoldr k z ys

mmapM :: forall m a b. Monad m => (a -> m b) -> [a] -> m [b]
mmapM f as = foldr k (return []) as
    where
        k :: a -> m [b] -> m [b]
        k a r = do { x <- f a; xs <- r; return (x:xs) }
