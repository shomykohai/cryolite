{
  lib,
  config,
  ...
}:
lib.mkIf (config.system.desktopEnvironment == "KDE") {
  homix = {
    ".config/kcinputrc" = {
      text = ''
        [Libinput][1267][5][Elan Touchpad]
        DisableWhileTyping=true
        Enabled=true
        LeftHanded=false
        MiddleButtonEmulation=true
        NaturalScroll=true
        PointerAcceleration=0
        TapToClick=true
      '';
      copy = true;
    };
  };
}
