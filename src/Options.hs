module Options where


type Host = String
type Bind = String
type Port = Integer


data Options = Options CommonOpts Command
  deriving Show


data CommonOpts = CommonOpts
  { verbosity :: Integer
  , port :: Port }
  deriving Show


data Command
  = Serve ServeOpts
  | Connect ConnectOpts
  deriving Show


data ServeOpts = ServeOpts
  { bind :: Bind }
  deriving Show


data ConnectOpts = ConnectOpts
  { host :: Host }
  deriving Show
