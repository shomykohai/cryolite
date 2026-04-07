{
  lib,
  config,
  ...
}: {
  # Default shared settings between hosts
  imports = [
    ./boot
    ./system.nix
    ./security.nix
    ./swap.nix
    ./hardware
    ./services
    ./desktop
    ./packages.nix
    ./secrets.nix

    ../containers/docker.nix
    ../games/default.nix

    ../../users/root
  ];

  environment.variables = {
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
  };
}
