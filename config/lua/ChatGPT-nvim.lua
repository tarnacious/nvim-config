require("chatgpt").setup({
  api_key_cmd = "pass openai/vim"
})
vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>ChatGPT<cr>", { noremap = true })
