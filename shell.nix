let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  shake_dhall = pkgs.lib.overrideDerivation pkgs.haskellPackages.shake-dhall
    (
      drv: {
        doCheck = false;
      }
    );
in
  with pkgs;
  mkShell {
    buildInputs = [
      gitAndTools.pre-commit
      cacert
      niv
      dhall
      fd
      gnumake
      (haskellPackages.ghcWithPackages (p: with p; [ shake dhall shake_dhall ]))
    ];
  }
