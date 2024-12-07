{ githubToken }: self: super:
{
  ghostty-darwin = super.stdenv.mkDerivation rec {
    pname = "Ghostty";
    version = "tip";

    buildInputs = [ super.unzip super.cacert ];
    sourceRoot = ".";

    phases = [ "unpackPhase" "installPhase" ];

    # Define the source using fetchurl with browser_download_url
    src = super.fetchurl {
      url = "https://api.github.com/repos/ghostty-org/ghostty/releases/assets/211402665";
      sha256 = "0000000000000000000000000000000000000000000000000000";
      headers = [
        "Accept: application/octet-stream"
        "Authorization: Bearer ${githubToken}"
        "X-GitHub-Api-Version: 2022-11-28"
      ];
    };

    unpackPhase = ''
      runHook preUnpack

      unzip $src -d "$sourceRoot"
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
      platforms = super.lib.platforms.darwin;
    };
  };
}
