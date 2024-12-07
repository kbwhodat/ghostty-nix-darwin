{ githubToken }: self: super:
{
  ghostty-darwin = super.stdenv.mkDerivation rec {
      pname = "Ghostty";
      version = "tip";

      buildInputs = [ super.unzip super.wget super.cacert ];
      sourceRoot = ".";

      phases = [ "unpackPhase" "installPhase" ];

      unpackPhase = ''
        runHook preUnpack

        export SSL_CERT_FILE="${super.cacert}/etc/ssl/certs/ca-certificates.crt"
        wget --header="Accept: application/octet-stream" --header="Authorization: Bearer ${githubToken}" --header="X-GitHub-Api-Version: 2022-11-28" -O ghostty.zip https://api.github.com/repos/ghostty-org/ghostty/releases/assets/211402665 --verbose

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
