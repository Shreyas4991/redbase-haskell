{-# LANGUAGE DeriveGeneric #-}
module PageFiles.Page(
    Page(..)
)  where
    import Data.Binary as Binary
    import GHC.Generics (Generic)

    data Page a = Page {
                        pageNumber::Int,
                        contents :: a
                    } deriving(Generic,Show)
    --The type qualifier `Binary.Binary` for `a` makes it imperative for us to ensure that
    --any data type that we define and plan on storing in our pages must be
    --an instance of the typeclass binary. For this the GHC.Generics module
    --and the pragma on top are required as is also "deriving(Generic)". This allows us to encode and decode pages.
    instance (Binary a)=> Binary (Page a)
