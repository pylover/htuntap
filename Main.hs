module Main where

import Logging
import CLI
import App
import TunTap

main :: IO ()
main = do 
    args <- parseArguments
    print $ app args
    run $ app args

run :: App -> IO()
run (Server logger bind port) = serverMain logger bind port
run (Client logger host port) = clientMain logger host port

serverMain :: Logger -> Bind -> Port -> IO ()
serverMain l b p = print "server"

clientMain :: Logger -> Host -> Port -> IO ()
clientMain l b p = print "client"
