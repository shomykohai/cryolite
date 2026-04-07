{
  lib,
  config ? {},
}: let
  inherit (lib) mapAttrsToList concatStringsSep;

  valueToString = v:
    if builtins.isString v
    then v
    else if builtins.isBool v
    then
      (
        if v
        then "true"
        else "false"
      )
    else if builtins.isInt v
    then builtins.toString v
    else builtins.toString v;

  formatSection = name: values:
    if builtins.isAttrs values then
      concatStringsSep "\n\n" (
        mapAttrsToList (key: value:
          if builtins.isAttrs value then
            "[${name} \"${key}\"]\n"
            + concatStringsSep "\n"
              (mapAttrsToList (k: v: "  ${k} = ${valueToString v}") value)
          else
            "[${name}]\n"
            + concatStringsSep "\n"
              (mapAttrsToList (k: v: "  ${k} = ${valueToString v}") values)
        ) values
      )
    else
      throw "Invalid git config structure";
in
  concatStringsSep "\n\n" (mapAttrsToList formatSection config)
