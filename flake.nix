{
  description = "Aydin's dotfiles";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "github:nix-community/home-manager";
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
              nil
              nixfmt
              ripgrep
              starship
              tree-sitter
              neovim
              gitui
              nushell
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
