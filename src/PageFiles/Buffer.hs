module PageFiles.Buffer(

) where
    import Data.Binary
    import PageFiles.Page

    data PageContainer a = PageContainer {
        page :: Page a,
        dirtyMark :: Bool
    } deriving(Show,Eq)

    data Buffer a = Buffer{
        maxSize :: Int,
        bufferContent :: [PageContainer a]
    }

    initialiseBuffer :: (Binary a,Eq a) => Int -> Buffer a
    initialiseBuffer bufferSize= Buffer {maxSize = bufferSize,bufferContent = []}

    insertPage :: (Binary a,Eq a) => Buffer a -> Page a -> Buffer a
    insertPage currentBuffer newPage
        | (length $ bufferContent currentBuffer) == maxSize currentBuffer = currentBuffer
        | elem (PageContainer{dirtyMark = True,page = newPage}) (bufferContent currentBuffer) = modifiedBuffer
        | elem (PageContainer{dirtyMark = False,page = newPage}) (bufferContent currentBuffer) = modifiedBuffer
        | otherwise = appendedBuffer
        where
            appendedBuffer = Buffer {
                                    maxSize = (maxSize currentBuffer),
                                    bufferContent = (PageContainer {
                                        dirtyMark = False,
                                        page = newPage
                                    }):(bufferContent currentBuffer)
                                }
            modifiedBuffer = Buffer {
                                    maxSize = (maxSize currentBuffer),
                                    bufferContent = (PageContainer {
                                        dirtyMark = True,
                                        page = newPage
                                    }):restOfBuffer
                                }
            restOfBuffer = [pageContainer | pageContainer <- bufferContent currentBuffer, (page pageContainer) /= newPage]
