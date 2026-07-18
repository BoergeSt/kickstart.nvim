# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It uses **lazy.nvim** as the plugin manager and is structured around two layers:

- `lua/kickstart/plugins/` — lightly-modified kickstart defaults (autopairs, gitsigns, neo-tree)
- `lua/custom/plugins/` — personal additions and overrides

The entry point is `init.lua`, which sets global options/keymaps and calls `require('lazy').setup(...)` with both layers.

## Formatting

Lua code is formatted with **StyLua**. Run it before committing:

```bash
stylua .
```

Check only (CI uses this):
```bash
stylua --check .
```

## Plugin Architecture

**Completion stack:** `blink.cmp` (v1.*) with `LuaSnip` snippets, `blink-copilot` (Copilot source), and `cmp-dap` for DAP REPL completion. Sources switch automatically: DAP buffers get `{ 'dap', 'snippets', 'buffer' }`, normal buffers get `{ 'lsp', 'path', 'snippets', 'lazydev', 'copilot' }`.

**LSP setup:** `nvim-lspconfig` + `mason` + `mason-lspconfig`. Servers are declared in `lua/custom/plugins/lsp.lua` (`servers` table). Additional server configs can be dropped as separate files under `lua/custom/plugins/lsp/*.lua` — the file is auto-discovered and merged into the `servers` table at startup. Currently active servers: `lua_ls`, `texlab`, `zls`, `bashls`, `clangd`, `yamlls`, `pylsp`, `verible`.

**SystemVerilog:** `verible` (Mason-installed) provides the LSP (`verible-verilog-ls`, covering linting via its diagnostics) for `verilog`/`systemverilog` filetypes, and its formatter (`verible-verilog-format`) is wired into conform.nvim's `formatters_by_ft`. Treesitter highlighting uses the `verilog` parser (nvim-treesitter maps the `systemverilog` filetype to it automatically).

**Python LSP special handling:** `lua/custom/plugins/lsp/python.lua` hooks into `mason-registry`'s `package:install:success` event to auto-install a large set of pylsp/ruff plugins into Mason's pylsp venv immediately after `python-lsp-server` is installed. Logs go to `vim.fn.stdpath('data') .. '/mason_pylsp.log'`.

**Copilot:** Uses `zbirenbaum/copilot.lua` (not `github/copilot.vim`). Suggestions/panel are disabled in favour of the `blink-copilot` completion source. Copilot is explicitly disabled for `.env` and `.env.*` files via a custom `should_attach` function. Only enabled for an explicit allowlist of filetypes (`bitbake`, `c`, `cmake`, `cpp`, `dts`, `json`, `kconfig`, `lua`, `make`, `python`, `sh`, `yaml`).

**Debugging:** `nvim-dap` with `nvim-dap-view` UI, `mason-nvim-dap` for adapter installation, and `nvim-dap-python` configured with `debugpy-adapter`. DAP keymaps: `<F5>` continue, `<F1>/<F2>/<F3>` step into/over/out, `<leader>b` toggle breakpoint, `<F7>` toggle DAP view.

**Testing:** `neotest` with `neotest-python` adapter (pytest runner, verbose output with `log_cli=true`). Keymaps under `<leader>t` prefix.

## Key Keymaps

- `<leader>` = Space
- `<leader>f` — format buffer (conform.nvim)
- `<leader>lg` — LazyGit
- `<leader>cc` — CopilotChat
- `<leader>v` — VenvSelect (Python files only)
- `<leader>sh/sf/sg/sw/sd` — Telescope search (help/files/grep/word/diagnostics)
- `<leader><leader>` — Telescope buffers
- `grn/gra/grr/grd/gri/grt` — LSP rename/action/references/definition/implementation/type-def
- `` ` `` — lua-console toggle

## Adding a New LSP Server

1. Add the server name (and any settings) to the `servers` table in `lua/custom/plugins/lsp.lua`, **or**
2. Create `lua/custom/plugins/lsp/<name>.lua` returning a table of `{ server_name = { settings = ... } }` — it will be auto-merged on startup.

Mason will auto-install the server on next Neovim start.

## Adding a New Plugin

Create a new file `lua/custom/plugins/<name>.lua` returning a lazy.nvim plugin spec table. It is automatically imported via `{ import = 'custom.plugins' }` in `init.lua`.
