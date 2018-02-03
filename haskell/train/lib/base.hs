{-# LANGUAGE ScopedTypeVariables #-}

module MyBase where

flip f a b = f b a

class Monoid a where
    mempty :: a
    mappend :: a -> a -> a

    mconcat :: [a] -> a -- fold a list using monoid
    mconcat = foldr mappend mempty

instance Monoid [a] where
    mempty = []
    mappend = (++)
    mconcat xss = [x | xs <- xss, x <- xs]

instance Monoid b => Monoid (a -> b) where
    mempty _ = mempty
    mappend f g x = f x `mappend` g x

instance Monoid a => Monoid (Maybe a) where
    mempty = Nothing
    mappend Nothing   m         = m
    mappend m         Nothing   = m
    mappend (Just m1) (Just m2) = Just (mappend m1 m2)

instance Monoid a => Applicative ((,) a) where
    .......

instance Monoid a => Monad ((,) a) where
    .......

instance Monoid a => Monoid (IO a) where
    mempty = pure mempty
    mappend = liftA2 mappend

--------------------------------- Functor, Applicative

class Functor f where
    fmap :: (a -> b) -> f a -> f b

    (<$) :: a -> f b -> f a
    (<$) = fmap . const

class Functor f => Applicative f where
    pure  :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b -- seq app-tion

    (*>) :: f a -> f b -> f b -- seq app discarding the val of 1st arg
    a1 *> a2 = (id <$ a1) <*> a2

    (<*) :: f a -> f b -> f a -- seq app discarding the val of 1st arg
    (<*) = liftA2 const

<**> :: Applicative f => f a -> f (a -> b) -> f b -- flipped(arg reversed) <*>
<**> = liftA2 (flip ($))

liftA :: Applicative f => (a -> b) -> f a -> f b
liftA f a = pure f <*> a  -- or liftA = fmap

liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
liftA2 f a b = f <$> a <*> b

liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
liftA3 f a b c  = f <$> a <*> b <*> c

---------------------------------- Monad

join :: Monad m => m (m a) -> m a
join x = x >>= id

class Applicative m => Monad m where
    return :: a -> m a
    return = pure

    (>>=) :: m a -> (a -> m b) -> m b

    (>>) :: m a -> m b -> m b
    m >> k = m >> \_ -> k -- or (>> = *>) but it's cause bag in some cases

    fail  :: String -> m a  -- will be moved to MonadFail in future
    fail s = error s


(=<<) :: Monad m => (a -> m b) -> m a -> m b
f =<< x = x >>= f

sequence :: Monad m => [m a] -> m [a]
sequence = mapM id

mapM :: forall m a b. Monad m => (a -> m b) -> [a] -> m [b]
mapM f as = foldr k (return []) as
    where  -- when we use `forall` then here `a`,`m`,`b` is the same types as
        k :: a -> m [b] -> m [b]  -- in mapM declaration
        k a r = do { x <- f a; xs <- r; return (x:xs) }

-- AFAIU the same as fmap
liftM :: (Monad m) => (a1 -> r) -> m a1 -> m r
liftM f m1 = do { x1 <- m1; return (f x1) }

liftM2 :: (Monad m) => (a -> b -> c) -> m a -> m b -> m c
liftM2 f m1 m2 = do { x1 <- m1; x2 <- m2; return (f m1 m2) }

ap :: (Monad m) => m (a -> b) -> m a -> m b
ap fm am = do {f <- fm; a <- m a; return (f a) }

------------------------------------------ Alternative

infix 3 <|>
-- monoid on applicative functors
-- * some v = (:) '<$>' v '<*>' many v
-- * many v = some v '<|>' 'pure' []
class Applicative f => Alternative f where
    empty :: f a                -- the identity of <|>
    (<|>) :: f a -> f a -> f a  -- an associative binary operation

    some :: f a -> f [a]  -- one or more
    some v = some_v
        where many_v = some_v <|> pure []
              some_v = (fmap (:) v) <*> many_v

    many :: f a -> f [a]  -- zero or more
    many v = many_v
        where many_v = some_v <|> pure []
              some_v = (fmap (:) v) <*> many_v




---------------------------------------------

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ z [] = z
foldr k z (y:ys) = y `k` foldr k z ys
-- foldr k z = go           -- original
--     where go [] = z
--           go (y:ys) = y `k` go ys


build :: forall a. (forall b. (a -> b -> b) -> b -> b) -> [a]


------------------------------------- Maybe
instance Functor Maybe where
    fmap _ Nothing = Nothing
    fmap f (Just x) = Just (f x)

instance Applicative Maybe where
    pure = Just

    Just f  <*> m = fmap f m
    Nothing <*> _ = Nothing

instance Monad Maybe where
    (Just x) >>= k  = Just (k x)
    Nothing  >>= _  = Nothing

    (>>)    = (*>)
    fail _  = Nothing

instance Alternative Maybe where
    empty = Nothing

    Nothing <|> r = r
    l       <|> _ = l


-------------------------------------- List
instance Functor [] where
    fmap = map

instance Applicative [] where
    pure x      = [x]
    fs <*> xs   = [f x | f <- fs, x <- xs]
    xs  *> ys   = [y | _ <- xs, y <- ys]

instance Monad [] where
    xs >>= f  = [y | x <- xs, y <- f x]
    (>>)      = (*>)
    fail _    = []

instance Alternative [] where
    empty = []
    (<|>) = (++)

-------------------------------------- Either
data Either a b = Left a | Right b

instance Functor (Either a) where
    fmap _ (Left x)   = Left x
    fmap f (Right y)  = Right (f y)

instance Applicative (Either a) where
    pure = Right
    Left  e <*> _ = Left e
    Right f <*> r = fmap f r

instance Monad (Either a) where
    Left  l >>= _ = Left l
    Right l >>= r = r l

either :: (a -> c) -> (b -> c) -> Either a b -> c
either f _ (Left x)   = f x
either _ g (Right y)  = g y

--------------------------------------
