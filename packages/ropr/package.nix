{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "ropr";
  version = "0.2.25";
  src = pkgs.fetchFromGitHub {
    owner = "Ben-Lichtman";
    repo = "ropr";
    rev = version;
    hash = "sha256-LfQp7knYlwzxyfA7NolYu9RQQAR3eBir6ULEiUOhQ7s=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-E1p4xfXNPbaPh5tE6uTkmmMsVk39NXNM8hhWpspTQjs=";
}
