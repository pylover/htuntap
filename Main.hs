module Main where

import Options.Applicative
import CLI

main :: IO ()
main = do
  r <- customExecParser (prefs helpShowGlobals) parserInfo
  print r
