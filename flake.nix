{
  description = "quran-companion flake (fork with Nix build)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        qt6 = pkgs.qt6;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "quran-companion";
          version = "unstable";

          src = self;  # because the flake.nix lives in your fork

        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          qt6.wrapQtAppsHook
          qt6.qttools  # add here
        ];

       buildInputs = with qt6; [
         qtbase
         qtimageformats
         qtsvg
         qtmultimedia
        ];


          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp quran-companion $out/bin/
          '';
        };

        defaultPackage = self.packages.${system}.default;

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "quran-companion";
        };
      });
}
