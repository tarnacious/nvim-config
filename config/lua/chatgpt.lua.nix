{ pkgs } : let

  actions = builtins.map (file:
       pkgs.writeTextFile {
         name = file;
         text = builtins.readFile ../resources/chatgpt/${file};
      } 
    )
    (builtins.attrNames (builtins.readDir ../resources/chatgpt));


  actionPaths = builtins.concatStringsSep ", " (builtins.map (action: "\"" + action + "\"") actions);
in
  ''
  function ChatGPTSetup()
    require("chatgpt").setup({
      api_key_cmd = "pass openai/vim",
      actions_paths = { ${actionPaths} }
    })
    vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>ChatGPT<cr>", { noremap = true })
  end

  vim.cmd("command! ChatGPTSetup lua ChatGPTSetup()")
  ''
