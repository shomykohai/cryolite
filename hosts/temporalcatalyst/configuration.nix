# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{...}: {
  imports = [
    # Import default configuration first
    ../../modules/nixos/default-configuration.nix
    ./hardware-configuration.nix

    # Host specific packages
    ./packages.nix

    # Users
    ../../users/shomy
  ];

  networking.hostName = "temporalcatalyst";

  zramSwap = {
    memoryPercent = 1024 * 8; # 8GB
  };

  system.desktopEnvironment = "KDE";
  docker.stregatto.enable = true;
  games.genshin-impact.enable = true;

  ## TODO: Put in a more secure place
  secrets.ageKeyPath = "/home/shomy/.config/sops/age/keys.txt";
}
