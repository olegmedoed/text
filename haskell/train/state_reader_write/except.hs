type Except e = ExceptT e Identity

runExcept :: Except e a -> Either e a
runExcept (ExceptT m) = runIdentity m

-----------------------------------------------------------------------------------------

newtype ExceptT e m a = ExceptT (m (Either e a))

runExceptT :: ExceptT e m a -> m (Either e a)
runExceptT (ExceptT m) = m


instance (Functor m) => Functor (ExceptT e m) where
    fmap f = ExceptT . fmap (fmap f) . runExceptT


instance (Monad m) => Monad (ExceptT e m) where

    return a = ExceptT $ return (Right a)

    m >>= k = ExceptT $ do
        a <- (runExceptT m)
        case a of
            Left e -> return (Left e)
            Right x -> runExceptT (k x)

    -- pripustim:           `runExceptT m` ==  StateT (\s -> Either e, (a', s))
    -- to na vyhode s:   `m >>= k`
    ExceptT (runExceptT m >>= \a -> case a of
                                 Left e -> return (Left e)
                                 Right x -> runExceptT (k x))  -- x :: (a', s)

    fail = ExceptT . fail

-- instead of throwException in trasformers_lang.hs
throwE :: (Monad m) => e -> ExceptT e m a
throwE = ExceptT . return . Left
