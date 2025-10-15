{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}: let
  zedExtraPackages = [];
  zedBasePackage = pkgsUnstable.zed-editor;

  zedPackage =
    if zedExtraPackages != []
    then
      pkgs.symlinkJoin {
        name = "zed-editor-wrapped";
        paths = [zedBasePackage];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/zeditor \
            --suffix PATH : ${lib.makeBinPath zedExtraPackages}
        '';
      }
    else zedBasePackage;
in {
  users.users.shomy.packages = [zedPackage];

  homix.".config/zed/settings.json" = {
    copy = true;
    text = ''
      {
        "icon_theme": "Colored Zed Icons Theme Light",
        "auto_install_extensions": {
          "nix": true,
          "python": true,
          "rust": true
        },
        "buffer_font_size": 11,

        "telemetry": {
          "diagnostics": false,
          "metrics": false
        },
        "disable_ai": false,
        "features": {
          "edit_prediction_provider": "copilot"
        },
        "theme": "Rosé Pine Moon",
        "ui_font_size": 16,
        "vim_mode": false,
        "auto_indent_on_paste": true,
        "auto_update": false,
        "base_keymap": "VSCode",
        "current_line_highlight": "all",
        "selection_highlight": true,
        "snippet_sort_order": "bottom",
        "scrollbar": {
          "show": "auto",
          "cursors": false,
          "axes": {
            "horizontal": false
          },
          "selected_symbol": true,
          "diagnostics": "all"
        },

        "minimap": {
          "show": "always",
          // Have to think about this
          "thumb": "hover"
        },

        "tab_bar": {
          "show_nav_history_buttons": false
        },

        "tabs": {
          "close_position": "right",
          "file_icons": true,
          "show_diagnostics": "errors",
          "activate_on_close": "left_neighbour"
        },

        "inline_code_actions": true,
        "drag_and_drop_selection": {
          "enabled": false // I hate you
        },

        "enable_language_server": true,

        "diagnostics": {
          "button": true,
          "include_warnings": true,
          "lsp_pull_diagnostics": {
            "enabled": true,
            "debounce_ms": 50
          },
          "inline": {
            "enabled": true,
            "update_debounce_ms": 150,
            "padding": 4,
            "min_column": 0,
            "max_severity": null
          }
        },

        // Spaces instead of tabs :D
        "hard_tabs": false,
        "title_bar": {
          "show_branch_icon": true,
          "show_branch_name": true,
          "show_project_items": true,
          "show_onboarding_banner": false,
          "show_user_picture": false,
          "show_sign_in": false,
          "show_menus": false
        },

        "project_panel": {
          "indent_size": 10,
          "hide_root": true,
          "scrollbar": { "show": "never" },
          "entry_spacing": "standard"
        },

        // LSP TIME
        "lsp": {
          "rust-analyzer": {
            "binary": {
              "path": "${pkgsUnstable.rust-analyzer}/bin/rust-analyzer"
            }
          },
          "nixd": {
            "settings": {
              "nixpkgs": {
                "expr": "import (builtins.getFlake \"/etc/cryolite/cryolite\").inputs.nixpkgs { }"
              },
              "options": {
                "expr": "import (builtins.getFlake \"/etc/cryolite/cryolite\").nixosConfigurations.chronoshaven.options"
              }
            }
          }
        },

        "languages": {
          "Nix": {
            "language_servers": ["nixd", "!nil"],
            "formatter": {
              "external": { "command": "alejandra", "arguments": ["--quiet", "--"] }
            }
          }
        }
      }
    '';
  };
}
