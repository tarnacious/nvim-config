require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    vim.keymap.set('n', ']c', function() gs.next_hunk() end, { buffer = bufnr })
    vim.keymap.set('n', '[c', function() gs.prev_hunk() end, { buffer = bufnr })
  end
})
