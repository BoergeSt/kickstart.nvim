return {
  -- { 'github/copilot.vim' },
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp',
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        c = true,
        cpp = true,
        dts = true,
        kconfig = true,
        lua = true,
        make = true,
        python = true,
        sh = true,
        yaml = true,
        json = true,
        ['*'] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = { -- See Configuration section for options
    },
    keys = {
      { '<leader>cc', '<cmd>CopilotChat<cr>', desc = 'Open Copilot Chat' },
    },
  },
}
