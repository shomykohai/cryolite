{
  pkgs,
  pkgsUnstable,
  inputs,
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

  networking.hostName = "selene";

  system.flakePath = "/etc/cryolite/cryolite";

  zramSwap = {
    memoryPercent = 50;
  };

  system.desktopEnvironment = "KDE";

  services.openssh = {
    enable = true;
  };

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  # SDDM hangs for ~20 seconds without this, because of fprint timing out.
  # Since I don't wnat fingerprint login to begin with, just disable it :D!
  security.pam.services.login.fprintAuth = false;

  games.minecraft.enable = true;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  secrets.ageKeyPath = "/persist/secrets/keys.txt";
}
