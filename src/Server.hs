module Server where

import Data.ByteString hiding (putStrLn)
import Network.Simple.TCP
import Control.Monad.Trans
import Control.Monad.Trans.Maybe

import Logging
import Options


serverMain :: CommonOpts -> Logger -> Bind -> IO ()
serverMain c l b = serve (Host b) (show (port c)) $ \(s, addr) -> do
  putStrLn $ "TCP connection established from " ++ show addr
  runMaybeT $ serverLoop l s
  return ()


serverLoop :: Logger -> Socket -> MaybeT IO ()
serverLoop l s = recv_ >>= send_ >> serverLoop l s
  where
    recv_ = MaybeT $ recv s 1024
    send_ = lift . send s
