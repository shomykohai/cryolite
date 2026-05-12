{
  pkgs,
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

  nix.settings.substituters = ["https://cache.garnix.io" "https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];

  system.desktopEnvironment = "KDE";

  services.openssh = {
    enable = true;
  };

  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages."x86_64-linux".linuxPackages-cachyos-latest-lto-x86_64-v3;
  secrets.ageKeyPath = "/persist/secrets/keys.txt";
}
