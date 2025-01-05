{ githubToken }: self: super:
{
  ghostty-darwin = super.stdenv.mkDerivation rec {
      pname = "Ghostty";
      version = "tip";

      buildInputs = [ super.unzip super.wget ];
      sourceRoot = ".";

      phases = [ "unpackPhase" "installPhase" ];

      unpackPhase = ''
        runHook preUnpack

        wget -O ghostty.zip "https://github.com/ghostty-org/ghostty/releases/download/${version}/ghostty-macos-universal.zip" --verbose --no-check-certificate

        unzip ghostty.zip -d "$sourceRoot"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r Ghostty.app "$out/Applications/"

        mkdir -p $out/bin
        ln -s ../Applications/Ghostty.app/Contents/MacOS/ghostty "$out/bin/ghostty"

        runHook postInstall
      '';

      meta = {
        description = "Ghostty is a cross-platform, GPU-accelerated terminal emulator.";
        homepage = "https://mitchellh.com/ghostty";
        license = super.lib.licenses.mit;
      };
    };
}
