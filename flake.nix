{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
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
      nixgl,
      home-manager,
      ...
    }@inputs:
    let
      uname = "d0ublew";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [ nixgl.overlay ];
      # };
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      mylib = import ./libs { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib.extend (final: prev: { my = mylib; });
      unfree-pkgs = [
        "ngrok"
      ];
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
            inherit unfree-pkgs;
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
              home-manager.users."${uname}" = import ./home/wsl.nix;
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
            inherit unfree-pkgs;
          };
          modules = [
            ./home/wsl.nix
            ./overlays
          ];
        };
        kali = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit lib;
          extraSpecialArgs = {
            uname = "kali";
            inherit pkgs-stable;
            inherit unfree-pkgs;
          };
          modules = [
            ./home/kali.nix
            ./overlays
          ];
        };
        williamwijaya = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          inherit lib;
          extraSpecialArgs = {
            pkgs-stable = nixpkgs-stable.legacyPackages.aarch64-darwin;
            uname = "williamwijaya";
            inherit unfree-pkgs;
          };
          modules = [
            ./home/mac.nix
            ./overlays
          ];
        };
        "mini" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit lib;
          extraSpecialArgs = {
            uname = "kali";
            inherit pkgs-stable;
            inherit unfree-pkgs;
            inherit nixgl;
          };
          modules = [
            ./home/mini.nix
            ./overlays
          ];
        };
      };
    };
}
