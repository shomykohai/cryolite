{
  pkgs,
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
    pkgs.ayugram-desktop
    frostix.lkpatcher
  ];
}
