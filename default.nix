{pkgs ? import <nixpkgs> {}}:

rec {
  wallpaper = pkgs.callPackage ({
      runCommand, makeWrapper, lib,
      bash, jq, ffmpeg, imagemagick, mpc_cli, sway, procps, coreutils, gnugrep}:

    runCommand "musical-wallpapers" {} ''
      mkdir -p $out/bin/
      . ${makeWrapper}/nix-support/setup-hook
      makeWrapper ${./musical-wallpapers} $out/bin/musical-wallpapers --prefix PATH : ${lib.makeBinPath [bash jq ffmpeg imagemagick mpc_cli sway procps coreutils gnugrep]}
    ''
  ) {};

  unit = pkgs.callPackage ({pkgs}: pkgs.writeTextFile {
    name = "musical-wallpapers.service";
    text = ''
      [Unit]
      Description=Musical Wallpapers
      [Service]
      ExecStart=${wallpaper}/bin/musical-wallpapers
      [Install]
      WantedBy=graphical-session.target
    '';
  }) {};
}
