{
  pkgs,
  frostix,
  lib,
  config,
  ...
}: {
  options = {
    programs.thunderbird-ferroxide.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Ferroxide (Protonmail Bridge) and Thunderbird.";
    };
  };

  config = lib.mkIf config.programs.thunderbird-ferroxide.enable {
    imports = [
      ./ferroxide.nix
    ];

    users.users.shomy.packages = [
      pkgs.thunderbird
      frostix.ferroxide
    ];
  };
}
