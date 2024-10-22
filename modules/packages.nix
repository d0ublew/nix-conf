{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nix-output-monitor
    tmux
    neovim
    git
    ripgrep
    fd
    htop
    neofetch
    acpi
    python312
    wtf
    gh
    delta
    home-manager
  ];
}
