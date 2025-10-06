{
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    games.genshin-impact.enable = lib.mkEnableOption "Install an anime game launcher";
  };

  imports = [inputs.aagl.nixosModules.default];

  config = lib.mkIf config.games.genshin-impact.enable {
    nix.settings = inputs.aagl.nixConfig; # Set up Cachix
    programs.anime-game-launcher.enable = true;

    networking.mihoyo-telemetry.block = lib.mkForce true;
    aagl.enableNixpkgsReleaseBranchCheck = false;
  };
}
