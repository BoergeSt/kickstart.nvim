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

      should_attach = function(bufnr, bufname)
        local bo = vim.bo[bufnr]

        -- keep upstream/default behavior
        if not bo.buflisted then
          return false
        end

        if bo.buftype ~= '' then
          return false
        end

        -- disable Copilot for .env and .env.*
        local name = vim.fn.fnamemodify(bufname, ':t')
        if name == '.env' or name:match '^%.env%..+' then
          return false
        end

        return true
      end,

      filetypes = {
        bitbake = true,
        c = true,
        cmake = true,
        cpp = true,
        dts = true,
        json = true,
        kconfig = true,
        lua = true,
        make = true,
        python = true,
        sh = true,
        yaml = true,
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
