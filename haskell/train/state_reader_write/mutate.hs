module Main where

import Data.IORef
import Data.STRef
import Control.Monad
import Control.Monad.ST

magic :: IORef (Maybe Int) -> IO ()
magic ref = do
    val <- readIORef ref

    case val of
      Nothing -> writeIORef ref (Just 42)
      Just _ -> return ()


bubbleSort :: [Int] -> IO [Int]
bubbleSort input = do
    let ln = length input

    xs <- mapM newIORef input

    forM_ [0..ln-1] $ \_ -> do
        forM_ [0..ln-2] $ \j -> do
            let ix = xs !! j
            let iy = xs !! (j+1)

            x <- readIORef ix
            y <- readIORef iy

            when (x > y) $ do
                writeIORef ix y
                writeIORef iy x

    mapM readIORef xs

magicST :: Int -> Int
magicST x = runST $ do
    ref <- newSTRef x
    modifySTRef ref (+1)
    readSTRef ref

main :: IO ()
main = do
    ref <- newIORef Nothing
    magic ref

    -- AFAIU: IORef is like Cell in Rust
    let value = (newIORef 3)
    ref1 <- value 
    ref2 <- value

    val1 <- (readIORef ref1)
    val2 <- (readIORef ref2)

    writeIORef ref1 (val1 + val2)

    readIORef ref1 >>= print
    readIORef ref2 >>= print
    value >>= readIORef >>=  print
