{...}: {
  imports = [
    ../../third-party/homix.nix
    ./kde/kde.nix

    ./programs
  ];
  users.users.shomy = {
    homix = true; # Enable homix
    isNormalUser = true;
    description = "Shomy";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "adbusers"
      "scanner"
      "lp"
    ];

    useDefaultShell = true;
  };
}
