local opt = { noremap = true }
local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({})
require("telescope").load_extension("vim_bookmarks")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', ';', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>b', telescope.extensions.vim_bookmarks.all, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
