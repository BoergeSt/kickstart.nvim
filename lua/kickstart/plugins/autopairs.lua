-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {}

    -- SystemVerilog uses ' heavily for based literals (8'hFF), assignment
    -- patterns ('{...}), and '0/'1/'x/'z -- not as a string delimiter.
    local cond = require 'nvim-autopairs.conds'
    for _, rule in ipairs(npairs.get_rules "'") do
      rule:with_pair(cond.not_filetypes { 'systemverilog' })
    end
  end,
}
