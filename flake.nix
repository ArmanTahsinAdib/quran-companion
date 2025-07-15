{
  description = "Quran Companion AppImage wrapper";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      appimageUrl = "https://github.com/0xzer0x/quran-companion/releases/download/v1.3.2/Quran_Companion-1.3.2-x86_64.AppImage";
      appimageSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace with real sha256
    in
    {
      packages.${system}.quranCompanionAppImage = pkgs.stdenv.mkDerivation {
        pname = "quran-companion-appimage";
        version = "1.3.2";

        src = pkgs.fetchurl {
          url = appimageUrl;
          sha256 = appimageSha256;
        };

        buildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/quran-companion.AppImage
          chmod +x $out/bin/quran-companion.AppImage
          wrapProgram $out/bin/quran-companion.AppImage --set QT_QPA_PLATFORM xcb
          ln -s $out/bin/quran-companion.AppImage $out/bin/quran-companion
        '';

        meta = with pkgs.lib; {
          description = "Quran Companion AppImage launcher";
          homepage = "https://github.com/0xzer0x/quran-companion";
          license = licenses.mit; # adjust if needed
          maintainers = with maintainers; [ ];
          platforms = platforms.linux;
        };
      };

      defaultPackage.${system} = self.packages.${system}.quranCompanionAppImage;

      defaultApp.${system} = {
        type = "app";
        program = "${self.packages.${system}.quranCompanionAppImage}/bin/quran-companion";
      };
    };
}
