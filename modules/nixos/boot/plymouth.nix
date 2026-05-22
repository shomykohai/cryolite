{pkgs, ...}: {
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
    themePackages = [
      pkgs.nixos-bgrt-plymouth
    ];
  };
}
