{ mylib }:
final: prev: {
  duckstation = final.callPackage (
    {
      qtScaleFactor ? null,
    }:
    final.appimageTools.wrapType2 rec {
      pname = "duckstation";
      version = "0.1-12083";
      src = final.fetchurl {
        url = "https://github.com/stenzek/duckstation/releases/download/v${version}/DuckStation-x64.AppImage";
        hash = "sha256-xebwRfaiQggvyvqfAtVq2JXiM7lCcoeI0jKtDAx2XCQ=";
      };
      profile = mylib.exportEnv {
        QT_SCALE_FACTOR = qtScaleFactor;
      };
      extraInstallCommands =
        let
          desktop = final.makeDesktopItem {
            name = pname;
            desktopName = "DuckStation";
            exec = "${pname} %f";
          };
        in
        ''
          mkdir -p $out/share/applications
          cp ${desktop}/share/applications/* $out/share/applications/
        '';
    }
  ) { };
}
