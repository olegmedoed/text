module TransformerLang where

-- class Monad m where
--     return  :: a -> m a
--     (>>=)   :: m a -> (a -> m b) ->  m b
--     (>>)    :: m a -> m b -> m b
-- 
--     m >> n  =  m >>= \_ -> n
-- 
--     fail :: String -> m a

-- class MonadTrans t where
--     lift :: Monad m => m a -> t m a

import Control.Monad.Identity
import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State
import Control.Monad.State.Lazy
import Data.Maybe
import qualified Data.Map as Map

type Name = String
data Expr = Lit Integer
          | Var Name
          | Plus Expr Expr
          | Abs Name Expr
          | App Expr Expr
          deriving(Show)

data Value = IntVal Integer
           | FunVal Env Name Expr
           deriving(Show)

type Env = Map.Map Name Value

-- 12 + ((\x -> x)(4 + 2))   ===   18
exampleExp =   Lit 12 `Plus` (App (Abs "x" (Var "x"))
                                  (Lit 4 `Plus` Lit 2))

--------------------------------- pure style ----------------------------------

eval0 :: Env -> Expr -> Value
eval0 env (Lit i)       = IntVal i
eval0 env (Var n)       = fromJust (Map.lookup n env)
eval0 env (Plus e1 e2)  = let IntVal i1 = eval0 env e1
                              IntVal i2 = eval0 env e2
                           in IntVal (i1 + i2)
eval0 env (Abs n e)     = FunVal env n e
eval0 env (App e1 e2)   = let val1 = eval0 env e1
                              val2 = eval0 env e2
                           in case val1 of
                                FunVal env' n body -> eval0 (Map.insert n val2 env') body

resExampleExp0   = eval0 Map.empty exampleExp -- IntVal 18

-------------------------------- monadic style --------------------------------

type Eval1 a = Identity a

runEval1 :: Eval1 a -> a
runEval1 = runIdentity

-- eval1 :: Env -> Expr -> Eval1 Value
eval1 :: Monad m => Env -> Expr -> m Value
eval1 env (Lit i) = return $ IntVal i
eval1 env (Var n) = return $ fromJust (Map.lookup n env)
eval1 env (Plus e1 e2) = do IntVal i1 <- eval1 env e1
                            IntVal i2 <- eval1 env e2
                            return $ IntVal (i1 + i2)
eval1 env (Abs n e) = return $ FunVal env n e
eval1 env (App e1 e2) = do val1 <- eval1 env e1
                           val2 <- eval1 env e2
                           case val1 of
                                FunVal env' n body -> eval1 (Map.insert n val2 env') body 

-- resExampleExp1 = runEval1 $ eval1 Map.empty exampleExp -- IntVal 18
resExampleExp1 :: Maybe Value
resExampleExp1 = eval1 Map.empty exampleExp

