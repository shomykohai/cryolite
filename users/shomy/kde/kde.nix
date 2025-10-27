{
  lib,
  config,
  ...
}: let
  # Import panels.nix and access the panelConfigs attribute
  panels = import ./panels.nix {inherit lib;};
in {
  imports = [
    # ./kde-connect.nix
    ./kdePackages.nix
  ];

  # Don't enable QT, otherwise some KDE settings (such as the settings) won't
  # integrate well with the theme.
  environment.variables = {
    QT_STYLE_OVERRIDE = "darkly";
    QT_QPA_PLATFORMTHEME = "qtct";
  };

  homix = lib.mkIf (config.system.desktopEnvironment == "KDE") {
    ".config/plasma-org.kde.plasma.desktop-appletsrc" = {
      text = ''
        ${panels.panelConfigs."plasma-org.kde.plasma.desktop-appletsrc"}
      '';
      copy = true; # Copy instead of symlinking
    };

    ".config/plasmashellrc" = {
      text = ''
        ${panels.panelConfigs.plasmashellrc}
      '';
      copy = true;
    };

    ".config/kwinrc" = {
      text = ''
        [NightColor]
        Active=true
        DayTemperature=6500
        Mode=Constant
        NightTemperature=3500
        TransitionTime=1000

        [Plugins]
        translucencyEnabled=true
        wobblywindowsEnabled=true
        kwin4_effect_shapecornersEnabled=true
        screenedgeEnabled=false

        [Round-Corners]
        InactiveOutlineThickness=0
        InactiveSecondOutlineThickness=0
        OutlineThickness=0
        SecondOutlineThickness=0

        [org.kde.kdecoration2]
        library[$i]=org.kde.darkly
        theme[$i]=Darkly
      '';
      copy = true;
    };

    ".config/plasmarc" = {
      text = ''
        [Theme]
        name=rose-pine-moonlight
      '';
      copy = true;
    };

    ".config/kdeglobals" = {
      text = ''
        [General]
        ColorScheme[$i]=RosPineMoonlight

        [Icons]
        Theme[$i]=WhiteSur-dark

        [KDE]
        widgetStyle[$i]=Darkly

      '';
      copy = true;
    };

    # Ensure that Alt+Tab works as expected, since it broke lol
    ".config/kglobalshortcutsrc" = {
      text = ''
        [kwin]
        Walk Through Windows=Alt+Tab,Alt+Tab,Walk Through Windows
        Walk Through Windows (Reverse)=Alt+Shift+Tab,Alt+Shift+Tab,Walk Through Windows (Reverse)
      '';
      copy = true;
    };
  };
}
