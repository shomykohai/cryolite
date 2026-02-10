## Defines the core system configuration for NixOS.
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # options = {
  # };

  ## Auto update service
  system.autoUpgrade = {
    enable = true;
    persistent = true;
    dates = "*-*-01/3 09:30:00";
    flake = inputs.self.outPath;
  };

  services.reflake = lib.mkIf config.system.autoUpgrade.enable {
    enable = true;
    flakePath = "/home/shomy/.dotfiles/";
    showUiPrompt = false;
    updateInterval = 604800; # 1 week in seconds
  };

  nix = {
    package = pkgs.lix;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator" # I'm using lix. When using nix, it should be `pipe-operators`
    ];

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

  nixpkgs.config.allowUnfree = true;

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

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [pkgs.zsh];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    pkgs.stdenv.cc.cc
    pkgs.glibc
    pkgs.libsecret
  ];

  console.keyMap = "it2";
  keyboard.useCustomLayout = true;

  system.stateVersion = "25.05";
}
