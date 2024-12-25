{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    file
    nix-output-monitor
    # nix-direnv
    # nix-direnv-flakes
    tmux
    # neovim-unwrapped
    git
    ripgrep
    fd
    htop
    fastfetch
    pfetch-rs
    acpi
    python312
    wtf
    gh
    delta
    home-manager
    zoxide
    fzf
    aria2
    gnupg
    tealdeer
    bat
    yazi
    p7zip
    unixtools.xxd
    netcat-openbsd
    podman
    podman-compose
    # qemu-user
    # qemu-utils
    # qemu
    # virtiofsd
  ];
}
