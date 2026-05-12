{
  lib,
  config,
  ...
}: {
  imports = [
    ../../third-party/homix.nix

    ./programs
    ./ssh.nix

    ./kde
  ];

  users.users.shomy = {
    homix = true; # Enable homix
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/shomy";
    description = "Shomy";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "adbusers"
      "scanner"
      "lp"
      "libvirtd"
      "wireshark"
    ];

    useDefaultShell = true;
  };
}
