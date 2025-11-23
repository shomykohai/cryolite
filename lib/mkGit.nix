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
    "[${name}]\n"
    + (
      concatStringsSep "\n"
      (mapAttrsToList (key: value: "  ${key} = ${valueToString value}") values)
    );
in
  concatStringsSep "\n\n" (mapAttrsToList formatSection config)
