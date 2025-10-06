{
  inputs,
  pkgs,
  lib,
  ...
}: let
  ## TODO: Find a way to ditch `with`
  extensions = with pkgs.vscode-marketplace; [
    redhat.java
    ms-python.python
    usernamehw.errorlens
    aaron-bond.better-comments
    beardedbear.beardedtheme
    github.copilot
    jnoortheen.nix-ide
    geequlim.godot-tools
    rust-lang.rust-analyzer
    # Nix packaged version is patched to work with nix's rust-analyzer binary
    # pkgs.vscode-extensions.rust-lang.rust-analyzer
  ];

  extensionLinks = builtins.listToAttrs (map (
      ext: {
        name = ".vscode-oss/extensions/${ext.pname}-${ext.version}";
        value = {
          source = "${ext}/share/vscode/extensions/${ext.pname}";
        };
      }
    )
    extensions);
in {
  nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

  # TODO: MAKE THIS LIKE home.packages
  users.users.shomy.packages = [
    pkgs.vscodium
    pkgs.alejandra
    pkgs.nixd
  ];

  homix =
    extensionLinks
    // {
      ".config/VSCodium/User/settings.json" = {
        text = ''
          {
            "editor.formatOnSave": true,
            "editor.insertSpaces": true,
            "editor.tabSize": 4,
            "workbench.colorTheme": "Bearded Theme OLED (Experimental)",
            "redhat.telemetry.enabled": false,
            "nix.enableLanguageServer": true,
            "nix.hiddenLanguageServerErrors": [
              "textDocument/definition"
            ],
            "nix.formatterPath": "alejandra",
            "nix.serverPath": "nixd",
            "nix.serverSettings": {
              "nixd": {
                "nixpkgs": {
                  "expr": "import (builtins.getFlake \"${toString ./../../..}\").inputs.nixpkgs { }"
                },
                "formatting": {
                  "command": ["alejandra"]
                },
                "options": {
                  "nixos": {
                    "expr": "(builtins.getFlake \"${toString ./../../..}\").nixosConfigurations.chronoshaven.options"
                  }
                }
              }
            },
            "rust-analyzer.server.path": "${pkgs.rust-analyzer}/bin/rust-analyzer"
          }
        '';
      };
    };
}
