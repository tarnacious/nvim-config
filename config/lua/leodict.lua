function openSelectedWordInBrowser()
  local selected_word = vim.fn.expand("<cWORD>")
  local url = "https://dict.leo.org/german-english/" .. selected_word
  local job_id = vim.fn.jobstart({"xdg-open", url})
end

vim.api.nvim_set_keymap('n', '<Leader>g', '<cmd>lua openSelectedWordInBrowser()<CR>', { noremap = true, silent = true })

