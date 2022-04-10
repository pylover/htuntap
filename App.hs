module App where

import Logging
import CLI

data App = Server Logger Bind Port
         | Client Logger Host Port
  deriving (Show)

app :: Args -> App
app (Args (CommonOpts l p) (Serve (ServeOpts b))) = Server (Logger l) b p
app (Args (CommonOpts l p) (Connect (ConnectOpts h))) = Client (Logger l) h p
