{-# LANGUAGE TupleSections #-}

-- Either (Either a b) c    ~   Either a (Either b c)
-- (a + b) + c = a + (b + c)
eforward (Left (Left  a))  = Left a
eforward (Left (Right b))  = Right (Left b)
eforward (Right c)     = Right (Right c)
--
ereverse (Left a) = Left (Left a)
ereverse (Right (Left b)) = Left (Right b)
ereverse (Right (Right c)) = Right c
-- or
eforward' = either (either Left (Right . Left))  (Right . Right)
ereverse' = either (Left . Left)                 (either (Left . Right) Right)


-- ((a,b), c)   ~ (a, (b,c))
-- (a * b) * c  = a * (b * c)
tforward ((a, b), c) = (a, (b, c))
treverse (a, (b, c)) = ((a, b), c)

-- (a, (Either b c)) ~ Either (a, b) (a, c)
-- a * (b + c) = (a * b) + (a * c)
etforward :: (a, Either b c) -> Either (a, b) (a, c)
etforward (a, e) = either (Left . (a, )) (Right . (a,)) e
-- etreverse :: (Either (a,b) (a,c)) -> (a, (Either b c))
etreverse e = (either fst fst e, either (Left . snd) (Right . snd) e)

data Zero -- 0

-- a + b + c
data Sum a b c = S1 a | S2 b | S3 c
type Sum1 a b c = Either a (Either b (Either c Zero))
