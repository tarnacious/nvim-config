{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, neovim }:
    let
      overlay-neovim = prev: final: {
        neovim = neovim.packages.x86_64-linux.neovim;
      };

      overlay-custom-neovim = prev: final: {
        custom-neovim = import ./packages/custom-neovim.nix {
          pkgs = final;
        };
      };

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlay-neovim overlay-custom-neovim ];
      };

    in {
      packages.x86_64-linux.default = pkgs.custom-neovim;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${pkgs.custom-neovim}/bin/nvim";
      };
    };
}

