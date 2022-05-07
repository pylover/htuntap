module Main where


import Logging
import Options
import CLI
import Server


data App = Server Logger Bind Port
         | Client Logger Host Port
  deriving (Show)


app :: Options -> App
app (Options (CommonOpts l p) (Serve (ServeOpts b))) = Server (Logger l) b p
app (Options (CommonOpts l p) (Connect (ConnectOpts h))) = Client (Logger l) h p


main :: IO ()
main = do 
    args <- parseArguments
    print $ app args
    run $ app args


run :: App -> IO()
run (Server logger bind port) = serverMain logger bind port
run (Client logger host port) = clientMain logger host port


clientMain :: Logger -> Host -> Port -> IO ()
clientMain l b p = print "client"
