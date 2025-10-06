# Nix reimplementation of https://github.com/nix-community/plasma-manager/blob/trunk/script/write_config.py
# It's literally the same thing, so I guess I have to add this:
# SPDX-FileCopyrightText: 2022 Plasma Manager contributors
# SPDX-License-Identifier: MIT
{lib}: contents: let
  inherit
    (lib)
    concatStringsSep
    mapAttrsToList
    replaceStrings
    splitString
    sort
    lessThan
    ;

  escapeKey = k:
    replaceStrings [" " "[" "]"] ["\\s" "\\[" "\\]"] k;

  escapeValue = v:
    replaceStrings ["\n" "\t" "\r"] ["\\n" "\\t" "\\r"] (toString v);

  marking = attrs: let
    immutable = attrs.immutable or false;
    shellExpand = attrs.shellExpand or false;
  in
    if immutable && shellExpand
    then "[$ei]"
    else if immutable
    then "[$i]"
    else if shellExpand
    then "[$e]"
    else "";

  renderGroup = groupName: keyValues: let
    groupNameStr = concatStringsSep "." groupName;

    keys =
      mapAttrsToList (
        key: val:
          if !(builtins.isAttrs val)
          then throw "mkKConf: key '${key}' in group '${groupNameStr}' must be an attrset"
          else if !(val ? value)
          then throw "mkKConf: key '${key}' in group '${groupNameStr}' is missing 'value'"
          else let
            mark = marking val;
            escapedKey = escapeKey key + mark;
            valStr =
              if val.value == null
              then null
              else escapeValue val.value;
          in
            if valStr == null
            then escapedKey
            else "${escapedKey}=${valStr}"
      )
      keyValues;
  in
    "[${concatStringsSep "][" groupName}]\n" + concatStringsSep "\n" (sort lessThan keys);

  render = config: let
    groupList = mapAttrsToList (g: kv: renderGroup (splitString "/" g) kv) config;
  in
    concatStringsSep "\n\n" (sort lessThan groupList);
in
  render contents
