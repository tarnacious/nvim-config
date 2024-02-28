{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };

  deps = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.pyright
  ];

  plugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    nerdtree
    telescope-nvim
    plenary-nvim
    nui-nvim
    ChatGPT-nvim
    tokyonight-nvim
    solarized-nvim
  ];

  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = deps;
  };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ neovimRuntimeDependencies ];
  #text = ''
  #  OPENAI_API_KEY=${secrets.openai-api-key} ${myNeovimUnwrapped}/bin/nvim "$@"
  #'';
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
