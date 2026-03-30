# nix-conf

Nix configuration using the [Dendritic pattern](https://github.com/mightyiam/dendritic) with [flake-parts](https://flake.parts) and [import-tree](https://github.com/vic/import-tree).

## Structure

```
flake.nix                        # Inputs + mkFlake + import-tree (keep minimal)
modules/
  nix/
    flake-parts.nix              # flake-parts setup (systems, flakeModules.modules)
    configurations.nix           # Shared helpers (mkStandaloneHome, unfreePredicate)
    overlays.nix                 # Nixpkgs overlay registration
  system/
    nix-settings.nix             # Nix daemon + HM nix/unfree settings
    wsl.nix                      # WSL-specific NixOS config
    users.nix                    # User accounts and groups
    system-packages.nix          # System-wide packages
    system-types/                # HM system-type inheritance chain
      system-default.nix         # Base: shell, bat, delta, direnv, zoxide, yazi, inputrc
      system-cli.nix             # Extends default: starship, tmux, git, neovim base
  programs/                      # Home Manager program aspects
    shell.nix                    # Bash, common aliases, fzf
    bat.nix                      # bat
    delta.nix                    # delta (git pager)
    direnv.nix                   # direnv + nix-direnv
    gdb.nix                      # GDB + GEF
    git.nix                      # Git with aliases, signing, credential helpers
    lsd.nix                      # lsd (ls replacement)
    neovim.nix                   # Neovim wrapper (lazy.nvim, LSPs, plugins)
    starship.nix                 # starship prompt
    uv.nix                       # uv (Python)
    yazi.nix                     # yazi file manager
    zoxide.nix                   # zoxide (cd replacement)
    _neovim/                     # Neovim internals (hidden from import-tree)
    _yazi/                       # Yazi data files (hidden from import-tree)
  hosts/                         # NixOS host definitions
    my-nix.nix                   # NixOS WSL + integrated Home Manager
  users/                         # Home Manager user definitions
    d0ublew.nix                  # d0ublew user aspect (shared by standalone + NixOS)
    d0ublew-standalone.nix       # Standalone HM wrapper for d0ublew
    kali.nix                     # Kali Linux
    williamwijaya.nix            # macOS
    mini.nix                     # Headless Linux + nixGL
  dotfiles/                      # Static config files (inputrc, tmux, ghostty, etc.)
overlays/                        # Package overlays (outside modules/)
pkgs/                            # Custom package definitions (outside modules/)
```

## Key Concepts

Every `.nix` file under `modules/` is automatically loaded by `import-tree` as a flake-parts module. Files or directories prefixed with `_` are ignored.

**Aspects** are named module definitions: `flake.modules.<class>.<name>`. Classes include `nixos`, `homeManager`, and `generic`. Hosts reference aspects via `inputs.self.modules.<class>.<name>`.

**Shared HM aspects** (`modules/programs/`) define config that multiple hosts import. Use `lib.mkDefault` for values hosts may override.

**System types** (`modules/system/system-types/`) define an inheritance chain for HM configuration. `system-default` is the base (shell, bat, delta, etc.). `system-cli` extends it with tmux, starship, git, and neovim. User modules import a system type as their base.

**User definitions** (`modules/users/`) define per-user HM aspects that import a system type and add user-specific config. Standalone wrappers call `mkStandaloneHome` to create `homeConfigurations`. **Host definitions** (`modules/hosts/`) are for NixOS system configurations.

**Program aspects** with complex internals (neovim, yazi) use a wrapper pattern: a single `.nix` flake-parts module imports a `_`-prefixed directory containing the internal HM modules. The `_` prefix hides them from `import-tree`.

## Hosts

| Name | Type | System | Description |
|------|------|--------|-------------|
| `my-nix` | NixOS + HM | x86_64-linux | WSL with integrated Home Manager |
| `d0ublew` | Standalone HM | x86_64-linux | WSL standalone |
| `kali` | Standalone HM | x86_64-linux | Kali Linux |
| `williamwijaya` | Standalone HM | aarch64-darwin | macOS |
| `mini` | Standalone HM | x86_64-linux | Headless Linux (nixGL) |

## Common Tasks

### Add a shared program

Create a new file under `modules/programs/`:

```nix
# modules/programs/ripgrep.nix
{ ... }:
{
  flake.modules.homeManager.ripgrep = {
    programs.ripgrep.enable = true;
  };
}
```

Then add `inputs.self.modules.homeManager.ripgrep` to the desired user/host files in `modules/users/` or `modules/hosts/`.

### Add a program to a single user

Add the config inline in the user's module block in `modules/users/<user>.nix`:

```nix
# modules/users/d0ublew.nix
{ inputs, ... }:
{
  flake.modules.homeManager.d0ublew = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [ system-cli ];

    # ... existing config ...

    # Add a program for just this user:
    home.packages = with pkgs; [ wireshark ];
    programs.tmux.enable = true;
  };
}
```

If the program is an existing aspect, import it in the user's `imports` list:

```nix
imports = with inputs.self.modules.homeManager; [ system-cli gdb ];
```

### Add a new NixOS aspect

Create a file under `modules/system/`:

```nix
# modules/system/printing.nix
{ ... }:
{
  flake.modules.nixos.printing = {
    services.printing.enable = true;
  };
}
```

Then add `inputs.self.modules.nixos.printing` to the NixOS host in `modules/hosts/<host>.nix`.

### Add a new user

Create two files — an aspect defining the user's config, and a standalone wrapper:

```nix
# modules/users/alice.nix — user aspect
{ inputs, ... }:
{
  flake.modules.homeManager.alice = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [ system-cli ];
    home.username = "alice";
    home.homeDirectory = "/home/alice";
    git-mod.username = "alice";
    # user-specific packages, shell config, etc.
  };
}

# modules/users/alice-standalone.nix — standalone HM wrapper
{ inputs, config, ... }:
{
  flake.homeConfigurations."alice" = config.flake.lib.mkStandaloneHome {
    system = "x86_64-linux";
    stateVersion = "25.05";
    extraModules = [
      inputs.self.modules.homeManager.nix-settings
      inputs.self.modules.homeManager.alice
    ];
  };
}
```

The user aspect imports a system type (`system-cli` or `system-default`) which brings in all shared programs. `mkStandaloneHome` just provides `pkgs` and `home.stateVersion`.

### Add a new flake input

Add the input to `flake.nix`, then reference it via `inputs.<name>` in any module file (flake-parts passes `inputs` to every module automatically).

### Temporarily disable a feature

Prefix the file or directory with `_`:

```
mv modules/programs/starship.nix modules/programs/_starship.nix
```

### Add an LSP to neovim

Create a new directory under `modules/programs/_neovim/lsp/<lang>/` with `default.nix` and `spec.lua`, then add the import to `modules/programs/_neovim/lsp/default.nix`. Enable it per-user with `neovim-mod.lsp.<lang>.enable = true`.

### Override a shared aspect per-host

Shared aspects should use `lib.mkDefault` for overridable values. Hosts can then set the value directly:

```nix
# In the host's inline module:
programs.lsd.icons = false;  # overrides the mkDefault true from lsd.nix
```

## Building

```bash
# macOS
nix build .#homeConfigurations.williamwijaya.activationPackage

# Standalone HM (any Linux host)
nix build .#homeConfigurations.d0ublew.activationPackage

# NixOS
nix build .#nixosConfigurations.my-nix.config.system.build.toplevel

# Dry-run (no actual build, just evaluate)
nix build .#homeConfigurations.williamwijaya.activationPackage --dry-run
```

## Applying

```bash
# macOS / standalone Linux
home-manager switch --flake .#williamwijaya

# NixOS (on the target machine)
sudo nixos-rebuild switch --flake .#my-nix
```
