{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import GHC.Prim (coerce)

newtype Const a b = Const { newConst :: a }
    deriving (Monoid)
-- ^
-- instance Monoid a => Monoid (Const a b) where
--     mempty = coerce (mempty :: a) :: Const a b
--     mappend = coerce (mappend :: a -> a -> a) ::
--         Const a b -> Const a b -> Const a b
--     mconcat = coerce (mconcat :: [] a -> a) :: [] (Const a b) -> Const a b
