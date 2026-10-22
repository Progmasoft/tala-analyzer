<!-- SPDX-FileCopyrightText: 2026 Progmasoft <support@progmasoft.com> -->
<!-- SPDX-License-Identifier: MPL-2.0 WITH AdditionRef-Progmasoft-Exception-1.1 -->

# Changelog

## Unreleased

## 0.1.0 - 2026-10-22

The first release of tala-analyzer from a repository of its own. Until now the
analyzer lived in the Tala repository, last as version 0.3.3; it moved with its
history and starts its own numbering.

- `tala-analyzer` is a stdio language server: diagnostics and document symbols
  for `.tala` files, from the compiler of Tala 0.1.0 through `tala-tooling`,
  pinned to the `tala-0.1.0` commit of Progmasoft/tala until the compiler
  packages are on Hackage.
- `tala-analyzer --version` and `--help` answer without starting the server,
  `--stdio` names the default transport, and any other argument is an error
  (exit status 2). The server reports its package version to the client.
- `tala-analyzer.kts` configures it through a typed Kotlin model.
- The IntelliJ Platform plugin and the VS Code extension start the server; they
  are not published to a marketplace yet.
