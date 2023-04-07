{
  description = "NixOS flake for Central Utah LUG";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      culug-pomerium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/nix-pomerium/configuration.nix ];
      };
      nixos-server-intel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/generic-server/configuration.nix ];
      };
    };
  };
}
