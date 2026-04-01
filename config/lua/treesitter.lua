-- nvim-treesitter v1+ no longer uses the configs module.
-- Neovim 0.11 has treesitter built-in; parsers are provided via nix withAllGrammars.
-- Enable treesitter-based highlighting for all buffers.
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
