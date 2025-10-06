{
  pkgs,
  frostix,
  inputs,
  ...
}: {
  users.users.shomy.packages = with pkgs; [
    inputs.darkly.packages.x86_64-linux.darkly-qt5
    inputs.darkly.packages.x86_64-linux.darkly-qt6

    kdePackages.plasma-integration # Needed for some KDE apps to use Darkly correctly
    kdePackages.bluez-qt
    kdePackages.kde-gtk-config
    kdePackages.krfb # KDE Remote Desktop

    plasma-panel-colorizer
    kde-rounded-corners
    frostix.kde-plasma-control-hub

    # latte-dock # Wait for https://invent.kde.org/plasma/latte-dock/-/tree/work/plasma6 to be done
  ];

  programs.kdeconnect.enable = true;
}
