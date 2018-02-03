module Main where

frac x  | x == '#'  = "# #"
        | otherwise = "   "

_liftM :: (Monad m) => (a -> b) -> (m a) -> (m b)
_liftM f xs = xs >>= (return . f)

_join :: (Monad m) => m (m a) -> m a
_join xss = xss >>= id

_put :: IO ()
_put = putStrLn "Hello, man"

newtype Fuck a = Fuck a

-- patIO :: IO 
-- patIO (GHC.Types.IO ()) = 1
-- patIO _       = 2

retList :: a -> [a]
retList a = return a >>= return >>= return >>= return

type Person = String
parents :: Person -> [Person]
parents "Oleg Tsyba"  = ["Lydia Tsyba", "Vit9 Tsyba"]
parents "Lydia Tsyba" = ["Dus9 Stol9rova", "Sasha Stol9rov"]
parents "Vit9 Tsyba"  = ["Vera Tsyba", "Ivan Tsyba"]
-- (parents <=< parents) "Oleg Tsyba"

-- data Pipe a b r
--     = Pure r
--     | Await (a -> Pipe a b r)
--     | Yield b (Pipe a b r)
-- 
-- Pure r <-< _ = Pure r
-- Yield b p1 <-< p2 = Yiled b (p1 <-< p2)
-- Await f <-< 

_map :: (Monad m) => (a -> b) -> (a -> m b)
_map f = return . f


data MEither t e = MVal t
                 | MError e

instance Functor (MEither t) where
    fmap _ (MError x) = return x
    fmap f (MVal x) _ = return . f $ x
