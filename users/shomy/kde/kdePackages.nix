{
  pkgs,
  pkgsUnstable,
  frostix,
  inputs,
  ...
}: {
  users.users.shomy.packages = builtins.attrValues {
    inherit
      (pkgs.kdePackages)
      plasma-integration # Needed for some KDE apps to use Darkly correctly
      bluez-qt
      kde-gtk-config
      krfb # KDE Remote Desktop
      ;

    inherit
      (pkgs)
      plasma-panel-colorizer
      kde-rounded-corners
      ;

    inherit
      (frostix)
      kde-plasma-control-hub
      ;
  };

  programs.kdeconnect.enable = true;
}
