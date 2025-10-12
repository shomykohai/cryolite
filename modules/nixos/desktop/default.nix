{
  config,
  lib,
  pkgsUnstable,
  ...
}: let
  toLower = lib.strings.toLower;
  de = toLower (config.system.desktopEnvironment or "none");

  isKDE = de == "kde";
  isGnome = de == "gnome";
in {
  options.system.desktopEnvironment = lib.mkOption {
    type = lib.types.str;
    default = "none";
    description = ''
      The desktop environment to use. Supported values (case-insensitive): "KDE", "Gnome", "none".
    '';
  };

  config = lib.mkIf (de != "none") {
    #nixpkgs.overlays = [
    #  (final: prev: {
    #    kdePackages = pkgsUnstable.kdePackages;
    #  })
    #];

    services.xserver.enable = false;

    services.desktopManager.plasma6.enable = lib.mkDefault isKDE;
    services.xserver.desktopManager.gnome.enable = lib.mkDefault isGnome;
    # On unstable: or 25.11, uncomment this
    # services.desktopManager.gnome.enable = lib.mkDefault isGnome;

    services.displayManager.sddm = lib.mkIf isKDE {
      enable = true;
      wayland.enable = true;
    };

    services.xserver.displayManager.gdm.enable = lib.mkDefault isGnome;
  };
}
