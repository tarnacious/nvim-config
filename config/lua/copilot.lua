require("copilot").setup({
  suggestion = {
    enabled = true,           -- Enable Copilot suggestions
    auto_trigger = true,      -- Automatically trigger suggestions
    keymap = {
      accept = "<C-l>",       -- Accept suggestion
      prev = "<C-k>",         -- Previous suggestion
      next = "<C-j>",         -- Next suggestion
    },
  },
  panel = {
    enabled = false,          -- Disable the Copilot panel if you don't want it
  },
})
