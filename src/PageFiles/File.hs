module PageFiles.File(
        open,
        close,
        byteLength,
        readPage,
        writePage,
        readPageAt,
        writePageAt
    )where
        --imports
        import qualified Data.ByteString as BS
        import Data.Binary (encode,decode,Binary)
        import System.IO as FileIO(
                                    Handle(..),
                                    openFile,
                                    hClose,
                                    IOMode(..),
                                    hSeek,
                                    SeekMode(..)
                                )
        import PageFiles.Page
        import Data.String.Conversions as DSC

        -- Bindings
        open :: FilePath -> IO Handle
        open path = FileIO.openFile path ReadWriteMode

        close :: Handle -> IO ()
        close = FileIO.hClose

        readNBytes :: Handle -> Int -> IO StrictByteString
        readNBytes = BS.hGetSome

        readAll :: Handle -> IO StrictByteString
        readAll = BS.hGetContents

        writeBytes :: Handle -> StrictByteString -> IO ()
        writeBytes = BS.hPut

        byteLength :: (Binary a) => a -> Integer
        byteLength object = fromIntegral $ BS.length ((DSC.convertString::LazyByteString->StrictByteString) $ encode object)

        --The page size must be obtained using byteLength. The idea being we only use constant sized pages. This goes without saying
        readPage :: (Binary a) => Handle -> Integer -> IO (Page a)
        readPage fileHandle pageSize = (fmap (convertString::StrictByteString -> LazyByteString)  (readNBytes fileHandle (fromIntegral pageSize)) ) >>= return.(decode :: (Binary a) => LazyByteString -> Page a)

        writePage :: (Binary a) => Handle -> Page a -> IO ()
        writePage handle page = writeBytes handle ((DSC.convertString::LazyByteString -> StrictByteString) $ encode page)

        -- Write the page at a particular page position in the file
        writePageAt :: (Binary a) => Handle -> Integer -> Page a -> IO ()
        writePageAt handle pageNumber page = hSeek handle AbsoluteSeek (pageNumber*(byteLength page))  >> writePage handle page

        -- Write the page at a particular page position in the file
        readPageAt :: (Binary a) => Handle -> Integer -> Integer -> IO (Page a)
        readPageAt handle pageNumber pageSize = hSeek handle AbsoluteSeek (pageNumber*pageSize) >> readPage handle pageSize
