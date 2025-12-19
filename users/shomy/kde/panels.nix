{lib, ...}: let
  mkPanels = import ./lib/mkPanels.nix {inherit lib;};

  panelConfig = mkPanels.mkPanels {
    startPanelId = 2519;
    panels = [
      {
        location = "top";
        height = 32;
        floating = false;
        opacity = "adaptive";

        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }

          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                showDate = false;
                enabledCalendarPlugins = ["astronomicalevents" "holidaysevents"];
              };
              ConfigDialog = {
                DialogHeight = 540;
                DialogWidth = 720;
              };
              PreloadWeight = 70;
              popupHeight = 450;
              popupWidth = 810;
            };
          }
        ];
      }
      # Dock
      {
        location = "bottom";
        height = 54;
        floating = true;
        opacity = "translucent";
        lengthMode = "fit";
        alignment = "center";
        hiding = "dodgewindows";

        widgets = [
          # Application list (can be found in /run/current-system/sw/share/applications/)
          {
            iconTasks = {
              launchers = [
                "applications:zen.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:com.mitchellh.ghostty.desktop"
                "applications:vesktop.desktop"
                "applications:codium.desktop"
                "applications:aseprite.desktop"
                "applications:com.ayugram.desktop.desktop"
                "applications:org.godotengine.Godot4.5.desktop"
                "applications:github-desktop-plus.desktop"
                "applications:obsidian.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.trash"
        ];
      }
    ];

    systemTrayItems = [
      "org.kde.plasma.weather"
    ];
  };

  panelConfigs = mkPanels.writeConfig panelConfig;
in {
  panelConfigs = panelConfigs;
}
