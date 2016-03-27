module Alfred.Increment
    ( incrementVisits
    ) where

import qualified Data.Text as T

import Alfred.Item
import Alfred.Search
import Alfred.Cache

incrementVisits :: String -> T.Text -> IO ()
incrementVisits cacheFile url = do
    items <- getItems cacheFile
    let items' = foldr (incrementIfItem url) [] items
    writeItems cacheFile items'

incrementIfItem :: T.Text -> Item -> [Item] -> [Item]
incrementIfItem url item items
    | url == aiUrl item = increment item : items
    | otherwise = item : items

increment :: Item -> Item
increment i =
    i { aiVisits = (+1) $ aiVisits i }
