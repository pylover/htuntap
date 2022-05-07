module Server where

import Data.ByteString hiding (putStrLn)
import Network.Simple.TCP
import Control.Monad.Trans
import Control.Monad.Trans.Maybe

import Logging
import Options


serverMain :: Logger -> Bind -> Port -> IO ()
serverMain l b p = serve (Host b) (show p) $ \(s, addr) -> do
  putStrLn $ "TCP connection established from " ++ show addr
  runMaybeT $ serverLoop l s
  return ()


serverLoop :: Logger -> Socket -> MaybeT IO ()
serverLoop l s = recv_ >>= send_ >> serverLoop l s
  where
    recv_ = MaybeT $ recv s 1024
    send_ = lift . send s
