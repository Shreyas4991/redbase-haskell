module PageFiles.Buffer(
) where
    import Data.Binary
    import PageFiles.Page
    import Utilities.Errors
    import Control.Applicative
    import Data.Vector.Mutable as V
    import Data.HashTable.IO as H

    type BufferPageTable = CuckooHashTable Int Int
    data PageContainer a = PageContainer {
        page :: Page a,
        dirtyMark :: Bool,
        pinned :: Bool
    } deriving(Show,Eq)

    data Buffer a = Buffer {
        maxSize :: Int,
        filledSlots :: Int,
        bufferContent :: IOVector (PageContainer a),
        pageTable :: BufferPageTable,
        unPinnedPageNumbers :: [Int]
    }
    -- Functions to construct and fetch data from Page Containers
    containerPageNumber :: (Binary a) => PageContainer a -> Int
    containerPageNumber pageContainer = pageNumber $ page pageContainer

    containerPageContent :: (Binary a) => PageContainer a -> a
    containerPageContent pageContainer = contents $ page pageContainer

    containerPageDeleted :: (Binary a) => PageContainer a -> Bool
    containerPageDeleted pageContainer = deleted $ page pageContainer

    newPageContainer :: (Binary a) => Page a -> Bool -> Bool -> IO (PageContainer a)
    newPageContainer newPage newDirtyMark newPinned = return PageContainer {
                                                                page = newPage,
                                                                dirtyMark = newDirtyMark,
                                                                pinned = newPinned
                                                            }
    -- Buffer creation functions

    createBuffer :: (Binary a) => Int -> IOVector (PageContainer a) -> BufferPageTable -> IO (Buffer a)
    createBuffer size contents table = return Buffer{
                                                        maxSize = size,
                                                        filledSlots = 0,
                                                        bufferContent = contents,
                                                        pageTable = table,
                                                        unPinnedPageNumbers = []
                                                    }

    createBufferContentsVector :: (Binary a) => Int -> IO (IOVector (PageContainer a))
    createBufferContentsVector = V.new

    createPageTable :: IO BufferPageTable
    createPageTable = H.new

    newBuffer :: (Binary a) => Int -> IO (Buffer a)
    newBuffer bufferSize = createBufferContentsVector bufferSize >>=
                                                        \contentsVector ->
                                                            createPageTable >>=
                                                                \pageTable ->
                                                                    createBuffer bufferSize contentsVector pageTable


    -- Buffer modifications
    getPageBufferPosition :: (Binary a) => Buffer a -> Int -> IO (Maybe Int)
    getPageBufferPosition currentBuffer pageNum = H.lookup (pageTable currentBuffer) pageNum

    {--    -- Deletes an unpinned page if necessary
    deleteUnPinnedContainer :: (Binary a) => Buffer a ->  IO (Maybe Int)
    deleteUnPinnedContainer currentBuffer
        | null $ unPinnedPageNumbers currentBuffer = (return (-1))
        | otherwise = getPageBufferPosition (pageNumber $ last (unPinnedPageNumbers currentBuffer)) >>=
    insertContainerProperly

    insertPage :: (Binary a) => Page a -> Bool -> Bool -> Buffer a -> IO ()
    insertPage newPage pinned currentBuffer
                | getPageBufferPosition currentBuffer (pageNumber newPage) == Nothing =  newPageContainer newPage False pinned >>=
                                                        \pageContainer ->
--}
