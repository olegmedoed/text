module MyFoldable where

class Foldable t where
    {-# MINIMAL foldMap | foldr #-}

    fold :: Monoid m => t m -> m -- combine elements of a struct using a monoid
    fold = foldMap id

    foldMap :: Monoid m => (a -> m) -> t a -> m
    foldMap f = foldr (mappend . f) mempty

    

