{lib, ...}: {
  imports = [
    ./stregatto.nix
  ];

  docker.stregatto.enable = lib.mkDefault false;
}
