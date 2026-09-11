return {
  harper_ls = {
    -- nvim-lspconfig's default filetypes list, plus mail/text. harper-ls is
    -- NOT auto-attached (see lsp.lua, which skips it in the vim.lsp.enable
    -- loop) -- it's attached on demand via <leader>tg. Native 'spell' is
    -- enabled for these same filetypes for always-on spell checking; see
    -- lsp.lua's spellcheck-filetypes autocmd.
    filetypes = {
      'asciidoc',
      'c',
      'cpp',
      'cs',
      'gitcommit',
      'go',
      'html',
      'java',
      'javascript',
      'lua',
      'mail',
      'markdown',
      'nix',
      'python',
      'ruby',
      'rust',
      'swift',
      'tex',
      'text',
      'toml',
      'typescript',
      'typescriptreact',
      'haskell',
      'cmake',
      'typst',
      'php',
      'dart',
      'clojure',
      'sh',
    },
  },
}
