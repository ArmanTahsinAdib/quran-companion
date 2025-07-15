{
  description = "Flake for Quran Companion (Qt6/C++ project)";

  inputs = {    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
