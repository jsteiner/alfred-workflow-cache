module Alfred.Search
    ( searchItems
    , getItems
    ) where

import Data.Maybe (fromMaybe)
import Data.Function (on)
import Control.Exception (throwIO)
import qualified Data.List as L
import System.Directory (doesFileExist)

import qualified Data.Csv as Csv
import qualified Data.Vector as V
import qualified Data.ByteString.Lazy as BS
import qualified Data.Text as T
import Text.XML.Generator
import qualified Text.Fuzzy as Fuzzy

import Alfred.Item

searchItems :: String -> Maybe String -> IO ()
searchItems cacheFile mq = do
    items <- getItems cacheFile
    printXML . sortByHits . V.toList . matchingItems items $ mq

sortByHits :: [Item] -> [Item]
sortByHits = L.sortBy comparator
    where
        comparator = flip compare `Data.Function.on` aiVisits

getItems :: String -> IO (V.Vector Item)
getItems cacheFile = do
    csvText <- BS.readFile cacheFile
    let result = Csv.decodeByName csvText
    case result of
        Left e -> throwIO $ userError e
        Right (_, items) -> return items

matchingItems :: V.Vector Item -> Maybe String -> V.Vector Item
matchingItems items Nothing = items
matchingItems items (Just q) = V.filter (itemMatches $ T.pack q) items

printXML :: [Item] -> IO ()
printXML = BS.putStr . xrender . itemsToXML

itemsToXML :: [Item] -> Xml Elem
itemsToXML is =
    xelem "items" $
        xelems $ itemToElem <$> is

itemToElem :: Item -> Xml Elem
itemToElem i =
    xelem "item" (attr, elem)
  where
    attr = xattr "arg" $ aiUrl i
    elem = xelem "title" $ xtext $ aiName i

itemMatches :: T.Text -> Item -> Bool
itemMatches q = Fuzzy.test q . aiName
