self: super:
{
  ghosttyPackage = edition:
    super.stdenv.mkDerivation rec {
      pname = "Ghostty";
  
      buildInputs = [ super.pkgs.unzip ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
  
      unpackPhase = ''
        runHook preUnpack
        unzip  "$src" -d "$sourceRoot"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall
    
        mkdir -p $out/Applications
        cp -r Ghostty.app "$out/Applications/"
    
        runHook postInstall
      '';

# If this doesn't work this, it because you do not have access to the repo
      src = super.fetchurl {
        url = "https://api.github.com/repos/ghostty-org/ghostty/releases/assets/181797263";
        sha256 = super.lib.fake256Sha; 
        headers = [
          "Accept: application/octet-stream"
            (builtins.concatStringsSep " " ["Authorization: Bearer" (builtins.getEnv "GITHUB_TOKEN")])
            "X-GitHub-Api-Version: 2022-11-28"
        ];
      };
  
      meta = {
        description = "Ghostty is a cross-platform, GPU-accelerated terminal emulator.";
        homepage = "https://mitchellh.com/ghostty";
      };
    };

}
