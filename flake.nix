{
  description = "Aydin's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nixgl,
      ...
    }:
    let
      unfreePackages = [ "claude-code" ];
      allowUnfree =
        package:
        builtins.elem (package.pname or (builtins.parseDrvName package.name).name) unfreePackages;
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfreePredicate = allowUnfree;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      homeConfigurations."aydin@zeus" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [ ./hosts/zeus ];
      };

      homeConfigurations."aydin@hades" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [ ./hosts/hades ];
      };

      homeConfigurations."aydin@poseidon" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [ ./hosts/hades ];
      };

      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/macbook
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfreePredicate = allowUnfree;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aydinaksel = import ./hosts/macbook/home.nix;
          }
        ];
      };
    };
}
