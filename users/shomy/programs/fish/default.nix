{
  pkgs,
  config,
  ...
}: {
  programs.fish.enable = true;
  programs.pay-respects.enable = true;

  homix.".config/fish".symlink = "${config.system.flakePath}/users/shomy/programs/fish/config";
}
