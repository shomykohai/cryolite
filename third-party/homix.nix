# FROM sioodmy dotfiles, with some modifications https://github.com/sioodmy/dotfiles/blob/main/modules/homix/default.nix
# Simplest way to manage your home dir
# Copyright (C) <year> sioodmy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types filterAttrs attrValues mkIf mkDerivedConfig;

  inherit (builtins) map listToAttrs attrNames;
in {
  options = {
    homix = mkOption {
      default = {};
      type = types.attrsOf (types.submodule ({
        name,
        config,
        options,
        ...
      }: {
        options = {
          path = mkOption {
            type = types.str;
            description = ''
              Path to the file relative to the $HOME directory.
              If not defined, name of attribute set will be used.
            '';
          };
          source = mkOption {
            type = types.path;
            description = "Path of the source file or directory.";
          };
          text = mkOption {
            default = null;
            type = types.nullOr types.lines;
            description = "Text of the file.";
          };
          # If you're wondering what changed: I added this option since
          # KDE configs need to be writable
          copy = mkOption {
            type = types.bool;
            default = false;
            description = ''
              If true, copy the file into $HOME instead of symlinking it.
              Useful for files that need to be writable by the user or an app (like KDE configs)
            '';
          };
        };
        config = {
          path = lib.mkDefault name;
          source = mkIf (config.text != null) (
            let
              name' = "homix-" + lib.replaceStrings ["/"] ["-"] name;
            in
              mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }));
    };
    users.users = mkOption {
      type = types.attrsOf (types.submodule {
        options.homix = mkEnableOption "Enable homix for selected user";
      });
    };
  };

  config = let
    # list of users managed by homix
    users = attrNames (filterAttrs (name: user: user.homix) config.users.users);

    homix-link = let
      files = map (f: ''
        FILE=$HOME/${f.path}
        mkdir -p "$(dirname "$FILE")"
        ${
          if f.copy
          then ''
            cp ${f.source} "$FILE"
          ''
          else ''ln -sf ${f.source} "$FILE"''
        }
      '') (attrValues config.homix);
    in
      pkgs.writeShellScript "homix-link" ''
        #!/bin/sh
        ${builtins.concatStringsSep "\n" files}
      '';

    mkService = user: {
      name = "homix-${user}";
      value = {
        wantedBy = ["multi-user.target"];
        description = "Setup homix environment for ${user}.";
        serviceConfig = {
          Type = "oneshot";
          User = "${user}";
          ExecStart = "${homix-link}";
        };
        environment = {
          # epic systemd momento
          HOME = config.users.users.${user}.home;
        };
      };
    };

    services = listToAttrs (map mkService users);
  in {
    systemd.services = services;
  };
}
