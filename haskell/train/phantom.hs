data Expr a = Expr PrimExpr

constant :: Show a => a -> Expr a
(.+.) :: Expr Int -> Expr Int -> Expr Int
(.==.) :: Eq a => Expr a -> Expr a -> Expr Bool
(.&&.) :: Expr Bool -> Expr Bool -> Expr Bool

data PrimExpr = BinExpr BinOp PrimExpr PrimExpr
              | UnExpr UnOp PrimExpr
              | ConstExpr String

data BinOp = OpEq | OpAnd | OpPlus
data UnOp = OpRevers
