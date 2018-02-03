module Test0 where

import Control.Monad.Identity
import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State
import Control.Monad.State.Lazy
import Data.Maybe

-- onList xs = xs >>= (\x -> x >>= \y -> return $ x + y)
-- onList :: Num(a) => [[a]] -> [a]
-- onList xs = do
--     x <- xs
--     y <- x
--     return $ y * y

e       = ExceptT [Right 3, Right 8, Left "FUCK"]
efake   = ExceptT Nothing

res = do x <- efake
         return $ makeStr x
    where
        makeStr x = if x < 1 then []
                             else 'x': makeStr (x - 1)
