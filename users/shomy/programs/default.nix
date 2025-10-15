{
  pkgs,
  frostix,
  ...
}: {
  imports = [
    ./zsh.nix
    ./codium.nix
    ./ghostty.nix
    ./git.nix
    ./zen.nix
    ./spicetify.nix
    ./obs.nix
    ./syncthing.nix
    ./thunderbird
    ./zed.nix
  ];

  users.users.shomy.packages = [
    pkgs.inkscape
    pkgs.ayugram-desktop
    frostix.lkpatcher
  ];
}
