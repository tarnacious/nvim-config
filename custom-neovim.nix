{ pkgs }:
let
  customRC = import ./load-config.nix { inherit pkgs; };

   

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

  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };

  # Combining these two dependency lists doesn't work properly for some reason.
  # The issue is described here: https://primamateria.github.io/blog/neovim-nix/#add-runtime-dependency

  nodeDeps = with pkgs; [
    nodePackages.typescript-language-server
    nodePackages.pyright
  ];

  rootDeps = with pkgs; [
    nil
  ];

  nodeDependencies = pkgs.symlinkJoin {
    name = "nodeDependencies";
    paths = nodeDeps;
  };

  rootDependencies = pkgs.symlinkJoin {
    name = "rootDependencies";
    paths = rootDeps;
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ nodeDependencies rootDependencies ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
