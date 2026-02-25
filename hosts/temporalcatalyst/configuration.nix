# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  inputs,
  ...
}: {
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
    memoryPercent = 50; # 8GB
  };

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  nix.settings.substituters = ["https://cache.garnix.io" "https://attic.xuyh0120.win/lantian"];
  nix.settings.trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];

  system.desktopEnvironment = "KDE";
  docker.stregatto.enable = true;
  games.genshin-impact.enable = true;
  games.minecraft.enable = true;

  services.openssh = {
    enable = true;
  };
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;

  ## TODO: Put in a more secure place
  secrets.ageKeyPath = "/home/shomy/.config/sops/age/keys.txt";
}
