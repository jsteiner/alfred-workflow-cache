module Alfred.Cache
    ( writeItems
    , rawWriteItems
    ) where

import qualified Data.Csv as Csv
import qualified Data.ByteString.Lazy as BS
import qualified Data.Foldable as F

import Alfred.Item
import Alfred.Search

writeItems :: String -> [Item] -> IO ()
writeItems cacheFile items = do
  cachedItems <- getItems cacheFile
  rawWriteItems cacheFile $ itemsWithCachedVisits items cachedItems

rawWriteItems :: String -> [Item] -> IO ()
rawWriteItems cacheFile = BS.writeFile cacheFile . Csv.encodeDefaultOrderedByName

itemsWithCachedVisits :: Foldable t => [Item] -> t Item -> [Item]
itemsWithCachedVisits currentItems itemsCache =
  map (combineWithCache itemsCache) currentItems

combineWithCache :: Foldable t => t Item -> Item -> Item
combineWithCache is i =
  case item of
    Just i' -> i { aiVisits = aiVisits i' }
    Nothing -> i
  where
    item = F.find ((== aiUrl i) . aiUrl) is
