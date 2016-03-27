module Alfred.Cache
    ( writeItems
    ) where

import qualified Data.Csv as Csv
import qualified Data.ByteString.Lazy as BS

import Alfred.Item

writeItems :: String -> [Item] -> IO ()
writeItems cacheFile = BS.writeFile cacheFile . Csv.encodeDefaultOrderedByName
