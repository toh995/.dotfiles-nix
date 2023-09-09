{
  description = "NixOS Config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { home-manager, nixpkgs, nixpkgs-stable, nur, ... }: 
    let
      stable-overlay = final: prev: {
        stable = nixpkgs-stable.legacyPackages.${prev.system};
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nur.nixosModules.nur
          { nixpkgs.overlays = [stable-overlay nur.overlay]; }
          ./modules/hardware-config.nix
          ./modules/system-config.nix
          home-manager.nixosModules.home-manager
          ./modules/home-manager
        ];
      };
    };
}
