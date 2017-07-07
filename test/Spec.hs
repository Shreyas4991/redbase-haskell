{-# LANGUAGE DeriveGeneric #-}
import qualified Utilities.Config as Config
import Utilities.Errors
import PageFiles.File as File
import PageFiles.Page as Page
import System.IO
import Data.ByteString as BS
import Data.Binary
import GHC.Generics(Generic)
import Control.Monad

data Record  = Person {
    name::String,
    age::Int
} deriving(Show,Generic)

instance Binary Record

readRecordAt :: Handle -> Integer -> Integer -> IO (Page Record)
readRecordAt = readPageAt

writeRecordAt :: Handle -> Integer -> Page Record -> IO ()
writeRecordAt = writePageAt

readRecord :: Handle -> Integer -> IO (Page Record)
readRecord = readPage

writeRecord :: Handle -> Page Record -> IO ()
writeRecord = writePage


main :: IO ()
main = void $ open "test.dat"
        >>= \handle ->
                writePage handle p
                    >> writePage handle q
                    >> readRecordAt handle 0 (byteLength p)
                        >>= System.IO.putStrLn.show
                        >> readRecord handle (byteLength p)
                            >>= System.IO.putStrLn.show

        where
            p = Page {pageNumber=1,contents = Person {name="Shreyas",age = 22}}
            q = Page {pageNumber=2,contents = Person {name="Thejas",age=18}}
