module Logging where

type Level = Integer

data Logger = Logger Level
  deriving (Show)
