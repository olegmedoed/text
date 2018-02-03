module StateTest where

import Control.Monad.State 
import Data.Functor.Identity

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
type State s = StateT s Identity
type State s a = StateT s Identity a

newtype StateT s m a = StateT {runStateT :: s -> m (a, s)}

instance Monad m => Monad (StateT s m)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


------------------------   MY CODE              ----------------------------------
fromStoA :: Integral s => s -> Identity (Integer, s)
fromStoA n =
    if n `mod` 5 == 0
       then Identity (133, n + 1)
       else Identity (42, n + 2)

s = StateT fromStoA

ss = s >>= (\a -> modify (* 2))
------------------------   MY CODE              -----------------------------------


----------------------------------------------------------------------------------
---------------------------------------------------------------------------------
return a = StateT $ \ s -> return (a, s)

state1 >>= fn =
    StateT $ \s -> do
        let (a', s') = runState state1 s
         in runState (fn a') s'
--      ~(a', s') <- runStateT state1 s
--      runStateT (fn a') s'

(>>=) :: State s a  ->  (a -> State s b)  ->  State s b
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- return the state value being passed around:
get :: State s s
get = State $ \s -> (s,s)

-- replace the current state value with 's':
put :: s -> State s ()
put s = State $ \_ -> ((), s)

modify :: (Monad m) => (s -> s) -> StateT s m ()
modify f = State $ \ s -> ((), f s)
