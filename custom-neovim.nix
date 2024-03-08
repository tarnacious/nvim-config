{ pkgs }:
let
  customRC = import ./load-config.nix { inherit pkgs; };

  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    nerdtree
    telescope-nvim
    plenary-nvim
    nui-nvim
    nvim-treesitter
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
    nodePackages.pyright
    nil
    ripgrep
    fd
  ];
  text = ''
    ${customNeovim}/bin/nvim "$@"
  '';
}
