{
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: {
  imports = [
    #./zsh.nix
    ./fish
    ./ghostty.nix
    ./git.nix
    ./zen.nix
    #./spicetify.nix
    ./obs.nix
    ./syncthing.nix
    ./zed
  ];

  users.users.shomy.packages = [
    pkgs.inkscape
    pkgsUnstable.ayugram-desktop
    frostix.lkpatcher
  ];
}
