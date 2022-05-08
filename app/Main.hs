module Main where


import Logging
import Options
import CLI
import Server


main :: IO ()
main = parseArguments >>= run


run :: Options -> IO ()
run (Options c (Serve (ServeOpts b))) = serverMain c (logger c) b
run (Options c (Connect (ConnectOpts h))) = clientMain c (logger c) h


clientMain :: CommonOpts -> Logger -> Host -> IO ()
clientMain c l b = print "client"