------------
-- to o chem 9 govoril, wo mol  `return` v Hskl posvol9et abstragirovat's9 ot
-- conteinera(side-effect), i takim obrazom, my mozhem bindit' nawu  `eval1` na
-- lubuu monadu, hot' tam Maybe, hot' List, tipa
[expr1, expr2] >>= (eval1 some_env)  -- [val1, val2]
Just expr >>= (eval1 some_ent)       -- Just val
-- tak vot, primer etogo zhe v Rust,
-- bez vs9kih bl9t' monad, a tupo iteratorami,
-- Teper' 9 pon9l wo znachil otvet "YOU MAY USE ITERATORS" kogda 9 googlil "monads rust".
-- env i eval1 --v vychisl9ut huinu, no igraut tuzhe rol', takwo prosto godnye stub-y
    let env = 40;
    -- ne uszau monadi, prost vozvraw'au zanchenie(v Option wob ne panic!ovat' kak Hskl
    -- eto delaet v `eval0`  see `fromJust`)
    fn eval1(env: i32, expr: i32) -> Option<String> { -- String tipa Value, i32 tipa Env/Expr
        if expr > env { -- `>` tipa expr can be parsed (Map.lookup nawla znachenie dl9 perem v expr)
           Some(format!("expr = {}", expr)) -- parse
        }
        else { None } -- ne parsits9(v `eval0` eto tipa Map.lookup ne nawla zancheni9 dl9 perem.)
    }
    let s: Vec<_> = vec!(33, 54, 66).into_iter() -- [expr1, expr2]
        .flat_map(|expr| eval1(env, expr))
        .collect();
    println!("s_flat = {:?}", s); -- ["s_flat = 54", "s_flat = 66"]   << [val1, val2] 

    let s: Vec<_> = Some(66).into_iter()    -- Just expr1
        .flat_map(|expr| eval1(env, expr))
        .collect();
    println!("s_flat = {:?}", s); -- ["s_flat = 66"]    if Some(33) => []
    -- Takoe ne konaet, no tol'ko potomu wo
    -- FromIterator<String>` is not implemented for the type `Option<_>`
    -- Vypolni i flag tebe v ruki
    let s: Option<_> = Some(53).into_iter()
        .flat_map(|expr| eval(env, expr))
        .collect();
    println!("s_flat = {:?}", s);
    -- Vobw'em  [GIST] v tom wo v Ruste mozhno delat' dohu9 interesnyh i krutyh
    -- wtuk, mozh NE TAKIM OBRAZOM kak v Hskl, mozhet dazhe koewo i ne
    -- poluchits9(ili tebe tak kazhets9), no i v Haskele ne vse zdelaew wo v Rust
    -- (9 pro abstakcii, pro zhelezo/mem.layout 9 voobw'e molchu),
    -- pokrainei mere poka ne poimew kak pravil'no raweat' podobnye zadachi `in
    -- Hskl way`,   POTOMU: dupli `THE RUST WAY`, Rust daet tebe uimu abstrakcyi, i
    -- esli woto kazhets9 wo Hskl mozhet, a Rust ne, to eto potomu chto ty pitaews9 delat'
    -- eto na Rust `in Hskl way`, naidi prosto `the Rust way` i vse budet ok.
-------------

------------------------------ monad transformers -----------------------------

type Eval2 a = ExceptT String Identity a --- po factu nichem ne otlichaets9 ot prosto `Either`

runEval2 :: Eval2 a -> Either String a
runEval2 ev = runIdentity (runExceptT ev)
-----------------------------

eval2a :: Env -> Expr -> Eval2 Value
eval2a env (Lit i) = return $ IntVal i
eval2a env (Var n) = return $ fromJust (Map.lookup n env)
eval2a env (Plus e1 e2) = do IntVal i1 <- eval2a env e1
                             IntVal i2 <- eval2a env e2
                             return $ IntVal(i1 + i2)
eval2a env (Abs n e) = return $ FunVal env n e
eval2a env (App e1 e2) = do val1 <- eval2a env e1
                            val2 <- eval2a env e2
                            case val1 of
                                FunVal env' n body -> eval2a (Map.insert n val2 env') body

resExampleExp2a = runEval2 $ eval2a Map.empty exampleExp


eval2b :: Env -> Expr -> Eval2 Value
eval2b env (Lit i) = return $ IntVal i
eval2b env (Var n) = case Map.lookup n env of
                       Just i -> return i
                       Nothing -> throwError "type error"
eval2b env (Plus e1 e2) = do e1' <- eval2b env e1
                             e2' <- eval2b env e2
                             case (e1', e2') of
                                (IntVal i1, IntVal i2) -> return $ IntVal (i1 + i2)
                                _                      -> throwError "type error"
eval2b env (Abs n e) = return $ FunVal env n e
eval2b env (App e1 e2) = do val1 <- eval2b env e1
                            val2 <- eval2b env e2
                            case val1 of
                                FunVal env' n body -> eval2b (Map.insert n val2 env') body
                                _                  -> throwError "type error"

resExampleExp2b = runEval2 $ eval2b Map.empty exampleExp
-- resExampleExp2b = eval2b Map.empty (Plus (Abs "n" (Lit 3)) (Abs "n" (Lit 7)))

--------------------------- reader monad transformers -------------------------

type Eval3 a = ReaderT Env (ExceptT String Identity) a

runEval3 :: Env -> Eval3 a -> Either String a
runEval3 env ev = runIdentity (runExceptT (runReaderT ev env))

eval3 :: Expr -> Eval3 Value

eval3 (Lit i) = return $ IntVal i
eval3 (Var n) = do env <- ask
                   case Map.lookup n env of
                       Just i -> return i
                       Nothing -> throwError ("type error" ++ n)
eval3 (Plus e1 e2) = do e1' <- eval3 e1
                        e2' <- eval3 e2
                        case (e1', e2') of
                          (IntVal i1, IntVal i2) -> return $ IntVal(i1 + i2)
                          _                      -> throwError "type error in addition"
eval3 (Abs n e) = do env <- ask
                     return $ FunVal env n e 
eval3 (App e1 e2) = do val1 <- eval3 e1
                       val2 <- eval3 e2
                       case val1 of
                         FunVal env n body -> local (const (Map.insert n val2 env)) (eval3 body)
                         _ -> throwError "type error in application"

resExampleExp3 = runEval3 Map.empty (eval3 exampleExp)

