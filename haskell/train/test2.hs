{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GADTs #-}

data family XList a
data instance XList Char  = XCons !Char !(XList Char) | XNil
    deriving Show
data instance XList ()    = XListUnit !Int


-- data family GMap k :: * -> *
-- data instance GMap (Either a b) v = GMapEither (GMap a v) (GMap b v)


data family T a
data instance T Int = T1 Int | T2 Int
newtype instance T Char = TC Bool

data family G a b
data instance G [a] b where
    G1 :: c -> G [Int] b
    G2 :: G [a] Bool

class GMapKey k where

    data GMap k :: * -> *

    empty       :: GMap k v
    lookup      :: k -> GMap k v -> Maybe v
    insert      :: k -> v -> GMap k v -> GMap k v

instance GMapKey Int where
    data GMap Int v         = GMapInt (Data.IntMap.IntMap v)

    empty                   = GMapInt Data.IntMap empty
    lookup k (GMapInt m)    = Data.IntMap.lookup k m
    insert k v (GMapInt m)  = GMapInt (Data.IntMap.insert k v m) 
