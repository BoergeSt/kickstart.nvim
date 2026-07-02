-- Pretty in-buffer markdown rendering (glow-like). Rendering is toggled off
-- for the cursor line, so the raw markers show up right where you edit.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown' },
  opts = {},
}
