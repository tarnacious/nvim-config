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
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    in
    {
      # this kinda get repeated because I'm not sure how to do it better yet
      packages = nixpkgs.lib.genAttrs supportedSystems (system:
        let
          overlay-neovim = prev: final: {
            neovim = neovim.packages.${system}.neovim;
          };

          overlay-custom-neovim = prev: final: {
            custom-neovim = import ./custom-neovim.nix {
              pkgs = final;
            };
          };

          pkgs = import nixpkgs {
            system = system;
            overlays = [ overlay-neovim overlay-custom-neovim ];
          };

        in {
          default = pkgs.custom-neovim;
        }
      );

      apps = nixpkgs.lib.genAttrs supportedSystems (system:
        let
          overlay-neovim = prev: final: {
            neovim = neovim.packages.${system}.neovim;
          };

          overlay-custom-neovim = prev: final: {
            custom-neovim = import ./custom-neovim.nix {
              pkgs = final;
            };
          };

          pkgs = import nixpkgs {
            system = system;
            overlays = [ overlay-neovim overlay-custom-neovim ];
          };

        in {
          apps.${system}.default = {
            type = "app";
            program = "${pkgs.custom-neovim}/bin/nvim";
          };
        }
      );
    };

}

