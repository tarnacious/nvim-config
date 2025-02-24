require("copilot").setup({
  suggestion = {
    enabled = true,           -- Enable Copilot suggestions
    auto_trigger = true,      -- Automatically trigger suggestions
    keymap = {
      accept = "<C-Right>",    -- Accept suggestion
      prev = "<C-Left>",       -- Previous suggestion
      next = "<C-Down>",       -- Next suggestion
    },
  },
  panel = {
    enabled = false,          -- Disable the Copilot panel if you don't want it
  },
})
