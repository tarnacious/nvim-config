{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  #secrets = import ../.secrets/secrets.nix;
  plugins = import ../plugins.nix { inherit pkgs; };
  runtimeDeps = import ../runtimeDeps.nix { inherit pkgs; };
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = runtimeDeps.deps;
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
