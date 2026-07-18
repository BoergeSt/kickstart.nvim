vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

-- Ligature-aware terminals (e.g. Ghostty) only fuse "<=" into a single glyph
-- when both characters carry identical highlight attributes. Nudge the "<"
-- of the non-blocking assignment operator one shade off from "@operator"
-- (imperceptible) so that specific run breaks, while the "<=" relational
-- (less-or-equal) operator is left untouched and still ligates as "≤".
-- The distinction comes from the treesitter tree: only the "<=" token that
-- is a direct child of a `nonblocking_assignment` node gets the treatment.
local ns = vim.api.nvim_create_namespace 'sv_nonblocking_break'
local query = vim.treesitter.query.parse('systemverilog', '(nonblocking_assignment) @assign')

local function sync_break_hl()
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = '@operator', link = false })
  if not ok or not hl.fg then
    return
  end
  local blue = hl.fg % 256
  blue = (blue == 0) and 1 or (blue - 1)
  local shifted = (hl.fg - (hl.fg % 256)) + blue
  vim.api.nvim_set_hl(0, 'SVNonblockingBreak', vim.tbl_extend('force', hl, { fg = shifted }))
end

sync_break_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('sv_nonblocking_break_colors', { clear = true }),
  callback = sync_break_hl,
})

-- row -> column of the "<" to recolor, refreshed per redraw in on_win
local break_cols = {}

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr, topline, botline)
    if vim.bo[bufnr].filetype ~= 'systemverilog' then
      return false
    end
    local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr, 'systemverilog')
    if not ok_parser or not parser then
      return false
    end
    local root = parser:parse()[1]:root()
    break_cols = {}
    for _, node in query:iter_captures(root, bufnr, topline, botline + 1) do
      for child in node:iter_children() do
        if child:type() == '<=' then
          local srow, scol = child:range()
          break_cols[srow] = scol
        end
      end
    end
  end,
  on_line = function(_, _, bufnr, row)
    local col = break_cols[row]
    if not col then
      return
    end
    vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
      end_col = col + 1,
      hl_group = 'SVNonblockingBreak',
      priority = 200,
      ephemeral = true,
    })
  end,
})
