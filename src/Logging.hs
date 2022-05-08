module Logging where


import Options


type Level = Integer


data Logger = Logger Level
  deriving (Show)


logger :: CommonOpts -> Logger
logger c = Logger $ verbosity c
