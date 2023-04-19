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
      culug-cal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/nix-cal/configuration.nix ];
      };
      culug-chat = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/nix-chat/configuration.nix ];
      };
      # Used for CI/GitHub Actions
      nixos-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [ ./hosts/generic-server/configuration.nix ];
      };
    };
  };
}
