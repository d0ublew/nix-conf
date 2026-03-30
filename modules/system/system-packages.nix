{ ... }:
{
  flake.modules.nixos.system-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        file
        nix-output-monitor
        tmux
        git
        ripgrep
        fd
        htop
        fastfetch
        pfetch-rs
        acpi
        python312
        wtfutil
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
        elfutils
        gdb
        jq
        dig
        openssl
      ];
    };
}
