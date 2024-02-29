{
  description = "NixOS Config";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    home-manager,
    nixpkgs,
    nur,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nur.nixosModules.nur
        {nixpkgs.overlays = [nur.overlay];}
        ./modules/hardware-config.nix
        ./modules/system-config.nix
        home-manager.nixosModules.home-manager
        ./modules/home-manager
      ];
    };
  };
}
