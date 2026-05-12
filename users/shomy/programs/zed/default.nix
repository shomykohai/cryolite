{
  lib,
  pkgs,
  pkgsUnstable,
  config,
  ...
}: let
  zedExtraPackages = [
    pkgs.nixd
    pkgs.alejandra
  ];
  zedBasePackage = pkgsUnstable.zed-editor;

  zedPackage =
    if zedExtraPackages != []
    then
      pkgs.symlinkJoin {
        name = "zed-editor-wrapped";
        paths = [zedBasePackage];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/zeditor \
            --suffix PATH : ${lib.makeBinPath zedExtraPackages}
        '';
      }
    else zedBasePackage;
in {
  users.users.shomy.packages = [zedPackage];

  homix.".config/zed/settings.json" = {
    copy = true;
    text =
      builtins.replaceStrings
      ["@rust-analyzer@" "@flake-path@"]
      ["${pkgsUnstable.rust-analyzer}" "${config.system.flakePath}"]
      (builtins.readFile ./settings.json);
  };
}
