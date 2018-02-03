module App where

sequnce :: [IO a] -> IO [a] -- due to ad-hoc polymorphism we can have controll
sequnce [] = return []    -- flow with diff side-effects(here IO, but if [exmp]
sequnce (x:xs) = x >>= \x' ->  -- it was Either it will be computation with
                     sequnce xs >>= \xs' ->   return (x':xs')  -- expecption )

ap :: Monad m => m (a -> b) -> m a -> m b
ap mf mx = mf >>= \f ->
               mx >>= \x ->  return (f x)

-- maybe it can be treated, as generalization(in SICP terms), like we define
_sequence_ []     = return []            -- sqrt in terms of approximate.func
_sequence_ (x:xs) = return (:) `ap` x `ap` _sequence_ xs


transpose :: [[a]] -> [[a]]        -- matrices
transpose [] = repeat []
transpose (xs:xss) = zipWith (:) xs (transpose xss)

zapp :: [a->b] -> [a] -> [b]
zapp (f:fs) (x:xs) = f x : zapp fs xs
zapp _      _      = []
-- The general scheme is as follows:
--    zipWith-n :: (a1 → ... → an → b) → [a1] → ... → [an] → [b]
--    zipWith-n f xs1 ... xsn = repeat f ‘zapp‘ xs1 ‘zapp‘ ... ‘zapp‘ xsn
-- so,
transpose_ [] = repeat []
transpose_ (xs:xss) = repeat (:) `zapp` xs `zapp` (transpose xss)
-- (may-16: zametil wo 9 otuchils9 maleha myslit' kak P.Graham zavew'al
-- (recursivno), a tobiw: `transpose_ xss` eto uzhe transponiranna9 matrica iz
-- ostatkov k kotoro my konnectim elems iz `xs`, vse legko(lol))
--
-- Mo9 versi9 may-2016(spust9 pol goda)
--
myTranspose_ [] = repeat []
myTranspose_ (xs:xss) = do
    (x', xs') <- (zip xs (myTranspose_ xss))
    return (x' : xs')
-- or even more primitive
anmyTranspose_ [] = repeat []
anmyTranspose_ (xs:xss) = map (\(x', xs') -> (x' : xs')) (zip xs (anmyTranspose_ xss))

-- (may-2016: kogda zapustil eto spust9 pol goda eto kakago to hera ne
-- kompilirovalos')
--
-- data Exp v = Var v | Val Int | Add (Exp v) (Exp v)
-- 
-- eval :: Exp v -> Env v -> Int
-- eval (Var x)    y = fetch x y
-- eval (Val i)    y = i
-- eval (Add p q)  y = eval p y + eval q y
-- ---or
-- eval (Var x) = fetch x
-- eval (Val i) = const i
-- eval (Add p q) = const (+) `s` eval p `s` eval q
--     where s :: (env -> a -> b) -> (env -> a) -> (env -> b)
--           s ef es y = (ef y) (es y)

