-- KOS (Kerbal Operating System) support
-- Requires kos-language-server: npm install -g kos-language-server
return {
  {
    'Freedzone/kerbovim',
    config = function()
      vim.lsp.config('kls', {
        cmd = { 'kls', '--stdio' },
        filetypes = { 'kerboscript' },
        root_dir = function(fname)
          return vim.fs.root(fname, { 'ksconfig.json', '.git' })
        end,
      })
      vim.lsp.enable 'kls'
    end,
  },
}
