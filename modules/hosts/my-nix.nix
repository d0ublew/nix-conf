{ inputs, ... }:
let
  system = "x86_64-linux";
  uname = "d0ublew";
in
{
  flake.nixosConfigurations."my-nix" = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      inputs.nixos-wsl.nixosModules.default
      inputs.nix-ld.nixosModules.nix-ld
      { programs.nix-ld.dev.enable = true; }
      inputs.home-manager.nixosModules.home-manager
      inputs.self.modules.nixos.nix-settings
      inputs.self.modules.nixos.wsl
      inputs.self.modules.nixos.users
      inputs.self.modules.nixos.system-packages
      {
        system.stateVersion = "24.05";
        networking.hostName = "my-nix";
        time.timeZone = "Asia/Jakarta";
        nixpkgs.overlays = builtins.attrValues inputs.self.overlays;
        unfree-pkgs = [ "ngrok" ];
        wsl-mod.enable = true;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${uname} = {
          imports = [
            inputs.self.modules.homeManager.d0ublew
          ];
          home.stateVersion = "24.05";
        };
      }
    ];
  };
}
