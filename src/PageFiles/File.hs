module PageFiles.File(
        open,
        close,
        writeBytes,
        readPage,
        byteLength,
        writePage
    )where
        import Data.ByteString.Lazy as BS
        import Data.Binary (encode,decode,Binary)
        import System.IO as FileIO(Handle(..),openFile,hClose,withFile,IOMode(..))
        import PageFiles.Page
        import GHC.Int (Int64)

        open :: FilePath -> IO Handle
        open path = FileIO.openFile path ReadWriteMode

        close :: Handle -> IO ()
        close = FileIO.hClose

        readNBytes :: Handle -> Int -> IO BS.ByteString
        readNBytes = BS.hGet

        readAll :: Handle -> IO BS.ByteString
        readAll = BS.hGetContents

        writeBytes :: Handle -> BS.ByteString -> IO ()
        writeBytes = BS.hPut

        byteLength :: (Binary a) => a -> Int
        byteLength object = fromIntegral $ BS.length (encode object)

        --The page size must be obtained using byteLength. The idea being we only use constant sized pages. This goes without saying
        readPage :: (Binary a) => Handle -> Int -> IO (Page a)
        readPage fileHandle pageSize = readNBytes fileHandle pageSize >>= return.(decode :: (Binary a) => BS.ByteString -> Page a)

        writePage :: (Binary a) => Handle -> Page a -> IO ()
        writePage handle page = writeBytes handle (encode page)
