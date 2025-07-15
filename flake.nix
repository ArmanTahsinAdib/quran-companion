{
  description = "quran-companion flake (with qttools fix)";

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

          src = self;

          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            qt6.wrapQtAppsHook
            qt6.qttools   # <--- ✨ this is key: tools like lrelease & lupdate
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

          configurePhase = ''
            cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release
          '';

          buildPhase = ''
            ninja -C build
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/quran-companion $out/bin/
          '';
        };

        defaultPackage = self.packages.${system}.default;

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "quran-companion";
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            qt6.wrapQtAppsHook
            qt6.qttools
          ];
          buildInputs = with qt6; [
            qtbase
            qtimageformats
            qtsvg
            qtmultimedia
          ];
        };
      });
}
