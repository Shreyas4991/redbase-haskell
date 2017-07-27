module Utilities.Errors(
    throwError,
    Result(..),
    (<*>)
) where

    import qualified Utilities.Config as Config
    import Control.Monad

    data Result a = Error String | Result a

    instance Functor Result where
        fmap f (Result x) = Result (f x)
        fmap f (Error errormessage) = (Error errormessage)

    instance Applicative Result where
        pure x = Result x
        (Error x) <*> _ = (Error x)
        _ <*> (Error y) = (Error y)
        (Result f) <*> (Result x) = (Result $ f x)

    instance Monad Result where
        return res = Result res
        Result res1 >>= function = (function res1)
        (Error errormessage) >>= function = (Error errormessage)


    throwError :: Result a -> IO ()
    throwError (Error message) = putStrLn message
    throwError _ = return ()
