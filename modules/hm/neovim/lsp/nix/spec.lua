local uv = vim.loop

local dir
if uv.fs_stat(vim.fn.expand("~/config")) then
  dir = vim.fn.expand("~/config")
elseif uv.fs_stat("~/nix-conf") then
  dir = vim.fn.expand("~/nix-conf")
elseif uv.fs_stat("/etc/nixos") then
  dir = "/etc/nixos"
else
  dir = vim.fn.expand("~/.config/nixpkgs")
end

local hostname = uv.os_gethostname()

return {
  formatters = {
    "nixfmt",
  },
  servers = {
    {
      name = "nixd",
      config = {
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
            options = {
              nixos = {
                expr = string.format(
                  '(builtins.getFlake "git+file://%s").nixosConfigurations."%s".options',
                  dir,
                  hostname
                ),
              },
              nix_darwin = {
                expr = string.format(
                  '(builtins.getFlake "git+file://%s").darwinConfigurations."%s".options',
                  dir,
                  hostname
                ),
              },
              home_manager = {
                expr = string.format(
                  '(builtins.getFlake "git+file://%s").homeConfigurations."%s".options',
                  dir,
                  os.getenv("USER")
                ),
              },
            },
          },
        },
      },
    },
  },
}
