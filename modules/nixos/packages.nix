{
  # config,
  # inputs,
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = builtins.attrValues {
    inherit
      (pkgs)
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
      # support 32-bit only
      wine
      # support 64-bit only
      wine64
      # winetricks (all versions)
      winetricks
      wineasio
      rar
      zip
      #TODO: USE UNSTABLE ONCE IT IS FIXED
      aseprite
      # Core System
      libsecret
      # seahorse
      # Utilities
      coreutils
      binutils
      usbutils
      hyfetch
      htop
      tree
      file
      wget
      jq
      ;

    # support both 32-bit and 64-bit applications
    inherit
      (pkgs.wineWowPackages)
      stable
      # wine-staging (version with experimental features)
      staging
      # native wayland support (unstable)
      waylandFull
      ;

    # support 64-bit only
    wine64Override = pkgs.wine.override {wineBuild = "wine64";};
    bottlesOverride = pkgs.bottles.override {
      removeWarningPopup = true;
    };
  };

  # Up to date packages
  unstablePackages = builtins.attrValues {
    inherit
      (pkgsUnstable)
      godot
      jdk8
      # Art
      #    aseprite
      # Notes
      obsidian
      ;

    inherit
      (frostix)
      github-desktop-plus
      mtkclient-git
      dexpatcher
      ;

    inherit
      (pkgsUnstable.python3Packages)
      pyserial
      ;
  };
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

    programs.git = {
      enable = true;
      lfs.enable = true;
    };

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    # Combine both lists for systemPackages
    environment.systemPackages = stablePackages ++ unstablePackages;
  }
