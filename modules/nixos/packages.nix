{
  # config,
  # inputs,
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = with pkgs; [
    inkscape
    # Code editors related stuff

    # Development tools
    python3
    imhex

    # Various stuff
    vesktop
    ghostty
    # ayugram-desktop

    # kdePackages.qtstyleplugin-kvantum
    # kdePackages.qt6ct
    # System management
    btrfs-assistant

    # support both 32-bit and 64-bit applications
    wineWowPackages.stable
    # support 32-bit only
    wine
    # support 64-bit only
    (wine.override {wineBuild = "wine64";})
    # support 64-bit only
    wine64
    # wine-staging (version with experimental features)
    wineWowPackages.staging
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    wineasio
    (bottles.override
      {
        removeWarningPopup = true;
      })
    rar
    zip

    #TODO: USE UNSTABLE ONCE IT IS FIXED
    aseprite
    # Core System
    python3Packages.pyqt6 # For Reflake
    libsecret
    # seahorse
  ];

  # Up to date packages
  unstablePackages = with pkgsUnstable; [
    godot
    frostix.github-desktop-plus
    jdk8
    # Android development & research
    frostix.mtkclient-git
    python3Packages.pyserial
    frostix.dexpatcher

    # kdePackages.kcoreaddons
    # KDE Theme

    # Art
    #    aseprite

    # Notes
    obsidian
  ];
in
  # Define packages shared between hosts.
  # For hosts specific packages, change them inside the packages.nix inside the
  # corresponding directory.
  {
    # Assign unstable packages configuration
    # _module.args.pkgsUnstable = import inputs.nixpkgsUnstable {
    #   inherit (pkgs.stdenv.hostPlatform) system;
    #   inherit (config.nixpkgs) config;
    #   overlays = [
    #     inputs.nix-vscode-extensions.overlays.default
    #   ];
    #   # inherit (pkgs.overlays) overlays;
    # };

    # Needed for GTK apps menubar
    # chaotic.appmenu-gtk3-module.enable = true;
    # Needed by mtkclient since udev rules are following the adbusers group
    # Also, adb stuff and android tools
    programs.adb.enable = true;
    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
      package = pkgsUnstable.wireshark;
    };

    # Allow unfree packages

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    # Combine both lists for systemPackages
    environment.systemPackages = stablePackages ++ unstablePackages;
    # inputs.home.packages = homePackages ++ homeUnstablePackages;
  }
