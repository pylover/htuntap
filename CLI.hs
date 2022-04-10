{-# LANGUAGE Arrows #-}
module CLI where

import Options.Applicative
import Options.Applicative.Arrows
import Paths_htuntap (version)
import Data.Version (showVersion)

parseArguments :: IO Args
parseArguments = customExecParser (prefs helpShowGlobals) parserInfo

data Args = Args CommonOpts Command
  deriving Show

data CommonOpts = CommonOpts
  { optVerbosity :: Integer }
  deriving Show

data Command
  = Serve ServeOpts
  | Connect ConnectOpts
  deriving Show

data ServeOpts = ServeOpts
  { instReserve :: Bool
  , instForce :: Bool }
  deriving Show

data ConnectOpts = ConnectOpts
  { foo :: Bool
  , bar :: Bool }
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
     <> help "Set verbosity to LEVEL"
     <> value 0 )

serveParser :: Parser Command
serveParser = runA $ proc () -> do
  s <- asA serveOpts -< ()
  returnA -< Serve s

serveOpts :: Parser ServeOpts
serveOpts = runA $ proc () -> do
  reinst <- asA (switch (long "reserve")) -< ()
  force <- asA (switch (long "force-reserve")) -< ()
  returnA -< ServeOpts
             { instReserve = reinst
             , instForce = force }

connectOpts :: Parser ConnectOpts
connectOpts = runA $ proc () -> do
  f <- asA (switch (long "foo")) -< ()
  b <- asA (switch (long "bar")) -< ()
  returnA -< ConnectOpts
             { foo = f
             , bar = b }

connectParser :: Parser Command
connectParser = runA $ proc () -> do
  c <- asA connectOpts -< ()
  returnA -< Connect c

parserInfo :: ParserInfo Args
parserInfo = info parser ( progDesc "Multiprotocol tunnel" )
