module Main where

sort lst@(x:[]) = lst -- Initialization(base case). one element
sort lst@(x:xs) = -- |-- the gist of insert.sort is expressed tremendously simply
          --   V-----|   
  arrange (sort xs) x  -- Loop invariant: first parameter '(sort xs)' is
    where -- guarantee that part of list [cormen 1..j] is sorted,  and arrange
      arrange [] key = key:[]   -- func is analog of proof in math induction
      arrange lst@(x:xs) key =  -- as Graham has said (that mean what "truth" 
        if key > x  -- aka "n=>n+1" in the computable func is expressed by
           then x : arrange xs key  --  ability to compute "n" so that result
           else key : lst -- of computation conform to expected result aka "n+1"
  -- here "n" originally [x:[]], then by using arrange we compute "n+1" by 
  -- handling "n" aka (sort xs) and produce "n+1" what will be new "n" sort 
  -- the next recursion stage
--                          iterative version in terms of list we cannot compute

