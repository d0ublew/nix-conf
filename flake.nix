{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-wsl,
      nix-ld,
      home-manager,
      ...
    }@inputs:
    let
      uname = "d0ublew";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      mylib = import ./libs { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib.extend (final: prev: { my = mylib; });
    in
    {
      nixosConfigurations = {
        "my-nix" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit uname;
            inherit system;
            inherit lib;
            inherit pkgs-stable;
          };
          modules = [
            nixos-wsl.nixosModules.default
            nix-ld.nixosModules.nix-ld
            {
              programs.nix-ld.dev.enable = true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${uname}" = import ./modules/home.nix;
              home-manager.extraSpecialArgs = {
                inherit uname;
              };
            }
            ./hosts/my-nix.nix
            {
              wsl-mod.enable = true;
            }
          ];
        };
      };
      homeConfigurations = {
        "${uname}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit lib;
          extraSpecialArgs = {
            inherit uname;
            inherit pkgs-stable;
          };
          modules = [
            ./modules/home.nix
            ./overlays
          ];
        };
        kali = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit lib;
          extraSpecialArgs = {
            inherit uname;
            inherit pkgs-stable;
          };
          modules = [
            ./modules/kali-home.nix
            ./overlays
          ];
        };
      };
    };
}
