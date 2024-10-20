{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
    	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, ... }: {
    nixosConfigurations = {
      my-nix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
	  inputs.home-manager.nixosModules.default
	  ./hosts/my-nix.nix
        ];
      };
    };
    # home-manager-mods.default = ./modules/home-manager-mods;
  };
}
