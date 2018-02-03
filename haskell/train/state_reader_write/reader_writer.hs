module ReaderTest where

import Contor.Monad.Reader
import Data.Functor.Identity

newtype StateT  s m a = StateT  {runStateT  :: s -> m (a, s)}
newtype ReaderT r m a = ReaderT {runReaderT :: r -> m a     }
newtype WriterT w m a = WriterT { runWriterT :: m (a, w) }

type Reader r = ReaderT r Identity
type Writer w = WriterT w Identity


instance (Monad m) => Monad (ReaderT r m) where
    return   = lift . return

    m >>= k     = ReaderT $ \ r -> do
        a <- runReaderT m r -- r == env
        runReaderT (k a) r

    -- state for comparison
    m >>= fn = StateT $ \s -> do
        ~(a', s') <- runStateT m s
        runStateT (fn a') s'

    fail msg = lift (fail msg)

instance (Monoid w, Monad m) => Monad (WriterT w m) where
    return a = writer (a, mempty)

    m >>= k  = WriterT $ do
        ~(a, w)  <- runWriterT m
        ~(b, w') <- runWriterT (k a)
        return (b, w `mappend` w')     -- mappend ==> plusuet chisla, concatenirue stroki, etc

    fail msg = WriterT $ fail msg

writer = WriterT . return
