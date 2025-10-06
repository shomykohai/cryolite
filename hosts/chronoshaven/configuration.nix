{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Import default configuration first
    ../../modules/nixos/default-configuration.nix
    ./hardware-configuration.nix
    ./touchpad.nix

    # Host specific packages
    ./packages.nix

    # Users
    ../../users/shomy
  ];

  networking.hostName = "chronoshaven";

  zramSwap = {
    memoryPercent = 1024 * 6; # 6GB
  };

  # nvidia drivers fail to build with a kernel newer than 6.12
  # so, force it back just for this host (I should get a better unit)
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
  system.desktopEnvironment = "KDE";

  ## TODO: Put in a more secure place
  secrets.ageKeyPath = "/home/shomy/.config/sops/age/keys.txt";
}
