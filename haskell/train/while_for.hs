module Main where

import GHC.Base (when)

main = putStrLn "hello, world"

while :: (Monad m) => m Bool -> m a -> m ()
while cond action = do
    c <- cond
    when c $ do
        action
        while cond action
-- while cond action =
--     cond >>= \c -> when c (action >> while cond action >> return ())

for :: Monad m => m a -> m Bool -> m b -> m c -> m ()
for init cond post action = do
    init
    while cond $ do
        action
        post
-- for init cond post action =
--     init >> while cond (action >> post >> return ())

-- data Status = Status { _i :: Int, _result :: Double }
-- 
-- class Default a where def :: a
-- 
-- instance Default Int    where def = 0
-- instance Default Double where def = 0.0
-- instance Default Status where def = Status def def
-- 
-- 
