{-# LANGUAGE Arrows #-}
module CLI where

import Options.Applicative
import Options.Applicative.Arrows
import Paths_htuntap (version)
import Data.Version (showVersion)


parseArguments :: IO Args
parseArguments = customExecParser (prefs helpShowGlobals) parserInfo


type Host = String
type Bind = String
type Port = Integer


data Args = Args CommonOpts Command
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


versionParser :: Parser (a -> a)
versionParser = infoOption (showVersion version)
  (  long "version"
  <> help "Print version information" )


parser :: Parser Args
parser = runA $ proc () -> do
  opts <- asA commonOpts -< ()
  cmds <- (asA . hsubparser)
     ( command "serve" (info serveParser (progDesc "Server Mode"))
    <> command "connect" (info connectParser (progDesc "Client Mode"))) -< ()
  A versionParser >>> A helper -< Args opts cmds


commonOpts :: Parser CommonOpts
commonOpts = CommonOpts
  <$> option auto
      ( short 'v'
     <> long "verbose"
     <> metavar "LEVEL"
     <> help "Set verbosity to LEVEL, 0..4, default: 2"
     <> value 2 )
  <*> option auto 
      ( short 'p'
     <> long "port"
     <> metavar "PORT"
     <> help "Port number: 1..65535, default: 5671"
     <> value 5671 )


serveParser :: Parser Command
serveParser = runA $ proc () -> do
  s <- asA serveOpts -< ()
  returnA -< Serve s


serveOpts :: Parser ServeOpts
serveOpts = ServeOpts <$> argument str (metavar "ADDRESS")


connectOpts :: Parser ConnectOpts
connectOpts = ConnectOpts <$> argument str (metavar "HOSTNAME")


connectParser :: Parser Command
connectParser = runA $ proc () -> do
  c <- asA connectOpts -< ()
  returnA -< Connect c


parserInfo :: ParserInfo Args
parserInfo = info parser ( progDesc "Multiprotocol tunnel" )
