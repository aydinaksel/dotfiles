{
  description = "Aydin's dotfiles";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      homeConfigurations."zeus" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            home.username = "aydin";
            home.homeDirectory = "/home/aydin";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
              bat
              dust
              gitui
              just
              mdbook
              neovim
              nil
              nixfmt
              nushell
              qrrs
              ripgrep
              rustlings
              starship
              tree-sitter
              xh
              zellij
            ];
          }
        ];
      };

      homeConfigurations."hades" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            home.username = "aydin";
            home.homeDirectory = "/home/aydin";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
              mdbook
              nil
              nixfmt
              ripgrep
              snowflake-cli
              starship
              tree-sitter
            ];
          }
        ];
      };

      homeConfigurations."darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          {
            home.username = "aydin";
            home.homeDirectory = "/Users/aydin";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };

            home.packages = with nixpkgs.legacyPackages.aarch64-darwin; [
              nil
              nixfmt
              ripgrep
              starship
              tree-sitter
            ];
          }
        ];
      };
    };
}
