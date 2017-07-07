{-# LANGUAGE DeriveGeneric #-}
import qualified Utilities.Config as Config
import Utilities.Errors
import PageFiles.File as File
import PageFiles.Page as Page
import System.IO

import Data.Binary
import GHC.Generics(Generic)
import Control.Monad (void)

-- Test on management of records
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


testRecord :: IO ()
testRecord = open "test.dat"
        >>= \handle ->
                writePageAt handle 0 p
                    >> writePage handle q
                    >> readRecordAt handle 0 (byteLength p)
                        >>= System.IO.putStrLn.show
                        >> readRecord handle (byteLength p)
                            >>= System.IO.putStrLn.show
                            >> writePageAt handle 0 r
                            >> readRecordAt handle 0 (byteLength r)
                                >>= System.IO.putStrLn.show
                                >> readRecord handle (byteLength p)
                                    >>= System.IO.putStrLn.show
        where
            p = Page {pageNumber=1,contents = Person {name="Finch",age = 22}}
            q = Page {pageNumber=2,contents = Person {name="Reese",age = 18}}
            r = Page {pageNumber=3,contents = Person {name="Fusco",age = 20}}


-- The main function executing all tests

main :: IO ()
main = void testRecord
