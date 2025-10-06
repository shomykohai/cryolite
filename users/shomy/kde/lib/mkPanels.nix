# Basically, readapted from Plasma Manager to keep my configuration I spent
# hours making
{lib}: let
  inherit
    (lib)
    range
    length
    mergeAttrs
    concatStringsSep
    ;

  locationToPosition = location:
    if location == "top"
    then 3
    else if location == "bottom"
    then 4
    else if location == "left"
    then 5
    else if location == "right"
    then 6
    else 4;

  mkPanels = {
    panels ? [],
    defaultScreen ? 0,
    startPanelId ? 2519,
    systemTrayItems ? [],
  }: let
    defaultSystemTrayItems =
      [
        "org.kde.plasma.cameraindicator"
        "org.kde.plasma.clipboard"
        "org.kde.plasma.devicenotifier"
        "org.kde.plasma.manage-inputmethod"
        "org.kde.plasma.notifications"
        "org.kde.kdeconnect"
        "org.kde.plasma.battery"
        "org.kde.plasma.bluetooth"
        "org.kde.plasma.brightness"
        "org.kde.plasma.keyboardindicator"
        "org.kde.plasma.keyboardlayout"
        "org.kde.plasma.networkmanagement"
        "org.kde.plasma.printmanager"
        "org.kde.plasma.mediacontroller"
        "org.kde.kscreen"
        "org.kde.plasma.volume"
      ]
      ++ systemTrayItems;

    # Did you know?
    # KDE for some obscure reason, decided it was a good idea splitting
    # the panel config in two different files:
    # ~ plasma-org.kde.plasma.desktop-appletsrc
    # ~ plasmashellrc

    processedPanels =
      builtins.foldl'
      (
        result: panel: let
          panelId = result.nextPanelId;
          appletId = result.nextAppletId;

          widgetsResult = processWidgets {
            inherit panelId defaultSystemTrayItems;
            widgets = panel.widgets or [];
            startAppletId = appletId;
          };

          location = panel.location or "bottom";
          panelConfig = {
            "Containments/${toString panelId}" = {
              activityId = {value = "";};
              formfactor = {
                value =
                  if (location == "top" || location == "bottom")
                  then 2
                  else 3;
              };
              immutability = {value = 1;};
              lastScreen = {value = panel.screen or defaultScreen;};
              location = {value = locationToPosition location;};
              plugin = {value = "org.kde.panel";};
              wallpaperplugin = {value = "org.kde.image";};
            };

            "Containments/${toString panelId}/General" = {
              AppletOrder = {value = concatStringsSep ";" (map toString widgetsResult.appletIds);};
            };
          };

          height = panel.height or 38;
          floating = panel.floating or false;
          hiding = panel.hiding or "none";
          hidingValue =
            if hiding == "autohide"
            then 1
            else if hiding == "dodgewindows"
            then 2
            else if hiding == "windowsgobelow"
            then 3
            else 0;

          lengthMode = panel.lengthMode or "fill";
          lengthModeValue =
            if lengthMode == "fit"
            then 1
            else 0;

          shellConfig = {
            "PlasmaViews/Panel ${toString panelId}" = {
              floating = {
                value =
                  if floating
                  then 1
                  else 0;
              };
              panelVisibility = {value = hidingValue;};
              panelLengthMode = {value = lengthModeValue;};
            };

            "PlasmaViews/Panel ${toString panelId}/Defaults" = {
              thickness = {value = height;};
            };
          };
        in {
          desktop = mergeAttrs result.desktop (mergeAttrs panelConfig widgetsResult.config);
          shell = mergeAttrs result.shell shellConfig;
          nextPanelId = panelId + 1;
          nextAppletId = widgetsResult.nextAppletId;
        }
      )
      {
        desktop = {};
        shell = {};
        nextPanelId = startPanelId;
        nextAppletId = startPanelId + 1;
      }
      panels;

    # This seemed important, so keep it ig
    baseDesktopConfig = {
      "ActionPlugins/1" = {
        "RightButton;NoModifier" = {value = "org.kde.contextmenu";};
      };
    };

    baseShellConfig = {
      "PlasmaTransientsConfig" = {
        PreloadWeight = {value = 0;};
      };
    };

    desktopConfig = mergeAttrs baseDesktopConfig processedPanels.desktop;
    shellConfig = mergeAttrs baseShellConfig processedPanels.shell;
  in {
    # Like, fr kde, why two files???
    "plasma-org.kde.plasma.desktop-appletsrc" = desktopConfig;
    "plasmashellrc" = shellConfig;
  };

  # It's applets/widgets time!!
  # Surely, this will be a easier, right?
  processWidgets = {
    panelId,
    widgets,
    startAppletId,
    defaultSystemTrayItems,
  }:
    builtins.foldl'
    (
      result: widget: let
        currentId = result.nextAppletId;

        # Plasma manager allows you to define widgets as
        # either a string or an attrset
        # Using strings is basically: "Im okay with the default configuration",
        # while attrsets is "Please configure me~"
        isSimpleWidget = builtins.isString widget;

        # PlasmaManager has some default widgets with simpler names
        # Perhaps I'll remove this part one day to make it faster
        # But I'd rather write this then change my previous configuration :3
        pluginName =
          if isSimpleWidget
          then widget
          else if widget ? name
          then widget.name
          else if builtins.hasAttr "kickoff" widget
          then "org.kde.plasma.kickoff"
          else if builtins.hasAttr "iconTasks" widget
          then "org.kde.plasma.icontasks"
          else "org.kde.plasma." + (builtins.head (builtins.attrNames widget));

        isSystemTray = pluginName == "org.kde.plasma.systemtray";
        isDigitalClock = pluginName == "org.kde.plasma.digitalclock";

        baseConfig = {
          "Containments/${toString panelId}/Applets/${toString currentId}" = {
            immutability = {value = 1;};
            plugin = {value = pluginName;};
          };

          "Containments/${toString panelId}/Applets/${toString currentId}/Configuration" = {
            PreloadWeight = {
              value =
                if isSystemTray
                then 100
                else 10;
            };
          };
        };

        specificConfig =
          if isSimpleWidget
          then {} # Again, simple widgets is literally just default
          # I let AI write this part because I was lazy and too burnt out to do it myself :3
          else if isSystemTray
          then let
            # System tray base config
            systemTrayBase = {
              "Containments/${toString panelId}/Applets/${toString currentId}" = {
                activityId = {value = "";};
                formfactor = {value = 0;};
                lastScreen = {value = -1;};
                location = {value = 0;};
                wallpaperplugin = {value = "org.kde.image";};
              };

              "Containments/${toString panelId}/Applets/${toString currentId}/Configuration" = {
                popupHeight = {value = 432;};
                popupWidth = {value = 432;};
              };

              "Containments/${toString panelId}/Applets/${toString currentId}/General" = {
                extraItems = {value = concatStringsSep "," defaultSystemTrayItems;};
                knownItems = {value = concatStringsSep "," defaultSystemTrayItems;};
              };
            };

            subConfigs =
              builtins.foldl'
              (
                subResult: idx: let
                  item = builtins.elemAt defaultSystemTrayItems idx;
                  subId = currentId + 1 + idx;

                  weight =
                    if
                      item
                      == "org.kde.plasma.devicenotifier"
                      || item == "org.kde.plasma.notifications"
                      || item == "org.kde.plasma.volume"
                      || item == "org.kde.plasma.networkmanagement"
                    then 55
                    else 10;

                  itemConfig = {
                    "Containments/${toString panelId}/Applets/${toString currentId}/Applets/${toString subId}" = {
                      immutability = {value = 1;};
                      plugin = {value = item;};
                    };

                    "Containments/${toString panelId}/Applets/${toString currentId}/Applets/${toString subId}/Configuration" = {
                      PreloadWeight = {value = weight;};
                    };
                  };
                in
                  mergeAttrs subResult itemConfig
              )
              {}
              (range 0 (length defaultSystemTrayItems - 1));
          in
            mergeAttrs systemTrayBase subConfigs
          else if isDigitalClock
          then
            # Special handling for digital clock with nested config
            let
              cfg =
                if widget ? config
                then widget.config
                else {};

              # Extract specific configs or use defaults
              popupHeight =
                if cfg ? popupHeight
                then cfg.popupHeight
                else 450;
              popupWidth =
                if cfg ? popupWidth
                then cfg.popupWidth
                else 810;

              # Extract Appearance configs
              appearance =
                if cfg ? Appearance
                then cfg.Appearance
                else {};
              showDate =
                if appearance ? showDate
                then appearance.showDate
                else false;
              enabledCalendarPlugins =
                if appearance ? enabledCalendarPlugins
                then appearance.enabledCalendarPlugins
                else ["astronomicalevents" "holidaysevents"];

              # Extract ConfigDialog configs
              configDialog =
                if cfg ? ConfigDialog
                then cfg.ConfigDialog
                else {};
              dialogHeight =
                if configDialog ? DialogHeight
                then configDialog.DialogHeight
                else 540;
              dialogWidth =
                if configDialog ? DialogWidth
                then configDialog.DialogWidth
                else 720;
            in {
              "Containments/${toString panelId}/Applets/${toString currentId}/Configuration" = {
                PreloadWeight = {value = 75;};
                popupHeight = {value = popupHeight;};
                popupWidth = {value = popupWidth;};
              };

              "Containments/${toString panelId}/Applets/${toString currentId}/Configuration/Appearance" = {
                showDate = {value = showDate;};
                enabledCalendarPlugins = {value = concatStringsSep "," enabledCalendarPlugins;};
              };

              "Containments/${toString panelId}/Applets/${toString currentId}/Configuration/ConfigDialog" = {
                DialogHeight = {value = dialogHeight;};
                DialogWidth = {value = dialogWidth;};
              };
            }
          else if widget ? config
          then
            # For widgets with flat config attribute
            let
              makeConfigEntry = key: value: {
                "Containments/${toString panelId}/Applets/${toString currentId}/Configuration/${key}" = {
                  value = value;
                };
              };

              configEntries =
                builtins.mapAttrs (
                  key: value:
                    if builtins.isAttrs value && !(key == "Appearance" || key == "ConfigDialog")
                    then throw "Nested config not supported for key '${key}', use flat structure"
                    else value
                )
                widget.config;

              configAttrs = builtins.mapAttrs makeConfigEntry configEntries;
              mergedConfig = builtins.foldl' mergeAttrs {} (builtins.attrValues configAttrs);
            in
              mergedConfig
          else if builtins.hasAttr "kickoff" widget
          then let
            cfg = widget.kickoff;
          in {
            "Containments/${toString panelId}/Applets/${toString currentId}/Configuration" = {
              PreloadWeight = {value = 100;};
              popupHeight = {value = cfg.popupHeight or 516;};
              popupWidth = {value = cfg.popupWidth or 655;};
            };

            "Containments/${toString panelId}/Applets/${toString currentId}/Configuration/General" = {
              alphaSort = {value = cfg.sortAlphabetically or true;};
              favoritesPortedToKAstats = {value = true;};
              icon = {value = cfg.icon or "start-here-kde";};
            };
          }
          else if builtins.hasAttr "iconTasks" widget
          then let
            cfg = widget.iconTasks;
          in {
            "Containments/${toString panelId}/Applets/${toString currentId}/Configuration/General" = {
              launchers = {value = concatStringsSep "," cfg.launchers;};
              forceStripes = {value = false;};
              unhideOnAttention = {
                value =
                  if builtins.hasAttr "behavior" cfg && builtins.hasAttr "unhideOnAttentionNeeded" cfg.behavior
                  then
                    if cfg.behavior.unhideOnAttentionNeeded == true
                    then true
                    else false
                  else false;
              };
            };
          }
          else {};

        finalConfig = mergeAttrs baseConfig specificConfig;

        nextAppletId =
          if isSystemTray
          then currentId + 1 + length defaultSystemTrayItems
          else currentId + 1;
      in {
        config = mergeAttrs result.config finalConfig;
        appletIds = result.appletIds ++ [currentId];
        nextAppletId = nextAppletId;
      }
    )
    {
      config = {};
      appletIds = [];
      nextAppletId = startAppletId;
    }
    widgets;

  writeConfig = panelConfig:
    lib.mapAttrs (file: config: mkKConf config) panelConfig;

  mkKConf = import ./mkKConf.nix {inherit lib;};
in {
  inherit mkPanels writeConfig;
}
