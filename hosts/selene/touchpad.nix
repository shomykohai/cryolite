{
  lib,
  config,
  ...
}:
lib.mkIf (config.system.desktopEnvironment == "KDE") {
  homix = {
    ".config/kcminputrc" = {
      text = ''
        [Libinput][1739][52934][SYNA801A:00 06CB:CEC6 Touchpad]
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
