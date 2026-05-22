{
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "nowatchdog"
  ];
}
