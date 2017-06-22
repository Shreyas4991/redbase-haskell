import qualified Utilities.Config as Config
import Utilities.Errors
import PageFiles.File as File
import PageFiles.Page as Page
import System.IO
import Data.ByteString.Lazy as BS
import Data.Binary

p = Page {pageNumber=1,contents = (6::Int)}
main :: IO ()
main = open "test.dat"
        >>=  \handle -> writeBytes handle (encode p)
            -- >> (readPage::Handle -> Int -> IO (Page Int)) handle (byteLength p)
            -- >>= System.IO.putStrLn.show
