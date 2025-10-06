{lib, ...}: {
  imports = [
    ./genshin.nix
    ./minecraft.nix
  ];

  games.genshin-impact.enable = lib.mkDefault false;
  games.minecraft.enable = lib.mkDefault false;
}
