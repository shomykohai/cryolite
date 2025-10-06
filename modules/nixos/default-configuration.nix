# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  config,
  ...
}: {
  # options.system.users = lib.mkOption {
  #   type = lib.types.listOf lib.types.str;
  #   default = [];
  #   description = "List of usernames to configure.";
  # };

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
  ];

  environment.variables = {
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
  };
}
