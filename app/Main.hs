-- SPDX-FileCopyrightText: 2026 Progmasoft <support@progmasoft.com>
-- SPDX-License-Identifier: MPL-2.0 WITH AdditionRef-Progmasoft-Exception-2.0

{- | Stdio-only entry point. LSP reserves stdout for protocol frames, so all
diagnostic logging and transport failures go to stderr in the transport layer.
Only @--help@ and @--version@ write to stdout, and they serve nothing.
-}
module Main (main) where

import Progmasoft.TalaAnalyzer.CommandLine
import Progmasoft.TalaAnalyzer.Server (runAnalyzerServer)
import Progmasoft.TalaAnalyzer.Version (analyzerName, analyzerVersion)
import System.Environment (getArgs)
import System.Exit (ExitCode (..), exitWith)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
    arguments <- getArgs
    case parseCommandLine arguments of
        Left problem -> do
            hPutStrLn stderr (analyzerName ++ ": " ++ renderCommandLineError problem)
            exitWith (ExitFailure usageError)
        Right ShowHelp -> putStr usageText
        Right ShowVersion -> putStrLn (analyzerName ++ " " ++ analyzerVersion)
        Right Serve -> do
            status <- runAnalyzerServer
            if status == 0 then pure () else exitWith (ExitFailure status)

-- | Exit status of a command line that could not be read.
usageError :: Int
usageError = 2
