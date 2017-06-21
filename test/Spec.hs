import qualified Utilities.Config as Config
import Utilities.Errors


main :: IO ()
main = putStrLn $ throwError $ (Error "Wrong String") <> (Error "Wrong address")
