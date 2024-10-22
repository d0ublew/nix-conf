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

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs: 
    let
      uname = "d0ublew";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        my-nix = nixpkgs.lib.nixosSystem {
	  inherit system;
          specialArgs = { inherit inputs uname system; };
          modules = [
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users."${uname}" = import ./modules/home.nix;
	      home-manager.extraSpecialArgs = { inherit uname; };
	    }
            ./hosts/my-nix.nix
          ];
        };
      };
      homeConfigurations = {
        "d0ublew" = home-manager.lib.homeManagerConfiguration {
	  inherit pkgs;
	  extraSpecialArgs = { inherit uname; };
          modules = [
            ./modules/home.nix
          ];
        };
      };
  };
}
