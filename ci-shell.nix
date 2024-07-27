{ githubToken, pkgs ? import <nixpkgs> { overlays = [ (import ./overlay.nix { inherit githubToken; } ) ]; } }:
pkgs.mkShell {
  packages = with pkgs; [
    ghostty-darwin
  ];
}
