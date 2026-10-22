-- SPDX-FileCopyrightText: 2026 Progmasoft <support@progmasoft.com>
-- SPDX-License-Identifier: MPL-2.0 WITH AdditionRef-Progmasoft-Exception-1.1

{- | The version of the analyzer, read from the Cabal package so that
@--version@, the LSP server information and the package can never disagree.
-}
module Progmasoft.TalaAnalyzer.Version
    ( analyzerName
    , analyzerVersion
    ) where

import Data.Version (showVersion)
import Paths_tala_analyzer (version)

-- | The name clients see in the server information.
analyzerName :: String
analyzerName = "tala-analyzer"

-- | The package version, such as @0.1.0@.
analyzerVersion :: String
analyzerVersion = showVersion version
