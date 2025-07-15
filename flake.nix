{
  description = "Flake for Quran Companion (Qt6/C++ project)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        qt = pkgs.qt6.full;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "quran-companion";
          version = "unstable";
          src = ./.;
          nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config qt ];
          buildInputs = [ qt ];
          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config qt ];
          buildInputs = [ qt ];
        };
      }
    );
}
