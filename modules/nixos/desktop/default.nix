{
  config,
  lib,
  pkgsUnstable,
  pkgs,
  frostix,
  inputs,
  ...
}: let
  toLower = lib.strings.toLower;
  de = toLower (config.system.desktopEnvironment or "none");

  isKDE = de == "kde";
  isGnome = de == "gnome";

  # Hack to make the theme work.
  # Since frostix uses nixpkgs-unstable, we can't mix QT versions.
  # The solution is to override it so it pulls in the same QT version
  # as the system (stable).
  sddmSilentTheme = frostix.sddm-silent-theme.override {
    pkgs = pkgs;
  };
in {
  options.system.desktopEnvironment = lib.mkOption {
    type = lib.types.str;
    default = "none";
    description = ''
      The desktop environment to use. Supported values (case-insensitive): "KDE", "Gnome", "none".
    '';
  };

  config = lib.mkIf (de != "none") {
    services.xserver.enable = false;

    services.desktopManager.plasma6.enable = lib.mkDefault isKDE;
    services.desktopManager.gnome.enable = lib.mkDefault isGnome;
    # On unstable: or 25.11, uncomment this
    # services.desktopManager.gnome.enable = lib.mkDefault isGnome;

    services.displayManager.sddm = lib.mkIf isKDE {
      enable = true;
      wayland.enable = true;
      theme = "silent";
      extraPackages = [sddmSilentTheme];
      settings = {
        General = {
          GreeterEnvironment = "QML2_IMPORT_PATH=${sddmSilentTheme}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard";
          InputMethod = "qtvirtualkeyboard";
        };
      };
    };

    # Packages based on desktop environment
    environment.systemPackages =
      [
      ]
      ++ lib.optionals isKDE [
        frostix.rose-pine-moonlight-kde
        (pkgsUnstable.whitesur-icon-theme.override {
          alternativeIcons = true;
          boldPanelIcons = true;
        })
        pkgsUnstable.whitesur-kde
        pkgsUnstable.whitesur-cursors
        sddmSilentTheme

        (pkgsUnstable.darkly.override {
          qtPackages = pkgs.kdePackages;
        })
        pkgsUnstable.darkly-qt5
      ]
      ++ lib.optionals isGnome [
      ];

    services.displayManager.gdm.enable = lib.mkDefault isGnome;
  };
}
