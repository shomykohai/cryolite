{
  lib,
  config,
  pkgs,
  ...
}: let
  customLayout = pkgs.writeText "it-ext" ''

    xkb_symbols "it-ext" {
      include "it(basic)"

      name[Group1] = "Italian (Extended)";

      // Make Z act like < and X like > without needing to press Shift
      key <AB01>	{ [         z,          Z, less, guillemotleft ]	};
      key <AB02>	{ [         x,          X, greater, guillemotright ]	};

    };
  '';
in {
  options = {
    keyboard.useCustomLayout = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable custom keyboard layout";
    };
  };

  config = {
    services.xserver.xkb = {
      layout =
        if config.keyboard.useCustomLayout
        then "it-ext"
        else "it";

      variant = "";

      extraLayouts =
        if config.keyboard.useCustomLayout
        then {
          it-ext = {
            description = "Italian (Extended)";
            languages = ["it"];
            symbolsFile = customLayout;
          };
        }
        else {};
    };
  };
}
