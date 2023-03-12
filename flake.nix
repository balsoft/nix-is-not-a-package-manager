{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-pandoc.url = "github:serokell/nix-pandoc";
  inputs.pandoc-lua-filters = {
    url = "github:pandoc/lua-filters";
    flake = false;
  };
  inputs.beamer-mtheme = {
    url = "github:matze/mtheme";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, nix-pandoc, beamer-mtheme
    , pandoc-lua-filters }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default =
          (pkgs.extend nix-pandoc.overlay).callPackage ./presentation.nix {
            inherit pandoc-lua-filters beamer-mtheme;
          };
      });
}
