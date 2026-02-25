{
  pkgs,
  frostix,
  ...
}: {
  imports = [
    ./zsh.nix
    ./ghostty.nix
    ./git.nix
    ./zen.nix
    ./spicetify.nix
    ./obs.nix
    ./syncthing.nix
    ./zed.nix
  ];

  users.users.shomy.packages = [
    pkgs.inkscape
    pkgs.ayugram-desktop
    frostix.lkpatcher
  ];
}
