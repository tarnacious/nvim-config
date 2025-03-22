vim.g.mapleader = ','

vim.cmd('colorscheme tokyonight-night')

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.termguicolors = true

vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+yg', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>yy', '"+yy', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>P', '"+P', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>P', '"+P', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fn', ':let @+=expand("%:p")<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tf", function()
  local filename = vim.fn.expand("%")
  vim.cmd("split | terminal npm test " .. filename)
end, { desc = "Run npm test on current file" })

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99  -- don't auto fold


vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]


vim.g['plantuml_previewer#viewer_path'] = '~/.plantuml'
