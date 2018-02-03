{-# LANGUAGE ScopedTypeVariables #-}

module Main where
import Data.Char (toUpper)


data Person = Person {
    personName  :: String,
    personAge   :: Int
} deriving (Show)

pat o = case o of
        Nothing -> 0
        Just x
            | x < 8 -> x+x
            | x > 8 -> x*x


land amount balance
    | amount < reserve = Just newBalance
    | otherwise = Nothing
        where reserve = 100
              newBalance = balance - amount

oleg = Person {
    personName  = "Oleg Tsyba",
    personAge   = 25
}

-- f m = do c <- m; return (toUpper c)
-- f m = do x <- m; return x
f m = m >>= return
