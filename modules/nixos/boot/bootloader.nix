{lib, ...}: {
  boot.loader.limine = {
    enable = true;
    maxGenerations = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.initrd.verbose = false;

  systemd = {
    network.wait-online.enable = lib.mkDefault false;
  };
}
