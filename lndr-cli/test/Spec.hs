{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings   #-}

module Main where

import           Control.Concurrent (threadDelay)
import           Lndr.CLI.Args
import           Lndr.Types
import           Test.Framework
import           Test.Framework.Providers.HUnit
import           Test.HUnit hiding (Test)


testUrl = "http://localhost:80"

testAddress1 = "198e13017d2333712bd942d8b028610b95c363da"
testAddress2 = "1ba7167373f13d28cc112f373bac8d5a07a47af9"

testSearch = "test"
testNick1 = "test1"
testNick2 = "test2"

main :: IO ()
main = defaultMain tests


tests :: [Test]
tests = [ testGroup "Nicks"
            [ testCase "setting nicks and friends" nickTest
            ]
        , testGroup "Credits"
            [ testCase "lend money to friend" basicLendTest
            ]
        , testGroup "Admin"
            [ testCase "get and set gas price" basicGasTest
            ]
        ]


nickTest :: Assertion
nickTest = do
    -- check that nick is available
    nickTaken <- takenNick testUrl testNick1
    assertBool "after db reset all nicks are available" (not nickTaken)
    -- set nick for user1
    httpCode <- setNick testUrl (NickRequest testAddress1 testNick1 "")
    assertEqual "add friend success" 204 httpCode
    -- check that test nick is no longer available
    nickTaken <- takenNick testUrl testNick1
    assertBool "nicks already in db are not available" nickTaken
    -- check that nick for user1 properly set
    queriedNick <- getNick testUrl testAddress1
    assertEqual "nick is set and queryable" queriedNick testNick1
    -- fail to set identical nick for user2
    httpCode <- setNick testUrl (NickRequest testAddress2 testNick1 "")
    assertBool "duplicate nick is rejected with user error" (httpCode /= 204)
    -- change user1 nick
    httpCode <- setNick testUrl (NickRequest testAddress1 testNick2 "")
    assertEqual "change nick success" 204 httpCode
    -- check that user1's nick was successfully changed
    queriedNick <- getNick testUrl testAddress1
    assertEqual "nick is set and queryable" queriedNick testNick2

    -- set user2's nick
    httpCode <- setNick testUrl (NickRequest testAddress2 testNick1 "")
    assertEqual "previously used nickname is settable" 204 httpCode

    fuzzySearchResults <- searchNick testUrl testSearch
    assertEqual "search returns both results" 2 $ length fuzzySearchResults

    -- user1 adds user2 as a friend
    httpCode <- addFriend testUrl testAddress1 testAddress2
    assertEqual "add friend success" 204 httpCode
    -- verify that friend has been added
    friends <- getFriends testUrl testAddress1
    print friends
    -- threadDelay 1000000 -- delay one second
    -- assertEqual "friend properly added" [testAddress2] ((\(NickInfo addr _) -> addr) <$> friends)


basicLendTest :: Assertion
basicLendTest = putStrLn "yet to be implemented"


basicGasTest :: Assertion
basicGasTest = do
    price <- getGasPrice testUrl

    -- double gas price
    httpCode <- setGasPrice testUrl testAddress1 (price * 2)
    assertEqual "add friend success" 204 httpCode

    -- check that gas price has been doubled
    newPrice <- getGasPrice testUrl
    assertEqual "gas price doubled" newPrice (price * 2)
