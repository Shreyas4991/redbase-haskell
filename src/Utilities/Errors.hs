module Utilities.Errors(
    throwError,
    displayError,
    Error(..),
    (<>)
) where

    import qualified Utilities.Config as Config

    data Error = Error String deriving(Show)

    instance Monoid Error where
        mempty = Error ""
        mappend (Error x) (Error y) = Error (x ++ "\n AND "++y)

    (<>) :: Error -> Error -> Error
    (<>) = mappend

    displayError :: Error -> String
    displayError (Error x) = "ERROR: "++x

    throwErrorPrivate :: String -> Error -> String
    throwErrorPrivate mode e
        | mode == "DEVELOPMENT" = displayError e
        | mode == "TESTING" = displayError e
        | otherwise = ""

    throwError :: Error -> String
    throwError = throwErrorPrivate (Config.fetchConfig "MODE")
