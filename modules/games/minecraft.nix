{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    games.minecraft.enable = lib.mkEnableOption "Install minecraft launcher";
  };

  config = lib.mkIf config.games.minecraft.enable {
    environment.systemPackages = [
      pkgs.minecraft
    ];
  };
}
