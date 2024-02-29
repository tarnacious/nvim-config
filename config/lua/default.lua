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
