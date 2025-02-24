{ pkgs }:
let
  customRC = import ./load-config.nix { inherit pkgs; };

  plugins = with pkgs.vimPlugins; [
    nerdtree
    telescope-nvim
    plenary-nvim
    nui-nvim

    nvim-treesitter
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-lspconfig

    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-cmdline

    plantuml-syntax
    plantuml-previewer-vim
    open-browser-vim

    ChatGPT-nvim
    tokyonight-nvim
    solarized-nvim
  ];

  customNeovim = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };

in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = with pkgs; [
    nodePackages.typescript-language-server
    pyright
    nil
    ruff
    ruff-lsp
    ripgrep
    fd
    graphviz
  ];
  text = ''
    ${customNeovim}/bin/nvim "$@"
  '';
}
