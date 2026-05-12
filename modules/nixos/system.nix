## Defines the core system configuration for NixOS.
{
  pkgs,
  lib,
  config,
  ...
}: {
  options.system.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "/etc/nixos";
    description = "Path to the system flake";
  };

  config = {
    ## Auto update service
    system.autoUpgrade = {
      enable = true;
      persistent = true;
      dates = "*-*-01/3 09:30:00";
      flake = config.system.flakePath;
      flags = ["--override-input" "secrets-flake" "${config.system.flakePath}/secrets"];
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = config.system.flakePath;
    };

    nix = {
      package = pkgs.lixPackageSets.git.lix;
      optimise.automatic = true;
      gc.automatic = false;

      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";

      settings = {
        max-jobs = "auto";
        cores = 0;
        max-substitution-jobs = 32;
        eval-cache = true;
        auto-optimise-store = true;
        keep-going = true;
        builders-use-substitutes = true;
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];
        accept-flake-config = true;
        keep-outputs = true;
        keep-derivations = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operator" # I'm using lix. When using nix, it should be `pipe-operators`
        ];
        warn-dirty = false;
        commit-lockfile-summary = "flake: Update flake inputs";
      };

      extraOptions = ''
        http3 = true
        nar-buffer-size = 67108864
        fallback = true
        download-attempts = 2 # Annoying when cache fails!
        warn-import-from-derivation = true
      '';

      registry = {
        frostix = {
          from = {
            type = "indirect";
            id = "frostix";
          };
          to = {
            type = "github";
            owner = "shomykohai";
            repo = "frostix";
          };
        };
      };
    };

    systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;

    time.timeZone = "Europe/Rome";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };

    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
    environment.shells = [pkgs.fish];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = [
      pkgs.stdenv.cc.cc
      pkgs.glibc
      pkgs.libsecret
    ];

    console.keyMap = "it";
    keyboard.useCustomLayout = true;

    systemd.services.NetworkManager-wait-online.enable = false;
    documentation.man.enable = false;
    documentation.enable = false;

    system.stateVersion = "25.05";
  };
}
