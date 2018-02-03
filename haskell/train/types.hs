module Types where

-- {-# LANGUAGE ScopedTypeVariables #-}
-- mkpair1 :: forall a b. a -> b -> (a,b)
-- mkpair1 a b = (ida a, b)
--     where ida :: a -> a -- `a` refers to `a` in the mkpair1 type signature
--           ida = id
-- 
-- mkpair2 :: forall a b. a -> b -> (a, b)
-- mkpair2 a b = (ida a, b)
--     where ida :: b -> b -- illegal, since refers to `b` in mkpair2 type signature
--           ida = id

mkpair3 :: a -> b -> (a, b)
mkpair3 a b = (ida a, b)
    where ida :: b -> b -- legal, because b is now free variable
          ida = id
