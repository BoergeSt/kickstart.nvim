return {
  -- { 'github/copilot.vim' },
  { 'zbirenbaum/copilot.lua', dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  }, cmd = 'Copilot', event = 'InsertEnter', opts = {} },
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = {
  --     { 'nvim-lua/plenary.nvim', branch = 'master' },
  --   },
  --   build = 'make tiktoken',
  --   opts = { -- See Configuration section for options
  --   },
  -- },
}
