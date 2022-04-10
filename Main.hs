module Main where

import Options.Applicative
import CLI

main :: IO ()
main = do
  r <- customExecParser (prefs helpShowGlobals) parserInfo
  run r

run :: Args -> IO()
run (Args c (Serve o)) = serverMain c o
run (Args c (Connect o)) = clientMain c o

serverMain :: CommonOpts -> ServeOpts -> IO()
serverMain c o = do
  print c
  print o

clientMain :: CommonOpts -> ConnectOpts -> IO()
clientMain c o = do
  print c
  print o
