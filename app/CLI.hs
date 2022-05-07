{-# LANGUAGE Arrows #-}
module CLI where

import Options.Applicative
import Options.Applicative.Arrows
import Paths_htuntap (version)
import Data.Version (showVersion)

import Options


parseArguments :: IO Options
parseArguments = customExecParser (prefs helpShowGlobals) parserInfo


versionParser :: Parser (a -> a)
versionParser = infoOption (showVersion version)
  (  long "version"
  <> help "Print version information" )


parser :: Parser Options
parser = runA $ proc () -> do
  opts <- asA commonOpts -< ()
  cmds <- (asA . hsubparser)
     ( command "serve" (info serveParser (progDesc "Server Mode"))
    <> command "connect" (info connectParser (progDesc "Client Mode"))) -< ()
  A versionParser >>> A helper -< Options opts cmds


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
serveOpts = ServeOpts 
  <$> argument str 
      ( metavar "ADDRESS"
     <> value "localhost" )


connectOpts :: Parser ConnectOpts
connectOpts = ConnectOpts <$> argument str (metavar "HOSTNAME")


connectParser :: Parser Command
connectParser = runA $ proc () -> do
  c <- asA connectOpts -< ()
  returnA -< Connect c


parserInfo :: ParserInfo Options
parserInfo = info parser ( progDesc "Multiprotocol tunnel" )
