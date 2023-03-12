{ runCommand, mkDoc, texlive, pandoc, fontconfig, fira, python3, which
, proselint, pandoc-lua-filters, beamer-mtheme, stdenv }:
let
  texlive-packages = {
    inherit (texlive)
      scheme-small noto mweights cm-super cmbright fontaxes beamer minted
      fvextra catchfile xstring framed pgfopts;
  };

  texlive-combined = texlive.combine texlive-packages;

  mtheme = stdenv.mkDerivation {
    name = "beamer-theme-metropolis";
    src = beamer-mtheme;
    buildInputs = [ texlive-combined ];
    buildPhase = "make sty";
    installPhase = "mkdir -p $out; cp *.sty $out";
  };

in mkDoc {
  name = "nix-is-not-a-package-manager";
  src = ./.;
  font = fira;
  inherit texlive-combined;
  LUA_FILTERS = pandoc-lua-filters;
  HOME = "/build";
  extraTexInputs = [ mtheme ];
  extraBuildInputs = [ which python3.pkgs.pygments ];
  checkInputs = [ proselint ];
  checkPhase = "make check";
}
