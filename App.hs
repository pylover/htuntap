module App where

import Logging
import CLI

type Host = String
type Bind = String
type Port = Integer

data App = Server Logger Bind Port
         | Client Logger Host Port

app :: Args -> App
app (Args c (Serve o)) = Server (createLogger c) "Localhost" 5671
app (Args c (Connect o)) = Client (createLogger c) "Localhost" 5671

createLogger :: CommonOpts -> Logger
createLogger (CommonOpts v) = Logger v
