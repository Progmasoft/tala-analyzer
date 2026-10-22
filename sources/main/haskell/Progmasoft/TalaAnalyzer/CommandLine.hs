-- SPDX-FileCopyrightText: 2026 Progmasoft <support@progmasoft.com>
-- SPDX-License-Identifier: MPL-2.0 WITH AdditionRef-Progmasoft-Exception-1.1

{- | The command line of @tala-analyzer@ as values.

@
tala-analyzer            serve LSP over stdin and stdout
tala-analyzer --stdio    the same, as editors that name the transport start it
tala-analyzer --version  print the version
tala-analyzer --help     print the usage
@

The parser is written by hand. Every accepted line is a 'Command' and every
rejected one a 'CommandLineError'; nothing later looks at an argument again.
-}
module Progmasoft.TalaAnalyzer.CommandLine
    ( Command (..)
    , CommandLineError (..)
    , parseCommandLine
    , renderCommandLineError
    , usageText
    ) where

-- | One invocation of the analyzer.
data Command
    = -- | Serve the language server protocol over stdin and stdout.
      Serve
    | ShowHelp
    | ShowVersion
    deriving (Eq, Show)

-- | Why a command line was rejected.
data CommandLineError
    = -- | An option the analyzer does not have.
      UnknownOption String
    | -- | A positional argument; the analyzer reads documents from its client.
      UnexpectedArgument String
    | -- | More than one option, such as @--stdio --version@.
      TooManyArguments [String]
    deriving (Eq, Show)

{- | Read the arguments. Help and version requests answer and exit; any other
argument is an error rather than ignored, so a client that passes an option
this version does not have learns it at once instead of at the first request.
-}
parseCommandLine :: [String] -> Either CommandLineError Command
parseCommandLine arguments = case arguments of
    [] -> Right Serve
    [argument] -> single argument
    _ -> Left (TooManyArguments arguments)
  where
    single argument
        | argument == "--stdio" = Right Serve
        | argument `elem` ["--help", "-h"] = Right ShowHelp
        | argument `elem` ["--version", "-v"] = Right ShowVersion
        | take 1 argument == "-" = Left (UnknownOption argument)
        | otherwise = Left (UnexpectedArgument argument)

-- | The message of an error, without the program name.
renderCommandLineError :: CommandLineError -> String
renderCommandLineError problem = case problem of
    UnknownOption option -> "unknown option " ++ option ++ "; see --help"
    UnexpectedArgument argument ->
        "unexpected argument " ++ argument ++ "; the analyzer reads documents from its LSP client"
    TooManyArguments arguments -> "expected at most one option, got " ++ unwords arguments

-- | What @--help@ prints.
usageText :: String
usageText =
    unlines
        [ "Usage: tala-analyzer [--stdio | --version | --help]"
        , ""
        , "Serves the Tala language server protocol over stdin and stdout."
        , "An editor starts it; it is not meant to be run by hand."
        , ""
        , "Options:"
        , "  --stdio        serve over stdin and stdout (the default)"
        , "  -v, --version  print the version and exit"
        , "  -h, --help     print this text and exit"
        ]
