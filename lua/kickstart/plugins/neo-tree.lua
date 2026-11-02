-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    -- { '<leader>e', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.git',
        },
      },
      commands = {
        -- Open the node under the cursor with the system handler (xdg-open via vim.ui.open)
        system_open = function(state)
          local node = state.tree:get_node()
          local _, err = vim.ui.open(node.path)
          if err then
            vim.notify('Failed to open ' .. node.path .. ': ' .. err, vim.log.levels.ERROR)
          end
        end,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['gx'] = 'system_open',
        },
      },
    },
  },
}
