{ githubToken }: self: super:
{
  ghostty-darwin = super.stdenv.mkDerivation rec {
      pname = "Ghostty";
      version = "tip";

      buildInputs = [ super.unzip super.curl ];
      sourceRoot = ".";

      phases = [ "unpackPhase" "installPhase" ];

      unpackPhase = ''
        runHook preUnpack

        curl -L -H "Accept: application/octet-stream" \
             -H "Authorization: Bearer ${githubToken}" \
             -H "X-GitHub-Api-Version: 2022-11-28" \
             https://api.github.com/repos/ghostty-org/ghostty/releases/assets/211402665 \
             --output ghostty.zip -kv

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
