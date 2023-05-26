{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let modules = [
      ./system-config.nix
      home-manager.nixosModules.home-manager
      ./home-manager-config.nix
    ];
    in {
      nixosConfigurations = {
        nixos-utm = nixpkgs.lib.nixosSystem { inherit modules; system = "aarch64-linux" };
      };
    };
  };
}
