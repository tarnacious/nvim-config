{ pkgs } : let
  configDir = pkgs.stdenv.mkDerivation {
    name = "chat-gpt-actions";
    src = ../json;
    installPhase = ''
      mkdir -p $out/
      cp ./* $out/
    '';
  };
  actions = (builtins.attrNames (builtins.readDir configDir));

  paths = builtins.map (file: "\"" + configDir + "/" + file + "\"") actions;
  str = builtins.concatStringsSep ", " paths;
in
  ''
  require("chatgpt").setup({
    api_key_cmd = "pass openai/vim",
    actions_paths = { ${str} }
  })
  vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>ChatGPT<cr>", { noremap = true })
  ''
